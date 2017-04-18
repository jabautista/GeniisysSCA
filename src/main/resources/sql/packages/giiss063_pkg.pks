CREATE OR REPLACE PACKAGE CPI.giiss063_pkg
AS
   TYPE rec_type IS RECORD (
      class_cd     giis_class.class_cd%TYPE,
      class_desc  giis_class.class_desc%TYPE,
      remarks     giis_class.remarks%TYPE,
      user_id     giis_class.user_id%TYPE,
      last_update VARCHAR2 (30) 
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_class_cd     giis_class.class_cd%TYPE,
      p_class_desc  giis_class.class_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_class%ROWTYPE);

   PROCEDURE del_rec (p_class_cd giis_class.class_cd%TYPE);

   PROCEDURE val_del_rec (p_class_cd giis_class.class_cd%TYPE);
   
   PROCEDURE val_add_rec(p_class_cd giis_class.class_cd%TYPE);
   
   PROCEDURE val_add_rec2 (p_class_desc giis_class.class_desc%TYPE);
END;
/


