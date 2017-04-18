CREATE OR REPLACE PACKAGE CPI.GIIS_INSPECTOR_PKG AS

  TYPE inspector_list_type IS RECORD
    (insp_cd			   GIIS_INSPECTOR.insp_cd%TYPE,
	 insp_name			   GIIS_INSPECTOR.insp_name%TYPE
	);
	
  TYPE inspector_list_tab IS TABLE OF inspector_list_type;
	
  FUNCTION get_inspector_list RETURN inspector_list_tab PIPELINED;
 
END GIIS_INSPECTOR_PKG;
/


