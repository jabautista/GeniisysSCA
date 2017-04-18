DROP PROCEDURE CPI.UPD_BACK_ENDT;

CREATE OR REPLACE PROCEDURE CPI.upd_back_endt(
	   	  		  p_par_id				IN  GIPI_PARLIST.par_id%TYPE,
	   	  		  p_msg_alert			OUT VARCHAR2	  
	   	  		  )
	   IS
  v_eff_date          GIPI_WPOLBAS.eff_date%TYPE;
  v_endt_expiry_date  GIPI_WPOLBAS.eff_date%TYPE;
  v_expiry_date       GIPI_WPOLBAS.eff_date%TYPE;
  v_line_cd           GIPI_WPOLBAS.line_cd%TYPE;
  v_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE;
  v_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE;   
  v_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE;
  v_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE;
  v_renew_no          GIPI_WPOLBAS.renew_no%TYPE;
  v_prorate           GIPI_WITMPERL.prem_rt%TYPE;
  v_comp_prem         GIPI_WITMPERL.tsi_amt%TYPE;
  v_prorate_flag      GIPI_WPOLBAS.prorate_flag%TYPE;
  v_short_rt          GIPI_WPOLBAS.short_rt_percent%TYPE;
  v_comp_sw           GIPI_WPOLBAS.comp_sw%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 31, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : upd_back_endt program unit
  */
  
  FOR eff_dt IN
      ( SELECT eff_date,endt_expiry_date, expiry_date, line_cd, subline_cd, iss_cd, 
               issue_yy, pol_seq_no, renew_no,prorate_flag, short_rt_percent,comp_sw
          FROM GIPI_WPOLBAS
         WHERE par_id = p_par_id
       )LOOP
       v_eff_date := eff_dt.eff_date;
       v_endt_expiry_date := eff_dt.endt_expiry_date;
       v_expiry_date := eff_dt.expiry_date;
       v_line_cd  := eff_dt.line_cd;
       v_subline_cd := eff_dt.subline_cd;
       v_iss_cd := eff_dt.iss_cd;
       v_issue_yy := eff_dt.issue_yy;
       v_pol_seq_no := eff_dt.pol_seq_no;
       v_renew_no := eff_dt.renew_no;
       v_prorate_flag := eff_dt.prorate_flag;
       v_comp_sw  := eff_dt.comp_sw;
       v_short_rt := eff_dt.short_rt_percent;
       EXIT;
  END LOOP;   
  FOR itmperl IN
      ( SELECT b480.item_no,  b480.currency_rt, a170.peril_type,
               b490.peril_cd, b490.tsi_amt, b490.prem_amt
          FROM GIPI_WITEM b480, GIPI_WITMPERL b490, GIIS_PERIL a170
         WHERE b480.par_id = b490.par_id
           AND b480.item_no =b490.item_no
           AND b490.line_cd = a170.line_cd
           AND b490.peril_cd = a170.peril_cd
           AND b490.par_id = p_par_id
      )LOOP
        v_comp_prem := NULL;
        IF v_prorate_flag = 1 THEN
           IF v_endt_expiry_date <= v_eff_date THEN
              p_MSG_ALERT := 'Your endorsement expiry date is equal to or less than your effectivity date.'||
                        ' Restricted condition.';
           ELSE
              IF v_comp_sw = 'Y' THEN
                 v_prorate  :=  ((TRUNC( v_endt_expiry_date) - TRUNC(v_eff_date )) + 1 )/
                                (ADD_MONTHS(v_eff_date,12) - v_eff_date);
              ELSIF v_comp_sw = 'M' THEN
                 v_prorate  :=  ((TRUNC( v_endt_expiry_date) - TRUNC(v_eff_date )) - 1 )/
                                (ADD_MONTHS(v_eff_date,12) - v_eff_date);
              ELSE 
                 v_prorate  :=  (TRUNC( v_endt_expiry_date) - TRUNC(v_eff_date ))/
                             (ADD_MONTHS(v_eff_date,12) - v_eff_date);
              END IF;
           END IF;
           v_comp_prem  := itmperl.prem_amt/v_prorate;
        ELSIF v_prorate_flag = 2 THEN
           v_comp_prem  := itmperl.prem_amt;
        ELSE
           v_comp_prem :=  itmperl.prem_amt/(v_short_rt/100);  
        END IF;
      FOR A1 IN
          ( SELECT policy_id
              FROM GIPI_POLBASIC b250
             WHERE b250.line_cd = v_line_cd
               AND b250.subline_cd = v_subline_cd
               AND b250.iss_cd = v_iss_cd
               AND b250.issue_yy = v_issue_yy
               AND b250.pol_seq_no = v_pol_seq_no
               AND b250.renew_no = v_renew_no
               AND b250.eff_date > v_eff_date
               AND b250.endt_seq_no > 0	
               AND b250.pol_flag IN('1','2','3')	 
               AND NVL(b250.endt_expiry_date,b250.expiry_date) >=  v_eff_date
          )LOOP
          FOR PERL IN 
              ( SELECT '1'
                  FROM GIPI_ITMPERIL b380
                 WHERE b380.item_no = itmperl.item_no
                   AND b380.peril_cd = itmperl.peril_cd  
                   AND b380.policy_id = a1.policy_id
               ) LOOP
               UPDATE GIPI_ITMPERIL
                  SET ann_tsi_amt  = ann_tsi_amt + itmperl.tsi_amt,
                      ann_prem_amt = ann_prem_amt + NVL(v_comp_prem,itmperl.prem_amt)
                WHERE policy_id = a1.policy_id
                  AND item_no = itmperl.item_no
                  AND peril_cd = itmperl.peril_cd;
          END LOOP;
          IF itmperl.peril_type = 'B' THEN
             UPDATE GIPI_ITEM
                SET ann_tsi_amt  = ann_tsi_amt + itmperl.tsi_amt,
                    ann_prem_amt = ann_prem_amt + NVL(v_comp_prem,itmperl.prem_amt)
              WHERE policy_id = a1.policy_id
                AND item_no = itmperl.item_no;
             UPDATE GIPI_POLBASIC
                SET ann_tsi_amt  = ann_tsi_amt + ROUND((itmperl.tsi_amt * NVL(itmperl.currency_rt,1)),2),
                    ann_prem_amt = ann_prem_amt + ROUND((NVL(v_comp_prem,itmperl.prem_amt) * NVL(itmperl.currency_rt,1)),2)
              WHERE policy_id = a1.policy_id;
          ELSE
             UPDATE GIPI_ITEM
                SET ann_prem_amt = ann_prem_amt + NVL(v_comp_prem,itmperl.prem_amt)
              WHERE policy_id = a1.policy_id
                AND item_no = itmperl.item_no;
             UPDATE GIPI_POLBASIC
                SET ann_prem_amt = ann_prem_amt + ROUND((NVL(v_comp_prem,itmperl.prem_amt) * NVL(itmperl.currency_rt,1)),2)
              WHERE policy_id = a1.policy_id;
          END IF;
      END LOOP;
  END LOOP;      


END;
/


