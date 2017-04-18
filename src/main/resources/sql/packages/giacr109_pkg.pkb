CREATE OR REPLACE PACKAGE BODY CPI.giacr109_pkg
AS
   FUNCTION get_giacr_109_report (
      p_branch_cd    VARCHAR2,
      p_include      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_module_id    VARCHAR2,
      p_post_tran    VARCHAR2,
      p_tran_date1   VARCHAR2,
      p_tran_date2   VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list            report_type;
      data_found_flag   VARCHAR2 (1) := 'N';
      v_exist           VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN
         (SELECT   i.tran_date pyt_date, i.tran_class tran_class,
                   /*DECODE (i.tran_class,
                           'COL', DECODE (b.or_no,
                                          NULL, ' ',
                                             'COL '
                                          || b.or_pref_suf
                                          || '-'
                                          || LPAD (b.or_no, 10, 0)
                                         ),
                           'DV', DECODE (m.dv_no,
                                         NULL, ' ',
                                            'DV '
                                         || m.dv_pref
                                         || '-'
                                         || LPAD (m.dv_no, 10, 0)
                                        ),
                           'JV', DECODE (i.tran_class_no,
                                         NULL, ' ',
                                            i.tran_class
                                         || '-'
                                         || LPAD (i.tran_class_no, 10, 0)
                                        ),
                              i.tran_class
                           || CHR (32)
                           || TO_CHAR (i.tran_year, 'FM0999')
                           || '-'
                           || TO_CHAR (i.tran_month, 'FM09')
                           || '-'
                           || LPAD (i.tran_seq_no, 6, 0)
                          ) pyt_ref, */ -- jhing 03.29.2016 GENQA 5302, instead of using decode, use get_ref_no 
                          get_ref_no(i.tran_id) pyt_ref, -- jhing 03.29.2016 GENQA 5302,
                      h.b140_iss_cd
                   || '-'
                   || LPAD (h.b140_prem_seq_no, 12, 0)
                   || '-'
                   || h.inst_no bill_no,
                   h.premium_amt premium, h.collection_amt pyt_amt,
                   f.tax_amt, j.balance_amt_due os_bal, a.line_cd line_cd,
                   get_policy_no (a.policy_id) policy_no, a.ref_pol_no,
                   a.incept_date incept_date, a.expiry_date expiry_date,
                   a.acct_ent_date, a.subline_cd subline_cd, a.iss_cd iss_cd,
                   a.issue_yy issue_yy, a.pol_seq_no pol_seq_no,
                   a.renew_no renew_no, a.endt_iss_cd endt_iss_cd,
                   a.endt_yy endt_yy, a.endt_seq_no endt_seq_no, a.assd_no,
                   a.par_id
              FROM gipi_polbasic a,
                   gipi_invoice d,
                   giac_aging_soa_details j,
                   giac_tax_collns f,
                   giac_direct_prem_collns h,
                   giac_disb_vouchers m,
                   giac_order_of_payts b,
                   giac_acctrans i
             WHERE 1 = 1
               AND d.policy_id = a.policy_id
               AND d.iss_cd = h.b140_iss_cd
               AND d.iss_cd = h.b140_iss_cd
               AND d.prem_seq_no = h.b140_prem_seq_no
               AND d.prem_seq_no = h.b140_prem_seq_no
               AND h.b140_iss_cd = j.iss_cd(+)
               AND h.b140_prem_seq_no = j.prem_seq_no(+)
               AND h.inst_no = j.inst_no(+)
               AND f.b160_tax_cd = giacp.n ('EVAT')
               AND h.gacc_tran_id = f.gacc_tran_id
               AND h.b140_iss_cd = f.b160_iss_cd
               AND h.b140_prem_seq_no = f.b160_prem_seq_no
               AND h.inst_no = f.inst_no
               AND i.tran_id = h.gacc_tran_id(+)
               AND i.tran_id = h.gacc_tran_id(+)
               AND i.tran_id = m.gacc_tran_id(+)
               AND i.tran_id = m.gacc_tran_id(+)
               AND i.tran_id = b.gacc_tran_id(+)
               AND i.tran_id = b.gacc_tran_id(+)
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND i.gibr_branch_cd = NVL (p_branch_cd, i.gibr_branch_cd)
               AND a.iss_cd <> 'BB'
               AND check_user_per_iss_cd_acctg (NULL,
                                                i.gibr_branch_cd,
                                                'GIACS108'
                                               ) = 1
               AND NOT EXISTS (
                      SELECT n.gacc_tran_id
                        FROM giac_reversals n, giac_acctrans o
                       WHERE n.reversing_tran_id = o.tran_id
                         AND o.tran_flag <> 'D'
                         AND n.gacc_tran_id = h.gacc_tran_id)
               AND NOT EXISTS (
                      SELECT p.gacc_tran_id
                        FROM giac_advanced_payt p
                       WHERE p.gacc_tran_id = h.gacc_tran_id
                         AND p.iss_cd = h.b140_iss_cd
                         AND p.prem_seq_no = h.b140_prem_seq_no
                         AND p.inst_no = h.inst_no
                         /*AND (   p.acct_ent_date IS NULL           -- jhing 03.29.2016 commented out conditions for acct_ent_date - GENQA 5302
                              OR TRUNC (p.acct_ent_date) >=
                                    TRUNC (TO_DATE (p_tran_date2,
                                                    'MM-dd-YYYY')
                                          )
                             )*/ )
               AND i.tran_flag != 'D'
               AND (   (    p_post_tran = 'P'
                        AND TRUNC (i.posting_date)
                               BETWEEN TO_DATE (p_tran_date1, 'MM-dd-YYYY')
                                   AND TO_DATE (p_tran_date2, 'MM-dd-YYYY')
                       )
                    OR (    p_post_tran = 'T'
                        AND TRUNC (i.tran_date) BETWEEN TO_DATE (p_tran_date1,
                                                                 'MM-dd-YYYY'
                                                                )
                                                    AND TO_DATE (p_tran_date2,
                                                                 'MM-dd-YYYY'
                                                                )
                       )
                   )
          UNION
          SELECT   i.tran_date pyt_date, i.tran_class tran_class,
                   /*DECODE (i.tran_class,
                           'COL', DECODE (b.or_no,
                                          NULL, ' ',
                                             'COL '
                                          || b.or_pref_suf
                                          || '-'
                                          || LPAD (b.or_no, 10, 0)
                                         ),
                           'DV', DECODE (m.dv_no,
                                         NULL, ' ',
                                            'DV '
                                         || m.dv_pref
                                         || '-'
                                         || LPAD (m.dv_no, 10, 0)
                                        ),
                           'JV', DECODE (i.tran_class_no,
                                         NULL, ' ',
                                            i.tran_class
                                         || '-'
                                         || LPAD (i.tran_class_no, 10, 0)
                                        ),
                              i.tran_class
                           || CHR (32)
                           || TO_CHAR (i.tran_year, '0999')
                           || '-'
                           || TO_CHAR (i.tran_month, '09')
                           || '-'
                           || LPAD (i.tran_seq_no, 6, 0)
                          ) pyt_ref, */ -- jhing 03.29.2016 GENQA 5302, instead of using DECODE , use get_ref_no 
                          get_ref_no(i.tran_id) pyt_ref,
                      h.b140_iss_cd
                   || '-'
                   || LPAD (h.b140_prem_seq_no, 12, 0)   -- jhing 03.29.2016 added padding to ensure CSV and PDF are consistent with format of bill no
                   || '-'
                   || h.inst_no bill_no,
                   h.premium_amt premium, h.collection_amt pyt_amt, f.tax_amt,
                   j.balance_amt_due os_bal, a.line_cd line_cd,
                   get_policy_no (a.policy_id) policy_no, a.ref_pol_no,
                   a.incept_date incept_date, a.expiry_date expiry_date,
                   a.acct_ent_date, a.subline_cd subline_cd, a.iss_cd iss_cd,
                   a.issue_yy issue_yy, a.pol_seq_no pol_seq_no,
                   a.renew_no renew_no, a.endt_iss_cd endt_iss_cd,
                   a.endt_yy endt_yy, a.endt_seq_no endt_seq_no, a.assd_no,
                   a.par_id
              FROM gipi_polbasic a,
                   gipi_invoice d,
                   giac_aging_soa_details j,
                   giac_tax_collns f,
                   giac_direct_prem_collns h,
                   giac_disb_vouchers m,
                   giac_order_of_payts b,
                   giac_acctrans i,
                   giac_advanced_payt p
             WHERE 1 = 1
               AND d.policy_id = a.policy_id
               AND d.iss_cd = h.b140_iss_cd
               AND d.iss_cd = h.b140_iss_cd
               AND d.prem_seq_no = h.b140_prem_seq_no
               AND d.prem_seq_no = h.b140_prem_seq_no
               AND j.iss_cd(+) = h.b140_iss_cd
               AND j.prem_seq_no(+) = h.b140_prem_seq_no
               AND j.inst_no(+) = h.inst_no
               AND f.b160_tax_cd = giacp.n ('EVAT')
               AND h.gacc_tran_id = f.gacc_tran_id
               AND i.tran_id = p.gacc_tran_id
               AND h.gacc_tran_id = p.gacc_tran_id
               AND h.b140_iss_cd = p.iss_cd
               AND h.b140_prem_seq_no = p.prem_seq_no
               AND h.inst_no = p.inst_no
               AND h.b140_iss_cd = f.b160_iss_cd
               AND h.b140_prem_seq_no = f.b160_prem_seq_no
               AND h.inst_no = f.inst_no
               AND i.tran_id = h.gacc_tran_id(+)
               AND i.tran_id = h.gacc_tran_id(+)
               AND i.tran_id = m.gacc_tran_id(+)
               AND i.tran_id = m.gacc_tran_id(+)
               AND i.tran_id = b.gacc_tran_id(+)
               AND i.tran_id = b.gacc_tran_id(+)
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND i.gibr_branch_cd = NVL (p_branch_cd, i.gibr_branch_cd)
               AND a.iss_cd <> 'BB'
               AND check_user_per_iss_cd_acctg (NULL,
                                                i.gibr_branch_cd,
                                                'GIACS108'
                                               ) = 1
               AND NOT EXISTS (
                      SELECT n.gacc_tran_id
                        FROM giac_reversals n, giac_acctrans o
                       WHERE n.reversing_tran_id = o.tran_id
                         AND o.tran_flag <> 'D'
                         AND n.gacc_tran_id = h.gacc_tran_id)
               AND p.acct_ent_date BETWEEN TO_DATE (p_tran_date1,
                                                    'MM-dd-YYYY')
                                       AND TO_DATE (p_tran_date2,
                                                    'MM-dd-YYYY')
          ORDER BY line_cd,
                   subline_cd,
                   iss_cd,
                   issue_yy,
                   pol_seq_no,
                   renew_no,
                   endt_iss_cd,
                   endt_yy,
                   endt_seq_no)
      LOOP
         FOR line IN (SELECT line_name
                        FROM giis_line
                       WHERE line_cd = i.line_cd)
         LOOP
            v_list.line_nm := line.line_name;
         END LOOP;

         v_list.policy_no := i.policy_no;
         v_list.ref_pol_no := i.ref_pol_no;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;
         v_list.acct_ent_date := i.acct_ent_date;
         v_list.invoice_no := i.bill_no;
         v_list.premium := NVL(i.premium, 0);
         v_list.pyt_date := i.pyt_date;
         v_list.pyt_ref := i.pyt_ref;
         v_list.pyt_amt := NVL(i.pyt_amt, 0);
         v_list.os_bal := NVL(i.os_bal, 0);

         BEGIN
            FOR a IN (SELECT assd_name, assd_tin,
                                NVL (mail_addr1, ' ')
                             || ' '
                             || NVL (mail_addr2, ' ')
                             || ' '
                             || NVL (mail_addr3, ' ') address
                        FROM giis_assured
                       WHERE assd_no = i.assd_no)
            LOOP
               data_found_flag := 'Y';
               v_list.cp_tin := a.assd_tin;
               v_list.cp_addr := a.address;
               v_list.client := a.assd_name;
            END LOOP;

            IF data_found_flag = 'N'
            THEN
               FOR b IN (SELECT assd_name, assd_tin,
                                   NVL (mail_addr1, ' ')
                                || ' '
                                || NVL (mail_addr2, ' ')
                                || ' '
                                || NVL (mail_addr3, ' ') address
                           FROM giis_assured
                          WHERE assd_no IN (SELECT assd_no
                                              FROM gipi_parlist
                                             WHERE par_id = i.par_id))
               LOOP
                  v_list.cp_tin := b.assd_tin;
                  v_list.cp_addr := b.address;
                  v_list.client := b.assd_name;
               END LOOP;
            END IF;
         END;

         IF NVL (i.tax_amt, 0) = 0
         THEN
            v_list.evat := 0;
         ELSE
            v_list.evat := i.tax_amt;
         END IF;

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

         BEGIN
            IF NVL (i.premium, 0) = 0
            THEN
               v_list.cf_premium := 0;
            ELSE
               v_list.cf_premium := i.premium;
            END IF;
         END;

         BEGIN
            IF NVL (i.premium, 0) = 0
            THEN
               v_list.cf_os_bal := 0;
            ELSE
               v_list.cf_os_bal := i.os_bal;
            END IF;
         END;

         BEGIN
            IF NVL (i.tax_amt, 0) = 0
            THEN
               v_list.cf_evat := 0;
            ELSE
               v_list.cf_evat := i.tax_amt;
            END IF;
         END;

         BEGIN
            IF NVL (i.premium, 0) = 0
            THEN
               v_list.cf_pyt_amt := 0;
            ELSE
               v_list.cf_pyt_amt := i.pyt_amt;
            END IF;
         END;
         
         v_exist := 'Y';
         v_list.exist := 'Y';
         
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_exist = 'N' THEN
         v_list.exist := 'N';
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
         
         PIPE ROW (v_list);
      END IF;
      
   END get_giacr_109_report;

   FUNCTION get_giacr109_inwardreport (
      p_branch_cd    VARCHAR2,
      p_line_cd      VARCHAR2,
      p_post_tran    VARCHAR2,
      p_tran_date1   VARCHAR2,
      p_tran_date2   VARCHAR2
   )
      RETURN giacr109_inward_tab PIPELINED
   IS
      v_list            giacr109_inward_type;
      data_found_flag   VARCHAR2 (1)         := 'N';
   BEGIN
      FOR i IN
         (SELECT   i.tran_date pyt_date, i.tran_class tran_class,
                   /*DECODE (i.tran_class,
                           'COL', DECODE (b.or_no,
                                          NULL, ' ',
                                             'COL '
                                          || b.or_pref_suf
                                          || '-'
                                          || TO_CHAR (b.or_no)
                                         ),
                           'DV', DECODE (m.dv_no,
                                         NULL, ' ',
                                            'DV '
                                         || m.dv_pref
                                         || '-'
                                         || TO_CHAR (m.dv_no)
                                        ),
                           'JV', DECODE (i.tran_class_no,
                                         NULL, ' ',
                                            i.tran_class
                                         || '-'
                                         || TO_CHAR (i.tran_class_no)
                                        ),
                           TO_CHAR (i.jv_no)
                          ) pyt_ref,*/ -- jhing 03.29.2016 GENQA 5302, instead of using DECODE , use get_ref_no 
                          get_ref_no(i.tran_id) pyt_ref,
                      h.b140_iss_cd
                   || '-'
                   || LPAD (h.b140_prem_seq_no, 12, 0)   -- jhing 03.29.2016 added padding to ensure CSV and PDF are consistent with format of bill no
                   || '-'
                   || h.inst_no bill_no,
                   h.premium_amt premium, h.collection_amt pyt_amt,
                   h.tax_amount, j.balance_due os_bal, a.line_cd line_cd,
                   get_policy_no (a.policy_id) policy_no, a.ref_pol_no,
                   a.incept_date incept_date, a.expiry_date expiry_date,
                   a.acct_ent_date, a.subline_cd subline_cd, a.iss_cd iss_cd,
                   a.issue_yy issue_yy, a.pol_seq_no pol_seq_no,
                   a.renew_no renew_no, a.endt_iss_cd endt_iss_cd,
                   a.endt_yy endt_yy, a.endt_seq_no endt_seq_no, a.assd_no,
                   a.par_id
              FROM gipi_polbasic a,
                   gipi_invoice d,
                   giac_aging_ri_soa_details j,
                   giac_inwfacul_prem_collns h,
                   giac_disb_vouchers m,
                   giac_order_of_payts b,
                   giac_acctrans i
             WHERE 1 = 1
               AND d.policy_id = a.policy_id
               AND d.iss_cd = h.b140_iss_cd
               AND d.iss_cd = h.b140_iss_cd
               AND d.prem_seq_no = h.b140_prem_seq_no
               AND d.prem_seq_no = h.b140_prem_seq_no
               AND h.b140_prem_seq_no = j.prem_seq_no(+)
               AND h.inst_no = j.inst_no(+)
               AND i.tran_id = h.gacc_tran_id(+)
               AND i.tran_id = h.gacc_tran_id(+)
               AND i.tran_id = m.gacc_tran_id(+)
               AND i.tran_id = m.gacc_tran_id(+)
               AND i.tran_id = b.gacc_tran_id(+)
               AND i.tran_id = b.gacc_tran_id(+)
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND i.gibr_branch_cd = NVL (p_branch_cd, i.gibr_branch_cd)
               AND a.iss_cd <> 'BB'
               AND check_user_per_iss_cd_acctg (NULL,
                                                i.gibr_branch_cd,
                                                'GIACS108'
                                               ) = 1
               AND NOT EXISTS (
                      SELECT n.gacc_tran_id
                        FROM giac_reversals n, giac_acctrans o
                       WHERE n.reversing_tran_id = o.tran_id
                         AND o.tran_flag <> 'D'
                         AND n.gacc_tran_id = h.gacc_tran_id)
               AND NOT EXISTS (
                      SELECT p.gacc_tran_id
                        FROM giac_advanced_payt p
                       WHERE p.gacc_tran_id = h.gacc_tran_id
                         AND p.iss_cd = h.b140_iss_cd
                         AND p.prem_seq_no = h.b140_prem_seq_no
                         AND p.inst_no = h.inst_no
                         AND (   p.acct_ent_date IS NULL
                              OR TRUNC (p.acct_ent_date) >=
                                    TRUNC (TO_DATE (p_tran_date2,
                                                    'MM-dd-YYYY')
                                          )
                             ))
               AND i.tran_class IN ('COL', 'DV', 'JV')
               AND i.tran_flag != 'D'
               AND (   (    p_post_tran = 'P'
                        AND TRUNC (i.posting_date)
                               BETWEEN TO_DATE (p_tran_date1, 'MM-dd-YYYY')
                                   AND TO_DATE (p_tran_date2, 'MM-dd-YYYY')
                       )
                    OR (    p_post_tran = 'T'
                        AND TRUNC (i.tran_date) BETWEEN TO_DATE (p_tran_date1,
                                                                 'MM-dd-YYYY'
                                                                )
                                                    AND TO_DATE (p_tran_date2,
                                                                 'MM-dd-YYYY'
                                                                )
                       )
                   )
          UNION
          SELECT   i.tran_date pyt_date, i.tran_class tran_class,
                   /*DECODE (i.tran_class,
                           'COL', DECODE (b.or_no,
                                          NULL, ' ',
                                             'COL '
                                          || b.or_pref_suf
                                          || '-'
                                          || TO_CHAR (b.or_no)
                                         ),
                           'DV', DECODE (m.dv_no,
                                         NULL, ' ',
                                            'DV '
                                         || m.dv_pref
                                         || '-'
                                         || TO_CHAR (m.dv_no)
                                        ),
                           'JV', DECODE (i.tran_class_no,
                                         NULL, ' ',
                                            i.tran_class
                                         || '-'
                                         || TO_CHAR (i.tran_class_no)
                                        ),
                           TO_CHAR (i.jv_no)
                          ) pyt_ref,*/ -- jhing 03.29.2016 GENQA 5302, instead of using DECODE , use get_ref_no 
                      get_ref_no(i.tran_id) pyt_ref,
                      h.b140_iss_cd
                   || '-'
                   || LPAD (h.b140_prem_seq_no, 12, 0) -- jhing 03.29.2016 added padding to ensure CSV and PDF are consistent with format of bill no
                   || '-'
                   || h.inst_no bill_no,
                   h.premium_amt premium, h.collection_amt pyt_amt,
                   h.tax_amount, j.balance_due os_bal, a.line_cd line_cd,
                   get_policy_no (a.policy_id) policy_no, a.ref_pol_no,
                   a.incept_date incept_date, a.expiry_date expiry_date,
                   a.acct_ent_date, a.subline_cd subline_cd, a.iss_cd iss_cd,
                   a.issue_yy issue_yy, a.pol_seq_no pol_seq_no,
                   a.renew_no renew_no, a.endt_iss_cd endt_iss_cd,
                   a.endt_yy endt_yy, a.endt_seq_no endt_seq_no, a.assd_no,
                   a.par_id
              FROM gipi_polbasic a,
                   gipi_invoice d,
                   giac_aging_ri_soa_details j,
                   giac_inwfacul_prem_collns h,
                   giac_disb_vouchers m,
                   giac_order_of_payts b,
                   giac_acctrans i,
                   giac_advanced_payt p
             WHERE 1 = 1
               AND d.policy_id = a.policy_id
               AND d.iss_cd = h.b140_iss_cd
               AND d.iss_cd = h.b140_iss_cd
               AND d.prem_seq_no = h.b140_prem_seq_no
               AND d.prem_seq_no = h.b140_prem_seq_no
               AND h.b140_prem_seq_no = j.prem_seq_no(+)
               AND h.inst_no = j.inst_no(+)
               AND i.tran_id = p.gacc_tran_id
               AND h.gacc_tran_id = p.gacc_tran_id
               AND h.b140_iss_cd = p.iss_cd
               AND h.b140_prem_seq_no = p.prem_seq_no
               AND h.inst_no = p.inst_no
               AND i.tran_id = h.gacc_tran_id(+)
               AND i.tran_id = h.gacc_tran_id(+)
               AND i.tran_id = m.gacc_tran_id(+)
               AND i.tran_id = m.gacc_tran_id(+)
               AND i.tran_id = b.gacc_tran_id(+)
               AND i.tran_id = b.gacc_tran_id(+)
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND i.gibr_branch_cd = NVL (p_branch_cd, i.gibr_branch_cd)
               AND a.iss_cd <> 'BB'
               AND check_user_per_iss_cd_acctg (NULL,
                                                i.gibr_branch_cd,
                                                'GIACS108'
                                               ) = 1
               AND NOT EXISTS (
                      SELECT n.gacc_tran_id
                        FROM giac_reversals n,
                             giac_acctrans o,
                             giac_inwfacul_prem_collns h
                       WHERE n.reversing_tran_id = o.tran_id
                         AND o.tran_flag <> 'D'
                         AND n.gacc_tran_id = h.gacc_tran_id)
               AND p.acct_ent_date BETWEEN TO_DATE (p_tran_date1,
                                                    'MM-dd-YYYY')
                                       AND TO_DATE (p_tran_date2,
                                                    'MM-dd-YYYY')
          ORDER BY line_cd,
                   subline_cd,
                   iss_cd,
                   issue_yy,
                   pol_seq_no,
                   renew_no,
                   endt_iss_cd,
                   endt_yy,
                   endt_seq_no)
      LOOP
         FOR line IN (SELECT line_name
                        FROM giis_line
                       WHERE line_cd = i.line_cd)
         LOOP
            v_list.line_name := line.line_name;
         END LOOP;

         v_list.policy_no := i.policy_no;
         v_list.ref_pol_no := i.ref_pol_no;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;
         v_list.acct_ent_date := i.acct_ent_date;
         v_list.invoice_no := i.bill_no;
         v_list.premium := i.premium;
         v_list.pyt_date := i.pyt_date;
         v_list.pyt_ref := i.pyt_ref;
         v_list.pyt_amt := i.pyt_amt;
         v_list.os_bal := i.os_bal;

         BEGIN
            FOR a IN (SELECT assd_name, assd_tin,
                                NVL (mail_addr1, ' ')
                             || ' '
                             || NVL (mail_addr2, ' ')
                             || ' '
                             || NVL (mail_addr3, ' ') address
                        FROM giis_assured
                       WHERE assd_no = i.assd_no)
            LOOP
               data_found_flag := 'Y';
               v_list.cp_tin := a.assd_tin;
               v_list.cp_addr := a.address;
               v_list.client := a.assd_name;
            END LOOP;

            IF data_found_flag = 'N'
            THEN
               FOR b IN (SELECT assd_name, assd_tin,
                                   NVL (mail_addr1, ' ')
                                || ' '
                                || NVL (mail_addr2, ' ')
                                || ' '
                                || NVL (mail_addr3, ' ') address
                           FROM giis_assured
                          WHERE assd_no IN (SELECT assd_no
                                              FROM gipi_parlist
                                             WHERE par_id = i.par_id))
               LOOP
                  v_list.cp_tin := b.assd_tin;
                  v_list.cp_addr := b.address;
                  v_list.client := b.assd_name;
               END LOOP;
            END IF;
         END;
         
         IF NVL (i.tax_amount, 0) = 0
         THEN
            v_list.evat := 0;
         ELSE
            v_list.evat := i.tax_amount;
         END IF;

         IF NVL (i.tax_amount, 0) = 0
         THEN
            v_list.cf_evat := 0;
         ELSE
            v_list.cf_evat := i.tax_amount;
         END IF;
         
         BEGIN
            IF NVL (i.premium, 0) = 0
            THEN
               v_list.cf_premium := 0;
            ELSE
               v_list.cf_premium := i.premium;
            END IF;
         END;

         BEGIN
            IF NVL (i.premium, 0) = 0
            THEN
               v_list.cf_os_bal := 0;
            ELSE
               v_list.cf_os_bal := i.os_bal;
            END IF;
         END;

         BEGIN
            IF NVL (i.premium, 0) = 0
            THEN
               v_list.cf_pyt_amt := 0;
            ELSE
               v_list.cf_pyt_amt := i.pyt_amt;
            END IF;
         END;

         PIPE ROW (v_list);
      END LOOP;
   END get_giacr109_inwardreport;
END;
/


