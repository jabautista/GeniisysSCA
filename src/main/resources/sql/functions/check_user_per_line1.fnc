DROP FUNCTION CPI.CHECK_USER_PER_LINE1;

CREATE OR REPLACE FUNCTION CPI.check_user_per_line1(p_line_cd  VARCHAR2
                    , p_iss_cd   VARCHAR2
					, p_user_id	 VARCHAR2
                    , p_module_id VARCHAR2)
  RETURN NUMBER IS
  v_line_access NUMBER(1) := 0;
/* checks user access on line to be called
** by bdarusin, 05/08/03. */
/* check user group first before user access
   modified by dannelopt 100307*/
BEGIN
  FOR a IN (
  SELECT c.access_tag
    FROM GIIS_USERS a
        , GIIS_USER_GRP_LINE b
        , GIIS_USER_GRP_MODULES c
   WHERE a.user_grp  = b.user_grp
     AND a.user_grp  = c.user_grp
     AND a.user_id   = p_user_id
     AND b.iss_cd    = NVL(p_iss_cd,b.iss_cd)
     AND b.line_cd   = NVL(p_line_cd, b.line_cd)
     AND b.tran_cd   = c.tran_cd
     AND c.module_id = p_module_id) LOOP
    v_line_access := a.access_tag;
   EXIT;
  END LOOP;
  IF v_line_access = 1 THEN
  RETURN 1;
  ELSIF v_line_access = 2 THEN
  RETURN 0;
  END IF;

  FOR a IN (
  SELECT c.access_tag
    FROM GIIS_USERS a
        , GIIS_USER_LINE b
        , GIIS_USER_MODULES c
   WHERE a.user_id  = b.userid
     AND a.user_id  = c.userid
     AND a.user_id   = p_user_id
     AND b.iss_cd    = NVL(p_iss_cd,b.iss_cd)
     AND b.line_cd   = NVL(p_line_cd, b.line_cd)
     AND b.tran_cd   = c.tran_cd
     AND c.module_id = p_module_id) LOOP
    v_line_access := a.access_tag;
 EXIT;
  END LOOP;
  IF v_line_access = 1 THEN
  RETURN 1;
  ELSIF v_line_access = 2 THEN
  RETURN 0;
  END IF;
  RETURN 0;
END check_user_per_line1;
/


