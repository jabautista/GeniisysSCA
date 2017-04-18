SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      ('ALTER TABLE CPI.giac_eom_checking_scripts ADD script_type VARCHAR2(15)');

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added SCRIPT_TYPE column to GIAC_EOM_CHECKING_SCRIPTS table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;