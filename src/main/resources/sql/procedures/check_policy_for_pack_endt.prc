DROP PROCEDURE CPI.CHECK_POLICY_FOR_PACK_ENDT;

CREATE OR REPLACE PROCEDURE CPI.Check_Policy_For_Pack_Endt (
	p_line_cd			IN gipi_pack_wpolbas.line_cd%TYPE,
	p_subline_cd		IN gipi_pack_wpolbas.subline_cd%TYPE,
	p_iss_cd			IN gipi_pack_wpolbas.iss_cd%TYPE,
	p_issue_yy			IN gipi_pack_wpolbas.issue_yy%TYPE,
	p_pol_seq_no		IN gipi_pack_wpolbas.pol_seq_no%TYPE,
	p_renew_no			IN gipi_pack_wpolbas.renew_no%TYPE,
	p_pack_pol_flag		OUT gipi_pack_wpolbas.pack_pol_flag%TYPE,
	p_entered_pol_no	OUT VARCHAR2,
	p_policy_spoilage	OUT VARCHAR2,
	p_check_claims		OUT VARCHAR2)
AS	
	/*	Date        Author			Description
    **	==========	===============	============================
    **	11.12.2010	Emman			This procedure checks the policy_no for possible problems
	**								and returns result from different validation	
    **                              Reference by : (GIPIS031A - Pack Endt Basic Information)
    **    11.02.2011    mark jm            added p_pack_pol_flag to be returned
    */
BEGIN
    Check_Entered_Pack_Policy_No(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, 
        p_pol_seq_no, p_renew_no, p_pack_pol_flag, p_entered_pol_no);
    
    Check_Pack_Policy_For_Spoilage(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, 
        p_pol_seq_no, p_renew_no, p_policy_spoilage);
    
    Check_Claims(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, 
        p_pol_seq_no, p_renew_no, p_check_claims);    
    
END Check_Policy_For_Pack_Endt;
/


