SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_tab_cols
    WHERE table_name = 'GIRI_WFRPS_RI'
      AND column_name = 'RI_WHOLDING_VAT'
      AND owner = 'CPI';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
              ('Column RI_WHOLDING_VAT already exist on table GIRI_WFRPS_RI.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE CPI.giri_wfrps_ri ADD (ri_wholding_vat NUMBER (12, 2))';

      DBMS_OUTPUT.put_line
         ('Successfully added column RI_WHOLDING_VAT to table GIRI_WFRPS_RI.');
END;