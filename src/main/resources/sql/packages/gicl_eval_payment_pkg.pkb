CREATE OR REPLACE PACKAGE BODY CPI.GICL_EVAL_PAYMENT_PKG AS
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.20.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Update the cancel_sw to 'Y' of GICL_EVAL_PAYMENT table
    */
    
    PROCEDURE cancel_eval_payment(p_claim_id       IN  GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                  p_clm_loss_id    IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    AS
    
    BEGIN
         UPDATE GICL_EVAL_PAYMENT
           SET cancel_sw = 'Y'
         WHERE claim_id = p_claim_id
           AND clm_loss_id = p_clm_loss_id;
           
    END cancel_eval_payment;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.06.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if records exist in GICL_EVAL_PAYMENT
    **                  with the given parameters
    */ 

    FUNCTION check_exist_eval_payment(p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                      p_clm_loss_id     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    RETURN VARCHAR2 AS
            
        v_exist   VARCHAR2(1) := 'N';

    BEGIN
        FOR dtl IN (SELECT 'Y' exist
                      FROM GICL_EVAL_PAYMENT
                     WHERE claim_id    = p_claim_id
                       AND clm_loss_id = p_clm_loss_id)
        LOOP
          v_exist := dtl.exist;
          EXIT;
        END LOOP;
                
        RETURN v_exist;
                
    END check_exist_eval_payment;
                                  
END GICL_EVAL_PAYMENT_PKG;
/


