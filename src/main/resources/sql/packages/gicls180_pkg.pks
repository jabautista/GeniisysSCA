CREATE OR REPLACE PACKAGE CPI.GICLS180_PKG
AS
   TYPE rec_type IS RECORD (
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
      document_name  giac_payt_req_docs.document_name%TYPE,
      gicls181_iss   VARCHAR2(1)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list(
      p_module_id    giis_modules.module_id%TYPE,
      p_user_id      giis_users.user_id%TYPE
   ) RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giac_documents%ROWTYPE);

   PROCEDURE del_rec(p_rec giac_documents%ROWTYPE);
   
   PROCEDURE val_del_rec(p_report_id giac_rep_signatory.report_id%TYPE);
   
   TYPE report_lov_type IS RECORD (
      report_id      giis_reports.report_id%TYPE,
      report_title   giis_reports.report_title%TYPE
   ); 

   TYPE report_lov_tab IS TABLE OF report_lov_type;
   
   FUNCTION get_report_lov(
      p_keyword      VARCHAR2
   ) RETURN report_lov_tab PIPELINED; 
   
   TYPE line_lov_type IS RECORD (
      line_cd        giis_line.line_cd%TYPE,
      line_name      giis_line.line_name%TYPE
   ); 

   TYPE line_lov_tab IS TABLE OF line_lov_type;
      
   FUNCTION get_line_lov(
      p_module_id    giis_modules.module_id%TYPE,
      p_user_id      giis_users.user_id%TYPE,
      p_keyword      VARCHAR2
   ) RETURN line_lov_tab PIPELINED;
   
   TYPE document_lov_type IS RECORD (
      document_cd    giac_payt_req_docs.document_cd%TYPE,
      document_name  giac_payt_req_docs.document_name%TYPE
   ); 

   TYPE document_lov_tab IS TABLE OF document_lov_type;
   
   FUNCTION get_document_lov(
      p_keyword      VARCHAR2
   ) RETURN document_lov_tab PIPELINED;
   
   TYPE branch_lov_type IS RECORD (
      branch_cd      giis_issource.iss_cd%TYPE,
      branch_name    giis_issource.iss_name%TYPE
   ); 

   TYPE branch_lov_tab IS TABLE OF branch_lov_type;
      
   FUNCTION get_branch_lov(
      p_module_id    giis_modules.module_id%TYPE,
      p_user_id      giis_users.user_id%TYPE,
      p_keyword      VARCHAR2
   ) RETURN branch_lov_tab PIPELINED;
END;
/


