CREATE OR REPLACE PACKAGE CPI.cmpare_amts_wrking_tbls
AS
   PROCEDURE wpolicyds_vs_wpolicyds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   );

   PROCEDURE wperilds_vs_wperilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   );

   PROCEDURE witemds_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   );

   PROCEDURE witmprilds_vs_witmprilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   );

   PROCEDURE witmprlds_dtl_vs_wplicyds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   );

   PROCEDURE witmprilds_dtl_vs_wprilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   );

   PROCEDURE witmprilds_dtl_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   );

   PROCEDURE wpolicyds_dtl_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   );

   PROCEDURE wpolcyds_dtl_vs_wperilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   );
END cmpare_amts_wrking_tbls;
/


