/* Created by   : Dren Niebres
 * Date Created : 06.08.2016
 * Remarks      : SR-5278
 */
SET SERVEROUTPUT ON

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   SELECT 'Y'
     INTO v_exists
     FROM cpi.giis_modules
    WHERE module_id = 'GIISS223';

   IF v_exists = 'Y'
   THEN
      DELETE FROM cpi.giis_modules
            WHERE module_id = 'GIISS223';
      COMMIT;

      DBMS_OUTPUT.put_line
         ('Record with module_id = GIISS223 is successfully deleted.'
         );        
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line
         ('Record with module_id = GIISS223 is not existing in GIIS_MODULES.'
         );
END;