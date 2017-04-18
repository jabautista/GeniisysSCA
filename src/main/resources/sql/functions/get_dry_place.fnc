DROP FUNCTION CPI.GET_DRY_PLACE;

CREATE OR REPLACE FUNCTION CPI.Get_Dry_Place (p_claim_id IN GICL_CLAIMS.claim_id%TYPE)
          RETURN VARCHAR2 AS
/* created by Pia, 07.04.02
** return dry_date from gicl_hull_dtl */
CURSOR c1 (p_claim_id   IN GICL_CLAIMS.claim_id%TYPE) IS
   SELECT dry_place
     FROM GICL_HULL_DTL
    WHERE claim_id  = p_claim_id;
 p_dry_place  GICL_HULL_DTL.dry_place%TYPE;
BEGIN
  OPEN c1 (p_claim_id);
  FETCH c1 INTO p_dry_place;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_dry_place;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/


