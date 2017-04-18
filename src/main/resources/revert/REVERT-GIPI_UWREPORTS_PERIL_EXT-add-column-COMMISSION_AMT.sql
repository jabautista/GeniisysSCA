SET SERVEROUTPUT ON

DECLARE
   V_EXISTS   VARCHAR2 (1) := 'N';
BEGIN
   FOR X
      IN (SELECT 1
            FROM all_tab_cols
           WHERE     OWNER = 'CPI'
                 AND TABLE_NAME = 'GIPI_UWREPORTS_PERIL_EXT'
                 AND COLUMN_NAME = 'COMMISSION_AMT')
   LOOP
      V_EXISTS := 'Y';
   END LOOP;

   IF V_EXISTS = 'Y'
   THEN
      EXECUTE IMMEDIATE
         'ALTER TABLE CPI.GIPI_UWREPORTS_PERIL_EXT DROP COLUMN COMMISSION_AMT';
         
       DBMS_OUTPUT.PUT_LINE (
         'Column COMMISSION_AMT successfully dropped from table CPI.GIPI_UWREPORTS_PERIL_EXT.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         'Column COMMISSION_AMT does not exists in table CPI.GIPI_UWREPORTS_PERIL_EXT.');
     
   END IF;
END;