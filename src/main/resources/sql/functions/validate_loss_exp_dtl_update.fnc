DROP FUNCTION CPI.VALIDATE_LOSS_EXP_DTL_UPDATE;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_LOSS_EXP_DTL_UPDATE
(p_claim_id     IN  GICL_CLAIMS.claim_id%TYPE,
 p_clm_loss_id  IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
 p_loss_exp_cd  IN  GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE )
 
 RETURN VARCHAR2 AS
 
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 02.16.2012
**  Reference By  : GICLS030 - Loss/Expense History
**  Description   : Validates if record has existing tax/es and/or deductible/s
**                  and return a message if any of those exists.
*/ 
 
  v_msg_alert        VARCHAR2(500);        
  v_ded_exist        VARCHAR2(1) := 'N'; -- determines if record has detail in gicl_loss_exp_ded_dtl
  v_tax_exist        VARCHAR2(1) := 'N'; -- determines if record has tax

 BEGIN
    v_tax_exist := GICL_LOSS_EXP_TAX_PKG.check_exist_loss_exp_tax_2(p_claim_id, p_clm_loss_id, p_loss_exp_cd);
    v_ded_exist := GICL_LOSS_EXP_DED_DTL_PKG.check_exist_loss_exp_ded_dtl(p_claim_id, p_clm_loss_id, p_loss_exp_cd);
    
    IF v_ded_exist = 'Y' AND v_tax_exist = 'N' THEN
        v_msg_alert := 'This record has deductible/s. Deductible/s under this loss/expense '||
                       'will be deleted. Do you want to continue?'; 
   
    ELSIF v_ded_exist = 'N' AND v_tax_exist = 'Y' THEN
        v_msg_alert := 'The history to which this detail is under already '||
                       'has Tax/es. Updating this record will delete the '||
                       'Tax/es. Do you want to continue?';
   
    ELSIF v_ded_exist = 'Y' AND v_tax_exist = 'Y' THEN
        v_msg_alert := 'The history to which this detail is under already '||
                       'has Tax/es and Deductible/s. Updating this record '||
                       'will delete the Tax/es and Deductible/s. '||
                       'Do you want to continue?';
    END IF; 
     
    RETURN v_msg_alert; 
    
 END validate_loss_exp_dtl_update;
/


