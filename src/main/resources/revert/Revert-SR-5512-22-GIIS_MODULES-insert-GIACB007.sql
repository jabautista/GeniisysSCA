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
     FROM cpi.giis_modules
    WHERE module_id = 'GIACB007';

   IF v_count > 0
   THEN
      DELETE FROM cpi.giis_modules
            WHERE module_id = 'GIACB007';

      DBMS_OUTPUT.put_line
                          ('Successfully deleted GIACB007 from GIIS_MODULES.');
   ELSE
      DBMS_OUTPUT.put_line ('GIACB007 does not exists at GIIS_MODULES.');
   END IF;

   COMMIT;
END;