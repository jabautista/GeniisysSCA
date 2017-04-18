DROP VIEW CPI.GICL_MOTSHOP_LISTING_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gicl_motshop_listing_v (advice_id,
                                                         claim_id,
                                                         line_cd,
                                                         subline_cd,
                                                         iss_cd,
                                                         clm_yy,
                                                         clm_seq_no,
                                                         pol_iss_cd,
                                                         issue_yy,
                                                         pol_seq_no,
                                                         renew_no,
                                                         plate_no,
                                                         loss_reserve,
                                                         dsp_loss_date,
                                                         clm_file_date,
                                                         clm_stat_cd,
                                                         payee_cd,
                                                         issue_cd,
                                                         clm_yy2,
                                                         loa_seq_no,
                                                         paid_amt,
                                                         assured_name
                                                        )
AS
   SELECT DISTINCT d.advice_id, a.claim_id, a.line_cd, a.subline_cd, a.iss_cd,
                   a.clm_yy, a.clm_seq_no, a.pol_iss_cd, a.issue_yy,
                   a.pol_seq_no, a.renew_no, a.plate_no,
                   SUM (f.loss_reserve) loss_reserve, a.dsp_loss_date,
                   a.clm_file_date, a.clm_stat_cd, b.payee_cd, e.issue_cd,
                   e.clm_yy clm_yy2, e.loa_seq_no, d.paid_amt, a.assured_name
              FROM gicl_claims a,
                   gicl_loss_exp_payees b,
                   gicl_clm_loss_exp c,
                   gicl_advice d,
                   gicl_loa e,
                   gicl_clm_res_hist f
             WHERE a.claim_id = b.claim_id
               AND f.claim_id = a.claim_id
               AND b.claim_id = c.claim_id
               AND b.clm_clmnt_no = c.clm_clmnt_no
               AND b.peril_cd = c.peril_cd
               AND b.payee_cd = e.motshop_cd
               AND c.claim_id = d.claim_id
               AND c.advice_id = d.advice_id
               AND d.claim_id = e.claim_id
               AND d.advice_id = e.advice_id
               AND c.clm_clmnt_no = e.clm_clmnt_no
               AND c.payee_class_cd = e.payee_class_cd
               AND c.payee_cd = e.motshop_cd
               AND b.payee_class_cd = giacp.v ('MC_PAYEE_CLASS')
               AND d.advice_flag = 'Y'
               AND (e.cancel_sw = 'N' OR e.cancel_sw IS NULL)
               AND f.dist_sw = 'Y'
          GROUP BY d.advice_id,
                   a.claim_id,
                   a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.clm_yy,
                   a.clm_seq_no,
                   a.pol_iss_cd,
                   a.issue_yy,
                   a.pol_seq_no,
                   a.renew_no,
                   a.plate_no,
                   a.dsp_loss_date,
                   a.clm_file_date,
                   a.clm_stat_cd,
                   b.payee_cd,
                   e.issue_cd,
                   e.clm_yy,
                   e.loa_seq_no,
                   d.paid_amt,
                   c.peril_cd,
                   a.assured_name
   UNION
   SELECT DISTINCT c.advice_id, a.claim_id, a.line_cd, a.subline_cd, a.iss_cd,
                   a.clm_yy, a.clm_seq_no, a.pol_iss_cd, a.issue_yy,
                   a.pol_seq_no, a.renew_no, a.plate_no,
                   SUM (f.loss_reserve) loss_reserve, a.dsp_loss_date,
                   a.clm_file_date, a.clm_stat_cd, b.payee_cd,
                   e.iss_cd issue_cd, e.loa_yy clm_yy2, e.loa_seq_no,
                   c.paid_amt, a.assured_name
              FROM gicl_claims a,
                   gicl_loss_exp_payees b,
                   gicl_clm_loss_exp c,
                   gicl_eval_loa e,
                   gicl_clm_res_hist f
             WHERE a.claim_id = b.claim_id
               AND f.claim_id = a.claim_id
               AND b.claim_id = c.claim_id
               AND b.clm_clmnt_no = c.clm_clmnt_no
               AND b.peril_cd = c.peril_cd
               AND b.payee_cd = e.payee_cd
               AND c.claim_id = e.claim_id
               AND c.payee_class_cd = e.payee_type_cd
               AND c.payee_cd = e.payee_cd
               AND c.clm_loss_id = e.clm_loss_id
               AND b.payee_class_cd = giacp.v ('MC_PAYEE_CLASS')
               AND (e.cancel_sw = 'N' OR e.cancel_sw IS NULL)
               AND f.dist_sw = 'Y'
          GROUP BY c.advice_id,
                   a.claim_id,
                   a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.clm_yy,
                   a.clm_seq_no,
                   a.pol_iss_cd,
                   a.issue_yy,
                   a.pol_seq_no,
                   a.renew_no,
                   a.plate_no,
                   a.dsp_loss_date,
                   a.clm_file_date,
                   a.clm_stat_cd,
                   b.payee_cd,
                   e.iss_cd,
                   e.loa_yy,
                   e.loa_seq_no,
                   c.paid_amt,
                   c.peril_cd,
                   a.assured_name
   UNION
   -- Added by Marlo 12/02/2009
   SELECT DISTINCT d.advice_id, a.claim_id, a.line_cd, a.subline_cd, a.iss_cd,
                   a.clm_yy, a.clm_seq_no, a.pol_iss_cd, a.issue_yy,
                   a.pol_seq_no, a.renew_no, a.plate_no,
                   SUM (d.loss_reserve) loss_reserve, a.dsp_loss_date,
                   a.clm_file_date, a.clm_stat_cd, c.payee_cd,
                   e.iss_cd issue_cd, e.loa_yy clm_yy2, e.loa_seq_no,
                   c.base_amt, a.assured_name
              FROM gicl_claims a,
                   gicl_mc_evaluation b,
                   gicl_clm_res_hist d,
                   gicl_eval_loa e,
                   (SELECT   payee_cd, payee_type_cd, eval_id,
                             SUM (base_amt) base_amt
                        FROM (SELECT   NVL (a.payt_payee_cd,
                                            a.payee_cd
                                           ) payee_cd,
                                       NVL
                                          (a.payt_payee_type_cd,
                                           a.payee_type_cd
                                          ) payee_type_cd,
                                       a.eval_id, SUM (a.part_amt) base_amt
                                  FROM gicl_replace a,
                                       giis_payee_class b,
                                       gicl_eval_loa d
                                 WHERE NVL (a.payt_payee_type_cd,
                                            a.payee_type_cd
                                           ) = b.payee_class_cd
                                   AND a.eval_id = d.eval_id(+)
                                   AND NVL (a.payt_payee_type_cd,
                                            a.payee_type_cd
                                           ) = d.payee_type_cd(+)
                                   AND NVL (a.payt_payee_cd, a.payee_cd) = d.payee_cd(+)
                                   AND b.loa_sw = 'Y'
                                   AND NVL (d.cancel_sw, 'N') = 'N'
                              GROUP BY NVL (a.payt_payee_cd, a.payee_cd),
                                       NVL (a.payt_payee_type_cd,
                                            a.payee_type_cd
                                           ),
                                       a.eval_id
                              UNION ALL
                              SELECT a.payee_cd, a.payee_type_cd, a.eval_id,
                                     d.repair_amt base_amt
                                FROM gicl_repair_hdr a,
                                     giis_payee_class b,
                                     gicl_mc_evaluation d,
                                     gicl_eval_loa e
                               WHERE a.eval_id = d.eval_id
                                 AND a.payee_type_cd = b.payee_class_cd
                                 AND a.eval_id = e.eval_id(+)
                                 AND a.payee_type_cd = e.payee_type_cd(+)
                                 AND a.payee_cd = e.payee_cd(+)
                                 AND b.loa_sw = 'Y'
                                 AND NVL (e.cancel_sw, 'N') = 'N')
                    GROUP BY payee_cd, payee_type_cd, eval_id) c
             WHERE b.claim_id = a.claim_id
               AND a.claim_id = e.claim_id
               AND c.payee_cd = e.payee_cd
               AND c.payee_type_cd = e.payee_type_cd
               AND a.claim_id = d.claim_id
               AND e.eval_id = b.eval_id
               AND c.eval_id = b.eval_id
               AND d.dist_sw = 'Y'
               AND NVL (e.cancel_sw, 'N') = 'N'
          GROUP BY d.advice_id,
                   a.claim_id,
                   a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.clm_yy,
                   a.clm_seq_no,
                   a.pol_iss_cd,
                   a.issue_yy,
                   a.pol_seq_no,
                   a.renew_no,
                   a.plate_no,
                   a.dsp_loss_date,
                   a.clm_file_date,
                   a.clm_stat_cd,
                   c.payee_cd,
                   e.iss_cd,
                   e.loa_yy,
                   e.loa_seq_no,
                   c.base_amt,
                   a.assured_name
                   WITH READ ONLY;


