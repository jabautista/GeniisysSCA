CREATE OR REPLACE PACKAGE CPI.giiss053_pkg
AS
   TYPE rec_type IS RECORD (
      flood_zone        giis_flood_zone.flood_zone%TYPE,
      flood_zone_desc   giis_flood_zone.flood_zone_desc%TYPE,
      zone_grp          giis_flood_zone.zone_grp%TYPE,
      remarks           giis_flood_zone.remarks%TYPE,
      user_id           giis_flood_zone.user_id%TYPE,
      last_update       VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_flood_zone          giis_flood_zone.flood_zone%TYPE,
      p_flood_zone_desc     giis_flood_zone.flood_zone_desc%TYPE,
      p_zone_grp            giis_flood_zone.zone_grp%TYPE
   )  RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_flood_zone%ROWTYPE);

   PROCEDURE del_rec (p_flood_zone giis_flood_zone.flood_zone%TYPE);

   PROCEDURE val_del_rec (p_flood_zone giis_flood_zone.flood_zone%TYPE);
   
   PROCEDURE val_add_rec (
        p_flood_zone        giis_flood_zone.flood_zone%TYPE,
        p_flood_zone_desc   giis_flood_zone.flood_zone_desc%TYPE
   );
   
END;
/


