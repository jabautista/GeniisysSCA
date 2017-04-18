CREATE OR REPLACE PACKAGE CPI.GIISS035_PKG
AS 
    TYPE giis_required_docs_type IS RECORD (
        line_cd         giis_required_docs.line_cd%TYPE,
        subline_cd      giis_required_docs.subline_cd%TYPE,
        doc_cd          giis_required_docs.doc_cd%TYPE,
        doc_name        giis_required_docs.doc_name%TYPE,
        valid_flag      giis_required_docs.valid_flag%TYPE,
        effectivity_date VARCHAR2(20),
        remarks         giis_required_docs.remarks%TYPE,
        user_id         giis_required_docs.user_id%TYPE,
        last_update     giis_required_docs.last_update%TYPE,
        cpi_rec_no      giis_required_docs.cpi_rec_no%TYPE,
        cpi_branch_cd   giis_required_docs.cpi_branch_cd%TYPE
    );
    
    TYPE giis_required_docs_tab IS TABLE OF giis_required_docs_type;
    
    TYPE line_listing_type IS RECORD (
      line_cd         giis_line.line_cd%TYPE,
      line_name       giis_line.line_name%TYPE
    );

    TYPE line_listing_tab IS TABLE OF line_listing_type;
   
    FUNCTION get_giis_required_docs_list (
        p_line_cd     giis_required_docs.line_cd%TYPE
    )
        RETURN giis_required_docs_tab PIPELINED;
        
--    FUNCTION get_giis_line_list
--        RETURN line_listing_tab PIPELINED;

    -- Kris 05.23.2013: modified function get_giis_line_list params to use check_user_per_line2
    FUNCTION get_giis_line_list(
        p_module_id         GIIS_modules.module_id%TYPE,
        p_user_id           giis_users.user_id%TYPE
    ) RETURN line_listing_tab PIPELINED;
        
    PROCEDURE del_giis_required_doc(
        p_line_cd     giis_required_docs.line_cd%TYPE,
        p_subline_cd  giis_required_docs.subline_cd%TYPE,
        p_doc_cd      giis_required_docs.doc_cd%TYPE
    );
    
    PROCEDURE set_giis_required_doc(p_required_doc giis_required_docs%ROWTYPE);
   
    PROCEDURE pre_delete_validation(
        p_check_both        IN VARCHAR2,
        p_doc_cd            IN GIIS_REQUIRED_DOCS.doc_cd%TYPE,
        p_line_cd           IN GIIS_REQUIRED_DOCS.line_Cd%TYPE
    );
    
    --added by john dolon 11.27.2013
    TYPE rec_type IS RECORD (
      line_cd             giis_required_docs.line_cd%TYPE,
      subline_cd          giis_required_docs.subline_cd%TYPE,
      doc_cd              giis_required_docs.doc_cd%TYPE,
      doc_name            giis_required_docs.doc_name%TYPE,
      valid_flag          giis_required_docs.valid_flag%TYPE,
      effectivity_date    VARCHAR2(30),
      remarks             giis_required_docs.remarks%TYPE,
      user_id             giis_required_docs.user_id%TYPE,
      last_update         VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list(
        p_line_cd       VARCHAR2,
        p_subline_cd    VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_required_docs%ROWTYPE);

   PROCEDURE del_rec(
        p_line_cd     giis_required_docs.line_cd%TYPE,
        p_subline_cd  giis_required_docs.subline_cd%TYPE,
        p_doc_cd      giis_required_docs.doc_cd%TYPE
   );

   FUNCTION val_del_rec(
        p_line_cd     giis_required_docs.line_cd%TYPE,
        p_subline_cd  giis_required_docs.subline_cd%TYPE,
        p_doc_cd      giis_required_docs.doc_cd%TYPE
   )
   RETURN VARCHAR2;
   
   PROCEDURE val_add_rec(
        p_line_cd     giis_required_docs.line_cd%TYPE,
        p_subline_cd  giis_required_docs.subline_cd%TYPE,
        p_doc_cd      giis_required_docs.doc_cd%TYPE
   );
   
   TYPE giiss035_line_lov_type IS RECORD (
       line_cd   giis_line.line_cd%TYPE,
       line_name giis_line.line_name%TYPE
   ); 

   TYPE giiss035_line_lov_tab IS TABLE OF giiss035_line_lov_type;
   
   FUNCTION get_giiss035_line_lov(
        p_user      VARCHAR2
   )
   RETURN giiss035_line_lov_tab PIPELINED;
   
   TYPE giiss035_subline_lov_type IS RECORD (
       subline_cd   giis_subline.subline_cd%TYPE,
       subline_name giis_subline.subline_name%TYPE
   ); 

   TYPE giiss035_subline_lov_tab IS TABLE OF giiss035_subline_lov_type;
   
   FUNCTION get_giiss035_subline_lov(
        p_line_cd    VARCHAR2,
        p_search     VARCHAR2
   )
   RETURN giiss035_subline_lov_tab PIPELINED;
   
   PROCEDURE validate_line(
        p_line_cd   IN OUT VARCHAR2,
        p_line_name    OUT VARCHAR2,
        p_user             VARCHAR2
   );
   
   PROCEDURE validate_subline(
        p_line_cd       IN     VARCHAR2,
        p_subline_cd    IN OUT VARCHAR2,
        p_subline_name     OUT VARCHAR2
   );
    
END;
/


