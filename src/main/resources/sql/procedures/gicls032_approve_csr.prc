DROP PROCEDURE CPI.GICLS032_APPROVE_CSR;

CREATE OR REPLACE PROCEDURE CPI.gicls032_approve_csr (
   p_claim_id        gicl_advice.claim_id%TYPE,
   p_advice_id       gicl_advice.advice_id%TYPE,
   p_ac_user_name    VARCHAR2,
   p_rp_user_name    VARCHAR2
)
IS
/**
  * Created by: Andrew Robes
  * Date created: 03.28.2012
  * Referenced by : (GICLS032 - Generate Advice)
  * Description : Converted procedure from gicls032 - approve_csr
  */
  
   v_exist           VARCHAR2 (1);
   v_reqapp          VARCHAR2 (1)    := 'N';
   v_loss_set_amt    NUMBER          := 0;
   v_exp_set_amt     NUMBER          := 0;
   v_loss_res_amt    NUMBER          := 0;
   v_exp_res_amt     NUMBER          := 0;
   v_msg             VARCHAR2 (200)  := ' ';
   v_request         NUMBER;
   v_function_code   VARCHAR2 (2);
   v_columns         VARCHAR2 (1000);
   v_no_of_expense   NUMBER;
   v_no_of_loss      NUMBER;
   v_ovr_app_csr     VARCHAR2(1);
BEGIN

  SELECT COUNT(clm_loss_id)
    INTO v_no_of_expense
    FROM gicl_clm_loss_exp
   WHERE claim_id = p_claim_id
     AND advice_id = p_advice_id             
     AND payee_type = 'E';
      
  SELECT COUNT(clm_loss_id)
    INTO v_no_of_loss
    FROM gicl_clm_loss_exp
   WHERE claim_id = p_claim_id
     AND advice_id = p_advice_id             
     AND payee_type = 'L';

   gicls032_get_set_res_amounts (p_claim_id,
                                 p_advice_id,
                                 NULL,
                                 v_loss_set_amt,                                                                     -- OUT NUMBER
                                 v_exp_set_amt,                                                                       --OUT NUMBER
                                 v_loss_res_amt,                                                                      --OUT NUMBER
                                 v_exp_res_amt                                                                        --OUT NUMBER
                                );
   v_function_code := 'AC';                                                                -- RAJI 06/03/2010 to indicate that the
   -- CHECK_ALERT was called from APPROVE CSR function
   v_reqapp := gicls032_check_request (p_claim_id, p_advice_id, v_function_code);          -- check request of for approval of csr
   /* Added by Marlo
   ** 10072010
   ** To reset the variable v_columns and set the new value*/
   v_columns := NULL;

   FOR i IN (SELECT function_col_cd, table_name, column_name
               FROM giac_function_columns
              WHERE module_id IN (SELECT module_id
                                    FROM giac_modules
                                   WHERE module_name = 'GICLS032') AND function_cd = v_function_code)
   LOOP
      IF i.table_name = 'GICL_ADVICE' AND i.column_name = 'CLAIM_ID'
      THEN
         v_columns := override.generate_p_column (v_columns, i.function_col_cd, p_claim_id);
      ELSIF i.table_name = 'GICL_ADVICE' AND i.column_name = 'ADVICE_ID'
      THEN
         v_columns := override.generate_p_column (v_columns, i.function_col_cd, p_advice_id);
      END IF;
   END LOOP;

   --end of modifications 10072010 
   --giac_user_functions_pkg.check_ovr_csr (NVL(giis_users_pkg.app_user, USER) changed dahil ang check parin nya is ung original user at hindi ung nag override - irwin 6.29.2012
   IF giac_user_functions_pkg.check_ovr_csr (NVL(p_ac_user_name,giis_users_pkg.app_user)) OR                                                                 -- user has the right to approve csr
                             NVL (giacp.v ('OVERRIDE_APPROVE_CSR'), 'N') = 'N' OR v_reqapp = 'Y'
   THEN                                                             -- existing request for the current advise is already approved
      --for overide      
      v_ovr_app_csr := 'Y';
      gicls032_check_sl_type_cd(p_claim_id, p_advice_id);
      gicls032_check_set_res_amount(p_claim_id, p_advice_id, null, v_ovr_app_csr, p_rp_user_name);
   ELSE
      v_ovr_app_csr := 'N';
 
      IF giisp.v ('DISALLOW RESERVE LESS THAN PAYMENT') = 'Y'
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
               raise_application_error (-20001, 'Geniisys Exception#I#Cannot Proceed to Approval of CSR. ');
            END IF;
         ELSIF v_no_of_expense > 0
         THEN
            IF v_exp_res_amt < v_exp_set_amt
            THEN
               v_msg := 'Unable to process settlement request. Expense Settlement Amount exceeds Expense Reserve Amount.';
               raise_application_error (-20001, 'Geniisys Exception#I#Cannot Proceed to Approval of CSR. ' || v_msg);
            END IF;
         END IF;
      END IF;
      
      --raise_application_error (-20001, 'Geniisys Exception#CONFIRM_AC_OVERRIDE#User is not allowed to approve CSR. Would you like to override?');
      raise_application_error (-20001, 'Geniisys Exception#CONFIRM_AC_OVERRIDE#User is not allowed to approve CSR. What would you like to do?');
   END IF;      
END;
/


