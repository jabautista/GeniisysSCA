CREATE OR REPLACE PACKAGE BODY CPI.giacr111_pkg
AS
   FUNCTION get_giacr_111_report (
      p_date          VARCHAR2,
      p_exclude_tag   VARCHAR2,
      p_module_id     VARCHAR2,
      p_post_tran     VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
      v_exist  VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN
         (SELECT ROWNUM, a.tin, a.NAME, a.bir_tax_cd, a.income_amt,
                 a.percent_rate, a.wholding_tax_amt
            FROM (SELECT      b.payee_last_name
                           || ' '
                           || b.payee_first_name
                           || ' '
                           || b.payee_middle_name NAME,
                           b.tin, c.bir_tax_cd, c.percent_rate,
                           SUM (d.income_amt) income_amt,
                           SUM (d.wholding_tax_amt) wholding_tax_amt
                      FROM giac_acctrans a,
                           giis_payees b,
                           giac_wholding_taxes c,
                           giac_taxes_wheld d,
                           giis_payee_class e
                     WHERE c.whtax_id = d.gwtx_whtax_id
                       AND b.payee_class_cd = e.payee_class_cd
                       AND b.payee_class_cd = d.payee_class_cd
                       AND b.payee_no = d.payee_cd
                       AND a.tran_id = d.gacc_tran_id
                       AND a.tran_flag <> 'D'
                       AND d.gacc_tran_id NOT IN (
                              SELECT e.gacc_tran_id
                                FROM giac_reversals e, giac_acctrans f
                               WHERE e.reversing_tran_id = f.tran_id
                                 AND f.tran_flag <> 'D')
                       AND (   (    p_post_tran = 'T'
                                AND TRUNC (a.tran_date) <=
                                        TRUNC (TO_DATE (p_date, 'MM-dd-YYYY'))
                               )
                            OR (    p_post_tran = 'P'
                                AND TRUNC (a.posting_date) <=
                                        TRUNC (TO_DATE (p_date, 'MM-dd-YYYY'))
                               )
                           )
                       AND (   (    p_post_tran = 'T'
                                AND a.tran_flag <> NVL (p_exclude_tag, ' ')
                               )
                            OR p_post_tran = 'P'
                           )
                       AND check_user_per_iss_cd_acctg (NULL,
                                                        a.gibr_branch_cd,
                                                        p_module_id
                                                       ) = 1
                  GROUP BY    b.payee_last_name
                           || ' '
                           || b.payee_first_name
                           || ' '
                           || b.payee_middle_name,
                           b.tin,
                           c.bir_tax_cd,
                           c.percent_rate
                  ORDER BY NAME ASC) a)
      LOOP
         BEGIN
            SELECT param_value_v
              INTO v_list.co_tin
              FROM giac_parameters
             WHERE param_name = 'COMPANY_TIN';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.co_tin := NULL;
         END;

         BEGIN
            SELECT param_value_v
              INTO v_list.co_name
              FROM giac_parameters
             WHERE param_name = 'COMPANY_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.co_name := NULL;
         END;
         
         v_list.seq_no := i.rownum;
         v_list.tin := i.tin;
         v_list.name := i.name;
         v_list.atc_code := i.bir_tax_cd;
         v_list.income_amt := i.income_amt;
         v_list.tax_rt := i.percent_rate;
         v_list.tax_wh := i.wholding_tax_amt;

         IF p_date IS NOT NULL
         THEN
            v_list.as_of_date := 
               TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'),
                        'fmMonth DD, RRRR'
                       );
         END IF;
         
         v_exist := 'Y';
         
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_exist = 'N' THEN
         BEGIN
            SELECT param_value_v
              INTO v_list.co_tin
              FROM giac_parameters
             WHERE param_name = 'COMPANY_TIN';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.co_tin := NULL;
         END;

         BEGIN
            SELECT param_value_v
              INTO v_list.co_name
              FROM giac_parameters
             WHERE param_name = 'COMPANY_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.co_name := NULL;
         END;
         
         IF p_date IS NOT NULL
         THEN
            v_list.as_of_date := 
               TO_CHAR (TO_DATE (p_date, 'mm/dd/yyyy'),
                        'fmMonth DD, RRRR'
                       );
         END IF;
         
         v_list.exist := 'N';
         
         PIPE ROW(v_list);
      END IF;
   END get_giacr_111_report;
END;
/


