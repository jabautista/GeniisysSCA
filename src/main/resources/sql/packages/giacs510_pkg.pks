CREATE OR REPLACE PACKAGE CPI.giacs510_pkg
AS
   TYPE giacs510_list IS RECORD (
      YEAR               giac_budget.YEAR%TYPE,
      gl_acct_id         giac_budget.gl_acct_id%TYPE,
      dtl_acct_id        giac_budget_dtl.dtl_acct_id%TYPE,
      budget             giac_budget.budget%TYPE,
      remarks            giac_budget.remarks%TYPE,
      user_id            giac_budget.user_id%TYPE,
      last_update        VARCHAR2 (50),
      gl_account_no      VARCHAR2 (100),
      gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
   );

   TYPE giacs510_year_list_tab IS TABLE OF giacs510_list;

   FUNCTION get_budget_year_list (p_year giac_budget.YEAR%TYPE)
      RETURN giacs510_year_list_tab PIPELINED;

   FUNCTION get_budget_peryear_list (
      p_year            giac_budget.YEAR%TYPE,
      p_gl_account_no   VARCHAR2,
      p_gl_acct_name    giac_chart_of_accts.gl_acct_name%TYPE,
      p_budget          giac_budget.budget%TYPE
   )
      RETURN giacs510_year_list_tab PIPELINED;

   PROCEDURE val_add_budgetyear (p_year giac_budget.YEAR%TYPE);

   TYPE year_list_lov IS RECORD (
      YEAR   giac_budget.YEAR%TYPE
   );

   TYPE year_list_lov_tab IS TABLE OF year_list_lov;

   FUNCTION get_budgetyear_lov
      RETURN year_list_lov_tab PIPELINED;

   PROCEDURE copy_budget (
      p_year          VARCHAR2,
      p_copied_year   VARCHAR2,
      p_user_id       VARCHAR2
   );

   TYPE gl_acctno_lov IS RECORD (
      gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      gl_account_no      VARCHAR2 (100),
      gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
   );

   TYPE gl_acctno_lov_tab IS TABLE OF gl_acctno_lov;

   FUNCTION get_glacct_lov (
      p_table              VARCHAR2,
      p_year               VARCHAR2,
      p_gl_account_no      VARCHAR2,
      p_gl_acct_name       VARCHAR2,
      p_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      p_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
   )
      RETURN gl_acctno_lov_tab PIPELINED;

   PROCEDURE delete_budget (
      p_year         giac_budget.YEAR%TYPE,
      p_gl_acct_id   giac_chart_of_accts.gl_acct_id%TYPE
   );

   PROCEDURE val_delete_budget_peryear (
      p_gl_acct_id   giac_chart_of_accts.gl_acct_id%TYPE,
      p_year         giac_budget.year%TYPE
   );

   PROCEDURE set_budget_peryear (
      p_year         giac_budget.YEAR%TYPE,
      p_gl_acct_id   giac_chart_of_accts.gl_acct_id%TYPE,
      p_budget       giac_budget.budget%TYPE,
      p_remarks      giis_cargo_type.remarks%TYPE,
      p_user_id      giis_users.user_id%TYPE
   );

   TYPE validate_glacctno_type IS RECORD (
      exist          VARCHAR2 (1),
      gl_acct_id     giac_chart_of_accts.gl_acct_id%TYPE,
      gl_acct_name   giac_chart_of_accts.gl_acct_name%TYPE
   );

   TYPE validate_glacctno_tab IS TABLE OF validate_glacctno_type;

   FUNCTION validate_glacctno (
      p_year               giac_budget.YEAR%TYPE,
      p_table              VARCHAR2,
      p_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      p_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
   )
      RETURN validate_glacctno_tab PIPELINED;

   TYPE giacs510__dtl_list IS RECORD (
      YEAR               giac_budget.YEAR%TYPE,
      gl_acct_id         giac_budget.gl_acct_id%TYPE,
      dtl_acct_id        giac_budget_dtl.dtl_acct_id%TYPE,
      gl_account_no      VARCHAR2 (100),
      gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
   );

   TYPE giacs510__dtl_list_tab IS TABLE OF giacs510__dtl_list;

   FUNCTION get_budgetdtl_peryear_list (
      p_year            giac_budget.YEAR%TYPE,
      p_gl_acct_id      giac_budget.gl_acct_id%TYPE,
      p_gl_account_no   VARCHAR2,
      p_gl_acct_name    giac_chart_of_accts.gl_acct_name%TYPE
   )
      RETURN giacs510__dtl_list_tab PIPELINED;

   PROCEDURE set_budgetdtl_peryear (
      p_year          giac_budget.YEAR%TYPE,
      p_gl_acct_id    giac_chart_of_accts.gl_acct_id%TYPE,
      p_dtl_acct_id   giac_budget_dtl.dtl_acct_id%TYPE,
      p_user_id       giis_users.user_id%TYPE
   );

   PROCEDURE delete_budgetdtl (
      p_year          giac_budget.YEAR%TYPE,
      p_gl_acct_id    giac_chart_of_accts.gl_acct_id%TYPE,
      p_dtl_acct_id   giac_budget_dtl.dtl_acct_id%TYPE
   );

   TYPE check_exists_type IS RECORD (
      exist   VARCHAR2 (1)
   );

   TYPE check_exists_tab IS TABLE OF check_exists_type;

   FUNCTION check_exist_giacs510 (p_year giac_budget.YEAR%TYPE)
      RETURN check_exists_tab PIPELINED;

   PROCEDURE extract_giacs510 (
      p_year         IN       VARCHAR,
      p_date_basis   IN       VARCHAR,
      p_tran_flag    IN       VARCHAR,
      p_user_id      IN       VARCHAR,
      p_exists       OUT      NUMBER
   );

   TYPE gl_nodtl_type IS RECORD (
      gl_account_no   VARCHAR2 (100),
      gl_acct_name    giac_chart_of_accts.gl_acct_name%TYPE
   );

   TYPE gl_nodtl_tab IS TABLE OF gl_nodtl_type;

   FUNCTION get_gl_nodtl (
      p_year            giac_budget.YEAR%TYPE,
      p_gl_account_no   VARCHAR2,
      p_gl_acct_name    giac_chart_of_accts.gl_acct_name%TYPE
   )
      RETURN gl_nodtl_tab PIPELINED;
END;
/


