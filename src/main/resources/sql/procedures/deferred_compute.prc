DROP PROCEDURE CPI.DEFERRED_COMPUTE;

CREATE OR REPLACE PROCEDURE CPI.Deferred_Compute(p_year NUMBER, p_mm NUMBER, p_method NUMBER) IS
   v_exists                NUMBER;
   v_numerator_factor      GIAC_DEFERRED_FACTORS.numerator_factor%TYPE;
   v_denominator_factor    GIAC_DEFERRED_FACTORS.denominator_factor%TYPE;
   v_user_id         VARCHAR2(8) := NVL(giis_users_pkg.app_user, USER);     --added by Gzelle 05.31.2013, replaced all USER with v_user_id
/*
** List of Application Errors:
**    -20200,'Previous extract for this Year and MM has already been posted.';
**    -20201,'Factors for the method are not found.';
**    -20202,'Error retrieving factors in giac_deferred_factors.';
**    -20203,'You have not yet extracted data for computation.';
*/

/*Modified by:  Vincent
 Date Modified: 013105
 Modification:  added acct_trty_type for RI premium and comm income*/

BEGIN
   v_exists := 0;
   /* Check for previous extract */
   FOR chk IN (SELECT gen_tag
                 FROM GIAC_DEFERRED_EXTRACT
                WHERE YEAR = p_year
                  AND mm   = p_mm
                  AND procedure_id = p_method)
   LOOP
      IF chk.gen_tag = 'Y' THEN
         RAISE_APPLICATION_ERROR(-20200,'Previous extract for this Year and MM has already been posted.');
      ELSE
         v_exists := 1;
         UPDATE GIAC_DEFERRED_EXTRACT
            SET user_id      = v_user_id,
                last_compute = SYSDATE
          WHERE YEAR = p_year
            AND mm   = p_mm
            AND procedure_id = p_method;
      END IF;
      EXIT;
   END LOOP;
   IF v_exists = 0 THEN
      RAISE_APPLICATION_ERROR(-20203,'You have not yet extracted data for computation.');
   END IF;
   /* Get the factors for the method */
   BEGIN
      SELECT numerator_factor,
             denominator_factor
        INTO v_numerator_factor,
             v_denominator_factor
        FROM GIAC_DEFERRED_FACTORS
       WHERE procedure_id = p_method
         AND MONTH        = p_mm;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20201,'Factors for the method are not found.');
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20202,'Error retrieving factors in giac_deferred_factors.');
   END;
   /* Compute for the Deferred Gross Premium */
   FOR gross IN (SELECT gdgp.iss_cd,
                        gdgp.line_cd,
                        gb.prnt_branch_cd,
                        NVL(gdgp.prem_amt,0) prem_amt,
                        NVL(gdgp.def_prem_amt,0) def_prem_amt,
                        NVL(gdgp.prev_def_prem_amt,0) prev_def_prem_amt,
                        NVL(gdgp.def_prem_amt_diff,0) def_prem_amt_diff
                   FROM GIAC_DEFERRED_GROSS_PREM gdgp,
                        GIAC_BRANCHES gb
                  WHERE gdgp.YEAR         = p_year
                    AND gdgp.mm           = p_mm
                    AND gdgp.procedure_id = p_method
                    AND gdgp.iss_cd       = gb.branch_cd
   )
   LOOP
      gross.def_prem_amt := gross.prem_amt * v_numerator_factor / v_denominator_factor;
      BEGIN
         SELECT NVL(def_prem_amt,0)
           INTO gross.prev_def_prem_amt
           FROM GIAC_DEFERRED_GROSS_PREM
          WHERE YEAR         = (p_year - 1)
            AND mm           = p_mm
            AND procedure_id = p_method
            AND iss_cd       = gross.iss_cd
            AND line_cd      = gross.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               gross.prev_def_prem_amt := 0;
      END;
      gross.def_prem_amt_diff := gross.def_prem_amt - gross.prev_def_prem_amt;
      UPDATE GIAC_DEFERRED_GROSS_PREM
         SET prnt_branch_cd     = gross.prnt_branch_cd,
             numerator_factor   = v_numerator_factor,
             denominator_factor = v_denominator_factor,
             def_prem_amt       = gross.def_prem_amt,
             prev_def_prem_amt  = gross.prev_def_prem_amt,
             def_prem_amt_diff  = gross.def_prem_amt_diff,
             user_id            = v_user_id,
             last_update        = SYSDATE
       WHERE YEAR = p_year
         AND mm   = p_mm
         AND procedure_id = p_method
         AND iss_cd = gross.iss_cd
         AND line_cd = gross.line_cd;
   END LOOP;
   /* RI PREMIUMS CEDED */
   FOR ri_prem IN (SELECT iss_cd,
                          line_cd,
                          NVL(dist_prem,0) dist_prem,
                          NVL(def_dist_prem,0) def_dist_prem,
                          NVL(prev_def_dist_prem,0) prev_def_dist_prem,
                          NVL(def_dist_prem_diff,0) def_dist_prem_diff,
                          share_type,
             acct_trty_type --added by Vincent 013105
                     FROM GIAC_DEFERRED_RI_PREM_CEDED
                   WHERE YEAR = p_year
                     AND mm   = p_mm
                     AND procedure_id = p_method)
   LOOP
      ri_prem.def_dist_prem := ri_prem.dist_prem * v_numerator_factor / v_denominator_factor;
      BEGIN
         SELECT NVL(def_dist_prem,0)
           INTO ri_prem.prev_def_dist_prem
           FROM GIAC_DEFERRED_RI_PREM_CEDED
          WHERE YEAR    = (p_year - 1)
            AND mm      = p_mm
            AND iss_cd  = ri_prem.iss_cd
            AND line_cd = ri_prem.line_cd
            AND procedure_id = p_method
            AND share_type = ri_prem.share_type
      AND acct_trty_type = ri_prem.acct_trty_type;--added by Vincent 013105
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               ri_prem.prev_def_dist_prem := 0;
      END;
      ri_prem.def_dist_prem_diff := ri_prem.def_dist_prem - ri_prem.prev_def_dist_prem;
      UPDATE GIAC_DEFERRED_RI_PREM_CEDED
         SET numerator_factor    = v_numerator_factor,
             denominator_factor  = v_denominator_factor,
             def_dist_prem       = ri_prem.def_dist_prem,
             prev_def_dist_prem  = ri_prem.prev_def_dist_prem,
             def_dist_prem_diff  = ri_prem.def_dist_prem_diff,
             user_id             = v_user_id,
             last_update         = SYSDATE
       WHERE YEAR = p_year
         AND mm   = p_mm
         AND iss_cd = ri_prem.iss_cd
         AND line_cd = ri_prem.line_cd
         AND procedure_id = p_method
         AND share_type = ri_prem.share_type
     AND acct_trty_type = ri_prem.acct_trty_type;--added by Vincent 013105
   END LOOP;
   FOR comm IN (SELECT iss_cd,
                       line_cd,
                       NVL(comm_income,0) comm_income,
                       NVL(def_comm_income,0) def_comm_income,
                       NVL(prev_def_comm_income,0) prev_def_comm_income,
                       NVL(def_comm_income_diff,0) def_comm_income_diff,
                       share_type,
            acct_trty_type--added by Vincent 013105
                  FROM GIAC_DEFERRED_COMM_INCOME
                 WHERE YEAR = p_year
                   AND mm   = p_mm
                   AND procedure_id = p_method)
   LOOP
      comm.def_comm_income := comm.comm_income * v_numerator_factor / v_denominator_factor;
      BEGIN
         SELECT NVL(def_comm_income,0)
           INTO comm.prev_def_comm_income
           FROM GIAC_DEFERRED_COMM_INCOME
          WHERE YEAR    = (p_year - 1)
            AND mm      = p_mm
            AND iss_cd  = comm.iss_cd
            AND line_cd = comm.line_cd
            AND procedure_id = p_method
            AND share_type = comm.share_type
      AND acct_trty_type = comm.acct_trty_type;--added by Vincent 013105
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               comm.prev_def_comm_income := 0;
      END;
      comm.def_comm_income_diff := comm.def_comm_income - comm.prev_def_comm_income;
      UPDATE GIAC_DEFERRED_COMM_INCOME
         SET numerator_factor     = v_numerator_factor,
             denominator_factor   = v_denominator_factor,
             def_comm_income      = comm.def_comm_income,
             prev_def_comm_income = comm.prev_def_comm_income,
             def_comm_income_diff = comm.def_comm_income_diff,
             user_id              = v_user_id,
             last_update          = SYSDATE
       WHERE YEAR = p_year
         AND mm   = p_mm
         AND iss_cd = comm.iss_cd
         AND line_cd = comm.line_cd
         AND procedure_id = p_method
         AND share_type = comm.share_type
     AND acct_trty_type = comm.acct_trty_type;--added by Vincent 013105
   END LOOP;
   FOR expen IN (SELECT iss_cd,
                       line_cd,
                       NVL(comm_expense,0) comm_expense,
                       NVL(def_comm_expense,0) def_comm_expense,
                       NVL(prev_def_comm_expense,0) prev_def_comm_expense,
                       NVL(def_comm_expense_diff,0) def_comm_expense_diff
                  FROM GIAC_DEFERRED_COMM_EXPENSE
                 WHERE YEAR = p_year
                   AND mm   = p_mm
                   AND procedure_id = p_method)
   LOOP
      expen.def_comm_expense := expen.comm_expense * v_numerator_factor / v_denominator_factor;
      BEGIN
         SELECT NVL(def_comm_expense,0)
           INTO expen.prev_def_comm_expense
           FROM GIAC_DEFERRED_COMM_EXPENSE
          WHERE YEAR    = (p_year - 1)
            AND mm      = p_mm
            AND iss_cd  = expen.iss_cd
            AND line_cd = expen.line_cd
            AND procedure_id = p_method;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               expen.prev_def_comm_expense := 0;
      END;
      expen.def_comm_expense_diff := expen.def_comm_expense - expen.prev_def_comm_expense;
      UPDATE GIAC_DEFERRED_COMM_EXPENSE
         SET numerator_factor      = v_numerator_factor,
             denominator_factor    = v_denominator_factor,
             def_comm_expense      = expen.def_comm_expense,
             prev_def_comm_expense = expen.prev_def_comm_expense,
             def_comm_expense_diff  = expen.def_comm_expense_diff,
             user_id               = v_user_id,
             last_update          = SYSDATE
       WHERE YEAR = p_year
         AND mm   = p_mm
         AND iss_cd = expen.iss_cd
         AND line_cd = expen.line_cd
         AND procedure_id = p_method;
   END LOOP;
   COMMIT;
END Deferred_Compute;
/


