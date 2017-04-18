DROP PROCEDURE CPI.GICLS032_REVERSE_TAKEUP_HIST;

CREATE OR REPLACE PROCEDURE CPI.gicls032_reverse_takeup_hist(
  p_claim_id         gicl_advice.claim_id%TYPE,
  p_advice_id        gicl_advice.advice_id%TYPE,
  p_user_id          giis_users.user_id%TYPE
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - reverse_takeup_hist
   */

   v_take_up_hist   gicl_take_up_hist.take_up_hist%TYPE;
   v_net_amt        gicl_advice.net_amt%TYPE;
   v_setup          giac_parameters.param_value_n%TYPE    := giacp.n ('OS_BATCH_TAKEUP');
BEGIN
   IF v_setup = 2
   THEN
      BEGIN
         FOR i IN (SELECT   b.payee_type, b.item_no, b.peril_cd, b.final_tag, a.acct_intm_cd, SUM (net_amt) net_amt
                       FROM gicl_take_up_hist a, gicl_clm_loss_exp b
                      WHERE a.claim_id = b.claim_id
                        AND a.item_no = b.item_no
                        AND a.peril_cd = b.peril_cd
                        AND a.take_up_type = 'N'
                        AND NVL (b.cancel_sw, 'N') = 'N'
                        AND b.claim_id = p_claim_id
                        AND b.advice_id = p_advice_id
                   GROUP BY b.payee_type, b.item_no, b.peril_cd, b.final_tag, a.acct_intm_cd)
         LOOP
            BEGIN
               SELECT NVL (MAX (take_up_hist), 0) + 1
                 INTO v_take_up_hist
                 FROM gicl_take_up_hist
                WHERE claim_id = p_claim_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_take_up_hist := 1;
            END;

            IF i.final_tag = 'Y'
            THEN
               FOR l IN (SELECT MAX (take_up_hist) hist
                           FROM gicl_take_up_hist a
                          WHERE a.take_up_type = 'N'
                            AND a.claim_id = p_claim_id
                            AND a.item_no = i.item_no
                            AND a.peril_cd = i.peril_cd)
               LOOP
                  FOR y IN (SELECT a.os_loss, a.os_expense
                              FROM gicl_take_up_hist a
                             WHERE a.take_up_type = 'N'
                               AND a.claim_id = p_claim_id
                               AND a.item_no = i.item_no
                               AND a.peril_cd = i.peril_cd
                               AND a.take_up_hist = l.hist)
                  LOOP
                     IF i.payee_type = 'L'
                     THEN
                        INSERT INTO gicl_take_up_hist
                                    (claim_id, take_up_type, take_up_hist, item_no, peril_cd, os_loss, os_expense,
                                     acct_intm_cd, user_id, last_update
                                    )
                             VALUES (p_claim_id, 'R', v_take_up_hist, i.item_no, i.peril_cd, (y.os_loss * -1), 0,
                                     i.acct_intm_cd, USER, SYSDATE
                                    );
                     ELSIF i.payee_type = 'E'
                     THEN
                        INSERT INTO gicl_take_up_hist
                                    (claim_id, take_up_type, take_up_hist, item_no, peril_cd, os_loss, os_expense,
                                     acct_intm_cd, user_id, last_update
                                    )
                             VALUES (p_claim_id, 'R', v_take_up_hist, i.item_no, i.peril_cd, 0, (y.os_expense * -1),
                                     i.acct_intm_cd, USER, SYSDATE
                                    );
                     END IF;
                  END LOOP;
               END LOOP;
            ELSIF NVL (i.final_tag, 'N') = 'N'
            THEN
               IF i.payee_type = 'L'
               THEN
                  INSERT INTO gicl_take_up_hist
                              (claim_id, take_up_type, take_up_hist, item_no, peril_cd, os_loss, os_expense, acct_intm_cd,
                               user_id, last_update
                              )
                       VALUES (p_claim_id, 'R', v_take_up_hist, i.item_no, i.peril_cd, (i.net_amt * -1), 0, i.acct_intm_cd,
                               p_user_id, SYSDATE
                              );
               ELSIF i.payee_type = 'E'
               THEN
                  INSERT INTO gicl_take_up_hist
                              (claim_id, take_up_type, take_up_hist, item_no, peril_cd, os_loss, os_expense, acct_intm_cd,
                               user_id, last_update
                              )
                       VALUES (p_claim_id, 'R', v_take_up_hist, i.item_no, i.peril_cd, 0, (i.net_amt * -1), i.acct_intm_cd,
                               p_user_id, SYSDATE
                              );
               END IF;
            END IF;
         END LOOP;
      END;
   END IF;
   
END;
/


