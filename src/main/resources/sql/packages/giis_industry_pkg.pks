CREATE OR REPLACE PACKAGE CPI.Giis_Industry_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS002 
  RECORD GROUP NAME: INDUSTRY   
***********************************************************************************/ 

  TYPE industry_list_type IS RECORD
  	   (industry_nm		  GIIS_INDUSTRY.industry_nm%TYPE,
	    industry_cd		  GIIS_INDUSTRY.industry_cd%TYPE);

  TYPE industry_list_tab IS TABLE OF industry_list_type; 

  FUNCTION get_industry_list RETURN industry_list_tab PIPELINED;
  
  
/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS017 
  RECORD GROUP NAME: INDUSTRY   
***********************************************************************************/
  
  FUNCTION get_industry_filtered_list(p_industry_nm GIIS_INDUSTRY.industry_nm%TYPE)
    RETURN industry_list_tab PIPELINED;
    
    FUNCTION get_industry_cd(p_assd_no IN giis_assured.assd_no%TYPE)
    RETURN NUMBER;
  
END Giis_Industry_Pkg;
/


