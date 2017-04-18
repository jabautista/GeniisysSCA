DROP PROCEDURE CPI.GIPIS031_ENDT_COI_TAGGED;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_ENDT_COI_TAGGED (
    p_par_id IN gipi_wpolbas.par_id%TYPE,
    p_cancel_type IN VARCHAR2)
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    01.19.2012    mark jm            this procedure is called if endt/coi
    **                                was tagged in GIPIS031    
    **                                Reference By : (GIPIS031 - Endt Basic Information)
    */    
    b240 gipi_parlist%ROWTYPE;
    b540 gipi_wpolbas%ROWTYPE;
    v_v_expiry_date gipi_wpolbas.expiry_date%TYPE;
    v_message VARCHAR2(2000);
BEGIN
    FOR i IN (
        SELECT *
          FROM gipi_parlist
         WHERE par_id = p_par_id)
    LOOP
        b240 := i;
    END LOOP;
    
    FOR i IN (
        SELECT *
          FROM gipi_wpolbas
         WHERE par_id = p_par_id)
    LOOP
        b540 := i;
    END LOOP;
    
    delete_other_info(b540.par_id);
    delete_records(b540.par_id, b540.line_cd, b540.subline_cd, b540.iss_cd,
        b540.issue_yy, b540.pol_seq_no, b540.renew_no, b540.eff_date,
        b540.co_insurance_sw, b540.ann_tsi_amt, b540.ann_prem_amt, v_message);
    
    IF p_cancel_type = 'ENDT' THEN        
        create_negated_records_endt01(b540,    b240.par_status, v_v_expiry_date);        
    ELSIF p_cancel_type = 'COI' THEN
        create_negated_records_coi01(b540,    b240.par_status, v_v_expiry_date);
    END IF;
    
    -- update gipi_parlist based on changes made after performing some procedures
    UPDATE gipi_parlist
       SET ROW = b240
     WHERE par_id = p_par_id;
    
    b540.prorate_flag := 2;
    b540.pol_flag := 1;
    b540.comp_sw := 'N';
    
    -- update gipi_wpolbas based on changes made after performing some procedures
    UPDATE gipi_wpolbas
       SET ROW = b540
     WHERE par_id = b540.par_id;    
END GIPIS031_ENDT_COI_TAGGED;
/


