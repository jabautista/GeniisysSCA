CREATE OR REPLACE PACKAGE CPI.giacr191_pkg
AS
   rep_date_format   VARCHAR2 (20);

   TYPE report_header_type IS RECORD (
      company_name        giac_parameters.param_value_v%TYPE,
      company_address     giac_parameters.param_value_v%TYPE,
      print_company       GIAC_PARAMETERS.param_value_v%TYPE, --VARCHAR2 (1),	-- SR-4040 : shan 06.19.2015
      title               GIAC_PARAMETERS.param_value_v%TYPE, --VARCHAR2 (100),	-- SR-4040 : shan 06.19.2015
      date_label          GIAC_PARAMETERS.param_value_v%TYPE, --VARCHAR2 (100),	-- SR-4040 : shan 06.19.2015
      paramdate           DATE,
      date_tag1           VARCHAR2 (300),
      date_tag2           VARCHAR2 (300),
      print_date_tag      GIAC_PARAMETERS.param_value_v%TYPE, --VARCHAR2 (1),	-- SR-4040 : shan 06.19.2015
      rundate             VARCHAR2 (20),
      print_footer_date   VARCHAR2 (1),
      print_user_id       VARCHAR2 (1),
      label               giac_rep_signatory.LABEL%TYPE,-- VARCHAR2 (100),	-- SR-4040 : shan 06.19.2015
      signatory           VARCHAR2 (100),
      designation         VARCHAR2 (100),
      print_signatory     GIAC_PARAMETERS.param_value_v%TYPE --VARCHAR2 (1)	-- SR-4040 : shan 06.19.2015
   );

   TYPE report_header_tab IS TABLE OF report_header_type;

   FUNCTION get_report_header (p_user_id giac_soa_rep_ext.user_id%TYPE)
      RETURN report_header_tab PIPELINED;

   PROCEDURE beforereport;

   FUNCTION cf_company_name
      RETURN VARCHAR2;

   FUNCTION cf_company_address
      RETURN VARCHAR2;

   FUNCTION cf_title
      RETURN VARCHAR2;

   FUNCTION cf_date_label
      RETURN VARCHAR2;

   FUNCTION cf_date (p_user_id giac_soa_rep_ext.user_id%TYPE)
      RETURN DATE;

   FUNCTION cf_date_tag1 (p_user_id giac_soa_rep_ext.user_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION cf_date_tag2 (p_user_id giac_soa_rep_ext.user_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION cf_label
      RETURN VARCHAR2;

   FUNCTION cf_signatory
      RETURN VARCHAR2;

   FUNCTION cf_designation
      RETURN VARCHAR2;

   TYPE report_parent_type IS RECORD (
      branch_cd         giac_soa_rep_ext.branch_cd%TYPE,
      cf_branch         giac_branches.branch_name%TYPE,
      assd_no           giac_soa_rep_ext.assd_no%TYPE,
      assd_name         giac_soa_rep_ext.assd_name%TYPE,
      policy_no         giac_soa_rep_ext.policy_no%TYPE,
      incept_date       VARCHAR2 (20),
      ref_pol_no        giac_soa_rep_ext.ref_pol_no%TYPE,
      intm_name         giac_soa_rep_ext.intm_name%TYPE,
      bill_no           VARCHAR2 (30),
      due_date          VARCHAR2 (20),
      prem_bal_due      giac_soa_rep_ext.prem_bal_due%TYPE,
      tax_bal_due       giac_soa_rep_ext.tax_bal_due%TYPE,
      balance_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      column_title      giac_soa_rep_ext.column_title%TYPE,
      column_no         giac_soa_rep_ext.column_no%TYPE
   );

   TYPE report_parent_tab IS TABLE OF report_parent_type;

   FUNCTION get_report_parent_details (
      p_branch_cd     giac_soa_rep_ext.branch_cd%TYPE,
      p_assd_no       giac_soa_rep_ext.assd_no%TYPE,
      p_inc_overdue   giac_soa_rep_ext.due_tag%TYPE,
      p_user          giac_soa_rep_ext.user_id%TYPE
   )
      RETURN report_parent_tab PIPELINED;

   TYPE col_no_header_type IS RECORD (
      col_no      giac_soa_title.col_no%TYPE,
      col_title   giac_soa_title.col_title%TYPE
   );

   TYPE col_no_header_tab IS TABLE OF col_no_header_type;

   FUNCTION get_col_no_header
      RETURN col_no_header_tab PIPELINED;

   TYPE col_no_details_type IS RECORD (
      branch_cd         giac_soa_rep_ext.branch_cd%TYPE,
      assd_no           giac_soa_rep_ext.assd_no%TYPE,
      policy_no         giac_soa_rep_ext.policy_no%TYPE,
      intm_name         giac_soa_rep_ext.intm_name%TYPE,
      bill_no           VARCHAR2 (30),
      balance_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      column_title      giac_soa_rep_ext.column_title%TYPE
   );

   TYPE col_no_details_tab IS TABLE OF col_no_details_type;

   FUNCTION get_report_col_no_details (
      p_branch_cd     giac_soa_rep_ext.branch_cd%TYPE,
      p_assd_no       giac_soa_rep_ext.assd_no%TYPE,
      p_inc_overdue   giac_soa_rep_ext.due_tag%TYPE,
      p_user          giac_soa_rep_ext.user_id%TYPE,
      p_policy_no     giac_soa_rep_ext.policy_no%TYPE,
      p_bill_no       VARCHAR2
   )
      RETURN col_no_details_tab PIPELINED;

   TYPE report_total_type IS RECORD (
      branch_cd         giac_soa_rep_ext.branch_cd%TYPE,
      assd_no           giac_soa_rep_ext.assd_no%TYPE,
      balance_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      column_title      giac_soa_rep_ext.column_title%TYPE
   );

   TYPE report_total_tab IS TABLE OF report_total_type;

   FUNCTION get_report_totals (
      p_branch_cd     giac_soa_rep_ext.branch_cd%TYPE,
      p_assd_no       giac_soa_rep_ext.assd_no%TYPE,
      p_inc_overdue   giac_soa_rep_ext.due_tag%TYPE,
      p_user          giac_soa_rep_ext.user_id%TYPE
   )
      RETURN report_total_tab PIPELINED;

   TYPE apdc_details_type IS RECORD (
      apdc_number      VARCHAR2 (50),
      apdc_date        VARCHAR2 (20),
      bank_cd          giac_apdc_payt_dtl.bank_cd%TYPE,
      bank_sname       giac_banks.bank_sname%TYPE,
      bank_branch      giac_apdc_payt_dtl.bank_branch%TYPE,
      check_no         VARCHAR2 (50),
      check_date       VARCHAR2 (20),
      check_amt        VARCHAR2 (50),
      iss_cd           giac_pdc_prem_colln.iss_cd%TYPE,
      prem_seq_no      giac_pdc_prem_colln.prem_seq_no%TYPE,
      inst_no          giac_pdc_prem_colln.inst_no%TYPE,
      bill_no          VARCHAR2 (50),
      collection_amt   VARCHAR2 (50),
      intm_type        giac_soa_rep_ext.intm_type%TYPE,
      apdc_pref        giac_apdc_payt.apdc_pref%TYPE,
      branch_cd        giac_apdc_payt.branch_cd%TYPE,
      apdc_no          giac_apdc_payt.apdc_no%TYPE,
      assd_no          giac_soa_rep_ext.assd_no%TYPE
   );

   TYPE apdc_details_tab IS TABLE OF apdc_details_type;

   FUNCTION get_report_apdc_details (
      p_branch_cd   giac_soa_rep_ext.branch_cd%TYPE,
      p_assd_no     giac_soa_rep_ext.assd_no%TYPE,
      p_user        giac_soa_rep_ext.user_id%TYPE,
      p_cut_off     VARCHAR2
   )
      RETURN apdc_details_tab PIPELINED;
      
   TYPE csv_col_type IS RECORD (
      col_name VARCHAR2(100)
   );
   
   TYPE csv_col_tab IS TABLE OF csv_col_type;
       
   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED;
         
END giacr191_pkg;
/