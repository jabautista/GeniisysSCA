DROP VIEW CPI.GIAC_MONTHLY_TRANS_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_monthly_trans_v (gl_acct_id,
                                                       fund_cd,
                                                       branch_cd,
                                                       tran_year,
                                                       tran_mm,
                                                       tran_source,
                                                       total_debit_amt,
                                                       total_credit_amt,
                                                       bal_debit_amt,
                                                       bal_credit_amt
                                                      )
AS
   SELECT   b.gl_acct_id gl_acct_id, b.gacc_gfun_fund_cd fund_cd,
            b.gacc_gibr_branch_cd branch_cd, a.tran_year tran_year,
            a.tran_month tran_mm, a.tran_class tran_source,
            SUM (NVL (b.debit_amt, 0)) total_debit_amt,
            SUM (NVL (b.credit_amt, 0)) total_credit_amt,
            DECODE (GREATEST (SUM (NVL (b.debit_amt, 0)),
                              SUM (NVL (b.credit_amt, 0))
                             ),
                    SUM (NVL (b.debit_amt, 0)), SUM (NVL (b.debit_amt, 0))
                     - SUM (NVL (b.credit_amt, 0)),
                    0
                   ) bal_debit_amt,
            DECODE (GREATEST (SUM (NVL (b.debit_amt, 0)),
                              SUM (NVL (b.credit_amt, 0))
                             ),
                    SUM (NVL (b.credit_amt, 0)), SUM (NVL (b.credit_amt, 0))
                     - SUM (NVL (b.debit_amt, 0)),
                    0
                   ) bal_credit_amt
       FROM giac_acctrans a, giac_acct_entries b
      WHERE a.tran_id = b.gacc_tran_id
        AND a.gfun_fund_cd = b.gacc_gfun_fund_cd
        AND a.gibr_branch_cd = b.gacc_gibr_branch_cd
   GROUP BY b.gl_acct_id,
            b.gacc_gfun_fund_cd,
            b.gacc_gibr_branch_cd,
            a.tran_year,
            a.tran_month,
            a.tran_class
            WITH READ ONLY;


