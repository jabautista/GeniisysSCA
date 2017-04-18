DROP FUNCTION CPI.CHECK_USER_OVERRIDE;

CREATE OR REPLACE FUNCTION CPI.check_user_override(
   p_user_id     IN giis_override_users.user_id%TYPE,
   p_module_id   IN giis_modules.module_id%TYPE)
RETURN BOOLEAN IS
  v_dummy          NUMBER;
BEGIN
  SELECT 1
    INTO v_dummy
    FROM giis_modules                 a,
         giis_override_users           c
   WHERE 1=1
     AND a.module_id         =    p_module_id
     AND a.module_id         =   c.module_id
     AND c.userid              =  p_user_id
     AND NVL(c.override_tag,'N')= 'Y'
     AND TRUNC(c.validity_dt) <= TRUNC(SYSDATE)
     AND (TRUNC(c.termination_dt) > SYSDATE OR
          TRUNC(c.termination_dt) IS NULL);
  RETURN(TRUE);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN(FALSE);
END check_user_override;
/


