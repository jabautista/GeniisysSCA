CREATE OR REPLACE PACKAGE CPI.GIPI_REASSIGN_ENDT_PKG
AS
	TYPE gipi_reassign_endt_type IS RECORD(
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
    TYPE gipi_reassign_endt_tab IS TABLE OF gipi_reassign_endt_type;
	
	TYPE gipi_underwriter_type IS RECORD(
		user_id				GIIS_USERS.user_id%TYPE,
		user_grp			GIIS_USERS.user_grp%TYPE,
		user_name			GIIS_USERS.user_name%TYPE
	);
	
	TYPE gipi_underwriter_tab IS TABLE OF gipi_underwriter_type;
	
	FUNCTION get_reassign_par_endt(p_user_id			GIIS_USERS.user_id%TYPE)
		RETURN gipi_reassign_endt_tab PIPELINED;
	  
	FUNCTION get_parstat_date(p_par_id GIPI_PARLIST.par_id%TYPE)
		RETURN DATE;
		
	FUNCTION get_reassign_par_endt_LOV(p_line_cd	GIPI_PARLIST.line_cd%TYPE,
									 p_iss_cd	GIPI_PARLIST.iss_cd%TYPE)
  	RETURN gipi_underwriter_tab PIPELINED;
	
	FUNCTION check_user(p_user_id			GIIS_USERS.user_id%TYPE,
						p_underwriter		GIPI_PARLIST.underwriter%TYPE)
	RETURN VARCHAR2;
	
	PROCEDURE set_gipis_reassign_parlist(p_underwriter      GIPI_PARLIST.underwriter%TYPE,
										p_remarks           GIPI_PARLIST.remarks%TYPE,
										p_par_id			GIPI_PARLIST.par_id%TYPE,
										p_par_status		GIPI_PARLIST.par_status%TYPE,
										p_line_cd			GIPI_PARLIST.line_cd%TYPE);
											
	PROCEDURE update_parhist(p_underwriter      GIPI_PARLIST.underwriter%TYPE,
							p_remarks           GIPI_PARLIST.remarks%TYPE,
							p_par_id			GIPI_PARLIST.par_id%TYPE,
							p_par_status		GIPI_PARLIST.par_status%TYPE,
							p_line_cd			GIPI_PARLIST.line_cd%TYPE);
							
	PROCEDURE CREATE_TRANSFER_WORKFLOW_REC(p_module_id  	IN VARCHAR2,
											p_underwriter 	IN VARCHAR2,
										   	p_user_id       IN VARCHAR2,
										   	p_par_id  		IN VARCHAR2,
											p_line_cd  		IN VARCHAR2,
											p_iss_cd  		IN VARCHAR2,
											p_par_yy  		IN VARCHAR2,
											p_par_seq_no	IN VARCHAR2,
											p_quote_seq_no	IN VARCHAR2,
											p_msg    		OUT VARCHAR2); 
END;
/


