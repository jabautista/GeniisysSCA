SET serveroutput on;

DECLARE
   exists_tag   NUMBER := 0;
BEGIN
   SELECT DISTINCT 1
              INTO exists_tag
              FROM all_tab_cols
             WHERE table_name = 'GIAC_UPLOAD_INWFACUL_PREM'
               AND column_name = 'RI_CD'
               AND owner = 'CPI';

   IF exists_tag = 1
   THEN
      DBMS_OUTPUT.put_line
            ('RI_CD column already exist at GIAC_UPLOAD_INWFACUL_PREM table.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_UPLOAD_INWFACUL_PREM ADD RI_CD NUMBER(5)';

      DBMS_OUTPUT.put_line
         ('Successfully added RI_CD column to GIAC_UPLOAD_INWFACUL_PREM table.'
         );
   WHEN TOO_MANY_ROWS
   THEN
      DBMS_OUTPUT.put_line
            ('RI_CD column already exist at GIAC_UPLOAD_INWFACUL_PREM table.');
END;