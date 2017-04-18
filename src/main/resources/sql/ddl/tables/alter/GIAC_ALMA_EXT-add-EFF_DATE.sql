SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_tab_cols
    WHERE table_name = 'GIAC_ALMA_EXT'
      AND column_name = 'EFF_DATE'
      AND owner = 'CPI';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                      ('Column EFF_DATE already exist on table GIAC_ALMA_EXT.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE giac_alma_ext ADD (eff_date VARCHAR2 (8))';

      DBMS_OUTPUT.put_line
                 ('Successfully added column EFF_DATE to table GIAC_ALMA_EXT.');
END;