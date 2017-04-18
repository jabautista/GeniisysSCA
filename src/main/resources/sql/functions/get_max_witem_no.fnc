DROP FUNCTION CPI.GET_MAX_WITEM_NO;

CREATE OR REPLACE FUNCTION CPI.Get_Max_Witem_No (p_par_id	GIPI_WITEM.item_no%TYPE)
RETURN NUMBER
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.01.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Get the max item_no in GIPI_WITEM
	*/
	v_item_no	GIPI_WITEM.item_no%TYPE;
BEGIN
	SELECT NVL(MAX(ITEM_NO),0)
	  INTO v_item_no
	  FROM GIPI_WITEM
	 WHERE par_id = p_par_id;
	 
	RETURN v_item_no;
END;
/


