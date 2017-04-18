DROP FUNCTION CPI.VALIDATE_CONFIRM_RENUMBER;

CREATE OR REPLACE FUNCTION CPI.Validate_Confirm_Renumber (p_par_id	GIPI_WITEM.par_id%TYPE)
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Checks if item_no are arranged consecutively
	*/
	v_count		NUMBER := 0;
	v_exist		VARCHAR2(1);
	v_exist2	VARCHAR2(1);
	v_result 	VARCHAR2(4000);
BEGIN
	FOR cnt IN (SELECT COUNT(*) item
				  FROM GIPI_WITEM
				 WHERE par_id = p_par_id)
	LOOP
		v_count := cnt.item;
	END LOOP;
	
	IF v_count > 0  THEN
		FOR A IN 1..v_count
		LOOP
			v_exist := 'N';
			FOR B IN (SELECT '1'
						FROM GIPI_WITEM
					   WHERE par_id = p_par_id
						 AND item_no = a)
			LOOP
				v_exist := 'Y';
			END LOOP;
			
			IF v_exist = 'N' THEN
				v_exist2 := 'Y';
				EXIT;
			END IF;
		END LOOP;
	ELSE
		v_result := 'Renumber will only work if there are existing items.';
	END IF;
	
	IF NVL(v_exist2, 'N') = 'N' THEN
		v_result := 'Renumber will only work if item are not arranged consecutively.';
	END IF;
	
	RETURN v_result;
END;
/


