DROP FUNCTION CPI.GET_CLM_CLAIMANT_NO;

CREATE OR REPLACE FUNCTION CPI.get_clm_claimant_no
(p_claim_id          IN  GICL_CLAIMS.claim_id%TYPE,
 p_payee_class_cd    IN  GICL_LOSS_EXP_PAYEES.payee_class_cd%TYPE,
 p_payee_cd          IN  GICL_LOSS_EXP_PAYEES.payee_cd%TYPE )
 
 RETURN NUMBER AS
 
   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 02.07.2012
   **  Reference By  : GICLS030 - Loss/Recovery History
   **  Description   : Gets the next value of claimant no
   */ 
 
 v_clmnt_no      NUMBER := 0;
 
BEGIN
  FOR get_clmnt_no IN (
    SELECT clm_clmnt_no
      FROM GICL_CLM_CLAIMANT
     WHERE claim_id = p_claim_id
       AND payee_class_cd = p_payee_class_cd
       AND clmnt_no = p_payee_cd)
  LOOP
      v_clmnt_no := get_clmnt_no.clm_clmnt_no;
  END LOOP;
  
  IF v_clmnt_no = 0 THEN
       FOR get_max_clmnt_no IN( 
       SELECT NVL(MAX(clm_clmnt_no),0) clm_clmnt_no 
         FROM GICL_CLM_CLAIMANT 
        WHERE claim_id = p_claim_id)
     LOOP
          v_clmnt_no := get_max_clmnt_no.clm_clmnt_no;
     END LOOP;
     v_clmnt_no := v_clmnt_no + 1;
  END IF;
  
  RETURN v_clmnt_no;
END;
/


