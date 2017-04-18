CREATE OR REPLACE PACKAGE CPI.giacr189_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company        VARCHAR2 (50),
      cf_com_address    VARCHAR2 (200),
      report_title      VARCHAR2 (50),
      date_label        VARCHAR2 (100),
      soa_branch_total  VARCHAR2 (100),
      cf_date           giac_soa_rep_ext.param_date%TYPE,
      date_tag1         VARCHAR2 (300),
      date_tag2         VARCHAR2 (200),
      date_tag3         VARCHAR2 (300),
      date_tag4         VARCHAR2 (200),
      branch_cd         giac_soa_rep_ext.branch_cd%TYPE,
      branch_name       giis_issource.iss_name%TYPE,
      intm_type         giac_soa_rep_ext.intm_type%TYPE,
      intm_no           giac_soa_rep_ext.intm_no%TYPE,
      intm_name         giac_soa_rep_ext.intm_name%TYPE,
      incept_date       giac_soa_rep_ext.incept_date%TYPE,
      policy_no         giac_soa_rep_ext.policy_no%TYPE,
      ref_pol_no        giac_soa_rep_ext.ref_pol_no%TYPE,
      assd_name         giac_soa_rep_ext.assd_name%TYPE,
      bill_no           VARCHAR2 (84),
      due_date          giac_soa_rep_ext.due_date%TYPE,
      prem_bal_due      giac_soa_rep_ext.prem_bal_due%TYPE,
      tax_bal_due       giac_soa_rep_ext.tax_bal_due%TYPE,
      balance_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      exist_pdc         VARCHAR2 (20),
      signatory_tag     giac_parameters.param_value_v%TYPE,
      label             giac_rep_signatory.label%TYPE,
      signatory         giis_signatory_names.signatory%TYPE,
      designation       giis_signatory_names.designation%TYPE,
      /*branch_cd_dummy   VARCHAR2 (200),		-- start SR-4032 : shan 06.19.2015
      intm_name_dummy   VARCHAR2 (200),
      col_no1           giac_soa_title.col_no%TYPE,
      col_title1        giac_soa_title.col_title%TYPE,
      col_no2           giac_soa_title.col_no%TYPE,
      col_title2        giac_soa_title.col_title%TYPE,
      col_no3           giac_soa_title.col_no%TYPE,
      col_title3        giac_soa_title.col_title%TYPE,
      col_no4           giac_soa_title.col_no%TYPE,
      col_title4        giac_soa_title.col_title%TYPE,
      col_no5           giac_soa_title.col_no%TYPE,
      col_title5        giac_soa_title.col_title%TYPE,
      no_of_dummy       NUMBER (10)*/
	  column_no         giac_soa_rep_ext.COLUMN_NO%TYPE,
 	  column_title      giac_soa_rep_ext.COLUMN_TITLE%TYPE	-- end SR-4032 : shan 06.19.2015
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   TYPE get_bal_amt_detail_type IS RECORD (
      col_title         giac_soa_title.col_title%TYPE,
      col_no            giac_soa_title.col_no%TYPE,
      balance_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      policy_no         giac_soa_rep_ext.policy_no%TYPE
   );

   TYPE get_bal_amt_detail_tab IS TABLE OF get_bal_amt_detail_type;

   TYPE get_apdc_type IS RECORD (
      apdc_number       VARCHAR2 (49),
      apdc_date         giac_apdc_payt.apdc_date%TYPE,
      bank_sname        giac_banks.bank_sname%TYPE,
      bank_branch       giac_apdc_payt_dtl.bank_branch%TYPE,
      check_no          giac_apdc_payt_dtl.check_no%TYPE,
      check_date_apdc   giac_apdc_payt_dtl.check_date%TYPE,
      check_amt         giac_apdc_payt_dtl.check_amt%TYPE,
      bill_no           VARCHAR2 (84),
      collection_amt    giac_pdc_prem_colln.collection_amt%TYPE
   );

   TYPE get_apdc_tab IS TABLE OF get_apdc_type;

   --added by steven 12.16.2014 for matrix
   TYPE title_type IS RECORD (
      col_title   giac_soa_title.col_title%TYPE,
      col_no      giac_soa_title.col_no%TYPE
   );

   TYPE title_tab IS TABLE OF title_type;

   FUNCTION get_details (
      p_month         VARCHAR2,
      p_user          VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_intm_no       VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_assd_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_cut_off       VARCHAR2,
      p_no            VARCHAR2,
      p_bal_amt_due   NUMBER
   )
      RETURN get_details_tab PIPELINED;

   FUNCTION get_bal_amt_detail (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_intm_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_user          VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_col_no        VARCHAR2,
      p_policy_no     VARCHAR2,
      p_bill_no       VARCHAR2
   )
      RETURN get_bal_amt_detail_tab PIPELINED;

   FUNCTION get_apdc (
      p_month         VARCHAR2,
      p_user          VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_intm_no       VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_assd_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_cut_off       VARCHAR2,
      p_no            VARCHAR2,
      p_bal_amt_due   NUMBER,
      p_policy_no     VARCHAR2,
      p_bill_no       VARCHAR2
   )
      RETURN get_apdc_tab PIPELINED;

   TYPE csv_col_type IS RECORD (
      col_name   VARCHAR2 (100)
   );

   TYPE csv_col_tab IS TABLE OF csv_col_type;

   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED;
END;
/


