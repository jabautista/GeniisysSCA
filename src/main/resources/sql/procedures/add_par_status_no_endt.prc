DROP PROCEDURE CPI.ADD_PAR_STATUS_NO_ENDT;

CREATE OR REPLACE PROCEDURE CPI.ADD_PAR_STATUS_NO_ENDT (
	p_par_id		IN gipi_parlist.par_id%TYPE,
	p_line_cd		IN gipi_parlist.line_cd%TYPE,
	p_iss_cd		IN gipi_parlist.iss_cd%TYPE,	
	p_negate_item	IN VARCHAR2,
	p_prorate_flag	IN gipi_wpolbas.prorate_flag%TYPE,
	p_comp_sw		IN VARCHAR2,
	p_endt_exp_date	IN gipi_wpolbas.endt_expiry_date%TYPE,
	p_eff_date		IN gipi_wpolbas.eff_date%TYPE,
	p_exp_date		IN gipi_wpolbas.expiry_date%TYPE,
    p_short_rt_pct    IN gipi_wpolbas.short_rt_percent%TYPE,
    p_v_endt_tax_sw    OUT gipi_wendttext.endt_tax%TYPE)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 10.07.2010
    **  Reference By     : (GIPI061 - Endt Item Information - Casualty)
    **  Description     : Update the par status of the PAR in process depending on the changes
    */
    v_dist_no        giuw_pol_dist.dist_no%TYPE;
    v_exist            VARCHAR2(1) := 'N';
    v_par_status    gipi_parlist.par_status%TYPE;
BEGIN
    FOR a IN (
        SELECT dist_no
          FROM giuw_pol_dist
         WHERE par_id = p_par_id)
    LOOP
        CHANGES_IN_PAR_STATUS_ENDT(p_par_id, a.dist_no, p_line_cd, p_iss_cd, p_negate_item,
            p_prorate_flag, p_comp_sw, p_endt_exp_date, p_eff_date, p_exp_date, p_short_rt_pct, p_v_endt_tax_sw);
        v_exist := 'Y';
    END LOOP;
    
    IF v_exist = 'N' THEN
        CHANGES_IN_PAR_STATUS_ENDT(p_par_id, v_dist_no, p_line_cd, p_iss_cd, p_negate_item,
            p_prorate_flag, p_comp_sw, p_endt_exp_date, p_eff_date, p_exp_date, p_short_rt_pct, p_v_endt_tax_sw);
    END IF;
    
    FOR i IN (
        SELECT par_status
          FROM gipi_parlist
         WHERE par_id = p_par_id)
    LOOP
        v_par_status := i.par_status;
        EXIT;
    END LOOP;
    
    IF v_par_status = 3 OR v_par_status IS NULL THEN
        NULL;
    ELSIF v_par_status > 3 THEN
        NULL;
    ELSIF v_par_status < 3 THEN
        RAISE_APPLICATION_ERROR(20000, 'You are not granted access to this form. The changes that you have made '||
               'will not be committed to the database.');
    END IF;
END ADD_PAR_STATUS_NO_ENDT;
/


