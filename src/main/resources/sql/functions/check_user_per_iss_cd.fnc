--DROP FUNCTION CPI.CHECK_USER_PER_ISS_CD;

CREATE OR REPLACE FUNCTION CPI.Check_User_Per_Iss_Cd (p_line_cd   VARCHAR2,
                p_iss_cd    VARCHAR2,
                p_module_id VARCHAR2)
  RETURN NUMBER IS
  v_iss_cd_access NUMBER(1) := 0;
/* checks user access on iss cd to be called
** by bdarusin, 05/08/03. */
/*modified by dannelopt 100407
  check user group access before user access*/

/* MJ Fabroa 03/08/2013
** Changed RETURN v_iss_cd_access to RETURN 1
*/
  
BEGIN
  
  FOR a IN (
    SELECT c.access_tag
      FROM GIIS_USERS a,
           GIIS_USER_GRP_DTL b,
           GIIS_USER_GRP_MODULES c
     WHERE a.user_grp  = b.user_grp
       AND a.user_grp  = c.user_grp
       AND a.user_id   = NVL(giis_users_pkg.app_user, USER) --Added by Dren SR-5336 04.13.2016
       AND b.iss_cd    = NVL(p_iss_cd, b.iss_cd)
       AND b.tran_cd   = c.tran_cd
       AND c.module_id = p_module_id
       AND EXISTS (SELECT 1
                     FROM GIIS_USER_GRP_LINE
                    WHERE user_grp = b.user_grp
                      AND iss_cd   = b.iss_cd
                      AND tran_cd  = c.tran_cd
                      AND line_cd  = NVL(p_line_cd,line_cd))) 
  LOOP
    v_iss_cd_access := a.access_tag;
    EXIT; 
  END LOOP;
  IF v_iss_cd_access = 1 THEN
	 --RETURN 1; --editted by MJ for consolidation 01032013
	 --RETURN v_iss_cd_access;
	 RETURN 1;
  /*ELSIF v_iss_cd_access = 2 THEN
	 RETURN 0;*/ /*Removed by: jen.20120522 (1) Used v_iss_cd_access variable instead of hardcoded value(2)should check user access before return*/
  END IF;
  
  FOR a IN (
    SELECT c.access_tag
      FROM GIIS_USERS a,
           GIIS_USER_ISS_CD b,
           GIIS_USER_MODULES c
     WHERE a.user_id  = b.userid
       AND a.user_id  = c.userid
       AND a.user_id   = NVL(giis_users_pkg.app_user, USER) --Added by Dren SR-5336 06.17.2016
       AND b.iss_cd    = NVL(p_iss_cd, b.iss_cd)
       AND b.tran_cd   = c.tran_cd
       AND c.module_id = p_module_id
       AND EXISTS (SELECT 1
                     FROM GIIS_USER_LINE
                    WHERE userid = b.userid
                      AND iss_cd = b.iss_cd
                      AND tran_cd  = c.tran_cd
                      AND line_cd  = NVL(p_line_cd,line_cd))) 
  LOOP
    v_iss_cd_access := a.access_tag;
    EXIT;--dannelopt100407
  END LOOP;
  IF v_iss_cd_access = 1 THEN
	 --RETURN 1; --editted by MJ for consolidation 01032013
	 --RETURN v_iss_cd_access;
	 RETURN 1;
  ELSIF v_iss_cd_access = 2 THEN
	 RETURN 0;
  END IF;
  RETURN 0;
END Check_User_Per_Iss_Cd;
/