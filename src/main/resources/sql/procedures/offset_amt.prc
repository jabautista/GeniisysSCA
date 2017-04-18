DROP PROCEDURE CPI.OFFSET_AMT;

CREATE OR REPLACE PROCEDURE CPI.offset_amt (v_clm_dist_no  gicl_reserve_ds.clm_dist_no%TYPE,
                      v1_claim_id    gicl_clm_res_hist.claim_id%type,
                      v1_clm_res_hist_id  gicl_reserve_ds.clm_res_hist_id%TYPE) IS
  offset_loss  gicl_reserve_ds.shr_loss_res_amt%TYPE;
  offset_exp   gicl_reserve_ds.shr_loss_res_amt%TYPE;

BEGIN

-- extract amounts from gicl_reserve_rids
  FOR A IN
    (SELECT grp_seq_no, peril_cd, item_no, grouped_item_no,
            SUM(shr_loss_ri_res_amt) loss_amt, SUM(shr_exp_ri_res_amt) exp_amt
       FROM gicl_reserve_rids
      WHERE claim_id        = v1_claim_id
        AND clm_dist_no     = v_clm_dist_no
        AND clm_res_hist_id = v1_clm_res_hist_id
      GROUP BY grp_seq_no, item_no, peril_cd,grouped_item_no)
  LOOP
    offset_loss := 0;
    offset_exp  := 0;
-- extract amounts from gicl_reserve_ds to link with the values in A.
    FOR B IN
      (SELECT shr_loss_res_amt, shr_exp_res_amt
         FROM gicl_reserve_ds
        WHERE claim_id        = v1_claim_id
          AND clm_dist_no     = v_clm_dist_no
          AND grp_seq_no      = a.grp_seq_no
          AND clm_res_hist_id = v1_clm_res_hist_id
          AND item_no         = a.item_no  
          AND grouped_item_no = a.grouped_item_no
          AND peril_cd        = a.peril_cd)
    LOOP
/* subtract sum of amounts in A from B, if <> 0 IF statement executes.
   otherwise, null. */
      offset_loss := nvl(b.shr_loss_res_amt,0) - nvl(a.loss_amt,0);
      offset_exp  := nvl(b.shr_exp_res_amt,0) - nvl(a.exp_amt,0);
    END LOOP;

-- if <> 0 update gicl_reserve_rids using ri_cd.
    IF NVL(offset_loss,0) <> 0 OR NVL(offset_exp,0) <> 0 THEN
       FOR C IN
         (SELECT ri_cd
            FROM gicl_reserve_rids
           WHERE claim_id         = v1_claim_id
             AND clm_dist_no      = v_clm_dist_no
             AND grp_seq_no       = a.grp_seq_no
             AND clm_res_hist_id  = v1_clm_res_hist_id
             AND item_no          = a.item_no  
             AND grouped_item_no  = a.grouped_item_no
             AND peril_cd         = a.peril_cd) 
       LOOP
/* add offset_loss/offset_exp to 
   amounts in A then assign back to the same amounts 
   (shr_loss_ri_res_amount, shr_exp_ri_res_amt) */ 
         UPDATE gicl_reserve_rids
             SET shr_loss_ri_res_amt = nvl(shr_loss_ri_res_amt,0) + nvl(offset_loss,0),
                 shr_exp_ri_res_amt  = nvl(shr_exp_ri_res_amt,0) + nvl(offset_exp,0)
           WHERE claim_id        = v1_claim_id
             AND clm_dist_no     = v_clm_dist_no
             AND grp_seq_no      = a.grp_seq_no
             AND clm_res_hist_id = v1_clm_res_hist_id
             AND ri_cd           = c.ri_cd  
             AND item_no         = a.item_no  
             AND grouped_item_no = a.grouped_item_no
             AND peril_cd        = a.peril_cd;
         EXIT;
       END LOOP;
    END IF;
  END LOOP;

END;
/


