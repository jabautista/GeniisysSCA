CREATE OR REPLACE PACKAGE CPI.giiss011_pkg
AS
   TYPE rec_type IS RECORD (
      eq_zone         giis_eqzone.eq_zone%TYPE,
      eq_desc         giis_eqzone.eq_desc%TYPE,
      zone_grp        giis_eqzone.zone_grp%TYPE,
      remarks         giis_eqzone.remarks%TYPE,
      user_id         giis_eqzone.user_id%TYPE,
      last_update     VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_eq_zone    giis_eqzone.eq_zone%TYPE,
      p_eq_desc    giis_eqzone.eq_desc%TYPE,
      p_zone_grp   giis_eqzone.zone_grp%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_eqzone%ROWTYPE);

   PROCEDURE del_rec (p_eq_zone giis_eqzone.eq_zone%TYPE);

   PROCEDURE val_del_rec (p_eq_zone giis_eqzone.eq_zone%TYPE);

   PROCEDURE val_add_rec (
      p_eq_zone   giis_eqzone.eq_zone%TYPE,
      p_eq_desc   giis_eqzone.eq_desc%TYPE
   );
END;
/


