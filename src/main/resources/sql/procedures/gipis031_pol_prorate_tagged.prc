DROP PROCEDURE CPI.GIPIS031_POL_PRORATE_TAGGED;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_POL_PRORATE_TAGGED (
	p_par_id IN gipi_wpolbas.par_id%TYPE,
	p_cancel_type IN VARCHAR2,
    p_comp_sw IN VARCHAR) --parameter added by Jerome Bautista 10.15.2015 SR 20567
AS
	/*	Date        Author			Description
    **	==========	===============	============================
    **	01.19.2012	mark jm			this procedure is called if pol_flag/prorate_flag
	**								was tagged in GIPIS031	
	**								Reference By : (GIPIS031 - Endt Basic Information)
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
      --  create_negated_records_flat01(b540,    b240.par_status, v_v_expiry_date); moved, this is only called when cancellation Flat is initiated - irwin 8.23.2012
    
    IF p_cancel_type = 'POL_FLAG' THEN
		create_negated_records_flat01(b540,    b240.par_status, v_v_expiry_date);
        -- update gipi_parlist based on changes made after performing some procedures
        UPDATE gipi_parlist
           SET ROW = b240
         WHERE par_id = p_par_id;
    
        b540.prorate_flag := 2;
        b540.comp_sw := NULL;
    ELSIF p_cancel_type = 'PRORATE' THEN
        --b540.prorate_flag := 1; removed by robert
        b540.comp_sw := p_comp_sw; --'N'; --modified by Jerome Bautista 10.15.2015 SR 20567
    END IF;
    
    b540.pol_flag := 4;
    
    -- update gipi_wpolbas based on changes made after performing some procedures
    UPDATE gipi_wpolbas
       SET ROW = b540
     WHERE par_id = b540.par_id;    
     
END GIPIS031_POL_PRORATE_TAGGED;
/


