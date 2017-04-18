DROP FUNCTION CPI.VALIDATE_COPY_ITEM_PERIL_INFO;

CREATE OR REPLACE FUNCTION CPI.Validate_Copy_Item_Peril_Info (
	p_par_id 		GIPI_WDEDUCTIBLES.par_id%TYPE,
	p_line_cd 		GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
	p_subline_cd	GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE)
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Checks if par_id has existing policy level deductible/s based on % of TSI
	*/
	v_result	VARCHAR2(4000);
	v_policy	BOOLEAN := FALSE;
	v_item		BOOLEAN := FALSE;
	v_peril		BOOLEAN := FALSE;
BEGIN
	FOR a IN (
		SELECT par_id, item_no, peril_cd
		  FROM GIPI_WDEDUCTIBLES,
			   GIIS_DEDUCTIBLE_DESC
		 WHERE deductible_cd = ded_deductible_cd
		   AND ded_line_cd = line_cd
		   AND ded_subline_cd = subline_cd
		   AND par_id = p_par_id
		   AND ded_line_cd = p_line_cd
		   AND ded_subline_cd = p_subline_cd
		   AND ded_type = 'T')
	LOOP
		IF a.item_no > 0 AND a.peril_cd > 0 THEN
			v_peril := TRUE;
		END IF;
		
		IF a.item_no > 0 AND a.peril_cd = 0 THEN
			v_item := TRUE;
		END IF;
		
		IF a.item_no = 0 AND a.item_no IS NULL THEN
			v_policy := TRUE;
		END IF;
	END LOOP;
	
	IF 	(v_peril AND v_item AND v_policy) OR 
		(NOT v_peril AND v_item AND v_policy) OR 
		(v_peril AND NOT v_item AND v_policy) OR
		(NOT v_peril AND NOT v_item AND v_policy) THEN
		v_result := 'The PAR has existing policy level deductible/s based on % of TSI. ' ||  
					'Copying an item and peril info will delete the existing deductible/s. Continue?';
	END IF;
	
	RETURN v_result;
END;
/


