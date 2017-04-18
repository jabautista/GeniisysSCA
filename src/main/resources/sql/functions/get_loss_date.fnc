DROP FUNCTION CPI.GET_LOSS_DATE;

CREATE OR REPLACE FUNCTION CPI.get_loss_date (p_clm_id gicl_claims.claim_id%TYPE)
  RETURN DATE AS

/*created by mon
**for sorting loss_date using claim_id
**in gicls266
*/
    CURSOR abc (p_clm_id gicl_claims.claim_id%TYPE) IS
    SELECT loss_date
      FROM gicl_claims
     WHERE claim_id = p_clm_id;
   v_loss_dt  gicl_claims.dsp_loss_date%TYPE;
BEGIN
  OPEN abc (p_clm_id);
  FETCH abc INTO v_loss_dt;
  IF abc%FOUND THEN
    CLOSE abc;
    RETURN v_loss_dt;
  ELSE
    CLOSE abc;
    RETURN NULL;
  END IF;
END;
/


