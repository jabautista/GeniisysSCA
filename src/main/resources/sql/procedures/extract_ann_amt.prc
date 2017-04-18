DROP PROCEDURE CPI.EXTRACT_ANN_AMT;

CREATE OR REPLACE PROCEDURE CPI.EXTRACT_ANN_AMT(p_par_id        IN GIPI_WITMPERL.par_id%TYPE,
                                            p_item_no       IN GIPI_WITMPERL.item_no%TYPE,
                                            p_peril_cd      IN GIPI_WITMPERL.peril_cd%TYPE,
                                            p_ann_tsi_amt   IN OUT GIPI_WITMPERL.ann_tsi_amt%TYPE,
                                            p_ann_prem_amt  IN OUT GIPI_WITMPERL.ann_prem_amt%TYPE,
                                            p_rec_flag      IN OUT GIPI_WITMPERL.rec_flag%TYPE,
                                            p_message       IN OUT VARCHAR2)
 
IS
  v_ann_tsi       gipi_witmperl.ann_tsi_amt%TYPE  := 0;
  v_ann_prem      gipi_witmperl.ann_prem_amt%TYPE := 0; 
  v_comp_tsi      gipi_witmperl.ann_tsi_amt%TYPE  := 0;
  v_comp_prem     gipi_witmperl.ann_prem_amt%TYPE := 0; 
  v_prorate       NUMBER;
 
  v_line_cd     GIPI_WPOLBAS.line_cd%TYPE;
  v_subline_cd  GIPI_WPOLBAS.subline_cd%TYPE;
  v_iss_cd      GIPI_WPOLBAS.iss_cd%TYPE;
  v_issue_yy    GIPI_WPOLBAS.issue_yy%TYPE;
  v_pol_seq_no  GIPI_WPOLBAS.pol_seq_no%TYPE;
  v_renew_no    GIPI_WPOLBAS.renew_no%TYPE;
  v_eff_date    GIPI_WPOLBAS.eff_date%TYPE;
  
  v_expiry_date DATE;
BEGIN
  FOR i IN (
    SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date
      FROM GIPI_WPOLBAS
     WHERE par_id = p_par_id)
  LOOP
    v_line_cd     := i.line_cd;
    v_subline_cd  := i.subline_cd;
    v_iss_cd      := i.iss_cd;
    v_issue_yy    := i.issue_yy;
    v_pol_seq_no  := i.pol_seq_no;
    v_renew_no    := i.renew_no;
    v_eff_date    := i.eff_date;        
  END LOOP;     

  v_expiry_date := EXTRACT_EXPIRY(p_par_id);
  
  FOR A1 IN (
      SELECT      A.tsi_amt tsi,       A.prem_amt prem,       A.prem_rt rate,
                  B.eff_date,          B.endt_expiry_date,    B.expiry_date,
                  B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw, b.incept_date,
                  B.short_rt_percent   short_rt
        FROM      GIPI_ITMPERIL A,
                  GIPI_POLBASIC B
       WHERE      B.line_cd      =  v_line_cd
         AND      B.subline_cd   =  v_subline_cd
         AND      B.iss_cd       =  v_iss_cd
         AND      B.issue_yy     =  v_issue_yy
         AND      B.pol_seq_no   =  v_pol_seq_no
         AND      B.renew_no     =  v_renew_no
         AND      B.policy_id    =  A.policy_id
         AND      A.item_no      =  p_item_no
         AND      A.peril_cd     =  p_peril_cd
         AND      B.pol_flag     IN ('1','2','3','X') 
         -- add this validation so that data that will be retrieved
         --           is only those from endorsement prior to the current endorsement
         --           this was consider because of the backward endorsement
         AND      TRUNC(B.eff_date)    <=  DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(v_eff_date))
         AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                    v_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) >= TRUNC(v_eff_date)
    ORDER BY      TRUNC(B.eff_date) DESC)
  LOOP
    v_comp_prem := 0;
    IF A1.prorate_flag = 1 THEN
      IF A1.endt_expiry_date <= A1.eff_date THEN
         p_message := 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.';
      ELSE      
         /*Removed add_months operation for computaton of premium.  Replaced
         **it instead of variables.v_days (see check_duration) for short term endt.
         */
        IF A1.comp_sw = 'Y' THEN
           v_prorate  :=  ((TRUNC( A1.endt_expiry_date) - TRUNC(A1.eff_date )) + 1 )/
                          check_duration(A1.incept_date,A1.expiry_date);
        ELSIF A1.comp_sw = 'M' THEN
           v_prorate  :=  ((TRUNC( A1.endt_expiry_date) - TRUNC(A1.eff_date )) - 1 )/
                            check_duration(A1.incept_date,A1.expiry_date);
        ELSE
           v_prorate  :=  (TRUNC( A1.endt_expiry_date) - TRUNC(A1.eff_date ))/
                            check_duration(A1.incept_date,A1.expiry_date);
        END IF;
      END IF;
      v_comp_prem  := A1.prem/v_prorate;
    ELSIF A1.prorate_flag = 2 THEN
       v_comp_prem  :=  A1.prem;
       -- Solve for the annualized premium amount
       /* Three conditions have to be considered for en- *
        * dorsements :  3 indicates that computation     *
        * should be based with respect to the short rate *
        * percent.                                       */
    ELSE
       v_comp_prem :=  A1.prem/(A1.short_rt/100);
       -- Solve for the annualized premium amount

    END IF;
    --v_ann_prem := v_ann_prem + v_comp_prem;
    v_ann_prem := v_ann_prem + NVL(v_comp_prem, 0); -- bonok :: 9.3.2015 :: UCPB 20152
    v_ann_tsi  := v_ann_tsi  + A1.tsi;
  END LOOP;

  p_ann_tsi_amt    := v_ann_tsi;
  p_ann_prem_amt   := v_ann_prem;

  IF v_ann_tsi <> 0 AND v_ann_prem <> 0 THEN
     p_rec_flag := 'C';
  END IF;
END;
/


