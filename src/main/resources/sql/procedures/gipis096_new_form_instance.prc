DROP PROCEDURE CPI.GIPIS096_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS096_NEW_FORM_INSTANCE (
    p_default_curr_cd   OUT    GIIS_CURRENCY.main_currency_cd%TYPE,
    p_v_fire            OUT    GIIS_PARAMETERS.param_value_v%TYPE,
    p_v_aviation        OUT    GIIS_PARAMETERS.param_value_v%TYPE,
    p_v_marine_hull     OUT    GIIS_PARAMETERS.param_value_v%TYPE,
    p_v_casualty        OUT    GIIS_PARAMETERS.param_value_v%TYPE,
    p_v_engineering     OUT    GIIS_PARAMETERS.param_value_v%TYPE,
    p_v_accident        OUT    GIIS_PARAMETERS.param_value_v%TYPE,
    p_v_marine_cargo    OUT    GIIS_PARAMETERS.param_value_v%TYPE,
    p_v_motorcar        OUT    GIIS_PARAMETERS.param_value_v%TYPE,
    p_ora2010_sw        OUT    VARCHAR2)
AS
    /*
    **  Created by     : Veronica V. Raymundo
    **  Date Created  : July 19,2011
    **  Reference By : (GIPIS096 - Package Endt Policy Items)
    **  Description : This procedure is used for retrieving necessary values when the form is called
    */
    
BEGIN
    /* default currency_cd */
    DECLARE
        v_found VARCHAR2(1) := 'N';
    BEGIN
        FOR i IN (
            SELECT main_currency_cd currency_cd          
              FROM giis_currency
             WHERE currency_rt = 1)
        LOOP
            p_default_curr_cd := i.currency_cd;
            v_found := 'Y';
            EXIT;
        END LOOP;
        
        IF v_found = 'N' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Philippine currency not found in the maintenance table for currency. Please contact your database administrator.');
        END IF;    
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

END GIPIS096_NEW_FORM_INSTANCE;
/


