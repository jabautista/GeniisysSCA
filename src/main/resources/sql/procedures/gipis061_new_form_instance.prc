DROP PROCEDURE CPI.GIPIS061_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS061_NEW_FORM_INSTANCE (
    p_par_id                    IN gipi_parlist.par_id%TYPE,
    p_v_pack_pol_flag            OUT gipi_wpolbas.pack_pol_flag%TYPE,
    p_v_eff_date                OUT VARCHAR2,
    p_v_endt_expiry_date        OUT VARCHAR2,
    p_v_prov_prem_tag            OUT gipi_wpolbas.prov_prem_tag%TYPE,
    p_v_prov_prem_pct            OUT gipi_wpolbas.prov_prem_pct%TYPE,
    p_v_short_rt_percent        OUT gipi_wpolbas.short_rt_percent%TYPE,
    p_v_prorate_flag            OUT gipi_wpolbas.prorate_flag%TYPE,
    p_comp_sw                    OUT gipi_wpolbas.comp_sw%TYPE,
    p_p_pol_flag_sw                OUT VARCHAR2,
    p_v_co_ins_sw                OUT gipi_wpolbas.co_insurance_sw%TYPE,
    p_disc_exist                OUT VARCHAR2,
    p_allow_update_curr_rate    OUT VARCHAR2)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created    : 09.29.2010
    **  Reference By    : (GIPIS061 - Item Information - Casualty)
    **  Description        : This procedures is called before the page is displayed
    **                    : Returning values to be used on the page
    */
BEGIN
    FOR A IN (
        SELECT pack_pol_flag, pol_flag, co_insurance_sw
          FROM gipi_wpolbas
         WHERE par_id = p_par_id)
    LOOP      
        p_v_pack_pol_flag  := a.pack_pol_flag;
        
        IF A.pol_flag = '4' THEN
            p_p_pol_flag_sw := 'Y';
        END IF;
        
        p_v_co_ins_sw := A.co_insurance_sw;
        EXIT;
    END LOOP;
    
    FOR A IN(
        SELECT eff_date,
               endt_expiry_date,
               prov_prem_tag,
               prov_prem_pct,
               short_rt_percent,
               prorate_flag,
               NVL(comp_sw,'N') comp_sw
          FROM gipi_wpolbas
         WHERE par_id = p_par_id)
    LOOP
        p_v_eff_date         := TO_CHAR(A.eff_date, 'MM-DD-RRRR HH24:MI:SS') ;
        p_v_endt_expiry_date := TO_CHAR(A.endt_expiry_date, 'MM-DD-RRRR HH24:MI:SS');
        p_v_prov_prem_tag    := A.prov_prem_tag;
        p_v_prov_prem_pct    := A.prov_prem_pct;
        p_v_short_rt_percent := A.short_rt_percent;
        p_v_prorate_flag     := A.prorate_flag;
        p_comp_sw            := A.comp_sw;
    END LOOP;
    
    FOR D1 IN(
        SELECT 1
          FROM gipi_wperil_discount
         WHERE par_id = p_par_id )
    LOOP
        p_disc_exist   := 'Y';
        EXIT;
    END LOOP;
    
    FOR a in (
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name = 'ALLOW_UPDATE_CURR_RATE')
    LOOP
        p_allow_update_curr_rate := a.param_value_v;
    END LOOP;
END GIPIS061_NEW_FORM_INSTANCE;
/


