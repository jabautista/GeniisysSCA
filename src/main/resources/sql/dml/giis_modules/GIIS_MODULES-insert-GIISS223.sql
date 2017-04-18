/* Created by   : Dren Niebres
 * Date Created : 06.08.2016
 * Remarks      : SR-5278
 */
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_modules
    WHERE module_id = 'GIISS223';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('GIISS223 already exists in GIIS_MODULES.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_modules
                  (module_id, module_desc, module_type, web_enabled
                  )
           VALUES ('GIISS223', 'MOTORCAR FAIR MARKET VALUE MAINTENANCE', 'M', 'Y'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added GIISS223 in GIIS_MODULES.');
END;