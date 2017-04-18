DROP FUNCTION CPI.GET_ISS_PLACE;

CREATE OR REPLACE FUNCTION CPI.get_iss_place (p_iss_cd   IN giis_issource.iss_cd%TYPE,
                                          p_place_cd IN giis_issource_place.place%TYPE)
         RETURN VARCHAR2 AS
  v_place giis_issource_place.place%TYPE;
BEGIN
  FOR plc IN (SELECT place
                FROM giis_issource_place
			   WHERE place_cd = p_place_cd
			     AND iss_cd   = p_iss_cd)
  LOOP
    RETURN(plc.place);
	EXIT;
  END LOOP;
  RETURN(NULL);
END;
/


