DROP FUNCTION CPI.VALIDATE_PAR_STATUS2;

CREATE OR REPLACE FUNCTION CPI.Validate_Par_Status2 (p_par_id GIPI_PARLIST.par_id%TYPE)
RETURN NUMBER
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Returns the par_status of the given par_id
	*/
	v_result 	GIPI_PARLIST.par_status%TYPE;
BEGIN
	FOR a IN (
		SELECT par_status	  
		  FROM GIPI_PARLIST
		 WHERE par_id = p_par_id)
	LOOP
		v_result := a.par_status;
	END LOOP;
	 
	RETURN v_result;
END;
/


