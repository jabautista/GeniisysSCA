DROP FUNCTION CPI.EXTRACT_INCEPT;

CREATE OR REPLACE FUNCTION CPI.Extract_Incept (
	p_line_cd		IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd	IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd		IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy		IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no	IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_WPOLBAS.renew_no%TYPE)
RETURN DATE
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.29.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This function returns the latest incept date in case there is an endorsement of inception
	*/
	v_max_eff_date      GIPI_POLBASIC.eff_date%TYPE;
	v_incept_date       GIPI_POLBASIC.incept_date%TYPE;
	v_max_endt_seq      GIPI_POLBASIC.endt_seq_no%TYPE;
BEGIN
	-- first get the expiry_date of the policy
	FOR A1 IN (
		SELECT incept_date
		  FROM GIPI_POLBASIC a
		 WHERE a.line_cd    = p_line_cd
		   AND a.subline_cd = p_subline_cd
		   AND a.iss_cd     = p_iss_cd
		   AND a.issue_yy   = p_issue_yy
		   AND a.pol_seq_no = p_pol_seq_no
		   AND a.renew_no   = p_renew_no
		   AND a.pol_flag IN ('1','2','3','X')
		   AND NVL(a.endt_seq_no,0) = 0)
	LOOP
		v_incept_date  := a1.incept_date;
		-- then check and retrieve for any change of incept in case there is 
		-- endorsement of expiry date
		FOR B1 IN (
			SELECT incept_date, endt_seq_no
			  FROM GIPI_POLBASIC a
			 WHERE a.line_cd    = p_line_cd
			   AND a.subline_cd = p_subline_cd
			   AND a.iss_cd     = p_iss_cd
			   AND a.issue_yy   = p_issue_yy
			   AND a.pol_seq_no = p_pol_seq_no
			   AND a.renew_no   = p_renew_no
			   AND a.pol_flag IN ('1','2','3','X')
			   AND NVL(a.endt_seq_no,0) > 0
			   AND incept_date <> a1.incept_date
			   AND incept_date = eff_date
		  ORDER BY a.eff_date DESC)
		LOOP
			v_incept_date  := b1.incept_date;
			v_max_endt_seq := b1.endt_seq_no;
			FOR B2 IN (
				SELECT incept_date, endt_seq_no
				  FROM GIPI_POLBASIC a
				 WHERE a.line_cd    = p_line_cd
				   AND a.subline_cd = p_subline_cd
				   AND a.iss_cd     = p_iss_cd
				   AND a.issue_yy   = p_issue_yy
				   AND a.pol_seq_no = p_pol_seq_no
				   AND a.renew_no   = p_renew_no
				   AND a.pol_flag IN ('1','2','3','X')
				   AND NVL(a.endt_seq_no,0) > b1.endt_seq_no
				   AND incept_date <> B1.incept_date
				   AND incept_date = eff_date
              ORDER BY a.eff_date DESC)
			LOOP
				v_incept_date  := b2.incept_date;
				v_max_endt_seq := b2.endt_seq_no;
				EXIT;
			END LOOP;
			
			--check for change in incept using backward endt. 
			FOR C IN (
				SELECT incept_date
				  FROM GIPI_POLBASIC a
				 WHERE a.line_cd    = p_line_cd
				   AND a.subline_cd = p_subline_cd
				   AND a.iss_cd     = p_iss_cd
				   AND a.issue_yy   = p_issue_yy
				   AND a.pol_seq_no = p_pol_seq_no
				   AND a.renew_no   = p_renew_no
				   AND a.pol_flag IN ('1','2','3','X')
				   AND NVL(a.endt_seq_no,0) > 0
				   AND incept_date <> a1.incept_date
				   AND incept_date = eff_date
				   AND NVL(a.back_stat,5) = 2
				   AND NVL(a.endt_seq_no,0) > v_max_endt_seq
			  ORDER BY a.endt_seq_no DESC)
			LOOP
				v_incept_date  := c.incept_date;
				EXIT;
			END LOOP;    
			EXIT;
		END LOOP;
	END LOOP;
	
	RETURN v_incept_date;
END Extract_Incept;
/


