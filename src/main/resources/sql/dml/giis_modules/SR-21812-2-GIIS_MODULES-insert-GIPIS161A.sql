SET SERVEROUTPUT ON;

DECLARE
    v_exists NUMBER(1) := 0;
BEGIN
    SELECT 1
      INTO v_exists
      FROM cpi.giis_modules
     WHERE module_id = 'GIPIS161A';
     
     DBMS_OUTPUT.PUT_LINE('GIPIS161A already exists in GIIS_MODULES');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    INSERT INTO cpi.giis_modules(
        module_id,
        module_desc,
        user_id,
        last_update,
        module_type,
        web_enabled
    ) VALUES(
        'GIPIS161A',
        'UPDATE INITIAL/ GENERAL/ ENDT INFO (PACKAGE)',
        USER,
        SYSDATE,
        'T',
        'Y'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('GIPIS161A is successfully inserted to GIIS_MODULES');
END;
