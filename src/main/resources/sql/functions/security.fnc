DROP FUNCTION CPI.SECURITY;

CREATE OR REPLACE FUNCTION CPI.SECURITY(p_module_id VARCHAR2,
										p_user_id	GIIS_USERS.user_id%TYPE) RETURN VARCHAR2 IS
  v_where   VARCHAR2(32767);
  p_user_sw VARCHAR2(1):='N';
BEGIN
    FOR x IN (SELECT '1'
                FROM giis_users
               WHERE user_id = NVL(p_user_id, USER)
                 AND NVL(all_user_sw,'N') = 'Y')
    LOOP
        p_user_sw := 'Y';
        EXIT;
    END LOOP;
    FOR line IN (SELECT DISTINCT line_cd, iss_cd, underwriter
                 FROM gipi_pack_parlist gp
                WHERE 1=1
                  AND assign_sw = 'Y'
                  AND par_status NOT IN (10,99,98)
                  AND par_type = 'P'
                  AND ((underwriter = NVL(p_user_id, USER) AND p_user_sw = 'N') OR p_user_sw = 'Y') 
                  AND EXISTS (
                        SELECT d.line_cd, b.iss_cd
                          FROM giis_users         a
                             , giis_user_iss_cd  b
                             , giis_modules_tran c
                             , giis_user_line    d
                         WHERE 1=1
                           AND a.user_id  = b.userid
                           AND a.user_id   = NVL(p_user_id, USER)
                           AND b.tran_cd   = c.tran_cd
                           AND c.module_id = p_module_id
                             AND d.userid    = b.userid
                             AND d.iss_cd    = b.iss_cd
                             AND d.tran_cd   = b.tran_cd
                             AND d.line_cd   = gp.line_cd
                             AND d.iss_cd    = gp.iss_cd
                       UNION
                        SELECT d.line_cd, b.iss_cd
                          FROM giis_users          a
                             , giis_user_grp_dtl  b
                             , giis_modules_tran  c
                             , giis_user_grp_line d
                         WHERE 1=1
                           AND a.user_id   = NVL(p_user_id, USER)
                           AND a.user_grp  = b.user_grp
                           AND b.tran_cd   = c.tran_cd
                           AND c.module_id = p_module_id
                           AND d.user_grp = b.user_grp
                           AND d.iss_cd   = b.iss_cd
                           AND d.tran_cd  = b.tran_cd
                           AND d.line_cd    = gp.line_cd
                           AND d.iss_cd     = gp.iss_cd))
  LOOP
      IF v_where IS NULL THEN
           v_where := '((line_cd = '''||line.line_cd||''' AND iss_cd = '''||line.iss_cd||'''AND underwriter = '''||line.underwriter||''')';
      ELSE
           v_where := v_where||' OR (line_cd = '''||line.line_cd||''' AND iss_cd = '''||line.iss_cd||''')';
      END IF;
  END LOOP;
  IF v_where IS NOT NULL THEN
       v_where := v_where||' )';
  ELSE
       v_where := ' line_cd = NULL AND iss_cd = NULL ';
  END IF;
  RETURN(v_where);
END;
/


