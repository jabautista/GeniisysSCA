DROP PROCEDURE CPI.EXTRACT_ANN_AMT2;

CREATE OR REPLACE PROCEDURE CPI.EXTRACT_ANN_AMT2(
                                      p_line_cd              GIPI_WPOLBAS.line_cd%TYPE,
                               p_subline_cd              GIPI_WPOLBAS.subline_cd%TYPE,
                               p_iss_cd                  GIPI_WPOLBAS.iss_cd%TYPE,
                               p_issue_yy              GIPI_WPOLBAS.issue_yy%TYPE,
                               p_pol_seq_no              GIPI_WPOLBAS.pol_seq_no%TYPE,
                               p_renew_no              GIPI_WPOLBAS.renew_no%TYPE,
                               p_eff_date              GIPI_WPOLBAS.eff_date%TYPE,
                               v_item                 gipi_witem.item_no%TYPE,
                               v_ann_prem1  IN OUT       gipi_witem.ann_prem_amt%TYPE,
                               v_ann_tsi1   IN OUT       gipi_witem.ann_tsi_amt%TYPE) IS
  v_comp_prem     gipi_witmperl.ann_prem_amt%TYPE := 0; 
  v_prorate       NUMBER;
BEGIN
  v_ann_prem1 := 0;
    v_ann_tsi1 := 0;
  FOR A2 IN
      ( SELECT A.tsi_amt tsi,       A.prem_amt  prem,       
               B.eff_date,          B.endt_expiry_date,    B.expiry_date,
               B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
               B.short_rt_percent   short_rt,
               A.peril_cd
          FROM GIPI_ITMPERIL A,
               GIPI_POLBASIC B
         WHERE B.line_cd      =  p_line_cd
           AND B.subline_cd   =  p_subline_cd
           AND B.iss_cd       =  p_iss_cd
           AND B.issue_yy     =  p_issue_yy
           AND B.pol_seq_no   =  p_pol_seq_no
           AND B.renew_no     =  p_renew_no
           AND B.policy_id    =  A.policy_id
           AND A.item_no      =  v_item
           AND B.pol_flag     in('1','2','3','X') 
           AND TRUNC(NVL(b.endt_expiry_date,b.expiry_date)) >= TRUNC(p_eff_date) 
           AND TRUNC(b.eff_date) <= DECODE(NVL(b.endt_seq_no,0),0,TRUNC(b.eff_date),TRUNC(p_eff_date))  
         ORDER BY      b.eff_date DESC) LOOP
      v_comp_prem := 0;
      IF A2.prorate_flag = 1 THEN
         IF A2.endt_expiry_date <= A2.eff_date THEN NULL;
            --MSG_ALERT('Your endorsement expiry date is equal to or less than your effectivity date.'||
                      --' Restricted condition.','E',TRUE);
         ELSE
            IF A2.comp_sw = 'Y' THEN
               v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) + 1 )/
                              (ADD_MONTHS(A2.eff_date,12) - A2.eff_date);
            ELSIF A2.comp_sw = 'M' THEN
               v_prorate  :=  ((TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date )) - 1 )/
                              (ADD_MONTHS(A2.eff_date,12) - A2.eff_date);
            ELSE 
               v_prorate  :=  (TRUNC( A2.endt_expiry_date) - TRUNC(A2.eff_date ))/
                              (ADD_MONTHS(A2.eff_date,12) - A2.eff_date);
            END IF;
         END IF;
           /*modified by bdarusin, mar072003, to resolve ora01476 divisor is equal to zero*/
           IF TRUNC(A2.eff_date) = TRUNC(A2.endt_expiry_date) THEN
                 v_prorate := 1;
           END IF;      
         v_comp_prem  := A2.prem/v_prorate;
      ELSIF A2.prorate_flag = 2 THEN
         v_comp_prem  :=  A2.prem;
      ELSE
         v_comp_prem :=  A2.prem/(A2.short_rt/100);  
      END IF;
      v_ann_prem1 := v_ann_prem1 + v_comp_prem;
      FOR TYPE IN
          ( SELECT peril_type
              FROM giis_peril
             WHERE line_cd = p_line_cd              
               AND peril_cd = A2.peril_cd
          ) LOOP
          IF type.peril_type = 'B' THEN            
             v_ann_tsi1  := v_ann_tsi1  + A2.tsi;
          END IF;
     END LOOP;
    END LOOP; 
END EXTRACT_ANN_AMT2;
/


