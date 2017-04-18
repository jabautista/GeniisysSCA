CREATE OR REPLACE PACKAGE CPI.csv_uw_risk_profile
AS
   TYPE get_gipir948_rec_type IS RECORD (
      line_cd                  gipi_risk_profile.line_cd%TYPE,
      subline_cd               gipi_risk_profile.subline_cd%TYPE,
      range_from               gipi_risk_profile.range_from%TYPE,
      range_to                 gipi_risk_profile.range_to%TYPE,
      policy_count             gipi_risk_profile.policy_count%TYPE,
      net_retention            gipi_risk_profile.net_retention%TYPE,
      net_retention_tsi        gipi_risk_profile.net_retention_tsi%TYPE,
      sec_net_retention_prem   gipi_risk_profile.sec_net_retention_prem%TYPE,
      sec_net_retention_tsi    gipi_risk_profile.sec_net_retention_tsi%TYPE,
      quota_share              gipi_risk_profile.quota_share%TYPE,
      quota_share_tsi          gipi_risk_profile.quota_share_tsi%TYPE,
      facultative              gipi_risk_profile.facultative%TYPE,
      facultative_tsi          gipi_risk_profile.facultative_tsi%TYPE,
      treaty_tsi               gipi_risk_profile.treaty_tsi%TYPE,
      treaty2_tsi              gipi_risk_profile.treaty2_tsi%TYPE,
      treaty3_tsi              gipi_risk_profile.treaty3_tsi%TYPE,
      treaty4_tsi              gipi_risk_profile.treaty4_tsi%TYPE,
      treaty5_tsi              gipi_risk_profile.treaty5_tsi%TYPE,
      treaty6_tsi              gipi_risk_profile.treaty6_tsi%TYPE,
      treaty7_tsi              gipi_risk_profile.treaty7_tsi%TYPE,
      treaty8_tsi              gipi_risk_profile.treaty8_tsi%TYPE,
      treaty9_tsi              gipi_risk_profile.treaty9_tsi%TYPE,
      treaty10_tsi             gipi_risk_profile.treaty10_tsi%TYPE,
      treaty_prem              gipi_risk_profile.treaty_prem%TYPE,
      treaty2_prem             gipi_risk_profile.treaty2_prem%TYPE,
      treaty3_prem             gipi_risk_profile.treaty3_prem%TYPE,
      treaty4_prem             gipi_risk_profile.treaty4_prem%TYPE,
      treaty5_prem             gipi_risk_profile.treaty5_prem%TYPE,
      treaty6_prem             gipi_risk_profile.treaty6_prem%TYPE,
      treaty7_prem             gipi_risk_profile.treaty7_prem%TYPE,
      treaty8_prem             gipi_risk_profile.treaty8_prem%TYPE,
      treaty9_prem             gipi_risk_profile.treaty9_prem%TYPE,
      treaty10_prem            gipi_risk_profile.treaty10_prem%TYPE,
      tarf_cd                  gipi_risk_profile.tarf_cd%TYPE,
      trty_name                gipi_risk_profile.trty_name%TYPE,
      trty2_name               gipi_risk_profile.trty2_name%TYPE,
      trty3_name               gipi_risk_profile.trty3_name%TYPE,
      trty4_name               gipi_risk_profile.trty4_name%TYPE,
      trty5_name               gipi_risk_profile.trty5_name%TYPE,
      trty6_name               gipi_risk_profile.trty6_name%TYPE,
      trty7_name               gipi_risk_profile.trty7_name%TYPE,
      trty8_name               gipi_risk_profile.trty8_name%TYPE,
      trty9_name               gipi_risk_profile.trty9_name%TYPE,
      trty10_name              gipi_risk_profile.trty10_name%TYPE
   );

   TYPE get_gipir948_tab IS TABLE OF get_gipir948_rec_type;

   TYPE dyn_sql_query IS RECORD (
      query1   VARCHAR2 (4000),
      query2   VARCHAR2 (4000),
      query3   VARCHAR2 (4000),
      query4   VARCHAR2 (4000),
      query5   VARCHAR2 (4000),
      query6   VARCHAR2 (4000),
      query7   VARCHAR2 (4000),
      query8   VARCHAR2 (4000)
   );

   TYPE dyn_sql_query_tab IS TABLE OF dyn_sql_query;

   FUNCTION get_rec_gipir948 (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN get_gipir948_tab PIPELINED;

   FUNCTION get_dynsql_gipir934 (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN dyn_sql_query_tab PIPELINED;

   FUNCTION get_dynsql_gipir941 (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN dyn_sql_query_tab PIPELINED;

   FUNCTION get_dynsql_gipir948 (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN dyn_sql_query_tab PIPELINED;

   FUNCTION get_dynsql_gipir949 (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN dyn_sql_query_tab PIPELINED;

   FUNCTION get_dynsql_gipir949b (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN dyn_sql_query_tab PIPELINED;

   FUNCTION get_dynsql_gipir949c (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN dyn_sql_query_tab PIPELINED;

   FUNCTION get_tariff_desc (p_tarf_cd VARCHAR2)
      RETURN VARCHAR2;
END csv_uw_risk_profile;
/


