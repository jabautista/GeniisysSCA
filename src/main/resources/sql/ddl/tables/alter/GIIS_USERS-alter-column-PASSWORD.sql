/* Formatted on 3/2/2016 6:30:02 PM (QP5 v5.227.12220.39754) */
SET SERVEROUTPUT ON;

BEGIN
   EXECUTE IMMEDIATE 'ALTER TABLE giis_users MODIFY password VARCHAR2(1000)';
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR: ' || SQLERRM);
END;