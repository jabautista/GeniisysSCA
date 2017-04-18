DROP FUNCTION CPI.VERIFY_USER;

CREATE OR REPLACE FUNCTION CPI.Verify_User (
  username_in   IN   VARCHAR2,
  password_in   IN   VARCHAR2,
  dbstring      IN   VARCHAR2)
RETURN BOOLEAN AUTHID CURRENT_USER
AS
  dummy         dual.dummy%TYPE;
  retval        BOOLEAN           := TRUE;
BEGIN
  FOR a IN (
    SELECT DB_LINK
      FROM user_db_links)
  LOOP
    BEGIN
  	  EXECUTE IMMEDIATE ('DROP DATABASE LINK '||a.db_link);
	EXCEPTION
	  WHEN OTHERS THEN
	    NULL;
	END;
  END LOOP;

  retval := Verify_User_Dblink(username_in, password_in, dbstring);

  RETURN retval;
END;
/


