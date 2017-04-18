CREATE OR REPLACE PACKAGE BODY CPI.GIACR502F_PKG
AS
/*
**Created by: Benedict G. Castillo
**Date Created : 07/25/2013
**Description: GIACR502F :TRIAL BALANCE REPORT
*/
   FUNCTION populate_giacr502f (
      p_tran_mm   VARCHAR2,
      p_tran_yr   VARCHAR2,
      p_user_id   VARCHAR2
   )
      RETURN giacr502f_tab PIPELINED
   AS
      v_rec         giacr502f_type;
      v_not_exist   BOOLEAN        := TRUE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');

      IF NVL (p_tran_mm, 0) <= 0 OR NVL (p_tran_mm, 0) > 12
      THEN
         v_rec.as_of :=
                  'As of ' || NVL (p_tran_mm, 0) || ' '
                  || TO_CHAR (p_tran_yr);
      ELSE
         v_rec.as_of :=
               'As of '
            || RTRIM (TO_CHAR (TO_DATE (TO_CHAR (p_tran_mm), 'MM'), 'Month'))
            || ' '
            || TO_CHAR (p_tran_yr);
      END IF;

      FOR i IN (SELECT   get_gl_acct_no (a.gl_acct_id) acct_no,
                         b.gl_acct_name,
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
                   --AND a.user_id = p_user_id
                GROUP BY get_gl_acct_no (a.gl_acct_id), b.gl_acct_name
                ORDER BY get_gl_acct_no (a.gl_acct_id))
      LOOP
         v_not_exist := FALSE;
         v_rec.acct_no := i.acct_no;
         v_rec.acct_name := i.gl_acct_name;
         v_rec.beg_debit := i.beg_debit;
         v_rec.beg_credit := i.beg_credit;
         v_rec.trans_debit := i.trans_debit;
         v_rec.trans_credit := i.trans_credit;
         v_rec.end_debit := i.end_debit;
         v_rec.end_credit := i.end_credit;
         v_rec.balance := (i.end_debit - i.end_credit);
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.flag := 'T';
         PIPE ROW (v_rec);
      END IF;
   END populate_giacr502f;
END GIACR502F_PKG;
/


