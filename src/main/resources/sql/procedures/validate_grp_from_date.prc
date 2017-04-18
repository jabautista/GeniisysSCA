DROP PROCEDURE CPI.VALIDATE_GRP_FROM_DATE;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_GRP_FROM_DATE(
    p_par_id        IN  GIPI_WGROUPED_ITEMS.par_id%TYPE,
    p_item_no       IN  GIPI_WGROUPED_ITEMS.item_no%TYPE,
    p_from_date     IN  VARCHAR2,
    p_to_date       IN  VARCHAR2,
    p_message       OUT VARCHAR2
)
IS
    v_from_date     GIPI_WITEM.from_date%TYPE;
    v_to_date       GIPI_WITEM.to_date%TYPE;
BEGIN
    p_message := 'SUCCESS';

    BEGIN
        SELECT from_date, to_date
          INTO v_from_date, v_to_date
          FROM GIPI_WITEM
         WHERE par_id = p_par_id
           AND item_no = p_item_no;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_from_date := NULL;
            v_to_date := NULL;
    END;
    
    IF TO_DATE(p_from_date, 'MM-DD-YYYY') < TRUNC(v_from_date) THEN
        p_message := 'Date entered must not be earlier than inception date ' || TO_CHAR(v_from_date, 'FMMONTH DD, YYYY');
    ELSIF TO_DATE(p_from_date, 'MM-DD-YYYY') > TRUNC(v_to_date) THEN
        p_message := 'Date entered must not be later than the expiry date ' || TO_CHAR(v_to_date, 'FMMONTH DD, YYYY');
    ELSIF p_to_date IS NOT NULL AND (TO_DATE(p_from_date, 'MM-DD-YYYY') > TO_DATE(p_to_date, 'MM-DD-YYYY')) THEN
        p_message := 'Date entered must not be later than the effectivity end date ' || TO_CHAR(TO_DATE(p_to_date, 'MM-DD-YYYY'), 'FMMONTH DD, YYYY');
    END IF;
END;
/


