DROP PROCEDURE CPI.GIPIS065_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS065_NEW_FORM_INSTANCE (
	p_par_id IN gipi_witem.par_id%TYPE,
	p_p_dflt_coverage OUT NUMBER,
	p_v_subline_ga OUT VARCHAR2,
	p_v_subline_ha OUT VARCHAR2,
	p_v_subline_tr OUT VARCHAR2,
	p_v_endt_tax_sw OUT VARCHAR2,
	p_default_curr_cd OUT giis_currency.main_currency_cd%TYPE
)
AS	
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 05.05.2011
	**  Reference By 	: (GIPIS065 - Endt Item Information - Accident)
	**  Description 	: This procedure is used for retrieving values when the form is called
	*/
BEGIN	
	/* p_v_subline_ga, p_v_subline_ha, p_v_subline_tr*/
    DECLARE
        v_exist VARCHAR2(1) := 'N';
    BEGIN
        FOR A1 IN (
            SELECT A.param_value_v  a_param_value_v,
                   b.param_value_v  b_param_value_v,
                   c.param_value_v  c_param_value_v
              FROM giis_parameters A,
                   giis_parameters b,
                   giis_parameters c
             WHERE A.param_name LIKE 'GROUP ACCIDENT'
               AND b.param_name LIKE 'INDIVIDUAL PERSONAL ACCIDENT'
               AND c.param_name LIKE 'GENERAL TRAVEL')
        LOOP
            p_v_subline_ga  := a1.a_param_value_v;
            p_v_subline_ha  := a1.b_param_value_v;
            p_v_subline_tr  := a1.c_param_value_v;
            v_exist := 'Y'; 
            EXIT;
        END LOOP;
        
        IF v_exist = 'N' THEN
            RAISE_APPLICATION_ERROR(-20001, 'No parameter found for Personal Accident subline. Please contact your DBA.');
        END IF;
    END;
    
    /* p_v_endt_tax */
    FOR A IN (
        SELECT endt_tax
          FROM gipi_wendttext
         WHERE par_id = p_par_id)
    LOOP
        p_v_endt_tax_sw := A.endt_tax;
        EXIT;
    END LOOP; 
    
    /* p_p_dflt_coverage */
    BEGIN
        SELECT param_value_n
          INTO p_p_dflt_coverage
          FROM GIIS_PARAMETERS
         WHERE param_name = 'DEFAULT_COVERAGE_CD';    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error in getting value for parameter DEFAULT_COVERAGE_CD from giis_parameters, no data found.');
            
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error in getting value for parameter DEFAULT_COVERAGE_CD from giis_parameters, too many entries.');            
    END;
    
    /* default currency_cd */
    DECLARE
        v_found VARCHAR2(1) := 'N';
    BEGIN
        FOR i IN (
            SELECT main_currency_cd currency_cd          
              FROM giis_currency
             WHERE short_name LIKE giacp.v('DEFAULT_CURRENCY')  --currency_rt = 1) modified by Robert 11.11.14
               AND main_currency_cd = giacp.n('CURRENCY_CD'))
        LOOP
            p_default_curr_cd := i.currency_cd;
            v_found := 'Y';
            EXIT;
        END LOOP;
        
        IF v_found = 'N' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Philippine currency not found in the maintenance table for currency. Please contact your database administrator.');
        END IF;    
    END;
END GIPIS065_NEW_FORM_INSTANCE;
/


