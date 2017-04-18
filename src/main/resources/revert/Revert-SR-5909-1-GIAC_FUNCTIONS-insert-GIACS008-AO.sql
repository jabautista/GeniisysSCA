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
       WHERE module_id = v_module_id AND function_code = 'AO';

      IF v_exists = 1
      THEN
         DELETE FROM cpi.giac_functions
               WHERE module_id = v_module_id AND function_code = 'AO';

         COMMIT;
         DBMS_OUTPUT.put_line
            ('Successfully deleted functin AO for GIACS008 in GIAC_FUNCTIONS.'
            );
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line
               ('Function AO for GIACS008 does not exists in GIAC_FUNCTIONS.');
   END;
END;