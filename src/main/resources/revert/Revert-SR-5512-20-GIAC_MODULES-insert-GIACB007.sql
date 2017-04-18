SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 10.13.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/

DECLARE
   v_count   NUMBER := 0;
BEGIN
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.giac_modules
    WHERE module_name = 'GIACB007';

   IF v_count > 0
   THEN
      DELETE FROM cpi.giac_modules
            WHERE module_name = 'GIACB007';

      DBMS_OUTPUT.put_line
                         ('Successfully deleted GIACB007 from GIAC_MODULES.');
   ELSE
      DBMS_OUTPUT.put_line ('GIACB007 does not exists at GIAC_MODULES.');
   END IF;

   COMMIT;
END;