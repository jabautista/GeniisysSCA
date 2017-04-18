CREATE OR REPLACE PACKAGE CPI.giacr510_pkg
AS
   TYPE giacr510_type IS RECORD (
      cf_company_name   VARCHAR2 (100),
      cf_date_basis     VARCHAR2 (100),
      cf_report_title   VARCHAR2 (100),
      cf_report_date    VARCHAR2 (100),
      budget_for_year   VARCHAR2 (100),
      gl_acct_name      giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_id        giac_chart_of_accts.gl_acct_id%TYPE,
      budget            giac_budget.budget%TYPE,
      curr_exp          giac_comp_expense_ext.curr_exp%TYPE,
      prev_exp          giac_comp_expense_ext.prev_exp%TYPE,
      cf_ic_period      giac_comp_expense_ext.curr_exp%TYPE,
      cf_ic_budget      giac_budget.budget%TYPE
   );

   TYPE giacr510_tab IS TABLE OF giacr510_type;

   FUNCTION get_giacr510_dtls (
      p_year        VARCHAR2,
      p_dt_basis    VARCHAR2,
      p_tran_flag   VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giacr510_tab PIPELINED;

   FUNCTION cf_ic_periodformula (
      p_curr_exp   giac_comp_expense_ext.curr_exp%TYPE,
      p_prev_exp   giac_comp_expense_ext.prev_exp%TYPE
   )
      RETURN NUMBER;

   FUNCTION cf_ic_budgetformula (
      p_curr_exp   giac_comp_expense_ext.curr_exp%TYPE,
      p_budget     giac_budget.budget%TYPE
   )
      RETURN NUMBER;
END;
/


