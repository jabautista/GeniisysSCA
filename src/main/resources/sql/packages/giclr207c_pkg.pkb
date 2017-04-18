CREATE OR REPLACE PACKAGE BODY CPI.giclr207c_pkg
AS

   FUNCTION get_giclr207c_records (
      p_month        VARCHAR2,
      p_year         VARCHAR2,
      p_tran_class   VARCHAR2,
      p_tran_date    VARCHAR2
   )
      RETURN giclr207c_record_tab PIPELINED
   IS
      v_list        giclr207c_record_type;
      v_not_exist   BOOLEAN            := TRUE;
      v_tran_date   DATE               := TO_DATE (p_tran_date, 'MM-DD-RRRR');
   BEGIN
      v_list.company_name := giisp.v ('COMPANY_NAME');
      v_list.company_add := giisp.v ('COMPANY_ADDRESS');
      v_list.as_of_date := 'As of ' || TO_CHAR (TO_DATE (p_month, 'MM'),'FMMONTH') || ', ' || TO_CHAR (TO_DATE (p_year, 'RRRR'), 'RRRR');

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
         v_not_exist := FALSE;
         v_list.gl_acct_id := i.gl_acct_id;
         v_list.gl_acct := i.gl_acct;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.tran_date := i.tran_date;
         v_list.tran_class := i.tran_class;
         v_list.debit_amt := i.debit_amt;
         v_list.credit_amt := i.credit_amt;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr207c_records;
END;
/


