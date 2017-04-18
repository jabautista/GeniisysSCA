CREATE OR REPLACE PACKAGE CPI.giacr197_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      report_title      VARCHAR2 (200),
      date_label        VARCHAR2 (100),
      report_date       DATE,
      date_tag1         VARCHAR2 (300),
      date_tag2         VARCHAR2 (200),
      date_tag3         VARCHAR2 (300),
      date_tag4         VARCHAR2 (200),
      branch_cd         giac_soa_rep_ext.branch_cd%TYPE,
      iss_name          giis_issource.iss_name%TYPE,
      assd_address      VARCHAR2 (250),
      cf_label          giac_rep_signatory.label%TYPE,
      signatory         giis_signatory_names.signatory%TYPE,
      designation       giis_signatory_names.designation%TYPE,
      assd_no           giac_soa_rep_ext.assd_no%TYPE,
      assd_name         giac_soa_rep_ext.assd_name%TYPE,
      column_title      giac_soa_title.col_title%TYPE,
      policy_no         giac_soa_rep_ext.policy_no%TYPE,
      incept_date       giac_soa_rep_ext.incept_date%TYPE,
      ref_pol_no        giac_soa_rep_ext.ref_pol_no%TYPE,
      bill_no           VARCHAR2 (100),
      due_date          giac_soa_rep_ext.due_date%TYPE,
      age               giac_soa_rep_ext.no_of_days%TYPE,
      prem_amt          giac_soa_rep_ext.prem_bal_due%TYPE,
      tax_amt           giac_soa_rep_ext.tax_bal_due%TYPE,
      balance_amt       giac_soa_rep_ext.balance_amt_due%TYPE,
      val               GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
      print_signatory   GIAC_PARAMETERS.PARAM_VALUE_V%TYPE
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giacr197_report (
      p_assd_no       NUMBER,
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_type     VARCHAR2,
      p_month         VARCHAR2,
      p_user          VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/


