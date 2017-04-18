CREATE OR REPLACE PACKAGE BODY CPI.GIUTS003A_PKG
AS
    
    /** 
    **  Created by:    Shan Krisne Bati
    **  Date Created:  02.25.2013
    **  Referenced By: GIUTS003A - Spoil Package Policy/Endorsement
    **/
    
    
    /*
    *   Retrieves initial values
    */
    FUNCTION when_new_form_giuts003a
    RETURN when_new_form_giuts003a_tab PIPELINED
    AS
        v_tab   when_new_form_giuts003a_type;
    BEGIN
        FOR A IN ( SELECT param_value_v 
                     FROM giac_parameters
                    WHERE param_name = 'ALLOW_SPOILAGE') 
        LOOP  
            v_tab.allow_spoilage := a.param_value_v;
            EXIT;
        END LOOP;
        
        FOR STAT IN ( SELECT param_value_v  cd
                        FROM giis_parameters
                       WHERE param_name = 'GICL_CLAIMS_CLM_STAT_CD_CANCELLED') 
        LOOP
            v_tab.clm_stat_cancel := stat.cd;
            EXIT;
        END LOOP;
        
        v_tab.req_spl_reason := giisp.v('REQUIRE_SPOILAGE_REASON');
        
        PIPE ROW(v_tab);
    END when_new_form_giuts003a;
    
    
    /*
    *   Retrieves policy(ies) based on the given parameters
    */
    FUNCTION get_pack_policy_giuts003a(
        p_module_id         VARCHAR2,
        p_pack_policy_id    GIPI_PACK_POLBASIC.PACK_POLICY_ID%TYPE,
        p_line_cd           GIPI_PACK_POLBASIC.LINE_CD%TYPE,
        p_subline_cd        GIPI_PACK_POLBASIC.SUBLINE_CD%TYPE,
        p_iss_cd            GIPI_PACK_POLBASIC.ISS_CD%TYPE,
        p_issue_yy          GIPI_PACK_POLBASIC.ISSUE_YY%TYPE,
        p_pol_seq_no        GIPI_PACK_POLBASIC.POL_SEQ_NO%TYPE,
        p_renew_no          GIPI_PACK_POLBASIC.RENEW_NO%TYPE,
        p_user_id           GIPI_PACK_POLBASIC.USER_ID%TYPE
    ) RETURN giuts003a_policy_lov_tab PIPELINED
    IS
        v_rep_tab       giuts003a_policy_lov_type;
        v_assd_no       giis_assured.ASSD_NO%type;
        v_spoil_desc    GIIS_SPOILAGE_REASON.SPOIL_DESC%type;
    BEGIN
        FOR i IN(SELECT a.*, 
                        a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.iss_cd
                       || '-'
                       || TO_CHAR (a.issue_yy, '09')
                       || '-'
                       || TO_CHAR (a.pol_seq_no, '0999999')
                       || '-'
                       || TO_CHAR (a.renew_no, '09') policy_no,
                       a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.endt_iss_cd
                       || '-'
                       || TO_CHAR (a.endt_yy, '09')
                       || '-'
                       || TO_CHAR (a.endt_seq_no, '0999999') endt_no
                   FROM GIPI_PACK_POLBASIC a
                  WHERE a.line_cd LIKE UPPER(NVL(p_line_cd, a.line_cd))
                    AND a.subline_cd LIKE UPPER(NVL(p_subline_cd, a.subline_cd))
                    AND a.iss_cd LIKE UPPER(NVL(p_iss_cd, a.iss_cd))
                    AND a.issue_yy LIKE UPPER(NVL(p_issue_yy, a.issue_yy))
                    AND a.pol_seq_no LIKE UPPER(NVL(p_pol_seq_no, a.pol_seq_no))
                    AND a.renew_no LIKE UPPER(NVL(p_renew_no, a.renew_no))
                    AND a.PACK_POLICY_ID LIKE UPPER(NVL(p_pack_policy_id, a.pack_policy_id))
                    AND check_user_per_iss_cd1(p_line_cd,iss_cd,p_user_id, p_module_id) = 1 
                    AND POL_FLAG NOT IN ('X', '4')
                    AND NOT EXISTS (SELECT 1
                                      FROM gipi_polbasic c, gipi_polnrep d  
                                     WHERE c.policy_id = d.old_policy_id
                                       AND c.pack_policy_id = a.pack_policy_id)
                    AND renew_flag is NULL
                  ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no)
        LOOP
            v_spoil_desc := null;
            
            v_rep_tab.pack_policy_id    := i.pack_policy_id;
            v_rep_tab.pack_par_id       := i.pack_par_id;
            v_rep_tab.line_cd           := i.line_cd;
            v_rep_tab.subline_cd        := i.subline_cd;
            v_rep_tab.iss_cd            := i.iss_cd;
            v_rep_tab.issue_yy          := i.issue_yy;
            v_rep_tab.pol_seq_no        := i.pol_seq_no;
            v_rep_tab.renew_no          := i.renew_no;
            v_rep_tab.endt_iss_cd       := i.endt_iss_cd;
            v_rep_tab.endt_yy           := i.endt_yy;
            v_rep_tab.endt_seq_no       := i.endt_seq_no;
            v_rep_tab.acct_ent_date     := i.acct_ent_date;
            v_rep_tab.assd_no           := i.assd_no;
            v_rep_tab.eff_date          := i.eff_date;
            v_rep_tab.expiry_date       := i.expiry_date;
            v_rep_tab.endt_expiry_date  := i.endt_expiry_date;
            v_rep_tab.spld_date         := i.spld_date;
            v_rep_tab.user_id           := i.user_id;
            v_rep_tab.dist_flag         := i.dist_flag;
            v_rep_tab.spld_user_id      := i.spld_user_id;
            v_rep_tab.spld_approval     := i.spld_approval;
            v_rep_tab.spld_flag         := i.spld_flag;
            v_rep_tab.policy_no         := i.policy_no;
            v_rep_tab.comp_sw           := i.comp_sw;
            v_rep_tab.prorate_flag      := i.prorate_flag;
            v_rep_tab.short_rt_percent  := i.short_rt_percent;
            v_rep_tab.spld_acct_ent_date := i.spld_acct_ent_date;
            v_rep_tab.pol_flag          := i.pol_flag;
            v_rep_tab.last_upd_date     := i.last_upd_date;
            v_rep_tab.ann_tsi_amt       := i.ann_tsi_amt;
            v_rep_tab.ann_prem_amt      := i.ann_prem_amt;
            v_rep_tab.eis_flag          := i.eis_flag;
            v_rep_tab.spoil_cd          := i.spoil_cd;
            
            
            /** === POST_QUERY trigger of block B250 === **/
            
            -- for mean_pol_flag
            BEGIN
                CHK_CHAR_REF_CODES(v_rep_tab.spld_flag              /* MOD: Value to be validated        */
                                  ,v_rep_tab.mean_pol_flag          /* MOD: Domain meaning               */
                                  ,'GIPI_POLBASIC.SPLD_FLAG');      /* IN : Reference codes domain       */
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_rep_tab.mean_pol_flag := NULL;
            END;
      
            -- for endt_no
            IF v_rep_tab.endt_seq_no != 0 THEN
                v_rep_tab.endt_no := i.endt_no;
            ELSE
                v_rep_tab.endt_no := NULL;
            END IF;
            
            -- for assd_name
            -- To display the assured if the record is an endorsement policy.
            IF v_rep_tab.assd_no IS NULL THEN
                FOR assd IN (SELECT assd_no
                               FROM gipi_pack_parlist
                              WHERE pack_par_id = v_rep_tab.pack_par_id)
                LOOP
                    v_assd_no := assd.assd_no;
                END LOOP;
            ELSE
                v_assd_no := v_rep_tab.assd_no;
            END IF;
            
            
            FOR drv_assd IN (SELECT  assd_name
                               FROM  giis_assured
                              WHERE  assd_no = v_assd_no)
            LOOP 
                v_rep_tab.assd_name := drv_assd.assd_name;
            END LOOP;
                        
            -- for spoil_desc
            FOR drv_spl_reason IN (SELECT spoil_desc
                                     FROM giis_spoilage_reason
                                    WHERE spoil_cd = v_rep_tab.spoil_cd)
            LOOP
                v_spoil_desc := drv_spl_reason.spoil_desc;
            END LOOP;
            
            /** === END OF POST_QUERY trigger === **/
            
            v_rep_tab.spoil_desc    := v_spoil_desc;            
            v_rep_tab.policy_status := i.spld_flag || ' - ' || v_rep_tab.mean_pol_flag;
            
            PIPE ROW(v_rep_tab);
        END LOOP;
        
    END get_pack_policy_giuts003a;
    
    
    /* 
    *   Retrieves reason for spoilage LOV
    */
    FUNCTION get_spoil_giuts003a(p_find_text IN VARCHAR2)
    RETURN giuts003a_spoil_lov_tab PIPELINED
    AS
        v_spoil     giuts003a_spoil_lov_type;
    BEGIN
        FOR i IN (SELECT spoil_cd, spoil_desc
                    FROM GIIS_SPOILAGE_REASON
                    WHERE (UPPER(spoil_cd) LIKE UPPER(NVL('%'||p_find_text|| '%', '%')) 
                       OR UPPER(spoil_desc) LIKE UPPER(NVL(p_find_text, '%')))
                      AND active_tag = 'A' --added by carlo SR 5915 01-25-2017
                   ORDER BY spoil_cd)
        LOOP
            v_spoil.spoil_cd := i.spoil_cd;
            v_spoil.spoil_desc := i.spoil_desc;
            
            PIPE ROW(v_spoil);
        END LOOP;
    END get_spoil_giuts003a;
    
    
    /*  BUT_SPOIL: 
    *   Determine whether the policy chosen is suited to be spoiled
    **  or not with regards to some defined condition.
    */
    FUNCTION chk_pack_policy_for_spoilage(
        p_pack_policy_id        GIPI_POLBASIC.PACK_POLICY_ID%TYPE,
        p_iss_cd                GIPI_PACK_POLBASIC.ISS_CD%TYPE
        --p_msg_considered    OUT VARCHAR2,
        --p_msg_spoiled       OUT VARCHAR2
    ) RETURN giuts003a_pack_spoil_msg_tab PIPELINED
    IS
        v_endt_type       gipi_polbasic.endt_type%TYPE;
        v_pack_line_cd    gipi_pack_polbasic.line_cd%TYPE;
        v_pack_subline_cd gipi_pack_polbasic.subline_cd%TYPE;
        v_pack_iss_cd     gipi_pack_polbasic.iss_cd%TYPE;
        v_pack_issue_yy   gipi_pack_polbasic.issue_yy%TYPE;
        v_pack_pol_seq_no gipi_pack_polbasic.pol_seq_no%TYPE;
        v_pack_renew_no   gipi_pack_polbasic.renew_no%TYPE;
        v_rownum          NUMBER := 0;
        v_aff_rownum      NUMBER := 0;
        
        v_tab            giuts003a_pack_spoil_msg_type;
    
        v_claim_id         gicl_claims.claim_id%TYPE;
        --  v_policy_id       gicl_claims.policy_id%TYPE;
        curr_value       VARCHAR2(1) ;
        v_subline        giis_subline.subline_cd%TYPE; 
        v_restrict       VARCHAR2(1) ; -- identifier if spoilage is allowed for policy already 
                                         -- considered in Acctng using GIIS_PARAMETERS.PARAM_NAME='RESTRICT_SPOIL_OF_REC_WACCT_ENT_DATE'
    
        v_policy_id     GIPI_POLBASIC.POLICY_ID%type;
        v_line_cd       GIPI_POLBASIC.LINE_CD%type;
        v_subline_cd    GIPI_POLBASIC.SUBLINE_CD%type;
        v_iss_cd        GIPI_POLBASIC.ISS_CD%type;
        v_issue_yy      GIPI_POLBASIC.ISSUE_YY%type;
        v_pol_seq_no    GIPI_POLBASIC.POL_SEQ_NO%type;
        v_renew_no      GIPI_POLBASIC.RENEW_NO%type;
        v_eff_date      GIPI_POLBASIC.EFF_DATE%type;
        v_pol_flag      GIPI_POLBASIC.POL_FLAG%type;
        v_endt_seq_no   GIPI_POLBASIC.ENDT_SEQ_NO%type;
        v_acct_ent_date GIPI_POLBASIC.ACCT_ENT_DATE%type;
        v_spld_flag     GIPI_POLBASIC.SPLD_FLAG%type;
        
        v_sw             giis_issource.ho_tag%TYPE;
        v_iss_cd_param   giac_parameters.param_value_v%TYPE;
    BEGIN
        --the record must not be tagged for spoilage if the iss_cd's ho_tag <> 'Y'
        BEGIN
            SELECT param_value_v
              INTO v_iss_cd_param
              FROM giac_parameters
            WHERE param_name = 'BRANCH_CD';
        EXCEPTION
            WHEN no_data_found THEN
                NULL;
        END;
          
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param = 'HO' THEN
            BEGIN
                SELECT ho_tag
                  INTO v_sw
                  FROM giis_issource
                 WHERE iss_cd = p_iss_cd;
            EXCEPTION 
                WHEN no_data_found THEN
                    NULL;
            END;
            
            IF v_sw = 'N' THEN
                raise_application_error('-20001',
                                        'Geniisys Exception#I#' || p_iss_cd||' is not allowed to tag the record for spoilage.');
            END IF;
        END IF;
            
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param <> 'HO' THEN
             raise_application_error('-20001',
                                     'Geniisys Exception#I#' || p_iss_cd||' is not allowed to tag the record for spoilage.');
        END IF;  
        
        
        --check package policy
        FOR i IN (SELECT policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date, pol_flag, endt_seq_no, acct_ent_date, spld_flag
                    FROM gipi_polbasic a
                   WHERE a.pack_policy_id = p_pack_policy_id)
        LOOP
            v_policy_id     := i.policy_id;
            v_line_cd       := i.line_cd;
            v_subline_cd    := i.subline_cd;
            v_iss_cd        := i.iss_cd;
            v_issue_yy      := i.issue_yy;
            v_pol_seq_no    := i.pol_seq_no;
            v_renew_no      := i.renew_no;
            v_eff_date      := i.eff_date;
            v_pol_flag      := i.pol_flag;
            v_endt_seq_no   := i.endt_seq_no;
            v_acct_ent_date := i.acct_ent_date;
            v_spld_flag     := i.spld_flag;
            
            FOR mop IN (SELECT a.param_value_v, 
                                b.param_value_v restrict_spoil
                          FROM giis_parameters a,
                               giis_parameters b
                         WHERE a.param_name = 'SUBLINE_MN_MOP'
                           AND b.param_name = 'RESTRICT_SPOIL_OF_REC_WACCT_ENT_DATE')
            LOOP
                v_subline  := mop.param_value_v;
                v_restrict := mop.restrict_spoil;
                EXIT;
            END LOOP;
            
            --disallow spoilage of policy/endt with OPEN claim records
            FOR A1 IN (SELECT claim_id
                   FROM gicl_claims
                  WHERE line_cd     = v_line_cd
                    AND subline_cd  = v_subline_cd
                    AND pol_iss_cd  = v_iss_cd
                    AND issue_yy    = v_issue_yy
                    AND pol_seq_no  = v_pol_seq_no
                    AND renew_no    = v_renew_no
                    AND (loss_date  > v_eff_date)
                    AND clm_stat_cd NOT IN ('CC','WD','DN','CD'))
            LOOP
                v_claim_id   :=  A1.claim_id;
                raise_application_error('-20001',
                                        'Geniisys Exception#E#The policy has pending claims, cannot spoil policy / endorsement.');
                EXIT;
            END LOOP;
            
            chk_paid_policy(v_policy_id, v_line_cd, v_iss_cd);
            
            --     check if policy to be spoiled had already been extracted for expiry
            --     if policy had been processed disallow spoilage
            --     else delete data of that record in expiry tables
            FOR A IN (SELECT NVL(post_flag, 'N') post_flag, policy_id
                        FROM giex_expiry
                       WHERE line_cd     = v_line_cd
                         AND subline_cd  = v_subline_cd
                         AND iss_cd      = v_iss_cd
                         AND issue_yy    = v_issue_yy
                         AND pol_seq_no  = v_pol_seq_no
                         AND renew_no    = v_renew_no)
            LOOP
                IF a.post_flag = 'Y' THEN
                     raise_application_error('-20001',
                                             'Geniisys Exception#I#This policy is already process for expiry, cannot spoil policy/endorsement.');
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
                   DELETE FROM giex_expiry
                      WHERE policy_id = a.policy_id;
                END IF;
                EXIT;
            END LOOP;
            
            IF v_acct_ent_date IS NOT NULL THEN
                IF v_restrict = 'Y' THEN
                    raise_application_error('-20001',
                                             'Geniisys Exception#I#Policy / Endorsement has been considered in Accounting on ' || 
                                             TO_CHAR(v_acct_ent_date,'fmMonth DD, YYYY') || ', Cannot spoil policy.');
                ELSE
                    v_tab.msg_considered := 'Policy / Endorsement has been considered in Accounting on ' || TO_CHAR(v_acct_ent_date,'fmMonth DD, YYYY') 
                                        || ', Please inform Accounting of spoilage.';
                END IF;
            END IF;
            
            /* Loth 042299
             ** Check if the policy is an open policy, thus restrict 
             ** the user from tagging the policy for spoilage if it 
             ** is used by an MRN policy.  
             */
            IF v_subline_cd = v_subline THEN
                IF v_endt_seq_no = 0 THEN
                    check_mrn(v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no);
                END IF;
            END IF;
            
            IF v_spld_flag = '3' THEN
                v_tab.msg_spoiled := 'This policy / endorsement has already been spoiled.';
            ELSIF v_spld_flag = '1' THEN
            --    IF ((v_claim_id IS NULL) AND (v_policy_id IS NULL)) THEN
                IF (v_claim_id IS NULL) THEN
                    DECLARE
                         v_pol_flag       VARCHAR2(1);
                    BEGIN
                        FOR A3 IN (SELECT pol_flag
                                     FROM gipi_polbasic  
                                    WHERE policy_id  = v_policy_id
                                           AND line_cd = v_line_cd
                                        AND subline_cd = v_subline_cd
                                          AND iss_cd   = v_iss_cd    
                                           AND issue_yy = v_issue_yy
                                           AND pol_seq_no = v_pol_seq_no
                                           AND renew_no   = v_renew_no) LOOP
                          v_pol_flag := A3.pol_flag;
                           EXIT;
                        END LOOP;
                        
                        IF v_pol_flag = 'X' THEN
                            raise_application_error('-20001',
                                                    'Geniisys Exception#E#This policy / endorsement is already expired.');
                        END IF;
                    END; 


                     check_endorsement(v_policy_id, v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, 
                                       v_renew_no, v_eff_date, v_pol_flag, v_endt_seq_no);
                  
                     /* Loth 031299
                     ** Populate non-base table field to display domain meaning
                     */
                        -- A.R.C. 11.20.2006
                        --transfer to PACK_SPOIL 
                        --        BEGIN
                        --          curr_value := :B250.SPLD_FLAG;
                        --          CGDV$CHK_CHAR_REF_CODES(
                        --            curr_value                  /* MOD: Value to be validated        */
                        --           ,:B250.MEAN_POL_FLAG         /* MOD: Domain meaning               */
                        --           ,'GIPI_POLBASIC.SPLD_FLAG');  /* IN : Reference codes domain       */
                        --        EXCEPTION
                        --          WHEN no_data_found THEN
                        --            :b250.mean_pol_flag := NULL;
                        --          WHEN OTHERS THEN
                        --            cgte$other_exceptions;
                        --        END;
                                /* End of Update */
                        --        COMMIT;
                        --        clear_message;
                        --        message('Policy/Endorsement has been tagged for spoilage.',NO_ACKNOWLEDGE);
                ELSE
                    raise_application_error('-20001',
                                            'Geniisys Exception#E#The policy/endorsement has claims ... cannot spoil policy / endorsement.');
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE('Function is not available.');     --NO_ACKNOWLEDGE message in forms
            END IF;  
            PIPE ROW(v_tab);
        END LOOP;
        
        --added by steven 05.16.2013 to check if the endorsement in the package is an affecting endorsement
        BEGIN
            SELECT line_cd,
                   subline_cd,
                   iss_cd,
                   issue_yy,
                   pol_seq_no,
                   renew_no
            INTO v_pack_line_cd,
                 v_pack_subline_cd,
                 v_pack_iss_cd,
                 v_pack_issue_yy,
                 v_pack_pol_seq_no,
                 v_pack_renew_no
            FROM gipi_pack_polbasic
                WHERE pack_policy_id = p_pack_policy_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        
            FOR aff IN (SELECT   pack_policy_id,
                         rownum
                    FROM gipi_pack_polbasic
                   WHERE line_cd = v_pack_line_cd
                     AND subline_cd = v_pack_subline_cd
                     AND iss_cd = v_pack_iss_cd
                     AND issue_yy = v_pack_issue_yy
                     AND pol_seq_no = v_pack_pol_seq_no
                     AND renew_no = v_pack_renew_no
                     AND endt_seq_no <> 0
                     AND spld_flag <> '3'
                ORDER BY endt_yy, endt_seq_no) 
            LOOP
                    IF aff.pack_policy_id = p_pack_policy_id THEN
                        v_rownum := aff.rownum;
                    END IF;
                    BEGIN
                        SELECT endt_type
                        INTO v_endt_type
                          FROM gipi_polbasic
                         WHERE pack_policy_id = aff.pack_policy_id 
                            AND endt_type = 'A' 
                            AND ROWNUM = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            v_endt_type := NULL;
                    END;
                    
                    IF v_endt_type = 'A' THEN
                        v_aff_rownum := aff.rownum;
                    END IF;
            END LOOP;
            
            IF v_rownum < v_aff_rownum THEN
                raise_application_error('-20001',
                                                'Geniisys Exception#I#Only non-affecting and affecting endorsement insignificant to '||
                                                'endorsements later than this record can be spoiled. ');
            END IF;
                
    END chk_pack_policy_for_spoilage;
    
    --added by kenneth 07132015 SR 4753
    PROCEDURE chk_pack_policy2(
        p_pack_policy_id        GIPI_POLBASIC.PACK_POLICY_ID%TYPE,
        p_iss_cd                GIPI_PACK_POLBASIC.ISS_CD%TYPE,
        p_message               OUT VARCHAR2 -- apollo cruz 11.13.2015 sr#20906
        --p_msg_considered    OUT VARCHAR2,
        --p_msg_spoiled       OUT VARCHAR2
    )
    AS
        v_endt_type       gipi_polbasic.endt_type%TYPE;
        v_pack_line_cd    gipi_pack_polbasic.line_cd%TYPE;
        v_pack_subline_cd gipi_pack_polbasic.subline_cd%TYPE;
        v_pack_iss_cd     gipi_pack_polbasic.iss_cd%TYPE;
        v_pack_issue_yy   gipi_pack_polbasic.issue_yy%TYPE;
        v_pack_pol_seq_no gipi_pack_polbasic.pol_seq_no%TYPE;
        v_pack_renew_no   gipi_pack_polbasic.renew_no%TYPE;
        v_rownum          NUMBER := 0;
        v_aff_rownum      NUMBER := 0;
        
        v_tab            giuts003a_pack_spoil_msg_type;
    
        v_claim_id         gicl_claims.claim_id%TYPE;
        --  v_policy_id       gicl_claims.policy_id%TYPE;
        curr_value       VARCHAR2(1) ;
        v_subline        giis_subline.subline_cd%TYPE; 
        v_restrict       VARCHAR2(1) ; -- identifier if spoilage is allowed for policy already 
                                         -- considered in Acctng using GIIS_PARAMETERS.PARAM_NAME='RESTRICT_SPOIL_OF_REC_WACCT_ENT_DATE'
    
        v_policy_id     GIPI_POLBASIC.POLICY_ID%type;
        v_line_cd       GIPI_POLBASIC.LINE_CD%type;
        v_subline_cd    GIPI_POLBASIC.SUBLINE_CD%type;
        v_iss_cd        GIPI_POLBASIC.ISS_CD%type;
        v_issue_yy      GIPI_POLBASIC.ISSUE_YY%type;
        v_pol_seq_no    GIPI_POLBASIC.POL_SEQ_NO%type;
        v_renew_no      GIPI_POLBASIC.RENEW_NO%type;
        v_eff_date      GIPI_POLBASIC.EFF_DATE%type;
        v_pol_flag      GIPI_POLBASIC.POL_FLAG%type;
        v_endt_seq_no   GIPI_POLBASIC.ENDT_SEQ_NO%type;
        v_acct_ent_date GIPI_POLBASIC.ACCT_ENT_DATE%type;
        v_spld_flag     GIPI_POLBASIC.SPLD_FLAG%type;
        
        v_sw             giis_issource.ho_tag%TYPE;
        v_iss_cd_param   giac_parameters.param_value_v%TYPE;
    BEGIN
        --the record must not be tagged for spoilage if the iss_cd's ho_tag <> 'Y'
        BEGIN
            SELECT param_value_v
              INTO v_iss_cd_param
              FROM giac_parameters
            WHERE param_name = 'BRANCH_CD';
        EXCEPTION
            WHEN no_data_found THEN
                NULL;
        END;
          
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param = 'HO' THEN
            BEGIN
                SELECT ho_tag
                  INTO v_sw
                  FROM giis_issource
                 WHERE iss_cd = p_iss_cd;
            EXCEPTION 
                WHEN no_data_found THEN
                    NULL;
            END;
            
            IF v_sw = 'N' THEN
                raise_application_error('-20001',
                                        'Geniisys Exception#I#' || p_iss_cd||' is not allowed to tag the record for spoilage.');
            END IF;
        END IF;
            
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param <> 'HO' THEN
             raise_application_error('-20001',
                                     'Geniisys Exception#I#' || p_iss_cd||' is not allowed to tag the record for spoilage.');
        END IF;  
        
        
        --check package policy
        FOR i IN (SELECT policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date, pol_flag, endt_seq_no, acct_ent_date, spld_flag
                    FROM gipi_polbasic a
                   WHERE a.pack_policy_id = p_pack_policy_id)
        LOOP
            v_policy_id     := i.policy_id;
            v_line_cd       := i.line_cd;
            v_subline_cd    := i.subline_cd;
            v_iss_cd        := i.iss_cd;
            v_issue_yy      := i.issue_yy;
            v_pol_seq_no    := i.pol_seq_no;
            v_renew_no      := i.renew_no;
            v_eff_date      := i.eff_date;
            v_pol_flag      := i.pol_flag;
            v_endt_seq_no   := i.endt_seq_no;
            v_acct_ent_date := i.acct_ent_date;
            v_spld_flag     := i.spld_flag;
            
            FOR mop IN (SELECT a.param_value_v, 
                                b.param_value_v restrict_spoil
                          FROM giis_parameters a,
                               giis_parameters b
                         WHERE a.param_name = 'SUBLINE_MN_MOP'
                           AND b.param_name = 'RESTRICT_SPOIL_OF_REC_WACCT_ENT_DATE')
            LOOP
                v_subline  := mop.param_value_v;
                v_restrict := mop.restrict_spoil;
                EXIT;
            END LOOP;
            
            --disallow spoilage of policy/endt with OPEN claim records
            FOR A1 IN (SELECT claim_id
                   FROM gicl_claims
                  WHERE line_cd     = v_line_cd
                    AND subline_cd  = v_subline_cd
                    AND pol_iss_cd  = v_iss_cd
                    AND issue_yy    = v_issue_yy
                    AND pol_seq_no  = v_pol_seq_no
                    AND renew_no    = v_renew_no
                    AND (loss_date  > v_eff_date)
                    AND clm_stat_cd NOT IN ('CC','WD','DN','CD'))
            LOOP
                v_claim_id   :=  A1.claim_id;
                raise_application_error('-20001',
                                        'Geniisys Exception#E#The policy has pending claims, cannot spoil policy / endorsement.');
                EXIT;
            END LOOP;
            
            chk_paid_policy(v_policy_id, v_line_cd, v_iss_cd) ;
            
            --     check if policy to be spoiled had already been extracted for expiry
            --     if policy had been processed disallow spoilage
            --     else delete data of that record in expiry tables
            FOR A IN (SELECT NVL(post_flag, 'N') post_flag, policy_id
                        FROM giex_expiry
                       WHERE line_cd     = v_line_cd
                         AND subline_cd  = v_subline_cd
                         AND iss_cd      = v_iss_cd
                         AND issue_yy    = v_issue_yy
                         AND pol_seq_no  = v_pol_seq_no
                         AND renew_no    = v_renew_no)
            LOOP
                IF a.post_flag = 'Y' THEN
                     raise_application_error('-20001',
                                             'Geniisys Exception#I#This policy is already process for expiry, cannot spoil policy/endorsement.');
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
                   DELETE FROM giex_old_group_itmperil
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
            
            IF v_acct_ent_date IS NOT NULL THEN
                IF v_restrict = 'Y' THEN
                    raise_application_error('-20001',
                                             'Geniisys Exception#I#Policy / Endorsement has been considered in Accounting on ' || 
                                             TO_CHAR(v_acct_ent_date,'fmMonth DD, YYYY') || ', Cannot spoil policy.');
                ELSE
--                    v_tab.msg_considered := 'Policy / Endorsement has been considered in Accounting on ' || TO_CHAR(v_acct_ent_date,'fmMonth DD, YYYY') 
--                                        || ', Please inform Accounting of spoilage.';
                                        
                     raise_application_error('-20001',
                                             'Geniisys Exception#I#Policy / Endorsement has been considered in Accounting on ' || TO_CHAR(v_acct_ent_date,'fmMonth DD, YYYY') 
                                        || ', Please inform Accounting of spoilage.');
                END IF;
            END IF;
            
            /* Loth 042299
             ** Check if the policy is an open policy, thus restrict 
             ** the user from tagging the policy for spoilage if it 
             ** is used by an MRN policy.  
             */
            IF v_subline_cd = v_subline THEN
                IF v_endt_seq_no = 0 THEN
                    check_mrn(v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no);
                END IF;
            END IF;
            
            -- apollo cruz 11.13.2015 sr#20906
            -- moved the validation of spoiled sub policies below
            /*IF v_spld_flag = '3' THEN
--                v_tab.msg_spoiled := 'This policy / endorsement has already been spoiled.';
                raise_application_error('-20001', 'Geniisys Exception#I#This policy / endorsement has already been spoiled.');
            ELS*/
            IF v_spld_flag = '1' THEN
            --    IF ((v_claim_id IS NULL) AND (v_policy_id IS NULL)) THEN
                IF (v_claim_id IS NULL) THEN
                    DECLARE
                         v_pol_flag       VARCHAR2(1);
                    BEGIN
                        FOR A3 IN (SELECT pol_flag
                                     FROM gipi_polbasic  
                                    WHERE policy_id  = v_policy_id
                                           AND line_cd = v_line_cd
                                        AND subline_cd = v_subline_cd
                                          AND iss_cd   = v_iss_cd    
                                           AND issue_yy = v_issue_yy
                                           AND pol_seq_no = v_pol_seq_no
                                           AND renew_no   = v_renew_no) LOOP
                          v_pol_flag := A3.pol_flag;
                           EXIT;
                        END LOOP;
                        
                        IF v_pol_flag = 'X' THEN
                            raise_application_error('-20001',
                                                    'Geniisys Exception#E#This policy / endorsement is already expired.');
                        END IF;
                    END; 


                     check_endorsement(v_policy_id, v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, 
                                       v_renew_no, v_eff_date, v_pol_flag, v_endt_seq_no);
                  
                     /* Loth 031299
                     ** Populate non-base table field to display domain meaning
                     */
                        -- A.R.C. 11.20.2006
                        --transfer to PACK_SPOIL 
                        --        BEGIN
                        --          curr_value := :B250.SPLD_FLAG;
                        --          CGDV$CHK_CHAR_REF_CODES(
                        --            curr_value                  /* MOD: Value to be validated        */
                        --           ,:B250.MEAN_POL_FLAG         /* MOD: Domain meaning               */
                        --           ,'GIPI_POLBASIC.SPLD_FLAG');  /* IN : Reference codes domain       */
                        --        EXCEPTION
                        --          WHEN no_data_found THEN
                        --            :b250.mean_pol_flag := NULL;
                        --          WHEN OTHERS THEN
                        --            cgte$other_exceptions;
                        --        END;
                                /* End of Update */
                        --        COMMIT;
                        --        clear_message;
                        --        message('Policy/Endorsement has been tagged for spoilage.',NO_ACKNOWLEDGE);
                ELSE
                    raise_application_error('-20001',
                                            'Geniisys Exception#E#The policy/endorsement has claims ... cannot spoil policy / endorsement.');
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE('Function is not available.');     --NO_ACKNOWLEDGE message in forms
            END IF;  
            
            DELETE FROM giex_pack_expiry   
               WHERE pack_policy_id = p_pack_policy_id;
--            PIPE ROW(v_tab);
        END LOOP;
        
        --added by steven 05.16.2013 to check if the endorsement in the package is an affecting endorsement
        BEGIN
            SELECT line_cd,
                   subline_cd,
                   iss_cd,
                   issue_yy,
                   pol_seq_no,
                   renew_no
            INTO v_pack_line_cd,
                 v_pack_subline_cd,
                 v_pack_iss_cd,
                 v_pack_issue_yy,
                 v_pack_pol_seq_no,
                 v_pack_renew_no
            FROM gipi_pack_polbasic
                WHERE pack_policy_id = p_pack_policy_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
        
            FOR aff IN (SELECT   pack_policy_id,
                         rownum
                    FROM gipi_pack_polbasic
                   WHERE line_cd = v_pack_line_cd
                     AND subline_cd = v_pack_subline_cd
                     AND iss_cd = v_pack_iss_cd
                     AND issue_yy = v_pack_issue_yy
                     AND pol_seq_no = v_pack_pol_seq_no
                     AND renew_no = v_pack_renew_no
                     AND endt_seq_no <> 0
                     AND spld_flag <> '3'
                ORDER BY endt_yy, endt_seq_no) 
            LOOP
                    IF aff.pack_policy_id = p_pack_policy_id THEN
                        v_rownum := aff.rownum;
                    END IF;
                    BEGIN
                        SELECT endt_type
                        INTO v_endt_type
                          FROM gipi_polbasic
                         WHERE pack_policy_id = aff.pack_policy_id 
                            AND endt_type = 'A' 
                            AND ROWNUM = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            v_endt_type := NULL;
                    END;
                    
                    IF v_endt_type = 'A' THEN
                        v_aff_rownum := aff.rownum;
                    END IF;
            END LOOP;
            
            IF v_rownum < v_aff_rownum THEN
                raise_application_error('-20001',
                                                'Geniisys Exception#I#Only non-affecting and affecting endorsement insignificant to '||
                                                'endorsements later than this record can be spoiled. ');
            END IF;
            
            -- apollo cruz 11.13.2015 sr#20906
            DECLARE
               v_spld_flag gipi_polbasic.spld_flag%TYPE;
            BEGIN
               SELECT DISTINCT spld_flag
                 INTO v_spld_flag
                 FROM gipi_polbasic
                WHERE  pack_policy_id = p_pack_policy_id;
                
                v_spld_flag := NVL(v_spld_flag, 'X');
                
                IF v_spld_flag = '3' THEN
                   p_message := 'All Sub-Policy/Endorsement of this package policy has been spoiled. System will now tag this package as spoiled.';
                END IF;
                
            EXCEPTION WHEN TOO_MANY_ROWS THEN
               v_spld_flag := NULL;       
            END; 
                   
                
    END chk_pack_policy2;
    /* 
    *   Determine whether the policy being processed has
    *   been paid or not --  whatever this means.
    */
    PROCEDURE chk_paid_policy(
        p_policy_id     GIPI_POLBASIC.POLICY_ID%TYPE,
        p_line_cd       GIPI_POLBASIC.LINE_CD%TYPE,
        p_iss_cd        GIPI_POLBASIC.ISS_CD%TYPE
    )
    AS
        v_policy_id        gipi_invoice.policy_id%TYPE;
        v_ri            gipi_polbasic.iss_cd%TYPE;
        v_prem_coll     giac_inwfacul_prem_collns.collection_amt%TYPE;
    BEGIN
        --BETH 10202000 For RI policies, check for the existence of premium collection
        FOR RI IN (SELECT param_value_v cd
                     FROM giis_parameters
                    WHERE param_name = 'ISS_CD_RI')
        LOOP
            v_ri := ri.cd;
            EXIT;
        END LOOP;
        
        IF p_iss_cd != v_ri THEN   --added by janet ang so that is RI it wont check here na
            FOR A1 IN (SELECT a.policy_id    policy_id
                         FROM gipi_invoice a, giac_aging_soa_details b
                        WHERE a.policy_id       = p_policy_id
                          AND a.iss_cd          = b.iss_cd
                          AND a.prem_seq_no     = b.prem_seq_no
                    --     AND b.total_payments != 0) LOOP  
                    -- replaced by janet ang 031501 because total_payments sometimes have inaccurate amounts
                          AND b.total_amount_due != b.balance_amt_due) 
            LOOP
                v_policy_id  := A1.policy_id;
                EXIT;
            END LOOP;
            
            IF v_policy_id IS NOT NULL THEN
               raise_application_error('-20001',
                                       'Geniisys Exception#E#Paid policy / endorsement cannot be spoiled.');
            END IF;
        END IF;    
        
        IF p_iss_cd = v_ri THEN
            --  replaced by janet ang 031501 to make things simplier,
            --  instead of looking at the payment, just check the maintenance of RI SOA
            --       FOR COLL IN (SELECT SUM(NVL(a.collection_amt,0)) AMT
            --                      FROM gipi_invoice e,
            --                           giac_inwfacul_prem_collns a,
            --                           giac_acctrans b
            --                     WHERE e.policy_id    =  :b250.pack_policy_id       
            --                     AND e.prem_seq_no  =  a.b140_prem_seq_no
            --                     AND e.iss_cd       =  a.b140_iss_cd
            --                     AND a.gacc_tran_id =  b.tran_id
            --                     AND b.tran_flag    <> 'D'   
            --                     AND NOT EXISTS (SELECT '1'
            --                                       FROM giac_reversals c,
            --                                            giac_acctrans d
            --                                      WHERE c.reversing_tran_id =  d.tran_id
            --                                        AND d.tran_flag         <> 'D'
            --                                        AND c.gacc_tran_id = a.gacc_tran_id))
            --     LOOP
            FOR A1 IN (SELECT a.policy_id    policy_id
                         FROM gipi_invoice a, giac_aging_RI_soa_details b
                        WHERE a.policy_id       = p_policy_id
                          AND b.gagp_aging_id   >= 0
                          AND a.iss_cd          = v_ri
                          AND a.prem_seq_no     = b.prem_seq_no
                          AND b.total_amount_due != b.balance_due) 
            LOOP

        --          IF NVL(coll.amt,0) <> 0 THEN
                IF nvl(a1.policy_id,0) != 0 then
                    raise_application_error('-20001',
                                            'Geniisys Exception#I#Policy has collection(s) already from Cedant. Cannot spoil policy/endorsement.');
                END IF;
                EXIT;
            END LOOP;
        END IF;
        
        chk_reinsurance_payment(p_policy_id, p_line_cd);
          
    END chk_paid_policy;
    
    
    /*  
    *   check if policy has FACUL share and if there are existing payments
    *   from FACUL Reinsurers
    */
    PROCEDURE chk_reinsurance_payment(
        p_policy_id     GIPI_POLBASIC.POLICY_ID%TYPE,
        p_line_cd       GIPI_POLBASIC.LINE_CD%TYPE
    )
    AS
        v_param_value_n    giis_parameters.param_value_n%TYPE;
    BEGIN
        FOR A1 IN (SELECT param_value_n
                     FROM giis_parameters 
                    WHERE param_name = 'FACULTATIVE') 
        LOOP
            v_param_value_n  :=  A1.param_value_n;
            EXIT;
        END LOOP;
    
        IF v_param_value_n IS NOT NULL THEN
            FOR A2 IN (SELECT a.dist_no      dist_no,
                               a.dist_seq_no  dist_seq_no,
                               a.line_cd      line_cd,
                               a.share_cd     share_cd
                         FROM giuw_pol_dist c ,giuw_policyds_dtl a,giuw_policyds b
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
                              AND c.reverse_date IS NULL)
                LOOP
                    FOR A4 IN (SELECT SUM(NVL(a.disbursement_amt,0)) amt
                                 FROM giac_outfacul_prem_payts a, 
                                      giac_acctrans b
                                WHERE a.a180_ri_cd         =  a3.ri_cd
                                  AND a.d010_fnl_binder_id =  a3.fnl_binder_id
                                  AND a.gacc_tran_id       =  b.tran_id
                                  AND b.tran_flag          <> 'D'        
                                  AND NOT EXISTS (SELECT '1'
                                                     FROM giac_reversals c, 
                                                          giac_acctrans d
                                                    WHERE a.gacc_tran_id = c.gacc_tran_id
                                                      AND c.reversing_tran_id =  d.tran_id
                                                      AND d.tran_flag         <> 'D'))
                    LOOP
                        IF a4.amt <> 0 THEN
                            raise_application_error('-20001',
                                                    'Geniisys Exception#I#This policy has collections from FACUL Reinsurers, Cannot spoil policy/endorsement');
                            EXIT;
                        END IF;                 
                    END LOOP;                                          
                END LOOP;   
             END LOOP;   
        END IF;
        
    END chk_reinsurance_payment;
    
    
    /*
    *   Check if the policy is being used by an MRN policy
    */
    PROCEDURE check_mrn(
        p_line_cd       GIPI_POLBASIC.LINE_CD%TYPE , 
        p_subline_cd    GIPI_POLBASIC.SUBLINE_CD%TYPE , 
        p_iss_cd        GIPI_POLBASIC.ISS_CD%TYPE , 
        p_issue_yy      GIPI_POLBASIC.ISSUE_YY%TYPE , 
        p_pol_seq_no    GIPI_POLBASIC.POL_SEQ_NO%TYPE , 
        p_renew_no      GIPI_POLBASIC.RENEW_NO%TYPE
    )
    AS
        v_exist   VARCHAR2(1) := 'N';
        v_subline giis_subline.subline_cd%TYPE;
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
        
        FOR exist1 IN  (SELECT 'a' 
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
            raise_application_error('-20001',
                                    'Geniisys Exception#I#MOP Policy / Endorsement has been used by another declaration policy ('||v_subline||').');
        END IF;
        
    END check_mrn;
    
    
    /*  
    *   this procedure allows spoilage of endorsement even if there
    *   are later endorsement 
    */    
    PROCEDURE check_endorsement(
        p_policy_id     GIPI_POLBASIC.POLICY_ID%TYPE , 
        p_line_cd       GIPI_POLBASIC.LINE_CD%TYPE , 
        p_subline_cd    GIPI_POLBASIC.SUBLINE_CD%TYPE , 
        p_iss_cd        GIPI_POLBASIC.ISS_CD%TYPE , 
        p_issue_yy      GIPI_POLBASIC.ISSUE_YY%TYPE , 
        p_pol_seq_no    GIPI_POLBASIC.POL_SEQ_NO%TYPE , 
        p_renew_no      GIPI_POLBASIC.RENEW_NO%TYPE , 
        p_eff_date      GIPI_POLBASIC.EFF_DATE%TYPE , 
        p_pol_flag      GIPI_POLBASIC.POL_FLAG%TYPE , 
        p_endt_seq_no   GIPI_POLBASIC.ENDT_SEQ_NO%TYPE 
    )
    AS
        v_eff_date          gipi_polbasic.eff_date%TYPE;
        v_endt_type          gipi_polbasic.endt_type%TYPE := 'E';
        v_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE;
        v_exist         VARCHAR2(1) := 'N';
        v_cancel_sw     VARCHAR2(1) := 'N';
        
    BEGIN
        FOR A1 IN (SELECT eff_date,endt_type, endt_seq_no
                     FROM gipi_polbasic
                    WHERE line_cd    = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd     = p_iss_cd
                      AND issue_yy   = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no   = p_renew_no
                      AND pol_flag  IN ('1','2','3','4')
                      AND spld_flag != '3'
                    ORDER BY  eff_date DESC, endt_seq_no DESC) 
        LOOP
            v_eff_date    := A1.eff_date;
            v_endt_seq_no := A1.endt_seq_no;
            v_endt_type   := A1.endt_type;
            EXIT;
        END LOOP;
        
        --check for the existance of on-going endorsement for the policy 
        FOR A2 IN (SELECT eff_date,endt_type
                     FROM gipi_wpolbas
                    WHERE line_cd    = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd     = p_iss_cd
                      AND issue_yy   = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no   = p_renew_no
                    ORDER BY eff_date DESC, endt_seq_no DESC) 
        LOOP
            v_exist := 'Y'; 
            EXIT;
        END LOOP;
        
        /* Check whether there are existing endorsement created after the
        ** current record being processed.
        */
        IF v_exist = 'Y' THEN
             raise_application_error('-20001',
                                    'Geniisys Exception#E#Policy / Endorsement cannot be spoiled, '||
                                    'creation of endorsement connected to this record is on going. ');
        END IF;
        
        --BETH 03/06/2001 for cancelled endt. only the cancelling endt. can be spoiled
        IF p_pol_flag = '4' THEN
              --check first if it is the cancelling endt., cancelling endt. can be determine
              --by means of 0 ann_tsi_amt  and if old_pol_flag is NULL 
             FOR A IN (SELECT '1'
                         FROM gipi_polbasic
                        WHERE policy_id = p_policy_id
                          AND ann_tsi_amt = 0
                          --AND ann_prem_amt = 0 -- comment out by aaron 073009 
                          AND old_pol_flag IS NULL)
             LOOP 
                v_cancel_sw := 'Y'; --record is the cancelling endt.
                EXIT;
             END LOOP;
             --for record that is not the cancelling endt disallow spoilage
             IF v_cancel_sw = 'N' THEN
                  raise_application_error('-20001',
                                          'Geniisys Exception#E#You cannot spoiled a cancelled record if it is not the cancelling endorsement.');
             END IF;   
        ELSIF (v_eff_date = p_eff_date AND v_endt_seq_no = p_endt_seq_no ) OR (v_endt_type IS NULL AND NVL(v_endt_seq_no,0) = 0) THEN  
             NULL;      
        ELSE
             IF NVL(p_endt_seq_no,0) = 0 AND p_pol_flag IN ('1','2','3') THEN
                  raise_application_error('-20001',
                                          'Geniisys Exception#E#Policy with existing valid endorsement cannot be spoiled.');
               
             /*ELSE      --remove by steven 05.16.2013  base on PHILFIRE SR 0013091
                FOR PERL IN (SELECT b380.item_no
                               FROM gipi_itmperil b380
                              WHERE b380.policy_id = p_policy_id
                                AND NVL(b380.tsi_amt,0) <> 0 
                                AND NVL(b380.prem_amt,0) <> 0 )
                LOOP
                    FOR CHK IN (SELECT '1'
                                  FROM gipi_itmperil  b380
                                 WHERE b380.item_no = perl.item_no 
                                   AND EXISTS (SELECT '1'
                                                 FROM gipi_polbasic b250
                                                WHERE b250.line_cd     =  p_line_cd
                                                  AND b250.subline_cd  =  p_subline_cd
                                                  AND b250.iss_cd      =  p_iss_cd
                                                  AND b250.issue_yy    =  p_issue_yy
                                                  AND b250.pol_seq_no  =  p_pol_seq_no
                                                  AND b250.renew_no    =  p_renew_no
                                                  AND b250.eff_date    >  p_eff_date
                                                  AND b250.pol_flag    IN ('1','2','3')
                                                  AND b250.pack_policy_id   =  b380.policy_ID))
                    LOOP
                        raise_application_error('-20001',
                                                'Geniisys Exception#I#Only non-affecting and affecting endorsement insignificant to '||
                                                'endorsements later than this record can be spoiled. ');
                    END LOOP;
                END LOOP; */
             END IF;
        END IF;    
        
    END check_endorsement;
    
    
    /* 
    *   Procedure to perform spoilage
    */
    PROCEDURE pack_spoil(
        p_spoil_cd              GIPI_PACK_POLBASIC.SPOIL_CD%TYPE,
        p_pack_policy_id        GIPI_PACK_POLBASIC.PACK_POLICY_ID%TYPE,
        p_spld_flag             GIPI_PACK_POLBASIC.SPLD_FLAG%TYPE,
        p_user_id                GIIS_USERS.user_id%TYPE,
        p_mean_pol_flag     OUT VARCHAR2
    )
    AS
         curr_value       VARCHAR2(1) ;
    BEGIN
        UPDATE gipi_polbasic
           SET spld_flag    = '2',
               spoil_cd     = p_spoil_cd, -- by gmi
               spld_date    = SYSDATE,
               spld_user_id = p_user_id
         WHERE pack_policy_id = p_pack_policy_id
           AND spld_flag <> '3'; -- apollo cruz 11.13.2015 sr#20906 
             
        UPDATE gipi_pack_polbasic
           SET spld_flag = '2',
               spoil_cd     = p_spoil_cd, 
               spld_date    = SYSDATE,
               spld_user_id = p_user_id
         WHERE pack_policy_id = p_pack_policy_id;
            
            
        BEGIN
          curr_value := p_spld_flag;
            
          CHK_CHAR_REF_CODES(curr_value                     /* MOD: Value to be validated        */
                             ,p_mean_pol_flag               /* MOD: Domain meaning               */
                             ,'GIPI_POLBASIC.SPLD_FLAG');   /* IN : Reference codes domain       */
        EXCEPTION
          WHEN no_data_found THEN
            p_mean_pol_flag := NULL;
          WHEN OTHERS THEN
            p_mean_pol_flag := NULL;
        END; 
        
    END pack_spoil;
    
    
    /*  BUT_UNPOST:
    **  This will reverse the process that has been done when the user tagged the
    **  policy for spoilage.
    */
    PROCEDURE pack_unspoil(
        p_iss_cd            GIPI_PACK_POLBASIC.ISS_CD%TYPE,
        p_pack_policy_id    GIPI_PACK_POLBASIC.PACK_POLICY_ID%TYPE,
        p_spld_flag         GIPI_PACK_POLBASIC.SPLD_FLAG%TYPE,
        p_mean_pol_flag OUT VARCHAR2
    )
    AS
        curr_value             VARCHAR2(1);
        v_sw                 giis_issource.ho_tag%TYPE;        
        v_iss_cd_param        giac_parameters.param_value_v%TYPE;
    BEGIN
            --the record must not be unspoiled if the iss_cd's ho_tag <> 'Y'
        BEGIN
            SELECT param_value_v
              INTO v_iss_cd_param
              FROM giac_parameters
             WHERE param_name = 'BRANCH_CD';
          EXCEPTION
              WHEN no_data_found THEN
                  NULL;
        END;
  
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param = 'HO' THEN
            BEGIN
                SELECT ho_tag
                  INTO v_sw
                  FROM giis_issource
                 WHERE iss_cd = p_iss_cd;
            EXCEPTION 
                  WHEN no_data_found THEN
                         NULL;
            END;
            
            IF v_sw = 'N' THEN
                raise_application_error('-20001',
                                        'Geniisys Exception#I#' || p_iss_cd||' is not allowed to unspoil the record.');
            END IF;
        END IF;
    
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param <> 'HO' THEN
             raise_application_error('-20001',
                                     'Geniisys Exception#I#' || p_iss_cd||' is not allowed to unspoil the record.');
        END IF;  
    
        UPDATE gipi_polbasic
           SET spld_flag = '1',   
               spoil_cd = NULL, -- by gmi
               spld_date = NULL,
               spld_user_id = NULL
         WHERE pack_policy_id = p_pack_policy_id
           AND spld_flag <> '3'; -- apollo cruz 11.13.2015 sr#20906
         
         UPDATE gipi_pack_polbasic
            SET spld_flag = '1',   
                spoil_cd = NULL, -- by gmi
                spld_date = NULL,
                spld_user_id = NULL
         WHERE pack_policy_id = p_pack_policy_id;
         
         
         BEGIN
            curr_value := p_spld_flag;
           
            CHK_CHAR_REF_CODES(curr_value                  /* MOD: Value to be validated        */
                               ,p_mean_pol_flag         /* MOD: Domain meaning               */
                               ,'GIPI_POLBASIC.SPLD_FLAG');  /* IN : Reference codes domain       */
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                p_mean_pol_flag := NULL;
           WHEN OTHERS THEN
                p_mean_pol_flag := NULL;
         END;
    
    END pack_unspoil;
    
    
    /*  BUT_POST:
    *   Check if the policy is suited to be posted 
    *   based on some defined conditions 
    */
    PROCEDURE chk_pack_policy_post(
        p_module_id             GIIS_USER_GRP_MODULES.MODULE_ID%TYPE,
        p_line_cd               GIPI_PACK_POLBASIC.LINE_CD%TYPE,
        p_iss_cd                GIPI_PACK_POLBASIC.ISS_CD%TYPE,
        p_pack_policy_id        GIPI_PACK_POLBASIC.PACK_POLICY_ID%TYPE,
        p_user_id               GIPI_POLBASIC.USER_ID%TYPE,
        p_continue_spoilage     VARCHAR,
        p_start         IN OUT  NUMBER,
        p_policy_no        OUT  VARCHAR2,
        p_mean_pol_flag    OUT  VARCHAR2,
        p_ann_prem_amt     OUT  GIPI_PACK_POLBASIC.ANN_PREM_AMT%TYPE,
        p_ann_tsi_amt      OUT  GIPI_PACK_POLBASIC.ANN_TSI_AMT%TYPE,
        p_msg_considered   OUT  VARCHAR2,
        p_final_msg        OUT  VARCHAR2
    )
    AS
        v_policy_id         GIPI_POLBASIC.POLICY_ID%TYPE;
        v_line_cd           GIPI_POLBASIC.LINE_CD%type;
        v_subline_cd        GIPI_POLBASIC.SUBLINE_CD%type;
        v_iss_cd            GIPI_POLBASIC.ISS_CD%type;
        v_issue_yy          GIPI_POLBASIC.ISSUE_YY%type;
        v_pol_seq_no        GIPI_POLBASIC.POL_SEQ_NO%type;
        v_renew_no          GIPI_POLBASIC.RENEW_NO%type;
        v_eff_date          GIPI_POLBASIC.EFF_DATE%type;
        v_pol_flag          GIPI_POLBASIC.POL_FLAG%type;
        v_endt_seq_no       GIPI_POLBASIC.ENDT_SEQ_NO%type;
        v_acct_ent_date     GIPI_POLBASIC.ACCT_ENT_DATE%type;
        v_spld_flag         GIPI_POLBASIC.SPLD_FLAG%type;
        v_prorate_flag      GIPI_POLBASIC.PRORATE_FLAG%TYPE;
        v_comp_sw           GIPI_POLBASIC.COMP_SW%TYPE;
        v_endt_expiry_date  GIPI_POLBASIC.ENDT_EXPIRY_DATE%TYPE;
        v_short_rt_percent  GIPI_POLBASIC.SHORT_RT_PERCENT%TYPE;
        
        v_iss_cd_param  giac_parameters.param_value_v%TYPE;
        v_sw            giis_issource.ho_tag%TYPE;
        v_MIS_sw         VARCHAR2(1);
        v_MGR_sw         VARCHAR2(1);
        v_sw3            VARCHAR2(1) := 'N';
        curr_value       VARCHAR2(1) ;
        p_dist_no        giuw_pol_dist.dist_no%TYPE;
        v_claim_id       gicl_claims.claim_id%TYPE;
        v_subline        giis_subline.subline_cd%TYPE; 
        v_restrict       VARCHAR2(1) ; -- identifier if spoilage is allowed for policy already 
        v_exist          VARCHAR2(1) := 'N';
    
        cnt              NUMBER := 0;
    BEGIN
        --the spoiled policy / endorsement must not be posted if the iss_cd's ho_tag <> 'Y'
        BEGIN
             SELECT param_value_v
               INTO v_iss_cd_param
               FROM giac_parameters
              WHERE param_name = 'BRANCH_CD';
        EXCEPTION
               WHEN no_data_found THEN
                    NULL;
        END;
          
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param = 'HO' THEN
            BEGIN
                SELECT ho_tag
                  INTO v_sw
                  FROM giis_issource
                 WHERE iss_cd = p_iss_cd;
            EXCEPTION 
                    WHEN no_data_found THEN
                              NULL;
            END;
            
            IF v_sw = 'N' THEN
                raise_application_error('-20001',
                                        'Geniisys Exception#I#' ||p_iss_cd||' is not allowed to post the spoiled policy / endorsement.');
            END IF;
        END IF;
            
        IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param <> 'HO' THEN
             raise_application_error('-20001',
                                     'Geniisys Exception#I#'||p_iss_cd||' is not allowed to post the spoiled policy / endorsement.');
        END IF;  
        --end if inserted code by bdarusin (08232001)

        /* Created by Loth 031299
        ** Check if the user has an access in MIS and Managerial.
        ** If none, disallow the user from posting
        ** the spoiled policy.
        */
        /*FOR sw IN (
        SELECT mis_sw,mgr_sw, user_grp
          FROM giis_users
         WHERE user_id = :CG$CTRL.CG$US)
        LOOP
         v_MIS_sw := sw.mis_sw;
         v_MGR_sw := sw.mgr_sw;
         FOR iss IN (
           SELECT iss_cd
             FROM giis_user_grp_dtl
            WHERE user_grp = sw.user_grp)
         LOOP
           IF :b250.iss_cd = iss.iss_cd THEN
              v_sw3 := 'Y';
              exit;
           END IF;
         END LOOP;
        END LOOP;

        IF v_MIS_sw != 'Y' AND v_MGR_sw != 'Y' THEN
        msg_alert('You are not allowed to post this spoiled policy / endorsement.','I',TRUE);
        END IF;

        IF v_sw3 != 'Y' THEN
         msg_alert('You are not allowed to post this spoiled policy / endorsement.','I',TRUE);
        END IF;*/
        /*BY Iris Bordey 07.23.2003
        */
        IF check_user_per_line1(p_line_cd, p_iss_cd, p_user_id, p_module_id) <> 1 THEN
            raise_application_error('-20001',
                                    'Geniisys Exception#I#You are not allowed to post this spoiled policy / endorsement.');
        END IF;
        
        FOR c1 IN (SELECT policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date, pol_flag, endt_seq_no, acct_ent_date, spld_flag, prorate_flag, comp_sw, endt_expiry_date, short_rt_percent  
                     FROM gipi_polbasic a
                    WHERE a.pack_policy_id = p_pack_policy_id)
        LOOP 
            v_policy_id := c1.policy_id;
            v_line_cd := c1.line_cd;       
            v_subline_cd := c1.subline_cd;
            v_iss_cd := c1.iss_cd;
            v_issue_yy := c1.issue_yy;
            v_pol_seq_no := c1.pol_seq_no;
            v_renew_no := c1.renew_no;
            v_eff_date := c1.eff_date;
            v_pol_flag := c1.pol_flag;
            v_endt_seq_no := c1.endt_seq_no;    
            v_acct_ent_date := c1.acct_ent_date;
            v_spld_flag := c1.spld_flag;
            v_prorate_flag := c1.prorate_flag; 
            v_comp_sw := c1.comp_sw; 
            v_endt_expiry_date := c1.endt_expiry_date; 
            v_short_rt_percent := c1.short_rt_percent;
            
            -- ADDED BY RBD 04151999
            -- Commented by Loth in Request of SIR BOBBY 060899
            --  IF :b250.ACCT_ENT_DATE IS NOT NULL THEN
            --     msg_alert('Policy / Endorsement has been considered in Accounting on ' || TO_CHAR(:b250.ACCT_ENT_DATE,'fmMonth DD, YYYY') || ', Cannot spoil policy / endorsement.','I',TRUE);
            --  END IF;
                
            -- grace 09-26-2003
            -- populate refresh_sw in GICL_CLAIMS when the record being spoiled has existing claims
            -- Grace 10/25/2002
            --  for policy and endorsement -check if there are 
            --  existing claim(s) for the policy  and if the loss date
            --  of the claim is later or equal to policy/endt effectivity date
            FOR A1 IN (SELECT claim_id
                       FROM gicl_claims
                      WHERE line_cd     = v_line_cd
                        AND subline_cd  = v_subline_cd
                        AND pol_iss_cd  = v_iss_cd
                        AND issue_yy    = v_issue_yy
                        AND pol_seq_no  = v_pol_seq_no
                        AND renew_no    = v_renew_no
                        AND (loss_date  >= v_eff_date))
            --                AND clm_stat_cd NOT IN ('CC','WD','DN'))
            LOOP
                v_claim_id :=  A1.claim_id;
                v_exist      := 'Y';
                EXIT;                
            END LOOP;
            
            IF v_exist = 'Y' AND p_continue_spoilage IS NULL THEN
                p_policy_no := get_policy_no(v_policy_id);
                p_start := cnt;
                RETURN;                
            END IF;
            
            IF p_continue_spoilage = 'Y' AND cnt = p_start THEN   --for policy with existing claims
                UPDATE gicl_claims
                   SET refresh_sw = 'Y'
                 WHERE line_cd     = v_line_cd
                   AND subline_cd  = v_subline_cd
                   AND pol_iss_cd  = v_iss_cd
                   AND issue_yy    = v_issue_yy
                   AND pol_seq_no  = v_pol_seq_no
                   AND renew_no    = v_renew_no
                   AND (loss_date  >= v_eff_date);
            ELSIF p_continue_spoilage = 'N' AND cnt = p_start THEN
                RETURN;
            END IF;
            
            chk_paid_policy(v_policy_id, v_line_cd, v_iss_cd);
            
            --     check if policy to be spoiled had already been extracted for expiry
            --     if policy had been processed disallow spoilage
            --     else delete data of that record in expiry tables
            FOR A IN (SELECT NVL(post_flag, 'N') post_flag, policy_id
                        FROM giex_expiry
                       WHERE line_cd     = v_line_cd
                         AND subline_cd  = v_subline_cd
                         AND iss_cd      = v_iss_cd
                         AND issue_yy    = v_issue_yy
                         AND pol_seq_no  = v_pol_seq_no
                         AND renew_no    = v_renew_no)
            LOOP
                IF a.post_flag = 'Y' THEN
                    raise_application_error('-20001',
                                            'Geniisys Exception#I#This policy is already process for expiry, cannot spoil policy/endorsement.');
                ELSE
                    DELETE FROM giex_old_group_tax
                     WHERE policy_id = a.policy_id;
                    DELETE FROM giex_old_group_peril
                     WHERE policy_id = a.policy_id; 
                    DELETE FROM giex_old_group_itmperil --added by kenneth 07132015 SR 4753
                     WHERE policy_id = a.policy_id;                    
                    DELETE FROM giex_new_group_tax
                     WHERE policy_id = a.policy_id;
                    DELETE FROM giex_new_group_peril
                     WHERE policy_id = a.policy_id;                 
                    DELETE FROM giex_itmperil
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
            
            FOR a IN (SELECT param_value_v restrict_spoil
                        FROM giis_parameters
                       WHERE param_name = 'RESTRICT_SPOIL_OF_REC_WACCT_ENT_DATE')
            LOOP
                v_restrict := a.restrict_spoil;
                EXIT;
            END LOOP;
            
            IF v_acct_ent_date IS NOT NULL THEN
                IF v_restrict      = 'Y' THEN
                    raise_application_error('-20001',
                                            'Geniisys Exception#I#Policy / Endorsement has been considered in Accounting on ' || 
                                            TO_CHAR(v_acct_ent_date,'fmMonth DD, YYYY') || ', Cannot spoil policy.');
                ELSE
                    p_msg_considered := 'Policy / Endorsement has been considered in Accounting on ' || TO_CHAR(v_acct_ent_date,'fmMonth DD, YYYY') || 
                                        ', Please inform Accounting of spoilage.';
                END IF;
            END IF;
            
            /* Check if the policy is an open policy, thus restrict 
            ** the user from tagging the policy for spoilage if it 
            ** is used by an MRN policy.  
            */
            IF v_subline_cd = v_subline THEN
                 IF v_endt_seq_no = 0 THEN
                    check_mrn(v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no);
                 END IF;
            END IF;
            
            
            IF v_spld_flag = '2' THEN
             --check_oth_endt;
             --A.R.C. 11.21.2006
                 FOR A2 IN (SELECT dist_no
                              FROM giuw_pol_dist
                             WHERE policy_id = v_policy_id) 
                 LOOP
                     --AND negate_date IS NULL) LOOP
                     chk_reinsurance(A2.DIST_NO, v_line_cd);
                 END LOOP;
                       --A.R.C. 11.21.2006
                       /*:B250.pol_flag := '5';
                       :B250.dist_flag := '4';
                       :B250.user_id   := USER;
                       :B250.last_upd_date := SYSDATE;*/ 
                          
                      -- belle 08092010 
                           /**  UPDATE gipi_polbasic
                                SET pol_flag = '5',  -- aaron 082609
                                    --pol_flag = '1',             --ryanv 09/16/08
                              dist_flag = '4',
                              user_id = USER,
                              last_upd_date = SYSDATE
                        WHERE policy_id = variables.b250_policy_id; **/ 
                           
                 FOR A2 IN (SELECT dist_no
                              FROM giuw_pol_dist
                             WHERE policy_id = v_policy_id) LOOP
                               --AND negate_date IS NULL) LOOP
                     UPDATE giuw_pol_dist
                        SET negate_date = SYSDATE,
                            dist_flag   = '4'
                      WHERE policy_id = v_policy_id
                        AND dist_no  = a2.dist_no;
                 END LOOP;
                 --A.R.C. 11.21.2006     
                 /*:b250.spld_flag := '3';
                 :b250.spld_date := SYSDATE;
                 :b250.spld_user_id := USER;
                 :b250.spld_approval := :cg$ctrl.cgu$user;
                 :b250.pol_flag   := '5';*/

                    -- belle 08092010 
                     /**UPDATE gipi_polbasic
                        SET spld_flag = '3',            
                        spld_date = SYSDATE,
                        spld_user_id = USER,
                        spld_approval = :cg$ctrl.cgu$user,
                        pol_flag = '5'  -- aaron 082609
                       -- pol_flag = '1'    --ryanv 09/16/08
                  WHERE policy_id = variables.b250_policy_id; **/

                     /* Loth 031299
                 ** Populate non-base table field to display domain meaning
                 */

                -- A.R.C. 11.21.2006
                --     BEGIN
                --       curr_value := :B250.SPLD_FLAG;
                --       CGDV$CHK_CHAR_REF_CODES(
                --         curr_value                  /* MOD: Value to be validated        */
                --        ,:B250.MEAN_POL_FLAG         /* MOD: Domain meaning               */
                --        ,'GIPI_POLBASIC.SPLD_FLAG');  /* IN : Reference codes domain       */
                --     EXCEPTION
                --       WHEN NO_DATA_FOUND THEN
                --         :B250.MEAN_POL_FLAG := NULL;
                --       WHEN OTHERS THEN
                --         CGTE$OTHER_EXCEPTIONS;
                --     END;
                  
                 /* End of Update */

                --beth 051299
                FOR A1 IN(SELECT pol_flag
                           FROM gipi_polbasic
                          WHERE policy_id = v_policy_id) LOOP
                   IF A1.pol_flag = '4' THEN
                     --beth 06202000 update of eis_flag to 'N' of affected records
                     --     of the spoiled cancelling endorsement
                     UPDATE gipi_polbasic
                        SET pol_flag = old_pol_flag
                            --eis_flag = 'N'
                      WHERE line_cd    = v_line_cd
                        AND subline_cd = v_subline_cd
                        AND iss_cd     = v_iss_cd
                        AND issue_yy   = v_issue_yy
                        AND pol_seq_no = v_pol_seq_no    
                        AND renew_no   = v_renew_no
                        AND pol_flag  != '5'
                        AND policy_id != v_policy_id;
                   END IF;
                   EXIT;
                END LOOP;
                    
                 --belle 08092010
                 UPDATE gipi_polbasic
                    SET pol_flag = '5',  
                        dist_flag = '4',
                        spld_flag = '3',
                        spld_date = SYSDATE,
                        spld_approval = p_user_id,
                        user_id = p_user_id,
                        last_upd_date = SYSDATE
                  WHERE policy_id = v_policy_id;  
                 --end update
                                 
                 --beth 10202000 update eim_flag of table eim_takeup_info
                 --     '3' = spoiled policies but not yet taken up by EIM
                 --           eim_flag IN (null, '1')
                 --     '5' = policies taken up by EIM but were spoiled after the take-up
                 --           eim_flag IN ('2', '4')
                 UPDATE eim_takeup_info
                    SET eim_flag = DECODE(eim_flag, NULL, '3', '1', '3','2','5','4','5',eim_flag)
                  WHERE policy_id = v_policy_id;
                      

                FOR x IN (SELECT ann_tsi_amt, pol_flag
                              FROM gipi_pack_polbasic
                             WHERE pack_policy_id = p_pack_policy_id)
                LOOP           
                    IF x.ann_tsi_amt != 0 AND x.pol_flag != '4' THEN -- endorsement to be spoiled is not a cancelling endorsement aaron 082809
                        update_affected_endt(v_policy_id, v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no,
                                             v_prorate_flag, v_comp_sw, v_endt_expiry_date, v_eff_date, v_short_rt_percent);
                    END IF;
                END LOOP; 
                --  UPDATE_AFFECTED_ENDT;
                  --beth  12132000
                  --      if policy to be spoiled had already been extracted
                  --      delete data for that particular record in expiry tables
                      
                  --A.R.C. 11.21.2006           
                  --COMMIT;
                  --CLEAR_MESSAGE;
                --beth 06202000 update of eis_flag to 'N' upon record's spoilage
                 UPDATE gipi_polbasic
                    SET eis_flag = 'N'
                  WHERE policy_id = v_policy_id;

                 --A.R.C. 11.21.2006
                 /*GO_ITEM('b250.spld_flag');
                 SET_ITEM_PROPERTY('b250.but_unspoil',ENABLED,PROPERTY_FALSE);
                 SET_ITEM_PROPERTY('b250.but_unspoil',NAVIGABLE,PROPERTY_FALSE);
                 SET_ITEM_PROPERTY('b250.but_post',ENABLED,PROPERTY_FALSE);
                 SET_ITEM_PROPERTY('b250.but_post',NAVIGABLE,PROPERTY_FALSE);
                 COMMIT;
                 CLEAR_MESSAGE;
                 MESSAGE('Policy/Endorsement has been spoiled.',NO_ACKNOWLEDGE);*/
            ELSIF v_spld_flag = '1' THEN
                raise_application_error('-20001',
                                        'Geniisys Exception#E#Policy / Endorsement has not yet been tagged for spoilage, cannot post.');

-- apollo cruz 11.13.2015 sr#20906
--            ELSE
--                raise_application_error('-20001',
--                                        'Geniisys Exception#E#Policy /Endorsement has been spoiled.');
            END IF;
            
            cnt := cnt + 1;
            DELETE FROM giex_pack_expiry   --added by kenneth 07132015 SR 4753
               WHERE pack_policy_id = p_pack_policy_id;
            
        END LOOP;
        
        
        -- added by apollo cruz 11.24.2015 sr#20906
        SELECT spld_flag
          INTO v_spld_flag
          FROM gipi_pack_polbasic
         WHERE pack_policy_id = p_pack_policy_id; 
        
        pack_post(p_pack_policy_id, v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_spld_flag, p_user_id,
                  p_mean_pol_flag, p_ann_prem_amt, p_ann_tsi_amt);
                  
        p_final_msg := 'SUCCESS';
        
    END chk_pack_policy_post;
    
    
    /* 
    *   Check RI records; if there are existing records in RI then
    *   update their reverse dates to the current date.
    */
    PROCEDURE chk_reinsurance(
        p_dist_no       NUMBER,
        p_line_cd       giuw_policyds_dtl.LINE_CD%TYPE
    )
    AS
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
            v_param_value_n  :=  A1.param_value_n;
            EXIT;
        END LOOP;
        
        IF v_param_value_n IS NOT NULL THEN
            FOR A2 IN (SELECT a.dist_no      dist_no,
                              a.dist_seq_no  dist_seq_no,
                              a.line_cd      line_cd,
                              a.share_cd     share_cd
                         FROM giuw_policyds_dtl a,giuw_policyds b
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
             
                FOR A3 IN (SELECT frps_yy,frps_seq_no
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
                       --ASI 051499 update reverse_date of binders which are not yet reversed
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
    END chk_reinsurance;
    
    
    /*  
    *   update affected endorsements
    */
    PROCEDURE update_affected_endt(
        p_policy_id         GIPI_POLBASIC.POLICY_ID%TYPE , 
        p_line_cd           GIPI_POLBASIC.LINE_CD%TYPE , 
        p_subline_cd        GIPI_POLBASIC.SUBLINE_CD%TYPE , 
        p_iss_cd            GIPI_POLBASIC.ISS_CD%TYPE , 
        p_issue_yy          GIPI_POLBASIC.ISSUE_YY%TYPE , 
        p_pol_seq_no        GIPI_POLBASIC.POL_SEQ_NO%TYPE , 
        p_renew_no          GIPI_POLBASIC.RENEW_NO%TYPE ,
        p_prorate_flag      GIPI_POLBASIC.PRORATE_FLAG%TYPE , 
        p_comp_sw           GIPI_POLBASIC.COMP_SW%TYPE , 
        p_endt_expiry_date  GIPI_POLBASIC.ENDT_EXPIRY_DATE%TYPE , 
        p_eff_date          GIPI_POLBASIC.EFF_DATE%TYPE , 
        p_short_rt_percent  GIPI_POLBASIC.SHORT_RT_PERCENT%TYPE
    )
    AS
        v_comp_prem         gipi_witmperl.tsi_amt%TYPE;
        v_prorate           gipi_witmperl.prem_rt%TYPE;
    BEGIN
        FOR itmperl IN( SELECT b480.item_no,  b480.currency_rt, a170.peril_type,
                               b490.peril_cd, b490.tsi_amt, b490.prem_amt
                          FROM gipi_item b480,  
                               giis_peril a170, 
                               gipi_itmperil b490
                         WHERE b480.policy_id = b490.policy_id
                           AND b480.item_no =b490.item_no
                           AND b490.line_cd = a170.line_cd
                           AND b490.peril_cd = a170.peril_cd
                           AND b490.policy_id = p_policy_id)
        LOOP
            v_comp_prem := NULL;
            IF nvl(p_prorate_flag,2) = 1 THEN
                IF p_comp_sw = 'Y' THEN
                    v_prorate  :=  ((TRUNC( p_endt_expiry_date) - TRUNC(p_eff_date )) + 1 )/
                                   (ADD_MONTHS(p_eff_date,12) - p_eff_date);
                ELSIF p_comp_sw = 'M' THEN
                    v_prorate  :=  ((TRUNC( p_endt_expiry_date) - TRUNC(p_eff_date )) - 1 )/
                                   (ADD_MONTHS(p_eff_date,12) - p_eff_date);
                ELSE 
                    v_prorate  :=  (TRUNC( p_endt_expiry_date) - TRUNC(p_eff_date ))/
                                   (ADD_MONTHS(p_eff_date,12) - p_eff_date);
                END IF;
                v_comp_prem  := itmperl.prem_amt/v_prorate;
            ELSIF nvl(p_prorate_flag,2) = 2 THEN
                v_comp_prem  := itmperl.prem_amt;
            ELSE
                v_comp_prem :=  itmperl.prem_amt/(p_short_rt_percent/100);  
            END IF;
                
            FOR A1 IN(SELECT policy_id
                        FROM gipi_polbasic b250
                       WHERE b250.line_cd     = p_line_cd
                         AND b250.subline_cd  = p_subline_cd
                         AND b250.iss_cd      = p_iss_cd
                         AND b250.issue_yy    = p_issue_yy
                         AND b250.pol_seq_no  = p_pol_seq_no
                         AND b250.renew_no    = p_renew_no
                         AND b250.eff_date    > p_eff_date
                         AND b250.endt_seq_no > 0    
                         AND b250.pol_flag in('1','2','3')     
                         AND NVL(b250.endt_expiry_date,b250.expiry_date) >=  p_eff_date)
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
                       AND item_no = itmperl.item_no
                       AND peril_cd = itmperl.peril_cd;
                END LOOP;
                  
                IF itmperl.peril_type = 'B' THEN
                    UPDATE gipi_item
                       SET ann_tsi_amt  = ann_tsi_amt - itmperl.tsi_amt,
                           ann_prem_amt = ann_prem_amt - NVL(v_comp_prem,itmperl.prem_amt)
                     WHERE policy_id = a1.policy_id
                       AND item_no = itmperl.item_no;                
                  
                    UPDATE gipi_polbasic
                       SET ann_tsi_amt  = ann_tsi_amt - ROUND((itmperl.tsi_amt * NVL(itmperl.currency_rt,1)),2),
                           ann_prem_amt = ann_prem_amt - ROUND((NVL(v_comp_prem,itmperl.prem_amt) * NVL(itmperl.currency_rt,1)),2)
                     WHERE policy_id = a1.policy_id;
                ELSE
                    UPDATE gipi_item
                       SET ann_prem_amt = ann_prem_amt + NVL(v_comp_prem,itmperl.prem_amt)
                     WHERE policy_id = a1.policy_id
                       AND item_no = itmperl.item_no;                
                    
                    UPDATE gipi_polbasic
                       SET ann_prem_amt = ann_prem_amt - ROUND((NVL(v_comp_prem,itmperl.prem_amt) * NVL(itmperl.currency_rt,1)),2)
                     WHERE policy_id = a1.policy_id;
                END IF;
            END LOOP;
        END LOOP;
        
    END update_affected_endt;
    
    
    /*
    *   procedure to perform posting of spoilage
    */ 
    PROCEDURE pack_post(
        p_pack_policy_id    GIPI_PACK_POLBASIC.PACK_POLICY_ID%TYPE,
        p_line_cd           GIPI_PACK_POLBASIC.LINE_CD%TYPE,
        p_subline_cd        GIPI_PACK_POLBASIC.SUBLINE_CD%TYPE,
        p_iss_cd            GIPI_PACK_POLBASIC.ISS_CD%TYPE,
        p_issue_yy          GIPI_PACK_POLBASIC.ISSUE_YY%TYPE,
        p_pol_seq_no        GIPI_PACK_POLBASIC.POL_SEQ_NO%TYPE,
        p_renew_no          GIPI_PACK_POLBASIC.RENEW_NO%TYPE,
        p_spld_flag         GIPI_PACK_POLBASIC.SPLD_FLAG%TYPE,
        p_user_id           GIPI_PACK_POLBASIC.SPLD_APPROVAL%TYPE,
        p_mean_pol_flag OUT VARCHAR2,
        p_ann_prem_amt  OUT GIPI_PACK_POLBASIC.ANN_PREM_AMT%TYPE,
        p_ann_tsi_amt   OUT GIPI_PACK_POLBASIC.ANN_TSI_AMT%TYPE
    )
    AS
        curr_value       VARCHAR2(1) ;
    BEGIN
        --belle 08092010 
        FOR A1 IN(SELECT pol_flag, old_pol_flag
                   FROM gipi_pack_polbasic
                  WHERE pack_policy_id = p_pack_policy_id) 
        LOOP
            IF A1.pol_flag = '4' THEN
                 --beth 06202000 update of eis_flag to 'N' of affected records
                 --     of the spoiled cancelling endorsement
                 UPDATE gipi_pack_polbasic
                    SET pol_flag = old_pol_flag
                        --eis_flag = 'N'
                  WHERE line_cd    = p_line_cd
                    AND subline_cd = p_subline_cd
                    AND iss_cd     = p_iss_cd
                    AND issue_yy   = p_issue_yy
                    AND pol_seq_no = p_pol_seq_no    
                    AND renew_no   = p_renew_no
                    AND pol_flag  != '5'
                    AND pack_policy_id != p_pack_policy_id;
            END IF;
            EXIT;
        END LOOP;
        
        IF p_spld_flag = '2' THEN
            UPDATE gipi_pack_polbasic
               SET pol_flag = '5',
                   dist_flag = '4',
                   spld_flag = '3',
                   user_id   = p_user_id,
                   last_upd_date = SYSDATE,
                   spld_date = SYSDATE,
                   spld_user_id = p_user_id,
                   spld_approval = p_user_id
             WHERE pack_policy_id = p_pack_policy_id;
             
            BEGIN
                curr_value := '3';
                CHK_CHAR_REF_CODES(curr_value                   /* MOD: Value to be validated        */
                                   ,p_mean_pol_flag             /* MOD: Domain meaning               */
                                   ,'GIPI_POLBASIC.SPLD_FLAG'); /* IN : Reference codes domain       */
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_mean_pol_flag := NULL;
                WHEN OTHERS THEN
                    p_mean_pol_flag := NULL;
            END;
             
            FOR c2 IN (SELECT SUM(ann_tsi_amt) ann_tsi_amt, SUM(ann_prem_amt) ann_prem_amt
                         FROM gipi_polbasic
                        WHERE pack_policy_id = p_pack_policy_id)
            LOOP
                  p_ann_tsi_amt := c2.ann_tsi_amt;
                p_ann_prem_amt := c2.ann_prem_amt;
            END LOOP;
            
            --beth 06202000 update of eis_flag to 'N' upon record's spoilage
            --A.R.C. 11.21.2006
            UPDATE gipi_pack_polbasic
               SET eis_flag = 'N'
            WHERE pack_policy_id = p_pack_policy_id;
        END IF;
        
    END pack_post;
    
END GIUTS003A_PKG;
/


