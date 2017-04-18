CREATE OR REPLACE PACKAGE BODY CPI.CSV_LOSS_RATIO AS
/* Author: Udel
** Date: 01122012
** General logic on these functions:
**   1. Select the data (SELECT statement is based on the report).
**   2. Perform necessary concatenations, format maskings, etc. to make 
**        the data more readable (like the formatting on the report).
**   3. Pipe the formatted data.
*/
-- printGICLR204A2CSV added by carlo 3.16.2016 SR-5384
   FUNCTION csv_giclr204a2_prem_writ_cy (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab PIPELINED
   IS
      v_list   giclr204a2_type;
   BEGIN
      FOR i IN (SELECT   b.line_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.line_name, d.assd_name,
                         a.policy_id
                    FROM gipi_polbasic a,
                         gicl_lratio_curr_prem_ext b,
                         giis_line c,
                         giis_assured d
                   WHERE b.policy_id = a.policy_id
                     AND b.assd_no = d.assd_no(+)
                     AND b.line_cd = c.line_cd(+)
                     AND b.session_id = p_session_id
                GROUP BY b.line_cd,
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.line_name,
                         d.assd_name,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;

         IF i.endt_seq_no != 0
         THEN
            v_list.POLICY :=
               (   i.POLICY
                || '/'
                || i.endt_iss_cd
                || '-'
                || TO_CHAR (i.endt_yy)
                || '-'
                || TO_CHAR (i.endt_seq_no)
               );
         ELSE
            v_list.POLICY := i.POLICY;
         END IF;

         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.incept_date := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_list.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_list.tsi_amt := amount_format (i.tsi_amt);
         v_list.prem_amt := amount_format (i.prem_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_prem_writ_cy;

-- Start: Kevin SR-5384
   FUNCTION csv_giclr204a2_prem_writ_cy1 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab1 PIPELINED
   IS
      v_list   giclr204a2_type1;
   BEGIN
      FOR i IN (SELECT   b.line_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.line_name, d.assd_name,
                         a.policy_id
                    FROM gipi_polbasic a,
                         gicl_lratio_curr_prem_ext b,
                         giis_line c,
                         giis_assured d
                   WHERE b.policy_id = a.policy_id
                     AND b.assd_no = d.assd_no(+)
                     AND b.line_cd = c.line_cd(+)
                     AND b.session_id = p_session_id
                GROUP BY b.line_cd,
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.line_name,
                         d.assd_name,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;

         IF i.endt_seq_no != 0
         THEN
            v_list.POLICY :=
               (   i.POLICY
                || '/'
                || i.endt_iss_cd
                || '-'
                || TO_CHAR (i.endt_yy)
                || '-'
                || TO_CHAR (i.endt_seq_no)
               );
         ELSE
            v_list.POLICY := i.POLICY;
         END IF;

         FOR rec IN (SELECT issue_date
                       FROM gipi_polbasic
                      WHERE policy_id = i.policy_id)
         LOOP
            v_list.issue_date := TO_CHAR (rec.issue_date, 'MM-DD-RRRR');
         END LOOP;

         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.incept_date := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_list.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_list.tsi_amt := amount_format (i.tsi_amt);
         v_list.prem_amt := amount_format (i.prem_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_prem_writ_cy1;

   FUNCTION csv_giclr204a2_prem_writ_cy3 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab3 PIPELINED
   IS
      v_list   giclr204a2_type3;
   BEGIN
      FOR i IN (SELECT   b.line_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.line_name, d.assd_name,
                         a.policy_id
                    FROM gipi_polbasic a,
                         gicl_lratio_curr_prem_ext b,
                         giis_line c,
                         giis_assured d
                   WHERE b.policy_id = a.policy_id
                     AND b.assd_no = d.assd_no(+)
                     AND b.line_cd = c.line_cd(+)
                     AND b.session_id = p_session_id
                GROUP BY b.line_cd,
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.line_name,
                         d.assd_name,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;

         IF i.endt_seq_no != 0
         THEN
            v_list.POLICY :=
               (   i.POLICY
                || '/'
                || i.endt_iss_cd
                || '-'
                || TO_CHAR (i.endt_yy)
                || '-'
                || TO_CHAR (i.endt_seq_no)
               );
         ELSE
            v_list.POLICY := i.POLICY;
         END IF;

         FOR rec IN (SELECT acct_ent_date
                       FROM gipi_polbasic
                      WHERE policy_id = i.policy_id)
         LOOP
            v_list.acct_ent_date := TO_CHAR (rec.acct_ent_date, 'MM-DD-RRRR');
         END LOOP;

         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.incept_date := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_list.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_list.tsi_amt := amount_format (i.tsi_amt);
         v_list.prem_amt := amount_format (i.prem_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_prem_writ_cy3;

   FUNCTION csv_giclr204a2_prem_writ_cy4 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab4 PIPELINED
   IS
      v_list   giclr204a2_type4;
   BEGIN
      FOR i IN (SELECT   b.line_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.line_name, d.assd_name,
                         a.policy_id
                    FROM gipi_polbasic a,
                         gicl_lratio_curr_prem_ext b,
                         giis_line c,
                         giis_assured d
                   WHERE b.policy_id = a.policy_id
                     AND b.assd_no = d.assd_no(+)
                     AND b.line_cd = c.line_cd(+)
                     AND b.session_id = p_session_id
                GROUP BY b.line_cd,
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.line_name,
                         d.assd_name,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;

         IF i.endt_seq_no != 0
         THEN
            v_list.POLICY :=
               (   i.POLICY
                || '/'
                || i.endt_iss_cd
                || '-'
                || TO_CHAR (i.endt_yy)
                || '-'
                || TO_CHAR (i.endt_seq_no)
               );
         ELSE
            v_list.POLICY := i.POLICY;
         END IF;

         FOR rec IN (SELECT    booking_mth
                            || ' '
                            || TO_CHAR (booking_year) booking_date
                       FROM gipi_polbasic
                      WHERE policy_id = i.policy_id)
         LOOP
            v_list.booking_date := rec.booking_date;
         END LOOP;

         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.incept_date := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_list.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_list.tsi_amt := amount_format (i.tsi_amt);
         v_list.prem_amt := amount_format (i.prem_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_prem_writ_cy4;

-- End: Kevin SR-5384
   FUNCTION csv_giclr204a2_prem_writ_py (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab PIPELINED
   IS
      v_list   giclr204a2_type;
   BEGIN
      FOR i IN (SELECT   b.line_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.assd_name, d.line_name,
                         a.policy_id
                    FROM gipi_polbasic a,
                         gicl_lratio_prev_prem_ext b,
                         giis_assured c,
                         giis_line d
                   WHERE b.policy_id = a.policy_id
                     AND b.line_cd = d.line_cd(+)
                     AND b.assd_no = c.assd_no(+)
                     AND b.session_id = p_session_id
                GROUP BY b.line_cd,
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.assd_name,
                         d.line_name,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;

         IF i.endt_seq_no != 0
         THEN
            v_list.POLICY :=
               (   i.POLICY
                || '/'
                || i.endt_iss_cd
                || '-'
                || TO_CHAR (i.endt_yy)
                || '-'
                || TO_CHAR (i.endt_seq_no)
               );
         ELSE
            v_list.POLICY := i.POLICY;
         END IF;

         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.incept_date := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_list.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_list.tsi_amt := amount_format (i.tsi_amt);
         v_list.prem_amt := amount_format (i.prem_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_prem_writ_py;

--Start added by Kevin 4-11-2016 SR-5384
   FUNCTION csv_giclr204a2_prem_writ_py1 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab1 PIPELINED
   IS
      v_list   giclr204a2_type1;
   BEGIN
      FOR i IN (SELECT   b.line_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.assd_name, d.line_name,
                         a.policy_id
                    FROM gipi_polbasic a,
                         gicl_lratio_prev_prem_ext b,
                         giis_assured c,
                         giis_line d
                   WHERE b.policy_id = a.policy_id
                     AND b.line_cd = d.line_cd(+)
                     AND b.assd_no = c.assd_no(+)
                     AND b.session_id = p_session_id
                GROUP BY b.line_cd,
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.assd_name,
                         d.line_name,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;

         IF i.endt_seq_no != 0
         THEN
            v_list.POLICY :=
               (   i.POLICY
                || '/'
                || i.endt_iss_cd
                || '-'
                || TO_CHAR (i.endt_yy)
                || '-'
                || TO_CHAR (i.endt_seq_no)
               );
         ELSE
            v_list.POLICY := i.POLICY;
         END IF;

         FOR rec IN (SELECT issue_date
                       FROM gipi_polbasic
                      WHERE policy_id = i.policy_id)
         LOOP
            v_list.issue_date := TO_CHAR (rec.issue_date, 'MM-DD-RRRR');
         END LOOP;

         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.incept_date := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_list.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_list.tsi_amt := amount_format (i.tsi_amt);
         v_list.prem_amt := amount_format (i.prem_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_prem_writ_py1;

   FUNCTION csv_giclr204a2_prem_writ_py3 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab3 PIPELINED
   IS
      v_list   giclr204a2_type3;
   BEGIN
      FOR i IN (SELECT   b.line_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.assd_name, d.line_name,
                         a.policy_id
                    FROM gipi_polbasic a,
                         gicl_lratio_prev_prem_ext b,
                         giis_assured c,
                         giis_line d
                   WHERE b.policy_id = a.policy_id
                     AND b.line_cd = d.line_cd(+)
                     AND b.assd_no = c.assd_no(+)
                     AND b.session_id = p_session_id
                GROUP BY b.line_cd,
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.assd_name,
                         d.line_name,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;

         IF i.endt_seq_no != 0
         THEN
            v_list.POLICY :=
               (   i.POLICY
                || '/'
                || i.endt_iss_cd
                || '-'
                || TO_CHAR (i.endt_yy)
                || '-'
                || TO_CHAR (i.endt_seq_no)
               );
         ELSE
            v_list.POLICY := i.POLICY;
         END IF;

         FOR rec IN (SELECT acct_ent_date
                       FROM gipi_polbasic
                      WHERE policy_id = i.policy_id)
         LOOP
            v_list.acct_ent_date := TO_CHAR (rec.acct_ent_date, 'MM-DD-RRRR');
         END LOOP;

         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.incept_date := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_list.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_list.tsi_amt := amount_format (i.tsi_amt);
         v_list.prem_amt := amount_format (i.prem_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_prem_writ_py3;

   FUNCTION csv_giclr204a2_prem_writ_py4 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab4 PIPELINED
   IS
      v_list   giclr204a2_type4;
   BEGIN
      FOR i IN (SELECT   b.line_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.assd_name, d.line_name,
                         a.policy_id
                    FROM gipi_polbasic a,
                         gicl_lratio_prev_prem_ext b,
                         giis_assured c,
                         giis_line d
                   WHERE b.policy_id = a.policy_id
                     AND b.line_cd = d.line_cd(+)
                     AND b.assd_no = c.assd_no(+)
                     AND b.session_id = p_session_id
                GROUP BY b.line_cd,
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.assd_name,
                         d.line_name,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;

         IF i.endt_seq_no != 0
         THEN
            v_list.POLICY :=
               (   i.POLICY
                || '/'
                || i.endt_iss_cd
                || '-'
                || TO_CHAR (i.endt_yy)
                || '-'
                || TO_CHAR (i.endt_seq_no)
               );
         ELSE
            v_list.POLICY := i.POLICY;
         END IF;

         FOR rec IN (SELECT    booking_mth
                            || ' '
                            || TO_CHAR (booking_year) booking_date
                       FROM gipi_polbasic
                      WHERE policy_id = i.policy_id)
         LOOP
            v_list.booking_date := rec.booking_date;
         END LOOP;

         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.incept_date := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_list.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_list.tsi_amt := amount_format (i.tsi_amt);
         v_list.prem_amt := amount_format (i.prem_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_prem_writ_py4;

--End Kevin SR-5384
   FUNCTION csv_giclr204a2_os_loss_cy (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a3_tab PIPELINED
   IS
      v_list   giclr204a3_type;
   BEGIN
      FOR i IN (SELECT   e.line_name, a.line_cd, a.assd_no, d.assd_name,
                         a.claim_id, SUM (os_amt) os_amt, b.dsp_loss_date,
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
                                                                    claim_no
                    FROM gicl_lratio_curr_os_ext a,
                         gicl_claims b,
                         giis_assured d,
                         giis_line e
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = b.claim_id
                     AND a.line_cd = e.line_cd(+)
                     AND a.assd_no = d.assd_no
                GROUP BY a.line_cd,
                         e.line_name,
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
                ORDER BY claim_no)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;
         v_list.claim_no := i.claim_no;
         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-RRRR');
         v_list.file_date := TO_CHAR (i.clm_file_date, 'MM-DD-RRRR');
         v_list.loss_amt := amount_format (i.os_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_os_loss_cy;

   FUNCTION csv_giclr204a2_os_loss_py (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a3_tab PIPELINED
   IS
      v_list   giclr204a3_type;
   BEGIN
      FOR i IN (SELECT   e.line_name, a.line_cd, a.assd_no, d.assd_name,
                         a.claim_id, SUM (os_amt) os_amt, b.dsp_loss_date,
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
                                                                    claim_no
                    FROM gicl_lratio_prev_os_ext a,
                         gicl_claims b,
                         giis_assured d,
                         giis_line e
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = b.claim_id
                     AND a.line_cd = e.line_cd(+)
                     AND a.assd_no = d.assd_no
                GROUP BY a.line_cd,
                         e.line_name,
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
                ORDER BY claim_no)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;
         v_list.claim_no := i.claim_no;
         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-RRRR');
         v_list.file_date := TO_CHAR (i.clm_file_date, 'MM-DD-RRRR');
         v_list.loss_amt := amount_format (i.os_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_os_loss_py;

   FUNCTION csv_giclr204a2_losses_paid (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a4_tab PIPELINED
   IS
      v_list   giclr204a4_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, e.line_name, a.assd_no, c.assd_name,
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
                         giis_line e
                   WHERE a.session_id = p_session_id
                     AND a.assd_no = c.assd_no
                     AND a.line_cd = e.line_cd
                     AND a.claim_id = b.claim_id
                GROUP BY a.line_cd,
                         e.line_name,
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
                ORDER BY claim_no)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;
         v_list.claim_no := i.claim_no;
         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-RRRR');
         v_list.loss_amt := amount_format (i.loss_paid);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_losses_paid;

   FUNCTION csv_giclr204a2_loss_reco_cy (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a5_tab PIPELINED
   IS
      v_list   giclr204a5_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, f.line_name, a.assd_no, b.assd_name,
                         d.rec_type_desc, SUM (a.recovered_amt) rec_amt,
                         e.dsp_loss_date,
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
                         giis_line f
                   WHERE a.assd_no = b.assd_no
                     AND a.line_cd = f.line_cd
                     AND a.recovery_id = c.recovery_id
                     AND c.rec_type_cd = d.rec_type_cd
                     AND c.claim_id = e.claim_id
                     AND a.session_id = p_session_id
                GROUP BY a.line_cd,
                         f.line_name,
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
                ORDER BY rec_no)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;
         v_list.rec_no := i.rec_no;
         v_list.rec_type := i.rec_type_desc;
         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-RRRR');
         v_list.rec_amt := amount_format (i.rec_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_loss_reco_cy;

   FUNCTION csv_giclr204a2_loss_reco_py (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a5_tab PIPELINED
   IS
      v_list   giclr204a5_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, f.line_name, a.assd_no, b.assd_name,
                         d.rec_type_desc, SUM (a.recovered_amt) rec_amt,
                         e.dsp_loss_date,
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
                         giis_line f
                   WHERE a.assd_no = b.assd_no
                     AND a.line_cd = f.line_cd
                     AND a.recovery_id = c.recovery_id
                     AND c.rec_type_cd = d.rec_type_cd
                     AND c.claim_id = e.claim_id
                     AND a.session_id = p_session_id
                GROUP BY a.line_cd,
                         f.line_name,
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
                ORDER BY rec_no)
      LOOP
         v_list.line := i.line_cd || ' - ' || i.line_name;
         v_list.rec_no := i.rec_no;
         v_list.rec_type := i.rec_type_desc;
         v_list.assured := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-RRRR');
         v_list.rec_amt := amount_format (i.rec_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204a2_loss_reco_py;
-- printGICLR204A2CSV END --
  FUNCTION GICLR204D (p_session_id NUMBER)
    RETURN giclr204d_typ PIPELINED IS
    v_giclr204d   giclr204d_rectype;
    v_ref         VARCHAR2 (30);
    v_ratio       NUMBER;
  BEGIN
    FOR rec IN (SELECT a.intm_no, a.loss_ratio_date, NVL(a.curr_prem_amt, 0) curr_prem_amt,
                       NVL (a.curr_prem_res, 0) prem_res_cy,
                       NVL (a.prev_prem_res, 0) prem_res_py, NVL(a.loss_paid_amt, 0) loss_paid_amt, a.curr_loss_res,
                       a.prev_loss_res,
                       (NVL(a.curr_prem_amt, 0) + NVL(a.prev_prem_res, 0) - NVL(a.curr_prem_res, 0)) premiums_earned,
                       (NVL (a.loss_paid_amt, 0) + NVL(a.curr_loss_res, 0) - NVL (a.prev_loss_res, 0)) losses_incurred,
                       b.ref_intm_cd, b.intm_name
                  FROM gicl_loss_ratio_ext a, giis_intermediary b
                 WHERE a.session_id = p_session_id
                   AND a.intm_no = b.intm_no
              ORDER BY get_loss_ratio (a.session_id,
                                       a.line_cd,
                                       a.subline_cd,
                                       a.iss_cd,
                                       a.peril_cd,
                                       a.intm_no,
                                       a.assd_no
                                      ) DESC)
    LOOP
      BEGIN
        SELECT DECODE (rec.ref_intm_cd,
                       NULL, TO_CHAR (rec.intm_no),
                       TO_CHAR (rec.intm_no) || ' / ' || rec.ref_intm_cd)
          INTO v_ref
          FROM DUAL;
      EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
          v_ref := NULL;
      END;

      IF NVL (rec.premiums_earned, 0) != 0 THEN
        v_ratio := (rec.losses_incurred / rec.premiums_earned) * 100;
      ELSE
        v_ratio := 0;
      END IF;
      
      v_giclr204d.intm_no           := v_ref;
      v_giclr204d.intm_name         := rec.intm_name;
      v_giclr204d.loss_paid_amt     := rec.loss_paid_amt;
      v_giclr204d.curr_loss_res     := rec.curr_loss_res;
      v_giclr204d.prev_loss_res     := rec.prev_loss_res;
      v_giclr204d.curr_prem_amt     := rec.curr_prem_amt;
      v_giclr204d.prem_res_cy       := rec.prem_res_cy;
      v_giclr204d.prem_res_py       := rec.prem_res_py;
      v_giclr204d.losses_incurred   := rec.losses_incurred;
      v_giclr204d.premiums_earned   := rec.premiums_earned;
      v_giclr204d.loss_ratio        := v_ratio;
      
      PIPE ROW (v_giclr204d);
    END LOOP;
    RETURN;
  END GICLR204D;
  
  FUNCTION GICLR204C (p_session_id NUMBER)
    RETURN giclr204c_typ PIPELINED IS
    v_giclr204c     giclr204c_rectype;
    v_iss           VARCHAR2(100);
    v_ratio         NUMBER;
  BEGIN
    FOR rec IN (SELECT a.iss_cd, a.loss_ratio_date, 
                       NVL(a.curr_prem_amt,0) curr_prem_amt,
                       NVL(a.curr_prem_res,0) prem_res_cy, 
                       NVL(a.prev_prem_res,0) prem_res_py, 
                       NVL(a.loss_paid_amt,0) loss_paid_amt,
                       a.curr_loss_res ,
                       a.prev_loss_res,
                       (NVL(a.curr_prem_amt,0) + NVL(a.prev_prem_res,0) - NVL(a.curr_prem_res,0)) premiums_earned,
                       (NVL(a.loss_paid_amt,0) + NVL(a.curr_loss_res,0) - NVL(a.prev_loss_res,0)) losses_incurred
                  FROM gicl_loss_ratio_ext a
                 WHERE a.session_id = p_session_id
                 ORDER BY get_loss_ratio(a.session_id,a.line_cd,a.subline_cd,a.iss_cd,a.peril_cd,a.INTM_NO,a.assd_no) DESC)
    LOOP
      BEGIN 
        SELECT iss_cd||' - '||iss_name
          INTO v_iss
          FROM giis_issource
         WHERE iss_cd = rec.iss_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          v_iss := NULL;
      END;
      
      IF NVL(rec.premiums_earned, 0) != 0 THEN
        v_ratio := (rec.losses_incurred / rec.premiums_earned) * 100;
      ELSE
        v_ratio := 0;
      END IF;
      
      v_giclr204c.issue_name      := v_iss;
      v_giclr204c.loss_paid_amt   := rec.loss_paid_amt;
      v_giclr204c.curr_loss_res   := rec.curr_loss_res;
      v_giclr204c.prev_loss_res   := rec.prev_loss_res;
      v_giclr204c.curr_prem_amt   := rec.curr_prem_amt;
      v_giclr204c.prem_res_cy     := rec.prem_res_cy;
      v_giclr204c.prem_res_py     := rec.prem_res_py;
      v_giclr204c.losses_incurred := rec.losses_incurred;
      v_giclr204c.premiums_earned := rec.premiums_earned;
      v_giclr204c.ratio           := v_ratio;
      
      PIPE ROW (v_giclr204c);
    END LOOP;
    RETURN;
  END GICLR204C;
  
  FUNCTION giclr204d3_pw(p_session_id   NUMBER,
                         p_date         VARCHAR2,
                         p_prnt_date    NUMBER)
    RETURN giclr204d3_pw_typ PIPELINED IS
    v_giclr204d3_pw     giclr204d3_pw_rectype;
    v_intm_name       VARCHAR2(100);
    v_policy          VARCHAR2(100);
    v_assd            VARCHAR2(520);
    v_incept_date     gipi_polbasic.incept_date%TYPE;
    v_expiry_date     gipi_polbasic.expiry_date%TYPE;
    v_date            VARCHAR2(20);
  BEGIN
    FOR rec IN (SELECT b.intm_no, b.assd_no,
                       a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||
                         LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy,
                       a.policy_id, a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) prem_amt, c.intm_name,
                       d.assd_name, TO_DATE(TO_CHAR(date_for_24th,'MONTH YYYY'),'MONTH YYYY') month
                  FROM gipi_polbasic a,
                       (SELECT * FROM gicl_lratio_curr_prem_ext
                         WHERE p_date = 'CURR'
                        UNION
                        SELECT * FROM gicl_lratio_prev_prem_ext
                         WHERE p_date = 'PREV') b,
                       giis_intermediary c, giis_assured d
                 WHERE b.policy_id  = a.policy_id
                   AND b.assd_no    = d.assd_no (+)
                   AND b.intm_no    = c.intm_no (+)
                   AND b.session_id = p_session_id
                 GROUP BY b.intm_no, b.assd_no,
                       a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')),
                       a.policy_id,
                       a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, a.tsi_amt,  c.intm_name,
                       d.assd_name, TO_DATE(TO_CHAR(date_for_24th,'MONTH YYYY'),'MONTH YYYY') 
                ORDER BY TO_DATE(TO_CHAR(date_for_24th,'MONTH YYYY'),'MONTH YYYY') DESC, policy)
    LOOP
      v_intm_name := TO_CHAR(rec.intm_no)||' - '||rec.intm_name;
      
      IF rec.endt_seq_no != 0 THEN 
        v_policy := rec.policy||'/'||rec.endt_iss_cd||'-'||TO_CHAR(rec.endt_yy)||'-'||TO_CHAR(rec.endt_seq_no);
      ELSE
        v_policy := rec.policy;
      END IF;
      
      v_assd := TO_CHAR(rec.assd_no)||' '||rec.assd_name;
      v_incept_date := TO_DATE(TO_CHAR(rec.incept_date, 'MM-DD-RRRR'),'MM-DD-RRRR');
      v_expiry_date := TO_DATE(TO_CHAR(rec.expiry_date, 'MM-DD-RRRR'),'MM-DD-RRRR');
      
      IF p_prnt_date = 1 THEN
        FOR rec1 IN (SELECT issue_date
                      FROM gipi_polbasic
                     WHERE policy_id = rec.policy_id)
        LOOP
          v_date := TO_CHAR(rec1.issue_date,'MM-DD-RRRR');
        END LOOP;
      ELSIF p_prnt_date = 3 THEN
        FOR rec1 IN (SELECT acct_ent_date
                      FROM gipi_polbasic
                     WHERE policy_id = rec.policy_id)
        LOOP
          v_date := TO_CHAR(rec1.acct_ent_date,'MM-DD-RRRR');
        END LOOP;
      ELSIF p_prnt_date = 4 THEN
        FOR rec1 IN (SELECT booking_mth||' '||TO_CHAR(booking_year) booking_date
                      FROM gipi_polbasic
                     WHERE policy_id = rec.policy_id)
        LOOP
          v_date := rec1.booking_date;         
        END LOOP;
      ELSE
         v_date := NULL;
      END IF;
      
      v_giclr204d3_pw.intm_name     := v_intm_name;
      v_giclr204d3_pw.month24       := rec.month;
      v_giclr204d3_pw.policy_no     := v_policy;
      v_giclr204d3_pw.assd          := v_assd;
      v_giclr204d3_pw.incept_date   := v_incept_date;
      v_giclr204d3_pw.expiry_date   := v_expiry_date;
      v_giclr204d3_pw.date_by       := v_date;
      v_giclr204d3_pw.tsi_amt       := rec.tsi_amt;
      v_giclr204d3_pw.prem_amt      := rec.prem_amt;
      
      PIPE ROW (v_giclr204d3_pw);
    END LOOP;
    RETURN;
  END GICLR204D3_PW;
  
  FUNCTION GICLR204D3_OS(p_session_id   NUMBER,
                         p_date         VARCHAR2)
    RETURN giclr204d3_os_typ PIPELINED IS
    
    v_giclr204d3_os     giclr204d3_loss_rectype;
  BEGIN
    FOR rec IN (SELECT e.intm_name, a.intm_no, a.assd_no, d.assd_name, a.claim_id, SUM(os_amt) os_amt, 
                       b.dsp_loss_date, b.clm_file_date,
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim
                  FROM (SELECT * FROM gicl_lratio_curr_os_ext
                         WHERE p_date = 'CURR'
                        UNION
                        SELECT * FROM gicl_lratio_prev_os_ext
                         WHERE p_date = 'PREV') a,
                       gicl_claims b, giis_assured d, giis_intermediary e
                 WHERE a.session_id = p_session_id
                   AND a.claim_id = b.claim_id 
                   AND a.intm_no  = e.intm_no(+)
                   AND a.assd_no = d.assd_no
                 GROUP BY a.intm_no, e.intm_name,a.claim_id, a.assd_no, d.assd_name, b.dsp_loss_date,b.clm_file_date,
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) 
                 ORDER BY claim)
    LOOP
      v_giclr204d3_os.intm_name       := rec.intm_no||' - '||rec.intm_name;
      v_giclr204d3_os.claim_no        := rec.claim;
      v_giclr204d3_os.assd_name       := rec.assd_no||' '||rec.assd_name;
      v_giclr204d3_os.dsp_loss_date   := TO_DATE(TO_CHAR(rec.dsp_loss_date, 'MM-DD-RRRR'),'MM-DD-RRRR');
      v_giclr204d3_os.clm_file_date   := TO_DATE(TO_CHAR(rec.clm_file_date, 'MM-DD-RRRR'),'MM-DD-RRRR');
      v_giclr204d3_os.amount          := rec.os_amt;
      
      PIPE ROW (v_giclr204d3_os);
    END LOOP;
    RETURN;
  END GICLR204D3_OS;
  
  FUNCTION GICLR204D3_LP(p_session_id   NUMBER)
    RETURN giclr204d3_lp_typ PIPELINED IS
  
    v_giclr204d3_lp     giclr204d3_loss_rectype;
  BEGIN
    FOR rec IN (SELECT a.intm_no, e.intm_name, a.assd_no, c.assd_name,
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim,
                       b.dsp_loss_date, SUM(a.loss_paid) loss_paid
                  FROM gicl_lratio_loss_paid_ext a, gicl_claims b, giis_assured c, giis_intermediary e
                 WHERE a.session_id = p_session_id
                   AND a.assd_no = c.assd_no
                   AND a.intm_no = e.intm_no
                   AND a.claim_id = b.claim_id
                GROUP BY a.intm_no, e.intm_name, a.assd_no, c.assd_name, b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                b.dsp_loss_date
                ORDER BY claim)
    LOOP
      v_giclr204d3_lp.intm_name       := rec.intm_no||' - '||rec.intm_name;
      v_giclr204d3_lp.claim_no        := rec.claim;
      v_giclr204d3_lp.assd_name       := rec.assd_no||' '||rec.assd_name;
      v_giclr204d3_lp.dsp_loss_date   := TO_DATE(TO_CHAR(rec.dsp_loss_date, 'MM-DD-RRRR'),'MM-DD-RRRR');
      v_giclr204d3_lp.amount          := rec.loss_paid;
      
      PIPE ROW (v_giclr204d3_lp);
    END LOOP;
    RETURN;
  END GICLR204D3_LP;
  
  FUNCTION GICLR204D3_LR(p_session_id   NUMBER,
                         p_date         VARCHAR2)
    RETURN giclr204d3_lr_typ PIPELINED IS
    
    v_giclr204d3_lr giclr204d3_lr_rectype; 
  BEGIN
    FOR rec IN (SELECT a.intm_no, f.intm_name, a.assd_no, b.assd_name,
                       d.rec_type_desc, SUM(a.recovered_amt) recovered_amt, e.dsp_loss_date,
                       c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery
                  FROM (SELECT * FROM gicl_lratio_curr_recovery_ext
                         WHERE p_date = 'CURR'
                        UNION
                        SELECT * FROM gicl_lratio_prev_recovery_ext
                         WHERE p_date = 'PREV') a,
                       giis_assured b, gicl_clm_recovery c, giis_recovery_type d,
                       gicl_claims e, giis_intermediary f
                 WHERE a.assd_no = b.assd_no
                   AND a.intm_no = f.intm_no
                   AND a.recovery_id = c.recovery_id
                   AND c.rec_type_cd = d.rec_type_cd
                   AND c.claim_id = e.claim_id
                   AND a.session_id = p_session_id
                 GROUP BY a.intm_no, f.intm_name, a.assd_no, b.assd_name, d.rec_type_desc, e.dsp_loss_date,
                       c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009'))
                 ORDER BY recovery)
    LOOP
      v_giclr204d3_lr.intm_name       := TO_CHAR(rec.intm_no)||' - '||rec.intm_name;
      v_giclr204d3_lr.recovery_no     := rec.recovery;
      v_giclr204d3_lr.assd_name       := TO_CHAR(rec.assd_no)||' '||rec.assd_name;
      v_giclr204d3_lr.rec_type_desc   := rec.rec_type_desc;
      v_giclr204d3_lr.loss_date       := TO_DATE(TO_CHAR(rec.dsp_loss_date, 'MM-DD-RRRR'),'MM-DD-RRRR');
      v_giclr204d3_lr.amount          := rec.recovered_amt;
      
      PIPE ROW (v_giclr204d3_lr);
    END LOOP;
    RETURN;
  END GICLR204D3_LR;
  
  FUNCTION GICLR204C3_PW(p_session_id   NUMBER,
                         p_date         VARCHAR2,
                         p_prnt_date    NUMBER)
    RETURN giclr204c3_typ PIPELINED IS
    v_giclr204c3_pw   giclr204c3_rectype;
    v_iss_name        VARCHAR2(100);
    v_policy          VARCHAR2(100);
    v_assd            VARCHAR2(520);
    v_incept_date     gipi_polbasic.incept_date%TYPE;
    v_expiry_date     gipi_polbasic.expiry_date%TYPE;
    v_date            VARCHAR2(20);    
  BEGIN
    FOR rec IN (SELECT b.iss_cd, b.assd_no,
                       a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy,
                       a.policy_id,
                       a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) prem_amt, c.iss_name,
                       d.assd_name, TO_DATE(TO_CHAR(date_for_24th,'MONTH YYYY'),'MONTH YYYY') month
                  FROM gipi_polbasic a,
                       (SELECT * FROM gicl_lratio_curr_prem_ext
                         WHERE p_date = 'CURR'
                        UNION
                        SELECT * FROM gicl_lratio_prev_prem_ext
                         WHERE p_date = 'PREV') b,
                       giis_issource c, giis_assured d
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = d.assd_no (+)
                   AND b.iss_cd = c.iss_cd (+)
                   AND b.session_id = p_session_id
                 GROUP BY b.iss_cd, b.assd_no, a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) , a.policy_id,
                       a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, a.tsi_amt, c.iss_name,
                       d.assd_name,a.iss_cd, TO_DATE(TO_CHAR(date_for_24th,'MONTH YYYY'),'MONTH YYYY') 
                 ORDER BY TO_DATE(TO_CHAR(date_for_24th,'MONTH YYYY'),'MONTH YYYY') DESC, policy)
    LOOP
      v_iss_name := TO_CHAR(rec.iss_cd)||' - '||rec.iss_name;
      
      IF rec.endt_seq_no != 0 THEN 
        v_policy := rec.policy||'/'||rec.endt_iss_cd||'-'||TO_CHAR(rec.endt_yy)||'-'||TO_CHAR(rec.endt_seq_no);
      ELSE
        v_policy := rec.policy;
      END IF;
      
      v_assd := TO_CHAR(rec.assd_no)||' '||rec.assd_name;
      v_incept_date := TO_DATE(TO_CHAR(rec.incept_date, 'MM-DD-RRRR'),'MM-DD-RRRR');
      v_expiry_date := TO_DATE(TO_CHAR(rec.expiry_date, 'MM-DD-RRRR'),'MM-DD-RRRR');
      
      IF p_prnt_date = 1 THEN
        FOR rec1 IN (SELECT issue_date
                      FROM gipi_polbasic
                     WHERE policy_id = rec.policy_id)
        LOOP
          v_date := TO_CHAR(rec1.issue_date,'MM-DD-RRRR');
        END LOOP;
      ELSIF p_prnt_date = 3 THEN
        FOR rec1 IN (SELECT acct_ent_date
                      FROM gipi_polbasic
                     WHERE policy_id = rec.policy_id)
        LOOP
          v_date := TO_CHAR(rec1.acct_ent_date,'MM-DD-RRRR');
        END LOOP;
      ELSIF p_prnt_date = 4 THEN
        FOR rec1 IN (SELECT booking_mth||' '||TO_CHAR(booking_year) booking_date
                      FROM gipi_polbasic
                     WHERE policy_id = rec.policy_id)
        LOOP
          v_date := rec1.booking_date;         
        END LOOP;
      ELSE
         v_date := NULL;
      END IF;
      
      v_giclr204c3_pw.iss_cd         := v_iss_name;
      v_giclr204c3_pw.lr_month       := rec.month;
      v_giclr204c3_pw.policy_no      := v_policy;
      v_giclr204c3_pw.assd_name      := v_assd;
      v_giclr204c3_pw.incept_date    := v_incept_date;
      v_giclr204c3_pw.expiry_date    := v_expiry_date;
      v_giclr204c3_pw.date_by        := v_date;
      v_giclr204c3_pw.tsi_amt        := rec.tsi_amt;
      v_giclr204c3_pw.prem_amt       := rec.prem_amt;
      
      PIPE ROW (v_giclr204c3_pw);
    END LOOP;
    RETURN;
  END GICLR204C3_PW;
  
  FUNCTION GICLR204C3_OS(p_session_id   NUMBER,
                         p_date         VARCHAR2)
    RETURN giclr204c3_typ PIPELINED IS
    v_giclr204c3_os giclr204c3_rectype;
  BEGIN
    FOR rec IN (SELECT e.iss_name, a.iss_cd, a.assd_no, d.assd_name, a.claim_id, SUM(os_amt) os_amt, 
                       b.dsp_loss_date, b.clm_file_date,
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim
                  FROM (SELECT * FROM gicl_lratio_curr_os_ext
                         WHERE p_date = 'CURR'
                        UNION
                        SELECT * FROM gicl_lratio_prev_os_ext
                         WHERE p_date = 'PREV') a,
                       gicl_claims b, giis_assured d, giis_issource e
                 WHERE a.session_id = p_session_id
                   AND a.claim_id = b.claim_id 
                   AND a.iss_cd  = e.iss_cd(+)
                   AND a.assd_no = d.assd_no
                 GROUP BY a.iss_cd, e.iss_name,a.claim_id, a.assd_no, d.assd_name, b.dsp_loss_date, b.clm_file_date,
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) 
                 ORDER BY claim)
    LOOP
      v_giclr204c3_os.iss_cd        := rec.iss_cd||' - '||rec.iss_name;
      v_giclr204c3_os.claim_no      := rec.claim;
      v_giclr204c3_os.assd_name     := TO_CHAR(rec.assd_no)||' '||rec.assd_name;
      v_giclr204c3_os.loss_date     := TO_DATE(TO_CHAR(rec.dsp_loss_date, 'MM-DD-RRRR'),'MM-DD-RRRR');
      v_giclr204c3_os.file_date     := TO_DATE(TO_CHAR(rec.clm_file_date, 'MM-DD-RRRR'),'MM-DD-RRRR');
      v_giclr204c3_os.loss_amt      := rec.os_amt;
      
      PIPE ROW (v_giclr204c3_os);
    END LOOP;
    RETURN;
  END GICLR204C3_OS;
  
  FUNCTION GICLR204C3_LP(p_session_id   NUMBER)
    RETURN giclr204c3_typ PIPELINED IS
    v_giclr204c3_lp     giclr204c3_rectype;
  BEGIN
    FOR rec IN (SELECT a.iss_cd, e.iss_name, a.assd_no, c.assd_name,
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim,
                       b.dsp_loss_date, SUM(a.loss_paid) loss_paid
                  FROM gicl_lratio_loss_paid_ext a, gicl_claims b, giis_assured c, giis_issource e
                 WHERE a.session_id = p_session_id
                   AND a.assd_no = c.assd_no
                   AND a.iss_cd = e.iss_cd
                   AND a.claim_id = b.claim_id
                 GROUP BY a.iss_cd, e.iss_name, a.assd_no, c.assd_name,
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                       b.dsp_loss_date
                 ORDER BY claim)
    LOOP
      v_giclr204c3_lp.iss_cd        := rec.iss_cd||' - '||rec.iss_name;
      v_giclr204c3_lp.claim_no      := rec.claim;
      v_giclr204c3_lp.assd_name     := TO_CHAR(rec.assd_no)||' '||rec.assd_name;
      v_giclr204c3_lp.loss_date     := TO_DATE(TO_CHAR(rec.dsp_loss_date, 'MM-DD-RRRR'),'MM-DD-RRRR');
      v_giclr204c3_lp.loss_amt      := rec.loss_paid;
      
      PIPE ROW (v_giclr204c3_lp);
    END LOOP;
    RETURN;
  END GICLR204C3_LP;
  
  FUNCTION GICLR204C3_LR(p_session_id   NUMBER,
                         p_date         VARCHAR2)
    RETURN giclr204c3_typ PIPELINED IS
    v_giclr204c3_lr     giclr204c3_rectype;
  BEGIN
    FOR rec IN (SELECT a.iss_cd, f.iss_name, a.assd_no, b.assd_name, d.rec_type_desc,
                       SUM(a.recovered_amt) recovered_amt, e.dsp_loss_date,
                       c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery
                  FROM (SELECT * FROM gicl_lratio_curr_recovery_ext
                         WHERE p_date = 'CURR'
                        UNION
                        SELECT * FROM gicl_lratio_prev_recovery_ext
                         WHERE p_date = 'PREV') a,
                       giis_assured b, gicl_clm_recovery c, giis_recovery_type d,
                       gicl_claims e, giis_issource f
                 WHERE a.assd_no = b.assd_no
                   AND a.iss_cd = f.iss_cd
                   AND a.recovery_id = c.recovery_id
                   AND c.rec_type_cd = d.rec_type_cd
                   AND c.claim_id = e.claim_id
                   AND a.session_id = p_session_id
                 GROUP BY a.iss_cd, f.iss_name, a.assd_no, b.assd_name, d.rec_type_desc, e.dsp_loss_date,
                       c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009'))
                 ORDER BY recovery)
    LOOP
      v_giclr204c3_lr.iss_cd            := rec.iss_cd||' - '||rec.iss_name;
      v_giclr204c3_lr.recovery_no       := rec.recovery;
      v_giclr204c3_lr.assd_name         := TO_CHAR(rec.assd_no)||' '||rec.assd_name;
      v_giclr204c3_lr.recovery_type     := rec.rec_type_desc;
      v_giclr204c3_lr.loss_date         := TO_DATE(TO_CHAR(rec.dsp_loss_date, 'MM-DD-RRRR'),'MM-DD-RRRR');
      v_giclr204c3_lr.recovery_amt      := rec.recovered_amt;
      
      PIPE ROW (v_giclr204c3_lr);
    END LOOP;
  END GICLR204C3_LR;
  --Start John Michael Mabini SR-5386 04042016
 FUNCTION format_amt(amt NUMBER)
 RETURN VARCHAR2
    IS
    BEGIN
        RETURN to_char(amt, '9,999,999,999.99');
    END ;
   FUNCTION csv_giclr204B (
      p_assd_no      NUMBER,
      p_date         VARCHAR2,
      p_intm_no      NUMBER,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_session_id   NUMBER,
      p_subline_cd   VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.subline_cd, a.loss_ratio_date,
                         NVL (a.curr_prem_amt, 0) curr_prem_amt,
                         NVL (a.curr_prem_res, 0) prem_res_cy,
                         NVL (a.prev_prem_res, 0) prem_res_py,
                         NVL (a.loss_paid_amt, 0) loss_paid_amt,
                         NVL (a.curr_loss_res, 0) curr_loss_res,
                         NVL (a.prev_loss_res, 0) prev_loss_res,
                         (  NVL (a.curr_prem_amt, 0)
                          + NVL (a.prev_prem_res, 0)
                          - NVL (a.curr_prem_res, 0)
                         ) premiums_earned,
                         (  NVL (a.loss_paid_amt, 0)
                          + NVL (a.curr_loss_res, 0)
                          - NVL (a.prev_loss_res, 0)
                         ) losses_incurred,
                         a.iss_cd, a.assd_no, a.intm_no
                    FROM gicl_loss_ratio_ext a
                   WHERE a.session_id = p_session_id
                ORDER BY get_loss_ratio (a.session_id,
                                         a.line_cd,
                                         a.subline_cd,
                                         a.iss_cd,
                                         a.peril_cd,
                                         a.intm_no,
                                         a.assd_no
                                        ) DESC)
      LOOP
       
         BEGIN
            SELECT p_line_cd
                   || ' - '
                   || line_name
              INTO v_list.Line
              FROM giis_line
             WHERE line_cd = p_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.Line := '';
         END;

         BEGIN
            SELECT i.subline_cd || ' - ' || subline_name
              INTO v_list.subline
              FROM giis_subline
             WHERE line_cd = p_line_cd AND subline_cd = i.subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.subline := NULL;
         END;

         v_list.Losses_Paid := format_amt(i.loss_paid_amt);
         v_list.Outstanding_Loss_CY := format_amt(i.curr_loss_res);
         v_list.Outstanding_Loss_PY := format_amt(i.prev_loss_res);
         v_list.Premiums_Written := format_amt(i.curr_prem_amt);
         v_list.Premiums_Reserve_CY := format_amt(i.prem_res_cy);
         v_list.Premiums_Reserve_PY := format_amt(i.prem_res_py);
         v_list.Losses_Incurred := format_amt(i.losses_incurred);
         v_list.Premiums_Earned := format_amt(i.premiums_earned);

         IF NVL (i.premiums_earned, 0) != 0
         THEN
            v_list.Loss_Ratio :=
                       ROUND(NVL ((i.losses_incurred / i.premiums_earned) * 100, 0), 4);
         ELSE
            v_list.Loss_Ratio := 0;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204B;
--End
-- printGICLR204A added by carlo de guzman 3.15.2016--
    FUNCTION csv_giclr204A(
        p_session_id NUMBER,
        p_date       DATE,
        p_line_cd   GIIS_LINE.LINE_CD%TYPE,
        p_subline_cd GIIS_SUBLINE.SUBLINE_CD%TYPE,
        p_intm_no   GIIS_INTERMEDIARY.intm_no%TYPE,
        p_iss_cd    GIIS_ISSOURCE.iss_CD%TYPE,
        p_ASSD_NO    GIIS_assured.ASSD_NO%TYPE
    )
    RETURN GICLR204A_tab PIPELINED as 

        v_rec GICLR204A_type;
        v_as_of_date    VARCHAR2(100);
     
    BEGIN
        FOR a IN(
             SELECT 
                    a.line_cd, 
                    a.loss_ratio_date, 
                    a.curr_prem_amt,
                    (a.curr_prem_res) prem_res_cy, 
                    (a.prev_prem_res) prem_res_py, 
                    NVL(a.loss_paid_amt,0) loss_paid_amt,
                    NVL(a.curr_loss_res,0) curr_loss_res,
                    NVL(a.prev_loss_res,0) prev_loss_res,
                    GICLR204A_PKG.GET_LINE_NAME(a.line_cd) line_name,
                    GICLR204A_PKG.GET_SUBLINE_NAME(p_subline_cd) subline_name,
                    GICLR204A_PKG.GET_INTM_NAME(p_intm_no) intm_name,
                    GICLR204A_PKG.GET_ISS_NAME(p_iss_cd) iss_name,
                    GICLR204A_PKG.GET_ASSD_NAME(p_ASSD_NO) ASSD_name,
                    nvl(a.curr_prem_amt,0) + nvl(a.prev_prem_res,0) - nvl(a.curr_prem_res,0) premiums_earned,
                    nvl(a.loss_paid_amt,0) + nvl(a.curr_loss_res,0) - nvl(a.prev_loss_res,0) losses_incurred,
                    'As of '||to_char(p_date, 'fmMonth DD, YYYY') as_of_date
            FROM    gicl_loss_ratio_ext a
            WHERE   a.session_id =p_session_id
            order by get_loss_ratio(a.session_id,a.line_cd,a.subline_cd,a.iss_cd,a.peril_cd,a.intm_no,a.assd_no) DESC
         )
            LOOP
                    --v_rec.company_name      :=  giacp.v('COMPANY_NAME');
                    --v_rec.company_address   :=  giacp.v('COMPANY_ADDRESS');
                    --v_rec.line_cd           :=  a.line_cd;
                    --v_rec.loss_ratio_date   :=  a.loss_ratio_date;
                    v_rec.premiums_written     :=  NVL(a.curr_prem_amt, 0);  
                    v_rec.premiums_reserve_current_year       :=  a.prem_res_cy;
                    v_rec.premiums_reserve_previous_year       :=  a.prem_res_py;
                    v_rec.losses_paid     :=  a.loss_paid_amt;
                    v_rec.outstanding_loss_current_year     :=  a.curr_loss_res;
                    v_rec.outstanding_loss_previous_year     :=  a.prev_loss_res;  
                    v_rec.premiums_earned   :=  a.premiums_earned; 
                    v_rec.losses_incurred   :=  a.losses_incurred;
                    v_rec.line             :=  a.line_cd ||' - '||a.line_name;
                    
                    if nvl(a.premiums_earned, 0) != 0 then
                      v_rec.loss_ratio := (a.losses_incurred / a.premiums_earned) * 100;
                    else
                      v_rec.loss_ratio := 0;
                    end if;     
                                  
                PIPE ROW (v_rec);
                
            END LOOP;          
     
    END csv_giclr204A;    
    FUNCTION get_line_name(
        p_line_cd       GIIS_LINE.LINE_CD%TYPE
       )
    RETURN VARCHAR2 as 
        v_line_name       GIIS_LINE.LINE_NAME%TYPE;
    BEGIN
        SELECT  line_name
        INTO    V_LINE_NAME 
        FROM    GIIS_LINE
        where   line_cd = p_line_cd; 
        
        return v_line_name;      
    END;
    FUNCTION GET_SUBLINE_NAME(
        p_subline_cd       GIIS_SUBLINE.SUBLINE_CD%TYPE
      )
    RETURN VARCHAR2 as
        v_subline_name       GIIS_SUBLINE.SUBLINE_NAME%TYPE;
        
    BEGIN
        SELECT  subline_name
        INTO    V_SUBLINE_NAME 
        FROM    GIIS_SUBLINE
        where   subline_cd = p_subline_cd; 
        
    return v_subline_name;      
    END GET_SUBLINE_NAME;
    FUNCTION GET_ISS_NAME(
        p_iss_cd       GIIS_ISSOURCE.iss_CD%TYPE
      )
    RETURN VARCHAR2 as
        v_iss_name       GIIS_ISSOURCE.ISS_NAME%TYPE;
        
    BEGIN
        SELECT  iss_name
        INTO    V_iss_NAME 
        FROM    GIIS_ISSOURCE
        where   iss_cd = p_iss_cd; 
        
    return v_iss_name;      
    END GET_ISS_NAME;
    FUNCTION GET_INTM_NAME(
        p_intm_no       GIIS_INTERMEDIARY.intm_no%TYPE
      )
    RETURN VARCHAR2 as
        v_intm_name       GIIS_INTERMEDIARY.intm_NAME%TYPE;
        
    BEGIN
        SELECT  intm_name
        INTO    V_INTM_NAME 
        FROM    GIIS_INTERMEDIARY
        where   intm_no = p_intm_no; 
        
    return v_INTM_name;      
    END GET_INTM_NAME;
    FUNCTION GET_assD_NAME(
        p_ASSD_no       GIIS_assured.ASSD_no%TYPE
      )
    RETURN VARCHAR2 as
        v_ASSD_name       GIIS_asSURED.ASSD_NAME%TYPE;
        
    BEGIN
        SELECT  ASSD_name
        INTO    V_ASSD_NAME 
        FROM    GIIS_assured
        where   ASSD_no = p_ASSD_no; 
        
    return v_ASSD_name;      
    END GET_ASSD_NAME;
-- printGICLR204A END--
  
    --Start: added by Kevin SR-5389
   FUNCTION amount_format (amount NUMBER)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN TO_CHAR (amount, '99,999,999,999.99');
   END;

   FUNCTION DATE_FORMAT (v_date DATE)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN TO_CHAR (v_date, 'MM-DD-YYYY');
   END;

   FUNCTION get_giclr204c2_iss (p_iss_cd VARCHAR2, p_iss_name VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (p_iss_cd || ' - ' || p_iss_name);
   END get_giclr204c2_iss;

   FUNCTION get_giclr204c2_policy_func (
      p_endt_seq_no   NUMBER,
      p_policy        VARCHAR2,
      p_endt_iss_cd   VARCHAR2,
      p_endt_yy       NUMBER
   )
      RETURN VARCHAR2
   IS
   BEGIN
      IF p_endt_seq_no != 0
      THEN
         RETURN (   p_policy
                 || '/'
                 || p_endt_iss_cd
                 || '-'
                 || TO_CHAR (p_endt_yy)
                 || '-'
                 || TO_CHAR (p_endt_seq_no)
                );
      ELSE
         RETURN (p_policy);
      END IF;

      RETURN NULL;
   END get_giclr204c2_policy_func;

   FUNCTION get_giclr204c2_assd (p_assd_no NUMBER, p_assd_name VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (TO_CHAR (p_assd_no) || ' ' || p_assd_name);
   END get_giclr204c2_assd;

   FUNCTION get_giclr204c2_as_date (p_policy_id NUMBER, p_prnt_date NUMBER)
      RETURN CHAR
   IS
   BEGIN
      IF p_prnt_date = 1
      THEN
         FOR rec IN (SELECT issue_date
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id)
         LOOP
            RETURN (TO_CHAR (rec.issue_date, 'MM-DD-RRRR'));
         END LOOP;
      ELSIF p_prnt_date = 3
      THEN
         FOR rec IN (SELECT acct_ent_date
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id)
         LOOP
            RETURN (TO_CHAR (rec.acct_ent_date, 'MM-DD-RRRR'));
         END LOOP;
      ELSIF p_prnt_date = 4
      THEN
         FOR rec IN (SELECT    booking_mth
                            || ' '
                            || TO_CHAR (booking_year) booking_date
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id)
         LOOP
            RETURN (rec.booking_date);
         END LOOP;
      ELSE
         RETURN (NULL);
      END IF;
   END get_giclr204c2_as_date;

   FUNCTION csv_giclr204c2_records (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_record_tab PIPELINED
   IS
      v_list   giclr204c2_record_type;
   BEGIN
      FOR i IN (SELECT   b.iss_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.iss_name, d.assd_name,
                         a.policy_id
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.iss_name,
                         d.assd_name,
                         a.iss_cd,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.POLICY :=
            get_giclr204c2_policy_func (i.endt_seq_no,
                                        i.POLICY,
                                        i.endt_iss_cd,
                                        i.endt_yy
                                       );
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.incept_date := DATE_FORMAT (i.incept_date);
         v_list.expiry_date := DATE_FORMAT (i.expiry_date);
         v_list.tsi_amount := amount_format (i.tsi_amt);
         v_list.premium_amount := amount_format (i.prem_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2_records;

   FUNCTION csv_giclr204c2_records1 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_record1_tab PIPELINED
   IS
      v_list   giclr204c2_record1_type;
   BEGIN
      FOR i IN (SELECT   b.iss_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.iss_name, d.assd_name,
                         a.policy_id
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.iss_name,
                         d.assd_name,
                         a.iss_cd,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.POLICY :=
            get_giclr204c2_policy_func (i.endt_seq_no,
                                        i.POLICY,
                                        i.endt_iss_cd,
                                        i.endt_yy
                                       );
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.incept_date := DATE_FORMAT (i.incept_date);
         v_list.expiry_date := DATE_FORMAT (i.expiry_date);
         v_list.tsi_amount := amount_format (i.tsi_amt);
         v_list.premium_amount := amount_format (i.prem_amt);
         v_list.issue_date :=
                             get_giclr204c2_as_date (i.policy_id, p_prnt_date);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2_records1;

   FUNCTION csv_giclr204c2_records3 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_record3_tab PIPELINED
   IS
      v_list   giclr204c2_record3_type;
   BEGIN
      FOR i IN (SELECT   b.iss_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.iss_name, d.assd_name,
                         a.policy_id
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.iss_name,
                         d.assd_name,
                         a.iss_cd,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.POLICY :=
            get_giclr204c2_policy_func (i.endt_seq_no,
                                        i.POLICY,
                                        i.endt_iss_cd,
                                        i.endt_yy
                                       );
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.incept_date := DATE_FORMAT (i.incept_date);
         v_list.expiry_date := DATE_FORMAT (i.expiry_date);
         v_list.tsi_amount := amount_format (i.tsi_amt);
         v_list.premium_amount := amount_format (i.prem_amt);
         v_list.acct_ent_date :=
                             get_giclr204c2_as_date (i.policy_id, p_prnt_date);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2_records3;

   FUNCTION csv_giclr204c2_records4 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_record4_tab PIPELINED
   IS
      v_list   giclr204c2_record4_type;
   BEGIN
      FOR i IN (SELECT   b.iss_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.iss_name, d.assd_name,
                         a.policy_id
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.iss_name,
                         d.assd_name,
                         a.iss_cd,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.POLICY :=
            get_giclr204c2_policy_func (i.endt_seq_no,
                                        i.POLICY,
                                        i.endt_iss_cd,
                                        i.endt_yy
                                       );
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.incept_date := DATE_FORMAT (i.incept_date);
         v_list.expiry_date := DATE_FORMAT (i.expiry_date);
         v_list.tsi_amount := amount_format (i.tsi_amt);
         v_list.premium_amount := amount_format (i.prem_amt);
         v_list.booking_date :=
                             get_giclr204c2_as_date (i.policy_id, p_prnt_date);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2_records4;

   FUNCTION csv_giclr204c2g7_records (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2g7_record_tab PIPELINED
   IS
      v_list   giclr204c2g7_record_type;
   BEGIN
      FOR i IN (SELECT   b.iss_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.assd_name, d.iss_name,
                         a.iss_cd a_iss_cd, a.policy_id
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.assd_name,
                         d.iss_name,
                         a.iss_cd,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.POLICY :=
            get_giclr204c2_policy_func (i.endt_seq_no,
                                        i.POLICY,
                                        i.endt_iss_cd,
                                        i.endt_yy
                                       );
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.incept_date := DATE_FORMAT (i.incept_date);
         v_list.expiry_date := DATE_FORMAT (i.expiry_date);
         v_list.tsi_amount := amount_format (i.tsi_amt);
         v_list.premium_amount := amount_format (i.prem_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2g7_records;

   FUNCTION csv_giclr204c2g7_records1 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2g7_record1_tab PIPELINED
   IS
      v_list   giclr204c2g7_record1_type;
   BEGIN
      FOR i IN (SELECT   b.iss_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.assd_name, d.iss_name,
                         a.iss_cd a_iss_cd, a.policy_id
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.assd_name,
                         d.iss_name,
                         a.iss_cd,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.POLICY :=
            get_giclr204c2_policy_func (i.endt_seq_no,
                                        i.POLICY,
                                        i.endt_iss_cd,
                                        i.endt_yy
                                       );
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.incept_date := DATE_FORMAT (i.incept_date);
         v_list.expiry_date := DATE_FORMAT (i.expiry_date);
         v_list.tsi_amount := amount_format (i.tsi_amt);
         v_list.premium_amount := amount_format (i.prem_amt);
         v_list.issue_date :=
                             get_giclr204c2_as_date (i.policy_id, p_prnt_date);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2g7_records1;

   FUNCTION csv_giclr204c2g7_records3 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2g7_record3_tab PIPELINED
   IS
      v_list   giclr204c2g7_record3_type;
   BEGIN
      FOR i IN (SELECT   b.iss_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.assd_name, d.iss_name,
                         a.iss_cd a_iss_cd, a.policy_id
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.assd_name,
                         d.iss_name,
                         a.iss_cd,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.POLICY :=
            get_giclr204c2_policy_func (i.endt_seq_no,
                                        i.POLICY,
                                        i.endt_iss_cd,
                                        i.endt_yy
                                       );
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.incept_date := DATE_FORMAT (i.incept_date);
         v_list.expiry_date := DATE_FORMAT (i.expiry_date);
         v_list.tsi_amount := amount_format (i.tsi_amt);
         v_list.premium_amount := amount_format (i.prem_amt);
         v_list.acct_ent_date :=
                             get_giclr204c2_as_date (i.policy_id, p_prnt_date);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2g7_records3;

   FUNCTION csv_giclr204c2g7_records4 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2g7_record4_tab PIPELINED
   IS
      v_list   giclr204c2g7_record4_type;
   BEGIN
      FOR i IN (SELECT   b.iss_cd, b.assd_no,
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
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) prem_amt, c.assd_name, d.iss_name,
                         a.iss_cd a_iss_cd, a.policy_id
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.assd_name,
                         d.iss_name,
                         a.iss_cd,
                         a.policy_id
                ORDER BY POLICY)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.POLICY :=
            get_giclr204c2_policy_func (i.endt_seq_no,
                                        i.POLICY,
                                        i.endt_iss_cd,
                                        i.endt_yy
                                       );
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.incept_date := DATE_FORMAT (i.incept_date);
         v_list.expiry_date := DATE_FORMAT (i.expiry_date);
         v_list.tsi_amount := amount_format (i.tsi_amt);
         v_list.premium_amount := amount_format (i.prem_amt);
         v_list.booking_date :=
                             get_giclr204c2_as_date (i.policy_id, p_prnt_date);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2g7_records4;

   FUNCTION csv_giclr204c2_claim (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_claim_tab PIPELINED
   IS
      v_list   giclr204c2_claim_type;
   BEGIN
      FOR i IN (SELECT   e.iss_name, a.iss_cd, a.assd_no, d.assd_name,
                         a.claim_id, SUM (os_amt) os_amt, b.dsp_loss_date,
                         b.clm_file_date,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')) claim
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
                ORDER BY claim)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.claim_no := i.claim;
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.loss_date := DATE_FORMAT (i.dsp_loss_date);
         v_list.file_date := DATE_FORMAT (i.clm_file_date);
         v_list.loss_amount := amount_format (i.os_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2_claim;

   FUNCTION csv_giclr204c2_claimg5 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_claimg5_tab PIPELINED
   IS
      v_list   giclr204c2_claimg5_type;
   BEGIN
      FOR i IN (SELECT   e.iss_name, a.iss_cd, a.assd_no, d.assd_name,
                         a.claim_id, SUM (os_amt) os_amt, b.dsp_loss_date,
                         b.clm_file_date,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')) claim
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
                ORDER BY claim)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.claim_no := i.claim;
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.loss_date := DATE_FORMAT (i.dsp_loss_date);
         v_list.file_date := DATE_FORMAT (i.clm_file_date);
         v_list.losst_amount := amount_format (i.os_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2_claimg5;

   FUNCTION csv_giclr204c2_claimg9 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_claimg9_tab PIPELINED
   IS
      v_list   giclr204c2_claimg9_type;
   BEGIN
      FOR i IN (SELECT   a.iss_cd, e.iss_name, a.assd_no, c.assd_name,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')) claim,
                         b.dsp_loss_date, SUM (a.loss_paid) loss_paid,
                         b.clm_file_date
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
                         b.dsp_loss_date,
                         b.clm_file_date
                ORDER BY claim)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.claim_no := i.claim;
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.loss_date := DATE_FORMAT (i.dsp_loss_date);
         v_list.loss_amount := amount_format (i.loss_paid);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2_claimg9;

   FUNCTION csv_giclr204c2_recoveryg11 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_recoveryg11_tab PIPELINED
   IS
      v_list   giclr204c2_recoveryg11_type;
   BEGIN
      FOR i IN (SELECT   a.iss_cd, f.iss_name, a.assd_no, b.assd_name,
                         d.rec_type_desc, SUM (a.recovered_amt)
                                                               recovered_amt,
                         e.dsp_loss_date,
                            c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (rec_year, '0999'))
                         || '-'
                         || LTRIM (TO_CHAR (rec_seq_no, '009')) RECOVERY
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
                ORDER BY RECOVERY)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.recovery_no := i.RECOVERY;
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.recovery_type := i.rec_type_desc;
         v_list.loss_date := DATE_FORMAT (i.dsp_loss_date);
         v_list.recovered_amount := amount_format (i.recovered_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2_recoveryg11;

   FUNCTION csv_giclr204c2_recoveryg13 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_recoveryg13_tab PIPELINED
   IS
      v_list   giclr204c2_recoveryg13_type;
   BEGIN
      FOR i IN (SELECT   a.iss_cd, f.iss_name, a.assd_no, b.assd_name,
                         d.rec_type_desc, SUM (a.recovered_amt)
                                                               recovered_amt,
                         e.dsp_loss_date,
                            c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (rec_year, '0999'))
                         || '-'
                         || LTRIM (TO_CHAR (rec_seq_no, '009')) RECOVERY
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
                ORDER BY RECOVERY)
      LOOP
         v_list.issuing_source := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.recovery_no := i.RECOVERY;
         v_list.assured := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.recovery_type := i.rec_type_desc;
         v_list.loss_date := DATE_FORMAT (i.dsp_loss_date);
         v_list.recovered_amount := amount_format (i.recovered_amt);
         PIPE ROW (v_list);
      END LOOP;
   END csv_giclr204c2_recoveryg13;
--End: Kevin SR-5389

   -- printGICLR204A3_q3_CSV added by carlo de guzman 3.18.2016 SR-5385--
   FUNCTION cf_lineformula (p_line_cd VARCHAR2, p_line_name VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      RETURN (p_line_cd || ' - ' || p_line_name);
   END;

   FUNCTION cf_dateformula (p_prnt_date VARCHAR2, p_policy_id NUMBER)
      RETURN CHAR
   IS
   BEGIN
      IF p_prnt_date = 1
      THEN
         FOR rec IN (SELECT issue_date
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id)
         LOOP
            RETURN (TO_CHAR (rec.issue_date, 'MM-DD-RRRR'));
         END LOOP;
      ELSIF p_prnt_date = 3
      THEN
         FOR rec IN (SELECT acct_ent_date
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id)
         LOOP
            RETURN (TO_CHAR (rec.acct_ent_date, 'MM-DD-RRRR'));
         END LOOP;
      ELSIF p_prnt_date = 4
      THEN
         FOR rec IN (SELECT    booking_mth
                            || ' '
                            || TO_CHAR (booking_year) booking_date
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id)
         LOOP
            RETURN (rec.booking_date);
         END LOOP;
      ELSE
         RETURN (NULL);
      END IF;
   END;

   FUNCTION cf_policyformula (
      p_endt_seq_no   NUMBER,
      p_policy1       VARCHAR2,
      p_endt_iss_cd   VARCHAR2,
      p_endt_yy       NUMBER
   )
      RETURN VARCHAR2
   IS
   BEGIN
      IF p_endt_seq_no != 0
      THEN
         RETURN (   p_policy1
                 || '/'
                 || p_endt_iss_cd
                 || '-'
                 || TO_CHAR (p_endt_yy)
                 || '-'
                 || TO_CHAR (p_endt_seq_no)
                );
      ELSE
         RETURN (p_policy1);
      END IF;

      RETURN NULL;
   END;

   FUNCTION cf_assdformula (p_assd_no NUMBER, p_assd_name VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (TO_CHAR (p_assd_no || ' ' || p_assd_name));
   END;

   FUNCTION csv_giclr204a3_prem_written_cy (
      p_session_id   NUMBER,
      p_prnt_date    VARCHAR2
   )
      RETURN giclr204a3_q3_record_tab PIPELINED
   IS
      v_list   giclr204a3_q3_record_type;
      v_test   BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   b.line_cd, b.assd_no,
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
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy1,
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) sum_prem_amt, c.line_name,
                         a.policy_id, d.assd_name,
                         TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 ) month1
                    FROM gipi_polbasic a,
                         gicl_lratio_curr_prem_ext b,
                         giis_line c,
                         giis_assured d
                   WHERE b.policy_id = a.policy_id
                     AND b.assd_no = d.assd_no(+)
                     AND b.line_cd = c.line_cd(+)
                     AND b.session_id = p_session_id
                GROUP BY b.line_cd,
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.line_name,
                         a.policy_id,
                         d.assd_name,
                         TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 )
                ORDER BY TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 ) DESC,
                         policy1)
      LOOP
         v_test := FALSE;
         v_list.POLICY := i.policy1;
         v_list.incept_date := TO_CHAR (i.incept_date, 'MM-DD-YYYY');
         v_list.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-YYYY');
         v_list.tsi_amount := amount_format (i.tsi_amt);
         v_list.premium_amount := amount_format (i.sum_prem_amt);
         v_list.transaction_date := TO_CHAR (i.month1, 'MONTH YYYY');
         v_list.line := cf_lineformula (i.line_cd, i.line_name);
         v_list.acct_ent_date := cf_dateformula (p_prnt_date, i.policy_id);
         v_list.assured := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         PIPE ROW (v_list);
      END IF;
   END csv_giclr204a3_prem_written_cy;

   -- END --

   -- printGICLR204A3_q4_CSV added by carlo de guzman 3.18.2016 SR-5385--
   FUNCTION csv_giclr204a3_prem_written_py (
      p_session_id   NUMBER,
      p_prnt_date    VARCHAR2
   )
      RETURN giclr204a3_q3_record_tab PIPELINED
   IS
      v_list   giclr204a3_q3_record_type;
      v_test   BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   b.line_cd, b.assd_no,
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
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy1,
                         a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                         a.incept_date, a.expiry_date, a.tsi_amt,
                         SUM (b.prem_amt) sum_prem_amt, c.assd_name,
                         a.policy_id, d.line_name,
                         TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 ) month1
                    FROM gipi_polbasic a,
                         gicl_lratio_prev_prem_ext b,
                         giis_assured c,
                         giis_line d
                   WHERE b.policy_id = a.policy_id
                     AND b.line_cd = d.line_cd(+)
                     AND b.assd_no = c.assd_no(+)
                     AND b.session_id = p_session_id
                GROUP BY b.line_cd,
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
                         a.endt_iss_cd,
                         a.endt_yy,
                         a.endt_seq_no,
                         a.incept_date,
                         a.expiry_date,
                         a.tsi_amt,
                         c.assd_name,
                         a.policy_id,
                         d.line_name,
                         TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 )
                ORDER BY TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 ) DESC,
                         policy1)
      LOOP
         v_test := FALSE;
         v_list.POLICY := i.policy1;
         v_list.incept_date := TO_CHAR (i.incept_date, 'MM-DD-YYYY');
         v_list.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-YYYY');
         v_list.tsi_amount := amount_format (i.tsi_amt);
         v_list.premium_amount := amount_format (i.sum_prem_amt);
         v_list.transaction_date := TO_CHAR (i.month1, 'MONTH YYYY');
         v_list.line := cf_lineformula (i.line_cd, i.line_name);
         v_list.acct_ent_date := cf_dateformula (p_prnt_date, i.policy_id);
         v_list.assured := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         PIPE ROW (v_list);
      END IF;
   END csv_giclr204a3_prem_written_py;

   -- END --

   -- CSVprinting of giclr204A3  carlo de guzman  3018.2016 SR-5385--
   FUNCTION csv_giclr204a3_os_loss_cy (p_session_id NUMBER)
      RETURN giclr204a3_q1_record_tab PIPELINED
   IS
      v_list   giclr204a3_q1_record_type;
      v_test   BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   e.line_name, a.line_cd, a.assd_no, d.assd_name,
                         a.claim_id, SUM (os_amt) sum_os_amt,
                         b.dsp_loss_date, b.clm_file_date,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')) claim
                    FROM gicl_lratio_curr_os_ext a,
                         gicl_claims b,
                         giis_assured d,
                         giis_line e
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = b.claim_id
                     AND a.line_cd = e.line_cd
                     AND a.assd_no = d.assd_no
                GROUP BY a.line_cd,
                         e.line_name,
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
                ORDER BY claim)
      LOOP
         v_test := FALSE;
         v_list.loss_amount := amount_format (i.sum_os_amt);
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-YYYY');
         v_list.file_date := TO_CHAR (i.clm_file_date, 'MM-DD-YYYY');
         v_list.claim_no := i.claim;
         v_list.line := cf_lineformula (i.line_cd, i.line_name);
         v_list.assured := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         PIPE ROW (v_list);
      END IF;
   END csv_giclr204a3_os_loss_cy;

   FUNCTION csv_giclr204a3_os_loss_py (p_session_id NUMBER)
      RETURN giclr204a3_q1_record_tab PIPELINED
   IS
      v_list   giclr204a3_q1_record_type;
      v_test   BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   e.line_name, a.line_cd, a.assd_no, d.assd_name,
                         a.claim_id, SUM (os_amt) sum_os_amt,
                         b.dsp_loss_date, b.clm_file_date,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')) claim
                    FROM gicl_lratio_prev_os_ext a,
                         gicl_claims b,
                         giis_assured d,
                         giis_line e
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = b.claim_id
                     AND a.line_cd = e.line_cd
                     AND a.assd_no = d.assd_no
                GROUP BY a.line_cd,
                         e.line_name,
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
                ORDER BY claim)
      LOOP
         v_test := FALSE;
         v_list.loss_amount := amount_format (i.sum_os_amt);
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-YYYY');
         v_list.file_date := TO_CHAR (i.clm_file_date, 'MM-DD-YYYY');
         v_list.claim_no := i.claim;
         v_list.line := cf_lineformula (i.line_cd, i.line_name);
         v_list.assured := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         PIPE ROW (v_list);
      END IF;
   END csv_giclr204a3_os_loss_py;

   FUNCTION csv_giclr204a3_losses_paid (p_session_id NUMBER)
      RETURN giclr204a3_q5_record_tab PIPELINED
   IS
      v_list   giclr204a3_q5_record_type;
      v_test   BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   a.line_cd, e.line_name, a.assd_no, c.assd_name,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')) claim,
                         b.dsp_loss_date, SUM (a.loss_paid) sum_loss_paid
                    FROM gicl_lratio_loss_paid_ext a,
                         gicl_claims b,
                         giis_assured c,
                         giis_line e
                   WHERE a.session_id = p_session_id
                     AND a.assd_no = c.assd_no
                     AND a.line_cd = e.line_cd
                     AND a.claim_id = b.claim_id
                GROUP BY a.line_cd,
                         e.line_name,
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
                ORDER BY claim)
      LOOP
         v_test := FALSE;
         v_list.claim_no := i.claim;
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-YYYY');
         v_list.loss_amount := amount_format (i.sum_loss_paid);
         v_list.line := cf_lineformula (i.line_cd, i.line_name);
         v_list.assured := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         PIPE ROW (v_list);
      END IF;
   END csv_giclr204a3_losses_paid;

   FUNCTION csv_giclr204a3_loss_reco_cy (p_session_id NUMBER)
      RETURN giclr204a3_q6_record_tab PIPELINED
   IS
      v_list   giclr204a3_q6_record_type;
      v_test   BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   a.line_cd, f.line_name, a.assd_no, b.assd_name,
                         d.rec_type_desc,
                         SUM (a.recovered_amt) sum_recovered_amt,
                         e.dsp_loss_date,
                            c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (rec_year, '0999'))
                         || '-'
                         || LTRIM (TO_CHAR (rec_seq_no, '009')) recovery1
                    FROM gicl_lratio_curr_recovery_ext a,
                         giis_assured b,
                         gicl_clm_recovery c,
                         giis_recovery_type d,
                         gicl_claims e,
                         giis_line f
                   WHERE a.assd_no = b.assd_no
                     AND a.line_cd = f.line_cd
                     AND a.recovery_id = c.recovery_id
                     AND c.rec_type_cd = d.rec_type_cd
                     AND c.claim_id = e.claim_id
                     AND a.session_id = p_session_id
                GROUP BY a.line_cd,
                         f.line_name,
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
                ORDER BY recovery1)
      LOOP
         v_test := FALSE;
         v_list.recovery_type := i.rec_type_desc;
         v_list.recovered_amount := amount_format (i.sum_recovered_amt);
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-YYYY');
         v_list.recovery_no := i.recovery1;
         v_list.line := cf_lineformula (i.line_cd, i.line_name);
         v_list.assured := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         PIPE ROW (v_list);
      END IF;
   END csv_giclr204a3_loss_reco_cy;

   FUNCTION csv_giclr204a3_loss_reco_py (p_session_id NUMBER)
      RETURN giclr204a3_q6_record_tab PIPELINED
   IS
      v_list   giclr204a3_q6_record_type;
      v_test   BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   a.line_cd, f.line_name, a.assd_no, b.assd_name,
                         d.rec_type_desc,
                         SUM (a.recovered_amt) sum_recovered_amt,
                         e.dsp_loss_date,
                            c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (rec_year, '0999'))
                         || '-'
                         || LTRIM (TO_CHAR (rec_seq_no, '009')) recovery1
                    FROM gicl_lratio_prev_recovery_ext a,
                         giis_assured b,
                         gicl_clm_recovery c,
                         giis_recovery_type d,
                         gicl_claims e,
                         giis_line f
                   WHERE a.assd_no = b.assd_no
                     AND a.line_cd = f.line_cd
                     AND a.recovery_id = c.recovery_id
                     AND c.rec_type_cd = d.rec_type_cd
                     AND c.claim_id = e.claim_id
                     AND a.session_id = p_session_id
                GROUP BY a.line_cd,
                         f.line_name,
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
                ORDER BY recovery1)
      LOOP
         v_test := FALSE;
         v_list.recovery_type := i.rec_type_desc;
         v_list.recovered_amount := amount_format (i.sum_recovered_amt);
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-YYYY');
         v_list.recovery_no := i.recovery1;
         v_list.line := cf_lineformula (i.line_cd, i.line_name);
         v_list.assured := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         PIPE ROW (v_list);
      END IF;
   END csv_giclr204a3_loss_reco_py;
   
-- end SR-5385 --

       -- GICLR204F2 CSV printing added by carlo de guzman 3.23.2016 SR 5395
   --added by carlo rubenecia 04.14.2016 SR 5395 --START
   
   FUNCTION csv_giclr204F2_pw_cy1( 
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab1 PIPELINED AS
      cp                    prem_details_type1;
   BEGIN
      FOR i IN (SELECT b.peril_cd, b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.peril_name, d.assd_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_curr_prem_ext b, giis_peril c, giis_assured d
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = d.assd_no (+)
                   AND b.line_cd = c.line_cd
                   AND b.peril_cd = c.peril_cd (+)
                   AND b.session_id = p_session_id
                 GROUP BY b.peril_cd, b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                          a.incept_date, a.expiry_date, a.tsi_amt, c.peril_name, d.assd_name, a.policy_id
                 ORDER BY 1, 3)
      LOOP
         cp.peril := i.peril_cd || ' - ' || i.peril_name;
         cp.assured := i.assd_no || ' ' || i.assd_name;
         cp.policy := i.policy_no;       
         cp.incept_date := TO_CHAR(i.incept_date,'MM-dd-yyyy');
         cp.expiry_date := TO_CHAR(i.expiry_date,'MM-dd-yyyy');     
         cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));           
         cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));
         cp.issue_date := CSV_LOSS_RATIO.cf_dateformula(p_prnt_date, i.policy_id);
         PIPE ROW(cp);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F2_pw_cy2( 
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab2 PIPELINED AS
      cp                    prem_details_type2;
   BEGIN
      FOR i IN (SELECT b.peril_cd, b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.peril_name, d.assd_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_curr_prem_ext b, giis_peril c, giis_assured d
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = d.assd_no (+)
                   AND b.line_cd = c.line_cd
                   AND b.peril_cd = c.peril_cd (+)
                   AND b.session_id = p_session_id
                 GROUP BY b.peril_cd, b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                          a.incept_date, a.expiry_date, a.tsi_amt, c.peril_name, d.assd_name, a.policy_id
                 ORDER BY 1, 3)
      LOOP
         cp.peril := i.peril_cd || ' - ' || i.peril_name;
         cp.assured := i.assd_no || ' ' || i.assd_name;
         cp.policy := i.policy_no;       
         cp.incept_date := TO_CHAR(i.incept_date, 'MM-dd-yyyy');
         cp.expiry_date := TO_CHAR(i.expiry_date, 'MM-dd-yyy');           
         cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));           
         cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));
         cp.acct_end_date := CSV_LOSS_RATIO.cf_dateformula(p_prnt_date, i.policy_id);
         PIPE ROW(cp);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F2_pw_cy3( 
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab3 PIPELINED AS
      cp                    prem_details_type3;
   BEGIN
      FOR i IN (SELECT b.peril_cd, b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.peril_name, d.assd_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_curr_prem_ext b, giis_peril c, giis_assured d
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = d.assd_no (+)
                   AND b.line_cd = c.line_cd
                   AND b.peril_cd = c.peril_cd (+)
                   AND b.session_id = p_session_id
                 GROUP BY b.peril_cd, b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                          a.incept_date, a.expiry_date, a.tsi_amt, c.peril_name, d.assd_name, a.policy_id
                 ORDER BY 1, 3)
      LOOP
         cp.peril := i.peril_cd || ' - ' || i.peril_name;
         cp.assured := i.assd_no || ' ' || i.assd_name;
         cp.policy := i.policy_no;       
         cp.incept_date := TO_CHAR(i.incept_date, 'MM-dd-yyyy');
         cp.expiry_date := TO_CHAR(i.expiry_date, 'MM-dd-yyy');           
         cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));             
         cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));  
         cp.booking_date := CSV_LOSS_RATIO.cf_dateformula(p_prnt_date, i.policy_id);
         PIPE ROW(cp);
      END LOOP;
   END;
 
   FUNCTION csv_giclr204F2_pw_py1(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab1 PIPELINED AS
      pp                    prem_details_type1;
   BEGIN
      FOR i IN (SELECT b.peril_cd, b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, d.peril_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_prev_prem_ext b, giis_assured c, giis_peril d
                 WHERE b.policy_id = a.policy_id
                   AND b.line_cd = d.line_cd 
                   AND b.peril_cd = d.peril_cd (+)
                   AND b.assd_no = c.assd_no (+)
                   AND b.session_id = p_session_id
                 GROUP BY b.peril_cd, b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                          a.incept_date, a.expiry_date, a.tsi_amt,  c.assd_name, d.peril_name, a.policy_id
                 ORDER BY 1, 3)
      LOOP
         pp.peril := i.peril_cd || ' - ' || i.peril_name;
         pp.assured := i.assd_no || ' ' || i.assd_name;
         pp.policy := i.policy_no;       
         pp.incept_date := TO_CHAR(i.incept_date, 'MM-dd-yyyy');
         pp.expiry_date := TO_CHAR(i.expiry_date, 'MM-dd-yyy');          
         pp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));         
         pp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));  
         pp.issue_date := CSV_LOSS_RATIO.cf_dateformula(p_prnt_date, i.policy_id);
         PIPE ROW(pp);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F2_pw_py2(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab2 PIPELINED AS
      pp                    prem_details_type2;
   BEGIN
      FOR i IN (SELECT b.peril_cd, b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, d.peril_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_prev_prem_ext b, giis_assured c, giis_peril d
                 WHERE b.policy_id = a.policy_id
                   AND b.line_cd = d.line_cd 
                   AND b.peril_cd = d.peril_cd (+)
                   AND b.assd_no = c.assd_no (+)
                   AND b.session_id = p_session_id
                 GROUP BY b.peril_cd, b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                          a.incept_date, a.expiry_date, a.tsi_amt,  c.assd_name, d.peril_name, a.policy_id
                 ORDER BY 1, 3)
      LOOP
         pp.peril := i.peril_cd || ' - ' || i.peril_name;
         pp.assured := i.assd_no || ' ' || i.assd_name;
         pp.policy := i.policy_no;       
         pp.incept_date := TO_CHAR(i.incept_date, 'MM-dd-yyyy');
         pp.expiry_date := TO_CHAR(i.expiry_date, 'MM-dd-yyy');         
         pp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));       
         pp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));   
         pp.acct_end_date := CSV_LOSS_RATIO.cf_dateformula(p_prnt_date, i.policy_id);
         PIPE ROW(pp);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F2_pw_py3(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab3 PIPELINED AS
      pp                    prem_details_type3;
   BEGIN
      FOR i IN (SELECT b.peril_cd, b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, d.peril_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_prev_prem_ext b, giis_assured c, giis_peril d
                 WHERE b.policy_id = a.policy_id
                   AND b.line_cd = d.line_cd 
                   AND b.peril_cd = d.peril_cd (+)
                   AND b.assd_no = c.assd_no (+)
                   AND b.session_id = p_session_id
                 GROUP BY b.peril_cd, b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                          a.incept_date, a.expiry_date, a.tsi_amt,  c.assd_name, d.peril_name, a.policy_id
                 ORDER BY 1, 3)
      LOOP
         pp.peril := i.peril_cd || ' - ' || i.peril_name;
         pp.assured := i.assd_no || ' ' || i.assd_name;
         pp.policy := i.policy_no;       
         pp.incept_date := TO_CHAR(i.incept_date, 'MM-dd-yyyy');
         pp.expiry_date := TO_CHAR(i.expiry_date, 'MM-dd-yyy');            
         pp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));         
         pp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));    
         pp.booking_date := CSV_LOSS_RATIO.cf_dateformula(p_prnt_date, i.policy_id);
         PIPE ROW(pp);
      END LOOP;
   END;
   
     --added by carlo rubenecia 04.14.2016 SR 5395 --END
   FUNCTION csv_giclr204F2_os_loss_cy(
      p_session_id          gicl_lratio_curr_os_ext.session_id%TYPE
   ) RETURN os_details_tab PIPELINED AS
      co                    os_details_type;
   BEGIN
      FOR i IN (SELECT a.peril_cd, a.assd_no, d.assd_name, a.claim_id, SUM(os_amt) sum_os_amt, c.peril_name, b.dsp_loss_date, b.clm_file_date, 
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) claim_no
                  FROM gicl_lratio_curr_os_ext a, gicl_claims b, giis_peril c, giis_assured d
                 WHERE a.session_id = p_session_id
                   AND a.claim_id = b.claim_id 
                   AND a.peril_cd = c.peril_cd
                   AND b.line_cd  = c.line_cd
                   AND a.assd_no = d.assd_no
                 GROUP BY a.peril_cd, c.peril_name,  a.claim_id,  a.assd_no, d.assd_name, b.dsp_loss_date, b.clm_file_date,b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))
                 ORDER BY 1, 9)
      LOOP
         co.peril := i.peril_cd || ' - ' || i.peril_name ;
         co.assured := i.assd_no || ' ' || i.assd_name;
         co.loss_amount := TRIM(TO_CHAR(i.sum_os_amt, '999,999,999,990.00')); --modified by carlo rubenecia 04.15.2016
         co.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-dd-yyyy');--modified by carlo rubenecia 04.15.2016
         co.file_date := TO_CHAR(i.clm_file_date, 'MM-dd-yyyy');--modified by carlo rubenecia 04.15.2016
         co.claim_no := i.claim_no;
         PIPE ROW(co);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F2_os_loss_py(
      p_session_id          gicl_lratio_prev_os_ext.session_id%TYPE
   ) RETURN os_details_tab PIPELINED AS
      po                    os_details_type;
   BEGIN
      FOR i IN (SELECT a.assd_no, d.assd_name, a.claim_id, a.peril_cd, SUM(os_amt) sum_os_amt, c.peril_name, b.dsp_loss_date, b.clm_file_date, 
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) claim_no
                  FROM gicl_lratio_prev_os_ext a, gicl_claims b, giis_peril c, giis_assured d
                 WHERE a.session_id = p_session_id
                   AND a.claim_id = b.claim_id 
                   AND a.peril_cd = c.peril_cd
                   AND b.line_cd  = c.line_cd
                   AND a.assd_no = d.assd_no
                 GROUP BY a.peril_cd, a.claim_id, a.assd_no, d.assd_name, c.peril_name, b.dsp_loss_date, b.clm_file_date,
                          b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))
                 ORDER BY 1, 9)
      LOOP
        po.peril := i.peril_cd || ' - ' || i.peril_name ;
        po.assured := i.assd_no || ' ' || i.assd_name;
        po.loss_amount := TRIM(TO_CHAR(i.sum_os_amt, '999,999,999,990.00')); --modified by carlo rubenecia 04.15.2016
        po.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-dd-yyyy'); --modified by carlo rubenecia 04.15.2016
        po.file_date := TO_CHAR(i.clm_file_date, 'MM-dd-yyyy'); --modified by carlo rubenecia 04.15.2016
        po.claim_no := i.claim_no;
        PIPE ROW(po);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F2_losses_paid(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN loss_paid_details_tab PIPELINED AS
      lp                    loss_paid_details_type;
   BEGIN
      FOR i IN (SELECT a.assd_no, c.assd_name, b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) claim_no,
                       a.peril_cd, d.peril_name, b.dsp_loss_date, SUM(a.loss_paid) sum_loss_paid
                  FROM gicl_lratio_loss_paid_ext a, gicl_claims b, giis_assured c, giis_peril d
                 WHERE a.session_id = p_session_id
                   AND a.assd_no = c.assd_no
                   AND a.claim_id = b.claim_id
                   AND a.peril_cd = d.peril_cd
                   AND a.line_cd = d.line_cd
                 GROUP BY a.peril_cd, d.peril_name, a.assd_no, c.assd_name, b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')), b.dsp_loss_date
                 ORDER BY 1, 3)
      LOOP
         lp.assured := i.assd_no || ' ' || i.assd_name;
         lp.claim_no := i.claim_no;
         lp.peril := i.peril_cd || ' - ' || i.peril_name;
         lp.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-dd-yyyy'); --modified by carlo rubenecia 04.15.2016
         lp.loss_amount := TRIM(TO_CHAR(i.sum_loss_paid, '999,999,999,990.00')); --modified by carlo rubenecia 04.15.2016
         PIPE ROW(lp);
      END LOOP;
   END;                
   
   FUNCTION csv_giclr204F2_loss_reco_cy(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN rec_details_tab PIPELINED AS
      cr                    rec_details_type;
   BEGIN
      FOR i IN (SELECT a.peril_cd, f.peril_name, a.assd_no, b.assd_name, d.rec_type_desc, SUM(a.recovered_amt) sum_recovered_amt, e.dsp_loss_date,
                       c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no
                  FROM gicl_lratio_curr_recovery_ext a, giis_assured b, gicl_clm_recovery c, giis_recovery_type d, gicl_claims e, giis_peril f
                 WHERE a.assd_no = b.assd_no
                   AND a.line_cd = f.line_cd
                   AND a.peril_cd = f.peril_cd
                   AND a.recovery_id = c.recovery_id
                   AND c.rec_type_cd = d.rec_type_cd
                   AND c.claim_id = e.claim_id
                   AND a.session_id = p_session_id
                 GROUP BY a.peril_cd, f.peril_name, a.assd_no, b.assd_name, d.rec_type_desc, e.dsp_loss_date, 
                          c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009'))
                 ORDER BY 1, 8)
      LOOP
         cr.peril := i.peril_cd || ' - ' || i.peril_name;
         cr.assured := i.assd_no || ' ' || i.assd_name;
         cr.recovery_type := i.rec_type_desc;
         cr.loss_amount := TRIM(TO_CHAR(i.sum_recovered_amt, '999,999,999,990.00')); --modified by carlo rubenecia 04.15.2016
         cr.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-dd-yyyy'); --modified by carlo rubenecia 04.15.2016
         PIPE ROW(cr);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F2_loss_reco_py(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN rec_details_tab PIPELINED AS
      pr                    rec_details_type;
   BEGIN
      FOR i IN (SELECT a.peril_cd, f.peril_name, a.assd_no, b.assd_name, d.rec_type_desc, SUM(a.recovered_amt) sum_recovered_amt, e.dsp_loss_date, 
                       c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no
                  FROM gicl_lratio_prev_recovery_ext a, giis_assured b, gicl_clm_recovery c, giis_recovery_type d, gicl_claims e, giis_peril f
                 WHERE a.assd_no = b.assd_no
                   AND a.line_cd = f.line_cd
                   AND a.peril_cd = f.peril_cd
                   AND a.recovery_id = c.recovery_id
                   AND c.rec_type_cd = d.rec_type_cd
                   AND c.claim_id = e.claim_id
                   AND a.session_id = p_session_id
                 GROUP BY a.peril_cd, f.peril_name, a.assd_no, b.assd_name, d.rec_type_desc,  e.dsp_loss_date,
                          c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009'))
                 ORDER BY recovery_no)
      LOOP
         pr.peril := i.peril_cd || ' - ' || i.peril_name;
         pr.assured := i.assd_no || ' ' || i.assd_name;
         pr.recovery_type := i.rec_type_desc;
         pr.loss_amount := TRIM(TO_CHAR(i.sum_recovered_amt, '999,999,999,990.00')); --modified by carlo rubenecia 04.15.2016
         pr.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-dd-yyyy');  --modified by carlo rubenecia 04.15.2016
         PIPE ROW(pr);
      END LOOP;
   END;
  -- GICLR204F2 CSV printing end SR 5395 --
  
  -- CSVprinting of GICLR204E  Mark Anthony Salazar  03.22.2016--
FUNCTION cf_assd_name (p_assd_no NUMBER)
      RETURN VARCHAR2
   IS
      v_assd   giis_assured.assd_name%TYPE;
   BEGIN
      BEGIN
         SELECT assd_name
           INTO v_assd
           FROM giis_assured
          WHERE assd_no = p_assd_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN v_assd;
   END;
   FUNCTION csv_giclr204E (
      p_assd_no      NUMBER,
      p_intm_no      NUMBER,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_session_id   NUMBER,
      p_subline_cd   VARCHAR2,
      p_date         VARCHAR2
   )
      RETURN giclr204e_record_tab PIPELINED
   IS
      v_rec   giclr204e_record_type;
   BEGIN
      FOR i IN (SELECT   a.assd_no, a.line_cd, a.loss_ratio_date,
                         NVL(a.curr_prem_amt, 0) curr_prem_amt, 
                         NVL (a.curr_prem_res, 0) prem_res_cy,
                         NVL (a.prev_prem_res, 0) prem_res_py,
                         NVL (a.loss_paid_amt, 0) loss_paid_amt,
                         NVL (a.curr_loss_res, 0) curr_loss_res,
                         NVL (a.prev_loss_res, 0) prev_loss_res,
                         (  NVL (a.curr_prem_amt, 0)
                          + NVL (a.prev_prem_res, 0)
                          - NVL (a.curr_prem_res, 0)
                         ) premiums_earned,
                         (  NVL (a.loss_paid_amt, 0)
                          + NVL (a.curr_loss_res, 0)
                          - NVL (a.prev_loss_res, 0)
                         ) losses_incurred
                    FROM gicl_loss_ratio_ext a
                   WHERE a.session_id = p_session_id
                ORDER BY get_loss_ratio (a.session_id,
                                         a.line_cd,
                                         a.subline_cd,
                                         a.iss_cd,
                                         a.peril_cd,
                                         a.intm_no,
                                         a.assd_no
                                        ) DESC)
      LOOP
         v_rec.assured := i.assd_no || ' - ' || cf_assd_name (i.assd_no);
         v_rec.losses_paid := i.loss_paid_amt;
         v_rec.outstanding_loss_current_year := i.curr_loss_res;
         v_rec.outstanding_loss_previous_year := i.prev_loss_res;
         v_rec.premiums_written := i.curr_prem_amt;
         v_rec.premiums_reserve_current_year := i.prem_res_cy;
         v_rec.premiums_reserve_previous_year := i.prem_res_py;
         v_rec.losses_incurred := i.losses_incurred;
         v_rec.premiums_earned := i.premiums_earned;
         IF i.premiums_earned <= 0 THEN
            v_rec.loss_ratio := 0;
         ELSE
            v_rec.loss_ratio := i.losses_incurred/i.premiums_earned*100;

         END IF;
         PIPE ROW (v_rec);
      END LOOP;
   END csv_giclr204E;
  -- end GICLR204E --
  
   -- CSVprinting of GICLR204D2 John Daniel Marasigan 03.22.2016--
  
    FUNCTION csv_giclr204D2_pwcy_a(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date   varchar2,
        p_curr_end_date     varchar2,
        p_print_date        varchar2
    )
    RETURN csv_giclr204d2_tab_pwcy_a PIPELINED AS
        v_rec csv_giclr204D2_rec_pwcy_a;
    BEGIN
        FOR i IN (
            SELECT 
                a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                a.incept_date,
                a.issue_date, 
                a.expiry_date, 
                a.tsi_amt, 
                SUM(b.prem_amt) sum_prem_amt,
                d.assd_name, 
                b.intm_no || ' ' || c.intm_name intermediary
        FROM    gipi_polbasic a, 
                gicl_lratio_curr_prem_ext b, 
                giis_intermediary c, 
                giis_assured d
        WHERE   b.policy_id = a.policy_id
        AND     b.assd_no = d.assd_no (+)
        AND     b.intm_no = c.intm_no (+)
        AND     b.session_id = p_session_id
        GROUP BY  
                a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) , 
                a.incept_date, 
                a.issue_date, 
                a.expiry_date, 
                a.tsi_amt, 
                b.prem_amt, 
                d.assd_name, 
                b.intm_no || ' ' || c.intm_name
        ORDER BY policy_no
        )
        LOOP
            v_rec.intermediary := i.intermediary;
            v_rec.Policy := i.policy_no;
            v_rec.Assured := i.assd_name;
            v_rec.Incept_Date := i.incept_date;
            v_rec.Expiry_Date := i.expiry_date;
            v_rec.Issue_Date := i.issue_date;
            v_rec.TSI_Amount := i.tsi_amt;
            v_rec.Premium_Amount := i.sum_prem_amt;
            PIPE ROW(v_rec);
        END LOOP;
    END csv_giclr204D2_pwcy_a;
    
    FUNCTION csv_giclr204D2_pwcy_b(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date   varchar2,
        p_curr_end_date     varchar2,
        p_print_date        varchar2
    )
    RETURN csv_giclr204d2_tab_pwcy_b PIPELINED AS
        v_rec csv_giclr204D2_rec_pwcy_b;
    BEGIN
        FOR i IN (
            SELECT 
                a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                a.incept_date,
                a.issue_date, 
                a.expiry_date, 
                a.tsi_amt, 
                SUM(b.prem_amt) sum_prem_amt,
                d.assd_name, 
                b.intm_no || ' ' || c.intm_name intermediary
        FROM    gipi_polbasic a, 
                gicl_lratio_curr_prem_ext b, 
                giis_intermediary c, 
                giis_assured d
        WHERE   b.policy_id = a.policy_id
        AND     b.assd_no = d.assd_no (+)
        AND     b.intm_no = c.intm_no (+)
        AND     b.session_id = p_session_id
        GROUP BY  
                a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) , 
                a.incept_date, 
                a.issue_date, 
                a.expiry_date, 
                a.tsi_amt, 
                b.prem_amt, 
                d.assd_name, 
                b.intm_no || ' ' || c.intm_name
        ORDER BY policy_no
        )
        LOOP
            v_rec.intermediary := i.intermediary;
            v_rec.Policy := i.policy_no;
            v_rec.Assured := i.assd_name;
            v_rec.Incept_Date := i.incept_date;
            v_rec.Expiry_Date := i.expiry_date;
            v_rec.Acct_Ent_Date := i.issue_date;
            v_rec.TSI_Amount := i.tsi_amt;
            v_rec.Premium_Amount := i.sum_prem_amt;
            PIPE ROW(v_rec);
        END LOOP;
    END csv_giclr204D2_pwcy_b;
    
    FUNCTION csv_giclr204D2_pwcy_c(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date   varchar2,
        p_curr_end_date     varchar2,
        p_print_date        varchar2
    )
    RETURN csv_giclr204d2_tab_pwcy_c PIPELINED AS
        v_rec csv_giclr204D2_rec_pwcy_c;
    BEGIN
        FOR i IN (
            SELECT 
                a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                a.incept_date,
                a.issue_date, 
                a.expiry_date, 
                a.tsi_amt, 
                SUM(b.prem_amt) sum_prem_amt,
                d.assd_name, 
                b.intm_no || ' ' || c.intm_name intermediary
        FROM    gipi_polbasic a, 
                gicl_lratio_curr_prem_ext b, 
                giis_intermediary c, 
                giis_assured d
        WHERE   b.policy_id = a.policy_id
        AND     b.assd_no = d.assd_no (+)
        AND     b.intm_no = c.intm_no (+)
        AND     b.session_id = p_session_id
        GROUP BY  
                a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) , 
                a.incept_date, 
                a.issue_date, 
                a.expiry_date, 
                a.tsi_amt, 
                b.prem_amt, 
                d.assd_name, 
                b.intm_no || ' ' || c.intm_name
        ORDER BY policy_no
        )
        LOOP
            v_rec.intermediary := i.intermediary;
            v_rec.Policy := i.policy_no;
            v_rec.Assured := i.assd_name;
            v_rec.Incept_Date := i.incept_date;
            v_rec.Expiry_Date := i.expiry_date;
            v_rec.Booking_Date := i.issue_date;
            v_rec.TSI_Amount := i.tsi_amt;
            v_rec.Premium_Amount := i.sum_prem_amt;
            PIPE ROW(v_rec);
        END LOOP;
    END csv_giclr204D2_pwcy_c;
    
    FUNCTION csv_giclr204D2_pwpy_a(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year         varchar2,
        p_print_date        varchar2
    )
    RETURN csv_giclr204D2_tab_pwpy_a PIPELINED
    AS
        v_rec csv_giclr204d2_rec_pwpy_a;
    BEGIN
        FOR i IN (
            SELECT  b.intm_no ||' - ' ||c.intm_name intermediary,
                b.intm_no,
                b.assd_no, 
                a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                a.endt_iss_cd, 
                a.endt_yy, 
                a.endt_seq_no, 
                a.incept_date, 
                a.expiry_date, 
                a.tsi_amt, 
                SUM(b.prem_amt) sum_prem_amt, 
                c.intm_name,
                d.assd_name, 
                a.policy_id,
                'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year time_period
        FROM    gipi_polbasic a, 
                gicl_lratio_prev_prem_ext b,  
                giis_intermediary c, 
                giis_assured d
        WHERE   b.policy_id = a.policy_id
        AND     b.assd_no = d.assd_no (+)
        AND     b.intm_no = c.intm_no (+)
        AND     b.session_id = p_session_id
        GROUP BY    b.intm_no, 
                    b.assd_no, 
                    a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) ,
                    a.endt_iss_cd, 
                    a.endt_yy, 
                    a.endt_seq_no, 
                    a.incept_date, 
                    a.expiry_date, 
                    a.tsi_amt, 
                    c.intm_name,
                    d.assd_name, 
                    a.policy_id,
                    'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year
        ORDER BY policy_no
        )
        LOOP
            v_rec.intermediary := i.intermediary;
            v_rec.Policy := i.policy_no;
            v_rec.Assured := i.assd_name;
            v_rec.Incept_Date := i.incept_date;
            v_rec.Expiry_Date := i.expiry_date;
            v_rec.TSI_Amount := i.tsi_amt;
            v_rec.Premium_Amount := i.sum_prem_amt;
            v_rec.Issue_Date := CSV_LOSS_RATIO.get_datevalue(p_print_date, i.policy_id);
            PIPE ROW(v_rec);
        END LOOP;
    END csv_giclr204D2_pwpy_a;
    
    FUNCTION csv_giclr204D2_pwpy_b(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year         varchar2,
        p_print_date        varchar2
    )
    RETURN csv_giclr204D2_tab_pwpy_b PIPELINED
    AS
        v_rec csv_giclr204d2_rec_pwpy_b;
    BEGIN
        FOR i IN (
            SELECT  b.intm_no ||' - ' ||c.intm_name intermediary,
                b.intm_no,
                b.assd_no, 
                a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                a.endt_iss_cd, 
                a.endt_yy, 
                a.endt_seq_no, 
                a.incept_date, 
                a.expiry_date, 
                a.tsi_amt, 
                SUM(b.prem_amt) sum_prem_amt, 
                c.intm_name,
                d.assd_name, 
                a.policy_id,
                'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year time_period
        FROM    gipi_polbasic a, 
                gicl_lratio_prev_prem_ext b, 
                giis_intermediary c, 
                giis_assured d
        WHERE   b.policy_id = a.policy_id
        AND     b.assd_no = d.assd_no (+)
        AND     b.intm_no = c.intm_no (+)
        AND     b.session_id = p_session_id
        GROUP BY    b.intm_no, 
                    b.assd_no, 
                    a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) ,
                    a.endt_iss_cd, 
                    a.endt_yy, 
                    a.endt_seq_no, 
                    a.incept_date, 
                    a.expiry_date, 
                    a.tsi_amt, 
                    c.intm_name,
                    d.assd_name, 
                    a.policy_id,
                    'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year
        ORDER BY policy_no
        )
        LOOP
            v_rec.intermediary := i.intermediary;
            v_rec.Policy := i.policy_no;
            v_rec.Assured := i.assd_name;
            v_rec.Incept_Date := i.incept_date;
            v_rec.Expiry_Date := i.expiry_date;
            v_rec.TSI_Amount := i.tsi_amt;
            v_rec.Premium_Amount := i.sum_prem_amt;
            v_rec.Acct_Ent_Date := CSV_LOSS_RATIO.get_datevalue(p_print_date, i.policy_id);
            PIPE ROW(v_rec);
        END LOOP;
    END csv_giclr204D2_pwpy_b;
    
    FUNCTION csv_giclr204D2_pwpy_c(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year         varchar2,
        p_print_date        varchar2
    )
    RETURN csv_giclr204D2_tab_pwpy_c PIPELINED
    AS
        v_rec csv_giclr204d2_rec_pwpy_c;
    BEGIN
        FOR i IN (
            SELECT  b.intm_no ||' - ' ||c.intm_name intermediary,
                b.intm_no,
                b.assd_no, 
                a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                a.endt_iss_cd, 
                a.endt_yy, 
                a.endt_seq_no, 
                a.incept_date, 
                a.expiry_date, 
                a.tsi_amt, 
                SUM(b.prem_amt) sum_prem_amt, 
                c.intm_name,
                d.assd_name, 
                a.policy_id,
                'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year time_period
        FROM    gipi_polbasic a, 
                gicl_lratio_prev_prem_ext b, 
                giis_intermediary c, 
                giis_assured d
        WHERE   b.policy_id = a.policy_id
        AND     b.assd_no = d.assd_no (+)
        AND     b.intm_no = c.intm_no (+)
        AND     b.session_id = p_session_id
        GROUP BY    b.intm_no, 
                    b.assd_no, 
                    a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) ,
                    a.endt_iss_cd, 
                    a.endt_yy, 
                    a.endt_seq_no, 
                    a.incept_date, 
                    a.expiry_date, 
                    a.tsi_amt, 
                    c.intm_name,
                    d.assd_name, 
                    a.policy_id,
                    'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year
        ORDER BY policy_no
        )
        LOOP
            v_rec.intermediary := i.intermediary;
            v_rec.Policy := i.policy_no;
            v_rec.Assured := i.assd_name;
            v_rec.Incept_Date := i.incept_date;
            v_rec.Expiry_Date := i.expiry_date;
            v_rec.TSI_Amount := i.tsi_amt;
            v_rec.Premium_Amount := i.sum_prem_amt;
            v_rec.Booking_Date := CSV_LOSS_RATIO.get_datevalue(p_print_date, i.policy_id);
            PIPE ROW(v_rec);
        END LOOP;
    END csv_giclr204D2_pwpy_c;
    
    FUNCTION csv_giclr204d2_lp(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_year         varchar2
    )
    RETURN csv_giclr204d2_tab_lp PIPELINED
    AS
        v_rec csv_giclr204d2_rec_lp;
    BEGIN
         FOR a IN(
            SELECT      a.intm_no ||' - ' || e.intm_name intermediary,
                        a.intm_no, 
                        e.intm_name, 
                        a.assd_no, 
                        c.assd_name, 
                        b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no,
                        b.dsp_loss_date, 
                        SUM(a.loss_paid) sum_loss_paid,
                        'LOSSES PAID FOR THE YEAR' ||  p_curr_year time_period
            FROM        gicl_lratio_loss_paid_ext a, 
                        gicl_claims b, 
                        giis_assured c, 
                        giis_intermediary e
            WHERE       a.session_id = p_session_id
            AND         a.assd_no = c.assd_no
            AND         a.intm_no = e.intm_no
            AND         a.claim_id = b.claim_id
            GROUP BY    a.intm_no, 
                        e.intm_name, 
                        a.assd_no, 
                        c.assd_name, 
                        b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) ,
                        b.dsp_loss_date
            ORDER BY claim_no
         )
         LOOP   
             v_rec.Claim_No  :=  a.claim_no;
             v_rec.Loss_Amount    :=  a.sum_loss_paid;
             v_rec.Assured :=  a.assd_name;       
             v_rec.intermediary :=  a.intermediary;   
             v_rec.Loss_Date := a.dsp_loss_date;
            PIPE ROW (v_rec);
         END LOOP;
    END csv_giclr204d2_lp;
    
    FUNCTION csv_giclr204d2_olcy(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_end_date     varchar2
    )
    RETURN csv_giclr204d2_tab_ol PIPELINED
    AS
        v_rec csv_giclr204d2_rec_ol;
    BEGIN
        FOR a IN(
            SELECT  e.intm_no||' - ' ||e.intm_name intermediary,
                    e.intm_name, 
                    a.intm_no, 
                    a.assd_no, 
                    d.assd_name, 
                    a.claim_id, 
                    SUM(os_amt) os_amt, 
                    b.dsp_loss_date, 
                    b.clm_file_date, 
                    b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no,
                    'OUTSTANDING LOSS AS OF ' ||  p_curr_end_date time_period
            FROM    gicl_lratio_curr_os_ext a, 
                    gicl_claims b, 
                    giis_assured d, 
                    giis_intermediary e
            WHERE a.session_id = p_session_id
            AND   a.claim_id = b.claim_id 
            AND   a.intm_no  = e.intm_no(+)
            AND   a.assd_no = d.assd_no
            GROUP BY    a.intm_no, 
                        e.intm_name,
                        a.claim_id, 
                        a.assd_no, 
                        d.assd_name, 
                        b.dsp_loss_date, 
                        b.clm_file_date,
                        b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                        e.intm_no||' - ' ||e.intm_name  
            ORDER BY claim_no
        )
        LOOP     
            v_rec.Claim  :=  a.claim_no;
            v_rec.Loss_Amount    :=  a.os_amt;
            v_rec.Assured :=  a.assd_name;        
            v_rec.intermediary :=  a.intermediary; 
            v_rec.Loss_Date := a.dsp_loss_date;
            v_rec.File_Date := a.clm_file_date;

            PIPE ROW (v_rec);
            
        END LOOP;
    END csv_giclr204d2_olcy;
    
    FUNCTION csv_giclr204d2_olpy(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_end_date varchar2
    )
    RETURN csv_giclr204d2_tab_ol PIPELINED
    AS
        v_rec csv_giclr204d2_rec_ol;
    BEGIN
        FOR a IN(
            SELECT  e.intm_no||' - ' ||e.intm_name intermediary,
                    e.intm_name, 
                    a.intm_no, 
                    a.assd_no, 
                    d.assd_name, 
                    a.claim_id, 
                    SUM(os_amt) os_amt, 
                    b.dsp_loss_date, 
                    b.clm_file_date, 
                    b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no,
                    'OUTSTANDING LOSS AS OF' || p_prev_end_date time_period
            FROM    gicl_lratio_prev_os_ext a, 
                    gicl_claims b, 
                    giis_assured d, 
                    giis_intermediary e
            WHERE a.session_id = p_session_id
            AND   a.claim_id = b.claim_id 
            AND   a.intm_no  = e.intm_no(+)
            AND   a.assd_no = d.assd_no
            GROUP BY    a.intm_no, 
                        e.intm_name,
                        a.claim_id, 
                        a.assd_no, 
                        d.assd_name, 
                        b.dsp_loss_date, 
                        b.clm_file_date,
                        b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                        e.intm_no||' - ' ||e.intm_name
            ORDER BY claim_no
            )
        LOOP    
            v_rec.Claim  :=  a.claim_no;
            v_rec.Loss_Amount   :=  a.os_amt;
            v_rec.Assured :=  a.assd_name;
            v_rec.intermediary :=  a.intermediary;   
            v_rec.Loss_Date := a.dsp_loss_date;
            v_rec.File_Date := a.clm_file_date;

            PIPE ROW (v_rec);
        END LOOP;
    END csv_giclr204d2_olpy;

    
    FUNCTION csv_giclr204d2_lrcy(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_dt     varchar2,
        p_curr_end_dt       varchar2
    )
    RETURN csv_giclr204d2_tab_lrcy PIPELINED
    AS
        v_rec csv_giclr204d2_rec_lrcy;
    BEGIN
        FOR a IN(
            SELECT      a.intm_no ||' - '||f.intm_name intermediary,
                        a.intm_no, 
                        f.intm_name, 
                        a.assd_no, 
                        b.assd_name, 
                        d.rec_type_desc, 
                        SUM(a.recovered_amt) sum_recovered_amt, 
                        e.dsp_loss_date,       
                        c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no,
                        'LOSS RECOVERY FOR THE PERIOD ' || P_CURR_START_DT || ' TO ' ||  P_CURR_END_DT time_period
            FROM    gicl_lratio_curr_recovery_ext a, 
                    giis_assured b, 
                    gicl_clm_recovery c, 
                    giis_recovery_type d,
                    gicl_claims e, 
                    giis_intermediary f
            WHERE   a.assd_no = b.assd_no
            AND     a.intm_no = f.intm_no
            AND     a.recovery_id = c.recovery_id
            AND     c.rec_type_cd = d.rec_type_cd
            AND     c.claim_id = e.claim_id
            AND     a.session_id = p_session_id
            GROUP BY    a.intm_no, 
                        f.intm_name, 
                        a.assd_no, 
                        b.assd_name, 
                        d.rec_type_desc, 
                        e.dsp_loss_date,       
                        c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')),
                        'LOSS RECOVERY FOR THE PERIOD ' || P_CURR_START_DT || ' TO ' ||  P_CURR_END_DT 
            ORDER BY recovery_no
            )
        LOOP
            v_rec.intermediary :=  a.intermediary;         
            v_rec.Assured   :=  a.assd_name;     
            v_rec.Recovery_Type := a.rec_type_desc;
            v_rec.Recovered_Amount    :=  a.sum_recovered_amt;
            v_rec.Loss_Date := a.dsp_loss_date;
            v_rec.Recovery_No := a.recovery_no;
            PIPE ROW (v_rec);
            
        END LOOP;
    END csv_giclr204d2_lrcy;
    
    FUNCTION csv_giclr204d2_lrpy(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year         number
    )
    RETURN csv_giclr204d2_tab_lrpy PIPELINED
    AS
        v_rec csv_giclr204d2_rec_lrpy;
    BEGIN
        FOR a IN(
                SELECT  a.intm_no ||' - ' ||f.intm_name intermediary,    
                        a.intm_no, 
                        f.intm_name, 
                        a.assd_no, 
                        b.assd_name, 
                        d.rec_type_desc, 
                        SUM(a.recovered_amt) sum_recovered_amt, 
                        e.dsp_loss_date,       
                        c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no,
                        'LOSS RECOVERY FOR THE YEAR ' || p_prev_year time_period
                FROM    gicl_lratio_prev_recovery_ext a, 
                        giis_assured b, 
                        gicl_clm_recovery c, 
                        giis_recovery_type d,
                        gicl_claims e, 
                        giis_intermediary f
                WHERE   a.assd_no = b.assd_no
                AND     a.intm_no = f.intm_no
                AND     a.recovery_id = c.recovery_id
                AND     c.rec_type_cd = d.rec_type_cd
                AND     c.claim_id = e.claim_id
                AND     a.session_id = p_session_id
                GROUP BY    a.intm_no, 
                            f.intm_name, 
                            a.assd_no, 
                            b.assd_name, 
                            d.rec_type_desc, 
                            e.dsp_loss_date,       
                            c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')),
                            a.intm_no ||' - ' ||f.intm_name,
                            'LOSS RECOVERY FOR THE YEAR ' || p_prev_year
                ORDER BY recovery_no
            )
        LOOP
            v_rec.intermediary :=  a.intermediary;       
            v_rec.Assured   :=  a.assd_name;     
            v_rec.Recovery_Type := a.rec_type_desc;
            v_rec.Recovered_Amount    :=  a.sum_recovered_amt;
            v_rec.Loss_Date := a.dsp_loss_date;
            v_rec.Recovery_No := a.recovery_no;
            PIPE ROW (v_rec);
            
        END LOOP;
    END csv_giclr204d2_lrpy;
    
    FUNCTION get_datevalue(
        p_prnt_date         varchar2,
        p_policy_id         GIPI_POLBASIC.POLICY_ID%TYPE
    )
    RETURN varchar2
    AS
        v_date varchar2(40);
    BEGIN 
        IF p_prnt_date = '1' THEN
           SELECT to_char(issue_date,'MM-DD-RRRR') into v_date
           FROM gipi_polbasic
           WHERE policy_id = p_policy_id;
           return(v_date);
        ELSIF p_prnt_date = '3' THEN
           SELECT TO_CHAR(acct_ent_date,'MM-DD-RRRR') into v_date
           FROM gipi_polbasic
           WHERE policy_id = p_policy_id;
           return(v_date);
        ELSIF p_prnt_date = '4' THEN
           SELECT booking_mth||' '||TO_CHAR(booking_year) into v_date
           FROM gipi_polbasic
           WHERE policy_id = p_policy_id;
           return(v_date);                    
        ELSE
           return (null);
        END IF;  
    END;
   -- END GICLR204D2
  
  -- Start: Added by Mary Cris Invento 04.04.2016 SR 5392
  FUNCTION CSV_GICLR204E2_PW_CY_ISSUE(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204e2_pwcy_issue_tab PIPELINED AS
      cp                    giclr204e2_pwcy_issue_type;
   BEGIN
      FOR i IN (SELECT b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_curr_prem_ext b, giis_assured c
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = c.assd_no(+)
                   AND b.session_id = p_session_id
                 GROUP BY b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                          a.incept_date, a.expiry_date, a.tsi_amt, c.assd_name, a.policy_id
                 ORDER BY 1, 2)
      LOOP
         cp.assured := i.assd_no||' - '||i.assd_name;
         cp.policy := i.policy_no;
         cp.incept_date := TO_CHAR(i.incept_date, 'MM-DD-RRRR');
         cp.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-RRRR');
         cp.issue_date := CSV_LOSS_RATIO.CSV_GICLR204E2_get_cf_date(p_prnt_date, i.policy_id);
         cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));           
         cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));
         
         PIPE ROW(cp);
      END LOOP;
   END CSV_GICLR204E2_PW_CY_ISSUE;
   
   FUNCTION CSV_GICLR204E2_PW_CY_ACCTG(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204e2_pwcy_acctg_tab PIPELINED AS
      cp                    giclr204e2_pwcy_acctg_type;
   BEGIN
      FOR i IN (SELECT b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_curr_prem_ext b, giis_assured c
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = c.assd_no(+)
                   AND b.session_id = p_session_id
                 GROUP BY b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                          a.incept_date, a.expiry_date, a.tsi_amt, c.assd_name, a.policy_id
                 ORDER BY 1, 2)
      LOOP
         cp.assured := i.assd_no||' - '||i.assd_name;
         cp.policy := i.policy_no;
         cp.incept_date := TO_CHAR(i.incept_date, 'MM-DD-RRRR');
         cp.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-RRRR');
         cp.acct_ent_date := CSV_LOSS_RATIO.CSV_GICLR204E2_get_cf_date(p_prnt_date, i.policy_id);
         cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));           
         cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));
         
         PIPE ROW(cp);
      END LOOP;
   END CSV_GICLR204E2_PW_CY_ACCTG;
   
   FUNCTION CSV_GICLR204E2_PW_CY_BKING(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204e2_pwcy_bking_tab PIPELINED AS
      cp                    giclr204e2_pwcy_bking_type;
   BEGIN
      FOR i IN (SELECT b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_curr_prem_ext b, giis_assured c
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = c.assd_no(+)
                   AND b.session_id = p_session_id
                 GROUP BY b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                          a.incept_date, a.expiry_date, a.tsi_amt, c.assd_name, a.policy_id
                 ORDER BY 1, 2)
      LOOP
         cp.assured := i.assd_no||' - '||i.assd_name;
         cp.policy := i.policy_no;
         cp.incept_date := TO_CHAR(i.incept_date, 'MM-DD-RRRR');
         cp.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-RRRR');
         cp.booking_date := CSV_LOSS_RATIO.CSV_GICLR204E2_get_cf_date(p_prnt_date, i.policy_id);
         cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));           
         cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));
         
         PIPE ROW(cp);
      END LOOP;
   END CSV_GICLR204E2_PW_CY_BKING;
   
   FUNCTION CSV_GICLR204E2_PW_PY_ISSUE(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204e2_pwpy_issue_tab PIPELINED AS
      pp                    giclr204e2_pwpy_issue_type;
   BEGIN
      FOR i IN (SELECT b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_prev_prem_ext b, giis_assured c
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = c.assd_no(+)
                   AND b.session_id = p_session_id
                 GROUP BY b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                          a.incept_date, a.expiry_date, a.tsi_amt, c.assd_name, a.policy_id
                 ORDER BY 1, 2)
      LOOP
         pp.assured := i.assd_no||' - '||i.assd_name;
         pp.policy := i.policy_no;                
         pp.incept_date := TO_CHAR(i.incept_date, 'MM-DD-RRRR');
         pp.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-RRRR');      
         pp.issue_date := CSV_LOSS_RATIO.CSV_GICLR204E2_get_cf_date(p_prnt_date, i.policy_id);    
         pp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));           
         pp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));
         
         PIPE ROW(pp);
      END LOOP;
   END CSV_GICLR204E2_PW_PY_ISSUE;
   
   FUNCTION CSV_GICLR204E2_PW_PY_ACCTG(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204e2_pwpy_acctg_tab PIPELINED AS
      pp                    giclr204e2_pwpy_acctg_type;
   BEGIN
      FOR i IN (SELECT b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_prev_prem_ext b, giis_assured c
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = c.assd_no(+)
                   AND b.session_id = p_session_id
                 GROUP BY b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                          a.incept_date, a.expiry_date, a.tsi_amt, c.assd_name, a.policy_id
                 ORDER BY 1, 2)
      LOOP
         pp.assured := i.assd_no||' - '||i.assd_name;
         pp.policy := i.policy_no;                
         pp.incept_date := TO_CHAR(i.incept_date, 'MM-DD-RRRR');
         pp.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-RRRR');      
         pp.acct_ent_date := CSV_LOSS_RATIO.CSV_GICLR204E2_get_cf_date(p_prnt_date, i.policy_id);    
         pp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));           
         pp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));
         
         PIPE ROW(pp);
      END LOOP;
   END CSV_GICLR204E2_PW_PY_ACCTG;
   
   FUNCTION CSV_GICLR204E2_PW_PY_BKING(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204e2_pwpy_bking_tab PIPELINED AS
      pp                    giclr204e2_pwpy_bking_type;
   BEGIN
      FOR i IN (SELECT b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                       a.incept_date, a.expiry_date, a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, a.policy_id
                  FROM gipi_polbasic a, gicl_lratio_prev_prem_ext b, giis_assured c
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = c.assd_no(+)
                   AND b.session_id = p_session_id
                 GROUP BY b.assd_no, get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, 
                          a.incept_date, a.expiry_date, a.tsi_amt, c.assd_name, a.policy_id
                 ORDER BY 1, 2)
      LOOP
         pp.assured := i.assd_no||' - '||i.assd_name;
         pp.policy := i.policy_no;                
         pp.incept_date := TO_CHAR(i.incept_date, 'MM-DD-RRRR');
         pp.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-RRRR');      
         pp.booking_date := CSV_LOSS_RATIO.CSV_GICLR204E2_get_cf_date(p_prnt_date, i.policy_id);    
         pp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));           
         pp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));
         
         PIPE ROW(pp);
      END LOOP;
   END CSV_GICLR204E2_PW_PY_BKING;
   
   FUNCTION CSV_GICLR204E2_OS_CY(
      p_session_id          gicl_lratio_curr_os_ext.session_id%TYPE
   ) RETURN os_details_tab2 PIPELINED AS
      co                    os_details_type2;
   BEGIN
      FOR i IN (SELECT a.assd_no, d.assd_name, a.claim_id, SUM(os_amt) sum_os_amt, b.dsp_loss_date, b.clm_file_date, 
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) claim_no
                  FROM gicl_lratio_curr_os_ext a, gicl_claims b, giis_assured d
                 WHERE a.session_id = p_session_id
                   AND a.claim_id = b.claim_id 
                   AND a.assd_no = d.assd_no
                 GROUP BY a.assd_no, d.assd_name, a.claim_id, b.dsp_loss_date, b.clm_file_date,
                          b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) 
                 ORDER BY 1, 6)
      LOOP
         co.assured := i.assd_no||' - '||i.assd_name;
         co.claim_no := i.claim_no;
         co.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-DD-RRRR');
         co.file_date := TO_CHAR(i.clm_file_date, 'MM-DD-RRRR');
         co.loss_amount := TRIM(TO_CHAR(i.sum_os_amt, '999,999,999,990.00'));
         
         PIPE ROW(co);
      END LOOP;
   END CSV_GICLR204E2_OS_CY;
   
   FUNCTION CSV_GICLR204E2_OS_PY(
      p_session_id          gicl_lratio_prev_os_ext.session_id%TYPE
   ) RETURN os_details_tab2 PIPELINED AS
      po                    os_details_type2;
   BEGIN
      FOR i IN (SELECT a.assd_no, d.assd_name, a.claim_id, SUM(os_amt) sum_os_amt, b.dsp_loss_date, b.clm_file_date, 
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no
                  FROM gicl_lratio_prev_os_ext a, gicl_claims b, giis_assured d
                 WHERE a.session_id = p_session_id
                   AND a.claim_id = b.claim_id 
                   AND a.assd_no = d.assd_no
                 GROUP BY a.assd_no, d.assd_name, a.claim_id, b.dsp_loss_date, b.clm_file_date,
                          b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) 
                 ORDER BY 1, 6)
      LOOP
         po.assured := i.assd_no||' - '||i.assd_name;
         po.claim_no := i.claim_no;
         po.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-DD-RRRR');
         po.file_date := TO_CHAR(i.clm_file_date, 'MM-DD-RRRR');
         po.loss_amount := TRIM(TO_CHAR(i.sum_os_amt, '999,999,999,990.00'));
         
         PIPE ROW(po);
      END LOOP;
   END CSV_GICLR204E2_OS_PY;
   
   FUNCTION CSV_GICLR204E2_LP(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN loss_paid_details_tab2 PIPELINED AS
      lp                    loss_paid_details_type2;
   BEGIN
      FOR i IN (SELECT a.assd_no, c.assd_name, b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no,
                       b.dsp_loss_date, SUM(a.loss_paid) sum_loss_paid
                  FROM gicl_lratio_loss_paid_ext a, gicl_claims b, giis_assured c
                 WHERE a.session_id = p_session_id
                   AND a.assd_no = c.assd_no
                   AND a.claim_id = b.claim_id
                 GROUP BY a.assd_no, c.assd_name, b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                          b.dsp_loss_date
                 ORDER BY 1, 3)
      LOOP
         lp.assured := i.assd_no||' - '||i.assd_name;
         lp.claim_no := i.claim_no;
         lp.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-DD-RRRR');
         lp.loss_amount := TRIM(TO_CHAR(i.sum_loss_paid, '999,999,999,990.00'));
         
         PIPE ROW(lp);
      END LOOP;
   END CSV_GICLR204E2_LP;                
   
   FUNCTION CSV_GICLR204E2_LR_CY(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN rec_details_tab2 PIPELINED AS
      cr                    rec_details_type2;
   BEGIN
      FOR i IN (SELECT a.assd_no, b.assd_name, d.rec_type_desc, SUM(a.recovered_amt) sum_recovered_amt, e.dsp_loss_date,       
                       c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no
                  FROM gicl_lratio_curr_recovery_ext a, giis_assured b, gicl_clm_recovery c, giis_recovery_type d, gicl_claims e
                 WHERE a.assd_no = b.assd_no
                   AND a.recovery_id = c.recovery_id
                   AND c.rec_type_cd = d.rec_type_cd
                   AND c.claim_id = e.claim_id
                   AND a.session_id = p_session_id
                 GROUP BY a.assd_no, b.assd_name, d.rec_type_desc, e.dsp_loss_date, 
                          c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009'))
                 ORDER BY 1, 5)
      LOOP
         cr.assured := i.assd_no||' - '||i.assd_name;
         cr.recovery_no := i.recovery_no;
         cr.recovery_type := i.rec_type_desc;
         cr.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-DD-RRRR');
         cr.recovered_amount := TRIM(TO_CHAR(i.sum_recovered_amt, '999,999,999,990.00'));
         
         PIPE ROW(cr);
      END LOOP;
   END CSV_GICLR204E2_LR_CY;
   
   FUNCTION CSV_GICLR204E2_LR_PY(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN rec_details_tab2 PIPELINED AS
      pr                    rec_details_type2;
   BEGIN
      FOR i IN (SELECT a.assd_no, b.assd_name, d.rec_type_desc, SUM(a.recovered_amt) sum_recovered_amt, e.dsp_loss_date, 
                       c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no
                  FROM gicl_lratio_prev_recovery_ext a, giis_assured b, gicl_clm_recovery c, giis_recovery_type d, gicl_claims e
                 WHERE a.assd_no = b.assd_no
                   AND a.recovery_id = c.recovery_id
                   AND c.rec_type_cd = d.rec_type_cd
                   AND c.claim_id = e.claim_id
                   AND a.session_id = p_session_id
                 GROUP BY a.assd_no, b.assd_name, d.rec_type_desc, e.dsp_loss_date, 
                          c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009'))
                 ORDER BY 1, 5)
      LOOP
         pr.assured := i.assd_no||' - '||i.assd_name;
         pr.recovery_no := i.recovery_no;
         pr.recovery_type := i.rec_type_desc;
         pr.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-DD-RRRR');
         pr.recovered_amount := TRIM(TO_CHAR(i.sum_recovered_amt, '999,999,999,990.00'));

         PIPE ROW(pr);
      END LOOP;
   END CSV_GICLR204E2_LR_PY;
   
   FUNCTION CSV_GICLR204E2_get_cf_date(
        p_prnt_date         VARCHAR2,
        p_policy_id         gipi_polbasic.policy_id%TYPE
    )
    RETURN VARCHAR2
    AS
        cf_date     VARCHAR2(20);
    BEGIN 
        IF p_prnt_date = '1' THEN
           SELECT TO_CHAR(issue_date,'MM-DD-RRRR') INTO cf_date
           FROM gipi_polbasic
           WHERE policy_id = p_policy_id;
           return(cf_date);
        ELSIF p_prnt_date = '3' THEN
           SELECT TO_CHAR(acct_ent_date,'MM-DD-RRRR') INTO cf_date
           FROM gipi_polbasic
           WHERE policy_id = p_policy_id;
           return(cf_date);
        ELSIF p_prnt_date = '4' THEN
           SELECT booking_mth||' '||TO_CHAR(booking_year) INTO cf_date
           FROM gipi_polbasic
           WHERE policy_id = p_policy_id;
           RETURN cf_date;
        ELSE
           RETURN NULL;
        END IF;
    END CSV_GICLR204E2_get_cf_date;
  -- End: Added by Mary Cris Invento 04.04.2016 SR 5392
  
    -- GICLR204E3 CSVprinting added by carlo rubenecia 05.31.2016 SR 5393 -START
    FUNCTION populate_prem_writn_priod1(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date   varchar2,
        p_curr_end_date     varchar2,
        p_print_date        varchar2
    )
    RETURN prem_writn_priod_tab1 PIPELINED as 
           cp prem_writn_priod_type1;
    BEGIN
        FOR i IN(
            SELECT  b.assd_no,
                    a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no, 
                    a.endt_iss_cd, 
                    a.policy_id,
                    a.endt_yy, 
                    a.endt_seq_no, 
                    a.incept_date, 
                    a.issue_date, 
                    a.expiry_date, 
                    a.tsi_amt, 
                    SUM(b.prem_amt) sum_prem_amt, 
                    c.assd_name, 
                    TO_CHAR(date_for_24th,'MONTH YYYY') transaction_month,
                    'PREMIUMS WRITTEN FOR '|| p_curr_start_date || ' TO ' ||  p_curr_end_date time_period
                FROM    gipi_polbasic a, 
                        gicl_lratio_curr_prem_ext b, 
                        giis_assured c
                WHERE   b.policy_id = a.policy_id
                AND     b.assd_no = c.assd_no (+)
                AND     b.session_id = p_session_id
                GROUP BY    b.assd_no, 
                            'PREMIUMS WRITTEN FOR '|| p_curr_start_date || ' TO ' ||  p_curr_end_date, 
                            a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')), 
                            a.endt_iss_cd, 
                            a.policy_id,
                            a.endt_yy, 
                            a.endt_seq_no, 
                            a.incept_date, 
                            a.issue_date,
                            a.expiry_date, 
                            a.tsi_amt, 
                            c.assd_name, 
                            TO_CHAR(date_for_24th,'MONTH YYYY')
                ORDER BY    TO_CHAR(date_for_24th,'MONTH YYYY') DESC, 
                            policy_no
            )
            LOOP
                 cp.assured := concat(i.assd_no, ' - '||i.assd_name);            
                 cp.transaction_date  := i.transaction_month;
                 cp.policy := i.policy_no;
                 cp.incept_date := TO_CHAR(i.incept_date, 'MM-DD-RRRR');
                 cp.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-RRRR');            
                 cp.issue_date := CSV_LOSS_RATIO.GICLR204E3_get_datevalue('1',i.policy_id);     
                 cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,999,990.00'));     
                 cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,999,990.00'));              
                PIPE ROW (cp);
            END LOOP;
    END populate_prem_writn_priod1;
 
    FUNCTION populate_prem_writn_priod2(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date   varchar2,
        p_curr_end_date     varchar2,
        p_print_date        varchar2
    )
    RETURN prem_writn_priod_tab2 PIPELINED as 
        cp prem_writn_priod_type2;
    BEGIN
        FOR i IN(
            SELECT  b.assd_no,
                    a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no, 
                    a.endt_iss_cd, 
                    a.policy_id,
                    a.endt_yy, 
                    a.endt_seq_no, 
                    a.incept_date, 
                    a.issue_date, 
                    a.expiry_date, 
                    a.tsi_amt, 
                    SUM(b.prem_amt) sum_prem_amt, 
                    c.assd_name, 
                    TO_CHAR(date_for_24th,'MONTH YYYY') transaction_month,
                    'PREMIUMS WRITTEN FOR '|| p_curr_start_date || ' TO ' ||  p_curr_end_date time_period
                FROM    gipi_polbasic a, 
                        gicl_lratio_curr_prem_ext b, 
                        giis_assured c
                WHERE   b.policy_id = a.policy_id
                AND     b.assd_no = c.assd_no (+)
                AND     b.session_id = p_session_id
                GROUP BY    b.assd_no, 
                            'PREMIUMS WRITTEN FOR '|| p_curr_start_date || ' TO ' ||  p_curr_end_date, 
                            a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')), 
                            a.endt_iss_cd, 
                            a.policy_id,
                            a.endt_yy, 
                            a.endt_seq_no, 
                            a.incept_date, 
                            a.issue_date,
                            a.expiry_date, 
                            a.tsi_amt, 
                            c.assd_name, 
                            TO_CHAR(date_for_24th,'MONTH YYYY')
                ORDER BY    TO_CHAR(date_for_24th,'MONTH YYYY') DESC, 
                            policy_no            
            )
            LOOP
                 cp.assured := concat(i.assd_no, ' - '||i.assd_name);            
                 cp.transaction_date  := i.transaction_month;
                 cp.policy := i.policy_no;
                 cp.incept_date := TO_CHAR(i.incept_date, 'MM-DD-RRRR');
                 cp.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-RRRR');              
                 cp.acct_end_date := CSV_LOSS_RATIO.GICLR204E3_get_datevalue('3',i.policy_id);     
                 cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,999,990.00'));     
                 cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,999,990.00'));              
                PIPE ROW (cp);
            END LOOP;
    END populate_prem_writn_priod2;



    FUNCTION populate_prem_writn_priod3(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date   varchar2,
        p_curr_end_date     varchar2,
        p_print_date        varchar2
    )
    RETURN prem_writn_priod_tab3 PIPELINED as 
        cp prem_writn_priod_type3;
    BEGIN
        FOR i IN(
            SELECT  b.assd_no,
                    a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no, 
                    a.endt_iss_cd, 
                    a.policy_id,
                    a.endt_yy, 
                    a.endt_seq_no, 
                    a.incept_date, 
                    a.issue_date, 
                    a.expiry_date, 
                    a.tsi_amt, 
                    SUM(b.prem_amt) sum_prem_amt, 
                    c.assd_name, 
                    TO_CHAR(date_for_24th,'MONTH YYYY') transaction_month,
                    'PREMIUMS WRITTEN FOR '|| p_curr_start_date || ' TO ' ||  p_curr_end_date time_period
                FROM    gipi_polbasic a, 
                        gicl_lratio_curr_prem_ext b, 
                        giis_assured c
                WHERE   b.policy_id = a.policy_id
                AND     b.assd_no = c.assd_no (+)
                AND     b.session_id = p_session_id
                GROUP BY    b.assd_no, 
                            'PREMIUMS WRITTEN FOR '|| p_curr_start_date || ' TO ' ||  p_curr_end_date, 
                            a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')), 
                            a.endt_iss_cd, 
                            a.policy_id,
                            a.endt_yy, 
                            a.endt_seq_no, 
                            a.incept_date, 
                            a.issue_date,
                            a.expiry_date, 
                            a.tsi_amt, 
                            c.assd_name, 
                            TO_CHAR(date_for_24th,'MONTH YYYY')
                ORDER BY    TO_CHAR(date_for_24th,'MONTH YYYY') DESC, 
                            policy_no
            )
            LOOP
                 cp.assured := concat(i.assd_no, ' - '||i.assd_name);            
                 cp.transaction_date  := i.transaction_month;
                 cp.policy := i.policy_no;
                 cp.incept_date := TO_CHAR(i.incept_date, 'MM-DD-RRRR');
                 cp.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-RRRR');           
                 cp.booking_date := CSV_LOSS_RATIO.GICLR204E3_get_datevalue('4',i.policy_id);    
                 cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,999,990.00'));     
                 cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,999,990.00'));              
                PIPE ROW (cp);
            END LOOP;
    END populate_prem_writn_priod3;


    FUNCTION populate_prem_writn_year1(
        p_session_id  gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year   varchar2,
        p_print_date  varchar2
    )
    RETURN prem_writn_year_tab1 PIPELINED as 
        cp prem_writn_year_type1;
    BEGIN
        FOR i IN(
            SELECT      b.assd_no, 
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no, 
                        a.endt_iss_cd, 
                        a.endt_yy, 
                        a.endt_seq_no, 
                        a.incept_date, 
                        a.expiry_date, 
                        a.tsi_amt, 
                        SUM(b.prem_amt) sum_prem_amt,
                        c.assd_name, 
                        a.policy_id,
                        TO_CHAR(date_for_24th,'MONTH YYYY') transaction_month,
                        'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year time_period
            FROM        gipi_polbasic a, 
                        gicl_lratio_prev_prem_ext b,
                        giis_assured c
            WHERE       b.policy_id = a.policy_id
            AND         b.assd_no = c.assd_no (+)
            AND         b.session_id = p_session_id
            GROUP BY    b.assd_no, a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')), 
                        a.endt_iss_cd, 
                        a.endt_yy, 
                        a.endt_seq_no, 
                        a.incept_date, 
                        a.issue_date,
                        a.expiry_date, 
                        a.tsi_amt, 
                        c.assd_name, 
                        a.policy_id,
                        TO_CHAR(date_for_24th,'MONTH YYYY'),
                        'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year 
            ORDER BY    TO_CHAR(date_for_24th,'MONTH YYYY') DESC, policy_no
            )
            LOOP
                 cp.assured := concat(i.assd_no, ' - '||i.assd_name);             
                 cp.transaction_date  := i.transaction_month;
                 cp.policy := i.policy_no;
                 cp.incept_date := TO_CHAR(i.incept_date, 'MM-DD-RRRR');
                 cp.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-RRRR');                 
                 cp.issue_date := CSV_LOSS_RATIO.GICLR204E3_get_datevalue('1',i.policy_id);     
                 cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,999,990.00'));     
                 cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,999,990.00'));               
                PIPE ROW (cp);
            END LOOP;
    END populate_prem_writn_year1;


    FUNCTION populate_prem_writn_year2(
        p_session_id  gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year   varchar2,
        p_print_date  varchar2
    )
    RETURN prem_writn_year_tab2 PIPELINED as 
        cp prem_writn_year_type2;
    BEGIN
        FOR i IN(
            SELECT      b.assd_no, 
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no, 
                        a.endt_iss_cd, 
                        a.endt_yy, 
                        a.endt_seq_no, 
                        a.incept_date, 
                        a.expiry_date, 
                        a.tsi_amt, 
                        SUM(b.prem_amt) sum_prem_amt,
                        c.assd_name, 
                        a.policy_id,
                        TO_CHAR(date_for_24th,'MONTH YYYY') transaction_month,
                        'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year time_period
            FROM        gipi_polbasic a, 
                        gicl_lratio_prev_prem_ext b,
                        giis_assured c
            WHERE       b.policy_id = a.policy_id
            AND         b.assd_no = c.assd_no (+)
            AND         b.session_id = p_session_id
            GROUP BY    b.assd_no, a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')), 
                        a.endt_iss_cd, 
                        a.endt_yy, 
                        a.endt_seq_no, 
                        a.incept_date, 
                        a.issue_date,
                        a.expiry_date, 
                        a.tsi_amt, 
                        c.assd_name, 
                        a.policy_id,
                        TO_CHAR(date_for_24th,'MONTH YYYY'),
                        'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year 
            ORDER BY    TO_CHAR(date_for_24th,'MONTH YYYY') DESC, policy_no
            )
            LOOP
                 cp.assured := concat(i.assd_no, ' - '||i.assd_name);             
                 cp.transaction_date  := i.transaction_month;
                 cp.policy := i.policy_no;
                 cp.incept_date := TO_CHAR(i.incept_date, 'MM-DD-RRRR');
                 cp.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-RRRR');               
                 cp.acct_end_date := CSV_LOSS_RATIO.GICLR204E3_get_datevalue('3',i.policy_id);     
                 cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,999,990.00'));     
                 cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,999,990.00'));              
                PIPE ROW (cp);
            END LOOP;
    END populate_prem_writn_year2;


    FUNCTION populate_prem_writn_year3(
        p_session_id  gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year   varchar2,
        p_print_date  varchar2
    )
    RETURN prem_writn_year_tab3 PIPELINED as 
        cp prem_writn_year_type3;
    BEGIN
        FOR i IN(
            SELECT      b.assd_no, 
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no, 
                        a.endt_iss_cd, 
                        a.endt_yy, 
                        a.endt_seq_no, 
                        a.incept_date, 
                        a.expiry_date, 
                        a.tsi_amt, 
                        SUM(b.prem_amt) sum_prem_amt,
                        c.assd_name, 
                        a.policy_id,
                        TO_CHAR(date_for_24th,'MONTH YYYY') transaction_month,
                        'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year time_period
            FROM        gipi_polbasic a, 
                        gicl_lratio_prev_prem_ext b,
                        giis_assured c
            WHERE       b.policy_id = a.policy_id
            AND         b.assd_no = c.assd_no (+)
            AND         b.session_id = p_session_id
            GROUP BY    b.assd_no, a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')), 
                        a.endt_iss_cd, 
                        a.endt_yy, 
                        a.endt_seq_no, 
                        a.incept_date, 
                        a.issue_date,
                        a.expiry_date, 
                        a.tsi_amt, 
                        c.assd_name, 
                        a.policy_id,
                        TO_CHAR(date_for_24th,'MONTH YYYY'),
                        'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year 
            ORDER BY    TO_CHAR(date_for_24th,'MONTH YYYY') DESC, policy_no
            )
            LOOP
                 cp.assured := concat(i.assd_no, ' - '||i.assd_name);             
                 cp.transaction_date  := i.transaction_month;
                 cp.policy := i.policy_no;
                 cp.incept_date := TO_CHAR(i.incept_date, 'MM-DD-RRRR');
                 cp.expiry_date := TO_CHAR(i.expiry_date, 'MM-DD-RRRR');               
                 cp.booking_date := CSV_LOSS_RATIO.GICLR204E3_get_datevalue('4',i.policy_id);     
                 cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,999,990.00'));     
                 cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,999,990.00'));              
                PIPE ROW (cp);
            END LOOP;
    END populate_prem_writn_year3;


    FUNCTION populate_losses_pd_curr_year(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_year      varchar
    )
    RETURN losses_pd_curr_year_tab PIPELINED as 
        v_rec losses_pd_curr_year_type;
    BEGIN
        FOR a IN(
                SELECT  a.assd_no, 
                        c.assd_name, 
                        b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no,
                        b.dsp_loss_date, 
                        SUM(a.loss_paid) sum_loss_paid,
                        'LOSSES PAID FOR THE YEAR ' ||  p_curr_year time_period  
                FROM    gicl_lratio_loss_paid_ext a, 
                        gicl_claims b, 
                        giis_assured c
                WHERE   a.session_id = p_session_id
                AND     a.assd_no = c.assd_no
                AND     a.claim_id = b.claim_id
                GROUP BY    a.assd_no, 
                            c.assd_name, 
                            b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                            b.dsp_loss_date,
                            'LOSSES PAID FOR THE YEAR ' ||  p_curr_year  
                ORDER BY claim_no
            )
            LOOP
                v_rec.assured   := concat(a.assd_no, ' - '||a.assd_name);     
                v_rec.claim_no  := a.claim_no;           
                v_rec.loss_date := TO_CHAR(a.dsp_loss_date, 'dd-MM-yyyy');
                v_rec.loss_amount := TRIM(TO_CHAR(a.sum_loss_paid, '999,999,999,999,990.00'));         
                PIPE ROW (v_rec);
            END LOOP;
    END populate_losses_pd_curr_year;

    FUNCTION populate_outstndng_loss_as_of(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_end_date varchar2
    )
    RETURN outstndng_loss_as_of_tab PIPELINED as 
            v_rec outstndng_loss_as_of_type;
    BEGIN
        FOR a IN(
                SELECT  a.assd_no, 
                        d.assd_name,
                        a.assd_no ||'-'||        d.assd_name assured, 
                        a.claim_id, 
                        SUM(os_amt) sum_os_amt, 
                        b.dsp_loss_date, 
                        b.clm_file_date, 
                        b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no,
                        'OUTSTANDING LOSS AS OF ' ||  p_curr_end_date  time_period
                FROM    gicl_lratio_curr_os_ext a, 
                        gicl_claims b, 
                        giis_assured d
                WHERE   a.session_id = p_session_id
                AND     a.claim_id = b.claim_id 
                AND     a.assd_no = d.assd_no
                GROUP BY    a.assd_no, 
                            d.assd_name, 
                            a.claim_id, 
                            b.dsp_loss_date, 
                            b.clm_file_date,
                            b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                            'OUTSTANDING LOSS AS OF ' ||  p_curr_end_date 
                ORDER BY claim_no
                )
            LOOP
                v_rec.assured   :=  concat(a.assd_no, ' - '||a.assd_name);   
                v_rec.claim  :=  a.claim_no;          
                v_rec.loss_date := TO_CHAR(a.dsp_loss_date, 'dd-MM-yyyy');          
                v_rec.file_date := TO_CHAR(a.clm_file_date, 'dd-MM-yyyy');         
                v_rec.loss_amount    :=  TRIM(TO_CHAR(a.sum_os_amt, '999,999,999,999,990.00'));
                PIPE ROW (v_rec);
            END LOOP;
    END populate_outstndng_loss_as_of;

    FUNCTION populate_outstndng_loss_prev(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_end_date varchar2
    )
    RETURN outstndng_loss_as_of_tab PIPELINED as 
        v_rec outstndng_loss_as_of_type;
    BEGIN
        FOR a IN(
                    SELECT  a.assd_no ||' - '||d.assd_name assured,
                            a.assd_no, 
                            d.assd_name, 
                            a.claim_id, SUM(os_amt) sum_os_amt, 
                            b.dsp_loss_date, 
                            b.clm_file_date, 
                            b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no,
                            a.session_id,
                            'OUTSTANDING LOSS AS OF' ||p_prev_end_date  time_period
                    FROM    gicl_lratio_prev_os_ext a, gicl_claims b, giis_assured d
                    WHERE   a.claim_id = b.claim_id 
                    AND     a.assd_no = d.assd_no
                    AND     a.session_id = p_session_id
                    GROUP BY    a.assd_no,
                                a.session_id, 
                                d.assd_name, 
                                a.claim_id, 
                                b.dsp_loss_date, 
                                b.clm_file_date,b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                                'OUTSTANDING LOSS AS OF' ||p_prev_end_date     
                    ORDER BY claim_no
                 )
            LOOP
                v_rec.assured   :=  concat(a.assd_no, ' - '||a.assd_name);   
                v_rec.claim  :=  a.claim_no;          
                v_rec.loss_date := TO_CHAR(a.dsp_loss_date, 'dd-MM-yyyy');           
                v_rec.file_date := TO_CHAR(a.clm_file_date, 'dd-MM-yyyy');           
                v_rec.loss_amount    := TRIM(TO_CHAR(a.sum_os_amt, '999,999,999,999,990.00'));
                PIPE ROW (v_rec);      
            END LOOP;
    END populate_outstndng_loss_prev;

    FUNCTION populate_loss_recovery_period(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date varchar2,
        p_curr_end_date varchar2
    )
    RETURN loss_recovery_period_tab PIPELINED as 
        v_rec loss_recovery_period_type;
    BEGIN
        FOR a IN(
                SELECT      a.assd_no, 
                            b.assd_name, 
                            d.rec_type_desc, 
                            SUM(a.recovered_amt) sum_recovered_amt, 
                            e.dsp_loss_date,       
                            c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no,
                            'LOSS RECOVERY FOR THE PERIOD ' || P_CURR_START_DATE || ' TO ' ||  P_CURR_END_DATE time_period
                FROM        gicl_lratio_curr_recovery_ext a, 
                            giis_assured b, 
                            gicl_clm_recovery c, 
                            giis_recovery_type d,
                            gicl_claims e
                WHERE       a.assd_no = b.assd_no
                AND         a.recovery_id = c.recovery_id
                AND         c.rec_type_cd = d.rec_type_cd
                AND         c.claim_id = e.claim_id
                AND         a.session_id = p_session_id
                GROUP BY    a.assd_no, 
                            b.assd_name, 
                            d.rec_type_desc, 
                            e.dsp_loss_date,       
                            c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')),
                            'LOSS RECOVERY FOR THE PERIOD ' || P_CURR_START_DATE || ' TO ' ||  P_CURR_END_DATE
                ORDER BY    recovery_no
                )
            LOOP
                v_rec.assured   :=  concat(a.assd_no, ' - '||a.assd_name);   
                v_rec.recovery_no   := a.recovery_no;          
                v_rec.recovery_type := a.rec_type_desc;         
                v_rec.loss_date     := TO_CHAR(a.dsp_loss_date, 'dd-MM-yyyy');
                v_rec.recovered_amount := TRIM(TO_CHAR(a.sum_recovered_amt, '999,999,999,999,990.00'));
                PIPE ROW (v_rec);
            END LOOP;
    END populate_loss_recovery_period;

    FUNCTION populate_loss_recovery_year(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year number
    )
    RETURN loss_recovery_year_tab PIPELINED as 
        v_rec loss_recovery_year_type;
    BEGIN
        FOR a IN(
                SELECT      a.assd_no, 
                            b.assd_name, 
                            d.rec_type_desc, 
                            SUM(a.recovered_amt) sum_recovered_amt, 
                            e.dsp_loss_date,       
                            c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no,
                            'LOSS RECOVERY FOR THE YEAR ' || p_prev_year time_period
                FROM        gicl_lratio_prev_recovery_ext a, 
                            giis_assured b, 
                            gicl_clm_recovery c, 
                            giis_recovery_type d,
                            gicl_claims e
                WHERE       a.assd_no = b.assd_no
                AND         a.recovery_id = c.recovery_id
                AND         c.rec_type_cd = d.rec_type_cd
                AND         c.claim_id = e.claim_id
                AND         a.session_id = p_session_id
                GROUP BY    a.assd_no, 
                            b.assd_name, 
                            d.rec_type_desc, 
                            e.dsp_loss_date,       
                            c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')),
                            'LOSS RECOVERY FOR THE YEAR ' || p_prev_year 
                ORDER BY    recovery_no
                )
            LOOP           
                v_rec.assured   :=  concat(a.assd_no, ' - '||a.assd_name);   
                v_rec.recovery_no   := a.recovery_no;           
                v_rec.recovery_type := a.rec_type_desc;          
                v_rec.loss_date := TO_CHAR(a.dsp_loss_date, 'dd-MM-yyyy');
                v_rec.recovered_amount :=  TRIM(TO_CHAR(a.sum_recovered_amt, '999,999,999,999,990.00'));
                PIPE ROW (v_rec);
            END LOOP;
    END populate_loss_recovery_year;

    FUNCTION GICLR204E3_get_datevalue(
            p_prnt_date         VARCHAR2,
            p_policy_id         gipi_polbasic.policy_id%TYPE
        )
        RETURN VARCHAR2
        AS
            cf_date     VARCHAR2(20);
        BEGIN 
            IF p_prnt_date = '1' THEN
               SELECT TO_CHAR(issue_date,'MM-DD-RRRR') INTO cf_date
               FROM gipi_polbasic
               WHERE policy_id = p_policy_id;
               return(cf_date);
            ELSIF p_prnt_date = '3' THEN
               SELECT TO_CHAR(acct_ent_date,'MM-DD-RRRR') INTO cf_date
               FROM gipi_polbasic
               WHERE policy_id = p_policy_id;
               return(cf_date);
            ELSIF p_prnt_date = '4' THEN
               SELECT booking_mth||' '||TO_CHAR(booking_year) INTO cf_date
               FROM gipi_polbasic
               WHERE policy_id = p_policy_id;
               RETURN cf_date;
            ELSE
               RETURN NULL;
            END IF;
        END;
    -- GICLR204E3 CSVprinting added by carlo rubenecia 05.31.2016 SR 5393 -END
	
-- GICLR204F CSV printing  ---  SR 5394 added by carlo de guzman 3.23.2016
  FUNCTION csv_giclr204f(
    p_session_id NUMBER,
    p_date VARCHAR2,
    p_line VARCHAR2,
    p_subline_cd VARCHAR2,
    p_iss_cd    VARCHAR2,
    p_assd_no NUMBER,
    p_intm_no NUMBER
    )
    RETURN giclr204f_tab PIPELINED
    AS
        v_rec giclr204f_type;
        v_as_of_date  DATE := to_date(p_date, 'mm-dd-yyyy'  );
        
    BEGIN   
        FOR i IN (
                SELECT a.peril_cd, a.line_cd, a.loss_ratio_date, 
                a.curr_prem_amt,
                (a.curr_prem_res) prem_res_cy, 
                (a.prev_prem_res) prem_res_py, 
                a.loss_paid_amt,
                a.curr_loss_res ,
                a.prev_loss_res,
                nvl(a.curr_prem_amt,0) + nvl(a.curr_prem_res,0) - nvl(a.prev_prem_res,0) premiums_earned, --changed formula for premiums  earned by Carlo Rubenecia 05.24.2016 SR 5394  
                nvl(a.loss_paid_amt,0) + nvl(a.curr_loss_res,0) - nvl(a.prev_loss_res,0) losses_incurred
                FROM gicl_loss_ratio_ext a
                WHERE a.session_id = p_session_id
        )
        LOOP
            v_rec.curr_prem_amt := TRIM(TO_CHAR(NVL(i.curr_prem_amt,0), '999,999,999,990.00'));  --modified by carlo rubenecia 04.18.2016 SR 5394 -START
            v_rec.prem_res_cy := TRIM(TO_CHAR(NVL(i.prem_res_cy,0), '999,999,999,990.00'));  
            v_rec.prem_res_py :=  TRIM(TO_CHAR(NVL(i.prem_res_py,0), '999,999,999,990.00'));  
            v_rec.loss_paid_amt := TRIM(TO_CHAR(NVL(i.loss_paid_amt,0), '999,999,999,990.00'));  
            v_rec.curr_loss_res := TRIM(TO_CHAR(NVL(i.curr_loss_res,0), '999,999,999,990.00'));  
            v_rec.prev_loss_res := TRIM(TO_CHAR(NVL(i.prev_loss_res,0), '999,999,999,990.00'));  
            v_rec.premiums_earned := TRIM(TO_CHAR(i.premiums_earned, '999,999,999,990.00'));  
            v_rec.losses_incurred := TRIM(TO_CHAR(i.losses_incurred, '999,999,999,990.00'));  --modified by carlo rubenecia 04.18.2016 SR 5394 -END
            
            FOR a IN (
                    select peril_name
                    from giis_peril
                    where peril_cd = i.peril_cd
                    and line_cd = i.line_cd       
                      )
            LOOP
                v_rec.peril_name := a.peril_name;
            END LOOP;
            
              if nvl(i.premiums_earned, 0) != 0 then
                v_rec.loss_ratio := TRIM(TO_CHAR((i.losses_incurred / i.premiums_earned) * 100, '999,999,999,990.0000'));--modified by carlo rubenecia 04.18.2016 SR 5394 
              end if;      
              
           FOR i IN (select line_cd || ' - '||line_name line_name
                          from giis_line   
                         where line_cd = p_line)
            LOOP
                 v_rec.line_name := i.line_name; 
            END LOOP;        

        PIPE ROW(v_rec);
        END LOOP;
        
    END csv_giclr204f;
   -- GICLR204F SR 5394 CSV printing end --- 

  --GICLR204F3 CSV printing carlo de guzman 3.28.2016 SR 5396 -START
  --added by carlo rubenecia 04.18.2016 --start  
   FUNCTION csv_giclr204F3_pw_cy1(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204f3_details_tab1 PIPELINED AS
      cp                    giclr204f3_details_type1;
      v_grand_total         gipi_polbasic.prem_amt%TYPE := 0;
   BEGIN
      FOR i IN (SELECT b.peril_cd, TO_CHAR(date_for_24th,'MONTH YYYY') date_for_24th, b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, 
                       a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.peril_name, a.policy_id, d.assd_name
                  FROM gipi_polbasic a, gicl_lratio_curr_prem_ext b, giis_peril c, giis_assured d
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = d.assd_no (+)
                   AND b.line_cd = c.line_cd
                   AND b.peril_cd = c.peril_cd (+)
                   AND b.session_id = p_session_id
                 GROUP BY b.peril_cd, TO_CHAR(date_for_24th,'MONTH YYYY'), b.assd_no, 
                          get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, 
                          a.tsi_amt,  c.peril_name, a.policy_id, d.assd_name
                 ORDER BY 1, 2)
      LOOP
         cp.peril := i.peril_cd || ' - ' || i.peril_name;
         cp.transaction_date := i.date_for_24th;
         cp.assured := i.assd_no || ' ' || i.assd_name;
         cp.policy := i.policy_no;       
         cp.incept_date := TO_CHAR(i.incept_date,'MM-dd-yyyy');
         cp.expiry_date := TO_CHAR(i.expiry_date,'MM-dd-yyyy');     
         cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));           
         cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));  
         cp.issue_date := CSV_LOSS_RATIO.cf_dateformula(p_prnt_date, i.policy_id);
         PIPE ROW(cp);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F3_pw_cy2(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204f3_details_tab2 PIPELINED AS
      cp                    giclr204f3_details_type2;
      v_grand_total         gipi_polbasic.prem_amt%TYPE := 0;
   BEGIN
      FOR i IN (SELECT b.peril_cd, TO_CHAR(date_for_24th,'MONTH YYYY') date_for_24th, b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, 
                       a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.peril_name, a.policy_id, d.assd_name
                  FROM gipi_polbasic a, gicl_lratio_curr_prem_ext b, giis_peril c, giis_assured d
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = d.assd_no (+)
                   AND b.line_cd = c.line_cd
                   AND b.peril_cd = c.peril_cd (+)
                   AND b.session_id = p_session_id
                 GROUP BY b.peril_cd, TO_CHAR(date_for_24th,'MONTH YYYY'), b.assd_no, 
                          get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, 
                          a.tsi_amt,  c.peril_name, a.policy_id, d.assd_name
                 ORDER BY 1, 2)
      LOOP
         cp.peril := i.peril_cd || ' - ' || i.peril_name;
         cp.transaction_date := i.date_for_24th;
         cp.assured := i.assd_no || ' ' || i.assd_name;
         cp.policy := i.policy_no;       
         cp.incept_date := TO_CHAR(i.incept_date,'MM-dd-yyyy');
         cp.expiry_date := TO_CHAR(i.expiry_date,'MM-dd-yyyy');     
         cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));           
         cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00'));
         cp.acct_end_date := CSV_LOSS_RATIO.cf_dateformula(p_prnt_date, i.policy_id);
         PIPE ROW(cp);
      END LOOP;
   END;
  
   FUNCTION csv_giclr204F3_pw_cy3(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204f3_details_tab3 PIPELINED AS
      cp                    giclr204f3_details_type3;
      v_grand_total         gipi_polbasic.prem_amt%TYPE := 0;
   BEGIN
      FOR i IN (SELECT b.peril_cd, TO_CHAR(date_for_24th,'MONTH YYYY') date_for_24th, b.assd_no, get_policy_no(a.policy_id) policy_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, 
                       a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.peril_name, a.policy_id, d.assd_name
                  FROM gipi_polbasic a, gicl_lratio_curr_prem_ext b, giis_peril c, giis_assured d
                 WHERE b.policy_id = a.policy_id
                   AND b.assd_no = d.assd_no (+)
                   AND b.line_cd = c.line_cd
                   AND b.peril_cd = c.peril_cd (+)
                   AND b.session_id = p_session_id
                 GROUP BY b.peril_cd, TO_CHAR(date_for_24th,'MONTH YYYY'), b.assd_no, 
                          get_policy_no(a.policy_id), a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, 
                          a.tsi_amt,  c.peril_name, a.policy_id, d.assd_name
                 ORDER BY 1, 2)
      LOOP
         cp.peril := i.peril_cd || ' - ' || i.peril_name;
         cp.transaction_date := i.date_for_24th;
         cp.assured := i.assd_no || ' ' || i.assd_name;
         cp.policy := i.policy_no;       
         cp.incept_date := TO_CHAR(i.incept_date,'MM-dd-yyyy');
         cp.expiry_date := TO_CHAR(i.expiry_date,'MM-dd-yyyy');     
         cp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));           
         cp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00')); 
         cp.booking_date := CSV_LOSS_RATIO.cf_dateformula(p_prnt_date, i.policy_id);
         PIPE ROW(cp);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F3_pw_py1(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204f3_details_tab1 PIPELINED AS
      pp                    giclr204f3_details_type1;
   BEGIN
      FOR i IN (SELECT b.peril_cd, TO_CHAR(date_for_24th,'MONTH YYYY') date_for_24th, get_policy_no(a.policy_id) policy_no, b.assd_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, 
                       a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, a.policy_id, d.peril_name
                FROM  gipi_polbasic a, gicl_lratio_prev_prem_ext b, giis_assured c, giis_peril d
                WHERE b.policy_id = a.policy_id
                AND b.line_cd = d.line_cd 
                AND b.peril_cd = d.peril_cd
                AND b.assd_no = c.assd_no (+)
                AND b.session_id = p_session_id
                GROUP BY b.peril_cd, TO_CHAR(date_for_24th,'MONTH YYYY'), get_policy_no(a.policy_id), b.assd_no, 
                       a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, a.tsi_amt, c.assd_name, a.policy_id,
                       d.peril_name
                ORDER BY 1, 2)
      LOOP
         pp.peril := i.peril_cd || ' - ' || i.peril_name;
         pp.transaction_date := i.date_for_24th;
         pp.assured := i.assd_no || ' ' || i.assd_name;
         pp.policy := i.policy_no;       
         pp.incept_date := TO_CHAR(i.incept_date, 'MM-dd-yyyy');
         pp.expiry_date := TO_CHAR(i.expiry_date, 'MM-dd-yyy');           
         pp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));                    
         pp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00')); 
         pp.issue_date := CSV_LOSS_RATIO.cf_dateformula(p_prnt_date, i.policy_id);
         PIPE ROW(pp);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F3_pw_py2(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204f3_details_tab2 PIPELINED AS
      pp                    giclr204f3_details_type2;
   BEGIN
      FOR i IN (SELECT b.peril_cd, TO_CHAR(date_for_24th,'MONTH YYYY') date_for_24th, get_policy_no(a.policy_id) policy_no, b.assd_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, 
                       a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, a.policy_id, d.peril_name
                FROM  gipi_polbasic a, gicl_lratio_prev_prem_ext b, giis_assured c, giis_peril d
                WHERE b.policy_id = a.policy_id
                AND b.line_cd = d.line_cd 
                AND b.peril_cd = d.peril_cd
                AND b.assd_no = c.assd_no (+)
                AND b.session_id = p_session_id
                GROUP BY b.peril_cd, TO_CHAR(date_for_24th,'MONTH YYYY'), get_policy_no(a.policy_id), b.assd_no, 
                       a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, a.tsi_amt, c.assd_name, a.policy_id,
                       d.peril_name
                ORDER BY 1, 2)
      LOOP
         pp.peril := i.peril_cd || ' - ' || i.peril_name;
         pp.transaction_date := i.date_for_24th;
         pp.assured := i.assd_no || ' ' || i.assd_name;
         pp.policy := i.policy_no;       
         pp.incept_date := TO_CHAR(i.incept_date, 'MM-dd-yyyy');
         pp.expiry_date := TO_CHAR(i.expiry_date, 'MM-dd-yyy');          
         pp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));         
         pp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00')); 
         pp.acct_end_date := CSV_LOSS_RATIO.cf_dateformula(p_prnt_date, i.policy_id);
         PIPE ROW(pp);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F3_pw_py3(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204f3_details_tab3 PIPELINED AS
      pp                    giclr204f3_details_type3;
   BEGIN
      FOR i IN (SELECT b.peril_cd, TO_CHAR(date_for_24th,'MONTH YYYY') date_for_24th, get_policy_no(a.policy_id) policy_no, b.assd_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, 
                       a.tsi_amt, SUM(b.prem_amt) sum_prem_amt, c.assd_name, a.policy_id, d.peril_name
                FROM  gipi_polbasic a, gicl_lratio_prev_prem_ext b, giis_assured c, giis_peril d
                WHERE b.policy_id = a.policy_id
                AND b.line_cd = d.line_cd 
                AND b.peril_cd = d.peril_cd
                AND b.assd_no = c.assd_no (+)
                AND b.session_id = p_session_id
                GROUP BY b.peril_cd, TO_CHAR(date_for_24th,'MONTH YYYY'), get_policy_no(a.policy_id), b.assd_no, 
                       a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date, a.expiry_date, a.tsi_amt, c.assd_name, a.policy_id,
                       d.peril_name
                ORDER BY 1, 2)
      LOOP
         pp.peril := i.peril_cd || ' - ' || i.peril_name;
         pp.transaction_date := i.date_for_24th;
         pp.assured := i.assd_no || ' ' || i.assd_name;
         pp.policy := i.policy_no;       
         pp.incept_date := TO_CHAR(i.incept_date, 'MM-dd-yyyy');
         pp.expiry_date := TO_CHAR(i.expiry_date, 'MM-dd-yyy');          
         pp.tsi_amount := TRIM(TO_CHAR(i.tsi_amt, '999,999,999,990.00'));         
         pp.premium_amount := TRIM(TO_CHAR(i.sum_prem_amt, '999,999,999,990.00')); 
         pp.booking_date := CSV_LOSS_RATIO.cf_dateformula(p_prnt_date, i.policy_id);
         PIPE ROW(pp);
      END LOOP;
   END;
    --added by carlo rubenecia 04.18.2016 --end
    
   FUNCTION csv_giclr204F3_os_loss_cy(
      p_session_id          gicl_lratio_curr_os_ext.session_id%TYPE
   ) RETURN giclr204f3_os_tab PIPELINED AS
      co                    giclr204f3_os_type;
   BEGIN
      FOR i IN (SELECT a.assd_no, d.assd_name, a.claim_id, a.peril_cd, SUM(os_amt) sum_os_amt, c.peril_name, b.dsp_loss_date, b.clm_file_date, 
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) claim_no
                  FROM gicl_lratio_curr_os_ext a, gicl_claims b, giis_peril c, giis_assured d
                 WHERE a.session_id = p_session_id
                   AND a.claim_id = b.claim_id 
                   AND a.peril_cd = c.peril_cd
                   AND b.line_cd  = c.line_cd
                   AND a.assd_no = d.assd_no
                 GROUP BY a.peril_cd, a.claim_id,  a.assd_no, d.assd_name, c.peril_name, b.dsp_loss_date, b.clm_file_date,
                          b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))
                 ORDER BY 4, 9)
      LOOP
         co.peril := i.peril_cd || ' - ' || i.peril_name ;
         co.assured := i.assd_no || ' ' || i.assd_name;
         co.loss_amount := TRIM(TO_CHAR(i.sum_os_amt, '999,999,999,990.00')); --modified by carlo rubenecia 04.15.2016
         co.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-dd-yyyy');--modified by carlo rubenecia 04.18.2016
         co.file_date := TO_CHAR(i.clm_file_date, 'MM-dd-yyyy');--modified by carlo rubenecia 04.18.2016
         co.claim_no := i.claim_no;
         PIPE ROW(co);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F3_os_loss_py(
      p_session_id          gicl_lratio_prev_os_ext.session_id%TYPE
   ) RETURN giclr204f3_os_tab PIPELINED AS
      po                    giclr204f3_os_type;
   BEGIN
      FOR i IN (SELECT a.assd_no, d.assd_name, a.claim_id, a.peril_cd, SUM(os_amt) sum_os_amt, c.peril_name, b.dsp_loss_date, b.clm_file_date, 
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) claim_no
                  FROM gicl_lratio_prev_os_ext a, gicl_claims b, giis_peril c, giis_assured d
                 WHERE a.session_id = p_session_id
                   AND a.claim_id = b.claim_id 
                   AND a.peril_cd = c.peril_cd
                   AND b.line_cd  = c.line_cd
                   AND a.assd_no = d.assd_no
                 GROUP BY a.peril_cd, a.claim_id, a.assd_no, d.assd_name, c.peril_name, b.dsp_loss_date, b.clm_file_date,b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))
                 ORDER BY 4, 9)
      LOOP
         po.peril := i.peril_cd || ' - ' || i.peril_name ;
         po.assured := i.assd_no || ' ' || i.assd_name;
         po.loss_amount := TRIM(TO_CHAR(i.sum_os_amt, '999,999,999,990.00')); --modified by carlo rubenecia 04.18.2016
         po.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-dd-yyyy'); --modified by carlo rubenecia 04.18.2016
         po.file_date := TO_CHAR(i.clm_file_date, 'MM-dd-yyyy'); --modified by carlo rubenecia 04.18.2016
         po.claim_no := i.claim_no;
         PIPE ROW(po);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F3_losses_paid(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN giclr204f3_loss_tab PIPELINED AS
      lp                    giclr204f3_loss_type;
   BEGIN
      FOR i IN (SELECT a.peril_cd, a.assd_no, c.assd_name, 
                       b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')) claim_no,
                       d.peril_name, b.dsp_loss_date, SUM(a.loss_paid) sum_loss_paid
                  FROM gicl_lratio_loss_paid_ext a, gicl_claims b, giis_assured c, giis_peril d 
                 WHERE a.session_id = p_session_id
                   AND a.assd_no = c.assd_no
                   AND a.claim_id = b.claim_id
                   AND a.peril_cd = d.peril_cd
                   AND a.line_cd = d.line_cd
                 GROUP BY a.peril_cd, a.assd_no, c.assd_name, 
                          b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                          d.peril_name, b.dsp_loss_date
                 ORDER BY 1, 4)
      LOOP
         lp.assured := i.assd_no || ' ' || i.assd_name;
         lp.claim_no := i.claim_no;
         lp.peril := i.peril_cd || ' - ' || i.peril_name;
         lp.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-dd-yyyy'); --modified by carlo rubenecia 04.18.2016
         lp.loss_amount := TRIM(TO_CHAR(i.sum_loss_paid, '999,999,999,990.00')); --modified by carlo rubenecia 04.18.2016
         PIPE ROW(lp);
      END LOOP;
   END;                
   
   FUNCTION csv_giclr204F3_loss_reco_cy(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN giclr204f3_rec_tab PIPELINED AS
      cr                    giclr204f3_rec_type;
   BEGIN
      FOR i IN (SELECT a.peril_cd, f.peril_name, a.assd_no, b.assd_name, d.rec_type_desc, SUM(a.recovered_amt) sum_recovered_amt, e.dsp_loss_date, 
                       c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no
                  FROM gicl_lratio_curr_recovery_ext a, giis_assured b, gicl_clm_recovery c, giis_recovery_type d, gicl_claims e, giis_peril f
                 WHERE a.assd_no = b.assd_no
                   AND a.line_cd = f.line_cd
                   AND a.peril_cd = f.peril_cd
                   AND a.recovery_id = c.recovery_id
                   AND c.rec_type_cd = d.rec_type_cd
                   AND c.claim_id = e.claim_id
                   AND a.session_id = p_session_id
                 GROUP BY a.peril_cd, f.peril_name, a.assd_no, b.assd_name, d.rec_type_desc, e.dsp_loss_date,
                          c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009'))
                 ORDER BY 1, 8)
      LOOP
        cr.peril := i.peril_cd || ' - ' || i.peril_name;
        cr.assured := i.assd_no || ' ' || i.assd_name;
        cr.recovery_type := i.rec_type_desc;
        cr.loss_amount := TRIM(TO_CHAR(i.sum_recovered_amt, '999,999,999,990.00')); --modified by carlo rubenecia 04.18.2016
        cr.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-dd-yyyy'); --modified by carlo rubenecia 04.18.2016
        PIPE ROW(cr);
      END LOOP;
   END;
   
   FUNCTION csv_giclr204F3_loss_reco_py(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN giclr204f3_rec_tab PIPELINED AS
      pr                    giclr204f3_rec_type;
   BEGIN
      FOR i IN (SELECT a.peril_cd, f.peril_name, a.assd_no, b.assd_name, d.rec_type_desc, SUM(a.recovered_amt) sum_recovered_amt, e.dsp_loss_date,
                       c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no
                  FROM gicl_lratio_prev_recovery_ext a, giis_assured b, gicl_clm_recovery c, giis_recovery_type d, gicl_claims e, giis_peril f
                 WHERE a.assd_no = b.assd_no
                   AND a.line_cd = f.line_cd
                   AND a.peril_cd = f.peril_cd
                   AND a.recovery_id = c.recovery_id
                   AND c.rec_type_cd = d.rec_type_cd
                   AND c.claim_id = e.claim_id
                   AND a.session_id = p_session_id
                 GROUP BY a.peril_cd, f.peril_name, a.assd_no, b.assd_name, d.rec_type_desc, e.dsp_loss_date,
                          c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009'))
                 ORDER BY 1, 8)
      LOOP
         pr.peril := i.peril_cd || ' - ' || i.peril_name;
         pr.assured := i.assd_no || ' ' || i.assd_name;
         pr.recovery_type := i.rec_type_desc;
         pr.loss_amount := TRIM(TO_CHAR(i.sum_recovered_amt, '999,999,999,990.00')); --modified by carlo rubenecia 04.18.2016
         pr.loss_date := TO_CHAR(i.dsp_loss_date, 'MM-dd-yyyy');  --modified by carlo rubenecia 04.18.2016
         PIPE ROW(pr);
      END LOOP;
   END;
   --GICLR204F3 CSV printing carlo de guzman 3.28.2016 SR 5396 -END
   
END csv_loss_ratio;
/

