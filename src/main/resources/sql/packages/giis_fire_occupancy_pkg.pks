CREATE OR REPLACE PACKAGE CPI.Giis_Fire_Occupancy_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: DSP_OCCUPANCY_DESC 
***********************************************************************************/

  TYPE fire_occupancy_list_type IS RECORD
    (occupancy_desc		GIIS_FIRE_OCCUPANCY.occupancy_desc%TYPE,
	 occupancy_cd		GIIS_FIRE_OCCUPANCY.occupancy_cd%TYPE);

  TYPE fire_occupancy_list_tab IS TABLE OF fire_occupancy_list_type;

  FUNCTION get_fire_occupancy_list RETURN fire_occupancy_list_tab PIPELINED;
  
  FUNCTION get_fire_occupancy_listing(p_find_text VARCHAR2)
    RETURN fire_occupancy_list_tab PIPELINED;

END Giis_Fire_Occupancy_Pkg;
/


