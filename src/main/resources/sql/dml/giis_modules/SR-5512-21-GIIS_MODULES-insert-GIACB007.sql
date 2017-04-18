SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 10.13.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/
BEGIN
   INSERT INTO giis_modules
               (module_id, module_desc, module_type, web_enabled
               )
        VALUES ('GIACB007', 'Accounting Entry Generation on Inward Treaty Business', 'T', 'Y'
               );

   COMMIT;
   DBMS_OUTPUT.put_line ('Successfully added GIACB007 in GIIS_MODULES.');
EXCEPTION
   WHEN DUP_VAL_ON_INDEX
   THEN
      DBMS_OUTPUT.put_line ('GIACB007 module_id already exists in GIIS_MODULES.');
END;