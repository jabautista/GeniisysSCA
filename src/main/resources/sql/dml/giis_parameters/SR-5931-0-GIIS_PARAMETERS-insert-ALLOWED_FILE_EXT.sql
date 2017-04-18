SET SERVEROUTPUT ON;

DECLARE
    v_exists NUMBER(1) := 0;
BEGIN
    SELECT 1
      INTO v_exists
      FROM CPI.GIIS_PARAMETERS
     WHERE PARAM_NAME = 'ALLOWED_FILE_EXT';
     
    IF v_exists = 1 THEN 
        DBMS_OUTPUT.PUT_LINE('ALLOWED_FILE_EXT already exists in GIIS_PARAMETERS');
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
        'ALLOWED_FILE_EXT',
        'GIF,PNG,JPG,JPEG,BMP,ANI,DOC,XLS,PDF,TXT,ODS,ODT,DOCX,PPT,MPEG,MPG,MP4,AVI,3GP,3GPP,WMV',
        USER,
        SYSDATE,
        'List of allowed file extension for Attach Media.'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ALLOWED_FILE_EXT is successfully inserted into GIIS_PARAMETERS');
END;