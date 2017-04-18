CREATE OR REPLACE PACKAGE CPI.GIACR191P_PKG AS 

  TYPE giacr191p_type IS RECORD (
    company_name    giis_parameters.param_value_v%TYPE,
    company_address giis_parameters.param_value_v%TYPE,
    soa_date_label  giis_parameters.param_value_v%TYPE,
    cutoff_date     VARCHAR2(100),
    title           giac_parameters.param_value_v%TYPE, --VARCHAR2(100),	-- SR-4040 : shan 06.19.2015
    date_tag        VARCHAR2(100),
    date_tag2       VARCHAR2(100),
    signatory       giis_signatory_names.SIGNATORY%TYPE, --VARCHAR2(100),	-- SR-4040 : shan 06.19.2015
    designation     giis_signatory_names.DESIGNATION%TYPE, --VARCHAR2(100),	-- SR-4040 : shan 06.19.2015
    sign_label      giac_rep_signatory.LABEL%TYPE, --VARCHAR2(100),			-- SR-4040 : shan 06.19.2015
    print_signatory giac_parameters.param_value_v%type
  );

  TYPE giacr191p_tab IS TABLE OF giacr191p_type;
  
  FUNCTION populate_giacr191p(
    p_user      VARCHAR2
  ) RETURN giacr191p_tab PIPELINED;

  TYPE giacr191p_details_type IS RECORD (
    policy_no           giac_soa_rep_ext.policy_no%TYPE,
    branch_cd           giac_soa_rep_ext.branch_cd%TYPE,
    intm_name           giac_soa_rep_ext.intm_name%TYPE,
    intm_type           giac_soa_rep_ext.intm_type%TYPE,
    assd_no             VARCHAR2(30),
    ref_pol_no          giac_soa_rep_ext.ref_pol_no%TYPE,
    bill_no             VARCHAR2(30),
    assd_name           giac_soa_rep_ext.assd_name%TYPE,
    prem_bal_due        giac_soa_rep_ext.prem_bal_due%TYPE,
    tax_bal_due         giac_soa_rep_ext.tax_bal_due%TYPE,
    balance_amt_due     giac_soa_rep_ext.balance_amt_due%TYPE,
    aging_id            giac_soa_rep_ext.aging_id%TYPE,
    no_of_days          giac_soa_rep_ext.no_of_days%TYPE,
    due_date            DATE,
    column_no           giac_soa_rep_ext.column_no%TYPE,
    column_title        giac_soa_rep_ext.column_title%TYPE,
    remarks             VARCHAR2(2000),
    branch_name         giac_branches.branch_name%TYPE,
    user_id             giac_soa_rep_ext.user_id%TYPE,
    due_tag             giac_soa_rep_ext.due_tag%TYPE
  );

  TYPE giacr191p_details_tab IS TABLE OF giacr191p_details_type;
  
  FUNCTION populate_giacr191p_details( 		-- start SR-4040 : shan 06.19.2015
      p_branch_cd     VARCHAR2,
      p_assd_no       VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_type     VARCHAR2,  
      p_user          VARCHAR2
  )  RETURN giacr191p_details_tab PIPELINED;  
    
  -- transfer from GIACR191_PKG -- shan 02.25.2015
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
      RETURN apdc_details_tab PIPELINED;		-- end SR-4040 : shan 06.19.2015

END GIACR191P_PKG;
/