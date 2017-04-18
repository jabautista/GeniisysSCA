DROP FUNCTION CPI.GET_CLM_YY;

CREATE OR REPLACE FUNCTION CPI.Get_Clm_Yy (p_clm_id gicl_claims.claim_id%TYPE)
  RETURN VARCHAR2 AS
/* this function is created for the purpose of sorting non-base item
** CLM_YY (GICLS043, c015 block, base table:gicl_advice) which
** is populated from gicl_claims, using_claim_id.
** function does not work if created in form.
** created by Pia, 03/19/02 */
    CURSOR abc (p_clm_id gicl_claims.claim_id%TYPE) IS
    SELECT clm_yy
      FROM gicl_claims
     WHERE claim_id = p_clm_id;
   v_cyy  gicl_claims.clm_yy%TYPE;
BEGIN
  OPEN abc (p_clm_id);
  FETCH abc INTO v_cyy;
  IF abc%FOUND THEN
    CLOSE abc;
    RETURN v_cyy;
  ELSE
    CLOSE abc;
    RETURN NULL;
  END IF;
END;
/


