DROP PROCEDURE CPI.CHECK_PACK_ENDT_ITEM_AND_PERIL;

CREATE OR REPLACE PROCEDURE CPI.Check_Pack_Endt_Item_And_Peril (
	p_par_id		IN GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
	p_item			OUT NUMBER,
	p_peril			OUT NUMBER)
AS
	/*
	**  Created by		: Emman
	**  Date Created 	: 03.09.2011
	**  Reference By 	: (GIPIS031A - Pack Endt. Basic Information)
	**  Description 	: This procedure returns the no of item and peril of the given pack_par_id	
	*/
BEGIN
	p_item := 0;
	p_peril := 0;
	
	-- check if PAR already have existing items
	FOR ITEM IN (SELECT '1'
                   FROM gipi_witem a, gipi_parlist b 
                  WHERE a.par_id = b.par_id
                    AND b.pack_par_id = p_par_id)
	LOOP
		p_item := p_item + 1;
	END LOOP;
	
	-- check if PAR already have existing peril/s
	FOR ITEM IN (SELECT '1'
                   FROM gipi_witmperl a, gipi_parlist b  
                  WHERE a.par_id = b.par_id
                    AND b.pack_par_id = p_par_id)
	LOOP
		p_peril := p_peril + 1;
	END LOOP;
END Check_Pack_Endt_Item_And_Peril;
/


