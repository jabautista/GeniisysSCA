CREATE OR REPLACE FORCE VIEW cpi.giuw_witmds_itmds_dtl_v (dist_no,
                                                          dist_seq_no,
                                                          item_no,
                                                          line_cd,
                                                          share_cd,
                                                          dist_spct,
                                                          dist_tsi,
                                                          dist_prem,
                                                          ann_dist_spct,
                                                          ann_dist_tsi,
                                                          dist_grp,
                                                          dist_spct1
                                                         )
AS
   SELECT dist_no, dist_seq_no, item_no, line_cd, share_cd, dist_spct, dist_tsi, dist_prem, ann_dist_spct, ann_dist_tsi, dist_grp,
          dist_spct1
     FROM giuw_witemds_dtl
   UNION
   SELECT dist_no, dist_seq_no, item_no, line_cd, share_cd, dist_spct, dist_tsi, dist_prem, ann_dist_spct, ann_dist_tsi, dist_grp,
          dist_spct1
     FROM giuw_itemds_dtl;

CREATE OR REPLACE PUBLIC SYNONYM GIUW_WITMDS_ITMDS_DTL_V FOR CPI.GIUW_WITMDS_ITMDS_DTL_V;

GRANT SELECT ON CPI.GIUW_WITMDS_ITMDS_DTL_V TO PUBLIC;