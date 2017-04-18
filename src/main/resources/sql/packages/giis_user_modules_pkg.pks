CREATE OR REPLACE PACKAGE CPI.Giis_User_Modules_Pkg AS
  
  TYPE giis_user_modules_type IS RECORD (
  	   userid				 GIIS_USER_MODULES.userid%TYPE,
	   module_id		 	 GIIS_USER_MODULES.module_id%TYPE,
	   module_desc		 	 GIIS_MODULES.module_desc%TYPE,
	   user_id				 GIIS_USER_MODULES.user_id%TYPE,
	   last_update		 	 GIIS_USER_MODULES.last_update%TYPE,
	   remarks			 	 GIIS_USER_MODULES.remarks%TYPE,
	   access_tag	 	 	 GIIS_USER_MODULES.access_tag%TYPE,
	   tran_cd		 	 	 GIIS_USER_MODULES.tran_cd%TYPE,
	   create_user		 	 GIIS_USER_MODULES.create_user%TYPE,
	   create_date			 GIIS_USER_MODULES.create_date%TYPE);
  
  TYPE giis_user_modules_tab IS TABLE OF giis_user_modules_type;   
  
  TYPE giis_module_users_type IS RECORD (
  	   userid				 GIIS_USER_MODULES.USERID%TYPE,
	   username				 GIIS_USERS.USER_NAME%TYPE,
	   access_tag			 CG_REF_CODES.RV_MEANING%TYPE,
	   user_id				 GIIS_USER_MODULES.USER_ID%TYPE,
	   last_update			 GIIS_USER_MODULES.LAST_UPDATE%TYPE);
  
  TYPE giis_module_users_tab IS TABLE OF giis_module_users_type;
  
  FUNCTION get_giis_user_modules_list (p_userid          GIIS_USER_MODULES.userid%TYPE,
                                       p_user_tran       GIIS_USER_MODULES.tran_cd%TYPE)  
    RETURN giis_user_modules_tab PIPELINED;
	
  FUNCTION get_giis_user_modules_list (p_userid          GIIS_USER_MODULES.userid%TYPE)
    RETURN giis_user_modules_tab PIPELINED;
    
  PROCEDURE set_giis_user_modules (
    v_userid                    GIIS_USER_MODULES.userid%TYPE,
    v_module_id                 GIIS_USER_MODULES.module_id%TYPE,
    v_remarks                   GIIS_USER_MODULES.remarks%TYPE,        
    v_access_tag                GIIS_USER_MODULES.access_tag%TYPE,
    v_tran_cd                   GIIS_USER_MODULES.tran_cd%TYPE,
	v_session_user				GIIS_USER_MODULES.user_id%TYPE);
    
  PROCEDURE del_giis_user_module (p_userid       	GIIS_USER_MODULES.userid%TYPE,
                                  p_module_id    	GIIS_USER_MODULES.module_id%TYPE);
									  
  PROCEDURE del_giis_user_module (p_userid       	GIIS_USER_MODULES.userid%TYPE);
  
  FUNCTION get_module_users(p_module_id GIIS_MODULES.MODULE_ID%TYPE)
    RETURN giis_module_users_tab PIPELINED;
  
END Giis_User_Modules_Pkg;
/


