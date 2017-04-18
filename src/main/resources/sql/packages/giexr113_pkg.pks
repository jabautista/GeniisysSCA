CREATE OR REPLACE PACKAGE CPI.GIEXR113_PKG
AS
	/*
	** Created By: bonok
	** Date Created: 01.16.2013
	** Reference By: GIEXR113
	** Description: Expiry List of Direct Business (BY ASSURED)
	*/
	TYPE giexr113_details_type IS RECORD(
		policy_no			VARCHAR(100),
		line_cd				giex_expiries_v.line_cd%TYPE,
        subline_cd			giex_expiries_v.subline_cd%TYPE,
        iss_cd				giex_expiries_v.iss_cd%TYPE,
        issue_yy			giex_expiries_v.issue_yy%TYPE,
        pol_seq_no			giex_expiries_v.pol_seq_no%TYPE,
        renew_no			giex_expiries_v.renew_no%TYPE,
        iss_cd2				giex_expiries_v.iss_cd%TYPE,
        line_cd2			giex_expiries_v.line_cd%TYPE,
        subline_cd2			giex_expiries_v.subline_cd%TYPE,
        policy_id			giex_expiries_v.policy_id%TYPE,
        tsi_amt				giex_expiries_v.tsi_amt%TYPE,
        prem_amt			giex_expiries_v.prem_amt%TYPE,
		ren_tsi_amt			giex_expiries_v.ren_tsi_amt%TYPE,
        ren_prem_amt		giex_expiries_v.ren_prem_amt%TYPE,
        tax_amt				giex_expiries_v.tax_amt%TYPE,
        expiry_date			giex_expiries_v.expiry_date%TYPE,
        balance_flag		giex_expiries_v.balance_flag%TYPE,
        claim_flag			giex_expiries_v.claim_flag%TYPE,
		assd_no				giex_expiries_v.assd_no%TYPE,
		assd_name			giis_assured.assd_name%TYPE,			
		line_name			giis_line.line_name%TYPE,
		subline_name		giis_subline.subline_name%TYPE,
		iss_name			giis_issource.iss_name%TYPE,
        total_due           giex_expiries_v.ren_prem_amt%TYPE,
        ref_pol_no          gipi_polbasic.ref_pol_no%TYPE,
        starting_date       VARCHAR2(50),
        ending_date         VARCHAR2(50)
	);
	
	TYPE giexr113_details_tab IS TABLE OF giexr113_details_type;
	
    TYPE giexr113_company_details_type IS RECORD(
		company_name        giis_parameters.param_value_v%TYPE,
        company_address     giis_parameters.param_value_v%TYPE
	);
	
	TYPE giexr113_company_details_tab IS TABLE OF giexr113_company_details_type;
    
	FUNCTION get_giexr113_details(
		p_line_cd			giex_expiries_v.line_cd%TYPE,
		p_subline_cd		giex_expiries_v.subline_cd%TYPE,
		p_iss_cd			giex_expiries_v.iss_cd%TYPE,
		p_intm_no			giex_expiries_v.intm_no%TYPE,
		p_assd_no			giex_expiries_v.assd_no%TYPE,
		p_policy_id			giex_expiries_v.policy_id%TYPE,
		p_starting_date		VARCHAR2,
		p_ending_date		VARCHAR2,        
		p_include_pack		VARCHAR2,
		p_claim_flag		giex_expiries_v.claim_flag%TYPE,
		p_balance_flag		giex_expiries_v.balance_flag%TYPE
	)
		RETURN giexr113_details_tab PIPELINED;
        
    FUNCTION get_giexr113_company_details
        RETURN giexr113_company_details_tab PIPELINED;
END;
/


