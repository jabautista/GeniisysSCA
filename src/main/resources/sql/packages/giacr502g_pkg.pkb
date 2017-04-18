CREATE OR REPLACE PACKAGE BODY CPI.GIACR502G_PKG
AS
   FUNCTION get_giacr502g_as_of_date (p_tran_mm VARCHAR2, p_tran_yr VARCHAR2)
      RETURN VARCHAR2
   IS
      v_as_of   VARCHAR2 (20);
      v_mm      VARCHAR2 (10);
   BEGIN
      IF NVL (p_tran_mm, 0) <= 0 OR NVL (p_tran_mm, 0) > 12
      THEN
         v_mm := NVL (p_tran_mm, 0);
      ELSE
         v_mm :=
               RTRIM (TO_CHAR (TO_DATE (TO_CHAR (p_tran_mm), 'MM'), 'Month'));
      END IF;

      v_as_of := 'As of ' || v_mm || ' ' || TO_CHAR (p_tran_yr);
      RETURN (v_as_of);
   END get_giacr502g_as_of_date;

   FUNCTION get_giacr502g_branch_name2 (p_branch_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_branch_name   VARCHAR2 (50);
   BEGIN
      FOR a IN (SELECT branch_name
                  FROM giac_branches
                 WHERE branch_cd = p_branch_cd)
      LOOP
         v_branch_name := a.branch_name;
      END LOOP;

      RETURN (v_branch_name);
   END get_giacr502g_branch_name2;

   FUNCTION get_giacr502g_branch_totals (branch_cd VARCHAR2)
      RETURN CHAR
   IS
      v_text   VARCHAR2 (30);
   BEGIN
      v_text := '(' || branch_cd || ') Branch Totals   :';
      RETURN (v_text);
   END get_giacr502g_branch_totals;

   FUNCTION get_giacr502g_balance (end_debit NUMBER, end_credit NUMBER)
      RETURN NUMBER
   IS
      v_balance   NUMBER (16, 2);
   BEGIN
      v_balance := end_debit - end_credit;
      RETURN (v_balance);
   END get_giacr502g_balance;

   FUNCTION get_giacr502g_records (
      p_branch_cd   VARCHAR2,
      p_tran_mm     VARCHAR2,
      p_tran_yr     VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr502g_record_tab PIPELINED
   IS
      v_list        giacr502g_record_type;
      v_not_exist   BOOLEAN               := TRUE;
   BEGIN
      v_list.comp_name := giisp.v ('COMPANY_NAME');
      v_list.comp_address := giisp.v ('COMPANY_ADDRESS');
      v_list.branch_name2 := get_giacr502g_branch_name2 (p_branch_cd);
      v_list.as_of_date := get_giacr502g_as_of_date (p_tran_mm, p_tran_yr);
      
      FOR i IN (SELECT   fund_cd, branch_cd,
                         get_gl_acct_no (a.gl_acct_id) gl_no, b.gl_acct_name,
                         SUM (DECODE (SIGN (beg_debit_bal - beg_credit_bal),
                                      1, (beg_debit_bal - beg_credit_bal),
                                      0
                                     )
                             ) beg_debit,
                         SUM (ABS (DECODE (SIGN (beg_debit_bal
                                                 - beg_credit_bal
                                                ),
                                           -1, (beg_debit_bal - beg_credit_bal),
                                           0
                                          )
                                  )
                             ) beg_credit,
                         SUM (a.debit) trans_debit,
                         SUM (a.credit) trans_credit,
                         SUM (DECODE (SIGN (a.trans_balance),
                                      1, a.trans_balance,
                                      0
                                     )
                             ) end_debit,
                         SUM (ABS (DECODE (SIGN (a.trans_balance),
                                           -1, a.trans_balance,
                                           0
                                          )
                                  )
                             ) end_credit
                    FROM giac_trial_balance_summary a, giac_chart_of_accts b
                   WHERE a.gl_acct_id = b.gl_acct_id
                    -- AND a.user_id = p_user_id
                     AND branch_cd = NVL (p_branch_cd, branch_cd)
                GROUP BY fund_cd,
                         branch_cd,
                         get_gl_acct_no (a.gl_acct_id),
                         b.gl_acct_name)
      LOOP
         v_not_exist := FALSE;
         v_list.fund_cd := i.fund_cd;
         v_list.branch_cd := i.branch_cd;
         v_list.gl_no := i.gl_no;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.beg_debit := i.beg_debit;
         v_list.beg_credit := i.beg_credit;
         v_list.trans_debit := i.trans_debit;
         v_list.trans_credit := i.trans_credit;
         v_list.end_debit := i.end_debit;
         v_list.end_credit := i.end_credit;
         v_list.branch_totals := get_giacr502g_branch_totals (i.branch_cd);
         v_list.balance := get_giacr502g_balance (i.end_debit, i.end_credit);

         FOR c IN (SELECT branch_name
                     FROM giac_branches
                    WHERE gfun_fund_cd = i.fund_cd
                          AND branch_cd = i.branch_cd)
         LOOP
            v_list.branch := c.branch_name;
            EXIT;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giacr502g_records;
END;
/


