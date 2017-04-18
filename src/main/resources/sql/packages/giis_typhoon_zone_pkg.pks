CREATE OR REPLACE PACKAGE CPI.Giis_Typhoon_Zone_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: GIPI_WFIREITM6_DSP_TYPHOON 
***********************************************************************************/

  TYPE typhoon_zone_list_type IS RECORD
    (typhoon_zone        GIIS_TYPHOON_ZONE.typhoon_zone%TYPE,
     typhoon_zone_desc    GIIS_TYPHOON_ZONE.typhoon_zone_desc%TYPE);
     
  TYPE typhoon_zone_list_tab IS TABLE OF typhoon_zone_list_type;
  
    FUNCTION get_typhoon_zone_list RETURN typhoon_zone_list_tab PIPELINED;
    
    FUNCTION get_typhoon_zone_listing(p_find_text IN VARCHAR2) RETURN typhoon_zone_list_tab PIPELINED;
	
	FUNCTION get_typhoon_zone_desc(p_typhoon_zone IN giis_typhoon_zone.typhoon_zone%TYPE)
	RETURN giis_typhoon_zone.typhoon_zone_desc%TYPE;
  
END Giis_Typhoon_Zone_Pkg;
/


