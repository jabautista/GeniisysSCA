DROP PROCEDURE CPI.GICLS032_INSERT_INTO_GDCP;

CREATE OR REPLACE PROCEDURE CPI.gicls032_insert_into_gdcp (
   p_claim_id         gicl_advice.claim_id%TYPE,
   p_advice_id        gicl_advice.advice_id%TYPE,
   p_iss_cd           gicl_advice.iss_cd%TYPE,
   p_user_id          giis_users.user_id%TYPE,
   p_tran_id          giac_payt_requests_dtl.tran_id%TYPE,
   p_payee_cd         giac_payt_requests_dtl.payee_cd%TYPE,
   p_payee_class_cd   giac_payt_requests_dtl.payee_class_cd%TYPE
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - insert_into_gdcp
   */
   
   v_payee_type         giac_direct_claim_payts.payee_type%TYPE;
   v_disb_amt           giac_direct_claim_payts.disbursement_amt%TYPE;
   v_net_disb_amt       giac_direct_claim_payts.net_disb_amt%TYPE;
   v_foreign_curr_amt   giac_direct_claim_payts.foreign_curr_amt%TYPE;
   v_local_currency     NUMBER                                          := giacp.n ('CURRENCY_CD');
   v_ri_iss_cd          giac_parameters.param_value_v%TYPE              := giacp.v ('RI_ISS_CD');
   tax_amt              NUMBER (16, 2)                                  DEFAULT 0;
   wtax_amt             NUMBER (16, 2)                                  DEFAULT 0;
   v_clm_loss_id        gicl_clm_loss_exp.clm_loss_id%TYPE;                                                        --roset,2/8/10
BEGIN
   FOR b IN (SELECT DISTINCT a.payee_type, a.clm_loss_id, a.net_amt, a.paid_amt, b.currency_cd,
                             NVL (b.orig_curr_rate, b.convert_rate),
                             DECODE (a.currency_cd, v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) conv_rt_a,
                             DECODE (b.currency_cd, v_local_currency, 1, NVL (b.orig_curr_rate, b.convert_rate)) conv_rt_b,
                             b.orig_curr_cd, b.orig_curr_rate                                                              --beth
                        FROM gicl_clm_loss_exp a, gicl_advice b
                       WHERE a.claim_id = b.claim_id
                         AND a.advice_id = b.advice_id
                         AND a.advice_id = p_advice_id
                         AND a.claim_id = p_claim_id
                         AND a.payee_cd = p_payee_cd
                         AND a.payee_class_cd = p_payee_class_cd
                         AND b.advice_flag = 'Y')
   LOOP
      v_payee_type := b.payee_type;
      v_clm_loss_id := b.clm_loss_id;                                                                           --roset, 2/8/2010

      FOR al IN (SELECT SUM (NVL (b.tax_amt, 0)) tax_amount
                   FROM gicl_clm_loss_exp a, gicl_loss_exp_tax b
                  WHERE a.claim_id = b.claim_id
                    AND a.clm_loss_id = b.clm_loss_id
                    AND a.claim_id = p_claim_id
                    AND a.advice_id = p_advice_id
                    AND a.payee_cd = p_payee_cd
                    AND a.payee_class_cd = p_payee_class_cd
                    AND a.payee_type = v_payee_type
                    AND b.tax_type = 'I'
                    AND a.clm_loss_id = v_clm_loss_id)                      --roset 2/8/2010, to get the input vat per clm_loss_id
      LOOP
         tax_amt := tax_amt + NVL (al.tax_amount, 0) * b.conv_rt_a;
      END LOOP;

      FOR me IN (SELECT SUM (NVL (b.tax_amt, 0)) tax_amount
                   FROM gicl_clm_loss_exp a, gicl_loss_exp_tax b
                  WHERE a.claim_id = b.claim_id
                    AND a.clm_loss_id = b.clm_loss_id
                    AND a.claim_id = p_claim_id
                    AND a.advice_id = p_advice_id
                    AND a.payee_cd = p_payee_cd
                    AND a.payee_class_cd = p_payee_class_cd
                    AND a.payee_type = v_payee_type
                    AND b.tax_type = 'W'
                    AND a.clm_loss_id = v_clm_loss_id)                   --roset 2/8/2010, to get the wholding tax per clm_loss_id
      LOOP
         wtax_amt := wtax_amt + NVL (me.tax_amount, 0) * b.conv_rt_a;
      END LOOP;

      v_disb_amt := NVL (b.net_amt, 0) * b.conv_rt_a;
      v_net_disb_amt := NVL (b.paid_amt, 0) * b.conv_rt_a;
      v_foreign_curr_amt := (NVL (b.net_amt, 0) * b.conv_rt_a) / b.conv_rt_b;

/* modified by judyann 08202003
** added column net_disb_amt
*/
      IF p_iss_cd <> v_ri_iss_cd
      THEN
         INSERT INTO giac_direct_claim_payts
                     (gacc_tran_id, transaction_type, claim_id, clm_loss_id, advice_id, payee_cd, payee_class_cd, payee_type,
                      disbursement_amt, currency_cd, convert_rate, foreign_curr_amt, user_id, last_update, input_vat_amt,
                      wholding_tax_amt, net_disb_amt, orig_curr_cd, orig_curr_rate
                     )
              VALUES (p_tran_id, 1, p_claim_id, b.clm_loss_id, p_advice_id, p_payee_cd, p_payee_class_cd, v_payee_type,
                      v_disb_amt, b.currency_cd, b.conv_rt_b, v_foreign_curr_amt, p_user_id, SYSDATE, tax_amt,
                      wtax_amt, v_net_disb_amt, b.orig_curr_cd, b.orig_curr_rate
                     );
      ELSIF p_iss_cd = v_ri_iss_cd
      THEN
         INSERT INTO giac_inw_claim_payts
                     (gacc_tran_id, transaction_type, claim_id, clm_loss_id, advice_id, payee_cd, payee_class_cd, payee_type,
                      disbursement_amt, currency_cd, convert_rate, foreign_curr_amt, user_id, last_update, input_vat_amt,
                      wholding_tax_amt, net_disb_amt, orig_curr_cd, orig_curr_rate
                     )
              VALUES (p_tran_id, 1, p_claim_id, b.clm_loss_id, p_advice_id, p_payee_cd, p_payee_class_cd, v_payee_type,
                      v_disb_amt, b.currency_cd, b.conv_rt_b, v_foreign_curr_amt, p_user_id, SYSDATE, tax_amt,
                      wtax_amt, v_net_disb_amt, b.orig_curr_cd, b.orig_curr_rate
                     );
      END IF;

      tax_amt := 0;
      wtax_amt := 0;
   END LOOP;

   IF SQL%NOTFOUND
   THEN
      IF p_iss_cd <> v_ri_iss_cd
      THEN
         raise_application_error (-20001, 'Cannot Insert into GIAC_DIRECT_CLAIM_PAYTS');
      ELSIF p_iss_cd = v_ri_iss_cd
      THEN
         raise_application_error (-20001, 'Cannot Insert into GIAC_INW_CLAIM_PAYTS');
      END IF;
   END IF;   
END;
/


