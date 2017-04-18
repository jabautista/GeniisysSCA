DROP FUNCTION CPI.VERIFY_USER_DBLINK;

CREATE OR REPLACE FUNCTION CPI.Verify_User_Dblink (
  username_in   IN   VARCHAR2,
  password_in   IN   VARCHAR2,
  dbstring      IN   VARCHAR2)
RETURN BOOLEAN AUTHID CURRENT_USER
AS
  dummy         dual.dummy%TYPE;
  linkname      VARCHAR2 (34)     :='TMP$'||username_in;
  retval        BOOLEAN           := TRUE;
  v_dblink_seq  NUMBER;
  v_dbname  VARCHAR2(16);
  no_listener   EXCEPTION;
  inv_passwrd   EXCEPTION;
  dup_dblink    EXCEPTION;
  PRAGMA EXCEPTION_INIT (no_listener, -12541);
  PRAGMA EXCEPTION_INIT (inv_passwrd, -01017);
  PRAGMA EXCEPTION_INIT (inv_passwrd, -2011);
BEGIN

  SELECT dblink_user.NEXTVAL
    INTO v_dblink_seq
 FROM dual;

  linkname := linkname||v_dblink_seq;
/* verify_user: given a username, password, and connect string,
|| this function returns TRUE if a connection to the database
|| succeeds.
||
|| Creates and destroys a database link named 'tmp$' || username_in
||
|| Requires Net8; raises -20001 exception if Net8 is not up.
*/
--  BEGIN
--    EXECUTE IMMEDIATE 'DROP DATABASE LINK ' || linkname;
  --EXCEPTION
  -- WHEN OTHERS THEN
  --   NULL;
--  END;

  EXECUTE IMMEDIATE 'ALTER SESSION SET GLOBAL_NAMES=FALSE';

  BEGIN
    EXECUTE IMMEDIATE    'CREATE DATABASE LINK '
                      || linkname
                         || ' CONNECT TO '
                      || username_in
                      || ' IDENTIFIED BY "' --replace by jess 10.28.2009, add double quote
                      || password_in  	 	-- in password_in to accept password that starts with a number
                      || '" USING '''		-- add double quote
                      || dbstring
       || '''';
  END;

  BEGIN
    EXECUTE IMMEDIATE 'SELECT DUMMY FROM DUAL@' || linkname;
  EXCEPTION
    WHEN OTHERS THEN
     retval := FALSE;
  END;
 /**added by: ging 032707 **/
  ROLLBACK; --to allow closing of database link
  IF retval THEN --added condition to prevent closing of unopened database link which triggers ORA-02081 error by MAC 04/11/2012
  EXECUTE IMMEDIATE 'ALTER SESSION CLOSE DATABASE LINK '||linkname; --to close the session created by the dblink
  END IF;
 /*DB link closed*/
  EXECUTE IMMEDIATE 'ALTER SESSION SET GLOBAL_NAMES=TRUE';
  EXECUTE IMMEDIATE 'DROP DATABASE LINK '||linkname;
  RETURN retval;
END;
/


