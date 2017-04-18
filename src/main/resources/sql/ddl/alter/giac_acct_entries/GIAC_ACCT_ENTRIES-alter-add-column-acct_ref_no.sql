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
      AND UPPER (column_name) = 'ACCT_REF_NO';

   IF v_count = 0
   THEN
      DBMS_OUTPUT.put_line
                   ('Adding column ACCT_REF_NO to table GIAC_ACCT_ENTRIES...');

      EXECUTE IMMEDIATE 'ALTER TABLE giac_acct_entries add acct_ref_no VARCHAR2(50)';

      EXECUTE IMMEDIATE ('COMMENT ON COLUMN CPI.GIAC_ACCT_ENTRIES.acct_ref_no IS ''Account Reference Number''');

      DBMS_OUTPUT.put_line ('Column added.');
   ELSE
      DBMS_OUTPUT.put_line
              ('ACCT_REF_NO column already exist at GIAC_ACCT_ENTRIES table.');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;