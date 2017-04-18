CREATE OR REPLACE PACKAGE BODY CPI.Giis_User_Grp_Tran_Pkg AS

  FUNCTION get_giis_user_grp_tran_list (p_user_grp    GIIS_USER_GRP_HDR.user_grp%TYPE)
    RETURN giis_user_grp_tran_tab PIPELINED IS

    v_user_grp_tran    giis_user_grp_tran_type;

  BEGIN
    FOR a IN (SELECT a.user_grp,  a.tran_cd, b.tran_desc, a.remarks,  a.access_tag
                FROM GIIS_USER_GRP_TRAN a,
                     GIIS_TRANSACTION b
                 WHERE a.tran_cd   = b.tran_cd
                 AND a.user_grp  = p_user_grp
               ORDER BY a.tran_cd)
    LOOP
      v_user_grp_tran.user_grp     := a.user_grp;
      v_user_grp_tran.tran_desc    := a.tran_desc;
      v_user_grp_tran.tran_cd      := a.tran_cd;
      v_user_grp_tran.remarks      := a.remarks;
      v_user_grp_tran.access_tag      := a.access_tag;
      PIPE ROW(v_user_grp_tran);
    END LOOP;
    RETURN;
  END get_giis_user_grp_tran_list;


  PROCEDURE set_giis_user_grp_tran (
    v_user_grp                      GIIS_USER_GRP_TRAN.user_grp%TYPE,
    v_tran_cd                       GIIS_USER_GRP_TRAN.tran_cd%TYPE,
    v_remarks                       GIIS_USER_GRP_TRAN.remarks%TYPE,
    v_access_tag                    GIIS_USER_GRP_TRAN.access_tag%TYPE,
    v_session_user                  GIIS_USER_GRP_TRAN.user_id%TYPE) IS

  BEGIN

    MERGE INTO GIIS_USER_GRP_TRAN
    USING DUAL ON (user_grp    = v_user_grp
                   AND tran_cd = v_tran_cd  )

     WHEN NOT MATCHED THEN
            INSERT (user_grp,       tran_cd,     user_id,         last_update,    remarks,       access_tag,
                  create_user,    create_date)
          VALUES (v_user_grp,     v_tran_cd,   v_session_user,  SYSDATE,        v_remarks,     v_access_tag,
                  v_session_user, SYSDATE)
     WHEN MATCHED THEN
          UPDATE SET user_id       =   v_session_user,
                     last_update   =   SYSDATE,
                     remarks       =   v_remarks,
                     access_tag    =   v_access_tag;
    --COMMIT;
  END set_giis_user_grp_tran;

  PROCEDURE del_giis_user_grp_tran (p_user_grp	    	GIIS_USER_GRP_TRAN.user_grp%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_GRP_TRAN
      WHERE user_grp  = p_user_grp;
    --COMMIT;

  END del_giis_user_grp_tran;

END Giis_User_Grp_Tran_Pkg;
/


