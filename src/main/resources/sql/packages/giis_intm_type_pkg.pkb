CREATE OR REPLACE PACKAGE BODY CPI.GIIS_INTM_TYPE_PKG AS

    FUNCTION get_intm_type_listing
      RETURN intm_type_listing_tab PIPELINED AS
        v_intm_type           intm_type_listing_type;
    BEGIN
        FOR i IN(SELECT intm_type, intm_desc
                   FROM GIIS_INTM_TYPE
                  ORDER BY intm_type)
        LOOP
            v_intm_type.intm_type := i.intm_type;
            v_intm_type.intm_desc := i.intm_desc;
            PIPE ROW(v_intm_type);
        END LOOP;
    END;
    
    PROCEDURE validate_intm_type(
        p_intm_type     IN      GIIS_INTM_TYPE.intm_type%TYPE,
        p_intm_desc     OUT     GIIS_INTM_TYPE.intm_desc%TYPE
    )
    AS
    BEGIN
        SELECT intm_desc
          INTO p_intm_desc
          FROM GIIS_INTM_TYPE
         WHERE intm_type = p_intm_type;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_intm_desc := NULL;
    END;
    
    -- Kris 07.10.2013 for GIACS413
    FUNCTION get_intm_type_lov
        RETURN intm_type_listing_tab PIPELINED
    IS
        v_intm_type         intm_type_listing_type;
    BEGIN
    
        FOR rec IN (SELECT a.intm_type, a.intm_desc 
                      FROM giis_intm_type a
                     ORDER BY 2)
        LOOP
            v_intm_type.intm_type := rec.intm_type;
            v_intm_type.intm_desc := rec.intm_desc;
            PIPE ROW(v_intm_type);
        END LOOP;
    
    END get_intm_type_lov;
    
    FUNCTION get_giacs288_intm_type_lov(
        p_find_text             GIIS_INTM_TYPE.intm_type%TYPE
    )
      RETURN intm_type_listing_tab PIPELINED
    IS
        v_row                   intm_type_listing_type;
    BEGIN
        FOR i IN(SELECT intm_type, intm_desc
                   FROM GIIS_INTM_TYPE
                  WHERE (UPPER(intm_type) LIKE UPPER(NVL(p_find_text, intm_type))
                     OR UPPER(intm_desc) LIKE UPPER(NVL(p_find_text, intm_desc)))
                  ORDER BY intm_type)
        LOOP
            v_row.intm_type := i.intm_type;
            v_row.intm_desc := i.intm_desc;
            PIPE ROW(v_row);
        END LOOP;
    END;

END GIIS_INTM_TYPE_PKG;
/


