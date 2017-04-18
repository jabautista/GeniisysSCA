SET serveroutput ON

DECLARE
   v_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO v_count
     FROM user_tab_columns
    WHERE UPPER (table_name) = 'GIPI_QUOTE' AND UPPER (column_name) = 'ACCOUNT_SW';

   IF v_count = 0 THEN
      DBMS_OUTPUT.put_line ('Adding column ACCOUNT_SW to table GIPI_QUOTE...');

      EXECUTE IMMEDIATE 'ALTER TABLE GIPI_QUOTE add account_sw NUMBER(1)';

      DBMS_OUTPUT.put_line ('Column added.');
   ELSE
      DBMS_OUTPUT.put_line ('ACCOUNT_SW column already exist at GIPI_QUOTE table.');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;
