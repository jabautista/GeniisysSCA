SET serveroutput on;

DECLARE
   exists_tag   NUMBER := 0;
BEGIN
   SELECT DISTINCT 1
              INTO exists_tag
              FROM all_tab_cols
             WHERE table_name = 'GIAC_UPLOAD_PREM_ATM_DTL'
               AND column_name = 'CURRENCY_CD'
               AND owner = 'CPI';

   IF exists_tag = 1 THEN
      DBMS_OUTPUT.put_line ('CURRENCY_CD column already exist at GIAC_UPLOAD_PREM_ATM_DTL table.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_UPLOAD_PREM_ATM_DTL ADD CURRENCY_CD NUMBER(2)';
      DBMS_OUTPUT.put_line ('Successfully added CURRENCY_CD column to GIAC_UPLOAD_PREM_ATM_DTL table.');
   WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.put_line ('CURRENCY_CD column already exist at GIAC_UPLOAD_PREM_ATM_DTL table.');
END;