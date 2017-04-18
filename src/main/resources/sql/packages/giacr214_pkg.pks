CREATE OR REPLACE PACKAGE CPI.giacr214_pkg
AS
   TYPE giacr214_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      date_params       VARCHAR2 (100),
      branch            VARCHAR2 (60),
      payee_no          giac_disb_vouchers.payee_no%TYPE,
      payee_class_cd    giac_disb_vouchers.payee_class_cd%TYPE,
--      particulars       giac_order_of_payts.particulars%TYPE,
      particulars       giac_acctrans.particulars%TYPE, --changed type by gab 12.09.2016 SR 5872
      tran_date         VARCHAR2 (15),
      amt_o_vat         giac_comm_payts.input_vat_amt%TYPE,
      tran_class        giac_acctrans.tran_class%TYPE,
      NAME              VARCHAR2 (550),
      input_vat         giac_comm_payts.input_vat_amt%TYPE,
      ref_no            VARCHAR2 (95),
      sl_name           VARCHAR2 (1000),
      tin               VARCHAR2 (30),
      joy               VARCHAR2 (370),
      sl_cd             giac_acct_entries.sl_cd%TYPE,
      sl_source_cd      giac_acct_entries.sl_source_cd%TYPE,
      sl_type_cd        giac_acct_entries.sl_type_cd%TYPE,
      address           VARCHAR2 (200)
   );

   TYPE giacr214_tab IS TABLE OF giacr214_type;

   FUNCTION get_giacr214_details (
      p_from_date   DATE,
      p_to_date     DATE,
      p_tran_post   VARCHAR2,
      p_include     VARCHAR2, --vondanix 12.16.15 RSIC GENQA 5223
      p_branch_cd   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr214_tab PIPELINED;

   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2;

   FUNCTION get_cf_company_addformula
      RETURN VARCHAR2;

   FUNCTION get_cf_date_paramsformula (p_from_date DATE, p_to_date DATE)
      RETURN VARCHAR2;

   FUNCTION get_cf_amt_o_vatformula (
      p_input_vat   giac_comm_payts.input_vat_amt%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_cf_sl_nameformula (
      p_sl_cd          giac_acct_entries.sl_cd%TYPE,
      p_sl_source_cd   giac_acct_entries.sl_source_cd%TYPE,
      p_sl_type_cd     giac_acct_entries.sl_type_cd%TYPE,
      p_payee_no       giac_disb_vouchers.payee_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_cf_tinformula (
      p_sl_cd            giac_acct_entries.sl_cd%TYPE,
      p_sl_source_cd     giac_acct_entries.sl_source_cd%TYPE,
      p_sl_type_cd       giac_acct_entries.sl_type_cd%TYPE,
      p_payee_no         giac_disb_vouchers.payee_no%TYPE,
      p_payee_class_cd   giac_disb_vouchers.payee_class_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_cf_addformula (
      p_sl_cd            giac_acct_entries.sl_cd%TYPE,
      p_sl_source_cd     giac_acct_entries.sl_source_cd%TYPE,
      p_sl_type_cd       giac_acct_entries.sl_type_cd%TYPE,
      p_payee_no         giac_disb_vouchers.payee_no%TYPE,
      p_payee_class_cd   giac_disb_vouchers.payee_class_cd%TYPE
   )
      RETURN VARCHAR2;
END giacr214_pkg;
/

