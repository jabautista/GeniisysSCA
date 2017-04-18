DROP PROCEDURE CPI.SEARCH_FOR_POLICY_1;

CREATE OR REPLACE PROCEDURE CPI.SEARCH_FOR_POLICY_1 (
    p_par_id IN gipi_wpolbas.par_id%TYPE,
    p_line_cd IN gipi_wpolbas.line_cd%TYPE,
    p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
    p_iss_cd IN gipi_wpolbas.iss_cd%TYPE,
    p_issue_yy IN gipi_wpolbas.issue_yy%TYPE,
    p_pol_seq_no IN gipi_wpolbas.pol_seq_no%TYPE,
    p_renew_no IN gipi_wpolbas.renew_no%TYPE,
    p_v_expiry_date OUT DATE,
    p_v_expiry_date_1 OUT DATE, --added by June Mark SR-23166 [12.09.16]
    p_g_cg$back_endt OUT VARCHAR2,
    p_p_first_endt_sw OUT VARCHAR2,
    p_c_prompt_prov OUT VARCHAR2,
    p_p_v_endt OUT VARCHAR2,
    p_p_confirm_sw OUT VARCHAR2,
    p_v_exp_chg_sw OUT VARCHAR2,
    p_v_v_old_date_eff OUT DATE,
    p_p_sysdate_sw OUT VARCHAR2,
	p_p_open_policy_sw OUT VARCHAR2,
    p_gipi_parlist OUT gipis031_ref_cursor_pkg.rc_gipi_parlist_type,
    p_gipi_wpolbas OUT gipis031_ref_cursor_pkg.rc_gipi_wpolbas_type2,    
    p_msg_alert OUT VARCHAR2)
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    01.02.2012    mark jm            Retrieve information based on the new specified policy number
    **                                Fires only when the entered policy number is changed (Original Description)
    **                                Reference By : (GIPIS031 - Endt Basic Information)
    */    
    v_tmp_incept_date        gipi_wpolbas.incept_date%TYPE; 
    v_tmp_expiry_date        gipi_wpolbas.expiry_date%TYPE; 
    v_tmp_eff_date            gipi_wpolbas.eff_date%TYPE; 
    v_tmp_endt_expiry_date    gipi_wpolbas.endt_expiry_date%TYPE; 
    v_tmp_mortg_name        gipi_wpolbas.mortg_name%TYPE; 
    v_tmp_prov_prem_tag        gipi_wpolbas.prov_prem_tag%TYPE; 
    v_tmp_prov_prem_pct        gipi_wpolbas.prov_prem_pct%TYPE; 
    v_tmp_govt_acc_sw        gipi_wpolbas.foreign_acc_sw%TYPE; 
    v_tmp_comp_sw            gipi_wpolbas.comp_sw%TYPE; 
    v_tmp_prem_warr_tag        gipi_wpolbas.prem_warr_tag%TYPE; 
    v_tmp_prorate_flag        gipi_wpolbas.prorate_flag%TYPE; 
    v_tmp_short_rt_percent    gipi_wpolbas.short_rt_percent%TYPE; 
    v_tmp_add1                gipi_wpolbas.address1%TYPE; 
    v_tmp_add2                gipi_wpolbas.address1%TYPE; 
    v_tmp_add3                gipi_wpolbas.address1%TYPE; 
    v_tmp_assd_no            gipi_wpolbas.assd_no%TYPE; 
    v_tmp_type_cd            gipi_wpolbas.type_cd%TYPE; 
    v_tmp_ann_tsi_amt        gipi_wpolbas.ann_tsi_amt%TYPE; 
    v_tmp_ann_prem_amt        gipi_wpolbas.ann_prem_amt%TYPE; 
    v_fi_line_cd            gipi_wpolbas.subline_cd%TYPE;  --* To store parameter value of line FIRE *--

    v_tmp_incept_tag        gipi_wpolbas.incept_tag%TYPE;       
    v_tmp_expiry_tag        gipi_wpolbas.expiry_tag%TYPE;       

    v_tmp_reg_policy_sw        gipi_wpolbas.reg_policy_sw%TYPE;
    v_tmp_co_insurance_sw    gipi_wpolbas.co_insurance_sw%TYPE;
    v_tmp_endt_expiry_tag    gipi_wpolbas.endt_expiry_tag%TYPE;
    v_tmp_manual_renew_no    gipi_wpolbas.manual_renew_no%TYPE;
    v_tmp_cred_branch        gipi_wpolbas.cred_branch%TYPE;
    v_tmp_ref_pol_no        gipi_wpolbas.ref_pol_no%TYPE;
    v_max_eff_date1            gipi_wpolbas.eff_date%TYPE;
    v_max_eff_date2            gipi_wpolbas.eff_date%TYPE;
    v_max_eff_date            gipi_wpolbas.eff_date%TYPE;
    v_eff_date                gipi_wpolbas.eff_date%TYPE;
    v_pol_id                gipi_polbasic.policy_id%TYPE;
    v_max_endt_seq_no        gipi_wpolbas.endt_seq_no%TYPE;
    v_max_endt_seq_no1        gipi_wpolbas.endt_seq_no%TYPE;
    v_prorate                gipi_itmperil.prem_rt%TYPE := 0;   
    v_amt_sw                VARCHAR2(1);   -- switch that will determine if amount is already 
    v_comp_prem                gipi_polbasic.prem_amt%TYPE  := 0;   -- variable that will store computed prem 
    v_expired_sw            VARCHAR2(1);   -- switch that is used to determine if policy have short term endt.
    -- fields that will be use in storing computed amounts when computing for the amount
    -- of records with short term endorsement    
    v_ann_tsi2                gipi_polbasic.ann_tsi_amt%TYPE   :=0; 
    v_ann_prem2                gipi_polbasic.ann_prem_amt%TYPE  :=0;
    v_tmp_takeup_term        gipi_wpolbas.takeup_term%TYPE;
    v_tmp_bank_ref_no            gipi_wpolbas.bank_ref_no%type:=null;
    --06.25.2012 added for bancassurance details
    v_tmp_bancassurance_sw        gipi_polbasic.bancassurance_sw%TYPE;
    v_tmp_banc_type_cd            gipi_polbasic.banc_type_cd%TYPE;
    v_tmp_area_cd                gipi_polbasic.area_cd%TYPE;    
    v_tmp_branch_cd                gipi_polbasic.branch_cd%TYPE;
    v_tmp_manager_cd            gipi_polbasic.manager_cd%TYPE;
    v_tmp_acct_of_cd            gipi_polbasic.acct_of_cd%TYPE;
    
    -- added by irwin nov.14.2012
    v_tmp_risk_tag          gipi_polbasic.risk_tag%TYPE;
    v_tmp_region_cd  gipi_polbasic.region_cd%TYPE;
    v_tmp_industry_cd  gipi_polbasic.INDUSTRY_CD%TYPE;
    v_tmp_place_cd    gipi_polbasic.place_cd%TYPE;
    
    v_tmp_label_tag   GIPI_WPOLBAS.LABEL_TAG%TYPE; -- added by Kris 04.11.2014

    
    CURSOR B(
        p_line_cd  gipi_wpolbas.line_cd%TYPE,
        p_type_cd  gipi_wpolbas.type_cd%TYPE) 
    IS 
        SELECT type_desc
          FROM GIIS_POLICY_TYPE
         WHERE line_cd = p_line_cd
           AND type_cd = p_type_cd;    
    
    v_parlist        gipi_parlist%ROWTYPE;
    v_wpolbas        gipi_wpolbas%ROWTYPE;    
BEGIN    
    p_v_expiry_date := Extract_Expiry2(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
    
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
    
    --include retrieving of govt_acc_sw ,ref_pol_no, prem_warr_sw values
    --include retrieving of incept_tag,endt_expiry_tag,expiry_tag
    --include retrieving of bank reference number
    --include retrieving bancassurance_sw, banc_type_cd, area_cd, branch_cd, manager_cd
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
               b250.ref_pol_no, b250.takeup_term, b250.bank_ref_no,
               b250.bancassurance_sw, b250.banc_type_cd, b250.area_cd, 
               b250.branch_cd, b250.manager_cd, b250.acct_of_cd, b250.acct_of_cd_sw,  
               b250.risk_tag, b250.region_cd, b250.INDUSTRY_CD, b250.place_cd, b250.label_tag
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
        
        v_tmp_incept_date        := a1.incept_date; 
        v_tmp_expiry_date        := a1.expiry_date; 
        v_tmp_eff_date            := a1.eff_date; 
        v_tmp_endt_expiry_date    := a1.endt_expiry_date; 

        v_tmp_mortg_name        := a1.mortg_name; 
        v_tmp_prov_prem_tag        := a1.prov_prem_tag; 
        v_tmp_prov_prem_pct        := a1.prov_prem_pct; 
        v_tmp_prorate_flag        := a1.prorate_flag; 
        v_tmp_short_rt_percent    := a1.short_rt_percent; 
        v_tmp_type_cd            := a1.type_cd; 
        v_tmp_ann_tsi_amt        := a1.ann_tsi_amt; 
        v_tmp_ann_prem_amt        := a1.ann_prem_amt; 
        v_tmp_govt_acc_sw        := a1.foreign_acc_sw;
        v_tmp_comp_sw            := a1.comp_sw;
        v_tmp_prem_warr_tag        := a1.prem_warr_tag;
        
        v_tmp_expiry_tag        := a1.expiry_tag;
        v_tmp_incept_tag        := a1.incept_tag;
        v_tmp_endt_expiry_tag    := a1.endt_expiry_tag;
        v_tmp_reg_policy_sw        := a1.reg_policy_sw;
        v_tmp_co_insurance_sw    := a1.co_insurance_sw;
        v_tmp_manual_renew_no    := a1.manual_renew_no;
        v_tmp_cred_branch        := a1.cred_branch;
        v_tmp_ref_pol_no        := a1.ref_pol_no;
        
        v_tmp_takeup_term        := a1.takeup_term;  
        v_tmp_bank_ref_no        := a1.bank_ref_no;
        
        v_tmp_bancassurance_sw   := a1.bancassurance_sw;
        v_tmp_banc_type_cd       := a1.banc_type_cd;
        v_tmp_area_cd            := a1.area_cd;
        v_tmp_branch_cd          := a1.branch_cd;
        v_tmp_manager_cd         := a1.manager_cd;
        
        v_tmp_label_tag          := a1.label_tag;
        
        -- condition added by: Nica 01.08.2013  
        -- to assign null value to acct_of_cd if acct_of_cd 
        -- is deleted from previous endt (acct_of_cd_sw = 'Y')
        IF a1.acct_of_cd_sw = 'Y' THEN 
            v_tmp_acct_of_cd     := NULL;
        ELSE
            v_tmp_acct_of_cd     := a1.acct_of_cd;
        END IF;
        
        v_tmp_risk_tag           := a1.risk_tag    ;
        v_tmp_region_cd          := a1.region_cd;
        v_tmp_industry_cd        := a1.industry_cd;
        v_tmp_place_cd           := a1.place_Cd;
        
        EXIT;        
    END LOOP;
    
    IF v_tmp_ref_pol_no IS NULL THEN        
        v_tmp_ref_pol_no := Gipi_Polbasic_Pkg.get_ref_pol_no(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
    END IF;    
    
    v_wpolbas.line_cd            := p_line_cd;
    v_wpolbas.subline_cd        := p_subline_cd;
    v_wpolbas.iss_cd            := p_iss_cd;
    v_wpolbas.issue_yy            := p_issue_yy;
    v_wpolbas.pol_seq_no        := p_pol_seq_no;
    v_wpolbas.renew_no            := p_renew_no;    
    v_wpolbas.endt_iss_cd        := p_iss_cd;
    v_wpolbas.endt_yy            := p_issue_yy;    
    v_wpolbas.incept_date        := NVL(v_tmp_incept_date, v_wpolbas.incept_date);
    v_wpolbas.incept_tag        := v_tmp_incept_tag;
    v_wpolbas.expiry_tag        := v_tmp_expiry_tag;
    v_wpolbas.endt_expiry_tag    := v_tmp_endt_expiry_tag;
    v_wpolbas.eff_date            := NULL;
    v_wpolbas.endt_expiry_date    := NVL(v_tmp_endt_expiry_date, p_v_expiry_date); --change v_tmp_expiry_date to p_v_expiry_date by June Mark SR23166 [11.09.16]
    v_wpolbas.type_cd            := v_tmp_type_cd;
    v_wpolbas.same_polno_sw        := 'N';    
    v_wpolbas.foreign_acc_sw    := NVL(v_tmp_govt_acc_sw,'N');
    v_wpolbas.comp_sw            := v_tmp_comp_sw;
    v_wpolbas.prem_warr_tag        := v_tmp_prem_warr_tag;    
    v_wpolbas.old_assd_no        := v_tmp_assd_no;                    
    v_wpolbas.old_address1        := v_tmp_add1;
    v_wpolbas.old_address2        := v_tmp_add2;
    v_wpolbas.old_address3        := v_tmp_add3;    
    v_wpolbas.address1            := v_tmp_add1;
    v_wpolbas.address2            := v_tmp_add2;
    v_wpolbas.address3            := v_tmp_add3;
    v_wpolbas.reg_policy_sw        := NVL(v_tmp_reg_policy_sw,'Y');
    v_wpolbas.co_insurance_sw    := NVL(v_tmp_co_insurance_sw,'1');
    v_wpolbas.manual_renew_no    := v_tmp_manual_renew_no;
    v_wpolbas.cred_branch        := v_tmp_cred_branch;
    v_wpolbas.ref_pol_no        := v_tmp_ref_pol_no;
    v_wpolbas.takeup_term        := v_tmp_takeup_term;    
    v_wpolbas.booking_mth        := NULL;
    v_wpolbas.booking_year        := NULL;
    
    v_wpolbas.bank_ref_no        := v_tmp_bank_ref_no;
    v_wpolbas.bancassurance_sw   := v_tmp_bancassurance_sw;
    v_wpolbas.banc_type_cd       := v_tmp_banc_type_cd;
    v_wpolbas.area_cd            := v_tmp_area_cd;
    v_wpolbas.branch_cd          := v_tmp_branch_cd;
    v_wpolbas.manager_cd         := v_tmp_manager_cd;
    v_wpolbas.acct_of_cd         := v_tmp_acct_of_cd;
    
    v_parlist.assd_no          := v_tmp_assd_no;
    v_parlist.address1         := v_tmp_add1;
    v_parlist.address2         := v_tmp_add2;
    v_parlist.address3         := v_tmp_add3;
    
    v_wpolbas.risk_tag          :=v_tmp_risk_tag   ;
    v_wpolbas.region_cd          :=v_tmp_region_cd     ;
    v_wpolbas.industry_cd          :=v_tmp_industry_cd ;
    v_wpolbas.place_cd          :=v_tmp_place_cd;
    v_wpolbas.mortg_name         := v_tmp_mortg_name; --added by christian 03/05/13
    v_wpolbas.label_tag          := v_tmp_label_tag;  -- added by Kris 04.11.2014
    
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
           --AND TRUNC(B.eff_date) <=  TRUNC(SYSDATE) 
           AND TRUNC(B.eff_date) <=  TRUNC(v_wpolbas.incept_date) -- bonok :: 07.12.2013 :: as per mam jhing, replaced SYSDATE with the new endorsement's incept_date
          -- AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) < TRUNC(SYSDATE)
--           AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
--               p_v_expiry_date, expiry_date,b.endt_expiry_date)) < SYSDATE
           AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
               p_v_expiry_date, expiry_date,b.endt_expiry_date)) < v_wpolbas.endt_expiry_date -- bonok :: 07.12.2013 :: as per mam jhing, replaced SYSDATE with the new endorsement's expiry_date
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
               --AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                    --p_v_expiry_date, expiry_date,b.endt_expiry_date)) >= SYSDATE
               AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                   p_v_expiry_date, expiry_date,b.endt_expiry_date)) >= TRUNC(v_wpolbas.endt_expiry_date) -- bonok :: 07.12.2013 :: as per mam jhing, replaced SYSDATE with the new endorsement's expiry_date
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
         
        v_wpolbas.ann_tsi_amt := v_ann_tsi2;
        v_wpolbas.ann_prem_amt := v_ann_prem2;
    END IF;
    
    IF p_v_expiry_date IS NULL THEN --June Mark SR23166 [11.09.16]
        IF v_wpolbas.line_cd NOT IN ('MH', 'AV') THEN
            v_wpolbas.expiry_date := ADD_MONTHS(v_wpolbas.incept_date,12) - 1;
        ELSE
            v_wpolbas.expiry_date := ADD_MONTHS(v_wpolbas.incept_date,12);
        END IF; 
    ELSE
        v_wpolbas.expiry_date := p_v_expiry_date; --June Mark SR23166 [11.09.16]
    END IF;
        
    p_v_expiry_date_1 := ADD_MONTHS(v_wpolbas.incept_date,12);  --June Mark SR23166 [01.04.17]
    
    IF v_wpolbas.line_cd  = v_fi_line_cd THEN   --* If line is FIRE prov_prem_tag and
        v_wpolbas.prov_prem_tag := 'N';      --* and prov_prem_pct IS NOT RETRIEVED
        v_wpolbas.prov_prem_pct := NULL;
    ELSIF v_tmp_prov_prem_tag = 'Y' THEN        
        p_c_prompt_prov  := 'Premium % :';
        v_wpolbas.prov_prem_tag := 'Y'; -- kenneth 11.25.2015 SR 20984
        v_wpolbas.prov_prem_pct := v_tmp_prov_prem_pct;        
    ELSE
        v_wpolbas.prov_prem_tag  := 'N';    
        v_wpolbas.prov_prem_pct  :=  NULL;        
    END IF;
    
    IF v_tmp_prorate_flag = '3' THEN
        v_wpolbas.prorate_flag     := '3';    
        --:b540.nbt_short_rt_percent := v_tmp_short_rt_percent;      
    ELSIF v_tmp_prorate_flag = '2' THEN
        v_wpolbas.prorate_flag     := '2';
        --:b540.nbt_short_rt_percent := NULL;                
    ELSE 
        v_wpolbas.prorate_flag     := '1';    
        --:b540.nbt_short_rt_percent := NULL;
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
    
    /* p_p_open_policy_sw */
    FOR A1 IN (
        SELECT open_policy_sw
          FROM giis_subline
         WHERE line_cd = v_wpolbas.line_cd 
           AND subline_cd = v_wpolbas.subline_cd)
    LOOP
        p_p_open_policy_sw  := a1.open_policy_sw;
        EXIT;
   END LOOP;
    
    <<RAISE_FORM_TRIGGER_FAILURE>>    
    NULL;    
      
    /* creates new record cursor for GIPI_PARLIST based on the following data */
    OPEN p_gipi_parlist FOR
    SELECT par_id,                        p_line_cd line_cd,                p_iss_cd iss_cd,
           par_yy,                        par_seq_no,                        quote_seq_no,
           par_type,                    par_status,                        v_parlist.assd_no assd_no,
           v_parlist.address1 address1,    v_parlist.address2 address2,    v_parlist.address3 address3
      FROM GIPI_PARLIST
     WHERE par_id = p_par_id;
    
    /* creates new record cursor for GIPI_WPOLBAS based on the following data */
    OPEN p_gipi_wpolbas FOR
    SELECT v_wpolbas.line_cd line_cd,                    v_wpolbas.subline_cd subline_cd,                v_wpolbas.iss_cd iss_cd,
           v_wpolbas.issue_yy issue_yy,                    v_wpolbas.pol_seq_no pol_seq_no,                v_wpolbas.renew_no renew_no,
           v_wpolbas.endt_iss_cd endt_iss_cd,            v_wpolbas.endt_yy endt_yy,                        v_wpolbas.incept_date incept_date,
           v_wpolbas.incept_tag incept_tag,                v_wpolbas.expiry_tag expiry_tag,                v_wpolbas.endt_expiry_date endt_expiry_tag,
           v_wpolbas.eff_date eff_date,                    v_wpolbas.endt_expiry_date endt_expiry_date,    v_wpolbas.type_cd type_cd,
           v_wpolbas.same_polno_sw same_polno_sw,        v_wpolbas.foreign_acc_sw foreign_acc_sw,        v_wpolbas.comp_sw comp_sw,
           v_wpolbas.prem_warr_tag prem_warr_tag,        v_wpolbas.old_assd_no old_assd_no,                v_wpolbas.old_address1 old_address1,
           v_wpolbas.old_address2 old_address2,            v_wpolbas.old_address3 old_address3,            v_wpolbas.address1 address1,
           v_wpolbas.address2 address2,                    v_wpolbas.address3 address3,                    v_wpolbas.reg_policy_sw reg_policy_sw,
           v_wpolbas.co_insurance_sw co_insurance_sw,    v_wpolbas.manual_renew_no manual_renew_no,        v_wpolbas.cred_branch cred_branch,
           v_wpolbas.ref_pol_no ref_pol_no,                v_wpolbas.takeup_term takeup_term,                v_wpolbas.booking_mth booking_mth,
           v_wpolbas.booking_year booking_year,            v_wpolbas.expiry_date expiry_date,                v_wpolbas.prov_prem_tag prov_prem_tag,
           v_wpolbas.prov_prem_pct prov_prem_pct,        v_wpolbas.prorate_flag prorate_flag,            v_wpolbas.pol_flag pol_flag,
           v_wpolbas.ann_tsi_amt ann_tsi_amt,            v_wpolbas.ann_prem_amt ann_prem_amt,            v_wpolbas.issue_date issue_date,
           v_wpolbas.pack_pol_flag pack_pol_flag,         v_wpolbas.bank_ref_no bank_ref_no,             v_wpolbas.bancassurance_sw bancassurance_sw,
           v_wpolbas.banc_type_cd banc_type_cd,           v_wpolbas.area_cd area_cd,                     v_wpolbas.branch_cd branch_cd,
           v_wpolbas.manager_cd manager_cd,                v_wpolbas.acct_of_cd acct_of_cd,				 v_wpolbas.risk_tag risk_tag,
           v_wpolbas.region_cd region_cd ,				v_wpolbas.industry_cd  industry_cd, 			 v_wpolbas.place_cd  place_cd,
		   v_wpolbas.mortg_name mortg_name, v_wpolbas.label_tag label_tag
      FROM dual;
END SEARCH_FOR_POLICY_1;
/


