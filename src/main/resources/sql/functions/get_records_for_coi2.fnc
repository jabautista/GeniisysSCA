DROP FUNCTION CPI.GET_RECORDS_FOR_COI2;

CREATE OR REPLACE FUNCTION CPI.Get_Records_For_Coi2 (
	p_line_cd		IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd	IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd		IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy		IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no	IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_WPOLBAS.renew_no%TYPE)
RETURN Gipis031_Ref_Cursor_Pkg.cancel_record_tab PIPELINED
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.08.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure returns a cursor containing records
	**  				: for coi cancellation	
	*/
	v_table Gipis031_Ref_Cursor_Pkg.gipis031_cancel_records_type;
BEGIN
	FOR i IN (
		/*SELECT a.endt_iss_cd
			   || '-'
			   || LTRIM (RTRIM (TO_CHAR (a.endt_yy, '09')))
			   || '-'
			   || LTRIM (RTRIM (TO_CHAR (a.endt_seq_no, '099999'))) endorsement,
			   a.policy_id
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
				   AND pol_flag IN ('1', '2', '3'))
	  ORDER BY endorsement*/
		SELECT address1 endorsement, par_id policy_id
		  FROM GIPI_WPOLBAS
		 WHERE ROWNUM < 6)
	LOOP
		v_table.endorsement := i.endorsement;
		v_table.policy_id := i.policy_id;
		
		PIPE ROW(v_table);
	END LOOP;
	
	RETURN;
END Get_Records_For_Coi2;
/


