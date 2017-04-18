DROP PROCEDURE CPI.GIPIS019_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS019_NEW_FORM_INSTANCE (
    p_par_id    IN gipi_witem.par_id%TYPE,
    p_default_curr_cd    OUT giis_currency.main_currency_cd%TYPE,
    p_default_region_cd    OUT giis_issource.region_cd%TYPE,
    p_ora2010_sw        OUT VARCHAR2)
AS
    /*
    **  Created by      : Jerome Orio 
    **  Date Created    : 03.02.2011
    **  Reference By    : (GIPIS019 - Item Information - Aviation) 
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
             WHERE short_name LIKE giacp.v('DEFAULT_CURRENCY')  --currency_rt = 1) modified by Gzelle 10172014
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
    
    p_ora2010_sw := Giisp.v('ORA2010_SW');
END GIPIS019_NEW_FORM_INSTANCE;
/


