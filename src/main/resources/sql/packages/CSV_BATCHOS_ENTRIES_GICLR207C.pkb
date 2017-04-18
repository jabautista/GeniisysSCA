CREATE OR REPLACE PACKAGE BODY CPI.CSV_BATCHOS_ENTRIES_GICLR207C
AS
/*
**Created by : Carlo Rubenecia
**Date Created : 04/25/2016
**Description : CSV for giclr207C 
*/
   FUNCTION csv_giclr207c (

      p_tran_class   VARCHAR2,
      p_tran_date    VARCHAR2
   )
      RETURN giclr207c_record_tab PIPELINED
   IS
      v_list        giclr207c_record_type;
      v_not_exist   BOOLEAN            := TRUE;
      v_tran_date   DATE               := TO_DATE (p_tran_date, 'MM-DD-RRRR');
   BEGIN


      FOR i IN (SELECT   a.gl_acct_id,
                            TO_CHAR (a.gl_acct_category)
                         || '-'
                         || TO_CHAR (a.gl_control_acct)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_1)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_2)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_3)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_4)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_5)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_6)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_7) gl_acct,
                         a.gl_acct_name, c.tran_date, c.tran_class,
                         NVL (SUM (b.debit_amt), 0) debit_amt,
                         NVL (SUM (b.credit_amt), 0) credit_amt
                    FROM giac_chart_of_accts a,
                         giac_acct_entries b,
                         giac_acctrans c
                   WHERE a.gl_acct_id = b.gl_acct_id
                     AND b.gacc_tran_id = c.tran_id
                     AND c.tran_date = v_tran_date
                     AND c.tran_class = p_tran_class
                     AND c.tran_flag IN ('P', 'C')
                  HAVING SUM (b.debit_amt) > 0 OR SUM (b.credit_amt) > 0
                GROUP BY a.gl_acct_id,
                            TO_CHAR (a.gl_acct_category)
                         || '-'
                         || TO_CHAR (a.gl_control_acct)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_1)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_2)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_3)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_4)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_5)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_6)
                         || '-'
                         || TO_CHAR (a.gl_sub_acct_7),
                         a.gl_acct_name,
                         c.tran_date,
                         c.tran_class
                ORDER BY 2)
      LOOP
         v_list.gl_account := i.gl_acct;
         v_list.gl_account_name := i.gl_acct_name;
         v_list.debit_amount := trim(to_char(i.debit_amt, '999,999,999,990.00'));
         v_list.credit_amount := trim(to_char(i.credit_amt, '999,999,999,990.00'));
         PIPE ROW (v_list);
      END LOOP;

   END csv_giclr207c;
END;
/
