DROP PROCEDURE CPI.GET_GICL055_REC_PAYT_INFO;

CREATE OR REPLACE PROCEDURE CPI.GET_GICL055_REC_PAYT_INFO (
    p_claim_id                IN  gicl_claims.claim_id%TYPE,
    p_acct_tran_id            IN  GICL_RECOVERY_PAYT.acct_tran_id%TYPE,
    p_recovery_id             IN  GICL_RECOVERY_PAYT.recovery_id%TYPE,
    
    p_line_cd                 OUT GICL_CLM_RECOVERY.line_cd%TYPE,
    p_iss_cd                  OUT GICL_CLM_RECOVERY.iss_cd%TYPE,
    p_rec_year                OUT GICL_CLM_RECOVERY.rec_year%TYPE,
    p_rec_seq_no              OUT GICL_CLM_RECOVERY.rec_seq_no%TYPE,
    p_line_cd2                OUT GICL_CLAIMS.line_cd%TYPE,
    p_subline_cd1             OUT GICL_CLAIMS.subline_cd%TYPE,    
    p_iss_cd1                 OUT GICL_CLAIMS.iss_cd%TYPE,
    p_clm_yy                  OUT VARCHAR2,
    p_clm_seq_no              OUT VARCHAR2,
    p_pol_iss_cd              OUT GICL_CLAIMS.pol_iss_cd%TYPE,
    p_issue_yy                OUT VARCHAR2,
    p_pol_seq_no              OUT VARCHAR2,
    p_renew_no                OUT VARCHAR2,
    
    p_dsp_assured_name        OUT GICL_CLAIMS.assured_name%TYPE,
    p_dsp_recovery_no         OUT VARCHAR2,
    p_dsp_ref_no              OUT VARCHAR2,
    p_dsp_claim_number        OUT VARCHAR2,
    p_dsp_policy_no           OUT VARCHAR2,
    p_dsp_loss_date           OUT VARCHAR2,
    p_dsp_loss_ctgry          OUT GIIS_LOSS_CTGRY.loss_cat_des%TYPE,
    p_clm_stat_cd             OUT GICL_CLAIMS.clm_stat_cd%TYPE,
    p_in_hou_adj              OUT GICL_CLAIMS.in_hou_adj%TYPE
) IS
BEGIN
   /*
   **  Created by   :  D.Alcantara
   **  Date Created : 12.14.2011
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  : 
   */ 
   
   FOR rec IN
    (SELECT line_cd, iss_cd, rec_year, rec_seq_no
       FROM gicl_clm_recovery
      WHERE recovery_id = p_recovery_id)
   LOOP 
       p_line_cd := rec.line_cd;
       p_iss_cd := rec.iss_cd;
       p_rec_year := rec.rec_year;  
       p_rec_seq_no := rec.rec_seq_no;
       p_dsp_recovery_no  := rec.line_cd || '-' || rec.iss_cd || '-' || rec.rec_year || '-' || TO_CHAR(rec.rec_seq_no,'099');
   END LOOP;
   
   FOR a IN
      (SELECT a.line_cd, a.subline_cd, a.iss_cd, a.clm_yy, a.clm_seq_no,
                a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                a.assured_name, a.dsp_loss_date, b.loss_cat_des,
                a.in_hou_adj, a.clm_stat_cd -- added by Pia, 09.05.03
           FROM gicl_claims a, giis_loss_ctgry b
          WHERE a.loss_cat_cd = b.loss_cat_cd
            AND a.line_cd     = b.line_cd
            AND a.claim_id    = p_claim_id)
     LOOP
        p_line_cd2    := a.line_cd;
        p_subline_cd1 := a.subline_cd;
        p_iss_cd1     := a.iss_cd;
        p_clm_yy      := a.clm_yy;
        p_clm_seq_no  := a.clm_seq_no;
        p_issue_yy    := a.issue_yy; 
        p_pol_seq_no  := a.pol_seq_no;
        p_renew_no    := a.renew_no; 
        p_pol_iss_cd  := a.pol_iss_cd;
    
        p_dsp_assured_name := a.assured_name;
        p_dsp_claim_number := a.line_cd || '-' || a.subline_cd || '-' || a.iss_cd || '-' 
                                || TO_CHAR(a.clm_yy) || '-' || TO_CHAR(a.clm_seq_no);
        p_dsp_policy_no := a.line_cd || '-' || a.subline_cd || '-' || a.pol_iss_cd || '-' 
                                || TO_CHAR(a.issue_yy) || '-' || TO_CHAR(a.pol_seq_no) || '-' || TO_CHAR(a.renew_no);     
        p_dsp_loss_date   := TO_CHAR(a.dsp_loss_date);
        p_dsp_loss_ctgry  := a.loss_cat_des;
        p_clm_stat_cd := a.clm_stat_cd;
        p_in_hou_adj  := a.in_hou_adj;
     END LOOP;
     
   FOR t IN (SELECT tran_class, TO_CHAR(tran_class_no,'0999999999') tran_class_no
                FROM giac_acctrans
               WHERE tran_id = p_acct_tran_id)
    LOOP 
      IF t.tran_class = 'COL' THEN
         FOR c IN (
           SELECT or_pref_suf||'-'||TO_CHAR(or_no,'0999999999') or_no 
             FROM giac_order_of_payts
            WHERE gacc_tran_id = p_acct_tran_id)
         LOOP
           p_dsp_ref_no := c.or_no;
         END LOOP; 
      ELSIF t.tran_class = 'DV' THEN
         FOR r IN (
           SELECT document_cd||'-'||branch_cd||'-'||TO_CHAR(doc_year)
                  ||'-'||TO_CHAR(doc_mm)||'-'||TO_CHAR(doc_seq_no,'099999') request_no
             FROM giac_payt_requests a, giac_payt_requests_dtl b
            WHERE a.ref_id = b.gprq_ref_id
              AND b.tran_id = p_acct_tran_id)
         LOOP 
           p_dsp_ref_no := r.request_no;
           FOR d IN (   
             SELECT dv_pref||'-'||TO_CHAR(dv_no,'0999999999') dv_no
               FROM giac_disb_vouchers
              WHERE gacc_tran_id = p_acct_tran_id)
           LOOP
             p_dsp_ref_no := d.dv_no;
           END LOOP;
         END LOOP; 
      ELSIF t.tran_class = 'JV' THEN
         p_dsp_ref_no := t.tran_class||'-'||t.tran_class_no; 
      END IF;
    END LOOP;   
END GET_GICL055_REC_PAYT_INFO;
/


