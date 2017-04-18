DROP TRIGGER CPI.GICL_CLM_RESERVE_TAXUX;

CREATE OR REPLACE TRIGGER CPI.GICL_CLM_RESERVE_TAXUX
/* for automatic closing of item-peril and claim */
   AFTER UPDATE OF losses_paid, expenses_paid
   ON CPI.GICL_CLM_RESERVE    FOR EACH ROW
DECLARE
   v_final_loss   gicl_clm_loss_exp.final_tag%TYPE;
   v_final_exp    gicl_clm_loss_exp.final_tag%TYPE;
BEGIN
   IF giacp.v ('AUTO_CLOSE_CLAIM') = 'Y'
   THEN
      IF (   :NEW.losses_paid > NVL (:OLD.losses_paid, 0)
          OR :NEW.expenses_paid > NVL (:OLD.expenses_paid, 0)
         )
      THEN
         FOR t IN (SELECT   transaction_type, MAX (clm_res_hist_id)
                       FROM gicl_clm_res_hist a, giac_direct_claim_payts b
                      WHERE a.claim_id = b.claim_id
                        AND a.advice_id = b.advice_id
                        AND a.clm_loss_id = b.clm_loss_id
                        AND a.tran_id = b.gacc_tran_id
                        AND a.claim_id = :NEW.claim_id
                        AND a.item_no = :NEW.item_no
                        AND NVL (a.grouped_item_no, 0) =
                                                 NVL (:NEW.grouped_item_no, 0)
                        AND a.peril_cd = :NEW.peril_cd
                   GROUP BY transaction_type
                   --erica 04.19.13
                   UNION
                   SELECT   transaction_type, MAX (clm_res_hist_id)
                       FROM gicl_clm_res_hist a, giac_inw_claim_payts b
                      WHERE a.claim_id = b.claim_id
                        AND a.advice_id = b.advice_id
                        AND a.clm_loss_id = b.clm_loss_id
                        AND a.tran_id = b.gacc_tran_id
                        AND a.claim_id = :NEW.claim_id
                        AND a.item_no = :NEW.item_no
                        AND NVL (a.grouped_item_no, 0) =
                                                 NVL (:NEW.grouped_item_no, 0)
                        AND a.peril_cd = :NEW.peril_cd
                   GROUP BY transaction_type)--end 04.19.13
         LOOP
            IF t.transaction_type = 1
            THEN
               IF (:NEW.loss_reserve IS NOT NULL OR :NEW.loss_reserve <> 0)
               THEN
                  FOR l IN (SELECT   final_tag, MAX (clm_res_hist_id)
                                FROM gicl_clm_res_hist a,
                                     gicl_clm_loss_exp b
                               WHERE a.claim_id = b.claim_id
                                 AND a.item_no = b.item_no
                                 AND a.peril_cd = b.peril_cd
                                 AND a.clm_loss_id = b.clm_loss_id
                                 AND a.tran_id IS NOT NULL
                                 AND NVL (cancel_tag, 'N') = 'N'
                                 AND b.payee_type = 'L'
                                 AND a.claim_id = :NEW.claim_id
                                 AND a.item_no = :NEW.item_no
                                 AND NVL (a.grouped_item_no, 0) =
                                                 NVL (:NEW.grouped_item_no, 0)
                                 AND a.peril_cd = :NEW.peril_cd
                            GROUP BY final_tag)
                  LOOP
                     v_final_loss := l.final_tag;
                  END LOOP;
               END IF;

               IF (   :NEW.expense_reserve IS NOT NULL
                   OR :NEW.expense_reserve <> 0
                  )
               THEN
                  FOR e IN (SELECT   final_tag, MAX (clm_res_hist_id)
                                FROM gicl_clm_res_hist a,
                                     gicl_clm_loss_exp b
                               WHERE a.claim_id = b.claim_id
                                 AND a.item_no = b.item_no
                                 AND a.peril_cd = b.peril_cd
                                 AND a.clm_loss_id = b.clm_loss_id
                                 AND a.tran_id IS NOT NULL
                                 AND NVL (cancel_tag, 'N') = 'N'
                                 AND b.payee_type = 'E'
                                 AND a.claim_id = :NEW.claim_id
                                 AND a.item_no = :NEW.item_no
                                 AND NVL (a.grouped_item_no, 0) =
                                                 NVL (:NEW.grouped_item_no, 0)
                                 AND a.peril_cd = :NEW.peril_cd
                            GROUP BY final_tag)
                  LOOP
                     v_final_exp := e.final_tag;
                  END LOOP;
               END IF;

               FOR c IN (SELECT   DECODE (NVL (v_final_loss, 'Y'),
                                          'Y', 1,
                                          'N', -1,
                                          NULL, 0
                                         )
                                + DECODE (NVL (v_final_exp, 'Y'),
                                          'Y', 1,
                                          'N', -1,
                                          NULL, 0
                                         ) tag
                           FROM DUAL)
               LOOP
                  IF (c.tag = 1 OR c.tag = 2)
                  THEN
                     UPDATE gicl_item_peril
                        SET close_flag = 'CC',
                            close_date = SYSDATE
                      WHERE claim_id = :NEW.claim_id
                        AND item_no = :NEW.item_no
                        AND NVL (grouped_item_no, 0) =
                                                 NVL (:NEW.grouped_item_no, 0)
                        AND close_flag = 'AP'
                        AND peril_cd = :NEW.peril_cd;

                     UPDATE gicl_item_peril
                        SET close_flag2 = 'CC',
                            close_date2 = SYSDATE
                      WHERE claim_id = :NEW.claim_id
                        AND item_no = :NEW.item_no
                        AND NVL (grouped_item_no, 0) =
                                                 NVL (:NEW.grouped_item_no, 0)
                        AND close_flag2 = 'AP'
                        AND peril_cd = :NEW.peril_cd;
                  END IF;
               END LOOP;

               FOR s IN (SELECT clm_stat_cd
                           FROM gicl_claims
                          WHERE claim_id = :NEW.claim_id)
               LOOP
                  FOR c IN (SELECT COUNT (*) cnt
                              FROM gicl_item_peril
                             WHERE claim_id = :NEW.claim_id
                               AND close_flag NOT IN ('DN', 'WD'))
                  LOOP
                     FOR d IN (SELECT COUNT (*) clsd
                                 FROM gicl_item_peril
                                WHERE claim_id = :NEW.claim_id
                                  AND (close_flag = 'AP' OR close_flag2 = 'AP'
                                      ))
                     LOOP
                        IF d.clsd = 0
                        THEN
                           UPDATE gicl_claims
                              SET old_stat_cd = s.clm_stat_cd,
                                  clm_stat_cd = 'CD',
                                  close_date = SYSDATE
                            WHERE claim_id = :NEW.claim_id;
                        END IF;
                     END LOOP;
                  END LOOP;
               END LOOP;
            END IF;
         END LOOP;
      END IF;
   END IF;
END;
/


