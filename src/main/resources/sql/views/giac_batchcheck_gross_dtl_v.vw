DROP VIEW CPI.GIAC_BATCHCHECK_GROSS_DTL_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_batchcheck_gross_dtl_v (line_cd,
                                                              policy_no,
                                                              policy_id,
                                                              prem_amt
                                                             )
AS
   SELECT a.line_cd, get_policy_no (a.policy_id) policy_no, a.policy_id,
          DECODE (a.spld_acct_ent_date,
                  c.TO_DATE, b.prem_amt * b.currency_rt * -1,
                  b.prem_amt * b.currency_rt
                 ) prem_amt
     FROM gipi_invoice b, gipi_polbasic a, giac_batch_check_gross_ext c
    WHERE a.policy_id = b.policy_id
      AND a.line_cd <> 'SC'
      AND a.subline_cd <> 'MOP'
      AND a.iss_cd <> 'RI'
      AND a.line_cd = c.line_cd
      AND (   TRUNC (a.acct_ent_date) = c.TO_DATE
           OR TRUNC (a.spld_acct_ent_date) = c.TO_DATE
          );


