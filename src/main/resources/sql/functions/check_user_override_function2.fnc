DROP FUNCTION CPI.CHECK_USER_OVERRIDE_FUNCTION2;

CREATE OR REPLACE FUNCTION CPI.check_user_override_function2(
   p_user_id     IN giac_user_functions.user_id%TYPE,
   p_module_id   IN giac_modules.module_name%TYPE,
   p_function_cd IN giac_user_functions.function_code%TYPE)
RETURN VARCHAR2 IS
BEGIN
  -- marco - 01.22.2014 - check validity of accounting user - SR FGIC-WEB 3338
  FOR rec IN(SELECT 1
               FROM giac_users
              WHERE user_id = p_user_id
                AND (active_tag = 'N' OR SYSDATE NOT BETWEEN TRUNC(active_dt) AND TRUNC(NVL(inactive_dt, SYSDATE+1))))
  LOOP
    RETURN ('FALSE');
  END LOOP; 

  FOR rec IN (SELECT '1'
                FROM giac_user_functions a, giac_modules b , giac_functions c
               WHERE a.module_id = b.module_id
                 AND a.module_id = c.module_id
                 AND a.function_code = c.function_code
                 AND module_name = p_module_id
                 AND valid_tag = 'Y'
                 AND a.function_code = p_function_cd
                 AND a.user_id = p_user_id
                 AND validity_dt < SYSDATE
                 --AND (TRUNC(NVL(termination_dt, SYSDATE)) >= TRUNC(SYSDATE) --added by steven 09.10.2014; TRUNC --Commented out by Jerome Bautista 11.02.2015 SR 3338
                       --OR termination_dt IS NULL)   --added by d.alcantara, 04-24-2012 --Commented out by Jerome Bautista 11.02.2015 SR 3338
                 AND (a.termination_dt >= SYSDATE OR a.termination_dt IS NULL) --Added by Jerome Bautista 11.02.2015 SR 3338
                 AND ROWNUM = 1)
  LOOP
   RETURN ('TRUE');
  END LOOP;
  RETURN ('FALSE');
END;
/


