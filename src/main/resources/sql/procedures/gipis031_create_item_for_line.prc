DROP PROCEDURE CPI.GIPIS031_CREATE_ITEM_FOR_LINE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_CREATE_ITEM_FOR_LINE (
	p_par_id	IN GIPI_WITEM.par_id%TYPE,
	p_item_no	IN GIPI_WITEM.item_no%TYPE,
	p_line_cd	IN GIPI_POLBASIC.line_cd%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.03.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure is used for inserting records based on the line_cd
	*/
	v_menu_line	GIIS_LINE.menu_line_cd%TYPE;
BEGIN
	BEGIN
		SELECT NVL(menu_line_cd, line_cd) menu_line
		  INTO v_menu_line
		  FROM GIIS_LINE
		 WHERE line_cd = p_line_cd;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_menu_line := NULL;
	END;
	
	IF p_line_cd = 'FI' OR v_menu_line = 'FI' THEN
		GIPIS031_CREATE_FIRE_ITEM(p_par_id, p_item_no);
	ELSIF p_line_cd = 'MC' OR v_menu_line = 'MC' THEN
		GIPIS031_CREATE_VEHICLE_ITEM(p_par_id, p_item_no);
	ELSIF p_line_cd = 'PA' OR v_menu_line = 'AC' THEN
		GIPIS031_CREATE_ACCIDENT_ITEM(p_par_id, p_item_no);
	ELSIF p_line_cd = 'AV' OR v_menu_line = 'AV' THEN
		GIPIS031_CREATE_AVIATION_ITEM(p_par_id, p_item_no);
	ELSIF p_line_cd = 'MN' OR v_menu_line = 'MN' THEN
		GIPIS031_CREATE_CARGO_ITEM(p_par_id, p_item_no);
	ELSIF p_line_cd = 'CA' OR v_menu_line = 'OC' OR v_menu_line = 'CA' THEN
		GIPIS031_CREATE_CASUALTY_ITEM(p_par_id, p_item_no);
	ELSIF p_line_cd = 'EN' OR v_menu_line = 'EN' THEN
		GIPIS031_CREATE_ENGR_ITEM(p_par_id, p_item_no);
	ELSIF p_line_cd = 'MH' OR v_menu_line = 'MH' THEN
		GIPIS031_CREATE_MARINE_ITEM(p_par_id, p_item_no);
	END IF;
END GIPIS031_CREATE_ITEM_FOR_LINE;
/


