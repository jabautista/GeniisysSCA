CREATE OR REPLACE PACKAGE CPI.Giis_Coverage_Pkg AS

  TYPE coverage_list_type IS RECORD
    (coverage_cd          GIIS_COVERAGE.coverage_cd%TYPE,
     coverage_desc        GIIS_COVERAGE.coverage_desc%TYPE);
  
  TYPE coverage_list_tab IS TABLE OF coverage_list_type; 
        
  FUNCTION get_coverage_list (p_line       GIIS_COVERAGE.line_cd%TYPE,
  		   					  p_subline    GIIS_COVERAGE.subline_cd%TYPE)  
    RETURN coverage_list_tab PIPELINED;
	
	
  FUNCTION get_coverage2_list RETURN coverage_list_tab PIPELINED;	

END Giis_Coverage_Pkg;
/


