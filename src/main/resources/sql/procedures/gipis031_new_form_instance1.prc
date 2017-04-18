CREATE OR REPLACE PROCEDURE CPI.GIPIS031_NEW_FORM_INSTANCE1 (
    p_par_id IN gipi_wpolbas.par_id%TYPE,
    p_g_cancellation_type OUT VARCHAR2,
    p_g_cancel_tag OUT VARCHAR2,
    p_v_lc_mc OUT VARCHAR2,
    p_v_lc_ac OUT VARCHAR2,
    p_v_subline_mop OUT VARCHAR2,
    p_v_advance_booking OUT VARCHAR2,
    p_v_lc_en OUT VARCHAR2,
    p_c_mop_subline OUT VARCHAR2,
    p_v_var_v_date OUT VARCHAR2,
    p_req_ref_pol_no OUT VARCHAR2,
    p_req_ref_no OUT VARCHAR2, --added by gab 11.17.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
    p_show_marine_detail_button OUT VARCHAR2,
    p_show_banca_detail_button OUT VARCHAR2,
    p_region_cd OUT VARCHAR2,
    p_existing_claim OUT VARCHAR2,
    p_paid_amt OUT NUMBER,
    p_req_survey_sett_agent OUT VARCHAR2,
    p_open_policy_sw OUT VARCHAR2,
    p_ora2010_sw OUT VARCHAR2,
	p_invoice_exist OUT VARCHAR2,
    p_msg_alert OUT VARCHAR2,
    p_industry_cd OUT VARCHAR2) -- bonok :: 11.15.2012
AS    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    06.11.2010    mark jm            retrieve values that will be used on endt basic info
    **                                Reference By : (GIPIS031 - Endt. Basic Information)
    **     01.06.2012    mark jm            added p_open_policy_sw 
    */
    v_line_cd       gipi_wpolbas.line_cd%TYPE;
    v_subline_cd    gipi_wpolbas.subline_cd%TYPE;
    v_iss_cd        gipi_wpolbas.iss_cd%TYPE;
    v_issue_yy      gipi_wpolbas.issue_yy%TYPE;
    v_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE;
    v_renew_no      gipi_wpolbas.renew_no%TYPE;
    v_assd_no       gipi_wpolbas.assd_no%TYPE; -- bonok :: 11.15.2012
BEGIN
    gipi_wpolbas_pkg.get_gipi_wpolbas_par_no(p_par_id, v_line_cd, v_subline_cd, 
        v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no);
        
    IF v_line_cd IS NULL OR v_iss_cd IS NULL THEN
        gipi_parlist_pkg.get_line_cd_iss_cd(p_par_id, v_line_cd, v_iss_cd);
    END IF;
        
    p_g_cancellation_type := NULL;
    p_g_cancel_tag := 'N';
    
    /* INITIALIZE_PARAMETERS procedure */
    FOR A1 IN (
        SELECT a.param_value_v  a_param_value_v,
               b.param_value_v  b_param_value_v
          FROM giis_parameters a,
               giis_parameters b
         WHERE a.param_name LIKE 'MOTOR CAR'
           AND b.param_name LIKE 'LINE_CODE_AC')
    LOOP     
        p_v_lc_mc  := a1.a_param_value_v;
        p_v_lc_ac  := a1.b_param_value_v;
        EXIT;
    END LOOP;
    
    FOR B IN (
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name = 'MN_SUBLINE_MOP')
    LOOP
        p_v_subline_mop := b.param_value_v;
    END LOOP;
    
    p_v_advance_booking := 'N';
    
    FOR E IN (
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name = 'ALLOW_BOOKING_IN_ADVANCE')
    LOOP
        p_v_advance_booking := E.param_value_v;
    END LOOP;
    
    FOR F IN (
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name = 'LINE_CODE_EN')
    LOOP
        p_v_lc_en  := F.param_value_v;        
    END LOOP;
    ---------------------------------------------------
    DECLARE
        v_exist5    NUMBER;
        v_co_ins_sw    gipi_wpolbas.co_insurance_sw%TYPE;
        v_flag        giis_subline.op_flag%TYPE;
    BEGIN
        FOR A2 IN(
            SELECT a760.param_value_v mop
              FROM giis_parameters a760
             WHERE a760.param_name = 'MN_SUBLINE_MOP')
        LOOP
            p_c_mop_subline := a2.mop;
            EXIT;
        END LOOP;
        
        IF v_subline_cd != p_c_mop_subline THEN
            BEGIN
                FOR co IN (
                    SELECT co_insurance_sw
                      FROM gipi_wpolbas
                     WHERE par_id = p_par_id)
                LOOP
                    v_co_ins_sw := co.co_insurance_sw;
                END LOOP;
            END;
            
            IF v_exist5 IS NOT NULL THEN
                DECLARE
                   v_exist1        NUMBER;
                   v_exist2        NUMBER;
                   v_exist3        NUMBER;
                   v_exist4        NUMBER;
                   v_exist5        NUMBER;
                   ri_iss_cd    giis_issource.iss_cd%TYPE;
                BEGIN
                    FOR cd IN (
                        SELECT param_value_v
                          FROM giis_parameters
                         WHERE param_name = 'RI_ISS_CD')
                    LOOP
                        ri_iss_cd := cd.param_value_v;
                    END LOOP;
                    
                    SELECT DISTINCT 1
                      INTO v_exist3
                      FROM gipi_witmperl b490
                     WHERE b490.par_id = p_par_id;
                END;
            END IF;
        END IF;
    END;
    
    DECLARE
        v_require VARCHAR2(1) := 'N';
    BEGIN
        FOR C IN (
            SELECT param_value_n
              FROM giac_parameters
             WHERE param_name = 'PROD_TAKE_UP')
        LOOP
            p_v_var_v_date := C.param_value_n;
        END LOOP;
        
        IF TO_NUMBER(p_v_var_v_date) > 3 THEN
            p_msg_alert := 'The parameter value (' || p_v_var_v_date || ') for parameter name ''PROD_TAKE_UP'' is invalid. Please do the necessary changes.';
            GOTO RAISE_FORM_TRIGGER_FAILURE;
        END IF;
        
        FOR A IN (
            SELECT DECODE(param_value_v, 'Y', 'Y', 'N') param_value_v
              FROM giis_parameters
             WHERE param_name = 'REQUIRE_REF_POL_NO')
        LOOP
            p_req_ref_pol_no := a.param_value_v;
            EXIT;
        END LOOP;
        
--        added by gab 11.17.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
        FOR G IN (
            SELECT DECODE(param_value_v, 'Y', 'Y', 'N') param_value_v
              FROM giis_parameters
             WHERE param_name = 'REQUIRE_REF_NO')
        LOOP
            p_req_ref_no := g.param_value_v;
            EXIT;
        END LOOP;        
    END;
    
    DECLARE
        v_param_value_v   VARCHAR2(200);
        v_menu_line_cd    VARCHAR2(2);
    BEGIN
        FOR X IN (
            SELECT param_value_v
              FROM giis_parameters
             WHERE param_name = 'LINE_CODE_MN')
        LOOP
            v_param_value_v := X.param_value_v;
        END LOOP;
    
        FOR y IN (
            SELECT menu_line_cd
              FROM giis_line
             WHERE line_cd = v_line_cd)
        LOOP
            v_menu_line_cd := y.menu_line_cd;
        END LOOP;
        
        IF (v_line_cd = v_param_value_v) OR ('MN' = v_menu_line_cd) THEN
            p_show_marine_detail_button := 'Y';
            FOR i IN (
                SELECT param_value_v 
                  FROM giis_parameters
                 WHERE param_name = 'REQ_SURVEY_SETT_AGENT')
            LOOP
                p_req_survey_sett_agent := i.param_value_v;
            END LOOP;
        ELSE
            p_show_marine_detail_button := 'N';
        END IF;
    END;
    
    IF Giisp.v('ORA2010_SW') <> 'Y' THEN
        p_show_banca_detail_button := 'N';
    ELSE
        p_show_banca_detail_button := 'Y';
    END IF;
    
    /* retrieve region_cd */
    FOR X IN (
        SELECT region_desc, region_cd
          FROM giis_region
         WHERE region_cd = (SELECT region_cd 
                              FROM giis_issource
                             WHERE iss_cd = v_iss_cd))
    LOOP
         p_region_cd := X.region_cd;
         EXIT;
    END LOOP;
    
    /* check for pending claims */
    IF gicl_claims_pkg.chk_for_pending_claims(v_line_cd, v_subline_cd, 
            v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no) > 0 THEN
        p_existing_claim := 'Y';
    ELSE
        p_existing_claim := 'N';
    END IF;
    
    /* check for paid policy */
    p_paid_amt := giac_aging_soa_details_pkg.check_policy_payment(v_line_cd, v_subline_cd, 
            v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no);
            
    /* open_policy_sw */    
    FOR A1 IN (
        SELECT open_policy_sw
          FROM giis_subline
         WHERE line_cd = v_line_cd 
           AND subline_cd = v_subline_cd)
    LOOP
        p_open_policy_sw  := a1.open_policy_sw;
        EXIT;
   END LOOP;
   
   /* ora2010_sw */
   p_ora2010_sw := giisp.v('ORA2010_SW');
   
    FOR i IN (
        SELECT 1
          FROM gipi_winv_tax
         WHERE par_id = p_par_id)
    LOOP
        p_invoice_exist := 'Y';
    END LOOP; 
    
    /* retrieve industry cd */ -- bonok begin :: 11.15.2012 
    FOR ind IN (SELECT industry_cd 
	              FROM giis_assured 
	             WHERE assd_no = (SELECT assd_no
                                    FROM gipi_parlist
                                   WHERE par_id = p_par_id))
    LOOP
        p_industry_cd := ind.industry_cd;
	END LOOP; -- bonok end :: 11.15.2012
    
    <<RAISE_FORM_TRIGGER_FAILURE>>
    NULL;
END GIPIS031_NEW_FORM_INSTANCE1;
/


