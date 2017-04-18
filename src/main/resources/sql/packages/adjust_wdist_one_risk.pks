CREATE OR REPLACE PACKAGE CPI.adjust_wdist_one_risk
AS
   PROCEDURE adjust_witemperilds_dtl (p_dist_no giuw_pol_dist.dist_no%TYPE);

   PROCEDURE adjust_wpolicyds_dtl (p_dist_no giuw_pol_dist.dist_no%TYPE);

   PROCEDURE adjust_witemds_dtl (p_dist_no giuw_pol_dist.dist_no%TYPE);

   PROCEDURE adjust_wperilds_dtl (p_dist_no giuw_pol_dist.dist_no%TYPE);

   PROCEDURE adjust_tot_spct_to_100 (p_dist_no giuw_pol_dist.dist_no%TYPE);

   PROCEDURE adjust_share_wdistfrps (p_dist_no giuw_wpolicyds.dist_no%TYPE);
   
   PROCEDURE adjust_dist (p_dist_no   giuw_pol_dist.dist_no%TYPE);   
   
   PROCEDURE adjust_dist_one_risk (p_dist_no   giuw_pol_dist.dist_no%TYPE);
END adjust_wdist_one_risk;
/


