DECLARE
   v_count   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_count
     FROM all_tab_cols
    WHERE table_name = 'GIIS_USERS'
      AND column_name = 'INVALID_LOGIN_TRIES'
      AND owner = 'CPI';

   IF v_count = 1
   THEN
      DBMS_OUTPUT.put_line
         ('Column INVALID_LOGIN_TRIES already exists in table GIIS_USERS.'
         );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE GIIS_USERS ADD (INVALID_LOGIN_TRIES NUMBER(2) DEFAULT 0)';

      DBMS_OUTPUT.put_line
         ('Successfully added column INVALID_LOGIN_TRIES on table GIIS_USERS.'
         );
END;
/