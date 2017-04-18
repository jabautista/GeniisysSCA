DROP PROCEDURE CPI.GICLS032_INITIALIZE;

CREATE OR REPLACE PROCEDURE CPI.gicls032_initialize (
  p_claim_id gicl_advice.claim_id%TYPE,
  p_variables OUT GICL_ADVICE_PKG.GICLS032_VARIABLES 
) IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - initialize
   */
   
   v_pol_iss_cd             gicl_claims.pol_iss_cd%TYPE;    
BEGIN    
   p_variables.v_ri_iss_cd := giacp.v ('RI_ISS_CD');
   p_variables.v_separate_booking := giacp.v('SEPARATE_BOOKING_OF_TAXABLE_LOSS');
   p_variables.v_local_currency := giacp.n('CURRENCY_CD');
   
   SELECT pol_iss_cd
     INTO v_pol_iss_cd
     FROM gicl_claims
    WHERE claim_id = p_claim_id;

   BEGIN
      SELECT param_value_n
        INTO p_variables.v_claim_sl_cd
        FROM giac_parameters
       WHERE param_name = 'CLAIMS_SL_CD';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing CLAIMS_SL_CD parameter on GIAC_PARAMETERS.');
         p_variables.v_claim_sl_cd := 2;
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_assd_sl_type
        FROM giac_parameters
       WHERE param_name = 'ASSD_SL_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing ASSD_SL_TYPE parameter on GIAC_PARAMETERS.');
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_ri_sl_type
        FROM giac_parameters
       WHERE param_name = 'RI_SL_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing RI_SL_TYPE parameter on GIAC_PARAMETERS.');
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_line_sl_type
        FROM giac_parameters
       WHERE param_name = 'LINE_SL_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing LINE_SL_TYPE parameter on GIAC_PARAMETERS.');
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_intm_sl_type
        FROM giac_parameters
       WHERE param_name = 'INTM_SL_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing INTM_SL_TYPE parameter on GIAC_PARAMETERS.');
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_adj_sl_type
        FROM giac_parameters
       WHERE param_name = 'ADJ_SL_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing ADJ_SL_TYPE parameter on GIAC_PARAMETERS.');
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_lawyer_sl_type
        FROM giac_parameters
       WHERE param_name = 'LAWYER_SL_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing LAWYER_SL_TYPE parameter on GIAC_PARAMETERS.');
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_motshop_sl_type
        FROM giac_parameters
       WHERE param_name = 'MOTSHOP_SL_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing MOTSHOP_SL_TYPE parameter on GIAC_PARAMETERS.');
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_branch_sl_type
        FROM giac_parameters
       WHERE param_name = 'BRANCH_SL_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing BRANCH_SL_TYPE parameter on GIAC_PARAMETERS.');
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_lsp_sl_type
        FROM giac_parameters
       WHERE param_name = 'LSP_SL_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing LSP_SL_TYPE parameter on GIAC_PARAMETERS.');
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_trty_shr_type
        FROM giac_parameters
       WHERE param_name = 'TRTY_SHARE_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing TRTY_SHARE_TYPE parameter on GIAC_PARAMETERS.');
         p_variables.v_trty_shr_type := 2;
   END;

   --BETH 03232004
   --     parameter for XOL treaty share type
   BEGIN
      SELECT param_value_v
        INTO p_variables.v_xol_shr_type
        FROM giac_parameters
       WHERE param_name = 'XOL_TRTY_SHARE_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing XOL_TRTY_SHARE_TYPE parameter on GIAC_PARAMETERS.');
         p_variables.v_xol_shr_type := 4;
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_facul_shr_type
        FROM giac_parameters
       WHERE param_name = 'FACUL_SHARE_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing FACUL_SHARE_TYPE parameter on GIAC_PARAMETERS.');
         p_variables.v_facul_shr_type := 3;
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_exp_payee_type
        FROM giac_parameters
       WHERE param_name = 'CLM_EXP_PAYEE_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing CLM_EXP_PAYEE_TYPE parameter on GIAC_PARAMETERS.');
         p_variables.v_exp_payee_type := 'E';
   END;

   BEGIN
      SELECT param_value_v
        INTO p_variables.v_loss_payee_type
        FROM giac_parameters
       WHERE param_name = 'CLM_LOSS_PAYEE_TYPE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing CLM_LOSS_PAYEE_TYPE parameter on GIAC_PARAMETERS.');
         p_variables.v_loss_payee_type := 'E';
   END;

/*
  ** use module entries for GIACS017 for direct claim payts and
  ** GIACS018 for inward transactions
  */
   IF v_pol_iss_cd = p_variables.v_ri_iss_cd
   THEN                                                                                                 --:c003.iss_cd = 'RI' THEN
      p_variables.v_module_name := 'GIACS018';
   ELSE
      p_variables.v_module_name := 'GIACS017';
   END IF;

   BEGIN
      SELECT module_id, generation_type
        INTO p_variables.v_module_id, p_variables.v_gen_type
        FROM giac_modules
       WHERE module_name = p_variables.v_module_name;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         gicl_advice_pkg.revert_advice (p_claim_id);
         raise_application_error (-20001, 'Geniisys Exception#I#No data found in GIAC MODULES.');
   END;

   /* validate if the booking amount for Losses Paid will be the Net Retention Amount */
   BEGIN
      SELECT param_value_v
        INTO p_variables.v_cur_name
        FROM giac_parameters
       WHERE param_name = 'CLM_NET_RET_TAG';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing CLM_NET_RET_TAG parameter on GIAC_PARAMETERS.');
         p_variables.v_cur_name := 'N';
   END;
   
   /* added by juday 09272004
   ** check if RI recoverable entries will be separated for losses and expenses */
   BEGIN
      SELECT param_value_v
        INTO p_variables.v_ri_recov
        FROM giac_parameters
       WHERE param_name = 'SEPARATE_RI_RECOV';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing SEPARATE_RI_RECOV parameter on GIAC_PARAMETERS.');
         p_variables.v_ri_recov := 'N';
   END;

   BEGIN
      SELECT param_value_n
        INTO p_variables.v_setup
        FROM giac_parameters
       WHERE param_name = 'OS_BATCH_TAKEUP';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No OS_BATCH_TAKEUP parameter found in giac_parameters.');
   END;

   IF p_variables.v_setup = 2
   THEN
      BEGIN
         SELECT param_value_v
           INTO p_variables.v_param
           FROM giac_parameters
          WHERE param_name = 'OS_EXP_BOOKING';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20001, 'Geniisys Exception#I#No OS_EXP_BOOKING parameter found in GIAC_PARAMETERS.');
      END;

      BEGIN
         SELECT module_id
           INTO p_variables.os_module_id
           FROM giac_modules
          WHERE module_name = 'GICLB001';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20001, 'Geniisys Exception#I#No data found in GIAC MODULES.');
      END;

      BEGIN
         SELECT gl_acct_category
           INTO p_variables.v_gl_acct_ctgry
           FROM giac_module_entries
          WHERE module_id = p_variables.os_module_id AND item_no = 2;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
--      msg_alert('No expense setup in giac_module_entries.','I',FALSE);
            IF p_variables.v_param = 'Y'
            THEN
               p_variables.v_gl_acct_ctgry := 0;
            END IF;
      END;
   END IF;

   -- added by A.R.C. 02.10.2005
   BEGIN
      SELECT param_value_v
        INTO p_variables.v_separate_xol_entries
        FROM giac_parameters
       WHERE param_name = 'SEPARATE_XOL_ENTRIES';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#I#No existing SEPARATE_XOL_ENTRIES parameter on GIAC_PARAMETERS.');
   END;
END;
/


