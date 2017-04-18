DROP PROCEDURE CPI.GIPIS031_PRORATE_FLAG_INTRRPTN;

CREATE OR REPLACE PROCEDURE CPI.Gipis031_Prorate_Flag_Intrrptn (
	p_par_id 				IN GIPI_WPOLBAS.par_id%TYPE,	
	p_incept_date			IN VARCHAR2,
	p_eff_date				IN VARCHAR2,
	p_record_status			IN VARCHAR2,	
	p_msg_alert				OUT VARCHAR2,
	p_complete_transaction	OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.07.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure is called to checked if possible interruption may occur before executing the procedures
	*/
	v_line_cd		GIPI_WPOLBAS.line_cd%TYPE;
	v_subline_cd	GIPI_WPOLBAS.subline_cd%TYPE;
	v_iss_cd		GIPI_WPOLBAS.iss_cd%TYPE;
	v_issue_yy		GIPI_WPOLBAS.issue_yy%TYPE;
	v_pol_seq_no	GIPI_WPOLBAS.pol_seq_no%TYPE;
	v_renew_no		GIPI_WPOLBAS.renew_no%TYPE;
	v_incept_date	GIPI_WPOLBAS.incept_date%TYPE;
	v_eff_date		GIPI_WPOLBAS.eff_date%TYPE;
	
BEGIN
	p_complete_transaction := 'FALSE';
	FOR i IN (
		SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, 
			   TO_DATE(p_incept_date,'MM-DD-RRRR') + (incept_date - TO_DATE(p_incept_date,'MM-DD-RRRR')) new_incept_date,
   			   TO_DATE(p_eff_date,'MM-DD-RRRR') + (eff_date - TO_DATE(p_eff_date,'MM-DD-RRRR')) new_eff_date
		  FROM GIPI_WPOLBAS
		 WHERE par_id = p_par_id)
	LOOP
		v_line_cd		:= i.line_cd;
		v_subline_cd	:= i.subline_cd;
		v_iss_cd		:= i.iss_cd;
		v_issue_yy		:= i.issue_yy;
		v_pol_seq_no	:= i.pol_seq_no;
		v_renew_no		:= i.renew_no;
		v_incept_date	:= i.new_incept_date;
		v_eff_date		:= i.new_eff_date;
	END LOOP;
	
	
	-- check for existence of claims and if pending claim(s) is found
	-- disallow cancellation process
	FOR A1 IN (
		SELECT b.claim_id
		  FROM GIPI_POLBASIC a,
			   GICL_CLAIMS   b
		 WHERE a.line_cd     = b.line_cd
		   AND a.subline_cd  = b.subline_cd
		   AND a.iss_cd      = b.pol_iss_cd
		   AND a.issue_yy    = b.issue_yy
		   AND a.pol_seq_no  = b.pol_seq_no
		   AND a.renew_no    = b.renew_no
		   AND NVL(a.endt_seq_no,0) = 0
		   AND clm_stat_cd NOT IN ('CC','DN','WD','CD')
		   AND a.line_cd       = v_line_cd
		   AND a.subline_cd    = v_subline_cd
		   AND a.iss_cd        = v_iss_cd
		   AND a.issue_yy      = v_issue_yy
		   AND a.pol_seq_no    = v_pol_seq_no
		   AND a.renew_no      = v_renew_no)
	LOOP		
		p_msg_alert := 'The policy has pending claims, cannot cancel policy.';
		GOTO RAISE_FORM_TRIGGER_FAILURE;
	END LOOP;
	
	/* display a warning before cancelling a paid policy */
	FOR a IN (
		SELECT SUM(c.total_payments) paid_amt
		  FROM GIPI_POLBASIC a, GIPI_INVOICE b, GIAC_AGING_SOA_DETAILS c
		 WHERE a.line_cd     = v_line_cd
		   AND a.subline_cd  = v_subline_cd
		   AND a.iss_cd      = v_iss_cd
		   AND a.issue_yy    = v_issue_yy
		   AND a.pol_seq_no  = v_pol_seq_no
		   AND a.renew_no    = v_renew_no
		   AND a.pol_flag IN ('1','2','3')
		   AND a.policy_id = b.policy_id
		   AND b.iss_cd = c.iss_cd
		   AND b.prem_seq_no = c.prem_seq_no)
	LOOP
		IF a.paid_amt <> 0 THEN
	        p_msg_alert := 'Payments have been made to the policy/endorsement to be cancelled. Continue?';	        
	    END IF;
    END LOOP;
	
	/* check if PAR already have existing items and perils*/
	DECLARE
		v_item	NUMBER := 0;
		v_peril NUMBER := 0;
	BEGIN
		FOR ITEM IN (
			SELECT 1
			  FROM GIPI_WITEM
			 WHERE par_id = p_par_id)
		LOOP
			v_item := v_item + 1;
		END LOOP;
		
		FOR PERIL IN (
			SELECT 1
			  FROM GIPI_WITMPERL
			 WHERE par_id = p_par_id)
		LOOP
			v_peril := v_peril + 1;
		END LOOP;
		
		IF v_item > 0 OR v_peril > 0 THEN
			IF NOT p_msg_alert IS NULL THEN
				p_msg_alert := p_msg_alert || CHR(10);
			END IF;
			
			IF v_item > 0 AND v_peril > 0 THEN				
				p_msg_alert := 'This endorsement have existing item(s) and peril(s), performing cancellation will cause all the records to be replaced.';
			ELSIF v_item > 0 THEN				
				p_msg_alert := 'This endorsement have existing item(s), performing cancellation will cause all the records to be replaced.';
			END IF;
		END IF;
	END;
	
	/* check amounts */
	DECLARE
		v_expired_sw VARCHAR2(1) := 'N';
	BEGIN
		FOR SW IN (
			SELECT '1'
              FROM GIPI_ITMPERIL A,
                   GIPI_POLBASIC B
             WHERE B.line_cd      =  v_line_cd
               AND B.subline_cd   =  v_subline_cd
               AND B.iss_cd       =  v_iss_cd
               AND B.issue_yy     =  v_issue_yy
               AND B.pol_seq_no   =  v_pol_seq_no
               AND B.renew_no     =  v_renew_no
               AND B.policy_id    =  A.policy_id
               AND B.pol_flag     IN('1','2','3')
               AND (NVL(A.prem_amt,0) <> 0 OR  NVL(A.tsi_amt,0) <> 0) 
               AND TRUNC(b.eff_date) <= TRUNC(v_eff_date)
               AND TRUNC(NVL(b.endt_expiry_date, b.expiry_date)) <TRUNC(v_eff_date)
          ORDER BY B.eff_date DESC)
		LOOP
			v_expired_sw := 'Y';
			EXIT;
		END LOOP;
		
		IF v_expired_sw = 'Y' THEN
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
                 WHERE B.line_cd      =  v_line_cd
                   AND B.subline_cd   =  v_subline_cd
                   AND B.iss_cd       =  v_iss_cd
                   AND B.issue_yy     =  v_issue_yy
                   AND B.pol_seq_no   =  v_pol_seq_no
                   AND B.renew_no     =  v_renew_no
                   AND B.policy_id    =  A.policy_id
                   AND B.policy_id    =  C.policy_id
                   AND A.item_no      =  C.item_no
                   AND B.pol_flag     IN('1','2','3') 
                   AND TRUNC(b.eff_date) <=  DECODE(NVL(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(v_eff_date))
                   AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(v_eff_date)) 
			LOOP
				IF A2.prorate_flag = 1 THEN
					IF A2.endt_expiry_date <= A2.eff_date THEN
						p_msg_alert := 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.';
						GOTO RAISE_FORM_TRIGGER_FAILURE;
					END IF;
				END IF;
			END LOOP;
			
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
					 WHERE B.line_cd      =  v_line_cd
                       AND B.subline_cd   =  v_subline_cd
                       AND B.iss_cd       =  v_iss_cd
                       AND B.issue_yy     =  v_issue_yy
                       AND B.pol_seq_no   =  v_pol_seq_no
                       AND B.renew_no     =  v_renew_no
                       AND B.policy_id    =  A.policy_id
                       AND B.policy_id    =  C.policy_id
                       AND A.item_no      =  C.item_no
                       AND a.item_no      =  par_item.item_no
                       AND B.pol_flag     IN('1','2','3') 
                       AND TRUNC(b.eff_date) <=  DECODE(NVL(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(v_eff_date))
                       AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(v_eff_date)) 
				LOOP
					IF A2.prorate_flag = 1 THEN
						IF A2.endt_expiry_date <= A2.eff_date THEN
							p_msg_alert := 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.';
							GOTO RAISE_FORM_TRIGGER_FAILURE;
						END IF;
					END IF;
				END LOOP;
			END LOOP;
		END IF;
	END;
	
	p_complete_transaction := 'TRUE';
	
	<<RAISE_FORM_TRIGGER_FAILURE>>
	NULL;
END Gipis031_Prorate_Flag_Intrrptn;
/


