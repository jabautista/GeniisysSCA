CREATE OR REPLACE PACKAGE CPI.Giis_Control_Type_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS012 
  RECORD GROUP NAME: CONTROL_TYPE_CD  
***********************************************************************************/ 

  TYPE control_type_list_type IS RECORD
    (control_type_cd	GIIS_CONTROL_TYPE.control_type_cd%TYPE,
	 control_type_desc	GIIS_CONTROL_TYPE.control_type_desc%TYPE);
	 
  TYPE control_type_list_tab IS TABLE OF control_type_list_type;
  
  FUNCTION get_control_type_list RETURN control_type_list_tab PIPELINED;

END Giis_Control_Type_Pkg;
/


