CREATE OR REPLACE PACKAGE CPI.giacr480a_pkg
AS
   TYPE report_type IS RECORD (
      company_name          VARCHAR2 (200),
      company_address       VARCHAR2 (200),
      as_of_date            VARCHAR2 (100),
      sys_date              VARCHAR2 (100),
      employee_name         giac_sal_ded_billing_ext.employee_name%TYPE,
      employee_cd           giac_sal_ded_billing_ext.employee_cd%TYPE,
      prem_due              giac_sal_ded_billing_ext.prem_due%TYPE,
      month_year            VARCHAR2 (200),
      billing_advice_text   VARCHAR2 (500),
      extract_date          DATE,
      user_id               giac_sal_ded_billing_ext.user_id%TYPE,
      sys_date1             DATE
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giacr_480_a_report (
      p_as_of_date    VARCHAR2,
      p_company_cd    VARCHAR2,
      p_employee_cd   VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN report_tab PIPELINED;

   TYPE giacr480a_type IS RECORD (
      as_of_date          VARCHAR2 (100),
      pack_policy_no      giac_sal_ded_billing_ext.pack_policy_no%TYPE,
      line_name           giac_sal_ded_billing_ext.line_name%TYPE,
      employee_cd         giac_sal_ded_billing_ext.employee_cd%TYPE,
      assd_name           giac_sal_ded_billing_ext.assured_name%TYPE,
      in_acct_of          giac_sal_ded_billing_ext.in_acct_of%TYPE,
      company_name        giac_sal_ded_billing_ext.company_name%TYPE,
      employee_dept       giac_sal_ded_billing_ext.employee_dept%TYPE,
      policy_no           giac_sal_ded_billing_ext.policy_no%TYPE,
      incept_date         VARCHAR2 (100),
      expiry_date         VARCHAR2 (100),
      ref_no              giac_sal_ded_payt_ext.ref_no%TYPE,
      tran_date           VARCHAR2 (100),
      total_amt_due       giac_sal_ded_billing_ext.total_amt_due%TYPE,
      cf_prem_paid        NUMBER (16, 2),
      prem_balance        giac_sal_ded_billing_ext.prem_balance%TYPE,
      due_date            VARCHAR2 (100),
      prem_due            giac_sal_ded_billing_ext.prem_due%TYPE,
      amort_no            giac_sal_ded_billing_ext.amort_no%TYPE,
      billing_stmt_text   VARCHAR2 (500),
      company_cd          giac_sal_ded_billing_ext.company_cd%TYPE,
      iss_cd              giac_sal_ded_billing_ext.iss_cd%TYPE,
      user_id             giac_sal_ded_billing_ext.user_id%TYPE
   );

   TYPE giacr480a_tab IS TABLE OF giacr480a_type;

   FUNCTION get_giacr_480_a_details (
      p_as_of_date    VARCHAR2,
      p_company_cd    VARCHAR2,
      p_employee_cd   VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN giacr480a_tab PIPELINED;

   FUNCTION get_giacr_480_a_payt (
      p_as_of_date       VARCHAR2,
      p_company_cd       VARCHAR2,
      p_employee_cd      VARCHAR2,
      p_iss_cd           VARCHAR2,
      p_user_id          VARCHAR2,
      p_line_name        VARCHAR2,
      p_policy_no        VARCHAR2,
      p_pack_policy_no   VARCHAR2
   )
      RETURN giacr480a_tab PIPELINED;
END;
/


