SET SERVEROUTPUT ON;

DECLARE
   v_exists      VARCHAR2 (1)                  := 'N';
   v_module_id   giac_modules.module_id%TYPE;
BEGIN
   BEGIN
      SELECT module_id
        INTO v_module_id
        FROM giac_modules
       WHERE module_name = 'GICLS030';
   END;

   BEGIN
      SELECT 'Y'
        INTO v_exists
        FROM giac_functions
       WHERE module_id = v_module_id 
         AND function_code = 'LO';
         
         IF v_exists = 'Y' THEN
              DBMS_OUTPUT.put_line ('FUNCTION LO for GICLS030 is already existing in GIAC_FUNCTIONS.');
         END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO giac_functions
                     (module_id, function_code,
                      function_name, active_tag,
                      function_desc,
                      user_id, last_update
                     )
              VALUES (v_module_id, 'LO',
                      'LOA OVERRIDE FOR UNPAID PREMIUM', 'Y',
                      'User can print the LOA for a claim whose policy has unpaid premiums',
                      USER, SYSDATE
                     );

         COMMIT;
      DBMS_OUTPUT.put_line ('Function LO for GICLS030 is inserted.');
   END;
END;