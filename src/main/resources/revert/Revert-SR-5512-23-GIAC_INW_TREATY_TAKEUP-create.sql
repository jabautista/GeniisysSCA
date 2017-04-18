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
     FROM all_tables
    WHERE owner = 'CPI' AND table_name = 'GIAC_INW_TREATY_TAKEUP';

   IF v_count > 0
   THEN
      EXECUTE IMMEDIATE ('DROP TABLE GIAC_INW_TREATY_TAKEUP');

      DBMS_OUTPUT.put_line ('Successfully deleted GIAC_INW_TREATY_TAKEUP table.');
   ELSE
      DBMS_OUTPUT.put_line ('GIAC_INW_TREATY_TAKEUP table does not exists.');
   END IF;

   COMMIT;
END;