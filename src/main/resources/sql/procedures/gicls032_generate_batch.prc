DROP PROCEDURE CPI.GICLS032_GENERATE_BATCH;

CREATE OR REPLACE PROCEDURE CPI.gicls032_generate_batch (
   p_claim_id    gicl_advice.claim_id%TYPE,
   p_advice_id   gicl_advice.advice_id%TYPE,
   p_line_cd     gicl_claims.line_cd%TYPE,
   p_variables   gicl_advice_pkg.gicls032_variables
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - generate_batch
   */ 
   
   v_take_up_hist    gicl_take_up_hist.take_up_hist%TYPE;
   v_net_amt         gicl_advice.net_amt%TYPE;
BEGIN
   IF p_variables.v_setup = 2
   THEN
      BEGIN
         FOR i IN (SELECT DISTINCT b.final_tag, payee_class_cd, payee_cd
                              FROM gicl_clm_loss_exp b
                             WHERE b.claim_id = p_claim_id AND b.advice_id = p_advice_id)
         LOOP
            IF i.final_tag = 'Y'
            THEN
               IF p_variables.v_param = 'Y' AND p_variables.v_gl_acct_ctgry <> 0
               THEN
                  gicls032_setup_four (p_claim_id, p_advice_id, p_line_cd, i.payee_class_cd, i.payee_cd, p_variables);
               ELSIF p_variables.v_param = 'Y' AND p_variables.v_gl_acct_ctgry = 0
               THEN
                  gicls032_setup_five (p_claim_id, p_advice_id, p_line_cd, i.payee_class_cd, i.payee_cd, p_variables);
               ELSIF p_variables.v_param = 'N'
               THEN
                  gicls032_setup_six (p_claim_id, p_advice_id, p_line_cd, i.payee_class_cd, i.payee_cd, p_variables);
               END IF;
            ELSIF NVL (i.final_tag, 'N') = 'N'
            THEN
               IF p_variables.v_param = 'Y' AND p_variables.v_gl_acct_ctgry <> 0
               THEN
                  gicls032_setup_one (p_claim_id, p_advice_id, p_line_cd, i.payee_class_cd, i.payee_cd, p_variables);
               ELSIF p_variables.v_param = 'Y' AND p_variables.v_gl_acct_ctgry = 0
               THEN
                  gicls032_setup_two (p_claim_id, p_advice_id, p_line_cd, i.payee_class_cd, i.payee_cd, p_variables);
               ELSIF p_variables.v_param = 'N'
               THEN
                  gicls032_setup_three (p_claim_id, p_advice_id, p_line_cd, i.payee_class_cd, i.payee_cd, p_variables);
               END IF;
            END IF;
         END LOOP;
      END;
   END IF;
END;
/


