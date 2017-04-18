SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_tables
    WHERE table_name = 'GIAC_ALMA_EXT'
      AND owner = 'CPI';

   IF v_exist = 1
   THEN
   
      EXECUTE IMMEDIATE
      'ALTER TABLE GIAC_ALMA_EXT
      RENAME TO GIAC_AMLA_EXT';
      
      DBMS_OUTPUT.put_line('TABLE GIAC_ALMA_EXT renamed to GIAC_AMLA_EXT.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN

      DBMS_OUTPUT.put_line('TABLE GIAC_ALMA_EXT does not exist.');
END;