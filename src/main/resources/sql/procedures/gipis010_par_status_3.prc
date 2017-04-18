DROP PROCEDURE CPI.GIPIS010_PAR_STATUS_3;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Par_Status_3 (
	p_par_id		IN GIPI_PARLIST.par_id%TYPE,
	p_pack_pol_flag	OUT GIPI_WPOLBAS.pack_pol_flag%TYPE,
	p_item_tag		OUT VARCHAR2)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Set par_status to 3 in GIPI_PARLIST
	*/
BEGIN
	p_pack_pol_flag := Check_Pack_Pol_Flag(p_par_id);
	p_item_tag := Check_Tag(p_par_id);
	
	UPDATE GIPI_PARLIST
	   SET par_status = 3
	 WHERE par_id = p_par_id;       
END Gipis010_Par_Status_3;
/


