SET serveroutput ON

DECLARE
   v_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO v_count
     FROM user_tab_columns
    WHERE UPPER (table_name) = 'GICL_ACCT_ENTRIES' AND UPPER (column_name) = 'SL_CD';

   IF v_count = 0 THEN
      DBMS_OUTPUT.put_line ('Adding column SL_CD to table GICL_ACCT_ENTRIES...');

      EXECUTE IMMEDIATE 'ALTER TABLE GICL_ACCT_ENTRIES add SL_CD NUMBER(12)';

      DBMS_OUTPUT.put_line ('Column added.');
   ELSE
      EXECUTE IMMEDIATE 'ALTER TABLE GICL_ACCT_ENTRIES MODIFY SL_CD NUMBER(12)';
   
      DBMS_OUTPUT.put_line ('Modified SL_CD on table GICL_ACCT_ENTRIES');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;
