DROP PROCEDURE CPI.VERIFY_USER_OVERIDE;

CREATE OR REPLACE PROCEDURE CPI.verify_user_overide(
   p_username 						VARCHAR2,
   p_password						VARCHAR2,
   p_database						VARCHAR2,
   p_msg			OUT				VARCHAR2   
)
AUTHID CURRENT_USER
IS
   v_user_exist	   BOOLEAN;
BEGIN
   p_msg := 'OK';
   v_user_exist := verify_user(p_username, p_password, p_database);
   
   IF NOT(v_user_exist) THEN
    p_msg := 'Invalid username/password.';
   END IF;
   
END;
/


