CREATE OR REPLACE PACKAGE BODY CPI.GIUTS003_PKG
    /*
    **  Created by        : bonok
    **  Date Created      : 02.21.2013
    **  Reference By      : GIUTS003 - SPOIL POLICY/ENDORSEMENT
    */
AS
    FUNCTION when_new_form_giuts003
    RETURN when_new_form_giuts003_tab PIPELINED AS
        res        when_new_form_giuts003_type;
    BEGIN
        FOR A IN (SELECT param_value_v 
                    FROM giac_parameters
                      WHERE param_name = 'ALLOW_SPOILAGE')
        LOOP  
            res.allow_spoilage := a.param_value_v;
            EXIT;
        END LOOP;
        
        FOR STAT IN (SELECT param_value_v cd
                       FROM giis_parameters
                      WHERE param_name = 'GICL_CLAIMS_CLM_STAT_CD_CANCELLED')
        LOOP
            res.clm_stat_cancel := stat.cd;
            EXIT;
        END LOOP;
        
        res.require_reason := giisp.v('REQUIRE_SPOILAGE_REASON');
        
        PIPE ROW(res);
    END when_new_form_giuts003;
    
    FUNCTION get_policy_giuts003_lov(
        p_line_cd           gipi_polbasic.line_cd%TYPE,
        p_subline_cd        gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          gipi_polbasic.renew_no%TYPE,
        p_user_id           giis_users.user_id%TYPE --added by reymon 05062013
    ) RETURN get_policy_giuts003_lov_tab PIPELINED AS
        res                 get_policy_giuts003_lov_type;
    BEGIN
        FOR i IN(SELECT a.policy_id,
                        a.line_cd|| '-' || 
                        a.subline_cd|| '-' ||
                        a.iss_cd|| '-' ||
                        LTRIM (TO_CHAR (a.issue_yy, '09'))|| '-' ||
                        LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))|| '-' ||
                        LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                        DECODE(endt_seq_no, 0, '', a.line_cd|| '-' ||
                                                   a.subline_cd|| '-' ||
                                                   a.endt_iss_cd|| '-' ||
                                                   LTRIM (TO_CHAR (a.endt_yy, '09'))|| '-' ||
                                                   LTRIM (TO_CHAR (a.endt_seq_no, '09999999'))) endt_no,
                        b.assd_name, a.spld_flag, a.line_cd, a.subline_cd, a.iss_cd, a. issue_yy,
                        a.pol_seq_no, a.renew_no, a.acct_ent_date, a.eff_date, a.expiry_date, a.spoil_cd,
                        a.spld_user_id, a.spld_date, a.spld_approval, a.endt_seq_no, a.pol_flag, a.endt_expiry_date,
                        a.prorate_flag, a.comp_sw, a.short_rt_percent
                   FROM gipi_polbasic a, giis_assured b
                  WHERE a.assd_no = b.assd_no
                    AND a.line_cd = NVL(p_line_cd, a.line_cd)
                    AND a.subline_cd = NVL(p_subline_cd, a.subline_cd)
                    AND a.iss_cd = NVL(p_iss_cd, a.iss_cd)
                    AND a.issue_yy = NVL(p_issue_yy, a.issue_yy)
                    AND a.pol_seq_no = NVL(p_pol_seq_no, a.pol_seq_no)
                    AND a.renew_no = NVL(p_renew_no, a.renew_no)                
                    --AND check_user_per_iss_cd(a.line_cd, NVL(p_iss_cd, a.iss_cd), 'GIUTS003') = 1
                    AND check_user_per_iss_cd2(a.line_cd, NVL(p_iss_cd, a.iss_cd), 'GIUTS003', p_user_id) = 1
                    --AND check_user_per_line(a.line_cd, NVL(p_iss_cd, a.iss_cd), 'GIUTS003') = 1
                    AND check_user_per_line2(a.line_cd, NVL(p_iss_cd, a.iss_cd), 'GIUTS003', p_user_id) = 1  
                    AND a.line_cd <> 'GD'
                    --AND a.spld_flag != '3' -- Removed by Joms Diago 05112013
                    AND A. POL_FLAG NOT IN ('X', '4') -- Dren 10192015 SR: 002060 - Spoilage of package policies should not be allowed if the status is canceled.
                  ORDER BY 1)
        LOOP
            res.policy_id        := i.policy_id;
            res.policy_no        := i.policy_no;
            res.endt_no          := i.endt_no;
            res.assd_name        := i.assd_name;
            res.line_cd          := i.line_cd;
            res.subline_cd       := i.subline_cd;
            res.iss_cd           := i.iss_cd;
            res.issue_yy         := i.issue_yy;
            res.pol_seq_no       := i.pol_seq_no;
            res.renew_no         := i.renew_no;
            res.acct_ent_date    := i.acct_ent_date;
            res.eff_date         := i.eff_date;
            res.expiry_date      := i.expiry_date;
            res.spld_flag        := i.spld_flag;
            res.spld_user_id     := i.spld_user_id;
            res.spld_date        := i.spld_date;
            res.spld_approval    := i.spld_approval;
            res.endt_seq_no      := i.endt_seq_no;
            res.spoil_cd         := i.spoil_cd;
            res.pol_flag         := i.pol_flag;
            res.endt_expiry_date := i.endt_expiry_date;
            res.prorate_flag     := i.prorate_flag;
            res.comp_sw          := i.comp_sw;
            res.short_rt_percent := i.short_rt_percent;
            
            FOR j IN (SELECT DECODE(rv_high_value, NULL, rv_low_value, i.spld_flag), rv_meaning
                        FROM cg_ref_codes
                       WHERE ((rv_high_value IS NULL
                               AND i.spld_flag IN (rv_low_value, rv_abbreviation)) 
                                OR (i.spld_flag BETWEEN rv_low_value 
                                    AND rv_high_value))
                         AND ROWNUM = 1
                         AND rv_domain = 'GIPI_POLBASIC.SPLD_FLAG')
            LOOP
                res.policy_status := i.spld_flag || ' - ' || j.rv_meaning;
            END LOOP;
            
            IF res.spoil_cd IS NOT NULL THEN
                FOR k IN (SELECT spoil_desc
                            FROM giis_spoilage_reason
                           WHERE spoil_cd = i.spoil_cd)
                LOOP
                    res.spoil_desc := k.spoil_desc;
                END LOOP;
            ELSE
                res.spoil_desc := NULL;
            END IF;
            
            PIPE ROW(res);
        END LOOP;                   
    END get_policy_giuts003_lov;
    
    FUNCTION get_spoil_cd_giuts003_lov
    RETURN get_spoil_cd_giuts003_lov_tab PIPELINED AS
        res             get_spoil_cd_giuts003_lov_type;
    BEGIN
        FOR i IN(SELECT spoil_cd, spoil_desc
                   FROM giis_spoilage_reason
                  WHERE active_tag = 'A' --added by carlo SR 5915 01-25-2017
                  ORDER BY spoil_desc)
        LOOP
            res.spoil_cd   := i.spoil_cd;
            res.spoil_desc := i.spoil_desc;
            
            PIPE ROW(res);
        END LOOP;
    END;        
    
    PROCEDURE spoil_policy_giuts003(
        p_user_id           IN  gipi_polbasic.user_id%TYPE,
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE,
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE,
        p_subline_cd        IN  gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            IN  gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          IN  gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        IN  gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          IN  gipi_polbasic.renew_no%TYPE,
        p_endt_seq_no       IN  gipi_polbasic.endt_seq_no%TYPE,
        p_eff_date          IN  gipi_polbasic.eff_date%TYPE,
        p_acct_ent_date     IN  gipi_polbasic.acct_ent_date%TYPE,
        p_spld_flag         IN OUT gipi_polbasic.spld_flag%TYPE,
        p_spoil_cd          IN  gipi_polbasic.spoil_cd%TYPE,
        p_require_reason    IN  giis_parameters.param_value_v%TYPE,
        p_pol_flag          IN  gipi_polbasic.pol_flag%TYPE,
        p_message           OUT VARCHAR2,
        p_cont              OUT VARCHAR2,
        p_policy_status     OUT VARCHAR2,
        p_spld_user_id      OUT gipi_polbasic.spld_user_id%TYPE,
        p_spld_date         OUT VARCHAR2
    ) AS
        v_iss_cd_param      giac_parameters.param_value_v%TYPE;
        v_iss_cd_ho            giis_parameters.param_value_v%TYPE;
        v_sw                giis_issource.ho_tag%TYPE;
        v_subline           giis_subline.subline_cd%TYPE; 
        v_restrict          VARCHAR2(1);
        v_claim_id            gicl_claims.claim_id%TYPE;
    BEGIN
        BEGIN
            SELECT param_value_v
              INTO v_iss_cd_param
              FROM giac_parameters
             WHERE param_name = 'BRANCH_CD';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        
        BEGIN
            SELECT param_value_v
              INTO v_iss_cd_ho
              FROM giis_parameters
             WHERE param_name = 'ISS_CD_HO';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param = v_iss_cd_ho THEN
            BEGIN
                SELECT ho_tag
                  INTO v_sw
                  FROM giis_issource
                 WHERE iss_cd = p_iss_cd;
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            
            IF v_sw = 'N' THEN
                RAISE_APPLICATION_ERROR('-20001', 'Geniisys Exception#I#'||p_iss_cd||' is not allowed to tag the record for spoilage.');
            END IF;
        END IF;
        
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param <>    v_iss_cd_ho THEN
            RAISE_APPLICATION_ERROR('-20001', 'Geniisys Exception#I#'||p_iss_cd||' is not allowed to tag the record for spoilage.');
        END IF; 
        
        FOR mop IN (SELECT a.param_value_v, b.param_value_v restrict_spoil
                      FROM giis_parameters a, giis_parameters b
                     WHERE a.param_name = 'SUBLINE_MN_MOP'
                       AND a.param_type = b.param_type
                       AND b.param_name = 'RESTRICT_SPOIL_OF_REC_WACCT_ENT_DATE')
        LOOP
            v_subline  := mop.param_value_v;
            v_restrict := mop.restrict_spoil;
            EXIT;
        END LOOP; 
        
        FOR a1 IN (SELECT claim_id
                     FROM gicl_claims
                    WHERE line_cd     = p_line_cd
                      AND subline_cd  = p_subline_cd
                      AND pol_iss_cd  = p_iss_cd
                      AND issue_yy    = p_issue_yy
                      AND pol_seq_no  = p_pol_seq_no
                      AND renew_no    = p_renew_no
                      AND loss_date   > p_eff_date
                      AND clm_stat_cd NOT IN ('CC','WD','DN','CD'))
        LOOP
            v_claim_id   :=  a1.claim_id;
            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#The policy has pending claims, cannot spoil policy/endorsement.');
            EXIT;
        END LOOP;
        
        check_paid_policy(p_policy_id, p_line_cd, p_iss_cd);
        
        FOR a IN (SELECT NVL(post_flag, 'N') post_flag, policy_id
                    FROM giex_expiry
                   WHERE line_cd     = p_line_cd
                     AND subline_cd  = p_subline_cd
                     AND iss_cd      = p_iss_cd
                     AND issue_yy    = p_issue_yy
                     AND pol_seq_no  = p_pol_seq_no
                     AND renew_no    = p_renew_no)
        LOOP
            IF a.post_flag = 'Y' THEN
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#This policy is already process for expiry, cannot spoil policy/endorsement.');
            ELSE
                DELETE FROM giex_old_group_tax
                      WHERE policy_id = a.policy_id;
                DELETE FROM giex_old_group_peril
                      WHERE policy_id = a.policy_id;                 
                DELETE FROM giex_new_group_tax
                      WHERE policy_id = a.policy_id;
                DELETE FROM giex_new_group_peril
                      WHERE policy_id = a.policy_id;                 
                DELETE FROM giex_itmperil
                      WHERE policy_id = a.policy_id;   
                DELETE FROM giex_old_group_itmperil     --added by Gzelle 12112014 SR 17828
                      WHERE policy_id = a.policy_id;
                DELETE FROM giex_old_group_deductibles  --added by kenneth 07132015 SR 4753
                      WHERE policy_id = a.policy_id;   
                DELETE FROM giex_new_group_deductibles   --added by kenneth 07132015 SR 4753
                      WHERE policy_id = a.policy_id;                                     
                DELETE FROM giex_expiry
                      WHERE policy_id = a.policy_id;                                  
            END IF;
            EXIT;
        END LOOP;
        
        p_cont := 'Y';
        IF p_acct_ent_date IS NOT NULL THEN
            IF v_restrict = 'Y' THEN
                p_message := 'Policy/Endorsement has been considered in Accounting on ' || TO_CHAR(p_acct_ent_date,'fmMonth DD, YYYY') || ', Cannot spoil policy.';
                p_cont := 'N';
            ELSE
                p_message := 'Policy/Endorsement has been considered in Accounting on ' || TO_CHAR(p_acct_ent_date,'fmMonth DD, YYYY') || ', Please inform Accounting of spoilage.';
            END IF;
        END IF;
        
        IF p_cont = 'Y' THEN
            IF p_subline_cd = v_subline THEN
                IF p_endt_seq_no = 0 THEN
                    check_mrn(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
                END IF;
            END IF;
            
            IF p_spld_flag = '3' THEN
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#This policy/endorsement has already been spoiled.');
            ELSIF p_spld_flag = '1' THEN
                IF (v_claim_id IS NULL) THEN
                    DECLARE
                        v_pol_flag       VARCHAR2(1);
                    BEGIN
                        FOR A3 IN (SELECT pol_flag
                                     FROM gipi_polbasic  
                                    WHERE line_cd     = p_line_cd
                                      AND subline_cd  = p_subline_cd
                                      AND iss_cd      = p_iss_cd
                                      AND issue_yy    = p_issue_yy
                                      AND pol_seq_no  = p_pol_seq_no
                                      AND renew_no    = p_renew_no)
                        LOOP
                            v_pol_flag := A3.pol_flag;
                            EXIT;
                        END LOOP;
                        
                        IF v_pol_flag = 'X' THEN
                            RAISE_APPLICATION_ERROR('-20001', 'Geniisys Exception#E#This policy/endorsement is already expired.');
                        END IF;
                    END; 
            
                    IF p_require_reason = 'Y' THEN
                        IF p_spoil_cd IS NULL THEN
                            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Please specify reason for spoilage.');          
                        END IF;
                    END IF;       
                    
                    check_endorsement(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_pol_flag, p_policy_id, p_endt_seq_no, p_eff_date);
      
                ELSE
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#The policy/endorsement has claims ... cannot spoil policy/endorsement.');
                END IF;      
            END IF;  
            
            giis_users_pkg.app_user := p_user_id;
            
            UPDATE gipi_polbasic
               SET spld_date = SYSDATE,
                   spld_user_id = p_user_id,
                   spld_flag = '2',
                   last_upd_date = SYSDATE,
                   spoil_cd = p_spoil_cd
             WHERE policy_id = p_policy_id;
             
            FOR i IN (SELECT DECODE(rv_high_value, NULL, rv_low_value, '2'), rv_meaning
                        FROM cg_ref_codes
                       WHERE ((rv_high_value IS NULL
                               AND '2' IN (rv_low_value, rv_abbreviation)) 
                                OR ('2' BETWEEN rv_low_value 
                                    AND rv_high_value))
                         AND ROWNUM = 1
                         AND rv_domain = 'GIPI_POLBASIC.SPLD_FLAG')
            LOOP
                p_policy_status := '2 - ' || i.rv_meaning;
            END LOOP;
            
            p_spld_user_id := p_user_id;
            p_spld_date := TO_CHAR(SYSDATE, 'DD-MON-YYYY');
            p_spld_flag := '2';
                        
        END IF;
        
    END spoil_policy_giuts003;
    
    PROCEDURE check_paid_policy(
        p_policy_id         gipi_polbasic.policy_id%TYPE,
        p_line_cd           gipi_polbasic.line_cd%TYPE,
        p_iss_cd            gipi_polbasic.iss_cd%TYPE
    ) AS
        v_policy_id            gipi_invoice.policy_id%TYPE;
        v_ri                gipi_polbasic.iss_cd%TYPE;
        v_prem_coll         giac_inwfacul_prem_collns.collection_amt%TYPE;
    BEGIN
        FOR RI IN (SELECT param_value_v cd
                     FROM giis_parameters
                    WHERE param_name = 'ISS_CD_RI')
        LOOP
            v_ri := ri.cd;
            EXIT;
        END LOOP;
        
        IF p_iss_cd != v_ri THEN
            FOR a1 IN (SELECT a.policy_id policy_id
                         FROM gipi_invoice a, giac_aging_soa_details b
                        WHERE a.policy_id        = p_policy_id
                          AND a.iss_cd           = b.iss_cd
                          AND a.prem_seq_no      = b.prem_seq_no
                          AND b.total_amount_due != b.balance_amt_due)
            LOOP
                v_policy_id  := a1.policy_id;
                EXIT;
            END LOOP;
            
            IF v_policy_id IS NOT NULL THEN       
                RAISE_APPLICATION_ERROR('-20001', 'Geniisys Exception#E#Paid policy/endorsement cannot be spoiled.');
            END IF;
        END IF;
        
        IF p_iss_cd = v_ri THEN
            FOR a1 IN (SELECT a.policy_id policy_id
                         FROM gipi_invoice a, giac_aging_ri_soa_details b
                        WHERE a.policy_id        = p_policy_id
                          AND b.gagp_aging_id    >= 0
                          AND a.iss_cd           = v_ri
                          AND a.prem_seq_no      = b.prem_seq_no
                          AND b.total_amount_due != b.balance_due)
            LOOP
                IF NVL(a1.policy_id,0) != 0 THEN
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Policy has collection(s) already from Cedant. Cannot spoil policy/endorsement.');
                END IF;
                EXIT;
            END LOOP;
        END IF;
        check_reinsurance_payment(p_policy_id, p_line_cd);
    END check_paid_policy;
    
    PROCEDURE check_reinsurance_payment(
        p_policy_id         gipi_polbasic.policy_id%TYPE,
        p_line_cd           gipi_polbasic.line_cd%TYPE
    ) AS
        v_param_value_n        giis_parameters.param_value_n%TYPE;
    BEGIN
        FOR a1 IN (SELECT param_value_n
                     FROM giis_parameters 
                    WHERE param_name = 'FACULTATIVE')
        LOOP
            v_param_value_n := a1.param_value_n;
            EXIT;
        END LOOP;
        
        IF v_param_value_n IS NOT NULL THEN
            FOR a2 IN (SELECT a.dist_no dist_no, a.dist_seq_no dist_seq_no, a.line_cd line_cd, a.share_cd share_cd
                         FROM giuw_pol_dist c, giuw_policyds_dtl a, giuw_policyds b
                        WHERE c.policy_id   = p_policy_id 
                          AND c.dist_no     = b.dist_no
                          AND c.negate_date IS NULL
                          AND a.dist_no     = b.dist_no
                          AND a.dist_seq_no = b.dist_seq_no
                          AND a.line_cd     = p_line_cd
                          AND a.share_cd    = v_param_value_n) 
            LOOP
                FOR a3 IN (SELECT c.fnl_binder_id, b.ri_cd
                             FROM giri_distfrps a, giri_frps_ri b, giri_binder c
                            WHERE a.dist_no       = a2.dist_no
                              AND a.dist_seq_no   = a2.dist_seq_no
                              AND a.frps_yy       = b.frps_yy
                              AND a.frps_seq_no   = b.frps_seq_no 
                              AND b.line_cd       = a2.line_cd
                              AND b.fnl_binder_id = c.fnl_binder_id
                              AND c.reverse_date IS NULL)
                LOOP
                    FOR a4 IN (SELECT SUM(NVL(a.disbursement_amt,0)) amt
                                 FROM giac_outfacul_prem_payts a, giac_acctrans b
                                WHERE a.a180_ri_cd         =  a3.ri_cd
                                  AND a.d010_fnl_binder_id =  a3.fnl_binder_id
                                  AND a.gacc_tran_id       =  b.tran_id
                                  AND b.tran_flag          <> 'D'        
                                  AND NOT EXISTS (SELECT '1'
                                                    FROM giac_reversals c, giac_acctrans d
                                                   WHERE a.gacc_tran_id      = c.gacc_tran_id
                                                     AND c.reversing_tran_id = d.tran_id
                                                     AND d.tran_flag         <> 'D'))
                    LOOP
                        IF a4.amt <> 0 THEN
                            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#This policy has collections from FACUL Reinsurers, Cannot spoil policy/endorsement');
                            EXIT;
                        END IF;                 
                    END LOOP;                                          
                END LOOP;   
            END LOOP;   
        END IF;
    END check_reinsurance_payment;
    
    PROCEDURE check_mrn(
        p_line_cd           gipi_polbasic.line_cd%TYPE,
        p_subline_cd        gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          gipi_polbasic.renew_no%TYPE
    ) AS
        v_exist             VARCHAR2(1) := 'N';
        v_subline           giis_subline.subline_cd%TYPE; 
    BEGIN
        FOR exist IN (SELECT 'a' 
                        FROM gipi_wopen_policy
                       WHERE op_subline_cd  = p_subline_cd
                         AND op_iss_cd      = p_iss_cd
                         AND op_issue_yy    = p_issue_yy
                         AND op_pol_seqno   = p_pol_seq_no
                         AND op_renew_no    = p_renew_no)
        LOOP
            v_exist := 'Y';
        END LOOP;

        FOR exist1 IN (SELECT 'a' 
                         FROM gipi_open_policy
                        WHERE op_subline_cd  = p_subline_cd
                          AND op_iss_cd      = p_iss_cd
                          AND op_issue_yy    = p_issue_yy
                          AND op_pol_seqno   = p_pol_seq_no
                          AND op_renew_no    = p_renew_no)
        LOOP
            v_exist := 'Y';
        END LOOP;

        FOR mop IN (SELECT subline_cd
                      FROM giis_subline
                     WHERE open_policy_sw = 'Y'
                       AND line_cd        = p_line_cd)
        LOOP
            v_subline := mop.subline_cd;
            EXIT;
        END LOOP;

        IF v_exist = 'Y' THEN
            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#MOP Policy/Endorsement has been used by another declaration policy ('||v_subline||').');
        END IF;
    END check_mrn;
    
    PROCEDURE check_endorsement(
        p_line_cd           gipi_polbasic.line_cd%TYPE,
        p_subline_cd        gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          gipi_polbasic.renew_no%TYPE,
        p_pol_flag          gipi_polbasic.pol_flag%TYPE,
        p_policy_id         gipi_polbasic.policy_id%TYPE,
        p_endt_seq_no       gipi_polbasic.endt_seq_no%TYPE,
        p_eff_date          gipi_polbasic.eff_date%TYPE
    ) AS
        v_eff_date              gipi_polbasic.eff_date%TYPE;
        v_endt_type              gipi_polbasic.endt_type%TYPE := 'E';
        v_endt_seq_no        gipi_polbasic.endt_seq_no%TYPE;
        v_exist             VARCHAR2(1) := 'N';
        v_cancel_sw         VARCHAR2(1) := 'N';
        
        v_eff_date2            gipi_polbasic.eff_date%TYPE;
    BEGIN
        FOR A0 IN (SELECT eff_date,endt_type, endt_seq_no
                     FROM gipi_polbasic
                    WHERE policy_id = p_policy_id
                      AND pol_flag   IN ('1','2','3','4')
                      AND spld_flag  != '3'
                 ORDER BY eff_date DESC, endt_seq_no DESC) 
        LOOP
            v_eff_date2    := A0.eff_date;
            EXIT;
        END LOOP;
        
        FOR A1 IN (SELECT eff_date,endt_type, endt_seq_no
                     FROM gipi_polbasic
                    WHERE line_cd    = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd     = p_iss_cd
                      AND issue_yy   = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no   = p_renew_no
                      AND pol_flag   IN ('1','2','3','4')
                      AND spld_flag  != '3'
                 ORDER BY eff_date DESC, endt_seq_no DESC) 
        LOOP
            v_eff_date    := A1.eff_date;
            v_endt_seq_no := A1.endt_seq_no;
            v_endt_type   := A1.endt_type;
            EXIT;
        END LOOP;
        
        FOR A2 IN (SELECT '1'
                     FROM gipi_wpolbas
                    WHERE line_cd    = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd     = p_iss_cd
                      AND issue_yy   = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no   = p_renew_no) 
        LOOP
            v_exist := 'Y'; 
            EXIT;
        END LOOP;
        
        IF v_exist = 'Y' THEN
            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Policy/Endorsement cannot be spoiled, creation of endorsement connected to this record is on going.');
        END IF;

        IF p_pol_flag = '4' THEN
            FOR A IN (SELECT '1'
                        FROM gipi_polbasic
                         WHERE policy_id = p_policy_id
                         AND ann_tsi_amt = 0                  
                         AND old_pol_flag IS NULL)
            LOOP 
                v_cancel_sw := 'Y';
                EXIT;
            END LOOP;
     
            IF v_cancel_sw = 'N' THEN
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#You cannot spoil a cancelled record if it is not the cancelling endorsement.');
            END IF;   
        ELSIF (TO_DATE(v_eff_date) = TO_DATE(p_eff_date) AND v_endt_seq_no = p_endt_seq_no ) OR (v_endt_type IS NULL AND NVL(v_endt_seq_no,0) = 0) THEN  
            NULL;      
        ELSE
            IF NVL(p_endt_seq_no,0) = 0 AND p_pol_flag IN ('1','2','3') THEN
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Policy with existing valid ensorsement cannot be spoiled.');
            ELSE                                                                     
                FOR CHK IN (SELECT '1'
                              FROM gipi_polbasic b250, gipi_itmperil  b380
                             WHERE 1 = 1 
                               AND b250.policy_id       = b380.policy_id
                               AND b250.line_cd         = p_line_cd
                               AND b250.subline_cd      = p_subline_cd
                               AND b250.iss_cd          = p_iss_cd
                               AND b250.issue_yy        = p_issue_yy
                               AND b250.pol_seq_no      = p_pol_seq_no
                               AND b250.renew_no        = p_renew_no
                               AND TO_DATE(b250.eff_date, 'dd-MON-yy') > TO_DATE(p_eff_date, 'dd-MON-yy')
                               AND NVL(b380.tsi_amt,0)  <> 0 
                               AND NVL(b380.prem_amt,0) <> 0
                               AND b250.pol_flag        IN ('1','2','3'))
                LOOP
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#Only non-affecting and affecting endorsement insignificant to endorsements later than this record can be spoiled.');
                END LOOP;  
            END IF;
        END IF;     
    END check_endorsement;
    
    PROCEDURE unspoil_policy_giuts003(
        p_iss_cd            IN  gipi_polbasic.iss_cd%TYPE,
        p_spld_flag         IN  gipi_polbasic.spld_flag%TYPE,
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE,
        p_policy_status     OUT VARCHAR2
    ) AS
        v_sw                 giis_issource.ho_tag%TYPE;
        v_iss_cd_param        giac_parameters.param_value_v%TYPE;
        v_iss_cd_ho            giis_parameters.param_value_v%TYPE;
    BEGIN
        BEGIN
            SELECT param_value_v
              INTO v_iss_cd_param
              FROM giac_parameters
             WHERE param_name = 'BRANCH_CD';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        
        BEGIN
            SELECT param_value_v
              INTO v_iss_cd_ho
              FROM giis_parameters
             WHERE param_name = 'ISS_CD_HO';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param = v_iss_cd_ho THEN
            BEGIN
                SELECT ho_tag
                  INTO v_sw
                  FROM giis_issource
                 WHERE iss_cd = p_iss_cd;
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            
            IF v_sw = 'N' THEN
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#'||p_iss_cd||' is not allowed to unspoil the record.');
            END IF;
        END IF;
        
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param <> v_iss_cd_ho THEN    
            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#'||p_iss_cd||' is not allowed to unspoil the record.');         
        END IF;
        
        IF p_spld_flag = '2' THEN
            UPDATE gipi_polbasic
               SET spld_flag    = '1',
                   spld_date    = NULL,
                   spld_user_id = NULL,
                   spoil_cd     = NULL
             WHERE policy_id    = p_policy_id;
        ELSE
            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Policy/Endorsement is not tagged for spoilage. Not Unspoiled.');
        END IF;  
        
        FOR i IN (SELECT DECODE(rv_high_value, NULL, rv_low_value, '1'), rv_meaning
                    FROM cg_ref_codes
                   WHERE ((rv_high_value IS NULL
                           AND '1' IN (rv_low_value, rv_abbreviation)) 
                            OR ('1' BETWEEN rv_low_value 
                                AND rv_high_value))
                     AND ROWNUM = 1
                     AND rv_domain = 'GIPI_POLBASIC.SPLD_FLAG')
        LOOP
            p_policy_status := '1 - ' || i.rv_meaning;
        END LOOP;
        
    END unspoil_policy_giuts003;
    
    PROCEDURE post_policy_giuts003(
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE,
        p_subline_cd        IN  gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            IN  gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          IN  gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        IN  gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          IN  gipi_polbasic.renew_no%TYPE,
        p_eff_date          IN  gipi_polbasic.eff_date%TYPE,
        p_acct_ent_date     IN  gipi_polbasic.acct_ent_date%TYPE,
        p_spld_flag         IN OUT gipi_polbasic.spld_flag%TYPE,
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE,
        p_endt_expiry_date  IN  gipi_polbasic.endt_expiry_date%TYPE,
        p_prorate_flag      IN  gipi_polbasic.prorate_flag%TYPE,
        p_comp_sw           IN  gipi_polbasic.comp_sw%TYPE,
        p_short_rt_percent  IN  gipi_polbasic.short_rt_percent%TYPE,
        p_user_id           IN  gipi_polbasic.user_id%TYPE,
        p_exist             OUT VARCHAR2,
        p_message           OUT VARCHAR2,
        p_cont              OUT VARCHAR2,
        p_policy_status     OUT VARCHAR2,
        p_spld_user_id      OUT gipi_polbasic.spld_user_id%TYPE,
        p_spld_date         OUT VARCHAR2,
        p_spld_approval     OUT gipi_polbasic.spld_approval%TYPE
    ) AS
        v_iss_cd_param      giac_parameters.param_value_v%TYPE;
        v_iss_cd_ho            giis_parameters.param_value_v%TYPE;
        v_sw                giis_issource.ho_tag%TYPE;
        v_claim_id            gicl_claims.claim_id%TYPE;
        v_message           VARCHAR2(100);
        v_cont              VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT param_value_v
              INTO v_iss_cd_param
              FROM giac_parameters
             WHERE param_name = 'BRANCH_CD';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
  
        BEGIN
            SELECT param_value_v
              INTO v_iss_cd_ho
              FROM giis_parameters
             WHERE param_name = 'ISS_CD_HO';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param = v_iss_cd_ho THEN
            BEGIN
                SELECT ho_tag
                  INTO v_sw
                  FROM giis_issource
                 WHERE iss_cd = p_iss_cd;
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            
            IF v_sw = 'N' THEN
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#'||p_iss_cd||' is not allowed to post the spoiled policy/endorsement.');
            END IF;
        END IF;
        
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param <> v_iss_cd_ho THEN
            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#'||p_iss_cd||' is not allowed to post the spoiled policy/endorsement.');
        END IF; 
        
        IF check_user_per_line2(p_line_cd, p_iss_cd, 'GIUTS003',p_user_id) <> 1 THEN -- added user_id by robert 01.10.14
            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#You are not allowed to post this spoiled policy/endorsement.');
        END IF;
        
        p_exist := 'N';
        
        FOR A1 IN (SELECT claim_id
                     FROM gicl_claims
                    WHERE line_cd     = p_line_cd
                      AND subline_cd  = p_subline_cd
                      AND pol_iss_cd  = p_iss_cd
                      AND issue_yy    = p_issue_yy
                      AND pol_seq_no  = p_pol_seq_no
                      AND renew_no    = p_renew_no
                      AND (loss_date  >= p_eff_date))
        LOOP
            v_claim_id :=  A1.claim_id;
            p_exist    := 'Y';
            EXIT;                
        END LOOP;
        
        IF p_exist = 'N' THEN
            post_policy2_giuts003(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
                                  p_eff_date, p_acct_ent_date, p_spld_flag, p_policy_id, p_endt_expiry_date,
                                  p_prorate_flag, p_comp_sw, p_short_rt_percent, p_user_id, 'N', p_message, p_cont,
                                  p_policy_status, p_spld_user_id, p_spld_date, p_spld_approval);
        END IF;
        
        p_message := 'SUCCESS';
    END post_policy_giuts003;
    
    PROCEDURE post_policy2_giuts003(
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE,
        p_subline_cd        IN  gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            IN  gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          IN  gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        IN  gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          IN  gipi_polbasic.renew_no%TYPE,
        p_eff_date          IN  gipi_polbasic.eff_date%TYPE,
        p_acct_ent_date     IN  gipi_polbasic.acct_ent_date%TYPE,
        p_spld_flag         IN OUT gipi_polbasic.spld_flag%TYPE,
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE,
        p_endt_expiry_date  IN  gipi_polbasic.endt_expiry_date%TYPE,
        p_prorate_flag      IN  gipi_polbasic.prorate_flag%TYPE,
        p_comp_sw           IN  gipi_polbasic.comp_sw%TYPE,
        p_short_rt_percent  IN  gipi_polbasic.short_rt_percent%TYPE,
        p_user_id           IN  gipi_polbasic.user_id%TYPE,
        p_alert             IN  VARCHAR2,
        p_message           OUT VARCHAR2,
        p_cont              OUT VARCHAR2,
        p_policy_status     OUT VARCHAR2,
        p_spld_user_id      OUT gipi_polbasic.spld_user_id%TYPE,
        p_spld_date         OUT VARCHAR2,
        p_spld_approval     OUT gipi_polbasic.spld_approval%TYPE
    ) AS
        v_restrict          VARCHAR2(1);
    BEGIN
        IF p_alert = 'Y' THEN 
            UPDATE gicl_claims
                SET refresh_sw = 'Y'
              WHERE line_cd     = p_line_cd
               AND subline_cd  = p_subline_cd
               AND pol_iss_cd  = p_iss_cd
               AND issue_yy    = p_issue_yy
               AND pol_seq_no  = p_pol_seq_no
               AND renew_no    = p_renew_no
               AND (loss_date  >= p_eff_date);
        END IF;
        
        check_paid_policy(p_line_cd, p_iss_cd, p_policy_id);
        
        FOR A IN (SELECT NVL(post_flag, 'N') post_flag, policy_id
                    FROM giex_expiry
                   WHERE line_cd     = p_line_cd
                     AND subline_cd  = p_subline_cd
                     AND iss_cd      = p_iss_cd
                     AND issue_yy    = p_issue_yy
                     AND pol_seq_no  = p_pol_seq_no
                     AND renew_no    = p_renew_no)
        LOOP
            IF a.post_flag = 'Y' THEN
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#This policy is already process for expiry, cannot spoil policy/endorsement.');
            ELSE
                DELETE FROM giex_old_group_tax
                    WHERE policy_id = a.policy_id;
                DELETE FROM giex_old_group_peril
                    WHERE policy_id = a.policy_id;                 
                DELETE FROM giex_new_group_tax
                    WHERE policy_id = a.policy_id;
                DELETE FROM giex_new_group_peril
                    WHERE policy_id = a.policy_id;                 
                DELETE FROM giex_itmperil
                    WHERE policy_id = a.policy_id; 
                DELETE FROM giex_old_group_itmperil     --added by kenneth 07132015 SR 4753
                      WHERE policy_id = a.policy_id;
                DELETE FROM giex_old_group_deductibles  --added by kenneth 07132015 SR 4753
                      WHERE policy_id = a.policy_id;   
                DELETE FROM giex_new_group_deductibles  --added by kenneth 07132015 SR 4753
                      WHERE policy_id = a.policy_id;                 
                DELETE FROM giex_expiry
                    WHERE policy_id = a.policy_id;                                  
            END IF;
            EXIT;
        END LOOP;
        
        FOR a IN (SELECT param_value_v restrict_spoil
                     FROM giis_parameters
                      WHERE param_name = 'RESTRICT_SPOIL_OF_REC_WACCT_ENT_DATE')
        LOOP
            v_restrict := a.restrict_spoil;
            EXIT;
        END LOOP;
        
        p_cont := 'Y';
        IF p_acct_ent_date IS NOT NULL THEN
              IF v_restrict = 'Y' THEN
                p_message := 'Policy/Endorsement has been considered in Accounting on ' || TO_CHAR(p_acct_ent_date, 'fmMonth DD, YYYY') || ', Cannot spoil policy.';
                p_cont := 'N';
            ELSE
                p_message := 'Policy/Endorsement has been considered in Accounting on ' || TO_CHAR(p_acct_ent_date, 'fmMonth DD, YYYY') || ', Please inform Accounting of spoilage.';
            END IF;
        END IF;
        
        IF p_cont = 'Y' THEN
            IF p_spld_flag = '2' THEN
                FOR A2 IN (SELECT dist_no
                             FROM giuw_pol_dist
                            WHERE policy_id = p_policy_id) 
                LOOP
                    check_reinsurance(A2.dist_no, p_line_cd);
                END LOOP;  
                
                FOR A2 IN (SELECT dist_no
                             FROM giuw_pol_dist
                            WHERE policy_id = p_policy_id)
                LOOP
                    UPDATE giuw_pol_dist
                       SET negate_date = SYSDATE,
                           dist_flag   = '4'
                     WHERE policy_id   = p_policy_id
                       AND dist_no  = a2.dist_no;
                END LOOP;

                FOR A1 IN(SELECT pol_flag
                            FROM gipi_polbasic
                           WHERE policy_id = p_policy_id)
                LOOP
                    IF A1.pol_flag = '4' THEN
                        UPDATE gipi_polbasic
                           SET pol_flag = old_pol_flag
                         WHERE line_cd    = p_line_cd
                           AND subline_cd = p_subline_cd
                           AND iss_cd     = p_iss_cd
                           AND issue_yy   = p_issue_yy
                           AND pol_seq_no = p_pol_seq_no    
                           AND renew_no   = p_renew_no
                           AND pol_flag   != '5'
                           AND policy_id  != p_policy_id;
                    END IF;
                    EXIT;
                END LOOP;
           
                UPDATE eim_takeup_info
                   SET eim_flag = DECODE(eim_flag, NULL, '3', '1', '3', '2', '5', '4', '5', eim_flag)
                 WHERE policy_id = p_policy_id;
      
                FOR x IN (SELECT ann_tsi_amt, pol_flag
                            FROM gipi_polbasic
                           WHERE policy_id = p_policy_id)
                LOOP           
                    IF x.ann_tsi_amt != 0 AND x.pol_flag != '4' THEN
                        update_affected_endt(p_policy_id, p_prorate_flag, p_comp_sw, p_endt_expiry_date, p_eff_date, p_short_rt_percent,
                                             p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
                    END IF;
                END LOOP;  
      
                UPDATE gipi_polbasic
                   SET eis_flag = 'N'
                 WHERE policy_id = p_policy_id;    
                
                giis_users_pkg.app_user := p_user_id;
                 
                UPDATE gipi_polbasic
                   SET pol_flag      = '5',
                       dist_flag     = '4',
                       last_upd_date = SYSDATE,
                       spld_flag     = '3',
                       spld_date     = SYSDATE,
                       spld_user_id  = p_user_id,
                       spld_approval = p_user_id
                 WHERE policy_id     = p_policy_id;
                
                FOR A2 IN (SELECT dist_no
                             FROM giuw_pol_dist
                            WHERE policy_id = p_policy_id)
                LOOP
                    UPDATE giuw_pol_dist
                       SET negate_date = SYSDATE,
                           dist_flag   = '4'
                     WHERE policy_id   = p_policy_id
                       AND dist_no  = a2.dist_no;
                END LOOP;   
                
                FOR i IN (SELECT DECODE(rv_high_value, NULL, rv_low_value, '3'), rv_meaning
                        FROM cg_ref_codes
                       WHERE ((rv_high_value IS NULL
                               AND '3' IN (rv_low_value, rv_abbreviation)) 
                                OR ('3' BETWEEN rv_low_value 
                                    AND rv_high_value))
                         AND ROWNUM = 1
                         AND rv_domain = 'GIPI_POLBASIC.SPLD_FLAG')
                LOOP
                    p_policy_status := '3 - ' || i.rv_meaning;
                END LOOP;
                
                p_spld_user_id := p_user_id;
                p_spld_date := TO_CHAR(SYSDATE, 'DD-MON-YYYY');
                p_spld_flag := '3';
                p_spld_approval := p_user_id;            

            ELSIF p_spld_flag = '1' THEN
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Policy/Endorsement has not yet been tagged for spoilage, cannot post.');
            ELSE
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Policy/Endorsement has been spoiled.');
            END IF;
        END IF;
        
    END post_policy2_giuts003;
    
    PROCEDURE check_paid_policy(
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE,
        p_iss_cd            IN  gipi_polbasic.iss_cd%TYPE,
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE
    ) AS
        v_policy_id            gipi_invoice.policy_id%TYPE;
        v_ri                gipi_polbasic.iss_cd%TYPE;
    BEGIN
        FOR RI IN (SELECT param_value_v cd
                     FROM giis_parameters
                    WHERE param_name = 'ISS_CD_RI')
        LOOP
              v_ri := ri.cd;
              EXIT;
        END LOOP;
        
        IF p_iss_cd != v_ri THEN
            FOR A1 IN (SELECT a.policy_id policy_id
                         FROM gipi_invoice a, giac_aging_soa_details b
                        WHERE a.policy_id        = p_policy_id
                          AND a.iss_cd           = b.iss_cd
                          AND a.prem_seq_no      = b.prem_seq_no
                          AND b.total_amount_due != b.balance_amt_due)
            LOOP
                v_policy_id  := A1.policy_id;
                EXIT;
            END LOOP;

            IF v_policy_id IS NOT NULL THEN
                RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#Paid policy/endorsement cannot be spoiled.');
            END IF;
        END IF;
        
        IF p_iss_cd = v_ri THEN
            FOR A1 IN (SELECT a.policy_id policy_id
                         FROM gipi_invoice a, giac_aging_ri_soa_details b
                        WHERE a.policy_id        = p_policy_id
                          AND b.gagp_aging_id    >= 0
                          AND a.iss_cd           = v_ri
                          AND a.prem_seq_no      = b.prem_seq_no
                          AND b.total_amount_due != b.balance_due)
            LOOP
                IF NVL(a1.policy_id,0) != 0 THEN
                    RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#Policy has collection(s) already from Cedant. Cannot spoil policy/endorsement.');
                END IF;
                EXIT;
            END LOOP;
        END IF;
        check_reinsurance_payment(p_line_cd, p_policy_id);
    END check_paid_policy;
    
    PROCEDURE check_reinsurance_payment(
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE,
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE
    ) AS
        v_param_value_n        giis_parameters.param_value_n%TYPE;
    BEGIN
        FOR A1 IN (SELECT param_value_n
                     FROM giis_parameters 
                    WHERE param_name = 'FACULTATIVE')
        LOOP
            v_param_value_n  :=  A1.param_value_n;
            EXIT;
        END LOOP;
        
        IF v_param_value_n IS NOT NULL THEN
            FOR A2 IN (SELECT a.dist_no dist_no, a.dist_seq_no dist_seq_no,
                              a.line_cd line_cd, a.share_cd share_cd
                         FROM giuw_pol_dist c, giuw_policyds_dtl a, giuw_policyds b
                        WHERE c.policy_id   = p_policy_id 
                          AND c.dist_no     = b.dist_no
                          AND c.negate_date IS NULL
                          AND a.dist_no     = b.dist_no
                          AND a.dist_seq_no = b.dist_seq_no
                          AND a.line_cd     = p_line_cd
                          AND a.share_cd    = v_param_value_n) 
            LOOP
                FOR A3 IN (SELECT c.fnl_binder_id, b.ri_cd
                             FROM giri_distfrps a, giri_frps_ri b, giri_binder c
                            WHERE a.dist_no       = a2.dist_no
                              AND a.dist_seq_no   = a2.dist_seq_no
                              AND a.frps_yy       = b.frps_yy
                              AND a.frps_seq_no   = b.frps_seq_no 
                              AND b.line_cd       = a2.line_cd
                              AND b.fnl_binder_id = c.fnl_binder_id
                              AND c.reverse_date  IS NULL)
                LOOP
                    FOR A4 IN (SELECT SUM(NVL(a.disbursement_amt,0)) amt
                                 FROM giac_outfacul_prem_payts a, giac_acctrans b
                                WHERE a.a180_ri_cd         =  a3.ri_cd
                                  AND a.d010_fnl_binder_id =  a3.fnl_binder_id
                                  AND a.gacc_tran_id       =  b.tran_id
                                  AND b.tran_flag          <> 'D'        
                                  AND NOT EXISTS (SELECT '1'
                                                    FROM giac_reversals c, giac_acctrans d
                                                   WHERE a.gacc_tran_id      = c.gacc_tran_id
                                                     AND c.reversing_tran_id =  d.tran_id
                                                     AND d.tran_flag         <> 'D'))
                    LOOP
                         IF a4.amt <> 0 THEN
                             RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#This policy has collections from FACUL Reinsurers, Cannot spoil policy/endorsement');
                             EXIT;
                        END IF;                 
                    END LOOP;                                          
                END LOOP;   
            END LOOP;   
        END IF;
    END check_reinsurance_payment;
    
    PROCEDURE check_reinsurance(
        p_dist_no           IN  NUMBER,
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE
    ) AS
        v_param_value_n        giis_parameters.param_value_n%TYPE;
        v_dist_no            giuw_policyds_dtl.dist_no%TYPE;
        v_dist_seq_no        giuw_policyds_dtl.dist_seq_no%TYPE;
        v_line_cd            giuw_policyds_dtl.line_cd%TYPE;
        v_share_cd            giuw_policyds_dtl.share_cd%TYPE;
        v_frps_yy            giri_distfrps.frps_yy%TYPE;
        v_frps_seq_no        giri_distfrps.frps_seq_no%TYPE;
        v_fnl_binder_id        giri_frps_ri.fnl_binder_id%TYPE;
        v_fnl_binder_id1    giri_binder.fnl_binder_id%TYPE;
    BEGIN
        FOR A1 IN (SELECT param_value_n
                     FROM giis_parameters 
                    WHERE param_name = 'FACULTATIVE')
        LOOP
            v_param_value_n := A1.param_value_n;
            EXIT;
        END LOOP;
        
        IF v_param_value_n IS NOT NULL THEN
            FOR A2 IN (SELECT a.dist_no dist_no, a.dist_seq_no  dist_seq_no, a.line_cd line_cd, a.share_cd share_cd
                         FROM giuw_policyds_dtl a, giuw_policyds b
                        WHERE a.dist_no     = b.dist_no
                          AND a.dist_seq_no = b.dist_seq_no
                          AND a.line_cd     = p_line_cd
                          AND a.dist_no     = p_dist_no
                          AND a.share_cd    = v_param_value_n)
            LOOP
                v_dist_no     :=  A2.dist_no;
                v_dist_seq_no :=  A2.dist_seq_no;
                v_line_cd     :=  A2.line_cd;
                v_share_cd    :=  A2.share_cd;
                
                FOR A3 IN (SELECT frps_yy, frps_seq_no
                             FROM giri_distfrps
                            WHERE dist_no     = v_dist_no
                              AND dist_seq_no = v_dist_seq_no)
                LOOP
                    v_frps_yy      :=  A3.frps_yy;
                    v_frps_seq_no  :=  A3.frps_seq_no;
              
                    FOR A4 IN (SELECT fnl_binder_id
                                 FROM giri_frps_ri
                                WHERE frps_yy     = v_frps_yy
                                  AND frps_seq_no = v_frps_seq_no 
                                  AND line_cd     = v_line_cd)
                    LOOP
                        v_fnl_binder_id   :=  A4.fnl_binder_id;
                   
                        FOR A5 IN(SELECT '1'
                                    FROM giri_binder
                                   WHERE fnl_binder_id = v_fnl_binder_id
                                     AND reverse_date IS NULL)
                        LOOP 
                            UPDATE giri_binder
                               SET reverse_date = SYSDATE
                             WHERE fnl_binder_id = v_fnl_binder_id;
                            EXIT;
                        END LOOP;
                    END LOOP;
                END LOOP;   
            END LOOP;   
        END IF;
    END check_reinsurance;
    
    PROCEDURE update_affected_endt(
        p_policy_id         IN  gipi_polbasic.policy_id%TYPE,
        p_prorate_flag        IN  gipi_polbasic.prorate_flag%TYPE,
        p_comp_sw           IN  gipi_polbasic.comp_sw%TYPE,
        p_endt_expiry_date  IN  gipi_polbasic.endt_expiry_date%TYPE,
        p_eff_date          IN  gipi_polbasic.eff_date%TYPE,
        p_short_rt_percent  IN  gipi_polbasic.short_rt_percent%TYPE,
        p_line_cd           IN  gipi_polbasic.line_cd%TYPE,
        p_subline_cd        IN  gipi_polbasic.subline_cd%TYPE,
        p_iss_cd            IN  gipi_polbasic.iss_cd%TYPE,
        p_issue_yy          IN  gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no        IN  gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no          IN  gipi_polbasic.renew_no%TYPE
    ) AS
        v_comp_prem NUMBER; --gipi_witmperl.tsi_amt%TYPE;
        v_prorate NUMBER; --gipi_witmperl.prem_rt%TYPE;
    BEGIN
        FOR itmperl IN (SELECT b480.item_no, b480.currency_rt, a170.peril_type,
                               b490.peril_cd, b490.tsi_amt, b490.prem_amt,
                               b250.endt_seq_no --vpsalud 12.14.15 kb#2011 UCPBGEN 21045
                          FROM gipi_item b480, giis_peril a170, gipi_itmperil b490,
                               gipi_polbasic b250--vpsalud 12.14.15 kb#2011 UCPBGEN 21045
                         WHERE 1=1
                           AND b250.policy_id = b480.policy_id--vpsalud 12.14.15 kb#2011 UCPBGEN 21045
                           AND b480.policy_id = b490.policy_id
                           AND b480.item_no =b490.item_no
                           AND b490.line_cd = a170.line_cd
                           AND b490.peril_cd = a170.peril_cd
                           AND b490.policy_id = p_policy_id)
        LOOP
            v_comp_prem := NULL;
            IF NVL(p_prorate_flag, 2) = 1 THEN
                IF p_comp_sw = 'Y' THEN
                    v_prorate := ((TRUNC(p_endt_expiry_date) - TRUNC(p_eff_date)) + 1 )/(ADD_MONTHS(p_eff_date, 12) - p_eff_date);
                ELSIF p_comp_sw = 'M' THEN
                    v_prorate := ((TRUNC(p_endt_expiry_date) - TRUNC(p_eff_date )) - 1 )/(ADD_MONTHS(p_eff_date, 12) - p_eff_date);
                ELSE 
                    v_prorate := (TRUNC(p_endt_expiry_date) - TRUNC(p_eff_date ))/(ADD_MONTHS(p_eff_date,12) - p_eff_date);
                END IF;
                v_comp_prem := itmperl.prem_amt/v_prorate;
            ELSIF NVL(p_prorate_flag, 2) = 2 THEN
                v_comp_prem := itmperl.prem_amt;
            ELSE
                v_comp_prem := itmperl.prem_amt/(p_short_rt_percent/100);  
            END IF;
            
            FOR A1 IN (SELECT policy_id
                         FROM gipi_polbasic b250
                        WHERE b250.line_cd     = p_line_cd
                          AND b250.subline_cd  = p_subline_cd
                          AND b250.iss_cd      = p_iss_cd
                          AND b250.issue_yy    = p_issue_yy
                          AND b250.pol_seq_no  = p_pol_seq_no
                          AND b250.renew_no    = p_renew_no
                          AND b250.eff_date    > p_eff_date
                          AND b250.endt_seq_no > itmperl.endt_seq_no  --vpsalud 12.14.15 kb#2011 UCPBGEN 21045    
                          AND b250.pol_flag    IN ('1','2','3')     
                          AND NVL(b250.endt_expiry_date, b250.expiry_date) >=  p_eff_date)
            LOOP
                FOR PERL IN (SELECT '1'
                               FROM gipi_itmperil b380
                              WHERE b380.item_no = itmperl.item_no
                                AND b380.peril_cd = itmperl.peril_cd  
                                AND b380.policy_id = a1.policy_id)
                LOOP
                    UPDATE gipi_itmperil
                       SET ann_tsi_amt  = ann_tsi_amt + itmperl.tsi_amt,
                           ann_prem_amt = ann_prem_amt + NVL(v_comp_prem,itmperl.prem_amt)
                     WHERE policy_id = a1.policy_id
                       AND item_no   = itmperl.item_no
                       AND peril_cd  = itmperl.peril_cd;
                END LOOP;
          
                IF itmperl.peril_type = 'B' THEN
                    UPDATE gipi_item
                       SET ann_tsi_amt  = ann_tsi_amt - itmperl.tsi_amt,
                           ann_prem_amt = ann_prem_amt - NVL(v_comp_prem,itmperl.prem_amt)
                     WHERE policy_id = a1.policy_id
                       AND item_no   = itmperl.item_no;                
             
                    UPDATE gipi_polbasic
                       SET ann_tsi_amt  = ann_tsi_amt - ROUND((itmperl.tsi_amt * NVL(itmperl.currency_rt,1)),2),
                           ann_prem_amt = ann_prem_amt - ROUND((NVL(v_comp_prem,itmperl.prem_amt) * NVL(itmperl.currency_rt,1)),2)
                     WHERE policy_id = a1.policy_id;
                ELSE
                    UPDATE gipi_item
                       SET ann_prem_amt = ann_prem_amt + NVL(v_comp_prem,itmperl.prem_amt)
                     WHERE policy_id = a1.policy_id
                       AND item_no   = itmperl.item_no;                
             
                    UPDATE gipi_polbasic
                       SET ann_prem_amt = ann_prem_amt - ROUND((NVL(v_comp_prem,itmperl.prem_amt) * NVL(itmperl.currency_rt,1)),2)
                     WHERE policy_id = a1.policy_id;
                END IF;
            END LOOP;
        END LOOP;
    END update_affected_endt;
    
   FUNCTION validate_spoil_cd(
      p_spoil_cd           giis_spoilage_reason.spoil_cd%TYPE
   ) RETURN VARCHAR2 AS
      v_spoil_desc         giis_spoilage_reason.spoil_desc%TYPE;
   BEGIN
      SELECT spoil_desc
        INTO v_spoil_desc
        FROM giis_spoilage_reason
       WHERE spoil_cd = p_spoil_cd;
      
      RETURN v_spoil_desc;
   END;        
END GIUTS003_PKG;
/


