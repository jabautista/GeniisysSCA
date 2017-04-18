DROP VIEW CPI.GICL_CLAIMS_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gicl_claims_v (adjuster_no,
                                                claim_id,
                                                line_cd,
                                                subline_cd,
                                                iss_cd,
                                                clm_yy,
                                                clm_seq_no,
                                                clm_setl_date,
                                                clm_stat_cd,
                                                loss_date,
                                                assign_date,
                                                mail_date,
                                                loss_pd_amt,
                                                loss_res_amt
                                               )
AS
   SELECT DISTINCT a.adjuster_no, b.claim_id, b.line_cd, b.subline_cd,
                   b.iss_cd, b.clm_yy, b.clm_seq_no,
--b.policy_id,     --editted by MJ 01/04/2013 [POLICY_ID column does not exist in table GICL_CLAIMS]
                                                    b.clm_setl_date,
                   b.clm_stat_cd, b.loss_date, a.assign_date, a.mail_date,
                   b.loss_pd_amt, b.loss_res_amt
              FROM gicl_clm_adj a, gicl_claims b
             WHERE a.claim_id = b.claim_id;


