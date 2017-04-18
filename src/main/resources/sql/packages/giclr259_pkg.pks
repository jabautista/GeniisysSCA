CREATE OR REPLACE PACKAGE CPI.GICLR259_PKG
    /*
    **  Created by        : Steven Ramirez
    **  Date Created      : 03.11.2013
    **  Reference By      : GICLR259 - CLAIM LISTING PER PAYEE
    */
AS
    TYPE giclr259_type IS RECORD(
        claim_id            gicl_claims.claim_id%TYPE,
		line_cd				gicl_claims.line_cd%TYPE,
		payee_class_cd		giis_payees.payee_class_cd%TYPE,
		payee_no			giis_payees.payee_no%TYPE,
		payee_class			VARCHAR2 (100),
		payee_name			VARCHAR2 (600), --changed by robert from 200 01.03.2014
		claim_number		VARCHAR (50),
		policy_number		VARCHAR (50),
		assured_name		gicl_claims.assured_name%TYPE,
		item_no				gicl_clm_loss_exp.item_no%TYPE,
		paid_amt			gicl_clm_loss_exp.paid_amt%TYPE,
		net_amt				gicl_clm_loss_exp.net_amt%TYPE,
		advise_amt			gicl_clm_loss_exp.advise_amt%TYPE,
		peril				VARCHAR2 (200),
		hist_seq_no			VARCHAR2 (10),
		item				VARCHAR2 (200),
		advice_id			gicl_clm_loss_exp.advice_id%TYPE,
		dsp_loss_date		gicl_claims.dsp_loss_date%TYPE,
		cf_advice_no		VARCHAR2(20),
	 	company_name        giis_parameters.param_value_v%TYPE,
        company_address     giis_parameters.param_value_v%TYPE,
		date_type           VARCHAR(150)
    );
    
    TYPE giclr259_tab IS TABLE OF giclr259_type;
    
    FUNCTION get_giclr259_details(
        p_payee_no         	GIIS_PAYEES.payee_no%TYPE,
      	p_payee_class_cd   	GIIS_PAYEE_CLASS.payee_class_cd%TYPE,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
		p_as_of_date        VARCHAR2,
	 	p_from_ldate        VARCHAR2,
        p_to_ldate          VARCHAR2,
		p_as_of_ldate       VARCHAR2,
		p_user_id			GIIS_USERS.user_id%TYPE
    ) RETURN giclr259_tab PIPELINED;
END GICLR259_PKG;
/


