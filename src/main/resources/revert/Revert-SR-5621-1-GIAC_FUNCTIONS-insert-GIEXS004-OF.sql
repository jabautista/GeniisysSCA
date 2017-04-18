/* benjo brito 11.24.2016 SR-5621 */
SET SERVEROUTPUT ON;

DECLARE
   v_exists      NUMBER := 0;
   v_module_id   NUMBER := NULL;
BEGIN
   BEGIN
      SELECT module_id
        INTO v_module_id
        FROM cpi.giac_modules
       WHERE module_name = 'GIEXS004';
   END;

   BEGIN
      SELECT 1
        INTO v_exists
        FROM cpi.giac_functions
       WHERE module_id = v_module_id AND function_code = 'OF';

      IF v_exists = 1
      THEN
         DELETE cpi.giac_functions
          WHERE module_id = v_module_id AND function_code = 'OF';
         
         COMMIT;
         DBMS_OUTPUT.put_line
                ('Function OF for GIEXS004 deleted in GIAC_FUNCTIONS.');
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         
         DBMS_OUTPUT.put_line
             ('Function OF for GIEXS004 does not exist in GIAC_FUNCTIONS.');
   END;
END;