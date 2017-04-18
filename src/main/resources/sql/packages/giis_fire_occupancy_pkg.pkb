CREATE OR REPLACE PACKAGE BODY CPI.Giis_Fire_Occupancy_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: DSP_OCCUPANCY_DESC 
***********************************************************************************/

  FUNCTION get_fire_occupancy_list 
    RETURN fire_occupancy_list_tab PIPELINED IS
	
	v_fire_occ		fire_occupancy_list_type;
	
  BEGIN
    FOR i IN (
		SELECT occupancy_desc, occupancy_cd 
		  FROM GIIS_FIRE_OCCUPANCY 
		 ORDER BY INITCAP(occupancy_desc))
	LOOP
		v_fire_occ.occupancy_desc	:= i.occupancy_desc;
		v_fire_occ.occupancy_cd		:= i.occupancy_cd;
	  PIPE ROW(v_fire_occ);
	END LOOP;
  
    RETURN;
  END;

  FUNCTION get_fire_occupancy_listing(p_find_text VARCHAR2) 
    RETURN fire_occupancy_list_tab PIPELINED IS
	
	v_fire_occ		fire_occupancy_list_type;
	
  BEGIN
    FOR i IN (
		SELECT occupancy_desc, occupancy_cd 
		  FROM GIIS_FIRE_OCCUPANCY
         WHERE UPPER(occupancy_desc) LIKE UPPER(NVL(p_find_text, '%%')) 
           AND active_tag = 'Y' --added by Kris 06.27.2013 for UW-SPECS-2013-00067
		 ORDER BY(occupancy_desc))
	LOOP
		v_fire_occ.occupancy_desc	:= i.occupancy_desc;
		v_fire_occ.occupancy_cd		:= i.occupancy_cd;
	  PIPE ROW(v_fire_occ);
	END LOOP;
  
    RETURN;
  END;

END Giis_Fire_Occupancy_Pkg;
/


