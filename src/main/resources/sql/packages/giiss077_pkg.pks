CREATE OR REPLACE PACKAGE CPI.giiss077_pkg
AS
   TYPE rec_type IS RECORD (
      vestype_cd     giis_vestype.vestype_cd%TYPE,
      vestype_desc  giis_vestype.vestype_desc%TYPE,
      remarks     giis_vestype.remarks%TYPE,
      user_id     giis_vestype.user_id%TYPE,
      last_update VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_vestype_cd     giis_vestype.vestype_cd%TYPE,
      p_vestype_desc  giis_vestype.vestype_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_vestype%ROWTYPE);

   PROCEDURE del_rec (p_vestype_cd giis_vestype.vestype_cd%TYPE);

   PROCEDURE val_del_rec (p_vestype_cd giis_vestype.vestype_cd%TYPE);
   
   PROCEDURE val_add_rec(p_vestype_cd giis_vestype.vestype_cd%TYPE);
   
END;
/


