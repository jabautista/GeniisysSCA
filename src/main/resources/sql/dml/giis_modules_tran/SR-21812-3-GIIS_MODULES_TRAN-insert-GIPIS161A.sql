SET SERVEROUTPUT ON;

DECLARE
    v_exists NUMBER(1) := 0;
BEGIN
    SELECT 1
      INTO v_exists
      FROM cpi.giis_modules_tran
     WHERE module_id = 'GIPIS161A';
     
     DBMS_OUTPUT.PUT_LINE('GIPIS161A already exists in GIIS_MODULES_TRAN');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    INSERT INTO cpi.giis_modules_tran(
        module_id,
        tran_cd,
        user_id,
        last_update
    ) VALUES(
        'GIPIS161A',
        27,
        USER,
        SYSDATE
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('GIPIS161A is successfully inserted in GIIS_MODULES_TRAN');
END;
