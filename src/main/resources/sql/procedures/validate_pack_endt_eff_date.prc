DROP PROCEDURE CPI.VALIDATE_PACK_ENDT_EFF_DATE;

CREATE OR REPLACE PROCEDURE CPI.Validate_Pack_Endt_Eff_Date (
    p_v_old_date_eff    IN         GIPI_WPOLBAS.eff_date%TYPE,
    p_par_id            IN        GIPI_WPOLBAS.par_id%TYPE,
    p_line_cd            IN         GIPI_WPOLBAS.line_cd%TYPE,
    p_subline_cd        IN         GIPI_WPOLBAS.subline_cd%TYPE,
    p_iss_cd            IN         GIPI_WPOLBAS.iss_cd%TYPE,
    p_issue_yy            IN         GIPI_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no        IN         GIPI_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no            IN         GIPI_WPOLBAS.renew_no%TYPE,
    p_prorate_flag        IN        GIPI_WPOLBAS.prorate_flag%TYPE,
    p_endt_expiry_date    IN        GIPI_WPOLBAS.endt_expiry_date%TYPE,
    p_comp_sw            IN        GIPI_WPOLBAS.comp_sw%TYPE,
    p_pol_flag            IN        GIPI_WPOLBAS.pol_flag%TYPE,
    p_exp_chg_sw        IN        VARCHAR2,
    p_max_eff_date        IN        DATE,
    p_par_first_endt_sw    IN        VARCHAR2,    
    p_v_vdate            IN         NUMBER,
    p_issue_date        IN        GIPI_WPOLBAS.issue_date%TYPE,
    p_eff_date            IN OUT     VARCHAR2,
    p_incept_date        IN OUT     VARCHAR2,
    p_expiry_date        IN OUT    VARCHAR2,    
    p_endt_yy            IN OUT    GIPI_WPOLBAS.endt_yy%TYPE,
    p_sysdate_sw        IN OUT    VARCHAR2,    
    p_cg$back_endt        IN OUT    VARCHAR2,    
    p_par_back_endt_sw    IN OUT    VARCHAR2,
    p_v_expiry_date     OUT        GIPI_WPOLBAS.expiry_date%TYPE,
    p_ann_tsi_amt        OUT        GIPI_WPOLBAS.ann_tsi_amt%TYPE,
    p_ann_prem_amt        OUT        GIPI_WPOLBAS.ann_prem_amt%TYPE,    
    p_prorate_days        OUT        NUMBER,    
    p_mpl_switch        OUT        VARCHAR2,
    p_v_idate            OUT     VARCHAR2,
    p_booking_mth        OUT        VARCHAR2,
    p_booking_year        OUT        VARCHAR2,
    p_msg_alert            OUT        VARCHAR2)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 05.27.2010
    **  Reference By     : (GIPIS031 - Endt. Basic Information)
    **  Description     : This procedure returns the eff_date, incept_date, expiry_date, endt_yy, prorate_days, 
    **                    : ann_tsi_amt, ann_prem_amt, mpl_switch, sysdate_sw, cg$back_endt
    **                    : Moved from Oracle Forms Program_Unit of GIPIS031
    */
    v_add_time        NUMBER;
    v_end_of_day    VARCHAR2(1);
    
    v_max_eff_date    DATE;
    v_new_date        DATE;
    v_eff_date        DATE;
    v_eff_date2        DATE := TO_DATE(p_eff_date, 'MM-DD-RRRR');
    v_incept_date    DATE := TO_DATE(p_incept_date, 'MM-DD-RRRR');
    v_expiry_date    DATE := TO_DATE(p_expiry_date, 'MM-DD-RRRR');
    v_old_exp_cnt    NUMBER := 0;
    v_new_exp_cnt    NUMBER := 0;
    v_success        BOOLEAN := FALSE;
BEGIN
    p_ann_tsi_amt := null;
    p_ann_prem_amt := null;
    
    IF TRUNC(NVL(p_v_old_date_eff, SYSDATE)) != TRUNC(v_eff_date2) THEN
        Get_Addtl_Time_Gipis002(p_line_cd, p_subline_cd, v_add_time);
        v_end_of_day := Giis_Subline_Pkg.get_subline_time_sw(p_line_cd, p_subline_cd);
        
        IF NVL(v_end_of_day, 'N') = 'Y' THEN
            v_new_date := TRUNC(v_eff_date2) + 86399 / 86400;
        ELSE
            v_new_date := TRUNC(v_eff_date2) + v_add_time / 86400;
        END IF;
        
        IF v_new_date IS NOT NULL THEN
            v_eff_date2 := v_new_date;
        END IF;
        
    END IF;
    
    p_endt_yy := p_issue_yy;
    
    /* validate if the v_eff_date2 entered would not be earlier than the v_incept_date*/
    IF TRUNC(v_eff_date2) < TRUNC(v_incept_date) THEN
        p_mpl_switch := 'Y';
        p_msg_alert := 'Effectivity date should not be earlier than Inception date';
        --v_eff_date2 := p_v_old_date_eff;
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    END IF;
    
    /* validate if the v_eff_date2 entered would not be later than the expiry date*/
    IF TRUNC(v_eff_date2) > TRUNC(v_expiry_date) THEN
        p_mpl_switch := 'Y';
        p_msg_alert := 'Effectivity date should not be later than the Expiry date.';
        --v_eff_date2 := p_v_old_date_eff;
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    END IF;
	
	-- added by: Nica 01.15.2012
	/* validate if the v_eff_date2 entered would not be later than the endt expiry date*/
    IF TRUNC(v_eff_date2) > TRUNC(p_endt_expiry_date) THEN
        p_mpl_switch := 'Y';
        p_msg_alert := 'Effectivity date should not be later than the Endorsement Expiry date.';
        --v_eff_date2 := p_v_old_date_eff;
        GOTO RAISE_FORM_TRIGGER_FAILURE;
    END IF;
    
    /* if expiration date had been changed then valid effectivity date is only those that 
       are not later than the maximum effectivity date */
    IF p_exp_chg_sw = 'Y' AND p_max_eff_date IS NOT NULL THEN
        IF TRUNC(v_eff_date2) >= TRUNC(p_max_eff_date) THEN
            NULL;
        ELSE
            p_msg_alert := 'Effectivity date should not be earlier than the effectivity date ('||
                            TO_CHAR(p_max_eff_date, 'fmMonth DD, YYYY')||') of the latest  endorsement.';
            v_eff_date2 := NULL;
            GOTO RAISE_FORM_TRIGGER_FAILURE;
        END IF;
    END IF;
    
    /* get the latest eff_date of policy/endorsement */
    FOR C1 IN (
        SELECT eff_date
          FROM GIPI_PACK_POLBASIC
         WHERE line_cd     = p_line_cd
           AND subline_cd  = p_subline_cd
           AND iss_cd      = p_iss_cd
           AND issue_yy    = p_issue_yy
           AND pol_seq_no  = p_pol_seq_no
           AND renew_no    = p_renew_no
           AND endt_seq_no != 0
           AND pol_flag   IN ('1','2','3')
      ORDER BY eff_date DESC) 
    LOOP
        v_max_eff_date := c1.eff_date;
        EXIT;
    END LOOP;
    
    /* retrieved if there is an existing date same as the entered date
       for records with more than 1 record with same eff_date get the maximum date*/
    FOR A IN (
        SELECT eff_date
          FROM GIPI_PACK_POLBASIC
         WHERE line_cd     = p_line_cd
           AND subline_cd  = p_subline_cd
           AND iss_cd      = p_iss_cd
           AND issue_yy    = p_issue_yy
           AND pol_seq_no  = p_pol_seq_no
           AND renew_no    = p_renew_no
           AND pol_flag   IN ('1','2','3')
           AND eff_date = (SELECT MAX(eff_date)
                             FROM GIPI_PACK_POLBASIC
                            WHERE line_cd    = p_line_cd
                              AND subline_cd = p_subline_cd
                              AND iss_cd     = p_iss_cd
                              AND issue_yy   = p_issue_yy
                              AND pol_seq_no = p_pol_seq_no
                              AND renew_no   = p_renew_no
                              AND pol_flag   IN ('1','2','3')                                        
                              AND TRUNC(eff_date)   = TRUNC(v_eff_date2))
      ORDER BY eff_date DESC)
    LOOP
        v_eff_date := A.eff_date;
        EXIT;
    END LOOP;
    
    -- policy will reset it's information for changes in date 
    -- when the ff condition are encountered :
    --   1) for initial entry of policy that will be endorsed either new record 
    --      or changed in policy to be endorsed and enetered date is less than current date 
    --   2) for record that is previously a backward endt and was change to a normal endt.
    --   3) for changes in date will differ in the no. of short-term endt. that will be
    --      retrieved between the new and old eff_date
    --   4) for change in date that is a backward endt.
    
    -- entered date is earlier than SYSDATE and initial entry or change
    -- of policy to be endorsed
    IF TRUNC(v_eff_date2) < TRUNC(SYSDATE) AND p_sysdate_sw = 'Y' THEN
        search_for_pack_policy2(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy,    p_pol_seq_no, p_renew_no, v_eff_date2, 
                             v_expiry_date, p_v_expiry_date,p_ann_tsi_amt, p_ann_prem_amt, p_msg_alert, v_success);
        IF NOT v_success THEN
            GOTO RAISE_FORM_TRIGGER_FAILURE;
        END IF;
        p_sysdate_sw := 'N';
    ELSIF TRUNC(v_eff_date2) >= TRUNC(v_max_eff_date) OR v_max_eff_date IS NULL THEN
        -- check for the existence of short term endt. for the old eff_date
        FOR C1 IN (
            SELECT COUNT(*) cntr
              FROM gipi_polbasic c, gipi_pack_polbasic a, gipi_itmperil b
             WHERE c.pack_policy_id   = a.pack_policy_id
               AND b.policy_id   = c.policy_id
               AND a.line_cd     = p_line_cd
               AND a.subline_cd  = p_subline_cd
               AND a.iss_cd      = p_iss_cd
               AND a.issue_yy    = p_issue_yy
               AND a.pol_seq_no  = p_pol_seq_no
               AND a.renew_no    = p_renew_no
               AND a.pol_flag   IN ('1','2','3')                        
               AND TRUNC(NVL(a.endt_expiry_date, a.expiry_date)) < TRUNC(p_v_old_date_eff)
               AND (NVL(b.tsi_amt,0) <> 0 OR NVL(b.prem_amt,0)<> 0))
        LOOP             
            v_old_exp_cnt := c1.cntr;
        END LOOP;
        -- check for the existence of short term endt. for the old eff_date
        FOR C2 IN (
            SELECT COUNT(*) cntr
              FROM gipi_polbasic c, gipi_pack_polbasic a, gipi_itmperil b
             WHERE c.pack_policy_id   = a.pack_policy_id
               AND b.policy_id   = c.policy_id
               AND a.line_cd     = p_line_cd
               AND a.subline_cd  = p_subline_cd
               AND a.iss_cd      = p_iss_cd
               AND a.issue_yy    = p_issue_yy
               AND a.pol_seq_no  = p_pol_seq_no
               AND a.renew_no    = p_renew_no
               AND a.pol_flag   IN ('1','2','3')                        
               AND TRUNC(NVL(a.endt_expiry_date, a.expiry_date)) < TRUNC(v_eff_date2)
               AND (NVL(b.tsi_amt,0) <> 0 OR NVL(b.prem_amt,0)<> 0))
        LOOP             
            v_new_exp_cnt := c2.cntr;
        END LOOP;
        --toggle GLOBAL.CG$BACK_ENDT to determine that this endorsement had been changed from
        --backward to ordinary endorsement then retrieved corresponding info           
        IF p_cg$back_endt = 'Y' THEN
            p_cg$back_endt := 'N';
            -- retrieved current info based on entered date
            search_for_pack_policy2(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy,    p_pol_seq_no, p_renew_no, v_eff_date2, 
                             v_expiry_date, p_v_expiry_date,p_ann_tsi_amt, p_ann_prem_amt, p_msg_alert, v_success);
            IF NOT v_success THEN
                GOTO RAISE_FORM_TRIGGER_FAILURE;
            END IF;  
            -- if old eff_date and new eff_date differs in the no. of short term endt. 
            -- then retrievd new info.                 
        ELSIF v_old_exp_cnt <> v_new_exp_cnt THEN
            -- retrieved current info based on entered date
            search_for_pack_policy2(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy,    p_pol_seq_no, p_renew_no, v_eff_date2, 
                             v_expiry_date, p_v_expiry_date,p_ann_tsi_amt, p_ann_prem_amt, p_msg_alert, v_success);                
            IF NOT v_success THEN
                GOTO RAISE_FORM_TRIGGER_FAILURE;
            END IF;
        END IF;
    ELSE
        IF p_par_first_endt_sw = 'Y' THEN
            --p_msg_alert := 'This is a Backward Endorsement since it''s effectivity date is earlier than the effectivity date '||
            --                'of previous endorsement(s).';
            p_cg$back_endt := 'Y';
            search_for_pack_policy2(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy,    p_pol_seq_no, p_renew_no, v_eff_date2, 
                             v_expiry_date, p_v_expiry_date,p_ann_tsi_amt, p_ann_prem_amt, p_msg_alert, v_success);
            IF NOT v_success THEN
                GOTO RAISE_FORM_TRIGGER_FAILURE;
            END IF; 
            p_par_back_endt_sw := 'Y';
        ELSE
            --p_msg_alert := 'Since this is a Backward Endorsement initial information is not the latest record as of entered effectivity date. '||
            --                'Changes is about to take place.'
            p_cg$back_endt := 'Y';
            search_for_pack_policy2(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy,    p_pol_seq_no, p_renew_no, v_eff_date2, 
                             v_expiry_date, p_v_expiry_date,p_ann_tsi_amt, p_ann_prem_amt, p_msg_alert, v_success);
            IF NOT v_success THEN
                GOTO RAISE_FORM_TRIGGER_FAILURE;
            END IF; 
            p_par_back_endt_sw := 'Y';
        END IF; 
    END IF;
    
    -- If Endorsement effectivity date is the same as the endorsement date   
    -- of the latest endorsement, the time of the Endorsement effectivity    
    -- date is adjusted by adding one minute.                                
    IF v_eff_date IS NOT NULL THEN        
       v_eff_date2 := v_eff_date + (1/1440);
    END IF;
    --  If Endorsement effectivity date is the same as Policy inception date  
    --  the time of the Endorsement effectivity date is adjusted              
    --  by adding one minute.                                                   
    IF v_eff_date2 = v_incept_date THEN
      v_eff_date2 := v_eff_date2 + (1/1440);
    END IF;
    --temporary comment field in connection to booking
    --:b540.booking_mth  := NULL;
    --:b540.booking_year := NULL;
    
    --for changes in eff_date and endt. computation is based on pro-rate then
    --update no. of days depending on the new eff_date
    IF NVL(p_v_old_date_eff,SYSDATE) != v_eff_date2 AND p_prorate_flag = '1' AND p_endt_expiry_date IS NOT NULL AND v_eff_date2 IS NOT NULL THEN
        p_prorate_days := TRUNC(p_endt_expiry_date) - TRUNC(v_eff_date2);
        IF p_comp_sw = 'Y' THEN
            p_prorate_days := p_prorate_days + 1;
        ELSIF p_comp_sw = 'M' THEN                    
            p_prorate_days := p_prorate_days - 1;
        END IF;
    END IF; 
    
    
    --for cancelling endt. backward endt. is not consider
    --so toggle the switch that determines backward endt. to 'N' 
    IF p_pol_flag = '4' THEN
        p_cg$back_endt := 'N';
    END IF;
    
    DECLARE
        v_date_flag1    NUMBER := 2;
        v_date_flag2    NUMBER := 2;
        v_d1            VARCHAR2(10);
        v_d2            VARCHAR2(10);
        v_flag1         NUMBER := 2;
        v_flag2         NUMBER := 2;
    BEGIN
        IF p_v_vdate = 1 OR (p_v_vdate = 3 AND p_issue_date > v_eff_date2) THEN
            p_v_idate := TO_CHAR(p_issue_date, 'MM-DD-RRRR HH24:MI:SS');
            v_d2 := p_issue_date;
            
            FOR c IN (
                SELECT booking_year, 
                       TO_CHAR(TO_DATE('01-' || SUBSTR(booking_mth,1, 3) || '-' || booking_year, 'DD-MON-YYYY'), 'MM') 
                       booking_mth 
                  FROM GIIS_BOOKING_MONTH
                 WHERE (NVL(booked_tag, 'N') != 'Y')
                   AND (booking_year > TO_NUMBER(TO_CHAR(p_issue_date, 'YYYY'))
                    OR (booking_year = TO_NUMBER(TO_CHAR(p_issue_date, 'YYYY'))
                   AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3) || '-' || BOOKING_YEAR, 'DD-MON-YYYY'), 'MM'))>= TO_NUMBER(TO_CHAR(p_issue_date, 'MM'))))
              ORDER BY 1, 2 ) 
            LOOP
                p_booking_year := TO_NUMBER(c.booking_year);       
                p_booking_mth  := c.booking_mth;              
                v_date_flag2 := 5;
                EXIT;
            END LOOP;
            
            IF v_date_flag2 <> 5 THEN
                p_booking_year := NULL;
                p_booking_mth := NULL;
            END IF;
        ELSIF p_v_vdate = 2 OR (p_v_vdate = 3 AND p_issue_date <= v_eff_date2) THEN
            p_v_idate := TO_CHAR(v_eff_date2, 'MM-DD-RRRR HH24:MI:SS');
            
            FOR C IN (
                SELECT booking_year, 
                       TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year, 'DD-MON-RRRR'), 'MM'), 
                       booking_mth 
                  FROM GIIS_BOOKING_MONTH
                 WHERE (NVL(booked_tag, 'N') <> 'Y')
                   AND (booking_year > TO_NUMBER(TO_CHAR(v_eff_date2, 'YYYY'))
                    OR (booking_year = TO_NUMBER(TO_CHAR(v_eff_date2, 'YYYY'))
                   AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year, 'DD-MON-RRRR'), 'MM'))>= TO_NUMBER(TO_CHAR(v_eff_date2, 'MM'))))
              ORDER BY 1, 2 )
            LOOP
                p_booking_year := TO_NUMBER(c.booking_year);       
                p_booking_mth  := c.booking_mth;              
                v_date_flag2 := 5;
                EXIT;
            END LOOP;
            
            IF v_date_flag2 <> 5 THEN
                p_booking_year := NULL;
                p_booking_mth := NULL;
            END IF;
        END IF;
    END;    
    
    <<RAISE_FORM_TRIGGER_FAILURE>>
    NULL;

    p_eff_date := TO_CHAR(v_eff_date2, 'MM-DD-RRRR HH24:MI:SS');
    p_incept_date := TO_CHAR(v_incept_date, 'MM-DD-RRRR HH24:MI:SS');
    p_expiry_date := TO_CHAR(v_expiry_date, 'MM-DD-RRRR HH24:MI:SS');
END Validate_Pack_Endt_Eff_Date;
/


