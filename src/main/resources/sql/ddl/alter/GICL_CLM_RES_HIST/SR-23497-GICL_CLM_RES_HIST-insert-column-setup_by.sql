SET serveroutput ON

DECLARE
   v_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO v_count
     FROM user_tab_columns
    WHERE UPPER (table_name) = 'GICL_CLM_RES_HIST'
      AND UPPER (column_name) = 'SETUP_BY';

   IF v_count = 0
   THEN
      DBMS_OUTPUT.put_line
                   ('Adding column SETUP_BY to table GICL_CLM_RES_HIST.');

      EXECUTE IMMEDIATE 'ALTER TABLE GICL_CLM_RES_HIST add setup_by VARCHAR2(8)';

      DBMS_OUTPUT.put_line ('Column added.');
   ELSE
      DBMS_OUTPUT.put_line
              ('SETUP_BY column is already existing at GICL_CLM_RES_HIST table.');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;