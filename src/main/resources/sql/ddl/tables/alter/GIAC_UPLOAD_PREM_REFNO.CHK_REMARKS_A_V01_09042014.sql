SET serveroutput on;

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_tab_cols
    WHERE table_name = 'GIAC_UPLOAD_PREM_REFNO'
      AND column_name = 'CHK_REMARKS'
      AND owner = 'CPI'
      AND data_length >= 4000;

   DBMS_OUTPUT.put_line
      ('Length of column CHK_REMARKS of table GIAC_UPLOAD_PREM_REFNO is already greater than or equal to 4000.'
      );
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE cpi.giac_upload_prem_refno
                         MODIFY chk_remarks VARCHAR2(4000)';

      DBMS_OUTPUT.put_line
         ('Successfully modified column CHK_REMARKS of table GIAC_UPLOAD_PREM_REFNO.'
         );
END;