DROP PROCEDURE CPI.GIPIS010_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_New_Form_Instance (
    p_par_id                IN GIPI_WPOLBAS.par_id%TYPE,
    p_line_cd                IN GIPI_WPOLBAS.line_cd%TYPE,
    p_subline_cd            IN GIPI_WPOLBAS.subline_cd%TYPE,
    p_iss_cd                IN GIPI_PARLIST.iss_cd%TYPE,
    p_region_cd                OUT GIPI_WITEM.region_cd%TYPE,
    p_v_subline_motorcycle    OUT GIIS_SUBLINE.subline_cd%TYPE,
    p_v_subline_commercial    OUT GIIS_SUBLINE.subline_cd%TYPE,
    p_v_subline_private        OUT GIIS_SUBLINE.subline_cd%TYPE,
    p_v_subline_lto            OUT GIIS_SUBLINE.subline_cd%TYPE,
    p_v_coc_lto                OUT GIPI_WVEHICLE.coc_type%TYPE,
    p_v_coc_nlto            OUT GIPI_WVEHICLE.coc_type%TYPE,
    p_v_mc_company_sw        OUT VARCHAR2,
    p_v_disc_exist            OUT VARCHAR2,
    p_p_dflt_coverage        OUT NUMBER,
    p_v_generate_coc        OUT VARCHAR2,
    p_user_access            OUT VARCHAR2,
    p_iss_cd_ri                OUT VARCHAR2,
    p_param_name            OUT VARCHAR2,
    p_peril_ded_exist        OUT VARCHAR2,
    p_towing                OUT VARCHAR2,
    p_ded_item_peril        OUT Gipis010_Ref_Cursor_Pkg.rc_gipi_wdeductibles_type,
    p_msg_alert                OUT VARCHAR2)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 08.17.2010
    **  Reference By     : (GIPIS010 - Item Information - MC)
    **  Description     : This procedures is called before the page is displayed
    **                    : Returning values to be used on the page
    */
    v_counter NUMBER;    
BEGIN
    
    p_v_mc_company_sw := 'N';
    p_v_generate_coc := 'N';
    p_user_access := 'N';
    p_v_disc_exist := 'N';
    
    FOR MOTORCYCLE IN (
        SELECT param_value_v cd
          FROM GIIS_PARAMETERS
         WHERE param_name = 'MOTORCYCLE')
    LOOP
        p_v_subline_motorcycle := motorcycle.cd;
        v_counter := NVL(v_counter,0) + 1;
    END LOOP;
    
    IF NVL(v_counter,0) = 0 THEN
        p_msg_alert := 'Error in getting values from GIIS_PARAMETERS for parameter name MOTORCYCLE';
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    ELSIF NVL(v_counter,0) > 1 THEN
        p_msg_alert := 'Too many rows fetch from GIIS_PARAMETERS for parameter name MOTORCYCLE';
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    END IF;
    
    v_counter := 0;
    
    FOR COMMERCIAL IN (
        SELECT param_value_v cd
          FROM GIIS_PARAMETERS
         WHERE param_name = 'COMMERCIAL VEHICLE')
    LOOP
        p_v_subline_commercial := commercial.cd;
        v_counter := NVL(v_counter,0) + 1;
    END LOOP;
    
    IF NVL(v_counter,0) = 0 THEN
        p_msg_alert := 'Error in getting values from GIIS_PARAMETERS for parameter name COMMERCIAL VEHICLE';
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    ELSIF NVL(v_counter,0) > 1 THEN
        p_msg_alert := 'Too many rows fetch from GIIS_PARAMETERS for parameter name COMMERCIAL VEHICLE';
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    END IF;
    
    v_counter := 0;
    
    FOR PRIVATE_CAR IN (
        SELECT param_value_v cd
          FROM GIIS_PARAMETERS
         WHERE param_name = 'PRIVATE CAR')
    LOOP
        p_v_subline_private := private_car.cd;
        v_counter := NVL(v_counter,0) + 1;
    END LOOP;
    
    IF NVL(v_counter,0) = 0 THEN
        p_msg_alert := 'Error in getting values from GIIS_PARAMETERS for parameter name PRIVATE CAR';
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    ELSIF NVL(v_counter,0) > 1 THEN
        p_msg_alert := 'Too many rows fetch from GIIS_PARAMETERS for parameter name PRIVATE CAR';
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    END IF;
    
    v_counter := 0;
    
    FOR LTO IN (
        SELECT param_value_v cd
          FROM GIIS_PARAMETERS
         WHERE param_name = 'LAND TRANS. OFFICE')
    LOOP
        p_v_subline_lto := lto.cd;
        v_counter := NVL(v_counter,0) + 1;
    END LOOP;
    
    IF NVL(v_counter,0) = 0 THEN
        p_msg_alert := 'Error in getting values from GIIS_PARAMETERS for parameter name LAND TRANS. OFFICE';
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    ELSIF NVL(v_counter,0) > 1 THEN
        p_msg_alert := 'Too many rows fetch from GIIS_PARAMETERS for parameter name LAND TRANS. OFFICE';
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    END IF;
    
    v_counter := 0;
    
    FOR LTO_TYPE IN (
        SELECT param_value_v cd
          FROM GIIS_PARAMETERS
         WHERE param_name = 'COC_TYPE_LTO')
    LOOP
       p_v_coc_lto := lto_type.cd;
       v_counter := NVL(v_counter,0) + 1;
    END LOOP;
    
    IF NVL(v_counter,0) = 0 THEN
        p_msg_alert := 'Error in getting values from GIIS_PARAMETERS for parameter name COC_TYPE_LTO';
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    ELSIF NVL(v_counter,0) > 1 THEN
        p_msg_alert := 'Too many rows fetch from GIIS_PARAMETERS for parameter name COC_TYPE_LTO';
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    END IF;
    
    v_counter := 0;
    
    FOR NLTO_TYPE IN (
        SELECT param_value_v cd
          FROM GIIS_PARAMETERS
         WHERE param_name = 'COC_TYPE_NLTO')
    LOOP
        p_v_coc_nlto := nlto_type.cd;
        v_counter := NVL(v_counter,0) + 1;
    END LOOP;
    
    IF NVL(v_counter,0) = 0 THEN
        p_msg_alert := 'Error in getting values from GIIS_PARAMETERS for parameter name COC_TYPE_NLTO';
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    ELSIF NVL(v_counter,0) > 1 THEN
        p_msg_alert := 'Too many rows fetch from GIIS_PARAMETERS for parameter name COC_TYPE_NLTO';
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    END IF;
    
    v_counter := 0;
    
    BEGIN
        SELECT param_value_v
          INTO p_v_mc_company_sw
            FROM GIIS_PARAMETERS
          WHERE param_name = 'REQUIRE_MC_COMPANY';    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_msg_alert := 'Error in getting value for parameter REQUIRE_MC_COMPANY from giis_parameters, '||
                   'no data found.';
            GOTO RAISE_FORM_TRIGGER_FAILURE;
        WHEN TOO_MANY_ROWS THEN
            p_msg_alert := 'Error in getting value for parameter REQUIRE_MC_COMPANY from giis_parameters, '||
                   'too many entries.';
            GOTO RAISE_FORM_TRIGGER_FAILURE;
    END;
    
    BEGIN
        SELECT param_value_n
          INTO p_p_dflt_coverage
          FROM GIIS_PARAMETERS
         WHERE param_name = 'DEFAULT_COVERAGE_CD';    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_msg_alert := 'Error in getting value for parameter DEFAULT_COVERAGE_CD from giis_parameters, '||
                   'no data found.';
            GOTO RAISE_FORM_TRIGGER_FAILURE;
        WHEN TOO_MANY_ROWS THEN
            p_msg_alert := 'Error in getting value for parameter DEFAULT_COVERAGE_CD from giis_parameters, '||
                   'too many entries.';
            GOTO RAISE_FORM_TRIGGER_FAILURE;
    END;
    
    FOR A IN (
        SELECT param_value_v
          FROM GIIS_PARAMETERS
         WHERE param_name = 'GENERATE_COC_SERIAL')
    LOOP
        p_v_generate_coc := a.param_value_v;
    END LOOP;
    
    /* p_user_access */
    IF Check_User_Access('GIPIS211') = 0 THEN
        p_user_access := 'N';
    ELSE
        p_user_access := 'Y';
    END IF;
    
    /* p_iss_cd_ri */    
    p_iss_cd_ri := Giis_Parameters_Pkg.v('ISS_CD_RI');    
    
    /* p_param_name */    
    p_param_name := Giis_Parameters_Pkg.n(p_iss_cd);    
    
    /* p_peril_ded_exist */    
    p_peril_ded_exist := NVL(Gipi_Wdeductibles_Pkg.Check_Gipi_Wdeductibles_Items(p_par_id, p_line_cd, p_subline_cd), 'N');    
    
    /* p_towing */
    DECLARE
        CURSOR B  IS   
            SELECT  param_name, param_value_n
              FROM  GIIS_PARAMETERS
             WHERE  param_name LIKE '%TOW%';
        
        v_pack_line_cd        GIPI_WITEM.pack_line_cd%TYPE;
        v_pack_subline_cd    GIPI_WITEM.pack_subline_cd%TYPE;
    BEGIN
        FOR i IN (
            SELECT pack_line_cd, pack_subline_cd
              FROM GIPI_WITEM
             WHERE par_id = p_par_id)
        LOOP
            v_pack_line_cd         := i.pack_line_cd;
            v_pack_subline_cd     := i.pack_subline_cd;
            EXIT;
        END LOOP;
        
        FOR i IN B
        LOOP
            IF i.param_name = 'TOWING LIMIT - CV' AND p_subline_cd = p_v_subline_commercial THEN
                p_towing := i.param_value_n;
            ELSIF i.param_name = 'TOWING LIMIT - LTO' AND p_subline_cd = p_v_subline_lto THEN
                p_towing := i.param_value_n;
            ELSIF i.param_name = 'TOWING LIMIT - MCL' AND p_subline_cd = p_v_subline_motorcycle THEN
                p_towing := i.param_value_n;
            ELSIF i.param_name = 'TOWING LIMIT - PC' AND p_subline_cd = p_v_subline_private THEN
                p_towing := i.param_value_n;
            ELSIF (i.param_name = 'TOWING LIMIT - CV' OR
                i.param_name = 'TOWING LIMIT - LTO' OR
                i.param_name = 'TOWING LIMIT - MCL' OR
                i.param_name = 'TOWING LIMIT - PC') AND
                v_pack_line_cd IS NOT NULL AND v_pack_subline_cd IS NOT NULL THEN
                p_towing := i.param_value_n;
            ELSIF i.param_name = 'DEFAULT_MC_TOW_LIMIT' THEN
                p_towing := i.param_value_n;
            END IF;
        END LOOP;
    END;
    
    /* region_cd */
    FOR A IN (
        SELECT a.region_cd region_cd
          FROM giis_issource a, giis_region b
         WHERE a.iss_cd = p_iss_cd
           AND a.region_cd = b.region_cd)
    LOOP
        IF a.region_cd IS NOT NULL THEN
           p_region_cd := a.region_cd;           
        END IF;
    END LOOP;
    
    /* disc_exist */
    FOR D1 IN (
        SELECT 1
          FROM gipi_wperil_discount
         WHERE par_id = p_par_id)
    LOOP
        p_v_disc_exist   := 'Y';
        EXIT;
    END LOOP;
    
    <<RAISE_FORM_TRIGGER_FAILURE>>
    NULL;
    
    OPEN p_ded_item_peril FOR
    SELECT a.*
      FROM GIPI_WDEDUCTIBLES a, GIIS_DEDUCTIBLE_DESC b
     WHERE a.ded_deductible_cd = deductible_cd
       AND a.ded_line_cd = b.line_cd
       AND a.ded_subline_cd = b.subline_cd
       AND a.par_id = p_par_id
       AND a.ded_line_cd = p_line_cd
       AND a.ded_subline_cd = p_subline_cd
       AND b.ded_type = 'T'
     ORDER BY 2 DESC, 3 DESC;
     
END Gipis010_New_Form_Instance;
/


