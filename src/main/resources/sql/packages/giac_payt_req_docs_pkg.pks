CREATE OR REPLACE PACKAGE CPI.giac_payt_req_docs_pkg
AS
   TYPE giac_payt_req_docs_type IS RECORD (
      gibr_gfun_fund_cd   giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd      giac_payt_req_docs.gibr_branch_cd%TYPE,
      document_cd         giac_payt_req_docs.document_cd%TYPE,
      document_name       giac_payt_req_docs.document_name%TYPE,
      line_cd_tag         giac_payt_req_docs.line_cd_tag%TYPE,
      yy_tag              giac_payt_req_docs.yy_tag%TYPE,
      mm_tag              giac_payt_req_docs.mm_tag%TYPE,
      doc_id              giac_payt_req_docs.doc_id%TYPE,
      remarks             giac_payt_req_docs.remarks%TYPE,
      user_id             giac_payt_req_docs.user_id%TYPE,
      last_update         giac_payt_req_docs.last_update%TYPE,
      cpi_rec_no          giac_payt_req_docs.cpi_rec_no%TYPE,
      cpi_branch_cd       giac_payt_req_docs.cpi_branch_cd%TYPE
   );

   TYPE giac_payt_req_docs_tab IS TABLE OF giac_payt_req_docs_type;

   FUNCTION get_rg_document_cd_claim (
      p_fund_cd     giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd   giac_payt_req_docs.gibr_branch_cd%TYPE
   )
      RETURN giac_payt_req_docs_tab PIPELINED;

   FUNCTION get_rg_document_cd_non_claim (
      p_fund_cd      giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd    giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_param_name   giac_parameters.param_value_v%TYPE
   )
      RETURN giac_payt_req_docs_tab PIPELINED;

   FUNCTION get_rg_document_cd_other (
      p_fund_cd     giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd   giac_payt_req_docs.gibr_branch_cd%TYPE
   )
      RETURN giac_payt_req_docs_tab PIPELINED;

   FUNCTION get_rg_document_cd_all
      RETURN giac_payt_req_docs_tab PIPELINED;

   FUNCTION get_payt_req_numbering_scheme (
      p_fund_cd       IN   giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
      p_branch_cd     IN   giac_disb_vouchers.gibr_branch_cd%TYPE,
      p_document_cd   IN   giac_payt_requests.document_cd%TYPE
--        p_nbt_line_cd_tag   OUT        giac_payt_req_docs.line_cd_tag%TYPE,
--        p_nbt_yy_tag        OUT        giac_payt_req_docs.yy_tag%TYPE,
--        p_nbt_mm_tag        OUT        giac_payt_req_docs.mm_tag%TYPE
   )
      RETURN giac_payt_req_docs_tab PIPELINED;

   FUNCTION get_document_cd_list (
      p_module_id   giis_modules_tran.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_fund_cd     giac_payt_requests.fund_cd%TYPE,
      p_branch_cd   giac_payt_requests.branch_cd%TYPE
   )
      RETURN giac_payt_req_docs_tab PIPELINED;

   PROCEDURE validate_document_cd (
      p_fund_cd       giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd     giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_document_cd   giac_payt_req_docs.document_cd%TYPE
   );

   FUNCTION fetch_document_list (
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN giac_payt_req_docs_tab PIPELINED;
      
    FUNCTION validate_document_cd2(
        p_document_cd   giac_payt_req_docs.DOCUMENT_CD%type,
        p_branch_cd     giac_payt_req_docs.GIBR_BRANCH_CD%type
    ) RETURN VARCHAR2;
   
END;
/


