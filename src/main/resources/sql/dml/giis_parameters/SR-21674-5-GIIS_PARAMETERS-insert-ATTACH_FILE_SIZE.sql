SET SERVEROUTPUT ON;

DECLARE
    v_exists NUMBER(1) := 0;
BEGIN
    SELECT 1
      INTO v_exists
      FROM CPI.GIIS_PARAMETERS
     WHERE PARAM_NAME = 'ATTACH_FILE_SIZE';
     
    IF v_exists = 1 THEN
        DBMS_OUTPUT.PUT_LINE('ATTACH_FILE_SIZE already exists in GIIS_PARAMETERS');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    INSERT INTO CPI.GIIS_PARAMETERS(
        PARAM_TYPE,
        PARAM_NAME,
        PARAM_VALUE_N,
        USER_ID,
        LAST_UPDATE,
        REMARKS
    ) VALUES(
        'N',
        'ATTACH_FILE_SIZE',
        2,
        USER,
        SYSDATE,
        'This indicates the maximum size of file being attached.'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ATTACH_FILE_SIZE is successfully inserted to GIIS_PARAMETERS');
END;
