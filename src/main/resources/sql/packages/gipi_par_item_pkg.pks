CREATE OR REPLACE PACKAGE CPI.Gipi_Par_Item_Pkg
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.10.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains insert / update / delete procedure of table GIPI_WITEM
	*/
	PROCEDURE set_gipi_par_item (p_item		GIPI_WITEM%ROWTYPE);
	
	PROCEDURE pre_set_gipi_par_item (p_par_id	GIPI_WITEM.par_id%TYPE);
	
	PROCEDURE del_gipi_par_item (
		p_par_id		GIPI_WITEM.par_id%TYPE,
		p_item_no	GIPI_WITEM.item_no%TYPE);
	
	PROCEDURE del_all_gipi_par_item (p_par_id		GIPI_WITEM.par_id%TYPE);
	
	PROCEDURE pre_del_gipi_par_item (
		p_par_id		GIPI_WITEM.par_id%TYPE,
		p_item_no	GIPI_WITEM.item_no%TYPE);
		
	PROCEDURE post_del_gipi_par_item (	
		p_par_id 	GIPI_WITEM.par_id%TYPE,
		p_line_cd	GIPI_PARLIST.line_cd%TYPE,
		p_iss_cd	GIPI_PARLIST.iss_cd%TYPE);
END Gipi_Par_Item_Pkg;
/


