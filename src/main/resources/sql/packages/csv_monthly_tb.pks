CREATE OR REPLACE PACKAGE CPI.Csv_Monthly_Tb AS
   TYPE con_br_typ_rec IS RECORD(gl_acct_no   VARCHAR2(50),
                                 acct_name    GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
                                 YEAR         GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                                 MONTH        GIAC_MONTHLY_TOTALS.tran_mm%TYPE,
                                 debit        GIAC_MONTHLY_TOTALS.trans_debit_bal%TYPE,
                                 credit       GIAC_MONTHLY_TOTALS.trans_credit_bal%TYPE);
   TYPE con_br_typ_rep IS TABLE OF con_br_typ_rec;
   /*april*/
    TYPE inc_subtotals_rec IS RECORD(branch_name GIAC_BRANCHES.branch_name%TYPE,
                   gl_acct_no   VARCHAR2(50),
                                     acct_name    GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
                                     debit        GIAC_MONTHLY_TOTALS.trans_debit_bal%TYPE,
                                     credit       GIAC_MONTHLY_TOTALS.trans_credit_bal%TYPE);
   TYPE inc_subtotals_rep IS TABLE OF inc_subtotals_rec;--april
   TYPE con_br_typ_rec_w_sum IS RECORD(gl_acct_no VARCHAR2(50),
                                       acct_name  GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
                                       debit      GIAC_MONTHLY_TOTALS.trans_debit_bal%TYPE,
                                       credit     GIAC_MONTHLY_TOTALS.trans_credit_bal%TYPE);
   TYPE con_br_typ_rep_w_sum IS TABLE OF con_br_typ_rec_w_sum;
   TYPE break_by_br_rec IS RECORD(branch_name GIAC_BRANCHES.branch_name%TYPE,
                                  gl_acct_no  VARCHAR2(50),
                                  acct_name   GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
                                  YEAR        GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                                  MONTH       GIAC_MONTHLY_TOTALS.tran_mm%TYPE,
                                  debit       GIAC_MONTHLY_TOTALS.trans_debit_bal%TYPE,
                                  credit      GIAC_MONTHLY_TOTALS.trans_credit_bal%TYPE);
   TYPE break_by_br_rep IS TABLE OF break_by_br_rec;
   TYPE summary_rec IS RECORD(branch_name GIAC_BRANCHES.branch_name%TYPE,
               gl_acct_no  VARCHAR2(50),
                              acct_name   GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
                              debit       GIAC_MONTHLY_TOTALS.trans_debit_bal%TYPE,
                              credit      GIAC_MONTHLY_TOTALS.trans_credit_bal%TYPE);
   TYPE summary_rep IS TABLE OF summary_rec;
   TYPE standard_rec IS RECORD(branch_name  GIAC_BRANCHES.branch_name%TYPE,
                               gl_acct_no   VARCHAR2(50),                                             
                               ACCT_NAME    GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
                               YEAR         GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                               MONTH        GIAC_MONTHLY_TOTALS.tran_mm%TYPE,
                               DEBIT        GIAC_MONTHLY_TOTALS.trans_debit_bal%TYPE,
                               CREDIT       GIAC_MONTHLY_TOTALS.trans_credit_bal%TYPE);
   TYPE standard_rep IS TABLE OF standard_rec;
   TYPE adj_entries_rec IS RECORD(branch_name   GIAC_BRANCHES.branch_name%TYPE,
                                  gl_acct_no    VARCHAR2(50),
                                  acct_name     GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE, 
                                  YEAR          GIAC_MONTHLY_TOTALS.tran_year%TYPE, 
                                  MONTH         GIAC_MONTHLY_TOTALS.tran_mm%TYPE, 
                                  debit         GIAC_MONTHLY_TOTALS.trans_debit_bal%TYPE,
                                  credit        GIAC_MONTHLY_TOTALS.trans_credit_bal%TYPE,
                                  adjust_debit  GIAC_MONTHLY_TOTALS.trans_debit_bal%TYPE,
                                  adjust_credit GIAC_MONTHLY_TOTALS.trans_credit_bal%TYPE,
                                  bal_debit     GIAC_MONTHLY_TOTALS.trans_debit_bal%TYPE,
                                  bal_credit    GIAC_MONTHLY_TOTALS.trans_credit_bal%TYPE);
   TYPE adj_entries_rep IS TABLE OF adj_entries_rec;
   FUNCTION con_branches(p_tran_year GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                         p_tran_mm   GIAC_MONTHLY_TOTALS.tran_mm%TYPE) RETURN con_br_typ_rep PIPELINED;
   FUNCTION con_branches_w_sum(p_user_id GIIS_USERS.user_id%TYPE) RETURN con_br_typ_rep_w_sum PIPELINED; --modified by Daniel Marasigan SR 22768
   FUNCTION break_by_branch(p_tran_year GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                            p_tran_mm   GIAC_MONTHLY_TOTALS.tran_mm%TYPE) RETURN break_by_br_rep PIPELINED;
   FUNCTION summary_report(p_user_id GIIS_USERS.user_id%TYPE) RETURN summary_rep PIPELINED; --modified by Daniel Marasigan SR 22768; same issue with SR 22768
   FUNCTION standard_report(p_tran_year GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                           p_tran_mm    GIAC_MONTHLY_TOTALS.tran_mm%TYPE) RETURN standard_rep PIPELINED;
   FUNCTION adjusting_entries(p_tran_year GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                              p_tran_mm   GIAC_MONTHLY_TOTALS.tran_mm%TYPE,
                              p_branch    VARCHAR2) RETURN adj_entries_rep PIPELINED;
         /*ADDED BY APRIL*/
   FUNCTION sub_totals(p_tran_year GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                         p_tran_mm   GIAC_MONTHLY_TOTALS.tran_mm%TYPE) RETURN inc_subtotals_rep PIPELINED;
END;
/


