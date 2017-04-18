CREATE OR REPLACE PACKAGE CPI.GICLS110_PKG
AS
   TYPE line_type IS RECORD (
      line_cd        giis_line.line_cd%TYPE,
      line_name      giis_line.line_name%TYPE
   ); 

   TYPE line_tab IS TABLE OF line_type;

   FUNCTION get_line_lov(
      p_module_id    giis_modules.module_id%TYPE,
      p_user_id      giis_users.user_id%TYPE,
      p_keyword      VARCHAR2
   ) RETURN line_tab PIPELINED;
   
   TYPE subline_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   ); 

   TYPE subline_tab IS TABLE OF subline_type;
   
   FUNCTION get_subline_lov(
      p_line_cd      giis_subline.line_cd%TYPE,
      p_module_id    giis_modules.module_id%TYPE,
      p_user_id      giis_users.user_id%TYPE,
      p_keyword      VARCHAR2
   ) RETURN subline_tab PIPELINED;
   
   TYPE clm_docs_type IS RECORD (
      line_cd        gicl_clm_docs.line_cd%TYPE,
      subline_cd     gicl_clm_docs.subline_cd%TYPE,
      dsp_clm_doc_cd gicl_clm_docs.clm_doc_cd%TYPE,
      clm_doc_desc   gicl_clm_docs.clm_doc_desc%TYPE,
      priority_cd    gicl_clm_docs.priority_cd%TYPE,
      clm_doc_remark gicl_clm_docs.clm_doc_remark%TYPE,
      user_id        gicl_clm_docs.user_id%TYPE,
      last_update    VARCHAR2(50)
   ); 

   TYPE clm_docs_tab IS TABLE OF clm_docs_type;
   
   FUNCTION get_clm_docs_list(
      p_line_cd      gicl_clm_docs.line_cd%TYPE,
      p_subline_cd   gicl_clm_docs.subline_cd%TYPE
   ) RETURN clm_docs_tab PIPELINED;     
   
   PROCEDURE set_rec (p_rec gicl_clm_docs%ROWTYPE);

   PROCEDURE val_delete_rec (
      p_line_cd      gicl_clm_docs.line_cd%TYPE,
      p_subline_cd   gicl_clm_docs.subline_cd%TYPE,
      p_clm_doc_cd   gicl_clm_docs.clm_doc_cd%TYPE
   );

   PROCEDURE del_rec(p_rec gicl_clm_docs%ROWTYPE);
END;
/


