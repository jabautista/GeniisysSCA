DROP PROCEDURE CPI.CHECK_POLICY_FOR_SPOILAGE;

CREATE OR REPLACE PROCEDURE CPI.CHECK_POLICY_FOR_SPOILAGE (
	p_line_cd		IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd	IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd		IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy		IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no	IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_WPOLBAS.renew_no%TYPE,
	p_msg_alert		OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.24.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure is used for checking if the policy_no entered is already spoiled
	*/
	
	v_spld	VARCHAR2(1) := 'N';
	v_spld1	VARCHAR2(1) := 'N';
BEGIN	
	
	v_spld := Gipi_Polbasic_Pkg.get_spoiled_flag(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);	
	
	v_spld1 := Gipi_Polbasic_Pkg.get_spoiled_flag1(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
	
	IF v_spld1 = 'Y' THEN
		p_msg_alert := 'Policy has been spoiled. Cannot endorse a spoiled policy. ';
		GOTO RAISE_FORM_TRIGGER_FAILURE;
	ELSIF v_spld = 'Y' THEN
		p_msg_alert := 'Policy / Current endorsement has been tagged for spoilage. ' ||
			'Please do the necessary action before creating another one.';
		GOTO RAISE_FORM_TRIGGER_FAILURE;
	END IF;
  
	<<RAISE_FORM_TRIGGER_FAILURE>>
	NULL;
END CHECK_POLICY_FOR_SPOILAGE;
/


