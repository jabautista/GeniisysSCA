DROP FUNCTION CPI.VALIDATE_MC_COC_SERIAL_NO;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_MC_COC_SERIAL_NO (
    p_par_id IN gipi_wvehicle.par_id%TYPE,
    p_item_no IN gipi_wvehicle.item_no%TYPE,
    p_coc_type IN gipi_wvehicle.coc_type%TYPE,
    p_coc_serial_no IN gipi_wvehicle.coc_serial_no%TYPE)
RETURN VARCHAR2
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    12.21.2011    mark jm            checks if coc_serial_no exists in other records and on posted policies
    **    07.26.2016    Mark S.            added parameter to check wether to include checking if policy is spoiled
    */
    v_par_id      gipi_wvehicle.par_id%TYPE;
    v_par_no      VARCHAR2(50);
    v_policy_no VARCHAR2(50);
    v_message     VARCHAR2(1000);
    v_stop         BOOLEAN := FALSE;
    v_reuse_spoiled VARCHAR2(50);
BEGIN
    SELECT NVL(param_value_v,'N')
     INTO v_reuse_spoiled
     FROM cpi.giis_parameters
    WHERE param_name = 'ALLOW_REUSE_COC_SPOILED_POLICIES'; 
    FOR C1 IN (
        SELECT coc_serial_no, par_id
          FROM gipi_wvehicle
         WHERE coc_type = p_coc_type
           AND coc_serial_no = p_coc_serial_no
           AND (par_id != p_par_id
            OR (par_id = p_par_id
           AND item_no != p_item_no)))
    LOOP
        FOR A IN (
            SELECT line_cd || '-' || iss_cd || '-' || 
                   LTRIM(TO_CHAR(par_yy, '09')) || '-' ||
                   LTRIM(TO_CHAR(par_seq_no, '099999')) || '-' ||
                   LTRIM(TO_CHAR(quote_seq_no, '09')) par_no, 
                   par_status                    
             FROM gipi_parlist
            WHERE par_id = C1.par_id)
        LOOP
            v_par_no := A.par_no;
            
            IF A.par_status NOT IN (98, 99) THEN
                v_message := 'Coc serial no. ' || p_coc_serial_no || ' already exists in PAR No. ' || v_par_no || '.';
                v_stop := TRUE;
                EXIT;
            END IF;
        END LOOP;
        
        IF v_stop THEN
            EXIT;
        END IF;
    END LOOP;
    
    FOR D IN (
        SELECT coc_serial_no, policy_id
          FROM gipi_vehicle
         WHERE coc_type = p_coc_type
           AND coc_serial_no = p_coc_serial_no)
    LOOP
        FOR B IN (
            SELECT line_cd || '-' || subline_cd || '-' || iss_cd || '-' ||
                   LTRIM(TO_CHAR(issue_yy, '09')) || '-' || 
                   LTRIM(TO_CHAR(pol_seq_no, '0999999')) || '-' ||  
                   LTRIM(TO_CHAR(renew_no, '09')) policy_no, 
                   pol_flag
              FROM gipi_polbasic
             WHERE policy_id = d.policy_id)
        LOOP
            v_policy_no := B.policy_no;
            --EDITED BY MarkS 7.26.2016 SR22702
            IF NVL(v_reuse_spoiled,'N') ='N' THEN
                IF B.pol_flag <> '5' THEN 
                    v_message := 'Coc serial no. ' || p_coc_serial_no || ' already exists in Policy No. ' || v_policy_no || '.';
                    v_stop := TRUE;
                    EXIT;
                END IF;
            ELSE
                v_message := 'Coc serial no. ' || p_coc_serial_no || ' already exists in Policy No. ' || v_policy_no || '.';
                v_stop := TRUE;
                EXIT;
            END IF;
            --SR22702
        END LOOP;
        
        IF v_stop THEN
            EXIT;
        END IF;
    END LOOP;
    
    RETURN v_message;
END VALIDATE_MC_COC_SERIAL_NO;
/

