CREATE OR REPLACE PACKAGE BODY CPI.CSV_AC_RCPT_REPORTS
AS
/* created by carlo de guzman 
   date   3.8.2016
   */
   FUNCTION csv_giacr170(
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_date_type   VARCHAR2,
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_module_id   VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr170_details_tab PIPELINED
   IS
      v_rec         giacr170_details_type;
      v_to_date     DATE                 := TO_DATE (p_to_date, 'MM/DD/YYYY');
      v_from_date   DATE               := TO_DATE (p_from_date, 'MM/DD/YYYY');
   BEGIN
      FOR i IN
         (SELECT   a.prem_seq_no, g.tran_id, g.tran_date,
                   DECODE (d.endt_seq_no,
                           0,  d.line_cd
                            || '-'
                            || d.subline_cd
                            || '-'
                            || d.iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (d.issue_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (d.pol_seq_no, '0000009'))
                            || '-'
                            || LTRIM (TO_CHAR (d.renew_no, '09')),
                              d.line_cd
                           || '-'
                           || d.subline_cd
                           || '-'
                           || d.iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (d.issue_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (d.pol_seq_no, '0000009'))
                           || '-'
                           || LTRIM (TO_CHAR (d.renew_no, '09'))
                           || '/'
                           || d.endt_iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (d.endt_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (d.endt_seq_no, '000009'))
                          ) policy_no,
                   RTRIM (LTRIM (d.ref_pol_no)) reference_pol_no,f.assd_no,
                   f.assd_name assured, d.incept_date inception_date, a.iss_cd,
                   d.expiry_date expiry_date,
                   a.iss_cd || '-' || a.prem_seq_no bill_no,
                   c.collection_amt collection_amt,
                   c.premium_amt premium_amt, c.tax_amt tax_amt,
                   a.booking_mth bk_month, a.booking_year bk_year,
                   DECODE (p_branch,
                           'OR', g.gibr_branch_cd,
                           'BI', c.b140_iss_cd,
                           'CB', d.cred_branch
                          ) branch,
                   h.dv_no, i.or_no, g.jv_no, h.dv_pref, i.or_pref_suf, g.jv_pref_suff -- Dren 04.27.2016 SR-5353                             
              FROM giac_advanced_payt a,
                   giac_direct_prem_collns c,
                   gipi_polbasic d,
                   gipi_invoice e,
                   giis_assured f,
                   giac_acctrans g,
                   giac_disb_vouchers h, -- Dren 04.27.2016 SR-5353
                   giac_order_of_payts i -- Dren 04.27.2016 SR-5353                   
             WHERE a.gacc_tran_id = c.gacc_tran_id
               AND g.tran_id = h.gacc_tran_id(+) -- Dren 04.27.2016 SR-5353
               AND g.tran_id = i.gacc_tran_id(+) -- Dren 04.27.2016 SR-5353             
               AND a.gacc_tran_id = g.tran_id
               AND a.iss_cd = c.b140_iss_cd
               AND a.prem_seq_no = c.b140_prem_seq_no
               AND d.policy_id = e.policy_id
               AND c.b140_iss_cd = e.iss_cd
               AND c.b140_prem_seq_no = e.prem_seq_no
               AND d.assd_no = f.assd_no
               AND g.tran_flag != 'D'
                AND c.inst_no = a.inst_no           
               AND (   g.gibr_branch_cd IN (
                          SELECT DECODE (p_branch, 'OR', gibr_branch_cd)
                            FROM giac_acctrans
                           WHERE gibr_branch_cd =
                                             NVL (p_branch_cd, gibr_branch_cd)
                             AND check_user_per_iss_cd_acctg2 (NULL,
                                                               gibr_branch_cd,
                                                               p_module_id,
                                                               p_user
                                                              ) = 1)
                                                    
                    OR c.b140_iss_cd IN (
                          SELECT DECODE (p_branch, 'BI', b140_iss_cd)
                            FROM giac_direct_prem_collns
                           WHERE b140_iss_cd = NVL (p_branch_cd, b140_iss_cd)
                             AND check_user_per_iss_cd_acctg2 (NULL,
                                                               b140_iss_cd,
                                                               p_module_id,
                                                               p_user
                                                              ) = 1)
                                                   
                    OR d.cred_branch IN (
                          SELECT DECODE (p_branch, 'CB', cred_branch)
                            FROM gipi_polbasic
                           WHERE cred_branch = NVL (p_branch_cd, cred_branch)
                             AND check_user_per_iss_cd_acctg2 (NULL,
                                                               cred_branch,
                                                               p_module_id,
                                                               p_user
                                                              ) = 1)
                   )                                
               AND TRUNC (DECODE (UPPER (p_date_type),
                                  'T', g.tran_date,
                                  'P', g.posting_date
                                 )
                         )
                      BETWEEN NVL
                                (UPPER (v_from_date),
                                 (SELECT MIN
                                            (TRUNC
                                                  (DECODE (UPPER (p_date_type),
                                                           'T', tran_date,
                                                           'P', posting_date
                                                          )
                                                  )
                                            )
                                    FROM giac_acctrans)
                                )
                          AND v_to_date
                            
               AND NOT EXISTS (
                      SELECT x.gacc_tran_id
                        FROM giac_reversals x, giac_acctrans y
                       WHERE x.reversing_tran_id = y.tran_id
                         AND y.tran_flag != 'D'
                         AND x.gacc_tran_id = a.gacc_tran_id)
          ORDER BY branch, h.dv_pref, h.dv_no, i.or_pref_suf,i.or_no, g.jv_pref_suff,  g.jv_no, g.tran_id, g.tran_date) -- Dren 04.27.2016 SR-5353                         )
      LOOP
         v_rec.issue_code           := i.iss_cd;
         v_rec.transaction_date     := i.tran_date;
         v_rec.policy_no            := i.policy_no;
         v_rec.reference_policy_no  := i.reference_pol_no;
         v_rec.assured_no           := i.assd_no;
         v_rec.assured_name         := i.assured;
         v_rec.inception_date       := i.inception_date;
         v_rec.expiry_date          := i.expiry_date;
         v_rec.collection_amount    := i.collection_amt;
         v_rec.premium_amount       := i.premium_amt;
         v_rec.tax_amount           := i.tax_amt;
         v_rec.booking_month        := i.bk_month;
         v_rec.booking_year         := i.bk_year;
         v_rec.branch_code          := i.branch;
         v_rec.premium_sequence_no  := i.prem_seq_no;
         
         
          SELECT tran_id
          INTO v_rec.or_no
          FROM TABLE(CSV_AC_RCPT_REPORTS.CF_1FORMULA(i.tran_id));
        
         
         
         BEGIN
                SELECT distinct iss_name
                INTO v_rec.branch_name
                FROM giis_issource
                WHERE iss_cd = v_rec.branch_code;
             
            EXCEPTION
                WHEN NO_DATA_FOUND
            THEN
               v_rec.branch_name := null;
            END;
            
       
            
        
            
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END csv_giacr170;
   FUNCTION csv_giacr170a (
      p_date_type   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2
   )
      RETURN giacr170a_details_tab PIPELINED
   IS
      v_rec         giacr170a_details_type;
      v_from_date   DATE               := TO_DATE (p_from_date, 'MM/DD/YYYY');
      v_to_date     DATE                 := TO_DATE (p_to_date, 'MM/DD/YYYY');
      branch        VARCHAR2 (50);
   BEGIN
      FOR i IN
         (SELECT DISTINCT get_ref_no (b.tran_id) ref_no,
                          DECODE (p_date_type,
                                  'P', b.posting_date,
                                  'T', b.tran_date
                                 ) date_decode,
                          get_policy_no (d.policy_id) policy_no, f.assd_name,
                          d.incept_date, d.expiry_date,
                          a.iss_cd || '-' || a.prem_seq_no bill_no,
                          c.premium_amt, c.tax_amt,
                          (a.booking_mth || ' ' || a.booking_year
                          ) booking_date,
                          d.cred_branch
                     FROM giac_advanced_payt a,
                          giac_acctrans b,
                          giac_direct_prem_collns c,
                          gipi_polbasic d,
                          gipi_invoice e,
                          giis_assured f
                    WHERE a.gacc_tran_id = b.tran_id
                      AND a.gacc_tran_id = c.gacc_tran_id
                      AND a.iss_cd = c.b140_iss_cd
                      AND a.prem_seq_no = c.b140_prem_seq_no
                      AND d.policy_id = e.policy_id
                      AND c.b140_iss_cd = e.iss_cd
                      AND c.b140_prem_seq_no = e.prem_seq_no
                      AND d.assd_no = f.assd_no
                      AND d.cred_branch = NVL (p_branch_cd, d.cred_branch)
                      AND a.batch_gacc_tran_id IN (
                             SELECT tran_id
                               FROM giac_acctrans
                              WHERE tran_class = 'PPR'
                                AND tran_flag <> 'D'
                                AND TRUNC (DECODE (p_date_type,
                                                   'P', posting_date,
                                                   'T', tran_date
                                                  )
                                          ) BETWEEN v_from_date AND v_to_date)
                 ORDER BY policy_no)
      LOOP
         v_rec.ref_no := i.ref_no;
         v_rec.date_decode := i.date_decode;
         v_rec.policy_no := i.policy_no;
         v_rec.assd_name := i.assd_name;
         v_rec.incept_date := i.incept_date;
         v_rec.expiry_date := i.expiry_date;
         v_rec.bill_no := i.bill_no;
         v_rec.premium_amt := i.premium_amt;
         v_rec.tax_amt := i.tax_amt;
         v_rec.booking_date := i.booking_date;
         v_rec.cred_branch := i.cred_branch;
         v_rec.evat :=
            cf_evatformula (p_branch_cd,
                            i.policy_no,
                            p_date_type,
                            p_from_date,
                            p_to_date,
                            i.ref_no
                           );

         FOR j IN (SELECT branch_name
                     FROM giac_branches
                    WHERE branch_cd = i.cred_branch)
         LOOP
            v_rec.branch_name := j.branch_name;
            EXIT;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END csv_giacr170a;
   
   FUNCTION cf_evatformula (
      p_branch_cd   VARCHAR2,
      p_policy_no   VARCHAR2,
      p_date_type   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_ref_no      VARCHAR2
   )
      RETURN NUMBER
   IS
      v_evat        NUMBER;
      v_from_date   DATE   := TO_DATE (p_from_date, 'MM/DD/YYYY');
      v_to_date     DATE   := TO_DATE (p_to_date, 'MM/DD/YYYY');

      CURSOR cur1
      IS
         SELECT DISTINCT get_policy_no (d.policy_id) policy_no,
                         g.tax_amt evat, get_ref_no (b.tran_id) ref_no
                    FROM giac_advanced_payt a,
                         giac_acctrans b,
                         giac_direct_prem_collns c,
                         gipi_polbasic d,
                         gipi_invoice e,
                         giac_tax_collns g,
                         giis_assured f
                   WHERE a.gacc_tran_id = b.tran_id
                     AND a.gacc_tran_id = c.gacc_tran_id
                     AND a.iss_cd = c.b140_iss_cd
                     AND a.prem_seq_no = c.b140_prem_seq_no
                     AND d.policy_id = e.policy_id
                     AND c.b140_iss_cd = e.iss_cd
                     AND c.b140_prem_seq_no = e.prem_seq_no
                     AND d.assd_no = f.assd_no
                     AND c.gacc_tran_id = g.gacc_tran_id
                     AND c.b140_iss_cd = g.b160_iss_cd
                     AND c.b140_prem_seq_no = g.b160_prem_seq_no
                     AND c.inst_no = g.inst_no
                     AND d.cred_branch = NVL (p_branch_cd, d.cred_branch)
                     AND g.b160_tax_cd = giacp.n ('EVAT')
                     AND get_policy_no (d.policy_id) = p_policy_no
                     AND a.batch_gacc_tran_id IN (
                            SELECT tran_id
                              FROM giac_acctrans
                             WHERE tran_class = 'PPR'
                               AND tran_flag <> 'D'
                               AND TRUNC (DECODE (p_date_type,
                                                  'T', tran_date,
                                                  'P', posting_date
                                                 )
                                         ) BETWEEN v_from_date AND v_to_date);

      evat          NUMBER := 0;
   BEGIN
      FOR a IN cur1
      LOOP
         IF a.policy_no = p_policy_no AND a.ref_no = p_ref_no
         THEN
            v_evat := a.evat;
         END IF;
      END LOOP;

      RETURN (v_evat);
   END;
   
   FUNCTION cf_1formula (p_tran_id giac_acctrans.tran_id%TYPE)
      RETURN tran_id_tab PIPELINED
   IS
      v_rec   tran_id_type;
   BEGIN
      FOR i IN (SELECT dv_pref || '-' || dv_no ref_no
                  FROM giac_disb_vouchers
                 WHERE gacc_tran_id = p_tran_id)
      LOOP
         v_rec.tran_id := i.ref_no;
         PIPE ROW (v_rec);
      END LOOP;

      FOR i IN (SELECT or_pref_suf || '-' || or_no ref_no
                  FROM giac_order_of_payts
                 WHERE gacc_tran_id = p_tran_id)
      LOOP
         v_rec.tran_id := i.ref_no;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_rec.tran_id IS NULL
      THEN
         FOR i IN (SELECT jv_pref_suff || '-' || jv_no ref_no
                     FROM giac_acctrans
                    WHERE tran_id = p_tran_id)
         LOOP
            v_rec.tran_id := i.ref_no;
            PIPE ROW (v_rec);
         END LOOP;
      END IF;
   END cf_1formula;

  --Added by Carlo Rubenecia SR-5354 04.29.2016 -start
  FUNCTION csv_giacr414 (
      p_branch_cd      VARCHAR2,
      p_module_id      VARCHAR2,
      p_post_tran_sw   VARCHAR2,
      p_report_id      VARCHAR2,
      p_from           VARCHAR2,
      p_to             VARCHAR2,
      p_user_id        GIIS_USERS.user_id%TYPE 
   )
      RETURN giacr414_tab PIPELINED
   IS
      v_list       giacr414_type;
      v_assd_no    NUMBER;
      v_par_id     NUMBER;
      v_line_cd    VARCHAR2 (5);
      v_peril_cd   gipi_comm_inv_peril.peril_cd%TYPE;
      v_exists     VARCHAR2(1) := 'N';
   BEGIN
   
      FOR i IN (SELECT   or_pref_suf || '-' || LPAD (or_no, 10, 0) or_no,
                         input_vat_amt, comm_amt, b.intm_no, a.gacc_tran_id,
                         a.or_date, b.iss_cd, LPAD (prem_seq_no, 12, 0) prem_seq_no 
                    FROM giac_order_of_payts a,
                         giac_comm_payts b,
                         giac_acctrans c
                   WHERE a.gacc_tran_id = b.gacc_tran_id
                     AND a.gacc_tran_id = c.tran_id
                     AND or_flag = 'P'
                     AND a.gibr_branch_cd =
                                           NVL (p_branch_cd, a.gibr_branch_cd)
                     /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                      a.gibr_branch_cd,
                                                      p_module_id,
                                                      p_user_id
                                                     ) = 1*/ --Comment out by pjsantos 11/24/2016, for optimization GENQA 5851
                     AND TRUNC (tran_date) BETWEEN TO_DATE (p_from,
                                                            'MM-DD-YYYY'
                                                           )
                                               AND TO_DATE (p_to,
                                                            'MM-DD-YYYY')
                     /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                      b.iss_cd,
                                                      p_module_id,
                                                      p_user_id
                                                     ) = 1*/ --Comment out by pjsantos 11/24/2016, replaced by codes below for optimization GENQA 5851
                     AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                                WHERE branch_cd = a.gibr_branch_cd) 
                ORDER BY iss_cd, prem_seq_no)
      LOOP
      
         v_list.issue_code := i.iss_cd;
         v_list.premium_sequence_no := i.prem_seq_no;
         v_list.or_no := i.or_no;
         v_list.input_vat_amount := TRIM(TO_CHAR(i.input_vat_amt, '999,999,999,990.00'));
         v_list.or_date := TO_CHAR (i.or_date, 'MM-DD-YYYY');
         v_list.commission_slip_amount := TRIM(TO_CHAR(i.comm_amt, '999,999,999,990.00'));
         BEGIN
            FOR chu IN (SELECT gci.policy_id, gci.premium_amt, gci.commission_amt --added premium_amt, commission_amt by pjsantos 11/24/2016, for optimization GENQA 5851
                          FROM gipi_comm_invoice gci
                         WHERE /*iss_cd || '-' || LPAD (prem_seq_no, 12, 0) =
                                                                     i.inv_no
                           AND check_user_per_iss_cd_acctg2 (NULL,
                                                            iss_cd,
                                                            p_module_id,
                                                            p_user_id
                                                           ) = 1*/ --Removed by pjsantos 11/24/2016, checking of security is already handled in main loop, for optimization GENQA 5851
                               gci.iss_cd      = i.iss_cd
                           AND gci.prem_seq_no = i.prem_seq_no)
            LOOP              
               /*Moved here by pjsantos 11/24/2016, for optimization GENQA 5851*/
               v_list.policy_no := get_policy_no (chu.policy_id); 
               v_list.premium_amount       := TRIM(TO_CHAR(chu.premium_amt, '999,999,999,990.00'));
               v_list.commission_amount    := TRIM(TO_CHAR(chu.commission_amt, '999,999,999,990.00'));
               --pjsantos end 
               
               BEGIN
                  /*  FOR ctr1 IN (SELECT par_id
                                 FROM gipi_polbasic
                                WHERE policy_id = chu.policy_id)
                  LOOP
                     v_par_id := ctr1.par_id;

                     FOR ctr2 IN (SELECT assd_no
                                    FROM gipi_parlist
                                   WHERE par_id = v_par_id)
                     LOOP
                        v_assd_no := ctr2.assd_no;

                        FOR ctr3 IN (SELECT assd_name
                                       FROM giis_assured
                                      WHERE assd_no = v_assd_no)
                        LOOP
                           v_list.assd_name := ctr3.assd_name;
                        END LOOP;
                     END LOOP;
                  END LOOP;*/--Replaced by code below by pjsantos 11/24/2016, for optimization GENQA 5851     
                     SELECT a.assd_no, a.assd_name
                       INTO v_list.assured_no, v_list.assured_name
                       FROM giis_assured a, 
                            gipi_polbasic b, 
                            gipi_parlist c
                      WHERE a.assd_no   = c.assd_no
                        AND b.par_id    = c.par_id
                        AND b.policy_id = chu.policy_id;  
                     EXCEPTION 
                           WHEN NO_DATA_FOUND
                            THEN      
                              v_list.assured_no   := NULL;
                              v_list.assured_name := NULL;
               END;

               /*BEGIN
                  FOR rec IN
                     (SELECT get_policy_no (chu.policy_id) v_policy_no
                        FROM DUAL)
                  LOOP
                     v_list.policy_no := rec.v_policy_no;
                  END LOOP;
               END;

               BEGIN
                  FOR rec IN (SELECT premium_amt
                                FROM gipi_comm_invoice
                               WHERE policy_id = chu.policy_id)
                  LOOP
                     v_list.premium_amount := TRIM(TO_CHAR(rec.premium_amt, '999,999,999,990.00'));
                  END LOOP;
               END;*/ --Moved code above in loop chu by pjsantos 11/24/2016, for optimization GENQA 5851 

               BEGIN
                  /*FOR ctr1 IN (SELECT line_cd
                                 FROM gipi_polbasic
                                WHERE policy_id = chu.policy_id)
                  LOOP
                     v_line_cd := ctr1.line_cd;

                     FOR ctr2 IN (SELECT peril_cd
                                    FROM gipi_comm_inv_peril
                                   WHERE    iss_cd
                                         || '-'
                                         || LPAD (prem_seq_no, 12, 0) =
                                                                       i.iss_cd || '-' || LPAD (i.prem_seq_no, 12, 0))
                     LOOP
                        v_peril_cd := ctr2.peril_cd;

                        FOR ctr3 IN (SELECT peril_sname, peril_cd
                                       FROM giis_peril
                                      WHERE peril_cd = v_peril_cd
                                        AND line_cd = v_line_cd)
                        LOOP
                           v_list.peril_short_name := ctr3.peril_sname;
                           v_list.peril_code := ctr3.peril_cd;
                        END LOOP;
                     END LOOP;
                  END LOOP;*/ 
                  --Replaced by code below by pjsantos 11/24/2016, for optimization GENQA 5851
                  SELECT a.peril_sname, a.peril_cd
                    INTO v_list.peril_short_name, v_list.peril_code
                    FROM giis_peril a,
                         gipi_comm_inv_peril b,
                         gipi_polbasic c
                   WHERE a.peril_cd = b.peril_cd
                     AND a.line_cd  = c.line_cd
                     AND b.iss_cd   = i.iss_cd
                     AND b.prem_seq_no = i.prem_seq_no
                     AND c.policy_id   = chu.policy_id
                     AND ROWNUM = 1
                ORDER BY b.prem_seq_no DESC;
                  EXCEPTION
                        WHEN NO_DATA_FOUND
                         THEN
                            v_list.peril_short_name := NULL; 
                            v_list.peril_code := NULL;                   
               END;

               /*BEGIN
                  FOR rec IN (SELECT commission_amt
                                FROM gipi_comm_invoice
                               WHERE policy_id = chu.policy_id)
                  LOOP
                     v_list.commission_amount := TRIM(TO_CHAR(rec.commission_amt, '999,999,999,990.00'));
                  END LOOP;
               END;*/ --Moved code above in loop chu by pjsantos 11/24/2016, for optimization GENQA 5851 
            END LOOP;
         END;

         BEGIN
            v_list.commission_slip_number := null;
            v_list.commission_slip_date := null;
            FOR rec IN (SELECT comm_slip_date, comm_slip_no
                          FROM giac_comm_slip_ext d
                         WHERE d.gacc_tran_id = i.gacc_tran_id
                           AND d.iss_cd = i.iss_cd
                           AND d.prem_seq_no = i.prem_seq_no
                           AND d.intm_no = i.intm_no)
            LOOP
               v_list.commission_slip_number := rec.comm_slip_no;
               v_list.commission_slip_date := TO_CHAR (rec.comm_slip_date, 'MM-DD-YYYY');
            END LOOP;
         END;

         BEGIN
            FOR ctr1 IN (SELECT intm_type, intm_no, intm_name
                           FROM giis_intermediary
                          WHERE intm_no = i.intm_no)
            LOOP
               v_list.intermediary_type := ctr1.intm_type;
               v_list.intermediary_no := ctr1.intm_no;
               v_list.intermediary_name := ctr1.intm_name;
            END LOOP;
         END;

         PIPE ROW (v_list);
      END LOOP;


      RETURN;
   END csv_giacr414;
   --Added by Carlo Rubenecia SR-5354 04.29.2016 -end

END CSV_AC_RCPT_REPORTS;
/
