CREATE OR REPLACE PACKAGE CPI.GICLR268A_PKG
	/*
    **  Created by        : Steven Ramirez
    **  Date Created      : 03.12.2013
    **  Reference By      : GICLR268A - RECOVERY LISTING PER PLATE NO 
    */
AS
	TYPE giclr268A_type IS RECORD(
		plate_no			gicl_motor_car_dtl.plate_no%TYPE,
        claim_id            gicl_claims.claim_id%TYPE,
		claim_no			VARCHAR (50),
		policy_no			VARCHAR (50),
		assured_name		gicl_claims.assured_name%TYPE,
		loss_date			gicl_claims.loss_date%TYPE,
		recovery_no			VARCHAR (50),
		recovery_type		giis_recovery_type.rec_type_desc%TYPE,
		recovery_status		giis_recovery_status.rec_stat_desc%TYPE,
		recoverable_amt		gicl_clm_recovery.recoverable_amt%TYPE,
		recovered_amt		gicl_clm_recovery.recovered_amt%TYPE,
		payor				VARCHAR (600),
		recovered_payor		gicl_recovery_payor.recovered_amt%TYPE,
		clm_file_date		gicl_claims.clm_file_date%TYPE,
		report_title		VARCHAR2(50),
	 	company_name        giis_parameters.param_value_v%TYPE,
        company_address     giis_parameters.param_value_v%TYPE,
		date_type           VARCHAR(150)
    );
    
    TYPE giclr268A_tab IS TABLE OF giclr268A_type;
    
    FUNCTION get_giclr268A_details(
		p_plate_no			gicl_motor_car_dtl.plate_no%TYPE,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
		p_as_of_date        VARCHAR2,
	 	p_from_ldate        VARCHAR2,
        p_to_ldate          VARCHAR2,
		p_as_of_ldate       VARCHAR2,
		p_user_id			GIIS_USERS.user_id%TYPE
    ) RETURN giclr268A_tab PIPELINED;
	
END;
/


