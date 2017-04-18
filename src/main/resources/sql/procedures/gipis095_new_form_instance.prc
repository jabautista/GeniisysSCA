DROP PROCEDURE CPI.GIPIS095_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS095_NEW_FORM_INSTANCE (
    p_pack_par_id IN gipi_parlist.pack_par_id%TYPE,
    p_default_curr_cd OUT giis_currency.main_currency_cd%TYPE,
    p_v_fire OUT giis_parameters.param_value_v%TYPE,
    p_v_aviation OUT giis_parameters.param_value_v%TYPE,
    p_v_marine_hull OUT giis_parameters.param_value_v%TYPE,
    p_v_casualty OUT giis_parameters.param_value_v%TYPE,
    p_v_engineering OUT giis_parameters.param_value_v%TYPE,
    p_v_accident OUT giis_parameters.param_value_v%TYPE,
    p_v_marine_cargo OUT giis_parameters.param_value_v%TYPE,
    p_v_motorcar OUT giis_parameters.param_value_v%TYPE,
    p_ora2010_sw OUT VARCHAR2)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created    : 03.17.2011
    **  Reference By    : (GIPIS095 - Package Policy Items)
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
             WHERE short_name LIKE giacp.v('DEFAULT_CURRENCY')  --currency_rt = 1) modified by Gzelle 10242014
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
    
    /* variables.fi */
    BEGIN
        SELECT param_value_v
          INTO p_v_fire
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_FI';         
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_FI is not existing in giis_parameters.');
    END;
    
    /* variables.av */
    BEGIN
        SELECT param_value_v
          INTO p_v_aviation
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_AV';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_AV is not existing in giis_parameters.');
    END;
    
    /* variables.mh */
    BEGIN
        SELECT param_value_v
          INTO p_v_marine_hull
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_MH';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_MH is not existing in giis_parameters.');
    END;
    
    /* variables.ca */
    BEGIN
        SELECT param_value_v
          INTO p_v_casualty
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_CA';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_CA is not existing in giis_parameters.');
    END;
    
    /* variables.en */
    BEGIN
        SELECT param_value_v
          INTO p_v_engineering
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_EN';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_EN is not existing in giis_parameters.');
    END;
    
    /* variables.ac */
    BEGIN
        SELECT param_value_v
          INTO p_v_accident
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_AC';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_AC is not existing in giis_parameters.');
    END;
    
    /* variables.mn */
    BEGIN
        SELECT param_value_v
          INTO p_v_marine_cargo
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_MN';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_MN is not existing in giis_parameters.');
    END;
    
    /* variables.mc */
    BEGIN
        SELECT param_value_v
          INTO p_v_motorcar
          FROM giis_parameters
         WHERE param_name LIKE 'LINE_CODE_MC';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'LINE_CD_MC is not existing in giis_parameters.');
    END;
    
    p_ora2010_sw := Giisp.v('ORA2010_SW');
END GIPIS095_NEW_FORM_INSTANCE;
/


