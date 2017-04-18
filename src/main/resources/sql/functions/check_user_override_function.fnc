DROP FUNCTION CPI.CHECK_USER_OVERRIDE_FUNCTION;

CREATE OR REPLACE FUNCTION CPI.Check_User_Override_Function(
   p_user_id     IN giac_user_functions.user_id%TYPE,
   p_module_id   IN giac_modules.module_name%TYPE,
   p_function_cd IN giac_user_functions.function_code%TYPE)
RETURN BOOLEAN IS
BEGIN
  FOR rec IN (SELECT '1'
                FROM giac_user_functions a, giac_modules b , giac_functions c
               WHERE a.module_id = b.module_id
                 AND a.module_id = c.module_id
                 AND a.function_code = c.function_code
                 AND module_name = p_module_id
                 AND valid_tag = 'Y'
                 AND a.function_code = p_function_cd
                 AND a.user_id = p_user_id
                 AND TRUNC(validity_dt) < TRUNC(SYSDATE)
                 AND TRUNC(NVL(termination_dt, SYSDATE)) >= TRUNC(SYSDATE)
                 AND ROWNUM = 1)
  LOOP
   RETURN (TRUE);
  END LOOP;
  RETURN (FALSE);
END;
/


