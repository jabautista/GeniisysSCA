CREATE OR REPLACE PACKAGE CPI.GIACR500C_PKG
AS
   TYPE giacr500c_record_type IS RECORD (
      cf_company_name           VARCHAR2 (300),
      cf_company_add            VARCHAR2 (350),
      cf_date                   VARCHAR2 (50),
      fund_cd                   giac_trial_balance_summary.fund_cd%TYPE,
      branch_cd                 giac_trial_balance_summary.branch_cd%TYPE,
      branch_name               giac_branches.branch_name%TYPE,
      gl_acct_id                giac_trial_balance_summary.gl_acct_id%TYPE,
      gl_acct_name              giac_chart_of_accts.gl_acct_name%TYPE,
      gl_no                     VARCHAR2 (30),
      debit                     giac_trial_balance_summary.debit%TYPE,
      credit                    giac_trial_balance_summary.credit%TYPE,
      cname                     VARCHAR2 (1)
   );

   TYPE giacr500c_record_tab IS TABLE OF giacr500c_record_type;

   FUNCTION get_giacr500c_record (
      p_month    NUMBER,
      p_year     NUMBER,
      p_user_id  VARCHAR
   )
      RETURN giacr500c_record_tab PIPELINED;
END GIACR500C_PKG;
/


