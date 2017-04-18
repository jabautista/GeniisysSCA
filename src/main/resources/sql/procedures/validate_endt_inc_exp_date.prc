DROP PROCEDURE CPI.VALIDATE_ENDT_INC_EXP_DATE;

CREATE OR REPLACE PROCEDURE CPI.Validate_Endt_Inc_Exp_Date (
	p_field				IN VARCHAR2,
	p_incept_date		IN GIPI_WPOLBAS.incept_date%TYPE,
	p_eff_date			IN GIPI_WPOLBAS.eff_date%TYPE,
	p_expiry_date		IN GIPI_WPOLBAS.expiry_date%TYPE,
	p_par_id			IN GIPI_PARLIST.par_id%TYPE,
	p_line_cd			IN GIIS_SUBLINE.line_cd%TYPE,
	p_subline_cd		IN GIIS_SUBLINE.subline_cd%TYPE,
	p_iss_cd			IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy			IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no		IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no			IN GIPI_WPOLBAS.renew_no%TYPE,
	p_out_incept_date	OUT GIPI_WPOLBAS.incept_date%TYPE,
	p_out_expiry_date	OUT GIPI_WPOLBAS.expiry_date%TYPE,
	p_out_msg_alert		OUT VARCHAR2)	
AS
	v_incept_date	DATE := p_incept_date;
	v_eff_date		DATE := p_eff_date;
	v_expiry_date	DATE := p_expiry_date;
	v_add_time		NUMBER := 0;
BEGIN
	p_out_msg_alert := NULL;
	p_out_incept_date := p_incept_date;
	p_out_expiry_date := p_expiry_date;
	
	IF p_field = 'INCEPT_DATE' THEN
		IF TO_CHAR(v_incept_date, 'HH:MI:SS AM') = '12:00:00 AM' THEN
			Get_Addtl_Time_Gipis002(p_line_cd, p_subline_cd, v_add_time);
			p_out_incept_date := v_incept_date + v_add_time / 86400;
		END IF;
		
		FOR C1 IN (
			SELECT eff_date,expiry_date,incept_date
			  FROM GIPI_WPOLBAS
			 WHERE par_id     = p_par_id
			   AND line_cd    = p_line_cd
			   AND subline_cd = p_subline_cd 
			   AND iss_cd     = p_iss_cd
			   AND issue_yy   = p_issue_yy
			   AND pol_seq_no = p_pol_seq_no
			   AND renew_no   = p_renew_no
		  ORDER BY eff_date)
		LOOP
			IF C1.EFF_DATE IS NOT NULL THEN		
				IF v_eff_date < v_incept_date THEN 
					p_out_msg_alert := 'The new inception date should not be later than '|| TO_CHAR(C1.eff_date) || '.';
					p_out_incept_date := c1.incept_date;
				END IF;
			ELSE
				IF v_expiry_date < v_incept_date THEN
					p_out_msg_alert := 'The new inception date should not be later than '|| TO_CHAR (C1.expiry_date) || '.';
					p_out_incept_date := c1.incept_date;	
				END IF;
			END IF;
			EXIT;
		END LOOP;
	ELSIF p_field = 'PACK_INCEPT_DATE' THEN
		
		IF v_eff_date < v_incept_date THEN  -- added by: Nica 01.14.2013
           p_out_msg_alert := 'The new inception date should not be later than '||to_char(v_eff_date)||'.';
        END IF;
		
		IF v_expiry_date < v_incept_date THEN -- added by: Nica 01.14.2012
			p_out_msg_alert := 'Inception date should not be later than expiry date.';               
		END IF;
		
		FOR C1 IN (SELECT EFF_DATE,EXPIRY_DATE,INCEPT_DATE
	 	             FROM GIPI_PACK_WPOLBAS
	   	            WHERE PACK_PAR_ID     = p_par_id
			          AND LINE_CD    	  = p_line_cd
	                  AND SUBLINE_CD 	  = p_subline_cd
	 	   	          AND ISS_CD     	  = p_iss_cd
			          AND ISSUE_YY   	  = p_issue_yy
			          AND POL_SEQ_NO 	  = p_pol_seq_no
			          AND RENEW_NO   	  = p_renew_no
			     ORDER BY EFF_DATE) LOOP
	     IF C1.EFF_DATE IS NOT NULL THEN
	        IF v_eff_date < v_incept_date THEN 
	           p_out_msg_alert := 'The new inception date should not be later than '||to_char(C1.eff_date)||'.';
		       p_out_incept_date := c1.incept_date;
	        END IF;
	     ELSE
	        IF v_expiry_date < v_incept_date THEN
		       p_out_msg_alert := 'The new inception date should not be later than '||to_char(c1.expiry_date)||'.';
	  	       p_out_incept_date := c1.incept_date;	
	        END IF;
	     END IF;
	     EXIT;
	    END LOOP;
    ELSIF p_field = 'PACK_EXPIRY_DATE' THEN  -- added by: Nica 01.14.2012
        IF v_expiry_date < v_incept_date THEN
			p_out_msg_alert := 'Expiry date should not be earlier than  Inception Date.';               
		END IF;
	ELSE
		IF TO_CHAR(v_expiry_date, 'HH:MI:SS AM') = '12:00:00 AM' THEN
			Get_Addtl_Time_Gipis002(p_line_cd, p_subline_cd, v_add_time);
			p_out_expiry_date := v_expiry_date + v_add_time / 86400;
		END IF;
		
		IF v_expiry_date < v_incept_date THEN
			p_out_msg_alert := 'Expiry date should not be earlier than  Inception Date.';
		END IF;
	END IF;
END VALIDATE_ENDT_INC_EXP_DATE;
/


