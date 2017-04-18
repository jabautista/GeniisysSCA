DROP FUNCTION CPI.GET_RENEW_NO;

CREATE OR REPLACE FUNCTION CPI.get_renew_no (p_clm_id gicl_claims.claim_id%TYPE)
  RETURN VARCHAR2 AS
/* this function is created for the purpose of sorting non-base item
** RENEW_NO (GICLS043, c015 block, base table:gicl_advice) which
** is populated from gicl_claims.
** function does not work if created in form.
** created by Pia, 03/19/02 */
    CURSOR abc (p_clm_id gicl_claims.claim_id%TYPE) IS
    SELECT renew_no
      FROM gicl_claims
     WHERE claim_id = p_clm_id;
   v_renew_no  gicl_claims.renew_no%TYPE;
BEGIN
  OPEN abc (p_clm_id);
  FETCH abc INTO v_renew_no;
  IF abc%FOUND THEN
    CLOSE abc;
    RETURN v_renew_no;
  ELSE
    CLOSE abc;
    RETURN NULL;
  END IF;
END;
/


