CREATE OR REPLACE PACKAGE CPI.Giis_Fire_Construction_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: DSP_CONSTRUCTION_DESC 
***********************************************************************************/

  TYPE fire_construction_list_type IS RECORD
    (construction_desc		GIIS_FIRE_CONSTRUCTION.construction_desc%TYPE,
	 construction_cd		GIIS_FIRE_CONSTRUCTION.construction_cd%TYPE);
	 
  TYPE fire_construction_list_tab IS TABLE OF fire_construction_list_type;

  FUNCTION get_fire_construction_list RETURN fire_construction_list_tab PIPELINED;

END Giis_Fire_Construction_Pkg;
/


