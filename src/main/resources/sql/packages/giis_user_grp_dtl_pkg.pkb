CREATE OR REPLACE PACKAGE BODY CPI.Giis_User_Grp_Dtl_Pkg AS

  FUNCTION get_giis_user_grp_dtl_list (p_user_grp        GIIS_USER_GRP_DTL.user_grp%TYPE,
                                       p_user_grp_tran   GIIS_USER_GRP_DTL.tran_cd%TYPE)
    RETURN giis_user_grp_dtl_tab PIPELINED IS

    v_user_grp_dtl    giis_user_grp_dtl_type;

  BEGIN
    FOR a IN (SELECT a.user_grp,  a.tran_cd, a.iss_cd, b.iss_name, a.remarks
                FROM GIIS_USER_GRP_DTL a,
                     GIIS_ISSOURCE b
                 WHERE a.iss_cd    = b.iss_cd
                 AND a.user_grp  = p_user_grp
                 AND a.tran_cd   = p_user_grp_tran
               ORDER BY a.tran_cd, a.iss_cd)
    LOOP
      v_user_grp_dtl.user_grp     := a.user_grp;
      v_user_grp_dtl.tran_cd      := a.tran_cd;
       v_user_grp_dtl.iss_cd       := a.iss_cd;
      v_user_grp_dtl.iss_name     := a.iss_name;
      v_user_grp_dtl.remarks      := a.remarks;
      PIPE ROW(v_user_grp_dtl);
    END LOOP;
    RETURN;
  END get_giis_user_grp_dtl_list;

  FUNCTION get_giis_user_grp_dtl_grp_list (p_user_grp        GIIS_USER_GRP_DTL.user_grp%TYPE)
    RETURN giis_user_grp_dtl_tab PIPELINED IS

    v_user_grp_dtl    giis_user_grp_dtl_type;

  BEGIN
    FOR a IN (SELECT a.user_grp,  a.tran_cd, a.iss_cd, b.iss_name, a.remarks
                FROM GIIS_USER_GRP_DTL a,
                     GIIS_ISSOURCE b
               WHERE a.iss_cd    = b.iss_cd
                 AND a.user_grp  = p_user_grp
               ORDER BY a.tran_cd, a.iss_cd)
    LOOP
      v_user_grp_dtl.user_grp     := a.user_grp;
      v_user_grp_dtl.tran_cd      := a.tran_cd;
       v_user_grp_dtl.iss_cd       := a.iss_cd;
      v_user_grp_dtl.iss_name     := a.iss_name;
      v_user_grp_dtl.remarks      := a.remarks;
      PIPE ROW(v_user_grp_dtl);
    END LOOP;
    RETURN;
  END get_giis_user_grp_dtl_grp_list;


  PROCEDURE set_giis_user_grp_dtl (
    v_user_grp                GIIS_USER_GRP_DTL.user_grp%TYPE,
    v_tran_cd                 GIIS_USER_GRP_DTL.tran_cd%TYPE,
    v_iss_cd                  GIIS_USER_GRP_DTL.iss_cd%TYPE,
    v_remarks                 GIIS_USER_GRP_DTL.remarks%TYPE,
    v_session_user            GIIS_USER_GRP_DTL.user_id%TYPE) IS

  BEGIN

    MERGE INTO GIIS_USER_GRP_DTL
    USING DUAL ON (user_grp     = v_user_grp
                   AND tran_cd  = v_tran_cd
                   AND iss_cd   = v_iss_cd)

     WHEN NOT MATCHED THEN
            INSERT (user_grp,       tran_cd,     iss_cd,      user_id,         last_update,    remarks,
                  create_user,    create_date)
          VALUES (v_user_grp,     v_tran_cd,   v_iss_cd,    v_session_user,  SYSDATE,        v_remarks,
                  v_session_user, SYSDATE)
     WHEN MATCHED THEN
          UPDATE SET user_id       =   v_session_user,
                     last_update   =   SYSDATE,
                     remarks       =   v_remarks;
    --COMMIT;
  END set_giis_user_grp_dtl;

  PROCEDURE del_giis_user_grp_dtl (p_user_grp	    	GIIS_USER_GRP_DTL.user_grp%TYPE,
                                   p_tran_cd      		GIIS_USER_GRP_DTL.tran_cd%TYPE,
                                   p_iss_cd             GIIS_USER_GRP_DTL.iss_cd%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_GRP_DTL
      WHERE user_grp  = p_user_grp
        AND tran_cd   = p_tran_cd
        AND iss_cd    = p_iss_cd;
    --COMMIT;

  END del_giis_user_grp_dtl;

  PROCEDURE del_giis_user_grp_dtl (p_user_grp	    	GIIS_USER_GRP_DTL.user_grp%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_GRP_DTL
      WHERE user_grp  = p_user_grp;
    --COMMIT;

  END del_giis_user_grp_dtl;

END Giis_User_Grp_Dtl_Pkg;
/


