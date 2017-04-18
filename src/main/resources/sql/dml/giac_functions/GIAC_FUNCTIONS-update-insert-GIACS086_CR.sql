/*  Created by: Aliza Garza
    Created On: 10/8/2015
    Description:This script will insert funcotion code CR or correct its description
*/

DECLARE
   v_exist   VARCHAR2 (1) := 0;
BEGIN
   FOR x IN (SELECT *
               FROM giac_functions
              WHERE module_id IN (SELECT module_id
                                    FROM giac_modules
                                   WHERE module_name = 'GIACS086')
                AND function_code = 'CR')
   LOOP
         UPDATE giac_functions
            SET function_desc = 'User can cancel a payment request',
                function_name = 'CANCEL REQUEST'
          WHERE module_id = x.module_id AND function_code = 'CR';

         COMMIT;
         v_exist := 1;
         EXIT;
   END LOOP;

   IF v_exist = 0 THEN
      FOR x IN (SELECT *
                  FROM giac_modules
                 WHERE module_name = 'GIACS086')
      LOOP
         INSERT INTO cpi.giac_functions
                     (module_id, function_code, function_name, user_id,
                      last_update, active_tag, function_desc
                     )
              VALUES (x.module_id, 'CR', 'CANCEL REQUEST', USER,
                      SYSDATE, 'Y', 'User can cancel a payment request'
                     );

         COMMIT;
      END LOOP;
   END IF;
END;