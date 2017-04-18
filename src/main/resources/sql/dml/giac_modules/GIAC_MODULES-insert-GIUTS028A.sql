SET SERVEROUTPUT ON

DECLARE
   v_exists      NUMBER := 0;
   v_module_id   NUMBER := NULL;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giac_modules
    WHERE module_name = 'GIUTS028A';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line ('GIUTS028A is already existing in GIAC_MODULES.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      SELECT MAX (module_id) + 1
        INTO v_module_id
        FROM cpi.giac_modules;

      INSERT INTO cpi.giac_modules
                  (module_id, module_name, scrn_rep_name, scrn_rep_tag
                  )
           VALUES (v_module_id, 'GIUTS028A', 'PACKAGE REINSTATEMENT', 'S'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line ('GIUTS028A inserted.');
END;