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
    WHERE UPPER (table_name) = 'GIAC_TAXES'
          AND UPPER (column_name) = 'INTRTY_SW';

   IF v_count > 0
   THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_TAXES DROP COLUMN INTRTY_SW');

      DBMS_OUTPUT.put_line
                ('Successfully dropped column INTRTY_SW in GIAC_TAXES table.');
   ELSE
      DBMS_OUTPUT.put_line
                     ('Column INTRTY_SW in GIAC_TAXES table does not exists.');
   END IF;

   COMMIT;
END;