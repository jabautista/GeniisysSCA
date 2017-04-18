SET SERVEROUTPUT ON

DECLARE
   v_data_length   NUMBER := 0;
BEGIN
   SELECT data_length
     INTO v_data_length
     FROM all_tab_cols
    WHERE table_name = 'GIIS_USERS'
      AND column_name = 'EMAIL_ADDRESS';

   IF v_data_length < 200
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE GIIS_USERS MODIFY (EMAIL_ADDRESS VARCHAR2(200 BYTE))';

      DBMS_OUTPUT.put_line
         ('Successfully modified data length of column EMAIL_ADDRESS on table GIIS_USERS to 200.'
         );
   ELSE
      DBMS_OUTPUT.put_line
         ('Data length of column EMAIL_ADDRESS on table GIIS_USERS is already greater than or equal to 200.'
         );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE GIIS_USERS ADD (EMAIL_ADDRESS VARCHAR2(200 BYTE))';

      DBMS_OUTPUT.put_line
                ('Successfully added column EMAIL_ADDRESS to table GIIS_USERS.');
END; --Dren 02.19.2016 SR-21366 