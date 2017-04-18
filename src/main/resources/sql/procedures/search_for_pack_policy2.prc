DROP PROCEDURE CPI.SEARCH_FOR_PACK_POLICY2;

CREATE OR REPLACE PROCEDURE CPI.search_for_pack_policy2(
    p_par_id        IN GIPI_WPOLBAS.par_id%TYPE,
    p_line_cd        IN GIPI_POLBASIC.line_cd%TYPE,
    p_subline_cd    IN GIPI_POLBASIC.subline_cd%TYPE,
    p_iss_cd        IN GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy        IN GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no	IN GIPI_POLBASIC.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_POLBASIC.renew_no%TYPE,	
	p_eff_date		IN GIPI_WPOLBAS.eff_date%TYPE,
	p_expiry_date 	IN GIPI_WPOLBAS.expiry_date%TYPE,
	pv_expiry_date	OUT GIPI_WPOLBAS.expiry_date%TYPE,	
	p_ann_tsi_amt	OUT	GIPI_WPOLBAS.ann_tsi_amt%TYPE,
	p_ann_prem_amt	OUT GIPI_WPOLBAS.ann_prem_amt%TYPE,
	p_msg_alert		OUT VARCHAR2,
	p_success		OUT BOOLEAN
) 
IS
  tmp_incept_date              gipi_wpolbas.incept_date%TYPE; 
  tmp_expiry_date               gipi_wpolbas.expiry_date%TYPE; 
  tmp_eff_date                 gipi_wpolbas.eff_date%TYPE; 
  tmp_endt_expiry_date       gipi_wpolbas.endt_expiry_date%TYPE; 
  tmp_mortg_name               gipi_wpolbas.mortg_name%TYPE; 
  tmp_prov_prem_tag          gipi_wpolbas.prov_prem_tag%TYPE; 
  tmp_prov_prem_pct          gipi_wpolbas.prov_prem_pct%TYPE; 
  tmp_govt_acc_sw            gipi_wpolbas.foreign_acc_sw%TYPE; 
  tmp_comp_sw                gipi_wpolbas.comp_sw%TYPE; 
  tmp_prem_warr_tag          gipi_wpolbas.prem_warr_tag%TYPE; 
  tmp_prorate_flag             gipi_wpolbas.prorate_flag%TYPE; 
  tmp_short_rt_percent       gipi_wpolbas.short_rt_percent%TYPE; 
  tmp_add1                   gipi_wpolbas.address1%TYPE; 
  tmp_add2                   gipi_wpolbas.address1%TYPE; 
  tmp_add3                   gipi_wpolbas.address1%TYPE; 
  tmp_assd_no                gipi_wpolbas.assd_no%TYPE; 
  tmp_type_cd                gipi_wpolbas.type_cd%TYPE; 
  tmp_ann_tsi_amt            gipi_wpolbas.ann_tsi_amt%TYPE; 
  tmp_ann_prem_amt           gipi_wpolbas.ann_prem_amt%TYPE; 
  fi_line_cd                 gipi_wpolbas.subline_cd%TYPE;  --* To store parameter value of line FIRE *--
  tmp_incept_tag             gipi_wpolbas.incept_tag%TYPE;       
  tmp_expiry_tag             gipi_wpolbas.expiry_tag%TYPE;
  tmp_endt_expiry_tag        gipi_wpolbas.endt_expiry_tag%TYPE;              
   
  tmp_reg_policy_sw          gipi_wpolbas.reg_policy_sw%TYPE;
  tmp_co_insurance_sw        gipi_wpolbas.co_insurance_sw%TYPE;
  tmp_manual_renew_no        gipi_wpolbas.manual_renew_no%TYPE;
  tmp_cred_branch            gipi_wpolbas.cred_branch%TYPE;
  tmp_ref_pol_no             gipi_wpolbas.ref_pol_no%TYPE;
   
  v_max_eff_date1            gipi_wpolbas.eff_date%TYPE;
  v_max_eff_date2            gipi_wpolbas.eff_date%TYPE;
  v_max_eff_date             gipi_wpolbas.eff_date%TYPE;
  v_eff_date                 gipi_wpolbas.eff_date%TYPE;
  p_policy_id                gipi_polbasic.policy_id%TYPE;
  v_max_endt_seq_no          gipi_wpolbas.endt_seq_no%TYPE;
  v_max_endt_seq_no1         gipi_wpolbas.endt_seq_no%TYPE;
  v_prorate                  gipi_itmperil.prem_rt%TYPE := 0;   
  amt_sw                     VARCHAR2(1);   -- switch that will determine if amount is already 
  v_comp_prem                gipi_polbasic.prem_amt%TYPE  := 0;   -- variable that will store computed prem 
  expired_sw                 VARCHAR2(1);   -- switch that is used to determine if policy have short term endt.
  -- fields that will be use in storing computed amounts when computing for the amount
  -- of records with short term endorsement    
  v_ann_tsi2                 gipi_polbasic.ann_tsi_amt%TYPE :=0; 
  v_ann_prem2                gipi_polbasic.ann_prem_amt%TYPE:=0;
    
  var_expiry_date            DATE;
  v_end_of_transaction       BOOLEAN;
    
  CURSOR B(p_line_cd  gipi_wpolbas.line_cd%TYPE,
           p_type_cd  gipi_wpolbas.type_cd%TYPE) IS 
         SELECT  type_desc
           FROM  giis_policy_type
          WHERE  line_cd  = p_line_cd
            AND  type_cd  = p_type_cd;
BEGIN
  var_expiry_date := GIPI_PACK_POLBASIC_PKG.extract_expiry(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
  --extract_expiry;
  --*--
   --by iris bordey
   --07.11.2002
   --fetch for acct_of_cd
--  get_acct_of_cd(:cg$ctrl.line_cd2,
--                      :cg$ctrl.subline_cd2,
--                      :cg$ctrl.iss_cd2,
--                      :cg$ctrl.iss_yy2,
--                      :cg$ctrl.pol_seq_no2,
--                      :cg$ctrl.renew_no2);                               
  FOR X IN (SELECT b2501.eff_date eff_date, b2501.pack_policy_id policy_id
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
    v_eff_date := x.eff_date;
    p_policy_id := x.policy_id;
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
               AND TRUNC(b2501.eff_date) <= TRUNC(nvl(p_eff_date,SYSDATE))
               AND TRUNC(nvl(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(p_eff_date)) 
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
                  AND TRUNC(b250.eff_date) <= TRUNC(p_eff_date)
                  AND TRUNC(nvl(b250.endt_expiry_date,b250.expiry_date)) >= TRUNC(p_eff_date)
                  AND nvl(b250.back_stat,5) = 2) 
     LOOP
       v_max_endt_seq_no1 := g.endt_seq_no;
       EXIT;
     END LOOP;
     IF v_max_endt_seq_no != nvl(v_max_endt_seq_no1,-1) THEN             
        FOR Z IN (SELECT MAX(b2501.eff_date) eff_date
                    FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
                   WHERE b2501.line_cd    = p_line_cd
                     AND b2501.subline_cd = p_subline_cd
                     AND b2501.iss_cd     = p_iss_cd
                     AND b2501.issue_yy   = p_issue_yy
                     AND b2501.pol_seq_no = p_pol_seq_no
                     AND b2501.renew_no   = p_renew_no
                     AND b2501.pol_flag   IN ('1','2','3','X')
                     AND TRUNC(b2501.eff_date)   <= TRUNC(p_eff_date)
                     AND TRUNC(nvl(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(p_eff_date)
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
                     AND TRUNC(b2501.eff_date) <= TRUNC(p_eff_date)
                     AND TRUNC(nvl(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(p_eff_date)
                     AND nvl(b2501.back_stat,5)!= 2) 
        LOOP
          v_max_eff_date2 := y.eff_date;
          EXIT;
        END LOOP;               
        v_max_eff_date := nvl(v_max_eff_date2,v_max_eff_date1);                         
     ELSE
        FOR C IN (SELECT MAX(b2501.eff_date) eff_date
                    FROM gipi_pack_polbasic b2501 --A.R.C. 07.26.2006
                   WHERE b2501.line_cd    = p_line_cd
                     AND b2501.subline_cd = p_subline_cd
                     AND b2501.iss_cd     = p_iss_cd
                     AND b2501.issue_yy   = p_issue_yy
                     AND b2501.pol_seq_no = p_pol_seq_no
                     AND b2501.renew_no   = p_renew_no
                     AND b2501.pol_flag   IN ('1','2','3','X')
                     AND TRUNC(b2501.eff_date)   <= TRUNC(p_eff_date)
                     AND TRUNC(nvl(b2501.endt_expiry_date,b2501.expiry_date)) >= TRUNC(p_eff_date)
                     AND nvl(b2501.back_stat,5) = 2
                     AND b2501.endt_seq_no = v_max_endt_seq_no1) 
        LOOP
          v_max_eff_date1 := c.eff_date;
          EXIT;
        END LOOP;              
        v_max_eff_date := v_max_eff_date1;              
     END IF;
  ELSE
     v_max_eff_date := p_eff_date;                
  END IF;
  --SYNCHRONIZE;
  /*BETH 02152001 latest annualized amounts must be retrieved from the latest endt,
  **     for policy without endt yet latest annualized amount will be the amounts of 
  **     policy record. For cases with short-term endt. annualized amount should be recomputed
  **     by adding up all policy/endt that is not yet expired
  */
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
               AND B.pack_policy_id    =  c.pack_policy_id --A.R.C. 07.26.2006
               AND c.policy_id    =  A.policy_id --A.R.C. 07.26.2006
               AND B.pol_flag     in('1','2','3','X')
               AND (NVL(A.prem_amt,0) <> 0 OR  NVL(A.tsi_amt,0) <> 0) 
               AND TRUNC(b.eff_date) <= TRUNC(P_eff_date)
               AND TRUNC(nvl(b.endt_expiry_date, b.expiry_date)) <TRUNC(p_eff_date)
             ORDER BY B.eff_date DESC)
  LOOP
    expired_sw := 'Y';
    EXIT;
  END LOOP; 
  --for policy with no expired_sw
  IF expired_sw = 'N' THEN
       --get the amount from the latest endt
       amt_sw := 'N';
     FOR AMT IN (SELECT b250.ann_tsi_amt,      b250.ann_prem_amt
                   FROM gipi_pack_polbasic b250 --A.R.C. 07.26.2006
                  WHERE b250.line_cd    = p_line_cd
                    AND b250.subline_cd = p_subline_cd
                    AND b250.iss_cd     = p_iss_cd
                    AND b250.issue_yy   = p_issue_yy
                    AND b250.pol_seq_no = p_pol_seq_no
                    AND b250.renew_no   = p_renew_no
                    AND b250.pol_flag   IN ('1','2','3','X') 
                    AND NVL(b250.endt_seq_no, 0) > 0
                    AND b250.eff_date  <= nvl(p_eff_date,SYSDATE)
               ORDER BY b250.eff_date DESC, b250.endt_seq_no  DESC )
     LOOP
       p_ann_tsi_amt      := amt.ann_tsi_amt; 
       p_ann_prem_amt     := amt.ann_prem_amt; 
       amt_sw := 'Y';
       EXIT;
     END LOOP;
     --for policy without endt., get amounts from policy
       IF amt_sw = 'N' THEN
             FOR AMT IN (SELECT b250.ann_tsi_amt,      b250.ann_prem_amt
                      FROM gipi_pack_polbasic b250 --A.R.C. 07.26.2006
                     WHERE b250.line_cd    = p_line_cd
                       AND b250.subline_cd = p_subline_cd
                       AND b250.iss_cd     = p_iss_cd
                       AND b250.issue_yy   = p_issue_yy
                       AND b250.pol_seq_no = p_pol_seq_no
                       AND b250.renew_no   = p_renew_no
                       AND b250.pol_flag   IN ('1','2','3','X') 
                       AND nvl(b250.endt_seq_no, 0) = 0)
        LOOP
             p_ann_tsi_amt      := amt.ann_tsi_amt;                   
          EXIT;
        END LOOP;
       END IF;
  ELSE     
     --for policy with short term endt. amounts should be recomputed by adding up 
     --all policy and endt. 
     FOR A2 IN(SELECT (C.tsi_amt * A.currency_rt) tsi,
                      (C.prem_amt * a.currency_rt) prem,       
                      B.eff_date,          B.endt_expiry_date,    B.expiry_date,
                      B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
                      B.short_rt_percent   short_rt,
                      C.peril_cd, b.incept_date
                 FROM GIPI_ITEM A,
                      GIPI_POLBASIC D, --A.R.C. 07.26.2006
                      GIPI_PACK_POLBASIC B,  --A.R.C. 07.26.2006 
                      GIPI_ITMPERIL C
                WHERE B.line_cd      =  p_line_cd
                  AND B.subline_cd   =  p_subline_cd
                  AND B.iss_cd       =  p_iss_cd
                  AND B.issue_yy     =  p_issue_yy
                  AND B.pol_seq_no   =  p_pol_seq_no
                  AND B.renew_no     =  p_renew_no
                  AND B.pack_policy_id = D.pack_policy_id --A.R.C. 07.26.2006
                  AND D.policy_id    =  A.policy_id --A.R.C. 07.26.2006
                  AND D.policy_id    =  C.policy_id --A.R.C. 07.26.2006
                  AND A.item_no      =  C.item_no
                  AND B.pol_flag     IN ('1','2','3','X') 
                  AND TRUNC(b.eff_date) <=  DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date))
               --   AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(:b540.eff_date)
                  AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                   var_expiry_date, b.expiry_date,b.endt_expiry_date)) >= TRUNC(p_eff_date)
             ORDER BY B.eff_date DESC) 
     LOOP
       v_comp_prem := 0;
       IF A2.prorate_flag = 1 THEN
          IF A2.endt_expiry_date <= A2.eff_date THEN
             p_msg_alert := 'Your endorsement expiry date is equal to or less than your effectivity date.'||
                       ' Restricted condition.';
             GOTO RAISE_FORM_TRIGGER_FAILURE;
                       
          ELSE
               /*By Iris Bordey
               **Removed add_months operation on computaton of v_prorate.  Replaced
               **it instead of variables.v_days (see check_duration) for short term endt.
               */
               IF A2.comp_sw = 'Y' THEN
                v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) + 1 )/
                               check_duration(A2.incept_date, A2.expiry_date);
                               --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
             ELSIF A2.comp_sw = 'M' THEN
                v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) - 1 )/
                               check_duration(A2.incept_date, A2.expiry_date);
                               --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
             ELSE 
                v_prorate  := (TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date ))/
                              check_duration(A2.incept_date, A2.expiry_date);
                              --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
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
     p_ann_tsi_amt  := v_ann_tsi2;
     p_ann_prem_amt := v_ann_prem2;
  END IF;   
  
--  FOR A1 IN (SELECT  b250.incept_date,      b250.expiry_date,  
--                     b250.endt_expiry_date, b250.mortg_name,    b250.prorate_flag, 
--                     b250.short_rt_percent, b250.prov_prem_tag, b250.prov_prem_pct, 
--                     b250.type_cd,          b250.line_cd,
--                     b250.ann_tsi_amt,      b250.ann_prem_amt,
--                     b250.foreign_acc_sw,   b250.prem_warr_tag,
--                     b250.expiry_tag,       b250.incept_tag,
--                     b250.reg_policy_sw,    b250.co_insurance_sw,
--                     b250.endt_expiry_tag,  b250.manual_renew_no,
--                     DECODE(b250.prorate_flag,'1',NVL(b250.comp_sw,'N')) comp_sw,
--                     b250.cred_branch,      b250.ref_pol_no
--               FROM  gipi_pack_polbasic b250 --A.R.C. 07.26.2006
--              WHERE  b250.line_cd    = p_line_cd
--                AND  b250.subline_cd = p_subline_cd
--                AND  b250.iss_cd     = p_iss_cd
--                AND  b250.issue_yy   = p_issue_yy
--                AND  b250.pol_seq_no = p_pol_seq_no
--                AND  b250.renew_no   = p_renew_no
--                AND  b250.pol_flag   IN ('1','2','3','X') 
--                AND  b250.eff_date   = v_max_eff_date
--           ORDER BY b250.endt_seq_no  DESC )
--  LOOP
--   
--    --beth 03212001 retrieved assured from latest endt    
--    --search_for_assured2(tmp_assd_no, p_eff_date, p_line_cd,	p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
--    --beth 03212001 retrieved address from latest endt
--    --search_for_address2(tmp_add1, tmp_add2, tmp_add3);
--    tmp_incept_date       := a1.incept_date; 
--    tmp_expiry_date          := a1.expiry_date; 
--    tmp_endt_expiry_date  := a1.endt_expiry_date; 
--                                                
--    tmp_mortg_name          := a1.mortg_name; 
--    tmp_prov_prem_tag     := a1.prov_prem_tag; 
--    tmp_prov_prem_pct     := a1.prov_prem_pct; 
--    tmp_prorate_flag      := a1.prorate_flag; 
--    tmp_short_rt_percent  := a1.short_rt_percent; 
--    tmp_type_cd           := a1.type_cd; 
--    tmp_ann_tsi_amt       := a1.ann_tsi_amt; 
--    tmp_ann_prem_amt      := a1.ann_prem_amt; 
--    
--    tmp_govt_acc_sw       := a1.foreign_acc_sw;
--    tmp_comp_sw           := a1.comp_sw;
--    tmp_prem_warr_tag     := a1.prem_warr_tag;
--    
--    tmp_expiry_tag        := a1.expiry_tag;
--    tmp_endt_expiry_tag   := a1.endt_expiry_tag;
--    tmp_incept_tag        := a1.incept_tag;
--    tmp_reg_policy_sw     := a1.reg_policy_sw;
--    tmp_co_insurance_sw   := a1.co_insurance_sw;
--    tmp_manual_renew_no   := a1.manual_renew_no;
--    tmp_cred_branch       := a1.cred_branch;
--    tmp_ref_pol_no        := a1.ref_pol_no;
--    
----    FOR B1 IN B(a1.line_cd, a1.type_cd) 
----    LOOP
----      :b540.dsp_type_cd := b1.type_desc;
----      EXIT;
----    END LOOP;
--    EXIT;
--  END LOOP;
  
--  FOR C1 IN (SELECT  assd_name
--               FROM  giis_assured
--              WHERE  assd_no = tmp_assd_no) 
--  LOOP
--      :b240.assd_no := tmp_assd_no;
--    :b240.drv_assd_no := c1.assd_name;
--    EXIT;
--  END LOOP;
--        
--  FOR X IN (SELECT iss_name
--              FROM giis_issource
--             WHERE iss_cd = tmp_cred_branch) 
--  LOOP
--    :b540.dsp_cred_branch := x.iss_name;
--    EXIT;
--  END LOOP;
--        
--  :b540.incept_tag       := tmp_incept_tag;
--  :b540.expiry_tag       := tmp_expiry_tag;
--  :b540.endt_expiry_tag  := tmp_endt_expiry_tag;
--  :b540.endt_expiry_date := NVL(tmp_endt_expiry_date, tmp_expiry_date);
--  :b540.type_cd          := tmp_type_cd;
--  :b540.same_polno_sw    := 'N';
--  
--  :b540.foreign_acc_sw   := nvl(tmp_govt_acc_sw,'N');
--  :b540.comp_sw          := tmp_comp_sw;
--  :b540.prem_warr_tag    := tmp_prem_warr_tag;
--  :b240.assd_no          := tmp_assd_no;
--  :b540.old_assd_no      := tmp_assd_no;                    
--  :b540.old_address1     := tmp_add1;
--  :b540.old_address2     := tmp_add2;
--  :b540.old_address3     := tmp_add3;
--  :b240.address1         := tmp_add1;
--  :b240.address2         := tmp_add2;
--  :b240.address3         := tmp_add3;
--  :b540.reg_policy_sw    := nvl(tmp_reg_policy_sw,'Y');
--  :b540.co_insurance_sw  := nvl(tmp_co_insurance_sw,'1');
--  :b540.manual_renew_no  := tmp_manual_renew_no;
--  :b540.cred_branch      := tmp_cred_branch;
--  --BETH 120699
--  :b540.booking_mth      := NULL;
--  :b540.booking_year     := NULL;
--         
--  IF tmp_prorate_flag = '3' THEN
--     :b540.prorate_flag     := '3';    
--     :b540.short_rt_percent := tmp_short_rt_percent;      
--  ELSIF tmp_prorate_flag = '2' THEN
--     :b540.prorate_flag     := '2';
--     :b540.short_rt_percent := NULL;                
--  ELSE 
--     :b540.prorate_flag     := '1';    
--     :B540.short_rt_percent := NULL;
--  END IF;    
--             
--  :b360.endt_text01   := NULL;
--  :b360.endt_text02   := NULL;
--  :b360.endt_text03   := NULL;
--  :b360.endt_text04   := NULL;
--  :b360.endt_text05   := NULL;
--  :b360.endt_text06   := NULL;
--  :b360.endt_text07   := NULL;
--  :b360.endt_text08   := NULL;
--  :b360.endt_text09   := NULL;
--  :b360.endt_text10   := NULL;
--  :b360.endt_text11   := NULL;
--  :b360.endt_text12   := NULL;
--  :b360.endt_text13   := NULL;
--  :b360.endt_text14   := NULL;
--  :b360.endt_text15   := NULL;
--  :b360.endt_text16   := NULL;
--  :b360.endt_text17   := NULL;
--  :b360.endt_text     := NULL;
--  :b360.dsp_endt_text := NULL;
--  :b550.gen_info01    := NULL;
--  :b550.gen_info02    := NULL;
--  :b550.gen_info03    := NULL;
--  :b550.gen_info04    := NULL;
--  :b550.gen_info05    := NULL;
--  :b550.gen_info06    := NULL;
--  :b550.gen_info07    := NULL;
--  :b550.gen_info08    := NULL;
--  :b550.gen_info09    := NULL;
--  :b550.gen_info10    := NULL;
--  :b550.gen_info11    := NULL;
--  :b550.gen_info12    := NULL;
--  :b550.gen_info13    := NULL;
--  :b550.gen_info14    := NULL;
--  :b550.gen_info15    := NULL;
--  :b550.gen_info16    := NULL;
--  :b550.gen_info17    := NULL;
--  :b550.gen_info      := NULL;
--  :b550.dsp_gen_info  := NULL;
--  :b360.endt_tax      := 'N';
--  :parameter.v_endt   := 'N';--switch to prevent the post-forms-commit trigger to fire
--  
--  IF trunc(:b540.endt_expiry_date)  < trunc(:b540.expiry_date) AND
--     TRUNC(NVL(variables.v_old_date_eff,SYSDATE)) != TRUNC(:b540.eff_date)THEN
--     :parameter.confirm_sw := 'Y';
--  ELSE
--     :parameter.confirm_sw := 'N';
--  END IF;           
--  
--  --beth 03132000 store derived assured name
--  variables.v_ext_assd := :b240.drv_assd_no;
--     
--  CLEAR_MESSAGE;
--   
--  variables.v_old_date_eff := NULL;      
 
	v_end_of_transaction := TRUE;
	
	<<RAISE_FORM_TRIGGER_FAILURE>>
	IF v_end_of_transaction THEN
		p_success := TRUE;
	END IF;

END;
/


