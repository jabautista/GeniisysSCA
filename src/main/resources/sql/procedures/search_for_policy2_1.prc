DROP PROCEDURE CPI.SEARCH_FOR_POLICY2_1;

CREATE OR REPLACE PROCEDURE CPI.SEARCH_FOR_POLICY2_1 (
	p_par_id		IN gipi_wpolbas.par_id%TYPE,
	p_line_cd		IN gipi_polbasic.line_cd%TYPE,
	p_subline_cd	IN gipi_polbasic.subline_cd%TYPE,
	p_iss_cd		IN gipi_polbasic.iss_cd%TYPE,
	p_issue_yy		IN gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no	IN gipi_polbasic.pol_seq_no%TYPE,
	p_renew_no		IN gipi_polbasic.renew_no%TYPE,	
	p_eff_date		IN gipi_wpolbas.eff_date%TYPE,
	p_expiry_date 	IN gipi_wpolbas.expiry_date%TYPE,
	pv_expiry_date	OUT gipi_wpolbas.expiry_date%TYPE,	
	p_gipi_parlist OUT gipi_parlist%ROWTYPE,
    p_gipi_wpolbas OUT gipi_wpolbas%ROWTYPE,
	p_msg_alert        OUT VARCHAR2,
    p_msg_alert_type OUT VARCHAR2)
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================    
    **    01.10.2012    mark jm            Retrieve information based on the new specified effecivity date
    **                                Fires only when the entered effecivity date is changed and if
    **                                endt is a backward endt or if the change in effectivity will
    **                                make it a backward endorsement (Original Description)
    **                                Reference By : (GIPIS031 - Endt. Basic Information)
    */
    
    v_tmp_incept_date            gipi_wpolbas.incept_date%TYPE; 
    v_tmp_expiry_date            gipi_wpolbas.expiry_date%TYPE; 
    v_tmp_eff_date                gipi_wpolbas.eff_date%TYPE; 
    v_tmp_endt_expiry_date        gipi_wpolbas.endt_expiry_date%TYPE; 
    v_tmp_mortg_name            gipi_wpolbas.mortg_name%TYPE; 
    v_tmp_prov_prem_tag            gipi_wpolbas.prov_prem_tag%TYPE; 
    v_tmp_prov_prem_pct            gipi_wpolbas.prov_prem_pct%TYPE; 
    v_tmp_govt_acc_sw            gipi_wpolbas.foreign_acc_sw%TYPE; 
    v_tmp_comp_sw                gipi_wpolbas.comp_sw%TYPE; 
    v_tmp_prem_warr_tag            gipi_wpolbas.prem_warr_tag%TYPE; 
    v_tmp_prorate_flag            gipi_wpolbas.prorate_flag%TYPE; 
    v_tmp_short_rt_percent        gipi_wpolbas.short_rt_percent%TYPE; 
    v_tmp_add1                    gipi_wpolbas.address1%TYPE; 
    v_tmp_add2                    gipi_wpolbas.address1%TYPE; 
    v_tmp_add3                    gipi_wpolbas.address1%TYPE; 
    v_tmp_assd_no                gipi_wpolbas.assd_no%TYPE; 
    v_tmp_type_cd                gipi_wpolbas.type_cd%TYPE; 
    v_tmv_ann_tsi_amt            gipi_wpolbas.ann_tsi_amt%TYPE; 
    v_tmv_ann_prem_amt            gipi_wpolbas.ann_prem_amt%TYPE; 
    v_fi_line_cd                gipi_wpolbas.subline_cd%TYPE;  --* To store parameter value of line FIRE *--
    v_tmp_incept_tag            gipi_wpolbas.incept_tag%TYPE;       
    v_tmp_expiry_tag            gipi_wpolbas.expiry_tag%TYPE;
    v_tmp_endt_expiry_tag        gipi_wpolbas.endt_expiry_tag%TYPE;              
    
    v_tmp_reg_policy_sw            gipi_wpolbas.reg_policy_sw%TYPE;
    v_tmp_co_insurance_sw        gipi_wpolbas.co_insurance_sw%TYPE;
    v_tmp_manual_renew_no        gipi_wpolbas.manual_renew_no%TYPE;
    v_tmp_cred_branch            gipi_wpolbas.cred_branch%TYPE;
    v_tmp_ref_pol_no            gipi_wpolbas.ref_pol_no%TYPE;

    v_max_eff_date1                gipi_wpolbas.eff_date%TYPE;
    v_max_eff_date2                gipi_wpolbas.eff_date%TYPE;
    v_max_eff_date                gipi_wpolbas.eff_date%TYPE;
    v_eff_date                    gipi_wpolbas.eff_date%TYPE;
    v_policy_id                    gipi_polbasic.policy_id%TYPE;
    v_max_endt_seq_no            gipi_wpolbas.endt_seq_no%TYPE;
    v_max_endt_seq_no1            gipi_wpolbas.endt_seq_no%TYPE;
    v_prorate                    gipi_itmperil.prem_rt%TYPE := 0;   
    v_amt_sw                    VARCHAR2(1);   -- switch that will determine if amount is already 
    v_comp_prem                    gipi_polbasic.prem_amt%TYPE  := 0;   -- variable that will store computed prem 
    v_expired_sw                VARCHAR2(1);   -- switch that is used to determine if policy have short term endt.
    -- fields that will be use in storing computed amounts when computing for the amount
    -- of records with short term endorsement    
    v_ann_tsi_amt                gipi_polbasic.ann_tsi_amt%TYPE := 0;
    v_ann_prem_amt                gipi_polbasic.ann_prem_amt%TYPE := 0;
    v_ann_tsi2                    gipi_polbasic.ann_tsi_amt%TYPE :=0; 
    v_ann_prem2                    gipi_polbasic.ann_prem_amt%TYPE:=0;
      
    CURSOR B(p_line_cd IN gipi_wpolbas.line_cd%TYPE,
           p_type_cd IN gipi_wpolbas.type_cd%TYPE) 
    IS 
        SELECT type_desc
          FROM giis_policy_type
         WHERE line_cd  = p_line_cd
           AND type_cd  = p_type_cd;
           
    v_wpolbas gipi_wpolbas%ROWTYPE;
BEGIN    
    pv_expiry_date := extract_expiry2(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
    
    -- get_acct_of_cd here
    
    --get policy id and effectivity of policy
    gipi_polbasic_pkg.get_eff_date_policy_id(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_eff_date, v_policy_id);    
    
    --get the maximum endt_seq_no
    v_max_endt_seq_no := gipi_polbasic_pkg.get_max_endt_seq_no(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 'SEARCH_FOR_POLICY2');
    
    IF v_max_endt_seq_no > 0 THEN
        --get maximum endt_seq_no for backward endt.
        v_max_endt_seq_no1 := gipi_polbasic_pkg.get_max_endt_seq_no_back_stat(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 'SEARCH_FOR_POLICY2');
        
        IF v_max_endt_seq_no != NVL(v_max_endt_seq_no1,-1) THEN             
            --get max. eff_date for backward endt with updates            
            v_max_eff_date1 := gipi_polbasic_pkg.get_max_eff_date_back_stat(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, v_max_endt_seq_no1, 'SEARCH_FOR_POLICY2');
            
            --get max eff_date for endt            
            v_max_eff_date2 := gipi_polbasic_pkg.get_endt_max_eff_date(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 'SEARCH_FOR_POLICY2');               
            v_max_eff_date := NVL(v_max_eff_date2,v_max_eff_date1);
        ELSE
            --address should be from the latest backward endt. with updates
            v_max_eff_date1 := gipi_polbasic_pkg.get_max_eff_date_back_stat(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, v_max_endt_seq_no1, 'SEARCH_FOR_POLICY2');      
            v_max_eff_date := v_max_eff_date1;              
        END IF;
    ELSE
        v_max_eff_date := v_eff_date;                
    END IF;
    
    v_expired_sw := 'N';
    
    FOR SW IN(
        SELECT '1'
          FROM gipi_itmperil A,
               gipi_polbasic B
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
        gipi_polbasic_pkg.get_amt_from_latest_endt(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_eff_date, 'SEARCH_FOR_POLICY2', v_ann_tsi_amt, v_ann_prem_amt, v_amt_sw);
        
        --for policy without endt., get amounts from policy
        IF v_amt_sw = 'N' THEN            
            gipi_polbasic_pkg.get_amt_from_pol_wout_endt(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_ann_tsi_amt, v_ann_prem_amt);
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
              FROM gipi_item A,
                   gipi_polbasic B,  
                   gipi_itmperil C
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
			   --AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
               --             pv_expiry_date, expiry_date,b.endt_expiry_date)) >= TRUNC(p_eff_date)
			   -- marco - 09.05.2012        
               AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                            pv_expiry_date, b.endt_expiry_date, TRUNC(b.endt_expiry_date))) >= TRUNC(p_eff_date)
          ORDER BY B.eff_date DESC)
        LOOP
            v_comp_prem := 0;
            IF A2.prorate_flag = 1 THEN
                IF A2.endt_expiry_date <= A2.eff_date THEN
                    /* error */
                    p_msg_alert := 'Your endorsement expiry date is equal to or less than your effectivity date.' || ' Restricted condition.';
                    p_msg_alert_type := 'ERROR';
                    RETURN;                    
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
                  FROM giis_peril
                 WHERE line_cd  = p_line_cd
                   AND peril_cd = A2.peril_cd)
            LOOP
                IF TYPE.peril_type = 'B' THEN
                    v_ann_tsi2  := v_ann_tsi2  + A2.tsi;
                END IF;
            END LOOP;        
        END LOOP;
        v_ann_tsi_amt  := v_ann_tsi2;
        v_ann_prem_amt := v_ann_prem2;
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
          FROM gipi_polbasic b250
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
        search_for_assured2(v_tmp_assd_no, p_eff_date, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);        
        search_for_address2(v_tmp_add1, v_tmp_add2, v_tmp_add3, p_eff_date, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
        
        v_tmp_incept_date       := a1.incept_date; 
        v_tmp_expiry_date        := a1.expiry_date; 
        v_tmp_endt_expiry_date  := a1.endt_expiry_date; 
        
        v_tmp_mortg_name        := a1.mortg_name; 
        v_tmp_prov_prem_tag     := a1.prov_prem_tag; 
        v_tmp_prov_prem_pct     := a1.prov_prem_pct; 
        v_tmp_prorate_flag      := a1.prorate_flag; 
        v_tmp_short_rt_percent  := a1.short_rt_percent; 
        v_tmp_type_cd           := a1.type_cd; 
        v_tmv_ann_tsi_amt       := a1.ann_tsi_amt; 
        v_tmv_ann_prem_amt      := a1.ann_prem_amt; 
        
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
    END LOOP;
    
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
    v_wpolbas.endt_expiry_date    := NVL(v_tmp_endt_expiry_date, v_tmp_expiry_date);    
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
    v_wpolbas.booking_mth        := NULL;
    v_wpolbas.booking_year        := NULL;
    v_wpolbas.ann_tsi_amt        := v_ann_tsi_amt;
    v_wpolbas.ann_prem_amt        := v_ann_prem_amt;    
    
    /* set data for GIPI_PARLIST */     
    FOR i IN (
        SELECT par_id,                p_line_cd line_cd,                p_iss_cd iss_cd,
               par_yy,                par_seq_no,                        quote_seq_no,
               par_type,            par_status,                        v_tmp_assd_no assd_no,
               v_tmp_add1 address1,    v_tmp_add2 address2,            v_tmp_add3 address3
          FROM gipi_parlist
         WHERE par_id = p_par_id)
    LOOP
        p_gipi_parlist.par_id         := i.par_id;
        p_gipi_parlist.line_cd         := i.line_cd;
        p_gipi_parlist.iss_cd         := i.iss_cd;
        p_gipi_parlist.par_yy         := i.par_yy;
        p_gipi_parlist.par_seq_no     := i.par_seq_no;
        p_gipi_parlist.quote_seq_no := i.quote_seq_no;
        p_gipi_parlist.par_type     := i.par_type;
        p_gipi_parlist.par_status     := i.par_status;
        p_gipi_parlist.assd_no         := i.assd_no;
        p_gipi_parlist.address1        := i.address1;
        p_gipi_parlist.address2        := i.address2;
        p_gipi_parlist.address3        := i.address3;
    END LOOP;
    
    /* creates new record cursor for GIPI_WPOLBAS based on the following data */
    p_gipi_wpolbas := v_wpolbas;
END SEARCH_FOR_POLICY2_1;
/


