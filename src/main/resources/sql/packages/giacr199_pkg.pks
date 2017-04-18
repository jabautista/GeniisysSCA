CREATE OR REPLACE PACKAGE CPI.giacr199_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company       VARCHAR2 (50),
      cf_com_address   VARCHAR2 (200),
      report_title     VARCHAR2 (50),
      date_label       VARCHAR2 (100),
      cf_date          giac_soa_rep_ext.param_date%TYPE,
      date_tag1         VARCHAR2 (300),   
      date_tag2        VARCHAR2 (200),
      date_tag3         VARCHAR2 (300),   
      date_tag4        VARCHAR2 (200),
      branch_name      giis_issource.iss_name%TYPE,
      intm_name        giac_soa_rep_ext.intm_name%TYPE,
      intm_no          giac_soa_rep_ext.intm_no%TYPE,
      intm_type        giac_soa_rep_ext.intm_type%TYPE,
      column_title     giac_soa_rep_ext.column_title%TYPE,
      incept_date      giac_soa_rep_ext.incept_date%TYPE,
      assd_no          giac_soa_rep_ext.assd_no%TYPE,
      assd_name        giac_soa_rep_ext.assd_name%TYPE,
      balance_amt_due  giac_soa_rep_ext.balance_amt_due%TYPE,
      policy_no        giac_soa_rep_ext.policy_no%TYPE,
      bill_no          VARCHAR2(20),
      due_date         giac_soa_rep_ext.due_date%TYPE,
      expiry_date      giac_soa_rep_ext.expiry_date%TYPE,
      no_of_days       giac_soa_rep_ext.no_of_days%TYPE,
      ref_pol_no       giac_soa_rep_ext.ref_pol_no%TYPE,
      prem_bal_due     giac_soa_rep_ext.prem_bal_due%TYPE,
      tax_bal_due      giac_soa_rep_ext.tax_bal_due%TYPE,
      iss_cd           giac_soa_rep_ext.iss_cd%TYPE,
      prem_seq_no      giac_soa_rep_ext.prem_seq_no%TYPE,
      branch_cd        giac_soa_rep_ext.branch_cd%TYPE,
      col_no           giac_soa_title.col_no%TYPE,
      input_vat_rate   giis_intermediary.input_vat_rate%TYPE,
      ref_intm         giis_intermediary.ref_intm_cd%TYPE,
      intm_add         VARCHAR2 (250),
      cf_comm_amt      NUMBER(16,2),
      cf_whtax         NUMBER(16,2),
      cf_input_vat_amt NUMBER(16,2),
      cf_net_amt       NUMBER(16,2),
      signatory_tag    GIAC_PARAMETERS.param_value_v%TYPE,
      label            giac_rep_signatory.label%TYPE,
      signatory        giis_signatory_names.signatory%TYPE,
      designation      giis_signatory_names.designation%TYPE
      
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_details(
        p_bal_amt_due   NUMBER,
        p_user          VARCHAR,
        p_intm_no       VARCHAR,
        p_intm_type     VARCHAR,
        p_branch_cd     VARCHAR,
        p_inc_overdue   VARCHAR,
        p_cut_off       VARCHAR
   )
      RETURN get_details_tab PIPELINED;
END;
/


