SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE ('ALTER TABLE cpi.giis_tax_range
MODIFY(min_value NUMBER(16,2))');

   EXECUTE IMMEDIATE ('ALTER TABLE cpi.giis_tax_range
MODIFY(max_value NUMBER(16,2))');

   DBMS_OUTPUT.put_line
            ('MIN_VALUE AND MAX_VALUE were successfully set to NUMBER(16,2).');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;