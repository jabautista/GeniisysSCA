DROP FUNCTION CPI.VALIDATE_COC_SERIAL_NO_IN_PAR;

CREATE OR REPLACE FUNCTION CPI.Validate_Coc_Serial_No_In_Par (	
	p_par_id			IN GIPI_WVEHICLE.par_id%TYPE,
	p_item_no			IN GIPI_WVEHICLE.item_no%TYPE,
	p_coc_serial_no		IN GIPI_WVEHICLE.coc_serial_no%TYPE,
	p_coc_type			IN GIPI_WVEHICLE.coc_type%TYPE)
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.09.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Checks for coc_serial_no in Par
    */
    v_result    VARCHAR2(4000);
BEGIN
    FOR chk_rec2 IN (
        SELECT coc_serial_no, par_id
          FROM GIPI_WVEHICLE
         WHERE coc_type = p_coc_type
           AND coc_serial_no = p_coc_serial_no
           AND (par_id != p_par_id OR (par_id = p_par_id 
               AND item_no != p_item_no)))
    LOOP
        FOR b IN (
            SELECT line_cd || '-' || iss_cd || '-' || 
                   LTRIM(TO_CHAR(par_yy, '09')) || '-' ||
                   LTRIM(TO_CHAR(par_seq_no, '099999')) || '-' ||
                   LTRIM(TO_CHAR(quote_seq_no, '09')) PAR_NO, par_status
              FROM GIPI_PARLIST
             WHERE par_id = chk_rec2.par_id)
        LOOP            
            IF b.par_status NOT IN (98,99) THEN
                v_result := 'COC Serial No. ' || p_coc_serial_no || ' already exists in PAR No. ' || b.par_no || '.';                
                EXIT;
            END IF;
        END LOOP;
    END LOOP;    
    RETURN v_result;
END Validate_Coc_Serial_No_In_Par;
/


