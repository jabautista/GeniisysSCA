DROP PROCEDURE CPI.NEGATE_LOSS_EXP_HISTORY;

CREATE OR REPLACE PROCEDURE CPI.negate_loss_exp_history
(p_claim_id         IN  GICL_CLAIMS.claim_id%TYPE,
 p_clm_loss_id      IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
 p_payee_class_cd   IN  GICL_lOSS_EXP_PAYEES.payee_class_cd%TYPE,
 p_payee_cd         IN  GICL_lOSS_EXP_PAYEES.payee_cd%TYPE) IS
 
/*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 02.29.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Negates the distributed Loss Expense History record
 **                  
 */

BEGIN

    UPDATE GICL_CLM_LOSS_EXP
       SET dist_sw     = 'N'
     WHERE claim_id    = p_claim_id
       AND clm_loss_id = p_clm_loss_id; 
     
    UPDATE GICL_LOSS_EXP_DS
       SET negate_tag  = 'Y'
     WHERE claim_id    = p_claim_id
       AND clm_loss_id = p_clm_loss_id; 
         
    UPDATE GICL_EVAL_LOA
      SET cancel_sw = 'Y'
    WHERE claim_id = p_claim_id
      AND clm_loss_id = p_clm_loss_id 
      AND payee_type_cd = p_payee_class_cd
      AND payee_cd = p_payee_cd;
                                          
    UPDATE GICL_EVAL_CSL
      SET cancel_sw = 'Y'
    WHERE claim_id = p_claim_id
      AND clm_loss_id = p_clm_loss_id 
      AND payee_type_cd = p_payee_class_cd
      AND payee_cd = p_payee_cd;
      
END negate_loss_exp_history;
/


