DROP PROCEDURE CPI.INSERT_PACK_PARHIST;

CREATE OR REPLACE PROCEDURE CPI.INSERT_PACK_PARHIST (
	p_par_id	IN GIPI_PACK_PARHIST.pack_par_id%TYPE,
	p_user_id	IN GIPI_PACK_PARHIST.user_id%TYPE)
AS
	/*
	**  Created by		: Emman
	**  Date Created 	: 11.25.2010
	**  Reference By 	: (GIPIS031A - Package Endt Basic Information)
	**  Description 	: This procedure inserts record to GIPI_PACK_PARHIST
	**					: based on the given parameters
	*/
BEGIN
	INSERT INTO GIPI_PACK_PARHIST (
		pack_par_id, user_id, parstat_date, entry_source, parstat_cd)
	VALUES (
		p_par_id, p_user_id, SYSDATE, NULL, '3');
END INSERT_PACK_PARHIST;
/


