DROP PROCEDURE CPI.GICLS030_OFFSET_AMT;

CREATE OR REPLACE PROCEDURE CPI.gicls030_offset_amt (v_clm_dist_no      GICL_LOSS_EXP_DS.clm_dist_no%TYPE,
                                                 v1_claim_id        GICL_CLM_RES_HIST.claim_id%type,
                                                 v1_clm_loss_id     GICL_CLM_LOSS_EXP.clm_loss_id%type) 
IS

   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 02.27.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : This procedure offsets amounts in (gicl_loss_exp_rids) and equates it 
   **                  with the amount in table (gicl_loss_exp_ds); (shr_le_ri_pd_amt with 
   **                  shr_le_pd_amt), (shr_le_ri_adv_amt with shr_le_adv_amt) and
   **                  shr_le_ri_net_amt with shr_le_net_amt) respectively. 
   */ 
   
  offset_pd    GICL_LOSS_EXP_DS.shr_le_pd_amt%TYPE;
  offset_adv   GICL_LOSS_EXP_DS.shr_le_pd_amt%TYPE;
  offset_net   GICL_LOSS_EXP_DS.shr_le_pd_amt%TYPE;
  offset_pd1   GICL_LOSS_EXP_DS.shr_le_pd_amt%TYPE;
  offset_adv1  GICL_LOSS_EXP_DS.shr_le_pd_amt%TYPE;
  offset_net1  GICL_LOSS_EXP_DS.shr_le_pd_amt%TYPE;

BEGIN
-- OFFSET FROM BASE AMOUNT
  FOR OFFSET IN (
     SELECT  paid_amt, net_amt, advise_amt
       FROM GICL_CLM_LOSS_EXP
      WHERE claim_id        = v1_claim_id
        AND clm_loss_id     = v1_clm_loss_id)
  LOOP      
    FOR offset2 IN (
      SELECT SUM(shr_le_pd_amt)sum_pd, SUM(shr_le_adv_amt) sum_adv,
             SUM(shr_le_net_amt)sum_net
        FROM GICL_LOSS_EXP_DS
       WHERE claim_id = v1_claim_id
         AND clm_dist_no = v_clm_dist_no
         AND clm_loss_id = v1_clm_loss_id)
    LOOP
      offset_pd1:= NVL(offset.paid_amt,0) - NVL(offset2.sum_pd,0);
      offset_adv1:= NVL(offset.advise_amt,0) - NVL(offset2.sum_adv,0);
      offset_net1:= NVL(offset.net_amt,0) - NVL(offset2.sum_net,0);
    END LOOP;
  END LOOP;
  
  IF NVL(offset_pd1,0) <> 0 OR NVL(offset_adv1,0) <> 0 OR NVL(offset_net1,0) <> 0 THEN
       FOR get_cd IN (
         SELECT grp_seq_no
           FROM GICL_LOSS_EXP_DS
          WHERE claim_id = v1_claim_id
         AND clm_dist_no = v_clm_dist_no
         AND clm_loss_id = v1_clm_loss_id 
       ORDER BY grp_seq_no)
     LOOP
         UPDATE GICL_LOSS_EXP_DS
            SET shr_le_pd_amt = shr_le_pd_amt + offset_pd1,
                shr_le_adv_amt = shr_le_adv_amt + offset_adv1,
                shr_le_net_amt = shr_le_net_amt + offset_net1
          WHERE claim_id = v1_claim_id
            AND clm_dist_no = v_clm_dist_no
            AND grp_seq_no  = get_cd.grp_seq_no
            AND clm_loss_id = v1_clm_loss_id;   
      EXIT;
     END LOOP;
  END IF;   
  
  -- extract amounts from gicl_loss_exp_rids
  FOR A IN
    (SELECT grp_seq_no, peril_cd, item_no,
            grouped_item_no,
            SUM(shr_le_ri_pd_amt) pd_amt,
            SUM(shr_le_ri_adv_amt) adv_amt,
            SUM(shr_le_ri_net_amt) net_amt
       FROM GICL_LOSS_EXP_RIDS
      WHERE claim_id    = v1_claim_id
        AND clm_dist_no = v_clm_dist_no
        AND clm_loss_id = v1_clm_loss_id   
      GROUP BY grp_seq_no, item_no, peril_cd, grouped_item_no)
  LOOP
    offset_pd  := 0;
    offset_adv := 0;
    offset_net := 0;
    -- extract amounts from gicl_loss_exp_ds to link with the values in A.
    FOR B IN
      (SELECT shr_le_pd_amt, shr_le_adv_amt, shr_le_net_amt
         FROM GICL_LOSS_EXP_DS
        WHERE claim_id    = v1_claim_id
          AND clm_dist_no = v_clm_dist_no
          AND clm_loss_id = v1_clm_loss_id   
          AND grp_seq_no  = a.grp_seq_no
          AND item_no     = a.item_no 
          AND grouped_item_no = a.grouped_item_no 
          AND peril_cd    = a.peril_cd)
    LOOP
    /* subtract sum of amounts in A from B, if <> 0 IF statement executes.
       otherwise, null. */
      offset_pd  := NVL(b.shr_le_pd_amt,0) - NVL(a.pd_amt,0);
      offset_adv := NVL(b.shr_le_adv_amt,0) - NVL(a.adv_amt,0);
      offset_net := NVL(b.shr_le_net_amt,0) - NVL(a.net_amt,0);
    END LOOP;

    -- if <> 0 update gicl_loss_exp_rids using ri_cd.
    IF offset_pd <> 0 OR
         offset_adv <> 0 OR
         offset_net <> 0 THEN
         --msg_alert('not ZERO', 'I', false);
       FOR C IN
         (SELECT ri_cd
            FROM GICL_LOSS_EXP_RIDS
           WHERE claim_id    = v1_claim_id
             AND clm_dist_no = v_clm_dist_no
             AND clm_loss_id = v1_clm_loss_id   
             AND grp_seq_no  = a.grp_seq_no
             AND item_no     = a.item_no  
             and grouped_item_no = a.grouped_item_no
             AND peril_cd    = a.peril_cd) 
       LOOP
         /* add offset_pd/offset_adv/offset_net to 
            amounts in A then assign back to the same amounts 
            (shr_le_ri_pd_amount, shr_le_ri_adv_amt and shr_le_ri_net_amt) */ 
         UPDATE GICL_LOSS_EXP_RIDS
            SET shr_le_ri_pd_amt  = NVL(shr_le_ri_pd_amt,0) + NVL(offset_pd,0),
                shr_le_ri_adv_amt = NVL(shr_le_ri_adv_amt,0) + NVL(offset_adv,0),
                shr_le_ri_net_amt = NVL(shr_le_ri_net_amt,0) + NVL(offset_net,0)
          WHERE claim_id    = v1_claim_id
            AND clm_dist_no = v_clm_dist_no
            AND clm_loss_id = v1_clm_loss_id   
            AND grp_seq_no  = a.grp_seq_no
            AND ri_cd       = c.ri_cd  
            AND item_no     = a.item_no  
            AND grouped_item_no = a.grouped_item_no
            AND peril_cd    = a.peril_cd;
         EXIT;
       END LOOP;
    END IF;
    END LOOP;

END;
/


