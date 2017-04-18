DROP FUNCTION CPI.CHECK_USER_ACCESS2;

CREATE OR REPLACE FUNCTION CPI.Check_User_Access2 (p_mod_id  VARCHAR2,
                            p_user_id GIIS_USERS.user_id%TYPE)
  RETURN NUMBER IS
  v_access_tag GIIS_USER_GRP_MODULES.access_tag%TYPE;
/* checks user access on modules to be called
** by bdarusin, 05/08/03. */
/*modified by dannelopt 100407
  check user gropu access before user access*/
BEGIN
  /*GIIS_MODULES.USER_ACCESS_TAG VALUES IN CG_REF_CODES :
     1 = Full Access
  2 = No Access  */
     
     FOR a IN (SELECT b.access_tag
        FROM GIIS_USERS a
           , GIIS_USER_GRP_MODULES b
       WHERE a.user_grp  = b.user_grp
         AND a.user_id   = p_user_id
         AND b.module_id = p_mod_id) LOOP
       v_access_tag := a.access_tag;
       EXIT;--dannelopt100407
  END LOOP;
  IF v_access_tag = 1 THEN
     RETURN 1;
 /* ELSIF v_access_tag = 2 THEN
  RETURN 0; */ -- jhing 04.09.2013 commented out 
  END IF;
    
  FOR a IN (SELECT b.access_tag
              FROM GIIS_USERS a
        , GIIS_USER_MODULES b
    WHERE a.user_id = b.userid
      AND a.user_id = p_user_id
      AND b.module_id = p_mod_id) LOOP
       v_access_tag := a.access_tag;
    EXIT; --dannelopt100407
  END LOOP;
  IF v_access_tag = 1 THEN
     RETURN 1;
  ELSIF v_access_tag = 2 THEN
  RETURN 0;
  END IF;
  
  RETURN 0;
END Check_User_Access2;
/


