DROP PROCEDURE CPI.VALIDATE_GROUPED_ITEM_TITLE;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_GROUPED_ITEM_TITLE(
    p_grouped_item_title    IN  GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE,
    p_par_id                IN  GIPI_WGROUPED_ITEMS.par_id%TYPE,
    p_item_no               IN  GIPI_WGROUPED_ITEMS.item_no%TYPE,
    p_subline_cd            OUT GIPI_WPOLBAS.subline_cd%TYPE,
    p_message               OUT VARCHAR2
)
IS
    v_exists    VARCHAR2(1);
BEGIN
    p_message := 'Grouped Item Title must be unique.';
    
    BEGIN
        SELECT 1
          INTO v_exists
          FROM GIPI_WGROUPED_ITEMS
         WHERE grouped_item_title = p_grouped_item_title
           AND par_id = p_par_id
           AND item_no = p_item_no;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_message := 'SUCCESS';
    END;

    FOR i IN(SELECT line_cd
               FROM GIPI_PARLIST
              WHERE par_id = p_par_id)
    LOOP
        FOR a IN(SELECT subline_cd
                   FROM GIPI_WPOLBAS
                  WHERE par_id = p_par_id
                    AND line_cd = i.line_cd)
        LOOP
            p_subline_cd := a.subline_cd;
        END LOOP;
    END LOOP;
END;
/


