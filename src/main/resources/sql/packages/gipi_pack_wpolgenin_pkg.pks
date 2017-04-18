CREATE OR REPLACE PACKAGE CPI.GIPI_PACK_WPOLGENIN_PKG AS
	
	TYPE gipis031A_pack_wpolgenin_type IS RECORD (
		 pack_par_id				 	GIPI_PACK_WPOLGENIN.pack_par_id%TYPE,
		 genin_info_cd					GIPI_PACK_WPOLGENIN.genin_info_cd%TYPE,
		 gen_info01						GIPI_PACK_WPOLGENIN.gen_info01%TYPE,
		 gen_info02						GIPI_PACK_WPOLGENIN.gen_info02%TYPE,
		 gen_info03						GIPI_PACK_WPOLGENIN.gen_info03%TYPE,
		 gen_info04						GIPI_PACK_WPOLGENIN.gen_info04%TYPE,
		 gen_info05						GIPI_PACK_WPOLGENIN.gen_info05%TYPE,
		 gen_info06						GIPI_PACK_WPOLGENIN.gen_info06%TYPE,
		 gen_info07						GIPI_PACK_WPOLGENIN.gen_info07%TYPE,
		 gen_info08						GIPI_PACK_WPOLGENIN.gen_info08%TYPE,
		 gen_info09						GIPI_PACK_WPOLGENIN.gen_info09%TYPE,
		 gen_info10						GIPI_PACK_WPOLGENIN.gen_info10%TYPE,
		 gen_info11						GIPI_PACK_WPOLGENIN.gen_info11%TYPE,
		 gen_info12						GIPI_PACK_WPOLGENIN.gen_info12%TYPE,
		 gen_info13						GIPI_PACK_WPOLGENIN.gen_info13%TYPE,
		 gen_info14						GIPI_PACK_WPOLGENIN.gen_info14%TYPE,
		 gen_info15						GIPI_PACK_WPOLGENIN.gen_info15%TYPE,
		 gen_info16						GIPI_PACK_WPOLGENIN.gen_info16%TYPE,
		 gen_info17						GIPI_PACK_WPOLGENIN.gen_info17%TYPE,
		 dsp_gen_info					GIPI_PACK_WPOLGENIN.gen_info01%TYPE
	);
	
	TYPE rc_gipi_pack_wpolgenin_cur IS REF CURSOR RETURN gipis031A_pack_wpolgenin_type;
    
    TYPE gipi_pack_wpolgenin_type IS RECORD
    (pack_par_id            GIPI_PACK_WPOLGENIN.pack_par_id%TYPE,  
     agreed_tag             GIPI_PACK_WPOLGENIN.agreed_tag%TYPE,
     genin_info_cd          GIPI_PACK_WPOLGENIN.genin_info_cd%TYPE,
     gen_info01             GIPI_PACK_WPOLGENIN.gen_info01%TYPE,
     gen_info02             GIPI_PACK_WPOLGENIN.gen_info02%TYPE,
     gen_info03             GIPI_PACK_WPOLGENIN.gen_info03%TYPE,
     gen_info04             GIPI_PACK_WPOLGENIN.gen_info04%TYPE,
     gen_info05             GIPI_PACK_WPOLGENIN.gen_info05%TYPE,
     gen_info06             GIPI_PACK_WPOLGENIN.gen_info06%TYPE,
     gen_info07             GIPI_PACK_WPOLGENIN.gen_info07%TYPE,
     gen_info08             GIPI_PACK_WPOLGENIN.gen_info08%TYPE,
     gen_info09             GIPI_PACK_WPOLGENIN.gen_info09%TYPE,
     gen_info10             GIPI_PACK_WPOLGENIN.gen_info10%TYPE,
     gen_info11             GIPI_PACK_WPOLGENIN.gen_info11%TYPE,
     gen_info12             GIPI_PACK_WPOLGENIN.gen_info12%TYPE,
     gen_info13             GIPI_PACK_WPOLGENIN.gen_info13%TYPE,
	 gen_info14			    GIPI_PACK_WPOLGENIN.gen_info14%TYPE,
	 gen_info15			    GIPI_PACK_WPOLGENIN.gen_info15%TYPE,
	 gen_info16			    GIPI_PACK_WPOLGENIN.gen_info16%TYPE,
	 gen_info17			    GIPI_PACK_WPOLGENIN.gen_info17%TYPE,	 	 	 	 	 	 	 
	 initial_info01		    GIPI_PACK_WPOLGENIN.initial_info01%TYPE,
	 initial_info02		    GIPI_PACK_WPOLGENIN.initial_info02%TYPE,
	 initial_info03		    GIPI_PACK_WPOLGENIN.initial_info03%TYPE,
	 initial_info04		    GIPI_PACK_WPOLGENIN.initial_info04%TYPE,
	 initial_info05		    GIPI_PACK_WPOLGENIN.initial_info05%TYPE,
	 initial_info06		    GIPI_PACK_WPOLGENIN.initial_info06%TYPE,
	 initial_info07		    GIPI_PACK_WPOLGENIN.initial_info07%TYPE,
	 initial_info08		    GIPI_PACK_WPOLGENIN.initial_info08%TYPE,
	 initial_info09		    GIPI_PACK_WPOLGENIN.initial_info09%TYPE,
	 initial_info10		    GIPI_PACK_WPOLGENIN.initial_info10%TYPE,
	 initial_info11		    GIPI_PACK_WPOLGENIN.initial_info11%TYPE,
	 initial_info12		    GIPI_PACK_WPOLGENIN.initial_info12%TYPE,
	 initial_info13		    GIPI_PACK_WPOLGENIN.initial_info13%TYPE,
	 initial_info14		    GIPI_PACK_WPOLGENIN.initial_info14%TYPE,
	 initial_info15		    GIPI_PACK_WPOLGENIN.initial_info15%TYPE,
	 initial_info16		    GIPI_PACK_WPOLGENIN.initial_info16%TYPE,
	 initial_info17		    GIPI_PACK_WPOLGENIN.initial_info17%TYPE
	 );
	 
	 TYPE gipi_pack_wpolgenin_tab IS TABLE OF gipi_pack_wpolgenin_type;

	 
	
	 PROCEDURE set_gipi_pack_wpolgenin(p_par_id				 	        GIPI_PACK_WPOLGENIN.pack_par_id%TYPE,
									 p_genin_info_cd					GIPI_PACK_WPOLGENIN.genin_info_cd%TYPE,
									 p_gen_info01						GIPI_PACK_WPOLGENIN.gen_info01%TYPE,
									 p_gen_info02						GIPI_PACK_WPOLGENIN.gen_info02%TYPE,
									 p_gen_info03						GIPI_PACK_WPOLGENIN.gen_info03%TYPE,
									 p_gen_info04						GIPI_PACK_WPOLGENIN.gen_info04%TYPE,
									 p_gen_info05						GIPI_PACK_WPOLGENIN.gen_info05%TYPE,
									 p_gen_info06						GIPI_PACK_WPOLGENIN.gen_info06%TYPE,
									 p_gen_info07						GIPI_PACK_WPOLGENIN.gen_info07%TYPE,
									 p_gen_info08						GIPI_PACK_WPOLGENIN.gen_info08%TYPE,
									 p_gen_info09						GIPI_PACK_WPOLGENIN.gen_info09%TYPE,
									 p_gen_info10						GIPI_PACK_WPOLGENIN.gen_info10%TYPE,
									 p_gen_info11						GIPI_PACK_WPOLGENIN.gen_info11%TYPE,
									 p_gen_info12						GIPI_PACK_WPOLGENIN.gen_info12%TYPE,
									 p_gen_info13						GIPI_PACK_WPOLGENIN.gen_info13%TYPE,
									 p_gen_info14						GIPI_PACK_WPOLGENIN.gen_info14%TYPE,
									 p_gen_info15						GIPI_PACK_WPOLGENIN.gen_info15%TYPE,
									 p_gen_info16						GIPI_PACK_WPOLGENIN.gen_info16%TYPE,
									 p_gen_info17						GIPI_PACK_WPOLGENIN.gen_info17%TYPE,
									 p_user_id							GIPI_PACK_WPOLGENIN.user_id%TYPE
   			 						 );
    FUNCTION get_gipi_pack_wpolgenin (p_pack_par_id		GIPI_PACK_WPOLGENIN.pack_par_id%TYPE)
        RETURN gipi_pack_wpolgenin_tab PIPELINED;
    
    PROCEDURE set_gipi_pack_wpolgenin2 (
         p_pack_par_id		IN  GIPI_PACK_WPOLGENIN.pack_par_id%TYPE,
         p_agreed_tag		IN  GIPI_PACK_WPOLGENIN.agreed_tag%TYPE,
         p_genin_info_cd  	IN  GIPI_PACK_WPOLGENIN.genin_info_cd%TYPE,
         p_init_info01	    IN  VARCHAR2,
         p_init_info02	    IN  VARCHAR2,
         p_init_info03	    IN  VARCHAR2,
         p_init_info04	    IN  VARCHAR2,
         p_init_info05	    IN  VARCHAR2,
         p_init_info06	    IN  VARCHAR2,
         p_init_info07	    IN  VARCHAR2,
         p_init_info08	    IN  VARCHAR2,
         p_init_info09	    IN  VARCHAR2,
         p_init_info10	    IN  VARCHAR2,
         p_init_info11	    IN  VARCHAR2,
         p_init_info12	    IN  VARCHAR2,
         p_init_info13	    IN  VARCHAR2,
         p_init_info14	    IN  VARCHAR2,
         p_init_info15	    IN  VARCHAR2,
         p_init_info16	    IN  VARCHAR2,
         p_init_info17	    IN  VARCHAR2,
         p_gen_info01 		IN  VARCHAR2,
         p_gen_info02 		IN  VARCHAR2,
         p_gen_info03 		IN  VARCHAR2,
         p_gen_info04 		IN  VARCHAR2,
         p_gen_info05 		IN  VARCHAR2,
         p_gen_info06 		IN  VARCHAR2,
         p_gen_info07 		IN  VARCHAR2,
         p_gen_info08 		IN  VARCHAR2,
         p_gen_info09 		IN  VARCHAR2,
         p_gen_info10 		IN  VARCHAR2,
         p_gen_info11 		IN  VARCHAR2,
         p_gen_info12 		IN  VARCHAR2,
         p_gen_info13 		IN  VARCHAR2,
         p_gen_info14 		IN  VARCHAR2,
         p_gen_info15 		IN  VARCHAR2,
         p_gen_info16 		IN  VARCHAR2,
         p_gen_info17 		IN  VARCHAR2,
         p_user_id			IN  VARCHAR2
	);
    
    PROCEDURE del_gipi_pack_wpolgenin (p_pack_par_id        GIPI_PACK_WPOLGENIN.pack_par_id%TYPE);
    
    PROCEDURE chk_gipi_pack_wpolgenin_exist (p_pack_par_id  IN      GIPI_PACK_WPOLGENIN.pack_par_id%TYPE,
											 p_exist        OUT     NUMBER);
    
    PROCEDURE COPY_PACK_POL_WPOLGENIN(
        p_pack_par_id           gipi_parlist.pack_par_id%TYPE,
        p_pack_policy_id        gipi_pack_polgenin.pack_policy_id%TYPE,
        p_msg_alert         OUT VARCHAR2
        );
		
	PROCEDURE copy_pack_wpolgenin_giuts008a (
		p_policy_id   IN gipi_pack_wpolgenin.pack_par_id%TYPE,
		p_pack_par_id IN gipi_pack_wpolgenin.pack_par_id%TYPE,
		p_user_id     IN giis_users.user_id%TYPE
	);
            
END GIPI_PACK_WPOLGENIN_PKG;
/


