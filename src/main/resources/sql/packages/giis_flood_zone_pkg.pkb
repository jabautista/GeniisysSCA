CREATE OR REPLACE PACKAGE BODY CPI.Giis_Flood_Zone_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: DSP_FLOOD_ZONE_DESC 
***********************************************************************************/

  FUNCTION get_flood_zone_list 
    RETURN flood_zone_list_tab PIPELINED IS
	
	v_flood		flood_zone_list_type;
	
  BEGIN
  	FOR i IN (
		SELECT flood_zone, flood_zone_desc 
		  FROM GIIS_FLOOD_ZONE
		 ORDER BY flood_zone)
	LOOP
		v_flood.flood_zone 		:= i.flood_zone;
		v_flood.flood_zone_desc	:= i.flood_zone_desc;
	  PIPE ROW(v_flood);
	END LOOP;
  
    RETURN;
  END get_flood_zone_list;
  
    /*
    **  Created by        : Mark JM
    **  Date Created    : 05.04.2011
    **  Reference By    : (GIPIS003 - Item Information - FIRE)
    **  Description     : Returns flood zone listing
    */
    FUNCTION get_flood_zone_listing(p_find_text IN VARCHAR2) RETURN flood_zone_list_tab PIPELINED
    IS
        v_flood flood_zone_list_type;
    BEGIN
        FOR i IN (
            SELECT flood_zone, flood_zone_desc
              FROM giis_flood_zone
             WHERE UPPER(flood_zone_desc) LIKE UPPER(NVL(p_find_text, '%%'))
          ORDER BY flood_zone_desc)
        LOOP
            v_flood.flood_zone         := i.flood_zone;
            v_flood.flood_zone_desc    := i.flood_zone_desc;
            
            PIPE ROW(v_flood);
        END LOOP;
        
        RETURN;
    END get_flood_zone_listing;
    
    /*
    **  Created by        : Mark JM
    **  Date Created    : 05.04.2011
    **  Reference By    : (GIPIS003 - Item Information - FIRE)
    **  Description     : Returns flood_zone_desc based on the given flood_zone
    */
    FUNCTION get_flood_zone_desc(p_flood_zone IN giis_flood_zone.flood_zone%TYPE) 
    RETURN giis_flood_zone.flood_zone_desc%TYPE
    IS
        v_flood_zone_desc giis_flood_zone.flood_zone_desc%TYPE;
    BEGIN
        FOR i IN (
            SELECT flood_zone_desc
              FROM giis_flood_zone
             WHERE flood_zone = p_flood_zone)
        LOOP
            v_flood_zone_desc := i.flood_zone_desc;
        END LOOP;
        
        RETURN v_flood_zone_desc;
    END get_flood_zone_desc;

END Giis_Flood_Zone_Pkg;
/


