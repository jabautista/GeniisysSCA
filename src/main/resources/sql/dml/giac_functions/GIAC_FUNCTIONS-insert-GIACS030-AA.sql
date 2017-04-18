/* Created by   : Gzelle
 * Date Created : 12-16-2015
 * Remarks		: KB#132 - Accounting - AP/AR Enhancement
 */
SET SERVEROUTPUT ON

DECLARE
   v_exists      VARCHAR2 (1)                  := 'N';
   v_module_id   giac_modules.module_id%TYPE;
BEGIN
   BEGIN
      SELECT module_id
        INTO v_module_id
        FROM giac_modules
       WHERE module_name = 'GIACS030';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_module_id := NULL;
   END;

   BEGIN
      SELECT 'Y'
        INTO v_exists
        FROM giac_functions
       WHERE module_id = v_module_id AND function_code = 'AA';

      IF v_exists = 'Y'
      THEN
         DBMS_OUTPUT.put_line
            ('Record with function_code = AA under GIACS030 is already existing in GIAC_FUNCTIONS.'
            );
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            INSERT INTO giac_functions
                        (module_id, function_code, function_name,
                         active_tag, function_desc,
                         user_id, last_update
                        )
                 VALUES (v_module_id, 'AA', 'ALLOW AP/AR Accounts',
                         'Y', 'User is allowed to enter AP/AR Accounts.',
                         'CPI', SYSDATE
                        );

            COMMIT;
            DBMS_OUTPUT.put_line
               ('Successfully inserted function_code = AA under GIACS030 in GIAC_FUNCTIONS.'
               );
         END;
   END;
END;