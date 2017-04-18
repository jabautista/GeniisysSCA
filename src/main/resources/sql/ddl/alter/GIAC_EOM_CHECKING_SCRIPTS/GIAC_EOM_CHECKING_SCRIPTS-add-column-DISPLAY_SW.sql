SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      ('ALTER TABLE CPI.giac_eom_checking_scripts ADD display_sw varchar2(1)');

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added DISPLAY_SW column to GIAC_EOM_CHECKING_SCRIPTS table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;