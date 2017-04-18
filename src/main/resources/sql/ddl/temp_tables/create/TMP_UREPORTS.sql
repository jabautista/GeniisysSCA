SET SERVEROUTPUT ON

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_objects
    WHERE object_name = 'TMP_UREPORTS' AND owner = 'CPI';

   DBMS_OUTPUT.put_line (
      'The global temporary table TMP_UREPORTS is already existing in the database. ');
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE
         (   ' CREATE GLOBAL TEMPORARY TABLE CPI.TMP_UREPORTS  '
          || ' (  '
          || ' POLICY_ID      NUMBER(12), '
          || ' ITEM_GRP       NUMBER(5), '
          || 'TAKEUP_SEQ_NO  NUMBER(3), '
          || ' CURRENCY_RT    NUMBER(12,9), '
          || '  LINE_CD        VARCHAR2(2 BYTE), '
          || '  USER_ID        VARCHAR2(8 BYTE) '
          || ' )  '
          || ' ON COMMIT PRESERVE ROWS');

      DBMS_OUTPUT.put_line (
         'The global temporary table TMP_UREPORTS is successfully created.');
END;