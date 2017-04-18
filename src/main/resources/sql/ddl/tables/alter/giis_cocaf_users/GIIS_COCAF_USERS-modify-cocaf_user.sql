DECLARE
    v_exists    NUMBER := 0;
BEGIN
	SELECT 1
	  INTO v_exists
      FROM all_tables
     WHERE owner = 'CPI'
       AND table_name = 'GIIS_COCAF_USERS';

    IF v_exists = 1 THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_COCAF_USERS MODIFY (COCAF_USER VARCHAR2(30))');
    END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('GIIS_COCAF_USERS table is not existing.');
END;