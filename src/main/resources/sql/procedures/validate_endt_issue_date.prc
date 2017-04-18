DROP PROCEDURE CPI.VALIDATE_ENDT_ISSUE_DATE;

CREATE OR REPLACE PROCEDURE CPI.Validate_Endt_Issue_Date (
	p_par_id		IN GIPI_WPOLBAS.par_id%TYPE,
	p_p_var_vdate 	IN VARCHAR2,	
	p_issue_date 	IN VARCHAR2,
	p_eff_date		IN VARCHAR2,
	p_p_var_idate	OUT VARCHAR2,
	p_booking_year	OUT VARCHAR2,
	p_booking_mth	OUT VARCHAR2,
	p_msg_alert		OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.11.2010
	**  Reference By 	: (GIPIS031 - Endt. Basic Information)
	**  Description 	: This procedure validates the endt_issue_date and returns values
	**					: to the calling environment to be used for other transaction	
	*/
	v_line_cd		GIPI_WPOLBAS.line_cd%TYPE;
	v_subline_cd	GIPI_WPOLBAS.subline_cd%TYPE;
	v_iss_cd		GIPI_WPOLBAS.iss_cd%TYPE;
	v_issue_yy		GIPI_WPOLBAS.issue_yy%TYPE;
	v_pol_seq_no	GIPI_WPOLBAS.pol_seq_no%TYPE;
	v_renew_no		GIPI_WPOLBAS.renew_no%TYPE;
	v_issue_date	DATE := TO_DATE(p_issue_date, 'MM-DD-RRRR');
	v_eff_date		DATE := TO_DATE(p_eff_date, 'MM-DD-RRRR');
	v_policy_issue_date  GIPI_POLBASIC.issue_date%TYPE;
	d1	VARCHAR2(10);
	d2	VARCHAR2(10);
	date_flag1	NUMBER := 2;
	date_flag2	NUMBER := 2;
BEGIN
	Gipi_Wpolbas_Pkg.get_gipi_wpolbas_par_no(p_par_id, v_line_cd, v_subline_cd, 
		v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no);
	
	IF p_p_var_vdate = '1' OR (p_p_var_vdate = '3' AND v_issue_date > v_eff_date) THEN
		FOR issue IN (
			SELECT issue_date
			  FROM GIPI_POLBASIC
			 WHERE line_cd     = v_line_cd
			   AND subline_cd  = v_subline_cd
			   AND iss_cd      = v_iss_cd
			   AND issue_yy    = v_issue_yy
			   AND pol_seq_no  = v_pol_seq_no
			   AND renew_no    = v_renew_no
			   AND endt_seq_no = 0)
		LOOP                     
			v_policy_issue_date := issue.issue_date;
			EXIT;
		END LOOP;
		
		IF TRUNC(v_issue_date) < TRUNC(v_policy_issue_date) THEN
			p_msg_alert := 'Endorsement issue date must not be earlier than Policy issue date ('||v_policy_issue_date||').';
			GOTO RAISE_FORM_TRIGGER_FAILURE;
		END IF;
		
		p_p_var_idate := TO_CHAR(v_issue_date, 'MM-DD-RRRR');
		d2 := v_eff_date;
		
		FOR c IN (
			SELECT booking_year, 
				   TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year), 'MM'), 
				   booking_mth 
			  FROM GIIS_BOOKING_MONTH
			 WHERE (NVL(booked_tag, 'N') != 'Y')
			   AND (booking_year > TO_NUMBER(TO_CHAR(v_issue_date, 'YYYY'))
				OR (booking_year = TO_NUMBER(TO_CHAR(v_issue_date, 'YYYY'))
			   AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year), 'MM'))>= TO_NUMBER(TO_CHAR(v_issue_date, 'MM'))))
		  ORDER BY 1, 2 )
		LOOP
			p_booking_year := c.booking_year;       
			p_booking_mth  := c.booking_mth;       	   
			date_flag2 := 5;
			EXIT;
		END LOOP;
		
		IF date_flag2 <> 5 THEN
			p_booking_year := NULL;
			p_booking_mth := NULL;
		END IF;
	ELSIF p_p_var_vdate = '2' OR (p_p_var_vdate = '3' AND v_issue_date <= v_eff_date) THEN
		p_p_var_idate := TO_CHAR(v_eff_date, 'MM-DD-RRRR');
		
		FOR c IN (
			SELECT booking_year, 
				   TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year), 'MM'), 
				   booking_mth 
			  FROM GIIS_BOOKING_MONTH
			 WHERE ( NVL(booked_tag, 'N') <> 'Y')
			   AND (booking_year > TO_NUMBER(TO_CHAR(v_eff_date, 'YYYY'))
				OR (booking_year = TO_NUMBER(TO_CHAR(v_eff_date, 'YYYY'))
			   AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year), 'MM'))>= TO_NUMBER(TO_CHAR(v_eff_date, 'MM'))))  	           
		  ORDER BY 1, 2 )
		LOOP
		   p_booking_year := c.booking_year;       
		   p_booking_mth  := c.booking_mth;       	   
		   date_flag2 := 5;
		   EXIT;
		END LOOP;
		
		IF date_flag2 <> 5 THEN
			p_booking_year := NULL;
			p_booking_mth := NULL;
		END IF;
	END IF;
	
	<<RAISE_FORM_TRIGGER_FAILURE>>
	NULL;
END Validate_Endt_Issue_Date;
/


