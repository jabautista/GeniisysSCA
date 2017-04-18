CREATE OR REPLACE PACKAGE CPI.Giis_EqZone_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: CGFK$GIPI_WFIREITM6_DSP_EQ_DES  
***********************************************************************************/

  TYPE eqzone_list_type IS RECORD
    (eq_desc    GIIS_EQZONE.eq_desc%TYPE,
     eq_zone    GIIS_EQZONE.eq_zone%TYPE);
     
  TYPE eqzone_list_tab IS TABLE OF eqzone_list_type;
  
  FUNCTION get_eqzone_list RETURN eqzone_list_tab PIPELINED;
  
    FUNCTION get_eqzone_listing(p_find_text IN VARCHAR2) RETURN eqzone_list_tab PIPELINED;
    
    FUNCTION get_eqzone_desc(p_eq_zone IN giis_eqzone.eq_zone%TYPE) RETURN giis_eqzone.eq_desc%TYPE;
  
END Giis_EqZone_Pkg;
/


