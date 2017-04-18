CREATE OR REPLACE PACKAGE BODY CPI.GIIS_CA_LOCATION_PKG 
AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS011  
  RECORD GROUP NAME: LOC_CD_DESC  
***********************************************************************************/
  FUNCTION get_ca_location_list
    RETURN ca_location_list_tab PIPELINED IS
	v_loc  ca_location_list_type;
  BEGIN
    FOR i IN (SELECT location_cd, location_desc
		  	    FROM giis_ca_location
			   ORDER BY upper(location_desc))
	LOOP
	  v_loc.location_cd     := i.location_cd;
	  v_loc.location_desc   := i.location_desc; 
	PIPE ROW(v_loc);
    END LOOP;
    RETURN;			
  END;	

END;
/


