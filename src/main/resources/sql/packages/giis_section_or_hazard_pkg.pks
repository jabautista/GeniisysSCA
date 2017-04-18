CREATE OR REPLACE PACKAGE CPI.Giis_Section_Or_Hazard_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS011 
  RECORD GROUP NAME: CGFK$B720_SECTION_OR_HAZARD_CD  
***********************************************************************************/ 

  TYPE section_or_hazard_list_type IS RECORD
    (section_or_hazard_cd		   GIIS_SECTION_OR_HAZARD.section_or_hazard_cd%TYPE,
	 section_line_cd		   	   GIIS_SECTION_OR_HAZARD.section_line_cd%TYPE,
	 section_subline_cd		   	   GIIS_SECTION_OR_HAZARD.section_subline_cd%TYPE,
	 section_or_hazard_title	   GIIS_SECTION_OR_HAZARD.section_or_hazard_title%TYPE);
	 
  TYPE section_or_hazard_list_tab IS TABLE OF section_or_hazard_list_type;  

  FUNCTION get_section_or_hazard_list (p_line_cd  	  GIIS_SECTION_OR_HAZARD.section_line_cd%TYPE,
  		   					     	   p_subline_cd   GIIS_SECTION_OR_HAZARD.section_subline_cd%TYPE)
	RETURN section_or_hazard_list_tab PIPELINED;


/********************************** FUNCTION 2 ************************************
  MODULE: GIIMM002 
  RECORD GROUP NAME: SECTION_OR_HAZARD  
***********************************************************************************/ 

  FUNCTION get_section_or_hazard2_list RETURN section_or_hazard_list_tab PIPELINED;	
  
  FUNCTION get_section_or_hazard_lov(p_line_cd giis_section_or_hazard.section_line_cd%TYPE, --Added by Jerome 09.07.2016 SR 5644
                                     p_subline_cd giis_section_or_hazard.section_subline_cd%TYPE) --Added by Jerome 09.07.2016 SR 5644 
  RETURN section_or_hazard_list_tab PIPELINED;
	
END Giis_Section_Or_Hazard_Pkg;
/


