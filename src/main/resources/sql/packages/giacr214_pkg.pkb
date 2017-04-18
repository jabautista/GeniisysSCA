CREATE OR REPLACE PACKAGE BODY CPI.giacr214_pkg
AS
   FUNCTION get_giacr214_details (
      p_from_date   DATE,
      p_to_date     DATE,
      p_tran_post   VARCHAR2,
      p_include     VARCHAR2, --vondanix 12.16.15 RSIC GENQA 5223
      p_branch_cd   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr214_tab PIPELINED
   IS
      v_giacr214   giacr214_type;
   BEGIN
      FOR i IN (SELECT   e.gacc_gibr_branch_cd || '-'
                         || gb.branch_name branch,
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
                         DECODE (d.tran_class,
                                 'COL', b.payor,
                                 'DV', c.payee
                                ) NAME,
                         d.tran_class tran_class, d.tran_date tran_date,
--                       changed to get_ref_no by robert SR 5223 03.11.16
--                         DECODE (d.tran_class,
--                                 'COL', DECODE (b.or_no,
--                                                NULL, ' ',
--                                                   b.or_pref_suf
--                                                || '-'
--                                                || LPAD (b.or_no, 10, 0)
--                                               ),
--                                 'DV', DECODE (c.dv_no,
--                                               NULL, ' ',
--                                                  c.dv_pref
--                                               || '-'
--                                               || LPAD (c.dv_no, 10, 0)
--                                              ),
--                                 'JV', DECODE (d.jv_no,
--                                               NULL, ' ',
--                                                  d.tran_class
--                                               || '-'
--                                               || LPAD (d.jv_no, 6.0)
--                                              ),
--                                    d.tran_class
--                                 || '-'
--                                 || TO_CHAR (d.tran_year)
--                                 || '-'
--                                 || TO_CHAR (d.tran_month)
--                                 || '-'
--                                 || LPAD (d.tran_seq_no, 6, 0)
--                                ) ref_no,
                         get_ref_no(e.gacc_tran_id) ref_no,
                         DECODE (NVL (e.debit_amt, 0),
                                 0, e.credit_amt * -1,
                                 e.debit_amt - NVL ((e.credit_amt), 0)
                                ) input_vat,
                         DECODE (d.tran_class,
                                 'COL', b.particulars,
                                 'DV', c.particulars,
                                 'JV', d.particulars
                                ) particulars,
                         e.sl_source_cd, e.sl_cd, e.sl_type_cd, c.payee_no,
                         c.payee_class_cd
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
                ORDER BY 1, 2, 3, 7)
      LOOP
         v_giacr214.branch := i.branch;
         v_giacr214.payee_no := i.payee_no;
         v_giacr214.payee_class_cd := i.payee_class_cd;
         v_giacr214.particulars := i.particulars;
         v_giacr214.tran_date := TO_CHAR (i.tran_date, 'MM-DD-RRRR');
         v_giacr214.tran_class := i.tran_class;
         v_giacr214.NAME := i.NAME;
         v_giacr214.input_vat := i.input_vat;
         v_giacr214.ref_no := i.ref_no;
         v_giacr214.joy := i.joy;
         v_giacr214.sl_cd := i.sl_cd;
         v_giacr214.sl_source_cd := i.sl_source_cd;
         v_giacr214.sl_type_cd := i.sl_type_cd;

         SELECT giacr214_pkg.get_cf_amt_o_vatformula (v_giacr214.input_vat)
           INTO v_giacr214.amt_o_vat
           FROM DUAL;

         SELECT giacr214_pkg.get_cf_sl_nameformula (v_giacr214.sl_cd,
                                                    v_giacr214.sl_source_cd,
                                                    v_giacr214.sl_type_cd,
                                                    v_giacr214.payee_no
                                                   )
           INTO v_giacr214.sl_name
           FROM DUAL;

         SELECT giacr214_pkg.get_cf_tinformula (v_giacr214.sl_cd,
                                                v_giacr214.sl_source_cd,
                                                v_giacr214.sl_type_cd,
                                                v_giacr214.payee_no,
                                                v_giacr214.payee_class_cd
                                               )
           INTO v_giacr214.tin
           FROM DUAL;

         SELECT giacr214_pkg.get_cf_addformula (v_giacr214.sl_cd,
                                                v_giacr214.sl_source_cd,
                                                v_giacr214.sl_type_cd,
                                                v_giacr214.payee_no,
                                                v_giacr214.payee_class_cd
                                               )
           INTO v_giacr214.address
           FROM DUAL;

         SELECT giacr214_pkg.get_cf_company_nameformula
           INTO v_giacr214.company_name
           FROM DUAL;

         SELECT giacr214_pkg.get_cf_company_addformula
           INTO v_giacr214.company_address
           FROM DUAL;

         SELECT giacr214_pkg.get_cf_date_paramsformula (p_from_date,
                                                        p_to_date)
           INTO v_giacr214.date_params
           FROM DUAL;

         PIPE ROW (v_giacr214);
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

   FUNCTION get_cf_amt_o_vatformula (
      p_input_vat   giac_comm_payts.input_vat_amt%TYPE
   )
      RETURN NUMBER
   IS
      v_amt_o_vat        NUMBER;
      v_input_vat_rate   NUMBER;
   BEGIN
      SELECT param_value_n / 100
        INTO v_input_vat_rate
        FROM giac_parameters
       WHERE param_name = 'INPUT_VAT_RT';

      v_amt_o_vat := p_input_vat / v_input_vat_rate;
      RETURN (ROUND (v_amt_o_vat, 2));
   END;

   FUNCTION get_cf_sl_nameformula (
      p_sl_cd          giac_acct_entries.sl_cd%TYPE,
      p_sl_source_cd   giac_acct_entries.sl_source_cd%TYPE,
      p_sl_type_cd     giac_acct_entries.sl_type_cd%TYPE,
      p_payee_no       giac_disb_vouchers.payee_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_amt_o_vat        NUMBER;
      v_input_vat_rate   NUMBER;
      v_sl_nm            VARCHAR2 (1000);
   BEGIN
      IF p_sl_cd IS NOT NULL
      THEN
         IF p_sl_source_cd = '2'
         THEN
            BEGIN
               SELECT DECODE (payee_first_name,
                              NULL, payee_last_name
                               || ' '
                               || payee_first_name
                               || ' '
                               || payee_middle_name
                               || '  *',
                                 payee_last_name
                              || ', '
                              || payee_first_name
                              || ' '
                              || payee_middle_name
                              || '  *'
                             ) sl_nm
                 INTO v_sl_nm
                 FROM giis_payees a, giis_payee_class b
                WHERE a.payee_class_cd = b.payee_class_cd
                  AND b.sl_type_cd = p_sl_type_cd
                  AND a.payee_no = p_payee_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_sl_nm := '_invalid PAYEE_';
            END;
         ELSE
            BEGIN
               SELECT sl_name sl_nm
                 INTO v_sl_nm
                 FROM giac_sl_lists
                WHERE sl_type_cd = p_sl_type_cd AND sl_cd = p_sl_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_sl_nm := '_invalid SL_';
            END;
         END IF;

         RETURN (v_sl_nm);
      ELSE
         RETURN ('_______No SL Code_______');
      END IF;

      RETURN NULL;
   END;

   FUNCTION get_cf_tinformula (
      p_sl_cd            giac_acct_entries.sl_cd%TYPE,
      p_sl_source_cd     giac_acct_entries.sl_source_cd%TYPE,
      p_sl_type_cd       giac_acct_entries.sl_type_cd%TYPE,
      p_payee_no         giac_disb_vouchers.payee_no%TYPE,
      p_payee_class_cd   giac_disb_vouchers.payee_class_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_tin   VARCHAR2 (30);
   BEGIN
      IF p_sl_cd IS NOT NULL
      THEN
         IF p_sl_source_cd = '2'
         THEN
            BEGIN
               SELECT tin
                 INTO v_tin
                 FROM giis_payee_class gpc, giis_payees gp
                WHERE gpc.payee_class_cd = gp.payee_class_cd
                  AND gpc.payee_class_cd = p_payee_class_cd
                  AND payee_no = p_payee_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_tin := '_invalid PAYEE_';
            END;

            RETURN (v_tin);
         ELSE
            BEGIN
               SELECT tin
                 INTO v_tin
                 FROM giis_payee_class gpc, giis_payees gp, giac_sl_lists gsl
                WHERE gpc.payee_class_cd = gp.payee_class_cd
                  AND gpc.sl_type_cd = gsl.sl_type_cd
                  AND gsl.sl_type_cd = p_sl_type_cd
                  AND sl_cd = p_sl_cd
                  AND payee_no = p_sl_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_tin := '_invalid SL_';
            END;

            RETURN (v_tin);
         END IF;
      END IF;
      
      RETURN (v_tin);   -- shan 07.31.2014
   END;

   FUNCTION get_cf_addformula (
      p_sl_cd            giac_acct_entries.sl_cd%TYPE,
      p_sl_source_cd     giac_acct_entries.sl_source_cd%TYPE,
      p_sl_type_cd       giac_acct_entries.sl_type_cd%TYPE,
      p_payee_no         giac_disb_vouchers.payee_no%TYPE,
      p_payee_class_cd   giac_disb_vouchers.payee_class_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_add   VARCHAR2 (200);
   BEGIN
      IF p_sl_cd IS NOT NULL
      THEN
         IF p_sl_source_cd = '2'
         THEN
            BEGIN
               SELECT mail_addr1 || ' ' || mail_addr2 || ' ' || mail_addr3
                                                                      address
                 INTO v_add
                 FROM giis_payees a, giis_payee_class b
                WHERE a.payee_class_cd = b.payee_class_cd
                  AND b.sl_type_cd = p_sl_type_cd
                  AND a.payee_no = p_payee_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_add := '_invalid PAYEE_';
            END;
         ELSE
            BEGIN
               SELECT mail_addr1 || ' ' || mail_addr2 || ' ' || mail_addr3
                                                                      address
                 INTO v_add
                 FROM giis_payee_class gpc, giis_payees gp, giac_sl_lists gsl
                WHERE gpc.payee_class_cd = gp.payee_class_cd
                  AND gpc.sl_type_cd = gsl.sl_type_cd
                  AND gsl.sl_type_cd = p_sl_type_cd
                  AND sl_cd = p_sl_cd
                  AND payee_no = p_sl_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_add := '_invalid SL_';
            END;
         END IF;

         RETURN (v_add);
      ELSE
         RETURN ('_______No SL Code_______');
      END IF;

      RETURN NULL;
   END;
END giacr214_pkg;
/


