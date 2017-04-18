DROP PROCEDURE CPI.CHECK_ENDT_ITEM_AND_PERIL;

CREATE OR REPLACE PROCEDURE CPI.Check_Endt_Item_And_Peril (
	p_par_id		IN GIPI_WPOLBAS.par_id%TYPE,
	p_item			OUT NUMBER,
	p_peril			OUT NUMBER)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 05.31.2010
	**  Reference By 	: (GIPIS031 - Endt. Basic Information)
	**  Description 	: This procedure returns the no of item and peril of the given par_id	
	*/
BEGIN
	p_item := 0;
	p_peril := 0;
	
	-- check if PAR already have existing items
	FOR ITEM IN (
		SELECT '1'
		  FROM GIPI_WITEM
		 WHERE par_id = p_par_id)
	LOOP
		p_item := p_item + 1;
	END LOOP;
	
	-- check if PAR already have existing peril/s
	FOR ITEM IN (
		SELECT '1'
		  FROM GIPI_WITMPERL
		 WHERE par_id = p_par_id)
	LOOP
		p_peril := p_peril + 1;
	END LOOP;
END Check_Endt_Item_And_Peril;
/


