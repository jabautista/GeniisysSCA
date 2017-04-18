CREATE OR REPLACE PACKAGE CPI.gipir940_pkg
AS
   TYPE gipir940_record_type IS RECORD (
      tarf_cd           gipi_risk_profile.tarf_cd%TYPE,
      tarf_line         gipi_risk_profile.line_cd%TYPE,
      line_cd           gipi_risk_profile.line_cd%TYPE,
      range_from        NUMBER,
      range_to          NUMBER,
      policy_count      gipi_risk_profile.policy_count%TYPE,
      net_retention     gipi_risk_profile.net_retention%TYPE,
      quota_share       gipi_risk_profile.quota_share%TYPE,
      facultative       gipi_risk_profile.facultative%TYPE,
      treaty            gipi_risk_profile.treaty%TYPE,
      total             NUMBER,
      line_name         VARCHAR2 (100),
      tarf_desc         VARCHAR2 (100),
      cf_from           VARCHAR2 (100),
      cf_to             VARCHAR2 (100),
      company_name      VARCHAR2 (100),
      company_address   VARCHAR2 (100),
      title             VARCHAR2 (200),
      mjm               VARCHAR2 (1)
   );

   TYPE gipir940_record_tab IS TABLE OF gipir940_record_type;

   FUNCTION get_gipir940_record (
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_param_date      VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN gipir940_record_tab PIPELINED;
END;
/


