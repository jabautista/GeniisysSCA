DROP PROCEDURE CPI.DEFERRED_COMPUTE2;

CREATE OR REPLACE PROCEDURE CPI.Deferred_Compute2(p_year NUMBER, p_mm NUMBER, p_method NUMBER) IS
  v_exists                  NUMBER;
  v_month                   NUMBER;
  v_count                   NUMBER;
  v_numerator_factor        GIAC_DEFERRED_FACTORS.numerator_factor%TYPE;
  v_denominator_factor      GIAC_DEFERRED_FACTORS.denominator_factor%TYPE;
  v_numerator_factor_mn     GIAC_DEFERRED_FACTORS.numerator_factor%TYPE;--factor for 'MN'
  v_denominator_factor_mn   GIAC_DEFERRED_FACTORS.denominator_factor%TYPE;--factor for 'MN'
  v_prev_def_prem_amt       GIAC_DEFERRED_GROSS_PREM.prev_def_prem_amt%TYPE;
  v_def_prem_amt_diff       GIAC_DEFERRED_GROSS_PREM.def_prem_amt_diff%TYPE;
  v_prev_def_dist_prem      GIAC_DEFERRED_RI_PREM_CEDED.prev_def_dist_prem%TYPE;
  v_def_dist_prem_diff      GIAC_DEFERRED_RI_PREM_CEDED.def_dist_prem_diff%TYPE;
  v_prev_def_comm_income    GIAC_DEFERRED_COMM_INCOME.prev_def_comm_income%TYPE;
  v_def_comm_income_diff    GIAC_DEFERRED_COMM_INCOME.def_comm_income_diff%TYPE;
  v_prev_def_comm_expense   GIAC_DEFERRED_COMM_EXPENSE.prev_def_comm_expense%TYPE;
  v_def_comm_expense_diff   GIAC_DEFERRED_COMM_EXPENSE.def_comm_expense_diff%TYPE;
  v_numrtr_factordf_y       GIAC_DEFERRED_FACTORS.numerator_factor%TYPE;  --for factors with def_tag is Y
  v_numrtr_factormndf_y     GIAC_DEFERRED_FACTORS.numerator_factor%TYPE;  --
  v_dnmtr_factordf_y        GIAC_DEFERRED_FACTORS.denominator_factor%TYPE;--
  v_dnmtr_factormn_df_y     GIAC_DEFERRED_FACTORS.denominator_factor%TYPE;--
  v_user_id         VARCHAR2(8) := NVL(giis_users_pkg.app_user, USER);     --added by Gzelle 05.31.2013, replaced all USER with v_user_id
/*
** List of Application Errors:
**    -20200,'Previous extract for this Year and MM has already been posted.';
**    -20201,'Factors for the method are not found.';
**    -20202,'Error retrieving factors in giac_deferred_factors.';
**    -20203,'You have not yet extracted data for computation.';
*/

/* Created by:   Vincent
** Date Created: 062405
** Description:  Computes data based on specs for the monthly computation of 24th Method
*/

/* Modified by:    Alfie
** Date Modified:  06082010
** Description:    Handles the additional factors for monthly computation of 24th Method, additional factors spans up to 13 months
*/
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
      RAISE_APPLICATION_ERROR(-20200,'PREVIOUS EXTRACT FOR THIS YEAR AND MM HAS ALREADY BEEN POSTED.');
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
    RAISE_APPLICATION_ERROR(-20203,'YOU HAVE NOT YET EXTRACTED DATA FOR COMPUTATION.');
  END IF;

  --compute records for the previous months which fall on the previous year
  v_month := p_mm; --from p_mm + 1 :alfie
  v_count := 13; --from 12 :alfie
  FOR rec IN 1..ABS(p_mm - 13) --from 12 :alfie
  LOOP
    /* Get the factors for the method */
    BEGIN

      IF v_count <= 12 THEN  --gross prem and ri ceded's computation spans up to 12 months only.. : alfie
        --factors for Marine Cargo
        SELECT numerator_factor,
               denominator_factor
          INTO v_numerator_factor_mn,
               v_denominator_factor_mn
          FROM GIAC_DEFERRED_FACTORS
         WHERE procedure_id = p_method
           AND MONTH        = v_count
           AND line_cd = 'MN'
           AND def_tag IS NULL;
      --factors for other lines
        SELECT numerator_factor,
               denominator_factor
          INTO v_numerator_factor,
               v_denominator_factor
          FROM GIAC_DEFERRED_FACTORS
         WHERE procedure_id = p_method
           AND MONTH        = v_count
           AND line_cd IS NULL
           AND def_tag IS NULL;
       END IF;
     --factors with def_tag is Y, for Marine Cargo : alfie
     SELECT numerator_factor,
             denominator_factor
        INTO v_numrtr_factormndf_y,
             v_dnmtr_factormn_df_y
        FROM GIAC_DEFERRED_FACTORS
       WHERE procedure_id = p_method
         AND MONTH        = v_count
         AND line_cd = 'MN'
         AND def_tag = 'Y';
      --factors with def_tag is Y, factors for other lines : alfie
     SELECT numerator_factor,
             denominator_factor
        INTO v_numrtr_factordf_y,
             v_dnmtr_factordf_y
        FROM GIAC_DEFERRED_FACTORS
       WHERE procedure_id = p_method
         AND MONTH        = v_count
         AND line_cd IS NULL
         AND def_tag = 'Y';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20201,'FACTORS FOR THE METHOD ARE NOT FOUND.');
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20202,'ERROR RETRIEVING FACTORS IN GIAC_DEFERRED_FACTORS.');
    END;
    Deferred_Compute2_Dtl(p_year,
                          p_mm,
                          (p_year-1),
                          v_month,
                          p_method,
                          v_numerator_factor,
                          v_denominator_factor,
                          v_numerator_factor_mn,
                          v_denominator_factor_mn,
                          v_numrtr_factordf_y,--added by alfie
                          v_numrtr_factormndf_y, --
                          v_dnmtr_factordf_y,    --
                          v_dnmtr_factormn_df_y  --
                          );
    v_count := v_count - 1;
    v_month := v_month + 1;
  END LOOP;

  --compute records for the months which fall on the current extract year
  v_month := 1;
  FOR rec IN 1..p_mm
  LOOP
    /* Get the factors for the method */
    BEGIN
      --factors for Marine Cargo
      SELECT numerator_factor,
             denominator_factor
        INTO v_numerator_factor_mn,
             v_denominator_factor_mn
        FROM GIAC_DEFERRED_FACTORS
       WHERE procedure_id = p_method
         AND MONTH        = v_count
         AND line_cd = 'MN'
         AND def_tag IS NULL;
      --factors for other lines
      SELECT numerator_factor,
             denominator_factor
        INTO v_numerator_factor,
             v_denominator_factor
        FROM GIAC_DEFERRED_FACTORS
       WHERE procedure_id = p_method
         AND MONTH        = v_count
         AND line_cd IS NULL
         AND def_tag IS NULL;
      --factors with def_tag is Y, for Marine Cargo: alfie
      SELECT numerator_factor,
             denominator_factor
        INTO v_numrtr_factormndf_y,
             v_dnmtr_factormn_df_y
        FROM GIAC_DEFERRED_FACTORS
       WHERE procedure_id = p_method
         AND MONTH        = v_count
         AND line_cd = 'MN'
         AND def_tag = 'Y';
      --factors with def_tag is Y, factors for other lines : alfie
      SELECT numerator_factor,
             denominator_factor
        INTO v_numrtr_factordf_y,
             v_dnmtr_factordf_y
        FROM GIAC_DEFERRED_FACTORS
       WHERE procedure_id = p_method
         AND MONTH        = v_count
         AND line_cd IS NULL
         AND def_tag = 'Y';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20201,'FACTORS FOR THE METHOD ARE NOT FOUND.');
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20202,'ERROR RETRIEVING FACTORS IN GIAC_DEFERRED_FACTORS.');
    END;

    Deferred_Compute2_Dtl(p_year,
                          p_mm,
                          p_year,
                          v_month,
                          p_method,
                          v_numerator_factor,
                          v_denominator_factor,
                          v_numerator_factor_mn,
                          v_denominator_factor_mn,
                          v_numrtr_factordf_y,    --added by alfie
                          v_numrtr_factormndf_y,
                          v_dnmtr_factordf_y,
                          v_dnmtr_factormn_df_y);
    v_count := v_count - 1;
    v_month := v_month + 1;
  END LOOP;

--added by alfie: 06/30/2011: to compute deferral amount for advance booking policies
  SELECT numerator_factor,
         denominator_factor
    INTO v_numerator_factor_mn,
         v_denominator_factor_mn
    FROM GIAC_DEFERRED_FACTORS
   WHERE procedure_id = p_method
     AND MONTH        = 0
     AND line_cd = 'MN'
     AND def_tag IS NULL;
      
  --factors for other lines
  SELECT numerator_factor,
         denominator_factor
    INTO v_numerator_factor,
         v_denominator_factor
   FROM GIAC_DEFERRED_FACTORS
  WHERE procedure_id = p_method
    AND MONTH        = 0
    AND line_cd IS NULL
    AND def_tag IS NULL;
    
   SELECT numerator_factor,
             denominator_factor
        INTO v_numrtr_factormndf_y,
             v_dnmtr_factormn_df_y
        FROM GIAC_DEFERRED_FACTORS
       WHERE procedure_id = p_method
         AND MONTH        = 0
         AND line_cd = 'MN'
         AND def_tag = 'Y';
      --factors with def_tag is Y, factors for other lines : alfie
      SELECT numerator_factor,
             denominator_factor
        INTO v_numrtr_factordf_y,
             v_dnmtr_factordf_y
        FROM GIAC_DEFERRED_FACTORS
       WHERE procedure_id = p_method
         AND MONTH        = 0
         AND line_cd IS NULL
         AND def_tag = 'Y';

  Deferred_Compute2_Dtl(p_year,
                        p_mm,
                        p_year,
                        99,
                        p_method,
                        v_numerator_factor,
                        v_denominator_factor,
                        v_numerator_factor_mn,
                        v_denominator_factor_mn,
                        v_numrtr_factordf_y,    --added by alfie
                        v_numrtr_factormndf_y,
                        v_dnmtr_factordf_y,
                        v_dnmtr_factormn_df_y);
                        
  --until here: alfie

  /* update main tables using data computed in detail tables*/
  FOR gross IN (SELECT iss_cd,
                       line_cd,
                       SUM(NVL(def_prem_amt,0)) def_prem_amt
                  FROM GIAC_DEFERRED_GROSS_PREM_DTL
                 WHERE extract_year = p_year
                   AND extract_mm   = p_mm
                   AND procedure_id = p_method
                 GROUP BY iss_cd, line_cd)
  LOOP
    BEGIN
      SELECT NVL(def_prem_amt,0)
        INTO v_prev_def_prem_amt
        FROM GIAC_DEFERRED_GROSS_PREM
       WHERE ((YEAR = (p_year - 1) AND mm = 12 AND p_mm = 1)
              OR (YEAR = p_year AND mm = (p_mm-1) AND p_mm != 1))
         AND procedure_id = p_method
         AND iss_cd       = gross.iss_cd
         AND line_cd      = gross.line_cd;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_prev_def_prem_amt := 0;
    END;

    v_def_prem_amt_diff := gross.def_prem_amt - v_prev_def_prem_amt;

    UPDATE GIAC_DEFERRED_GROSS_PREM
       SET def_prem_amt       = gross.def_prem_amt,
           prev_def_prem_amt  = v_prev_def_prem_amt,
           def_prem_amt_diff  = v_def_prem_amt_diff,
           numerator_factor   = NULL,
           denominator_factor = NULL,
           user_id            = v_user_id,
           last_update        = SYSDATE
     WHERE YEAR = p_year
       AND mm   = p_mm
       AND procedure_id = p_method
       AND iss_cd = gross.iss_cd
       AND line_cd = gross.line_cd;
  END LOOP;

  FOR ri_prem IN (SELECT iss_cd,
                         line_cd,
                         share_type,
                         acct_trty_type,
                         SUM(NVL(def_dist_prem,0)) def_dist_prem
                    FROM GIAC_DEFERRED_RI_PREM_CEDE_DTL
                   WHERE extract_year = p_year
                     AND extract_mm   = p_mm
                     AND procedure_id = p_method
                   GROUP BY iss_cd, line_cd, share_type, acct_trty_type)
  LOOP
    BEGIN
      SELECT NVL(def_dist_prem,0)
        INTO v_prev_def_dist_prem
        FROM GIAC_DEFERRED_RI_PREM_CEDED
       WHERE ((YEAR = (p_year - 1) AND mm = 12 AND p_mm = 1)
              OR (YEAR = p_year AND mm = (p_mm-1) AND p_mm != 1))
         AND iss_cd  = ri_prem.iss_cd
         AND line_cd = ri_prem.line_cd
         AND procedure_id = p_method
         AND share_type = ri_prem.share_type
         AND acct_trty_type = ri_prem.acct_trty_type;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_prev_def_dist_prem := 0;
    END;

    v_def_dist_prem_diff := ri_prem.def_dist_prem - v_prev_def_dist_prem;

    UPDATE GIAC_DEFERRED_RI_PREM_CEDED
       SET def_dist_prem       = ri_prem.def_dist_prem,
           prev_def_dist_prem  = v_prev_def_dist_prem,
           def_dist_prem_diff  = v_def_dist_prem_diff,
           numerator_factor    = NULL,
           denominator_factor  = NULL,
           user_id             = v_user_id,
           last_update         = SYSDATE
     WHERE YEAR = p_year
       AND mm   = p_mm
       AND iss_cd = ri_prem.iss_cd
       AND line_cd = ri_prem.line_cd
       AND procedure_id = p_method
       AND share_type = ri_prem.share_type
       AND acct_trty_type = ri_prem.acct_trty_type;
  END LOOP;

  FOR comm IN (SELECT iss_cd,
                      line_cd,
                      share_type,
                      acct_trty_type,
       ri_cd,
                      SUM(NVL(def_comm_income,0)) def_comm_income
                 FROM GIAC_DEFERRED_COMM_INCOME_DTL
                WHERE extract_year = p_year
                  AND extract_mm   = p_mm
                  AND procedure_id = p_method
                GROUP BY iss_cd, line_cd, share_type, acct_trty_type, ri_cd)
  LOOP
    BEGIN
      SELECT NVL(def_comm_income,0)
        INTO v_prev_def_comm_income
        FROM GIAC_DEFERRED_COMM_INCOME
       WHERE ((YEAR = (p_year - 1) AND mm = 12 AND p_mm = 1)
              OR (YEAR = p_year AND mm = (p_mm-1) AND p_mm != 1))
         AND iss_cd  = comm.iss_cd
         AND line_cd = comm.line_cd
         AND procedure_id = p_method
         AND share_type = comm.share_type
         AND acct_trty_type = comm.acct_trty_type
   AND ri_cd = comm.ri_cd;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_prev_def_comm_income := 0;
    END;

    v_def_comm_income_diff := comm.def_comm_income - v_prev_def_comm_income;

    UPDATE GIAC_DEFERRED_COMM_INCOME
       SET def_comm_income      = comm.def_comm_income,
           prev_def_comm_income = v_prev_def_comm_income,
           def_comm_income_diff = v_def_comm_income_diff,
           numerator_factor     = NULL,
           denominator_factor   = NULL,
           user_id              = v_user_id,
           last_update          = SYSDATE
     WHERE YEAR = p_year
       AND mm   = p_mm
       AND iss_cd = comm.iss_cd
       AND line_cd = comm.line_cd
       AND procedure_id = p_method
       AND share_type = comm.share_type
       AND acct_trty_type = comm.acct_trty_type
       AND ri_cd = comm.ri_cd;
  END LOOP;

  FOR expen IN (SELECT iss_cd,
                       line_cd,
        intm_ri,
                       SUM(NVL(def_comm_expense,0)) def_comm_expense
                  FROM GIAC_DEFERRED_COMM_EXPENSE_DTL
                 WHERE extract_year = p_year
                   AND extract_mm   = p_mm
                   AND procedure_id = p_method
                 GROUP BY iss_cd, line_cd, intm_ri)
  LOOP
    BEGIN
      SELECT NVL(def_comm_expense,0)
        INTO v_prev_def_comm_expense
        FROM GIAC_DEFERRED_COMM_EXPENSE
       WHERE ((YEAR = (p_year - 1) AND mm = 12 AND p_mm = 1)
              OR (YEAR = p_year AND mm = (p_mm-1) AND p_mm != 1))
         AND procedure_id = p_method
         AND iss_cd       = expen.iss_cd
         AND line_cd      = expen.line_cd
   AND intm_ri      = expen.intm_ri;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_prev_def_comm_expense := 0;
    END;

    v_def_comm_expense_diff := expen.def_comm_expense - v_prev_def_comm_expense;

    UPDATE GIAC_DEFERRED_COMM_EXPENSE
       SET def_comm_expense      = expen.def_comm_expense,
           prev_def_comm_expense = v_prev_def_comm_expense,
           def_comm_expense_diff = v_def_comm_expense_diff,
           numerator_factor      = NULL,
           denominator_factor    = NULL,
           user_id               = v_user_id,
           last_update           = SYSDATE
     WHERE YEAR = p_year
       AND mm   = p_mm
       AND procedure_id = p_method
       AND iss_cd = expen.iss_cd
       AND line_cd = expen.line_cd
    AND intm_ri = expen.intm_ri;
  END LOOP;

  COMMIT;

END Deferred_Compute2;
/


