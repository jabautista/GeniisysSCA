SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      ('ALTER TABLE CPI.GIPI_INSP_DATA ADD DATE_REPORTED DATE');

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added DATE_REPORTED column to GIPI_INSP_DATA table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;