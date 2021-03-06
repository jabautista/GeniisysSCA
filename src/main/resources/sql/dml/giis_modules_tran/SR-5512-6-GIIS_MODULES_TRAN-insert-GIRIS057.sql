SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 08.03.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/
BEGIN
   INSERT INTO giis_modules_tran
               (module_id, tran_cd
               )
        VALUES ('GIRIS057', 25
               );

   COMMIT;
   DBMS_OUTPUT.put_line ('Successfully added GIRIS057 in GIIS_MODULES_TRAN.');
EXCEPTION
   WHEN DUP_VAL_ON_INDEX
   THEN
      DBMS_OUTPUT.put_line ('GIRIS057 module_id already exists in GIIS_MODULES_TRAN.');
END;