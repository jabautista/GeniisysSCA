CREATE OR REPLACE PACKAGE BODY CPI.Giis_Control_Type_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS012 
  RECORD GROUP NAME: CONTROL_TYPE_CD  
***********************************************************************************/ 

  FUNCTION get_control_type_list 
    RETURN control_type_list_tab PIPELINED IS
	
	v_control	 control_type_list_type;
  
  BEGIN
    FOR i IN (
		SELECT control_type_cd,  ESCAPE_VALUE(control_type_desc) control_type_desc --ESCAPE_VALUE added by jeffdojello 04.29.2013 to handle single quote
		  FROM GIIS_CONTROL_TYPE
 	     ORDER BY control_type_desc)
	LOOP
		v_control.control_type_cd	:= i.control_type_cd;
		v_control.control_type_desc	:= i.control_type_desc;
	  PIPE ROW(v_control);
	END LOOP;
	
    RETURN;
  END get_control_type_list;

END Giis_Control_Type_Pkg;
/


