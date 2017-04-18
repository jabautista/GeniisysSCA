CREATE OR REPLACE PACKAGE CPI.giis_city_pkg
AS
/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003
  RECORD GROUP NAME: CITY_RG
***********************************************************************************/
   TYPE city_list_type IS RECORD (
      city          giis_block.city%TYPE,
      city_cd       giis_block.city_cd%TYPE,
      province_cd   giis_block.province_cd%TYPE,
      province      giis_block.province%TYPE
   );

   TYPE city_list_tab IS TABLE OF city_list_type;

   FUNCTION get_city_list
      RETURN city_list_tab PIPELINED;

/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS003
  RECORD GROUP NAME: CITY_RG1
***********************************************************************************/
   TYPE city_by_province_list_type IS RECORD (
      city            giis_block.city%TYPE,
      city_cd         giis_block.city_cd%TYPE,
      province_cd     giis_block.province_cd%TYPE,
      province_desc   giis_block.province%TYPE,
      region_cd       giis_province.region_cd%TYPE
   );

   TYPE city_by_province_list_tab IS TABLE OF city_by_province_list_type;

   FUNCTION get_city_by_province_list (
      p_region_cd     IN   giis_province.region_cd%TYPE,
      p_province_cd   IN   giis_province.province_cd%TYPE
   )
      RETURN city_by_province_list_tab PIPELINED;

/********************************** FUNCTION 3 ************************************
  MODULE: GIIMM002
  RECORD GROUP NAME: LOV_CITY
***********************************************************************************/
   FUNCTION get_city_province_list (
      p_province_desc   giis_province.province_desc%TYPE
   )
      RETURN city_by_province_list_tab PIPELINED;

   FUNCTION get_city_listing (
      p_region_cd     giis_province.region_cd%TYPE,
      p_province_cd   giis_province.province_cd%TYPE,
      p_find_text     VARCHAR2
   )
      RETURN city_by_province_list_tab PIPELINED;

   FUNCTION get_city_listing_gicls010 (
      p_province_cd   giis_province.province_cd%TYPE
   )
      RETURN city_list_tab PIPELINED;
      
   TYPE location_type IS RECORD (
        location_cd     VARCHAR2(20),
        location_desc   VARCHAR2(150)
   );
   
   TYPE location_tab IS TABLE OF location_type;
   
   FUNCTION get_location_lov(p_keyword VARCHAR2)
        RETURN location_tab PIPELINED;
   
   
    FUNCTION get_city_listing_gipis155( 
        p_province_cd   GIIS_CITY.PROVINCE_CD%type
    ) RETURN city_list_tab PIPELINED;
   
END giis_city_pkg;
/


