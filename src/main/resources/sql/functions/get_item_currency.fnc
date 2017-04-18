DROP FUNCTION CPI.GET_ITEM_CURRENCY;

CREATE OR REPLACE FUNCTION CPI.Get_Item_Currency (p_claim_id   IN gicl_clm_item.claim_id%TYPE,
                          p_item_no  IN gicl_clm_item.item_no%TYPE)
                  RETURN VARCHAR2 AS
/* created by judyann 11172003
** used in sorting records by currency code of claim item
*/
CURSOR c1 (p_claim_id  IN gicl_clm_item.claim_id%TYPE,
           p_item_no   IN gicl_clm_item.item_no%TYPE) IS

  SELECT currency_cd
    FROM gicl_clm_item
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no;

  p_currency_cd         gicl_clm_item.currency_cd%TYPE;

BEGIN
  OPEN c1 (p_claim_id, p_item_no);
  FETCH c1 INTO p_currency_cd;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_currency_cd;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/


