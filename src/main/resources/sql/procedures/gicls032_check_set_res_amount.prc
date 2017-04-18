DROP PROCEDURE CPI.GICLS032_CHECK_SET_RES_AMOUNT;

CREATE OR REPLACE PROCEDURE CPI.gicls032_check_set_res_amount (
   p_claim_id            gicl_clm_loss_exp.claim_id%TYPE,
   p_advice_id           gicl_clm_loss_exp.advice_id%TYPE,
   p_selected_clm_loss   VARCHAR2,
   p_ovr_app_csr         VARCHAR2,
   p_user_name          VARCHAR2
)
IS
/**
  * Created by: Andrew Robes
  * Date created: 03.28.2012
  * Referenced by : (GICLS032 - Generate Advice)
  * Description : Converted procedure from gicls032 - check_set_res_amount
  */

   v_loss_set_amt    NUMBER                           := 0;
   v_exp_set_amt     NUMBER                           := 0;
   v_loss_res_amt    NUMBER                           := 0;
   v_exp_res_amt     NUMBER                           := 0;
   v_msg             VARCHAR2 (200)                   := ' ';
   v_disallow_pymt   VARCHAR2 (2)                     := giisp.v ('DISALLOW RESERVE LESS THAN PAYMENT');
   v_reqapp          VARCHAR2 (1)                     := 'N';
   v_approve         VARCHAR2 (1)                     := 'N';
   v_override        VARCHAR2 (1)                     := 'N';
   v_check_id        VARCHAR2 (50)                    := '';                                    --created by MAGeamoga 08/19/2011
   v_function_code   VARCHAR2 (5);   
   v_no_of_expense   NUMBER;
   v_no_of_loss      NUMBER;
   v_line_cd         gicl_claims.line_cd%TYPE;
   v_subline_cd      gicl_claims.subline_cd%TYPE;
   v_iss_cd          gicl_claims.iss_cd%TYPE;
   v_clm_yy          gicl_claims.clm_yy%TYPE;
   v_clm_seq_no      gicl_claims.clm_seq_no%TYPE;
   v_adv_line_cd     gicl_advice.line_cd%TYPE;
   v_adv_iss_cd      gicl_advice.iss_cd%TYPE;
   v_advice_year     gicl_advice.advice_year%TYPE;
   v_advice_seq_no   gicl_advice.advice_seq_no%TYPE;
BEGIN
   gicls032_get_set_res_amounts (p_claim_id,
                                 p_advice_id,
                                 p_selected_clm_loss,
                                 v_loss_set_amt,
                                 v_exp_set_amt,
                                 v_loss_res_amt,
                                 v_exp_res_amt
                                );

   SELECT line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no
     INTO v_line_cd, v_subline_cd, v_iss_cd, v_clm_yy, v_clm_seq_no
     FROM gicl_claims
    WHERE claim_id = p_claim_id;

   IF p_advice_id IS NOT NULL
   THEN
      SELECT line_cd, iss_cd, advice_year, advice_seq_no
        INTO v_adv_line_cd, v_adv_iss_cd, v_advice_year, v_advice_seq_no
        FROM gicl_advice
       WHERE claim_id = p_claim_id AND advice_id = p_advice_id;
   END IF;

   IF p_advice_id IS NOT NULL
   THEN
      SELECT COUNT (clm_loss_id)
        INTO v_no_of_expense
        FROM gicl_clm_loss_exp
       WHERE claim_id = p_claim_id AND advice_id = p_advice_id AND payee_type = 'E';

      SELECT COUNT (clm_loss_id)
        INTO v_no_of_loss
        FROM gicl_clm_loss_exp
       WHERE claim_id = p_claim_id AND advice_id = p_advice_id AND payee_type = 'L';
   ELSE
      SELECT COUNT (clm_loss_id)
        INTO v_no_of_expense
        FROM gicl_clm_loss_exp
       WHERE claim_id = p_claim_id AND advice_id IS NULL AND payee_type = 'E';

      SELECT COUNT (clm_loss_id)
        INTO v_no_of_loss
        FROM gicl_clm_loss_exp
       WHERE claim_id = p_claim_id AND advice_id IS NULL AND payee_type = 'L';
   END IF;

   IF v_disallow_pymt = 'Y'
   THEN
      IF v_no_of_expense > 0 AND v_no_of_loss > 0
      THEN
         IF v_loss_res_amt < v_loss_set_amt OR v_exp_res_amt < v_exp_set_amt
         THEN
            IF v_loss_res_amt < v_loss_set_amt AND v_exp_res_amt < v_exp_set_amt
            THEN
               v_msg := 'Unable to process settlement request. Settlement Amounts exceed Reserve Amounts.';
            ELSIF v_loss_res_amt < v_loss_set_amt
            THEN
               v_msg := 'Unable to process settlement request. Loss Settlement Amount exceeds Loss Reserve Amount.';
            ELSIF v_exp_res_amt < v_exp_set_amt
            THEN
               v_msg := 'Unable to process settlement request. Expense Settlement Amount exceeds Expense Reserve Amount.';
            END IF;
            
            raise_application_error (-20001, 'Geniisys Exception#I#Cannot Proceed to Approval of CSR. ' || v_msg);
         END IF;
      ELSIF v_no_of_loss > 0
      THEN
         IF v_loss_res_amt < v_loss_set_amt
         THEN
            v_msg := 'Unable to process settlement request. Loss Settlement Amount exceeds Loss Reserve Amount.';
            raise_application_error (-20001, 'Geniisys Exception#I#Cannot Proceed to Approval of CSR. ' || v_msg);
         END IF;
      ELSIF v_no_of_expense > 0
      THEN
         IF v_exp_res_amt < v_exp_set_amt
         THEN
            v_msg := 'Unable to process settlement request. Expense Settlement Amount exceeds Expense Reserve Amount.';
            raise_application_error (-20001, 'Geniisys Exception#I#Cannot Proceed to Approval of CSR. ' || v_msg);
         END IF;
      END IF;

      v_approve := 'Y';
   ELSIF v_disallow_pymt = 'O'
   THEN      
      v_function_code := 'RP';                                                            -- RAJI 06/03/2010 to indicate that the
      -- CHECK_ALERT was called from APPROVE RESERVE LESS THEN PAYMENT function
      v_reqapp := gicls032_check_request (p_claim_id, p_advice_id, v_function_code);

      IF check_user_override_function (giis_users_pkg.app_user, 'GICLS032', v_function_code) OR v_reqapp = 'Y'
      THEN
         v_approve := 'Y';
      ELSE
         IF v_no_of_expense > 0 AND v_no_of_loss > 0
         THEN
            IF v_loss_res_amt < v_loss_set_amt OR v_exp_res_amt < v_exp_set_amt
            THEN
               IF v_loss_res_amt < v_loss_set_amt AND v_exp_res_amt < v_exp_set_amt
               THEN
                  v_msg := 'Unable to process settlement request. Settlement Amounts exceed Reserve Amounts.';
               ELSIF v_loss_res_amt < v_loss_set_amt
               THEN
                  v_msg := 'Unable to process settlement request. Loss Settlement Amount exceeds Loss Reserve Amount.';
               ELSIF v_exp_res_amt < v_exp_set_amt
               THEN
                  v_msg := 'Unable to process settlement request. Expense Settlement Amount exceeds Expense Reserve Amount.';
               END IF;

               v_override := 'Y';
            END IF;
         ELSIF v_no_of_loss > 0
         THEN
            IF v_loss_res_amt < v_loss_set_amt
            THEN
               v_msg := 'Unable to process settlement request. Loss Settlement Amount exceeds Loss Reserve Amount.';
               v_override := 'Y';
            END IF;
         ELSIF v_no_of_expense > 0
         THEN
            IF v_exp_res_amt < v_exp_set_amt
            THEN
               v_msg := 'Unable to process settlement request. Expense Settlement Amount exceeds Expense Reserve Amount.';
               v_override := 'Y';
            END IF;
         END IF;

         --added by MAGeamoga 08/22/2011 to check for the approved override request in function code 'RP'
         IF p_advice_id IS NULL
         THEN
            v_check_id :=
                  'Claim no. : '
               || v_line_cd
               || '-'
               || v_subline_cd
               || '-'
               || v_iss_cd
               || '-'
               || LPAD (v_clm_yy, 2, 0)
               || '-'
               || LPAD (v_clm_seq_no, 7, 0);
         ELSE
            v_check_id := 'Advice Number : ' || v_line_cd || '-' || v_iss_cd || '-' || v_advice_year || v_advice_seq_no;
         END IF;

         FOR i IN (SELECT display
                     FROM gicl_function_override
                    WHERE line_cd = v_line_cd
                      AND iss_cd = v_iss_cd
                      AND module_id IN (SELECT module_id
                                          FROM giac_modules
                                         WHERE module_name = 'GICLS032')
                      AND function_cd = v_function_code
                      AND override_user IS NOT NULL
                      AND override_date IS NOT NULL
                      AND display LIKE '%' || v_check_id || '%')
         LOOP
            IF i.display IS NOT NULL
            THEN 
               v_override := 'N';
               EXIT;
            END IF;
         END LOOP;

         --IF v_override = 'Y' AND p_user_name IS NULL AND p_password IS NULL
         IF v_override = 'Y' AND p_user_name IS NULL
         THEN
            --raise_application_error (-20001, 'Geniisys Exception#CONFIRM_RP_OVERRIDE#' || v_msg || ' Would you like to override?');
            raise_application_error (-20001, 'Geniisys Exception#CONFIRM_RP_OVERRIDE#' || v_msg || ' What would you like to do?');
         ELSE
            IF p_ovr_app_csr = 'Y'
            THEN
               v_approve := 'Y';
            END IF;
         END IF;
      END IF;
   ELSIF v_disallow_pymt = 'N'
   THEN
      v_approve := 'Y';
   ELSE
      raise_application_error
                   (-20001,
                    'Geniisys Exception#I#Value of GIIS Parameter "DISALLOW RESERVE LESS THAN PAYMENT" not yet in this Database.'
                   );
   END IF;

   IF p_advice_id IS NOT NULL
   THEN                                                                                            --added by MAGeamoga 08/18/2011
      IF v_approve = 'Y'
      THEN
         UPDATE gicl_advice
            SET apprvd_tag = 'Y'
          WHERE advice_id = p_advice_id AND claim_id = p_claim_id;
      END IF;
   END IF;
END;
/


