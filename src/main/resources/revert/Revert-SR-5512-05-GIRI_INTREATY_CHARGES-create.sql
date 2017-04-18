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
     FROM all_tables
    WHERE owner = 'CPI' AND table_name = 'GIRI_INTREATY_CHARGES';

   IF v_count > 0
   THEN
      EXECUTE IMMEDIATE ('DROP TABLE GIRI_INTREATY_CHARGES');

      DBMS_OUTPUT.put_line
                         ('Successfully deleted GIRI_INTREATY_CHARGES table.');
   ELSE
      DBMS_OUTPUT.put_line ('GIRI_INTREATY_CHARGES table does not exists.');
   END IF;

   COMMIT;
END;