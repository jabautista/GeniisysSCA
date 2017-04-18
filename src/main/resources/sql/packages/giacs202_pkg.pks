CREATE OR REPLACE PACKAGE CPI.giacs202_pkg
AS
   /* Create by : J. Diago
   ** Date Created : 07.31.2013
   ** Reference by : GIACS202 Bills by Assured and Age
   */
   TYPE giacs202_dtls_type IS RECORD (
      gagp_aging_id         giac_aging_summaries_v.gagp_aging_id%TYPE,
      a020_assd_no          giac_aging_summaries_v.a020_assd_no%TYPE,
      balance_amt_due       giac_aging_summaries_v.balance_amt_due%TYPE,
      assd_name             giis_assured.assd_name%TYPE,
      sum_balance_amt_due   giac_aging_summaries_v.balance_amt_due%TYPE,
      column_heading        giac_aging_parameters.column_heading%TYPE
   );

   TYPE giacs202_dtls_tab IS TABLE OF giacs202_dtls_type;

   FUNCTION get_giacs202_dtls (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_column_no   giac_aging_parameters.column_no%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giacs202_dtls_tab PIPELINED;

   TYPE giacs202_aging_list_type IS RECORD (
      gibr_gfun_fund_cd   giac_aging_totals_v.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd      giac_aging_totals_v.gibr_branch_cd%TYPE,
      column_heading      giac_aging_parameters.column_heading%TYPE,
      balance_amt_due     giac_aging_totals_v.balance_amt_due%TYPE
   );

   TYPE giacs202_aging_list_tab IS TABLE OF giacs202_aging_list_type;

   FUNCTION get_aging_list_dtls (
      p_fund_cd     giac_aging_totals_v.gibr_gfun_fund_cd%TYPE,
      p_branch_cd   giac_aging_totals_v.gibr_branch_cd%TYPE
   )
      RETURN giacs202_aging_list_tab PIPELINED;

   TYPE aging_level_lov_type IS RECORD (
      column_no        giac_aging_parameters.column_no%TYPE,
      column_heading   giac_aging_parameters.column_heading%TYPE
   );

   TYPE aging_level_lov_tab IS TABLE OF aging_level_lov_type;

   FUNCTION get_age_level_lov
      RETURN aging_level_lov_tab PIPELINED;

   TYPE branch_cd_lov_type IS RECORD (
      branch_cd     VARCHAR2 (50),
      branch_name   VARCHAR2 (200)
   );

   TYPE branch_cd_lov_tab IS TABLE OF branch_cd_lov_type;

   FUNCTION get_branch_cd_lov (p_fund_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN branch_cd_lov_tab PIPELINED;
END;
/


