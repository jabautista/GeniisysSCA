/* Formatted on 2017/02/07 11:04 (Formatter Plus v4.8.8) */
SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE 'CREATE INDEX  CPI.GIEX_EXPIRY_IDX3 ON CPI.GIEX_EXPIRY (pack_policy_id)';

   DBMS_OUTPUT.put_line ('index created');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLERRM || '-' || SQLCODE);
END;
/