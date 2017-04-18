DROP PROCEDURE CPI.GICLS032_ENABLE_DISABLE_BTNS;

CREATE OR REPLACE PROCEDURE CPI.gicls032_enable_disable_btns(
  p_claim_id        IN GICL_ADVICE.claim_id%TYPE,
  p_advice_id       IN GICL_ADVICE.advice_id%TYPE,
  p_btn_cancel_adv  OUT VARCHAR2,
  p_btn_print_csr   OUT VARCHAR2,
  p_btn_acct_ent_but OUT VARCHAR2,
  p_btn_app_csr     OUT VARCHAR2,
  p_btn_gen_acc     OUT VARCHAR2,
  p_btn_csr_but     OUT VARCHAR2,
  p_btn_gen_adv     OUT VARCHAR2,
  p_btn_lbl_print_csr OUT VARCHAR2
) IS
/**
  * Created by: Andrew Robes
  * Date created: 03.28.2012
  * Referenced by : (GICLS032 - Generate Advice)
  * Description : Converted procedure from gicls032 - enable_disable_button
  */
   v_exist    VARCHAR2 (2)                       := NULL;
   v_exist1   VARCHAR2 (2)                       := NULL;
   v_exist2   VARCHAR2 (2)                       := NULL;
   v_exist3   VARCHAR2 (2)                       := NULL;
   v_exist4   gicl_batch_csr.batch_csr_id%TYPE   := NULL;
   v_exist5   VARCHAR2 (2)                       := NULL;
   v_exist6   VARCHAR2 (2)                       := NULL;
   v_exist7   giac_batch_dv.batch_dv_id%TYPE     := NULL;
   v_exists   NUMBER                             := 0;                                                           --emcyDA080707TE
   v_in_hou_adj GICL_CLAIMS.in_hou_adj%TYPE;
   v_pol_iss_cd GICL_CLAIMS.pol_iss_cd%TYPE;
   v_ri_iss_cd VARCHAR2(10);
BEGIN
   v_ri_iss_cd := GIISP.V('ISS_CD_RI');

   SELECT pol_iss_cd, in_hou_adj
     INTO v_pol_iss_cd, v_in_hou_adj
     FROM gicl_claims
    WHERE claim_id = p_claim_id;

   BEGIN
      SELECT DISTINCT 'x'
                 INTO v_exist
                 FROM gicl_clm_loss_exp
                WHERE claim_id = p_claim_id AND advice_id = p_advice_id;

      IF v_exist IS NOT NULL
      THEN
         p_btn_cancel_adv := 'enable';
         p_btn_print_csr := 'enable';
         p_btn_acct_ent_but := 'enable';
         p_btn_app_csr := 'enable';
         p_btn_gen_acc := 'disable';
         p_btn_csr_but := 'disable';
         p_btn_gen_adv := 'disable';
         p_btn_lbl_print_csr := 'Print CSR';

         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist2
                       FROM gicl_advice
                      WHERE claim_id = p_claim_id AND advice_id = p_advice_id AND apprvd_tag = 'Y';

            IF v_exist2 IS NOT NULL
            THEN               
               p_btn_cancel_adv := 'enable';
               p_btn_print_csr := 'enable';
               p_btn_acct_ent_but := 'enable';
               p_btn_app_csr := 'disable';
               p_btn_gen_acc := 'enable';
               p_btn_csr_but := 'enable';

               BEGIN                                                                                             --emcyDA080707TE
                  SELECT DISTINCT 1
                             INTO v_exists
                             FROM gicl_clm_loss_exp
                            WHERE advice_id = p_advice_id AND tran_id IS NOT NULL;
                            
                     p_btn_cancel_adv := 'disable';
                     p_btn_print_csr := 'enable';
                     p_btn_acct_ent_but := 'enable';
                     p_btn_app_csr := 'disable';
                     p_btn_gen_acc := 'disable';
                     p_btn_csr_but := 'enable';
                     p_btn_lbl_print_csr := 'Final CSR';                                       
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN                                                                                     --no active acctng tran
                     NULL;
               END;

               --following codes where placed inside the new pl block--emcyDA080707TE
               IF v_pol_iss_cd <> v_ri_iss_cd
               THEN
                  BEGIN
                     SELECT DISTINCT 'x'
                                INTO v_exist1
                                FROM gicl_advice a,
                                     giac_direct_claim_payts b,
                                     giac_payt_requests_dtl c                                       --modified by judyann 01042002
                               WHERE a.claim_id = b.claim_id
                                 AND a.advice_id = b.advice_id
                                 AND b.gacc_tran_id = c.tran_id
                                 AND a.apprvd_tag = 'Y'
                                 AND c.payt_req_flag IN ('N', 'C')
                                 AND b.claim_id = p_claim_id
                                 AND b.advice_id = p_advice_id;

                     IF v_exist1 IS NOT NULL
                     THEN
                         p_btn_cancel_adv := 'disable';
                         p_btn_print_csr := 'enable';
                         p_btn_acct_ent_but := 'enable';
                         p_btn_app_csr := 'disable';
                         p_btn_gen_acc := 'disable';
                         p_btn_csr_but := 'enable';
                         p_btn_lbl_print_csr := 'Final CSR';
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN                                 --added by judyann 01022003; considered payments made through offsetting
                        BEGIN
                           SELECT DISTINCT 'x'
                                      INTO v_exist5
                                      FROM gicl_advice a, giac_direct_claim_payts b, giac_order_of_payts c
                                     WHERE a.claim_id = b.claim_id
                                       AND a.advice_id = b.advice_id
                                       AND b.gacc_tran_id = c.gacc_tran_id
                                       AND a.apprvd_tag = 'Y'
                                       AND c.or_flag <> 'C'
                                       AND b.claim_id = p_claim_id
                                       AND b.advice_id = p_advice_id;

                           IF v_exist5 IS NOT NULL
                           THEN
                             p_btn_cancel_adv := 'disable';
                             p_btn_print_csr := 'enable';
                             p_btn_acct_ent_but := 'disable';
                             p_btn_app_csr := 'disable';
                             p_btn_gen_acc := 'disable';
                             p_btn_csr_but := 'disable';
                           END IF;
                        EXCEPTION
                           WHEN NO_DATA_FOUND
                           THEN
                              NULL;
                        END;
                  END;
               ELSIF v_pol_iss_cd = v_ri_iss_cd
               THEN
                  BEGIN
                     SELECT DISTINCT 'x'
                                INTO v_exist3
                                FROM gicl_advice a, giac_inw_claim_payts b,
                                     giac_payt_requests_dtl c                                       --modified by judyann 01042002
                               WHERE a.claim_id = b.claim_id
                                 AND a.advice_id = b.advice_id
                                 AND b.gacc_tran_id = c.tran_id
                                 AND a.apprvd_tag = 'Y'
                                 AND c.payt_req_flag IN ('N', 'C')
                                 AND b.claim_id = p_claim_id
                                 AND b.advice_id = p_advice_id;

                     IF v_exist3 IS NOT NULL
                     THEN
                         p_btn_cancel_adv := 'disable';
                         p_btn_print_csr := 'enable';
                         p_btn_acct_ent_but := 'enable';
                         p_btn_app_csr := 'disable';
                         p_btn_gen_acc := 'disable';
                         p_btn_csr_but := 'enable';
                         p_btn_lbl_print_csr := 'Final CSR';                        
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN                                 --added by judyann 01022003; considered payments made through offsetting
                        BEGIN
                           SELECT DISTINCT 'x'
                                      INTO v_exist6
                                      FROM gicl_advice a, giac_inw_claim_payts b, giac_order_of_payts c
                                     WHERE a.claim_id = b.claim_id
                                       AND a.advice_id = b.advice_id
                                       AND b.gacc_tran_id = c.gacc_tran_id
                                       AND a.apprvd_tag = 'Y'
                                       AND c.or_flag <> 'C'
                                       AND b.claim_id = p_claim_id
                                       AND b.advice_id = p_advice_id;

                           IF v_exist6 IS NOT NULL
                           THEN
                              p_btn_cancel_adv := 'disable';
                              p_btn_print_csr := 'enable';
                              p_btn_acct_ent_but := 'disable';
                              p_btn_app_csr := 'disable';
                              p_btn_gen_acc := 'disable';
                              p_btn_csr_but := 'disable';                                                            
                           END IF;
                        EXCEPTION
                           WHEN NO_DATA_FOUND
                           THEN
                              NULL;
                        END;
                  END;
               END IF;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT batch_csr_id, batch_dv_id
              INTO v_exist4, v_exist7
              FROM gicl_advice
             WHERE claim_id = p_claim_id AND advice_id = p_advice_id;

            IF (v_exist4 IS NOT NULL OR v_exist7 IS NOT NULL)
            THEN
              p_btn_cancel_adv := 'disable';
              p_btn_print_csr := 'disable';
              p_btn_acct_ent_but := 'disable';
              p_btn_app_csr := 'disable';
              p_btn_gen_acc := 'disable';
              p_btn_csr_but := 'disable';               
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist4 := NULL;
               v_exist7 := NULL;
         END;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_btn_cancel_adv := 'disable';
         p_btn_print_csr := 'disable';
         p_btn_acct_ent_but := 'disable';
         p_btn_app_csr := 'disable';
         p_btn_gen_acc := 'disable';
         p_btn_csr_but := 'disable';
         p_btn_lbl_print_csr := 'Print CSR';         
   END;

   -- hardy 03/25/03
   -- disable ff. button if user != in_hou_adj
   IF NVL(giis_users_pkg.app_user, USER) != v_in_hou_adj
   THEN
     p_btn_cancel_adv := 'disable';
     p_btn_print_csr := 'disable';
     p_btn_acct_ent_but := 'disable';
     p_btn_app_csr := 'disable';
     p_btn_gen_acc := 'disable';
     p_btn_csr_but := 'disable';
   END IF;
END;
/


