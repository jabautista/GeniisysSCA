DROP PROCEDURE CPI.GIPIS010_INSERT_PARHIST;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Insert_Parhist(
	p_par_id	IN GIPI_PARHIST.par_id%TYPE,
	p_user		IN GIPI_PARHIST.user_id%TYPE)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.26.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: This procedure inserts record on GIPI_PARHIST
	*/
BEGIN
	INSERT INTO GIPI_PARHIST (
		par_id,	user_id, parstat_date, entry_source, parstat_cd)
	VALUES (
		p_par_id, p_user, SYSDATE, NULL, '4');
END;
/


