DROP PROCEDURE CPI.GIPIS031_VALIDATE_ENDTEXP_DATE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_VALIDATE_ENDTEXP_DATE (
    p_line_cd IN gipi_wpolbas.line_cd%TYPE,
    p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
    p_eff_date IN gipi_wpolbas.eff_date%TYPE,
    p_expiry_date IN gipi_wpolbas.expiry_date%TYPE,
    p_v_old_date_exp IN gipi_wpolbas.expiry_date%TYPE,
    p_comp_sw IN gipi_wpolbas.comp_sw%TYPE,    
    p_prorate_flag IN OUT gipi_wpolbas.prorate_flag%TYPE,    
    p_v_v_mpl_switch OUT VARCHAR2,    
    p_p_confirm_sw OUT VARCHAR2,
    p_prorate_days OUT NUMBER,    
    p_message OUT VARCHAR2,
    p_message_type OUT VARCHAR2,
    p_endt_expiry_date IN OUT gipi_wpolbas.endt_expiry_date%TYPE,
    p_v_v_add_time IN OUT NUMBER)
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================    
    **    01.13.2012    mark jm            if difference between endorsement expiry date and effectivity
    **                                date is not equal to a year then, if the DEFAULT_PRORATE_TAG = 'Y'
    **                                in giis_parameters then prorate tag is the default else if  
    **                                DEFAULT_PRORATE_TAG = 'N' then default is one-year or straight tag. (Original Description)    
    **                                Reference By : (GIPIS031 - Endt. Basic Information)
    */
    v_default_prorate_flag giis_parameters.param_value_v%TYPE;
    v_end_of_day VARCHAR2(1);
BEGIN
    FOR A IN (
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name = 'DEFAULT_PRORATE_TAG')
    LOOP 
        v_default_prorate_flag := A.param_value_v;
        EXIT;
    END LOOP;
    
    IF v_default_prorate_flag = 'Y' THEN
        IF TRUNC(p_endt_expiry_date) <> TRUNC(ADD_MONTHS(p_eff_date, 12)) THEN
            p_prorate_flag := '1';
        ELSE
            p_prorate_flag := '2';
        END IF;
    ELSIF v_default_prorate_flag = 'N' THEN
        IF (p_endt_expiry_date - p_eff_date) <> 365 then
            p_prorate_flag := '2';
        END IF;
    END IF;
    
    IF p_v_old_date_exp != p_endt_expiry_date THEN
        p_v_v_add_time := 0;
        get_addtl_time_gipis002(p_line_cd, p_subline_cd, p_v_v_add_time);
        v_end_of_day := giis_subline_pkg.get_subline_time_sw(p_line_cd, p_subline_cd);
        IF NVL(v_end_of_day,'N') = 'Y' THEN 
            p_endt_expiry_date := p_endt_expiry_date + 86399 /86400;
        ELSE
            p_endt_expiry_date := p_endt_expiry_date + p_v_v_add_time /86400;
        END IF;
    END IF;
    
    IF TRUNC(p_expiry_date) < TRUNC(p_endt_expiry_date) THEN
        p_v_v_mpl_switch := 'Y';
        p_message := 'The endorsement expiry date should not be later than the policy expiry date.';
        p_message_type := 'ERROR';
        p_endt_expiry_date := p_v_old_date_exp;
        RETURN;    
    END IF;
    
    IF TRUNC(p_endt_expiry_date) < TRUNC(p_eff_date) THEN
        p_v_v_mpl_switch := 'Y';
        p_message := 'Endorsement expiry date should not be earlier than the endorsement effectivity date.';
        p_message_type := 'ERROR';
        p_endt_expiry_date := p_v_old_date_exp;
        RETURN;
    END IF;
    
    IF p_v_old_date_exp != p_endt_expiry_date THEN
        p_p_confirm_sw := 'N';     
        IF p_prorate_flag = '1' AND p_endt_expiry_date IS NOT NULL AND p_eff_date IS NOT NULL THEN
            p_prorate_days := TRUNC(p_endt_expiry_date) - TRUNC(p_eff_date);
            IF p_comp_sw = 'Y' THEN
                p_prorate_days := p_prorate_days + 1    ;
            ELSIF p_comp_sw = 'M' THEN                    
                p_prorate_days := p_prorate_days - 1    ;
            ELSE
                p_prorate_days := p_prorate_days;
            END IF;
        END IF;  
    END IF;
END GIPIS031_VALIDATE_ENDTEXP_DATE;
/


