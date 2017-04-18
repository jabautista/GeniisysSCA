DROP PROCEDURE CPI.CREATE_GRP_DFLT_WITEMPERILDS;

CREATE OR REPLACE PROCEDURE CPI.CREATE_GRP_DFLT_WITEMPERILDS
         (p_dist_no			IN giuw_witemperilds_dtl.dist_no%TYPE      ,
          p_dist_seq_no		IN giuw_witemperilds_dtl.dist_seq_no%TYPE  ,
          p_item_no			IN giuw_witemperilds_dtl.item_no%TYPE      ,
          p_line_cd			IN giuw_witemperilds_dtl.line_cd%TYPE      ,
          p_peril_cd		IN giuw_witemperilds_dtl.peril_cd%TYPE     ,
          p_dist_tsi		IN giuw_witemperilds_dtl.dist_tsi%TYPE     ,
          p_dist_prem		IN giuw_witemperilds_dtl.dist_prem%TYPE    ,
          p_ann_dist_tsi	IN giuw_witemperilds_dtl.ann_dist_tsi%TYPE ,
          p_rg_count		IN NUMBER,
		  p_v_default_no	IN giis_default_dist.default_no%TYPE) IS

 -- rg_id				RECORDGROUP;
  rg_name			VARCHAR2(20) := 'DFLT_DIST_VALUES';
  rg_col2			VARCHAR2(40) := rg_name || '.share_cd';
  rg_col7			VARCHAR2(40) := rg_name || '.true_pct';
  v_selection_count		NUMBER;
  v_row				NUMBER;
  v_dist_spct			giuw_witemperilds_dtl.dist_spct%TYPE;
  v_dist_tsi			giuw_witemperilds_dtl.dist_tsi%TYPE;
  v_dist_prem			giuw_witemperilds_dtl.dist_prem%TYPE;
  v_ann_dist_tsi		giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
  v_share_cd			giis_dist_share.share_cd%TYPE;
  v_sum_dist_tsi		giuw_witemperilds_dtl.dist_tsi%TYPE     := 0;
  v_sum_dist_spct		giuw_witemperilds_dtl.dist_spct%TYPE    := 0;
  v_sum_dist_prem		giuw_witemperilds_dtl.dist_prem%TYPE    := 0;
  v_sum_ann_dist_tsi		giuw_witemperilds_dtl.ann_dist_tsi%TYPE := 0;

  PROCEDURE INSERT_TO_WITEMPERILDS_DTL IS
  BEGIN
    INSERT INTO  giuw_witemperilds_dtl
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
  /*
  **  Created by   : Jerome Orio 
  **  Date Created : April 05, 2010 
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : CREATE_GRP_DFLT_WITEMPERILDS program unit 
  */
  
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

  END IF;   
END;
/


