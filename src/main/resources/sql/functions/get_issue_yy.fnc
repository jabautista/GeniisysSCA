DROP FUNCTION CPI.GET_ISSUE_YY;

CREATE OR REPLACE FUNCTION CPI.get_issue_yy (p_clm_id gicl_claims.claim_id%TYPE)
  RETURN VARCHAR2 AS
/* this function is created for the purpose of sorting non-base item
** ISSUE_YY (GICLS043, c015 block, base table:gicl_advice) which
** is populated from gicl_claims.
** function does not work if created in form.
** created by Pia, 03/19/02 */
    CURSOR abc (p_clm_id gicl_claims.claim_id%TYPE) IS
    SELECT issue_yy
      FROM gicl_claims
     WHERE claim_id = p_clm_id;
   v_iss_yy  gicl_claims.issue_yy%TYPE;
BEGIN
  OPEN abc (p_clm_id);
  FETCH abc INTO v_iss_yy;
  IF abc%FOUND THEN
    CLOSE abc;
    RETURN v_iss_yy;
  ELSE
    CLOSE abc;
    RETURN NULL;
  END IF;
END;
/


