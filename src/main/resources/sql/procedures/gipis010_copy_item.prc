DROP PROCEDURE CPI.GIPIS010_COPY_ITEM;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Copy_Item(
	p_par_id		GIPI_WITEM.par_id%TYPE,
	p_item_no		GIPI_WITEM.item_no%TYPE,
	p_new_item_no	GIPI_WITEM.item_no%TYPE)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.08.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Creates new record in GIPI_WITEM by copying the record specified
	**					  by the parameters (par_id, item_no)
	*/
BEGIN
	INSERT INTO GIPI_WITEM (
		par_id,				item_no, 		item_title, 	item_grp,
		item_desc, 			item_desc2,		currency_cd, 	currency_rt, 	
		group_cd,			from_date,		TO_DATE, 		pack_line_cd, 	
		pack_subline_cd,	coverage_cd, 	region_cd,		rec_flag)
	(SELECT p_par_id, 			p_new_item_no, 	item_title, 	item_grp, 
			item_desc, 			item_desc2, 	currency_cd, 	currency_rt, 
			group_cd, 			from_date, 		TO_DATE, 		pack_line_cd, 
			pack_subline_cd, 	coverage_cd, 	region_cd,		rec_flag
	   FROM GIPI_WITEM
	  WHERE par_id = p_par_id
	    AND item_no = p_item_no);
	COMMIT;	
END;
/


