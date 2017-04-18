DROP FUNCTION CPI.SECURITY_GIPIS171;

CREATE OR REPLACE FUNCTION CPI.SECURITY_gIPIS171(p_module_id VARCHAR2) RETURN VARCHAR2 IS
  v_where   VARCHAR2(32767);
BEGIN
	FOR line IN (
  SELECT d.line_cd, B.iss_cd
    FROM GIIS_USERS         a
        , GIIS_USER_ISS_CD  b
        , GIIS_MODULES_TRAN c
		, GIIS_USER_LINE    d
   WHERE 1=1
     AND a.user_id  = b.userid
     AND a.user_id   = USER
     AND b.tran_cd   = c.tran_cd
     AND c.module_id = p_module_id
	   AND d.userid    = b.userid
	   AND d.iss_cd    = b.iss_cd
	   AND d.tran_cd   = b.tran_cd
  UNION
  SELECT d.line_cd, b.iss_cd
    FROM GIIS_USERS          a
        , GIIS_USER_GRP_DTL  b
        , GIIS_MODULES_TRAN  c
		    , GIIS_USER_GRP_LINE d
   WHERE 1=1
     AND a.user_id   = USER
     AND a.user_grp  = b.user_grp
     AND b.tran_cd   = c.tran_cd
     AND c.module_id = p_module_id
     AND d.user_grp = b.user_grp
     AND d.iss_cd   = b.iss_cd
     AND d.tran_cd  = b.tran_cd)
  LOOP
  	IF v_where IS NULL THEN
  		 v_where := 'AND ((line_cd = '''||line.line_cd||''' AND iss_cd = '''||line.iss_cd||''')';
  	ELSE
  		 v_where := v_where||' OR (line_cd = '''||line.line_cd||''' AND iss_cd = '''||line.iss_cd||''')';
  	END IF;
  END LOOP;
  IF v_where IS NULL THEN
  	 v_where := 'AND line_cd = NULL AND iss_cd = NULL';
  ELSE
  	 v_where := v_where||' )';
  END IF;
  RETURN(v_where);
END;
/


