/* Created by   : Dren Niebres
 * Date Created : 08.25.2016
 * Remarks      : SR-5278
 */
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_modules_tran
    WHERE module_id = 'GIISS223';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('GIISS223 already exists in GIIS_MODULES_TRAN.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_modules_tran
                  (module_id, tran_cd, user_id, last_update
                  )
           VALUES ('GIISS223', 24, USER, SYSDATE
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added GIISS223 in GIIS_MODULES_TRAN.');
END;