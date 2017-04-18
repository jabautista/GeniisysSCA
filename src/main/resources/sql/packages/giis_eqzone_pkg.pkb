CREATE OR REPLACE PACKAGE BODY CPI.Giis_EqZone_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: CGFK$GIPI_WFIREITM6_DSP_EQ_DES  
***********************************************************************************/

  FUNCTION get_eqzone_list 
    RETURN eqzone_list_tab PIPELINED IS
	
	v_eqzone	eqzone_list_type;
	
  BEGIN
  	FOR i IN (
		SELECT eq_desc, eq_zone
		  FROM GIIS_EQZONE)
	LOOP
		v_eqzone.eq_desc 	:= i.eq_desc;
		v_eqzone.eq_zone 	:= i.eq_zone;
	  PIPE ROW(v_eqzone);
	END LOOP;
      
    RETURN;
  END;
 
	/*
	**  Created by		: Mark JM
	**  Date Created     : 05.04.2011
    **  Reference By     : (GIPIS003 - Item Information - FIRE)
    **  Description     : Returns eq zone listing
    */
    FUNCTION get_eqzone_listing(p_find_text IN VARCHAR2) RETURN eqzone_list_tab PIPELINED
    IS
        v_eqzone eqzone_list_type;
    BEGIN
        FOR i IN (
            SELECT eq_zone, eq_desc
              FROM giis_eqzone
             WHERE UPPER(eq_desc) LIKE UPPER(NVL(p_find_text, '%%')))
        LOOP
            v_eqzone.eq_zone := i.eq_zone;
            v_eqzone.eq_desc := i.eq_desc;
            
            PIPE ROW(v_eqzone);
        END LOOP;
    END get_eqzone_listing;
    
    /*
    **  Created by        : Mark JM
    **  Date Created    : 05.04.2011
    **  Reference By    : (GIPIS003 - Item Information - FIRE)
    **  Description     : Returns eq_desc based on the given eq_zone
    */
    FUNCTION get_eqzone_desc(p_eq_zone IN giis_eqzone.eq_zone%TYPE) RETURN giis_eqzone.eq_desc%TYPE
    IS
        v_eqzone_desc giis_eqzone.eq_desc%TYPE;
    BEGIN
        FOR i IN (
            SELECT eq_desc
              FROM giis_eqzone
             WHERE eq_zone = p_eq_zone)
        LOOP
            v_eqzone_desc := i.eq_desc;
        END LOOP;
        
        RETURN v_eqzone_desc;
    END get_eqzone_desc;

END Giis_EqZone_Pkg;
/


