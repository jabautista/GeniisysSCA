CREATE OR REPLACE PACKAGE CPI.Giis_Position_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS011 
  RECORD GROUP NAME: CGFK$B975_CAPACITY_CD   
***********************************************************************************/ 

  TYPE position_list_type IS RECORD
    (position		GIIS_POSITION.position%TYPE,
	 position_cd	GIIS_POSITION.position_cd%TYPE);
	 
  TYPE position_list_tab IS TABLE OF position_list_type;

  FUNCTION get_position_list RETURN position_list_tab PIPELINED;
  
  FUNCTION get_capacity_lov RETURN position_list_tab PIPELINED;

END Giis_Position_Pkg;
/


