DROP PROCEDURE CPI.SEARCH_FOR_POLICY3;

CREATE OR REPLACE PROCEDURE CPI.Search_For_Policy3 (
	p_par_id			IN GIPI_WPOLBAS.par_id%TYPE,
	p_line_cd			IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd		IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd			IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy			IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no		IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no			IN GIPI_WPOLBAS.renew_no%TYPE,
	p_v_expiry_date		OUT DATE,
	p_g_cg$back_endt	OUT VARCHAR2,
	p_p_first_endt_sw	OUT VARCHAR2,
	p_c_prompt_prov		OUT VARCHAR2,
	p_p_v_endt			OUT VARCHAR2,
	p_p_confirm_sw		OUT VARCHAR2,
	p_v_exp_chg_sw		OUT VARCHAR2,
	p_v_v_old_date_eff	OUT DATE,
	p_p_sysdate_sw		OUT VARCHAR2,	
	p_gipi_parlist		OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_parlist_type,
	p_gipi_wpolbas		OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_wpolbas_type,
	p_gipi_wendttext	OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_wendttext_type,
	p_gipi_wpolgenin	OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_wpolgenin_type,
	p_msg_alert			OUT VARCHAR2,
    p_eff_date          IN  VARCHAR2,
    p_acct_of_cd        IN  VARCHAR2,
    p_drv_acct_of_cd    OUT VARCHAR2,
    p_label_tag         OUT VARCHAR2,
    p_nbt_short_rt_percent  OUT VARCHAR2,
    p_drv_assd_name         OUT VARCHAR2,
	p_dsp_bond_seq_no	IN OUT gipi_polbasic.bond_seq_no%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.25.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: Retrieve information based on the new specified policy number
	**					: Fires only when the entered policy number is changed
	**					: (Original Description)
	*/
	v_tmp_incept_date		GIPI_WPOLBAS.incept_date%TYPE; 
	v_tmp_expiry_date		GIPI_WPOLBAS.expiry_date%TYPE; 
	v_tmp_eff_date			GIPI_WPOLBAS.eff_date%TYPE; 
	v_tmp_endt_expiry_date	GIPI_WPOLBAS.endt_expiry_date%TYPE; 
	v_tmp_mortg_name		GIPI_WPOLBAS.mortg_name%TYPE; 
	v_tmp_prov_prem_tag		GIPI_WPOLBAS.prov_prem_tag%TYPE; 
	v_tmp_prov_prem_pct		GIPI_WPOLBAS.prov_prem_pct%TYPE; 
	v_tmp_govt_acc_sw		GIPI_WPOLBAS.foreign_acc_sw%TYPE; 
	v_tmp_comp_sw			GIPI_WPOLBAS.comp_sw%TYPE; 
	v_tmp_prem_warr_tag		GIPI_WPOLBAS.prem_warr_tag%TYPE; 
	v_tmp_prorate_flag		GIPI_WPOLBAS.prorate_flag%TYPE; 
	v_tmp_short_rt_percent	GIPI_WPOLBAS.short_rt_percent%TYPE; 
	v_tmp_add1				GIPI_WPOLBAS.address1%TYPE; 
	v_tmp_add2				GIPI_WPOLBAS.address1%TYPE; 
	v_tmp_add3				GIPI_WPOLBAS.address1%TYPE; 
	v_tmp_assd_no			GIPI_WPOLBAS.assd_no%TYPE; 
	v_tmp_type_cd			GIPI_WPOLBAS.type_cd%TYPE; 
	v_tmp_ann_tsi_amt		GIPI_WPOLBAS.ann_tsi_amt%TYPE; 
	v_tmp_ann_prem_amt		GIPI_WPOLBAS.ann_prem_amt%TYPE; 
	v_fi_line_cd			GIPI_WPOLBAS.subline_cd%TYPE;  --* To store parameter value of line FIRE *--

	v_tmp_incept_tag		GIPI_WPOLBAS.incept_tag%TYPE;       
	v_tmp_expiry_tag		GIPI_WPOLBAS.expiry_tag%TYPE;       

	v_tmp_reg_policy_sw		GIPI_WPOLBAS.reg_policy_sw%TYPE;
	v_tmp_co_insurance_sw	GIPI_WPOLBAS.co_insurance_sw%TYPE;
	v_tmp_endt_expiry_tag	GIPI_WPOLBAS.endt_expiry_tag%TYPE;
	v_tmp_manual_renew_no	GIPI_WPOLBAS.manual_renew_no%TYPE;
	v_tmp_cred_branch		GIPI_WPOLBAS.cred_branch%TYPE;
	v_tmp_ref_pol_no		GIPI_WPOLBAS.ref_pol_no%TYPE;
	v_max_eff_date1			GIPI_WPOLBAS.eff_date%TYPE;
	v_max_eff_date2			GIPI_WPOLBAS.eff_date%TYPE;
	v_max_eff_date			GIPI_WPOLBAS.eff_date%TYPE;
	v_eff_date				GIPI_WPOLBAS.eff_date%TYPE;
	v_pol_id				GIPI_POLBASIC.policy_id%TYPE;
	v_max_endt_seq_no		GIPI_WPOLBAS.endt_seq_no%TYPE;
	v_max_endt_seq_no1		GIPI_WPOLBAS.endt_seq_no%TYPE;
	v_prorate				GIPI_ITMPERIL.prem_rt%TYPE := 0;   
	v_amt_sw				VARCHAR2(1);   -- switch that will determine if amount is already 
	v_comp_prem				GIPI_POLBASIC.prem_amt%TYPE  := 0;   -- variable that will store computed prem 
	v_expired_sw			VARCHAR2(1);   -- switch that is used to determine if policy have short term endt.
	-- fields that will be use in storing computed amounts when computing for the amount
	-- of records with short term endorsement	
	v_ann_tsi2				GIPI_POLBASIC.ann_tsi_amt%TYPE   :=0; 
	v_ann_prem2				GIPI_POLBASIC.ann_prem_amt%TYPE  :=0;
	v_tmp_takeup_term		GIPI_WPOLBAS.takeup_term%TYPE;
    v_tmp_bank_ref_no		gipi_wpolbas.bank_ref_no%type:=null;
	v_tmp_bond_seq_no		gipi_polbasic.bond_seq_no%TYPE;
	CURSOR B(p_line_cd  GIPI_WPOLBAS.line_cd%TYPE,
		   p_type_cd  GIPI_WPOLBAS.type_cd%TYPE) IS 
		SELECT type_desc
		  FROM GIIS_POLICY_TYPE
		 WHERE line_cd = p_line_cd
		   AND type_cd = p_type_cd;	
	
	v_parlist		GIPI_PARLIST%ROWTYPE;
	v_wpolbas		GIPI_WPOLBAS%ROWTYPE;
    v_modal_flag    VARCHAR2(1) := 'Y';
BEGIN	
    v_wpolbas.acct_of_cd := p_acct_of_cd;
	p_v_expiry_date := Extract_Expiry2(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
	
    get_acct_of_cd(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, 
        p_eff_date, v_modal_flag, v_wpolbas.acct_of_cd, p_drv_acct_of_cd, p_label_tag, v_wpolbas.acct_of_cd);
    
	v_fi_line_cd := Giis_Parameters_Pkg.v('FIRE');
	
	p_g_cg$back_endt := 'N';
	
	--get policy id and effectivity of policy
	Gipi_Polbasic_Pkg.get_eff_date_policy_id(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_eff_date,v_pol_id);	
	
	--get the maximum endt_seq_no
	v_max_endt_seq_no := Gipi_Polbasic_Pkg.get_max_endt_seq_no(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, NULL, 'SEARCH_FOR_POLICY');
	
	IF v_max_endt_seq_no > 0 THEN
		--get maximum endt_seq_no for backward endt.
		v_max_endt_seq_no1 := Gipi_Polbasic_Pkg.get_max_endt_seq_no_back_stat(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, NULL, 'SEARCH_FOR_POLICY');
		
		IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN
			--get max. eff_date for backward endt with updates			
			v_max_eff_date := Gipi_Polbasic_Pkg.get_max_eff_date_back_stat(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, NULL, v_max_endt_seq_no1, 'SEARCH_FOR_POLICY');
		ELSE
			--get max. eff_date for backward endt with updates			
			v_max_eff_date1 := Gipi_Polbasic_Pkg.get_max_eff_date_back_stat(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, NULL, v_max_endt_seq_no1, 'SEARCH_FOR_POLICY');
			
			--get max eff_date for endt			
			v_max_eff_date2 := Gipi_Polbasic_Pkg.get_endt_max_eff_date(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, NULL, 'SEARCH_FOR_POLICY');
			v_max_eff_date := NVL(v_max_eff_date2,v_max_eff_date1);			
		END IF;
	ELSE
		p_p_first_endt_sw := 'Y';
		v_max_eff_date := v_eff_date;
	END IF;
	
	/* latest annualized amounts must be retrieved from the latest endt,
	** for policy without endt yet latest annualized amount will be the amounts of 
	** policy record. For cases with short-term endt. annualized amount should be recomputed
	** by adding up all policy/endt 
	*/
	--check first for the existance of short term endt. 
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
		   AND B.pol_flag     IN('1','2','3','X')
		   AND (NVL(A.prem_amt,0) <> 0 OR  NVL(A.tsi_amt,0) <> 0) 
		   AND TRUNC(B.eff_date) <=  TRUNC(SYSDATE)
		  -- AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) < TRUNC(SYSDATE)
		   AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
			   p_v_expiry_date, expiry_date,b.endt_expiry_date)) < SYSDATE
		 ORDER BY B.eff_date DESC)
	LOOP
		v_expired_sw := 'Y';
		EXIT;
	END LOOP;
	
	--for policy with no v_expired_sw
	IF v_expired_sw = 'N' THEN
		--get the amount from the latest endt
		v_amt_sw := 'N';
		Gipi_Polbasic_Pkg.get_amt_from_latest_endt(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, NULL, 'SEARCH_FOR_POLICY', v_wpolbas.ann_tsi_amt, v_wpolbas.ann_prem_amt, v_amt_sw);
		
		--for policy without endt., get amounts from policy
		IF v_amt_sw = 'N' THEN
			Gipi_Polbasic_Pkg.get_amt_from_pol_wout_endt(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_wpolbas.ann_tsi_amt, v_wpolbas.ann_prem_amt);
		END IF;
	ELSE	
		--for policy with short term endt. amounts should be recomputed by adding up 
		--all policy and endt. that is not yet expired.
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
			   AND B.pol_flag     IN('1','2','3','X') 
			   AND TRUNC(b.eff_date) <=  DECODE(NVL(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(SYSDATE))
			   --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(SYSDATE)
			   AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
					p_v_expiry_date, expiry_date,b.endt_expiry_date)) >= SYSDATE
		 ORDER BY B.eff_date DESC) 
		LOOP
			v_comp_prem := 0;
			IF A2.prorate_flag = 1 THEN
				IF A2.endt_expiry_date <= A2.eff_date THEN
					p_msg_alert := 'Your endorsement expiry date is equal to or less than your effectivity date.'||
                       ' Restricted condition.';
					GOTO RAISE_FORM_TRIGGER_FAILURE;
				ELSE
					IF A2.comp_sw = 'Y' THEN
						v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) + 1 )/
										(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
					ELSIF A2.comp_sw = 'M' THEN
						v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) - 1 )/
										(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
					ELSE 
						v_prorate  :=  (TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date ))/
										(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
					END IF;
				END IF;
				v_comp_prem  := A2.prem/v_prorate;
			ELSIF A2.prorate_flag = 2 THEN
				v_comp_prem  :=  A2.prem;
			ELSE
				IF A2.short_rt IS NULL OR A2.short_rt = 0 THEN
       	  	 		v_comp_prem := 0;
       	  		ELSE
             		v_comp_prem :=  A2.prem/(A2.short_rt/100);
          		END IF; 
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
		v_wpolbas.ann_tsi_amt := v_ann_tsi2;
		v_wpolbas.ann_prem_amt := v_ann_prem2;
	END IF;
	
	--include retrieving of govt_acc_sw ,ref_pol_no, prem_warr_sw values
	--include retrieving of incept_tag,endt_expiry_tag,expiry_tag
	FOR A1 IN (
		SELECT b250.incept_date,      b250.expiry_date,   b250.eff_date,
			   b250.endt_expiry_date, b250.mortg_name,    b250.prorate_flag, 
			   b250.short_rt_percent, b250.prov_prem_tag, b250.prov_prem_pct, 
			   b250.type_cd,          b250.line_cd,
			   b250.ann_tsi_amt,      b250.ann_prem_amt,
			   b250.foreign_acc_sw,   b250.prem_warr_tag,
			   b250.expiry_tag,       b250.incept_tag,
			   b250.reg_policy_sw,    b250.co_insurance_sw,
			   b250.endt_expiry_tag,  b250.manual_renew_no,
			   NVL(b250.comp_sw,'N') comp_sw, b250.cred_branch,
			   b250.ref_pol_no, b250.takeup_term, b250.bank_ref_no bank_ref_no,
			   b250.bond_seq_no
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
		Search_For_Assured(v_tmp_assd_no, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
		Search_For_Address(v_tmp_add1, v_tmp_add2, v_tmp_add3, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
		
		v_tmp_incept_date		:= a1.incept_date; 
		v_tmp_expiry_date		:= a1.expiry_date; 
		v_tmp_eff_date			:= a1.eff_date; 
		v_tmp_endt_expiry_date	:= a1.endt_expiry_date; 

		v_tmp_mortg_name		:= a1.mortg_name; 
		v_tmp_prov_prem_tag		:= a1.prov_prem_tag; 
		v_tmp_prov_prem_pct		:= a1.prov_prem_pct; 
		v_tmp_prorate_flag		:= a1.prorate_flag; 
		v_tmp_short_rt_percent	:= a1.short_rt_percent; 
		v_tmp_type_cd			:= a1.type_cd; 
		v_tmp_ann_tsi_amt		:= a1.ann_tsi_amt; 
		v_tmp_ann_prem_amt		:= a1.ann_prem_amt; 
		v_tmp_govt_acc_sw		:= a1.foreign_acc_sw;
		v_tmp_comp_sw			:= a1.comp_sw;
		v_tmp_prem_warr_tag		:= a1.prem_warr_tag;
		
		v_tmp_expiry_tag		:= a1.expiry_tag;
		v_tmp_incept_tag		:= a1.incept_tag;
		v_tmp_endt_expiry_tag	:= a1.endt_expiry_tag;
		v_tmp_reg_policy_sw		:= a1.reg_policy_sw;
		v_tmp_co_insurance_sw	:= a1.co_insurance_sw;
		v_tmp_manual_renew_no	:= a1.manual_renew_no;
		v_tmp_cred_branch		:= a1.cred_branch;
		v_tmp_ref_pol_no		:= a1.ref_pol_no;
		
		v_tmp_takeup_term		:= a1.takeup_term;	
		v_tmp_bank_ref_no		:= a1.bank_Ref_no;
		v_tmp_bond_seq_no		:= a1.bond_seq_no;
		EXIT;		
	END LOOP;
	
	IF v_tmp_ref_pol_no IS NULL THEN		
		v_tmp_ref_pol_no := Gipi_Polbasic_Pkg.get_ref_pol_no(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
	END IF;	
	
    FOR C1 IN (SELECT  assd_name
                 FROM  giis_assured
                WHERE  assd_no = v_tmp_assd_no) 
    LOOP
      v_wpolbas.assd_no     := v_tmp_assd_no;
      p_drv_assd_name         := c1.assd_name;
      EXIT;
    END LOOP;
    
	v_wpolbas.line_cd			:= p_line_cd;
	v_wpolbas.subline_cd		:= p_subline_cd;
	v_wpolbas.iss_cd			:= p_iss_cd;
	v_wpolbas.issue_yy			:= p_issue_yy;
	v_wpolbas.pol_seq_no		:= p_pol_seq_no;
	v_wpolbas.renew_no			:= p_renew_no;	
	v_wpolbas.endt_iss_cd		:= p_iss_cd;
	v_wpolbas.endt_yy			:= p_issue_yy;	
	v_wpolbas.incept_date      	:= NVL(v_tmp_incept_date, v_wpolbas.incept_date);
	v_wpolbas.incept_tag       	:= v_tmp_incept_tag;
	v_wpolbas.expiry_tag       	:= v_tmp_expiry_tag;
	v_wpolbas.endt_expiry_tag  	:= v_tmp_endt_expiry_tag;
	v_wpolbas.eff_date         	:= NULL;
	v_wpolbas.endt_expiry_date 	:= NVL(v_tmp_endt_expiry_date, v_tmp_expiry_date);	
	v_wpolbas.type_cd          	:= v_tmp_type_cd;
	v_wpolbas.same_polno_sw    	:= 'N';	
	v_wpolbas.foreign_acc_sw   	:= NVL(v_tmp_govt_acc_sw,'N');
	v_wpolbas.comp_sw          	:= v_tmp_comp_sw;
	v_wpolbas.prem_warr_tag    	:= v_tmp_prem_warr_tag;	
	v_wpolbas.old_assd_no      	:= v_tmp_assd_no;                    
	v_wpolbas.old_address1     	:= v_tmp_add1;
	v_wpolbas.old_address2     	:= v_tmp_add2;
	v_wpolbas.old_address3     	:= v_tmp_add3;	
	v_wpolbas.address1         	:= v_tmp_add1;
	v_wpolbas.address2         	:= v_tmp_add2;
	v_wpolbas.address3         	:= v_tmp_add3;
	v_wpolbas.reg_policy_sw    	:= NVL(v_tmp_reg_policy_sw,'Y');
	v_wpolbas.co_insurance_sw  	:= NVL(v_tmp_co_insurance_sw,'1');
	v_wpolbas.manual_renew_no  	:= v_tmp_manual_renew_no;
	v_wpolbas.cred_branch      	:= v_tmp_cred_branch;
	v_wpolbas.ref_pol_no       	:= v_tmp_ref_pol_no;
	v_wpolbas.takeup_term		:= v_tmp_takeup_term;	
	v_wpolbas.booking_mth		:= NULL;
	v_wpolbas.booking_year		:= NULL;
	
	v_parlist.assd_no          := v_tmp_assd_no;
	v_parlist.address1         := v_tmp_add1;
	v_parlist.address2         := v_tmp_add2;
	v_parlist.address3         := v_tmp_add3;	
	
	--added by bonok :: 07.11.2012
	IF p_dsp_bond_seq_no IS NULL AND NVL(giisp.v('SHOW_BOND_SEQ_NO'),'N') = 'Y' THEN
	--added condition for SU endorsements with no value in bond_seq_no by MAC 04/24/2012
   	--select bond_seq_no of the original policy.
		SELECT  b250.bond_seq_no
          INTO  p_dsp_bond_seq_no
          FROM  gipi_polbasic b250
         WHERE  b250.line_cd    = p_line_cd
           AND  b250.subline_cd = p_subline_cd
           AND  b250.iss_cd     = p_iss_cd
           AND  b250.issue_yy   = p_issue_yy
           AND  b250.pol_seq_no = p_pol_seq_no
           AND  b250.renew_no   = p_renew_no
           --AND  b250.pol_flag   IN ('1','2','3','X')
           AND  b250.endt_seq_no = 0;
	ELSIF NVL(giisp.v('SHOW_BOND_SEQ_NO'),'N') = 'N' THEN
   		p_dsp_bond_seq_no := NULL; --set :b5401.dsp_bond_seq_no if SHOW_BOND_SEQ_NO parameter is N.
   	END IF;
	
	IF v_tmp_expiry_date IS NULL THEN
		IF v_wpolbas.line_cd NOT IN ('MH', 'AV') THEN
			v_wpolbas.expiry_date := ADD_MONTHS(v_wpolbas.incept_date,12) - 1;
		ELSE
			v_wpolbas.expiry_date := ADD_MONTHS(v_wpolbas.incept_date,12);
		END IF; 
	ELSE
		v_wpolbas.expiry_date := v_tmp_expiry_date;
	END IF;
		
	IF v_wpolbas.line_cd  = v_fi_line_cd THEN   --* If line is FIRE prov_prem_tag and
		v_wpolbas.prov_prem_tag := 'N';      --* and prov_prem_pct IS NOT RETRIEVED
		v_wpolbas.prov_prem_pct := NULL;
	ELSIF v_tmp_prov_prem_tag = 'Y' THEN		
		p_c_prompt_prov  := 'Premium % :';
		v_wpolbas.prov_prem_pct := v_tmp_prov_prem_pct;		
	ELSE
		v_wpolbas.prov_prem_tag  := 'N';	
		v_wpolbas.prov_prem_pct  :=  NULL;		
	END IF;
	
	IF v_tmp_prorate_flag = '3' THEN
		v_wpolbas.prorate_flag     := '3';	
		p_nbt_short_rt_percent := v_tmp_short_rt_percent;  	
	ELSIF v_tmp_prorate_flag = '2' THEN
		v_wpolbas.prorate_flag     := '2';
		p_nbt_short_rt_percent := NULL;				
	ELSE 
		v_wpolbas.prorate_flag     := '1';	
		p_nbt_short_rt_percent := NULL;
	END IF;		  
			
	p_p_v_endt   := 'N';--switch to prevent the post-forms-commit trigger to fire
	
	IF TRUNC(v_wpolbas.endt_expiry_date)  < TRUNC(v_wpolbas.expiry_date) THEN
		p_p_confirm_sw := 'Y';
	ELSE
		p_p_confirm_sw := 'N';
	END IF;
	
	p_v_exp_chg_sw := 'N';
	
	v_wpolbas.pol_flag := '1';

	--store derived assured name
	--variables.v_ext_assd := :b240.drv_assd_no;	
	
	p_v_v_old_date_eff := NULL; 
	p_p_sysdate_sw := 'Y';
	
	IF v_wpolbas.issue_date IS NULL THEN
		v_wpolbas.issue_date := SYSDATE;
	END IF;	
	
	FOR i IN (
		SELECT pack_pol_flag
		  FROM GIPI_POLBASIC
		 WHERE line_cd = p_line_cd
		   AND subline_cd = p_subline_cd
		   AND iss_cd = p_iss_cd
		   AND issue_yy = p_issue_yy
		   AND pol_seq_no = p_pol_seq_no
		   AND renew_no = p_renew_no
		   AND dist_flag NOT IN ('5','X'))
	LOOP
		v_wpolbas.pack_pol_flag := i.pack_pol_flag;
	END LOOP;
	
	<<RAISE_FORM_TRIGGER_FAILURE>>	
	NULL;
	
	/* creates new record for GIPI_WENDTTEXT based on the following data */
	OPEN p_gipi_wendttext FOR
	SELECT NULL endt_text, 		'N' endt_tax,		NULL endt_text01, 	NULL endt_text02,
		   NULL endt_text03, 	NULL endt_text04, 	NULL endt_text05,	NULL endt_text06,
		   NULL endt_text07, 	NULL endt_text08, 	NULL endt_text09,	NULL endt_text10,
		   NULL endt_text11, 	NULL endt_text12, 	NULL endt_text13, 	NULL endt_text14,
		   NULL endt_text15,	NULL endt_text16, 	NULL endt_text17, 	NULL endt_cd
	  FROM dual;
	
	/* creates new record for GIPI_WPOLGENIN based on the following data */
	OPEN p_gipi_wpolgenin FOR
	SELECT NULL gen_info01,		NULL gen_info02,		NULL gen_info03,		NULL gen_info04,
		   NULL gen_info05,		NULL gen_info06,		NULL gen_info07,		NULL gen_info08,
		   NULL gen_info09,		NULL gen_info10,		NULL gen_info11,		NULL gen_info12,
		   NULL gen_info13,		NULL gen_info14,		NULL gen_info15,		NULL gen_info16,
		   NULL gen_info17
	  FROM dual;
	  
	/* creates new record cursor for GIPI_PARLIST based on the following data */
	OPEN p_gipi_parlist FOR
	SELECT par_id,						p_line_cd line_cd,				p_iss_cd iss_cd,
		   par_yy,						par_seq_no,						quote_seq_no,
		   par_type,					par_status,						v_parlist.assd_no assd_no,
		   v_parlist.address1 address1,	v_parlist.address2 address2,	v_parlist.address3 address3
	  FROM GIPI_PARLIST
	 WHERE par_id = p_par_id;
	
	/* creates new record cursor for GIPI_WPOLBAS based on the following data */
	OPEN p_gipi_wpolbas FOR
	SELECT v_wpolbas.line_cd line_cd,					v_wpolbas.subline_cd subline_cd,				v_wpolbas.iss_cd iss_cd,
		   v_wpolbas.issue_yy issue_yy,					v_wpolbas.pol_seq_no pol_seq_no,				v_wpolbas.renew_no renew_no,
		   v_wpolbas.endt_iss_cd endt_iss_cd,			v_wpolbas.endt_yy endt_yy,						v_wpolbas.incept_date incept_date,
		   v_wpolbas.incept_tag incept_tag,				v_wpolbas.expiry_tag expiry_tag,				v_wpolbas.endt_expiry_date endt_expiry_tag,
		   v_wpolbas.eff_date eff_date,					v_wpolbas.endt_expiry_date endt_expiry_date,	v_wpolbas.type_cd type_cd,
		   v_wpolbas.same_polno_sw same_polno_sw,		v_wpolbas.foreign_acc_sw foreign_acc_sw,		v_wpolbas.comp_sw comp_sw,
		   v_wpolbas.prem_warr_tag prem_warr_tag,		v_wpolbas.old_assd_no old_assd_no,				v_wpolbas.old_address1 old_address1,
		   v_wpolbas.old_address2 old_address2,			v_wpolbas.old_address3 old_address3,			v_wpolbas.address1 address1,
		   v_wpolbas.address2 address2,					v_wpolbas.address3 address3,					v_wpolbas.reg_policy_sw reg_policy_sw,
		   v_wpolbas.co_insurance_sw co_insurance_sw,	v_wpolbas.manual_renew_no manual_renew_no,		v_wpolbas.cred_branch cred_branch,
		   v_wpolbas.ref_pol_no ref_pol_no,				v_wpolbas.takeup_term takeup_term,				v_wpolbas.booking_mth booking_mth,
		   v_wpolbas.booking_year booking_year,			v_wpolbas.expiry_date expiry_date,				v_wpolbas.prov_prem_tag prov_prem_tag,
		   v_wpolbas.prov_prem_pct prov_prem_pct,		v_wpolbas.prorate_flag prorate_flag,			v_wpolbas.pol_flag pol_flag,
		   v_wpolbas.ann_tsi_amt ann_tsi_amt,			v_wpolbas.ann_prem_amt ann_prem_amt,			v_wpolbas.issue_date issue_date,
		   v_wpolbas.pack_pol_flag pack_pol_flag
	  FROM dual;
END Search_For_Policy3;
/


