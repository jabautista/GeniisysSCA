/* Created by   : Dren Niebres
 * Date Created : 09.15.2016
 * Remarks      : SR-5278
 */
SET SERVEROUTPUT ON

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   SELECT 'Y'
     INTO v_exists
     FROM cpi.giis_modules
    WHERE module_id = 'GIISS224';

   IF v_exists = 'Y'
   THEN
      DELETE FROM cpi.giis_modules
            WHERE module_id = 'GIISS224';
      COMMIT;

      DBMS_OUTPUT.put_line
         ('Record with module_id = GIISS224 is successfully deleted.'
         );        
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line
         ('Record with module_id = GIISS224 is not existing in GIIS_MODULES.'
         );
END;