DROP FUNCTION CPI.GET_CLM_ITEM_TITLE2;

CREATE OR REPLACE FUNCTION CPI.get_clm_item_title2 (p_claim_id   IN gicl_claims.claim_id%TYPE,
			                                    p_item_no    IN gicl_clm_item.item_no%TYPE)
RETURN VARCHAR2 AS
/* created by MON, 10.25.02
** return item_title from gicl_clm_item
** function restricted to Claims since parameter used is claim_id */
CURSOR c1 (p_claim_id   IN gicl_claims.claim_id%TYPE,
           p_item_no IN gicl_clm_item.item_no%TYPE) IS
   SELECT item_title
     FROM gicl_clm_item
    WHERE claim_id  = p_claim_id
      AND item_no = p_item_no;

 p_item_title  gicl_clm_item.item_title%TYPE;

BEGIN
  OPEN c1 (p_claim_id, p_item_no);
  FETCH c1 INTO p_item_title;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_item_title;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/


