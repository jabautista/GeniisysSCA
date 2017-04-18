CREATE OR REPLACE PACKAGE BODY CPI.Csv_Monthly_Tb AS
   FUNCTION con_branches(p_tran_year GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                         p_tran_mm GIAC_MONTHLY_TOTALS.tran_mm%TYPE)
                                    RETURN con_br_typ_rep pipelined
   IS
     CURSOR con_branch
     IS
     SELECT DECODE(INSTR(a.gl_acct_no_formatted,'-',1),2,'0'||
                        SUBSTR(a.gl_acct_no_formatted,1,1),SUBSTR(a.gl_acct_no_formatted,1,2)) TEST1,
                      DECODE(INSTR(a.gl_acct_no_formatted,'-',1,2) - INSTR(a.gl_acct_no_formatted,'-',1),2,'0'
                        ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,2) -1 ,1),
                        SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,2) -2 ,2)) TEST2,
                      DECODE (DECODE(INSTR(a.gl_acct_no_formatted,'-',1),2,'0'||
                        SUBSTR(a.gl_acct_no_formatted,1,1),SUBSTR(a.gl_acct_no_formatted,1,2)) ,'04',
                      DECODE(INSTR(a.gl_acct_no_formatted,'-',1,3)  - INSTR(a.gl_acct_no_formatted,'-',1,2),2,'0'
                        ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,3) -1 ,1),
                        SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,3) -2 ,2)),
                      DECODE(INSTR(a.gl_acct_no_formatted,'-',1,2) - INSTR(a.gl_acct_no_formatted,'-',1),2,'0'
                        ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,2) -1 ,1),
                        SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,2) -2 ,2)) ) TEST3,
                      a.gl_acct_no_formatted gl_acct_no,
                      a.gl_acct_name,
                      a.tran_year YEAR,
                      a.tran_mm MONTH,
                      SUM(a.trans_debit_bal) DEBIT,
                      SUM(a.trans_credit_bal) CREDIT
                   FROM  giac_trial_balance_v a
                     WHERE a.tran_year = p_tran_year
                       AND a.tran_mm   = p_tran_mm
                            GROUP BY DECODE(INSTR(a.gl_acct_no_formatted,'-',1),2,'0'||
                                       SUBSTR(a.gl_acct_no_formatted,1,1),SUBSTR(a.gl_acct_no_formatted,1,2))                 ,
                                     DECODE(INSTR(a.gl_acct_no_formatted,'-',1,2) - INSTR(a.gl_acct_no_formatted,'-',1),2,'0'
                                       ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,2) -1 ,1),
                                        SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,2) -2 ,2))           ,
                                     DECODE (DECODE(INSTR(a.gl_acct_no_formatted,'-',1),2,'0'||
                                       SUBSTR(a.gl_acct_no_formatted,1,1),SUBSTR(a.gl_acct_no_formatted,1,2)) ,'04',
                                     DECODE(INSTR(a.gl_acct_no_formatted,'-',1,3)  - INSTR(a.gl_acct_no_formatted,'-',1,2),2,'0'
                                       ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,3) -1 ,1),
                                       SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,3) -2 ,2)) ) ,
                                     a.gl_acct_no_formatted, 
                                     a.gl_acct_name,
                                     a.tran_year,
                                     a.tran_mm
                                ORDER BY a.gl_acct_no_formatted;
     v_rec con_br_typ_rec;
   BEGIN
       FOR i IN con_branch
       LOOP
         v_rec.gl_acct_no   := i.gl_acct_no;
         v_rec.acct_name    := i.gl_acct_name;
         v_rec.YEAR         := i.YEAR;
         v_rec.MONTH        := i.MONTH;
         v_rec.debit        := i.debit;
         v_rec.credit       := i.credit;
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END;
   FUNCTION con_branches_w_sum (p_user_id GIIS_USERS.user_id%TYPE) RETURN con_br_typ_rep_w_sum PIPELINED --modified by Daniel Marasigan SR 22768
   IS
   CURSOR con_branch_w_sum
   IS
   SELECT b.gl_acct_name, 
               a.gl_acct_id, 
               Get_Gl_Acct_No(a.gl_acct_id) gl_acct_no, 
               SUM(debit)  debit,
               SUM(credit) credit
          FROM GIAC_TRIAL_BALANCE_SUMMARY a, GIAC_CHART_OF_ACCTS b
          WHERE a.user_id = p_user_id 		--modified by Daniel Marasigan SR 22768
            AND a.gl_acct_id = b.gl_acct_id
                GROUP BY b.gl_acct_name, a.gl_acct_id, Get_Gl_Acct_No(a.gl_acct_id)
                ORDER BY 3;
   v_rec_sum con_br_typ_rec_w_sum;
   BEGIN  
     FOR i IN con_branch_w_sum
     LOOP
       v_rec_sum.gl_acct_no := i.gl_acct_no;
       v_rec_sum.acct_name  := i.gl_acct_name;
       v_rec_sum.debit      := i.debit;
       v_rec_sum.credit     := i.credit;
       PIPE ROW(v_rec_sum);
     END LOOP;
     RETURN;
   END;
   FUNCTION break_by_branch(p_tran_year GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                            p_tran_mm GIAC_MONTHLY_TOTALS.tran_mm%TYPE) RETURN break_by_br_rep PIPELINED
   IS
   CURSOR break_by_branches
   IS
   SELECT DECODE(INSTR(a.gl_acct_no_formatted,'-',1),2,'0'||
            SUBSTR(a.gl_acct_no_formatted,1,1),SUBSTR(a.gl_acct_no_formatted,1,2)) TEST1,
             DECODE(INSTR(a.gl_acct_no_formatted,'-',1,2) - INSTR(a.gl_acct_no_formatted,'-',1),2,'0'
            ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,2) -1 ,1),
            SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,2) -2 ,2)) TEST2,
          DECODE (DECODE(INSTR(a.gl_acct_no_formatted,'-',1),2,'0'||
            SUBSTR(a.gl_acct_no_formatted,1,1),SUBSTR(a.gl_acct_no_formatted,1,2)) ,'04',
          DECODE(INSTR(a.gl_acct_no_formatted,'-',1,3)  - INSTR(a.gl_acct_no_formatted,'-',1,2),2,'0'
            ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,3) -1 ,1),
            SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,3) -2 ,2)),
          DECODE(INSTR(a.gl_acct_no_formatted,'-',1,2) - INSTR(a.gl_acct_no_formatted,'-',1),2,'0'
            ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,2) -1 ,1),
            SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,2) -2 ,2)) ) TEST3,
          a.branch_cd, 
          a.branch_name,
          a.gl_acct_no_formatted, 
          a.gl_acct_name,
          gl_acct_category, 
          gl_control_acct,
          DECODE (gl_sub_acct_1,0, 0,DECODE (gl_sub_acct_2, 0, gl_control_acct, gl_sub_acct_1)) gl_sub_acct_1,
          DECODE (gl_sub_acct_2,0, 0,DECODE (gl_sub_acct_3, 0, gl_sub_acct_1, gl_sub_acct_2)) gl_sub_acct_2,
          DECODE (gl_sub_acct_3,0, 0,DECODE (gl_sub_acct_4, 0, gl_sub_acct_2, gl_sub_acct_3)) gl_sub_acct_3,
          DECODE (gl_sub_acct_4,0, 0,DECODE (gl_sub_acct_5, 0, gl_sub_acct_3, gl_sub_acct_4)) gl_sub_acct_4,
          DECODE (gl_sub_acct_5,0, 0,DECODE (gl_sub_acct_6, 0, gl_sub_acct_4, gl_sub_acct_5)) gl_sub_acct_5,
          DECODE (gl_sub_acct_6,0, 0,DECODE (gl_sub_acct_7, 0, gl_sub_acct_5, gl_sub_acct_6)) gl_sub_acct_6,
          DECODE (gl_sub_acct_7, 0, 0, gl_sub_acct_6) gl_sub_acct_7,
          a.tran_year YEAR, 
          a.tran_mm MONTH, 
          SUM (a.trans_debit_bal) debit,
          SUM (a.trans_credit_bal) credit
     FROM giac_trial_balance_v a
       WHERE a.tran_year = p_tran_year 
         AND a.tran_mm = p_tran_mm
         GROUP BY DECODE(INSTR(a.gl_acct_no_formatted,'-',1),2,'0'||
                    SUBSTR(a.gl_acct_no_formatted,1,1),SUBSTR(a.gl_acct_no_formatted,1,2))                 ,
                  DECODE(INSTR(a.gl_acct_no_formatted,'-',1,2) - INSTR(a.gl_acct_no_formatted,'-',1),2,'0'
                    ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,2) -1 ,1),
                    SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,2) -2 ,2))           ,
                  DECODE (DECODE(INSTR(a.gl_acct_no_formatted,'-',1),2,'0'||
                    SUBSTR(a.gl_acct_no_formatted,1,1),SUBSTR(a.gl_acct_no_formatted,1,2)) ,'04',
                  DECODE(INSTR(a.gl_acct_no_formatted,'-',1,3)  - INSTR(a.gl_acct_no_formatted,'-',1,2),2,'0'
                    ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,3) -1 ,1),
                    SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,3) -2 ,2)) ) ,
                  a.branch_name,
                  a.branch_cd,
                  a.gl_acct_no_formatted,
                  a.gl_acct_name,
                  gl_acct_category,
                  gl_control_acct,
                  DECODE (gl_sub_acct_1,0, 0,DECODE (gl_sub_acct_2, 0, gl_control_acct, gl_sub_acct_1)),
                  DECODE (gl_sub_acct_2,0, 0,DECODE (gl_sub_acct_3, 0, gl_sub_acct_1, gl_sub_acct_2)),
                  DECODE (gl_sub_acct_3,0, 0,DECODE (gl_sub_acct_4, 0, gl_sub_acct_2, gl_sub_acct_3)),
                  DECODE (gl_sub_acct_4,0, 0,DECODE (gl_sub_acct_5, 0, gl_sub_acct_3, gl_sub_acct_4)),
                  DECODE (gl_sub_acct_5,0, 0,DECODE (gl_sub_acct_6, 0, gl_sub_acct_4, gl_sub_acct_5)),
                  DECODE (gl_sub_acct_6,0, 0,DECODE (gl_sub_acct_7, 0, gl_sub_acct_5, gl_sub_acct_6)),
                  DECODE (gl_sub_acct_7, 0, 0, gl_sub_acct_6),
                  a.tran_year,
                  a.tran_mm
             ORDER BY branch_name, gl_acct_no_formatted;
    v_break_br break_by_br_rec;
    BEGIN
      FOR i IN break_by_branches
      LOOP
        v_break_br.branch_name := i.branch_name;
        v_break_br.gl_acct_no  := i.gl_acct_no_formatted;
        v_break_br.acct_name   := i.gl_acct_name;
        v_break_br.YEAR        := i.YEAR;
        v_break_br.MONTH       := i.MONTH;
        v_break_br.debit       := i.debit;
        v_break_br.credit      := i.credit;
        PIPE ROW(v_break_br);
      END LOOP;
      RETURN;
    END;
    FUNCTION summary_report(p_user_id GIIS_USERS.user_id%TYPE) RETURN summary_rep PIPELINED --modified by Daniel Marasigan; same issue with SR 22768
    IS
    CURSOR summ
    IS
    SELECT a.fund_cd, 
           a.branch_cd, 
           b.gl_acct_name, 
           a.gl_acct_id, 
           Get_Gl_Acct_No(a.gl_acct_id) gl_no, 
           SUM(debit) debit,
           SUM(credit) credit
      FROM GIAC_TRIAL_BALANCE_SUMMARY a, GIAC_CHART_OF_ACCTS b
        WHERE a.user_id = p_user_id
          AND a.gl_acct_id = b.gl_acct_id
            GROUP BY a.fund_cd,a.branch_cd, b.gl_acct_name, a.gl_acct_id, Get_Gl_Acct_No(a.gl_acct_id)
              ORDER BY branch_cd, 5;
    v_summ summary_rec;
 v_branch_name     GIAC_BRANCHES.branch_name%TYPE;
 v_new_branch      VARCHAR2(3) := 'df1';
 v_current_branch  VARCHAR2(3) := 'df2';
    BEGIN
      FOR i IN summ
      LOOP
     v_new_branch := NVL(i.branch_cd, 'df1');
  IF v_new_branch <> v_current_branch THEN
    BEGIN
      SELECT branch_name
        INTO v_branch_name
       FROM GIAC_BRANCHES
         WHERE branch_cd = v_new_branch;
      v_current_branch := v_new_branch;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
     v_branch_name := NULL;
     v_current_branch := 'df2';
    END;
  END IF; 
  v_summ.branch_name  := v_branch_name;
        v_summ.gl_acct_no   := i.gl_no;
        v_summ.acct_name    := i.gl_acct_name;
        v_summ.debit        := i.debit;
        v_summ.credit       := i.credit;
        PIPE ROW (v_summ);
      END LOOP;
      RETURN;
    END;
    FUNCTION standard_report(p_tran_year GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                             p_tran_mm GIAC_MONTHLY_TOTALS.tran_mm%TYPE) RETURN standard_rep PIPELINED
    IS
    CURSOR std_rep
    IS
    SELECT DECODE(INSTR(a.gl_acct_no_formatted,'-',1),2,'0'||
             SUBSTR(a.gl_acct_no_formatted,1,1),SUBSTR(a.gl_acct_no_formatted,1,2)) TEST1,
           DECODE(INSTR(a.gl_acct_no_formatted,'-',1,2) - INSTR(a.gl_acct_no_formatted,'-',1),2,'0'
             ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,2) -1 ,1),
             SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,2) -2 ,2)) TEST2,
           DECODE (DECODE(INSTR(a.gl_acct_no_formatted,'-',1),2,'0'||
             SUBSTR(a.gl_acct_no_formatted,1,1),SUBSTR(a.gl_acct_no_formatted,1,2)) ,'04',
           DECODE(INSTR(a.gl_acct_no_formatted,'-',1,3)  - INSTR(a.gl_acct_no_formatted,'-',1,2),2,'0'
             ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,3) -1 ,1),
             SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,3) -2 ,2)),
           DECODE(INSTR(a.gl_acct_no_formatted,'-',1,2) - INSTR(a.gl_acct_no_formatted,'-',1),2,'0'
             ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,2) -1 ,1),
             SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,2) -2 ,2)) ) TEST3,
           a.gl_acct_no_formatted,
           a.gl_acct_name,
           a.branch_name,
           a.tran_year YEAR,
           a.tran_mm MONTH,
           SUM(a.trans_debit_bal) DEBIT,
           SUM(a.trans_credit_bal) CREDIT
       FROM  giac_trial_balance_v a
         WHERE a.tran_year = p_tran_year
           AND a.tran_mm   = p_tran_mm
             GROUP BY DECODE(INSTR(a.gl_acct_no_formatted,'-',1),2,'0'||
                        SUBSTR(a.gl_acct_no_formatted,1,1),SUBSTR(a.gl_acct_no_formatted,1,2))                 ,
                      DECODE(INSTR(a.gl_acct_no_formatted,'-',1,2) - INSTR(a.gl_acct_no_formatted,'-',1),2,'0'
                        ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,2) -1 ,1),
                        SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,2) -2 ,2))           ,
                      DECODE (DECODE(INSTR(a.gl_acct_no_formatted,'-',1),2,'0'||
                        SUBSTR(a.gl_acct_no_formatted,1,1),SUBSTR(a.gl_acct_no_formatted,1,2)) ,'04',
                      DECODE(INSTR(a.gl_acct_no_formatted,'-',1,3)  - INSTR(a.gl_acct_no_formatted,'-',1,2),2,'0'
                        ||SUBSTR(a.gl_acct_no_formatted,INSTR(a.gl_acct_no_formatted,'-',1,3) -1 ,1),
                        SUBSTR(a.gl_acct_no_formatted, INSTR(a.gl_acct_no_formatted,'-',1,3) -2 ,2)) ) ,
                      a.gl_acct_no_formatted, 
                      a.gl_acct_name, 
                      a.tran_year,
                      a.tran_mm, 
                      a.branch_name
                 ORDER BY a.gl_acct_no_formatted;
    v_std_rep standard_rec;
    BEGIN
      FOR i IN std_rep
      LOOP
        v_std_rep.branch_name := i.branch_name;
        v_std_rep.gl_acct_no := i.gl_acct_no_formatted;
        v_std_rep.acct_name := i.gl_acct_name;
        v_std_rep.YEAR := i.YEAR;
        v_std_rep.MONTH := i.MONTH;
        v_std_rep.debit := i.debit;
        v_std_rep.credit := i.credit;
        PIPE ROW(v_std_rep);
      END LOOP;
      RETURN;
    END;
    FUNCTION adjusting_entries(p_tran_year GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                               p_tran_mm GIAC_MONTHLY_TOTALS.tran_mm%TYPE,
                               p_branch VARCHAR2) RETURN adj_entries_rep PIPELINED
    IS
    CURSOR adjust_entries
    IS
    SELECT a.branch_cd,  
           a.gl_acct_id,
           gl_acct_no_formatted, 
           gl_acct_name,
           YEAR, 
           MONTH,
           NVL(debit, 0) debit, 
           NVL(credit, 0) credit,
           NVL(adj_debit,0) adj_debit, 
           NVL(adj_credit,0) adj_credit
       FROM (SELECT  NULL branch_cd,
                          a.gl_acct_id,
                          a.gl_acct_no_formatted, 
                          a.gl_acct_name, 
                          a.tran_year YEAR, 
                          a.tran_mm MONTH, 
                          SUM (a.trans_debit_bal) debit,
                          SUM (a.trans_credit_bal) credit
                FROM giac_trial_balance_v a
                  WHERE a.tran_year = p_tran_year 
                    AND  a.tran_mm = p_tran_mm
                    AND  p_branch  = 'N'
                      GROUP BY NULL, a.gl_acct_id,
                                     a.gl_acct_no_formatted,
                                     a.gl_acct_name,
                                     a.tran_year,
                                     a.tran_mm
             UNION
             SELECT branch_cd,
                    a.gl_acct_id,
                    a.gl_acct_no_formatted, 
                    a.gl_acct_name, 
                    a.tran_year YEAR, 
                    a.tran_mm MONTH, 
                    SUM (a.trans_debit_bal) debit,
                    SUM (a.trans_credit_bal) credit
                FROM giac_trial_balance_v a
                  WHERE a.tran_year = p_tran_year 
                    AND a.tran_mm = p_tran_mm
                    AND p_branch = 'Y'
                      GROUP BY branch_cd, 
                a.gl_acct_id,
                               a.gl_acct_no_formatted,
                               a.gl_acct_name,
                               a.tran_year,
                               a.tran_mm) a,
             (SELECT DECODE( SIGN(SUM (debit_amt)- SUM (credit_amt)) ,1, SUM (debit_amt)- SUM (credit_amt),0) adj_debit,
                     SUM (credit_amt) adj_credit, 
                     a.gl_acct_id,
                     a.branch_cd 
                FROM giac_trial_balance_v a, GIAC_ACCT_ENTRIES b, GIAC_ACCTRANS c
                  WHERE b.gacc_tran_id = c.tran_id
                    AND ae_tag = 'Y'
                    AND TRUNC(posting_date) = LAST_DAY(TO_DATE(TO_CHAR(A.tran_mm, '09')||'-01-'||TO_CHAR(A.tran_year, 'fm0999'), 'MM/DD/RRRR'))
                    AND a.gl_acct_id = b.gl_acct_id
                    AND a.branch_cd = b.gacc_gibr_branch_cd
                    AND a.tran_mm = p_tran_mm
                    AND a.tran_year = p_tran_year
                      GROUP BY a.GL_ACCT_ID, branch_cd) b
        WHERE a.gl_acct_id = b.gl_acct_id(+)
          AND NVL(a.branch_cd, 'N') = NVL2(a.branch_cd, b.branch_cd(+), 'N' ) 
            ORDER BY branch_cd, gl_acct_no_formatted;
    v_adj_entries adj_entries_rec;
 v_current_branch VARCHAR2(3) := 'df1';
 v_new_branch     VARCHAR2(3) := 'df2';
 v_branch_name    GIAC_BRANCHES.branch_name%TYPE;
    BEGIN
      FOR i IN adjust_entries
      LOOP
     v_new_branch := NVL(i.branch_cd,'df2');
  IF v_new_branch <> v_current_branch THEN
    BEGIN
      SELECT branch_name
     INTO v_branch_name
       FROM GIAC_BRANCHES
       WHERE branch_cd = v_new_branch;
      v_current_branch := v_new_branch;
       EXCEPTION
      WHEN NO_DATA_FOUND THEN
     v_branch_name := NULL;
     v_current_branch := 'df1';
    END;
  END IF;
        v_adj_entries.branch_name    := v_branch_name;
        v_adj_entries.gl_acct_no     := i.gl_acct_no_formatted;
        v_adj_entries.acct_name      := i.gl_acct_name;
        v_adj_entries.MONTH          := i.MONTH;
        v_adj_entries.YEAR           := i.YEAR;
        v_adj_entries.debit          := i.debit - NVL( i.adj_debit,0);
        v_adj_entries.credit         := i.credit - NVL(i.adj_credit, 0);
        v_adj_entries.adjust_debit   := i.adj_debit;
        v_adj_entries.adjust_credit  := i.adj_credit;
        v_adj_entries.bal_debit      := i.debit;
        v_adj_entries.bal_credit     := i.credit;
        PIPE ROW (v_adj_entries);
      END LOOP;
      RETURN;
    END;       
 /*april*/
 FUNCTION sub_totals(p_tran_year GIAC_MONTHLY_TOTALS.tran_year%TYPE,
                         p_tran_mm GIAC_MONTHLY_TOTALS.tran_mm%TYPE)
                                    RETURN inc_subtotals_rep pipelined
   IS
     CURSOR inc_subtotals
     IS
  SELECT branch_name,
               gl_acct_no,
               gl_acct_name,
               trans_debit_bal,
               trans_credit_bal,
               gl_acct_category||'-'|| TO_CHAR(gl_control_acct,'09') ||'-'|| TO_CHAR(gl_sub_acct_1,'09') ||'-'|| TO_CHAR(gl_sub_acct_2,'09') sum2,
               gl_acct_category||'-'|| TO_CHAR(gl_control_acct,'09') ||'-'|| TO_CHAR(gl_sub_acct_1,'09') SUM,
               gl_acct_category||'-'|| TO_CHAR(gl_control_acct,'09') total,
               gl_acct_category,
               gl_acct_no_formatted
  FROM giac_trial_balance_v
 WHERE 1=1 
   AND tran_year = p_tran_year
   AND tran_mm = p_tran_mm
 ORDER BY gl_acct_no_formatted;
 v_rec inc_subtotals_rec;
  BEGIN
       FOR i IN inc_subtotals
       LOOP
      v_rec.branch_name  := i.branch_name;
         v_rec.gl_acct_no   := i.gl_acct_no;
         v_rec.acct_name    := i.gl_acct_name;
         v_rec.debit        := i.trans_debit_bal;
         v_rec.credit       := i.trans_credit_bal;
   
         PIPE ROW(v_rec);
       END LOOP;
       RETURN;
   END; 
END;
/


