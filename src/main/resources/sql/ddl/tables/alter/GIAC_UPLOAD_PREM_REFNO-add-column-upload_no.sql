SET serveroutput on;

DECLARE
   exists_tag   NUMBER := 0;
BEGIN
   SELECT DISTINCT 1
              INTO exists_tag
              FROM all_tab_cols
             WHERE table_name = 'GIAC_UPLOAD_PREM_REFNO'
               AND column_name = 'UPLOAD_NO'
               AND owner = 'CPI';

   IF exists_tag = 1
   THEN
      DBMS_OUTPUT.put_line
           ('UPLOAD_NO column already exist at GIAC_UPLOAD_PREM_REFNO table.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_UPLOAD_PREM_REFNO ADD UPLOAD_NO VARCHAR2(12)';

      DBMS_OUTPUT.put_line
         ('Successfully added UPLOAD_NO column to GIAC_UPLOAD_PREM_REFNO table.'
         );
   WHEN TOO_MANY_ROWS
   THEN
      DBMS_OUTPUT.put_line
           ('UPLOAD_NO column already exist at GIAC_UPLOAD_PREM_REFNO table.');
END;