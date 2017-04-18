CREATE OR REPLACE PACKAGE cpi.gipir941_pkg
AS
   TYPE gipir941_record_type IS RECORD (
      tarf_cd           gipi_risk_profile.tarf_cd%TYPE,
      line_cd           gipi_risk_profile.line_cd%TYPE,
      subline_cd        gipi_risk_profile.subline_cd%TYPE,
      range_from        gipi_risk_profile.range_from%TYPE,
      range_to          gipi_risk_profile.range_to%TYPE,
      policy_count      gipi_risk_profile.policy_count%TYPE,
      net_retention     gipi_risk_profile.net_retention%TYPE,
      quota_share       gipi_risk_profile.quota_share%TYPE,
      facultative       gipi_risk_profile.facultative%TYPE,
      treaty            gipi_risk_profile.treaty%TYPE,
      line_name         VARCHAR2 (100),
      subline_name      VARCHAR2 (100),
      tarf_desc         VARCHAR2 (100),
      cf_from           VARCHAR2 (100),
      cf_to             VARCHAR2 (100),
      company_name      VARCHAR2 (100),
      company_address   VARCHAR2 (100),
      title             VARCHAR2 (200),
      mjm               VARCHAR2 (1)
   );

   TYPE gipir941_record_tab IS TABLE OF gipir941_record_type;

   FUNCTION get_gipir941_record (
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_all_line_tag    VARCHAR2, --benjo 05.22.2015 UW-SPECS-2015-047
      p_by_tarf         VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN gipir941_record_tab PIPELINED;
END;