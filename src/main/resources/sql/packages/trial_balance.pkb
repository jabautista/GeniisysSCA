CREATE OR REPLACE PACKAGE BODY CPI.Trial_Balance AS

  FUNCTION get_debit_adjusting (p_gl_acct_id       GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
                                p_branch_cd        GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
                                p_tran_yr          GIAC_FINANCE_YR.tran_year%TYPE,
                                p_tran_mm          GIAC_FINANCE_YR.tran_mm%TYPE) RETURN NUMBER IS
    v_debit_amt   GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    v_posting_dt  GIAC_ACCTRANS.posting_date%TYPE;
  BEGIN

    SELECT LAST_DAY(TO_DATE(p_tran_mm||'/'||p_tran_yr,'MM/RRRR'))
    INTO   v_posting_dt
    FROM   dual;
    /*Modified by Edison 06.14.2012
    **To be tallied with credit_amt. Debit amt doesnt need to less the credit amt to get the value.*/
    FOR A IN (SELECT SUM(debit_amt) debit_amt --DECODE( SIGN(SUM (debit_amt)- SUM (credit_amt)) ,1, SUM (debit_amt)- SUM (credit_amt),0) debit_amt --Edison 06.14.2012 
              FROM   GIAC_ACCTRANS B,
                     GIAC_ACCT_ENTRIES A
              WHERE  b.tran_id         = A.gacc_tran_id
              AND    b.gibr_branch_cd  = NVL(p_branch_cd, b.gibr_branch_cd)
              AND    A.gl_acct_id      = p_gl_acct_id     
              AND    ae_tag            = 'Y'
              AND    posting_date      = v_posting_dt) LOOP

      v_debit_amt := A.debit_amt;
      EXIT;
    END LOOP;            
  
    RETURN (v_debit_amt);
  END get_debit_adjusting;        
  
  FUNCTION get_credit_adjusting (p_gl_acct_id       GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
                                 p_branch_cd        GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
                                 p_tran_yr          GIAC_FINANCE_YR.tran_year%TYPE,
                                 p_tran_mm          GIAC_FINANCE_YR.tran_mm%TYPE) RETURN NUMBER IS
    v_credit_amt   GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    v_posting_dt  GIAC_ACCTRANS.posting_date%TYPE;
  BEGIN

    SELECT LAST_DAY(TO_DATE(p_tran_mm||'/'||p_tran_yr,'MM/RRRR'))
    INTO   v_posting_dt
    FROM   dual;

    FOR A IN (SELECT SUM (credit_amt) credit_amt
              FROM   GIAC_ACCTRANS B,
                     GIAC_ACCT_ENTRIES A
              WHERE  b.tran_id         = A.gacc_tran_id
              AND    b.gibr_branch_cd  = NVL(p_branch_cd, b.gibr_branch_cd)
              AND    A.gl_acct_id      = p_gl_acct_id         
              AND    ae_tag            = 'Y'
              AND    posting_date      = v_posting_dt) LOOP

      v_credit_amt := A.credit_amt;
      EXIT;
    END LOOP;            
  
    RETURN (v_credit_amt);
  END get_credit_adjusting;  

END;
/


