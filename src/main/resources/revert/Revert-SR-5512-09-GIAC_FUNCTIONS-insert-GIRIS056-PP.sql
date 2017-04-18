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
    WHERE function_code = 'PP' AND function_name = 'POST INWARD TREATY';

   IF v_count > 0
   THEN
      DELETE FROM cpi.giac_functions
            WHERE function_code = 'PP'
              AND function_name = 'POST INWARD TREATY';

      DBMS_OUTPUT.put_line
               ('Successfully deleted POST INWARD TREATY from GIAC_FUNCTIONS.');
   ELSE
      DBMS_OUTPUT.put_line
                     ('POST INWARD TREATY does not exists at GIAC_FUNCTIONS.');
   END IF;

   COMMIT;
END;