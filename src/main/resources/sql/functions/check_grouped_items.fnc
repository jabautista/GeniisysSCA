DROP FUNCTION CPI.CHECK_GROUPED_ITEMS;

CREATE OR REPLACE FUNCTION CPI.CHECK_GROUPED_ITEMS(
    p_par_id            GIPI_WGROUPED_ITEMS.par_id%TYPE,
    p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE
)
RETURN NUMBER
IS
    v_count             NUMBER := 0;
BEGIN
    SELECT count(*)
      INTO v_count
      FROM GIPI_WGROUPED_ITEMS
     WHERE par_id = p_par_id
       AND item_no = p_item_no;

    RETURN v_count;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/


