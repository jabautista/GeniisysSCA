SET serveroutput ON;
DECLARE
    v_exists VARCHAR2(1);
BEGIN
    BEGIN
        SELECT 'Y'
          INTO v_exists
          FROM all_tab_cols
         WHERE owner = 'CPI'
           AND table_name = 'GIIS_USERS'
           AND column_name = 'SALT';
    
        DBMS_OUTPUT.PUT_LINE('GIIS_USERS.salt already exists.');       
           
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_exists := 'N';
    END;
    
    IF v_exists = 'N' THEN
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIIS_USERS ADD salt VARCHAR2(1000)';
            DBMS_OUTPUT.PUT_LINE ('Column added.');
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR : ' || SQLERRM);    
        END;
    END IF;    
END;