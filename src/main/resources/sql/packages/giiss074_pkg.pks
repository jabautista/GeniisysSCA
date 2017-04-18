CREATE OR REPLACE PACKAGE CPI.giiss074_pkg
AS
   TYPE rec_type IS RECORD (
      ri_type         giis_ri_type_docs.ri_type%TYPE,
      doc_cd          giis_ri_type_docs.doc_cd%TYPE,
      doc_name        giis_ri_type_docs.doc_name%TYPE,
      remarks         giis_ri_type_docs.remarks%TYPE,
      user_id         giis_ri_type_docs.user_id%TYPE,
      last_update     VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list(p_ri_type VARCHAR2) 
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_ri_type_docs%ROWTYPE);

   PROCEDURE del_rec (p_ri_type giis_ri_type_docs.ri_type%TYPE, p_doc_cd giis_ri_type_docs.doc_cd%TYPE);

   FUNCTION val_del_rec (p_ri_type giis_ri_type_docs.ri_type%TYPE, p_doc_cd giis_ri_type_docs.doc_cd%TYPE)
   RETURN VARCHAR2;
   
   PROCEDURE val_add_rec(p_ri_type giis_ri_type_docs.ri_type%TYPE, p_doc_cd giis_ri_type_docs.doc_cd%TYPE);
   
   TYPE giiss074_lov_type IS RECORD (
      ri_type         GIIS_REINSURER_TYPE.ri_type%TYPE,
      ri_type_desc    GIIS_REINSURER_TYPE.ri_type_desc%TYPE
   ); 

   TYPE giiss074_lov_tab IS TABLE OF giiss074_lov_type;
   
   FUNCTION get_giiss074_lov(p_search VARCHAR2) 
      RETURN giiss074_lov_tab PIPELINED;
      
   PROCEDURE validate_ri_type(
        p_ri_type   IN OUT VARCHAR2,
        p_ri_type_desc OUT VARCHAR2
    );
   
END;
/


