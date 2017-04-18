CREATE OR REPLACE PACKAGE CPI.Giis_Mortgagee_Pkg AS


  TYPE mortgagee_list_type IS RECORD
    (mortg_cd           GIIS_MORTGAGEE.mortg_cd%TYPE,
     mortg_name         GIIS_MORTGAGEE.mortg_name%TYPE);
  
  TYPE mortgagee_list_tab IS TABLE OF mortgagee_list_type; 
  
  --kenneth SR 5483 05.26.2016
  TYPE mortgagee_list_type1 IS RECORD
    (mortg_cd           GIIS_MORTGAGEE.mortg_cd%TYPE,
     mortg_name         GIIS_MORTGAGEE.mortg_name%TYPE,
     delete_sw          GIIS_MORTGAGEE.delete_sw%TYPE);
  
  TYPE mortgagee_list_tab1 IS TABLE OF mortgagee_list_type1; 
        
  FUNCTION get_mortgagee_list  (p_iss_cd    GIIS_MORTGAGEE.iss_cd%TYPE) 
    RETURN mortgagee_list_tab PIPELINED;
    
    FUNCTION get_policy_mortgagee_list (
        p_par_id IN gipi_wmortgagee.par_id%TYPE,
        p_iss_cd IN giis_mortgagee.iss_cd%TYPE)
    RETURN mortgagee_list_tab1 PIPELINED; --kenneth SR 5483 05.26.2016
    
    FUNCTION get_item_mortgagee_list (
        p_par_id IN gipi_wmortgagee.par_id%TYPE,
        p_iss_cd IN giis_mortgagee.iss_cd%TYPE)
    RETURN mortgagee_list_tab1 PIPELINED; --kenneth SR 5483 05.26.2016

    FUNCTION get_mortgagee_list1 (
        p_par_id IN gipi_witem.par_id%TYPE,
        p_item_no IN gipi_witem.item_no%TYPE,
        p_iss_cd IN giis_mortgagee.iss_cd%TYPE,
        p_find_text IN VARCHAR2)
    RETURN mortgagee_list_tab1 PIPELINED; --kenneth SR 5483 05.26.2016
	
	FUNCTION get_mortgagee_gipis165 (
		p_iss_cd	 giis_mortgagee.iss_cd%TYPE,
		p_mortg_name giis_mortgagee.mortg_name%TYPE,
		p_keyword	 VARCHAR2
	)
		RETURN mortgagee_list_tab PIPELINED;
END Giis_Mortgagee_Pkg;
/


