DROP FUNCTION CPI.GET_ITEM_TITLE_DESC;

CREATE OR REPLACE FUNCTION CPI.get_item_title_desc
                           (p_claim_id  IN gicl_claims.claim_id%TYPE,
                            p_item_no IN gicl_clm_item.item_no%TYPE)
                  RETURN VARCHAR2 AS
v_title gicl_clm_item.item_title%TYPE;
BEGIN
  FOR rec IN (SELECT item_title
         FROM gicl_clm_item
        WHERE claim_id = p_claim_id
          AND item_no = p_item_no)
  LOOP
    v_title := rec.item_title;
    RETURN (v_title);
  END LOOP;
END;
/


