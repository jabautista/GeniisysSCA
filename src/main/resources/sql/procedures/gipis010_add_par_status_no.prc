DROP PROCEDURE CPI.GIPIS010_ADD_PAR_STATUS_NO;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Add_Par_Status_No (
	p_par_id		IN GIPI_PARLIST.par_id%TYPE,
	p_line_cd		IN GIPI_PARLIST.line_cd%TYPE,
	p_par_status	IN GIPI_PARLIST.par_status%TYPE,
	p_invoice_sw	IN VARCHAR2,
	p_iss_cd		IN GIPI_PARLIST.iss_cd%TYPE,
	p_result		OUT VARCHAR2)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.23.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Update the par status of the PAR
	** 					  in process depending on the changes
	** 					  made in this form
	**					  (Original description)
	*/
	v_dist_no	GIUW_POL_DIST.dist_no%TYPE;
	v_exist		VARCHAR2(1) := 'N';
BEGIN
	p_result := 'SUCCESS';
	FOR a IN (
		SELECT dist_no
		  FROM GIUW_POL_DIST
		 WHERE par_id = p_par_id)
	LOOP
		p_result := Changes_In_Par_Status(p_par_id, a.dist_no, p_line_cd, p_invoice_sw, p_iss_cd);
		IF NOT (p_result IS NULL) THEN
			EXIT;
		END IF;
		v_exist := 'Y';
	END LOOP;

	IF NOT (p_result IS NULL) THEN
		RETURN;
	END IF;

	IF v_exist = 'N' THEN
		p_result := Changes_In_Par_Status(p_par_id, v_dist_no, p_line_cd, p_invoice_sw, p_iss_cd);
	END IF;

	IF p_par_status = 3 OR p_par_status IS NULL THEN
		NULL;
	ELSIF p_par_status > 3 THEN
		NULL;
	ELSIF p_par_status < 3 THEN
		p_result := 'You are not granted access to this form. The changes that you have made will not be committed to the database.'; /* RAISE FORM_TRIGGER_FAILURE */
	END IF;
	p_result := NVL(p_result, 'SUCCESS');
END;
/


