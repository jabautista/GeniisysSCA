CREATE OR REPLACE PACKAGE CPI.giacr214b_pkg
AS
   TYPE giacr214b_type IS RECORD (
      company_name      /*giis_parameters*/ giac_parameters.param_value_v%TYPE, -- changed by shan 07.31.2014
      company_address   /*giis_parameters*/ giac_parameters.param_value_v%TYPE, -- changed by shan 07.31.2014
      date_params       VARCHAR2 (100),
      branch            VARCHAR2 (55),
      sl_name           /*VARCHAR2 (300),*/ giac_sl_lists.sl_name%TYPE, --edited by gab 12.07.2016 SR 5872
      sl_cd             giac_acct_entries.sl_cd%TYPE,
      sl_type_cd        giac_acct_entries.sl_type_cd%TYPE,
      sl_source_cd      giac_acct_entries.sl_source_cd%TYPE,
      input_vat         giac_comm_payts.input_vat_amt%TYPE,
      amt_sub_to_vat    giac_comm_payts.input_vat_amt%TYPE,
      tin               giis_payees.tin%TYPE,
      address           VARCHAR2 (200)  -- changed from 100 : shan 07.31.2014
   );

   TYPE giacr214b_tab IS TABLE OF giacr214b_type;

   FUNCTION get_giacr214b_details (
      p_from_date   DATE,
      p_to_date     DATE,
      p_tran_post   VARCHAR2,
      p_include     VARCHAR2, --vondanix 12.16.15 RSIC GENQA 5223
      p_branch_cd   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr214b_tab PIPELINED;

   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2;

   FUNCTION get_cf_company_addformula
      RETURN VARCHAR2;

   FUNCTION get_cf_date_paramsformula (p_from_date DATE, p_to_date DATE)
      RETURN VARCHAR2;

   FUNCTION get_cf_tinformula (
      p_sl_cd        giac_acct_entries.sl_cd%TYPE,
      p_sl_type_cd   giac_acct_entries.sl_type_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_cf_addressformula (
      p_sl_cd        giac_acct_entries.sl_cd%TYPE,
      p_sl_type_cd   giac_acct_entries.sl_type_cd%TYPE
   )
      RETURN VARCHAR2;
END giacr214b_pkg;
/


