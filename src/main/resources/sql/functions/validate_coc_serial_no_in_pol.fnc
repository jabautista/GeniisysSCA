DROP FUNCTION CPI.VALIDATE_COC_SERIAL_NO_IN_POL;

CREATE OR REPLACE FUNCTION CPI.Validate_Coc_Serial_No_In_Pol (p_coc_serial_no IN GIPI_VEHICLE.coc_serial_no%TYPE)
RETURN VARCHAR2
IS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.09.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Checks for coc_serial_no in Policy
    */
    v_result     VARCHAR2(4000);
BEGIN
    FOR chk_rec IN (
        SELECT coc_serial_no, policy_id
          FROM GIPI_VEHICLE
         WHERE coc_serial_no = p_coc_serial_no)
    LOOP     
        FOR a IN (
            SELECT line_cd || '-' || subline_cd || '-' || iss_cd || '-' ||
                   LTRIM(TO_CHAR(issue_yy, '09')) || '-' || 
                   LTRIM(TO_CHAR(pol_seq_no, '0999999')) || '-' ||  
                   LTRIM(TO_CHAR(renew_no, '09')) POLICY_NO, pol_flag
              FROM GIPI_POLBASIC
             WHERE policy_id = chk_rec.policy_id)
        LOOP            
            IF a.pol_flag <> '5' THEN
                v_result := 'COC Serial No. ' || p_coc_serial_no || ' already exists in Policy No. ' || a.POLICY_NO || '.';                
                EXIT;
            END IF;
        END LOOP;
    END LOOP;
    RETURN v_result;
END Validate_Coc_Serial_No_In_Pol;
/


