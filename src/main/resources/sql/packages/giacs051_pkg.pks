CREATE OR REPLACE PACKAGE CPI.giacs051_pkg
AS
   TYPE branch_cd_from_lov_type IS RECORD (
      gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      iss_name         giis_issource.iss_name%TYPE
   );

   TYPE branch_cd_from_lov_tab IS TABLE OF branch_cd_from_lov_type;

   FUNCTION get_branch_cd_from_lov (p_user_id giis_users.user_id%TYPE)
      RETURN branch_cd_from_lov_tab PIPELINED;

   TYPE doc_year_lov_type IS RECORD (
      doc_year   giac_acctrans.tran_year%TYPE,
      doc_mm     giac_acctrans.tran_month%TYPE
   );

   TYPE doc_year_lov_tab IS TABLE OF doc_year_lov_type;

   FUNCTION get_doc_year_lov (p_gibr_branch_cd VARCHAR2)
      RETURN doc_year_lov_tab PIPELINED;

   TYPE doc_seq_no_type IS RECORD (
      doc_seq_no       giac_acctrans.tran_seq_no%TYPE,
      particulars      giac_acctrans.particulars%TYPE,
      tran_id          giac_acctrans.tran_id%TYPE,
      gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      tran_seq_no      giac_acctrans.tran_seq_no%TYPE,
      tran_date        giac_acctrans.tran_date%TYPE
   );

   TYPE doc_seq_no_tab IS TABLE OF doc_seq_no_type;

   FUNCTION get_doc_seq_no_lov (
      p_gibr_branch_cd   VARCHAR2,
      p_doc_year         VARCHAR2,
      p_doc_mm           VARCHAR2,
      p_doc_seq_no       VARCHAR2
   )
      RETURN doc_seq_no_tab PIPELINED;

   TYPE branch_cd_to_lov_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE branch_cd_to_lov_tab IS TABLE OF branch_cd_to_lov_type;

   FUNCTION get_branch_cd_to_lov (p_user_id giis_users.user_id%TYPE)
      RETURN branch_cd_to_lov_tab PIPELINED;

   FUNCTION check_create_transaction (
      p_tran_date   VARCHAR2,
      p_branch_to   VARCHAR2
   )
      RETURN VARCHAR2;

   PROCEDURE insert_into_acctrans (
      p_fund_cd_from      IN       VARCHAR2,
      p_branch_cd_to      IN       VARCHAR2,
      p_tran_date_from    IN       VARCHAR2,
      p_acctran_tran_id   OUT      giac_acctrans.tran_id%TYPE,
      p_doc_year_from     IN       VARCHAR2,
      p_doc_mm_from       IN       VARCHAR2,
      p_doc_seq_no_from   IN       giac_acctrans.tran_seq_no%TYPE,
      p_branch_cd_from    IN       VARCHAR2,
      p_doc_year_to       IN       VARCHAR2,
      p_doc_mm_to         IN       VARCHAR2,
      p_user_id           IN       VARCHAR2
   );

   PROCEDURE copy_acctg_entries (
      p_acct_entry_id   VARCHAR2,
      p_tran_id_from    VARCHAR2,
      p_acct_tran_id    VARCHAR2,
      p_branch_cd_to    VARCHAR2,
      p_user_id         VARCHAR2
   );

   PROCEDURE copy_jv_looper (
      p_fund_cd          IN       VARCHAR2,
      p_branch_cd_from   IN       VARCHAR2,
      p_tran_id_from     IN       VARCHAR2,
      p_acct_tran_id     IN       VARCHAR2,
      p_branch_cd_to     IN       VARCHAR2,
      p_user_id          IN       VARCHAR2,
      p_doc_year_to      IN       VARCHAR2,
      p_doc_mm_to        IN       VARCHAR2,
      p_new_tran_no      OUT      VARCHAR2
   );

   FUNCTION validate_branch_cd_from (
      p_branch_cd_from   VARCHAR2,
      p_user_id          VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION validate_doc_year (
      p_branch_cd_from   VARCHAR2,
      p_doc_year         VARCHAR2
   )
      RETURN VARCHAR2;
   
   FUNCTION validate_doc_mm (
      p_branch_cd_from   VARCHAR2,
      p_doc_year         VARCHAR2,
      p_doc_mm           VARCHAR2
   )
      RETURN VARCHAR2;
      
   FUNCTION validate_branch_cd_to (
      p_branch_cd_to VARCHAR2,
      p_user_id VARCHAR2
   )
      RETURN VARCHAR2;
      
   TYPE validate_doc_seq_no_type IS RECORD (
      doc_seq_no       giac_acctrans.tran_seq_no%TYPE,
      particulars      giac_acctrans.particulars%TYPE,
      tran_id          giac_acctrans.tran_id%TYPE,
      gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      tran_seq_no      giac_acctrans.tran_seq_no%TYPE,
      tran_date        giac_acctrans.tran_date%TYPE,
      rec_count        NUMBER(10)
   );

   TYPE validate_doc_seq_no_tab IS TABLE OF validate_doc_seq_no_type;   
      
   FUNCTION validate_doc_seq_no (
      p_gibr_branch_cd   VARCHAR2,
      p_doc_year         VARCHAR2,
      p_doc_mm           VARCHAR2,
      p_doc_seq_no       VARCHAR2
   )
      RETURN validate_doc_seq_no_tab PIPELINED;      
      
END;
/


