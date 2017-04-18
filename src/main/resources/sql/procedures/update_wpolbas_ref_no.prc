DROP PROCEDURE CPI.UPDATE_WPOLBAS_REF_NO;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_WPOLBAS_REF_NO (p_pack_par_id IN NUMBER)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
	**  Description 	: Updates the bank_ref_no of gipi_wpolbas based on the given pack_par_id
	*/
	v_ref_no VARCHAR2(30);
BEGIN
	SELECT bank_ref_no
	  INTO v_ref_no
	  FROM gipi_pack_wpolbas
	 WHERE pack_par_id = p_pack_par_id;
	
	IF v_ref_no LIKE '%-%-%-%' THEN
        UPDATE gipi_wpolbas
           SET bank_ref_no = v_ref_no
         WHERE pack_par_id = p_pack_par_id
           AND bank_ref_no IS NULL;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
        NULL;
END UPDATE_WPOLBAS_REF_NO;
/


