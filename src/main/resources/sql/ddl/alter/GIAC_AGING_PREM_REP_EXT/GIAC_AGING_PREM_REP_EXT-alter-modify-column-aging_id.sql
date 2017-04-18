/* Formatted on 11/18/2016 9:13:16 AM (QP5 v5.227.12220.39754) */
SET SERVEROUTPUT ON

DECLARE
   v_chk   VARCHAR2 (1) := 'N';
BEGIN
   FOR x
      IN (SELECT *
            FROM ALL_TAB_COLS
           WHERE     OWNER = 'CPI'
                 AND TABLE_NAME = 'GIAC_AGING_PREM_REP_EXT'
                 AND COLUMN_NAME = 'AGING_ID'
                 AND DATA_PRECISION = 4)
   LOOP
      v_chk := 'Y';
   END LOOP;

   IF v_chk = 'N'
   THEN
      EXECUTE IMMEDIATE
         ('ALTER TABLE CPI.GIAC_AGING_PREM_REP_EXT MODIFY AGING_ID NUMBER(4)');
         DBMS_OUTPUT.PUT_LINE('AGING_ID modified successfully.');
   ELSE
         DBMS_OUTPUT.PUT_LINE('AGING_ID is already set to NUMBER(4).');
   END IF;
END;