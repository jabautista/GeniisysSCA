DROP PROCEDURE CPI.CHECK_ITEM_DATES;

CREATE OR REPLACE PROCEDURE CPI.Check_Item_Dates (
	p_line_cd			IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd		IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd			IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy			IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no		IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no			IN GIPI_WPOLBAS.renew_no%TYPE,
	p_exist				OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.28.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure checks if there is
	**					: an existing record on the following tables
	*/
BEGIN
	p_exist := 'N';
	FOR item IN (
		SELECT DISTINCT b.item_no
		  FROM GIPI_POLBASIC a,
			   GIPI_ITEM     b
		 WHERE 1=1
		   AND a.policy_id  = b.policy_id
		   AND a.line_cd    = p_line_cd
		   AND a.subline_cd = p_subline_cd
		   AND a.iss_cd     = p_iss_cd
		   AND a.issue_yy   = p_issue_yy
		   AND a.pol_seq_no = p_pol_seq_no
		   AND a.renew_no   = p_renew_no
		   AND a.pol_flag  IN ('1','2','3')
		   AND (b.from_date IS NOT NULL OR b.TO_DATE IS NOT NULL))
	LOOP
		FOR rec IN (
			SELECT d.item_no,d.item_title,TRUNC(d.from_date) from_date,
				   TRUNC(d.TO_DATE) TO_DATE,
				   d.currency_cd,d.currency_rt,d.region_cd
			  FROM GIPI_POLBASIC c,
				   GIPI_ITEM     d
			 WHERE 1=1
			   AND c.policy_id  = d.policy_id
			   AND c.line_cd    = p_line_cd
			   AND c.subline_cd = p_subline_cd
			   AND c.iss_cd     = p_iss_cd
			   AND c.issue_yy   = p_issue_yy
			   AND c.pol_seq_no = p_pol_seq_no
			   AND c.renew_no   = p_renew_no
			   AND c.pol_flag   IN ('1','2','3')
			   AND (d.from_date IS NOT NULL OR d.TO_DATE IS NOT NULL)
			   AND d.item_no    = item.item_no
			   AND NOT EXISTS (SELECT '1'
								 FROM GIPI_POLBASIC X,
									  GIPI_ITEM y
								WHERE 1=1
								  AND X.policy_id  = y.policy_id
								  AND X.line_cd    = p_line_cd
								  AND X.subline_cd = p_subline_cd
								  AND X.iss_cd     = p_iss_cd
								  AND X.issue_yy   = p_issue_yy
								  AND X.pol_seq_no = p_pol_seq_no
								  AND X.renew_no   = p_renew_no
								  AND X.pol_flag IN ('1','2','3')
								  AND y.item_no    = item.item_no
								  AND (y.from_date IS NOT NULL OR y.TO_DATE IS NOT NULL)
								  AND X.endt_seq_no > c.endt_seq_no
								  AND NVL(X.back_stat,5) = 2)
		 ORDER BY eff_date DESC)
		LOOP
			p_exist := 'Y';
		END LOOP;
	END LOOP;
END CHECK_ITEM_DATES;
/


