DROP FUNCTION CPI.CHECK_POL_FOR_ENDT_TO_CANCEL;

CREATE OR REPLACE FUNCTION CPI.CHECK_POL_FOR_ENDT_TO_CANCEL (
	p_line_cd			IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd		IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd			IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy			IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no		IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no			IN GIPI_WPOLBAS.renew_no%TYPE)
RETURN VARCHAR2
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.06.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This function checks if policy have affecting endorsement that can be cancelled	
	*/
	v_endt_sw VARCHAR2(1) := 'N';
BEGIN
	FOR A IN (
		SELECT DISTINCT '1'
		  FROM GIPI_POLBASIC a, GIPI_ITMPERIL b
		 WHERE a.policy_id = b.policy_id
		   AND a.line_cd = b.line_cd
		   AND (NVL (b.tsi_amt, 0) <> 0 OR NVL (b.prem_amt, 0) <> 0)  	
		   AND NOT EXISTS (SELECT '1'
							 FROM GIAC_DIRECT_PREM_COLLNS y, GIPI_INVOICE z
							WHERE y.b140_iss_cd = z.iss_cd
							  AND y.b140_prem_seq_no = z.prem_seq_no
							  AND z.policy_id = a.policy_id)
		   AND a.pol_flag IN ('1', '2', '3')
		   AND NVL(a.endt_seq_no,0) > 0 
		   AND a.endt_type = 'A'
		   AND a.line_cd = p_line_cd
		   AND a.subline_cd = p_subline_cd
		   AND a.iss_cd = p_iss_cd
		   AND a.issue_yy = p_issue_yy
		   AND a.pol_seq_no = p_pol_seq_no
		   AND a.renew_no = p_renew_no
		   AND a.cancelled_endt_id IS NULL
		   AND NOT EXISTS (
					SELECT '1'
					  FROM GIPI_POLBASIC
					 WHERE a.policy_id = cancelled_endt_id
					   AND pol_flag IN ('1', '2', '3')))
  		LOOP
    		v_endt_sw := 'Y';
    		EXIT;
		END LOOP;
		
		RETURN v_endt_sw;
END CHECK_POL_FOR_ENDT_TO_CANCEL;
/


