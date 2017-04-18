SET SERVEROUTPUT ON;

DECLARE
    v_exists NUMBER(1) := 0;
BEGIN
    SELECT 1
      INTO v_exists
      FROM CPI.GIIS_PARAMETERS
     WHERE PARAM_NAME = 'MEDIA_PATH_CLM';
     
    IF v_exists = 1 THEN
        DBMS_OUTPUT.PUT_LINE('MEDIA_PATH_CLM already exists in GIIS_PARAMETERS');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    INSERT INTO CPI.GIIS_PARAMETERS(
        PARAM_TYPE,
        PARAM_NAME,
        PARAM_VALUE_V,
        USER_ID,
        LAST_UPDATE,
        REMARKS
    ) VALUES(
        'V',
        'MEDIA_PATH_CLM',
        'C:\GENIISYS_WEB\ATTACHMENTS\CLM',
        USER,
        SYSDATE,
        'This indicates the location of the files attached at claims processing module.'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('MEDIA_PATH_CLM is successfully inserted to GIIS_PARAMETERS');
END;
