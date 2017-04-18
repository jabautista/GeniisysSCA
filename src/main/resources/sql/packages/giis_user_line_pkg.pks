CREATE OR REPLACE PACKAGE CPI.Giis_User_Line_Pkg AS
  	 
  TYPE giis_user_line_type IS RECORD (
  	   userid				 GIIS_USER_LINE.userid%TYPE,
	   tran_cd				 GIIS_USER_LINE.tran_cd%TYPE,
	   iss_cd				 GIIS_USER_LINE.iss_cd%TYPE,
	   line_cd				 GIIS_USER_LINE.line_cd%TYPE,
	   line_name		 	 GIIS_LINE.line_name%TYPE,
	   user_id				 GIIS_USER_LINE.user_id%TYPE,
	   last_update		 	 GIIS_USER_LINE.last_update%TYPE,
	   create_user		 	 GIIS_USER_LINE.create_user%TYPE,
	   create_date			 GIIS_USER_LINE.create_date%TYPE);

  TYPE giis_user_line_tab IS TABLE OF giis_user_line_type;
  
  FUNCTION get_giis_user_line_list (p_userid          GIIS_USER_LINE.userid%TYPE,
                                    p_tran            GIIS_USER_LINE.tran_cd%TYPE,
                                    p_iss_cd          GIIS_USER_LINE.iss_cd%TYPE)  
    RETURN giis_user_line_tab PIPELINED;
    
  PROCEDURE set_giis_user_line (
    v_userid                   GIIS_USER_LINE.userid%TYPE,
    v_tran_cd                  GIIS_USER_LINE.tran_cd%TYPE,
    v_line_cd                  GIIS_USER_LINE.line_cd%TYPE,          
    v_iss_cd                   GIIS_USER_LINE.iss_cd%TYPE,
    v_session_user			   GIIS_USER_LINE.user_id%TYPE);
	
  FUNCTION get_giis_user_line_list (p_userid            GIIS_USER_LINE.userid%TYPE) 
    RETURN giis_user_line_tab PIPELINED;	

  PROCEDURE del_giis_user_line (p_userid	    	GIIS_USER_LINE.userid%TYPE,
                                p_tran_cd	    	GIIS_USER_LINE.tran_cd%TYPE,
                                p_iss_cd	    	GIIS_USER_LINE.iss_cd%TYPE,
                                p_line_cd	    	GIIS_USER_LINE.line_cd%TYPE);
									
  PROCEDURE del_giis_user_line (p_userid	    	GIIS_USER_LINE.userid%TYPE);

END Giis_User_Line_Pkg;
/


