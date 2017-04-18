CREATE OR REPLACE PACKAGE BODY CPI.GIPI_WLIM_LIAB_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.01.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure deletes record based on the given par_id
	*/
	Procedure DEL_GIPI_WLIM_LIAB (p_par_id IN GIPI_WLIM_LIAB.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_WLIM_LIAB
		 WHERE par_id = p_par_id;
	END DEL_GIPI_WLIM_LIAB;
END GIPI_WLIM_LIAB_PKG;
/


