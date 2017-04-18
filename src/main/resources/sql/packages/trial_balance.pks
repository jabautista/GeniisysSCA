CREATE OR REPLACE PACKAGE CPI.Trial_Balance AS

  FUNCTION get_debit_adjusting (p_gl_acct_id       GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
                                p_branch_cd        GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
                                p_tran_yr          GIAC_FINANCE_YR.tran_year%TYPE,
                                p_tran_mm          GIAC_FINANCE_YR.tran_mm%TYPE) RETURN NUMBER;

  FUNCTION get_credit_adjusting (p_gl_acct_id       GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
                                 p_branch_cd        GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
                                 p_tran_yr          GIAC_FINANCE_YR.tran_year%TYPE,
                                 p_tran_mm          GIAC_FINANCE_YR.tran_mm%TYPE) RETURN NUMBER;

END;
/


