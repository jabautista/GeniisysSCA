SET SERVEROUTPUT ON;

DECLARE
   v_exists      NUMBER := 0;
   v_module_id   NUMBER := NULL;
BEGIN
   BEGIN
      SELECT module_id
        INTO v_module_id
        FROM cpi.giac_modules
       WHERE module_name = 'GIACS008';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line
                          ('Module GIACS008 does not exists in GIAC_MODULES.');
   END;

   BEGIN
      SELECT 1
        INTO v_exists
        FROM cpi.giac_functions
       WHERE module_id = v_module_id AND function_code = 'CC';

      IF v_exists = 1
      THEN
         DBMS_OUTPUT.put_line
                ('Function CC for GIACS008 already exists in GIAC_FUNCTIONS.');
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO cpi.giac_functions
                     (module_id, function_code, function_name, active_tag,
                      function_desc
                     )
              VALUES (v_module_id, 'CC', 'CHECK CLAIM', 'Y',
                         'User is allowed to process premium collections for '
                      || 'policies with existing claims'
                     );

         COMMIT;
         DBMS_OUTPUT.put_line
             ('Successfully added function CC for GIACS008 in GIAC_FUNCTIONS.');
   END;
END;