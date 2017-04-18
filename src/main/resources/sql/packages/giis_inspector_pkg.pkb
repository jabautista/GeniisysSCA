CREATE OR REPLACE PACKAGE BODY CPI.GIIS_INSPECTOR_PKG AS

  FUNCTION get_inspector_list RETURN inspector_list_tab PIPELINED
  
  IS
  
  	v_inspector				  inspector_list_type;
	
  BEGIN
  	   FOR i IN (
	   	   SELECT insp_cd, insp_name
	   	   	 FROM GIIS_INSPECTOR
		   ORDER BY insp_cd)
	   LOOP
	   	   v_inspector.insp_cd	 := i.insp_cd;
		   v_inspector.insp_name := i.insp_name;
		   PIPE ROW(v_inspector);
	   END LOOP;
	   RETURN;
  END;
  
END GIIS_INSPECTOR_PKG;
/


