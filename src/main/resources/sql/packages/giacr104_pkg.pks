CREATE OR REPLACE PACKAGE CPI.giacr104_pkg
AS
   TYPE giacr104_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      date_params       VARCHAR2 (100),
      branch            VARCHAR2 (60),
      address           VARCHAR2 (155),
      sl_cd             giac_acct_entries.sl_cd%TYPE,
      tin               giac_order_of_payts.tin%TYPE,
      NAME              giac_order_of_payts.payor%TYPE,
--      particulars       giac_order_of_payts.particulars%TYPE,
      particulars       giac_acctrans.particulars%TYPE, --changed type by gab 12.02.2016 SR 5872
      tran_date         VARCHAR (20),
      tran_class        giac_acctrans.tran_class%TYPE,
      input_vat         giac_comm_payts.input_vat_amt%TYPE,
      ref_no            VARCHAR2 (95),
      joy               VARCHAR2 (370),
      v_o_vat           giac_comm_payts.input_vat_amt%TYPE
   );

   TYPE giacr104_tab IS TABLE OF giacr104_type;

   FUNCTION get_giacr104_details (
      p_from_date   DATE,
      p_to_date     DATE,
      p_tran_post   VARCHAR2,
      p_include     VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr104_tab PIPELINED;

   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2;

   FUNCTION get_cf_company_addformula
      RETURN VARCHAR2;

   FUNCTION get_cf_date_paramsformula (p_from_date DATE, p_to_date DATE)
      RETURN VARCHAR2;
END giacr104_pkg;
/


