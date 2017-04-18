CREATE OR REPLACE PACKAGE CPI.Giis_Region_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE:  GIPIS002 
  RECORD GROUP NAME: REGION 
***********************************************************************************/ 

  TYPE region_list_type IS RECORD
  	   (region_cd		    GIIS_REGION.region_cd%TYPE,
   	    region_desc			GIIS_REGION.region_desc%TYPE);
   
  TYPE region_list_tab IS TABLE OF region_list_type;
  
  FUNCTION get_region_list RETURN region_list_tab PIPELINED;

END Giis_Region_Pkg;
/


