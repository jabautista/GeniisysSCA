SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 08.03.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/

DECLARE
   v_count   NUMBER := 0;
BEGIN
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.giac_functions
    WHERE function_code = 'AP' AND function_name = 'APPROVE INWARD TREATY';

   IF v_count > 0
   THEN
      DELETE FROM cpi.giac_functions
            WHERE function_code = 'AP'
              AND function_name = 'APPROVE INWARD TREATY';

      DBMS_OUTPUT.put_line
            ('Successfully deleted APPROVE INWARD TREATY from GIAC_FUNCTIONS.');
   ELSE
      DBMS_OUTPUT.put_line
                  ('APPROVE INWARD TREATY does not exists at GIAC_FUNCTIONS.');
   END IF;

   COMMIT;
END;