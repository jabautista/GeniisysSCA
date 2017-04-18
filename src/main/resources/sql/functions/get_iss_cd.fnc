DROP FUNCTION CPI.GET_ISS_CD;

CREATE OR REPLACE FUNCTION CPI.Get_Iss_Cd (p_clm_id gicl_claims.claim_id%TYPE)
  RETURN VARCHAR2 AS
/* this function is created for the purpose of sorting non-base item
** ISS_CD (GICLS043, c015 block, base table:gicl_advice) which
** is populated from gicl_claims, using_claim_id.
** function does not work if created in form.
** created by Pia, 03/19/02 */
    CURSOR abc (p_clm_id gicl_claims.claim_id%TYPE) IS
    SELECT iss_cd
      FROM gicl_claims
     WHERE claim_id = p_clm_id;
   v_iss  gicl_claims.iss_cd%TYPE;
BEGIN
  OPEN abc (p_clm_id);
  FETCH abc INTO v_iss;
  IF abc%FOUND THEN
    CLOSE abc;
    RETURN v_iss;
  ELSE
    CLOSE abc;
    RETURN NULL;
  END IF;
END;
/


