DROP FUNCTION CPI.PRE_GET_AMOUNTS;

CREATE OR REPLACE FUNCTION CPI.PRE_GET_AMOUNTS (
	p_par_id			IN GIPI_WPOLBAS.par_id%TYPE,
	p_line_cd			IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd		IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd			IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy			IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no		IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no			IN GIPI_WPOLBAS.renew_no%TYPE,
	p_eff_date			IN GIPI_WPOLBAS.eff_date%TYPE)
RETURN VARCHAR2
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.01.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: Check endorsement expiry date againse endorsement eff date	
	*/
	v_expired_sw VARCHAR2(1) := 'N';
	v_msg_alert VARCHAR2(100) := '';
BEGIN
	--check first for the existance of short term endt.   
	FOR SW IN (
		SELECT '1'
		  FROM GIPI_ITMPERIL A,
			   GIPI_POLBASIC B
		 WHERE B.line_cd      =  p_line_cd
		   AND B.subline_cd   =  p_subline_cd
		   AND B.iss_cd       =  p_iss_cd
		   AND B.issue_yy     =  p_issue_yy
		   AND B.pol_seq_no   =  p_pol_seq_no
		   AND B.renew_no     =  p_renew_no
		   AND B.policy_id    =  A.policy_id
		   AND B.pol_flag     IN('1','2','3')
		   AND (NVL(A.prem_amt,0) <> 0 OR  NVL(A.tsi_amt,0) <> 0) 
		   AND TRUNC(b.eff_date) <= TRUNC(p_eff_date)
		   AND TRUNC(NVL(b.endt_expiry_date, b.expiry_date)) < TRUNC(p_eff_date)
	  ORDER BY B.eff_date DESC)
	LOOP
		v_expired_sw := 'Y';
		EXIT;
	END LOOP;
	
	IF v_expired_sw = 'Y' THEN
		--for policy with short term endt. amounts should be recomputed by adding up 
		--all policy and endt. that is not yet expired.
		FOR A2 IN (
			SELECT (C.tsi_amt * A.currency_rt) tsi,
				   (C.prem_amt * a.currency_rt) prem,       
				   B.eff_date,          B.endt_expiry_date,    B.expiry_date,
				   B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
				   B.short_rt_percent   short_rt,
				   C.peril_cd, b.incept_date
			  FROM GIPI_ITEM     A,
				   GIPI_POLBASIC B,  
				   GIPI_ITMPERIL C
			 WHERE B.line_cd      =  p_line_cd
			   AND B.subline_cd   =  p_subline_cd
			   AND B.iss_cd       =  p_iss_cd
			   AND B.issue_yy     =  p_issue_yy
			   AND B.pol_seq_no   =  p_pol_seq_no
			   AND B.renew_no     =  p_renew_no
			   AND B.policy_id    =  A.policy_id
			   AND B.policy_id    =  C.policy_id
			   AND A.item_no      =  C.item_no
			   AND B.pol_flag     IN('1','2','3') 
			   AND TRUNC(b.eff_date) <=  DECODE(NVL(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date))
			   AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(p_eff_date)) 
		LOOP		
			IF A2.prorate_flag = 1 THEN
				IF A2.endt_expiry_date <= A2.eff_date THEN
					v_msg_alert := 'Your endorsement expiry date is equal to or less than your effectivity date.'||
						' Restricted condition.';
					GOTO RAISE_FORM_TRIGGER_FAILURE;
				END IF;  
			END IF;		       
		END LOOP;
	END IF;
	
	FOR par_item IN (
		SELECT item_no
		  FROM GIPI_WITEM
		 WHERE par_id = p_par_id
		   AND rec_flag <> 'A')
	LOOP	 
		FOR A2 IN (
			SELECT (C.tsi_amt * A.currency_rt) tsi,
				   (C.prem_amt * a.currency_rt) prem,       
				   B.eff_date,          B.endt_expiry_date,    B.expiry_date,
				   B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
				   B.short_rt_percent   short_rt,
				   C.peril_cd, b.incept_date
			  FROM GIPI_ITEM     A,
				   GIPI_POLBASIC B,  
				   GIPI_ITMPERIL C
			 WHERE B.line_cd      =  p_line_cd
			   AND B.subline_cd   =  p_subline_cd
			   AND B.iss_cd       =  p_iss_cd
			   AND B.issue_yy     =  p_issue_yy
			   AND B.pol_seq_no   =  p_pol_seq_no
			   AND B.renew_no     =  p_renew_no
			   AND B.policy_id    =  A.policy_id
			   AND B.policy_id    =  C.policy_id
			   AND A.item_no      =  C.item_no
			   AND a.item_no      =  par_item.item_no
			   AND B.pol_flag IN ('1','2','3') 
			   AND TRUNC(b.eff_date) <=  DECODE(NVL(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date))
			   AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(p_eff_date)) 
		LOOP	 
			IF A2.prorate_flag = 1 THEN
				IF A2.endt_expiry_date <= A2.eff_date THEN
					v_msg_alert := 'Your endorsement expiry date is equal to or less than your effectivity date.'||
						' Restricted condition.';
					GOTO RAISE_FORM_TRIGGER_FAILURE;
				END IF;
			END IF;
		END LOOP;
	END LOOP;
	
	<<RAISE_FORM_TRIGGER_FAILURE>>
	RETURN v_msg_alert;
END PRE_GET_AMOUNTS;
/


