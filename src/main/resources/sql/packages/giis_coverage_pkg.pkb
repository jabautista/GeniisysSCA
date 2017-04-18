CREATE OR REPLACE PACKAGE BODY CPI.Giis_Coverage_Pkg AS

  FUNCTION get_coverage_list (p_line       GIIS_COVERAGE.line_cd%TYPE,
  		   					  p_subline    GIIS_COVERAGE.subline_cd%TYPE) 
    RETURN coverage_list_tab PIPELINED  IS
	
	v_coverage      coverage_list_type;
    
  BEGIN  
    FOR i IN (
      SELECT coverage_cd, coverage_desc
        FROM GIIS_COVERAGE
--       WHERE NVL(line_cd, NVL(p_line,'@@@')) = NVL(p_line, NVL(line_cd,'@@@'))
--         AND NVL(subline_cd, NVL(p_subline,'@@@')) = NVL(p_subline, NVL(subline_cd,'@@@')))
        WHERE NVL(line_cd, NVL(p_line, '%')) = NVL(p_line, '%')
         AND NVL(subline_cd, NVL(p_subline, '%')) = NVL(p_subline, '%')) --edited by gab 11.16.2015

    LOOP
	  v_coverage.coverage_cd  := i.coverage_cd;
	  v_coverage.coverage_desc     := i.coverage_desc;             
      PIPE ROW (v_coverage);
    END LOOP;
	
	RETURN;  
  END get_coverage_list;
  

  FUNCTION get_coverage2_list 
    RETURN coverage_list_tab PIPELINED IS
	
	v_coverage      coverage_list_type;
    
  BEGIN  
    FOR i IN (
		SELECT coverage_cd, coverage_desc
		  FROM GIIS_COVERAGE)
    LOOP
	  v_coverage.coverage_cd    := i.coverage_cd;
	  v_coverage.coverage_desc  := i.coverage_desc;             
      PIPE ROW (v_coverage);
    END LOOP;
	
	RETURN;  
  END get_coverage2_list;  

END Giis_Coverage_Pkg;
/


