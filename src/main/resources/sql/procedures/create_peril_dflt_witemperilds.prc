DROP PROCEDURE CPI.CREATE_PERIL_DFLT_WITEMPERILDS;

CREATE OR REPLACE PROCEDURE CPI.CREATE_PERIL_DFLT_WITEMPERILDS
         (p_dist_no       IN giuw_wperilds_dtl.dist_no%TYPE,
          p_dist_seq_no   IN giuw_wperilds_dtl.dist_seq_no%TYPE,
          p_line_cd       IN giuw_wperilds_dtl.line_cd%TYPE,
          p_peril_cd      IN giuw_wperilds_dtl.peril_cd%TYPE,
          p_share_cd      IN giuw_wperilds_dtl.share_cd%TYPE,
          p_dist_spct     IN giuw_wperilds_dtl.dist_spct%TYPE,
          p_ann_dist_spct IN giuw_wperilds_dtl.ann_dist_spct%TYPE
          ,p_dist_spct1    IN giuw_wperilds_dtl.DIST_SPCT1%TYPE) IS --added dist_spct1 edgar 09/12/2014

  v_dist_tsi                 giuw_witemperilds_dtl.dist_tsi%TYPE;
  v_dist_prem                giuw_witemperilds_dtl.dist_prem%TYPE;
  v_ann_dist_tsi             giuw_witemperilds_dtl.ann_dist_tsi%TYPE;

BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010 
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : CREATE_PERIL_DFLT_WITEMPERILDS program unit 
  */
  
  FOR c2 IN (SELECT tsi_amt , prem_amt    , ann_tsi_amt ,
                    item_no
               FROM giuw_witemperilds
              WHERE peril_cd    = p_peril_cd
                AND line_cd     = p_line_cd
                AND dist_seq_no = p_dist_seq_no
                AND dist_no     = p_dist_no)
  LOOP

    /* Multiply the percentage values of table GIUW_WPERILDS_DTL
    ** with the values of columns belonging to table GIUW_WITEMPERILDS,
    ** to arrive at the correct break down of values in table
    ** GIUW_WITEMPERILDS_DTL. */
    v_dist_tsi     := ROUND(p_dist_spct/100     * c2.tsi_amt, 2);
    v_dist_prem    := ROUND(NVL(p_dist_spct1, p_dist_spct)/100     * c2.prem_amt, 2); --added dist_spct1 edgar 09/12/2014
    v_ann_dist_tsi := ROUND(p_ann_dist_spct/100 * c2.ann_tsi_amt, 2);

    INSERT INTO  giuw_witemperilds_dtl
                (dist_no         , dist_seq_no    , item_no     ,
                 line_cd         , peril_cd       , share_cd    ,
                 dist_spct       , dist_tsi       , dist_prem   ,
                 ann_dist_spct   , ann_dist_tsi   , dist_grp    , dist_spct1) --added dist_spct1 edgar 09/12/2014
         VALUES (p_dist_no       , p_dist_seq_no  , c2.item_no  ,
                 p_line_cd       , p_peril_cd     , p_share_cd  ,
                 p_dist_spct     , v_dist_tsi     , v_dist_prem ,
                 p_ann_dist_spct , v_ann_dist_tsi , 1           , p_dist_spct1); --added dist_spct1 edgar 09/12/2014

  END LOOP;
END;
/


