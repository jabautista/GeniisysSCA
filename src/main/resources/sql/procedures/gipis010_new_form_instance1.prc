DROP PROCEDURE CPI.GIPIS010_NEW_FORM_INSTANCE1;

CREATE OR REPLACE PROCEDURE CPI.GIPIS010_NEW_FORM_INSTANCE1 (
	p_par_id				IN gipi_wpolbas.par_id%TYPE,
	p_v_subline_motorcycle 	OUT giis_parameters.param_value_v%TYPE,
	p_v_subline_commercial 	OUT giis_parameters.param_value_v%TYPE,
	p_v_subline_private		OUT giis_parameters.param_value_v%TYPE,
	p_v_subline_lto			OUT giis_parameters.param_value_v%TYPE,
	p_v_coc_lto				OUT giis_parameters.param_value_v%TYPE,
	p_v_coc_nlto			OUT giis_parameters.param_value_v%TYPE,
	p_v_mc_company_sw		OUT giis_parameters.param_value_v%TYPE,
	p_p_dflt_coverage		OUT giis_parameters.param_value_n%TYPE,
	p_v_generate_coc		OUT giis_parameters.param_value_v%TYPE,
	p_default_curr_cd		OUT giis_currency.main_currency_cd%TYPE,
	p_default_region_cd		OUT giis_issource.region_cd%TYPE,
	p_default_towing        OUT gipi_wvehicle.towing%TYPE,
    p_default_plate_no        OUT gipi_wvehicle.plate_no%TYPE,
    p_plan_sw                OUT gipi_wpolbas.plan_sw%TYPE,    
    p_user_access            OUT VARCHAR2,
    p_ora2010_sw            OUT VARCHAR2)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 12.02.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : This procedure is used for retrieving values when the form is called
    */
    v_counter NUMBER := 0;
BEGIN
    FOR motorcycle IN (
        SELECT param_value_v cd
          FROM giis_parameters
         WHERE param_name = 'MOTORCYCLE')
    LOOP
        p_v_subline_motorcycle := motorcycle.cd;
        v_counter := NVL(v_counter, 0) + 1;
    END LOOP;
    
    IF NVL(v_counter, 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error in getting values from GIIS_PARAMETERS for parameter name MOTORCYCLE');
    ELSIF NVL(v_counter, 0) > 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Too many rows fetch from GIIS_PARAMETERS for parameter name MOTORCYCLE');
    END IF;
    
    v_counter := 0;
    
    FOR commercial IN (
        SELECT param_value_v cd
          FROM giis_parameters
         WHERE param_name = 'COMMERCIAL VEHICLE')
    LOOP
        p_v_subline_commercial := commercial.cd;
        v_counter := NVL(v_counter, 0) + 1;
    END LOOP;
    
    IF NVL(v_counter, 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error in getting values from GIIS_PARAMETERS for parameter name COMMERCIAL VEHICLE');
    ELSIF NVL(v_counter, 0) > 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Too many rows fetch from GIIS_PARAMETERS for parameter name COMMERCIAL VEHICLE');
    END IF;
    
    v_counter := 0;
    
    FOR private_car IN (
        SELECT param_value_v cd
          FROM giis_parameters
         WHERE param_name = 'PRIVATE CAR')         
    LOOP
        p_v_subline_private := private_car.cd;
        v_counter := NVL(v_counter, 0) + 1;
    END LOOP;
    
    IF NVL(v_counter, 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error in getting values from GIIS_PARAMETERS for parameter name PRIVATE CAR');
    ELSIF NVL(v_counter, 0) > 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Too many rows fetch from GIIS_PARAMETERS for parameter name PRIVATE CAR');
    END IF;
    
    v_counter := 0;
    
    FOR lto IN (
        SELECT param_value_v cd
          FROM giis_parameters
         WHERE param_name = 'LAND TRANS. OFFICE')
    LOOP
        p_v_subline_lto := lto.cd;
        v_counter := NVL(v_counter, 0) + 1;
    END LOOP;
    
    IF NVL(v_counter, 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error in getting values from GIIS_PARAMETERS for parameter name LAND TRANS. OFFICE');
    ELSIF NVL(v_counter, 0) > 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Too many rows fetch from GIIS_PARAMETERS for parameter name LAND TRANS. OFFICE');
    END IF;
    
    v_counter := 0;
    
    FOR lto_type IN (
        SELECT param_value_v cd
          FROM giis_parameters
         WHERE param_name = 'COC_TYPE_LTO')
    LOOP
        p_v_coc_lto := lto_type.cd;
        v_counter := NVL(v_counter, 0) + 1;
    END LOOP;
    
    IF NVL(v_counter, 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error in getting values from GIIS_PARAMETERS for parameter name COC_TYPE_LTO');
    ELSIF NVL(v_counter, 0) > 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Too many rows fetch from GIIS_PARAMETERS for parameter name COC_TYPE_LTO');
    END IF;
    
    v_counter := 0;
    
    FOR nlto_type IN (
        SELECT param_value_v cd
          FROM giis_parameters
         WHERE param_name = 'COC_TYPE_NLTO')
    LOOP
        p_v_coc_nlto := nlto_type.cd;
        v_counter := NVL(v_counter, 0) + 1;
    END LOOP;
    
    IF NVL(v_counter, 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error in getting values from GIIS_PARAMETERS for parameter name COC_TYPE_NLTO');
    ELSIF NVL(v_counter, 0) > 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Too many rows fetch from GIIS_PARAMETERS for parameter name COC_TYPE_NLTO');
    END IF;
    
    v_counter := 0;
    
    BEGIN
        SELECT param_value_v
          INTO p_v_mc_company_sw
          FROM giis_parameters
         WHERE param_name = 'REQUIRE_MC_COMPANY';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error in getting value for parameter REQUIRE_MC_COMPANY from giis_parameters, no data found');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error in getting value for parameter REQUIRE_MC_COMPANY from giis_parameters, too many entries');
    END;
    
    BEGIN
        SELECT param_value_n
          INTO p_p_dflt_coverage
          FROM giis_parameters
         WHERE param_name = 'DEFAULT_COVERAGE_CD';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error in getting value for parameter DEFAULT_COVERAGE_CD from giis_parameters, no data found');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error in getting value for parameter DEFAULT_COVERAGE_CD from giis_parameters, too many entries');
    END;
    
    FOR a IN (
        SELECT param_value_v cd
          FROM giis_parameters
         WHERE param_name = 'GENERATE_COC_SERIAL')
    LOOP
        p_v_generate_coc := a.cd;
    END LOOP;
    
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
    
    /* p_default_towing */
    DECLARE
        CURSOR B  IS   
            SELECT  param_name, param_value_n
              FROM  GIIS_PARAMETERS
             WHERE  param_name LIKE '%TOW%';
        
        CURSOR F  IS   
            SELECT param_name, param_value_v
              FROM giis_parameters
             WHERE param_name LIKE 'PLATE NUMBER%';
        
        v_subline_cd        gipi_wpolbas.subline_cd%TYPE;
        v_pack_line_cd        gipi_witem.pack_line_cd%TYPE;
        v_pack_subline_cd    gipi_witem.pack_subline_cd%TYPE;
    BEGIN
        FOR i IN (
            SELECT subline_cd, NULL pack_line_cd, NULL pack_subline_cd
              FROM gipi_wpolbas a
             WHERE a.par_id = p_par_id)
        LOOP
            v_subline_cd        := i.subline_cd;
            v_pack_line_cd        := i.pack_line_cd;
            v_pack_subline_cd    := i.pack_subline_cd;
            EXIT;
        END LOOP;
        
        FOR i IN B
        LOOP
            IF i.param_name = 'TOWING LIMIT - CV' AND v_subline_cd = p_v_subline_commercial THEN
                p_default_towing := i.param_value_n;
				EXIT; -- mark jm 12.20.2011
            ELSIF i.param_name = 'TOWING LIMIT - LTO' AND v_subline_cd = p_v_subline_lto THEN
                p_default_towing := i.param_value_n;
				EXIT; -- mark jm 12.20.2011
            ELSIF i.param_name = 'TOWING LIMIT - MCL' AND v_subline_cd = p_v_subline_motorcycle THEN
                p_default_towing := i.param_value_n;
				EXIT; -- mark jm 12.20.2011
            ELSIF i.param_name = 'TOWING LIMIT - PC' AND v_subline_cd = p_v_subline_private THEN
                p_default_towing := i.param_value_n;
				EXIT; -- mark jm 12.20.2011
            ELSIF (i.param_name = 'TOWING LIMIT - CV' OR
                i.param_name = 'TOWING LIMIT - LTO' OR
                i.param_name = 'TOWING LIMIT - MCL' OR
                i.param_name = 'TOWING LIMIT - PC') AND
                v_pack_line_cd IS NOT NULL AND v_pack_subline_cd IS NOT NULL THEN
                p_default_towing := i.param_value_n;
				EXIT; -- mark jm 12.20.2011
            ELSIF i.param_name = 'DEFAULT_MC_TOW_LIMIT' THEN
                p_default_towing := i.param_value_n;
				EXIT; -- mark jm 12.20.2011
            END IF;
        END LOOP;
        
        FOR F_REC IN F LOOP   
            IF f_rec.param_name = 'PLATE NUMBER' THEN
                p_default_plate_no := f_rec.param_value_v;
            END IF;
        END LOOP;
    END;
    
    /* plan_sw */
    FOR i IN (
        SELECT NVL(plan_sw, 'N') plan_sw
          FROM gipi_wpolbas
         WHERE par_id = p_par_id)
    LOOP
        p_plan_sw := i.plan_sw;
    END LOOP;
    
    IF Check_User_Access('GIPIS211') = 0 THEN
        p_user_access := 'N';
    ELSE
        p_user_access := 'Y';
    END IF;
    
    p_ora2010_sw := Giisp.v('ORA2010_SW');    
END GIPIS010_NEW_FORM_INSTANCE1;
/


