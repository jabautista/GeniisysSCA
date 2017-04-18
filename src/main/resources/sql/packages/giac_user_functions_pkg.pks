CREATE OR REPLACE PACKAGE CPI.GIAC_USER_FUNCTIONS_PKG
AS
   FUNCTION validate_user (
      p_function_code    GIAC_FUNCTIONS.function_code%TYPE,
      p_function_name    GIAC_FUNCTIONS.function_name%TYPE,
      p_module_name      GIAC_MODULES.module_name%TYPE,
      p_valid_tag        GIAC_USER_FUNCTIONS.valid_tag%TYPE)
      RETURN VARCHAR2;

   FUNCTION check_if_user_has_function (
      p_function_cd    GIAC_FUNCTIONS.function_code%TYPE,
      p_module_name    GIAC_MODULES.module_name%TYPE,
      p_user_id        GIAC_USER_FUNCTIONS.user_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION validate_user2 (
      p_function_code    GIAC_FUNCTIONS.function_code%TYPE,
      p_function_name    GIAC_FUNCTIONS.function_name%TYPE,
      p_module_name      GIAC_MODULES.module_name%TYPE,
      p_valid_tag        GIAC_USER_FUNCTIONS.valid_tag%TYPE,
      p_user_id          GIAC_USER_FUNCTIONS.user_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION check_overdue (p_func_name    VARCHAR2,
                           p_module_id    VARCHAR2,
                           p_user         VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION CHECK_OVR_CSR (p_user_id GIIS_USERS.user_id%TYPE)
      RETURN BOOLEAN;

   FUNCTION validate_user3 (
      p_user_id       IN giac_users.user_id%TYPE,
      p_function_cd   IN giac_functions.function_code%TYPE,
      p_module_name   IN giac_modules.module_name%TYPE,
      p_valid_tag     IN VARCHAR2)
      RETURN VARCHAR2;
	  
   PROCEDURE check_user_validity (
      p_user_id       IN        giac_user_functions.user_id%TYPE,
      p_validity_dt      OUT    VARCHAR2,
      p_termination_dt   OUT    VARCHAR2,
      p_valid_tag        OUT    VARCHAR2
   );
   
END GIAC_USER_FUNCTIONS_PKG;
/


