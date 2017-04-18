CREATE OR REPLACE PACKAGE BODY CPI.GIUW_POL_DIST_FINAL_PKG AS

/**
**  Created by:     Veronica V. Raymundo
**  Date Created:   July 13, 2011
**  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
**  Description:    Compares the tsi, premium and annualized amounts 
**                  from the gipi_item tables against the corresponding 
**                  amounts from the gipi_itmperil table
**/

    PROCEDURE COMP_GIPI_ITEM_ITMPERIL_GWS010 
    (p_policy_id         IN       GIPI_POLBASIC.policy_id%TYPE,
     p_pack_pol_flag     IN       GIPI_POLBASIC.pack_pol_flag%TYPE,
     p_line_cd           IN       GIPI_POLBASIC.line_cd%TYPE,
     p_message           OUT      VARCHAR2)
     
     IS
     
        v_tsi_amt               NUMBER(16,2);
        v_prem_amt              NUMBER(12,2);
        v_ann_tsi_amt           NUMBER(16,2);
        v2_tsi_amt              NUMBER(16,2);
        v2_prem_amt             NUMBER(12,2);
        v2_ann_tsi_amt          NUMBER(16,2);
        v3_tsi_amt              NUMBER(16,2);
        v3_prem_amt             NUMBER(12,2);
        v3_ann_tsi_amt          NUMBER(16,2); 
        v4_tsi_amt              NUMBER(16,2);
        v4_prem_amt             NUMBER(12,2);
        v4_ann_tsi_amt          NUMBER(16,2);
        v_exist                 VARCHAR2(1) := 'N';
        v_message               VARCHAR(100) := 'SUCCESS';
        
    BEGIN
       
      IF NVL(p_pack_pol_flag, 'N') = 'N' THEN

         BEGIN
           SELECT SUM(tsi_amt),
                  SUM(prem_amt),
                  SUM(ann_tsi_amt)
             INTO v_tsi_amt,
                  v_prem_amt,
                  v_ann_tsi_amt
             FROM GIPI_ITEM
            WHERE policy_id = p_policy_id;

           SELECT SUM(prem_amt)
             INTO v2_prem_amt
             FROM GIPI_ITMPERIL
            WHERE policy_id = p_policy_id;

           SELECT SUM(a.tsi_amt),
                  SUM(a.ann_tsi_amt)
             INTO v2_tsi_amt,
                  v2_ann_tsi_amt
             FROM GIPI_ITMPERIL a
            WHERE EXISTS
                 (SELECT 1
                    FROM GIIS_PERIL b
                   WHERE b.peril_type = 'B'
                     AND b.peril_cd   = a.peril_cd
                     AND b.line_cd    = p_line_cd)
              AND a.policy_id = p_policy_id;

           IF v_tsi_amt <> v2_tsi_amt THEN
              v_message := 'The total sum insured in gipi_item and gipi_itmperil does not tally.'||
                           ' Please call your database administrator.';
           ELSIF v_prem_amt <> v2_prem_amt THEN
              v_message :='The premium amounts in gipi_item and gipi_itmperil does not tally.'||
                          ' Please call your database administrator.';
           END IF;

         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             v_message := 'There are no records retrieved from gipi_item '||
                          'and gipi_itmperil for policy_id '||TO_CHAR(p_policy_id)||
                          '. Please call your database administrator.';
           WHEN OTHERS THEN
             v_message := 'Other exceptions';
         END;
      ELSE
         BEGIN
           v_exist := 'N';
           FOR c1 IN (  SELECT SUM(tsi_amt)     tsi_amt     ,
                               SUM(prem_amt)    prem_amt    ,
                               SUM(ann_tsi_amt) ann_tsi_amt ,
                               pack_line_cd
                          FROM GIPI_ITEM
                         WHERE policy_id = p_policy_id
                      GROUP BY pack_line_cd)
           LOOP
             v_tsi_amt     := c1.tsi_amt;
             v_prem_amt    := c1.prem_amt; 
             v_ann_tsi_amt := c1.ann_tsi_amt;
             FOR c2 IN (SELECT  SUM(a.tsi_amt)     tsi_amt,
                                SUM(a.ann_tsi_amt) ann_tsi_amt
                          FROM  GIPI_ITMPERIL a, GIPI_ITEM b
                         WHERE  EXISTS
                               (SELECT 1
                                  FROM GIIS_PERIL c
                                 WHERE c.peril_type = 'B'
                                   AND c.peril_cd   = a.peril_cd
                                   AND c.line_cd    = c1.pack_line_cd)
                           AND  a.item_no      = b.item_no
                           AND  a.policy_id    = b.policy_id
                           AND  b.pack_line_cd = c1.pack_line_cd 
                           AND  a.policy_id    = p_policy_id)
             LOOP
               v_exist := 'Y';
               v2_tsi_amt     := c2.tsi_amt;
               v2_ann_tsi_amt := c2.ann_tsi_amt;
               EXIT;
             END LOOP;
             IF v_exist = 'N' THEN
                EXIT;
             END IF;
             v3_tsi_amt     := NVL(v3_tsi_amt, 0)     + NVL(v_tsi_amt, 0);
             v3_prem_amt    := NVL(v3_prem_amt, 0)    + NVL(v_prem_amt, 0);
             v3_ann_tsi_amt := NVL(v3_ann_tsi_amt, 0) + v_ann_tsi_amt;
             v4_tsi_amt     := NVL(v4_tsi_amt, 0)     + v2_tsi_amt;
             v4_ann_tsi_amt := NVL(v4_ann_tsi_amt, 0) + v2_ann_tsi_amt;
           END LOOP;
           IF v_exist = 'N' THEN
              RAISE NO_DATA_FOUND;
           END IF;
           v_exist := 'N';
           FOR c1 IN (SELECT SUM(prem_amt) prem_amt
                        FROM GIPI_ITMPERIL
                       WHERE policy_id = p_policy_id)
           LOOP
             v_exist := 'Y';
             v4_prem_amt := c1.prem_amt;
             EXIT;
           END LOOP;
           IF v_exist = 'N' THEN
              RAISE NO_DATA_FOUND;
           END IF;
           IF v3_tsi_amt <> v4_tsi_amt THEN
              v_message := 'The total sum insured in gipi_item and gipi_itmperil does not tally.'||
                           ' Please call your database administrator.';
           ELSIF v3_prem_amt <> v4_prem_amt THEN
              v_message := 'The premium amounts in gipi_item and gipi_itmperil does not tally.'||
                           ' Please call your database administrator.';
           END IF;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             v_message := 'There are no records retrieved from gipi_item '||
                          'and gipi_itmperil for policy_id '||TO_CHAR(p_policy_id)||
                          '. Please call your database administrator.';
           WHEN OTHERS THEN
             v_message := 'Other exceptions';
         END;
      END IF;
        p_message := v_message;
    END;


/**
**  Created by:     Veronica V. Raymundo
**  Date Created:   July 13, 2011
**  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
**  Description:    CREATE_GRP_DFLT_WPOLICYDS Program Unit from GIUWS010
**/
     PROCEDURE CRTE_GRP_DFLT_WPOLICYDS_GWS010
         (p_dist_no        IN   GIUW_WPOLICYDS_DTL.dist_no%TYPE      ,
          p_dist_seq_no    IN   GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE  ,
          p_line_cd        IN   GIUW_WPOLICYDS_DTL.line_cd%TYPE      ,
          p_dist_tsi       IN   GIUW_WPOLICYDS_DTL.dist_tsi%TYPE     ,
          p_dist_prem      IN   GIUW_WPOLICYDS_DTL.dist_prem%TYPE    ,
          p_ann_dist_tsi   IN   GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE ,
          p_rg_count       IN   OUT NUMBER                           ,
          p_default_type   IN   GIIS_DEFAULT_DIST.default_type%TYPE  ,
          p_currency_rt    IN   GIPI_ITEM.currency_rt%TYPE          ,
          p_policy_id      IN   GIPI_POLBASIC.policy_id%TYPE         ,
          p_item_grp       IN   GIPI_ITEM.item_grp%TYPE,
          p_v_default_no   IN   GIIS_DEFAULT_DIST.default_no%TYPE) IS

          --rg_id                RECORDGROUP;
          rg_name               VARCHAR2(20) := 'DFLT_DIST_VALUES';
          rg_col1               VARCHAR2(40) := rg_name || '.line_cd';
          rg_col2               VARCHAR2(40) := rg_name || '.share_cd';
          rg_col3               VARCHAR2(40) := rg_name || '.share_pct';
          rg_col4               VARCHAR2(40) := rg_name || '.share_amt1';
          rg_col5               VARCHAR2(40) := rg_name || '.peril_cd';
          rg_col6               VARCHAR2(40) := rg_name || '.share_amt2';
          rg_col7               VARCHAR2(40) := rg_name || '.true_pct';
          v_remaining_tsi       NUMBER       := p_dist_tsi * p_currency_rt;
          v_share_amt           GIIS_DEFAULT_DIST_GROUP.share_amt1%TYPE;
          v_peril_cd            GIIS_DEFAULT_DIST_GROUP.peril_cd%TYPE;
          v_prev_peril_cd       GIIS_DEFAULT_DIST_GROUP.peril_cd%TYPE;
          v_dist_spct           GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
          v_dist_tsi            GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
          v_dist_prem           GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
          v_ann_dist_tsi        GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
          v_sum_dist_tsi        GIUW_WPOLICYDS_DTL.dist_tsi%TYPE     := 0;
          v_sum_dist_spct       GIUW_WPOLICYDS_DTL.dist_spct%TYPE    := 0;
          v_sum_dist_prem       GIUW_WPOLICYDS_DTL.dist_prem%TYPE    := 0;
          v_sum_ann_dist_tsi    GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE := 0;
          v_share_cd            GIIS_DIST_SHARE.share_cd%TYPE;
          v_use_share_amt2      VARCHAR2(1) := 'N';
          v_dist_spct_limit     NUMBER;
          v_pol_flag               GIPI_POLBASIC_POL_DIST_V1.POL_FLAG%type; -- shan 07.29.2014
          v_par_type               GIPI_POLBASIC_POL_DIST_V1.PAR_TYPE%type; -- shan 07.29.2014
          v_policy_id              GIPI_POLBASIC_POL_DIST_V1.POLICY_ID%type; -- shan 07.29.2014
          v_dflt_policy_exists     BOOLEAN := FALSE;    -- shan 07.29.2014
          v_dist_spct1          giuw_wpolicyds_dtl.DIST_SPCT1%type; -- shan 07.29.204
          v_par_id              GIPI_POLBASIC_POL_DIST_V1.PAR_ID%type;  -- shan 07.29.2014
          v_dist_seq_no         giuw_wpolicyds_dtl.dist_seq_no%TYPE;--edgar 09/08/2014
          v_dist_spct1_chk      BOOLEAN := FALSE;--edgar 09/12/2014
      
      PROCEDURE INSERT_TO_WPOLICYDS_DTL IS
      BEGIN
        IF v_dist_spct1_chk THEN/*added edgar 09/12/2014*/
            v_dist_spct1 := v_dist_spct;
        END IF;/*ended edgar 09/12/2014*/        
        INSERT INTO  GIUW_WPOLICYDS_DTL
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp,   dist_spct1)    -- added dist_spct1 : shan 07.29.2014
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1, v_dist_spct1); -- added dist_spct1 : shan 07.29.2014
      END;

      -- shan 07.29.2014
      PROCEDURE insert_dflt_values
      IS
      BEGIN      
          IF p_rg_count = 0 THEN 

             /* Create the default distribution records based on the 100%
             ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
              v_share_cd     := 1;
             v_dist_spct    := 100;
             v_dist_tsi     := p_dist_tsi;
             v_dist_prem    := p_dist_prem;
             v_ann_dist_tsi := p_ann_dist_tsi;
             FOR c IN 1..2
             LOOP
               INSERT_TO_WPOLICYDS_DTL;
               v_share_cd     := 999;
               v_dist_spct    := 0;
               v_dist_tsi     := 0;
               v_dist_prem    := 0;
               v_ann_dist_tsi := 0;
             END LOOP;

          ELSE

             /*rg_id := FIND_GROUP(rg_name);
             RESET_GROUP_SELECTION(rg_id);
             IF GET_GROUP_NUMBER_CELL(rg_col2, p_rg_count) = 999 THEN
                DELETE_GROUP_ROW(rg_id, p_rg_count);
                p_rg_count := p_rg_count - 1;
             END IF;*/

             /* Use AMOUNTS to create the default distribution records. */
             IF p_default_type = 1 THEN
                FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                 a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                 1 true_pct 
                            FROM GIIS_DEFAULT_DIST_GROUP a  
                           WHERE a.default_no = TO_CHAR(NVL(p_v_default_no, 0))
                             AND a.line_cd    = p_line_cd
                             AND a.share_cd   <> 999
                           ORDER BY a.sequence ASC)
                LOOP
                  --v_peril_cd    := GET_GROUP_NUMBER_CELL(rg_col5, c);
                    v_peril_cd := c.peril_cd;
                  IF v_peril_cd IS NOT NULL THEN
                     IF NVL(v_prev_peril_cd, 0) = v_peril_cd THEN
                        NULL;
                     ELSE
                        v_use_share_amt2 := 'N';
                        FOR c1 IN (SELECT 'a'
                                     FROM GIPI_ITMPERIL B380, GIPI_ITEM B340
                                    WHERE B380.peril_cd  = v_peril_cd
                                      AND B380.line_cd   = p_line_cd
                                      AND B380.item_no   = B340.item_no
                                      AND B380.policy_id = B340.policy_id
                                      AND B340.item_grp  = p_item_grp
                                      AND B340.policy_id = p_policy_id)
                        LOOP
                          v_use_share_amt2 := 'Y';
                          EXIT;
                        END LOOP;
                        v_prev_peril_cd := v_peril_cd;
                     END IF;
                  END IF;
                  IF v_use_share_amt2 = 'N' THEN
                     --v_share_amt  := GET_GROUP_NUMBER_CELL(rg_col4, c);
                       v_share_amt  := c.share_amt1;
                  ELSE
                     --v_share_amt  := GET_GROUP_NUMBER_CELL(rg_col6, c);
                       v_share_amt  := c.share_amt2;
                  END IF;
                  IF v_remaining_tsi >= v_share_amt THEN
                     v_dist_tsi      := v_share_amt / p_currency_rt;
                     v_remaining_tsi := v_remaining_tsi - v_share_amt;
                  ELSE
                     v_remaining_tsi := 0;
                  END IF;
                  IF v_remaining_tsi != 0 THEN
                     v_dist_spct        := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
                     v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
                     v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
                     v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
                     v_sum_dist_spct    := v_sum_dist_spct    + v_dist_spct;
                     v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                     v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                     v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
                  ELSIF v_remaining_tsi = 0 THEN
                     v_dist_spct    := 100            - v_sum_dist_spct;
                     v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                     v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                     v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                  END IF;
                  /*v_share_cd := GET_GROUP_NUMBER_CELL(rg_col2, c);
                  SET_GROUP_NUMBER_CELL(rg_col7, c, v_dist_spct);
                  SET_GROUP_SELECTION(rg_id, c);*/
                  v_share_cd := c.share_cd;          
                  INSERT_TO_WPOLICYDS_DTL;
                  IF v_remaining_tsi = 0 THEN
                     EXIT;
                  END IF;
                END LOOP;
                IF v_remaining_tsi != 0  THEN
                   v_dist_spct    := 100            - v_sum_dist_spct;
                   v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                   v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                   v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                   v_share_cd     := '999';
                   p_rg_count     := p_rg_count + 1;
                   /*ADD_GROUP_ROW(rg_id, END_OF_GROUP);
                   SET_GROUP_NUMBER_CELL(rg_col2, p_rg_count, 999);
                   SET_GROUP_NUMBER_CELL(rg_col7, p_rg_count, v_dist_spct);
                   SET_GROUP_SELECTION(rg_id, p_rg_count);*/
                   INSERT_TO_WPOLICYDS_DTL;
                END IF;

             /* Use PERCENTAGES to create the default distribution records. */
             ELSIF p_default_type = 2 THEN
                FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                 a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                 1 true_pct 
                            FROM GIIS_DEFAULT_DIST_GROUP a  
                           WHERE a.default_no = TO_CHAR(NVL(p_v_default_no, 0))
                             AND a.line_cd    = p_line_cd
                             AND a.share_cd   <> 999
                           ORDER BY a.sequence ASC)
                LOOP
                  --v_dist_spct     := GET_GROUP_NUMBER_CELL(rg_col3, c);
                  --v_share_amt     := GET_GROUP_NUMBER_CELL(rg_col4, c);
                    v_dist_spct     := c.share_pct;

                    v_share_amt     := c.share_amt1;
                  IF v_share_amt IS NOT NULL THEN
                     v_dist_tsi        := v_share_amt / p_currency_rt;
                     v_dist_spct_limit := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
                     IF v_dist_spct > v_dist_spct_limit THEN 
                        v_dist_spct := v_dist_spct_limit;                        
                     END IF;
                  END IF;
                  
                  v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
                  IF v_sum_dist_spct != 100 THEN
                     v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
                     v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
                     v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
                     v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                     v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                     v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
                  ELSE
                     v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                     v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                     v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                  END IF;
                   v_share_cd      := c.share_cd;
                  /*v_share_cd      := GET_GROUP_NUMBER_CELL(rg_col2, c);
                  SET_GROUP_NUMBER_CELL(rg_col7, c, v_dist_spct);
                  SET_GROUP_SELECTION(rg_id, c);*/
                  INSERT_TO_WPOLICYDS_DTL;
                END LOOP;
                IF v_sum_dist_spct != 100 THEN
                   v_dist_spct    := 100            - v_sum_dist_spct;
                   v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                   v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                   v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                   v_share_cd     := '999';
                   p_rg_count     := p_rg_count + 1;
                   /*ADD_GROUP_ROW(rg_id, END_OF_GROUP);
                   SET_GROUP_NUMBER_CELL(rg_col2, p_rg_count, 999);
                   SET_GROUP_NUMBER_CELL(rg_col7, p_rg_count, v_dist_spct);
                   SET_GROUP_SELECTION(rg_id, p_rg_count);*/
                   INSERT_TO_WPOLICYDS_DTL;
                END IF;
             ELSE /*added edgar 09/09/2014*/
                 /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_dist_tsi;
                 v_dist_prem    := p_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WPOLICYDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;   
                 /*ended edgar 09/09/2014*/          
             END IF;
          END IF;
      END;
    BEGIN
        -- shan 07.29.2014
        FOR i IN (SELECT *
                    FROM GIPI_POLBASIC_POL_DIST_V1 
                   WHERE policy_id = (SELECT policy_id
                                        FROM giuw_pol_dist
                                       WHERE dist_no = p_dist_no))
        LOOP
            v_pol_flag  := i.pol_flag;
            v_par_type  := i.par_type;
            v_policy_id := i.policy_id;
            v_par_id    := i.par_id;
            EXIT;
        END LOOP;
        
        IF v_pol_flag = '2' THEN
             v_dflt_policy_exists   := FALSE;--edgar 09/08/2014
             v_dist_spct1_chk := FALSE;--edgar 09/12/2014
            /*uncommented out by edgar 09/08/2014*/
            FOR c IN ( SELECT share_cd, dist_spct, dist_spct1  -- commented out retrieving of default share from original policy for now : shan 08.06.2014
		                 FROM giuw_policyds_dtl a
                        WHERE a.dist_seq_no = p_dist_seq_no
                          AND dist_no = ( SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE policy_id = ( SELECT MAX(old_policy_id) --edgar 09/17/21014
                                                                 FROM GIPI_POLNREP
                                                                WHERE par_id = v_par_id
                                                                  AND ren_rep_sw = '1'/*added edgar 09/12/2014*/
                                                                  AND new_policy_id = (SELECT policy_id
                                                                                         FROM gipi_polbasic
                                                                                        WHERE pol_flag <> '5'
                                                                                          AND policy_id = v_policy_id))))/*ended edgar 09/12/2014*/
		    LOOP     	
		       v_dist_spct1_chk := FALSE;--edgar 09/12/2014
               v_share_cd     := c.share_cd;
		       v_dist_spct    := c.dist_spct;
               v_dist_spct1     := c.dist_spct1  ; 
		       v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
		       v_dist_prem        := ROUND(((p_dist_prem    * NVL(c.dist_spct1, c.dist_spct))/ 100), 2);
		       v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
		       v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
		       v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
		       v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
		       INSERT_TO_WPOLICYDS_DTL;
			   v_dflt_policy_exists   := TRUE;            
            END LOOP; --*/--edgar 09/08/2014 
            
           /* IF v_dflt_policy_exists = FALSE THEN
                insert_dflt_values;
            END IF;*/--commented out edgar 09/08/2014
            /*added edgar 09/08/2014*/
             v_dist_spct1_chk := FALSE;--edgar 09/12/2014
            FOR i IN (SELECT '1' /*checks for records having dist_spct1 to insert correct dist_spct1*/
                        FROM giuw_wpolicyds_dtl
                       WHERE dist_no = p_dist_no
                         AND dist_spct1 IS NOT NULL)
            LOOP
                v_dist_spct1_chk := TRUE;
                EXIT;
            END LOOP;
                        
            IF NOT v_dflt_policy_exists THEN
                insert_dflt_values;
            END IF;
            /*ended edgar 09/08/2014*/
            
        ELSIF v_par_type = 'E' THEN
            /*uncommented out edgar 09/08/2014*/
            v_dflt_policy_exists   := FALSE;--edgar 09/08/2014
            FOR c IN ( SELECT dist_no, share_cd, dist_spct, dist_spct1  -- added dist_spct1 : shan 07.29.2014 commented out retrieving of default share from original policy for now : shan 08.06.2014
 	 		             FROM giuw_policyds_dtl a
                        WHERE 1 = 1
                          AND a.dist_seq_no = p_dist_seq_no
                          AND dist_no = ( SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE par_id = ( SELECT par_id
                                                              FROM GIPI_POLBASIC
                                                             WHERE endt_seq_no = 0
                                                               AND (line_cd, 		subline_cd, 
                                                                    iss_cd, 		issue_yy, 
                                                                    pol_seq_no,	renew_no) = (SELECT line_cd, 		subline_cd, 
                                                                                                    iss_cd, 		issue_yy, 
                                                                                                    pol_seq_no, renew_no
                                                                                               FROM GIPI_POLBASIC
                                                                                              WHERE policy_id = v_policy_id))))
            LOOP
                 v_share_cd     	:= c.share_cd;
		         v_dist_spct    	:= c.dist_spct;
                 v_dist_spct1       := c.dist_spct1  ;    -- shan 07.29.2014 
		         v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
		         v_dist_prem        := ROUND(((p_dist_prem    * NVL(c.dist_spct1, c.dist_spct))/ 100), 2);  -- added NVL : shan 07.29.2014
		         v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
		         v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
		         v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
		         v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);		       
		         INSERT_TO_WPOLICYDS_DTL;
                 v_dflt_policy_exists   := TRUE;
            END LOOP; --*/--edgar 09/08/2014 
            
            /*IF v_dflt_policy_exists = FALSE THEN
                insert_dflt_values;
            END IF;*/--commented out edgar 09/08/2014
            /*added edgar 09/08/2014*/

            IF NOT  v_dflt_policy_exists THEN
                insert_dflt_values;
            END IF;            
            /*ended edgar 09/08/2014*/            
        ELSE
            insert_dflt_values;
        END IF; 
       /* created a separate local procedure (INSERT_DFLT_VALUES) for the code below : shan 07.29.2014
      IF p_rg_count = 0 THEN

         /* Create the default distribution records based on the 100%
         ** NET RETENTION and 0% FACULTATIVE hard code defaults. * /
         v_share_cd     := 1;
         v_dist_spct    := 100;
         v_dist_tsi     := p_dist_tsi;
         v_dist_prem    := p_dist_prem;
         v_ann_dist_tsi := p_ann_dist_tsi;
         FOR c IN 1..2
         LOOP
           INSERT_TO_WPOLICYDS_DTL;
           v_share_cd     := 999;
           v_dist_spct    := 0;
           v_dist_tsi     := 0;
           v_dist_prem    := 0;
           v_ann_dist_tsi := 0;
         END LOOP;

      ELSE

         /*rg_id := FIND_GROUP(rg_name);
         RESET_GROUP_SELECTION(rg_id);
         IF GET_GROUP_NUMBER_CELL(rg_col2, p_rg_count) = 999 THEN
            DELETE_GROUP_ROW(rg_id, p_rg_count);
            p_rg_count := p_rg_count - 1;
         END IF;*/

         /* Use AMOUNTS to create the default distribution records. * /
         IF p_default_type = 1 THEN
            FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                             a.share_amt1 , a.peril_cd , a.share_amt2 ,
                             1 true_pct 
                        FROM GIIS_DEFAULT_DIST_GROUP a  
                       WHERE a.default_no = TO_CHAR(NVL(p_v_default_no, 0))
                         AND a.line_cd    = p_line_cd
                         AND a.share_cd   <> 999
                       ORDER BY a.sequence ASC)
            LOOP
              --v_peril_cd    := GET_GROUP_NUMBER_CELL(rg_col5, c);
                v_peril_cd := c.peril_cd;
              IF v_peril_cd IS NOT NULL THEN
                 IF NVL(v_prev_peril_cd, 0) = v_peril_cd THEN
                    NULL;
                 ELSE
                    v_use_share_amt2 := 'N';
                    FOR c1 IN (SELECT 'a'
                                 FROM GIPI_ITMPERIL B380, GIPI_ITEM B340
                                WHERE B380.peril_cd  = v_peril_cd
                                  AND B380.line_cd   = p_line_cd
                                  AND B380.item_no   = B340.item_no
                                  AND B380.policy_id = B340.policy_id
                                  AND B340.item_grp  = p_item_grp
                                  AND B340.policy_id = p_policy_id)
                    LOOP
                      v_use_share_amt2 := 'Y';
                      EXIT;
                    END LOOP;
                    v_prev_peril_cd := v_peril_cd;
                 END IF;
              END IF;
              IF v_use_share_amt2 = 'N' THEN
                 --v_share_amt  := GET_GROUP_NUMBER_CELL(rg_col4, c);
                   v_share_amt  := c.share_amt1;
              ELSE
                 --v_share_amt  := GET_GROUP_NUMBER_CELL(rg_col6, c);
                   v_share_amt  := c.share_amt2;
              END IF;
              IF v_remaining_tsi >= v_share_amt THEN
                 v_dist_tsi      := v_share_amt / p_currency_rt;
                 v_remaining_tsi := v_remaining_tsi - v_share_amt;
              ELSE
                 v_remaining_tsi := 0;
              END IF;
              IF v_remaining_tsi != 0 THEN
                 v_dist_spct        := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
                 v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
                 v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
                 v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
                 v_sum_dist_spct    := v_sum_dist_spct    + v_dist_spct;
                 v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                 v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                 v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
              ELSIF v_remaining_tsi = 0 THEN
                 v_dist_spct    := 100            - v_sum_dist_spct;
                 v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                 v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
              END IF;
              /*v_share_cd := GET_GROUP_NUMBER_CELL(rg_col2, c);
              SET_GROUP_NUMBER_CELL(rg_col7, c, v_dist_spct);
              SET_GROUP_SELECTION(rg_id, c);* /
              v_share_cd := c.share_cd;          
              INSERT_TO_WPOLICYDS_DTL;
              IF v_remaining_tsi = 0 THEN
                 EXIT;
              END IF;
            END LOOP;
            IF v_remaining_tsi != 0  THEN
               v_dist_spct    := 100            - v_sum_dist_spct;
               v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
               v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
               v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
               v_share_cd     := '999';
               p_rg_count     := p_rg_count + 1;
               /*ADD_GROUP_ROW(rg_id, END_OF_GROUP);
               SET_GROUP_NUMBER_CELL(rg_col2, p_rg_count, 999);
               SET_GROUP_NUMBER_CELL(rg_col7, p_rg_count, v_dist_spct);
               SET_GROUP_SELECTION(rg_id, p_rg_count);* /
               INSERT_TO_WPOLICYDS_DTL;
            END IF;

         /* Use PERCENTAGES to create the default distribution records. * /
         ELSIF p_default_type = 2 THEN
            FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                             a.share_amt1 , a.peril_cd , a.share_amt2 ,
                             1 true_pct 
                        FROM GIIS_DEFAULT_DIST_GROUP a  
                       WHERE a.default_no = TO_CHAR(NVL(p_v_default_no, 0))
                         AND a.line_cd    = p_line_cd
                         AND a.share_cd   <> 999
                       ORDER BY a.sequence ASC)
            LOOP
              --v_dist_spct     := GET_GROUP_NUMBER_CELL(rg_col3, c);
              --v_share_amt     := GET_GROUP_NUMBER_CELL(rg_col4, c);
                v_dist_spct     := c.share_pct;
                v_share_amt     := c.share_amt1;
              IF v_share_amt IS NOT NULL THEN
                 v_dist_tsi        := v_share_amt / p_currency_rt;
                 v_dist_spct_limit := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
                 IF v_dist_spct > v_dist_spct_limit THEN 
                    v_dist_spct := v_dist_spct_limit;
                 END IF;
              END IF;
              v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
              IF v_sum_dist_spct != 100 THEN
                 v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
                 v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
                 v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
                 v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                 v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                 v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
              ELSE
                 v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                 v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
              END IF;
               v_share_cd      := c.share_cd;
              /*v_share_cd      := GET_GROUP_NUMBER_CELL(rg_col2, c);
              SET_GROUP_NUMBER_CELL(rg_col7, c, v_dist_spct);
              SET_GROUP_SELECTION(rg_id, c);* /
              INSERT_TO_WPOLICYDS_DTL;
            END LOOP;
            IF v_sum_dist_spct != 100 THEN
               v_dist_spct    := 100            - v_sum_dist_spct;
               v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
               v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
               v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
               v_share_cd     := '999';
               p_rg_count     := p_rg_count + 1;
               /*ADD_GROUP_ROW(rg_id, END_OF_GROUP);
               SET_GROUP_NUMBER_CELL(rg_col2, p_rg_count, 999);
               SET_GROUP_NUMBER_CELL(rg_col7, p_rg_count, v_dist_spct);
               SET_GROUP_SELECTION(rg_id, p_rg_count);* /
               INSERT_TO_WPOLICYDS_DTL;
            END IF;
         END IF;
      END IF; */  
    END;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    CREATE_PERIL_DFLT_WPERILDS Program Unit from GIUWS010
    **/

     PROCEDURE CRTE_PERL_DFLT_WPERILDS_GWS010
         (p_dist_no         IN  GIUW_WPERILDS_DTL.dist_no%TYPE      ,
          p_dist_seq_no     IN  GIUW_WPERILDS_DTL.dist_seq_no%TYPE  ,
          p_line_cd         IN  GIUW_WPERILDS_DTL.line_cd%TYPE      ,
          p_peril_cd        IN  GIUW_WPERILDS_DTL.peril_cd%TYPE     ,
          p_dist_tsi        IN  GIUW_WPERILDS_DTL.dist_tsi%TYPE     ,
          p_dist_prem       IN  GIUW_WPERILDS_DTL.dist_prem%TYPE    ,
          p_ann_dist_tsi    IN  GIUW_WPERILDS_DTL.ann_dist_tsi%TYPE ,
          p_currency_rt     IN  GIPI_WINVOICE.currency_rt%TYPE      ,
          p_default_no      IN  GIIS_DEFAULT_DIST.default_no%TYPE   ,
          p_default_type    IN  GIIS_DEFAULT_DIST.default_type%TYPE ,
          p_dflt_netret_pct IN  GIIS_DEFAULT_DIST.dflt_netret_pct%TYPE) IS

      v_dflt_dist_exist        VARCHAR2(1) := 'N';
      v_dist_spct              GIUW_WPERILDS_DTL.dist_spct%TYPE;
      v_dist_tsi               GIUW_WPERILDS_DTL.dist_tsi%TYPE;
      v_dist_prem              GIUW_WPERILDS_DTL.dist_prem%TYPE;
      v_ann_dist_tsi           GIUW_WPERILDS_DTL.ann_dist_tsi%TYPE;
      v_share_cd               GIIS_DIST_SHARE.share_cd%TYPE;
      v_sum_dist_tsi           GIUW_WPERILDS_DTL.dist_tsi%TYPE     := 0;
      v_sum_dist_spct          GIUW_WPERILDS_DTL.dist_spct%TYPE    := 0;
      v_sum_dist_prem          GIUW_WPERILDS_DTL.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi       GIUW_WPERILDS_DTL.ann_dist_tsi%TYPE := 0;
      v_dist_spct_limit        NUMBER;
      v_remaining_tsi          NUMBER := p_dist_tsi * p_currency_rt;
      v_pol_flag               GIPI_POLBASIC_POL_DIST_V1.POL_FLAG%type;     -- shan 08.04.2014
      v_par_type               GIPI_POLBASIC_POL_DIST_V1.PAR_TYPE%type;     -- shan 08.04.2014
      v_policy_id              GIPI_POLBASIC_POL_DIST_V1.POLICY_ID%type;    -- shan 08.04.2014
      v_dflt_policy_exists     BOOLEAN := FALSE;                            -- shan 08.04.2014
      v_dist_spct1             giuw_wperilds_dtl.DIST_SPCT1%type;           -- shan 08.04.2014
      v_par_id                 gipi_polbasic_pol_dist_v1.PAR_ID%type;       -- shan 08.04.2014
      v_dist_seq_no            giuw_wperilds_dtl.dist_seq_no%TYPE;          --edgar 09/09/2014
      v_dist_spct1_chk         BOOLEAN := FALSE;--edgar 09/12/2014

      CURSOR dist_peril_cur IS
          SELECT a.share_cd , a.share_pct , a.share_amt1
            FROM GIIS_DEFAULT_DIST_PERIL a 
           WHERE a.default_no = p_default_no
             AND a.line_cd    = p_line_cd
             AND a.peril_cd   = p_peril_cd
             AND a.share_cd   <> 999
        ORDER BY a.sequence ASC;
      
      PROCEDURE INSERT_TO_WPERILDS_DTL IS
      BEGIN
        IF v_dist_spct1_chk THEN/*added edgar 09/12/2014*/
            v_dist_spct1 := v_dist_spct;
        END IF;/*ended edgar 09/12/2014*/           
        INSERT INTO  GIUW_WPERILDS_DTL
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , peril_cd      , dist_spct1)--added dist_spct1 edgar 09/12/2014
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_peril_cd    , v_dist_spct1);--added dist_spct1 edgar 09/12/2014
        CREATE_PERIL_DFLT_WITEMPERILDS
              (p_dist_no  , p_dist_seq_no , p_line_cd   ,
               p_peril_cd , v_share_cd    , v_dist_spct ,  
               v_dist_spct, v_dist_spct1);--added dist_spct1 edgar 09/12/2014
      END;
     
     PROCEDURE insert_dflt_values
     IS       
     BEGIN
        /* encapsulate in a local procedure : shan 08.04.2014 */
          /* Use AMOUNTS to create the default distribution records. */
          IF p_default_type = 1 THEN
             FOR c1 IN dist_peril_cur
             LOOP
               v_dflt_dist_exist := 'Y';
               IF v_remaining_tsi >= c1.share_amt1 THEN
                  v_dist_tsi      := c1.share_amt1 / p_currency_rt;
                  v_remaining_tsi := v_remaining_tsi - c1.share_amt1;
               ELSE
                  v_remaining_tsi := 0;
               END IF;
               IF v_remaining_tsi != 0 THEN
                  v_dist_spct        := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
                  v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
                  v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
                  v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
                  v_sum_dist_spct    := v_sum_dist_spct    + v_dist_spct;
                  v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                  v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                  v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
               ELSIF v_remaining_tsi = 0 THEN
                  v_dist_spct    := 100            - v_sum_dist_spct;
                  v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                  v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                  v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
               END IF;
               v_share_cd := c1.share_cd;
               INSERT_TO_WPERILDS_DTL;
               IF v_remaining_tsi = 0 THEN
                  EXIT;
               END IF;
             END LOOP;
             IF v_remaining_tsi  != 0   AND
                v_dflt_dist_exist = 'Y' THEN
                v_dist_spct    := 100            - v_sum_dist_spct;
                v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                v_share_cd     := '999';
                INSERT_TO_WPERILDS_DTL;
             END IF;

          /* Use PERCENTAGES to create the default distribution records. */
          ELSIF p_default_type = 2 THEN
             FOR c1 IN dist_peril_cur
             LOOP
               v_dflt_dist_exist := 'Y';
               v_dist_spct := c1.share_pct;
               IF c1.share_amt1 IS NOT NULL THEN
                  v_dist_tsi        := c1.share_amt1 / p_currency_rt;
                  v_dist_spct_limit := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
                  IF v_dist_spct > v_dist_spct_limit THEN 
                     v_dist_spct := v_dist_spct_limit;
                  END IF;
               END IF;
               v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
               IF v_sum_dist_spct != 100 THEN
                  v_dist_tsi         := ROUND(p_dist_tsi         * v_dist_spct / 100, 2);
                  v_dist_prem        := ROUND(p_dist_prem        * v_dist_spct / 100, 2);
                  v_ann_dist_tsi     := ROUND(p_ann_dist_tsi     * v_dist_spct / 100, 2);
                  v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                  v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                  v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
               ELSE
                  v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                  v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                  v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
               END IF;
               v_share_cd := c1.share_cd;
               INSERT_TO_WPERILDS_DTL;
             END LOOP;
             IF v_sum_dist_spct  != 100 AND
                v_dflt_dist_exist = 'Y' THEN
                v_dist_spct    := 100            - v_sum_dist_spct;
                v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                v_share_cd     := '999';
                INSERT_TO_WPERILDS_DTL;
             END IF;
          ELSIF p_default_type = 0 THEN /*added edgar 09/09/2014*/
             v_dflt_dist_exist := 'Y';
             /* Create the default distribution records based on the 100%
             ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
             v_share_cd     := 1;
             v_dist_spct    := 100;
             v_dist_tsi     := p_dist_tsi;
             v_dist_prem    := p_dist_prem;
             v_ann_dist_tsi := p_ann_dist_tsi;
             FOR c IN 1..2
             LOOP
               INSERT_TO_WPERILDS_DTL;
               v_share_cd     := 999;
               v_dist_spct    := 0;
               v_dist_tsi     := 0;
               v_dist_prem    := 0;
               v_ann_dist_tsi := 0;
             END LOOP;         
             /*ended edgar 09/09/2014*/ 
          END IF;

          /* If GIIS_DEFAULT_DIST_PERIL does not contain a record that
          ** corresponds to the particular peril being distributed,
          ** then use the value of the DFLT_NETRET_PCT column retrieved
          ** from table GIIS_DEFAULT_DIST. */
          IF v_dflt_dist_exist = 'N'       AND
             p_dflt_netret_pct IS NOT NULL THEN

             IF p_dflt_netret_pct != 100 THEN
                v_dist_spct        := p_dflt_netret_pct;
                v_dist_tsi         := ROUND(p_dist_tsi     * p_dflt_netret_pct / 100, 2);
                v_dist_prem        := ROUND(p_dist_prem    * p_dflt_netret_pct / 100, 2);
                v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * p_dflt_netret_pct / 100, 2);
                v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
             ELSE
                v_dist_spct    := p_dflt_netret_pct;
                v_dist_tsi     := p_dist_tsi;
                v_dist_prem    := p_dist_prem;
                v_ann_dist_tsi := p_ann_dist_tsi;
             END IF;
             v_share_cd := 1;
             INSERT_TO_WPERILDS_DTL;
             IF p_dflt_netret_pct != 100 THEN
                v_dist_spct    := 100            - p_dflt_netret_pct;
                v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                v_share_cd     := '999';
                INSERT_TO_WPERILDS_DTL;
             END IF;

          /* If no default distribution record was found in table
          ** GIIS_DEFAULT_DIST, then create the record using
          ** the traditional 100% NET RETENTION, 0% FACULTATIVE
          ** default. */
          ELSIF v_dflt_dist_exist = 'N' THEN

             /* Create the default distribution records based on the 100%
             ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
             v_share_cd     := 1;
             v_dist_spct    := 100;
             v_dist_tsi     := p_dist_tsi;
             v_dist_prem    := p_dist_prem;
             v_ann_dist_tsi := p_ann_dist_tsi;
             FOR c IN 1..2
             LOOP
               INSERT_TO_WPERILDS_DTL;
               v_share_cd     := 999;
               v_dist_spct    := 0;
               v_dist_tsi     := 0;
               v_dist_prem    := 0;
               v_ann_dist_tsi := 0;
             END LOOP;

          END IF;
     END;
     
    BEGIN
        FOR i IN (SELECT *
                    FROM GIPI_POLBASIC_POL_DIST_V1 
                   WHERE policy_id = (SELECT policy_id
                                        FROM giuw_pol_dist
                                       WHERE dist_no = p_dist_no))
        LOOP
            v_pol_flag  := i.pol_flag;
            v_par_type  := i.par_type;
            v_policy_id := i.policy_id;
            v_par_id    := i.par_id;
            EXIT;
        END LOOP;
        
        IF v_pol_flag = '2' THEN
            v_dflt_policy_exists   := FALSE;--edgar 09/09/2014
            v_dist_spct1_chk := FALSE;--edgar 09/12/2014
            /*uncommented out edgar 09/09/2014*/
            FOR c IN ( SELECT share_cd, dist_spct, dist_spct1  -- commented out retrieving of default share from original policy for now : shan 08.06.2014
		                 FROM giuw_perilds_dtl a
                        WHERE a.dist_seq_no = p_dist_seq_no
                          AND a.peril_cd = p_peril_cd
                          AND dist_no = ( SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE policy_id = ( SELECT MAX(old_policy_id) --edgar 09/17/21014
                                                                 FROM GIPI_POLNREP
                                                                WHERE par_id = v_par_id
                                                                  AND ren_rep_sw = '1'/*added edgar 09/12/2014*/
                                                                  AND new_policy_id = (SELECT policy_id
                                                                                         FROM gipi_polbasic
                                                                                        WHERE pol_flag <> '5'
                                                                                          AND policy_id = v_policy_id))))/*ended edgar 09/12/2014*/
		    LOOP  	
		       v_dist_spct1_chk := FALSE;--edgar 09/12/2014
               v_share_cd     := c.share_cd;
		       v_dist_spct    := c.dist_spct;
               v_dist_spct1     := c.dist_spct1;
		       v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
		       v_dist_prem        := ROUND(((p_dist_prem    * NVL(c.dist_spct1, c.dist_spct))/ 100), 2);
		       v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
		       v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
		       v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
		       v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
		       INSERT_TO_WPERILDS_DTL;
			   v_dflt_policy_exists   := TRUE;               
            END LOOP; --*/--edgar 09/08/2014 
            
            /*IF v_dflt_policy_exists = FALSE THEN
                insert_dflt_values;
            END IF;*/--commented out edgar 09/09/2014
            /*added edgar 09/09/2014*/
             v_dist_spct1_chk := FALSE;--edgar 09/12/2014
            FOR i IN (SELECT '1' /*checks for records having dist_spct1 to insert correct dist_spct1*/
                        FROM giuw_wperilds_dtl
                       WHERE dist_no = p_dist_no
                         AND dist_spct1 IS NOT NULL)
            LOOP
                v_dist_spct1_chk := TRUE;
                EXIT;
            END LOOP;
            
            IF NOT v_dflt_policy_exists THEN
                insert_dflt_values;
            END IF;
            /*ended edgar 09/09/2014*/
            
        ELSIF v_par_type = 'E' THEN
            v_dflt_policy_exists   := FALSE;--edgar 09/09/2014
            /*uncommented out edgar 09/09/2014*/
            FOR c IN ( SELECT dist_no, share_cd, dist_spct, dist_spct1  -- commented out retrieving of default share from original policy for now : shan 08.06.2014
                         FROM giuw_perilds_dtl a
                        WHERE 1 = 1
                          AND a.dist_seq_no = p_dist_seq_no
                          AND a.peril_cd = p_peril_cd
                          AND dist_no = ( SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE par_id = ( SELECT par_id
                                                              FROM GIPI_POLBASIC
                                                             WHERE endt_seq_no = 0
                                                               AND (line_cd,         subline_cd, 
                                                                    iss_cd,         issue_yy, 
                                                                    pol_seq_no,    renew_no) = (SELECT line_cd,         subline_cd, 
                                                                                                       iss_cd,         issue_yy, 
                                                                                                       pol_seq_no, renew_no
                                                                                                  FROM GIPI_POLBASIC
                                                                                                 WHERE policy_id = v_policy_id))))
            LOOP
                 v_share_cd         := c.share_cd;
                 v_dist_spct        := c.dist_spct;
                 v_dist_spct1       := c.dist_spct1;
                 v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                 v_dist_prem        := ROUND(((p_dist_prem    * NVL(c.dist_spct1, c.dist_spct))/ 100), 2);
                 v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                 v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                 v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                 v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);		       
		         INSERT_TO_WPERILDS_DTL;
                 v_dflt_policy_exists   := TRUE;
            END LOOP; --*/--edgar 09/08/2014 
            
            /*IF v_dflt_policy_exists = FALSE THEN
                insert_dflt_values;
            END IF;*/--commented out edgar 09/09/2014
            /*added edgar 09/09/2014*/
            IF NOT v_dflt_policy_exists THEN
                insert_dflt_values;
            END IF;
            /*ended edgar 09/09/2014*/            
        ELSE
            insert_dflt_values;
        END IF; 
    END;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    Creates a new record in table GIRI_WDISTFRPS in accordance with
    **                  the data taken in by the facultative share of a specific DIST_SEQ_NO
    **                  in table GIUW_WPOLICYDS_DTL.
    **/

     PROCEDURE CRTE_RI_NEW_WDISTFRPS_GIUWS010
         (p_dist_no         IN  GIUW_WPOLICYDS_DTL.dist_no%TYPE,
          p_dist_seq_no     IN  GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE,
          p_new_tsi_amt     IN  GIUW_WPOLICYDS.tsi_amt%TYPE,
          p_new_prem_amt    IN  GIUW_WPOLICYDS.prem_amt%TYPE, 
          p_new_dist_tsi    IN  GIUW_WPOLICYDS_DTL.dist_tsi%TYPE, 
          p_new_dist_prem   IN  GIUW_WPOLICYDS_DTL.dist_prem%TYPE,
          p_new_dist_spct   IN  GIUW_WPOLICYDS_DTL.dist_spct%TYPE,
          p_new_currency_cd IN  GIPI_INVOICE.currency_cd%TYPE,
          p_new_currency_rt IN  GIPI_INVOICE.currency_rt%TYPE,
          p_new_user_id     IN  GIUW_POL_DIST.user_id%TYPE,
          p_policy_id       IN  GIPI_POLBASIC.policy_id%TYPE,
          p_line_cd         IN  GIPI_POLBASIC.line_cd%TYPE,
          p_subline_cd      IN  GIPI_POLBASIC.subline_cd%TYPE) IS

      v_claims_control_sw       GIRI_WDISTFRPS.claims_control_sw%TYPE := 'N';
      v_claims_coop_sw          GIRI_WDISTFRPS.claims_coop_sw%TYPE    := 'N';
      v_op_sw                   GIRI_WDISTFRPS.op_sw%TYPE;
      v_op_frps_yy              GIRI_WDISTFRPS.op_frps_yy%TYPE;
      v_op_frps_seq_no          GIRI_WDISTFRPS.op_frps_seq_no%TYPE;

    BEGIN

      /* Set the OP_SW of table GIRI_WDISTFRPS to 'Y',
      ** if the subline_cd of the specified PAR is in
      ** 'MOP' or 'MRN'. */
      IF p_subline_cd = 'MOP' THEN
         v_op_sw := 'Y';
      END IF;
      IF p_subline_cd = 'MRN' THEN
         v_op_sw := 'Y';

         /* For risk note policies, get the FRPS_YY and FRPS_SEQ_NO of the
         ** open policy to which the risk note belongs to.  The value 
         ** retrieved shall be used to populate the OP_FRPS_YY and OP_FRPS_SEQ_NO
         ** of table GIRI_WDISTFRPS upon data insertion. */
         FOR c1 IN (SELECT a.frps_yy frps_yy, a.frps_seq_no frps_seq_no
                      FROM GIRI_WDISTFRPS a   , GIUW_POL_DIST c080 ,
                           GIPI_POLBASIC b250 , GIPI_OPEN_POLICY b
                     WHERE a.dist_no       = c080.dist_no
                       AND c080.policy_id  = b250.policy_id
                       AND b250.pol_seq_no = b.op_pol_seqno
                       AND b250.issue_yy   = b.op_issue_yy
                       AND b250.iss_cd     = b.op_iss_cd
                       AND b250.subline_cd = b.op_subline_cd
                       AND b250.line_cd    = b.line_cd
                       AND c080.dist_flag IN ('1', '2', '3')
                       AND b.policy_id     = p_policy_id)
         LOOP
           v_op_frps_yy     := c1.frps_yy;
           v_op_frps_seq_no := c1.frps_seq_no;
           EXIT;
         END LOOP;
      END IF;

      /* Check for an existing CLAIMS CONTROL clause from
      ** table GIPI_POLWC to determine the appropriate value
      ** of the CLAIMS_CONTROL_SW in table GIRI_WDISTFRPS. */
      FOR A IN (SELECT wc_cd
                  FROM GIPI_POLWC
                 WHERE UPPER(wc_title) LIKE '%CLAIMS CONTROL%'
                   AND policy_id = p_policy_id)
      LOOP
        v_claims_control_sw := 'Y';
        EXIT;
      END LOOP;

      /* Check for an existing CLAIMS COOP clause from table
      ** GIPI_POLWC to determine the appropriate value of the
      ** of the CLAIMS_COOP_SW in table GIRI_WDISTFRPS. */
      FOR A IN (SELECT wc_cd
                  FROM GIPI_POLWC
                 WHERE UPPER(wc_title) LIKE '%CLAIMS COOP%'
                   AND policy_id = p_policy_id)
      LOOP
        v_claims_coop_sw    := 'Y';
        EXIT;
      END LOOP;

      /* Creates a record in table GIRI_WDISTFRPS for the specified DIST_NO
      ** and DIST_SEQ_NO. */
      INSERT INTO  GIRI_WDISTFRPS
                  (frps_yy                          , line_cd           , op_group_no      ,
                   op_frps_yy                       , op_frps_seq_no    , dist_no          ,
                   dist_seq_no                      , tsi_amt           , tot_fac_spct     ,
                   tot_fac_tsi                      , prem_amt          , tot_fac_prem     ,
                   loc_voy_unit                     , op_sw             , ri_flag          ,
                   currency_cd                      , currency_rt       , create_date      ,
                   user_id                          , prem_warr_sw      , claims_coop_sw   ,
                   claims_control_sw)
           VALUES (TO_NUMBER(TO_CHAR(SYSDATE,'YY')) , p_line_cd         , NULL             ,
                   v_op_frps_yy                     , v_op_frps_seq_no  , p_dist_no        ,
                   p_dist_seq_no                    , p_new_tsi_amt     , p_new_dist_spct  ,
                   p_new_dist_tsi                   , p_new_prem_amt    , p_new_dist_prem  ,
                   NULL                             , v_op_sw           , '1'              ,
                   p_new_currency_cd                , p_new_currency_rt , SYSDATE          ,
                   p_new_user_id                    , 'N'               , v_claims_coop_sw ,
                   v_claims_control_sw);  
    END;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    Delete affected records related to the regrouping process of the current
    **                  DIST_NO from the distribution and RI working tables.
    **                  Distribution tables affected:
    **                      GIUW_WPERILDS  and DTL, GIUW_WITEMPERILDS and DTL,
    **                      GIUW_WITEMDS_DTL and GIUW_WPOLICYDS_DTL.
    **                  RI tables affected:
    **                      GIRI_WBINDER_PERIL, GIRI_WBINDER, GIRI_WFRPERIL, 
    **                      GIRI_WFRPS_RI and GIRI_WDISTFRPS 
    **/

    PROCEDURE DEL_AFFECTED_DIST_TABLES(v_dist_no giuw_pol_dist.dist_no%TYPE) IS
      
    BEGIN
      
      DELETE giuw_wperilds_dtl
       WHERE dist_no = v_dist_no;
      DELETE giuw_wperilds
       WHERE dist_no = v_dist_no;
      DELETE giuw_witemperilds_dtl
       WHERE dist_no = v_dist_no;
      DELETE giuw_witemperilds
       WHERE dist_no = v_dist_no;
      DELETE giuw_witemds_dtl
       WHERE dist_no = v_dist_no;
      DELETE giuw_wpolicyds_dtl
       WHERE dist_no = v_dist_no;
      FOR c1 IN (SELECT frps_yy, frps_seq_no, line_cd -- jhing 11.26.2014 added line_cd 
                   FROM giri_wdistfrps
                  WHERE dist_no = v_dist_no)
      LOOP
        FOR c2 IN (SELECT pre_binder_id
                     FROM giri_wfrps_ri
                    WHERE frps_yy     = c1.frps_yy 
                      AND frps_seq_no = c1.frps_seq_no
                      AND line_cd = c1.line_cd /* jhing 11.26.2014 added line_cd */ ) 
        LOOP
          DELETE giri_wbinder_peril
           WHERE pre_binder_id = c2.pre_binder_id; 
          DELETE giri_wbinder
           WHERE pre_binder_id = c2.pre_binder_id;
        END LOOP;
        DELETE giri_wfrperil
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no
           AND line_cd = c1.line_cd /* jhing 11.26.2014 added line_cd */ ;
        DELETE giri_wfrps_ri
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no
           AND line_cd = c1.line_cd /* jhing 11.26.2014 added line_cd */ ;
           
        -- jhing 11.26.2014 added delete to giri_wfrps_peril_grp 
         DELETE giri_wfrps_peril_grp
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no
           AND line_cd = c1.line_cd ;
           
      END LOOP;
      
      DELETE giri_wdistfrps
       WHERE dist_no = v_dist_no;
    END;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    RECREATE_GRP_DFLT_WPOLICYDS Program Unit from GIUWS010
    **/

    PROCEDURE RECRTE_GRP_DFLT_WPOLDS_GWS010
         (p_dist_no        IN   GIUW_WPOLICYDS_DTL.dist_no%TYPE      ,
          p_dist_seq_no    IN   GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE  ,
          p_line_cd        IN   GIUW_WPOLICYDS_DTL.line_cd%TYPE      ,
          p_dist_tsi       IN   GIUW_WPOLICYDS_DTL.dist_tsi%TYPE     ,
          p_dist_prem      IN   GIUW_WPOLICYDS_DTL.dist_prem%TYPE    ,
          p_ann_dist_tsi   IN   GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE ,
          p_rg_count       IN OUT NUMBER                           ,
          p_default_type   IN   GIIS_DEFAULT_DIST.default_type%TYPE  ,
          p_currency_rt    IN   GIPI_ITEM.currency_rt%TYPE          ,
          p_policy_id      IN   GIPI_POLBASIC.policy_id%TYPE             ,
          p_item_grp       IN   GIPI_ITEM.item_grp%TYPE,
          p_v_default_no   IN   GIIS_DEFAULT_DIST.default_no%TYPE) IS

      --rg_id                RECORDGROUP;
      rg_name               VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_col1               VARCHAR2(40) := rg_name || '.line_cd';
      rg_col2               VARCHAR2(40) := rg_name || '.share_cd';
      rg_col3               VARCHAR2(40) := rg_name || '.share_pct';
      rg_col4               VARCHAR2(40) := rg_name || '.share_amt1';
      rg_col5               VARCHAR2(40) := rg_name || '.peril_cd';
      rg_col6               VARCHAR2(40) := rg_name || '.share_amt2';
      rg_col7               VARCHAR2(40) := rg_name || '.true_pct';
      v_remaining_tsi       NUMBER       := p_dist_tsi * p_currency_rt;
      v_share_amt           GIIS_DEFAULT_DIST_GROUP.share_amt1%TYPE;
      v_peril_cd            GIIS_DEFAULT_DIST_GROUP.peril_cd%TYPE;
      v_prev_peril_cd       GIIS_DEFAULT_DIST_GROUP.peril_cd%TYPE;
      v_dist_spct           GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_dist_tsi            GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_dist_prem           GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_ann_dist_tsi        GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
      v_sum_dist_tsi        GIUW_WPOLICYDS_DTL.dist_tsi%TYPE     := 0;
      v_sum_dist_spct       GIUW_WPOLICYDS_DTL.dist_spct%TYPE    := 0;
      v_sum_dist_prem       GIUW_WPOLICYDS_DTL.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi    GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE := 0;
      v_share_cd            GIIS_DIST_SHARE.share_cd%TYPE;
      v_use_share_amt2      VARCHAR2(1) := 'N';
      v_dist_spct_limit     GIUW_WPOLICYDS_DTL.dist_spct%TYPE;

      PROCEDURE INSERT_TO_WPOLICYDS_DTL IS
      BEGIN
        INSERT INTO  GIUW_WPOLICYDS_DTL
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1);
      END;

    BEGIN
      IF p_rg_count = 0 THEN

         /* Create the default distribution records based on the 100%
         ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
         v_share_cd     := 1;
         v_dist_spct    := 100;
         v_dist_tsi     := p_dist_tsi;
         v_dist_prem    := p_dist_prem;
         v_ann_dist_tsi := p_ann_dist_tsi;
         FOR c IN 1..2
         LOOP
           INSERT_TO_WPOLICYDS_DTL;
           v_share_cd     := 999;
           v_dist_spct    := 0;
           v_dist_tsi     := 0;
           v_dist_prem    := 0;
           v_ann_dist_tsi := 0;
         END LOOP;

      ELSE

         /*rg_id := FIND_GROUP(rg_name);
         RESET_GROUP_SELECTION(rg_id);
         IF GET_GROUP_NUMBER_CELL(rg_col2, p_rg_count) = 999 THEN
            DELETE_GROUP_ROW(rg_id, p_rg_count);
            p_rg_count := p_rg_count - 1;
         END IF;*/

         /* Use AMOUNTS to create the default distribution records. */
         IF p_default_type = 1 THEN
            --FOR c IN 1..p_rg_count
            FOR c IN (SELECT a.line_cd    , a.share_cd , a.share_pct  ,
                             a.share_amt1 , a.peril_cd , a.share_amt2 ,
                             1 true_pct 
                        FROM GIIS_DEFAULT_DIST_GROUP a 
                        WHERE a.default_no = TO_CHAR(NVL(p_v_default_no, 0))
                        AND a.line_cd    = p_line_cd
                        AND a.share_cd   <> 999 
                       ORDER BY a.sequence ASC)
            LOOP
              --v_peril_cd    := GET_GROUP_NUMBER_CELL(rg_col5, c);
                v_peril_cd    := c.peril_cd;
                
              IF v_peril_cd IS NOT NULL THEN
                 IF NVL(v_prev_peril_cd, 0) = v_peril_cd THEN
                    NULL;
                 ELSE
                    v_use_share_amt2 := 'N';
                    FOR c1 IN (SELECT 'a'
                                 FROM GIPI_ITMPERIL B380, GIPI_ITEM B340,
                                      GIUW_WITEMDS C150
                                WHERE B380.peril_cd    = v_peril_cd
                                  AND B380.line_cd     = p_line_cd
                                  AND B380.item_no     = B340.item_no
                                  AND B380.policy_id   = B340.policy_id
                                  AND B340.item_no     = C150.item_no
                                  AND B340.item_grp    = p_item_grp
                                  AND B340.policy_id   = p_policy_id
                                  AND C150.dist_seq_no = p_dist_seq_no
                                  AND C150.dist_no     = p_dist_no)
                    LOOP
                      v_use_share_amt2 := 'Y';
                      EXIT;
                    END LOOP;
                    v_prev_peril_cd := v_peril_cd;
                 END IF;
              END IF;
              IF v_use_share_amt2 = 'N' THEN
                 --v_share_amt  := GET_GROUP_NUMBER_CELL(rg_col4, c);
                    v_share_amt  := c.share_amt1;
              ELSE
                 --v_share_amt  := GET_GROUP_NUMBER_CELL(rg_col6, c);
                    v_share_amt  := c.share_amt2;
              END IF;
              IF v_remaining_tsi >= v_share_amt THEN
                 v_dist_tsi      := v_share_amt / p_currency_rt;
                 v_remaining_tsi := v_remaining_tsi - v_share_amt;
              ELSE
                 v_remaining_tsi := 0;
              END IF;
              IF v_remaining_tsi != 0 THEN
                 v_dist_spct        := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
                 v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
                 v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
                 v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
                 v_sum_dist_spct    := v_sum_dist_spct    + v_dist_spct;
                 v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                 v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                 v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
              ELSIF v_remaining_tsi = 0 THEN
                 v_dist_spct    := 100            - v_sum_dist_spct;
                 v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                 v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
              END IF;
              
              v_share_cd := c.share_cd;
              /*v_share_cd := GET_GROUP_NUMBER_CELL(rg_col2, c);
              SET_GROUP_NUMBER_CELL(rg_col7, c, v_dist_spct);
              SET_GROUP_SELECTION(rg_id, c);*/          
              INSERT_TO_WPOLICYDS_DTL;
              IF v_remaining_tsi = 0 THEN
                 EXIT;
              END IF;
            END LOOP;
            IF v_remaining_tsi != 0  THEN
               v_dist_spct    := 100            - v_sum_dist_spct;
               v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
               v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
               v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
               v_share_cd     := '999';
               p_rg_count     := p_rg_count + 1;
               /*ADD_GROUP_ROW(rg_id, END_OF_GROUP);
               SET_GROUP_NUMBER_CELL(rg_col2, p_rg_count, 999);
               SET_GROUP_NUMBER_CELL(rg_col7, p_rg_count, v_dist_spct);
               SET_GROUP_SELECTION(rg_id, p_rg_count);*/
               INSERT_TO_WPOLICYDS_DTL;
            END IF;

         /* Use PERCENTAGES to create the default distribution records. */
         ELSIF p_default_type = 2 THEN
            --FOR c IN 1..p_rg_count
            FOR c IN (SELECT a.line_cd    , a.share_cd , a.share_pct  ,
                             a.share_amt1 , a.peril_cd , a.share_amt2 ,
                             1 true_pct 
                        FROM GIIS_DEFAULT_DIST_GROUP a 
                        WHERE a.default_no = TO_CHAR(NVL(p_v_default_no, 0))
                        AND a.line_cd    = p_line_cd
                       AND a.share_cd   <> 999 
                       ORDER BY a.sequence ASC)
            LOOP
              --v_dist_spct     := GET_GROUP_NUMBER_CELL(rg_col3, c);
              --v_share_amt     := GET_GROUP_NUMBER_CELL(rg_col4, c);
              v_dist_spct     := c.share_pct;
              v_share_amt     := c.share_amt1;
              
              IF v_share_amt IS NOT NULL THEN
                 v_dist_tsi        := v_share_amt / p_currency_rt;
                 v_dist_spct_limit := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
                 IF v_dist_spct > v_dist_spct_limit THEN 
                    v_dist_spct := v_dist_spct_limit;
                 END IF;
              END IF;
              v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
              IF v_sum_dist_spct != 100 THEN
                 v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
                 v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
                 v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
                 v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                 v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                 v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
              ELSE
                 v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                 v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
              END IF;
                
                v_share_cd      := c.share_cd;
              
              /*v_share_cd      := GET_GROUP_NUMBER_CELL(rg_col2, c);
              SET_GROUP_NUMBER_CELL(rg_col7, c, v_dist_spct);
              SET_GROUP_SELECTION(rg_id, c);*/
              
              INSERT_TO_WPOLICYDS_DTL;
            END LOOP;
            IF v_sum_dist_spct != 100 THEN
               v_dist_spct    := 100            - v_sum_dist_spct;
               v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
               v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
               v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
               v_share_cd     := '999';
               p_rg_count     := p_rg_count + 1;
               /*ADD_GROUP_ROW(rg_id, END_OF_GROUP);
               SET_GROUP_NUMBER_CELL(rg_col2, p_rg_count, 999);
               SET_GROUP_NUMBER_CELL(rg_col7, p_rg_count, v_dist_spct);
               SET_GROUP_SELECTION(rg_id, p_rg_count);*/
               INSERT_TO_WPOLICYDS_DTL;
            END IF;
         END IF;
      END IF;   
    END;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    RECREATE_PERIL_DFLT_DIST Program Unit from GIUWS010
    **/

     PROCEDURE RECRTE_PERIL_DFLT_DIST_GWS010
      (p_dist_no         IN     GIUW_WPOLICYDS.dist_no%TYPE,
       p_dist_seq_no     IN     GIUW_WPOLICYDS.dist_seq_no%TYPE,
       p_dist_flag       IN     GIUW_WPOLICYDS.dist_flag%TYPE,
       p_policy_tsi      IN     GIUW_WPOLICYDS.tsi_amt%TYPE,
       p_policy_premium  IN     GIUW_WPOLICYDS.prem_amt%TYPE,
       p_policy_ann_tsi  IN     GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
       p_item_grp        IN     GIUW_WPOLICYDS.item_grp%TYPE,
       p_line_cd         IN     GIIS_LINE.line_cd%TYPE,
       p_default_no      IN     GIIS_DEFAULT_DIST.default_no%TYPE,
       p_default_type    IN     GIIS_DEFAULT_DIST.default_type%TYPE,
       p_dflt_netret_pct IN     GIIS_DEFAULT_DIST.dflt_netret_pct%TYPE,
       p_currency_rt     IN     GIPI_ITEM.currency_rt%TYPE,
       p_policy_id       IN     GIPI_POLBASIC.policy_id%TYPE) IS

      v_peril_cd             GIIS_PERIL.peril_cd%TYPE;
      v_peril_tsi            GIUW_WPERILDS.tsi_amt%TYPE      := 0;
      v_peril_premium        GIUW_WPERILDS.prem_amt%TYPE     := 0;
      v_peril_ann_tsi        GIUW_WPERILDS.ann_tsi_amt%TYPE  := 0;
      v_exist                VARCHAR2(1)                     := 'N';
      v_insert_sw            VARCHAR2(1)                     := 'N';
      v_dist_flag            GIPI_POLBASIC.dist_flag%TYPE;
      
      /* Updates the amounts of the previously processed PERIL_CD
      ** while looping inside cursor C3.  After which, the records
      ** for table GIUW_WPERILDS_DTL are also created.
      ** NOTE:  This is a LOCAL PROCEDURE BODY called below. */
      PROCEDURE  UPD_CREATE_WPERIL_DTL_DATA IS
      BEGIN
        UPDATE GIUW_WPERILDS
           SET tsi_amt     = v_peril_tsi     ,
               prem_amt    = v_peril_premium ,
               ann_tsi_amt = v_peril_ann_tsi
         WHERE peril_cd    = v_peril_cd
           AND line_cd     = p_line_cd
           AND dist_seq_no = p_dist_seq_no
           AND dist_no     = p_dist_no;
        GIUW_POL_DIST_FINAL_PKG.CRTE_PERL_DFLT_WPERILDS_GWS010
              (p_dist_no       , p_dist_seq_no , p_line_cd       ,
               v_peril_cd      , v_peril_tsi   , v_peril_premium ,
               v_peril_ann_tsi , p_currency_rt , p_default_no    ,
               p_default_type  , p_dflt_netret_pct);
      END;

    BEGIN

        /* Initialize the value of the variables
        ** in preparation for processing the new
        ** DIST_SEQ_NO. */
        v_peril_cd      := NULL;
        v_peril_tsi     := 0;
        v_peril_premium := 0;
        v_peril_ann_tsi := 0;   
        v_exist         := 'N';

        /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
        ** in table GIPI_WITMPERL in preparation for data insertion to 
        ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
        ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
        
      
      FOR a IN (SELECT dist_flag
                FROM GIUW_POL_DIST
                WHERE policy_id = (SELECT policy_id
                                   FROM GIUW_POL_DIST
                                   WHERE dist_no = p_dist_no)
                                   AND dist_flag = 5) 
      LOOP
          v_dist_flag := a.dist_flag;                              
      END LOOP;
      
      IF v_dist_flag = 5 THEN  
                             -- lian 111501
        FOR c3 IN /*(SELECT B380.tsi_amt      itmperil_tsi                                               ,
                                               (B380.prem_amt - SUM(c170.dist_prem)) itmperil_premium ,
                                           B380.ann_tsi_amt  itmperil_ann_tsi                                           ,
                                           B380.item_no      item_no                                                    ,
                                           B380.peril_cd     peril_cd                                                          
                                   FROM gipi_itmperil B380, gipi_item B340,
                                             giuw_itemperilds_dtl C170, giuw_witemds C150
                                     WHERE B380.item_no     = B340.item_no
                                       AND B380.policy_id   = B340.policy_id
                                       AND B340.item_no     = C170.item_no
                                       AND B380.peril_cd    = C170.peril_cd
                                       AND B380.line_cd     = C170.line_cd
                                       AND B340.policy_id   = p_policy_id
                                       AND C170.dist_seq_no = p_dist_seq_no
                                       AND B340.item_grp       = p_item_grp
                                       AND B340.item_no     = C150.item_no
                                       AND C150.dist_seq_no = p_dist_seq_no
                                       AND C170.dist_no IN (SELECT dist_no
                                                                                 FROM giuw_pol_dist
                                                                                    WHERE policy_id = p_policy_id
                                                                                         AND dist_flag IN (2,3))
                             GROUP BY B380.tsi_amt, B380.ann_tsi_amt, B380.item_no, 
                                               B380.peril_cd, B340.pack_line_cd, B380.prem_amt
                             ORDER BY B380.peril_cd)*/
        
                              (SELECT B380.tsi_amt     itmperil_tsi     ,
                                      B380.prem_amt    itmperil_premium ,
                                      B380.ann_tsi_amt itmperil_ann_tsi ,
                                      B380.item_no     item_no          ,
                                      B380.peril_cd    peril_cd
                                   FROM GIPI_ITMPERIL B380, GIPI_ITEM B340,
                                        GIUW_WITEMDS C150
                                  WHERE B380.item_no     = B340.item_no
                                    AND B380.policy_id   = B340.policy_id
                                    AND B340.item_no     = C150.item_no
                                    AND B340.item_grp    = p_item_grp
                                    AND B340.policy_id   = p_policy_id
                                    AND C150.dist_seq_no = p_dist_seq_no
                                    AND C150.dist_no     = p_dist_no
                               ORDER BY B380.peril_cd)
        LOOP
          v_exist     := 'Y';

          /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
          ** for the specified DIST_SEQ_NO. */
          INSERT INTO  GIUW_WITEMPERILDS  
                      (dist_no             , dist_seq_no   , item_no         ,
                       peril_cd            , line_cd       , tsi_amt         ,
                       prem_amt            , ann_tsi_amt)
               VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                       c3.peril_cd         , p_line_cd     , c3.itmperil_tsi ,
                       /*p_policy_premium*/c3.itmperil_premium , c3.itmperil_ann_tsi);

          /* Create the newly processed PERIL_CD in table
          ** GIUW_WPERILDS. */
          IF v_peril_cd IS NULL THEN
             v_peril_cd     := c3.peril_cd;
             v_insert_sw    := 'Y';
          END IF;

          /* Check if the value of the previously processed
          ** PERIL_CD is equal to the one currently processed.
          ** Should the two be unequal, then the amounts of
          ** the previously processed PERIL_CD must be updated
          ** to reflect the true value of each field for the
          ** specified PERIL_CD.  After the amounts of the specified
          ** PERIL_CD have been updated, then that's the time to
          ** create the records in table GIUW_WPERILDS_DTL.
          ** On the other hand, if the value of the two PERIL_CDs
          ** are equal, then the amounts of the currently processed
          ** record is added along with the amounts of the previously
          ** processed records of the same PERIL_CD.  Such amounts
          ** shall be used later on when the two PERIL_CDs become
          ** unequal. */
          IF v_peril_cd != c3.peril_cd THEN

             /* Updates the amounts of the previously processed PERIL_CD.
             ** After which, the records for table GIUW_WPERILDS_DTL are
             ** also created. */
             UPD_CREATE_WPERIL_DTL_DATA;

             /* Assigns the new PERIL_CD to the V_PERIL_CD
             ** variable in preparation for data creation
             ** in table GIUW_WPERILDS. */
             v_peril_cd      := c3.peril_cd;
             v_peril_tsi     := c3.itmperil_tsi;
             v_peril_premium := p_policy_premium;
             v_peril_ann_tsi := c3.itmperil_ann_tsi;
             v_insert_sw     := 'Y';

          ELSIF v_peril_cd = c3.peril_cd THEN
             v_peril_tsi     := v_peril_tsi     + c3.itmperil_tsi;
             v_peril_premium := v_peril_premium + p_policy_premium;
             v_peril_ann_tsi := v_peril_ann_tsi + c3.itmperil_ann_tsi;
          END IF;
          IF v_insert_sw = 'Y' THEN
             INSERT INTO  GIUW_WPERILDS  
                         (dist_no   , dist_seq_no   , peril_cd         ,
                          line_cd   , tsi_amt       , prem_amt         ,
                          ann_tsi_amt)
                  VALUES (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                          p_line_cd , v_peril_tsi   , v_peril_premium  ,
                          v_peril_ann_tsi);
             v_insert_sw     := 'N';
          END IF;

        END LOOP;
        IF v_exist = 'Y' THEN

           /* Updates the amounts of the last processed PERIL_CD.
           ** After which, its corresponding records for table 
           ** GIUW_WPERILDS_DTL are also created.
           ** NOTE:  This was done so, because the last processed
           **        PERIL_CD is no longer handled by the C3 loop. */
           UPD_CREATE_WPERIL_DTL_DATA;

        END IF;

        /* Create records in table GIUW_WITEMDS_DTL based on
        ** the values inserted to table GIUW_WITEMPERILDS_DTL. */
        CREATE_PERIL_DFLT_WITEMDS  (p_dist_no, p_dist_seq_no);

        /* Create records in table GIUW_WPOLICYDS_DTL based on
        ** the values inserted to table GIUW_WITEMDS_DTL. */
        CREATE_PERIL_DFLT_WPOLICYDS(p_dist_no, p_dist_seq_no);
      
      ELSE -- dist_flag
        FOR c3 IN (SELECT B380.tsi_amt     itmperil_tsi     ,
                          B380.prem_amt    itmperil_premium ,
                          B380.ann_tsi_amt itmperil_ann_tsi ,
                          B380.item_no     item_no          ,
                          B380.peril_cd    peril_cd
                     FROM GIPI_ITMPERIL B380, GIPI_ITEM B340,
                          GIUW_WITEMDS C150
                    WHERE B380.item_no     = B340.item_no
                      AND B380.policy_id   = B340.policy_id
                      AND B340.item_no     = C150.item_no
                      AND B340.item_grp    = p_item_grp
                      AND B340.policy_id   = p_policy_id
                      AND C150.dist_seq_no = p_dist_seq_no
                      AND C150.dist_no     = p_dist_no
                 ORDER BY B380.peril_cd)
        LOOP
          v_exist     := 'Y';

          /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
          ** for the specified DIST_SEQ_NO. */
          INSERT INTO  GIUW_WITEMPERILDS  
                      (dist_no             , dist_seq_no   , item_no         ,
                       peril_cd            , line_cd       , tsi_amt         ,
                       prem_amt            , ann_tsi_amt)
               VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                       c3.peril_cd         , p_line_cd     , c3.itmperil_tsi ,
                       c3.itmperil_premium , c3.itmperil_ann_tsi);

          /* Create the newly processed PERIL_CD in table
          ** GIUW_WPERILDS. */
          IF v_peril_cd IS NULL THEN
             v_peril_cd     := c3.peril_cd;
             v_insert_sw    := 'Y';
          END IF;

          /* Check if the value of the previously processed
          ** PERIL_CD is equal to the one currently processed.
          ** Should the two be unequal, then the amounts of
          ** the previously processed PERIL_CD must be updated
          ** to reflect the true value of each field for the
          ** specified PERIL_CD.  After the amounts of the specified
          ** PERIL_CD have been updated, then that's the time to
          ** create the records in table GIUW_WPERILDS_DTL.
          ** On the other hand, if the value of the two PERIL_CDs
          ** are equal, then the amounts of the currently processed
          ** record is added along with the amounts of the previously
          ** processed records of the same PERIL_CD.  Such amounts
          ** shall be used later on when the two PERIL_CDs become
          ** unequal. */
          IF v_peril_cd != c3.peril_cd THEN

             /* Updates the amounts of the previously processed PERIL_CD.
             ** After which, the records for table GIUW_WPERILDS_DTL are
             ** also created. */
             UPD_CREATE_WPERIL_DTL_DATA;

             /* Assigns the new PERIL_CD to the V_PERIL_CD
             ** variable in preparation for data creation
             ** in table GIUW_WPERILDS. */
             v_peril_cd      := c3.peril_cd;
             v_peril_tsi     := c3.itmperil_tsi;
             v_peril_premium := c3.itmperil_premium;
             v_peril_ann_tsi := c3.itmperil_ann_tsi;
             v_insert_sw     := 'Y';

          ELSIF v_peril_cd = c3.peril_cd THEN
             v_peril_tsi     := v_peril_tsi     + c3.itmperil_tsi;
             v_peril_premium := v_peril_premium + c3.itmperil_premium;
             v_peril_ann_tsi := v_peril_ann_tsi + c3.itmperil_ann_tsi;
          END IF;
          IF v_insert_sw = 'Y' THEN
             INSERT INTO  GIUW_WPERILDS  
                         (dist_no   , dist_seq_no   , peril_cd         ,
                          line_cd   , tsi_amt       , prem_amt         ,
                          ann_tsi_amt)
                  VALUES (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                          p_line_cd , v_peril_tsi   , v_peril_premium  ,
                          v_peril_ann_tsi);
             v_insert_sw     := 'N';
          END IF;

        END LOOP;
        IF v_exist = 'Y' THEN

           /* Updates the amounts of the last processed PERIL_CD.
           ** After which, its corresponding records for table 
           ** GIUW_WPERILDS_DTL are also created.
           ** NOTE:  This was done so, because the last processed
           **        PERIL_CD is no longer handled by the C3 loop. */
           UPD_CREATE_WPERIL_DTL_DATA;

        END IF;

        /* Create records in table GIUW_WITEMDS_DTL based on
        ** the values inserted to table GIUW_WITEMPERILDS_DTL. */
        CREATE_PERIL_DFLT_WITEMDS  (p_dist_no, p_dist_seq_no);

        /* Create records in table GIUW_WPOLICYDS_DTL based on
        ** the values inserted to table GIUW_WITEMDS_DTL. */
        CREATE_PERIL_DFLT_WPOLICYDS(p_dist_no, p_dist_seq_no);
      END IF;      
    END;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    CREATE_GRP_DFLT_DIST Program Unit from GIUWS010
    **/

     PROCEDURE CREATE_GRP_DFLT_DIST_GIUWS010
       (p_dist_no        IN     GIUW_WPOLICYDS.dist_no%TYPE,
        p_dist_seq_no    IN     GIUW_WPOLICYDS.dist_seq_no%TYPE,
        p_dist_flag      IN     GIUW_WPOLICYDS.dist_flag%TYPE,
        p_policy_tsi     IN     GIUW_WPOLICYDS.tsi_amt%TYPE,
        p_policy_premium IN     GIUW_WPOLICYDS.prem_amt%TYPE,
        p_policy_ann_tsi IN     GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
        p_item_grp       IN     GIUW_WPOLICYDS.item_grp%TYPE,
        p_line_cd        IN     GIIS_LINE.line_cd%TYPE,
        p_rg_count       IN     OUT NUMBER,
        p_default_type   IN     GIIS_DEFAULT_DIST.default_type%TYPE,
        p_currency_rt    IN     GIPI_ITEM.currency_rt%TYPE,
        p_policy_id      IN     GIPI_POLBASIC.policy_id%TYPE,
        p_v_default_no   IN     GIIS_DEFAULT_DIST.default_no%TYPE) 
        
    IS

        v_peril_cd              GIIS_PERIL.peril_cd%TYPE;
        v_peril_tsi             GIUW_WPERILDS.tsi_amt%TYPE      := 0;
        v_peril_premium         GIUW_WPERILDS.prem_amt%TYPE     := 0;
        v_peril_ann_tsi         GIUW_WPERILDS.ann_tsi_amt%TYPE  := 0;
        v_exist                 VARCHAR2(1)                     := 'N';
        v_insert_sw             VARCHAR2(1)                     := 'N';
        v_dist_flag             GIPI_POLBASIC.dist_flag%TYPE;
        
        ----------------------------------------------------------------
        dist_cnt                NUMBER;
        dist_max                GIUW_POL_DIST.dist_no%type;
        
        v_tsi_amt               GIUW_POL_DIST.tsi_amt%type;
        v_prem_amt              GIUW_POL_DIST.tsi_amt%type;
        v_ann_tsi_amt           GIUW_POL_DIST.tsi_amt%type;
        ----------------------------------------------------------------
        v_redist_prem           GIUW_POL_DIST.tsi_amt%type;
        v_current_takeup        giuw_pol_dist.takeup_seq_no%TYPE; -- jhing 11.26.2014 
        v_max_takeup            giuw_pol_dist.takeup_seq_no%TYPE;  -- jhing 11.26.2014 
        v_redist_sw             VARCHAR2(1) ; -- jhing 11.26.2014 
        
      /* Updates the amounts of the previously processed PERIL_CD
      ** while looping inside cursor C3.  After which, the records
      ** for table GIUW_WPERILDS_DTL are also created.
      ** NOTE:  This is a LOCAL PROCEDURE BODY called below. */
      PROCEDURE  UPD_CREATE_WPERIL_DTL_DATA IS
        BEGIN
          UPDATE GIUW_WPERILDS
             SET tsi_amt     = v_peril_tsi     ,
                 prem_amt    = v_peril_premium ,
                 ann_tsi_amt = v_peril_ann_tsi
           WHERE peril_cd    = v_peril_cd
             AND line_cd     = p_line_cd
             AND dist_seq_no = p_dist_seq_no
             AND dist_no     = p_dist_no;
          
           -- jhing 11.25.2014 commented out codes which populates DTL tables. These tables will be populated in a separate proc.
          /*GIUW_POL_DIST_FINAL_PKG.CRT_GRP_DFLT_WPERILDS_GW18    -- CREATE_GRP_DFLT_WPERILDS : shan 07.29.2014
            (p_dist_no       , p_dist_seq_no , p_line_cd       ,
             v_peril_cd      , v_peril_tsi   , v_peril_premium ,
             v_peril_ann_tsi , p_rg_count    , p_v_default_no ); */
        END;

      BEGIN
      ---------------------------------------  
        SELECT COUNT(*), MAX(dist_no)
          INTO dist_cnt, dist_max
          FROM GIUW_POL_DIST
         WHERE policy_id = p_policy_id
           AND item_grp = p_item_grp
           AND dist_flag NOT IN (4,5);
           
        -- jhing 11.26.2014 added codes to retrieve takeup
        SELECT NVL(MAX(takeup_seq_no),1 )
            INTO v_max_takeup
                FROM giuw_pol_dist
                    WHERE policy_id = p_policy_id;
        
        SELECT NVL(takeup_seq_no,1)
            INTO v_current_takeup
            FROM giuw_pol_dist
                WHERE dist_no = p_dist_no; 
                
        v_redist_sw := 'N';
        FOR rd in ( SELECT 1 
                        FROM giuw_pol_dist
                            WHERE policy_id = p_policy_id
                                AND dist_flag = '5')
        LOOP
            v_redist_sw := 'Y';
            EXIT;
        END LOOP;        
            
        -- end of added codes jhing 11.26.2014   
           
         
        IF dist_cnt = 0 AND dist_max IS NULL THEN
            SELECT COUNT(*), MAX(dist_no)
            INTO dist_cnt, dist_max
            FROM GIUW_POL_DIST
           WHERE policy_id = p_policy_id
             AND item_grp IS NULL
             AND dist_flag NOT IN (4,5);
        END IF;
      ------------------------------------------  
        /* Create records in table GIUW_WPOLICYDS and GIUW_WPOLICYDS_DTL
        ** for the specified DIST_SEQ_NO. */
        -- START added by Jayson 07.21.2010 --
        -- deducts the 1st half of the redistributed distribution --
        IF /*p_dist_no = dist_max*/ v_redist_sw = 'Y'  /* jhing changed condition*/ THEN
            BEGIN
            SELECT prem_amt
              INTO v_redist_prem
              FROM GIUW_POL_DIST
             WHERE policy_id = p_policy_id
               AND item_grp IS NULL
               AND dist_flag = 3;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_redist_prem := 0;
            END;
            -- END added by Jayson 07.21.2010 --
           
            FOR x IN (SELECT SUM(NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)    /*beth- (ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)/dist_cnt),2) * (dist_cnt - 1))*/) tsi_amt, 
                             --SUM(NVL(a.prem_amt,0) - (ROUND((NVL(a.prem_amt,0)/dist_cnt),2) * (dist_cnt - 1))) prem_amt, -- removed by jayson 07.21.2010
                              SUM(NVL(a.prem_amt,0)) - v_redist_prem prem_amt,-- added by jayson 07.21.2010
                              SUM(NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0) /*beth- (ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)/dist_cnt),2) * (dist_cnt - 1))*/) ann_tsi_amt
                                    FROM GIPI_ITMPERIL a, GIPI_ITEM b, GIIS_PERIL c
                                 WHERE a.policy_id = b.policy_id
                                   AND a.item_no = b.item_no
                                   AND a.policy_id = p_policy_id
                                     AND b.item_grp  = p_item_grp
                                     AND a.peril_cd = c.peril_cd
                                     AND c.line_cd  = p_line_cd)
                   
            LOOP
                v_tsi_amt         := x.tsi_amt;
                v_prem_amt        := x.prem_amt;
                v_ann_tsi_amt     := x.ann_tsi_amt;
            END LOOP; 
          ELSE
            IF dist_cnt = 0 THEN
                dist_cnt := 1;
            END IF;
            FOR x IN (SELECT SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)/*beth/dist_cnt*/),2)) tsi_amt, 
                                             SUM(ROUND((NVL(a.prem_amt,0)/dist_cnt),2)) prem_amt, 
                                             SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)/*beth/dist_cnt*/),2)) ann_tsi_amt
                                    FROM GIPI_ITMPERIL a, GIPI_ITEM b, GIIS_PERIL c
                                 WHERE a.policy_id = b.policy_id
                                   AND a.item_no = b.item_no
                                   AND a.policy_id = p_policy_id
                                   AND b.item_grp  = p_item_grp
                                   AND a.peril_cd  = c.peril_cd
                                   AND c.line_cd  = p_line_cd)
                   
            LOOP
                v_tsi_amt         := x.tsi_amt;
                v_prem_amt        := x.prem_amt;
                v_ann_tsi_amt     := x.ann_tsi_amt;
            END LOOP; 
          END IF;
        ---------------------------
        INSERT INTO  GIUW_WPOLICYDS
          (dist_no      , dist_seq_no      , dist_flag        ,
           tsi_amt      , prem_amt         , ann_tsi_amt      ,
           item_grp)
        VALUES 
          (p_dist_no    , p_dist_seq_no    , p_dist_flag      ,
           --p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
           v_tsi_amt    , v_prem_amt       , v_ann_tsi_amt    ,
           p_item_grp);

        -- jhing 11.25.2014 commented out codes which populates DTL tables. These tables will be populated in a separate proc.      
        /*GIUW_POL_DIST_FINAL_PKG.CRTE_GRP_DFLT_WPOLICYDS_GWS010
          (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
           --p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
           v_tsi_amt    , v_prem_amt       , v_ann_tsi_amt    ,
           p_rg_count   , p_default_type   , p_currency_rt    ,
           p_policy_id  , p_item_grp       , p_v_default_no); */
                     
        /* Get the amounts for each item in table GIPI_ITEM in preparation
        ** for data insertion to its corresponding distribution tables. */
        
        -- lian 111501
        FOR a IN (SELECT dist_flag
                  FROM GIUW_POL_DIST
                  WHERE policy_id = (SELECT policy_id
                                     FROM GIUW_POL_DIST
                                     WHERE dist_no = p_dist_no)
                                     AND dist_flag = 5) 
          LOOP
              v_dist_flag := a.dist_flag;                              
          END LOOP;
      
          IF v_dist_flag = 5 THEN
            
          FOR c2 IN (SELECT c.item_no     , a.tsi_amt , 
                            (a.prem_amt - SUM(c.dist_prem)) prem_amt ,
                                             a.ann_tsi_amt
                                   FROM GIPI_ITEM a, GIUW_ITEMPERILDS_DTL c
                                       WHERE EXISTS (SELECT '1'
                                                   FROM GIPI_ITMPERIL b
                                                 WHERE b.policy_id = a.policy_id
                                                     AND b.item_no   = a.item_no)
                                         AND a.item_no     = c.item_no
                                         AND a.item_grp    = p_item_grp
                                         AND a.policy_id   = p_policy_id
                                       --  AND c.dist_seq_no = p_dist_seq_no  -- jhing commented out 11.26.2014 causes discrep for multiple dist group
                                         AND c.dist_no IN (SELECT dist_no
                                                           FROM GIUW_POL_DIST
                                                           WHERE policy_id = p_policy_id
                                                              AND dist_flag IN (2,3))
                                  GROUP BY c.item_no, a.tsi_amt, a.prem_amt, a.ann_tsi_amt)
                         
                                 /*SELECT a.item_no     , a.tsi_amt , a.prem_amt ,
                              a.ann_tsi_amt
                              FROM gipi_item a
                            WHERE exists( SELECT '1'
                                        FROM gipi_itmperil b
                                            WHERE b.policy_id = a.policy_id
                                              AND b.item_no = a.item_no)
                              AND a.item_grp  = p_item_grp
                              AND a.policy_id = p_policy_id)*/
          LOOP

            /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL
            ** for the specified DIST_SEQ_NO. */
            INSERT INTO  GIUW_WITEMDS
              (dist_no        , dist_seq_no   , item_no        ,
               tsi_amt        , prem_amt      , ann_tsi_amt)
            VALUES 
              (p_dist_no      , p_dist_seq_no , c2.item_no     ,
               c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);
            
            -- jhing 11.25.2014 commented out codes which populates DTL tables. These tables will be populated in a separate proc.
            /*GIUW_POL_DIST_FINAL_PKG.CRT_GRP_DFLT_WITEMDS_GW18 -- CREATE_GRP_DFLT_WITEMDS : shan 07.29.2014
              (p_dist_no      , p_dist_seq_no , c2.item_no  ,
               p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
               c2.ann_tsi_amt , p_rg_count    , p_v_default_no); */

          END LOOP;

          /* Initialize the value of the variables
          ** in preparation for processing the new
          ** DIST_SEQ_NO. */
          v_peril_cd      := NULL;
          v_peril_tsi     := 0;
          v_peril_premium := 0;
          v_peril_ann_tsi := 0;   
          v_exist         := 'N';

          /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
          ** in table GIPI_ITMPERIL in preparation for data insertion to 
          ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
          ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
                 
          -- lian 111501
            FOR c3 IN (SELECT B380.tsi_amt      itmperil_tsi  ,
                             (B380.prem_amt - SUM(c150.dist_prem)) itmperil_premium ,
                              B380.ann_tsi_amt  itmperil_ann_tsi  ,
                              B380.item_no      item_no ,
                              B380.peril_cd     peril_cd                                                          
                       FROM GIPI_ITMPERIL B380, GIPI_ITEM B340,
                            GIUW_ITEMPERILDS_DTL C150
                       WHERE B380.item_no     = B340.item_no
                         AND B380.policy_id   = B340.policy_id
                         AND B340.item_no     = C150.item_no
                         AND B380.peril_cd    = C150.peril_cd
                         AND B380.line_cd     = C150.line_cd
                         AND B340.policy_id   = p_policy_id
                        -- AND C150.dist_seq_no = p_dist_seq_no  -- jhing 11.26.2014 commented out, causes discrep for multiple dist group
                         AND B340.item_grp       = p_item_grp
                         AND C150.dist_no IN (SELECT dist_no
                                              FROM GIUW_POL_DIST
                                              WHERE policy_id = p_policy_id
                                              AND dist_flag IN (2,3)) 
                         -- jhing 11.26.2014 added condition 
                         AND EXISTS (   SELECT 1 
                                            FROM giuw_witemds px
                                                WHERE px.dist_no = p_dist_no
                                                    AND px.item_no = B340.item_no  )
              GROUP BY B380.tsi_amt, B380.ann_tsi_amt, B380.item_no, 
                       B380.peril_cd, B340.pack_line_cd, B380.prem_amt
              ORDER BY B380.peril_cd)
                             
                                 /*SELECT B380.tsi_amt     itmperil_tsi     ,
                              B380.prem_amt    itmperil_premium ,
                              B380.ann_tsi_amt itmperil_ann_tsi ,
                                B380.item_no     item_no          ,
                                B380.peril_cd    peril_cd
                            FROM gipi_itmperil B380, gipi_item B340
                          WHERE B380.item_no   = B340.item_no
                            AND B380.policy_id = B340.policy_id
                            AND B340.item_grp  = p_item_grp
                            AND B340.policy_id = p_policy_id
                               ORDER BY B380.peril_cd)*/
          LOOP
            v_exist     := 'Y';

            /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
            ** for the specified DIST_SEQ_NO. */
             
            INSERT INTO  GIUW_WITEMPERILDS  
              (dist_no             , dist_seq_no   , item_no         ,
               peril_cd            , line_cd       , tsi_amt         ,
               prem_amt            , ann_tsi_amt)
            VALUES 
              (p_dist_no           , p_dist_seq_no , c3.item_no      ,
               c3.peril_cd         , p_line_cd     , c3.itmperil_tsi , 
               c3.itmperil_premium , c3.itmperil_ann_tsi);
            
            -- jhing 11.25.2014 commented out codes which populates DTL tables. These tables will be populated in a separate proc.
            /*GIUW_POL_DIST_FINAL_PKG.CRT_GRP_DFLT_WITEMPERILDS_GW18  -- CREATE_GRP_DFLT_WITEMPERILDS : shan 07.29.2014
              (p_dist_no           , p_dist_seq_no       , c3.item_no      ,
               p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
               c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count, p_v_default_no); */

            /* Create the newly processed PERIL_CD in table
            ** GIUW_WPERILDS. */
            IF v_peril_cd IS NULL THEN
              v_peril_cd     := c3.peril_cd;
              v_insert_sw    := 'Y';
            END IF;

            /* Check if the value of the previously processed
            ** PERIL_CD is equal to the one currently processed.
            ** Should the two be unequal, then the amounts of
            ** the previously processed PERIL_CD must be updated
            ** to reflect the true value of each field for the
            ** specified PERIL_CD.  After the amounts of the specified
            ** PERIL_CD have been updated, then that's the time to
            ** create the records in table GIUW_WPERILDS_DTL.
            ** On the other hand, if the value of the two PERIL_CDs
            ** are equal, then the amounts of the currently processed
            ** record is added along with the amounts of the previously
            ** processed records of the same PERIL_CD.  Such amounts
            ** shall be used later on when the two PERIL_CDs become
            ** unequal. */
            IF v_peril_cd != c3.peril_cd THEN
                        /* Updates the amounts of the previously processed PERIL_CD.
              ** After which, the records for table GIUW_WPERILDS_DTL are
              ** also created. */
              UPD_CREATE_WPERIL_DTL_DATA;

              /* Assigns the new PERIL_CD to the V_PERIL_CD
              ** variable in preparation for data creation
              ** in table GIUW_WPERILDS. */
              v_peril_cd      := c3.peril_cd;
              v_peril_tsi     := c3.itmperil_tsi;
              v_peril_premium := c3.itmperil_premium;
              v_peril_ann_tsi := c3.itmperil_ann_tsi;
              v_insert_sw     := 'Y';

            ELSIF v_peril_cd = c3.peril_cd THEN
              v_peril_tsi     := v_peril_tsi     + c3.itmperil_tsi;
              v_peril_premium := v_peril_premium + c3.itmperil_premium;
              v_peril_ann_tsi := v_peril_ann_tsi + c3.itmperil_ann_tsi;
            END IF;
            
            IF v_insert_sw = 'Y' THEN
              INSERT INTO  GIUW_WPERILDS  
                (dist_no   , dist_seq_no   , peril_cd         ,
                 line_cd   , tsi_amt       , prem_amt         ,
                 ann_tsi_amt)
              VALUES 
                  (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                 p_line_cd , v_peril_tsi   , v_peril_premium  ,
                 v_peril_ann_tsi);
              
              v_insert_sw     := 'N';
            END IF;
          END LOOP;
          
          IF v_exist = 'Y' THEN
            /* Updates the amounts of the last processed PERIL_CD.
            ** After which, its corresponding records for table 
            ** GIUW_WPERILDS_DTL are also created.
            ** NOTE:  This was done so, because the last processed
            **        PERIL_CD is no longer handled by the C3 loop. */
            UPD_CREATE_WPERIL_DTL_DATA;
                END IF;
        
        ELSE -- dist_flag -- non-redistributed, long term 
          FOR c2 IN (SELECT a.item_no     , a.tsi_amt , a.prem_amt ,
                            a.ann_tsi_amt
                       FROM GIPI_ITEM a
                      WHERE EXISTS( SELECT '1'
                                      FROM GIPI_ITMPERIL b
                                     WHERE b.policy_id = a.policy_id
                                       AND b.item_no = a.item_no)
                        AND a.item_grp  = p_item_grp
                        AND a.policy_id = p_policy_id)
          LOOP
                    IF /*p_dist_no = dist_max*/ v_current_takeup = v_max_takeup  THEN
                    FOR x IN (SELECT SUM(NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)    /*beth- (ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)/dist_cnt),2) * (dist_cnt - 1))*/) tsi_amt, 
                                      SUM(NVL(a.prem_amt,0) - (ROUND((NVL(a.prem_amt,0)//*dist_cnt*/ v_max_takeup ),2) * (/*dist_cnt*/ v_max_takeup - 1))) prem_amt, 
                                      SUM(NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0) /*beth- (ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)/dist_cnt),2) * (dist_cnt - 1))*/) ann_tsi_amt
                              FROM GIPI_ITMPERIL a, GIPI_ITEM b, GIIS_PERIL c
                              WHERE a.policy_id = b.policy_id
                                AND a.item_no = b.item_no
                                AND a.policy_id = p_policy_id
                                AND a.item_no  = c2.item_no
                                AND a.peril_cd = c.peril_cd
                                AND c.line_cd  = p_line_cd)
                           
                    LOOP
                        v_tsi_amt         := x.tsi_amt;
                        v_prem_amt        := x.prem_amt;
                        v_ann_tsi_amt     := x.ann_tsi_amt;
                    END LOOP; 
                  ELSE
                    FOR x IN (SELECT SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0) /*beth/dist_cnt*/),2)) tsi_amt, 
                                     SUM(ROUND((NVL(a.prem_amt,0)/dist_cnt),2)) prem_amt, 
                                     SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)/*beth/dist_cnt*/),2)) ann_tsi_amt
                              FROM GIPI_ITMPERIL a, GIPI_ITEM b, GIIS_PERIL c
                              WHERE a.policy_id = b.policy_id
                                AND a.item_no = b.item_no
                                AND a.policy_id = p_policy_id
                                AND a.item_no = c2.item_no
                                AND a.peril_cd = c.peril_cd
                                AND c.line_cd = p_line_cd)
                           
                    LOOP
                        v_tsi_amt         := x.tsi_amt;
                        v_prem_amt        := x.prem_amt;
                        v_ann_tsi_amt     := x.ann_tsi_amt;
                    END LOOP; 
                  END IF;    
            
            /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL
            ** for the specified DIST_SEQ_NO. */
              INSERT INTO  GIUW_WITEMDS
              (dist_no        , dist_seq_no   , item_no        ,
               tsi_amt        , prem_amt      , ann_tsi_amt)
               VALUES 
                (p_dist_no      , p_dist_seq_no , c2.item_no     ,
               --c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);
               v_tsi_amt            , v_prem_amt        , v_ann_tsi_amt);
            
             -- jhing 11.25.2014 commented out codes which populates DTL tables. These tables will be populated in a separate proc.
            /*GIUW_POL_DIST_FINAL_PKG.CRT_GRP_DFLT_WITEMDS_GW18   -- CREATE_GRP_DFLT_WITEMDS : shan 07.29.2014 
              (p_dist_no      , p_dist_seq_no , c2.item_no  ,
               p_line_cd      , v_tsi_amt            , v_prem_amt    ,    --c2.tsi_amt    , c2.prem_amt ,
               v_ann_tsi_amt  ,--c2.ann_tsi_amt 
               p_rg_count     , p_v_default_no); */ 

          END LOOP;

          /* Initialize the value of the variables
          ** in preparation for processing the new
          ** DIST_SEQ_NO. */
          v_peril_cd      := NULL;
          v_peril_tsi     := 0;
          v_peril_premium := 0;
          v_peril_ann_tsi := 0;   
          v_exist         := 'N';

          /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
          ** in table GIPI_ITMPERIL in preparation for data insertion to 
          ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
          ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
          FOR c3 IN (SELECT B380.tsi_amt     itmperil_tsi     ,
                            B380.prem_amt    itmperil_premium ,
                            B380.ann_tsi_amt itmperil_ann_tsi ,
                            B380.item_no     item_no          ,
                            B380.peril_cd    peril_cd
                       FROM GIPI_ITMPERIL B380, GIPI_ITEM B340
                      WHERE B380.item_no   = B340.item_no
                        AND B380.policy_id = B340.policy_id
                        AND B340.item_grp  = p_item_grp
                        AND B340.policy_id = p_policy_id
                      ORDER BY B380.peril_cd)
          LOOP
            v_exist     := 'Y';
                    
            /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
            ** for the specified DIST_SEQ_NO. */
            IF /*p_dist_no = dist_max */ v_current_takeup = v_max_takeup  THEN -- jhing 11.27.2014 replaced conditions 
                    v_tsi_amt          := NVL(c3.itmperil_tsi,0)     /*beth- (ROUND((NVL(c3.itmperil_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
                    v_prem_amt         := NVL(c3.itmperil_premium,0) - (ROUND((NVL(c3.itmperil_premium,0)//*dist_cnt*/ v_max_takeup ),2) * (/*dist_cnt*/ v_max_takeup  - 1));
                    v_ann_tsi_amt      := NVL(c3.itmperil_ann_tsi,0) /*beth- (ROUND((NVL(c3.itmperil_ann_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
            ELSE
                    v_tsi_amt          := ROUND((NVL(c3.itmperil_tsi,0)    /*beth/dist_cnt*/),2);
                    v_prem_amt         := ROUND((NVL(c3.itmperil_premium,0)//*dist_cnt*/ v_max_takeup ),2);
                    v_ann_tsi_amt      := ROUND((NVL(c3.itmperil_ann_tsi,0)/*beth/dist_cnt*/),2);
            END IF; 
                  
            INSERT INTO  GIUW_WITEMPERILDS  
              (dist_no             , dist_seq_no   , item_no         ,
               peril_cd            , line_cd       , tsi_amt         ,
               prem_amt            , ann_tsi_amt)
            VALUES 
                (p_dist_no         , p_dist_seq_no , c3.item_no      ,
               c3.peril_cd         , p_line_cd     , v_tsi_amt,--c3.itmperil_tsi , 
               --c3.itmperil_premium , c3.itmperil_ann_tsi
               v_prem_amt, v_ann_tsi_amt);
            
            -- jhing 11.25.2014 commented out codes which populates DTL tables. These tables will be populated in a separate proc.
            /* GIUW_POL_DIST_FINAL_PKG.CRT_GRP_DFLT_WITEMPERILDS_GW18  -- CREATE_GRP_DFLT_WITEMPERILDS : shan 07.29.2014
              (p_dist_no           , p_dist_seq_no       , c3.item_no      ,
               p_line_cd           , c3.peril_cd         , v_tsi_amt       ,--c3.itmperil_tsi ,
               v_prem_amt          , v_ann_tsi_amt       ,--c3.itmperil_premium , c3.itmperil_ann_tsi , 
               p_rg_count          , p_v_default_no);  */ 
               
            END LOOP;
          
          /* Create the newly processed PERIL_CD in table
             ** GIUW_WPERILDS. */
            FOR c4 IN (SELECT SUM(a.tsi_amt)     itmperil_tsi     ,
                                        SUM(a.prem_amt)    itmperil_premium ,
                                        SUM(a.ann_tsi_amt) itmperil_ann_tsi ,
                                        --B490.item_no     item_no          ,
                                        a.peril_cd    peril_cd
                                     FROM GIPI_ITMPERIL a, GIPI_ITEM b
                                  WHERE a.item_no  = b.item_no
                                    AND a.policy_id   = b.policy_id
                                    AND b.item_grp = p_item_grp
                                    AND a.policy_id   = p_policy_id         
                                  GROUP BY a.peril_cd)
                LOOP       
                  --msg_alert('giuw_wperilds','I',FALSE);
                  IF /*p_dist_no = dist_max*/ v_current_takeup = v_max_takeup  THEN -- jhing 11.26.2014 replaced conditions/variables
                    c4.itmperil_tsi      := NVL(c4.itmperil_tsi,0)     /*beth- (ROUND((NVL(c4.itmperil_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
                    c4.itmperil_premium  := NVL(c4.itmperil_premium,0) - (ROUND((NVL(c4.itmperil_premium,0)/v_max_takeup/*dist_cnt*/ ),2) * (v_max_takeup - 1 /*dist_cnt*/ ));
                    c4.itmperil_ann_tsi  := NVL(c4.itmperil_ann_tsi,0) /*beth- (ROUND((NVL(c4.itmperil_ann_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
                  ELSE
                    c4.itmperil_tsi      := c4.itmperil_tsi     /*beth/ dist_cnt*/;
                    c4.itmperil_premium  := c4.itmperil_premium / v_max_takeup/*dist_cnt*/ ;
                    c4.itmperil_ann_tsi  := c4.itmperil_ann_tsi /*beth/ dist_cnt*/;
                  END IF;
              
                  INSERT INTO GIUW_WPERILDS  
                    (dist_no   , dist_seq_no   , peril_cd         ,
                      line_cd   , tsi_amt       , prem_amt         ,
                      ann_tsi_amt)
                  VALUES 
                      (p_dist_no , p_dist_seq_no , c4.peril_cd       ,
                       p_line_cd , c4.itmperil_tsi   , c4.itmperil_premium  ,
                       c4.itmperil_ann_tsi);            
              
                  v_peril_cd         := c4.peril_cd;
                  v_peril_tsi        := c4.itmperil_tsi;
                  v_peril_premium    := c4.itmperil_premium;
                  v_peril_ann_tsi    := c4.itmperil_ann_tsi;
                
                  UPD_CREATE_WPERIL_DTL_DATA;                   
                END LOOP;
          END IF;
    END;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    CREATE_RI_RECORDS Program Unit from GIUWS010
    **/

     PROCEDURE CREATE_RI_RECORDS_GIUWS010
     (p_dist_no    IN GIUW_POL_DIST.dist_no%TYPE,
      p_policy_id  IN GIPI_POLBASIC.policy_id%TYPE,
      p_line_cd    IN GIPI_POLBASIC.line_cd%TYPE,
      p_subline_cd IN GIPI_POLBASIC.subline_cd%TYPE)
      
    IS
      v_frps_exist            BOOLEAN;
      v_line_cd               GIUW_WPERILDS.line_cd%TYPE;
      v_new_dist_tsi          GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_new_dist_prem         GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_new_dist_spct         GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_exist                 VARCHAR2(1) := 'N';
      v_disallow_posting_sw   VARCHAR2(1) := 'N';

    BEGIN

      /* ************************************************************************************* */
      /* Checks for the existence of a facultative share code in each of the DIST_SEQ_NO's of
      ** table GIUW_WPOLICYDS_DTL.  If the said share code exists for a particular DIST_SEQ_NO,
      ** then procedure will check for an existing record in RI table GIRI_WDISTFRPS and update
      ** such record in accordance with the values taken in by table GIUW_WPOLICYDS_DTL.  Should
      ** table GIRI_WDISTFRPS contain no entries with regards to the current DIST_SEQ_NO with the
      ** facultative share, then a record shall be created against the said table.
      ** On the other hand, if a facultative share does not exist for a particular DIST_SEQ_NO,
      ** then procedure will delete any related records in RI tables GIRI_WBINDER_PERIL,
      ** GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI, and GIRI_WDISTFRPS.
      ** NOTE:  A VALID facultative share must not have a zero DIST_TSI and a zero DIST_PREM.
      ** Modified by:  Crystal 12/28/1998  */
      /* ************************************************************************************ */

      FOR c1 IN (SELECT C1306.dist_seq_no , C1306.tsi_amt    , C1306.prem_amt ,
                        B140.currency_cd  , B140.currency_rt , C080.user_id
                   FROM GIUW_WPOLICYDS C1306,
                        GIUW_POL_DIST C080,
                        GIPI_INVOICE B140
                  WHERE B140.item_grp  = C1306.item_grp
                    AND B140.policy_id = C080.policy_id
                    AND C080.dist_no   = C1306.dist_no
                    AND C1306.dist_no  = p_dist_no)
      LOOP
        BEGIN

          /* Get the LINE_CD for the particular DIST_SEQ_NO
          ** for use in retrieving the correct data from
          ** GIUW_WPOLICYDS_DTL. */
          FOR c100 IN (SELECT line_cd
                         FROM GIUW_WPERILDS
                        WHERE dist_seq_no = c1.dist_seq_no
                          AND dist_no     = p_dist_no)
          LOOP
            v_line_cd := c100.line_cd;
            EXIT;
          END LOOP;

          v_exist := 'N';
          FOR c200 IN (SELECT dist_prem , dist_spct , dist_tsi
                       FROM GIUW_WPOLICYDS_DTL
                      WHERE share_cd    = '999'
                        AND line_cd     = v_line_cd
                        AND dist_seq_no = c1.dist_seq_no
                        AND dist_no     = p_dist_no)
          LOOP
            v_exist         := 'Y';
            v_new_dist_prem := c200.dist_prem;
            v_new_dist_spct := c200.dist_spct;
            v_new_dist_tsi  := c200.dist_tsi;
            EXIT;
          END LOOP;
          IF v_exist = 'N' THEN
             RAISE NO_DATA_FOUND;
          END IF;

          IF v_new_dist_tsi  = 0 AND
             v_new_dist_prem = 0 THEN

             /* Sets the distribution flag of table GIUW_WPOLICYDS to
             ** 1, signifying that the current DIST_SEQ_NO is not yet
             ** properly distributed. */
             UPDATE GIUW_WPOLICYDS
                SET dist_flag =  '1'
              WHERE dist_seq_no = c1.dist_seq_no
                AND dist_no     = p_dist_no;

          END IF;

          IF v_new_dist_tsi  != 0 OR 
             v_new_dist_prem != 0 THEN

             /* Checks for an existing record corresponding to
             ** the given DIST_SEQ_NO in table GIRI_WDISTFRPS. */
             v_frps_exist := CHECK_FOR_EXISTING_FRPS(p_dist_no, c1.dist_seq_no);

             IF NOT v_frps_exist THEN

                /* Creates a new record in table GIRI_WDISTFRPS in
                ** accordance with the data taken in by table
                ** GIUW_WPOLICYDS_DTL. */
                GIUW_POL_DIST_FINAL_PKG.CRTE_RI_NEW_WDISTFRPS_GIUWS010
                      (p_dist_no       , c1.dist_seq_no , c1.tsi_amt      ,
                       c1.prem_amt     , v_new_dist_tsi , v_new_dist_prem ,
                       v_new_dist_spct , c1.currency_cd , c1.currency_rt  ,
                       c1.user_id      , p_policy_id    , p_line_cd       ,
                       p_subline_cd);

             ELSE

                /* Updates the existing record of table 
                ** GIRI_WDISTFRPS in accordance with the
                ** data taken in by table GIUW_WPOLICYDS_DTL. */            
                UPDATE_RI_WDISTFRPS
                      (p_dist_no       , c1.dist_seq_no , c1.tsi_amt      ,
                       c1.prem_amt     , v_new_dist_tsi , v_new_dist_prem , 
                       v_new_dist_spct , c1.currency_cd , c1.currency_rt  ,
                       c1.user_id);

             END IF;
          ELSE

             /* Delete related records in RI tables GIRI_WBINDER_PERIL,
             ** GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI, and 
             ** GIRI_WDISTFRPS. */
             DELETE_RI_TABLES(p_dist_no, c1.dist_seq_no);

          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN

            /* Delete related records in RI tables GIRI_WBINDER_PERIL,
            ** GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI, and 
            ** GIRI_WDISTFRPS. */
            DELETE_RI_TABLES(p_dist_no, c1.dist_seq_no);

        END;
      END LOOP;

    END;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    CREATE_PERIL_DFLT_DIST Program Unit from GIUWS010
    **/

     PROCEDURE CRTE_PERIL_DFLT_DIST_GIUWS010
        (p_dist_no         IN GIUW_WPOLICYDS.dist_no%TYPE,
         p_dist_seq_no     IN GIUW_WPOLICYDS.dist_seq_no%TYPE,
         p_dist_flag       IN GIUW_WPOLICYDS.dist_flag%TYPE,
         p_policy_tsi      IN GIUW_WPOLICYDS.tsi_amt%TYPE,
         p_policy_premium  IN GIUW_WPOLICYDS.prem_amt%TYPE,
         p_policy_ann_tsi  IN GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
         p_item_grp        IN GIUW_WPOLICYDS.item_grp%TYPE, 
         p_line_cd         IN GIIS_LINE.line_cd%TYPE,
         p_default_no      IN GIIS_DEFAULT_DIST.default_no%TYPE,
         p_default_type    IN GIIS_DEFAULT_DIST.default_type%TYPE,
         p_dflt_netret_pct IN GIIS_DEFAULT_DIST.dflt_netret_pct%TYPE,
         p_currency_rt     IN GIPI_ITEM.currency_rt%TYPE,
         p_policy_id       IN GIPI_POLBASIC.policy_id%TYPE) IS

      v_peril_cd              GIIS_PERIL.peril_cd%TYPE;
      v_peril_tsi             GIUW_WPERILDS.tsi_amt%TYPE      := 0;
      v_peril_premium         GIUW_WPERILDS.prem_amt%TYPE     := 0;
      v_peril_ann_tsi         GIUW_WPERILDS.ann_tsi_amt%TYPE  := 0;
      v_exist                 VARCHAR2(1)                     := 'N';
      v_insert_sw             VARCHAR2(1)                     := 'N';
      v_dist_flag             GIPI_POLBASIC.dist_flag%TYPE;
      
      /* Updates the amounts of the previously processed PERIL_CD
      ** while looping inside cursor C3.  After which, the records
      ** for table GIUW_WPERILDS_DTL are also created.
      ** NOTE:  This is a LOCAL PROCEDURE BODY called below. */
      
      PROCEDURE  UPD_CREATE_WPERIL_DTL_DATA IS
      BEGIN
        UPDATE GIUW_WPERILDS
           SET tsi_amt     = v_peril_tsi     ,
               prem_amt    = v_peril_premium ,
               ann_tsi_amt = v_peril_ann_tsi
         WHERE peril_cd    = v_peril_cd
           AND line_cd     = p_line_cd
           AND dist_seq_no = p_dist_seq_no
           AND dist_no     = p_dist_no;
        
        GIUW_POL_DIST_FINAL_PKG.CRTE_PERL_DFLT_WPERILDS_GWS010
              (p_dist_no       , p_dist_seq_no , p_line_cd       ,
               v_peril_cd      , v_peril_tsi   , v_peril_premium ,
               v_peril_ann_tsi , p_currency_rt , p_default_no    ,
               p_default_type  , p_dflt_netret_pct);
      END;

    BEGIN

        /* Create records in table GIUW_WPOLICYDS and GIUW_WPOLICYDS_DTL
        ** for the specified DIST_SEQ_NO. */
        INSERT INTO  GIUW_WPOLICYDS
                    (dist_no      , dist_seq_no      , dist_flag        ,
                     tsi_amt      , prem_amt         , ann_tsi_amt      ,
                     item_grp)
             VALUES (p_dist_no    , p_dist_seq_no    , p_dist_flag      ,
                     p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                     p_item_grp);

        /* Get the amounts for each item in table GIPI_ITEM in preparation
        ** for data insertion to its corresponding distribution tables. */
        
        -- lian 111501
          FOR a IN (SELECT dist_flag
                              FROM GIUW_POL_DIST
                              WHERE policy_id = (SELECT policy_id
                                                 FROM GIUW_POL_DIST
                                                 WHERE dist_no = p_dist_no)
                                AND dist_flag = 5) LOOP
              v_dist_flag := a.dist_flag;      
              EXIT;                        
          END LOOP;
      
          IF v_dist_flag = 5 THEN 
                             
                FOR c2 IN (SELECT c.item_no     , a.tsi_amt , (a.prem_amt - SUM(c.dist_prem)) prem_amt ,
                                  a.ann_tsi_amt
                           FROM GIPI_ITEM a, GIUW_ITEMPERILDS_DTL c
                           WHERE EXISTS( SELECT '1'
                                        FROM GIPI_ITMPERIL b
                                        WHERE b.policy_id = a.policy_id
                                        AND b.item_no   = a.item_no)
                           AND a.item_no     = c.item_no
                           AND a.item_grp    = p_item_grp
                           AND a.policy_id   = p_policy_id
                           AND c.dist_seq_no = p_dist_seq_no
                           AND c.dist_no IN (SELECT dist_no
                                             FROM GIUW_POL_DIST
                                             WHERE policy_id = p_policy_id
                                             AND dist_flag IN (2,3)) 
                           GROUP BY c.item_no, a.tsi_amt, a.prem_amt, a.ann_tsi_amt)
                         
                         /*SELECT a.item_no     , a.tsi_amt , a.prem_amt ,
                          a.ann_tsi_amt
                     FROM gipi_item a
                    WHERE exists( SELECT '1'
                                    FROM gipi_itmperil b
                                   WHERE b.policy_id = a.policy_id
                                     AND b.item_no = a.item_no)
                      AND a.item_grp  = p_item_grp
                      AND a.policy_id = p_policy_id)*/
        LOOP

          /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL
          ** for the specified DIST_SEQ_NO. */
          INSERT INTO  GIUW_WITEMDS
                      (dist_no        , dist_seq_no   , item_no        ,
                       tsi_amt        , prem_amt      , ann_tsi_amt)
               VALUES (p_dist_no      , p_dist_seq_no , c2.item_no     ,
                       c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);
        END LOOP;

        /* Initialize the value of the variables
        ** in preparation for processing the new
        ** DIST_SEQ_NO. */
        v_peril_cd      := NULL;
        v_peril_tsi     := 0;
        v_peril_premium := 0;
        v_peril_ann_tsi := 0;   
        v_exist         := 'N';

        /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
        ** in table GIPI_ITMPERIL in preparation for data insertion to 
        ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
        ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
        FOR c3 IN /*(SELECT B380.tsi_amt      itmperil_tsi                                               ,
                                               (B380.prem_amt - SUM(c150.dist_prem)) itmperil_premium ,
                                           B380.ann_tsi_amt  itmperil_ann_tsi                                           ,
                                           B380.item_no      item_no                                                    ,
                                           B380.peril_cd     peril_cd                                                          
                                   FROM gipi_itmperil B380, gipi_item B340,
                                             giuw_itemperilds_dtl C150
                                     WHERE B380.item_no     = B340.item_no
                                       AND B380.policy_id   = B340.policy_id
                                       AND B340.item_no     = C150.item_no
                                       AND B380.peril_cd    = C150.peril_cd
                                       AND B380.line_cd     = C150.line_cd
                                       AND B340.policy_id   = p_policy_id
                                       AND C150.dist_seq_no = p_dist_seq_no
                                       AND B340.item_grp       = p_item_grp
                                       AND C150.dist_no IN (SELECT dist_no
                                                                                 FROM giuw_pol_dist
                                                                                    WHERE policy_id = p_policy_id
                                                                                         AND dist_flag IN (2,3))
                             GROUP BY B380.tsi_amt, B380.ann_tsi_amt, B380.item_no, 
                                               B380.peril_cd, B340.pack_line_cd, B380.prem_amt
                             ORDER BY B380.peril_cd)*/ 
        
                            (SELECT B380.tsi_amt     itmperil_tsi     ,
                            B380.prem_amt    itmperil_premium ,
                            B380.ann_tsi_amt itmperil_ann_tsi ,
                            B380.item_no     item_no          ,
                            B380.peril_cd    peril_cd
                       FROM GIPI_ITMPERIL B380, GIPI_ITEM B340
                      WHERE B380.item_no   = B340.item_no
                        AND B380.policy_id = B340.policy_id
                        AND B340.item_grp  = p_item_grp
                        AND B340.policy_id = p_policy_id
                   ORDER BY B380.peril_cd)
        LOOP
          v_exist     := 'Y';

          /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
          ** for the specified DIST_SEQ_NO. */
          INSERT INTO  GIUW_WITEMPERILDS  
                      (dist_no             , dist_seq_no   , item_no         ,
                       peril_cd            , line_cd       , tsi_amt         ,
                       prem_amt            , ann_tsi_amt)
               VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                       c3.peril_cd         , p_line_cd     , c3.itmperil_tsi ,
                       /*p_policy_premium*/c3.itmperil_premium , c3.itmperil_ann_tsi);

          /* Create the newly processed PERIL_CD in table
          ** GIUW_WPERILDS. */
          IF v_peril_cd IS NULL THEN
             v_peril_cd     := c3.peril_cd;
             v_insert_sw    := 'Y';
          END IF;

          /* Check if the value of the previously processed
          ** PERIL_CD is equal to the one currently processed.
          ** Should the two be unequal, then the amounts of
          ** the previously processed PERIL_CD must be updated
          ** to reflect the true value of each field for the
          ** specified PERIL_CD.  After the amounts of the specified
          ** PERIL_CD have been updated, then that's the time to
          ** create the records in table GIUW_WPERILDS_DTL.
          ** On the other hand, if the value of the two PERIL_CDs
          ** are equal, then the amounts of the currently processed
          ** record is added along with the amounts of the previously
          ** processed records of the same PERIL_CD.  Such amounts
          ** shall be used later on when the two PERIL_CDs become
          ** unequal. */
          IF v_peril_cd != c3.peril_cd THEN

             /* Updates the amounts of the previously processed PERIL_CD.
             ** After which, the records for table GIUW_WPERILDS_DTL are
             ** also created. */
             UPD_CREATE_WPERIL_DTL_DATA;

             /* Assigns the new PERIL_CD to the V_PERIL_CD
             ** variable in preparation for data creation
             ** in table GIUW_WPERILDS. */
             v_peril_cd      := c3.peril_cd;
             v_peril_tsi     := c3.itmperil_tsi;
             v_peril_premium := p_policy_premium;
             v_peril_ann_tsi := c3.itmperil_ann_tsi;
             v_insert_sw     := 'Y';

          ELSIF v_peril_cd = c3.peril_cd THEN
             v_peril_tsi     := v_peril_tsi     + c3.itmperil_tsi;
             v_peril_premium := v_peril_premium + p_policy_premium;
             v_peril_ann_tsi := v_peril_ann_tsi + c3.itmperil_ann_tsi;
          END IF;
          IF v_insert_sw = 'Y' THEN
             INSERT INTO  GIUW_WPERILDS  
                         (dist_no   , dist_seq_no   , peril_cd         ,
                          line_cd   , tsi_amt       , prem_amt         ,
                          ann_tsi_amt)
                  VALUES (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                          p_line_cd , v_peril_tsi   , v_peril_premium  ,
                          v_peril_ann_tsi);
             v_insert_sw     := 'N';
          END IF;

        END LOOP;
        IF v_exist = 'Y' THEN

           /* Updates the amounts of the last processed PERIL_CD.
           ** After which, its corresponding records for table 
           ** GIUW_WPERILDS_DTL are also created.
           ** NOTE:  This was done so, because the last processed
           **        PERIL_CD is no longer handled by the C3 loop. */
           UPD_CREATE_WPERIL_DTL_DATA;

        END IF;

        /* Create records in table GIUW_WITEMDS_DTL based on
        ** the values inserted to table GIUW_WITEMPERILDS_DTL. */
        CREATE_PERIL_DFLT_WITEMDS  (p_dist_no, p_dist_seq_no);

        /* Create records in table GIUW_WPOLICYDS_DTL based on
        ** the values inserted to table GIUW_WITEMDS_DTL. */
        CREATE_PERIL_DFLT_WPOLICYDS(p_dist_no, p_dist_seq_no);
        
        ELSE -- dist_flag
            FOR c2 IN (SELECT a.item_no     , a.tsi_amt , a.prem_amt ,
                            a.ann_tsi_amt
                       FROM GIPI_ITEM a
                      WHERE exists( SELECT '1'
                                      FROM GIPI_ITMPERIL b
                                     WHERE b.policy_id = a.policy_id
                                       AND b.item_no = a.item_no)
                        AND a.item_grp  = p_item_grp
                        AND a.policy_id = p_policy_id)
        LOOP

          /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL
          ** for the specified DIST_SEQ_NO. */
          INSERT INTO  GIUW_WITEMDS
                      (dist_no        , dist_seq_no   , item_no        ,
                       tsi_amt        , prem_amt      , ann_tsi_amt)
               VALUES (p_dist_no      , p_dist_seq_no , c2.item_no     ,
                       c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);
        END LOOP;

        /* Initialize the value of the variables
        ** in preparation for processing the new
        ** DIST_SEQ_NO. */
        v_peril_cd      := NULL;
        v_peril_tsi     := 0;
        v_peril_premium := 0;
        v_peril_ann_tsi := 0;   
        v_exist         := 'N';

        /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
        ** in table GIPI_ITMPERIL in preparation for data insertion to 
        ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
        ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
        FOR c3 IN (SELECT B380.tsi_amt     itmperil_tsi     ,
                          B380.prem_amt    itmperil_premium ,
                          B380.ann_tsi_amt itmperil_ann_tsi ,
                          B380.item_no     item_no          ,
                          B380.peril_cd    peril_cd
                     FROM GIPI_ITMPERIL B380, GIPI_ITEM B340
                    WHERE B380.item_no   = B340.item_no
                      AND B380.policy_id = B340.policy_id
                      AND B340.item_grp  = p_item_grp
                      AND B340.policy_id = p_policy_id
                 ORDER BY B380.peril_cd)
        LOOP
          v_exist     := 'Y';

          /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
          ** for the specified DIST_SEQ_NO. */
          INSERT INTO  GIUW_WITEMPERILDS  
                      (dist_no             , dist_seq_no   , item_no         ,
                       peril_cd            , line_cd       , tsi_amt         ,
                       prem_amt            , ann_tsi_amt)
               VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                       c3.peril_cd         , p_line_cd     , c3.itmperil_tsi ,
                       c3.itmperil_premium , c3.itmperil_ann_tsi);

          /* Create the newly processed PERIL_CD in table
          ** GIUW_WPERILDS. */
          IF v_peril_cd IS NULL THEN
             v_peril_cd     := c3.peril_cd;
             v_insert_sw    := 'Y';
          END IF;

          /* Check if the value of the previously processed
          ** PERIL_CD is equal to the one currently processed.
          ** Should the two be unequal, then the amounts of
          ** the previously processed PERIL_CD must be updated
          ** to reflect the true value of each field for the
          ** specified PERIL_CD.  After the amounts of the specified
          ** PERIL_CD have been updated, then that's the time to
          ** create the records in table GIUW_WPERILDS_DTL.
          ** On the other hand, if the value of the two PERIL_CDs
          ** are equal, then the amounts of the currently processed
          ** record is added along with the amounts of the previously
          ** processed records of the same PERIL_CD.  Such amounts
          ** shall be used later on when the two PERIL_CDs become
          ** unequal. */
          IF v_peril_cd != c3.peril_cd THEN

             /* Updates the amounts of the previously processed PERIL_CD.
             ** After which, the records for table GIUW_WPERILDS_DTL are
             ** also created. */
             UPD_CREATE_WPERIL_DTL_DATA;

             /* Assigns the new PERIL_CD to the V_PERIL_CD
             ** variable in preparation for data creation
             ** in table GIUW_WPERILDS. */
             v_peril_cd      := c3.peril_cd;
             v_peril_tsi     := c3.itmperil_tsi;
             v_peril_premium := c3.itmperil_premium;
             v_peril_ann_tsi := c3.itmperil_ann_tsi;
             v_insert_sw     := 'Y';

          ELSIF v_peril_cd = c3.peril_cd THEN
             v_peril_tsi     := v_peril_tsi     + c3.itmperil_tsi;
             v_peril_premium := v_peril_premium + c3.itmperil_premium;
             v_peril_ann_tsi := v_peril_ann_tsi + c3.itmperil_ann_tsi;
          END IF;
          IF v_insert_sw = 'Y' THEN
             INSERT INTO  GIUW_WPERILDS  
                         (dist_no   , dist_seq_no   , peril_cd         ,
                          line_cd   , tsi_amt       , prem_amt         ,
                          ann_tsi_amt)
                  VALUES (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                          p_line_cd , v_peril_tsi   , v_peril_premium  ,
                          v_peril_ann_tsi);
             v_insert_sw     := 'N';
          END IF;

        END LOOP;
        IF v_exist = 'Y' THEN

           /* Updates the amounts of the last processed PERIL_CD.
           ** After which, its corresponding records for table 
           ** GIUW_WPERILDS_DTL are also created.
           ** NOTE:  This was done so, because the last processed
           **        PERIL_CD is no longer handled by the C3 loop. */
           UPD_CREATE_WPERIL_DTL_DATA;

        END IF;

        /* Create records in table GIUW_WITEMDS_DTL based on
        ** the values inserted to table GIUW_WITEMPERILDS_DTL. */
        CREATE_PERIL_DFLT_WITEMDS  (p_dist_no, p_dist_seq_no);

        /* Create records in table GIUW_WPOLICYDS_DTL based on
        ** the values inserted to table GIUW_WITEMDS_DTL. */
        CREATE_PERIL_DFLT_WPOLICYDS(p_dist_no, p_dist_seq_no);
        END IF;
    END;

    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    CREATE_POLICY_DIST_RECS Program Unit from GIUWS010
    **/
    
     PROCEDURE CRTE_POLICY_DIST_RECS_GIUWS010
      (p_dist_no       IN   GIUW_POL_DIST.dist_no%TYPE,
       p_policy_id     IN   GIPI_POLBASIC.policy_id%TYPE,
       p_line_cd       IN   GIPI_POLBASIC.line_cd%TYPE,
       p_subline_cd    IN   GIPI_POLBASIC.subline_cd%TYPE,
       p_iss_cd        IN   GIPI_POLBASIC.iss_cd%TYPE,
       p_pack_pol_flag IN   GIPI_POLBASIC.pack_pol_flag%TYPE) IS

       v_line_cd             GIPI_POLBASIC.line_cd%TYPE;
       v_subline_cd          GIPI_POLBASIC.subline_cd%TYPE;
       v_dist_seq_no         GIUW_WPOLICYDS.dist_seq_no%TYPE := 0;
      --rg_id                 RECORDGROUP;
       rg_name               VARCHAR2(20) := 'DFLT_DIST_VALUES';
       rg_count              NUMBER;
       v_exist               VARCHAR2(1);
       v_errors              NUMBER;
       v_default_no          GIIS_DEFAULT_DIST.default_no%TYPE;
       v_default_type        GIIS_DEFAULT_DIST.default_type%TYPE;
       v_dflt_netret_pct     GIIS_DEFAULT_DIST.dflt_netret_pct%TYPE;
       v_dist_type           GIIS_DEFAULT_DIST.dist_type%TYPE;
       v_post_flag           VARCHAR2(1)  := 'O';
       v_package_policy_sw   VARCHAR2(1)  := 'Y';
       v_dist_flag           GIPI_POLBASIC.dist_flag%TYPE;
       v_item_grp            GIUW_POL_DIST.item_grp%TYPE;
       v_exist2              VARCHAR2(1) := 'N'; --edgar 09/09/2014
       v_err_exists          VARCHAR2(1) ; -- jhing 12.11.2014 

    BEGIN
        BEGIN
            SELECT NVL(item_grp,1)
              INTO v_item_grp
              FROM GIUW_POL_DIST
             WHERE policy_id = p_policy_id
               AND dist_no = p_dist_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
        END;
        
      /* Get the unique ITEM_GRP to produce a unique DIST_SEQ_NO for each. */
      
      FOR a IN (SELECT dist_flag
                FROM GIUW_POL_DIST
                WHERE policy_id = (SELECT policy_id
                                   FROM GIUW_POL_DIST
                                   WHERE dist_no = p_dist_no)
                AND dist_flag = 5) 
      LOOP
          v_dist_flag := a.dist_flag;                              
      END LOOP;
      
      IF v_dist_flag = 5 THEN -- this means naredistribute si policy. 
          /*added edgar 09/09/2014 so that policy with at least one item that has zero TSI and Prem is distributed using One-Risk only*/
          FOR i IN (SELECT item_no,
                          SUM(tsi_amt)     policy_tsi      ,
                          SUM(prem_amt)    policy_premium  ,
                          SUM(ann_tsi_amt) policy_ann_tsi  
                     FROM GIPI_ITEM a
                    WHERE policy_id = p_policy_id
                      AND EXISTS (SELECT 1
                                    FROM GIPI_ITMPERIL
                                   WHERE policy_id = a.policy_id
                                     AND item_no = a.item_no)
                    GROUP BY item_no)
          LOOP
            IF i.policy_tsi = 0 AND i.policy_premium = 0 THEN
                v_exist2 := 'Y';
                EXIT;
            END IF; 
          END LOOP;       
          
        
        -- jhing 11.25.2014 commented out the whole block. post_flag and default distribution variables will be retrieved after DS tables has been populated 
        /*FOR pol IN (SELECT a.pol_flag, b.par_type
                        FROM gipi_polbasic a, gipi_parlist b
                       WHERE a.policy_id = p_policy_id
                         AND a.par_id = b.par_id)
          LOOP
              BEGIN
                IF pol.pol_flag = '2' THEN
                    FOR post IN (SELECT post_flag , dist_flag
                                   FROM GIUW_POL_DIST 
                                  WHERE dist_no = 
                                         (SELECT MAX(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE policy_id = 
                                                    ( SELECT MAX(old_policy_id) 
                                                        FROM GIPI_POLNREP
                                                       WHERE ren_rep_sw = '1'
                                                         AND new_policy_id = (SELECT policy_id
                                                                                FROM gipi_polbasic
                                                                               WHERE pol_flag <> '5'
                                                                                 AND policy_id = p_policy_id))))
                    LOOP
                        IF post.dist_flag in ( '2', '3' ) THEN 
                            v_post_flag := post.post_flag;
                        END IF; 
                    END LOOP;
                     
                ELSIF pol.par_type = 'E' THEN                                                    
                   FOR post IN (SELECT post_flag , dist_flag
                                  --INTO v_post_flag
                                  FROM giuw_pol_dist
                                 WHERE dist_no =
                                         (SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE par_id = (SELECT par_id
                                                             FROM gipi_polbasic
                                                            WHERE endt_seq_no = 0
                                                              AND (line_cd,
                                                                   subline_cd,
                                                                   iss_cd,
                                                                   issue_yy,
                                                                   pol_seq_no,
                                                                   renew_no
                                                                  ) =
                                                                     (SELECT line_cd, subline_cd, iss_cd, issue_yy,
                                                                             pol_seq_no, renew_no
                                                                        FROM gipi_polbasic
                                                                       WHERE policy_id = p_policy_id))))
                      LOOP
                        IF post.dist_flag in ( '2', '3' ) THEN 
                            v_post_flag := post.post_flag;
                        END IF;
                      END LOOP;     
                ELSE        
                    v_post_flag := NULL;                                               
                END IF;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_post_flag := NULL;  
              END; 
          EXIT;
          END LOOP;  */ 
          /*ended edgar 09/09/2014*/   
                                  
       FOR c1 IN (SELECT --c.item_no                                                      ,
                       NVL(a.item_grp, 1)  item_grp        ,
                       a.pack_line_cd      pack_line_cd    ,
                       a.pack_subline_cd   pack_subline_cd ,
                       a.currency_rt       currency_rt     ,
                       SUM(a.tsi_amt)      policy_tsi      ,
                       --sum(a.prem_amt - (c.prem_amt)) policy_premium  ,
                            --sum(distinct c.prem_amt) prem_Amt,
                       SUM(a.prem_Amt)-SUM(DISTINCT c.prem_amt) policy_premium  ,                                   
                       SUM(a.ann_tsi_amt)                                 policy_ann_tsi  
               FROM GIPI_ITEM a, GIUW_POL_DIST c --giuw_itemds_dtl c
                 WHERE a.policy_id = p_policy_id
                   AND a.policy_id = c.policy_id 
                   AND EXISTS (SELECT 1
                                FROM GIPI_ITMPERIL b
                             WHERE b.policy_id = a.policy_id
                               AND b.item_no   = a.item_no)
                   --AND c.dist_no IN (SELECT dist_no
                    --                                    FROM giuw_pol_dist
                    --                                      WHERE policy_id = p_policy_id
                    AND c.dist_flag IN (2,3)
                    --AND a.item_no   = c.item_no                 
               GROUP BY a.item_grp , a.pack_line_cd , a.pack_subline_cd ,
                     a.currency_rt
                     ORDER BY a.item_grp, a.pack_line_cd , a.pack_subline_cd , a.currency_rt /* jhing 12.11.2014 added order by */ ) 
      
                           /*SELECT NVL(item_grp, 1) item_grp        ,
                          pack_line_cd     pack_line_cd    ,
                          pack_subline_cd  pack_subline_cd ,
                          currency_rt      currency_rt     ,
                          SUM(tsi_amt)     policy_tsi      ,
                          SUM(prem_amt)    policy_premium  ,
                          SUM(ann_tsi_amt) policy_ann_tsi  
                     FROM gipi_item a
                    WHERE policy_id = p_policy_id
                      --AND (prem_amt != 0
                      -- OR  tsi_amt  != 0)
                      AND EXISTS (SELECT 1
                                    FROM gipi_itmperil
                                   WHERE policy_id = a.policy_id
                                     AND item_no = a.item_no)
                    GROUP BY item_grp , pack_line_cd , pack_subline_cd ,
                          currency_rt)*/
      LOOP

        /* If the POLICY processed is a package policy
        ** then get the true LINE_CD and true SUBLINE_CD,
        ** that is, the PACK_LINE_CD and PACK_SUBLINE_CD 
        ** from the GIPI_ITEM table.
        ** This will be used upon inserting to certain
        ** distribution tables requiring a value for
        ** the similar field. */
        IF p_pack_pol_flag = 'N' THEN
           v_line_cd    := p_line_cd;
           v_subline_cd := p_subline_cd;
        ELSE
           v_line_cd           := c1.pack_line_cd;
           v_subline_cd        := c1.pack_subline_cd;
           v_package_policy_sw := 'Y';
        END IF;

        -- jhing 11.25.2014 commented the whole block retrieval of default dist no would be done in a single procedure call after the DS tables
        -- have been populated
        
        /*        IF v_package_policy_sw = 'Y' THEN
                   FOR c2 IN (SELECT default_no, default_type, dist_type,
                                     dflt_netret_pct
                                FROM GIIS_DEFAULT_DIST
                               WHERE iss_cd     = p_iss_cd
                                 AND subline_cd = v_subline_cd
                                 AND line_cd    = v_line_cd)
                   LOOP
                     v_default_no      := c2.default_no;
                     v_default_type    := c2.default_type;
                     v_dist_type       := c2.dist_type;
                     v_dflt_netret_pct := c2.dflt_netret_pct;
                     EXIT;
                   END LOOP;
                   IF NVL(v_dist_type, '1') = '1' THEN 
                      /*rg_id := FIND_GROUP(rg_name);
                      IF NOT ID_NULL(rg_id) THEN
                         DELETE_GROUP(rg_id);
                      END IF;
                      rg_id    := CREATE_GROUP_FROM_QUERY(rg_name,
                                  '   SELECT a.line_cd    , a.share_cd , a.share_pct  , '
                               || '          a.share_amt1 , a.peril_cd , a.share_amt2 , '
                               || '          1 true_pct '
                               || '     FROM giis_default_dist_group a '
                               || '    WHERE a.default_no = ' || TO_CHAR(NVL(v_default_no, 0))
                               || '      AND a.line_cd    = ' || '''' || v_line_cd || ''''
                               || '      AND a.share_cd   <> 999 '
                               || ' ORDER BY a.sequence ASC');
                      v_errors := POPULATE_GROUP(rg_id);
                      IF v_errors NOT IN (0, 1403) THEN
                         MESSAGE('Error populating group ' || rg_name || '.', NO_ACKNOWLEDGE);
                         RAISE FORM_TRIGGER_FAILURE;
                      END IF;
                      rg_count := GET_GROUP_ROW_COUNT(rg_id);*/
                      
         /*             rg_count := 0;
                      
                      FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  ,
                                       a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                       1 true_pct 
                                FROM GIIS_DEFAULT_DIST_GROUP a 
                                WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
                                AND a.line_cd    = v_line_cd
                               AND a.share_cd   <> 999 
                               ORDER BY a.sequence ASC)
                      LOOP
                        rg_count := c.rownum;
                      END LOOP;
                   ELSIF v_dist_type = '2' AND v_post_flag = 'O' THEN --edgar 09/10//2014
                      rg_count := 0;   --edgar 09/10/2014           
                   END IF;
                   v_package_policy_sw := 'N';
                ELSE /*added edgar 09/09/2014*/
       /*            FOR c2 IN (SELECT default_no, default_type, dist_type,
                                     dflt_netret_pct
                                FROM GIIS_DEFAULT_DIST
                               WHERE iss_cd     = p_iss_cd
                                 AND subline_cd = v_subline_cd
                                 AND line_cd    = v_line_cd)
                   LOOP
                     v_default_no      := c2.default_no;
                     v_default_type    := c2.default_type;
                     v_dist_type       := c2.dist_type;
                     v_dflt_netret_pct := c2.dflt_netret_pct;
                     EXIT;
                   END LOOP;
                   IF NVL(v_dist_type, '1') = '1' AND v_post_flag = 'O' THEN
                      rg_count := 0;
                      
                      FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  ,
                                       a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                       1 true_pct 
                                FROM GIIS_DEFAULT_DIST_GROUP a 
                                WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
                                AND a.line_cd    = v_line_cd
                               AND a.share_cd   <> 999 
                               ORDER BY a.sequence ASC)
                      LOOP
                        rg_count := c.rownum;
                      END LOOP;
                   ELSIF v_dist_type = '2' AND v_post_flag = 'O' THEN
                      rg_count := 0;
                   END IF;
                   v_package_policy_sw := 'N';       
                   /*ended edgar 09/09/2014*/             
      /*          END IF;  */

        /* Generate a new DIST_SEQ_NO for the new
        ** item group. */
        v_dist_seq_no := v_dist_seq_no + 1;
        
        --  jhing 11.25.2014 commented out conditions in calling CREATE_GRP_DFLT_DIST_GIUWS010 and CRTE_PERIL_DFLT_DIST_GIUWS010.
        --  regardless of default distribution, just call one procedure to populate the DS tables. The DTL 
        -- tables will be populated in another procedure         
        
        GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_GIUWS010
                     (p_dist_no      , v_dist_seq_no     , '2'               ,
                      c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                      c1.item_grp    , v_line_cd         , rg_count          ,
                      v_default_type , c1.currency_rt    , p_policy_id, v_default_no);  
                      
        -- jhing 11.25.2014 commented out 
        /*        /*added edgar 09/08/2014*/
        /*        IF v_exist2 = 'Y' THEN
                       v_post_flag := 'O';
                       GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_GIUWS010
                             (p_dist_no      , v_dist_seq_no     , '2'               ,
                              c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                              c1.item_grp    , v_line_cd         , rg_count          ,
                              v_default_type , c1.currency_rt    , p_policy_id, v_default_no);        
                ELSE
                /*ended edgar 09/08/2014*/
        /*            IF NVL(v_dist_type, '1') = '1' AND v_post_flag = 'O' THEN --added post_flag edgar 09/09/2014
                       v_post_flag := 'O';
                       GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_GIUWS010
                             (p_dist_no      , v_dist_seq_no     , '2'               ,
                              c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                              c1.item_grp    , v_line_cd         , rg_count          ,
                              v_default_type , c1.currency_rt    , p_policy_id, v_default_no);
                    /*added edgar 09/09/2014*/
        /*            ELSIF NVL(v_dist_type, '1') = '1' AND v_post_flag = 'P' THEN  
                       v_post_flag := 'P';
                       v_default_type := 0;
                       GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_DIST_GIUWS010
                             (p_dist_no      , v_dist_seq_no     , '2'               ,
                              c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                              c1.item_grp    , v_line_cd         , v_default_no      ,
                              v_default_type , v_dflt_netret_pct , c1.currency_rt    ,
                              p_policy_id);            
                    ELSIF NVL(v_dist_type, '1') = '2' AND v_post_flag = 'O' THEN
                       v_post_flag := 'O';
                       GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_GIUWS010
                             (p_dist_no      , v_dist_seq_no     , '2'               ,
                              c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                              c1.item_grp    , v_line_cd         , rg_count          ,
                              v_default_type , c1.currency_rt    , p_policy_id, v_default_no);            
                    /*ended edgar 09/09/2014*/
        /*            ELSIF NVL(v_dist_type,'1') = '2' AND v_post_flag = 'P' THEN --added post_flag edgar 09/09/2014 -- jhing 11.24.2014 added nvl
                       v_post_flag := 'P';
                       GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_DIST_GIUWS010
                             (p_dist_no      , v_dist_seq_no     , '2'               ,
                              c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                              c1.item_grp    , v_line_cd         , v_default_no      ,
                              v_default_type , v_dflt_netret_pct , c1.currency_rt    ,
                              p_policy_id);
                    /*added edgar 09/17/2014*/
        /*            ELSIF NVL(v_dist_type,'1') = '1' AND v_post_flag IS NULL THEN  -- jhing 11.24.2014 added NVL
                       v_post_flag := 'O';
                       GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_GIUWS010
                             (p_dist_no      , v_dist_seq_no     , '2'               ,
                              c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                              c1.item_grp    , v_line_cd         , rg_count          ,
                              v_default_type , c1.currency_rt    , p_policy_id, v_default_no);
                    ELSIF NVL(v_dist_type,'1') = '2' AND v_post_flag IS NULL THEN  
                       v_post_flag := 'P';
                       GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_DIST_GIUWS010
                             (p_dist_no      , v_dist_seq_no     , '2'               ,
                              c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                              c1.item_grp    , v_line_cd         , v_default_no      ,
                              v_default_type , v_dflt_netret_pct , c1.currency_rt    ,
                              p_policy_id);                      
                    /*ended edgar 09/17/2014*/
      /*              END IF;
                END IF;--edgar 09/10/2014     */       
        
      END LOOP;
      /*IF NOT ID_NULL(rg_id) THEN
         DELETE_GROUP(rg_id);
      END IF;*/

      /* Adjust computational floats to equalize the amounts
      ** attained by the master tables with that of its detail
      ** tables.
      ** Tables involved:  GIUW_WPERILDS     - GIUW_WPERILDS_DTL
      **                   GIUW_WPOLICYDS    - GIUW_WPOLICYDS_DTL
      **                   GIUW_WITEMDS      - GIUW_WITEMDS_DTL
      **                   GIUW_WITEMPERILDS - GIUW_WITEMPERILDS_DTL */
      --ADJUST_NET_RET_IMPERFECTION(p_dist_no); --edgar 09/15/2014
      
      -- jhing 11.26.2014 commented out. Adjustment will be called in the 
      -- procedure for population of default distribution 
      /*added edgar for new adjustments*/
      --  IF  NVL(v_post_flag,'O') = 'O' THEN
      --      GIUW_POL_DIST_PKG.ADJUST_ALL_WTABLES_GIUWS004(p_dist_no);
      --  ELSIF v_post_flag = 'P' THEN
      --      ADJUST_DISTRIBUTION_PERIL_PKG.ADJUST_DISTRIBUTION(p_dist_no);
      --  END IF;
      /*ended edgar 09/15/2014*/ 
      
      -- jhing 11.26.2014 for redistribution only, adjust the other DS tables.  
      GIUW_POL_DIST_FINAL_PKG.update_dist_ds_prem (p_dist_no, p_policy_id);  

      -- jhing 12.11.2014 validate if there are missing distribution records against GIPI_ITMPERIL. 
       v_err_exists := 'N' ;
      GIUW_POL_DIST_FINAL_PKG.check_missing_dist_rec_item (p_dist_no, p_policy_id , v_err_exists );
      IF v_err_exists = 'Y' THEN
           RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#There are missing distribution records. Please recreate the items before re-grouping the records.'); 
      END IF;           
              
      -- jhing 11.26.2014 call the new procedure for populating default distribution 
      GIUW_POL_DIST_FINAL_PKG.POPULATE_DEFAULT_DIST ( p_dist_no, v_post_flag, v_dist_type );
      
       
      /* Create records in RI tables if a facultative
      ** share exists in any of the DIST_SEQ_NO in table
      ** GIUW_WPOLICYDS_DTL. */
      -- GIUW_POL_DIST_FINAL_PKG.CREATE_RI_RECORDS_GIUWS010(p_dist_no, p_policy_id, p_line_cd, p_subline_cd); -- jhing 11.21.2014 commented out for FULLWEB SIT SR # 3723

      /* Set the value of the DIST_FLAG back 
      ** to Undistributed after recreation. */
     
      UPDATE GIUW_POL_DIST
         SET dist_flag = '1',
             post_flag = v_post_flag,
             dist_type = '1' ,
             special_dist_sw = 'N'
       WHERE policy_id = p_policy_id
         AND dist_no   = p_dist_no;

      ELSE -- dist_flag
          /*added edgar 09/09/2014 so that policy with at least one item that has zero TSI and Prem is distributed using One-Risk only*/
          FOR i IN (SELECT item_no,
                          SUM(tsi_amt)     policy_tsi      ,
                          SUM(prem_amt)    policy_premium  ,
                          SUM(ann_tsi_amt) policy_ann_tsi  
                     FROM GIPI_ITEM a
                    WHERE policy_id = p_policy_id
                      AND EXISTS (SELECT 1
                                    FROM GIPI_ITMPERIL
                                   WHERE policy_id = a.policy_id
                                     AND item_no = a.item_no)
                    GROUP BY item_no)
          LOOP
            IF i.policy_tsi = 0 AND i.policy_premium = 0 THEN
                v_exist2 := 'Y';
                EXIT;
            END IF; 
          END LOOP; 
          
         -- jhing 11.25.2014 commented out the whole block. Will populate the post_flag and the default distribution variables after the DS tables 
         -- has been populated.         
                
        /*  FOR pol IN (SELECT a.pol_flag, b.par_type
                        FROM gipi_polbasic a, gipi_parlist b
                       WHERE a.policy_id = p_policy_id
                         AND a.par_id = b.par_id)
          LOOP
              BEGIN
                IF pol.pol_flag = '2' THEN
                    FOR post IN (SELECT post_flag , dist_flag
                                   FROM GIUW_POL_DIST 
                                  WHERE dist_no = 
                                         (SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE policy_id = 
                                                    ( SELECT MAX(old_policy_id) 
                                                        FROM GIPI_POLNREP
                                                       WHERE ren_rep_sw = '1'
                                                         AND new_policy_id = (SELECT policy_id
                                                                                FROM gipi_polbasic
                                                                               WHERE pol_flag <> '5'
                                                                                 AND policy_id = p_policy_id))))
                    LOOP
                        IF post.dist_flag in ( '2', '3') THEN 
                            v_post_flag := post.post_flag;
                        END IF;
                    END LOOP;
                    
                ELSIF pol.par_type = 'E' THEN                                                    
                    SELECT post_flag, dist_flag
                      INTO v_post_flag, v_temp_dist_flag
                      FROM giuw_pol_dist
                     WHERE dist_no =
                              (SELECT MAX(dist_no) 
                                FROM GIUW_POL_DIST 
                               WHERE par_id = (SELECT par_id
                                                 FROM gipi_polbasic
                                                WHERE endt_seq_no = 0
                                                  AND (line_cd,
                                                       subline_cd,
                                                       iss_cd,
                                                       issue_yy,
                                                       pol_seq_no,
                                                       renew_no
                                                      ) =
                                                         (SELECT line_cd, subline_cd, iss_cd, issue_yy,
                                                                 pol_seq_no, renew_no
                                                            FROM gipi_polbasic
                                                           WHERE policy_id = p_policy_id)));  
                                                           
                      -- jhing 11.25.2014
                      IF v_temp_dist_flag NOT IN ( '2', '3' ) THEN
                        v_post_flag := NULL;
                      END IF;    
                ELSE        
                    v_post_flag := NULL;    
                END IF;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_post_flag := NULL; 
              END; 
          EXIT;
          END LOOP; */
          /*ended edgar 09/09/2014*/
          
          
          FOR c1 IN (SELECT NVL(item_grp, 1) item_grp        ,
                          pack_line_cd     pack_line_cd    ,
                          pack_subline_cd  pack_subline_cd ,
                          currency_rt      currency_rt     ,
                          SUM(tsi_amt)     policy_tsi      ,
                          SUM(prem_amt)    policy_premium  ,
                          SUM(ann_tsi_amt) policy_ann_tsi  
                     FROM GIPI_ITEM a
                    WHERE policy_id = p_policy_id
                      --AND item_grp = v_item_grp   -- commented out by shan 07.29.2014
                      --AND (prem_amt != 0
                      -- OR  tsi_amt  != 0)
                      AND EXISTS (SELECT 1
                                    FROM GIPI_ITMPERIL
                                   WHERE policy_id = a.policy_id
                                     AND item_no = a.item_no)
                    GROUP BY item_grp , pack_line_cd , pack_subline_cd ,
                          currency_rt
                          ORDER BY item_grp , pack_line_cd , pack_subline_cd , currency_rt /* added by jhing 12.11.2014 */ )
      LOOP

        /* If the POLICY processed is a package policy
        ** then get the true LINE_CD and true SUBLINE_CD,
        ** that is, the PACK_LINE_CD and PACK_SUBLINE_CD 
        ** from the GIPI_ITEM table.
        ** This will be used upon inserting to certain
        ** distribution tables requiring a value for
        ** the similar field. */
        IF p_pack_pol_flag = 'N' THEN
           v_line_cd    := p_line_cd;
           v_subline_cd := p_subline_cd;
        ELSE
           v_line_cd           := c1.pack_line_cd;
           v_subline_cd        := c1.pack_subline_cd;
           v_package_policy_sw := 'Y';
        END IF;
        

     -- jhing 11.25.2014 commented out whole block. Default distribution no. will be setup/populated after the DS tables
     -- have been populated 
     
       /*         IF v_package_policy_sw = 'Y' THEN
                   FOR c2 IN (SELECT default_no, default_type, dist_type,
                                     dflt_netret_pct
                                FROM GIIS_DEFAULT_DIST
                               WHERE iss_cd     = p_iss_cd
                                 AND subline_cd = v_subline_cd
                                 AND line_cd    = v_line_cd)
                   LOOP
                     v_default_no      := c2.default_no;
                     v_default_type    := c2.default_type;
                     v_dist_type       := c2.dist_type;
                     v_dflt_netret_pct := c2.dflt_netret_pct;
                     EXIT;
                   END LOOP;
                   IF NVL(v_dist_type, '1') = '1' THEN
                      /*rg_id := FIND_GROUP(rg_name);
                      IF NOT ID_NULL(rg_id) THEN
                         DELETE_GROUP(rg_id);
                      END IF;
                      rg_id    := CREATE_GROUP_FROM_QUERY(rg_name,
                                  '   SELECT a.line_cd    , a.share_cd , a.share_pct  , '
                               || '          a.share_amt1 , a.peril_cd , a.share_amt2 , '
                               || '          1 true_pct '
                               || '     FROM giis_default_dist_group a '
                               || '    WHERE a.default_no = ' || TO_CHAR(NVL(v_default_no, 0))
                               || '      AND a.line_cd    = ' || '''' || v_line_cd || ''''
                               || '      AND a.share_cd   <> 999 '
                               || ' ORDER BY a.sequence ASC');
                      v_errors := POPULATE_GROUP(rg_id);
                      IF v_errors NOT IN (0, 1403) THEN
                         MESSAGE('Error populating group ' || rg_name || '.', NO_ACKNOWLEDGE);
                         RAISE FORM_TRIGGER_FAILURE;
                      END IF;
                      rg_count := GET_GROUP_ROW_COUNT(rg_id);*/
       /*               rg_count := 0;
                      
                      FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  ,
                                       a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                       1 true_pct 
                                FROM GIIS_DEFAULT_DIST_GROUP a 
                                WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
                                AND a.line_cd    = v_line_cd
                               AND a.share_cd   <> 999 
                               ORDER BY a.sequence ASC)
                      LOOP
                        rg_count := c.rownum;
                      END LOOP;
                   ELSIF v_dist_type = '2' AND v_post_flag = 'O' THEN --edgar 09/09/2014
                      rg_count := 0;              --edgar 09/09/2014
                   END IF;
                   v_package_policy_sw := 'N';
                ELSE /*added edgar 09/09/2014*/
       /*            FOR c2 IN (SELECT default_no, default_type, dist_type,
                                     dflt_netret_pct
                                FROM GIIS_DEFAULT_DIST
                               WHERE iss_cd     = p_iss_cd
                                 AND subline_cd = v_subline_cd
                                 AND line_cd    = v_line_cd)
                   LOOP
                     v_default_no      := c2.default_no;
                     v_default_type    := c2.default_type;
                     v_dist_type       := c2.dist_type;
                     v_dflt_netret_pct := c2.dflt_netret_pct;
                     EXIT;
                   END LOOP;
                   IF NVL(v_dist_type, '1') = '1' AND v_post_flag = 'O' THEN
                      rg_count := 0;
                      
                      FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  ,
                                       a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                       1 true_pct 
                                FROM GIIS_DEFAULT_DIST_GROUP a 
                                WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
                                AND a.line_cd    = v_line_cd
                               AND a.share_cd   <> 999 
                               ORDER BY a.sequence ASC)
                      LOOP
                        rg_count := c.rownum;
                      END LOOP;
                   ELSIF v_dist_type = '2' AND v_post_flag = 'O' THEN
                      rg_count := 0;
                   END IF;
                   v_package_policy_sw := 'N';       
                   /*ended edgar 09/09/2014*/            
       /*         END IF;  */


        /* Generate a new DIST_SEQ_NO for the new
        ** item group. */
        v_dist_seq_no := v_dist_seq_no + 1;
        
        -- jhing 11.26.2014 always call CREATE_GRP_DFLT_DIST_GIUWS010 which was modified to populatethe DS Tables only 
        GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_GIUWS010
                     (p_dist_no      , v_dist_seq_no     , '2'               ,
                      c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                      c1.item_grp    , v_line_cd         , rg_count          ,
                      v_default_type , c1.currency_rt    , p_policy_id, v_default_no);  
        
                    /*added edgar 09/08/2014*/
         /*           IF v_exist2 = 'Y' THEN
                           v_post_flag := 'O';
                           GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_GIUWS010
                                 (p_dist_no      , v_dist_seq_no     , '2'               ,
                                  c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                  c1.item_grp    , v_line_cd         , rg_count          ,
                                  v_default_type , c1.currency_rt    , p_policy_id, v_default_no);        
                    ELSE
                    /*ended edgar 09/08/2014*/
                    
         /*               IF NVL(v_dist_type, '1') = '1' AND v_post_flag = 'O' THEN --added post_flag edgar 09/09/2014
                           v_post_flag := 'O';
                           GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_GIUWS010
                                 (p_dist_no      , v_dist_seq_no     , '2'               ,
                                  c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                  c1.item_grp    , v_line_cd         , rg_count          ,
                                  v_default_type , c1.currency_rt    , p_policy_id, v_default_no);
                        /*added edgar 09/09/2014*/
        /*                ELSIF NVL(v_dist_type, '1') = '1' AND v_post_flag = 'P' THEN
                           v_post_flag := 'P';
                           v_default_type := 0;
                           GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_DIST_GIUWS010
                                 (p_dist_no      , v_dist_seq_no     , '2'               ,
                                  c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                  c1.item_grp    , v_line_cd         , v_default_no      ,
                                  v_default_type , v_dflt_netret_pct , c1.currency_rt    ,
                                  p_policy_id);            
                        ELSIF NVL(v_dist_type, '1') = '2' AND v_post_flag = 'O' THEN
                           v_post_flag := 'O';
                           GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_GIUWS010
                                 (p_dist_no      , v_dist_seq_no     , '2'               ,
                                  c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                  c1.item_grp    , v_line_cd         , rg_count          ,
                                  v_default_type , c1.currency_rt    , p_policy_id, v_default_no);            
                        /*ended edgar 09/09/2014*/
        /*                ELSIF NVL(v_dist_type,'1') = '2' AND v_post_flag = 'P' THEN --added post_flag edgar 09/09/2014  -- jhing added nvl 11.24.2014 
                           v_post_flag := 'P';
                           GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_DIST_GIUWS010
                                 (p_dist_no      , v_dist_seq_no     , '2'               ,
                                  c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                  c1.item_grp    , v_line_cd         , v_default_no      ,
                                  v_default_type , v_dflt_netret_pct , c1.currency_rt    ,
                                  p_policy_id);
                        /*added edgar 09/17/2014*/
        /*                ELSIF NVL(v_dist_type,'1') = '1' AND v_post_flag IS NULL THEN  -- jhing 11.24.2014 added nvl 
                           v_post_flag := 'O';
                           GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_GIUWS010
                                 (p_dist_no      , v_dist_seq_no     , '2'               ,
                                  c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                  c1.item_grp    , v_line_cd         , rg_count          ,
                                  v_default_type , c1.currency_rt    , p_policy_id, v_default_no);
                        ELSIF NVL(v_dist_type,'1') = '2' AND v_post_flag IS NULL THEN   -- jhing 11.24.2014 added nvl 
                           v_post_flag := 'P';
                           GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_DIST_GIUWS010
                                 (p_dist_no      , v_dist_seq_no     , '2'               ,
                                  c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                  c1.item_grp    , v_line_cd         , v_default_no      ,
                                  v_default_type , v_dflt_netret_pct , c1.currency_rt    ,
                                  p_policy_id);                      
                        /*ended edgar 09/17/2014*/                      
      /*                  END IF;
                    END IF;--edgar 09/08/2014  */

      END LOOP;
      /*IF NOT ID_NULL(rg_id) THEN
         DELETE_GROUP(rg_id);
      END IF;*/

      /* Adjust computational floats to equalize the amounts
      ** attained by the master tables with that of its detail
      ** tables.
      ** Tables involved:  GIUW_WPERILDS     - GIUW_WPERILDS_DTL
      **                   GIUW_WPOLICYDS    - GIUW_WPOLICYDS_DTL
      **                   GIUW_WITEMDS      - GIUW_WITEMDS_DTL
      **                   GIUW_WITEMPERILDS - GIUW_WITEMPERILDS_DTL */

      --ADJUST_NET_RET_IMPERFECTION(p_dist_no); --edgar 09/15/2014
      
       -- jhing 11.25.2014 commented out. adjustment will be called in the procedure for default distribution (new procedure)
      /*added edgar for new adjustments*/
      --  IF  NVL(v_post_flag,'O') = 'O' THEN
      --      GIUW_POL_DIST_PKG.ADJUST_ALL_WTABLES_GIUWS004(p_dist_no);
      --  ELSIF v_post_flag = 'P' THEN
      --      ADJUST_DISTRIBUTION_PERIL_PKG.ADJUST_DISTRIBUTION(p_dist_no);
      --  END IF;
      /*ended edgar 09/15/2014*/ 

      -- jhing 12.11.2014 validate if there are missing distribution records against GIPI_ITMPERIL. 
       v_err_exists := 'N' ;
      GIUW_POL_DIST_FINAL_PKG.check_missing_dist_rec_item (p_dist_no, p_policy_id , v_err_exists );
      IF v_err_exists = 'Y' THEN
           RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#There are missing distribution records. Please recreate the items before re-grouping the records.'); 
      END IF; 
      
      -- jhing 11.26.2014 call the new procedure for populating default distribution 
      GIUW_POL_DIST_FINAL_PKG.POPULATE_DEFAULT_DIST ( p_dist_no, v_post_flag, v_dist_type );


      /* Create records in RI tables if a facultative
      ** share exists in any of the DIST_SEQ_NO in table
      ** GIUW_WPOLICYDS_DTL. */
     --  GIUW_POL_DIST_FINAL_PKG.CREATE_RI_RECORDS_GIUWS010(p_dist_no, p_policy_id, p_line_cd, p_subline_cd);  -- jhing  commented out 11.21.2014  -- FULLWEB SIT SR # 3723

      /* Set the value of the DIST_FLAG back 
      ** to Undistributed after recreation. */
     
      UPDATE GIUW_POL_DIST
         SET dist_flag = '1',
             post_flag = v_post_flag,
             dist_type = '1' ,
             special_dist_sw = 'N'
       WHERE policy_id = p_policy_id
         AND dist_no   = p_dist_no;
     END IF;
        
        /*IF v_dist_type = '2' THEN   -- shan 08.04.2014
            ADJUST_DISTRIBUTION_PERIL_PKG.ADJUST_DISTRIBUTION(p_dist_no);
        END IF;*/
    END;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    RECREATE_GRP_DFLT_DIST Program Unit from GIUWS010
    **/

     PROCEDURE RECRTE_GRP_DFLT_DIST_GIUWS010
        (p_dist_no        IN    GIUW_WPOLICYDS.dist_no%TYPE,
         p_dist_seq_no    IN    GIUW_WPOLICYDS.dist_seq_no%TYPE,
         p_dist_flag      IN    GIUW_WPOLICYDS.dist_flag%TYPE,
         p_policy_tsi     IN    GIUW_WPOLICYDS.tsi_amt%TYPE,
         p_policy_premium IN    GIUW_WPOLICYDS.prem_amt%TYPE,
         p_policy_ann_tsi IN    GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
         p_item_grp       IN    GIUW_WPOLICYDS.item_grp%TYPE,
         p_line_cd        IN    GIIS_LINE.line_cd%TYPE,
         p_rg_count       IN OUT NUMBER,
         p_default_type   IN    GIIS_DEFAULT_DIST.default_type%TYPE,
         p_currency_rt    IN    GIPI_ITEM.currency_rt%TYPE,
         p_policy_id      IN    GIPI_POLBASIC.policy_id%TYPE,
         p_v_default_no   IN    GIIS_DEFAULT_DIST.default_no%TYPE) IS
         

    ---------------
    dist_cnt        NUMBER;
    dist_max        GIUW_POL_DIST.dist_no%type;
    v_peril_exists  VARCHAR2(1); 
    -- jhing 11.26.2014 
    v_current_takeup    giuw_pol_dist.takeup_seq_no%TYPE;
    v_max_takeup        giuw_pol_dist.takeup_seq_no%TYPE;
    v_redist_sw      VARCHAR2(1);
    v_err_in_seq     VARCHAR2(1); 
    v_err_exists     VARCHAR2(1) ; -- jhing 12.11.2014
    ---------------

    BEGIN
        SELECT COUNT(dist_no), MAX(dist_no)
          INTO dist_cnt, dist_max
          FROM GIUW_POL_DIST
         WHERE policy_id = p_policy_id
           AND item_grp = p_item_grp
           AND dist_flag NOT IN (4,5);
           
      -- jhing 11.27.2014 added codes to retrieve takeup info
      SELECT nvl(takeup_seq_no,1)
        INTO v_current_takeup
            FROM giuw_pol_dist 
                WHERE dist_no = p_dist_no;
                
      SELECT nvl(MAX(takeup_seq_no),1)
        INTO v_max_takeup
            FROM giuw_pol_dist
                WHERE policy_id = p_policy_id;  
      
      v_redist_sw := 'N';           
      FOR p in(SELECT 1 
                FROM giuw_pol_dist 
                    WHERE policy_id = p_policy_id
                        AND dist_flag = '5')
      LOOP
        v_redist_sw := 'Y';
        EXIT;
      END LOOP;           
      -- end added codes jhing 11.27.2014   
           
        
      IF dist_cnt = 0 AND dist_max IS NULL THEN
        BEGIN
            SELECT COUNT(dist_no), MAX(dist_no)
                  INTO dist_cnt, dist_max
                  FROM GIUW_POL_DIST
                  WHERE policy_id = p_policy_id
                  AND item_grp IS NULL
                  AND dist_flag NOT IN (4,5);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
      END IF;


       -- jhing 12.11.2014 prompt an error when dist_seq_no is insequential
      v_err_in_seq := 'N';
      GIUW_POL_DIST_FINAL_PKG.val_sequential_distGrp (p_dist_no , 'GIUWS010', v_err_in_seq) ; 
      IF v_err_in_seq = 'Y' THEN
          RAISE_APPLICATION_ERROR (-20004 , 'Geniisys Exception#E#There are non-sequential distribution group nos. Please recreate the items then try to regroup the items again. '); 
 
      END IF;
      
      GIUW_POL_DIST_FINAL_PKG.val_multipleBillGrp_perDist (p_dist_no , p_policy_id, v_err_in_seq) ; 
      IF v_err_in_seq = 'Y' THEN
          RAISE_APPLICATION_ERROR (-20004 , 'Geniisys Exception#E#Cannot proceed with the setup of distribution. There are multiple bill groups which were grouped into a single distribution no. Please recreate the items and try to re-grouped the records again.'); 
 
      END IF;      

      /* Create records in table GIUW_WPOLICYDS_DTL
      ** for the specified DIST_SEQ_NO. */
     /* GIUW_POL_DIST_FINAL_PKG.RECRTE_GRP_DFLT_WPOLDS_GWS010
        (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
         p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
         p_rg_count   , p_default_type   , p_currency_rt    ,
         p_policy_id  , p_item_grp       , p_v_default_no); */ -- jhing 11.24.2014 commented out 

      /* Get the amounts for each item in table GIUW_WITEMDS in preparation
      ** for data insertion to its corresponding detail distribution table. */
      FOR c2 IN (SELECT item_no     , tsi_amt , prem_amt ,
                        ann_tsi_amt
                   FROM GIUW_WITEMDS
                  WHERE dist_seq_no = p_dist_seq_no
                    AND dist_no     = p_dist_no)
      LOOP

        /* Create records in table GIUW_WITEMDS_DTL
        ** for the specified DIST_SEQ_NO. */
        /*CREATE_GRP_DFLT_WITEMDS
          (p_dist_no      , p_dist_seq_no , c2.item_no  ,
           p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
           c2.ann_tsi_amt , p_rg_count    , p_v_default_no);  */ -- jhing commented out 11.24.2014            
   
        IF v_redist_sw = 'Y' THEN -- jhing 11.26.2014 ibig sabihin redistributed ung policy...dapat ung pangpopulate nia ng giuw_witemperilds consider ung 
                                                  -- earned portion sa premium  
                             
                /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
                ** in table GIPI_WITMPERL in preparation for data insertion to 
                ** distribution tables GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL. */
                FOR c3 IN (SELECT B380.tsi_amt      itmperil_tsi  ,
                                         (B380.prem_amt - SUM(c150.dist_prem)) itmperil_premium ,
                                          B380.ann_tsi_amt  itmperil_ann_tsi  ,
                                          B380.item_no      item_no ,
                                          B380.peril_cd     peril_cd                                                          
                                   FROM GIPI_ITMPERIL B380, GIPI_ITEM B340,
                                        GIUW_ITEMPERILDS_DTL C150
                                   WHERE B380.item_no     = B340.item_no
                                     AND B380.policy_id   = B340.policy_id
                                     AND B340.item_no     = C150.item_no
                                     AND B380.peril_cd    = C150.peril_cd
                                     AND B380.line_cd     = C150.line_cd
                                     AND B340.policy_id   = p_policy_id
                                     AND B340.item_grp       = p_item_grp
                                     AND B380.item_no = c2.item_no
                                     AND C150.dist_no IN (SELECT dist_no
                                                          FROM GIUW_POL_DIST
                                                          WHERE policy_id = p_policy_id
                                                          AND dist_flag IN (2,3))
                          GROUP BY B380.tsi_amt, B380.ann_tsi_amt, B380.item_no, 
                                   B380.peril_cd, B340.pack_line_cd, B380.prem_amt
                          ORDER BY B380.peril_cd)               
               LOOP

                  /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
                  ** for the specified DIST_SEQ_NO. */
                    INSERT INTO  GIUW_WITEMPERILDS  
                      (dist_no             , dist_seq_no   , item_no         ,
                       peril_cd            , line_cd       , tsi_amt         ,
                       prem_amt            , ann_tsi_amt)
                    VALUES 
                      (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                       c3.peril_cd         , p_line_cd     , c3.itmperil_tsi , 
                       c3.itmperil_premium , c3.itmperil_ann_tsi);
               END LOOP;
               
        ELSE
                /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
                ** in table GIPI_WITMPERL in preparation for data insertion to 
                ** distribution tables GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL. */
                FOR c3 IN (SELECT B380.tsi_amt     itmperil_tsi     ,
                                  B380.prem_amt    itmperil_premium ,
                                  B380.ann_tsi_amt itmperil_ann_tsi ,
                                  B380.peril_cd    peril_cd
                             FROM GIPI_ITMPERIL B380, GIPI_ITEM B340
                            WHERE B380.item_no   = B340.item_no
                              AND B380.policy_id = B340.policy_id
                              AND B340.item_no   = c2.item_no
                              AND B340.policy_id = p_policy_id)
                                    /*(SELECT B380.tsi_amt      itmperil_tsi                                               ,
                                                          (B380.prem_amt - SUM(c150.dist_prem)) itmperil_premium ,
                                                     B380.ann_tsi_amt  itmperil_ann_tsi                                           ,
                                                     B380.peril_cd     peril_cd                                                          
                                             FROM gipi_itmperil B380, gipi_item B340,
                                                       giuw_itemperilds_dtl C150
                                               WHERE B380.item_no   = B340.item_no
                                                 AND B380.policy_id = B340.policy_id
                                                 AND B340.item_no   = C150.item_no
                                                 AND B340.item_no   = c2.item_no
                                                 AND B380.peril_cd  = C150.peril_cd
                                                 AND B380.line_cd   = C150.line_cd
                                                 AND B340.policy_id = p_policy_id
                                                 AND C150.dist_seq_no = p_dist_seq_no
                                                 AND C150.dist_no IN (SELECT dist_no
                                                                                           FROM giuw_pol_dist
                                                                                              WHERE policy_id = p_policy_id
                                                                                                   AND dist_flag IN (2,3))
                                       GROUP BY B380.tsi_amt, B380.ann_tsi_amt, B380.item_no, 
                                                         B380.peril_cd, B340.pack_line_cd, B380.prem_amt
                                       ORDER BY B380.peril_cd)*/  
                  
                              
                LOOP

                  /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
                  ** for the specified DIST_SEQ_NO. */
                  IF /*p_dist_no = dist_max*/ v_current_takeup = v_max_takeup THEN -- jhing 11.27.2014 changed variables 
                            c3.itmperil_tsi     := NVL(c3.itmperil_tsi,0)     /*beth- (ROUND((NVL(c3.itmperil_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
                            c3.itmperil_premium := NVL(c3.itmperil_premium,0) - (ROUND((NVL(c3.itmperil_premium,0)/v_max_takeup /*dist_cnt*/ ),2) * (/*dist_cnt*/ v_max_takeup - 1));
                            c3.itmperil_ann_tsi := NVL(c3.itmperil_ann_tsi,0) /*beth- (ROUND((NVL(c3.itmperil_ann_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
                        ELSE
                            IF dist_cnt = 0 THEN
                                dist_cnt := 1;
                            END IF;
                            c3.itmperil_tsi     := ROUND((NVL(c3.itmperil_tsi,0)    /*beth/dist_cnt*/),2);
                            c3.itmperil_premium := ROUND((NVL(c3.itmperil_premium,0)/ v_max_takeup /*dist_cnt*/),2);
                            c3.itmperil_ann_tsi := ROUND((NVL(c3.itmperil_ann_tsi,0)/*beth/dist_cnt*/),2);
                   END IF;  
                  
                      INSERT INTO  GIUW_WITEMPERILDS  
                                    (dist_no             , dist_seq_no    , item_no         ,
                                     peril_cd            , line_cd        , tsi_amt         ,
                                     prem_amt            , ann_tsi_amt)
                             VALUES (p_dist_no           , p_dist_seq_no  , c2.item_no      ,
                                     c3.peril_cd         , p_line_cd      , c3.itmperil_tsi , 
                                     /*p_policy_premium*/c3.itmperil_premium , c3.itmperil_ann_tsi);
                       
                        --          CREATE_GRP_DFLT_WITEMPERILDS
                        --            (p_dist_no           , p_dist_seq_no       , c2.item_no      ,
                        --             p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                        --             /*p_policy_premium*/c3.itmperil_premium , c3.itmperil_ann_tsi , 
                        --             p_rg_count          , p_v_default_no);  -- jhing 11.24.2014 commented out 
            
                --END IF;

               END LOOP; 

              -- jhing 12.01.2014 commented out. Causes unique constraint error for insertion of GIUW_WPERILS
              -- when multiple items reuses same peril.
              
             /* FOR c4 IN (  SELECT SUM(tsi_amt)     tsi_amt     ,
                                  SUM(prem_amt)    prem_amt    ,
                                  SUM(ann_tsi_amt) ann_tsi_amt ,
                                  dist_no          dist_no     ,
                                  dist_seq_no      dist_seq_no ,
                                  line_cd          line_cd     ,
                                  peril_cd         peril_cd    
                             FROM GIUW_WITEMPERILDS
                            WHERE dist_seq_no = p_dist_seq_no
                              AND dist_no     = p_dist_no
                            GROUP BY dist_no, dist_seq_no, line_cd, peril_cd)
              LOOP

                /* Create records in table GIUW_WPERILDS and GIUW_WPERILDS_DTL
                ** for the specified DIST_SEQ_NO. */
             /*   INSERT INTO  GIUW_WPERILDS  
                  (dist_no    , dist_seq_no    , peril_cd    ,
                   line_cd    , tsi_amt        , prem_amt    ,
                   ann_tsi_amt)
                VALUES 
                    (p_dist_no  , p_dist_seq_no  , c4.peril_cd ,
                   p_line_cd  , c4.tsi_amt     , c4.prem_amt ,
                   c4.ann_tsi_amt);
                
               /* CREATE_GRP_DFLT_WPERILDS
                  (p_dist_no      , p_dist_seq_no , p_line_cd   ,
                   c4.peril_cd    , c4.tsi_amt    , c4.prem_amt ,
                   c4.ann_tsi_amt , p_rg_count    ,p_v_default_no); */ -- jhing 11.24.2014 commented out 
           
           /*   END LOOP;  */
         END IF;
      END LOOP;
       
       -- jhing  12.01.2014 insert GIUW_WPERILDS based on the record on GIUW_WITEMPERILDS
      FOR c4 IN ( SELECT SUM(tsi_amt)     tsi_amt     ,
                                  SUM(prem_amt)    prem_amt    ,
                                  SUM(ann_tsi_amt) ann_tsi_amt ,
                                  dist_no          dist_no     ,
                                  dist_seq_no      dist_seq_no ,
                                  line_cd          line_cd     ,
                                  peril_cd         peril_cd    
                             FROM GIUW_WITEMPERILDS
                            WHERE dist_seq_no = p_dist_seq_no
                              AND dist_no     = p_dist_no
                            GROUP BY dist_no, dist_seq_no, line_cd, peril_cd)
      LOOP

                /* Create records in table GIUW_WPERILDS and GIUW_WPERILDS_DTL
                ** for the specified DIST_SEQ_NO. */            
                
           INSERT INTO  GIUW_WPERILDS  
                  (dist_no    , dist_seq_no    , peril_cd    ,
                   line_cd    , tsi_amt        , prem_amt    ,
                   ann_tsi_amt)
              VALUES 
                    (p_dist_no  , p_dist_seq_no  , c4.peril_cd ,
                   p_line_cd  , c4.tsi_amt     , c4.prem_amt ,
                   c4.ann_tsi_amt);              
         
      END LOOP;  
     
      -- jhing 12.11.2014 added validation on amounts during saving of dist records (DS)
      --    RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#REIKOH TEST.'); 
 

      v_err_exists := 'N';
      GIUW_POL_DIST_FINAL_PKG.check_missing_dist_rec_item (p_dist_no, p_policy_id , v_err_exists );
      IF v_err_exists = 'Y' THEN
           RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#There are missing distribution records. Please recreate the items before re-grouping the items.'); 
      END IF;            

    END RECRTE_GRP_DFLT_DIST_GIUWS010;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    CREATE_ITEMS Program Unit from GIUWS010
    **/
    
    PROCEDURE CREATE_ITEMS_GIUWS010
       (p_dist_no        IN     GIUW_POL_DIST.dist_no%TYPE,
        p_policy_id      IN     GIPI_POLBASIC.policy_id%TYPE,
        p_line_cd        IN     GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd     IN     GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd         IN     GIPI_POLBASIC.iss_cd%TYPE,
        p_pack_pol_flag  IN     GIPI_POLBASIC.pack_pol_flag%TYPE) IS

    BEGIN

      /* Create or recreate records in distribution tables GIUW_WPOLICYDS,
      ** GIUW_WPOLICYDS_DTL, GIUW_WITEMDS, GIUW_WITEMDS_DTL, GIUW_WITEMPERILDS,
      ** GIUW_WITEMPERILDS_DTL, GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
      CPI.GIUW_POL_DIST_FINAL_PKG.CRTE_POLICY_DIST_RECS_GIUWS010
        (p_dist_no    , p_policy_id , p_line_cd , 
         p_subline_cd , p_iss_cd    , p_pack_pol_flag);

      /* Set the value of the DIST_FLAG back 
      ** to Undistributed after recreation. */
      
      UPDATE GIUW_POL_DIST
         SET dist_flag = '1',
             dist_type = '1',
             special_dist_sw = 'N' -- jhing 11.25.2014 
       WHERE policy_id = p_policy_id
         AND dist_no   = p_dist_no;

    END;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    CREATE_REGROUPED_DIST_RECS Program Unit from GIUWS010
    **/

     PROCEDURE CRTE_REGRPED_DIST_RECS_GWS010
     (p_dist_no       IN    GIUW_POL_DIST.dist_no%TYPE    ,
      p_policy_id     IN    GIPI_POLBASIC.policy_id%TYPE  ,
      p_line_cd       IN    GIPI_POLBASIC.line_cd%TYPE    ,
      p_subline_cd    IN    GIPI_POLBASIC.subline_cd%TYPE ,
      p_iss_cd        IN    GIPI_POLBASIC.iss_cd%TYPE     ,
      p_pack_pol_flag IN    GIPI_POLBASIC.pack_pol_flag%TYPE) IS

      v_line_cd             GIPI_POLBASIC.line_cd%TYPE;
      v_subline_cd          GIPI_POLBASIC.subline_cd%TYPE;
      v_currency_rt         GIPI_ITEM.currency_rt%TYPE;
      v_dist_seq_no         GIUW_WPOLICYDS.dist_seq_no%TYPE := 0;
      --rg_id                 RECORDGROUP;
      rg_name               VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_count              NUMBER;
      v_exist               VARCHAR2(1);
      v_errors              NUMBER;
      v_default_no          GIIS_DEFAULT_DIST.default_no%TYPE;
      v_default_type        GIIS_DEFAULT_DIST.default_type%TYPE;
      v_dflt_netret_pct     GIIS_DEFAULT_DIST.dflt_netret_pct%TYPE;
      v_dist_type           GIIS_DEFAULT_DIST.dist_type%TYPE;
      v_post_flag           VARCHAR2(1)  := 'O';
      v_package_policy_sw   VARCHAR2(1)  := 'Y';      
    BEGIN
      FOR c1 IN (SELECT dist_seq_no , tsi_amt  , prem_amt ,
                        ann_tsi_amt , item_grp , rowid 
                   FROM GIUW_WPOLICYDS
                  WHERE dist_no = p_dist_no)
      LOOP
        
        FOR c2 IN (SELECT currency_rt , pack_line_cd , pack_subline_cd
                     FROM GIPI_ITEM
                    WHERE item_grp  = c1.item_grp
                      AND policy_id = p_policy_id)
        LOOP

          v_currency_rt := c2.currency_rt;

          /* If the record processed is a package policy
          ** then get the true LINE_CD and true SUBLINE_CD,
          ** that is, the PACK_LINE_CD and PACK_SUBLINE_CD 
          ** from the GIPI_ITEM table.
          ** This will be used upon inserting to certain
          ** distribution tables requiring a value for
          ** the similar field. */
          IF p_pack_pol_flag = 'N' THEN
             v_line_cd    := p_line_cd;
             v_subline_cd := p_subline_cd;
          ELSE
             v_line_cd           := c2.pack_line_cd;
             v_subline_cd        := c2.pack_subline_cd;
             v_package_policy_sw := 'Y';
          END IF;
          EXIT;
        END LOOP;

       -- jhing 11.25.2014 commented out the whole block to get default dist no for package policy sinde 
       -- default distribution is already retrieved in the upper codes 
      /*  IF v_package_policy_sw = 'Y' THEN
           FOR c2 IN (SELECT default_no, default_type, dist_type,
                             dflt_netret_pct
                        FROM GIIS_DEFAULT_DIST
                       WHERE iss_cd     = p_iss_cd
                         AND subline_cd = v_subline_cd
                         AND line_cd    = v_line_cd)
           LOOP
             v_default_no      := c2.default_no;
             v_default_type    := c2.default_type;
             v_dist_type       := c2.dist_type;
             v_dflt_netret_pct := c2.dflt_netret_pct;
             EXIT;
           END LOOP;
           IF NVL(v_dist_type, '1') = '1' THEN
              /*rg_id := FIND_GROUP(rg_name);
              IF NOT ID_NULL(rg_id) THEN
                 DELETE_GROUP(rg_id);
              END IF;
              rg_id    := CREATE_GROUP_FROM_QUERY(rg_name,
                          '   SELECT a.line_cd    , a.share_cd , a.share_pct  , '
                       || '          a.share_amt1 , a.peril_cd , a.share_amt2 , '
                       || '          1 true_pct '
                       || '     FROM giis_default_dist_group a '
                       || '    WHERE a.default_no = ' || TO_CHAR(NVL(v_default_no, 0))
                       || '      AND a.line_cd    = ' || '''' || v_line_cd || ''''
                       || '      AND a.share_cd   <> 999 '
                       || ' ORDER BY a.sequence ASC');
              v_errors := POPULATE_GROUP(rg_id);
              IF v_errors NOT IN (0, 1403) THEN
                 MESSAGE('Error populating group ' || rg_name || '.', NO_ACKNOWLEDGE);
                 RAISE FORM_TRIGGER_FAILURE;
              END IF;
              rg_count := GET_GROUP_ROW_COUNT(rg_id);*/
          /*    rg_count := 0;
              
              FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  ,
                               a.share_amt1 , a.peril_cd , a.share_amt2 ,
                               1 true_pct 
                        FROM GIIS_DEFAULT_DIST_GROUP a 
                        WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
                        AND a.line_cd    = v_line_cd
                       AND a.share_cd   <> 999 
                       ORDER BY a.sequence ASC)
              LOOP
                rg_count := c.rownum;
              END LOOP;
              
           END IF;
           v_package_policy_sw := 'N';
        END IF;  */
        
       -- jhing 11.26.2014 regardless of dist_type, just call RECRTE_GRP_DFLT_DIST_GIUWS010 which now only populates the DS tables and not the DTL.
       -- distribution DTL tables will be populated by another proc
       GIUW_POL_DIST_FINAL_PKG.RECRTE_GRP_DFLT_DIST_GIUWS010
                   (p_dist_no      , c1.dist_seq_no , '2'            ,
                    c1.tsi_amt     , c1.prem_amt    , c1.ann_tsi_amt ,
                    c1.item_grp    , v_line_cd      , rg_count       ,
                    v_default_type , v_currency_rt  , p_policy_id, v_default_no);


            /*       IF NVL(v_dist_type, '1') = '1' THEN
                       v_post_flag := 'O';
                       GIUW_POL_DIST_FINAL_PKG.RECRTE_GRP_DFLT_DIST_GIUWS010
                               (p_dist_no      , c1.dist_seq_no , '2'            ,
                                c1.tsi_amt     , c1.prem_amt    , c1.ann_tsi_amt ,
                                c1.item_grp    , v_line_cd      , rg_count       ,
                                v_default_type , v_currency_rt  , p_policy_id, v_default_no);
                    ELSIF v_dist_type = '2' THEN
                       v_post_flag := 'P';
                       GIUW_POL_DIST_FINAL_PKG.RECRTE_PERIL_DFLT_DIST_GWS010
                               (p_dist_no      , c1.dist_seq_no    , '2'            ,
                                c1.tsi_amt     , c1.prem_amt       , c1.ann_tsi_amt ,
                                c1.item_grp    , v_line_cd         , v_default_no   ,
                                v_default_type , v_dflt_netret_pct , v_currency_rt  ,
                                p_policy_id);
                    END IF;  */
      
      END LOOP;
      
      
      /*IF NOT ID_NULL(rg_id) THEN
         DELETE_GROUP(rg_id);
      END IF;*/

      /* Adjust computational floats to equalize the amounts
      ** attained by the master tables with that of its detail
      ** tables.
      ** Tables involved:  GIUW_WPERILDS     - GIUW_WPERILDS_DTL
      **                   GIUW_WPOLICYDS    - GIUW_WPOLICYDS_DTL
      **                   GIUW_WITEMDS      - GIUW_WITEMDS_DTL
      **                   GIUW_WITEMPERILDS - GIUW_WITEMPERILDS_DTL */
      --ADJUST_NET_RET_IMPERFECTION(p_dist_no);  -- jhing commented out 11.24.2014 

      /* Create records in RI tables if a facultative
      ** share exists in any of the DIST_SEQ_NO in table
      ** GIUW_WPOLICYDS_DTL. */
      --GIUW_POL_DIST_FINAL_PKG.CREATE_RI_RECORDS_GIUWS010(p_dist_no, p_policy_id, p_line_cd, p_subline_cd);  -- jhing 11.24.2014 commented out 
      -- jhing 11.26.2014 call the new procedure for populating default distribution 
      GIUW_POL_DIST_FINAL_PKG.POPULATE_DEFAULT_DIST ( p_dist_no, v_post_flag, v_dist_type );
 
      /* Set the value of the DIST_FLAG back 
      ** to Undistributed after recreation. */
      
      UPDATE GIUW_POL_DIST
         SET dist_flag = '1',
             post_flag = v_post_flag,
             dist_type = '1' ,
             special_dist_sw = 'N' -- jhing 11.27.2014 
       WHERE policy_id = p_policy_id
         AND dist_no   = p_dist_no;

    END;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    PRE_UPDATE trigger on Block C150 from GIUWS010
    **/
    
    PROCEDURE PRE_UPDATE_C150_GIUWS010
        (p_dist_no        IN    GIUW_WPOLICYDS.dist_no%TYPE,
         p_dist_seq_no    IN    GIUW_WPOLICYDS.dist_seq_no%TYPE,
         p_tsi_amt           IN    GIUW_WPOLICYDS.tsi_amt%TYPE,
         p_prem_amt       IN    GIUW_WPOLICYDS.prem_amt%TYPE,
         p_ann_tsi_amt       IN    GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
         p_item_grp       IN    GIUW_WPOLICYDS.item_grp%TYPE,
         p_policy_id      IN    GIPI_POLBASIC.policy_id%TYPE) 
     AS
    
    CURSOR cur IS
            SELECT rowid , tsi_amt , prem_amt ,
                   ann_tsi_amt
              FROM GIUW_WPOLICYDS
             WHERE dist_seq_no =  p_dist_seq_no
               AND dist_no     =  p_dist_no
     FOR UPDATE OF tsi_amt, prem_amt, ann_tsi_amt;

      v_row             cur%ROWTYPE;

    BEGIN

      /* Check if the user-assigned DIST_SEQ_NO already exists
      ** in the parent table GIUW_WPOLICYDS.  If it doesn't, then
      ** a record with the said DIST_SEQ_NO must be created against
      ** said parent table. If it does exist, then the existing record
      ** must be updated to reflect its true value based on the changes */
      
      OPEN cur;
      FETCH cur
       INTO v_row;
      
      IF cur%notfound THEN
         INSERT INTO  GIUW_WPOLICYDS
                     (dist_no       , dist_seq_no       , dist_flag         ,
                      tsi_amt       , prem_amt          , ann_tsi_amt       ,
                      item_grp)
              VALUES (p_dist_no , p_dist_seq_no , 1                 ,
                      p_tsi_amt , p_prem_amt    , p_ann_tsi_amt ,
                      p_item_grp);
      ELSE
         UPDATE GIUW_WPOLICYDS
            SET tsi_amt     = v_row.tsi_amt     + p_tsi_amt ,
                prem_amt    = v_row.prem_amt    + p_prem_amt ,
                ann_tsi_amt = v_row.ann_tsi_amt + p_ann_tsi_amt
          WHERE rowid       = v_row.rowid;
      END IF;
      
      UPDATE GIUW_POL_DIST
        SET item_grp = p_item_grp
       WHERE policy_id = p_policy_id;
            
      CLOSE cur;
    END;
    
    /**
    **  Created by:     Veronica V. Raymundo
    **  Date Created:   July 13, 2011
    **  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
    **  Description:    POST_UPDATE trigger on Block C150 from GIUWS010
    **/

    PROCEDURE POST_UPDATE_C150_GIUWS010
        (p_dist_no            IN    GIUW_WPOLICYDS.dist_no%TYPE,
         p_orig_dist_seq_no IN    GIUW_WPOLICYDS.dist_seq_no%TYPE,
         p_tsi_amt             IN    GIUW_WPOLICYDS.tsi_amt%TYPE,
         p_prem_amt         IN    GIUW_WPOLICYDS.prem_amt%TYPE,
         p_ann_tsi_amt         IN    GIUW_WPOLICYDS.ann_tsi_amt%TYPE) AS

    BEGIN
        
      /* Remove the current record from the DIST_SEQ_NO to
      ** which it originally belongs to, as the record 
      ** may have already been regrouped to some other
      ** DIST_SEQ_NO. */
      
      FOR c1 IN ( SELECT rowid, tsi_amt , prem_amt ,
                         ann_tsi_amt
                  FROM GIUW_WPOLICYDS
                  WHERE dist_seq_no = p_orig_dist_seq_no
                    AND dist_no     = p_dist_no
                  FOR UPDATE OF tsi_amt, prem_amt, ann_tsi_amt)
      LOOP 
        
        IF c1.tsi_amt     != p_tsi_amt     OR
           c1.prem_amt    != p_prem_amt    OR
           c1.ann_tsi_amt != p_ann_tsi_amt THEN
           
           UPDATE GIUW_WPOLICYDS
              SET tsi_amt     = c1.tsi_amt     - p_tsi_amt  ,
                  prem_amt    = c1.prem_amt    - p_prem_amt ,
                  ann_tsi_amt = c1.ann_tsi_amt - p_ann_tsi_amt
            WHERE rowid    = c1.rowid;
        ELSE
           DELETE FROM GIUW_WPOLICYDS
            WHERE rowid = c1.rowid;
        END IF;
        EXIT;
      END LOOP;
  
END;

/**
**  Created by:     Veronica V. Raymundo
**  Date Created:   July 14, 2011
**  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
**  Description:    PRE_COMMIT trigger from GIUWS010
**/

PROCEDURE PRE_COMMIT_GIUWS010(p_dist_no GIUW_POL_DIST.dist_no%TYPE) IS

BEGIN
     GIUW_POL_DIST_FINAL_PKG.del_affected_dist_tables(p_dist_no);
     
     UPDATE GIUW_WPOLICYDS
        SET dist_flag = '1'
      WHERE dist_no   = p_dist_no;
     UPDATE GIUW_POL_DIST
        SET dist_flag = '1',
            dist_type = '1'
      WHERE dist_no   = p_dist_no;
END;

  /*
  **  Created by   : Belle Bebing
  **  Date Created : 07.15.2011
  **  Reference By : CREATE_PERIL_DFLT_WITEMDS program unit from GIUWS018- Set-up Peril Groups Distribution for Final
  **  Description  : Create records in table GIUW_WITEMDS_DTL based on
  **                 the values taken in by table GIUW_WITEMPERILDS_DTL.
  */
    PROCEDURE CRTE_PERIL_DFLT_WITEMDS_GWS018
       (p_dist_no       IN giuw_pol_dist.dist_no%TYPE,
        p_dist_seq_no   IN giuw_wpolicyds.dist_seq_no%TYPE) IS
        
        v_dist_spct        giuw_witemds_dtl.dist_spct%TYPE;
        v_ann_dist_spct    giuw_witemds_dtl.ann_dist_spct%TYPE;
        v_allied_dist_prem giuw_witemds_dtl.dist_prem%TYPE;
        v_dist_prem        giuw_witemds_dtl.dist_prem%TYPE;
    
    BEGIN
      FOR c1 IN (SELECT line_cd     line_cd      ,
                          item_no     item_no    ,
                          share_cd    share_cd   ,
                          dist_grp    dist_grp
                   FROM giuw_witemperilds_dtl
                  WHERE dist_no     = p_dist_no
                    AND dist_seq_no = p_dist_seq_no
               GROUP BY item_no, line_cd, share_cd, dist_grp)
      LOOP
        FOR c2 IN (SELECT SUM(DECODE(A170.peril_type, 'B', a.dist_tsi, 0)) dist_tsi,
                          SUM(a.dist_prem) dist_prem,
                          SUM(DECODE(A170.peril_type, 'B', a.ann_dist_tsi, 0)) ann_dist_tsi
                     FROM giuw_witemperilds_dtl a, giis_peril A170
                    WHERE A170.peril_cd   = a.peril_cd
                      AND A170.line_cd    = a.line_cd
                      AND a.dist_grp      = c1.dist_grp
                      AND a.share_cd      = c1.share_cd
                      AND a.line_cd       = c1.line_cd
                      AND a.item_no       = c1.item_no
                      AND a.dist_seq_no   = p_dist_seq_no                    
                      AND a.dist_no       = p_dist_no)
        LOOP
          FOR c3 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt , item_no
                       FROM giuw_witemds
                      WHERE item_no     = c1.item_no
                        AND dist_seq_no = p_dist_seq_no
                        AND dist_no     = p_dist_no)
          LOOP

            /* Divide the individual TSI/Premium with the total TSI/Premium
            ** and multiply it by 100 to arrive at the correct percentage for
            ** the breakdown. */
            IF c3.tsi_amt != 0 THEN
               v_dist_spct  := ROUND(c2.dist_tsi/c3.tsi_amt, 9) * 100;
            ELSE
               IF c3.prem_amt != 0 THEN
                 v_dist_spct  := ROUND(c2.dist_prem/c3.prem_amt, 9) * 100;
               ELSE
                 v_dist_spct  := ROUND(c2.dist_prem/1, 9) * 100;
               END IF;               
            END IF;
            
            IF c3.ann_tsi_amt != 0 THEN
               v_ann_dist_spct := ROUND(c2.ann_dist_tsi/c3.ann_tsi_amt, 9) * 100;
            ELSE
               v_ann_dist_spct := v_dist_spct;
            END IF;      

            INSERT INTO  giuw_witemds_dtl
                        (dist_no         , dist_seq_no   , item_no         ,
                         line_cd         , share_cd      , dist_spct       ,
                         dist_tsi        , dist_prem     , ann_dist_spct   ,
                         ann_dist_tsi    , dist_grp)
                 VALUES (p_dist_no       , p_dist_seq_no , c3.item_no      , 
                         c1.line_cd      , c1.share_cd   , v_dist_spct     ,
                         c2.dist_tsi     , c2.dist_prem  , v_ann_dist_spct ,
                         c2.ann_dist_tsi , c1.dist_grp);
          END LOOP;
          EXIT;
        END LOOP;
      END LOOP;
    END;

/**
 **  Created by:     Belle Bebing
 **  Date Created:   07.15.2011
 **  Referenced by:  GIUWS018 - Set-up Peril Groups Distribution for Final
 **  Description:    CREATE_GRP_DFLT_DIST Program Unit from GIUWS018
 */
    PROCEDURE CRTE_PERIL_DFLT_DIST_GWS018
       (p_dist_no         IN giuw_wpolicyds.dist_no%TYPE,
        p_dist_seq_no     IN giuw_wpolicyds.dist_seq_no%TYPE,
        p_dist_flag       IN giuw_wpolicyds.dist_flag%TYPE,
        p_policy_tsi      IN giuw_wpolicyds.tsi_amt%TYPE,
        p_policy_premium  IN giuw_wpolicyds.prem_amt%TYPE,
        p_policy_ann_tsi  IN giuw_wpolicyds.ann_tsi_amt%TYPE,
        p_item_grp        IN giuw_wpolicyds.item_grp%TYPE,
        p_line_cd         IN giis_line.line_cd%TYPE,
        p_default_no      IN giis_default_dist.default_no%TYPE,
        p_default_type    IN giis_default_dist.default_type%TYPE,
        p_dflt_netret_pct IN giis_default_dist.dflt_netret_pct%TYPE,
        p_currency_rt     IN gipi_item.currency_rt%TYPE,
        p_policy_id       IN gipi_polbasic.policy_id%TYPE) IS
        
        v_peril_cd           giis_peril.peril_cd%TYPE;
        v_peril_tsi          giuw_wperilds.tsi_amt%TYPE      := 0;
        v_peril_premium      giuw_wperilds.prem_amt%TYPE     := 0;
        v_peril_ann_tsi      giuw_wperilds.ann_tsi_amt%TYPE  := 0;
        v_exist              VARCHAR2(1)                     := 'N';
        v_insert_sw          VARCHAR2(1)                     := 'N';
        v_dist_flag          gipi_polbasic.dist_flag%TYPE;
        
  /* Updates the amounts of the previously processed PERIL_CD
  ** while looping inside cursor C3.  After which, the records
  ** for table GIUW_WPERILDS_DTL are also created.
  ** NOTE:  This is a LOCAL PROCEDURE BODY called below. */
  PROCEDURE  UPD_CREATE_WPERIL_DTL_DATA IS
    BEGIN
         UPDATE giuw_wperilds
           SET tsi_amt     = v_peril_tsi     ,
               prem_amt    = v_peril_premium ,
               ann_tsi_amt = v_peril_ann_tsi
         WHERE peril_cd    = v_peril_cd
           AND line_cd     = p_line_cd
           AND dist_seq_no = p_dist_seq_no
           AND dist_no     = p_dist_no;
           
        GIUW_POL_DIST_FINAL_PKG.CRTE_PERL_DFLT_WPERILDS_GWS010 
              (p_dist_no       , p_dist_seq_no , p_line_cd       ,
               v_peril_cd      , v_peril_tsi   , v_peril_premium ,
               v_peril_ann_tsi , p_currency_rt , p_default_no    ,
               p_default_type  , p_dflt_netret_pct);
    END;

    BEGIN

        /* Create records in table GIUW_WPOLICYDS and GIUW_WPOLICYDS_DTL
        ** for the specified DIST_SEQ_NO. */
        INSERT INTO  giuw_wpolicyds
                    (dist_no      , dist_seq_no      , dist_flag        ,
                     tsi_amt      , prem_amt         , ann_tsi_amt      ,
                     item_grp)
             VALUES (p_dist_no    , p_dist_seq_no    , p_dist_flag      ,
                     p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                     p_item_grp);

        /* Get the amounts for each item in table GIPI_ITEM in preparation
        ** for data insertion to its corresponding distribution tables. */

        FOR a IN (SELECT dist_flag
                    FROM giuw_pol_dist
                   WHERE policy_id = (SELECT policy_id
                                        FROM giuw_pol_dist
                                       WHERE dist_no = p_dist_no)
                     AND dist_flag = 5) 
        LOOP
           v_dist_flag := a.dist_flag;                              
        END LOOP;
  
       IF v_dist_flag = 5 THEN
            FOR c2 IN (SELECT c.item_no     , a.tsi_amt , (a.prem_amt - SUM(c.dist_prem)) prem_amt ,a.ann_tsi_amt
                         FROM gipi_item a, giuw_itemperilds_dtl c
                        WHERE EXISTS( SELECT '1'
                                        FROM gipi_itmperil b
                                       WHERE b.policy_id = a.policy_id
                                         AND b.item_no   = a.item_no)
                                         AND a.item_no     = c.item_no
                                         AND a.item_grp    = p_item_grp
                                         AND a.policy_id   = p_policy_id
                                         AND c.dist_seq_no = p_dist_seq_no
                                         AND c.dist_no IN (SELECT dist_no
                                                             FROM giuw_pol_dist
                                                            WHERE policy_id = p_policy_id
                                                              AND dist_flag IN (2,3)) 
                    GROUP BY c.item_no, a.tsi_amt, a.prem_amt, a.ann_tsi_amt)
            LOOP
              /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL
              ** for the specified DIST_SEQ_NO. */
              INSERT INTO  giuw_witemds
                          (dist_no        , dist_seq_no   , item_no        ,
                           tsi_amt        , prem_amt      , ann_tsi_amt)
                   VALUES (p_dist_no      , p_dist_seq_no , c2.item_no     ,
                           c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);
            END LOOP;

            /* Initialize the value of the variables
            ** in preparation for processing the new
            ** DIST_SEQ_NO. */
            v_peril_cd      := NULL;
            v_peril_tsi     := 0;
            v_peril_premium := 0;
            v_peril_ann_tsi := 0;   
            v_exist         := 'N';

            /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
            ** in table GIPI_ITMPERIL in preparation for data insertion to 
            ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
            ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
            FOR c3 IN (SELECT B380.tsi_amt      itmperil_tsi                                               ,
                             (B380.prem_amt - SUM(c150.dist_prem)) itmperil_premium ,
                              B380.ann_tsi_amt  itmperil_ann_tsi                                           ,
                              B380.item_no      item_no                                                    ,
                              B380.peril_cd     peril_cd                                                          
                         FROM gipi_itmperil B380, gipi_item B340, giuw_itemperilds_dtl C150
                        WHERE B380.item_no     = B340.item_no
                          AND B380.policy_id   = B340.policy_id
                          AND B340.item_no     = C150.item_no
                          AND B380.peril_cd    = C150.peril_cd
                          AND B380.line_cd     = C150.line_cd
                          AND B340.policy_id   = p_policy_id
                          AND C150.dist_seq_no = p_dist_seq_no
                          AND B340.item_grp       = p_item_grp
                          AND C150.dist_no IN (SELECT dist_no
                                                 FROM giuw_pol_dist
                                                WHERE policy_id = p_policy_id
                                                  AND dist_flag IN (2,3))
                     GROUP BY B380.tsi_amt, B380.ann_tsi_amt, B380.item_no, B380.peril_cd, B380.prem_amt
                     ORDER BY B380.peril_cd)

            LOOP
              v_exist     := 'Y';

              /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
              ** for the specified DIST_SEQ_NO. */
              INSERT INTO  giuw_witemperilds  
                          (dist_no             , dist_seq_no   , item_no         ,
                           peril_cd            , line_cd       , tsi_amt         ,
                           prem_amt            , ann_tsi_amt)
                   VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                           c3.peril_cd         , p_line_cd     , c3.itmperil_tsi ,
                           c3.itmperil_premium , c3.itmperil_ann_tsi);
              /* Create the newly processed PERIL_CD in table GIUW_WPERILDS. */
              IF v_peril_cd IS NULL THEN
                 v_peril_cd     := c3.peril_cd;
                 v_insert_sw    := 'Y';
              END IF;

              /* Check if the value of the previously processed
              ** PERIL_CD is equal to the one currently processed.
              ** Should the two be unequal, then the amounts of
              ** the previously processed PERIL_CD must be updated
              ** to reflect the true value of each field for the
              ** specified PERIL_CD.  After the amounts of the specified
              ** PERIL_CD have been updated, then that's the time to
              ** create the records in table GIUW_WPERILDS_DTL.
              ** On the other hand, if the value of the two PERIL_CDs
              ** are equal, then the amounts of the currently processed
              ** record is added along with the amounts of the previously
              ** processed records of the same PERIL_CD.  Such amounts
              ** shall be used later on when the two PERIL_CDs become
              ** unequal. */
              
              IF v_peril_cd != c3.peril_cd THEN
              /* Updates the amounts of the previously processed PERIL_CD.
              ** After which, the records for table GIUW_WPERILDS_DTL are
              ** also created. */
                  UPD_CREATE_WPERIL_DTL_DATA;

              /* Assigns the new PERIL_CD to the V_PERIL_CD
              ** variable in preparation for data creation
              ** in table GIUW_WPERILDS. */
                  v_peril_cd      := c3.peril_cd;
                  v_peril_tsi     := c3.itmperil_tsi;
                  v_peril_premium := c3.itmperil_premium;
                  v_peril_ann_tsi := c3.itmperil_ann_tsi;
                  v_insert_sw     := 'Y';

             ELSIF v_peril_cd = c3.peril_cd THEN
                 v_peril_tsi     := v_peril_tsi     + c3.itmperil_tsi;
                 v_peril_premium := v_peril_premium + c3.itmperil_premium;
                 v_peril_ann_tsi := v_peril_ann_tsi + c3.itmperil_ann_tsi;
              END IF;
              
              IF v_insert_sw = 'Y' THEN
                 INSERT INTO  giuw_wperilds  
                             (dist_no   , dist_seq_no   , peril_cd         ,
                              line_cd   , tsi_amt       , prem_amt         ,
                              ann_tsi_amt)
                      VALUES (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                              p_line_cd , v_peril_tsi   , v_peril_premium  ,
                              v_peril_ann_tsi);
                 v_insert_sw     := 'N';
              END IF;
            END LOOP;
            
            IF v_exist = 'Y' THEN
               /* Updates the amounts of the last processed PERIL_CD.
               ** After which, its corresponding records for table 
               ** GIUW_WPERILDS_DTL are also created.
               ** NOTE:  This was done so, because the last processed
               **        PERIL_CD is no longer handled by the C3 loop. */
               UPD_CREATE_WPERIL_DTL_DATA;

            END IF;
            
            /* Create records in table GIUW_WITEMDS_DTL based on
            ** the values inserted to table GIUW_WITEMPERILDS_DTL. */
            GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_WITEMDS_GWS018  (p_dist_no, p_dist_seq_no);
            /* Create records in table GIUW_WPOLICYDS_DTL based on
            ** the values inserted to table GIUW_WITEMDS_DTL. */
            CREATE_PERIL_DFLT_WPOLICYDS(p_dist_no, p_dist_seq_no);

      ELSE -- dist_flag
            FOR c2 IN (SELECT a.item_no     , a.tsi_amt , a.prem_amt ,a.ann_tsi_amt
                         FROM gipi_item a
                        WHERE exists( SELECT '1'
                                        FROM gipi_itmperil b
                                       WHERE b.policy_id = a.policy_id
                                         AND b.item_no = a.item_no)
                      AND a.item_grp  = p_item_grp
                      AND a.policy_id = p_policy_id)
                     
            LOOP
              /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL
              ** for the specified DIST_SEQ_NO. */
              INSERT INTO  giuw_witemds
                          (dist_no        , dist_seq_no   , item_no        ,
                           tsi_amt        , prem_amt      , ann_tsi_amt)
                   VALUES (p_dist_no      , p_dist_seq_no , c2.item_no     ,
                           c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);
            END LOOP;

            /* Initialize the value of the variables
            ** in preparation for processing the new
            ** DIST_SEQ_NO. */
                v_peril_cd      := NULL;
                v_peril_tsi     := 0;
                v_peril_premium := 0;
                v_peril_ann_tsi := 0;   
                v_exist         := 'N';

            /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
            ** in table GIPI_ITMPERIL in preparation for data insertion to 
            ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
            ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
    
            FOR c3 IN (SELECT B380.tsi_amt     itmperil_tsi     ,
                              B380.prem_amt    itmperil_premium ,
                              B380.ann_tsi_amt itmperil_ann_tsi ,
                              B380.item_no     item_no          ,
                              B380.peril_cd    peril_cd
                         FROM gipi_itmperil B380, gipi_item B340
                        WHERE B380.item_no   = B340.item_no
                          AND B380.policy_id = B340.policy_id
                          AND B340.item_grp  = p_item_grp
                          AND B340.policy_id = p_policy_id
                     ORDER BY B380.peril_cd)
            LOOP
              v_exist     := 'Y';

                /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
                ** for the specified DIST_SEQ_NO. */
                    INSERT INTO  giuw_witemperilds  
                      (dist_no             , dist_seq_no   , item_no         ,
                       peril_cd            , line_cd       , tsi_amt         ,
                       prem_amt            , ann_tsi_amt)
                    VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                       c3.peril_cd         , p_line_cd     , c3.itmperil_tsi ,
                       c3.itmperil_premium , c3.itmperil_ann_tsi);
               /* Create the newly processed PERIL_CD in table
               ** GIUW_WPERILDS. */
                IF v_peril_cd IS NULL THEN
                   v_peril_cd     := c3.peril_cd;
                   v_insert_sw    := 'Y';
                END IF;

               /* Check if the value of the previously processed
               ** PERIL_CD is equal to the one currently processed.
               ** Should the two be unequal, then the amounts of
               ** the previously processed PERIL_CD must be updated
               ** to reflect the true value of each field for the
               ** specified PERIL_CD.  After the amounts of the specified
               ** PERIL_CD have been updated, then that's the time to
               ** create the records in table GIUW_WPERILDS_DTL.
               ** On the other hand, if the value of the two PERIL_CDs
               ** are equal, then the amounts of the currently processed
               ** record is added along with the amounts of the previously
               ** processed records of the same PERIL_CD.  Such amounts
               ** shall be used later on when the two PERIL_CDs become
               ** unequal. */
               IF v_peril_cd != c3.peril_cd THEN

                   /* Updates the amounts of the previously processed PERIL_CD.
                   ** After which, the records for table GIUW_WPERILDS_DTL are
                   ** also created. */
                    UPD_CREATE_WPERIL_DTL_DATA;

                   /* Assigns the new PERIL_CD to the V_PERIL_CD
                   ** variable in preparation for data creation
                   ** in table GIUW_WPERILDS. */
                     v_peril_cd      := c3.peril_cd;
                     v_peril_tsi     := c3.itmperil_tsi;
                     v_peril_premium := c3.itmperil_premium;
                     v_peril_ann_tsi := c3.itmperil_ann_tsi;
                     v_insert_sw     := 'Y';

              ELSIF v_peril_cd = c3.peril_cd THEN
                     v_peril_tsi     := v_peril_tsi     + c3.itmperil_tsi;
                     v_peril_premium := v_peril_premium + c3.itmperil_premium;
                     v_peril_ann_tsi := v_peril_ann_tsi + c3.itmperil_ann_tsi;
               END IF;
               
               IF v_insert_sw = 'Y' THEN
                     INSERT INTO  giuw_wperilds  
                                 (dist_no   , dist_seq_no   , peril_cd         ,
                                  line_cd   , tsi_amt       , prem_amt         ,
                                  ann_tsi_amt)
                          VALUES (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                                  p_line_cd , v_peril_tsi   , v_peril_premium  ,
                                  v_peril_ann_tsi);
                     v_insert_sw     := 'N';
               END IF;
            END LOOP;
            
            IF v_exist = 'Y' THEN

               /* Updates the amounts of the last processed PERIL_CD.
               ** After which, its corresponding records for table 
               ** GIUW_WPERILDS_DTL are also created.
               ** NOTE:  This was done so, because the last processed
               **        PERIL_CD is no longer handled by the C3 loop. */
               UPD_CREATE_WPERIL_DTL_DATA;

            END IF;
            
            /* Create records in table GIUW_WITEMDS_DTL based on
            ** the values inserted to table GIUW_WITEMPERILDS_DTL. */
            GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_WITEMDS_GWS018  (p_dist_no, p_dist_seq_no);
           /* Create records in table GIUW_WPOLICYDS_DTL based on
            ** the values inserted to table GIUW_WITEMDS_DTL. */
            CREATE_PERIL_DFLT_WPOLICYDS(p_dist_no, p_dist_seq_no);
       END IF;          
    END;
    
/**
 **  Created by:     Belle Bebing
 **  Date Created:   07.15.2011
 **  Referenced by:  CREATE_GRP_DFLT_DIST Program Unit from GIUWS018 - Set-up Peril Groups Distribution for Final
 **  Description:    GIUWS018
 */

    PROCEDURE CRTE_GRP_DFLT_DIST_GWS018
        (p_dist_no        IN giuw_wpolicyds.dist_no%TYPE,
         p_dist_seq_no    IN giuw_wpolicyds.dist_seq_no%TYPE,
         p_dist_flag      IN giuw_wpolicyds.dist_flag%TYPE,
         p_policy_tsi     IN giuw_wpolicyds.tsi_amt%TYPE,
         p_policy_premium IN giuw_wpolicyds.prem_amt%TYPE,
         p_policy_ann_tsi IN giuw_wpolicyds.ann_tsi_amt%TYPE,
         p_item_grp       IN giuw_wpolicyds.item_grp%TYPE,
         p_line_cd        IN giis_line.line_cd%TYPE,
         p_rg_count       IN OUT NUMBER,
         p_default_type   IN giis_default_dist.default_type%TYPE,
         p_currency_rt    IN gipi_item.currency_rt%TYPE,
         p_policy_id      IN gipi_polbasic.policy_id%TYPE,
         p_default_no     in giis_default_dist.default_no%TYPE) IS
         
         v_peril_cd          giis_peril.peril_cd%TYPE;
         v_peril_tsi         giuw_wperilds.tsi_amt%TYPE      := 0;
         v_peril_premium     giuw_wperilds.prem_amt%TYPE     := 0;
         v_peril_ann_tsi     giuw_wperilds.ann_tsi_amt%TYPE  := 0;
         v_exist             VARCHAR2(1)                     := 'N';
         v_insert_sw         VARCHAR2(1)                     := 'N';
         v_dist_flag         gipi_polbasic.dist_flag%TYPE;
         dist_cnt            NUMBER;
         dist_max            giuw_pol_dist.dist_no%type;
         v_tsi_amt           giuw_pol_dist.tsi_amt%type;
         v_prem_amt          giuw_pol_dist.prem_amt%type;
         v_ann_tsi_amt       giuw_pol_dist.ann_tsi_amt%type;
         v_exist2            VARCHAR2(1)                     := 'N';
         -- jhing 11.27.2014 added variables
         v_current_takeup   giuw_pol_dist.takeup_seq_no%TYPE;
         v_max_takeup       giuw_pol_dist.takeup_seq_no%TYPE;
    
  /* Updates the amounts of the previously processed PERIL_CD
  ** while looping inside cursor C3.  After which, the records
  ** for table GIUW_WPERILDS_DTL are also created.
  ** NOTE:  This is a LOCAL PROCEDURE BODY called below. */
  PROCEDURE  UPD_CREATE_WPERIL_DTL_DATA IS

  BEGIN

    UPDATE giuw_wperilds
       SET tsi_amt     = v_peril_tsi     ,
           prem_amt    = v_peril_premium ,
           ann_tsi_amt = v_peril_ann_tsi
     WHERE peril_cd    = v_peril_cd
       AND line_cd     = p_line_cd
       AND dist_seq_no = p_dist_seq_no
       AND dist_no     = p_dist_no;

     -- jhing 11.26.2014 commented out. DTL tables will be populated using new procedure
    /*GIUW_POL_DIST_FINAL_PKG.CRT_GRP_DFLT_WPERILDS_GW18 --CREATE_GRP_DFLT_WPERILDS -- shan 07.29.2014
      (p_dist_no       , p_dist_seq_no , p_line_cd       ,
       v_peril_cd      , v_peril_tsi   , v_peril_premium ,
       v_peril_ann_tsi , p_rg_count    , p_default_no); */
  END;
  
  BEGIN

        SELECT count(*), max(dist_no)
          INTO dist_cnt, dist_max
          FROM giuw_pol_dist
         WHERE policy_id = p_policy_id
           AND item_grp = p_item_grp
		    -- 10/06/2011 - from GIUWS010
           AND dist_flag NOT IN (4,5); --editted by steven 11/28/2012: copied from FMB
        
        IF dist_cnt = 0 AND dist_max IS NULL THEN
            SELECT count(*), max(dist_no)
              INTO dist_cnt, dist_max
              FROM giuw_pol_dist
             WHERE policy_id = p_policy_id
               AND item_grp IS NULL
               AND DIST_FLAG NOT IN (3,4,5);--VJP 041210
        END IF;
        
        -- jhing 11.27.2014 get takeup info
        SELECT NVL(takeup_seq_no,1)
            INTO v_current_takeup
                FROM giuw_pol_dist
                    WHERE dist_no = p_dist_no;
                  
        SELECT NVL(MAX(takeup_seq_no),1) 
            INTO v_max_takeup
                FROM giuw_pol_dist
                    WHERE policy_id = p_policy_id;         
        -- end of added code jhing 11.27.2014 
        
      /* Create records in table GIUW_WPOLICYDS and GIUW_WPOLICYDS_DTL for the specified DIST_SEQ_NO. */
        IF /*p_dist_no = dist_max */  v_current_takeup = v_max_takeup THEN
             FOR x IN (SELECT SUM(NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)) tsi_amt, 
                              SUM(NVL(a.prem_amt,0) - (ROUND((NVL(a.prem_amt,0)/v_max_takeup /*dist_cnt*/ ),2) * (/*dist_cnt*/ v_max_takeup - 1))) prem_amt, 
                              SUM(NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)) ann_tsi_amt
                         FROM gipi_itmperil a, gipi_item b, giis_peril c
                        WHERE a.policy_id = b.policy_id
                          AND a.item_no   = b.item_no
                          AND a.policy_id = p_policy_id
                          AND b.item_grp  = p_item_grp
                          AND a.peril_cd  = c.peril_cd
                          AND c.line_cd   = p_line_cd)
             LOOP
                  v_tsi_amt        := x.tsi_amt;
                  v_prem_amt       := x.prem_amt;
                  v_ann_tsi_amt    := x.ann_tsi_amt;
             END LOOP;
             
        ELSE
            IF dist_cnt = 0 THEN
                dist_cnt := 1;
            END IF;
            FOR x IN (SELECT SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)),2)) tsi_amt, 
                             SUM(ROUND((NVL(a.prem_amt,0)//*dist_cnt*/ v_max_takeup ),2)) prem_amt,
                             SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)),2)) ann_tsi_amt
                        FROM gipi_itmperil a, gipi_item b, giis_peril c
                       WHERE a.policy_id = b.policy_id
                         AND a.item_no   = b.item_no
                         AND a.policy_id = p_policy_id
                         AND b.item_grp  = p_item_grp
                         AND a.peril_cd  = c.peril_cd
                         AND c.line_cd   = p_line_cd)
            LOOP
                 v_tsi_amt       := x.tsi_amt;
                 v_prem_amt      := x.prem_amt;
                 v_ann_tsi_amt   := x.ann_tsi_amt;
            END LOOP;            
        END IF;        
    
      ----------------------------------------
       INSERT INTO  giuw_wpolicyds
            (dist_no  ,dist_seq_no  , dist_flag    ,
            tsi_amt   ,prem_amt     , ann_tsi_amt  ,
            item_grp)
       VALUES 
           (p_dist_no , p_dist_seq_no , p_dist_flag   ,
            v_tsi_amt , v_prem_amt    , v_ann_tsi_amt ,
            p_item_grp);

        -- jhing 11.26.2014 commented out. DTL tables will be populated using new procedure
       /*GIUW_POL_DIST_FINAL_PKG.CRTE_GRP_DFLT_WPOLICYDS_GWS010
        (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
         v_tsi_amt    , v_prem_amt       , v_ann_tsi_amt    ,
         p_rg_count   , p_default_type   , p_currency_rt    ,
         p_policy_id  , p_item_grp       , p_default_no); */

       /* Get the amounts for each item in table GIPI_ITEM in preparation
       ** for data insertion to its corresponding distribution tables. */
       
       FOR a IN (SELECT dist_flag
                   FROM giuw_pol_dist
                  WHERE policy_id = (SELECT policy_id
                                       FROM giuw_pol_dist
                                      WHERE dist_no = p_dist_no)
                    AND dist_flag = 5) 
       LOOP
          v_dist_flag := a.dist_flag;                              
       END LOOP;
      
       IF v_dist_flag = 5 THEN
          FOR c2 IN (SELECT c.item_no, a.tsi_amt , (a.prem_amt - SUM(c.dist_prem)) prem_amt , a.ann_tsi_amt
                       FROM gipi_item a, giuw_itemperilds_dtl c
                      WHERE EXISTS( SELECT '1'
                                      FROM gipi_itmperil b
                                     WHERE b.policy_id = a.policy_id
                                       AND b.item_no   = a.item_no)
                                       AND a.item_no     = c.item_no
                                       AND a.item_grp    = p_item_grp
                                       AND a.policy_id   = p_policy_id
									   	/* 10/06/2011 bmq - commented out to include grouped items in distribution */
                                      --AND c.dist_seq_no = p_dist_seq_no --editted by steven 11/28/2012: copied from FMB
                                       AND c.dist_no IN (SELECT dist_no
                                                           FROM giuw_pol_dist
                                                          WHERE policy_id = p_policy_id
                                                            AND dist_flag IN (2,3))
                   GROUP BY c.item_no, a.tsi_amt, a.prem_amt, a.ann_tsi_amt)
          LOOP
            /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL
            ** for the specified DIST_SEQ_NO. */
            INSERT INTO  giuw_witemds
                (dist_no   , dist_seq_no   , item_no    ,
                 tsi_amt   , prem_amt      , ann_tsi_amt)
            VALUES 
                (p_dist_no , p_dist_seq_no , c2.item_no ,
                 c2.tsi_amt , c2.prem_amt  , c2.ann_tsi_amt);
            
            -- jhing 11.26.2014 commented out. DTL tables will be populated using new procedure. 
            /*GIUW_POL_DIST_FINAL_PKG.CRT_GRP_DFLT_WITEMDS_GW18   --CREATE_GRP_DFLT_WITEMDS -- shan 07.29.2014
            (p_dist_no      , p_dist_seq_no , c2.item_no  ,
             p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
             c2.ann_tsi_amt , p_rg_count    , p_default_no); */

          END LOOP;

          /* Initialize the value of the variables
          ** in preparation for processing the new
          ** DIST_SEQ_NO. */
          v_peril_cd      := NULL;
          v_peril_tsi     := 0;
          v_peril_premium := 0;
          v_peril_ann_tsi := 0;   
          v_exist         := 'N';

          /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
          ** in table GIPI_ITMPERIL in preparation for data insertion to 
          ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
          ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
          FOR c3 IN (SELECT B380.tsi_amt      itmperil_tsi                                               ,
                           (B380.prem_amt - SUM(c150.dist_prem)) itmperil_premium ,
                            B380.ann_tsi_amt  itmperil_ann_tsi                                           ,
                            B380.item_no      item_no                                                    ,
                            B380.peril_cd     peril_cd                                                          
                       FROM gipi_itmperil B380, gipi_item B340, giuw_itemperilds_dtl C150
                      WHERE B380.item_no     = B340.item_no
                        AND B380.policy_id   = B340.policy_id
                        AND B340.item_no     = C150.item_no
                        AND B380.peril_cd    = C150.peril_cd
                        AND B380.line_cd     = C150.line_cd
                        AND B340.policy_id   = p_policy_id
						/* 10/06/2011 bmq - commented out to include grouped items in distribution */
                        --AND C150.dist_seq_no = p_dist_seq_no --editted by steven 11/28/2012: copied from FMB
                        AND B340.item_grp       = p_item_grp
                        AND C150.dist_no IN (SELECT dist_no
                                               FROM giuw_pol_dist
                                              WHERE policy_id = p_policy_id
                                                AND dist_flag IN (2,3))
                   GROUP BY B380.tsi_amt, B380.ann_tsi_amt, B380.item_no, B380.peril_cd, B380.prem_amt
                   ORDER BY B380.peril_cd)
          LOOP
            v_exist     := 'Y';

            /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
            ** for the specified DIST_SEQ_NO. */
            INSERT INTO  giuw_witemperilds  
                (dist_no             , dist_seq_no   , item_no         ,
                 peril_cd            , line_cd       , tsi_amt         ,
                 prem_amt            , ann_tsi_amt)
            VALUES 
               (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                c3.peril_cd         , p_line_cd     , c3.itmperil_tsi , 
                c3.itmperil_premium , c3.itmperil_ann_tsi);
                
                
            -- jhing 11.26.2014 commented out. DTL tables will be populated using new procedure.     
            /*GIUW_POL_DIST_FINAL_PKG.CRT_GRP_DFLT_WITEMPERILDS_GW18  --CREATE_GRP_DFLT_WITEMPERILDS -- shan 07.29.2014
               (p_dist_no           , p_dist_seq_no       , c3.item_no      ,
                p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count      ,
                p_default_no); */                

            /* Create the newly processed PERIL_CD in table
            ** GIUW_WPERILDS. */
            IF v_peril_cd IS NULL THEN
               v_peril_cd     := c3.peril_cd;
               v_insert_sw    := 'Y';
            END IF;

            /* Check if the value of the previously processed
            ** PERIL_CD is equal to the one currently processed.
            ** Should the two be unequal, then the amounts of
            ** the previously processed PERIL_CD must be updated
            ** to reflect the true value of each field for the
            ** specified PERIL_CD.  After the amounts of the specified
            ** PERIL_CD have been updated, then that's the time to
            ** create the records in table GIUW_WPERILDS_DTL.
            ** On the other hand, if the value of the two PERIL_CDs
            ** are equal, then the amounts of the currently processed
            ** record is added along with the amounts of the previously
            ** processed records of the same PERIL_CD.  Such amounts
            ** shall be used later on when the two PERIL_CDs become
            ** unequal. */
            IF v_peril_cd != c3.peril_cd THEN

              /* Updates the amounts of the previously processed PERIL_CD.
              ** After which, the records for table GIUW_WPERILDS_DTL are
              ** also created. */
              UPD_CREATE_WPERIL_DTL_DATA;

              /* Assigns the new PERIL_CD to the V_PERIL_CD
              ** variable in preparation for data creation
              ** in table GIUW_WPERILDS. */
              v_peril_cd      := c3.peril_cd;
              v_peril_tsi     := c3.itmperil_tsi;
              v_peril_premium := c3.itmperil_premium;
              v_peril_ann_tsi := c3.itmperil_ann_tsi;
              v_insert_sw     := 'Y';

            ELSIF v_peril_cd = c3.peril_cd THEN
               v_peril_tsi     := v_peril_tsi     + c3.itmperil_tsi;
               v_peril_premium := v_peril_premium + c3.itmperil_premium;
               v_peril_ann_tsi := v_peril_ann_tsi + c3.itmperil_ann_tsi;
            END IF;
            
            IF v_insert_sw = 'Y' THEN
               INSERT INTO  giuw_wperilds  
                  (dist_no   , dist_seq_no   , peril_cd         ,
                   line_cd   , tsi_amt       , prem_amt         ,
                   ann_tsi_amt)
               VALUES 
                 (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                  p_line_cd , v_peril_tsi   , v_peril_premium  ,
                  v_peril_ann_tsi);
               
               v_insert_sw     := 'N';
            END IF;
          END LOOP;
          
          IF v_exist = 'Y' THEN
             /* Updates the amounts of the last processed PERIL_CD.
             ** After which, its corresponding records for table 
             ** GIUW_WPERILDS_DTL are also created.
             ** NOTE:  This was done so, because the last processed
             **        PERIL_CD is no longer handled by the C3 loop. */
             UPD_CREATE_WPERIL_DTL_DATA;
          END IF;

      ELSE -- dist_flag
          /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL for the specified DIST_SEQ_NO. */
          FOR c2 IN (SELECT a.item_no     , a.tsi_amt , a.prem_amt ,a.ann_tsi_amt
                       FROM gipi_item a
                      WHERE exists(SELECT '1'
                                     FROM gipi_itmperil b
                                    WHERE b.policy_id = a.policy_id
                                      AND b.item_no = a.item_no)
                        AND a.item_grp  = p_item_grp
                        AND a.policy_id = p_policy_id)
          LOOP
              IF /*p_dist_no = dist_max*/ v_current_takeup = v_max_takeup THEN
                  FOR x IN (SELECT SUM(NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)) tsi_amt, 
                                   SUM(NVL(a.prem_amt,0) - (ROUND((NVL(a.prem_amt,0)/v_max_takeup /*dist_cnt*/ ),2) * (v_max_takeup /*dist_cnt*/ - 1))) prem_amt, 
                                   SUM(NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)) ann_tsi_amt
                              FROM gipi_itmperil a, gipi_item b, giis_peril c
                             WHERE a.policy_id  = b.policy_id
                               AND a.item_no = b.item_no
                               AND a.policy_id  = p_policy_id
                               AND a.item_no = c2.item_no
                               AND a.peril_cd  = c.peril_cd
                               AND c.line_cd   = p_line_cd)
                   LOOP
                       v_tsi_amt        := x.tsi_amt;
                       v_prem_amt       := x.prem_amt;
                       v_ann_tsi_amt    := x.ann_tsi_amt;
                   END LOOP;
              ELSE
                   FOR x IN (SELECT SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.tsi_amt,0),0)),2)) tsi_amt, 
                                    SUM(ROUND((NVL(a.prem_amt,0)/v_max_takeup /*dist_cnt*/ ),2)) prem_amt, 
                                    SUM(ROUND((NVL(DECODE(c.peril_type,'B',a.ann_tsi_amt,0),0)),2)) ann_tsi_amt
                               FROM gipi_itmperil a, gipi_item b, giis_peril c
                              WHERE a.policy_id  = b.policy_id
                                AND a.item_no = b.item_no
                                AND a.policy_id  = p_policy_id
                                AND a.item_no = c2.item_no
                                AND a.peril_cd = c.peril_cd
                                AND c.line_cd = p_line_cd)
                   LOOP
                       v_tsi_amt     := x.tsi_amt;
                       v_prem_amt    := x.prem_amt;
                       v_ann_tsi_amt := x.ann_tsi_amt;
                   END LOOP;
              END IF;
          
              INSERT INTO  giuw_witemds
                (dist_no        , dist_seq_no   , item_no        ,
                 tsi_amt        , prem_amt      , ann_tsi_amt)
              VALUES 
                (p_dist_no      , p_dist_seq_no , c2.item_no     ,
                 v_tsi_amt      , v_prem_amt    , v_ann_tsi_amt );

               -- jhing 11.26.2014 commented out. DTL tables will be populated using new procedure.
              /*GIUW_POL_DIST_FINAL_PKG.CRT_GRP_DFLT_WITEMDS_GW18 --CREATE_GRP_DFLT_WITEMDS -- shan 07.29.2014
                (p_dist_no      , p_dist_seq_no , c2.item_no  ,
                 p_line_cd      , v_tsi_amt     , v_prem_amt  ,
                 v_ann_tsi_amt  ,p_rg_count     , p_default_no); */
          END LOOP;

          /* Initialize the value of the variables
          ** in preparation for processing the new
          **  DIST_SEQ_NO. */
                v_peril_cd      := NULL;
                v_peril_tsi     := 0;
                v_peril_premium := 0;
                v_peril_ann_tsi := 0;   
                v_exist         := 'N';

          /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
          ** in table GIPI_ITMPERIL in preparation for data insertion to 
          ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
          ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
            FOR c3 IN (SELECT B380.tsi_amt     itmperil_tsi     ,
                              B380.prem_amt    itmperil_premium ,
                              B380.ann_tsi_amt itmperil_ann_tsi ,
                              B380.item_no     item_no          ,
                              B380.peril_cd    peril_cd
                         FROM gipi_itmperil B380, gipi_item B340
                        WHERE B380.item_no   = B340.item_no
                          AND B380.policy_id = B340.policy_id
                          AND B340.item_grp  = p_item_grp
                          AND B340.policy_id = p_policy_id
                     ORDER BY B380.peril_cd)
            LOOP
                v_exist     := 'Y';
                
                IF /*p_dist_no = dist_max*/ v_current_takeup = v_max_takeup  THEN
                    v_tsi_amt        := NVL(c3.itmperil_tsi,0) ;
                    v_prem_amt       := NVL(c3.itmperil_premium,0) - (ROUND((NVL(c3.itmperil_premium,0)/v_max_takeup /*dist_cnt */ ),2) * (/*dist_cnt*/ v_max_takeup  - 1));
                    v_ann_tsi_amt    := NVL(c3.itmperil_ann_tsi,0);
                ELSE
                    v_tsi_amt        := ROUND((NVL(c3.itmperil_tsi,0)),2);
                    v_prem_amt       := ROUND((NVL(c3.itmperil_premium,0)/v_max_takeup /*dist_cnt */ ),2);
                    v_ann_tsi_amt    := ROUND((NVL(c3.itmperil_ann_tsi,0)),2);
                END IF;
              /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
              ** for the specified DIST_SEQ_NO. */
              INSERT INTO  giuw_witemperilds  
                (dist_no             , dist_seq_no   , item_no         ,
                 peril_cd            , line_cd       , tsi_amt         ,
                 prem_amt            , ann_tsi_amt)
              VALUES 
                (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                 c3.peril_cd         , p_line_cd     , v_tsi_amt       ,
                 v_prem_amt          , v_ann_tsi_amt );
                               
               -- jhing 11.26.2014 commented out. DTL tables will be populated using new procedure    
              /*GIUW_POL_DIST_FINAL_PKG.CRT_GRP_DFLT_WITEMPERILDS_GW18    --CREATE_GRP_DFLT_WITEMPERILDS -- shan 07.29.2014
                (p_dist_no           , p_dist_seq_no       , c3.item_no      ,
                 p_line_cd           , c3.peril_cd         , v_tsi_amt       ,
                 v_prem_amt          , v_ann_tsi_amt       ,p_rg_count       ,
                 p_default_no); */
            END LOOP;

            /* Create the newly processed PERIL_CD in table GIUW_WPERILDS. */
			--mildred 09292011 include the sum amounts per peril
            FOR c4 IN (SELECT SUM(B380.tsi_amt)     itmperil_tsi     , 
							SUM(B380.prem_amt)    itmperil_premium ,
							SUM(B380.ann_tsi_amt) itmperil_ann_tsi ,
							B380.peril_cd    peril_cd
						FROM gipi_itmperil B380, gipi_item B340
							WHERE B380.item_no   = B340.item_no
								AND B380.policy_id = B340.policy_id
								AND B340.item_grp  = p_item_grp
								AND B340.policy_id = p_policy_id
							--ORDER BY B380.peril_cd) -- comment by mildred 09292011 
							GROUP BY B380.peril_cd) --editted by steven 11/28/2012: copied from FMB
                LOOP  
                     
                  IF /*p_dist_no = dist_max*/ v_current_takeup = v_max_takeup  THEN
                    c4.itmperil_tsi      := NVL(c4.itmperil_tsi,0);
                    c4.itmperil_premium     := NVL(c4.itmperil_premium,0) - (ROUND((NVL(c4.itmperil_premium,0)/v_max_takeup /*dist_cnt */ ),2) * (/*dist_cnt*/ v_max_takeup  - 1));
                    c4.itmperil_ann_tsi  := NVL(c4.itmperil_ann_tsi,0);
                  ELSE
                    c4.itmperil_tsi      := c4.itmperil_tsi;
                    c4.itmperil_premium  := c4.itmperil_premium / v_max_takeup /*dist_cnt */ ;
                    c4.itmperil_ann_tsi  := c4.itmperil_ann_tsi;
                  END IF;
              
                  FOR x IN (SELECT '1' 
                              FROM giuw_wperilds
                             WHERE dist_no = p_dist_no
                               AND dist_seq_no = p_dist_seq_no
                               AND peril_cd = c4.peril_cd)
                  LOOP
                      v_exist2 := 'Y';
                      EXIT;
                  END LOOP;
              
                  IF v_exist2 = 'N' THEN
                      INSERT INTO giuw_wperilds  
                            (dist_no   , dist_seq_no   , peril_cd         ,
                             line_cd   , tsi_amt       , prem_amt         ,
                             ann_tsi_amt)
                      VALUES 
                            (p_dist_no , p_dist_seq_no , c4.peril_cd       ,
                             p_line_cd , c4.itmperil_tsi   , c4.itmperil_premium  ,
                             c4.itmperil_ann_tsi);          
                  END IF;
              
                  v_peril_cd         := c4.peril_cd;
                  v_peril_tsi        := c4.itmperil_tsi;
                  v_peril_premium    := c4.itmperil_premium;
                  v_peril_ann_tsi    := c4.itmperil_ann_tsi;

                  UPD_CREATE_WPERIL_DTL_DATA;                   
                END LOOP;
       END IF;
  END;

/**
    **  Created by:     Belle Bebing
    **  Date Created:   07.14.2011
    **  Referenced by:  CREATE_POLICY_DIST_RECS Program Unit from GIUWS018- Set-up Peril Groups Distribution for Final
    **  Description:    Create default distribution records in all distribution tables namely:
    **                  GIUW_WPOLICYDS, GIUW_WPOLICYDS_DTL, GIUW_WITEMDS, GIUW_WITEMDS_DTL,
    **                  GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL, GIUW_WPERILDS and GIUW_WPERILDS_DTL.
    **                  The default records inserted to the detail tables were driven from the defaults
    **                  distribution tables:  GIIS_DEFAULT_DIST, GIIS_DEFAULT_DIST_GROUP and 
    **                  GIIS_DEFAULT_DIST_PERIL. 
    **/
    PROCEDURE  CRTE_POLICY_DIST_RECS_GIUWS018
    (p_dist_no       IN giuw_pol_dist.dist_no%TYPE,
     p_policy_id     IN gipi_polbasic.policy_id%TYPE,
     p_line_cd       IN gipi_polbasic.line_cd%TYPE,
     p_subline_cd    IN gipi_polbasic.subline_cd%TYPE,
     p_iss_cd        IN gipi_polbasic.iss_cd%TYPE,
     p_pack_pol_flag IN gipi_polbasic.pack_pol_flag%TYPE) IS

     v_line_cd          gipi_polbasic.line_cd%TYPE;
     v_subline_cd       gipi_polbasic.subline_cd%TYPE;
     v_dist_seq_no      giuw_wpolicyds.dist_seq_no%TYPE := 0;
     rg_name            VARCHAR2(20) := 'DFLT_DIST_VALUES';
     rg_count           NUMBER;
     v_exist            VARCHAR2(1);
     v_errors           NUMBER;
     v_default_no       giis_default_dist.default_no%TYPE;
     v_default_type     giis_default_dist.default_type%TYPE;
     v_dflt_netret_pct  giis_default_dist.dflt_netret_pct%TYPE;
     v_dist_type        giis_default_dist.dist_type%TYPE;
     v_post_flag        VARCHAR2(1)  := 'O';
     v_package_policy_sw VARCHAR2(1)  := 'Y';
     v_dist_flag        gipi_polbasic.dist_flag%TYPE;
     v_item_grp         giuw_pol_dist.item_grp%TYPE;
     v_exist2           VARCHAR2(1) := 'N'; --edgar 09/09/2014
     v_temp_dist_flag   giuw_pol_dist.dist_flag%TYPE ; -- jhing 11.25.2014
     
     BEGIN
         BEGIN
            SELECT NVL(item_grp,1)
              INTO v_item_grp
              FROM giuw_pol_dist
             WHERE policy_id = p_policy_id
               AND dist_no = p_dist_no;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
         END;
        
         FOR a IN (SELECT dist_flag
                          FROM giuw_pol_dist
                         WHERE policy_id = (SELECT policy_id
                                               FROM giuw_pol_dist
                                              WHERE dist_no = p_dist_no)
                           AND dist_flag = 5) 
         LOOP
            v_dist_flag := a.dist_flag;                              
         END LOOP;
  
         IF v_dist_flag = 5 THEN
         
              -- jhing 11.26.2014 commented out. Default distribution parameter and setup will be retrieved after 
              -- DS tables have been populated. They would be called in a separate procedure.
                              
                                /* Get the unique ITEM_GRP to produce a unique DIST_SEQ_NO for each. */
                              /*added edgar 09/09/2014 so that policy with at least one item that has zero TSI and Prem is distributed using One-Risk only*/
              /*                FOR i IN (SELECT item_no,
                                              SUM(tsi_amt)     policy_tsi      ,
                                              SUM(prem_amt)    policy_premium  ,
                                              SUM(ann_tsi_amt) policy_ann_tsi  
                                         FROM GIPI_ITEM a
                                        WHERE policy_id = p_policy_id
                                          AND EXISTS (SELECT 1
                                                        FROM GIPI_ITMPERIL
                                                       WHERE policy_id = a.policy_id
                                                         AND item_no = a.item_no)
                                        GROUP BY item_no)
                              LOOP
                                IF i.policy_tsi = 0 AND i.policy_premium = 0 THEN
                                    v_exist2 := 'Y';
                                    EXIT;
                                END IF; 
                              END LOOP;   
                              FOR pol IN (SELECT a.pol_flag, b.par_type
                                            FROM gipi_polbasic a, gipi_parlist b
                                           WHERE a.policy_id = p_policy_id
                                             AND a.par_id = b.par_id)
                              LOOP
                                  BEGIN
                                    IF pol.pol_flag = '2' THEN
                                        FOR post IN (SELECT post_flag , dist_flag 
                                                       FROM GIUW_POL_DIST 
                                                      WHERE dist_no = 
                                                             (SELECT max(dist_no) 
                                                                FROM GIUW_POL_DIST 
                                                               WHERE policy_id = 
                                                                        ( SELECT MAX(old_policy_id) 
                                                                            FROM GIPI_POLNREP
                                                                           WHERE ren_rep_sw = '1'
                                                                             AND new_policy_id = (SELECT policy_id
                                                                                                    FROM gipi_polbasic
                                                                                                   WHERE pol_flag <> '5'
                                                                                                     AND policy_id = p_policy_id))))
                                        LOOP
                                            IF post.dist_flag in ( '2', '3') THEN
                                                v_post_flag := post.post_flag;
                                            END IF; 
                                        END LOOP;
                                    ELSIF pol.par_type = 'E' THEN                                                                           
                                        SELECT post_flag, dist_flag
                                          INTO v_post_flag, v_temp_dist_flag
                                          FROM giuw_pol_dist
                                         WHERE dist_no = 
                                                  (SELECT MAX(dist_no)
                                                     FROM giuw_pol_dist
                                                    WHERE par_id =                                     
                                                      (SELECT par_id
                                                         FROM gipi_polbasic
                                                        WHERE endt_seq_no = 0
                                                          AND (line_cd,
                                                               subline_cd,
                                                               iss_cd,
                                                               issue_yy,
                                                               pol_seq_no,
                                                               renew_no
                                                              ) =
                                                                 (SELECT line_cd, subline_cd, iss_cd, issue_yy,
                                                                         pol_seq_no, renew_no
                                                                    FROM gipi_polbasic
                                                                   WHERE policy_id = p_policy_id)));  
                                           
                                        IF v_temp_dist_flag NOT IN ( '2', '3' ) THEN
                                            v_post_flag := NULL;
                                        END IF;                             
                                    ELSE        
                                        v_post_flag := NULL;    
                                    END IF;
                                  EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                        v_post_flag := NULL;  
                                  END; 
                              EXIT;
                              END LOOP;   */                 
                              /*ended edgar 09/09/2014*/                 

                FOR c1 IN (SELECT  NVL(a.item_grp, 1)   item_grp        ,
                                   a.pack_line_cd       pack_line_cd    ,
                                   a.pack_subline_cd    pack_subline_cd ,
                                   a.currency_rt        currency_rt     ,
                                   sum(a.tsi_amt)       policy_tsi      ,
                                   sum(a.prem_amt - (c.prem_amt)) policy_premium  ,
                                   sum(a.ann_tsi_amt)   policy_ann_tsi  
                            FROM gipi_item a, giuw_pol_dist c
                           WHERE a.policy_id = p_policy_id
                             AND a.policy_id = c.policy_id
                             AND EXISTS (SELECT 1
                                           FROM gipi_itmperil b
                                          WHERE b.policy_id = a.policy_id
                                            AND b.item_no   = a.item_no)
                             AND dist_flag IN (2,3)
                        GROUP BY a.item_grp , a.pack_line_cd , a.pack_subline_cd ,a.currency_rt
                            ORDER BY a.pack_line_cd, a.pack_subline_cd, a.item_grp, a.currency_rt ) -- jhing 11.28.2014 added order by fields
                LOOP
                    /* If the POLICY processed is a package policy
                    ** then get the true LINE_CD and true SUBLINE_CD,
                    ** that is, the PACK_LINE_CD and PACK_SUBLINE_CD 
                    ** from the GIPI_ITEM table.
                    ** This will be used upon inserting to certain
                    ** distribution tables requir
                    ing a value for
                    ** the similar field. */
                    
                     IF p_pack_pol_flag = 'N' THEN
                         v_line_cd    := p_line_cd;
                         v_subline_cd := p_subline_cd;
                     ELSE
                         v_line_cd           := c1.pack_line_cd;
                         v_subline_cd        := c1.pack_subline_cd;
                         v_package_policy_sw := 'Y';
                     END IF;
                                        
                    -- jhing 11.26.2014 commented out. Default distribution parameters will be setup in another procedure.
                     /*                   IF v_package_policy_sw = 'Y' THEN
                                            FOR c2 IN (SELECT default_no, default_type, dist_type,
                                                              dflt_netret_pct
                                                         FROM giis_default_dist
                                                        WHERE iss_cd     = p_iss_cd
                                                          AND subline_cd = v_subline_cd
                                                          AND line_cd    = v_line_cd)
                                            LOOP
                                             v_default_no      := c2.default_no;
                                             v_default_type    := c2.default_type;
                                             v_dist_type       := c2.dist_type;
                                             v_dflt_netret_pct := c2.dflt_netret_pct;
                                             EXIT;
                                            END LOOP;
                          
                                           IF NVL(v_dist_type, '1') = '1' THEN
                                             rg_count := 0;
                                                FOR i IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                                                         a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                                                 1 true_pct 
                                                            FROM giis_default_dist_group a 
                                                           WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
                                                             AND a.line_cd    =  v_line_cd
                                                             AND a.share_cd   <> 999 
                                                        ORDER BY a.sequence ASC)
                                                LOOP
                                                    rg_count := i.rownum;
                                                END LOOP;
                                           ELSIF v_dist_type = '2' AND v_post_flag = 'O' THEN --edgar 09/09/2014
                                              rg_count := 0;              --edgar 09/09/2014                                
                                           END IF;
                                            v_package_policy_sw := 'N';
                                        ELSE /*edgar 09/09/2014*/
                 /*                          FOR c2 IN (SELECT default_no, default_type, dist_type,
                                                             dflt_netret_pct
                                                        FROM giis_default_dist
                                                       WHERE iss_cd     = p_iss_cd
                                                         AND subline_cd = v_subline_cd
                                                         AND line_cd    = v_line_cd)
                                           LOOP
                                             v_default_no      := c2.default_no;
                                             v_default_type    := c2.default_type;
                                             v_dist_type       := c2.dist_type;
                                             v_dflt_netret_pct := c2.dflt_netret_pct;
                                             EXIT;
                                           END LOOP;
                                           
                                           IF NVL(v_dist_type, '1') = '1' THEN
                                             rg_count := 0 ;
                                             FOR z IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                                                      a.share_amt1 , a.peril_cd , a.share_amt2 , 
                                                              1 true_pct 
                                                         FROM giis_default_dist_group a 
                                                        WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
                                                          AND a.line_cd    = v_line_cd 
                                                          AND a.share_cd   <> 999 
                                                     ORDER BY a.sequence ASC)
                                             LOOP
                                               rg_count := z.rownum; 
                                             END LOOP;
                                           ELSIF NVL(v_dist_type,'1') = '2' AND v_post_flag = 'O' THEN --edgar 09/09/2014 -- jhing 11.24.2014 added nvl 
                                              rg_count := 0;              --edgar 09/09/2014                         
                                           END IF;
                                           v_package_policy_sw := 'N';
                                           /*ended edgar 09/09/2014*/                             
                   /*                     END IF;  */ 

                    /* Generate a new DIST_SEQ_NO for the new
                    ** item group. */
                    v_dist_seq_no := v_dist_seq_no + 1;

                    -- jhing 11.26.2014 regardless of dist_type just call CRTE_GRP_DFLT_DIST_GWS018 which 
                    -- now can only populate the DS tables and not the DTL tables
                    GIUW_POL_DIST_FINAL_PKG.CRTE_GRP_DFLT_DIST_GWS018
                                 (p_dist_no      , v_dist_seq_no     , '2'               ,
                                  c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                  c1.item_grp    , v_line_cd         , rg_count          ,
                                  v_default_type , c1.currency_rt    , p_policy_id       ,
                                  v_default_no);

                    -- jhing 11.26.2014 commented out block of code 
                                        /*added edgar 09/08/2014*/
                   /*                     IF v_exist2 = 'Y' THEN
                                               v_post_flag := 'O';
                                              GIUW_POL_DIST_FINAL_PKG.CRTE_GRP_DFLT_DIST_GWS018
                                                     (p_dist_no      , v_dist_seq_no     , '2'               ,
                                                      c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                                      c1.item_grp    , v_line_cd         , rg_count          ,
                                                      v_default_type , c1.currency_rt    , p_policy_id       ,
                                                      v_default_no);      
                                        ELSE
                                        /*ended edgar 09/08/2014*/
                   /*                         IF NVL(v_dist_type, '1') = '1' AND v_post_flag = 'O' THEN --added post_flag edgar 09/09/2014
                                               v_post_flag := 'O';
                                              GIUW_POL_DIST_FINAL_PKG.CRTE_GRP_DFLT_DIST_GWS018
                                                     (p_dist_no      , v_dist_seq_no     , '2'               ,
                                                      c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                                      c1.item_grp    , v_line_cd         , rg_count          ,
                                                      v_default_type , c1.currency_rt    , p_policy_id       ,
                                                      v_default_no);
                                            /*added edgar 09/09/2014*/
                   /*                         ELSIF NVL(v_dist_type, '1') = '1' AND v_post_flag = 'P' THEN
                                               v_post_flag := 'P';
                                               v_default_type := 0;
                                                 GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_DIST_GWS018
                                                  (p_dist_no      , v_dist_seq_no     , '2'               ,
                                                   c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                                   c1.item_grp    , v_line_cd         , v_default_no      ,
                                                   v_default_type , v_dflt_netret_pct , c1.currency_rt    ,
                                                   p_policy_id);        
                                            ELSIF NVL(v_dist_type, '1') = '2' AND v_post_flag = 'O' THEN
                                               v_post_flag := 'O';
                                              GIUW_POL_DIST_FINAL_PKG.CRTE_GRP_DFLT_DIST_GWS018
                                                     (p_dist_no      , v_dist_seq_no     , '2'               ,
                                                      c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                                      c1.item_grp    , v_line_cd         , rg_count          ,
                                                      v_default_type , c1.currency_rt    , p_policy_id       ,
                                                      v_default_no);          
                                            /*ended edgar 09/09/2014*/                                  
                   /*                         ELSIF NVL(v_dist_type,'1') = '2' AND v_post_flag = 'P' THEN --added post_flag edgar 09/09/2014 -- jhing 11.24.2014 added nvl 
                                                 v_post_flag := 'P';
                                                 GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_DIST_GWS018
                                                  (p_dist_no      , v_dist_seq_no     , '2'               ,
                                                   c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                                   c1.item_grp    , v_line_cd         , v_default_no      ,
                                                   v_default_type , v_dflt_netret_pct , c1.currency_rt    ,
                                                   p_policy_id);
                                            END IF;
                                        END IF;--edgar 09/09/2014

                                    END LOOP; */
                
                /* Adjust computational floats to equalize the amounts
                ** attained by the master tables with that of its detail
                ** tables.
                ** Tables involved:  GIUW_WPERILDS     - GIUW_WPERILDS_DTL
                **                   GIUW_WPOLICYDS    - GIUW_WPOLICYDS_DTL
                **                   GIUW_WITEMDS      - GIUW_WITEMDS_DTL
                **                   GIUW_WITEMPERILDS - GIUW_WITEMPERILDS_DTL */
              
                    --ADJUST_NET_RET_IMPERFECTION(p_dist_no); --edgar 09/15/2014
                    
                    
                 -- jhing 11.26.2014 commented out codes in adjustment. This will be included in the procedure for setting up default distribution                    
                  /*added edgar for new adjustments*/
                  --  IF  NVL(v_post_flag,'O') = 'O' THEN
                  --      GIUW_POL_DIST_PKG.ADJUST_ALL_WTABLES_GIUWS004(p_dist_no);
                  --  ELSIF v_post_flag = 'P' THEN
                  --     ADJUST_DISTRIBUTION_PERIL_PKG.ADJUST_DISTRIBUTION(p_dist_no);
                  --  END IF;
                  /*ended edgar 09/15/2014*/  
                  
                  END LOOP; -- jhing 11.26.2014 
                    
                  -- jhing 11.26.2014 added code to correct premium of other DS Tables. Note this should only be used for unearned redistribution portion 
                  GIUW_POL_DIST_FINAL_PKG.update_dist_ds_prem (p_dist_no, p_policy_id);
                  
                  -- jhing 11.26.2014 call the new procedure for populating default distribution 
                  GIUW_POL_DIST_FINAL_PKG.POPULATE_DEFAULT_DIST ( p_dist_no, v_post_flag, v_dist_type );  
                  
                /* Create records in RI tables if a facultative
                ** share exists in any of the DIST_SEQ_NO in table
                ** GIUW_WPOLICYDS_DTL. */
              
                 --   GIUW_POL_DIST_FINAL_PKG.CREATE_RI_RECORDS_GIUWS010(p_dist_no, p_policy_id, p_line_cd, p_subline_cd);  -- jhing 11.21.2014 commented out GIRI_WDISTFRPS should be created upon posting of dist

                /* Set the value of the DIST_FLAG back 
                ** to Undistributed after recreation. */
                  UPDATE giuw_pol_dist
                     SET dist_flag = '1',
                         post_flag = v_post_flag,
                         dist_type = '2',
                         special_dist_sw = 'N'
                   WHERE policy_id = p_policy_id
                     AND dist_no   = p_dist_no;
        
         ELSE -- dist_flag
         
              -- jhing 11.26.2014 commented out. Default distribution will be processed in a separate procedure hence there is no need to query this here.
            --              /*added edgar 09/09/2014 so that policy with at least one item that has zero TSI and Prem is distributed using One-Risk only*/
             /*             FOR i IN (SELECT item_no,
                                          SUM(tsi_amt)     policy_tsi      ,
                                          SUM(prem_amt)    policy_premium  ,
                                          SUM(ann_tsi_amt) policy_ann_tsi  
                                     FROM GIPI_ITEM a
                                    WHERE policy_id = p_policy_id
                                      AND EXISTS (SELECT 1
                                                    FROM GIPI_ITMPERIL
                                                   WHERE policy_id = a.policy_id
                                                     AND item_no = a.item_no)
                                    GROUP BY item_no)
                          LOOP
                            IF i.policy_tsi = 0 AND i.policy_premium = 0 THEN
                                v_exist2 := 'Y';
                                EXIT;
                            END IF; 
                          END LOOP;        
                          FOR pol IN (SELECT a.pol_flag, b.par_type
                                        FROM gipi_polbasic a, gipi_parlist b
                                       WHERE a.policy_id = p_policy_id
                                         AND a.par_id = b.par_id)
                          LOOP
                              BEGIN
                                IF pol.pol_flag = '2' THEN
                                    FOR post IN (SELECT post_flag , dist_flag 
                                                   FROM GIUW_POL_DIST 
                                                  WHERE dist_no = 
                                                         (SELECT max(dist_no) 
                                                            FROM GIUW_POL_DIST 
                                                           WHERE policy_id = 
                                                                     ( SELECT MAX(old_policy_id) 
                                                                        FROM GIPI_POLNREP
                                                                       WHERE ren_rep_sw = '1'
                                                                         AND new_policy_id = (SELECT policy_id
                                                                                                FROM gipi_polbasic
                                                                                               WHERE pol_flag <> '5'
                                                                                                 AND policy_id = p_policy_id))))
                                    LOOP
                                        IF post.dist_flag in ( '2', '3') THEN 
                                            v_post_flag := post.post_flag;
                                        END IF;
                                    END LOOP;
                                ELSIF pol.par_type = 'E' THEN                                                    
                                    SELECT post_flag, v_temp_dist_flag 
                                      INTO v_post_flag, v_dist_flag
                                      FROM giuw_pol_dist
                                     WHERE dist_no =
                                          (SELECT MAX(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE par_id = (SELECT par_id
                                                             FROM gipi_polbasic
                                                            WHERE endt_seq_no = 0
                                                              AND (line_cd,
                                                                   subline_cd,
                                                                   iss_cd,
                                                                   issue_yy,
                                                                   pol_seq_no,
                                                                   renew_no
                                                                  ) =
                                                                     (SELECT line_cd, subline_cd, iss_cd, issue_yy,
                                                                             pol_seq_no, renew_no
                                                                        FROM gipi_polbasic
                                                                       WHERE policy_id = p_policy_id)));      
                                    
                                     IF v_temp_dist_flag NOT IN ('2', '3') THEN
                                        v_post_flag := NULL;
                                     END IF;
                                ELSE        
                                     v_post_flag := NULL;    
                                END IF;
                              EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                     v_post_flag := NULL;
                              END; 
                          EXIT;
                          END LOOP;    */           
            --              /*ended edgar 09/09/2014*/     
                FOR c1 IN (SELECT NVL(item_grp, 1) item_grp        ,
                                  pack_line_cd     pack_line_cd    ,
                                  pack_subline_cd  pack_subline_cd ,
                                  currency_rt      currency_rt     ,
                                  SUM(tsi_amt)     policy_tsi      ,
                                  SUM(prem_amt)    policy_premium  ,
                                  SUM(ann_tsi_amt) policy_ann_tsi
                             FROM gipi_item
                            WHERE policy_id = p_policy_id
							/* 10/06/2011 bmq - commented out to cater other item_grp -FPAC*/ --added by steven 11/28/2012: copied from FMB
                              --AND item_grp = v_item_grp
                         GROUP BY item_grp , pack_line_cd , pack_subline_cd ,
                                  currency_rt
                             ORDER BY pack_line_cd, pack_subline_cd , item_grp , currency_rt ) -- jhing 11.28.2014 added order by 
                LOOP

                    /* If the POLICY processed is a package policy
                    ** then get the true LINE_CD and true SUBLINE_CD,
                    ** that is, the PACK_LINE_CD and PACK_SUBLINE_CD 
                    ** from the GIPI_ITEM table.
                    ** This will be used upon inserting to certain
                    ** distribution tables requiring a value for
                    ** the similar field. */
                
                    IF p_pack_pol_flag = 'N' THEN
                       v_line_cd    := p_line_cd;
                       v_subline_cd := p_subline_cd;
                    ELSE
                       v_line_cd           := c1.pack_line_cd;
                       v_subline_cd        := c1.pack_subline_cd;
                       v_package_policy_sw := 'Y';
                    END IF;

                    -- jhing 11.26.2014 commented out block of code. Any default distribution setup will be setup/retrieved in the 
                    -- new procedure for populating default distribution 
                    
                    /*                    IF v_package_policy_sw = 'Y' THEN
                                           FOR c2 IN (SELECT default_no, default_type, dist_type,
                                                             dflt_netret_pct
                                                        FROM giis_default_dist
                                                       WHERE iss_cd     = p_iss_cd
                                                         AND subline_cd = v_subline_cd
                                                         AND line_cd    = v_line_cd)
                                           LOOP
                                             v_default_no      := c2.default_no;
                                             v_default_type    := c2.default_type;
                                             v_dist_type       := c2.dist_type;
                                             v_dflt_netret_pct := c2.dflt_netret_pct;
                                             EXIT;
                                           END LOOP;
                                           
                                           IF NVL(v_dist_type, '1') = '1' THEN
                                             rg_count := 0 ;
                                             FOR z IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                                                      a.share_amt1 , a.peril_cd , a.share_amt2 , 
                                                              1 true_pct 
                                                         FROM giis_default_dist_group a 
                                                        WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
                                                          AND a.line_cd    = v_line_cd 
                                                          AND a.share_cd   <> 999 
                                                     ORDER BY a.sequence ASC)
                                             LOOP
                                               rg_count := z.rownum; 
                                             END LOOP;
                                           ELSIF v_dist_type = '2' AND v_post_flag = 'O' THEN --edgar 09/09/2014
                                              rg_count := 0;              --edgar 09/09/2014                         
                                           END IF;
                                           v_package_policy_sw := 'N';
                                        ELSE /*edgar 09/09/2014*/
                /*                           FOR c2 IN (SELECT default_no, default_type, dist_type,
                                                             dflt_netret_pct
                                                        FROM giis_default_dist
                                                       WHERE iss_cd     = p_iss_cd
                                                         AND subline_cd = v_subline_cd
                                                         AND line_cd    = v_line_cd)
                                           LOOP
                                             v_default_no      := c2.default_no;
                                             v_default_type    := c2.default_type;
                                             v_dist_type       := c2.dist_type;
                                             v_dflt_netret_pct := c2.dflt_netret_pct;
                                             EXIT;
                                           END LOOP;
                                           
                                           IF NVL(v_dist_type, '1') = '1' THEN
                                             rg_count := 0 ;
                                             FOR z IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                                                      a.share_amt1 , a.peril_cd , a.share_amt2 , 
                                                              1 true_pct 
                                                         FROM giis_default_dist_group a 
                                                        WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
                                                          AND a.line_cd    = v_line_cd 
                                                          AND a.share_cd   <> 999 
                                                     ORDER BY a.sequence ASC)
                                             LOOP
                                               rg_count := z.rownum; 
                                             END LOOP;
                                           ELSIF v_dist_type = '2' AND v_post_flag = 'O' THEN --edgar 09/09/2014
                                              rg_count := 0;              --edgar 09/09/2014                         
                                           END IF;
                                           v_package_policy_sw := 'N';
                                           /*ended edgar 09/09/2014*/                    
                 /*                       END IF;  */

                    /* Generate a new DIST_SEQ_NO for the new
                    ** item group. */
                    v_dist_seq_no := v_dist_seq_no + 1;
                    
                    -- jhing 11.26.2014 regardless of dist type, just use CRTE_GRP_DFLT_DIST_GWS018. This procedure will only populate the DS tables now. The DTL 
                    -- tables will be populated by a new procedure
                    GIUW_POL_DIST_FINAL_PKG.CRTE_GRP_DFLT_DIST_GWS018
                                 (p_dist_no      , v_dist_seq_no     , '2'               ,
                                  c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                  c1.item_grp    , v_line_cd         , rg_count          ,
                                  v_default_type , c1.currency_rt    , p_policy_id       ,
                                  v_default_no);  

 
                    -- jhing 11.26.2014 commented out blocks of code 
                                     
                    --                    /*added edgar 09/08/2014*/
                    /*                    IF v_exist2 = 'Y' THEN
                                               v_post_flag := 'O';
                                              GIUW_POL_DIST_FINAL_PKG.CRTE_GRP_DFLT_DIST_GWS018
                                                     (p_dist_no      , v_dist_seq_no     , '2'               ,
                                                      c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                                      c1.item_grp    , v_line_cd         , rg_count          ,
                                                      v_default_type , c1.currency_rt    , p_policy_id       ,
                                                      v_default_no);      
                                        ELSE
                                        /*ended edgar 09/08/2014*/
                     /*                       IF NVL(v_dist_type, '1') = '1' AND v_post_flag = 'O' THEN --added post_flag edgar 09/09/2014
                                               v_post_flag := 'O';
                                              GIUW_POL_DIST_FINAL_PKG.CRTE_GRP_DFLT_DIST_GWS018
                                                     (p_dist_no      , v_dist_seq_no     , '2'               ,
                                                      c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                                      c1.item_grp    , v_line_cd         , rg_count          ,
                                                      v_default_type , c1.currency_rt    , p_policy_id       ,
                                                      v_default_no);
                                            /*added edgar 09/09/2014*/
                    /*                        ELSIF NVL(v_dist_type, '1') = '1' AND v_post_flag = 'P' THEN
                                               v_post_flag := 'P';
                                               v_default_type := 0;
                                                 GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_DIST_GWS018
                                                  (p_dist_no      , v_dist_seq_no     , '2'               ,
                                                   c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                                   c1.item_grp    , v_line_cd         , v_default_no      ,
                                                   v_default_type , v_dflt_netret_pct , c1.currency_rt    ,
                                                   p_policy_id);        
                                            ELSIF NVL(v_dist_type, '1') = '2' AND v_post_flag = 'O' THEN
                                               v_post_flag := 'O';
                                              GIUW_POL_DIST_FINAL_PKG.CRTE_GRP_DFLT_DIST_GWS018
                                                     (p_dist_no      , v_dist_seq_no     , '2'               ,
                                                      c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                                      c1.item_grp    , v_line_cd         , rg_count          ,
                                                      v_default_type , c1.currency_rt    , p_policy_id       ,
                                                      v_default_no);          
                                            /*ended edgar 09/09/2014*/                                  
                    /*                        ELSIF NVL(v_dist_type,'1') = '2' AND v_post_flag = 'P' THEN --added post_flag edgar 09/09/2014 -- jhing 11.24.2014 added nvl 
                                                 v_post_flag := 'P';
                                                 GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_DIST_GWS018
                                                  (p_dist_no      , v_dist_seq_no     , '2'               ,
                                                   c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                                   c1.item_grp    , v_line_cd         , v_default_no      ,
                                                   v_default_type , v_dflt_netret_pct , c1.currency_rt    ,
                                                   p_policy_id);
                                            /*added edgar 09/17/2014*/
                   /*                         ELSIF v_dist_type = '1' AND v_post_flag IS NULL THEN
                                               v_post_flag := 'O';
                                              GIUW_POL_DIST_FINAL_PKG.CRTE_GRP_DFLT_DIST_GWS018
                                                     (p_dist_no      , v_dist_seq_no     , '2'               ,
                                                      c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                                      c1.item_grp    , v_line_cd         , rg_count          ,
                                                      v_default_type , c1.currency_rt    , p_policy_id       ,
                                                      v_default_no);
                                            ELSIF v_dist_type = '2' AND v_post_flag IS NULL THEN  
                                                 v_post_flag := 'P';
                                                 GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_DIST_GWS018
                                                  (p_dist_no      , v_dist_seq_no     , '2'               ,
                                                   c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                                                   c1.item_grp    , v_line_cd         , v_default_no      ,
                                                   v_default_type , v_dflt_netret_pct , c1.currency_rt    ,
                                                   p_policy_id);                    
                                            /*ended edgar 09/17/2014*/                               
                     /*                       END IF;
                                        END IF;--edgar 09/09/2014  */

               END LOOP;
             
               /* Adjust computational floats to equalize the amounts
               ** attained by the master tables with that of its detail
               ** tables.
               ** Tables involved:  GIUW_WPERILDS     - GIUW_WPERILDS_DTL
               **                   GIUW_WPOLICYDS    - GIUW_WPOLICYDS_DTL
               **                   GIUW_WITEMDS      - GIUW_WITEMDS_DTL
               **                   GIUW_WITEMPERILDS - GIUW_WITEMPERILDS_DTL */
                   --ADJUST_NET_RET_IMPERFECTION(p_dist_no); --edgar 09/15/
                   
                   -- jhing 11.26.2014 commented out. Adjustment now will be called in the new procedure for default distribution
                  /*added edgar for new adjustments*/
                  --  IF  NVL(v_post_flag,'O') = 'O' THEN
                  --      GIUW_POL_DIST_PKG.ADJUST_ALL_WTABLES_GIUWS004(p_dist_no);
                  -- ELSIF v_post_flag = 'P' THEN
                  --      ADJUST_DISTRIBUTION_PERIL_PKG.ADJUST_DISTRIBUTION(p_dist_no);
                  --  END IF;
                  /*ended edgar 09/15/2014*/  
                  
               /* Create records in RI tables if a facultative
               ** share exists in any of the DIST_SEQ_NO in table
               ** GIUW_WPOLICYDS_DTL. */
                --   GIUW_POL_DIST_FINAL_PKG.CREATE_RI_RECORDS_GIUWS010(p_dist_no, p_policy_id, p_line_cd, p_subline_cd);  -- jhing 11.21.2014 commented out . GIRI_WDISTFRPS should be created upon posting of dist

                
                  -- jhing 11.26.2014 call the new procedure for populating default distribution 
                  GIUW_POL_DIST_FINAL_PKG.POPULATE_DEFAULT_DIST ( p_dist_no, v_post_flag, v_dist_type ); 
 
               /* Set the value of the DIST_FLAG back 
               ** to Undistributed after recreation. */
                 UPDATE giuw_pol_dist
                    SET dist_flag = '1',
                        post_flag = v_post_flag,
                        dist_type = '2',
                        special_dist_sw = 'N'
                  WHERE policy_id = p_policy_id
                    AND dist_no   = p_dist_no;
         END IF;   
     END;

/**
**  Created by:     Belle Bebing
**  Date Created:   07.14.2011
**  Referenced by:  GIUWS018 - Set-up Peril Groups Distribution for Final 
**  Description:    Compares the tsi, premium and annualized amounts 
**                  from the gipi_item tables against the corresponding 
**                  amounts from the gipi_itmperil table
**/
 PROCEDURE COMP_GIPI_ITEM_ITMPERIL_GWS018 
    (p_policy_id         IN       GIPI_POLBASIC.policy_id%TYPE,
     p_pack_pol_flag     IN       GIPI_POLBASIC.pack_pol_flag%TYPE,
     p_line_cd           IN       GIPI_POLBASIC.line_cd%TYPE,
     p_message           OUT      VARCHAR2)
 
IS
    v_tsi_amt            NUMBER(16,2);
    v_prem_amt           NUMBER(12,2);
    v_ann_tsi_amt        NUMBER(16,2);
    v2_tsi_amt           NUMBER(16,2);
    v2_prem_amt          NUMBER(12,2);
    v2_ann_tsi_amt       NUMBER(16,2);
    v3_tsi_amt           NUMBER(16,2);
    v3_prem_amt          NUMBER(12,2);
    v3_ann_tsi_amt       NUMBER(16,2); 
    v4_tsi_amt           NUMBER(16,2);
    v4_prem_amt          NUMBER(12,2);
    v4_ann_tsi_amt       NUMBER(16,2);
    v_exist              VARCHAR2(1) := 'N';
    v_message            VARCHAR(100) := 'SUCCESS';
    
 BEGIN

   FOR a IN ( SELECT tsi_amt
                INTO v_tsi_amt
                FROM GIPI_ITEM
               WHERE policy_id = p_policy_id)
   LOOP 
    v_tsi_amt := a.tsi_amt;
     
      BEGIN    
      
         IF v_tsi_amt IS NULL THEN
            v_message := ('You have an invalid record in GIPI_ITEM.'||
                          ' No tsi_amt was fetched in this table.'); 
         END IF;
     
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_message := ('There are no records retrieved from gipi_item '||
                          'and gipi_itmperil for policy_id '|| TO_CHAR(p_policy_id)||
                          '. Please call your database administrator.');  
   
       END;
    END LOOP;
 
  IF p_pack_pol_flag = 'N' THEN

     BEGIN
       SELECT SUM(tsi_amt),
              SUM(prem_amt),
              SUM(ann_tsi_amt)
         INTO v_tsi_amt,
              v_prem_amt,
              v_ann_tsi_amt
         FROM gipi_item
        WHERE policy_id = p_policy_id;

       SELECT SUM(prem_amt)
         INTO v2_prem_amt
         FROM gipi_itmperil
        WHERE policy_id = p_policy_id;

       SELECT SUM(a.tsi_amt),
              SUM(a.ann_tsi_amt)
         INTO v2_tsi_amt,
              v2_ann_tsi_amt
         FROM gipi_itmperil a
        WHERE EXISTS
             (SELECT 1
                FROM giis_peril b
               WHERE b.peril_type = 'B'
                 AND b.peril_cd   = a.peril_cd
                 AND b.line_cd    = p_line_cd)
                 AND a.policy_id = p_policy_id;

       IF v_tsi_amt <> v2_tsi_amt THEN
          v_message := ('The total sum insured in gipi_item and gipi_itmperil does not tally.'||
                        ' Please call your database administrator.');
       ELSIF v_prem_amt <> v2_prem_amt THEN
             v_message := ('The premium amounts in gipi_item and gipi_itmperil does not tally.'||
                           ' Please call your database administrator.');
       END IF;

     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_message := ('There are no records retrieved from gipi_item '||
                       'and gipi_itmperil for policy_id '||TO_CHAR(p_policy_id)||
                       '. Please call your database administrator.');
       WHEN OTHERS THEN
         v_message := 'Other Exceptions'; 
     END;
     
  ELSE
  
     BEGIN
       v_exist := 'N';
       FOR c1 IN (SELECT SUM(tsi_amt)     tsi_amt     ,
                         SUM(prem_amt)    prem_amt    ,
                         SUM(ann_tsi_amt) ann_tsi_amt ,
                         pack_line_cd
                    FROM gipi_item
                   WHERE policy_id = p_policy_id
                GROUP BY pack_line_cd)
       LOOP
         v_tsi_amt     := c1.tsi_amt;
         v_prem_amt    := c1.prem_amt; 
         v_ann_tsi_amt := c1.ann_tsi_amt;
         
         FOR c2 IN (SELECT  SUM(a.tsi_amt)     tsi_amt,
                            SUM(a.ann_tsi_amt) ann_tsi_amt
                      FROM  gipi_itmperil a, gipi_item b
                     WHERE  EXISTS
                           (SELECT 1
                              FROM giis_peril c
                             WHERE c.peril_type = 'B'
                               AND c.peril_cd   = a.peril_cd
                               AND c.line_cd    = c1.pack_line_cd)
                       AND  a.item_no      = b.item_no
                       AND  a.policy_id    = b.policy_id
                       AND  b.pack_line_cd = c1.pack_line_cd 
                       AND  a.policy_id    = p_policy_id)
         LOOP
           v_exist := 'Y';
           v2_tsi_amt     := c2.tsi_amt;
           v2_ann_tsi_amt := c2.ann_tsi_amt;
           EXIT;
         END LOOP;
         IF v_exist = 'N' THEN
            EXIT;
         END IF;
         v3_tsi_amt     := NVL(v3_tsi_amt, 0)     + NVL(v_tsi_amt, 0);
         v3_prem_amt    := NVL(v3_prem_amt, 0)    + NVL(v_prem_amt, 0);
         v3_ann_tsi_amt := NVL(v3_ann_tsi_amt, 0) + v_ann_tsi_amt;
         v4_tsi_amt     := NVL(v4_tsi_amt, 0)     + v2_tsi_amt;
         v4_ann_tsi_amt := NVL(v4_ann_tsi_amt, 0) + v2_ann_tsi_amt;
       END LOOP;
       IF v_exist = 'N' THEN
          RAISE NO_DATA_FOUND;
       END IF;
       
       v_exist := 'N';
       
       FOR c1 IN (SELECT SUM(prem_amt) prem_amt
                    FROM gipi_itmperil
                   WHERE policy_id = p_policy_id)
       LOOP
         v_exist := 'Y';
         v4_prem_amt := c1.prem_amt;
         EXIT;
       END LOOP;
       IF v_exist = 'N' THEN
          RAISE NO_DATA_FOUND;
       END IF;
       IF v3_tsi_amt <> v4_tsi_amt THEN
          v_message := ('The total sum insured in gipi_item and gipi_itmperil does not tally.'||
                        ' Please call your database administrator.');
       ELSIF v3_prem_amt <> v4_prem_amt THEN
          v_message := ('The premium amounts in gipi_item and gipi_itmperil does not tally.'||
                        ' Please call your database administrator.');
       END IF;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_message := ('There are no records retrieved from gipi_item '||
                       'and gipi_itmperil for policy_id '||to_char(p_policy_id)||
                       '. Please call your database administrator.');
       WHEN OTHERS THEN
         v_message := 'Other Exceptions';
     END;
     
  END IF;
    p_message := v_message;
 END;
 
     /**
    **  Created by:     Belle Bebing
    **  Date Created:   07.18.2011
    **  Referenced by:  GIUWS018 - Set-up Peril Groups Distribution for Final
    **  Description:    CREATE_ITEMS Program Unit from GIUWS018
    **/
    
    PROCEDURE CREATE_ITEMS_GIUWS018
       (p_dist_no        IN     GIUW_POL_DIST.dist_no%TYPE,
        p_policy_id      IN     GIPI_POLBASIC.policy_id%TYPE,
        p_line_cd        IN     GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd     IN     GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd         IN     GIPI_POLBASIC.iss_cd%TYPE,
        p_pack_pol_flag  IN     GIPI_POLBASIC.pack_pol_flag%TYPE) IS

    BEGIN

      /* Create or recreate records in distribution tables GIUW_WPOLICYDS,
      ** GIUW_WPOLICYDS_DTL, GIUW_WITEMDS, GIUW_WITEMDS_DTL, GIUW_WITEMPERILDS,
      ** GIUW_WITEMPERILDS_DTL, GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
      GIUW_POL_DIST_FINAL_PKG.CRTE_POLICY_DIST_RECS_GIUWS018
        (p_dist_no    , p_policy_id , p_line_cd , 
         p_subline_cd , p_iss_cd    , p_pack_pol_flag);

      /* Set the value of the DIST_FLAG back 
      ** to Undistributed after recreation. */
      
      UPDATE GIUW_POL_DIST
         SET dist_flag = '1',
             dist_type = '1'
       WHERE policy_id = p_policy_id
         AND dist_no   = p_dist_no;

    END;
    
    /**
    **  Created by:     Belle Bebing
    **  Date Created:   07.19.2011
    **  Referenced by:  GIUWS018- Set-up Peril Groups Distribution for Final
    **  Description:    Delete affected records related to the regrouping process of the current
    **                  DIST_NO from the distribution and RI working tables.
    **                  Distribution tables affected:
    **                  GIUW_WPERILDS  and DTL, GIUW_WITEMPERILDS and DTL, GIUW_WITEMDS_DTL and GIUW_WPOLICYDS_DTL.
    **                  RI tables affected:
    **                  GIRI_WBINDER_PERIL, GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI and GIRI_WDISTFRPS 
    **/
    PROCEDURE DEL_AFFECTED_DIST_TABLE_GWS018 ( v_dist_no  giuw_pol_dist.dist_no%TYPE) 
    IS
 
    BEGIN
      
      DELETE giuw_wperilds_dtl
       WHERE dist_no = v_dist_no;
      DELETE giuw_witemperilds_dtl
       WHERE dist_no = v_dist_no;
      DELETE giuw_witemperilds
       WHERE dist_no = v_dist_no;
      DELETE giuw_witemds_dtl
       WHERE dist_no = v_dist_no;
      DELETE giuw_witemds
       WHERE dist_no = v_dist_no; 
      DELETE giuw_wpolicyds_dtl
       WHERE dist_no = v_dist_no;
      FOR c1 IN (SELECT frps_yy, frps_seq_no, line_cd /* jhing 11.27.2014 added line_cd */ 
                   FROM giri_wdistfrps
                  WHERE dist_no = v_dist_no)
      LOOP
        FOR c2 IN (SELECT pre_binder_id
                     FROM giri_wfrps_ri
                    WHERE frps_yy     = c1.frps_yy 
                      AND frps_seq_no = c1.frps_seq_no
                      AND line_cd = c1.line_cd /* jhing 11.27.2014 */ ) 
        LOOP
          DELETE giri_wbinder_peril
           WHERE pre_binder_id = c2.pre_binder_id; 
          DELETE giri_wbinder
           WHERE pre_binder_id = c2.pre_binder_id;
        END LOOP;
        DELETE giri_wfrperil
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no
           AND line_cd = c1.line_cd /* jhing 11.27.2014 */ ;
        DELETE giri_wfrps_ri
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no
           AND line_cd = c1.line_cd /* jhing 11.27.2014 */ ;
        -- jhing 11.27.2014    
        DELETE giri_wfrps_peril_grp
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no
           AND line_cd = c1.line_cd ;   
      END LOOP;
      DELETE giri_wdistfrps
       WHERE dist_no = v_dist_no;
    END;
    
    /**
    **  Created by:     Belle Bebing
    **  Date Created:   07.19.2011
    **  Referenced by:  GIUWS0108- Set-up Peril Groups Distribution for Final
    **  Description:    PRE_COMMIT trigger from GIUWS018
    **/

    PROCEDURE PRE_COMMIT_GIUWS018(p_dist_no                 IN GIUW_POL_DIST.dist_no%TYPE) IS

    BEGIN
           
         GIUW_POL_DIST_FINAL_PKG.DEL_AFFECTED_DIST_TABLE_GWS018(p_dist_no); 
         
         UPDATE GIUW_WPOLICYDS
            SET dist_flag = '1'
          WHERE dist_no   = p_dist_no;
         UPDATE GIUW_POL_DIST
            SET dist_flag = '1',
                dist_type = '1'
          WHERE dist_no   = p_dist_no;
    END;
    
    /**  Created by:     Belle Bebing
    **  Date Created:   07.19.2011
    **  Referenced by:  GIUWS018 - Set-up Peril Groups Distribution for Final
    **  Description:    RECREATE_GRP_DFLT_DIST Program Unit from GIUWS018
    **/

    PROCEDURE RECRTE_GRP_DFLT_DIST_GWS018
        (p_dist_no        IN giuw_wpolicyds.dist_no%TYPE,
         p_dist_seq_no    IN giuw_wpolicyds.dist_seq_no%TYPE,
         p_dist_flag      IN giuw_wpolicyds.dist_flag%TYPE,
         p_policy_tsi     IN giuw_wpolicyds.tsi_amt%TYPE,
         p_policy_premium IN giuw_wpolicyds.prem_amt%TYPE,
         p_policy_ann_tsi IN giuw_wpolicyds.ann_tsi_amt%TYPE,
         p_item_grp       IN giuw_wpolicyds.item_grp%TYPE,
         p_line_cd        IN giis_line.line_cd%TYPE,
         p_rg_count       IN OUT NUMBER,
         p_default_type   IN giis_default_dist.default_type%TYPE,
         p_currency_rt    IN gipi_item.currency_rt%TYPE,
         p_policy_id      IN gipi_polbasic.policy_id%TYPE,
         p_default_no     IN GIIS_DEFAULT_DIST.default_no%TYPE) IS


         dist_cnt            NUMBER;
         dist_max            giuw_pol_dist.dist_no%TYPE;
         v_max_takeup        giuw_pol_dist.takeup_seq_no%TYPE;
         v_current_takeup    giuw_pol_dist.takeup_seq_no%TYPE;
         v_redist_sw         VARCHAR2(1);
         v_err_in_seq        VARCHAR2(1); -- jhing 12.11.2014
         v_err_exists        VARCHAR2(1); -- jhing 12.11.2014

    BEGIN 
        
        DELETE FROM GIUW_WITEMDS
        WHERE DIST_NO = P_DIST_NO;
        
        
        DELETE FROM GIUW_WITEMPERILDS
        WHERE DIST_NO = P_DIST_NO;
    
    
        SELECT count(*), max(dist_no)
          INTO dist_cnt, dist_max
          FROM giuw_pol_dist
         WHERE policy_id = p_policy_id
           AND item_grp = p_item_grp
           AND dist_flag NOT IN ( 4, 5 ) ; -- jhing 11.26.2014 added checking of dist_flag 
           --aND DIST_FLAG NOT IN (3,4,5);--VJP 041210 
           
           
          -- jhing 11.26.2014 get maximum takeup seq no as basis for the recomputation of premium
          -- for long term. As of this period, redistribution of long term policy is restricted in web. Geniisys cannot handle this
          -- scenario yet hence, will not anticipate it in the code for the meantime.
          
          v_max_takeup := 1 ;
          FOR tk in (SELECT NVL(MAX(takeup_seq_no),1) takeup_seq_no
                        FROM giuw_pol_dist 
                                WHERE policy_id = p_policy_id )
          LOOP
            v_max_takeup := tk.takeup_seq_no;
            EXIT;
          END LOOP; 
          
          SELECT NVL(takeup_seq_no,1) 
            INTO v_current_takeup
            FROM giuw_pol_dist
                WHERE dist_no = p_dist_no; 
                
          v_redist_sw := 'N';
          FOR lp in (SELECT 1 FROM giuw_pol_dist
                        WHERE policy_id = p_policy_id
                            AND dist_flag = '5')
          LOOP
            v_redist_sw := 'Y';
            EXIT;
          END LOOP;      
          -- jhing 11.26.2014 end of added code       
    
          IF dist_cnt = 0 AND dist_max IS NULL THEN
            BEGIN
                SELECT count(*), max(dist_no)
                    INTO dist_cnt, dist_max
                    FROM giuw_pol_dist
                     WHERE policy_id = p_policy_id
                     AND item_grp IS NULL
                         AND DIST_FLAG NOT IN (3,4,5);--VJP 041210              
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    null;
            END;
          END IF;
 
      /* Create records in table GIUW_WPOLICYDS_DTL
      ** for the specified DIST_SEQ_NO. */
      /*(GIUW_POL_DIST_FINAL_PKG.RECRTE_GRP_DFLT_WPOLDS_GWS010 --RECREATE_GRP_DFLT_WPOLICYDS
        (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
         p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
         p_rg_count   , p_default_type   , p_currency_rt    ,
         p_policy_id  , p_item_grp       , p_default_no); */ -- jhing 11.25.2014 commented out  
        
      /* Get the amounts for each item in table GIUW_WITEMDS in preparation
      ** for data insertion to its corresponding detail distribution table. */
      FOR c2 IN (SELECT item_no     , tsi_amt , prem_amt ,ann_tsi_amt
                   FROM giuw_witemds
                  WHERE dist_seq_no = p_dist_seq_no
                    AND dist_no     = p_dist_no)
      LOOP
        /* Create records in table GIUW_WITEMDS_DTL
        ** for the specified DIST_SEQ_NO. */
       /* CREATE_GRP_DFLT_WITEMDS
          (p_dist_no      , p_dist_seq_no , c2.item_no  ,
           p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
           c2.ann_tsi_amt , p_rg_count    , p_default_no); */ -- jhing commented out 11.25.2014 
           
       IF  v_redist_sw = 'Y' THEN -- jhing 11.26.2014 added code for redistribution...     

            /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
            ** in table GIPI_WITMPERL in preparation for data insertion to 
            ** distribution tables GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL. */
            FOR c3a IN (SELECT B380.tsi_amt      itmperil_tsi  ,
                                         (B380.prem_amt - SUM(c150.dist_prem)) itmperil_premium ,
                                          B380.ann_tsi_amt  itmperil_ann_tsi  ,
                                          B380.item_no      item_no ,
                                          B380.peril_cd     peril_cd                                                          
                                   FROM GIPI_ITMPERIL B380, GIPI_ITEM B340,
                                        GIUW_ITEMPERILDS_DTL C150
                                   WHERE B380.item_no     = B340.item_no
                                     AND B380.policy_id   = B340.policy_id
                                     AND B340.item_no     = C150.item_no
                                     AND B380.peril_cd    = C150.peril_cd
                                     AND B380.line_cd     = C150.line_cd
                                     AND B340.policy_id   = p_policy_id
                                     AND B340.item_grp       = p_item_grp
                                     AND B380.item_no = c2.item_no
                                     AND C150.dist_no IN (SELECT dist_no
                                                          FROM GIUW_POL_DIST
                                                          WHERE policy_id = p_policy_id
                                                          AND dist_flag IN (2,3))
                                     AND EXISTS (SELECT 1 FROM
                                                    GIUW_WPERILDS 
                                                        WHERE dist_no = p_dist_no
                                                            AND dist_seq_no = p_dist_seq_no 
                                                            AND peril_cd = B380.peril_cd )                    
                                      GROUP BY B380.tsi_amt, B380.ann_tsi_amt, B380.item_no, 
                                               B380.peril_cd, B340.pack_line_cd, B380.prem_amt
                                      ORDER BY B380.peril_cd)
            LOOP
            
                  /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
                  ** for the specified DIST_SEQ_NO. */
                    INSERT INTO  GIUW_WITEMPERILDS  
                      (dist_no             , dist_seq_no   , item_no         ,
                       peril_cd            , line_cd       , tsi_amt         ,
                       prem_amt            , ann_tsi_amt)
                    VALUES 
                      (p_dist_no           , p_dist_seq_no , c3a.item_no      ,
                       c3a.peril_cd         , p_line_cd     , c3a.itmperil_tsi , 
                       c3a.itmperil_premium , c3a.itmperil_ann_tsi);
                 
            END LOOP;
            
        ELSE  -- regular - non redistributed including long term
        
        /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
            ** in table GIPI_WITMPERL in preparation for data insertion to 
            ** distribution tables GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL. */
            
            FOR c3 IN (SELECT B380.tsi_amt      itmperil_tsi        ,
                              B380.prem_amt     itmperil_premium ,
                              B380.ann_tsi_amt  itmperil_ann_tsi ,
                              B380.item_no      item_no          ,
                              B380.peril_cd     peril_cd                                                          
                         FROM gipi_itmperil B380, 
                              gipi_item B340
                        WHERE B380.item_no   = B340.item_no
                          AND B380.policy_id = B340.policy_id
                          AND B340.item_no   = c2.item_no
                          AND B380.peril_cd IN (SELECT peril_cd 
                                                  FROM giuw_wperilds
                                                 WHERE dist_no = p_dist_no
                                                   AND dist_seq_no = p_dist_seq_no
                          AND line_cd = p_line_cd)
                          AND B340.policy_id = p_policy_id
                     GROUP BY B380.tsi_amt, B380.ann_tsi_amt, B380.item_no, 
                              B380.peril_cd, B380.prem_amt
                     ORDER BY B380.peril_cd)
            LOOP
              /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
              ** for the specified DIST_SEQ_NO. */
              IF /*p_dist_no = dist_max*/ v_current_takeup = v_max_takeup THEN -- jhing 11.26.2014 replaced condition and variables 
                    c3.itmperil_tsi     := NVL(c3.itmperil_tsi,0);
                        c3.itmperil_premium    := NVL(c3.itmperil_premium,0) - (ROUND((NVL(c3.itmperil_premium,0)//*dist_cnt*/ v_max_takeup),2) * (/*dist_cnt*/ v_max_takeup - 1));
                        c3.itmperil_ann_tsi := NVL(c3.itmperil_ann_tsi,0);
              ELSE
                        IF dist_cnt = 0 THEN
                            dist_cnt := 1;
                        END IF;
                        c3.itmperil_tsi     := ROUND((NVL(c3.itmperil_tsi,0)),2);
                        c3.itmperil_premium    := ROUND((NVL(c3.itmperil_premium,0)//*dist_cnt*/ v_max_takeup ),2);
                        c3.itmperil_ann_tsi := ROUND((NVL(c3.itmperil_ann_tsi,0)),2);
              END IF;
              
              INSERT INTO  giuw_witemperilds  
                (dist_no             , dist_seq_no    , item_no         ,
                 peril_cd            , line_cd        , tsi_amt         ,
                 prem_amt            , ann_tsi_amt)
                    VALUES 
                        (p_dist_no           , p_dist_seq_no  , c2.item_no      ,
                 c3.peril_cd         , p_line_cd      , c3.itmperil_tsi , 
                 c3.itmperil_premium , c3.itmperil_ann_tsi);
                 
              /*CREATE_GRP_DFLT_WITEMPERILDS
                (p_dist_no           , p_dist_seq_no       , c2.item_no      ,
                 p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                 c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count      ,
                 p_default_no); */ -- jhing 11.25.2014 commented out 

            END LOOP;        
        
        END IF;
      END LOOP;    
      
      -- jhing 11.27.2014 added code to adjust DS tables based on giuw_witemperilds
      -- for redistributed shares
       IF  v_redist_sw = 'Y' THEN
       
            GIUW_POL_DIST_FINAL_PKG.update_dist_ds_prem (p_dist_no, p_policy_id);
       END IF;
      
      v_err_exists := 'N';
      GIUW_POL_DIST_FINAL_PKG.check_missing_dist_rec_peril (p_dist_no, p_policy_id , v_err_exists );
      IF v_err_exists = 'Y' THEN
           RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#There are missing distribution records. Please recreate the items before re-grouping the items.'); 
      END IF; 

      -- jhing 11.25.2014 commented out whole for loop block. Other tables will be populated after base table ( GIUW_WPOLICYDS_DTL or GIUW_WPERILDS_DTL )
      -- have been populated with default distribution logic.
         /*     FOR c4 IN (SELECT SUM(tsi_amt)     tsi_amt     ,
                                SUM(prem_amt)    prem_amt    ,
                                SUM(ann_tsi_amt) ann_tsi_amt ,
                                dist_no          dist_no     ,
                                dist_seq_no      dist_seq_no ,
                                line_cd          line_cd     ,
                                peril_cd         peril_cd    
                           FROM giuw_witemperilds
                          WHERE dist_seq_no = p_dist_seq_no
                            AND dist_no     = p_dist_no
                       GROUP BY dist_no, dist_seq_no, line_cd, peril_cd)
              LOOP
                /* Create records in table GIUW_WPERILDS and GIUW_WPERILDS_DTL
                ** for the specified DIST_SEQ_NO. */
                
        /*        CREATE_GRP_DFLT_WPERILDS
                  (p_dist_no      , p_dist_seq_no , p_line_cd   ,
                   c4.peril_cd    , c4.tsi_amt    , c4.prem_amt ,
                   c4.ann_tsi_amt , p_rg_count    , p_default_no);
                END LOOP;  */
        

    END;
    
    /**  Created by:     Belle Bebing
    **  Date Created:   07.19.2011
    **  Referenced by:  GIUWS018 - Set-up Peril Groups Distribution for Final
    **  Description:    RECREATE_PERIL_DFLT_DIST Program Unit from GIUWS018
    **/

    PROCEDURE RECRTE_PERIL_DFLT_DIST_GWS018
         (p_dist_no         IN giuw_wpolicyds.dist_no%TYPE,
          p_dist_seq_no     IN giuw_wpolicyds.dist_seq_no%TYPE,
          p_dist_flag       IN giuw_wpolicyds.dist_flag%TYPE,
          p_policy_tsi      IN giuw_wpolicyds.tsi_amt%TYPE,
          p_policy_premium  IN giuw_wpolicyds.prem_amt%TYPE,
          p_policy_ann_tsi  IN giuw_wpolicyds.ann_tsi_amt%TYPE,
          p_item_grp        IN giuw_wpolicyds.item_grp%TYPE,
          p_line_cd         IN giis_line.line_cd%TYPE,
          p_default_no      IN giis_default_dist.default_no%TYPE,
          p_default_type    IN giis_default_dist.default_type%TYPE,
          p_dflt_netret_pct IN giis_default_dist.dflt_netret_pct%TYPE,
          p_currency_rt     IN gipi_item.currency_rt%TYPE,
          p_policy_id       IN gipi_polbasic.policy_id%TYPE) IS

          v_peril_cd           giis_peril.peril_cd%TYPE;
          v_peril_tsi           giuw_wperilds.tsi_amt%TYPE      := 0;
          v_peril_premium       giuw_wperilds.prem_amt%TYPE     := 0;
          v_peril_ann_tsi       giuw_wperilds.ann_tsi_amt%TYPE  := 0;
          v_exist               VARCHAR2(1)                     := 'N';
          v_insert_sw           VARCHAR2(1)                     := 'N';
          v_dist_flag           gipi_polbasic.dist_flag%TYPE;
          
      /* Updates the amounts of the previously processed PERIL_CD
      ** while looping inside cursor C3.  After which, the records
      ** for table GIUW_WPERILDS_DTL are also created.
      ** NOTE:  This is a LOCAL PROCEDURE BODY called below. */
      PROCEDURE  UPD_CREATE_WPERIL_DTL_DATA IS
      BEGIN
        FOR A1 IN (SELECT line_cd,   peril_cd,   tsi_amt, 
                          prem_amt,  ann_tsi_amt
                     FROM giuw_wperilds
                    WHERE dist_no = p_dist_no
                      AND dist_seq_no = p_dist_seq_no)
        LOOP                                
          GIUW_POL_DIST_FINAL_PKG.CRTE_PERL_DFLT_WPERILDS_GWS010
              (p_dist_no       , p_dist_seq_no , p_line_cd       ,
               A1.peril_cd     , A1.tsi_amt    , A1.prem_amt  ,
               A1.ann_tsi_amt  , p_currency_rt , p_default_no    ,
               p_default_type  , p_dflt_netret_pct);
        END LOOP;        
      END;

     BEGIN

        /* Initialize the value of the variables
        ** in preparation for processing the new
        ** DIST_SEQ_NO. */
        v_peril_cd      := NULL;
        v_peril_tsi     := 0;
        v_peril_premium := 0;
        v_peril_ann_tsi := 0;   
        v_exist         := 'N';

        /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
        ** in table GIPI_WITMPERL in preparation for data insertion to 
        ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
        ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
        FOR a IN (SELECT dist_flag
                    FROM giuw_pol_dist
                   WHERE policy_id = (SELECT policy_id
                                        FROM giuw_pol_dist
                                       WHERE dist_no = p_dist_no)
                     AND dist_flag = 5)
        LOOP
            v_dist_flag := a.dist_flag;                              
        END LOOP;
  
          IF v_dist_flag = 5 THEN
            FOR c3 IN (SELECT B380.tsi_amt      itmperil_tsi,
                              B380.prem_amt - SUM(c170.dist_prem) itmperil_premium ,
                              B380.ann_tsi_amt  itmperil_ann_tsi ,
                              B380.item_no      item_no ,
                              B380.peril_cd     peril_cd                                          
                         FROM gipi_itmperil B380, gipi_item B340,
                              giuw_itemperilds_dtl C170,
                              giuw_wperilds C150, giuw_witemds c160    
                        WHERE B380.item_no     = B340.item_no
                          AND B380.policy_id   = B340.policy_id
                          AND B340.item_no     = C170.item_no
                          AND B380.peril_cd    = C170.peril_cd
                          AND B380.line_cd     = C170.line_cd
                          AND B340.policy_id   = p_policy_id
                          AND C170.dist_seq_no = p_dist_seq_no
                          AND B340.item_grp    = p_item_grp
                          AND B340.item_no     = C160.item_no
                          AND B380.peril_cd    = C150.peril_cd
                          AND b380.line_cd     = C150.line_cd
                          AND C150.dist_no     = C160.dist_no
                          AND C150.dist_seq_no = C160.dist_seq_no
                          AND C150.dist_seq_no = p_dist_seq_no
                          AND C170.dist_no IN (SELECT dist_no
                                                 FROM giuw_pol_dist
                                                WHERE policy_id = p_policy_id
                                                  AND dist_flag IN (2,3))
                     GROUP BY B380.tsi_amt, B380.ann_tsi_amt, B380.item_no, 
                              B380.peril_cd, B380.prem_amt
                     ORDER BY B380.peril_cd)

            LOOP
              v_exist     := 'Y';
              /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
              ** for the specified DIST_SEQ_NO. */
              INSERT INTO  giuw_witemperilds  
                          (dist_no             , dist_seq_no   , item_no         ,
                           peril_cd            , line_cd       , tsi_amt         ,
                           prem_amt            , ann_tsi_amt)
                   VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                           c3.peril_cd         , p_line_cd     , c3.itmperil_tsi ,
                           c3.itmperil_premium , c3.itmperil_ann_tsi);
            END LOOP;
            
            --UPD_CREATE_WPERIL_DTL_DATA; -- jhing 11.25.2014 commented out 
            
            /* Create records in table GIUW_WITEMDS_DTL based on
            ** the values inserted to table GIUW_WITEMPERILDS_DTL. */
           -- GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_WITEMDS_GWS018(p_dist_no, p_dist_seq_no);  -- jhing 11.25.2014 commented out 
            /* Create records in table GIUW_WPOLICYDS_DTL based on
            ** the values inserted to table GIUW_WITEMDS_DTL. */
           -- CREATE_PERIL_DFLT_WPOLICYDS(p_dist_no, p_dist_seq_no);  -- jhing 11.25.2014 commented out 
           
       ELSE -- dist_flag
            FOR c3 IN (SELECT B380.tsi_amt     itmperil_tsi     ,
                              B380.prem_amt    itmperil_premium ,
                              B380.ann_tsi_amt itmperil_ann_tsi ,
                              B380.item_no     item_no          ,
                              B380.peril_cd    peril_cd
                         FROM gipi_itmperil B380, gipi_item B340,
                              giuw_wperilds C150, giuw_witemds c160
                        WHERE B380.item_no     = B340.item_no
                          AND B380.policy_id   = B340.policy_id
                          AND B340.item_no     = C160.item_no
                          AND B380.peril_cd    = C150.peril_cd
                          AND b380.line_cd     = C150.line_cd
                          AND B340.item_grp    = p_item_grp
                          AND B340.policy_id   = p_policy_id
                          AND C150.dist_no     = C160.dist_no
                          AND C150.dist_seq_no = C160.dist_seq_no
                          AND C150.dist_seq_no = p_dist_seq_no
                          AND C150.dist_no     = p_dist_no
                     ORDER BY B380.peril_cd)
            LOOP
              v_exist     := 'Y';
              /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
              ** for the specified DIST_SEQ_NO. */
              INSERT INTO  giuw_witemperilds  
                          (dist_no             , dist_seq_no   , item_no         ,
                           peril_cd            , line_cd       , tsi_amt         ,
                           prem_amt            , ann_tsi_amt)
                   VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                           c3.peril_cd         , p_line_cd     , c3.itmperil_tsi ,
                           c3.itmperil_premium , c3.itmperil_ann_tsi);
            END LOOP;
          --  UPD_CREATE_WPERIL_DTL_DATA;  -- jhing 11.25.2014 commented out 
            /* Create records in table GIUW_WITEMDS_DTL based on
            ** the values inserted to table GIUW_WITEMPERILDS_DTL. */
           --  GIUW_POL_DIST_FINAL_PKG.CRTE_PERIL_DFLT_WITEMDS_GWS018(p_dist_no, p_dist_seq_no);  -- jhing 11.25.2014 commented out 
            /* Create records in table GIUW_WPOLICYDS_DTL based on
            ** the values inserted to table GIUW_WITEMDS_DTL. */
           --  CREATE_PERIL_DFLT_WPOLICYDS(p_dist_no, p_dist_seq_no);  -- jhing 11.25.2014 commented out 
        END IF;      
     END;
    
    
    /**
    **  Created by:     Belle Bebing
    **  Date Created:   07.19.2011
    **  Referenced by:  GIUWS018 - Set-up Peril Groups Distribution for Final 
    **  Description:    CREATE_REGROUPED_DIST_RECS Program Unit from GIUWS018
    **  Modified by:    Gzelle 07092014
    **/
    PROCEDURE CRTE_REGRPED_DIST_RECS_GWS018
         (p_dist_no       IN giuw_pol_dist.dist_no%TYPE    ,
          p_policy_id     IN gipi_polbasic.policy_id%TYPE  ,
          p_line_cd       IN gipi_polbasic.line_cd%TYPE    ,
          p_subline_cd    IN gipi_polbasic.subline_cd%TYPE ,
          p_iss_cd        IN gipi_polbasic.iss_cd%TYPE     ,
          p_pack_pol_flag IN gipi_polbasic.pack_pol_flag%TYPE,
          p_item_no       IN VARCHAR2,
          p_dist_seq_no   IN giuw_wperilds.dist_seq_no%TYPE,
          p_peril_type    IN giis_peril.peril_type%TYPE,
          p_peril_cd      IN giuw_wperilds.peril_cd%TYPE) IS
          
          v_line_cd             gipi_polbasic.line_cd%TYPE;
          v_subline_cd          gipi_polbasic.subline_cd%TYPE;
          v_currency_rt         gipi_item.currency_rt%TYPE;
          v_dist_seq_no         giuw_wpolicyds.dist_seq_no%TYPE := 0;
          rg_count              NUMBER;
          v_exist               VARCHAR2(1);
          v_default_no          giis_default_dist.default_no%TYPE;
          v_default_type        giis_default_dist.default_type%TYPE;
          v_dflt_netret_pct     giis_default_dist.dflt_netret_pct%TYPE;
          v_dist_type           giis_default_dist.dist_type%TYPE;
          v_post_flag           VARCHAR2(1)  := 'O';
          v_package_policy_sw   VARCHAR2(1)  := 'Y';
          v_exist2              VARCHAR2(1);
          v_item                giuw_witemds.item_no%TYPE;
          dist_cnt              NUMBER;
          dist_max              giuw_pol_dist.dist_no%type;
          v_item_grp            giuw_pol_dist.item_grp%type;

    BEGIN
         SELECT item_grp
          INTO v_item_grp
          FROM giuw_pol_dist
         WHERE policy_id = p_policy_id
           AND dist_no = p_dist_no;

        
        IF v_item_grp IS NULL THEN   
            SELECT count(*), max(dist_no)
              INTO dist_cnt, dist_max
              FROM giuw_pol_dist
             WHERE policy_id = p_policy_id
               AND item_grp IS NULL
               and dist_flag not in (3,4,5); --VJP 041210
        ELSE
            SELECT count(*), max(dist_no)
              INTO dist_cnt, dist_max
              FROM giuw_pol_dist
             WHERE policy_id = p_policy_id
               AND item_grp = v_item_grp; 
        END IF;   
 
       /*beth 04062000 create records in giuw_witemds used the record group EXISTING_ITEMPERILS as reference */
        /*FOR a IN (SELECT a.dist_no , a.dist_seq_no , a.peril_cd ,
                         a.tsi_amt , a.prem_amt    , a.ann_tsi_amt ,
                         b.peril_type
                   FROM giuw_wperilds a, giis_peril b       commented out by Gzelle 07092014
                  WHERE a.peril_cd = b.peril_cd
                    AND a.line_cd  = b.line_cd
                    AND a.dist_no = p_dist_no 
               ORDER BY b.peril_type desc )
        LOOP*/
               /*FOR row_no IN 1..:parameter.peril_count 
            LOOP
            --if new dist_seq_no = old dist_seq_no
            --and if new peril_cd = old peril_cdl select corresponding data
            --needed to populate giuw_witemds and giuw_witemds_dtl    
                
                IF a.dist_seq_no = GET_GROUP_NUMBER_CELL(rg_col1, row_no) AND
                   a.peril_cd    = GET_GROUP_NUMBER_CELL(rg_col2, row_no) THEN
                        v_item := GET_GROUP_NUMBER_CELL(rg_col3, row_no);*/
                     
                 FOR b IN (SELECT B380.tsi_amt      itmperil_tsi                                               ,
                                  B380.prem_amt     itmperil_premium ,
                                  B380.ann_tsi_amt  itmperil_ann_tsi                                           ,
                                  B380.item_no      item_no                                                    ,
                                  B380.peril_cd     peril_cd                                                          ,
                                  B340.pack_line_cd pack_line_cd
                             FROM gipi_itmperil B380, 
                                  gipi_item B340
                            WHERE B380.item_no   = B340.item_no
                              AND B380.policy_id = B340.policy_id
                              --AND B380.peril_cd  = p_peril_cd   --a.peril_cd    modified by Gzelle 07092014 -- jhing 11.28.2014 commented out 
                              AND B340.item_no   = TO_NUMBER(p_item_no) 
                              AND B340.policy_id = p_policy_id
                              AND EXISTS ( SELECT 1 FROM
                                            giuw_wpolicyds x , giuw_wperilds w
                                                WHERE x.dist_no = p_dist_no
                                                    AND x.item_grp = B340.item_grp 
                                                    AND x.dist_no = w.dist_no
                                                    AND x.dist_seq_no = w.dist_seq_no
                                                    AND w.peril_cd = B380.peril_cd
                                )                               
                         GROUP BY B380.tsi_amt, B380.ann_tsi_amt, B380.item_no, 
                                  B380.peril_cd, B340.pack_line_cd, B380.prem_amt
                          ORDER BY B380.peril_cd) 
                 
                 LOOP
                     v_exist2 := 'N';
                   FOR chk IN (SELECT '1'
                                 FROM giuw_witemds
                                WHERE dist_no = p_dist_no   --a.dist_no    modified by Gzelle 07092014
                                  AND dist_seq_no = p_dist_seq_no   --a.dist_seq_no modified by Gzelle 07092014
                                  AND item_no = b.item_no)
                   LOOP
                     v_exist2 := 'Y';
                     EXIT;
                   END LOOP;
                   IF p_peril_type = 'A' THEN --a.peril_type = 'A' THEN modified by Gzelle 07092014
                      b.itmperil_ann_tsi  := 0;
                      b.itmperil_tsi      := 0;
                   END IF;
                   IF v_exist2 = 'N' THEN
                             IF p_dist_no = dist_max THEN
                                 b.itmperil_tsi            := NVL(b.itmperil_tsi,0);  
                                 b.itmperil_premium        := NVL(b.itmperil_premium,0) - (ROUND((NVL(b.itmperil_premium,0)/dist_cnt),2) * (dist_cnt - 1)); 
                                 b.itmperil_ann_tsi        := NVL(b.itmperil_ann_tsi,0);
                             ELSE
                                    b.itmperil_tsi            := ROUND((NVL(b.itmperil_tsi,0)),2);
                                    b.itmperil_premium        := ROUND((NVL(b.itmperil_premium,0)/dist_cnt),2);
                                    b.itmperil_ann_tsi        := ROUND((NVL(b.itmperil_ann_tsi,0)),2);
                               END IF;
                      INSERT INTO giuw_witemds
                             (dist_no             , dist_seq_no         , item_no         ,
                              tsi_amt             , prem_amt            , ann_tsi_amt)
                      VALUES (p_dist_no           , p_dist_seq_no      , b.item_no       ,      --modified by Gzelle 07092014
                              b.itmperil_tsi      , b.itmperil_premium  , b.itmperil_ann_tsi);
                   ELSE
                       IF p_dist_no = dist_max THEN
                            b.itmperil_tsi            := NVL(b.itmperil_tsi,0);
                            b.itmperil_premium        := NVL(b.itmperil_premium,0) - (ROUND((NVL(b.itmperil_premium,0)/dist_cnt),2) * (dist_cnt - 1));
                            b.itmperil_ann_tsi        := NVL(b.itmperil_ann_tsi,0);
                       ELSE
                            b.itmperil_tsi            := ROUND((NVL(b.itmperil_tsi,0)),2);
                            b.itmperil_premium        := ROUND((NVL(b.itmperil_premium,0)/dist_cnt),2);
                            b.itmperil_ann_tsi        := ROUND((NVL(b.itmperil_ann_tsi,0)),2);
                       END IF;
                       
                        UPDATE giuw_witemds
                           SET tsi_amt     = tsi_amt     +   b.itmperil_tsi ,
                               prem_amt    = prem_amt    +   b.itmperil_premium,
                               ann_tsi_amt = ann_tsi_amt +   b.itmperil_ann_tsi 
                          WHERE dist_no = p_dist_no --a.dist_no     modified by Gzelle 07092014
                           AND dist_seq_no = p_dist_seq_no  --a.dist_seq_no     modified by Gzelle 07092014
                           AND item_no = b.item_no;
                   END IF;
                 END LOOP;
              -- END IF; 
        --END LOOP;
        /*commented out by Gzelle 07032014 moved to CRTE_REGRPED_DIST_RECS_FINAL*/
        /*FOR c1 IN (SELECT dist_seq_no , tsi_amt  , prem_amt ,
                            ann_tsi_amt , item_grp , rowid
                       FROM giuw_wpolicyds
                      WHERE dist_no = p_dist_no)
        LOOP
            --this for loop is to get PACK_LINE_CD and PACK_SUBLINE_CD
            --from GIPI_ITEM for PACKAGE POLICY.
            FOR c2 IN (SELECT currency_rt , pack_line_cd , pack_subline_cd
                         FROM gipi_item
                        WHERE item_grp  = c1.item_grp
                          AND policy_id = p_policy_id)
            LOOP

              v_currency_rt := c2.currency_rt;

              /* If the record processed is a package policy
              ** then get the true LINE_CD and true SUBLINE_CD,
              ** that is, the PACK_LINE_CD and PACK_SUBLINE_CD 
              ** from the GIPI_ITEM table.
              ** This will be used upon inserting to certain
              ** distribution tables requiring a value for
              ** the similar field. */
             /* IF p_pack_pol_flag = 'N' THEN
                 v_line_cd    := p_line_cd;
                 v_subline_cd := p_subline_cd;
              ELSE
                 v_line_cd           := c2.pack_line_cd;
                 v_subline_cd        := c2.pack_subline_cd;
                 v_package_policy_sw := 'Y';
              END IF;
              EXIT;
            END LOOP;
            
            --if it is a PACKAGE POLICY ...
            IF v_package_policy_sw = 'Y' THEN
               FOR c2 IN (SELECT default_no, default_type, dist_type,
                                 dflt_netret_pct
                            FROM giis_default_dist
                           WHERE iss_cd     = p_iss_cd
                             AND subline_cd = v_subline_cd
                             AND line_cd    = v_line_cd)
               LOOP
                 v_default_no      := c2.default_no;
                 v_default_type    := c2.default_type;
                 v_dist_type       := c2.dist_type;
                 v_dflt_netret_pct := c2.dflt_netret_pct;
                 EXIT;
               END LOOP;
               
               IF NVL(v_dist_type, '1') = '1' THEN
                  rg_count := 0;
                  FOR i IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                           a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                   1 true_pct 
                              FROM giis_default_dist_group a 
                             WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
                               AND a.line_cd    =  v_line_cd
                               AND a.share_cd   <> 999 
                          ORDER BY a.sequence ASC)
                  LOOP
                    rg_count := i.rownum;
                  END LOOP;
               END IF;
              
               v_package_policy_sw := 'N';
            END IF; --end of script for PACKAGE POLICY
            
            IF NVL(v_dist_type, '1') = '1' THEN
               v_post_flag := 'O';
               
               GIUW_POL_DIST_FINAL_PKG.RECRTE_GRP_DFLT_DIST_GWS018
                       (p_dist_no      , c1.dist_seq_no , '2'            ,
                        c1.tsi_amt     , c1.prem_amt    , c1.ann_tsi_amt ,
                        c1.item_grp    , v_line_cd      , rg_count       ,
                        v_default_type , v_currency_rt  , p_policy_id    ,
                        v_default_no);
            ELSIF v_dist_type = '2' THEN 
               v_post_flag := 'P';
               GIUW_POL_DIST_FINAL_PKG.RECRTE_PERIL_DFLT_DIST_GWS018
                   (p_dist_no      , c1.dist_seq_no    , '2'            ,
                    c1.tsi_amt     , c1.prem_amt       , c1.ann_tsi_amt ,
                    c1.item_grp    , v_line_cd         , v_default_no   ,
                    v_default_type , v_dflt_netret_pct , v_currency_rt  ,
                    p_policy_id);
            END IF;
        END LOOP;

      /* Adjust computational floats to equalize the amounts
      ** attained by the master tables with that of its detail
      ** tables.
      ** Tables involved:  GIUW_WPERILDS     - GIUW_WPERILDS_DTL
      **                   GIUW_WPOLICYDS    - GIUW_WPOLICYDS_DTL
      **                   GIUW_WITEMDS      - GIUW_WITEMDS_DTL
      **                   GIUW_WITEMPERILDS - GIUW_WITEMPERILDS_DTL */
         --ADJUST_NET_RET_IMPERFECTION(p_dist_no);

      /* Create records in RI tables if a facultative
      ** share exists in any of the DIST_SEQ_NO in table
      ** GIUW_WPOLICYDS_DTL. */
         --GIUW_POL_DIST_FINAL_PKG.CREATE_RI_RECORDS_GIUWS010(p_dist_no, p_policy_id, p_line_cd, p_subline_cd);

      /* Set the value of the DIST_FLAG back 
      ** to Undistributed after recreation. */

      /*UPDATE giuw_pol_dist
         SET dist_flag = '1',
             post_flag = v_post_flag,
             dist_type = '2'
       WHERE policy_id = p_policy_id
         AND dist_no   = p_dist_no;*/
    END;
    
    /**
    **  Created by:     Belle Bebing
    **  Date Created:   07.21.2011
    **  Referenced by:  GIUWS018 - Set-up Peril Groups Distribution for Final
    **  Description:    PRE_UPDATE trigger on Block C150 from GIUWS018
    **/
    
    PROCEDURE PRE_UPDATE_C150_GWS018
        (p_dist_no        IN    GIUW_WPOLICYDS.dist_no%TYPE,
         p_dist_seq_no    IN    GIUW_WPOLICYDS.dist_seq_no%TYPE,
         p_tsi_amt        IN    GIUW_WPOLICYDS.tsi_amt%TYPE,
         p_prem_amt       IN    GIUW_WPOLICYDS.prem_amt%TYPE,
         p_ann_tsi_amt    IN    GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
         p_item_grp       IN    GIUW_WPOLICYDS.item_grp%TYPE,
         p_policy_id      IN    GIPI_POLBASIC.policy_id%TYPE,
         p_peril_type     IN    GIIS_PERIL.peril_type%TYPE) AS
         
         v_tsi_amt          giuw_wpolicyds.tsi_amt%TYPE;
         v_ann_tsi_amt      giuw_wpolicyds.ann_tsi_amt%TYPE;
            
         CURSOR cur IS
                SELECT rowid , tsi_amt , prem_amt ,
                       ann_tsi_amt
                  FROM giuw_wpolicyds
                 WHERE dist_seq_no =  p_dist_seq_no
                   AND dist_no     =  p_dist_no
         FOR UPDATE OF tsi_amt, prem_amt, ann_tsi_amt;

          v_row           cur%ROWTYPE;

        BEGIN

          /* Check if the user-assigned DIST_SEQ_NO already exists
          ** in the parent table GIUW_WPOLICYDS.  If it doesn't, then
          ** a record with the said DIST_SEQ_NO must be created against
          ** said parent table. If it does exist, then the existing record
          ** must be updated to reflect its true value based on the changes
          ** made in this form. */
          OPEN cur;
          FETCH cur
           INTO v_row;
            IF cur%notfound THEN
              /* BETH 04062000 check for the records peril type, if it is an allied
               peril tsi_amt and ann_tsi_amt should not be added to giuw_policyds amounts of it's current dist_seq_no.*/
                 IF p_peril_type = 'A' THEN
                      v_tsi_amt     := 0;
                      v_ann_tsi_amt := 0;
                 ELSE
                      v_tsi_amt     := p_tsi_amt;
                      v_ann_tsi_amt := p_ann_tsi_amt;
                 END IF;

                 INSERT INTO  giuw_wpolicyds
                             (dist_no       , dist_seq_no       , dist_flag         ,
                              tsi_amt       , prem_amt          , ann_tsi_amt       ,
                              item_grp)
                      VALUES (p_dist_no , p_dist_seq_no , 1             ,
                              v_tsi_amt , p_prem_amt    , v_ann_tsi_amt ,
                              p_item_grp);
           ELSE
                 IF p_peril_type = 'A' THEN
                      v_tsi_amt     := 0;
                      v_ann_tsi_amt := 0;
                 ELSE
                      v_tsi_amt     := p_tsi_amt;
                      v_ann_tsi_amt := p_ann_tsi_amt;
                 END IF;
                 
                 UPDATE giuw_wpolicyds
                    SET tsi_amt     = v_row.tsi_amt     + v_tsi_amt ,
                        prem_amt    = v_row.prem_amt    + p_prem_amt ,
                        ann_tsi_amt = v_row.ann_tsi_amt + v_ann_tsi_amt
                  WHERE rowid       = v_row.rowid;
              END IF;
          CLOSE cur;

        END;
        
   /**
    **  Created by:     Belle Bebing
    **  Date Created:   07.21.2011
    **  Referenced by:  GIUWS018 - Set-up Peril Groups Distribution for Final
    **  Description:    POST_UPDATE trigger on Block C150 from GIUWS018
    **/
    
    PROCEDURE POST_UPDATE_C150_GWS018
        (p_dist_no          IN    GIUW_WPOLICYDS.dist_no%TYPE,
         p_orig_dist_seq_no IN    GIUW_WPOLICYDS.dist_seq_no%TYPE,
         p_tsi_amt          IN    GIUW_WPOLICYDS.tsi_amt%TYPE,
         p_prem_amt         IN    GIUW_WPOLICYDS.prem_amt%TYPE,
         p_ann_tsi_amt      IN    GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
         p_peril_type       IN    GIIS_PERIL.peril_type%TYPE) AS

         v_delete_sw     VARCHAR2(1);
         
    BEGIN

      /* Remove the current record from the DIST_SEQ_NO to
      ** which it originally belongs to, as the record 
      ** may have already been regrouped to some other
      ** DIST_SEQ_NO. */
      FOR c1 IN (SELECT rowid, tsi_amt , prem_amt ,ann_tsi_amt
                   FROM giuw_wpolicyds
                  WHERE dist_seq_no = p_orig_dist_seq_no
                    AND dist_no     = p_dist_no
          FOR UPDATE OF tsi_amt, prem_amt, ann_tsi_amt)
      LOOP
         /*BETH 04062000 check for the records peril type, if it is an allied
              peril tsi_amt and ann_tsi_amt should not be deducted to giuw_policyds amounts of it's original dist_seq_no. */           
         IF p_peril_type = 'B' THEN 
          UPDATE giuw_wpolicyds
             SET tsi_amt     = c1.tsi_amt     - p_tsi_amt  ,
                 prem_amt    = c1.prem_amt    - p_prem_amt ,
                 ann_tsi_amt = c1.ann_tsi_amt - p_ann_tsi_amt
           WHERE rowid    = c1.rowid;
         ELSE
               UPDATE giuw_wpolicyds
             SET prem_amt    = c1.prem_amt    - p_prem_amt                  
           WHERE rowid    = c1.rowid;
         END IF;
         --BETH 04062000 check if the tsi_amt, ann_tsi_amt is = 0 and there 
         --     are no records left for it's original dist_seq_no in giuw_wperilds
         --     table, if these conditions are true then giuw_policyds records
         --     of the original dist_se_no should be deleted.
         FOR A1 IN ( SELECT rowid,tsi_amt, ann_tsi_amt
                       FROM giuw_wpolicyds
                      WHERE dist_seq_no = p_orig_dist_seq_no
                       AND dist_no      = p_dist_no)
         LOOP
             IF a1.tsi_amt = 0 AND a1.ann_tsi_amt = 0 THEN
                  v_delete_sw := 'Y';
                  FOR A2 IN (SELECT '1'
                               FROM giuw_wperilds
                              WHERE dist_seq_no = p_orig_dist_seq_no
                              AND dist_no     = p_dist_no )
                LOOP              
                  v_delete_sw := 'N';
                END LOOP;
                IF v_delete_sw = 'Y' THEN
                   DELETE giuw_wpolicyds
                    WHERE rowid = a1.rowid;                                        
                END IF;    
             END IF;    
         END LOOP;     
    
      EXIT;
      END LOOP;
      
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Procedure to equalize values of tsi_amt, prem_amt, and ann_tsi_amt
**                 of master table and detail table 
*/
    
   PROCEDURE ADJUST_AMTS_GIUWS016 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE) IS  

    v_correct_dist_tsi                GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
    v_correct_dist_prem               GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
    v_correct_ann_dist_tsi            GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
    v_rowid                           VARCHAR2(100):= NULL;
    v_update_details                  VARCHAR2(1):= 'N';

   BEGIN  
    
    FOR a IN (
            SELECT dist_no,    dist_seq_no,    SUM(tsi_amt)             tsi_amt,
                   SUM(prem_amt) prem_amt,     SUM(ann_tsi_amt)     ann_tsi_amt 
            FROM GIUW_WPERILDS
            WHERE dist_no = p_dist_no
            GROUP BY dist_no, dist_seq_no)
     LOOP
         FOR b in (
             SELECT dist_no,    dist_seq_no,   SUM(dist_tsi)         tsi_amt,
                    SUM(dist_prem) prem_amt,   SUM(ann_dist_tsi) ann_tsi_amt 
             FROM GIUW_WPERILDS_DTL
             WHERE dist_no     = p_dist_no
             AND dist_seq_no = a.dist_seq_no                
             GROUP BY dist_no, dist_seq_no)
         LOOP             
             IF a.tsi_amt  <> b.tsi_amt OR    a.prem_amt <> b.prem_amt OR a.ann_tsi_amt <> b.ann_tsi_amt THEN 
                  --msg_alert('peril','I',FALSE);
                  UPDATE GIUW_WPERILDS_DTL c
                     SET c.dist_tsi      = c.dist_tsi + (a.tsi_amt - b.tsi_amt),
                         c.dist_prem     = c.dist_prem + (a.prem_amt - b.prem_amt),
                         c.ann_dist_tsi  = c.ann_dist_tsi + (a.ann_tsi_amt - b.ann_tsi_amt)
                   WHERE c.dist_seq_no   = a.dist_seq_no
                     AND (c.peril_cd, c.share_cd) = (SELECT MAX(peril_cd), MAX(share_cd) 
                                                     FROM GIUW_WPERILDS_DTL d
                                                     WHERE d.dist_no    = p_dist_no
                                                     AND d.dist_seq_no  = b.dist_seq_no)
                     AND c.dist_no      = p_dist_no; 
             END IF;             
         END LOOP;              
     END LOOP;
     
  FOR a IN (
        SELECT dist_no,         dist_seq_no, 
               SUM(tsi_amt)     tsi_amt,
               SUM(prem_amt)    prem_amt,   
               SUM(ann_tsi_amt) ann_tsi_amt 
        FROM GIUW_WITEMDS
        WHERE dist_no = p_dist_no
        GROUP BY dist_no, dist_seq_no)
     LOOP
         FOR b in (
                   SELECT dist_no,    dist_seq_no, 
                         SUM(dist_tsi)          tsi_amt,
                         SUM(dist_prem)      prem_amt,   
                         SUM(ann_dist_tsi) ann_tsi_amt 
                   FROM GIUW_WITEMDS_DTL
                   WHERE dist_no   = p_dist_no
                   AND dist_seq_no = a.dist_seq_no                
                   GROUP BY dist_no, dist_seq_no)
         LOOP
         --    msg_alert(a.tsi_amt||' - '||b.tsi_amt,'I',FALSE);
             --msg_alert(a.prem_amt||' - '||b.prem_amt,'I',FALSE);
             --msg_alert(a.ann_tsi_amt||' - '||b.ann_tsi_amt,'I',FALSE);
             IF a.tsi_amt     <> b.tsi_amt OR
                a.prem_amt    <> b.prem_amt OR  
                a.ann_tsi_amt <> b.ann_tsi_amt THEN 
                  --msg_alert('item','I',FALSE);
                  UPDATE GIUW_WITEMDS_DTL c
                     SET c.dist_tsi      = c.dist_tsi + (a.tsi_amt - b.tsi_amt),
                         c.dist_prem     = c.dist_prem + (a.prem_amt - b.prem_amt),
                         c.ann_dist_tsi  = c.ann_dist_tsi + (a.ann_tsi_amt - b.ann_tsi_amt)
                   WHERE c.dist_seq_no   = a.dist_seq_no
                     AND (c.item_no, c.share_cd)  = (SELECT MAX(item_no),
                                                            MAX(share_cd) 
                                                     FROM GIUW_WITEMDS_DTL d
                                                     WHERE d.dist_no   = p_dist_no
                                                     AND d.dist_seq_no = b.dist_seq_no)
                     AND c.dist_no     = p_dist_no; 
             END IF;             
         END LOOP;              
     END LOOP;
     
     FOR a IN (
        SELECT dist_no,      dist_seq_no, 
               SUM(tsi_amt)  tsi_amt,
               SUM(prem_amt) prem_amt,   
               SUM(ann_tsi_amt) ann_tsi_amt 
        FROM GIUW_WITEMPERILDS
        WHERE dist_no = p_dist_no
        GROUP BY dist_no, dist_seq_no)
     LOOP
         FOR b in (
             SELECT dist_no,       dist_seq_no, 
                    SUM(dist_tsi)  tsi_amt,
                    SUM(dist_prem) prem_amt,   
                    SUM(ann_dist_tsi) ann_tsi_amt 
             FROM GIUW_WITEMPERILDS_DTL
              WHERE dist_no     = p_dist_no
                AND dist_seq_no = a.dist_seq_no                
              GROUP BY dist_no, dist_seq_no)
         LOOP
             IF a.tsi_amt       <> b.tsi_amt OR
                  a.prem_amt    <> b.prem_amt OR  
                  a.ann_tsi_amt <> b.ann_tsi_amt THEN 
                  --msg_alert('itemperil','I',FALSE);
                  UPDATE GIUW_WITEMPERILDS_DTL c
                     SET c.dist_tsi      = c.dist_tsi + (a.tsi_amt - b.tsi_amt),
                         c.dist_prem     = c.dist_prem + (a.prem_amt - b.prem_amt),
                         c.ann_dist_tsi  = c.ann_dist_tsi + (a.ann_tsi_amt - b.ann_tsi_amt)
                   WHERE c.dist_seq_no = a.dist_seq_no
                     AND (c.item_no, c.peril_cd, c.share_cd) = (SELECT MAX(item_no),
                                                                       MAX(peril_cd),
                                                                       MAX(share_cd)  
                                                                FROM GIUW_WITEMPERILDS_DTL d
                                                                WHERE d.dist_no = p_dist_no
                                                                AND d.dist_seq_no = b.dist_seq_no)
                     AND c.dist_no     = p_dist_no; 
             END IF;             
         END LOOP;              
     END LOOP;
     
     FOR a IN (
        SELECT dist_no,      dist_seq_no, 
               SUM(tsi_amt)  tsi_amt,
               SUM(prem_amt) prem_amt,   
               SUM(ann_tsi_amt) ann_tsi_amt 
        FROM GIUW_WPOLICYDS
          WHERE dist_no = p_dist_no
          GROUP BY dist_no, dist_seq_no)
     LOOP
         FOR b in (
             SELECT dist_no,       dist_seq_no, 
                    SUM(dist_tsi)  tsi_amt,
                    SUM(dist_prem) prem_amt,   
                    SUM(ann_dist_tsi) ann_tsi_amt 
             FROM GIUW_WPOLICYDS_DTL
              WHERE dist_no     = p_dist_no
                AND dist_seq_no = a.dist_seq_no                
              GROUP BY dist_no, dist_seq_no)
         LOOP
             IF a.tsi_amt     <> b.tsi_amt OR
                a.prem_amt    <> b.prem_amt OR  
                a.ann_tsi_amt <> b.ann_tsi_amt THEN 
                  --msg_alert('policy','I',FALSE);
                  UPDATE GIUW_WPOLICYDS_DTL c
                     SET c.dist_tsi      = c.dist_tsi + (a.tsi_amt - b.tsi_amt),
                         c.dist_prem     = c.dist_prem + (a.prem_amt - b.prem_amt),
                         c.ann_dist_tsi  = c.ann_dist_tsi + (a.ann_tsi_amt - b.ann_tsi_amt)
                   WHERE c.dist_seq_no = a.dist_seq_no
                     AND (c.share_cd)  = (SELECT MAX(share_cd)  
                                          FROM giuw_wpolicyds_dtl d
                                          WHERE d.dist_no   = p_dist_no
                                          AND d.dist_seq_no = b.dist_seq_no)
                     AND c.dist_no     = p_dist_no; 
             END IF;             
         END LOOP;              
     END LOOP;
                   
   END;
   
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Adjust amts in perilds dtl tables to equalize the amounts
**                 attained by the policyds dtl table.
**                 Tables involved:  GIUW_WPOLICYDS_DTL, GIUW_WPERILDS_DTL, GIUW_WITEMPERILDS_DTL
*/

 PROCEDURE ADJUST_DTL_AMTS_GIUWS016 (p_dist_no   IN   GIUW_POL_DIST.dist_no%TYPE) IS
  v_rowid                    VARCHAR2(50):= NULL;
  v_prl_eql                  VARCHAR2(1) := 'Y';
  v_itmprl_eql               VARCHAR2(1) := 'Y';
  v_correct_dist_tsi         GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
  v_correct_dist_prem        GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
  v_correct_ann_dist_tsi     GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;

 BEGIN
  /* Get sum of tsi, prem and ann_tsi from giuw_wpolicyds_dtl
  ** group by share_cd */
  FOR a IN (SELECT ROUND(SUM(dist_tsi),2) pol_tsi, ROUND(SUM(dist_prem),2) pol_prem, 
                   ROUND(SUM(ann_dist_tsi),2) pol_ann_tsi, dist_seq_no, share_cd
              FROM GIUW_WPOLICYDS_DTL
             WHERE dist_no = p_dist_no
             GROUP BY dist_seq_no, share_cd)
  LOOP
    /* First part : compare giuw_wpolicyds_dtl with giuw_wperilds_dtl*/               
      /* Get sum of tsi, prem and ann_tsi from giuw_wperilds_dtl */
    
    FOR b IN (SELECT ROUND(SUM(DECODE(gper.peril_type,'B',gwd.dist_tsi,0)),2) prl_tsi, 
                     ROUND(SUM(gwd.dist_prem),2) prl_prem, 
                     ROUND(SUM(DECODE(gper.peril_type,'B',gwd.ann_dist_tsi,0)),2) prl_ann_tsi
                FROM GIUW_WPERILDS_DTL gwd
                   , GIIS_PERIL gper
               WHERE gwd.peril_cd = gper.peril_cd
                 AND gwd.line_cd  = gper.line_cd
                 AND gwd.dist_no  = p_dist_no
                 AND gwd.dist_seq_no = a.dist_seq_no
                 AND gwd.share_cd = a.share_cd)
    LOOP
        /* initialize variables*/
          v_prl_eql := 'Y';
          v_rowid   := NULL;
          v_correct_dist_tsi     := 0;
          v_correct_dist_prem    := 0;
          v_correct_ann_dist_tsi := 0;
      
      /* Get rowid of last peril encoded in giuw_wperilds_dtl*/
        FOR r IN (SELECT rowid
                  FROM GIUW_WPERILDS_DTL
                  WHERE dist_no = p_dist_no
                  AND dist_seq_no = a.dist_seq_no
                  AND share_cd = a.share_cd) 
        LOOP
        v_rowid := r.rowid;
        END LOOP;
        
        /* Compare sums taken from giuw_wpolicyds_dtl and giuw_wperilds_dtl 
        ** if sums are not equal, get correct amt for giuw_wperilds_dtl*/
        IF b.prl_tsi <> a.pol_tsi THEN
             v_prl_eql := 'N';
             v_correct_dist_tsi := a.pol_tsi - b.prl_tsi;
        END IF;     
        IF b.prl_prem <> a.pol_prem THEN
             v_prl_eql := 'N';
             v_correct_dist_prem := a.pol_prem - b.prl_prem;
        END IF;     
        IF b.prl_ann_tsi <> a.pol_ann_tsi THEN
             v_prl_eql := 'N';
             v_correct_ann_dist_tsi := a.pol_ann_tsi - b.prl_ann_tsi;
        END IF;
             
        /* update giuw_wperilds_dtl if at least one of the compared amts is not equal
        ** adjust only the last peril entered*/
        IF v_prl_eql = 'N' THEN
             UPDATE GIUW_WPERILDS_DTL
                SET dist_tsi     = v_correct_dist_tsi + dist_tsi
                  , dist_prem    = v_correct_dist_prem + dist_prem
                  , ann_dist_tsi = v_correct_ann_dist_tsi + ann_dist_tsi
              WHERE rowid        = v_rowid;
        END IF;
    END LOOP; --b loop
    /* Second part : compare giuw_wpolicyds_dtl with giuw_itemperilds_dtl*/
    FOR c IN (SELECT ROUND(SUM(DECODE(gper.peril_type,'B',gwd.dist_tsi,0)),2) itmprl_tsi, 
                     ROUND(SUM(gwd.dist_prem),2) itmprl_prem, 
                     ROUND(SUM(DECODE(gper.peril_type,'B',gwd.ann_dist_tsi,0)),2) itmprl_ann_tsi
                FROM GIUW_WITEMPERILDS_DTL gwd
                   , GIIS_PERIL gper
               WHERE gwd.peril_cd = gper.peril_cd
                 AND gwd.line_cd  = gper.line_cd
                 AND gwd.dist_no = p_dist_no
                 AND gwd.dist_seq_no = a.dist_seq_no
                 AND gwd.share_cd = a.share_cd)
    LOOP
          v_itmprl_eql := 'Y';
          v_rowid      := NULL;
          v_correct_dist_tsi     := 0;
          v_correct_dist_prem    := 0;
          v_correct_ann_dist_tsi := 0;
      
      /* Get rowid of last peril of the last item encoded in giuw_witemperilds_dtl*/
        FOR r IN (SELECT rowid
                  FROM GIUW_WITEMPERILDS_DTL
                  WHERE dist_no = p_dist_no
                  AND dist_seq_no = a.dist_seq_no
                  AND share_cd = a.share_cd) 
        LOOP
        v_rowid := r.rowid;
        END LOOP;
        
        /* Compare sums taken from giuw_wpolicyds_dtl and giuw_witemperilds_dtl 
        ** if sums are not equal, get correct amt for giuw_witemperilds_dtl*/
        IF c.itmprl_tsi <> a.pol_tsi THEN
             v_itmprl_eql := 'N';
             v_correct_dist_tsi := a.pol_tsi - c.itmprl_tsi;
        END IF;     
        IF c.itmprl_prem <> a.pol_prem THEN
             v_itmprl_eql := 'N';
             v_correct_dist_prem := a.pol_prem - c.itmprl_prem;
        END IF;     
        IF c.itmprl_ann_tsi <> a.pol_ann_tsi THEN
             v_itmprl_eql := 'N';
             v_correct_ann_dist_tsi := a.pol_ann_tsi - c.itmprl_ann_tsi;
        END IF;     
        /* update giuw_witemperilds_dtl if at least one of the compared amts is not equal
        ** adjust only the last peril entered*/
        IF v_itmprl_eql = 'N' THEN
             UPDATE GIUW_WITEMPERILDS_DTL
                SET dist_tsi     = v_correct_dist_tsi + dist_tsi
                  , dist_prem    = v_correct_dist_prem + dist_prem 
                  , ann_dist_tsi = v_correct_ann_dist_tsi + ann_dist_tsi
              WHERE rowid        = v_rowid;
        END IF;
    END LOOP; --c loop
  END LOOP; --a loop

 END;
 
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Adjust computational floats to equalize the amounts
**                 attained by the master tables with that of its detail tables.
**                 Tables involved:  GIUW_WITEMDS - GIUW_WITEMDS_DTL
*/

PROCEDURE ADJUST_ITM_LVL_AMTS_GIUWS016 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE) IS

  v_exist                   VARCHAR2(1) := 'N';
  v_count                   NUMBER;
  v_line_cd                 GIPI_PARLIST.line_cd%TYPE;
  v_tsi_amt                 GIUW_WPOLICYDS.tsi_amt%TYPE;
  v_prem_amt                GIUW_WPOLICYDS.prem_amt%TYPE;
  v_ann_tsi_amt             GIUW_WPOLICYDS.ann_tsi_amt%TYPE;
  v_dist_spct               GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
  v_dist_spct1              GIUW_WPOLICYDS_DTL.dist_spct1%TYPE;
  v_dist_tsi                GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
  v_dist_prem               GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
  v_ann_dist_tsi            GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
  v_ann_dist_spct           GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;
  v_sum_dist_tsi            GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
  v_sum_dist_prem           GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
  v_sum_dist_spct           GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
  v_sum_dist_spct1          GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
  v_sum_ann_dist_tsi        GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
  v_sum_ann_dist_spct       GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;
  v_correct_dist_tsi        GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
  v_correct_dist_prem       GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
  v_correct_dist_spct       GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
  v_correct_dist_spct1      GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
  v_correct_ann_dist_tsi    GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
  v_correct_ann_dist_spct   GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;

BEGIN

  /* Scan each combination of the DIST_SEQ_NO and ITEM_NO for computational floats. */
  FOR c1 IN (SELECT dist_no                                   ,
                    dist_seq_no                               ,
                    item_no                                   ,
                    ROUND(NVL(tsi_amt    , 0), 2) tsi_amt     ,
                    ROUND(NVL(prem_amt   , 0), 2) prem_amt    ,
                    ROUND(NVL(ann_tsi_amt, 0), 2) ann_tsi_amt
               FROM GIUW_WITEMDS
              WHERE dist_no = p_dist_no)
  LOOP
    BEGIN

      /* Get the LINE_CD for the particular DIST_SEQ_NO
      ** for use in retrieving the correct data from
      ** GIUW_WITEMDS_DTL. */
      FOR c2 IN (SELECT line_cd
                   FROM GIUW_WPERILDS
                  WHERE dist_seq_no = c1.dist_seq_no
                    AND dist_no     = c1.dist_no)
      LOOP
        v_line_cd := c2.line_cd;
        EXIT;
      END LOOP;

      /* **************************** Section A **********************************
      ** Compare the amounts retrieved from the master table with the sum of its
      ** counterparts from the detail table.
      ************************************************************************* */

      v_tsi_amt     := c1.tsi_amt;
      v_prem_amt    := c1.prem_amt;
      v_ann_tsi_amt := c1.ann_tsi_amt;

      v_exist := 'N';
      FOR c10 IN (SELECT ROUND(SUM(NVL(dist_tsi, 0)), 2)     dist_tsi     , 
                         ROUND(SUM(NVL(dist_prem, 0)), 2)    dist_prem    ,
                         ROUND(SUM(NVL(dist_spct, 0)), 14)   dist_spct    ,
                         ROUND(SUM(NVL(dist_spct1, 0)), 14)  dist_spct1   ,
                         ROUND(SUM(NVL(ann_dist_tsi, 0)), 2) ann_dist_tsi
                    FROM GIUW_WITEMDS_DTL
                   WHERE line_cd     = v_line_cd
                     AND item_no     = c1.item_no
                     AND dist_seq_no = c1.dist_seq_no
                     AND dist_no     = c1.dist_no)
      LOOP 
        v_exist        := 'Y';
        v_dist_tsi     := c10.dist_tsi;
        v_dist_prem    := c10.dist_prem;
        v_dist_spct    := c10.dist_spct;
        v_dist_spct1   := c10.dist_spct1;
        v_ann_dist_tsi := c10.ann_dist_tsi;
        EXIT;
      END LOOP;
      IF v_exist = 'N' THEN
         EXIT;
      END IF;

      /******************************** End of Section A ******************************/

      /* If the amounts retrieved from the master table
      ** are not equal to the amounts retrieved from the
      ** the detail table then the procedure below shall
      ** be executed. */
      IF (100           != v_dist_spct   ) OR
         (100           != v_dist_spct1  ) OR
         (v_tsi_amt     != v_dist_tsi    ) OR 
         (v_prem_amt    != v_dist_prem   ) OR
         (v_ann_tsi_amt != v_ann_dist_tsi) THEN
         BEGIN
           v_exist := 'N';

           /*************************** Section B *******************************
           ** Adjust the value of the fields belonging to the NET RETENTION share
           ** (SHARE_CD = '1'). If by chance a NET RETENTION share does not exist,
           ** then the NO_DATA_FOUND exception (Section F) shall handle the next
           ** few steps.
           *********************************************************************/
           
           /* Get the ROWID of the NET RETENTION share
           ** in preparation for update. */
           FOR c10 IN (SELECT ROWID
                         FROM GIUW_WITEMDS_DTL
                        WHERE share_cd    = '1'
                          AND line_cd     = v_line_cd
                          AND item_no     = c1.item_no
                          AND dist_seq_no = c1.dist_seq_no
                          AND dist_no     = c1.dist_no)
           LOOP

             /* Get the sum of each field for all the shares excluding the NET
             ** RETENTION share.  The result will serve as the SUBTRAHEND in 
             ** calculating for the values to be attained by the fields belonging
             ** to NET RETENTION. */
             FOR c20 IN (SELECT ROUND(SUM(dist_tsi), 2)              dist_tsi     , 
                                ROUND(SUM(dist_prem), 2)             dist_prem    , 
                                ROUND(SUM(dist_spct), 14)             dist_spct    , 
                                ROUND(SUM(dist_spct1), 14)            dist_spct1   , 
                                ROUND(SUM(NVL(ann_dist_tsi, 0)), 2)  ann_dist_tsi ,
                                ROUND(SUM(NVL(ann_dist_spct, 0)), 14) ann_dist_spct
                           FROM GIUW_WITEMDS_DTL
                          WHERE share_cd   != '1'
                            AND line_cd     = v_line_cd
                            AND item_no     = c1.item_no
                            AND dist_seq_no = c1.dist_seq_no
                            AND dist_no     = c1.dist_no)
             LOOP
               v_exist             := 'Y';
               v_sum_dist_tsi      := c20.dist_tsi;
               v_sum_dist_prem     := c20.dist_prem;
               v_sum_dist_spct     := c20.dist_spct;
               v_sum_dist_spct1    := c20.dist_spct1;
               v_sum_ann_dist_tsi  := c20.ann_dist_tsi;
               v_sum_ann_dist_spct := c20.ann_dist_spct;
               EXIT;
             END LOOP;
             IF v_exist = 'N' THEN
                EXIT;
             END IF;

             /* Calculate for the values to be attained by the fields
             ** belonging to the NET RETENTION share by subtracting
             ** the values attained from the master table with the
             ** values attained above. */
             v_correct_dist_tsi      := ABS(v_tsi_amt)  - ABS(v_sum_dist_tsi);
             v_correct_dist_prem     := ABS(v_prem_amt) - ABS(v_sum_dist_prem);
             v_correct_dist_spct     := 100 - v_sum_dist_spct;
             v_correct_dist_spct1    := 100 - v_sum_dist_spct1;
             v_correct_ann_dist_tsi  := ABS(v_ann_tsi_amt) - ABS(v_sum_ann_dist_tsi);
             v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

             IF SIGN(v_tsi_amt) = -1 THEN
                v_correct_dist_tsi := v_correct_dist_tsi * -1;
             END IF;
             IF SIGN(v_prem_amt) = -1 THEN
                v_correct_dist_prem := v_correct_dist_prem * -1;
             END IF;
             IF SIGN(v_ann_tsi_amt) = -1 THEN
                v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
             END IF;
             /* Update the values of the fields belonging to the NET
             ** RETENTION share to equalize the amounts attained from
             ** the detail table with the amounts attained from the
             ** master table. */
             UPDATE GIUW_WITEMDS_DTL 
                SET dist_tsi      = v_correct_dist_tsi,
                    dist_prem     = v_correct_dist_prem,
                    dist_spct     = v_correct_dist_spct,
                    dist_spct1    = v_correct_dist_spct1,
                    ann_dist_tsi  = v_correct_ann_dist_tsi,
                    ann_dist_spct = v_correct_ann_dist_spct
              WHERE ROWID         = c10.rowid;
             EXIT;
           END LOOP;
           IF v_exist = 'N' THEN
              RAISE NO_DATA_FOUND;
           END IF;

           /*************************** End of Section B ***************************/

         EXCEPTION
           WHEN NO_DATA_FOUND THEN  
             BEGIN

               /****************************** Section C ******************************
               ** Adjust the value of the fields belonging to the share of the FIRST
               ** RETRIEVED ROW.
               ***********************************************************************/

               /* Get the ROWID of the first retrieved
               ** row in preparation for update. */ 
               FOR c10 IN (SELECT ROWID 
                             FROM GIUW_WITEMDS_DTL
                            WHERE line_cd     = v_line_cd
                              AND item_no     = c1.item_no
                              AND dist_seq_no = c1.dist_seq_no
                              AND dist_no     = c1.dist_no)
               LOOP

                 /* Get the sum of each field for all the shares excluding the share
                 ** of the FIRST RETRIEVED ROW.  The result will serve as the SUBTRAHEND
                 ** in calculating for the values to be attained by the fields belonging
                 ** to the FIRST ROW. */
                 FOR c20 IN (SELECT ROUND(SUM(dist_tsi), 2)              dist_tsi      ,
                                    ROUND(SUM(dist_prem), 2)             dist_prem     , 
                                    ROUND(SUM(dist_spct), 14)             dist_spct     ,
                                    ROUND(SUM(dist_spct1), 14)            dist_spct1    ,
                                    ROUND(SUM(NVL(ann_dist_tsi, 0)), 2)  ann_dist_tsi  ,
                                    ROUND(SUM(NVL(ann_dist_spct, 0)), 14) ann_dist_spct
                               FROM GIUW_WITEMDS_DTL
                              WHERE ROWID      != c10.rowid
                                AND line_cd     = v_line_cd
                                AND item_no     = c1.item_no
                                AND dist_seq_no = c1.dist_seq_no
                                AND dist_no     = c1.dist_no)
                 LOOP
                   v_sum_dist_tsi      := c20.dist_tsi;
                   v_sum_dist_prem     := c20.dist_prem;
                   v_sum_dist_spct     := c20.dist_spct;
                   v_sum_dist_spct1    := c20.dist_spct1;
                   v_sum_ann_dist_tsi  := c20.ann_dist_tsi;
                   v_sum_ann_dist_spct := c20.ann_dist_spct;
                   EXIT;
                 END LOOP;

                 /* Calculate for the values to be attained by the fields
                 ** belonging to the share of the FIRST ROW by subtracting
                 ** the values attained from the master table with the
                 ** values attained above. */
                 v_correct_dist_tsi      := ABS(v_tsi_amt) - ABS(v_sum_dist_tsi);
                 v_correct_dist_prem     := ABS(v_prem_amt) - ABS(v_sum_dist_prem);
                 v_correct_dist_spct     := 100 - v_sum_dist_spct;
                 v_correct_dist_spct1    := 100 - v_sum_dist_spct1;
                 v_correct_ann_dist_tsi  := ABS(v_ann_tsi_amt) - ABS(v_sum_ann_dist_tsi);
                 v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;
                 IF SIGN(v_tsi_amt) = -1 THEN
                    v_correct_dist_tsi := v_correct_dist_tsi * -1;
                 END IF;
                 IF SIGN(v_prem_amt) = -1 THEN
                    v_correct_dist_prem := v_correct_dist_prem * -1;
                 END IF;
                 IF SIGN(v_ann_tsi_amt) = -1 THEN
                    v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
                 END IF;

                 /* Update the values of the fields belonging to the share
                 ** of the FIRST ROW to equalize the amounts attained from
                 ** the detail table with the amounts attained from the
                 ** master table. */
                 UPDATE GIUW_WITEMDS_DTL 
                    SET dist_tsi      = v_correct_dist_tsi,
                        dist_prem     = v_correct_dist_prem,
                        dist_spct     = v_correct_dist_spct,
                        dist_spct1    = v_correct_dist_spct1,
                        ann_dist_tsi  = v_correct_ann_dist_tsi,
                        ann_dist_spct = v_correct_ann_dist_spct
                  WHERE ROWID         = c10.rowid;
                 EXIT;
               END LOOP;
             END;

             /**************************** End of Section C *************************/

         END;
      END IF;
    END;
  END LOOP;
END;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Adjust computational floats to equalize the amounts
**                    attained by the master tables with that of its detail tables.
**                    Tables involved:  GIUW_WITEMPERILDS - GIUW_WITEMPERILDS_DTL
*/

PROCEDURE ADJ_ITM_PERL_LVL_AMTS_GIUWS016 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE) IS

  v_exist                   VARCHAR2(1) := 'N';
  v_count                   NUMBER;
  v_tsi_amt                 GIUW_WPOLICYDS.tsi_amt%TYPE;
  v_prem_amt                GIUW_WPOLICYDS.prem_amt%TYPE;
  v_ann_tsi_amt             GIUW_WPOLICYDS.ann_tsi_amt%TYPE;
  v_dist_spct               GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
  v_dist_spct1              GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
  v_dist_tsi                GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
  v_dist_prem               GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
  v_ann_dist_tsi            GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
  v_ann_dist_spct           GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;
  v_sum_dist_tsi            GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
  v_sum_dist_prem           GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
  v_sum_dist_spct           GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
  v_sum_dist_spct1          GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
  v_sum_ann_dist_tsi        GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
  v_sum_ann_dist_spct       GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;
  v_correct_dist_tsi        GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
  v_correct_dist_prem       GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
  v_correct_dist_spct       GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
  v_correct_dist_spct1      GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
  v_correct_ann_dist_tsi    GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
  v_correct_ann_dist_spct   GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;

BEGIN

  /* Scan each combination of the DIST_SEQ_NO, ITEM_NO, LINE_CD and
  ** PERIL_CD for computational floats. */
  FOR c1 IN (SELECT dist_no                                   ,
                    dist_seq_no                               ,
                    item_no                                   ,
                    line_cd                                   ,
                    peril_cd                                  ,
                    ROUND(NVL(tsi_amt    , 0), 2) tsi_amt     ,
                    ROUND(NVL(prem_amt   , 0), 2) prem_amt    ,
                    ROUND(NVL(ann_tsi_amt, 0), 2) ann_tsi_amt
               FROM GIUW_WITEMPERILDS
              WHERE dist_no = p_dist_no)
  LOOP
    BEGIN

      /* **************************** Section A **********************************
      ** Compare the amounts retrieved from the master table with the sum of its
      ** counterparts from the detail table.
      ************************************************************************* */

      v_tsi_amt     := c1.tsi_amt;
      v_prem_amt    := c1.prem_amt;
      v_ann_tsi_amt := c1.ann_tsi_amt;

      v_exist := 'N';
      FOR c10 IN (SELECT ROUND(SUM(NVL(dist_tsi, 0)), 2)     dist_tsi     , 
                         ROUND(SUM(NVL(dist_prem, 0)), 2)    dist_prem    ,
                         ROUND(SUM(NVL(dist_spct, 0)), 14)    dist_spct    ,
                         ROUND(SUM(NVL(dist_spct1, 0)), 14)   dist_spct1   ,
                         ROUND(SUM(NVL(ann_dist_tsi, 0)), 2) ann_dist_tsi
                    FROM GIUW_WITEMPERILDS_DTL
                   WHERE peril_cd    = c1.peril_cd
                     AND line_cd     = c1.line_cd
                     AND item_no     = c1.item_no
                     AND dist_seq_no = c1.dist_seq_no
                     AND dist_no     = c1.dist_no)
      LOOP 
        v_exist        := 'Y';
        v_dist_tsi     := c10.dist_tsi;
        v_dist_prem    := c10.dist_prem;
        v_dist_spct    := c10.dist_spct;
        v_dist_spct1   := c10.dist_spct1;
        v_ann_dist_tsi := c10.ann_dist_tsi;
        EXIT;
      END LOOP;
      IF v_exist = 'N' THEN
         EXIT;
      END IF;

      /******************************** End of Section A ******************************/

      /* If the amounts retrieved from the master table
      ** are not equal to the amounts retrieved from the
      ** the detail table then the procedure below shall
      ** be executed. */
      IF (100           != v_dist_spct   ) OR
         (100           != v_dist_spct1  ) OR
         (v_tsi_amt     != v_dist_tsi    ) OR 
         (v_prem_amt    != v_dist_prem   ) OR
         (v_ann_tsi_amt != v_ann_dist_tsi) THEN
         BEGIN
           v_exist := 'N';

           /*************************** Section B *******************************
           ** Adjust the value of the fields belonging to the NET RETENTION share
           ** (SHARE_CD = '1'). If by chance a NET RETENTION share does not exist,
           ** then the NO_DATA_FOUND exception (Section F) shall handle the next
           ** few steps.
           *********************************************************************/
           
           /* Get the ROWID of the NET RETENTION share
           ** in preparation for update. */
           FOR c10 IN (SELECT ROWID
                         FROM GIUW_WITEMPERILDS_DTL
                        WHERE share_cd    = '1'
                          AND peril_cd    = c1.peril_cd
                          AND line_cd     = c1.line_cd
                          AND item_no     = c1.item_no
                          AND dist_seq_no = c1.dist_seq_no
                          AND dist_no     = c1.dist_no)
           LOOP

             /* Get the sum of each field for all the shares excluding the NET
             ** RETENTION share.  The result will serve as the SUBTRAHEND in 
             ** calculating for the values to be attained by the fields belonging
             ** to NET RETENTION. */
             FOR c20 IN (SELECT ROUND(SUM(dist_tsi), 2)              dist_tsi     , 
                                ROUND(SUM(dist_prem), 2)             dist_prem    , 
                                ROUND(SUM(dist_spct), 14)            dist_spct    , 
                                ROUND(SUM(dist_spct1), 14)           dist_spct1   , 
                                ROUND(SUM(NVL(ann_dist_tsi, 0)), 2)  ann_dist_tsi ,
                                ROUND(SUM(NVL(ann_dist_spct, 0)), 14) ann_dist_spct
                           FROM GIUW_WITEMPERILDS_DTL
                          WHERE share_cd   != '1'
                            AND peril_cd    = c1.peril_cd
                            AND line_cd     = c1.line_cd
                            AND item_no     = c1.item_no
                            AND dist_seq_no = c1.dist_seq_no
                            AND dist_no     = c1.dist_no)
             LOOP
               v_exist             := 'Y';
               v_sum_dist_tsi      := c20.dist_tsi;
               v_sum_dist_prem     := c20.dist_prem;
               v_sum_dist_spct     := c20.dist_spct;
               v_sum_dist_spct1    := c20.dist_spct1;
               v_sum_ann_dist_tsi  := c20.ann_dist_tsi;
               v_sum_ann_dist_spct := c20.ann_dist_spct;
               EXIT;
             END LOOP;
             IF v_exist = 'N' THEN
                EXIT;
             END IF;

             /* Calculate for the values to be attained by the fields
             ** belonging to the NET RETENTION share by subtracting
             ** the values attained from the master table with the
             ** values attained above. */
             v_correct_dist_tsi      := ABS(v_tsi_amt)  - ABS(v_sum_dist_tsi);
             v_correct_dist_prem     := ABS(v_prem_amt) - ABS(v_sum_dist_prem);
             v_correct_dist_spct     := 100 - v_sum_dist_spct;
             v_correct_dist_spct1    := 100 - v_sum_dist_spct1;
             v_correct_ann_dist_tsi  := ABS(v_ann_tsi_amt) - ABS(v_sum_ann_dist_tsi);
             v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

             IF SIGN(v_tsi_amt) = -1 THEN
                v_correct_dist_tsi := v_correct_dist_tsi * -1;
             END IF;
             IF SIGN(v_prem_amt) = -1 THEN
                v_correct_dist_prem := v_correct_dist_prem * -1;
             END IF;
             IF SIGN(v_ann_tsi_amt) = -1 THEN
                v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
             END IF;

             /* Update the values of the fields belonging to the NET
             ** RETENTION share to equalize the amounts attained from
             ** the detail table with the amounts attained from the
             ** master table. */
             UPDATE GIUW_WITEMPERILDS_DTL 
                SET dist_tsi      = v_correct_dist_tsi,
                    dist_prem     = v_correct_dist_prem,
                    dist_spct     = v_correct_dist_spct,
                    dist_spct1    = v_correct_dist_spct1,
                    ann_dist_tsi  = v_correct_ann_dist_tsi,
                    ann_dist_spct = v_correct_ann_dist_spct
              WHERE ROWID         = c10.rowid;
             EXIT;
           END LOOP;
           IF v_exist = 'N' THEN
              RAISE NO_DATA_FOUND;
           END IF;

           /*************************** End of Section B ***************************/

         EXCEPTION
           WHEN NO_DATA_FOUND THEN  
             BEGIN

               /****************************** Section C ******************************
               ** Adjust the value of the fields belonging to the share of the FIRST
               ** RETRIEVED ROW.
               ***********************************************************************/

               /* Get the ROWID of the first retrieved
               ** row in preparation for update. */ 
               FOR c10 IN (SELECT ROWID 
                             FROM GIUW_WITEMPERILDS_DTL
                            WHERE ROWNUM      = 1
                              AND peril_cd    = c1.peril_cd
                              AND line_cd     = c1.line_cd
                              AND item_no     = c1.item_no
                              AND dist_seq_no = c1.dist_seq_no
                              AND dist_no     = c1.dist_no)
               LOOP

                 /* Get the sum of each field for all the shares excluding the share
                 ** of the FIRST RETRIEVED ROW.  The result will serve as the SUBTRAHEND
                 ** in calculating for the values to be attained by the fields belonging
                 ** to the FIRST ROW. */
                 FOR c20 IN (SELECT ROUND(SUM(dist_tsi), 2)              dist_tsi      ,
                                    ROUND(SUM(dist_prem), 2)             dist_prem     , 
                                    ROUND(SUM(dist_spct), 14)            dist_spct     ,
                                    ROUND(SUM(dist_spct1), 14)           dist_spct1    ,
                                    ROUND(SUM(NVL(ann_dist_tsi, 0)), 2)  ann_dist_tsi  ,
                                    ROUND(SUM(NVL(ann_dist_spct, 0)), 14) ann_dist_spct
                               FROM GIUW_WITEMPERILDS_DTL
                              WHERE ROWID      != c10.rowid
                                AND peril_cd    = c1.peril_cd
                                AND line_cd     = c1.line_cd
                                AND item_no     = c1.item_no
                                AND dist_seq_no = c1.dist_seq_no
                                AND dist_no     = c1.dist_no)
                 LOOP
                   v_sum_dist_tsi      := c20.dist_tsi;
                   v_sum_dist_prem     := c20.dist_prem;
                   v_sum_dist_spct     := c20.dist_spct;
                   v_sum_dist_spct1    := c20.dist_spct1;
                   v_sum_ann_dist_tsi  := c20.ann_dist_tsi;
                   v_sum_ann_dist_spct := c20.ann_dist_spct;
                   EXIT;
                 END LOOP;

                 /* Calculate for the values to be attained by the fields
                 ** belonging to the share of the FIRST ROW by subtracting
                 ** the values attained from the master table with the
                 ** values attained above. */
                 v_correct_dist_tsi      := ABS(v_tsi_amt) - ABS(v_sum_dist_tsi);
                 v_correct_dist_prem     := ABS(v_prem_amt) - ABS(v_sum_dist_prem);
                 v_correct_dist_spct     := 100 - v_sum_dist_spct;
                 v_correct_dist_spct1    := 100 - v_sum_dist_spct1;
                 v_correct_ann_dist_tsi  := ABS(v_ann_tsi_amt) - ABS(v_sum_ann_dist_tsi);
                 v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

                 IF SIGN(v_tsi_amt) = -1 THEN
                    v_correct_dist_tsi := v_correct_dist_tsi * -1;
                 END IF;
                 IF SIGN(v_prem_amt) = -1 THEN
                    v_correct_dist_prem := v_correct_dist_prem * -1;
                 END IF;
                 IF SIGN(v_ann_tsi_amt) = -1 THEN
                    v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
                 END IF;

                 /* Update the values of the fields belonging to the share
                 ** of the FIRST ROW to equalize the amounts attained from
                 ** the detail table with the amounts attained from the
                 ** master table. */
                 UPDATE GIUW_WITEMPERILDS_DTL 
                    SET dist_tsi      = v_correct_dist_tsi,
                        dist_prem     = v_correct_dist_prem,
                        dist_spct     = v_correct_dist_spct,
                        dist_spct1    = v_correct_dist_spct1,
                        ann_dist_tsi  = v_correct_ann_dist_tsi,
                        ann_dist_spct = v_correct_ann_dist_spct
                  WHERE ROWID         = c10.rowid;
                 EXIT;
               END LOOP;
             END;

             /**************************** End of Section C *************************/

         END;
      END IF;
    END;
  END LOOP;
END;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Adjust computational floats to equalize the amounts
**                 attained by the master tables with that of its detail tables.
**                 Tables involved:  GIUW_WPERILDS - GIUW_WPERILDS_DTL
*/

    PROCEDURE ADJUST_PERIL_LVL_AMTS_GIUWS016 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE) IS

      v_exist                   VARCHAR2(1) := 'N';
      v_count                   NUMBER;
      v_tsi_amt                 GIUW_WPOLICYDS.tsi_amt%TYPE;
      v_prem_amt                GIUW_WPOLICYDS.prem_amt%TYPE;
      v_ann_tsi_amt             GIUW_WPOLICYDS.ann_tsi_amt%TYPE;
      v_dist_spct               GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_dist_spct1              GIUW_WPOLICYDS_DTL.dist_spct1%TYPE;
      v_dist_tsi                GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_dist_prem               GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_ann_dist_tsi            GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
      v_ann_dist_spct           GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;
      v_sum_dist_tsi            GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_sum_dist_prem           GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_sum_dist_spct           GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_sum_dist_spct1          GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_sum_ann_dist_tsi        GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
      v_sum_ann_dist_spct       GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;
      v_correct_dist_tsi        GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_correct_dist_prem       GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_correct_dist_spct       GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_correct_dist_spct1      GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_correct_ann_dist_tsi    GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
      v_correct_ann_dist_spct   GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;

    BEGIN

      /* Scan each combination of the DIST_SEQ_NO, LINE_CD and
      ** PERIL_CD for computational floats. */
      FOR c1 IN (SELECT dist_no                                   ,
                        dist_seq_no                               ,
                        line_cd                                   ,
                        peril_cd                                  ,
                        ROUND(NVL(tsi_amt    , 0), 2) tsi_amt     ,
                        ROUND(NVL(prem_amt   , 0), 2) prem_amt    ,
                        ROUND(NVL(ann_tsi_amt, 0), 2) ann_tsi_amt
                   FROM GIUW_WPERILDS
                  WHERE dist_no = p_dist_no)
      LOOP
        BEGIN

          /* **************************** Section A **********************************
          ** Compare the amounts retrieved from the master table with the sum of its
          ** counterparts from the detail table.
          ************************************************************************* */

          v_tsi_amt     := c1.tsi_amt;
          v_prem_amt    := c1.prem_amt;
          v_ann_tsi_amt := c1.ann_tsi_amt;

          v_exist := 'N';
          FOR c10 IN (SELECT ROUND(SUM(NVL(dist_tsi, 0)), 2)     dist_tsi     , 
                             ROUND(SUM(NVL(dist_prem, 0)), 2)    dist_prem    ,
                             ROUND(SUM(NVL(dist_spct, 0)), 14)   dist_spct    ,
                             ROUND(SUM(NVL(dist_spct1, 0)), 14)  dist_spct1   ,
                             ROUND(SUM(NVL(ann_dist_tsi, 0)), 2) ann_dist_tsi
                        FROM GIUW_WPERILDS_DTL
                       WHERE peril_cd    = c1.peril_cd
                         AND line_cd     = c1.line_cd
                         AND dist_seq_no = c1.dist_seq_no
                         AND dist_no     = c1.dist_no)
          LOOP 
            v_exist        := 'Y';
            v_dist_tsi     := c10.dist_tsi;
            v_dist_prem    := c10.dist_prem;
            v_dist_spct    := c10.dist_spct;
            v_dist_spct1   := c10.dist_spct1;
            v_ann_dist_tsi := c10.ann_dist_tsi;
            EXIT;
          END LOOP;
          IF v_exist = 'N' THEN
             EXIT;
          END IF;

          /******************************** End of Section A ******************************/

          /* If the amounts retrieved from the master table
          ** are not equal to the amounts retrieved from the
          ** the detail table then the procedure below shall
          ** be executed. */
          IF (100           != v_dist_spct   ) OR
             (100           != v_dist_spct1  ) OR
             (v_tsi_amt     != v_dist_tsi    ) OR 
             (v_prem_amt    != v_dist_prem   ) OR
             (v_ann_tsi_amt != v_ann_dist_tsi) THEN
             BEGIN
               v_exist := 'N';

               /*************************** Section B *******************************
               ** Adjust the value of the fields belonging to the NET RETENTION share
               ** (SHARE_CD = '1'). If by chance a NET RETENTION share does not exist,
               ** then the NO_DATA_FOUND exception (Section F) shall handle the next
               ** few steps.
               *********************************************************************/
               
               /* Get the ROWID of the NET RETENTION share
               ** in preparation for update. */
               FOR c10 IN (SELECT ROWID
                             FROM GIUW_WPERILDS_DTL
                            WHERE share_cd    = '1'
                              AND peril_cd    = c1.peril_cd
                              AND line_cd     = c1.line_cd
                              AND dist_seq_no = c1.dist_seq_no
                              AND dist_no     = c1.dist_no)
               LOOP

                 /* Get the sum of each field for all the shares excluding the NET
                 ** RETENTION share.  The result will serve as the SUBTRAHEND in 
                 ** calculating for the values to be attained by the fields belonging
                 ** to NET RETENTION. */
                 FOR c20 IN (SELECT ROUND(SUM(dist_tsi), 2)              dist_tsi     , 
                                    ROUND(SUM(dist_prem), 2)             dist_prem    , 
                                    ROUND(SUM(dist_spct), 14)            dist_spct    , 
                                    ROUND(SUM(dist_spct1), 14)           dist_spct1   , 
                                    ROUND(SUM(NVL(ann_dist_tsi, 0)), 2)  ann_dist_tsi ,
                                    ROUND(SUM(NVL(ann_dist_spct, 0)), 14) ann_dist_spct
                               FROM GIUW_WPERILDS_DTL
                              WHERE share_cd   != '1'
                                AND peril_cd    = c1.peril_cd
                                AND line_cd     = c1.line_cd
                                AND dist_seq_no = c1.dist_seq_no
                                AND dist_no     = c1.dist_no)
                 LOOP
                   v_exist             := 'Y';
                   v_sum_dist_tsi      := c20.dist_tsi;
                   v_sum_dist_prem     := c20.dist_prem;
                   v_sum_dist_spct     := c20.dist_spct;
                   v_sum_dist_spct1    := c20.dist_spct1;
                   v_sum_ann_dist_tsi  := c20.ann_dist_tsi;
                   v_sum_ann_dist_spct := c20.ann_dist_spct;
                   EXIT;
                 END LOOP;
                 IF v_exist = 'N' THEN
                    EXIT;
                 END IF;

                 /* Calculate for the values to be attained by the fields
                 ** belonging to the NET RETENTION share by subtracting
                 ** the values attained from the master table with the
                 ** values attained above. */
                 v_correct_dist_tsi      := ABS(v_tsi_amt)  - ABS(v_sum_dist_tsi);
                 v_correct_dist_prem     := ABS(v_prem_amt) - ABS(v_sum_dist_prem);
                 v_correct_dist_spct     := 100 - v_sum_dist_spct;
                 v_correct_dist_spct1    := 100 - v_sum_dist_spct1;
                 v_correct_ann_dist_tsi  := ABS(v_ann_tsi_amt) - ABS(v_sum_ann_dist_tsi);
                 v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

                 IF SIGN(v_tsi_amt) = -1 THEN
                    v_correct_dist_tsi := v_correct_dist_tsi * -1;
                 END IF;
                 IF SIGN(v_prem_amt) = -1 THEN
                    v_correct_dist_prem := v_correct_dist_prem * -1;
                 END IF;
                 IF SIGN(v_ann_tsi_amt) = -1 THEN
                    v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
                 END IF;

                 /* Update the values of the fields belonging to the NET
                 ** RETENTION share to equalize the amounts attained from
                 ** the detail table with the amounts attained from the
                 ** master table. */
                 UPDATE GIUW_WPERILDS_DTL 
                    SET dist_tsi      = v_correct_dist_tsi,
                        dist_prem     = v_correct_dist_prem,
                        dist_spct     = v_correct_dist_spct,
                        dist_spct1    = v_correct_dist_spct1,
                        ann_dist_tsi  = v_correct_ann_dist_tsi,
                        ann_dist_spct = v_correct_ann_dist_spct
                  WHERE ROWID         = c10.rowid;
                 EXIT;
               END LOOP;
               IF v_exist = 'N' THEN
                  RAISE NO_DATA_FOUND;
               END IF;

               /*************************** End of Section B ***************************/

             EXCEPTION
               WHEN NO_DATA_FOUND THEN  
                 BEGIN

                   /****************************** Section C ******************************
                   ** Adjust the value of the fields belonging to the share of the FIRST
                   ** RETRIEVED ROW.
                   ***********************************************************************/

                   /* Get the ROWID of the first retrieved
                   ** row in preparation for update. */ 
                   FOR c10 IN (SELECT ROWID 
                                 FROM GIUW_WPERILDS_DTL
                                WHERE ROWNUM      = 1
                                  AND peril_cd    = c1.peril_cd
                                  AND line_cd     = c1.line_cd
                                  AND dist_seq_no = c1.dist_seq_no
                                  AND dist_no     = c1.dist_no)
                   LOOP

                     /* Get the sum of each field for all the shares excluding the share
                     ** of the FIRST RETRIEVED ROW.  The result will serve as the SUBTRAHEND
                     ** in calculating for the values to be attained by the fields belonging
                     ** to the FIRST ROW. */
                     FOR c20 IN (SELECT ROUND(SUM(dist_tsi), 2)              dist_tsi      ,
                                        ROUND(SUM(dist_prem), 2)             dist_prem     , 
                                        ROUND(SUM(dist_spct), 14)            dist_spct     ,
                                        ROUND(SUM(dist_spct1), 14)           dist_spct1    ,
                                        ROUND(SUM(NVL(ann_dist_tsi, 0)), 2)  ann_dist_tsi  ,
                                        ROUND(SUM(NVL(ann_dist_spct, 0)), 14) ann_dist_spct
                                   FROM GIUW_WPERILDS_DTL
                                  WHERE ROWID      != c10.rowid
                                    AND peril_cd    = c1.peril_cd
                                    AND line_cd     = c1.line_cd
                                    AND dist_seq_no = c1.dist_seq_no
                                    AND dist_no     = c1.dist_no)
                     LOOP
                       v_sum_dist_tsi      := c20.dist_tsi;
                       v_sum_dist_prem     := c20.dist_prem;
                       v_sum_dist_spct     := c20.dist_spct;
                       v_sum_dist_spct1    := c20.dist_spct1;
                       v_sum_ann_dist_tsi  := c20.ann_dist_tsi;
                       v_sum_ann_dist_spct := c20.ann_dist_spct;
                       EXIT;
                     END LOOP;

                     /* Calculate for the values to be attained by the fields
                     ** belonging to the share of the FIRST ROW by subtracting
                     ** the values attained from the master table with the
                     ** values attained above. */
                     v_correct_dist_tsi      := ABS(v_tsi_amt) - ABS(v_sum_dist_tsi);
                     v_correct_dist_prem     := ABS(v_prem_amt) - ABS(v_sum_dist_prem);
                     v_correct_dist_spct     := 100 - v_sum_dist_spct;
                     v_correct_dist_spct1    := 100 - v_sum_dist_spct1;
                     v_correct_ann_dist_tsi  := ABS(v_ann_tsi_amt) - ABS(v_sum_ann_dist_tsi);
                     v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

                     IF SIGN(v_tsi_amt) = -1 THEN
                        v_correct_dist_tsi := v_correct_dist_tsi * -1;
                     END IF;
                     IF SIGN(v_prem_amt) = -1 THEN
                        v_correct_dist_prem := v_correct_dist_prem * -1;
                     END IF;
                     IF SIGN(v_ann_tsi_amt) = -1 THEN
                        v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
                     END IF;

                     /* Update the values of the fields belonging to the share
                     ** of the FIRST ROW to equalize the amounts attained from
                     ** the detail table with the amounts attained from the
                     ** master table. */
                     UPDATE GIUW_WPERILDS_DTL 
                        SET dist_tsi      = v_correct_dist_tsi,
                            dist_prem     = v_correct_dist_prem,
                            dist_spct     = v_correct_dist_spct,
                            dist_spct1    = v_correct_dist_spct1,
                            ann_dist_tsi  = v_correct_ann_dist_tsi,
                            ann_dist_spct = v_correct_ann_dist_spct
                      WHERE ROWID         = c10.rowid;
                     EXIT;
                   END LOOP;
                 END;

                 /**************************** End of Section C *************************/

             END;
          END IF;
        END;
      END LOOP;
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Adjust computational floats to equalize the amounts
**                 attained by the master tables with that of its detail tables.
**                 Tables involved:  GIUW_WPOLICYDS - GIUW_WPOLICYDS_DTL
*/

    PROCEDURE ADJUST_POL_LVL_AMTS_GIUWS016(p_dist_no IN GIUW_POL_DIST.dist_no%TYPE) IS

      v_exist                            VARCHAR2(1) := 'N';
      v_count                            NUMBER;
      v_line_cd                          GIPI_PARLIST.line_cd%TYPE;
      v_tsi_amt                          GIUW_WPOLICYDS.tsi_amt%TYPE;
      v_prem_amt                         GIUW_WPOLICYDS.prem_amt%TYPE;
      v_ann_tsi_amt                      GIUW_WPOLICYDS.ann_tsi_amt%TYPE;
      v_dist_spct                        GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_dist_tsi                         GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_dist_prem                        GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_ann_dist_tsi                     GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
      v_ann_dist_spct                    GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;
      v_sum_dist_tsi                     GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_sum_dist_prem                    GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_sum_dist_spct                    GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_sum_ann_dist_tsi                 GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
      v_sum_ann_dist_spct                GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;
      v_correct_dist_tsi                 GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_correct_dist_prem                GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_correct_dist_spct                GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_correct_ann_dist_tsi             GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
      v_correct_ann_dist_spct            GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;

    BEGIN

      /* Scan each DIST_SEQ_NO for computational floats. */
      FOR c1 IN (SELECT dist_no                                   ,
                        dist_seq_no                               ,
                        ROUND(NVL(tsi_amt    , 0), 2) tsi_amt     ,
                        ROUND(NVL(prem_amt   , 0), 2) prem_amt    ,
                        ROUND(NVL(ann_tsi_amt, 0), 2) ann_tsi_amt
                   FROM GIUW_WPOLICYDS
                  WHERE dist_no = p_dist_no)
      LOOP
        BEGIN

          /* Get the LINE_CD for the particular DIST_SEQ_NO
          ** for use in retrieving the correct data from
          ** GIUW_WPOLICYDS_DTL. */
          FOR c2 IN (SELECT line_cd
                       FROM GIUW_WPERILDS
                      WHERE dist_seq_no = c1.dist_seq_no
                        AND dist_no     = c1.dist_no)
          LOOP
            v_line_cd := c2.line_cd;
            EXIT;
          END LOOP;

          /* **************************** Section A **********************************
          ** Compare the amounts retrieved from the master table with the sum of its
          ** counterparts from the detail table.
          ************************************************************************* */
      
          v_tsi_amt     := c1.tsi_amt;
          v_prem_amt    := c1.prem_amt;
          v_ann_tsi_amt := c1.ann_tsi_amt;

          v_exist := 'N';
          FOR c10 IN (SELECT ROUND(SUM(NVL(dist_tsi, 0)), 2)     dist_tsi     , 
                             ROUND(SUM(NVL(dist_prem, 0)), 2)    dist_prem    ,
                             ROUND(SUM(NVL(dist_spct, 0)), 14)   dist_spct    ,
                             ROUND(SUM(NVL(ann_dist_tsi, 0)), 2) ann_dist_tsi
                        FROM GIUW_WPOLICYDS_DTL
                       WHERE dist_seq_no = c1.dist_seq_no
                         AND dist_no     = c1.dist_no)
          LOOP 
            v_exist        := 'Y';
            v_dist_tsi     := c10.dist_tsi;
            v_dist_prem    := c10.dist_prem;
            v_dist_spct    := c10.dist_spct;
            v_ann_dist_tsi := c10.ann_dist_tsi;
            EXIT;
          END LOOP;
          IF v_exist = 'N' THEN
             EXIT;
          END IF;

          /*************************** End of Section A ****************************/

          /* If the amounts retrieved from the master table
          ** are not equal to the amounts retrieved from the
          ** the detail table then the procedure below shall
          ** be executed. */
          IF (100           != v_dist_spct   ) OR
             (v_tsi_amt     != v_dist_tsi    ) OR 
             (v_prem_amt    != v_dist_prem   ) OR
             (v_ann_tsi_amt != v_ann_dist_tsi) THEN
             BEGIN
               v_exist := 'N';

               /*************************** Section B *******************************
               ** Adjust the value of the fields belonging to the NET RETENTION share
               ** (SHARE_CD = '1'). If by chance a NET RETENTION share does not exist,
               ** then the NO_DATA_FOUND exception (Section C) shall handle the next
               ** few steps.
               *********************************************************************/
               
               /* Get the ROWID of the NET RETENTION share
               ** in preparation for update. */ 
               FOR c10 IN (SELECT ROWID
                             FROM GIUW_WPOLICYDS_DTL
                            WHERE share_cd    = '1'
                              AND line_cd     = v_line_cd
                              AND dist_seq_no = c1.dist_seq_no
                              AND dist_no     = c1.dist_no)
               LOOP

                 /* Get the sum of each field for all the shares excluding the NET
                 ** RETENTION share.  The result will serve as the SUBTRAHEND in 
                 ** calculating for the values to be attained by the fields belonging
                 ** to NET RETENTION. */
                 FOR c20 IN (SELECT ROUND(SUM(dist_tsi), 2)              dist_tsi     , 
                                    ROUND(SUM(dist_prem), 2)             dist_prem    , 
                                    ROUND(SUM(dist_spct), 14)            dist_spct    , 
                                    ROUND(SUM(NVL(ann_dist_tsi, 0)), 2)  ann_dist_tsi ,
                                    ROUND(SUM(NVL(ann_dist_spct, 0)), 14) ann_dist_spct
                               FROM GIUW_WPOLICYDS_DTL
                              WHERE share_cd   != '1'
                                AND line_cd     = v_line_cd
                                AND dist_seq_no = c1.dist_seq_no
                                AND dist_no     = c1.dist_no)
                 LOOP
                   v_exist             := 'Y';
                   v_sum_dist_tsi      := c20.dist_tsi;
                   v_sum_dist_prem     := c20.dist_prem;
                   v_sum_dist_spct     := c20.dist_spct;
                   v_sum_ann_dist_tsi  := c20.ann_dist_tsi;
                   v_sum_ann_dist_spct := c20.ann_dist_spct;
                   EXIT;
                 END LOOP;
                 IF v_exist = 'N' THEN
                    EXIT;
                 END IF;

                 /* Calculate for the values to be attained by the fields
                 ** belonging to the NET RETENTION share by subtracting
                 ** the values attained from the master table with the
                 ** values attained above. */
                 v_correct_dist_tsi      := ABS(v_tsi_amt)  - ABS(v_sum_dist_tsi);
                 v_correct_dist_prem     := ABS(v_prem_amt) - ABS(v_sum_dist_prem);
                 v_correct_dist_spct     := 100 - v_sum_dist_spct;
                 v_correct_ann_dist_tsi  := ABS(v_ann_tsi_amt) - ABS(v_sum_ann_dist_tsi);
                 v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

                 IF SIGN(v_tsi_amt) = -1 THEN
                    v_correct_dist_tsi := v_correct_dist_tsi * -1;
                 END IF;
                 IF SIGN(v_prem_amt) = -1 THEN
                    v_correct_dist_prem := v_correct_dist_prem * -1;
                 END IF;
                 IF SIGN(v_ann_tsi_amt) = -1 THEN
                    v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
                 END IF;

                 /* Update the values of the fields belonging to the NET
                 ** RETENTION share to equalize the amounts attained from
                 ** the detail table with the amounts attained from the
                 ** master table. */
                 UPDATE GIUW_WPOLICYDS_DTL 
                    SET dist_tsi      = v_correct_dist_tsi,
                        dist_prem     = v_correct_dist_prem,
                        dist_spct     = v_correct_dist_spct,
                        ann_dist_tsi  = v_correct_ann_dist_tsi,
                        ann_dist_spct = v_correct_ann_dist_spct
                  WHERE ROWID         = c10.rowid;
                 EXIT;
               END LOOP;
               IF v_exist = 'N' THEN
                  RAISE NO_DATA_FOUND;
               END IF;

               /*************************** End of Section B ***************************/

             EXCEPTION
               WHEN NO_DATA_FOUND THEN  
                 BEGIN

                   /****************************** Section C ******************************
                   ** Adjust the value of the fields belonging to the share of the FIRST
                   ** RETRIEVED ROW.
                   ***********************************************************************/

                   /* Get the ROWID of the first retrieved
                   ** row in preparation for update. */ 
                   FOR c10 IN (SELECT ROWID 
                                 FROM GIUW_WPOLICYDS_DTL
                                WHERE ROWNUM      = '1'
                                  AND dist_seq_no = c1.dist_seq_no
                                  AND dist_no     = c1.dist_no)
                   LOOP

                     /* Get the sum of each field for all the shares excluding the share
                     ** of the FIRST RETRIEVED ROW.  The result will serve as the SUBTRAHEND
                     ** in calculating for the values to be attained by the fields belonging
                     ** to the FIRST ROW. */
                     FOR c20 IN (SELECT ROUND(SUM(dist_tsi), 2)              dist_tsi      ,
                                        ROUND(SUM(dist_prem), 2)             dist_prem     , 
                                        ROUND(SUM(dist_spct), 14)             dist_spct     ,
                                        ROUND(SUM(NVL(ann_dist_tsi, 0)), 2)  ann_dist_tsi  ,
                                        ROUND(SUM(NVL(ann_dist_spct, 0)), 14) ann_dist_spct
                                   FROM GIUW_WPOLICYDS_DTL
                                  WHERE ROWID       != c10.rowid
                                    AND dist_seq_no  = c1.dist_seq_no
                                    AND dist_no      = c1.dist_no)
                     LOOP
                       v_sum_dist_tsi      := c20.dist_tsi;
                       v_sum_dist_prem     := c20.dist_prem;
                       v_sum_dist_spct     := c20.dist_spct;
                       v_sum_ann_dist_tsi  := c20.ann_dist_tsi;
                       v_sum_ann_dist_spct := c20.ann_dist_spct;
                       EXIT;
                     END LOOP;

                     /* Calculate for the values to be attained by the fields
                     ** belonging to the share of the FIRST ROW by subtracting
                     ** the values attained from the master table with the
                     ** values attained above. */
                     v_correct_dist_tsi      := ABS(v_tsi_amt) - ABS(v_sum_dist_tsi);
                     v_correct_dist_prem     := ABS(v_prem_amt) - ABS(v_sum_dist_prem);
                     v_correct_dist_spct     := 100 - v_sum_dist_spct;
                     v_correct_ann_dist_tsi  := ABS(v_ann_tsi_amt) - ABS(v_sum_ann_dist_tsi);
                     v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

                     IF SIGN(v_tsi_amt) = -1 THEN
                        v_correct_dist_tsi := v_correct_dist_tsi * -1;
                     END IF;
                     IF SIGN(v_prem_amt) = -1 THEN
                        v_correct_dist_prem := v_correct_dist_prem * -1;
                     END IF;
                     IF SIGN(v_ann_tsi_amt) = -1 THEN
                        v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
                     END IF;

                     /* Update the values of the fields belonging to the share
                     ** of the FIRST ROW to equalize the amounts attained from
                     ** the detail table with the amounts attained from the
                     ** master table. */
                     UPDATE GIUW_WPOLICYDS_DTL 
                        SET dist_tsi      = v_correct_dist_tsi,
                            dist_prem     = v_correct_dist_prem,
                            dist_spct     = v_correct_dist_spct,
                            ann_dist_tsi  = v_correct_ann_dist_tsi,
                            ann_dist_spct = v_correct_ann_dist_spct
                      WHERE ROWID         = c10.rowid;
                     EXIT;

                   END LOOP;
                 END;
                
                 /**************************** End of Section C *************************/

             END;
          END IF;
        END;
      END LOOP;
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Adjust computational floats to equalize the amounts
**                 attained by the master tables with that of its detail tables.
**                 Tables involved:  GIUW_WPOLICYDS - GIUW_WPOLICYDS_DTL
*/

    PROCEDURE ADJUST_WPOLICYDS_DTL_GIUWS016 ( p_dist_no      IN    GIUW_POL_DIST.dist_no%TYPE,
                                              p_dist_seq_no  IN    GIUW_WPOLICYDS.dist_seq_no%TYPE) 
    IS

      v_count                   NUMBER;
      v_exist                   VARCHAR2 (1) := 'N';
      v_dist_no                 GIUW_WPOLICYDS.dist_no%TYPE;
      v_dist_seq_no             GIUW_WPOLICYDS.dist_seq_no%TYPE;
      v_line_cd                 GIUW_WPOLICYDS_DTL.line_cd%TYPE;
      v_tsi_amt                 GIUW_WPOLICYDS.tsi_amt%TYPE;
      v_prem_amt                GIUW_WPOLICYDS.prem_amt%TYPE;
      v_ann_tsi_amt             GIUW_WPOLICYDS.ann_tsi_amt%TYPE;
      v_dist_tsi                GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_dist_prem               GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_dist_spct               GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_dist_spct1              GIUW_WPOLICYDS_DTL.dist_spct1%TYPE;
      v_ann_dist_tsi            GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
      v_ann_dist_spct           GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;
      v_sum_dist_tsi            GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_sum_dist_prem           GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_sum_dist_spct           GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_sum_dist_spct1          GIUW_WPOLICYDS_DTL.dist_spct1%TYPE;
      v_sum_ann_dist_tsi        GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
      v_sum_ann_dist_spct       GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;
      v_correct_dist_tsi        GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_correct_dist_prem       GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_correct_dist_spct       GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_correct_dist_spct1      GIUW_WPOLICYDS_DTL.dist_spct1%TYPE;
      v_correct_ann_dist_tsi    GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
      v_correct_ann_dist_spct   GIUW_WPOLICYDS_DTL.ann_dist_spct%TYPE;
   BEGIN
      v_dist_no := p_dist_no;
      v_dist_seq_no := p_dist_seq_no;

      /* Get the LINE_CD for the particular DIST_SEQ_NO
      ** for use in retrieving the correct data from
      ** GIUW_WPOLICYDS_DTL. */
      FOR c1 IN (SELECT line_cd
                   FROM GIUW_WPERILDS
                  WHERE dist_seq_no = v_dist_seq_no 
                    AND dist_no = v_dist_no)
      LOOP
         v_line_cd := c1.line_cd;
         EXIT;
      END LOOP;

      /* ************************************ Start *********************************************
      ** Adjust computational floats between tables GIUW_WPOLICYDS and GIUW_WPOLICYDS_DTL.
      ***************************************************************************************** */
      BEGIN
         /* **************************** Section A **********************************
         ** Compare the amounts retrieved from the master table with the sum of its
         ** counterparts from the detail table.
         ************************************************************************* */
         FOR c10 IN (SELECT ROUND (NVL (tsi_amt, 0), 2) tsi_amt,
                            ROUND (NVL (prem_amt, 0), 2) prem_amt,
                            ROUND (NVL (ann_tsi_amt, 0), 2) ann_tsi_amt
                       FROM GIUW_WPOLICYDS
                      WHERE dist_seq_no = v_dist_seq_no
                        AND dist_no = v_dist_no)
         LOOP
            v_exist := 'Y';
            v_tsi_amt := c10.tsi_amt;
            v_prem_amt := c10.prem_amt;
            v_ann_tsi_amt := c10.ann_tsi_amt;
            EXIT;
         END LOOP;

         IF v_exist = 'N'
         THEN
            RETURN;
         END IF;

         v_exist := 'N';

         FOR c10 IN (SELECT ROUND (SUM (NVL (dist_tsi, 0)), 2) dist_tsi,
                            ROUND (SUM (NVL (dist_prem, 0)), 2) dist_prem,
                            ROUND (SUM (NVL (dist_spct, 0)), 14) dist_spct,
                            ROUND(SUM(NVL(dist_spct1, 0)), 14)  dist_spct1   ,
                            ROUND (SUM (NVL (ann_dist_tsi, 0)),
                                   2
                                  ) ann_dist_tsi
                       FROM GIUW_WPOLICYDS_DTL
                      WHERE dist_seq_no = v_dist_seq_no
                            AND dist_no = v_dist_no)
         LOOP
            v_exist := 'Y';
            v_dist_tsi := c10.dist_tsi;
            v_dist_prem := c10.dist_prem;
            v_dist_spct := c10.dist_spct;
            v_dist_spct1   := c10.dist_spct1;
            v_ann_dist_tsi := c10.ann_dist_tsi;
            EXIT;
         END LOOP;

         IF v_exist = 'N'
         THEN
            RETURN;
         END IF;

         /*************************** End of Section A ****************************/

         /* If the amounts retrieved from the master table
         ** are not equal to the amounts retrieved from the
         ** the detail table then the procedure below shall
         ** be executed. */
         IF    (100 != v_dist_spct)
            OR (100 != v_dist_spct1  ) 
            OR (v_tsi_amt != v_dist_tsi)
            OR (v_prem_amt != v_dist_prem)
            OR (v_ann_tsi_amt != v_ann_dist_tsi)
         THEN
            BEGIN
               v_exist := 'N';

               /*************************** Section B *******************************
               ** Adjust the value of the fields belonging to the NET RETENTION share
               ** (SHARE_CD = '1'). If by chance a NET RETENTION share does not exist,
               ** then the NO_DATA_FOUND exception (Section C) shall handle the next
               ** few steps.
               *********************************************************************/

               /* Get the ROWID of the NET RETENTION share
               ** in preparation for update. */
               FOR c10 IN (SELECT ROWID
                             FROM GIUW_WPOLICYDS_DTL
                            WHERE share_cd = '1'
                              AND line_cd = v_line_cd
                              AND dist_seq_no = v_dist_seq_no
                              AND dist_no = v_dist_no)
               LOOP
                  /* Get the sum of each field for all the shares excluding the NET
                  ** RETENTION share.  The result will serve as the SUBTRAHEND in
                  ** calculating for the values to be attained by the fields belonging
                  ** to NET RETENTION. */
                  FOR c20 IN
                     (SELECT ROUND (SUM (dist_tsi), 2) dist_tsi,
                             ROUND (SUM (dist_prem), 2) dist_prem,
                             ROUND (SUM (dist_spct), 14) dist_spct,
                             ROUND(SUM(dist_spct1), 14) dist_spct1   ,
                             ROUND (SUM (NVL (ann_dist_tsi, 0)),
                                    2
                                   ) ann_dist_tsi,
                             ROUND (SUM (NVL (ann_dist_spct, 0)),
                                    14
                                   ) ann_dist_spct
                        FROM GIUW_WPOLICYDS_DTL
                       WHERE share_cd != '1'
                         AND line_cd = v_line_cd
                         AND dist_seq_no = v_dist_seq_no
                         AND dist_no = v_dist_no)
                  LOOP
                     v_exist := 'Y';
                     v_sum_dist_tsi := c20.dist_tsi;
                     v_sum_dist_prem := c20.dist_prem;
                     v_sum_dist_spct := c20.dist_spct;
                     v_sum_dist_spct1   := c20.dist_spct1;
                     v_sum_ann_dist_tsi := c20.ann_dist_tsi;
                     v_sum_ann_dist_spct := c20.ann_dist_spct;
                     EXIT;
                  END LOOP;

                  IF v_exist = 'N'
                  THEN
                     EXIT;
                  END IF;

                  /* Calculate for the values to be attained by the fields
                  ** belonging to the NET RETENTION share by subtracting
                  ** the values attained from the master table with the
                  ** values attained above. */
                  v_correct_dist_tsi := ABS (v_tsi_amt) - ABS (v_sum_dist_tsi);
                  v_correct_dist_prem :=
                                       ABS (v_prem_amt)
                                       - ABS (v_sum_dist_prem);
                  v_correct_dist_spct := 100 - v_sum_dist_spct;
                   v_correct_dist_spct1  := 100 - v_sum_dist_spct1;
                  v_correct_ann_dist_tsi :=
                                 ABS (v_ann_tsi_amt)
                                 - ABS (v_sum_ann_dist_tsi);
                  v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

                  IF SIGN (v_tsi_amt) = -1
                  THEN
                     v_correct_dist_tsi := v_correct_dist_tsi * -1;
                  END IF;

                  IF SIGN (v_prem_amt) = -1
                  THEN
                     v_correct_dist_prem := v_correct_dist_prem * -1;
                  END IF;

                  IF SIGN (v_ann_tsi_amt) = -1
                  THEN
                     v_correct_ann_dist_tsi := v_correct_ann_dist_tsi * -1;
                  END IF;

                  /* Update the values of the fields belonging to the NET
                  ** RETENTION share to equalize the amounts attained from
                  ** the detail table with the amounts attained from the
                  ** master table. */
                  UPDATE GIUW_WPOLICYDS_DTL
                     SET dist_tsi = v_correct_dist_tsi,
                         dist_prem = v_correct_dist_prem,
                         dist_spct = v_correct_dist_spct,
                         dist_spct1    = v_correct_dist_spct1,
                         ann_dist_tsi = v_correct_ann_dist_tsi,
                         ann_dist_spct = v_correct_ann_dist_spct
                   WHERE ROWID = c10.ROWID;

                  EXIT;
               END LOOP;

               IF v_exist = 'N'
               THEN
                  RAISE NO_DATA_FOUND;
               END IF;
            /*************************** End of Section B ***************************/
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  BEGIN
                     /****************************** Section C ******************************
                     ** Adjust the value of the fields belonging to the share of the FIRST
                     ** RETRIEVED ROW.
                     ***********************************************************************/

                     /* Get the ROWID of the first retrieved
                     ** row in preparation for update. */
                     FOR c10 IN (SELECT ROWID
                                   FROM GIUW_WPOLICYDS_DTL
                                  WHERE ROWNUM = '1'
                                    AND line_cd = v_line_cd
                                    AND dist_seq_no = v_dist_seq_no
                                    AND dist_no = v_dist_no)
                     LOOP
                        /* Get the sum of each field for all the shares excluding the share
                        ** of the FIRST RETRIEVED ROW.  The result will serve as the SUBTRAHEND
                        ** in calculating for the values to be attained by the fields belonging
                        ** to the FIRST ROW. */
                        FOR c20 IN
                           (SELECT ROUND (SUM (dist_tsi), 2) dist_tsi,
                                   ROUND (SUM (dist_prem), 2) dist_prem,
                                   ROUND (SUM (dist_spct), 14) dist_spct,
                                   ROUND(SUM(dist_spct1), 14)  dist_spct1,
                                   ROUND
                                       (SUM (NVL (ann_dist_tsi, 0)),
                                        2
                                       ) ann_dist_tsi,
                                   ROUND
                                      (SUM (NVL (ann_dist_spct, 0)),
                                       14
                                      ) ann_dist_spct
                              FROM GIUW_WPOLICYDS_DTL
                             WHERE ROWID != c10.ROWID
                               AND line_cd = v_line_cd
                               AND dist_seq_no = v_dist_seq_no
                               AND dist_no = v_dist_no)
                        LOOP
                           v_sum_dist_tsi := c20.dist_tsi;
                           v_sum_dist_prem := c20.dist_prem;
                           v_sum_dist_spct := c20.dist_spct;
                           v_sum_dist_spct1   := c20.dist_spct1;
                           v_sum_ann_dist_tsi := c20.ann_dist_tsi;
                           v_sum_ann_dist_spct := c20.ann_dist_spct;
                           EXIT;
                        END LOOP;

                        /* Calculate for the values to be attained by the fields
                        ** belonging to the share of the FIRST ROW by subtracting
                        ** the values attained from the master table with the
                        ** values attained above. */
                        v_correct_dist_tsi :=
                                         ABS (v_tsi_amt)
                                         - ABS (v_sum_dist_tsi);
                        v_correct_dist_prem :=
                                       ABS (v_prem_amt)
                                       - ABS (v_sum_dist_prem);
                        v_correct_dist_spct := 100 - v_sum_dist_spct;
                        v_correct_dist_spct1 := 100 - v_sum_dist_spct1;
                        v_correct_ann_dist_tsi :=
                                 ABS (v_ann_tsi_amt)
                                 - ABS (v_sum_ann_dist_tsi);
                        v_correct_ann_dist_spct := 100 - v_sum_ann_dist_spct;

                        IF SIGN (v_tsi_amt) = -1
                        THEN
                           v_correct_dist_tsi := v_correct_dist_tsi * -1;
                        END IF;

                        IF SIGN (v_prem_amt) = -1
                        THEN
                           v_correct_dist_prem := v_correct_dist_prem * -1;
                        END IF;

                        IF SIGN (v_ann_tsi_amt) = -1
                        THEN
                           v_correct_ann_dist_tsi :=
                                                   v_correct_ann_dist_tsi
                                                   * -1;
                        END IF;

                        /* Update the values of the fields belonging to the share
                        ** of the FIRST ROW to equalize the amounts attained from
                        ** the detail table with the amounts attained from the
                        ** master table. */
                        UPDATE GIUW_WPOLICYDS_DTL
                           SET dist_tsi = v_correct_dist_tsi,
                               dist_prem = v_correct_dist_prem,
                               dist_spct = v_correct_dist_spct,
                               dist_spct1   = v_correct_dist_spct1,
                               ann_dist_tsi = v_correct_ann_dist_tsi,
                               ann_dist_spct = v_correct_ann_dist_spct
                         WHERE ROWID = c10.ROWID;

                        EXIT;
                     END LOOP;
                  END;
            /**************************** End of Section C *************************/
            END;
         END IF;
      END;
/************************************** End ******************************************/
   END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Adjust computational floats to equalize the amounts
**                 attained by the master tables with that of its detail
**                 tables.
*/

    PROCEDURE ADJ_NET_RET_IMPERFECTION_016 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE) 

    IS

    BEGIN
      
      /* Equalize the amounts of tables GIUW_WITEMDS
      ** and GIUW_WITEMDS_DTL. */
      GIUW_POL_DIST_FINAL_PKG.adjust_itm_lvl_amts_giuws016(p_dist_no);

      /* Equalize the amounts of tables GIUW_WITEMPERILDS
      ** and GIUW_WITEMPERILDS_DTL. */
      GIUW_POL_DIST_FINAL_PKG.adj_itm_perl_lvl_amts_giuws016(p_dist_no);

      /* Equalize the amounts of tables GIUW_WPERILDS
      ** and GIUW_WPERILDS_DTL. */
      GIUW_POL_DIST_FINAL_PKG.adjust_peril_lvl_amts_giuws016(p_dist_no);
      
      GIUW_POL_DIST_FINAL_PKG.adjust_amts_giuws016(p_dist_no);


    END;



    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Recreate records in tables GIUW_WITEMDS_DTL,
**                 GIUW_WITEMPERILDS_DTL, GIUW_WPERILDS_DTL based on 
**                 the information taken in by table GIUW_WPOLICYDS_DTL.
*/

    PROCEDURE POP_WITEM_PERIL_DTL_GIUWS016 (p_dist_no  IN  GIUW_POL_DIST.dist_no%TYPE) IS

      v_dist_no             GIUW_POL_DIST.dist_no%TYPE;
      v_dist_tsi            GIUW_WITEMDS_DTL.dist_tsi%TYPE;
      v_dist_prem           GIUW_WITEMDS_DTL.dist_prem%TYPE;  
      v_ann_dist_tsi        GIUW_WITEMDS_DTL.ann_dist_tsi%TYPE;
      v_dist_tsi1           GIUW_WITEMPERILDS_DTL.dist_tsi%TYPE;
      v_dist_prem1          GIUW_WITEMPERILDS_DTL.dist_prem%TYPE;  
      v_ann_dist_tsi1       GIUW_WITEMPERILDS_DTL.ann_dist_tsi%TYPE;
      v_dist_tsi2           GIUW_WPERILDS_DTL.dist_tsi%TYPE;
      v_dist_prem2          GIUW_WPERILDS_DTL.dist_prem%TYPE;  
      v_ann_dist_tsi2       GIUW_WPERILDS_DTL.ann_dist_tsi%TYPE;

    BEGIN
      v_dist_no := p_dist_no;

      /* Delete tables in preparation
      ** for data insertion. */
      DELETE GIUW_WPERILDS_DTL
       WHERE dist_no = v_dist_no;
      DELETE GIUW_WITEMPERILDS_DTL
       WHERE dist_no = v_dist_no;
      DELETE GIUW_WITEMDS_DTL
       WHERE dist_no = v_dist_no;

      /* Get the distribution share percentage for each record
      ** in table GIUW_WPOLICYDS_DTL. */
      FOR c1 IN (SELECT dist_seq_no , line_cd       , share_cd ,
                        dist_spct   , ann_dist_spct , dist_grp,
                        dist_spct1
                   FROM GIUW_WPOLICYDS_DTL
                  WHERE dist_no = v_dist_no) 
      LOOP

        /* Get the amounts from table GIUW_WITEMDS and multiply
        ** it to the share percentage driven from table 
        ** GIUW_WPOLICYDS_DTL to arrive at the correct breakdown
        ** of the amounts for table GIUW_WITEMDS_DTL. */
        FOR c2 IN (SELECT tsi_amt , prem_amt , ann_tsi_amt ,
                          item_no
                     FROM GIUW_WITEMDS
                    WHERE dist_seq_no = c1.dist_seq_no
                      AND dist_no     = v_dist_no)
        LOOP
          v_dist_tsi     := ROUND(c1.dist_spct/100     * c2.tsi_amt, 2);
          v_dist_prem    := ROUND(c1.dist_spct1/100    * c2.prem_amt, 2);
          v_ann_dist_tsi := ROUND(c1.ann_dist_spct/100 * c2.ann_tsi_amt, 2);
          INSERT INTO  GIUW_WITEMDS_DTL
                      (dist_no         , dist_seq_no    , item_no          , 
                       line_cd         , share_cd       , dist_spct        ,
                       dist_tsi        , dist_prem      , ann_dist_spct    ,
                       ann_dist_tsi    , dist_grp       , dist_spct1)    
               VALUES (v_dist_no       , c1.dist_seq_no , c2.item_no       ,
                       c1.line_cd      , c1.share_cd    , c1.dist_spct     ,
                       v_dist_tsi      , v_dist_prem    , c1.ann_dist_spct ,
                       v_ann_dist_tsi  , c1.dist_grp    , c1.dist_spct1);
        END LOOP;

        /* Get the amounts from table GIUW_WITEMPERILDS and multiply
        ** it to the share percentage driven from table 
        ** GIUW_WPOLICYDS_DTL to arrive at the correct breakdown
        ** of the amounts for table GIUW_WITEMPERILDS_DTL. */
        FOR c3 IN (SELECT tsi_amt , prem_amt , ann_tsi_amt ,
                          item_no , line_cd  , peril_cd
                     FROM GIUW_WITEMPERILDS
                    WHERE line_cd     = c1.line_cd
                      AND dist_seq_no = c1.dist_seq_no
                      AND dist_no     = v_dist_no)
        LOOP
          v_dist_tsi1     := ROUND(c1.dist_spct/100     * c3.tsi_amt, 2);
           v_dist_prem1   := ROUND(c1.dist_spct1/100    * c3.prem_amt, 2);
          v_ann_dist_tsi1 := ROUND(c1.ann_dist_spct/100 * c3.ann_tsi_amt, 2);
          INSERT INTO  GIUW_WITEMPERILDS_DTL
                      (dist_no         , dist_seq_no    , item_no          , 
                       line_cd         , share_cd       , dist_spct        ,
                       dist_tsi        , dist_prem      , ann_dist_spct    ,
                       ann_dist_tsi    , dist_grp       , peril_cd         ,
                       dist_spct1)
               VALUES (v_dist_no       , c1.dist_seq_no , c3.item_no       ,
                       c3.line_cd      , c1.share_cd    , c1.dist_spct     ,
                       v_dist_tsi1     , v_dist_prem1   , c1.ann_dist_spct ,
                       v_ann_dist_tsi1 , c1.dist_grp    , c3.peril_cd      ,
                       c1.dist_spct1);
        END LOOP;

        /* Get the amounts from table GIUW_WPERILDS and multiply
        ** it to the share percentage driven from table 
        ** GIUW_WPOLICYDS_DTL to arrive at the correct breakdown
        ** of the amounts for table GIUW_WPERILDS_DTL. */
        FOR c4 IN (SELECT tsi_amt , prem_amt , ann_tsi_amt ,
                          line_cd  , peril_cd
                     FROM GIUW_WPERILDS
                    WHERE line_cd     = c1.line_cd
                      AND dist_seq_no = c1.dist_seq_no
                      AND dist_no     = v_dist_no)
        LOOP
          v_dist_tsi2     := ROUND(c1.dist_spct/100     * c4.tsi_amt, 2);
          --v_dist_prem2    := ROUND(c1.dist_spct/100     * c4.prem_amt, 2);
          v_dist_prem2    := ROUND(c1.dist_spct1/100    * c4.prem_amt, 2);
          v_ann_dist_tsi2 := ROUND(c1.ann_dist_spct/100 * c4.ann_tsi_amt, 2);
          INSERT INTO  GIUW_WPERILDS_DTL
                      (dist_no         , dist_seq_no    , peril_cd         , 
                       line_cd         , share_cd       , dist_spct        ,
                       dist_tsi        , dist_prem      , ann_dist_spct    ,
                       ann_dist_tsi    , dist_grp       , dist_spct1)
               VALUES (v_dist_no       , c1.dist_seq_no , c4.peril_cd      ,
                       c1.line_cd      , c1.share_cd    , c1.dist_spct     ,
                       v_dist_tsi2     , v_dist_prem2   , c1.ann_dist_spct ,
                       v_ann_dist_tsi2 , c1.dist_grp    , c1.dist_spct1);
        END LOOP;
      END LOOP;
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : CREATE_RI_RECORDS Program Unit from GIUWS010
*/

    PROCEDURE CREATE_RI_RECORDS_GIUWS016(p_policy_id  IN  GIUW_POL_DIST.policy_id%TYPE,
                                         p_dist_no    IN  GIUW_POL_DIST.dist_no%TYPE,
                                         p_par_id     IN  GIPI_PARLIST.par_id%TYPE,
                                         p_line_cd    IN  GIPI_WPOLBAS.line_cd%TYPE,
                                         p_subline_cd IN  GIPI_WPOLBAS.subline_cd%TYPE) IS
      
      v_frps_exist            BOOLEAN;
      v_line_cd               GIUW_WPERILDS.line_cd%TYPE;
      v_new_dist_tsi          GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_new_dist_prem         GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_new_dist_spct         GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_exist                 VARCHAR2(1) := 'N';
      v_disallow_posting_sw   VARCHAR2(1) := 'N';

    BEGIN

      /* ************************************************************************************* */
      /* Checks for the existence of a facultative share code in each of the DIST_SEQ_NO's of
      ** table GIUW_WPOLICYDS_DTL.  If the said share code exists for a particular DIST_SEQ_NO,
      ** then procedure will check for an existing record in RI table GIRI_WDISTFRPS and update
      ** such record in accordance with the values taken in by table GIUW_WPOLICYDS_DTL.  Should
      ** table GIRI_WDISTFRPS contain no entries with regards to the current DIST_SEQ_NO with the
      ** facultative share, then a record shall be created against the said table.
      ** On the other hand, if a facultative share does not exist for a particular DIST_SEQ_NO,
      ** then procedure will delete any related records in RI tables GIRI_WBINDER_PERIL,
      ** GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI, and GIRI_WDISTFRPS.
      ** NOTE:  A VALID facultative share must not have a zero DIST_TSI and a zero DIST_PREM.
      ** Modified by:  Crystal 12/28/1998  */
      /* ************************************************************************************ */

      /* Disable the POST DISTRIBUTION button first.
      ** If a facultative share was found to be existing then
      ** that's the time to reenable it. */
      --SET_ITEM_PROPERTY('c1306.but_post_dist', ENABLED, PROPERTY_FALSE);

      FOR c1 IN (SELECT C1306.dist_seq_no , C1306.tsi_amt    , C1306.prem_amt ,
                        B450.currency_cd  , B450.currency_rt , C080.user_id
                   FROM GIUW_WPOLICYDS C1306,
                        GIUW_POL_DIST C080,
                        GIPI_WINVOICE B450
                  WHERE B450.item_grp = C1306.item_grp
                    AND B450.par_id   = C080.par_id
                    AND C080.dist_no  = C1306.dist_no
                    AND C1306.dist_no = p_dist_no)
      LOOP
        BEGIN

          /* Get the LINE_CD for the particular DIST_SEQ_NO
          ** for use in retrieving the correct data from
          ** GIUW_WPOLICYDS_DTL. */
          FOR c100 IN (SELECT line_cd
                         FROM GIUW_WPERILDS
                        WHERE dist_seq_no = c1.dist_seq_no
                          AND dist_no     = p_dist_no)
          LOOP
            v_line_cd := c100.line_cd;
            EXIT;
          END LOOP;

          v_exist := 'N';
          FOR c200 IN (SELECT dist_prem , dist_spct , dist_tsi
                       FROM GIUW_WPOLICYDS_DTL
                      WHERE share_cd    = '999'
                        AND line_cd     = v_line_cd
                        AND dist_seq_no = c1.dist_seq_no
                        AND dist_no     = p_dist_no)
          LOOP
            v_exist         := 'Y';
            v_new_dist_prem := c200.dist_prem;
            v_new_dist_spct := c200.dist_spct;
            v_new_dist_tsi  := c200.dist_tsi;
            EXIT;
          END LOOP;
          IF v_exist = 'N' THEN
             RAISE NO_DATA_FOUND;
          END IF;

          IF v_new_dist_tsi  = 0 AND
             v_new_dist_prem = 0 THEN

             /* Disable the POST DISTRIBUTION button first.
             ** If a facultative share was found to be existing then
             ** that's the time to reenable it. */
             --SET_ITEM_PROPERTY('c1306.but_post_dist', ENABLED, PROPERTY_FALSE);
             v_disallow_posting_sw := 'Y';

             /* Sets the distribution flag of table GIUW_WPOLICYDS to
             ** 1, signifying that the current DIST_SEQ_NO is not yet
             ** properly distributed. */
             UPDATE GIUW_WPOLICYDS
                SET dist_flag =  '1'
              WHERE dist_seq_no = c1.dist_seq_no
                AND dist_no     = p_dist_no;

          END IF;

          IF v_new_dist_tsi  != 0 OR 
             v_new_dist_prem != 0 THEN

             IF v_disallow_posting_sw = 'N' THEN

                /* Enable the POST DISTRIBUTION button because a facultative
                ** share was found to be existing in table GIUW_WPOLICYDS_DTL. */
                NULL;
             END IF;

             /* Checks for an existing record corresponding to
             ** the given DIST_SEQ_NO in table GIRI_WDISTFRPS. */
             v_frps_exist := CHECK_FOR_EXISTING_FRPS(p_dist_no, c1.dist_seq_no);

             IF NOT v_frps_exist THEN

                /* Creates a new record in table GIRI_WDISTFRPS in
                ** accordance with the data taken in by table
                ** GIUW_WPOLICYDS_DTL. */
                GIRI_WDISTFRPS_PKG.create_ri_new_wdistfrps_016
                      (p_policy_id     , p_dist_no       , c1.dist_seq_no , c1.tsi_amt      ,
                       c1.prem_amt     , v_new_dist_tsi , v_new_dist_prem ,
                       v_new_dist_spct , c1.currency_cd , c1.currency_rt  ,
                       c1.user_id      , p_par_id       , p_line_cd       ,
                       p_subline_cd);

             ELSE

                /* Updates the existing record of table 
                ** GIRI_WDISTFRPS in accordance with the
                ** data taken in by table GIUW_WPOLICYDS_DTL. */            
                UPDATE_RI_WDISTFRPS
                      (p_dist_no       , c1.dist_seq_no , c1.tsi_amt      ,
                       c1.prem_amt     , v_new_dist_tsi , v_new_dist_prem , 
                       v_new_dist_spct , c1.currency_cd , c1.currency_rt  ,
                       c1.user_id);

             END IF;
          ELSE

             /* Delete related records in RI tables GIRI_WBINDER_PERIL,
             ** GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI, and 
             ** GIRI_WDISTFRPS. */
             DELETE_RI_TABLES(p_dist_no, c1.dist_seq_no);

          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN

            /* Delete related records in RI tables GIRI_WBINDER_PERIL,
            ** GIRI_WBINDER, GIRI_WFRPERIL, GIRI_WFRPS_RI, and 
            ** GIRI_WDISTFRPS. */
            DELETE_RI_TABLES(p_dist_no, c1.dist_seq_no);

        END;
      END LOOP;

    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : CREATE_GRP_DFLT_WPOLICYDS Program Unit from GIUWS016
*/

    PROCEDURE CREATE_GRP_DFLT_WPOLICYDS_016
             (p_dist_no         IN  GIUW_WPOLICYDS_DTL.dist_no%TYPE      ,
              p_dist_seq_no     IN  GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE  ,
              p_line_cd         IN  GIUW_WPOLICYDS_DTL.line_cd%TYPE      ,
              p_dist_tsi        IN  GIUW_WPOLICYDS_DTL.dist_tsi%TYPE     ,
              p_dist_prem       IN  GIUW_WPOLICYDS_DTL.dist_prem%TYPE    ,
              p_ann_dist_tsi    IN  GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE ,
              p_rg_count        IN  OUT NUMBER                           ,
              p_default_type    IN  GIIS_DEFAULT_DIST.default_type%TYPE  ,
              p_currency_rt     IN  GIPI_WITEM.currency_rt%TYPE          ,
              p_par_id          IN  GIPI_PARLIST.par_id%TYPE             ,
              p_item_grp        IN  GIPI_WITEM.item_grp%TYPE             ,
              p_policy_id       IN  GIUW_POL_DIST.policy_id%TYPE         ,
              p_pol_flag        IN  GIPI_WPOLBAS.pol_flag%TYPE           ,
              p_par_type        IN  GIPI_PARLIST.par_type%TYPE) 

    IS

      --rg_id              RECORDGROUP;
      rg_name               VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_col1               VARCHAR2(40) := rg_name || '.line_cd';
      rg_col2               VARCHAR2(40) := rg_name || '.share_cd';
      rg_col3               VARCHAR2(40) := rg_name || '.share_pct';
      rg_col4               VARCHAR2(40) := rg_name || '.share_amt1';
      rg_col5               VARCHAR2(40) := rg_name || '.peril_cd';
      rg_col6               VARCHAR2(40) := rg_name || '.share_amt2';
      rg_col7               VARCHAR2(40) := rg_name || '.true_pct';
      v_remaining_tsi       NUMBER       := p_dist_tsi * p_currency_rt;
      v_share_amt           GIIS_DEFAULT_DIST_GROUP.share_amt1%TYPE;
      v_peril_cd            GIIS_DEFAULT_DIST_GROUP.peril_cd%TYPE;
      v_prev_peril_cd       GIIS_DEFAULT_DIST_GROUP.peril_cd%TYPE;
      v_dist_spct           GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_dist_tsi            GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_dist_prem           GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_ann_dist_tsi        GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE;
      v_sum_dist_tsi        GIUW_WPOLICYDS_DTL.dist_tsi%TYPE     := 0;
      v_sum_dist_spct       GIUW_WPOLICYDS_DTL.dist_spct%TYPE    := 0;
      v_sum_dist_prem       GIUW_WPOLICYDS_DTL.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi    GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE := 0;
      v_share_cd            GIIS_DIST_SHARE.share_cd%TYPE;
      v_use_share_amt2      VARCHAR2(1) := 'N';
      v_dist_spct_limit     NUMBER;

      PROCEDURE INSERT_TO_WPOLICYDS_DTL IS
      BEGIN
        INSERT INTO  GIUW_WPOLICYDS_DTL
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , dist_spct1)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , v_dist_spct);
      END;

    BEGIN
        
      IF p_rg_count = 0 THEN
          
         IF p_pol_flag = '2' THEN -- renewal
                 
                 FOR c IN (
                   SELECT share_cd, dist_spct
                     FROM giuw_policyds_dtl a
                    WHERE a.dist_seq_no = p_dist_seq_no
                      AND dist_no = ( SELECT max(dist_no) 
                                      FROM GIUW_POL_DIST 
                                         WHERE policy_id = ( SELECT MAX(old_policy_id) 
                                                              FROM GIPI_POLNREP
                                                             WHERE par_id = p_par_id
                                                               AND ren_rep_sw = '1'
                                                               AND new_policy_id = (SELECT policy_id
                                                                                      FROM gipi_polbasic
                                                                                     WHERE pol_flag <> '5'
                                                                                       AND policy_id = p_policy_id))))
                 LOOP         
                   v_share_cd         := c.share_cd;
                   v_dist_spct        := c.dist_spct;
                   v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                   v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                   v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                   v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                   v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                   v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
                   INSERT_TO_WPOLICYDS_DTL;
                     END LOOP;
             
             ELSIF p_par_type = 'E' THEN
                     
                 FOR c IN (
                   SELECT share_cd, dist_spct
                     FROM GIUW_POLICYDS_DTL a
                    WHERE a.dist_seq_no = p_dist_seq_no
                      AND dist_no = ( SELECT max(dist_no) 
                                       FROM GIUW_POL_DIST 
                                      WHERE par_id = ( SELECT par_id
                                                        FROM GIPI_POLBASIC
                                                        WHERE endt_seq_no = 0
                                                          AND (line_cd, subline_cd, 
                                                               iss_cd,  issue_yy, 
                                                               pol_seq_no, renew_no) = (SELECT line_cd,    subline_cd, 
                                                                                               iss_cd,     issue_yy, 
                                                                                               pol_seq_no, renew_no
                                                                                        FROM GIPI_POLBASIC
                                                                                        WHERE policy_id = p_policy_id))))
                     LOOP         
                       v_share_cd         := c.share_cd;
                       v_dist_spct        := c.dist_spct;
                       v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                       v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                       v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                       v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                       v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                       v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);               
                       INSERT_TO_WPOLICYDS_DTL;
                       
                     END LOOP;            
             ELSE
                 /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_dist_tsi;
                 v_dist_prem    := p_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WPOLICYDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;             
         END IF;  

      ELSE
         NULL; -- null muna since p_rg_count will always be equals to 0 - nica 
      END IF;   
    END; 
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : CREATE_GRP_DFLT_WPERILDS Program Unit from GIUWS016
*/

    PROCEDURE CREATE_GRP_DFLT_WPERILDS_016
             (p_dist_no        IN   GIUW_WPERILDS_DTL.dist_no%TYPE      ,
              p_dist_seq_no    IN   GIUW_WPERILDS_DTL.dist_seq_no%TYPE  ,
              p_line_cd        IN   GIUW_WPERILDS_DTL.line_cd%TYPE      ,
              p_peril_cd       IN   GIUW_WPERILDS_DTL.peril_cd%TYPE     ,
              p_dist_tsi       IN   GIUW_WPERILDS_DTL.dist_tsi%TYPE     ,
              p_dist_prem      IN   GIUW_WPERILDS_DTL.dist_prem%TYPE    ,
              p_ann_dist_tsi   IN   GIUW_WPERILDS_DTL.ann_dist_tsi%TYPE ,
              p_rg_count       IN   NUMBER                              ,
              p_par_id         IN   GIPI_PARLIST.par_id%TYPE            ,
              p_policy_id      IN   GIUW_POL_DIST.policy_id%TYPE        ,
              p_pol_flag       IN   GIPI_WPOLBAS.pol_flag%TYPE          ,
              p_par_type       IN   GIPI_PARLIST.par_type%TYPE)  IS

      --rg_id                                RECORDGROUP;
      rg_name                         VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_col2                         VARCHAR2(40) := rg_name || '.share_cd';
      rg_col7                         VARCHAR2(40) := rg_name || '.true_pct';
      v_selection_count               NUMBER;
      v_row                           NUMBER;
      v_dist_spct                     GIUW_WPERILDS_DTL.dist_spct%TYPE;
      v_dist_tsi                      GIUW_WPERILDS_DTL.dist_tsi%TYPE;
      v_dist_prem                     GIUW_WPERILDS_DTL.dist_prem%TYPE;
      v_ann_dist_tsi                  GIUW_WPERILDS_DTL.ann_dist_tsi%TYPE;
      v_share_cd                      GIIS_DIST_SHARE.share_cd%TYPE;
      v_sum_dist_tsi                  GIUW_WPERILDS_DTL.dist_tsi%TYPE  := 0;
      v_sum_dist_spct                 GIUW_WPERILDS_DTL.dist_spct%TYPE := 0;
      v_sum_dist_prem                 GIUW_WPERILDS_DTL.dist_prem%TYPE := 0;
      v_sum_ann_dist_tsi              GIUW_WPERILDS_DTL.ann_dist_tsi%TYPE := 0;

      PROCEDURE INSERT_TO_WPERILDS_DTL IS
      BEGIN
        INSERT INTO  GIUW_WPERILDS_DTL
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , peril_cd      , dist_spct1)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_peril_cd    , v_dist_spct);
      END;

    BEGIN
        
      IF p_rg_count = 0 THEN
                
         IF p_pol_flag = '2' THEN -- renewal
                 
                 FOR c IN (
                   SELECT share_cd, dist_spct
                     FROM GIUW_POLICYDS_DTL a
                    WHERE 1 = 1 
                      AND a.dist_seq_no = p_dist_seq_no
                        AND dist_no = ( SELECT max(dist_no) 
                                        FROM GIUW_POL_DIST 
                                        WHERE policy_id = ( SELECT MAX(old_policy_id) 
                                                            FROM GIPI_POLNREP
                                                            WHERE par_id = p_par_id
                                                              AND ren_rep_sw = '1'
                                                              AND new_policy_id = (SELECT policy_id
                                                                                     FROM gipi_polbasic
                                                                                    WHERE pol_flag <> '5'
                                                                                      AND policy_id = p_policy_id))))
                     LOOP         
                   
                       v_share_cd         := c.share_cd;
                       v_dist_spct        := c.dist_spct;
                       v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                       v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                       v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                       v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                       v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                       v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
                   
                       INSERT_TO_WPERILDS_DTL;
                     END LOOP;
             ELSIF p_par_type = 'E' THEN
                     
                    FOR c IN (
                        SELECT share_cd, dist_spct
                          FROM GIUW_POLICYDS_DTL a
                         WHERE 1 = 1
                           AND a.dist_seq_no = p_dist_seq_no
                           AND dist_no = ( SELECT max(dist_no) 
                                           FROM GIUW_POL_DIST 
                                           WHERE par_id = ( SELECT par_id
                                                            FROM GIPI_POLBASIC
                                                            WHERE endt_seq_no = 0
                                                             AND (line_cd,         subline_cd, 
                                                                  iss_cd,          issue_yy, 
                                                                  pol_seq_no,    renew_no) = (SELECT line_cd,        subline_cd, 
                                                                                                     iss_cd,         issue_yy, 
                                                                                                     pol_seq_no,     renew_no
                                                                                              FROM GIPI_POLBASIC
                                                                                              WHERE policy_id = p_policy_id))))
                     LOOP         
                       v_share_cd         := c.share_cd;
                       v_dist_spct        := c.dist_spct;
                       v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                       v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                       v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                       v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                       v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                       v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);               
                       INSERT_TO_WPERILDS_DTL;
                     END LOOP;            
             ELSE
                     /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_dist_tsi;
                 v_dist_prem    := p_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WPERILDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;             
         END IF;  
      ELSE
           NULL; -- null muna since p_rg_count will always be equals to 0 - nica 

         /*rg_id             := FIND_GROUP(rg_name);
         IF NOT id_null(rg_id) THEN
            v_selection_count := GET_GROUP_SELECTION_COUNT(rg_id);
         END IF;   

         FOR c IN 1..v_selection_count
         LOOP
           v_row           := GET_GROUP_SELECTION(rg_id, c);
           v_dist_spct     := GET_GROUP_NUMBER_CELL(rg_col7, v_row);
           v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
           IF v_sum_dist_spct != 100 THEN
              v_dist_tsi         := ROUND(p_dist_tsi         * v_dist_spct / 100, 2);
              v_dist_prem        := ROUND(p_dist_prem        * v_dist_spct / 100, 2);
              v_ann_dist_tsi     := ROUND(p_ann_dist_tsi     * v_dist_spct / 100, 2);
              v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
              v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
              v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
           ELSE
              v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
              v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
              v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
           END IF;
           v_share_cd     := GET_GROUP_NUMBER_CELL(rg_col2, v_row);
           INSERT_TO_WPERILDS_DTL;
         END LOOP;*/

      END IF;   
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : CREATE_GRP_DFLT_WITEMPERILDS Program Unit from GIUWS016
*/

    PROCEDURE CRTE_GRP_DFLT_WITEMPERILDS_016
             (p_dist_no            IN   GIUW_WITEMPERILDS_DTL.dist_no%TYPE      ,
              p_dist_seq_no        IN   GIUW_WITEMPERILDS_DTL.dist_seq_no%TYPE  ,
              p_item_no            IN   GIUW_WITEMPERILDS_DTL.item_no%TYPE      ,
              p_line_cd            IN   GIUW_WITEMPERILDS_DTL.line_cd%TYPE      ,
              p_peril_cd           IN   GIUW_WITEMPERILDS_DTL.peril_cd%TYPE     ,
              p_dist_tsi           IN   GIUW_WITEMPERILDS_DTL.dist_tsi%TYPE     ,
              p_dist_prem          IN   GIUW_WITEMPERILDS_DTL.dist_prem%TYPE    ,
              p_ann_dist_tsi       IN   GIUW_WITEMPERILDS_DTL.ann_dist_tsi%TYPE ,
              p_rg_count           IN   NUMBER                                  ,
              p_par_id             IN   GIPI_PARLIST.par_id%TYPE                ,
              p_policy_id          IN   GIUW_POL_DIST.policy_id%TYPE            ,
              p_pol_flag           IN   GIPI_WPOLBAS.pol_flag%TYPE              ,
              p_par_type           IN   GIPI_PARLIST.par_type%TYPE) 
      IS

      --rg_id                                RECORDGROUP;
      rg_name                           VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_col2                           VARCHAR2(40) := rg_name || '.share_cd';
      rg_col7                           VARCHAR2(40) := rg_name || '.true_pct';
      v_selection_count                 NUMBER;
      v_row                             NUMBER;
      v_dist_spct                       GIUW_WITEMPERILDS_DTL.dist_spct%TYPE;
      v_dist_tsi                        GIUW_WITEMPERILDS_DTL.dist_tsi%TYPE;
      v_dist_prem                       GIUW_WITEMPERILDS_DTL.dist_prem%TYPE;
      v_ann_dist_tsi                    GIUW_WITEMPERILDS_DTL.ann_dist_tsi%TYPE;
      v_share_cd                        GIIS_DIST_SHARE.share_cd%TYPE;
      v_sum_dist_tsi                    GIUW_WITEMPERILDS_DTL.dist_tsi%TYPE     := 0;
      v_sum_dist_spct                   GIUW_WITEMPERILDS_DTL.dist_spct%TYPE    := 0;
      v_sum_dist_prem                   GIUW_WITEMPERILDS_DTL.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi                GIUW_WITEMPERILDS_DTL.ann_dist_tsi%TYPE := 0;

      PROCEDURE INSERT_TO_WITEMPERILDS_DTL IS
      BEGIN
        INSERT INTO  GIUW_WITEMPERILDS_DTL
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , item_no       , peril_cd                ,
                     dist_spct1)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_item_no     , p_peril_cd            ,
                     v_dist_spct);
      END;

    BEGIN
        
      IF p_rg_count = 0 THEN
          
         IF p_pol_flag = '2' THEN -- renewal
                 --message('pol flag 2');pause;
                 FOR c IN (
                   SELECT share_cd, dist_spct
                     FROM GIUW_POLICYDS_DTL a
                    WHERE a.dist_seq_no = p_dist_seq_no
                        AND dist_no       = ( SELECT max(dist_no) 
                                              FROM GIUW_POL_DIST 
                                              WHERE policy_id = ( SELECT MAX(old_policy_id) 
                                                                    FROM GIPI_POLNREP
                                                                  WHERE par_id = p_par_id
                                                                    AND ren_rep_sw = '1'
                                                                    AND new_policy_id = (SELECT policy_id
                                                                                           FROM gipi_polbasic
                                                                                          WHERE pol_flag <> '5'
                                                                                            AND policy_id = p_policy_id))))
                     LOOP         
                       v_share_cd         := c.share_cd;
                       v_dist_spct        := c.dist_spct;
                       v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                       v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                       v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                       v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                       v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                       v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
                       INSERT_TO_WITEMPERILDS_DTL;
                     END LOOP;
             ELSIF p_par_type = 'E' THEN
                     
                     FOR c IN (
                            SELECT share_cd, dist_spct
                               FROM giuw_policyds_dtl a
                             WHERE a.dist_seq_no = p_dist_seq_no
                             AND dist_no = ( SELECT max(dist_no) 
                                             FROM GIUW_POL_DIST 
                                             WHERE par_id = ( SELECT par_id
                                                              FROM GIPI_POLBASIC
                                                              WHERE endt_seq_no = 0
                                                                AND (line_cd,         subline_cd, 
                                                                      iss_cd,          issue_yy, 
                                                                        pol_seq_no,    renew_no) = (SELECT line_cd,         subline_cd, 
                                                                                                           iss_cd,         issue_yy, 
                                                                                                           pol_seq_no, renew_no
                                                                                                      FROM GIPI_POLBASIC
                                                                                                      WHERE policy_id = p_policy_id))))
                     LOOP         
                       v_share_cd         := c.share_cd;
                       v_dist_spct        := c.dist_spct;
                       v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                       v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                       v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                       v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                       v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                       v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);               
                       INSERT_TO_WITEMPERILDS_DTL;
                     END LOOP;            
             ELSE
                     /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_dist_tsi;
                 v_dist_prem    := p_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WITEMPERILDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;             
         END IF;    
         

      ELSE
          NULL; -- null muna since p_rg_count will always be equals to 0 - nica 
         
         /*rg_id             := FIND_GROUP(rg_name);
         IF NOT id_null(rg_id) THEN
            v_selection_count := GET_GROUP_SELECTION_COUNT(rg_id);
         END IF;   

         FOR c IN 1..v_selection_count
         LOOP
           v_row           := GET_GROUP_SELECTION(rg_id, c);
           v_dist_spct     := GET_GROUP_NUMBER_CELL(rg_col7, v_row);
           v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
           IF v_sum_dist_spct != 100 THEN
              v_dist_tsi         := ROUND(p_dist_tsi         * v_dist_spct / 100, 2);
              v_dist_prem        := ROUND(p_dist_prem        * v_dist_spct / 100, 2);
              v_ann_dist_tsi     := ROUND(p_ann_dist_tsi     * v_dist_spct / 100, 2);
              v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
              v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
              v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
           ELSE
              v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
              v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
              v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
           END IF;
           v_share_cd     := GET_GROUP_NUMBER_CELL(rg_col2, v_row);
           INSERT_TO_WITEMPERILDS_DTL;
         END LOOP;*/

      END IF;   
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : CREATE_GRP_DFLT_WITEMDS Program Unit from GIUWS016
*/

    PROCEDURE CREATE_GRP_DFLT_WITEMDS_016
             (p_dist_no            IN   GIUW_WITEMDS_DTL.dist_no%TYPE      ,
              p_dist_seq_no        IN   GIUW_WITEMDS_DTL.dist_seq_no%TYPE  ,
              p_item_no            IN   GIUW_WITEMDS_DTL.item_no%TYPE      ,
              p_line_cd            IN   GIUW_WITEMDS_DTL.line_cd%TYPE      ,
              p_dist_tsi           IN   GIUW_WITEMDS_DTL.dist_tsi%TYPE     ,
              p_dist_prem          IN   GIUW_WITEMDS_DTL.dist_prem%TYPE    ,
              p_ann_dist_tsi       IN   GIUW_WITEMDS_DTL.ann_dist_tsi%TYPE ,
              p_rg_count           IN   NUMBER                             ,
              p_par_id             IN   GIPI_PARLIST.par_id%TYPE           ,
              p_policy_id          IN   GIUW_POL_DIST.policy_id%TYPE       ,
              p_pol_flag           IN   GIPI_WPOLBAS.pol_flag%TYPE         ,
              p_par_type           IN   GIPI_PARLIST.par_type%TYPE) IS

      --rg_id                        RECORDGROUP;
      rg_name                    VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_col2                    VARCHAR2(40) := rg_name || '.share_cd';
      rg_col7                    VARCHAR2(40) := rg_name || '.true_pct';
      v_selection_count          NUMBER;
      v_row                      NUMBER;
      v_dist_spct                GIUW_WITEMDS_DTL.dist_spct%TYPE;
      v_dist_tsi                 GIUW_WITEMDS_DTL.dist_tsi%TYPE;
      v_dist_prem                GIUW_WITEMDS_DTL.dist_prem%TYPE;
      v_ann_dist_tsi             GIUW_WITEMDS_DTL.ann_dist_tsi%TYPE;
      v_share_cd                 GIIS_DIST_SHARE.share_cd%TYPE;
      v_sum_dist_tsi             GIUW_WITEMDS_DTL.dist_tsi%TYPE     := 0;
      v_sum_dist_spct            GIUW_WITEMDS_DTL.dist_spct%TYPE    := 0;
      v_sum_dist_prem            GIUW_WITEMDS_DTL.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi         GIUW_WITEMDS_DTL.ann_dist_tsi%TYPE := 0;


  PROCEDURE INSERT_TO_WITEMDS_DTL IS
     BEGIN
        
        INSERT INTO  GIUW_WITEMDS_DTL
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , item_no       , dist_spct1)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_item_no     , v_dist_spct);
     END;

    BEGIN
        
      IF p_rg_count = 0 THEN
           
         IF p_pol_flag = '2' THEN -- renewal
                 
                 FOR c IN (
                   SELECT share_cd, dist_spct
                     FROM giuw_policyds_dtl a
                    WHERE 1 = 1
                      AND a.dist_seq_no = p_dist_seq_no
                      AND dist_no       = ( SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                              WHERE policy_id = ( SELECT MAX(old_policy_id) 
                                                                   FROM GIPI_POLNREP
                                                                WHERE par_id = p_par_id
                                                                  AND ren_rep_sw = '1'
                                                                  AND new_policy_id = (SELECT policy_id
                                                                                         FROM gipi_polbasic
                                                                                        WHERE pol_flag <> '5'
                                                                                          AND policy_id = p_policy_id))))
                     LOOP         
                       v_share_cd         := c.share_cd;
                       v_dist_spct        := c.dist_spct;
                       v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                       v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                       v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                       v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                       v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                       v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
                        INSERT_TO_WITEMDS_DTL;
                     END LOOP;
                     
             ELSIF p_par_type = 'E' THEN
                     
                     FOR c IN (
                            SELECT share_cd, dist_spct
                               FROM GIUW_POLICYDS_DTL a
                            WHERE 1 = 1
                                AND a.dist_seq_no = p_dist_seq_no
                                AND dist_no = ( SELECT max(dist_no) 
                                                FROM GIUW_POL_DIST 
                                                WHERE par_id = ( SELECT par_id
                                                                   FROM GIPI_POLBASIC
                                                                   WHERE endt_seq_no = 0
                                                                     AND (line_cd,       subline_cd, 
                                                                          iss_cd,        issue_yy, 
                                                                          pol_seq_no,    renew_no) = (SELECT line_cd,        subline_cd, 
                                                                                                             iss_cd,         issue_yy, 
                                                                                                             pol_seq_no,     renew_no
                                                                                                        FROM GIPI_POLBASIC
                                                                                                       WHERE policy_id = p_policy_id))))
                     LOOP         
                       v_share_cd         := c.share_cd;
                       v_dist_spct        := c.dist_spct;
                       v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                       v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                       v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                       v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                       v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                       v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);               
                       INSERT_TO_WITEMDS_DTL;
                     END LOOP;            
             ELSE
                     /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_dist_tsi;
                 v_dist_prem    := p_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WITEMDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;             
         END IF;  

      ELSE
          NULL; -- null muna since p_rg_count will always be equals to 0 - nica 
          
         /*rg_id             := FIND_GROUP(rg_name);
         IF NOT id_null(rg_id) THEN
            v_selection_count := GET_GROUP_SELECTION_COUNT(rg_id);
         END IF;   

         FOR c IN 1..v_selection_count
         LOOP
           v_row           := GET_GROUP_SELECTION(rg_id, c);
           v_dist_spct     := GET_GROUP_NUMBER_CELL(rg_col7, v_row);
           v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
           IF v_sum_dist_spct != 100 THEN
              v_dist_tsi         := ROUND(((p_dist_tsi     * v_dist_spct)/ 100), 2);
              v_dist_prem        := ROUND(((p_dist_prem    * v_dist_spct)/ 100), 2);
              v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * v_dist_spct)/ 100), 2);
              v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
              v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
              v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
           ELSE
              v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
              v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
              v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
           END IF;
           v_share_cd     := GET_GROUP_NUMBER_CELL(rg_col2, v_row);
           INSERT_TO_WITEMDS_DTL;
         END LOOP;*/

      END IF;   
    END;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 3, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : CREATE_GRP_DFLT_DIST Program Unit from GIUWS016
*/

    PROCEDURE CREATE_GRP_DFLT_DIST_GIUWS016(p_dist_no        IN  GIUW_WPOLICYDS.dist_no%TYPE,
                                            p_dist_seq_no    IN  GIUW_WPOLICYDS.dist_seq_no%TYPE,
                                            p_dist_flag      IN  GIUW_WPOLICYDS.dist_flag%TYPE,
                                            p_policy_tsi     IN  GIUW_WPOLICYDS.tsi_amt%TYPE,
                                            p_policy_premium IN  GIUW_WPOLICYDS.prem_amt%TYPE,
                                            p_policy_ann_tsi IN  GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
                                            p_item_grp       IN  GIUW_WPOLICYDS.item_grp%TYPE,
                                            p_line_cd        IN  GIIS_LINE.line_cd%TYPE,
                                            p_rg_count       IN OUT NUMBER,
                                            p_default_type   IN  GIIS_DEFAULT_DIST.default_type%TYPE,
                                            p_currency_rt    IN  GIPI_WITEM.currency_rt%TYPE,
                                            p_par_id         IN  GIPI_PARLIST.par_id%TYPE,
                                            p_dist_exists    IN  VARCHAR2,
                                            p_policy_id      IN  GIUW_POL_DIST.policy_id%TYPE,
                                            p_pol_flag       IN  GIPI_WPOLBAS.pol_flag%TYPE,
                                            p_par_type       IN  GIPI_PARLIST.par_type%TYPE) IS

      v_peril_cd                    GIIS_PERIL.peril_cd%TYPE;
      v_peril_tsi                   GIUW_WPERILDS.tsi_amt%TYPE      := 0;
      v_peril_premium               GIUW_WPERILDS.prem_amt%TYPE     := 0;
      v_peril_ann_tsi               GIUW_WPERILDS.ann_tsi_amt%TYPE  := 0;
      v_exist                       VARCHAR2(1)                     := 'N';
      v_insert_sw                   VARCHAR2(1)                     := 'N';
      v_dist_exists                 VARCHAR2(1)                     := p_dist_exists;

      /* Updates the amounts of the previously processed PERIL_CD
      ** while looping inside cursor C3.  After which, the records
      ** for table GIUW_WPERILDS_DTL are also created.
      ** NOTE:  This is a LOCAL PROCEDURE BODY called below. */
      PROCEDURE  UPD_CREATE_WPERIL_DTL_DATA IS
      BEGIN
        GIUW_POL_DIST_FINAL_PKG.create_grp_dflt_wperilds_016
              (p_dist_no       , p_dist_seq_no , p_line_cd       ,
               v_peril_cd      , v_peril_tsi   , v_peril_premium ,
               v_peril_ann_tsi , p_rg_count    , p_par_id        ,
               p_policy_id     , p_pol_flag    , p_par_type);
      END;

    BEGIN
      
    /***********************
            POLICYDS
    ***********************/          
      IF NVL(v_dist_exists,'N') = 'N' THEN      
         INSERT INTO  GIUW_WPOLICYDS
                    ( dist_no      , dist_seq_no      , dist_flag        ,
                      tsi_amt      , prem_amt         , ann_tsi_amt      ,
                      item_grp)
             VALUES (p_dist_no    , p_dist_seq_no    , p_dist_flag      ,
                     p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                     p_item_grp);
      ELSE
           UPDATE GIUW_WPOLICYDS
                 SET tsi_amt       = p_policy_tsi,
                     prem_amt      = p_policy_premium,
                     ann_tsi_amt   = p_policy_ann_tsi
               WHERE dist_no       = p_dist_no
                 AND dist_seq_no   = p_dist_seq_no;                               
      END IF;
      
        /*CREATE_GRP_DFLT_WPOLICYDS
                    (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
                     p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                     p_rg_count   , p_default_type   , p_currency_rt    ,
                     p_par_id     , p_item_grp);*/    ---GRACE

       /* Get the amounts for each item in table GIPI_WITEM in preparation
        ** for data insertion to its corresponding distribution tables. */
        
    /***********************
            ITEMDS
    ***********************/          
        
      IF NVL(v_dist_exists,'N') = 'N' THEN      
         FOR c2 IN (
           SELECT a.item_no , a.tsi_amt , a.prem_amt , a.ann_tsi_amt
             FROM GIPI_ITEM a
            WHERE EXISTS ( SELECT '1'
                             FROM GIPI_ITMPERIL b
                            WHERE b.policy_id = a.policy_id
                              AND b.item_no   = a.item_no)
              AND a.item_grp    = p_item_grp
              AND a.policy_id   = p_policy_id)
         LOOP 
           /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL
           ** for the specified DIST_SEQ_NO. */
           INSERT INTO GIUW_WITEMDS
                     ( dist_no        , dist_seq_no   , item_no        ,
                       tsi_amt        , prem_amt      , ann_tsi_amt)
              VALUES ( p_dist_no      , p_dist_seq_no , c2.item_no     ,
                       c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);      
           GIUW_POL_DIST_FINAL_PKG.create_grp_dflt_witemds_016
                      (p_dist_no      , p_dist_seq_no , c2.item_no  ,
                       p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
                       c2.ann_tsi_amt , p_rg_count    , p_par_id        ,
                       p_policy_id    , p_pol_flag    , p_par_type);                   
         END LOOP;
      ELSE
           FOR c2 IN (
                SELECT a.item_no , b.tsi_amt , b.prem_amt , b.ann_tsi_amt
                  FROM GIUW_WITEMDS a, GIPI_ITEM b
                 WHERE a.dist_no     = p_dist_no
                   AND a.dist_seq_no = p_dist_seq_no
                          AND a.item_no     = b.item_no
                          AND b.policy_id   = p_policy_id
                          AND EXISTS( SELECT 1
                                 FROM GIPI_ITMPERIL c
                                WHERE b.policy_id  = c.policy_id
                                  AND b.item_no = c.item_no))
             LOOP
               UPDATE GIUW_WITEMDS             
                  SET tsi_amt     = c2.tsi_amt,
                      prem_amt    = c2.prem_amt,
                      ann_tsi_amt = c2.ann_tsi_amt
                WHERE dist_no     = p_dist_no
                  AND item_no     = c2.item_no
                  AND dist_seq_no = p_dist_seq_no;
                                                
               GIUW_POL_DIST_FINAL_PKG.create_grp_dflt_witemds_016
                              (p_dist_no      , p_dist_seq_no , c2.item_no  ,
                               p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
                               c2.ann_tsi_amt , p_rg_count    , p_par_id        ,
                               p_policy_id    , p_pol_flag    , p_par_type );                          
             END LOOP;
      END IF;
         
      GIUW_POL_DIST_PKG.update_dtls_no_share_cd(p_dist_no, p_dist_seq_no, 'ITEM', p_line_cd);       
      
        /* Initialize the value of the variables
        ** in preparation for processing the new
        ** DIST_SEQ_NO. */
        v_peril_cd      := NULL;
        v_peril_tsi     := 0;
        v_peril_premium := 0;
        v_peril_ann_tsi := 0;   
        v_exist         := 'N';

        /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
        ** in table GIPI_WITMPERL in preparation for data insertion to 
        ** distribution tables GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
        ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
      IF NVL(v_dist_exists,'N') = 'N' THEN
           FOR c3 IN (  
             SELECT B490.tsi_amt     itmperil_tsi     ,
                    B490.prem_amt    itmperil_premium ,
                    B490.ann_tsi_amt itmperil_ann_tsi ,
                    B490.item_no     item_no          ,
                    B490.peril_cd    peril_cd
             FROM GIPI_ITMPERIL B490, GIPI_ITEM B480
            WHERE B490.item_no   = B480.item_no
              AND B490.policy_id = B480.policy_id
              AND B480.item_grp  = p_item_grp
              AND B480.policy_id = p_policy_id)
         LOOP
           v_exist     := 'Y';
           /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
           ** for the specified DIST_SEQ_NO. */
           INSERT INTO GIUW_WITEMPERILDS  
                     ( dist_no             , dist_seq_no   , item_no         ,
                       peril_cd            , line_cd       , tsi_amt         ,
                       prem_amt            , ann_tsi_amt)
              VALUES ( p_dist_no           , p_dist_seq_no , c3.item_no      ,
                       c3.peril_cd         , p_line_cd     , c3.itmperil_tsi , 
                       c3.itmperil_premium , c3.itmperil_ann_tsi);
        
           GIUW_POL_DIST_FINAL_PKG.crte_grp_dflt_witemperilds_016
                     ( p_dist_no           , p_dist_seq_no       , c3.item_no      ,
                       p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                       c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count      ,
                       p_par_id            , p_policy_id         , p_pol_flag    , p_par_type);
         END LOOP;
      ELSE
         FOR c3 IN (  
               SELECT B490.tsi_amt     itmperil_tsi     ,
                      B490.prem_amt    itmperil_premium ,
                      B490.ann_tsi_amt itmperil_ann_tsi ,
                      B490.item_no     item_no          ,
                      B490.peril_cd    peril_cd
                 FROM GIPI_ITMPERIL B490, GIPI_ITEM B480
                WHERE B490.item_no   = B480.item_no
                  AND B490.policy_id = B480.policy_id
                  AND B480.item_grp  = p_item_grp
                  AND B480.policy_id = p_policy_id
                  AND EXISTS ( SELECT 1
                                 FROM GIUW_WPOLICYDS c
                                WHERE 1 = 1
                                  AND c.dist_no     = p_dist_no
                                  AND c.dist_seq_no = p_dist_seq_no
                                  AND c.item_grp    = p_item_grp
                                  AND c.item_grp    = b480.item_grp)
                  AND EXISTS ( SELECT 1
                                 FROM GIUW_WITEMDS c
                                WHERE 1 = 1
                                  AND c.dist_no     = p_dist_no
                                  AND c.dist_seq_no = p_dist_seq_no
                                  AND c.item_no     = b480.item_no))
             LOOP
               v_exist     := 'Y';
               /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
               ** for the specified DIST_SEQ_NO. */
               INSERT INTO GIUW_WITEMPERILDS  
                         ( dist_no             , dist_seq_no   , item_no         ,
                           peril_cd            , line_cd       , tsi_amt         ,
                           prem_amt            , ann_tsi_amt)
                  VALUES ( p_dist_no           , p_dist_seq_no , c3.item_no      ,
                           c3.peril_cd         , p_line_cd     , c3.itmperil_tsi , 
                           c3.itmperil_premium , c3.itmperil_ann_tsi);                           
                              
               GIUW_POL_DIST_FINAL_PKG.crte_grp_dflt_witemperilds_016
                         ( p_dist_no           , p_dist_seq_no       , c3.item_no      ,
                           p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                           c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count      ,
                           p_par_id            , p_policy_id         , p_pol_flag      , p_par_type);
             END LOOP;    
      END IF;
       
      GIUW_POL_DIST_PKG.update_dtls_no_share_cd(p_dist_no, p_dist_seq_no, 'ITEMPERIL', p_line_cd);
                  
      IF NVL(v_dist_exists,'N') = 'N' THEN
           FOR c4 IN (
               SELECT sum(B490.tsi_amt)     itmperil_tsi     ,
                      sum(B490.prem_amt)    itmperil_premium ,
                      sum(B490.ann_tsi_amt) itmperil_ann_tsi ,
                      --B490.item_no     item_no          ,
                      B490.peril_cd    peril_cd
                 FROM GIPI_ITMPERIL B490, GIPI_ITEM B480
                WHERE B490.item_no   = B480.item_no
                  AND B490.policy_id = B480.policy_id
                  AND B480.item_grp  = p_item_grp
                  AND B480.policy_id = p_policy_id
                GROUP BY B490.peril_cd)
             LOOP       
               
               INSERT INTO GIUW_WPERILDS  
                         ( dist_no   , dist_seq_no   , peril_cd         ,
                           line_cd   , tsi_amt       , prem_amt         ,
                           ann_tsi_amt)
                  VALUES ( p_dist_no , p_dist_seq_no , c4.peril_cd       ,
                           p_line_cd , c4.itmperil_tsi   , c4.itmperil_premium  ,
                           c4.itmperil_ann_tsi);            
               
               v_peril_cd         := c4.peril_cd;
               v_peril_tsi        := c4.itmperil_tsi;
               v_peril_premium    := c4.itmperil_premium;
               v_peril_ann_tsi    := c4.itmperil_ann_tsi;
               
               UPD_CREATE_WPERIL_DTL_DATA;
                                  
             END LOOP;
      ELSE
           FOR c4 IN (
               SELECT sum(B490.tsi_amt)     itmperil_tsi     ,
                      sum(B490.prem_amt)    itmperil_premium ,
                      sum(B490.ann_tsi_amt) itmperil_ann_tsi ,
                      --B490.item_no     item_no          ,
                      B490.peril_cd    peril_cd
                 FROM GIPI_ITMPERIL B490, GIPI_ITEM B480
                WHERE B490.item_no   = B480.item_no
                  AND B490.policy_id = B480.policy_id
                  AND B480.item_grp  = p_item_grp
                  AND B480.policy_id = p_policy_id
                  AND EXISTS ( SELECT 1
                                 FROM GIUW_WITEMDS c
                                WHERE 1 = 1
                                  AND c.dist_no     = p_dist_no
                                  AND c.dist_seq_no = p_dist_seq_no
                                  AND c.item_no     = b480.item_no)
                GROUP BY B490.peril_cd)
             LOOP       
                
               INSERT INTO GIUW_WPERILDS  
                         ( dist_no   , dist_seq_no   , peril_cd         ,
                           line_cd   , tsi_amt       , prem_amt         ,
                           ann_tsi_amt)
                  VALUES ( p_dist_no , p_dist_seq_no , c4.peril_cd       ,
                           p_line_cd , c4.itmperil_tsi   , c4.itmperil_premium  ,
                           c4.itmperil_ann_tsi);            
               
               v_peril_cd         := c4.peril_cd;
               v_peril_tsi        := c4.itmperil_tsi;
               v_peril_premium    := c4.itmperil_premium;
               v_peril_ann_tsi    := c4.itmperil_ann_tsi;
                  
               UPD_CREATE_WPERIL_DTL_DATA;                   
             END LOOP; 
      END IF;    
       
      GIUW_POL_DIST_PKG.update_dtls_no_share_cd(p_dist_no, p_dist_seq_no, 'PERIL', p_line_cd);       
        
      GIUW_POL_DIST_FINAL_PKG.create_grp_dflt_wpolicyds_016
           ( p_dist_no    , p_dist_seq_no    , p_line_cd        ,
             p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
             p_rg_count   , p_default_type   , p_currency_rt    ,
             p_par_id     , p_item_grp       , p_policy_id      ,
             p_pol_flag   , p_par_type);
       
      GIUW_POL_DIST_PKG.update_dtls_no_share_cd(p_dist_no, p_dist_seq_no,'POLICY', p_line_cd);                 

    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 3, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Create default distribution records in all distribution tables namely:
**                 GIUW_WPOLICYDS, GIUW_WPOLICYDS_DTL, GIUW_WITEMDS, GIUW_WITEMDS_DTL,
**                 GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL, GIUW_WPERILDS and GIUW_WPERILDS_DTL.
**                 The default records inserted to the detail tables were driven from the default
**                 distribution tables:  GIIS_DEFAULT_DIST, GIIS_DEFAULT_DIST_GROUP and 
**                 GIIS_DEFAULT_DIST_PERIL.
*/

    PROCEDURE CREATE_PAR_DISTR_RECS_016
              (p_dist_no       IN   GIUW_POL_DIST.dist_no%TYPE,
               p_par_id        IN   GIPI_PARLIST.par_id%TYPE,
               p_line_cd       IN   GIPI_PARLIST.line_cd%TYPE,
               p_subline_cd    IN   GIPI_WPOLBAS.subline_cd%TYPE,
               p_iss_cd        IN   GIPI_WPOLBAS.iss_cd%TYPE,
               p_pack_pol_flag IN   GIPI_WPOLBAS.pack_pol_flag%TYPE,
               p_policy_id     IN   GIUW_POL_DIST.policy_id%TYPE,
               p_pol_flag      IN   GIPI_WPOLBAS.pol_flag%TYPE,
               p_par_type      IN   GIPI_PARLIST.par_type%TYPE) IS

      v_line_cd                     GIPI_PARLIST.line_cd%TYPE;
      v_subline_cd                  GIPI_WPOLBAS.subline_cd%TYPE;
      v_dist_seq_no                 GIUW_WPOLICYDS.dist_seq_no%TYPE := 0;
      --rg_id                         RECORDGROUP;
      rg_name                       VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_count                      NUMBER := 0;
      v_exist                       VARCHAR2(1);
      v_errors                      NUMBER;
      v_default_no                  GIIS_DEFAULT_DIST.default_no%TYPE;
      v_default_type                GIIS_DEFAULT_DIST.default_type%TYPE;
      v_dflt_netret_pct             GIIS_DEFAULT_DIST.dflt_netret_pct%TYPE;
      v_dist_type                   GIIS_DEFAULT_DIST.dist_type%TYPE;
      v_post_flag                   VARCHAR2(1)  := 'O';
      v_package_policy_sw           VARCHAR2(1)  := 'Y';
      v_dist_exists                 VARCHAR2(1)  := 'N';

    BEGIN
      FOR a IN ( 
          SELECT 1 
            FROM GIUW_WPOLICYDS
           WHERE dist_no = p_dist_no)
        LOOP
            v_dist_exists := 'Y';
            EXIT;
        END LOOP;
        
      IF NVL(v_dist_exists,'N') = 'N'  THEN 
      
      /* Get the unique ITEM_GRP to produce a unique DIST_SEQ_NO for each. */
          FOR c1 IN (  SELECT NVL(item_grp, 1) item_grp        ,
                              pack_line_cd     pack_line_cd    ,
                              pack_subline_cd  pack_subline_cd ,
                              currency_rt      currency_rt     ,
                              SUM(tsi_amt)     policy_tsi      ,
                              SUM(prem_amt)    policy_premium  ,
                              SUM(ann_tsi_amt) policy_ann_tsi
                         FROM GIPI_ITEM a
                        WHERE EXISTS ( SELECT 1
                                         FROM GIPI_ITMPERIL
                                        WHERE policy_id = a.policy_id 
                                          AND item_no = a.item_no )   
                           --(b.prem_amt != 0
                           --OR b.tsi_amt  != 0)
                          AND policy_id    = p_policy_id
                     GROUP BY item_grp    , pack_line_cd , pack_subline_cd ,
                              currency_rt)
          LOOP

            /* If the PAR processed is a package policy
            ** then get the true LINE_CD and true SUBLINE_CD,
            ** that is, the PACK_LINE_CD and PACK_SUBLINE_CD 
            ** from the GIPI_WITEM table.
            ** This will be used upon inserting to certain
            ** distribution tables requiring a value for
            ** the similar field. */
            IF p_pack_pol_flag = 'N' THEN
               v_line_cd    := p_line_cd;
               v_subline_cd := p_subline_cd;
            ELSE
               v_line_cd           := c1.pack_line_cd;
               v_subline_cd        := c1.pack_subline_cd;
               v_package_policy_sw := 'Y';
            END IF;

            IF v_package_policy_sw = 'Y' THEN
               FOR c2 IN (SELECT default_no, default_type, dist_type,
                                 dflt_netret_pct
                            FROM GIIS_DEFAULT_DIST
                           WHERE iss_cd     = p_iss_cd
                             AND subline_cd = v_subline_cd
                             AND line_cd    = v_line_cd)
               LOOP
                 v_default_no      := c2.default_no;
                 v_default_type    := c2.default_type;
                 v_dist_type       := c2.dist_type;
                 v_dflt_netret_pct := c2.dflt_netret_pct;
                 EXIT;
               END LOOP;
               /*IF NVL(v_dist_type, '1') = '1' THEN
                  rg_id := FIND_GROUP(rg_name);
                  IF NOT ID_NULL(rg_id) THEN
                     DELETE_GROUP(rg_id);
                  END IF;
                  rg_id    := CREATE_GROUP_FROM_QUERY(rg_name,
                              '   SELECT a.line_cd    , a.share_cd , a.share_pct  , '
                           || '          a.share_amt1 , a.peril_cd , a.share_amt2 , '
                           || '          1 true_pct '
                           || '     FROM giis_default_dist_group a '
                           || '    WHERE a.default_no = ' || TO_CHAR(NVL(v_default_no, 0))
                           || '      AND a.line_cd    = ' || '''' || v_line_cd || ''''
                           || '      AND a.share_cd   <> 999 '      
                           || ' ORDER BY a.sequence ASC');
                  v_errors := POPULATE_GROUP(rg_id);
                  IF v_errors NOT IN (0, 1403) THEN
                     MESSAGE('Error populating group ' || rg_name || '.', NO_ACKNOWLEDGE);
                     RAISE FORM_TRIGGER_FAILURE;
                  END IF;
                  rg_count := GET_GROUP_ROW_COUNT(rg_id);
               END IF;*/
               v_package_policy_sw := 'N';
            END IF;

            /* Generate a new DIST_SEQ_NO for the new
            ** item group. */
            v_dist_seq_no := v_dist_seq_no + 1;

            v_post_flag := 'O';
            GIUW_POL_DIST_FINAL_PKG.create_grp_dflt_dist_giuws016
                     (p_dist_no      , v_dist_seq_no     , '2'               ,
                      c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                      c1.item_grp    , v_line_cd         , rg_count          ,
                      v_default_type , c1.currency_rt    , p_par_id          ,
                      v_dist_exists  , p_policy_id       , p_pol_flag        ,
                      p_par_type);   
          END LOOP;
      ELSE
              FOR a IN ( 
                SELECT dist_seq_no, tsi_amt, prem_amt, ann_tsi_amt,item_grp
                  FROM GIUW_WPOLICYDS
                 WHERE dist_no = p_dist_no)
              LOOP
                  
                  v_post_flag := 'O';
                                
                  GIUW_POL_DIST_FINAL_PKG.create_grp_dflt_dist_giuws016
                          (p_dist_no      , a.dist_seq_no  , '2'           ,
                           a.tsi_amt      , a.prem_amt     , a.ann_tsi_amt ,
                           a.item_grp     , p_line_cd      , rg_count      ,
                           v_default_type , 1              , p_par_id      ,
                           v_dist_exists  , p_policy_id       , p_pol_flag        ,
                           p_par_type);                          
              END LOOP;          
      END IF;
      
     /* IF NOT ID_NULL(rg_id) THEN
         DELETE_GROUP(rg_id);
      END IF; */
      
      IF p_pol_flag != '2' AND p_par_type = 'P' THEN 
      /* Equalize the amounts of tables GIUW_WPOLICYDS
      ** and GIUW_WPOLICYDS_DTL. */
      GIUW_POL_DIST_FINAL_PKG.adjust_pol_lvl_amts_giuws016(p_dist_no);

      /* Adjust computational floats to equalize the amounts
      ** attained by the master tables with that of its detail
      ** tables.
      ** Tables involved:  GIUW_WPERILDS     - GIUW_WPERILDS_DTL
      **                   GIUW_WITEMDS      - GIUW_WITEMDS_DTL
      **                   GIUW_WITEMPERILDS - GIUW_WITEMPERILDS_DTL */
      GIUW_POL_DIST_FINAL_PKG.adj_net_ret_imperfection_016(p_dist_no);
      END IF;
      

      /* Create records in RI tables if a facultative
      ** share exists in any of the DIST_SEQ_NO in table
      ** GIUW_WPOLICYDS_DTL. */
      GIUW_POL_DIST_FINAL_PKG.create_ri_records_giuws016(p_policy_id, p_dist_no, p_par_id, p_line_cd, p_subline_cd);

      /* Set the value of the DIST_FLAG back 
      ** to Undistributed after recreation. */
      --:c080.dist_flag      := '1';
      --:c080.mean_dist_flag := 'Undistributed';
      UPDATE GIUW_POL_DIST
         SET dist_flag = '1',
             post_flag = v_post_flag
       WHERE par_id    = p_par_id
         AND dist_no   = p_dist_no;
         
      GIUW_POL_DIST_FINAL_PKG.adjust_amts_giuws016(p_dist_no);
      
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 3, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : CREATE_ITEMS Program Unit from GIUWS016
*/

    PROCEDURE CREATE_ITEMS_GIUWS016 (p_dist_no       IN   GIUW_POL_DIST.dist_no%TYPE,
                                     p_par_id        IN   GIPI_PARLIST.par_id%TYPE,
                                     p_line_cd       IN   GIPI_PARLIST.line_cd%TYPE,
                                     p_subline_cd    IN   GIPI_WPOLBAS.subline_cd%TYPE,
                                     p_iss_cd        IN   GIPI_WPOLBAS.iss_cd%TYPE,
                                     p_pack_pol_flag IN   GIPI_WPOLBAS.pack_pol_flag%TYPE,
                                     p_policy_id     IN   GIUW_POL_DIST.policy_id%TYPE,
                                     p_pol_flag      IN   GIPI_WPOLBAS.pol_flag%TYPE,
                                     p_par_type      IN   GIPI_PARLIST.par_type%TYPE) IS
    BEGIN

      /* Create or recreate records in distribution tables GIUW_WPOLICYDS,
      ** GIUW_WPOLICYDS_DTL, GIUW_WITEMDS, GIUW_WITEMDS_DTL, GIUW_WITEMPERILDS,
      ** GIUW_WITEMPERILDS_DTL, GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
      
      GIUW_POL_DIST_FINAL_PKG.create_par_distr_recs_016
        (p_dist_no ,     p_par_id ,      p_line_cd , 
         p_subline_cd ,  p_iss_cd ,      p_pack_pol_flag, 
         p_policy_id,    p_pol_flag,     p_par_type);

    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 5, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Check if the distribution has been previously negated
**                 before recreating the records in the RI tables.
*/

    PROCEDURE POLICY_NEGATED_CHECK_GIUWS016 (p_facul_sw          IN OUT VARCHAR2,
                                             p_policy_id         IN     GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                                             p_dist_no           IN     GIUW_POL_DIST.dist_no%TYPE,
                                             p_line_cd           IN     GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                             p_subline_cd        IN     GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE) 

    IS

      v_exist                       VARCHAR2(1)  := 'N';
      v_old_dist_no                 GIUW_POL_DIST.dist_no%TYPE;
      v_old_tsi_amt                 GIUW_POLICYDS.tsi_amt%TYPE;
      v_old_prem_amt                GIUW_POLICYDS.prem_amt%TYPE;
      v_old_dist_tsi                GIUW_POLICYDS_DTL.dist_tsi%TYPE;
      v_old_dist_prem               GIUW_POLICYDS_DTL.dist_prem%TYPE;
      v_old_dist_spct               GIUW_POLICYDS_DTL.dist_spct%TYPE;
      v_old_dist_spct1              GIUW_POLICYDS_DTL.dist_spct1%TYPE;
      v_old_line_cd                 GIUW_POLICYDS_DTL.line_cd%TYPE;
      v_old_currency_cd             GIPI_INVOICE.currency_cd%TYPE;
      v_old_currency_rt             GIPI_INVOICE.currency_rt%TYPE;
      v_old_user_id                 GIUW_POL_DIST.user_id%TYPE;
      v_new_tsi_amt                 GIUW_WPOLICYDS.tsi_amt%TYPE;
      v_new_prem_amt                GIUW_WPOLICYDS.prem_amt%TYPE;
      v_new_dist_tsi                GIUW_WPOLICYDS_DTL.dist_tsi%TYPE;
      v_new_dist_prem               GIUW_WPOLICYDS_DTL.dist_prem%TYPE;
      v_new_dist_spct               GIUW_WPOLICYDS_DTL.dist_spct%TYPE;
      v_new_dist_spct1              GIUW_WPOLICYDS_DTL.dist_spct1%TYPE;
      -- v_new_line_cd            giuw_wpolicyds_dtl.line_cd%TYPE;
      v_new_currency_cd             GIPI_INVOICE.currency_cd%TYPE;
      v_new_currency_rt             GIPI_INVOICE.currency_rt%TYPE;
      v_new_user_id                 GIUW_POL_DIST.user_id%TYPE;
      v_rg_seq_no                   GIUW_WPOLICYDS.dist_seq_no%TYPE;
      v_errors                      NUMBER;
      v_count                       NUMBER;
      v_frps_exist                  BOOLEAN;
      rec_count                     NUMBER;
	  --added by robert 10.13.15 GENQA 5053
      v_allied_facul        		BOOLEAN;                 
      v_tsi_allied_facul    		giuw_wperilds_dtl.dist_tsi%TYPE;
      v_tsi_allied          		giuw_wperilds_dtl.dist_tsi%TYPE;
	  
      /** Variables to be used for the record group **/
          TYPE rg_current_groups_type   IS RECORD (
            column_seq_no               GIUW_WPERILDS_DTL.dist_seq_no%TYPE,
            dist_tsi                    GIUW_WPERILDS_DTL.dist_tsi%TYPE,
            dist_prem                   GIUW_WPERILDS_DTL.dist_prem%TYPE,
            dist_spct                   GIUW_WPERILDS_DTL.dist_spct%TYPE,
            dist_spct1                  GIUW_WPERILDS_DTL.dist_spct1%TYPE,
            tsi_amt                     GIUW_WPERILDS.tsi_amt%TYPE,
            prem_amt                    GIUW_WPERILDS.prem_amt%TYPE,
            user_id                     GIUW_POL_DIST.user_id%TYPE,
            currency_cd                 GIPI_INVOICE.currency_cd%TYPE,
            currency_rt                 GIPI_INVOICE.currency_rt%TYPE
          );
          
          TYPE  rg_current_groups_tab IS TABLE OF rg_current_groups_type;
          
          v_rg_current_groups           rg_current_groups_tab;
          
          v_rg_index                    INTEGER;

      /* Process the remaining records from the
      ** dynamically created record group. */
      PROCEDURE PROCESS_REMAINING_RECORDS IS
      BEGIN
        v_count := v_rg_current_groups.COUNT;
        
        IF v_count > 0 THEN
             v_rg_index := v_rg_current_groups.FIRST;
           --FOR c1 IN 1..v_count
           WHILE v_rg_index IS NOT NULL
           LOOP
             v_rg_seq_no           := v_rg_current_groups(v_rg_index).column_seq_no;
             v_new_tsi_amt         := v_rg_current_groups(v_rg_index).tsi_amt;
             v_new_prem_amt        := v_rg_current_groups(v_rg_index).prem_amt;
             v_new_dist_tsi        := v_rg_current_groups(v_rg_index).dist_tsi;
             v_new_dist_prem       := v_rg_current_groups(v_rg_index).dist_prem;
             v_new_dist_spct       := v_rg_current_groups(v_rg_index).dist_spct;
             v_new_dist_spct1      := v_rg_current_groups(v_rg_index).dist_spct1;
             v_new_currency_cd     := v_rg_current_groups(v_rg_index).currency_cd;
             v_new_currency_rt     := v_rg_current_groups(v_rg_index).currency_rt;
             v_new_user_id         := v_rg_current_groups(v_rg_index).user_id;
             v_frps_exist          := CHECK_FOR_EXISTING_FRPS(p_dist_no, v_rg_seq_no);
             
             IF NOT v_frps_exist THEN

                /* Create a new record in table GIRI_WDISTFRPS in
                ** accordance with the values taken in by table
                ** GIUW_WPOLICYDS_DTL. */
                GIRI_WDISTFRPS_PKG.create_new_wdistfrps_giuws016(p_dist_no         , v_rg_seq_no       , v_new_tsi_amt     , v_new_prem_amt    , 
                                                                 v_new_dist_tsi    , v_new_dist_prem   , v_new_dist_spct   , v_new_dist_spct1  , 
                                                                 v_new_currency_cd , v_new_currency_rt , v_new_user_id     , p_line_cd         , 
                                                                 p_subline_cd      , p_policy_id);

             ELSE

                /* Update the amounts of the existing record
                ** in table GIRI_WDISTFRPS. */
                GIRI_WDISTFRPS_PKG.update_wdistfrps_giuws016(p_dist_no ,         v_rg_seq_no       , v_new_tsi_amt     , v_new_prem_amt    ,
                                                             v_new_dist_tsi    , v_new_dist_prem   , v_new_dist_spct   , v_new_dist_spct1  , 
                                                             v_new_currency_cd , v_new_currency_rt , v_new_user_id);

             END IF;
              v_rg_index := v_rg_current_groups.NEXT(v_rg_index); --added by: Nica 03.05.2012
           END LOOP;
        END IF;
        
      END;

    BEGIN
         
         -- initialize record group tab
          v_rg_current_groups := rg_current_groups_tab();

      /* Create a dynamic record group for the current 
      ** distribution record to temporarily maintain a 
      ** list of the DIST_SEQ_NOs with a facultative share
      ** in it.
      ** NOTE:  The V_ERRORS variable was created to contain the ORA error
      **        number which caused the population failure of a record group
      **        during a call made to the POPULATE_GROUP built-in.  The
      **        variable will return a zero value if no errors were encountered,
      **        and a 1403 if the query caused no records to be retrieved. */
      
      IF v_rg_current_groups.COUNT > 0 THEN
         v_rg_current_groups.TRIM(v_rg_current_groups.COUNT);
      END IF;
      
       FOR c1 IN (SELECT C1407.dist_seq_no , 
                        C1407.dist_tsi    , 
                        C1407.line_cd     , 
                        C1407.dist_prem   , 
                        C1407.dist_spct   , 
                        C1407.dist_spct1  , 
                        C1306.tsi_amt     , 
                        C1306.prem_amt    , 
                        C080.user_id      , 
                        B140.currency_cd  , 
                        B140.currency_rt 
                   FROM GIUW_WPOLICYDS_DTL C1407, 
                        GIUW_WPOLICYDS C1306, 
                        GIUW_POL_DIST C080, 
                        GIPI_INVOICE B140 
                  WHERE B140.item_grp     = C1306.item_grp 
                    AND B140.policy_id    = C080.policy_id 
                    AND C080.dist_no      = C1306.dist_no 
                    AND C1306.dist_seq_no = C1407.dist_seq_no 
                    AND C1306.dist_no     = C1407.dist_no 
                    AND C1407.share_cd    = 999 
                    AND C1407.dist_no     = TO_CHAR(p_dist_no)
               ORDER BY C1407.dist_seq_no )
               
       LOOP
             v_rg_current_groups.EXTEND(1);
             v_rg_current_groups(v_rg_current_groups.COUNT).column_seq_no    := c1.dist_seq_no;
             v_rg_current_groups(v_rg_current_groups.COUNT).tsi_amt          := c1.tsi_amt;
             v_rg_current_groups(v_rg_current_groups.COUNT).prem_amt         := c1.prem_amt;
             v_rg_current_groups(v_rg_current_groups.COUNT).dist_tsi         := c1.dist_tsi;
             v_rg_current_groups(v_rg_current_groups.COUNT).dist_prem        := c1.dist_prem;
             v_rg_current_groups(v_rg_current_groups.COUNT).dist_spct        := c1.dist_spct;
             v_rg_current_groups(v_rg_current_groups.COUNT).dist_spct1       := c1.dist_spct1; -- andrew 1.2.2013
             v_rg_current_groups(v_rg_current_groups.COUNT).currency_cd      := c1.currency_cd;
             v_rg_current_groups(v_rg_current_groups.COUNT).currency_rt      := c1.currency_rt;
             v_rg_current_groups(v_rg_current_groups.COUNT).user_id          := c1.user_id;
             
             /*  -- jhing commented out. Enhancement on illegal distribution should not affect the TSI amt 
                -- of GIRI_WDISTFRPS. This code cause zero TSI_ANT in GIRI_WDISTFRPS (REPUBLICFULLWEB 21734 , MAC 21789 )
			 --added by robert 10.13.15 GENQA 5053
			 v_allied_facul := giuw_pol_dist_final_pkg.check_peril_dist (p_dist_no, c1.dist_seq_no );
         	 IF v_allied_facul THEN
				BEGIN
				   SELECT SUM (dist_tsi) tsi
					 INTO v_tsi_allied_facul
					 FROM giuw_wperilds_dtl a, giis_peril b
					WHERE a.share_cd = '999'
					  AND a.line_cd = p_line_cd
					  AND a.dist_seq_no = c1.dist_seq_no
					  AND a.dist_no = p_dist_no
					  AND a.line_cd = b.line_cd
					  AND a.peril_cd = b.peril_cd
					  AND b.peril_type = 'A';
				END;
	
				BEGIN
				   SELECT SUM (dist_tsi)
					 INTO v_tsi_allied
					 FROM giuw_wperilds_dtl
					WHERE line_cd = p_line_cd
					  AND dist_seq_no = c1.dist_seq_no
					  AND dist_no = p_dist_no
					  AND peril_cd IN (
							 SELECT a.peril_cd
							   FROM giuw_wperilds_dtl a, giis_peril b
							  WHERE a.share_cd = '999'
								AND a.line_cd = p_line_cd
								AND a.dist_seq_no = c1.dist_seq_no
								AND a.dist_no = p_dist_no
								AND a.line_cd = b.line_cd
								AND a.peril_cd = b.peril_cd
								AND b.peril_type = 'A');
				END;
	
				v_rg_current_groups (v_rg_current_groups.COUNT).dist_spct := (v_tsi_allied_facul / v_tsi_allied ) * 100;
				v_rg_current_groups(v_rg_current_groups.COUNT).tsi_amt    := 0;
			 END IF;
			 --end robert 10.13.15 GENQA 5053 */
       END LOOP;                           
      
      /*v_errors := POPULATE_GROUP(rg_id);
      IF v_errors NOT IN (0, 1403) THEN
         MESSAGE('ORA-' || TO_CHAR(v_errors) || ' error encountered while populating ' ||
                 'record group ' || rg_name || '.', NO_ACKNOWLEDGE);
         RAISE FORM_TRIGGER_FAILURE;
      END IF;*/
      
      v_count := v_rg_current_groups.COUNT;
      
      IF v_count > 0 THEN
         p_facul_sw := 'Y';
      END IF;

      /* Delete previously inserted records
      ** that are no longer relevant to the
      ** current distribution record as such
      ** records no longer have a facultative
      ** share in it. */
      DELETE GIRI_WDISTFRPS a
       WHERE NOT EXISTS
            (SELECT 'A'
               FROM GIUW_WPOLICYDS_DTL
              WHERE share_cd    = 999
                AND dist_seq_no = a.dist_seq_no
                AND dist_no     = a.dist_no)
         AND dist_no = p_dist_no;

      /* Check whether the current distribution record has
      ** previously been negated.  If so, get its previous
      ** distribution number, as such shall be used in retrieving
      ** the value of the facultative DIST_TSI for the negated
      ** distribution prior to comparing its value with the
      ** same column of the current distribution record's facultative
      ** share. */
      FOR c1 IN (SELECT dist_no_old
                   FROM GIUW_DISTREL
                  WHERE policy_id   = p_policy_id
                    AND dist_no_new = p_dist_no)
      LOOP
        v_exist       := 'Y';
        v_old_dist_no := c1.dist_no_old;
        EXIT;
      END LOOP;
      IF v_exist = 'N' THEN
         RAISE NO_DATA_FOUND;
      END IF;

      /* Scan each of the DIST_SEQ_NO belonging to the
      ** previously negated distribution record, to check
      ** for the existence of a facultative share in each
      ** group. */
      FOR c1 IN (  SELECT dist_seq_no
                     FROM GIUW_POLICYDS
                    WHERE dist_no = v_old_dist_no
                 ORDER BY dist_seq_no DESC)
      LOOP

        /* Get the LINE_CD of the current 
        ** DIST_SEQ_NO for the negated distribution
        ** record to access its detail table
        ** more efficiently via primary key. */
        FOR c2 IN (SELECT line_cd
                     FROM GIUW_PERILDS
                    WHERE dist_seq_no = c1.dist_seq_no
                      AND dist_no     = v_old_dist_no)
        LOOP
          v_old_line_cd := c2.line_cd;
          EXIT;
        END LOOP;

        v_exist := 'N';

        /* Get the facultative DIST_TSI of the
        ** previously negated distribution record to 
        ** allow the possibility of comparing its
        ** value with the facultative DIST_TSI of
        ** its recreated distribution record. */
        FOR c3 IN (SELECT C1407.dist_tsi,
                          C1407.dist_prem,
                          C1407.dist_spct,
                          C1407.dist_spct1,
                          C1306.tsi_amt,
                          C1306.prem_amt,
                          C080.user_id,
                          B140.currency_cd,
                          B140.currency_rt
                     FROM GIUW_POLICYDS_DTL C1407,
                          GIUW_POLICYDS C1306,
                          GIUW_POL_DIST C080,
                          GIPI_INVOICE B140 
                    WHERE B140.item_grp     = C1306.item_grp
                      AND B140.policy_id    = C080.dist_no
                      AND C080.dist_no      = C1306.dist_no
                      AND C1306.dist_seq_no = C1407.dist_seq_no
                      AND C1306.dist_no     = C1407.dist_no
                      AND C1407.share_cd    = '999'
                      AND C1407.line_cd     = v_old_line_cd
                      AND C1407.dist_seq_no = c1.dist_seq_no
                      AND C1407.dist_no     = v_old_dist_no)
        LOOP
          v_exist           := 'Y';
          v_old_tsi_amt     := c3.tsi_amt;
          v_old_prem_amt    := c3.prem_amt;
          v_old_dist_tsi    := c3.dist_tsi;
          v_old_dist_prem   := c3.dist_prem;
          v_old_dist_spct   := c3.dist_spct;
          v_old_dist_spct1  := c3.dist_spct1;
          v_old_currency_cd := c3.currency_cd;
          v_old_currency_rt := c3.currency_rt;
          v_old_user_id     := c3.user_id;
          EXIT;
        END LOOP;

        /* If a facultative share in the negated distribution record exists
        ** for the current DIST_SEQ_NO processed then the procedure below
        ** shall be executed. */
        IF v_exist = 'Y' THEN
           IF v_count > 0 THEN
              v_rg_seq_no      := v_rg_current_groups(v_count).column_seq_no;
              
              WHILE v_rg_seq_no > c1.dist_seq_no
              LOOP
                v_new_tsi_amt     := v_rg_current_groups(v_count).tsi_amt;
                v_new_prem_amt    := v_rg_current_groups(v_count).prem_amt;
                v_new_dist_tsi    := v_rg_current_groups(v_count).dist_tsi;
                v_new_dist_prem   := v_rg_current_groups(v_count).dist_prem;
                v_new_dist_spct   := v_rg_current_groups(v_count).dist_spct;
                v_new_dist_spct1  := v_rg_current_groups(v_count).dist_spct1;
                v_new_currency_cd := v_rg_current_groups(v_count).currency_cd;
                v_new_currency_rt := v_rg_current_groups(v_count).currency_rt;
                v_new_user_id     := v_rg_current_groups(v_count).user_id;
                v_count           := v_count - 1;
                rec_count         :=  v_rg_current_groups.COUNT;
                
                IF rec_Count > v_count AND v_count <> 0 THEN
                      v_rg_current_groups.delete(v_count);
                END IF;
                
                v_frps_exist          := CHECK_FOR_EXISTING_FRPS(p_dist_no, v_rg_seq_no);
                IF NOT v_frps_exist THEN


                   /* Create a new record in table GIRI_WDISTFRPS in
                   ** accordance with the values taken in by table
                   ** GIUW_WPOLICYDS_DTL. */
                   GIRI_WDISTFRPS_PKG.create_new_wdistfrps_giuws016(p_dist_no         , v_rg_seq_no       , v_new_tsi_amt     , v_new_prem_amt    , 
                                                                    v_new_dist_tsi    , v_new_dist_prem   , v_new_dist_spct   , v_new_dist_spct1  , 
                                                                    v_new_currency_cd , v_new_currency_rt , v_new_user_id     , p_line_cd         , 
                                                                    p_subline_cd      , p_policy_id);
                ELSE

                   /* Update the amounts of the existing record
                   ** in table GIRI_WDISTFRPS. */
                   GIRI_WDISTFRPS_PKG.update_wdistfrps_giuws016(p_dist_no ,         v_rg_seq_no       , v_new_tsi_amt     , v_new_prem_amt    ,
                                                                v_new_dist_tsi    , v_new_dist_prem   , v_new_dist_spct   , v_new_dist_spct1  , 
                                                                v_new_currency_cd , v_new_currency_rt , v_new_user_id);

                END IF;
                IF v_count = 0 THEN
                   EXIT;
                END IF;            
                v_rg_seq_no      := v_rg_current_groups(v_count).column_seq_no;

              END LOOP;
              IF v_rg_seq_no < c1.dist_seq_no THEN

                 /* Updates table GIRI_BINDER of the negated
                 ** distribution record signifying that the
                 ** binder released has been reversed. */
                 GIRI_BINDER_PKG.update_reverse_date_giuws013(v_old_dist_no, c1.dist_seq_no);

              ELSIF v_rg_seq_no = c1.dist_seq_no THEN
                 v_new_tsi_amt     := v_rg_current_groups(v_count).tsi_amt;
                 v_new_prem_amt    := v_rg_current_groups(v_count).prem_amt;
                 v_new_dist_tsi    := v_rg_current_groups(v_count).dist_tsi;
                 v_new_dist_prem   := v_rg_current_groups(v_count).dist_prem;
                 v_new_dist_spct   := v_rg_current_groups(v_count).dist_spct;
                 v_new_dist_spct1  := v_rg_current_groups(v_count).dist_spct1;
                 v_new_currency_cd := v_rg_current_groups(v_count).currency_cd;
                 v_new_currency_rt := v_rg_current_groups(v_count).currency_rt;
                 v_new_user_id     := v_rg_current_groups(v_count).user_id;
                 rec_Count := v_rg_current_groups.COUNT;
                 IF rec_Count > v_count AND v_count <> 0 THEN          
                   v_rg_current_groups.DELETE(v_count);
                 END IF;
                 
                 IF v_new_tsi_amt     <> v_old_tsi_amt     OR
                    v_new_prem_amt    <> v_old_prem_amt    OR
                    v_new_dist_tsi    <> v_old_dist_tsi    OR
                    v_new_dist_prem   <> v_old_dist_prem   OR
                    v_new_dist_spct   <> v_old_dist_spct   OR
                    v_new_dist_spct1  <> v_old_dist_spct1  OR
                    v_new_currency_cd <> v_old_currency_cd OR
                    v_new_currency_rt <> v_old_currency_rt OR
                    v_new_user_id     <> v_old_user_id     THEN

                    /* Updates table GIRI_BINDER of the negated
                    ** distribution record signifying that the
                    ** binder released has been reversed. */
                    GIRI_BINDER_PKG.UPDATE_REVERSE_DATE_GIUWS013(v_old_dist_no, c1.dist_seq_no);

                    v_frps_exist := CHECK_FOR_EXISTING_FRPS(p_dist_no, c1.dist_seq_no);
                    IF NOT v_frps_exist THEN

                       -- GENERATE_FRPS_SEQ_NO;

                       /* Create a new record in table GIRI_WDISTFRPS in
                       ** accordance with the values taken in by tables
                       ** GIUW_WPOLICYDS_DTL of the current distribution
                       ** record, and GIRI_DISTFRPS of the previously negated
                       ** distribution record. */
                       GIRI_WDISTFRPS_PKG.create_wdistfrps_giuws016(p_dist_no         , p_line_cd         ,  v_old_dist_no    , 
                                                                    c1.dist_seq_no    , v_new_tsi_amt     ,  v_new_prem_amt    , 
                                                                    v_new_dist_tsi    , v_new_dist_prem   ,  v_new_dist_spct   , 
                                                                    v_new_dist_spct1  , v_new_currency_cd ,  v_new_currency_rt , 
                                                                    v_new_user_id);

                    ELSE

                       /* Update the amounts of the existing record
                       ** in table GIRI_WDISTFRPS. */
                       GIRI_WDISTFRPS_PKG.update_wdistfrps_giuws016(p_dist_no         , v_rg_seq_no       , v_new_tsi_amt     , v_new_prem_amt    ,
                                                                    v_new_dist_tsi    , v_new_dist_prem   , v_new_dist_spct   , v_new_dist_spct1  , 
                                                                    v_new_currency_cd , v_new_currency_rt , v_new_user_id);

                    END IF;
                 END IF;
              END IF;
           ELSE

              /* Updates table GIRI_BINDER of the negated
              ** distribution record signifying that the
              ** binder released has been reversed. */
              GIRI_BINDER_PKG.UPDATE_REVERSE_DATE_GIUWS013(v_old_dist_no, c1.dist_seq_no);
                        
                      FOR c IN (SELECT line_cd, frps_yy , frps_seq_no
                                 FROM GIRI_DISTFRPS
                               WHERE dist_seq_no = c1.dist_seq_no
                                 AND dist_no     = v_old_dist_no)
                      LOOP
                        FOR c2 IN (SELECT fnl_binder_id
                                     FROM GIRI_FRPS_RI
                                    WHERE line_cd     = c.line_cd
                                      AND frps_yy     = c.frps_yy
                                      AND frps_seq_no = c.frps_seq_no)
                        LOOP
                          UPDATE GIRI_BINDER
                              SET replaced_flag  = 'Y'
                            WHERE fnl_binder_id = c2.fnl_binder_id;
                           UPDATE GIRI_FRPS_RI
                              SET reverse_sw  = 'Y'
                            WHERE fnl_binder_id = c2.fnl_binder_id; 
                        END LOOP;
                      END LOOP;
           END IF;
         END IF;
      END LOOP;

      /* Process the remaining records
      ** in the list. */
      PROCESS_REMAINING_RECORDS;

      v_rg_current_groups.TRIM(v_rg_current_groups.COUNT);

    EXCEPTION
      WHEN NO_DATA_FOUND THEN

        /* Process the remaining records
        ** in the list. */    
        PROCESS_REMAINING_RECORDS;

        v_rg_current_groups.TRIM(v_rg_current_groups.COUNT);
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 5, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Executes WHEN-BUTTON-PRESSED Trigger of the Post Distribution 
**                 button in module GIUWS016.
*/
    
    PROCEDURE POST_DIST_GIUWS016(p_policy_id         IN     GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                                 p_dist_no           IN     GIUW_POL_DIST.dist_no%TYPE,
                                 p_par_id            IN     GIUW_POL_DIST.par_id%TYPE,
                                 p_line_cd           IN     GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                 p_subline_cd        IN     GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
                                 p_iss_cd            IN     GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE,
                                 p_issue_yy          IN     GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE,
                                 p_pol_seq_no        IN     GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE,
                                 p_renew_no          IN     GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE,
                                 p_par_type          IN     GIPI_POLBASIC_POL_DIST_V1.par_type%TYPE,
                                 p_pol_flag          IN     GIPI_POLBASIC_POL_DIST_V1.pol_flag%TYPE,
                                 p_eff_date          IN     GIPI_POLBASIC_POL_DIST_V1.eff_date%TYPE,
                                 p_batch_id          IN     GIUW_POL_DIST.batch_id%TYPE,
                                 p_dist_seq_no       IN     GIUW_POLICYDS_DTL.dist_seq_no%TYPE,
                                 p_message           OUT    VARCHAR2,
                                 p_workflow_msgr     OUT    VARCHAR2,
                                 p_v_facul_sw        OUT    VARCHAR2)
                                 
      IS
      
      v_cnt                NUMBER;
      v_eff_date           GIUW_POL_DIST.eff_date%TYPE;        
      v_expiry_date        GIUW_POL_DIST.expiry_date%TYPE;
      v_eff_date_trunc     GIUW_POL_DIST.expiry_date%TYPE;
          
    BEGIN
       p_v_facul_sw := 'N';

      /* BETH 03/14/2001 
      ** Check if records are existing in all distribution 
      ** tables, disallow POSTING of distribution if there are
      ** missing records in any of the distribution tables
      */
	  
	  giuw_pol_dist_final_pkg.pop_witem_peril_dtl_giuws016(p_dist_no);
	  
      FOR A IN ( SELECT count(dist_no) count
                   FROM GIUW_POL_DIST
                  WHERE policy_id = p_policy_id
                    AND negate_date IS NULL
                    AND dist_flag IN ('1','2','3') 
               )       
      LOOP
          v_cnt := a.count;
      END LOOP;             
      
      IF v_cnt > 1 THEN
         VALIDATE_EXISTING_DIST_REC2(p_policy_id,p_dist_no, p_message);
      ELSE    
         VALIDATE_EXISTING_DIST_REC(p_policy_id,p_dist_no, p_message);
      END IF;  
	  
	  giuw_pol_dist_pkg.adjust_all_wtables_giuws004(p_dist_no);
      giuw_pol_dist_pkg.compare_wdist_table_for_policy (p_dist_no, p_par_id); 
      
     --added by john 6.26.2014
      IF p_message IS NOT NULL
      THEN
         RETURN;
      END IF;
	  
      
      FOR i IN (SELECT TRUNC (eff_date) eff_date
                FROM gipi_polbasic
               WHERE policy_id = p_policy_id    --kenneth SR5307 05042016
      ) 
      LOOP
        v_eff_date_trunc := i.eff_date;
        EXIT;
      END LOOP;


      giuw_pol_dist_pkg.compare_wdist_table_for_policy(p_dist_no, p_par_id);

      /* Checks for a previously negated
      ** distribution record before creating
      ** or updating records from the RI
      ** table GIRI_WDISTFRPS. */
      GIUW_POL_DIST_FINAL_PKG.policy_negated_check_giuws016(p_v_facul_sw, p_policy_id, p_dist_no,
                                                            p_line_cd   , p_subline_cd);

      /* Remove existing records related to the
      ** current DIST_NO from certain distribution
      ** and RI master tables considering the fact
      ** that the current changes made were not yet
      ** posted to the master tables. */
      DELETE_DIST_MASTER_TABLES_2(p_dist_no);


      /* Post records retrieved from GIUW_WPOLICYDS 
      ** and GIUW_WPOLICYDS_DTL to tables GIUW_POLICYDS 
      ** and GIUW_POLICYDS_DTL. */
      GIUW_POLICYDS_PKG.post_wpolicyds_dtl_giuws016(p_dist_no, v_eff_date_trunc, p_message);

      /* Post records retrieved from GIUW_WITEMDS 
      ** and GIUW_WITEMDS_DTL to tables GIUW_ITEMDS 
      ** and GIUW_WITEMDS_DTL. */
      GIUW_WITEMDS_PKG.post_witemds_dtl_giuws016(p_dist_no);
     

      /* Post records retrieved from GIUW_WITEMPERILDS 
      ** and GIUW_WITEMPERILDS_DTL to tables GIUW_ITEMPERILDS 
      ** and GIUW_ITEMPERILDS_DTL. */
      GIUW_ITEMPERILDS_DTL_PKG.post_witemperilds_dtl_giuws016(p_dist_no);
      

      /* Post records retrieved from GIUW_WPERILDS 
      ** and GIUW_WPERILDS_DTL to tables GIUW_PERILDS 
      ** and GIUW_PERILDS_DTL. */
      GIUW_WPERILDS_DTL_PKG.post_wperilds_dtl_giuws016(p_dist_no);


      /* Remove the current distribution from the batch
      ** to which it originally belongs to. */
      IF p_batch_id IS NOT NULL THEN
         FOR c1 IN (SELECT rowid, batch_qty
                      FROM GIUW_DIST_BATCH
                     WHERE batch_id = p_batch_id)
         LOOP
           IF c1.batch_qty > 1 THEN
              UPDATE GIUW_DIST_BATCH
                 SET batch_qty = c1.batch_qty - 1
               WHERE rowid     = c1.rowid;
           ELSE
              DELETE GIUW_DIST_BATCH_DTL
               WHERE batch_id = p_batch_id;
              DELETE GIUW_DIST_BATCH
               WHERE rowid = c1.rowid;
           END IF;
           ---:c080.batch_id := NULL;
           EXIT;
         END LOOP;
      END IF;

         -- to delete workflow records of Final Distribution --
         DELETE_WORKFLOW_REC('Final Distribution','GIPIS055', NVL(GIIS_USERS_PKG.app_user, USER) ,p_policy_id);
         
      /* If a facultative share does not exist in any of
      ** the distribution records, records in the working
      ** tables will be deleted. */ 
      IF p_v_facul_sw = 'N' THEN
         UPDATE GIPI_POLBASIC
            SET dist_flag = 3
          WHERE policy_id = p_policy_id;
         
         UPDATE GIUW_POL_DIST
            SET dist_flag = 3,
                post_flag = 'O',
                post_date = SYSDATE
          WHERE policy_id = p_policy_id
            AND dist_no   = p_dist_no;

           
        /** to create workflow records of Policy/Endt.  Redistribution */        
           FOR a1 IN (SELECT DISTINCT claim_id
                        FROM GICL_CLAIMS b,
                             GIPI_POLBASIC a
                       WHERE b.line_cd = a.line_cd
                         AND b.subline_cd = a.subline_cd
                         AND b.iss_cd = a.iss_cd                     
                         AND b.issue_yy = a.issue_yy 
                         AND b.pol_seq_no = a.pol_seq_no
                         AND b.renew_no = a.renew_no
                         AND b.clm_stat_cd NOT IN ('CC','WD','DN')
                         AND a.policy_id = p_policy_id)
           LOOP    
             FOR c1 IN (SELECT b.userid, d.event_desc  
                            FROM GIIS_EVENTS_COLUMN c, GIIS_EVENT_MOD_USERS b, 
                                 GIIS_EVENT_MODULES a, GIIS_EVENTS d
                           WHERE 1=1
                           AND c.event_cd = a.event_cd
                           AND c.event_mod_cd = a.event_mod_cd
                           AND b.event_mod_cd = a.event_mod_cd
                           AND b.passing_userid = NVL(GIIS_USERS_PKG.app_user, USER)
                           AND a.module_id = 'GIUWS012'
                           AND a.event_cd = d.event_cd
                           AND UPPER(d.event_desc) = 'POLICY/ENDT.  REDISTRIBUTION')
             LOOP
               CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIUWS012', c1.userid, a1.claim_id, c1.event_desc||' '||GET_CLM_NO(a1.claim_id), p_message, p_workflow_msgr, NVL(GIIS_USERS_PKG.app_user, USER));
             END LOOP; 
           END LOOP;
           
         /* 11052000 BETH 
         **    posted policy distribution with eim_flag = '2' should be
         **    updated with eim_flag ='6' and undist_sw = 'Y' in eim_takeup_info
         **    table.
         */
         FOR A IN (SELECT '1'
                     FROM EIM_TAKEUP_INFO
                    WHERE policy_id = p_policy_id
                      AND eim_flag = '2')
         LOOP
              UPDATE EIM_TAKEUP_INFO 
                 SET eim_flag = '6',
                     undist_sw = 'Y'
            WHERE policy_id = p_policy_id;
           EXIT;
         END LOOP;
         
            /* mark jm 10.12.2009 UW-SPECS-2009-00067 starts here */
            /* for updating GICL_CLM_RESERVE.REDIST_SW */
            BEGIN           
                SELECT eff_date, expiry_date
                    INTO v_eff_date, v_expiry_date
                    FROM GIUW_POL_DIST
                 WHERE policy_id = p_policy_id
                     AND dist_no = p_dist_no;
            END;
        
            FOR a IN (SELECT claim_id, loss_date          
                        FROM GICL_CLAIMS
                     WHERE line_cd = p_line_cd
                         AND subline_cd = p_subline_cd
                         AND pol_iss_cd = p_iss_cd
                         AND issue_yy = p_issue_yy
                         AND pol_seq_no = p_pol_seq_no
                         AND renew_no = p_renew_no) 
            LOOP        
                FOR b IN (SELECT item_no, peril_cd  
                          FROM GIUW_WITEMPERILDS
                          WHERE dist_no = p_dist_no
                          AND dist_seq_no = p_dist_seq_no) 
                LOOP            
                    FOR c IN (SELECT 1
                              FROM GICL_CLM_RESERVE
                              WHERE claim_id = a.claim_id
                              AND item_no = b.item_no
                              AND peril_cd = b.peril_cd) 
                    LOOP                                    
                        IF p_v_facul_sw = 'N' AND (a.loss_date BETWEEN v_eff_date AND v_expiry_date) THEN                    
                            UPDATE GICL_CLM_RESERVE
                                 SET redist_sw = 'Y'
                             WHERE claim_id = a.claim_id
                               AND item_no = b.item_no
                               AND peril_cd = b.peril_cd;                
                        END IF;                
                    END LOOP;            
                END LOOP;            
            END LOOP;
            /* mark jm 10.12.09 UW-SPECS-2009-00067 ends here */
         
         /* Delete all data related to the current
         ** DIST_NO from the distribution and RI
         ** working tables. */
         --DELETE_DIST_WORKING_TABLES_2(p_dist_no, p_par_type, p_pol_flag);
		 DELETE_DIST_WORKING_TABLES(p_dist_no);
         
         /* A.R.C. 06.28.2005
         ** to delete workflow records of Undistributed policies awaiting claims */
         FOR c1 IN (SELECT claim_id
                    FROM GICL_CLAIMS
                    WHERE 1=1
                    AND line_cd = p_line_cd
                    AND subline_cd = p_subline_cd 
                    AND iss_cd = p_iss_cd
                    AND issue_yy = p_issue_yy
                    AND pol_seq_no = p_pol_seq_no
                    AND renew_no = p_renew_no)
         LOOP    
           DELETE_WORKFLOW_REC('Undistributed policies awaiting claims','GICLS010',NVL(GIIS_USERS_PKG.app_user, USER),c1.claim_id);  
         END LOOP;
        
             --added to delete the workflow facultative placement of GIUWS012 if not facul
           DELETE_WORKFLOW_REC('Facultative Placement','GIUWS012', NVL(GIIS_USERS_PKG.app_user, USER), p_policy_id);

      ELSIF p_v_facul_sw    = 'Y' THEN
         UPDATE GIPI_POLBASIC
            SET dist_flag = 2
          WHERE policy_id = p_policy_id;
         UPDATE GIUW_POL_DIST
            SET dist_flag = 2,
                post_flag = 'O'
          WHERE policy_id = p_policy_id
            AND dist_no   = p_dist_no;

        
        /** to create workflow records of Facultative Placement */        
         FOR c1 IN (SELECT b.userid, d.event_desc  
                        FROM GIIS_EVENTS_COLUMN c, GIIS_EVENT_MOD_USERS b, 
                             GIIS_EVENT_MODULES a, GIIS_EVENTS d
                       WHERE 1=1
                       AND c.event_cd = a.event_cd
                       AND c.event_mod_cd = a.event_mod_cd
                       AND b.event_mod_cd = a.event_mod_cd
                       --AND b.userid <> USER  --A.R.C. 01.24.2006
                       AND b.passing_userid = NVL(GIIS_USERS_PKG.app_user, USER)  --A.R.C. 01.24.2006
                       AND a.module_id = 'GIUWS012'
                       AND a.event_cd = d.event_cd
                       AND UPPER(d.event_desc) = 'FACULTATIVE PLACEMENT')
         LOOP
           CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIUWS012', c1.userid, p_policy_id, c1.event_desc||' '||GET_POLICY_NO(p_policy_id), p_message, p_workflow_msgr, NVL(GIIS_USERS_PKG.app_user, USER));
         END LOOP;
		 
		 FOR dist_no IN (SELECT dist_seq_no
                           FROM giuw_policyds
                          WHERE dist_no = p_dist_no)
         LOOP
            DELETE_WORKING_BINDER_TABLES(p_dist_no, dist_no.dist_seq_no);
         END LOOP;
         
      END IF;


        /* A.R.C. 08.16.2004
      ** to delete workflow records of Distribution Negation */
      DELETE_WORKFLOW_REC('Distribution Negation','GIUTS002',NVL(GIIS_USERS_PKG.app_user, USER),p_policy_id);
        
      /**to update replaced_flag of giri_binder if distribution has no facul*/
      GIRI_BINDER_PKG.update_giri_binder_giuws016(p_dist_no, p_par_id);
           
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 5, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : POST_FORMS_COMMIT Trigger from GIUWS016
*/

    PROCEDURE POST_FORMS_COMMIT_GIUWS016( p_dist_no      IN    GIUW_POL_DIST.dist_no%TYPE,
                                          p_policy_id    IN    GIUW_POL_DIST.policy_id%TYPE,
                                          p_batch_id     IN    GIUW_POL_DIST.batch_id%TYPE,
										  p_dist_seq_no  IN    GIUW_WPOLICYDS.dist_seq_no%TYPE
										  )
    IS

    BEGIN

      /* *************************** START OF FOR COMMIT ONLY ******************************** */
      /*  PROCEDURE IS ONLY PERFORMED DURING COMMIT PROCESSING WHERE THE VALUE OF THE VARIABLE
      **  VARIABLES.POST_SWIS EQUAL TO 'N'.                                                    */
      /* ************************************************************************************* */
	  
	  --giuw_pol_dist_pkg.adjust_wpolicyds_dtl (p_dist_no, p_dist_seq_no);

      /* Reset DIST_FLAG to undistributed as
      ** the current changes made were not yet
      ** posted to the master tables. */
      /*:c080.dist_flag      := '1';
      :c080.mean_dist_flag := 'Undistributed';*/
      UPDATE giuw_pol_dist
         SET dist_flag = '1',
             post_flag = 'O',
             batch_id  = NULL
       WHERE policy_id = p_policy_id
         AND dist_no   = p_dist_no;

      /* Remove the current distribution from the batch
      ** to which it originally belongs to. */
      IF p_batch_id IS NOT NULL THEN
         FOR c1 IN (SELECT rowid, batch_qty
                      FROM GIUW_DIST_BATCH
                     WHERE batch_id = p_batch_id)
         LOOP
           IF c1.batch_qty > 1 THEN
              UPDATE GIUW_DIST_BATCH
                 SET batch_qty = c1.batch_qty - 1
               WHERE rowid     = c1.rowid;
           ELSE
              DELETE GIUW_DIST_BATCH_DTL
               WHERE batch_id = p_batch_id;
              DELETE GIUW_DIST_BATCH
               WHERE rowid = c1.rowid;
           END IF;
           --:c080.batch_id := NULL;
           EXIT;
         END LOOP;
      END IF;

      UPDATE GIPI_POLBASIC
         SET dist_flag = '1'
       WHERE policy_id = p_policy_id;

      /* Remove existing records related to the
      ** current DIST_NO from certain distribution
      ** and RI master tables considering the fact
      ** that the current changes made were not yet
      ** posted to the master tables. */
      DELETE_DIST_MASTER_TABLES_2(p_dist_no);

      /* Recreate records of table GIUW_WITEMDS_DTL, 
      ** GIUW_WITEMPERILDS_DTL and GIUW_WPERILDS_DTL based
      ** on the data inserted to table GIUW_WPOLICYDS_DTL. */
      GIUW_POL_DIST_FINAL_PKG.pop_witem_peril_dtl_giuws016(p_dist_no);

      /* Adjust computational floats to equalize the amounts
      ** attained by the master tables with that of its detail
      ** tables.
      ** Tables involved:  GIUW_WITEMDS      - GIUW_WITEMDS_DTL
      **                   GIUW_WITEMPERILDS - GIUW_WITEMPERILDS_DTL
      **                   GIUW_WPERILDS     - GIUW_WPERILDS_DTL */
       GIUW_POL_DIST_FINAL_PKG.adj_net_ret_imperfection_016(p_dist_no);

      /* Sets the distribution flag of table GIUW_WPOLICYDS to
      ** 2 or what used to be 2, signifying that all records
      ** have already been properly distributed and that such
      ** records are ready for posting.
      ** NOTE:  The update was made across all DIST_SEQ_NO's
      **        because the current system does not support
      **        partial distribution.  This means that if a
      **        particular DIST_SEQ_NO has already been 
      **        distributed, all subsequent DIST_SEQ_NO's 
      **        must also be distributed. */
      UPDATE GIUW_WPOLICYDS
         SET dist_flag =  '2'
       WHERE dist_no   = p_dist_no;

    END;

    PROCEDURE DELETE_DIST_WORKING_TABLES_017(p_dist_no  giuw_pol_dist.dist_no%TYPE) IS
      v_dist_no            giuw_pol_dist.dist_no%TYPE;
    BEGIN
      v_dist_no := p_dist_no;
      DELETE giuw_wperilds_dtl
       WHERE dist_no = v_dist_no;
      DELETE giuw_wperilds --added by steven 06.24.2014
       WHERE dist_no = v_dist_no;
      DELETE giuw_witemperilds_dtl
       WHERE dist_no = v_dist_no;
      DELETE giuw_witemperilds
       WHERE dist_no = v_dist_no;
      DELETE giuw_witemds_dtl
       WHERE dist_no = v_dist_no;
      DELETE giuw_witemds
       WHERE dist_no = v_dist_no;
      DELETE giuw_wpolicyds_dtl
       WHERE dist_no = v_dist_no;
      FOR c1 IN (SELECT frps_yy, frps_seq_no, line_cd
                   FROM giri_wdistfrps
                  WHERE dist_no = v_dist_no)
      LOOP
        FOR c2 IN (SELECT pre_binder_id
                     FROM giri_wfrps_ri
                    WHERE frps_yy     = c1.frps_yy 
                      AND frps_seq_no = c1.frps_seq_no
                      AND line_cd     = c1.line_cd)--added line_cd edgar 10/09/2014 
        LOOP
          DELETE giri_wbinder_peril
           WHERE pre_binder_id = c2.pre_binder_id; 
          DELETE giri_wbinder
           WHERE pre_binder_id = c2.pre_binder_id;
        END LOOP;
        DELETE giri_wfrperil
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no
           AND line_cd         = c1.line_cd;
        DELETE giri_wfrps_ri
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no
           AND line_cd         = c1.line_cd;
        DELETE giri_wfrps_peril_grp --added deletion of giri_wfrps_peril_grp edgar 10/09/2014
         WHERE frps_yy = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no
           AND line_cd = c1.line_cd;
      END LOOP;
      DELETE giri_wdistfrps
       WHERE dist_no = v_dist_no;
      DELETE giuw_wpolicyds --added by steven 06.24.2014
       WHERE dist_no = v_dist_no;
    END;

    PROCEDURE CREATE_GRP_DFLT_WPERILDS_017
             (p_dist_no            IN giuw_wperilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no        IN giuw_wperilds_dtl.dist_seq_no%TYPE  ,
              p_line_cd            IN giuw_wperilds_dtl.line_cd%TYPE      ,
              p_peril_cd        IN giuw_wperilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi        IN giuw_wperilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem        IN giuw_wperilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi    IN giuw_wperilds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count        IN NUMBER,
              p_pol_flag        IN gipi_wpolbas.pol_flag%TYPE,
              p_par_type        IN gipi_parlist.par_type%TYPE,
              p_par_id          IN gipi_wpolbas.par_id%TYPE,
              p_policy_id       IN gipi_polbasic.policy_id%TYPE
              ) IS
      --rg_id                                RECORDGROUP;
      rg_name                            VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_col2                            VARCHAR2(40) := rg_name || '.share_cd';
      rg_col7                            VARCHAR2(40) := rg_name || '.true_pct';
      v_selection_count                    NUMBER;
      v_row                                NUMBER;
      v_dist_spct                        giuw_wperilds_dtl.dist_spct%TYPE;
      v_dist_tsi                        giuw_wperilds_dtl.dist_tsi%TYPE;
      v_dist_prem                        giuw_wperilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi                    giuw_wperilds_dtl.ann_dist_tsi%TYPE;
      v_share_cd                        giis_dist_share.share_cd%TYPE;
      v_sum_dist_tsi                    giuw_wperilds_dtl.dist_tsi%TYPE     := 0;
      v_sum_dist_spct                    giuw_wperilds_dtl.dist_spct%TYPE    := 0;
      v_sum_dist_prem                    giuw_wperilds_dtl.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi                giuw_wperilds_dtl.ann_dist_tsi%TYPE := 0;

      PROCEDURE INSERT_TO_WPERILDS_DTL IS
      BEGIN
        INSERT INTO  giuw_wperilds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , peril_cd             , dist_spct1)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_peril_cd    , v_dist_spct);
      END;

    BEGIN
      IF p_rg_count = 0 THEN
         IF p_pol_flag = '2' THEN -- renewal
                 FOR c IN (
                   SELECT share_cd, dist_spct
                     FROM giuw_perilds_dtl a
                    WHERE 1 = 1
                      AND a.peril_cd = p_peril_cd
                      AND a.dist_seq_no = p_dist_seq_no
                        AND dist_no = ( SELECT max(dist_no) 
                                                                FROM GIUW_POL_DIST 
                                                                    WHERE policy_id = ( SELECT MAX(old_policy_id) 
                                                                                          FROM GIPI_POLNREP
                                                                                         WHERE par_id = p_par_id
                                                                                           AND ren_rep_sw = '1'
                                                                                           AND new_policy_id = (SELECT policy_id
                                                                                                                  FROM gipi_polbasic
                                                                                                                 WHERE pol_flag <> '5'
                                                                                                                   AND policy_id = p_policy_id))))
                     LOOP         
                   v_share_cd     := c.share_cd;
                   v_dist_spct    := c.dist_spct;
                   v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                   v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                   v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                   v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                   v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                   v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
                   INSERT_TO_WPERILDS_DTL;
                     END LOOP;
         ELSIF p_par_type = 'E' THEN
                     FOR c IN (
                   SELECT share_cd, dist_spct
                             FROM giuw_perilds_dtl a
                            WHERE 1 = 1
                      AND a.peril_cd         = p_peril_cd
                      AND a.dist_seq_no = p_dist_seq_no
                        AND dist_no = ( SELECT max(dist_no) 
                                                                FROM GIUW_POL_DIST 
                                                                 WHERE par_id = ( SELECT par_id
                                                                                        FROM GIPI_POLBASIC
                                                                                                 WHERE endt_seq_no = 0
                                                                                                   AND (line_cd,         subline_cd, 
                                                                                                                    iss_cd,          issue_yy, 
                                                                                                                    pol_seq_no,    renew_no) = (SELECT line_cd,         subline_cd, 
                                                                                                                                                                                    iss_cd,         issue_yy, 
                                                                                                                                                                                    pol_seq_no, renew_no
                                                                                                                                                                     FROM GIPI_POLBASIC
                                                                                                                                                                    WHERE policy_id = p_policy_id))))
                     LOOP         
                   v_share_cd             := c.share_cd;
                   v_dist_spct            := c.dist_spct;
                   v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                   v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                   v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                   v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                   v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                   v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);               
                   INSERT_TO_WPERILDS_DTL;
                     END LOOP;            
         ELSE
                  /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_dist_tsi;
                 v_dist_prem    := p_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WPERILDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;             
         END IF;  
      ELSE
        NULL;
      END IF;   
    END;
    
    PROCEDURE CREATE_GRP_DFLT_WITEMPERILDS17
             (p_dist_no                IN giuw_witemperilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no            IN giuw_witemperilds_dtl.dist_seq_no%TYPE  ,
              p_item_no                IN giuw_witemperilds_dtl.item_no%TYPE      ,
              p_line_cd                IN giuw_witemperilds_dtl.line_cd%TYPE      ,
              p_peril_cd            IN giuw_witemperilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi            IN giuw_witemperilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem            IN giuw_witemperilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi        IN giuw_witemperilds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count            IN NUMBER,
              p_pol_flag            IN gipi_wpolbas.pol_flag%TYPE,
              p_par_type            IN gipi_parlist.par_type%TYPE,
              p_par_id              IN gipi_wpolbas.par_id%TYPE,
              p_policy_id           IN gipi_polbasic.policy_id%TYPE
              ) IS
      --rg_id                            RECORDGROUP;
      rg_name                        VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_col2                        VARCHAR2(40) := rg_name || '.share_cd';
      rg_col7                        VARCHAR2(40) := rg_name || '.true_pct';
      v_selection_count                NUMBER;
      v_row                            NUMBER;
      v_dist_spct                    giuw_witemperilds_dtl.dist_spct%TYPE;
      v_dist_tsi                    giuw_witemperilds_dtl.dist_tsi%TYPE;
      v_dist_prem                    giuw_witemperilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi                giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
      v_share_cd                    giis_dist_share.share_cd%TYPE;
      v_sum_dist_tsi                giuw_witemperilds_dtl.dist_tsi%TYPE     := 0;
      v_sum_dist_spct                giuw_witemperilds_dtl.dist_spct%TYPE    := 0;
      v_sum_dist_prem                giuw_witemperilds_dtl.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi            giuw_witemperilds_dtl.ann_dist_tsi%TYPE := 0;

      PROCEDURE INSERT_TO_WITEMPERILDS_DTL IS
      BEGIN
        INSERT INTO  giuw_witemperilds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , item_no       , peril_cd          ,
                     dist_spct1)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_item_no     , p_peril_cd      ,
                     v_dist_spct);
      END;
    BEGIN
      IF p_rg_count = 0 THEN
        -- rollie 27may2005 vincent's birthday
        -- see procedure create_items for other info
         
         IF p_pol_flag = '2' THEN -- renewal
                 ---message('pol flag 2');pause;
                 FOR c IN (
                   SELECT DISTINCT share_cd, dist_spct
                     FROM giuw_perilds_dtl a
                    WHERE 1 = 1
                      AND a.peril_cd = p_peril_cd
                      AND a.dist_seq_no = p_dist_seq_no
                        AND dist_no = ( SELECT max(dist_no) 
                                                                FROM GIUW_POL_DIST 
                                                                    WHERE policy_id = ( SELECT MAX(old_policy_id) 
                                                                                          FROM GIPI_POLNREP
                                                                                         WHERE par_id = p_par_id
                                                                                           AND ren_rep_sw = '1'
                                                                                           AND new_policy_id = (SELECT policy_id
                                                                                                                  FROM gipi_polbasic
                                                                                                                 WHERE pol_flag <> '5'
                                                                                                                   AND policy_id = p_policy_id))))
                 LOOP         
                   v_share_cd     := c.share_cd;
                   v_dist_spct    := c.dist_spct;
                   v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                   v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                   v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                   v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                   v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                   v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
                   INSERT_TO_WITEMPERILDS_DTL;
                 END LOOP;
             ELSIF p_par_type = 'E' THEN
                     FOR c IN (
                   SELECT DISTINCT share_cd, dist_spct
                             FROM giuw_perilds_dtl a
                            WHERE 1 = 1
                      AND a.peril_cd         = p_peril_cd
                      AND a.dist_seq_no = p_dist_seq_no
                        AND dist_no = ( SELECT max(dist_no) 
                                                                FROM GIUW_POL_DIST 
                                                                 WHERE par_id = ( SELECT par_id
                                                                                        FROM GIPI_POLBASIC
                                                                                                 WHERE endt_seq_no = 0
                                                                                                   AND (line_cd,         subline_cd, 
                                                                                                                    iss_cd,          issue_yy, 
                                                                                                                    pol_seq_no,    renew_no) = (SELECT line_cd,         subline_cd, 
                                                                                                                                                                                    iss_cd,         issue_yy, 
                                                                                                                                                                                    pol_seq_no, renew_no
                                                                                                                                                                     FROM GIPI_POLBASIC
                                                                                                                                                                    WHERE policy_id = p_policy_id))))
                     LOOP         
                   v_share_cd             := c.share_cd;
                   v_dist_spct            := c.dist_spct;
                   v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                   v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                   v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                   v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                   v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                   v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);               
                   INSERT_TO_WITEMPERILDS_DTL;
                     END LOOP;        
            
             ELSE
                    /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_dist_tsi;
                 v_dist_prem    := p_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WITEMPERILDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;             
         END IF;         
      ELSE
        NULL;
      END IF;   
    END;    

    PROCEDURE CREATE_GRP_DFLT_WITEMDS_017
             (p_dist_no            IN giuw_witemds_dtl.dist_no%TYPE      ,
              p_dist_seq_no        IN giuw_witemds_dtl.dist_seq_no%TYPE  ,
              p_item_no            IN giuw_witemds_dtl.item_no%TYPE      ,
              p_line_cd            IN giuw_witemds_dtl.line_cd%TYPE      ,
              p_dist_tsi        IN giuw_witemds_dtl.dist_tsi%TYPE     ,
              p_dist_prem        IN giuw_witemds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi    IN giuw_witemds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count        IN NUMBER,
              p_pol_flag        IN gipi_wpolbas.pol_flag%TYPE,
              p_par_type        IN gipi_parlist.par_type%TYPE,
              p_policy_id       IN gipi_polbasic.policy_id%TYPE
              ) IS

      --rg_id                        RECORDGROUP;
      rg_name                       VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_col2                    VARCHAR2(40) := rg_name || '.share_cd';
      rg_col7                    VARCHAR2(40) := rg_name || '.true_pct';
      v_selection_count            NUMBER;
      v_row                        NUMBER;
      v_dist_spct                giuw_witemds_dtl.dist_spct%TYPE;
      v_dist_tsi                giuw_witemds_dtl.dist_tsi%TYPE;
      v_dist_prem                giuw_witemds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi              giuw_witemds_dtl.ann_dist_tsi%TYPE;
      v_share_cd                giis_dist_share.share_cd%TYPE;
      v_sum_dist_tsi               giuw_witemds_dtl.dist_tsi%TYPE     := 0;
      v_sum_dist_spct            giuw_witemds_dtl.dist_spct%TYPE    := 0;
      v_sum_dist_prem            giuw_witemds_dtl.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi        giuw_witemds_dtl.ann_dist_tsi%TYPE := 0;


      PROCEDURE INSERT_TO_WITEMDS_DTL IS
      BEGIN
        INSERT INTO  giuw_witemds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , item_no         , dist_spct1)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_item_no     , v_dist_spct);
      END;
    BEGIN
      IF p_rg_count = 0 THEN
         -- see procedure create_items for other info
             IF p_pol_flag = '2' OR p_par_type='E' THEN -- renewal or endt
                FOR c IN (
                        SELECT sum(decode(c.peril_type,'B',tsi_amt*(dist_spct/100),0)) dist_tsi, 
                                   sum(dist_prem) dist_prem,
                               sum(decode(c.peril_type,'B',ann_tsi_amt*(dist_spct/100),0)) ann_dist_tsi,a.share_cd
                    FROM giuw_wperilds_dtl a , giis_peril c,gipi_itmperil b
                   WHERE a.dist_seq_no = p_dist_seq_no        
                         AND a.peril_cd    = c.peril_cd
                         AND c.line_cd     = p_line_cd
                         AND a.line_cd     = c.line_cd
                         AND b.policy_id   = p_policy_id
                         AND b.item_no     = p_item_no                      
                         AND a.peril_cd    = b.peril_cd
                         AND a.line_cd     = b.line_cd
                         AND a.dist_no     = p_dist_no                                                        
                       GROUP BY a.share_cd)                      
                     LOOP         
                   --msg_alert('item '||p_item_no||' - '||c.share_cd||' - '||c.dist_tsi||' - '||c.dist_prem||' - '||c.ann_dist_tsi,'I',FALSE); 
                   v_share_cd     := c.share_cd;
                   IF p_dist_tsi = 0 THEN
                      v_dist_spct := 0;
                   ELSE
                      v_dist_spct    := ROUND((c.dist_tsi/p_dist_tsi)*100,14);
                   END IF;
                   
                   --v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                   --v_dist_prem        := ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                   --v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                   v_dist_tsi         := ROUND(((p_dist_tsi     * v_dist_spct)/ 100), 2);
                   v_dist_prem        := ROUND(((p_dist_prem    * v_dist_spct)/ 100), 2);
                   v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * v_dist_spct)/ 100), 2);
                   v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                   v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                   v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
                   --v_dist_tsi         := c.dist_tsi;
                   --v_dist_prem        := c.dist_prem;
                   --v_ann_dist_tsi     := c.ann_dist_tsi;
                   --v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                   --v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);                              
                   --msg_alert('item '||p_item_no||' - '||c.share_cd||' - '||v_dist_tsi||' - '||v_dist_prem||' - '||v_ann_dist_tsi,'I',FALSE); 
                   INSERT_TO_WITEMDS_DTL;
                     END LOOP;
             ELSE
                    /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_dist_tsi;
                 v_dist_prem    := p_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WITEMDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;             
         END IF;  

      ELSE
         NULL;
      END IF;   
    END;

    PROCEDURE update_witemds (
        p_dist_no         giuw_witemperilds_dtl.dist_no%type,
        p_dist_seq_no giuw_witemperilds_dtl.dist_no%type
        )IS
    BEGIN
      FOR a IN (
        SELECT 'giuw_witemperilds_dtl',
                     sum(decode(a.peril_type,'B',dist_tsi,0))          tsi_amt, 
                     sum(dist_prem)      prem_amt,     
                     sum(decode(a.peril_type,'B',ann_dist_tsi,0)) ann_tsi_amt,              
                     share_cd, 
                     item_no 
          FROM giuw_witemperilds_dtl b, giis_peril a
         WHERE dist_no    = p_dist_no
           AND dist_seq_no= p_dist_seq_no 
           AND a.line_cd  = b.line_cd
           AND a.peril_cd = b.peril_cd
         GROUP BY share_cd,item_no)
      LOOP
        FOR b IN (
          SELECT 'giuw_witemds_dtl',
                     sum(dist_tsi) tsi_amt, 
                     sum(dist_prem) prem_amt, 
                     sum(ann_dist_tsi) ann_tsi_amt, 
                     share_cd, 
                     item_no
              FROM giuw_witemds_dtl
           WHERE dist_no = p_dist_no
             AND dist_seq_no= p_dist_seq_no  
             AND item_no = a.item_no
             AND share_cd= a.share_cd
           GROUP BY share_cd,item_no)
         LOOP
             IF a.tsi_amt <> b.tsi_amt OR 
                  a.prem_amt <> b.prem_amt OR
                  a.ann_tsi_amt <> b.ann_tsi_amt THEN               
                  UPDATE giuw_witemds_dtl
                   SET dist_tsi  = a.tsi_amt,
                       dist_prem = a.prem_amt--,
                       --ann_dist_tsi = a.ann_tsi_amt
                 WHERE item_no   = a.item_no
                   AND share_cd  = a.share_cd
                   AND dist_no   = p_dist_no
                   AND dist_seq_no= p_dist_seq_no ;
             END IF;          
         END LOOP;     
      END LOOP;  
    END;

    /* NOTE:  default_type 1 - Use AMOUNTS to create the default distribution records
    **                     2 - Use PERCENTAGE to create the default distribution records. */
    PROCEDURE CREATE_GRP_DFLT_WPOLICYDS_017
             (p_dist_no                IN giuw_wpolicyds_dtl.dist_no%TYPE      ,
              p_dist_seq_no            IN giuw_wpolicyds_dtl.dist_seq_no%TYPE  ,
              p_line_cd                IN giuw_wpolicyds_dtl.line_cd%TYPE      ,
              p_dist_tsi            IN giuw_wpolicyds_dtl.dist_tsi%TYPE     ,
              p_dist_prem            IN giuw_wpolicyds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi        IN giuw_wpolicyds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count            IN OUT NUMBER                           ,
              p_default_type        IN giis_default_dist.default_type%TYPE  ,
              p_currency_rt         IN gipi_witem.currency_rt%TYPE          ,
              p_par_id              IN gipi_parlist.par_id%TYPE             ,
              p_item_grp            IN gipi_witem.item_grp%TYPE             ,
              p_pol_flag            IN gipi_wpolbas.pol_flag%TYPE           ,
              p_par_type            IN gipi_parlist.par_type%TYPE
              ) IS
      --rg_id                    RECORDGROUP;
      rg_name                    VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_col1                    VARCHAR2(40) := rg_name || '.line_cd';
      rg_col2                    VARCHAR2(40) := rg_name || '.share_cd';
      rg_col3                    VARCHAR2(40) := rg_name || '.share_pct';
      rg_col4                    VARCHAR2(40) := rg_name || '.share_amt1';
      rg_col5                    VARCHAR2(40) := rg_name || '.peril_cd';
      rg_col6                    VARCHAR2(40) := rg_name || '.share_amt2';
      rg_col7                    VARCHAR2(40) := rg_name || '.true_pct';
      v_remaining_tsi            NUMBER       := p_dist_tsi * p_currency_rt;
      v_share_amt                giis_default_dist_group.share_amt1%TYPE;
      v_peril_cd                giis_default_dist_group.peril_cd%TYPE;
      v_prev_peril_cd            giis_default_dist_group.peril_cd%TYPE;
      v_dist_spct                giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_dist_tsi                giuw_wpolicyds_dtl.dist_tsi%TYPE;
      v_dist_prem                giuw_wpolicyds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi            giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
      v_sum_dist_tsi            giuw_wpolicyds_dtl.dist_tsi%TYPE     := 0;
      v_sum_dist_spct            giuw_wpolicyds_dtl.dist_spct%TYPE    := 0;
      v_sum_dist_prem            giuw_wpolicyds_dtl.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi        giuw_wpolicyds_dtl.ann_dist_tsi%TYPE := 0;
      v_share_cd                giis_dist_share.share_cd%TYPE;
      v_use_share_amt2          VARCHAR2(1) := 'N';
      v_dist_spct_limit            NUMBER;

      PROCEDURE INSERT_TO_WPOLICYDS_DTL IS
      BEGIN
        INSERT INTO  giuw_wpolicyds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp     , dist_spct1)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1             , v_dist_spct);
      END;

    BEGIN
      IF p_rg_count = 0 THEN
        -- rollie 15Nov2005 last day of mr adrian ortega in CPI
        -- see procedure create_items for other info
         IF p_pol_flag = '2' OR p_par_type = 'E' THEN -- renewal
                 FOR c IN (
                   SELECT sum(dist_tsi)     dist_tsi, 
                          sum(dist_prem)    dist_prem,
                              sum(ann_dist_tsi) ann_dist_tsi,
                              a.share_cd
                     FROM giuw_witemds_dtl a
                    WHERE a.dist_seq_no = p_dist_seq_no        
                      AND a.dist_no     = p_dist_no                    
                        GROUP BY a.share_cd)
                     LOOP         
                   v_share_cd     := c.share_cd;
                   IF p_dist_tsi = 0 THEN
                      v_dist_spct := 0;
                   ELSE
                      v_dist_spct    := ROUND((c.dist_tsi/p_dist_tsi)*100,14);
                   END IF;
                   v_dist_tsi         := c.dist_tsi;
                   v_dist_prem        := c.dist_prem;
                   v_ann_dist_tsi     := c.ann_dist_tsi;
                   v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                   v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                   v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
                   INSERT_TO_WPOLICYDS_DTL;
                     END LOOP;
             
             ELSE
                    /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_dist_tsi;
                 v_dist_prem    := p_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WPOLICYDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;             
         END IF;  

      ELSE
         NULL;
      END IF;   
    END;

    PROCEDURE inherit_dist_pct (
        p_dist_no               NUMBER,
        p_par_type              gipi_parlist.par_type%TYPE,
        p_par_id                gipi_parlist.par_id%TYPE,
        p_policy_id             gipi_polbasic.policy_id%TYPE
        ) IS
    BEGIN 
      IF p_par_type='E' THEN
              FOR a IN (
                SELECT dist_no, item_no, share_cd
                  FROM giuw_witemds_dtl
                 WHERE dist_spct = 0
                   AND (dist_prem = 0 OR dist_tsi = 0)
                   AND dist_no = p_dist_no)
              LOOP
                --msg_alert('item','I',FALSE);
                FOR b IN (
                  SELECT dist_spct
                    FROM giuw_itemds_dtl 
                   WHERE item_no  = a.item_no
                     AND share_cd = a.share_cd
                     AND dist_no = ( SELECT MAX(dist_no) 
                                                             FROM GIUW_POL_DIST 
                                                              WHERE par_id = ( SELECT MAX(par_id)
                                                                                     FROM GIPI_POLBASIC
                                                                                                WHERE 1 = 1
                                                                                                    AND (endt_seq_no) <> (SELECT endt_seq_no
                                                                                                                                                 FROM GIPI_POLBASIC
                                                                                                                                                WHERE policy_id = p_policy_id)
                                                                                                    AND (line_cd,         subline_cd, 
                                                                                                                 iss_cd,          issue_yy, 
                                                                                                                 pol_seq_no,    renew_no) = (SELECT line_cd,         subline_cd, 
                                                                                                                                                                                    iss_cd,         issue_yy, 
                                                                                                                                                                                    pol_seq_no, renew_no
                                                                                                                                                                     FROM GIPI_POLBASIC
                                                                                                                                                                    WHERE policy_id = p_policy_id))))
                    LOOP
                        UPDATE giuw_witemds_dtl
                           SET dist_spct = b.dist_spct
                         WHERE dist_no   = a.dist_no
                           AND share_cd  = a.share_cd
                           AND item_no   = a.item_no;
                        --msg_alert('update item '||a.item_no||' share code is '||a.share_cd,'I',FALSE);
                    END LOOP;        
              END LOOP;
              
              FOR a IN (
                SELECT dist_no, share_cd
                  FROM giuw_wpolicyds_dtl
                 WHERE dist_spct = 0
                   AND (dist_prem = 0 OR dist_tsi = 0)
                   AND dist_no = p_dist_no)
              LOOP
                FOR b IN (
                  SELECT dist_spct
                    FROM giuw_policyds_dtl 
                   WHERE 1 = 1
                     AND share_cd = a.share_cd
                     AND dist_no  = (SELECT MAX(dist_no) 
                                                             FROM GIUW_POL_DIST 
                                                              WHERE par_id = ( SELECT MAX(par_id)
                                                                                     FROM GIPI_POLBASIC
                                                                                                WHERE 1 = 1
                                                                                                    AND (endt_seq_no) <> (SELECT endt_seq_no
                                                                                                                                                 FROM GIPI_POLBASIC
                                                                                                                                                WHERE policy_id = p_policy_id)
                                                                                                    AND (line_cd,         subline_cd, 
                                                                                                                 iss_cd,          issue_yy, 
                                                                                                                 pol_seq_no,    renew_no) = (SELECT line_cd,         subline_cd, 
                                                                                                                                                                                    iss_cd,         issue_yy, 
                                                                                                                                                                                    pol_seq_no, renew_no
                                                                                                                                                                     FROM GIPI_POLBASIC
                                                                                                                                                                    WHERE policy_id = p_policy_id))))
                    LOOP
                        UPDATE giuw_wpolicyds_dtl
                           SET dist_spct = b.dist_spct
                         WHERE share_cd  = a.share_cd
                           AND dist_no   = a.dist_no;
                    --    msg_alert('update policy '||a.dist_no||' share code is '||a.share_cd,'I',FALSE);
                    END LOOP;        
              END LOOP;
      ELSE -- renewal
          FOR a IN (
                SELECT dist_no, item_no, share_cd
                  FROM giuw_witemds_dtl
                 WHERE dist_spct = 0
                   AND (dist_prem = 0 OR dist_tsi = 0)
                   AND dist_no = p_dist_no)
              LOOP
                FOR b IN (
                  SELECT dist_spct
                    FROM giuw_itemds_dtl 
                   WHERE item_no  = a.item_no
                     AND share_cd = a.share_cd
                     AND dist_no = (SELECT max(dist_no) 
                                                                FROM GIUW_POL_DIST 
                                                                    WHERE policy_id = ( SELECT old_policy_id 
                                                                                                    FROM GIPI_POLNREP
                                                                                                         WHERE par_id = p_par_id)))
                    LOOP
                        UPDATE giuw_witemds_dtl
                           SET dist_spct = b.dist_spct
                         WHERE dist_no   = a.dist_no
                           AND share_cd  = a.share_cd
                           AND item_no   = a.item_no;
                        --msg_alert('update item '||a.item_no||' share code is '||a.share_cd,'I',FALSE);
                    END LOOP;        
              END LOOP;
              
              FOR a IN (
                SELECT dist_no, share_cd
                  FROM giuw_wpolicyds_dtl
                 WHERE dist_spct = 0
                   AND (dist_prem = 0 OR dist_tsi = 0)
                   AND dist_no = p_dist_no)
              LOOP
                FOR b IN (
                  SELECT dist_spct
                    FROM giuw_policyds_dtl 
                   WHERE 1 = 1
                     AND share_cd = a.share_cd
                     AND dist_no  =(SELECT max(dist_no) 
                                                                FROM GIUW_POL_DIST 
                                                                    WHERE policy_id = ( SELECT old_policy_id 
                                                                                                    FROM GIPI_POLNREP
                                                                                                         WHERE par_id = p_par_id)))
                    LOOP
                        UPDATE giuw_wpolicyds_dtl
                           SET dist_spct = b.dist_spct
                         WHERE share_cd  = a.share_cd
                           AND dist_no   = a.dist_no;
                        --msg_alert('update policy '||a.dist_no||' share code is '||a.share_cd,'I',FALSE);
                    END LOOP;        
              END LOOP;
      END IF;  
    END;

    PROCEDURE CREATE_GRP_DFLT_DIST_017(
            p_dist_no              IN giuw_wpolicyds.dist_no%TYPE,
            p_dist_seq_no       IN giuw_wpolicyds.dist_seq_no%TYPE,
            p_dist_flag         IN giuw_wpolicyds.dist_flag%TYPE,
            p_policy_tsi        IN giuw_wpolicyds.tsi_amt%TYPE,
            p_policy_premium    IN giuw_wpolicyds.prem_amt%TYPE,
            p_policy_ann_tsi    IN giuw_wpolicyds.ann_tsi_amt%TYPE,
            p_item_grp          IN giuw_wpolicyds.item_grp%TYPE,
            p_line_cd           IN giis_line.line_cd%TYPE,
            p_rg_count          IN OUT NUMBER,
            p_default_type      IN giis_default_dist.default_type%TYPE,
            p_currency_rt       IN gipi_witem.currency_rt%TYPE,
            p_pol_flag          IN gipi_wpolbas.pol_flag%TYPE,
            p_par_type          IN gipi_parlist.par_type%TYPE,
            p_par_id            IN gipi_wpolbas.par_id%TYPE,
            p_policy_id         IN gipi_polbasic.policy_id%TYPE
            ) IS
      v_peril_cd                giis_peril.peril_cd%TYPE;
      v_peril_tsi                   giuw_wperilds.tsi_amt%TYPE      := 0;
      v_peril_premium            giuw_wperilds.prem_amt%TYPE     := 0;
      v_peril_ann_tsi            giuw_wperilds.ann_tsi_amt%TYPE  := 0;
      v_exist                    VARCHAR2(1)                     := 'N';
      v_insert_sw                VARCHAR2(1)                     := 'N';
      v_peril_exists            VARCHAR2(1)                     := 'N';
      v_dist_exists             VARCHAR2(1)                     := 'N';  
      /* Updates the amounts of the previously processed PERIL_CD
      ** while looping inside cursor C3.  After which, the records
      ** for table GIUW_WPERILDS_DTL are also created.
      ** NOTE:  This is a LOCAL PROCEDURE BODY called below. */
      PROCEDURE  UPD_CREATE_WPERIL_DTL_DATA IS
      BEGIN
        GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_WPERILDS_017
              (p_dist_no       , p_dist_seq_no , p_line_cd       ,
               v_peril_cd      , v_peril_tsi   , v_peril_premium ,
               v_peril_ann_tsi , p_rg_count    , p_pol_flag      ,
               p_par_type      , p_par_id      , p_policy_id);
      END;

    BEGIN
      FOR a IN ( 
          SELECT 1 
            FROM giuw_wpolicyds
           WHERE dist_no = p_dist_no
             AND dist_seq_no = p_dist_seq_no)
        LOOP
            v_dist_exists := 'Y';
            EXIT;
        END LOOP;
           
      IF NVL(v_dist_exists,'N') = 'N' THEN         
         INSERT INTO giuw_wpolicyds
                    (dist_no      , dist_seq_no      , dist_flag        ,
                     tsi_amt      , prem_amt         , ann_tsi_amt      ,
                     item_grp)
             VALUES (p_dist_no    , p_dist_seq_no    , p_dist_flag      ,
                     p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                     p_item_grp);
      ELSE                          
             UPDATE giuw_wpolicyds
                SET tsi_amt        = p_policy_tsi,
                    prem_amt       = p_policy_premium,
                    ann_tsi_amt = p_policy_ann_tsi
              WHERE dist_no         = p_dist_no
                AND dist_seq_no = p_dist_seq_no;
      END IF;
      
      IF NVL(v_dist_exists,'N') = 'N' THEN         
             FOR c3 IN (  
               SELECT sum(B490.tsi_amt)     peril_tsi     ,
                      sum(B490.prem_amt)    peril_premium ,
                      sum(B490.ann_tsi_amt) peril_ann_tsi ,
                      B490.peril_cd    peril_cd
                 FROM gipi_itmperil B490, gipi_item B480
                WHERE B490.item_no   = B480.item_no
                  AND B490.policy_id = B480.policy_id
                  AND B480.item_grp  = p_item_grp
                  AND B480.policy_id = p_policy_id           
                 GROUP BY B490.peril_cd)
             LOOP    
                  /* Create records in table GIUW_WPERILDS and GIUW_WPERILDS_DTL
                  ** for the specified DIST_SEQ_NO. */
               --msg_alert('no perilds ','I',FALSE);   
               INSERT INTO giuw_wperilds  
                         ( dist_no              , dist_seq_no   , peril_cd         , 
                           line_cd                    , tsi_amt       , prem_amt         , 
                           ann_tsi_amt)
                  VALUES ( p_dist_no            , p_dist_seq_no , c3.peril_cd      , 
                             p_line_cd                  , c3.peril_tsi  , c3.peril_premium , 
                             c3.peril_ann_tsi);
               GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_WPERILDS_017
                             ( p_dist_no             , p_dist_seq_no , p_line_cd           ,
                             c3.peril_cd                , c3.peril_tsi     , c3.peril_premium ,
                             c3.peril_ann_tsi          , p_rg_count    , p_pol_flag       ,
                             p_par_type              , p_par_id      , p_policy_id);           
             END LOOP;
      ELSE
           FOR c3 IN (  
             SELECT SUM(B490.tsi_amt)     peril_tsi     ,
                    SUM(B490.prem_amt)    peril_premium ,
                    SUM(B490.ann_tsi_amt) peril_ann_tsi ,
                    B490.peril_cd    peril_cd
              FROM gipi_itmperil B490, giuw_wperilds B480, gipi_item B470
             WHERE 1 = 1
               AND B480.dist_seq_no = p_dist_seq_no
               AND B490.policy_id = B470.policy_id
               AND B490.peril_cd  = B480.peril_cd
               AND B490.item_no     = B470.item_no
               AND B480.dist_no   = p_dist_no
               AND B470.item_grp  = p_item_grp
               AND B490.policy_id = p_policy_id
             GROUP BY B490.peril_cd)
           LOOP    
              /* Create records in table GIUW_WPERILDS and GIUW_WPERILDS_DTL
              ** for the specified DIST_SEQ_NO. */
             UPDATE giuw_wperilds
                SET tsi_amt         = c3.peril_tsi,
                    prem_amt        = c3.peril_premium,
                    ann_tsi_amt = c3.peril_ann_tsi
              WHERE dist_no       = p_dist_no
                AND dist_seq_no = p_dist_seq_no
                AND peril_cd    = c3.peril_cd
                AND line_cd     = p_line_cd;    
                
             GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_WPERILDS_017
                             ( p_dist_no             , p_dist_seq_no , p_line_cd           ,
                             c3.peril_cd                , c3.peril_tsi     , c3.peril_premium ,
                             c3.peril_ann_tsi          , p_rg_count    , p_pol_flag       ,
                             p_par_type              , p_par_id      , p_policy_id);           
           END LOOP;                
      END IF;  
                 
      GIUW_POL_DIST_PKG.UPDATE_DTLS_NO_SHARE_CD(p_dist_no, p_dist_seq_no, 'PERIL', p_line_cd);

      FOR c2 IN (
        SELECT a.item_no, sum(decode(c.peril_type,'B',a.tsi_amt,0)) tsi_amt, 
                     sum(a.prem_amt) prem_amt, 
                     sum(decode(c.peril_type,'B',a.ann_tsi_amt,0)) ann_tsi_amt 
          FROM gipi_itmperil a, giuw_wperilds b, giis_peril c
             WHERE a.peril_cd = b.peril_cd
             AND a.line_cd  = b.line_cd
             AND c.peril_cd = b.peril_cd
             AND c.line_cd  = b.line_cd
             AND a.policy_id = p_policy_id
             AND b.dist_no   = p_dist_no
             AND b.dist_seq_no = p_dist_seq_no
             AND EXISTS ( SELECT 1 FROM gipi_item c
                                 WHERE c.policy_id = a.policy_id
                                             AND c.item_no   = a.item_no
                                             AND c.item_grp  = p_item_grp)
            GROUP BY a.item_no)
      LOOP
        /* Create records in table GIUW_WITEMDS and GIUW_WITEMDS_DTL
        ** for the specified DIST_SEQ_NO. */
        INSERT INTO giuw_witemds
                  ( dist_no        , dist_seq_no   , item_no        ,
                    tsi_amt        , prem_amt      , ann_tsi_amt)
           VALUES ( p_dist_no      , p_dist_seq_no , c2.item_no     ,
                    c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);        
          GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_WITEMDS_017
                  ( p_dist_no      , p_dist_seq_no , c2.item_no  ,
                    p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
                    c2.ann_tsi_amt , p_rg_count    , p_pol_flag  ,
                    p_par_type     , p_policy_id);
      END LOOP;    
        
      GIUW_POL_DIST_PKG.UPDATE_DTLS_NO_SHARE_CD(p_dist_no, p_dist_seq_no, 'ITEM', p_line_cd);    
      
      IF NVL(v_dist_exists,'N') = 'N' THEN
        FOR c3 IN (  
          SELECT B490.tsi_amt     itmperil_tsi     ,
                 B490.prem_amt    itmperil_premium ,
                 B490.ann_tsi_amt itmperil_ann_tsi ,
                 B490.item_no     item_no          ,
                 B490.peril_cd    peril_cd
            FROM gipi_itmperil B490, gipi_item B480
           WHERE B490.item_no   = B480.item_no
             AND B490.policy_id = B480.policy_id
             AND B480.item_grp  = p_item_grp
             AND B480.policy_id = p_policy_id)
        LOOP
          v_exist     := 'Y';
          /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
          ** for the specified DIST_SEQ_NO. */                
          INSERT INTO giuw_witemperilds  
                    ( dist_no             , dist_seq_no   , item_no         ,
                      peril_cd            , line_cd       , tsi_amt         ,
                      prem_amt            , ann_tsi_amt)
             VALUES ( p_dist_no           , p_dist_seq_no , c3.item_no      ,
                      c3.peril_cd         , p_line_cd     , c3.itmperil_tsi , 
                      c3.itmperil_premium , c3.itmperil_ann_tsi);        
          GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_WITEMPERILDS17
                    ( p_dist_no           , p_dist_seq_no       , c3.item_no      ,
                      p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                      c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count      ,
                      p_pol_flag          , p_par_type          , p_par_id        ,
                      p_policy_id);          
        END LOOP;  
      ELSE
           FOR c3 IN (  
             SELECT B490.tsi_amt     itmperil_tsi     ,
                    B490.prem_amt    itmperil_premium ,
                    B490.ann_tsi_amt itmperil_ann_tsi ,
                    B490.item_no     item_no          ,
                    B490.peril_cd    peril_cd
               FROM gipi_itmperil B490, gipi_item B480
              WHERE B490.item_no   = B480.item_no
                AND B490.policy_id = B480.policy_id
                AND B480.item_grp  = p_item_grp
                AND B480.policy_id = p_policy_id
                AND EXISTS ( SELECT 1
                                 FROM giuw_wperilds c
                                WHERE 1 = 1
                                    AND c.dist_no     = p_dist_no
                                    AND c.dist_seq_no = p_dist_seq_no
                                    AND c.peril_cd        = b490.peril_cd
                                    AND c.line_cd    = b490.line_cd)
                AND EXISTS ( SELECT 1
                                 FROM giuw_wpolicyds c
                                WHERE 1 = 1
                                    AND c.dist_no     = p_dist_no
                                    AND c.dist_seq_no = p_dist_seq_no
                                    AND c.item_grp    = p_item_grp
                                    AND c.item_grp    = b480.item_grp)
                  AND EXISTS ( SELECT 1
                                 FROM giuw_witemds c
                                WHERE 1 = 1
                                    AND c.dist_no     = p_dist_no
                                    AND c.dist_seq_no = p_dist_seq_no
                                    AND c.item_no     = b480.item_no)   
             )
           LOOP
             v_exist     := 'Y';
             /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
             ** for the specified DIST_SEQ_NO. */
             INSERT INTO giuw_witemperilds  
                       ( dist_no             , dist_seq_no   , item_no         ,
                         peril_cd            , line_cd       , tsi_amt         ,
                         prem_amt            , ann_tsi_amt)
                VALUES ( p_dist_no           , p_dist_seq_no , c3.item_no      ,
                         c3.peril_cd         , p_line_cd     , c3.itmperil_tsi , 
                         c3.itmperil_premium , c3.itmperil_ann_tsi);                        
                                   
             GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_WITEMPERILDS17
                       ( p_dist_no           , p_dist_seq_no       , c3.item_no      ,
                         p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                         c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count      ,
                         p_pol_flag          , p_par_type          , p_par_id        ,
                         p_policy_id);          
           END LOOP;    
      END IF;    
      
      GIUW_POL_DIST_PKG.UPDATE_DTLS_NO_SHARE_CD(p_dist_no, p_dist_seq_no, 'ITEMPERIL', p_line_cd);               
      GIUW_POL_DIST_FINAL_PKG.UPDATE_WITEMDS(p_dist_no, p_dist_seq_no);
            
      /* Get the amounts for each item in table GIPI_WITEM in preparation
      ** for data insertion to its corresponding distribution tables. */            
      GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_WPOLICYDS_017
                    (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
                     p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                     p_rg_count   , p_default_type   , p_currency_rt    ,
                     p_par_id     , p_item_grp       , p_pol_flag       ,
                     p_par_type);
                     
      GIUW_POL_DIST_PKG.UPDATE_DTLS_NO_SHARE_CD(p_dist_no, p_dist_seq_no, 'POLICY', p_line_cd);
      
      IF p_pol_flag = '2' OR p_par_type='E' THEN
         GIUW_POL_DIST_FINAL_PKG.INHERIT_DIST_PCT(p_dist_no,p_par_type,p_par_id,p_policy_id);
      END IF;
      
    END;  

    PROCEDURE CHECK_AUTO_DIST1(
        p_dist_no           IN     GIUW_POL_DIST.dist_no%TYPE,
        p_par_id            IN     gipi_wpolbas.par_id%TYPE,
        p_line_cd           IN     GIPI_POLBASIC.line_cd%TYPE
        ) IS
        v_share        VARCHAR2(1) := 'N';
        v_share1    VARCHAR2(1) := 'N';
    BEGIN
        FOR V IN (SELECT SHARE_TYPE
                    FROM giis_dist_share 
                   WHERE line_cd = p_line_cd
                     AND share_type = 3
                     AND share_cd IN (SELECT share_cd
                                        FROM GIUW_WPOLICYDS_DTL
                                             WHERE DIST_NO = p_dist_no
                                                 AND LINE_CD = p_LINE_CD)) LOOP                                
        IF V.SHARE_TYPE = '3' THEN
                    v_share := 'Y';
        END IF;                         
      END LOOP;     
      IF V_SHARE = 'Y' THEN               
        UPDATE giuw_pol_dist
               SET auto_dist = 'N'                     
         WHERE par_id    = p_par_id
             AND dist_no   = p_dist_no;        
      ELSE 
        NULL;
      END IF;
      --FORMS_DDL('COMMIT'); 
    END;

   /**
    **  Created by:     Niknok Orio 
    **  Date Created:   08.02.2011
    **  Referenced by:  GIUWS017 - Dist by TSI/Prem (Peril)  
    **  Description:    CREATE_ITEMS Program Unit from GIUWS017 
    **/
    PROCEDURE CREATE_ITEMS_GIUWS017(
        p_dist_no           IN      GIUW_POL_DIST.dist_no%TYPE,
        p_par_id            IN      gipi_wpolbas.par_id%TYPE,
        p_line_cd           IN      GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd        IN      GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd            IN      GIPI_POLBASIC.iss_cd%TYPE,
        p_pack_pol_flag     IN      GIPI_POLBASIC.pack_pol_flag%TYPE,
        p_pol_flag          IN      gipi_wpolbas.pol_flag%TYPE,
        p_par_type          IN      gipi_parlist.par_type%TYPE,
        p_policy_id         IN      GIPI_POLBASIC.policy_id%TYPE
        ) IS
      v_line_cd                            gipi_parlist.line_cd%TYPE;
      v_subline_cd                        gipi_wpolbas.subline_cd%TYPE;
      v_dist_seq_no                     giuw_wpolicyds.dist_seq_no%TYPE := 0;
      --rg_id                                RECORDGROUP;
      rg_name                            VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_count                            NUMBER := 0;
      v_exist                            VARCHAR2(1);
      v_errors                            NUMBER;
      v_default_no                        giis_default_dist.default_no%TYPE;
      v_default_type                    giis_default_dist.default_type%TYPE;
      v_dflt_netret_pct                 giis_default_dist.dflt_netret_pct%TYPE;
      v_dist_type                          giis_default_dist.dist_type%TYPE;
      v_post_flag                           VARCHAR2(1)  := 'O';
      v_package_policy_sw               VARCHAR2(1)  := 'Y';
      v_dist_exists                     VARCHAR2(1)  := 'N';
    BEGIN
        FOR a IN (SELECT 1 
                    FROM giuw_wpolicyds
                   WHERE dist_no = p_dist_no)
        LOOP
            v_dist_exists := 'Y';
            EXIT;
        END LOOP;
        
        IF NVL(v_dist_exists,'N') = 'N'  THEN 
          /* Get the unique ITEM_GRP to produce a unique DIST_SEQ_NO for each. */  
            FOR c1 IN (  
                SELECT NVL(item_grp, 1) item_grp        ,
                       pack_line_cd     pack_line_cd    ,
                       pack_subline_cd  pack_subline_cd ,
                       currency_rt      currency_rt     ,
                       SUM(tsi_amt)     policy_tsi      ,
                       SUM(prem_amt)    policy_premium  ,
                       SUM(ann_tsi_amt) policy_ann_tsi
                  FROM gipi_item a
                 WHERE EXISTS ( SELECT 1
                                  FROM gipi_itmperil
                                 WHERE policy_id = a.policy_id 
                                   AND item_no      = a.item_no )   
                       --(b.prem_amt != 0
                       --OR b.tsi_amt  != 0)
                   AND policy_id    = p_policy_id
                 GROUP BY item_grp , pack_line_cd , pack_subline_cd , currency_rt)
            LOOP
              /* If the PAR processed is a package policy
              ** then get the true LINE_CD and true SUBLINE_CD,
              ** that is, the PACK_LINE_CD and PACK_SUBLINE_CD 
              ** from the GIPI_WITEM table.
              ** This will be used upon inserting to certain
              ** distribution tables requiring a value for
              ** the similar field. */
            
                IF p_pack_pol_flag = 'N' THEN
                   v_line_cd    := p_line_cd;
                   v_subline_cd := p_subline_cd;
                ELSE
                   v_line_cd           := c1.pack_line_cd;
                   v_subline_cd        := c1.pack_subline_cd;
                   v_package_policy_sw := 'Y';
                END IF;
                
                IF v_package_policy_sw = 'Y' THEN
                   FOR c2 IN (
                     SELECT default_no, default_type, dist_type, dflt_netret_pct
                       FROM giis_default_dist
                      WHERE iss_cd     = p_iss_cd
                        AND subline_cd = v_subline_cd
                        AND line_cd    = v_line_cd)
                   LOOP
                     v_default_no      := c2.default_no;
                     v_default_type    := c2.default_type;
                     v_dist_type       := c2.dist_type;
                     v_dflt_netret_pct := c2.dflt_netret_pct;
                     EXIT;
                   END LOOP;               
               v_package_policy_sw := 'N';
            END IF;

                /* Generate a new DIST_SEQ_NO for the new
                ** item group. */
                v_dist_seq_no := v_dist_seq_no + 1;
                   
            v_post_flag := 'P';
               
            GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_017
               ( p_dist_no      , v_dist_seq_no     , '2'               ,
                 c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi ,
                 c1.item_grp    , v_line_cd         , rg_count          ,
                 v_default_type , c1.currency_rt    , p_pol_flag        ,
                 p_par_type     , p_par_id          , p_policy_id);    
          END LOOP;
          
        ELSE
               FOR a IN ( 
                   SELECT dist_seq_no, tsi_amt, prem_amt, ann_tsi_amt,item_grp
                     FROM giuw_wpolicyds
                    WHERE dist_no = p_dist_no)
                 LOOP
                   v_post_flag := 'P';   
                   GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_DIST_017
                         (p_dist_no      , a.dist_seq_no     , '2'               ,
                          a.tsi_amt      , a.prem_amt        , a.ann_tsi_amt     ,
                          a.item_grp     , p_line_cd         , rg_count          ,
                          v_default_type , 1                 , p_pol_flag        ,
                          p_par_type     , p_par_id          , p_policy_id);
                 END LOOP;
        END IF;
                 
        /*IF NOT ID_NULL(rg_id) THEN
           DELETE_GROUP(rg_id);
        END IF;*/
            
        /* Create records in RI tables if a facultative
        ** share exists in any of the DIST_SEQ_NO in table
        ** GIUW_WPOLICYDS_DTL. */
        GIUW_POL_DIST_FINAL_PKG.CREATE_RI_RECORDS_GIUWS010(p_dist_no, p_par_id, p_line_cd, p_subline_cd);

        /* Set the value of the DIST_FLAG back 
        ** to Undistributed after recreation. */
        --:c080.dist_flag      := '1';
        --:c080.mean_dist_flag := 'Undistributed';
        UPDATE giuw_pol_dist
           SET dist_flag = '1',
               post_flag = v_post_flag
         WHERE par_id    = p_par_id
           AND dist_no   = p_dist_no;
             
        GIUW_POL_DIST_FINAL_PKG.ADJUST_AMTS_GIUWS016(p_dist_no);
        GIUW_POL_DIST_FINAL_PKG.CHECK_AUTO_DIST1(p_dist_no, p_par_id, p_line_cd);
    END;

   /**
    **  Created by:     Niknok Orio 
    **  Date Created:   08.05.2011
    **  Referenced by:  GIUWS017 - Dist by TSI/Prem (Peril)  
    **  Description:   
    **/   
    PROCEDURE ADJUST_NET_RET_IMP_017(
        p_dist_no        giuw_wpolicyds.dist_no%TYPE
        ) IS
    BEGIN
        /* Equalize the amounts of tables GIUW_WPOLICYDS
        ** and GIUW_WPOLICYDS_DTL. */
        giuw_wpolicyds_dtl_pkg.ADJUST_POLICY_LEVEL_AMTS(p_dist_no);
        
        /* Equalize the amounts of tables GIUW_WITEMDS
        ** and GIUW_WITEMDS_DTL. */
        giuw_pol_dist_final_pkg.ADJUST_ITM_LVL_AMTS_GIUWS016(p_dist_no);

        /* Equalize the amounts of tables GIUW_WITEMPERILDS
        ** and GIUW_WITEMPERILDS_DTL. */
        giuw_pol_dist_final_pkg.ADJ_ITM_PERL_LVL_AMTS_GIUWS016(p_dist_no);  

        /*bdarusin ,may27,2003*/
        giuw_pol_dist_final_pkg.ADJUST_DTL_AMTS_GIUWS016(p_dist_no);  
    END;

   /**
    **  Created by:     Niknok Orio 
    **  Date Created:   08.05.2011
    **  Referenced by:  GIUWS017 - Dist by TSI/Prem (Peril)  
    **  Description:   
    **/   
    --added steven 
    PROCEDURE pfc_giuws017_batch_id(
        p_dist_no           IN      GIUW_POL_DIST.dist_no%TYPE, 
        p_batch_id          IN OUT  giuw_pol_dist.batch_id%TYPE
        ) IS
    BEGIN
       /* Remove the current distribution from the batch
         ** to which it originally belongs to. */
       IF p_batch_id IS NOT NULL
       THEN
          FOR c1 IN (SELECT ROWID, batch_qty
                       FROM giuw_dist_batch
                      WHERE batch_id = p_batch_id)
          LOOP
             IF c1.batch_qty > 1
             THEN
                UPDATE giuw_dist_batch
                   SET batch_qty = c1.batch_qty - 1
                 WHERE ROWID = c1.ROWID;
             ELSE
                DELETE      giuw_dist_batch_dtl
                      WHERE batch_id = p_batch_id;

                UPDATE giuw_pol_dist
                   SET batch_id = NULL
                 WHERE dist_no = p_dist_no;

                DELETE      giuw_dist_batch
                      WHERE ROWID = c1.ROWID;
             END IF;

             p_batch_id := NULL;
             EXIT;
          END LOOP;
       END IF;
    END;
    
    PROCEDURE post_form_commit_giuws017(
        p_dist_no           IN      GIUW_POL_DIST.dist_no%TYPE, 
        --p_dist_seq_no       IN      giuw_wperilds.dist_seq_no%TYPE,
        --p_line_cd           IN      giuw_wperilds.line_cd%TYPE,
        --p_peril_cd          IN      giuw_wperilds.peril_cd%TYPE,
        p_pol_flag          IN      gipi_wpolbas.pol_flag%TYPE,
        p_par_type          IN      gipi_parlist.par_type%TYPE,
        p_policy_id         IN      GIPI_POLBASIC.policy_id%TYPE
        --p_batch_id          IN OUT  giuw_pol_dist.batch_id%TYPE
        ) IS
    BEGIN

      /* Adjust computational floats to equalize the amounts
      ** attained by the master tables with that of its detail
      ** tables.
      ** Tables involved:  GIUW_WPERILDS - GIUW_WPERILDS_DTL */
--      IF p_pol_flag != '2' AND p_par_type = 'P' THEN --remove by steven 06.23.2014 copied from FMB
--        giuw_pol_dist_pkg.adjust_wperilds_dtl2(p_dist_no, p_dist_seq_no, p_line_cd, p_peril_cd); 
--      END IF;

      /* *************************** START OF FOR COMMIT ONLY ******************************** */
      /*  PROCEDURE IS ONLY PERFORMED DURING COMMIT PROCESSING WHERE THE VALUE OF THE VARIABLE
      **  VARIABLES.POST_SW IS EQUAL TO 'N'.                                                   */
      /* ************************************************************************************* */
      --added by steven 08.05.2014 - checks for allied perils that were illegally distributed.
      /* removed by robert 10.13.15 GENQA 5053
	  FOR i IN (SELECT dist_seq_no, peril_cd, share_cd
                   FROM giuw_wperilds_dtl
                  WHERE dist_no = p_dist_no) 
      LOOP
        GIUW_POL_DIST_FINAL_PKG.check_peril_dist_per_share(p_dist_no, i.dist_seq_no, i.share_cd, i.peril_cd);
      END LOOP; */
      /* Reset DIST_FLAG to undistributed as
      ** the current changes made were not yet
      ** posted to the master tables. */
      UPDATE giuw_pol_dist
         SET dist_flag = '1',
             post_flag = 'P',
             batch_id  = NULL
       WHERE policy_id = p_policy_id
         AND dist_no   = p_dist_no;
         
      UPDATE gipi_polbasic
         SET dist_flag = '1'
       WHERE policy_id = p_policy_id;
       
      --IF p_pol_flag != '2' AND p_par_type = 'P' THEN --remove by steven 06.23.2014 dapat pag may changes papasok pa rin siya dito
          /* Remove existing records related to the
          ** current DIST_NO from certain distribution
          ** and RI master tables considering the fact
          ** that the current changes made were not yet
          ** posted to the master tables. */
          GIUW_POL_DIST_PKG.DELETE_DIST_MASTER_TABLES(p_dist_no);
          
          /* Recreate records of table GIUW_WITEMPERILDS_DTL based
          ** on the data inserted to table GIUW_WPERILDS_DTL. */
          giuw_witemperilds_dtl_pkg.POPULATE_WITEMPERILDS_DTL3(p_dist_no);
          
          /* Recreate records of table GIUW_WITEMDS_DTL based
          ** on the data inserted to table GIUW_WITEMPERILDS_DTL. */
          giuw_witemds_dtl_pkg.populate_witemds_dtl2(p_dist_no);
            
          /* Recreate records of table GIUW_WPOLICYDS_DTL based
          ** on the data inserted to table GIUW_WITEMDS_DTL. */
          giuw_wpolicyds_dtl_pkg.populate_wpolicyds_dtl2(p_dist_no);
          
          /* Adjust computational floats to equalize the amounts
          ** attained by the master tables with that of its detail
          ** tables.
          ** Tables involved:  GIUW_WPOLICYDS - GIUW_WPOLICYDS_DTL
          **                   GIUW_WITEMDS   - GIUW_WITEMDS_DTL */
          
          --GIUW_POL_DIST_FINAL_PKG.ADJUST_NET_RET_IMP_017(p_dist_no); --remove by steven 06.23.2014 copied from FMB
      --ELSE 
          --GIUW_POL_DIST_FINAL_PKG.ADJUST_NET_RET_IMP_017(p_dist_no); --remove by steven 06.23.2014 copied from FMB
      --END IF;
      adjust_distribution_peril_pkg.adjust_distribution(p_dist_no); --added by steven 06.23.2014 copied from FMB
          
      /* Sets the distribution flag of table GIUW_WPOLICYDS to
      ** 2 or what used to be 2, signifying that all records
      ** have already been properly distributed and that such
      ** records are ready for posting.
      ** NOTE:  The update was made across all DIST_SEQ_NO's
      **        because the current system does not support
      **        partial distribution.  This means that if a
      **        particular DIST_SEQ_NO has already been 
      **        distributed, all subsequent DIST_SEQ_NO's 
      **        must also be distributed. */
      UPDATE giuw_wpolicyds
         SET dist_flag =  '2'
       WHERE dist_no   = p_dist_no;
       --added by steven to alwalys set the SPECIAL_DIST_SW to 'N'
       UPDATE giuw_pol_dist
         SET special_dist_sw = 'N'
       WHERE dist_no = p_dist_no;
       
       --added by steven 08.04.2014 -to delete the records in the binder working tables 
       FOR i IN (SELECT dist_seq_no
                   FROM giuw_wpolicyds
                   WHERE dist_no = p_dist_no)
       LOOP
        delete_working_binder_tables (p_dist_no, i.dist_seq_no);
       END LOOP;
    END;
    
    --added by steven 08.05.2014
    PROCEDURE validate_before_post_giuws017 (
        p_dist_no           IN      GIUW_POL_DIST.dist_no%TYPE, 
        p_policy_id         IN      GIPI_POLBASIC.policy_id%TYPE
    )
    IS
    v_basic_exists  VARCHAR2(1);
    v_msg_alert     VARCHAR2(2000);
    BEGIN
       -- to check the allied peril
       FOR i IN(SELECT dist_seq_no
              FROM GIUW_WPOLICYDS
             WHERE dist_no = p_dist_no)
       LOOP
          v_basic_exists := 'N';
       
          FOR d IN(SELECT DISTINCT b.peril_type
                     FROM GIUW_WPERILDS a,
                          GIIS_PERIL b
                    WHERE a.dist_no = p_dist_no
                      AND a.dist_seq_no = i.dist_seq_no
                      AND a.line_cd = b.line_cd
                      AND a.peril_cd = b.peril_cd)
          LOOP
             IF d.peril_type = 'B' THEN
                v_basic_exists := 'Y';
                EXIT;
             END IF;
          END LOOP;
          
          IF v_basic_exists = 'N' THEN
             FOR c IN(SELECT a.tsi_amt, a.prem_amt
                        FROM GIUW_WPERILDS a
                       WHERE a.dist_no = p_dist_no
                         AND a.dist_seq_no = i.dist_seq_no)
             LOOP
                IF c.tsi_amt != 0 AND c.prem_amt = 0 THEN
                   raise_application_error(-20001, 'Geniisys Exception#I#Cannot post distribution. Please distribute by group.');
                END IF;
             END LOOP;
          END IF;
       END LOOP;
       
       --- to check if the TSI amount and premium amount is zero.
       FOR i IN(SELECT NVL(tsi_amt, 0) tsi_amt,
                   NVL(prem_amt, 0) prem_amt
              FROM GIPI_POLBASIC
             WHERE policy_id = p_policy_id)
       LOOP
          IF i.tsi_amt = 0 AND i.prem_amt = 0 THEN
             raise_application_error(-20001, 'Geniisys Exception#I#Cannot post distribution. Please distribute by group.');
          END IF;
       END LOOP;
       
       --checks for allied perils that were illegally distributed.
       --giuw_pol_dist_pkg.check_peril_distribution_error(p_dist_no,v_msg_alert); removed by robert 10.13.15 GENQA 5053
    END;

   /**
    **  Created by:     Niknok Orio 
    **  Date Created:   08.08.2011
    **  Referenced by:  GIUWS017 - Dist by TSI/Prem (Peril)  
    **  Description:   posting distribution 
    **/  
    PROCEDURE post_dist_giuws017(
        p_dist_no           IN     GIUW_POL_DIST.dist_no%TYPE,
        p_dist_seq_no       IN     GIUW_POLICYDS_DTL.dist_seq_no%TYPE,
        p_policy_id         IN     GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
        p_par_id            IN     GIUW_POL_DIST.par_id%TYPE,
        p_line_cd           IN     GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
        p_subline_cd        IN     GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
        p_iss_cd            IN     GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE,
        p_issue_yy          IN     GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE,
        p_pol_seq_no        IN     GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE,
        p_renew_no          IN     GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE,
        p_eff_date          IN     GIPI_POLBASIC_POL_DIST_V1.eff_date%TYPE,
        p_peril_cd          IN     GIUW_WPERILDS.peril_cd%TYPE,
        p_batch_id          IN OUT GIUW_POL_DIST.batch_id%TYPE,
        p_msg_alert         OUT    VARCHAR2,
        p_workflow_msgr     OUT    VARCHAR2
        ) IS
      v_msg_alert           VARCHAR2(32000) := '';
      v_facul_sw            VARCHAR2(32000) := 'N';
      v_cnt                 NUMBER;
      v_eff_date            GIUW_POL_DIST.eff_date%TYPE;        
      v_expiry_date         GIUW_POL_DIST.expiry_date%TYPE;
      v_takeup_term         GIPI_WPOLBAS.takeup_term%TYPE;
      v_eff_date_trunc      DATE;
      --added by robert SR 21734 02.17.16
      v_illegal_dist        BOOLEAN;
      v_tsi_allied_facul    giuw_wperilds_dtl.dist_tsi%TYPE;
      v_tsi_allied          giuw_wperilds_dtl.dist_tsi%TYPE;
    BEGIN

      /* BETH 03/14/2001 
      ** Check if records are existing in all distribution 
      ** tables, disallow POSTING of distribution if there are
      ** missing records in any of the distribution tables
      */
      --GIUW_POL_DIST_FINAL_PKG.validate_before_post_giuws017(p_dist_no, p_policy_id); --removed by robert SR 5053 01.08.16 --added by steven 08.06.2014 
      VALIDATE_EXISTING_DIST_REC2(p_policy_id, p_dist_no, v_msg_alert); 
      IF v_msg_alert IS NOT NULL THEN
        p_msg_alert := v_msg_alert;
        RETURN;
      END IF;
      
      --added by steven 06.13.2014; for peril only.
      BEGIN 
         SELECT a.takeup_term
           INTO v_takeup_term
           FROM gipi_polbasic a
          WHERE a.par_id = p_par_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_takeup_term := NULL;
      END;
        
      IF v_takeup_term = 'ST' THEN
        compare_itmperil_dist_pkg.compare_recompute_dist(p_dist_no, p_msg_alert);   
        giuw_pol_dist_pkg.compare_wdist_table_for_policy(p_dist_no, p_par_id );
      END IF;

      /* Checks for a previously negated
      ** distribution record before creating
      ** or updating records from the RI
      ** table GIRI_WDISTFRPS. */
      GIUW_POL_DIST_FINAL_PKG.POLICY_NEGATED_CHECK_GIUWS016(v_facul_sw, p_policy_id, p_dist_no, p_line_cd, p_subline_cd);

      /* Remove existing records related to the
      ** current DIST_NO from certain distribution
      ** and RI master tables considering the fact
      ** that the current changes made were not yet
      ** posted to the master tables. */
      GIUW_POL_DIST_PKG.DELETE_DIST_MASTER_TABLES(p_dist_no);
      
      --added by steven 08.06.2014
      /* Recreate records of table GIUW_WITEMPERILDS_DTL based
      ** on the data inserted to table GIUW_WPERILDS_DTL. */
      giuw_witemperilds_dtl_pkg.POPULATE_WITEMPERILDS_DTL3(p_dist_no);
          
      /* Recreate records of table GIUW_WITEMDS_DTL based
      ** on the data inserted to table GIUW_WITEMPERILDS_DTL. */
      giuw_witemds_dtl_pkg.populate_witemds_dtl2(p_dist_no);
            
      /* Recreate records of table GIUW_WPOLICYDS_DTL based
      ** on the data inserted to table GIUW_WITEMDS_DTL. */
      giuw_wpolicyds_dtl_pkg.populate_wpolicyds_dtl2(p_dist_no);
          
      /* Adjust computational floats to equalize the amounts
      ** attained by the master tables with that of its detail
      ** tables.
      ** Tables involved:  GIUW_WPOLICYDS - GIUW_WPOLICYDS_DTL
      **                   GIUW_WITEMDS   - GIUW_WITEMDS_DTL */
      adjust_distribution_peril_pkg.adjust_distribution(p_dist_no); 
      --end steven 08.06.2014

      -- added by robert SR 21734 02.17.16
      -- recompute giri_wdistfrps.tot_fac_spct for illegally distributed records
        BEGIN
           v_illegal_dist := giuw_pol_dist_final_pkg.check_peril_dist (p_dist_no, p_dist_seq_no);

           IF v_illegal_dist
           THEN
              FOR upd_gwd IN (SELECT dist_no, dist_seq_no, line_cd, dist_spct
                                FROM giuw_wpolicyds_dtl
                               WHERE dist_no = p_dist_no
                                 AND dist_seq_no = p_dist_seq_no
                                 AND line_cd = p_line_cd
                                 AND share_cd = 999)
              LOOP
                 IF upd_gwd.dist_spct = 0
                 THEN
                    BEGIN
                       SELECT SUM (dist_tsi) tsi
                         INTO v_tsi_allied_facul
                         FROM giuw_wperilds_dtl a, giis_peril b
                        WHERE a.share_cd = '999'
                          AND a.line_cd = upd_gwd.line_cd
                          AND a.dist_seq_no = upd_gwd.dist_seq_no
                          AND a.dist_no = upd_gwd.dist_no
                          AND a.line_cd = b.line_cd
                          AND a.peril_cd = b.peril_cd
                          AND b.peril_type = 'A';
                    END;

                    BEGIN
                       SELECT SUM (dist_tsi)
                         INTO v_tsi_allied
                         FROM giuw_wperilds_dtl
                        WHERE line_cd = upd_gwd.line_cd
                          AND dist_seq_no = upd_gwd.dist_seq_no
                          AND dist_no = upd_gwd.dist_no
                          AND peril_cd IN (
                                 SELECT a.peril_cd
                                   FROM giuw_wperilds_dtl a, giis_peril b
                                  WHERE a.share_cd = '999'
                                    AND a.line_cd = upd_gwd.line_cd
                                    AND a.dist_seq_no = upd_gwd.dist_seq_no
                                    AND a.dist_no = upd_gwd.dist_no
                                    AND a.line_cd = b.line_cd
                                    AND a.peril_cd = b.peril_cd
                                    AND b.peril_type = 'A');
                    END;

                    UPDATE giri_wdistfrps gwd
                       SET gwd.tot_fac_spct = (v_tsi_allied_facul / v_tsi_allied) * 100
                     WHERE gwd.dist_no = upd_gwd.dist_no
                       AND gwd.dist_seq_no = upd_gwd.dist_seq_no;
                 END IF;

                 EXIT;
              END LOOP;
           END IF;
        END;
      -- end of codes by robert SR 21734 02.17.16

      /* Post records retrieved from GIUW_WPOLICYDS 
      ** and GIUW_WPOLICYDS_DTL to tables GIUW_POLICYDS 
      ** and GIUW_POLICYDS_DTL. */
      FOR i IN (SELECT TRUNC (eff_date) eff_date
                FROM gipi_polbasic
               WHERE policy_id = p_policy_id)    --kenneth SR5307 05042016 
      LOOP
        v_eff_date_trunc := i.eff_date;
        EXIT;
      END LOOP;
      
      GIUW_POLICYDS_PKG.post_wpolicyds_dtl_giuws016(p_dist_no, v_eff_date_trunc, v_msg_alert);
      IF v_msg_alert IS NOT NULL THEN
        p_msg_alert := v_msg_alert;
        RETURN;
      END IF;

      /* Post records retrieved from GIUW_WITEMDS 
      ** and GIUW_WITEMDS_DTL to tables GIUW_ITEMDS 
      ** and GIUW_WITEMDS_DTL. */
      GIUW_WITEMDS_PKG.post_witemds_dtl_giuws016(p_dist_no);

      /* Post records retrieved from GIUW_WITEMPERILDS 
      ** and GIUW_WITEMPERILDS_DTL to tables GIUW_ITEMPERILDS 
      ** and GIUW_ITEMPERILDS_DTL. */
      GIUW_ITEMPERILDS_DTL_PKG.post_witemperilds_dtl_giuws016(p_dist_no);

      /* Post records retrieved from GIUW_WPERILDS 
      ** and GIUW_WPERILDS_DTL to tables GIUW_PERILDS 
      ** and GIUW_PERILDS_DTL. */
      GIUW_WPERILDS_DTL_PKG.post_wperilds_dtl_giuws016(p_dist_no);

      /* Remove the current distribution from the batch
      ** to which it originally belongs to. */
      IF p_batch_id IS NOT NULL THEN
         FOR c1 IN (SELECT rowid, batch_qty
                      FROM giuw_dist_batch
                     WHERE batch_id = p_batch_id)
         LOOP
           IF c1.batch_qty > 1 THEN
              UPDATE giuw_dist_batch
                 SET batch_qty = c1.batch_qty - 1
               WHERE rowid     = c1.rowid;
           ELSE
              DELETE giuw_dist_batch_dtl
               WHERE batch_id = p_batch_id;
              DELETE giuw_dist_batch
               WHERE rowid = c1.rowid;
           END IF;
           p_batch_id := NULL;
           EXIT;
         END LOOP;
      END IF;

      -- A.R.C. 08.13.2004 --
      -- to delete workflow records of Final Distribution --
      delete_workflow_rec('Final Distribution', 'GIPIS055', NVL(GIIS_USERS_PKG.app_user, USER), p_policy_id);
         
      /* If a facultative share does not exist in any of
      ** the distribution records, records in the working
      ** tables will be deleted. */ 
      IF v_facul_sw = 'N' THEN
         UPDATE gipi_polbasic
            SET dist_flag = 3
          WHERE policy_id = p_policy_id;
         
         UPDATE giuw_pol_dist
            SET dist_flag = 3,
                post_flag = 'P',
                post_date = SYSDATE
          WHERE policy_id = p_policy_id
            AND dist_no   = p_dist_no;

         /* 11052000 BETH 
         **    posted policy distribution with eim_flag = '2' should be
         **    updated with eim_flag ='6' and undist_sw = 'Y' in eim_takeup_info
         **    table.
         */
         FOR A IN (SELECT '1'
                     FROM eim_takeup_info
                    WHERE policy_id = p_policy_id
                      AND eim_flag = '2')
         LOOP
             UPDATE eim_takeup_info 
                SET eim_flag = '6',
                    undist_sw = 'Y'
            WHERE policy_id = p_policy_id;
           EXIT;
         END LOOP;
         
            /* mark jm 10.08.2009 UW-SPECS-2009-00067 starts here */
            /* for updating GICL_CLM_RESERVE.REDIST_SW */
            BEGIN           
                SELECT eff_date, expiry_date
                    INTO v_eff_date, v_expiry_date
                    FROM giuw_pol_dist
                 WHERE policy_id = P_policy_id
                     AND dist_no = p_dist_no;
            END;
        
            FOR a IN (SELECT claim_id, loss_date          
                                    FROM gicl_claims
                                 WHERE line_cd = p_line_cd
                                     AND subline_cd = p_subline_cd
                                     AND pol_iss_cd = p_iss_cd
                                     AND issue_yy = p_issue_yy
                                     AND pol_seq_no = p_pol_seq_no
                                     AND renew_no = p_renew_no) LOOP    
                /*FOR b IN (SELECT item_no  
                                        FROM giuw_witemperilds
                                     WHERE dist_no = p_dist_no
                                         AND dist_seq_no = p_dist_seq_no) LOOP
                    FOR c IN (SELECT 1
                                            FROM gicl_clm_reserve
                                         WHERE claim_id = a.claim_id
                                             AND item_no = b.item_no
                                             AND peril_cd = p_peril_cd) LOOP            
                        IF v_facul_sw = 'N' AND (a.loss_date BETWEEN v_eff_date AND v_expiry_date) THEN
                            UPDATE gicl_clm_reserve
                                 SET redist_sw = 'Y'
                             WHERE claim_id = a.claim_id
                                 AND item_no = b.item_no
                                 AND peril_cd = p_peril_cd;                
                        END IF;
                    END LOOP;
                END LOOP;*/ --comment-out by steven 06.13.2014
                FOR b IN (SELECT item_no, peril_cd  
                                        FROM giuw_witemperilds
                                     WHERE dist_no = p_dist_no) LOOP
                    FOR c IN (SELECT 1
                                            FROM gicl_clm_reserve
                                         WHERE claim_id = a.claim_id
                                             AND item_no = b.item_no
                                             AND peril_cd = b.peril_cd) LOOP            
                        IF v_facul_sw = 'N' AND (a.loss_date BETWEEN v_eff_date AND v_expiry_date) THEN
                            UPDATE gicl_clm_reserve
                                 SET redist_sw = 'Y'
                             WHERE claim_id = a.claim_id
                                 AND item_no = b.item_no
                                 AND peril_cd = b.peril_cd;                
                        END IF;
                    END LOOP;
                END LOOP;
            END LOOP;
            /* mark jm 10.08.09 UW-SPECS-2009-00067 ends here */
         
         /* Delete all data related to the current
         ** DIST_NO from the distribution and RI
         ** working tables. */
         GIUW_POL_DIST_FINAL_PKG.DELETE_DIST_WORKING_TABLES_017(p_dist_no);
           /* A.R.C. 06.28.2005
         ** to delete workflow records of Undistributed policies awaiting claims */
         FOR c1 IN (SELECT claim_id
                        FROM gicl_claims
                       WHERE 1=1
                         AND line_cd = p_line_cd
                       AND subline_cd = p_subline_cd 
                       AND iss_cd = p_iss_cd
                       AND issue_yy = p_issue_yy
                       AND pol_seq_no = p_pol_seq_no
                       AND renew_no = p_renew_no)
         LOOP    
           delete_workflow_rec('Undistributed policies awaiting claims','GICLS010', NVL(GIIS_USERS_PKG.app_user, USER), c1.claim_id);  
         END LOOP;  

        --A.R.C. 02.07.2007
            --added to delete the workflow facultative placement of GIUWS012 if not facul
          DELETE_WORKFLOW_REC('Facultative Placement','GIUWS012', NVL(GIIS_USERS_PKG.app_user, USER),p_policy_id);

      ELSIF v_facul_sw    = 'Y' THEN
         UPDATE gipi_polbasic
            SET dist_flag = 2
          WHERE policy_id = p_policy_id;
         UPDATE giuw_pol_dist
            SET dist_flag = 2,
                post_flag = 'P'
          WHERE policy_id = p_policy_id
            AND dist_no   = p_dist_no;
            
            /* A.R.C. 08.16.2004
        ** to create workflow records of Facultative Placement */            
         FOR c1 IN (SELECT b.userid, d.event_desc  
                        FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
                       WHERE 1=1
                       AND c.event_cd = a.event_cd
                       AND c.event_mod_cd = a.event_mod_cd
                       AND b.event_mod_cd = a.event_mod_cd
                       --AND b.userid <> USER  --A.R.C. 01.23.2006
                       AND b.passing_userid = USER  --A.R.C. 01.23.2006
                       AND a.module_id = 'GIUWS012'
                       AND a.event_cd = d.event_cd
                       AND UPPER(d.event_desc) = 'FACULTATIVE PLACEMENT')
         LOOP
           CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIUWS012', c1.userid, p_policy_id, c1.event_desc||' '||get_policy_no(p_policy_id), v_msg_alert, p_workflow_msgr, NVL(GIIS_USERS_PKG.app_user, USER));
           IF v_msg_alert IS NOT NULL THEN
             p_msg_alert := v_msg_alert;
             RETURN;
           END IF;
         END LOOP; 
         
         FOR i IN (SELECT dist_seq_no
                   FROM giuw_wpolicyds
                   WHERE dist_no = p_dist_no)
         LOOP
           delete_working_binder_tables (p_dist_no, i.dist_seq_no);
         END LOOP;
      END IF;

      /* A.R.C. 08.16.2004
      ** to delete workflow records of Distribution Negation */
      delete_workflow_rec('Distribution Negation','GIUTS002',NVL(GIIS_USERS_PKG.app_user, USER),p_policy_id);
        
      /*iris bordey 04.04.2003
      **to update replaced_flag of giri_binder if distribution has no facul*/
      GIRI_BINDER_PKG.update_giri_binder_giuws016(p_dist_no, p_par_id);  
      --added by steven to alwalys set the SPECIAL_DIST_SW to 'N'
       UPDATE giuw_pol_dist
         SET special_dist_sw = 'N'
       WHERE dist_no = p_dist_no;
    END post_dist_giuws017;

    /**
    ** Created by:      Niknok Orio 
    ** Date Created:    08 15, 2011 
    ** Reference by:    GIUTS999 - Populate missing distribution records 
    ** Description :    
    **/
    PROCEDURE CREATE_GRP_DFLT_PERILDS999
             (p_dist_no		    IN giuw_perilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN giuw_perilds_dtl.dist_seq_no%TYPE  ,
              p_line_cd		    IN giuw_perilds_dtl.line_cd%TYPE      ,
              p_peril_cd		IN giuw_perilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi		IN giuw_perilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN giuw_perilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN giuw_perilds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN NUMBER) IS
      v_dist_spct			giuw_perilds_dtl.dist_spct%TYPE;
      v_dist_tsi			giuw_perilds_dtl.dist_tsi%TYPE;
      v_dist_prem			giuw_perilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi		giuw_perilds_dtl.ann_dist_tsi%TYPE;
      v_share_cd			giis_dist_share.share_cd%TYPE;
      v_sum_dist_tsi		giuw_perilds_dtl.dist_tsi%TYPE     := 0;
      v_sum_dist_spct		giuw_perilds_dtl.dist_spct%TYPE    := 0;
      v_sum_dist_prem		giuw_perilds_dtl.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi    giuw_perilds_dtl.ann_dist_tsi%TYPE := 0;

      PROCEDURE INSERT_TO_PERILDS_DTL IS
      BEGIN
        INSERT INTO  giuw_perilds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , peril_cd)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_peril_cd);
      END;

    BEGIN
      IF p_rg_count = 0 THEN

         /* Create the default distribution records based on the 100%
         ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
         v_share_cd     := 1;
         v_dist_spct    := 100;
         v_dist_tsi     := p_dist_tsi;
         v_dist_prem    := p_dist_prem;
         v_ann_dist_tsi := p_ann_dist_tsi;
         INSERT_TO_PERILDS_DTL;
      ELSE
         FOR c IN 1..gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT
         LOOP
           v_dist_spct     := gipi_polbasic_pol_dist_v1_pkg.rg_id(c).true_pct;
           v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
           IF v_sum_dist_spct != 100 THEN
              v_dist_tsi         := ROUND(p_dist_tsi         * v_dist_spct / 100, 2);
              v_dist_prem        := ROUND(p_dist_prem        * v_dist_spct / 100, 2);
              v_ann_dist_tsi     := ROUND(p_ann_dist_tsi     * v_dist_spct / 100, 2);
              v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
              v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
              v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
           ELSE
              v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
              v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
              v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
           END IF;
           v_share_cd     := gipi_polbasic_pol_dist_v1_pkg.rg_id(c).share_cd;
           INSERT_TO_PERILDS_DTL;
         END LOOP;

      END IF;   
    END;

    /* NOTE:  default_type 1 - Use AMOUNTS to create the default distribution records
    **                     2 - Use PERCENTAGE to create the default distribution records. */
    PROCEDURE CREATE_GRP_DFLT_POLICYDS999
             (p_dist_no	   	    IN  giuw_policyds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN  giuw_policyds_dtl.dist_seq_no%TYPE  ,
              p_line_cd		    IN  giuw_policyds_dtl.line_cd%TYPE      ,
              p_dist_tsi		IN  giuw_policyds_dtl.dist_tsi%TYPE     ,
              p_dist_prem	    IN  giuw_policyds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN  giuw_policyds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count	    IN  OUT NUMBER                           ,
              p_default_type	IN  giis_default_dist.default_type%TYPE  ,
              p_currency_rt     IN  gipi_item.currency_rt%TYPE          ,
              p_policy_id       IN  gipi_polbasic.policy_id%TYPE         ,
              p_item_grp	    IN  gipi_item.item_grp%TYPE) IS
      v_remaining_tsi				NUMBER       := p_dist_tsi * p_currency_rt;
      v_share_amt			        giis_default_dist_group.share_amt1%TYPE;
      v_peril_cd				    giis_default_dist_group.peril_cd%TYPE;
      v_prev_peril_cd				giis_default_dist_group.peril_cd%TYPE;
      v_dist_spct				    giuw_policyds_dtl.dist_spct%TYPE;
      v_dist_tsi				    giuw_policyds_dtl.dist_tsi%TYPE;
      v_dist_prem				    giuw_policyds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi				giuw_policyds_dtl.ann_dist_tsi%TYPE;
      v_sum_dist_tsi				giuw_policyds_dtl.dist_tsi%TYPE     := 0;
      v_sum_dist_spct				giuw_policyds_dtl.dist_spct%TYPE    := 0;
      v_sum_dist_prem				giuw_policyds_dtl.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi		    giuw_policyds_dtl.ann_dist_tsi%TYPE := 0;
      v_share_cd				    giis_dist_share.share_cd%TYPE;
      v_use_share_amt2              VARCHAR2(1) := 'N';
      v_dist_spct_limit			    NUMBER;
      v_rg_net          		    NUMBER; --field that would store the rec no of net ret in DFLT_DIST_VALUES

      PROCEDURE INSERT_TO_POLICYDS_DTL IS
      BEGIN
        INSERT INTO  giuw_policyds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1);
      END;

    BEGIN
        IF p_rg_count = 0 THEN
         /* Create the default distribution records based on the 100%
         ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
         v_share_cd     := 1;
         v_dist_spct    := 100;
         v_dist_tsi     := p_dist_tsi;
         v_dist_prem    := p_dist_prem;
         v_ann_dist_tsi := p_ann_dist_tsi;
         INSERT_TO_POLICYDS_DTL;      
      ELSE
      
         gipi_polbasic_pol_dist_v1_pkg.rg_selection.TRIM(gipi_polbasic_pol_dist_v1_pkg.rg_selection.COUNT);
         
         /* Use AMOUNTS to create the default distribution records. */
         IF p_default_type = 1 THEN
            FOR c IN 1..p_rg_count
            LOOP
              v_peril_cd    := gipi_polbasic_pol_dist_v1_pkg.rg_id(c).peril_cd;
              IF v_peril_cd IS NOT NULL THEN
                 IF NVL(v_prev_peril_cd, 0) = v_peril_cd THEN
                    NULL;
                 ELSE
                    v_use_share_amt2 := 'N';
                    FOR c1 IN (SELECT 'a'
                                 FROM gipi_itmperil B380, gipi_item B340
                                WHERE B380.peril_cd  = v_peril_cd
                                  AND B380.line_cd   = p_line_cd
                                  AND B380.item_no   = B340.item_no
                                  AND B380.policy_id = B340.policy_id
                                  AND B340.item_grp  = p_item_grp
                                  AND B340.policy_id = p_policy_id)
                    LOOP
                      v_use_share_amt2 := 'Y';
                      EXIT;
                    END LOOP;
                    v_prev_peril_cd := v_peril_cd;
                 END IF;
              END IF;
              IF v_use_share_amt2 = 'N' THEN
                 v_share_amt  := gipi_polbasic_pol_dist_v1_pkg.rg_id(c).share_amt1;
              ELSE
                 v_share_amt  := gipi_polbasic_pol_dist_v1_pkg.rg_id(c).share_amt2;
              END IF;
              IF v_remaining_tsi >= v_share_amt THEN
                 v_dist_tsi      := v_share_amt / p_currency_rt;
                 v_remaining_tsi := v_remaining_tsi - v_share_amt;
              ELSE
                 v_remaining_tsi := 0;
              END IF;
              IF v_remaining_tsi != 0 THEN
                 v_dist_spct        := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
                 v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
                 v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
                 v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
                 v_sum_dist_spct    := v_sum_dist_spct    + v_dist_spct;
                 v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                 v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                 v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
              ELSIF v_remaining_tsi = 0 THEN
                 v_dist_spct    := 100            - v_sum_dist_spct;
                 v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                 v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
              END IF;
              v_share_cd := gipi_polbasic_pol_dist_v1_pkg.rg_id(c).share_cd;
              --store record no of share NET RET
              IF v_share_cd = 1 THEN
                 v_rg_net := c;
              END IF;	  
              gipi_polbasic_pol_dist_v1_pkg.rg_id(c).true_pct := v_dist_spct;
              --SET_GROUP_SELECTION(rg_id, c);  --amf sakit sa bangs comment muna   
              gipi_polbasic_pol_dist_v1_pkg.rg_selection.EXTEND(1);
              gipi_polbasic_pol_dist_v1_pkg.rg_selection(gipi_polbasic_pol_dist_v1_pkg.rg_selection.COUNT) := gipi_polbasic_pol_dist_v1_pkg.rg_id(c);      
              INSERT_TO_POLICYDS_DTL;
              IF v_remaining_tsi = 0 THEN
                 EXIT;
              END IF;
            END LOOP;
            --beth 04272001 if after insert of all default share and record is not 
            --     yet distributed 100% then the remaining portion would be assign 
            --     to share of NET RETENTION instead of FACUL
            IF v_remaining_tsi != 0  THEN
               v_dist_spct    := 100            - v_sum_dist_spct;
               v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
               v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
               v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
               v_share_cd     := '1';
               --beth 04272001 if NET RET is not yet used
               --     insert it to record group for default share
               IF v_rg_net IS NULL THEN
                  p_rg_count     := p_rg_count + 1;
                  gipi_polbasic_pol_dist_v1_pkg.rg_count := gipi_polbasic_pol_dist_v1_pkg.rg_count + 1;
                  gipi_polbasic_pol_dist_v1_pkg.rg_id.EXTEND(1);
                  gipi_polbasic_pol_dist_v1_pkg.rg_id(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT).share_cd := 1;
                  gipi_polbasic_pol_dist_v1_pkg.rg_id(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT).true_pct := v_dist_spct;
                  gipi_polbasic_pol_dist_v1_pkg.rg_selection.EXTEND(1);
                  gipi_polbasic_pol_dist_v1_pkg.rg_selection(gipi_polbasic_pol_dist_v1_pkg.rg_selection.COUNT) := gipi_polbasic_pol_dist_v1_pkg.rg_id(p_rg_count);
                  INSERT_TO_POLICYDS_DTL;
               ELSE
                  --beth 04272001 if NET RET is not yet used
                  --     update it's record in default share record group
                  p_rg_count     := v_rg_net;
                  v_dist_spct    :=  v_dist_spct +  gipi_polbasic_pol_dist_v1_pkg.rg_id(p_rg_count).true_pct;
                  gipi_polbasic_pol_dist_v1_pkg.rg_id(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT).true_pct := v_dist_spct;
                  gipi_polbasic_pol_dist_v1_pkg.rg_selection.EXTEND(1);
                  gipi_polbasic_pol_dist_v1_pkg.rg_selection(gipi_polbasic_pol_dist_v1_pkg.rg_selection.COUNT) := gipi_polbasic_pol_dist_v1_pkg.rg_id(p_rg_count);
                  
                  UPDATE giuw_policyds_dtl
                     SET dist_spct = dist_spct + v_dist_spct,
                         dist_tsi  = dist_tsi + v_dist_tsi,
                         dist_prem = dist_prem + v_dist_prem,
                         ann_dist_tsi = ann_dist_tsi + v_ann_dist_tsi
                   WHERE dist_no = p_dist_no      
                     AND dist_seq_no = p_dist_seq_no
                     AND line_cd = p_line_cd
                     AND share_cd = v_share_cd;
               END IF;      
            END IF;

         /* Use PERCENTAGES to create the default distribution records. */
         ELSIF p_default_type = 2 THEN
            FOR c IN 1..p_rg_count
            LOOP
              v_dist_spct     := gipi_polbasic_pol_dist_v1_pkg.rg_id(c).share_pct;
              v_share_amt     := gipi_polbasic_pol_dist_v1_pkg.rg_id(c).share_amt1;
              IF v_share_amt IS NOT NULL THEN
                 v_dist_tsi        := v_share_amt / p_currency_rt;
                 v_dist_spct_limit := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
                 IF v_dist_spct > v_dist_spct_limit THEN 
                    v_dist_spct := v_dist_spct_limit;
                 END IF;
              END IF;
              v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
              IF v_sum_dist_spct != 100 THEN
                 v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
                 v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
                 v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
                 v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                 v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                 v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
              ELSE
                 v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                 v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
              END IF;
              v_share_cd      := gipi_polbasic_pol_dist_v1_pkg.rg_id(c).share_cd;
              IF v_share_cd = 1 THEN
                 v_rg_net := c;
              END IF;	       
              gipi_polbasic_pol_dist_v1_pkg.rg_id(c).true_pct := v_dist_spct;
              gipi_polbasic_pol_dist_v1_pkg.rg_selection.EXTEND(1);
              gipi_polbasic_pol_dist_v1_pkg.rg_selection(gipi_polbasic_pol_dist_v1_pkg.rg_selection.COUNT) := gipi_polbasic_pol_dist_v1_pkg.rg_id(c);  
              INSERT_TO_POLICYDS_DTL;
            END LOOP;
            --beth 04272001 if after insert of all default share and record is not 
            --     yet distributed 100% then the remaining portion would be assign 
            --     to share of NET RETENTION instead of FACUL        
            IF v_sum_dist_spct != 100 THEN
               v_dist_spct    := 100            - v_sum_dist_spct;
               v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
               v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
               v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
               v_share_cd     := '1';
               --beth 04272001 if NET RET is not yet used
               --     insert it to record group for default share           
               IF v_rg_net IS NULL THEN
                  p_rg_count     := p_rg_count + 1;
                  gipi_polbasic_pol_dist_v1_pkg.rg_count := gipi_polbasic_pol_dist_v1_pkg.rg_count + 1;
                  gipi_polbasic_pol_dist_v1_pkg.rg_id.EXTEND(1);
                  gipi_polbasic_pol_dist_v1_pkg.rg_id(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT).share_cd := 1;
                  gipi_polbasic_pol_dist_v1_pkg.rg_id(gipi_polbasic_pol_dist_v1_pkg.rg_id.COUNT).true_pct := v_dist_spct;
                  gipi_polbasic_pol_dist_v1_pkg.rg_selection.EXTEND(1);
                  gipi_polbasic_pol_dist_v1_pkg.rg_selection(gipi_polbasic_pol_dist_v1_pkg.rg_selection.COUNT) := gipi_polbasic_pol_dist_v1_pkg.rg_id(p_rg_count);
                  INSERT_TO_POLICYDS_DTL;
               ELSE
                  --beth 04272001 if NET RET is not yet used
                  --     update it's record in default share record group
                  p_rg_count     := v_rg_net;
                  v_dist_spct    :=  v_dist_spct + gipi_polbasic_pol_dist_v1_pkg.rg_id(p_rg_count).true_pct;
                  gipi_polbasic_pol_dist_v1_pkg.rg_id(p_rg_count).true_pct := v_dist_spct;
                  gipi_polbasic_pol_dist_v1_pkg.rg_selection.EXTEND(1);
                  gipi_polbasic_pol_dist_v1_pkg.rg_selection(gipi_polbasic_pol_dist_v1_pkg.rg_selection.COUNT) := gipi_polbasic_pol_dist_v1_pkg.rg_id(p_rg_count);
                  UPDATE giuw_policyds_dtl
                     SET dist_spct = dist_spct + v_dist_spct,
                         dist_tsi  = dist_tsi + v_dist_tsi,
                         dist_prem = dist_prem + v_dist_prem,
                         ann_dist_tsi = ann_dist_tsi + v_ann_dist_tsi
                   WHERE dist_no = p_dist_no      
                     AND dist_seq_no = p_dist_seq_no
                     AND line_cd = p_line_cd
                     AND share_cd = v_share_cd;
               END IF;                 
            END IF;
         END IF;
      END IF;   
    END;

    PROCEDURE CREATE_GRP_DFLT_ITEMDS999
             (p_dist_no		    IN giuw_itemds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN giuw_itemds_dtl.dist_seq_no%TYPE  ,
              p_item_no		    IN giuw_itemds_dtl.item_no%TYPE      ,
              p_line_cd		    IN giuw_itemds_dtl.line_cd%TYPE      ,
              p_dist_tsi		IN giuw_itemds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN giuw_itemds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN giuw_itemds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN NUMBER) IS
      v_selection_count			        NUMBER;
      v_dist_spct						giuw_itemds_dtl.dist_spct%TYPE;
      v_dist_tsi						giuw_itemds_dtl.dist_tsi%TYPE;
      v_dist_prem						giuw_itemds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi				    giuw_itemds_dtl.ann_dist_tsi%TYPE;
      v_share_cd						giis_dist_share.share_cd%TYPE;
      v_sum_dist_tsi				    giuw_itemds_dtl.dist_tsi%TYPE     := 0;
      v_sum_dist_spct				    giuw_itemds_dtl.dist_spct%TYPE    := 0;
      v_sum_dist_prem				    giuw_itemds_dtl.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi		        giuw_itemds_dtl.ann_dist_tsi%TYPE := 0;
      net_ret_sw                        VARCHAR2(1);

      PROCEDURE INSERT_TO_ITEMDS_DTL IS
      BEGIN
        INSERT INTO  giuw_itemds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , item_no)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_item_no);
      END;

    BEGIN
      IF p_rg_count = 0 THEN

         /* Create the default distribution records based on the 100%
         ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
         v_share_cd     := 1;
         v_dist_spct    := 100;
         v_dist_tsi     := p_dist_tsi;
         v_dist_prem    := p_dist_prem;
         v_ann_dist_tsi := p_ann_dist_tsi;
         INSERT_TO_ITEMDS_DTL;      
      ELSE
         v_selection_count := gipi_polbasic_pol_dist_v1_pkg.rg_selection.COUNT;

         FOR c IN 1..v_selection_count
         LOOP
           v_dist_spct     := gipi_polbasic_pol_dist_v1_pkg.rg_selection(c).true_pct;
           v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
           IF v_sum_dist_spct != 100 THEN
              v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
              v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
              v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
              v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
              v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
              v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
           ELSE
              v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
              v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
              v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
           END IF;
           v_share_cd     := gipi_polbasic_pol_dist_v1_pkg.rg_selection(c).share_cd;
           INSERT_TO_ITEMDS_DTL;
         END LOOP;

      END IF;   
    END;

    PROCEDURE CREATE_GRP_DFLT_ITEMPERILDS999
             (p_dist_no		    IN giuw_itemperilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN giuw_itemperilds_dtl.dist_seq_no%TYPE  ,
              p_item_no		    IN giuw_itemperilds_dtl.item_no%TYPE      ,
              p_line_cd		    IN giuw_itemperilds_dtl.line_cd%TYPE      ,
              p_peril_cd		IN giuw_itemperilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi		IN giuw_itemperilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN giuw_itemperilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN giuw_itemperilds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN NUMBER) IS
      v_selection_count		NUMBER;
      v_dist_spct			giuw_itemperilds_dtl.dist_spct%TYPE;
      v_dist_tsi			giuw_itemperilds_dtl.dist_tsi%TYPE;
      v_dist_prem			giuw_itemperilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi		giuw_itemperilds_dtl.ann_dist_tsi%TYPE;
      v_share_cd			giis_dist_share.share_cd%TYPE;
      v_sum_dist_tsi		giuw_itemperilds_dtl.dist_tsi%TYPE     := 0;
      v_sum_dist_spct		giuw_itemperilds_dtl.dist_spct%TYPE    := 0;
      v_sum_dist_prem		giuw_itemperilds_dtl.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi		giuw_itemperilds_dtl.ann_dist_tsi%TYPE := 0;

      PROCEDURE INSERT_TO_ITEMPERILDS_DTL IS
      BEGIN
        INSERT INTO  giuw_itemperilds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , item_no       , peril_cd)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_item_no     , p_peril_cd);
      END;

    BEGIN
      IF p_rg_count = 0 THEN

         /* Create the default distribution records based on the 100%
         ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
         v_share_cd     := 1;
         v_dist_spct    := 100;
         v_dist_tsi     := p_dist_tsi;
         v_dist_prem    := p_dist_prem;
         v_ann_dist_tsi := p_ann_dist_tsi;
         INSERT_TO_ITEMPERILDS_DTL;      
      ELSE
         v_selection_count := gipi_polbasic_pol_dist_v1_pkg.rg_selection.COUNT;

         FOR c IN 1..v_selection_count
         LOOP
           v_dist_spct     := gipi_polbasic_pol_dist_v1_pkg.rg_selection(c).true_pct;
           v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
           IF v_sum_dist_spct != 100 THEN
              v_dist_tsi         := ROUND(p_dist_tsi         * v_dist_spct / 100, 2);
              v_dist_prem        := ROUND(p_dist_prem        * v_dist_spct / 100, 2);
              v_ann_dist_tsi     := ROUND(p_ann_dist_tsi     * v_dist_spct / 100, 2);
              v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
              v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
              v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
           ELSE
              v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
              v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
              v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
           END IF;
           v_share_cd     := gipi_polbasic_pol_dist_v1_pkg.rg_selection(c).share_cd;
           INSERT_TO_ITEMPERILDS_DTL;
         END LOOP;

      END IF;   
    END;

    /**
    ** Created by:      Niknok Orio 
    ** Date Created:    08 15, 2011 
    ** Reference by:    GIUTS999 - Populate missing distribution records 
    ** Description :    
    **/
    PROCEDURE CREATE_GRP_DFLT_DIST999(p_dist_no        IN giuw_policyds.dist_no%TYPE,
                                   p_dist_seq_no    IN giuw_policyds.dist_seq_no%TYPE,
                                   p_dist_flag      IN giuw_pol_dist.dist_flag%TYPE,
                                   p_policy_tsi     IN giuw_policyds.tsi_amt%TYPE,
                                   p_policy_premium IN giuw_policyds.prem_amt%TYPE,
                                   p_policy_ann_tsi IN giuw_policyds.ann_tsi_amt%TYPE,
                                   p_item_grp       IN giuw_policyds.item_grp%TYPE,
                                   p_line_cd        IN giis_line.line_cd%TYPE,
                                   p_rg_count       IN OUT NUMBER,
                                   p_default_type   IN giis_default_dist.default_type%TYPE,
                                   p_currency_rt    IN gipi_item.currency_rt%TYPE,
                                   p_policy_id      IN gipi_polbasic.policy_id%TYPE) IS

      v_peril_cd                        giis_peril.peril_cd%TYPE;
      v_peril_tsi		              	giuw_perilds.tsi_amt%TYPE       := 0;
      v_peril_premium		            giuw_perilds.prem_amt%TYPE      := 0;
      v_peril_ann_tsi	            	giuw_perilds.ann_tsi_amt%TYPE   := 0;
      v_exist			                VARCHAR2(1)                     := 'N';
      v_insert_sw			            VARCHAR2(1)                     := 'N';

      /* Updates the amounts of the previously processed PERIL_CD
      ** while looping inside cursor C3.  After which, the records
      ** for table GIUW_PERILDS_DTL are also created.
      ** NOTE:  This is a LOCAL PROCEDURE BODY called below. */
      PROCEDURE  UPD_CREATE_PERIL_DTL_DATA IS
      BEGIN
        UPDATE giuw_perilds
           SET tsi_amt     = v_peril_tsi     ,
               prem_amt    = v_peril_premium ,
               ann_tsi_amt = v_peril_ann_tsi
         WHERE peril_cd    = v_peril_cd
           AND line_cd     = p_line_cd
           AND dist_seq_no = p_dist_seq_no
           AND dist_no     = p_dist_no;
        GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_PERILDS999
              (p_dist_no       , p_dist_seq_no , p_line_cd       ,
               v_peril_cd      , v_peril_tsi   , v_peril_premium ,
               v_peril_ann_tsi , p_rg_count);
      END;

    BEGIN
      /* Create records in table GIUW_POLICYDS and GIUW_POLICYDS_DTL
      ** for the specified DIST_SEQ_NO. */
      INSERT INTO giuw_policyds
                  (dist_no      , dist_seq_no      , 
                   tsi_amt      , prem_amt         , ann_tsi_amt      ,
                   item_grp)
           VALUES (p_dist_no    , p_dist_seq_no    ,
                   p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                   p_item_grp);
      
      GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_POLICYDS999
                  (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
                   p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                   p_rg_count   , p_default_type   , p_currency_rt    ,
                   p_policy_id  , p_item_grp);
      /* Get the amounts for each item in table GIPI_ITEM in preparation
      ** for data insertion to its corresponding distribution tables. */
      FOR c2 IN (SELECT a.item_no     , a.tsi_amt , a.prem_amt ,
                        a.ann_tsi_amt
                   FROM gipi_item a
                  WHERE exists( SELECT '1'
                                  FROM gipi_itmperil b
                                 WHERE b.policy_id = a.policy_id
                                   AND b.item_no = a.item_no)
                    AND a.item_grp  = p_item_grp
                    AND a.policy_id = p_policy_id)
      LOOP
        /* Create records in table GIUW_ITEMDS and GIUW_ITEMDS_DTL
        ** for the specified DIST_SEQ_NO. */
        INSERT INTO  giuw_itemds
                    (dist_no        , dist_seq_no   , item_no        ,
                     tsi_amt        , prem_amt      , ann_tsi_amt)
             VALUES (p_dist_no      , p_dist_seq_no , c2.item_no     ,
                     c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);
        GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_ITEMDS999
                    (p_dist_no      , p_dist_seq_no , c2.item_no  ,
                     p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
                     c2.ann_tsi_amt , p_rg_count);
      END LOOP;
      
      /* Initialize the value of the variables
      ** in preparation for processing the new
      ** DIST_SEQ_NO. */
      v_peril_cd      := NULL;
      v_peril_tsi     := 0;
      v_peril_premium := 0;
      v_peril_ann_tsi := 0;   
      v_exist         := 'N';
      
      /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
      ** in table GIPI_ITMPERIL in preparation for data insertion to 
      ** distribution tables GIUW_ITEMPERILDS, GIUW_ITEMPERILDS_DTL,
      ** GIUW_PERILDS and GIUW_PERILDS_DTL. */
      FOR c3 IN (  SELECT B380.tsi_amt     itmperil_tsi     ,
                          B380.prem_amt    itmperil_premium ,
                          B380.ann_tsi_amt itmperil_ann_tsi ,
                          B380.item_no     item_no          ,
                          B380.peril_cd    peril_cd
                     FROM gipi_itmperil B380, gipi_item B340
                    WHERE B380.item_no   = B340.item_no
                      AND B380.policy_id = B340.policy_id
                      AND B340.item_grp  = p_item_grp
                      AND B340.policy_id = p_policy_id
                 ORDER BY B380.peril_cd)
      LOOP
        v_exist     := 'Y';
        /* Create records in table GIUW_ITEMPERILDS and GIUW_ITEMPERILDS_DTL
        ** for the specified DIST_SEQ_NO. */
        INSERT INTO  giuw_itemperilds  
                    (dist_no             , dist_seq_no   , item_no         ,
                     peril_cd            , line_cd       , tsi_amt         ,
                     prem_amt            , ann_tsi_amt)
             VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                     c3.peril_cd         , p_line_cd     , c3.itmperil_tsi , 
                     c3.itmperil_premium , c3.itmperil_ann_tsi);
        GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_ITEMPERILDS999
                    (p_dist_no           , p_dist_seq_no       , c3.item_no      ,
                     p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                     c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count);
        /* Create the newly processed PERIL_CD in table
        ** GIUW_PERILDS. */
        IF v_peril_cd IS NULL THEN
           v_peril_cd     := c3.peril_cd;
           v_insert_sw    := 'Y';
        END IF;
        /* Check if the value of the previously processed
        ** PERIL_CD is equal to the one currently processed.
        ** Should the two be unequal, then the amounts of
        ** the previously processed PERIL_CD must be updated
        ** to reflect the true value of each field for the
        ** specified PERIL_CD.  After the amounts of the specified
        ** PERIL_CD have been updated, then that's the time to
        ** create the records in table GIUW_PERILDS_DTL.
        ** On the other hand, if the value of the two PERIL_CDs
        ** are equal, then the amounts of the currently processed
        ** record is added along with the amounts of the previously
        ** processed records of the same PERIL_CD.  Such amounts
        ** shall be used later on when the two PERIL_CDs become
        ** unequal. */
        IF v_peril_cd != c3.peril_cd THEN
           /* Updates the amounts of the previously processed PERIL_CD.
           ** After which, the records for table GIUW_PERILDS_DTL are
           ** also created. */
           UPD_CREATE_PERIL_DTL_DATA;
           /* Assigns the new PERIL_CD to the V_PERIL_CD
           ** variable in preparation for data creation
           ** in table GIUW_PERILDS. */
           v_peril_cd      := c3.peril_cd;
           v_peril_tsi     := c3.itmperil_tsi;
           v_peril_premium := c3.itmperil_premium;
           v_peril_ann_tsi := c3.itmperil_ann_tsi;
           v_insert_sw     := 'Y';
        ELSIF v_peril_cd = c3.peril_cd THEN
           v_peril_tsi     := v_peril_tsi     + c3.itmperil_tsi;
           v_peril_premium := v_peril_premium + c3.itmperil_premium;
           v_peril_ann_tsi := v_peril_ann_tsi + c3.itmperil_ann_tsi;
        END IF;
        IF v_insert_sw = 'Y' THEN
           INSERT INTO  giuw_perilds  
                       (dist_no   , dist_seq_no   , peril_cd         ,
                        line_cd   , tsi_amt       , prem_amt         ,
                        ann_tsi_amt)
                VALUES (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                        p_line_cd , v_peril_tsi   , v_peril_premium  ,
                        v_peril_ann_tsi);
           v_insert_sw     := 'N';
        END IF;
      END LOOP;
      IF v_exist = 'Y' THEN
         /* Updates the amounts of the last processed PERIL_CD.
         ** After which, its corresponding records for table 
         ** GIUW_PERILDS_DTL are also created.
         ** NOTE:  This was done so, because the last processed
         **        PERIL_CD is no longer handled by the C3 loop. */
         UPD_CREATE_PERIL_DTL_DATA;
      END IF;
    END;

    PROCEDURE CREATE_GRP_DFLT_PERILDS_RI999
             (p_dist_no		    IN giuw_perilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN giuw_perilds_dtl.dist_seq_no%TYPE  ,
              p_line_cd		    IN giuw_perilds_dtl.line_cd%TYPE      ,
              p_peril_cd		IN giuw_perilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi		IN giuw_perilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN giuw_perilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN giuw_perilds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN NUMBER,
              p_fac_spct        IN  giri_distfrps.tot_fac_spct%TYPE) IS
      v_dist_spct			giuw_perilds_dtl.dist_spct%TYPE;
      v_dist_tsi			giuw_perilds_dtl.dist_tsi%TYPE;
      v_dist_prem			giuw_perilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi		giuw_perilds_dtl.ann_dist_tsi%TYPE;
      v_share_cd			giis_dist_share.share_cd%TYPE;

      PROCEDURE INSERT_TO_PERILDS_DTL IS
      BEGIN
        INSERT INTO  giuw_perilds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , peril_cd)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_peril_cd);
      END;

    BEGIN
        v_share_cd     := 999;
      v_dist_spct    := p_fac_spct;
      v_dist_tsi     := p_dist_tsi      * (p_fac_spct/100);
      v_dist_prem    := p_dist_prem     * (p_fac_spct/100);
      v_ann_dist_tsi := p_ann_dist_tsi * (p_fac_spct/100);
      INSERT_TO_PERILDS_DTL;
      v_share_cd     := 1;
      v_dist_spct    := 100            - v_dist_spct;
      v_dist_prem    := p_dist_prem    - v_dist_prem;
      v_ann_dist_tsi := p_ann_dist_tsi - v_ann_dist_tsi;
      v_dist_tsi     := p_dist_tsi     - v_dist_tsi;
      INSERT_TO_PERILDS_DTL;
    END;

    PROCEDURE CREATE_GRP_DFLT_POLICYDS_RI999
             (p_dist_no	   	    IN  giuw_policyds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN  giuw_policyds_dtl.dist_seq_no%TYPE  ,
              p_line_cd		    IN  giuw_policyds_dtl.line_cd%TYPE      ,
              p_dist_tsi	    IN  giuw_policyds_dtl.dist_tsi%TYPE     ,
              p_dist_prem	    IN  giuw_policyds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN  giuw_policyds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count	    IN  OUT NUMBER                           ,
              p_default_type	IN  giis_default_dist.default_type%TYPE  ,
              p_currency_rt     IN  gipi_item.currency_rt%TYPE          ,
              p_policy_id       IN  gipi_polbasic.policy_id%TYPE         ,
              p_item_grp	    IN  gipi_item.item_grp%TYPE,
              p_fac_spct        IN  giri_distfrps.tot_fac_spct%TYPE,
              p_fac_tsi         IN  giri_distfrps.tot_fac_tsi%TYPE,
              p_fac_prem        IN  giri_distfrps.tot_fac_prem%TYPE) IS

      v_dist_spct			giuw_policyds_dtl.dist_spct%TYPE;
      v_dist_tsi			giuw_policyds_dtl.dist_tsi%TYPE;
      v_dist_prem			giuw_policyds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi		giuw_policyds_dtl.ann_dist_tsi%TYPE;
      v_share_cd			giis_dist_share.share_cd%TYPE;
      PROCEDURE INSERT_TO_POLICYDS_DTL IS
      BEGIN
        INSERT INTO  giuw_policyds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1);
      END;

    BEGIN
        v_share_cd     := 999;
      v_dist_spct    := p_fac_spct;
      v_dist_tsi     := p_fac_tsi;
      v_dist_prem    := p_fac_prem;
      v_ann_dist_tsi := p_ann_dist_tsi * (p_fac_spct/100);
      INSERT_TO_POLICYDS_DTL;      
      v_share_cd     := 1;
      v_dist_spct    := 100            - v_dist_spct;
      v_dist_prem    := p_dist_prem    - v_dist_prem;
      v_ann_dist_tsi := p_ann_dist_tsi - v_ann_dist_tsi;
      v_dist_tsi     := p_dist_tsi     - v_dist_tsi;
      INSERT_TO_POLICYDS_DTL;        
    END;

    PROCEDURE CREATE_GRP_DFLT_ITEMDS_RI999
             (p_dist_no		    IN giuw_itemds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN giuw_itemds_dtl.dist_seq_no%TYPE  ,
              p_item_no		    IN giuw_itemds_dtl.item_no%TYPE      ,
              p_line_cd		    IN giuw_itemds_dtl.line_cd%TYPE      ,
              p_dist_tsi		IN giuw_itemds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN giuw_itemds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN giuw_itemds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN NUMBER,
              p_fac_spct        IN  giri_distfrps.tot_fac_spct%TYPE) IS

      v_dist_spct			giuw_itemds_dtl.dist_spct%TYPE;
      v_dist_tsi			giuw_itemds_dtl.dist_tsi%TYPE;
      v_dist_prem			giuw_itemds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi		giuw_itemds_dtl.ann_dist_tsi%TYPE;
      v_share_cd			giis_dist_share.share_cd%TYPE;


      PROCEDURE INSERT_TO_ITEMDS_DTL IS
      BEGIN
        INSERT INTO  giuw_itemds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , item_no)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_item_no);
      END;

    BEGIN
      v_share_cd     := 999;
      v_dist_spct    := p_fac_spct;
      v_dist_tsi     := p_dist_tsi      * (p_fac_spct/100);
      v_dist_prem    := p_dist_prem     * (p_fac_spct/100);
      v_ann_dist_tsi := p_ann_dist_tsi * (p_fac_spct/100);
      INSERT_TO_ITEMDS_DTL;      
      v_share_cd     := 1;
      v_dist_spct    := 100            - v_dist_spct;
      v_dist_prem    := p_dist_prem    - v_dist_prem;
      v_ann_dist_tsi := p_ann_dist_tsi - v_ann_dist_tsi;
      v_dist_tsi     := p_dist_tsi     - v_dist_tsi;
      INSERT_TO_ITEMDS_DTL;        
    END;

    PROCEDURE CREATE_GRP_DFLT_ITEMPERILDS_RI
             (p_dist_no		    IN giuw_itemperilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN giuw_itemperilds_dtl.dist_seq_no%TYPE  ,
              p_item_no		    IN giuw_itemperilds_dtl.item_no%TYPE      ,
              p_line_cd		    IN giuw_itemperilds_dtl.line_cd%TYPE      ,
              p_peril_cd		IN giuw_itemperilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi		IN giuw_itemperilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN giuw_itemperilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN giuw_itemperilds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN NUMBER,
              p_fac_spct        IN  giri_distfrps.tot_fac_spct%TYPE) IS

      v_dist_spct			giuw_itemperilds_dtl.dist_spct%TYPE;
      v_dist_tsi			giuw_itemperilds_dtl.dist_tsi%TYPE;
      v_dist_prem			giuw_itemperilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi		giuw_itemperilds_dtl.ann_dist_tsi%TYPE;
      v_share_cd			giis_dist_share.share_cd%TYPE;
      PROCEDURE INSERT_TO_ITEMPERILDS_DTL IS
      BEGIN
        INSERT INTO  giuw_itemperilds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , item_no       , peril_cd)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_item_no     , p_peril_cd);
      END;

    BEGIN
      v_share_cd     := 999;
      v_dist_spct    := p_fac_spct;
      v_dist_tsi     := p_dist_tsi      * (p_fac_spct/100);
      v_dist_prem    := p_dist_prem     * (p_fac_spct/100);
      v_ann_dist_tsi := p_ann_dist_tsi * (p_fac_spct/100);
      INSERT_TO_ITEMPERILDS_DTL;
      v_share_cd     := 1;
      v_dist_spct    := 100            - v_dist_spct;
      v_dist_prem    := p_dist_prem    - v_dist_prem;
      v_ann_dist_tsi := p_ann_dist_tsi - v_ann_dist_tsi;
      v_dist_tsi     := p_dist_tsi     - v_dist_tsi;
      INSERT_TO_ITEMPERILDS_DTL;           
    END;

    /**
    ** Created by:      Niknok Orio 
    ** Date Created:    08 15, 2011 
    ** Reference by:    GIUTS999 - Populate missing distribution records 
    ** Description :    for distribution with RI records 
    **                  distribtuion records would be recreated by getting FACUL share
    **                  from table giri_distfrps for each seq_no 
    **/   
    PROCEDURE CREATE_GRP_DFLT_DIST_RI999(p_dist_no        IN giuw_policyds.dist_no%TYPE,
                                   p_dist_seq_no    IN giuw_policyds.dist_seq_no%TYPE,
                                   p_dist_flag      IN giuw_pol_dist.dist_flag%TYPE,
                                   p_policy_tsi     IN giuw_policyds.tsi_amt%TYPE,
                                   p_policy_premium IN giuw_policyds.prem_amt%TYPE,
                                   p_policy_ann_tsi IN giuw_policyds.ann_tsi_amt%TYPE,
                                   p_item_grp       IN giuw_policyds.item_grp%TYPE,
                                   p_line_cd        IN giis_line.line_cd%TYPE,
                                   p_rg_count       IN OUT NUMBER,
                                   p_default_type   IN giis_default_dist.default_type%TYPE,
                                   p_currency_rt    IN gipi_item.currency_rt%TYPE,
                                   p_policy_id      IN gipi_polbasic.policy_id%TYPE) IS

      v_peril_cd                        giis_peril.peril_cd%TYPE;
      v_peril_tsi		              	giuw_perilds.tsi_amt%TYPE      := 0;
      v_peril_premium		            giuw_perilds.prem_amt%TYPE     := 0;
      v_peril_ann_tsi	            	giuw_perilds.ann_tsi_amt%TYPE  := 0;
      v_exist			                VARCHAR2(1)                     := 'N';
      v_insert_sw			            VARCHAR2(1)                     := 'N';
      v_fac_spct                        giri_distfrps.tot_fac_spct%TYPE; 
      v_fac_tsi                         giri_distfrps.tot_fac_tsi%TYPE;
      v_fac_prem                        giri_distfrps.tot_fac_prem%TYPE;
      ri_exists                         VARCHAR2(1); --switch to detemine if dist_seq_no has RI
      /* Updates the amounts of the previously processed PERIL_CD
      ** while looping inside cursor C3.  After which, the records
      ** for table GIUW_PERILDS_DTL are also created.
      ** NOTE:  This is a LOCAL PROCEDURE BODY called below. */
      PROCEDURE  UPD_CREATE_PERIL_DTL_DATA IS
      BEGIN
        UPDATE giuw_perilds
           SET tsi_amt     = v_peril_tsi     ,
               prem_amt    = v_peril_premium ,
               ann_tsi_amt = v_peril_ann_tsi
         WHERE peril_cd    = v_peril_cd
           AND line_cd     = p_line_cd
           AND dist_seq_no = p_dist_seq_no
           AND dist_no     = p_dist_no;
        IF ri_exists = 'N' THEN   
           GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_PERILDS999
              (p_dist_no       , p_dist_seq_no , p_line_cd       ,
               v_peril_cd      , v_peril_tsi   , v_peril_premium ,
               v_peril_ann_tsi , p_rg_count);
        ELSE       
           GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_PERILDS_RI999
              (p_dist_no       , p_dist_seq_no , p_line_cd       ,
               v_peril_cd      , v_peril_tsi   , v_peril_premium ,
               v_peril_ann_tsi , p_rg_count    , v_fac_spct);
        END IF;            
      END;

    BEGIN
      ri_exists := 'N';
      FOR A IN (SELECT tot_fac_spct, 
                       tot_fac_prem,
                       tot_fac_tsi
                  FROM giri_distfrps
                 WHERE dist_no = p_dist_no
                   AND dist_seq_no = p_dist_seq_no)
      LOOP
        v_fac_spct := a.tot_fac_spct;
        v_fac_prem := a.tot_fac_prem;
        v_fac_tsi  := a.tot_fac_tsi;
        ri_exists  := 'Y';
      END LOOP;	              
      /* Create records in table GIUW_POLICYDS and GIUW_POLICYDS_DTL
      ** for the specified DIST_SEQ_NO. */
      IF ri_exists = 'N' THEN
         GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_POLICYDS999
                  (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
                   p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                   p_rg_count   , p_default_type   , p_currency_rt    ,
                   p_policy_id  , p_item_grp);
      ELSE
         GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_POLICYDS_RI999
                  (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
                   p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                   p_rg_count   , p_default_type   , p_currency_rt    ,
                   p_policy_id  , p_item_grp       , v_fac_spct       ,
                   v_fac_tsi    , v_fac_prem);
      END IF;             
      /* Get the amounts for each item in table GIPI_ITEM in preparation
      ** for data insertion to its corresponding distribution tables. */
      FOR c2 IN (SELECT a.item_no     , a.tsi_amt , a.prem_amt ,
                        a.ann_tsi_amt
                   FROM gipi_item a
                  WHERE exists( SELECT '1'
                                  FROM gipi_itmperil b
                                 WHERE b.policy_id = a.policy_id
                                   AND b.item_no = a.item_no)
                    AND a.item_grp  = p_item_grp
                    AND a.policy_id = p_policy_id)
      LOOP
        /* Create records in table GIUW_ITEMDS and GIUW_ITEMDS_DTL
        ** for the specified DIST_SEQ_NO. */
        INSERT INTO  giuw_itemds
                    (dist_no        , dist_seq_no   , item_no        ,
                     tsi_amt        , prem_amt      , ann_tsi_amt)
             VALUES (p_dist_no      , p_dist_seq_no , c2.item_no     ,
                     c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);
        IF ri_exists = 'N' THEN                 
           GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_ITEMDS999
                    (p_dist_no      , p_dist_seq_no , c2.item_no  ,
                     p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
                     c2.ann_tsi_amt , p_rg_count);
        ELSE
           GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_ITEMDS_RI999
                    (p_dist_no      , p_dist_seq_no , c2.item_no  ,
                     p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
                     c2.ann_tsi_amt , p_rg_count    , v_fac_spct);
        END IF;             
      END LOOP;
      
      /* Initialize the value of the variables
      ** in preparation for processing the new
      ** DIST_SEQ_NO. */
      v_peril_cd      := NULL;
      v_peril_tsi     := 0;
      v_peril_premium := 0;
      v_peril_ann_tsi := 0;   
      v_exist         := 'N';
      
      /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
      ** in table GIPI_ITMPERIL in preparation for data insertion to 
      ** distribution tables GIUW_ITEMPERILDS, GIUW_ITEMPERILDS_DTL,
      ** GIUW_PERILDS and GIUW_PERILDS_DTL. */
      FOR c3 IN (  SELECT B380.tsi_amt     itmperil_tsi     ,
                          B380.prem_amt    itmperil_premium ,
                          B380.ann_tsi_amt itmperil_ann_tsi ,
                          B380.item_no     item_no          ,
                          B380.peril_cd    peril_cd
                     FROM gipi_itmperil B380, gipi_item B340
                    WHERE B380.item_no   = B340.item_no
                      AND B380.policy_id = B340.policy_id
                      AND B340.item_grp  = p_item_grp
                      AND B340.policy_id = p_policy_id
                 ORDER BY B380.peril_cd)
      LOOP
        v_exist     := 'Y';
        /* Create records in table GIUW_ITEMPERILDS and GIUW_ITEMPERILDS_DTL
        ** for the specified DIST_SEQ_NO. */
        INSERT INTO  giuw_itemperilds  
                    (dist_no             , dist_seq_no   , item_no         ,
                     peril_cd            , line_cd       , tsi_amt         ,
                     prem_amt            , ann_tsi_amt)
             VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                     c3.peril_cd         , p_line_cd     , c3.itmperil_tsi , 
                     c3.itmperil_premium , c3.itmperil_ann_tsi);
        IF ri_exists = 'N' THEN             
             GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_ITEMPERILDS999
                    (p_dist_no           , p_dist_seq_no       , c3.item_no      ,
                     p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                     c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count);
        ELSE
             GIUW_POL_DIST_FINAL_PKG.CREATE_GRP_DFLT_ITEMPERILDS_RI
                    (p_dist_no           , p_dist_seq_no       , c3.item_no      ,
                     p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                     c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count      ,
                     v_fac_spct);
        END IF;                 
        /* Create the newly processed PERIL_CD in table
        ** GIUW_PERILDS. */
        IF v_peril_cd IS NULL THEN
           v_peril_cd     := c3.peril_cd;
           v_insert_sw    := 'Y';
        END IF;
        /* Check if the value of the previously processed
        ** PERIL_CD is equal to the one currently processed.
        ** Should the two be unequal, then the amounts of
        ** the previously processed PERIL_CD must be updated
        ** to reflect the true value of each field for the
        ** specified PERIL_CD.  After the amounts of the specified
        ** PERIL_CD have been updated, then that's the time to
        ** create the records in table GIUW_PERILDS_DTL.
        ** On the other hand, if the value of the two PERIL_CDs
        ** are equal, then the amounts of the currently processed
        ** record is added along with the amounts of the previously
        ** processed records of the same PERIL_CD.  Such amounts
        ** shall be used later on when the two PERIL_CDs become
        ** unequal. */
        IF v_peril_cd != c3.peril_cd THEN
           /* Updates the amounts of the previously processed PERIL_CD.
           ** After which, the records for table GIUW_PERILDS_DTL are
           ** also created. */
           UPD_CREATE_PERIL_DTL_DATA;
           /* Assigns the new PERIL_CD to the V_PERIL_CD
           ** variable in preparation for data creation
           ** in table GIUW_PERILDS. */
           v_peril_cd      := c3.peril_cd;
           v_peril_tsi     := c3.itmperil_tsi;
           v_peril_premium := c3.itmperil_premium;
           v_peril_ann_tsi := c3.itmperil_ann_tsi;
           v_insert_sw     := 'Y';
        ELSIF v_peril_cd = c3.peril_cd THEN
           v_peril_tsi     := v_peril_tsi     + c3.itmperil_tsi;
           v_peril_premium := v_peril_premium + c3.itmperil_premium;
           v_peril_ann_tsi := v_peril_ann_tsi + c3.itmperil_ann_tsi;
        END IF;
        IF v_insert_sw = 'Y' THEN
           INSERT INTO  giuw_perilds  
                       (dist_no   , dist_seq_no   , peril_cd         ,
                        line_cd   , tsi_amt       , prem_amt         ,
                        ann_tsi_amt)
                VALUES (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                        p_line_cd , v_peril_tsi   , v_peril_premium  ,
                        v_peril_ann_tsi);
           v_insert_sw     := 'N';
        END IF;
      END LOOP;
      IF v_exist = 'Y' THEN
         /* Updates the amounts of the last processed PERIL_CD.
         ** After which, its corresponding records for table 
         ** GIUW_PERILDS_DTL are also created.
         ** NOTE:  This was done so, because the last processed
         **        PERIL_CD is no longer handled by the C3 loop. */
         UPD_CREATE_PERIL_DTL_DATA;
      END IF;
    END;
    
    PROCEDURE CREATE_PERIL_DFLT_ITEMPERILDS
             (p_dist_no       IN giuw_perilds_dtl.dist_no%TYPE,
              p_dist_seq_no   IN giuw_perilds_dtl.dist_seq_no%TYPE,
              p_line_cd       IN giuw_perilds_dtl.line_cd%TYPE,
              p_peril_cd      IN giuw_perilds_dtl.peril_cd%TYPE,
              p_share_cd      IN giuw_perilds_dtl.share_cd%TYPE,
              p_dist_spct     IN giuw_perilds_dtl.dist_spct%TYPE,
              p_ann_dist_spct IN giuw_perilds_dtl.ann_dist_spct%TYPE) IS

      v_dist_tsi                 giuw_itemperilds_dtl.dist_tsi%TYPE;
      v_dist_prem                giuw_itemperilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi             giuw_itemperilds_dtl.ann_dist_tsi%TYPE;

    BEGIN
      FOR c2 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt ,
                        item_no
                   FROM giuw_itemperilds
                  WHERE peril_cd    = p_peril_cd
                    AND line_cd     = p_line_cd
                    AND dist_seq_no = p_dist_seq_no
                    AND dist_no     = p_dist_no)
      LOOP

        /* Multiply the percentage values of table GIUW_PERILDS_DTL
        ** with the values of columns belonging to table GIUW_ITEMPERILDS,
        ** to arrive at the correct break down of values in table
        ** GIUW_ITEMPERILDS_DTL. */
        v_dist_tsi     := ROUND(p_dist_spct/100     * c2.tsi_amt, 2);
        v_dist_prem    := ROUND(p_dist_spct/100     * c2.prem_amt, 2);
        v_ann_dist_tsi := ROUND(p_ann_dist_spct/100 * c2.ann_tsi_amt, 2);

        INSERT INTO  giuw_itemperilds_dtl
                    (dist_no         , dist_seq_no    , item_no     ,
                     line_cd         , peril_cd       , share_cd    ,
                     dist_spct       , dist_tsi       , dist_prem   ,
                     ann_dist_spct   , ann_dist_tsi   , dist_grp)
             VALUES (p_dist_no       , p_dist_seq_no  , c2.item_no  ,
                     p_line_cd       , p_peril_cd     , p_share_cd  ,
                     p_dist_spct     , v_dist_tsi     , v_dist_prem ,
                     p_ann_dist_spct , v_ann_dist_tsi , 1);

      END LOOP;
    END;    
    
    PROCEDURE CREATE_PERIL_DFLT_PERILDS
             (p_dist_no         IN giuw_perilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no     IN giuw_perilds_dtl.dist_seq_no%TYPE  ,
              p_line_cd         IN giuw_perilds_dtl.line_cd%TYPE      ,
              p_peril_cd        IN giuw_perilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi        IN giuw_perilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem       IN giuw_perilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi    IN giuw_perilds_dtl.ann_dist_tsi%TYPE ,
              p_currency_rt     IN gipi_invoice.currency_rt%TYPE      ,
              p_default_no      IN giis_default_dist.default_no%TYPE   ,
              p_default_type    IN giis_default_dist.default_type%TYPE ,
              p_dflt_netret_pct IN giis_default_dist.dflt_netret_pct%TYPE) IS

      v_dflt_dist_exist						VARCHAR2(1) := 'N';
      v_dist_spct									giuw_perilds_dtl.dist_spct%TYPE;
      v_dist_tsi									giuw_perilds_dtl.dist_tsi%TYPE;
      v_dist_prem									giuw_perilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi							giuw_perilds_dtl.ann_dist_tsi%TYPE;
      v_share_cd									giis_dist_share.share_cd%TYPE;
      v_sum_dist_tsi							giuw_perilds_dtl.dist_tsi%TYPE     := 0;
      v_sum_dist_spct							giuw_perilds_dtl.dist_spct%TYPE    := 0;
      v_sum_dist_prem							giuw_perilds_dtl.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi					giuw_perilds_dtl.ann_dist_tsi%TYPE := 0;
      v_dist_spct_limit						NUMBER;
      v_remaining_tsi             NUMBER := p_dist_tsi * p_currency_rt;
      net_ret_sw                  VARCHAR2(1);

      CURSOR dist_peril_cur IS
          SELECT a.share_cd , a.share_pct , a.share_amt1
            FROM giis_default_dist_peril a 
           WHERE a.default_no = p_default_no
             AND a.line_cd    = p_line_cd
             AND a.peril_cd   = p_peril_cd
             AND a.share_cd   <> 999
        ORDER BY a.sequence ASC;

      PROCEDURE INSERT_TO_PERILDS_DTL IS
      BEGIN
        INSERT INTO  giuw_perilds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , peril_cd)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_peril_cd);
        GIUW_POL_DIST_FINAL_PKG.CREATE_PERIL_DFLT_ITEMPERILDS
              (p_dist_no  , p_dist_seq_no , p_line_cd   ,
               p_peril_cd , v_share_cd    , v_dist_spct ,  
               v_dist_spct);
      END;

    BEGIN

      /* Use AMOUNTS to create the default distribution records. */
      IF p_default_type = 1 THEN
         FOR c1 IN dist_peril_cur
         LOOP
           v_dflt_dist_exist := 'Y';
           IF v_remaining_tsi >= c1.share_amt1 THEN
              v_dist_tsi      := c1.share_amt1 / p_currency_rt;
              v_remaining_tsi := v_remaining_tsi - c1.share_amt1;
           ELSE
              v_remaining_tsi := 0;
           END IF;
           IF v_remaining_tsi != 0 THEN
              v_dist_spct        := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
              v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
              v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
              v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
              v_sum_dist_spct    := v_sum_dist_spct    + v_dist_spct;
              v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
              v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
              v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
           ELSIF v_remaining_tsi = 0 THEN
              v_dist_spct    := 100            - v_sum_dist_spct;
              v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
              v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
              v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
           END IF;
           v_share_cd := c1.share_cd;
           INSERT_TO_PERILDS_DTL;
           IF v_remaining_tsi = 0 THEN
              EXIT;
           END IF;
         END LOOP;
         IF v_remaining_tsi  != 0   AND
            v_dflt_dist_exist = 'Y' THEN
            v_dist_spct    := 100            - v_sum_dist_spct;
            v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
            v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
            v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
            v_share_cd     := 1;
            net_ret_sw     := 'N';
            FOR A IN (SELECT '1'
                        FROM giuw_perilds_dtl
                       WHERE dist_no = p_dist_no
                         AND dist_seq_no = p_dist_seq_no
                         AND line_cd = p_line_cd
                         AND share_cd = v_share_cd
                         AND peril_cd = p_peril_cd)
            LOOP              
                net_ret_sw := 'Y';
            END LOOP;	
            IF net_ret_sw = 'N' THEN	
               INSERT_TO_PERILDS_DTL;
            ELSE
                 UPDATE giuw_perilds_dtl
                    SET dist_spct = dist_spct + v_dist_spct,
                        dist_tsi  = dist_tsi  + v_dist_tsi,
                        dist_prem = dist_prem + v_dist_prem,
                        ann_dist_tsi  = ann_dist_tsi  + v_ann_dist_tsi
                            WHERE dist_no = p_dist_no
                  AND dist_seq_no = p_dist_seq_no
                  AND line_cd = p_line_cd
                  AND share_cd = v_share_cd
                  AND peril_cd = p_peril_cd;        	        
            END IF;      
         END IF;

      /* Use PERCENTAGES to create the default distribution records. */
      ELSIF p_default_type = 2 THEN
         FOR c1 IN dist_peril_cur
         LOOP
           v_dflt_dist_exist := 'Y';
           v_dist_spct := c1.share_pct;
           IF c1.share_amt1 IS NOT NULL THEN
              v_dist_tsi        := c1.share_amt1 / p_currency_rt;
              v_dist_spct_limit := ROUND(v_dist_tsi / p_dist_tsi * 100, 9);
              IF v_dist_spct > v_dist_spct_limit THEN 
                 v_dist_spct := v_dist_spct_limit;
              END IF;
           END IF;
           v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
           IF v_sum_dist_spct != 100 THEN
              v_dist_tsi         := ROUND(p_dist_tsi         * v_dist_spct / 100, 2);
              v_dist_prem        := ROUND(p_dist_prem        * v_dist_spct / 100, 2);
              v_ann_dist_tsi     := ROUND(p_ann_dist_tsi     * v_dist_spct / 100, 2);
              v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
              v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
              v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
           ELSE
              v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
              v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
              v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
           END IF;
           v_share_cd := c1.share_cd;
           INSERT_TO_PERILDS_DTL;
         END LOOP;
         IF v_sum_dist_spct  != 100 AND
            v_dflt_dist_exist = 'Y' THEN
            v_dist_spct    := 100            - v_sum_dist_spct;
            v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
            v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
            v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
            v_share_cd     := 1;
            net_ret_sw     := 'N';
            FOR A IN (SELECT '1'
                        FROM giuw_perilds_dtl
                       WHERE dist_no = p_dist_no
                         AND dist_seq_no = p_dist_seq_no
                         AND line_cd = p_line_cd
                         AND share_cd = v_share_cd
                         AND peril_cd = p_peril_cd)
            LOOP              
                net_ret_sw := 'Y';
            END LOOP;	
            IF net_ret_sw = 'N' THEN	
               INSERT_TO_PERILDS_DTL;
            ELSE
                 UPDATE giuw_perilds_dtl
                    SET dist_spct = dist_spct + v_dist_spct,
                        dist_tsi  = dist_tsi  + v_dist_tsi,
                        dist_prem = dist_prem + v_dist_prem,
                        ann_dist_tsi  = ann_dist_tsi  + v_ann_dist_tsi
                            WHERE dist_no = p_dist_no
                  AND dist_seq_no = p_dist_seq_no
                  AND line_cd = p_line_cd
                  AND share_cd = v_share_cd
                  AND peril_cd = p_peril_cd;        	        
            END IF;      
            
         END IF;
      END IF;

      /* If GIIS_DEFAULT_DIST_PERIL does not contain a record that
      ** corresponds to the particular peril being distributed,
      ** then use the value of the DFLT_NETRET_PCT column retrieved
      ** from table GIIS_DEFAULT_DIST. */
      /*IF v_dflt_dist_exist = 'N'       AND
         p_dflt_netret_pct IS NOT NULL THEN

         IF p_dflt_netret_pct != 100 THEN
            v_dist_spct        := p_dflt_netret_pct;
            v_dist_tsi         := ROUND(p_dist_tsi     * p_dflt_netret_pct / 100, 2);
            v_dist_prem        := ROUND(p_dist_prem    * p_dflt_netret_pct / 100, 2);
            v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * p_dflt_netret_pct / 100, 2);
            v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
            v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
            v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
         ELSE
            v_dist_spct    := p_dflt_netret_pct;
            v_dist_tsi     := p_dist_tsi;
            v_dist_prem    := p_dist_prem;
            v_ann_dist_tsi := p_ann_dist_tsi;
         END IF;
         v_share_cd := 1;
         INSERT_TO_PERILDS_DTL;
         IF p_dflt_netret_pct != 100 THEN
            v_dist_spct    := 100            - p_dflt_netret_pct;
            v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
            v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
            v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
            v_share_cd     := '999';
            INSERT_TO_PERILDS_DTL;
         END IF;
      */
      /* If no default distribution record was found in table
      ** GIIS_DEFAULT_DIST, then create the record using
      ** the traditional 100% NET RETENTION, 0% FACULTATIVE
      ** default. */
      --ELSIF v_dflt_dist_exist = 'N' THEN

         /* Create the default distribution records based on the 100%
         ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
      IF v_dflt_dist_exist = 'N' THEN   
         v_share_cd     := 1;
         v_dist_spct    := 100;
         v_dist_tsi     := p_dist_tsi;
         v_dist_prem    := p_dist_prem;
         v_ann_dist_tsi := p_ann_dist_tsi;
         INSERT_TO_PERILDS_DTL;
      END IF;
    END;    

    PROCEDURE CREATE_PERIL_DFLT_PERILDS_RI
             (p_dist_no         IN giuw_perilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no     IN giuw_perilds_dtl.dist_seq_no%TYPE  ,
              p_line_cd         IN giuw_perilds_dtl.line_cd%TYPE      ,
              p_peril_cd        IN giuw_perilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi        IN giuw_perilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem       IN giuw_perilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi    IN giuw_perilds_dtl.ann_dist_tsi%TYPE ,
              p_currency_rt     IN gipi_invoice.currency_rt%TYPE      ,
              p_default_no      IN giis_default_dist.default_no%TYPE   ,
              p_default_type    IN giis_default_dist.default_type%TYPE ,
              p_dflt_netret_pct IN giis_default_dist.dflt_netret_pct%TYPE,
              p_fac_spct        IN giri_distfrps.tot_fac_spct%TYPE) IS

      v_dflt_dist_exist		VARCHAR2(1) := 'N';
      v_dist_spct					giuw_perilds_dtl.dist_spct%TYPE;
      v_dist_tsi					giuw_perilds_dtl.dist_tsi%TYPE;
      v_dist_prem					giuw_perilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi			giuw_perilds_dtl.ann_dist_tsi%TYPE;
      v_share_cd					giis_dist_share.share_cd%TYPE;
      v_sum_dist_tsi			giuw_perilds_dtl.dist_tsi%TYPE     := 0;
      v_sum_dist_spct			giuw_perilds_dtl.dist_spct%TYPE    := 0;
      v_sum_dist_prem			giuw_perilds_dtl.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi	giuw_perilds_dtl.ann_dist_tsi%TYPE := 0;
      v_dist_spct_limit		NUMBER;
      v_remaining_tsi     NUMBER := p_dist_tsi * p_currency_rt;

      CURSOR dist_peril_cur IS
          SELECT a.share_cd , a.share_pct , a.share_amt1
            FROM giis_default_dist_peril a 
           WHERE a.default_no = p_default_no
             AND a.line_cd    = p_line_cd
             AND a.peril_cd   = p_peril_cd
             AND a.share_cd   <> 999
        ORDER BY a.sequence ASC;

      PROCEDURE INSERT_TO_PERILDS_DTL IS
      BEGIN
        INSERT INTO  giuw_perilds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , peril_cd)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , p_peril_cd);
        GIUW_POL_DIST_FINAL_PKG.CREATE_PERIL_DFLT_ITEMPERILDS
              (p_dist_no  , p_dist_seq_no , p_line_cd   ,
               p_peril_cd , v_share_cd    , v_dist_spct ,  
               v_dist_spct);
      END;

    BEGIN
      v_share_cd     := 999;
      v_dist_spct    := p_fac_spct;
      v_dist_tsi     := p_dist_tsi     * (p_fac_spct/100);
      v_dist_prem    := p_dist_prem    * (p_fac_spct/100);
      v_ann_dist_tsi := p_ann_dist_tsi * (p_fac_spct/100);
      INSERT_TO_PERILDS_DTL;
      v_share_cd     := 1;
      v_dist_spct    := 100 - p_fac_spct;
      v_dist_tsi     := p_dist_tsi     - v_dist_tsi;
      v_dist_prem    := p_dist_prem    - v_dist_prem;
      v_ann_dist_tsi := p_ann_dist_tsi - v_ann_dist_tsi;
      INSERT_TO_PERILDS_DTL;
    END;

    PROCEDURE CREATE_PERIL_DFLT_ITEMDS(p_dist_no     IN giuw_pol_dist.dist_no%TYPE,
                                       p_dist_seq_no IN giuw_policyds.dist_seq_no%TYPE) IS
      v_dist_spct			giuw_itemds_dtl.dist_spct%TYPE;
      v_ann_dist_spct               giuw_itemds_dtl.ann_dist_spct%TYPE;
      v_allied_dist_prem            giuw_itemds_dtl.dist_prem%TYPE;
      v_dist_prem                   giuw_itemds_dtl.dist_prem%TYPE;
    BEGIN
      FOR c1 IN (  SELECT line_cd     line_cd      ,
                          item_no     item_no      ,
                          share_cd    share_cd     ,
                          dist_grp    dist_grp
                     FROM giuw_itemperilds_dtl
                    WHERE dist_no     = p_dist_no
                      AND dist_seq_no = p_dist_seq_no
                 GROUP BY item_no, line_cd, share_cd, dist_grp)
      LOOP
        FOR c2 IN (  SELECT SUM(DECODE(A170.peril_type, 'B', 
                                       a.dist_tsi, 0))        dist_tsi     ,
                            SUM(a.dist_prem)                  dist_prem    ,
                            SUM(DECODE(A170.peril_type, 'B',
                                       a.ann_dist_tsi, 0))    ann_dist_tsi
                       FROM giuw_itemperilds_dtl a, giis_peril A170
                      WHERE A170.peril_cd   = a.peril_cd
                        AND A170.line_cd    = a.line_cd
                        AND a.dist_grp      = c1.dist_grp
                        AND a.share_cd      = c1.share_cd
                        AND a.line_cd       = c1.line_cd
                        AND a.item_no       = c1.item_no
                        AND a.dist_seq_no   = p_dist_seq_no                    
                        AND a.dist_no       = p_dist_no)
        LOOP
          FOR c3 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt ,
                            item_no
                       FROM giuw_itemds
                      WHERE item_no     = c1.item_no
                        AND dist_seq_no = p_dist_seq_no
                        AND dist_no     = p_dist_no)
          LOOP
            /* Divide the individual TSI/Premium with the total TSI/Premium
            ** and multiply it by 100 to arrive at the correct percentage for
            ** the breakdown. */
            IF c3.tsi_amt != 0 THEN
               v_dist_spct  := ROUND(c2.dist_tsi/c3.tsi_amt, 9) * 100;
            ELSE
                IF c3.prem_amt != 0 THEN --roset, 1/18/10
                v_dist_spct  := ROUND(c2.dist_prem/c3.prem_amt, 9) * 100;
                ELSE 
                    v_dist_spct  := 0; --roset,1/18/2010, added condition to avoid ora-1476 if prem_amt = 0
                END IF;	
            END IF;
            v_ann_dist_spct := ROUND(c2.ann_dist_tsi/c3.ann_tsi_amt, 9) * 100; 
            
            INSERT INTO  giuw_itemds_dtl
                        (dist_no         , dist_seq_no   , item_no         ,
                         line_cd         , share_cd      , dist_spct       ,
                         dist_tsi        , dist_prem     , ann_dist_spct   ,
                         ann_dist_tsi    , dist_grp)
                 VALUES (p_dist_no       , p_dist_seq_no , c3.item_no      , 
                         c1.line_cd      , c1.share_cd   , v_dist_spct     ,
                         c2.dist_tsi     , c2.dist_prem  , v_ann_dist_spct ,
                         c2.ann_dist_tsi , c1.dist_grp);
          END LOOP;
          EXIT;
        END LOOP;
      END LOOP;
    END;

    PROCEDURE CREATE_PERIL_DFLT_POLICYDS(p_dist_no     IN giuw_pol_dist.dist_no%TYPE,
                                         p_dist_seq_no IN giuw_policyds.dist_seq_no%TYPE) IS
      v_dist_spct			giuw_policyds_dtl.dist_spct%type;
      v_ann_dist_spct               giuw_policyds_dtl.ann_dist_spct%type;
    BEGIN
      FOR c1 IN (  SELECT SUM(dist_tsi)     dist_tsi     ,
                          SUM(dist_prem)    dist_prem    ,
                          SUM(ann_dist_tsi) ann_dist_tsi ,
                          line_cd           line_cd      ,
                          share_cd          share_cd     ,
                          dist_grp          dist_grp
                     FROM giuw_itemds_dtl
                    WHERE dist_no     = p_dist_no
                      AND dist_seq_no = p_dist_seq_no
                 GROUP BY line_cd, share_cd, dist_grp)
      LOOP
        FOR c2 IN (SELECT tsi_amt , prem_amt , ann_tsi_amt
                     FROM giuw_policyds
                    WHERE dist_seq_no = p_dist_seq_no
                      AND dist_no     = p_dist_no)
        LOOP

          /* Divide the individual TSI with the total TSI and multiply
          ** it by 100 to arrive at the correct percentage for the
          ** breakdown. */
          IF c2.tsi_amt != 0 THEN
             v_dist_spct     := ROUND(c1.dist_tsi/c2.tsi_amt, 9) * 100;
          ELSE
            IF c2.prem_amt!= 0 THEN --roset, 1/18/2010
              v_dist_spct     := ROUND(c1.dist_prem/c2.prem_amt, 9) * 100;
            ELSE
                v_dist_spct     := 0; --roset, 1/18/2010, to avoid ora-1476 when prem_amt = 0
            END IF;
          END IF;
          v_ann_dist_spct := ROUND(c1.ann_dist_tsi/c2.ann_tsi_amt, 9) * 100;

          INSERT INTO  giuw_policyds_dtl
                      (dist_no         , dist_seq_no     , line_cd          ,
                       share_cd        , dist_spct       , dist_tsi         ,
                       dist_prem       , ann_dist_spct   , ann_dist_tsi     ,
                       dist_grp)
               VALUES (p_dist_no       , p_dist_seq_no   , c1.line_cd       ,
                       c1.share_cd     , v_dist_spct     , c1.dist_tsi      ,
                       c1.dist_prem    , v_ann_dist_spct , c1.ann_dist_tsi  ,
                       c1.dist_grp);
        END LOOP;
      END LOOP;
    END;

    PROCEDURE CREATE_PERIL_DFLT_DIST999(p_dist_no         IN giuw_policyds.dist_no%TYPE,
                                     p_dist_seq_no     IN giuw_policyds.dist_seq_no%TYPE,
                                     p_dist_flag       IN giuw_pol_dist.dist_flag%TYPE,
                                     p_policy_tsi      IN giuw_policyds.tsi_amt%TYPE,
                                     p_policy_premium  IN giuw_policyds.prem_amt%TYPE,
                                     p_policy_ann_tsi  IN giuw_policyds.ann_tsi_amt%TYPE,
                                     p_item_grp        IN giuw_policyds.item_grp%TYPE,
                                     p_line_cd         IN giis_line.line_cd%TYPE,
                                     p_default_no      IN giis_default_dist.default_no%TYPE,
                                     p_default_type    IN giis_default_dist.default_type%TYPE,
                                     p_dflt_netret_pct IN giis_default_dist.dflt_netret_pct%TYPE,
                                     p_currency_rt     IN gipi_item.currency_rt%TYPE,
                                     p_policy_id       IN gipi_polbasic.policy_id%TYPE,
                                     p_ri_sw           IN VARCHAR2) IS

      v_peril_cd                    giis_peril.peril_cd%TYPE;
      v_peril_tsi										giuw_perilds.tsi_amt%TYPE      := 0;
      v_peril_premium								giuw_perilds.prem_amt%TYPE     := 0;
      v_peril_ann_tsi								giuw_perilds.ann_tsi_amt%TYPE  := 0;
      v_exist												VARCHAR2(1)                     := 'N';
      v_insert_sw										VARCHAR2(1)                     := 'N';
      v_fac_spct       							giri_distfrps.tot_fac_spct%TYPE;
      ri_exists                     VARCHAR2(1);
      /* Updates the amounts of the previously processed PERIL_CD
      ** while looping inside cursor C3.  After which, the records
      ** for table GIUW_PERILDS_DTL are also created.
      ** NOTE:  This is a LOCAL PROCEDURE BODY called below. */
      PROCEDURE  UPD_CREATE_PERIL_DTL_DATA IS
      BEGIN
        UPDATE giuw_perilds
           SET tsi_amt     = v_peril_tsi     ,
               prem_amt    = v_peril_premium ,
               ann_tsi_amt = v_peril_ann_tsi
         WHERE peril_cd    = v_peril_cd
           AND line_cd     = p_line_cd
           AND dist_seq_no = p_dist_seq_no
           AND dist_no     = p_dist_no;
        IF ri_exists = 'N' THEN  
           GIUW_POL_DIST_FINAL_PKG.CREATE_PERIL_DFLT_PERILDS
              (p_dist_no       , p_dist_seq_no , p_line_cd       ,
               v_peril_cd      , v_peril_tsi   , v_peril_premium ,
               v_peril_ann_tsi , p_currency_rt , p_default_no    ,
               p_default_type  , p_dflt_netret_pct);
        ELSE       
           GIUW_POL_DIST_FINAL_PKG.CREATE_PERIL_DFLT_PERILDS_RI
              (p_dist_no       , p_dist_seq_no , p_line_cd       ,
               v_peril_cd      , v_peril_tsi   , v_peril_premium ,
               v_peril_ann_tsi , p_currency_rt , p_default_no    ,
               p_default_type  , p_dflt_netret_pct, v_fac_spct);
        END IF;       
      END;

    BEGIN

        /* Create records in table GIUW_POLICYDS and GIUW_POLICYDS_DTL
        ** for the specified DIST_SEQ_NO. */
        IF p_ri_sw = 'N' THEN
           INSERT INTO  giuw_policyds
                       (dist_no      , dist_seq_no      , 
                        tsi_amt      , prem_amt         , ann_tsi_amt      ,
                        item_grp)
                VALUES (p_dist_no    , p_dist_seq_no    , 
                        p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                        p_item_grp);
        END IF;
        ri_exists := 'N';
        FOR A IN (SELECT tot_fac_spct
                    FROM giri_distfrps
                   WHERE dist_no = p_dist_no
                     AND dist_seq_no = p_dist_seq_no)
        LOOP
            ri_exists := 'Y';
            v_fac_spct  :=  a.tot_fac_spct;
        END LOOP; 	            
        /* Get the amounts for each item in table GIPI_ITEM in preparation
        ** for data insertion to its corresponding distribution tables. */
        FOR c2 IN (SELECT a.item_no     , a.tsi_amt , a.prem_amt ,
                          a.ann_tsi_amt
                     FROM gipi_item a
                    WHERE exists( SELECT '1'
                                    FROM gipi_itmperil b
                                   WHERE b.policy_id = a.policy_id
                                     AND b.item_no = a.item_no)
                      AND a.item_grp  = p_item_grp
                      AND a.policy_id = p_policy_id)
        LOOP

          /* Create records in table GIUW_ITEMDS and GIUW_ITEMDS_DTL
          ** for the specified DIST_SEQ_NO. */
          INSERT INTO  giuw_itemds
                      (dist_no        , dist_seq_no   , item_no        ,
                       tsi_amt        , prem_amt      , ann_tsi_amt)
               VALUES (p_dist_no      , p_dist_seq_no , c2.item_no     ,
                       c2.tsi_amt     , c2.prem_amt   , c2.ann_tsi_amt);
        END LOOP;

        /* Initialize the value of the variables
        ** in preparation for processing the new
        ** DIST_SEQ_NO. */
        v_peril_cd      := NULL;
        v_peril_tsi     := 0;
        v_peril_premium := 0;
        v_peril_ann_tsi := 0;   
        v_exist         := 'N';

        /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
        ** in table GIPI_ITMPERIL in preparation for data insertion to 
        ** distribution tables GIUW_ITEMPERILDS, GIUW_ITEMPERILDS_DTL,
        ** GIUW_PERILDS and GIUW_PERILDS_DTL. */
        FOR c3 IN (  SELECT B380.tsi_amt     itmperil_tsi     ,
                            B380.prem_amt    itmperil_premium ,
                            B380.ann_tsi_amt itmperil_ann_tsi ,
                            B380.item_no     item_no          ,
                            B380.peril_cd    peril_cd
                       FROM gipi_itmperil B380, gipi_item B340
                      WHERE B380.item_no   = B340.item_no
                        AND B380.policy_id = B340.policy_id
                        AND B340.item_grp  = p_item_grp
                        AND B340.policy_id = p_policy_id
                   ORDER BY B380.peril_cd)
        LOOP
          v_exist     := 'Y';

          /* Create records in table GIUW_ITEMPERILDS and GIUW_ITEMPERILDS_DTL
          ** for the specified DIST_SEQ_NO. */
          INSERT INTO  giuw_itemperilds  
                      (dist_no             , dist_seq_no   , item_no         ,
                       peril_cd            , line_cd       , tsi_amt         ,
                       prem_amt            , ann_tsi_amt)
               VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                       c3.peril_cd         , p_line_cd     , c3.itmperil_tsi ,
                       c3.itmperil_premium , c3.itmperil_ann_tsi);

          /* Create the newly processed PERIL_CD in table
          ** GIUW_PERILDS. */
          IF v_peril_cd IS NULL THEN
             v_peril_cd     := c3.peril_cd;
             v_insert_sw    := 'Y';
          END IF;

          /* Check if the value of the previously processed
          ** PERIL_CD is equal to the one currently processed.
          ** Should the two be unequal, then the amounts of
          ** the previously processed PERIL_CD must be updated
          ** to reflect the true value of each field for the
          ** specified PERIL_CD.  After the amounts of the specified
          ** PERIL_CD have been updated, then that's the time to
          ** create the records in table GIUW_PERILDS_DTL.
          ** On the other hand, if the value of the two PERIL_CDs
          ** are equal, then the amounts of the currently processed
          ** record is added along with the amounts of the previously
          ** processed records of the same PERIL_CD.  Such amounts
          ** shall be used later on when the two PERIL_CDs become
          ** unequal. */
          IF v_peril_cd != c3.peril_cd THEN

             /* Updates the amounts of the previously processed PERIL_CD.
             ** After which, the records for table GIUW_PERILDS_DTL are
             ** also created. */
             UPD_CREATE_PERIL_DTL_DATA;

             /* Assigns the new PERIL_CD to the V_PERIL_CD
             ** variable in preparation for data creation
             ** in table GIUW_PERILDS. */
             v_peril_cd      := c3.peril_cd;
             v_peril_tsi     := c3.itmperil_tsi;
             v_peril_premium := c3.itmperil_premium;
             v_peril_ann_tsi := c3.itmperil_ann_tsi;
             v_insert_sw     := 'Y';

          ELSIF v_peril_cd = c3.peril_cd THEN
             v_peril_tsi     := v_peril_tsi     + c3.itmperil_tsi;
             v_peril_premium := v_peril_premium + c3.itmperil_premium;
             v_peril_ann_tsi := v_peril_ann_tsi + c3.itmperil_ann_tsi;
          END IF;
          IF v_insert_sw = 'Y' THEN
             INSERT INTO  giuw_perilds  
                         (dist_no   , dist_seq_no   , peril_cd         ,
                          line_cd   , tsi_amt       , prem_amt         ,
                          ann_tsi_amt)
                  VALUES (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                          p_line_cd , v_peril_tsi   , v_peril_premium  ,
                          v_peril_ann_tsi);
             v_insert_sw     := 'N';
          END IF;

        END LOOP;
        IF v_exist = 'Y' THEN

           /* Updates the amounts of the last processed PERIL_CD.
           ** After which, its corresponding records for table 
           ** GIUW_PERILDS_DTL are also created.
           ** NOTE:  This was done so, because the last processed
           **        PERIL_CD is no longer handled by the C3 loop. */
           UPD_CREATE_PERIL_DTL_DATA;

        END IF;

        /* Create records in table GIUW_ITEMDS_DTL based on
        ** the values inserted to table GIUW_ITEMPERILDS_DTL. */
        GIUW_POL_DIST_FINAL_PKG.CREATE_PERIL_DFLT_ITEMDS  (p_dist_no, p_dist_seq_no);

        /* Create records in table GIUW_POLICYDS_DTL based on
        ** the values inserted to table GIUW_ITEMDS_DTL. */
        GIUW_POL_DIST_FINAL_PKG.CREATE_PERIL_DFLT_POLICYDS(p_dist_no, p_dist_seq_no);
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Update discrepancy in distribution tables. 
*/

    PROCEDURE ADJUST_FINAL_GIUWS015(p_dist_no IN GIUW_POL_DIST.dist_no%TYPE) IS

    BEGIN
      
      /* equalize amount of GIUW_ITEMDS_DTL as to the amount stored in GIUW_POLICYDS_DTL */
      FOR A1 IN
          ( SELECT dist_seq_no,share_cd, SUM(dist_prem) prem
              FROM GIUW_POLICYDS_DTL
             WHERE dist_no = p_dist_no
           GROUP BY dist_seq_no, share_cd
          )LOOP
          FOR A2 IN 
              ( SELECT SUM(dist_prem) prem
                  FROM GIUW_ITEMDS_DTL
                 WHERE dist_no = p_dist_no
                   AND dist_seq_no = A1.dist_seq_no
                   AND share_cd =  A1.share_cd
              ) LOOP
              IF  A1.prem != A2.prem THEN
                  FOR A3 IN
                      ( SELECT MIN(item_no) item 
                          FROM GIUW_ITEMDS_DTL
                         WHERE dist_no = p_dist_no
                           AND dist_seq_no = A1.dist_seq_no
                           AND share_cd =  A1.share_cd
                      ) LOOP 
                      UPDATE GIUW_ITEMDS_DTL
                         SET dist_prem = dist_prem + (A1.prem - A2.prem)
                       WHERE dist_no = p_dist_no
                         AND dist_seq_no = A1.dist_seq_no
                         AND share_cd =  A1.share_cd
                         AND item_no = A3.item;
                      EXIT;
                  END LOOP;
               END IF;
          END LOOP;
      END LOOP;
      
      /* equalize amount of GIUW_ITEMPERILDS_DTL as to the amount stored in GIUW_ITEMDS_DTL */
      FOR A1 IN
          ( SELECT item_no,dist_seq_no,share_cd, SUM(dist_prem) prem
              FROM GIUW_ITEMDS_DTL
             WHERE dist_no = p_dist_no
          GROUP BY item_no, dist_seq_no, share_cd
          )LOOP
          FOR A2 IN 
              ( SELECT SUM(dist_prem) prem
                  FROM GIUW_ITEMPERILDS_DTL
                 WHERE dist_no = p_dist_no
                   AND dist_seq_no = A1.dist_seq_no
                   AND share_cd =  A1.share_cd
                   AND item_no = A1.item_no
              ) LOOP
              IF  A1.prem != A2.prem THEN
                  FOR A3 IN
                      ( SELECT MIN(peril_cd) peril 
                          FROM GIUW_ITEMPERILDS_DTL
                         WHERE dist_no = p_dist_no
                           AND dist_seq_no = A1.dist_seq_no
                           AND share_cd =  A1.share_cd
                           AND item_no = A1.item_no
                      ) LOOP 
                      UPDATE GIUW_ITEMPERILDS_DTL
                         SET dist_prem = dist_prem + (A1.prem - A2.prem)
                       WHERE dist_no = p_dist_no
                         AND dist_seq_no = A1.dist_seq_no
                         AND share_cd =  A1.share_cd
                         AND item_no = A1.item_no
                         AND peril_cd = A3.peril;
                      EXIT;
                  END LOOP;
               END IF;
          END LOOP;
      END LOOP;
      
      /* equalize amount of GIUW_PERILDS_DTL as to the amount stored in GIUW_ITEMPERILDS_DTL */
      FOR A1 IN
          ( SELECT peril_cd,dist_seq_no,share_cd, SUM(dist_prem) prem
              FROM GIUW_ITEMPERILDS_DTL
             WHERE dist_no = p_dist_no
          GROUP BY peril_cd, dist_seq_no, share_cd
          )LOOP
          FOR A2 IN 
              ( SELECT SUM(dist_prem) prem
                  FROM GIUW_PERILDS_DTL
                 WHERE dist_no = p_dist_no
                   AND dist_seq_no = A1.dist_seq_no
                   AND share_cd =  A1.share_cd
                   AND peril_cd = A1.peril_cd
              ) LOOP
              IF  A1.prem != A2.prem THEN
                  UPDATE GIUW_PERILDS_DTL
                    SET dist_prem = dist_prem + (A1.prem - A2.prem)
                  WHERE dist_no = p_dist_no
                    AND dist_seq_no = A1.dist_seq_no
                    AND share_cd =  A1.share_cd
                    AND peril_cd = A1.peril_cd;
               END IF;
          END LOOP;
      END LOOP;
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Delete all the distribution records including the RI records
**                 for each distribution number read in GIUW_POL_DIST.                
*/

PROCEDURE DELETE_DIST_TABLES_GIUWS015 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE) IS
           
    CURSOR   RI (p_dist_no  GIUW_POL_DIST.dist_no%TYPE) IS 
                 SELECT frps_yy, frps_seq_no, line_cd
                   FROM GIRI_DISTFRPS
                 WHERE dist_no = p_dist_no;
                    
BEGIN
    /* Deletion of Actual Reinsurance tables   */
    /* just to be sure that no records exist...*/
    
    FOR RI_REC IN RI(p_dist_no)
    
    LOOP 
      /* Deletion of Binder records              */
      /* just to be sure that no records exist...*/
      
      FOR BNDR_REC IN (SELECT fnl_binder_id
                        FROM GIRI_FRPS_RI
                       WHERE line_cd     = RI_REC.line_cd
                         AND frps_yy     = RI_REC.frps_yy
                         AND frps_seq_no = RI_REC.frps_seq_no)
      LOOP 
           DELETE FROM GIRI_FRPERIL
                  WHERE line_cd        = RI_REC.line_cd
                    AND frps_yy        = RI_REC.frps_yy
                    AND frps_seq_no    = RI_REC.frps_seq_no; 
           DELETE FROM GIRI_FRPS_RI
                  WHERE line_cd        = RI_REC.line_cd
                    AND frps_yy        = RI_REC.frps_yy
                    AND frps_seq_no    = RI_REC.frps_seq_no; 
           DELETE FROM GIRI_BINDER_PERIL 
            WHERE fnl_binder_id = BNDR_REC.fnl_binder_id; 
           DELETE FROM GIRI_BINDER
            WHERE fnl_binder_id = BNDR_REC.fnl_binder_id; 
      END LOOP; --END OF BNDR_REC
      
      /* Deletion of FRPS related tables */               
        DELETE FROM GIRI_FRPS_PERIL_GRP 
             WHERE line_cd        = RI_REC.line_cd
               AND frps_yy        = RI_REC.frps_yy
               AND frps_seq_no    = RI_REC.frps_seq_no;
        END LOOP; --end of RI_REC

        DELETE FROM GIRI_DISTFRPS
         WHERE dist_no = p_dist_no;
    
     /* Deletion of Distribution tables */
        DELETE FROM GIUW_PERILDS_DTL
         WHERE dist_no = p_dist_no;
        DELETE FROM GIUW_PERILDS
         WHERE dist_no = p_dist_no;
        DELETE FROM GIUW_ITEMPERILDS_DTL
         WHERE dist_no = p_dist_no;
        DELETE FROM GIUW_ITEMPERILDS
         WHERE dist_no = p_dist_no;
        DELETE FROM GIUW_ITEMDS_DTL
         WHERE dist_no = p_dist_no;
        DELETE FROM GIUW_ITEMDS
         WHERE dist_no = p_dist_no;
        DELETE FROM GIUW_POLICYDS_DTL
         WHERE dist_no = p_dist_no;
        DELETE FROM GIUW_POLICYDS
         WHERE dist_no = p_dist_no;

END; --end of DELETE_DIST_TABLES

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Delete all the distribution records including the RI records
**                 for each distribution number read in GIUW_POL_DIST.              
*/

    PROCEDURE DEL_DIST_WORK_TABLES_GIUWS015(p_dist_no IN GIUW_POL_DIST.dist_no%TYPE) IS

        CURSOR RI IS    SELECT frps_yy, frps_seq_no, line_cd
                         FROM GIRI_WDISTFRPS
                        WHERE dist_no = p_dist_no;
                        
    BEGIN
        
        /* Deletion of Reinsurance tables */
        FOR RI_REC IN RI
        
        LOOP
              /* Deletion of Binder records */
            FOR BNDR_REC IN (SELECT pre_binder_id
                              FROM GIRI_WFRPS_RI
                             WHERE line_cd     = RI_REC.line_cd
                               AND frps_yy     = RI_REC.frps_yy
                               AND frps_seq_no = RI_REC.frps_seq_no)
            LOOP
                DELETE FROM GIRI_WBINDER_PERIL
                 WHERE pre_binder_id = BNDR_REC.pre_binder_id;
                DELETE FROM GIRI_WBINDER
                 WHERE pre_binder_id = BNDR_REC.pre_binder_id;
            END LOOP;
          
                /* Deletion of FRPS related tables */      
                DELETE FROM GIRI_WFRPERIL
                 WHERE line_cd        = RI_REC.line_cd
                   AND frps_yy        = RI_REC.frps_yy
                   AND frps_seq_no    = RI_REC.frps_seq_no;
                DELETE FROM GIRI_WFRPS_RI
                 WHERE line_cd        = RI_REC.line_cd
                   AND frps_yy        = RI_REC.frps_yy
                   AND frps_seq_no    = RI_REC.frps_seq_no;
                DELETE FROM GIRI_WFRPS_PERIL_GRP
                 WHERE line_cd        = RI_REC.line_cd
                   AND frps_yy        = RI_REC.frps_yy
                   AND frps_seq_no    = RI_REC.frps_seq_no;
                  
            END LOOP;

            DELETE FROM GIRI_WDISTFRPS
             WHERE dist_no = p_dist_no;
        
            /* Deletion of Distribution tables */
            DELETE FROM GIUW_WPERILDS_DTL
             WHERE dist_no = p_dist_no;
            DELETE FROM GIUW_WPERILDS
             WHERE dist_no = p_dist_no;
            DELETE FROM GIUW_WITEMPERILDS_DTL
             WHERE dist_no = p_dist_no;
            DELETE FROM GIUW_WITEMPERILDS
             WHERE dist_no = p_dist_no;
            DELETE FROM GIUW_WITEMDS_DTL
             WHERE dist_no = p_dist_no;
            DELETE FROM GIUW_WITEMDS
             WHERE dist_no = p_dist_no;
            DELETE FROM GIUW_WPOLICYDS_DTL
             WHERE dist_no = p_dist_no;
        DELETE FROM GIUW_WPOLICYDS
         WHERE dist_no = p_dist_no;
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Delete all the RI records for each distribution number read in GIUW_POL_DIST.     
*/

    PROCEDURE DELETE_RI_TABLES_GIUWS015(p_batch_id   IN   GIUW_POL_DIST.batch_id%TYPE) IS
      
        CURSOR DIST IS SELECT dist_no
                       FROM GIUW_POL_DIST
                        WHERE batch_id = p_batch_id;
                        
        CURSOR   RI (p_dist_no  GIUW_POL_DIST.dist_no%TYPE) IS 
                        SELECT frps_yy, frps_seq_no, line_cd
                         FROM GIRI_DISTFRPS
                        WHERE dist_no = p_dist_no;
                        
    BEGIN
        FOR DIST_REC IN DIST
        
        LOOP

        /* Deletion of Reinsurance tables */
        FOR RI_REC IN RI(DIST_REC.dist_no)
            LOOP
              /* Deletion of Binder records */
              
              FOR BNDR_REC IN (SELECT fnl_binder_id
                                 FROM GIRI_FRPS_RI
                               WHERE line_cd     = RI_REC.line_cd
                                 AND frps_yy     = RI_REC.frps_yy
                                 AND frps_seq_no = RI_REC.frps_seq_no)
              LOOP
                   DELETE FROM GIRI_BINDER_PERIL
                    WHERE fnl_binder_id = BNDR_REC.fnl_binder_id;
                   DELETE FROM GIRI_BINDER
                    WHERE fnl_binder_id = BNDR_REC.fnl_binder_id;
              END LOOP;
              
                /* Deletion of FRPS related tables */      
                DELETE FROM GIRI_FRPERIL
                 WHERE line_cd             = RI_REC.line_cd
                   AND frps_yy             = RI_REC.frps_yy
                   AND frps_seq_no    = RI_REC.frps_seq_no;
                DELETE FROM GIRI_FRPS_RI
                 WHERE line_cd             = RI_REC.line_cd
                   AND frps_yy             = RI_REC.frps_yy
                   AND frps_seq_no    = RI_REC.frps_seq_no;
                DELETE FROM GIRI_FRPS_PERIL_GRP
                 WHERE line_cd             = RI_REC.line_cd
                   AND frps_yy             = RI_REC.frps_yy
                   AND frps_seq_no    = RI_REC.frps_seq_no;
                      
            END LOOP;

            DELETE FROM GIRI_DISTFRPS
             WHERE dist_no = DIST_REC.dist_no;
        
        END LOOP;
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 25, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : This procedure will update both underwriting and reinsurance tables
**                 used for Post batch distribution process.     
*/

PROCEDURE TABLE_UPDATES_GIUWS015(p_batch_id      IN    GIUW_POL_DIST_POLBASIC_V.batch_id%TYPE,
                                 p_policy_id     IN    GIUW_POL_DIST_POLBASIC_V.policy_id%TYPE,
                                 p_dist_no       IN    GIUW_POL_DIST_POLBASIC_V.dist_no%TYPE,
                                 p_line_cd       IN    GIUW_POL_DIST_POLBASIC_V.line_cd%TYPE,
                                 p_subline_cd    IN    GIUW_POL_DIST_POLBASIC_V.subline_cd%TYPE,
                                 p_iss_cd        IN    GIUW_POL_DIST_POLBASIC_V.iss_cd%TYPE,
                                 p_issue_yy      IN    GIUW_POL_DIST_POLBASIC_V.issue_yy%TYPE,
                                 p_pol_seq_no    IN    GIUW_POL_DIST_POLBASIC_V.pol_seq_no%TYPE,
                                 p_renew_no      IN    GIUW_POL_DIST_POLBASIC_V.renew_no%TYPE,
                                 p_user_id       IN    GIUW_POL_DIST_POLBASIC_V.user_id%TYPE) IS
  
  CURSOR MAIN IS SELECT dist_no, policy_id
                   FROM GIUW_POL_DIST
                   WHERE batch_id = p_batch_id;
                     
  v_facul_sw            VARCHAR2(1) := 'N';
  v_dist_no             GIUW_POL_DIST.dist_no%TYPE;
  v_frps_exist          VARCHAR2(1) := 'N';
  v_dist_flag           VARCHAR2(1) := '3';
  counter               NUMBER := 1;
  counter2              NUMBER := 314;
  v_eff_date            GIUW_POL_DIST.eff_date%TYPE;        
  v_expiry_date         GIUW_POL_DIST.expiry_date%TYPE;
  v_message             VARCHAR2(1000); 
  v_workflow_msg        VARCHAR2(1000);    

    BEGIN
        FOR counter2 IN 1..counter 
        LOOP
        /*Set_Application_Property(CURSOR_STYLE,'BUSY');
        Set_View_Property('POSTING',VISIBLE,PROPERTY_TRUE);
        GO_ITEM('C170.DSP_PROCEDURE_NAME');
        SYNCHRONIZE;
        counter := counter + .01;
        set_item_property('cg$ctrl.gauge_like',item_size,counter,6);*/

         FOR MAIN_REC IN MAIN 
            LOOP
            /*IF MAIN_REC.policy_id IS NOT NULL THEN
                FOR POL IN   (SELECT SUBSTR(LTRIM(line_cd || '-' || LTRIM(subline_cd) || '-' || iss_cd
                                         || '-' || LTRIM(TO_CHAR(issue_yy,'99')) || '-' || 
                                       LPAD(LTRIM(TO_CHAR(pol_seq_no,'9999999')),7,'0') || '-' || 
                                       LPAD(LTRIM(TO_CHAR(renew_no,'99')),2,'0') || '  ' ||
                                       DECODE(endt_seq_no,0,'',endt_iss_cd) || DECODE(endt_seq_no,0,'','-') || 
                                       DECODE(endt_seq_no,0,'',LTRIM(TO_CHAR(endt_yy,'99'))) || DECODE(endt_seq_no,0,'','-') || 
                                       DECODE(endt_seq_no,0,'',LTRIM(TO_CHAR(endt_seq_no,'999999')))),1,40) policy,
                                       NVL(endt_seq_no,0) endt_seq_no
                               FROM GIPI_POLBASIC
                               WHERE policy_id = MAIN_REC.policy_id) 
                               
                               LOOP
                                
                                --:c170.dsp_policy_id := POL.policy ;
                                    IF POL.endt_seq_no > 0 THEN
                                         --:c170.dsp_title := 'For endt. No.';
                                    ELSE
                                         --:c170.dsp_title := 'For policy No.';
                                    END IF;
                                    EXIT ;                          
                               END LOOP;
            END IF;*/

            /* Check if distribution has Facultative share */
               GIUW_DIST_BATCH_DTL_PKG.check_ri_share(p_batch_id, v_facul_sw);            
                
            /* To delete all related records in ACTUAL DISTRIBUTION TABLES */
            /* including ACTUAL REINSURANCE TABLES.                                              */
               --:c170.dsp_procedure_name := 'DELETING DISTRIBUTION TABLES';
               
              GIUW_POL_DIST_FINAL_PKG.delete_dist_tables_giuws015(MAIN_REC.dist_no); 
            
            /* To populate the detail of all working distribution tables   */
            /* coming from the entered distribution */
               --:c170.dsp_procedure_name := 'UPDATING DISTRIBUTION TABLES';            
               GIUW_WITEMDS_PKG.post_witemds_dtl_giuws015(p_batch_id, MAIN_REC.dist_no);
               GIUW_WPERILDS_DTL_PKG.post_wperilds_dtl_giuws015(p_batch_id, MAIN_REC.dist_no);
               GIUW_WITEMPERILDS_DTL_PKG.post_witemperilds_dtl_giuws015(p_batch_id, MAIN_REC.dist_no);
               GIUW_WPOLICYDS_DTL_PKG.post_wpolicyds_dtl_giuws015(p_batch_id, MAIN_REC.dist_no);

               /* To transfer distribution records from working distribution tables */
               /* to main/actual distribution tables.*/
               GIUW_WPOLICYDS_PKG.transfer_wpolicyds(MAIN_REC.dist_no);
               GIUW_WITEMDS_PKG.transfer_witemds(MAIN_REC.dist_no);
               GIUW_WITEMPERILDS_PKG.transfer_witemperilds(MAIN_REC.dist_no);
               GIUW_WPERILDS_PKG.transfer_wperilds(MAIN_REC.dist_no);
            
            /* If facul_sw = TRUE, then distribution made has facultative and therefore */
            /* status should be 2 ONLY, since there is still a need for RI distribution */
            /* To delete distribution records in all WORKING distribution tables        */
                IF v_facul_sw = 'N' THEN
                  --:c170.dsp_procedure_name := 'DELETING WORKING TABLES';
                  
                    /* mark jm 10.12.2009 UW-SPECS-2009-00067 starts here */
                    /* for updating GICL_CLM_RESERVE.REDIST_SW */
                    BEGIN           
                        SELECT eff_date, expiry_date
                            INTO v_eff_date, v_expiry_date
                            FROM giuw_pol_dist
                         WHERE policy_id = p_policy_id
                             AND dist_no = p_dist_no;
                    END;
        
                    FOR a IN (SELECT claim_id, loss_date          
                                FROM gicl_claims
                               WHERE line_cd = p_line_cd
                                 AND subline_cd = p_subline_cd
                                 AND pol_iss_cd = p_iss_cd
                                 AND issue_yy = p_issue_yy
                                 AND pol_seq_no = p_pol_seq_no
                                 AND renew_no = p_renew_no) 
                    LOOP        
                        FOR b IN (SELECT item_no, peril_cd  
                                    FROM GIUW_WITEMPERILDS
                                  WHERE dist_no = p_dist_no
                                 /*AND dist_seq_no = :c1306.dist_seq_no*/) 
                        LOOP            
                            FOR c IN (SELECT 1
                                      FROM GICL_CLM_RESERVE
                                      WHERE claim_id = a.claim_id
                                        AND item_no = b.item_no
                                        AND peril_cd = b.peril_cd) 
                            LOOP                                    
                                IF v_facul_sw = 'N' AND (a.loss_date BETWEEN v_eff_date AND v_expiry_date) THEN                    
                                    UPDATE GICL_CLM_RESERVE
                                         SET redist_sw = 'Y'
                                     WHERE claim_id = a.claim_id
                                       AND item_no = b.item_no
                                       AND peril_cd = b.peril_cd;                
                                END IF;                
                            END LOOP;            
                        END LOOP;            
                    END LOOP;
                    /* mark jm 10.12.09 UW-SPECS-2009-00067 ends here */
                  
                    GIUW_POL_DIST_FINAL_PKG.del_dist_work_tables_giuws015(MAIN_REC.dist_no);
                  -->--bdarusin
                  FOR A IN (SELECT c.fnl_binder_id--, c.replaced_flag
                              FROM GIRI_DISTFRPS a,
                                   GIRI_FRPS_RI  b,
                                   GIRI_BINDER   c,
                                   GIUW_POL_DIST d
                             WHERE a.line_cd       = b.line_cd
                               AND a.frps_yy       = b.frps_yy
                               AND a.frps_seq_no   = b.frps_seq_no
                               AND b.fnl_binder_id = c.fnl_binder_id
                               AND a.dist_no       = d.dist_no
                               AND d.dist_flag     = 4
                               AND NVL(replaced_flag,'N') <> 'Y'
                               AND d.policy_id     = MAIN_REC.policy_id) 
                      LOOP
                        UPDATE GIRI_BINDER
                           SET replaced_flag = 'Y'
                         WHERE fnl_binder_id = a.fnl_binder_id;
                        --EXIT;
                      END LOOP;                              
                   --<--bdarusin
                ELSE
                  /* To create Reinsurance records in GIRI_WDISTFRPS */
                     --:c170.dsp_procedure_name := 'CREATING REINSURANCE RECORDS';
                    GIRI_WDISTFRPS_PKG.create_wdistfrps_giuws015(MAIN_REC.dist_no, MAIN_REC.policy_id, p_user_id);
                END IF;
                
                /* Update GIUW_POL_DIST .., Update POST_FLAG to 'O'          */ 
                /* If distribution has facultative share then DIST_FLAG = '2'*/
                /* otherwise, '3'                                           */
                IF v_facul_sw ='Y' THEN
                     v_dist_flag := '2';
                END IF;
                
                IF v_dist_flag = '3' THEN
                     UPDATE GIUW_POL_DIST
                        SET dist_flag   = v_dist_flag,
                            post_flag   = 'O',
                            post_date   = SYSDATE,
                            user_id     = p_user_id,--:CG$CTRL.CG$US,
                            last_upd_date  = SYSDATE
                      WHERE dist_no   = MAIN_REC.dist_no;
                ELSE         
                     UPDATE GIUW_POL_DIST
                        SET dist_flag      = v_dist_flag,
                            post_flag      = 'O',
                            user_id        = p_user_id,--:CG$CTRL.CG$US,
                            last_upd_date  = SYSDATE
                         WHERE dist_no   = MAIN_REC.dist_no;    
                END IF; 
                /* Update GIPI_POLBASIC as to the current */
                /* distribution status of the policy      */
              UPDATE GIPI_POLBASIC             
                 SET user_id       = p_user_id,--:CG$CTRL.CG$US,
                     last_upd_date = SYSDATE,
                     dist_flag     = v_dist_flag
               WHERE policy_id = MAIN_REC.policy_id;
               
              /*PAU 12FEB08
              **UPDATE EXISTING CLAIMS WITH DISTRUBUTED RESERVE FOR THIS POLICY
              */
              UPDATE GICL_CLM_RESERVE
                 SET redist_sw = 'Y'
               WHERE (claim_id, item_no, peril_cd) IN (SELECT claim_id, item_no, peril_cd
                                                         FROM GICL_CLM_RES_HIST
                                                       WHERE claim_id IN (SELECT claim_id
                                                                            FROM GICL_CLAIMS
                                                                          WHERE line_cd = p_line_cd
                                                                            AND subline_cd = p_subline_cd
                                                                            AND pol_iss_cd = p_iss_cd
                                                                            AND issue_yy = p_issue_yy
                                                                            AND pol_seq_no = p_pol_seq_no
                                                                            AND renew_no = p_renew_no)
                                                       AND dist_sw = 'Y')
                 AND (item_no, peril_cd) IN (SELECT item_no, peril_cd
                                               FROM GIUW_ITEMPERILDS
                                             WHERE dist_no = p_dist_no
                                               AND dist_seq_no IN (SELECT MAX(dist_seq_no)
                                                                   FROM GIUW_ITEMPERILDS
                                                                   WHERE dist_no = p_dist_no));
         --FORMS_DDL('COMMIT');
        /*PAU 12FEB08 END*/
               
           /* 11052000 BETH 
           **    posted policy distribution with eim_flag = '2' should be
           **    updated with eim_flag ='6' and undist_sw = 'Y' in eim_takeup_info
           **    table.
           */
           IF v_dist_flag = '3' THEN
            
                /* A.R.C. 02.03.2006
                ** to create workflow records of Policy/Endt.  Redistribution */        
                   FOR a1 IN (SELECT DISTINCT claim_id
                                FROM GICL_CLAIMS b,
                                     GIPI_POLBASIC a
                               WHERE b.line_cd = a.line_cd
                                 AND b.subline_cd = a.subline_cd
                                 AND b.iss_cd = a.iss_cd                     
                                 AND b.issue_yy = a.issue_yy 
                                 AND b.pol_seq_no = a.pol_seq_no
                                 AND b.renew_no = a.renew_no
                                 AND b.clm_stat_cd NOT IN ('CC','WD','DN')
                                 AND a.policy_id = MAIN_REC.policy_id)
                   LOOP    
                     FOR c1 IN (SELECT b.userid, d.event_desc  
                                    FROM GIIS_EVENTS_COLUMN c, GIIS_EVENT_MOD_USERS b, GIIS_EVENT_MODULES a, GIIS_EVENTS d
                                   WHERE 1=1
                                   AND c.event_cd = a.event_cd
                                   AND c.event_mod_cd = a.event_mod_cd
                                   AND b.event_mod_cd = a.event_mod_cd
                                   AND b.passing_userid = USER
                                   AND a.module_id = 'GIUWS012'
                                   AND a.event_cd = d.event_cd
                                   AND UPPER(d.event_desc) = 'POLICY/ENDT.  REDISTRIBUTION')
                     LOOP
                       CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIUWS012', c1.userid, a1.claim_id, c1.event_desc||' '||get_clm_no(a1.claim_id), v_message, v_workflow_msg, NVL(giis_users_pkg.app_user,USER));
                     END LOOP; 
                   END LOOP;
           
              FOR A IN (SELECT '1'
                          FROM EIM_TAKEUP_INFO
                         WHERE policy_id = MAIN_REC.policy_id
                           AND eim_flag = '2')
              LOOP
                  UPDATE EIM_TAKEUP_INFO 
                      SET eim_flag = '6',
                          undist_sw = 'Y'
                  WHERE policy_id = MAIN_REC.policy_id;
                  EXIT;
              END LOOP;
           END IF;
           
              -- A.R.C. 08.13.2004 --
              -- to delete workflow records of Final Distribution --
              delete_workflow_rec('Final Distribution','GIPIS055', p_user_id,MAIN_REC.policy_id);   
                     
               /* UPDATE GIUW_WPERILDS and GIUW_WPOLICYDS */
               /* as to the current distribution status   */
               /* of the policy  */
               IF v_facul_sw = 'Y' THEN
                       UPDATE GIUW_WPERILDS
                          SET dist_flag = v_dist_flag
                        WHERE dist_no   = MAIN_REC.dist_no;
                        
                       UPDATE GIUW_WPOLICYDS
                          SET dist_flag = v_dist_flag
                        WHERE dist_no   = MAIN_REC.dist_no;

                  /* A.R.C. 08.16.2004
              ** to create workflow records of Facultative Placement */        
                  FOR c1 IN (SELECT b.userid, d.event_desc  
                                 FROM GIIS_EVENTS_COLUMN c, GIIS_EVENT_MOD_USERS b, GIIS_EVENT_MODULES a, GIIS_EVENTS d
                                WHERE 1=1
                                AND c.event_cd = a.event_cd
                                AND c.event_mod_cd = a.event_mod_cd
                                AND b.event_mod_cd = a.event_mod_cd
                                --AND b.userid <> USER  --A.R.C. 01.23.2006
                                AND b.passing_userid = USER  --A.R.C. 01.23.2006
                                AND a.module_id = 'GIUWS012'
                                AND a.event_cd = d.event_cd
                                AND UPPER(d.event_desc) = 'FACULTATIVE PLACEMENT')
                  LOOP
                    CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIUWS012', c1.userid, MAIN_REC.policy_id, c1.event_desc||' '||get_policy_no(MAIN_REC.policy_id), v_message, v_workflow_msg, NVL(giis_users_pkg.app_user,USER));
                  END LOOP;
               END IF;
               
               /* A.R.C. 08.16.2004
               ** to delete workflow records of Distribution Negation */
               delete_workflow_rec('Distribution Negation','GIUTS002',p_user_id,MAIN_REC.policy_id);
               /* A.R.C. 06.28.2005
               ** to delete workflow records of Undistributed policies awaiting claims */
               IF v_facul_sw = 'N' THEN
                 FOR c1 IN (SELECT claim_id
                                FROM GICL_CLAIMS b, GIPI_POLBASIC a
                               WHERE 1=1
                                 AND b.line_cd = a.line_cd
                               AND b.subline_cd = a.subline_cd 
                               AND b.iss_cd = a.iss_cd
                               AND b.issue_yy = a.issue_yy
                               AND b.pol_seq_no = a.pol_seq_no
                               AND b.renew_no = a.renew_no
                               AND a.policy_id = main_rec.policy_id)
                 LOOP    
                   delete_workflow_rec('Undistributed policies awaiting claims','GICLS010', p_user_id,c1.claim_id);  
                 END LOOP;             
                 --A.R.C. 02.07.2007
                  --added to delete the workflow facultative placement of GIUWS012 if not facul
                 delete_workflow_rec('Facultative Placement','GIUWS012', p_user_id,MAIN_REC.policy_id);
               END IF;   
            END LOOP;

           /* If facul_sw = TRUE, then distribution made has facultative and therefore */
           /* status should be 2 ONLY, since there is still a need for RI distribution */
           /*IF v_facul_sw = FALSE THEN
                UPDATE_DIST_BATCH1;
           ELSE
                UPDATE_DIST_BATCH2;
           END IF;*/
        END LOOP;
        
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 26, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Return list of records from GIUW_POL_DIST with the given batch_id
**                  	
*/
    
    FUNCTION get_pol_dist_by_batch_id(p_batch_id    IN  GIUW_POL_DIST.batch_id%TYPE)

    RETURN giuw_pol_dist_final_tab PIPELINED 

    IS

       v_pol_dist           giuw_pol_dist_final_type;

    BEGIN
        FOR i IN (SELECT a.dist_no,   a.par_id,       a.policy_id,           
                         a.tsi_amt,   a.prem_amt,     a.batch_id,             
                         a.iss_cd,    a.prem_seq_no,  a.item_grp,        
                         a.takeup_seq_no 
                  FROM GIUW_POL_DIST a
                  WHERE batch_id  = p_batch_id)
        LOOP
            v_pol_dist.dist_no        :=  i.dist_no;        
            v_pol_dist.par_id        :=  i.par_id;   
            v_pol_dist.policy_id     :=  i.policy_id;  
            v_pol_dist.tsi_amt       :=  i.tsi_amt;  
            v_pol_dist.prem_amt      :=  i.prem_amt;   
            v_pol_dist.batch_id      :=  i.batch_id;      
            v_pol_dist.iss_cd        :=  i.iss_cd;
            v_pol_dist.prem_seq_no   :=  i.prem_seq_no;
            v_pol_dist.item_grp      :=  i.item_grp; 
            v_pol_dist.takeup_seq_no :=  i.takeup_seq_no;
            
            PIPE ROW(v_pol_dist);
            
        END LOOP;
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 31, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : This procedure  is a part of the PROGRAM UNIT table_updates 
**                 under GIUWS015 which will update both underwriting and  
**                 reinsurance tables used for Post batch distribution process.     
*/

    PROCEDURE TABLE_UPDATES_GIUWS015_A(p_facul_sw      IN    VARCHAR2,
                                       p_policy_id     IN    GIUW_POL_DIST_POLBASIC_V.policy_id%TYPE,
                                       p_dist_no       IN    GIUW_POL_DIST_POLBASIC_V.dist_no%TYPE,
                                       p_line_cd       IN    GIUW_POL_DIST_POLBASIC_V.line_cd%TYPE,
                                       p_subline_cd    IN    GIUW_POL_DIST_POLBASIC_V.subline_cd%TYPE,
                                       p_iss_cd        IN    GIUW_POL_DIST_POLBASIC_V.iss_cd%TYPE,
                                       p_issue_yy      IN    GIUW_POL_DIST_POLBASIC_V.issue_yy%TYPE,
                                       p_pol_seq_no    IN    GIUW_POL_DIST_POLBASIC_V.pol_seq_no%TYPE,
                                       p_renew_no      IN    GIUW_POL_DIST_POLBASIC_V.renew_no%TYPE,
                                       p_user_id       IN    GIUW_POL_DIST_POLBASIC_V.user_id%TYPE)
    IS
                                       

    v_eff_date            GIUW_POL_DIST.eff_date%TYPE;        
    v_expiry_date         GIUW_POL_DIST.expiry_date%TYPE;
    v_dist_flag           VARCHAR2(1) := '3';

    BEGIN
        IF p_facul_sw = 'N' THEN
                      
            /* mark jm 10.12.2009 UW-SPECS-2009-00067 starts here */
            /* for updating GICL_CLM_RESERVE.REDIST_SW */
            BEGIN           
                SELECT eff_date, expiry_date
                    INTO v_eff_date, v_expiry_date
                    FROM GIUW_POL_DIST
                 WHERE policy_id = p_policy_id
                     AND dist_no = p_dist_no;
            END;
            
            FOR a IN (SELECT claim_id, loss_date          
                        FROM GICL_CLAIMS
                     WHERE line_cd = p_line_cd
                       AND subline_cd = p_subline_cd
                       AND pol_iss_cd = p_iss_cd
                       AND issue_yy = p_issue_yy
                       AND pol_seq_no = p_pol_seq_no
                       AND renew_no = p_renew_no) 
            LOOP        
                FOR b IN (SELECT item_no, peril_cd  
                            FROM GIUW_WITEMPERILDS
                           WHERE dist_no = p_dist_no) 
                LOOP            
                    FOR c IN (SELECT 1
                                FROM GICL_CLM_RESERVE
                              WHERE claim_id = a.claim_id
                                AND item_no  = b.item_no
                                AND peril_cd = b.peril_cd) 
                    LOOP                                    
                        IF p_facul_sw = 'N' AND (a.loss_date BETWEEN v_eff_date AND v_expiry_date) THEN                    
                            UPDATE GICL_CLM_RESERVE
                               SET redist_sw = 'Y'
                             WHERE claim_id = a.claim_id
                               AND item_no  = b.item_no
                               AND peril_cd = b.peril_cd;                
                        END IF;                
                    END LOOP;            
                END LOOP;            
            END LOOP;
           
          /* mark jm 10.12.09 UW-SPECS-2009-00067 ends here */
                      
          GIUW_POL_DIST_FINAL_PKG.del_dist_work_tables_giuws015(p_dist_no);
                  
          FOR A IN (SELECT c.fnl_binder_id--, c.replaced_flag
                      FROM GIRI_DISTFRPS a,
                           GIRI_FRPS_RI  b,
                           GIRI_BINDER   c,
                           GIUW_POL_DIST d
                     WHERE a.line_cd       = b.line_cd
                       AND a.frps_yy       = b.frps_yy
                       AND a.frps_seq_no   = b.frps_seq_no
                       AND b.fnl_binder_id = c.fnl_binder_id
                       AND a.dist_no       = d.dist_no
                       AND d.dist_flag     = 4
                       AND NVL(replaced_flag,'N') <> 'Y'
                       AND d.policy_id     = p_policy_id) 
              LOOP
                UPDATE GIRI_BINDER
                   SET replaced_flag = 'Y'
                 WHERE fnl_binder_id = a.fnl_binder_id;
                --EXIT;
              END LOOP;                              
           --<--bdarusin
        ELSE
            /* To create Reinsurance records in GIRI_WDISTFRPS */ 
            GIRI_WDISTFRPS_PKG.create_wdistfrps_giuws015(p_dist_no, p_policy_id, p_user_id);
        END IF;
                    
        /* Update GIUW_POL_DIST .., Update POST_FLAG to 'O' */ 
        /* If distribution has facultative share then DIST_FLAG = '2'*/
        /* otherwise, '3'*/
                
        IF p_facul_sw = 'Y' THEN
             v_dist_flag := '2';
        END IF;
                
        IF v_dist_flag = '3' THEN
             UPDATE GIUW_POL_DIST
                  SET dist_flag     = v_dist_flag,
                      post_flag     = 'O',
                      post_date     = SYSDATE,
                      user_id       = p_user_id,
                      last_upd_date = SYSDATE
                WHERE dist_no       = p_dist_no;
        ELSE         
             UPDATE GIUW_POL_DIST
                  SET dist_flag     = v_dist_flag,
                      post_flag     = 'O',
                      user_id       = p_user_id,
                      last_upd_date = SYSDATE
                 WHERE dist_no      = p_dist_no;    
        END IF; 
        /* Update GIPI_POLBASIC as to the current */
        /* distribution status of the policy      */
        UPDATE GIPI_POLBASIC             
         SET user_id       = p_user_id,
             last_upd_date = SYSDATE,
             dist_flag     = v_dist_flag
        WHERE policy_id    = p_policy_id;
                   
        /*PAU 12FEB08
        **UPDATE EXISTING CLAIMS WITH DISTRUBUTED RESERVE FOR THIS POLICY
        */
        UPDATE GICL_CLM_RESERVE
         SET redist_sw = 'Y'
        WHERE (claim_id, item_no, peril_cd) IN (SELECT claim_id, item_no, peril_cd
                                                  FROM GICL_CLM_RES_HIST
                                                 WHERE claim_id IN (SELECT claim_id
                                                                      FROM GICL_CLAIMS
                                                                      WHERE line_cd = p_line_cd
                                                                        AND subline_cd = p_subline_cd
                                                                        AND pol_iss_cd = p_iss_cd
                                                                        AND issue_yy = p_issue_yy
                                                                        AND pol_seq_no = p_pol_seq_no
                                                                        AND renew_no = p_renew_no)
                                                                        AND dist_sw = 'Y')
        AND (item_no, peril_cd) IN (SELECT item_no, peril_cd
                                      FROM GIUW_ITEMPERILDS
                                     WHERE dist_no = p_dist_no
                                       AND dist_seq_no IN (SELECT MAX(dist_seq_no)
                                                             FROM GIUW_ITEMPERILDS
                                                            WHERE dist_no = p_dist_no));
    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 31, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : This procedure  is a part of the PROGRAM UNIT table_updates 
**                 under GIUWS015 which will update both underwriting and  
**                 reinsurance tables used for Post batch distribution process.     
*/

    PROCEDURE TABLE_UPDATES_GIUWS015_B(p_facul_sw      IN    VARCHAR2,
                                       p_policy_id     IN    GIUW_POL_DIST_POLBASIC_V.policy_id%TYPE,
                                       p_dist_no       IN    GIUW_POL_DIST_POLBASIC_V.dist_no%TYPE,
                                       p_user_id       IN    GIUW_POL_DIST_POLBASIC_V.user_id%TYPE,
                                       p_message       OUT   VARCHAR2,
                                       p_workflow_msg  OUT   VARCHAR2)
    IS

    v_dist_flag           VARCHAR2(1) := '3';
    v_message             VARCHAR2(1000); 
    v_workflow_msg        VARCHAR2(1000);


    BEGIN
        
        IF p_facul_sw = 'Y' THEN
           v_dist_flag := '2';
        END IF;

        IF v_dist_flag = '3' THEN
                
            /* A.R.C. 02.03.2006
           ** to create workflow records of Policy/Endt.  Redistribution */        
           FOR a1 IN (SELECT DISTINCT claim_id
                        FROM GICL_CLAIMS b,
                             GIPI_POLBASIC a
                       WHERE b.line_cd = a.line_cd
                         AND b.subline_cd = a.subline_cd
                         AND b.iss_cd = a.iss_cd                     
                         AND b.issue_yy = a.issue_yy 
                         AND b.pol_seq_no = a.pol_seq_no
                         AND b.renew_no = a.renew_no
                         AND b.clm_stat_cd NOT IN ('CC','WD','DN')
                         AND a.policy_id = p_policy_id)
           LOOP    
             FOR c1 IN (SELECT b.userid, d.event_desc  
                            FROM GIIS_EVENTS_COLUMN c, 
                                 GIIS_EVENT_MOD_USERS b, 
                                 GIIS_EVENT_MODULES a, 
                                 GIIS_EVENTS d
                           WHERE 1=1
                           AND c.event_cd = a.event_cd
                           AND c.event_mod_cd = a.event_mod_cd
                           AND b.event_mod_cd = a.event_mod_cd
                           AND b.passing_userid = p_user_id
                           AND a.module_id = 'GIUWS012'
                           AND a.event_cd = d.event_cd
                           AND UPPER(d.event_desc) = 'POLICY/ENDT.  REDISTRIBUTION')
             LOOP
               CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIUWS012', c1.userid, a1.claim_id, c1.event_desc||' '||get_clm_no(a1.claim_id), v_message, v_workflow_msg, NVL(giis_users_pkg.app_user,USER));
             END LOOP; 
             
           END LOOP;
               
          FOR A IN (SELECT '1'
                      FROM EIM_TAKEUP_INFO
                     WHERE policy_id = p_policy_id
                       AND eim_flag = '2')
          LOOP
              UPDATE EIM_TAKEUP_INFO 
                  SET eim_flag = '6',
                      undist_sw = 'Y'
             WHERE policy_id = p_policy_id;
            EXIT;
          END LOOP;
        END IF;
               
          -- A.R.C. 08.13.2004 --
      -- to delete workflow records of Final Distribution --
          delete_workflow_rec('Final Distribution','GIPIS055', p_user_id, p_policy_id);   
                         
       /* UPDATE GIUW_WPERILDS and GIUW_WPOLICYDS */
       /* as to the current distribution status   */
       /* of the policy  */
           IF p_facul_sw = 'Y' THEN
                   UPDATE GIUW_WPERILDS
                      SET dist_flag = v_dist_flag
                    WHERE dist_no   = p_dist_no;
                                
                   UPDATE GIUW_WPOLICYDS
                      SET dist_flag = v_dist_flag
                    WHERE dist_no   = p_dist_no;

              /* A.R.C. 08.16.2004
              ** to create workflow records of Facultative Placement */        
            FOR c1 IN (SELECT b.userid, d.event_desc  
                         FROM GIIS_EVENTS_COLUMN c, 
                              GIIS_EVENT_MOD_USERS b, 
                              GIIS_EVENT_MODULES a, 
                              GIIS_EVENTS d
                        WHERE 1=1
                          AND c.event_cd = a.event_cd
                          AND c.event_mod_cd = a.event_mod_cd
                          AND b.event_mod_cd = a.event_mod_cd
                        --AND b.userid <> USER  --A.R.C. 01.23.2006
                          AND b.passing_userid = p_user_id  --A.R.C. 01.23.2006
                          AND a.module_id = 'GIUWS012'
                          AND a.event_cd = d.event_cd
                          AND UPPER(d.event_desc) = 'FACULTATIVE PLACEMENT')
            LOOP
                CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIUWS012', c1.userid, p_policy_id, c1.event_desc||' '||get_policy_no(p_policy_id), v_message, v_workflow_msg, NVL(giis_users_pkg.app_user,USER));
            END LOOP;
           END IF;
                   
           /* A.R.C. 08.16.2004
           ** to delete workflow records of Distribution Negation */
           delete_workflow_rec('Distribution Negation','GIUTS002',p_user_id, p_policy_id);
          
          /* A.R.C. 06.28.2005
          ** to delete workflow records of Undistributed policies awaiting claims */
          
          IF p_facul_sw = 'N' THEN
             FOR c1 IN (SELECT claim_id
                          FROM GICL_CLAIMS b, GIPI_POLBASIC a
                         WHERE 1=1
                           AND b.line_cd = a.line_cd
                           AND b.subline_cd = a.subline_cd 
                           AND b.iss_cd = a.iss_cd
                           AND b.issue_yy = a.issue_yy
                           AND b.pol_seq_no = a.pol_seq_no
                           AND b.renew_no = a.renew_no
                           AND a.policy_id = p_policy_id)
             LOOP    
               delete_workflow_rec('Undistributed policies awaiting claims','GICLS010', p_user_id, c1.claim_id);  
             END LOOP;             
             --A.R.C. 02.07.2007
            --added to delete the workflow facultative placement of GIUWS012 if not facul
            DELETE_WORKFLOW_REC('Facultative Placement','GIUWS012', p_user_id, p_policy_id);
          END IF;   
           
    END;
    
    /**
    **  Created by:     Gzelle Ison
    **  Date Created:   07.03.2011
    **  Referenced by:  GIUWS018 - Set-up Peril Groups Distribution for Final 
    **  Description:    PRE-QUERY trigger in C150 - EXISTING_ITEMPERILS recordgroup
    **/
    FUNCTION get_giuw_witemperilds_rec(
        p_dist_no   gipi_polbasic_pol_dist_v1.dist_no%TYPE
    )
        RETURN giuw_witemperilds_rec_tab PIPELINED
    IS
        rec giuw_witemperilds_rec_type;
    BEGIN       
        FOR a IN(SELECT b.dist_seq_no dist_seq_no ,
                        b.item_no     item_no ,
                        b.peril_cd    peril_cd  
                   FROM giuw_witemperilds b 
                  WHERE b.dist_no     = p_dist_no
               ORDER BY b.dist_seq_no, b.peril_cd)
        
        LOOP
            rec.dist_seq_no := a.dist_seq_no;
            rec.item_no     := a.item_no;
            rec.peril_cd    := a.peril_cd;
            
            PIPE ROW(rec);
        END LOOP;
    END;       

        /**
    **  Created by:     Gzelle Ison
    **  Date Created:   07.03.2011
    **  Referenced by:  GIUWS018 - Set-up Peril Groups Distribution for Final 
    **  Description:    PRE-QUERY trigger in C150 - EXISTING_ITEMPERILS recordgroup
    **/
    PROCEDURE CRTE_REGRPED_DIST_RECS_FINAL
         (p_dist_no       IN giuw_pol_dist.dist_no%TYPE    ,
          p_policy_id     IN gipi_polbasic.policy_id%TYPE  ,
          p_line_cd       IN gipi_polbasic.line_cd%TYPE    ,
          p_subline_cd    IN gipi_polbasic.subline_cd%TYPE ,
          p_iss_cd        IN gipi_polbasic.iss_cd%TYPE     ,
          p_pack_pol_flag IN gipi_polbasic.pack_pol_flag%TYPE) IS
          
          v_line_cd             gipi_polbasic.line_cd%TYPE;
          v_subline_cd          gipi_polbasic.subline_cd%TYPE;
          v_currency_rt         gipi_item.currency_rt%TYPE;
          v_dist_seq_no         giuw_wpolicyds.dist_seq_no%TYPE := 0;
          rg_count              NUMBER;
          v_exist               VARCHAR2(1);
          v_default_no          giis_default_dist.default_no%TYPE;
          v_default_type        giis_default_dist.default_type%TYPE;
          v_dflt_netret_pct     giis_default_dist.dflt_netret_pct%TYPE;
          v_dist_type           giis_default_dist.dist_type%TYPE;
          v_post_flag           VARCHAR2(1)  := 'O';
          v_package_policy_sw   VARCHAR2(1)  := 'Y';
          v_exist2              VARCHAR2(1);
          v_item                giuw_witemds.item_no%TYPE;
          dist_cnt              NUMBER;
          dist_max              giuw_pol_dist.dist_no%type;
          v_item_grp            giuw_pol_dist.item_grp%type;       
    BEGIN
    
    /* jhing 11.28.2014  recreate the witemperilds and witemds 
    **
    */
    GIUW_POL_DIST_FINAL_PKG.recrte_grp_ds_tables_giuws018 (p_dist_no , p_policy_id );  
    
    
    -- ==========================================================================================
    
    
      /*   SELECT item_grp
          INTO v_item_grp
          FROM giuw_pol_dist
         WHERE policy_id = p_policy_id
           AND dist_no = p_dist_no;
        
        IF v_item_grp IS NULL THEN   
            SELECT count(*), max(dist_no)
              INTO dist_cnt, dist_max
              FROM giuw_pol_dist
             WHERE policy_id = p_policy_id
               AND item_grp IS NULL
              -- and dist_flag not in (3,4,5); --VJP 041210 -- jhing 11.26.2014 replaced with:
              and dist_flag NOT IN ( 4, 5 ); 
        ELSE
            SELECT count(*), max(dist_no)
              INTO dist_cnt, dist_max
              FROM giuw_pol_dist
             WHERE policy_id = p_policy_id
               AND item_grp = v_item_grp; 
        END IF;
            
        FOR c1 IN (SELECT dist_seq_no , tsi_amt  , prem_amt ,
                            ann_tsi_amt , item_grp , rowid
                       FROM giuw_wpolicyds
                      WHERE dist_no = p_dist_no)
        LOOP
            v_dist_seq_no := c1.dist_seq_no; 
            
            --this for loop is to get PACK_LINE_CD and PACK_SUBLINE_CD
            --from GIPI_ITEM for PACKAGE POLICY.
            FOR c2 IN (SELECT currency_rt , pack_line_cd , pack_subline_cd
                         FROM gipi_item
                        WHERE item_grp  = c1.item_grp
                          AND policy_id = p_policy_id)
            LOOP

              v_currency_rt := c2.currency_rt;

              /* If the record processed is a package policy
              ** then get the true LINE_CD and true SUBLINE_CD,
              ** that is, the PACK_LINE_CD and PACK_SUBLINE_CD 
              ** from the GIPI_ITEM table.
              ** This will be used upon inserting to certain
              ** distribution tables requiring a value for
              ** the similar field. */
       /*       IF p_pack_pol_flag = 'N' THEN
                 v_line_cd    := p_line_cd;
                 v_subline_cd := p_subline_cd;
              ELSE
                 v_line_cd           := c2.pack_line_cd;
                 v_subline_cd        := c2.pack_subline_cd;
                 v_package_policy_sw := 'Y';
              END IF;
              EXIT;
            END LOOP;
            
            --if it is a PACKAGE POLICY ...
            /*IF v_package_policy_sw = 'Y' THEN
               FOR c2 IN (SELECT default_no, default_type, dist_type,
                                 dflt_netret_pct
                            FROM giis_default_dist
                           WHERE iss_cd     = p_iss_cd
                             AND subline_cd = v_subline_cd
                             AND line_cd    = v_line_cd)
               LOOP
                 v_default_no      := c2.default_no;
                 v_default_type    := c2.default_type;
                 v_dist_type       := c2.dist_type;
                 v_dflt_netret_pct := c2.dflt_netret_pct;
                 EXIT;
               END LOOP;
               
               IF NVL(v_dist_type, '1') = '1' THEN
                  rg_count := 0;
                  FOR i IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                           a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                   1 true_pct 
                              FROM giis_default_dist_group a 
                             WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
                               AND a.line_cd    =  v_line_cd
                               AND a.share_cd   <> 999 
                          ORDER BY a.sequence ASC)
                  LOOP
                    rg_count := i.rownum;
                  END LOOP;
               END IF;
              
               v_package_policy_sw := 'N';
            END IF; --end of script for PACKAGE POLICY  */ -- jhing 11.25.2014 commented out 
            
            -- jhing 11.26.2014 regardless of dist_type just use RECRTE_GRP_DFLT_DIST_GWS018. This table will now only 
            -- populate the DS tables. The DTL tables will be populated in another procedure.
       /*     GIUW_POL_DIST_FINAL_PKG.RECRTE_GRP_DFLT_DIST_GWS018
                       (p_dist_no      , c1.dist_seq_no , '2'            ,
                        c1.tsi_amt     , c1.prem_amt    , c1.ann_tsi_amt ,
                        c1.item_grp    , v_line_cd      , rg_count       ,
                        v_default_type , v_currency_rt  , p_policy_id    ,
                        v_default_no);                    
         
            
            -- jhing 11.26.2014 commented out 
           /* IF NVL(v_dist_type, '1') = '1' THEN
               v_post_flag := 'O';
               
               GIUW_POL_DIST_FINAL_PKG.RECRTE_GRP_DFLT_DIST_GWS018
                       (p_dist_no      , c1.dist_seq_no , '2'            ,
                        c1.tsi_amt     , c1.prem_amt    , c1.ann_tsi_amt ,
                        c1.item_grp    , v_line_cd      , rg_count       ,
                        v_default_type , v_currency_rt  , p_policy_id    ,
                        v_default_no);
            ELSIF v_dist_type = '2' THEN 
               v_post_flag := 'P';
               GIUW_POL_DIST_FINAL_PKG.RECRTE_PERIL_DFLT_DIST_GWS018
                   (p_dist_no      , c1.dist_seq_no    , '2'            ,
                    c1.tsi_amt     , c1.prem_amt       , c1.ann_tsi_amt ,
                    c1.item_grp    , v_line_cd         , v_default_no   ,
                    v_default_type , v_dflt_netret_pct , v_currency_rt  ,
                    p_policy_id);
            END IF; */
            
            
     /*   END LOOP;
        
      -- jhing 11.26.2014 call the new procedure for populating default distribution 
      GIUW_POL_DIST_FINAL_PKG.POPULATE_DEFAULT_DIST ( p_dist_no, v_post_flag, v_dist_type );  
	        

      /* Adjust computational floats to equalize the amounts
      ** attained by the master tables with that of its detail
      ** tables.
      ** Tables involved:  GIUW_WPERILDS     - GIUW_WPERILDS_DTL
      **                   GIUW_WPOLICYDS    - GIUW_WPOLICYDS_DTL
      **                   GIUW_WITEMDS      - GIUW_WITEMDS_DTL
      **                   GIUW_WITEMPERILDS - GIUW_WITEMPERILDS_DTL */
       --  ADJUST_NET_RET_IMPERFECTION(p_dist_no);  -- jhing 11.25.2014 commented out 

      /* Create records in RI tables if a facultative
      ** share exists in any of the DIST_SEQ_NO in table
      ** GIUW_WPOLICYDS_DTL. */
      --   GIUW_POL_DIST_FINAL_PKG.CREATE_RI_RECORDS_GIUWS010(p_dist_no, p_policy_id, p_line_cd, p_subline_cd); -- jhing 11.25.2014 commented out 

      /* Set the value of the DIST_FLAG back 
      ** to Undistributed after recreation. */

    /*  UPDATE giuw_pol_dist
         SET dist_flag = '1',
             post_flag = v_post_flag,
             dist_type = '2'
       WHERE policy_id = p_policy_id
         AND dist_no   = p_dist_no;   */  
    END;        
        
    PROCEDURE validate_item_peril_amt_shr (
       p_dist_no     giuw_pol_dist_polbasic_v.dist_no%TYPE,
       p_module_id   VARCHAR2
    )
    IS
    BEGIN
       IF p_module_id = 'GIUWS013' OR p_module_id = 'GIUWS016'
       THEN
          FOR i IN (SELECT dist_spct, dist_tsi, dist_prem
                      FROM giuw_wpolicyds_dtl
                     WHERE dist_no = p_dist_no)
          LOOP
             IF i.dist_spct IS NULL OR i.dist_tsi IS NULL OR i.dist_prem IS NULL
             THEN
                raise_application_error
                   (-20001,
                    'Geniisys Exception#I#There are null share % in distribution tables. To correct this error, please recreate using Set-Up Groups for Distribution (Item).'
                   );
             END IF;
          END LOOP;
       ELSE
          FOR i IN (SELECT dist_spct, dist_tsi, dist_prem
                      FROM giuw_witemds_dtl
                     WHERE dist_no = p_dist_no)
          LOOP
             IF i.dist_spct IS NULL OR i.dist_tsi IS NULL OR i.dist_prem IS NULL
             THEN
                raise_application_error
                   (-20001,
                    'Geniisys Exception#I#There are null premium and/or share % in distribution tables. To correct this error, please recreate using Set-Up Groups for Distribution (Item).'
                   );
             END IF;
          END LOOP;

          FOR i IN (SELECT dist_spct, dist_tsi, dist_prem
                      FROM giuw_wperilds_dtl
                     WHERE dist_no = p_dist_no)
          LOOP
             IF i.dist_spct IS NULL OR i.dist_tsi IS NULL OR i.dist_prem IS NULL
             THEN
                raise_application_error
                   (-20001,
                    'Geniisys Exception#I#There are null premium and/or share % in distribution tables. To correct this error, please recreate using Set-Up Groups for Distribution (Item).'
                   );
             END IF;
          END LOOP;

          FOR i IN (SELECT dist_spct, dist_tsi, dist_prem
                      FROM giuw_witemperilds_dtl
                     WHERE dist_no = p_dist_no)
          LOOP
             IF i.dist_spct IS NULL OR i.dist_tsi IS NULL OR i.dist_prem IS NULL
             THEN
                raise_application_error
                   (-20001,
                    'Geniisys Exception#I#There are null premium and/or share % in distribution tables. To correct this error, please recreate using Set-Up Groups for Distribution (Item).'
                   );
             END IF;
          END LOOP;
       END IF;
    END;
    
    /********** shan 07.29.2014 **********/
    
    PROCEDURE CRT_GRP_DFLT_WITEMDS_GW18
         (p_dist_no			IN giuw_witemds_dtl.dist_no%TYPE      ,
          p_dist_seq_no		IN giuw_witemds_dtl.dist_seq_no%TYPE  ,
          p_item_no			IN giuw_witemds_dtl.item_no%TYPE      ,
          p_line_cd			IN giuw_witemds_dtl.line_cd%TYPE      ,
          p_dist_tsi		IN giuw_witemds_dtl.dist_tsi%TYPE     ,
          p_dist_prem		IN giuw_witemds_dtl.dist_prem%TYPE    ,
          p_ann_dist_tsi	IN giuw_witemds_dtl.ann_dist_tsi%TYPE ,
          p_rg_count		IN NUMBER,
		  p_v_default_no	IN giis_default_dist.default_no%TYPE) 
    IS
          v_row					NUMBER;
          v_dist_spct			giuw_witemds_dtl.dist_spct%TYPE;
          v_dist_tsi			giuw_witemds_dtl.dist_tsi%TYPE;
          v_dist_prem			giuw_witemds_dtl.dist_prem%TYPE;
          v_ann_dist_tsi		giuw_witemds_dtl.ann_dist_tsi%TYPE;
          v_share_cd			giis_dist_share.share_cd%TYPE;
          v_sum_dist_tsi		giuw_witemds_dtl.dist_tsi%TYPE     := 0;
          v_sum_dist_spct		giuw_witemds_dtl.dist_spct%TYPE    := 0;
          v_sum_dist_prem		giuw_witemds_dtl.dist_prem%TYPE    := 0;
          v_sum_ann_dist_tsi		giuw_witemds_dtl.ann_dist_tsi%TYPE := 0;
          v_pol_flag               GIPI_POLBASIC_POL_DIST_V1.POL_FLAG%type; 
          v_par_type               GIPI_POLBASIC_POL_DIST_V1.PAR_TYPE%type;
          v_policy_id              GIPI_POLBASIC_POL_DIST_V1.POLICY_ID%type; 
          v_dflt_policy_exists     BOOLEAN := FALSE;   
          v_dist_spct1             giuw_witemds_dtl.DIST_SPCT1%type;
          v_par_id              gipi_polbasic_pol_dist_v1.PAR_ID%type;
          v_dist_seq_no         giuw_wpolicyds_dtl.dist_seq_no%TYPE;--edgar 09/08/2014   
          v_dist_spct1_chk      BOOLEAN := FALSE;--edgar 09/12/2014       
      
          PROCEDURE INSERT_TO_WITEMDS_DTL IS
          BEGIN
                IF v_dist_spct1_chk THEN/*added edgar 09/12/2014*/
                    v_dist_spct1 := v_dist_spct;
                END IF;/*ended edgar 09/12/2014*/                  
               INSERT INTO  giuw_witemds_dtl
                        (dist_no     , dist_seq_no   , line_cd        ,
                         share_cd    , dist_spct     , dist_tsi       ,
                         dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                         dist_grp    , item_no,
                         dist_spct1)
                 VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                         v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                         v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                         1           , p_item_no,
                         v_dist_spct1);
          END;

        PROCEDURE insert_dflt_values
        IS
        BEGIN
            IF p_rg_count = 0 THEN
                 /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_dist_tsi;
                 v_dist_prem    := p_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WITEMDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;

            ELSE
                 FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                     a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                     1 true_pct 
                                FROM giis_default_dist_group a  
                               WHERE a.default_no = TO_CHAR(NVL(p_v_default_no, 0))
                                 AND a.line_cd    = p_line_cd
                                 AND a.share_cd   <> 999
                               ORDER BY a.sequence ASC)
                 LOOP
                    --v_row           := GET_GROUP_SELECTION(rg_id, c);
                    v_row           := c.rownum;
                    --v_dist_spct     := GET_GROUP_NUMBER_CELL(rg_col7, v_row);
                    --v_dist_spct     := c.true_pct;
                    v_dist_spct     := c.share_pct; -- andrew - 09.24.2012 - replaced true_pct by share_pct;
                    
                     IF v_dist_spct IS NULL THEN         
                         FOR h IN (SELECT dist_spct
                                     FROM giuw_wpolicyds_dtl
                                    WHERE line_cd = c.line_cd
                                      AND share_cd = c.share_cd
                                      AND dist_no = p_dist_no)
                         LOOP
                            v_dist_spct := h.dist_spct;
                            EXIT;
                         END LOOP; 
                     END IF;
                     
                    v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
                    IF v_sum_dist_spct != 100 THEN
                        v_dist_tsi         := ROUND(p_dist_tsi     * v_dist_spct / 100, 2);
                        v_dist_prem        := ROUND(p_dist_prem    * v_dist_spct / 100, 2);
                        v_ann_dist_tsi     := ROUND(p_ann_dist_tsi * v_dist_spct / 100, 2);
                        v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                        v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                        v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
                    ELSE
                        v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                        v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                        v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                    END IF;
                    
                    --v_share_cd     := GET_GROUP_NUMBER_CELL(rg_col2, v_row);
                    v_share_cd     := c.share_cd;
                    INSERT_TO_WITEMDS_DTL;
                 END LOOP;
                 
                 IF v_sum_dist_spct != 100 THEN
                   v_dist_spct    := 100            - v_sum_dist_spct;
                   v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                   v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                   v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                   v_share_cd     := '999';
                   --p_rg_count     := p_rg_count + 1;
                   INSERT_TO_WITEMDS_DTL;
                 END IF;

            END IF;   
        END;
        
    BEGIN
        FOR i IN (SELECT *
                    FROM GIPI_POLBASIC_POL_DIST_V1 
                   WHERE policy_id = (SELECT policy_id
                                        FROM giuw_pol_dist
                                       WHERE dist_no = p_dist_no))
        LOOP
            v_pol_flag  := i.pol_flag;
            v_par_type  := i.par_type;
            v_policy_id := i.policy_id;
            v_par_id    := i.par_id;
            EXIT;
        END LOOP;
        
        IF v_pol_flag = '2' THEN
            v_dflt_policy_exists := FALSE;
             v_dist_spct1_chk := FALSE;--edgar 09/12/2014
            /*uncomment out edgar 09/09/2014*/
            FOR c IN ( SELECT share_cd, dist_spct, dist_spct1  -- commented out retrieving of default share from original policy for now : shan 08.06.2014
		                 FROM giuw_itemds_dtl a
                        WHERE a.dist_seq_no = p_dist_seq_no
                          AND a.item_no = p_item_no
                          AND dist_no = ( SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE policy_id = ( SELECT MAX(old_policy_id) --edgar 09/17/21014
                                                                 FROM GIPI_POLNREP
                                                                WHERE par_id = v_par_id
                                                                  AND ren_rep_sw = '1'/*added edgar 09/12/2014*/
                                                                  AND new_policy_id = (SELECT policy_id
                                                                                         FROM gipi_polbasic
                                                                                        WHERE pol_flag <> '5'
                                                                                          AND policy_id = v_policy_id))))/*ended edgar 09/12/2014*/
		    LOOP     	
		       v_dist_spct1_chk := FALSE;--edgar 09/12/2014
		       v_share_cd     := c.share_cd;
		       v_dist_spct    := c.dist_spct;
               v_dist_spct1     := c.dist_spct1;
		       v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
		       v_dist_prem        := ROUND(((p_dist_prem    * NVL(c.dist_spct1, c.dist_spct))/ 100), 2);
		       v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
		       v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
		       v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
		       v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
		       INSERT_TO_WITEMDS_DTL;
			   v_dflt_policy_exists   := TRUE;
            END LOOP; --*/--edgar 09/08/2014 
            
            /*IF v_dflt_policy_exists = FALSE THEN
                insert_dflt_values;
            END IF;*/--commented out edgar 09/09/2014
              /*added edgar 09/08/2014*/
                 v_dist_spct1_chk := FALSE;--edgar 09/12/2014
                FOR i IN (SELECT '1' /*checks for records having dist_spct1 to insert correct dist_spct1*/
                            FROM giuw_witemds_dtl
                           WHERE dist_no = p_dist_no
                             AND dist_spct1 IS NOT NULL)
                LOOP
                    v_dist_spct1_chk := TRUE;
                    EXIT;
                END LOOP;
                          
              IF NOT v_dflt_policy_exists
              THEN
                 insert_dflt_values;
              END IF;
           /*ended edgar 09/08/2014*/            
        ELSIF v_par_type = 'E' THEN
            /*uncommented out edgar 09/08/2014*/
            v_dflt_policy_exists := FALSE; --edgar 09/08/2014
            FOR c IN ( SELECT dist_no, share_cd, dist_spct, dist_spct1  -- commented out retrieving of default share from original policy for now : shan 08.06.2014
                         FROM giuw_itemds_dtl a
                        WHERE 1 = 1
                          AND a.dist_seq_no = p_dist_seq_no
                          AND a.item_no = p_item_no
                          AND dist_no = ( SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE par_id = ( SELECT par_id
                                                              FROM GIPI_POLBASIC
                                                             WHERE endt_seq_no = 0
                                                               AND (line_cd,         subline_cd, 
                                                                    iss_cd,         issue_yy, 
                                                                    pol_seq_no,    renew_no) = (SELECT line_cd,         subline_cd, 
                                                                                                       iss_cd,         issue_yy, 
                                                                                                       pol_seq_no, renew_no
                                                                                                  FROM GIPI_POLBASIC
                                                                                                 WHERE policy_id = v_policy_id))))
            LOOP
                 v_share_cd         := c.share_cd;
                 v_dist_spct        := c.dist_spct;
                 v_dist_spct1       := c.dist_spct1;
                 v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                 v_dist_prem        := ROUND(((p_dist_prem    * NVL(c.dist_spct1, c.dist_spct))/ 100), 2);
                 v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                 v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                 v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                 v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);		       
		         INSERT_TO_WITEMDS_DTL;
                 v_dflt_policy_exists   := TRUE;
            END LOOP; --*/--edgar 09/08/2014 
            
            /*IF v_dflt_policy_exists = FALSE THEN
                insert_dflt_values;
            END IF;*/--commented otu edgar 09/09/2014
              /*added edgar 09/08/2014*/
              IF NOT v_dflt_policy_exists
              THEN
                 insert_dflt_values;
              END IF;
           /*ended edgar 09/08/2014*/            
        ELSE
            insert_dflt_values;
        END IF; 
    END;
    
    PROCEDURE CRT_GRP_DFLT_WITEMPERILDS_GW18
         (p_dist_no			IN giuw_witemperilds_dtl.dist_no%TYPE      ,
          p_dist_seq_no		IN giuw_witemperilds_dtl.dist_seq_no%TYPE  ,
          p_item_no			IN giuw_witemperilds_dtl.item_no%TYPE      ,
          p_line_cd			IN giuw_witemperilds_dtl.line_cd%TYPE      ,
          p_peril_cd		IN giuw_witemperilds_dtl.peril_cd%TYPE     ,
          p_dist_tsi		IN giuw_witemperilds_dtl.dist_tsi%TYPE     ,
          p_dist_prem		IN giuw_witemperilds_dtl.dist_prem%TYPE    ,
          p_ann_dist_tsi	IN giuw_witemperilds_dtl.ann_dist_tsi%TYPE ,
          p_rg_count		IN NUMBER,
		  p_v_default_no	IN giis_default_dist.default_no%TYPE)
    IS
          v_row					NUMBER;
          v_dist_spct			giuw_witemperilds_dtl.dist_spct%TYPE;
          v_dist_tsi			giuw_witemperilds_dtl.dist_tsi%TYPE;
          v_dist_prem			giuw_witemperilds_dtl.dist_prem%TYPE;
          v_ann_dist_tsi		giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
          v_share_cd			giis_dist_share.share_cd%TYPE;
          v_sum_dist_tsi		giuw_witemperilds_dtl.dist_tsi%TYPE     := 0;
          v_sum_dist_spct		giuw_witemperilds_dtl.dist_spct%TYPE    := 0;
          v_sum_dist_prem		giuw_witemperilds_dtl.dist_prem%TYPE    := 0;
          v_sum_ann_dist_tsi		giuw_witemperilds_dtl.ann_dist_tsi%TYPE := 0;
          v_pol_flag               GIPI_POLBASIC_POL_DIST_V1.POL_FLAG%type; 
          v_par_type               GIPI_POLBASIC_POL_DIST_V1.PAR_TYPE%type; 
          v_policy_id              GIPI_POLBASIC_POL_DIST_V1.POLICY_ID%type; 
          v_dflt_policy_exists     BOOLEAN := FALSE; 
          v_dist_spct1          giuw_witemperilds_dtl.DIST_SPCT1%type;  
          v_par_id              gipi_polbasic_pol_dist_v1.PAR_ID%type;
          v_dist_seq_no          giuw_wpolicyds_dtl.dist_seq_no%TYPE;--edgar 09/08/2014   
          v_dist_spct1_chk      BOOLEAN := FALSE;--edgar 09/12/2014       
      
          PROCEDURE INSERT_TO_WITEMPERILDS_DTL IS
          BEGIN
            IF v_dist_spct1_chk THEN/*added edgar 09/12/2014*/
                v_dist_spct1 := v_dist_spct;
            END IF;/*ended edgar 09/12/2014*/              
            INSERT INTO  giuw_witemperilds_dtl
                        (dist_no     , dist_seq_no   , line_cd        ,
                         share_cd    , dist_spct     , dist_tsi       ,
                         dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                         dist_grp    , item_no       , peril_cd,
                         dist_spct1)
                 VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                         v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                         v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                         1           , p_item_no     , p_peril_cd,
                         v_dist_spct1);
          END;

         PROCEDURE insert_dflt_values
         IS
         BEGIN
            IF p_rg_count = 0 THEN 

                 /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_dist_tsi;
                 v_dist_prem    := p_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WITEMPERILDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;

            ELSE

                 --rg_id             := FIND_GROUP(rg_name);
                 --v_selection_count := GET_GROUP_SELECTION_COUNT(rg_id);

                 FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                     a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                     1 true_pct 
                                FROM giis_default_dist_group a  
                               WHERE a.default_no = TO_CHAR(NVL(p_v_default_no, 0))
                                 AND a.line_cd    = p_line_cd
                                 AND a.share_cd   <> 999
                               ORDER BY a.sequence ASC)
                 LOOP
                   --v_row           := GET_GROUP_SELECTION(rg_id, c);
                   v_row           := c.rownum;
                   --v_dist_spct     := GET_GROUP_NUMBER_CELL(rg_col7, v_row);
                   --v_dist_spct     := c.true_pct;
                   v_dist_spct     := c.share_pct; -- andrew - 09.24.2012 - replaced true_pct by share_pct;
                   
                   IF v_dist_spct IS NULL THEN         
                         FOR h IN (SELECT dist_spct
                                     FROM giuw_wpolicyds_dtl
                                    WHERE line_cd = c.line_cd
                                      AND share_cd = c.share_cd
                                      AND dist_no = p_dist_no)
                         LOOP
                            v_dist_spct := h.dist_spct;
                            EXIT;
                         END LOOP; 
                   END IF;
         
                   v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
                   IF v_sum_dist_spct != 100 THEN
                      v_dist_tsi         := ROUND(p_dist_tsi         * v_dist_spct / 100, 2);
                      v_dist_prem        := ROUND(p_dist_prem        * v_dist_spct / 100, 2);
                      v_ann_dist_tsi     := ROUND(p_ann_dist_tsi     * v_dist_spct / 100, 2);
                      v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                      v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                      v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
                   ELSE
                      v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                      v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                      v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                   END IF;
                   --v_share_cd     := GET_GROUP_NUMBER_CELL(rg_col2, v_row);
                   v_share_cd     := c.share_cd;
                   INSERT_TO_WITEMPERILDS_DTL;
                 END LOOP;
                
                 IF v_sum_dist_spct != 100 THEN
                   v_dist_spct    := 100            - v_sum_dist_spct;
                   v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                   v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                   v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                   v_share_cd     := '999';
                   --p_rg_count     := p_rg_count + 1;
                   INSERT_TO_WITEMPERILDS_DTL;
                 END IF;
            END IF;
         END;
         
    BEGIN
        FOR i IN (SELECT *
                    FROM GIPI_POLBASIC_POL_DIST_V1 
                   WHERE policy_id = (SELECT policy_id
                                        FROM giuw_pol_dist
                                       WHERE dist_no = p_dist_no))
        LOOP
            v_pol_flag  := i.pol_flag;
            v_par_type  := i.par_type;
            v_policy_id := i.policy_id;
            v_par_id    := i.par_id;
            EXIT;
        END LOOP;
        
        IF v_pol_flag = '2' THEN
           v_dflt_policy_exists := FALSE;   --edgar 09/08/2014
           v_dist_spct1_chk := FALSE;--edgar 09/12/2014
          /*uncommented out by edgar 09/08/2014*/           
           FOR c IN ( SELECT share_cd, dist_spct, dist_spct1  -- commented out retrieving of default share from original policy for now : shan 08.06.2014
		                 FROM giuw_itemperilds_dtl a
                        WHERE a.dist_seq_no = p_dist_seq_no
                          --AND a.item_no = p_item_no --edgar 09/12/2014
                          --AND a.peril_cd = p_peril_cd --edgar 09/12/2014
                          AND dist_no = ( SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE policy_id = ( SELECT MAX(old_policy_id) --edgar 09/17/21014 
                                                                 FROM GIPI_POLNREP
                                                                WHERE par_id = v_par_id
                                                                  AND ren_rep_sw = '1'/*added edgar 09/12/2014*/
                                                                  AND new_policy_id = (SELECT policy_id
                                                                                         FROM gipi_polbasic
                                                                                        WHERE pol_flag <> '5'
                                                                                          AND policy_id = v_policy_id)))
                     GROUP BY share_cd, dist_spct, dist_spct1)/*ended edgar 09/12/2014*/
		    LOOP
		       v_dist_spct1_chk := FALSE;--edgar 09/12/2014     	
		       v_share_cd     := c.share_cd;
		       v_dist_spct    := c.dist_spct;
               v_dist_spct1     := c.dist_spct1;
		       v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
		       v_dist_prem        := ROUND(((p_dist_prem    * NVL(c.dist_spct1, c.dist_spct))/ 100), 2);
		       v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
		       v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
		       v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
		       v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
		       INSERT_TO_WITEMPERILDS_DTL;
			   v_dflt_policy_exists   := TRUE;
            END LOOP; --*/--edgar 09/08/2014 
            
            /*IF v_dflt_policy_exists = FALSE THEN
                insert_dflt_values;
            END IF;*/--commented out edgar 09/09/2014
             /*added edgar 09/08/2014*/
              v_dist_spct1_chk := FALSE;--edgar 09/12/2014
              FOR i IN (SELECT '1' /*checks for records having dist_spct1 to insert correct dist_spct1*/
                          FROM giuw_witemperilds_dtl
                         WHERE dist_no = p_dist_no
                           AND dist_spct1 IS NOT NULL)
              LOOP
                  v_dist_spct1_chk := TRUE;
                  EXIT;
              END LOOP;              
            
              IF NOT v_dflt_policy_exists
              THEN
                 insert_dflt_values;
              END IF;
           /*ended edgar 09/08/2014*/            
        ELSIF v_par_type = 'E' THEN
          v_dflt_policy_exists := FALSE;   --edgar 09/08/2014
          /*uncommented out by edgar 09/08/2014*/                
            FOR c IN ( SELECT dist_no, share_cd, dist_spct, dist_spct1  -- commented out retrieving of default share from original policy for now : shan 08.06.2014
                         FROM giuw_itemperilds_dtl a
                        WHERE 1 = 1
                          AND a.dist_seq_no = p_dist_seq_no
                          AND a.item_no = p_item_no
                          AND a.peril_cd = p_peril_cd
                          AND dist_no = ( SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE par_id = ( SELECT par_id
                                                              FROM GIPI_POLBASIC
                                                             WHERE endt_seq_no = 0
                                                               AND (line_cd,         subline_cd, 
                                                                    iss_cd,         issue_yy, 
                                                                    pol_seq_no,    renew_no) = (SELECT line_cd,         subline_cd, 
                                                                                                       iss_cd,         issue_yy, 
                                                                                                       pol_seq_no, renew_no
                                                                                                  FROM GIPI_POLBASIC
                                                                                                 WHERE policy_id = v_policy_id))))
            LOOP
                 v_share_cd         := c.share_cd;
                 v_dist_spct        := c.dist_spct;
                 v_dist_spct1       := c.dist_spct1;
                 v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                 v_dist_prem        := ROUND(((p_dist_prem    * NVL(c.dist_spct1, c.dist_spct))/ 100), 2);
                 v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                 v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                 v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                 v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);		       
		         INSERT_TO_WITEMPERILDS_DTL;
                 v_dflt_policy_exists   := TRUE;
            END LOOP; --*/--edgar 09/08/2014 
            
            /*IF v_dflt_policy_exists = FALSE THEN
                insert_dflt_values;
            END IF;*/--commented out edgar 09/09/2014
              /*added edgar 09/08/2014*/
              IF NOT v_dflt_policy_exists
              THEN
                 insert_dflt_values;
              END IF;
           /*ended edgar 09/08/2014*/            
        ELSE
            insert_dflt_values;
        END IF; 
    END;
    
    PROCEDURE CRT_GRP_DFLT_WPERILDS_GW18
         (p_dist_no			IN giuw_wperilds_dtl.dist_no%TYPE      ,
          p_dist_seq_no		IN giuw_wperilds_dtl.dist_seq_no%TYPE  ,
          p_line_cd			IN giuw_wperilds_dtl.line_cd%TYPE      ,
          p_peril_cd		IN giuw_wperilds_dtl.peril_cd%TYPE     ,
          p_dist_tsi		IN giuw_wperilds_dtl.dist_tsi%TYPE     ,
          p_dist_prem		IN giuw_wperilds_dtl.dist_prem%TYPE    ,
          p_ann_dist_tsi	IN giuw_wperilds_dtl.ann_dist_tsi%TYPE ,
          p_rg_count		IN NUMBER,
		  p_v_default_no	IN giis_default_dist.default_no%TYPE)
    IS
          v_row					NUMBER;
          v_dist_spct			giuw_wperilds_dtl.dist_spct%TYPE;
          v_dist_tsi			giuw_wperilds_dtl.dist_tsi%TYPE;
          v_dist_prem			giuw_wperilds_dtl.dist_prem%TYPE;
          v_ann_dist_tsi		giuw_wperilds_dtl.ann_dist_tsi%TYPE;
          v_share_cd			giis_dist_share.share_cd%TYPE;
          v_sum_dist_tsi		giuw_wperilds_dtl.dist_tsi%TYPE     := 0;
          v_sum_dist_spct		giuw_wperilds_dtl.dist_spct%TYPE    := 0;
          v_sum_dist_prem		giuw_wperilds_dtl.dist_prem%TYPE    := 0;
          v_sum_ann_dist_tsi		giuw_wperilds_dtl.ann_dist_tsi%TYPE := 0;
          v_pol_flag               GIPI_POLBASIC_POL_DIST_V1.POL_FLAG%type; 
          v_par_type               GIPI_POLBASIC_POL_DIST_V1.PAR_TYPE%type; 
          v_policy_id              GIPI_POLBASIC_POL_DIST_V1.POLICY_ID%type;
          v_dflt_policy_exists     BOOLEAN := FALSE;    
          v_dist_spct1          giuw_wperilds_dtl.DIST_SPCT1%type;
          v_par_id              gipi_polbasic_pol_dist_v1.PAR_ID%type;
          v_dist_seq_no          giuw_wpolicyds_dtl.dist_seq_no%TYPE; --edgar 09/08/2014    
          v_dist_spct1_chk      BOOLEAN := FALSE;--edgar 09/12/2014      
          
          PROCEDURE INSERT_TO_WPERILDS_DTL IS
          BEGIN
                IF v_dist_spct1_chk THEN/*added edgar 09/12/2014*/
                    v_dist_spct1 := v_dist_spct;
                END IF;/*ended edgar 09/12/2014*/                
               INSERT INTO  giuw_wperilds_dtl
                        (dist_no     , dist_seq_no   , line_cd        ,
                         share_cd    , dist_spct     , dist_tsi       ,
                         dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                         dist_grp    , peril_cd,
                         dist_spct1)
                 VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                         v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                         v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                         1           , p_peril_cd,
                         v_dist_spct1);
          END;
        
        PROCEDURE insert_dflt_values
        IS
        BEGIN
            IF p_rg_count = 0 THEN

                 /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_dist_tsi;
                 v_dist_prem    := p_dist_prem;
                 v_ann_dist_tsi := p_ann_dist_tsi;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WPERILDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;

            ELSE

                 --rg_id             := FIND_GROUP(rg_name); 
                 --v_selection_count := GET_GROUP_SELECTION_COUNT(rg_id); 

                 FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                  a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                  1 true_pct 
                             FROM giis_default_dist_group a  
                            WHERE a.default_no = TO_CHAR(NVL(p_v_default_no, 0))
                              AND a.line_cd    = p_line_cd
                              AND a.share_cd   <> 999
                            ORDER BY a.sequence ASC)
                 LOOP
                   --v_row           := GET_GROUP_SELECTION(rg_id, c); --Retrieves the sequence number of the selected row for the given group. 
                   --v_dist_spct     := GET_GROUP_NUMBER_CELL(rg_col7, v_row);
            	   
                   v_row         := c.rownum;
                   --v_dist_spct   := c.true_pct;
                     v_dist_spct   := c.share_pct; -- andrew - 09.24.2012 - replaced true_pct by share_pct; 
                   
                   IF v_dist_spct IS NULL THEN         
                         FOR h IN (SELECT dist_spct
                                     FROM giuw_wpolicyds_dtl
                                    WHERE line_cd = c.line_cd
                                      AND share_cd = c.share_cd
                                      AND dist_no = p_dist_no)
                         LOOP
                            v_dist_spct := h.dist_spct;
                            EXIT;
                         END LOOP; 
                   END IF;
                   
                   v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
                   IF v_sum_dist_spct != 100 THEN
                      v_dist_tsi         := ROUND(p_dist_tsi         * v_dist_spct / 100, 2);
                      v_dist_prem        := ROUND(p_dist_prem        * v_dist_spct / 100, 2);
                      v_ann_dist_tsi     := ROUND(p_ann_dist_tsi     * v_dist_spct / 100, 2);
                      v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                      v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                      v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
                   ELSE
                      v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                      v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                      v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                   END IF;
                   --v_share_cd     := GET_GROUP_NUMBER_CELL(rg_col2, v_row);
                   v_share_cd := c.share_cd;
                   INSERT_TO_WPERILDS_DTL;
                 END LOOP;

                 IF v_sum_dist_spct != 100 THEN
                   v_dist_spct    := 100            - v_sum_dist_spct;
                   v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
                   v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
                   v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
                   v_share_cd     := '999';
                   --p_rg_count     := p_rg_count + 1;
                   INSERT_TO_WPERILDS_DTL;
                 END IF;
            END IF;  
        END;
        
    BEGIN
        FOR i IN (SELECT *
                    FROM GIPI_POLBASIC_POL_DIST_V1 
                   WHERE policy_id = (SELECT policy_id
                                        FROM giuw_pol_dist
                                       WHERE dist_no = p_dist_no))
        LOOP
            v_pol_flag  := i.pol_flag;
            v_par_type  := i.par_type;
            v_policy_id := i.policy_id;
            v_par_id    := i.par_id;
            EXIT;
        END LOOP;
        
        IF v_pol_flag = '2' THEN
              v_dflt_policy_exists := FALSE;                       --edgar 09/08/2014
             v_dist_spct1_chk := FALSE;--edgar 09/12/2014
              /*uncommented out by edgar 09/08/2014*/            
            FOR c IN ( SELECT share_cd, dist_spct, dist_spct1 -- commented out retrieving of default share from original policy for now : shan 08.06.2014
		                 FROM giuw_perilds_dtl a
                        WHERE a.dist_seq_no = p_dist_seq_no
                          --AND a.peril_cd = p_peril_cd --edgar 09/12/2014
                          AND dist_no = ( SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE policy_id = ( SELECT MAX(old_policy_id) --edgar 09/17/21014
                                                                 FROM GIPI_POLNREP
                                                                WHERE par_id = v_par_id
                                                                  AND ren_rep_sw = '1'/*added edgar 09/12/2014*/
                                                                  AND new_policy_id = (SELECT policy_id
                                                                                         FROM gipi_polbasic
                                                                                        WHERE pol_flag <> '5'
                                                                                          AND policy_id = v_policy_id)))
                     GROUP BY share_cd, dist_spct, dist_spct1)/*ended edgar 09/12/2014*/
		    LOOP     	
		       v_dist_spct1_chk := FALSE;--edgar 09/12/2014
		       v_share_cd     := c.share_cd;
		       v_dist_spct    := c.dist_spct;
               v_dist_spct1     := c.dist_spct1;
		       v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
		       v_dist_prem        := ROUND(((p_dist_prem    * NVL(c.dist_spct1, c.dist_spct))/ 100), 2);
		       v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
		       v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
		       v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
		       v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
		       INSERT_TO_WPERILDS_DTL;
			   v_dflt_policy_exists   := TRUE;
            END LOOP;--*/--edgar 09/08/2014
            
            /*IF v_dflt_policy_exists = FALSE THEN
                insert_dflt_values;
            END IF;*/--commented out edgar 09/09/2014
               /*added edgar 09/08/2014*/
             v_dist_spct1_chk := FALSE;--edgar 09/12/2014
              FOR i IN (SELECT '1' /*checks for records having dist_spct1 to insert correct dist_spct1*/
                          FROM giuw_wpolicyds_dtl
                         WHERE dist_no = p_dist_no
                           AND dist_spct1 IS NOT NULL)
              LOOP
                 v_dist_spct1_chk := TRUE;
                 EXIT;
              END LOOP;
                           
              IF NOT v_dflt_policy_exists
              THEN
                 insert_dflt_values;
              END IF;
           /*ended edgar 09/08/2014*/            
        ELSIF v_par_type = 'E' THEN
              v_dflt_policy_exists := FALSE;  --edgar 09/08/2014
              /*uncommented out by edgar 09/08/2014*/                 
            FOR c IN ( SELECT dist_no, share_cd, dist_spct, dist_spct1 -- commented out retrieving of default share from original policy for now : shan 08.06.2014
                         FROM giuw_perilds_dtl a
                        WHERE 1 = 1
                          AND a.dist_seq_no = p_dist_seq_no
                          AND a.peril_cd = p_peril_cd
                          AND dist_no = ( SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE par_id = ( SELECT par_id
                                                              FROM GIPI_POLBASIC
                                                             WHERE endt_seq_no = 0
                                                               AND (line_cd,         subline_cd, 
                                                                    iss_cd,         issue_yy, 
                                                                    pol_seq_no,    renew_no) = (SELECT line_cd,         subline_cd, 
                                                                                                       iss_cd,         issue_yy, 
                                                                                                       pol_seq_no, renew_no
                                                                                                  FROM GIPI_POLBASIC
                                                                                                 WHERE policy_id = v_policy_id))))
            LOOP
                 v_share_cd         := c.share_cd;
                 v_dist_spct        := c.dist_spct;
                 v_dist_spct1       := c.dist_spct1;
                 v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                 v_dist_prem        := ROUND(((p_dist_prem    * NVL(c.dist_spct1, c.dist_spct))/ 100), 2);
                 v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                 v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                 v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                 v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);		       
		         INSERT_TO_WPERILDS_DTL;
                 v_dflt_policy_exists   := TRUE;
            END LOOP; --*/--edgar 09/08/2014
            
            /*IF v_dflt_policy_exists = FALSE THEN
                insert_dflt_values;
            END IF;*/--commented out edgar 09/09/2014
              /*added edgar 09/08/2014*/
              IF NOT v_dflt_policy_exists
              THEN
                 insert_dflt_values;
              END IF;
           /*ended edgar 09/08/2014*/            
        ELSE
            insert_dflt_values;
        END IF; 
    END;
    /********** end 07.29.2014 **********/
    --added by steven 08.06.2014
    PROCEDURE check_peril_dist_per_share (
      p_dist_no     IN       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no IN       VARCHAR2,
      p_share_cd    IN       VARCHAR2,
      p_peril_cd    IN       giis_peril.peril_cd%TYPE
   )
   IS
      v_dist_no     giuw_pol_dist.dist_no%TYPE;
      v_exist       VARCHAR2 (1)                 := 'N';
      v_peril1      VARCHAR2 (50);
      v_peril2      VARCHAR2 (50);
      v_perils      VARCHAR2 (200);
      v_trty_type   VARCHAR2 (10);
      v_trty_name   VARCHAR2 (50);
      v_count       NUMBER                       := 0;
      v_msg_alert   VARCHAR2 (2000);
   BEGIN
      v_dist_no := p_dist_no;

      /* Checks for shares with a zero DIST_TSI
      ** from every item of the GIUW_WITEMDS_DTL table. */
      FOR c1 IN (SELECT dist_seq_no, item_no, line_cd, share_cd
                   FROM giuw_witemds_dtl
                  WHERE dist_tsi = 0
                    AND dist_no = v_dist_no
                    AND dist_seq_no = p_dist_seq_no
                    AND share_cd = p_share_cd)
      LOOP
         /* The share with a zero DIST_TSI from the WITEMDS_DTL
         ** table will only be valid if a basic peril with a zero
         ** DIST_TSI of the same item was found to have been
         ** distributed with the said share. */
         FOR c2 IN (SELECT 'A'
                      FROM giuw_witemperilds_dtl a, giis_peril b
                     WHERE a.peril_cd = b.peril_cd
                       AND a.line_cd = b.line_cd
                       AND b.peril_type = 'B'
                       AND a.dist_tsi = 0
                       AND a.share_cd = c1.share_cd
                       AND a.line_cd = c1.line_cd
                       AND a.item_no = c1.item_no
                       AND a.dist_seq_no = c1.dist_seq_no
                       AND a.dist_no = v_dist_no)
         LOOP
            v_exist := 'Y';
            EXIT;
         END LOOP;

         /* If a basic peril with a zero DIST_TSI was not found
         ** to have been distributed with the said share, then it
         ** is understood that the zero DIST_TSI in the WITEMDS_DTL
         ** table was caused by an allied peril which was distributed
         ** wrongfully.  Thus, the next procedure selects for the name
         ** of the allied perils that caused the error prior to displaying
         ** the error message on the screen notifying the user that the
         ** said perils were distributed illegally. */
         IF v_exist = 'N'
         THEN
            FOR c3 IN (SELECT b.peril_name, c.trty_name,
                              DECODE (c.share_type,
                                      '2', 'treaty',
                                      'share'
                                     ) TYPE,
                               a.peril_cd
                         FROM giuw_witemperilds_dtl a,
                              giis_peril b,
                              giis_dist_share c
                        WHERE c.share_cd = a.share_cd
                          AND c.line_cd = a.line_cd
                          AND a.peril_cd = b.peril_cd
                          AND a.line_cd = b.line_cd
                          AND b.peril_type = 'A'
                          AND a.share_cd = c1.share_cd
                          AND a.line_cd = c1.line_cd
                          AND a.item_no = c1.item_no
                          AND a.dist_seq_no = c1.dist_seq_no
                          AND a.dist_no = v_dist_no)
            LOOP
               v_count := v_count + 1;
               v_trty_name := c3.trty_name;
               v_trty_type := c3.TYPE;

               IF v_count = 1
               THEN
                  v_peril1 := c3.peril_name;
                  v_perils := v_peril1;
               ELSIF v_count = 2
               THEN
                  v_peril2 := c3.peril_name;
                  v_perils := v_peril1 || ' and ' || v_peril2;
               ELSIF v_count = 3
               THEN
                  v_perils :=
                     v_peril1 || ', ' || v_peril2 || ', and '
                     || c3.peril_name;
                  v_msg_alert :=
                        'At least 3 of the allied perils: '
                     || v_perils
                     || ' were illegally distributed.  The '
                     || v_trty_name
                     || ' '
                     || v_trty_type
                     || ' cannot be a part of the said '
                     || ' perils'' distribution shares.';
               END IF;
            END LOOP;

            IF v_count = 1
            THEN
               v_msg_alert :=
                     'Allied peril '
                  || v_perils
                  || ' was illegally distributed. '
                  || 'The '
                  || v_trty_name
                  || ' '
                  || v_trty_type
                  || ' cannot be a '
                  || 'part of the said peril''s distribution shares.';
            ELSIF v_count = 2
            THEN
               v_msg_alert :=
                     'Allied perils: '
                  || v_perils
                  || ' were illegally distributed. '
                  || 'The '
                  || v_trty_name
                  || ' '
                  || v_trty_type
                  || ' cannot be a '
                  || 'part of the said perils'' distribution shares.';
            END IF;
         
            IF v_msg_alert IS NOT NULL THEN
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#'||v_msg_alert);
            END IF;
         END IF;
      END LOOP;
   END;
    
    PROCEDURE check_posted_binder (
      p_policy_id       IN  giuw_pol_dist.par_id%TYPE,
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_alert          OUT  VARCHAR2 
    )
    IS
    /*Created by    : edgar
    **Date created  : 09/11/2014
    **Description   : checks for posted binders. disallow modification of setup of dist if there are any.
    */
    BEGIN
       FOR binder_exist IN (SELECT 1
                              FROM giri_frps_ri a,
                                   giri_binder b,
                                   giri_distfrps c,
                                   giuw_pol_dist d
                             WHERE 1 = 1
                               AND a.fnl_binder_id = b.fnl_binder_id
                               AND a.line_cd = c.line_cd
                               AND a.frps_yy = c.frps_yy
                               AND a.frps_seq_no = c.frps_seq_no
                               AND c.dist_no = d.dist_no
                               AND d.policy_id = p_policy_id
                               AND d.dist_no = p_dist_no)
       LOOP
            p_alert := 'You can no longer alter the distribution of a record with posted binder.';
          EXIT;
       END LOOP;
    END check_posted_binder; 

    /* ===================================================================================================================
    **  Created   by Jhing 11.25.2014 
    **  Purpose: To populate giuw_witemperilds_dtl, giuw_wperilds_dtl and giuw_witemds_dtl after default distribution has
    **           been created from default distribution program flow/logic for ONE RISK.Instead of reusing existing procedure  
    **           from other packages, created a new one since in setup dist, we will now ensure dist_spct1 has value. 
    ** ==================================================================================================================*/ 
       
    PROCEDURE populate_oth_tbls_one_risk (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE 
    )
    IS
      v_dist_no         giuw_pol_dist.dist_no%TYPE;
      v_dist_tsi        giuw_witemds_dtl.dist_tsi%TYPE;
      v_dist_prem       giuw_witemds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi    giuw_witemds_dtl.ann_dist_tsi%TYPE;
      v_dist_tsi1       giuw_witemperilds_dtl.dist_tsi%TYPE;
      v_dist_prem1      giuw_witemperilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi1   giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
      v_dist_tsi2       giuw_wperilds_dtl.dist_tsi%TYPE;
      v_dist_prem2      giuw_wperilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi2   giuw_wperilds_dtl.ann_dist_tsi%TYPE;    
    BEGIN
      v_dist_no := p_dist_no;

      /* Delete tables in preparation
      ** for data insertion. */
      DELETE      giuw_wperilds_dtl
            WHERE dist_no = v_dist_no;

      DELETE      giuw_witemperilds_dtl
            WHERE dist_no = v_dist_no;

      DELETE      giuw_witemds_dtl
            WHERE dist_no = v_dist_no;

      /* Get the distribution share percentage for each record
      ** in table GIUW_WPOLICYDS_DTL. */
      FOR c1 IN (SELECT dist_seq_no, line_cd, share_cd, dist_spct,
                        ann_dist_spct, dist_grp,
                        dist_spct1                --Added by tonio 06/08/2011
                   FROM giuw_wpolicyds_dtl
                  WHERE dist_no = v_dist_no)
      LOOP
         /* Get the amounts from table GIUW_WITEMDS and multiply
         ** it to the share percentage driven from table
         ** GIUW_WPOLICYDS_DTL to arrive at the correct breakdown
         ** of the amounts for table GIUW_WITEMDS_DTL. */
         FOR c2 IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, item_no
                      FROM giuw_witemds
                     WHERE dist_seq_no = c1.dist_seq_no
                       AND dist_no = v_dist_no)
         LOOP
            v_dist_tsi := ROUND (c1.dist_spct / 100 * c2.tsi_amt, 2);
            v_dist_prem := ROUND (NVL(c1.dist_spct1 , c1.dist_spct)/ 100 * c2.prem_amt, 2);
            v_ann_dist_tsi :=
                           ROUND (c1.ann_dist_spct / 100 * c2.ann_tsi_amt, 2);

            INSERT INTO giuw_witemds_dtl
                        (dist_no, dist_seq_no, item_no, line_cd,
                         share_cd, dist_spct, dist_spct1,
                         dist_tsi, dist_prem, ann_dist_spct,
                         ann_dist_tsi, dist_grp
                        )
                 VALUES (v_dist_no, c1.dist_seq_no, c2.item_no, c1.line_cd,
                         c1.share_cd, c1.dist_spct, c1.dist_spct1,
                         v_dist_tsi, v_dist_prem, c1.ann_dist_spct,
                         v_ann_dist_tsi, c1.dist_grp
                        );
         END LOOP;

         /* Get the amounts from table GIUW_WITEMPERILDS and multiply
         ** it to the share percentage driven from table
         ** GIUW_WPOLICYDS_DTL to arrive at the correct breakdown
         ** of the amounts for table GIUW_WITEMPERILDS_DTL. */
         FOR c3 IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, item_no, line_cd,
                           peril_cd
                      FROM giuw_witemperilds
                     WHERE line_cd = c1.line_cd
                       AND dist_seq_no = c1.dist_seq_no
                       AND dist_no = v_dist_no)
         LOOP
            v_dist_tsi1 := ROUND (c1.dist_spct / 100 * c3.tsi_amt, 2);
            v_dist_prem1 := ROUND (NVL(c1.dist_spct1, c1.dist_spct) / 100 * c3.prem_amt, 2);
            v_ann_dist_tsi1 :=
                           ROUND (c1.ann_dist_spct / 100 * c3.ann_tsi_amt, 2);

            INSERT INTO giuw_witemperilds_dtl
                        (dist_no, dist_seq_no, item_no, line_cd,
                         share_cd, dist_spct, dist_spct1,
                         dist_tsi, dist_prem, ann_dist_spct,
                         ann_dist_tsi, dist_grp, peril_cd
                        )
                 VALUES (v_dist_no, c1.dist_seq_no, c3.item_no, c3.line_cd,
                         c1.share_cd, c1.dist_spct, c1.dist_spct1,
                         v_dist_tsi1, v_dist_prem1, c1.ann_dist_spct,
                         v_ann_dist_tsi1, c1.dist_grp, c3.peril_cd
                        );
         END LOOP;

         /* Get the amounts from table GIUW_WPERILDS and multiply
         ** it to the share percentage driven from table
         ** GIUW_WPOLICYDS_DTL to arrive at the correct breakdown
         ** of the amounts for table GIUW_WPERILDS_DTL. */
         FOR c4 IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, line_cd, peril_cd
                      FROM giuw_wperilds
                     WHERE line_cd = c1.line_cd
                       AND dist_seq_no = c1.dist_seq_no
                       AND dist_no = v_dist_no)
         LOOP
            v_dist_tsi2 := ROUND (c1.dist_spct / 100 * c4.tsi_amt, 2);
            v_dist_prem2 := ROUND (NVL(c1.dist_spct1,c1.dist_spct) / 100 * c4.prem_amt, 2); 
            v_ann_dist_tsi2 :=
                           ROUND (c1.ann_dist_spct / 100 * c4.ann_tsi_amt, 2);

            INSERT INTO giuw_wperilds_dtl
                        (dist_no, dist_seq_no, peril_cd, line_cd,
                         share_cd, dist_spct, dist_spct1,
                         dist_tsi, dist_prem, ann_dist_spct,
                         ann_dist_tsi, dist_grp
                        )
                 VALUES (v_dist_no, c1.dist_seq_no, c4.peril_cd, c1.line_cd,
                         c1.share_cd, c1.dist_spct, c1.dist_spct1,
                         v_dist_tsi2, v_dist_prem2, c1.ann_dist_spct,
                         v_ann_dist_tsi2, c1.dist_grp
                        );
         END LOOP;
      END LOOP;    
    
    END populate_oth_tbls_one_risk;  
    
    /* ===================================================================================================================
    **  Created   by Jhing 11.25.2014 
    **  Purpose: To populate giuw_witemperilds_dtl, giuw_wpolicyds_dtl and giuw_witemds_dtl after default distribution has
    **           been created from default distribution program flow/logic for PERIL DIST. Instead of reusing existing procedure  
    **           from other packages, created a new one since in setup dist, we will now ensure dist_spct1 has value. 
    ** ==================================================================================================================*/     
    PROCEDURE populate_oth_tbls_peril_dist (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE 
    )
    IS
        v_dist_tsi giuw_wpolicyds_dtl.dist_tsi%TYPE;
        v_dist_prem giuw_wpolicyds_dtl.dist_prem%TYPE;
        v_ann_dist_tsi  giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
        v_ann_dist_spct giuw_wpolicyds_dtl.ann_dist_spct%TYPE;
        v_dist_spct     giuw_wpolicyds_dtl.dist_spct%TYPE;
        v_dist_spct1    giuw_wpolicyds_dtl.dist_spct1%TYPE;
        v_spct1_exists  VARCHAR2(1);
    BEGIN
    
    /** =====================================================================================================================   **
    **         POPULATE THE GIUW_WITEMPERILDS_DTL BASED FROM GIUW_WPERILDS_DTL                                                  **
    **  =====================================================================================================================   */
      DELETE giuw_witemperilds_dtl 
       WHERE dist_no = p_dist_no;
       
       
      FOR c1 IN (SELECT dist_spct , ann_dist_spct , dist_grp    ,
                        share_cd  , line_cd       , dist_seq_no ,
                        peril_cd  , dist_spct1
                   FROM giuw_wperilds_dtl
                  WHERE dist_no = p_dist_no)
      LOOP
        FOR c2 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt ,
                          dist_no , dist_seq_no , item_no     ,
                          line_cd , peril_cd
                     FROM giuw_witemperilds
                    WHERE peril_cd    = c1.peril_cd
                      AND line_cd     = c1.line_cd
                      AND dist_seq_no = c1.dist_seq_no
                      AND dist_no     = p_dist_no)
        LOOP

          /* Multiply the percentage values of table GIUW_WPERILDS_DTL
          ** with the values of columns belonging to table GIUW_WITEMPERILDS,
          ** to arrive at the correct break down of values in table
          ** GIUW_WITEMPERILDS_DTL. */
          IF c2.tsi_amt = 0 THEN
             v_dist_tsi := 0;
          ELSE   
             v_dist_tsi     := ROUND(c1.dist_spct/100     * c2.tsi_amt, 2);
          END IF;
          IF c2.prem_amt = 0 THEN
             v_dist_prem := 0;
          ELSE   
             v_dist_prem    := ROUND(NVL(c1.dist_spct1, c1.dist_spct)/100     * c2.prem_amt, 2);
          END IF;   
          IF c2.ann_tsi_amt = 0 THEN
             v_ann_dist_tsi := 0;
          ELSE   	
             v_ann_dist_tsi := ROUND(c1.ann_dist_spct/100 * c2.ann_tsi_amt, 2);
          END IF;   

          INSERT INTO  giuw_witemperilds_dtl
                      (dist_no          , dist_seq_no    , item_no          ,
                       line_cd          , peril_cd       , share_cd         ,
                       dist_spct        , dist_tsi       , dist_prem        ,
                       ann_dist_spct    , ann_dist_tsi   , dist_grp         ,
                       dist_spct1)
               VALUES (c2.dist_no       , c2.dist_seq_no , c2.item_no       ,
                       c2.line_cd       , c2.peril_cd    , c1.share_cd      ,
                       c1.dist_spct     , v_dist_tsi     , v_dist_prem      ,
                       c1.ann_dist_spct , v_ann_dist_tsi , c1.dist_grp      ,
                       c1.dist_spct1);
        END LOOP;
      END LOOP;

   /** =====================================================================================================================   **
    **         POPULATE THE GIUW_WITEMDS_DTL BASED FROM GIUW_WITEMPERILDS_DTL                                                  **
    **  =====================================================================================================================   */
    
      DELETE giuw_witemds_dtl 
      WHERE dist_no = p_dist_no;
     
      FOR c1 IN (  SELECT dist_seq_no dist_seq_no  ,
                          line_cd     line_cd      ,
                          item_no     item_no      ,
                          share_cd    share_cd     ,
                          dist_grp    dist_grp
                     FROM giuw_witemperilds_dtl
                    WHERE dist_no = p_dist_no
                 GROUP BY dist_seq_no, item_no, line_cd, share_cd, dist_grp)
      LOOP
        FOR c2 IN (  SELECT SUM(DECODE(A170.peril_type, 'B', 
                                       a.dist_tsi, 0))        dist_tsi     ,
                            SUM(a.dist_prem)                  dist_prem    ,
                            SUM(DECODE(A170.peril_type, 'B',
                                       a.ann_dist_tsi, 0))    ann_dist_tsi
                       FROM giuw_witemperilds_dtl a, giis_peril A170
                      WHERE A170.peril_cd   = a.peril_cd
                        AND A170.line_cd    = a.line_cd
                        AND a.dist_grp      = c1.dist_grp
                        AND a.share_cd      = c1.share_cd
                        AND a.line_cd       = c1.line_cd
                        AND a.item_no       = c1.item_no
                        AND a.dist_seq_no   = c1.dist_seq_no                    
                        AND a.dist_no       = p_dist_no)
        LOOP
      
          FOR c3 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt ,
                            dist_no , dist_seq_no , item_no
                       FROM giuw_witemds
                      WHERE item_no     = c1.item_no
                        AND dist_seq_no = c1.dist_seq_no
                        AND dist_no     = p_dist_no)
          LOOP

            /* Divide the individual TSI/Premium with the total TSI/Premium
            ** and multiply it by 100 to arrive at the correct percentage for
            ** the breakdown. */
           
            IF c3.tsi_amt = 0 AND c3.prem_amt <> 0 THEN
               v_dist_spct := ROUND (((c2.dist_prem / c3.prem_amt) * 100), 9);
            ELSIF c3.tsi_amt = 0 AND /*c3.prem_amt <> 0*/ c3.prem_amt = 0 THEN --modified edgar 02/06/2015
               v_dist_spct  := 0 ; 
            ELSE	 
               v_dist_spct    := ROUND(((c2.dist_tsi/c3.tsi_amt) * 100),9) ;   
            END IF; 
              
            IF  c3.tsi_amt <> 0 AND c3.prem_amt = 0 THEN 
                 v_dist_spct1   := ROUND (((c2.dist_tsi / c3.tsi_amt) * 100), 9);
            ELSIF c3.prem_amt = 0 AND c3.tsi_amt = 0  THEN
                 v_dist_spct1   := 0;
            ELSE	 
               v_dist_spct1   := ROUND(((c2.dist_prem/c3.prem_amt) * 100),9);   
            END IF; 
              
            IF c3.ann_tsi_amt = 0 THEN
                 v_ann_dist_spct := 0;
            ELSE	 
               v_ann_dist_spct := ROUND(((c2.ann_dist_tsi/c3.ann_tsi_amt) * 100),9) ;   
            END IF;  
            
            INSERT INTO  giuw_witemds_dtl
                        (dist_no         , dist_seq_no    , item_no          ,
                         line_cd         , share_cd       , dist_spct        ,
                         dist_tsi        , dist_prem      , ann_dist_spct    ,
                         ann_dist_tsi    , dist_grp       , dist_spct1)  
                 VALUES (c3.dist_no      , c3.dist_seq_no , c3.item_no       , 
                         c1.line_cd      , c1.share_cd    , v_dist_spct      ,
                         c2.dist_tsi     , c2.dist_prem   , v_ann_dist_spct  ,
                         c2.ann_dist_tsi , c1.dist_grp    , v_dist_spct1);  
          END LOOP;
          EXIT;
        END LOOP;
      END LOOP;


   /** =====================================================================================================================   **
    **         POPULATE THE GIUW_WPOLICYDS_DTL BASED FROM GIUW_WITEMS_DTL                                                  **
    **  =====================================================================================================================   */
      DELETE      giuw_wpolicyds_dtl
            WHERE dist_no = p_dist_no;

      FOR c1 IN (SELECT   SUM (dist_tsi) dist_tsi, SUM (dist_prem) dist_prem,
                          SUM (ann_dist_tsi) ann_dist_tsi,
                          dist_seq_no dist_seq_no, line_cd line_cd,
                          share_cd share_cd, dist_grp dist_grp
                     FROM giuw_witemds_dtl
                    WHERE dist_no = p_dist_no
                 GROUP BY dist_seq_no, line_cd, share_cd, dist_grp)
      LOOP
         FOR c2 IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, dist_no,
                           dist_seq_no
                      FROM giuw_wpolicyds
                     WHERE dist_seq_no = c1.dist_seq_no
                       AND dist_no = p_dist_no)
         LOOP
            /* Divide the individual TSI with the total TSI and multiply
            ** it by 100 to arrive at the correct percentage for the
            ** breakdown. */
            IF c2.tsi_amt = 0 AND c2.prem_amt <> 0 THEN
               v_dist_spct := ROUND (((c1.dist_prem / c2.prem_amt) * 100), 9);
            ELSIF c2.tsi_amt = 0 AND /*c2.prem_amt <> 0*/ c2.prem_amt = 0 THEN --modified edgar 02/06/2015
               v_dist_spct  := 0 ; 
            ELSE	 
               v_dist_spct    := ROUND(((c1.dist_tsi/c2.tsi_amt) * 100),9) ;   
            END IF; 
              
            IF  c2.tsi_amt <> 0 AND c2.prem_amt = 0 THEN 
                 v_dist_spct1   := ROUND (((c1.dist_tsi / c2.tsi_amt) * 100), 9);
            ELSIF c2.prem_amt = 0 AND c2.tsi_amt = 0  THEN
                 v_dist_spct1   := 0;
            ELSE	 
               v_dist_spct1   := ROUND(((c1.dist_prem/c2.prem_amt) * 100),9);   
            END IF; 
              
            IF c2.ann_tsi_amt = 0 THEN
                 v_ann_dist_spct := 0;
            ELSE	 
               v_ann_dist_spct := ROUND(((c1.ann_dist_tsi/c2.ann_tsi_amt) * 100),9) ;   
            END IF;  

            INSERT INTO giuw_wpolicyds_dtl
                        (dist_no, dist_seq_no, line_cd, share_cd,
                         dist_spct, dist_tsi, dist_prem,
                         ann_dist_spct, ann_dist_tsi, dist_grp,
                         dist_spct1
                        )
                 VALUES (c2.dist_no, c2.dist_seq_no, c1.line_cd, c1.share_cd,
                         v_dist_spct, c1.dist_tsi, c1.dist_prem,
                         v_ann_dist_spct, c1.ann_dist_tsi, c1.dist_grp,
                         v_dist_spct1
                        );
         END LOOP;
      END LOOP;
      
      /*  ==========================================================================
      **    update value of DIST_SPCT1 based from the nature of GIUW_WPERILDS_DTL 
      **  ========================================================================= */
      
      v_spct1_exists := 'N';
      FOR exists1 IN (SELECT 1 
                        FROM giuw_wperilds_dtl
                            WHERE dist_no = p_dist_no
                                AND dist_spct1 IS NOT NULL )
      LOOP
         v_spct1_exists := 'Y';
         EXIT;
      END LOOP;
      
      
      IF v_spct1_exists = 'N' THEN
            UPDATE giuw_witemds_dtl
                SET dist_spct1 = NULL
                    WHERE dist_no = p_dist_no
                        AND dist_spct1 IS NOT NULL;
      
      
             UPDATE giuw_wpolicyds_dtl
                SET dist_spct1 = NULL
                    WHERE dist_no = p_dist_no
                        AND dist_spct1 IS NOT NULL;
      ELSE
            UPDATE giuw_witemds_dtl
                SET dist_spct1 = dist_spct--dist_spct1 --edgar 02/06/2015
                    WHERE dist_no = p_dist_no
                        AND dist_spct1 IS NULL;
      
      
             UPDATE giuw_wpolicyds_dtl
                SET dist_spct1 = dist_spct
                    WHERE dist_no = p_dist_no
                        AND dist_spct1 IS NULL;      
      END IF;
      
     
    END populate_oth_tbls_peril_dist;  
    
        
    PROCEDURE insert_setup_dflt_group_values (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no     IN  giuw_policyds.dist_seq_no%TYPE ,
      p_rg_count        IN  NUMBER ,
      p_default_no      IN  giis_default_dist.default_no%TYPE ,
      p_default_type    IN  giis_default_dist.default_type%TYPE,
      p_line_cd         IN  giis_line.line_cd%TYPE ,
      p_tsi_amt         IN  giuw_policyds.tsi_amt%TYPE,
      p_prem_amt        IN  giuw_policyds.prem_amt%TYPE,
      p_ann_tsi_amt     IN  giuw_policyds.ann_tsi_amt%TYPE,
      p_currency_rt     IN  gipi_item.currency_rt%TYPE
    )  
    IS
      v_share_cd            giis_dist_share.share_cd%TYPE;
      v_dist_spct           giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_dist_spct1          giuw_wpolicyds_dtl.dist_spct1%TYPE  := NULL ; 
      v_ann_dist_spct       giuw_wpolicyds_dtl.ann_dist_spct%TYPE ;
      v_dist_tsi            giuw_wpolicyds_dtl.dist_tsi%TYPE;
      v_dist_prem           giuw_wpolicyds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi        giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
      v_peril_cd            giis_peril.peril_cd%TYPE;
      v_use_share_amt2      VARCHAR2 (1)                              := 'N';
      v_share_amt           giis_default_dist_group.share_amt1%TYPE; 
      v_sum_dist_spct       giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_sum_dist_tsi        giuw_wpolicyds.tsi_amt%TYPE;
      v_sum_dist_prem       giuw_wpolicyds.prem_amt%TYPE;
      v_sum_ann_dist_spct   giuw_wpolicyds_dtl.ann_dist_spct%TYPE;
      v_sum_ann_dist_tsi    giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
      v_dist_spct_limit     giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_remaining_tsi       giuw_wpolicyds.tsi_amt%TYPE ;
      v_currency_rt         gipi_invoice.currency_rt%TYPE;
                      
      PROCEDURE INSERT_TO_WPOLICYDS_DTL IS
      BEGIN
        INSERT INTO  GIUW_WPOLICYDS_DTL
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , dist_spct1)
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , v_dist_spct1);
      END; -- end INSERT_TO_WPOLICYDS_DTL     
    BEGIN
    
        v_currency_rt := NVL( p_currency_rt,1);
        IF p_rg_count = 0 THEN 

             /* Create the default distribution records based on the 100%
             ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
             v_share_cd     := 1;
             v_dist_spct    := 100;
             v_dist_tsi     := p_tsi_amt;
             v_dist_prem    := p_prem_amt;
             v_ann_dist_tsi := p_ann_tsi_amt;
             FOR c IN 1..2
             LOOP
               INSERT_TO_WPOLICYDS_DTL;
               v_share_cd     := 999;
               v_dist_spct    := 0;
               v_dist_tsi     := 0;
               v_dist_prem    := 0;
               v_ann_dist_tsi := 0;
             END LOOP;

          ELSE
             /* Use AMOUNTS to create the default distribution records. */
             IF p_default_type = 1 THEN
             
                v_remaining_tsi := p_tsi_amt * v_currency_rt ;
                v_sum_dist_spct := 0 ;
                v_sum_dist_tsi  := 0 ;
                v_sum_dist_prem := 0 ;
                v_sum_ann_dist_tsi := 0 ;               
               
                FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                 a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                 1 true_pct 
                            FROM GIIS_DEFAULT_DIST_GROUP a  
                           WHERE a.default_no = TO_CHAR(NVL(p_default_no, 0))
                             AND a.line_cd    = p_line_cd
                             AND a.share_cd   <> 999
                           ORDER BY a.sequence ASC)
                LOOP

                 /* v_peril_cd := c.peril_cd;
                  IF v_peril_cd IS NOT NULL THEN
                     IF NVL(v_prev_peril_cd, 0) = v_peril_cd THEN
                        NULL;
                     ELSE
                        v_use_share_amt2 := 'N';
                        FOR c1 IN (  SELECT 'a' 
                                        FROM giuw_wperilds a
                                            WHERE a.dist_no = p_dist_no
                                                AND a.dist_seq_no = v_dist_seq_no
                                                AND a.line_cd= p_line_cd
                                                AND a.peril_cd = v_peril_cd )
                        LOOP
                          v_use_share_amt2 := 'Y';
                          EXIT;
                        END LOOP;
                        v_prev_peril_cd := v_peril_cd;
                     END IF;
                  END IF; */
                  IF v_use_share_amt2 = 'N' THEN
                       v_share_amt  := c.share_amt1;
                  ELSE
                       v_share_amt  := c.share_amt2;
                  END IF;
                  IF v_remaining_tsi >= v_share_amt THEN
                     v_dist_tsi      := v_share_amt / v_currency_rt;
                     v_remaining_tsi := v_remaining_tsi - v_share_amt;
                  ELSE
                     v_remaining_tsi := 0;
                  END IF;
                  IF v_remaining_tsi != 0 THEN
                     v_dist_spct        := ROUND(v_dist_tsi / p_tsi_amt * 100, 9);
                     v_dist_tsi         := ROUND(p_tsi_amt     * v_dist_spct / 100, 2);
                     v_dist_prem        := ROUND(p_prem_amt    * v_dist_spct / 100, 2);
                     v_ann_dist_tsi     := ROUND(p_ann_tsi_amt * v_dist_spct / 100, 2);
                     v_sum_dist_spct    := v_sum_dist_spct    + v_dist_spct;
                     v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                     v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                     v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
                  ELSIF v_remaining_tsi = 0 THEN
                     v_dist_spct    := 100           - v_sum_dist_spct;
                     v_dist_prem    := p_prem_amt    - v_sum_dist_prem;
                     v_ann_dist_tsi := p_ann_tsi_amt - v_sum_ann_dist_tsi;
                     v_dist_tsi     := p_tsi_amt     - v_sum_dist_tsi;
                  END IF;

                  v_share_cd := c.share_cd;          
                  INSERT_TO_WPOLICYDS_DTL;
                  IF v_remaining_tsi = 0 THEN
                     EXIT;
                  END IF;
                END LOOP;
                
                IF v_sum_dist_spct < 100 THEN 
                    IF v_remaining_tsi != 0  THEN
                       v_dist_spct    := 100            - v_sum_dist_spct;
                       v_dist_prem    := p_prem_amt    - v_sum_dist_prem;
                       v_ann_dist_tsi := p_ann_tsi_amt - v_sum_ann_dist_tsi;
                       v_dist_tsi     := p_tsi_amt     - v_sum_dist_tsi;
                       v_share_cd     := '999';
                       INSERT_TO_WPOLICYDS_DTL;
                    END IF;
                
                END IF;

             /* Use PERCENTAGES to create the default distribution records. */
             ELSIF p_default_type = 2 THEN
             
                v_sum_dist_spct := 0 ;
                v_sum_dist_tsi  := 0 ;
                v_sum_dist_prem := 0 ;
                v_sum_ann_dist_tsi := 0 ;
                
                FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                                 a.share_amt1 , a.peril_cd , a.share_amt2 ,
                                 1 true_pct 
                            FROM GIIS_DEFAULT_DIST_GROUP a  
                           WHERE a.default_no = TO_CHAR(NVL(p_default_no, 0))
                             AND a.line_cd    = p_line_cd
                             AND a.share_cd   <> 999
                           ORDER BY a.sequence ASC)
                LOOP
                    v_dist_spct     := c.share_pct;
                    v_share_amt     := c.share_amt1;
                    
                   -- jhing temporary left this condition as fpac-th enh uses limit..this code might be used by the enh though not sure
                   -- since their enh is not yet checked in.
                   -- for now, this condition will not be met as when the maintenance should only have value for one of these columns
                   -- and not both and hence will not affect regular setup distribution.
                   
                  IF v_share_amt IS NOT NULL THEN
                     v_dist_tsi        := v_share_amt / v_currency_rt;
                     v_dist_spct_limit := ROUND(v_dist_tsi / p_tsi_amt * 100, 9);
                     IF v_dist_spct > v_dist_spct_limit THEN 
                        v_dist_spct := v_dist_spct_limit;
                     END IF;
                  END IF;
                  v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
                  IF v_sum_dist_spct != 100 THEN
                     v_dist_tsi         := ROUND(p_tsi_amt     * v_dist_spct / 100, 2);
                     v_dist_prem        := ROUND(p_prem_amt    * v_dist_spct / 100, 2);
                     v_ann_dist_tsi     := ROUND(p_ann_tsi_amt * v_dist_spct / 100, 2);
                     v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                     v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                     v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
                  ELSE
                     v_dist_tsi     := p_tsi_amt     - v_sum_dist_tsi;
                     v_dist_prem    := p_prem_amt    - v_sum_dist_prem;
                     v_ann_dist_tsi := p_ann_tsi_amt - v_sum_ann_dist_tsi;
                  END IF;
                   v_share_cd      := c.share_cd;
                  INSERT_TO_WPOLICYDS_DTL;
                END LOOP;
                IF v_sum_dist_spct != 100 THEN
                   v_dist_spct    := 100            - v_sum_dist_spct;
                   v_dist_tsi     := p_tsi_amt     - v_sum_dist_tsi;
                   v_dist_prem    := p_prem_amt    - v_sum_dist_prem;
                   v_ann_dist_tsi := p_ann_tsi_amt - v_sum_ann_dist_tsi;
                   v_share_cd     := '999';
                   INSERT_TO_WPOLICYDS_DTL;
                END IF;
             ELSE 
                 /* Create the default distribution records based on the 100%
                 ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
                 v_share_cd     := 1;
                 v_dist_spct    := 100;
                 v_dist_tsi     := p_tsi_amt;
                 v_dist_prem    := p_prem_amt;
                 v_ann_dist_tsi := p_ann_tsi_amt;
                 FOR c IN 1..2
                 LOOP
                   INSERT_TO_WPOLICYDS_DTL;
                   v_share_cd     := 999;
                   v_dist_spct    := 0;
                   v_dist_tsi     := 0;
                   v_dist_prem    := 0;
                   v_ann_dist_tsi := 0;
                 END LOOP;          
             END IF;
          END IF;
    
    END insert_setup_dflt_group_values;  
    
    
    PROCEDURE insert_setup_dflt_peril_values (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no     IN  giuw_policyds.dist_seq_no%TYPE ,
      p_rg_count        IN  NUMBER ,
      p_default_no      IN  giis_default_dist.default_no%TYPE ,
      p_default_type    IN  giis_default_dist.default_type%TYPE,
      p_line_cd         IN  giis_line.line_cd%TYPE ,
      p_peril_cd        IN  giis_peril.peril_cd%TYPE,      
      p_tsi_amt         IN  giuw_policyds.tsi_amt%TYPE,
      p_prem_amt        IN  giuw_policyds.prem_amt%TYPE,
      p_ann_tsi_amt     IN  giuw_policyds.ann_tsi_amt%TYPE,
      p_currency_rt     IN  gipi_item.currency_rt%TYPE
    )
    IS
      v_share_cd            giis_dist_share.share_cd%TYPE;
      v_dist_spct           giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_dist_spct1          giuw_wpolicyds_dtl.dist_spct1%TYPE ; 
      v_ann_dist_spct       giuw_wpolicyds_dtl.ann_dist_spct%TYPE ;
      v_dist_tsi            giuw_wpolicyds_dtl.dist_tsi%TYPE;
      v_dist_prem           giuw_wpolicyds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi        giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
      v_peril_cd            giis_peril.peril_cd%TYPE;
      v_use_share_amt2      VARCHAR2 (1)                              := 'N';
      v_share_amt           giis_default_dist_group.share_amt1%TYPE; 
      v_sum_dist_spct       giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_sum_dist_tsi        giuw_wpolicyds.tsi_amt%TYPE;
      v_sum_dist_prem       giuw_wpolicyds.prem_amt%TYPE;
      v_sum_ann_dist_spct   giuw_wpolicyds_dtl.ann_dist_spct%TYPE;
      v_sum_ann_dist_tsi    giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
      v_dist_spct_limit     giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_remaining_tsi       giuw_wpolicyds.tsi_amt%TYPE ;
      v_currency_rt         gipi_invoice.currency_rt%TYPE;

      CURSOR dist_peril_cur
      IS
         SELECT   a.share_cd, a.share_pct, a.share_amt1
             FROM giis_default_dist_peril a
            WHERE a.default_no = p_default_no
              AND a.line_cd = p_line_cd
              AND a.peril_cd = p_peril_cd
              AND a.share_cd <> 999
         ORDER BY a.SEQUENCE ASC;
         
      PROCEDURE insert_to_wperilds_dtl
      IS
      BEGIN
         INSERT INTO giuw_wperilds_dtl
                     (dist_no, dist_seq_no, line_cd, share_cd,
                      dist_spct, dist_tsi, dist_prem, ann_dist_spct,
                      ann_dist_tsi, dist_grp, peril_cd, dist_spct1
                     )
              VALUES (p_dist_no, p_dist_seq_no, p_line_cd, v_share_cd,
                      v_dist_spct, v_dist_tsi, v_dist_prem, v_dist_spct,
                      v_ann_dist_tsi, 1, p_peril_cd, v_dist_spct1
                     );
      END; -- end insert_to_wperilds_dtl     
    BEGIN
       v_currency_rt := NVL( p_currency_rt,1);
       
       IF p_rg_count = 0 THEN 

             /* Create the default distribution records based on the 100%
             ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
             v_share_cd     := 1;
             v_dist_spct    := 100;
             --v_dist_spct1   := v_dist_spct; -- jhing commented out 12.16.2014
             v_dist_tsi     := p_tsi_amt;
             v_dist_prem    := p_prem_amt;
             v_ann_dist_tsi := p_ann_tsi_amt;
             FOR c IN 1..2
             LOOP
                INSERT_TO_WPERILDS_DTL;
                v_share_cd     := 999;
                v_dist_spct    := 0;
                --v_dist_spct1   := v_dist_spct; -- jhing commented out 12.16.2014 
                v_dist_tsi     := 0;
                v_dist_prem    := 0;
                v_ann_dist_tsi := 0;
             END LOOP; 

       ELSE
              /* Use AMOUNTS to create the default distribution records. */
              IF p_default_type = 1 THEN
                 v_remaining_tsi := p_tsi_amt * v_currency_rt ;
                 v_sum_dist_spct := 0 ;
                 v_sum_dist_tsi  := 0 ;
                 v_sum_dist_prem := 0 ;
                 v_sum_ann_dist_tsi := 0 ;    
                 
                 FOR c1 IN dist_peril_cur
                 LOOP
                   IF v_remaining_tsi >= c1.share_amt1 THEN
                      v_dist_tsi      := c1.share_amt1 / p_currency_rt;
                      v_remaining_tsi := v_remaining_tsi - c1.share_amt1;
                   ELSE
                      v_remaining_tsi := 0;
                   END IF;
                   IF v_remaining_tsi != 0 THEN
                      v_dist_spct        := ROUND(v_dist_tsi / p_tsi_amt * 100, 9);
                      --v_dist_spct1       := v_dist_spct;  -- jhing commented out 12.16.2014
                      v_dist_tsi         := ROUND(p_tsi_amt     * v_dist_spct / 100, 2);
                      v_dist_prem        := ROUND(p_prem_amt    * v_dist_spct / 100, 2);
                      v_ann_dist_tsi     := ROUND(p_ann_tsi_amt * v_dist_spct / 100, 2);
                      v_sum_dist_spct    := v_sum_dist_spct    + v_dist_spct;
                      v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                      v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                      v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
                   ELSIF v_remaining_tsi = 0 THEN
                      v_dist_spct    := 100            - v_sum_dist_spct;
                     -- v_dist_spct1   := v_dist_spct;  -- jhing commented out 12.16.2014 
                      v_dist_prem    := p_prem_amt    - v_sum_dist_prem;
                      v_ann_dist_tsi := p_ann_tsi_amt - v_sum_ann_dist_tsi;
                      v_dist_tsi     := p_tsi_amt     - v_sum_dist_tsi;
                   END IF;
                   v_share_cd := c1.share_cd;
                   INSERT_TO_WPERILDS_DTL;
                   IF v_remaining_tsi = 0 THEN
                      EXIT;
                   END IF;
                 END LOOP;
                 
                 IF v_sum_dist_spct < 100 THEN 
                     IF v_remaining_tsi  != 0   THEN
                        v_dist_spct    := 100            - v_sum_dist_spct;
                        --  v_dist_spct1   := v_dist_spct;    -- jhing commented out 12.16.2014 
                        v_dist_prem    := p_prem_amt    - v_sum_dist_prem;
                        v_ann_dist_tsi := p_ann_tsi_amt - v_sum_ann_dist_tsi;
                        v_dist_tsi     := p_tsi_amt     - v_sum_dist_tsi;
                        v_share_cd     := '999';
                        INSERT_TO_WPERILDS_DTL;
                     END IF;                 
                 END IF;

              /* Use PERCENTAGES to create the default distribution records. */
              ELSIF p_default_type = 2 THEN
              
                v_sum_dist_spct := 0 ;
                v_sum_dist_tsi  := 0 ;
                v_sum_dist_prem := 0 ;
                v_sum_ann_dist_tsi := 0 ;    
                
                 FOR c1 IN dist_peril_cur
                 LOOP
                   v_dist_spct := c1.share_pct;
                  -- v_dist_spct1 := v_dist_spct;   -- jhing commented out 12.16.2014 
                   IF c1.share_amt1 IS NOT NULL THEN
                      v_dist_tsi        := c1.share_amt1 / p_currency_rt;
                      v_dist_spct_limit := ROUND(v_dist_tsi / p_tsi_amt * 100, 9);
                      IF v_dist_spct > v_dist_spct_limit THEN 
                         v_dist_spct := v_dist_spct_limit;
                        -- v_dist_spct1 := v_dist_spct;   -- jhing commented out 12.16.2014 
                      END IF;
                   END IF;
                   v_sum_dist_spct := v_sum_dist_spct + v_dist_spct;
                   IF v_sum_dist_spct != 100 THEN
                      v_dist_tsi         := ROUND(p_tsi_amt         * v_dist_spct / 100, 2);
                      v_dist_prem        := ROUND(p_prem_amt        * v_dist_spct / 100, 2);
                      v_ann_dist_tsi     := ROUND(p_ann_tsi_amt     * v_dist_spct / 100, 2);
                      v_sum_dist_tsi     := v_sum_dist_tsi     + v_dist_tsi;
                      v_sum_dist_prem    := v_sum_dist_prem    + v_dist_prem;
                      v_sum_ann_dist_tsi := v_sum_ann_dist_tsi + v_ann_dist_tsi;
                   ELSE
                      v_dist_tsi     := p_tsi_amt     - v_sum_dist_tsi;
                      v_dist_prem    := p_prem_amt    - v_sum_dist_prem;
                      v_ann_dist_tsi := p_ann_tsi_amt - v_sum_ann_dist_tsi;
                   END IF;
                   v_share_cd := c1.share_cd;
                   INSERT_TO_WPERILDS_DTL;
                 END LOOP;
                 IF v_sum_dist_spct  != 100 THEN
                    v_dist_spct    := 100            - v_sum_dist_spct;
                    -- v_dist_spct1   := v_dist_spct;                     -- jhing commented out 12.16.2014 
                    v_dist_tsi     := p_tsi_amt     - v_sum_dist_tsi;
                    v_dist_prem    := p_prem_amt    - v_sum_dist_prem;
                    v_ann_dist_tsi := p_ann_tsi_amt - v_sum_ann_dist_tsi;
                    v_share_cd     := '999';
                    INSERT_TO_WPERILDS_DTL;
                 END IF;
             END IF;
       END IF;
    
    END insert_setup_dflt_peril_values;    
    
    PROCEDURE get_default_dist_params (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_policy_id       IN OUT giuw_pol_dist.policy_id%TYPE,      
      p_post_flag       OUT giuw_pol_dist.post_flag%TYPE,
      p_line_cd         IN OUT giis_default_dist.line_cd%TYPE ,      
      p_default_no      OUT giis_default_dist.default_no%TYPE , 
      p_dist_type       OUT giis_default_dist.dist_type%TYPE , 
      p_default_type    OUT giis_default_dist.default_type%TYPE,
      p_orig_dist_no    OUT giuw_pol_dist.dist_no%TYPE 
    )
    IS
      v_pol_flag        gipi_polbasic.pol_flag%TYPE;
      v_par_type        gipi_parlist.par_type%TYPE ; 
      v_orig_dist_no    giuw_pol_dist.dist_no%TYPE := NULL  ;
      v_policy_id       gipi_polbasic.policy_id%TYPE; 
      v_line_cd         gipi_polbasic.line_cd%TYPE ;
      v_subline_cd      gipi_polbasic.subline_cd%TYPE;
      v_iss_cd          gipi_polbasic.iss_cd%TYPE ;
      v_issue_yy        gipi_polbasic.issue_yy%TYPE; 
      v_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no        gipi_polbasic.renew_no%TYPE;
      v_default_no      giis_default_dist.default_no%TYPE := NULL;
      v_dist_type       giis_default_dist.dist_type%TYPE := NULL ;
      v_default_type    giis_default_dist.default_type%TYPE := NULL ;     
      v_post_flag       giuw_pol_dist.post_flag%TYPE := NULL ;         
    BEGIN
    
        FOR curpol in (SELECT a.pol_flag, b.par_type, a.policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no
                        FROM gipi_polbasic a, gipi_parlist b , giuw_pol_dist c
                            WHERE c.dist_no = p_dist_no
                                AND c.policy_id = a.policy_id
                                AND a.par_id = b.par_id )
        LOOP
            
            v_pol_flag := curpol.pol_flag;
            v_par_type  := curpol.par_type;
            v_policy_id := curpol.policy_id;
            v_line_cd   := curpol.line_cd;
            v_subline_cd := curpol.subline_cd;
            v_iss_cd     := curpol.iss_cd;
            v_issue_yy  := curpol.issue_yy;
            v_pol_seq_no    := curpol.pol_seq_no;
            v_renew_no      := curpol.renew_no;
            EXIT; 
        END LOOP;
        
        
        IF v_pol_flag = '2' THEN
              FOR post IN (SELECT post_flag , dist_flag, dist_no
                                   FROM GIUW_POL_DIST 
                                  WHERE dist_no = 
                                         (SELECT max(dist_no) 
                                            FROM GIUW_POL_DIST 
                                           WHERE policy_id = 
                                                    ( SELECT MAX(old_policy_id) 
                                                        FROM GIPI_POLNREP
                                                       WHERE ren_rep_sw = '1'
                                                         AND new_policy_id = (SELECT policy_id
                                                                                FROM gipi_polbasic
                                                                               WHERE pol_flag <> '5'
                                                                                 AND policy_id = v_policy_id))))
               LOOP
                   IF post.dist_flag in ( '2', '3') THEN 
                      v_post_flag := post.post_flag;
                      v_orig_dist_no := post.dist_no; 
                   END IF;
                   EXIT;
               END LOOP;        
        ELSIF v_par_type = 'E' THEN        

            FOR post IN ( SELECT post_flag, dist_flag, dist_no 
                              FROM giuw_pol_dist
                             WHERE dist_no =
                                      (SELECT MAX(dist_no) 
                                        FROM GIUW_POL_DIST 
                                       WHERE par_id = (SELECT par_id
                                                         FROM gipi_polbasic
                                                        WHERE endt_seq_no = 0
                                                            AND line_cd = v_line_cd
                                                            AND subline_cd = v_subline_cd
                                                            AND iss_cd = v_iss_cd
                                                            AND issue_yy = v_issue_yy
                                                            AND pol_seq_no = v_pol_seq_no
                                                            AND renew_no  = v_renew_no 
                                                         )))
             LOOP
                 IF post.dist_flag in ( '2', '3') THEN 
                    v_post_flag := post.post_flag;
                    v_orig_dist_no := post.dist_no; 
                 END IF;
                 EXIT;          
             END LOOP;   
             
             FOR witemds IN ( SELECT 1 
                                FROM giuw_witemds 
                                    WHERE dist_no = p_dist_no 
                                        AND tsi_amt = 0 
                                        AND prem_amt = 0 )
             LOOP
                v_post_flag := 'O';     
                EXIT;         
             END LOOP;             
        END IF; 
        
        
        -- if post_flag is NULL, retrieve it from default distribution, and get the default distribution , else just retrieve the default distribution based on post_flag 
        IF v_post_flag IS NULL THEN
            v_post_flag := 'O' ; -- magdefault muna ng one risk then overwrite nlng ng default distribution if meron ngexists
            FOR defDist in (SELECT x.default_no, x.default_type, x.dist_type
                              FROM giis_default_dist x
                             WHERE x.line_cd = v_line_cd
                               AND x.subline_cd = v_subline_cd )
            LOOP 
                IF defDist.dist_type = '1' THEN
                    v_post_flag := 'O';
                ELSE
                    v_post_flag := 'P';
                END IF;                   
                v_default_no := defDist.default_no;        
                v_default_type := defDist.default_type;     
                v_dist_type := defDist.dist_type ;                             
            END LOOP;           
          
        ELSE
            FOR defDist in (SELECT x.default_no, x.default_type, x.dist_type
                              FROM giis_default_dist x
                             WHERE x.line_cd = v_line_cd
                               AND x.subline_cd = v_subline_cd 
                               AND x.dist_type = DECODE ( v_post_flag, 'O', '1', '2' ))
            LOOP                    
                v_default_no := defDist.default_no;        
                v_default_type := defDist.default_type;     
                v_dist_type := defDist.dist_type ;                             
            END LOOP;      
        END IF;   
       
        p_post_flag := NVL(v_post_flag,'O');
        p_default_no := v_default_no;
        p_dist_type  := v_dist_type;
        p_default_type := v_default_type;
        p_orig_dist_no := v_orig_dist_no;
        p_line_cd      := v_line_cd;
        p_policy_id    := v_policy_id;
    
    END get_default_dist_params ; 
    
    
    PROCEDURE populate_default_dist (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_post_flag       IN OUT giuw_pol_dist.post_flag%TYPE ,
      p_dist_type       IN OUT giuw_pol_dist.dist_type%TYPE
    )
    IS
      v_post_flag       giuw_pol_dist.post_flag%TYPE ;
      v_default_no      giis_default_dist.default_no%TYPE;
      v_dist_type       giis_default_dist.dist_type%TYPE;
      v_default_type    giis_default_dist.default_type%TYPE ;
      v_orig_dist_no    giuw_pol_dist.dist_no%TYPE;
      v_tsi_amt         giuw_wpolicyds.tsi_amt%TYPE;
      v_prem_amt        giuw_wpolicyds.prem_amt%TYPE;
      v_ann_tsi_amt     giuw_wpolicyds.ann_tsi_amt%TYPE;
      v_line_cd         giis_dist_share.line_cd%TYPE ; 
      v_peril_cd        giis_peril.peril_cd%TYPE;
      v_share_cd        giis_dist_share.share_cd%TYPE ;
      v_dist_tsi        giuw_wpolicyds_dtl.dist_tsi%TYPE;
      v_dist_prem       giuw_wpolicyds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi    giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
      v_dist_spct       giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_dist_spct1      giuw_wpolicyds_dtl.dist_spct1%TYPE;
      v_dist_seq_no     giuw_wpolicyds.dist_seq_no%TYPE;
      v_currency_rt     gipi_invoice.currency_rt%TYPE ;
      v_item_grp        gipi_invoice.item_grp%TYPE; 
      v_policy_id       gipi_polbasic.policy_id%TYPE;
      v_distributed_sw  VARCHAR2(1);
      v_rg_count        NUMBER;
      v_spct1_exists    VARCHAR2(1);   
 
      
      PROCEDURE INSERT_TO_WPOLICYDS_DTL IS
      BEGIN
        INSERT INTO  GIUW_WPOLICYDS_DTL
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp    , dist_spct1)
             VALUES (p_dist_no   , v_dist_seq_no , v_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1           , v_dist_spct1);
      END; -- end INSERT_TO_WPOLICYDS_DTL  
      
      PROCEDURE insert_to_wperilds_dtl
      IS
      BEGIN
         INSERT INTO giuw_wperilds_dtl
                     (dist_no, dist_seq_no, line_cd, share_cd,
                      dist_spct, dist_tsi, dist_prem, ann_dist_spct,
                      ann_dist_tsi, dist_grp, peril_cd, dist_spct1
                     )
              VALUES (p_dist_no, v_dist_seq_no, v_line_cd, v_share_cd,
                      v_dist_spct, v_dist_tsi, v_dist_prem, v_dist_spct,
                      v_ann_dist_tsi, 1, v_peril_cd, v_dist_spct1
                     ); 
      END ; -- end  insert_to_wperilds_dtl       
      
      FUNCTION get_currency_rt ( p_policy_id gipi_polbasic.policy_id%TYPE, p_item_grp giuw_wpolicyds.item_grp%TYPE )
      RETURN NUMBER AS
        v_currency_rt gipi_invoice.currency_rt%TYPE  := 1 ;
      BEGIN   
      
        FOR gipi_inv IN (SELECT currency_rt 
                            FROM gipi_invoice
                                WHERE policy_id = p_policy_id
                                    AND item_grp = p_item_grp )
        LOOP
            v_currency_rt := gipi_inv.currency_rt;
            EXIT;
        END LOOP;
        
        RETURN v_currency_rt ; 
        
      END ;
    BEGIN
    
     
      GIUW_POL_DIST_FINAL_PKG.GET_DEFAULT_DIST_PARAMS ( p_dist_no, v_policy_id, v_post_flag, v_line_cd, v_default_no, v_dist_type, v_default_type, v_orig_dist_no );
      
      -- default distribution for one risk 
      IF v_post_flag = 'O' THEN
      
         DELETE FROM 
            giuw_wpolicyds_dtl 
                WHERE dist_no = p_dist_no;
                
         FOR polds IN (SELECT dist_no, dist_seq_no, NVL(tsi_amt,0) tsi_amt, NVL(prem_amt,0) prem_amt, NVL(ann_tsi_amt,0) ann_tsi_amt, item_grp 
                        FROM giuw_wpolicyds 
                            WHERE dist_no = p_dist_no
                                ORDER BY dist_seq_no )
         LOOP
                v_distributed_sw := 'N'; 
                v_tsi_amt := polds.tsi_amt;
                v_prem_amt :=polds.prem_amt;
                v_ann_tsi_amt := polds.ann_tsi_amt;
                v_dist_seq_no := polds.dist_seq_no;
                v_item_grp    := polds.item_grp; 
                v_currency_rt := get_currency_rt (v_policy_id, v_item_grp );
                
                FOR oldDist in ( SELECT share_cd, dist_spct, dist_spct1 
                                    FROM giuw_policyds_dtl 
                                        WHERE DIST_NO = v_orig_dist_no AND dist_seq_no = polds.dist_seq_no  )                
                LOOP
                    v_share_cd := oldDist.share_cd;
                    v_dist_spct := oldDist.dist_spct;
                    v_dist_spct1 := oldDist.dist_spct1 ;
                    v_dist_tsi := ROUND (((v_tsi_amt * v_dist_spct) / 100), 2);
                    v_dist_prem := ROUND (((v_prem_amt * NVL(v_dist_spct1,v_dist_spct) ) / 100), 2);
                    v_ann_dist_tsi :=
                           ROUND (((v_ann_tsi_amt * v_dist_spct) / 100), 2);
                    
                    INSERT_TO_WPOLICYDS_DTL ;
                    v_distributed_sw := 'Y';
                END LOOP; 
                
                IF v_distributed_sw = 'N' THEN            
                   IF v_default_no IS NULL THEN 
                         v_rg_count := 0 ;
                   ELSIF v_dist_type = '1' THEN
                       v_rg_count := 0 ; 
                       FOR rg in (SELECT '1' FROM giis_default_dist_group
                                     WHERE default_no = v_default_no )
                       LOOP 
                            v_rg_count := v_rg_count + 1 ; 
                       END LOOP;
                   ELSE
                       v_rg_count := 0 ;                      
                   END IF;           
                  
                   GIUW_POL_DIST_FINAL_PKG.INSERT_SETUP_DFLT_GROUP_VALUES ( p_dist_no, v_dist_seq_no, v_rg_count , v_default_no
                                        , v_default_type, v_line_cd, v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_currency_rt );          
                END IF;                
         END LOOP;
         
         v_spct1_exists := 'N'; 
         FOR exists1 in ( SELECT 1 
                            FROM giuw_wpolicyds_dtl
                                WHERE dist_no = p_dist_no
                                    AND dist_spct1 IS NOT NULL )
         LOOP
            v_spct1_exists := 'Y';
            EXIT;
         END LOOP;
         
         IF v_spct1_exists = 'Y' THEN
            UPDATE giuw_wpolicyds_dtl
                SET dist_spct1 = dist_spct
                    WHERE dist_no = p_dist_no
                        AND dist_spct1 IS NULL; 
                        
         END IF;
      
      -- default distribution for peril distribution 
      ELSE

         DELETE FROM 
            giuw_wperilds_dtl 
                WHERE dist_no = p_dist_no;
                      
         FOR polds IN (SELECT dist_no, dist_seq_no, item_grp 
                        FROM giuw_wpolicyds 
                            WHERE dist_no = p_dist_no
                                ORDER BY dist_seq_no )
         LOOP            
             v_item_grp    := polds.item_grp; 
             v_currency_rt := get_currency_rt (v_policy_id, v_item_grp );
             
             FOR curperil in (SELECT x.dist_seq_no, x.line_cd , x.peril_cd , x.tsi_amt, x.prem_amt, x.ann_tsi_amt 
                                        FROM giuw_wperilds x
                                            WHERE x.dist_no = polds.dist_no 
                                                AND x.dist_seq_no = polds.dist_seq_no
                                             ORDER BY x.dist_seq_no, x.peril_cd )
             LOOP
                 v_distributed_sw := 'N'; 
                 v_tsi_amt := curperil.tsi_amt;
                 v_prem_amt :=curperil.prem_amt;
                 v_ann_tsi_amt := curperil.ann_tsi_amt;         
                 v_peril_cd    := curperil.peril_cd;    
                 v_dist_seq_no := curperil.dist_seq_no;  
                   
                 FOR old_perildist in ( SELECT share_cd, dist_spct, dist_spct1   
                                          FROM giuw_perilds_dtl a
                                            WHERE a.dist_seq_no = v_dist_seq_no
                                              AND a.peril_cd = v_peril_cd
                                              AND dist_no = v_orig_dist_no )
                 LOOP
                      v_distributed_sw := 'Y'; 
                      v_share_cd := old_perildist.share_cd;
                      v_dist_spct := old_perildist.dist_spct;
                      v_dist_spct1 := old_perildist.dist_spct1 ;
                      v_dist_tsi := ROUND (((v_tsi_amt * v_dist_spct) / 100), 2);
                      v_dist_prem := ROUND (((v_prem_amt * NVL(v_dist_spct1,v_dist_spct)) / 100), 2);
                      v_ann_dist_tsi := ROUND (((v_ann_tsi_amt * v_dist_spct) / 100), 2);                              
                      
                      INSERT_TO_WPERILDS_DTL  ;                      
                 END LOOP;
       

                 IF v_distributed_sw = 'N' THEN
                      IF v_default_no IS NULL THEN 
                           v_rg_count := 0 ;
                      ELSIF v_dist_type = '2' THEN
                           v_rg_count := 0 ; 
                           FOR rg in (SELECT '1' FROM giis_default_dist_peril
                                          WHERE default_no = v_default_no
                                              AND line_cd = v_line_cd 
                                              AND peril_cd = v_peril_cd  )
                           LOOP 
                               v_rg_count := v_rg_count + 1 ; 
                           END LOOP;
                      ELSE
                           v_rg_count := 0 ;                      
                      END IF;           
                             
                      GIUW_POL_DIST_FINAL_PKG.INSERT_SETUP_DFLT_PERIL_VALUES ( p_dist_no, v_dist_seq_no, v_rg_count , v_default_no
                                            , v_default_type, v_line_cd, v_peril_cd, v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_currency_rt ); 


                 END IF;              
             END LOOP;
        END LOOP;
        
        v_spct1_exists := 'N'; 
        FOR exists1 in ( SELECT 1 
                            FROM giuw_wperilds_dtl
                                WHERE dist_no = p_dist_no
                                    AND dist_spct1 IS NOT NULL )
         LOOP
            v_spct1_exists := 'Y';
            EXIT;
         END LOOP;
         
         IF v_spct1_exists = 'Y' THEN
            UPDATE giuw_wperilds_dtl
                SET dist_spct1 = dist_spct
                    WHERE dist_no = p_dist_no
                        AND dist_spct1 IS NULL; 
                        
         END IF;
      END IF;      
      
      -- based on the post_flag, populate the other distribution tables and do the correponding adjustment  
     -- jhing 11.25.2014 populate other distribution tables and to adjust it based on post_flag 
      IF NVL(v_post_flag,'O') = 'O' THEN    
            GIUW_POL_DIST_FINAL_PKG.populate_oth_tbls_one_risk ( p_dist_no );
            GIUW_POL_DIST_PKG.ADJUST_ALL_WTABLES_GIUWS004(p_dist_no);
      ELSE 
            GIUW_POL_DIST_FINAL_PKG.populate_oth_tbls_peril_dist( p_dist_no );
            ADJUST_DISTRIBUTION_PERIL_PKG.ADJUST_DISTRIBUTION(p_dist_no);
      END IF;
      
      p_post_flag := v_post_flag;
          
    END populate_default_dist;   
    
    PROCEDURE update_dist_ds_prem (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE,
      p_policy_id       IN gipi_polbasic.policy_id%TYPE
    )
    IS
    /* Created by Jhing 11.26.2014 
    ** Purpose: to correct the premium amounts of other DS tables
    **          based on GIUW_WITEMPERILDS for the setup or recreation of unearned portion of the REDISTRIBUTED record. Will be used by GIUWS010 and GIUWS018
    */
    BEGIN
    
    -- update giuw_wperilds based on giuw_witemperilds
      FOR i IN (SELECT   a.dist_no, a.dist_seq_no, a.peril_cd,
                         a.prem_amt iperl_prem, b.prem_amt perl_prem
                    FROM (SELECT   dist_no, dist_seq_no, peril_cd,
                                   SUM (ROUND (NVL (prem_amt, 0), 2))  prem_amt
                              FROM giuw_witemperilds
                             WHERE dist_no = p_dist_no
                          GROUP BY dist_no, dist_seq_no, peril_cd) a,
                         (SELECT dist_no, dist_seq_no, peril_cd,                              
                                 ROUND (NVL (prem_amt, 0), 2) prem_amt
                            FROM giuw_wperilds
                           WHERE dist_no = p_dist_no) b
                   WHERE a.dist_no = b.dist_no
                     AND a.dist_seq_no = b.dist_seq_no
                     AND a.peril_cd = b.peril_cd                     
                ORDER BY a.dist_no, a.dist_seq_no, a.peril_cd)
      LOOP
         UPDATE giuw_wperilds
            SET prem_amt = i.iperl_prem
          WHERE dist_no = i.dist_no
            AND dist_seq_no = i.dist_seq_no
            AND peril_cd = i.peril_cd;
      END LOOP; 

    -- update giuw_witemds based on giuw_witemperilds 
     FOR i IN
         (SELECT   a.dist_no, a.dist_seq_no, a.item_no, 
                   a.prem_amt iperl_prem,
                   b.prem_amt item_prem
              FROM (SELECT   dist_no, dist_seq_no, item_no,
                             SUM (ROUND (NVL (prem_amt, 0), 2)) prem_amt
                        FROM giuw_witemperilds c, giis_peril d
                       WHERE c.dist_no = p_dist_no
                         AND c.peril_cd = d.peril_cd
                         AND c.line_cd = d.line_cd
                    GROUP BY dist_no, dist_seq_no, item_no) a,
                   (SELECT dist_no, dist_seq_no, item_no,                          
                           ROUND (NVL (prem_amt, 0), 2) prem_amt
                      FROM giuw_witemds
                     WHERE dist_no = p_dist_no) b
             WHERE a.dist_no = b.dist_no
               AND a.dist_seq_no = b.dist_seq_no
               AND a.item_no = b.item_no              
          ORDER BY a.dist_no, a.dist_seq_no, a.item_no)
      LOOP
         UPDATE giuw_witemds
            SET prem_amt = i.iperl_prem
          WHERE dist_no = i.dist_no
            AND dist_seq_no = i.dist_seq_no
            AND item_no = i.item_no;
      END LOOP;
    
    
    -- update giuw_wpolicyds based on giuw_witemperilds 
      FOR i IN
         (SELECT   a.dist_no, a.dist_seq_no, 
                   a.prem_amt iperl_prem, 
                   b.prem_amt pol_prem
              FROM (SELECT   dist_no, dist_seq_no,
                             SUM (ROUND (NVL (prem_amt, 0), 2)) prem_amt
                        FROM giuw_witemperilds c, giis_peril d
                       WHERE c.dist_no = p_dist_no
                         AND c.peril_cd = d.peril_cd
                         AND c.line_cd = d.line_cd
                    GROUP BY dist_no, dist_seq_no) a,
                   (SELECT dist_no, dist_seq_no,
                           ROUND (NVL (prem_amt, 0), 2) prem_amt
                      FROM giuw_wpolicyds
                     WHERE dist_no = p_dist_no) b
             WHERE a.dist_no = b.dist_no
               AND a.dist_seq_no = b.dist_seq_no             
          ORDER BY a.dist_no, a.dist_seq_no)
      LOOP
         UPDATE giuw_wpolicyds
            SET prem_amt = i.iperl_prem
          WHERE dist_no = i.dist_no AND dist_seq_no = i.dist_seq_no;
      END LOOP;
    
      -- update giuw_pol_dist
      FOR poldist IN (SELECT SUM (b.prem_amt * NVL (a.currency_rt, 1)) prem_amt
                          FROM gipi_invoice a, giuw_wpolicyds b
                         WHERE a.policy_id = p_policy_id
                           AND b.dist_no = p_dist_no
                           AND a.item_grp = b.item_grp)
      LOOP
        UPDATE giuw_pol_dist
            SET prem_amt = poldist.prem_amt
         WHERE dist_no = p_dist_no;
      
      END LOOP;
      
    END update_dist_ds_prem;    
    
    PROCEDURE recrte_grp_ds_tables_giuws018 (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_policy_id       IN gipi_polbasic.policy_id%TYPE
    )
    IS
    /** ====================================================================================================
    **  Created by : Jhing Factor 11.28.2014
    **  Purpose    : This procedure will recreate the records in GIUW_WITEMDS and GIUW_WITEMPERILDS 
    **               based on GIUW_WPERILDS and GIUW_WPOLICYDS. This can only be used by Setup Dist By Peril.
    **               Note that scenarios wherein distribution is grouped by item, then regrouped by peril
    **               cannot be handled by this code. For now, we will not consider this scenario in web
    **               since it may produce erroneous records in DS tables and other distribution tables.
    ** ================================================================================================== */
    
        v_redist_sw         VARCHAR2(1);
        v_max_takeup        giuw_pol_dist.takeup_seq_no%TYPE;
        v_current_takeup    giuw_pol_dist.takeup_seq_no%TYPE; 
        v_prem_amt          gipi_itmperil.prem_amt%TYPE;
        v_tsi_amt           gipi_itmperil.tsi_amt%TYPE;
        v_ann_tsi_amt       gipi_itmperil.ann_tsi_amt%TYPE;
        v_post_flag         giuw_pol_dist.post_flag%TYPE;
        v_dist_type         giuw_pol_dist.dist_type%TYPE;
        v_err_in_seq        VARCHAR2(1) ; 
        v_err_exists        VARCHAR2(1) ;
    BEGIN          
        -- check if the policy is already redistributed ( dist_flag = 5 ). This will have an impact on the computation of premium .
        v_redist_sw := 'N';
        FOR cur in ( SELECT 1 
                        FROM giuw_pol_dist
                            WHERE policy_id = p_policy_id
                                AND dist_flag = '5' )
        LOOP
            v_redist_sw := 'Y';
            EXIT;
        END LOOP;
        
        -- get takeup variables. This will be important in the computation of premium especially in long term policies 
        SELECT NVL(takeup_seq_no,1)
            INTO v_current_takeup
                FROM giuw_pol_dist
                WHERE dist_no = p_dist_no;
        
        FOR cur2 in (SELECT NVL(max(takeup_seq_no), 1) takeup_seq_no
                    FROM giuw_pol_dist
                        WHERE policy_id = p_policy_id )
        LOOP
            v_max_takeup := cur2.takeup_seq_no;
            EXIT;
        END LOOP;
        
        
        -- create the records in GIUW_WITEMDS based on the records on GIPI_ITMPERIL and GIUW_WPERILDS and GIUW_WPOLICYDS. At this point
        -- it is expected that no anomaly records are created in GIUW_WPERILDS and GIUW_WPOLICYDS
         
        FOR polds IN ( SELECT dist_no, dist_seq_no , item_grp 
                        FROM giuw_wpolicyds
                             WHERE dist_no = p_dist_no  )
        LOOP
        
            --nieko 01172017, SR 23565
            IF v_redist_sw = 'Y' THEN
                FOR itmperil IN
                   (SELECT   b380.item_no,
                             SUM (DECODE (b390.peril_type, 'B', b380.ann_tsi_amt, 0 ) ) ann_tsi_amt,
                             SUM (DECODE (b390.peril_type, 'B', b380.tsi_amt, 0) ) tsi_amt,
                             SUM (b380.prem_amt - c150.prem_amt) prem_amt
                        FROM gipi_itmperil b380,
                             gipi_item b340,
                             giis_peril b390,
                             giuw_wperilds c150
                       WHERE b340.policy_id = p_policy_id
                         AND b340.policy_id = b380.policy_id
                         AND b340.item_no = b380.item_no
                         AND b380.line_cd = b390.line_cd
                         AND b380.peril_cd = b390.peril_cd
                         AND b340.item_grp = polds.item_grp
                         AND b380.line_cd = c150.line_cd
                         AND b380.peril_cd = c150.peril_cd
                         AND b380.peril_cd IN (
                                SELECT a.peril_cd
                                  FROM giuw_wperilds a
                                 WHERE a.dist_no = p_dist_no
                                   AND a.dist_seq_no = polds.dist_seq_no)
                         AND c150.dist_no IN (
                                SELECT dist_no
                                  FROM giuw_pol_dist
                                 WHERE policy_id = p_policy_id
                                   AND dist_flag IN (2, 3))
                    GROUP BY b380.item_no)
                LOOP
                   INSERT INTO giuw_witemds
                               (dist_no, dist_seq_no, item_no,
                                tsi_amt, prem_amt,
                                ann_tsi_amt
                               )
                        VALUES (p_dist_no, polds.dist_seq_no, itmperil.item_no,
                                itmperil.tsi_amt, itmperil.prem_amt,
                                itmperil.ann_tsi_amt
                               );
                END LOOP;
            ELSE
                -- create records in GIUW_WITEMDS based on GIPI_ITMPERIL
                FOR itmperil in (SELECT   b340.item_no, SUM (DECODE (b390.peril_type, 'B', b380.ann_tsi_amt, 0)) ann_tsi_amt,
                                     SUM (DECODE (b390.peril_type, 'B', b380.tsi_amt, 0)) tsi_amt,
                                     SUM (b380.prem_amt) prem_amt
                                FROM gipi_itmperil b380, gipi_item b340, giis_peril b390
                               WHERE b340.policy_id = p_policy_id
                                 AND b340.policy_id = b380.policy_id
                                 AND b340.item_no = b380.item_no
                                 AND b380.line_cd = b390.line_cd
                                 AND b380.peril_cd = b390.peril_cd
                                 AND b340.item_grp = polds.item_grp
                                 AND b380.peril_cd IN (
                                             SELECT a.peril_cd
                                               FROM giuw_wperilds a
                                              WHERE a.dist_no = p_dist_no
                                                    AND a.dist_seq_no = polds.dist_seq_no)
                            GROUP BY b340.item_no, b340.ann_tsi_amt)
                LOOP            
                       INSERT INTO giuw_witemds
                                 (dist_no             , dist_seq_no         , item_no         ,
                                  tsi_amt             , prem_amt            , ann_tsi_amt)
                          VALUES (p_dist_no           , polds.dist_seq_no      , itmperil.item_no       ,     
                                  itmperil.tsi_amt      , itmperil.prem_amt  , itmperil.ann_tsi_amt);               
                
                END LOOP;     
            
            END IF;
            -- after records are inserted in GIUW_WITEMDS insert records in GIUW_WITEMPERILDS  
            
            -- if the policy has been redistributed, premium will consider total premium from earned portion of distribution.
            IF v_redist_sw = 'Y' THEN
                
                /*
                ** nieko 01172017, SR 23565
                FOR c3 IN (SELECT   b380.tsi_amt itmperil_tsi,
                                     (b380.prem_amt - SUM (c150.dist_prem)) itmperil_premium,
                                     b380.ann_tsi_amt itmperil_ann_tsi, b380.item_no item_no,
                                     b380.peril_cd peril_cd, b380.line_cd
                                FROM gipi_itmperil b380, gipi_item b340, giuw_itemperilds_dtl c150
                               WHERE b380.item_no = b340.item_no
                                 AND b380.policy_id = b340.policy_id
                                 AND b340.item_no = c150.item_no
                                 AND b380.peril_cd = c150.peril_cd
                                 AND b380.line_cd = c150.line_cd
                                 AND b340.policy_id = p_policy_id
                                 AND b340.item_grp = polds.item_grp
                                 AND c150.dist_no IN (
                                                     SELECT dist_no
                                                       FROM giuw_pol_dist
                                                      WHERE policy_id = p_policy_id
                                                            AND dist_flag IN (2, 3))
                                 AND EXISTS (SELECT 1
                                               FROM giuw_witemds px
                                              WHERE px.dist_no = polds.dist_no 
                                              AND px.dist_seq_no = polds.dist_seq_no
                                              AND px.item_no = b340.item_no)
                            GROUP BY b380.tsi_amt,
                                     b380.ann_tsi_amt,
                                     b380.item_no,
                                     b380.peril_cd,
                                     b340.pack_line_cd
                                     b380.prem_amt
                            ORDER BY b380.peril_cd)
                LOOP
                         
                         
                         INSERT INTO  GIUW_WITEMPERILDS  
                                  (dist_no             , dist_seq_no   , item_no         ,
                                   peril_cd            , line_cd       , tsi_amt         ,
                                   prem_amt            , ann_tsi_amt)
                                VALUES 
                                  (p_dist_no           , polds.dist_seq_no , c3.item_no      ,
                                   c3.peril_cd         , c3.line_cd     , c3.itmperil_tsi , 
                                   c3.itmperil_premium , c3.itmperil_ann_tsi);
                
                END LOOP;
                */            
                
                --nieko 01172017, SR 23565
                FOR c3 IN (SELECT   b380.tsi_amt itmperil_tsi,
                                    (b380.prem_amt - SUM (c150.prem_amt)
                                    ) itmperil_premium,
                                    b380.ann_tsi_amt itmperil_ann_tsi,
                                    b380.item_no item_no, b380.peril_cd peril_cd,
                                    b380.line_cd
                               FROM gipi_itmperil b380,
                                    gipi_item b340,
                                    giuw_perilds c150
                              WHERE b380.item_no = b340.item_no
                                AND b380.policy_id = b340.policy_id
                                AND b380.peril_cd = c150.peril_cd
                                AND b380.line_cd = c150.line_cd
                                AND b340.policy_id = p_policy_id
                                AND b340.item_grp = polds.item_grp
                                AND c150.dist_no IN (
                                       SELECT dist_no
                                         FROM giuw_pol_dist
                                        WHERE policy_id = p_policy_id
                                          AND dist_flag IN (2, 3))
                                AND b380.peril_cd IN (
                                       SELECT a.peril_cd
                                         FROM giuw_wperilds a
                                        WHERE a.dist_no = p_dist_no
                                          AND a.dist_seq_no = polds.dist_seq_no)
                           GROUP BY b380.tsi_amt,
                                    b380.ann_tsi_amt,
                                    b380.item_no,
                                    b380.peril_cd,
                                    b380.line_cd,
                                    b380.prem_amt
                           ORDER BY b380.peril_cd)
                LOOP
                         
                         
                         INSERT INTO  GIUW_WITEMPERILDS  
                                  (dist_no             , dist_seq_no   , item_no         ,
                                   peril_cd            , line_cd       , tsi_amt         ,
                                   prem_amt            , ann_tsi_amt)
                                VALUES 
                                  (p_dist_no           , polds.dist_seq_no , c3.item_no      ,
                                   c3.peril_cd         , c3.line_cd     , c3.itmperil_tsi , 
                                   c3.itmperil_premium , c3.itmperil_ann_tsi);
                
                END LOOP;
                
            -- the policy has not been redistributed. premium will only be based on gipi_itmperil premium amounts. Long term policies will 
            -- consider takeup in the computation of premium.
            ELSE
              -- get the amounts from gipi_itmperil. For long term, recompute the premium based on proportion per takeup. Last takeup will
              -- hold the remaining premium from other takeups.
              FOR c3 IN (SELECT B380.tsi_amt     itmperil_tsi     ,
                                B380.prem_amt    itmperil_premium ,
                                B380.ann_tsi_amt itmperil_ann_tsi ,
                                B380.item_no     item_no          ,
                                B380.peril_cd    peril_cd, B380.line_cd
                           FROM GIPI_ITMPERIL B380, GIPI_ITEM B340
                          WHERE B380.item_no   = B340.item_no
                            AND B380.policy_id = B340.policy_id
                            AND B340.item_grp  = polds.item_grp
                            AND B340.policy_id = p_policy_id
                            AND b380.peril_cd IN (
                                         SELECT a.peril_cd
                                           FROM giuw_wperilds a
                                          WHERE a.dist_no = p_dist_no
                                                AND a.dist_seq_no = polds.dist_seq_no)
                          ORDER BY B380.peril_cd)
              LOOP                     

                IF v_current_takeup = v_max_takeup  THEN 
                        v_tsi_amt          := NVL(c3.itmperil_tsi,0)    ;
                        v_prem_amt         := NVL(c3.itmperil_premium,0) - (ROUND((NVL(c3.itmperil_premium,0)/ v_max_takeup ),2) * (v_max_takeup  - 1));
                        v_ann_tsi_amt      := NVL(c3.itmperil_ann_tsi,0);
                ELSE
                        v_tsi_amt          := ROUND((NVL(c3.itmperil_tsi,0)    ),2);
                        v_prem_amt         := ROUND((NVL(c3.itmperil_premium,0)/v_max_takeup ),2);
                        v_ann_tsi_amt      := ROUND((NVL(c3.itmperil_ann_tsi,0)),2);
                END IF; 
                      
                INSERT INTO  GIUW_WITEMPERILDS  
                  (dist_no             , dist_seq_no   , item_no         ,
                   peril_cd            , line_cd       , tsi_amt         ,
                   prem_amt            , ann_tsi_amt)
                VALUES 
                    (p_dist_no         , polds.dist_seq_no , c3.item_no      ,
                   c3.peril_cd         , c3.line_cd     , v_tsi_amt,
                   v_prem_amt, v_ann_tsi_amt);
                
                  
              END LOOP;
            
            END IF;    
        
        END LOOP;    
        
        -- recompute the other DS tables based from giuw_witemperilds  
        GIUW_POL_DIST_FINAL_PKG.update_dist_ds_prem ( p_dist_no , p_policy_id ); 

        v_err_exists := 'N';
        GIUW_POL_DIST_FINAL_PKG.check_missing_dist_rec_item (p_dist_no, p_policy_id , v_err_exists );
        IF v_err_exists = 'Y' THEN
             RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#There are missing distribution records. Please recreate the items before re-grouping the records.'); 
        END IF;  

       -- jhing 12.11.2014 prompt an error when dist_seq_no is insequential
       v_err_in_seq := 'N';
       GIUW_POL_DIST_FINAL_PKG.val_sequential_distGrp (p_dist_no , 'GIUWS018', v_err_in_seq) ; 
       IF v_err_in_seq = 'Y' THEN
          RAISE_APPLICATION_ERROR (-20004 , 'Geniisys Exception#E#There are non-sequential distribution group nos. Please recreate the items then try to regroup the items again. '); 
 
       END IF;  

       GIUW_POL_DIST_FINAL_PKG.val_multipleBillGrp_perDist (p_dist_no , p_policy_id, v_err_in_seq) ; 
       IF v_err_in_seq = 'Y' THEN
          RAISE_APPLICATION_ERROR (-20004 , 'Geniisys Exception#E#Cannot proceed with the setup of distribution. There are multiple bill groups which were grouped into a single distribution no. Please recreate the items and try to re-grouped the records again.'); 
 
       END IF;   
       
               
        -- call the new procedure for populating default distribution 
        GIUW_POL_DIST_FINAL_PKG.POPULATE_DEFAULT_DIST ( p_dist_no, v_post_flag, v_dist_type );        
       
       UPDATE giuw_pol_dist
         SET dist_flag = '1',
             post_flag = v_post_flag,
             dist_type = '2'
       WHERE policy_id = p_policy_id
         AND dist_no   = p_dist_no;   
        
    END recrte_grp_ds_tables_giuws018;   
    
    PROCEDURE validate_setup_dist_per_action  (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_policy_id       IN gipi_polbasic.policy_id%TYPE,
      p_action          IN VARCHAR2,
      p_module_id       IN giis_modules.module_id%TYPE
    )
    IS
    /** ====================================================================================================
    **  Created by : Jhing Factor 12.04.2014 
    **  Purpose    : This procedure will validate distribution records based on the action selected by the user.  
    **               Instead of creating multiple web procedures, I placed all the validations of the setup .
    **               modules in this procedure. This will be used by GIUWS010 and GIUWS018.
    **               
    **               Possible values for action:
    **                          CREATE_ITEM   => pressing Create/Recreate Items in GIUWS010 , GIUWS018 
    **                          NEW_GROUP     => pressing New Group in GIUWS010 , GIUWS018
    **                          JOIN_GROUP    => pressing Join Group in GIUWS010 , GIUWS018
    ** ================================================================================================== */      
    
     v_err_exists   VARCHAR2(1) := 'N' ;  
     v_alert VARCHAR2(2000) := NULL ; 
    BEGIN        
        -- check if parameters encoded are handled by the procedure. Note that as of date of creation, this procedure can only
        -- handle CREATE_ITEM, NEW_GROUP, JOIN_GROUP of modules GIUWS010 and GIUWS018
        IF NVL(p_module_id,'X') NOT IN ('GIUWS010', 'GIUWS018') THEN
               RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#Invalid parameter passed for MODULE_ID for call to validate setup dist per action.'  ); 
        END IF;
        
        
        IF NVL(p_action , 'X') NOT IN ('NEW_GROUP','JOIN_GROUP','CREATE_ITEM') THEN
           RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#Invalid parameter passed for ACTION/PROCESS for call to validate setup dist per action.'); 
        END IF;
        
        -- execute distribution validations based on action and module id 
        IF UPPER(p_action) IN (  'CREATE_ITEM' , 'JOIN_GROUP', 'NEW_GROUP') THEN        
           GIUW_POL_DIST_FINAL_PKG.check_posted_binder (p_policy_id , p_dist_no, v_alert );
           IF v_alert IS NOT NULL  THEN
                RAISE_APPLICATION_ERROR (-20003 ,  'Geniisys Exception#E#You can no longer alter the distribution of a record with posted binder.' ); 
           END IF; 
                      
           GIUW_POL_DIST_FINAL_PKG.check_non_existing_basc_perl (p_policy_id , v_err_exists );
           IF v_err_exists = 'Y' THEN
                RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#Cannot proceed with the transaction. There is/are allied peril(s) attached to a non-existing basic peril(s).'); 
           END IF;        
           
        END IF;
     
        IF UPPER(p_module_id) = 'GIUWS010' AND UPPER(p_action) IN ('NEW_GROUP','JOIN_GROUP') THEN
           
           GIUW_POL_DIST_FINAL_PKG.check_regrp_by_peril (p_dist_no, v_err_exists );
           IF v_err_exists = 'Y' THEN
                RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#The distribution record has been grouped by peril which created multiple distribution groups for particular items. Re-grouping of distribution records per item will not be allowed. Please recreate the items first before re-grouping the records. '); 
           END IF;             
            
           GIUW_POL_DIST_FINAL_PKG.check_missing_dist_rec_item (p_dist_no, p_policy_id , v_err_exists );
           IF v_err_exists = 'Y' THEN
                RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#There are missing distribution records. Please recreate the items before re-grouping the items.'); 
           END IF;             
           
        ELSIF UPPER(p_module_id) = 'GIUWS018' AND UPPER(p_action) IN ('NEW_GROUP','JOIN_GROUP') THEN
 
           GIUW_POL_DIST_FINAL_PKG.check_regrp_by_item (p_dist_no, v_err_exists );
           IF v_err_exists = 'Y' THEN
                RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#The distribution record has been grouped by item which created multiple distribution groups for particular item/peril of the bill group. Re-grouping of distribution records per peril will not be allowed. Please recreate the items first before re-grouping the records. '); 
           END IF; 
           
           GIUW_POL_DIST_FINAL_PKG.check_missing_dist_rec_peril (p_dist_no, p_policy_id , v_err_exists );
           IF v_err_exists = 'Y' THEN
                RAISE_APPLICATION_ERROR (-20003 , 'Geniisys Exception#E#There are missing distribution records. Please recreate the items before re-grouping the items.'); 
           END IF;                 
       
       END IF;
           
     
    END validate_setup_dist_per_action; 
    
    PROCEDURE check_non_existing_basc_perl (
      p_policy_id       IN gipi_polbasic.policy_id%TYPE,
      p_result          OUT VARCHAR2
    )
    IS
    /** ====================================================================================================
    **  Created by : Jhing Factor 12.04.2014 
    **  Purpose    : This procedure check if there are any records in gipi_itmperil which references 
    **               a non-existing basic peril.
    ** ================================================================================================== */
    v_error      VARCHAR2(1) := 'N'; 
    BEGIN
    
        FOR cur in (SELECT distinct b.line_cd , b.peril_cd , b.basc_perl_cd
                          FROM gipi_itmperil a, giis_peril b
                         WHERE a.policy_id = p_policy_id
                           AND a.line_cd = b.line_cd
                           AND a.peril_cd = b.peril_cd
                           AND b.peril_type = 'A'
                           AND b.basc_perl_cd IS NOT NULL
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM giis_peril c
                                   WHERE c.line_cd = b.line_cd
                                     AND c.peril_cd = b.basc_perl_cd))
        LOOP
            v_error := 'Y';
            EXIT;            
        END LOOP; 
        
        p_result := v_error ; 
    
    END check_non_existing_basc_perl; 
    
    PROCEDURE check_missing_dist_rec_item (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_policy_id       IN gipi_polbasic.policy_id%TYPE,
      p_result          OUT VARCHAR2
    )
    IS
     /** ====================================================================================================
    **  Created by : Jhing Factor 12.04.2014
    **  Purpose    : This procedure will check if there are missing records between gipi_itmperil and 
    **               GIUW_WITEMDS. 
    ** ================================================================================================== */
    v_redist_flag   VARCHAR2(1) := 'N'; 
    v_max_takeup    giuw_pol_dist.takeup_seq_no%TYPE;
    v_error         VARCHAR2(1) := 'N'; 
    v_discrep       VARCHAR2(1) := 'N';
    v_tsi_amt       giuw_wperilds.tsi_amt%TYPE;
    v_prem_amt      giuw_wperilds.prem_amt%TYPE; 
    v_exists        varchar2(1);
    v_posted_bndr   VARCHAR2(1); 
    BEGIN
    
        v_posted_bndr := 'N';
        FOR curbinder IN ( SELECT 1 
                            FROM giri_distfrps 
                                  WHERE dist_no = p_dist_no )
        LOOP
            v_posted_bndr := 'Y';
            EXIT;
        END LOOP;
        
        
        IF v_posted_bndr = 'N' THEN 
    
            -- check if the policy has been redistributed 
            FOR cur in (SELECT 1 
                            FROM giuw_pol_dist
                                WHERE policy_id = p_policy_id
                                    AND dist_flag = '5' )
            LOOP        
                v_redist_flag := 'Y'; 
                EXIT;
            END LOOP;
            
            
            -- get the maximum takeup seq no to identify if the policy has multiple takeups 
            FOR cur2 in (SELECT NVL(MAX(takeup_seq_no),1) max_takeup 
                            FROM giuw_pol_dist 
                                WHERE policy_id = p_policy_id )
            LOOP
                v_max_takeup := cur2.max_takeup ;
                EXIT;
            END LOOP;
            
            
            -- for now only check the non-redistributed, single takeup policies. For long term and redistributed check the TSI only. 
            IF v_redist_flag <> 'Y' AND v_max_takeup = 1 THEN            
       
                FOR curitmperil IN (SELECT   a.item_no, SUM (DECODE( b.peril_type, 'B', NVL(a.tsi_amt,0), 0 )) tsi_amt,
                                             SUM (NVL(a.prem_amt,0)) prem_amt, SUM (NVL(a.ann_tsi_amt,0)) ann_tsi_amt
                                        FROM gipi_itmperil a, giis_peril b 
                                       WHERE a.policy_id = p_policy_id
                                        AND a.line_cd = b.line_cd
                                        AND a.peril_cd = b.peril_cd
                                    GROUP BY a.item_no
                                    ORDER BY a.item_no )
                LOOP
                     v_discrep := 'N'; 
                     v_tsi_amt := 0 ;
                     v_prem_amt := 0 ; 
                     FOR curdist IN (SELECT   a.item_no , SUM (NVL (a.tsi_amt, 0)) tsi_amt,
                                             SUM (NVL (a.prem_amt, 0)) prem_amt,
                                             SUM (NVL (a.ann_tsi_amt, 0)) ann_tsi_amt
                                        FROM giuw_witemds a
                                       WHERE a.dist_no = p_dist_no
                                        AND a.item_no = curitmperil.item_no
                                    GROUP BY a.item_no)
                     LOOP

                             v_tsi_amt := curdist.tsi_amt ;
                             v_prem_amt := curdist.prem_amt ; 
                            EXIT;                            
                        
                     END LOOP;
                
                     v_exists := 'N';
                     FOR cur in (SELECT 1 
                                     FROM giuw_witemds a
                                     WHERE a.dist_no = p_dist_no
                                       AND a.item_no = curitmperil.item_no )
                     LOOP
                        v_exists := 'Y';
                        EXIT;
                     END LOOP; 
                
                      IF ((curitmperil.tsi_amt <> v_tsi_amt 
                           OR curitmperil.prem_amt <> v_prem_amt) OR v_exists = 'N' ) THEN                            
                                    v_discrep := 'Y';                             
                      END IF;
                      
                      IF v_discrep = 'Y' THEN
                        exit;
                      END IF;
                END LOOP;   
                
                IF v_discrep = 'Y' THEN
                    v_error := 'Y';
                END IF; 
            ELSE
               -- for now let's validate the TSI for long term and redistributed. After the saving and recreation, premium would be corrected. It is just important
               -- to ensure there are no missing records in GIUW_WPERILDS in comparison with GIPI_ITMPERIL 
     
               FOR curitmperil IN (SELECT   a.item_no, SUM (DECODE( b.peril_type, 'B', NVL(a.tsi_amt,0), 0 )) tsi_amt,
                                             SUM (NVL(a.prem_amt,0)) prem_amt, SUM (NVL(a.ann_tsi_amt,0)) ann_tsi_amt
                                        FROM gipi_itmperil a, giis_peril b 
                                       WHERE a.policy_id = p_policy_id
                                        AND a.line_cd = b.line_cd
                                        AND a.peril_cd = b.peril_cd
                                    GROUP BY a.item_no
                                    ORDER BY a.item_no)
                LOOP
                     v_discrep := 'N'; 
                     v_tsi_amt := 0 ;
                     v_prem_amt := 0 ; 
                     FOR curdist IN (SELECT   a.item_no , SUM (NVL (a.tsi_amt, 0)) tsi_amt,
                                             SUM (NVL (a.prem_amt, 0)) prem_amt,
                                             SUM (NVL (a.ann_tsi_amt, 0)) ann_tsi_amt
                                        FROM giuw_witemds a
                                       WHERE a.dist_no = p_dist_no
                                        AND a.item_no = curitmperil.item_no
                                    GROUP BY a.item_no)
                     LOOP

                             v_tsi_amt := curdist.tsi_amt ;
                             v_prem_amt := curdist.prem_amt ; 
                            EXIT;                            
                        
                     END LOOP;

                     v_exists := 'N';
                     FOR cur in (SELECT 1 
                                     FROM giuw_witemds a
                                     WHERE a.dist_no = p_dist_no
                                       AND a.item_no = curitmperil.item_no )
                     LOOP
                        v_exists := 'Y';
                        EXIT;
                     END LOOP;            
                
                
                     IF ( ( curitmperil.tsi_amt <> v_tsi_amt )OR v_exists = 'N' )   THEN                            
                         v_discrep := 'Y';                             
                     END IF;
                      
                     IF v_discrep = 'Y' THEN
                        EXIT;
                     END IF;
                END LOOP;   
                
                IF v_discrep = 'Y' THEN
                    v_error := 'Y';
                END IF; 
               
            END IF;             
       END IF;
       p_result := v_error;    
    END check_missing_dist_rec_item; 

    PROCEDURE check_missing_dist_rec_peril (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_policy_id       IN gipi_polbasic.policy_id%TYPE,
      p_result          OUT VARCHAR2
    )
    IS
     /** ====================================================================================================
    **  Created by : Jhing Factor 12.04.2014
    **  Purpose    : This procedure will check if there are missing records between gipi_itmperil and 
    **               GIUW_WITEMDS. 
    ** ================================================================================================== */
    v_redist_flag   VARCHAR2(1) := 'N'; 
    v_max_takeup    giuw_pol_dist.takeup_seq_no%TYPE;
    v_error         VARCHAR2(1) := 'N'; 
    v_discrep       VARCHAR2(1) := 'N';
    v_tsi_amt       giuw_wperilds.tsi_amt%TYPE;
    v_prem_amt      giuw_wperilds.prem_amt%TYPE; 
    v_exists        VARCHAR2(1); 
    v_posted_bndr   VARCHAR2(1);
    BEGIN
    
            
        v_posted_bndr := 'N';
        FOR curbinder IN ( SELECT 1 
                            FROM giri_distfrps 
                                  WHERE dist_no = p_dist_no )
        LOOP
            v_posted_bndr := 'Y';
            EXIT;
        END LOOP;
        
        IF v_posted_bndr = 'N' THEN     
    
            -- check if the policy has been redistributed 
            FOR cur in (SELECT 1 
                            FROM giuw_pol_dist
                                WHERE policy_id = p_policy_id
                                    AND dist_flag = '5' )
            LOOP        
                v_redist_flag := 'Y'; 
                EXIT;
            END LOOP;
            
            
            -- get the maximum takeup seq no to identify if the policy has multiple takeups 
            FOR cur2 in (SELECT NVL(MAX(takeup_seq_no),1) max_takeup 
                            FROM giuw_pol_dist 
                                WHERE policy_id = p_policy_id )
            LOOP
                v_max_takeup := cur2.max_takeup ;
                EXIT;
            END LOOP;
            
            
            -- for now only check the non-redistributed, single takeup policies. For long term and redistributed check the TSI only. 
            IF v_redist_flag <> 'Y' AND v_max_takeup = 1 THEN            
       
                FOR curitmperil IN (SELECT   a.line_cd, a.peril_cd, SUM (a.tsi_amt) tsi_amt,
                                             SUM (a.prem_amt) prem_amt, SUM (a.ann_tsi_amt) ann_tsi_amt
                                        FROM gipi_itmperil a
                                       WHERE a.policy_id = p_policy_id
                                    GROUP BY a.line_cd, a.peril_cd
                                    ORDER BY a.line_cd, a.peril_cd)
                LOOP
                     v_discrep := 'N'; 
                     v_tsi_amt := 0 ;
                     v_prem_amt := 0 ; 
                     FOR curdist IN (SELECT   a.line_cd, a.peril_cd, SUM (NVL (a.tsi_amt, 0)) tsi_amt,
                                             SUM (NVL (a.prem_amt, 0)) prem_amt,
                                             SUM (NVL (a.ann_tsi_amt, 0)) ann_tsi_amt
                                        FROM giuw_wperilds a
                                       WHERE a.dist_no = p_dist_no
                                        AND a.line_cd = curitmperil.line_cd
                                        AND a.peril_cd = curitmperil.peril_cd
                                    GROUP BY a.line_cd, a.peril_cd)
                        LOOP

                             v_tsi_amt := curdist.tsi_amt ;
                             v_prem_amt := curdist.prem_amt ; 
                            EXIT;                            
                        
                        END LOOP;
                
                     v_exists := 'N';
                     FOR cur in (SELECT 1 
                                     FROM giuw_wperilds a
                                     WHERE a.dist_no = p_dist_no
                                       AND a.line_cd = curitmperil.line_cd
                                       AND a.peril_cd = curitmperil.peril_cd )
                     LOOP
                        v_exists := 'Y';
                        EXIT;
                     END LOOP;             
                
                      IF ((curitmperil.tsi_amt <> v_tsi_amt 
                           OR curitmperil.prem_amt <> v_prem_amt) OR v_exists = 'N' ) THEN                            
                                    v_discrep := 'Y';                             
                      END IF;
                      
                      IF v_discrep = 'Y' THEN
                        exit;
                      END IF;
                END LOOP;   
                
                IF v_discrep = 'Y' THEN
                    v_error := 'Y';
                END IF; 
            ELSE
               -- for now let's validate the TSI for long term and redistributed. After the saving and recreation, premium would be corrected. It is just important
               -- to ensure there are no missing records in GIUW_WPERILDS in comparison with GIPI_ITMPERIL 
     
               FOR curitmperil IN (SELECT   a.line_cd, a.peril_cd, SUM (a.tsi_amt) tsi_amt,
                                             SUM (a.prem_amt) prem_amt, SUM (a.ann_tsi_amt) ann_tsi_amt
                                        FROM gipi_itmperil a
                                       WHERE a.policy_id = p_policy_id
                                    GROUP BY a.line_cd, a.peril_cd
                                    ORDER BY a.line_cd, a.peril_cd)
                LOOP
                     v_discrep := 'N'; 
                     v_tsi_amt := 0 ;
                     v_prem_amt := 0 ; 
                     FOR curdist IN (SELECT   a.line_cd, a.peril_cd, SUM (NVL (a.tsi_amt, 0)) tsi_amt,
                                             SUM (NVL (a.prem_amt, 0)) prem_amt,
                                             SUM (NVL (a.ann_tsi_amt, 0)) ann_tsi_amt
                                        FROM giuw_wperilds a
                                       WHERE a.dist_no = p_dist_no
                                        AND a.line_cd = curitmperil.line_cd
                                        AND a.peril_cd = curitmperil.peril_cd
                                    GROUP BY a.line_cd, a.peril_cd)
                        LOOP

                             v_tsi_amt := curdist.tsi_amt ;
                             v_prem_amt := curdist.prem_amt ; 
                            EXIT;                            
                        
                        END LOOP;

                     v_exists := 'N';
                     FOR cur in (SELECT 1 
                                     FROM giuw_wperilds a
                                     WHERE a.dist_no = p_dist_no
                                       AND a.line_cd = curitmperil.line_cd
                                       AND a.peril_cd = curitmperil.peril_cd )
                     LOOP
                        v_exists := 'Y';
                        EXIT;
                     END LOOP;             
                
                     IF ( ( curitmperil.tsi_amt <> v_tsi_amt) OR v_exists = 'N' ) THEN                            
                         v_discrep := 'Y';                             
                     END IF;
                      
                     IF v_discrep = 'Y' THEN
                        exit;
                     END IF;
                END LOOP;   
                
                IF v_discrep = 'Y' THEN
                    v_error := 'Y';
                END IF; 
               
            END IF;     
        END IF;    
    
        p_result := v_error;
    
    END check_missing_dist_rec_peril;    
    PROCEDURE check_regrp_by_item (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_result          OUT VARCHAR2
    )
    IS
     /** ====================================================================================================
    **  Created by : Jhing Factor 12.04.2014 
    **  Purpose    : This procedure will check if the record has been grouped by item.
    ** ================================================================================================== */
     v_error varchar2(1) := 'N';
    BEGIN
    
        FOR cur IN (SELECT   b.item_grp, COUNT (DISTINCT a.dist_seq_no) cnt
                        FROM giuw_witemds a, giuw_wpolicyds b
                       WHERE a.dist_no = p_dist_no
                         AND a.dist_no = b.dist_no
                         AND a.dist_seq_no = b.dist_seq_no
                         AND NOT EXISTS (SELECT   x.item_no, COUNT (DISTINCT x.dist_seq_no) cnt
                                             FROM giuw_witemds x
                                            WHERE x.dist_no = p_dist_no
                                         GROUP BY x.item_no
                                           HAVING COUNT (DISTINCT x.dist_seq_no) > 1)
                    GROUP BY b.item_grp
                      HAVING COUNT (DISTINCT a.dist_seq_no) > 1)
        LOOP
            v_error := 'Y';
            EXIT;        
        END LOOP; 
       
        p_result := v_error;
    
    END check_regrp_by_item;      
      
    PROCEDURE check_regrp_by_peril (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_result          OUT VARCHAR2
    )
    IS
    /** ====================================================================================================
    **  Created by : Jhing Factor 11.28.2014
    **  Purpose    : This procedure will check if the record has been grouped by peril.
    ** ================================================================================================== */
     v_error varchar2(1) := 'N';
    BEGIN
    
        FOR cur IN (SELECT   a.item_no, COUNT (DISTINCT a.dist_seq_no) cnt
                            FROM giuw_witemds a
                           WHERE a.dist_no = p_dist_no
                        GROUP BY a.item_no
                          HAVING COUNT (DISTINCT a.dist_seq_no) > 1)
        LOOP
            v_error := 'Y';
            EXIT;        
        END LOOP; 
       
        p_result := v_error; 
    END check_regrp_by_peril;
    
    
    PROCEDURE val_sequential_distGrp (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_module_id       IN giis_modules.module_id%TYPE,
      p_result          OUT VARCHAR2
    )
    IS
    /** ====================================================================================================
    **  Created by : Jhing Factor  12.10.2014
    **  Purpose    : This procedure will if the generated dist seq no is sequential
    ** ================================================================================================== */
    
    v_dist_seq_no giuw_wpolicyds.dist_seq_no%TYPE := 0 ; 
    v_error varchar2(1) := 'N'; 
    BEGIN

        IF p_module_id = 'GIUWS010' THEN
            v_dist_seq_no := 0 ; 
            FOR cur IN (SELECT DISTINCT dist_seq_no
                           FROM giuw_witemds
                          WHERE dist_no = p_dist_no
                       ORDER BY dist_seq_no)
            LOOP
                v_dist_seq_no := v_dist_seq_no + 1 ;
                
                IF cur.dist_seq_no <> v_dist_seq_no THEN
                    v_error := 'Y';
                    EXIT;
                END IF;
            
            END LOOP;
        
        ELSIF p_module_id = 'GIUWS018' THEN
            v_dist_seq_no := 0 ; 
            FOR cur IN (SELECT DISTINCT dist_seq_no
                           FROM giuw_wperilds
                          WHERE dist_no = p_dist_no
                       ORDER BY dist_seq_no)
            LOOP
                v_dist_seq_no := v_dist_seq_no + 1 ;
                
                IF cur.dist_seq_no <> v_dist_seq_no THEN
                    v_error := 'Y';
                    EXIT;
                END IF;
            
            END LOOP;        
        END IF; 
        
        p_result := v_error; 
      
    
    END ;      
         
    PROCEDURE val_multipleBillGrp_perDist (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_policy_id       IN gipi_polbasic.policy_id%TYPE,
      p_result          OUT VARCHAR2
    )
    IS
    /** ====================================================================================================
    **  Created by : Jhing Factor 11.28.2014
    **  Purpose    : This procedure will check if multiple bill groups were grouped into a single distribution group.
    ** ================================================================================================== */
     v_error varchar2(1) := 'N';
    BEGIN
    
        FOR cur IN (SELECT   b.dist_seq_no, COUNT (DISTINCT a.item_grp) cnt_itemgrp
                        FROM gipi_item a, giuw_witemds b
                       WHERE a.policy_id = p_policy_id AND b.dist_no = p_dist_no
                             AND a.item_no = b.item_no
                    GROUP BY b.dist_seq_no
                      HAVING COUNT (DISTINCT a.item_grp) > 1)
        LOOP
            v_error := 'Y';
            EXIT;        
        END LOOP; 
       
        p_result := v_error; 
    END val_multipleBillGrp_perDist; 
	--added by robert 10.13.15 GENQA 5053
	FUNCTION check_peril_dist (
      p_dist_no       IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   IN   VARCHAR2
    )
      RETURN BOOLEAN
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR c1 IN (SELECT dist_seq_no, item_no, line_cd, share_cd
                   FROM giuw_witemds_dtl
                  WHERE dist_no = p_dist_no
                    AND dist_seq_no = p_dist_seq_no --added by robert SR 21734 02.17.16
                    AND dist_tsi = 0 --added by robert SR 21734 02.17.16
					ORDER BY dist_seq_no, item_no)
      LOOP
         FOR c2 IN (SELECT 'A'
                      FROM giuw_witemperilds_dtl a, giis_peril b
                     WHERE a.peril_cd = b.peril_cd
                       AND a.line_cd = b.line_cd
                       AND b.peril_type = 'B'
                       AND a.dist_tsi = 0
                       AND a.share_cd = c1.share_cd
                       AND a.line_cd = c1.line_cd
                       AND a.item_no = c1.item_no
                       AND a.dist_seq_no = c1.dist_seq_no
                       AND a.dist_no = p_dist_no)
         LOOP
            v_exist := 'Y';
            EXIT;
         END LOOP;

         IF v_exist = 'N'
         THEN
            FOR c3 IN (SELECT 1
                         FROM giuw_witemperilds_dtl a,
                              giis_peril b,
                              giis_dist_share c
                        WHERE c.share_cd = a.share_cd
                          AND c.line_cd = a.line_cd
                          AND a.peril_cd = b.peril_cd
                          AND a.line_cd = b.line_cd
                          AND b.peril_type = 'A'
                          AND a.share_cd = c1.share_cd
                          AND a.line_cd = c1.line_cd
                          AND a.item_no = c1.item_no
                          AND a.dist_seq_no = c1.dist_seq_no
                          AND a.dist_no = p_dist_no)
            LOOP
               RETURN (TRUE);
            END LOOP;
         END IF;
      END LOOP;

      RETURN (FALSE);
   END check_peril_dist;
	
END GIUW_POL_DIST_FINAL_PKG;
/


