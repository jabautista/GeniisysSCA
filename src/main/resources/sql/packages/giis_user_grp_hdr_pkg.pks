CREATE OR REPLACE PACKAGE CPI.Giis_User_Grp_Hdr_Pkg AS

  TYPE giis_user_grp_type IS RECORD
    (user_grp                  GIIS_USER_GRP_HDR.user_grp%TYPE,
     user_grp_desc             GIIS_USER_GRP_HDR.user_grp_desc%TYPE,
     user_id                      GIIS_USER_GRP_HDR.user_id%TYPE, 
     last_update               GIIS_USER_GRP_HDR.last_update%TYPE,
     remarks                      GIIS_USER_GRP_HDR.remarks%TYPE, 
     grp_iss_cd                GIIS_USER_GRP_HDR.grp_iss_cd%TYPE,
     iss_name                   GIIS_ISSOURCE.iss_name%TYPE);
          
  TYPE giis_user_grp_tab IS TABLE OF giis_user_grp_type;
          
  FUNCTION get_giis_user_grp_list (p_param    VARCHAR2)  
    RETURN giis_user_grp_tab PIPELINED;
    
  PROCEDURE set_giis_user_grp_hdr (
    v_user_grp                    GIIS_USER_GRP_HDR.user_grp%TYPE,                     
    v_user_grp_desc               GIIS_USER_GRP_HDR.user_grp_desc%TYPE,          
    v_remarks                  GIIS_USER_GRP_HDR.remarks%TYPE, 
    v_grp_iss_cd               GIIS_USER_GRP_HDR.grp_iss_cd%TYPE,
    v_session_user               GIIS_USERS.user_id%TYPE);
  
  PROCEDURE del_giis_user_grp_hdr (p_user_grp	    	GIIS_USER_GRP_HDR.user_grp%TYPE);
  
  PROCEDURE copy_user_group_records(
    p_user_grp                  GIIS_USER_GRP_HDR.user_grp%TYPE,
    p_new_user_grp              GIIS_USER_GRP_HDR.user_grp%TYPE,
    p_user_id                   GIIS_USER_GRP_HDR.user_id%TYPE
  );
  
 END Giis_User_Grp_Hdr_Pkg;
/


