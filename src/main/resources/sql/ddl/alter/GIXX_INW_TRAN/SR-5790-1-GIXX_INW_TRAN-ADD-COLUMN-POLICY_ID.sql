SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      ('ALTER TABLE CPI.GIXX_INW_TRAN ADD policy_id NUMBER(12)');
   DBMS_OUTPUT.PUT_LINE (
      'Successfully added policy_idcolumn to CPI.GIXX_INW_TRAN table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;
