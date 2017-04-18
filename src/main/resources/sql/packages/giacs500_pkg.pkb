CREATE OR REPLACE PACKAGE BODY CPI.giacs500_pkg
AS
   FUNCTION validate_transaction_date (p_tran_date DATE)
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 0;
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_monthly_totals
                 WHERE tran_year = TO_CHAR (p_tran_date, 'YYYY')
                   AND tran_mm = TO_CHAR (p_tran_date, 'MM'))
      LOOP
         RETURN '1';
      END LOOP;

      RETURN '0';
   END;

   FUNCTION check_tran_open (
      p_tran_date       DATE,
      p_include_month   VARCHAR2,
      p_include_year    VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (10) := 0;
   BEGIN
      IF p_include_month = 'N' AND p_include_year = 'N'
      THEN
         SELECT COUNT (*)
           INTO v_exists
           FROM giac_acctrans gacc
          WHERE gacc.tran_flag = 'O'
            AND TRUNC (gacc.tran_date) <= TRUNC (p_tran_date)
            AND TO_CHAR (gacc.tran_date, 'YYYY') =
                                                 TO_CHAR (p_tran_date, 'YYYY')
            AND TO_CHAR (gacc.tran_date, 'MM') = TO_CHAR (p_tran_date, 'MM')
            AND gacc.tran_class <> 'DV';
      ELSIF p_include_month = 'Y' AND p_include_year = 'N'
      THEN
         SELECT COUNT (*)
           INTO v_exists
           FROM giac_acctrans gacc
          WHERE gacc.tran_flag = 'O'
            AND TRUNC (gacc.tran_date) <= TRUNC (p_tran_date)
            AND TO_CHAR (gacc.tran_date, 'YYYY') =
                                                 TO_CHAR (p_tran_date, 'YYYY')
            AND gacc.tran_class <> 'DV';
      ELSIF p_include_month = 'Y' AND p_include_year = 'Y'
      THEN
         SELECT COUNT (*)
           INTO v_exists
           FROM giac_acctrans gacc
          WHERE gacc.tran_flag = 'O'
            AND TRUNC (gacc.tran_date) <= TRUNC (p_tran_date)
            AND gacc.tran_class <> 'DV';
      END IF;

      RETURN v_exists;
   END;

   FUNCTION check_date (p_tran_date DATE)
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (10);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_tran_mm
                 WHERE closed_tag = 'Y'
                   AND tran_yr = NVL (TO_CHAR (p_tran_date, 'YYYY'), NULL)
                   AND tran_mm = NVL (TO_CHAR (p_tran_date, 'MM'), NULL))
      LOOP
         RETURN 'CLOSEDGL';
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_monthly_totals
                 WHERE close_tag = 'Y'
                   AND tran_year = TO_CHAR (p_tran_date, 'YYYY')
                   AND tran_mm = TO_CHAR (p_tran_date, 'MM'))
      LOOP
         RETURN 'CLOSEDTB';
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_monthly_totals
                 WHERE tran_year = NVL (TO_CHAR (p_tran_date, 'YYYY'), NULL)
                   AND tran_mm = NVL (TO_CHAR (p_tran_date, 'MM'), NULL))
      LOOP
         RETURN 'RERUN';
      END LOOP;

      RETURN 'PROCEED';
   END;

   PROCEDURE del_giac_monthly_totals_backup
   IS
   BEGIN
      DELETE FROM giac_monthly_totals_backup;
   END;

   PROCEDURE ins_giac_monthly_totals_backup (p_tran_date DATE)
   IS
   BEGIN
      FOR y IN (SELECT gl_acct_id, fund_cd, branch_cd, tran_year, tran_mm,
                       total_debit_amt, total_credit_amt, trans_debit_bal,
                       trans_credit_bal, trans_balance
                  FROM giac_monthly_totals
                 WHERE tran_mm = NVL (TO_CHAR (p_tran_date, 'MM'), NULL)
                   AND tran_year = NVL (TO_CHAR (p_tran_date, 'YYYY'), NULL))
      LOOP
         INSERT INTO giac_monthly_totals_backup
                     (gl_acct_id, fund_cd, branch_cd, tran_year,
                      tran_mm, total_debit_amt, total_credit_amt,
                      trans_debit_bal, trans_credit_bal,
                      trans_balance, leaf_tag
                     )
              VALUES (y.gl_acct_id, y.fund_cd, y.branch_cd, y.tran_year,
                      y.tran_mm, y.total_debit_amt, y.total_credit_amt,
                      y.trans_debit_bal, y.trans_credit_bal,
                      y.trans_balance, 'Y'
                     );
      END LOOP;
   END;

   PROCEDURE update_acctransae (p_tran_date DATE, p_update_action VARCHAR2)
   IS
   BEGIN
      IF p_update_action = 'updateAcctrans'
      THEN
         UPDATE giac_acctrans
            SET tran_flag = 'O'
          WHERE tran_id IN (
                   SELECT   a.tran_id
                       FROM giac_acctrans a, giac_acct_entries b
                      WHERE a.tran_id = b.gacc_tran_id
                        AND a.tran_flag = 'C'
                        AND TRUNC (tran_date) <= p_tran_date
                        AND TO_CHAR (tran_date, 'MM') =
                                                   TO_CHAR (p_tran_date, 'MM')
                        AND TO_CHAR (tran_date, 'YYYY') =
                                                 TO_CHAR (p_tran_date, 'YYYY')
                     HAVING NVL (SUM (debit_amt), 0) <>
                                                     NVL (SUM (credit_amt), 0)
                   GROUP BY tran_id);

         UPDATE giac_acctrans a
            SET tran_flag = 'P',
                posting_date = p_tran_date
          WHERE tran_flag = 'C'
            AND TRUNC (tran_date) <= p_tran_date
            AND NVL (ae_tag, 'N') <> 'Y'
            AND NVL (tb_exclude_tag, 'N') = 'N'
            AND TO_CHAR (tran_date, 'MM') = TO_CHAR (p_tran_date, 'MM')
            AND TO_CHAR (tran_date, 'YYYY') = TO_CHAR (p_tran_date, 'YYYY');
      ELSIF p_update_action = 'updateAcctransAe'
      THEN
         UPDATE giac_acctrans
            SET tran_flag = 'O'
          WHERE tran_id IN (
                   SELECT   a.tran_id
                       FROM giac_acctrans a, giac_acct_entries b
                      WHERE a.tran_id = b.gacc_tran_id
                        AND a.tran_flag = 'C'
                        AND TRUNC (tran_date) <= p_tran_date
                        AND TO_CHAR (tran_date, 'MM') =
                                                   TO_CHAR (p_tran_date, 'MM')
                        AND TO_CHAR (tran_date, 'YYYY') =
                                                 TO_CHAR (p_tran_date, 'YYYY')
                        AND a.ae_tag = 'Y'
                     HAVING SUM (debit_amt) <> SUM (credit_amt)
                   GROUP BY tran_id);

         UPDATE giac_acctrans a
            SET tran_flag = 'P',
                posting_date = p_tran_date
          WHERE tran_flag = 'C'
            AND TRUNC (tran_date) <= p_tran_date
            AND TO_CHAR (tran_date, 'MM') = TO_CHAR (p_tran_date, 'MM')
            AND TO_CHAR (tran_date, 'YYYY') = TO_CHAR (p_tran_date, 'YYYY')
            AND NVL (tb_exclude_tag, 'N') = 'N'
            AND a.ae_tag = 'Y';
      ELSIF p_update_action = 'updateAcctrans1'
      THEN
         UPDATE giac_acctrans
            SET tran_flag = 'O'
          WHERE tran_id IN (
                   SELECT   a.tran_id
                       FROM giac_acctrans a, giac_acct_entries b
                      WHERE a.tran_id = b.gacc_tran_id
                        AND a.tran_flag = 'C'
                        AND TRUNC (tran_date) <= TRUNC (p_tran_date)
                        AND TO_CHAR (tran_date, 'YYYY') =
                                                 TO_CHAR (p_tran_date, 'YYYY')
                     HAVING NVL (SUM (debit_amt), 0) <>
                                                     NVL (SUM (credit_amt), 0)
                   GROUP BY tran_id);

         UPDATE giac_acctrans a
            SET tran_flag = 'P',
                posting_date = p_tran_date
          WHERE tran_flag = 'C'
            AND NVL (ae_tag, 'N') <> 'Y'
            AND TRUNC (tran_date) <= TRUNC (p_tran_date)
            AND NVL (tb_exclude_tag, 'N') = 'N'
            AND TO_CHAR (tran_date, 'YYYY') = TO_CHAR (p_tran_date, 'YYYY');
      ELSIF p_update_action = 'updateAcctransAe1'
      THEN
         UPDATE giac_acctrans
            SET tran_flag = 'O'
          WHERE tran_id IN (
                   SELECT   a.tran_id
                       FROM giac_acctrans a, giac_acct_entries b
                      WHERE a.tran_id = b.gacc_tran_id
                        AND a.tran_flag = 'C'
                        AND TRUNC (tran_date) <= TRUNC (p_tran_date)
                        AND TO_CHAR (tran_date, 'MM') =
                                                   TO_CHAR (p_tran_date, 'MM')
                        AND TO_CHAR (tran_date, 'YYYY') =
                                                 TO_CHAR (p_tran_date, 'YYYY')
                        AND a.ae_tag = 'Y'
                     HAVING SUM (debit_amt) <> SUM (credit_amt)
                   GROUP BY tran_id);

         UPDATE giac_acctrans a
            SET tran_flag = 'P',
                posting_date = p_tran_date
          WHERE tran_flag = 'C'
            AND TRUNC (tran_date) <= TRUNC (p_tran_date)
            AND TO_CHAR (tran_date, 'YYYY') = TO_CHAR (p_tran_date, 'YYYY')
            AND NVL (tb_exclude_tag, 'N') = 'N'
            AND a.ae_tag = 'Y';
      ELSIF p_update_action = 'updateAcctrans2'
      THEN
         UPDATE giac_acctrans
            SET tran_flag = 'O'
          WHERE tran_id IN (
                   SELECT   a.tran_id
                       FROM giac_acctrans a, giac_acct_entries b
                      WHERE a.tran_id = b.gacc_tran_id
                        AND a.tran_flag = 'C'
                        AND TRUNC (tran_date) <= p_tran_date
                     HAVING NVL (SUM (debit_amt), 0) <>
                                                     NVL (SUM (credit_amt), 0)
                   GROUP BY tran_id);

         UPDATE giac_acctrans a
            SET tran_flag = 'P',
                posting_date = p_tran_date
          WHERE tran_flag = 'C'
            AND TRUNC (tran_date) <= p_tran_date
            AND NVL (tb_exclude_tag, 'N') = 'N'
            AND NVL (ae_tag, 'N') <> 'Y';
      ELSIF p_update_action = 'updateAcctransAe2'
      THEN
         UPDATE giac_acctrans
            SET tran_flag = 'O'
          WHERE tran_id IN (
                   SELECT   a.tran_id
                       FROM giac_acctrans a, giac_acct_entries b
                      WHERE a.tran_id = b.gacc_tran_id
                        AND a.tran_flag = 'C'
                        AND TRUNC (tran_date) <= p_tran_date
                        AND TO_CHAR (tran_date, 'MM') =
                                                   TO_CHAR (p_tran_date, 'MM')
                        AND TO_CHAR (tran_date, 'YYYY') =
                                                 TO_CHAR (p_tran_date, 'YYYY')
                        AND a.ae_tag = 'Y'
                     HAVING SUM (debit_amt) <> SUM (credit_amt)
                   GROUP BY tran_id);

         UPDATE giac_acctrans a
            SET tran_flag = 'P',
                posting_date = p_tran_date
          WHERE tran_flag = 'C'
            AND TRUNC (tran_date) <= p_tran_date
            AND NVL (tb_exclude_tag, 'N') = 'N'
            AND a.ae_tag = 'Y';
      END IF;
   END;

   FUNCTION get_no_of_records (p_tran_date DATE)
      RETURN VARCHAR2
   IS
      no_of_records   NUMBER := 0;
   BEGIN
      FOR c IN (SELECT   b.gl_acct_id, a.gfun_fund_cd, a.gibr_branch_cd,
                         TO_CHAR (p_tran_date, 'YYYY') param_year,
                         TO_CHAR (p_tran_date, 'MM') param_mm,
                         SUM (NVL (b.debit_amt, 0)) sum_debit,
                         SUM (NVL (b.credit_amt, 0)) sum_credit,
                         DECODE (SIGN (  SUM (NVL (b.debit_amt, 0))
                                       - SUM (NVL (b.credit_amt, 0))
                                      ),
                                 1, SUM (NVL (b.debit_amt, 0))
                                  - SUM (NVL (b.credit_amt, 0)),
                                 0
                                ) decode1,
                         DECODE (SIGN (  SUM (NVL (b.credit_amt, 0))
                                       - SUM (NVL (b.debit_amt, 0))
                                      ),
                                 1, SUM (NVL (b.credit_amt, 0))
                                  - SUM (NVL (b.debit_amt, 0)),
                                 0
                                ) decode2,
                           SUM (NVL (b.debit_amt, 0))
                         - SUM (NVL (b.credit_amt, 0)) transact_balance
                    FROM giac_acctrans a, giac_acct_entries b
                   WHERE a.tran_id = b.gacc_tran_id
                     AND a.tran_flag = 'P'
                     AND TO_CHAR (posting_date, 'MM-YYYY') =
                                              TO_CHAR (p_tran_date, 'MM-YYYY')
                GROUP BY b.gl_acct_id, a.gfun_fund_cd, a.gibr_branch_cd)
      LOOP
         no_of_records := no_of_records + 1;
      END LOOP;

      RETURN no_of_records;
   END;

   PROCEDURE del_giac_monthly_totals (p_tran_date DATE)
   IS
   BEGIN
      DELETE      giac_monthly_totals
            WHERE tran_mm = NVL (TO_CHAR (p_tran_date, 'MM'), NULL)
              AND tran_year = NVL (TO_CHAR (p_tran_date, 'YYYY'), NULL);
   END;

   PROCEDURE ins_giac_monthly_totals (p_tran_date DATE, p_user_id VARCHAR2)
   IS
      no_of_records   NUMBER := 0;
   BEGIN
      FOR c IN (SELECT   b.gl_acct_id, a.gfun_fund_cd, a.gibr_branch_cd,
                         TO_CHAR (p_tran_date, 'YYYY') param_year,
                         TO_CHAR (p_tran_date, 'MM') param_mm,
                         SUM (NVL (b.debit_amt, 0)) sum_debit,
                         SUM (NVL (b.credit_amt, 0)) sum_credit,
                         DECODE (SIGN (  SUM (NVL (b.debit_amt, 0))
                                       - SUM (NVL (b.credit_amt, 0))
                                      ),
                                 1, SUM (NVL (b.debit_amt, 0))
                                  - SUM (NVL (b.credit_amt, 0)),
                                 0
                                ) decode1,
                         DECODE (SIGN (  SUM (NVL (b.credit_amt, 0))
                                       - SUM (NVL (b.debit_amt, 0))
                                      ),
                                 1, SUM (NVL (b.credit_amt, 0))
                                  - SUM (NVL (b.debit_amt, 0)),
                                 0
                                ) decode2,
                           SUM (NVL (b.debit_amt, 0))
                         - SUM (NVL (b.credit_amt, 0)) transact_balance
                    FROM giac_acctrans a, giac_acct_entries b
                   WHERE a.tran_id = b.gacc_tran_id
                     AND a.tran_flag = 'P'
                     AND TO_CHAR (posting_date, 'MM-YYYY') =
                                              TO_CHAR (p_tran_date, 'MM-YYYY')
                GROUP BY b.gl_acct_id, a.gfun_fund_cd, a.gibr_branch_cd)
      LOOP
         no_of_records := no_of_records + 1;

         INSERT INTO giac_monthly_totals
                     (gl_acct_id, fund_cd, branch_cd,
                      tran_year, tran_mm, beg_debit_amt,
                      beg_credit_amt, total_debit_amt, total_credit_amt,
                      trans_debit_bal, trans_credit_bal, trans_balance,
                      end_debit_amt, end_credit_amt, leaf_tag, user_id,
                      last_update
                     )
              VALUES (c.gl_acct_id, c.gfun_fund_cd, c.gibr_branch_cd,
                      TO_NUMBER (c.param_year), TO_NUMBER (c.param_mm), 0,
                      0, c.sum_debit, c.sum_credit,
                      c.decode1, c.decode2, c.transact_balance,
                      0, 0, 'Y', p_user_id,
                      SYSDATE
                     );
      END LOOP;
   END;
END;
/


