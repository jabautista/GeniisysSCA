DROP PROCEDURE CPI.UPDATE_GIPI_WPOLBAS;

CREATE OR REPLACE PROCEDURE CPI.update_gipi_wpolbas(p_par_id  NUMBER,
                              p_prov_prem_pct IN NUMBER,
                              p_prov_prem_tag IN VARCHAR2) IS
  v_tsi             NUMBER(16,2) :=0;
  v_ann_tsi         NUMBER(16,2) :=0;
  v_prem            NUMBER(16,2):=0;
  v_ann_tsi2        NUMBER(16,2) :=0;
  v_ann_prem2       NUMBER(16,2) :=0;
  v_ann_prem        NUMBER(16,2) :=0;  
  prov_discount     NUMBER(12,9)  :=  NVL(p_prov_prem_pct/100,1);
  v_prorate         NUMBER(12,9);
  p_prov_prem       GIPI_WITMPERL.prem_amt%TYPE;
  po_prov_prem      GIPI_WITMPERL.prem_amt%TYPE;
  v_comp_prem       NUMBER(16,2) :=0;
  expired_sw        VARCHAR2(1) := 'N';
  v_exist           VARCHAR2(1);
  
  v_prorate_prem    NUMBER(15,5);--variable for computed negated premium
  v_no_of_days      NUMBER;                                             --
  v_days_of_policy  NUMBER;                                             --

   var_expiry_date        DATE;
   v_line_cd            gipi_wpolbas.line_cd%TYPE;
   v_subline_cd         gipi_wpolbas.subline_cd%TYPE;
   v_iss_cd             gipi_wpolbas.iss_cd%TYPE;
   v_issue_yy           gipi_wpolbas.issue_yy%TYPE;
   v_pol_seq_no         gipi_wpolbas.pol_seq_no%TYPE;
   v_renew_no           gipi_wpolbas.renew_no%TYPE;
   v_eff_date           gipi_wpolbas.eff_date%TYPE;
   v_prorate_flag       gipi_wpolbas.prorate_flag%TYPE;
   v_comp_sw            gipi_wpolbas.comp_sw%TYPE;
   v_incept_date        gipi_wpolbas.incept_date%TYPE;
   v_expiry_date        gipi_wpolbas.expiry_date%TYPE;
   v_endt_expiry_date   gipi_wpolbas.endt_expiry_date%TYPE;
   v_short_rt_percent   gipi_wpolbas.short_rt_percent%TYPE;     
BEGIN
   var_expiry_date := extract_expiry (p_par_id);

   SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, expiry_date, /*v_incept_date*/incept_date,
          renew_no, to_date(eff_date), -- added to_date by robert sr 13573 07.17.13 
          prorate_flag, comp_sw, endt_expiry_date, short_rt_percent
     INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_expiry_date, v_incept_date,
          v_renew_no, v_eff_date, v_prorate_flag, v_comp_sw, v_endt_expiry_date, v_short_rt_percent
     FROM gipi_wpolbas
    WHERE par_id = p_par_id;

    --select summarize premium and tsi of PAR 
  FOR A1 IN(SELECT SUM(NVL(tsi_amt,0)     *NVL(currency_rt,1))      TSI,
                   SUM(NVL(prem_amt,0)    *NVL(currency_rt,1))     PREM
              FROM gipi_witem
             WHERE par_id = p_par_id)
  LOOP
    v_ann_tsi        := v_ann_tsi +  A1.tsi;
    v_tsi            := v_tsi +  A1.tsi;
    v_prem           := v_prem +  A1.prem;
    IF NVL(p_prov_prem_tag,'N') != 'Y' THEN
       prov_discount       :=  1;
    END IF;
    /* Three conditions have to be considered for endorsements :
    **1 indicates that computation should be prorated.*/
    IF v_prorate_flag = 1 THEN
       IF v_endt_expiry_date <= v_eff_date THEN
          raise_application_error
                     (-20001,'Your endorsement expiry date is equal to or less than your effectivity date.'||
                    ' Restricted condition.');
       ELSE
          -->
          --added by bdarusin
--on feb 20, 2002
--to compute for the negated premium which will be compared to the prem amt entered by the user
--based on the create_negated_records_prorate procedure of gipis031
       FOR A2 IN(SELECT  b380.peril_cd peril, b380.prem_amt prem, b380.tsi_amt tsi, b380.ri_comm_amt comm,
                         b380.prem_rt rate, nvl(b250.endt_expiry_date, b250.expiry_date) expiry_date,
                         b250.eff_date, b250.prorate_flag, DECODE(nvl(comp_sw,'N'),'Y',1,'M',-1,0) comp_sw    
                   FROM  gipi_polbasic b250, gipi_itmperil b380
                  WHERE  b250.line_cd    = v_line_cd
                    AND  b250.subline_cd = v_subline_cd
                    AND  b250.iss_cd     = v_iss_cd
                    AND  b250.issue_yy   = v_issue_yy
                    AND  b250.pol_seq_no = v_pol_seq_no
                    --AND  nvl(b250.endt_expiry_date,b250.expiry_date) >= :b540.eff_date
                    AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                   var_expiry_date, b250.endt_expiry_date,b250.endt_expiry_date)) >= v_eff_date
                    AND  b250.pol_flag   IN ('1','2','3','X') 
                    AND  b250.policy_id  = b380.policy_id
                    --AND  B380.peril_cd   = :b490.peril_cd
                    ) 
       LOOP
            v_no_of_days     := NULL;
         v_days_of_policy := NULL;
         v_prorate_prem := 0;
            -- get no of days that a particular record exists
            -- in order to get correct computation of perm. per day
            v_days_of_policy := TRUNC(a2.expiry_date) - TRUNC(a2.eff_date);    
            IF v_prorate_flag = 1 THEN
                   v_days_of_policy := v_days_of_policy + a2.comp_sw;    
            END IF;      
            --get no. of days that will be returned 
           IF v_comp_sw = 'Y' THEN
             v_no_of_days  :=  (TRUNC(a2.expiry_date) - TRUNC(v_eff_date))+ 1;             
         ELSIF v_comp_sw = 'M' THEN
             v_no_of_days  :=  (TRUNC(a2.expiry_date) - TRUNC(v_eff_date)) - 1;             
         ELSE
             v_no_of_days  :=  TRUNC(a2.expiry_date) - TRUNC(v_eff_date);
         END IF;
		 
		 -- When TRUNC (a2.expiry_date) = TRUNC (a2.eff_date) and comp_sw = 'N', this result 
		 -- to v_policy_days = 0 which triggers ORA-01476 (divisor is equal to zero) error.
		 -- As per Ma'am Grace, same  dates of a2.expiry_date and a2.eff_date should already
		 -- be considered as 1 day. -- Nica 06.04.2013 
		 IF NVL (v_days_of_policy, 0) = 0 THEN
			v_days_of_policy := 1;
		 END IF;
		 
         --for policy or endt with no of days less than the no. of days of cancelling
         --endt. no_of days of cancelling endt. should be equal to the no_of days
         --of policy/endt. on process
         IF NVL(v_no_of_days,0)> NVL(v_days_of_policy,0) THEN
               v_no_of_days := v_days_of_policy;
         END IF;      
            --compute for negated premium for records with premium <> 0
         IF NVL(a2.prem,0) <> 0 THEN
            v_prorate_prem := v_prorate_prem + (-(a2.prem /v_days_of_policy)*(v_no_of_days));
         END IF;
       END LOOP;  
--end of added script by bdarusin
          /*By Iris Bordey 08.26.2003
          **Removed add_months operation for computaton of premium.  Replaced
          **it instead of variables.v_days (see check_duration) for short term endt.
          */
          --check_duration(:b540.incept_date,ADD_MONTHS(:b540.incept_date,12));
          IF v_comp_sw = 'Y' THEN
             v_prorate  :=  ((TRUNC( v_endt_expiry_date) - TRUNC(v_eff_date )) + 1 )/
                            check_duration(v_incept_date,v_expiry_date);
                            --(ADD_MONTHS(:b540.incept_date,12) - :b540.incept_date);
          ELSIF v_comp_sw = 'M' THEN
             v_prorate  :=  ((TRUNC( v_endt_expiry_date) - TRUNC(v_eff_date )) - 1 )/
                            check_duration(v_incept_date,v_expiry_date);
                            --(ADD_MONTHS(:b540.incept_date,12) - :b540.incept_date);
          ELSE
             v_prorate  :=  (TRUNC( v_endt_expiry_date) - TRUNC(v_eff_date ))/
                            check_duration(v_incept_date,v_expiry_date);
                            --(ADD_MONTHS(:b540.incept_date,12) - :b540.incept_date);
          END IF;
       END IF;
             -->bdarusin
       if a1.prem = round(v_prorate_prem,2) then
             a1.prem := v_prorate_prem;
       end if;
       --<bdarusin
       v_ann_prem := v_ann_prem + (A1.prem / (v_prorate));
    /*2 indicates that computation should be base on 1 year span*/   
    ELSIF v_prorate_flag = 2 THEN
       v_ann_prem := v_ann_prem + A1.prem;
    /*3 indicates that computation should be based with respect to the short rate percent.*/
    ELSE
       v_ann_prem :=  v_ann_prem +(A1.prem / (NVL(v_short_rt_percent,1)/100));
    END IF;
  END LOOP;
  /*check if policy has an existing expired short term endorsement(s) */ 
  FOR SW IN(SELECT '1'
              FROM GIPI_ITMPERIL A,
                   GIPI_POLBASIC B
             WHERE B.line_cd      =  v_line_cd
               AND B.subline_cd   =  v_subline_cd
               AND B.iss_cd       =  v_iss_cd
               AND B.issue_yy     =  v_issue_yy
               AND B.pol_seq_no   =  v_pol_seq_no
               AND B.renew_no     =  v_renew_no
               AND B.policy_id    =  A.policy_id
               AND B.pol_flag     in('1','2','3','X')
               AND (A.prem_amt <> 0 OR  A.tsi_amt <> 0) 
               AND TRUNC(B.eff_date) <=  TRUNC(v_eff_date)
               --AND NVL(B.endt_expiry_date,B.expiry_date) < TRUNC(:b240.eff_date)
               AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                  var_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) < TRUNC(v_eff_date)
          ORDER BY B.eff_date DESC)
  LOOP
    expired_sw := 'Y';
    EXIT;
  END LOOP; 
  /*update amounts in gipi_wpolbas 
  **for policy that have expired short term endorsement
  **recompute annualized amounts, for policy that does not have 
  **expired short term endorsements just get the amounts from the
  **latest endorsements
  */ 
  -- there are no existing short-term endt.
  IF NVL(expired_sw , 'N') = 'N' THEN
       v_exist := 'N';
       -- query amounts from the latest endt
     FOR A2 IN ( SELECT b250.ann_tsi_amt  ANN_TSI,
                        b250.ann_prem_amt ANN_PREM
                   FROM gipi_wpolbas b, gipi_polbasic b250 
                  WHERE b.par_id        = p_par_id
                    AND b250.line_cd    = b.line_cd
                    AND b250.subline_cd = b.subline_cd
                    AND b250.iss_cd     = b.iss_cd
                    AND b250.issue_yy   = b.issue_yy
                    AND b250.pol_seq_no = b.pol_seq_no
                    AND b250.renew_no   = b.renew_no
                    AND b250.pol_flag   IN ('1','2','3','X') 
                    AND TRUNC(b250.eff_date) <=  TRUNC(b.eff_date)
                    --AND NVL(b250.endt_expiry_date,b250.expiry_date) >= TRUNC(b.eff_date)
                    AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                    var_expiry_date, b250.endt_expiry_date,b250.endt_expiry_date)) >= TRUNC(b.eff_date)
                    AND NVL(b250.endt_seq_no,0) > 0
               ORDER BY b250.eff_date DESC)
     LOOP
       UPDATE gipi_wpolbas
          SET tsi_amt      = v_tsi,
              prem_amt     = v_prem,
              ann_tsi_amt  = A2.ann_tsi  + v_ann_tsi,
              ann_prem_amt = A2.ann_prem + v_ann_prem
        WHERE par_id = p_par_id;
         v_exist := 'Y'; -- toggle switch that will indicate that amount is alredy retrieved
       EXIT;
     END LOOP;     
     --for records with no endt. yet query it's amount from policy record
     IF v_exist = 'N' THEN
        FOR A2 IN ( SELECT b250.tsi_amt      TSI,
                           b250.prem_amt     PREM,
                           b250.ann_tsi_amt  ANN_TSI,
                           b250.ann_prem_amt ANN_PREM
                      FROM gipi_wpolbas b, gipi_polbasic b250 
                     WHERE b.par_id        = p_par_id
                       AND b250.line_cd    = b.line_cd
                       AND b250.subline_cd = b.subline_cd
                       AND b250.iss_cd     = b.iss_cd
                       AND b250.issue_yy   = b.issue_yy
                       AND b250.pol_seq_no = b.pol_seq_no
                       AND b250.renew_no   = b.renew_no
                       AND b250.pol_flag   IN ('1','2','3','X') 
                       AND NVL(b250.endt_seq_no,0) = 0
                  ORDER BY B.EFF_DATE DESC)
        LOOP
          UPDATE gipi_wpolbas
             SET tsi_amt      = v_tsi,
                 prem_amt     = v_prem,
                 ann_tsi_amt  = A2.ann_tsi  + v_ann_tsi,
                 ann_prem_amt = A2.ann_prem + v_ann_prem
           WHERE par_id = p_par_id;           
          EXIT;
        END LOOP;
     END IF;   
  ELSE 
     --for records with existing short term endt. amounts will be recomputed
     --by adding all amounts of policy and endt. that is not yet expired
     FOR A2 IN(SELECT (C.tsi_amt * A.currency_rt) tsi,
                      (C.prem_amt * a.currency_rt) prem,       
                      B.eff_date,          B.endt_expiry_date,    B.expiry_date,
                      B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
                      B.short_rt_percent   short_rt, b.incept_date,
                      C.peril_cd
                 FROM GIPI_ITEM A,
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
                  AND B.pol_flag    IN ('1','2','3','X') 
                  AND TRUNC(b.eff_date) <=  DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(v_eff_date))
                  --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= :b240.eff_date
                  AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                           var_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) >= v_eff_date
             ORDER BY B.eff_date DESC) 
     LOOP
       v_comp_prem := 0;
       IF A2.prorate_flag = 1 THEN
          IF A2.endt_expiry_date <= A2.eff_date THEN
             raise_application_error
                     (-20001,'Your endorsement expiry date is equal to or less than your effectivity date.'||
                       ' Restricted condition.');
          ELSE
              /*By Iris Bordey 08.26.2003
              **Removed add_months operation for computaton of premium.  Replaced
              **it instead of variables.v_days (see check_duration) for short term endt.
              */
              --check_duration(A2.incept_date,ADD_MONTHS(A2.incept_date,12));
             IF A2.comp_sw = 'Y' THEN
                v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) + 1 )/
                               check_duration(A2.incept_date,A2.expiry_date);
                               --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
             ELSIF A2.comp_sw = 'M' THEN
                v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) - 1 )/
                               check_duration(A2.incept_date,A2.expiry_date);
                               --(ADD_MONTHS(A2.incept_date,12) - A2.incept_date);
             ELSE 
                v_prorate  :=  (TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date ))/
                               check_duration(A2.incept_date,A2.expiry_date);
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
                    WHERE line_cd  = v_line_cd
                      AND peril_cd = A2.peril_cd)
       LOOP
         IF type.peril_type = 'B' THEN
            v_ann_tsi2  := v_ann_tsi2  + A2.tsi;
         END IF;
       END LOOP;        
     END LOOP;
     UPDATE gipi_wpolbas
        SET tsi_amt      = v_tsi,
            prem_amt     = v_prem,
            ann_tsi_amt  = v_ann_tsi2  + v_ann_tsi,
            ann_prem_amt = v_ann_prem2 + v_ann_prem
      WHERE par_id = p_par_id;
  END IF;
  
END;
/


