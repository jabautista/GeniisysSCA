SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 08.03.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/
BEGIN
   MERGE INTO giac_modules a
      USING (SELECT (SELECT MAX (module_id) + 1
                       FROM giac_modules) AS module_id,
                    'GIRIS056' AS module_name,
                    'INWARD TREATY LISTING' AS scrn_rep_name,
                    'S' AS scrn_rep_tag
               FROM DUAL) b
      ON (a.module_name = b.module_name)
      WHEN NOT MATCHED THEN
         INSERT (a.module_id, a.module_name, a.scrn_rep_name, a.scrn_rep_tag)
         VALUES (b.module_id, b.module_name, b.scrn_rep_name, b.scrn_rep_tag);

   IF SQL%FOUND
   THEN
      COMMIT;
      DBMS_OUTPUT.put_line ('GIRIS056 inserted in GIAC_MODULES.');
   ELSE
      DBMS_OUTPUT.put_line ('GIRIS056 is already existing in GIAC_MODULES.');
   END IF;
END;