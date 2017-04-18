DROP PROCEDURE CPI.CHECK_POLICY_FOR_ENDT;

CREATE OR REPLACE PROCEDURE CPI.Check_Policy_For_Endt (
	p_line_cd			IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd		IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd			IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy			IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no		IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no			IN GIPI_WPOLBAS.renew_no%TYPE,
	p_entered_pol_no	OUT VARCHAR2,
	p_policy_spoilage	OUT VARCHAR2,
	p_check_claims		OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.14.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure checks the policy_no for possible problems
	**					: and returns result from different validation	
	*/
BEGIN
	Check_Entered_Policy_Number(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, 
		p_pol_seq_no, p_renew_no, p_entered_pol_no);
	
	Check_Policy_For_Spoilage(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, 
		p_pol_seq_no, p_renew_no, p_policy_spoilage);
	
	Check_Claims(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, 
		p_pol_seq_no, p_renew_no, p_check_claims);	
	
END Check_Policy_For_Endt;
/


