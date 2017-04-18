DROP PROCEDURE CPI.DELETE_DISTRIBUTION_PACKAGE;

CREATE OR REPLACE PROCEDURE CPI.DELETE_DISTRIBUTION_PACKAGE (p_pack_par_id IN NUMBER)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
	**  Description 	: Create invoice and delete distribution based on certain conditions
	*/
	v_par_status gipi_parlist.par_status%TYPE;
BEGIN
	FOR A IN (
		SELECT dist_no, a.par_id
		  FROM giuw_pol_dist a, gipi_parlist b
		 WHERE a.par_id = b.par_id  
		   AND pack_par_id  = p_pack_par_id)
	LOOP
		SELECT par_status
		  INTO v_par_status
		  FROM gipi_pack_parlist
         WHERE pack_par_id = p_pack_par_id;
        
        create_invoice_item_package(p_pack_par_id);
        create_distribution_item_pkg(a.par_id, a.dist_no);
        
        IF v_par_status = 6 THEN
            UPDATE gipi_parlist
               SET par_status = 5
              WHERE pack_par_id = p_pack_par_id;
        END IF;
        EXIT;
    END LOOP;    
END DELETE_DISTRIBUTION_PACKAGE;
/


