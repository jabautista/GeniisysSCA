/* Formatted on 2/29/2016 5:15:35 PM (QP5 v5.227.12220.39754) */
CREATE OR REPLACE PROCEDURE CPI.deferred_compute3_dtl (p_ext_year    NUMBER,
                                                       p_ext_mm      NUMBER,
                                                       p_method      NUMBER)
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
   v_user_id                 VARCHAR2 (8)
                                := NVL (giis_users_pkg.app_user, USER);
   --added by Gzelle 06.13.2013, replaced all USER with v_user_id
   v_24th_comp               VARCHAR2 (1)
      := NVL (giacp.v ('24TH_METHOD_DEF_COMP'), 'Y');  --test mikel 02.04.2016
   v_line_cd_mn              VARCHAR2 (10) := giisp.v ('LINE_CODE_MN');
   --create an initial variable for the parameter LINE_CODE_MN
   v_mn_24th_comp            VARCHAR2 (1)
      := NVL (giacp.v ('MARINE_COMPUTATION_24TH'), 2);
--identifier which factor will be used if the line_cd is MN
BEGIN
   IF v_24th_comp = 'Y'
   THEN
      v_exists := 0;

      /* Check for previous extract */
      FOR chk
         IN (SELECT gen_tag
               FROM giac_deferred_extract
              WHERE     YEAR = p_ext_year
                    AND mm = p_ext_mm
                    AND procedure_id = p_method
                    AND comp_sw = 'Y')
      LOOP
         IF chk.gen_tag = 'Y'
         THEN
            raise_application_error (
               -20200,
               'PREVIOUS EXTRACT FOR THIS YEAR AND MM HAS ALREADY BEEN POSTED.');
         ELSE
            v_exists := 1;

            UPDATE giac_deferred_extract
               SET user_id = v_user_id, last_compute = SYSDATE
             WHERE     YEAR = p_ext_year
                   AND mm = p_ext_mm
                   AND procedure_id = p_method
                   AND comp_sw = 'Y';
         END IF;

         EXIT;
      END LOOP;

      IF v_exists = 0
      THEN
         raise_application_error (
            -20203,
            'YOU HAVE NOT YET EXTRACTED DATA FOR COMPUTATION.');
      END IF;

      /* Update Detail Tables */
--      BEGIN
--         /* Deferred Gross Premium */
--         UPDATE giac_deferred_gross_prem_pol
--            SET def_prem_amt =
--                     prem_amt
--                   * DECODE (
--                        line_cd,                                      /*'MN'*/
--                        v_line_cd_mn, DECODE (
--                                         v_mn_24th_comp,
--                                         '1',   denominator_factor
--                                              / denominator_factor,
--                                           numerator_factor
--                                         / denominator_factor),
--                        numerator_factor / denominator_factor),
--                numerator_factor =
--                   DECODE (
--                      line_cd,                                        /*'MN'*/
--                      v_line_cd_mn, DECODE (v_mn_24th_comp,
--                                            '1', denominator_factor,
--                                            numerator_factor),
--                      numerator_factor),
--                denominator_factor =
--                   DECODE (
--                      line_cd,                                        /*'MN'*/
--                      v_line_cd_mn, DECODE (v_mn_24th_comp,
--                                            '1', denominator_factor,
--                                            denominator_factor),
--                      denominator_factor),
--                user_id = v_user_id,
--                last_update = SYSDATE
--          WHERE     extract_year = p_ext_year
--                AND extract_mm = p_ext_mm
--                AND comp_sw = 'Y';
--
--         --FOR GROSS PREMIUM MN
--         UPDATE giac_deferred_gross_prem_pol
--            SET def_prem_amt = 0,
--                numerator_factor = 0,
--                denominator_factor =
--                   DECODE (
--                      line_cd,                                        /*'MN'*/
--                      v_line_cd_mn, DECODE (v_mn_24th_comp,
--                                            '1', denominator_factor,
--                                            denominator_factor),
--                      denominator_factor),
--                user_id = v_user_id,
--                last_update = SYSDATE
--          WHERE     extract_year = p_ext_year
--                AND extract_mm = p_ext_mm
--                AND line_cd = 'MN'
--                AND eff_date <
--                       ADD_MONTHS (
--                          TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'),
--                          -1)
--                AND comp_sw = 'Y';
--
--         /* Deferred RI Premium */
--         UPDATE giac_deferred_ri_prem_cede_pol
--            SET def_dist_prem =
--                     dist_prem
--                   * DECODE (
--                        line_cd,                                      /*'MN'*/
--                        v_line_cd_mn, DECODE (
--                                         v_mn_24th_comp,
--                                         '1',   denominator_factor
--                                              / denominator_factor,
--                                           numerator_factor
--                                         / denominator_factor),
--                        numerator_factor / denominator_factor),
--                numerator_factor =
--                   DECODE (
--                      line_cd,                                        /*'MN'*/
--                      v_line_cd_mn, DECODE (v_mn_24th_comp,
--                                            '1', denominator_factor,
--                                            numerator_factor),
--                      numerator_factor),
--                denominator_factor =
--                   DECODE (
--                      line_cd,                                        /*'MN'*/
--                      v_line_cd_mn, DECODE (v_mn_24th_comp,
--                                            '1', denominator_factor,
--                                            denominator_factor),
--                      denominator_factor),
--                user_id = v_user_id,
--                last_update = SYSDATE
--          WHERE     extract_year = p_ext_year
--                AND extract_mm = p_ext_mm
--                AND comp_sw = 'Y';
--
--         ---FOR MARINE
--         UPDATE giac_deferred_ri_prem_cede_pol
--            SET def_dist_prem = 0,
--                numerator_factor = 0,
--                denominator_factor =
--                   DECODE (
--                      line_cd,                                        /*'MN'*/
--                      v_line_cd_mn, DECODE (v_mn_24th_comp,
--                                            '1', denominator_factor,
--                                            denominator_factor),
--                      denominator_factor),
--                user_id = v_user_id,
--                last_update = SYSDATE
--          WHERE     extract_year = p_ext_year
--                AND extract_mm = p_ext_mm
--                AND line_cd = 'MN'
--                AND eff_date <
--                       ADD_MONTHS (
--                          TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'),
--                          -1)
--                AND comp_sw = 'Y';
--
--         /* Commission Income */
--         UPDATE giac_deferred_comm_income_pol
--            SET def_comm_income =
--                     comm_income
--                   * DECODE (
--                        line_cd,                                      /*'MN'*/
--                        v_line_cd_mn, DECODE (
--                                         v_mn_24th_comp,
--                                         '1',   denominator_factor
--                                              / denominator_factor,
--                                           numerator_factor
--                                         / denominator_factor),
--                        numerator_factor / denominator_factor),
--                numerator_factor =
--                   DECODE (
--                      line_cd,                                        /*'MN'*/
--                      v_line_cd_mn, DECODE (v_mn_24th_comp,
--                                            '1', denominator_factor,
--                                            numerator_factor),
--                      numerator_factor),
--                denominator_factor =
--                   DECODE (
--                      line_cd,                                        /*'MN'*/
--                      v_line_cd_mn, DECODE (v_mn_24th_comp,
--                                            '1', denominator_factor,
--                                            denominator_factor),
--                      denominator_factor),
--                user_id = v_user_id,
--                last_update = SYSDATE
--          WHERE     extract_year = p_ext_year
--                AND extract_mm = p_ext_mm
--                AND comp_sw = 'Y';
--
--         --FOR MARINE
--         UPDATE giac_deferred_comm_income_pol
--            SET def_comm_income = 0,
--                numerator_factor = 0,
--                denominator_factor =
--                   DECODE (
--                      line_cd,                                        /*'MN'*/
--                      v_line_cd_mn, DECODE (v_mn_24th_comp,
--                                            '1', denominator_factor,
--                                            denominator_factor),
--                      denominator_factor),
--                user_id = v_user_id,
--                last_update = SYSDATE
--          WHERE     extract_year = p_ext_year
--                AND extract_mm = p_ext_mm
--                AND line_cd = 'MN'
--                AND eff_date <
--                       ADD_MONTHS (
--                          TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'),
--                          -1)
--                AND comp_sw = 'Y';                                --FOR MARINE
--
--         /* Commission Expense */
--         UPDATE giac_deferred_comm_expense_pol
--            SET def_comm_expense =
--                     comm_expense
--                   * DECODE (
--                        line_cd,                                      /*'MN'*/
--                        v_line_cd_mn, DECODE (
--                                         v_mn_24th_comp,
--                                         '1',   denominator_factor
--                                              / denominator_factor,
--                                           numerator_factor
--                                         / denominator_factor),
--                        numerator_factor / denominator_factor),
--                numerator_factor =
--                   DECODE (
--                      line_cd,                                        /*'MN'*/
--                      v_line_cd_mn, DECODE (v_mn_24th_comp,
--                                            '1', denominator_factor,
--                                            numerator_factor),
--                      numerator_factor),
--                denominator_factor =
--                   DECODE (
--                      line_cd,                                        /*'MN'*/
--                      v_line_cd_mn, DECODE (v_mn_24th_comp,
--                                            '1', denominator_factor,
--                                            denominator_factor),
--                      denominator_factor),
--                user_id = v_user_id,
--                last_update = SYSDATE
--          WHERE     extract_year = p_ext_year
--                AND extract_mm = p_ext_mm
--                AND comp_sw = 'Y';
--
--         UPDATE giac_deferred_comm_expense_pol
--            SET def_comm_expense = 0,
--                numerator_factor = 0,
--                denominator_factor =
--                   DECODE (
--                      line_cd,                                        /*'MN'*/
--                      v_line_cd_mn, DECODE (v_mn_24th_comp,
--                                            '1', denominator_factor,
--                                            denominator_factor),
--                      denominator_factor),
--                user_id = v_user_id,
--                last_update = SYSDATE
--          WHERE     extract_year = p_ext_year
--                AND extract_mm = p_ext_mm
--                AND line_cd = 'MN'
--                AND eff_date <
--                       ADD_MONTHS (
--                          TO_DATE (p_ext_mm || '-' || p_ext_year, 'MM-YYYY'),
--                          -1)
--                AND comp_sw = 'Y';
--      END; -- mikel 02.29.2016; comment out and replaced by codes below
      --start mikel
     /* Update detail tables */
      BEGIN
         UPDATE giac_deferred_gross_prem_pol
            SET def_prem_amt =
                   prem_amt * numerator_factor / denominator_factor,
                user_id = v_user_id,
                last_update = SYSDATE
          WHERE     extract_year = p_ext_year
                AND extract_mm = p_ext_mm
                AND comp_sw = 'Y';

         UPDATE giac_deferred_ri_prem_cede_pol
            SET def_dist_prem =
                   dist_prem * numerator_factor / denominator_factor,
                user_id = v_user_id,
                last_update = SYSDATE
          WHERE     extract_year = p_ext_year
                AND extract_mm = p_ext_mm
                AND comp_sw = 'Y';

         UPDATE giac_deferred_comm_income_pol
            SET def_comm_income =
                   comm_income * numerator_factor / denominator_factor,
                user_id = v_user_id,
                last_update = SYSDATE
          WHERE     extract_year = p_ext_year
                AND extract_mm = p_ext_mm
                AND comp_sw = 'Y';

         UPDATE giac_deferred_comm_expense_pol
            SET def_comm_expense =
                   comm_expense * numerator_factor / denominator_factor,
                user_id = v_user_id,
                last_update = SYSDATE
          WHERE     extract_year = p_ext_year
                AND extract_mm = p_ext_mm
                AND comp_sw = 'Y';
      END;
      --end mikel

      /* Update Main Tables */
      BEGIN
         FOR gross
            IN (  SELECT iss_cd,
                         line_cd,
                         SUM (NVL (def_prem_amt, 0)) def_prem_amt
                    FROM giac_deferred_gross_prem_pol
                   WHERE     extract_year = p_ext_year
                         AND extract_mm = p_ext_mm
                         AND procedure_id = p_method
                         AND comp_sw = 'Y'
                GROUP BY iss_cd, line_cd)
         LOOP
            BEGIN
               SELECT NVL (def_prem_amt, 0)
                 INTO v_prev_def_prem_amt
                 FROM giac_deferred_gross_prem
                WHERE     (   (    YEAR = (p_ext_year - 1)
                               AND mm = 12
                               AND p_ext_mm = 1)
                           OR (    YEAR = p_ext_year
                               AND mm = (p_ext_mm - 1)
                               AND p_ext_mm != 1))
                      AND procedure_id = p_method
                      AND iss_cd = gross.iss_cd
                      AND line_cd = gross.line_cd
                      AND comp_sw = 'Y';
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
                   user_id = v_user_id,
                   last_update = SYSDATE
             WHERE     YEAR = p_ext_year
                   AND mm = p_ext_mm
                   AND procedure_id = p_method
                   AND iss_cd = gross.iss_cd
                   AND line_cd = gross.line_cd
                   AND comp_sw = 'Y';
         END LOOP;

         FOR ri_prem
            IN (  SELECT iss_cd,
                         line_cd,
                         share_type,
                         acct_trty_type,
                         SUM (NVL (def_dist_prem, 0)) def_dist_prem
                    FROM giac_deferred_ri_prem_cede_pol
                   WHERE     extract_year = p_ext_year
                         AND extract_mm = p_ext_mm
                         AND procedure_id = p_method
                         AND comp_sw = 'Y'
                GROUP BY iss_cd,
                         line_cd,
                         share_type,
                         acct_trty_type)
         LOOP
            BEGIN
               SELECT NVL (def_dist_prem, 0)
                 INTO v_prev_def_dist_prem
                 FROM giac_deferred_ri_prem_ceded
                WHERE     (   (    YEAR = (p_ext_year - 1)
                               AND mm = 12
                               AND p_ext_mm = 1)
                           OR (    YEAR = p_ext_year
                               AND mm = (p_ext_mm - 1)
                               AND p_ext_mm != 1
                               AND comp_sw = 'Y'))
                      AND iss_cd = ri_prem.iss_cd
                      AND line_cd = ri_prem.line_cd
                      AND procedure_id = p_method
                      AND share_type = ri_prem.share_type
                      AND comp_sw = 'Y' --mikel 03.10.2016
                      AND acct_trty_type = ri_prem.acct_trty_type;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_prev_def_dist_prem := 0;
            END;

            v_def_dist_prem_diff :=
               ri_prem.def_dist_prem - v_prev_def_dist_prem;

            UPDATE giac_deferred_ri_prem_ceded
               SET def_dist_prem = ri_prem.def_dist_prem,
                   prev_def_dist_prem = v_prev_def_dist_prem,
                   def_dist_prem_diff = v_def_dist_prem_diff,
                   numerator_factor = NULL,
                   denominator_factor = NULL,
                   user_id = v_user_id,
                   last_update = SYSDATE
             WHERE     YEAR = p_ext_year
                   AND mm = p_ext_mm
                   AND iss_cd = ri_prem.iss_cd
                   AND line_cd = ri_prem.line_cd
                   AND procedure_id = p_method
                   AND share_type = ri_prem.share_type
                   AND acct_trty_type = ri_prem.acct_trty_type
                   AND comp_sw = 'Y';
         END LOOP;

         FOR comm
            IN (  SELECT iss_cd,
                         line_cd,
                         share_type,
                         acct_trty_type,
                         ri_cd,
                         SUM (NVL (def_comm_income, 0)) def_comm_income
                    FROM giac_deferred_comm_income_pol
                   WHERE     extract_year = p_ext_year
                         AND extract_mm = p_ext_mm
                         AND procedure_id = p_method
                         AND comp_sw = 'Y'
                GROUP BY iss_cd,
                         line_cd,
                         share_type,
                         acct_trty_type,
                         ri_cd)
         LOOP
            BEGIN
               SELECT NVL (def_comm_income, 0)
                 INTO v_prev_def_comm_income
                 FROM giac_deferred_comm_income
                WHERE     (   (    YEAR = (p_ext_year - 1)
                               AND mm = 12
                               AND p_ext_mm = 1)
                           OR (    YEAR = p_ext_year
                               AND mm = (p_ext_mm - 1)
                               AND p_ext_mm != 1))
                      AND iss_cd = comm.iss_cd
                      AND line_cd = comm.line_cd
                      AND procedure_id = p_method
                      AND share_type = comm.share_type
                      AND acct_trty_type = comm.acct_trty_type
                      AND ri_cd = comm.ri_cd
                      AND comp_sw = 'Y';
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
                   user_id = v_user_id,
                   last_update = SYSDATE
             WHERE     YEAR = p_ext_year
                   AND mm = p_ext_mm
                   AND iss_cd = comm.iss_cd
                   AND line_cd = comm.line_cd
                   AND procedure_id = p_method
                   AND share_type = comm.share_type
                   AND acct_trty_type = comm.acct_trty_type
                   AND ri_cd = comm.ri_cd
                   AND comp_sw = 'Y';
         END LOOP;

         FOR expen
            IN (  SELECT iss_cd,
                         line_cd,
                         intm_ri,
                         SUM (NVL (def_comm_expense, 0)) def_comm_expense
                    FROM giac_deferred_comm_expense_pol
                   WHERE     extract_year = p_ext_year
                         AND extract_mm = p_ext_mm
                         AND procedure_id = p_method
                         AND comp_sw = 'Y'
                GROUP BY iss_cd, line_cd, intm_ri)
         LOOP
            BEGIN
               SELECT NVL (def_comm_expense, 0)
                 INTO v_prev_def_comm_expense
                 FROM giac_deferred_comm_expense
                WHERE     (   (    YEAR = (p_ext_year - 1)
                               AND mm = 12
                               AND p_ext_mm = 1)
                           OR (    YEAR = p_ext_year
                               AND mm = (p_ext_mm - 1)
                               AND p_ext_mm != 1))
                      AND procedure_id = p_method
                      AND iss_cd = expen.iss_cd
                      AND line_cd = expen.line_cd
                      AND intm_ri = expen.intm_ri
                      AND comp_sw = 'Y';
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
                   user_id = v_user_id,
                   last_update = SYSDATE
             WHERE     YEAR = p_ext_year
                   AND mm = p_ext_mm
                   AND procedure_id = p_method
                   AND iss_cd = expen.iss_cd
                   AND line_cd = expen.line_cd
                   AND intm_ri = expen.intm_ri
                   AND comp_sw = 'Y';
         END LOOP;
      END;
   ---------------------------------------------------------------------------------------------------------------------------------------------
   END IF;

   COMMIT;
END deferred_compute3_dtl;
/