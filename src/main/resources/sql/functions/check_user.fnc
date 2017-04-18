DROP FUNCTION CPI.CHECK_USER;

CREATE OR REPLACE FUNCTION CPI.Check_User (p_user    GIIS_MODULES_USER.user_id%TYPE,
                                       p_mod_id  GIIS_MODULES_USER.module_id%TYPE)
       RETURN VARCHAR2 IS
  v_acctag  VARCHAR2(1);
/* this function is created to check the validity of the
** user to access a certain module using the user's acces_tag
** found in giis_modules_user.
** by Pia, 11/12/01. */
BEGIN
  FOR atag IN (SELECT access_tag
                 FROM GIIS_MODULES_USER
                WHERE module_user_id = p_user
                  AND module_id = p_mod_id)
  LOOP
    v_acctag := atag.access_tag;
    EXIT;
  END LOOP;
  RETURN(NVL(v_acctag,'3'));
END;
/


