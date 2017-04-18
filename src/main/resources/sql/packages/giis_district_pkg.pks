CREATE OR REPLACE PACKAGE CPI.Giis_District_Pkg AS

	/********************************** FUNCTION 1 ************************************
	  MODULE: GIPIS003 
	  RECORD GROUP NAME: CGFK$GIPI_WFIREITM6_DISTRICT_N 
	***********************************************************************************/

  TYPE district_list_type IS RECORD (
	district_no			GIIS_BLOCK.district_no%TYPE,
	district_desc		GIIS_BLOCK.district_desc%TYPE,
	block_id			GIIS_BLOCK.block_id%TYPE,
	block_no			GIIS_BLOCK.block_no%TYPE,
	block_desc			GIIS_BLOCK.block_desc%TYPE,
	province_cd			GIIS_BLOCK.province_cd%TYPE,
	province_desc		GIIS_PROVINCE.province_desc%TYPE,
	city				GIIS_BLOCK.city%TYPE,
	eq_zone				GIIS_BLOCK.eq_zone%TYPE,
	typhoon_zone		GIIS_BLOCK.typhoon_zone%TYPE,
	flood_zone			GIIS_BLOCK.flood_zone%TYPE,
	eq_desc				GIIS_EQZONE.eq_desc%TYPE,
	typhoon_zone_desc	GIIS_TYPHOON_ZONE.typhoon_zone_desc%TYPE,
	flood_zone_desc		GIIS_FLOOD_ZONE.flood_zone_desc%TYPE);

	TYPE district_list_tab IS TABLE OF district_list_type;  
  
	FUNCTION get_district_list (p_province_desc    GIIS_PROVINCE.province_desc%TYPE,
							  p_city			 GIIS_BLOCK.city%TYPE)			
	RETURN district_list_tab PIPELINED;
    
    TYPE all_district_list_type IS RECORD(
      district_no			GIIS_BLOCK.district_no%TYPE,
	  district_desc		GIIS_BLOCK.district_desc%TYPE,
      city_cd				GIIS_BLOCK.city_cd%TYPE,
      province_cd			GIIS_BLOCK.province_cd%TYPE
    );
    
    TYPE all_district_list_tab IS TABLE OF all_district_list_type;
    
    FUNCTION get_all_district_list
    RETURN all_district_list_tab PIPELINED;

END Giis_District_Pkg;
/


