SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 08.03.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/
BEGIN
   INSERT INTO giis_modules
               (module_id, module_desc, module_type, web_enabled
               )
        VALUES ('GIRIS057', 'View Inward Treaty', 'I', 'Y'
               );

   COMMIT;
   DBMS_OUTPUT.put_line ('Successfully added GIRIS057 in GIIS_MODULES.');
EXCEPTION
   WHEN DUP_VAL_ON_INDEX
   THEN
      DBMS_OUTPUT.put_line ('GIRIS057 module_id already exists in GIIS_MODULES.');
END;