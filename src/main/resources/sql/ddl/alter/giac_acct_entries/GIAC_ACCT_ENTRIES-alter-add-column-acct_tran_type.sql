/* Created by   : Gzelle
 * Date Created : 11-04-2015
 * Remarks		: KB#132 - Accounting - AP/AR Enhancement
 */
SET serveroutput ON

DECLARE
   v_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO v_count
     FROM user_tab_columns
    WHERE UPPER (table_name) = 'GIAC_ACCT_ENTRIES'
      AND UPPER (column_name) = 'ACCT_TRAN_TYPE';

   IF v_count = 0
   THEN
      DBMS_OUTPUT.put_line
                ('Adding column ACCT_TRAN_TYPE to table GIAC_ACCT_ENTRIES...');

      EXECUTE IMMEDIATE 'ALTER TABLE giac_acct_entries add acct_tran_type VARCHAR2(1)';

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_ACCT_ENTRIES.acct_tran_type IS ''Identifier for Account Transaction Type''');

      DBMS_OUTPUT.put_line ('Column added.');
   ELSE
      DBMS_OUTPUT.put_line
           ('ACCT_TRAN_TYPE column already exist at GIAC_ACCT_ENTRIES table.');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;