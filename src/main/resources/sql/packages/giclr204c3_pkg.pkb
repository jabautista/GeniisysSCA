CREATE OR REPLACE PACKAGE BODY CPI.giclr204c3_pkg
AS
   FUNCTION get_giclr_204c3_report (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN (SELECT   b.iss_cd iss_cd2, b.assd_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')) POLICY,
                         a.policy_id, a.endt_iss_cd, a.endt_yy,
                         a.endt_seq_no, a.incept_date, a.expiry_date,
                         a.tsi_amt, SUM (b.prem_amt) prem_amt, c.iss_name,
                         d.assd_name, a.iss_cd,
                         TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 ) MONTH
                    FROM gipi_polbasic a,
                         gicl_lratio_curr_prem_ext b,
                         giis_issource c,
                         giis_assured d
                   WHERE b.policy_id = a.policy_id
                     AND b.assd_no = d.assd_no(+)
                     AND b.iss_cd = c.iss_cd(+)
                     AND b.session_id = p_session_id
                GROUP BY b.iss_cd,
                         b.assd_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')),
                         a.policy_id,
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.iss_name,
                         d.assd_name,
                         a.iss_cd,
                         TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 )
                ORDER BY MONTH DESC, POLICY)
      LOOP
         BEGIN
            SELECT param_value_v
              INTO v_list.company_name
              FROM giis_parameters
             WHERE param_name = 'COMPANY_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_name := '';
         END;

         BEGIN
            SELECT param_value_v
              INTO v_list.company_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_address := '';
         END;

         PIPE ROW (v_list);
      END LOOP;
      
      IF v_list.company_name IS NULL THEN
         BEGIN
            SELECT param_value_v
              INTO v_list.company_name
              FROM giis_parameters
             WHERE param_name = 'COMPANY_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_name := '';
         END;

         BEGIN
            SELECT param_value_v
              INTO v_list.company_address
              FROM giis_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.company_address := '';
         END;
      
         PIPE ROW (v_list);
      END IF;
   END get_giclr_204c3_report;

   FUNCTION get_giclr_204c3_q1 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_tab PIPELINED
   IS
      v_list   giclr204c3_type;
   BEGIN
      FOR i IN (SELECT   b.iss_cd iss_cd2, b.assd_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')) POLICY,
                         a.policy_id, a.endt_iss_cd, a.endt_yy,
                         a.endt_seq_no, a.incept_date, a.expiry_date,
                         a.tsi_amt, SUM (b.prem_amt) prem_amt, c.iss_name,
                         d.assd_name, a.iss_cd,
                         TO_CHAR (date_for_24th, 'MONTH YYYY') MONTH
                    FROM gipi_polbasic a,
                         gicl_lratio_curr_prem_ext b,
                         giis_issource c,
                         giis_assured d
                   WHERE b.policy_id = a.policy_id
                     AND b.assd_no = d.assd_no(+)
                     AND b.iss_cd = c.iss_cd(+)
                     AND b.session_id = p_session_id
                GROUP BY b.iss_cd,
                         b.assd_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')),
                         a.policy_id,
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.iss_name,
                         d.assd_name,
                         a.iss_cd,
                         TO_CHAR (date_for_24th, 'MONTH YYYY')
                ORDER BY iss_cd2,
                         TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 ) DESC,
                         POLICY)
      LOOP
         v_list.iss := i.iss_cd2 || ' - ' || i.iss_name;
         v_list.MONTH := i.MONTH;

         IF i.endt_seq_no != 0
         THEN
            v_list.POLICY :=
                  i.POLICY
               || '/'
               || i.endt_iss_cd
               || '-'
               || TO_CHAR (i.endt_yy)
               || '-'
               || TO_CHAR (i.endt_seq_no);
         ELSE
            v_list.POLICY := i.POLICY;
         END IF;

         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;

         IF p_print_date = 1
         THEN
            FOR rec IN (SELECT issue_date
                          FROM gipi_polbasic
                         WHERE policy_id = i.policy_id)
            LOOP
               v_list.cf_date := TO_CHAR (rec.issue_date, 'MM-DD-RRRR');
            END LOOP;
         ELSIF p_print_date = 3
         THEN
            FOR rec IN (SELECT acct_ent_date
                          FROM gipi_polbasic
                         WHERE policy_id = i.policy_id)
            LOOP
               v_list.cf_date := TO_CHAR (rec.acct_ent_date, 'MM-DD-RRRR');
            END LOOP;
         ELSIF p_print_date = 4
         THEN
            FOR rec IN (SELECT    booking_mth
                               || ' '
                               || TO_CHAR (booking_year) booking_date
                          FROM gipi_polbasic
                         WHERE policy_id = i.policy_id)
            LOOP
               v_list.cf_date := rec.booking_date;
            END LOOP;
         ELSE
            v_list.cf_date := NULL;
         END IF;

         v_list.prem_amt := i.prem_amt;
         v_list.tsi_amt := i.tsi_amt;

         IF p_curr1_24 IS NOT NULL AND p_curr_24 IS NOT NULL
         THEN
            v_list.page_header :=
                  'Premiums Written for the Period '
               || TO_CHAR (TO_DATE (p_curr1_24, 'mm-dd-yyyy'), 'Month YYYY')
               || ' to '
               || TO_CHAR (TO_DATE (p_curr_24, 'mm-dd-yyyy'), 'Month YYYY');
         ELSE
            v_list.page_header := NULL;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_giclr_204c3_q1;

   FUNCTION get_giclr_204c3_q2 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_tab PIPELINED
   IS
      v_list   giclr204c3_type;
   BEGIN
      FOR i IN (SELECT   b.iss_cd iss_cd2, b.assd_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')) POLICY,
                         a.policy_id, a.endt_iss_cd, a.endt_yy,
                         a.endt_seq_no, a.incept_date, a.expiry_date,
                         a.tsi_amt, SUM (b.prem_amt) prem_amt, c.assd_name,
                         d.iss_name, a.iss_cd,
                         TO_CHAR (date_for_24th, 'MONTH YYYY') MONTH
                    FROM gipi_polbasic a,
                         gicl_lratio_prev_prem_ext b,
                         giis_assured c,
                         giis_issource d
                   WHERE b.policy_id = a.policy_id
                     AND b.iss_cd = d.iss_cd(+)
                     AND b.assd_no = c.assd_no(+)
                     AND b.session_id = p_session_id
                GROUP BY b.iss_cd,
                         b.assd_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')),
                         a.policy_id,
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.assd_name,
                         d.iss_name,
                         a.iss_cd,
                         TO_CHAR (date_for_24th, 'MONTH YYYY')
                ORDER BY iss_cd2,
                         TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 ) DESC,
                         POLICY)
      LOOP
         v_list.iss := i.iss_cd2 || ' - ' || i.iss_name;
         v_list.MONTH := i.MONTH;

         IF i.endt_seq_no != 0
         THEN
            v_list.POLICY :=
                  i.POLICY
               || '/'
               || i.endt_iss_cd
               || '-'
               || TO_CHAR (i.endt_yy)
               || '-'
               || TO_CHAR (i.endt_seq_no);
         ELSE
            v_list.POLICY := i.POLICY;
         END IF;

         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;

         IF p_print_date = 1
         THEN
            FOR rec IN (SELECT issue_date
                          FROM gipi_polbasic
                         WHERE policy_id = i.policy_id)
            LOOP
               v_list.cf_date := TO_CHAR (rec.issue_date, 'MM-DD-RRRR');
            END LOOP;
         ELSIF p_print_date = 3
         THEN
            FOR rec IN (SELECT acct_ent_date
                          FROM gipi_polbasic
                         WHERE policy_id = i.policy_id)
            LOOP
               v_list.cf_date := TO_CHAR (rec.acct_ent_date, 'MM-DD-RRRR');
            END LOOP;
         ELSIF p_print_date = 4
         THEN
            FOR rec IN (SELECT    booking_mth
                               || ' '
                               || TO_CHAR (booking_year) booking_date
                          FROM gipi_polbasic
                         WHERE policy_id = i.policy_id)
            LOOP
               v_list.cf_date := rec.booking_date;
            END LOOP;
         ELSE
            v_list.cf_date := NULL;
         END IF;

         v_list.prem_amt := i.prem_amt;
         v_list.tsi_amt := i.tsi_amt;

         IF p_prev1_24 IS NOT NULL AND p_prev_24 IS NOT NULL
         THEN
            v_list.page_header :=
                  'Premiums Written for the Period '
               || TO_CHAR (TO_DATE (p_prev1_24, 'MM-dd-YYYY'), 'Month YYYY')
               || ' to '
               || TO_CHAR (TO_DATE (p_prev_24, 'MM-dd-YYYY'), 'Month YYYY');
         ELSE
            v_list.page_header := NULL;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_giclr_204c3_q2;

   FUNCTION get_giclr_204c3_q3 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_q3tab PIPELINED
   IS
      v_list   giclr204c3_q3type;
   BEGIN
      FOR i IN (SELECT   e.iss_name, a.iss_cd iss_cd2, a.assd_no,
                         d.assd_name, a.claim_id, SUM (os_amt) os_amt,
                         b.dsp_loss_date, b.clm_file_date,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009'))
                                                                    claim_no
                    FROM gicl_lratio_curr_os_ext a,
                         gicl_claims b,
                         giis_assured d,
                         giis_issource e
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = b.claim_id
                     AND a.iss_cd = e.iss_cd(+)
                     AND a.assd_no = d.assd_no
                GROUP BY a.iss_cd,
                         e.iss_name,
                         a.claim_id,
                         a.assd_no,
                         d.assd_name,
                         b.dsp_loss_date,
                         b.clm_file_date,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009'))
                ORDER BY iss_cd2, claim_no)
      LOOP
         v_list.iss := i.iss_cd2 || ' - ' || i.iss_name;
         v_list.claim_no := i.claim_no;
         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.loss_date := i.dsp_loss_date;
         v_list.file_date := i.clm_file_date;
         v_list.loss_amt := i.os_amt;

         IF p_curr_end_date IS NOT NULL
         THEN
            v_list.page_header :=
                                 'OUTSTANDING LOSS AS OF ' || p_curr_end_date;
         ELSE
            v_list.page_header := NULL;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_giclr_204c3_q3;

   FUNCTION get_giclr_204c3_q4 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_q3tab PIPELINED
   IS
      v_list   giclr204c3_q3type;
   BEGIN
      FOR i IN (SELECT   e.iss_name, a.iss_cd iss_cd2, a.assd_no,
                         d.assd_name, a.claim_id, SUM (os_amt) os_amt,
                         b.dsp_loss_date, b.clm_file_date,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009'))
                                                                    claim_no
                    FROM gicl_lratio_prev_os_ext a,
                         gicl_claims b,
                         giis_assured d,
                         giis_issource e
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = b.claim_id
                     AND a.iss_cd = e.iss_cd(+)
                     AND a.assd_no = d.assd_no
                GROUP BY a.iss_cd,
                         e.iss_name,
                         a.claim_id,
                         a.assd_no,
                         d.assd_name,
                         b.dsp_loss_date,
                         b.clm_file_date,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009'))
                ORDER BY iss_cd2, claim_no)
      LOOP
         v_list.iss := i.iss_cd2 || ' - ' || i.iss_name;
         v_list.claim_no := i.claim_no;
         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.loss_date := i.dsp_loss_date;
         v_list.file_date := i.clm_file_date;
         v_list.loss_amt := i.os_amt;

         IF p_prev_end_date IS NOT NULL
         THEN
            v_list.page_header :=
                                 'OUTSTANDING LOSS AS OF ' || p_prev_end_date;
         ELSE
            v_list.page_header := NULL;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_giclr_204c3_q4;

   FUNCTION get_giclr_204c3_q5 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_q3tab PIPELINED
   IS
      v_list   giclr204c3_q3type;
   BEGIN
      FOR i IN (SELECT   a.iss_cd iss_cd2, e.iss_name, a.assd_no,
                         c.assd_name,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009'))
                                                                    claim_no,
                         b.dsp_loss_date, SUM (a.loss_paid) loss_paid
                    FROM gicl_lratio_loss_paid_ext a,
                         gicl_claims b,
                         giis_assured c,
                         giis_issource e
                   WHERE a.session_id = p_session_id
                     AND a.assd_no = c.assd_no
                     AND a.iss_cd = e.iss_cd
                     AND a.claim_id = b.claim_id
                GROUP BY a.iss_cd,
                         e.iss_name,
                         a.assd_no,
                         c.assd_name,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')),
                         b.dsp_loss_date
                ORDER BY iss_cd2, claim_no)
      LOOP
         v_list.iss := i.iss_cd2 || ' - ' || i.iss_name;
         v_list.claim_no := i.claim_no;
         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.loss_date := i.dsp_loss_date;
         v_list.loss_amt := i.loss_paid;

         IF p_curr_year IS NOT NULL
         THEN
            v_list.page_header := 'LOSSES PAID FOR THE YEAR ' || p_curr_year;
         ELSE
            v_list.page_header := NULL;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_giclr_204c3_q5;

   FUNCTION get_giclr_204c3_q6 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_q6tab PIPELINED
   IS
      v_list   giclr204c3_q6type;
   BEGIN
      FOR i IN (SELECT   a.iss_cd iss_cd2, f.iss_name, a.assd_no,
                         b.assd_name, d.rec_type_desc,
                         SUM (a.recovered_amt) rec_amt, e.dsp_loss_date,
                            c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (rec_year, '0999'))
                         || '-'
                         || LTRIM (TO_CHAR (rec_seq_no, '009')) rec_no
                    FROM gicl_lratio_curr_recovery_ext a,
                         giis_assured b,
                         gicl_clm_recovery c,
                         giis_recovery_type d,
                         gicl_claims e,
                         giis_issource f
                   WHERE a.assd_no = b.assd_no
                     AND a.iss_cd = f.iss_cd
                     AND a.recovery_id = c.recovery_id
                     AND c.rec_type_cd = d.rec_type_cd
                     AND c.claim_id = e.claim_id
                     AND a.session_id = p_session_id
                GROUP BY a.iss_cd,
                         f.iss_name,
                         a.assd_no,
                         b.assd_name,
                         d.rec_type_desc,
                         e.dsp_loss_date,
                            c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (rec_year, '0999'))
                         || '-'
                         || LTRIM (TO_CHAR (rec_seq_no, '009'))
                ORDER BY iss_cd2, rec_no)
      LOOP
         v_list.iss := i.iss_cd2 || ' - ' || i.iss_name;
         v_list.rec_no := i.rec_no;
         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.rec_type := i.rec_type_desc;
         v_list.loss_date := i.dsp_loss_date;
         v_list.rec_amt := i.rec_amt;

         IF p_curr_start_date IS NOT NULL AND p_curr_end_date IS NOT NULL
         THEN
            v_list.page_header :=
                  'LOSS RECOVERY FOR THE PERIOD '
               || p_curr_start_date
               || ' TO '
               || p_curr_end_date;
         ELSE
            v_list.page_header := NULL;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_giclr_204c3_q6;

   FUNCTION get_giclr_204c3_q7 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_q6tab PIPELINED
   IS
      v_list   giclr204c3_q6type;
   BEGIN
      FOR i IN (SELECT   a.iss_cd iss_cd2, f.iss_name, a.assd_no,
                         b.assd_name, d.rec_type_desc,
                         SUM (a.recovered_amt) rec_amt, e.dsp_loss_date,
                            c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (rec_year, '0999'))
                         || '-'
                         || LTRIM (TO_CHAR (rec_seq_no, '009')) rec_no
                    FROM gicl_lratio_prev_recovery_ext a,
                         giis_assured b,
                         gicl_clm_recovery c,
                         giis_recovery_type d,
                         gicl_claims e,
                         giis_issource f
                   WHERE a.assd_no = b.assd_no
                     AND a.iss_cd = f.iss_cd
                     AND a.recovery_id = c.recovery_id
                     AND c.rec_type_cd = d.rec_type_cd
                     AND c.claim_id = e.claim_id
                     AND a.session_id = p_session_id
                GROUP BY a.iss_cd,
                         f.iss_name,
                         a.assd_no,
                         b.assd_name,
                         d.rec_type_desc,
                         e.dsp_loss_date,
                            c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (rec_year, '0999'))
                         || '-'
                         || LTRIM (TO_CHAR (rec_seq_no, '009'))
                ORDER BY iss_cd2, rec_no)
      LOOP
         v_list.iss := i.iss_cd2 || ' - ' || i.iss_name;
         v_list.rec_no := i.rec_no;
         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.rec_type := i.rec_type_desc;
         v_list.loss_date := i.dsp_loss_date;
         v_list.rec_amt := i.rec_amt;

         IF p_prev_year IS NOT NULL
         THEN
            v_list.page_header :=
                                 'LOSS RECOVERY FOR THE YEAR ' || p_prev_year;
         ELSE
            v_list.page_header := NULL;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_giclr_204c3_q7;
END;
/


