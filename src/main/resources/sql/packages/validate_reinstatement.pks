CREATE OR REPLACE PACKAGE CPI.validate_reinstatement
AS
   PROCEDURE check_paid_policy (
      p_policy_id   IN       gipi_polbasic.policy_id%TYPE,
      p_iss_cd      IN       gipi_polbasic.iss_cd%TYPE,
      p_msge1       OUT      VARCHAR2,
      p_msge2       OUT      VARCHAR2,
      p_msge3       OUT      BOOLEAN
   );

   PROCEDURE check_reinsurance_payment (
      p_policy_id   IN       gipi_polbasic.policy_id%TYPE,
      p_line_cd     IN       gipi_polbasic.line_cd%TYPE,
      p_msge1       OUT      VARCHAR2,
      p_msge2       OUT      VARCHAR2,
      p_msge3       OUT      BOOLEAN
   );

   PROCEDURE validate_renewal_policy (
      p_line_cd      IN       giex_expiry.line_cd%TYPE,
      p_subline_cd   IN       giex_expiry.subline_cd%TYPE,
      p_iss_cd       IN       giex_expiry.iss_cd%TYPE,
      p_issue_yy     IN       giex_expiry.issue_yy%TYPE,
      p_pol_seq_no   IN       giex_expiry.pol_seq_no%TYPE,
      p_renew_no     IN       giex_expiry.renew_no%TYPE,
      p_renew        IN       giis_parameters.param_value_v%TYPE,
      p_alert        OUT      VARCHAR2
   );

   PROCEDURE validate_renewal_pack_policy (
      p_line_cd      IN       giex_expiry.line_cd%TYPE,
      p_subline_cd   IN       giex_expiry.subline_cd%TYPE,
      p_iss_cd       IN       giex_expiry.iss_cd%TYPE,
      p_issue_yy     IN       giex_expiry.issue_yy%TYPE,
      p_pol_seq_no   IN       giex_expiry.pol_seq_no%TYPE,
      p_renew_no     IN       giex_expiry.renew_no%TYPE,
      p_renew        IN       giis_parameters.param_value_v%TYPE,
      p_alert        OUT      VARCHAR2
   );

   PROCEDURE check_acct_ent_date (
      p_acct_ent_date         gipi_polbasic.acct_ent_date%TYPE,
      p_restrict              giis_parameters.param_value_v%TYPE,
      p_msge1           OUT   VARCHAR2,
      p_msge2           OUT   VARCHAR2,
      p_msge3           OUT   BOOLEAN
   );
      PROCEDURE check_pack_acct_ent_date(
      p_acct_ent_date   gipi_polbasic.acct_ent_date%TYPE,
      p_restrict        giis_parameters.param_value_v%TYPE,
      p_msge1       OUT      VARCHAR2,
      p_msge2       OUT      VARCHAR2,
      p_msge3       OUT      BOOLEAN
   );
END validate_reinstatement;
/


