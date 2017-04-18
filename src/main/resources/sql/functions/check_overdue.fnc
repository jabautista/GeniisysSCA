DROP FUNCTION CPI.CHECK_OVERDUE;

CREATE OR REPLACE FUNCTION CPI.check_overdue (p_func_name VARCHAR2, p_module_id VARCHAR2, p_user VARCHAR2)
   RETURN VARCHAR2
IS
   v_select   VARCHAR2 (1) := NULL;
BEGIN
   FOR rec IN (SELECT '1' one
                 FROM giac_user_functions a, giac_modules b,
                      giac_functions c
                WHERE a.module_id = b.module_id
                  AND a.module_id = c.module_id
                  AND a.function_code = c.function_code
                  AND module_name = p_module_id--'GICLS010'
                  AND valid_tag = 'Y'
                  AND c.function_name = p_func_name --'OVERDUE_PREMIUM_OVERRIDE'
                  AND a.user_id = p_user
                  AND validity_dt < SYSDATE
                  AND NVL (termination_dt, SYSDATE) >= SYSDATE
                  AND ROWNUM = 1)
   LOOP
      v_select := rec.one;
   END LOOP;

   IF v_select = '1'
   THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END;
/


