CREATE OR REPLACE PACKAGE BODY CPI.giclr207r_pkg
AS
   FUNCTION get_giclr207r_issource (p_tran_id VARCHAR2)
      RETURN VARCHAR2
   IS
      v_issource   giis_issource.iss_name%TYPE;
   BEGIN
      FOR a IN (SELECT gibr_branch_cd
                  FROM giac_acctrans
                 WHERE tran_id = p_tran_id)
      LOOP
         FOR b IN (SELECT iss_name
                     FROM giis_issource
                    WHERE iss_cd = a.gibr_branch_cd)
         LOOP
            v_issource := b.iss_name;
         END LOOP;
      END LOOP;

      RETURN (v_issource);
   END get_giclr207r_issource;

   FUNCTION get_giclr207r_as_of_date (p_month VARCHAR2, p_year DATE)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN ('As of ' || TO_CHAR (TO_DATE (p_month, 'MM'),'FMMONTH') || ', ' || TO_CHAR (p_year, 'RRRR'));
   END get_giclr207r_as_of_date;

   FUNCTION get_giclr207r_records (
      p_month     VARCHAR2,
      p_year      VARCHAR2,
      p_tran_id   VARCHAR2
   )
      RETURN giclr207r_record_tab PIPELINED
   IS
      v_list        giclr207r_record_type;
      v_not_exist   BOOLEAN               := TRUE;
      v_year        DATE                  := TO_DATE (p_year, 'RRRR');
   BEGIN
      v_list.company_name := giisp.v ('COMPANY_NAME');
      v_list.company_add := giisp.v ('COMPANY_ADDRESS');
      v_list.as_of_date := get_giclr207r_as_of_date (p_month, v_year);

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
         v_not_exist := FALSE;
         v_list.gl_acct_id := i.gl_acct_id;
         v_list.gl_acct := i.gl_acct;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.debit_amt := i.debit_amt;
         v_list.credit_amt := i.credit_amt;
         v_list.issource := get_giclr207r_issource (p_tran_id);
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr207r_records;
END;
/


