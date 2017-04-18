CREATE OR REPLACE PACKAGE CPI.Giis_User_Grp_Modules_Pkg AS
  
  TYPE giis_user_grp_modules_type IS RECORD (
  	   user_grp				 GIIS_USER_GRP_MODULES.user_grp%TYPE,
	   module_id		 	 GIIS_USER_GRP_MODULES.module_id%TYPE,
	   module_desc		 	 GIIS_MODULES.module_desc%TYPE,
	   user_id				 GIIS_USER_GRP_MODULES.user_id%TYPE,
	   last_update		 	 GIIS_USER_GRP_MODULES.last_update%TYPE,
	   remarks			 	 GIIS_USER_GRP_MODULES.remarks%TYPE,
	   access_tag	 	 	 GIIS_USER_GRP_MODULES.access_tag%TYPE,
	   tran_cd		 	 	 GIIS_USER_GRP_MODULES.tran_cd%TYPE,
	   create_user		 	 GIIS_USER_GRP_MODULES.create_user%TYPE,
	   create_date			 GIIS_USER_GRP_MODULES.create_date%TYPE);
     
  TYPE giis_user_grp_modules_tab IS TABLE OF giis_user_grp_modules_type;
  
  TYPE giis_module_user_grps_type IS RECORD (
  	   user_grp				 GIIS_USER_GRP_HDR.USER_GRP%TYPE,
	   user_grp_desc		 GIIS_USER_GRP_HDR.USER_GRP_DESC%TYPE,
	   remarks				 GIIS_USER_GRP_MODULES.REMARKS%TYPE,
	   user_id				 GIIS_USER_GRP_HDR.USER_ID%TYPE,
	   last_update			 GIIS_USER_GRP_HDR.LAST_UPDATE%TYPE);
  
  TYPE giis_module_user_grps_tab IS TABLE OF giis_module_user_grps_type;
  
  FUNCTION get_giis_user_grp_modules(p_user    GIIS_USERS.user_id%TYPE)
    RETURN giis_user_grp_modules_tab PIPELINED;
  
  FUNCTION get_giis_user_grp_modules_list (p_user_grp        GIIS_USER_GRP_MODULES.user_grp%TYPE,
                                          p_user_grp_tran   GIIS_USER_GRP_MODULES.tran_cd%TYPE)  
    RETURN giis_user_grp_modules_tab PIPELINED;
	
  FUNCTION get_giis_user_grp_modules_list (p_user_grp VARCHAR2)
    RETURN giis_user_grp_modules_tab PIPELINED;
    
  PROCEDURE set_giis_user_grp_modules (
    v_user_grp                  GIIS_USER_GRP_MODULES.user_grp%TYPE,
    v_module_id                 GIIS_USER_GRP_MODULES.module_id%TYPE,
    v_remarks                   GIIS_USER_GRP_MODULES.remarks%TYPE,        
    v_access_tag                GIIS_USER_GRP_MODULES.access_tag%TYPE,
    v_tran_cd                   GIIS_USER_GRP_MODULES.tran_cd%TYPE,
	v_session_user				GIIS_USER_GRP_MODULES.user_id%TYPE);
    
  PROCEDURE del_giis_user_grp_module (p_user_grp       	GIIS_USER_GRP_MODULES.user_grp%TYPE,
                                      p_module_id    	GIIS_USER_GRP_MODULES.module_id%TYPE);
									  
  PROCEDURE del_giis_user_grp_module (p_user_grp       	GIIS_USER_GRP_MODULES.user_grp%TYPE);
  
  FUNCTION get_module_user_grps(p_module_id GIIS_MODULES.MODULE_ID%TYPE)
    RETURN giis_module_user_grps_tab PIPELINED;
	
  PROCEDURE del_user_grp_module (p_user_grp       	GIIS_USER_GRP_MODULES.user_grp%TYPE);  
  
END Giis_User_Grp_Modules_Pkg;
/


