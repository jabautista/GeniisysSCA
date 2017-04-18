/* benjo 01.10.2017 SR-5749 */
SET serveroutput ON

DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE owner = 'CPI'
      AND table_name = 'GIPI_WFIREITM'
      AND column_name = 'LONGITUDE';

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE gipi_wfireitm DROP COLUMN longitude';

      DBMS_OUTPUT.put_line ('GIPI_WFIREITM.LONGITUDE successfully dropped.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('GIPI_WFIREITM.LONGITUDE does not exist.');
END;