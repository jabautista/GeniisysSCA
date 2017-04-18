DROP FUNCTION CPI.CHECK_TAG;

CREATE OR REPLACE FUNCTION CPI.CHECK_TAG (p_par_id 	GIPI_WPACK_LINE_SUBLINE.par_id%TYPE)
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Determine the item_tag of a particular record
	*/
	v_count    	NUMBER;
	v_item_tag	GIPI_WPACK_LINE_SUBLINE.item_tag%TYPE;
BEGIN
	SELECT COUNT(*)
	  INTO v_count
	  FROM GIPI_WPACK_LINE_SUBLINE
	 WHERE par_id = p_par_id
	   AND item_tag LIKE 'N';
	
	IF v_count = 0 THEN
		v_item_tag := 'Y';
	ELSE
		v_item_tag := 'N';
	END IF;
	
	RETURN v_item_tag;
END;
/


