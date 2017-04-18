CREATE OR REPLACE PACKAGE CPI.Giis_Users_Pkg AS

  app_user GIIS_USERS.user_id%TYPE; -- added by andrew - 02.18.2011 - application user variable

  TYPE giis_user_type IS RECORD
      (user_id  	        GIIS_USERS.user_id%TYPE,
       user_grp	        	GIIS_USERS.user_grp%TYPE,
       user_name	        GIIS_USERS.user_name%TYPE,
       user_level        	GIIS_USERS.user_level%TYPE,
       acctg_sw	        	GIIS_USERS.acctg_sw%TYPE,
       claim_sw	        	GIIS_USERS.claim_sw%TYPE,
       dist_sw	        	GIIS_USERS.dist_sw%TYPE,
       exp_sw	        	GIIS_USERS.exp_sw%TYPE,
       inq_sw	        	GIIS_USERS.inq_sw%TYPE,
       mis_sw	        	GIIS_USERS.mis_sw%TYPE,
       pol_sw	        	GIIS_USERS.pol_sw%TYPE,
       rmd_sw	   			GIIS_USERS.rmd_sw%TYPE,
       ri_sw		   		GIIS_USERS.ri_sw%TYPE,
       comm_update_tag		GIIS_USERS.comm_update_tag%TYPE,
       mgr_sw				GIIS_USERS.mgr_sw%TYPE,
       mktng_sw				GIIS_USERS.mktng_sw%TYPE,
       all_user_sw			GIIS_USERS.all_user_sw%TYPE,
       remarks				GIIS_USERS.remarks%TYPE,
       last_user_id			GIIS_USERS.last_user_id%TYPE,
       last_update			GIIS_USERS.last_update%TYPE,
       active_flag			GIIS_USERS.active_flag%TYPE,
       change_pass_sw		GIIS_USERS.change_pass_sw%TYPE,
       workflow_tag			GIIS_USERS.workflow_tag%TYPE,
       email_address		GIIS_USERS.email_address%TYPE,
       pass					GIIS_USERS.PASSWORD%TYPE,
	   iss_cd				GIIS_USER_GRP_HDR.grp_iss_cd%TYPE,
	   iss_name				giis_issource.iss_name%TYPE,
	   user_grp_desc		GIIS_USER_GRP_HDR.user_grp_desc%TYPE);
		  
  TYPE giis_user_tab IS TABLE OF giis_user_type;
		  
  FUNCTION get_user_password(p_user_id 	  	  	  GIIS_USERS.user_id%TYPE, 
			  			 	 p_email_address 	  GIIS_USERS.email_address%TYPE)
	RETURN VARCHAR2;
	
  FUNCTION get_giis_user(p_user_id GIIS_USERS.user_id%TYPE) 
	RETURN giis_user_tab PIPELINED;
	
  FUNCTION get_giis_users(p_param GIIS_USERS.user_id%TYPE,
  		   				  p_active_flag VARCHAR2,
						  p_comm_update_tag VARCHAR2,
						  p_all_user_sw VARCHAR2,
						  p_mgr_sw VARCHAR2,
						  p_mktng_sw VARCHAR2,
						  p_mis_sw VARCHAR2,
						  p_workflow_tag VARCHAR2) 
	RETURN giis_user_tab PIPELINED;
	
  PROCEDURE set_giis_users (
  	v_user_id        	   IN GIIS_USERS.user_id%TYPE,                
    v_user_grp             IN GIIS_USERS.user_grp%TYPE,  
    v_user_name            IN GIIS_USERS.user_name%TYPE,  
    v_user_level           IN GIIS_USERS.user_level%TYPE,  
    v_acctg_sw             IN GIIS_USERS.acctg_sw%TYPE,  
    v_claim_sw             IN GIIS_USERS.claim_sw%TYPE,  
    v_dist_sw              IN GIIS_USERS.dist_sw%TYPE,  
    v_exp_sw               IN GIIS_USERS.exp_sw%TYPE,  
    v_inq_sw               IN GIIS_USERS.inq_sw%TYPE,  
    v_mis_sw               IN GIIS_USERS.mis_sw%TYPE,  
    v_pol_sw               IN GIIS_USERS.pol_sw%TYPE,  
    v_rmd_sw               IN GIIS_USERS.rmd_sw%TYPE,  
    v_ri_sw                IN GIIS_USERS.ri_sw%TYPE,  
    v_comm_update_tag      IN GIIS_USERS.comm_update_tag%TYPE,  
    v_mgr_sw               IN GIIS_USERS.mgr_sw%TYPE,  
    v_mktng_sw             IN GIIS_USERS.mktng_sw%TYPE,  
    v_all_user_sw          IN GIIS_USERS.all_user_sw%TYPE,  
    v_remarks              IN GIIS_USERS.remarks%TYPE,  
    v_last_user_id         IN GIIS_USERS.last_user_id%TYPE,  
    v_last_update          IN GIIS_USERS.last_update%TYPE,  
    v_active_flag          IN GIIS_USERS.active_flag%TYPE,  
    v_change_pass_sw       IN GIIS_USERS.change_pass_sw%TYPE,  
    v_workflow_tag         IN GIIS_USERS.workflow_tag%TYPE,  
    v_email_address        IN GIIS_USERS.email_address%TYPE,  
    v_password             IN GIIS_USERS.PASSWORD%TYPE,
    v_last_password_reset  IN GIIS_USERS.last_password_reset%TYPE,  
    v_last_login		   IN GIIS_USERS.last_login%TYPE);
  
  	FUNCTION get_giis_user_all_list
	  RETURN giis_user_tab PIPELINED;
	  
	FUNCTION get_grp_iss_cd(p_user_id GIIS_USERS.user_id%TYPE)
	  RETURN VARCHAR2;  
      
  PROCEDURE reset_password (p_user_id GIIS_USERS.user_id%TYPE,
                            p_password GIIS_USERS.password%TYPE,
                            p_last_user_id GIIS_USERS.last_user_id%TYPE,
                            p_salt giis_users.salt%TYPE);
                            
  FUNCTION get_underwriters (p_user_id IN giis_users.user_id%TYPE)
    RETURN giis_user_tab PIPELINED;

  TYPE workflow_user_type IS RECORD
      (user_id  	        GIIS_USERS.user_id%TYPE,
       user_name	        GIIS_USERS.user_name%TYPE,
       user_grp	        	GIIS_USERS.user_grp%TYPE,       
       active_flag          GIIS_USERS.active_flag%TYPE,
       email_address		GIIS_USERS.email_address%TYPE);
		  
  TYPE workflow_user_tab IS TABLE OF workflow_user_type;
                       
   FUNCTION get_workflow_user_list (
      p_event_cd     gipi_user_events.event_cd%TYPE,
      p_event_type   giis_events.event_type%TYPE,
      p_app_user     giis_users.user_id%TYPE,
      p_tran_id      gipi_user_events.tran_id%TYPE,
      p_event_mod_cd gipi_user_events.event_mod_cd%TYPE,
      p_event_col_cd gipi_user_events.event_col_cd%TYPE,      
      p_create       VARCHAR2
   )
        RETURN workflow_user_tab PIPELINED;
    
    FUNCTION get_user_level(p_user_id giis_users.user_id%TYPE)
        RETURN NUMBER;    
    
    FUNCTION get_user_by_iss_cd(p_line_cd GICL_CLAIMS.line_cd%TYPE,
                                 p_pol_iss_cd   GICL_CLAIMS.pol_iss_cd%TYPE,
                                 p_module_id    GIIS_MODULES.module_id%TYPE)
     RETURN giis_user_tab PIPELINED;
     
    PROCEDURE validate_user(
        p_user      IN  giis_users.user_id%TYPE,
        p_line_cd   IN  giis_user_grp_line.line_cd%TYPE,
        p_iss_cd    IN  giis_user_grp_line.iss_cd%TYPE,
        p_msg       OUT VARCHAR2
    );   
    
    FUNCTION validate_if_active_user(p_user_id GIIS_USERS.user_id%TYPE)
      RETURN VARCHAR2;   
      
    PROCEDURE check_user_stat(
        p_function_cd       IN  giac_user_functions.function_code%TYPE,
        p_module_id         IN  giac_user_functions.module_id%TYPE,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_all_user_sw       OUT giis_users.all_user_sw%TYPE,
        p_valid_tag         OUT giac_user_functions.valid_tag%TYPE
    );
      
    FUNCTION get_user_details(
      p_user_id giis_users.user_id%TYPE
    ) RETURN giis_user_tab PIPELINED;
    
    /* benjo 02.01.2016 GENQA-SR-4941 */
    FUNCTION validate_username(p_user_id giis_users.user_id%TYPE)
      RETURN VARCHAR2;
      
    PROCEDURE save_pw_hist (
        p_user_id     giis_users_pw_hist.user_id%TYPE,
        p_salt        giis_users_pw_hist.salt%TYPE,
        p_password    giis_users_pw_hist.password%TYPE
    );
    
    TYPE pw_hist_type IS RECORD (
        salt        giis_users_pw_hist.salt%TYPE,
        password    giis_users_pw_hist.password%TYPE
    );
    
    TYPE pw_hist_tab IS TABLE OF pw_hist_type;
    
    FUNCTION get_pw_hist (p_user_id VARCHAR2)
        RETURN pw_hist_tab PIPELINED;
                
END Giis_Users_Pkg;
/


