CREATE OR REPLACE PACKAGE CPI.giacs306_pkg
AS
   TYPE rec_type IS RECORD (
      doc_id          giac_payt_req_docs.doc_id%TYPE,
      document_cd     giac_payt_req_docs.document_cd%TYPE,
      document_name   giac_payt_req_docs.document_name%TYPE,
      line_cd_tag     giac_payt_req_docs.line_cd_tag%TYPE,
      yy_tag          giac_payt_req_docs.yy_tag%TYPE,
      mm_tag          giac_payt_req_docs.mm_tag%TYPE,
      purchase_tag    giac_payt_req_docs.purchase_tag%TYPE,
      remarks         giac_payt_req_docs.remarks%TYPE,
      user_id         giac_payt_req_docs.user_id%TYPE,
      last_update     VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_fund_cd         giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd       giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_document_cd     giac_payt_req_docs.document_cd%TYPE,
      p_document_name   giac_payt_req_docs.document_name%TYPE,
      p_line_cd_tag     giac_payt_req_docs.line_cd_tag%TYPE,
      p_yy_tag          giac_payt_req_docs.yy_tag%TYPE,
      p_mm_tag          giac_payt_req_docs.mm_tag%TYPE,
      p_purchase_tag    giac_payt_req_docs.purchase_tag%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giac_payt_req_docs%ROWTYPE);

   PROCEDURE del_rec (      
      p_fund_cd       giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd     giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_document_cd   giac_payt_req_docs.document_cd%TYPE);

   PROCEDURE val_del_rec (
      p_fund_cd       giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd     giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_document_cd   giac_payt_req_docs.document_cd%TYPE);

   PROCEDURE val_add_rec (
      p_fund_cd       giac_payt_req_docs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd     giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_document_cd   giac_payt_req_docs.document_cd%TYPE
   );
END;
/


