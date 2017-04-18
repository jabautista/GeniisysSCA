DROP VIEW CPI.GIAC_SOA_SUMMARIES_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_soa_summaries_v (a020_assd_no,
                                                       balance_amt_due,
                                                       prem_balance_due,
                                                       tax_balance_due
                                                      )
AS
   SELECT   a020_assd_no, SUM (balance_amt_due) balance_amt_due,
            SUM (prem_balance_due) prem_balance_due,
            SUM (tax_balance_due) tax_balance_due
       FROM giac_aging_soa_details
   GROUP BY a020_assd_no;


