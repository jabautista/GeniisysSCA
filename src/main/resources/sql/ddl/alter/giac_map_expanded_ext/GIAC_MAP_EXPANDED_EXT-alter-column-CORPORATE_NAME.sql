/* benjo 12.07.2016 SR-5869 */
SET serveroutput ON

DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM all_tab_cols
    WHERE owner = 'CPI'
      AND table_name = 'GIAC_MAP_EXPANDED_EXT'
      AND column_name = 'CORPORATE_NAME'
      AND data_length = 250;

   EXECUTE IMMEDIATE 'ALTER TABLE giac_map_expanded_ext MODIFY corporate_name VARCHAR2(500)';

   DBMS_OUTPUT.put_line
                ('Successfully modified GIAC_MAP_EXPANDED_EXT.CORPORATE_NAME.');
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line
         ('GIAC_MAP_EXPANDED_EXT.CORPORATE_NAME with 250 data length does not exist.'
         );
END;