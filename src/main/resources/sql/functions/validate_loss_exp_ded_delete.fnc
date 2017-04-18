DROP FUNCTION CPI.VALIDATE_LOSS_EXP_DED_DELETE;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_LOSS_EXP_DED_DELETE
(p_claim_id         IN  GICL_CLAIMS.claim_id%TYPE,
 p_clm_loss_id      IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
 p_ded_loss_exp_cd  IN  GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE)
 
 RETURN VARCHAR2 AS
 
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 03.30.2012
**  Reference By  : GICLS030 - Loss/Expense History
**  Description   : Validates if loss expense deductible record  
**                  has existing tax/es and return a message if exists.
*/ 
 
  v_msg_alert    VARCHAR2(500);
  v_cnt          NUMBER(5);          -- determines if record has tax
 
 BEGIN
    v_cnt := GICL_LOSS_EXP_TAX_PKG.get_count_loss_exp_tax_2(p_claim_id, p_clm_loss_id, p_ded_loss_exp_cd);
    
    IF v_cnt > 0 THEN
        v_msg_alert := 'The detail to which this deductible is attached has tax/es. '||
        	           'Updating this record will delete the tax/es. Do you want to continue?';
        
    ELSE 
        v_msg_alert := 'Deleting this record will mean removing the deductible from the loss/expense(s) '||
                       'to which the deductible applies, and having it permanently posted. ' ||
                       'Do you want to continue?';
    END IF;
     
     RETURN v_msg_alert; 
    
 END VALIDATE_LOSS_EXP_DED_DELETE;
/


