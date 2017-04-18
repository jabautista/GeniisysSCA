DROP VIEW CPI.GICL_FOR_PLA_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gicl_for_pla_v (claim_id,
                                                 clm_dist_no,
                                                 prnt_ri_cd,
                                                 ri_cd,
                                                 clm_res_hist_id,
                                                 grp_seq_no,
                                                 share_type,
                                                 loss,
                                                 EXP
                                                )
AS
   (SELECT DISTINCT m.claim_id, m.clm_dist_no,
                    NVL (m.prnt_ri_cd, m.ri_cd) prnt_ri_cd, m.ri_cd,
                    m.clm_res_hist_id, m.grp_seq_no, m.share_type,
                    shr_loss_ri_res_amt loss, shr_exp_ri_res_amt EXP
               FROM gicl_reserve_rids m, gicl_reserve_ds e
              WHERE m.claim_id = e.claim_id
                AND m.clm_res_hist_id = e.clm_res_hist_id
                AND m.clm_dist_no = e.clm_dist_no
                AND (e.negate_tag = 'N' OR e.negate_tag IS NULL))
   WITH READ ONLY;


