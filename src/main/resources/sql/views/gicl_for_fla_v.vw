DROP VIEW CPI.GICL_FOR_FLA_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gicl_for_fla_v (claim_id,
                                                 advice_id,
                                                 share_type,
                                                 grp_seq_no,
                                                 prnt_ri_cd,
                                                 ri_cd,
                                                 pd_amt,
                                                 net_amt,
                                                 adv_amt
                                                )
AS
   (SELECT DISTINCT a.claim_id, a.advice_id, c.share_type, c.grp_seq_no,
                    NVL (c.prnt_ri_cd, c.ri_cd) prnt_ri_cd, c.ri_cd,
                    c.shr_le_ri_pd_amt pd_amt, c.shr_le_ri_net_amt net_amt,
                    c.shr_le_ri_adv_amt adv_amt
               FROM gicl_clm_loss_exp a,
                    gicl_loss_exp_ds b,
                    gicl_loss_exp_rids c
              WHERE a.claim_id = b.claim_id
                AND a.clm_loss_id = b.clm_loss_id
                AND b.claim_id = c.claim_id
                AND b.clm_loss_id = c.clm_loss_id
                AND b.clm_dist_no = c.clm_dist_no
                AND (a.cancel_sw = 'N' OR a.cancel_sw IS NULL)
                AND (b.negate_tag = 'N' OR b.negate_tag IS NULL)
                AND a.dist_sw = 'Y'
                AND c.share_type <> 1)
   WITH READ ONLY;


