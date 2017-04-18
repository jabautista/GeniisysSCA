CREATE OR REPLACE PACKAGE BODY CPI.giacr134_pkg
AS
   FUNCTION get_giacr134_dtls (
      p_date         VARCHAR2,
      p_tran_date1   VARCHAR2,
      p_tran_date2   VARCHAR2,
      p_tran_year    VARCHAR2
   )
      RETURN get_giacr134_tab PIPELINED
   IS
      v_list   get_giacr134_type;
   BEGIN
      FOR i IN (SELECT   p_date,
                            c.gl_acct_category
                         || '-'
                         || c.gl_control_acct
                         || '-'
                         || c.gl_sub_acct_1
                         || '-'
                         || c.gl_sub_acct_2
                         || '-'
                         || c.gl_sub_acct_3
                         || '-'
                         || c.gl_sub_acct_4
                         || '-'
                         || c.gl_sub_acct_5
                         || '-'
                         || c.gl_sub_acct_6
                         || '-'
                         || c.gl_sub_acct_7 gl_acct_cd,
                         c.gl_acct_name gl_acct_name,
                         SUM (a.debit_amt) debit_amt,
                         SUM (a.credit_amt) credit_amt
                    FROM giac_acct_entries a,
                         giac_acctrans b,
                         giac_chart_of_accts c
                   WHERE b.tran_class = 'PRD'
                     AND b.tran_flag IN ('C', 'P')
                     AND TRUNC (b.tran_date) <=
                                  TRUNC (TO_DATE (p_tran_date2, 'MM-dd-YYYY'))
                     AND TRUNC (b.tran_date) >=
                                  TRUNC (TO_DATE (p_tran_date1, 'MM-dd-YYYY'))
                     AND a.gacc_tran_id = b.tran_id
                     AND a.gl_acct_id = c.gl_acct_id
                GROUP BY    c.gl_acct_category
                         || '-'
                         || c.gl_control_acct
                         || '-'
                         || c.gl_sub_acct_1
                         || '-'
                         || c.gl_sub_acct_2
                         || '-'
                         || c.gl_sub_acct_3
                         || '-'
                         || c.gl_sub_acct_4
                         || '-'
                         || c.gl_sub_acct_5
                         || '-'
                         || c.gl_sub_acct_6
                         || '-'
                         || c.gl_sub_acct_7,
                         c.gl_acct_name)
      LOOP
         BEGIN
            SELECT param_value_v
              INTO v_list.company_name
              FROM giis_parameters
             WHERE param_name = 'COMPANY_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_name := ' ';
         END;

         BEGIN
            SELECT param_value_v
              INTO v_list.company_address
              FROM giac_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_address := ' ';
         END;

         IF p_tran_date1 IS NOT NULL
         THEN
            v_list.tran_date1 :=
               TO_CHAR (TO_DATE (p_tran_date1, 'mm/dd/yyyy'),
                        'fmMonth DD, RRRR'
                       );
         END IF;
         
         IF p_tran_date2 IS NOT NULL
         THEN
            v_list.tran_date2 :=
               TO_CHAR (TO_DATE (p_tran_date2, 'mm/dd/yyyy'),
                        'fmMonth DD, RRRR'
                       );
         END IF;

         v_list.gl_acct_cd := i.gl_acct_cd;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.debit_amt := i.debit_amt;
         v_list.credit_amt := i.credit_amt;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacr134_dtls;
END;
/


