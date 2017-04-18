DROP PROCEDURE CPI.VALIDATE_MC_PLATE_NO;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_MC_PLATE_NO(
    p_plate_no IN gipi_wvehicle.plate_no%TYPE,
    p_message OUT VARCHAR2,
    p_message_type OUT VARCHAR2)
AS    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    12.20.2011    mark jm            checks if plate_no exists in gicl_claims and on posted policies
    */
    v_tag gicl_claims.total_tag%TYPE;
BEGIN
    p_message := NULL;
    p_message_type := NULL;
    
    FOR a IN (
        SELECT a.total_tag tag
          FROM gicl_claims a
         WHERE a.plate_no = p_plate_no
           AND a.clm_stat_cd NOT IN ('CC', 'DN', 'WD')
           AND a.total_tag IS NOT NULL)
    LOOP
        v_tag := a.tag;
    END LOOP;
    
    IF v_tag = 'Y' THEN
        p_message := 'Cannot issue policy for plate no. ' || p_plate_no || '. Plate no. already tagged as total loss.';
        p_message_type := 'E';
        
        RETURN;
    END IF;

    FOR car IN (
        SELECT y.policy_id
          FROM gipi_polbasic y,
               gipi_vehicle x
         WHERE x.policy_id = y.policy_id
           AND y.pol_flag IN ('1', '2', '3')
           AND x.plate_no = p_plate_no)
    LOOP
        p_message := 'Plate no ' || p_plate_no|| ' is used by another existing policy.';
        p_message_type := 'I';
        EXIT;
    END LOOP;
    
END VALIDATE_MC_PLATE_NO;
/


