DROP PROCEDURE CPI.EXTRACT_ANN_AMT_PACK;

CREATE OR REPLACE PROCEDURE CPI.EXTRACT_ANN_AMT_PACK
(p_item_no      IN      GIPI_WITEM.item_no%TYPE,
 p_line_cd      IN      GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd   IN      GIPI_POLBASIC.subline_cd%TYPE,
 p_iss_cd       IN      GIPI_POLBASIC.iss_cd%TYPE, 
 p_issue_yy     IN      GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no   IN      GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no     IN      GIPI_POLBASIC.renew_no%TYPE,
 p_eff_date     IN      GIPI_POLBASIC.eff_date%TYPE,
 p_expiry_date  IN      GIPI_POLBASIC.expiry_date%TYPE,
 p_ann_tsi_amt  OUT     GIPI_POLBASIC.ann_tsi_amt%TYPE,
 p_ann_prem_amt OUT     GIPI_POLBASIC.ann_prem_amt%TYPE) 

IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : July 26, 2011
**  Reference By : (GIPIS096 - Package Endt PAR Policy Items)
**  Description  : Equivalent to the Program Unit EXTRACT_ANN_AMT_PACK in GIPIS096 module
*/

  v_ann_tsi       GIPI_WITMPERL.ann_tsi_amt%TYPE  := 0;
  v_ann_prem      GIPI_WITMPERL.ann_prem_amt%TYPE := 0; 
  v_comp_prem     GIPI_WITMPERL.ann_prem_amt%TYPE := 0; 
  v_prorate       NUMBER;

BEGIN
  FOR A2 IN
      ( SELECT A.tsi_amt tsi,       A.prem_amt  prem,       
               B.eff_date,          B.endt_expiry_date,    B.expiry_date,
               B.prorate_flag,      NVL(B.comp_sw,'N') comp_sw,
               B.short_rt_percent   short_rt,
               A.peril_cd, c.line_cd
          FROM GIPI_ITMPERIL A,
               GIPI_PACK_POLBASIC B,
               GIPI_POLBASIC C
         WHERE B.line_cd      =  p_line_cd
           AND B.subline_cd   =  p_subline_cd
           AND B.iss_cd       =  p_iss_cd
           AND B.issue_yy     =  p_issue_yy
           AND B.pol_seq_no   =  p_pol_seq_no
           AND B.renew_no     =  p_renew_no
           AND C.pack_policy_id =  B.pack_policy_id
           AND C.policy_id    =  A.policy_id
           AND A.item_no      =  p_item_no
           AND B.pol_flag  IN ('1','2','3') 
         --ASI 081299 add this validation so that data that will be retrieved
         --           is only those from endorsement prior to the current endorsement
         --           this was consider because of the backward endorsement
           AND TRUNC(B.eff_date)    <=  TRUNC(p_eff_date)
           AND NVL(B.endt_expiry_date,B.expiry_date) >= p_eff_date
      ORDER BY      B.eff_date DESC)
       
    LOOP
      
      v_comp_prem := 0;
      
      IF A2.prorate_flag = 1 THEN
         IF A2.endt_expiry_date <= A2.eff_date THEN
            
            RAISE_APPLICATION_ERROR(-20001, 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.');
                      
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
         v_comp_prem  := A2.prem/v_prorate;
      ELSIF A2.prorate_flag = 2 THEN
         v_comp_prem  :=  A2.prem;
      ELSE
         v_comp_prem :=  A2.prem/(A2.short_rt/100);  
      END IF;
      v_ann_prem := v_ann_prem + v_comp_prem;
      FOR TYPE IN
          ( SELECT peril_type
              FROM GIIS_PERIL
             WHERE line_cd = A2.line_cd
               AND peril_cd = A2.peril_cd
          ) LOOP
          IF type.peril_type = 'B' THEN            
             v_ann_tsi  := v_ann_tsi  + A2.tsi;
          END IF;
     END LOOP;
    END LOOP;
       p_ann_tsi_amt    :=  v_ann_tsi;
       p_ann_prem_amt   :=  v_ann_prem;
END;
/


