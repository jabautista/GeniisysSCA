CREATE OR REPLACE PACKAGE CPI.giacs045_pkg
AS
   TYPE document_cd_type IS RECORD (
      document_cd   giac_payt_requests.document_cd%TYPE
   );

   TYPE document_cd_tab IS TABLE OF document_cd_type;

   FUNCTION get_document_cd_lov
      RETURN document_cd_tab PIPELINED;

   TYPE branch_cd_type IS RECORD (
      branch_cd     giac_payt_requests.branch_cd%TYPE,
      branch_name   giac_branches.branch_name%TYPE,
      line_cd_tag   giac_payt_req_docs.line_cd_tag%TYPE
   );

   TYPE branch_cd_tab IS TABLE OF branch_cd_type;

   FUNCTION get_branch_cd_lov (p_user_id VARCHAR2, p_document_cd_from VARCHAR2)
      RETURN branch_cd_tab PIPELINED;

   FUNCTION get_branch_cd_lov2 (p_user_id VARCHAR2)
      RETURN branch_cd_tab PIPELINED;

   TYPE line_cd_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_cd_tab IS TABLE OF line_cd_type;

   FUNCTION get_line_lov (
      p_document_cd_from   VARCHAR2,
      p_branch_cd_from     VARCHAR2
   )
      RETURN line_cd_tab PIPELINED;

   TYPE doc_year_type IS RECORD (
      doc_year   giac_payt_requests.doc_year%TYPE,
      doc_mm     giac_payt_requests.doc_mm%TYPE
   );

   TYPE doc_year_tab IS TABLE OF doc_year_type;

   FUNCTION get_doc_year_lov (
      p_document_cd_from   VARCHAR2,
      p_branch_cd_from     VARCHAR2,
      p_line_cd_from       VARCHAR2
   )
      RETURN doc_year_tab PIPELINED;

   TYPE doc_seq_no_type IS RECORD (
      doc_seq_no    giac_payt_requests.doc_seq_no%TYPE,
      particulars   giac_payt_requests_dtl.particulars%TYPE
   );

   TYPE doc_seq_no_tab IS TABLE OF doc_seq_no_type;

   FUNCTION get_doc_seq_no_lov (
      p_document_cd_from   VARCHAR2,
      p_branch_cd_from     VARCHAR2,
      p_line_cd_from       VARCHAR2,
      p_doc_year_from      VARCHAR2,
      p_doc_mm_from        VARCHAR2,
      p_doc_seq_no_from    VARCHAR2
   )
      RETURN doc_seq_no_tab PIPELINED;

   PROCEDURE validate_request_no (
      p_document_cd_from   IN       giac_payt_requests.document_cd%TYPE,
      p_branch_cd_from     IN       giac_payt_requests.branch_cd%TYPE,
      p_line_cd_from       IN       giac_payt_requests.line_cd%TYPE,
      p_doc_year_from      IN       giac_payt_requests.doc_year%TYPE,
      p_doc_mm_from        IN       giac_payt_requests.doc_mm%TYPE,
      p_doc_seq_no_from    IN       giac_payt_requests.doc_seq_no%TYPE,
      p_ref_id_from        OUT      giac_payt_requests.ref_id%TYPE,
      p_fund_cd_from       OUT      giac_payt_requests.fund_cd%TYPE,
      p_tran_id_from       OUT      giac_payt_requests_dtl.tran_id%TYPE,
      p_tran_date_from     OUT      giac_acctrans.tran_date%TYPE,
      p_check              OUT      VARCHAR2
   );

   PROCEDURE check_create_transaction (
      p_tran_date_from   IN   VARCHAR2,
      p_branch_cd_to     IN   VARCHAR2
   );

   PROCEDURE insert_into_acctrans (
      p_fund_cd_from     IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_branch_cd_from   IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_tran_date_from   IN       VARCHAR2,
      p_user_id          IN       VARCHAR2,
      p_tran_id_acc      OUT      giac_taxes_wheld.gacc_tran_id%TYPE
   );

   PROCEDURE copy_payment_request (
      p_document_cd_from   IN       giac_payt_requests.document_cd%TYPE,
      p_branch_cd_from     IN       giac_payt_requests.branch_cd%TYPE,
      p_line_cd_from       IN       giac_payt_requests.line_cd%TYPE,
      p_doc_year_from      IN       giac_payt_requests.doc_year%TYPE,
      p_doc_mm_from        IN       giac_payt_requests.doc_mm%TYPE,
      p_doc_seq_no_from    IN       giac_payt_requests.doc_seq_no%TYPE,
      p_document_cd_to     IN       giac_payt_requests.document_cd%TYPE,
      p_branch_cd_to       IN       giac_payt_requests.branch_cd%TYPE,
      p_line_cd_to         IN       giac_payt_requests.line_cd%TYPE,
      p_doc_year_to        IN       giac_payt_requests.doc_year%TYPE,
      p_doc_mm_to          IN       giac_payt_requests.doc_mm%TYPE,
      p_doc_seq_no_to      OUT      giac_payt_requests.doc_seq_no%TYPE,
      p_ref_id_from        IN       giac_payt_requests.ref_id%TYPE,
      p_ref_id_to          OUT      giac_payt_requests.ref_id%TYPE,
      p_tran_date_from     IN       VARCHAR2,
      p_user_id            IN       VARCHAR2,
      p_tran_id_acc        IN       giac_taxes_wheld.gacc_tran_id%TYPE
   );

   PROCEDURE copy_withholding (
      p_tran_id_from   IN   giac_payt_requests_dtl.tran_id%TYPE,
      p_tran_id_acc    IN   giac_taxes_wheld.gacc_tran_id%TYPE,
      p_user_id        IN   VARCHAR2
   );

   PROCEDURE copy_input_vat (
      p_tran_id_from   IN   giac_payt_requests_dtl.tran_id%TYPE,
      p_tran_id_acc    IN   giac_taxes_wheld.gacc_tran_id%TYPE,
      p_user_id        IN   VARCHAR2
   );

   PROCEDURE copy_acctg_entries (
      p_acct_entry_id   IN   giac_acct_entries.acct_entry_id%TYPE,
      p_tran_id_from    IN   giac_payt_requests_dtl.tran_id%TYPE,
      p_tran_id_acc     IN   giac_taxes_wheld.gacc_tran_id%TYPE,
      p_branch_cd_to    IN   giac_payt_requests.branch_cd%TYPE,
      p_user_id         IN   VARCHAR2
   );

   PROCEDURE copy_acctg_entries_looper (
      p_tran_id_from     IN   giac_payt_requests_dtl.tran_id%TYPE,
      p_fund_cd_from     IN   giac_payt_requests.fund_cd%TYPE,
      p_branch_cd_from   IN   giac_payt_requests.branch_cd%TYPE,
      p_branch_cd_to     IN   giac_payt_requests.branch_cd%TYPE,
      p_tran_id_acc      IN   giac_taxes_wheld.gacc_tran_id%TYPE,
      p_user_id          IN   VARCHAR2
   );

   FUNCTION validate_document_cd (p_document_cd VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION validate_branch_cd_from (
      p_document_cd      VARCHAR2,
      p_branch_cd_from   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION validate_line_cd (
      p_document_cd      VARCHAR2,
      p_branch_cd_from   VARCHAR2,
      p_line_cd          VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION validate_doc_year (
      p_document_cd      VARCHAR2,
      p_branch_cd_from   VARCHAR2,
      p_line_cd          VARCHAR2,
      p_doc_year         VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION validate_doc_mm (
      p_document_cd      VARCHAR2,
      p_branch_cd_from   VARCHAR2,
      p_line_cd          VARCHAR2,
      p_doc_year         VARCHAR2,
      p_doc_mm           VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION validate_branch_cd_to (p_user_id VARCHAR2, p_branch_cd_to VARCHAR2)
      RETURN VARCHAR2;
END;
/
