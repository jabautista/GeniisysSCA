CREATE OR REPLACE PACKAGE CPI.giacr218_pkg
AS
   TYPE giacr218_dtls_type IS RECORD (
      report_title        VARCHAR2 (200),
      report_date_title   VARCHAR2 (200),
      cf_co_name          VARCHAR2 (100),
      cf_co_address       VARCHAR2 (100),
      cf_toggle           VARCHAR2 (40),
      iss_cd              giac_prodrep_peril_ext.iss_cd%TYPE,
      iss_name            giis_issource.iss_name%TYPE,
      line_cd             giac_prodrep_peril_ext.line_cd%TYPE,
      line_name           giis_line.line_name%TYPE,
      subline_name        giis_subline.subline_name%TYPE,
      subline_cd          giis_subline.subline_cd%TYPE,
      policy_id           gipi_polbasic.policy_id%TYPE,
      policy_no           giac_prodrep_peril_ext.policy_no%TYPE
   );

   TYPE giacr218_dtls_tab IS TABLE OF giacr218_dtls_type;

   FUNCTION get_giacr218_dtls (
      p_from_date    DATE,
      p_to_date      DATE,
      p_toggle       VARCHAR2,
      p_iss_cd       giis_issource.iss_cd%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_user         giis_users.user_id%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE
   )
      RETURN giacr218_dtls_tab PIPELINED;

   TYPE giacr218_trtytitle_type IS RECORD (
      iss_cd      giac_prodrep_peril_ext.iss_cd%TYPE,
      line_cd     giac_prodrep_peril_ext.line_cd%TYPE,
      share_cd    giac_prodrep_peril_ext.share_cd%TYPE,
      trty_name   giac_prodrep_peril_ext.trty_name%TYPE
   );

   TYPE giacr218_trtytitle_tab IS TABLE OF giacr218_trtytitle_type;

   FUNCTION get_giacr218_trtytitle (
      p_user      giis_users.user_id%TYPE,
      p_iss_cd    giac_prodrep_peril_ext.iss_cd%TYPE,
      p_line_cd   giac_prodrep_peril_ext.line_cd%TYPE
   )
      RETURN giacr218_trtytitle_tab PIPELINED;

   TYPE giacr218_policyamt_type IS RECORD (
      iss_cd          giac_prodrep_peril_ext.iss_cd%TYPE,
      line_cd         giac_prodrep_peril_ext.line_cd%TYPE,
      subline_cd      giac_prodrep_peril_ext.subline_cd%TYPE,
      peril_sname     VARCHAR2(20),
      f_tr_dist_tsi   giac_prodrep_peril_ext.tr_dist_tsi%TYPE,
      tr_peril_tsi    giac_prodrep_peril_ext.tr_dist_tsi%TYPE,
      tr_peril_prem   giac_prodrep_peril_ext.tr_dist_prem%TYPE,
      trty_name       giac_prodrep_peril_ext.trty_name%TYPE
   );

   TYPE giacr218_policyamt_tab IS TABLE OF giacr218_policyamt_type;

   FUNCTION get_giacr218_polamt (
      p_user         giis_users.user_id%TYPE,
      p_iss_cd       giac_prodrep_peril_ext.iss_cd%TYPE,
      p_line_cd      giac_prodrep_peril_ext.line_cd%TYPE,
      p_subline_cd   giac_prodrep_peril_ext.subline_cd%TYPE,
      p_policy_no    giac_prodrep_peril_ext.policy_no%TYPE,
      p_toggle       VARCHAR2
   )
      RETURN giacr218_policyamt_tab PIPELINED;
END;
/


