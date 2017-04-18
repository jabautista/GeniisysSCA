CREATE OR REPLACE PACKAGE BODY CPI.Giis_User_Tran_Pkg AS

  FUNCTION get_giis_user_tran_list (p_userid    GIIS_USER_TRAN.userid%TYPE)
    RETURN giis_user_tran_tab PIPELINED IS

    v_user_tran    giis_user_tran_type;

  BEGIN
    FOR a IN (SELECT a.userid,  a.tran_cd, b.tran_desc,  a.access_tag
                FROM GIIS_USER_TRAN a,
                     GIIS_TRANSACTION b
                 WHERE a.tran_cd   = b.tran_cd
                   AND a.userid    = p_userid
               ORDER BY a.tran_cd)
    LOOP
      v_user_tran.userid       := a.userid;
      v_user_tran.tran_desc    := a.tran_desc;
      v_user_tran.tran_cd      := a.tran_cd;
      v_user_tran.access_tag   := a.access_tag;
      PIPE ROW(v_user_tran);
    END LOOP;
    RETURN;
  END get_giis_user_tran_list;


  PROCEDURE set_giis_user_tran (
    v_userid                        GIIS_USER_TRAN.userid%TYPE,
    v_tran_cd                       GIIS_USER_TRAN.tran_cd%TYPE,
    v_access_tag                    GIIS_USER_TRAN.access_tag%TYPE,
    v_session_user                  GIIS_USER_TRAN.user_id%TYPE) IS

  BEGIN

    MERGE INTO GIIS_USER_TRAN
    USING DUAL ON (userid      = v_userid
                   AND tran_cd = v_tran_cd  )

     WHEN NOT MATCHED THEN
            INSERT (userid,       tran_cd,     user_id,         last_update,     access_tag,
                    create_user,    create_date)
          VALUES (v_userid,       v_tran_cd,   v_session_user,  SYSDATE,         v_access_tag,
                  v_session_user, SYSDATE)
     WHEN MATCHED THEN
          UPDATE SET user_id       =   v_session_user,
                     last_update   =   SYSDATE,
                     access_tag    =   v_access_tag;
    COMMIT;
  END set_giis_user_tran;

  PROCEDURE del_giis_user_tran (p_userid	    	GIIS_USER_TRAN.userid%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_TRAN
      WHERE userid  = p_userid;

  END del_giis_user_tran;

END Giis_User_Tran_Pkg;
/


