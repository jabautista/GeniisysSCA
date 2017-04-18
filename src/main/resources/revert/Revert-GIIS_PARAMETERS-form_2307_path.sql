SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'FORM_2307_PATH';

   IF v_exist = 1 THEN
      DELETE FROM giis_parameters
      WHERE param_name = 'FORM_2307_PATH'
      AND param_type = 'V';

      DBMS_OUTPUT.put_line ('FORM_2307_PATH deleted from giis_parameters.');
      COMMIT;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.put_line ('FORM_2307_PATH not found in giis_parameters.');
END;