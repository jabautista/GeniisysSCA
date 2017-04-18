SET SERVEROUTPUT ON;

DECLARE
   v_exists      NUMBER := 0;
   v_module_id   NUMBER := NULL;
BEGIN
   BEGIN
      SELECT module_id
        INTO v_module_id
        FROM cpi.giac_modules
       WHERE module_name = 'GIUTS028A';
   END;

   BEGIN
      SELECT 1
        INTO v_exists
        FROM cpi.giac_functions
       WHERE module_id = v_module_id AND function_code = 'RP';

      IF v_exists = 1
      THEN
         DBMS_OUTPUT.put_line
            ('Function RP for GIUTS028A is already existing in GIAC_FUNCTIONS.'
            );
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO cpi.giac_functions
                     (module_id, function_code,
                      function_name, active_tag,
                      function_desc
                     )
              VALUES (v_module_id, 'RP',
                      'OVERRIDE FOR REINSTATEMENT OF POSTED POLICY', 'Y',
                      'User is allowed to reinstate a policy even if there is a cancelled renewal policy.'
                     );

         COMMIT;
         COMMIT;
         DBMS_OUTPUT.put_line ('Function RP for GIUTS028A inserted.');
   END;
END;