DROP PROCEDURE CPI.INSERT_PARHIST;

CREATE OR REPLACE PROCEDURE CPI.INSERT_PARHIST (
	p_par_id	IN GIPI_PARHIST.par_id%TYPE,
	p_user_id	IN GIPI_PARHIST.user_id%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.29.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure inserts record to GIPI_PARHIST
	**					: based on the given parameters
	*/
BEGIN
	INSERT INTO GIPI_PARHIST (
		par_id, user_id, parstat_date, entry_source, parstat_cd)
	VALUES (
		p_par_id, p_user_id, SYSDATE, NULL, '3');
END INSERT_PARHIST;
/


