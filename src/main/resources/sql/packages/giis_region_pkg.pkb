CREATE OR REPLACE PACKAGE BODY CPI.Giis_Region_Pkg AS

  FUNCTION get_region_list
  RETURN region_list_tab PIPELINED IS
     v_region region_list_type;
  BEGIN
  	   FOR i IN (
	   	   SELECT region_desc, region_cd
		     FROM GIIS_REGION
		    ORDER BY UPPER(region_desc))
	   LOOP
	     v_region.region_cd  	 := i.region_cd;
		 v_region.region_desc	 := i.region_desc;

		 PIPE ROW(v_region);
	   END LOOP;
  RETURN;
  END get_region_list;

END Giis_Region_Pkg;
/


