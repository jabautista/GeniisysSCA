CREATE OR REPLACE PACKAGE CPI.giis_block_pkg
AS
   /********************************** FUNCTION 1 ************************************
     MODULE: GIPIS003
     RECORD GROUP NAME: BLOCK_NO
   ***********************************************************************************/
   TYPE block_list_type IS RECORD (
      block_no            giis_block.block_no%TYPE,
      block_id            giis_block.block_id%TYPE,
      district_no         giis_block.district_no%TYPE,
      district_desc       giis_block.district_desc%TYPE,
      block_desc          giis_block.block_desc%TYPE,
      region_cd           giis_province.region_cd%TYPE,
      province_cd         giis_block.province_cd%TYPE,
      province_desc       giis_province.province_desc%TYPE,
      city_cd             giis_block.city_cd%TYPE,
      city                giis_block.city%TYPE,
      eq_zone             giis_block.eq_zone%TYPE,
      typhoon_zone        giis_block.typhoon_zone%TYPE,
      flood_zone          giis_block.flood_zone%TYPE,
      eq_desc             giis_eqzone.eq_desc%TYPE,
      typhoon_zone_desc   giis_typhoon_zone.typhoon_zone_desc%TYPE,
      flood_zone_desc     giis_flood_zone.flood_zone_desc%TYPE
   );

   TYPE block_list_tab IS TABLE OF block_list_type;

   FUNCTION get_block_list (
      p_region_cd     IN   giis_province.region_cd%TYPE,
      p_province_cd   IN   giis_block.province_cd%TYPE,
      p_city_cd       IN   giis_block.city_cd%TYPE,
      p_district_no   IN   giis_block.district_no%TYPE
   )
      RETURN block_list_tab PIPELINED;

   TYPE all_block_list_type IS RECORD (
      block_no        giis_block.block_no%TYPE,
      block_id        giis_block.block_id%TYPE,
      block_desc      giis_block.block_desc%TYPE,
      city_cd         giis_block.city_cd%TYPE,
      district_no     giis_block.district_no%TYPE,
      district_desc   giis_block.district_desc%TYPE,
      eq_zone         giis_block.eq_zone%TYPE,
      typhoon_zone    giis_block.typhoon_zone%TYPE,
      province_cd     giis_block.province_cd%TYPE,
      flood_zone      giis_block.flood_zone%TYPE
   );

   TYPE all_block_list_tab IS TABLE OF all_block_list_type;

   FUNCTION get_all_block_list
      RETURN all_block_list_tab PIPELINED;

   FUNCTION get_block_id (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE,
      p_district_no   giis_block.district_no%TYPE,
      p_block_no      giis_block.block_no%TYPE
   )
      RETURN VARCHAR2;

   TYPE giis_block_district_type IS RECORD (
      city            giis_block.city%TYPE,
      city_cd         giis_block.city_cd%TYPE,
      province_cd     giis_block.province_cd%TYPE,
      province        giis_block.province%TYPE,
      district_no     giis_block.district_no%TYPE,
      district_desc   giis_block.district_desc%TYPE,
      block_id        giis_block.block_id%TYPE,
      block_desc      giis_block.block_desc%TYPE,
      block_no        giis_block.block_no%TYPE
   );

   TYPE giis_block_district_tab IS TABLE OF giis_block_district_type;

   FUNCTION get_dtls_from_district (
      p_province_cd   giis_block.city_cd%TYPE,
      p_city_cd       giis_block.province_cd%TYPE
   )
      RETURN giis_block_district_tab PIPELINED;
      
   FUNCTION get_dtls_from_block (
      p_province_cd   giis_block.city_cd%TYPE,
      p_city_cd       giis_block.province_cd%TYPE,
      p_district_no   giis_block.district_no%TYPE
   )   
      RETURN giis_block_district_tab PIPELINED;
      
    FUNCTION get_block_list_tg (
        p_region_cd IN giis_province.region_cd%TYPE,
        p_province_cd IN giis_block.province_cd%TYPE,
        p_city_cd IN giis_block.city_cd%TYPE,
        p_district_no IN giis_block.district_no%TYPE,
        p_find_text IN VARCHAR2)
    RETURN block_list_tab PIPELINED;
    
    
    TYPE gipis155_district_type IS RECORD(
        district_no     giis_block.DISTRICT_NO%type,
        district_desc   giis_block.DISTRICT_DESC%type
    );
    
    TYPE gipis155_district_tab IS TABLE OF gipis155_district_type;
    
    
    FUNCTION get_district_listing_gipis155(
        p_province_cd       giis_block.PROVINCE_CD%type,
        p_city_cd           giis_block.CITY_CD%type
    ) RETURN gipis155_district_tab PIPELINED;
    
    
     TYPE gipis155_block_type IS RECORD(
        block_no     giis_block.block_NO%type,
        block_desc   giis_block.block_DESC%type
    );
    
    TYPE gipis155_block_tab IS TABLE OF gipis155_block_type;
    
    
    FUNCTION get_block_listing_gipis155(
        p_province_cd       giis_block.PROVINCE_CD%type,
        p_city_cd           giis_block.CITY_CD%type,
        p_district_no       giis_block.DISTRICT_NO%type
    ) RETURN gipis155_block_tab PIPELINED;
      
END giis_block_pkg;
/


