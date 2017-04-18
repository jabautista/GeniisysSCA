DROP PROCEDURE CPI.VALIDATE_PAR_STATUS_ENDT;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_PAR_STATUS_ENDT (
	p_par_id 		IN gipi_parlist.par_id%TYPE,
	p_endt_tax_sw	IN gipi_wendttext.endt_tax%TYPE)
AS
	/*
    **  Created by		: Mark JM
    **  Date Created	: 10.07.2010
    **  Reference By	: (GIPIS061 - Item Information - Casualty)
    **  Description     : Update par_status	
    */
	CURSOR A IS
		SELECT par_status
		  FROM gipi_parlist
		 WHERE par_id = p_par_id;
	
	v_par_status 	gipi_parlist.par_status%TYPE;
	v_exist			VARCHAR2(1) := 'N';
	v_exist1		VARCHAR2(1) := 'N';
	v_ctr			NUMBER := 0;
BEGIN
	FOR A1 IN A
	LOOP
		v_par_status := a1.par_status;
	END LOOP;
	
	FOR B IN (
		SELECT 1
		  FROM gipi_winvoice
		 WHERE par_id = p_par_id)
	LOOP
		v_exist := 'Y';
	END LOOP;
	
	FOR C IN (
		SELECT 1
		  FROM gipi_winv_tax
		 WHERE par_id = p_par_id)
	LOOP
		v_exist1 := 'Y';
	END LOOP;
	
	IF v_par_status = 4 THEN		
		SELECT COUNT(*)
		  INTO v_ctr
		  FROM gipi_witem A
		 WHERE par_id = p_par_id
		   AND rec_flag = 'A'
		   AND NOT EXISTS (
				SELECT '1'
				  FROM gipi_witmperl
				 WHERE par_id = p_par_id
				   AND item_no = A.item_no);
		
		IF v_ctr < 1 THEN
            IF NVL(p_endt_tax_sw, 'N') = 'Y' THEN
                IF v_exist1 = 'N' THEN
                    Gipi_Parlist_Pkg.update_par_status(p_par_id, 5);
                ELSE
                    Gipi_Parlist_Pkg.update_par_status(p_par_id, 6);
                END IF;
            END IF;
        END IF;        
    END IF;
END VALIDATE_PAR_STATUS_ENDT;
/


