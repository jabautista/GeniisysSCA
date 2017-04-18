CREATE OR REPLACE PACKAGE BODY CPI.Check_Password
AS
   FUNCTION check_is_digit (p_password IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_digit   GIIS_PARAMETERS.param_value_v%TYPE := Giisp.v ('DIGIT_ARRAY');
	  v_return VARCHAR2(10) := 'FALSE';
   BEGIN
      

      FOR i IN 1 .. LENGTH (Giisp.v ('DIGIT_ARRAY'))
      LOOP
         FOR j IN 1 .. LENGTH (p_password)
         LOOP
            IF SUBSTR (p_password, j, 1) = SUBSTR (v_digit, i, 1)
            THEN
               v_return := 'TRUE';
            END IF;
         END LOOP;
      END LOOP;
	  
	  RETURN (v_return);
   END;                                          --end function Check_Is_Digit

   FUNCTION check_is_char (p_password IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_char   GIIS_PARAMETERS.param_value_v%TYPE   := Giisp.v ('CHAR_ARRAY');
	  v_return VARCHAR2(10) := 'FALSE';
   BEGIN


      FOR i IN 1 .. LENGTH (Giisp.v ('CHAR_ARRAY'))
      LOOP
         FOR j IN 1 .. LENGTH (p_password)
         LOOP
            IF SUBSTR (p_password, j, 1) = SUBSTR (v_char, i, 1)
            THEN
               v_return := 'TRUE';
            END IF;
         END LOOP;
      END LOOP;
	  
	        RETURN (v_return);
   END;                                           --end function Check_Is_Char

   FUNCTION check_is_special_char (p_password IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_special_char   GIIS_PARAMETERS.param_value_v%TYPE:= Giisp.v ('SPECIAL_ARRAY');
	  v_return VARCHAR2(10) := 'FALSE';
   BEGIN
      

      FOR i IN 1 .. LENGTH (Giisp.v ('SPECIAL_ARRAY'))
      LOOP
         FOR j IN 1 .. LENGTH (p_password)
         LOOP
            IF SUBSTR (p_password, j, 1) = SUBSTR (v_special_char, i, 1)
            THEN
               v_return := 'TRUE';
            END IF;
         END LOOP;
      END LOOP;
	  
	  RETURN (v_return);
   END;                                   --end function Check_Is_Special_Char

   FUNCTION check_length (p_password IN VARCHAR2)
      RETURN BOOLEAN
   IS
      v_length   NUMBER := 8;                       --Minimum password Length
   BEGIN
      IF LENGTH (p_password) >= v_length
      THEN
         RETURN (TRUE);
      ELSE
         RETURN (FALSE);
      END IF;
   END;                                            --end function Check_Length

   FUNCTION check_inactivity (p_username IN VARCHAR2)
      RETURN BOOLEAN
   IS
      v_diff         NUMBER       := 0;
   BEGIN
   
      SELECT ROUND(SYSDATE - last_login, 2)
        INTO v_diff
        FROM GIIS_USERS
       WHERE user_id = UPPER(p_username);

      IF v_diff < 30
      THEN
         RETURN (TRUE);
      ELSE
         RETURN (FALSE);
      END IF;
   END;                                        --end function check_inactivity
END Check_Password;
/


