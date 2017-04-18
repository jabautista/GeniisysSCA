SET serveroutput ON

DECLARE
   v_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO v_count
     FROM user_tab_columns
    WHERE UPPER (table_name) = 'GIPI_COMM_INVOICE' AND UPPER (column_name) = 'WHTAX_ID';

   IF v_count = 0 THEN
      DBMS_OUTPUT.put_line ('Adding column WHTAX_ID to table GIPI_COMM_INVOICE...');

      EXECUTE IMMEDIATE 'ALTER TABLE GIPI_COMM_INVOICE add whtax_id NUMBER(5)';

      DBMS_OUTPUT.put_line ('Column added.');
   ELSE
      DBMS_OUTPUT.put_line ('WHTAX_ID column already exist at GIPI_COMM_INVOICE table.');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;