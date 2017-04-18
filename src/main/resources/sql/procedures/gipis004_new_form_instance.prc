DROP PROCEDURE CPI.GIPIS004_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS004_NEW_FORM_INSTANCE(
    p_par_id       GIPI_WPOLBAS.par_id%TYPE,
    p_default_curr_cd        OUT giis_currency.main_currency_cd%TYPE,
    p_default_region_cd        OUT giis_issource.region_cd%TYPE,
    p_plan_sw                OUT gipi_wpolbas.plan_sw%TYPE,    
    p_user_access            OUT VARCHAR2,
    p_ora2010_sw            OUT VARCHAR2
) AS
    
BEGIN
    
    /* default regiond cd */
    FOR i IN (
        SELECT a.region_cd region_cd
          FROM giis_issource a
         WHERE a.iss_cd = (SELECT iss_cd FROM gipi_parlist WHERE par_id = p_par_id))
    LOOP
        p_default_region_cd := i.region_cd;
        EXIT;
    END LOOP;
    
    /* default currency cd */
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
    
    
    /* plan_sw */
    FOR i IN (
        SELECT NVL(plan_sw, 'N') plan_sw
          FROM gipi_wpolbas
         WHERE par_id = p_par_id)
    LOOP
        p_plan_sw := i.plan_sw;
    END LOOP;
    
    /* check user access */
    IF Check_User_Access('GIUTS034') = 0 THEN
        p_user_access := 'N';
    ELSE
        p_user_access := 'Y';
    END IF;
    
    p_ora2010_sw := giisp.v('ORA2010_SW'); -- mark jm 11.16.2011 changed p_plan_sw to p_ora2010_sw
END GIPIS004_NEW_FORM_INSTANCE;
/


