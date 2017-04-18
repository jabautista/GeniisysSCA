CREATE OR REPLACE PACKAGE CPI.Giis_User_Grp_Dtl_Pkg AS
  
  TYPE giis_user_grp_dtl_type IS RECORD
    (user_grp                  GIIS_USER_GRP_DTL.user_grp%TYPE,
     tran_cd                   GIIS_USER_GRP_DTL.tran_cd%TYPE,
     iss_cd                    GIIS_USER_GRP_DTL.iss_cd%TYPE,
     iss_name                  GIIS_ISSOURCE.iss_name%TYPE,
     user_id                   GIIS_USER_GRP_DTL.user_id%TYPE, 
     last_update               GIIS_USER_GRP_DTL.last_update%TYPE,
     remarks                   GIIS_USER_GRP_DTL.remarks%TYPE);  
  
  TYPE giis_user_grp_dtl_tab IS TABLE OF giis_user_grp_dtl_type;
  
  FUNCTION get_giis_user_grp_dtl_list (p_user_grp        GIIS_USER_GRP_DTL.user_grp%TYPE,
                                       p_user_grp_tran   GIIS_USER_GRP_DTL.tran_cd%TYPE)  
    RETURN giis_user_grp_dtl_tab PIPELINED;
	
  FUNCTION get_giis_user_grp_dtl_grp_list (p_user_grp        GIIS_USER_GRP_DTL.user_grp%TYPE)  
    RETURN giis_user_grp_dtl_tab PIPELINED;
    
  PROCEDURE set_giis_user_grp_dtl (
    v_user_grp                 GIIS_USER_GRP_DTL.user_grp%TYPE,
    v_tran_cd                  GIIS_USER_GRP_DTL.tran_cd%TYPE,     
    v_iss_cd                   GIIS_USER_GRP_DTL.iss_cd%TYPE,
    v_remarks                  GIIS_USER_GRP_DTL.remarks%TYPE,
 	v_session_user			   GIIS_USER_GRP_DTL.user_id%TYPE);
    
  PROCEDURE del_giis_user_grp_dtl (p_user_grp	    	GIIS_USER_GRP_DTL.user_grp%TYPE,
                                   p_tran_cd    		GIIS_USER_GRP_DTL.tran_cd%TYPE,
                                   p_iss_cd             GIIS_USER_GRP_DTL.iss_cd%TYPE);
								   
  PROCEDURE del_giis_user_grp_dtl (p_user_grp	    	GIIS_USER_GRP_DTL.user_grp%TYPE);
       
END Giis_User_Grp_Dtl_Pkg;
/


