DROP PROCEDURE CPI.GICLS032_MISC_UW_ENTRIES;

CREATE OR REPLACE PROCEDURE CPI.gicls032_misc_uw_entries (
   p_claim_id          gicl_advice.claim_id%TYPE,
   p_advice_id         gicl_advice.advice_id%TYPE,
   p_variables          gicl_advice_pkg.gicls032_variables,
   misc_amt            giac_acct_entries.debit_amt%TYPE,
   ms_payee_class_cd   gicl_clm_loss_exp.payee_class_cd%TYPE,
   ms_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - misc_uw_entries
   */
   ws_sl_cd   giac_sl_lists.sl_cd%TYPE;
BEGIN
   BEGIN
      SELECT param_value_n
        INTO ws_sl_cd
        FROM giac_parameters
       WHERE param_name = 'CLAIMS_DEPARTMENT';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#There is no existing CLAIMS_DEPARTMENT parameter in GIAC_PARAMETERS table. Contact your DBA.');         
   END;

   IF misc_amt > 0
   THEN
      gicls032_aeg_create_acct_ent (p_claim_id,
                                    p_advice_id,
                                    p_variables,
                                    ws_sl_cd,
                                    p_variables.v_module_id,
                                    11,
                                    NULL,
                                    NULL,
                                    misc_amt,
                                    ms_payee_class_cd,
                                    ms_payee_cd,
                                    p_variables.v_gen_type,
                                    NULL
                                   );
   ELSE
      gicls032_aeg_create_acct_ent (p_claim_id,
                                    p_advice_id,
                                    p_variables,
                                    ws_sl_cd,
                                    p_variables.v_module_id,
                                    12,
                                    NULL,
                                    NULL,
                                    misc_amt * -1,
                                    ms_payee_class_cd,
                                    ms_payee_cd,
                                    p_variables.v_gen_type,
                                    NULL
                                   );
   END IF;
END;
/


