CREATE OR REPLACE PACKAGE CPI.GIPI_REASSIGN_POLICY_PKG
AS
	
	TYPE gipi_reassign_policy_type IS RECORD(
        par_id            	GIPI_PARLIST.par_id%TYPE,
        pack_par_id        	GIPI_PARLIST.pack_par_id%TYPE,
        line_cd             GIPI_PARLIST.line_cd%TYPE,
        iss_cd        		GIPI_PARLIST.iss_cd%TYPE,
        par_yy            	GIPI_PARLIST.par_yy%TYPE,
        par_seq_no          GIPI_PARLIST.par_seq_no%TYPE,
        quote_seq_no        GIPI_PARLIST.quote_seq_no%TYPE,
        assd_no           	GIPI_PARLIST.assd_no%TYPE,
        assign_sw           GIPI_PARLIST.assign_sw%TYPE,
        underwriter         GIPI_PARLIST.underwriter%TYPE,
        remarks           	GIPI_PARLIST.remarks%TYPE,
        par_status          GIPI_PARLIST.par_status%TYPE,
        par_type          	GIPI_PARLIST.par_type%TYPE,
		assd_name			GIIS_ASSURED.assd_name%TYPE,
		parstat_date		DATE,
		pack_pol_flag		GIIS_LINE.pack_pol_flag%TYPE
    );
    TYPE gipi_reassign_policy_tab IS TABLE OF gipi_reassign_policy_type;
	
	TYPE gipi_underwriter_type IS RECORD(
		user_id				GIIS_USERS.user_id%TYPE,
		user_grp			GIIS_USERS.user_grp%TYPE,
		user_name			GIIS_USERS.user_name%TYPE
	);
	
	TYPE gipi_underwriter_tab IS TABLE OF gipi_underwriter_type;
    
    TYPE get_user_sw_type IS RECORD(
		mgr_sw				GIIS_USERS.mgr_sw%TYPE,
		mis_sw			    GIIS_USERS.mis_sw%TYPE,
		all_user_sw			GIIS_USERS.all_user_sw%TYPE
	);
	
	TYPE get_user_sw_tab IS TABLE OF get_user_sw_type;
	
	FUNCTION get_reassign_par_policy(p_user_id  GIIS_USERS.user_id%TYPE)
		RETURN gipi_reassign_policy_tab PIPELINED;
	  
	FUNCTION get_parstat_date(p_par_id GIPI_PARLIST.par_id%TYPE)
		RETURN DATE;
		
	PROCEDURE set_gipis_reassign_parlist(p_underwriter       	GIPI_PARLIST.underwriter%TYPE,
        									p_remarks           GIPI_PARLIST.remarks%TYPE,
											p_par_id			GIPI_PARLIST.par_id%TYPE,
											p_par_status		GIPI_PARLIST.par_status%TYPE,
											p_line_cd			GIPI_PARLIST.line_cd%TYPE,
											p_cond				VARCHAR2);
										 
	FUNCTION get_reassign_par_policy_LOV(p_line_cd	GIPI_PARLIST.line_cd%TYPE,
									 p_iss_cd	GIPI_PARLIST.iss_cd%TYPE)
  	RETURN gipi_underwriter_tab PIPELINED;
    
    FUNCTION get_user_sw(p_user_id   GIIS_USERS.user_id%TYPE)
      RETURN get_user_sw_tab PIPELINED;
	
END GIPI_REASSIGN_POLICY_PKG;
/


