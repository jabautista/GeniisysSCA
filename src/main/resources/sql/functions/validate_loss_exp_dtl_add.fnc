DROP FUNCTION CPI.VALIDATE_LOSS_EXP_DTL_ADD;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_LOSS_EXP_DTL_ADD
(p_claim_id     IN  GICL_CLAIMS.claim_id%TYPE,
 p_clm_loss_id  IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
 p_loss_exp_cd  IN  GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE )
 
 RETURN VARCHAR2 AS
 
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 03.20.2012
**  Reference By  : GICLS030 - Loss/Expense History
**  Description   : Validates if record has existing tax/es and/or deductible = '%ALL%'
**                  and return a message if any of those exists.
*/ 
 
  v_msg_alert        VARCHAR2(500);        
  v_ded_all_exist    VARCHAR2(1) := 'N'; -- determines if record deductible= '%ALL%'
  v_tax_exist        VARCHAR2(1) := 'N'; -- determines if record has tax

 BEGIN
    v_tax_exist := GICL_LOSS_EXP_TAX_PKG.check_exist_loss_exp_tax_2(p_claim_id, p_clm_loss_id, p_loss_exp_cd);
    v_ded_all_exist := GICL_LOSS_EXP_DTL_PKG.check_exist_ded_equals_all(p_claim_id, p_clm_loss_id);
    
    IF v_ded_all_exist = 'Y'THEN
        v_msg_alert := 'This history has a posted deductible which will supposedly apply to all loss/expense details saved. '||
                       'Adding another detail would mean deleting the deductible upon saving. Do you want to continue?'; 
   
    ELSIF v_tax_exist = 'Y' THEN
        v_msg_alert := 'The history to which this detail would be under already '||
                       'has Tax/es. Adding another detail would mean deleting the Tax/es upon saving. '||
                       'Do you want to continue? ';
    END IF; 
     
    RETURN v_msg_alert; 
    
 END validate_loss_exp_dtl_add;
/


