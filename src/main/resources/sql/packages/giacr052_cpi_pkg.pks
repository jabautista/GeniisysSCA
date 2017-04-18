CREATE OR REPLACE PACKAGE CPI.giacr052_cpi_pkg
AS
   TYPE giac_disb_type IS RECORD (
      gacc_tran_id         giac_disb_vouchers.gacc_tran_id%TYPE,
      short_name           giis_currency.short_name%TYPE,
      payee                giac_disb_vouchers.payee%TYPE,
      chck_date            VARCHAR2 (400),
      --giac_chk_disbursement.check_date%TYPE,
      voucher_no           VARCHAR2 (400),
      dv_amt               VARCHAR2 (400),  --giac_disb_vouchers.dv_amt%TYPE, 
      particulars          giac_disb_vouchers.particulars%TYPE,
      dv_amt_in_words      VARCHAR2 (400),
      check_amt            VARCHAR2 (400),
      --giac_chk_disbursement.amount%TYPE,
      check_amt_in_words   VARCHAR2 (400),
      check_no             VARCHAR2 (400),
      company_name         VARCHAR2 (400)
   );

   TYPE giac_disb_tab IS TABLE OF giac_disb_type;

   FUNCTION get_disb_details (p_tran_id giac_disb_vouchers.gacc_tran_id%TYPE)
      RETURN giac_disb_tab PIPELINED;

   TYPE gl_accounts_type IS RECORD (
      gl_acct_number   VARCHAR2 (400),
      gl_acct_sname    giac_chart_of_accts.gl_acct_sname%TYPE,
      debit_amt        giac_acct_entries.debit_amt%TYPE,
      credit_amt       giac_acct_entries.credit_amt%TYPE
   );

   TYPE gl_accounts_tab IS TABLE OF gl_accounts_type;

   FUNCTION get_gl_account_dtls (
      p_tran_id   giac_acct_entries.gacc_tran_id%TYPE
   )
      RETURN gl_accounts_tab PIPELINED;

   TYPE signatories_type IS RECORD (
      app_signatory      giis_signatory_names.signatory%TYPE,
      app_designation    giis_signatory_names.designation%TYPE,
      prep_signatory     giis_signatory_names.signatory%TYPE,
      prep_designation   giis_signatory_names.designation%TYPE,
      chck_signatory     giis_signatory_names.signatory%TYPE,
      chck_designation   giis_signatory_names.designation%TYPE
   );

   TYPE signatories_tab IS TABLE OF signatories_type;

   FUNCTION get_signatories (
      p_tran_id     giac_disb_vouchers.gacc_tran_id%TYPE,
      p_report_id   giac_documents.report_id%TYPE,
      p_branch_cd   giac_documents.branch_cd%TYPE,
      p_user_id     giac_users.user_id%TYPE
   )
      RETURN signatories_tab PIPELINED;
END;
/


DROP PACKAGE CPI.GIACR052_CPI_PKG;