DROP FUNCTION CPI.GET_ITEM_TITLE;

CREATE OR REPLACE FUNCTION CPI.GET_ITEM_TITLE
          (p_policy_id IN gipi_item.policy_id%TYPE,
           p_par_id    IN gipi_witem.par_id%TYPE,
           p_item_no   IN gipi_item.item_no%TYPE) RETURN CHAR IS
  p_item_title        gipi_item.item_title%TYPE;
BEGIN
  IF p_policy_id IS NOT NULL THEN
    FOR A IN (SELECT  item_title
                FROM  gipi_item
               WHERE  policy_id = p_policy_id
                 AND  item_no   = p_item_no) LOOP
      p_item_title := a.item_title;
      EXIT;
    END LOOP;
  ELSIF p_par_id IS NOT NULL THEN
    FOR A IN (SELECT  item_title
                FROM  gipi_witem
               WHERE  par_id = p_par_id
                 AND  item_no   = p_item_no) LOOP
      p_item_title := a.item_title;
      EXIT;
    END LOOP;
  END IF;
  RETURN p_item_title;
END;
/


