DROP TRIGGER CPI.GIAC_DISB_VOUCHERS_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GIAC_DISB_VOUCHERS_TAIUD
AFTER UPDATE OF dv_flag ON CPI.GIAC_DISB_VOUCHERS FOR EACH ROW
WHEN (
NEW.dv_flag = 'C'
      )
DECLARE
/* modified by judyann 12182002
** trigger should only affect posted DV transactions
*/
/* modified by judyann 03072003
** updates on claims tables should be based on the payment's transaction type
*/
  v_flag                GIAC_ACCTRANS.tran_flag%TYPE;
  v_hist                GICL_CLM_RES_HIST.hist_seq_no%TYPE;
  v_res_hist_id         GICL_CLM_RES_HIST.clm_res_hist_id%TYPE;
  v_clm_hist            GICL_CLM_LOSS_EXP.hist_seq_no%TYPE;
  v_clm_loss_id         GICL_CLM_LOSS_EXP.clm_loss_id%TYPE;
BEGIN
  FOR f IN (SELECT tran_flag
              FROM GIAC_ACCTRANS
             WHERE tran_id = :NEW.gacc_tran_id)
  LOOP
    v_flag := f.tran_flag;
    FOR i IN (SELECT b.claim_id, b.advice_id, b.clm_loss_id,
                     b.item_no, b.peril_cd,
                     a.payee_type, a.payee_class_cd, a.payee_cd,
                     a.currency_cd, a.convert_rate, a.disbursement_amt,
                     a.gacc_tran_id, a.transaction_type, a.net_disb_amt  -- added by judyann 08202003
                FROM GIAC_DIRECT_CLAIM_PAYTS a,
                     GICL_CLM_LOSS_EXP b
               WHERE a.advice_id = b.advice_id
                 AND a.claim_id = b.claim_id
                 AND a.clm_loss_id = b.clm_loss_id
                 AND a.gacc_tran_id = :NEW.gacc_tran_id
              UNION
              SELECT b.claim_id, b.advice_id, b.clm_loss_id,
                     b.item_no, b.peril_cd,
                     a.payee_type, a.payee_class_cd, a.payee_cd,
                     a.currency_cd, a.convert_rate, a.disbursement_amt,
                     a.gacc_tran_id, a.transaction_type, a.net_disb_amt
                FROM GIAC_INW_CLAIM_PAYTS a,
                     GICL_CLM_LOSS_EXP b
               WHERE a.advice_id = b.advice_id
                 AND a.claim_id = b.claim_id
                 AND a.clm_loss_id = b.clm_loss_id
                 AND a.gacc_tran_id = :NEW.gacc_tran_id)
    LOOP
      IF v_flag = 'P' THEN
         IF i.transaction_type = 1 THEN
            UPDATE GICL_CLM_RES_HIST
               SET cancel_tag = 'Y',
                   cancel_date = SYSDATE
             WHERE claim_id = i.claim_id
               AND item_no = i.item_no
               AND peril_cd = i.peril_cd
               AND tran_id = :NEW.gacc_tran_id;
            UPDATE GICL_CLM_LOSS_EXP
               SET tran_id = NULL,
                   tran_date = NULL
             WHERE claim_id = i.claim_id
               AND clm_loss_id = i.clm_loss_id
               AND advice_id = i.advice_id;
            UPDATE GICL_ADVICE
               SET apprvd_tag = 'N'
             WHERE claim_id = i.claim_id
               AND advice_id = i.advice_id;
            IF i.payee_type = 'L' THEN
               UPDATE GICL_CLM_RESERVE
                  SET losses_paid = NVL(losses_paid,0) - i.disbursement_amt,
                      net_pd_loss = NVL(net_pd_loss,0) - i.net_disb_amt
                WHERE claim_id = i.claim_id
                  AND item_no = i.item_no
                  AND peril_cd = i.peril_cd;
               UPDATE GICL_CLAIMS
                  SET loss_pd_amt = NVL(loss_pd_amt,0) - i.disbursement_amt,
                      net_pd_loss = NVL(net_pd_loss,0) - i.net_disb_amt
                WHERE claim_id = i.claim_id;
            ELSIF i.payee_type = 'E' THEN
               UPDATE GICL_CLM_RESERVE
                  SET expenses_paid = NVL(expenses_paid,0) - i.disbursement_amt,
                      net_pd_exp = NVL(net_pd_exp,0) - i.net_disb_amt
                WHERE claim_id = i.claim_id
                  AND item_no = i.item_no
                  AND peril_cd = i.peril_cd;
               UPDATE GICL_CLAIMS
                  SET exp_pd_amt = NVL(exp_pd_amt,0) - i.disbursement_amt,
                      net_pd_exp = NVL(net_pd_exp,0) - i.net_disb_amt
                WHERE claim_id = i.claim_id;
            END IF;
         ELSIF i.transaction_type = 2 THEN
            FOR r IN (SELECT u.tran_id, u.date_paid
                        FROM GIAC_DIRECT_CLAIM_PAYTS s, GICL_CLM_LOSS_EXP t,
                             GICL_CLM_RES_HIST u
                       WHERE s.claim_id = t.claim_id
                         AND s.advice_id = t.advice_id
                         AND s.clm_loss_id = t.clm_loss_id
                         AND t.claim_id = u.claim_id
                         AND t.item_no = u.item_no
                         AND t.peril_cd = u.peril_cd
                         AND s.transaction_type = 1
                         AND s.claim_id = i.claim_id
                         AND s.advice_id = i.advice_id
                         AND t.item_no = i.item_no
                         AND t.peril_cd = i.peril_cd
                         AND u.tran_id IS NOT NULL
                         AND s.gacc_tran_id = u.tran_id
                         AND NVL(u.cancel_tag,'N') = 'N'
                         AND NVL(u.losses_paid,0) >= 0
                         AND NVL(u.expenses_paid,0) >= 0)
            LOOP
              UPDATE GICL_CLM_LOSS_EXP
                 SET tran_id = r.tran_id,
                     tran_date = r.date_paid
               WHERE claim_id = i.claim_id
                 AND clm_loss_id = i.clm_loss_id
                 AND advice_id = i.advice_id;
            END LOOP;
            UPDATE GICL_CLM_RES_HIST
               SET cancel_tag = 'Y',
                   cancel_date = SYSDATE
             WHERE claim_id = i.claim_id
               AND item_no = i.item_no
               AND peril_cd = i.peril_cd
               AND tran_id = :NEW.gacc_tran_id;
            UPDATE GICL_ADVICE
               SET apprvd_tag = 'Y'
             WHERE claim_id = i.claim_id
               AND advice_id = i.advice_id;
            IF i.payee_type = 'L' THEN
               UPDATE GICL_CLM_RESERVE
                  SET losses_paid = NVL(losses_paid,0) - i.disbursement_amt,
                      net_pd_loss = NVL(net_pd_loss,0) - i.net_disb_amt
                WHERE claim_id = i.claim_id
                  AND item_no = i.item_no
                  AND peril_cd = i.peril_cd;
               UPDATE GICL_CLAIMS
                  SET loss_pd_amt = NVL(loss_pd_amt,0) - i.disbursement_amt,
                      net_pd_loss = NVL(net_pd_loss,0) - i.net_disb_amt
                WHERE claim_id = i.claim_id;
            ELSIF i.payee_type = 'E' THEN
               UPDATE GICL_CLM_RESERVE
                  SET expenses_paid = NVL(expenses_paid,0) - i.disbursement_amt,
                      net_pd_exp = NVL(net_pd_exp,0) - i.net_disb_amt
                WHERE claim_id = i.claim_id
                  AND item_no = i.item_no
                  AND peril_cd = i.peril_cd;
               UPDATE GICL_CLAIMS
                  SET exp_pd_amt = NVL(exp_pd_amt,0) - i.disbursement_amt,
                      net_pd_exp = NVL(net_pd_exp,0) - i.net_disb_amt
                WHERE claim_id = i.claim_id;
            END IF;
         END IF;
      END IF;
    END LOOP;
/* UPDATE CLAIM RECOVERY TABLES. MODIFIED BY PIA, 11.25.02*/
    FOR p IN (SELECT claim_id, recovery_id, payor_class_cd,
                     payor_cd, collection_amt
                FROM GIAC_LOSS_RECOVERIES
               WHERE gacc_tran_id = :NEW.gacc_tran_id)
    LOOP
      IF v_flag = 'P'  THEN
         UPDATE GICL_RECOVERY_PAYT
            SET cancel_tag = 'Y',
                cancel_date = SYSDATE
          WHERE recovery_id = p.recovery_id
            AND claim_id = p.claim_id
            AND payor_class_cd = p.payor_class_cd
            AND payor_cd = p.payor_cd
		    AND acct_tran_id = :NEW.gacc_tran_id;
         UPDATE GICL_CLM_RECOVERY
            SET recovered_amt = NVL(recovered_amt,0) - p.collection_amt
          WHERE recovery_id = p.recovery_id
            AND claim_id = p.claim_id;
         UPDATE GICL_RECOVERY_PAYOR
            SET recovered_amt = NVL(recovered_amt,0) - p.collection_amt
          WHERE claim_id = p.claim_id
            AND recovery_id = p.recovery_id
            AND payor_class_cd = p.payor_class_cd
            AND payor_cd = p.payor_cd;
      END IF;
    END LOOP;
  END LOOP;
END;
/


