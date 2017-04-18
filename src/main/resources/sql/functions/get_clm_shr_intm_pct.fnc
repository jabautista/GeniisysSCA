DROP FUNCTION CPI.GET_CLM_SHR_INTM_PCT;

CREATE OR REPLACE FUNCTION CPI.get_clm_shr_intm_pct (p_claim_id   IN gicl_claims.claim_id%TYPE)
RETURN NUMBER AS
/* created by MON, 10.25.02
** return item_title from gicl_clm_item
** function restricted to Claims since parameter used is claim_id */
CURSOR c1 (p_claim_id   IN gicl_claims.claim_id%TYPE) IS
   SELECT shr_intm_pct shr
             FROM gicl_intm_itmperil
            WHERE claim_id = p_claim_id;
 p_shr_intm_pct  gicl_intm_itmperil.shr_intm_pct%TYPE;
BEGIN
  OPEN c1 (p_claim_id);
  FETCH c1 INTO p_shr_intm_pct ;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_shr_intm_pct  ;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/


