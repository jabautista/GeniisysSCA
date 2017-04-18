CREATE OR REPLACE PACKAGE BODY CPI.Giis_Issource_Place_Pkg AS
  
  FUNCTION get_place_list (p_iss_cd 		GIIS_ISSOURCE_PLACE.iss_cd%TYPE)
  RETURN place_list_tab PIPELINED IS
     v_place place_list_type;
  BEGIN
  	   FOR i IN (
	   	   SELECT place, place_cd
   	         FROM GIIS_ISSOURCE_PLACE
 		    WHERE iss_cd = p_iss_cd)
	   LOOP
	     v_place.place_cd  := i.place_cd;
		 v_place.place	   := i.place;
		 
		 PIPE ROW(v_place);
	   END LOOP;		
  RETURN;
  END get_place_list;
  
END Giis_Issource_Place_Pkg;
/


