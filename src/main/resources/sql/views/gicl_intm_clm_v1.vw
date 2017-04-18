DROP VIEW CPI.GICL_INTM_CLM_V1;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gicl_intm_clm_v1 (line_cd,
                                                   claim_id,
                                                   intm_no,
                                                   claim_no,
                                                   policy_no,
                                                   assd_no,
                                                   incept_date,
                                                   expiry_date,
                                                   loss_date,
                                                   trty_yy,
                                                   tsi_amt,
                                                   prem_amt,
                                                   loss_amt,
                                                   outstanding_loss,
                                                   claim_tag
                                                  )
AS
   SELECT DISTINCT b.line_cd, a.claim_id,
                   DECODE (c.parent_intm_no,
                           NULL, c.intrmdry_intm_no,
                           c.parent_intm_no
                          ) intm_no,
                   DECODE (a.line_cd,
                           NULL, NULL,
                           (   a.line_cd
                            || '-'
                            || a.subline_cd
                            || '-'
                            || a.iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (a.clm_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (a.clm_seq_no, '0000009'))
                           )
                          ) claim_no,
                   (   b.line_cd
                    || '-'
                    || b.subline_cd
                    || '-'
                    || b.iss_cd
                    || '-'
                    || LTRIM (TO_CHAR (b.issue_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                   ) policy_no,
                   b.assd_no, b.incept_date, b.expiry_date, a.loss_date,
                   TO_NUMBER (TO_CHAR (a.loss_date, 'YY')) trty_yy,
                   (d.ann_tsi_amt * c.share_percentage / 100) tsi_amt,
                   (d.ann_prem_amt * c.share_percentage / 100) prem_amt,
                   (  (NVL (loss_pd_amt, 0) + NVL (a.exp_pd_amt, 0))
                    * c.share_percentage
                    / 100
                   ) loss_amt,
                   (  (NVL (loss_res_amt, 0) + NVL (a.exp_res_amt, 0))
                    * c.share_percentage
                    / 100
                   ) outstanding_loss,
                   DECODE (a.line_cd, NULL, 'N', 'Y') claim_tag
              FROM gipi_comm_invoice c,
                   gipi_polbasic b,
                   gipi_polbasic d,
                   gicl_claims a
             WHERE c.policy_id = b.policy_id
               AND d.pol_seq_no = b.pol_seq_no
               AND d.issue_yy = b.issue_yy
               AND d.iss_cd = b.iss_cd
               AND d.subline_cd = b.subline_cd
               AND d.line_cd = b.line_cd
               AND d.eff_date =
                      (SELECT MAX (eff_date)
                         FROM gipi_polbasic e
                        WHERE e.pol_seq_no = d.pol_seq_no
                          AND e.issue_yy = d.issue_yy
                          AND e.iss_cd = d.iss_cd
                          AND e.subline_cd = d.subline_cd
                          AND e.line_cd = d.line_cd)
               AND c.share_percentage =
                      (SELECT MAX (f.share_percentage)
                         FROM gipi_comm_invoice f
                        WHERE f.policy_id = c.policy_id
                          AND f.intrmdry_intm_no = c.intrmdry_intm_no)
               AND b.pol_seq_no = a.pol_seq_no(+)
               AND b.issue_yy = a.issue_yy(+)
               AND b.iss_cd = a.iss_cd(+)
               AND b.subline_cd = a.subline_cd(+)
               AND b.line_cd = a.line_cd(+)
               AND b.endt_seq_no = 0
                   WITH READ ONLY;


