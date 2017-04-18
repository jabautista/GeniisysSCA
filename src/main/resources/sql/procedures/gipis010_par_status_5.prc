DROP PROCEDURE CPI.GIPIS010_PAR_STATUS_5;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Par_Status_5 (p_par_id	GIPI_PARLIST.par_id%TYPE)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Set par_status to 5 in GIPI_PARLIST
	*/
BEGIN
	UPDATE GIPI_PARLIST
	   SET par_status =  5
	 WHERE par_id =  p_par_id;
END;
/


