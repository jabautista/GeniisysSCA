DROP FUNCTION CPI.VALIDATE_LOSS_EXP_DTL_DELETE;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_LOSS_EXP_DTL_DELETE
(p_claim_id     IN  GICL_CLAIMS.claim_id%TYPE,
 p_clm_loss_id  IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
 p_loss_exp_cd  IN  GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE )
 
 RETURN VARCHAR2 AS
 
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 02.14.2012
**  Reference By  : GICLS030 - Loss/Expense History
**  Description   : Validates if record has existing tax/es and/or deductible/s
**                  and return a message if any of those exists.
*/ 
 
  v_msg_alert    VARCHAR2(500);
  v_cnt          NUMBER(5);          -- determines if record has tax
  v_exist        VARCHAR2(1) := 'N'; -- determines if record has detail in gicl_loss_exp_ded_dtl
 
 BEGIN
    v_cnt := GICL_LOSS_EXP_TAX_PKG.get_count_loss_exp_tax(p_claim_id, p_clm_loss_id);
    v_exist := GICL_LOSS_EXP_DED_DTL_PKG.check_exist_loss_exp_ded_dtl(p_claim_id, p_clm_loss_id, p_loss_exp_cd);
    
    IF v_cnt > 0 AND v_exist = 'N' THEN
        v_msg_alert := 'Tax for this detail already exists. Deleting this detail would also '||
                       'mean deleting the tax. Do you want to continue?';
        
     ELSIF v_cnt > 0 AND v_exist = 'Y' THEN
        v_msg_alert := 'Tax and Deductible for this detail already exist. '||
                       'Deleting this detail would also '||
                       'mean deleting the tax and the deductible.'||CHR(10)||
                       'Do you want to continue?';
        
     ELSIF v_cnt = 0 AND v_exist = 'Y' THEN 
        v_msg_alert := 'This record has deductible/s. Deductible/s under this loss/expense '||
                       'will be deleted. Do you want to continue?';
     END IF;
     
     RETURN v_msg_alert; 
    
 END validate_loss_exp_dtl_delete;
/


