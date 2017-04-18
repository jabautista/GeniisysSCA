CREATE OR REPLACE PACKAGE CPI.GIISS046_PKG
AS
   TYPE rec_type IS RECORD (
      hull_type_cd   giis_hull_type.hull_type_cd%TYPE,
      hull_desc      giis_hull_type.hull_desc%TYPE,
      remarks        giis_hull_type.remarks%TYPE,
      user_id        giis_hull_type.user_id%TYPE,
      last_update    VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_hull_type_cd   giis_hull_type.hull_type_cd%TYPE,
      p_hull_desc      giis_hull_type.hull_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_hull_type%ROWTYPE);

   PROCEDURE del_rec (p_hull_type_cd giis_hull_type.hull_type_cd%TYPE);

   PROCEDURE val_del_rec (p_hull_type_cd giis_hull_type.hull_type_cd%TYPE);

   PROCEDURE val_add_rec (p_hull_type_cd giis_hull_type.hull_type_cd%TYPE);
END GIISS046_PKG;
/


