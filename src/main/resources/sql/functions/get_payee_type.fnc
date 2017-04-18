DROP FUNCTION CPI.GET_PAYEE_TYPE;

CREATE OR REPLACE FUNCTION CPI.get_payee_type (p_claim_id NUMBER, p_clm_loss_id NUMBER)
RETURN VARCHAR2 AS
  v_payee_type  gicl_clm_loss_exp.payee_type%TYPE;
BEGIN
  FOR rec IN (SELECT payee_type
                FROM gicl_clm_loss_exp
               WHERE claim_id = p_claim_id
                 AND clm_loss_id = p_clm_loss_id)
  LOOP
    v_payee_type := rec.payee_type;
    EXIT;
  END LOOP;
  RETURN (v_payee_type);
END;
/


