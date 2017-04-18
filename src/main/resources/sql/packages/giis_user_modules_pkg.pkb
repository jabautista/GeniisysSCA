CREATE OR REPLACE PACKAGE BODY CPI.Giis_User_Modules_Pkg AS

  FUNCTION get_giis_user_modules_list (p_userid            GIIS_USER_MODULES.userid%TYPE,
                                       p_user_tran         GIIS_USER_MODULES.tran_cd%TYPE)
    RETURN giis_user_modules_tab PIPELINED IS

    v_user_module    giis_user_modules_type;

  BEGIN
    FOR a IN (SELECT a.userid,  a.tran_cd, a.module_id, b.module_desc, a.remarks,  a.access_tag
                FROM GIIS_USER_MODULES a,
                     GIIS_MODULES b,
                     GIIS_MODULES_TRAN c
               WHERE a.module_id = b.module_id
                 AND a.tran_cd   = c.tran_cd
                 AND a.module_id = c.module_id
                 AND a.userid    = p_userid
                 AND a.tran_cd   = p_user_tran
               ORDER BY a.tran_cd, a.module_id)
    LOOP
      v_user_module.userid       := a.userid;
      v_user_module.tran_cd      := a.tran_cd;
      v_user_module.module_id    := a.module_id;
      v_user_module.module_desc  := a.module_desc;
      v_user_module.remarks      := a.remarks;
      v_user_module.access_tag   := a.access_tag;
      PIPE ROW(v_user_module);
    END LOOP;
    RETURN;
  END get_giis_user_modules_list;

  FUNCTION get_giis_user_modules_list (p_userid         GIIS_USER_MODULES.userid%TYPE)
    RETURN giis_user_modules_tab PIPELINED IS

	v_giis_user_module		 giis_user_modules_type;

  BEGIN

    FOR i IN (SELECT a.userid, a.module_id, b.module_desc, a.user_id, a.last_update,
	   	  	 		 a.remarks, a.access_tag, a.tran_cd, a.create_user, a.create_date
  				FROM GIIS_USER_MODULES a,
			  	   	 GIIS_MODULES b,
                     GIIS_MODULES_TRAN c
 			   WHERE a.module_id = b.module_id
                 AND a.tran_cd   = c.tran_cd
                 AND a.module_id = c.module_id
			     AND a.userid    = p_userid
			ORDER BY b.module_desc)
  	LOOP
	  v_giis_user_module.userid  			:= i.userid;
	  v_giis_user_module.module_id		 	:= i.module_id;
	  v_giis_user_module.module_desc		:= i.module_desc;
	  v_giis_user_module.user_id			:= i.user_id;
	  v_giis_user_module.last_update		:= i.last_update;
	  v_giis_user_module.remarks			:= i.remarks;
	  v_giis_user_module.access_tag	 	 	:= i.access_tag;
	  v_giis_user_module.tran_cd		 	:= i.tran_cd;
	  v_giis_user_module.create_user		:= i.create_user;
	  v_giis_user_module.create_date		:= i.create_date;

	  PIPE ROW(v_giis_user_module);
	END LOOP;

	RETURN;
  END get_giis_user_modules_list;

  PROCEDURE set_giis_user_modules (
    v_userid                        GIIS_USER_MODULES.userid%TYPE,
    v_module_id                     GIIS_USER_MODULES.module_id%TYPE,
    v_remarks                       GIIS_USER_MODULES.remarks%TYPE,
    v_access_tag                    GIIS_USER_MODULES.access_tag%TYPE,
    v_tran_cd                       GIIS_USER_MODULES.tran_cd%TYPE,
    v_session_user                  GIIS_USER_MODULES.user_id%TYPE) IS

  BEGIN

    MERGE INTO GIIS_USER_MODULES
    USING DUAL ON (userid        = v_userid
                   AND tran_cd   = v_tran_cd
                   AND module_id = v_module_id)

     WHEN NOT MATCHED THEN
            INSERT (userid,       tran_cd,        module_id,      user_id,         last_update,    remarks,
                    access_tag,   create_user,    create_date)
          VALUES (v_userid,       v_tran_cd,      v_module_id,    v_session_user,  SYSDATE,        v_remarks,
                  v_access_tag,   v_session_user, SYSDATE)
     WHEN MATCHED THEN
          UPDATE SET user_id       =   v_session_user,
                     last_update   =   SYSDATE,
                     remarks       =   v_remarks,
                     access_tag    =   v_access_tag;

  END set_giis_user_modules;


  PROCEDURE del_giis_user_module (p_userid       	GIIS_USER_MODULES.userid%TYPE,
                                  p_module_id    	GIIS_USER_MODULES.module_id%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_MODULES
     WHERE userid    = p_userid
       AND module_id = p_module_id;

  END del_giis_user_module;

  PROCEDURE del_giis_user_module (p_userid       	GIIS_USER_MODULES.userid%TYPE) IS

  BEGIN

    DELETE FROM GIIS_USER_MODULES
     WHERE userid  = p_userid;

  END del_giis_user_module;

  FUNCTION get_module_users(p_module_id GIIS_MODULES.MODULE_ID%TYPE)
    RETURN giis_module_users_tab PIPELINED IS

	v_giis_module_users giis_module_users_type;

  BEGIN

    FOR i IN (SELECT a.USERID, b.USER_NAME, a.ACCESS_TAG, a.USER_ID, a.LAST_UPDATE
				FROM GIIS_USER_MODULES a,
				  	 GIIS_USERS b
			   WHERE MODULE_ID = p_module_id
			     AND a.USERID  = b.user_id)
	LOOP

	  v_giis_module_users.userid 		:= i.userid;
	  v_giis_module_users.username 		:= i.user_name;
	  v_giis_module_users.access_tag	:= Cg_Ref_Codes_Pkg.get_rv_meaning('GIIS_MODULES.MOD_ACCESS_TAG', i.access_tag);
	  v_giis_module_users.user_id		:= i.user_id;
	  v_giis_module_users.last_update	:= i.last_update;
	  PIPE ROW(v_giis_module_users);

	END LOOP;

	RETURN;

  END;

END Giis_User_Modules_Pkg;
/


