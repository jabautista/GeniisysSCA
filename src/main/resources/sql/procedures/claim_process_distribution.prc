DROP PROCEDURE CPI.CLAIM_PROCESS_DISTRIBUTION;

CREATE OR REPLACE PROCEDURE CPI.claim_process_distribution (
   p_clm_res_hist   gicl_clm_res_hist.clm_res_hist_id%TYPE,
   p_hist_seq_no    gicl_clm_res_hist.hist_seq_no%TYPE,
   p_claim_id       gicl_item_peril.claim_id%TYPE
)
IS
   v_prtf_sw           NUMBER                                 := 0;
                    --indicate if distribution is portfolio or natural expiry
   v_loss_amt          gicl_claims.loss_res_amt%TYPE;
                --temp. storage of loss_reserve amount for gicl_claims update
   v_exp_amt           gicl_claims.exp_res_amt%TYPE;
                 --temp. storage of exp_reserve amount for gicl_claims update
   v_claim_id          gicl_item_peril.claim_id%TYPE;
   v_grouped_item_no   gicl_item_peril.grouped_item_no%TYPE;
   v_item_no           gicl_item_peril.item_no%TYPE;
   v_peril_cd          gicl_item_peril.peril_cd%TYPE;
BEGIN
   FOR itm IN (SELECT claim_id, grouped_item_no, item_no, peril_cd
                 --INTO v_claim_id,v_grouped_item_no,v_item_no,v_peril_cd
               FROM   gicl_item_peril
                WHERE claim_id = p_claim_id)
   LOOP
      v_claim_id := itm.claim_id;
      v_grouped_item_no := itm.grouped_item_no;
      v_item_no := itm.item_no;
      v_peril_cd := itm.peril_cd;
      EXIT;
   END LOOP;

   --update negate_tag on table gicl_reserve_ds to 'Y' to indicate
   --that it is already negated
   UPDATE gicl_reserve_ds
      SET negate_tag = 'Y'
    WHERE claim_id = v_claim_id
      AND hist_seq_no < p_hist_seq_no
      AND grouped_item_no = v_grouped_item_no
      AND item_no = v_item_no
      AND peril_cd = v_peril_cd;

   --check if distribution is natural expiry or portfolio transfer
   --v_prtf_sw := check_transfer(:c022.peril_cd, :c022.item_no);
   --call the corresponding procedure of creating records for reserve distribution
   ----distribute_reserve(v_claim_id, p_clm_res_hist);
   FOR sum_res IN (SELECT SUM (loss_reserve) loss_reserve,
                          SUM (expense_reserve) exp_reserve
                     FROM gicl_clm_reserve a,
                          gicl_item_peril b,
                          gicl_item_peril c
                    WHERE a.claim_id = b.claim_id
                      AND a.grouped_item_no = b.grouped_item_no
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND a.claim_id = c.claim_id
                      AND c.claim_id = p_claim_id
                      AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP'))
   LOOP
      v_loss_amt := sum_res.loss_reserve;
      v_exp_amt := sum_res.exp_reserve;
      EXIT;
   END LOOP;

   --end sum_res loop

   --update table  gicl_claims for correct reserve amounts
   UPDATE gicl_claims
      SET loss_res_amt = NVL (v_loss_amt, 0),
          exp_res_amt = NVL (v_exp_amt, 0)
    WHERE claim_id = v_claim_id;
END;
/


