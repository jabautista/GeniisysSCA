CREATE OR REPLACE PACKAGE CPI.Giis_Flood_Zone_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: DSP_FLOOD_ZONE_DESC 
***********************************************************************************/

  TYPE flood_zone_list_type IS RECORD
    (flood_zone			GIIS_FLOOD_ZONE.flood_zone%TYPE,
	 flood_zone_desc	GIIS_FLOOD_ZONE.flood_zone_desc%TYPE);
	 
  TYPE flood_zone_list_tab IS TABLE OF flood_zone_list_type;
  
  FUNCTION get_flood_zone_list RETURN flood_zone_list_tab PIPELINED;

	FUNCTION get_flood_zone_listing(p_find_text IN VARCHAR2) RETURN flood_zone_list_tab PIPELINED;
	
	FUNCTION get_flood_zone_desc(p_flood_zone IN giis_flood_zone.flood_zone%TYPE) RETURN giis_flood_zone.flood_zone_desc%TYPE;
  
END Giis_Flood_Zone_Pkg;
/


