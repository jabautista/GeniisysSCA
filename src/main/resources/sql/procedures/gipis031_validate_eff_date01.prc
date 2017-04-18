DROP PROCEDURE CPI.GIPIS031_VALIDATE_EFF_DATE01;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_VALIDATE_EFF_DATE01 (
    p_v_v_old_date_eff IN gipi_wpolbas.eff_date%TYPE,    
    p_line_cd IN gipi_wpolbas.line_cd%TYPE,
    p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
    p_iss_cd IN gipi_wpolbas.iss_cd%TYPE,
    p_issue_yy IN gipi_wpolbas.issue_yy%TYPE,
    p_pol_seq_no IN gipi_wpolbas.pol_seq_no%TYPE,
    p_renew_no IN gipi_wpolbas.renew_no%TYPE,        
    p_incept_date IN gipi_wpolbas.incept_date%TYPE,
    p_expiry_date IN gipi_wpolbas.expiry_date%TYPE,
    p_v_exp_chg_sw IN VARCHAR2,
    p_v_max_eff_date IN DATE,
    p_v_v_mpl_sw OUT VARCHAR2,    
    p_endt_yy OUT gipi_wpolbas.endt_yy%TYPE,
    p_var_max_eff_date OUT DATE,
    p_var_eff_date OUT DATE,
    p_message OUT VARCHAR2,
    p_message_type OUT VARCHAR2,
    p_eff_date IN OUT gipi_wpolbas.eff_date%TYPE)
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================    
    **    01.10.2012    mark jm            Retrieve information based on the new specified effecivity date
    **                                Fires only when the entered effecivity date is changed and if
    **                                endt is a backward endt or if the change in effectivity will
    **                                make it a backward endorsement (Original Description)
    **                                Part 1. See GIPIS031_VALIDATE_EFF_DATE02 for next part
    **                                Reference By : (GIPIS031 - Endt. Basic Information)
    */
    v_add_time NUMBER;
    v_end_of_day VARCHAR2(1);
    v_new_date DATE;
BEGIN
    IF TRUNC(NVL(p_v_v_old_date_eff, SYSDATE)) != TRUNC(p_eff_date) THEN
        v_add_time := 0;
        get_addtl_time_gipis002(p_line_cd, p_subline_cd, v_add_time);  -- get the cut-off time for records subline           
        v_end_of_day := giis_subline_pkg.get_subline_time_sw(p_line_cd, p_subline_cd);
        
        IF NVL(v_end_of_day, 'N') = 'Y' THEN
            v_new_date := TRUNC(p_eff_date) + 86399 / 86400;
        ELSE
            v_new_date := TRUNC(p_eff_date) + v_add_time / 86400;
        END IF;
        
        IF v_new_date IS NOT NULL THEN
            p_eff_date := v_new_date;
        END IF;            
    END IF;
    
    -- endt_yy must be the same as the policy issue_yy
    p_endt_yy := p_issue_yy;
    -- validate if the eff_date entered would not be earlier than the inception date
    IF TRUNC(p_eff_date) < TRUNC(p_incept_date) THEN
       p_v_v_mpl_sw := 'Y';
       p_message := 'Effectivity date should not be earlier than Inception date';
       p_message_type := 'ERROR';
       p_eff_date := p_v_v_old_date_eff; 
       RETURN;
    END IF;
    -- validate if the eff_date entered would not be later than the expiry date
    IF TRUNC(p_eff_date) > TRUNC(p_expiry_date) THEN
       p_v_v_mpl_sw := 'Y';
       p_message := 'Effectivity date should not be later than the Expiry date.';
       p_message_type := 'ERROR';
       p_eff_date := p_v_v_old_date_eff;
       RETURN;
    END IF;
    --if expiration date had been changed then valid effectivity date is only those that 
    -- are not later than the maximum effectivity date
    IF p_v_exp_chg_sw = 'Y' AND p_v_max_eff_date IS NOT NULL THEN             
        IF TRUNC(p_eff_date) >= TRUNC(p_v_max_eff_date) THEN
            NULL;
        ELSE
            p_message := 'Effectivity date should not be earlier than the effectivity date ('||
                    TO_CHAR(p_v_max_eff_date, 'fmMonth DD, YYYY')||') of the latest  endorsement.';
            p_message_type := 'ERROR';
            p_eff_date := null;   
            RETURN;
        END IF;
    END IF;
    
    --get the latest eff_date of policy/endt.
    FOR C1 IN (SELECT eff_date
                 FROM gipi_polbasic
                WHERE line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND iss_cd = p_iss_cd
                  AND issue_yy = p_issue_yy
                  AND pol_seq_no = p_pol_seq_no
                  AND renew_no = p_renew_no
                  AND endt_seq_no != 0
                  AND pol_flag IN ('1','2','3')
             ORDER BY eff_date DESC) 
    LOOP
        p_var_max_eff_date := c1.eff_date;
        EXIT;
    END LOOP;
    
    -- retrieved if there is an existing date same as the entered date
    -- for records with more than 1 record with same eff_date get the maximum
    -- date    
    FOR A IN (SELECT eff_date
                FROM gipi_polbasic
               WHERE line_cd     = p_line_cd
                 AND subline_cd  = p_subline_cd
                 AND iss_cd      = p_iss_cd
                 AND issue_yy    = p_issue_yy
                 AND pol_seq_no  = p_pol_seq_no
                 AND renew_no    = p_renew_no
                 AND pol_flag   IN ('1','2','3')
                 AND eff_date = (SELECT MAX(eff_date)
                                   FROM gipi_polbasic
                                  WHERE line_cd    = p_line_cd
                                    AND subline_cd = p_subline_cd
                                    AND iss_cd     = p_iss_cd
                                    AND issue_yy   = p_issue_yy
                                    AND pol_seq_no = p_pol_seq_no
                                    AND renew_no   = p_renew_no
                                    AND pol_flag   IN ('1','2','3')                                        
                                   AND TRUNC(eff_date)   = TRUNC(p_eff_date))
            ORDER BY eff_date DESC)
    LOOP
        p_var_eff_date := A.eff_date;
        EXIT;
    END LOOP;
END GIPIS031_VALIDATE_EFF_DATE01;
/


