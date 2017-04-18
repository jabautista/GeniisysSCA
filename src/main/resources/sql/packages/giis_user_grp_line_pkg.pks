CREATE OR REPLACE PACKAGE CPI.Giis_User_Grp_Line_Pkg AS
  	 
  TYPE giis_user_grp_line_type IS RECORD (
  	   user_grp				 GIIS_USER_GRP_LINE.user_grp%TYPE,
	   tran_cd				 GIIS_USER_GRP_LINE.tran_cd%TYPE,
	   iss_cd				 GIIS_USER_GRP_LINE.iss_cd%TYPE,
	   line_cd				 GIIS_USER_GRP_LINE.line_cd%TYPE,
	   line_name		 	 GIIS_LINE.line_name%TYPE,
	   remarks			 	 GIIS_USER_GRP_LINE.remarks%TYPE,
	   user_id				 GIIS_USER_GRP_LINE.user_id%TYPE,
	   last_update		 	 GIIS_USER_GRP_LINE.last_update%TYPE,
	   create_user		 	 GIIS_USER_GRP_LINE.create_user%TYPE,
	   create_date			 GIIS_USER_GRP_LINE.create_date%TYPE);

  TYPE giis_user_grp_line_tab IS TABLE OF giis_user_grp_line_type;
  
  FUNCTION get_giis_user_grp_line_list (p_user_grp          GIIS_USER_GRP_LINE.user_grp%TYPE,
                                        p_user_grp_tran     GIIS_USER_GRP_LINE.tran_cd%TYPE,
                                        p_user_grp_iss_cd   GIIS_USER_GRP_LINE.iss_cd%TYPE)  
    RETURN giis_user_grp_line_tab PIPELINED;
    
  PROCEDURE set_giis_user_grp_line (
    v_user_grp                 GIIS_USER_GRP_LINE.user_grp%TYPE,
    v_tran_cd                  GIIS_USER_GRP_LINE.tran_cd%TYPE,
    v_line_cd                  GIIS_USER_GRP_LINE.line_cd%TYPE,          
    v_iss_cd                   GIIS_USER_GRP_LINE.iss_cd%TYPE,
    v_remarks                  GIIS_USER_GRP_LINE.remarks%TYPE,
 	v_session_user			   GIIS_USER_GRP_LINE.user_id%TYPE);
	
  FUNCTION get_giis_user_grp_line_list (p_user_grp VARCHAR2) 
    RETURN giis_user_grp_line_tab PIPELINED;	

  PROCEDURE del_giis_user_grp_line (p_user_grp	    	GIIS_USER_GRP_LINE.user_grp%TYPE,
                                    p_tran_cd	    	GIIS_USER_GRP_LINE.tran_cd%TYPE,
                                    p_iss_cd	    	GIIS_USER_GRP_LINE.iss_cd%TYPE,
                                    p_line_cd	    	GIIS_USER_GRP_LINE.line_cd%TYPE);
									
  PROCEDURE del_giis_user_grp_line (p_user_grp	    	GIIS_USER_GRP_LINE.user_grp%TYPE);

END Giis_User_Grp_Line_Pkg;
/


