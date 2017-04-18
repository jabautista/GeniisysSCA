/* benjo brito 11.08.2016 SR-5802 */
SET SERVEROUTPUT ON;

DECLARE
   v_exists      NUMBER := 0;
   v_module_id   NUMBER := NULL;
BEGIN
   BEGIN
      SELECT module_id
        INTO v_module_id
        FROM cpi.giac_modules
       WHERE module_name = 'GIACS001';
   END;

   BEGIN
      SELECT 1
        INTO v_exists
        FROM cpi.giac_functions
       WHERE module_id = v_module_id AND function_code = 'AS';

      IF v_exists = 1
      THEN
         DBMS_OUTPUT.put_line
                ('Function AS for GIACS001 already exists in GIAC_FUNCTIONS.');
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO cpi.giac_functions
                     (module_id, function_code, function_name, active_tag,
                      function_desc
                     )
              VALUES (v_module_id, 'AS', 'ALLOW SPOIL OR', 'Y',
                      'User can spoil OR.'
                     );

         COMMIT;
         DBMS_OUTPUT.put_line
             ('Successfully added function AS for GIACS001 in GIAC_FUNCTIONS.');
   END;
END;