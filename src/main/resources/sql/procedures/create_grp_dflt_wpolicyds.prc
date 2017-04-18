DROP PROCEDURE CPI.CREATE_GRP_DFLT_WPOLICYDS;

CREATE OR REPLACE PROCEDURE CPI.CREATE_GRP_DFLT_WPOLICYDS
         (p_dist_no		    IN giuw_wpolicyds_dtl.dist_no%TYPE      ,
          p_dist_seq_no		IN giuw_wpolicyds_dtl.dist_seq_no%TYPE  ,
          p_line_cd			IN giuw_wpolicyds_dtl.line_cd%TYPE      ,
          p_dist_tsi		IN giuw_wpolicyds_dtl.dist_tsi%TYPE     ,
          p_dist_prem		IN giuw_wpolicyds_dtl.dist_prem%TYPE    ,
          p_ann_dist_tsi	IN giuw_wpolicyds_dtl.ann_dist_tsi%TYPE ,
          p_rg_count		IN OUT NUMBER                           ,
          p_default_type	IN giis_default_dist.default_type%TYPE  ,
          p_currency_rt     IN gipi_witem.currency_rt%TYPE          ,
          p_par_id          IN gipi_parlist.par_id%TYPE             ,
          p_item_grp		IN gipi_witem.item_grp%TYPE,
		  p_v_default_no	IN giis_default_dist.default_no%TYPE) IS

--  rg_id				RECORDGROUP;
  rg_name			VARCHAR2(20) := 'DFLT_DIST_VALUES';
  rg_col1			VARCHAR2(40) := rg_name || '.line_cd';
  rg_col2			VARCHAR2(40) := rg_name || '.share_cd';
  rg_col3			VARCHAR2(40) := rg_name || '.share_pct';
  rg_col4			VARCHAR2(40) := rg_name || '.share_amt1';
  rg_col5			VARCHAR2(40) := rg_name || '.peril_cd';
  rg_col6			VARCHAR2(40) := rg_name || '.share_amt2';
  rg_col7			VARCHAR2(40) := rg_name || '.true_pct';
  v_remaining_tsi		NUMBER       := p_dist_tsi * p_currency_rt;
  v_share_amt			giis_default_dist_group.share_amt1%TYPE;
  v_peril_cd			giis_default_dist_group.peril_cd%TYPE;
  v_prev_peril_cd		giis_default_dist_group.peril_cd%TYPE;
  v_dist_spct			giuw_wpolicyds_dtl.dist_spct%TYPE;
  v_dist_tsi			giuw_wpolicyds_dtl.dist_tsi%TYPE;
  v_dist_prem			giuw_wpolicyds_dtl.dist_prem%TYPE;
  v_ann_dist_tsi		giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
  v_sum_dist_tsi		giuw_wpolicyds_dtl.dist_tsi%TYPE     := 0;
  v_sum_dist_spct		giuw_wpolicyds_dtl.dist_spct%TYPE    := 0;
  v_sum_dist_prem		giuw_wpolicyds_dtl.dist_prem%TYPE    := 0;
  v_sum_ann_dist_tsi	giuw_wpolicyds_dtl.ann_dist_tsi%TYPE := 0;
  v_share_cd			giis_dist_share.share_cd%TYPE;
  v_use_share_amt2      VARCHAR2(1) := 'N';
  v_dist_spct_limit		NUMBER;
  
  --by iris bordey 03.03.03
  /*v_line_cd             gipi_polbasic.line_cd%TYPE;
  v_subline_cd          gipi_polbasic.subline_cd%TYPE;
  v_iss_cd              gipi_polbasic.iss_cd%TYPE;
  v_issue_yy            gipi_polbasic.issue_yy%TYPE;
  v_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  v_renew_no            gipi_polbasic.renew_no%TYPE;
  v_eff_date            gipi_polbasic.eff_date%TYPE;
  v_insert_sw						VARCHAR2(1) := 'N';*/
  
   --Added by Apollo Cruz 11.27.2014
  PROCEDURE validate_share
  IS
     v VARCHAR2(1);
  BEGIN
     SELECT 'Y'
       INTO v
       FROM giis_dist_share
      WHERE line_cd = p_line_cd
        AND share_cd = v_share_cd;   
  EXCEPTION WHEN NO_DATA_FOUND THEN
     raise_application_error(-20001, 'Geniisys Exception#E#There is no setup for default distribution. Please contact your system administrator.');
  END;
  
  PROCEDURE INSERT_TO_WPOLICYDS_DTL IS
  BEGIN
       validate_share;
       INSERT INTO  giuw_wpolicyds_dtl
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
  /*
  **  Created by   : Jerome Orio 
  **  Date Created : April 05, 2010 
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : CREATE_GRP_DFLT_WPOLICYDS program unit 
  */
  
  /*IF :postpar.par_type = 'E' THEN
  	 FOR pol IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date
  	               FROM gipi_wpolbas
  	              WHERE par_id = :b240.par_id)
  	 LOOP
  	 	 v_line_cd := pol.line_cd;
  	 	 v_subline_cd := pol.subline_cd;
  	 	 v_iss_cd     := pol.iss_cd;
  	 	 v_issue_yy   := pol.issue_yy;
  	 	 v_pol_seq_no := pol.pol_seq_no;
  	 	 v_renew_no   := pol.renew_no;
  	 	 v_eff_date   := pol.eff_date;
  	 	 EXIT;
  	 END LOOP;
  	 IF :parameter.extract_sw = 'N' THEN
  	 	  summarize_distribution.extract(v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no,
                                       v_renew_no, v_eff_date);
        :parameter.extract_sw := 'Y';
  	 END IF;
  	 FOR dst IN (SELECT tsi_spct, share_cd
                   FROM giuw_policyds_ext
                  WHERE line_cd    = v_line_cd
                    AND subline_cd = v_subline_cd
                    AND iss_cd     = v_iss_cd
                    AND issue_yy   = v_issue_yy
                    AND pol_seq_no = v_pol_seq_no
                    AND renew_no   = v_renew_no)
     LOOP
     	 v_insert_sw := 'Y';
     	 INSERT INTO giuw_wpolicyds_dtl
             (dist_no,          dist_seq_no,   line_cd,   share_cd,
              dist_spct,        dist_tsi,      dist_prem,
              ann_dist_spct,    ann_dist_tsi,  dist_grp)
       VALUES(:postpar.dist_no, p_item_grp,    p_line_cd,    dst.share_cd,
              dst.tsi_spct,     p_dist_tsi*dst.tsi_spct/100,     p_dist_prem*dst.tsi_spct/100,
              dst.tsi_spct,     p_ann_dist_tsi*dst.tsi_spct/100, 1);
     END LOOP;  
  END IF;*/
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
  			        FROM giis_default_dist_group a  
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
                             FROM gipi_witmperl B490, gipi_witem B480
                            WHERE B490.peril_cd = v_peril_cd
                              AND B490.line_cd  = p_line_cd
                              AND B490.item_no  = B480.item_no
                              AND B490.par_id   = B480.par_id
                              AND B480.item_grp = p_item_grp
                              AND B480.par_id   = p_par_id)
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
          --v_share_cd := GET_GROUP_NUMBER_CELL(rg_col2, c);
		  v_share_cd := c.share_cd;
          --SET_GROUP_NUMBER_CELL(rg_col7, c, v_dist_spct);
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
           --SET_GROUP_SELECTION(rg_id, p_rg_count);
           INSERT_TO_WPOLICYDS_DTL;
        END IF;

     /* Use PERCENTAGES to create the default distribution records. */
     ELSIF p_default_type = 2 THEN
        FOR c IN (SELECT rownum, a.line_cd    , a.share_cd , a.share_pct  , 
       	   	  		  	 a.share_amt1 , a.peril_cd , a.share_amt2 ,
       				  	 1 true_pct 
  			        FROM giis_default_dist_group a  
 				   WHERE a.default_no = TO_CHAR(NVL(p_v_default_no, 0))
   				     AND a.line_cd    = p_line_cd
   				  	 AND a.share_cd   <> 999
 				   ORDER BY a.sequence ASC)
        LOOP
          --v_dist_spct     := GET_GROUP_NUMBER_CELL(rg_col3, c);
		  v_dist_spct     := c.share_pct;
          --v_share_amt     := GET_GROUP_NUMBER_CELL(rg_col4, c);
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
          --v_share_cd      := GET_GROUP_NUMBER_CELL(rg_col2, c);
		  v_share_cd      := c.share_cd;
          --SET_GROUP_NUMBER_CELL(rg_col7, c, v_dist_spct);
          --SET_GROUP_SELECTION(rg_id, c);
          INSERT_TO_WPOLICYDS_DTL;
        END LOOP;
        IF v_sum_dist_spct != 100 THEN
           v_dist_spct    := 100            - v_sum_dist_spct;
           v_dist_tsi     := p_dist_tsi     - v_sum_dist_tsi;
           v_dist_prem    := p_dist_prem    - v_sum_dist_prem;
           v_ann_dist_tsi := p_ann_dist_tsi - v_sum_ann_dist_tsi;
           v_share_cd     := '999';
           p_rg_count     := p_rg_count + 1;
          -- ADD_GROUP_ROW(rg_id, END_OF_GROUP);
          -- SET_GROUP_NUMBER_CELL(rg_col2, p_rg_count, 999);
          -- SET_GROUP_NUMBER_CELL(rg_col7, p_rg_count, v_dist_spct);
          -- SET_GROUP_SELECTION(rg_id, p_rg_count);
           INSERT_TO_WPOLICYDS_DTL;
        END IF;
     END IF;
  END IF;   
END;
/


