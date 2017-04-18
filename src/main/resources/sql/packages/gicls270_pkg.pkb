CREATE OR REPLACE PACKAGE BODY CPI.gicls270_pkg
AS
    FUNCTION populate_gicls270(
        P_USER_ID           VARCHAR2
    )
        RETURN gicls270_tab PIPELINED
    IS
        ntt     gicls270_type;
    BEGIN
    
        FOR i IN(
             SELECT b.recovery_id, b.line_cd, b.iss_cd, b.rec_year, b.rec_seq_no,
                    b.cancel_tag, NVL(b.recoverable_amt,0) recoverable_amt, NVL(b.recovered_amt,0) recovered_amt, a.claim_id,
                    a.line_cd line_cd2, a.subline_cd, a.iss_cd iss_cd2, a.clm_yy,
                    a.clm_seq_no, a.issue_yy, a.pol_seq_no, a.renew_no, a.assd_no,
                    a.assured_name, a.loss_cat_cd, a.loss_date, a.pol_iss_cd
               FROM gicl_claims a, gicl_clm_recovery b
              WHERE b.claim_id = a.claim_id
                AND check_user_per_line2(b.line_cd, b.iss_cd, 'GICLS270', p_user_id) = 1    --Gzelle 12.9.2013
                AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, 'GICLS270', p_user_id) = 1  --Gzelle 12.9.2013
             --ORDER BY b.line_cd, b.iss_cd, b.rec_year, b.rec_seq_no
                --commented out to replicate behavior in CS 
                --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS270', P_USER_ID) = 1
        )
        
        LOOP
        
            ntt.recovery_id         :=  i.recovery_id;
            ntt.line_cd             :=  i.line_cd;
            ntt.iss_cd              :=  i.iss_cd;
            ntt.rec_year            :=  i.rec_year;
            ntt.rec_seq_no          :=  i.rec_seq_no;
            ntt.cancel_tag          :=  i.cancel_tag;
            ntt.recoverable_amt     :=  i.recoverable_amt;
            ntt.recovered_amt       :=  i.recovered_amt;
            ntt.claim_id            :=  i.claim_id;
            ntt.line_cd2            :=  i.line_cd2;
            ntt.subline_cd          :=  i.subline_cd;
            ntt.iss_cd2             :=  i.iss_cd2;
            ntt.clm_yy              :=  i.clm_yy;
            ntt.clm_seq_no          :=  i.clm_seq_no;
            ntt.issue_yy            :=  i.issue_yy;
            ntt.pol_seq_no          :=  i.pol_seq_no;
            ntt.renew_no            :=  i.renew_no;
            ntt.assd_no             :=  i.assd_no;
            ntt.assured_name        :=  i.assured_name;
            ntt.loss_cat_cd         :=  i.loss_cat_cd;
            ntt.loss_date           :=  i.loss_date;
            ntt.recovery_number     :=  i.line_cd || '-' || i.iss_cd || '-' || i.rec_year || '-' || TO_CHAR(i.rec_seq_no,'009');
            --ntt.claim_number        :=  i.line_cd2 || '-' || i.subline_cd || '-' || TO_CHAR(i.clm_yy,'09') || '-' || TO_CHAR(i.clm_seq_no, '0000009');
            ntt.claim_number        :=  get_claim_number(i.claim_id);
            ntt.policy_number       :=  i.line_cd2 || '-' || i.subline_cd || '-' || i.pol_iss_cd || '-' || TO_CHAR(i.issue_yy,'09') || '-' || TO_CHAR(i.pol_seq_no, '0000009') || '-' || TO_CHAR(i.renew_no,'09');
            
            
            FOR c IN (
                SELECT loss_cat_des
                  FROM giis_loss_ctgry
                 WHERE loss_cat_cd = i.loss_cat_cd 
                   AND line_cd = i.line_cd
            )
            LOOP
                ntt.loss_cat_desc := i.loss_cat_cd||'-'||c.loss_cat_des; 
            END LOOP;
            
            IF i.cancel_tag IS NULL THEN
               ntt.cancel_desc := 'IN PROGRESS';
            ELSIF i.cancel_tag = 'CD' THEN
               ntt.cancel_desc := 'CLOSED';
            ELSIF i.cancel_tag = 'CC' THEN
               ntt.cancel_desc := 'CANCELLED';
            ELSIF i.cancel_tag = 'WO' THEN
               ntt.cancel_desc := 'WRITTEN OFF';
            END IF;
            
            SELECT COUNT(*)
              INTO ntt.v_check
              FROM gicl_recovery_payt a
             WHERE a.recovery_id = i.recovery_id;
            
            PIPE ROW(ntt);
        END LOOP;
        RETURN;
    END populate_gicls270;
    
    FUNCTION populate_payment_det(
        P_RECOVERY_ID       GICL_RECOVERY_PAYT.recovery_id%TYPE
    )
        RETURN gicls270_payment_det_tab PIPELINED
    IS
        ntt     gicls270_payment_det_type;
    BEGIN
    

    
        FOR i IN (
            SELECT  payor_class_cd, payor_cd, recovered_amt, tran_date,
                    cancel_tag, dist_sw, claim_id, acct_tran_id, recovery_id,
                    recovery_payt_id
              FROM  GICL_RECOVERY_PAYT
             WHERE recovery_id = P_RECOVERY_ID
        )
        
        LOOP
            ntt.payor_class_cd      := i.payor_class_cd;
            ntt.payor_cd            := i.payor_cd;
            ntt.recovered_amt       := i.recovered_amt;
            ntt.tran_date           := i.tran_date;
            ntt.cancel_tag          := i.cancel_tag;
            ntt.dist_sw             := i.dist_sw;
            ntt.claim_id            := i.claim_id;
            ntt.acct_tran_id        := i.acct_tran_id;
            ntt.recovery_id         := i.recovery_id;
            ntt.recovery_payt_id    := i.recovery_payt_id;
            
            FOR p IN(
                SELECT DECODE(payee_first_name,NULL,payee_last_name,
                       payee_last_name||', '||
                       payee_first_name||' '||
                       payee_middle_name) payor
                  FROM giis_payees
                 WHERE payee_class_cd = i.payor_class_cd
                   AND payee_no       = i.payor_cd
            )
            LOOP 
                ntt.payee_name  := p.payor;
                ntt.payor_det   := i.payor_class_cd || '-' || i.payor_cd || '-' || p.payor;
            END LOOP;
            
            BEGIN
              FOR t IN (SELECT tran_class, TO_CHAR(tran_class_no,'0999999999') tran_class_no
                          FROM giac_acctrans
                         WHERE tran_id = i.acct_tran_id)
              LOOP 
                IF t.tran_class = 'COL' THEN
                   FOR c IN (
                     SELECT or_pref_suf||'-'||TO_CHAR(or_no,'0999999999') or_no 
                       FROM giac_order_of_payts
                      WHERE gacc_tran_id = i.acct_tran_id)
                   LOOP
                     ntt.ref_no := c.or_no;
                   END LOOP; 
                ELSIF t.tran_class = 'DV' THEN
                   FOR r IN (
                     SELECT document_cd||'-'||branch_cd||'-'||TO_CHAR(doc_year)
                            ||'-'||TO_CHAR(doc_mm)||'-'||TO_CHAR(doc_seq_no,'099999') request_no
                       FROM giac_payt_requests a, giac_payt_requests_dtl b
                      WHERE a.ref_id = b.gprq_ref_id
                        AND b.tran_id = i.acct_tran_id)
                   LOOP 
                     ntt.ref_no := r.request_no;
                     FOR d IN (   
                       SELECT dv_pref||'-'||TO_CHAR(dv_no,'0999999999') dv_no
                         FROM giac_disb_vouchers
                        WHERE gacc_tran_id = i.acct_tran_id)
                     LOOP
                       ntt.ref_no := d.dv_no;
                     END LOOP;
                   END LOOP; 
                ELSIF t.tran_class = 'JV' THEN
                   ntt.ref_no := t.tran_class||'-'||t.tran_class_no; 
                END IF;
              END LOOP; 
            END; 
            
            BEGIN
                SELECT COUNT(*)
                  INTO ntt.v_check
                  FROM gicl_recovery_ds a
                 WHERE a.recovery_id = i.recovery_id
                 AND a.recovery_payt_id = i.recovery_payt_id;
                 
            EXCEPTION     
            WHEN NO_DATA_FOUND THEN
                ntt.v_check := -1;
            END;
        
        
        PIPE ROW(ntt);
        END LOOP;
         
        RETURN;
    END populate_payment_det;
    
    FUNCTION populate_distribution_ds(
        P_RECOVERY_ID       GICL_RECOVERY_PAYT.recovery_id%TYPE,
        P_RECOVERY_PAYT_ID  GICL_RECOVERY_PAYT.recovery_payt_id%TYPE
    )    
        RETURN gicls270_distribution_ds_tab PIPELINED
    IS
        ntt         gicls270_distribution_ds_type;
    BEGIN
    
        FOR i IN(
            SELECT recovery_id, recovery_payt_id, rec_dist_no, line_cd,
                   grp_seq_no, share_type, acct_trty_type, dist_year,
                   shr_recovery_amt, negate_tag, negate_date, user_id, 
                   last_update,share_pct
              FROM GICL_RECOVERY_DS
             WHERE recovery_id = P_RECOVERY_ID
               AND recovery_payt_id = P_RECOVERY_PAYT_ID
               AND NVL(negate_tag,'N') = 'N'
        )
        
        LOOP
        
            ntt.recovery_id         := i.recovery_id;
            ntt.recovery_payt_id    := i.recovery_payt_id;
            ntt.rec_dist_no         := i.rec_dist_no;
            ntt.line_cd             := i.line_cd;
            ntt.grp_seq_no          := i.grp_seq_no;
            ntt.share_type          := i.share_type;
            ntt.acct_trty_type      := i.acct_trty_type;
            ntt.dist_year           := i.dist_year;
            ntt.shr_recovery_amt    := i.shr_recovery_amt;
            ntt.negate_tag          := i.negate_tag;
            ntt.negate_date         := i.negate_date;
            ntt.user_id             := i.user_id;
            ntt.last_update         := i.last_update;
            ntt.share_pct           := i.share_pct;
            
            BEGIN
              FOR s IN (SELECT trty_name
                          FROM giis_dist_share
                         WHERE line_cd = i.line_cd
                           AND share_cd = i.grp_seq_no)
              LOOP
                ntt.share_name := s.trty_name;
              END LOOP;
            END;
            
        PIPE ROW(ntt);
        END LOOP;
        RETURN;
    END populate_distribution_ds;
    
    FUNCTION populate_distribution_rids(
        P_RECOVERY_ID       GICL_RECOVERY_RIDS.recovery_id%TYPE,
        P_RECOVERY_PAYT_ID  GICL_RECOVERY_RIDS.recovery_payt_id%TYPE,
        P_REC_DIST_NO       GICL_RECOVERY_RIDS.rec_dist_no%TYPE,
        P_GRP_SEQ_NO        GICL_RECOVERY_RIDS.grp_seq_no%TYPE
    )    
        RETURN gicls270_dist_rids_tab PIPELINED
    IS
        ntt     gicls270_dist_rids_type;
    BEGIN
    
        FOR i IN(
            SELECT recovery_id, recovery_payt_id, rec_dist_no, line_cd,
                   grp_seq_no, dist_year, share_type, acct_trty_type,
                   ri_cd, share_ri_pct, shr_ri_recovery_amt, share_ri_pct_real,
                   negate_tag, negate_date, user_id, last_update, cpi_rec_no,
                   cpi_branch_cd
              FROM GICL_RECOVERY_RIDS
             WHERE recovery_id = P_RECOVERY_ID
               AND recovery_payt_id = P_RECOVERY_PAYT_ID
               AND rec_dist_no = P_REC_DIST_NO
               AND grp_seq_no = P_GRP_SEQ_NO
        )
        
        LOOP
        
            ntt.recovery_id             := i.recovery_id;
            ntt.recovery_payt_id        := i.recovery_payt_id;
            ntt.rec_dist_no             := i.rec_dist_no;
            ntt.line_cd                 := i.line_cd;
            ntt.grp_seq_no              := i.grp_seq_no;
            ntt.dist_year               := i.dist_year;
            ntt.share_type              := i.share_type;
            ntt.acct_trty_type          := i.acct_trty_type;
            ntt.ri_cd                   := i.ri_cd;
            ntt.share_ri_pct            := i.share_ri_pct;
            ntt.shr_ri_recovery_amt     := i.shr_ri_recovery_amt;
            ntt.share_ri_pct_real       := i.share_ri_pct_real;
            ntt.negate_tag              := i.negate_tag;
            ntt.negate_date             := i.negate_date;
            ntt.user_id                 := i.user_id;
            ntt.last_update             := i.last_update;
            ntt.cpi_rec_no              := i.cpi_rec_no;
            ntt.cpi_branch_cd           := i.cpi_branch_cd;
            
            BEGIN
              FOR r IN (SELECT ri_name
                          FROM giis_reinsurer
                         WHERE ri_cd = i.ri_cd)
              LOOP
                ntt.ri_name := r.ri_name;
              END LOOP;
            END;
        
        PIPE ROW(ntt);
        END LOOP;
        RETURN;
    END populate_distribution_rids;
END;
/


