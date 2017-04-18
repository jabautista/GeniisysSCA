DROP VIEW CPI.GICL_RESERVE_RIDS_V1;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gicl_reserve_rids_v1 (claim_id,
                                                       item_no,
                                                       peril_cd,
                                                       grp_seq_no,
                                                       ri_cd,
                                                       shr_ri_pct,
                                                       ri_res_amt
                                                      )
AS
   SELECT   a.claim_id, a.item_no, a.peril_cd, a.grp_seq_no, a.ri_cd,
            a.shr_ri_pct,
            SUM (NVL (a.shr_loss_ri_res_amt, 0)
                 + NVL (a.shr_exp_ri_res_amt, 0)
                ) ri_res_amt
       FROM gicl_reserve_rids a, gicl_reserve_ds b, gicl_item_peril c
      WHERE a.grp_seq_no = b.grp_seq_no
        AND a.clm_dist_no = b.clm_dist_no
        AND a.clm_res_hist_id = b.clm_res_hist_id
        AND a.claim_id = b.claim_id
        AND b.peril_cd = c.peril_cd
        AND b.item_no = c.item_no
        AND b.claim_id = c.claim_id
        AND NVL (b.negate_tag, 'N') <> 'Y'
   GROUP BY a.claim_id,
            a.item_no,
            a.peril_cd,
            a.grp_seq_no,
            a.ri_cd,
            a.shr_ri_pct
            WITH READ ONLY;


