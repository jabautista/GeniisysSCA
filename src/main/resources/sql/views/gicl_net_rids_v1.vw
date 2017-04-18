DROP VIEW CPI.GICL_NET_RIDS_V1;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gicl_net_rids_v1 (claim_id,
                                                   item_no,
                                                   peril_cd,
                                                   grp_seq_no,
                                                   ri_cd,
                                                   shr_ri_pct,
                                                   ri_net_amt
                                                  )
AS
   SELECT   a.claim_id, a.item_no, a.peril_cd, a.grp_seq_no, a.ri_cd,
            (a.shr_loss_exp_ri_pct / b.shr_loss_exp_pct * 100) shr_ri_pct,
            SUM (NVL (a.shr_le_ri_net_amt, 0)) ri_net_amt
       FROM gicl_loss_exp_rids a, gicl_loss_exp_ds b, gicl_item_peril c
      WHERE a.grp_seq_no = b.grp_seq_no
        AND a.clm_dist_no = b.clm_dist_no
        AND a.clm_loss_id = b.clm_loss_id
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
            (a.shr_loss_exp_ri_pct / b.shr_loss_exp_pct * 100)
            WITH READ ONLY;


