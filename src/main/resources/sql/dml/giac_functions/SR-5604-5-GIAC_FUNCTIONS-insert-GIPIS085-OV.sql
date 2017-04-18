/* benjo brito 08.24.2016 SR-5604 */
SET SERVEROUTPUT ON;

DECLARE
   v_exists      NUMBER := 0;
   v_module_id   NUMBER := NULL;
BEGIN
   BEGIN
      SELECT module_id
        INTO v_module_id
        FROM cpi.giac_modules
       WHERE module_name = 'GIPIS085';
   END;

   BEGIN
      SELECT 1
        INTO v_exists
        FROM cpi.giac_functions
       WHERE module_id = v_module_id AND function_code = 'OV';

      IF v_exists = 1
      THEN
         DBMS_OUTPUT.put_line
                ('Function OV for GIPIS085 already exists in GIAC_FUNCTIONS.');
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO cpi.giac_functions
                     (module_id, function_code,
                      function_name, active_tag,
                      function_desc, override_sw
                     )
              VALUES (v_module_id, 'OV',
                      'OVERRIDE FOR UPDATE OF DEFAULT AGENT', 'Y',
                      'User is allowed to update/change the default intermediary of the assured during transaction.',
                      'Y'
                     );

         COMMIT;
         DBMS_OUTPUT.put_line
             ('Successfully added function OV for GIPIS085 in GIAC_FUNCTIONS.');
   END;
END;