DROP VIEW CPI.GIAC_AGING_TOTALS_ASSD_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_aging_totals_assd_v (aging_id,
                                                           balance_amt_due,
                                                           prem_balance_due,
                                                           tax_balance_due,
                                                           gibr_gfun_fund_cd,
                                                           gibr_branch_cd,
                                                           assd_no
                                                          )
AS
   SELECT   a.aging_id, SUM (balance_amt_due) balance_amt_due,
            SUM (prem_bal_due) prem_balance_due,
            SUM (tax_bal_due) tax_balance_due, gibr_gfun_fund_cd,
            gibr_branch_cd, assd_no
       FROM giac_soa_rep_ext a, giac_aging_parameters b
      WHERE a.aging_id = b.aging_id
        AND a.fund_cd = gibr_gfun_fund_cd
        AND a.branch_cd = gibr_branch_cd
        AND a.user_id = USER
   GROUP BY a.aging_id, gibr_gfun_fund_cd, gibr_branch_cd, assd_no;


