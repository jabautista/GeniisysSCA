CREATE OR REPLACE PACKAGE CPI.giiss051_pkg
AS
   TYPE rec_type IS RECORD (
      cargo_class_cd     giis_cargo_class.cargo_class_cd%TYPE,
      cargo_class_desc   giis_cargo_class.cargo_class_desc%TYPE,
      remarks            giis_cargo_class.remarks%TYPE,
      user_id            giis_cargo_class.user_id%TYPE,
      last_update        VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_cargo_class_cd     giis_cargo_class.cargo_class_cd%TYPE,
      p_cargo_class_desc   giis_cargo_class.cargo_class_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_cargo_class%ROWTYPE);

   PROCEDURE del_rec (p_cargo_class_cd giis_cargo_class.cargo_class_cd%TYPE);

   PROCEDURE val_del_rec (
      p_cargo_class_cd   giis_cargo_class.cargo_class_cd%TYPE
   );

   PROCEDURE val_add_rec (
      p_cargo_class_cd   giis_cargo_class.cargo_class_cd%TYPE
   );
END;
/


