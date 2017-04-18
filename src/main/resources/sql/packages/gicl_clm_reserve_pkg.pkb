CREATE OR REPLACE PACKAGE BODY CPI.gicl_clm_reserve_pkg
AS
 
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 10.10.2011
   **  Reference By  : (GICLS010 - Basic Information) 
   **  Description   : check if gicl_item_peril exist 
   */        
    FUNCTION get_gicl_clm_reserve_exist( 
        p_claim_id          gicl_clm_reserve.claim_id%TYPE
        ) 
    RETURN VARCHAR2 IS
      v_exists      varchar2(1) := 'N';
    BEGIN
      FOR h IN (SELECT DISTINCT 'X'
                  FROM gicl_clm_reserve
                 WHERE claim_id = p_claim_id) 
      LOOP
          v_exists := 'Y';
          EXIT;
      END LOOP;
    RETURN v_exists;
    END;
    
    /*
    **  CREATED BY:     Roy Encela
    **  DATE CREATED:   2012-01-19
    **  REFERENCED BY:  GICLS024(Claim Reserve)
    **  DESCRIPTION:    update
    **
    */
    PROCEDURE update_clm_dist_tag_gicls024(
        p_claim_id        IN gicl_clm_reserve.claim_id%TYPE
    ) IS
        V_EXISTS       VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT DISTINCT 'X'
              INTO V_EXISTS --
              FROM GICL_CLM_RES_HIST
             WHERE DIST_SW   = 'Y'
               AND CLAIM_ID  = p_claim_id;
               
            UPDATE GICL_CLAIMS
               SET CLM_DIST_TAG  = 'N'
             WHERE CLAIM_ID      = p_claim_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              UPDATE GICL_CLAIMS
                 SET CLM_DIST_TAG  = 'Y'
               WHERE CLAIM_ID      = p_claim_id;
        END;
    END update_clm_dist_tag_gicls024;
    
    PROCEDURE update_negate_date(
        p_claim_id        IN gicl_clm_reserve.claim_id%TYPE,
        p_item_no         IN gicl_clm_reserve.item_no%TYPE,
        p_peril_cd        IN gicl_clm_reserve.peril_cd%TYPE,
        p_grouped_item_no IN gicl_clm_reserve.grouped_item_no%TYPE,
        p_hist_seq_no     IN gicl_clm_res_hist.hist_seq_no%TYPE
    )IS
    BEGIN
        UPDATE gicl_clm_res_hist
           SET negate_date = SYSDATE
         WHERE claim_id = p_claim_id
           AND item_no = p_item_no
           AND peril_cd = p_peril_cd
           AND grouped_item_no = p_grouped_item_no
           AND hist_seq_no = p_hist_seq_no - 1;
    END;
    
    PROCEDURE update_preb_booking_date(
        p_claim_id          IN gicl_clm_res_hist.claim_id%TYPE,
        p_item_no           IN gicl_clm_res_hist.item_no%TYPE,
        p_peril_cd          IN gicl_clm_res_hist.peril_cd%TYPE,
        p_grouped_item_no   IN gicl_clm_res_hist.grouped_item_no%TYPE,
        p_hist_seq_no       IN gicl_clm_res_hist.hist_seq_no%TYPE,
        p_clm_res_hist_id   IN gicl_clm_res_hist.clm_res_hist_id%TYPE,
        p_old_month            IN OUT VARCHAR2,
        p_old_year            IN OUT NUMBER
    )IS
    BEGIN
        UPDATE    gicl_clm_res_hist
          SET    booking_month = p_old_month,
                booking_year = p_old_year
          WHERE    claim_id = p_claim_id
          AND    item_no = p_item_no
          AND    peril_cd = p_peril_cd
          AND   grouped_item_no = p_grouped_item_no
          AND    hist_seq_no = (p_hist_seq_no-1)
          AND    clm_res_hist_id = (p_clm_res_hist_id-1);
    END update_preb_booking_date;
    
    PROCEDURE update_workflow_switch(
        p_event_desc IN VARCHAR2,
        p_module_id  IN VARCHAR2,
        p_user       IN VARCHAR2
    )IS
        v_commit boolean;
    BEGIN
        v_commit := false;
        FOR a_rec IN (SELECT b.event_user_mod, c.event_col_cd 
                        FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
                       WHERE 1=1
                         AND c.event_cd = a.event_cd
                         AND c.event_mod_cd = a.event_mod_cd
                         AND b.event_mod_cd = a.event_mod_cd
                         AND b.userid = p_user
                         AND a.module_id = p_module_id
                           AND a.event_cd = d.event_cd
                           AND UPPER(d.event_desc) = UPPER(NVL(p_event_desc,d.event_desc)) )
          LOOP
            FOR B_REC IN ( SELECT b.col_value, b.tran_id , b.event_col_cd, b.event_user_mod, b.switch 
                               FROM gipi_user_events b 
                              WHERE b.event_user_mod = a_rec.event_user_mod 
                              AND b.event_col_cd = a_rec.event_col_cd )
              LOOP
              IF b_rec.switch = 'N' THEN
                   UPDATE gipi_user_events
                      SET switch = 'Y'
                    WHERE event_user_mod = b_rec.event_user_mod
                      AND event_col_cd = b_rec.event_col_cd
                      AND tran_id = b_rec.tran_id;
                   v_commit := TRUE;
                END IF;  
              END LOOP;
          END LOOP;
            IF v_commit = TRUE THEN
               COMMIT;
            END IF; 
    END update_workflow_switch;
    
    PROCEDURE extract_expiry(
        p_line_cd IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd IN gipi_polbasic.iss_cd%TYPE, -- POL_ISS_CD
        p_issue_yy IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no IN gipi_polbasic.renew_no%TYPE,
        p_loss_date IN gipi_polbasic.eff_date%TYPE,
        p_nbt_expiry_date OUT gipi_polbasic.expiry_date%TYPE
    )IS 
        v_max_eff_date      gipi_polbasic.eff_date%TYPE;
        v_expiry_date       gipi_polbasic.expiry_date%TYPE;
        v_max_endt_seq      gipi_polbasic.endt_seq_no%TYPE;
    BEGIN
        FOR a1 IN(
            SELECT expiry_date
              FROM gipi_polbasic a
             WHERE a.line_cd = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.iss_cd = p_iss_cd
               AND a.issue_yy = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no = p_renew_no
               AND a.pol_flag IN ('1', '2', '3', 'X')
               AND NVL(a.endt_seq_no,0) = 0)
        LOOP
            v_expiry_date  := a1.expiry_date;
            
            FOR b1 IN (
                SELECT expiry_date, endt_seq_no 
                  FROM gipi_polbasic a
                 WHERE a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.iss_cd = p_iss_cd
                     AND a.issue_yy = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no = p_renew_no
                     AND a.pol_flag IN ('1', '2', '3', 'X')
                     AND TRUNC(a.eff_date) <= TRUNC(p_loss_date)
                     AND NVL(a.endt_seq_no,0) > 0
                     AND expiry_date <> a1.expiry_date
                     AND expiry_date = endt_expiry_date
                   ORDER BY a.eff_date DESC     
            )LOOP
                v_expiry_date  := b1.expiry_date; 
                v_max_endt_seq := b1.endt_seq_no;
                
                FOR b2 IN (
                   SELECT expiry_date, endt_seq_no
                   FROM gipi_polbasic a
                  WHERE a.line_cd    = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd     = p_iss_cd
                    AND a.issue_yy   = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no   = p_renew_no
                    AND a.pol_flag in ('1','2','3','X')
                    AND TRUNC(a.eff_date) <= TRUNC(p_loss_date)              
                    AND NVL(a.endt_seq_no,0) > b1.endt_seq_no
                    AND expiry_date <> b1.expiry_date
                    AND expiry_date = endt_expiry_date
                  ORDER BY a.eff_date DESC
                )LOOP
                    v_expiry_date  := b2.expiry_date;
                    v_max_endt_seq := b2.endt_seq_no;
                    EXIT;
                END LOOP;
                
                FOR c IN(
                    SELECT expiry_date
                      FROM gipi_polbasic a
                     WHERE a.line_cd    = p_line_cd
                       AND a.subline_cd = p_subline_cd
                       AND a.iss_cd     = p_iss_cd
                       AND a.issue_yy   = p_issue_yy
                       AND a.pol_seq_no = p_pol_seq_no
                       AND a.renew_no   = p_renew_no
                       AND a.pol_flag in ('1','2','3','X')
                       AND TRUNC(a.eff_date)   <= TRUNC(p_loss_date)
                       AND NVL(a.endt_seq_no,0) > 0
                       AND expiry_date <> a1.expiry_date
                       AND expiry_date = endt_expiry_date
                       AND NVL(a.back_stat,5) = 2
                       AND NVL(a.endt_seq_no,0) > v_max_endt_seq
                )LOOP
                    v_expiry_date  := c.expiry_date;
                    EXIT;
                END LOOP;
            END LOOP;
        END LOOP;
       p_nbt_expiry_date := v_expiry_date;
    END extract_expiry;
    
    PROCEDURE validate_existing_dist(
       p_line_cd IN gipi_polbasic.line_cd%TYPE,
       p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
       p_iss_cd IN gipi_polbasic.iss_cd%TYPE,
       p_issue_yy IN gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no IN gipi_polbasic.renew_no%TYPE,
       p_proceed OUT VARCHAR2,
       p_message OUT VARCHAR2, 
       p_call_module OUT VARCHAR2
    )IS
        v_dist_param    giis_parameters.param_value_v%TYPE;
        v_hdr_sw        VARCHAR2(1);
        v_dtl_sw        VARCHAR2(1);
        v_exists        VARCHAR2(1);
    BEGIN
        p_call_module := '';
        p_proceed := 'Y';
        FOR rec IN (SELECT param_value_v
					  FROM giis_parameters
                     WHERE param_name = 'DISTRIBUTED')
        LOOP
            v_dist_param := rec.param_value_v;
            EXIT;
        END LOOP;             
        
        FOR chk_undist IN( SELECT '1'
                             FROM gipi_polbasic a,
                                  giuw_pol_dist b
                            WHERE a.line_cd = p_line_cd
                              AND a.subline_cd = p_subline_cd
                              AND a.iss_cd = p_iss_cd
                              AND a.issue_yy = p_issue_yy
                              AND a.pol_seq_no = p_pol_seq_no
                              AND a.renew_no = p_renew_no
                              AND a.policy_id      = b.policy_id 
                              AND a.pol_flag    IN ('1','2','3', 'X')
                              AND b.dist_flag      NOT IN ( v_dist_param, 5)
                              AND b.negate_date IS NULL
                                  AND NOT EXISTS   (SELECT c.policy_id
                                                      FROM gipi_endttext c
                                                     WHERE c.endt_tax = 'Y'
                                                       AND c.policy_id = a.policy_id))
        LOOP
            v_exists := 'X';
            EXIT;
        END LOOP;                 
        
        IF v_exists = 'X' THEN
            p_message := 'Policy is Undistributed.'||chr(10)|| 'Setting up of reserve is not allowed for claim with undistributed policy/endorsement.';
            p_proceed := 'N';
			RETURN;
        END IF;
        
        FOR get_dist IN(
            SELECT b.dist_no dist_no, a.policy_id policy_id
              FROM gipi_polbasic a, giuw_pol_dist b
             WHERE a.line_cd    = p_line_cd 
               AND a.subline_cd = p_subline_cd 
               AND a.iss_cd     = p_iss_cd 
               AND a.issue_yy   = p_issue_yy 
               AND a.pol_seq_no = p_pol_seq_no 
               AND a.renew_no   = p_renew_no
               AND a.policy_id  = b.policy_id 
               AND b.dist_flag  = v_dist_param
               AND b.negate_date is null
               AND a.pol_flag in ('1','2','3', 'X')
               AND NOT EXISTS   (SELECT c.policy_id
                                   FROM gipi_endttext c
                                  WHERE c.endt_tax = 'Y'
                                    AND c.policy_id = a.policy_id)
        )LOOP
            v_hdr_sw := 'N';
            FOR a IN(
                SELECT c110.dist_no, c110.dist_seq_no
                  FROM giuw_policyds c110
                 WHERE c110.dist_no = get_dist.dist_no
            )LOOP
                v_hdr_sw := 'Y';
                v_dtl_sw := 'N';
                
                FOR b IN(
                    SELECT    '1'
                      FROM    giuw_policyds_dtl c130
                     WHERE    c130.dist_no = a.dist_no
                       AND    c130.dist_seq_no = a.dist_seq_no
                )LOOP
                    v_dtl_sw := 'Y';
                    EXIT;
                END LOOP;    
                
                IF v_dtl_sw = 'N' THEN
                    EXIT;
                END IF;
            END LOOP;
            
            IF v_hdr_sw = 'N' or v_dtl_sw = 'N' THEN
                p_proceed := 'N';
                p_message := 'There was an error encountered in Distribution Number '||to_char(get_dist.dist_no)
                 ||'. Records in some tables are missing.' 
                 ||'Setting up of reserve is not allowed for claim with errors in policy/endorsement distribution.';
                EXIT;
            ELSE
                FOR item IN(
                    SELECT b340.item_no
                      FROM gipi_item b340
                     WHERE b340.policy_id = get_dist.policy_id
                       AND EXISTS (SELECT '1'
                                     FROM gipi_itmperil b380
                                    WHERE b380.policy_id = b340.policy_id
                                      AND b380.item_no = b340.item_no)
                )LOOP
                    v_hdr_sw := 'N';
                    
                    FOR a IN(
                        SELECT c140.dist_no, c140.dist_seq_no
                          FROM giuw_itemds c140
                         WHERE c140.dist_no = get_dist.dist_no
                           AND c140.item_no = item.item_no 
                    )LOOP 
                        v_hdr_sw := 'Y';
                        v_dtl_sw := 'N';
                        
                        FOR b IN(
                            SELECT '1'
                              FROM giuw_itemds_dtl c050
                             WHERE c050.dist_no = a.dist_no
                               AND c050.dist_seq_no = a.dist_seq_no
                               AND c050.item_no = item.item_no
                        )LOOP
                            v_dtl_sw := 'Y';
                            EXIT;
                        END LOOP;
                        IF v_dtl_sw = 'N' THEN
                           EXIT;
                        END IF;
                        IF v_hdr_sw = 'N' THEN
                           EXIT;
                        END IF;                        
                    END LOOP;
                END LOOP;                                        
                IF v_hdr_sw = 'N' OR v_dtl_sw = 'N' THEN
                    p_message := 'There was an error encountered in Distribution Number '||to_char(get_dist.dist_no)
                                      ||'. Records in some tables are missing.' 
                                      ||'Setting up of reserve is not allowed for claim with errors in policy/endorsement distribution.';
                                      
                    p_proceed := 'N';
                    EXIT;
                ELSE
                    FOR perl IN (
                      SELECT b380.item_no, b380.peril_cd
                        FROM gipi_itmperil b380
                       WHERE b380.policy_id = get_dist.policy_id
                    )LOOP
                        v_hdr_sw := 'N';
                        FOR a IN (
                            SELECT c060.dist_no, c060.dist_seq_no, c060.item_no, c060.peril_cd
                              FROM giuw_itemperilds c060
                             WHERE c060.dist_no = get_dist.dist_no
                               AND c060.item_no = perl.item_no
                               AND c060.peril_cd = perl.peril_cd)
                         LOOP
                             v_hdr_sw := 'Y';
                             v_dtl_sw := 'N';
                             FOR b IN (
                               SELECT '1'
                                 FROM giuw_itemperilds_dtl c070
                                WHERE c070.dist_no = a.dist_no
                                  AND c070.dist_seq_no = a.dist_seq_no
                                  AND c070.item_no = a.item_no
                                  AND c070.peril_cd = a.peril_cd)
                             LOOP
                                v_dtl_sw := 'Y';
                                EXIT;
                             END LOOP;
                                
                             IF v_dtl_sw = 'N' THEN
                                EXIT;
                             END IF;    
                         END LOOP;
                         IF v_hdr_sw = 'N' THEN
                             EXIT;
                         END IF;
                    END LOOP; 
                         
                    IF v_hdr_sw = 'N' or v_dtl_sw = 'N' THEN
                        p_message := 'There was an error encountered in Distribution Number '||to_char(get_dist.dist_no)
                                        ||'. Records in some tables are missing.' 
                                        ||'Setting up of reserve is not allowed for claim with errors in policy/endorsement distribution.';
                        -- call_form ('GICLS010',HIDE);
                        p_call_module := 'GICLS010';
                        p_proceed := 'N';
                        EXIT;
                    ELSE
                        FOR perl IN (
                            SELECT DISTINCT c060.peril_cd peril_cd, c060.dist_seq_no
                              FROM giuw_itemperilds c060
                             WHERE c060.dist_no = get_dist.dist_no)             
                        LOOP
                            v_hdr_sw := 'N';
                            FOR a IN (
                                   SELECT c090.dist_no, c090.dist_seq_no, c090.peril_cd
                                     FROM giuw_perilds c090
                                    WHERE c090.dist_no = get_dist.dist_no
                                      AND c090.dist_seq_no = perl.dist_seq_no
                                      AND c090.peril_cd = perl.peril_cd)
                             LOOP
                                v_hdr_sw := 'Y';
                                v_dtl_sw := 'N';
                                FOR b IN (
                                    SELECT '1'
                                      FROM giuw_perilds_dtl c100
                                     WHERE c100.dist_no = a.dist_no
                                       AND c100.dist_seq_no = a.dist_seq_no
                                       AND c100.peril_cd = a.peril_cd)
                                LOOP
                                    v_dtl_sw := 'Y';
                                    EXIT;
                                END LOOP;
                                IF v_dtl_sw = 'N' THEN
                                    EXIT;
                                END IF;
                             END LOOP;
                             IF v_hdr_sw = 'N' THEN
                                EXIT;
                             END IF;
                        END LOOP;
                        
                        IF v_hdr_sw = 'N' or v_dtl_sw = 'N' THEN
                            p_message := 'There was an error encountered in Distribution Number '||to_char(get_dist.dist_no)
                                            ||'. Records in some tables are missing.' 
                                            ||'Setting up of reserve is not allowed for claim with errors in policy/endorsement distribution.';
                            p_call_module := 'GICLS010';
                            p_proceed := 'N';
                            EXIT;
                        END IF;
                    END IF;  
                END IF;
              END IF;
        END LOOP;
    END validate_existing_dist;
     
    PROCEDURE init_claim_reserve1(
        p_claim_id IN gicl_claims.claim_id%TYPE,
        p_item_no   IN gicl_clm_reserve.item_no%TYPE,
        p_peril_cd  IN gicl_clm_reserve.peril_cd%TYPE,
        p_grouped_item_no IN gicl_clm_reserve.grouped_item_no%TYPE,
        p_line_cd_ac OUT giis_parameters.param_value_v%TYPE, 
        p_line_cd_ca OUT giis_parameters.param_value_v%TYPE,
        p_claim_number OUT VARCHAR2,
        p_policy_number OUT VARCHAR2,
        p_line_cd OUT gicl_claims.line_cd%TYPE,
        p_dsp_loss_date OUT gicl_claims.dsp_loss_date%TYPE,
        p_loss_date OUT gicl_claims.loss_date%TYPE,
        p_assured_name OUT gicl_claims.assured_name%TYPE,
        p_loss_category OUT VARCHAR2,
        p_subline_cd OUT gicl_claims.subline_cd%TYPE,
        p_pol_iss_cd OUT gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy OUT gicl_claims.issue_yy%TYPE,
        p_pol_seq_no OUT gicl_claims.pol_seq_no%TYPE,
        p_renew_no OUT gicl_claims.renew_no%TYPE,
        p_iss_cd OUT gicl_claims.iss_cd%TYPE,
        p_pol_eff_date OUT gicl_claims.pol_eff_date%TYPE,
        p_expiry_date OUT gicl_claims.expiry_date%TYPE,
        p_clm_file_date OUT gicl_claims.clm_file_date%TYPE,
        p_clm_stat_desc OUT giis_clm_stat.clm_stat_desc%TYPE,
        p_catastrophic_cd OUT gicl_claims.catastrophic_cd%TYPE,
        p_claim_yy OUT gicl_claims.clm_yy%TYPE,
        p_exist OUT VARCHAR2,
        p_show_reserve_history_btn OUT VARCHAR2,
        p_show_payment_history_btn OUT VARCHAR2
    )IS
        v_grouped_item_no gicl_clm_res_hist.grouped_item_no%TYPE;
    BEGIN
        FOR i IN (SELECT param_value_v FROM giis_parameters WHERE param_name LIKE 'LINE_CODE_AC')
        LOOP
            p_line_cd_ac := i.param_value_v; 
        END LOOP;
        
        FOR i IN (SELECT param_value_v FROM giis_parameters WHERE param_name LIKE 'LINE_CODE_CA')
        LOOP
            p_line_cd_ca := i.param_value_v;
        END LOOP;
        
        SELECT a.line_cd ||'-' || subline_cd ||'-'|| iss_cd ||'-'|| LTRIM(to_char(clm_yy,'00')) || '-' || LTRIM(to_char(clm_seq_no,'0000009')),
               a.line_cd ||'-' || subline_cd ||'-'|| pol_iss_cd ||'-'|| LTRIM(to_char(issue_yy,'00')) ||'-'|| LTRIM(to_char(pol_seq_no,'0000009'))  ||'-'|| LTRIM(to_char(renew_no,'00')),
               a.line_cd, a.dsp_loss_date, a.loss_date, assured_name, 
               b.loss_cat_cd ||'-'|| b.loss_cat_des, a.subline_cd, a.pol_iss_cd, 
               a.issue_yy, a.pol_seq_no, a.renew_no, 
               a.iss_cd, a.pol_eff_date, a.expiry_date, 
               a.clm_file_date, c.clm_stat_desc, a.catastrophic_cd,
               a.clm_yy
         INTO p_claim_number, 
             p_policy_number,   p_line_cd,        p_dsp_loss_date,   p_loss_date, 
             p_assured_name,    p_loss_category,  p_subline_cd,      p_pol_iss_cd, 
             p_issue_yy,        p_pol_seq_no,      p_renew_no, 
             p_iss_cd,          p_pol_eff_date,   p_expiry_date,     p_clm_file_date, 
             p_clm_stat_desc,   p_catastrophic_cd,p_claim_yy
         FROM gicl_claims a, giis_loss_ctgry b, giis_clm_stat c
        WHERE a.loss_cat_cd = b.loss_cat_cd
          AND a.line_cd = b.line_cd
          AND a.claim_id = p_claim_id
          AND c.clm_stat_cd = a.clm_stat_cd;
        
        p_exist := 'N';
        FOR chk_distribution IN(
            SELECT '1'
              FROM gicl_clm_reserve
             WHERE claim_id = p_claim_id)
        LOOP
            p_exist := 'Y';
        END LOOP;
          
        p_show_reserve_history_btn := 'N';
        FOR chk IN(SELECT 'Y'
               FROM gicl_clm_res_hist
              WHERE claim_id     = p_claim_id
                AND item_no      = p_item_no
                AND peril_cd     = p_peril_cd
                AND grouped_item_no = p_grouped_item_no 
                AND (NVL(loss_reserve, 0) != 0 
                  OR NVL(expense_reserve, 0) != 0))
      LOOP
        p_show_reserve_history_btn := 'Y';
        EXIT;
      END LOOP;
      
      p_show_payment_history_btn := 'N';
      
      FOR chk IN(SELECT 'Y'
               FROM gicl_clm_res_hist
              WHERE claim_id     = p_claim_id
                AND item_no      = p_item_no
                AND grouped_item_no = p_grouped_item_no
                AND peril_cd     = p_peril_cd
                AND (NVL(losses_paid, 0) != 0
                  OR NVL(expenses_paid, 0) != 0))
      LOOP
        p_show_payment_history_btn := 'Y';
        EXIT;
      END LOOP;
      
    END init_claim_reserve1;
 
    FUNCTION get_gicl_clm_res(
        p_claim_id          gicl_clm_reserve.claim_id%TYPE
    ) RETURN clm_res_type IS
        v_clm_res   clm_res_type;
    BEGIN 
        FOR i IN (SELECT *
                    FROM gicl_clm_reserve
                   WHERE claim_id = TO_NUMBER(p_claim_id)
        )LOOP
            v_clm_res.claim_id          := i.claim_id;
            v_clm_res.item_no           := i.item_no;
            v_clm_res.peril_cd          := i.peril_cd;
            v_clm_res.loss_reserve      := i.loss_reserve;
            v_clm_res.losses_paid       := i.losses_paid;
            v_clm_res.expense_reserve   := i.expense_reserve;
            v_clm_res.expenses_paid     := i.expenses_paid;
            v_clm_res.currency_cd       := i.currency_cd;
            v_clm_res.convert_rate      := i.convert_rate;
            v_clm_res.net_pd_loss       := i.net_pd_loss;
            v_clm_res.net_pd_exp        := i.net_pd_exp;
            v_clm_res.grouped_item_no   := i.grouped_item_no;
            v_clm_res.redist_sw         := i.redist_sw; 
            EXIT;
        END LOOP;
        RETURN v_clm_res;
    END;
    
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 03.15.2012
   **  Reference By  : (GICLS025 - Recovery Information) 
   **  Description   : Get recoverable list 
   */        
    FUNCTION get_recoverable_details(
        p_claim_id          gicl_clm_reserve.claim_id%TYPE,
        p_line_cd           gicl_claims.line_cd%TYPE,
        p_recovery_id       gicl_clm_recovery_dtl.recovery_id%TYPE
        )
    RETURN recoverable_details_tab PIPELINED IS
      v_list        recoverable_details_type;
    BEGIN
        FOR i IN (SELECT a.claim_id, a.item_no, a.peril_cd, a.loss_reserve, a.expense_reserve
                    FROM gicl_clm_reserve a, gicl_item_peril b
                   WHERE a.claim_id = b.claim_id
                     AND a.item_no = b.item_no
                     AND a.peril_cd = b.peril_cd
                     AND a.grouped_item_no = b.grouped_item_no
                     AND (NVL (a.expense_reserve, 0) + NVL (a.loss_reserve, 0)) > 0
                     AND (   (b.close_flag = NULL OR b.close_flag IN ('AP', 'CP', 'CC'))
                          OR (b.close_flag2 = NULL OR b.close_flag2 IN ('AP', 'CP', 'CC'))
                         )
                     AND (  DECODE (NVL (close_flag, 'AP'),
                                    'AP', NVL (loss_reserve, 0),
                                    'CP', NVL (loss_reserve, 0),
                                    'CC', NVL (loss_reserve, 0),
                                    0
                                   )
                          + DECODE (NVL (close_flag2, 'AP'),
                                    'AP', NVL (expense_reserve, 0),
                                    'CP', NVL (expense_reserve, 0),
                                    'CC', NVL (expense_reserve, 0),
                                    0
                                   ) > 0
                         )
                     AND a.claim_id = p_claim_id)
        LOOP
            v_list.claim_id                 := i.claim_id;
            v_list.item_no                  := i.item_no;
            v_list.peril_cd                 := i.peril_cd;
            v_list.loss_reserve             := i.loss_reserve;   
            v_list.expense_reserve          := i.expense_reserve;
            v_list.dsp_item_desc            := NULL;
            v_list.dsp_peril_desc           := NULL;
            v_list.nbt_paid_amt             := NULL;
            v_list.clm_loss_id              := NULL;
            v_list.hist_seq_no              := NULL;
            v_list.chk_choose               := NULL;   
            v_list.nbt_ann_tsi_amt          := NULL;
            v_list.orig_nbt_paid_amt        := NULL; -- added by apollo cruz 07.10.2015
            
            FOR item IN (SELECT item_title
                         FROM gicl_clm_item
                        WHERE claim_id = p_claim_id
                          AND item_no  = i.item_no)
            LOOP
              v_list.dsp_item_desc := item.item_title;
            END LOOP;
              
            FOR peril IN (SELECT peril_sname
                          FROM giis_peril
                         WHERE line_cd  = p_line_cd
                           AND peril_cd = i.peril_cd)
            LOOP
              v_list.dsp_peril_desc := peril.peril_sname;
              v_list.nbt_paid_amt   := 0;
            END LOOP;
              
            FOR x IN (SELECT clm_loss_id, hist_seq_no
                                FROM gicl_clm_loss_exp
                             WHERE claim_id = p_claim_id
                               AND item_no  = i.item_no
                       AND peril_cd = i.peril_cd)
            LOOP
              v_list.clm_loss_id := x.clm_loss_id;
              v_list.hist_seq_no := x.hist_seq_no; 
            END LOOP;
              
            FOR chk IN (SELECT recoverable_amt -- added by apollo cruz 07.10.2015 UCPB SR 19584 changed 1 to recoverable_amt 
                        FROM gicl_clm_recovery_dtl
                       WHERE claim_id = p_claim_id
                         AND recovery_id = p_recovery_id
                         AND item_no = i.item_no
                         AND peril_cd = i.peril_cd)
                         --AND clm_loss_id = :recoverable2.clm_loss_id)
            LOOP
              v_list.chk_choose := 'Y';
              
              -- added by apollo cruz 07.10.2015 UCPB SR 19584
              -- gicl_clm_recovery_dtl.recoverable_amt must be displayed
              -- instead of amounts from gicl_clm_res_hist if record exists in gicl_clm_recovery_dtl
              v_list.nbt_paid_amt := chk.recoverable_amt;    
            END LOOP;
              
            FOR x IN (SELECT ann_tsi_amt
                                FROM gicl_item_peril
                             WHERE claim_id = p_claim_id
                               AND item_no  = i.item_no
                               AND peril_cd = i.peril_cd)
            LOOP
             v_list.nbt_ann_tsi_amt := x.ann_tsi_amt;
            END LOOP;
            
            FOR amt IN (SELECT (decode(NVL(close_flag2,'AP'),'AP',NVL(expense_reserve,0),'CP',NVL(expense_reserve,0),'CC',NVL(expense_reserve,0),0) + 
                                                decode(NVL(close_flag,'AP'),'AP',NVL(loss_reserve,0),'CP',NVL(loss_reserve,0),'CC',NVL(loss_reserve,0),0)) amount
                                  FROM gicl_clm_res_hist a,
                                       gicl_item_peril b
                                 WHERE a.claim_id = p_claim_id
                                   AND a.item_no  = i.item_no--ramon, 022009
                                   AND a.peril_cd = i.peril_cd--ramon, 022009 
                                   AND NVL(dist_sw,'N') = 'Y'
                                   AND b.claim_id = a.claim_id
                                   AND b.item_no = a.item_no
                                   AND b.grouped_item_no = a.grouped_item_no
                                   AND b.peril_cd = a.peril_cd)
            LOOP
              -- added by apollo cruz 07.10.2015 UCPB SR 19584 
              IF NVL(v_list.chk_choose, 'N') = 'N' THEN
                 v_list.nbt_paid_amt := NVL(amt.amount,0);
              END IF;
                     
              v_list.orig_nbt_paid_amt := NVL(amt.amount,0);
            END LOOP;
            
            PIPE ROW(v_list);
        END LOOP;
      RETURN;    
    END;
    
    /*
    **  Created by    : Udel Dela Cruz Jr. 
    **  Date Created  : 04.11.2012
    **  Reference By  : (GICLS024 - Claim Reserve) 
    **  Description   : Get availments
    */
    FUNCTION get_availments(
        p_line_cd           gicl_claims.line_cd%TYPE,
        p_subline_cd        gicl_claims.subline_cd%TYPE,
        p_iss_cd            gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy          gicl_claims.issue_yy%TYPE,
        p_pol_seq_no        gicl_claims.pol_seq_no%TYPE,
        p_renew_no          gicl_claims.renew_no%TYPE,
        p_peril_cd          gicl_clm_reserve.peril_cd%TYPE,
        p_no_of_days        gicl_item_peril.no_of_days%TYPE
    ) RETURN availments_tab PIPELINED IS
        v_list      availments_type;
    BEGIN
        FOR rec IN (SELECT   a.claim_id, a.loss_date, a.clm_stat_cd, e.clm_stat_desc, b.loss_reserve,
                             SUM (c.paid_amt) paid_amt, SUM (d.no_of_units) no_of_units,
                             b.peril_cd, a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||TO_CHAR(a.clm_yy,'00')||'-'||
                                TO_CHAR(a.clm_seq_no,'0000000')||'-'||TO_CHAR(a.renew_no,'00') claim_no
                      FROM gicl_claims a,
                           gicl_clm_reserve b,
                           gicl_clm_loss_exp c,
                           gicl_loss_exp_dtl d,
                           giis_clm_stat e
                     WHERE a.claim_id       = b.claim_id
                       AND b.claim_id       = c.claim_id
                       AND b.item_no        = c.item_no
                       AND b.peril_cd       = c.peril_cd
                       AND c.claim_id       = d.claim_id
                       AND c.clm_loss_id    = d.clm_loss_id
                       AND e.clm_stat_cd    = a.clm_stat_cd
                       AND a.line_cd        = p_line_cd
                       AND a.subline_cd     = p_subline_cd
                       AND a.pol_iss_cd     = p_iss_cd
                       AND a.issue_yy       = p_issue_yy
                       AND a.pol_seq_no     = p_pol_seq_no
                       AND a.renew_no       = p_renew_no
                       AND b.peril_cd       = p_peril_cd
                       AND NVL (c.cancel_sw, 'N')   = 'N'
                       AND NVL (c.dist_sw, 'N')     = 'Y'
                  GROUP BY a.claim_id,
                           a.loss_date,
                           a.clm_stat_cd,
                           b.loss_reserve,
                           b.peril_cd,
                           a.line_cd,
                           a.subline_cd,
                           a.pol_iss_cd,
                           a.issue_yy,
                           a.pol_seq_no,
                           a.renew_no,
                           a.iss_cd,
                           a.clm_yy,
                           a.clm_seq_no,
                           e.clm_stat_desc)
        LOOP
            v_list.claim_id         := rec.claim_id;
            v_list.loss_date        := rec.loss_date;
            v_list.clm_stat_cd      := rec.clm_stat_cd;
            v_list.clm_stat_desc    := rec.clm_stat_desc;
            v_list.loss_reserve     := rec.loss_reserve;
            v_list.paid_amt         := rec.paid_amt;
            v_list.peril_cd         := rec.peril_cd;
            v_list.claim_no         := rec.claim_no;
            
            IF NVL(p_no_of_days, 0) != 0 THEN
                v_list.no_of_units  := rec.no_of_units;
            ELSE
                v_list.no_of_units  := 0;
            END IF;
            
            PIPE ROW(v_list);
        END LOOP;
    
    END get_availments;
   
   
    PROCEDURE check_uw_dist_gicls024 (
        p_line_cd       IN  GICL_CLAIMS.line_cd%TYPE,
        p_subline_cd    IN  GICL_CLAIMS.subline_cd%TYPE,
        p_pol_iss_cd    IN  GICL_CLAIMS.pol_iss_cd%TYPE,
        p_issue_yy      IN  GICL_CLAIMS.issue_yy%TYPE,
        p_pol_seq_no    IN  GICL_CLAIMS.pol_seq_no%TYPE,
        p_renew_no      IN  GICL_CLAIMS.renew_no%TYPE,
        p_eff_date      IN  GICL_CLAIMS.pol_eff_date%TYPE,
        p_expiry_date   IN  GICL_CLAIMS.expiry_date%TYPE,
        p_loss_date     IN  GICL_CLAIMS.loss_date%TYPE,
        p_c007_peril_cd IN  GICL_ITEM_PERIL.peril_cd%TYPE,
        p_c007_item_no  IN  GICL_ITEM_PERIL.item_no%TYPE,
        p_message       OUT VARCHAR2
    ) IS
        v_ann_dist_tsi NUMBER:=0;
        v_pol_tsi NUMBER:=0;
        v_pol_flag VARCHAR2(1); --kenneth SR 4855 100715
      
        CURSOR cur_perilds(v_peril_cd giri_ri_dist_item_v.peril_cd%type,
                           v_item_no  giri_ri_dist_item_v.item_no%type) IS
        SELECT d.share_cd, f.share_type, f.trty_yy,f.prtfolio_sw,
               f.acct_trty_type, SUM(d.dist_tsi) ann_dist_tsi,
               f.expiry_date
          FROM gipi_polbasic a, gipi_item b,
               giuw_pol_dist c, giuw_itemperilds_dtl d,
               giis_dist_share f, giis_parameters e
         WHERE f.share_cd   = d.share_cd
           AND f.line_cd    = d.line_cd
           AND d.peril_cd   = v_peril_cd
           AND d.item_no    = v_item_no
           AND d.item_no    = b.item_no
           AND d.dist_no    = c.dist_no
           AND e.param_type = 'V'
           AND c.dist_flag  = e.param_value_v
           AND e.param_name = 'DISTRIBUTED'
           AND c.policy_id  = b.policy_id
           AND trunc(DECODE(TRUNC(c.eff_date),TRUNC(a.eff_date),
               DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_eff_date, a.eff_date ),c.eff_date)) 
                <= p_loss_date 
           AND trunc(DECODE(TRUNC(c.expiry_date),TRUNC(a.expiry_date),DECODE(NVL(a.endt_expiry_date, a.expiry_date),
               a.expiry_date,p_expiry_date,a.endt_expiry_date),c.expiry_date))  
               >= p_loss_date
           AND b.policy_id  = a.policy_id
           AND a.pol_flag   IN ('1','2','3','X')
           AND a.line_cd    = p_line_cd
           AND a.subline_cd = p_subline_cd
           AND a.iss_cd     = p_pol_iss_cd
           AND a.issue_yy   = p_issue_yy
           AND a.pol_seq_no = p_pol_seq_no
           AND a.renew_no   = p_renew_no
         GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
               a.pol_seq_no, a.renew_no, d.share_cd, f.share_type, 
               f.trty_yy, f.acct_trty_type, d.item_no, d.peril_cd,f.prtfolio_sw,
               f.expiry_date; 
               
        CURSOR cur_pol_tsi (v_peril_cd giri_ri_dist_item_v.peril_cd%type,
                            v_item_no  giri_ri_dist_item_v.item_no%type) IS
              SELECT SUM(a.tsi_amt) TSI_AMT
                FROM giri_basic_info_item_sum_v a, giuw_pol_dist b
               WHERE a.policy_id  = b.policy_id
                 AND trunc(DECODE(TRUNC(b.eff_date),TRUNC(a.eff_date),
                     DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_eff_date, a.eff_date ),b.eff_date)) 
                     <= p_loss_date 
                 AND TRUNC(DECODE(TRUNC(b.expiry_date),TRUNC(a.expiry_date),
                     DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                     a.expiry_date,p_expiry_date,a.endt_expiry_date ),b.expiry_date)) 
                     >= p_loss_date
                 AND a.item_no    = v_item_no
                 AND a.peril_cd   = v_peril_cd
                 AND a.line_cd    = p_line_cd
                 AND a.subline_cd = p_subline_cd
                 AND a.iss_cd     = p_pol_iss_cd
                 AND a.issue_yy   = p_issue_yy
                 AND a.pol_seq_no = p_pol_seq_no
                 AND a.renew_no   = p_renew_no
                 AND b.dist_flag  = (SELECT param_value_v
                                       FROM giis_parameters
                                      WHERE param_name = 'DISTRIBUTED');  
                                      
        --start kenneth SR 4855 100715
        CURSOR cur_perilds_cncl(v_peril_cd giri_ri_dist_item_v.peril_cd%type,
                           v_item_no  giri_ri_dist_item_v.item_no%type) IS
        SELECT d.share_cd, f.share_type, f.trty_yy,f.prtfolio_sw,
               f.acct_trty_type, SUM(d.dist_tsi) ann_dist_tsi,
               f.expiry_date
          FROM gipi_polbasic a, gipi_item b,
               giuw_pol_dist c, giuw_itemperilds_dtl d,
               giis_dist_share f, giis_parameters e
         WHERE f.share_cd   = d.share_cd
           AND f.line_cd    = d.line_cd
           AND d.peril_cd   = v_peril_cd
           AND d.item_no    = v_item_no
           AND d.item_no    = b.item_no
           AND d.dist_no    = c.dist_no
           AND e.param_type = 'V'
           AND c.dist_flag  = e.param_value_v
           AND e.param_name = 'DISTRIBUTED'
           AND c.policy_id  = b.policy_id
           AND trunc(DECODE(TRUNC(c.eff_date),TRUNC(a.eff_date),
               DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_eff_date, a.eff_date ),c.eff_date)) 
                <= p_loss_date 
           AND trunc(DECODE(TRUNC(c.expiry_date),TRUNC(a.expiry_date),DECODE(NVL(a.endt_expiry_date, a.expiry_date),
               a.expiry_date,p_expiry_date,a.endt_expiry_date),c.expiry_date))  
               >= p_loss_date
           AND b.policy_id  = a.policy_id
           AND a.pol_flag   IN ('1','2','3','4','X')
           AND a.line_cd    = p_line_cd
           AND a.subline_cd = p_subline_cd
           AND a.iss_cd     = p_pol_iss_cd
           AND a.issue_yy   = p_issue_yy
           AND a.pol_seq_no = p_pol_seq_no
           AND a.renew_no   = p_renew_no
         GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
               a.pol_seq_no, a.renew_no, d.share_cd, f.share_type, 
               f.trty_yy, f.acct_trty_type, d.item_no, d.peril_cd,f.prtfolio_sw,
               f.expiry_date; 
               
        CURSOR cur_pol_tsi_cncl (v_peril_cd giri_ri_dist_item_v.peril_cd%type,
                            v_item_no  giri_ri_dist_item_v.item_no%type) IS
              SELECT SUM(a.tsi_amt) TSI_AMT
                FROM giri_basic_info_sum_cncl_v a, giuw_pol_dist b
               WHERE a.policy_id  = b.policy_id
                 AND trunc(DECODE(TRUNC(b.eff_date),TRUNC(a.eff_date),
                     DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_eff_date, a.eff_date ),b.eff_date)) 
                     <= p_loss_date 
                 AND TRUNC(DECODE(TRUNC(b.expiry_date),TRUNC(a.expiry_date),
                     DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                     a.expiry_date,p_expiry_date,a.endt_expiry_date ),b.expiry_date)) 
                     >= p_loss_date
                 AND a.item_no    = v_item_no
                 AND a.peril_cd   = v_peril_cd
                 AND a.line_cd    = p_line_cd
                 AND a.subline_cd = p_subline_cd
                 AND a.iss_cd     = p_pol_iss_cd
                 AND a.issue_yy   = p_issue_yy
                 AND a.pol_seq_no = p_pol_seq_no
                 AND a.renew_no   = p_renew_no
                 AND b.dist_flag  = (SELECT param_value_v
                                       FROM giis_parameters
                                      WHERE param_name = 'DISTRIBUTED');              

    BEGIN
         FOR x IN (SELECT pol_flag
                                FROM gipi_polbasic a
                               WHERE a.line_cd = p_line_cd
                                 AND a.subline_cd = p_subline_cd
                                 AND a.iss_cd = p_pol_iss_cd
                                 AND a.issue_yy = p_issue_yy
                                 AND a.pol_seq_no = p_pol_seq_no
                                 AND a.renew_no = p_renew_no
                                 AND a.endt_seq_no = (SELECT MAX (b.endt_seq_no) endt_seq_no
                                                        FROM gipi_polbasic b
                                                       WHERE b.line_cd = p_line_cd
                                                         AND b.subline_cd = p_subline_cd
                                                         AND b.iss_cd = p_pol_iss_cd
                                                         AND b.issue_yy = p_issue_yy
                                                         AND b.pol_seq_no = p_pol_seq_no
                                                         AND b.renew_no = p_renew_no))
        LOOP
            v_pol_flag := x.pol_flag;
            EXIT;
        END LOOP;
        
        p_message := 'SUCCESS';
        
        IF v_pol_flag = 4
        THEN
            FOR GET_ANN_DIST_TSI in cur_perilds_cncl(p_c007_peril_cd,p_c007_item_no) LOOP
                v_ann_dist_tsi:=v_ann_dist_tsi+GET_ANN_DIST_TSI.ann_dist_tsi;
            END LOOP;

            FOR GET_pol_TSI in cur_pOL_TSI_cncl(p_c007_peril_cd,p_c007_item_no) LOOP
                v_pol_tsi:=v_pol_tsi+GET_pol_TSI.TSI_AMT;
            END LOOP;
        ELSE
            FOR GET_ANN_DIST_TSI in cur_perilds(p_c007_peril_cd,p_c007_item_no) LOOP
                v_ann_dist_tsi:=v_ann_dist_tsi+GET_ANN_DIST_TSI.ann_dist_tsi;
            END LOOP;

            FOR GET_pol_TSI in cur_pOL_TSI(p_c007_peril_cd,p_c007_item_no) LOOP
                v_pol_tsi:=v_pol_tsi+GET_pol_TSI.TSI_AMT;
            END LOOP;
        END IF;
        --end kenneth SR 4855 100715
        
        IF v_ann_dist_tsi/v_pol_tsi = 1 THEN
            NULL; 
        ELSE 
            p_message := 'Please check UW distribution of this claim''s policy.';
        END IF;	

    END check_uw_dist_gicls024;   
    
    
    PROCEDURE redistribute_reserve(
        p_claim_id              IN GICL_CLAIMS.claim_id%TYPE,
        p_item_no               IN GICL_ITEM_PERIL.item_no%TYPE,
        p_peril_cd              IN GICL_ITEM_PERIL.peril_cd%TYPE,
        p_grouped_item_no       IN GICL_ITEM_PERIL.grouped_item_no%TYPE,
        p_distribution_date     IN GICL_CLM_RES_HIST.distribution_date%TYPE,  
        p_loss_reserve          IN GICL_CLM_RESERVE.LOSS_RESERVE%type,
        p_expense_reserve       IN GICL_CLM_RESERVE.expense_RESERVE%type,
        p_line_cd               IN GICL_CLAIMS.line_cd%TYPE,
        p_hist_seq_no           IN gicl_clm_res_hist.hist_seq_no%TYPE,
        p_clm_res_hist_id       IN gicl_clm_res_hist.clm_res_hist_id%TYPE,  --added by Halley 09.20.2013
        p_message               OUT VARCHAR2
    ) IS
        ctr	     NUMBER  := 0;
        chk_dist NUMBER  := 0;
        v_hist_seq_no  	gicl_clm_res_hist.hist_seq_no%TYPE := 1;
    BEGIN
        --commit_c022; 
        /*create_new_reserve (p_claim_id,
                             p_item_no,
                             p_peril_cd,
                             p_grouped_item_no,
                             p_distribution_date,
                             p_loss_reserve,
                             p_expense_reserve
                            );
         update_clm_dist_tag(p_claim_id);*/
         
        /* FOR hist IN
            (SELECT NVL(MAX(NVL(hist_seq_no,0)),0) seq_no
               FROM gicl_clm_res_hist
               WHERE claim_id = p_claim_id
                 AND item_no  = p_item_no
                 AND peril_cd = p_peril_cd
                 AND grouped_item_no = p_grouped_item_no) 
          LOOP
            v_hist_seq_no := hist.seq_no;
            EXIT;
          END LOOP;*/
        --
        FOR i IN (SELECT 'X'
                    FROM gicl_reserve_ds
                   WHERE line_cd  =  p_line_cd
                     AND claim_id =  p_claim_id
                     AND share_type in (2,3,4))  --added share_type 4 by Halley 09.20.2013
        LOOP
            ctr := ctr + 1;
        END LOOP;
        
        FOR i IN (SELECT 'X'
                 FROM gicl_reserve_ds
		            WHERE line_cd  =  p_line_cd
                  AND claim_id = p_claim_id
                  AND clm_res_hist_id = p_clm_res_hist_id) --replaced from p_hist_seq_no to p_clm_res_hist_id by Halley 09.20.2013
        LOOP
            chk_dist := chk_dist + 1; -- adrel check if redistribution is successful
        END LOOP;
               
        IF chk_dist >= 1 THEN       
            IF ctr > 1 or ctr = 1 THEN
                p_message := 'Reserve has now been redistributed. Please generate and print Preliminary Loss Advise.';
            ELSE
                p_message := 'Reserve has now been redistributed.';
            END IF;
        ELSE
            p_message := 'Distribution was not successful.';     	
        END IF;
        
        UPDATE GICL_CLM_RESERVE
     	   SET REDIST_SW = ''
     	 WHERE CLAIM_ID = p_claim_id
     	   AND ITEM_NO = p_item_no
     	   AND PERIL_CD = p_peril_cd;
    END redistribute_reserve;
    
    
    PROCEDURE checkOverrideGICLS024(
        p_user              IN VARCHAR2,
        p_loss_reserve      IN NUMBER,
        p_line_cd           IN VARCHAR2,
        p_iss_cd            IN VARCHAR2,
        p_message           OUT VARCHAR2
    ) IS
        pwd       VARCHAR2(500);
        sid       VARCHAR2(500);
        validFlag BOOLEAN;
        all_res_sw VARCHAR2(1);
        res_amt 				 gicl_adv_line_amt.res_range_to%TYPE;
    BEGIN
        IF check_user_override_function2(p_user, 'GICLS024','RO') = 'FALSE' THEN --robert 07.25.2012
            BEGIN
                SELECT NVL(all_res_amt_sw,'N')
                  INTO all_res_sw
                  FROM gicl_adv_line_amt
                 WHERE adv_user = p_user
                   AND line_cd = p_line_cd
                   AND iss_cd  = p_iss_cd;
                     --close override..
                IF all_res_sw = 'N' THEN
                     SELECT NVL(res_range_to,0)
                       INTO res_amt
                       FROM gicl_adv_line_amt	
                      WHERE adv_user = p_user
                        AND line_cd = p_line_cd
                        AND iss_cd  = p_iss_cd;
                					  
                       IF p_loss_reserve > res_amt THEN
                          p_message := upper(p_user)||' is not allowed to override';
                       END IF;	  
                END IF;
            EXCEPTION
                WHEN no_data_found THEN
                   p_message := 'User is not allowed to make a reserve, please refer to the reserve maintenance';
            END;
        END IF;
    END checkOverrideGICLS024;
	
	FUNCTION trty_peril_exists_loc (
      v_line_cd     giis_trty_peril.line_cd%TYPE,
      v_peril_cd    giis_trty_peril.peril_cd%TYPE,
      v_loss_date   DATE,
      v_location_cd   gipi_casualty_item.location_cd%TYPE
   )RETURN BOOLEAN IS 
	BEGIN
      FOR a IN (SELECT   d.share_cd,d.line_Cd,d.peril_cd
				  FROM gipi_polbasic a, gipi_item b, gipi_casualty_item b2,
					   giuw_pol_dist c, giuw_itemperilds_dtl d, giis_dist_share e
				 WHERE b2.policy_id = b.policy_id
				   AND b2.item_no = b.item_no
				   AND d.item_no = b.item_no
				   AND d.dist_no = c.dist_no
				   AND e.line_cd=d.line_Cd
				   AND e.share_cd=d.share_cd
				   AND e.share_type = giacp.v ('TRTY_SHARE_TYPE')
				   AND c.dist_flag = giisp.v ('DISTRIBUTED')
				   AND c.policy_id = b.policy_id
				   AND a.eff_date <= v_loss_date
				   AND a.expiry_date >= v_loss_date
				   AND b.policy_id = a.policy_id
				   AND a.pol_flag IN ('1', '2', '3', 'X')
				   AND location_cd = v_location_cd          
				   AND NOT EXISTS (SELECT 1
						  FROM giis_trty_peril tp
						 WHERE tp.trty_seq_no = d.share_cd
						   AND tp.line_cd =v_line_cd
						   AND tp.peril_cd = v_peril_cd))
		  LOOP
			 RETURN (FALSE);
		  END LOOP;
		RETURN (TRUE);
	END;
	
	FUNCTION trty_peril_exists_risk (
      v_line_cd     giis_trty_peril.line_cd%TYPE,
      v_peril_cd    giis_trty_peril.peril_cd%TYPE,
      v_loss_date   DATE,
      v_risk_cd   gipi_fireitem.risk_cd%TYPE
   ) RETURN BOOLEAN
   IS
   BEGIN
      FOR a IN (SELECT   d.share_cd,d.line_Cd,d.peril_cd
          FROM gipi_polbasic a, gipi_item b, gipi_fireitem b2, giuw_pol_dist c,
               giuw_itemperilds_dtl d, giis_dist_share e
         WHERE b2.policy_id = b.policy_id
           AND b2.item_no = b.item_no
           AND d.item_no = b.item_no
           AND d.dist_no = c.dist_no
           AND  e.line_cd=d.line_Cd
           AND e.share_cd=d.share_cd
           AND e.share_type = giacp.v ('TRTY_SHARE_TYPE')
           AND c.dist_flag = giisp.v ('DISTRIBUTED')
           AND c.policy_id = b.policy_id
           AND a.eff_date <= v_loss_date
           AND a.expiry_date >= v_loss_date
           AND b.policy_id = a.policy_id
           AND a.pol_flag IN ('1', '2', '3', 'X')
           AND risk_cd = v_risk_cd          
           AND NOT EXISTS (SELECT 1
                  FROM giis_trty_peril tp
                 WHERE tp.trty_seq_no = d.share_cd
                   AND tp.line_cd =v_line_cd
                   AND tp.peril_cd = v_peril_cd))
      LOOP
         RETURN (FALSE);
      END LOOP;

      RETURN (TRUE);
   END;
	
	FUNCTION LOC_DIST_EXISTS  (
      v_location_cd   gipi_casualty_item.location_cd%TYPE,
      v_loss_date     DATE
   ) RETURN BOOLEAN IS
	BEGIN
	FOR a IN (
		  SELECT   d.share_cd, f.share_type, f.trty_yy, f.acct_trty_type,
				   f.prtfolio_sw, v_location_cd, SUM (d.dist_tsi) ann_dist_tsi,
				   f.expiry_date
			  FROM gipi_polbasic a, gipi_item b, giis_peril b3,
				   giuw_pol_dist c, giuw_itemperilds_dtl d, giis_dist_share f
			 WHERE f.share_cd = d.share_cd
			   AND b3.line_cd = a.line_cd
			   AND b3.peril_cd = d.peril_cd
			   AND b3.peril_type = 'B'
			   AND f.line_cd = d.line_cd
			   AND d.item_no = b.item_no
			   AND d.dist_no = c.dist_no
			   AND c.dist_flag = giisp.v ('DISTRIBUTED')
			   AND c.policy_id = b.policy_id
			   AND TRUNC(a.eff_date) <= TRUNC(v_loss_date)
			   AND TRUNC(a.expiry_date) >= TRUNC(v_loss_date)
			   AND b.policy_id = a.policy_id
			   AND a.pol_flag IN ('1', '2', '3', 'X')
			   AND EXISTS (
					  SELECT 1
						FROM gipi_polbasic sub_a,
							 gipi_item sub_b,
							 gipi_casualty_item sub_c
					   WHERE sub_a.line_cd = a.line_cd
						 AND sub_a.subline_cd = a.subline_cd
						 AND sub_a.iss_cd = a.iss_cd
						 AND sub_a.issue_yy = a.issue_yy
						 AND sub_a.pol_seq_no = a.pol_seq_no
						 AND sub_a.renew_no = a.renew_no
						 AND sub_b.item_no=d.item_no
						 AND TRUNC (sub_a.eff_date) <= TRUNC (v_loss_date)
						 AND TRUNC (sub_a.expiry_date) >= TRUNC (v_loss_date)
						 AND sub_c.location_cd = v_location_cd
						 AND sub_a.policy_id = sub_b.policy_id
						 AND sub_b.policy_id = sub_c.policy_id
						 AND sub_b.item_no = sub_c.item_no)            
		  GROUP BY d.share_cd,
				   f.share_type,
				   f.trty_yy,
				   f.acct_trty_type,
				   f.prtfolio_sw,
				   v_location_cd,
				   f.expiry_date) LOOP
			 RETURN (TRUE);
		  END LOOP;
		  RETURN (FALSE);               	
	END;
	
	PROCEDURE process_distribution (
		p_clm_res_hist  		IN gicl_clm_res_hist.clm_res_hist_id%TYPE,
        p_hist_seq_no   		IN gicl_clm_res_hist.hist_seq_no%TYPE,
		p_claim_id              IN gicl_claims.claim_id%TYPE,
        p_item_no               IN gicl_item_peril.item_no%TYPE,
        p_peril_cd              IN gicl_item_peril.peril_cd%TYPE,
        p_grouped_item_no       IN gicl_item_peril.grouped_item_no%TYPE)
	IS 
		v_prtf_sw     	NUMBER := 0;
		v_loss_amt		gicl_claims.loss_res_amt%TYPE;
		v_exp_amt		gicl_claims.exp_res_amt%TYPE;
		v_location_cd	gicl_casualty_dtl.location_cd%TYPE;
	BEGIN
		UPDATE gicl_reserve_ds
  		   SET negate_tag = 'Y'
	     WHERE claim_id = p_claim_id
		   AND hist_seq_no < p_hist_seq_no
		   AND item_no = p_item_no
		   AND peril_cd = p_peril_cd
		   AND grouped_item_no = p_grouped_item_no; 
	END;
	
	PROCEDURE create_new_reserve(
        p_claim_id              IN gicl_claims.claim_id%TYPE,
        p_item_no               IN gicl_item_peril.item_no%TYPE,
        p_peril_cd              IN gicl_item_peril.peril_cd%TYPE,
        p_grouped_item_no       IN gicl_item_peril.grouped_item_no%TYPE,
        p_hist_seq_no           OUT gicl_clm_res_hist.hist_seq_no%TYPE,
        p_user_id               IN gicl_claims.user_id%TYPE,
        p_loss_reserve          IN gicl_clm_reserve.loss_reserve%TYPE,
        p_exp_reserve           IN gicl_clm_reserve.expense_reserve%TYPE,
        p_booking_month         IN gicl_clm_res_hist.booking_month%TYPE,
        p_booking_year          IN gicl_clm_res_hist.booking_month%TYPE,
        p_currency_cd           IN gicl_clm_res_hist.currency_cd%TYPE,
		p_convert_rate			IN gicl_clm_res_hist.convert_rate%TYPE,
		p_dist_date				IN gicl_clm_res_hist.distribution_date%TYPE
    )IS 
        v_hist_seq_no  	gicl_clm_res_hist.hist_seq_no%TYPE := 1;     
        v_hist_seq_no_old  	gicl_clm_res_hist.hist_seq_no%TYPE := 0;
        v_clm_res_hist	gicl_clm_res_hist.clm_res_hist_id%TYPE := 1;
        v_prev_loss_res       gicl_clm_res_hist.prev_loss_res%TYPE :=0;
        v_prev_exp_res        gicl_clm_res_hist.prev_loss_res%TYPE :=0;
        v_prev_loss_paid      gicl_clm_res_hist.prev_loss_res%TYPE :=0;
        v_prev_exp_paid       gicl_clm_res_hist.prev_loss_res%TYPE :=0;
    BEGIN
        FOR hist IN (SELECT NVL(MAX(NVL(hist_seq_no,0)),0) + 1 seq_no
                       FROM gicl_clm_res_hist
                      WHERE claim_id = p_claim_id
                 AND item_no  = p_item_no
                 AND peril_cd = p_peril_cd
                 AND grouped_item_no = p_grouped_item_no)
          LOOP
            v_hist_seq_no := hist.seq_no;
            p_hist_seq_no := v_hist_seq_no;
            EXIT;
          END LOOP;
		  
		  FOR old_hist IN (SELECT NVL(MAX(NVL(hist_seq_no,0)),0) seq_no
			   				 FROM gicl_clm_res_hist
			   				WHERE claim_id = p_claim_id
				 			  AND item_no  = p_item_no
				 		      AND peril_cd = p_peril_cd
					 		  AND grouped_item_no = p_grouped_item_no --added by gmi 02/23/06
				 			  AND NVL(dist_sw,'N') = 'Y')
		  LOOP
			v_hist_seq_no_old := old_hist.seq_no;
			EXIT;
		  END LOOP;
		  
		  FOR hist_id IN (SELECT (NVL(MAX(NVL(clm_res_hist_id,0)),0) + 1) hist_id
						    FROM gicl_clm_res_hist
						   WHERE claim_id = p_claim_id)
		  LOOP
			v_clm_res_hist := hist_id.hist_id;
			EXIT;
		  END LOOP;
		  
		  FOR prev_amt IN (SELECT NVL(loss_reserve,0) loss_reserve, NVL(expense_reserve,0) expense_reserve,
								NVL(losses_paid,0)  losses_paid, NVL(expenses_paid,0) expenses_paid
							 FROM gicl_clm_res_hist
							WHERE claim_id    = p_claim_id
							  AND item_no     = p_item_no
							  AND peril_cd    = p_peril_cd
							  AND grouped_item_no = p_grouped_item_no
							  AND hist_seq_no = v_hist_seq_no_old)
		  LOOP
			v_prev_loss_res  := prev_amt.loss_reserve;
			v_prev_exp_res   := prev_amt.expense_reserve;
			v_prev_loss_paid := prev_amt.losses_paid;
			v_prev_exp_paid  := prev_amt.expenses_paid;
		  END LOOP;
		  
		  -- retrieve valid booking date for this record
  		  --get_booking_date;
		  
		  INSERT INTO gicl_clm_res_hist
			(claim_id, clm_res_hist_id,	hist_seq_no,  item_no, peril_cd, grouped_item_no,
			 user_id, last_update, loss_reserve, expense_reserve, dist_sw, booking_month,
			 booking_year, currency_cd, convert_rate, prev_loss_res, prev_loss_paid, prev_exp_res,
			 prev_exp_paid, distribution_date)
		  VALUES
			(p_claim_id, v_clm_res_hist, v_hist_seq_no, p_item_no, p_peril_cd, p_grouped_item_no,
			 p_user_id, SYSDATE, p_loss_reserve, p_exp_reserve, 'Y', p_booking_month, p_booking_year,
			 p_currency_cd,	p_convert_rate, --NVL(variables.v_convert_rate , :c022.convert_rate),	
			 v_prev_loss_res, v_prev_loss_paid, v_prev_exp_res, v_prev_exp_paid, NVL(p_dist_date, SYSDATE)
			);
		  
		  IF v_clm_res_hist = 1 THEN 
			 UPDATE gicl_claims
				SET clm_stat_cd = 'OP'
			  WHERE claim_id = p_claim_id;
		  END IF;  
		  
		  UPDATE gicl_clm_res_hist
			 SET dist_sw     = 'N',
				 negate_date = SYSDATE
		   WHERE claim_id = p_claim_id
			 AND item_no  = p_item_no
			 AND peril_cd = p_peril_cd
			 AND grouped_item_no = p_grouped_item_no
			 AND NVL(dist_sw, 'N') = 'Y'
			 AND hist_seq_no <> v_hist_seq_no;
		  
		  --process_distribution(v_clm_res_hist, v_hist_seq_no);
		  
    END create_new_reserve;
	
	FUNCTION RISK_DIST_EXISTS  (
		p_claim_id              IN gicl_claims.claim_id%TYPE,
      v_risk_cd   gipi_fireitem.risk_cd%TYPE,
      v_loss_date     DATE
   ) RETURN BOOLEAN IS
	BEGIN
	FOR a IN (
		  	SELECT d.share_cd, f.share_type, f.trty_yy, f.acct_trty_type,
				   f.prtfolio_sw, v_risk_cd, SUM (d.dist_tsi) ann_dist_tsi,
				   f.expiry_date               
			  FROM gipi_polbasic a,	gipi_item b, giis_peril b3, giuw_pol_dist c,
				   giuw_itemperilds_dtl d, giis_dist_share f
			 WHERE f.share_cd = d.share_cd
			   AND b3.line_cd = a.line_cd
			   AND b3.peril_cd = d.peril_cd
			   AND b3.peril_type = 'B'
			   AND f.line_cd = d.line_cd
			   AND d.item_no = b.item_no
			   AND d.dist_no = c.dist_no
			   AND c.dist_flag = giisp.v ('DISTRIBUTED')
			   AND c.policy_id = b.policy_id
			   AND TRUNC(a.eff_date) <= TRUNC(v_loss_date)
			   AND TRUNC(a.expiry_date) >= TRUNC(v_loss_date)
			   AND b.policy_id = a.policy_id
			   AND a.pol_flag IN ('1', '2', '3', 'X')
			   AND EXISTS (
					  SELECT 1
						FROM gipi_polbasic sub_a,
							 gipi_item sub_b,
							 gipi_fireitem sub_c
					   WHERE sub_a.line_cd = a.line_cd
						 AND sub_a.subline_cd = a.subline_cd
						 AND sub_a.iss_cd = a.iss_cd
						 AND sub_a.issue_yy = a.issue_yy
						 AND sub_a.pol_seq_no = a.pol_seq_no
						 AND sub_a.renew_no = a.renew_no
						 AND sub_b.item_no=d.item_no
						 AND TRUNC(sub_a.eff_date) <= TRUNC(v_loss_date)
						 AND TRUNC(sub_a.expiry_date) >= TRUNC(v_loss_date)
						 AND sub_c.risk_cd = v_risk_cd
						 AND EXISTS (SELECT 1 FROM GICL_FIRE_DTL b_id
											 WHERE b_id.claim_id= p_claim_id
											   AND b_id.item_no=SUB_B.ITEM_NO
											   AND b_id.block_id=sub_c.block_id)                     
						 AND sub_a.policy_id = sub_b.policy_id
						 AND sub_b.policy_id = sub_c.policy_id
						 AND sub_b.item_no = sub_c.item_no)           
		  GROUP BY d.share_cd,
				   f.share_type,
				   f.trty_yy,
				   f.acct_trty_type,
				   f.prtfolio_sw,
				   v_risk_cd,
				   f.expiry_date) LOOP
			 RETURN (TRUE);
		  END LOOP;
		  RETURN (FALSE);  	
	END;
	
	PROCEDURE DISTRIBUTE_RESERVE (
		p_claim_id			IN gicl_claims.claim_id%TYPE,
        p_item_no			IN gicl_item_peril.item_no%TYPE,
        p_peril_cd          IN gicl_item_peril.peril_cd%TYPE,
        p_grouped_item_no	IN gicl_item_peril.grouped_item_no%TYPE,
        p_hist_seq_no		OUT gicl_clm_res_hist.hist_seq_no%TYPE,
		p_clm_dist_no		IN OUT gicl_clm_res_hist.dist_no%TYPE, -- variables.clm_dist_no
		p_distribution_date IN OUT DATE,
		p_user_id			IN gicl_claims.user_id%TYPE,
		v1_claim_id	 		IN gicl_clm_res_hist.claim_id%type,
        v1_clm_res_hist_id 	IN gicl_clm_res_hist.clm_res_hist_id%type,
		nbt_eff_date		IN DATE,
		nbt_expiry_date		IN DATE,
		nbt_cat_cd			IN NUMBER,
		loss_date			IN DATE, -- :control.loss_date
		dsp_line_cd			IN GICL_CLAIMS.line_cd%TYPE,
		dsp_subline_cd		IN GICL_CLAIMS.subline_cd%TYPE,
		dsp_pol_iss_cd		IN GICL_CLAIMS.pol_iss_cd%TYPE,
		dsp_issue_yy		IN GICL_CLAIMS.issue_yy%TYPE,
		dsp_pol_seq_no		IN GICL_CLAIMS.pol_seq_no%TYPE,
		dsp_renew_no		IN GICL_CLAIMS.renew_no%TYPE
	)IS 
		CURSOR cur_clm_res IS
		   SELECT claim_id, clm_res_hist_id,
				  hist_seq_no, item_no, peril_cd, 
				  loss_reserve, expense_reserve,
				  convert_rate, grouped_item_no  
			 FROM gicl_clm_res_hist
			WHERE claim_id        = v1_claim_id
			  AND clm_res_hist_id = v1_clm_res_hist_id
			  FOR UPDATE OF DIST_SW;
		
		CURSOR cur_perilds(v_peril_cd giri_ri_dist_item_v.peril_cd%type,
		    v_item_no  giri_ri_dist_item_v.item_no%type) IS
		   SELECT d.share_cd, f.share_type, f.trty_yy, f.prtfolio_sw, f.acct_trty_type, SUM(d.dist_tsi) ann_dist_tsi, f.expiry_date
			 FROM gipi_polbasic a, gipi_item b, giuw_pol_dist c, giuw_itemperilds_dtl d, giis_dist_share f, giis_parameters e
			WHERE f.share_cd   = d.share_cd	  AND f.line_cd    = d.line_cd		  AND d.peril_cd   = v_peril_cd	  AND d.item_no    = v_item_no
			  AND d.item_no    = b.item_no	  AND d.dist_no    = c.dist_no		  AND e.param_type = 'V'		  AND c.dist_flag  = e.param_value_v
			  AND e.param_name = 'DISTRIBUTED'AND c.policy_id  = b.policy_id
			  AND trunc(DECODE(TRUNC(c.eff_date),TRUNC(a.eff_date), DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), nbt_eff_date, a.eff_date ),c.eff_date)) <= loss_date 
			  AND trunc(DECODE(TRUNC(c.expiry_date),TRUNC(a.expiry_date),DECODE(NVL(a.endt_expiry_date, a.expiry_date), a.expiry_date,nbt_expiry_date,a.endt_expiry_date),c.expiry_date)) >= loss_date
			  AND b.policy_id  = a.policy_id	  AND a.pol_flag   IN ('1','2','3','X')
			  AND a.line_cd    = dsp_line_cd		 AND a.subline_cd = dsp_subline_cd
			  AND a.iss_cd     = dsp_pol_iss_cd	 AND a.issue_yy   = dsp_issue_yy
			  AND a.pol_seq_no = dsp_pol_seq_no	 AND a.renew_no   = dsp_renew_no
		 GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
				  a.pol_seq_no, a.renew_no, d.share_cd, f.share_type, 
				  f.trty_yy, f.acct_trty_type, d.item_no, d.peril_cd,f.prtfolio_sw,
				  f.expiry_date;
		
		CURSOR cur_trty(v_share_cd giis_dist_share.share_cd%type,
                 v_trty_yy  giis_dist_share.trty_yy%type) IS
		   SELECT ri_cd, trty_shr_pct, prnt_ri_cd
			 FROM giis_trty_panel
			WHERE line_cd     = dsp_line_cd
			  AND trty_yy     = v_trty_yy
			  AND trty_seq_no = v_share_cd;
		
		CURSOR cur_frperil(v_peril_cd giri_ri_dist_item_v.peril_cd%type, v_item_no  giri_ri_dist_item_v.item_no%type)is
		   SELECT t2.ri_cd,
				  SUM(NVL((t2.ri_shr_pct/100) * t8.tsi_amt,0)) sum_ri_tsi_amt 
			 FROM gipi_polbasic t5, gipi_itmperil t8, giuw_pol_dist t4,
				  giuw_itemperilds t6, giri_distfrps t3, giri_frps_ri t2	   
			WHERE 1                       = 1
			  AND t5.line_cd              = dsp_line_cd
			  AND t5.subline_cd           = dsp_subline_cd
			  AND t5.iss_cd               = dsp_pol_iss_cd
			  AND t5.issue_yy             = dsp_issue_yy
			  AND t5.pol_seq_no           = dsp_pol_seq_no
			  AND t5.renew_no             = dsp_renew_no
			  AND t5.pol_flag             IN ('1','2','3','X')   
			  AND t5.policy_id            = t8.policy_id
			  AND t8.peril_cd             = v_peril_cd
			  AND t8.item_no              = v_item_no
			  AND t5.policy_id            = t4.policy_id   
			  AND trunc(DECODE(TRUNC(t4.eff_date),TRUNC(t5.eff_date),
					DECODE(TRUNC(t5.eff_date),TRUNC(t5.incept_date), nbt_eff_date, t5.eff_date ),t4.eff_date)) <= loss_date 
			  AND TRUNC(DECODE(TRUNC(t4.expiry_date),TRUNC(t5.expiry_date), 
			  		DECODE(NVL(t5.endt_expiry_date, t5.expiry_date), t5.expiry_date, nbt_expiry_date,t5.endt_expiry_date),t4.expiry_date)) >= loss_date
			  AND t4.dist_flag            = '3'
			  AND t4.dist_no              = t6.dist_no
			  AND t8.item_no              = t6.item_no
			  AND t8.peril_cd             = t6.peril_cd
			  AND t4.dist_no              = t3.dist_no
			  AND t6.dist_seq_no          = t3.dist_seq_no
			  AND t3.line_cd              = t2.line_cd
			  AND t3.frps_yy              = t2.frps_yy
			  AND t3.frps_seq_no          = t2.frps_seq_no
			  AND NVL(t2.reverse_sw, 'N') = 'N'
			  AND NVL(t2.delete_sw, 'N')  = 'N'
			  AND t3.ri_flag              = '2'   
			 GROUP BY  t2.ri_cd;
		
		sum_tsi_amt			giri_basic_info_item_sum_v.tsi_amt%TYPE;
		ann_ri_pct			NUMBER(12,9);
		ann_dist_spct		gicl_reserve_ds.shr_pct%type := 0;
		me                  NUMBER := 0;
		v_facul_share_cd	giuw_perilds_dtl.share_cd%TYPE;
		v_trty_share_type	giis_dist_share.share_type%TYPE;
		v_facul_share_type  giis_dist_share.share_type%TYPE;
		v_loss_res_amt		gicl_reserve_ds.shr_loss_res_amt%TYPE;
		v_exp_res_amt		gicl_reserve_ds.shr_exp_res_amt%TYPE;
		v_trty_limit		giis_dist_share.trty_limit%type;  
		v_facul_amt			gicl_reserve_ds.shr_loss_res_amt%TYPE;
		v_net_amt			gicl_reserve_ds.shr_loss_res_amt%TYPE;
		v_treaty_amt		gicl_reserve_ds.shr_loss_res_amt%TYPE;
		v_qs_shr_pct		giis_dist_share.qs_shr_pct%type;
		v_acct_trty_type	giis_dist_share.acct_trty_type%type;
		v_share_cd			giis_dist_share.share_cd%type;
		v_policy			VARCHAR2(2000);
		counter				NUMBER := 0;
		v_switch			NUMBER := 0;
		v_policy_id			NUMBER;
		v_clm_dist_no		NUMBER:=0; -- ??? 
		v_peril_sname		giis_peril.peril_sname%type;
		v_trty_peril		giis_peril.peril_sname%type;
		v_share_exist		VARCHAR2(1);
		v_max_hist_seq_no	gicl_clm_res_hist.hist_seq_no%TYPE;
		v_clm_res_hist_id	gicl_clm_res_hist.clm_res_hist_id%TYPE;
		v_curr_date			DATE := SYSDATE; -- :C017.last_update
	BEGIN
		SELECT max(hist_seq_no)
		  INTO v_max_hist_seq_no
		  FROM gicl_clm_res_hist
		 WHERE claim_id = p_claim_id
		 AND item_no  = p_item_no
		 AND peril_cd = p_peril_cd
		 AND grouped_item_no = NVL(p_grouped_item_no,0);
	  
		SELECT clm_res_hist_id
		  INTO v_clm_res_hist_id
		  FROM gicl_clm_res_hist
		 WHERE claim_id = p_claim_id
		 AND item_no = p_item_no
		 AND peril_cd = p_peril_cd
		 AND grouped_item_no = NVL(p_grouped_item_no,0)
		 AND hist_seq_no = v_max_hist_seq_no;
		 
		BEGIN
			SELECT max(clm_dist_no)
			  INTO p_clm_dist_no
			  FROM gicl_reserve_ds
			 WHERE claim_id = p_claim_id
			   AND clm_res_hist_id = v_clm_res_hist_id;
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			   p_clm_dist_no := 0; 
		END;
		
		p_clm_dist_no := NVL(p_clm_dist_no,0) + 1;
		v_clm_dist_no := p_clm_dist_no;  
		
		-- CI LOOP BEGIN ****************
		FOR c1 in cur_clm_res LOOP       -- Using Item-peril cursor 
			
			BEGIN
				SELECT param_value_n
				  INTO v_facul_share_cd
				  FROM giis_parameters
				 WHERE param_name = 'FACULTATIVE';
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				null; -- MSG_ALERT('There is no existing FACULTATIVE parameter in GIIS_PARAMETERS table.','I',TRUE);
			END;
			
			BEGIN
				SELECT param_value_v
				  INTO v_trty_share_type
				  FROM giac_parameters
				 WHERE param_name = 'TRTY_SHARE_TYPE';
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				null; --MSG_ALERT('There is no existing TRTY_SHARE_TYPE parameter in GIAC_PARAMETERS table.','I',TRUE);
			END;
			
			BEGIN
				SELECT param_value_v
				  INTO v_facul_share_type
				  FROM giac_parameters
				 WHERE param_name = 'FACUL_SHARE_TYPE';
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				null; -- MSG_ALERT('There is no existing FACUL_SHARE_TYPE parameter in GIAC_PARAMETERS table.','I',TRUE);
			END;
			
			BEGIN
				SELECT param_value_n
				  INTO v_acct_trty_type
				  FROM giac_parameters
				 WHERE param_name = 'QS_ACCT_TRTY_TYPE';
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				null; --MSG_ALERT('There is no existing QS_ACCT_TRTY_TYPE parameter in GIAC_PARAMETERS table.','I',TRUE);
			END;
			
			BEGIN
				SELECT SUM(a.tsi_amt)
				  INTO sum_tsi_amt
				  FROM giri_basic_info_item_sum_v a, giuw_pol_dist b
				 WHERE a.policy_id  = b.policy_id
				   AND trunc(DECODE(TRUNC(b.eff_date),TRUNC(a.eff_date), DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), nbt_eff_date, a.eff_date ),b.eff_date)) <= loss_date 
         		   AND TRUNC(DECODE(TRUNC(b.expiry_date),TRUNC(a.expiry_date), DECODE(NVL(a.endt_expiry_date, a.expiry_date), a.expiry_date, nbt_expiry_date,a.endt_expiry_date ),b.expiry_date)) >= loss_date
				   AND a.item_no    = c1.item_no
				   AND a.peril_cd   = c1.peril_cd
				   AND a.line_cd    = dsp_line_cd
				   AND a.subline_cd = dsp_subline_cd
				   AND a.iss_cd     = dsp_pol_iss_cd
				   AND a.issue_yy   = dsp_issue_yy
				   AND a.pol_seq_no = dsp_pol_seq_no
				   AND a.renew_no   = dsp_renew_no
				   AND b.dist_flag  = (SELECT param_value_v
									     FROM giis_parameters
									    WHERE param_name = 'DISTRIBUTED');
    		EXCEPTION
      		WHEN NO_DATA_FOUND THEN
        		null; --msg_alert('The TSI for this policy is Zero...','I',TRUE);
    		END;
			
			DECLARE
				CURSOR quota_share_treaties IS
				SELECT trty_limit, qs_shr_pct, share_cd
				  FROM giis_dist_share
				 WHERE line_cd        = dsp_line_cd
				   AND eff_date       <= NVL(p_distribution_date,SYSDATE)
				   AND expiry_date    >= NVL(p_distribution_date,SYSDATE)
				   AND acct_trty_type = v_acct_trty_type
				   AND qs_shr_pct     IS NOT NULL;
			BEGIN
				FOR quota_share_rec IN quota_share_treaties 
				LOOP
					BEGIN
						SELECT quota_share_rec.TRTY_LIMIT, quota_share_rec.QS_SHR_PCT, quota_share_rec.SHARE_CD
						  INTO v_trty_limit, v_qs_shr_pct, v_share_cd
						  FROM DUAL;
					EXCEPTION
					WHEN OTHERS THEN
						NULL;
					END;
				END LOOP;
			END;
			
			FOR me IN cur_perilds(c1.peril_cd, c1.item_no) 
			LOOP
				IF me.acct_trty_type = v_acct_trty_type THEN
					v_switch  := 1;
				ELSIF ((me.acct_trty_type = v_acct_trty_type) OR (me.acct_trty_type is null)) and (v_switch <> 1) THEN
					v_switch := 0;
				END IF;
			END LOOP;
			
			BEGIN
				SELECT peril_sname
				  INTO v_peril_sname
				  FROM giis_peril
				 WHERE peril_cd = c1.peril_cd
				   AND line_cd = dsp_line_cd;
			END;
			
			BEGIN
				SELECT param_value_v
				  INTO v_trty_peril
				  FROM giac_parameters
				  WHERE param_name = 'TRTY_PERIL';
			END;
			
			IF v_peril_sname = v_trty_peril THEN
				SELECT param_value_n
				  INTO v_trty_limit
				  FROM giac_parameters
				 WHERE param_name = 'TRTY_PERIL_LIMIT';
			END IF;    
			
			--message('sum_tsi_amt '||to_char(sum_tsi_amt)); pause;
			
			IF sum_tsi_amt > v_trty_limit THEN 
				FOR I IN CUR_PERILDS(C1.PERIL_CD, C1.ITEM_NO) LOOP
					IF I.SHARE_TYPE = V_FACUL_SHARE_TYPE THEN
						v_facul_amt := sum_tsi_amt * (i.ann_dist_tsi/sum_tsi_amt);
					END IF;
				END LOOP;
				v_net_amt := (sum_tsi_amt - NVL(v_facul_amt,0))* ((100 - v_qs_shr_pct)/100);  
				v_treaty_amt := (sum_tsi_amt - NVL(v_facul_amt,0))* (v_qs_shr_pct/100);  
			ELSE
				v_net_amt    := sum_tsi_amt * ((100 - v_qs_shr_pct)/100);
				v_treaty_amt := sum_tsi_amt * (v_qs_shr_pct/100);     
			END IF;
			
			--Start of distribution - Marge 4-15-2k
			FOR c2 in cur_perilds(c1.peril_cd,c1.item_no) LOOP --Underwriting peril distribution
				IF c2.share_type = v_trty_share_type THEN
					DECLARE 
						v_share_cd     giis_dist_share.share_cd%TYPE := c2.share_cd;
						v_treaty_yy2   giis_dist_share.trty_yy%TYPE  := c2.trty_yy;
						v_prtf_sw      giis_dist_share.prtfolio_sw%TYPE;
						v_acct_trty    giis_dist_share.acct_trty_type%TYPE;
						v_share_type   giis_dist_share.share_type%TYPE;
						v_expiry_date  giis_dist_share.expiry_date%TYPE;
					BEGIN          	 
						IF NVL(c2.prtfolio_sw, 'N') = 'P' AND TRUNC(c2.expiry_date) < TRUNC(NVL(p_distribution_date,SYSDATE)) THEN	
							WHILE TRUNC(c2.expiry_date) < TRUNC(NVL(p_distribution_date,SYSDATE)) LOOP
								BEGIN
									SELECT share_cd, trty_yy, NVL(prtfolio_sw, 'N'), acct_trty_type, share_type, expiry_date 
									  INTO v_share_cd, v_treaty_yy2, v_prtf_sw, v_acct_trty, v_share_type, v_expiry_date
									  FROM giis_dist_share
									 WHERE line_cd = dsp_line_cd
									   AND old_trty_seq_no = c2.share_cd;                    
								EXCEPTION 
									WHEN NO_DATA_FOUND THEN
										NULL; --MSG_ALERT('No new treaty set-up for year'|| to_char(NVL(:dist_date.distribution_date,SYSDATE),'YYYY'), 'I', true);
										EXIT;
									WHEN TOO_MANY_ROWS THEN
										NULL; --MSG_ALERT('Too many treaty set-up for year'|| to_char(NVL(:dist_date.distribution_date,SYSDATE),'YYYY'), 'I', true);   
								END;
								c2.share_cd       := v_share_cd;
								c2.share_type     := v_share_type;
								c2.acct_trty_type := v_acct_trty;  
								c2.trty_yy        := v_treaty_yy2;                    
								c2.expiry_date    := v_expiry_date;
								IF v_prtf_sw = 'N' THEN
									EXIT;
								END IF;
							END LOOP;
						END IF;
					END;
				END IF;
				
				ann_dist_spct := 0;
      			
				IF ((c2.acct_trty_type <> v_acct_trty_type) OR (c2.acct_trty_type IS NULL)) AND v_switch = 0 THEN
					ann_dist_spct  := (c2.ann_dist_tsi / sum_tsi_amt) * 100;
					v_loss_res_amt := c1.loss_reserve * ann_dist_spct/100;
					v_exp_res_amt  := c1.expense_reserve * ann_dist_spct/100;
				ELSE 
					IF (c2.share_type = v_trty_share_type) AND (c2.share_cd = v_share_cd) THEN
						ann_dist_spct  := (v_treaty_amt/sum_tsi_amt) * 100;
						v_loss_res_amt := c1.loss_reserve * ann_dist_spct/100;
						v_exp_res_amt  := c1.expense_reserve * ann_dist_spct/100;
					ELSIF (c2.share_type != v_trty_share_type) 
					  AND (c2.share_type != v_facul_share_type) 
					  AND (v_net_amt IS NOT NULL) THEN
						ann_dist_spct  := (v_net_amt/sum_tsi_amt) * 100;
						v_loss_res_amt := c1.loss_reserve * ann_dist_spct/100;
						v_exp_res_amt  := c1.expense_reserve * ann_dist_spct/100;
					ELSE
						ann_dist_spct  := (c2.ann_dist_tsi / sum_tsi_amt) * 100;
						v_loss_res_amt := c1.loss_reserve * ann_dist_spct/100;
						v_exp_res_amt  := c1.expense_reserve * ann_dist_spct/100;
					END IF;
      			END IF;
				
				--	checks if share_cd is already existing if existing updates gicl_reserve_ds
				--		if not existing then inserts record to gicl_reserve_ds
				
				v_share_exist := 'N';
				
				FOR i IN (SELECT '1' 
							FROM gicl_reserve_ds
						   WHERE claim_id    = c1.claim_id	AND grouped_item_no = c1.grouped_item_no			
							 AND item_no     = c1.item_no	AND hist_seq_no = c1.hist_seq_no
							 AND peril_cd    = c1.peril_cd	AND line_cd     = dsp_line_cd
							 AND grp_seq_no  = c2.share_cd)
				LOOP
					v_share_exist :='Y';
				END LOOP;
				
				IF ann_dist_spct <> 0 THEN
					IF v_share_exist = 'N' THEN
						INSERT INTO gicl_reserve_ds(claim_id, clm_res_hist_id, dist_year, clm_dist_no, item_no, peril_cd,
                                        grouped_item_no, grp_seq_no, share_type, shr_pct, shr_loss_res_amt, shr_exp_res_amt, line_cd, acct_trty_type,  user_id, last_update, hist_seq_no)
							 VALUES (c1.claim_id, c1.clm_res_hist_id, to_char(NVL(p_distribution_date,SYSDATE),'YYYY'), v_clm_dist_no, c1.item_no,
                                        c1.peril_cd, c1.grouped_item_no, c2.share_cd, c2.share_type, ann_dist_spct, v_loss_res_amt, v_exp_res_amt,
                                        dsp_line_cd, c2.acct_trty_type, p_user_id, v_curr_date, c1.hist_seq_no);
					ELSE 
						UPDATE gicl_reserve_ds
						   SET shr_pct = NVL(shr_pct,0) + NVL(ann_dist_spct,0),
							   shr_loss_res_amt = NVL(shr_loss_res_amt,0) + NVL(v_loss_res_amt,0),
							   shr_exp_res_amt  = NVL(shr_exp_res_amt,0) + NVL(v_exp_res_amt,0)
						 WHERE claim_id    = c1.claim_id
						   AND hist_seq_no = c1.hist_seq_no
						   AND grouped_item_no = c1.grouped_item_no
						   AND item_no     = c1.item_no
						   AND peril_cd    = c1.peril_cd
						   AND grp_seq_no  = c2.share_cd
						   AND line_cd     = dsp_line_cd;
					END IF;
					
					me := to_number(c2.share_type) - to_number(v_trty_share_type);
					
					IF me = 0 THEN
						FOR c_trty in cur_trty(c2.share_cd, c2.trty_yy) LOOP
							IF v_share_exist = 'N' THEN 
								INSERT INTO gicl_reserve_rids(claim_id, clm_res_hist_id, dist_year, clm_dist_no, item_no, peril_cd, grp_seq_no, share_type, 		 	
                                               ri_cd, shr_ri_pct, shr_ri_pct_real, shr_loss_ri_res_amt, shr_exp_ri_res_amt, line_cd, acct_trty_type, prnt_ri_cd, 		        
                                               hist_seq_no, grouped_item_no)
									 VALUES(c1.claim_id, c1.clm_res_hist_id, to_char(NVL(p_distribution_date,SYSDATE),'YYYY'), v_clm_dist_no, c1.item_no, c1.peril_cd, c2.share_cd,
                                               v_trty_share_type, c_trty.ri_cd, (ann_dist_spct  * c_trty.trty_shr_pct/100), c_trty.trty_shr_pct, (v_loss_res_amt * c_trty.trty_shr_pct/100),
                    		                   (v_exp_res_amt  * c_trty.trty_shr_pct/100), dsp_line_cd, c2.acct_trty_type,   c_trty.prnt_ri_cd, 	
                                               c1.hist_seq_no,     c1.grouped_item_no);
							ELSE 
								UPDATE gicl_reserve_rids
								   SET shr_exp_ri_res_amt  = NVL(shr_exp_ri_res_amt,0) + (NVL(v_exp_res_amt,0)* c_trty.trty_shr_pct/100),
									   shr_loss_ri_res_amt = NVL(shr_loss_ri_res_amt,0) + (NVL(v_loss_res_amt,0)* c_trty.trty_shr_pct/100),
									   shr_ri_pct          = NVL(shr_ri_pct,0) + (NVL(ann_dist_spct,0)* c_trty.trty_shr_pct/100)
								WHERE claim_id    = c1.claim_id
									AND hist_seq_no = c1.hist_seq_no
									AND item_no     = c1.item_no
									AND peril_cd    = c1.peril_cd
									AND grouped_item_no = c1.grouped_item_no 
									AND grp_seq_no  = c2.share_cd
									AND ri_cd       = c_trty.ri_cd
									AND line_cd     = dsp_line_cd;
							END IF;           
            			END LOOP;
         			ELSIF c2.share_type = v_facul_share_type THEN
						FOR c3 in cur_frperil(c1.peril_cd,c1.item_no) LOOP
							IF (c2.acct_trty_type <> v_acct_trty_type) or (c2.acct_trty_type is null) then 
								ann_ri_pct := (c3.sum_ri_tsi_amt / sum_tsi_amt) * 100;
							ELSE
								ann_ri_pct := (v_facul_amt /sum_tsi_Amt) * 100;
							END IF; 
							
              				INSERT INTO gicl_reserve_rids(claim_id, clm_res_hist_id, dist_year, clm_dist_no, item_no, peril_cd,
									grp_seq_no, share_type, ri_cd, shr_ri_pct, shr_ri_pct_real, shr_loss_ri_res_amt,
									shr_exp_ri_res_amt, line_cd, acct_trty_type, prnt_ri_cd, hist_seq_no, grouped_item_no)
								 VALUES(c1.claim_id, c1.clm_res_hist_id, to_char(NVL(p_distribution_date,SYSDATE), 'YYYY'),
									v_clm_dist_no, c1.item_no, c1.peril_cd, c2.share_cd, v_facul_share_type, c3.ri_cd,
									ann_ri_pct, ann_ri_pct*100/ann_dist_spct, (c1.loss_reserve * ann_ri_pct/100),
	             		            (c1.expense_reserve * ann_ri_pct/100), dsp_line_cd, c2.acct_trty_type,
	             		            c3.ri_cd, c1.hist_seq_no, c1.grouped_item_no);
            			END LOOP; -- end of c3 loop
         			END IF;
      			ELSE 
         			NULL;
      			END IF;
    		END LOOP; -- End of c2 loop
		
			--EXCESS OF LOSS
			DECLARE
				v_retention					gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
				v_retention_orig			gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
				v_running_retention			gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
				v_total_retention			gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
				v_allowed_retention 		gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
				v_total_xol_share			gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
				v_overall_xol_share			gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
				v_overall_allowed_share		gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
				v_old_xol_share				gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;    	
				v_allowed_ret				gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
				v_shr_pct					gicl_reserve_ds.shr_pct%TYPE;
			BEGIN
				IF nbt_cat_cd IS NULL THEN
					FOR NET_SHR IN (SELECT	(shr_loss_res_amt * c1.convert_rate) loss_reserve, 
								(shr_exp_res_amt* c1.convert_rate) exp_reserve, shr_pct
						  FROM gicl_reserve_ds
						 WHERE claim_id    = c1.claim_id
						   AND grouped_item_no = c1.grouped_item_no --added by gmi 02/28/06
						   AND hist_seq_no = c1.hist_seq_no
						   AND item_no     = c1.item_no
						   AND peril_cd    = c1.peril_cd
						   AND share_type  = '1')        
					LOOP
						v_retention := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
						v_retention_orig := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
						FOR TOT_NET IN (
							SELECT SUM(NVL(a.shr_loss_res_amt * c.convert_rate,0) + NVL( a.shr_exp_res_amt* c.convert_rate,0)) ret_amt
							  FROM gicl_reserve_ds a, gicl_item_peril b, gicl_clm_res_hist c
							 WHERE a.claim_id = c1.claim_id
								AND a.claim_id = b.claim_id
								AND a.grouped_item_no = b.grouped_item_no
								AND a.item_no = b.item_no
								AND a.peril_cd = b.peril_cd
								AND a.claim_id = c.claim_id
								AND a.grouped_item_no = c.grouped_item_no
								AND a.item_no = c.item_no
								AND a.peril_cd = c.peril_cd
								AND a.clm_dist_no = c.dist_no
								AND a.clm_res_hist_id = c.clm_res_hist_id  
								AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
								AND NVL(a.negate_tag,'N') = 'N'
								AND a.share_type = '1'
								AND (a.item_no  <> c1.item_no OR a.peril_cd <> c1.peril_cd OR a.grouped_item_no <> c1.grouped_item_no))
						LOOP
							v_total_retention := v_retention + NVL(tot_net.ret_amt,0);
						END LOOP; 
						
						FOR CHK_XOL IN (
							SELECT a.share_cd, acct_trty_type, xol_allowed_amount, xol_base_amount, xol_reserve_amount, 
									trty_yy, xol_aggregate_sum, a.line_cd, a.share_type
							  FROM giis_dist_share a, giis_trty_peril b
							 WHERE a.line_cd = b.line_cd
							   AND a.share_cd = b.trty_seq_no
							   AND a.share_type = '4'
							   AND TRUNC(a.eff_date) <= TRUNC(loss_date)
							   AND TRUNC(a.expiry_date) >= TRUNC(loss_date)
							   AND b.peril_cd = c1.peril_cd             
							   AND a.line_cd = dsp_line_cd                
							 ORDER BY xol_base_amount ASC)
						LOOP
							v_allowed_retention := v_total_retention - chk_xol.xol_base_amount;
							IF v_allowed_retention < 1 THEN        	 
								EXIT;
							END IF;
							
							FOR get_all_xol IN (
								SELECT SUM(NVL(a.shr_loss_res_amt *c.convert_rate,0) + NVL( a.shr_exp_res_amt*c.convert_rate,0)) ret_amt
								  FROM gicl_reserve_ds a, gicl_item_peril b, gicl_clm_res_hist c
								 WHERE NVL(a.negate_tag,'N')   = 'N'
									AND a.item_no = b.item_no
									AND a.grouped_item_no = b.grouped_item_no
									AND a.peril_cd = b.peril_cd
									AND a.claim_id = b.claim_id
									AND a.item_no = c.item_no
									AND a.grouped_item_no = c.grouped_item_no
									AND a.peril_cd = c.peril_cd
									AND a.claim_id = c.claim_id
									AND NVL(a.clm_dist_no, -1) = NVL(c.dist_no, -1) 
									AND a.clm_res_hist_id = c.clm_res_hist_id  
									AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
									AND a.grp_seq_no = chk_xol.share_cd
									AND a.line_cd = chk_xol.line_cd)
							LOOP
								v_overall_xol_share := chk_xol.xol_aggregate_sum - get_all_xol.ret_amt;
							END LOOP;
							
							IF v_overall_xol_share < 1 THEN   -- added adrel 01082010, should exit loop if already exceeded aggregate limit      	 
								EXIT;
							END IF;
							
							IF v_allowed_retention > v_overall_xol_share THEN
								v_allowed_retention := v_overall_xol_share;
							END IF;	       
	
							IF v_allowed_retention > v_retention THEN
								v_allowed_retention := v_retention;	 
							END IF;
							
							v_total_xol_share := 0;
							v_old_xol_share := 0;
	
							FOR TOTAL_XOL IN (
								SELECT SUM(NVL(a.shr_loss_res_amt * c.convert_rate,0) + NVL( a.shr_exp_res_amt *c.convert_rate,0)) ret_amt
								  FROM gicl_reserve_ds a, gicl_item_peril b, gicl_clm_res_hist c
								 WHERE a.claim_id = c1.claim_id
									AND a.claim_id = b.claim_id
									AND a.grouped_item_no = b.grouped_item_no --added by gmi 02/28/06
									AND a.item_no = b.item_no
									AND a.peril_cd = b.peril_cd
									AND a.claim_id = c.claim_id
									AND a.item_no = c.item_no
									AND a.peril_cd = c.peril_cd
									AND a.grouped_item_no = c.grouped_item_no --added by gmi 02/28/06
									AND a.clm_res_hist_id = c.clm_res_hist_id  
									AND a.clm_dist_no = c.dist_no
									AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
									AND NVL(a.negate_tag,'N') = 'N'
									AND a.grp_seq_no = chk_xol.share_cd)
							LOOP
								v_total_xol_share := NVL(total_xol.ret_amt,0);
								v_old_xol_share    := NVL(total_xol.ret_amt,0);          	
							END LOOP;
							
						
							IF v_total_xol_share <= chk_xol.xol_allowed_amount THEN
								v_total_xol_share := chk_xol.xol_allowed_amount - v_total_xol_share;
							END IF;
							
							IF v_total_xol_share >= v_allowed_retention THEN
								v_total_xol_share := v_allowed_retention;
							END IF;	  	          
							
							IF v_total_xol_share <> 0 THEN
								v_shr_pct := v_total_xol_share/v_retention_orig;
								v_running_retention := v_running_retention + v_total_xol_share;      
								INSERT INTO gicl_reserve_ds (claim_id, clm_res_hist_id, dist_year, clm_dist_no,
									item_no, peril_cd, grouped_item_no, grp_seq_no, share_type, shr_pct, shr_loss_res_amt,
									shr_exp_res_amt, line_cd, acct_trty_type, user_id, last_update, hist_seq_no)
								VALUES (c1.claim_id, c1.clm_res_hist_id, to_char(NVL(p_distribution_date, SYSDATE),'YYYY'),
									v_clm_dist_no, c1.item_no, c1.peril_cd, c1.grouped_item_no, chk_xol.share_cd,
									chk_xol.share_type, (net_shr.shr_pct * v_shr_pct), (net_shr.loss_reserve * v_shr_pct)/c1.convert_rate,
									(net_shr.exp_reserve * v_shr_pct) / c1.convert_rate, dsp_line_cd, chk_xol.acct_trty_type,
									p_user_id, v_curr_date, c1.hist_seq_no);
								
								FOR update_xol_trty IN (
									SELECT SUM((NVL(a.shr_loss_res_amt,0)* b.convert_rate) +( NVL( shr_exp_res_amt,0)* b.convert_rate)) ret_amt
									  FROM gicl_reserve_ds a, gicl_clm_res_hist b, gicl_item_peril c
									 WHERE NVL(a.negate_tag,'N') = 'N'
										AND a.claim_id = b.claim_id
										AND a.clm_res_hist_id = b.clm_res_hist_id
										AND a.claim_id = c.claim_id
										AND a.item_no = c.item_no
										AND a.peril_cd = c.peril_cd
										AND a.grouped_item_no = c.grouped_item_no
										AND a.clm_dist_no = b.dist_no
										AND NVL(c.close_flag, 'AP') IN ('AP','CC','CP')
										AND a.grp_seq_no = chk_xol.share_cd
										AND a.line_cd = chk_xol.line_cd)
								LOOP
									UPDATE giis_dist_share 
									   SET xol_reserve_amount = update_xol_trty.ret_amt
									 WHERE share_cd           = chk_xol.share_cd
									   AND line_cd = chk_xol.line_cd;
								END LOOP;
								
								FOR xol_trty IN cur_trty(chk_xol.share_cd, chk_xol.trty_yy) 
								LOOP
									INSERT INTO gicl_reserve_rids (claim_id, clm_res_hist_id, dist_year, clm_dist_no, item_no, peril_cd,
										grp_seq_no, share_type, ri_cd, shr_ri_pct, shr_ri_pct_real, shr_loss_ri_res_amt,
										shr_exp_ri_res_amt, line_cd, acct_trty_type, prnt_ri_cd, hist_seq_no, grouped_item_no)
									VALUES (c1.claim_id, c1.clm_res_hist_id, TO_CHAR(NVL(p_distribution_date, SYSDATE),'YYYY'),
										v_clm_dist_no, c1.item_no, c1.peril_cd, chk_xol.share_cd, chk_xol.share_type, xol_trty.ri_cd,
										((net_shr.shr_pct * v_shr_pct)  * (xol_trty.trty_shr_pct/100)), xol_trty.trty_shr_pct,
										((net_shr.loss_reserve * v_shr_pct)* (xol_trty.trty_shr_pct/100))/ c1.convert_rate,
										((net_shr.exp_reserve * v_shr_pct)* ( xol_trty.trty_shr_pct/100))/ c1.convert_rate,
										dsp_line_cd, chk_xol.acct_trty_type, xol_trty.prnt_ri_cd,  c1.hist_seq_no, c1.grouped_item_no);
								END LOOP;
								
							END IF;
							v_retention := v_retention - v_total_xol_share;
							v_total_retention := v_total_retention +  v_old_xol_share;        
						END LOOP; --CHK_XOL          
					END LOOP; -- NET_SHR 
				ELSE
					FOR NET_SHR IN (
						SELECT	(shr_loss_res_amt * c1.convert_rate) loss_reserve, 
								(shr_exp_res_amt* c1.convert_rate) exp_reserve, 
								shr_pct
						FROM gicl_reserve_ds
						WHERE claim_id    = c1.claim_id
						AND hist_seq_no = c1.hist_seq_no
						AND grouped_item_no = c1.grouped_item_no
						AND item_no     = c1.item_no
						AND peril_cd    = c1.peril_cd
						AND share_type  = '1')        
					LOOP
						
						v_retention := NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
						v_retention_orig :=NVL(net_shr.loss_reserve,0) + NVL(net_shr.exp_reserve,0);
						
						
						FOR TOT_NET IN (
							SELECT SUM(NVL(shr_loss_res_amt* d.convert_rate,0) + NVL( shr_exp_res_amt* d.convert_rate,0)) ret_amt
							  FROM gicl_reserve_ds a, gicl_claims c, gicl_item_peril b, gicl_clm_res_hist d
							 WHERE a.claim_id = c.claim_id
								AND a.claim_id = b.claim_id
								AND a.grouped_item_no = b.grouped_item_no
								AND a.item_no = b.item_no
								AND a.peril_cd = b.peril_cd
								AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
								AND c.catastrophic_cd = nbt_cat_cd
								AND c.line_Cd = dsp_line_cd
								AND NVL(negate_tag,'N') = 'N'
								AND share_type = '1'
								AND a.claim_id = d.claim_id
								AND a.grouped_item_no = d.grouped_item_no --added by gmi 02/28/06
								AND a.item_no = d.item_no
								AND a.peril_cd = d.peril_cd
								AND a.clm_dist_no = d.dist_no
								AND a.clm_res_hist_id = d.clm_res_hist_id  
								AND (a.claim_id <> v1_claim_id OR a.item_no <> c1.item_no OR a.peril_cd <> c1.peril_cd ))
						LOOP
							v_total_retention := v_retention + NVL(tot_net.ret_amt,0);
						END LOOP;
						
						FOR CHK_XOL IN (
							SELECT a.share_cd, acct_trty_type, xol_allowed_amount, xol_base_amount, 
									xol_reserve_amount, trty_yy, xol_aggregate_sum, a.line_cd, a.share_type
							  FROM giis_dist_share a, giis_trty_peril b
							 WHERE a.line_cd            = b.line_cd
								AND a.share_cd           = b.trty_seq_no
								AND a.share_type         = '4'
								AND TRUNC(a.eff_date)    <= TRUNC(loss_date)
								AND TRUNC(a.expiry_date) >= TRUNC(loss_date)
								AND b.peril_cd           = c1.peril_cd             
								AND a.line_cd            = dsp_line_cd                
							ORDER BY xol_base_amount ASC)
						LOOP
							v_allowed_retention := v_total_retention - chk_xol.xol_base_amount;
							IF v_allowed_retention < 1 THEN        	 
								EXIT;
							END IF;
				   
							FOR get_all_xol IN (
								SELECT SUM(NVL(shr_loss_res_amt* c.convert_rate,0) + NVL( shr_exp_res_amt* c.convert_rate,0)) ret_amt
								  FROM gicl_reserve_ds a, gicl_item_peril b, gicl_clm_res_hist c
								 WHERE NVL(negate_tag,'N') = 'N'
									AND a.claim_id = b.claim_id
									AND a.item_no = b.item_no
									AND a.peril_cd = b.peril_cd
									AND a.grouped_item_no = b.grouped_item_no
									AND a.claim_id = c.claim_id
									AND a.grouped_item_no = c.grouped_item_no
									AND a.item_no = c.item_no
									AND a.peril_cd = c.peril_cd
									AND a.clm_dist_no = c.dist_no
									AND a.clm_res_hist_id = c.clm_res_hist_id
									AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')  
									AND grp_seq_no = chk_xol.share_cd
									AND a.line_cd = chk_xol.line_cd)
							LOOP
								v_overall_xol_share := chk_xol.xol_aggregate_sum - get_all_xol.ret_amt;
							END LOOP;
							
							IF v_overall_xol_share < 1 THEN   -- added adrel 01082010, should exit loop if already exceeded aggregate limit
								EXIT;
							END IF;            
	
							IF v_allowed_retention > v_overall_xol_share THEN
								v_allowed_retention := v_overall_xol_share;
							END IF;	       
							IF v_allowed_retention > v_retention THEN
								v_allowed_retention := v_retention;	 
							END IF;
								 
							v_total_xol_share := 0;
							v_old_xol_share   := 0; 
							
							FOR TOTAL_XOL IN (
								SELECT SUM(NVL(shr_loss_res_amt* d.convert_rate,0) + NVL( shr_exp_res_amt * d.convert_rate,0)) ret_amt
								  FROM gicl_reserve_ds a, gicl_claims c, gicl_item_peril b, gicl_clm_res_hist d
								 WHERE c.claim_id = a.claim_id
									AND a.grouped_item_no = b.grouped_item_no
									AND a.claim_id = b.claim_id
									AND a.item_no = b.item_no
									AND a.peril_cd = b.peril_cd
									AND a.claim_id = d.claim_id
									AND a.grouped_item_no = d.grouped_item_no
									AND a.item_no = d.item_no
									AND a.peril_cd = d.peril_cd
									AND a.clm_dist_no = d.dist_no
									AND a.clm_res_hist_id = d.clm_res_hist_id  
									AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP')
									AND c.catastrophic_cd = nbt_cat_cd
									AND c.line_cd = dsp_line_cd
									AND NVL(negate_tag,'N') = 'N'
									AND grp_seq_no = chk_xol.share_cd)
							LOOP
								v_total_xol_share := NVL(total_xol.ret_amt,0);
								v_old_xol_share   := NVL(total_xol.ret_amt,0);          	
							END LOOP;
							
							IF v_total_xol_share <= chk_xol.xol_allowed_amount THEN
								v_total_xol_share := chk_xol.xol_allowed_amount - v_total_xol_share;
							ELSE 
								v_total_xol_share := 0; -- jen.060210:will not insert record if xol share exceeds allowed xol amt
							END IF;	 
							
							IF v_total_xol_share >= v_allowed_retention THEN
								v_total_xol_share := v_allowed_retention;
							END IF;
				 
							IF v_total_xol_share <> 0 THEN
								v_shr_pct := v_total_xol_share/v_retention_orig;
								v_running_retention := v_running_retention + v_total_xol_share;      
								
								INSERT INTO gicl_reserve_ds (claim_id, clm_res_hist_id, dist_year, clm_dist_no, item_no, peril_cd,
									grouped_item_no, grp_seq_no, share_type, shr_pct, shr_loss_res_amt, shr_exp_res_amt, line_cd,
									acct_trty_type, user_id, last_update, hist_seq_no)
								VALUES (c1.claim_id, c1.clm_res_hist_id, TO_CHAR(NVL(p_distribution_date, SYSDATE),'YYYY'),
									v_clm_dist_no, c1.item_no, c1.peril_cd, c1.grouped_item_no, chk_xol.share_cd,
									chk_xol.share_type, (net_shr.shr_pct * v_shr_pct), (net_shr.loss_reserve * v_shr_pct) / c1.convert_rate,
									(net_shr.exp_reserve * v_shr_pct)/ c1.convert_rate, dsp_line_cd, chk_xol.acct_trty_type,
									p_user_id, v_curr_date, c1.hist_seq_no);		
								
								FOR update_xol_trty IN (
									SELECT SUM((NVL(a.shr_loss_res_amt,0)* b.convert_rate) +( NVL( shr_exp_res_amt,0)* b.convert_rate)) ret_amt
									  FROM gicl_reserve_ds a, gicl_clm_res_hist b, gicl_item_peril c
									 WHERE NVL(a.negate_tag,'N')   = 'N'
										AND a.claim_id = b.claim_id
										AND a.clm_res_hist_id = b.clm_res_hist_id
										AND a.claim_id = c.claim_id
										AND a.item_no = c.item_no
										AND a.peril_cd = c.peril_cd         	          
										AND a.grouped_item_no = c.grouped_item_no
										AND NVL(c.close_flag, 'AP') IN ('AP','CC','CP')
										AND a.grp_seq_no = chk_xol.share_cd
										AND a.line_cd = chk_xol.line_cd)
								LOOP     
									UPDATE giis_dist_share 
									   SET xol_reserve_amount = update_xol_trty.ret_amt
									 WHERE share_cd = chk_xol.share_cd
									   AND line_cd  = chk_xol.line_cd;
								END LOOP;
								
								FOR xol_trty IN cur_trty(chk_xol.share_cd, chk_xol.trty_yy) 
								LOOP
									INSERT INTO gicl_reserve_rids (claim_id, clm_res_hist_id, dist_year, clm_dist_no, item_no, peril_cd,                                                 
										grp_seq_no, share_type, ri_cd, shr_ri_pct, shr_ri_pct_real, shr_loss_ri_res_amt,
										shr_exp_ri_res_amt, line_cd, acct_trty_type, prnt_ri_cd, hist_seq_no, grouped_item_no)
									VALUES (c1.claim_id, c1.clm_res_hist_id, TO_CHAR(NVL(p_distribution_date, SYSDATE),'YYYY'),
										v_clm_dist_no, c1.item_no, c1.peril_cd, chk_xol.share_cd, chk_xol.share_type, xol_trty.ri_cd,
										((net_shr.shr_pct * v_shr_pct)  * (xol_trty.trty_shr_pct/100)), xol_trty.trty_shr_pct,
										((net_shr.loss_reserve * v_shr_pct)* (xol_trty.trty_shr_pct/100))/ c1.convert_rate,
										((net_shr.exp_reserve * v_shr_pct)* ( xol_trty.trty_shr_pct/100))/ c1.convert_rate,
										dsp_line_cd, chk_xol.acct_trty_type, xol_trty.prnt_ri_cd, c1.hist_seq_no, c1.grouped_item_no);
								END LOOP;
							END IF;      
							
							v_retention := v_retention - v_total_xol_share;         
							v_total_retention := v_total_retention +  v_old_xol_share;        
						END LOOP; --CHK_XOL          
					END LOOP; -- NET_SHR	     	
				END IF;
				
				
				IF v_retention = 0 THEN
					DELETE FROM gicl_reserve_ds
					WHERE claim_id    = c1.claim_id
					  AND hist_seq_no = c1.hist_seq_no
					  AND item_no     = c1.item_no
					  AND peril_cd    = c1.peril_cd
					  AND grouped_item_no = c1.grouped_item_no
					  AND share_type  = '1';
				ELSIF v_retention <> v_retention_orig THEN      	
					UPDATE gicl_reserve_ds
					   SET shr_loss_res_amt = shr_loss_res_amt * (v_retention_orig-v_running_retention)/v_retention_orig,
						   shr_exp_res_amt  = shr_exp_res_amt * (v_retention_orig-v_running_retention)/v_retention_orig,
						   shr_pct =  shr_pct * (v_retention_orig-v_running_retention)/v_retention_orig
					WHERE claim_id    = c1.claim_id
					  AND hist_seq_no = c1.hist_seq_no
					  AND item_no     = c1.item_no
					  AND peril_cd    = c1.peril_cd
					  AND grouped_item_no = c1.grouped_item_no
					  AND share_type  = '1';
				END IF;
				
			END;
		END LOOP; -- end of c1 loop
		
		UPDATE gicl_clm_res_hist
		   SET dist_sw = 'Y', dist_no = p_clm_dist_no
     	 WHERE current of cur_clm_res;

		UPDATE gicl_clm_res_hist
		  SET dist_sw = 'Y',
           dist_no = p_clm_dist_no
		WHERE current of cur_clm_res;
		
	
	--MESSAGE('Distribution Complete.', no_acknowledge);
	--offset_amt(v_clm_dist_no, v1_claim_id, v1_clm_res_hist_id);
 	--forms_ddl('COMMIT');
	--CLEAR_MESSAGE;
				
	END	DISTRIBUTE_RESERVE;
	
	PROCEDURE offset_amt (
		v_clm_dist_no  		IN gicl_reserve_ds.clm_dist_no%TYPE,
		v1_claim_id    		IN gicl_clm_res_hist.claim_id%type,
        v1_clm_res_hist_id  IN gicl_reserve_ds.clm_res_hist_id%TYPE
	)IS
  		offset_loss  gicl_reserve_ds.shr_loss_res_amt%TYPE;
  		offset_exp  gicl_reserve_ds.shr_loss_res_amt%TYPE;
  		offset_loss1  gicl_reserve_ds.shr_loss_res_amt%TYPE;
  		offset_exp1  gicl_reserve_ds.shr_loss_res_amt%TYPE;
	BEGIN
		FOR OFFSET IN (
			SELECT  loss_reserve, expense_reserve
			  FROM gicl_clm_res_hist
			 WHERE claim_id        = v1_claim_id
			   AND clm_res_hist_id = v1_clm_res_hist_id)
		LOOP      
			FOR offset2 IN (
				SELECT SUM(shr_loss_res_amt)sum_loss, SUM(shr_exp_res_amt) sum_exp
				  FROM gicl_reserve_ds
				 WHERE claim_id = v1_claim_id
				   AND clm_dist_no = v_clm_dist_no
				   AND clm_res_hist_id = v1_clm_res_hist_id)
			LOOP
				offset_loss1 := NVL(offset.loss_reserve,0) - NVL(offset2.sum_loss,0);
				offset_exp1 := NVL(offset.expense_reserve,0) - NVL(offset2.sum_exp,0);
			END LOOP;
		END LOOP;
  
		IF NVL(offset_loss1,0) <> 0 OR NVL(offset_exp1,0) <> 0 THEN
			FOR get_cd IN (
				SELECT grp_seq_no
				FROM gicl_reserve_ds
				WHERE claim_id = v1_claim_id
				AND clm_dist_no = v_clm_dist_no
				AND clm_res_hist_id = v1_clm_res_hist_id 
				ORDER BY grp_seq_no)
			LOOP
				UPDATE gicl_reserve_ds
				SET shr_loss_res_amt = shr_loss_res_amt + offset_loss1,
					shr_exp_res_amt = shr_exp_res_amt + offset_exp1
				WHERE claim_id = v1_claim_id
				AND clm_dist_no = v_clm_dist_no
				AND grp_seq_no = get_cd.grp_seq_no
				AND clm_res_hist_id = v1_clm_res_hist_id;
			EXIT;
			END LOOP;
		END IF;   
  
		FOR A IN ( -- extract amounts from gicl_reserve_rids
			SELECT grp_seq_no, peril_cd, item_no, grouped_item_no, 
				SUM(shr_loss_ri_res_amt) loss_amt, SUM(shr_exp_ri_res_amt) exp_amt
			FROM gicl_reserve_rids
			WHERE claim_id = v1_claim_id
			AND clm_dist_no = v_clm_dist_no
			AND clm_res_hist_id= v1_clm_res_hist_id
			GROUP BY grp_seq_no, item_no, peril_cd, grouped_item_no)
		LOOP
			offset_loss := 0;
			offset_exp  := 0;
		
			FOR B IN (  -- extract amounts from gicl_reserve_ds to link with the values in A.
				SELECT shr_loss_res_amt, shr_exp_res_amt
				  FROM gicl_reserve_ds
				 WHERE claim_id = v1_claim_id
				   AND clm_dist_no = v_clm_dist_no
				   AND grp_seq_no = a.grp_seq_no
				   AND clm_res_hist_id = v1_clm_res_hist_id
				   AND item_no = a.item_no  
				   AND peril_cd = a.peril_cd
				   AND grouped_item_no = a.grouped_item_no) --gmi 02/23/06
			LOOP -- subtract sum of amounts in A from B, if <> 0 IF statement executes. otherwise, null.
				offset_loss := NVL(b.shr_loss_res_amt,0) - NVL(a.loss_amt,0);
				offset_exp  := NVL(b.shr_exp_res_amt,0) - NVL(a.exp_amt,0);
    		END LOOP;
			-- if <> 0 update gicl_reserve_rids using ri_cd.
			IF NVL(offset_loss,0) <> 0 OR NVL(offset_exp,0) <> 0 THEN
				FOR C IN (
					SELECT ri_cd
					  FROM gicl_reserve_rids
					 WHERE claim_id = v1_claim_id
					   AND clm_dist_no = v_clm_dist_no
					   AND grp_seq_no = a.grp_seq_no
					   AND clm_res_hist_id  = v1_clm_res_hist_id
					   AND item_no = a.item_no  
					   AND peril_cd = a.peril_cd
					   AND grouped_item_no = a.grouped_item_no)--gmi 02/23/06
				LOOP  -- add offset_loss/offset_exp to amounts in A then assign back to the same amounts (shr_loss_ri_res_amount, shr_exp_ri_res_amt) 
					UPDATE gicl_reserve_rids
					   SET shr_loss_ri_res_amt = NVL(shr_loss_ri_res_amt,0) + NVL(offset_loss,0),
						shr_exp_ri_res_amt  = NVL(shr_exp_ri_res_amt,0) + NVL(offset_exp,0)
					 WHERE claim_id    = v1_claim_id
					   AND clm_dist_no = v_clm_dist_no
					   AND grp_seq_no  = a.grp_seq_no
					   AND clm_res_hist_id = v1_clm_res_hist_id
					   AND ri_cd       = c.ri_cd  
					   AND item_no     = a.item_no
					   AND grouped_item_no = a.grouped_item_no --added by gmi 02/23/06  
					   AND peril_cd    = a.peril_cd;
					EXIT;
				END LOOP;
			END IF;
		END LOOP;
	END offset_amt;
	
	PROCEDURE create_new_reserve2(
		p_claim_id              IN gicl_claims.claim_id%TYPE,
        p_item_no               IN gicl_item_peril.item_no%TYPE,
        p_peril_cd              IN gicl_item_peril.peril_cd%TYPE,
        p_grouped_item_no       IN gicl_item_peril.grouped_item_no%TYPE,
        p_hist_seq_no           IN gicl_clm_res_hist.hist_seq_no%TYPE,
        p_user_id               IN gicl_claims.user_id%TYPE,
        p_loss_reserve          IN gicl_clm_reserve.loss_reserve%TYPE,
        p_exp_reserve           IN gicl_clm_reserve.expense_reserve%TYPE,
		p_currency_cd			IN gicl_clm_res_hist.currency_cd%TYPE,
		p_convert_rate			IN gicl_clm_res_hist.convert_rate%TYPE,
		p_booking_month			IN gicl_clm_res_hist.booking_month%TYPE,
		p_booking_year			IN gicl_clm_res_hist.booking_year%TYPE,
		p_dist_date				IN DATE
	) IS
		v_hist_seq_no		gicl_clm_res_hist.hist_seq_no%TYPE := 1;	-- variable to be use for storing hist_seq_no to be used by new reserve record
		v_hist_seq_no_old	gicl_clm_res_hist.hist_seq_no%TYPE := 0;	-- variable to be use for storing old hist_seq_no to be used for update of prev reserve and payments
		v_clm_res_hist		gicl_clm_res_hist.clm_res_hist_id%TYPE := 1;-- variable to be use for storing clm_res_hist_id to be used by new reserve record
		v_prev_loss_res		gicl_clm_res_hist.prev_loss_res%TYPE :=0;	-- variable to be use for storing previous loss reseve to be used by new reserve record
		v_prev_exp_res		gicl_clm_res_hist.prev_loss_res%TYPE :=0;	-- variable to be use for storing previous exp. reseve to be used by new reserve record  
		v_prev_loss_paid	gicl_clm_res_hist.prev_loss_res%TYPE :=0;	-- variable to be use for storing previous loss paid to be used by new reserve record  
		v_prev_exp_paid		gicl_clm_res_hist.prev_loss_res%TYPE :=0;	-- variable to be use for storing previous exp.paid to be used by new reserve record
	BEGIN
		FOR hist IN(
			SELECT NVL(MAX(NVL(hist_seq_no,0)),0) + 1 seq_no
			FROM gicl_clm_res_hist
			WHERE claim_id = p_claim_id
			AND item_no  = p_item_no
			AND peril_cd = p_peril_cd
			AND grouped_item_no = p_grouped_item_no)
		LOOP
			v_hist_seq_no := hist.seq_no;
			EXIT;
		END LOOP;
		
		FOR old_hist IN(	-- get prev hist_seq_no from gicl_clm_res_hist for update of previous amounts
			SELECT NVL(MAX(NVL(hist_seq_no,0)),0) seq_no
			FROM gicl_clm_res_hist
			WHERE claim_id = p_claim_id
			AND item_no  = p_item_no
			AND peril_cd = p_peril_cd
			AND grouped_item_no = p_grouped_item_no --added by gmi 02/23/06
			AND NVL(dist_sw,'N') = 'Y')
		LOOP
			v_hist_seq_no_old := old_hist.seq_no;
			EXIT;
		END LOOP; --end old_hist loop
		
  		FOR prev_amt IN( -- get prev amounts from gicl_clm_res_hist using old hist_seq_no for insert of new reserve record
    		SELECT nvl(loss_reserve,0) loss_reserve, 
					nvl(expense_reserve,0) expense_reserve,
					nvl(losses_paid,0)  losses_paid, 
					nvl(expenses_paid,0) expenses_paid
			FROM gicl_clm_res_hist
			WHERE claim_id = p_claim_id
			AND item_no = p_item_no
			AND peril_cd = p_peril_cd
			AND grouped_item_no = p_grouped_item_no --added by gmi 02/23/06
			AND hist_seq_no = v_hist_seq_no_old)
		LOOP
			v_prev_loss_res  := prev_amt.loss_reserve;
			v_prev_exp_res   := prev_amt.expense_reserve;
			v_prev_loss_paid := prev_amt.losses_paid;
			v_prev_exp_paid  := prev_amt.expenses_paid;
		END LOOP;  -- end prev_amt loop
		
		-- retrieve valid booking date for this record
		--get_booking_date;

		INSERT INTO gicl_clm_res_hist(claim_id, clm_res_hist_id, hist_seq_no, item_no, peril_cd, grouped_item_no, user_id,
				last_update, loss_reserve, expense_reserve, dist_sw, booking_month, booking_year,
				currency_cd, convert_rate, prev_loss_res, prev_loss_paid, prev_exp_res, prev_exp_paid, distribution_date)
		  VALUES(p_claim_id, v_clm_res_hist, v_hist_seq_no, p_item_no, p_peril_cd, p_grouped_item_no, user, SYSDATE,
				p_loss_reserve, p_exp_reserve, 'Y', p_booking_month, p_booking_year, p_currency_cd, p_convert_rate,	
				v_prev_loss_res, v_prev_loss_paid, v_prev_exp_res, v_prev_exp_paid, NVL(p_dist_date, SYSDATE));
		
		IF v_clm_res_hist = 1 THEN
			UPDATE gicl_claims
			SET clm_stat_cd = 'OP'
			WHERE claim_id = p_claim_id;
		END IF;    
		
		-- update previous distributed record in gicl_clm_res_hist set it's dist_sw = N and negate date = sysdate
		UPDATE gicl_clm_res_hist
		   SET dist_sw = 'N', negate_date = SYSDATE
		 WHERE claim_id = p_claim_id
		   AND item_no  = p_item_no
		   AND peril_cd = p_peril_cd
		   AND grouped_item_no = p_grouped_item_no --added by gmi 02/23/06
		   AND NVL(dist_sw, 'N') = 'Y';
		
		-- call procedure which will generate records in claims distribution tables gicl_reserve_ds and gicl_reserve_rids
  		process_distribution(v_clm_res_hist, v_hist_seq_no, p_claim_id, p_item_no, p_peril_cd, p_grouped_item_no);
		
	END create_new_reserve2;
	
	PROCEDURE gicls024_post_forms_commit(
        p_claim_id              IN gicl_claims.claim_id%TYPE
    ) IS 
        v_loss_amt		gicl_claims.loss_res_amt%TYPE;
        v_exp_amt		gicl_claims.exp_res_amt%TYPE;
        v_recovery_sw   gicl_claims.recovery_sw%TYPE;
    BEGIN
        
    /* IF v_redist_sw = 'Y' THEN
            gicl_clm_reserve_pkg.create_new_reserve2(p_claim_id, p_item_no, p_peril_cd, p_grouped_item_no, p_hist_seq_no,
                p_user_id, p_loss_reserve, p_exp_reserve, p_currency_cd, p_convert_rate, p_booking_month, p_booking_year, p_dist_date);
            gicl_clm_reserve_pkg.update_clm_dist_tag_gicls024(p_claim_id);
        END IF;*/  -- removed, not needed - irwin 6.21.2012
        
        FOR x IN (SELECT convert_rate, item_no, peril_cd, grouped_item_no 
					FROM gicl_clm_res_hist
	 			   WHERE claim_id = p_claim_id
		 			 AND clm_res_hist_id IN (
                                        SELECT MAX(clm_res_hist_id) 
		                                  FROM gicl_clm_res_hist
                                         WHERE claim_id = p_claim_id
                                         GROUP BY item_no, peril_cd, grouped_item_no))
        LOOP
   	        FOR sum_amt IN (
    	            SELECT SUM(loss_reserve * NVL(x.convert_rate,1)) loss_reserve,
     	                    SUM(expense_reserve * NVL(x.convert_rate,1)) exp_reserve
     	              FROM gicl_clm_reserve a, gicl_item_peril b
   	                 WHERE a.claim_id = b.claim_id
    	               AND a.item_no  = b.item_no
     	               AND a.peril_cd = b.peril_cd
                       AND a.grouped_item_no = b.grouped_item_no
                       AND a.item_no = x.item_no
                       AND a.peril_cd = x.peril_cd
                       AND a.grouped_item_no = x.grouped_item_no
                       AND a.claim_id = p_claim_id
                       AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP'))
  	        LOOP
    	        v_loss_amt := NVL(v_loss_amt,0) + sum_amt.loss_reserve;
    	        v_exp_amt  := NVL(v_exp_amt,0) + sum_amt.exp_reserve;
    	        EXIT;
  	        END LOOP;
        END LOOP;
    END;
    
    PROCEDURE gicls024_check_loss_rsrv(
        p_c007_claim_id          IN GICL_ITEM_PERIL.claim_id%TYPE,
        p_c007_item_no           IN GICL_ITEM_PERIL.item_no%TYPE,
        p_c007_peril_cd          IN GICL_ITEM_PERIL.peril_cd%TYPE,
        p_c007_grouped_item_no   IN GICL_ITEM_PERIL.grouped_item_no%TYPE,
        p_dsp_line_cd            IN GICL_CLAIMS.line_cd%TYPE,
        p_dsp_iss_cd             IN GICL_CLAIMS.iss_cd%TYPE,
        p_user_id                IN GIAC_USER_FUNCTIONS.user_id%TYPE,
        p_c022_loss_reserve      IN NUMBER,
        p_c022_expense_reserve   IN NUMBER,
        p_c017_convert_rate      IN NUMBER,
        p_message               OUT VARCHAR2
    )
     IS 
        validate_reserve        varchar2(1);
        all_res_sw              varchar2(1);
        res_amt                 gicl_adv_line_amt.res_range_to%TYPE;
        v_res_tot               gicl_adv_line_amt.res_range_to%TYPE := 0;  -- beth 08032006 variable to store total reserve
        ans                     NUMBER;
        goFlag                  BOOLEAN := TRUE;
        v_convert_rate          gicl_clm_res_hist.convert_rate%TYPE := 1; -- beth 08032006 variable to store item currency rate
        v_mod_id                NUMBER(3); -- consolidated by adrel 03152007 from pau's version gicls024-1172006
        v_or_cnt                NUMBER(3); -- consolidated by adrel 03152007 from pau's version gicls024-1172006
        v_func_cl_cd            NUMBER(12); -- consolidated by adrel 03152007 from pau's version gicls024-1172006
        v_override_approved_sw  varchar2(1):='N'; -- added by adrel. 'Y' if reserve override for the user exists. 03222007

    BEGIN
       p_message := 'SUCCESS';
       IF check_user_override_function (p_user_id, 'GICLS024', 'RO') = FALSE
       THEN
          BEGIN
             SELECT param_value_v
               INTO validate_reserve
               FROM giis_parameters
              WHERE param_name = 'VALIDATE_RESERVE_LIMITS';
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                --p_message := 'VALIDATE_RESERVE_LIMITS not found in giis_parameters';
                p_message := 1;
                RETURN;
          END;

          IF validate_reserve <> 'N'
          THEN
             FOR get_rate IN (SELECT currency_rate
                                FROM gicl_clm_item
                               WHERE claim_id = p_c007_claim_id
                                 AND item_no = p_c007_item_no)
             LOOP
                v_convert_rate := get_rate.currency_rate;
             END LOOP;

             BEGIN
                SELECT NVL (all_res_amt_sw, 'N')
                  INTO all_res_sw
                  FROM gicl_adv_line_amt
                 WHERE adv_user = p_user_id
                   AND line_cd = p_dsp_line_cd
                   AND iss_cd = p_dsp_iss_cd;
             EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                   --p_message := 'User is not allowed to make a reserve, please refer to the reserve maintenance';
                   p_message := 2;
                   RETURN;
             END;

             IF all_res_sw = 'N'
             THEN
                -- get total loss reserve for other item peril
                FOR get_tot IN (SELECT   NVL (a.loss_reserve, 0)
                                       * NVL (a.convert_rate, 1) loss
                                  FROM gicl_clm_res_hist a, gicl_item_peril b
                                 WHERE a.claim_id = b.claim_id
                                   AND a.item_no = b.item_no
                                   AND NVL (a.grouped_item_no, 0) =
                                                        NVL (b.grouped_item_no, 0)
                                   AND a.peril_cd = b.peril_cd
                                   AND a.claim_id = p_c007_claim_id
                                   AND (   a.item_no <> p_c007_item_no
                                        OR NVL (a.grouped_item_no, 0) <> NVL (p_c007_grouped_item_no, 0)
                                        OR a.peril_cd <> p_c007_peril_cd )
                                   AND NVL (a.dist_sw, 'N') = 'Y'
                                   AND a.tran_id IS NULL
                                   AND b.close_flag NOT IN ('DN', 'WD'))
                LOOP
                   v_res_tot := get_tot.loss;
                END LOOP;

                IF validate_reserve = 'Y'
                THEN
                   -- get total expense reserve for other item peril
                   FOR get_tot IN (SELECT   NVL (a.expense_reserve, 0)
                                          * NVL (a.convert_rate, 1) expense
                                     FROM gicl_clm_res_hist a, gicl_item_peril b
                                    WHERE a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no
                                      AND NVL (a.grouped_item_no, 0) = NVL (b.grouped_item_no, 0)
                                      AND a.peril_cd = b.peril_cd
                                      AND a.claim_id = p_c007_claim_id
                                      AND (   a.item_no <> p_c007_item_no
                                           OR NVL (a.grouped_item_no, 0) <> NVL (p_c007_grouped_item_no, 0)
                                           OR a.peril_cd <> p_c007_peril_cd )
                                      AND NVL (a.dist_sw, 'N') = 'Y'
                                      AND a.tran_id IS NULL
                                      AND b.close_flag2 NOT IN ('DN', 'WD'))
                   LOOP
                      v_res_tot := get_tot.expense;
                   END LOOP;
                END IF;

                BEGIN
                   SELECT NVL (res_range_to, 0)
                     INTO res_amt
                     FROM gicl_adv_line_amt
                    WHERE adv_user = p_user_id
                      AND line_cd = p_dsp_line_cd
                      AND iss_cd = p_dsp_iss_cd;

                   v_res_tot := v_res_tot + (  NVL (p_c022_loss_reserve, 0) * NVL (p_c017_convert_rate, v_convert_rate) );

                   IF validate_reserve = 'Y'
                   THEN
                      v_res_tot := v_res_tot + (  NVL (p_c022_expense_reserve, 0) * NVL (p_c017_convert_rate, v_convert_rate) );
                   END IF;

                   IF v_res_tot > res_amt
                   THEN
                      BEGIN
                         SELECT module_id
                           INTO v_mod_id
                           FROM giac_modules
                          WHERE module_name = 'GICLS024';
                      EXCEPTION
                         WHEN TOO_MANY_ROWS
                         THEN
                            NULL;
                      END;

                      BEGIN
                         SELECT function_col_cd
                           INTO v_func_cl_cd
                           FROM giac_function_columns
                          WHERE module_id = v_mod_id
                            AND function_cd = 'RO'
                            AND column_name = 'CLAIM_ID'; --p_c007_claim_id -IRWIN
                      EXCEPTION
                         WHEN NO_DATA_FOUND
                         THEN
                            NULL;
                      END;

                      BEGIN
                         SELECT 'Y'
                           INTO v_override_approved_sw
                           FROM gicl_function_override a
                          WHERE override_user IS NOT NULL
                            AND EXISTS (
                                   SELECT 1
                                     FROM gicl_function_override_dtl
                                    WHERE override_id = a.override_id
                                      AND function_col_cd = v_func_cl_cd
                                      AND function_col_val = p_c007_claim_id);
                      EXCEPTION
                         WHEN TOO_MANY_ROWS
                         THEN
                            v_override_approved_sw := 'Y';
                         WHEN NO_DATA_FOUND
                         THEN
                            v_override_approved_sw := 'N';
                      END;

                      IF NVL (v_override_approved_sw, 'N') <> 'Y' THEN
                         --p_message := 'override';
                         p_message := 3;
                         RETURN;
                      END IF;
                   END IF;
                EXCEPTION
                   WHEN NO_DATA_FOUND
                   THEN
                      NULL;
                END;
             END IF;
          END IF;
       END IF;
    END;
    
    FUNCTION gicls024_check_booking_date(p_claim_id gicl_claims.claim_id%TYPE)
    RETURN VARCHAR2
    IS
       v_exist           VARCHAR2(1) := 'N';
       v_loss_date       gicl_claims.loss_date%TYPE;
       v_clm_file_date   gicl_claims.clm_file_date%TYPE;
       v_max_acct_date   gicl_take_up_hist.acct_date%TYPE;
       v_max_post_date   gicl_take_up_hist.acct_date%TYPE;
    BEGIN
       SELECT a.loss_date, a.clm_file_date
         INTO v_loss_date, v_clm_file_date
         FROM gicl_claims a, giis_loss_ctgry b, giis_clm_stat c
        WHERE a.loss_cat_cd = b.loss_cat_cd
          AND a.line_cd = b.line_cd
          AND a.claim_id = p_claim_id
          AND c.clm_stat_cd = a.clm_stat_cd;

       FOR max_acct_date IN (SELECT TRUNC (MAX (acct_date), 'MONTH') acct_date
                               FROM gicl_take_up_hist d, giac_acctrans e
                              WHERE d.acct_tran_id = e.tran_id
                                AND e.tran_class = 'OL'
                                AND e.tran_flag NOT IN ('D', 'P'))
       LOOP
          v_max_acct_date := max_acct_date.acct_date;
       END LOOP;

       FOR max_post_date IN (SELECT TRUNC (MAX (acct_date), 'MONTH') acct_date
                               FROM gicl_take_up_hist d, giac_acctrans e
                              WHERE d.acct_tran_id = e.tran_id
                                AND e.tran_class = 'OL'
                                AND e.tran_flag = 'P')
       LOOP
          v_max_post_date := max_post_date.acct_date;
       END LOOP;

       IF v_max_post_date IS NOT NULL
       THEN
          FOR chk IN (SELECT   '*' exist
                          FROM giac_tran_mm a, gicl_claims b
                         WHERE b.claim_id = p_claim_id
                           AND ROWNUM <= 1
                           AND a.closed_tag = 'N'
                           AND a.branch_cd = giacp.v ('BRANCH_CD')
                           AND LAST_DAY (TO_DATE (   TO_CHAR (a.tran_mm)
                                                  || '-'
                                                  || TO_CHAR (a.tran_yr),
                                                  'MM-YYYY'
                                                 )
                                        ) >=
                                  TRUNC (DECODE (giacp.v ('RESERVE BOOKING'),
                                                 'L', v_loss_date,
                                                 v_clm_file_date
                                                ),
                                         'MONTH'
                                        )
                           AND TO_DATE (   '01-'
                                        || TO_CHAR (a.tran_mm)
                                        || '-'
                                        || TO_CHAR (a.tran_yr),
                                        'DD-MM-YYYY'
                                       ) >=
                                  NVL (v_max_acct_date,
                                       TO_DATE (   '01-'
                                                || TO_CHAR (a.tran_mm)
                                                || '-'
                                                || TO_CHAR (a.tran_yr),
                                                'DD-MM-YYYY'
                                               )
                                      )
                           AND TO_DATE (   '01-'
                                        || TO_CHAR (a.tran_mm)
                                        || '-'
                                        || TO_CHAR (a.tran_yr),
                                        'DD-MM-YYYY'
                                       ) > v_max_post_date
                      ORDER BY a.tran_yr ASC, a.tran_mm ASC)
          LOOP
             v_exist := 'Y';
             EXIT;
          END LOOP;
       ELSE
          FOR chk IN (SELECT   '*' exist
                          FROM giac_tran_mm a, gicl_claims b
                         WHERE b.claim_id = p_claim_id
                           AND ROWNUM <= 1
                           AND a.closed_tag = 'N'
                           AND a.branch_cd = giacp.v ('BRANCH_CD')
                           AND LAST_DAY (TO_DATE (   TO_CHAR (a.tran_mm)
                                                  || '-'
                                                  || TO_CHAR (a.tran_yr),
                                                  'MM-YYYY'
                                                 )
                                        ) >=
                                  TRUNC (DECODE (giacp.v ('RESERVE BOOKING'),
                                                 'L', v_loss_date,
                                                 v_clm_file_date
                                                ),
                                         'MONTH'
                                        )
                           AND TO_DATE (   '01-'
                                        || TO_CHAR (a.tran_mm)
                                        || '-'
                                        || TO_CHAR (a.tran_yr),
                                        'DD-MM-YYYY'
                                       ) >=
                                  NVL (v_max_acct_date,
                                       TO_DATE (   '01-'
                                                || TO_CHAR (a.tran_mm)
                                                || '-'
                                                || TO_CHAR (a.tran_yr),
                                                'DD-MM-YYYY'
                                               )
                                      )
                      ORDER BY a.tran_yr ASC, a.tran_mm ASC)
          LOOP
             v_exist := 'Y';
             EXIT;
          END LOOP;
       END IF;
          
       RETURN v_exist;
    END;
    
    FUNCTION gicls024_get_override_cnt(p_claim_id gicl_claims.claim_id%TYPE)
       RETURN VARCHAR2
    IS
       v_exist        VARCHAR2 (1);
       v_mod_id       giac_modules.module_id%TYPE;
       v_func_cl_cd   giac_function_columns.function_col_cd%TYPE;
       v_or_cnt       NUMBER;
    BEGIN
       SELECT module_id
         INTO v_mod_id                                                   
         FROM giac_modules
        WHERE module_name = 'GICLS024';

        BEGIN
            SELECT function_col_cd
              INTO v_func_cl_cd
              FROM giac_function_columns
             WHERE module_id = v_mod_id
               AND function_cd = 'RO'
               AND column_name = 'CLAIM_ID';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_func_cl_cd := 0;
        END;

       SELECT COUNT (override_id)
         INTO v_or_cnt                                                        
         FROM gicl_function_override_dtl a
        WHERE function_col_cd = v_func_cl_cd                                  
          AND function_col_val = p_claim_id                                 
          AND NOT EXISTS (
                   SELECT 1
                     FROM gicl_function_override
                    WHERE override_id = a.override_id
                          AND override_user IS NOT NULL);

       IF v_or_cnt > 0
       THEN
          v_exist := 'Y';
       ELSE
          v_exist := 'N';
       END IF;

       RETURN v_exist;
    END;
	
   FUNCTION get_curr_cd (p_claim_id  GICL_CLAIMS.claim_id%TYPE, p_item_no gicl_clm_item.item_no%TYPE)
   RETURN NUMBER
     AS
   v_currency_cd  gicl_clm_item.currency_cd%TYPE;
   BEGIN
   
      SELECT currency_cd
        INTO v_currency_cd
        FROM gicl_clm_item
       WHERE claim_id =  p_claim_id
         AND item_no = p_item_no; -- added by andrew - 11.27.2012
         
   RETURN v_currency_cd;
   END;
   
   FUNCTION get_curr_rt (p_claim_id  GICL_CLAIMS.claim_id%TYPE, p_item_no gicl_clm_item.item_no%TYPE)
   RETURN NUMBER
     AS
   v_currency_rate  gicl_clm_item.currency_rate%TYPE;
   BEGIN
   
      SELECT currency_rate
        INTO v_currency_rate
        FROM gicl_clm_item
       WHERE claim_id =  p_claim_id
         AND item_no = p_item_no; -- added by andrew - 11.27.2012
         
   RETURN v_currency_rate;
   END;
END gicl_clm_reserve_pkg;
/


