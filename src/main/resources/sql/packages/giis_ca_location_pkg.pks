CREATE OR REPLACE PACKAGE CPI.GIIS_CA_LOCATION_PKG 
AS

  TYPE ca_location_list_type IS RECORD
    (location_cd			GIIS_CA_LOCATION.location_cd%TYPE,
	 location_desc			GIIS_CA_LOCATION.location_desc%TYPE);

  TYPE ca_location_list_tab IS TABLE OF ca_location_list_type;
  
/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS011  
  RECORD GROUP NAME: LOC_CD_DESC  
***********************************************************************************/

    FUNCTION get_ca_location_list
    RETURN ca_location_list_tab PIPELINED;
  
END;
/


