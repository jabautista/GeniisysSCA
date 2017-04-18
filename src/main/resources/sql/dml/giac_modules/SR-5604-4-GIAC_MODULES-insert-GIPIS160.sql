/* benjo brito 08.24.2016 SR-5604 */
SET SERVEROUTPUT ON

DECLARE
   v_exists      NUMBER := 0;
   v_module_id   NUMBER := NULL;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giac_modules
    WHERE module_name = 'GIPIS160';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line ('GIPIS160 already exists in GIAC_MODULES.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      SELECT MAX (module_id) + 1
        INTO v_module_id
        FROM cpi.giac_modules;

      INSERT INTO cpi.giac_modules
                  (module_id, module_name,
                   scrn_rep_name, scrn_rep_tag
                  )
           VALUES (v_module_id, 'GIPIS160',
                   'ENTER INVOICE COMMISSION (BONDS)', 'S'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line ('Successfully added GIPIS160 in GIAC_MODULES.');
END;