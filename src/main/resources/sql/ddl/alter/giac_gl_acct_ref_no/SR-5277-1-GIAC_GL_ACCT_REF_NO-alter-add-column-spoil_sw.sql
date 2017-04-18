/* Created by   : Gzelle
 * Date Created : 04-19-2016
 * Remarks		: Accounting - AP/AR Enhancement
 */
SET serveroutput ON

DECLARE
   v_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO v_count
     FROM user_tab_columns
    WHERE UPPER (table_name) = 'GIAC_GL_ACCT_REF_NO'
      AND UPPER (column_name) = 'SPOIL_SW';

   IF v_count = 0
   THEN
      DBMS_OUTPUT.put_line
                   ('Adding column SPOIL_SW to table GIAC_GL_ACCT_REF_NO...');

      EXECUTE IMMEDIATE 'ALTER TABLE giac_gl_acct_ref_no add spoil_sw VARCHAR2(1)';

      DBMS_OUTPUT.put_line ('Column added.');
   ELSE
      DBMS_OUTPUT.put_line
              ('SPOIL_SW column is already existing at GIAC_GL_ACCT_REF_NO table.');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;