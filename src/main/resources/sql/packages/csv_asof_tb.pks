CREATE OR REPLACE PACKAGE CPI.CSV_ASOF_TB AS         
   TYPE giacr502_record IS RECORD(branch_name giac_branches.branch_name%TYPE,
                                  gl_acct_no  VARCHAR2(50),
                                  acct_name   giac_chart_of_accts.gl_acct_name%TYPE,
                                  debit       giac_finance_yr.trans_balance%TYPE,
                                  credit      giac_finance_yr.trans_balance%TYPE,
                                  balance     giac_finance_yr.trans_balance%TYPE); 
                                  
   TYPE giacr502_adj_record IS RECORD(branch_name  giac_branches.branch_name%TYPE,
                                      gl_acct_no        VARCHAR2(50),
                                      acct_name         giac_chart_of_accts.gl_acct_name%TYPE,
                                      beg_debit         giac_finance_yr.beg_debit_amt%TYPE,
                                      beg_credit        giac_finance_yr.beg_debit_amt%TYPE,
                                      trans_debit       giac_finance_yr.trans_debit_bal%TYPE,
                                      trans_credit      giac_finance_yr.trans_debit_bal%TYPE,
                                      unadjusted_debit  NUMBER,
                                      unadjusted_credit NUMBER,
                                      adjusted_debit    NUMBER,
                                      adjusted_credit   NUMBER,
                                      end_debit         giac_finance_yr.trans_balance%TYPE,
                                      end_credit        giac_finance_yr.trans_balance%TYPE);   
   
   TYPE giacr502_dtld_record IS RECORD(branch_name  giac_branches.branch_name%TYPE,
                                       gl_acct_no   VARCHAR2(50),
                                       acct_name    giac_chart_of_accts.gl_acct_name%TYPE,
                                       beg_debit    giac_finance_yr.beg_debit_amt%TYPE,
                                       beg_credit   giac_finance_yr.beg_debit_amt%TYPE,
                                       trans_debit  giac_finance_yr.trans_debit_bal%TYPE,
                                       trans_credit giac_finance_yr.trans_debit_bal%TYPE,
                                       end_debit    giac_finance_yr.trans_balance%TYPE,
                                       end_credit   giac_finance_yr.trans_balance%TYPE,
                                       balance      giac_finance_yr.trans_credit_bal%TYPE);
                                       
   TYPE giacr502_cnsldtd_adj_record IS RECORD(gl_acct_no        VARCHAR2(50),
                                              acct_name         giac_chart_of_accts.gl_acct_name%TYPE,
                                              beg_debit         giac_finance_yr.beg_debit_amt%TYPE,
                                              beg_credit        giac_finance_yr.beg_debit_amt%TYPE,
                                              trans_debit       giac_finance_yr.trans_debit_bal%TYPE,
                                              trans_credit      giac_finance_yr.trans_debit_bal%TYPE,
                                              unadjusted_debit  NUMBER,
                                              unadjusted_credit NUMBER,
                                              adjusted_debit    NUMBER,
                                              adjusted_credit   NUMBER,
                                              end_debit         giac_finance_yr.trans_balance%TYPE,
                                              end_credit        giac_finance_yr.trans_balance%TYPE);
                                  
   TYPE giacr502_consolidated_record IS RECORD(gl_acct_no VARCHAR2(50),
                                               acct_name  giac_chart_of_accts.gl_acct_name%TYPE,
                                               debit      giac_finance_yr.trans_balance%TYPE,
                                               credit     giac_finance_yr.trans_balance%TYPE,
                                               balance    giac_finance_yr.trans_balance%TYPE);                                          
   TYPE giacr502_cnsldtd_dtld_record IS RECORD(gl_acct_no VARCHAR2(50),
                                               acct_name    giac_chart_of_accts.gl_acct_name%TYPE,
                                               beg_debit    giac_finance_yr.beg_debit_amt%TYPE,
                                               beg_credit   giac_finance_yr.beg_debit_amt%TYPE,
                                               trans_debit  giac_finance_yr.trans_debit_bal%TYPE,
                                               trans_credit giac_finance_yr.trans_debit_bal%TYPE,
                                               end_debit    giac_finance_yr.trans_balance%TYPE,
                                               end_credit   giac_finance_yr.trans_balance%TYPE,
                                               balance      giac_finance_yr.trans_credit_bal%TYPE);
                                               
   TYPE giacr502d_record IS RECORD(gl_acct_no VARCHAR2(50),                             -- shan 09.02.2014
                                   acct_name    giac_chart_of_accts.gl_acct_name%TYPE,
                                   beg_debit    giac_finance_yr.beg_debit_amt%TYPE,
                                   beg_credit   giac_finance_yr.beg_debit_amt%TYPE,
                                   trans_debit  giac_finance_yr.trans_debit_bal%TYPE,
                                   trans_credit giac_finance_yr.trans_debit_bal%TYPE,
                                   end_debit    giac_finance_yr.trans_balance%TYPE,
                                   end_credit   giac_finance_yr.trans_balance%TYPE);
   
   TYPE giacr502_table              IS TABLE OF giacr502_record;
   TYPE giacr502_adj_table          IS TABLE OF giacr502_adj_record;
   TYPE giacr502_dtld_table         IS TABLE OF giacr502_dtld_record;
   TYPE giacr502_cnsldtd_adj_table  IS TABLE OF giacr502_cnsldtd_adj_record;
   TYPE giacr502_consolidated_table IS TABLE OF giacr502_consolidated_record;
   TYPE giacr502_cnsldtd_dtld_table IS TABLE OF giacr502_cnsldtd_dtld_record; 
   TYPE giacr502d_table             IS TABLE OF giacr502d_record;     -- shan 09.02.2014
   
   FUNCTION giacr502(p_branch_cd giac_finance_yr.branch_cd%TYPE,
                     p_tran_year giac_finance_yr.tran_year%TYPE,
                     p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_table pipelined;
   
   FUNCTION giacr502a(p_tran_year giac_finance_yr.tran_year%TYPE,
                      p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_consolidated_table PIPELINED;
   
   FUNCTION giacr502b RETURN giacr502_consolidated_table PIPELINED;
   
   FUNCTION giacr502c(p_branch_cd GIAC_TRIAL_BALANCE_SUMMARY.branch_cd%TYPE) RETURN giacr502_table pipelined;
   
   FUNCTION giacr502d(p_tran_year giac_finance_yr.tran_year%TYPE,
                      p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_cnsldtd_dtld_table pipelined;

   FUNCTION giacr502e(p_branch_cd giac_finance_yr.branch_cd%TYPE,
                      p_tran_year giac_finance_yr.tran_year%TYPE,
                      p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_dtld_table pipelined;
                      
   FUNCTION giacr502f RETURN giacr502_cnsldtd_dtld_table pipelined;
   
   FUNCTION giacr502g(p_branch_cd giac_trial_balance_summary.branch_cd%TYPE) RETURN giacr502_dtld_table pipelined;
   
   FUNCTION giacr502ae_cnsldtd(p_tran_year giac_finance_yr.tran_year%TYPE,
                               p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_cnsldtd_adj_table pipelined;
                               
   FUNCTION giacr502ae(p_branch_cd giac_finance_yr.branch_cd%TYPE,
                       p_tran_year giac_finance_yr.tran_year%TYPE,
                       p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_adj_table pipelined;

   FUNCTION csv_giacr502(p_branch_cd giac_finance_yr.branch_cd%TYPE,
                     p_tran_yr giac_finance_yr.tran_year%TYPE,
                     p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_table pipelined;
   
   FUNCTION csv_giacr502a(p_tran_yr giac_finance_yr.tran_year%TYPE,
                      p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_consolidated_table PIPELINED;
   
   FUNCTION csv_giacr502b RETURN giacr502_consolidated_table PIPELINED;
   
   FUNCTION csv_giacr502c(p_branch_cd GIAC_TRIAL_BALANCE_SUMMARY.branch_cd%TYPE) RETURN giacr502_table pipelined;
   
   FUNCTION csv_giacr502d(p_tran_yr giac_finance_yr.tran_year%TYPE,
                      p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502d_table pipelined;

   FUNCTION csv_giacr502e(p_branch_cd giac_finance_yr.branch_cd%TYPE,
                      p_tran_yr giac_finance_yr.tran_year%TYPE,
                      p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_dtld_table pipelined;
                      
   FUNCTION csv_giacr502f RETURN giacr502_cnsldtd_dtld_table pipelined;
   
   FUNCTION csv_giacr502g(p_branch_cd giac_trial_balance_summary.branch_cd%TYPE) RETURN giacr502_dtld_table pipelined;
                               
   FUNCTION csv_giacr502ae(p_branch_cd giac_finance_yr.branch_cd%TYPE,
                       p_tran_yr giac_finance_yr.tran_year%TYPE,
                       p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_adj_table pipelined;
                       
   FUNCTION csv_giacr502ae_cnsldtd(p_tran_year giac_finance_yr.tran_year%TYPE,
                                   p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_cnsldtd_adj_table pipelined;
END;
/


