CREATE OR REPLACE PACKAGE CPI.cmpare_del_rnsrt_wdist_tables
AS
   PROCEDURE wperilds_vs_wperilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   );

   PROCEDURE witemds_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   );

   PROCEDURE witmprilds_vs_witmprilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   );

   PROCEDURE witmprlds_dtl_vs_wplicyds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   );

   PROCEDURE witmprilds_dtl_vs_wprilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   );

   PROCEDURE witmprilds_dtl_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   );

   PROCEDURE wpolicyds_dtl_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   );

   PROCEDURE wpolcyds_dtl_vs_wperilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   );

   PROCEDURE del_rnsrt_wdist_tables (p_dist_no IN giuw_pol_dist.dist_no%TYPE);
END cmpare_del_rnsrt_wdist_tables;
/


