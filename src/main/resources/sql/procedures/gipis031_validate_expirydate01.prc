DROP PROCEDURE CPI.GIPIS031_VALIDATE_EXPIRYDATE01;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_VALIDATE_EXPIRYDATE01 (
	p_line_cd IN gipi_wpolbas.line_cd%TYPE,
	p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,	
	p_incept_date IN gipi_wpolbas.incept_date%TYPE,
	p_prorate_flag IN gipi_wpolbas.prorate_flag%TYPE,
	p_eff_date IN gipi_wpolbas.eff_date%TYPE,
	p_comp_sw IN gipi_wpolbas.comp_sw%TYPE,	
	p_no_of_days OUT NUMBER,
	p_message OUT VARCHAR2,
	p_message_type OUT VARCHAR2,
	p_expiry_date IN OUT gipi_wpolbas.expiry_date%TYPE,
    p_endt_expiry_date IN OUT gipi_wpolbas.endt_expiry_date%TYPE)
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================    
    **    01.17.2012    mark jm            Validate expiry date
    **                                Add a message asking the user  to change 
    **                                the due dates of previous endt/policy.        
    **                                Reference By : (GIPIS031 - Endt. Basic Information)
    */
    v_add_time NUMBER;
BEGIN
    v_add_time := 0;
    get_addtl_time_gipis002(p_line_cd, p_subline_cd, v_add_time);  -- get the cut-off time for records subline     
    
    IF TO_CHAR(p_expiry_date, 'HH:MI:SS AM') = '12:00:00 AM' THEN
        p_expiry_date := p_expiry_date + NVL(v_add_time, 0) / 86400;
    END IF;
    
    IF p_expiry_date < p_incept_date THEN
        p_message := 'Expiry date should not be earlier than  Inception Date.';
        p_message_type := 'ERROR';
    ELSE
        p_endt_expiry_date := p_expiry_date;
    END IF;
    
    IF p_prorate_flag = '1' AND p_endt_expiry_date IS NOT NULL AND p_eff_date IS NOT NULL THEN
        p_no_of_days := TRUNC(p_endt_expiry_date) - TRUNC(p_eff_date);
        IF p_comp_sw = 'Y' THEN
            p_no_of_days := p_no_of_days + 1;
        ELSIF p_comp_sw = 'M' THEN
            p_no_of_days := p_no_of_days - 1;
        ELSE
            p_no_of_days := p_no_of_days;
        END IF;
    END IF;
END GIPIS031_VALIDATE_EXPIRYDATE01;
/


