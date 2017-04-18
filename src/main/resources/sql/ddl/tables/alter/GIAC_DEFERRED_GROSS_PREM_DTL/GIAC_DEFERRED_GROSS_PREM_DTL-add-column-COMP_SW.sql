SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.GIAC_DEFERRED_GROSS_PREM_DTL ADD comp_sw  VARCHAR2(1)';

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added comp_sw column to GIAC_DEFERRED_GROSS_PREM_DTL table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
BEGIN
   UPDATE cpi.GIAC_DEFERRED_GROSS_PREM_DTL
      SET COMP_SW = 'N'
    WHERE COMP_SW IS NULL;

   COMMIT;
END;
/
BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.GIAC_DEFERRED_GROSS_PREM_DTL MODIFY(comp_sw DEFAULT ''N'')';

   DBMS_OUTPUT.PUT_LINE ('Added default value for comp_sw.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/