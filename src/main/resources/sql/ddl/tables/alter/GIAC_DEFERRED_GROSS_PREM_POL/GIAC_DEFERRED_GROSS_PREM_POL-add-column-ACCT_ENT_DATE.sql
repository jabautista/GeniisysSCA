SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.GIAC_DEFERRED_GROSS_PREM_POL ADD acct_ent_date DATE';

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added acct_ent_date column to GIAC_DEFERRED_GROSS_PREM_POL table.');

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/