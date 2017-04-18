CREATE OR REPLACE PACKAGE BODY CPI.giacr214b_pkg
AS
   FUNCTION get_giacr214b_details (
      p_from_date   DATE,
      p_to_date     DATE,
      p_tran_post   VARCHAR2,
      p_include     VARCHAR2, --vondanix 12.16.15 RSIC GENQA 5223
      p_branch_cd   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr214b_tab PIPELINED
   IS
      v_giacr214b   giacr214b_type;
   BEGIN
      FOR i IN
         (SELECT   e.gacc_gibr_branch_cd || '-' || gb.branch_name branch,
                   SUM (DECODE (NVL (e.debit_amt, 0),
                                0, e.credit_amt * -1,
                                e.debit_amt - NVL ((e.credit_amt), 0)
                               )
                       ) input_vat,
                   e.sl_source_cd, e.sl_cd, e.sl_type_cd,
                   LTRIM
                      (DECODE (e.sl_cd,
                               NULL, '_______No SL Code_______',
                               (DECODE (e.sl_source_cd,
                                        2, (SELECT    payee_last_name
                                                   || ' '
                                                   || payee_first_name
                                                   || ' '
                                                   || payee_middle_name
                                                   || '  *'
                                              FROM giis_payees a,
                                                   giis_payee_class b
                                             WHERE a.payee_class_cd =
                                                              b.payee_class_cd
                                               AND b.sl_type_cd = e.sl_type_cd
                                               AND a.payee_no = e.sl_cd),
                                        (SELECT sl_name
                                           FROM giac_sl_lists
                                          WHERE sl_type_cd = e.sl_type_cd
                                            AND sl_cd = e.sl_cd)
                                       )
                               )
                              )
                      ) AS sl_name
              FROM giac_order_of_payts b,
                   giac_disb_vouchers c,
                   giac_acctrans d,
                   giac_acct_entries e,
                   giac_branches gb,
                   giac_sl_lists gl
             WHERE e.gacc_tran_id = b.gacc_tran_id(+)
               AND e.gacc_tran_id = c.gacc_tran_id(+)
               AND d.tran_id = e.gacc_tran_id
               AND e.gacc_tran_id = d.tran_id
               AND e.gacc_gibr_branch_cd = gb.branch_cd
               AND e.gacc_gfun_fund_cd = gb.gfun_fund_cd
               AND e.sl_cd = gl.sl_cd(+)
               AND e.sl_type_cd = gl.sl_type_cd(+)
               AND e.gl_acct_id IN (
                      SELECT ch.gl_acct_id
                        FROM giac_module_entries me,
                             giac_modules m,
                             giac_chart_of_accts ch
                       WHERE me.module_id = m.module_id
                         AND me.gl_acct_category = ch.gl_acct_category
                         AND me.gl_control_acct = ch.gl_control_acct
                         AND me.gl_sub_acct_1 = ch.gl_sub_acct_1
                         AND me.gl_sub_acct_2 = ch.gl_sub_acct_2
                         AND me.gl_sub_acct_3 = ch.gl_sub_acct_3
                         AND me.gl_sub_acct_4 = ch.gl_sub_acct_4
                         AND me.gl_sub_acct_5 = ch.gl_sub_acct_5
                         AND me.gl_sub_acct_6 = ch.gl_sub_acct_6
                         AND me.gl_sub_acct_7 = ch.gl_sub_acct_7
                         AND m.module_name = 'GIACS039')
               AND d.tran_flag <> 'D'
               AND (   (    p_tran_post = 'P'
                        AND TRUNC(d.posting_date) BETWEEN p_from_date AND p_to_date --vondanix 12.16.15 RSIC GENQA 5223 added TRUNC
                       )
                    OR (    p_tran_post = 'T'
                        AND TRUNC(d.tran_date) BETWEEN p_from_date AND p_to_date --vondanix 12.16.15 RSIC GENQA 5223 added TRUNC
                       )
                   )
               AND (   (p_include = 'I' AND d.tran_flag != 'D')
                    OR (p_include = 'X' AND d.tran_flag IN ('P', 'C'))) --vondanix 12.16.15 RSIC GENQA 5223
               AND e.gacc_gibr_branch_cd =
                                      NVL (p_branch_cd, e.gacc_gibr_branch_cd)
               AND check_user_per_iss_cd_acctg2 (NULL,
                                                 e.gacc_gibr_branch_cd,
                                                 'GIACS104',
                                                 p_user_id
                                                ) = 1
          GROUP BY e.gacc_gibr_branch_cd || '-' || gb.branch_name,
                   e.sl_source_cd,
                   e.sl_cd,
                   e.sl_type_cd
          ORDER BY e.gacc_gibr_branch_cd || '-' || gb.branch_name,
                   e.sl_source_cd,
                   e.sl_cd,
                   e.sl_type_cd)
      LOOP
         v_giacr214b.branch := i.branch;
         v_giacr214b.sl_name := i.sl_name;
         v_giacr214b.sl_cd := i.sl_cd;
         v_giacr214b.sl_type_cd := i.sl_type_cd;
         v_giacr214b.sl_source_cd := i.sl_source_cd;
         v_giacr214b.input_vat := i.input_vat;
         v_giacr214b.amt_sub_to_vat := ROUND ((i.input_vat / .12), 2);

         SELECT giacr214b_pkg.get_cf_company_nameformula
           INTO v_giacr214b.company_name
           FROM DUAL;

         SELECT giacr214b_pkg.get_cf_company_addformula
           INTO v_giacr214b.company_address
           FROM DUAL;

         SELECT giacr214b_pkg.get_cf_date_paramsformula (p_from_date,
                                                         p_to_date
                                                        )
           INTO v_giacr214b.date_params
           FROM DUAL;

         SELECT giacr214b_pkg.get_cf_tinformula (v_giacr214b.sl_cd,
                                                 v_giacr214b.sl_type_cd
                                                )
           INTO v_giacr214b.tin
           FROM DUAL;

         SELECT giacr214b_pkg.get_cf_addressformula (v_giacr214b.sl_cd,
                                                     v_giacr214b.sl_type_cd
                                                    )
           INTO v_giacr214b.address
           FROM DUAL;

         PIPE ROW (v_giacr214b);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2
   IS
      v_company_name   /*giis_parameters*/ giac_parameters.param_value_v%TYPE;  -- changed by shan 07.31.2014
   BEGIN
      FOR rec IN (SELECT giacp.v ('COMPANY_NAME') v_company_name
                    FROM DUAL)
      LOOP
         v_company_name := rec.v_company_name;
      END LOOP;

      RETURN (v_company_name);
   END;

   FUNCTION get_cf_company_addformula
      RETURN VARCHAR2
   IS
      v_company_address   /*giis_parameters*/ giac_parameters.param_value_v%TYPE;       -- changed by shan 07.31.2014
   BEGIN
      FOR rec IN (SELECT UPPER (giacp.v ('COMPANY_ADDRESS'))
                                                           v_company_address
                    FROM DUAL)
      LOOP
         v_company_address := rec.v_company_address;
      END LOOP;

      RETURN (v_company_address);
   END;

   FUNCTION get_cf_date_paramsformula (p_from_date DATE, p_to_date DATE)
      RETURN VARCHAR2
   IS
      v_date_params   VARCHAR2 (100);
   BEGIN
      IF p_from_date = p_to_date
      THEN
         v_date_params := p_from_date;
      ELSE
         v_date_params :=
               'From '
            || TO_CHAR (p_from_date, 'fmMonth dd, yyyy')
            || ' To '
            || TO_CHAR (p_to_date, 'fmMonth dd, yyyy');
      END IF;

      RETURN (v_date_params);
   END;

   FUNCTION get_cf_tinformula (
      p_sl_cd        giac_acct_entries.sl_cd%TYPE,
      p_sl_type_cd   giac_acct_entries.sl_type_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_tin   VARCHAR2 (35);
   BEGIN
      SELECT tin
        INTO v_tin
        FROM giis_payees a, giis_payee_class b
       WHERE a.payee_class_cd = b.payee_class_cd
         AND b.sl_type_cd = p_sl_type_cd
         AND a.payee_no = p_sl_cd;

      RETURN (v_tin);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_tin := NULL;
         RETURN (v_tin);
   END;

   FUNCTION get_cf_addressformula (
      p_sl_cd        giac_acct_entries.sl_cd%TYPE,
      p_sl_type_cd   giac_acct_entries.sl_type_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_address   VARCHAR2 (200);
   BEGIN
      FOR a IN (SELECT    mail_addr1
                       || ' '
                       || mail_addr2
                       || ' '
                       || mail_addr3 address
                  FROM giis_payees c, giis_payee_class d
                 WHERE c.payee_class_cd = d.payee_class_cd
                   AND d.sl_type_cd = p_sl_type_cd
                   AND c.payee_no = p_sl_cd)
      LOOP
         v_address := a.address;
         EXIT;
      END LOOP;

      RETURN (v_address);
   END;
END giacr214b_pkg;
/


