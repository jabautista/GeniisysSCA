SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giis_modules_tran
    WHERE module_id = 'GIACS342';

   IF v_exists = 1
   THEN
      DELETE FROM giis_user_grp_modules
            WHERE module_id = 'GIACS342';

      DELETE FROM giis_user_modules
            WHERE module_id = 'GIACS342';

      DELETE FROM giis_modules_tran
            WHERE module_id = 'GIACS342';

      COMMIT;
      DBMS_OUTPUT.put_line ('GIACS342 is deleted in GIIS_MODULES_TRAN.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('GIACS342 is not existing in GIIS_MODULES_TRAN');
END;