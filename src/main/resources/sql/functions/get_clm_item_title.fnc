DROP FUNCTION CPI.GET_CLM_ITEM_TITLE;

CREATE OR REPLACE FUNCTION CPI.Get_Clm_Item_Title (p_claim_id   IN GICL_CLAIMS.claim_id%TYPE)
         RETURN VARCHAR2 AS
/* created by Pia, 07.04.02
** return item_title from gicl_clm_item
** function restricted to Claims since parameter used is claim_id */
CURSOR c1 (p_claim_id   IN GICL_CLAIMS.claim_id%TYPE) IS
   SELECT item_title
     FROM GICL_CLM_ITEM
    WHERE claim_id  = p_claim_id;
 p_item_title  GICL_CLM_ITEM.item_title%TYPE;
BEGIN
  OPEN c1 (p_claim_id);
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


