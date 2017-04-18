DROP FUNCTION CPI.GET_INTM_PREM;

CREATE OR REPLACE FUNCTION CPI.get_intm_prem (p_claim_id    gicl_claims.claim_id%TYPE)
  RETURN NUMBER IS
  v_total_prem        gicl_intm_itmperil.premium_amt%TYPE;
BEGIN
  FOR get_prem IN(
    SELECT NVL(SUM(premium_amt),0) prem_amt
      FROM gicl_intm_itmperil d
      WHERE d.claim_id = p_claim_id)
  LOOP
    IF get_prem.prem_amt <> 0 THEN
       v_total_prem := get_prem.prem_amt;
    ELSE
       v_total_prem := 1;
    END IF;
    EXIT;
  END LOOP;
  RETURN v_total_prem;
END;
/


