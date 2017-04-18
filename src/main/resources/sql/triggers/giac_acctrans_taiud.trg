DROP TRIGGER CPI.GIAC_ACCTRANS_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GIAC_ACCTRANS_TAIUD
AFTER UPDATE OF tran_flag ON CPI.GIAC_ACCTRANS FOR EACH ROW
WHEN (
NEW.tran_flag = 'C' OR NEW.tran_flag = 'D' OR NEW.tran_flag = 'O'
      )
DECLARE
/* modified by judyann 02282003
** updates on claims tables should be based on the payment's transaction type
*/
/* modified by judyann 06242003
** added advice_id and clm_loss_id in insert into table gicl_clm_res_hist
*/
/* modified by beth 11092004
** include cancellation of batch dv
** 02012005
** include insert of dist_no in table gicl_clm_res_hist
*/
/* modified by judyann 09292005
** apprvd_tag in gicl_advice should not be updated to 'N' when tran_flag is changed from 'C' to 'O'
*/

/* modified by beth 08072006
** gicl_clm_res_hist amounts should be expressed in currency of advice
*/

  v_item_no          GICL_CLM_LOSS_EXP.item_no%TYPE;
  v_grouped_item_no  GICL_CLM_LOSS_EXP.grouped_item_no%TYPE;
  v_peril_cd         GICL_CLM_LOSS_EXP.peril_cd%TYPE;
  v_res_hist         GICL_CLM_RES_HIST.clm_res_hist_id%TYPE;
  v_hist_seq         GICL_CLM_RES_HIST.hist_seq_no%TYPE;
  v_batch_sw           VARCHAR2(1);
  v_dist_no          GICL_CLM_RES_HIST.dist_no%TYPE;
BEGIN
  FOR a IN (SELECT claim_id, advice_id, clm_loss_id,
                   payee_type, payee_class_cd, payee_cd,
                   NVL(orig_curr_cd,currency_cd) currency_cd, NVL(orig_curr_rate,convert_rate) convert_rate, disbursement_amt/NVL(orig_curr_rate,convert_rate) disbursement_amt, --beth 08072006
                           transaction_type,
                           net_disb_amt /NVL(orig_curr_rate,convert_rate) net_disb_amt --beth 08072006
              FROM GIAC_DIRECT_CLAIM_PAYTS
             WHERE gacc_tran_id = :NEW.tran_id
             UNION
              SELECT claim_id, advice_id, clm_loss_id,
                   payee_type, payee_class_cd, payee_cd,
                   NVL(orig_curr_cd,currency_cd) currency_cd, NVL(orig_curr_rate,convert_rate) convert_rate, disbursement_amt/NVL(orig_curr_rate,convert_rate) disbursement_amt, --beth 08072006
                           transaction_type,
                           net_disb_amt /NVL(orig_curr_rate,convert_rate) net_disb_amt --beth 08072006
              FROM GIAC_INW_CLAIM_PAYTS
             WHERE gacc_tran_id = :NEW.tran_id)
  LOOP
    FOR b IN (SELECT claim_id, item_no, peril_cd, GROUPED_ITEM_NO
                  FROM GICL_CLM_LOSS_EXP
               WHERE claim_id = a.claim_id
                 AND clm_loss_id = a.clm_loss_id
                 AND advice_id = a.advice_id)
    LOOP
      v_item_no := b.item_no;
      v_grouped_item_no := b.grouped_item_no;
      v_peril_cd := b.peril_cd;
      v_dist_no := NULL;

      /* get dist_no that will be inserted*/
      FOR s IN(SELECT clm_dist_no
                 FROM GICL_LOSS_EXP_DS
                WHERE claim_id    = a.claim_id
                  AND clm_loss_id = a.clm_loss_id
                  AND item_no     = v_item_no
                  AND grouped_item_no     = v_grouped_item_no
                  AND peril_cd    = v_peril_cd
                        AND NVL(negate_tag, 'N') = 'N')
      LOOP
           v_dist_no := s.clm_dist_no;
           EXIT;
      END LOOP;
      --end

      FOR C IN (SELECT MAX(NVL(clm_res_hist_id,0)) + 1 res_hist_id
                  FROM GICL_CLM_RES_HIST
                 WHERE claim_id = a.claim_id)
      LOOP
        v_res_hist := C.res_hist_id;
        FOR d IN (SELECT MAX(NVL(hist_seq_no,0)) + 1 hist
                    FROM GICL_CLM_RES_HIST
                   WHERE claim_id = a.claim_id
                     AND item_no = v_item_no
                        AND NVL(grouped_item_no,0) = v_grouped_item_no  --emcy da091106te : error in GIACS052, passes null value
                     AND peril_cd = v_peril_cd)
        LOOP
          v_hist_seq := d.hist;
/*:NEW.tran_flag = 'C' AND :OLD.tran_flag = 'O'*/
          IF :NEW.tran_flag = 'C' AND :OLD.tran_flag = 'O' THEN
/*--payee_type = 'L'--*/
             IF a.payee_type = 'L' THEN
                INSERT INTO GICL_CLM_RES_HIST
                              (claim_id,      clm_res_hist_id, hist_seq_no,
                            item_no,       peril_cd,        payee_class_cd,
                            payee_cd,      date_paid,       losses_paid,
                            net_pd_loss,   currency_cd,     convert_rate,
                                           tran_id,       advice_id,       clm_loss_id,
                                           user_id,       last_update,     dist_no,
                                           grouped_item_no)
                    VALUES (a.claim_id,     v_res_hist,     v_hist_seq,
                            v_item_no,      v_peril_cd,     a.payee_class_cd,
                            a.payee_cd,     :NEW.tran_date, a.disbursement_amt,
                            a.net_disb_amt, a.currency_cd,  a.convert_rate,
                                           :NEW.tran_id,   a.advice_id,    a.clm_loss_id,
                                           NVL (giis_users_pkg.app_user, USER),           SYSDATE,        v_dist_no,
                                           v_grouped_item_no);
                UPDATE GICL_CLM_RESERVE
                   SET losses_paid = NVL(losses_paid,0) + a.disbursement_amt,
                       net_pd_loss = NVL(net_pd_loss,0) + a.net_disb_amt
                 WHERE claim_id = a.claim_id
                   AND item_no = v_item_no
                   AND grouped_item_no     = v_grouped_item_no
                   AND peril_cd = v_peril_cd;

                UPDATE GICL_CLAIMS
                   SET loss_pd_amt = NVL(loss_pd_amt,0) + a.disbursement_amt,
                       net_pd_loss = NVL(net_pd_loss,0) + a.net_disb_amt
                 WHERE claim_id = a.claim_id;
/*--payee_type = 'E'--*/
             ELSIF a.payee_type = 'E' THEN
                INSERT INTO GICL_CLM_RES_HIST
                           (claim_id,      clm_res_hist_id, hist_seq_no,
                            item_no,       peril_cd,        payee_class_cd,
                            payee_cd,      date_paid,       expenses_paid,
                            net_pd_exp,    currency_cd,     convert_rate,
                                          tran_id,       advice_id,       clm_loss_id,
                                          user_id,       last_update,     dist_no,
                                  grouped_item_no)
                    VALUES (a.claim_id,     v_res_hist,     v_hist_seq,
                              v_item_no,      v_peril_cd,     a.payee_class_cd,
                              a.payee_cd,     :NEW.tran_date, a.disbursement_amt,
                            a.net_disb_amt, a.currency_cd,  a.convert_rate,
                                          :NEW.tran_id,   a.advice_id,    a.clm_loss_id,
                                          NVL (giis_users_pkg.app_user, USER),           SYSDATE,        v_dist_no,
                                        v_grouped_item_no);

                UPDATE GICL_CLM_RESERVE
                      SET expenses_paid = NVL(expenses_paid,0) + a.disbursement_amt,
                               net_pd_exp = NVL(net_pd_exp,0) + a.net_disb_amt
                   WHERE claim_id = a.claim_id
                     AND item_no = v_item_no
                     AND grouped_item_no     = v_grouped_item_no
                     AND peril_cd = v_peril_cd;

                UPDATE GICL_CLAIMS
                   SET exp_pd_amt = NVL(exp_pd_amt,0) + a.disbursement_amt,
                       net_pd_exp = NVL(net_pd_exp,0) + a.net_disb_amt
                 WHERE claim_id = a.claim_id;
             END IF;
/*--end--*/
/*--transaction_type = 1--*/
             IF a.transaction_type = 1 THEN
                UPDATE GICL_CLM_LOSS_EXP
                   SET tran_id = :NEW.tran_id,
                       tran_date = :NEW.tran_date
                 WHERE claim_id = a.claim_id
                   AND clm_loss_id = a.clm_loss_id
                   AND advice_id = a.advice_id;
/*--transaction_type = 2--*/
           ELSIF a.transaction_type = 2 THEN
                UPDATE GICL_CLM_LOSS_EXP
                   SET tran_id = NULL,
                       tran_date = NULL
                 WHERE claim_id = a.claim_id
                   AND clm_loss_id = a.clm_loss_id
                   AND advice_id = a.advice_id;

                UPDATE GICL_ADVICE
                   SET apprvd_tag = 'N'
                     WHERE claim_id = a.claim_id
                       AND advice_id = a.advice_id;
                        --BETH 11092004
                        FOR chk_batch IN(SELECT batch_csr_id
                                            FROM GICL_ADVICE
                                           WHERE claim_id = a.claim_id
                                         AND advice_id = a.advice_id)
                        LOOP
                          IF chk_batch.batch_csr_id IS NOT NULL THEN
                             v_batch_sw := 'N';
                             FOR chk_valid_advice IN (SELECT '1'
                                                         FROM GICL_ADVICE
                                                         WHERE batch_csr_id = chk_batch.batch_csr_id
                                                            AND NVL(apprvd_tag,'N') <> 'N')
                               LOOP
                                 v_batch_sw := 'Y';
                                 EXIT;
                               END LOOP;
                               IF v_batch_sw = 'N' THEN
                        UPDATE GICL_BATCH_CSR
                           SET batch_flag = 'N',
                               tran_id = NULL,
                               ref_id = NULL,
                               req_dtl_no = NULL
                         WHERE batch_csr_id = chk_batch.batch_csr_id;
                              END IF;
                          END IF;
                        END LOOP;
                END IF;
/*--end--*/
/*:OLD.tran_flag = 'C' AND (:NEW.tran_flag = 'D' OR :NEW.tran_flag = 'O')*/
          ELSIF :OLD.tran_flag = 'C' AND (:NEW.tran_flag = 'D' OR :NEW.tran_flag = 'O') THEN
/*--transaction_type = 1--*/
             IF a.transaction_type = 1 THEN
                UPDATE GICL_CLM_RES_HIST
                   SET cancel_tag = 'Y',
                       cancel_date = SYSDATE
                 WHERE claim_id = a.claim_id
                   AND item_no = v_item_no
                     AND grouped_item_no     = v_grouped_item_no
                   AND peril_cd = v_peril_cd
                   AND tran_id = :NEW.tran_id;

                UPDATE GICL_CLM_LOSS_EXP
                   SET tran_id = NULL,
                       tran_date = NULL
                 WHERE claim_id = a.claim_id
                   AND clm_loss_id = a.clm_loss_id
                   AND advice_id = a.advice_id;
                /*UPDATE GICL_ADVICE
                   SET apprvd_tag = 'N'
                 WHERE claim_id = a.claim_id
                   AND advice_id = a.advice_id;*/   -- judyann 09292005
/*-==payee_type = 'L'==-*/
                IF a.payee_type = 'L' THEN
                  UPDATE GICL_CLM_RESERVE
                       SET losses_paid = NVL(losses_paid,0) - a.disbursement_amt,
                         net_pd_loss = NVL(net_pd_loss,0) - a.net_disb_amt
                     WHERE claim_id = a.claim_id
                       AND item_no = v_item_no
                       AND grouped_item_no     = v_grouped_item_no
                       AND peril_cd = v_peril_cd;

                  UPDATE GICL_CLAIMS
                      SET loss_pd_amt = NVL(loss_pd_amt,0) - a.disbursement_amt,
                          net_pd_loss = NVL(net_pd_loss,0) - a.net_disb_amt
                    WHERE claim_id = a.claim_id;
/*-==payee_type = 'E'==-*/
                ELSIF a.payee_type = 'E' THEN
                   UPDATE GICL_CLM_RESERVE
                        SET expenses_paid = NVL(expenses_paid,0) - a.disbursement_amt,
                          net_pd_exp = NVL(net_pd_exp,0) - a.net_disb_amt
                    WHERE claim_id = a.claim_id
                         AND item_no = v_item_no
                        AND peril_cd = v_peril_cd;

                   UPDATE GICL_CLAIMS
                      SET exp_pd_amt = NVL(exp_pd_amt,0) - a.disbursement_amt,
                          net_pd_exp = NVL(net_pd_exp,0) - a.net_disb_amt
                    WHERE claim_id = a.claim_id;
                END IF;
/*-==end==-*/
/*--transaction_type = 2--*/
             ELSIF a.transaction_type = 2 THEN
                        FOR r IN (SELECT u.tran_id, u.date_paid
                                    FROM GIAC_DIRECT_CLAIM_PAYTS s, GICL_CLM_LOSS_EXP t,
                                         GICL_CLM_RES_HIST u
                                   WHERE s.claim_id = t.claim_id
                                     AND s.advice_id = t.advice_id
                                     AND s.clm_loss_id = t.clm_loss_id
                                     AND t.claim_id = u.claim_id
                                     AND t.item_no = u.item_no
                                     AND t.grouped_item_no = u.grouped_item_no
                                     AND t.peril_cd = u.peril_cd
                                     AND s.transaction_type = 1
                                     AND s.claim_id = a.claim_id
                                     AND s.advice_id = a.advice_id
                                     AND t.item_no = v_item_no
                                                   AND t.grouped_item_no = v_grouped_item_no
                                     AND t.peril_cd = v_peril_cd
                                     AND u.tran_id IS NOT NULL
                                     AND s.gacc_tran_id = u.tran_id
                                     AND NVL(u.cancel_tag,'N') = 'N'
                                     AND NVL(u.losses_paid,0) >= 0
                                     AND NVL(u.expenses_paid,0) >= 0)
                LOOP
                          UPDATE GICL_CLM_LOSS_EXP
                              SET tran_id = r.tran_id,
                                   tran_date = r.date_paid
                           WHERE claim_id = a.claim_id
                               AND clm_loss_id = a.clm_loss_id
                             AND advice_id = a.advice_id;
                END LOOP;

                UPDATE GICL_CLM_RES_HIST
                           SET cancel_tag = 'Y',
                               cancel_date = SYSDATE
                         WHERE claim_id = a.claim_id
                   AND item_no = v_item_no
                     AND grouped_item_no     = v_grouped_item_no
                   AND peril_cd = v_peril_cd
                   AND tran_id = :NEW.tran_id;

                UPDATE GICL_ADVICE
                     SET apprvd_tag = 'Y'
                 WHERE claim_id = a.claim_id
                     AND advice_id = a.advice_id;
/*-==payee_type = 'L'==-*/
                IF a.payee_type = 'L' THEN
                   UPDATE GICL_CLM_RESERVE
                      SET losses_paid = NVL(losses_paid,0) - a.disbursement_amt,
                          net_pd_loss = NVL(net_pd_loss,0) - a.net_disb_amt
                      WHERE claim_id = a.claim_id
                        AND item_no = v_item_no
                        AND grouped_item_no     = v_grouped_item_no
                      AND peril_cd = v_peril_cd;

                   UPDATE GICL_CLAIMS
                      SET loss_pd_amt = NVL(loss_pd_amt,0) - a.disbursement_amt,
                          net_pd_loss = NVL(net_pd_loss,0) - a.net_disb_amt
                      WHERE claim_id = a.claim_id;
/*-==payee_type = 'E'==-*/
                ELSIF a.payee_type = 'E' THEN
                   UPDATE GICL_CLM_RESERVE
                      SET expenses_paid = NVL(expenses_paid,0) - a.disbursement_amt,
                          net_pd_exp = NVL(net_pd_exp,0) - a.net_disb_amt
                    WHERE claim_id = a.claim_id
                      AND item_no = v_item_no
                      AND grouped_item_no     = v_grouped_item_no
                      AND peril_cd = v_peril_cd;

                   UPDATE GICL_CLAIMS
                      SET exp_pd_amt = NVL(exp_pd_amt,0) - a.disbursement_amt,
                          net_pd_exp = NVL(net_pd_exp,0) - a.net_disb_amt
                    WHERE claim_id = a.claim_id;
                END IF;
/*-==end==-*/
             END IF;
             IF :NEW.tran_flag = 'D' THEN   -- moved by VJ 050207
                      IF a.transaction_type = 1 THEN
                        UPDATE GICL_ADVICE
                       SET apprvd_tag = 'N'
                     WHERE claim_id = a.claim_id
                          AND advice_id = a.advice_id;
                END IF;
             END IF;
         /* ELSIF :OLD.tran_flag = 'C' AND :NEW.tran_flag = 'D' THEN   -- judyann 09292005
               IF a.transaction_type = 1 THEN
                 UPDATE GICL_ADVICE
               SET apprvd_tag = 'N'
             WHERE claim_id = a.claim_id
                 AND advice_id = a.advice_id;
         END IF;*/--comment by VJ 050207
     ELSIF  :OLD.tran_flag = 'O' AND :NEW.tran_flag = 'D' THEN   -- added by vj 050207
                      IF a.transaction_type = 1 THEN
                        UPDATE GICL_ADVICE
                       SET apprvd_tag = 'N'
                     WHERE claim_id = a.claim_id
                          AND advice_id = a.advice_id;
               ELSE
                        UPDATE GICL_ADVICE
                       SET apprvd_tag = 'Y'
                     WHERE claim_id = a.claim_id
                          AND advice_id = a.advice_id;
               END IF;
         END IF;
      END LOOP;
      END LOOP;
    END LOOP;
  END LOOP;
/* MODIFIED BY PIA, 11.25.02. UPDATE CLAIM RECOVERY TABLES */
  FOR P IN (SELECT claim_id, recovery_id, payor_class_cd,
                   payor_cd, collection_amt
              FROM GIAC_LOSS_RECOVERIES
             WHERE gacc_tran_id = :NEW.tran_id)
  LOOP
    IF :NEW.tran_flag = 'D' THEN
       UPDATE GICL_RECOVERY_PAYT
          SET cancel_tag = 'Y',
              cancel_date = SYSDATE
        WHERE recovery_id = P.recovery_id
          AND claim_id = P.claim_id
          AND payor_class_cd = P.payor_class_cd
          AND payor_cd = P.payor_cd
          AND acct_tran_id = :NEW.tran_id;
       UPDATE GICL_CLM_RECOVERY
          SET recovered_amt = NVL(recovered_amt,0) - P.collection_amt
        WHERE recovery_id = P.recovery_id
          AND claim_id = P.claim_id;
       UPDATE GICL_RECOVERY_PAYOR
          SET recovered_amt = NVL(recovered_amt,0) - P.collection_amt
        WHERE claim_id = P.claim_id
          AND recovery_id = P.recovery_id
          AND payor_class_cd = P.payor_class_cd
          AND payor_cd = P.payor_cd;
    ELSIF :NEW.tran_flag = 'C' THEN -- added by benjo 08.26.2015 UCPBGEN-SR-19654
       UPDATE GICL_RECOVERY_PAYT
          SET stat_sw = 'Y'
        WHERE recovery_id = P.recovery_id
          AND claim_id = P.claim_id
          AND payor_class_cd = P.payor_class_cd
          AND payor_cd = P.payor_cd
          AND acct_tran_id = :NEW.tran_id;
    END IF;
  END LOOP;
END;
/


