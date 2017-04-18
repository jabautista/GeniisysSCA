/* Formatted on 2015/06/17 16:35 (Formatter Plus v4.8.8) */
SET SERVEROUTPUT ON

DECLARE
   v_data_length   NUMBER := 0;
BEGIN
   SELECT data_length
     INTO v_data_length
     FROM all_tab_cols
    WHERE table_name = 'GIAC_TAXES_WHELD'
      AND column_name = 'GEN_TYPE'
      AND owner = 'CPI';

   IF v_data_length = 1
   THEN
      -- modify column if table and column are already existing
      EXECUTE IMMEDIATE ('ALTER TABLE GIAC_TAXES_WHELD MODIFY (GEN_TYPE VARCHAR2(2))');

      DBMS_OUTPUT.put_line
                          ('Column GEN_TYPE has been modified to VARCHAR2(2)');
   ELSIF v_data_length = 2
   THEN
      DBMS_OUTPUT.put_line
                     ('Data type and length of column GEN_TYPE is already VARCHAR2(2)');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      -- add column if column is not yet existing
      EXECUTE IMMEDIATE ('ALTER TABLE GIAC_TAXES_WHELD ADD GEN_TYPE VARCHAR2(2)');

      DBMS_OUTPUT.put_line
                   ('Column GEN_TYPE has been added to GIAC_TREATY_BATCH_EXT');
END;