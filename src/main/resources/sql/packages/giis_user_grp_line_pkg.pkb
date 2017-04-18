CREATE OR REPLACE PACKAGE BODY CPI.Giis_User_Grp_Line_Pkg AS

  FUNCTION get_giis_user_grp_line_list (p_user_grp          GIIS_USER_GRP_LINE.user_grp%TYPE,
                                        p_user_grp_tran     GIIS_USER_GRP_LINE.tran_cd%TYPE,
                                        p_user_grp_iss_cd   GIIS_USER_GRP_LINE.iss_cd%TYPE)
    RETURN giis_user_grp_line_tab PIPELINED IS

    v_user_grp_line    giis_user_grp_line_type;

  BEGIN
    FOR a IN (SELECT a.user_grp,  a.tran_cd, a.iss_cd, a.line_cd, b.line_name, a.remarks
                FROM GIIS_USER_GRP_LINE a,
                     GIIS_LINE b
                 WHERE a.line_cd   = b.line_cd
                 AND a.user_grp  = p_user_grp
                 AND a.tran_cd   = p_user_grp_tran
                 AND a.iss_cd    = p_user_grp_iss_cd
               ORDER BY a.tran_cd, a.iss_cd, a.line_cd)
    LOOP
      v_user_grp_line.user_grp     := a.user_grp;
      v_user_grp_line.tran_cd      := a.tran_cd;
       v_user_grp_line.iss_cd       := a.iss_cd;
       v_user_grp_line.line_cd      := a.line_cd;
      v_user_grp_line.line_name    := a.line_name;
      v_user_grp_line.remarks       := a.remarks;
      PIPE ROW(v_user_grp_line);
    END LOOP;
    RETURN;
  END get_giis_user_grp_line_list;

  FUNCTION get_giis_user_grp_line_list (p_user_grp VARCHAR2)
    RETURN giis_user_grp_line_tab PIPELINED IS

	v_giis_user_grp_line		  giis_user_grp_line_type;

  BEGIN

    FOR i IN (select a.user_grp, a.iss_cd, a.tran_cd, a.line_cd, b.line_name,
 	   	  	 		 a.user_id, a.remarks, a.last_update, a.create_user, a.create_date
  				from giis_user_grp_line a,
					 giis_line b
 			   where a.line_cd = b.line_cd
			     and a.user_grp = p_user_grp
			order by b.line_name)
	LOOP

	  v_giis_user_grp_line.user_grp		:= i.user_grp;
	  v_giis_user_grp_line.tran_cd		:= i.tran_cd;
	  v_giis_user_grp_line.iss_cd		:= i.iss_cd;
	  v_giis_user_grp_line.line_cd		:= i.line_cd;
	  v_giis_user_grp_line.line_name	:= i.line_name;
	  v_giis_user_grp_line.remarks		:= i.remarks;
	  v_giis_user_grp_line.user_id		:= i.user_id;
	  v_giis_user_grp_line.last_update	:= i.last_update;
	  v_giis_user_grp_line.create_user	:= i.create_user;
	  v_giis_user_grp_line.create_date	:= i.create_date;

	  PIPE ROW(v_giis_user_grp_line);
	END LOOP;

	RETURN;
  END get_giis_user_grp_line_list;


  PROCEDURE set_giis_user_grp_line (
    v_user_grp                  GIIS_USER_GRP_LINE.user_grp%TYPE,
    v_tran_cd                   GIIS_USER_GRP_LINE.tran_cd%TYPE,
    v_line_cd                   GIIS_USER_GRP_LINE.line_cd%TYPE,
    v_iss_cd                    GIIS_USER_GRP_LINE.iss_cd%TYPE,
    v_remarks                   GIIS_USER_GRP_LINE.remarks%TYPE,
    v_session_user              GIIS_USER_GRP_LINE.user_id%TYPE) IS

  BEGIN

    MERGE INTO GIIS_USER_GRP_LINE
    USING DUAL ON (user_grp     = v_user_grp
                   AND tran_cd  = v_tran_cd
                   AND iss_cd   = v_iss_cd
                   AND line_cd  = v_line_cd)

     WHEN NOT MATCHED THEN
            INSERT (user_grp,       tran_cd,     iss_cd,      line_cd,         user_id,         last_update,
                  remarks,        create_user,    create_date)
          VALUES (v_user_grp,     v_tran_cd,   v_iss_cd,    v_line_cd,       v_session_user,  SYSDATE,
                  v_remarks,      v_session_user, SYSDATE)
     WHEN MATCHED THEN
          UPDATE SET user_id       =   v_session_user,
                     last_update   =   SYSDATE,
                     remarks       =   v_remarks;
    --COMMIT;
  END set_giis_user_grp_line;


  PROCEDURE del_giis_user_grp_line (p_user_grp	    	GIIS_USER_GRP_LINE.user_grp%TYPE,
                                    p_tran_cd	    	GIIS_USER_GRP_LINE.tran_cd%TYPE,
                                    p_iss_cd	    	GIIS_USER_GRP_LINE.iss_cd%TYPE,
                                    p_line_cd	    	GIIS_USER_GRP_LINE.line_cd%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_GRP_LINE
      WHERE user_grp  = p_user_grp
        AND tran_cd   = p_tran_cd
        AND iss_cd    = p_iss_cd
        AND line_cd   = p_line_cd;
    --COMMIT;

  END del_giis_user_grp_line;

  PROCEDURE del_giis_user_grp_line (p_user_grp	    	GIIS_USER_GRP_LINE.user_grp%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_GRP_LINE
      WHERE user_grp  = p_user_grp;
    --COMMIT;

  END del_giis_user_grp_line;

END Giis_User_Grp_Line_Pkg;
/


