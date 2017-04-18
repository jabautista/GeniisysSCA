/* Created by   : Dren Niebres
 * Date Created : 08.01.2016
 * Remarks      : SR-5278
 */
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_modules
    WHERE module_id = 'GIISS224';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('GIISS224 already exists in GIIS_MODULES.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_modules
                  (module_id, module_desc, module_type, web_enabled
                  )
           VALUES ('GIISS224', 'MOTORCAR DEPRECIATION MAINTENANCE', 'M', 'Y'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added GIISS224 in GIIS_MODULES.');
END;