DROP FUNCTION CPI.GET_POL_SEQ_NO;

CREATE OR REPLACE FUNCTION CPI.get_pol_seq_no (p_clm_id gicl_claims.claim_id%TYPE)
  RETURN VARCHAR2 AS
/* this function is created for the purpose of sorting non-base item
** POL_SEQ_NO (GICLS043, c015 block, base table:gicl_advice) which
** is populated from gicl_claims.
** function does not work if created in form.
** created by Pia, 03/19/02 */
    CURSOR abc (p_clm_id gicl_claims.claim_id%TYPE) IS
    SELECT pol_seq_no
      FROM gicl_claims
     WHERE claim_id = p_clm_id;
   v_pol_seq  gicl_claims.pol_seq_no%TYPE;
BEGIN
  OPEN abc (p_clm_id);
  FETCH abc INTO v_pol_seq;
  IF abc%FOUND THEN
    CLOSE abc;
    RETURN v_pol_seq;
  ELSE
    CLOSE abc;
    RETURN NULL;
  END IF;
END;
/


