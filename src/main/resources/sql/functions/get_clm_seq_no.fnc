DROP FUNCTION CPI.GET_CLM_SEQ_NO;

CREATE OR REPLACE FUNCTION CPI.Get_Clm_Seq_No (p_clm_id gicl_claims.claim_id%TYPE)
  RETURN VARCHAR2 AS
/* this function is created for the purpose of sorting non-base item
** CLM_SEQ_NO (GICLS043, c015 block, base table:gicl_advice) which
** is populated from gicl_claims, using_claim_id.
** function does not work if created in form.
** created by Pia, 03/19/02 */
    CURSOR abc (p_clm_id gicl_claims.claim_id%TYPE) IS
    SELECT clm_seq_no
      FROM gicl_claims
     WHERE claim_id = p_clm_id;
   v_clm_seq  gicl_claims.clm_seq_no%TYPE;
BEGIN
  OPEN abc (p_clm_id);
  FETCH abc INTO v_clm_seq;
  IF abc%FOUND THEN
    CLOSE abc;
    RETURN v_clm_seq;
  ELSE
    CLOSE abc;
    RETURN NULL;
  END IF;
END;
/


