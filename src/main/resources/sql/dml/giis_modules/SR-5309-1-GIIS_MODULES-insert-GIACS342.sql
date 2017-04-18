SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giis_modules
    WHERE module_id = 'GIACS342';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line ('GIACS342 already exists in GIIS_MODULES');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_modules
                  (module_id, module_desc, module_type, web_enabled
                  )
           VALUES ('GIACS342', 'Print Outstanding AP/AR Accounts', 'R', 'Y'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line ('GIACS342 inserted');
END;