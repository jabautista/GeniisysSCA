DROP VIEW CPI.GIAC_TRIAL_BALANCE_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_trial_balance_v (gl_acct_id,
                                                       gl_acct_no_formatted,
                                                       gl_acct_no,
                                                       gl_acct_category,
                                                       gl_control_acct,
                                                       gl_sub_acct_1,
                                                       gl_sub_acct_2,
                                                       gl_sub_acct_3,
                                                       gl_sub_acct_4,
                                                       gl_sub_acct_5,
                                                       gl_sub_acct_6,
                                                       gl_sub_acct_7,
                                                       gl_acct_name,
                                                       tran_year,
                                                       tran_mm,
                                                       branch_name,
                                                       branch_cd,
                                                       trans_debit_bal,
                                                       trans_credit_bal
                                                      )
AS
   SELECT a.gl_acct_id,
             b.gl_acct_category
          || '-'
          || LTRIM (TO_CHAR (b.gl_control_acct, '09'))
          || '-'
          || LTRIM (TO_CHAR (b.gl_sub_acct_1, '09'))
          || '-'
          || LTRIM (TO_CHAR (b.gl_sub_acct_2, '09'))
          || '-'
          || LTRIM (TO_CHAR (b.gl_sub_acct_3, '09'))
          || '-'
          || LTRIM (TO_CHAR (b.gl_sub_acct_4, '09'))
          || '-'
          || LTRIM (TO_CHAR (b.gl_sub_acct_5, '09'))
          || '-'
          || LTRIM (TO_CHAR (b.gl_sub_acct_6, '09'))
          || '-'
          || LTRIM (TO_CHAR (b.gl_sub_acct_7, '09')) gl_acct_no_formatted,
             b.gl_acct_category
          || '-'
          || b.gl_control_acct
          || '-'
          || b.gl_sub_acct_1
          || '-'
          || b.gl_sub_acct_2
          || '-'
          || b.gl_sub_acct_3
          || '-'
          || b.gl_sub_acct_4
          || '-'
          || b.gl_sub_acct_5
          || '-'
          || b.gl_sub_acct_6
          || '-'
          || b.gl_sub_acct_7 gl_acct_no,
          b.gl_acct_category, b.gl_control_acct, b.gl_sub_acct_1,
          b.gl_sub_acct_2, b.gl_sub_acct_3, b.gl_sub_acct_4, b.gl_sub_acct_5,
          b.gl_sub_acct_6, b.gl_sub_acct_7, b.gl_acct_name, a.tran_year,
          a.tran_mm, c.branch_name, c.branch_cd, a.trans_debit_bal,
          a.trans_credit_bal
     FROM giac_monthly_totals a, giac_chart_of_accts b, giac_branches c
    WHERE a.gl_acct_id = b.gl_acct_id AND a.branch_cd = c.branch_cd;


