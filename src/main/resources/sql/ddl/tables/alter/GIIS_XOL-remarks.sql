SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_tab_columns
    WHERE UPPER(column_name) = 'REMARKS'
      AND UPPER(table_name) = 'GIIS_XOL'
      AND owner = 'CPI';

   IF v_exist = 1 THEN
      DBMS_OUTPUT.put_line ('Column REMARKS is already existing in GIIS_XOL table.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      EXECUTE IMMEDIATE 'ALTER TABLE GIIS_XOL ADD REMARKS VARCHAR2(4000)';
      DBMS_OUTPUT.put_line ('Column REMARKS created in GIIS_XOL.');
END;