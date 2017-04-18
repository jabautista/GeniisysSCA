DROP FUNCTION CPI.VALIDATE_ASSIGN_DEDUCTIBLES;

CREATE OR REPLACE FUNCTION CPI.Validate_Assign_Deductibles (
	p_par_id	GIPI_WDEDUCTIBLES.par_id%TYPE,
	p_item_no	GIPI_WDEDUCTIBLES.item_no%TYPE)
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Checks if assigning deductibles to item is ok
	*/
	exists_ded		VARCHAR2(1) := 'N';
	exists_ded2		VARCHAR2(1) := 'N';
	v_result		VARCHAR2(4000);
BEGIN
	FOR A1 IN (
		SELECT '1'
		  FROM GIPI_WDEDUCTIBLES
		 WHERE par_id   = p_par_id
		   AND item_no  = p_item_no
		  AND peril_cd = 0)
	LOOP
		exists_ded := 'Y';
		EXIT;
	END LOOP;
	
	FOR ITEM IN (
		SELECT b480.item_no
		  FROM GIPI_WITEM b480
		 WHERE b480.par_id = p_par_id
		   AND NOT EXISTS (SELECT '1'
							 FROM GIPI_WDEDUCTIBLES b350
							WHERE b350.par_id   = b480.par_id
							  AND b350.item_no  = b480.item_no
							  AND b350.peril_cd = 0))
	LOOP                                
		exists_ded2 := 'Y';
		EXIT;
	END LOOP;  
	   
	IF exists_ded = 'Y'  AND exists_ded2 = 'Y' THEN
		v_result := 'Assign Deductibles, will automatically copy the current item deductibles ' ||
					'to other items without deductibles yet... This will automatically be saved/store in the tables. Do you want to continue?';
	ELSIF exists_ded = 'N' THEN
		v_result := 'Item '|| TO_CHAR(p_item_no, '099')||' has no existing deductible(s). ' ||
					'You cannot assign a null deductible(s).';
	ELSIF exists_ded2 = 'N' THEN
		v_result := 'All existing items already have deductible(s).';
	END IF;
	
	RETURN v_result;    
END;
/


