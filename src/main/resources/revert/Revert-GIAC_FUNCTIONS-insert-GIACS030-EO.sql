/* Created by   : Gzelle
 * Date Created : 01-22-2016
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
       WHERE module_id = v_module_id AND function_code = 'EO';

      IF v_exists = 'Y'
      THEN
         DELETE FROM giac_user_functions
               WHERE module_id = v_module_id AND function_code = 'EO';

         DELETE FROM giac_function_columns
               WHERE module_id = v_module_id AND function_cd = 'EO';

         DELETE FROM giac_function_display
               WHERE module_id = v_module_id AND function_cd = 'EO';

         DELETE FROM giac_functions
               WHERE module_id = v_module_id AND function_code = 'EO';

         COMMIT;

         DBMS_OUTPUT.put_line
            ('Record with function_code = EO under GIACS030 is successfully deleted in GIAC_FUNCTIONS.'
            );         
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line
            ('Record with function_code = EO under GIACS030 is not existing in GIAC_FUNCTIONS.'
            );
   END;
END;