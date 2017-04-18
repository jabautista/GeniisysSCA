SET serveroutput ON

DECLARE
   v_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO v_count
     FROM user_tab_columns
    WHERE UPPER (table_name) = 'GIPI_QUOTE_WC' AND UPPER (column_name) = 'WC_REMARKS';

   IF v_count = 0 THEN
      DBMS_OUTPUT.put_line ('Adding column WC_REMARKS to table GIPI_QUOTE_WC...');

      EXECUTE IMMEDIATE 'ALTER TABLE GIPI_QUOTE_WC add WC_REMARKS VARCHAR2(2000)';

      DBMS_OUTPUT.put_line ('Column added.');
   ELSE
      EXECUTE IMMEDIATE 'ALTER TABLE GIPI_QUOTE_WC MODIFY WC_REMARKS VARCHAR(2000)';
   
      DBMS_OUTPUT.put_line ('Modified WC_REMARKS on table GIPI_QUOTE_WC');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;
