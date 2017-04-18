SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giac_parameters
    WHERE param_name = 'MAX_MISC_ENTRY';

   IF v_exist = 1
   THEN
      DELETE FROM giac_parameters
            WHERE param_name = 'MAX_MISC_ENTRY' AND param_type = 'N';

      DBMS_OUTPUT.put_line ('MAX_MISC_ENTRY deleted from giac_parameters.');
      COMMIT;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('MAX_MISC_ENTRY not found in giac_parameters.');
END;