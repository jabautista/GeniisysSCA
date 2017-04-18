DROP VIEW CPI.GIAC_AGING_INTM_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_aging_intm_v (balance_amt_due,
                                                    prem_balance_due,
                                                    tax_balance_due,
                                                    intm_no,
                                                    intm_name
                                                   )
AS
   SELECT   SUM (balance_amt_due) balance_amt_due,
            SUM (prem_bal_due) prem_balance_due,
            SUM (tax_bal_due) tax_balance_due, intm_no, intm_name
       FROM giac_soa_rep_ext
      WHERE user_id = USER AND intm_no != 0 AND assd_no != 0
   GROUP BY intm_no, intm_name;


