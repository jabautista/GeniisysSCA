SET SERVEROUTPUT ON;

DECLARE
    v_exists NUMBER(1) := 0;
BEGIN
    SELECT 1
      INTO v_exists
      FROM CPI.GIIS_PARAMETERS
     WHERE PARAM_NAME = 'ATTACH_PATH_SIZE';
     
    IF v_exists = 1 THEN
        DBMS_OUTPUT.PUT_LINE('ATTACH_PATH_SIZE already exists in GIIS_PARAMETERS');
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
        'ATTACH_PATH_SIZE',
        5,
        USER,
        SYSDATE,
        'This indicates the maximum total size of files attached per record.'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ATTACH_PATH_SIZE is successfully inserted to GIIS_PARAMETERS');
END;
