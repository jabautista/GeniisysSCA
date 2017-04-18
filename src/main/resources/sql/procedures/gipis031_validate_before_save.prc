DROP PROCEDURE CPI.GIPIS031_VALIDATE_BEFORE_SAVE;

CREATE OR REPLACE PROCEDURE CPI.Gipis031_Validate_Before_Save (
	p_par_id					IN GIPI_PARLIST.par_id%TYPE,
	p_line_cd					IN GIPI_PARLIST.line_cd%TYPE,
	p_iss_cd					IN GIPI_PARLIST.iss_cd%TYPE,
	p_pol_flag					IN GIPI_WPOLBAS.pol_flag%TYPE,
	p_nbt_pol_flag 				IN VARCHAR2,
	p_prorate_sw 				IN VARCHAR2,
	p_p_back_endt_sw			IN VARCHAR2,
	p_p_ins_winvoice			IN VARCHAR2,
	p_survey_agent_cd			IN VARCHAR2,
	p_settling_agent_cd 		IN VARCHAR2,
	p_p_confirm_sw				IN VARCHAR2,
	p_v_commit_switch			IN VARCHAR2,
	p_v_pol_changed_sw			IN VARCHAR2,
	p_incept_date				IN VARCHAR2,
	p_v_old_incept_date			IN VARCHAR2,
	p_expiry_date				IN VARCHAR2,
	p_v_old_expiry_date			IN VARCHAR2,
	p_eff_date					IN VARCHAR2,
	p_v_old_eff_date			IN VARCHAR2,
	p_endt_expiry_date			IN VARCHAR2,
	p_v_old_endt_expiry_date	IN VARCHAR2,
	p_v_old_prov_prem_tag		IN VARCHAR2,
	p_prov_prem_tag				IN VARCHAR2,
	p_prov_prem_pct				IN NUMBER,
	p_v_old_prov_prem_pct		IN NUMBER,
	p_v_prorate_sw				IN VARCHAR2,
	p_prorate_flag				IN GIPI_WPOLBAS.prorate_flag%TYPE,
	p_v_old_prorate_flag		IN VARCHAR2,
	p_nbt_short_rt_percent		IN NUMBER,
	p_v_old_short_rt_percent	IN NUMBER,
	p_booking_year				IN VARCHAR2,
	p_booking_mth				IN VARCHAR2,
	p_p_prorate_cancel_sw		IN VARCHAR2,
	p_show_popup				OUT VARCHAR2,
	p_msg_type					OUT VARCHAR2,
	p_msg_alert					OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.16.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure combines all procedures that are called when saving the record
	**					: It only validates records/transaction before the actual saving
	*/
	v_cg$back_endt 	VARCHAR2(1);
	v_line_cd		GIPI_WPOLBAS.line_cd%TYPE;
	v_subline_cd	GIPI_WPOLBAS.subline_cd%TYPE;
	v_iss_cd		GIPI_WPOLBAS.iss_cd%TYPE;
	v_issue_yy		GIPI_WPOLBAS.issue_yy%TYPE;
	v_pol_seq_no	GIPI_WPOLBAS.pol_seq_no%TYPE;
	v_renew_no		GIPI_WPOLBAS.renew_no%TYPE;
	v_incept_date	GIPI_WPOLBAS.incept_date%TYPE;
	v_eff_date		GIPI_WPOLBAS.eff_date%TYPE;
BEGIN
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
	
	/* KEY-COMMIT */
	IF p_pol_flag = '4' OR NVL(p_nbt_pol_flag, '1') = '4' OR NVL(p_prorate_sw, '2') = '1' THEN
		v_cg$back_endt := 'N';
	END IF;
	
	IF v_cg$back_endt = 'Y' AND p_p_back_endt_sw = 'Y' THEN
		p_show_popup := 'TRUE';
		GOTO RAISE_FORM_TRIGGER_FAILURE;
	ELSE
		p_show_popup := 'FALSE';
		--p_back_stat := 1; --comment muna dahil validation. dapat wala muna syang irereturn na value para sa field
	END IF;
	
	IF p_p_ins_winvoice = 'Y' THEN
		/* CREATE_WINVOICE1 no dml statements version*/
		DECLARE
			CURSOR a1 IS
				SELECT NVL(eff_date,incept_date), issue_date, place_cd, booking_mth,booking_year,takeup_term, -- added by aaron
					   endt_expiry_date, expiry_date
				  FROM GIPI_WPOLBAS
				 WHERE par_id = p_par_id;
			
			v_p_eff_date          GIPI_WPOLBAS.eff_date%TYPE;
			v_p_issue_date        GIPI_WPOLBAS.issue_date%TYPE;  
			v_p_place_cd          GIPI_WPOLBAS.place_cd%TYPE;
			v_p_booking_mth		  GIPI_WPOLBAS.booking_mth%TYPE;
			v_p_booking_yy        GIPI_WPOLBAS.booking_year%TYPE;
			v_p_takeup_term       GIPI_WPOLBAS.takeup_term%TYPE;
			v_p_endt_expiry_date  GIPI_WPOLBAS.endt_expiry_date%TYPE;
			v_p_expiry_date       GIPI_WPOLBAS.expiry_date%TYPE;
			
			v_expiry_date       GIPI_WPOLBAS.EXPIRY_DATE%TYPE;
			v_incept_date       GIPI_WPOLBAS.incept_DATE%TYPE;
			v_policy_days       NUMBER:= 0;
			v_policy_months     NUMBER:=0;
			v_no_of_takeup      NUMBER;
			v_yearly_tag        VARCHAR2(1);
			v_no_of_payment		NUMBER:= 1;
			v_days_interval     NUMBER:=0;
			v_assd_name         GIIS_ASSURED.assd_name%TYPE;
			v_pack              GIPI_WPOLBAS.pack_pol_flag%TYPE;
			v_cod               GIIS_PARAMETERS.param_value_v%TYPE;
			v_prev_currency_rt	GIPI_WINVOICE.currency_rt%TYPE;
			v_prev_currency_cd	GIPI_WINVOICE.currency_cd%TYPE;
			v_prodtakeup        NUMBER;
			v_prodtakeupdate    GIPI_WINVOICE.due_date%TYPE;
			v_due_date          GIPI_WINVOICE.due_date%TYPE;
			v_booking_date		GIPI_WPOLBAS.incept_DATE%TYPE;
			v_booking_mth		GIPI_WINVOICE.MULTI_BOOKING_MM%TYPE;
			v_booking_year		GIPI_WINVOICE.MULTI_BOOKING_YY%TYPE;
			v_err               NUMBER:=0;
		BEGIN
			OPEN a1;
			FETCH a1
			 INTO v_p_eff_date,
				  v_p_issue_date,
				  v_p_place_cd,
				  v_p_booking_mth,
				  v_p_booking_yy,
				  v_p_takeup_term,
				  v_p_endt_expiry_date,
				  v_p_expiry_date;
			CLOSE a1;
			
			IF v_p_endt_expiry_date IS NULL THEN
				v_expiry_date := v_p_expiry_date;
				v_incept_date := v_p_eff_date;
			ELSE
				v_expiry_date := v_p_endt_expiry_date;
				v_incept_date := v_p_eff_date;
			END IF;
			
			IF TRUNC(v_expiry_date - v_incept_date) = 31 THEN
				v_policy_days := 30;
			ELSE
				v_policy_days := TRUNC(v_expiry_date - v_incept_date);
			END IF;

			v_policy_months     := CEIL(MONTHS_BETWEEN(v_expiry_date,v_incept_date));
			
			FOR b1 IN (
				SELECT no_of_takeup, yearly_tag
				  FROM GIIS_TAKEUP_TERM
				 WHERE takeup_term = v_p_takeup_term)
			LOOP
				v_no_of_takeup := b1.no_of_takeup;
				v_yearly_tag   := b1.yearly_tag; 
			END LOOP;
			
			------- LONG TERM PROCESS get payment divisions--------------
			/*
			** v_yearly_tag: Y = adjust no of payment to the total policy days duration
			**               example: 2 years duration with monthly take up is divided into 24 no of payments --
			**                        8 months duration with monthly take up is divided into 8 no of payments --
			** v_yearly_tag: N = no of payment will follow the value of NO_OF_TAKEUP in giis_takeup_term table --
			**               example: 2 years duration with monthly take up is divided into 12 no of payments --
			**                        8 months duration with monthly take up is divided into 12 no of payments --
			*/
			
			IF v_yearly_tag = 'Y' THEN
				IF TRUNC((v_policy_days)/365,2) * v_no_of_takeup > TRUNC(TRUNC((v_policy_days)/365,2) * v_no_of_takeup) THEN
					v_no_of_payment := TRUNC(TRUNC((v_policy_days)/365,2) * v_no_of_takeup) + 1;
				ELSE
					v_no_of_payment := TRUNC(TRUNC((v_policy_days)/365,2) * v_no_of_takeup);
				END IF;
			ELSE
				IF v_policy_days < v_no_of_takeup THEN
					v_no_of_payment := v_policy_days;
				ELSE
					v_no_of_payment := v_no_of_takeup;
				END IF;
			END IF;
			
			IF NVL(v_no_of_payment,0) < 1 THEN
				v_no_of_payment := 1;
			END IF;
  
			v_days_interval := ROUND(v_policy_days/v_no_of_payment);
			
			FOR A1 IN (
				SELECT SUBSTR(b.assd_name,1,30) ASSD_NAME
				  FROM GIPI_PARLIST a, GIIS_ASSURED b
				 WHERE a.assd_no =  b.assd_no
				   AND a.par_id =  p_par_id
				   AND a.line_cd =  p_line_cd)
			LOOP
				v_assd_name  := A1.assd_name;
			END LOOP;
			
			IF v_assd_name IS NULL THEN
				v_assd_name := 'Null';
			END IF;
			
			FOR A IN (
				SELECT pack_pol_flag
				  FROM GIPI_WPOLBAS
				 WHERE par_id  =  p_par_id)
			LOOP
				v_pack  :=  A.pack_pol_flag;
				EXIT;
			END LOOP;
			
			FOR A IN (
				SELECT param_value_v
                  FROM GIIS_PARAMETERS
				 WHERE param_name = 'CASH ON DELIVERY')
			LOOP   
				v_cod := a.param_value_v;
				EXIT;
			END LOOP;
         	
			FOR B IN (
				SELECT main_currency_cd, currency_rt
                  FROM GIAC_PARAMETERS A, GIIS_CURRENCY B
				 WHERE param_name = 'DEFAULT_CURRENCY')
			LOOP
				v_prev_currency_cd := b.main_currency_cd;
				v_prev_currency_rt := b.currency_rt;
				EXIT;
			END LOOP;
			
			FOR j IN 1..v_no_of_payment
			LOOP    
				FOR gp IN (
					SELECT PARAM_VALUE_N,remarks
					  FROM GIAC_PARAMETERS
					 WHERE PARAM_NAME = 'PROD_TAKE_UP')
				LOOP
					v_prodtakeup := gp.param_value_n;
				END LOOP;
				
				IF v_due_date IS NULL THEN
					IF v_prodtakeup = 1 OR (v_prodtakeup = 3 AND v_p_issue_date > v_incept_date) OR (v_prodtakeup = 4 AND v_p_issue_date < v_incept_date) THEN
						v_prodtakeupdate:= v_p_issue_date;
					ELSIF v_prodtakeup = 2 OR (v_prodtakeup = 3 AND v_p_issue_date <= v_incept_date) OR (v_prodtakeup = 4 AND v_p_issue_date >= v_incept_date) THEN
                        v_prodtakeupdate:= v_incept_date;
					END IF;
					v_due_date := TRUNC(v_prodtakeupdate);              
                ELSE
					v_due_date := TRUNC(v_due_date + v_days_interval);
                END IF;
				
				IF v_booking_date IS NULL THEN
					v_booking_date := TRUNC(v_due_date);
				ELSE                  
					v_booking_date := ADD_MONTHS(v_due_date, (v_policy_months / v_no_of_payment));
				END IF;
				
				Get_Book_Dt (v_booking_year, v_booking_mth, v_yearly_tag, v_booking_date, v_due_date, v_err);
				
				IF v_err = 1 THEN
					p_msg_alert := 'Cannot generate booking date: '||TO_CHAR(v_booking_date,'MONTH YYYY')||'. Please check maintenance table.';
					p_msg_type := 'MESSAGE';
					GOTO RAISE_FORM_TRIGGER_FAILURE;
				END IF;
			END LOOP;
		END;
		/* CREATE_WINVOICE1 ends here*/
	END IF;
	
	DECLARE
		v_param_value_v   VARCHAR2(200);
		v_menu_line_cd    VARCHAR2(2);
	BEGIN		
		v_param_value_v := Giis_Parameters_Pkg.v('LINE_CODE_MN');
		
		FOR y IN (
			SELECT menu_line_cd
			  FROM GIIS_LINE
			 WHERE line_cd = p_line_cd)
		LOOP
			v_menu_line_cd := y.menu_line_cd;
		END LOOP;
		
		IF (p_line_cd = v_param_value_v) OR ('MN' = v_menu_line_cd) THEN			
			IF Giis_Parameters_Pkg.v('REQ_SURVEY_SETT_AGENT') = 'Y' THEN
				IF p_survey_agent_cd IS NULL OR p_settling_agent_cd IS NULL THEN
					p_msg_alert := 'Survey Agent and Settling Agent are required';
					p_msg_type := 'MESSAGE';
					GOTO RAISE_FORM_TRIGGER_FAILURE;
				END IF;					
			END IF;			
		END IF;		
	END;
	/* KEY-COMMIT ends here */
	
	/* PRE-COMMIT */
	
	/* VALIDATE_BEFORE_COMMIT no dml statements version*/
	DECLARE
		v_subline_cd	GIIS_SUBLINE.subline_cd%TYPE; 
		v_perils		VARCHAR2(1) := 'N';
	BEGIN
		FOR A IN (
			SELECT '1'
              FROM GIPI_WITMPERL
             WHERE par_id = p_par_id)
		LOOP
			v_perils := 'Y';
		END LOOP;
		
		IF p_p_confirm_sw = 'Y' THEN    
			p_msg_alert := 'This policy has been endorsed for a short-term period. Do you want to keep this record permanently ';     
			p_msg_type := 'CONFIRM';
			GOTO RAISE_FORM_TRIGGER_FAILURE;
		END IF;
		
		IF p_v_commit_switch = 'A' THEN
			p_msg_alert := 'Cannot endorse this policy.  This policy has not been distributed.';
			p_msg_type := 'MESSAGE';
			GOTO RAISE_FORM_TRIGGER_FAILURE;
		ELSIF p_v_commit_switch = 'B' THEN 
			p_msg_alert := 'Cannot endorse this policy.  This policy has been cancelled.';
			p_msg_type := 'MESSAGE';
			GOTO RAISE_FORM_TRIGGER_FAILURE;
		ELSIF p_v_commit_switch = 'C' THEN
			p_msg_alert := 'Cannot endorse this policy.  This policy has been tagged for spoilage.';
			p_msg_type := 'MESSAGE';
			GOTO RAISE_FORM_TRIGGER_FAILURE;
		ELSIF p_v_commit_switch = 'D' THEN
			p_msg_alert := 'Cannot endorse this policy.  This policy has been spoiled.';
			p_msg_type := 'MESSAGE';
			GOTO RAISE_FORM_TRIGGER_FAILURE;
		ELSIF p_v_commit_switch = 'Y' THEN
			p_msg_alert := 'Policy number does not exist, cannot commit changes made.';		
			p_msg_type := 'MESSAGE';
			GOTO RAISE_FORM_TRIGGER_FAILURE;
		END IF;
		
		IF NVL(p_nbt_pol_flag, '1') <> 4 AND NVL(p_prorate_sw, '2') <> 1 THEN
			DECLARE				
				old_prorate		VARCHAR2(50);
				new_prorate		VARCHAR2(50);
			BEGIN
				IF p_v_pol_changed_sw = 'Y' THEN          
					NULL;  				
				ELSE
					--*** Inception date has been altered ***-- 
					IF TO_DATE(p_incept_date, 'MM-DD-RRRR') != TRUNC(TO_DATE(p_v_old_incept_date, 'MM-DD-RRRR HH24:MI:SS')) THEN
						p_msg_alert := 'User has altered the inception date of this PAR from "' || TO_CHAR(TO_DATE(p_v_old_incept_date, 'MM-DD-RRRR HH24:MI:SS'), 'fmMonth DD, YYYY') ||
										'" to "'|| TO_CHAR(TO_DATE(p_incept_date,'MM-DD-RRRR HH24:MI:SS'), 'fmMonth DD, YYYY') || '".  All information related to this PAR will be deleted. Continue anyway ';
						p_msg_type := 'CONFIRM';
						GOTO RAISE_FORM_TRIGGER_FAILURE;
					--*** Expiry date has been altered ***-- 
					ELSIF TO_DATE(p_expiry_date, 'MM-DD-RRRR') != TRUNC(TO_DATE(p_v_old_expiry_date, 'MM-DD-RRRR HH24:MI:SS')) THEN
						p_msg_alert := 'User has altered the expiry date of this PAR from "' || TO_CHAR(TO_DATE(p_v_old_expiry_date, 'MM-DD-RRRR HH24:MI:SS'), 'fmMonth DD, YYYY') ||
									'" to "' || TO_CHAR(TO_DATE(p_expiry_date, 'MM-DD-RRRR HH24:MI:SS'), 'fmMonth DD, YYYY') || '".  All information related to this PAR will be deleted. Continue anyway ';
						p_msg_type := 'CONFIRM';
						GOTO RAISE_FORM_TRIGGER_FAILURE;
					--*** Effectivity date has been altered ***-- 
					ELSIF TO_DATE(p_eff_date, 'MM-DD-RRRR') != TRUNC(TO_DATE(p_v_old_eff_date, 'MM-DD-RRRR HH24:MI:SS')) AND p_pol_flag != '4' THEN
						p_msg_alert := 'User has altered the effectivity date of this PAR from "' || TO_CHAR(TO_DATE(p_v_old_eff_date, 'MM-DD-RRRR HH24:MI:SS'), 'fmMonth DD, YYYY') ||
									'" to "' || TO_CHAR(TO_DATE(p_eff_date, 'MM-DD-RRRR HH24:MI:SS'), 'fmMonth DD, YYYY') || '".  All information related to this PAR will be deleted. Continue anyway ';
						p_msg_type := 'CONFIRM';
						GOTO RAISE_FORM_TRIGGER_FAILURE;
					--*** Endorsement expiry date has been altered ***-- 
					ELSIF TO_DATE(p_endt_expiry_date, 'MM-DD-RRRR') != TRUNC(TO_DATE(p_v_old_endt_expiry_date, 'MM-DD-RRRR HH24:MI:SS')) THEN
						p_msg_alert := 'User has altered the endorsement expiry date of this PAR from "' || TO_CHAR(TO_DATE(p_v_old_endt_expiry_date, 'MM-DD-RRRR HH24:MI:SS'), 'fmMonth DD, YYYY') ||
									'" to "' || TO_CHAR(TO_DATE(p_endt_expiry_date, 'MM-DD-RRRR HH24:MI:SS'), 'fmMonth DD, YYYY') || '".  All information related to this PAR will be deleted. Continue anyway ';
						p_msg_type := 'CONFIRM';
						GOTO RAISE_FORM_TRIGGER_FAILURE;
					--*** Provisional premium tag has been altered ***-- 
					ELSIF p_v_old_prov_prem_tag != p_prov_prem_tag AND v_perils = 'Y' THEN
						p_msg_alert := 'User has updated the provisional premium tag.  All information related to this PAR will be deleted. Continue anyway ';
						p_msg_type := 'CONFIRM';
						GOTO RAISE_FORM_TRIGGER_FAILURE;
					--*** Provisional premium percentage has been altered ***-- 
					ELSIF p_prov_prem_pct != p_v_old_prov_prem_pct AND v_perils = 'Y' THEN
						p_msg_alert := 'User has updated the provisional premium percentage from " ' || TO_CHAR(p_v_old_prov_prem_pct) ||
									' " to " ' || TO_CHAR(p_prov_prem_pct)|| ' ".  All information related to this PAR will be deleted. Continue anyway ';
						p_msg_type := 'CONFIRM';
						GOTO RAISE_FORM_TRIGGER_FAILURE;
					--*** Prorate flag has been altered ***-- 
					ELSIF  p_v_prorate_sw = 'Y' AND v_perils = 'Y' THEN
						IF p_prorate_flag = '1' THEN
							new_prorate := 'Prorate';
						ELSIF p_prorate_flag = '2' THEN
							new_prorate := 'One-year';
						ELSIF p_prorate_flag = '3' THEN
							new_prorate := 'Short Rate';
						END IF;
						
						IF p_v_old_prorate_flag = '1' THEN
							old_prorate := 'Prorate';
						ELSIF p_v_old_prorate_flag = '2' THEN
							old_prorate := 'One-year';
						ELSIF p_v_old_prorate_flag = '3' THEN
							old_prorate := 'Short Rate';
						END IF;

						p_msg_alert := 'User has updated the prorate flag from "' || old_prorate ||
									'" to "' || new_prorate || '".  All information related to this PAR will be deleted. Continue anyway ';
						p_msg_type := 'CONFIRM';
						GOTO RAISE_FORM_TRIGGER_FAILURE;
					--*** Short rate percentile has been altered ***-- 
					ELSIF p_nbt_short_rt_percent != p_v_old_short_rt_percent AND v_perils = 'Y' THEN
						p_msg_alert := 'User has updated the short rate percentage from " '|| TO_CHAR(p_v_old_short_rt_percent) ||
									' " to " ' || TO_CHAR(p_nbt_short_rt_percent) || ' ".  All information related to this PAR will be deleted. Continue anyway ';
						p_msg_type := 'CONFIRM';
						GOTO RAISE_FORM_TRIGGER_FAILURE;					
					END IF;					
				END IF;
			END;
		END IF;	
	END;
	/* VALIDATE_BEFORE_COMMIT ends here*/
	
	DECLARE
	  v_par_stat NUMBER(2); 
	BEGIN
		BEGIN 
			SELECT par_status 
			  INTO v_par_stat
			  FROM GIPI_PARLIST 
			 WHERE par_id = p_par_id;
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				NULL;
		END;	 
		IF v_par_stat = 10 THEN 
			p_msg_alert := 'Cannot save changes, par_id has been posted to a different endorsement';
			p_msg_type := 'MESSAGE';
			GOTO RAISE_FORM_TRIGGER_FAILURE;
		END IF;
	END;
	
	IF p_booking_year IS NULL OR p_booking_mth IS NULL THEN
		p_msg_alert := 'There is no value for booking date. Please enter the date.';
		p_msg_type := 'MESSAGE';
		GOTO RAISE_FORM_TRIGGER_FAILURE;
	END IF;	
  
	IF ((p_eff_date IS NULL) OR (p_endt_expiry_date IS NULL)) THEN
		p_msg_alert := 'Cannot proceed, endorsement effectivity date / endorsement expiry_date must not be null.';
		p_msg_type := 'MESSAGE';
		GOTO RAISE_FORM_TRIGGER_FAILURE;
	END IF;
	
	IF p_prorate_sw = 1 AND p_p_prorate_cancel_sw = 'Y' THEN  	 
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
							p_msg_type := 'MESSAGE';
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
								p_msg_type := 'MESSAGE';
								GOTO RAISE_FORM_TRIGGER_FAILURE;
							END IF;
						END IF;
					END LOOP;
				END LOOP;
			END IF;
		END;		                                                          
	END IF;	
	/* PRE-COMMIT ends here*/
	
	<<RAISE_FORM_TRIGGER_FAILURE>>
	NULL;
END GIPIS031_VALIDATE_BEFORE_SAVE;
/


