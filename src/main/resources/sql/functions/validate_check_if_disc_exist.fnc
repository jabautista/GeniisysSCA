DROP FUNCTION CPI.VALIDATE_CHECK_IF_DISC_EXIST;

CREATE OR REPLACE FUNCTION CPI.Validate_Check_If_Disc_Exist (
	p_par_id	GIPI_WPERIL_DISCOUNT.par_id%TYPE)
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.01.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Checks if record/s exists in GIPI_WPERIL_DISCOUNT based on the par_id
	*/
	v_result VARCHAR2(1);
BEGIN
	FOR D1 IN(
		SELECT 1
		  FROM GIPI_WPERIL_DISCOUNT
		 WHERE par_id = p_par_id )
	LOOP
		v_result := 'Y';
		EXIT;
	END LOOP;
	RETURN v_result;
END;
/


