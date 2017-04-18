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
      AND column_name = 'LATITUDE';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line ('GIPI_WFIREITM.LATITUDE already exist.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE gipi_wfireitm ADD latitude VARCHAR2(50)';

      EXECUTE IMMEDIATE 'COMMENT ON COLUMN CPI.GIPI_WFIREITM.LATITUDE IS ''Latitude coordinates of the location of risk.''';

      DBMS_OUTPUT.put_line ('Successfully added GIPI_WFIREITM.LATITUDE.');
END;