CREATE OR REPLACE PACKAGE CPI.GIISS169_PKG
AS
   TYPE inspector_type IS RECORD (
      insp_cd              giis_inspector.insp_cd%TYPE,
      insp_name            giis_inspector.insp_name%TYPE,
      remarks              giis_inspector.remarks%TYPE,
      user_id              giis_inspector.user_id%TYPE,
      last_update          VARCHAR2(100)
   );

   TYPE inspector_tab IS TABLE OF inspector_type;

   FUNCTION get_inspector_list
   RETURN inspector_tab PIPELINED;
   
   PROCEDURE set_rec (p_rec giis_inspector%ROWTYPE);

   PROCEDURE del_rec (p_insp_cd giis_inspector.insp_cd%TYPE);

   PROCEDURE val_del_rec (p_insp_cd giis_inspector.insp_cd%TYPE);
   
   PROCEDURE val_add_rec(p_insp_name giis_inspector.insp_name%TYPE);
END;
/


