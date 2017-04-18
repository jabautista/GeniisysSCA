DROP PROCEDURE CPI.CHECK_CLAIMS;

CREATE OR REPLACE PROCEDURE CPI.Check_Claims (
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
	**  Description 	: For policy and endorsement -check if there are
	**					: existing claim(s) for the policy  and if the loss date
	**					: of the claim is later or equal to policy/endt effectivity date
	*/
	v_claim_id GICL_CLAIMS.claim_id%TYPE;
BEGIN	
	
	v_claim_id := Gicl_Claims_Pkg.get_claim_id(p_line_cd, p_subline_cd, 
		p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
	
	IF v_claim_id IS NOT NULL THEN
		p_msg_alert := 'The policy has claims pending.';		
	END IF;  
	
END Check_Claims;
/


