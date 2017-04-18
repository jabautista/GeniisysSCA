SET SERVEROUTPUT ON

DECLARE
    v_exist     NUMBER := 0;
BEGIN
    SELECT 1
      INTO v_exist
      FROM CPI.giis_parameters
     WHERE param_name = 'FORM_2307_PATH';

    IF v_exist = 1 THEN
        DBMS_OUTPUT.put_line ('Parameter FORM_2307_PATH already exists.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO cpi.giis_parameters (param_type, param_name, param_value_v, remarks, user_id, last_update)
        VALUES ('V', 'FORM_2307_PATH', 'C:\GENIISYS_WEB\REPORTS\IMAGES\form2307.jpg', 'Path of Form 2307 image used in GIACR112A', 'CPI', SYSDATE);

        COMMIT;
        DBMS_OUTPUT.put_line ('Parameter FORM_2307_PATH inserted.');
END;