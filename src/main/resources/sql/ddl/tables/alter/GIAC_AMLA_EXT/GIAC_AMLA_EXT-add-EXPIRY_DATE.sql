SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_tab_cols
    WHERE table_name = 'GIAC_AMLA_EXT'
      AND column_name = 'EXPIRY_DATE'
      AND owner = 'CPI';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                   ('Column EXPIRY_DATE already exist on table GIAC_AMLA_EXT.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE GIAC_AMLA_EXT ADD (expiry_date VARCHAR2 (8))';

      DBMS_OUTPUT.put_line
              ('Successfully added column EXPIRY_DATE to table GIAC_AMLA_EXT.');
END;