DROP PROCEDURE CPI.DEFERRED_EXTRACT365_DTL;

CREATE OR REPLACE PROCEDURE CPI.deferred_extract365_dtl (
   p_ext_year   NUMBER,
   p_ext_mm     NUMBER,
   p_year       NUMBER,
   p_mm         NUMBER,
   p_method     NUMBER
)
IS
   v_mm_year         VARCHAR2 (7);
   v_mm_year_mn1     VARCHAR2 (7);
   v_mm_year_mn2     VARCHAR2 (7);
   v_num_factor      NUMBER (4);
   v_num_factor2     NUMBER (4);
   v_den_factor      NUMBER (4);
   v_pol_term        NUMBER (4);
   v_earned_days     NUMBER (4);
   v_unearned_days   NUMBER (4);
   v_def_prem        NUMBER (16, 2);
   v_iss_cd_ri       VARCHAR2(2):= giisp.v ('ISS_CD_RI'); 
   v_iss_cd_rv       VARCHAR2(2):= giisp.v ('ISS_CD_RV');  
   v_start_date      DATE := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   v_mm_year3     DATE;
   v_mm_year4     DATE;
   v_booked_expired  VARCHAR2(1); --mikel 02.25.2013

   --v_def_comm_prod   VARCHAR2(1) := NVL(Giacp.v('DEF_COMM_PROD_ENTRY'),'N');
/*
** Created by:   Mikel
** Date Created: 08.28.2012
** Description:  Extracts detailed data required for the daily computation of 1/365 Method
*/
BEGIN
   
   --v_paramdate     := Giacp.v('24TH_METHOD_PARAMDATE');
   v_mm_year := LPAD (TO_CHAR (p_mm), 2, '0') || '-' || TO_CHAR (p_year);
   v_mm_year_mn1 := TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_ext_mm), 2, '0') || '-' || TO_CHAR (p_ext_year), 'MM-YYYY') - 1, 'MM') || '-'|| 
                    TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_ext_mm), 2, '0') || '-' || TO_CHAR (p_ext_year), 'MM-YYYY') - 1, 'YYYY');
   v_mm_year_mn2 := LPAD (TO_CHAR (p_ext_mm), 2, '0') || '-' || TO_CHAR (p_ext_year);
   v_mm_year3 := LAST_DAY(TO_DATE (   LPAD (TO_CHAR (p_ext_mm), 2, '0') || '-' || TO_CHAR (p_ext_year), 'MM-YYYY'));
   v_mm_year4 := TO_DATE (   LPAD (TO_CHAR (p_ext_mm), 2, '0') || '-' || TO_CHAR (p_ext_year), 'mm-yyyy');

   --GROSS PREMIUMS
   FOR gross IN
      (SELECT   NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd,
                get_policy_no (b.policy_id) policy_no,
                TRUNC (b.eff_date) eff_date,
                TRUNC (NVL (b.endt_expiry_date, b.expiry_date)) expiry_date, a.acct_ent_date,
                SUM (  DECODE (TO_CHAR (b.spld_acct_ent_date, 'MM-YYYY'), v_mm_year, -1, 1) * a.prem_amt * a.currency_rt) premium
           FROM gipi_invoice a, gipi_polbasic b
          WHERE a.policy_id = b.policy_id
            AND DECODE (v_start_date, NULL, SYSDATE, b.acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date) --mikel 01.14.2013; --mikel 01.29.2013; comment out
            --AND TRUNC (b.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.14.2013                                   
            /*AND TRUNC (b.eff_date) BETWEEN ADD_MONTHS (TO_DATE (   p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -11)
                                       --AND LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
                                       AND LAST_DAY (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'))*/
            AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') = v_mm_year
                 OR TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') = v_mm_year)
            AND b.reg_policy_sw = 'Y'
            --AND b.expiry_date IS NOT NULL --jm test
       GROUP BY NVL (b.cred_branch, a.iss_cd), b.line_cd, b.policy_id,
                b.eff_date, b.endt_expiry_date, b.expiry_date, a.acct_ent_date)
   LOOP
       
--      IF gross.eff_date > gross.expiry_date THEN
--        RAISE_APPLICATION_ERROR (-20001, 'Effectivity date is greater than the expiry date.');
--      END IF;
        
      /*v_pol_term := (gross.expiry_date + 1) - gross.eff_date;
      v_earned_days := (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1) - gross.eff_date;*/
      
      v_booked_expired := 'Y'; --mikel 03.04.2013
      /* 
      ** mikel 03.04.2013
      ** the denominator should be total number of days minus 1 day 
      ** and for the numerator  is minus 1 on the last month of the policy term.
      */
      
      v_pol_term := gross.expiry_date - gross.eff_date;
      IF LAST_DAY(gross.expiry_date) = v_mm_year3 THEN
        v_earned_days := LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) - gross.eff_date;
      ELSE
        v_earned_days := (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1) - gross.eff_date; 
      END IF; --mikel 03.04.2013
        
      IF gross.eff_date > LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) THEN
        v_earned_days := 0;
      END IF;
       
      IF v_earned_days > v_pol_term THEN
         v_earned_days := v_pol_term;
      END IF;
      
      v_unearned_days := v_pol_term - (v_earned_days);
      v_num_factor    := v_unearned_days;  
      v_num_factor2   := v_earned_days;
      v_den_factor    := v_pol_term;     
      
      
      -- mikel 02.08.2013; do not include expired policies
      IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) < v_mm_year3 THEN
        IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) >= LAST_DAY(TRUNC(gross.expiry_date)) THEN
            gross.premium := 0;
        END IF;
      END IF;
      
      --mikel 03.04.2013; do not include expired policies
      IF LAST_DAY(gross.expiry_date) < v_mm_year3 THEN
        IF LAST_DAY(gross.acct_ent_date) <= LAST_DAY(gross.expiry_date) THEN
            v_booked_expired := 'N';    
        END IF;
      END IF;
            
      --IF LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year, 'MM-YYYY')) <= LAST_DAY(TRUNC(gross.expiry_date)) THEN --mikel 02.06.2013; do not include expired policies
        IF gross.premium <> 0 AND v_booked_expired = 'Y' THEN --mikel 02.06.2013; do not include zero premium
          UPDATE giac_deferred_gross_prem_pol gprem_pol
             SET gprem_pol.prem_amt = gprem_pol.prem_amt + gross.premium
           WHERE gprem_pol.extract_year = p_ext_year
             AND gprem_pol.extract_mm = p_ext_mm
             AND gprem_pol.procedure_id = p_method
             AND gprem_pol.iss_cd = gross.iss_cd
             AND gprem_pol.line_cd = gross.line_cd
             AND gprem_pol.policy_no = gross.policy_no;

          IF SQL%NOTFOUND
          THEN          
             INSERT INTO giac_deferred_gross_prem_pol
                         (extract_year, extract_mm, procedure_id, iss_cd, line_cd,
                          policy_no, prem_amt, eff_date, expiry_date, numerator_factor,
                          denominator_factor, def_prem_amt, user_id, last_update
                         )
                  VALUES (p_ext_year, p_ext_mm, p_method, gross.iss_cd, gross.line_cd,
                          gross.policy_no, gross.premium, gross.eff_date, gross.expiry_date, v_num_factor,
                          v_den_factor, v_def_prem, USER, SYSDATE
                         );            
          END IF;
        END IF;  
      --END IF;   
   END LOOP;
   
   --RI PREMIUMS CEDED
   --Treaty
   --Premiuims 
   FOR trty_prem IN
       (SELECT   NVL (b.cred_branch, b.iss_cd) iss_cd, a.line_cd,
             get_policy_no (b.policy_id) policy_no, TRUNC (b.eff_date) eff_date,
             TRUNC (NVL (b.endt_expiry_date, b.expiry_date)) expiry_date,
             SUM (NVL (a.premium_amt, 0)) dist_prem,
             NVL (c.acct_trty_type, 0) acct_trty_type, a.acct_ent_date
        FROM giac_treaty_cessions a, gipi_polbasic b, giis_dist_share c
       WHERE a.policy_id = b.policy_id
         AND a.cession_year = p_year
         AND a.cession_mm = p_mm
         AND a.line_cd = c.line_cd
         AND a.share_cd = c.share_cd
         AND DECODE (v_start_date, NULL, SYSDATE, LAST_DAY (TO_DATE (a.cession_mm || '-' || a.cession_year, 'MM-YYYY'))) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date) --mikel 01.14.2013
         --AND TRUNC (b.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) c --mikel 01.29.2013; comment out
         AND b.reg_policy_sw = 'Y'
         --AND b.expiry_date IS NOT NULL --jm test
    GROUP BY NVL (b.cred_branch, b.iss_cd), b.policy_id,
             b.eff_date, b.expiry_date, b.endt_expiry_date,
             a.line_cd, c.acct_trty_type, a.acct_ent_date)
   LOOP
      /*v_pol_term := (trty_prem.expiry_date + 1) - trty_prem.eff_date;
      v_earned_days := (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1) - trty_prem.eff_date;*/
      
      v_booked_expired := 'Y'; --mikel 03.04.2013
      /* 
      ** mikel 03.04.2013
      ** the denominator should be total number of days minus 1 day 
      ** and for the numerator  is minus 1 on the last month of the policy term.
      */
      
      v_pol_term := trty_prem.expiry_date - trty_prem.eff_date; --mikel 03.04.2013
      IF LAST_DAY(trty_prem.expiry_date) = v_mm_year3 THEN
        v_earned_days := LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) - trty_prem.eff_date;
      ELSE
        v_earned_days := (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1) - trty_prem.eff_date; 
      END IF; --mikel 03.04.2013
      
      IF trty_prem.eff_date > LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) THEN
        v_earned_days := 0;
      END IF;
      
      IF v_earned_days > v_pol_term THEN
         v_earned_days := v_pol_term;
      END IF;
      
      v_unearned_days := v_pol_term - (v_earned_days);
      v_num_factor    := v_unearned_days;  
      v_num_factor2   := v_earned_days;
      v_den_factor    := v_pol_term;     
      
          -- mikel 02.08.2013; do not include expired policies
          IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) < v_mm_year3 THEN
            IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) >= LAST_DAY(TRUNC(trty_prem.expiry_date)) THEN
                trty_prem.dist_prem := 0;
            END IF;
          END IF;
          
      --mikel 03.04.2013; do not include expired policies
      IF LAST_DAY(trty_prem.expiry_date) < v_mm_year3 THEN
        IF LAST_DAY(trty_prem.acct_ent_date) <= LAST_DAY(trty_prem.expiry_date) THEN
            v_booked_expired := 'N';    
        END IF;
      END IF;

      --IF LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year, 'MM-YYYY')) <= LAST_DAY(TRUNC(trty_prem.expiry_date)) THEN --mikel 02.06.2013; do not include expired policies
        IF trty_prem.dist_prem <> 0 AND v_booked_expired = 'Y' THEN --mikel 02.06.2013; do not include zero premium
          UPDATE giac_deferred_ri_prem_cede_pol griprem_pol
             SET griprem_pol.dist_prem = griprem_pol.dist_prem + trty_prem.dist_prem
           WHERE griprem_pol.extract_year = p_ext_year
             AND griprem_pol.extract_mm = p_ext_mm
             AND griprem_pol.procedure_id = p_method
             AND griprem_pol.iss_cd = trty_prem.iss_cd
             AND griprem_pol.line_cd = trty_prem.line_cd
             AND griprem_pol.policy_no = trty_prem.policy_no
             AND griprem_pol.share_type = '2'
             AND griprem_pol.acct_trty_type = trty_prem.acct_trty_type;

          IF SQL%NOTFOUND
          THEN          
             INSERT INTO giac_deferred_ri_prem_cede_pol
                         (extract_year, extract_mm, procedure_id, iss_cd, line_cd,
                          share_type, acct_trty_type, policy_no, 
                          dist_prem, eff_date, expiry_date, numerator_factor,
                          denominator_factor, def_dist_prem, user_id, last_update
                         )
                  VALUES (p_ext_year, p_ext_mm, p_method, trty_prem.iss_cd, trty_prem.line_cd,
                          '2', trty_prem.acct_trty_type, trty_prem.policy_no, 
                          trty_prem.dist_prem, trty_prem.eff_date, trty_prem.expiry_date, v_num_factor,
                          v_den_factor, v_def_prem, USER, SYSDATE
                         );            
          END IF;
        END IF; 
      --END IF;
   END LOOP;           
   
   --Commission Income - Treaty
   FOR trty_ri_comm IN
        (SELECT   NVL (b.cred_branch, b.iss_cd) iss_cd, a.line_cd,
                 get_policy_no (b.policy_id) policy_no, TRUNC (b.eff_date) eff_date,
                 TRUNC (NVL (b.endt_expiry_date, b.expiry_date)) expiry_date,
                 SUM (NVL (a.commission_amt, 0)) commission,
                 NVL (c.acct_trty_type, 0) acct_trty_type, a.ri_cd, a.acct_ent_date
            FROM giac_treaty_cessions a, gipi_polbasic b, giis_dist_share c
           WHERE a.policy_id = b.policy_id
             AND a.cession_year = p_year
             AND a.cession_mm = p_mm
             AND a.line_cd = c.line_cd
             AND a.share_cd = c.share_cd
             AND DECODE (v_start_date, NULL, SYSDATE, LAST_DAY (TO_DATE (a.cession_mm || '-' || a.cession_year, 'MM-YYYY'))) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date) --mikel 01.14.2013
             --AND TRUNC (b.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.29.2013; comment out
             AND b.reg_policy_sw = 'Y'
             --AND b.expiry_date IS NOT NULL --jm test
        GROUP BY NVL (b.cred_branch, b.iss_cd), a.line_cd, b.policy_id,
                 b.eff_date, b.expiry_date, b.endt_expiry_date, c.acct_trty_type, 
                 a.ri_cd, a.acct_ent_date)
   LOOP
      --v_pol_term := (trty_ri_comm.expiry_date + 1) - trty_ri_comm.eff_date;
      --v_earned_days := (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1) - trty_ri_comm.eff_date;
      
      v_booked_expired := 'Y'; --mikel 03.04.2013
      /* 
      ** mikel 03.04.2013
      ** the denominator should be total number of days minus 1 day 
      ** and for the numerator  is minus 1 on the last month of the policy term.
      */
      v_pol_term := trty_ri_comm.expiry_date - trty_ri_comm.eff_date;
      
         IF LAST_DAY(trty_ri_comm.expiry_date) > v_mm_year3 THEN
            IF trty_ri_comm.eff_date < v_mm_year4 THEN
                v_earned_days := (v_mm_year3 - v_mm_year4) + 1;
            ELSIF trty_ri_comm.eff_date >= v_mm_year4 THEN
                v_earned_days := (v_mm_year3 - trty_ri_comm.eff_date) + 1;
            END IF;
         ELSIF LAST_DAY(trty_ri_comm.expiry_date) < v_mm_year3 THEN
            v_earned_days := 0;
         ELSIF LAST_DAY(trty_ri_comm.expiry_date) = v_mm_year3 THEN
            IF trty_ri_comm.eff_date < v_mm_year4 THEN
                --v_earned_days := (trty_ri_comm.expiry_date - v_mm_year4) + 1;
                v_earned_days := (trty_ri_comm.expiry_date - v_mm_year4); --mikel 03.04.2013
            ELSIF trty_ri_comm.eff_date >= v_mm_year4 THEN
                --v_earned_days := (trty_ri_comm.expiry_date - trty_ri_comm.eff_date) + 1;
                v_earned_days := (trty_ri_comm.expiry_date - trty_ri_comm.eff_date); --mikel 03.04.2013      
            END IF;               
         END IF; --mikel 01.22.2013; per month ang computation ng earned
      
      IF trty_ri_comm.eff_date > LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) THEN
        v_earned_days := 0;
      END IF;
      
      IF v_earned_days > v_pol_term THEN
         v_earned_days := v_pol_term;
      END IF;
      
      v_unearned_days := v_pol_term - (v_earned_days);
      
      v_num_factor   := v_earned_days;     
      
      v_den_factor    := v_pol_term;   
      
      -- mikel 02.08.2013; do not include expired policies
          IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) < v_mm_year3 THEN
            IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) >= LAST_DAY(TRUNC(trty_ri_comm.expiry_date)) THEN
                trty_ri_comm.commission := 0;
            END IF;
          END IF;  
          
      --mikel 03.04.2013; do not include expired policies
      IF LAST_DAY(trty_ri_comm.expiry_date) < v_mm_year3 THEN
        IF LAST_DAY(trty_ri_comm.acct_ent_date) <= LAST_DAY(trty_ri_comm.expiry_date) THEN
            v_booked_expired := 'N';    
        END IF;
      END IF;

      --IF LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year, 'MM-YYYY')) <= LAST_DAY(TRUNC(trty_ri_comm.expiry_date)) THEN --mikel 02.06.2013; do not include expired policies
        IF trty_ri_comm.commission <> 0 AND v_booked_expired = 'Y' THEN --mikel 02.06.2013; do not include zero commission income
          UPDATE giac_deferred_comm_income_pol gricomm_pol
             SET gricomm_pol.comm_income = gricomm_pol.comm_income + trty_ri_comm.commission
           WHERE gricomm_pol.extract_year = p_ext_year
             AND gricomm_pol.extract_mm = p_ext_mm
             AND gricomm_pol.procedure_id = p_method
             AND gricomm_pol.iss_cd = trty_ri_comm.iss_cd
             AND gricomm_pol.line_cd = trty_ri_comm.line_cd
             AND gricomm_pol.policy_no = trty_ri_comm.policy_no
             AND gricomm_pol.share_type = '2'
             AND gricomm_pol.acct_trty_type = trty_ri_comm.acct_trty_type
             AND gricomm_pol.ri_cd = trty_ri_comm.ri_cd;

          IF SQL%NOTFOUND
          THEN          
             INSERT INTO giac_deferred_comm_income_pol
                         (extract_year, extract_mm, procedure_id, iss_cd, line_cd,
                          share_type, acct_trty_type, policy_no, ri_cd,
                          comm_income, eff_date, expiry_date, numerator_factor,
                          denominator_factor, def_comm_income, user_id, last_update
                         )
                  VALUES (p_ext_year, p_ext_mm, p_method, trty_ri_comm.iss_cd, trty_ri_comm.line_cd,
                          '2', trty_ri_comm.acct_trty_type, trty_ri_comm.policy_no, trty_ri_comm.ri_cd,
                          trty_ri_comm.commission, trty_ri_comm.eff_date, trty_ri_comm.expiry_date, v_num_factor,
                          v_den_factor, v_def_prem, USER, SYSDATE
                         );            
          END IF;
        END IF;  
      --END IF;   
   END LOOP;
                 
   -- Facultative
   --Premiums
   FOR facul_prem IN
         (SELECT   NVL (e.cred_branch, e.iss_cd) iss_cd, a.line_cd,
                 get_policy_no (e.policy_id) policy_no, TRUNC (e.eff_date) eff_date,
                 TRUNC (NVL (e.endt_expiry_date, e.expiry_date)) expiry_date, a.acc_ent_date,
                 SUM (  DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'), v_mm_year, -1, 1) * a.ri_prem_amt * c.currency_rt) premium
            FROM giri_binder a,
                 giri_frps_ri b,
                 giri_distfrps c,
                 giuw_pol_dist d,
                 gipi_polbasic e
           WHERE a.fnl_binder_id = b.fnl_binder_id
             AND b.line_cd = c.line_cd
             AND b.frps_yy = c.frps_yy
             AND b.frps_seq_no = c.frps_seq_no
             AND c.dist_no = d.dist_no
             AND d.policy_id = e.policy_id
             AND DECODE (v_start_date, NULL, SYSDATE, a.acc_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date) --mikel 01.14.2013
             AND a.acc_ent_date = LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
             AND d.acct_ent_date <= LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
             --AND TRUNC (e.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.29.2013; comment out
             AND e.reg_policy_sw = 'Y'
        GROUP BY NVL (e.cred_branch, e.iss_cd), a.line_cd, e.policy_id,
                 e.eff_date, e.expiry_date, e.endt_expiry_date, a.acc_ent_date
        UNION
        SELECT   NVL (e.cred_branch, e.iss_cd) iss_cd, a.line_cd,
                 get_policy_no (e.policy_id) policy_no, TRUNC (e.eff_date) eff_date,
                 TRUNC (NVL (e.endt_expiry_date, e.expiry_date)) expiry_date, a.acc_rev_date acc_ent_date,
                 SUM (  DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'), v_mm_year, -1, 1) * a.ri_prem_amt * c.currency_rt) premium
            FROM giri_binder a,
                 giri_frps_ri b,
                 giri_distfrps c,
                 giuw_pol_dist d,
                 gipi_polbasic e
           WHERE a.fnl_binder_id = b.fnl_binder_id
             AND b.line_cd = c.line_cd
             AND b.frps_yy = c.frps_yy
             AND b.frps_seq_no = c.frps_seq_no
             AND c.dist_no = d.dist_no
             AND d.policy_id = e.policy_id
             AND DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date) --mikel 01.14.2013
             AND a.acc_rev_date = LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
             AND (   (d.dist_flag = '3' AND b.reverse_sw = 'Y')
                  OR (    d.dist_flag = '4' AND TO_CHAR (d.acct_neg_date, 'MM-YYYY') = v_mm_year)
                 )
             --AND TRUNC (e.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.29.2013; comment out
             AND e.reg_policy_sw = 'Y'
             --AND e.expiry_date IS NOT NULL --jm test
        GROUP BY NVL (e.cred_branch, e.iss_cd), a.line_cd, e.policy_id,
                 e.eff_date, e.expiry_date, e.endt_expiry_date, a.acc_rev_date)
   LOOP
   
      /*v_pol_term := (facul_prem.expiry_date + 1) - facul_prem.eff_date;
      v_earned_days := (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1) - facul_prem.eff_date;*/
      
      v_booked_expired := 'Y'; --mikel 03.04.2013
      /* 
      ** mikel 03.04.2013
      ** the denominator should be total number of days minus 1 day 
      ** and for the numerator  is minus 1 on the last month of the policy term.
      */
      
      v_pol_term := facul_prem.expiry_date - facul_prem.eff_date;
      IF LAST_DAY(facul_prem.expiry_date) = v_mm_year3 THEN
        v_earned_days := LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) - facul_prem.eff_date;
      ELSE
        v_earned_days := (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1) - facul_prem.eff_date; 
      END IF; --mikel 03.04.2013
      
      IF facul_prem.eff_date > LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) THEN
        v_earned_days := 0;
      END IF;
      
      IF v_earned_days > v_pol_term THEN
         v_earned_days := v_pol_term;
      END IF;
      
      v_unearned_days := v_pol_term - (v_earned_days);
      v_num_factor    := v_unearned_days;  
      v_num_factor2   := v_earned_days;
      v_den_factor    := v_pol_term;   
      
      -- mikel 02.08.2013; do not include expired policies
          IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) < v_mm_year3 THEN
            IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) >= LAST_DAY(TRUNC(facul_prem.expiry_date)) THEN
                facul_prem.premium := 0;
            END IF;
          END IF;   
          
      --mikel 03.04.2013; do not include expired policies
      IF LAST_DAY(facul_prem.expiry_date) < v_mm_year3 THEN
        IF LAST_DAY(facul_prem.acc_ent_date) <= LAST_DAY(facul_prem.expiry_date) THEN
            v_booked_expired := 'N';    
        END IF;
      END IF;          
      
      --IF LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year, 'MM-YYYY')) <= LAST_DAY(TRUNC(facul_prem.expiry_date)) THEN --mikel 02.06.2013; do not include expired policies
        IF facul_prem.premium <> 0 AND v_booked_expired = 'Y' THEN --mikel 02.06.2013; do not include zero premium
        UPDATE giac_deferred_ri_prem_cede_pol gfacprem_pol
            SET gfacprem_pol.dist_prem = gfacprem_pol.dist_prem + facul_prem.premium
          WHERE gfacprem_pol.extract_year = p_ext_year
            AND gfacprem_pol.extract_mm = p_ext_mm
            AND gfacprem_pol.iss_cd = facul_prem.iss_cd
            AND gfacprem_pol.line_cd = facul_prem.line_cd
            AND gfacprem_pol.procedure_id = p_method
            AND gfacprem_pol.policy_no = facul_prem.policy_no
            AND gfacprem_pol.share_type = '3'
            AND gfacprem_pol.acct_trty_type = 0;

         IF SQL%NOTFOUND
         THEN
            INSERT INTO giac_deferred_ri_prem_cede_pol
                     (extract_year, extract_mm, procedure_id, iss_cd, line_cd,
                      share_type, policy_no, 
                      dist_prem, eff_date, expiry_date, numerator_factor,
                      denominator_factor, def_dist_prem, user_id, last_update
                     )
              VALUES (p_ext_year, p_ext_mm, p_method, facul_prem.iss_cd, facul_prem.line_cd,
                      '3', facul_prem.policy_no, 
                      facul_prem.premium, facul_prem.eff_date, facul_prem.expiry_date, v_num_factor,
                      v_den_factor, v_def_prem, USER, SYSDATE
                     );  
         END IF;
        END IF;  
      --END IF;
   END LOOP;   
   
   --Commission Income - Facultative
   FOR facul_ri_comm IN
        (SELECT   NVL (e.cred_branch, e.iss_cd) iss_cd, a.line_cd,
                 get_policy_no (e.policy_id) policy_no, TRUNC (e.eff_date) eff_date,
                 TRUNC (NVL (e.endt_expiry_date, e.expiry_date)) expiry_date, a.ri_cd,
                 SUM (NVL (  DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'),v_mm_year, -1, 1) * a.ri_comm_amt * c.currency_rt, 0)) commission
                 ,a.acc_ent_date, a.acc_rev_date aed2, d.acct_ent_date ead3 --mikel 02.04.2013
                 ,'N' reverse_sw --mikel 03.04.2013
            FROM giri_binder a,
                 giri_frps_ri b,
                 giri_distfrps c,
                 giuw_pol_dist d,
                 gipi_polbasic e
           WHERE a.fnl_binder_id = b.fnl_binder_id
             AND b.line_cd = c.line_cd
             AND b.frps_yy = c.frps_yy
             AND b.frps_seq_no = c.frps_seq_no
             AND c.dist_no = d.dist_no
             AND d.policy_id = e.policy_id
             AND DECODE (v_start_date, NULL, SYSDATE, a.acc_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date) --mikel 01.14.2013
             AND a.acc_ent_date = LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
             AND d.acct_ent_date <= LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
             --AND TRUNC (e.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.29.2013; comment out
             AND e.reg_policy_sw = 'Y'
             --AND e.expiry_date IS NOT NULL --jm test
        GROUP BY NVL (e.cred_branch, e.iss_cd), a.line_cd, a.ri_cd, e.policy_id,
                 e.eff_date, e.expiry_date, e.endt_expiry_date, a.acc_ent_date, a.acc_rev_date , d.acct_ent_date --mikel 02.04.2013
        UNION
        SELECT   NVL (e.cred_branch, e.iss_cd) iss_cd, a.line_cd,
                 get_policy_no (e.policy_id) policy_no, TRUNC (e.eff_date) eff_date,
                 TRUNC (NVL (e.endt_expiry_date, e.expiry_date)) expiry_date, a.ri_cd,
                 SUM (NVL (  DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'), v_mm_year, -1, 1) * a.ri_comm_amt * c.currency_rt, 0)) commission
                 ,a.acc_ent_date, a.acc_rev_date aed2, d.acct_ent_date ead3 --mikel 02.04.2013
                 ,'Y' reverse_sw --mikel 03.04.2013
            FROM giri_binder a,
                 giri_frps_ri b,
                 giri_distfrps c,
                 giuw_pol_dist d,
                 gipi_polbasic e
           WHERE a.fnl_binder_id = b.fnl_binder_id
             AND b.line_cd = c.line_cd
             AND b.frps_yy = c.frps_yy
             AND b.frps_seq_no = c.frps_seq_no
             AND c.dist_no = d.dist_no
             AND d.policy_id = e.policy_id
             AND DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date) --mikel 01.14.2013
             AND a.acc_rev_date = LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
             AND (   (d.dist_flag = '3' AND b.reverse_sw = 'Y')
                  OR (    d.dist_flag = '4' AND TO_CHAR (d.acct_neg_date, 'MM-YYYY') = v_mm_year)
                 )
             --AND TRUNC (e.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.29.2013; comment out
             AND e.reg_policy_sw = 'Y'
                GROUP BY NVL (e.cred_branch, e.iss_cd), a.line_cd, a.ri_cd, e.policy_id,
                 e.eff_date, e.expiry_date, e.endt_expiry_date,a.acc_ent_date, a.acc_rev_date , d.acct_ent_date) --mikel 02.04.2013
   LOOP
   
          /*v_pol_term := (facul_ri_comm.expiry_date + 1) - facul_ri_comm.eff_date;
          v_earned_days := (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1) - facul_ri_comm.eff_date;*/
          
         v_booked_expired := 'Y'; --mikel 03.04.2013
         /* 
         ** mikel 03.04.2013
         ** the denominator should be total number of days minus 1 day 
         ** and for the numerator  is minus 1 on the last month of the policy term.
         */  
          
         v_pol_term := facul_ri_comm.expiry_date - facul_ri_comm.eff_date; --mikel 03.04.2013  
         
         IF LAST_DAY(facul_ri_comm.expiry_date) > v_mm_year3 THEN
            IF facul_ri_comm.eff_date < v_mm_year4 THEN
                v_earned_days := (v_mm_year3 - v_mm_year4) + 1;
            ELSIF facul_ri_comm.eff_date >= v_mm_year4 THEN
                v_earned_days := (v_mm_year3 - facul_ri_comm.eff_date) + 1;
            END IF;
         ELSIF LAST_DAY(facul_ri_comm.expiry_date) < v_mm_year3 THEN
            v_earned_days := 0;
         ELSIF LAST_DAY(facul_ri_comm.expiry_date) = v_mm_year3 THEN
            IF facul_ri_comm.eff_date < v_mm_year4 THEN
                --v_earned_days := (facul_ri_comm.expiry_date - v_mm_year4) + 1;
                v_earned_days := (facul_ri_comm.expiry_date - v_mm_year4); --mikel 03.04.2013
            ELSIF facul_ri_comm.eff_date >= v_mm_year4 THEN
                --v_earned_days := (facul_ri_comm.expiry_date - facul_ri_comm.eff_date) + 1;      
                v_earned_days := (facul_ri_comm.expiry_date - facul_ri_comm.eff_date); --mikel 03.04.2013
            END IF;               
         END IF; --mikel 01.22.2013; per month ang computation ng earned     
         
         -- mikel 02.04.2013; for late booking, 1st month computation will be based on extract date less effectivity date 
          IF (v_mm_year3 = LAST_DAY(facul_ri_comm.acc_ent_date)
              OR v_mm_year3 = LAST_DAY(facul_ri_comm.aed2)) THEN
              IF (TO_DATE(TO_CHAR(TO_DATE(facul_ri_comm.acc_ent_date), 'MM-YYYY'), 'MM-YYYY') > facul_ri_comm.eff_date  
                  OR TO_DATE(TO_CHAR(TO_DATE(facul_ri_comm.aed2), 'MM-YYYY'), 'MM-YYYY') > facul_ri_comm.eff_date) THEN
                    IF  LAST_DAY(facul_ri_comm.expiry_date) >= v_mm_year3 THEN 
                        v_earned_days := (v_mm_year3 - facul_ri_comm.eff_date) + 1;
                    ELSE
                        v_earned_days := (facul_ri_comm.expiry_date - facul_ri_comm.eff_date) + 1;
                    END IF;
                    
                    IF v_earned_days > v_pol_term THEN
                        v_earned_days := v_pol_term;
                    END IF;
              END IF;
          END IF;
          
          IF facul_ri_comm.eff_date > LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) THEN
            v_earned_days := 0;
          END IF;
          
          v_unearned_days := v_pol_term - (v_earned_days);     
          v_num_factor   := v_earned_days;
          v_den_factor    := v_pol_term;
          
          -- mikel 02.08.2013; do not include expired policies
          IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) < v_mm_year3 THEN
            IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) >= LAST_DAY(TRUNC(facul_ri_comm.expiry_date)) THEN
                facul_ri_comm.commission := 0;
            END IF;
          END IF; 
      
      --mikel 03.04.2013; do not include expired policies
      IF LAST_DAY(facul_ri_comm.expiry_date) < v_mm_year3 THEN
        IF (LAST_DAY(facul_ri_comm.acc_ent_date) <= LAST_DAY(facul_ri_comm.expiry_date) AND facul_ri_comm.reverse_sw = 'N'
            OR LAST_DAY(facul_ri_comm.aed2) <= LAST_DAY(facul_ri_comm.expiry_date) AND facul_ri_comm.reverse_sw = 'Y') THEN
            v_booked_expired := 'N';
        END IF;
      END IF;
      
        --IF LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year, 'MM-YYYY')) <= LAST_DAY(TRUNC(facul_ri_comm.expiry_date)) THEN --mikel 02.06.2013; do not include expired policies
            IF facul_ri_comm.commission <> 0 AND v_booked_expired = 'Y' THEN --mikel 02.06.2013; do not include zero RI commission
              UPDATE giac_deferred_comm_income_pol gfaccomm_pol
                 SET gfaccomm_pol.comm_income = gfaccomm_pol.comm_income + facul_ri_comm.commission
               WHERE gfaccomm_pol.extract_year = p_ext_year
                 AND gfaccomm_pol.extract_mm = p_ext_mm
                 AND gfaccomm_pol.iss_cd = facul_ri_comm.iss_cd
                 AND gfaccomm_pol.line_cd = facul_ri_comm.line_cd
                 AND gfaccomm_pol.procedure_id = p_method
                 AND gfaccomm_pol.policy_no = facul_ri_comm.policy_no
                 AND gfaccomm_pol.share_type = '3'
                 AND gfaccomm_pol.acct_trty_type = 0
                 AND gfaccomm_pol.ri_cd = facul_ri_comm.ri_cd;

              IF SQL%NOTFOUND
              THEN
                 INSERT INTO giac_deferred_comm_income_pol
                          (extract_year, extract_mm, procedure_id, iss_cd, line_cd,
                           share_type, policy_no, ri_cd,
                           comm_income, eff_date, expiry_date, numerator_factor,
                           denominator_factor, def_comm_income, user_id, last_update
                          )
                   VALUES (p_ext_year, p_ext_mm, p_method, facul_ri_comm.iss_cd, facul_ri_comm.line_cd,
                          '3', facul_ri_comm.policy_no, facul_ri_comm.ri_cd,
                          facul_ri_comm.commission, facul_ri_comm.eff_date, facul_ri_comm.expiry_date, v_num_factor,
                          v_den_factor, v_def_prem, USER, SYSDATE
                          ); 
                          
              END IF;
            --END IF;  
        END IF;
   END LOOP;  
   
   -- Commission Expense
   -- Direct   
   FOR dicomm_exp IN           
        --(SELECT   iss_cd, line_cd, intm_no, policy_no, eff_date, expiry_date, SUM (comm_expense) comm_expense, acct_ent_date, aed2
        --mikel 02.25.2013; to insert records per modification
        (SELECT   iss_cd, line_cd, intm_no, policy_no, eff_date, expiry_date, comm_expense, acct_ent_date, aed2 
             FROM (SELECT NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd,
                          d.intrmdry_intm_no intm_no, get_policy_no (b.policy_id) policy_no, TRUNC (b.eff_date) eff_date,
                          TRUNC (NVL (b.endt_expiry_date, b.expiry_date)) expiry_date,
                          d.commission_amt * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'), v_mm_year, -1, 1) * a.currency_rt comm_expense
                          ,a.acct_ent_date, a.spoiled_acct_ent_date aed2 --mikel 02.04.2013
                     FROM gipi_invoice a, gipi_polbasic b, gipi_comm_invoice d
                    WHERE a.iss_cd = d.iss_cd
                      AND a.prem_seq_no = d.prem_seq_no
                      AND a.policy_id = d.policy_id
                      AND a.policy_id = b.policy_id
                      --AND TRUNC (b.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.29.2013; comment out
                      AND (   DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                           OR DECODE (v_start_date, NULL, SYSDATE, a.spoiled_acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                          )
                      AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') = v_mm_year
                           OR TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') = v_mm_year
                          )
                      AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                      AND b.reg_policy_sw = 'Y'
                      --AND b.expiry_date IS NOT NULL --jm test
                      AND NOT EXISTS (
                             SELECT 'X'
                               FROM giac_prev_comm_inv g, giac_new_comm_inv h
                              WHERE g.fund_cd = h.fund_cd
                                AND g.branch_cd = h.branch_cd
                                AND g.comm_rec_id = h.comm_rec_id
                                AND g.intm_no = h.intm_no
                                AND TO_CHAR (g.acct_ent_date, 'MM-YYYY') = v_mm_year
                                AND h.acct_ent_date > LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
                                AND h.tran_flag = 'P'
                                AND h.iss_cd = d.iss_cd
                                AND h.prem_seq_no = d.prem_seq_no
                                AND DECODE (v_start_date, NULL, SYSDATE, h.acct_ent_date ) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date))
                   UNION ALL
                   --SELECT stmnt for comms modified in the succeeding months
                   SELECT NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd, c.intm_no,
                          get_policy_no (b.policy_id) policy_no, TRUNC (b.eff_date) eff_date,
                          TRUNC (NVL (b.endt_expiry_date, b.expiry_date)) expiry_date,
                          c.commission_amt * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'), v_mm_year, -1, 1) * a.currency_rt comm_expense
                          ,a.acct_ent_date, a.spoiled_acct_ent_date aed2 --mikel 02.04.2013
                     FROM gipi_invoice a,
                          gipi_polbasic b,
                          giac_prev_comm_inv c,
                          giac_new_comm_inv d
                    WHERE a.policy_id = b.policy_id
                      AND a.iss_cd = d.iss_cd
                      AND a.prem_seq_no = d.prem_seq_no
                      AND a.policy_id = d.policy_id
                      --AND TRUNC (b.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm|| '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.29.2013; comment out
                      AND (DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                           OR DECODE (v_start_date, NULL, SYSDATE, a.spoiled_acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                          ) 
                      AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') = v_mm_year
                           OR TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') = v_mm_year
                           )
                      AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                      AND b.reg_policy_sw = 'Y'
                      --AND b.expiry_date IS NOT NULL --jm test
                      AND c.fund_cd = d.fund_cd
                      AND c.branch_cd = d.branch_cd
                      AND c.comm_rec_id = d.comm_rec_id
                      AND c.intm_no = d.intm_no
                      AND TO_CHAR (c.acct_ent_date, 'MM-YYYY') = v_mm_year
                      AND d.acct_ent_date > LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
                      AND d.tran_flag = 'P'
                      AND c.comm_rec_id =
                             (SELECT MIN (g.comm_rec_id)
                                FROM giac_prev_comm_inv g, giac_new_comm_inv h
                               WHERE g.fund_cd = h.fund_cd
                                 AND g.branch_cd = h.branch_cd
                                 AND g.comm_rec_id = h.comm_rec_id
                                 AND g.intm_no = h.intm_no
                                 AND TO_CHAR (g.acct_ent_date, 'MM-YYYY') = v_mm_year
                                 AND h.acct_ent_date > LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
                                 AND h.tran_flag = 'P'
                                 AND h.iss_cd = d.iss_cd
                                 AND h.prem_seq_no = d.prem_seq_no)
                   UNION ALL
                   --SELECT stmnt for comms modified within selected month
                   SELECT NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd, d.intm_no,
                          get_policy_no (b.policy_id) policy_no, TRUNC (b.eff_date) eff_date,
                          TRUNC (NVL (b.endt_expiry_date, b.expiry_date)) expiry_date,
                          (d.commission_amt * a.currency_rt) comm_expense
                          ,a.acct_ent_date, d.acct_ent_date aed2--mikel 02.04.2013
                     FROM gipi_invoice a, gipi_polbasic b, giac_new_comm_inv d
                    WHERE a.policy_id = b.policy_id
                      AND a.iss_cd = d.iss_cd
                      AND a.prem_seq_no = d.prem_seq_no
                      AND a.policy_id = d.policy_id
                      --AND TRUNC (b.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.29.2013; comment out
                      AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                      AND b.reg_policy_sw = 'Y'
                      --AND b.expiry_date IS NOT NULL --jm test
                      AND (DECODE (v_start_date, NULL, SYSDATE, d.acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                           OR DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                          )
                      AND TO_CHAR (d.acct_ent_date, 'MM-YYYY') = v_mm_year
                      AND NVL (d.delete_sw, 'N') = 'N'
                      AND d.tran_flag = 'P'
                   UNION ALL
                   /*include reversals of modified commissions */
                    --SELECT stmnt for reversal of comms modified within selected month
                   SELECT NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd, d.intm_no,
                          get_policy_no (b.policy_id) policy_no, TRUNC (b.eff_date) eff_date,
                          TRUNC (NVL (b.endt_expiry_date, b.expiry_date)) expiry_date,
                          ((c.commission_amt * a.currency_rt) * -1) comm_expense
                          ,a.acct_ent_date, d.acct_ent_date aed2 --mikel 02.04.2013
                     FROM gipi_invoice a,
                          gipi_polbasic b,
                          giac_prev_comm_inv c,
                          giac_new_comm_inv d
                    WHERE a.policy_id = b.policy_id
                      AND a.iss_cd = d.iss_cd
                      AND a.prem_seq_no = d.prem_seq_no
                      AND a.policy_id = d.policy_id
                      AND c.comm_rec_id = d.comm_rec_id
                      --AND TRUNC (b.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.29.2013; comment out
                      AND b.iss_cd NOT IN (v_iss_cd_ri, v_iss_cd_rv)
                      AND b.reg_policy_sw = 'Y'
                      --AND b.expiry_date IS NOT NULL --jm test
                      AND (   DECODE (v_start_date, NULL, SYSDATE, d.acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                           --OR DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                           AND DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date) --mikel 03.07.2013; do not include booked policies prior to start date
                          )
                      AND TO_CHAR (d.acct_ent_date, 'MM-YYYY') = v_mm_year
                      AND NVL (d.delete_sw, 'N') = 'N'
                      AND d.tran_flag = 'P')
                      )
         --GROUP BY iss_cd, line_cd, intm_no, policy_no, eff_date, expiry_date, acct_ent_date, aed2) --mikel 02.25.2013
    LOOP
          /*v_pol_term := (dicomm_exp.expiry_date + 1) - dicomm_exp.eff_date;
          v_earned_days := (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1) - dicomm_exp.eff_date;*/
          
          v_booked_expired := 'Y'; 
          
         /* 
         ** mikel 03.04.2013
         ** the denominator should be total number of days minus 1 day 
         ** and for the numerator  is minus 1 on the last month of the policy term.
         */  
          
         v_pol_term := dicomm_exp.expiry_date - dicomm_exp.eff_date; --mikel 03.04.2013
         
          IF LAST_DAY(dicomm_exp.expiry_date) > v_mm_year3 THEN
            IF dicomm_exp.eff_date < v_mm_year4 THEN
                v_earned_days := (v_mm_year3 - v_mm_year4) + 1;
            ELSIF dicomm_exp.eff_date >= v_mm_year4 THEN
                v_earned_days := (v_mm_year3 - dicomm_exp.eff_date) + 1;
            END IF;
          ELSIF LAST_DAY(dicomm_exp.expiry_date) < v_mm_year3 THEN
            IF LAST_DAY(dicomm_exp.acct_ent_date) > LAST_DAY(dicomm_exp.expiry_date) THEN --mikel 02.25.2013
                v_earned_days := 0;
            ELSIF LAST_DAY(dicomm_exp.acct_ent_date) <= LAST_DAY(dicomm_exp.expiry_date) THEN
                v_booked_expired := 'N';    
            END IF;
          ELSIF LAST_DAY(dicomm_exp.expiry_date) = v_mm_year3 THEN
            IF dicomm_exp.eff_date < v_mm_year4 THEN
                --v_earned_days := (dicomm_exp.expiry_date - v_mm_year4) + 1;
                v_earned_days := (dicomm_exp.expiry_date - v_mm_year4); --mikel 03.04.2013
            ELSIF dicomm_exp.eff_date >= v_mm_year4 THEN
                --v_earned_days := (dicomm_exp.expiry_date - dicomm_exp.eff_date) + 1;
                v_earned_days := (dicomm_exp.expiry_date - dicomm_exp.eff_date); --mikel 03.04.2013            
            END IF;               
          END IF; --mikel 01.22.2013; per month ang computation ng earned  
          
          -- mikel 02.04.2013; for late booking, 1st month computation will be based on extract date less effectivity date 
          --IF (p_ext_mm||'-'||p_ext_year = TO_CHAR(TO_DATE(dicomm_exp.acct_ent_date), 'MM-YYYY')
              --OR p_ext_mm||'-'||p_ext_year = TO_CHAR(TO_DATE(dicomm_exp.aed2), 'MM-YYYY')) THEN
          IF (v_mm_year3 = LAST_DAY(dicomm_exp.acct_ent_date)
              OR v_mm_year3 = LAST_DAY(dicomm_exp.aed2)) THEN    
              IF (TO_DATE(TO_CHAR(TO_DATE(dicomm_exp.acct_ent_date), 'MM-YYYY'), 'MM-YYYY') > dicomm_exp.eff_date  
                  OR TO_DATE(TO_CHAR(TO_DATE(dicomm_exp.aed2), 'MM-YYYY'), 'MM-YYYY') > dicomm_exp.eff_date) THEN
                    IF  LAST_DAY(dicomm_exp.expiry_date) >= v_mm_year3 THEN 
                        v_earned_days := (v_mm_year3 - dicomm_exp.eff_date) + 1;
                    ELSE
                        v_earned_days := (dicomm_exp.expiry_date - dicomm_exp.eff_date) + 1;
                    END IF; 
                    
                    IF v_earned_days > v_pol_term THEN
                        v_earned_days := v_pol_term;
                    END IF;       
              END IF;
          END IF;       
            
          
          IF dicomm_exp.eff_date > LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) THEN
            v_earned_days := 0;
          END IF;
          
          /*IF v_earned_days > v_pol_term THEN
             v_earned_days := v_pol_term;   
          END IF;*/
          
          v_unearned_days := v_pol_term - (v_earned_days);
          
          /*IF v_def_comm_prod = 'Y' THEN
             v_num_factor   := v_earned_days;
          ELSE
             v_num_factor   := v_unearned_days;
          END IF;*/
          v_num_factor   := v_earned_days;     
          
          v_den_factor    := v_pol_term;
          
          -- mikel 02.08.2013; do not include expired policies
          IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) <= v_mm_year3 THEN
            IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) >= LAST_DAY(TRUNC(dicomm_exp.expiry_date)) THEN
                dicomm_exp.comm_expense  := 0;
            END IF;
          END IF;
          
        --IF LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year, 'MM-YYYY')) <= LAST_DAY(TRUNC(dicomm_exp.expiry_date)) THEN --mikel 02.06.2013; do not include expired policies
            IF dicomm_exp.comm_expense <> 0 AND v_booked_expired = 'Y' THEN --mikel 02.06.2013; do not include zero DIRECT commission
              /*  UPDATE giac_deferred_comm_expense_pol gdicomm_exp
                 SET gdicomm_exp.comm_expense = gdicomm_exp.comm_expense + dicomm_exp.comm_expense
               WHERE gdicomm_exp.extract_year = p_ext_year
                 AND gdicomm_exp.extract_mm = p_ext_mm
                 AND gdicomm_exp.iss_cd = dicomm_exp.iss_cd
                 AND gdicomm_exp.line_cd = dicomm_exp.line_cd
                 AND gdicomm_exp.intm_ri = dicomm_exp.intm_no
                 AND gdicomm_exp.procedure_id = p_method
                 AND gdicomm_exp.policy_no = dicomm_exp.policy_no;  */ --mikel 02.25.2013         

              --IF SQL%NOTFOUND THEN
                 INSERT INTO giac_deferred_comm_expense_pol
                             (extract_year, extract_mm, iss_cd, line_cd, 
                              procedure_id, policy_no, eff_date, expiry_date, numerator_factor,
                              denominator_factor, comm_expense, intm_ri, user_id, last_update
                             )
                      VALUES (p_ext_year, p_ext_mm, dicomm_exp.iss_cd, dicomm_exp.line_cd, 
                              p_method, dicomm_exp.policy_no, dicomm_exp.eff_date, dicomm_exp.expiry_date,v_num_factor,
                              v_den_factor, dicomm_exp.comm_expense, dicomm_exp.intm_no, USER, SYSDATE
                             );
              --END IF; 
            END IF;  
            
        --END IF;
    END LOOP;        
    
    FOR ri_comm_exp IN
        --(SELECT   iss_cd, line_cd, ri_cd, policy_no, eff_date, expiry_date, SUM (comm_expense) comm_expense ,acct_ent_date, aed2, aed3
        --mikel 02.25.2013; to insert records per modification
        (SELECT   iss_cd, line_cd, ri_cd, policy_no, eff_date, expiry_date, comm_expense ,acct_ent_date, aed2, aed3
        FROM (SELECT NVL (b.cred_branch, a.iss_cd) iss_cd,
               --SELECT stmnt for unmodified commissions
                     b.line_cd, c.ri_cd, get_policy_no (b.policy_id) policy_no,
                     TRUNC (b.eff_date) eff_date, TRUNC (NVL (b.endt_expiry_date, b.expiry_date)) expiry_date,
                       a.ri_comm_amt * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'), v_mm_year, -1, 1) * a.currency_rt comm_expense
                       ,a.acct_ent_date, a.spoiled_acct_ent_date aed2, a.acct_ent_date aed3 --mikel 02.04.2013
                FROM gipi_invoice a, gipi_polbasic b, giri_inpolbas c
               WHERE a.policy_id = b.policy_id
                 AND b.policy_id = c.policy_id
                 --AND TRUNC (b.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.29.2013; comment out
                 AND DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                 AND (TO_CHAR (a.acct_ent_date, 'MM-YYYY') = v_mm_year OR TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') = v_mm_year)
                 AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                 AND b.reg_policy_sw = 'Y'
                 --AND b.expiry_date IS NOT NULL --jm test
                 AND NOT EXISTS (
                        SELECT 'X'
                          FROM giac_ri_comm_hist c
                         WHERE c.policy_id = b.policy_id
                           AND TO_CHAR (c.acct_ent_date, 'MM-YYYY') = v_mm_year
                           AND LAST_DAY (TRUNC (c.post_date)) > LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')))
              UNION ALL
              --SELECT stmnt for comms modified in the succeeding months
              SELECT NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd, d.ri_cd,
                     get_policy_no (b.policy_id) policy_no, TRUNC (b.eff_date) eff_date,
                     TRUNC (NVL (b.endt_expiry_date, b.expiry_date)) expiry_date,
                     c.old_ri_comm_amt * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'), v_mm_year, -1, 1) * a.currency_rt comm_expense
                     ,a.acct_ent_date, a.spoiled_acct_ent_date aed2, c.acct_ent_date aed3 --mikel 02.04.2013
                FROM gipi_invoice a,
                     giac_ri_comm_hist c,
                     gipi_polbasic b,
                     giri_inpolbas d
               WHERE a.policy_id = b.policy_id
                 AND b.policy_id = c.policy_id
                 AND b.policy_id = d.policy_id
                 AND DECODE (v_start_date, NULL, SYSDATE, c.acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                 AND TO_CHAR (c.acct_ent_date, 'MM-YYYY') = v_mm_year
                 AND LAST_DAY (TRUNC (c.post_date)) > LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY'))
                 --AND TRUNC (b.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.29.2013; comment out
                 AND (TO_CHAR (a.acct_ent_date, 'MM-YYYY') = v_mm_year OR TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') = v_mm_year)
                 AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                 AND b.reg_policy_sw = 'Y'
                 --AND b.expiry_date IS NOT NULL --jm test
                 AND c.tran_id_rev =
                        (SELECT MIN (tran_id_rev)
                           FROM giac_ri_comm_hist d
                          WHERE d.policy_id = b.policy_id
                            AND TO_CHAR (d.acct_ent_date, 'MM-YYYY') = v_mm_year
                            AND LAST_DAY (TRUNC (d.post_date)) > LAST_DAY (TO_DATE (v_mm_year, 'MM-YYYY')))
              UNION ALL
              --SELECT stmnt for comms modified within selected month
              SELECT NVL (b.cred_branch, a.iss_cd) iss_cd, b.line_cd, d.ri_cd,
                     get_policy_no (b.policy_id) policy_no, TRUNC (b.eff_date) eff_date,
                     TRUNC (NVL (b.endt_expiry_date, b.expiry_date)) expiry_date,
                     c.new_ri_comm_amt * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'), v_mm_year, -1, 1) * a.currency_rt comm_expense
                     ,a.acct_ent_date, a.spoiled_acct_ent_date aed2, b.acct_ent_date aed3 --mikel 02.04.2013
                FROM gipi_invoice a,
                     giac_ri_comm_hist c,
                     gipi_polbasic b,
                     giri_inpolbas d
               WHERE a.policy_id = b.policy_id
                 AND b.policy_id = c.policy_id
                 AND b.policy_id = d.policy_id
                 AND DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE (v_start_date, NULL, SYSDATE, v_start_date)
                 AND TO_CHAR (c.post_date, 'MM-YYYY') = v_mm_year
                 --AND TRUNC (b.eff_date) > LAST_DAY (ADD_MONTHS (TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'), -12)) --mikel 01.29.2013; comment out
                 AND b.iss_cd IN (v_iss_cd_ri, v_iss_cd_rv)
                 AND b.reg_policy_sw = 'Y'
                 --AND b.expiry_date IS NOT NULL --jm test
                 AND c.tran_id =
                        (SELECT MAX (tran_id)
                           FROM giac_ri_comm_hist d
                          WHERE d.policy_id = b.policy_id
                            AND TO_CHAR (d.post_date, 'MM-YYYY') = v_mm_year)))
    --GROUP BY iss_cd, line_cd, ri_cd, policy_no, eff_date, expiry_date, acct_ent_date, aed2, aed3) --mikel 02.25.2013
    LOOP
          /*v_pol_term := (ri_comm_exp.expiry_date + 1) - ri_comm_exp.eff_date;
          v_earned_days := (LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) + 1) - ri_comm_exp.eff_date;*/
         
         v_booked_expired := 'Y';

          /* 
         ** mikel 03.04.2013
         ** the denominator should be total number of days minus 1 day 
         ** and for the numerator  is minus 1 on the last month of the policy term.
         */
          
         v_pol_term := ri_comm_exp.expiry_date - ri_comm_exp.eff_date; --mikel 03.04.2013
         
          IF LAST_DAY(ri_comm_exp.expiry_date) > v_mm_year3 THEN
            IF ri_comm_exp.eff_date < v_mm_year4 THEN
                v_earned_days := (v_mm_year3 - v_mm_year4) + 1;
            ELSIF ri_comm_exp.eff_date >= v_mm_year4 THEN
                v_earned_days := (v_mm_year3 - ri_comm_exp.eff_date) + 1;
            END IF;
          ELSIF LAST_DAY(ri_comm_exp.expiry_date) < v_mm_year3 THEN
            IF LAST_DAY(ri_comm_exp.acct_ent_date) > LAST_DAY(ri_comm_exp.expiry_date) THEN --mikel 02.25.2013
                v_earned_days := 0;
            ELSIF LAST_DAY(ri_comm_exp.acct_ent_date) <= LAST_DAY(ri_comm_exp.expiry_date) THEN
                v_booked_expired := 'N';    
            END IF;
          ELSIF LAST_DAY(ri_comm_exp.expiry_date) = v_mm_year3 THEN
            IF ri_comm_exp.eff_date < v_mm_year4 THEN
                --v_earned_days := (ri_comm_exp.expiry_date - v_mm_year4) + 1;
                v_earned_days := (ri_comm_exp.expiry_date - v_mm_year4); --mikel 03.04.2013
            ELSIF ri_comm_exp.eff_date >= v_mm_year4 THEN
                --v_earned_days := (ri_comm_exp.expiry_date - ri_comm_exp.eff_date) + 1;
                v_earned_days := (ri_comm_exp.expiry_date - ri_comm_exp.eff_date); --mikel 03.04.2013           
            END IF;               
          END IF; --mikel 01.22.2013; per month ang computation ng earned  
          
          -- mikel 02.04.2013; for late booking, 1st month computation will be based on extract date less effectivity date 
          IF (v_mm_year3 = LAST_DAY(ri_comm_exp.acct_ent_date)
              OR v_mm_year3 = LAST_DAY(ri_comm_exp.aed2)) THEN
              IF (TO_DATE(TO_CHAR(TO_DATE(ri_comm_exp.acct_ent_date), 'MM-YYYY'), 'MM-YYYY') > ri_comm_exp.eff_date
                  OR TO_DATE(TO_CHAR(TO_DATE(ri_comm_exp.aed2), 'MM-YYYY'), 'MM-YYYY') > ri_comm_exp.eff_date) THEN
                    IF  LAST_DAY(ri_comm_exp.expiry_date) >= v_mm_year3 THEN 
                        v_earned_days := (v_mm_year3 - ri_comm_exp.eff_date) + 1;
                    ELSE
                        v_earned_days := (ri_comm_exp.expiry_date - ri_comm_exp.eff_date) + 1;
                    END IF;
                    
                    IF v_earned_days > v_pol_term THEN
                        v_earned_days := v_pol_term;
                    END IF;    
              END IF;
          END IF;
          
          IF ri_comm_exp.eff_date > LAST_DAY (TO_DATE (v_mm_year_mn2, 'MM-YYYY')) THEN
            v_earned_days := 0;
          END IF;
          
          v_unearned_days := v_pol_term - (v_earned_days);
          
          v_num_factor   := v_earned_days;     
          
          v_den_factor    := v_pol_term;
          
          -- mikel 02.08.2013; do not include expired policies
          IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) < v_mm_year3 THEN
            IF LAST_DAY(TO_DATE(v_mm_year, 'MM-YYYY')) >= LAST_DAY(TRUNC(ri_comm_exp.expiry_date)) THEN
                ri_comm_exp.comm_expense  := 0;
            END IF;
          END IF;
          
        --IF LAST_DAY(TO_DATE(p_ext_mm||'-'||p_ext_year, 'MM-YYYY')) <= LAST_DAY(TRUNC(ri_comm_exp.expiry_date)) THEN --mikel 02.06.2013; do not include expired policies
            IF ri_comm_exp.comm_expense <> 0 AND v_booked_expired = 'Y' THEN --mikel 02.06.2013; do not include zero premium
               /* UPDATE giac_deferred_comm_expense_pol gricomm_exp
                 SET gricomm_exp.comm_expense = gricomm_exp.comm_expense + ri_comm_exp.comm_expense
               WHERE gricomm_exp.extract_year = p_ext_year
                 AND gricomm_exp.extract_mm = p_ext_mm
                 AND gricomm_exp.iss_cd = ri_comm_exp.iss_cd
                 AND gricomm_exp.line_cd = ri_comm_exp.line_cd
                 AND gricomm_exp.intm_ri = ri_comm_exp.ri_cd
                 AND gricomm_exp.procedure_id = p_method
                 AND gricomm_exp.policy_no = ri_comm_exp.policy_no;*/ --mikel 02.25.2013

              --IF SQL%NOTFOUND THEN
                 INSERT INTO giac_deferred_comm_expense_pol
                             (extract_year, extract_mm, iss_cd, line_cd, 
                              procedure_id, policy_no, eff_date, expiry_date, numerator_factor,
                              denominator_factor, comm_expense, intm_ri, user_id, last_update
                             )
                      VALUES (p_ext_year, p_ext_mm, ri_comm_exp.iss_cd, ri_comm_exp.line_cd, 
                              p_method, ri_comm_exp.policy_no, ri_comm_exp.eff_date, ri_comm_exp.expiry_date,v_num_factor,
                              v_den_factor, ri_comm_exp.comm_expense, ri_comm_exp.ri_cd, USER, SYSDATE
                             );
             -- END IF;
            END IF; 
            
        --END IF;   
    END LOOP;     
END deferred_extract365_dtl;
/


