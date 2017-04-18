CREATE OR REPLACE PACKAGE CPI.GICLS181_PKG
AS
   TYPE documents_type IS RECORD (
      report_id      giac_documents.report_id%TYPE,
      report_name    giac_documents.report_name%TYPE,
      remarks        giac_documents.remarks%TYPE,
      user_id        giac_documents.user_id%TYPE,
      last_update    VARCHAR2(30),
      report_no      giac_documents.report_no%TYPE,
      line_cd        giac_documents.line_cd%TYPE,
      line_name      giis_line.line_name%TYPE,
      document_tag   giac_documents.document_tag%TYPE,
      branch_cd      giac_documents.branch_cd%TYPE,
      branch_name    giis_issource.iss_name%TYPE,
      document_cd    giac_documents.document_cd%TYPE,
      document_name  giac_payt_req_docs.document_name%TYPE
   ); 

   TYPE documents_tab IS TABLE OF documents_type;

   FUNCTION get_documents_lov(
      p_module_id    giis_modules.module_id%TYPE,
      p_user_id      giis_users.user_id%TYPE,
      p_keyword      VARCHAR2
   ) RETURN documents_tab PIPELINED;
   
   TYPE rep_signatory_type IS RECORD (
      report_id      giac_rep_signatory.report_id%TYPE,
      item_no        giac_rep_signatory.item_no%TYPE,
      label          giac_rep_signatory.label%TYPE,
      signatory_id   giac_rep_signatory.signatory_id%TYPE,
      signatory      giis_signatory_names.signatory%TYPE,
      designation    giis_signatory_names.designation%TYPE,
      remarks        giac_rep_signatory.remarks%TYPE,
      user_id        giac_rep_signatory.user_id%TYPE,
      last_update    VARCHAR2(30),
      sname_flag     giac_rep_signatory.sname_flag%TYPE,
      report_no      giac_rep_signatory.report_no%TYPE,
      line_name      giis_line.line_name%TYPE,
      branch_name    giis_issource.iss_name%TYPE,
      document_name  giac_payt_req_docs.document_name%TYPE,
      readonly       VARCHAR2(1)
   ); 
   
   TYPE rep_signatory_tab IS TABLE OF rep_signatory_type;
   
   FUNCTION get_rep_signatory_list(
      p_report_id    giac_rep_signatory.report_id%TYPE,
      p_report_no    giac_rep_signatory.report_no%TYPE
   ) RETURN rep_signatory_tab PIPELINED;
   
   FUNCTION get_signatory_lov(p_keyword VARCHAR2)
   RETURN rep_signatory_tab PIPELINED;
   
   PROCEDURE val_add_rec(
      p_report_id    giac_rep_signatory.report_id%TYPE,
      p_item_no      giac_rep_signatory.item_no%TYPE,
      p_report_no    giac_rep_signatory.report_no%TYPE
   );
   
   PROCEDURE set_rec (p_rec giac_rep_signatory%ROWTYPE);

   PROCEDURE del_rec(p_rec giac_rep_signatory%ROWTYPE);
END;
/


