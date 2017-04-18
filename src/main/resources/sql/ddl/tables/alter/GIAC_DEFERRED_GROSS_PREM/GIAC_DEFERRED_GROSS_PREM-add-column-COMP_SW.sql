/* Formatted on 3/1/2016 11:26:04 AM (QP5 v5.227.12220.39754) */
SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_deferred_gross_prem DROP CONSTRAINT gdefgros_pk';

   DBMS_OUTPUT.PUT_LINE ('dropped gdefgros_pk constraint.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP INDEX gdefgros_pk';

   DBMS_OUTPUT.PUT_LINE ('dropped gdefgros_pk index.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.GIAC_DEFERRED_GROSS_PREM ADD comp_sw  VARCHAR2(1)';

   DBMS_OUTPUT.PUT_LINE (
      'Successfully added comp_sw column to GIAC_DEFERRED_GROSS_PREM table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
BEGIN
   UPDATE GIAC_DEFERRED_GROSS_PREM
      SET COMP_SW = 'N'
    WHERE COMP_SW IS NULL;

   COMMIT;
END;
/
BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.giac_deferred_gross_prem MODIFY(comp_sw DEFAULT ''N'')';

   DBMS_OUTPUT.PUT_LINE ('Added default value for comp_sw.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE cpi.GIAC_DEFERRED_GROSS_PREM
                         ADD CONSTRAINT gdefgros_pk PRIMARY KEY (YEAR,mm,iss_cd,line_cd, procedure_id,comp_sw)';


   DBMS_OUTPUT.PUT_LINE ('Successfully added gdefgros_pk.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/