DROP PROCEDURE CPI.GIPIS003_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS003_NEW_FORM_INSTANCE (
    p_par_id                IN gipi_wpolbas.par_id%TYPE,
    p_v_fire_item_type_bldg    OUT giis_fi_item_type.fr_item_type%TYPE,
    p_param1                OUT VARCHAR2,
    p_param2                OUT VARCHAR2,
    p_param3                OUT VARCHAR2,
    p_param4                OUT VARCHAR2,
    p_param5                OUT VARCHAR2,    
    p_display_risk            OUT VARCHAR2,
    p_loc_risk1                OUT /*gipi_wfireitm.loc_risk1%TYPE*/ VARCHAR2,
    p_loc_risk2                OUT /*gipi_wfireitm.loc_risk2%TYPE*/ VARCHAR2,
    p_loc_risk3                OUT /*gipi_wfireitm.loc_risk3%TYPE*/ VARCHAR2,
    p_default_curr_cd        OUT giis_currency.main_currency_cd%TYPE)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 01.28.2011
    **  Reference By     : (GIPIS003 - Item Information)
    **  Description     : This procedure is used for retrieving values when the form is called
    */
BEGIN
    FOR i IN (
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name LIKE 'BUILDINGS')
    LOOP
        p_v_fire_item_type_bldg := i.param_value_v;
    END LOOP;
    
    p_param1 := giisp.v('REQUIRE_FI_RISK_TAG');
    p_param2 := giisp.v('REQUIRE_FI_CONSTRUCTION');
    p_param3 := giisp.v('REQUIRE_FI_OCCUPANCY');
    p_param4 := giisp.v('REQUIRE_FI_RISK_NO');
    p_param5 := giisp.v('REQUIRE_FI_FIREITEM_TYPE');
    
    p_display_risk := 'N';
    
    FOR i IN (
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name LIKE 'DISPLAY_RISK')
    LOOP
        p_display_risk := i.param_value_v;
    END LOOP;
    
    FOR i IN (
        SELECT address1, address2, address3
          FROM gipi_wpolbas
         WHERE par_id = p_par_id)
    LOOP
        p_loc_risk1 := NVL(ESCAPE_VALUE(i.address1), NULL);
        p_loc_risk2 := NVL(ESCAPE_VALUE(i.address2), NULL);
        p_loc_risk3 := NVL(ESCAPE_VALUE(i.address3), NULL);
    END LOOP;
    
    IF p_loc_risk1 IS NULL AND p_loc_risk2 IS NULL AND p_loc_risk3 IS NULL THEN
        FOR i IN (
            SELECT mail_addr1, mail_addr2, mail_addr3
              FROM giis_assured
             WHERE assd_no = (
                    SELECT assd_no
                      FROM gipi_wpolbas
                     WHERE par_id = p_par_id))
        LOOP
            p_loc_risk1 := i.mail_addr1;
            p_loc_risk2 := i.mail_addr2;
            p_loc_risk3 := i.mail_addr3;
        END LOOP;
    END IF;

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
END GIPIS003_NEW_FORM_INSTANCE;
/


