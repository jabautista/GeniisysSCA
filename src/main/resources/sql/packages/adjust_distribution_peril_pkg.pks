CREATE OR REPLACE PACKAGE CPI.adjust_distribution_peril_pkg
AS
   PROCEDURE adjust_peril_dtl (p_dist_no giuw_wperilds.dist_no%TYPE);

   PROCEDURE adjust_itemperil_dtl (p_dist_no giuw_witemperilds.dist_no%TYPE);

   PROCEDURE adjust_item_dtl (p_dist_no giuw_witemds.dist_no%TYPE);

   PROCEDURE adjust_pol_dtl (p_dist_no giuw_wpolicyds.dist_no%TYPE);

   PROCEDURE adjust_share (p_dist_no giuw_wpolicyds.dist_no%TYPE);

   PROCEDURE adjust_share_wdistfrps (p_dist_no giuw_wpolicyds.dist_no%TYPE);

   PROCEDURE recompute_before_adjust_share (
      p_dist_no   giuw_wpolicyds.dist_no%TYPE
   );

   PROCEDURE adjust_distribution (p_dist_no giuw_wpolicyds.dist_no%TYPE);
   
   PROCEDURE adjust_dist (p_dist_no   giuw_pol_dist.dist_no%TYPE);   
   
   --added by robert SR 5053 01.08.16 
   PROCEDURE rec_witemds_wpolicyds_dtls (p_dist_no   giuw_pol_dist.dist_no%TYPE); 
END adjust_distribution_peril_pkg;
/


