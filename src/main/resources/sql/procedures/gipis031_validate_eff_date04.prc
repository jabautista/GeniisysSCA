DROP PROCEDURE CPI.GIPIS031_VALIDATE_EFF_DATE04;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_VALIDATE_EFF_DATE04 (
	p_var_eff_date IN DATE,
	p_incept_date IN gipi_wpolbas.incept_date%TYPE,
	p_v_v_old_date_eff IN gipi_wpolbas.eff_date%TYPE,
	p_prorate_flag IN gipi_wpolbas.prorate_flag%TYPE,
	p_endt_exp_date IN gipi_wpolbas.endt_expiry_date%TYPE,
	p_comp_sw IN gipi_wpolbas.comp_sw%TYPE,	
	p_booking_mth OUT gipi_wpolbas.booking_mth%TYPE,
	p_booking_year OUT gipi_wpolbas.booking_year%TYPE,
	p_prorate_days OUT NUMBER,
	p_eff_date IN OUT gipi_wpolbas.eff_date%TYPE)
AS
	/*	Date        Author            Description
    **    ==========    ===============    ============================    
    **    01.10.2012    mark jm            Retrieve information based on the new specified effecivity date
    **                                Fires only when the entered effecivity date is changed and if
    **                                endt is a backward endt or if the change in effectivity will
    **                                make it a backward endorsement (Original Description)
    **                                Part 4. See GIPIS031_VALIDATE_EFF_DATE05 for next part
    **                                Reference By : (GIPIS031 - Endt. Basic Information)
    */
BEGIN
    -- If Endorsement effectivity date is the same as the endorsement date   
    -- of the latest endorsement, the time of the Endorsement effectivity    
    -- date is adjusted by adding one minute.
    IF p_var_eff_date IS NOT NULL THEN
        p_eff_date := p_var_eff_date + (1/1440);
    END IF;
    --  If Endorsement effectivity date is the same as Policy inception date  
    --  the time of the Endorsement effectivity date is adjusted              
    --  by adding one minute.                                                   
    IF p_eff_date = p_incept_date THEN
        p_eff_date := p_eff_date + (1/1440);
    END IF;
    
    p_booking_mth := NULL;
    p_booking_year := NULL;
    
    --for changes in eff_date and endt. computation is based on pro-rate then
    --update no. of days depending on the new eff_date
    IF NVL(p_v_v_old_date_eff, SYSDATE) != p_eff_date AND p_prorate_flag = '1' AND p_endt_exp_date IS NOT NULL 
        AND p_eff_date IS NOT NULL THEN
        p_prorate_days := TRUNC(p_endt_exp_date) - TRUNC(p_eff_date);
        IF p_comp_sw = 'Y' THEN
            p_prorate_days := p_prorate_days + 1;
        ELSIF p_comp_sw = 'M' THEN                    
            p_prorate_days := p_prorate_days - 1;
        END IF;
    END IF;
END GIPIS031_VALIDATE_EFF_DATE04;
/


