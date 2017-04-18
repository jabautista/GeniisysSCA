CREATE OR REPLACE PACKAGE CPI.giacr193_pkg
AS
   TYPE giacr193_soa_intm_wonet_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      report_title      giac_parameters.param_value_v%TYPE,
      date_label        giac_parameters.param_value_v%TYPE,
      extract_date      VARCHAR (100),
      dsp_name          VARCHAR (300),
      dsp_name2         VARCHAR (300),
      v_from_to         VARCHAR2 (1),
      intm_name         giac_soa_rep_ext.intm_name%TYPE,
      intm_no           giac_soa_rep_ext.intm_no%TYPE,
      intm_type         giac_soa_rep_ext.intm_type%TYPE,
      column_title      giac_soa_rep_ext.column_title%TYPE,
      assd_no           giac_soa_rep_ext.assd_no%TYPE,
      assd_name         giac_soa_rep_ext.assd_name%TYPE,
      balance_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      policy_no         giac_soa_rep_ext.policy_no%TYPE,
      bill_no           VARCHAR2 (50),
      incept_date       VARCHAR2 (100),
      expiry_date       VARCHAR2 (100),
      due_date          VARCHAR2 (100),
      no_of_days        giac_soa_rep_ext.no_of_days%TYPE,
      ref_pol_no        giac_soa_rep_ext.ref_pol_no%TYPE,
      prem_bal_due      giac_soa_rep_ext.prem_bal_due%TYPE,
      tax_bal_due       giac_soa_rep_ext.tax_bal_due%TYPE,
      branch_cd         giac_soa_rep_ext.branch_cd%TYPE,
      col_no            giac_soa_title.col_no%TYPE,
      iss_cd            giac_soa_rep_ext.iss_cd%TYPE,
      prem_seq_no       giac_soa_rep_ext.prem_seq_no%TYPE,
      branch_name       giis_issource.iss_name%TYPE,
      ref_intm_cd       giis_intermediary.ref_intm_cd%TYPE,
      intm_add          VARCHAR2 (250),
      plate_no          VARCHAR2 (10),
      label             giac_rep_signatory.LABEL%TYPE, --VARCHAR2 (100),	-- SR-4016 : shan 06.19.2015
      signatory         VARCHAR2 (100),
      designation       VARCHAR2 (100),
      soa_signatory     giac_parameters.param_value_v%type
   );

   TYPE giacr193_soa_intm_wonet_tab IS TABLE OF giacr193_soa_intm_wonet_type;

   FUNCTION get_giacr193_details (
      p_user_id       giac_soa_rep_ext.user_id%TYPE,
      p_intm_no       giac_soa_rep_ext.intm_no%TYPE,
      p_intm_type     giac_soa_rep_ext.intm_type%TYPE,
      p_branch_cd     giac_soa_rep_ext.branch_cd%TYPE,
      p_inc_overdue   giac_soa_rep_ext.due_tag%TYPE,
      p_bal_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE
   ) RETURN giacr193_soa_intm_wonet_tab PIPELINED;

   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2;

   FUNCTION get_cf_company_addformula
      RETURN VARCHAR2;

   FUNCTION get_cf_title_formula
      RETURN VARCHAR2;

   FUNCTION get_cf_date_labelformula
      RETURN VARCHAR2;

   FUNCTION get_cf_param_dateformula (p_user_id giac_soa_rep_ext.user_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_parameter_v_from_to
      RETURN VARCHAR2;

   FUNCTION get_cf_label
      RETURN VARCHAR2;

   FUNCTION get_cf_signatory
      RETURN VARCHAR2;

   FUNCTION get_cf_designation
      RETURN VARCHAR2;
	  
END giacr193_pkg;
/