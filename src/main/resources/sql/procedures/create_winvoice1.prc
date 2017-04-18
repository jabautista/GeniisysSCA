DROP PROCEDURE CPI.CREATE_WINVOICE1;

CREATE OR REPLACE PROCEDURE CPI.CREATE_WINVOICE1 (
	p_par_id 	IN GIPI_PARLIST.par_id%TYPE,
	p_line_cd 	IN GIPI_PARLIST.line_cd%TYPE,
	p_iss_cd 	IN GIPI_PARLIST.iss_cd%TYPE,
	p_msg_alert	OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.15.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: Used by item-peril module to create an initial value for invoice module.
	**					: Taxes selection from maintenace tables are also performed. (Original Description)
	*/
	CURSOR a1 IS
		SELECT NVL(eff_date,incept_date), issue_date, place_cd, booking_mth,booking_year,takeup_term, -- added by aaron
			   endt_expiry_date, expiry_date
		  FROM GIPI_WPOLBAS
		 WHERE par_id  =  p_par_id;

	v_comm_amt_per_group	GIPI_WINVOICE.ri_comm_amt%TYPE;
	v_prem_amt_per_peril	GIPI_WINVOICE.prem_amt%TYPE;
	v_prem_amt_per_group	GIPI_WINVOICE.prem_amt%TYPE;
	v_tax_amt_per_peril		GIPI_WINVOICE.tax_amt%TYPE;
	v_tax_amt_per_group1	GIPI_WINVOICE.tax_amt%TYPE;
	v_tax_amt_per_group2	GIPI_WINVOICE.tax_amt%TYPE;
	v_tax_amt				REAL;
	v_prev_item_grp			GIPI_WINVOICE.item_grp%TYPE;
	v_prev_currency_cd		GIPI_WINVOICE.currency_cd%TYPE;
	v_prev_currency_rt		GIPI_WINVOICE.currency_rt%TYPE;
	v_assd_name				GIIS_ASSURED.assd_name%TYPE;
	v_dummy					VARCHAR2(1);
	v_issue_date			GIPI_WPOLBAS.issue_date%TYPE;
	v_eff_date				GIPI_WPOLBAS.eff_date%TYPE;
	v_place_cd				GIPI_WPOLBAS.place_cd%TYPE;
	v_pack					GIPI_WPOLBAS.pack_pol_flag%TYPE;
	v_cod					GIIS_PARAMETERS.param_value_v%TYPE;

	v_booking_mth			GIPI_WPOLBAS.booking_mth%TYPE;
	v_booking_yy			GIPI_WPOLBAS.booking_year%TYPE;
	v_takeup_term			GIPI_WPOLBAS.takeup_term%TYPE;
	
	v_no_of_takeup		NUMBER;
	v_yearly_tag		VARCHAR2(1);
	v_no_of_payment		NUMBER:= 1;
	v_policy_days		NUMBER:= 0;
	v_endt_expiry_date	GIPI_WPOLBAS.endt_expiry_date%TYPE;
	v_expiry_date		GIPI_WPOLBAS.expiry_date%TYPE;
	v_expiry_date2		GIPI_WPOLBAS.EXPIRY_DATE%TYPE;
	v_incept_date		GIPI_WPOLBAS.incept_DATE%TYPE;
	v_booking_date		GIPI_WPOLBAS.incept_DATE%TYPE;
	v_policy_months		NUMBER:=0;
	v_prodtakeup		NUMBER;
	v_due_date			GIPI_WINVOICE.due_date%TYPE;
	v_prodtakeupdate	GIPI_WINVOICE.due_date%TYPE;
	v_days_interval		NUMBER:=0;
	v_booking_month		GIPI_WINVOICE.MULTI_BOOKING_MM%TYPE;
	v_booking_year		GIPI_WINVOICE.MULTI_BOOKING_YY%TYPE;
	v_err				NUMBER:=0;
BEGIN
	OPEN a1;
	FETCH a1
	 INTO v_eff_date,
          v_issue_date,
          v_place_cd,
          v_booking_mth,
          v_booking_yy,
          v_takeup_term,
          v_endt_expiry_date,
          v_expiry_date2;
	CLOSE a1;
	
	IF v_endt_expiry_date IS NULL THEN
		v_expiry_date := v_expiry_date2;
		v_incept_date := v_eff_date;
	ELSE
		v_expiry_date := v_endt_expiry_date;
		v_incept_date := v_eff_date;
	END IF;
	
	IF TRUNC(v_expiry_date - v_incept_date) = 31 THEN
		v_policy_days := 30;
	ELSE
		v_policy_days := TRUNC(v_expiry_date - v_incept_date);
	END IF;
	
	v_policy_months := CEIL(MONTHS_BETWEEN(v_expiry_date,v_incept_date));
	
	FOR b1 IN (
		SELECT no_of_takeup, yearly_tag
		  FROM GIIS_TAKEUP_TERM
		 WHERE takeup_term = v_takeup_term)
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
			v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * v_no_of_takeup) + 1;
		ELSE
			v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * v_no_of_takeup);
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
	
	Gipi_Winstallment_Pkg.del_gipi_winstallment_1(p_par_id);
	Gipi_Wcomm_Inv_Perils_Pkg.del_gipi_wcomm_inv_perils1(p_par_id);
	Gipi_Wcomm_Invoices_Pkg.del_gipi_wcomm_invoices_1(p_par_id);
	Gipi_Winvperl_Pkg.del_gipi_winvperl_1(p_par_id);
	Gipi_Wpackage_Inv_Tax_Pkg.del_gipi_wpackage_inv_tax(p_par_id);
	Gipi_Winv_Tax_Pkg.del_gipi_winv_tax_1(p_par_id);
	Gipi_Winvoice_Pkg.DEL_GIPI_WINVOICE1(p_par_id);
	
	BEGIN
		FOR A1 IN (
		  SELECT SUBSTR(b.assd_name,1,30) ASSD_NAME
			FROM GIPI_PARLIST a, GIIS_ASSURED b
		   WHERE a.assd_no = b.assd_no
			 AND a.par_id = p_par_id
			 AND a.line_cd = p_line_cd)
		LOOP
			v_assd_name  := A1.assd_name;
		END LOOP;
		IF v_assd_name IS NULL THEN
		   v_assd_name := 'Null';
		END IF;
	END;
	
	FOR A IN (
		SELECT pack_pol_flag
		  FROM GIPI_WPOLBAS
		 WHERE par_id  =  p_par_id)
	LOOP
		v_pack  :=  A.pack_pol_flag;
		EXIT;
	END LOOP;
	
	BEGIN
		FOR A IN (
			SELECT param_value_v
			  FROM GIIS_PARAMETERS
			 WHERE param_name = 'CASH ON DELIVERY')
		LOOP   
		   v_cod := a.param_value_v;
		   EXIT;
		END LOOP;
		
		FOR B IN (
			/*SELECT main_currency_cd, currency_rt
			  FROM GIAC_PARAMETERS A, GIIS_CURRENCY B
			 WHERE param_name = 'DEFAULT_CURRENCY'*/ -- replaced by: Nica 09.04.2012 - to select the correct cuurency cd
			 SELECT main_currency_cd, currency_rt
			  FROM GIIS_CURRENCY
			 WHERE main_currency_cd = GIACP.n('CURRENCY_CD'))
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
				IF v_prodtakeup = 1 OR
					(v_prodtakeup = 3 AND v_issue_date > v_incept_date) OR
					(v_prodtakeup = 4 AND v_issue_date < v_incept_date) THEN
					v_prodtakeupdate:= v_issue_date;
				ELSIF v_prodtakeup = 2 OR
					(v_prodtakeup = 3 AND v_issue_date <= v_incept_date) OR
					(v_prodtakeup = 4 AND v_issue_date >= v_incept_date) THEN
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
			
			Get_Book_Dt (v_booking_year, v_booking_month, v_yearly_tag, v_booking_date, v_due_date, v_err);
			
			IF v_err = 1 THEN
				p_msg_alert :='CANNOT GENERATE BOOKING DATE: '||TO_CHAR(v_booking_date,'MONTH YYYY')||'. PLEASE CHECK MAINTENANCE TABLE';
				ROLLBACK;
				GOTO RAISE_FORM_TRIGGER_FAILURE;
			END IF;
			
			INSERT INTO  GIPI_WINVOICE (
				par_id,			item_grp,		payt_terms,			prem_seq_no,
				prem_amt,		tax_amt,		property,			insured,
				due_date,		notarial_fee,	ri_comm_amt,		currency_cd,
				currency_rt,	takeup_seq_no,	multi_booking_mm,	multi_booking_yy,
				no_of_takeup) -- no_of_takeup added by: Nica 09.04.2012
			VALUES (
				p_par_id,			1,	v_cod,				NULL,
				0,					0,	NULL,				v_assd_name,
				v_due_date,			0,	0,					v_prev_currency_cd,
				v_prev_currency_rt,	j,	v_booking_month,	v_booking_year,
				v_no_of_takeup);
     
		END LOOP;
		COMMIT;
	END;
	
	<<RAISE_FORM_TRIGGER_FAILURE>>
	NULL;
END CREATE_WINVOICE1;
/


