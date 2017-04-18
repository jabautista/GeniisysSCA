CREATE OR REPLACE PACKAGE BODY CPI.GIACR502E_PKG
AS
   /*
      **  Created by   :  Melvin John O. Ostia
      **  Date Created : 07.024.2013
      **  Reference By : GIACR502E_PKG - TRIAL BALANCE REPORT
      */
   FUNCTION get_giacr502e_record (
      p_tran_yr     VARCHAR2,
      p_tran_mm     VARCHAR2,
      p_branch_cd   VARCHAR2
   )
      RETURN giacr502e_tab PIPELINED
   AS
      v_rec         giacr502e_type;
      v_not_exist   BOOLEAN        := TRUE;
   BEGIN
      SELECT UPPER (param_value_v)
        INTO v_rec.company_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      SELECT UPPER (param_value_v)
        INTO v_rec.address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      IF NVL (p_tran_mm, 0) <= 0 OR NVL (p_tran_mm, 0) > 12
      THEN
         v_rec.mm := NVL (p_tran_mm, 0);
      ELSE
         v_rec.mm :=
               RTRIM (TO_CHAR (TO_DATE (TO_CHAR (p_tran_mm), 'MM'), 'Month'));
      END IF;

      v_rec.as_of := 'As of ' || v_rec.mm || ' ' || TO_CHAR (p_tran_yr);

      FOR rec IN (SELECT branch_name
                    FROM giac_branches
                   WHERE branch_cd = p_branch_cd)
      LOOP
         v_rec.branch_name := rec.branch_name;
         EXIT;
      END LOOP;

      FOR i IN (SELECT   fund_cd, branch_cd,
                         get_gl_acct_no (a.gl_acct_id) gl_no, b.gl_acct_name,
                         SUM (DECODE (SIGN (a.beg_debit_amt - a.beg_credit_amt),
                                      1, (a.beg_debit_amt - a.beg_credit_amt),
                                      0
                                     )
                             ) beg_debit,
                         SUM
                            (ABS (DECODE (SIGN (  a.beg_debit_amt
                                                - a.beg_credit_amt
                                               ),
                                          -1, (  a.beg_debit_amt
                                               - a.beg_credit_amt
                                           ),
                                          0
                                         )
                                 )
                            ) beg_credit,
                         SUM (a.trans_debit_bal) trans_debit,
                         SUM (a.trans_credit_bal) trans_credit,
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
                    FROM giac_finance_yr a, giac_chart_of_accts b
                   WHERE a.gl_acct_id = b.gl_acct_id
                     AND tran_year = p_tran_yr
                     AND tran_mm = p_tran_mm
                     AND branch_cd = NVL (p_branch_cd, branch_cd)
                GROUP BY branch_cd,
                         fund_cd,
                         get_gl_acct_no (a.gl_acct_id),
                         b.gl_acct_name
                ORDER BY branch_cd)
      LOOP
         v_not_exist := FALSE;
         v_rec.fund_cd := i.fund_cd;
         v_rec.branch_cd := i.branch_cd;
         v_rec.gl_no := i.gl_no;
         v_rec.gl_acct_name := i.gl_acct_name;
         v_rec.beg_debit := i.beg_debit;
         v_rec.beg_credit := i.beg_credit;
         v_rec.trans_debit := i.trans_debit;
         v_rec.trans_credit := i.trans_credit;
         v_rec.end_debit := i.end_debit;
         v_rec.end_credit := i.end_credit;

         FOR rec IN (SELECT branch_name
                       FROM giac_branches
                      WHERE gfun_fund_cd = i.fund_cd
                        AND branch_cd = NVL (p_branch_cd, i.branch_cd))
         LOOP
            v_rec.detail_branch_name := rec.branch_name;
         END LOOP;

         v_rec.balance := i.end_debit - i.end_credit;
         v_rec.text := '(' || i.branch_cd || ') Branch Totals   :';
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.v_not_exist := 'true';
         PIPE ROW (v_rec);
      END IF;
   END get_giacr502e_record;
END;
/


