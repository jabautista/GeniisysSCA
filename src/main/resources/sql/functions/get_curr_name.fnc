DROP FUNCTION CPI.GET_CURR_NAME;

CREATE OR REPLACE FUNCTION CPI.get_curr_name (p_claim_id gicl_item_peril.claim_id%TYPE,
                                          p_item_no gicl_item_peril.item_no%TYPE)
  RETURN VARCHAR2 IS
  v_curr_name        giis_currency.currency_desc%TYPE;
BEGIN
  FOR rec IN(
    SELECT currency_cd
      FROM gicl_clm_item
     WHERE claim_id = p_claim_id
       AND item_no = p_item_no)
  LOOP
    FOR NAME IN(
      SELECT currency_desc
        FROM giis_currency
       WHERE main_currency_cd = rec.currency_cd)
    LOOP
      v_curr_name := NAME.currency_desc;
      EXIT;
    END LOOP;
    EXIT;
  END LOOP;
  RETURN v_curr_name;
END;
/


