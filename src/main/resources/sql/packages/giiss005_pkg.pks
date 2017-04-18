CREATE OR REPLACE PACKAGE CPI.GIISS005_PKG
AS

   TYPE tariff_type IS RECORD(
      tarf_cd                 giis_tariff.tarf_cd%TYPE,
      tarf_desc               giis_tariff.tarf_desc%TYPE,
      tarf_rate               giis_tariff.tarf_rate%TYPE,
      tarf_remarks            giis_tariff.tarf_remarks%TYPE,
      occupancy_cd            giis_tariff.occupancy_cd%TYPE,
      occupancy_desc          giis_fire_occupancy.occupancy_desc%TYPE,
      tariff_zone             giis_tariff.tariff_zone%TYPE,
      tariff_zone_desc        giis_tariff_zone.tariff_zone_desc%TYPE,
      remarks                 giis_tariff.remarks%TYPE,
      user_id                 giis_tariff.user_id%TYPE,
      last_update             VARCHAR2(50)
   );
   TYPE tariff_tab IS TABLE OF tariff_type;
   
   TYPE occupancy_type IS RECORD(
      occupancy_cd            giis_fire_occupancy.occupancy_cd%TYPE,
      occupancy_desc          giis_fire_occupancy.occupancy_desc%TYPE
   );
   TYPE occupancy_tab IS TABLE OF occupancy_type;
   
   TYPE tariff_zone_type IS RECORD(
      tariff_zone             giis_tariff_zone.tariff_zone%TYPE,
      tariff_zone_desc        giis_tariff_zone.tariff_zone_desc%TYPE
   );
   TYPE tariff_zone_tab IS TABLE OF tariff_zone_type;

   FUNCTION get_rec_list(
      p_tarf_cd               giis_tariff.tarf_cd%TYPE,
      p_tarf_desc             giis_tariff.tarf_desc%TYPE,
      p_tarf_rate             giis_tariff.tarf_rate%TYPE,
      p_tarf_remarks          giis_tariff.tarf_remarks%TYPE
   )
     RETURN tariff_tab PIPELINED;
     
   FUNCTION get_occupancy_lov(
      p_find_text             VARCHAR2
   )
     RETURN occupancy_tab PIPELINED;
     
   FUNCTION get_tariff_lov(
      p_find_text             VARCHAR2
   )
     RETURN tariff_zone_tab PIPELINED;
     
   PROCEDURE val_add_rec(
      p_tarf_cd               giis_tariff.tarf_cd%TYPE
   );
   
   PROCEDURE set_rec(
      p_rec                   giis_tariff%ROWTYPE
   );

   PROCEDURE val_del_rec(
      p_tarf_cd               giis_tariff.tarf_cd%TYPE
   );

   PROCEDURE del_rec(
      p_tarf_cd               giis_tariff.tarf_cd%TYPE
   );

END;
/


