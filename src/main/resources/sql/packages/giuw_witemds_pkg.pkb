CREATE OR REPLACE PACKAGE BODY CPI.GIUW_WITEMDS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_witemds (p_dist_no 	GIUW_WITEMDS.dist_no%TYPE)
	IS
	BEGIN
		DELETE   GIUW_WITEMDS
		 WHERE   dist_no  =  p_dist_no;
	END del_giuw_witemds;
    
	/*
	**  Created by		: Jerome Orio 
	**  Date Created 	: 04.28.2011
	**  Reference By 	: (GIUWS001 - Set-up Groups for Preliminary Distribution)
	**  Description 	: Delete procedure of the table
	*/
	PROCEDURE del_giuw_witemds(
        p_dist_no 	        GIUW_WITEMDS.dist_no%TYPE,
        p_dist_seq_no       GIUW_WITEMDS.dist_seq_no%TYPE
        ) IS
	BEGIN
        DELETE GIUW_WITEMDS
		 WHERE dist_no =  p_dist_no
           AND dist_seq_no = p_dist_seq_no;  
	END del_giuw_witemds;    
    
    
	/*
	**  Created by		:  Jhing Factor
	**  Date Created 	: 12.01.2014 
	**  Reference By 	: (GIUWS010 - ITEM SET-UP
	**  Description 	: Delete procedure of the table per item_no
	*/
	PROCEDURE del_giuw_witemds(
        p_dist_no 	        GIUW_WITEMDS.dist_no%TYPE,
        p_dist_seq_no       GIUW_WITEMDS.dist_seq_no%TYPE,
        p_item_no           GIUW_WITEMDS.item_no%TYPE
        ) IS
	BEGIN
        DELETE GIUW_WITEMDS
		 WHERE dist_no =  p_dist_no
           AND dist_seq_no = p_dist_seq_no
           AND item_no = p_item_no ;  
	END del_giuw_witemds;        
    
	/*
	**  Created by		: Jerome Orio 
	**  Date Created 	: 04.12.2011
	**  Reference By 	: (GIUWS001 - Set-up Groups for Preliminary Distribution)
	**  Description 	: Gets GIUW_WITEMDS details of specified distribution number 
	*/    
    FUNCTION get_giuw_witemds(
        p_par_id    gipi_wpolbas.par_id%TYPE, 
        p_dist_no 	GIUW_WITEMDS.dist_no%TYPE)
    RETURN giuw_witemds_tab PIPELINED IS
      v_list        giuw_witemds_type;
    BEGIN
        FOR i IN (SELECT a.dist_no,     a.dist_seq_no,
                         a.item_no,     a.tsi_amt,
                         a.prem_amt,    a.ann_tsi_amt,
                         a.arc_ext_data
                    FROM giuw_witemds a
                   WHERE a.dist_no = p_dist_no
                   ORDER BY item_no, dist_seq_no)
        LOOP
            v_list.dist_no          := i.dist_no;
            v_list.dist_seq_no      := i.dist_seq_no;
            v_list.item_no          := i.item_no;
            v_list.tsi_amt          := i.tsi_amt;
            v_list.prem_amt         := i.prem_amt;
            v_list.ann_tsi_amt      := i.ann_tsi_amt;
            v_list.arc_ext_data     := i.arc_ext_data;
            
            FOR c1 IN (SELECT item_title      , item_desc , pack_line_cd , 
                              pack_subline_cd , item_grp  , currency_cd  ,
                              currency_rt     , ann_tsi_amt
                         FROM gipi_witem
                        WHERE item_no = i.item_no
                          AND par_id  = p_par_id)
            LOOP
                v_list.nbt_item_title      :=  c1.item_title;
                v_list.nbt_item_desc       :=  c1.item_desc;
                v_list.dsp_pack_line_cd    :=  c1.pack_line_cd;
                v_list.dsp_pack_subline_cd :=  c1.pack_subline_cd;
                v_list.item_grp            :=  c1.item_grp;
                v_list.nbt_currency_cd     :=  c1.currency_cd;
                v_list.dsp_currency_rt     :=  c1.currency_rt;
                FOR c2 IN (SELECT short_name
                             FROM giis_currency
                            WHERE main_currency_cd = c1.currency_cd)
                LOOP
                	
                   v_list.dsp_short_name :=  c2.short_name;
                   EXIT;
                END LOOP;
                EXIT;
            END LOOP;

            /* Store the original value of the dist_seq_no
            ** for referential purposes.
            ** NOTE:  For more info, see comment property
            **        of item. */
            v_list.orig_dist_seq_no := i.dist_seq_no;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;    
    END;
    
	/*
	**  Created by		: Jerome Orio 
	**  Date Created 	: 04.28.2011
	**  Reference By 	: (GIUWS001 - Set-up Groups for Preliminary Distribution)
	**  Description 	: Insert/update records in giuw_witemds table 
	*/      
    PROCEDURE set_giuw_witemds(
        p_dist_no               giuw_witemds.dist_no%TYPE,     
        p_dist_seq_no           giuw_witemds.dist_seq_no%TYPE,
        p_item_no               giuw_witemds.item_no%TYPE,     
        p_tsi_amt               giuw_witemds.tsi_amt%TYPE,
        p_prem_amt              giuw_witemds.prem_amt%TYPE,    
        p_ann_tsi_amt           giuw_witemds.ann_tsi_amt%TYPE,
        p_arc_ext_data          giuw_witemds.arc_ext_data%TYPE,
        p_orig_dist_seq_no      giuw_witemds.dist_seq_no%TYPE,
        p_item_grp              giuw_wpolicyds.item_grp%TYPE
        ) IS
      v_exist   VARCHAR2(1) := 'N';  
    BEGIN
        MERGE INTO giuw_witemds
            USING dual ON (dist_no = p_dist_no
                       AND dist_seq_no = p_dist_seq_no
                       AND item_no = p_item_no)
            WHEN NOT MATCHED THEN
                INSERT(dist_no,     dist_seq_no,
                       item_no,     tsi_amt,
                       prem_amt,    ann_tsi_amt,
                       arc_ext_data)    
                VALUES(p_dist_no,     p_dist_seq_no,
                       p_item_no,     p_tsi_amt,
                       p_prem_amt,    p_ann_tsi_amt,
                       p_arc_ext_data)
            WHEN MATCHED THEN
                UPDATE SET
                       tsi_amt          = p_tsi_amt,
                       prem_amt         = p_prem_amt,    
                       ann_tsi_amt      = p_ann_tsi_amt,
                       arc_ext_data     = p_arc_ext_data;
        /*FOR i IN(SELECT 1
                    FROM giuw_witemds 
                   WHERE dist_no = p_dist_no
                     AND dist_seq_no = p_orig_dist_seq_no
                     AND item_no     = item_no
                     AND tsi_amt     = p_tsi_amt     
                     AND prem_amt    = p_prem_amt    
                     AND ann_tsi_amt = p_ann_tsi_amt)
        LOOP             
            v_exist := 'Y';
            EXIT;
        END LOOP;
                        
        IF v_exist =  'Y' THEN
          giuw_witemds_pkg.pre_update_giuw_witemds(
            p_dist_no, p_dist_seq_no, p_tsi_amt,
            p_prem_amt, p_ann_tsi_amt, p_item_grp);
          UPDATE giuw_witemds
          SET dist_seq_no      = p_dist_seq_no,
              tsi_amt          = p_tsi_amt,
              prem_amt         = p_prem_amt,    
              ann_tsi_amt      = p_ann_tsi_amt,
              arc_ext_data     = p_arc_ext_data
              WHERE dist_no = p_dist_no
                     AND dist_seq_no = p_orig_dist_seq_no
                     AND item_no     = item_no
                     AND tsi_amt     = p_tsi_amt     
                     AND prem_amt    = p_prem_amt    
                     AND ann_tsi_amt = p_ann_tsi_amt;
          giuw_witemds_pkg.post_update_giuw_witemds(
            p_dist_no, p_orig_dist_seq_no, p_tsi_amt, p_prem_amt, p_ann_tsi_amt);             
        ELSE
           INSERT INTO giuw_witemds
                      (dist_no,     dist_seq_no,
                       item_no,     tsi_amt,
                       prem_amt,    ann_tsi_amt,
                       arc_ext_data)    
                VALUES(p_dist_no,     p_dist_seq_no,
                       p_item_no,     p_tsi_amt,
                       p_prem_amt,    p_ann_tsi_amt,
                       p_arc_ext_data);
        END IF;             */
    END;
    
	/*
	**  Created by		: Jerome Orio 
	**  Date Created 	: 04.28.2011
	**  Reference By 	: (GIUWS001 - Set-up Groups for Preliminary Distribution)
	**  Description 	: Pre-update trigger in C150 block (giuw_witemds)
	*/     
    PROCEDURE pre_update_giuw_witemds(
        p_dist_no               giuw_witemds.dist_no%TYPE,     
        p_dist_seq_no           giuw_witemds.dist_seq_no%TYPE,   
        p_tsi_amt               giuw_witemds.tsi_amt%TYPE,
        p_prem_amt              giuw_witemds.prem_amt%TYPE,    
        p_ann_tsi_amt           giuw_witemds.ann_tsi_amt%TYPE,
        p_item_grp              giuw_wpolicyds.item_grp%TYPE
        ) IS
      CURSOR cur IS
                SELECT rowid , tsi_amt , prem_amt ,
                       ann_tsi_amt
                  FROM giuw_wpolicyds
                 WHERE dist_seq_no =  p_dist_seq_no
                   AND dist_no     =  p_dist_no
         FOR UPDATE OF tsi_amt, prem_amt, ann_tsi_amt;

      v_row     		cur%ROWTYPE;

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
         INSERT INTO  giuw_wpolicyds
                     (dist_no       , dist_seq_no       , dist_flag         ,
                      tsi_amt       , prem_amt          , ann_tsi_amt       ,
                      item_grp)
              VALUES (p_dist_no , p_dist_seq_no , 1             ,
                      p_tsi_amt , p_prem_amt    , p_ann_tsi_amt ,
                      p_item_grp);
      ELSE
         UPDATE giuw_wpolicyds
            SET tsi_amt     = v_row.tsi_amt     + p_tsi_amt ,
                prem_amt    = v_row.prem_amt    + p_prem_amt ,
                ann_tsi_amt = v_row.ann_tsi_amt + p_ann_tsi_amt
          WHERE rowid       = v_row.rowid;
      END IF;
      CLOSE cur;
    END;             
       
	/*
	**  Created by		: Jerome Orio 
	**  Date Created 	: 04.28.2011
	**  Reference By 	: (GIUWS001 - Set-up Groups for Preliminary Distribution)
	**  Description 	: Post-update trigger in C150 block (giuw_witemds)
	*/     
    PROCEDURE post_update_giuw_witemds(
        p_dist_no               giuw_witemds.dist_no%TYPE,     
        p_orig_dist_seq_no      giuw_witemds.dist_seq_no%TYPE,   
        p_tsi_amt               giuw_witemds.tsi_amt%TYPE,
        p_prem_amt              giuw_witemds.prem_amt%TYPE,    
        p_ann_tsi_amt           giuw_witemds.ann_tsi_amt%TYPE
        ) IS
    BEGIN
      /* Remove the current record from the DIST_SEQ_NO to
      ** which it originally belongs to, as the record 
      ** may have already been regrouped to some other
      ** DIST_SEQ_NO. */
 
      FOR c1 IN (SELECT rowid, tsi_amt , prem_amt ,
                        ann_tsi_amt
                   FROM giuw_wpolicyds
                  WHERE dist_seq_no = p_orig_dist_seq_no
                    AND dist_no     = p_dist_no
                 FOR UPDATE OF tsi_amt, prem_amt, ann_tsi_amt)
      LOOP
       --A.R.C. 12.28.2006
       --comment and replace by the code below
       /*IF c1.tsi_amt     != :c150.tsi_amt     AND
           c1.prem_amt    != :c150.prem_amt    AND
           c1.ann_tsi_amt != :c150.ann_tsi_amt THEN
           UPDATE giuw_wpolicyds
              SET tsi_amt     = c1.tsi_amt     - :c150.tsi_amt  ,
                  prem_amt    = c1.prem_amt    - :c150.prem_amt ,
                  ann_tsi_amt = c1.ann_tsi_amt - :c150.ann_tsi_amt
            WHERE rowid    = c1.rowid;
        ELSE
           DELETE giuw_wpolicyds
            --WHERE rowid = c1.rowid;
            where dist_no = c1.dist_no;
        END IF;*/

        IF c1.tsi_amt     = p_tsi_amt     AND
           c1.prem_amt    = p_prem_amt    AND
           c1.ann_tsi_amt = p_ann_tsi_amt THEN
           DELETE giuw_wpolicyds
            WHERE rowid = c1.rowid;
        ELSE
           UPDATE giuw_wpolicyds
              SET tsi_amt     = c1.tsi_amt     - p_tsi_amt  ,
                  prem_amt    = c1.prem_amt    - p_prem_amt ,
                  ann_tsi_amt = c1.ann_tsi_amt - p_ann_tsi_amt
            WHERE rowid    = c1.rowid;
        END IF;
        EXIT;
      END LOOP;
      
      /* NOTE:  For more info, see comment property of item. */
      --:c150.orig_dist_seq_no := :c150.dist_seq_no;
    END;        
    
    PROCEDURE DEL_AFFECTED_DIST_TABLES(p_dist_no     giuw_pol_dist.dist_no%TYPE) IS
      v_dist_no			giuw_pol_dist.dist_no%TYPE;
    BEGIN
      v_dist_no := p_dist_no;
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
      FOR c1 IN (SELECT frps_yy, frps_seq_no, line_cd -- jhing 12.02.2014 added line_cd 
                   FROM giri_wdistfrps
                  WHERE dist_no = v_dist_no)
      LOOP
        FOR c2 IN (SELECT pre_binder_id
                     FROM giri_wfrps_ri
                    WHERE frps_yy     = c1.frps_yy 
                      AND frps_seq_no = c1.frps_seq_no
                      AND line_cd = c1.line_cd /* jhing added line_cd */ ) 
        LOOP
          DELETE giri_wbinder_peril
           WHERE pre_binder_id = c2.pre_binder_id; 
          DELETE giri_wbinder
           WHERE pre_binder_id = c2.pre_binder_id;
        END LOOP;
        DELETE giri_wfrperil
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no
           AND line_cd = c1.line_cd /* jhing added line_cd */ ;
        DELETE giri_wfrps_ri
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no
           AND line_cd     = c1.line_cd /* jhing added line_cd */ ;
        -- jhing 12.02.2014 added delete to giri_wfrps_peril_grp
        DELETE giri_wfrps_peril_grp
         WHERE frps_yy     = c1.frps_yy
           AND frps_seq_no = c1.frps_seq_no
           AND line_cd     = c1.line_cd ;           
      END LOOP;
      DELETE giri_wdistfrps
       WHERE dist_no = v_dist_no;
    END;    
    
    PROCEDURE pre_commit_giuws(
        p_dist_no     giuw_pol_dist.dist_no%TYPE
        ) IS
    BEGIN
     GIUW_WITEMDS_PKG.DEL_AFFECTED_DIST_TABLES(p_dist_no);
     DELETE_DIST_WORKING_TABLES(p_dist_no);
     UPDATE giuw_wpolicyds
        SET dist_flag = '1'
      WHERE dist_no   = p_dist_no;
     UPDATE giuw_pol_dist
        SET dist_flag = '1'
      WHERE dist_no   = p_dist_no;
    END;      
    
    PROCEDURE RECREATE_GRP_DFLT_WPOLICYDS
             (p_dist_no				IN giuw_wpolicyds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		    IN giuw_wpolicyds_dtl.dist_seq_no%TYPE  ,
              p_line_cd				IN giuw_wpolicyds_dtl.line_cd%TYPE      ,
              p_dist_tsi			IN giuw_wpolicyds_dtl.dist_tsi%TYPE     ,
              p_dist_prem			IN giuw_wpolicyds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	    IN giuw_wpolicyds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count			IN OUT NUMBER                           ,
              p_default_type	    IN giis_default_dist.default_type%TYPE  ,
              p_currency_rt         IN gipi_witem.currency_rt%TYPE          ,
              p_par_id              IN gipi_parlist.par_id%TYPE             ,
              p_item_grp			IN gipi_witem.item_grp%TYPE,
              p_pol_flag            IN gipi_wpolbas.pol_flag%TYPE,
              p_par_type            IN gipi_parlist.par_type%TYPE,
              p_default_no       IN       giis_default_dist.default_no%TYPE) IS -- shan 07.22.2014

      --rg_id				RECORDGROUP;
      rg_name			VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_col1			VARCHAR2(40) := rg_name || '.line_cd';
      rg_col2			VARCHAR2(40) := rg_name || '.share_cd';
      rg_col3			VARCHAR2(40) := rg_name || '.share_pct';
      rg_col4			VARCHAR2(40) := rg_name || '.share_amt1';
      rg_col5			VARCHAR2(40) := rg_name || '.peril_cd';
      rg_col6			VARCHAR2(40) := rg_name || '.share_amt2';
      rg_col7			VARCHAR2(40) := rg_name || '.true_pct';
      v_remaining_tsi		 NUMBER       := p_dist_tsi * p_currency_rt;
      v_share_amt				 giis_default_dist_group.share_amt1%TYPE;
      v_peril_cd				 giis_default_dist_group.peril_cd%TYPE;
      v_prev_peril_cd		 giis_default_dist_group.peril_cd%TYPE;
      v_dist_spct				 giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_dist_tsi				 giuw_wpolicyds_dtl.dist_tsi%TYPE;
      v_dist_prem				 giuw_wpolicyds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi		 giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
      v_sum_dist_tsi		 giuw_wpolicyds_dtl.dist_tsi%TYPE     := 0;
      v_sum_dist_spct		 giuw_wpolicyds_dtl.dist_spct%TYPE    := 0;
      v_sum_dist_prem		 giuw_wpolicyds_dtl.dist_prem%TYPE    := 0;
      v_sum_ann_dist_tsi giuw_wpolicyds_dtl.ann_dist_tsi%TYPE := 0;
      v_share_cd				 giis_dist_share.share_cd%TYPE;
      v_use_share_amt2   VARCHAR2(1) := 'N';
      v_dist_spct_limit	 giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_dflt_policy_exists  BOOLEAN := FALSE;   --shan 07.22.2014
      v_dist_spct1          giuw_wpolicyds_dtl.DIST_SPCT1%type;     -- shan 07.22.2014

      PROCEDURE INSERT_TO_WPOLICYDS_DTL IS
      BEGIN
        INSERT INTO  giuw_wpolicyds_dtl
                    (dist_no     , dist_seq_no   , line_cd        ,
                     share_cd    , dist_spct     , dist_tsi       ,
                     dist_prem   , ann_dist_spct , ann_dist_tsi   ,
                     dist_grp
                     , dist_spct1)  -- shan 07.22.2014
             VALUES (p_dist_no   , p_dist_seq_no , p_line_cd      ,
                     v_share_cd  , v_dist_spct   , v_dist_tsi     ,
                     v_dist_prem , v_dist_spct   , v_ann_dist_tsi ,
                     1
                     ,v_dist_spct1);  -- shan 07.22.2014
      END;
      
      --added by shan 07.22.2014      
      PROCEDURE insert_dflt_values
      IS
      BEGIN 
            /* Create the default distribution records based on the 100%
            ** NET RETENTION and 0% FACULTATIVE hard code defaults. */
            v_share_cd := 1;
            v_dist_spct := 100;
            v_dist_tsi := p_dist_tsi;
            v_dist_prem := p_dist_prem;
            v_ann_dist_tsi := p_ann_dist_tsi;

            FOR c IN 1 .. 2
            LOOP
               insert_to_wpolicyds_dtl;
               v_share_cd := 999;
               v_dist_spct := 0;
               v_dist_tsi := 0;
               v_dist_prem := 0;
               v_ann_dist_tsi := 0;
            END LOOP;
      END;

    BEGIN
      IF p_rg_count = 0 THEN	
             -- rollie 27may2005 vincent's birthday
         -- see procedure create_items for other info
         --sg_alert('RECREATE_GRP_DFLT_WPOLICYDS '||p_dist_seq_no||' - '||:b240.par_id||NVL(variables.v_pol_flag,'ROLLIE'),'I',FALSE);
         IF p_pol_flag = '2' THEN -- renewal
                 --message('pol flag 2');pause;
                 /*FOR c IN (    -- commented out retrieving of default share from original policy for now : shan 
                   SELECT share_cd, dist_spct
                          , dist_spct1 -- shan 07.22.2014
                     FROM giuw_policyds_dtl a
                    WHERE a.dist_seq_no = p_dist_seq_no
                      AND dist_no = ( SELECT dist_no 
                                                                FROM GIUW_POL_DIST 
                                                                    WHERE dist_flag <> 4  --add by jess 02192019 - to handle ora-01427
                                                                  AND policy_id = ( SELECT old_policy_id 
                                                                                                    FROM GIPI_WPOLNREP
                                                                                                         WHERE par_id = p_par_id)))
                     LOOP     	
                   v_share_cd     := c.share_cd;
                   v_dist_spct    := c.dist_spct;
                   v_dist_spct1 := c.dist_spct1;    -- shan 07.22.2014
                   v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                   v_dist_prem        := ROUND (((p_dist_prem * NVL(c.dist_spct1, c.dist_spct)) / 100), 2); --ROUND(((p_dist_prem    * c.dist_spct)/ 100), 2);
                   v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                   v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                   v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                   v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);
                   --sg_alert('RECREATE_GRP_DFLT_WPOLICYDS '||p_dist_seq_no||' - '||:b240.par_id||' - '||c.share_cd||' - '||c.dist_spct,'I',FALSE);
                   INSERT_TO_WPOLICYDS_DTL;
    		       v_dflt_policy_exists := TRUE;    -- shan 07.22.2014
                     END LOOP;*/
                     
                    --added by shan 07.22.2014
                    IF v_dflt_policy_exists = FALSE THEN
                        insert_dflt_values;
                    END IF;
                    --end 07.22.2014
             ELSIF p_par_type = 'E' THEN
                     --message ('insert');pause;
    				 
                    /* FOR c IN (    -- commented out retrieving of default share from original policy for now : shan 
                   SELECT share_cd, dist_spct
                            , dist_spct1  -- shan 07.22.2014
                             FROM giuw_policyds_dtl a
                            WHERE a.dist_seq_no = p_dist_seq_no
                      AND dist_no = ( SELECT dist_no 
                                                                FROM GIUW_POL_DIST 
                                                                 WHERE dist_flag <> 4  --A.R.C. 12.28.2006
                                                                   AND par_id = ( SELECT par_id
                                                                                        FROM GIPI_POLBASIC
                                                                                                 WHERE endt_seq_no = 0
                                                                                                   AND (line_cd, 
                                                                                                                subline_cd, 
                                                                                                                    iss_cd, 
                                                                                                                    issue_yy, 
                                                                                                                    pol_seq_no,
                                                                                                                    renew_no) = (SELECT line_cd, 
                                                                                                                                                        subline_cd, 
                                                                                                                                                            iss_cd, 
                                                                                                                                                            issue_yy, 
                                                                                                                                                            pol_seq_no, 
                                                                                                                                                            renew_no
                                                                                                                                             FROM GIPI_WPOLBAS
                                                                                                                                            WHERE par_id = p_par_id))))
                     LOOP     	
                   v_share_cd     		:= c.share_cd;
                   v_dist_spct    		:= c.dist_spct;
                   v_dist_spct1         := c.dist_spct1;    -- shan 07.22.2014  
                   v_dist_tsi         := ROUND(((p_dist_tsi     * c.dist_spct)/ 100), 2);
                   v_dist_prem        := ROUND (((p_dist_prem * NVL(c.dist_spct1, c.dist_spct)) / 100), 2);  --ROUND(((p_dist_prem    * c.dist_spct1)/ 100), 2);
                   v_ann_dist_tsi     := ROUND(((p_ann_dist_tsi * c.dist_spct)/ 100), 2);
                   v_sum_dist_tsi     := NVL(v_sum_dist_tsi,0)     + NVL(v_dist_tsi,0);
                   v_sum_dist_prem    := NVL(v_sum_dist_prem,0)    + NVL(v_dist_prem,0);
                   v_sum_ann_dist_tsi := NVL(v_sum_ann_dist_tsi,0) + NVL(v_ann_dist_tsi,0);		       
                   INSERT_TO_WPOLICYDS_DTL;
                   v_dflt_policy_exists := TRUE;    -- shan 07.22.2014
                     END LOOP;			*/
                     
                    --added by shan 07.22.2014
                    IF v_dflt_policy_exists = FALSE THEN
                        insert_dflt_values;
                    END IF;
                    --end 07.22.2014
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

         /*rg_id := FIND_GROUP(rg_name);
         RESET_GROUP_SELECTION(rg_id);
         IF GET_GROUP_NUMBER_CELL(rg_col2, p_rg_count) = 999 THEN
            DELETE_GROUP_ROW(rg_id, p_rg_count);
            p_rg_count := p_rg_count - 1;
         END IF;*/
        -- uncommented out by shan : 07.22.2014
         -- Use AMOUNTS to create the default distribution records. 
         IF p_default_type = 1 THEN
            FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
                             a.share_amt1 , a.peril_cd , a.share_amt2 ,
                             1 true_pct 
                        FROM GIIS_DEFAULT_DIST_GROUP a  
                       WHERE a.default_no = TO_CHAR(NVL(p_default_no, 0))
                         AND a.line_cd    = p_line_cd
                         AND a.share_cd   <> 999
                       ORDER BY a.sequence ASC)
            LOOP
              v_peril_cd    := c.peril_cd;
              IF v_peril_cd IS NOT NULL THEN
                 IF NVL(v_prev_peril_cd, 0) = v_peril_cd THEN
                    NULL;
                 ELSE
                    v_use_share_amt2 := 'N';
                    FOR c1 IN (SELECT 'a'
                                 FROM gipi_witmperl B490, gipi_witem B480,
                                      giuw_witemds C150
                                WHERE B490.peril_cd    = v_peril_cd
                                  AND B490.line_cd     = p_line_cd
                                  AND B490.item_no     = B480.item_no
                                  AND B490.par_id      = B480.par_id
                                  AND B480.item_no     = C150.item_no
                                  AND B480.item_grp    = p_item_grp
                                  AND B480.par_id      = p_par_id
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
                 v_share_amt  := c.share_amt1;
              ELSE
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
              --SET_GROUP_NUMBER_CELL(rg_col7, c, v_dist_spct);
              GIUW_POL_DIST_PKG.v_share_pct_updated :=  TRUE;     -- shan 07.22.2014     
              --SET_GROUP_SELECTION(rg_id, c);          
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
               --ADD_GROUP_ROW(rg_id, END_OF_GROUP);
               --SET_GROUP_NUMBER_CELL(rg_col2, p_rg_count, 999);
               --SET_GROUP_NUMBER_CELL(rg_col7, p_rg_count, v_dist_spct);
               GIUW_POL_DIST_PKG.v_share_pct_updated :=  TRUE;     -- shan 07.22.2014     
               --SET_GROUP_SELECTION(rg_id, p_rg_count);
               INSERT_TO_WPOLICYDS_DTL;
            END IF;

         --Use PERCENTAGES to create the default distribution records. 
         ELSIF p_default_type = 2 THEN
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
              /*SET_GROUP_NUMBER_CELL(rg_col7, c, v_dist_spct);
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
        -- */
        -- NULL;
      END IF;   
    END;    
    
    PROCEDURE RECREATE_GRP_DFLT_DIST(p_dist_no        IN giuw_wpolicyds.dist_no%TYPE,
                                     p_dist_seq_no    IN giuw_wpolicyds.dist_seq_no%TYPE,
                                     p_dist_flag      IN giuw_wpolicyds.dist_flag%TYPE,
                                     p_policy_tsi     IN giuw_wpolicyds.tsi_amt%TYPE,
                                     p_policy_premium IN giuw_wpolicyds.prem_amt%TYPE,
                                     p_policy_ann_tsi IN giuw_wpolicyds.ann_tsi_amt%TYPE,
                                     p_item_grp       IN giuw_wpolicyds.item_grp%TYPE,
                                     p_line_cd        IN giis_line.line_cd%TYPE,
                                     p_rg_count       IN OUT NUMBER,
                                     p_default_type   IN giis_default_dist.default_type%TYPE,
                                     p_currency_rt    IN gipi_witem.currency_rt%TYPE,
                                     p_par_id         IN gipi_parlist.par_id%TYPE,
                                     p_c150_item_grp  IN giuw_wpolicyds.item_grp%TYPE,
                                     p_pol_flag       IN gipi_wpolbas.pol_flag%TYPE,
                                     p_par_type       IN gipi_parlist.par_type%TYPE,
                                     p_default_no	  IN giis_default_dist.default_no%TYPE) IS


    dist_cnt			        number;
    dist_max			        giuw_pol_dist.dist_no%type;
    v_giuw_witemperilds_upd     VARCHAR2(1) := 'N'; --nok
    v_giuw_wperilds_upd         VARCHAR2(1) := 'N'; --nok
    BEGIN
            SELECT count(dist_no), max(dist_no)
          INTO dist_cnt, dist_max
          FROM giuw_pol_dist
         WHERE par_id = p_par_id
           AND item_grp = NVL(p_c150_item_grp,p_item_grp);
    	
        IF dist_cnt = 0 AND dist_max IS NULL THEN
        BEGIN
            SELECT count(dist_no), max(dist_no)
                INTO dist_cnt, dist_max
                FROM giuw_pol_dist
                 WHERE par_id = p_par_id
                 AND item_grp IS NULL;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                null;
        END;
      END IF;
        /* Create records in table GIUW_WPOLICYDS_DTL
        ** for the specified DIST_SEQ_NO. */
        GIUW_WITEMDS_PKG.RECREATE_GRP_DFLT_WPOLICYDS
                    (p_dist_no    , p_dist_seq_no    , p_line_cd        ,
                     p_policy_tsi , p_policy_premium , p_policy_ann_tsi ,
                     p_rg_count   , p_default_type   , p_currency_rt    ,
                     p_par_id     , p_item_grp       , p_pol_flag       ,
                     p_par_type
                     , p_default_no);   -- shan 07.22.2014
        /* Get the amounts for each item in table GIUW_WITEMDS in preparation
        ** for data insertion to its corresponding detail distribution table. */
        FOR c2 IN (SELECT item_no     , tsi_amt , prem_amt ,
                          ann_tsi_amt
                     FROM giuw_witemds
                    WHERE dist_seq_no = p_dist_seq_no
                      AND dist_no     = p_dist_no)
        LOOP
          /* Create records in table GIUW_WITEMDS_DTL
          ** for the specified DIST_SEQ_NO. */
          GIUW_POL_DIST_PKG.CREATE_GRP_DFLT_WITEMDS2
                      (p_dist_no      , p_dist_seq_no , c2.item_no  ,
                       p_line_cd      , c2.tsi_amt    , c2.prem_amt ,
                       c2.ann_tsi_amt , p_rg_count, p_pol_flag,
                       p_par_id, p_par_type, p_default_no);
          /* Get the amounts for each combination of the ITEM_NO and the PERIL_CD
          ** in table GIPI_WITMPERL in preparation for data insertion to 
          ** distribution tables GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL. */
          FOR c3 IN (  SELECT B490.tsi_amt     itmperil_tsi     ,
                              B490.prem_amt    itmperil_premium ,
                              B490.ann_tsi_amt itmperil_ann_tsi ,
                              B490.peril_cd    peril_cd
                         FROM gipi_witmperl B490, gipi_witem B480
                        WHERE B490.item_no = B480.item_no
                          AND B490.par_id  = B480.par_id
                          AND B480.item_no = c2.item_no
                          AND B480.par_id  = p_par_id)
          LOOP
         		
            /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
            ** for the specified DIST_SEQ_NO. */
            IF p_dist_no = dist_max THEN
            c3.itmperil_tsi     := NVL(c3.itmperil_tsi,0) /*beth- (ROUND((NVL(c3.itmperil_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
                    c3.itmperil_premium	 	:= NVL(c3.itmperil_premium,0) - (ROUND((NVL(c3.itmperil_premium,0)/dist_cnt),2) * (dist_cnt - 1));
                c3.itmperil_ann_tsi := NVL(c3.itmperil_ann_tsi,0) /*beth- (ROUND((NVL(c3.itmperil_ann_tsi,0)/dist_cnt),2) * (dist_cnt - 1))*/;
                ELSE
                c3.itmperil_tsi     := ROUND((NVL(c3.itmperil_tsi,0)/*beth/dist_cnt*/),2);
                c3.itmperil_premium	 	:= ROUND((NVL(c3.itmperil_premium,0)/dist_cnt),2);
                c3.itmperil_ann_tsi := ROUND((NVL(c3.itmperil_ann_tsi,0)/*beth/dist_cnt*/),2);
                END IF;
                
              FOR c1 IN (SELECT rowid, tsi_amt , prem_amt ,
                                ann_tsi_amt
                           FROM giuw_witemperilds
                          WHERE dist_seq_no = p_dist_seq_no
                            AND dist_no     = p_dist_no
                            AND item_no     = c2.item_no
                            AND peril_cd    = c3.peril_cd
                         FOR UPDATE OF line_cd, tsi_amt, prem_amt, ann_tsi_amt)
              LOOP
                v_giuw_witemperilds_upd := 'Y';
                UPDATE giuw_witemperilds
                      SET line_cd     = p_line_cd  ,
                          tsi_amt     = c3.itmperil_tsi ,
                          prem_amt    = c3.itmperil_premium ,
                          ann_tsi_amt = c3.itmperil_ann_tsi
                    WHERE rowid    = c1.rowid;
                EXIT;
              END LOOP;
                
              IF v_giuw_witemperilds_upd <> 'Y' THEN
               INSERT INTO  giuw_witemperilds  
                        (dist_no             , dist_seq_no    , item_no         ,
                         peril_cd            , line_cd        , tsi_amt         ,
                         prem_amt            , ann_tsi_amt)
                 VALUES (p_dist_no           , p_dist_seq_no  , c2.item_no      ,
                         c3.peril_cd         , p_line_cd      , c3.itmperil_tsi , 
                         c3.itmperil_premium , c3.itmperil_ann_tsi);
              END IF;
                         
            GIUW_POL_DIST_PKG.CREATE_GRP_DFLT_WITEMPERILDS2
                        (p_dist_no           , p_dist_seq_no       , c2.item_no      ,
                         p_line_cd           , c3.peril_cd         , c3.itmperil_tsi ,
                        c3.itmperil_premium , c3.itmperil_ann_tsi , p_rg_count,
                        p_pol_flag, p_par_id, p_par_type, p_default_no);
          END LOOP;
        END LOOP;

        FOR c4 IN (  SELECT SUM(tsi_amt)     tsi_amt     ,
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
          FOR c1 IN (SELECT rowid, tsi_amt , prem_amt ,
                                ann_tsi_amt
                           FROM giuw_wperilds
                          WHERE dist_seq_no = p_dist_seq_no
                            AND dist_no     = p_dist_no
                            AND line_cd     = p_line_cd
                            AND peril_cd    = c4.peril_cd
                         FOR UPDATE OF tsi_amt, prem_amt, ann_tsi_amt)
              LOOP
                v_giuw_wperilds_upd := 'Y';
                UPDATE giuw_wperilds
                      SET tsi_amt      = c4.tsi_amt ,
                          prem_amt     = c4.prem_amt ,
                          ann_tsi_amt  = c4.ann_tsi_amt 
                    WHERE rowid    = c1.rowid;
                EXIT;
              END LOOP;
                
              IF v_giuw_wperilds_upd <> 'Y' THEN
              INSERT INTO  giuw_wperilds  
                      (dist_no    , dist_seq_no    , peril_cd    ,
                       line_cd    , tsi_amt        , prem_amt    ,
                       ann_tsi_amt)
               VALUES (p_dist_no  , p_dist_seq_no  , c4.peril_cd ,
                       p_line_cd  , c4.tsi_amt     , c4.prem_amt ,
                       c4.ann_tsi_amt);
              END IF; 
          
          GIUW_POL_DIST_pkg.CREATE_GRP_DFLT_WPERILDS2
                (p_dist_no      , p_dist_seq_no , p_line_cd   ,
                 c4.peril_cd    , c4.tsi_amt    , c4.prem_amt ,
                 c4.ann_tsi_amt , p_rg_count, p_pol_flag,
                 p_par_id, p_par_type, p_default_no);
        END LOOP; 
        GIUW_POL_DIST_pkg.UPDATE_DTLS_NO_SHARE_CD2(p_dist_no, p_dist_seq_no, p_line_cd);          
    END;        
    
    PROCEDURE RECREATE_PERIL_DFLT_DIST
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
                       p_currency_rt     IN gipi_witem.currency_rt%TYPE,
                       p_par_id          IN gipi_parlist.par_id%TYPE,
                       p_pol_flag        IN gipi_wpolbas.pol_flag%TYPE, 
                       p_par_type        IN gipi_parlist.par_type%TYPE) IS

      v_peril_cd                giis_peril.peril_cd%TYPE;
      v_peril_tsi				giuw_wperilds.tsi_amt%TYPE      := 0;
      v_peril_premium		    giuw_wperilds.prem_amt%TYPE     := 0;
      v_peril_ann_tsi		    giuw_wperilds.ann_tsi_amt%TYPE  := 0;
      v_exist			        VARCHAR2(1)                     := 'N';
      v_insert_sw			    VARCHAR2(1)                     := 'N';
      v_giuw_witemperilds_upd   VARCHAR2(1)                     := 'N'; --nok
      v_giuw_wperilds_upd       VARCHAR2(1)                     := 'N'; --nok
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
        GIUW_POL_DIST_PKG.CREATE_PERIL_DFLT_WPERILDS
              (p_dist_no       , p_dist_seq_no , p_line_cd       ,
               v_peril_cd      , v_peril_tsi   , v_peril_premium ,
               v_peril_ann_tsi , p_currency_rt , p_default_no    ,
               p_default_type  , p_dflt_netret_pct, p_pol_flag,
               p_par_id, p_par_type);
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
        FOR c3 IN (  SELECT B490.tsi_amt     itmperil_tsi     ,
                            B490.prem_amt    itmperil_premium ,
                            B490.ann_tsi_amt itmperil_ann_tsi ,
                            B490.item_no     item_no          ,
                            B490.peril_cd    peril_cd
                       FROM gipi_witmperl B490, gipi_witem B480,
                            giuw_witemds C150
                      WHERE B490.item_no     = B480.item_no
                        AND B490.par_id      = B480.par_id
                        AND C150.item_no     = B480.item_no
                        AND B480.item_grp    = p_item_grp
                        AND B480.par_id      = p_par_id
                        AND C150.dist_seq_no = p_dist_seq_no
                        AND C150.dist_no     = p_dist_no
                   ORDER BY B490.peril_cd)
        LOOP
          v_exist     := 'Y';

          /* Create records in table GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL
          ** for the specified DIST_SEQ_NO. */
          FOR c1 IN (SELECT rowid, tsi_amt , prem_amt ,
                            ann_tsi_amt
                       FROM giuw_witemperilds
                      WHERE dist_seq_no = p_dist_seq_no
                        AND dist_no     = p_dist_no
                        AND item_no     = c3.item_no
                        AND peril_cd    = c3.peril_cd
                     FOR UPDATE OF line_cd, tsi_amt, prem_amt, ann_tsi_amt)
          LOOP
            v_giuw_witemperilds_upd := 'Y';
            UPDATE giuw_witemperilds
                  SET line_cd     = p_line_cd  ,
                      tsi_amt     = c3.itmperil_tsi ,
                      prem_amt    = c3.itmperil_premium ,
                      ann_tsi_amt = c3.itmperil_ann_tsi
                WHERE rowid    = c1.rowid;
            EXIT;
          END LOOP;
            
          IF v_giuw_witemperilds_upd <> 'Y' THEN
          INSERT INTO  giuw_witemperilds  
                      (dist_no             , dist_seq_no   , item_no         ,
                       peril_cd            , line_cd       , tsi_amt         ,
                       prem_amt            , ann_tsi_amt)
               VALUES (p_dist_no           , p_dist_seq_no , c3.item_no      ,
                       c3.peril_cd         , p_line_cd     , c3.itmperil_tsi ,
                       c3.itmperil_premium , c3.itmperil_ann_tsi);
          END IF;
          
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
              FOR c1 IN (SELECT rowid, tsi_amt , prem_amt ,
                                ann_tsi_amt
                           FROM giuw_wperilds
                          WHERE dist_seq_no = p_dist_seq_no
                            AND dist_no     = p_dist_no
                            AND line_cd     = p_line_cd
                            AND peril_cd    = v_peril_cd
                         FOR UPDATE OF tsi_amt, prem_amt, ann_tsi_amt)
              LOOP
                v_giuw_wperilds_upd := 'Y';
                UPDATE giuw_wperilds
                      SET tsi_amt      = v_peril_tsi ,
                          prem_amt     = v_peril_premium ,
                          ann_tsi_amt  = v_peril_ann_tsi 
                    WHERE rowid    = c1.rowid;
                EXIT;
              END LOOP;
                
              IF v_giuw_wperilds_upd <> 'Y' THEN
              INSERT INTO  giuw_wperilds  
                         (dist_no   , dist_seq_no   , peril_cd         ,
                          line_cd   , tsi_amt       , prem_amt         ,
                          ann_tsi_amt)
                  VALUES (p_dist_no , p_dist_seq_no , v_peril_cd       ,
                          p_line_cd , v_peril_tsi   , v_peril_premium  ,
                          v_peril_ann_tsi);
              END IF;   
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
        GIUW_POL_DIST_PKG.CREATE_PERIL_DFLT_WITEMDS  (p_dist_no, p_dist_seq_no, p_pol_flag, p_par_id, p_par_type);

        /* Create records in table GIUW_WPOLICYDS_DTL based on
        ** the values inserted to table GIUW_WITEMDS_DTL. */
        CREATE_PERIL_DFLT_WPOLICYDS(p_dist_no, p_dist_seq_no);
        
        
        GIUW_POL_DIST_pkg.UPDATE_DTLS_NO_SHARE_CD2(p_dist_no, p_dist_seq_no, p_line_cd);
    END;    
    
    PROCEDURE CREATE_REGROUPED_DIST_RECS
             (p_dist_no       IN giuw_pol_dist.dist_no%TYPE    ,
              p_par_id        IN gipi_wpolbas.par_id%TYPE  ,
              p_line_cd       IN gipi_wpolbas.line_cd%TYPE    ,
              p_subline_cd    IN gipi_wpolbas.subline_cd%TYPE ,
              p_iss_cd        IN gipi_wpolbas.iss_cd%TYPE     ,
              p_pack_pol_flag IN gipi_wpolbas.pack_pol_flag%TYPE,
              p_c150_item_grp IN giuw_wpolicyds.item_grp%TYPE,
              p_pol_flag      IN gipi_wpolbas.pol_flag%TYPE,
              p_par_type      IN gipi_parlist.par_type%TYPE) IS

      v_line_cd					gipi_parlist.line_cd%TYPE;
      v_subline_cd			    gipi_wpolbas.subline_cd%TYPE;
      v_currency_rt			    gipi_witem.currency_rt%TYPE;
      v_dist_seq_no             giuw_wpolicyds.dist_seq_no%TYPE := 0;
      --rg_id				    RECORDGROUP;
      rg_name				    VARCHAR2(20) := 'DFLT_DIST_VALUES';
      rg_count					NUMBER := 0; -- Nica 04.24.2013 - initialize rg_count to zero
      v_exist				    VARCHAR2(1);
      v_errors					NUMBER;
      v_default_no			    giis_default_dist.default_no%TYPE;
      v_default_type		    giis_default_dist.default_type%TYPE;
      v_dflt_netret_pct         giis_default_dist.dflt_netret_pct%TYPE;
      v_dist_type				giis_default_dist.dist_type%TYPE;
      v_post_flag				VARCHAR2(1)  := 'O';
      v_package_policy_sw       VARCHAR2(1)  := 'Y';

    BEGIN
    
    -- jhing 04.06.2016 commented out whole code. Code produces erroneous default distrubution
    -- amounts REPUBLICFULLWEB 21797 
    
    
--      FOR c1 IN (SELECT dist_seq_no , tsi_amt  , prem_amt ,
--                        ann_tsi_amt , item_grp , rowid
--                   FROM giuw_wpolicyds
--                  WHERE dist_no = p_dist_no)
--      LOOP
--
--        FOR c2 IN (SELECT currency_rt , pack_line_cd , pack_subline_cd
--                     FROM gipi_witem
--                    WHERE item_grp = c1.item_grp
--                      AND par_id   = p_par_id)
--        LOOP
--
--          v_currency_rt := c2.currency_rt;
--
--          /* If the record processed is a package policy
--          ** then get the true LINE_CD and true SUBLINE_CD,
--          ** that is, the PACK_LINE_CD and PACK_SUBLINE_CD 
--          ** from the GIPI_WITEM table.
--          ** This will be used upon inserting to certain
--          ** distribution tables requiring a value for
--          ** the similar field. */
--          IF p_pack_pol_flag = 'N' THEN
--             v_line_cd    := p_line_cd;
--             v_subline_cd := p_subline_cd;
--          ELSE
--             v_line_cd           := c2.pack_line_cd;
--             v_subline_cd        := c2.pack_subline_cd;
--             v_package_policy_sw := 'Y';
--          END IF;
--          EXIT;
--        END LOOP;
--
--        IF v_package_policy_sw = 'Y' THEN
--           FOR c2 IN (SELECT default_no, default_type, dist_type,
--                             dflt_netret_pct
--                        FROM giis_default_dist
--                       WHERE iss_cd     = p_iss_cd
--                         AND subline_cd = v_subline_cd
--                         AND line_cd    = v_line_cd)
--           LOOP
--             v_default_no      := c2.default_no;
--             v_default_type    := c2.default_type;
--             v_dist_type       := c2.dist_type;
--             v_dflt_netret_pct := c2.dflt_netret_pct;
--             EXIT;
--           END LOOP;
--           /*IF NVL(v_dist_type, '1') = '1' THEN
--              rg_id := FIND_GROUP(rg_name);
--              IF NOT ID_NULL(rg_id) THEN
--                 DELETE_GROUP(rg_id);
--              END IF;
--              rg_id    := CREATE_GROUP_FROM_QUERY(rg_name,
--                          '   SELECT a.line_cd    , a.share_cd , a.share_pct  , '
--                       || '          a.share_amt1 , a.peril_cd , a.share_amt2 , '
--                       || '          1 true_pct '
--                       || '     FROM giis_default_dist_group a '
--                       || '    WHERE a.default_no = ' || TO_CHAR(NVL(v_default_no, 0))
--                       || '      AND a.line_cd    = ' || '''' || v_line_cd || ''''
--                       || '      AND a.share_cd   <> 999 '
--                       || ' ORDER BY a.sequence ASC');
--              v_errors := POPULATE_GROUP(rg_id);
--              IF v_errors NOT IN (0, 1403) THEN
--                 MESSAGE('Error populating group ' || rg_name || '.', NO_ACKNOWLEDGE);
--                 RAISE FORM_TRIGGER_FAILURE;
--              END IF;
--              rg_count := GET_GROUP_ROW_COUNT(rg_id);
--           END IF;*/
--           
--           -- added by: shan 07.22.2014
--         
--         rg_count := 0;  
--              
--         FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  ,
--                     a.share_amt1 , a.peril_cd , a.share_amt2 ,
--                     1 true_pct 
--               FROM GIIS_DEFAULT_DIST_GROUP a 
--               WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
--               AND a.line_cd    = v_line_cd
--               AND a.share_cd   <> 999 
--               ORDER BY a.sequence ASC)
--         LOOP
--            rg_count := c.rownum;
--         END LOOP; 
--         
--         -- end here
--         
--           v_package_policy_sw := 'N';
--        END IF;
--        IF NVL(v_dist_type, '1') = '1' THEN
--           v_post_flag := 'O';
--           --sg_alert('RECREATE_GRP_DFLT_DIST','I',FALSE);
--           GIUW_WITEMDS_PKG.RECREATE_GRP_DFLT_DIST
--                   (p_dist_no      , c1.dist_seq_no , '2'            ,
--                    c1.tsi_amt     , c1.prem_amt    , c1.ann_tsi_amt ,
--                    c1.item_grp    , v_line_cd      , rg_count       ,
--                    v_default_type , v_currency_rt  , p_par_id      , 
--                    p_c150_item_grp, p_pol_flag, p_par_type, v_default_no);
--        ELSIF v_dist_type = '2' THEN
--           v_post_flag := 'P';
--           --sg_alert('RECREATE_PERIL_DFLT_DIST','I',FALSE);
--    GIUW_WITEMDS_PKG.RECREATE_PERIL_DFLT_DIST
--                   (p_dist_no      , c1.dist_seq_no    , '2'            ,
--                    c1.tsi_amt     , c1.prem_amt       , c1.ann_tsi_amt ,
--                    c1.item_grp    , v_line_cd         , v_default_no   ,
--                    v_default_type , v_dflt_netret_pct , v_currency_rt  ,
--                    p_par_id, p_pol_flag, p_par_type);
--        END IF;
--      END LOOP;
--      --IF NOT ID_NULL(rg_id) THEN
--      --   DELETE_GROUP(rg_id);
--      --END IF;
--
--      /* Adjust computational floats to equalize the amounts
--      ** attained by the master tables with that of its detail
--      ** tables.
--      ** Tables involved:  GIUW_WPERILDS     - GIUW_WPERILDS_DTL
--      **                   GIUW_WPOLICYDS    - GIUW_WPOLICYDS_DTL
--      **                   GIUW_WITEMDS      - GIUW_WITEMDS_DTL
--      **                   GIUW_WITEMPERILDS - GIUW_WITEMPERILDS_DTL */
--        
--      IF p_pol_flag != '2' AND p_par_type = 'P' THEN
--        --msg_alert('ADJUST_NET_RET_IMPERFECTION(p_dist_no);','I',FALSE);
--         ADJUST_NET_RET_IMPERFECTION(p_dist_no);
--      END IF;
--      
--      /* Create records in RI tables if a facultative
--      ** share exists in any of the DIST_SEQ_NO in table
--      ** GIUW_WPOLICYDS_DTL. */
--      CREATE_RI_RECORDS(p_dist_no, p_par_id, p_line_cd, p_subline_cd);
--
--      /* Set the value of the DIST_FLAG back 
--      ** to Undistributed after recreation. */
--      --:c080.dist_flag      := '1';
--      --:c080.mean_dist_flag := 'Undistributed';
--      UPDATE giuw_pol_dist
--         SET dist_flag = '1',
--             post_flag = v_post_flag
--       WHERE par_id    = p_par_id
--         AND dist_no   = p_dist_no;
--         
--      GIUW_POL_DIST_PKG.ADJUST_AMTS(p_dist_no);   
--      
--      -- shan 07.22.2014  
--      /*IF NVL (v_dist_type, '1') = '1' THEN 
--         giuw_pol_dist_pkg.ADJUST_ALL_WTABLES_GIUWS004(p_dist_no);
--         adjust_wdist_one_risk.ADJUST_SHARE_WDISTFRPS(p_dist_no);
--      ELSIF v_dist_type = '2' THEN
--         ADJUST_DISTRIBUTION_PERIL_PKG.adjust_distribution(p_dist_no);
--      END IF;*/

      -- jhing 04.01.2016 
--      GIUW_POL_DIST_PKG.POPULATE_DEFAULT_DIST ( p_dist_no, v_post_flag, v_dist_type );
      
      GIUW_POL_DIST_PKG.CRTE_PRELIM_REGRPED_DIST_RECS  (p_dist_no  ,
                            p_par_id    ,p_line_cd  , p_subline_cd  ,
                            p_iss_cd  , p_pack_pol_flag );    
    
      
       UPDATE giuw_pol_dist
         SET dist_flag = '1',
             post_flag = v_post_flag
       WHERE par_id = p_par_id AND dist_no = p_dist_no;
      
      giuw_pol_dist_pkg.v_share_pct_updated := FALSE;
    END;
    
/**
** Created by:      Veronica V. Raymundo
** Date Created:    July 7, 2011
** Reference by:    GIUWS010 - Set-up Group for Distribution
** Description :    Function returns query details from GIUW_WITEMDS 
**                  given the policy_id and dist_no.
**/
    
    FUNCTION get_giuw_witemds_for_distr(p_policy_id    GIPI_POLBASIC.policy_id%TYPE,
                                        p_dist_no 	    GIUW_WITEMDS.dist_no%TYPE)
    RETURN giuw_witemds_tab PIPELINED 
    
    IS
      v_witemds        giuw_witemds_type;
      v_max_dist_seq_no giuw_witemds.dist_seq_no%TYPE;  -- jhing 12.01.2014
      v_temp_cnt        NUMBER ; -- jhing 12.02.2014 
    
    BEGIN
    
        -- jhing 12.01.2014 get maximum dist_seq_no
         SELECT max(dist_seq_no) 
		  INTO v_max_dist_seq_no
		  FROM giuw_wpolicyds
		 WHERE dist_no = p_dist_no;
         
        FOR i IN (SELECT a.dist_no,     a.dist_seq_no,
                         a.item_no,     a.tsi_amt,
                         a.prem_amt,    a.ann_tsi_amt,
                         a.arc_ext_data
                    FROM GIUW_WITEMDS a , GIUW_WPOLICYDS b -- jhing 12.01.2014 added connection to GIUW_WPOLICYDS
                   WHERE a.dist_no = p_dist_no
                    AND a.dist_no = b.dist_no
                    AND a.dist_seq_no = b.dist_seq_no                    
                   ORDER BY item_no, dist_seq_no  
                   )
        LOOP
            v_witemds.dist_no          := i.dist_no;
            v_witemds.dist_seq_no      := i.dist_seq_no;
            v_witemds.item_no          := i.item_no;
            v_witemds.tsi_amt          := i.tsi_amt;
            v_witemds.prem_amt         := i.prem_amt;
            v_witemds.ann_tsi_amt      := i.ann_tsi_amt;
            v_witemds.arc_ext_data     := i.arc_ext_data;
            v_witemds.max_dist_seq_no  := v_max_dist_seq_no; -- jhing 12.01.2014
            
            FOR c1 IN (SELECT item_title      , item_desc , pack_line_cd , 
                              pack_subline_cd , item_grp  , currency_cd  ,
                              currency_rt     , ann_tsi_amt
                         FROM GIPI_ITEM
                        WHERE item_no = i.item_no
                          AND policy_id  = p_policy_id)
            LOOP
                v_witemds.nbt_item_title      :=  c1.item_title;
                v_witemds.nbt_item_desc       :=  c1.item_desc;
                v_witemds.dsp_pack_line_cd    :=  c1.pack_line_cd;
                v_witemds.dsp_pack_subline_cd :=  c1.pack_subline_cd;
                v_witemds.item_grp            :=  c1.item_grp;
                v_witemds.nbt_currency_cd     :=  c1.currency_cd;
                v_witemds.dsp_currency_rt     :=  c1.currency_rt;
                FOR c2 IN (SELECT short_name
                             FROM GIIS_CURRENCY
                            WHERE main_currency_cd = c1.currency_cd)
                LOOP
                	
                   v_witemds.dsp_short_name :=  c2.short_name;
                   EXIT;
                END LOOP;
                EXIT;
            END LOOP;
            
            v_witemds.orig_dist_seq_no := i.dist_seq_no;
            
            -- jhing 12.02.2014, query cnt of items per dist group
            v_temp_cnt := 0 ;
            FOR curItem IN (SELECT count(*)  cnt 
                                FROM giuw_witemds
                                    WHERE dist_no = p_dist_no
                                      AND dist_seq_no = i.dist_seq_no )
            LOOP
                v_temp_cnt := curItem.cnt;
                EXIT;
            END LOOP;
            
            v_witemds.cnt_per_dist_grp := v_temp_cnt ;
        PIPE ROW(v_witemds);
        END LOOP;
    RETURN;    
    END;
	
	/**
	** Created by:      Anthony Santos
	** Date Created:    July 19, 2011
	** Reference by:    GIUWS013 - One Risk
	**/
	
	PROCEDURE post_witemds_dtl(
	   p_dist_no             giuw_pol_dist.dist_no%TYPE
	)
	 IS
	  v_count    NUMBER(1);
	BEGIN
	
	  /* Get the value of the columns in table GIUW_WITEMDS 
	  ** in preparation for insertion or update to its corresponding
	  ** master table GIUW_ITEMDS. */
	  FOR wds_cur IN (  SELECT dist_no     , dist_seq_no , item_no     ,
	                           tsi_amt     , prem_amt    , ann_tsi_amt
	                      FROM giuw_witemds
	                     WHERE dist_no = p_dist_no
	                  ORDER BY dist_no , dist_seq_no , item_no)
	  LOOP
	    v_count  :=  NULL;
	
	   /* If the record corresponding to the specified DIST_NO
	    ** DIST_SEQ_NO and ITEM_NO does not exist in table GIUW_ITEMDS,
	    ** then the record in table GIUW_WITEMDS must be inserted
	    ** to the said table. */ 
	    IF v_count IS NULL THEN
	       INSERT INTO  giuw_itemds
	                   (dist_no             , dist_seq_no         , item_no             ,
	                    tsi_amt             , prem_amt            , ann_tsi_amt)
	            VALUES (wds_cur.dist_no     , wds_cur.dist_seq_no , wds_cur.item_no     ,
	                    wds_cur.tsi_amt     , wds_cur.prem_amt    , wds_cur.ann_tsi_amt); 
	     END IF;
	  END LOOP;
	
	  /* Get the value of the columns in table GIUW_WITEMDS_DTL 
	  ** in preparation for insertion or update to its corresponding
	  ** master table GIUW_ITEMDS_DTL. */ 
	  FOR wds_dtl_cur IN (  SELECT dist_no      , dist_seq_no   , item_no       ,
	                               line_cd      , share_cd      , dist_tsi      ,
	                               dist_prem    , dist_spct     , ann_dist_spct ,
	                               ann_dist_tsi , dist_grp
	                          FROM giuw_witemds_dtl
	                         WHERE dist_no = p_dist_no
	                      ORDER BY dist_no      , dist_seq_no   , item_no       ,
	                               line_cd      , share_cd)
	  LOOP
	    v_count  :=  NULL;
	
	    /* If the record corresponding to the specified DIST_NO, DIST_SEQ_NO, 
	    ** ITEM_NO, LINE_CD, SHARE_CD does not exist in table GIUW_ITEMDS_DTL,
	    ** then the record in table GIUW_ITEMDS_DTL must be inserted to the
	    ** said table. */ 
	    IF v_count IS NULL THEN
	       INSERT INTO  giuw_itemds_dtl
	                   (dist_no                   , dist_seq_no               ,
	                    item_no                   , line_cd                   ,
	                    share_cd                  , dist_tsi                  ,
	                    dist_prem                 , dist_spct                 ,
	                    ann_dist_spct             , ann_dist_tsi              ,
	                    dist_grp                  , dist_spct1)
	            VALUES (wds_dtl_cur.dist_no       , wds_dtl_cur.dist_seq_no   , 
	                    wds_dtl_cur.item_no       , wds_dtl_cur.line_cd       ,
	                    wds_dtl_cur.share_cd      , wds_dtl_cur.dist_tsi      ,
	                    wds_dtl_cur.dist_prem     , wds_dtl_cur.dist_spct     ,
	                    wds_dtl_cur.ann_dist_spct , wds_dtl_cur.ann_dist_tsi  ,
	                    wds_dtl_cur.dist_grp      , NULL);
	    END IF;
	  END LOOP;
	END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Post records retrieved from the working tables to their 
**                 corresponding master tables.
**                 Create or update non-existing or existing records of tables
**                 GIUW_ITEMDS and GIUW_ITEMDS_DTL based on the data retrieved
**                 from working tables GIUW_WITEMDS and GIUW_WITEMDS_DTL.
*/

    PROCEDURE post_witemds_dtl_giuws016(p_dist_no     IN        GIUW_POL_DIST.dist_no%TYPE) IS
      v_count    NUMBER(1);
    BEGIN

      /* Get the value of the columns in table GIUW_WITEMDS 
      ** in preparation for insertion or update to its corresponding
      ** master table GIUW_ITEMDS. */
      FOR wds_cur IN (  SELECT dist_no     , dist_seq_no , item_no     ,
                               tsi_amt     , prem_amt    , ann_tsi_amt
                          FROM GIUW_WITEMDS
                         WHERE dist_no = p_dist_no
                      ORDER BY dist_no , dist_seq_no , item_no)
      LOOP
        v_count  :=  NULL;

        /* If the record corresponding to the specified DIST_NO
        ** DIST_SEQ_NO and ITEM_NO does not exist in table GIUW_ITEMDS,
        ** then the record in table GIUW_WITEMDS must be inserted
        ** to the said table. */ 
        IF v_count IS NULL THEN
           INSERT INTO  GIUW_ITEMDS
                       (dist_no             , dist_seq_no         , item_no             ,
                        tsi_amt             , prem_amt            , ann_tsi_amt)
                VALUES (wds_cur.dist_no     , wds_cur.dist_seq_no , wds_cur.item_no     ,
                        wds_cur.tsi_amt     , wds_cur.prem_amt    , wds_cur.ann_tsi_amt); 
         END IF;
      END LOOP;

      /* Get the value of the columns in table GIUW_WITEMDS_DTL 
      ** in preparation for insertion or update to its corresponding
      ** master table GIUW_ITEMDS_DTL. */ 
      FOR wds_dtl_cur IN (  SELECT dist_no      , dist_seq_no   , item_no       ,
                                   line_cd      , share_cd      , dist_tsi      ,
                                   dist_prem    , dist_spct     , ann_dist_spct ,
                                   ann_dist_tsi , dist_grp      , dist_spct1
                              FROM GIUW_WITEMDS_DTL
                             WHERE dist_no = p_dist_no
                          ORDER BY dist_no      , dist_seq_no   , item_no       ,
                                   line_cd      , share_cd)
      LOOP
        v_count  :=  NULL;

        /* If the record corresponding to the specified DIST_NO, DIST_SEQ_NO, 
        ** ITEM_NO, LINE_CD, SHARE_CD does not exist in table GIUW_ITEMDS_DTL,
        ** then the record in table GIUW_ITEMDS_DTL must be inserted to the
        ** said table. */ 
        IF v_count IS NULL THEN
           INSERT INTO  GIUW_ITEMDS_DTL
                       (dist_no                   , dist_seq_no               ,
                        item_no                   , line_cd                   ,
                        share_cd                  , dist_tsi                  ,
                        dist_prem                 , dist_spct                 ,
                        ann_dist_spct             , ann_dist_tsi              ,
                        dist_grp                  , dist_spct1)
                VALUES (wds_dtl_cur.dist_no       , wds_dtl_cur.dist_seq_no   , 
                        wds_dtl_cur.item_no       , wds_dtl_cur.line_cd       ,
                        wds_dtl_cur.share_cd      , wds_dtl_cur.dist_tsi      ,
                        wds_dtl_cur.dist_prem     , wds_dtl_cur.dist_spct     ,
                        wds_dtl_cur.ann_dist_spct , wds_dtl_cur.ann_dist_tsi  ,
                        wds_dtl_cur.dist_grp      , wds_dtl_cur.dist_spct1);
        END IF;
      END LOOP;
    END;
    
    
    /*
    **  Created by   : Robert John Virrey 
    **  Date Created : August 4, 2011
    **  Reference By : GIUTS002 - Distribution Negation 
    **  Description  : Creates a new distribution record in table GIUW_WITEMDS
    **                  based on the values taken in by the fields of the negated
    **                  record
    */
    PROCEDURE neg_itemds (
        p_dist_no     IN  giuw_itemds.dist_no%TYPE,
        p_temp_distno IN  giuw_itemds.dist_no%TYPE
    ) 
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , item_no     , tsi_amt,
               prem_amt    , ann_tsi_amt
          FROM giuw_itemds
         WHERE dist_no = p_dist_no;

      v_dist_seq_no        giuw_itemds.dist_seq_no%type;
      v_item_no            giuw_itemds.item_no%type;    
      v_tsi_amt            giuw_itemds.tsi_amt%type;    
      v_prem_amt           giuw_itemds.prem_amt%type;    
      v_ann_tsi_amt        giuw_itemds.ann_tsi_amt%type;    

    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur 
         INTO v_dist_seq_no , v_item_no     , v_tsi_amt ,
              v_prem_amt    , v_ann_tsi_amt;
        EXIT WHEN dtl_retriever_cur%NOTFOUND; 
        INSERT INTO  giuw_witemds
                    (dist_no           , dist_seq_no   , item_no   ,
                     tsi_amt           , prem_amt      , ann_tsi_amt)
             VALUES (p_temp_distno     , v_dist_seq_no , v_item_no ,
                     v_tsi_amt         , v_prem_amt    , v_ann_tsi_amt);
      END LOOP;
      CLOSE dtl_retriever_cur;
    END neg_itemds;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  08.16.2011
    **  Reference By : (GIUTS021 - Redistribution)
    **  Description  : Creates a new distribution record in table GIUW_WITEMDS
    **                 based on the values taken in by the fields of the negated
    **                 record.
    **                 NOTE:  The value of field DIST_NO was not copied, as the newly 
    **                 created distribution record has its own distribution number.
    */ 
    PROCEDURE NEG_ITEMDS_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_v_ratio          IN OUT NUMBER)
    IS

      CURSOR dtl_retriever_cur IS
        SELECT dist_seq_no , item_no     , tsi_amt,
               prem_amt    , ann_tsi_amt
          FROM giuw_itemds
         WHERE dist_no = p_var_v_neg_distno;

      v_dist_seq_no            giuw_itemds.dist_seq_no%type;
      v_item_no            giuw_itemds.item_no%type;    
      v_tsi_amt            giuw_itemds.tsi_amt%type;    
      v_prem_amt            giuw_itemds.prem_amt%type;    
      v_ann_tsi_amt            giuw_itemds.ann_tsi_amt%type;    
      v_prem_amt_f            giuw_itemds.prem_amt%type;    
      v_prem_amt_w            giuw_itemds.prem_amt%type;    
    BEGIN
      OPEN dtl_retriever_cur;
      LOOP
        FETCH dtl_retriever_cur 
         INTO v_dist_seq_no , v_item_no     , v_tsi_amt ,
              v_prem_amt    , v_ann_tsi_amt;
        EXIT WHEN dtl_retriever_cur%NOTFOUND; 
        v_prem_amt_f := ROUND(v_prem_amt * p_v_ratio ,2);
        v_prem_amt_w := v_prem_amt - v_prem_amt_f;
        /* earned portion */
        INSERT INTO  giuw_witemds
                    (dist_no           , dist_seq_no   , item_no   ,
                     tsi_amt           , prem_amt      , ann_tsi_amt)
             VALUES (p_dist_no     , v_dist_seq_no , v_item_no ,
                     v_tsi_amt         , v_prem_amt_f  , v_ann_tsi_amt);
        /* unearned portion */
        INSERT INTO  giuw_witemds
                    (dist_no           , dist_seq_no   , item_no   ,
                     tsi_amt           , prem_amt      , ann_tsi_amt)
             VALUES (p_temp_distno , v_dist_seq_no , v_item_no ,
                     v_tsi_amt         , v_prem_amt_w  , v_ann_tsi_amt);
      END LOOP;
      CLOSE dtl_retriever_cur;
    END NEG_ITEMDS_GIUTS021;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Used for Post batch distribution process.    
*/

    PROCEDURE POST_WITEMDS_DTL_GIUWS015(p_batch_id  GIUW_POL_DIST.batch_id%TYPE,
                                        p_dist_no   GIUW_POL_DIST.dist_no%TYPE) IS

    BEGIN

      DELETE GIUW_WITEMDS_DTL
       WHERE dist_no = p_dist_no;
      
      DECLARE
        CURSOR C3 IS SELECT * 
                      FROM GIUW_WITEMDS
                     WHERE dist_no = p_dist_no
                     ORDER BY dist_no, item_no;
              
              v_dist_tsi       GIUW_WPOLICYDS.tsi_amt%TYPE;
              v_dist_prem      GIUW_WPOLICYDS.prem_amt%TYPE;
              v_ann_dist_tsi   GIUW_WPOLICYDS.ann_tsi_amt%TYPE;
              v_dist_grp       CONSTANT GIUW_WPOLICYDS_DTL.dist_grp%TYPE := 1;
      BEGIN
          FOR c3_rec IN C3
          LOOP
            DECLARE
              CURSOR C4 IS SELECT line_cd, share_cd, dist_spct 
                           FROM GIUW_DIST_BATCH_DTL
                           WHERE batch_id = p_batch_id;
          BEGIN     
              FOR c4_rec IN C4 LOOP
                    v_dist_tsi     := c3_rec.tsi_amt * (c4_rec.dist_spct/100);
                    v_dist_prem    := c3_rec.prem_amt * (c4_rec.dist_spct/100);
                    v_ann_dist_tsi := c3_rec.ann_tsi_amt * (c4_rec.dist_spct/100);
                    
                    INSERT INTO GIUW_WITEMDS_DTL(
                               dist_no,         dist_seq_no,     item_no,        line_cd,               
                               share_cd,        dist_spct,       dist_tsi,       dist_prem,         
                               ann_dist_spct,   dist_spct1,      ann_dist_tsi,   dist_grp) 
                      VALUES ( c3_rec.dist_no  ,c3_rec.dist_seq_no,    c3_rec.item_no,    c4_rec.line_cd    ,    
                               c4_rec.share_cd ,c4_rec.dist_spct  ,v_dist_tsi       , v_dist_prem     ,        
                               c4_rec.dist_spct,NULL              ,v_ann_dist_tsi   , v_dist_grp);
            END LOOP;
          END;

        END LOOP;
      END;

    END;
    
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Transfer all the records from working 
**                table of GIUW_WITEMDS to main table GIUW_ITEMDS    
*/

    PROCEDURE TRANSFER_WITEMDS (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE) IS
            
    BEGIN
            /* Master Table */
            FOR POLDS_REC IN (SELECT *
                                FROM GIUW_WITEMDS
                               WHERE dist_no = p_dist_no)
            LOOP 
                    INSERT INTO GIUW_ITEMDS(dist_no,              dist_seq_no,              item_no,
                                            tsi_amt,              prem_amt,                 ann_tsi_amt)
                                    VALUES (POLDS_REC.dist_no,    POLDS_REC.dist_seq_no,    POLDS_REC.item_no,
                                            POLDS_REC.tsi_amt,    POLDS_REC.prem_amt,       POLDS_REC.ann_tsi_amt);
            END LOOP;
            
            /* Detail Table */
            FOR ITMDSDTL_REC IN (SELECT *
                                   FROM GIUW_WITEMDS_DTL
                                  WHERE dist_no = p_dist_no)
            LOOP 
                    INSERT INTO GIUW_ITEMDS_DTL(dist_no,                    dist_seq_no,                  item_no,
                                                line_cd,                    share_cd,                     dist_spct,
                                                dist_spct1,                 dist_tsi,                     dist_prem,
                                                ann_dist_spct,              ann_dist_tsi,                 dist_grp)
                                         VALUES(ITMDSDTL_REC.dist_no,       ITMDSDTL_REC.dist_seq_no,     ITMDSDTL_REC.item_no,
                                                ITMDSDTL_REC.line_cd,       ITMDSDTL_REC.share_cd,        ITMDSDTL_REC.dist_spct,
                                                ITMDSDTL_REC.dist_spct1,    ITMDSDTL_REC.dist_tsi,        ITMDSDTL_REC.dist_prem,
                                                ITMDSDTL_REC.ann_dist_spct, ITMDSDTL_REC.ann_dist_tsi,    ITMDSDTL_REC.dist_grp);
            END LOOP; 

    END;
    
END GIUW_WITEMDS_PKG;
/


