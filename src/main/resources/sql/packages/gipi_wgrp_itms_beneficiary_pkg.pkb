CREATE OR REPLACE PACKAGE BODY CPI.GIPI_WGRP_ITMS_BENEFICIARY_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.01.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure deletes record based on the given par_id
	*/
	Procedure DEL_GIPI_WGRP_ITMS_BENEFICIARY (p_par_id IN GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM GIPI_WGRP_ITEMS_BENEFICIARY
		 WHERE par_id = p_par_id;
	END DEL_GIPI_WGRP_ITMS_BENEFICIARY;
END GIPI_WGRP_ITMS_BENEFICIARY_PKG;
/


