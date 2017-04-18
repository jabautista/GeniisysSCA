DROP FUNCTION CPI.CHECK_RECORDS_FOR_COI;

CREATE OR REPLACE FUNCTION CPI.CHECK_RECORDS_FOR_COI (
	p_line_cd		IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd	IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd		IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy		IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no	IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_WPOLBAS.renew_no%TYPE)
RETURN BOOLEAN
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.08.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This function checks if there are records available
	**  				: for coi cancellation	
	*/
	v_exist BOOLEAN := FALSE;
BEGIN
	FOR i IN (
		SELECT 1
		  FROM GIPI_POLBASIC a
		 WHERE EXISTS (
				SELECT '1'
				  FROM GIPI_ITMPERIL b
				 WHERE b.policy_id = a.policy_id
				   AND (NVL (a.tsi_amt, 0) <> 0 OR NVL (a.prem_amt, 0) <> 0))
		   AND a.pol_flag IN ('1', '2', '3')
		   AND NVL(a.endt_type,'A') = 'A'
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
		v_exist := TRUE;
		EXIT;
	END LOOP;

	RETURN v_exist;
END CHECK_RECORDS_FOR_COI;
/


