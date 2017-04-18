DROP PROCEDURE CPI.VALIDATE_GROUPED_ITEMS;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_GROUPED_ITEMS(
    p_grouped_item_no   IN      GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
    p_par_id            IN      GIPI_WGROUPED_ITEMS.par_id%TYPE,
    p_item_no           IN      GIPI_WGROUPED_ITEMS.item_no%TYPE,
    p_pack_ben_cd       OUT     GIPI_WITEM.pack_ben_cd%TYPE,               
    p_from_date         OUT     GIPI_WITEM.from_date%TYPE,
    p_to_date           OUT     GIPI_WITEM.to_date%TYPE,
    p_package_cd        OUT     GIIS_PACKAGE_BENEFIT.package_cd%TYPE,
    p_message           OUT     VARCHAR2
)
IS
    v_exists    VARCHAR2(1);
BEGIN
    p_message := 'Grouped Item No. must be unique.';

    BEGIN
        SELECT 1
          INTO v_exists
          FROM GIPI_WGROUPED_ITEMS
         WHERE grouped_item_no = p_grouped_item_no
           AND par_id = p_par_id
           AND item_no = p_item_no;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_message := 'SUCCESS';
    END;
    
    BEGIN
        SELECT a.pack_ben_cd, a.from_date, a.to_date, b.package_cd
          INTO p_pack_ben_cd, p_from_date, p_to_date, p_package_cd
          FROM GIPI_WITEM a,
               GIIS_PACKAGE_BENEFIT b
         WHERE a.par_id = p_par_id
           AND a.item_no = p_item_no
           AND a.pack_ben_cd = b.pack_ben_cd(+);
    END;
END;
/


