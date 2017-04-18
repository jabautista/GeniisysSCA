CREATE OR REPLACE PACKAGE CPI.giacr190a_pkg
AS
/******************************************************************************
   Name:       GIACR190A_PKG
   Purpose:    SOA - COLLECTION LETTER - LIST ALL INTERMEDIARY 

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06/07/2013  Abegail Pascual  Created this package.
******************************************************************************/
   TYPE g_giacr190a_type IS RECORD (
      intm_no           giis_intermediary.intm_no%TYPE,
      intm_name         giis_intermediary.intm_name%TYPE,
      address           giis_intermediary.bill_addr1%TYPE,
      address2          giis_intermediary.bill_addr2%TYPE,
      address3          giis_intermediary.bill_addr3%TYPE,
      policy_no         VARCHAR2 (2000),
      policy_term       VARCHAR2 (2000),
      invoice_num       VARCHAR2 (2000),
      balance_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      param_date        giac_soa_rep_ext.param_date%TYPE,
      user_id           giac_soa_rep_ext.user_id%TYPE,
      company_name      VARCHAR2 (2000),
      aging_id          giac_soa_rep_ext.aging_id%TYPE
   );

   TYPE g_giacr190a_tab IS TABLE OF g_giacr190a_type;

   FUNCTION get_report_details (
      p_intm_no    VARCHAR2,
      p_aging_id   VARCHAR2,
      p_print_btn_no NUMBER,
      p_user_id    giis_users.user_id%TYPE
   ) RETURN g_giacr190a_tab PIPELINED;

   TYPE g_giacr190a_signatory_type IS RECORD (
      item_no       giac_rep_signatory.item_no%TYPE,
      label         giac_rep_signatory.label%TYPE,
      signatory     giis_signatory_names.signatory%TYPE,
      designation   giis_signatory_names.designation%TYPE,
      remarks       giac_documents.remarks%TYPE,
      cut_off_date  giac_soa_rep_ext.param_date%TYPE
   );

   TYPE g_giacr190a_signatory_tab IS TABLE OF g_giacr190a_signatory_type;

   FUNCTION get_report_signatory (
        p_report_id giac_documents.report_id%TYPE,
        p_useR_id   giac_soa_rep_ext.user_id%TYPE,
        p_intm_no   giac_soa_rep_ext.intm_no%TYPE
   ) RETURN g_giacr190a_signatory_tab PIPELINED;
END;
/


