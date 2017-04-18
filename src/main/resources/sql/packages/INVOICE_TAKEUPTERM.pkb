/* Formatted on 2/11/2016 5:27:53 PM (QP5 v5.227.12220.39754) */
CREATE OR REPLACE PACKAGE BODY CPI.INVOICE_TAKEUPTERM
AS
   /*  Created by Mikel 02.09.2016
   ** Descrpition: This will retrieve incept and expiry date per invoice/bill
   **              to handle long-term policies and change of policy term for 24th Method.
   */

   FUNCTION latest_incept_expiry_date (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.line_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE,
      p_ext_mm_yy     VARCHAR2) --Deo [08.22.2016]: SR-22527
      RETURN incept_exp_list_tab
      PIPELINED
   IS
      v_list   incept_exp_list_type;
      
      --mikel 06.09.2016;UCPBGEN SR 22527
      v_prev_incept_date gipi_polbasic.incept_date%TYPE;
      v_prev_exp_date    gipi_polbasic.expiry_date%TYPE;
   BEGIN
      FOR pol
         IN (  SELECT TRUNC (x.eff_date) eff_date,
                      TRUNC (x.incept_date) incept_date, x.endt_seq_no, --mikel 06.09.2016;UCPBGEN SR 22527
                      TRUNC (NVL (x.endt_expiry_date, x.expiry_date)) endt_expiry_date,--mikel 06.09.2016;UCPBGEN SR 22527
                      TRUNC(x.expiry_date) expiry_date
                 FROM gipi_polbasic x, gipi_parlist y
                WHERE     1 = 1
                      AND x.par_id = y.par_id
                      AND x.line_cd = p_line_cd
                      AND x.subline_cd = p_subline_cd
                      AND x.iss_cd = p_iss_cd
                      AND x.issue_yy = p_issue_yy
                      AND x.pol_seq_no = p_pol_seq_no
                      AND x.renew_no = p_renew_no
                      AND x.policy_id > 0
                      AND x.pol_flag != DECODE(x.endt_seq_no, '0', '0', '5')  
                      AND ((LAST_DAY (TRUNC (x.eff_date)) <=
                                    LAST_DAY (TO_DATE (p_ext_mm_yy, 'MM-YYYY')) --Deo [08.22.2016]: SR-22527
                                    AND x.endt_seq_no != 0) OR x.endt_seq_no = 0) --mikel 01.18.2016 UCPBGEN SR 23722
                      --AND x.pol_flag IN ('1', '2', '3', 'X')
                      /*AND NOT EXISTS
                                 (SELECT 'X'
                                    FROM gipi_polbasic m
                                   WHERE     m.line_cd = p_line_cd
                                         AND m.subline_cd = p_subline_cd
                                         AND m.iss_cd = p_iss_cd
                                         AND m.issue_yy = p_issue_yy
                                         AND m.pol_seq_no = p_pol_seq_no
                                         AND m.endt_seq_no > x.endt_seq_no
                                         AND m.renew_no = p_renew_no
                                         AND m.pol_flag IN ('1', '2', '3', 'X')
                                         AND NVL (m.back_stat, 5) = 2
                                         AND m.assd_no IS NOT NULL)
             ORDER BY x.eff_date DESC)*/ --mikel 06.09.2016;UCPBGEN SR 22527
             ORDER BY x.endt_seq_no DESC) 
      LOOP   
         
         --mikel 06.09.2016;UCPBGEN SR 22527
         v_list.prev_incept_date := pol.incept_date;
         v_list.prev_expiry_date := pol.expiry_date;
         
         IF pol.endt_seq_no != 0 THEN
            BEGIN
                SELECT incept_date, expiry_date
                  INTO v_prev_incept_date, v_prev_exp_date
                  FROM gipi_polbasic y
                 WHERE y.line_cd = p_line_cd
                   AND y.subline_cd = p_subline_cd
                   AND y.iss_cd = p_iss_cd
                   AND y.issue_yy = p_issue_yy
                   AND y.pol_seq_no = p_pol_seq_no
                   AND y.renew_no = p_renew_no
                   --AND y.endt_seq_no = pol.endt_seq_no - 1;
                   AND y.endt_seq_no = 0;
                   
                   v_list.prev_incept_date := v_prev_incept_date;
                   v_list.prev_expiry_date := v_prev_exp_date;
            END;       
         END IF;
         
         v_list.incept_date := pol.incept_date;
         v_list.expiry_date := pol.expiry_date;
         v_list.eff_date    := pol.eff_date;
         v_list.endt_exp_date    := pol.endt_expiry_date;
         --end mikel 06.09.2016       
         
         PIPE ROW (v_list);
         EXIT;
      END LOOP;
   END;

   FUNCTION get_eff_date (p_policy_id        gipi_invoice.policy_id%TYPE,
                          p_takeup_seq_no    gipi_invoice.takeup_seq_no%TYPE,
                          p_ext_mm_yy        VARCHAR2) --Deo [08.22.2016]: SR-22527
      RETURN DATE
   IS
      v_eff_date            gipi_polbasic.eff_date%TYPE;
      v_incept_date         gipi_polbasic.incept_date%TYPE; --mikel 06.09.2016;UCPBGEN SR 22527
      v_policy_days         NUMBER := 0;
      v_days_interval       NUMBER := 0;
      v_max_takeup_seq_no   NUMBER := 0;
      v_exp_date            gipi_polbasic.expiry_date%TYPE; --Deo [08.22.2016]: SR-22527
      v_leap_year           NUMBER := 0; --Deo [08.22.2016]: SR-22527
   BEGIN
      FOR rec
         IN (SELECT DISTINCT MAX (b.takeup_seq_no) OVER () max_takeup_seq_no, --Deo [08.22.2016]: added distinct (SR-22527)
                    (SELECT TRUNC (incept_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       incept_date,
                    (SELECT TRUNC (expiry_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       expiry_date,
                    --mikel 06.09.2016;UCPBGEN SR 22527    
                    (SELECT TRUNC (eff_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       latest_end_eff_date,
                    (SELECT TRUNC (endt_exp_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       latest_end_exp_date,                  
                    (SELECT TRUNC (prev_incept_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       previous_incept_date,
                    (SELECT TRUNC (prev_expiry_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       previous_exp_date,                                                                            
                    TRUNC(a.eff_date) eff_date,
                    --end mikel 06.09.2016                     
               		a.endt_seq_no, TRUNC (NVL (a.endt_expiry_date, a.expiry_date)) endt_expiry_date --Deo [08.22.2016]: SR-22527
               FROM gipi_polbasic a, gipi_invoice b
              WHERE a.policy_id = b.policy_id AND b.policy_id = p_policy_id)
      LOOP
      	 IF rec.endt_seq_no != 0 --Deo [08.22.2016]: SR-22527
         THEN
            rec.incept_date := rec.eff_date;
            rec.expiry_date := rec.endt_expiry_date;
         ELSE
            rec.eff_date := rec.incept_date;
         END IF;
         
         IF TRUNC (rec.expiry_date - rec.incept_date) = 31
         THEN
            v_policy_days := 30;
         ELSE
            v_policy_days := TRUNC (rec.expiry_date - rec.incept_date);
         END IF;

         v_days_interval := ROUND (v_policy_days / rec.max_takeup_seq_no);

         /*v_eff_date :=
            rec.incept_date + (v_days_interval * (p_takeup_seq_no - 1));*/
            
         --mikel 06.09.2016;UCPBGEN SR 22527
         v_eff_date :=
            rec.eff_date + (v_days_interval * (p_takeup_seq_no - 1));  
            
         /*IF (rec.incept_date != NVL(rec.previous_incept_date, rec.incept_date) OR rec.expiry_date != NVL(rec.previous_exp_date, rec.expiry_date)) THEN
             IF rec.eff_date > rec.expiry_date THEN
                v_eff_date := rec.expiry_date; --long-term policies with multiple take-up is not yet handled
             END IF;
         END IF;*/  --Deo [08.22.2016]: comment out
         --end mikel    
                            
         --Deo [08.22.2016]: add start (SR-22527)
         IF p_takeup_seq_no > 1
         THEN
            v_exp_date := v_eff_date;

            FOR leap_year IN
               TO_NUMBER (TO_CHAR (rec.incept_date, 'YYYY')) .. TO_NUMBER
                                                                          (TO_CHAR
                                                                              (v_exp_date,
                                                                               'YYYY'
                                                                              )
                                                                          )
            LOOP
               IF     TO_NUMBER
                            (TO_CHAR (LAST_DAY (TO_DATE (   '01-FEB-'
                                                         || TO_CHAR (leap_year),
                                                         'DD-MON-RRRR'
                                                        )
                                               ),
                                      'DD'
                                     )
                            ) = 29
                  AND rec.incept_date <=
                         LAST_DAY (TO_DATE ('01-FEB-' || TO_CHAR (leap_year),
                                            'DD-MON-RRRR'
                                           )
                                  )
                  AND v_exp_date >=
                         LAST_DAY (TO_DATE ('01-FEB-' || TO_CHAR (leap_year),
                                            'DD-MON-RRRR'
                                           )
                                  )
               THEN
                  v_leap_year := v_leap_year + 1;
               END IF;
            END LOOP;

            IF v_leap_year > 0
            THEN
               v_exp_date := v_exp_date + v_leap_year;
            END IF;

            v_eff_date := v_exp_date + p_takeup_seq_no - 1;
         END IF;
         --Deo [08.22.2016]: add ends
      END LOOP;

      RETURN (v_eff_date);
   END;

   FUNCTION get_exp_date (p_policy_id        gipi_invoice.policy_id%TYPE,
                          p_takeup_seq_no    gipi_invoice.takeup_seq_no%TYPE,
                          p_ext_mm_yy        VARCHAR2) --Deo [08.22.2016]: SR-22527
      RETURN DATE
   IS
      v_eff_date            gipi_polbasic.eff_date%TYPE;
      v_exp_date            gipi_polbasic.eff_date%TYPE;
      v_policy_days         NUMBER := 0;
      v_days_interval       NUMBER := 0;
      v_max_takeup_seq_no   NUMBER := 0;
      v_leap_year           NUMBER := 0;
   BEGIN
      FOR rec
         IN (SELECT DISTINCT MAX (b.takeup_seq_no) OVER () max_takeup_seq_no, --Deo [08.22.2016]: added distinct (SR-22527)
                    (SELECT TRUNC (incept_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       incept_date,
                    (SELECT TRUNC (expiry_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       expiry_date,
                    --mikel 06.22.2016;UCPBGEN SR 22527    
                    (SELECT TRUNC (eff_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       latest_end_eff_date,
                    (SELECT TRUNC (prev_incept_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       previous_incept_date,
                    (SELECT TRUNC (prev_expiry_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       previous_exp_date,                                                                            
                    TRUNC(a.eff_date) eff_date, TRUNC(NVL(a.endt_expiry_date, a.expiry_date)) endt_expiry_date
                    ,a.endt_seq_no
                    --end mikel 06.22.2016   
               FROM gipi_polbasic a, gipi_invoice b
              WHERE a.policy_id = b.policy_id AND b.policy_id = p_policy_id)
      LOOP
         IF rec.endt_seq_no != 0 --Deo [08.22.2016]: SR-22527
         THEN
            rec.incept_date := rec.eff_date;
            rec.expiry_date := rec.endt_expiry_date;
         END IF;
         
         IF TRUNC (rec.expiry_date - rec.incept_date) = 31
         THEN
            v_policy_days := 30;
         ELSE
            v_policy_days := TRUNC (rec.expiry_date - rec.incept_date);
         END IF;

         v_days_interval := ROUND (v_policy_days / rec.max_takeup_seq_no);



         IF rec.max_takeup_seq_no = p_takeup_seq_no
         THEN
            v_exp_date := rec.expiry_date;
         ELSE
            v_eff_date :=
               rec.incept_date + (v_days_interval * (p_takeup_seq_no - 1));

            v_exp_date :=
               rec.incept_date + (v_days_interval * p_takeup_seq_no) /*- 1*/; --Deo [08.22.2016]: removed - 1 (SR-22527)


            /**/FOR leap_year IN TO_NUMBER (TO_CHAR (rec.incept_date, 'YYYY')) ..
                             TO_NUMBER (TO_CHAR (v_exp_date, 'YYYY'))
            LOOP
               IF     TO_NUMBER (
                         TO_CHAR (
                            LAST_DAY (
                               TO_DATE ('01-FEB-' || TO_CHAR (leap_year),
                                        'DD-MON-RRRR')),
                            'DD')) = 29
                  AND rec.incept_date <=
                         LAST_DAY (
                            TO_DATE ('01-FEB-' || TO_CHAR (leap_year),
                                     'DD-MON-RRRR'))
                  AND v_exp_date >=
                         LAST_DAY (
                            TO_DATE ('01-FEB-' || TO_CHAR (leap_year),
                                     'DD-MON-RRRR'))
               THEN
                  v_leap_year := v_leap_year + 1;
               END IF;
            END LOOP;

            IF v_leap_year > 0
            THEN
               v_exp_date := v_exp_date + v_leap_year;
            END IF;/**/ --Deo [08.22.2016]: restore commented out codes (SR-22527)
            
            IF p_takeup_seq_no > 1 --Deo [08.22.2016]: SR-22527
            THEN
               v_exp_date := v_exp_date + 1;
            END IF;
         END IF;
         
         /*v_exp_date := rec.endt_expiry_date;
         
         IF (rec.incept_date != NVL(rec.previous_incept_date, rec.incept_date) OR rec.expiry_date != NVL(rec.previous_exp_date, rec.expiry_date)) THEN
             IF rec.endt_seq_no = 0 THEN
                v_exp_date := rec.expiry_date;
             ELSIF rec.endt_seq_no != 0 THEN   
                 IF rec.endt_expiry_date > rec.expiry_date THEN
                    v_exp_date := rec.expiry_date; --long-term policies with multiple take-up is not yet handled
                 END IF;
             END IF;    
         END IF;*/ --Deo [08.22.2016]: comment out (SR-22527)
         
      END LOOP;

      RETURN (v_exp_date);
   END;
   
   --mikel 06.09.2016; UCPBGEN 22527
   FUNCTION get_inc_date (p_policy_id        gipi_invoice.policy_id%TYPE,
                          p_takeup_seq_no    gipi_invoice.takeup_seq_no%TYPE,
                          p_ext_mm_yy        VARCHAR2) --Deo [08.22.2016]: SR-22527
      RETURN DATE
   IS
      v_incept_date         gipi_polbasic.incept_date%TYPE;
      v_policy_days         NUMBER := 0;
      v_days_interval       NUMBER := 0;
      v_max_takeup_seq_no   NUMBER := 0;
   BEGIN
      FOR rec
         IN (SELECT MAX (b.takeup_seq_no) OVER () max_takeup_seq_no,
                    (SELECT TRUNC (incept_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       incept_date,
                    (SELECT TRUNC (expiry_date)
                       FROM TABLE (INVOICE_TAKEUPTERM.latest_incept_expiry_date (
                                      a.line_cd,
                                      a.subline_cd,
                                      a.iss_cd,
                                      a.issue_yy,
                                      a.pol_seq_no,
                                      a.renew_no,
                                      p_ext_mm_yy))) --Deo [08.22.2016]: SR-22527
                       expiry_date                    
               FROM gipi_polbasic a, gipi_invoice b
              WHERE a.policy_id = b.policy_id AND b.policy_id = p_policy_id)
      LOOP
         IF TRUNC (rec.expiry_date - rec.incept_date) = 31
         THEN
            v_policy_days := 30;
         ELSE
            v_policy_days := TRUNC (rec.expiry_date - rec.incept_date);
         END IF;

         v_days_interval := ROUND (v_policy_days / rec.max_takeup_seq_no);

         v_incept_date :=
            rec.incept_date + (v_days_interval * (p_takeup_seq_no - 1));
                            
      END LOOP;

      RETURN (v_incept_date);
   END;
END;