CREATE OR REPLACE PACKAGE CPI.GIACR500AE_PKG
AS
   TYPE giacr500ae_record_type IS RECORD (
      cf_company_name           VARCHAR2 (300),
      cf_company_add            VARCHAR2 (350),
      cf_date                   VARCHAR2 (50),
      branch_cd                 giac_trial_balance_v.branch_cd%TYPE,
      branch_name               giac_branches.branch_name%TYPE,
      gl_acct_id                giac_trial_balance_v.gl_acct_id%TYPE,
      gl_acct_no_formatted      giac_trial_balance_v.gl_acct_no_formatted%TYPE,
      gl_acct_name              giac_trial_balance_v.gl_acct_name%TYPE,
      YEAR                      giac_trial_balance_v.tran_year%TYPE,
      MONTH                     giac_trial_balance_v.tran_mm%TYPE,
      debit                     giac_trial_balance_v.trans_debit_bal%TYPE,
      credit                    giac_trial_balance_v.trans_credit_bal%TYPE,
      adj_debit                 giac_trial_balance_v.trans_debit_bal%TYPE,
      adj_credit                giac_trial_balance_v.trans_credit_bal%TYPE,
      cname                     VARCHAR (1),
      cf_unadj_credit           giac_monthly_totals.trans_debit_bal%TYPE,
      cf_unadj_debit            giac_monthly_totals.trans_debit_bal%TYPE
   );

   TYPE giacr500ae_record_tab IS TABLE OF giacr500ae_record_type;

   FUNCTION get_giacr500ae_record (
      p_month    NUMBER,
      p_year     NUMBER,
      p_branch   VARCHAR
   )
      RETURN giacr500ae_record_tab PIPELINED;
END GIACR500AE_PKG;
/


