CREATE OR REPLACE PACKAGE CPI.override_pkg
IS
   PROCEDURE create_history (  --insert record in table GICL_OVERRIDE_HISTORY
      p_claim_id          gicl_override_history.claim_id%TYPE,
      p_user_id           gicl_override_history.user_id%TYPE,
      p_overriding_user   gicl_override_history.override_user_id%TYPE,
      p_module_id         gicl_override_history.module_id%TYPE,
      p_function_code     gicl_override_history.function_code%TYPE
   );

   FUNCTION get_max_override_hist ( --get maximum history number per claim
      p_claim_id   gicl_override_history.claim_id%TYPE
   )                                  
      RETURN NUMBER;

   FUNCTION get_ri_share_in_reserve ( --get RI Share amount in reserve of the current item peril 
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE,
      p_item_no           gicl_clm_res_hist.item_no%TYPE,
      p_peril_cd          gicl_clm_res_hist.peril_cd%TYPE,
      p_loss_reserve      gicl_clm_res_hist.loss_reserve%TYPE,
      p_expense_reserve   gicl_clm_res_hist.expense_reserve%TYPE
   )
      RETURN NUMBER;
   
   FUNCTION get_other_ri_reserve ( --get RI Share amount of other item peril in same claim
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE,
      p_item_no           gicl_clm_res_hist.item_no%TYPE,
      p_grouped_item_no   gicl_clm_res_hist.grouped_item_no%TYPE,
      p_peril_cd          gicl_clm_res_hist.peril_cd%TYPE  
   )   
      RETURN NUMBER;
      
   FUNCTION validate_ri_reserve ( --check reserve amounts and parameter if valid
      p_user_id           gicl_clm_res_hist.user_id%TYPE,
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE,
      p_item_no           gicl_clm_res_hist.item_no%TYPE,
      p_grouped_item_no   gicl_clm_res_hist.grouped_item_no%TYPE,
      p_peril_cd          gicl_clm_res_hist.peril_cd%TYPE,
      p_loss_reserve      gicl_clm_res_hist.loss_reserve%TYPE,
      p_expense_reserve   gicl_clm_res_hist.expense_reserve%TYPE
   )
      RETURN VARCHAR2;
      
   FUNCTION get_ri_share_in_settlement ( --get RI Share amount in settlement of the current item peril 
      p_claim_id          gicl_clm_loss_exp.claim_id%TYPE,
      p_clm_loss_id       gicl_clm_loss_exp.clm_loss_id%TYPE
   )
      RETURN NUMBER;
   
   FUNCTION get_other_ri_settlement ( --get RI Share amount of other item peril in same claim
      p_claim_id          gicl_clm_loss_exp.claim_id%TYPE,
      p_clm_loss_id       gicl_clm_loss_exp.clm_loss_id%TYPE  
   )   
      RETURN NUMBER;
      
   FUNCTION validate_ri_settlement ( --check settlement amounts and parameter if valid
      p_user_id           gicl_clm_loss_exp.user_id%TYPE,
      p_claim_id          gicl_clm_loss_exp.claim_id%TYPE,
      p_clm_loss_id       gicl_clm_loss_exp.clm_loss_id%TYPE
   )
      RETURN VARCHAR2;   
      
   PROCEDURE check_request ( --check override request per claim
      p_module_name       giac_modules.module_name%TYPE,
      p_function_cd       gicl_function_override.function_cd%TYPE,
      p_claim_id          gicl_function_override_dtl.function_col_val%TYPE,
      p_request_status    OUT NUMBER,
      p_user_id           OUT gicl_function_override.override_user%TYPE
   );  
      
   PROCEDURE update_ri_stat ( --procedure to update RI Stat in Claim Basic Information if distribution includes share type 2,3,or 4
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE
   );
   
   PROCEDURE create_request_override ( --procedure to create override request
      p_module_name       giac_modules.module_name%TYPE,
      p_function_cd       gicl_function_override.function_cd%TYPE,
      p_claim_id          gicl_function_override_dtl.function_col_val%TYPE,
      p_user_id           gicl_function_override.override_user%TYPE,
      p_remarks           gicl_function_override.remarks%TYPE
   );
      
END override_pkg;
/


