CREATE OR REPLACE PACKAGE BODY CPI.GIACR502D_PKG
AS
   FUNCTION get_giacr_502d_report (p_tran_mm NUMBER, p_tran_yr NUMBER)
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
      v_not_exist   BOOLEAN               := TRUE;
   BEGIN
      FOR c IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'COMPANY_NAME')
      LOOP
         v_list.company_name := c.param_value_v;
      END LOOP;

      BEGIN
         SELECT param_value_v
           INTO v_list.company_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.company_address := '';
      END;

      BEGIN
         IF NVL (p_tran_mm, 0) <= 0 OR NVL (p_tran_mm, 0) > 12
         THEN
            v_list.mm := NVL (p_tran_mm, 0);
         ELSE
            v_list.mm :=
               RTRIM (TO_CHAR (TO_DATE (TO_CHAR (p_tran_mm), 'MM'), 'Month'));
         END IF;
      END;

      v_list.as_of := 'As of ' || v_list.mm || ' ' || TO_CHAR (p_tran_yr);

      FOR i IN (SELECT   get_gl_acct_no (a.gl_acct_id) gl_acct_no,
                         b.gl_acct_name,
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
                GROUP BY get_gl_acct_no (a.gl_acct_id), b.gl_acct_name
                ORDER BY get_gl_acct_no (a.gl_acct_id))
      LOOP
         v_not_exist := FALSE;
         v_list.gl_acct_no := i.gl_acct_no;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.beg_debit := i.beg_debit;
         v_list.beg_credit := i.beg_credit;
         v_list.trans_debit := i.trans_debit;
         v_list.trans_credit := i.trans_credit;
         v_list.end_debit := i.end_debit;
         v_list.end_credit := i.end_credit;
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_not_exist THEN
         PIPE ROW (v_list);
      END IF;
   END get_giacr_502d_report;
END;
/


