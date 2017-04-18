DROP VIEW CPI.GIUW_WPOLICYDS_POLICYDS_DTL_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giuw_wpolicyds_policyds_dtl_v (dist_no,
                                                                dist_seq_no,
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
   SELECT dist_no, dist_seq_no, line_cd, share_cd, dist_spct, dist_tsi,
          dist_prem, ann_dist_spct, ann_dist_tsi, dist_grp, dist_spct1
     FROM giuw_wpolicyds_dtl
   UNION
   SELECT dist_no, dist_seq_no, line_cd, share_cd, dist_spct, dist_tsi,
          dist_prem, ann_dist_spct, ann_dist_tsi, dist_grp, dist_spct1
     FROM giuw_policyds_dtl;


