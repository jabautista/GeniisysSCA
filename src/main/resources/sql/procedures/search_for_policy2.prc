DROP PROCEDURE CPI.SEARCH_FOR_POLICY2;

CREATE OR REPLACE PROCEDURE CPI.Search_For_Policy2 (
	p_par_id		IN GIPI_WPOLBAS.par_id%TYPE,
	p_line_cd		IN GIPI_POLBASIC.line_cd%TYPE,
	p_subline_cd	IN GIPI_POLBASIC.subline_cd%TYPE,
	p_iss_cd		IN GIPI_POLBASIC.iss_cd%TYPE,
	p_issue_yy		IN GIPI_POLBASIC.issue_yy%TYPE,
	p_pol_seq_no	IN GIPI_POLBASIC.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_POLBASIC.renew_no%TYPE,	
	p_eff_date		IN GIPI_WPOLBAS.eff_date%TYPE,
	p_expiry_date 	IN GIPI_WPOLBAS.expiry_date%TYPE,
	pv_expiry_date	OUT GIPI_WPOLBAS.expiry_date%TYPE,	
	p_ann_tsi_amt	OUT	GIPI_WPOLBAS.ann_tsi_amt%TYPE,
	p_ann_prem_amt	OUT GIPI_WPOLBAS.ann_prem_amt%TYPE,
	p_msg_alert		OUT VARCHAR2,
	p_success		OUT BOOLEAN)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 05.27.2010
	**  Reference By 	: (GIPIS031 - Endt. Basic Information)
	**  Description 	: This procedure returns the eff_date, expiry_date, ann_tsi_amt, ann_prem_amt
	**					: Moved from Oracle Forms Program_Unit of GIPIS031
	*/
	v_tmp_incept_date			GIPI_WPOLBAS.incept_date%TYPE; 
	v_tmp_expiry_date			GIPI_WPOLBAS.expiry_date%TYPE; 
	v_tmp_eff_date				GIPI_WPOLBAS.eff_date%TYPE; 
	v_tmp_endt_expiry_date		GIPI_WPOLBAS.endt_expiry_date%TYPE; 
	v_tmp_mortg_name			GIPI_WPOLBAS.mortg_name%TYPE; 
	v_tmp_prov_prem_tag			GIPI_WPOLBAS.prov_prem_tag%TYPE; 
	v_tmp_prov_prem_pct			GIPI_WPOLBAS.prov_prem_pct%TYPE; 
	v_tmp_govt_acc_sw			GIPI_WPOLBAS.foreign_acc_sw%TYPE; 
	v_tmp_comp_sw				GIPI_WPOLBAS.comp_sw%TYPE; 
	v_tmp_prem_warr_tag			GIPI_WPOLBAS.prem_warr_tag%TYPE; 
	v_tmp_prorate_flag			GIPI_WPOLBAS.prorate_flag%TYPE; 
	v_tmp_short_rt_percent		GIPI_WPOLBAS.short_rt_percent%TYPE; 
	v_tmp_add1					GIPI_WPOLBAS.address1%TYPE; 
	v_tmp_add2					GIPI_WPOLBAS.address1%TYPE; 
	v_tmp_add3					GIPI_WPOLBAS.address1%TYPE; 
	v_tmp_assd_no				GIPI_WPOLBAS.assd_no%TYPE; 
	v_tmp_type_cd				GIPI_WPOLBAS.type_cd%TYPE; 
	v_tmp_ann_tsi_amt			GIPI_WPOLBAS.ann_tsi_amt%TYPE; 
	v_tmp_ann_prem_amt			GIPI_WPOLBAS.ann_prem_amt%TYPE; 
	v_fi_line_cd				GIPI_WPOLBAS.subline_cd%TYPE;  --* To store parameter value of line FIRE *--
	v_tmp_incept_tag			GIPI_WPOLBAS.incept_tag%TYPE;       
	v_tmp_expiry_tag			GIPI_WPOLBAS.expiry_tag%TYPE;
	v_tmp_endt_expiry_tag		GIPI_WPOLBAS.endt_expiry_tag%TYPE;              
    
	v_tmp_reg_policy_sw			GIPI_WPOLBAS.reg_policy_sw%TYPE;
	v_tmp_co_insurance_sw		GIPI_WPOLBAS.co_insurance_sw%TYPE;
	v_tmp_manual_renew_no		GIPI_WPOLBAS.manual_renew_no%TYPE;
	v_tmp_cred_branch			GIPI_WPOLBAS.cred_branch%TYPE;
	v_tmp_ref_pol_no			GIPI_WPOLBAS.ref_pol_no%TYPE;

	v_max_eff_date1				GIPI_WPOLBAS.eff_date%TYPE;
	v_max_eff_date2				GIPI_WPOLBAS.eff_date%TYPE;
	v_max_eff_date				GIPI_WPOLBAS.eff_date%TYPE;
	v_eff_date					GIPI_WPOLBAS.eff_date%TYPE;
	v_policy_id					GIPI_POLBASIC.policy_id%TYPE;
	v_max_endt_seq_no			GIPI_WPOLBAS.endt_seq_no%TYPE;
	v_max_endt_seq_no1			GIPI_WPOLBAS.endt_seq_no%TYPE;
	v_prorate					GIPI_ITMPERIL.prem_rt%TYPE := 0;   
	v_amt_sw					VARCHAR2(1);   -- switch that will determine if amount is already 
	v_comp_prem					GIPI_POLBASIC.prem_amt%TYPE  := 0;   -- variable that will store computed prem 
	v_expired_sw				VARCHAR2(1);   -- switch that is used to determine if policy have short term endt.
	-- fields that will be use in storing computed amounts when computing for the amount
	-- of records with short term endorsement	
	v_ann_tsi2					GIPI_POLBASIC.ann_tsi_amt%TYPE :=0; 
	v_ann_prem2					GIPI_POLBASIC.ann_prem_amt%TYPE:=0;
	  
	CURSOR B(p_line_cd  GIPI_WPOLBAS.line_cd%TYPE,
		   p_type_cd  GIPI_WPOLBAS.type_cd%TYPE) 
	IS 
		SELECT  type_desc
		  FROM  GIIS_POLICY_TYPE
		 WHERE  line_cd  = p_line_cd
		   AND  type_cd  = p_type_cd;
	
	v_end_of_transaction	BOOLEAN := FALSE;
BEGIN
	p_success := FALSE;
	pv_expiry_date := Extract_Expiry2(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
	
	-- get_acct_of_cd here
	
	--get policy id and effectivity of policy
	Gipi_Polbasic_Pkg.get_eff_date_policy_id(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_eff_date, v_policy_id);	
	
	--get the maximum endt_seq_no
	v_max_endt_seq_no := Gipi_Polbasic_Pkg.get_max_endt_seq_no(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 'SEARCH_FOR_POLICY2');
	
	IF v_max_endt_seq_no > 0 THEN
		--get maximum endt_seq_no for backward endt.
		v_max_endt_seq_no1 := Gipi_Polbasic_Pkg.get_max_endt_seq_no_back_stat(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 'SEARCH_FOR_POLICY2');
		
		IF v_max_endt_seq_no != NVL(v_max_endt_seq_no1,-1) THEN             
			--get max. eff_date for backward endt with updates			
			v_max_eff_date1 := Gipi_Polbasic_Pkg.get_max_eff_date_back_stat(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, v_max_endt_seq_no1, 'SEARCH_FOR_POLICY2');
			
			--get max eff_date for endt			
			v_max_eff_date2 := Gipi_Polbasic_Pkg.get_endt_max_eff_date(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 'SEARCH_FOR_POLICY2');               
			v_max_eff_date := NVL(v_max_eff_date2,v_max_eff_date1);
		ELSE
			--address should be from the latest backward endt. with updates
			v_max_eff_date1 := Gipi_Polbasic_Pkg.get_max_eff_date_back_stat(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, v_max_endt_seq_no1, 'SEARCH_FOR_POLICY2');      
			v_max_eff_date := v_max_eff_date1;              
		END IF;
	ELSE
		v_max_eff_date := v_eff_date;            	
	END IF;
	
	v_expired_sw := 'N';
	
	FOR SW IN(
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
		   AND B.pol_flag IN ('1','2','3','X')
		   AND (NVL(A.prem_amt,0) <> 0 OR  NVL(A.tsi_amt,0) <> 0) 
		   AND TRUNC(b.eff_date) <= TRUNC(p_eff_date)
		   AND TRUNC(NVL(b.endt_expiry_date, b.expiry_date)) < TRUNC(p_eff_date)
		 ORDER BY B.eff_date DESC)
	LOOP
		v_expired_sw := 'Y';
		EXIT;
	END LOOP;
	
	IF v_expired_sw = 'N' THEN
		--get the amount from the latest endt
		v_amt_sw := 'N';		
		Gipi_Polbasic_Pkg.get_amt_from_latest_endt(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 'SEARCH_FOR_POLICY2', p_ann_tsi_amt, p_ann_prem_amt, v_amt_sw);
		
		--for policy without endt., get amounts from policy
		IF v_amt_sw = 'N' THEN			
			Gipi_Polbasic_Pkg.get_amt_from_pol_wout_endt(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_ann_tsi_amt, p_ann_prem_amt);
		END IF;
	ELSE
		--for policy with short term endt. amounts should be recomputed by adding up 
		--all policy and endt. 
		FOR A2 IN(
			SELECT (C.tsi_amt * A.currency_rt) tsi,
				   (C.prem_amt * a.currency_rt) prem,       
				   B.eff_date,          B.endt_expiry_date,    B.expiry_date,
				   B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
				   B.short_rt_percent   short_rt,
				   C.peril_cd, b.incept_date
			  FROM GIPI_ITEM A,
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
			   AND B.pol_flag     IN ('1','2','3','X') 
			   AND TRUNC(b.eff_date) <=  DECODE(NVL(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date))		  
			   AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
							pv_expiry_date, expiry_date,b.endt_expiry_date)) >= TRUNC(p_eff_date)
		  ORDER BY B.eff_date DESC) 
		LOOP
			v_comp_prem := 0;
			IF A2.prorate_flag = 1 THEN
				IF A2.endt_expiry_date <= A2.eff_date THEN
					/* error */
					p_msg_alert := 'Your endorsement expiry date is equal to or less than your effectivity date.' || ' Restricted condition.';
					GOTO RAISE_FORM_TRIGGER_FAILURE;
				ELSE
					/*Removed add_months operation on computaton of v_prorate.  Replaced
					**it instead of variables.v_days (see check_duration) for short term endt.
					*/
					IF A2.comp_sw = 'Y' THEN
						v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) + 1 )/
								   Check_Duration(A2.incept_date, A2.expiry_date);
					ELSIF A2.comp_sw = 'M' THEN
						v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) - 1 )/
								   Check_Duration(A2.incept_date, A2.expiry_date);
					ELSE 
						v_prorate  := (TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date ))/
								  Check_Duration(A2.incept_date, A2.expiry_date);
					END IF;
				END IF;
				v_comp_prem  := A2.prem/v_prorate;
			ELSIF A2.prorate_flag = 2 THEN
				v_comp_prem  :=  A2.prem;
			ELSE
				v_comp_prem :=  A2.prem/(A2.short_rt/100);  
			END IF;
			v_ann_prem2 := v_ann_prem2 + v_comp_prem;
			
			FOR TYPE IN(
				SELECT peril_type
				  FROM GIIS_PERIL
				 WHERE line_cd  = p_line_cd
				   AND peril_cd = A2.peril_cd)
			LOOP
				IF TYPE.peril_type = 'B' THEN
					v_ann_tsi2  := v_ann_tsi2  + A2.tsi;
				END IF;
			END LOOP;        
		END LOOP;
		p_ann_tsi_amt  := v_ann_tsi2;
		p_ann_prem_amt := v_ann_prem2;
	END IF;
	
	FOR A1 IN (
		SELECT b250.incept_date,      b250.expiry_date,  
			   b250.endt_expiry_date, b250.mortg_name,    b250.prorate_flag, 
			   b250.short_rt_percent, b250.prov_prem_tag, b250.prov_prem_pct, 
			   b250.type_cd,          b250.line_cd,
			   b250.ann_tsi_amt,      b250.ann_prem_amt,
			   b250.foreign_acc_sw,   b250.prem_warr_tag,
			   b250.expiry_tag,       b250.incept_tag,
			   b250.reg_policy_sw,    b250.co_insurance_sw,
			   b250.endt_expiry_tag,  b250.manual_renew_no,
			   DECODE(b250.prorate_flag,'1',NVL(b250.comp_sw,'N')) comp_sw,
			   b250.cred_branch,      b250.ref_pol_no
		  FROM GIPI_POLBASIC b250
		 WHERE b250.line_cd    = p_line_cd
		   AND b250.subline_cd = p_subline_cd
		   AND b250.iss_cd     = p_iss_cd
		   AND b250.issue_yy   = p_issue_yy
		   AND b250.pol_seq_no = p_pol_seq_no
		   AND b250.renew_no   = p_renew_no
		   AND b250.pol_flag   IN ('1','2','3','X') 
		   AND b250.eff_date   = v_max_eff_date
      ORDER BY b250.endt_seq_no  DESC )
	LOOP		
		Search_For_Assured2(v_tmp_assd_no, p_eff_date, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);		
		Search_For_Address2(v_tmp_add1, v_tmp_add2, v_tmp_add3, p_eff_date, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
		
		v_tmp_incept_date       := a1.incept_date; 
		v_tmp_expiry_date	    := a1.expiry_date; 
		v_tmp_endt_expiry_date  := a1.endt_expiry_date; 
		
		v_tmp_mortg_name	    := a1.mortg_name; 
		v_tmp_prov_prem_tag     := a1.prov_prem_tag; 
		v_tmp_prov_prem_pct     := a1.prov_prem_pct; 
		v_tmp_prorate_flag      := a1.prorate_flag; 
		v_tmp_short_rt_percent  := a1.short_rt_percent; 
		v_tmp_type_cd           := a1.type_cd; 
		v_tmp_ann_tsi_amt       := a1.ann_tsi_amt; 
		v_tmp_ann_prem_amt      := a1.ann_prem_amt; 
		
		v_tmp_govt_acc_sw       := a1.foreign_acc_sw;
		v_tmp_comp_sw           := a1.comp_sw;
		v_tmp_prem_warr_tag     := a1.prem_warr_tag;
		
		v_tmp_expiry_tag        := a1.expiry_tag;
		v_tmp_endt_expiry_tag   := a1.endt_expiry_tag;
		v_tmp_incept_tag        := a1.incept_tag;
		v_tmp_reg_policy_sw     := a1.reg_policy_sw;
		v_tmp_co_insurance_sw   := a1.co_insurance_sw;
		v_tmp_manual_renew_no   := a1.manual_renew_no;
		v_tmp_cred_branch       := a1.cred_branch;
		v_tmp_ref_pol_no        := a1.ref_pol_no;
		/*
		FOR B1 IN B(a1.line_cd, a1.type_cd) 
		LOOP
		  :b540.dsp_type_cd := b1.type_desc;
		  EXIT;
		END LOOP;
		EXIT;
		*/
	END LOOP;
	
	v_end_of_transaction := TRUE;
	
	<<RAISE_FORM_TRIGGER_FAILURE>>
	IF v_end_of_transaction THEN
		p_success := TRUE;
	END IF;
END Search_For_Policy2;
/


