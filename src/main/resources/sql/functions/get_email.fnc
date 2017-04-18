DROP FUNCTION CPI.GET_EMAIL;

CREATE OR REPLACE FUNCTION CPI.Get_Email(p_user_id VARCHAR2)
RETURN VARCHAR2 AS
  v_email GIIS_USERS.email_address%TYPE:=NULL;
BEGIN
  FOR rec IN (
   SELECT email_address
     FROM cpi.GIIS_USERS
    WHERE user_id = p_user_id)
  LOOP
    v_email := rec.email_address;
    EXIT;
  END LOOP;
  RETURN (v_email);
END;
/


