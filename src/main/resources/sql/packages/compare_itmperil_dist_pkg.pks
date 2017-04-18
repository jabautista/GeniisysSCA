CREATE OR REPLACE PACKAGE CPI.compare_itmperil_dist_pkg
AS
   PROCEDURE compare_itmperil_to_ds (
      p_par_id    IN       gipi_witmperl.par_id%TYPE,
      p_dist_no   IN       giuw_perilds_dtl.dist_no%TYPE,
      p_balance   OUT      VARCHAR2
   );
    
   PROCEDURE get_peril_type (
      p_line_cd   IN       giis_peril.line_cd%TYPE,
      p_peril_cd  IN       giis_peril.peril_cd%TYPE,
      p_peril_type  OUT    giis_peril.peril_type%TYPE
   );
   
   PROCEDURE get_expiry (
      p_line_cd    IN       giuw_wperilds_dtl.line_cd%TYPE,
      p_share_cd   IN       giuw_wperilds_dtl.share_cd%TYPE,
      p_par_id     IN       giuw_pol_dist.par_id%TYPE,
      p_treaty     OUT      VARCHAR2,
      p_expired    OUT      VARCHAR2
   );
   
   PROCEDURE compare_recompute_dist (
      p_dist_no      IN         giuw_pol_dist.DIST_NO%TYPE,
      p_msg_alert    OUT      VARCHAR2
   );
   
   PROCEDURE get_takeup_term (
      p_par_id      IN     gipi_parlist.par_id%TYPE,
      p_takeup_term OUT    gipi_wpolbas.TAKEUP_TERM%TYPE
   );
   
   PROCEDURE get_policy_takeup (
      p_policy_id      IN     gipi_polbasic.policy_id%TYPE,
      p_takeup_term OUT    gipi_wpolbas.TAKEUP_TERM%TYPE
   );
   
   PROCEDURE compare_pol_itmperil_to_ds (
      p_policy_id    IN       gipi_polbasic.policy_id%TYPE,
      p_dist_no      IN       giuw_perilds_dtl.dist_no%TYPE,
      p_balance      OUT      VARCHAR2
   );   
END compare_itmperil_dist_pkg;
/


