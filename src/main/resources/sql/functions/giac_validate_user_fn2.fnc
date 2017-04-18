DROP FUNCTION CPI.GIAC_VALIDATE_USER_FN2;

CREATE OR REPLACE FUNCTION CPI.giac_validate_user_fn2(
  p_user_id             IN giac_users.user_id%TYPE,
  p_function_name       IN giac_functions.function_name%TYPE,
  p_module_name         IN giac_modules.module_name%TYPE
  )
RETURN VARCHAR2 IS 
  v_select VARCHAR2(1) := NULL;
BEGIN
    FOR rec IN (SELECT '1' one
                  FROM giac_user_functions a, giac_modules b , giac_functions c
                 WHERE a.module_id = b.module_id 
                   AND a.module_id = c.module_id
                   AND a.function_code = c.function_code
                   AND module_name = p_module_name
                   AND valid_tag = 'Y'
                   AND c.function_name = p_function_name
                   AND a.user_id = p_user_id
                   AND validity_dt < SYSDATE
                   AND NVL(termination_dt, SYSDATE) >= SYSDATE
                   AND ROWNUM = 1)
    LOOP 
        v_select := rec.one;
    END LOOP; 
    IF v_select = '1' THEN
        RETURN('TRUE');
    ELSE
        RETURN('FALSE');
    END IF;
END;
/


