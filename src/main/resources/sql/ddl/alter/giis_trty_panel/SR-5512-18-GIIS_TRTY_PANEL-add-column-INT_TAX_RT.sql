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
                     WHERE UPPER (table_name) = 'GIIS_TRTY_PANEL'
                       AND UPPER (column_name) = 'INT_TAX_RT')
                THEN 'Y'
             ELSE 'N'
          END AS rec_exists
     INTO v_exists
     FROM DUAL;

   IF v_exists = 'Y'
   THEN
      DBMS_OUTPUT.put_line ('INT_TAX_RT column already exists in GIIS_TRTY_PANEL table.');
   ELSE
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_TRTY_PANEL ADD INT_TAX_RT NUMBER(5,3)');

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIIS_TRTY_PANEL.int_tax_rt IS ''Indicates the percent for interest on taxes.''');

      DBMS_OUTPUT.put_line ('Successfully added INT_TAX_RT column to GIIS_TRTY_PANEL table.');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;