CREATE OR REPLACE PACKAGE CPI.giiss097_pkg
AS
   TYPE rec_type IS RECORD (
      occupancy_cd     giis_fire_occupancy.occupancy_cd%TYPE,
      occupancy_desc   giis_fire_occupancy.occupancy_desc%TYPE,
      active_tag       giis_fire_occupancy.active_tag%TYPE,
      remarks          giis_fire_occupancy.remarks%TYPE,
      user_id          giis_fire_occupancy.user_id%TYPE,
      last_update      VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_occupancy_cd     giis_fire_occupancy.occupancy_cd%TYPE,
      p_occupancy_desc   giis_fire_occupancy.occupancy_desc%TYPE,
      p_active_tag       giis_fire_occupancy.active_tag%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_fire_occupancy%ROWTYPE);

   PROCEDURE del_rec (p_occupancy_cd giis_fire_occupancy.occupancy_cd%TYPE);

   PROCEDURE val_del_rec (
      p_occupancy_cd   giis_fire_occupancy.occupancy_cd%TYPE
   );

   PROCEDURE val_add_rec (
      p_occupancy_cd     giis_fire_occupancy.occupancy_cd%TYPE,
      p_occupancy_desc   giis_fire_occupancy.occupancy_desc%TYPE
   );
END;
/


