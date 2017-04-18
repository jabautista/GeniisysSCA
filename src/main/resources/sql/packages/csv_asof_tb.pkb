CREATE OR REPLACE PACKAGE BODY CPI.CSV_ASOF_TB AS     
   FUNCTION giacr502(p_branch_cd giac_finance_yr.branch_cd%TYPE,
                     p_tran_year giac_finance_yr.tran_year%TYPE,
                     p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_table pipelined
   IS
     CURSOR a
     IS
     SELECT gb.branch_name,
            get_gl_acct_no(gfy.gl_acct_id) gl_no,
            gca.gl_acct_name,
            DECODE(SIGN(gfy.trans_balance),-1,0,1,ABS(gfy.trans_balance),0) debit,
            DECODE(SIGN(gfy.trans_balance),-1,ABS(gfy.trans_balance),1,0,0) credit,
            gfy.trans_balance balance
       FROM giac_finance_yr gfy, giac_chart_of_accts gca, giac_branches gb
      WHERE gfy.gl_acct_id = gca.gl_acct_id
        AND gfy.branch_cd  = gb.branch_cd
        AND gfy.tran_year  = p_tran_year
        AND gfy.tran_mm    = p_tran_mm
        AND gfy.branch_cd  = NVL(p_branch_cd, gfy.branch_cd)
      ORDER BY gfy.fund_cd, gfy.branch_cd, get_gl_acct_no(gfy.gl_acct_id), gca.gl_acct_name;
 
     v_rec giacr502_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.branch_name := nvl(i.branch_name,0);
         v_rec.gl_acct_no  := nvl(i.gl_no,0);
         v_rec.acct_name   := nvl(i.gl_acct_name,0);
         v_rec.debit       := nvl(i.debit,0);
         v_rec.credit      := nvl(i.credit,0);
         v_rec.balance     := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;

   FUNCTION giacr502a(p_tran_year giac_finance_yr.tran_year%TYPE,
                      p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_consolidated_table pipelined
   IS
     CURSOR a
     IS
     SELECT get_gl_acct_no(gfy.gl_acct_id) gl_no,
            gca.gl_acct_name,
            sum(decode(sign(gfy.trans_balance),1, gfy.trans_balance,0)) debit,
            sum(abs(decode(sign(gfy.trans_balance),-1, gfy.trans_balance,0))) credit,
            sum(gfy.trans_balance) balance
       FROM giac_finance_yr gfy, giac_chart_of_accts gca 
      WHERE gfy.gl_acct_id = gca.gl_acct_id
        AND gfy.tran_year  = p_tran_year
        AND gfy.tran_mm    = p_tran_mm
      GROUP BY get_gl_acct_no(gfy.gl_acct_id), gca.gl_acct_name
      ORDER BY get_gl_acct_no(gfy.gl_acct_id), gca.gl_acct_name;
 
     v_rec giacr502_consolidated_record;
     
   BEGIN
       FOR i IN a
       LOOP
         v_rec.gl_acct_no := nvl(i.gl_no,0);
         v_rec.acct_name  := nvl(i.gl_acct_name,0);
         v_rec.debit      := nvl(i.debit,0);
         v_rec.credit     := nvl(i.credit,0);
         v_rec.balance    := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;

   FUNCTION giacr502b RETURN giacr502_consolidated_table PIPELINED
   IS
     CURSOR a
     IS
     SELECT get_gl_acct_no(a.gl_acct_id) gl_no,
            b.gl_acct_name,
            a.gl_acct_id,
            sum(decode(sign(trans_balance),1, trans_balance,0)) debit,
            sum(abs(decode(sign(trans_balance),-1, trans_balance,0))) credit,
            sum(trans_balance) balance
       FROM giac_trial_balance_summary a, giac_chart_of_accts b
      WHERE a.gl_acct_id = b.gl_acct_id
      GROUP BY b.gl_acct_name, a.gl_acct_id, get_gl_acct_no(a.gl_acct_id)
      ORDER BY gl_no;
 
     v_rec giacr502_consolidated_record;
     
   BEGIN
       FOR i IN a
       LOOP
         v_rec.gl_acct_no := nvl(i.gl_no,0);
         v_rec.acct_name  := nvl(i.gl_acct_name,0);
         v_rec.debit      := nvl(i.debit,0);
         v_rec.credit     := nvl(i.credit,0);
         v_rec.balance    := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION giacr502c(p_branch_cd GIAC_TRIAL_BALANCE_SUMMARY.branch_cd%TYPE) RETURN giacr502_table pipelined
   IS
     CURSOR a
     IS
     SELECT c.BRANCH_name,
            get_gl_acct_no(a.gl_acct_id) gl_no,
            b.gl_acct_name,
            SUM(DECODE(SIGN(trans_balance),1, trans_balance,0)) debit,
            SUM(ABS(DECODE(SIGN(trans_balance),-1, trans_balance,0))) credit,
            SUM(trans_balance) balance
       FROM GIAC_TRIAL_BALANCE_SUMMARY a, GIAC_CHART_OF_ACCTS b, giac_branches c
      WHERE a.user_id    = USER
        AND a.gl_acct_id = b.gl_acct_id
        AND a.branch_cd  = c.branch_cd
        AND a.BRANCH_CD  = NVL(p_branch_cd, a.BRANCH_CD)
      GROUP BY a.FUND_CD, c.BRANCH_name, b.gl_acct_name, a.gl_acct_id, get_gl_acct_no(a.gl_acct_id)
      ORDER BY c.branch_name, gl_no;
 
     v_rec giacr502_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.branch_name := nvl(i.branch_name,0);
         v_rec.gl_acct_no  := nvl(i.gl_no,0);
         v_rec.acct_name   := nvl(i.gl_acct_name,0);
         v_rec.debit       := nvl(i.debit,0);
         v_rec.credit      := nvl(i.credit,0);
         v_rec.balance     := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION giacr502d(p_tran_year giac_finance_yr.tran_year%TYPE,
                      p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_cnsldtd_dtld_table pipelined
   IS
     CURSOR a
     IS
     SELECT get_gl_acct_no(a.gl_acct_id) gl_no,
            b.gl_acct_name, 
            sum(decode(sign(a.beg_debit_amt-a.beg_credit_amt), 1,  (a.beg_debit_amt-a.beg_credit_amt), 0)) beg_debit,
            sum(abs(decode(sign(a.beg_debit_amt-a.beg_credit_amt), -1, (a.beg_debit_amt-a.beg_credit_amt), 0))) beg_credit,
            sum(a.trans_debit_bal) trans_debit, 
            sum(a.trans_credit_bal) trans_credit,
            sum(decode(sign(a.trans_balance),1, a.trans_balance,0)) end_debit,
            sum(abs(decode(sign(a.trans_balance),-1, a.trans_balance,0))) end_credit,
            sum(a.trans_balance) balance
       FROM giac_finance_yr a, giac_chart_of_accts b
      WHERE a.gl_acct_id = b.gl_acct_id
        AND tran_year    = p_tran_year
        AND tran_mm      = p_tran_mm
      GROUP BY get_gl_acct_no(a.gl_acct_id), b.gl_acct_name
      ORDER BY Get_Gl_Acct_No(a.gl_acct_id), b.gl_acct_name;
 
     v_rec giacr502_cnsldtd_dtld_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.gl_acct_no   := nvl(i.gl_no,0);
         v_rec.acct_name    := nvl(i.gl_acct_name,0);
         v_rec.beg_debit    := nvl(i.beg_debit,0);
         v_rec.beg_credit   := nvl(i.beg_credit,0);
         v_rec.trans_debit  := nvl(i.trans_debit,0);
         v_rec.trans_credit := nvl(i.trans_credit,0);
         v_rec.end_debit    := nvl(i.end_debit,0);
         v_rec.end_credit   := nvl(i.end_credit,0);
         v_rec.balance      := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION giacr502e(p_branch_cd giac_finance_yr.branch_cd%TYPE,
                      p_tran_year giac_finance_yr.tran_year%TYPE,
                      p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_dtld_table pipelined
   IS
     CURSOR a
     IS
     SELECT c.branch_name,
            get_gl_acct_no(a.gl_acct_id) gl_no,
            b.gl_acct_name,
            sum(decode(sign(a.beg_debit_amt-a.beg_credit_amt), 1,  (a.beg_debit_amt-a.beg_credit_amt), 0)) beg_debit, 
            sum(abs(decode(sign(a.beg_debit_amt-a.beg_credit_amt), -1, (a.beg_debit_amt-a.beg_credit_amt), 0))) beg_credit, 
            sum(a.trans_debit_bal) trans_debit, 
            sum(a.trans_credit_bal) trans_credit,
            sum(decode(sign(a.trans_balance),1, a.trans_balance,0)) end_debit,    
            sum(abs(decode(sign(a.trans_balance),-1, a.trans_balance,0))) end_credit,
            sum(a.trans_balance) balance  
       FROM giac_finance_yr a, giac_chart_of_accts b, giac_branches c
      WHERE a.gl_acct_id = b.gl_acct_id
        AND a.branch_cd  = c.branch_cd
        AND tran_year    = p_tran_year 
        AND tran_mm      = p_tran_mm
        AND c.branch_cd  = NVL(p_branch_cd, a.branch_cd)
      GROUP BY c.branch_name, get_gl_acct_no(a.gl_acct_id), b.gl_acct_name
      order by c.branch_name, gl_no;
 
     v_rec giacr502_dtld_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.branch_name  := nvl(i.branch_name,0);
         v_rec.gl_acct_no   := nvl(i.gl_no,0);
         v_rec.acct_name    := nvl(i.gl_acct_name,0);
         v_rec.beg_debit    := nvl(i.beg_debit,0);
         v_rec.beg_credit   := nvl(i.beg_credit,0);
         v_rec.trans_debit  := nvl(i.trans_debit,0);
         v_rec.trans_credit := nvl(i.trans_credit,0);
         v_rec.end_debit    := nvl(i.end_debit,0);
         v_rec.end_credit   := nvl(i.end_credit,0);
         v_rec.balance      := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION giacr502f RETURN giacr502_cnsldtd_dtld_table pipelined
   IS
     CURSOR a
     IS
     SELECT get_gl_acct_no(a.gl_acct_id) gl_no,
            b.gl_acct_name,
            sum(decode(sign(beg_debit_bal-beg_credit_bal), 1, (beg_debit_bal-beg_credit_bal) , 0)) beg_debit,
            sum(abs(decode(sign(beg_debit_bal-beg_credit_bal),-1,(beg_debit_bal-beg_credit_bal),0))) beg_credit,
            sum(a.debit) trans_debit, 
            sum(a.credit) trans_credit,
            sum(decode(sign(a.trans_balance),1, a.trans_balance,0)) end_debit,
            sum(abs(decode(sign(a.trans_balance),-1, a.trans_balance,0))) end_credit,
            sum(a.trans_balance) balance
       FROM giac_trial_balance_summary a, giac_chart_of_accts b
      WHERE a.gl_acct_id = b.gl_acct_id
        AND a.user_id    = USER
      GROUP BY get_gl_acct_no(a.gl_acct_id), b.gl_acct_name
      ORDER BY get_gl_acct_no(a.gl_acct_id);
 
     v_rec giacr502_cnsldtd_dtld_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.gl_acct_no   := nvl(i.gl_no,0);
         v_rec.acct_name    := nvl(i.gl_acct_name,0);
         v_rec.beg_debit    := nvl(i.beg_debit,0);
         v_rec.beg_credit   := nvl(i.beg_credit,0);
         v_rec.trans_debit  := nvl(i.trans_debit,0);
         v_rec.trans_credit := nvl(i.trans_credit,0);
         v_rec.end_debit    := nvl(i.end_debit,0);
         v_rec.end_credit   := nvl(i.end_credit,0);
         v_rec.balance      := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION giacr502g(p_branch_cd giac_trial_balance_summary.branch_cd%TYPE) RETURN giacr502_dtld_table pipelined
   IS
     CURSOR a
     IS
     SELECT c.branch_name, 
            get_gl_acct_no(a.gl_acct_id) gl_no, 
            b.gl_acct_name,
            sum(decode(sign(beg_debit_bal-beg_credit_bal),1,(beg_debit_bal-beg_credit_bal),0)) beg_debit,
            sum(abs(decode(sign(beg_debit_bal-beg_credit_bal),-1,(beg_debit_bal-beg_credit_bal),0))) beg_credit,
            sum(a.debit) trans_debit, 
            sum(a.credit) trans_credit,
            sum(decode(sign(a.trans_balance),1, a.trans_balance,0)) end_debit,
            sum(abs(decode(sign(a.trans_balance),-1, a.trans_balance,0))) end_credit,
            sum(a.trans_balance) balance
       FROM giac_trial_balance_summary a, giac_chart_of_accts b, giac_branches c
      WHERE a.gl_acct_id = b.gl_acct_id
        AND a.branch_cd  = c.branch_cd
        AND a.user_id    = USER
        AND a.branch_cd  = NVL(p_branch_cd, a.branch_cd) 
      GROUP BY c.branch_name,  get_gl_acct_no(a.gl_acct_id), b.gl_acct_name
      ORDER BY c.branch_name, gl_no;
 
     v_rec giacr502_dtld_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.branch_name  := nvl(i.branch_name,0);
         v_rec.gl_acct_no   := nvl(i.gl_no,0);
         v_rec.acct_name    := nvl(i.gl_acct_name,0);
         v_rec.beg_debit    := nvl(i.beg_debit,0);
         v_rec.beg_credit   := nvl(i.beg_credit,0);
         v_rec.trans_debit  := nvl(i.trans_debit,0);
         v_rec.trans_credit := nvl(i.trans_credit,0);
         v_rec.end_debit    := nvl(i.end_debit,0);
         v_rec.end_credit   := nvl(i.end_credit,0);
         v_rec.balance      := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION giacr502ae(p_branch_cd giac_finance_yr.branch_cd%TYPE, 
                       p_tran_year giac_finance_yr.tran_year%TYPE,
                       p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_adj_table pipelined
   IS
    
     CURSOR a
     IS
     SELECT a.gl_acct_id, 
            a.branch_cd,
            c.branch_name,
            get_gl_acct_no(a.gl_acct_id) gl_no, 
            b.gl_acct_name, 
            sum(decode(sign(a.beg_debit_amt-a.beg_credit_amt), 1,  (a.beg_debit_amt-a.beg_credit_amt), 0)) beg_debit, 
            sum(abs(decode(sign(a.beg_debit_amt-a.beg_credit_amt), -1, (a.beg_debit_amt-a.beg_credit_amt), 0))) beg_credit, 
            sum(a.trans_debit_bal) trans_debit, 
            sum(a.trans_credit_bal) trans_credit,
            nvl(trial_balance.get_debit_adjusting(a.gl_acct_id,a.branch_cd,p_tran_year,p_tran_mm),0) adjusting_debit,
            nvl(trial_balance.get_credit_adjusting(a.gl_acct_id,a.branch_cd,p_tran_year,p_tran_mm),0) adjusting_credit,
            sum(decode(sign(a.trans_balance),1, a.trans_balance,0)) end_debit,    
            sum(abs(decode(sign(a.trans_balance),-1, a.trans_balance,0))) end_credit
       FROM giac_finance_yr a, giac_chart_of_accts b, giac_branches c
      WHERE a.gl_acct_id = b.gl_acct_id
        AND a.branch_cd  = c.branch_cd
        AND tran_year    = p_tran_year 
        AND tran_mm      = p_tran_mm
        AND a.branch_cd = NVL(p_branch_cd, a.branch_cd)
      GROUP BY a.gl_acct_id, a.branch_cd, c.branch_name, get_gl_acct_no(a.gl_acct_id), b.gl_acct_name
      ORDER BY a.branch_cd, get_gl_acct_no(a.gl_acct_id), b.gl_acct_name;
 
     v_rec giacr502_adj_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.unadjusted_debit  := (i.beg_debit  + (i.trans_debit  - i.adjusting_debit )) - 
                                    (i.beg_credit + (i.trans_credit - i.adjusting_credit)); 
         
         IF v_rec.unadjusted_debit >= 0 THEN
           v_rec.unadjusted_credit := 0;
         ELSIF v_rec.unadjusted_debit < 0 THEN
           v_rec.unadjusted_credit := abs(v_rec.unadjusted_debit);
           v_rec.unadjusted_debit  := 0;
         END IF;
         
         v_rec.branch_name       := nvl(i.branch_name,0);
         v_rec.gl_acct_no        := nvl(i.gl_no,0);
         v_rec.acct_name         := nvl(i.gl_acct_name,0);
         v_rec.beg_debit         := nvl(i.beg_debit,0);
         v_rec.beg_credit        := nvl(i.beg_credit,0);
         v_rec.trans_debit       := nvl(i.trans_debit,0);
         v_rec.trans_credit      := nvl(i.trans_credit,0);
         v_rec.adjusted_debit    := nvl(i.adjusting_debit,0);
         v_rec.adjusted_credit   := nvl(i.adjusting_credit,0);
         v_rec.end_debit         := nvl(i.end_debit,0);
         v_rec.end_credit        := nvl(i.end_credit,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION giacr502ae_cnsldtd(p_tran_year giac_finance_yr.tran_year%TYPE,
                               p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_cnsldtd_adj_table pipelined
   IS
     CURSOR a
     IS
     SELECT b.gl_acct_id,
            get_gl_acct_no(a.gl_acct_id) gl_no, 
            b.gl_acct_name,
            sum(decode(sign(a.beg_debit_amt-a.beg_credit_amt), 1,  (a.beg_debit_amt-a.beg_credit_amt), 0)) beg_debit,
            sum(abs(decode(sign(a.beg_debit_amt-a.beg_credit_amt), -1, (a.beg_debit_amt-a.beg_credit_amt), 0))) beg_credit,
            sum(a.trans_debit_bal) trans_debit,
            sum(a.trans_credit_bal) trans_credit,
            nvl(trial_balance.get_debit_adjusting(a.gl_acct_id,NULL,p_tran_year,p_tran_mm),0) adjusting_debit,
            nvl(trial_balance.get_credit_adjusting(a.gl_acct_id,NULL,p_tran_year,p_tran_mm),0) adjusting_credit,
            sum(decode(sign(a.trans_balance),1, a.trans_balance,0)) end_debit,
            sum(abs(decode(sign(a.trans_balance),-1, a.trans_balance,0))) end_credit
       FROM giac_finance_yr a, giac_chart_of_accts b
      WHERE a.gl_acct_id = b.gl_acct_id
        AND tran_year    = p_tran_year
        AND tran_mm      = p_tran_mm
      GROUP BY b.gl_acct_id,get_gl_acct_no(a.gl_acct_id), b.gl_acct_name,
               nvl(trial_balance.get_debit_adjusting(a.gl_acct_id,NULL,p_tran_year,p_tran_mm),0),
               nvl(trial_balance.get_credit_adjusting(a.gl_acct_id,NULL,p_tran_year,p_tran_mm),0)
      ORDER BY Get_Gl_Acct_No(a.gl_acct_id), b.gl_acct_name;
 
     v_rec giacr502_cnsldtd_adj_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.unadjusted_debit  := (i.beg_debit  + (i.trans_debit  - i.adjusting_debit )) - 
                                    (i.beg_credit + (i.trans_credit - i.adjusting_credit)); 
         
         IF v_rec.unadjusted_debit >= 0 THEN
           v_rec.unadjusted_credit := 0;
         ELSIF v_rec.unadjusted_debit < 0 THEN
           v_rec.unadjusted_credit := abs(v_rec.unadjusted_debit);
           v_rec.unadjusted_debit  := 0;
         END IF;
         
         v_rec.gl_acct_no        := nvl(i.gl_no,0);
         v_rec.acct_name         := nvl(i.gl_acct_name,0);
         v_rec.beg_debit         := nvl(i.beg_debit,0);
         v_rec.beg_credit        := nvl(i.beg_credit,0);
         v_rec.trans_debit       := nvl(i.trans_debit,0);
         v_rec.trans_credit      := nvl(i.trans_credit,0);
         v_rec.adjusted_debit    := nvl(i.adjusting_debit,0);
         v_rec.adjusted_credit   := nvl(i.adjusting_credit,0);
         v_rec.end_debit         := nvl(i.end_debit,0);
         v_rec.end_credit        := nvl(i.end_credit,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION csv_giacr502(p_branch_cd giac_finance_yr.branch_cd%TYPE,
                     p_tran_yr giac_finance_yr.tran_year%TYPE,
                     p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_table pipelined
   IS
     CURSOR a
     IS
     SELECT gb.branch_name,
            get_gl_acct_no(gfy.gl_acct_id) gl_no,
            gca.gl_acct_name,
            DECODE(SIGN(gfy.trans_balance),-1,0,1,ABS(gfy.trans_balance),0) debit,
            DECODE(SIGN(gfy.trans_balance),-1,ABS(gfy.trans_balance),1,0,0) credit,
            gfy.trans_balance balance
       FROM giac_finance_yr gfy, giac_chart_of_accts gca, giac_branches gb
      WHERE gfy.gl_acct_id = gca.gl_acct_id
        AND gfy.branch_cd  = gb.branch_cd
        AND gfy.tran_year  = p_tran_yr
        AND gfy.tran_mm    = p_tran_mm
        AND gfy.branch_cd  = NVL(p_branch_cd, gfy.branch_cd)
      ORDER BY gfy.fund_cd, gfy.branch_cd, get_gl_acct_no(gfy.gl_acct_id), gca.gl_acct_name;
 
     v_rec giacr502_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.branch_name := nvl(i.branch_name,0);
         v_rec.gl_acct_no  := nvl(i.gl_no,0);
         v_rec.acct_name   := nvl(i.gl_acct_name,0);
         v_rec.debit       := nvl(i.debit,0);
         v_rec.credit      := nvl(i.credit,0);
         v_rec.balance     := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;

   FUNCTION csv_giacr502a(p_tran_yr giac_finance_yr.tran_year%TYPE,
                      p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_consolidated_table pipelined
   IS
     CURSOR a
     IS
     SELECT get_gl_acct_no(gfy.gl_acct_id) gl_no,
            gca.gl_acct_name,
            sum(decode(sign(gfy.trans_balance),1, gfy.trans_balance,0)) debit,
            sum(abs(decode(sign(gfy.trans_balance),-1, gfy.trans_balance,0))) credit,
            sum(gfy.trans_balance) balance
       FROM giac_finance_yr gfy, giac_chart_of_accts gca 
      WHERE gfy.gl_acct_id = gca.gl_acct_id
        AND gfy.tran_year  = p_tran_yr
        AND gfy.tran_mm    = p_tran_mm
      GROUP BY get_gl_acct_no(gfy.gl_acct_id), gca.gl_acct_name
      ORDER BY get_gl_acct_no(gfy.gl_acct_id), gca.gl_acct_name;
 
     v_rec giacr502_consolidated_record;
     
   BEGIN
       FOR i IN a
       LOOP
         v_rec.gl_acct_no := nvl(i.gl_no,0);
         v_rec.acct_name  := nvl(i.gl_acct_name,0);
         v_rec.debit      := nvl(i.debit,0);
         v_rec.credit     := nvl(i.credit,0);
         v_rec.balance    := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;

   FUNCTION csv_giacr502b RETURN giacr502_consolidated_table PIPELINED
   IS
     CURSOR a
     IS
     SELECT get_gl_acct_no(a.gl_acct_id) gl_no,
            b.gl_acct_name,
            a.gl_acct_id,
            sum(decode(sign(trans_balance),1, trans_balance,0)) debit,
            sum(abs(decode(sign(trans_balance),-1, trans_balance,0))) credit,
            sum(trans_balance) balance
       FROM giac_trial_balance_summary a, giac_chart_of_accts b
      WHERE a.gl_acct_id = b.gl_acct_id
      GROUP BY b.gl_acct_name, a.gl_acct_id, get_gl_acct_no(a.gl_acct_id)
      ORDER BY gl_no;
 
     v_rec giacr502_consolidated_record;
     
   BEGIN
       FOR i IN a
       LOOP
         v_rec.gl_acct_no := nvl(i.gl_no,0);
         v_rec.acct_name  := nvl(i.gl_acct_name,0);
         v_rec.debit      := nvl(i.debit,0);
         v_rec.credit     := nvl(i.credit,0);
         v_rec.balance    := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION csv_giacr502c(p_branch_cd GIAC_TRIAL_BALANCE_SUMMARY.branch_cd%TYPE) RETURN giacr502_table pipelined
   IS
     CURSOR a
     IS
     SELECT c.BRANCH_name,
            get_gl_acct_no(a.gl_acct_id) gl_no,
            b.gl_acct_name,
            SUM(DECODE(SIGN(trans_balance),1, trans_balance,0)) debit,
            SUM(ABS(DECODE(SIGN(trans_balance),-1, trans_balance,0))) credit,
            SUM(trans_balance) balance
       FROM GIAC_TRIAL_BALANCE_SUMMARY a, GIAC_CHART_OF_ACCTS b, giac_branches c
      WHERE /*a.user_id    = USER
        AND */a.gl_acct_id = b.gl_acct_id
        AND a.branch_cd  = c.branch_cd
        AND a.BRANCH_CD  = NVL(p_branch_cd, a.BRANCH_CD)
      GROUP BY a.FUND_CD, c.BRANCH_name, b.gl_acct_name, a.gl_acct_id, get_gl_acct_no(a.gl_acct_id)
      ORDER BY c.branch_name, gl_no;
 
     v_rec giacr502_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.branch_name := nvl(i.branch_name,0);
         v_rec.gl_acct_no  := nvl(i.gl_no,0);
         v_rec.acct_name   := nvl(i.gl_acct_name,0);
         v_rec.debit       := nvl(i.debit,0);
         v_rec.credit      := nvl(i.credit,0);
         v_rec.balance     := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION csv_giacr502d(p_tran_yr giac_finance_yr.tran_year%TYPE,
                      p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502d_table pipelined
   IS
     CURSOR a
     IS
     SELECT get_gl_acct_no(a.gl_acct_id) gl_no,
            b.gl_acct_name, 
            sum(decode(sign(a.beg_debit_amt-a.beg_credit_amt), 1,  (a.beg_debit_amt-a.beg_credit_amt), 0)) beg_debit,
            sum(abs(decode(sign(a.beg_debit_amt-a.beg_credit_amt), -1, (a.beg_debit_amt-a.beg_credit_amt), 0))) beg_credit,
            sum(a.trans_debit_bal) trans_debit, 
            sum(a.trans_credit_bal) trans_credit,
            sum(decode(sign(a.trans_balance),1, a.trans_balance,0)) end_debit,
            sum(abs(decode(sign(a.trans_balance),-1, a.trans_balance,0))) end_credit,
            sum(a.trans_balance) balance
       FROM giac_finance_yr a, giac_chart_of_accts b
      WHERE a.gl_acct_id = b.gl_acct_id
        AND tran_year    = p_tran_yr
        AND tran_mm      = p_tran_mm
      GROUP BY get_gl_acct_no(a.gl_acct_id), b.gl_acct_name
      ORDER BY Get_Gl_Acct_No(a.gl_acct_id), b.gl_acct_name;
 
     v_rec giacr502d_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.gl_acct_no   := nvl(i.gl_no,0);
         v_rec.acct_name    := nvl(i.gl_acct_name,0);
         v_rec.beg_debit    := nvl(i.beg_debit,0);
         v_rec.beg_credit   := nvl(i.beg_credit,0);
         v_rec.trans_debit  := nvl(i.trans_debit,0);
         v_rec.trans_credit := nvl(i.trans_credit,0);
         v_rec.end_debit    := nvl(i.end_debit,0);
         v_rec.end_credit   := nvl(i.end_credit,0);
         --v_rec.balance      := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION csv_giacr502e(p_branch_cd giac_finance_yr.branch_cd%TYPE,
                      p_tran_yr giac_finance_yr.tran_year%TYPE,
                      p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_dtld_table pipelined
   IS
     CURSOR a
     IS
     SELECT c.branch_name,
            get_gl_acct_no(a.gl_acct_id) gl_no,
            b.gl_acct_name,
            sum(decode(sign(a.beg_debit_amt-a.beg_credit_amt), 1,  (a.beg_debit_amt-a.beg_credit_amt), 0)) beg_debit, 
            sum(abs(decode(sign(a.beg_debit_amt-a.beg_credit_amt), -1, (a.beg_debit_amt-a.beg_credit_amt), 0))) beg_credit, 
            sum(a.trans_debit_bal) trans_debit, 
            sum(a.trans_credit_bal) trans_credit,
            sum(decode(sign(a.trans_balance),1, a.trans_balance,0)) end_debit,    
            sum(abs(decode(sign(a.trans_balance),-1, a.trans_balance,0))) end_credit,
            sum(a.trans_balance) balance  
       FROM giac_finance_yr a, giac_chart_of_accts b, giac_branches c
      WHERE a.gl_acct_id = b.gl_acct_id
        AND a.branch_cd  = c.branch_cd
        AND tran_year    = p_tran_yr 
        AND tran_mm      = p_tran_mm
        AND c.branch_cd  = NVL(p_branch_cd, a.branch_cd)
      GROUP BY c.branch_name, get_gl_acct_no(a.gl_acct_id), b.gl_acct_name
      order by c.branch_name, gl_no;
 
     v_rec giacr502_dtld_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.branch_name  := nvl(i.branch_name,0);
         v_rec.gl_acct_no   := nvl(i.gl_no,0);
         v_rec.acct_name    := nvl(i.gl_acct_name,0);
         v_rec.beg_debit    := nvl(i.beg_debit,0);
         v_rec.beg_credit   := nvl(i.beg_credit,0);
         v_rec.trans_debit  := nvl(i.trans_debit,0);
         v_rec.trans_credit := nvl(i.trans_credit,0);
         v_rec.end_debit    := nvl(i.end_debit,0);
         v_rec.end_credit   := nvl(i.end_credit,0);
         v_rec.balance      := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION csv_giacr502f RETURN giacr502_cnsldtd_dtld_table pipelined
   IS
     CURSOR a
     IS
     SELECT get_gl_acct_no(a.gl_acct_id) gl_no,
            b.gl_acct_name,
            sum(decode(sign(beg_debit_bal-beg_credit_bal), 1, (beg_debit_bal-beg_credit_bal) , 0)) beg_debit,
            sum(abs(decode(sign(beg_debit_bal-beg_credit_bal),-1,(beg_debit_bal-beg_credit_bal),0))) beg_credit,
            sum(a.debit) trans_debit, 
            sum(a.credit) trans_credit,
            sum(decode(sign(a.trans_balance),1, a.trans_balance,0)) end_debit,
            sum(abs(decode(sign(a.trans_balance),-1, a.trans_balance,0))) end_credit,
            sum(a.trans_balance) balance
       FROM giac_trial_balance_summary a, giac_chart_of_accts b
      WHERE a.gl_acct_id = b.gl_acct_id
        --AND a.user_id    = USER
      GROUP BY get_gl_acct_no(a.gl_acct_id), b.gl_acct_name
      ORDER BY get_gl_acct_no(a.gl_acct_id);
 
     v_rec giacr502_cnsldtd_dtld_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.gl_acct_no   := nvl(i.gl_no,0);
         v_rec.acct_name    := nvl(i.gl_acct_name,0);
         v_rec.beg_debit    := nvl(i.beg_debit,0);
         v_rec.beg_credit   := nvl(i.beg_credit,0);
         v_rec.trans_debit  := nvl(i.trans_debit,0);
         v_rec.trans_credit := nvl(i.trans_credit,0);
         v_rec.end_debit    := nvl(i.end_debit,0);
         v_rec.end_credit   := nvl(i.end_credit,0);
         v_rec.balance      := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION csv_giacr502g(p_branch_cd giac_trial_balance_summary.branch_cd%TYPE) RETURN giacr502_dtld_table pipelined
   IS
     CURSOR a
     IS
     SELECT c.branch_name, 
            get_gl_acct_no(a.gl_acct_id) gl_no, 
            b.gl_acct_name,
            sum(decode(sign(beg_debit_bal-beg_credit_bal),1,(beg_debit_bal-beg_credit_bal),0)) beg_debit,
            sum(abs(decode(sign(beg_debit_bal-beg_credit_bal),-1,(beg_debit_bal-beg_credit_bal),0))) beg_credit,
            sum(a.debit) trans_debit, 
            sum(a.credit) trans_credit,
            sum(decode(sign(a.trans_balance),1, a.trans_balance,0)) end_debit,
            sum(abs(decode(sign(a.trans_balance),-1, a.trans_balance,0))) end_credit,
            sum(a.trans_balance) balance
       FROM giac_trial_balance_summary a, giac_chart_of_accts b, giac_branches c
      WHERE a.gl_acct_id = b.gl_acct_id
        AND a.branch_cd  = c.branch_cd
        --AND a.user_id    = USER
        AND a.branch_cd  = NVL(p_branch_cd, a.branch_cd) 
      GROUP BY c.branch_name,  get_gl_acct_no(a.gl_acct_id), b.gl_acct_name
      ORDER BY c.branch_name, gl_no;
 
     v_rec giacr502_dtld_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.branch_name  := nvl(i.branch_name,0);
         v_rec.gl_acct_no   := nvl(i.gl_no,0);
         v_rec.acct_name    := nvl(i.gl_acct_name,0);
         v_rec.beg_debit    := nvl(i.beg_debit,0);
         v_rec.beg_credit   := nvl(i.beg_credit,0);
         v_rec.trans_debit  := nvl(i.trans_debit,0);
         v_rec.trans_credit := nvl(i.trans_credit,0);
         v_rec.end_debit    := nvl(i.end_debit,0);
         v_rec.end_credit   := nvl(i.end_credit,0);
         v_rec.balance      := nvl(i.balance,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   
   FUNCTION csv_giacr502ae(p_branch_cd giac_finance_yr.branch_cd%TYPE,
                       p_tran_yr giac_finance_yr.tran_year%TYPE,
                       p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_adj_table pipelined
   IS
      v_posting_dt  GIAC_ACCTRANS.posting_date%TYPE := LAST_DAY(TO_DATE(p_tran_mm||'/'||p_tran_yr,'MM/RRRR'));--Added by pjsantos 12/02/2016, for optimization GENQA 5870
     /*Modified by pjsantos 12/08/2016, for optimization GENQA 5870*/
     CURSOR a
     IS
     SELECT a.gl_acct_id, 
            a.branch_cd,
            c.branch_name,
            get_gl_acct_no(a.gl_acct_id) gl_no, 
            b.gl_acct_name, 
            sum(decode(sign(a.beg_debit_amt-a.beg_credit_amt), 1,  (a.beg_debit_amt-a.beg_credit_amt), 0)) beg_debit, 
            sum(abs(decode(sign(a.beg_debit_amt-a.beg_credit_amt), -1, (a.beg_debit_amt-a.beg_credit_amt), 0))) beg_credit, 
            sum(a.trans_debit_bal) trans_debit, 
            sum(a.trans_credit_bal) trans_credit,
            /*nvl(trial_balance.get_debit_adjusting(a.gl_acct_id,a.branch_cd,p_tran_yr,p_tran_mm),0) adjusting_debit,
            nvl(trial_balance.get_credit_adjusting(a.gl_acct_id,a.branch_cd,p_tran_yr,p_tran_mm),0) adjusting_credit,*/
            sum(decode(sign(a.trans_balance),1, a.trans_balance,0)) end_debit,    
            sum(abs(decode(sign(a.trans_balance),-1, a.trans_balance,0))) end_credit,
             d.debit_amt, d.credit_amt         
       FROM giac_finance_yr a, giac_chart_of_accts b, giac_branches c, 
       (SELECT SUM(debit_amt) debit_amt,  SUM(credit_amt) credit_amt, y.gl_acct_id, x.gibr_branch_cd
                             FROM GIAC_ACCTRANS x,
                                  GIAC_ACCT_ENTRIES y
                            WHERE x.tran_id         = y.gacc_tran_id
                              AND ae_tag            = 'Y'
                              AND x.posting_date    = v_posting_dt
                         GROUP BY y.gl_acct_id, x.gibr_branch_cd) d 
      WHERE a.gl_acct_id = b.gl_acct_id
        AND a.branch_cd  = c.branch_cd
        AND tran_year    = p_tran_yr 
        AND tran_mm      = p_tran_mm
        AND a.branch_cd = NVL(p_branch_cd, a.branch_cd)
        AND a.gl_acct_id = d.gl_acct_id(+)
        AND a.branch_cd = d.gibr_branch_cd(+)
      GROUP BY a.gl_acct_id, a.branch_cd, c.branch_name, get_gl_acct_no(a.gl_acct_id), b.gl_acct_name, d.debit_amt, d.credit_amt
      ORDER BY a.branch_cd, get_gl_acct_no(a.gl_acct_id), b.gl_acct_name;
 
     v_rec giacr502_adj_record;
     
   BEGIN
     FOR i IN a
       LOOP 
         v_rec.unadjusted_debit  := (NVL(i.beg_debit,0)  + (NVL(i.trans_debit,0)  - NVL(i./*adjusting_*/debit_amt,0) )) - 
                                    (NVL(i.beg_credit,0) + (NVL(i.trans_credit,0) - NVL(i./*adjusting_*/credit_amt,0))); 
         
         IF v_rec.unadjusted_debit >= 0 THEN
           v_rec.unadjusted_credit := 0;
         ELSIF v_rec.unadjusted_debit < 0 THEN
           v_rec.unadjusted_credit := abs(v_rec.unadjusted_debit);
           v_rec.unadjusted_debit  := 0;
         END IF;
         
         v_rec.branch_name       := nvl(i.branch_name,0);
         v_rec.gl_acct_no        := nvl(i.gl_no,0);
         v_rec.acct_name         := nvl(i.gl_acct_name,0);
         v_rec.beg_debit         := nvl(i.beg_debit,0);
         v_rec.beg_credit        := nvl(i.beg_credit,0);
         v_rec.trans_debit       := nvl(i.trans_debit,0) - NVL(i.debit_amt,0);
         v_rec.trans_credit      := nvl(i.trans_credit,0) - NVL(i.credit_amt,0);
         v_rec.adjusted_debit    := nvl(i./*adjusting_*/debit_amt,0);
         v_rec.adjusted_credit   := nvl(i./*adjusting_*/credit_amt,0);
         v_rec.end_debit         := nvl(i.end_debit,0);
         v_rec.end_credit        := nvl(i.end_credit,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
       --pjsantos end
   END;
   
   FUNCTION csv_giacr502ae_cnsldtd(p_tran_year giac_finance_yr.tran_year%TYPE,
                               p_tran_mm   giac_finance_yr.tran_mm%TYPE   ) RETURN giacr502_cnsldtd_adj_table pipelined 
   IS
     v_posting_dt  GIAC_ACCTRANS.posting_date%TYPE := LAST_DAY(TO_DATE(p_tran_mm||'/'||p_tran_year,'MM/RRRR'));--Added by pjsantos 12/02/2016, for optimization GENQA 5870
     /*Modified by pjsantos 12/08/2016, for optimization GENQA 5870*/
     CURSOR a
     IS
     SELECT b.gl_acct_id,
            get_gl_acct_no(a.gl_acct_id) gl_no, 
            b.gl_acct_name,
            sum(decode(sign(a.beg_debit_amt-a.beg_credit_amt), 1,  (a.beg_debit_amt-a.beg_credit_amt), 0)) beg_debit,
            sum(abs(decode(sign(a.beg_debit_amt-a.beg_credit_amt), -1, (a.beg_debit_amt-a.beg_credit_amt), 0))) beg_credit,
            sum(a.trans_debit_bal) trans_debit,
            sum(a.trans_credit_bal) trans_credit,
            /*nvl(trial_balance.get_debit_adjusting(a.gl_acct_id,NULL,p_tran_year,p_tran_mm),0) adjusting_debit,
            nvl(trial_balance.get_credit_adjusting(a.gl_acct_id,NULL,p_tran_year,p_tran_mm),0) adjusting_credit,*/ 
            sum(decode(sign(a.trans_balance),1, a.trans_balance,0)) end_debit, 
            sum(abs(decode(sign(a.trans_balance),-1, a.trans_balance,0))) end_credit, c.debit_amt, c.credit_amt 
       FROM giac_finance_yr a, giac_chart_of_accts b, 
                         (SELECT SUM(debit_amt) debit_amt,  SUM(credit_amt) credit_amt, y.gl_acct_id
                             FROM GIAC_ACCTRANS x,
                                  GIAC_ACCT_ENTRIES y
                            WHERE x.tran_id         = y.gacc_tran_id
                              AND ae_tag            = 'Y'
                              AND x.posting_date    = v_posting_dt
                         GROUP BY y.gl_acct_id) c                                
      WHERE a.gl_acct_id = b.gl_acct_id
        AND tran_year    = p_tran_year
        AND tran_mm      = p_tran_mm
        AND b.gl_acct_id = c.gl_acct_id(+)
      GROUP BY b.gl_acct_id,get_gl_acct_no(a.gl_acct_id), b.gl_acct_name,c.credit_amt, c.debit_amt 
               /*nvl(trial_balance.get_debit_adjusting(a.gl_acct_id,NULL,p_tran_year,p_tran_mm),0),
               nvl(trial_balance.get_credit_adjusting(a.gl_acct_id,NULL,p_tran_year,p_tran_mm),0)*/
      ORDER BY Get_Gl_Acct_No(a.gl_acct_id), b.gl_acct_name;
 
     v_rec giacr502_cnsldtd_adj_record;
     
   BEGIN
     FOR i IN a
       LOOP
         v_rec.unadjusted_debit  := (NVL(i.beg_debit,0)  + (NVL(i.trans_debit,0)  - NVL(i./*adjusting_*/debit_amt,0) )) -
                                    (NVL(i.beg_credit,0) + (NVL(i.trans_credit,0) - NVL(i./*adjusting_*/credit_amt,0))); 
         IF v_rec.unadjusted_debit >= 0 THEN
           v_rec.unadjusted_credit := 0;
         ELSIF v_rec.unadjusted_debit < 0 THEN
           v_rec.unadjusted_credit := abs(v_rec.unadjusted_debit);
           v_rec.unadjusted_debit  := 0;
         END IF;
         
         v_rec.gl_acct_no        := nvl(i.gl_no,0);
         v_rec.acct_name         := nvl(i.gl_acct_name,0);
         v_rec.beg_debit         := nvl(i.beg_debit,0);
         v_rec.beg_credit        := nvl(i.beg_credit,0);
         v_rec.trans_debit       := nvl(i.trans_debit,0)- NVL(i.debit_amt,0);
         v_rec.trans_credit      := nvl(i.trans_credit,0)- NVL(i.credit_amt,0);
         v_rec.adjusted_debit    := nvl(i./*adjusting_*/debit_amt,0);
         v_rec.adjusted_credit   := nvl(i./*adjusting_*/credit_amt,0);
         v_rec.end_debit         := nvl(i.end_debit,0);
         v_rec.end_credit        := nvl(i.end_credit,0);
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
  /*pjsantos end*/ 
END;
/


