DROP FUNCTION CPI.VALIDATE_COPY_ITEM;

CREATE OR REPLACE FUNCTION CPI.Validate_Copy_Item (
	p_par_id		GIPI_WDEDUCTIBLES.par_id%TYPE,
	p_line_cd		GIIS_DEDUCTIBLE_DESC.line_cd%TYPE,
	p_subline_cd	GIIS_DEDUCTIBLE_DESC.subline_cd%TYPE)
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.01.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Checks if PAR has existing item level deductible
	*/
	v_policy	BOOLEAN := FALSE;
	v_item		BOOLEAN := FALSE;
	v_result 	VARCHAR2(4000);
BEGIN
	FOR a IN (SELECT par_id, item_no, peril_cd
				FROM GIPI_WDEDUCTIBLES, GIIS_DEDUCTIBLE_DESC
			   WHERE deductible_cd = ded_deductible_cd
				 AND ded_line_cd = line_cd
				 AND ded_subline_cd = subline_cd
				 AND par_id = p_par_id
				 AND ded_line_cd = p_line_cd
				 AND ded_subline_cd = p_subline_cd
				 AND ded_type = 'T'
			ORDER BY 2 DESC, 3 DESC)
	LOOP
		IF a.item_no > 0 AND a.peril_cd = 0 THEN
			v_item	:= TRUE;
		END IF;
		
		IF a.item_no = 0 OR a.item_no IS NULL THEN
			v_policy := TRUE;
		END IF;
	END LOOP;
	
	IF(v_item AND v_policy) OR (v_item AND NOT v_policy) THEN
		v_result := 'The PAR has existing item level deductible/s based on % of TSI.  Copying the item info will not copy the existing deductible/s because there is no TSI yet for the item. Continue?';
	END IF;
	
	RETURN v_result;
END;
/


