CREATE OR REPLACE PACKAGE BODY CPI.Giis_Fire_Construction_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: DSP_CONSTRUCTION_DESC 
***********************************************************************************/

  FUNCTION get_fire_construction_list 
    RETURN fire_construction_list_tab PIPELINED IS
	
	v_fire_cons		fire_construction_list_type;
	
  BEGIN
    FOR i IN (
		SELECT construction_desc, construction_cd 
		  FROM GIIS_FIRE_CONSTRUCTION 
		 ORDER BY construction_desc)
	LOOP
		v_fire_cons.construction_desc	:= i.construction_desc;
		v_fire_cons.construction_cd		:= i.construction_cd;
	  PIPE ROW(v_fire_cons);
	END LOOP;
	
    RETURN;
  END;

END Giis_Fire_Construction_Pkg;
/


