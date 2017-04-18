CREATE OR REPLACE PACKAGE CPI.Giis_User_Grp_Tran_Pkg AS

    TYPE giis_user_grp_tran_type IS RECORD
    (user_grp       		   GIIS_USER_GRP_TRAN.user_grp%TYPE,
     tran_cd				   GIIS_USER_GRP_TRAN.tran_cd%TYPE,
     user_id       			   GIIS_USER_GRP_TRAN.user_id%TYPE, 
     last_update    		   GIIS_USER_GRP_TRAN.last_update%TYPE,
     remarks       			   GIIS_USER_GRP_TRAN.remarks%TYPE, 
     access_tag    		       GIIS_USER_GRP_TRAN.access_tag%TYPE,
	 tran_desc				   GIIS_TRANSACTION.tran_desc%TYPE);
  
  TYPE giis_user_grp_tran_tab IS TABLE OF giis_user_grp_tran_type;
  
  FUNCTION get_giis_user_grp_tran_list (p_user_grp    GIIS_USER_GRP_HDR.user_grp%TYPE)  
	RETURN giis_user_grp_tran_tab PIPELINED;
	
  PROCEDURE set_giis_user_grp_tran (
    v_user_grp       			   GIIS_USER_GRP_TRAN.user_grp%TYPE,
    v_tran_cd        			   GIIS_USER_GRP_TRAN.tran_cd%TYPE,
    v_remarks					   GIIS_USER_GRP_TRAN.remarks%TYPE,        
    v_access_tag     			   GIIS_USER_GRP_TRAN.access_tag%TYPE,
 	v_session_user				   GIIS_USER_GRP_TRAN.user_id%TYPE);

  PROCEDURE del_giis_user_grp_tran (p_user_grp	    	GIIS_USER_GRP_TRAN.user_grp%TYPE);
  
 END Giis_User_Grp_Tran_Pkg;
/


