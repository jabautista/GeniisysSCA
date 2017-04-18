DROP PROCEDURE CPI.GIPIS031_VALIDATE_EFF_DATE02_1;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_VALIDATE_EFF_DATE02_1 (
    p_par_id           IN GIPI_WPOLBAS.par_id%TYPE,    
    p_var_max_eff_date IN DATE,
    p_line_cd          IN GIPI_WPOLBAS.line_cd%TYPE,
    p_subline_cd       IN GIPI_WPOLBAS.subline_cd%TYPE,
    p_iss_cd           IN GIPI_WPOLBAS.iss_cd%TYPE,
    p_issue_yy         IN GIPI_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no       IN GIPI_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no         IN GIPI_WPOLBAS.renew_no%TYPE,
    p_v_v_old_date_eff IN GIPI_WPOLBAS.eff_date%TYPE,
    p_expiry_date      IN GIPI_WPOLBAS.expiry_date%TYPE,    
    p_gipi_parlist     OUT gipis031_ref_cursor_pkg.rc_gipi_parlist_type,
    p_gipi_wpolbas     OUT gipis031_ref_cursor_pkg.rc_gipi_wpolbas_type,
    p_assd_name        OUT  VARCHAR2, 
    p_message          OUT VARCHAR2,
    p_message_type     OUT VARCHAR2,
    p_p_sysdate_sw     IN OUT VARCHAR2,
    p_v_v_exp_date     IN OUT DATE,
    p_eff_date         IN OUT GIPI_WPOLBAS.eff_date%TYPE,    
    p_p_cg_back_endt   IN OUT VARCHAR2)
AS
    /*    Date           Author                   Description
    **    ==========    =====================    ============================    
    **    08.24.2012   Veronica V. Raymundo       Retrieve information based on the new specified effectivity date
    **                                            Fires only when the entered effectivity date is changed and if
    **                                            endt is a backward endt or if the change in effectivity will
    **                                            make it a backward endorsement (Original Description)
    **                                            Part 2. See GIPIS031_VALIDATE_EFF_DATE03_REV for next part
    **                                            Reference By : (GIPIS031 - Endt. Basic Information)
    */
    
    v_old_exp_cnt  NUMBER := 0;   --counter for total expired short-term endt of old eff_date
    v_new_exp_cnt  NUMBER := 0;   --counter for total expired short-term endt of new eff_date
  
    v_parlist   GIPI_PARLIST%ROWTYPE;
    v_wpolbas   GIPI_WPOLBAS%ROWTYPE;

BEGIN
    -- policy will reset it's information for changes in date 
    -- when the ff condition are encountered :
    --   1) for initial entry of policy that will be endorsed either new record 
    --      or changed in policy to be endorsed and entered date is less than current date 
    --   2) for record that is previously a backward endt and was change to a normal endt.
    --   3) for changes in date will differ in the no. of short-term endt. that will be
    --      retrieved between the new and old eff_date
    --   4) for change in date that is a backward endt.
    
    -- entered date is earlier than SYSDATE and initial entry or change
    -- of policy to be endorsed
    
    /*IF TRUNC(p_eff_date) < TRUNC(SYSDATE)  AND p_p_sysdate_sw = 'Y' THEN        
        p_p_sysdate_sw := 'Y';  
        SEARCH_FOR_POLICY2_REV(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no,
            p_renew_no,    p_eff_date,    p_expiry_date, p_v_v_exp_date, v_parlist, v_wpolbas,
            p_assd_name,   p_message, p_message_type); -- retrieved current info based on entered date
        
        IF NOT p_message IS NULL THEN
            GOTO RAISE_FORM_TRIGGER; --RETURN;                
        END IF;
        p_p_sysdate_sw := 'N';   
    -- entered date is later than the latest endt., or there is still no endt.for policy
    ELS*/ -- commented these lines Nica 09.18.2012 - temporary solution for RSIC-TEST-RSIC SR 10768
    
    p_p_sysdate_sw := 'N';
	
	IF TRUNC(p_eff_date) >= TRUNC(p_var_max_eff_date) OR p_var_max_eff_date IS NULL THEN
        -- check for the existence of short term endt. for the old eff_date 
        FOR C1 IN (
            SELECT COUNT(*) cntr
              FROM GIPI_POLBASIC a, GIPI_ITMPERIL b
             WHERE a.policy_id   = b.policy_id
               AND a.line_cd     = p_line_cd
               AND a.subline_cd  = p_subline_cd
               AND a.iss_cd      = p_iss_cd
               AND a.issue_yy    = p_issue_yy
               AND a.pol_seq_no  = p_pol_seq_no
               AND a.renew_no    = p_renew_no
               AND a.pol_flag   IN ('1','2','3')                        
               AND TRUNC(NVL(a.endt_expiry_date, a.expiry_date)) < TRUNC(p_v_v_old_date_eff)
               AND (NVL(b.tsi_amt,0) <> 0 OR NVL(b.prem_amt,0)<> 0))
        LOOP             
            v_old_exp_cnt := c1.cntr;
        END LOOP;     
        -- check for the existence of short term endt. for the old eff_date
        FOR C2 IN (
            SELECT COUNT(*) cntr
              FROM GIPI_POLBASIC a, GIPI_ITMPERIL b
             WHERE a.policy_id   = b.policy_id
               AND a.line_cd     = p_line_cd
               AND a.subline_cd  = p_subline_cd
               AND a.iss_cd      = p_iss_cd
               AND a.issue_yy    = p_issue_yy
               AND a.pol_seq_no  = p_pol_seq_no
               AND a.renew_no    = p_renew_no
               AND a.pol_flag   IN ('1','2','3')                        
               AND TRUNC(NVL(a.endt_expiry_date, a.expiry_date)) < TRUNC(p_eff_date)
               AND (NVL(b.tsi_amt,0) <> 0 OR NVL(b.prem_amt,0)<> 0))
        LOOP             
            v_new_exp_cnt := c2.cntr;
        END LOOP;
        
        --toggle GLOBAL.CG$BACK_ENDT to determine that this endorsement had been changed from
        --backward to ordinary endorsement then retrieved corresponding info           
        IF p_p_cg_back_endt = 'Y' THEN
            p_p_cg_back_endt := 'N';
            SEARCH_FOR_POLICY2_REV(p_par_id,    p_line_cd,   p_subline_cd,  p_iss_cd,       p_issue_yy, p_pol_seq_no,
                                   p_renew_no,  p_eff_date,  p_expiry_date, p_v_v_exp_date, v_parlist,  v_wpolbas,
                                   p_assd_name, p_message,   p_message_type); -- retrieved current info based on entered date            
                  
            IF NOT p_message IS NULL THEN
                GOTO RAISE_FORM_TRIGGER;                
            END IF;
            -- if old eff_date and new eff_date differs in the no. of short term endt. 
            -- then retrieved new info.                 
        ELSIF v_old_exp_cnt <> v_new_exp_cnt THEN
            SEARCH_FOR_POLICY2_REV(p_par_id,    p_line_cd,   p_subline_cd,  p_iss_cd,       p_issue_yy,  p_pol_seq_no,
                                   p_renew_no,  p_eff_date,  p_expiry_date, p_v_v_exp_date, v_parlist,   v_wpolbas,
                                   p_assd_name, p_message,   p_message_type); -- retrieved current info based on entered date            
                  
            IF NOT p_message IS NULL THEN
                GOTO RAISE_FORM_TRIGGER;                
            END IF;
        END IF;
    ELSE
        p_message := 'Part 3';        
    END IF;
    
    <<RAISE_FORM_TRIGGER>>
    /* creates new record cursor for GIPI_PARLIST based on the following data */
    OPEN p_gipi_parlist FOR
    SELECT v_parlist.par_id par_id,        v_parlist.line_cd line_cd,          v_parlist.iss_cd iss_cd,
           v_parlist.par_yy par_yy,        v_parlist.par_seq_no par_seq_no,    v_parlist.quote_seq_no quote_seq_no,
           v_parlist.par_type par_type,    v_parlist.par_status par_status,    v_parlist.assd_no assd_no,
           v_parlist.address1 address1,    v_parlist.address2 address2,        v_parlist.address3 address3
      FROM DUAL;
    
    /* creates new record cursor for GIPI_WPOLBAS based on the following data */
    OPEN p_gipi_wpolbas FOR
    SELECT v_wpolbas.line_cd line_cd,                    v_wpolbas.subline_cd subline_cd,                v_wpolbas.iss_cd iss_cd,
           v_wpolbas.issue_yy issue_yy,                  v_wpolbas.pol_seq_no pol_seq_no,                v_wpolbas.renew_no renew_no,
           v_wpolbas.endt_iss_cd endt_iss_cd,            v_wpolbas.endt_yy endt_yy,                      v_wpolbas.incept_date incept_date,
           v_wpolbas.incept_tag incept_tag,              v_wpolbas.expiry_tag expiry_tag,                v_wpolbas.endt_expiry_date endt_expiry_tag,
           v_wpolbas.eff_date eff_date,                  v_wpolbas.endt_expiry_date endt_expiry_date,    v_wpolbas.type_cd type_cd,
           v_wpolbas.same_polno_sw same_polno_sw,        v_wpolbas.foreign_acc_sw foreign_acc_sw,        v_wpolbas.comp_sw comp_sw,
           v_wpolbas.prem_warr_tag prem_warr_tag,        v_wpolbas.old_assd_no old_assd_no,              v_wpolbas.old_address1 old_address1,
           v_wpolbas.old_address2 old_address2,          v_wpolbas.old_address3 old_address3,            v_wpolbas.address1 address1,
           v_wpolbas.address2 address2,                  v_wpolbas.address3 address3,                    v_wpolbas.reg_policy_sw reg_policy_sw,
           v_wpolbas.co_insurance_sw co_insurance_sw,    v_wpolbas.manual_renew_no manual_renew_no,      v_wpolbas.cred_branch cred_branch,
           v_wpolbas.ref_pol_no ref_pol_no,              v_wpolbas.takeup_term takeup_term,              v_wpolbas.booking_mth booking_mth,
           v_wpolbas.booking_year booking_year,          v_wpolbas.expiry_date expiry_date,              v_wpolbas.prov_prem_tag prov_prem_tag,
           v_wpolbas.prov_prem_pct prov_prem_pct,        v_wpolbas.prorate_flag prorate_flag,            v_wpolbas.pol_flag pol_flag,
           v_wpolbas.ann_tsi_amt ann_tsi_amt,            v_wpolbas.ann_prem_amt ann_prem_amt,            v_wpolbas.issue_date issue_date,
           v_wpolbas.pack_pol_flag pack_pol_flag
      FROM DUAL;
    
END GIPIS031_VALIDATE_EFF_DATE02_1;
/


