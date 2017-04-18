CREATE OR REPLACE PACKAGE CPI.Giis_User_Iss_Cd_Pkg AS
  
  TYPE giis_user_iss_cd_type IS RECORD
    (userid                    GIIS_USER_ISS_CD.userid%TYPE,
     tran_cd                   GIIS_USER_ISS_CD.tran_cd%TYPE,
     iss_cd                    GIIS_USER_ISS_CD.iss_cd%TYPE,
     iss_name                  GIIS_ISSOURCE.iss_name%TYPE,
     user_id                   GIIS_USER_ISS_CD.user_id%TYPE, 
     last_update               GIIS_USER_ISS_CD.last_update%TYPE);  
  
  TYPE giis_user_iss_cd_tab IS TABLE OF giis_user_iss_cd_type;
  
  FUNCTION get_giis_user_iss_cd_list (p_userid           GIIS_USER_ISS_CD.userid%TYPE,
                                      p_user_tran        GIIS_USER_ISS_CD.tran_cd%TYPE)  
    RETURN giis_user_iss_cd_tab PIPELINED;
	
  FUNCTION get_giis_user_iss_cd_grp_list (p_userid        GIIS_USER_ISS_CD.userid%TYPE)  
    RETURN giis_user_iss_cd_tab PIPELINED;
    
  PROCEDURE set_giis_user_iss_cd (
    v_userid                   GIIS_USER_ISS_CD.userid%TYPE,
    v_tran_cd                  GIIS_USER_ISS_CD.tran_cd%TYPE,     
    v_iss_cd                   GIIS_USER_ISS_CD.iss_cd%TYPE,
    v_session_user			   GIIS_USER_ISS_CD.user_id%TYPE);
    
  PROCEDURE del_giis_user_iss_cd (p_userid 	           GIIS_USER_ISS_CD.userid%TYPE,
                                  p_tran_cd    		   GIIS_USER_ISS_CD.tran_cd%TYPE,
                                  p_iss_cd             GIIS_USER_ISS_CD.iss_cd%TYPE);
								   
  PROCEDURE del_giis_user_iss_cd (p_userid       	   GIIS_USER_ISS_CD.userid%TYPE);
  
  FUNCTION check_user_per_iss_cd_acctg (p_line_cd   VARCHAR2
							  , p_iss_cd    VARCHAR2
							  , p_module_id VARCHAR2)
  RETURN NUMBER;
  
  FUNCTION check_user_per_iss_cd_acctg2 (p_line_cd   VARCHAR2
							  , p_iss_cd    VARCHAR2
							  , p_module_id VARCHAR2
                              , p_user_id   GIIS_USERS.user_id%TYPE)
  RETURN NUMBER;
       
END Giis_User_Iss_Cd_Pkg;
/


