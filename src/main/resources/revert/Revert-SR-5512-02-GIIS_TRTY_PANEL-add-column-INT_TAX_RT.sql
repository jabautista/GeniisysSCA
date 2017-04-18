SET serveroutput ON
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
     FROM user_tab_columns
    WHERE UPPER (table_name) = 'GIIS_TRTY_PANEL'
      AND UPPER (column_name) = 'INT_TAX_RT';

   IF v_count > 0
   THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_TRTY_PANEL DROP COLUMN INT_TAX_RT');

      DBMS_OUTPUT.put_line
          ('Successfully dropped column INT_TAX_RT in GIIS_TRTY_PANEL table.');
   ELSE
      DBMS_OUTPUT.put_line
               ('Column INT_TAX_RT in GIIS_TRTY_PANEL table does not exists.');
   END IF;

   COMMIT;
END;