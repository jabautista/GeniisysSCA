CREATE OR REPLACE PACKAGE BODY CPI.CSV_BATCHOS_ENTRIES_GICLR207R 
AS
/*
**Created by : Carlo Rubenecia
**Date Created : 04/25/2016
**Description : CSV for giclr207R 
*/
   FUNCTION csv_giclr207r (
      p_tran_id   VARCHAR2
   )
      RETURN giclr207r_record_tab PIPELINED
   IS
      v_list        giclr207r_record_type;
      v_not_exist   BOOLEAN               := TRUE;
   BEGIN

      FOR i IN (SELECT   a.gl_acct_id,
                            TRIM (TO_CHAR (a.gl_acct_category))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_control_acct, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_7, '00')) gl_acct,
                         a.gl_acct_name, NVL (SUM (d.debit_amt), 0)
                                                                   debit_amt,
                         NVL (SUM (d.credit_amt), 0) credit_amt
                    FROM giac_chart_of_accts a,
                         giac_acctrans b,
                         giac_acct_entries d
                   WHERE a.gl_acct_id = d.gl_acct_id
                     AND d.gacc_tran_id = b.tran_id
                     AND b.tran_class = 'OLR'
                     AND b.tran_flag IN ('P', 'C')
                     AND d.gacc_tran_id = p_tran_id
                  HAVING SUM (d.debit_amt) > 0 OR SUM (d.credit_amt) > 0
                GROUP BY a.gl_acct_id,
                            TRIM (TO_CHAR (a.gl_acct_category))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_control_acct, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_7, '00')),
                         a.gl_acct_name
                ORDER BY 2)
      LOOP
         v_list.gl_account := i.gl_acct;
         v_list.gl_account_name := i.gl_acct_name;
         v_list.debit_amount := trim(to_char(i.debit_amt, '999,999,999,990.00'));
         v_list.credit_amount := trim(to_char(i.credit_amt, '999,999,999,990.00'));
         PIPE ROW (v_list);
      END LOOP;

   END csv_giclr207r;
END;
/
