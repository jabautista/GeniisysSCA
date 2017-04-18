CREATE OR REPLACE PACKAGE CPI.Check_Password
AS
   FUNCTION check_is_digit (p_password IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION check_is_char (p_password IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION check_is_special_char (p_password IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION check_length (p_password IN VARCHAR2)
      RETURN BOOLEAN;

   FUNCTION check_inactivity (p_username IN VARCHAR2)
      RETURN BOOLEAN;
END Check_Password;
/


