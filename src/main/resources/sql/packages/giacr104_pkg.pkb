CREATE OR REPLACE PACKAGE BODY CPI.giacr104_pkg
AS
   FUNCTION get_giacr104_details (
      p_from_date   DATE,
      p_to_date     DATE,
      p_tran_post   VARCHAR2,
      p_include     VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr104_tab PIPELINED
   IS
      v_giacr104   giacr104_type;
   BEGIN
      FOR i IN
         (SELECT   e.gacc_gibr_branch_cd || '-' || gb.branch_name branch,
                      e.gl_acct_category
                   || '-'
                   || e.gl_control_acct
                   || '-'
                   || e.gl_sub_acct_1
                   || '-'
                   || e.gl_sub_acct_2
                   || '-'
                   || e.gl_sub_acct_3
                   || '-'
                   || e.gl_sub_acct_4
                   || '-'
                   || e.gl_sub_acct_5
                   || '-'
                   || e.gl_sub_acct_6
                   || '-'
                   || e.gl_sub_acct_7 "JOY",
                   b.payor NAME, d.tran_class tran_class,
                   d.tran_date tran_date,
--                 changed to get_ref_no by robert SR 5223 03.11.16
--                 DECODE (b.or_no,
--                         NULL, 'COL ',
--                            'COL '
--                         || b.or_pref_suf
--                         || '-'
--                         || LPAD (b.or_no, 10, 0)
--                        ) ref_no,
                   get_ref_no(e.gacc_tran_id) ref_no,
                   DECODE (NVL (e.debit_amt, 0),
                           0, DECODE (NVL (e.credit_amt, 0),
                                      0, 0,
                                      e.credit_amt * -1
                                     ),
                           NVL (e.debit_amt, 0) - NVL (e.credit_amt, 0)
                          ) input_vat,
                   b.particulars particulars, b.tin tin, e.sl_cd,
                   ' ' address
              FROM giac_order_of_payts b,
                   giac_acctrans d,
                   giac_acct_entries e,
                   giac_branches gb
             WHERE e.gacc_tran_id = b.gacc_tran_id(+)
               AND d.tran_id = e.gacc_tran_id
               AND e.gacc_gibr_branch_cd = gb.branch_cd
               AND e.gacc_gfun_fund_cd = gb.gfun_fund_cd
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
               AND d.tran_class = 'COL'
               AND (   (    p_tran_post = 'P'
                        AND TRUNC(d.posting_date) BETWEEN p_from_date AND p_to_date --vondanix 12.16.15 RSIC GENQA 5223 added TRUNC
                       )
                    OR (    p_tran_post = 'T'
                        AND TRUNC(d.tran_date) BETWEEN p_from_date AND p_to_date --vondanix 12.16.15 RSIC GENQA 5223 added TRUNC
                       )
                   )
               AND (   (p_include = 'I' AND d.tran_flag != 'D')
                    OR (p_include = 'X' AND d.tran_flag IN ('P', 'C'))
                   )
               AND e.gacc_gibr_branch_cd =
                                      NVL (p_branch_cd, e.gacc_gibr_branch_cd)
               AND e.gacc_gibr_branch_cd IN (
                      SELECT iss_cd
                        FROM giis_issource
                       WHERE iss_cd =
                                DECODE
                                   (check_user_per_iss_cd_acctg2
                                                           (NULL,
                                                            iss_cd,
                                                            UPPER (p_module_id),
                                                            p_user_id
                                                           ),
                                    1, iss_cd,
                                    NULL
                                   ))
          UNION ALL --vondanix 12.16.15 RSIC GENQA 5223
          SELECT   e.gacc_gibr_branch_cd || '-' || gb.branch_name branch,
                      e.gl_acct_category
                   || '-'
                   || e.gl_control_acct
                   || '-'
                   || e.gl_sub_acct_1
                   || '-'
                   || e.gl_sub_acct_2
                   || '-'
                   || e.gl_sub_acct_3
                   || '-'
                   || e.gl_sub_acct_4
                   || '-'
                   || e.gl_sub_acct_5
                   || '-'
                   || e.gl_sub_acct_6
                   || '-'
                   || e.gl_sub_acct_7 "JOY",
                   c.payee NAME, d.tran_class tran_class,
                   d.tran_date tran_date,
--                 changed to get_ref_no by robert SR 5223 03.11.16                   
--                   DECODE (c.dv_no,
--                           NULL, 'DV ',
--                           'DV ' || c.dv_pref || '-' || LPAD (c.dv_no, 10, 0)
--                          ) ref_no,
                   get_ref_no(e.gacc_tran_id) ref_no,
                   DECODE (NVL (e.debit_amt, 0),
                           0, DECODE (NVL (e.credit_amt, 0),
                                      0, 0,
                                      e.credit_amt * -1
                                     ),
                           NVL (e.debit_amt, 0) - NVL (e.credit_amt, 0)
                          ) input_vat,
                   c.particulars particulars, x.tin tin, e.sl_cd,
                      x.mail_addr1
                   || ' '
                   || x.mail_addr2
                   || ' '
                   || x.mail_addr3 address
              FROM giac_disb_vouchers c,
                   giac_acctrans d,
                   giac_acct_entries e,
                   giac_branches gb,
                   giis_payees x
             WHERE e.gacc_tran_id = c.gacc_tran_id(+)
               AND d.tran_id = e.gacc_tran_id
               AND e.gacc_gibr_branch_cd = gb.branch_cd
               AND e.gacc_gfun_fund_cd = gb.gfun_fund_cd
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
               AND d.tran_class = 'DV'
               AND (   (    p_tran_post = 'P'
                        AND TRUNC(d.posting_date) BETWEEN p_from_date AND p_to_date --vondanix 12.16.15 RSIC GENQA 5223 added TRUNC
                       )
                    OR (    p_tran_post = 'T'
                        AND TRUNC(d.tran_date) BETWEEN p_from_date AND p_to_date --vondanix 12.16.15 RSIC GENQA 5223 added TRUNC
                       )
                   )
               AND (   (p_include = 'I' AND d.tran_flag != 'D')
                    OR (p_include = 'X' AND d.tran_flag IN ('P', 'C'))
                   )
               AND e.gacc_gibr_branch_cd =
                                      NVL (p_branch_cd, e.gacc_gibr_branch_cd)
               AND c.payee_class_cd = x.payee_class_cd
               AND c.payee_no = x.payee_no
               AND e.gacc_gibr_branch_cd IN (
                      SELECT iss_cd
                        FROM giis_issource
                       WHERE iss_cd =
                                DECODE
                                   (check_user_per_iss_cd_acctg2
                                                           (NULL,
                                                            iss_cd,
                                                            UPPER (p_module_id),
                                                            p_user_id
                                                           ),
                                    1, iss_cd,
                                    NULL
                                   ))
          UNION ALL --vondanix 12.16.15 RSIC GENQA 5223
          SELECT   e.gacc_gibr_branch_cd || '-' || gb.branch_name branch,
                      e.gl_acct_category
                   || '-'
                   || e.gl_control_acct
                   || '-'
                   || e.gl_sub_acct_1
                   || '-'
                   || e.gl_sub_acct_2
                   || '-'
                   || e.gl_sub_acct_3
                   || '-'
                   || e.gl_sub_acct_4
                   || '-'
                   || e.gl_sub_acct_5
                   || '-'
                   || e.gl_sub_acct_6
                   || '-'
                   || e.gl_sub_acct_7 "JOY",
                   ' ' NAME, d.tran_class tran_class,
                   NVL (d.tran_date, NULL) tran_date,
--                 changed to get_ref_no by robert SR 5223 03.11.16
--                   DECODE (d.tran_class,
--                           'JV', d.tran_class || '-' || d.jv_no,
--                              d.tran_class
--                           || '-'
--                           || TO_CHAR (d.tran_year)
--                           || '-'
--                           || TO_CHAR (d.tran_month)
--                           || '-'
--                           || LPAD (d.tran_seq_no, 6, 0)
--                          ) ref_no,
                   get_ref_no(e.gacc_tran_id) ref_no,
                   DECODE (NVL (e.debit_amt, 0),
                           0, DECODE (NVL (e.credit_amt, 0),
                                      0, 0,
                                      e.credit_amt * -1
                                     ),
                           NVL (e.debit_amt, 0) - NVL (e.credit_amt, 0)
                          ) input_vat,
                   d.particulars particulars, ' ' tin, e.sl_cd, ' ' address
              FROM giac_acctrans d, giac_acct_entries e, giac_branches gb
             WHERE d.tran_id = e.gacc_tran_id
               AND e.gacc_gibr_branch_cd = gb.branch_cd
               AND e.gacc_gfun_fund_cd = gb.gfun_fund_cd
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
               AND d.tran_class NOT IN ('COL', 'DV')
               AND (   (    p_tran_post = 'P'
                        AND TRUNC(d.posting_date) BETWEEN p_from_date AND p_to_date --vondanix 12.16.15 RSIC GENQA 5223 added TRUNC
                       )
                    OR (    p_tran_post = 'T'
                        AND TRUNC(d.tran_date) BETWEEN p_from_date AND p_to_date --vondanix 12.16.15 RSIC GENQA 5223 added TRUNC
                       )
                   )
               AND (   (p_include = 'I' AND d.tran_flag != 'D')
                    OR (p_include = 'X' AND d.tran_flag IN ('P', 'C'))
                   )
               AND e.gacc_gibr_branch_cd =
                                      NVL (p_branch_cd, e.gacc_gibr_branch_cd)
               AND e.gacc_gibr_branch_cd IN (
                      SELECT iss_cd
                        FROM giis_issource
                       WHERE iss_cd =
                                DECODE
                                   (check_user_per_iss_cd_acctg2
                                                           (NULL,
                                                            iss_cd,
                                                            UPPER (p_module_id),
                                                            p_user_id
                                                           ),
                                    1, iss_cd,
                                    NULL
                                   ))
          UNION ALL --vondanix 12.16.15 RSIC GENQA 5223
          SELECT   e.gacc_gibr_branch_cd || '-' || gb.branch_name branch,
                      e.gl_acct_category
                   || '-'
                   || e.gl_control_acct
                   || '-'
                   || e.gl_sub_acct_1
                   || '-'
                   || e.gl_sub_acct_2
                   || '-'
                   || e.gl_sub_acct_3
                   || '-'
                   || e.gl_sub_acct_4
                   || '-'
                   || e.gl_sub_acct_5
                   || '-'
                   || e.gl_sub_acct_6
                   || '-'
                   || e.gl_sub_acct_7 "JOY",
                   c.payee NAME, d.tran_class tran_class,
                   d.tran_date tran_date,
--                 changed to get_ref_no by robert SR 5223 03.11.16
--                      f.document_cd
--                   || '-'
--                   || DECODE (f.line_cd, NULL, '', f.line_cd || '-')
--                   || DECODE (f.doc_year,
--                              NULL, '',
--                              SUBSTR (f.doc_year, 3) || '-'
--                             )
--                   || DECODE (f.doc_mm, NULL, '', doc_mm || '-')
--                   || LPAD (f.doc_seq_no, 6, 0) ref_no,
                   get_ref_no(e.gacc_tran_id) ref_no,
                   DECODE (NVL (e.debit_amt, 0),
                           0, DECODE (NVL (e.credit_amt, 0),
                                      0, 0,
                                      e.credit_amt * -1
                                     ),
                           NVL (e.debit_amt, 0) - NVL (e.credit_amt, 0)
                          ) input_vat,
                   c.particulars particulars, y.tin tin, e.sl_cd,
                      y.mail_addr1
                   || ' '
                   || y.mail_addr2
                   || ' '
                   || y.mail_addr3 address
              FROM giac_payt_requests_dtl c,
                   giac_payt_requests f,
                   giac_acctrans d,
                   giac_acct_entries e,
                   giac_branches gb,
                   giis_payees y
             WHERE e.gacc_tran_id = c.tran_id(+)
               AND c.gprq_ref_id = f.ref_id
               AND d.tran_id = e.gacc_tran_id
               AND e.gacc_gibr_branch_cd = gb.branch_cd
               AND e.gacc_gfun_fund_cd = gb.gfun_fund_cd
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
               AND d.tran_class = 'DV'
               AND f.with_dv = 'N'
               AND (   (    p_tran_post = 'P'
                        AND TRUNC(d.posting_date) BETWEEN p_from_date AND p_to_date --added trunc vondanix 12.16.15 RSIC GENQA 5223
                       )
                    OR (    p_tran_post = 'T'
                        AND TRUNC(d.tran_date) BETWEEN p_from_date AND p_to_date --added trunc vondanix 12.16.15 RSIC GENQA 5223
                       )
                   )
               AND (   (p_include = 'I' AND d.tran_flag != 'D')
                    OR (p_include = 'X' AND d.tran_flag IN ('P', 'C'))
                   )
               AND e.gacc_gibr_branch_cd =
                                      NVL (p_branch_cd, e.gacc_gibr_branch_cd)
               AND c.payee_class_cd = y.payee_class_cd
               AND c.payee_cd = y.payee_no
               AND e.gacc_gibr_branch_cd IN (
                      SELECT iss_cd
                        FROM giis_issource
                       WHERE iss_cd =
                                DECODE
                                   (check_user_per_iss_cd_acctg2
                                                           (NULL,
                                                            iss_cd,
                                                            UPPER (p_module_id),
                                                            p_user_id
                                                           ),
                                    1, iss_cd,
                                    NULL
                                   ))
          ORDER BY BRANCH)
      LOOP
         v_giacr104.branch := i.branch;
         v_giacr104.address := i.address;
         v_giacr104.sl_cd := i.sl_cd;
         v_giacr104.tin := i.tin;
         v_giacr104.NAME := i.NAME;
         v_giacr104.particulars := i.particulars;
         v_giacr104.tran_date := TO_CHAR(i.tran_date, 'MM-DD-RRRR');
         v_giacr104.tran_class := i.tran_class;
         v_giacr104.input_vat := i.input_vat;
         v_giacr104.ref_no := i.ref_no;
         v_giacr104.joy := i.joy;
         v_giacr104.v_o_vat := i.input_vat / .12;

         SELECT giacr104_pkg.get_cf_company_nameformula
           INTO v_giacr104.company_name
           FROM DUAL;

         SELECT giacr104_pkg.get_cf_company_addformula
           INTO v_giacr104.company_address
           FROM DUAL;

         SELECT giacr104_pkg.get_cf_date_paramsformula (p_from_date,
                                                        p_to_date)
           INTO v_giacr104.date_params
           FROM DUAL;

         PIPE ROW (v_giacr104);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2
   IS
      v_company_name   giis_parameters.param_value_v%TYPE;
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
      v_company_address   giis_parameters.param_value_v%TYPE;
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
END giacr104_pkg;
/


