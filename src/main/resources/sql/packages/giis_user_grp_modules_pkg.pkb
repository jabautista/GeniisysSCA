CREATE OR REPLACE PACKAGE BODY CPI.Giis_User_Grp_Modules_Pkg AS


/**
* Modified by : Andrew Robes
* Date : 07.06.2011
* Description : Added 'web_enabled' condition, to narrow the query results only to modules which are ready for deployment
*/
  FUNCTION get_giis_user_grp_modules(p_user      GIIS_USERS.user_id%TYPE)
    RETURN giis_user_grp_modules_tab PIPELINED IS

    v_menu        giis_user_grp_modules_type;

  BEGIN
    FOR a IN (SELECT b.module_id
                FROM GIIS_USERS a,
                     GIIS_USER_GRP_MODULES b
                    ,GIIS_MODULES c
               WHERE a.user_grp = b.user_grp
                 AND UPPER(a.user_id) = UPPER(p_user) -- added UPPER by andrew - 03.03.2011
                 AND b.access_tag = 1
                 AND b.module_id = c.module_id
                 AND c.web_enabled = 'Y') LOOP

      v_menu.module_id := a.module_id;
      PIPE ROW(v_menu);

    END LOOP;

    FOR a IN (SELECT b.module_id
                FROM GIIS_USERS a,
                     GIIS_USER_MODULES b
                    ,GIIS_MODULES c
               WHERE a.user_id    = b.userid
                 AND UPPER(a.user_id) = UPPER(p_user) -- added UPPER by andrew - 03.03.2011
                 AND b.access_tag = 1
                 AND b.module_id = c.module_id
                 AND c.web_enabled = 'Y') LOOP

      v_menu.module_id    := a.module_id;
      PIPE ROW(v_menu);

    END LOOP;
    RETURN;
  END;

  FUNCTION get_giis_user_grp_modules_list (p_user_grp        GIIS_USER_GRP_MODULES.user_grp%TYPE,
                                          p_user_grp_tran   GIIS_USER_GRP_MODULES.tran_cd%TYPE)
    RETURN giis_user_grp_modules_tab PIPELINED IS

    v_user_grp_module    giis_user_grp_modules_type;

  BEGIN
    FOR a IN (SELECT a.user_grp,  a.tran_cd, a.module_id, b.module_desc, a.remarks,  a.access_tag
                FROM GIIS_USER_GRP_MODULES a,
                     GIIS_MODULES b,
                     GIIS_MODULES_TRAN c
               WHERE a.module_id = c.module_id
                 AND a.tran_cd   = c.tran_cd
                 AND a.module_id = b.module_id
                 AND a.user_grp  = p_user_grp
                 AND a.tran_cd   = p_user_grp_tran
               ORDER BY a.tran_cd, a.module_id)
    LOOP
      v_user_grp_module.user_grp     := a.user_grp;
      v_user_grp_module.tran_cd      := a.tran_cd;
       v_user_grp_module.module_id    := a.module_id;
      v_user_grp_module.module_desc  := a.module_desc;
      v_user_grp_module.remarks         := a.remarks;
      v_user_grp_module.access_tag     := a.access_tag;
      PIPE ROW(v_user_grp_module);
    END LOOP;
    RETURN;
  END get_giis_user_grp_modules_list;

  FUNCTION get_giis_user_grp_modules_list (p_user_grp VARCHAR2)
    RETURN giis_user_grp_modules_tab PIPELINED IS

    v_giis_user_grp_module         giis_user_grp_modules_type;

  BEGIN

    FOR i IN (SELECT a.user_grp, a.module_id, b.module_desc, a.user_id, a.last_update,
                           a.remarks, a.access_tag, a.tran_cd, a.create_user, a.create_date
                  FROM GIIS_USER_GRP_MODULES a,
                          GIIS_MODULES b,
                     GIIS_MODULES_TRAN c
                WHERE a.module_id = b.module_id
                 AND a.tran_cd   = c.tran_cd
                 AND a.module_id = c.module_id
                 AND a.user_grp  = p_user_grp
            ORDER BY b.module_desc)
      LOOP
      v_giis_user_grp_module.user_grp            := i.user_grp;
      v_giis_user_grp_module.module_id             := i.module_id;
      v_giis_user_grp_module.module_desc        := i.module_desc;
      v_giis_user_grp_module.user_id            := i.user_id;
      v_giis_user_grp_module.last_update        := i.last_update;
      v_giis_user_grp_module.remarks            := i.remarks;
      v_giis_user_grp_module.access_tag              := i.access_tag;
      v_giis_user_grp_module.tran_cd             := i.tran_cd;
      v_giis_user_grp_module.create_user        := i.create_user;
      v_giis_user_grp_module.create_date        := i.create_date;

      PIPE ROW(v_giis_user_grp_module);
    END LOOP;

    RETURN;
  END get_giis_user_grp_modules_list;

  PROCEDURE set_giis_user_grp_modules (
    v_user_grp                      GIIS_USER_GRP_MODULES.user_grp%TYPE,
    v_module_id                     GIIS_USER_GRP_MODULES.module_id%TYPE,
    v_remarks                       GIIS_USER_GRP_MODULES.remarks%TYPE,
    v_access_tag                    GIIS_USER_GRP_MODULES.access_tag%TYPE,
    v_tran_cd                       GIIS_USER_GRP_MODULES.tran_cd%TYPE,
    v_session_user                  GIIS_USER_GRP_MODULES.user_id%TYPE) IS

  BEGIN

    MERGE INTO GIIS_USER_GRP_MODULES
    USING DUAL ON (user_grp      = v_user_grp
                   AND tran_cd   = v_tran_cd
                   AND module_id = v_module_id)

     WHEN NOT MATCHED THEN
            INSERT (user_grp,       tran_cd,     module_id,      user_id,         last_update,    remarks,
                  access_tag,     create_user,    create_date)
          VALUES (v_user_grp,     v_tran_cd,   v_module_id,    v_session_user,  SYSDATE,        v_remarks,
                  v_access_tag,   v_session_user, SYSDATE)
     WHEN MATCHED THEN
          UPDATE SET user_id       =   v_session_user,
                     last_update   =   SYSDATE,
                     remarks       =   v_remarks,
                     access_tag    =   v_access_tag;
    --COMMIT;
  END set_giis_user_grp_modules;


  PROCEDURE del_giis_user_grp_module (p_user_grp           GIIS_USER_GRP_MODULES.user_grp%TYPE,
                                      p_module_id        GIIS_USER_GRP_MODULES.module_id%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_GRP_MODULES
      WHERE user_grp  = p_user_grp
        AND module_id = p_module_id;
    --COMMIT;

  END del_giis_user_grp_module;

  PROCEDURE del_giis_user_grp_module (p_user_grp           GIIS_USER_GRP_MODULES.user_grp%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_GRP_MODULES
      WHERE user_grp  = p_user_grp;
    --COMMIT;

  END del_giis_user_grp_module;


  FUNCTION get_module_user_grps(p_module_id GIIS_MODULES.MODULE_ID%TYPE)
    RETURN giis_module_user_grps_tab PIPELINED IS

    v_user_grp giis_module_user_grps_type;

  BEGIN

    FOR i IN(SELECT a.USER_GRP, b.USER_GRP_DESC, a.USER_ID, a.LAST_UPDATE, a.REMARKS
               FROM GIIS_USER_GRP_MODULES a,
                    GIIS_USER_GRP_HDR b
              WHERE MODULE_ID = p_module_id
                AND a.USER_GRP = b.USER_GRP)

    LOOP

      v_user_grp.user_grp        := i.user_grp;
      v_user_grp.user_grp_desc := i.user_grp_desc;
      v_user_grp.user_id       := i.user_id;
      v_user_grp.last_update   := i.last_update;
      v_user_grp.remarks       := i.remarks;

      PIPE ROW(v_user_grp);
    END LOOP;

    RETURN;

  END get_module_user_grps;

  PROCEDURE del_user_grp_module (p_user_grp           GIIS_USER_GRP_MODULES.user_grp%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_GRP_DTL
     WHERE USER_GRP = p_user_grp;

    COMMIT;

    DELETE FROM GIIS_USER_GRP_LINE
     WHERE USER_GRP = p_user_grp;

    COMMIT;

    DELETE FROM GIIS_USER_GRP_MODULES
     WHERE USER_GRP = p_user_grp;

    COMMIT;

    DELETE FROM GIIS_USER_GRP_TRAN
     WHERE USER_GRP = p_user_grp;

    COMMIT;

    DELETE FROM GIIS_USER_GRP_HDR
     WHERE USER_GRP = p_user_grp;

    COMMIT;

  END del_user_grp_module;

END Giis_User_Grp_Modules_Pkg;
/


