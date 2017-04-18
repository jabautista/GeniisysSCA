CREATE OR REPLACE PACKAGE cpi.giacr112a_pkg AS        

/*
** Created by: Bonok
** Date Created: 3/6/2015
** Description: GIACR112A : Form 2307 - Certificate of Creditable Tax Withheld at Source (with Form)
*/

   TYPE giacr112a_type IS RECORD(
      flag             VARCHAR2(2),
      date1            VARCHAR2(30),
      date2            VARCHAR2(30),
      payee_no         giis_payees.payee_no%TYPE,
      whtax_code       giac_wholding_taxes.whtax_code%TYPE,
      payee_tin1       giis_payees.tin%TYPE,
      payee_tin2       giis_payees.tin%TYPE,
      payee_tin3       giis_payees.tin%TYPE,
      payee_tin4       giis_payees.tin%TYPE,
      payee            VARCHAR2(300),
      address          VARCHAR2(500),
      com_tin1         giac_parameters.param_value_v%TYPE,
      com_tin2         giac_parameters.param_value_v%TYPE,
      com_tin3         giac_parameters.param_value_v%TYPE,
      com_tin4         giac_parameters.param_value_v%TYPE,
      comp_name        VARCHAR2(300),   
      comp_add         VARCHAR2(500),
      zip_code         giac_parameters.param_value_v%TYPE,
      whtax_desc       giac_wholding_taxes.whtax_desc%TYPE,
      bir_tax_cd       giac_wholding_taxes.bir_tax_cd%TYPE,
      income_amt1      NUMBER(18,2),
      income_amt2      NUMBER(18,2),
      income_amt3      NUMBER(18,2),
      income_amt_tot   NUMBER(18,2),
      whtax_tot        NUMBER(18,2),
      signatory        giis_signatory_names.signatory%type,
      designation      giis_signatory_names.designation%type,
      payee_class_cd   giis_payees.payee_class_cd%TYPE
   );
   TYPE giacr112a_tab IS TABLE OF giacr112a_type;
--Modified by pjsantos 12/22/2016, GENQA 5898
   FUNCTION populate_giacr112a(
      p_date1             VARCHAR2,
      p_date2             VARCHAR2,
      p_exclude_tag       VARCHAR2,
      p_payee_class_cd    VARCHAR2,
      p_payee_no          VARCHAR2,
      p_post_tran         VARCHAR2,
      p_tran_id           VARCHAR2,
      p_items             VARCHAR2,
      p_tran_tag          VARCHAR2 
   )RETURN giacr112a_tab PIPELINED;

   FUNCTION get_giacr112a_whtax(
      p_date1             VARCHAR2,
      p_date2             VARCHAR2,
      p_exclude_tag       VARCHAR2,
      p_payee_class_cd    VARCHAR2,
      p_payee_no          giis_payees.payee_no%TYPE,
      p_post_tran         VARCHAR2,
      p_whtax_code        giac_wholding_taxes.whtax_code%TYPE,
      p_bir_tax_cd        VARCHAR2,
      p_tran_id           VARCHAR2,
      p_items             VARCHAR2,
      p_tran_tag          VARCHAR2 
   ) RETURN giacr112a_tab PIPELINED;
--pjsantos end
END giacr112a_pkg;
/
