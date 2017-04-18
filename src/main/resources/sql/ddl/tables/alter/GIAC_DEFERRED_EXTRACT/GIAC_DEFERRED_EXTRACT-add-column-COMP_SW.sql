/* Formatted on 3/1/2016 11:20:28 AM (QP5 v5.227.12220.39754) */
SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_deferred_extract DROP CONSTRAINT gdefext_pk';

   DBMS_OUTPUT.PUT_LINE ('dropped gdefext_pk constraint.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP INDEX  gdefext_pk';

   DBMS_OUTPUT.PUT_LINE ('dropped gdefext_pk index.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.GIAC_DEFERRED_EXTRACT ADD comp_sw VARCHAR2(1)';

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added spoiled_acct_date column to GIAC_DEFERRED_EXTRACT table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
BEGIN
   UPDATE cpi.GIAC_DEFERRED_EXTRACT
      SET COMP_SW = 'N'
    WHERE COMP_SW IS NULL;

   COMMIT;
END;
/
BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_deferred_extract MODIFY(comp_sw DEFAULT ''N'')';

   DBMS_OUTPUT.PUT_LINE ('Added default value for comp_sw.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_deferred_extract
                         ADD CONSTRAINT gdefext_pk PRIMARY KEY (YEAR,mm,procedure_id,comp_sw)';

   DBMS_OUTPUT.PUT_LINE ('Successfully added gdefext_pk.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/