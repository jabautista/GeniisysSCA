CREATE OR REPLACE PACKAGE BODY CPI.pivot_records
AS
   FUNCTION partially_paid (
      p_display       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_prem_seq_no   NUMBER
   )
      RETURN mikel_type PIPELINED
   IS
      v_crr         crr_mikel_type;
      v_last_bill   VARCHAR2 (4000);
   BEGIN
      FOR r IN
         (SELECT   'STRAIGHT' payt_term, assd_name,
                   get_policy_no (a.policy_id) policy_no,
                   get_ref_no (d.gacc_tran_id) ref_no,
                   a.iss_cd || '-' || a.prem_seq_no bill_no,
                   b.inst_no inst_no, b.balance_amt_due bal_amt_due,
                   b.prem_balance_due prem_bal_due,
                   b.tax_balance_due tax_bal_due,
                   ROUND (a.prem_amt * a.currency_rt, 2) inv_prem,
                   ROUND (a.tax_amt * a.currency_rt, 2) inv_tax,
                   d.prem_amt prem_paid, d.tax_amt tax_paid,
                   ROUND (e.evat_due * a.currency_rt, 2) inv_evat,
                   d.evat evat_paid,
                   ROUND (d.prem_amt * .12, 2) evat_should_be,
                   d.evat - ROUND (d.prem_amt * .12, 2) evat_discrep,
                   comm_due inv_comm, NVL (comm_paid, 0) comm_paid,
                   NVL (comm_paid, 0) - comm_due comm_discrep, d.user_id,
                   d.last_update, d.gacc_tran_id, d.transaction_type,
                   d.collection_amt, a.iss_cd, a.prem_seq_no, d.or_date,
                   d.posting_date
              FROM gipi_invoice a,
                   giac_aging_soa_details b,
                   gipi_polbasic c,
                   giis_assured f,
                   gipi_parlist g,
                   (SELECT y.gacc_tran_id, y.transaction_type,
                           y.b140_iss_cd iss_cd,
                           y.b140_prem_seq_no prem_seq_no, y.user_id,
                           y.last_update, y.collection_amt,
                           (premium_amt) prem_amt, (tax_amt) tax_amt,
                           (NVL (l.evat, 0)) evat,
                           NVL (x.or_date, z.tran_date) or_date,
                           z.posting_date
                      FROM giac_direct_prem_collns y,
                           giac_order_of_payts x,
                           giac_acctrans z,
                           (SELECT   SUM (k.tax_amt) evat, k.gacc_tran_id,
                                     k.b160_iss_cd, k.b160_prem_seq_no
                                FROM giac_tax_collns k
                               WHERE k.b160_tax_cd = giacp.n ('EVAT')
                            GROUP BY k.gacc_tran_id,
                                     k.b160_iss_cd,
                                     k.b160_prem_seq_no) l
                     WHERE y.gacc_tran_id = z.tran_id
                       AND y.gacc_tran_id = x.gacc_tran_id(+)
                       AND l.gacc_tran_id(+) = y.gacc_tran_id
                       AND l.b160_prem_seq_no(+) = y.b140_prem_seq_no
                       AND l.b160_iss_cd(+) = y.b140_iss_cd
                       AND z.tran_flag <> 'D'
                       AND NOT EXISTS (
                              SELECT 'Z'
                                FROM giac_reversals v, giac_acctrans w
                               WHERE v.reversing_tran_id = w.tran_id
                                 AND w.tran_flag <> 'D'
                                 AND v.gacc_tran_id = y.gacc_tran_id)) d,
                   (SELECT   SUM (tax_amt) evat_due, iss_cd, prem_seq_no
                        FROM gipi_inv_tax
                       WHERE tax_cd = giacp.n ('EVAT') AND tax_amt <> 0
                    GROUP BY iss_cd, prem_seq_no) e,
                   (SELECT   s.iss_cd, s.prem_seq_no,
                             SUM (NVL (comm_amt, 0)) comm_paid
                        FROM giac_comm_payts s, giac_acctrans t
                       WHERE s.gacc_tran_id = t.tran_id
                         AND t.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = s.gacc_tran_id)
                    GROUP BY s.iss_cd, s.prem_seq_no) comm,
                   (SELECT   g.iss_cd, g.prem_seq_no,
                             ROUND (SUM (g.commission_amt * h.currency_rt),
                                    2
                                   ) comm_due
                        FROM gipi_comm_invoice g, gipi_invoice h
                       WHERE g.iss_cd = h.iss_cd
                         AND g.prem_seq_no = h.prem_seq_no
                    GROUP BY g.iss_cd, g.prem_seq_no) comm_due
             WHERE a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND c.policy_id <> '5'
               AND a.iss_cd = d.iss_cd
               AND a.prem_seq_no = d.prem_seq_no
               AND a.iss_cd = e.iss_cd
               AND a.prem_seq_no = e.prem_seq_no
               AND c.par_id = g.par_id
               AND g.assd_no = f.assd_no
               AND b.iss_cd = comm.iss_cd(+)
               AND b.prem_seq_no = comm.prem_seq_no(+)
               AND b.iss_cd = comm_due.iss_cd
               AND b.prem_seq_no = comm_due.prem_seq_no
               AND b.balance_amt_due <> 0
               AND b.prem_balance_due <> 0
               AND ABS ((d.evat - ROUND (d.prem_amt * .12, 2))) > .01
               AND ROUND (ROUND (a.prem_amt * a.currency_rt, 2) * .12, 2) =
                                         ROUND (e.evat_due * a.currency_rt, 2)
               AND EXISTS (
                      SELECT   'X'
                          FROM gipi_installment i
                         WHERE i.iss_cd = a.iss_cd
                           AND i.prem_seq_no = a.prem_seq_no
                        HAVING COUNT (*) = 1
                      GROUP BY i.iss_cd, i.prem_seq_no)
               AND a.policy_id IN (
                      SELECT policy_id
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
                                                  zz.ginst_prem + zz.ginst_tax)
               /*AND a.policy_id NOT IN (
                      SELECT mj.policy_id
                        FROM (SELECT b160_iss_cd, b160_prem_seq_no, inst_no
                                FROM (SELECT gacc_tran_id, transaction_type,
                                             b160_iss_cd, b160_prem_seq_no,
                                             inst_no
                                        FROM (SELECT DISTINCT b.gacc_tran_id,
                                                              b.transaction_type,
                                                              b.b160_iss_cd,
                                                              b.b160_prem_seq_no,
                                                              b.inst_no
                                                         FROM giac_tax_collns b,
                                                              giac_acctrans c
                                                        WHERE gacc_tran_id =
                                                                       tran_id
                                                          AND tran_flag <> 'D'
                                                          AND NOT EXISTS (
                                                                 SELECT 'X'
                                                                   FROM giac_reversals xx,
                                                                        giac_acctrans yy
                                                                  WHERE xx.reversing_tran_id =
                                                                           yy.tran_id
                                                                    AND yy.tran_flag <>
                                                                           'D'
                                                                    AND xx.gacc_tran_id =
                                                                           b.gacc_tran_id))
                                      MINUS
                                      (SELECT DISTINCT b.gacc_tran_id,
                                                       b.transaction_type,
                                                       b.b140_iss_cd,
                                                       b.b140_prem_seq_no,
                                                       b.inst_no
                                                  FROM giac_direct_prem_collns b)
                                      UNION ALL
                                      SELECT NULL, NULL, 'MIKEL', NULL, NULL
                                        FROM DUAL)) jm,
                             gipi_invoice mj
                       WHERE jm.b160_iss_cd = mj.iss_cd
                         AND jm.b160_prem_seq_no = mj.prem_seq_no)*/
               AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
               AND a.prem_seq_no = NVL (p_prem_seq_no, a.prem_seq_no)
          UNION ALL
          SELECT   'INSTALLMENT' payt_term, assd_name,
                   get_policy_no (a.policy_id) policy_no,
                   get_ref_no (d.gacc_tran_id) ref_no,
                   a.iss_cd || '-' || a.prem_seq_no bill_no,
                   b.inst_no inst_no, b.balance_amt_due bal_amt_due,
                   b.prem_balance_due prem_bal_due,
                   b.tax_balance_due tax_bal_due,
                   ROUND (a.prem_amt * a.currency_rt, 2) inv_prem,
                   ROUND (a.tax_amt * a.currency_rt, 2) inv_tax,
                   d.prem_amt prem_paid, d.tax_amt tax_paid,
                   ROUND (e.evat_due * a.currency_rt, 2) inv_evat,
                   d.evat evat_paid,
                   ROUND (d.prem_amt * .12, 2) evat_should_be,
                   d.evat - ROUND (d.prem_amt * .12, 2) evat_discrep,
                   comm_due inv_comm, NVL (comm_paid, 0) comm_paid,
                   NVL (comm_paid, 0) - comm_due comm_discrep, d.user_id,
                   d.last_update, d.gacc_tran_id, d.transaction_type,
                   d.collection_amt, d.iss_cd, d.prem_seq_no, d.or_date,
                   d.posting_date
              FROM gipi_invoice a,
                   gipi_installment f,
                   giac_aging_soa_details b,
                   gipi_polbasic c,
                   giis_assured f,
                   gipi_parlist g,
                   (SELECT y.gacc_tran_id, y.transaction_type,
                           y.b140_iss_cd iss_cd,
                           y.b140_prem_seq_no prem_seq_no, y.inst_no,
                           y.user_id, y.last_update, y.collection_amt,
                           (premium_amt) prem_amt, (tax_amt) tax_amt,
                           (NVL (l.evat, 0)) evat,
                           NVL (x.or_date, z.tran_date) or_date,
                           z.posting_date
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
                       AND NOT EXISTS (
                              SELECT 'Z'
                                FROM giac_reversals v, giac_acctrans w
                               WHERE v.reversing_tran_id = w.tran_id
                                 AND w.tran_flag <> 'D'
                                 AND v.gacc_tran_id = y.gacc_tran_id)) d,
                   (SELECT   SUM (tax_amt) evat_due, iss_cd, prem_seq_no
                        FROM gipi_inv_tax
                       WHERE tax_cd = giacp.n ('EVAT') AND tax_amt <> 0
                    GROUP BY iss_cd, prem_seq_no) e,
                   (SELECT   s.iss_cd, s.prem_seq_no,
                             SUM (NVL (comm_amt, 0)) comm_paid
                        FROM giac_comm_payts s, giac_acctrans t
                       WHERE s.gacc_tran_id = t.tran_id
                         AND t.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = s.gacc_tran_id)
                    GROUP BY s.iss_cd, s.prem_seq_no) comm,
                   (SELECT   g.iss_cd, g.prem_seq_no,
                             ROUND (SUM (g.commission_amt * h.currency_rt),
                                    2
                                   ) comm_due
                        FROM gipi_comm_invoice g, gipi_invoice h
                       WHERE g.iss_cd = h.iss_cd
                         AND g.prem_seq_no = h.prem_seq_no
                    GROUP BY g.iss_cd, g.prem_seq_no) comm_due
             WHERE a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND c.policy_id <> '5'
               AND a.iss_cd = d.iss_cd
               AND a.prem_seq_no = d.prem_seq_no
               AND a.iss_cd = e.iss_cd
               AND a.prem_seq_no = e.prem_seq_no
               AND a.iss_cd = f.iss_cd
               AND a.prem_seq_no = f.prem_seq_no
               AND f.inst_no = b.inst_no
               AND f.inst_no = d.inst_no
               AND c.par_id = g.par_id
               AND g.assd_no = f.assd_no
               AND b.iss_cd = comm.iss_cd(+)
               AND b.prem_seq_no = comm.prem_seq_no(+)
               AND b.iss_cd = comm_due.iss_cd
               AND b.prem_seq_no = comm_due.prem_seq_no
               AND b.balance_amt_due <> 0
               AND b.prem_balance_due <> 0
               --AND ROUND(d.prem_amt * .12,2) <> d.evat
               AND ABS ((d.evat - ROUND (d.prem_amt * .12, 2))) > .01
               AND ROUND (ROUND (a.prem_amt * a.currency_rt, 2) * .12, 2) =
                                         ROUND (e.evat_due * a.currency_rt, 2)
               AND b.inst_no = 1
               AND EXISTS (
                      SELECT   'X'
                          FROM gipi_installment i
                         WHERE i.iss_cd = a.iss_cd
                           AND i.prem_seq_no = a.prem_seq_no
                        HAVING COUNT (*) > 1
                      GROUP BY i.iss_cd, i.prem_seq_no)
               AND a.policy_id IN (
                      SELECT policy_id
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
                                                  zz.ginst_prem + zz.ginst_tax)
               /*AND a.policy_id NOT IN (
                      SELECT mj.policy_id
                        FROM (SELECT b160_iss_cd, b160_prem_seq_no, inst_no
                                FROM (SELECT gacc_tran_id, transaction_type,
                                             b160_iss_cd, b160_prem_seq_no,
                                             inst_no
                                        FROM (SELECT DISTINCT b.gacc_tran_id,
                                                              b.transaction_type,
                                                              b.b160_iss_cd,
                                                              b.b160_prem_seq_no,
                                                              b.inst_no
                                                         FROM giac_tax_collns b,
                                                              giac_acctrans c
                                                        WHERE gacc_tran_id =
                                                                       tran_id
                                                          AND tran_flag <> 'D'
                                                          AND NOT EXISTS (
                                                                 SELECT 'X'
                                                                   FROM giac_reversals xx,
                                                                        giac_acctrans yy
                                                                  WHERE xx.reversing_tran_id =
                                                                           yy.tran_id
                                                                    AND yy.tran_flag <>
                                                                           'D'
                                                                    AND xx.gacc_tran_id =
                                                                           b.gacc_tran_id))
                                      MINUS
                                      (SELECT DISTINCT b.gacc_tran_id,
                                                       b.transaction_type,
                                                       b.b140_iss_cd,
                                                       b.b140_prem_seq_no,
                                                       b.inst_no
                                                  FROM giac_direct_prem_collns b)
                                      UNION ALL
                                      SELECT NULL, NULL, 'MIKEL', NULL, NULL
                                        FROM DUAL)) jm,
                             gipi_invoice mj
                       WHERE jm.b160_iss_cd = mj.iss_cd
                         AND jm.b160_prem_seq_no = mj.prem_seq_no)*/
               AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
               AND a.prem_seq_no = NVL (p_prem_seq_no, a.prem_seq_no)
          ORDER BY 5, 6, 4)
      LOOP
         v_crr.payment_term := r.payt_term;
         v_crr.assured_name := r.assd_name;
         v_crr.policy_no := r.policy_no;
         v_crr.reference_no := r.ref_no;
         v_crr.invoice_no := r.bill_no;
         v_crr.inst_no := r.inst_no;
         v_crr.prem_paid := r.prem_paid;
         v_crr.tax_paid := r.tax_paid;
         v_crr.evat_paid := r.evat_paid;
         v_crr.user_id := r.user_id;
         v_crr.last_update := r.last_update;
         v_crr.or_date := r.or_date;
         v_crr.posting_date := r.posting_date;


         IF r.bill_no <> NVL (v_last_bill, 'MIKELRAZON')
         THEN
            v_crr.bal_amt_due := r.bal_amt_due;
            v_crr.prem_bal_due := r.prem_bal_due;
            v_crr.tax_bal_due := r.tax_bal_due;
            v_crr.inv_prem := r.inv_prem;
            v_crr.inv_tax := r.inv_tax;
            v_crr.inv_evat := r.inv_evat;
            v_crr.evat_should_be := r.evat_should_be;
            v_crr.evat_discrep := r.evat_discrep;
            v_crr.inv_comm := r.inv_comm;
            v_crr.comm_paid := r.comm_paid;
            v_crr.comm_discrep := r.comm_discrep;
            v_last_bill := r.bill_no;
         ELSE
            v_crr.bal_amt_due := NULL;
            v_crr.prem_bal_due := NULL;
            v_crr.tax_bal_due := NULL;
            v_crr.inv_prem := NULL;
            v_crr.inv_tax := NULL;
            v_crr.inv_evat := NULL;
            v_crr.evat_paid := r.evat_paid;
            v_crr.evat_should_be := r.evat_should_be;
            v_crr.evat_discrep := r.evat_discrep;
            v_crr.inv_comm := NULL;
            v_crr.comm_paid := NULL;
            v_crr.comm_discrep := NULL;
            v_last_bill := r.bill_no;
         END IF;

         IF p_display = 'Y'
         THEN
            v_crr.gacc_tran_id := r.gacc_tran_id;
            v_crr.transaction_type := r.transaction_type;
            v_crr.collection_amt := r.collection_amt;
            v_crr.b140_iss_cd := r.iss_cd;
            v_crr.b140_prem_seq_no := r.prem_seq_no;
         END IF;

         PIPE ROW (v_crr);
      END LOOP;

      RETURN;
   END partially_paid;

   FUNCTION fully_paid
      RETURN mikel_type2 PIPELINED
   IS
      v_crr              crr_mikel_type2;
      v_last_bill        VARCHAR2 (4000);
      v_evat_should_be   giac_tax_collns.tax_amt%TYPE   := 0;
      v_count_payt       NUMBER                         := 0;
   BEGIN
      FOR r IN
         (SELECT   'STRAIGHT' payt_term, assd_name,
                   get_policy_no (a.policy_id) policy_no,

                   --get_ref_no (d.gacc_tran_id) ref_no,
                   a.iss_cd || '-' || a.prem_seq_no bill_no,
                   b.inst_no inst_no, b.balance_amt_due bal_amt_due,
                   b.prem_balance_due prem_bal_due,
                   b.tax_balance_due tax_bal_due,
                   ROUND (a.prem_amt * a.currency_rt, 2) inv_prem,
                   ROUND (a.tax_amt * a.currency_rt, 2) inv_tax,
                   d.prem_amt prem_paid, d.tax_amt tax_paid,
                   ROUND (e.evat_due * a.currency_rt, 2) inv_evat,
                   d.evat evat_paid,
                   ROUND (d.prem_amt * .12, 2) evat_should_be,
                   d.evat - ROUND (d.prem_amt * .12, 2) evat_discrep,
                   comm_due inv_comm, NVL (comm_paid, 0) comm_paid,
                   NVL (comm_paid, 0) - comm_due comm_discrep, d.iss_cd,
                   d.prem_seq_no, a.policy_id
              FROM gipi_invoice a,
                   giac_aging_soa_details b,
                   gipi_polbasic c,
                   giis_assured f,
                   gipi_parlist g,
                   (SELECT   y.b140_iss_cd iss_cd,
                             y.b140_prem_seq_no prem_seq_no,
                             SUM (premium_amt) prem_amt, SUM (tax_amt)
                                                                      tax_amt,
                             SUM (NVL (l.evat, 0)) evat
--                           (premium_amt) prem_amt, (tax_amt) tax_amt,
--                           (NVL (l.evat, 0)) evat
                    FROM     giac_direct_prem_collns y,
                             giac_acctrans z,
                             (SELECT   SUM (k.tax_amt) evat, k.gacc_tran_id,
                                       k.b160_iss_cd, k.b160_prem_seq_no
                                  FROM giac_tax_collns k
                                 WHERE k.b160_tax_cd = giacp.n ('EVAT')
                              GROUP BY k.gacc_tran_id,
                                       k.b160_iss_cd,
                                       k.b160_prem_seq_no) l
                       WHERE y.gacc_tran_id = z.tran_id
                         AND l.gacc_tran_id(+) = y.gacc_tran_id
                         AND l.b160_prem_seq_no(+) = y.b140_prem_seq_no
                         AND l.b160_iss_cd(+) = y.b140_iss_cd
                         AND z.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = y.gacc_tran_id)
                    GROUP BY y.b140_iss_cd, y.b140_prem_seq_no, y.inst_no) d,
                   (SELECT   SUM (tax_amt) evat_due, iss_cd, prem_seq_no
                        FROM gipi_inv_tax
                       WHERE tax_cd = giacp.n ('EVAT') AND tax_amt <> 0
                    GROUP BY iss_cd, prem_seq_no) e,
                   (SELECT   s.iss_cd, s.prem_seq_no,
                             SUM (NVL (comm_amt, 0)) comm_paid
                        FROM giac_comm_payts s, giac_acctrans t
                       WHERE s.gacc_tran_id = t.tran_id
                         AND t.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = s.gacc_tran_id)
                    GROUP BY s.iss_cd, s.prem_seq_no) comm,
                   (SELECT   g.iss_cd, g.prem_seq_no,
                             ROUND (SUM (g.commission_amt * h.currency_rt),
                                    2
                                   ) comm_due
                        FROM gipi_comm_invoice g, gipi_invoice h
                       WHERE g.iss_cd = h.iss_cd
                         AND g.prem_seq_no = h.prem_seq_no
                    GROUP BY g.iss_cd, g.prem_seq_no) comm_due
             WHERE a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND c.policy_id <> '5'
               AND a.iss_cd = d.iss_cd
               AND a.prem_seq_no = d.prem_seq_no
               AND a.iss_cd = e.iss_cd
               AND a.prem_seq_no = e.prem_seq_no
               AND c.par_id = g.par_id
               AND g.assd_no = f.assd_no
               AND b.iss_cd = comm.iss_cd(+)
               AND b.prem_seq_no = comm.prem_seq_no(+)
               AND b.iss_cd = comm_due.iss_cd
               AND b.prem_seq_no = comm_due.prem_seq_no
               AND b.balance_amt_due = 0
               AND b.prem_balance_due <> 0
               AND ABS ((d.evat - ROUND (d.prem_amt * .12, 2))) > .01
               AND ROUND (ROUND (a.prem_amt * a.currency_rt, 2) * .12, 2) =
                                         ROUND (e.evat_due * a.currency_rt, 2)
               AND EXISTS (
                      SELECT   'X'
                          FROM gipi_installment i
                         WHERE i.iss_cd = a.iss_cd
                           AND i.prem_seq_no = a.prem_seq_no
                        HAVING COUNT (*) = 1
                      GROUP BY i.iss_cd, i.prem_seq_no)
               AND a.policy_id IN (
                      SELECT policy_id
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
                                                  zz.ginst_prem + zz.ginst_tax)
          /*AND a.policy_id NOT IN (
                 SELECT mj.policy_id
                   FROM (SELECT b160_iss_cd, b160_prem_seq_no, inst_no
                           FROM (SELECT gacc_tran_id, transaction_type,
                                        b160_iss_cd, b160_prem_seq_no,
                                        inst_no
                                   FROM (SELECT DISTINCT b.gacc_tran_id,
                                                         b.transaction_type,
                                                         b.b160_iss_cd,
                                                         b.b160_prem_seq_no,
                                                         b.inst_no
                                                    FROM giac_tax_collns b,
                                                         giac_acctrans c
                                                   WHERE gacc_tran_id =
                                                                  tran_id
                                                     AND tran_flag <> 'D'
                                                     AND NOT EXISTS (
                                                            SELECT 'X'
                                                              FROM giac_reversals xx,
                                                                   giac_acctrans yy
                                                             WHERE xx.reversing_tran_id =
                                                                      yy.tran_id
                                                               AND yy.tran_flag <>
                                                                      'D'
                                                               AND xx.gacc_tran_id =
                                                                      b.gacc_tran_id))
                                 MINUS
                                 (SELECT DISTINCT b.gacc_tran_id,
                                                  b.transaction_type,
                                                  b.b140_iss_cd,
                                                  b.b140_prem_seq_no,
                                                  b.inst_no
                                             FROM giac_direct_prem_collns b)
                                 UNION ALL
                                 SELECT NULL, NULL, 'MIKEL', NULL, NULL
                                   FROM DUAL)) jm,
                        gipi_invoice mj
                  WHERE jm.b160_iss_cd = mj.iss_cd
                    AND jm.b160_prem_seq_no = mj.prem_seq_no)*/
          UNION ALL
          SELECT   'INSTALLMENT' payt_term, assd_name,
                   get_policy_no (a.policy_id) policy_no,

                   --get_ref_no (d.gacc_tran_id) ref_no,
                   a.iss_cd || '-' || a.prem_seq_no bill_no,
                   b.inst_no inst_no, b.balance_amt_due bal_amt_due,
                   b.prem_balance_due prem_bal_due,
                   b.tax_balance_due tax_bal_due,
                   ROUND (a.prem_amt * a.currency_rt, 2) inv_prem,
                   ROUND (a.tax_amt * a.currency_rt, 2) inv_tax,
                   d.prem_amt prem_paid, d.tax_amt tax_paid,
                   ROUND (e.evat_due * a.currency_rt, 2) inv_evat,
                   d.evat evat_paid,
                   ROUND (d.prem_amt * .12, 2) evat_should_be,
                   d.evat - ROUND (d.prem_amt * .12, 2) evat_discrep,
                   comm_due inv_comm, NVL (comm_paid, 0) comm_paid,
                   NVL (comm_paid, 0) - comm_due comm_discrep, d.iss_cd,
                   d.prem_seq_no, a.policy_id
              FROM gipi_invoice a,
                   gipi_installment f,
                   giac_aging_soa_details b,
                   gipi_polbasic c,
                   giis_assured f,
                   gipi_parlist g,
                   (SELECT   y.b140_iss_cd iss_cd,
                             y.b140_prem_seq_no prem_seq_no, y.inst_no,
                             SUM (premium_amt) prem_amt, SUM (tax_amt)
                                                                      tax_amt,
                             SUM (NVL (l.evat, 0)) evat
--                           (premium_amt) prem_amt, (tax_amt) tax_amt,
--                           (NVL (l.evat, 0)) evat
                    FROM     giac_direct_prem_collns y,
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
                         AND l.gacc_tran_id(+) = y.gacc_tran_id
                         AND l.b160_prem_seq_no(+) = y.b140_prem_seq_no
                         AND l.b160_iss_cd(+) = y.b140_iss_cd
                         AND l.inst_no(+) = y.inst_no
                         AND z.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = y.gacc_tran_id)
                    GROUP BY y.b140_iss_cd, y.b140_prem_seq_no, y.inst_no) d,
                   (SELECT   SUM (tax_amt) evat_due, iss_cd, prem_seq_no
                        FROM gipi_inv_tax
                       WHERE tax_cd = giacp.n ('EVAT') AND tax_amt <> 0
                    GROUP BY iss_cd, prem_seq_no) e,
                   (SELECT   s.iss_cd, s.prem_seq_no,
                             SUM (NVL (comm_amt, 0)) comm_paid
                        FROM giac_comm_payts s, giac_acctrans t
                       WHERE s.gacc_tran_id = t.tran_id
                         AND t.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = s.gacc_tran_id)
                    GROUP BY s.iss_cd, s.prem_seq_no) comm,
                   (SELECT   g.iss_cd, g.prem_seq_no,
                             ROUND (SUM (g.commission_amt * h.currency_rt),
                                    2
                                   ) comm_due
                        FROM gipi_comm_invoice g, gipi_invoice h
                       WHERE g.iss_cd = h.iss_cd
                         AND g.prem_seq_no = h.prem_seq_no
                    GROUP BY g.iss_cd, g.prem_seq_no) comm_due
             WHERE a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND c.policy_id <> '5'
               AND a.iss_cd = d.iss_cd
               AND a.prem_seq_no = d.prem_seq_no
               AND a.iss_cd = e.iss_cd
               AND a.prem_seq_no = e.prem_seq_no
               AND a.iss_cd = f.iss_cd
               AND a.prem_seq_no = f.prem_seq_no
               AND f.inst_no = b.inst_no
               AND f.inst_no = d.inst_no
               AND c.par_id = g.par_id
               AND g.assd_no = f.assd_no
               AND b.iss_cd = comm.iss_cd(+)
               AND b.prem_seq_no = comm.prem_seq_no(+)
               AND b.iss_cd = comm_due.iss_cd
               AND b.prem_seq_no = comm_due.prem_seq_no
               AND b.balance_amt_due = 0
               AND b.prem_balance_due <> 0
               --AND ROUND(d.prem_amt * .12,2) <> d.evat
               AND ABS ((d.evat - ROUND (d.prem_amt * .12, 2))) > .01
               AND ROUND (ROUND (a.prem_amt * a.currency_rt, 2) * .12, 2) =
                                         ROUND (e.evat_due * a.currency_rt, 2)
               AND b.inst_no = 1
               AND EXISTS (
                      SELECT   'X'
                          FROM gipi_installment i
                         WHERE i.iss_cd = a.iss_cd
                           AND i.prem_seq_no = a.prem_seq_no
                        HAVING COUNT (*) > 1
                      GROUP BY i.iss_cd, i.prem_seq_no)
               AND a.policy_id IN (
                      SELECT policy_id
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
                                                  zz.ginst_prem + zz.ginst_tax)
          /*AND a.policy_id NOT IN (
                 SELECT mj.policy_id
                   FROM (SELECT b160_iss_cd, b160_prem_seq_no, inst_no
                           FROM (SELECT gacc_tran_id, transaction_type,
                                        b160_iss_cd, b160_prem_seq_no,
                                        inst_no
                                   FROM (SELECT DISTINCT b.gacc_tran_id,
                                                         b.transaction_type,
                                                         b.b160_iss_cd,
                                                         b.b160_prem_seq_no,
                                                         b.inst_no
                                                    FROM giac_tax_collns b,
                                                         giac_acctrans c
                                                   WHERE gacc_tran_id =
                                                                  tran_id
                                                     AND tran_flag <> 'D'
                                                     AND NOT EXISTS (
                                                            SELECT 'X'
                                                              FROM giac_reversals xx,
                                                                   giac_acctrans yy
                                                             WHERE xx.reversing_tran_id =
                                                                      yy.tran_id
                                                               AND yy.tran_flag <>
                                                                      'D'
                                                               AND xx.gacc_tran_id =
                                                                      b.gacc_tran_id))
                                 MINUS
                                 (SELECT DISTINCT b.gacc_tran_id,
                                                  b.transaction_type,
                                                  b.b140_iss_cd,
                                                  b.b140_prem_seq_no,
                                                  b.inst_no
                                             FROM giac_direct_prem_collns b)
                                 UNION ALL
                                 SELECT NULL, NULL, 'MIKEL', NULL, NULL
                                   FROM DUAL)) jm,
                        gipi_invoice mj
                  WHERE jm.b160_iss_cd = mj.iss_cd
                    AND jm.b160_prem_seq_no = mj.prem_seq_no)*/
          ORDER BY 20, 21)
      LOOP
         v_evat_should_be := 0;
         v_count_payt := 0;
         v_crr.policy_id := r.policy_id;

         FOR gdpc IN (SELECT   get_ref_no (y.gacc_tran_id) ref_no, y.user_id,
                               y.last_update, y.b140_iss_cd iss_cd,
                               y.b140_prem_seq_no prem_seq_no,
                               (premium_amt) prem_paid, (tax_amt) tax_paid,
                               (NVL (l.evat, 0)) evat_paid,
                               ROUND (y.premium_amt * .12, 2) evat_should_be,
                                 NVL (l.evat, 0)
                               - ROUND (y.premium_amt * .12, 2) evat_discrep,
                               NVL (x.or_date, z.tran_date) or_date,
                               posting_date
                          FROM giac_direct_prem_collns y,
                               giac_order_of_payts x,
                               giac_acctrans z,
                               (SELECT   SUM (k.tax_amt) evat, k.gacc_tran_id,
                                         k.b160_iss_cd, k.b160_prem_seq_no
                                    FROM giac_tax_collns k
                                   WHERE k.b160_tax_cd = giacp.n ('EVAT')
                                GROUP BY k.gacc_tran_id,
                                         k.b160_iss_cd,
                                         k.b160_prem_seq_no) l
                         WHERE y.gacc_tran_id = z.tran_id
                           AND y.gacc_tran_id = x.gacc_tran_id(+)
                           AND l.gacc_tran_id(+) = y.gacc_tran_id
                           AND l.b160_prem_seq_no(+) = y.b140_prem_seq_no
                           AND l.b160_iss_cd(+) = y.b140_iss_cd
                           AND z.tran_flag <> 'D'
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
            v_evat_should_be := v_evat_should_be + gdpc.evat_should_be;
            v_count_payt := v_count_payt + 1;
            v_crr.payment_term := r.payt_term;
            v_crr.assured_name := r.assd_name;
            v_crr.policy_no := r.policy_no;
            v_crr.reference_no := gdpc.ref_no;
            v_crr.invoice_no := r.bill_no;
            v_crr.inst_no := r.inst_no;
            v_crr.prem_paid := gdpc.prem_paid;
            v_crr.tax_paid := gdpc.tax_paid;
            v_crr.evat_paid := gdpc.evat_paid;
            v_crr.user_id := gdpc.user_id;
            v_crr.last_update := gdpc.last_update;
            v_crr.or_date := gdpc.or_date;
            v_crr.posting_date := gdpc.posting_date;


            IF r.bill_no <> NVL (v_last_bill, 'MIKELRAZON')
            THEN
               IF r.inv_evat = gdpc.evat_paid
               THEN
                  --NULL;--EXIT;
                  v_crr.evat_should_be := r.inv_evat;
                  v_crr.evat_discrep := gdpc.evat_paid - r.inv_evat;
               ELSIF     ABS (r.inv_evat) - ABS (v_evat_should_be) < 0
                     AND v_count_payt = 1
               THEN
                  v_crr.evat_should_be := r.inv_evat;
                  v_crr.evat_discrep := gdpc.evat_paid - r.inv_evat;
               ELSE
                  v_crr.evat_should_be := gdpc.evat_should_be;
                  v_crr.evat_discrep := gdpc.evat_discrep;
               END IF;

               v_crr.bal_amt_due := r.bal_amt_due;
               v_crr.prem_bal_due := r.prem_bal_due;
               v_crr.tax_bal_due := r.tax_bal_due;
               v_crr.inv_prem := r.inv_prem;
               v_crr.inv_tax := r.inv_tax;
               v_crr.inv_evat := r.inv_evat;
               v_crr.inv_comm := r.inv_comm;
               v_crr.comm_paid := r.comm_paid;
               v_crr.comm_discrep := r.comm_discrep;
               v_crr.user_id := gdpc.user_id;
               v_crr.last_update := gdpc.last_update;
               v_last_bill := r.bill_no;
            ELSE
               v_crr.bal_amt_due := NULL;
               v_crr.prem_bal_due := NULL;
               v_crr.tax_bal_due := NULL;
               v_crr.inv_prem := NULL;
               v_crr.inv_tax := NULL;
               v_crr.inv_evat := NULL;
               v_crr.evat_should_be := gdpc.evat_should_be;
               v_crr.evat_discrep := gdpc.evat_discrep;
               v_crr.inv_comm := NULL;
               v_crr.comm_paid := NULL;
               v_crr.comm_discrep := NULL;
               v_last_bill := r.bill_no;
            END IF;

            PIPE ROW (v_crr);
         END LOOP;
      END LOOP;

      RETURN;
   END fully_paid;

   FUNCTION partially_paid2
      RETURN mikel_type3 PIPELINED
   IS
      v_crr              crr_mikel_type3;
      v_last_bill        VARCHAR2 (4000);
      v_evat_should_be   giac_tax_collns.tax_amt%TYPE   := 0;
      v_count_payt       NUMBER                         := 0;
   BEGIN
      FOR r IN
         (SELECT   'STRAIGHT' payt_term, assd_name,
                   get_policy_no (a.policy_id) policy_no,

                   --get_ref_no (d.gacc_tran_id) ref_no,
                   a.iss_cd || '-' || a.prem_seq_no bill_no,
                   b.inst_no inst_no, b.balance_amt_due bal_amt_due,
                   b.prem_balance_due prem_bal_due,
                   b.tax_balance_due tax_bal_due,
                   ROUND (a.prem_amt * a.currency_rt, 2) inv_prem,
                   ROUND (a.tax_amt * a.currency_rt, 2) inv_tax,
                   d.prem_amt prem_paid, d.tax_amt tax_paid,
                   ROUND (e.evat_due * a.currency_rt, 2) inv_evat,
                   d.evat evat_paid,
                   ROUND (d.prem_amt * .12, 2) evat_should_be,
                   d.evat - ROUND (d.prem_amt * .12, 2) evat_discrep,
                   comm_due inv_comm, NVL (comm_paid, 0) comm_paid,
                   NVL (comm_paid, 0) - comm_due comm_discrep, d.iss_cd,
                   d.prem_seq_no
              FROM gipi_invoice a,
                   giac_aging_soa_details b,
                   gipi_polbasic c,
                   giis_assured f,
                   gipi_parlist g,
                   (SELECT   y.b140_iss_cd iss_cd,
                             y.b140_prem_seq_no prem_seq_no,
                             SUM (premium_amt) prem_amt, SUM (tax_amt)
                                                                      tax_amt,
                             SUM (NVL (l.evat, 0)) evat
--                           (premium_amt) prem_amt, (tax_amt) tax_amt,
--                           (NVL (l.evat, 0)) evat
                    FROM     giac_direct_prem_collns y,
                             giac_acctrans z,
                             (SELECT   SUM (k.tax_amt) evat, k.gacc_tran_id,
                                       k.b160_iss_cd, k.b160_prem_seq_no
                                  FROM giac_tax_collns k
                                 WHERE k.b160_tax_cd = giacp.n ('EVAT')
                              GROUP BY k.gacc_tran_id,
                                       k.b160_iss_cd,
                                       k.b160_prem_seq_no) l
                       WHERE y.gacc_tran_id = z.tran_id
                         AND l.gacc_tran_id(+) = y.gacc_tran_id
                         AND l.b160_prem_seq_no(+) = y.b140_prem_seq_no
                         AND l.b160_iss_cd(+) = y.b140_iss_cd
                         AND z.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = y.gacc_tran_id)
                    GROUP BY y.b140_iss_cd, y.b140_prem_seq_no, y.inst_no) d,
                   (SELECT   SUM (tax_amt) evat_due, iss_cd, prem_seq_no
                        FROM gipi_inv_tax
                       WHERE tax_cd = giacp.n ('EVAT') AND tax_amt <> 0
                    GROUP BY iss_cd, prem_seq_no) e,
                   (SELECT   s.iss_cd, s.prem_seq_no,
                             SUM (NVL (comm_amt, 0)) comm_paid
                        FROM giac_comm_payts s, giac_acctrans t
                       WHERE s.gacc_tran_id = t.tran_id
                         AND t.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = s.gacc_tran_id)
                    GROUP BY s.iss_cd, s.prem_seq_no) comm,
                   (SELECT   g.iss_cd, g.prem_seq_no,
                             ROUND (SUM (g.commission_amt * h.currency_rt),
                                    2
                                   ) comm_due
                        FROM gipi_comm_invoice g, gipi_invoice h
                       WHERE g.iss_cd = h.iss_cd
                         AND g.prem_seq_no = h.prem_seq_no
                    GROUP BY g.iss_cd, g.prem_seq_no) comm_due
             WHERE a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND c.policy_id <> '5'
               AND a.iss_cd = d.iss_cd
               AND a.prem_seq_no = d.prem_seq_no
               AND a.iss_cd = e.iss_cd
               AND a.prem_seq_no = e.prem_seq_no
               AND c.par_id = g.par_id
               AND g.assd_no = f.assd_no
               AND b.iss_cd = comm.iss_cd(+)
               AND b.prem_seq_no = comm.prem_seq_no(+)
               AND b.iss_cd = comm_due.iss_cd
               AND b.prem_seq_no = comm_due.prem_seq_no
               AND b.balance_amt_due <> 0
               AND b.prem_balance_due <> 0
               AND ABS ((d.evat - ROUND (d.prem_amt * .12, 2))) > .01
               AND ROUND (ROUND (a.prem_amt * a.currency_rt, 2) * .12, 2) =
                                         ROUND (e.evat_due * a.currency_rt, 2)
               AND EXISTS (
                      SELECT   'X'
                          FROM gipi_installment i
                         WHERE i.iss_cd = a.iss_cd
                           AND i.prem_seq_no = a.prem_seq_no
                        HAVING COUNT (*) = 1
                      GROUP BY i.iss_cd, i.prem_seq_no)
               AND a.policy_id IN (
                      SELECT policy_id
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
                                                  zz.ginst_prem + zz.ginst_tax)
          /* AND a.policy_id NOT IN (
                  SELECT mj.policy_id
                    FROM (SELECT b160_iss_cd, b160_prem_seq_no, inst_no
                            FROM (SELECT gacc_tran_id, transaction_type,
                                         b160_iss_cd, b160_prem_seq_no,
                                         inst_no
                                    FROM (SELECT DISTINCT b.gacc_tran_id,
                                                          b.transaction_type,
                                                          b.b160_iss_cd,
                                                          b.b160_prem_seq_no,
                                                          b.inst_no
                                                     FROM giac_tax_collns b,
                                                          giac_acctrans c
                                                    WHERE gacc_tran_id =
                                                                   tran_id
                                                      AND tran_flag <> 'D'
                                                      AND NOT EXISTS (
                                                             SELECT 'X'
                                                               FROM giac_reversals xx,
                                                                    giac_acctrans yy
                                                              WHERE xx.reversing_tran_id =
                                                                       yy.tran_id
                                                                AND yy.tran_flag <>
                                                                       'D'
                                                                AND xx.gacc_tran_id =
                                                                       b.gacc_tran_id))
                                  MINUS
                                  (SELECT DISTINCT b.gacc_tran_id,
                                                   b.transaction_type,
                                                   b.b140_iss_cd,
                                                   b.b140_prem_seq_no,
                                                   b.inst_no
                                              FROM giac_direct_prem_collns b)
                                  UNION ALL
                                  SELECT NULL, NULL, 'MIKEL', NULL, NULL
                                    FROM DUAL)) jm,
                         gipi_invoice mj
                   WHERE jm.b160_iss_cd = mj.iss_cd
                     AND jm.b160_prem_seq_no = mj.prem_seq_no)*/
          UNION ALL
          SELECT   'INSTALLMENT' payt_term, assd_name,
                   get_policy_no (a.policy_id) policy_no,

                   --get_ref_no (d.gacc_tran_id) ref_no,
                   a.iss_cd || '-' || a.prem_seq_no bill_no,
                   b.inst_no inst_no, b.balance_amt_due bal_amt_due,
                   b.prem_balance_due prem_bal_due,
                   b.tax_balance_due tax_bal_due,
                   ROUND (a.prem_amt * a.currency_rt, 2) inv_prem,
                   ROUND (a.tax_amt * a.currency_rt, 2) inv_tax,
                   d.prem_amt prem_paid, d.tax_amt tax_paid,
                   ROUND (e.evat_due * a.currency_rt, 2) inv_evat,
                   d.evat evat_paid,
                   ROUND (d.prem_amt * .12, 2) evat_should_be,
                   d.evat - ROUND (d.prem_amt * .12, 2) evat_discrep,
                   comm_due inv_comm, NVL (comm_paid, 0) comm_paid,
                   NVL (comm_paid, 0) - comm_due comm_discrep, d.iss_cd,
                   d.prem_seq_no
              FROM gipi_invoice a,
                   gipi_installment f,
                   giac_aging_soa_details b,
                   gipi_polbasic c,
                   giis_assured f,
                   gipi_parlist g,
                   (SELECT   y.b140_iss_cd iss_cd,
                             y.b140_prem_seq_no prem_seq_no, y.inst_no,
                             SUM (premium_amt) prem_amt, SUM (tax_amt)
                                                                      tax_amt,
                             SUM (NVL (l.evat, 0)) evat
--                           (premium_amt) prem_amt, (tax_amt) tax_amt,
--                           (NVL (l.evat, 0)) evat
                    FROM     giac_direct_prem_collns y,
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
                         AND l.gacc_tran_id(+) = y.gacc_tran_id
                         AND l.b160_prem_seq_no(+) = y.b140_prem_seq_no
                         AND l.b160_iss_cd(+) = y.b140_iss_cd
                         AND l.inst_no(+) = y.inst_no
                         AND z.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = y.gacc_tran_id)
                    GROUP BY y.b140_iss_cd, y.b140_prem_seq_no, y.inst_no) d,
                   (SELECT   SUM (tax_amt) evat_due, iss_cd, prem_seq_no
                        FROM gipi_inv_tax
                       WHERE tax_cd = giacp.n ('EVAT') AND tax_amt <> 0
                    GROUP BY iss_cd, prem_seq_no) e,
                   (SELECT   s.iss_cd, s.prem_seq_no,
                             SUM (NVL (comm_amt, 0)) comm_paid
                        FROM giac_comm_payts s, giac_acctrans t
                       WHERE s.gacc_tran_id = t.tran_id
                         AND t.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = s.gacc_tran_id)
                    GROUP BY s.iss_cd, s.prem_seq_no) comm,
                   (SELECT   g.iss_cd, g.prem_seq_no,
                             ROUND (SUM (g.commission_amt * h.currency_rt),
                                    2
                                   ) comm_due
                        FROM gipi_comm_invoice g, gipi_invoice h
                       WHERE g.iss_cd = h.iss_cd
                         AND g.prem_seq_no = h.prem_seq_no
                    GROUP BY g.iss_cd, g.prem_seq_no) comm_due
             WHERE a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND c.policy_id <> '5'
               AND a.iss_cd = d.iss_cd
               AND a.prem_seq_no = d.prem_seq_no
               AND a.iss_cd = e.iss_cd
               AND a.prem_seq_no = e.prem_seq_no
               AND a.iss_cd = f.iss_cd
               AND a.prem_seq_no = f.prem_seq_no
               AND f.inst_no = b.inst_no
               AND f.inst_no = d.inst_no
               AND c.par_id = g.par_id
               AND g.assd_no = f.assd_no
               AND b.iss_cd = comm.iss_cd(+)
               AND b.prem_seq_no = comm.prem_seq_no(+)
               AND b.iss_cd = comm_due.iss_cd
               AND b.prem_seq_no = comm_due.prem_seq_no
               AND b.balance_amt_due <> 0
               AND b.prem_balance_due <> 0
               --AND ROUND(d.prem_amt * .12,2) <> d.evat
               AND ABS ((d.evat - ROUND (d.prem_amt * .12, 2))) > .01
               AND ROUND (ROUND (a.prem_amt * a.currency_rt, 2) * .12, 2) =
                                         ROUND (e.evat_due * a.currency_rt, 2)
               AND b.inst_no = 1
               AND EXISTS (
                      SELECT   'X'
                          FROM gipi_installment i
                         WHERE i.iss_cd = a.iss_cd
                           AND i.prem_seq_no = a.prem_seq_no
                        HAVING COUNT (*) > 1
                      GROUP BY i.iss_cd, i.prem_seq_no)
               AND a.policy_id IN (
                      SELECT policy_id
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
                                                  zz.ginst_prem + zz.ginst_tax)
          /*AND a.policy_id NOT IN (
                 SELECT mj.policy_id
                   FROM (SELECT b160_iss_cd, b160_prem_seq_no, inst_no
                           FROM (SELECT gacc_tran_id, transaction_type,
                                        b160_iss_cd, b160_prem_seq_no,
                                        inst_no
                                   FROM (SELECT DISTINCT b.gacc_tran_id,
                                                         b.transaction_type,
                                                         b.b160_iss_cd,
                                                         b.b160_prem_seq_no,
                                                         b.inst_no
                                                    FROM giac_tax_collns b,
                                                         giac_acctrans c
                                                   WHERE gacc_tran_id =
                                                                  tran_id
                                                     AND tran_flag <> 'D'
                                                     AND NOT EXISTS (
                                                            SELECT 'X'
                                                              FROM giac_reversals xx,
                                                                   giac_acctrans yy
                                                             WHERE xx.reversing_tran_id =
                                                                      yy.tran_id
                                                               AND yy.tran_flag <>
                                                                      'D'
                                                               AND xx.gacc_tran_id =
                                                                      b.gacc_tran_id))
                                 MINUS
                                 (SELECT DISTINCT b.gacc_tran_id,
                                                  b.transaction_type,
                                                  b.b140_iss_cd,
                                                  b.b140_prem_seq_no,
                                                  b.inst_no
                                             FROM giac_direct_prem_collns b)
                                 UNION ALL
                                 SELECT NULL, NULL, 'MIKEL', NULL, NULL
                                   FROM DUAL)) jm,
                        gipi_invoice mj
                  WHERE jm.b160_iss_cd = mj.iss_cd
                    AND jm.b160_prem_seq_no = mj.prem_seq_no)*/
          ORDER BY 20, 21)
      LOOP
         v_evat_should_be := 0;
         v_count_payt := 0;

         FOR gdpc IN (SELECT   get_ref_no (y.gacc_tran_id) ref_no, y.user_id,
                               y.last_update, y.b140_iss_cd iss_cd,
                               y.b140_prem_seq_no prem_seq_no,
                               (premium_amt) prem_paid, (tax_amt) tax_paid,
                               (NVL (l.evat, 0)) evat_paid,
                               ROUND (y.premium_amt * .12, 2) evat_should_be,
                                 NVL (l.evat, 0)
                               - ROUND (y.premium_amt * .12, 2) evat_discrep
                          FROM giac_direct_prem_collns y,
                               giac_acctrans z,
                               (SELECT   SUM (k.tax_amt) evat, k.gacc_tran_id,
                                         k.b160_iss_cd, k.b160_prem_seq_no
                                    FROM giac_tax_collns k
                                   WHERE k.b160_tax_cd = giacp.n ('EVAT')
                                GROUP BY k.gacc_tran_id,
                                         k.b160_iss_cd,
                                         k.b160_prem_seq_no) l
                         WHERE y.gacc_tran_id = z.tran_id
                           AND l.gacc_tran_id(+) = y.gacc_tran_id
                           AND l.b160_prem_seq_no(+) = y.b140_prem_seq_no
                           AND l.b160_iss_cd(+) = y.b140_iss_cd
                           AND z.tran_flag <> 'D'
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
            v_evat_should_be := v_evat_should_be + gdpc.evat_should_be;
            v_count_payt := v_count_payt + 1;
            v_crr.payment_term := r.payt_term;
            v_crr.assured_name := r.assd_name;
            v_crr.policy_no := r.policy_no;
            v_crr.reference_no := gdpc.ref_no;
            v_crr.invoice_no := r.bill_no;
            v_crr.inst_no := r.inst_no;
            v_crr.prem_paid := gdpc.prem_paid;
            v_crr.tax_paid := gdpc.tax_paid;
            v_crr.evat_paid := gdpc.evat_paid;
            v_crr.user_id := gdpc.user_id;
            v_crr.last_update := gdpc.last_update;

            IF r.bill_no <> NVL (v_last_bill, 'MIKELRAZON')
            THEN
               IF r.inv_evat = gdpc.evat_paid
               THEN
                  --NULL;--EXIT;
                  v_crr.evat_should_be := r.inv_evat;
                  v_crr.evat_discrep := gdpc.evat_paid - r.inv_evat;
               ELSIF     ABS (r.inv_evat) - ABS (v_evat_should_be) < 0
                     AND v_count_payt = 1
               THEN
                  v_crr.evat_should_be := r.inv_evat;
                  v_crr.evat_discrep := gdpc.evat_paid - r.inv_evat;
               ELSE
                  v_crr.evat_should_be := gdpc.evat_should_be;
                  v_crr.evat_discrep := gdpc.evat_discrep;
               END IF;

               v_crr.bal_amt_due := r.bal_amt_due;
               v_crr.prem_bal_due := r.prem_bal_due;
               v_crr.tax_bal_due := r.tax_bal_due;
               v_crr.inv_prem := r.inv_prem;
               v_crr.inv_tax := r.inv_tax;
               v_crr.inv_evat := r.inv_evat;
               v_crr.inv_comm := r.inv_comm;
               v_crr.comm_paid := r.comm_paid;
               v_crr.comm_discrep := r.comm_discrep;
               v_crr.user_id := gdpc.user_id;
               v_crr.last_update := gdpc.last_update;
               v_last_bill := r.bill_no;
            ELSE
               v_crr.bal_amt_due := NULL;
               v_crr.prem_bal_due := NULL;
               v_crr.tax_bal_due := NULL;
               v_crr.inv_prem := NULL;
               v_crr.inv_tax := NULL;
               v_crr.inv_evat := NULL;
               v_crr.evat_should_be := gdpc.evat_should_be;
               v_crr.evat_discrep := gdpc.evat_discrep;
               v_crr.inv_comm := NULL;
               v_crr.comm_paid := NULL;
               v_crr.comm_discrep := NULL;
               v_last_bill := r.bill_no;
            END IF;

            PIPE ROW (v_crr);
         END LOOP;
      END LOOP;

      RETURN;
   END partially_paid2;

   FUNCTION fully_paid2
      RETURN mikel_type4 PIPELINED
   IS
      v_crr              crr_mikel_type4;
      v_last_bill        VARCHAR2 (4000);
      v_evat_should_be   giac_tax_collns.tax_amt%TYPE   := 0;
      v_count_payt       NUMBER                         := 0;
   BEGIN
      FOR r IN
         (SELECT   'STRAIGHT' payt_term, assd_name,
                   get_policy_no (a.policy_id) policy_no,

                   --get_ref_no (d.gacc_tran_id) ref_no,
                   a.iss_cd || '-' || a.prem_seq_no bill_no,
                   b.inst_no inst_no, b.balance_amt_due bal_amt_due,
                   b.prem_balance_due prem_bal_due,
                   b.tax_balance_due tax_bal_due,
                   ROUND (a.prem_amt * a.currency_rt, 2) inv_prem,
                   ROUND (a.tax_amt * a.currency_rt, 2) inv_tax,
                   d.prem_amt prem_paid, d.tax_amt tax_paid,
                   ROUND (e.evat_due * a.currency_rt, 2) inv_evat,
                   d.evat evat_paid,
                   ROUND (d.prem_amt * .12, 2) evat_should_be,
                   d.evat - ROUND (d.prem_amt * .12, 2) evat_discrep,
                   comm_due inv_comm, NVL (comm_paid, 0) comm_paid,
                   NVL (comm_paid, 0) - comm_due comm_discrep, d.iss_cd,
                   d.prem_seq_no, a.policy_id
              FROM gipi_invoice a,
                   giac_aging_soa_details b,
                   gipi_polbasic c,
                   giis_assured f,
                   gipi_parlist g,
                   (SELECT   y.b140_iss_cd iss_cd,
                             y.b140_prem_seq_no prem_seq_no,
                             SUM (premium_amt) prem_amt, SUM (tax_amt)
                                                                      tax_amt,
                             SUM (NVL (l.evat, 0)) evat
--                           (premium_amt) prem_amt, (tax_amt) tax_amt,
--                           (NVL (l.evat, 0)) evat
                    FROM     giac_direct_prem_collns y,
                             giac_acctrans z,
                             (SELECT   SUM (k.tax_amt) evat, k.gacc_tran_id,
                                       k.b160_iss_cd, k.b160_prem_seq_no
                                  FROM giac_tax_collns k
                                 WHERE k.b160_tax_cd = giacp.n ('EVAT')
                              GROUP BY k.gacc_tran_id,
                                       k.b160_iss_cd,
                                       k.b160_prem_seq_no) l
                       WHERE y.gacc_tran_id = z.tran_id
                         AND l.gacc_tran_id(+) = y.gacc_tran_id
                         AND l.b160_prem_seq_no(+) = y.b140_prem_seq_no
                         AND l.b160_iss_cd(+) = y.b140_iss_cd
                         AND z.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = y.gacc_tran_id)
                    GROUP BY y.b140_iss_cd, y.b140_prem_seq_no, y.inst_no) d,
                   (SELECT   SUM (tax_amt) evat_due, iss_cd, prem_seq_no
                        FROM gipi_inv_tax
                       WHERE tax_cd = giacp.n ('EVAT') AND tax_amt <> 0
                    GROUP BY iss_cd, prem_seq_no) e,
                   (SELECT   s.iss_cd, s.prem_seq_no,
                             SUM (NVL (comm_amt, 0)) comm_paid
                        FROM giac_comm_payts s, giac_acctrans t
                       WHERE s.gacc_tran_id = t.tran_id
                         AND t.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = s.gacc_tran_id)
                    GROUP BY s.iss_cd, s.prem_seq_no) comm,
                   (SELECT   g.iss_cd, g.prem_seq_no,
                             ROUND (SUM (g.commission_amt * h.currency_rt),
                                    2
                                   ) comm_due
                        FROM gipi_comm_invoice g, gipi_invoice h
                       WHERE g.iss_cd = h.iss_cd
                         AND g.prem_seq_no = h.prem_seq_no
                    GROUP BY g.iss_cd, g.prem_seq_no) comm_due
             WHERE a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND c.policy_id <> '5'
               AND a.iss_cd = d.iss_cd
               AND a.prem_seq_no = d.prem_seq_no
               AND a.iss_cd = e.iss_cd
               AND a.prem_seq_no = e.prem_seq_no
               AND c.par_id = g.par_id
               AND g.assd_no = f.assd_no
               AND b.iss_cd = comm.iss_cd(+)
               AND b.prem_seq_no = comm.prem_seq_no(+)
               AND b.iss_cd = comm_due.iss_cd
               AND b.prem_seq_no = comm_due.prem_seq_no
               AND b.balance_amt_due = 0
               AND b.prem_balance_due <> 0
               AND ABS ((d.evat - ROUND (d.prem_amt * .12, 2))) > .01
               AND ROUND (ROUND (a.prem_amt * a.currency_rt, 2) * .12, 2) =
                                         ROUND (e.evat_due * a.currency_rt, 2)
               AND EXISTS (
                      SELECT   'X'
                          FROM gipi_installment i
                         WHERE i.iss_cd = a.iss_cd
                           AND i.prem_seq_no = a.prem_seq_no
                        HAVING COUNT (*) = 1
                      GROUP BY i.iss_cd, i.prem_seq_no)
               AND a.policy_id IN (
                      SELECT policy_id
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
                                                  zz.ginst_prem + zz.ginst_tax)
          /*AND a.policy_id NOT IN (
                 SELECT mj.policy_id
                   FROM (SELECT b160_iss_cd, b160_prem_seq_no, inst_no
                           FROM (SELECT gacc_tran_id, transaction_type,
                                        b160_iss_cd, b160_prem_seq_no,
                                        inst_no
                                   FROM (SELECT DISTINCT b.gacc_tran_id,
                                                         b.transaction_type,
                                                         b.b160_iss_cd,
                                                         b.b160_prem_seq_no,
                                                         b.inst_no
                                                    FROM giac_tax_collns b,
                                                         giac_acctrans c
                                                   WHERE gacc_tran_id =
                                                                  tran_id
                                                     AND tran_flag <> 'D'
                                                     AND NOT EXISTS (
                                                            SELECT 'X'
                                                              FROM giac_reversals xx,
                                                                   giac_acctrans yy
                                                             WHERE xx.reversing_tran_id =
                                                                      yy.tran_id
                                                               AND yy.tran_flag <>
                                                                      'D'
                                                               AND xx.gacc_tran_id =
                                                                      b.gacc_tran_id))
                                 MINUS
                                 (SELECT DISTINCT b.gacc_tran_id,
                                                  b.transaction_type,
                                                  b.b140_iss_cd,
                                                  b.b140_prem_seq_no,
                                                  b.inst_no
                                             FROM giac_direct_prem_collns b)
                                 UNION ALL
                                 SELECT NULL, NULL, 'MIKEL', NULL, NULL
                                   FROM DUAL)) jm,
                        gipi_invoice mj
                  WHERE jm.b160_iss_cd = mj.iss_cd
                    AND jm.b160_prem_seq_no = mj.prem_seq_no)*/
          UNION ALL
          SELECT   'INSTALLMENT' payt_term, assd_name,
                   get_policy_no (a.policy_id) policy_no,

                   --get_ref_no (d.gacc_tran_id) ref_no,
                   a.iss_cd || '-' || a.prem_seq_no bill_no,
                   b.inst_no inst_no, b.balance_amt_due bal_amt_due,
                   b.prem_balance_due prem_bal_due,
                   b.tax_balance_due tax_bal_due,
                   ROUND (a.prem_amt * a.currency_rt, 2) inv_prem,
                   ROUND (a.tax_amt * a.currency_rt, 2) inv_tax,
                   d.prem_amt prem_paid, d.tax_amt tax_paid,
                   ROUND (e.evat_due * a.currency_rt, 2) inv_evat,
                   d.evat evat_paid,
                   ROUND (d.prem_amt * .12, 2) evat_should_be,
                   d.evat - ROUND (d.prem_amt * .12, 2) evat_discrep,
                   comm_due inv_comm, NVL (comm_paid, 0) comm_paid,
                   NVL (comm_paid, 0) - comm_due comm_discrep, d.iss_cd,
                   d.prem_seq_no, a.policy_id
              FROM gipi_invoice a,
                   gipi_installment f,
                   giac_aging_soa_details b,
                   gipi_polbasic c,
                   giis_assured f,
                   gipi_parlist g,
                   (SELECT   y.b140_iss_cd iss_cd,
                             y.b140_prem_seq_no prem_seq_no, y.inst_no,
                             SUM (premium_amt) prem_amt, SUM (tax_amt)
                                                                      tax_amt,
                             SUM (NVL (l.evat, 0)) evat
--                           (premium_amt) prem_amt, (tax_amt) tax_amt,
--                           (NVL (l.evat, 0)) evat
                    FROM     giac_direct_prem_collns y,
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
                         AND l.gacc_tran_id(+) = y.gacc_tran_id
                         AND l.b160_prem_seq_no(+) = y.b140_prem_seq_no
                         AND l.b160_iss_cd(+) = y.b140_iss_cd
                         AND l.inst_no(+) = y.inst_no
                         AND z.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = y.gacc_tran_id)
                    GROUP BY y.b140_iss_cd, y.b140_prem_seq_no, y.inst_no) d,
                   (SELECT   SUM (tax_amt) evat_due, iss_cd, prem_seq_no
                        FROM gipi_inv_tax
                       WHERE tax_cd = giacp.n ('EVAT') AND tax_amt <> 0
                    GROUP BY iss_cd, prem_seq_no) e,
                   (SELECT   s.iss_cd, s.prem_seq_no,
                             SUM (NVL (comm_amt, 0)) comm_paid
                        FROM giac_comm_payts s, giac_acctrans t
                       WHERE s.gacc_tran_id = t.tran_id
                         AND t.tran_flag <> 'D'
                         AND NOT EXISTS (
                                SELECT 'Z'
                                  FROM giac_reversals v, giac_acctrans w
                                 WHERE v.reversing_tran_id = w.tran_id
                                   AND w.tran_flag <> 'D'
                                   AND v.gacc_tran_id = s.gacc_tran_id)
                    GROUP BY s.iss_cd, s.prem_seq_no) comm,
                   (SELECT   g.iss_cd, g.prem_seq_no,
                             ROUND (SUM (g.commission_amt * h.currency_rt),
                                    2
                                   ) comm_due
                        FROM gipi_comm_invoice g, gipi_invoice h
                       WHERE g.iss_cd = h.iss_cd
                         AND g.prem_seq_no = h.prem_seq_no
                    GROUP BY g.iss_cd, g.prem_seq_no) comm_due
             WHERE a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND c.policy_id <> '5'
               AND a.iss_cd = d.iss_cd
               AND a.prem_seq_no = d.prem_seq_no
               AND a.iss_cd = e.iss_cd
               AND a.prem_seq_no = e.prem_seq_no
               AND a.iss_cd = f.iss_cd
               AND a.prem_seq_no = f.prem_seq_no
               AND f.inst_no = b.inst_no
               AND f.inst_no = d.inst_no
               AND c.par_id = g.par_id
               AND g.assd_no = f.assd_no
               AND b.iss_cd = comm.iss_cd(+)
               AND b.prem_seq_no = comm.prem_seq_no(+)
               AND b.iss_cd = comm_due.iss_cd
               AND b.prem_seq_no = comm_due.prem_seq_no
               AND b.balance_amt_due = 0
               AND b.prem_balance_due <> 0
               --AND ROUND(d.prem_amt * .12,2) <> d.evat
               AND ABS ((d.evat - ROUND (d.prem_amt * .12, 2))) > .01
               AND ROUND (ROUND (a.prem_amt * a.currency_rt, 2) * .12, 2) =
                                         ROUND (e.evat_due * a.currency_rt, 2)
               AND b.inst_no = 1
               AND EXISTS (
                      SELECT   'X'
                          FROM gipi_installment i
                         WHERE i.iss_cd = a.iss_cd
                           AND i.prem_seq_no = a.prem_seq_no
                        HAVING COUNT (*) > 1
                      GROUP BY i.iss_cd, i.prem_seq_no)
               AND a.policy_id IN (
                      SELECT policy_id
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
                                                  zz.ginst_prem + zz.ginst_tax)
          /*AND a.policy_id NOT IN (
                 SELECT mj.policy_id
                   FROM (SELECT b160_iss_cd, b160_prem_seq_no, inst_no
                           FROM (SELECT gacc_tran_id, transaction_type,
                                        b160_iss_cd, b160_prem_seq_no,
                                        inst_no
                                   FROM (SELECT DISTINCT b.gacc_tran_id,
                                                         b.transaction_type,
                                                         b.b160_iss_cd,
                                                         b.b160_prem_seq_no,
                                                         b.inst_no
                                                    FROM giac_tax_collns b,
                                                         giac_acctrans c
                                                   WHERE gacc_tran_id =
                                                                  tran_id
                                                     AND tran_flag <> 'D'
                                                     AND NOT EXISTS (
                                                            SELECT 'X'
                                                              FROM giac_reversals xx,
                                                                   giac_acctrans yy
                                                             WHERE xx.reversing_tran_id =
                                                                      yy.tran_id
                                                               AND yy.tran_flag <>
                                                                      'D'
                                                               AND xx.gacc_tran_id =
                                                                      b.gacc_tran_id))
                                 MINUS
                                 (SELECT DISTINCT b.gacc_tran_id,
                                                  b.transaction_type,
                                                  b.b140_iss_cd,
                                                  b.b140_prem_seq_no,
                                                  b.inst_no
                                             FROM giac_direct_prem_collns b)
                                 UNION ALL
                                 SELECT NULL, NULL, 'MIKEL', NULL, NULL
                                   FROM DUAL)) jm,
                        gipi_invoice mj
                  WHERE jm.b160_iss_cd = mj.iss_cd
                    AND jm.b160_prem_seq_no = mj.prem_seq_no)*/
          ORDER BY 20, 21)
      LOOP
         v_evat_should_be := 0;
         v_count_payt := 0;
         v_crr.policy_id := r.policy_id;

         FOR gdpc IN (SELECT   get_ref_no (y.gacc_tran_id) ref_no, y.user_id,
                               y.last_update, y.b140_iss_cd iss_cd,
                               y.b140_prem_seq_no prem_seq_no,
                               (premium_amt) prem_paid, (tax_amt) tax_paid,
                               (NVL (l.evat, 0)) evat_paid,
                               ROUND (y.premium_amt * .12, 2) evat_should_be,
                                 NVL (l.evat, 0)
                               - ROUND (y.premium_amt * .12, 2) evat_discrep,
                               NVL (x.or_date, z.tran_date) or_date,
                               posting_date
                          FROM giac_direct_prem_collns y,
                               giac_order_of_payts x,
                               giac_acctrans z,
                               (SELECT   SUM (k.tax_amt) evat, k.gacc_tran_id,
                                         k.b160_iss_cd, k.b160_prem_seq_no
                                    FROM giac_tax_collns k
                                   WHERE k.b160_tax_cd = giacp.n ('EVAT')
                                GROUP BY k.gacc_tran_id,
                                         k.b160_iss_cd,
                                         k.b160_prem_seq_no) l
                         WHERE y.gacc_tran_id = z.tran_id
                           AND y.gacc_tran_id = x.gacc_tran_id(+)
                           AND l.gacc_tran_id(+) = y.gacc_tran_id
                           AND l.b160_prem_seq_no(+) = y.b140_prem_seq_no
                           AND l.b160_iss_cd(+) = y.b140_iss_cd
                           AND z.tran_flag <> 'D'
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
            v_evat_should_be := v_evat_should_be + gdpc.evat_should_be;
            v_count_payt := v_count_payt + 1;
            v_crr.payment_term := r.payt_term;
            v_crr.assured_name := r.assd_name;
            v_crr.policy_no := r.policy_no;
            v_crr.reference_no := gdpc.ref_no;
            v_crr.invoice_no := r.bill_no;
            v_crr.inst_no := r.inst_no;
            v_crr.prem_paid := gdpc.prem_paid;
            v_crr.tax_paid := gdpc.tax_paid;
            v_crr.evat_paid := gdpc.evat_paid;
            v_crr.user_id := gdpc.user_id;
            v_crr.last_update := gdpc.last_update;
            v_crr.or_date := gdpc.or_date;
            v_crr.posting_date := gdpc.posting_date;


            IF r.bill_no <> NVL (v_last_bill, 'MIKELRAZON')
            THEN
               IF r.inv_evat = gdpc.evat_paid
               THEN
                  --NULL;--EXIT;
                  v_crr.evat_should_be := r.inv_evat;
                  v_crr.evat_discrep := gdpc.evat_paid - r.inv_evat;
               ELSIF     ABS (r.inv_evat) - ABS (v_evat_should_be) < 0
                     AND v_count_payt = 1
               THEN
                  v_crr.evat_should_be := r.inv_evat;
                  v_crr.evat_discrep := gdpc.evat_paid - r.inv_evat;
               ELSE
                  v_crr.evat_should_be := gdpc.evat_should_be;
                  v_crr.evat_discrep := gdpc.evat_discrep;
               END IF;

               v_crr.bal_amt_due := r.bal_amt_due;
               v_crr.prem_bal_due := r.prem_bal_due;
               v_crr.tax_bal_due := r.tax_bal_due;
               v_crr.inv_prem := r.inv_prem;
               v_crr.inv_tax := r.inv_tax;
               v_crr.inv_evat := r.inv_evat;
               v_crr.inv_comm := r.inv_comm;
               v_crr.comm_paid := r.comm_paid;
               v_crr.comm_discrep := r.comm_discrep;
               v_crr.user_id := gdpc.user_id;
               v_crr.last_update := gdpc.last_update;
               v_last_bill := r.bill_no;
            ELSE
               /*v_crr.bal_amt_due := NULL;
               v_crr.prem_bal_due := NULL;
               v_crr.tax_bal_due := NULL;
               v_crr.inv_prem := NULL;
               v_crr.inv_tax := NULL;
               v_crr.inv_evat := NULL;
               v_crr.evat_should_be := gdpc.evat_should_be;
               v_crr.evat_discrep := gdpc.evat_discrep;
               v_crr.inv_comm := NULL;
               v_crr.comm_paid := NULL;
               v_crr.comm_discrep := NULL;
               v_last_bill := r.bill_no;*/
               v_crr.bal_amt_due := r.bal_amt_due;
               v_crr.prem_bal_due := r.prem_bal_due;
               v_crr.tax_bal_due := r.tax_bal_due;
               v_crr.inv_prem := r.inv_prem;
               v_crr.inv_tax := r.inv_tax;
               v_crr.inv_evat := r.inv_evat;
               v_crr.evat_should_be := gdpc.evat_should_be;
               v_crr.evat_discrep := gdpc.evat_discrep;
               v_crr.inv_comm := r.inv_comm;
               v_crr.comm_paid := r.comm_paid;
               v_crr.comm_discrep := r.comm_discrep;
               v_last_bill := r.bill_no;
            END IF;

            PIPE ROW (v_crr);
         END LOOP;
      END LOOP;

      RETURN;
   END fully_paid2;
END pivot_records;
/


