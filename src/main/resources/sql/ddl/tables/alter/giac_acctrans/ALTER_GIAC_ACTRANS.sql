SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE giac_acctrans ADD (jv_pref VARCHAR2 (2), JV_SEQ_NO NUMBER(12))';

   DBMS_OUTPUT.PUT_LINE ('added new columns');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/