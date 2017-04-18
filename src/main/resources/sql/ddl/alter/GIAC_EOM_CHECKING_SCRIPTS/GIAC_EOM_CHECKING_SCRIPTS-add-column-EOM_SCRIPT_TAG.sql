SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      ('ALTER TABLE CPI.giac_eom_checking_scripts ADD eom_script_tag VARCHAR2(20)');

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added EOM_SCRIPT_TAG column to GIAC_EOM_CHECKING_SCRIPTS table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;