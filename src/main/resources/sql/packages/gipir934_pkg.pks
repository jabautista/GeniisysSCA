CREATE OR REPLACE PACKAGE CPI.gipir934_pkg
AS
   TYPE gipir934_record_type IS RECORD (
      line_cd           gipi_risk_profile.line_cd%TYPE,
      subline_cd        gipi_risk_profile.subline_cd%TYPE,
      range_from        gipi_risk_profile.range_from%TYPE,
      range_to          gipi_risk_profile.range_to%TYPE,
      policy_count      gipi_risk_profile.policy_count%TYPE,
      tarf_cd           gipi_risk_profile.tarf_cd%TYPE,
      peril_cd          gipi_risk_profile.peril_cd%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      peril_tsi         gipi_risk_profile.peril_tsi%TYPE,
      peril_prem        gipi_risk_profile.peril_prem%TYPE,
      peril_type        giis_peril.peril_type%TYPE,
      tsi_amt           NUMBER,
      company_name      VARCHAR2 (100),
      company_address   VARCHAR2 (100),
      title             VARCHAR2 (200),
      line_name         VARCHAR2 (100),
      subline_name      VARCHAR2 (100),
      tarf_name         VARCHAR2 (100),
      mjm               VARCHAR2 (1),
      line_cd_fi        giis_line.LINE_CD%type
   );

   TYPE gipir934_record_tab IS TABLE OF gipir934_record_type;
   
    TYPE detail_record_type IS RECORD (
      line_cd           gipi_risk_profile.line_cd%TYPE,
      subline_cd        gipi_risk_profile.subline_cd%TYPE,
      range_from        gipi_risk_profile.range_from%TYPE,
      range_to          gipi_risk_profile.range_to%TYPE,
      policy_count      gipi_risk_profile.policy_count%TYPE,
      tarf_cd           gipi_risk_profile.tarf_cd%TYPE,
      peril_cd          gipi_risk_profile.peril_cd%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      peril_tsi         gipi_risk_profile.peril_tsi%TYPE,
      peril_prem        gipi_risk_profile.peril_prem%TYPE,
      peril_type        giis_peril.peril_type%TYPE,
      tsi_amt           NUMBER,
      title             VARCHAR2 (200),
      line_name         VARCHAR2 (100),
      subline_name      VARCHAR2 (100),
      tarf_name         VARCHAR2 (100),
      mjm               VARCHAR2 (1)
   );

   TYPE detail_record_tab IS TABLE OF detail_record_type;

   FUNCTION get_gipir934_record (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_paramdate    VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir934_record_tab PIPELINED;
      
   FUNCTION get_detail_record (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_paramdate    VARCHAR2,
      p_user_id      VARCHAR2,
      p_tarf_cd     VARCHAR2
   )
      RETURN detail_record_tab PIPELINED;
      
   FUNCTION cf_2formula (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_paramdate    VARCHAR2,
      p_user_id      VARCHAR2,
      p_range_from   NUMBER,
      p_range_to     NUMBER
   )  RETURN NUMBER;
END;
/


