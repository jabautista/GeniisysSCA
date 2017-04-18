CREATE OR REPLACE PACKAGE CPI.GICL_EVAL_PAYMENT_PKG AS
    
    PROCEDURE cancel_eval_payment(p_claim_id       IN  GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                  p_clm_loss_id    IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE);
                                  
    FUNCTION check_exist_eval_payment(p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                      p_clm_loss_id     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    RETURN VARCHAR2;
                                  
END GICL_EVAL_PAYMENT_PKG;
/


