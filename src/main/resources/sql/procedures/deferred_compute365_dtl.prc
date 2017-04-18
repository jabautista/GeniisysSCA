DROP PROCEDURE CPI.DEFERRED_COMPUTE365_DTL;

CREATE OR REPLACE PROCEDURE CPI.deferred_compute365_dtl (
   p_ext_year   NUMBER,
   p_ext_mm     NUMBER,
   p_method     NUMBER
)
IS
   v_prev_def_prem_amt       giac_deferred_gross_prem.prev_def_prem_amt%TYPE;
   v_def_prem_amt_diff       giac_deferred_gross_prem.def_prem_amt_diff%TYPE;
   v_prev_def_dist_prem      giac_deferred_ri_prem_ceded.prev_def_dist_prem%TYPE;
   v_def_dist_prem_diff      giac_deferred_ri_prem_ceded.def_dist_prem_diff%TYPE;
   v_prev_def_comm_income    giac_deferred_comm_income.prev_def_comm_income%TYPE;
   v_def_comm_income_diff    giac_deferred_comm_income.def_comm_income_diff%TYPE;
   v_prev_def_comm_expense   giac_deferred_comm_expense.prev_def_comm_expense%TYPE;
   v_def_comm_expense_diff   giac_deferred_comm_expense.def_comm_expense_diff%TYPE;
   v_exists                  NUMBER;
   --mikel 02.05.2013
   v_prev_def_comm_exp       NUMBER (16, 2);
   v_last_comm_exp           NUMBER (16, 2);
   v_prev_def_comm_inc       NUMBER (16, 2);
   v_last_comm_inc           NUMBER (16, 2);
BEGIN
   v_exists := 0;

   /* Check for previous extract */
   FOR chk IN (SELECT gen_tag
                 FROM giac_deferred_extract
                WHERE YEAR = p_ext_year
                  AND mm = p_ext_mm
                  AND procedure_id = p_method)
   LOOP
      IF chk.gen_tag = 'Y'
      THEN
         raise_application_error
            (-20200,
             'PREVIOUS EXTRACT FOR THIS YEAR AND MM HAS ALREADY BEEN POSTED.'
            );
      ELSE
         v_exists := 1;

         UPDATE giac_deferred_extract
            SET user_id = USER,
                last_compute = SYSDATE
          WHERE YEAR = p_ext_year AND mm = p_ext_mm
                AND procedure_id = p_method;
      END IF;

      EXIT;
   END LOOP;

   IF v_exists = 0
   THEN
      raise_application_error (-20203, 'YOU HAVE NOT YET EXTRACTED DATA FOR COMPUTATION.');
   END IF;

   /* Update Detail Tables */
   BEGIN
      /* Deferred Gross Premium */
      UPDATE giac_deferred_gross_prem_pol
         SET def_prem_amt = prem_amt
                            * (numerator_factor / denominator_factor),
             user_id = USER,
             last_update = SYSDATE
       WHERE extract_year = p_ext_year
         AND extract_mm = p_ext_mm;

      /* Deferred RI Premium */
      UPDATE giac_deferred_ri_prem_cede_pol
         SET def_dist_prem =
                           dist_prem
                           * (numerator_factor / denominator_factor),
             user_id = USER,
             last_update = SYSDATE
       WHERE extract_year = p_ext_year
         AND extract_mm = p_ext_mm;

      /* Commission Income */
      /*
      UPDATE giac_deferred_comm_income_pol
         SET def_comm_income =
                         comm_income
                         * (numerator_factor / denominator_factor),
             user_id = USER,
             last_update = SYSDATE
       WHERE extract_year = p_ext_year AND extract_mm = p_ext_mm;*/
        -- mikel 02.05.2013; adjust computation of last month
      BEGIN
         FOR rec IN (SELECT policy_no, comm_income, def_comm_income,
                        expiry_date, ri_cd, acct_trty_type
                       FROM giac_deferred_comm_income_pol
                      WHERE extract_year = p_ext_year
                        AND extract_mm = p_ext_mm)
         LOOP
            IF TO_CHAR (TO_DATE (rec.expiry_date), 'mm-yyyy') =
                                                p_ext_mm || '-' || p_ext_year
            THEN
               BEGIN
                   SELECT   SUM (def_comm_income)
                       INTO v_prev_def_comm_inc
                       FROM giac_deferred_comm_income_pol
                      WHERE extract_mm || '-' || extract_year <>
                                                     p_ext_mm || '-' || p_ext_year
                        AND policy_no = rec.policy_no
                        AND ri_cd = rec.ri_cd
                        AND acct_trty_type = rec.acct_trty_type
                   GROUP BY policy_no, ri_cd, acct_trty_type;
               EXCEPTION WHEN NO_DATA_FOUND THEN
                    v_prev_def_comm_inc := 0;
               END;

               v_last_comm_inc := rec.comm_income - v_prev_def_comm_inc;

               UPDATE giac_deferred_comm_income_pol
                  SET def_comm_income = v_last_comm_inc,
                      user_id = USER,
                      last_update = SYSDATE
                WHERE extract_year = p_ext_year
                  AND extract_mm = p_ext_mm
                  AND policy_no = rec.policy_no
                  AND ri_cd = rec.ri_cd
                  AND acct_trty_type = rec.acct_trty_type;
            ELSE
               UPDATE giac_deferred_comm_income_pol
                  SET def_comm_income =
                         comm_income
                         * (numerator_factor / denominator_factor),
                      user_id = USER,
                      last_update = SYSDATE
                WHERE extract_year = p_ext_year
                  AND extract_mm = p_ext_mm
                  AND policy_no = rec.policy_no
                  AND ri_cd = rec.ri_cd
                  AND acct_trty_type = rec.acct_trty_type;
            END IF;
         END LOOP;
      END;

      /* Commission Expense */
      /*UPDATE giac_deferred_comm_expense_pol
         SET def_comm_expense =
                        comm_expense
                        * (numerator_factor / denominator_factor),
             user_id = USER,
             last_update = SYSDATE
       WHERE extract_year = p_ext_year AND extract_mm = p_ext_mm;*/
       -- mikel 02.05.2013; adjust computation of last month
      BEGIN
         FOR rec IN (SELECT policy_no, comm_expense, def_comm_expense,
                            expiry_date
                       FROM giac_deferred_comm_expense_pol
                      WHERE extract_year = p_ext_year
                        AND extract_mm = p_ext_mm)
         LOOP
            IF TO_CHAR (TO_DATE (rec.expiry_date), 'mm-yyyy') =
                                                p_ext_mm || '-' || p_ext_year
            THEN
               BEGIN
                   SELECT   SUM (def_comm_expense)
                       INTO v_prev_def_comm_exp
                       FROM giac_deferred_comm_expense_pol
                      WHERE extract_mm || '-' || extract_year <>
                                                     p_ext_mm || '-' || p_ext_year
                        AND policy_no = rec.policy_no
                   GROUP BY policy_no;
               EXCEPTION WHEN NO_DATA_FOUND THEN
                    v_prev_def_comm_exp := 0;
               END;

               v_last_comm_exp := rec.comm_expense - v_prev_def_comm_exp;

               UPDATE giac_deferred_comm_expense_pol
                  SET def_comm_expense = v_last_comm_exp,
                      user_id = USER,
                      last_update = SYSDATE
                WHERE extract_year = p_ext_year
                  AND extract_mm = p_ext_mm
                  AND policy_no = rec.policy_no;
            ELSE
               UPDATE giac_deferred_comm_expense_pol
                  SET def_comm_expense =
                           comm_expense
                         * (numerator_factor / denominator_factor),
                      user_id = USER,
                      last_update = SYSDATE
                WHERE extract_year = p_ext_year
                  AND extract_mm = p_ext_mm
                  AND policy_no = rec.policy_no;
            END IF;
         END LOOP;
      END;
   END;

   /* Update Main Tables */
   BEGIN
      FOR gross IN (SELECT   iss_cd, line_cd,
                             SUM (NVL (def_prem_amt, 0)) def_prem_amt
                        FROM giac_deferred_gross_prem_pol
                       WHERE extract_year = p_ext_year
                         AND extract_mm = p_ext_mm
                         AND procedure_id = p_method
                    GROUP BY iss_cd, line_cd)
      LOOP
         BEGIN
            SELECT NVL (def_prem_amt, 0)
              INTO v_prev_def_prem_amt
              FROM giac_deferred_gross_prem
             WHERE (   (YEAR = (p_ext_year - 1) AND mm = 12 AND p_ext_mm = 1)
                    OR (    YEAR = p_ext_year
                        AND mm = (p_ext_mm - 1)
                        AND p_ext_mm != 1
                       )
                   )
               AND procedure_id = p_method
               AND iss_cd = gross.iss_cd
               AND line_cd = gross.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_prev_def_prem_amt := 0;
         END;

         v_def_prem_amt_diff := gross.def_prem_amt - v_prev_def_prem_amt;

         UPDATE giac_deferred_gross_prem
            SET def_prem_amt = gross.def_prem_amt,
                prev_def_prem_amt = v_prev_def_prem_amt,
                def_prem_amt_diff = v_def_prem_amt_diff,
                numerator_factor = NULL,
                denominator_factor = NULL,
                user_id = USER,
                last_update = SYSDATE
          WHERE YEAR = p_ext_year
            AND mm = p_ext_mm
            AND procedure_id = p_method
            AND iss_cd = gross.iss_cd
            AND line_cd = gross.line_cd;
      END LOOP;

      FOR ri_prem IN (SELECT   iss_cd, line_cd, share_type, acct_trty_type,
                               SUM (NVL (def_dist_prem, 0)) def_dist_prem
                          FROM giac_deferred_ri_prem_cede_pol
                         WHERE extract_year = p_ext_year
                           AND extract_mm = p_ext_mm
                           AND procedure_id = p_method
                      GROUP BY iss_cd, line_cd, share_type, acct_trty_type)
      LOOP
         BEGIN
            SELECT NVL (def_dist_prem, 0)
              INTO v_prev_def_dist_prem
              FROM giac_deferred_ri_prem_ceded
             WHERE (   (YEAR = (p_ext_year - 1) AND mm = 12 AND p_ext_mm = 1)
                    OR (    YEAR = p_ext_year
                        AND mm = (p_ext_mm - 1)
                        AND p_ext_mm != 1
                       )
                   )
               AND iss_cd = ri_prem.iss_cd
               AND line_cd = ri_prem.line_cd
               AND procedure_id = p_method
               AND share_type = ri_prem.share_type
               AND acct_trty_type = ri_prem.acct_trty_type;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_prev_def_dist_prem := 0;
         END;

         v_def_dist_prem_diff := ri_prem.def_dist_prem - v_prev_def_dist_prem;

         UPDATE giac_deferred_ri_prem_ceded
            SET def_dist_prem = ri_prem.def_dist_prem,
                prev_def_dist_prem = v_prev_def_dist_prem,
                def_dist_prem_diff = v_def_dist_prem_diff,
                numerator_factor = NULL,
                denominator_factor = NULL,
                user_id = USER,
                last_update = SYSDATE
          WHERE YEAR = p_ext_year
            AND mm = p_ext_mm
            AND iss_cd = ri_prem.iss_cd
            AND line_cd = ri_prem.line_cd
            AND procedure_id = p_method
            AND share_type = ri_prem.share_type
            AND acct_trty_type = ri_prem.acct_trty_type;
      END LOOP;

      FOR comm IN (SELECT   iss_cd, line_cd, share_type, acct_trty_type,
                            ri_cd,
                            SUM (NVL (def_comm_income, 0)) def_comm_income
                       FROM giac_deferred_comm_income_pol
                      WHERE extract_year = p_ext_year
                        AND extract_mm = p_ext_mm
                        AND procedure_id = p_method
                   GROUP BY iss_cd, line_cd, share_type, acct_trty_type,
                            ri_cd)
      LOOP
         BEGIN
            SELECT NVL (def_comm_income, 0)
              INTO v_prev_def_comm_income
              FROM giac_deferred_comm_income
             WHERE (   (YEAR = (p_ext_year - 1) AND mm = 12 AND p_ext_mm = 1)
                    OR (    YEAR = p_ext_year
                        AND mm = (p_ext_mm - 1)
                        AND p_ext_mm != 1
                       )
                   )
               AND iss_cd = comm.iss_cd
               AND line_cd = comm.line_cd
               AND procedure_id = p_method
               AND share_type = comm.share_type
               AND acct_trty_type = comm.acct_trty_type
               AND ri_cd = comm.ri_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_prev_def_comm_income := 0;
         END;

         v_def_comm_income_diff :=
                                 comm.def_comm_income - v_prev_def_comm_income;

         UPDATE giac_deferred_comm_income
            SET def_comm_income = comm.def_comm_income,
                prev_def_comm_income = v_prev_def_comm_income,
                def_comm_income_diff = v_def_comm_income_diff,
                numerator_factor = NULL,
                denominator_factor = NULL,
                user_id = USER,
                last_update = SYSDATE
          WHERE YEAR = p_ext_year
            AND mm = p_ext_mm
            AND iss_cd = comm.iss_cd
            AND line_cd = comm.line_cd
            AND procedure_id = p_method
            AND share_type = comm.share_type
            AND acct_trty_type = comm.acct_trty_type
            AND ri_cd = comm.ri_cd;
      END LOOP;

      FOR expen IN (SELECT   iss_cd, line_cd, intm_ri,
                             SUM (NVL (def_comm_expense, 0)) def_comm_expense
                        FROM giac_deferred_comm_expense_pol
                       WHERE extract_year = p_ext_year
                         AND extract_mm = p_ext_mm
                         AND procedure_id = p_method
                    GROUP BY iss_cd, line_cd, intm_ri)
      LOOP
         BEGIN
            SELECT NVL (def_comm_expense, 0)
              INTO v_prev_def_comm_expense
              FROM giac_deferred_comm_expense
             WHERE (   (YEAR = (p_ext_year - 1) AND mm = 12 AND p_ext_mm = 1)
                    OR (    YEAR = p_ext_year
                        AND mm = (p_ext_mm - 1)
                        AND p_ext_mm != 1
                       )
                   )
               AND procedure_id = p_method
               AND iss_cd = expen.iss_cd
               AND line_cd = expen.line_cd
               AND intm_ri = expen.intm_ri;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_prev_def_comm_expense := 0;
         END;

         v_def_comm_expense_diff :=
                              expen.def_comm_expense - v_prev_def_comm_expense;

         UPDATE giac_deferred_comm_expense
            SET def_comm_expense = expen.def_comm_expense,
                prev_def_comm_expense = v_prev_def_comm_expense,
                def_comm_expense_diff = v_def_comm_expense_diff,
                numerator_factor = NULL,
                denominator_factor = NULL,
                user_id = USER,
                last_update = SYSDATE
          WHERE YEAR = p_ext_year
            AND mm = p_ext_mm
            AND procedure_id = p_method
            AND iss_cd = expen.iss_cd
            AND line_cd = expen.line_cd
            AND intm_ri = expen.intm_ri;
      END LOOP;
   END;

   COMMIT;
END deferred_compute365_dtl;
/


