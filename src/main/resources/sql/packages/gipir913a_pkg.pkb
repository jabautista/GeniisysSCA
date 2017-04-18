CREATE OR REPLACE PACKAGE BODY CPI.gipir913a_pkg
AS
   FUNCTION get_gipir913a_record (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipir913a_tab PIPELINED
   IS
      v_list          gipir913a_type;
      v_mortg_count   NUMBER         := 0;
      v_intm_count    NUMBER         := 0;
   BEGIN
      FOR i IN
         (SELECT DISTINCT    h.address1
                          || ' , '
                          || h.address2
                          || ' , '
                          || h.address3 branch_add,
                          h.tel_no, h.branch_fax_no, h.branch_website,
                             d.iss_cd
                          || '-'
                          || LPAD (d.prem_seq_no, 12, 0) bill_no,
                             b.address1
                          || ' '
                          || b.address2
                          || ' '
                          || b.address3 address,
                          a.line_name, c.subline_name,
                             b.line_cd
                          || '-'
                          || b.subline_cd
                          || '-'
                          || b.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                          || '-'
                          || LTRIM (TO_CHAR (renew_no, '09'))
                          || DECODE (NVL (endt_seq_no, 0),
                                     0, '',
                                        ' / '
                                     || endt_iss_cd
                                     || '-'
                                     || LTRIM (TO_CHAR (endt_yy, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (endt_seq_no,
                                                        '0999999')
                                              )
                                    ) POLICY,
                          b.issue_date,
                          DECODE (b.incept_tag,
                                  'Y', 'T.B.A.',
                                  TO_CHAR (DECODE (b.endt_seq_no,
                                                   0, b.incept_date,
                                                   b.eff_date
                                                  ),
                                           'MM/DD/YYYY'
                                          )
                                 ) fromdate,
                          TO_CHAR (DECODE (b.endt_seq_no,
                                           0, b.expiry_date,
                                           b.endt_expiry_date
                                          ),
                                   'MM/DD/YYYY'
                                  ) todate,
                          d.remarks particulars, b.endt_seq_no, b.expiry_tag,
                          b.endt_expiry_tag, d.currency_cd, i.report_id,
                          a.line_cd, e.endt_tax, d.policy_currency,
                          d.currency_rt, d.prem_amt tot_prem, w.assd_name,
                          b.policy_id, d.iss_cd, d.prem_seq_no
                     FROM giis_line a,
                          gipi_polbasic b,
                          giis_subline c,
                          gipi_invoice d,
                          gipi_endttext e,
                          giis_issource h,
                          giis_signatory i,
                          giis_assured w
                    WHERE h.iss_cd = d.iss_cd
                      AND a.line_cd = b.line_cd
                      AND a.line_cd = i.line_cd
                      AND a.line_cd = c.line_cd
                      AND d.policy_id = b.policy_id
                      AND b.policy_id = e.policy_id(+)
                      AND d.policy_id = p_policy_id
                      AND c.subline_cd = b.subline_cd
                      AND w.assd_no = b.assd_no(+))
      LOOP
         IF i.endt_seq_no = 0 AND i.expiry_tag = 'Y'
         THEN
            v_list.todate := 'TBA';
         ELSIF i.endt_seq_no = 0 AND i.endt_expiry_tag = 'Y'
         THEN
            v_list.todate := 'TBA';
         ELSE
            v_list.todate := i.todate;
         END IF;

         IF i.policy_currency = 'Y'
         THEN
            v_list.tot_prem := i.tot_prem;
         ELSE
            v_list.tot_prem := i.tot_prem * i.currency_rt;
         END IF;

         --raise_application_error (-20001,'fromdate-todate = '|| to_number(i.fromdate - i.todate));
         v_list.line_name := i.line_name;
         v_list.subline_name := i.subline_name;
         v_list.POLICY := i.POLICY;
         v_list.issue_date := i.issue_date;
         v_list.fromdate := i.fromdate;
         v_list.todate := i.todate;
         v_list.particulars := i.particulars;
         v_list.branch_add := i.branch_add;
         v_list.tel_no := i.tel_no;
         v_list.branch_fax_no := i.branch_fax_no;
         v_list.branch_website := i.branch_website;
         v_list.bill_no := i.bill_no;
         v_list.address := i.address;
         v_list.logo_file := giisp.v ('LOGO_FILE');
         v_list.tot_prem := i.tot_prem;
         v_list.currency_rt := i.currency_rt;
         v_list.line_cd := i.line_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.prem_seq_no := i.prem_seq_no;
         v_list.policy_currency := i.policy_currency;
         v_list.assd_name := i.assd_name;
         v_list.policy_id := i.policy_id;
         v_list.report_id := i.report_id;

         IF TO_CHAR (i.todate) = 'T.B.A.' OR TO_CHAR (i.fromdate) = 'T.B.A.'
         THEN
            v_list.term := 'T.B.A.';
         ELSE
            v_list.term :=
               TO_CHAR (  TO_DATE (i.todate, 'MM-DD-YYYY')
                        - TO_DATE (i.fromdate, 'MM-DD-YYYY')
                       );
         END IF;

         FOR y IN (SELECT a.pol_flag, b.old_policy_id
                     FROM gipi_polbasic a, gipi_polnrep b
                    WHERE b.new_policy_id = a.policy_id
                      AND a.policy_id = p_policy_id)
         LOOP
            IF y.pol_flag = '2'
            THEN
               v_list.pol_flag :=
                         'Renewing' || ' ' || get_policy_no (y.old_policy_id);
            ELSIF y.pol_flag = '3'
            THEN
               v_list.pol_flag :=
                        'Replacing' || ' ' || get_policy_no (y.old_policy_id);
            ELSE
               v_list.pol_flag := 'New Policy';
            END IF;
         END LOOP;

         FOR r IN (SELECT assd_name assd_name2,
                          DECODE (label_tag,
                                  'Y', 'Leased To :',
                                  'In Account Of :'
                                 ) label_tag
                     FROM giis_assured a, gipi_polbasic b
                    WHERE a.assd_no = b.acct_of_cd(+)
                          AND b.policy_id = p_policy_id)
         LOOP
            IF r.assd_name2 IS NOT NULL
            THEN
               v_list.assd_name2 := (r.label_tag || ' ' || r.assd_name2);
            ELSE
               v_list.assd_name2 := NULL;
            END IF;
         END LOOP;

         SELECT short_name
           INTO v_list.short_name
           FROM giis_currency curr
          WHERE curr.main_currency_cd = i.currency_cd;

         SELECT COUNT (*)
           INTO v_mortg_count
           FROM gipi_mortgagee
          WHERE policy_id = p_policy_id;

         IF v_mortg_count > 1
         THEN
            v_list.mortg_name := 'VARIOUS';
         ELSIF v_mortg_count = 1
         THEN
            SELECT DISTINCT b.mortg_name
                       INTO v_list.mortg_name
                       FROM gipi_mortgagee a, giis_mortgagee b
                      WHERE a.policy_id = p_policy_id
                        AND b.mortg_cd = a.mortg_cd;
         END IF;

         SELECT COUNT (*)
           INTO v_intm_count
           FROM gipi_comm_invoice
          WHERE policy_id = p_policy_id;

         IF v_intm_count > 1
         THEN
            v_list.intm_name := 'VARIOUS';
         ELSIF v_intm_count = 1
         THEN
            SELECT b.intm_name
              INTO v_list.intm_name
              FROM gipi_comm_invoice a, giis_intermediary b, gipi_invoice c
             WHERE a.policy_id = p_policy_id
               AND a.iss_cd = c.iss_cd
               AND a.prem_seq_no = c.prem_seq_no
               AND a.intrmdry_intm_no = b.intm_no;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_gipir913a_record;

   FUNCTION get_gipir913a_taxes (
      p_iss_cd            gipi_invoice.iss_cd%TYPE,
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_prem_seq_no       gipi_invoice.prem_seq_no%TYPE,
      p_policy_currency   gipi_invoice.policy_currency%TYPE,
      p_currency_rt       gipi_invoice.currency_rt%TYPE
   )
      RETURN gipir913a_taxes_tab PIPELINED
   IS
      v_list                 gipir913a_taxes_type;
      v_policy_currency      gipi_invoice.policy_currency%TYPE;
      v_currency_rt          gipi_invoice.currency_rt%TYPE;
      v_cnt                  NUMBER (16)                         := 0;
      v_tax_amt_other        NUMBER (16, 2);
      v_tax_amt_other_desc   VARCHAR2 (20);
   BEGIN
      FOR i IN (SELECT   b.tax_desc, a.tax_cd, a.tax_amt
                    FROM gipi_inv_tax a, giis_tax_charges b
                   WHERE a.prem_seq_no = p_prem_seq_no
                     AND a.line_cd = p_line_cd
                     AND a.iss_cd = p_iss_cd
                     AND b.tax_cd = a.tax_cd
                     AND b.iss_cd = a.iss_cd
                     AND b.tax_id = a.tax_id
                     AND b.line_cd = a.line_cd
                ORDER BY b.SEQUENCE, b.tax_cd)
      LOOP
         v_cnt := v_cnt + 1;

         IF v_cnt >= 5
         THEN
            v_tax_amt_other := v_tax_amt_other + i.tax_amt;
            v_tax_amt_other_desc := 'Other Taxes';
         ELSE
            v_tax_amt_other := 0;
         END IF;
      END LOOP;

      v_list.tax_amt_other := v_tax_amt_other;
      v_list.tax_amt_other_desc := v_tax_amt_other_desc;

      FOR i IN (SELECT   b.tax_desc, a.tax_cd, a.tax_amt
                    FROM gipi_inv_tax a, giis_tax_charges b
                   WHERE a.prem_seq_no = p_prem_seq_no
                     AND a.line_cd = p_line_cd
                     AND a.iss_cd = p_iss_cd
                     AND b.tax_cd = a.tax_cd
                     AND b.iss_cd = a.iss_cd
                     AND b.tax_id = a.tax_id
                     AND b.line_cd = a.line_cd
                ORDER BY b.SEQUENCE, b.tax_cd)
      LOOP
         IF p_policy_currency = 'Y'
         THEN
            v_list.tax_desc := i.tax_desc;
            v_list.tax_amt := i.tax_amt;
         ELSE
            v_list.tax_desc := i.tax_desc;
            v_list.tax_amt := i.tax_amt * p_currency_rt;
         END IF;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gipir913a_signatory (p_report_id VARCHAR2)
      RETURN gipir913a_signatory_tab PIPELINED
   IS
      v_list   gipir913a_signatory_type;
   BEGIN
      FOR i IN (SELECT signatory
                  FROM giis_signatory a,
                       giis_signatory_names b,
                       gipi_polbasic c
                 WHERE 1 = 1
                   AND a.line_cd = c.line_cd
                   AND report_id = p_report_id
                   AND a.iss_cd = c.iss_cd
                   AND a.signatory_id = b.signatory_id
                   AND current_signatory_sw = 'Y'
                   AND b.status = 1)
      LOOP
         v_list.signatory := i.signatory;
         PIPE ROW (v_list);
      END LOOP;
   END get_gipir913a_signatory;
END;
/


