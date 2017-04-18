SET SERVEROUTPUT ON

DECLARE
   v_data_length   NUMBER := 0;
BEGIN
   SELECT data_length
     INTO v_data_length
     FROM all_tab_cols
    WHERE table_name = 'GIAC_ALMA_EXT'
      AND column_name = 'ADDRESS1'
      AND owner = 'CPI';

   IF v_data_length < 50
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE giac_alma_ext MODIFY (address1 VARCHAR2(50 BYTE))';

      DBMS_OUTPUT.put_line
         ('Successfully modified data length of column ADDRESS1 on table GIAC_ALMA_EXT to 50.'
         );
   ELSE
      DBMS_OUTPUT.put_line
         ('Data length of column ADDRESS1 on table GIAC_ALMA_EXT is already greater than or equal to 50.'
         );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE giac_alma_ext ADD (address1 VARCHAR2(50 BYTE))';

      DBMS_OUTPUT.put_line
                ('Successfully added column ADDRESS1 to table GIAC_ALMA_EXT.');
END;

DECLARE
   v_data_length   NUMBER := 0;
BEGIN
   SELECT data_length
     INTO v_data_length
     FROM all_tab_cols
    WHERE table_name = 'GIAC_ALMA_EXT'
      AND column_name = 'ADDRESS2'
      AND owner = 'CPI';

   IF v_data_length < 50
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE giac_alma_ext MODIFY (address2 VARCHAR2(50 BYTE))';

      DBMS_OUTPUT.put_line
         ('Successfully modified data length of column ADDRESS2 on table GIAC_ALMA_EXT to 50.'
         );
   ELSE
      DBMS_OUTPUT.put_line
         ('Data length of column ADDRESS2 on table GIAC_ALMA_EXT is already greater than or equal to 50.'
         );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE giac_alma_ext ADD (address2 VARCHAR2(50 BYTE))';

      DBMS_OUTPUT.put_line
                ('Successfully added column ADDRESS2 to table GIAC_ALMA_EXT.');
END;