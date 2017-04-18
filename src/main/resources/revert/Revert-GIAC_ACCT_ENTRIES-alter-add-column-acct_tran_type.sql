/* Created by   : Gzelle
 * Date Created : 01-25-2016
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
         ('ACCT_TRAN_TYPE column is not existing at GIAC_ACCT_ENTRIES table.');
   ELSE
      DBMS_OUTPUT.put_line
              ('Deleting column ACCT_TRAN_TYPE in table GIAC_ACCT_ENTRIES...');

      EXECUTE IMMEDIATE 'ALTER TABLE giac_acct_entries DROP COLUMN acct_tran_type';

      DBMS_OUTPUT.put_line ('Column dropped.');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;