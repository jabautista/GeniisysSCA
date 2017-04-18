CREATE OR REPLACE PACKAGE CPI.giiss098_pkg
AS
   TYPE rec_type IS RECORD (
      construction_cd     giis_fire_construction.construction_cd%TYPE,
      construction_desc   giis_fire_construction.construction_desc%TYPE,
      remarks             giis_fire_construction.remarks%TYPE,
      user_id             giis_fire_construction.user_id%TYPE,
      last_update         VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_construction_cd     giis_fire_construction.construction_cd%TYPE,
      p_construction_desc   giis_fire_construction.construction_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_fire_construction%ROWTYPE);

   PROCEDURE del_rec (
      p_construction_cd   giis_fire_construction.construction_cd%TYPE
   );

   PROCEDURE val_del_rec (
      p_construction_cd   giis_fire_construction.construction_cd%TYPE
   );

   PROCEDURE val_add_rec (
      p_construction_cd   giis_fire_construction.construction_cd%TYPE
   );
END;
/


