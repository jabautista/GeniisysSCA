CREATE OR REPLACE PACKAGE CPI.giacr414_pkg  
AS
   TYPE get_giacr414_type IS RECORD (  
      company_name       VARCHAR2 (200),
      company_address    VARCHAR2 (200),
      cf_from_to         VARCHAR2 (100),
      cf_same_from_to    VARCHAR2 (100),
      assd_name          giis_assured.assd_name%TYPE,
      invoice_no         VARCHAR2 (100),
      policy_no          VARCHAR2 (50),
      or_no              VARCHAR2 (100),
      premium            gipi_comm_invoice.premium_amt%TYPE,
      peril              VARCHAR2 (5),
      invoice_comm_amt   gipi_comm_invoice.commission_amt%TYPE,
      input_vat          giac_comm_payts.input_vat_amt%TYPE,
      cv_no              VARCHAR2 (40),
      comm_amt           giac_comm_payts.comm_amt%TYPE,
      AGENT              VARCHAR2 (20),
      cf_label           giac_rep_signatory.label%TYPE,
      signatory          giis_signatory_names.signatory%TYPE,
      designation        giis_signatory_names.designation%TYPE,
      policy_id          GIPI_COMM_INVOICE.POLICY_ID%TYPE,
      or_date            VARCHAR2 (100) --added by robert SR 5227 02.04.16
   );

   TYPE get_giacr414_tab IS TABLE OF get_giacr414_type;

   FUNCTION get_giacr414_dtls (
      p_branch_cd      VARCHAR2,
      p_module_id      VARCHAR2,
      p_post_tran_sw   VARCHAR2,
      p_report_id      VARCHAR2,
      p_from           VARCHAR2,
      p_to             VARCHAR2,
      p_user_id        GIIS_USERS.user_id%TYPE
   )
      RETURN get_giacr414_tab PIPELINED;
END;
/


