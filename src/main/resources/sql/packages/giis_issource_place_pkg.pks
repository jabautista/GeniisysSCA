CREATE OR REPLACE PACKAGE CPI.Giis_Issource_Place_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE:  GIPIS002 
  RECORD GROUP NAME: ISSOURCE_PLACE 
***********************************************************************************/ 

  TYPE place_list_type IS RECORD
  	   (place_cd		GIIS_ISSOURCE_PLACE.place_cd%TYPE,
   	    place			GIIS_ISSOURCE_PLACE.place%TYPE);
   
  TYPE place_list_tab IS TABLE OF place_list_type;
  
  FUNCTION get_place_list (p_iss_cd 		GIIS_ISSOURCE_PLACE.iss_cd%TYPE)
  RETURN place_list_tab PIPELINED;

END Giis_Issource_Place_Pkg;
/


