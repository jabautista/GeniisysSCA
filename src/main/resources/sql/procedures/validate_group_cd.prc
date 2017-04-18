DROP PROCEDURE CPI.VALIDATE_GROUP_CD;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_GROUP_CD(
    p_par_id        IN  GIPI_WGROUPED_ITEMS.par_id%TYPE,
    p_group_cd      IN  GIPI_WGROUPED_ITEMS.group_cd%TYPE,
    p_group_desc    OUT GIIS_GROUP.group_desc%TYPE,
    p_message       OUT VARCHAR2
)
IS
    v_exists        VARCHAR2(1);
    v_group_desc    GIIS_GROUP.group_desc%TYPE;
    v_assd_no       GIPI_PARLIST.assd_no%TYPE;
BEGIN
    BEGIN
        SELECT assd_no
          INTO v_assd_no
          FROM GIPI_PARLIST
         WHERE par_id = p_par_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_assd_no := NULL;
    END;

    BEGIN
        SELECT group_desc
          INTO v_group_desc
          FROM GIIS_GROUP
         WHERE group_cd = p_group_cd;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_message := 'Group Code not existing in maintenance table.';
        WHEN TOO_MANY_ROWS THEN
            p_message := 'Too many rows found with this group code in the maintenance table.';
    END;
    
    FOR i IN(SELECT '1'
               FROM GIIS_ASSURED_GROUP
              WHERE group_cd = p_group_cd
                AND assd_no  = v_assd_no)
     LOOP
        p_group_desc := v_group_desc;
        v_exists := 'Y';
        EXIT;
     END LOOP;
END;
/


