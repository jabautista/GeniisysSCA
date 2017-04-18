CREATE OR REPLACE PACKAGE BODY CPI.Giis_User_Iss_Cd_Pkg AS

  FUNCTION get_giis_user_iss_cd_list (p_userid      GIIS_USER_ISS_CD.userid%TYPE,
                                      p_user_tran   GIIS_USER_ISS_CD.tran_cd%TYPE)
    RETURN giis_user_iss_cd_tab PIPELINED IS

    v_user_iss_cd    giis_user_iss_cd_type;

  BEGIN
    FOR a IN (SELECT a.userid,  a.tran_cd, a.iss_cd, b.iss_name
                FROM GIIS_USER_ISS_CD a,
                     GIIS_ISSOURCE b
                 WHERE a.iss_cd    = b.iss_cd
                   AND a.userid      = p_userid
                   AND a.tran_cd   = p_user_tran
               ORDER BY a.tran_cd, a.iss_cd)
    LOOP
      v_user_iss_cd.userid       := a.userid;
      v_user_iss_cd.tran_cd      := a.tran_cd;
      v_user_iss_cd.iss_cd       := a.iss_cd;
      v_user_iss_cd.iss_name     := a.iss_name;
      PIPE ROW(v_user_iss_cd);
    END LOOP;
    RETURN;
  END get_giis_user_iss_cd_list;

  FUNCTION get_giis_user_iss_cd_grp_list (p_userid        GIIS_USER_ISS_CD.userid%TYPE)
    RETURN giis_user_iss_cd_tab PIPELINED IS

    v_user_iss_cd    giis_user_iss_cd_type;

  BEGIN
    FOR a IN (SELECT a.userid,  a.tran_cd, a.iss_cd, b.iss_name
                FROM GIIS_USER_ISS_CD a,
                     GIIS_ISSOURCE b
               WHERE a.iss_cd    = b.iss_cd
                 AND a.userid    = p_userid
               ORDER BY a.tran_cd, a.iss_cd)
    LOOP
      v_user_iss_cd.userid       := a.userid;
      v_user_iss_cd.tran_cd      := a.tran_cd;
      v_user_iss_cd.iss_cd       := a.iss_cd;
      v_user_iss_cd.iss_name    := a.iss_name;
      PIPE ROW(v_user_iss_cd);
    END LOOP;
    RETURN;
  END get_giis_user_iss_cd_grp_list;


  PROCEDURE set_giis_user_iss_cd (
    v_userid                  GIIS_USER_ISS_CD.userid%TYPE,
    v_tran_cd                 GIIS_USER_ISS_CD.tran_cd%TYPE,
    v_iss_cd                  GIIS_USER_ISS_CD.iss_cd%TYPE,
    v_session_user            GIIS_USER_ISS_CD.user_id%TYPE) IS

  BEGIN

    MERGE INTO GIIS_USER_ISS_CD
    USING DUAL ON (userid       = v_userid
                   AND tran_cd  = v_tran_cd
                   AND iss_cd   = v_iss_cd)

     WHEN NOT MATCHED THEN
            INSERT (userid,         tran_cd,     iss_cd,      user_id,         last_update,
                    create_user,    create_date)
          VALUES (v_userid,       v_tran_cd,   v_iss_cd,    v_session_user,  SYSDATE,
                  v_session_user, SYSDATE)
     WHEN MATCHED THEN
          UPDATE SET user_id       =   v_session_user,
                     last_update   =   SYSDATE;

  END set_giis_user_iss_cd;

  PROCEDURE del_giis_user_iss_cd (p_userid                GIIS_USER_ISS_CD.userid%TYPE,
                                  p_tran_cd              GIIS_USER_ISS_CD.tran_cd%TYPE,
                                  p_iss_cd              GIIS_USER_ISS_CD.iss_cd%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_ISS_CD
      WHERE userid  = p_userid
        AND tran_cd   = p_tran_cd
        AND iss_cd    = p_iss_cd;

  END del_giis_user_iss_cd;

  PROCEDURE del_giis_user_iss_cd (p_userid            GIIS_USER_ISS_CD.userid%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_ISS_CD
      WHERE userid  = p_userid;

  END del_giis_user_iss_cd;

  FUNCTION check_user_per_iss_cd_acctg (p_line_cd   VARCHAR2
                              , p_iss_cd    VARCHAR2
                              , p_module_id VARCHAR2)
  RETURN NUMBER IS
  v_iss_cd_access NUMBER(1) := 0;
    /* checks user access on iss cd to be called
    ** by bdarusin, 05/08/03. */
    BEGIN

      FOR A IN (
            SELECT 1
              FROM GIIS_USERS A
                  , GIIS_USER_ISS_CD b
                  , GIIS_MODULES_TRAN C
             WHERE A.user_id  = b.userid
               AND A.user_id   = USER
               AND b.iss_cd    = p_iss_cd
               AND b.tran_cd   = C.tran_cd
               AND C.module_id = p_module_id) LOOP
        v_iss_cd_access := 1;
        EXIT;--totel--11/15/2007--tune
      END LOOP;
      IF v_iss_cd_access = 1 THEN
         RETURN v_iss_cd_access;
      END IF;
      FOR A IN (
            SELECT 1
              FROM GIIS_USERS A
                  , GIIS_USER_GRP_DTL b
                  , GIIS_MODULES_TRAN C
             WHERE A.user_grp  = b.user_grp
               AND A.user_id   = USER
               AND b.iss_cd    = p_iss_cd
               AND b.tran_cd   = C.tran_cd
               AND C.module_id = p_module_id) LOOP
        v_iss_cd_access := 1;
        EXIT;--totel--11/15/2007--tune
      END LOOP;
      IF v_iss_cd_access = 1 THEN
          RETURN v_iss_cd_access;
      END IF;
      RETURN v_iss_cd_access;
    END check_user_per_iss_cd_acctg;

  FUNCTION check_user_per_iss_cd_acctg2 (p_line_cd   VARCHAR2
                              , p_iss_cd    VARCHAR2
                              , p_module_id VARCHAR2
                              , p_user_id GIIS_USERS.user_id%TYPE)
  RETURN NUMBER IS
  v_iss_cd_access NUMBER(1) := 0;
    /* checks user access on iss cd to be called
    ** by bdarusin, 05/08/03. */
    BEGIN

      FOR A IN (
            SELECT 1
              FROM GIIS_USERS A
                  , GIIS_USER_ISS_CD b
                  , GIIS_MODULES_TRAN C
             WHERE A.user_id  = b.userid
               AND A.user_id   = NVL(p_user_id, USER)
               AND b.iss_cd    = p_iss_cd
               AND b.tran_cd   = C.tran_cd
               AND C.module_id = p_module_id) LOOP
        v_iss_cd_access := 1;
        EXIT;
      END LOOP;
      IF v_iss_cd_access = 1 THEN
         RETURN v_iss_cd_access;
      END IF;
      FOR A IN (
            SELECT 1
              FROM GIIS_USERS A
                  , GIIS_USER_GRP_DTL b
                  , GIIS_MODULES_TRAN C
             WHERE A.user_grp  = b.user_grp
               AND A.user_id   = NVL(p_user_id, USER)
               AND b.iss_cd    = p_iss_cd
               AND b.tran_cd   = C.tran_cd
               AND C.module_id = p_module_id) LOOP
        v_iss_cd_access := 1;
        EXIT;
      END LOOP;
      IF v_iss_cd_access = 1 THEN
          RETURN v_iss_cd_access;
      END IF;
      RETURN v_iss_cd_access;
    END check_user_per_iss_cd_acctg2;

END Giis_User_Iss_Cd_Pkg;
/


