CREATE OR REPLACE PACKAGE CPI.Giis_User_Tran_Pkg AS

    TYPE giis_user_tran_type IS RECORD
    (userid       		       GIIS_USER_TRAN.userid%TYPE,
     tran_cd				   GIIS_USER_TRAN.tran_cd%TYPE,
     user_id       			   GIIS_USER_TRAN.user_id%TYPE, 
     last_update    		   GIIS_USER_TRAN.last_update%TYPE,
     access_tag    		       GIIS_USER_TRAN.access_tag%TYPE,
	 tran_desc				   GIIS_TRANSACTION.tran_desc%TYPE);
  
  TYPE giis_user_tran_tab IS TABLE OF giis_user_tran_type;
  
  FUNCTION get_giis_user_tran_list (p_userid    GIIS_USER_TRAN.userid%TYPE)  
	RETURN giis_user_tran_tab PIPELINED;
	
  PROCEDURE set_giis_user_tran (
    v_userid        			   GIIS_USER_TRAN.userid%TYPE,
    v_tran_cd        			   GIIS_USER_TRAN.tran_cd%TYPE,   
    v_access_tag     			   GIIS_USER_TRAN.access_tag%TYPE,
 	v_session_user				   GIIS_USER_TRAN.user_id%TYPE);

  PROCEDURE del_giis_user_tran (p_userid	    	GIIS_USER_TRAN.userid%TYPE);
  
 END Giis_User_Tran_Pkg;
/


