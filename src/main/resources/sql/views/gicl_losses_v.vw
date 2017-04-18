DROP VIEW CPI.GICL_LOSSES_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gicl_losses_v (assd_name,
                                                policy_no,
                                                claim_no,
                                                eff_date,
                                                dsp_loss_date,
                                                expiry_date,
                                                clm_yy,
                                                clm_stat_type,
                                                claim_id,
                                                policy_id,
                                                line_cd,
                                                subline_cd,
                                                iss_cd,
                                                loss_res_amt,
                                                loss_pd_amt,
                                                check_date,
                                                clm_file_date,
                                                tsi_amt,
                                                MONTH
                                               )
AS
   (SELECT c.assd_name,
           (   e.line_cd
            || '-'
            || e.subline_cd
            || '-'
            || e.pol_iss_cd
            || '-'
            || LPAD (e.issue_yy, 2, 0)
            || '-'
            || LPAD (e.pol_seq_no, 7, 0)
            || '-'
            || LPAD (e.renew_no, 2, 0)
           ) policy_no,
           (   e.line_cd
            || '-'
            || e.subline_cd
            || '-'
            || e.iss_cd
            || '-'
            || LPAD (e.clm_yy, 2, 0)
            || '-'
            || LPAD (e.clm_seq_no, 7, 0)
           ) claim_no,
           d.eff_date, e.dsp_loss_date, d.expiry_date, e.clm_yy,
           g.clm_stat_type, e.claim_id, d.policy_id, e.line_cd, e.subline_cd,
           e.iss_cd,
           (NVL (e.loss_res_amt, 0) + NVL (e.exp_res_amt, 0)) loss_res_amt,
           (NVL (e.loss_pd_amt, 0) + NVL (e.exp_pd_amt, 0)) loss_pd_amt,
           m.check_date, e.clm_file_date, d.tsi_amt,
           TO_CHAR (e.dsp_loss_date, 'MM') MONTH
      FROM giis_assured c,
           gicl_claims e,
           gipi_polbasic d,
           (SELECT DISTINCT claim_id
                       FROM gicl_clm_hist
                      WHERE dist_sw = 'Y') f,
           giis_clm_stat g,
           (SELECT a.claim_id, b.advise_id, e.check_date, a.line_cd, a.iss_cd
              FROM gicl_claims a,
                   gicl_advise_hdr b,
                   gicl_advise_dtl c,
                   giac_disb_vouchers d,
                   giac_chk_disbursement e
             WHERE a.claim_id = b.claim_id(+)
               AND b.advise_id = c.advise_id(+)
               AND c.gprd_ref_id = d.gprq_ref_id(+)
               AND c.gprd_req_dtl_no = d.req_dtl_no(+)
               AND e.gacc_tran_id = d.gacc_tran_id
               AND dv_flag = 'P') m
     WHERE c.assd_no = e.assd_no
       --AND e.policy_id = d.policy_id   --editted by MJ 01/04/2013 [POLICY_ID column does not exist in table GICL_CLAIMS]
       AND e.line_cd =
                      d.line_cd
                               --added by MJ 01/04/2013 [to replace POLICY_ID]
       AND e.subline_cd =
                   d.subline_cd
                               --added by MJ 01/04/2013 [to replace POLICY_ID]
       AND e.issue_yy =
                     d.issue_yy
                               --added by MJ 01/04/2013 [to replace POLICY_ID]
       AND e.pol_iss_cd =
                       d.iss_cd
                               --added by MJ 01/04/2013 [to replace POLICY_ID]
       AND e.pol_seq_no =
                   d.pol_seq_no
                               --added by MJ 01/04/2013 [to replace POLICY_ID]
       AND e.renew_no =
                     d.renew_no
                               --added by MJ 01/04/2013 [to replace POLICY_ID]
       AND e.claim_id = f.claim_id
       AND e.claim_id = m.claim_id(+)
       AND e.clm_stat_cd = g.clm_stat_cd
       AND e.line_cd = m.line_cd(+)
       AND e.iss_cd = m.iss_cd(+)
       AND g.clm_stat_type NOT IN ('W', 'X', 'D'))
   WITH READ ONLY;


