DROP PROCEDURE CPI.GIPIS006_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS006_NEW_FORM_INSTANCE (
	p_par_id IN gipi_wpolbas.par_id%TYPE,
	p_default_curr_cd OUT giis_currency.main_currency_cd%TYPE,
    p_default_region_cd OUT giis_issource.region_cd%TYPE,
	p_multi_carrier OUT giis_parameters.param_value_v%TYPE,
	p_ora2010_sw OUT VARCHAR2,
	p_default_print_tag OUT gipi_wcargo.print_tag%TYPE,
	p_markup_tag OUT VARCHAR2)
AS
	/*
    **  Created by		: Mark JM
    **  Date Created    : 03.03.2011
    **  Reference By    : (GIPIS006 - Item Information)
    **  Description     : This procedure is used for retrieving values when the form is called
    */
BEGIN
    /* default currency_cd */
    DECLARE
        v_found VARCHAR2(1) := 'N';
    BEGIN
        FOR i IN (
            SELECT main_currency_cd currency_cd          
              FROM giis_currency
             WHERE short_name LIKE giacp.v('DEFAULT_CURRENCY')  --currency_rt = 1) modified by Gzelle 10222014
               AND main_currency_cd = giacp.n('CURRENCY_CD'))
        LOOP
            p_default_curr_cd := i.currency_cd;
            v_found := 'Y';
            EXIT;
        END LOOP;
        
        /*IF v_found = 'N' THEN     commented out by Gzelle 10242014 - error message moved in GIPI_WITEM_PKG.check_get_def_curr_rt
            RAISE_APPLICATION_ERROR(-20001, 'Philippine currency not found in the maintenance table for currency. Please contact your database administrator.');
        END IF;*/
    END;
    
    /* default region_cd */
    FOR i IN (
        SELECT a.region_cd region_cd
          FROM giis_issource a
         WHERE a.iss_cd = (SELECT iss_cd FROM gipi_parlist WHERE par_id = p_par_id))
    LOOP
        p_default_region_cd := i.region_cd;
        EXIT;
    END LOOP;
    
    /* multiple carrier */
    FOR A1 IN (
        SELECT param_value_v multi
          FROM giis_parameters
         WHERE param_name = 'VESSEL_CD_MULTI')
    LOOP
        p_multi_carrier := A1.multi;
        EXIT;
    END LOOP;
    
    IF p_multi_carrier IS NULL THEN
       RAISE_APPLICATION_ERROR(-20001, 'Parameter for VESSEL_CD_MULTI not found in giis_parameters.');       
    END IF;
    
    p_ora2010_sw := Giisp.v('ORA2010_SW');
    
    /* default print_tag */
    FOR i IN (
        SELECT rv_low_value  
          FROM cg_ref_codes 
         WHERE rv_domain = 'GIPI_WCARGO.PRINT_TAG')
    LOOP
        p_default_print_tag := i.rv_low_value;
        EXIT;
    END LOOP;
    
    /* markup_tag */
    p_markup_tag := giisp.v('MARINE_TSI_AMT');
END GIPIS006_NEW_FORM_INSTANCE;
/


