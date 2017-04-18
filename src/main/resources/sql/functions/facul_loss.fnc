CREATE OR REPLACE FUNCTION CPI.FACUL_LOSS(p_claim_id NUMBER, p_close_sw VARCHAR2)
RETURN NUMBER IS
  v_amt    NUMBER := 0;
BEGIN
    IF p_close_sw = 'N' THEN
       FOR rec IN (SELECT SUM(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0)) amt
                   FROM GICL_CLM_RES_HIST a,
                        GICL_RESERVE_DS b
                  WHERE a.claim_id = p_claim_id
                    AND a.claim_id         = b.claim_id
                    AND a.clm_res_hist_id  = b.clm_res_hist_id
                    AND NVL(a.dist_sw,'N') = 'Y'
                    AND b.share_type = 3)
     LOOP
          v_amt := v_amt + NVL(rec.amt,0);
          EXIT;
     END LOOP;
     
     --added by gab 06.22.2016 SR 21538
     FOR i IN(SELECT SUM (NVL (c.shr_recovery_amt, 0)) recovered_amt
                       FROM gicl_claims a,
                            gicl_recovery_payt b,
                            gicl_recovery_ds c
                      WHERE a.claim_id = p_claim_id
                        AND NVL (b.cancel_tag, 'N') = 'N'
                        AND TO_NUMBER (TO_CHAR (a.loss_date, 'YYYY')) =
                                     TO_NUMBER (TO_CHAR (b.tran_date, 'YYYY'))
                        AND b.claim_id = a.claim_id
                        AND b.recovery_id = c.recovery_id
                        AND b.recovery_payt_id = c.recovery_payt_id
                        AND NVL (c.negate_tag, 'N') = 'N'
                        AND c.share_type = 3)
     LOOP
            v_amt := v_amt - NVL(i.recovered_amt,0);
            EXIT;
     END LOOP;
     
  ELSIF p_close_sw = 'Y' THEN
     FOR rec IN (SELECT SUM(NVL(c.shr_le_net_amt,0)) amt
                   FROM GICL_CLM_RES_HIST a,
                        GICL_CLM_LOSS_EXP b,
                        GICL_LOSS_EXP_DS c
                  WHERE a.claim_id             = p_claim_id
                    AND NVL(a.cancel_tag,'N')  = 'N'
                    AND a.tran_id              IS NOT NULL
                    AND b.claim_id             = a.claim_id
                    AND b.tran_id              = a.tran_id
                    AND b.item_no              = a.item_no
                    AND b.peril_cd             = a.peril_cd
                    AND c.claim_id             = b.claim_id
                    AND c.clm_loss_id          = b.clm_loss_id
               /*a*/
                    AND a.clm_loss_id          = b.clm_loss_id
               /*alvin 03-01-2012
                added to fix errors on computation of loss amount,
                as requested in SR8844 from client CIC*/ 
                    AND NVL(c.negate_tag, 'N') = 'N'
                    AND c.share_type = 3)
     LOOP
       v_amt := v_amt + NVL(rec.amt,0);
       EXIT;
     END LOOP;
     
     --added by gab 06.22.2016 SR 21538
     FOR i IN(SELECT SUM (NVL (c.shr_recovery_amt, 0)) recovered_amt
                       FROM gicl_claims a,
                            gicl_recovery_payt b,
                            gicl_recovery_ds c
                      WHERE a.claim_id = p_claim_id
                        AND NVL (b.cancel_tag, 'N') = 'N'
                        AND TO_NUMBER (TO_CHAR (a.loss_date, 'YYYY')) =
                                     TO_NUMBER (TO_CHAR (b.tran_date, 'YYYY'))
                        AND b.claim_id = a.claim_id
                        AND b.recovery_id = c.recovery_id
                        AND b.recovery_payt_id = c.recovery_payt_id
                        AND NVL (c.negate_tag, 'N') = 'N'
                        AND c.share_type = 3)
     LOOP
            v_amt := v_amt - NVL(i.recovered_amt,0);
            EXIT;
     END LOOP;
     
  END IF;
  RETURN (NVL(v_amt,0));
end;
/


