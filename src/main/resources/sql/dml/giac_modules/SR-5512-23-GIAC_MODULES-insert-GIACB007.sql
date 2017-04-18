SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 10.13.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/

BEGIN
   MERGE INTO cpi.giac_modules a
      USING (SELECT (SELECT MAX (module_id) + 1
                       FROM cpi.giac_modules) AS module_id,
                    'GIACB007' AS module_name,
                    'TAKE-UP OF INWARD TREATY BUSINESS' AS scrn_rep_name,
                    'S' AS scrn_rep_tag, 'IT' AS generation_type,
                    'Y' AS mod_entries_tag
               FROM DUAL) b
      ON (a.module_name = b.module_name)
      WHEN NOT MATCHED THEN
         INSERT (a.module_id, a.module_name, a.scrn_rep_name, a.scrn_rep_tag,
                 a.generation_type, a.mod_entries_tag)
         VALUES (b.module_id, b.module_name, b.scrn_rep_name, b.scrn_rep_tag,
                 b.generation_type, b.mod_entries_tag);

   IF SQL%FOUND
   THEN
      COMMIT;
      DBMS_OUTPUT.put_line ('GIACB007 inserted in GIAC_MODULES.');
   ELSE
      DBMS_OUTPUT.put_line ('GIACB007 is already existing in GIAC_MODULES.');
   END IF;
END;