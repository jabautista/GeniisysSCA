CREATE OR REPLACE PACKAGE BODY CPI.Giis_User_Line_Pkg AS

  FUNCTION get_giis_user_line_list (p_userid        GIIS_USER_LINE.userid%TYPE,
                                    p_tran          GIIS_USER_LINE.tran_cd%TYPE,
                                    p_iss_cd        GIIS_USER_LINE.iss_cd%TYPE)
    RETURN giis_user_line_tab PIPELINED IS

    v_user_line    giis_user_line_type;

  BEGIN
    FOR a IN (SELECT a.userid,  a.tran_cd, a.iss_cd, a.line_cd, b.line_name
                FROM GIIS_USER_LINE a,
                     GIIS_LINE b
               WHERE a.line_cd   = b.line_cd
                 AND a.userid    = p_userid
                 AND a.tran_cd   = p_tran
                 AND a.iss_cd    = p_iss_cd
               ORDER BY a.tran_cd, a.iss_cd, a.line_cd)
    LOOP
      v_user_line.userid       := a.userid;
      v_user_line.tran_cd      := a.tran_cd;
      v_user_line.iss_cd       := a.iss_cd;
      v_user_line.line_cd      := a.line_cd;
      v_user_line.line_name    := a.line_name;
      PIPE ROW(v_user_line);
    END LOOP;
    RETURN;
  END get_giis_user_line_list;

  FUNCTION get_giis_user_line_list (p_userid            GIIS_USER_LINE.userid%TYPE)
    RETURN giis_user_line_tab PIPELINED IS

	v_giis_user_line		  giis_user_line_type;

  BEGIN

    FOR i IN (select a.userid,  a.iss_cd,      a.tran_cd,     a.line_cd,      b.line_name,
 	   	  	 		 a.user_id, a.last_update, a.create_user, a.create_date
  				from giis_user_line a,
					 giis_line b
 			   where a.line_cd = b.line_cd
			     and a.userid = p_userid
			order by b.line_name)
	LOOP

	  v_giis_user_line.userid		:= i.userid;
	  v_giis_user_line.tran_cd		:= i.tran_cd;
	  v_giis_user_line.iss_cd		:= i.iss_cd;
	  v_giis_user_line.line_cd		:= i.line_cd;
	  v_giis_user_line.line_name	:= i.line_name;
	  v_giis_user_line.user_id		:= i.user_id;
	  v_giis_user_line.last_update	:= i.last_update;
	  v_giis_user_line.create_user	:= i.create_user;
	  v_giis_user_line.create_date	:= i.create_date;

	  PIPE ROW(v_giis_user_line);
	END LOOP;

	RETURN;
  END get_giis_user_line_list;


  PROCEDURE set_giis_user_line (
    v_userid                    GIIS_USER_LINE.userid%TYPE,
    v_tran_cd                   GIIS_USER_LINE.tran_cd%TYPE,
    v_line_cd                   GIIS_USER_LINE.line_cd%TYPE,
    v_iss_cd                    GIIS_USER_LINE.iss_cd%TYPE,
    v_session_user              GIIS_USER_LINE.user_id%TYPE) IS

  BEGIN

    MERGE INTO GIIS_USER_LINE
    USING DUAL ON (userid       = v_userid
                   AND tran_cd  = v_tran_cd
                   AND iss_cd   = v_iss_cd
                   AND line_cd  = v_line_cd)

     WHEN NOT MATCHED THEN
            INSERT (userid,         tran_cd,     iss_cd,      line_cd,         user_id,         last_update,
                    create_user,    create_date)
          VALUES (v_userid,         v_tran_cd,   v_iss_cd,    v_line_cd,       v_session_user,  SYSDATE,
                  v_session_user,   SYSDATE)
     WHEN MATCHED THEN
          UPDATE SET user_id       =   v_session_user,
                     last_update   =   SYSDATE;

  END set_giis_user_line;


  PROCEDURE del_giis_user_line (p_userid	    	GIIS_USER_LINE.userid%TYPE,
                                p_tran_cd	    	GIIS_USER_LINE.tran_cd%TYPE,
                                p_iss_cd	    	GIIS_USER_LINE.iss_cd%TYPE,
                                p_line_cd	    	GIIS_USER_LINE.line_cd%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_LINE
      WHERE userid  = p_userid
        AND tran_cd   = p_tran_cd
        AND iss_cd    = p_iss_cd
        AND line_cd   = p_line_cd;

  END del_giis_user_line;

  PROCEDURE del_giis_user_line (p_userid	    	GIIS_USER_LINE.userid%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_LINE
      WHERE userid  = p_userid;

  END del_giis_user_line;

END Giis_User_Line_Pkg;
/


