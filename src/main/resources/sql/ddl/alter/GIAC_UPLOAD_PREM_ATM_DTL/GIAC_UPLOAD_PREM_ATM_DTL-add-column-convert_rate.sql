SET serveroutput on;

DECLARE
   exists_tag   NUMBER := 0; 
BEGIN
   SELECT DISTINCT 1
              INTO exists_tag
              FROM all_tab_cols
             WHERE table_name = 'GIAC_UPLOAD_PREM_ATM_DTL'
               AND column_name = 'CONVERT_RATE'
               AND owner = 'CPI';

   IF exists_tag = 1 THEN
      DBMS_OUTPUT.put_line ('CONVERT_RATE column already exist at GIAC_UPLOAD_PREM_ATM_DTL table.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_UPLOAD_PREM_ATM_DTL ADD CONVERT_RATE NUMBER(12,9)';
      DBMS_OUTPUT.put_line ('Successfully added CONVERT_RATE column to GIAC_UPLOAD_PREM_ATM_DTL table.');
   WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.put_line ('CONVERT_RATE column already exist at GIAC_UPLOAD_PREM_ATM_DTL table.');
END;