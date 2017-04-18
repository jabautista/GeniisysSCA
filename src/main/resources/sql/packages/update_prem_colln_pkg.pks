CREATE OR REPLACE PACKAGE CPI.update_prem_colln_pkg
AS
	
	PROCEDURE fetch_prem_colln_update_values(
		p_prem_seq_no	IN		GIAC_PDC_PREM_COLLN.prem_seq_no%TYPE,
		p_iss_cd		IN		GIAC_PDC_PREM_COLLN.iss_cd%TYPE,
		p_intm_name		OUT		GIIS_INTERMEDIARY.intm_name%TYPE,
		p_policy_id		OUT		GIPI_COMM_INVOICE.policy_id%TYPE,
		p_add1			OUT		GIPI_POLBASIC.address1%TYPE,
		p_add2			OUT		GIPI_POLBASIC.address2%TYPE,
		p_add3			OUT		GIPI_POLBASIC.address3%TYPE,
		p_mail			OUT		VARCHAR2
	);
	
	FUNCTION get_particulars_1(
  		p_apdc_id		   GIAC_APDC_PAYT_DTL.apdc_id%TYPE,
		p_pdc_id		   GIAC_APDC_PAYT_DTL.pdc_id%TYPE,
		p_item_no		   GIAC_APDC_PAYT_DTL.item_no%TYPE
    ) RETURN VARCHAR2;
	
	FUNCTION get_particulars_2A(
  		p_apdc_id		   GIAC_APDC_PAYT_DTL.apdc_id%TYPE,
		p_pdc_id		   GIAC_APDC_PAYT_DTL.pdc_id%TYPE,
		p_item_no		   GIAC_APDC_PAYT_DTL.item_no%TYPE
    ) RETURN VARCHAR2;
  
    FUNCTION get_particulars_2(
  		p_apdc_id			 GIAC_APDC_PAYT_DTL.apdc_id%TYPE,
		p_curr_particulars	 VARCHAR2
    ) RETURN VARCHAR2;
	
	FUNCTION get_particulars_1A(
  		p_apdc_id			 GIAC_APDC_PAYT_DTL.apdc_id%TYPE
    ) RETURN VARCHAR2;
  
END update_prem_colln_pkg;
/


