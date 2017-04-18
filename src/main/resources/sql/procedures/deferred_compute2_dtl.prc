DROP PROCEDURE CPI.DEFERRED_COMPUTE2_DTL;

CREATE OR REPLACE PROCEDURE CPI.Deferred_Compute2_Dtl(p_ext_year               NUMBER,
                                                      p_ext_mm                 NUMBER,
                                                      p_year                   NUMBER,
                                                      p_mm                     NUMBER,
                                                      p_method                 NUMBER,
                                                      p_numerator_factor       NUMBER,
                                                      p_denominator_factor     NUMBER,
                                                      p_numerator_factor_mn    NUMBER,
                                                      p_denominator_factor_mn  NUMBER,
                                                      p_numrtr_factordf_y      NUMBER, --added 4 parameters (1)
                                                      p_numrtr_factormndf_y    NUMBER, -- (2)
                                                      p_dnmtr_factordf_y       NUMBER, -- (3)
                                                      p_dnmtr_factormn_df_y    NUMBER) IS -- (4) : alfie 06042010 : for factors with Y def_tag
/* Created by:   Vincent
** Date Created: 062405
** Description:  Computes detailed data based on specs for the monthly computation of 24th Method
*/

/*
** Modified by: judyann
** Date Modified: 03012007
** Description: Removed hard-coding of line; Used parameters; Added exclusion of line Marine Hull;
               Added parameter for take-up of Commission Income and Commission Expense
*/

/* Modified by:    Alfie
** Date Modified:  06082010
** Description:    Handles the additional factors for monthly computation of 24th Method, additional factors spans up to 13 months
*/

  v_line_cd_mn VARCHAR2(10) := Giisp.v('LINE_CODE_MN'); --create an initial variable for the parameter LINE_CODE_MN
                                                      --Giisp.v('LINE_CODE_MN') below was replaced by v_line_cd_mn :alfie 06082010
  v_mn_24th_comp VARCHAR2(10) := Giacp.v('MARINE_COMPUTATION_24TH'); --identifier which factor will be used if the line_cd is MN,
                                                                   --if 1 factors for for MN, if 2 factors for other lines :alfie 06082010
  v_user_id         VARCHAR2(8) := NVL(giis_users_pkg.app_user, USER);     --added by Gzelle 05.31.2013, replaced all USER with v_user_id                                                                   
BEGIN
  IF (p_mm != p_ext_mm AND p_ext_year != p_year)
     OR (p_mm <= p_ext_mm AND p_ext_year = p_year)
     OR (p_mm = 99) THEN --alfie

     /* Deferred Gross Premium */
     UPDATE GIAC_DEFERRED_GROSS_PREM_DTL
        SET def_prem_amt       = (prem_amt) * DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1',p_numerator_factor_mn/p_denominator_factor_mn,
                                                     p_numerator_factor/p_denominator_factor),p_numerator_factor/p_denominator_factor),
            numerator_factor   = DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1',p_numerator_factor_mn,
                                        p_numerator_factor),p_numerator_factor),
            denominator_factor = DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1', p_denominator_factor_mn,
                                        p_denominator_factor),p_denominator_factor),
            user_id            = v_user_id,
            last_update        = SYSDATE
      WHERE extract_year = p_ext_year
        AND extract_mm = p_ext_mm
        AND YEAR = p_year
        AND mm   = p_mm
        AND procedure_id = p_method;

     /* RI Premium Ceded */
     UPDATE GIAC_DEFERRED_RI_PREM_CEDE_DTL
        SET def_dist_prem      = (dist_prem) * DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1',p_numerator_factor_mn/p_denominator_factor_mn,
                                                     p_numerator_factor/p_denominator_factor),p_numerator_factor/p_denominator_factor),
            numerator_factor   = DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1',p_numerator_factor_mn,
                                        p_numerator_factor),p_numerator_factor),
            denominator_factor = DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1',p_denominator_factor_mn,
                                        p_denominator_factor),p_denominator_factor),
            user_id            = v_user_id,
            last_update        = SYSDATE
      WHERE extract_year = p_ext_year
        AND extract_mm = p_ext_mm
        AND YEAR = p_year
        AND mm   = p_mm
        AND procedure_id = p_method;
     END IF;

     /* Commission Income */
     IF NVL(Giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'Y' THEN
     UPDATE GIAC_DEFERRED_COMM_INCOME_DTL
        SET def_comm_income    = (comm_income) * DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1',(p_numrtr_factormndf_y/p_dnmtr_factormn_df_y),
                                                      (p_numrtr_factordf_y/p_dnmtr_factordf_y)),(p_numrtr_factordf_y/p_dnmtr_factordf_y)),
            numerator_factor   = DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1', p_numrtr_factormndf_y,p_numrtr_factordf_y),
                                        p_numrtr_factordf_y),
            denominator_factor = DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1', p_dnmtr_factormn_df_y ,p_dnmtr_factordf_y),
                                        p_dnmtr_factordf_y),
            user_id            = v_user_id,
            last_update        = SYSDATE
      WHERE extract_year = p_ext_year
        AND extract_mm = p_ext_mm
        AND YEAR = p_year
        AND mm   = p_mm
        AND procedure_id = p_method;
  ELSE
     IF (p_mm != p_ext_mm AND p_ext_year != p_year)
        OR (p_mm <= p_ext_mm AND p_ext_year = p_year) 
        OR (p_mm = 99) THEN --alfie
         UPDATE GIAC_DEFERRED_COMM_INCOME_DTL
            SET def_comm_income    = (comm_income) * DECODE(line_cd, /*'MN'*/ v_line_cd_mn,  DECODE(v_mn_24th_comp,'1',p_numerator_factor_mn/p_denominator_factor_mn,
                                                         p_numerator_factor/p_denominator_factor),p_numerator_factor/p_denominator_factor),
                numerator_factor   = DECODE(line_cd, /*'MN'*/ v_line_cd_mn,  DECODE(v_mn_24th_comp,'1',p_numerator_factor_mn,
                                            p_numerator_factor), p_numerator_factor),
                denominator_factor = DECODE(line_cd, /*'MN'*/ v_line_cd_mn,  DECODE(v_mn_24th_comp,'1',p_denominator_factor_mn,
                                            p_denominator_factor),p_denominator_factor),
                user_id            = v_user_id,
                last_update        = SYSDATE
          WHERE extract_year = p_ext_year
            AND extract_mm = p_ext_mm
            AND YEAR = p_year
            AND mm   = p_mm
            AND procedure_id = p_method;
     END IF;

  END IF;

  /* Commission Expense */
  IF NVL(Giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'Y' THEN
     UPDATE GIAC_DEFERRED_COMM_EXPENSE_DTL
        SET def_comm_expense   = (comm_expense) * DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1',(p_numrtr_factormndf_y/p_dnmtr_factormn_df_y),
                                                      (p_numrtr_factordf_y/p_dnmtr_factordf_y)),(p_numrtr_factordf_y/p_dnmtr_factordf_y)),
            numerator_factor   = DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1', p_numrtr_factormndf_y,p_numrtr_factordf_y),
                                        p_numrtr_factordf_y),
            denominator_factor = DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1', p_dnmtr_factormn_df_y,p_dnmtr_factordf_y),
                                        p_dnmtr_factordf_y),
            user_id            = v_user_id,
            last_update        = SYSDATE
      WHERE extract_year = p_ext_year
        AND extract_mm = p_ext_mm
        AND YEAR = p_year
        AND mm   = p_mm
        AND procedure_id = p_method;
  ELSE
     IF (p_mm != p_ext_mm AND p_ext_year != p_year)
        OR (p_mm <= p_ext_mm AND p_ext_year = p_year) 
        OR (p_mm = 99) THEN --alfie
         UPDATE GIAC_DEFERRED_COMM_EXPENSE_DTL
            SET def_comm_expense   = (comm_expense) * DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1',p_numerator_factor_mn/p_denominator_factor_mn,
                                                         p_numerator_factor/p_denominator_factor),p_numerator_factor/p_denominator_factor),
                numerator_factor   = DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1',p_numerator_factor_mn,
                                            p_numerator_factor),p_numerator_factor),
                denominator_factor = DECODE(line_cd, /*'MN'*/ v_line_cd_mn, DECODE(v_mn_24th_comp,'1',p_denominator_factor_mn,
                                            p_denominator_factor),p_denominator_factor),
                user_id            = v_user_id,
                last_update        = SYSDATE
          WHERE extract_year = p_ext_year
            AND extract_mm = p_ext_mm
            AND YEAR = p_year
            AND mm   = p_mm
            AND procedure_id = p_method;
     END IF;
  END IF;
END Deferred_Compute2_Dtl;
/


