CREATE OR REPLACE PACKAGE CPI.giacr480b_pkg
AS
   TYPE report_type IS RECORD (
      cf_company_name     VARCHAR2 (200),
      company_address     VARCHAR2 (200),
      billing_stmt_text   VARCHAR2 (500),
      company_name        giac_sal_ded_billing_ext.company_name%TYPE,
      employee_cd         giac_sal_ded_billing_ext.employee_cd%TYPE,
      assd_name           giac_sal_ded_billing_ext.assured_name%TYPE,
      in_acct_of          giac_sal_ded_billing_ext.in_acct_of%TYPE,
      pack_policy_no      giac_sal_ded_billing_ext.pack_policy_no%TYPE,
      policy_no           giac_sal_ded_billing_ext.policy_no%TYPE,
      incept_date         giac_sal_ded_billing_ext.incept_date%TYPE,
      prem_amt            giac_sal_ded_billing_ext.prem_amt%TYPE,
      tax_amt             giac_sal_ded_billing_ext.tax_amt%TYPE,
      total_amt_due       giac_sal_ded_billing_ext.total_amt_due%TYPE,
      prem_paid           NUMBER (16, 2),
      prem_balance        giac_sal_ded_billing_ext.prem_balance%TYPE,
      prem_due            giac_sal_ded_billing_ext.prem_due%TYPE,
      amort_no            giac_sal_ded_billing_ext.amort_no%TYPE,
      as_of_date          VARCHAR2 (100),
      extract_date        DATE,
      user_id             giac_sal_ded_billing_ext.user_id%TYPE,
      sys_date1           DATE
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giacr_480_b_report (
      p_as_of_date    VARCHAR2,
      p_company_cd    VARCHAR2,
      p_employee_cd   VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/


