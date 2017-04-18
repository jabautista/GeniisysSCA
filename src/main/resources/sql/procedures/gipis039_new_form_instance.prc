DROP PROCEDURE CPI.GIPIS039_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS039_NEW_FORM_INSTANCE (
    p_par_id                IN gipi_wpolbas.par_id%TYPE,  
    p_endt_tax_sw           OUT gipi_wendttext.endt_tax%TYPE,
    p_fire_item_type_bldg   OUT VARCHAR2,
    p_display_risk          OUT VARCHAR2,
    p_default_curr_cd       OUT giis_currency.main_currency_cd%TYPE,
    p_allow_update_curr_rate OUT VARCHAR2,
    p_fire_item_type        OUT VARCHAR2,
    p_subline_htp           OUT VARCHAR2,
    p_loc_risk1             OUT GIPI_WPOLBAS.address1%TYPE,
    p_loc_risk2             OUT GIPI_WPOLBAS.address2%TYPE,
    p_loc_risk3             OUT GIPI_WPOLBAS.address3%TYPE)
AS
    /*
    **  Created by        : Andrew Robes
    **  Date Created     : 04.19.2011
    **  Reference By     : (GIPIS039 - Endt Fire Item Information)
    **  Description     : This procedure is used for retrieving values when the form is called
    */
BEGIN
    FOR A IN (SELECT endt_tax
                FROM gipi_wendttext
               WHERE par_id = p_par_id) 
    LOOP
        p_endt_tax_sw := a.endt_tax;
        EXIT;
    END LOOP;  

    FOR i IN (
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name LIKE 'BUILDINGS')
    LOOP
        p_fire_item_type_bldg := i.param_value_v;
    END LOOP;
       
    p_display_risk := 'N';
    
    FOR i IN (
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name LIKE 'DISPLAY_RISK')
    LOOP
        p_display_risk := i.param_value_v;
    END LOOP;
        
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
    
    FOR C1 IN (SELECT  param_value_v
                FROM  giis_parameters
               WHERE  param_name LIKE 'STOCKS') 
    LOOP
      p_fire_item_type := c1.param_value_v;
      EXIT;
    END LOOP;
    
   FOR A1 IN (SELECT  param_value_v HTP
                FROM  giis_parameters
               WHERE  param_name = 'SUBLINE_HTP') LOOP
      p_subline_htp := A1.HTP;      
   END LOOP;
   
   FOR a in (select param_value_v
               from giis_parameters
	          where param_name = 'ALLOW_UPDATE_CURR_RATE') 
   LOOP
      p_allow_update_curr_rate := a.param_value_v;
   END LOOP;
   
    FOR i IN (
        SELECT address1, address2, address3
          FROM gipi_wpolbas
         WHERE par_id = p_par_id)
    LOOP
        p_loc_risk1 := NVL(ESCAPE_VALUE(i.address1), NULL); --added escape_value 03.11.2013 sr12425
        p_loc_risk2 := NVL(ESCAPE_VALUE(i.address2), NULL); --added escape_value 03.11.2013 sr12425
        p_loc_risk3 := NVL(ESCAPE_VALUE(i.address3), NULL); --added escape_value 03.11.2013 sr12425
    END LOOP;
   
END GIPIS039_NEW_FORM_INSTANCE;
/


