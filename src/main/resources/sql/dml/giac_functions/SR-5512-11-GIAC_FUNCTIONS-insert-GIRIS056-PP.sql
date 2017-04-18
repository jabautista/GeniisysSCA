SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 08.03.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/
DECLARE
   v_module_id   NUMBER := NULL;
BEGIN
   SELECT module_id
     INTO v_module_id
     FROM giac_modules
    WHERE module_name = 'GIRIS056';

   INSERT INTO giac_functions
               (module_id, function_code, function_name, active_tag,
                function_desc
               )
        VALUES (v_module_id, 'PP', 'POST INWARD TREATY', 'Y',
                'User posts and generate entries for the inward treaty record'
               );

   DBMS_OUTPUT.put_line ('Function PP for GIRIS056 inserted in GIAC_FUNCTIONS.');
   COMMIT;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('GIRIS056 does not exist in GIAC_MODULES. Function PP for GIRIS056 was not inserted to GIAC_FUNCTIONS.');
   WHEN TOO_MANY_ROWS
   THEN
      DBMS_OUTPUT.put_line ('GIRIS056 has multiple entries in GIAC_MODULES. Function PP for GIRIS056 was not inserted to GIAC_FUNCTIONS.');
   WHEN DUP_VAL_ON_INDEX
   THEN
      DBMS_OUTPUT.put_line ('Function PP for GIRIS056 is already existing in GIAC_FUNCTIONS.');
END;