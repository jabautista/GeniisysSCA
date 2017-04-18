CREATE OR REPLACE PACKAGE CPI.UW_REPORTS_POLICY_BOND_PKG AS
	TYPE uw_rpt_pol_bond_type IS RECORD
	(policy_id		GIPI_POLBASIC.policy_id%TYPE
	,expiry_date	GIPI_POLBASIC.expiry_date%TYPE
	,endt_iss_cd	GIPI_POLBASIC.endt_iss_cd%TYPE
	,endt_seq_no	GIPI_POLBASIC.endt_seq_no%TYPE
	,endt_type		GIPI_POLBASIC.endt_type%TYPE
	,endt_yy		GIPI_POLBASIC.endt_yy%TYPE
	,line_cd		GIPI_POLBASIC.line_cd%TYPE
	,subline_cd		GIPI_POLBASIC.subline_cd%TYPE
	,iss_cd			GIPI_POLBASIC.iss_cd%TYPE
	,issue_yy		GIPI_POLBASIC.issue_yy%TYPE
	,pol_seq_no		GIPI_POLBASIC.pol_seq_no%TYPE
	,renew_no2		GIPI_POLBASIC.renew_no%TYPE
	,endt_tsi_amt	GIPI_POLBASIC.tsi_amt%TYPE
	,endt_prem_amt	GIPI_POLBASIC.prem_amt%TYPE
	,endt_ann_tsi_amt	GIPI_POLBASIC.ann_tsi_amt%TYPE
	,endt_ann_prem_amt	GIPI_POLBASIC.ann_prem_amt%TYPE
	,endt_eff_date	GIPI_BOND_BASIC.endt_eff_date%TYPE
	,subline_name	GIIS_SUBLINE.subline_name%TYPE
	,issue_date		GIPI_POLBASIC.issue_date%TYPE
	,assd_name		GIIS_ASSURED.assd_name%TYPE
	,assd_no		GIIS_ASSURED.assd_no%TYPE
	,bill_addr1		GIIS_ASSURED.bill_addr1%TYPE
	,bill_addr2		GIIS_ASSURED.bill_addr2%TYPE
	,bill_addr3		GIIS_ASSURED.bill_addr3%TYPE
	,endt_text		VARCHAR2(4000) --GIPI_ENDTTEXT.endt_text%TYPE
	,prin_signor1	GIIS_PRIN_SIGNTRY.prin_signor%TYPE
	,designation3	GIIS_PRIN_SIGNTRY.designation%TYPE
	,obligee_no1	GIIS_OBLIGEE.obligee_no%TYPE
	,address1		GIIS_OBLIGEE.address1%TYPE
	,address2		GIIS_OBLIGEE.address2%TYPE
	,address3		GIIS_OBLIGEE.address3%TYPE
	,obligee_name1	GIIS_OBLIGEE.obligee_name%TYPE
	);
	
	TYPE uw_rpt_pol_bond_tab IS TABLE OF uw_rpt_pol_bond_type;
	
	FUNCTION get_uw_endt_bond (p_policy_id	GIPI_POLBASIC.policy_id%TYPE
		,p_subline_cd	GIPI_POLBASIC.subline_cd%TYPE
		,p_endt_cd		GIPI_POLBASIC.endt_iss_cd%TYPE
		,p_endt_yy		GIPI_POLBASIC.endt_yy%TYPE
		,p_endt_seq_no	GIPI_POLBASIC.endt_seq_no%TYPE)
        
		RETURN uw_rpt_pol_bond_tab PIPELINED;

END UW_REPORTS_POLICY_BOND_PKG;
/


