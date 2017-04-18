DROP PROCEDURE CPI.SEARCH_FOR_PACK_POLICY;

CREATE OR REPLACE PROCEDURE CPI.search_for_pack_policy(
	    p_par_id			IN GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
		p_line_cd			IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
		p_subline_cd		IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
		p_iss_cd			IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
		p_issue_yy			IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
		p_pol_seq_no		IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
		p_renew_no			IN GIPI_PACK_WPOLBAS.renew_no%TYPE,
		p_param_modal_flag	IN OUT VARCHAR2,
		p_p_first_endt_sw	OUT VARCHAR2,
		p_v_expiry_date		OUT DATE,
		p_g_cg$back_endt	OUT VARCHAR2,
		p_c_prompt_prov		OUT VARCHAR2,
		p_p_v_endt			OUT VARCHAR2,
		p_p_confirm_sw		OUT VARCHAR2,
		p_v_exp_chg_sw		OUT VARCHAR2,
		p_p_sysdate_sw		OUT VARCHAR2,
		p_v_v_old_date_eff	OUT DATE,
		p_msg_alert			OUT VARCHAR2,
		p_gipi_pack_parlist_cur		   OUT GIPI_PACK_PARLIST_PKG.rc_gipi_pack_parlist_cur,
		p_gipi_pack_wpolbas_cur		   OUT GIPI_PACK_WPOLBAS_PKG.rc_gipi_pack_wpolbas_cur,
	    p_gipi_pack_wendttext_cur	   OUT GIPI_PACK_WENDTTEXT_PKG.rc_gipi_pack_wendttext_cur,
	    p_gipi_pack_wpolgenin_cur	   OUT GIPI_PACK_WPOLGENIN_PKG.rc_gipi_pack_wpolgenin_cur
)
AS
  /*
  **  Created by	: Emman
  **  Date Created 	: 22.22.2010
  **  Reference By 	: (GIPIS031A - Pack Endt Basic Information)
  **  Description 	: Retrieve information based on the new specified policy number
  **					: Fires only when the entered policy number is changed
  **					: (Original Description)
  */
	
  tmp_incept_date   	    gipi_wpolbas.incept_date%TYPE; 
  tmp_expiry_date	        gipi_wpolbas.expiry_date%TYPE; 
  tmp_eff_date	            gipi_wpolbas.eff_date%TYPE; 
  tmp_endt_expiry_date      gipi_wpolbas.endt_expiry_date%TYPE; 
  tmp_mortg_name	        gipi_wpolbas.mortg_name%TYPE; 
  tmp_prov_prem_tag         gipi_wpolbas.prov_prem_tag%TYPE; 
  tmp_prov_prem_pct         gipi_wpolbas.prov_prem_pct%TYPE; 
  tmp_govt_acc_sw           gipi_wpolbas.foreign_acc_sw%TYPE; 
  tmp_comp_sw               gipi_wpolbas.comp_sw%TYPE; 
  tmp_prem_warr_tag         gipi_wpolbas.prem_warr_tag%TYPE; 
  tmp_prorate_flag	        gipi_wpolbas.prorate_flag%TYPE; 
  tmp_short_rt_percent      gipi_wpolbas.short_rt_percent%TYPE; 
  tmp_add1                  gipi_wpolbas.address1%TYPE; 
  tmp_add2                  gipi_wpolbas.address1%TYPE; 
  tmp_add3                  gipi_wpolbas.address1%TYPE; 
  tmp_assd_no               gipi_wpolbas.assd_no%TYPE; 
  tmp_type_cd               gipi_wpolbas.type_cd%TYPE; 
  tmp_ann_tsi_amt           gipi_wpolbas.ann_tsi_amt%TYPE; 
  tmp_ann_prem_amt          gipi_wpolbas.ann_prem_amt%TYPE; 
  fi_line_cd                gipi_wpolbas.subline_cd%TYPE;  --* To store parameter value of line FIRE *--
  
  tmp_incept_tag            gipi_wpolbas.incept_tag%TYPE;       
  tmp_expiry_tag            gipi_wpolbas.expiry_tag%TYPE;       
  
  tmp_reg_policy_sw         gipi_wpolbas.reg_policy_sw%TYPE;
  tmp_co_insurance_sw       gipi_wpolbas.co_insurance_sw%TYPE;
  tmp_endt_expiry_tag       gipi_wpolbas.endt_expiry_tag%TYPE;
  tmp_manual_renew_no       gipi_wpolbas.manual_renew_no%TYPE;
  tmp_cred_branch			gipi_wpolbas.cred_branch%TYPE;
  tmp_ref_pol_no			gipi_wpolbas.ref_pol_no%TYPE;
  tmp_bank_ref_no           gipi_polbasic.bank_ref_no%TYPE; /*petermkaw 06212010 search below */
  tmp_assd_name				giis_assured.assd_name%TYPE;
  tmp_dsp_cred_branch		giis_issource.iss_name%TYPE;
  v_max_eff_date1           gipi_wpolbas.eff_date%TYPE;
  v_max_eff_date2           gipi_wpolbas.eff_date%TYPE;
  v_max_eff_date            gipi_wpolbas.eff_date%TYPE;
  p_eff_date                gipi_wpolbas.eff_date%TYPE;
  p_pol_id                  gipi_polbasic.policy_id%TYPE;
  v_max_endt_seq_no         gipi_wpolbas.endt_seq_no%TYPE;
  v_max_endt_seq_no1        gipi_wpolbas.endt_seq_no%TYPE;
  v_prorate                 gipi_itmperil.prem_rt%TYPE := 0;   
  amt_sw                    VARCHAR2(1);   -- switch that will determine if amount is already 
  v_comp_prem               gipi_polbasic.prem_amt%TYPE  := 0;   -- variable that will store computed prem 
  expired_sw                VARCHAR2(1);   -- switch that is used to determine if policy have short term endt.
  -- fields that will be use in storing computed amounts when computing for the amount
  -- of records with short term endorsement	
  v_ann_tsi2                gipi_polbasic.ann_tsi_amt%TYPE   :=0; 
  v_ann_prem2               gipi_polbasic.ann_prem_amt%TYPE  :=0;
  --added by reymon 04192013
  tmp_acct_of_cd            gipi_polbasic.acct_of_cd%TYPE;
  tmp_place_cd              gipi_polbasic.place_cd%TYPE;
  tmp_risk_tag              gipi_polbasic.risk_tag%TYPE;
  tmp_industry_cd           gipi_polbasic.industry_cd%TYPE;
  tmp_region_cd             gipi_polbasic.region_cd%TYPE;
  tmp_label_tag             gipi_polbasic.label_tag%TYPE;
  
  CURSOR B(p_line_cd  gipi_wpolbas.line_cd%TYPE,
           p_type_cd  gipi_wpolbas.type_cd%TYPE) IS 
         SELECT  type_desc
           FROM  giis_policy_type
          WHERE  line_cd  = p_line_cd
            AND  type_cd  = p_type_cd;
			
  v_pack_parlist		GIPI_PACK_PARLIST%ROWTYPE;
  v_pack_wpolbas		GIPI_PACK_WPOLBAS%ROWTYPE;
BEGIN
  p_v_expiry_date := GIPI_PACK_POLBASIC_PKG.extract_expiry(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
  
  v_pack_wpolbas.eff_date := NULL;
  
  GIPI_PACK_WPOLBAS_PKG.get_acct_of_cd(p_line_cd,
					   	               p_subline_cd,
					   	               p_iss_cd,
					   	               p_issue_yy,
					   	               p_pol_seq_no,
					   	               p_renew_no,
									   v_pack_wpolbas.eff_date,
									   v_pack_wpolbas.acct_of_cd,
									   v_pack_wpolbas.label_tag,
									   p_param_modal_flag);
   
  fi_line_cd := Giis_Parameters_Pkg.v('FIRE');
  
  p_g_cg$back_endt := 'N';
  
  FOR X IN (SELECT b2501.eff_date eff_date, b2501.pack_policy_id   pol_id
              FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
             WHERE b2501.line_cd    = p_line_cd
               AND b2501.subline_cd = p_subline_cd
               AND b2501.iss_cd     = p_iss_cd
               AND b2501.issue_yy   = p_issue_yy
               AND b2501.pol_seq_no = p_pol_seq_no
               AND b2501.renew_no   = p_renew_no
               AND b2501.pol_flag   IN ('1','2','3','X')
               AND b2501.endt_seq_no = 0) 
  LOOP
    p_eff_date := x.eff_date;
    p_pol_id   := x.pol_id;
    EXIT;
  END LOOP;             	
               
  FOR W IN (SELECT MAX(endt_seq_no) endt_seq_no 
              FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
             WHERE b2501.line_cd    = p_line_cd
               AND b2501.subline_cd = p_subline_cd
               AND b2501.iss_cd     = p_iss_cd
               AND b2501.issue_yy   = p_issue_yy
               AND b2501.pol_seq_no = p_pol_seq_no
               AND b2501.renew_no   = p_renew_no
               AND b2501.pol_flag   IN ('1','2','3','X')
               AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE) 
  LOOP
    v_max_endt_seq_no := w.endt_seq_no;  
    EXIT;
  END LOOP;
  IF v_max_endt_seq_no > 0 THEN
   	 FOR G IN (SELECT MAX(endt_seq_no) endt_seq_no
                 FROM gipi_pack_polbasic b250 --A.R.C. 07.26.2006
                WHERE b250.line_cd    = p_line_cd
                  AND b250.subline_cd = p_subline_cd
                  AND b250.iss_cd     = p_iss_cd
                  AND b250.issue_yy   = p_issue_yy
                  AND b250.pol_seq_no = p_pol_seq_no
                  AND b250.renew_no   = p_renew_no
                  AND b250.pol_flag   IN ('1','2','3','X')
                  AND nvl(b250.endt_expiry_date,b250.expiry_date) >= SYSDATE
                  AND nvl(b250.back_stat,5) = 2) 
     LOOP
       v_max_endt_seq_no1 := g.endt_seq_no;
       EXIT;
     END LOOP;
     IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN             
        FOR Z IN (SELECT MAX(b2501.eff_date) eff_date
                    FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
                   WHERE b2501.line_cd    = p_line_cd
                     AND b2501.subline_cd = p_subline_cd
                     AND b2501.iss_cd     = p_iss_cd
                     AND b2501.issue_yy   = p_issue_yy
                     AND b2501.pol_seq_no = p_pol_seq_no
                     AND b2501.renew_no   = p_renew_no
                     AND b2501.pol_flag   IN ('1','2','3','X')
                     AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                     AND nvl(b2501.back_stat,5) = 2
                     AND b2501.endt_seq_no = v_max_endt_seq_no1) 
        LOOP
          v_max_eff_date := z.eff_date;
          EXIT;
        END LOOP;             
     ELSE                
        FOR Z IN (SELECT MAX(b2501.eff_date) eff_date
                    FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
                   WHERE b2501.line_cd    = p_line_cd
                     AND b2501.subline_cd = p_subline_cd
                     AND b2501.iss_cd     = p_iss_cd
                     AND b2501.issue_yy   = p_issue_yy
                     AND b2501.pol_seq_no = p_pol_seq_no
                     AND b2501.renew_no   = p_renew_no
                     AND b2501.pol_flag   IN ('1','2','3','X')
                     AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                     AND nvl(b2501.back_stat,5) = 2
                     AND b2501.endt_seq_no = v_max_endt_seq_no1) 
        LOOP
          v_max_eff_date1 := z.eff_date;
          EXIT;
        END LOOP;                             	
        FOR Y IN (SELECT MAX(b2501.eff_date) eff_date
                    FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
                   WHERE b2501.line_cd    = p_line_cd
                     AND b2501.subline_cd = p_subline_cd
                     AND b2501.iss_cd     = p_iss_cd
                     AND b2501.issue_yy   = p_issue_yy
                     AND b2501.pol_seq_no = p_pol_seq_no
                     AND b2501.renew_no   = p_renew_no
                     AND b2501.pol_flag   IN ('1','2','3','X')
                     AND b2501.endt_seq_no != 0
                     AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= SYSDATE
                     AND nvl(b2501.back_stat,5)!= 2) 
        LOOP
        	v_max_eff_date2 := y.eff_date;
          EXIT;
        END LOOP;               
        v_max_eff_date := nvl(v_max_eff_date2,v_max_eff_date1);                         
     END IF;       
  ELSE
     p_p_first_endt_sw := 'Y';   	
     v_max_eff_date := p_eff_date;
  END IF;
   
  --check first for the existance of short term endt. 
  expired_sw := 'N';
  FOR SW IN(SELECT '1'
              FROM GIPI_ITMPERIL A,
                   GIPI_POLBASIC C, --A.R.C. 07.26.2006
                   GIPI_PACK_POLBASIC B --A.R.C. 07.26.2006
             WHERE B.line_cd      =  p_line_cd
               AND B.subline_cd   =  p_subline_cd
               AND B.iss_cd       =  p_iss_cd
               AND B.issue_yy     =  p_issue_yy
               AND B.pol_seq_no   =  p_pol_seq_no
               AND B.renew_no     =  p_renew_no
               AND b.pack_policy_id = c.pack_policy_id
               AND c.policy_id    =  A.policy_id
               AND B.pol_flag     in('1','2','3','X')
               AND (NVL(A.prem_amt,0) <> 0 OR  NVL(A.tsi_amt,0) <> 0) 
               AND TRUNC(B.eff_date) <=  TRUNC(SYSDATE)
               AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                   p_v_expiry_date, b.expiry_date,b.endt_expiry_date)) < SYSDATE
          	 ORDER BY B.eff_date DESC)
  LOOP
    expired_sw := 'Y';
    EXIT;
  END LOOP; 
  --for policy with no expired_sw
  IF expired_sw = 'N' THEN
  	 --get the amount from the latest endt
  	 amt_sw := 'N';
  	 Gipi_Pack_Polbasic_Pkg.get_amt_from_latest_endt(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, NULL, 'SEARCH_FOR_POLICY', v_pack_wpolbas.ann_tsi_amt, v_pack_wpolbas.ann_prem_amt, amt_sw);
	 
     --for policy without endt., get amounts from policy
  	 IF amt_sw = 'N' THEN
  	 	Gipi_Pack_Polbasic_Pkg.get_amt_from_pol_wout_endt(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_pack_wpolbas.ann_tsi_amt, v_pack_wpolbas.ann_prem_amt);          
  	 END IF;
  ELSE	 
     --for policy with short term endt. amounts should be recomputed by adding up 
     --all policy and endt. that is not yet expired.
     FOR A2 IN(SELECT (C.tsi_amt * A.currency_rt) tsi,
                      (C.prem_amt * a.currency_rt) prem,       
                      B.eff_date,          B.endt_expiry_date,    B.expiry_date,
                      B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
                      B.short_rt_percent   short_rt,
                      C.peril_cd, b.incept_date
                 FROM GIPI_ITEM A,
                      GIPI_POLBASIC D,
                      GIPI_PACK_POLBASIC B,
                      GIPI_ITMPERIL C
                WHERE B.line_cd      =  p_line_cd
                  AND B.subline_cd   =  p_subline_cd
                  AND B.iss_cd       =  p_iss_cd
                  AND B.issue_yy     =  p_issue_yy
                  AND B.pol_seq_no   =  p_pol_seq_no
                  AND B.renew_no     =  p_renew_no
                  AND B.pack_policy_id = D.pack_policy_id
                  AND D.policy_id    =  A.policy_id
                  AND D.policy_id    =  C.policy_id
                  AND A.item_no      =  C.item_no
                  AND B.pol_flag     in('1','2','3','X') 
                  AND TRUNC(b.eff_date) <=  DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(SYSDATE))
                  AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                   p_v_expiry_date, b.expiry_date,b.endt_expiry_date)) >= SYSDATE
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
       FOR TYPE IN(SELECT peril_type
                     FROM giis_peril
                    WHERE line_cd  = p_line_cd
                      AND peril_cd = A2.peril_cd)
       LOOP
         IF type.peril_type = 'B' THEN
            v_ann_tsi2  := v_ann_tsi2  + A2.tsi;
         END IF;
       END LOOP;        
     END LOOP;
     v_pack_wpolbas.ann_tsi_amt  := v_ann_tsi2;
     v_pack_wpolbas.ann_prem_amt := v_ann_prem2;
  END IF;   
  
  FOR A1 IN (SELECT  b250.incept_date,      b250.expiry_date,   b250.eff_date,
                     b250.endt_expiry_date, b250.mortg_name,    b250.prorate_flag, 
                     b250.short_rt_percent, b250.prov_prem_tag, b250.prov_prem_pct, 
                     b250.type_cd,          b250.line_cd,
                     b250.ann_tsi_amt,      b250.ann_prem_amt,
                     b250.foreign_acc_sw,   b250.prem_warr_tag,
                     b250.expiry_tag,       b250.incept_tag,
                     b250.reg_policy_sw,    b250.co_insurance_sw,
                     b250.endt_expiry_tag,  b250.manual_renew_no,
                     NVL(b250.comp_sw,'N') comp_sw, b250.cred_branch,
                     b250.ref_pol_no,       b250.bank_ref_no,
                     --added by reymon 04192013
                     b250.acct_of_cd,        b250.place_cd,
                     b250.risk_tag,         b250.industry_cd,
                     b250.region_cd,        b250.label_tag
               FROM  gipi_pack_polbasic b250
              WHERE  b250.line_cd    = p_line_cd
                AND  b250.subline_cd = p_subline_cd
                AND  b250.iss_cd     = p_iss_cd
                AND  b250.issue_yy   = p_issue_yy
                AND  b250.pol_seq_no = p_pol_seq_no
                AND  b250.renew_no   = p_renew_no
                AND  b250.pol_flag   IN ('1','2','3','X') 
                AND  b250.eff_date   = v_max_eff_date
           ORDER BY b250.endt_seq_no  DESC )
 LOOP
    GIPI_PACK_POLBASIC_PKG.gipis031A_search_for_assured(tmp_assd_no, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
    GIPI_PACK_POLBASIC_PKG.gipis031A_search_for_address(tmp_add1, tmp_add2, tmp_add3, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
    
    tmp_incept_date       := a1.incept_date; 
    tmp_expiry_date	      := a1.expiry_date; 
    tmp_eff_date	        := a1.eff_date; 
    tmp_endt_expiry_date  := a1.endt_expiry_date; 
                                              
    tmp_mortg_name	      := a1.mortg_name; 
    tmp_prov_prem_tag     := a1.prov_prem_tag; 
    tmp_prov_prem_pct     := a1.prov_prem_pct; 
    tmp_prorate_flag      := a1.prorate_flag; 
    tmp_short_rt_percent  := a1.short_rt_percent; 
    tmp_type_cd           := a1.type_cd; 
    tmp_ann_tsi_amt       := a1.ann_tsi_amt; 
    tmp_ann_prem_amt      := a1.ann_prem_amt; 
    tmp_govt_acc_sw       := a1.foreign_acc_sw;
    tmp_comp_sw           := a1.comp_sw;
    tmp_prem_warr_tag     := a1.prem_warr_tag;
    
    tmp_expiry_tag        := a1.expiry_tag;
    tmp_incept_tag        := a1.incept_tag;
    tmp_endt_expiry_tag   := a1.endt_expiry_tag;
    tmp_reg_policy_sw     := a1.reg_policy_sw;
    tmp_co_insurance_sw   := a1.co_insurance_sw;
    tmp_manual_renew_no   := a1.manual_renew_no;
    tmp_cred_branch       := a1.cred_branch;
    tmp_ref_pol_no        := a1.ref_pol_no;
    tmp_bank_ref_no		  := a1.bank_ref_no;
    
    --added by reymon 04192013
    tmp_acct_of_cd        := a1.acct_of_cd;
    tmp_place_cd          := a1.place_cd;
    tmp_risk_tag          := a1.risk_tag;
    tmp_industry_cd       := a1.industry_cd;
    tmp_region_cd         := a1.region_cd;
    tmp_label_tag         := a1.label_tag;
    
    EXIT;
  END LOOP;
  --Added by Iris Bordey 03.17.2003
  --To fetch ref_pol_no (req. by AUII prf# AUII-2003-01009)
  IF tmp_ref_pol_no IS NULL THEN
     FOR ref_pol_no IN (SELECT ref_pol_no
                         FROM gipi_pack_polbasic --A.R.C. 07.26.2006
                        WHERE 1=1
                          and line_cd    = p_line_cd
                          and subline_cd = p_subline_cd
                          and iss_cd     = p_iss_cd
                          and issue_yy   = p_issue_yy
                          and pol_seq_no = p_pol_seq_no
                          and renew_no   = p_renew_no
                          and ref_pol_no IS NOT NULL
                          AND pol_flag   IN ('1','2','3','X') 
                        ORDER BY EFF_DATE DESC)
     LOOP
  	   tmp_ref_pol_no        := ref_pol_no.ref_pol_no;
  	   EXIT;
     END LOOP;
  END IF;
  v_pack_parlist.assd_no := tmp_assd_no;
  
  FOR C1 IN (SELECT  assd_name
               FROM  giis_assured
              WHERE  assd_no = tmp_assd_no) 
  LOOP
  	v_pack_parlist.assd_no := tmp_assd_no;
    tmp_assd_name := c1.assd_name;
    EXIT;
  END LOOP;
           
  
  FOR X IN (SELECT iss_name
              FROM giis_issource
             WHERE iss_cd = tmp_cred_branch) 
  LOOP
    tmp_dsp_cred_branch := x.iss_name;
    EXIT;
  END LOOP;
  
  v_pack_wpolbas.line_cd     := p_line_cd;
  v_pack_wpolbas.subline_cd  := p_subline_cd;
  v_pack_wpolbas.iss_cd      := p_iss_cd;
  v_pack_wpolbas.issue_yy    := p_issue_yy;
  v_pack_wpolbas.pol_seq_no  := p_pol_seq_no;
  v_pack_wpolbas.renew_no    := p_renew_no;
           
  v_pack_wpolbas.endt_iss_cd      := p_iss_cd;
  v_pack_wpolbas.endt_yy          := p_issue_yy;
  
  v_pack_wpolbas.incept_date      := NVL(tmp_incept_date, v_pack_wpolbas.incept_date);
  v_pack_wpolbas.incept_tag       := tmp_incept_tag;
  v_pack_wpolbas.expiry_tag       := tmp_expiry_tag;
  v_pack_wpolbas.endt_expiry_tag  := tmp_endt_expiry_tag;
  v_pack_wpolbas.eff_date         := NULL;
  v_pack_wpolbas.endt_expiry_date := NVL(tmp_endt_expiry_date, tmp_expiry_date);
  
  v_pack_wpolbas.type_cd          := tmp_type_cd;
  v_pack_wpolbas.same_polno_sw    := 'N';
  
  v_pack_wpolbas.foreign_acc_sw   := nvl(tmp_govt_acc_sw,'N');
  v_pack_wpolbas.comp_sw          := tmp_comp_sw;
  v_pack_wpolbas.prem_warr_tag    := tmp_prem_warr_tag;
  v_pack_parlist.assd_no          := tmp_assd_no;
  v_pack_wpolbas.old_assd_no      := tmp_assd_no;                    
  v_pack_wpolbas.old_address1     := tmp_add1;
  v_pack_wpolbas.old_address2     := tmp_add2;
  v_pack_wpolbas.old_address3     := tmp_add3;
  v_pack_parlist.address1        := tmp_add1;
  v_pack_parlist.address2        := tmp_add2;
  v_pack_parlist.address3        := tmp_add3;
  v_pack_wpolbas.address1         := tmp_add1;--NULL;
  v_pack_wpolbas.address2         := tmp_add2;--NULL;
  v_pack_wpolbas.address3         := tmp_add3;--NULL;
  v_pack_wpolbas.reg_policy_sw    := nvl(tmp_reg_policy_sw,'Y');
  v_pack_wpolbas.co_insurance_sw  := nvl(tmp_co_insurance_sw,'1');
  v_pack_wpolbas.manual_renew_no  := tmp_manual_renew_no;
  v_pack_wpolbas.cred_branch      := tmp_cred_branch;
  v_pack_wpolbas.ref_pol_no       := tmp_ref_pol_no;
  v_pack_wpolbas.bank_ref_no      := tmp_bank_ref_no;
   
  --BETH 120699
  v_pack_wpolbas.booking_mth     := NULL;
  v_pack_wpolbas.booking_year    := NULL;
  
  --added by reymon 04192013
  v_pack_wpolbas.acct_of_cd      := tmp_acct_of_cd;
  v_pack_wpolbas.type_cd         := tmp_type_cd;
  v_pack_wpolbas.place_cd        := tmp_place_cd;
  v_pack_wpolbas.risk_tag        := tmp_risk_tag;
  v_pack_wpolbas.industry_cd     := tmp_industry_cd;
  v_pack_wpolbas.region_cd       := tmp_region_cd;
  v_pack_wpolbas.label_tag       := tmp_label_tag;
    
  IF tmp_expiry_date IS NULL THEN
     IF v_pack_wpolbas.line_cd NOT IN ('MH', 'AV') THEN
        v_pack_wpolbas.expiry_date := ADD_MONTHS(v_pack_wpolbas.incept_date,12) - 1;
     ELSE
        v_pack_wpolbas.expiry_date := ADD_MONTHS(v_pack_wpolbas.incept_date,12);
     END IF; 
  ELSE
     v_pack_wpolbas.expiry_date := tmp_expiry_DATE;
  END IF;
  	    
  IF v_pack_wpolbas.line_cd  = fi_line_cd THEN   --* If line is FIRE prov_prem_tag and
     v_pack_wpolbas.prov_prem_tag := 'N';      --* and prov_prem_pct IS NOT RETRIEVED
     v_pack_wpolbas.prov_prem_pct := NULL;
  ELSIF tmp_prov_prem_tag = 'Y' THEN
     p_c_prompt_prov  := 'Premium % :';
     v_pack_wpolbas.prov_prem_pct := tmp_prov_prem_pct;
  ELSE
     v_pack_wpolbas.prov_prem_tag  := 'N';	
     v_pack_wpolbas.prov_prem_pct  :=  NULL;
  END IF;
   
  IF tmp_prorate_flag = '3' THEN
     v_pack_wpolbas.prorate_flag     := '3';	
     --v_pack_wpolbas.nbt_short_rt_percent := tmp_short_rt_percent;  	
  ELSIF tmp_prorate_flag = '2' THEN
     v_pack_wpolbas.prorate_flag     := '2';
     --v_pack_wpolbas.nbt_short_rt_percent := NULL;				
  ELSE 
     v_pack_wpolbas.prorate_flag     := '1';	
     --v_pack_wpolbas.nbt_short_rt_percent := NULL;
  END IF;	
  
  p_p_v_endt		  := 'N';--switch to prevent the post-forms-commit trigger to fire
   
  IF trunc(v_pack_wpolbas.endt_expiry_date)  < trunc(v_pack_wpolbas.expiry_date) THEN
     p_p_confirm_sw := 'Y';
  ELSE
     p_p_confirm_sw := 'N';
  END IF;           
  
  p_v_exp_chg_sw := 'N';
  
  v_pack_wpolbas.pol_flag := '1';
  
  -- BETH 03142000 enable additional engineering info for line engineering
  --      for non-open policy 
  /*
  IF v_pack_wpolbas.line_cd = variables.lc_EN THEN
     SET_MENU_ITEM_PROPERTY('BASIC_INFO_MENU.ADDITIONAL_ENGG_BASIC_INFO',ENABLED,PROPERTY_TRUE); 
  END IF;
  
  FOR A IN (SELECT '1'
              FROM giis_subline
             WHERE line_cd = v_pack_wpolbas.line_cd
               AND subline_cd = v_pack_wpolbas.subline_cd
               AND op_flag = 'Y') 
  LOOP
    SET_MENU_ITEM_PROPERTY('BASIC_INFO_MENU.ADDITIONAL_ENGG_BASIC_INFO',ENABLED,PROPERTY_FALSE); 
  END LOOP;*/
  p_v_v_old_date_eff := NULL; 
  p_p_sysdate_sw := 'Y';
  
  <<RAISE_FORM_TRIGGER_FAILURE>>
  
  OPEN p_gipi_pack_wendttext_cur FOR
		SELECT p_par_id pack_par_id, 	NULL endt_cd, 		'N' endt_tax,
			   NULL endt_text01,		NULL endt_text02,	NULL endt_text03,
			   NULL endt_text04,		NULL endt_text05,	NULL endt_text06,
			   NULL endt_text07,		NULL endt_text08,	NULL endt_text09,
			   NULL endt_text10,		NULL endt_text11,	NULL endt_text12,
			   NULL endt_text13,		NULL endt_text14,	NULL endt_text15,
			   NULL endt_text16,		NULL endt_text17,	NULL dsp_endt_text
		  FROM DUAL;
		  
  OPEN p_gipi_pack_wpolgenin_cur FOR
		SELECT p_par_id pack_par_id, NULL genin_info_cd,		  NULL gen_info01,
			   NULL gen_info02,	  NULL gen_info03,				  NULL gen_info04,
			   NULL gen_info05,	  NULL gen_info06,				  NULL gen_info07,
			   NULL gen_info08,	  NULL gen_info09,				  NULL gen_info10,
			   NULL gen_info11,	  NULL gen_info12,				  NULL gen_info13,
			   NULL gen_info14,	  NULL gen_info15,				  NULL gen_info16,
			   NULL gen_info17,	  NULL dsp_gen_info
		  FROM DUAL;
		  
  OPEN p_gipi_pack_parlist_cur FOR
		SELECT b240.pack_par_id,	 	 		    v_pack_parlist.assd_no assd_no,	  	        b240.par_type,
			   b240.line_cd,			 			b240.par_yy,						  			b240.iss_cd,
			   b240.par_seq_no,			 			b240.quote_seq_no,					  			v_pack_parlist.address1 address1,
			   v_pack_parlist.address2 address2,	v_pack_parlist.address3 address3,	b240.par_status,
			   b240.line_cd || ' - ' ||  b240.iss_cd  || ' - ' || to_char(b240.par_yy, '09') || ' - ' ||
				  to_char(b240.par_seq_no, '099999') || ' - ' || to_char(b240.quote_seq_no, '09') drv_par_seq_no,
		       tmp_assd_name assd_name
		  FROM GIPI_PACK_PARLIST b240
		 WHERE b240.pack_par_id = p_par_id;
  --added values for place_cd, risk_tag, industry_cd and region_cd
  --reymon 04192013
  OPEN p_gipi_pack_wpolbas_cur FOR
  SELECT   p_par_id pack_par_id,		 		 	 	v_pack_wpolbas.label_tag label_tag,		  v_pack_wpolbas.endt_expiry_tag endt_expiry_tag,
		   v_pack_wpolbas.line_cd line_cd,		 		v_pack_wpolbas.subline_cd subline_cd,	  v_pack_wpolbas.iss_cd iss_cd,
		   v_pack_wpolbas.issue_yy issue_yy,	 		v_pack_wpolbas.pol_seq_no pol_seq_no,	  v_pack_wpolbas.renew_no renew_no,
		   NULL  assd_no,			 	 		 		v_pack_wpolbas.old_assd_no old_assd_no,	  v_pack_wpolbas.acct_of_cd acct_of_cd,
		   v_pack_wpolbas.endt_iss_cd endt_iss_cd,		v_pack_wpolbas.endt_yy endt_yy,			  NULL endt_seq_no,
		   v_pack_wpolbas.incept_date incept_date,		v_pack_wpolbas.incept_tag incept_tag,	  v_pack_wpolbas.expiry_date expiry_date,
		   v_pack_wpolbas.expiry_tag expiry_tag,		v_pack_wpolbas.prem_warr_tag prem_warr_tag, v_pack_wpolbas.eff_date eff_date,
		   v_pack_wpolbas.endt_expiry_date endt_expiry_date,	 	 		v_pack_wpolbas.place_cd place_cd,		  NULL place,	  	 			   			 	   			     NULL issue_date,
		   v_pack_wpolbas.type_cd type_cd,			 	v_pack_wpolbas.ref_pol_no ref_pol_no,	  v_pack_wpolbas.manual_renew_no manual_renew_no,
		   v_pack_wpolbas.pol_flag pol_flag,			NULL acct_of_cd_sw,			  			  v_pack_wpolbas.region_cd region_cd,		 		   			 	 				 NULL nbt_region_desc,
		   v_pack_wpolbas.industry_cd industry_cd,		 	 		 		NULL nbt_ind_desc,						  v_pack_wpolbas.address1 address1,				 				 v_pack_wpolbas.address2 address2,
		   v_pack_wpolbas.address3 address3,			v_pack_wpolbas.old_address1 old_address1, v_pack_wpolbas.old_address2 old_address2,
		   v_pack_wpolbas.old_address3 old_address3,	v_pack_wpolbas.cred_branch cred_branch,	  tmp_dsp_cred_branch dsp_cred_branch, 	 						 v_pack_wpolbas.bank_ref_no bank_ref_no,
		   NULL mortg_name,			 					v_pack_wpolbas.booking_year booking_year, v_pack_wpolbas.booking_mth booking_mth,
		   NULL covernote_printed_sw,	 				NULL quotation_printed_sw,	  			  v_pack_wpolbas.foreign_acc_sw foreign_acc_sw,
		   NULL invoice_sw,			 					NULL auto_renew_flag,			  		  v_pack_wpolbas.prorate_flag prorate_flag,
		   v_pack_wpolbas.comp_sw comp_sw,			 	NULL short_rt_percent,		  			  v_pack_wpolbas.prov_prem_tag prov_prem_tag,
		   NULL fleet_print_tag,	 	 				NULL with_tariff_sw,			  		  v_pack_wpolbas.prov_prem_pct prov_prem_pct,
		   NULL ref_open_pol_no,	 	 				v_pack_wpolbas.same_polno_sw same_polno_sw, v_pack_wpolbas.ann_tsi_amt ann_tsi_amt,
		   NULL prem_amt,			 	 				NULL tsi_amt,					  		  v_pack_wpolbas.ann_prem_amt ann_prem_amt,
		   v_pack_wpolbas.reg_policy_sw reg_policy_sw,	v_pack_wpolbas.co_insurance_sw co_insurance_sw, NULL user_id,
		   NULL pack_pol_flag,		 					NULL designation,				  		  NULL back_stat,
		   v_pack_wpolbas.risk_tag risk_tag,			 	 				NULL bancassurance_sw,		  			  NULL banc_type_cd, 			  								 NULL dsp_banc_type_desc,
		   NULL area_cd,			 	 		 		NULL dsp_area_desc, 					  NULL branch_cd,				 			 					 NULL dsp_branch_desc,
		   NULL dsp_area_cd,	 			 	 		NULL manager_cd,						  NULL assd_name
	  FROM DUAL;
END search_for_pack_policy;
/


