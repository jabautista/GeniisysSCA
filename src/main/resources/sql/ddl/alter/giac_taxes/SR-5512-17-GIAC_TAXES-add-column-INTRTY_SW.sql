SET serveroutput ON
/*
**  Created by   : Benjo Brito
**  Date Created : 08.03.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/
DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   SELECT CASE
             WHEN EXISTS (
                    SELECT NULL
                      FROM user_tab_columns
                     WHERE UPPER (table_name) = 'GIAC_TAXES'
                       AND UPPER (column_name) = 'INTRTY_SW')
                THEN 'Y'
             ELSE 'N'
          END AS rec_exists
     INTO v_exists
     FROM DUAL;

   IF v_exists = 'Y'
   THEN
      DBMS_OUTPUT.put_line ('INTRTY_SW column already exists in GIAC_TAXES table.');
   ELSE
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_TAXES ADD INTRTY_SW VARCHAR2(1)');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_TAXES.intrty_sw IS ''Indicates if the tax/charge is for inward treaty transaction only''');

      DBMS_OUTPUT.put_line ('Successfully added INTRTY_SW column to GIAC_TAXES table.');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;