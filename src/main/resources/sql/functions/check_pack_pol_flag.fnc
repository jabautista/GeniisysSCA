DROP FUNCTION CPI.CHECK_PACK_POL_FLAG;

CREATE OR REPLACE FUNCTION CPI.CHECK_PACK_POL_FLAG (p_par_id 	GIPI_WPOLBAS.par_id%TYPE)
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Get the pack_pol_flag of a certain record
	*/
	v_pack_pol_flag	GIPI_WPOLBAS.pack_pol_flag%TYPE;
BEGIN
	FOR TEMP IN(
		SELECT pack_pol_flag
		  FROM GIPI_WPOLBAS
		 WHERE par_id = p_par_id)
	LOOP
      v_pack_pol_flag := TEMP.pack_pol_flag;
      EXIT;
	END LOOP;
	RETURN v_pack_pol_flag;
END;
/


