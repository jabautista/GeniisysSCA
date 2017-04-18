CREATE OR REPLACE PACKAGE BODY CPI.extract_records
AS
   PROCEDURE extract_records_affected (p_iss_cd VARCHAR2, p_prem_seq_no NUMBER)
   IS
      v_evat_due         giac_tax_collns.tax_amt%TYPE;
      v_ref_no           VARCHAR2 (100);
      v_evat_should_be   giac_tax_collns.tax_amt%TYPE;
      v_evat_discrep     giac_tax_collns.tax_amt%TYPE;
      v_count_payt       NUMBER                                        := 0;
      v_max_inst         gipi_installment.inst_no%TYPE;
      v_collection_amt   giac_direct_prem_collns.collection_amt%TYPE;
      v_premium_amt      giac_direct_prem_collns.premium_amt%TYPE;
      v_tax_amt          giac_direct_prem_collns.tax_amt%TYPE;
      v_sum_tax_colln    giac_tax_collns.tax_amt%TYPE;
      v_fund_cd          VARCHAR2 (5)                  := giacp.v ('FUND_CD');
      v_with_tax_colln   VARCHAR2 (1)                                  := 'N';
      v_new_bill         VARCHAR2 (18)                           := 'XXXXXXX';
      v_last_bill        VARCHAR2 (18)                           := 'YYYYYYY';
      v_test             NUMBER                                        := 0;
      v_tax_endt         VARCHAR2 (1)                                  := 'N';
      v_prem_paid     giac_direct_prem_collns.premium_amt%TYPE;
      v_tax_paid         giac_direct_prem_collns.tax_amt%TYPE;
      v_prem_inv         gipi_installment.prem_amt%TYPE;
      v_tax_inv          gipi_installment.tax_amt%TYPE;
      v_taxes_inv        gipi_inv_tax.tax_amt%TYPE;
      v_taxes_paid       giac_tax_collns.tax_amt%TYPE;
      v_soa              giac_aging_soa_details.balance_amt_due%TYPE;
   BEGIN
      DELETE FROM dummy2_direct_prem_collns;

      DELETE FROM dummy2_giac_tax_collns;

      FOR r IN
         (SELECT assd_name, get_policy_no (a.policy_id) policy_no,
                 a.iss_cd || '-' || a.prem_seq_no bill_no, a.iss_cd,
                 a.prem_seq_no, a.prem_amt, a.tax_amt, a.currency_rt,
                 b.inst_no, b.balance_amt_due, b.prem_balance_due,
                 b.tax_balance_due, a.policy_id
            FROM gipi_invoice a,
                 giac_aging_soa_details b,
                 gipi_polbasic c,
                 giis_assured f,
                 gipi_parlist g,
                 gipi_installment d
           WHERE a.policy_id = b.policy_id
             AND b.policy_id = c.policy_id
             AND c.policy_id <> '5'
             AND c.par_id = g.par_id
             AND g.assd_no = f.assd_no
             AND b.iss_cd = d.iss_cd
             AND b.prem_seq_no = d.prem_seq_no
             AND b.inst_no = d.inst_no
             -- MILDRED
--             AND NOT EXISTS (
--                    SELECT DISTINCT 1
--                               FROM gipi_installment x,
--                                    giac_aging_soa_details y
--                              WHERE x.iss_cd = y.iss_cd
--                                AND x.prem_seq_no = y.prem_seq_no
--                                AND x.inst_no = y.inst_no
--                                AND balance_amt_due = 0
--                                AND prem_balance_due = 0
--                                AND tax_balance_due = 0
--                                AND x.iss_cd = b.iss_cd
--                                AND x.prem_seq_no = b.prem_seq_no
--                                AND x.inst_no = b.inst_no)  --mikel 01.02.2013
                             --HAVING COUNT (*) <> 1
                           --GROUP BY x.iss_cd, x.prem_seq_no)
---
             --AND a.iss_cd = 'HO'
             --AND a.prem_seq_no = 27361
             AND EXISTS (
                    SELECT DISTINCT 'Y'
                               FROM (SELECT iss_cd, prem_seq_no, policy_id,
                                            ROUND (prem_amt * currency_rt,
                                                   2
                                                  ) gi_prem_amt,
                                            ROUND (tax_amt * currency_rt,
                                                   2
                                                  ) gi_tax_amt
                                       FROM gipi_invoice) yy,
                                    (SELECT   iss_cd, prem_seq_no,
                                              SUM (prem_amt) ginst_prem,
                                              SUM (tax_amt) ginst_tax
                                         FROM gipi_installment
                                     GROUP BY iss_cd, prem_seq_no) zz
                              WHERE yy.iss_cd = zz.iss_cd
                                AND yy.prem_seq_no = zz.prem_seq_no
                                AND yy.gi_prem_amt + yy.gi_tax_amt =
                                                  zz.ginst_prem + zz.ginst_tax
                                AND yy.iss_cd = a.iss_cd
                                AND yy.prem_seq_no = a.prem_seq_no)
             AND EXISTS (
                    SELECT DISTINCT 'Z'
                               FROM giac_direct_prem_collns gd,
                                    giac_acctrans ga
                              WHERE gd.gacc_tran_id = ga.tran_id
                                AND ga.tran_flag <> 'D'
                                AND ga.tran_class <> 'CP'
                                AND TRUNC (ga.tran_date) >= '01-jan-2012'
                                AND gd.b140_iss_cd = d.iss_cd
                                AND gd.b140_prem_seq_no = d.prem_seq_no
                                AND gd.inst_no = d.inst_no
                                AND NOT EXISTS (
                                       SELECT 'A'
                                         FROM giac_reversals v,
                                              giac_acctrans w
                                        WHERE v.reversing_tran_id = w.tran_id
                                          AND w.tran_flag <> 'D'
                                          AND v.gacc_tran_id = gd.gacc_tran_id))
             AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
             AND a.prem_seq_no = NVL (p_prem_seq_no, a.prem_seq_no))
      LOOP
         BEGIN
            SELECT   SUM (tax_amt) evat_due
                INTO v_evat_due
                FROM gipi_inv_tax
               WHERE tax_cd = giacp.n ('EVAT')
                 AND tax_amt <> 0
                 AND iss_cd = r.iss_cd
                 AND prem_seq_no = r.prem_seq_no
            GROUP BY iss_cd, prem_seq_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_evat_due := 0;
         END;

         SELECT SUM (ROUND (a.tax_amt * b.currency_rt, 2))
           INTO v_taxes_inv
           FROM gipi_inv_tax a, gipi_invoice b
          WHERE a.iss_cd = b.iss_cd
            AND a.prem_seq_no = b.prem_seq_no
            AND a.iss_cd = r.iss_cd
            AND a.prem_seq_no = r.prem_seq_no;

         SELECT SUM (tax_amt)
           INTO v_taxes_paid
           FROM giac_tax_collns a, giac_acctrans b
          WHERE 1 = 1
            AND a.gacc_tran_id = b.tran_id
            AND b.tran_flag <> 'D'
            AND NOT EXISTS (
                   SELECT 'X'
                     FROM giac_reversals x, giac_acctrans y
                    WHERE x.reversing_tran_id = y.tran_id
                      AND y.tran_flag <> 'D'
                      AND x.gacc_tran_id = a.gacc_tran_id)
            AND b160_iss_cd = r.iss_cd
            AND b160_prem_seq_no = r.prem_seq_no;

         SELECT SUM (premium_amt), SUM (tax_amt)
           INTO v_prem_paid, v_tax_paid
           FROM giac_direct_prem_collns a, giac_acctrans b
          WHERE 1 = 1
            AND a.gacc_tran_id = b.tran_id
            AND b.tran_flag <> 'D'
            AND NOT EXISTS (
                   SELECT 'X'
                     FROM giac_reversals x, giac_acctrans y
                    WHERE x.reversing_tran_id = y.tran_id
                      AND y.tran_flag <> 'D'
                      AND x.gacc_tran_id = a.gacc_tran_id)
            AND b140_iss_cd = r.iss_cd
            AND b140_prem_seq_no = r.prem_seq_no
            AND inst_no = r.inst_no;

         SELECT ROUND (a.prem_amt * b.currency_rt, 2),
                ROUND (a.tax_amt * b.currency_rt, 2)
           INTO v_prem_inv,
                v_tax_inv
           FROM gipi_installment a, gipi_invoice b
          WHERE a.iss_cd = b.iss_cd
            AND a.prem_seq_no = b.prem_seq_no
            AND a.iss_cd = r.iss_cd
            AND a.prem_seq_no = r.prem_seq_no
            AND a.inst_no = r.inst_no;
            
         SELECT balance_amt_due + prem_balance_due + tax_balance_due
           INTO v_soa
           FROM giac_aging_soa_details
          WHERE iss_cd = r.iss_cd
            AND prem_seq_no = r.prem_seq_no
            AND inst_no = r.inst_no;    

         SELECT MAX (inst_no)
           INTO v_max_inst
           FROM gipi_installment
          WHERE iss_cd = r.iss_cd 
            AND prem_seq_no = r.prem_seq_no;
         
         v_tax_endt := 'N';
         --check if tax_endt (vat); if yes, do not include.
         IF v_evat_due <> 0 AND r.prem_amt = 0
         THEN
            BEGIN
               SELECT 'Y'
                 INTO v_tax_endt
                 FROM gipi_endttext
                WHERE policy_id = r.policy_id AND endt_tax = 'Y';
            --mikel 01.03.2012 pcic
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_tax_endt := 'N';
            END;
         END IF;

         v_evat_should_be := 0;
         v_evat_discrep := 0;
         v_count_payt := 0;
         v_new_bill := r.iss_cd || '-' || r.prem_seq_no || '-' || r.inst_no;

         IF v_last_bill <> v_new_bill
         THEN
            v_test := 0;
         END IF;

         IF     ABS (v_taxes_inv - v_tax_paid) BETWEEN 0 AND 0.01
            AND  v_soa = 0
         THEN                                                 --mikel 01082012
            NULL;
         ELSE
            IF     v_evat_due <> 0
               AND ROUND (ROUND (r.prem_amt * r.currency_rt, 2) * .12, 2) =
                                         ROUND (v_evat_due * r.currency_rt, 2)
               AND v_tax_endt = 'N'
            THEN
               FOR colln IN
                  (SELECT   get_ref_no (y.gacc_tran_id) ref_no,
                            y.transaction_type, y.collection_amt,
                            premium_amt, tax_amt, (NVL (l.evat, 0)) evat,
                            NVL (x.or_date, z.tran_date) or_date,
                            z.posting_date, y.user_id, y.last_update,
                            y.gacc_tran_id, y.b140_iss_cd,
                            y.b140_prem_seq_no, y.inst_no
                       FROM giac_direct_prem_collns y,
                            giac_order_of_payts x,
                            giac_acctrans z,
                            (SELECT   SUM (k.tax_amt) evat, k.gacc_tran_id,
                                      k.b160_iss_cd, k.b160_prem_seq_no,
                                      k.inst_no
                                 FROM giac_tax_collns k
                                WHERE k.b160_tax_cd = giacp.n ('EVAT')
                             GROUP BY k.gacc_tran_id,
                                      k.b160_iss_cd,
                                      k.b160_prem_seq_no,
                                      k.inst_no) l
                      WHERE y.gacc_tran_id = z.tran_id
                        AND y.gacc_tran_id = x.gacc_tran_id(+)
                        AND l.gacc_tran_id(+) = y.gacc_tran_id
                        AND l.b160_prem_seq_no(+) = y.b140_prem_seq_no
                        AND l.b160_iss_cd(+) = y.b140_iss_cd
                        AND l.inst_no(+) = y.inst_no
                        AND z.tran_flag <> 'D'
                        AND z.tran_class <> 'CP'
                        --AND TRUNC (z.tran_date) >= '01-jan-2012'
                        AND NOT EXISTS (
                               SELECT 'Z'
                                 FROM giac_reversals v, giac_acctrans w
                                WHERE v.reversing_tran_id = w.tran_id
                                  AND w.tran_flag <> 'D'
                                  AND v.gacc_tran_id = y.gacc_tran_id)
                        AND y.b140_iss_cd = r.iss_cd
                        AND y.b140_prem_seq_no = r.prem_seq_no
                        AND y.inst_no = r.inst_no
                   ORDER BY y.gacc_tran_id)
               LOOP
                  --v_test := v_test + 1;
                  IF ABS ((colln.evat - ROUND (colln.premium_amt * .12, 2))) >
                                                                          .02
                  THEN
                     v_test := v_test + 1;                 --mikel 01.02.2013

                     FOR prem IN (SELECT *
                                    FROM giac_direct_prem_collns
                                   WHERE gacc_tran_id = colln.gacc_tran_id
                                     AND b140_iss_cd = colln.b140_iss_cd
                                     AND b140_prem_seq_no =
                                                        colln.b140_prem_seq_no
                                     AND inst_no = colln.inst_no)
                     LOOP
                        INSERT INTO dummy2_direct_prem_collns
                                    (gacc_tran_id,
                                     transaction_type,
                                     b140_iss_cd,
                                     b140_prem_seq_no,
                                     collection_amt, premium_amt,
                                     tax_amt, inst_no, or_print_tag,
                                     currency_cd, convert_rate,
                                     foreign_curr_amt, user_id, last_update,
                                     prem_vatable, prem_vat_exempt,
                                     prem_zero_rated--, script_exclude_tag
                                    )
                             VALUES (prem.gacc_tran_id,
                                     prem.transaction_type,
                                     prem.b140_iss_cd,
                                     prem.b140_prem_seq_no,
                                     prem.collection_amt, prem.premium_amt,
                                     prem.tax_amt, prem.inst_no, 'N',
                                     1, 1,
                                     prem.collection_amt, USER, SYSDATE,
                                     prem.premium_amt, 0,
                                     0--, v_test
                                    );
                     END LOOP;

                     FOR inst IN (SELECT *
                                    FROM giac_tax_collns
                                   WHERE gacc_tran_id = colln.gacc_tran_id
                                     AND b160_iss_cd = colln.b140_iss_cd
                                     AND b160_prem_seq_no =
                                                        colln.b140_prem_seq_no
                                     AND inst_no = colln.inst_no)
                     LOOP
                        v_with_tax_colln := 'Y';

                        INSERT INTO dummy2_giac_tax_collns
                                    (gacc_tran_id,
                                     transaction_type,
                                     b160_iss_cd,
                                     b160_prem_seq_no,
                                     b160_tax_cd, tax_amt,
                                     fund_cd,
                                     remarks,
                                     user_id, last_update, inst_no--,
                                     --script_exclude_tag
                                    )
                             VALUES (inst.gacc_tran_id,
                                     inst.transaction_type,
                                     inst.b160_iss_cd,
                                     inst.b160_prem_seq_no,
                                     inst.b160_tax_cd, inst.tax_amt,
                                     inst.fund_cd,
                                     'To insert tax collections for reversal of bills with incorrect allocation of premium and tax.',
                                     USER, SYSDATE, inst.inst_no--,
                                    -- v_test
                                    );
                     END LOOP;

                     IF v_with_tax_colln = 'N'
                     THEN
                        FOR insert_tax IN (SELECT *
                                             FROM gipi_inv_tax
                                            WHERE iss_cd = colln.b140_iss_cd
                                              AND prem_seq_no =
                                                        colln.b140_prem_seq_no)
                        LOOP
                           INSERT INTO dummy2_giac_tax_collns
                                       (gacc_tran_id,
                                        transaction_type,
                                        b160_iss_cd,
                                        b160_prem_seq_no,
                                        b160_tax_cd, tax_amt, fund_cd,
                                        remarks,
                                        user_id, last_update, inst_no--,
                                        --script_exclude_tag
                                       )
                                VALUES (colln.gacc_tran_id,
                                        colln.transaction_type,
                                        colln.b140_iss_cd,
                                        colln.b140_prem_seq_no,
                                        insert_tax.tax_cd, 0, v_fund_cd,
                                        'To insert tax collections for reversal of bills with incorrect allocation of premium and tax.',
                                        USER, SYSDATE, colln.inst_no--,
                                        --v_test
                                       );
                        END LOOP;
                     END IF;
                  END IF;

                  v_last_bill :=
                        colln.b140_iss_cd
                     || '-'
                     || colln.b140_prem_seq_no
                     || '-'
                     || colln.inst_no;
               END LOOP;                                               --colln
            END IF;                                            --if v_evat_due
         END IF;
      END LOOP;                                                            --r
   END;

   FUNCTION get_records_affected
      RETURN gra_type PIPELINED
   IS
      v_crr              crr_gra_type;
      v_last_bill        VARCHAR2 (4000);
      v_evat_due         giac_tax_collns.tax_amt%TYPE;
      v_ref_no           VARCHAR2 (100);
      v_evat_should_be   giac_tax_collns.tax_amt%TYPE;
      v_evat_discrep     giac_tax_collns.tax_amt%TYPE;
      v_count_payt       NUMBER                                        := 0;
      v_max_inst         gipi_installment.inst_no%TYPE;
      v_collection_amt   giac_direct_prem_collns.collection_amt%TYPE;
      v_premium_amt      giac_direct_prem_collns.premium_amt%TYPE;
      v_tax_amt          giac_direct_prem_collns.tax_amt%TYPE;
      v_sum_tax_colln    giac_tax_collns.tax_amt%TYPE;
      v_fund_cd          VARCHAR2 (5)                  := giacp.v ('FUND_CD');
   BEGIN
      FOR r IN
         (SELECT assd_name, get_policy_no (a.policy_id) policy_no,
                 a.iss_cd || '-' || a.prem_seq_no bill_no, a.iss_cd,
                 a.prem_seq_no, a.prem_amt, a.tax_amt, a.currency_rt,
                 b.inst_no, b.balance_amt_due, b.prem_balance_due,
                 b.tax_balance_due,  e.gacc_tran_id
            FROM gipi_invoice a,
                 giac_aging_soa_details b,
                 gipi_polbasic c,
                 giis_assured f,
                 gipi_parlist g,
                 gipi_installment d,
                 dummy2_direct_prem_collns e
           WHERE a.policy_id = b.policy_id
             AND b.policy_id = c.policy_id
             AND c.policy_id <> '5'
             AND c.par_id = g.par_id
             AND g.assd_no = f.assd_no
             AND b.iss_cd = d.iss_cd
             AND b.prem_seq_no = d.prem_seq_no
             AND b.inst_no = d.inst_no
             AND d.iss_cd = e.b140_iss_cd
             AND d.prem_seq_no = e.b140_prem_seq_no
             AND d.inst_no = e.inst_no
--             AND a.iss_cd = 'HO'
--             AND a.prem_seq_no = 163225
             AND EXISTS (
                    SELECT DISTINCT 'Y'
                               FROM (SELECT iss_cd, prem_seq_no, policy_id,
                                            ROUND (prem_amt * currency_rt,
                                                   2
                                                  ) gi_prem_amt,
                                            ROUND (tax_amt * currency_rt,
                                                   2
                                                  ) gi_tax_amt
                                       FROM gipi_invoice) yy,
                                    (SELECT   iss_cd, prem_seq_no,
                                              SUM (prem_amt) ginst_prem,
                                              SUM (tax_amt) ginst_tax
                                         FROM gipi_installment
                                     GROUP BY iss_cd, prem_seq_no) zz
                              WHERE yy.iss_cd = zz.iss_cd
                                AND yy.prem_seq_no = zz.prem_seq_no
                                AND yy.gi_prem_amt + yy.gi_tax_amt =
                                                  zz.ginst_prem + zz.ginst_tax
                                AND yy.iss_cd = a.iss_cd
                                AND yy.prem_seq_no = a.prem_seq_no)
             AND EXISTS (
                    SELECT DISTINCT 'Z'
                               FROM giac_direct_prem_collns gd,
                                    giac_acctrans ga
                              WHERE gd.gacc_tran_id = ga.tran_id
                                AND ga.tran_flag <> 'D'
                                AND ga.tran_class <> 'CP'
                                --AND TRUNC (ga.tran_date) >= '01-jan-2012'
                                AND gd.b140_iss_cd = d.iss_cd
                                AND gd.b140_prem_seq_no = d.prem_seq_no
                                AND gd.inst_no = d.inst_no
                                AND NOT EXISTS (
                                       SELECT 'A'
                                         FROM giac_reversals v,
                                              giac_acctrans w
                                        WHERE v.reversing_tran_id = w.tran_id
                                          AND w.tran_flag <> 'D'
                                          AND v.gacc_tran_id = gd.gacc_tran_id)))
      LOOP
         BEGIN
            SELECT   SUM (tax_amt) evat_due
                INTO v_evat_due
                FROM gipi_inv_tax
               WHERE tax_cd = giacp.n ('EVAT')
                 AND tax_amt <> 0
                 AND iss_cd = r.iss_cd
                 AND prem_seq_no = r.prem_seq_no
            GROUP BY iss_cd, prem_seq_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_evat_due := 0;
         END;

         SELECT MAX (inst_no)
           INTO v_max_inst
           FROM gipi_installment
          WHERE iss_cd = r.iss_cd AND prem_seq_no = r.prem_seq_no;

         v_evat_should_be := 0;
         v_evat_discrep := 0;
         v_count_payt := 0;
         v_collection_amt := 0;
         v_premium_amt := 0;
         v_tax_amt := 0;
         v_sum_tax_colln := 0;

         SELECT   SUM (collection_amt), SUM (premium_amt), SUM (tax_amt)
             INTO v_collection_amt, v_premium_amt, v_tax_amt
             FROM dummy2_direct_prem_collns
            WHERE b140_iss_cd = r.iss_cd
              AND b140_prem_seq_no = r.prem_seq_no
              AND inst_no = r.inst_no
         GROUP BY b140_iss_cd, b140_prem_seq_no, inst_no;

         BEGIN
            SELECT   SUM (tax_amt) tax_amt
                INTO v_sum_tax_colln
                FROM dummy2_giac_tax_collns
               WHERE b160_iss_cd = r.iss_cd
                 AND b160_prem_seq_no = r.prem_seq_no
                 AND inst_no = r.inst_no
            GROUP BY b160_iss_cd, b160_prem_seq_no, inst_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_sum_tax_colln := 0;
         END;

         IF     v_evat_due <> 0
            AND ROUND (ROUND (r.prem_amt * r.currency_rt, 2) * .12, 2) =
                                         ROUND (v_evat_due * r.currency_rt, 2)
         THEN
            --IF (v_collection_amt <> 0 AND (v_premium_amt + v_tax_amt) <> 0)
            --THEN
            FOR colln IN
               (SELECT get_ref_no (y.gacc_tran_id) ref_no,
                       y.transaction_type, y.inst_no, y.collection_amt,
                       premium_amt, tax_amt, (NVL (l.evat, 0)) evat,
                       NVL (x.or_date, z.tran_date) or_date, z.posting_date,
                       y.user_id, y.last_update, y.gacc_tran_id, b140_iss_cd,
                       b140_prem_seq_no
                  FROM giac_direct_prem_collns y,
                       giac_order_of_payts x,
                       giac_acctrans z,
                       (SELECT   SUM (k.tax_amt) evat, k.gacc_tran_id,
                                 k.b160_iss_cd, k.b160_prem_seq_no, k.inst_no
                            FROM giac_tax_collns k
                           WHERE k.b160_tax_cd = giacp.n ('EVAT')
                        GROUP BY k.gacc_tran_id,
                                 k.b160_iss_cd,
                                 k.b160_prem_seq_no,
                                 k.inst_no) l
                 WHERE y.gacc_tran_id = z.tran_id
                   AND y.gacc_tran_id = x.gacc_tran_id(+)
                   AND l.gacc_tran_id(+) = y.gacc_tran_id
                   AND l.b160_prem_seq_no(+) = y.b140_prem_seq_no
                   AND l.b160_iss_cd(+) = y.b140_iss_cd
                   AND l.inst_no(+) = y.inst_no
                   AND z.tran_flag <> 'D'
                   AND z.tran_class <> 'CP'
                   --AND TRUNC (z.tran_date) >= '01-jan-2012'
                   AND NOT EXISTS (
                          SELECT 'Z'
                            FROM giac_reversals v, giac_acctrans w
                           WHERE v.reversing_tran_id = w.tran_id
                             AND w.tran_flag <> 'D'
                             AND v.gacc_tran_id = y.gacc_tran_id)
                   AND y.b140_iss_cd = r.iss_cd
                   AND y.b140_prem_seq_no = r.prem_seq_no
                   AND y.inst_no = r.inst_no
                   AND y.gacc_tran_id = r.gacc_tran_id)                 --test
            LOOP
               v_evat_should_be := ROUND (colln.premium_amt * .12, 2);
               v_evat_discrep := v_evat_should_be - colln.evat;

               IF ABS ((colln.evat - ROUND (colln.premium_amt * .12, 2))) >
                                                                          .01
               THEN
                  v_count_payt := v_count_payt + 1;

                  /*IF v_evat_due = colln.evat
                  THEN
                     v_evat_should_be := v_evat_due;
                     v_evat_discrep := colln.evat - v_evat_due;
                  ELS*/
                  IF     ABS (v_evat_due) - ABS (v_evat_should_be) < 0
                     AND v_count_payt = 1
                  THEN
                     v_evat_should_be := v_evat_due;
                     v_evat_discrep := colln.evat - v_evat_due;
                  ELSE
                     v_evat_should_be := v_evat_should_be;
                     v_evat_discrep := v_evat_discrep;
                  END IF;

                  IF (   (v_max_inst <> 1)
                      OR (v_max_inst = 1 AND v_evat_discrep <> 0)
                     )
--                  IF v_evat_discrep <> 0
                  THEN
                     v_crr.evat_should_be := v_evat_should_be;
                     v_crr.evat_discrep := v_evat_discrep;
                     v_crr.assured_name := r.assd_name;
                     v_crr.policy_no := r.policy_no;
                     v_crr.invoice_no := r.bill_no;
                     v_crr.inv_prem := r.prem_amt;
                     v_crr.inv_tax := r.tax_amt;
                     v_crr.inv_evat := v_evat_due;
                     v_crr.reference_no := colln.ref_no;
                     v_crr.inst_no := colln.inst_no;
                     v_crr.collection_amt := colln.collection_amt;
                     v_crr.prem_paid := colln.premium_amt;
                     v_crr.tax_paid := colln.tax_amt;
                     v_crr.evat_paid := colln.evat;
                     v_crr.or_date := colln.or_date;
                     v_crr.posting_date := colln.posting_date;
                     v_crr.iss_cd := r.iss_cd;
                     v_crr.prem_seq_no := r.prem_seq_no;
                     v_crr.gacc_tran_id := colln.gacc_tran_id;
                     v_crr.user_id := colln.user_id;
                     v_crr.last_update := colln.last_update;
                     v_crr.bal_amt_due := r.balance_amt_due;
                     v_crr.prem_bal_due := r.prem_balance_due;
                     v_crr.tax_bal_due := r.tax_balance_due;
                     v_crr.transaction_type := colln.transaction_type;
                     --v_crr.script_exclude_tag := r.script_exclude_tag;

                     IF v_max_inst = 1
                     THEN
                        v_crr.payment_term := 'STRAIGHT';
                     ELSE
                        v_crr.payment_term := 'INSTALLMENT';
                     END IF;

                     PIPE ROW (v_crr);
                  END IF;
               END IF;
            END LOOP;
         --END IF;
         END IF;
      END LOOP;

      RETURN;
   END get_records_affected;
END extract_records;
/


DROP PACKAGE BODY CPI.EXTRACT_RECORDS;
