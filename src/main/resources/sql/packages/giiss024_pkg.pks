CREATE OR REPLACE PACKAGE CPI.giiss024_pkg
AS
   TYPE rec_type IS RECORD (
      region_cd       giis_region.region_cd%TYPE,
      region_desc     giis_region.region_desc%TYPE,
      province_cd     giis_province.province_cd%TYPE,
      province_desc   giis_province.province_desc%TYPE,
      city_cd         giis_city.city_cd%TYPE,
      city            giis_city.city%TYPE,
      remarks         giis_province.remarks%TYPE,
      user_id         giis_region.user_id%TYPE,
      last_update     VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_region_cd       giis_region.region_cd%TYPE,
      p_region_desc     giis_region.region_desc%TYPE,
      p_province_cd     giis_province.province_cd%TYPE,
      p_province_desc   giis_province.province_desc%TYPE,
      p_city_cd         giis_city.city_cd%TYPE,
      p_city            giis_city.city%TYPE,
      p_mode            VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_giis_region (p_rec giis_region%ROWTYPE);

   PROCEDURE set_giis_province (p_rec giis_province%ROWTYPE);

   PROCEDURE set_giis_city (p_rec giis_city%ROWTYPE);

   PROCEDURE del_giis_region (p_region_cd giis_region.region_cd%TYPE);

   PROCEDURE del_giis_province (p_province_cd giis_province.province_cd%TYPE);

   PROCEDURE del_giis_city (
      p_city_cd       giis_city.city_cd%TYPE,
      p_province_cd   giis_city.province_cd%TYPE
   );

   PROCEDURE val_del_rec (
      p_rec_cd    VARCHAR2,
      p_rec_cd2   VARCHAR2,
      p_mode      VARCHAR2
   );

   PROCEDURE val_add_rec (
      p_rec_cd    VARCHAR2,
      p_rec_cd2   VARCHAR2,
      p_mode      VARCHAR2
   );
END;
/


