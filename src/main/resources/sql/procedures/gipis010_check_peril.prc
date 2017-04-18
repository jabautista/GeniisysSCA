DROP PROCEDURE CPI.GIPIS010_CHECK_PERIL;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Check_Peril (
	p_par_id 	IN GIPI_PARLIST.par_id%TYPE,
	p_v_vpar	OUT GIPI_PARLIST.par_status%TYPE)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Update GIPI_PARLIST and returns new par_status
	*/
	v_count    NUMBER;
BEGIN
	SELECT COUNT(*)
	  INTO v_count
	  FROM GIPI_WITEM
	 WHERE PAR_ID = p_par_id
	   AND NOT EXISTS (
				SELECT ITEM_NO
				  FROM GIPI_WITMPERL
				 WHERE PAR_ID = p_par_id
				   AND ITEM_NO = GIPI_WITEM.ITEM_NO);

	IF v_count = 0 THEN
		UPDATE GIPI_PARLIST
		   SET par_status = 5
		 WHERE par_id = p_par_id;    
	ELSE
		UPDATE GIPI_PARLIST
		   SET par_status = 4
		 WHERE par_id = p_par_id;     
	END IF;
	
	SELECT par_status
	  INTO p_v_vpar
	  FROM GIPI_PARLIST
	 WHERE par_id = p_par_id;
END Gipis010_Check_Peril;
/


