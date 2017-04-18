SET SERVEROUTPUT ON;

DECLARE
   v_exists      VARCHAR2 (1)                  := 'N';
   v_module_id   giac_modules.module_id%TYPE;
BEGIN
   BEGIN
      SELECT module_id
        INTO v_module_id
        FROM giac_modules
       WHERE module_name = 'GICLS010';
   END;

   BEGIN
      SELECT 'Y'
        INTO v_exists
        FROM giac_functions
       WHERE module_id = v_module_id AND function_code = 'CP';

      IF v_exists = 'Y' THEN
         DBMS_OUTPUT.put_line ('FUNCTION CP for GICLS010 is already existing in GIAC_FUNCTIONS.');
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         INSERT INTO giac_functions
                     (module_id, function_code, function_name, active_tag, function_desc, user_id, last_update
                     )
              VALUES (v_module_id, 'CP', 'Cancelled_Policy_Override', 'Y', 'User can process claim for cancelled policies loss date within the earned period.', USER, SYSDATE
                     );

         COMMIT;
         DBMS_OUTPUT.put_line ('Function CP for GICLS010 is inserted.');
   END;
END;