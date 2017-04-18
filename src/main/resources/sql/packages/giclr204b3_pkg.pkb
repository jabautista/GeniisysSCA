CREATE OR REPLACE PACKAGE BODY CPI.giclr204b3_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 08.07.2013
     **  Reference By : GICLR204B3
     **  Description  : LOSS RATIO DETAIL REPORT BY LINE/SUBLINE (24th Method)
     */
   FUNCTION cf_company_name
      RETURN VARCHAR2
   IS
      v_company   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_company
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_company);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN (v_company);
   END;

   FUNCTION cf_company_address
      RETURN VARCHAR2
   IS
      v_address   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN (v_address);
   END;

   FUNCTION cf_dateformula (p_prnt_date VARCHAR2, p_policy_id NUMBER)
      RETURN CHAR
   IS
   BEGIN
      IF p_prnt_date = '1'
      THEN
         FOR rec IN (SELECT issue_date
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id)
         LOOP
            RETURN (TO_CHAR (rec.issue_date, 'MM-DD-RRRR'));
         END LOOP;
      ELSIF p_prnt_date = '3'
      THEN
         FOR rec IN (SELECT acct_ent_date
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id)
         LOOP
            RETURN (TO_CHAR (rec.acct_ent_date, 'MM-DD-RRRR'));
         END LOOP;
      ELSIF p_prnt_date = '4'
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

   FUNCTION get_curr_prem_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN curr_prem_record_tab PIPELINED
   IS
      v_rec   curr_prem_record_type;
      mjm     BOOLEAN               := TRUE;
   BEGIN
      v_rec.company_name := cf_company_name;
      v_rec.company_address := cf_company_address;

      FOR i IN (SELECT   b.subline_cd, b.assd_no,
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
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                         a.policy_id, a.endt_iss_cd, a.endt_yy,
                         a.endt_seq_no, a.incept_date, a.expiry_date,
                         a.tsi_amt, SUM (b.prem_amt) prem_amt,
                         c.subline_name, d.assd_name,
                         TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 ) date_month
                    FROM gipi_polbasic a,
                         gicl_lratio_curr_prem_ext b,
                         giis_subline c,
                         giis_assured d
                   WHERE b.policy_id = a.policy_id
                     AND b.assd_no = d.assd_no(+)
                     AND b.line_cd = c.line_cd
                     AND b.subline_cd = c.subline_cd(+)
                     AND b.session_id = p_session_id
                GROUP BY b.subline_cd,
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
                         c.subline_name,
                         d.assd_name,
                         TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 )
                ORDER BY TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 ) DESC,
                         policy_no)
      LOOP
         mjm := FALSE;
         v_rec.subline_cd := i.subline_cd;
         v_rec.assd_no := i.assd_no;

         IF i.endt_seq_no != 0
         THEN
            v_rec.policy_no :=
               (   i.policy_no
                || '/'
                || i.endt_iss_cd
                || '-'
                || TO_CHAR (i.endt_yy)
                || '-'
                || TO_CHAR (i.endt_seq_no)
               );
         ELSE
            v_rec.policy_no := i.policy_no;
         END IF;

         v_rec.cf_date := cf_dateformula (p_prnt_date, i.policy_id);
         v_rec.policy_id := i.policy_id;
         v_rec.endt_iss_cd := i.endt_iss_cd;
         v_rec.endt_yy := i.endt_yy;
         v_rec.endt_seq_no := i.endt_seq_no;
         v_rec.incept_date := i.incept_date;
         v_rec.expiry_date := i.expiry_date;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.subline_name := i.subline_cd || ' - ' || i.subline_name;
         v_rec.assd_name := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_rec.date_month := i.date_month;
         v_rec.date_month_string := UPPER(TO_CHAR(i.date_month, 'fmMonth YYYY'));
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_curr_prem_record;

   FUNCTION get_prev_prem_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN prev_prem_record_tab PIPELINED
   IS
      v_rec   prev_prem_record_type;
      mjm     BOOLEAN               := TRUE;
   BEGIN
      FOR i IN (SELECT   b.subline_cd, b.assd_no,
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
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                         a.policy_id, a.endt_iss_cd, a.endt_yy,
                         a.endt_seq_no, a.incept_date, a.expiry_date,
                         a.tsi_amt, SUM (b.prem_amt) prem_amt, c.assd_name,
                         d.subline_name,
                         TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 ) date_month
                    FROM gipi_polbasic a,
                         gicl_lratio_prev_prem_ext b,
                         giis_assured c,
                         giis_subline d
                   WHERE b.policy_id = a.policy_id
                     AND b.line_cd = d.line_cd
                     AND b.subline_cd = d.subline_cd(+)
                     AND b.assd_no = c.assd_no(+)
                     AND b.session_id = p_session_id
                GROUP BY b.subline_cd,
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
                         d.subline_name,
                         TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 )
                ORDER BY TO_DATE (TO_CHAR (date_for_24th, 'MONTH YYYY'),
                                  'MONTH YYYY'
                                 ),
                         policy_no)
      LOOP
         mjm := FALSE;
         v_rec.subline_cd := i.subline_cd;
         v_rec.assd_no := i.assd_no;

         IF i.endt_seq_no != 0
         THEN
            v_rec.policy_no :=
               (   i.policy_no
                || '/'
                || i.endt_iss_cd
                || '-'
                || TO_CHAR (i.endt_yy)
                || '-'
                || TO_CHAR (i.endt_seq_no)
               );
         ELSE
            v_rec.policy_no := i.policy_no;
         END IF;

         v_rec.cf_date := cf_dateformula (p_prnt_date, i.policy_id);
         v_rec.policy_id := i.policy_id;
         v_rec.endt_iss_cd := i.endt_iss_cd;
         v_rec.endt_yy := i.endt_yy;
         v_rec.endt_seq_no := i.endt_seq_no;
         v_rec.incept_date := i.incept_date;
         v_rec.expiry_date := i.expiry_date;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.prem_amt := i.prem_amt;
         v_rec.subline_name := i.subline_cd || ' - ' || i.subline_name;
         v_rec.assd_name := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_rec.date_month := i.date_month;
         v_rec.date_month_string := UPPER(TO_CHAR(i.date_month, 'fmMonth YYYY'));
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_prev_prem_record;

   FUNCTION get_curr_loss_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN curr_loss_record_tab PIPELINED
   IS
      v_rec   curr_loss_record_type;
      mjm     BOOLEAN               := TRUE;
   BEGIN
      FOR i IN (SELECT   e.subline_name, a.subline_cd, a.assd_no,
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
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')) claim
                    FROM gicl_lratio_curr_os_ext a,
                         gicl_claims b,
                         giis_assured d,
                         giis_subline e
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = b.claim_id
                     AND a.line_cd = e.line_cd(+)
                     AND a.subline_cd = e.subline_cd(+)
                     AND a.assd_no = d.assd_no
                GROUP BY a.subline_cd,
                         e.subline_name,
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
         mjm := FALSE;
         v_rec.subline_name := i.subline_cd || ' - ' || i.subline_name;
         v_rec.subline_cd := i.subline_cd;
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_rec.claim_id := i.claim_id;
         v_rec.os_amt := i.os_amt;
         v_rec.dsp_loss_date := i.dsp_loss_date;
         v_rec.clm_file_date := i.clm_file_date;
         v_rec.claim := i.claim;
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_curr_loss_record;

   FUNCTION get_prev_loss_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN prev_loss_record_tab PIPELINED
   IS
      v_rec   prev_loss_record_type;
      mjm     BOOLEAN               := TRUE;
   BEGIN
      FOR i IN (SELECT   e.subline_name, a.subline_cd, a.assd_no,
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
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')) claim
                    FROM gicl_lratio_prev_os_ext a,
                         gicl_claims b,
                         giis_assured d,
                         giis_subline e
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = b.claim_id
                     AND a.line_cd = e.line_cd(+)
                     AND a.subline_cd = e.subline_cd
                     AND a.assd_no = d.assd_no
                GROUP BY a.subline_cd,
                         e.subline_name,
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
         mjm := FALSE;
         v_rec.subline_name := i.subline_cd || ' - ' || i.subline_name;
         v_rec.subline_cd := i.subline_cd;
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_rec.claim_id := i.claim_id;
         v_rec.os_amt := i.os_amt;
         v_rec.dsp_loss_date := i.dsp_loss_date;
         v_rec.clm_file_date := i.clm_file_date;
         v_rec.claim := i.claim;
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_prev_loss_record;

   FUNCTION get_losses_paid_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN losses_paid_record_tab PIPELINED
   IS
      v_rec   losses_paid_record_type;
      mjm     BOOLEAN                 := TRUE;
   BEGIN
      FOR i IN (SELECT   a.subline_cd, e.subline_name, a.assd_no,
                         c.assd_name,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')) claim,
                         b.dsp_loss_date, SUM (a.loss_paid) loss_paid
                    FROM gicl_lratio_loss_paid_ext a,
                         gicl_claims b,
                         giis_assured c,
                         giis_subline e
                   WHERE a.session_id = p_session_id
                     AND a.assd_no = c.assd_no
                     AND a.line_cd = e.line_cd
                     AND a.subline_cd = e.subline_cd
                     AND a.claim_id = b.claim_id
                GROUP BY a.subline_cd,
                         e.subline_name,
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
         mjm := FALSE;
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_cd || ' - ' || i.subline_name;
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_rec.claim := i.claim;
         v_rec.dsp_loss_date := i.dsp_loss_date;
         v_rec.loss_paid := i.loss_paid;
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_losses_paid_record;

   FUNCTION get_curr_recovery_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN curr_recovery_record_tab PIPELINED
   IS
      v_rec   curr_recovery_record_type;
      mjm     BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   a.subline_cd, f.subline_name, a.assd_no,
                         b.assd_name, d.rec_type_desc,
                         SUM (a.recovered_amt) recovered_amt,
                         e.dsp_loss_date,
                            c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (rec_year, '0999'))
                         || '-'
                         || LTRIM (TO_CHAR (rec_seq_no, '009')) recovery_no
                    FROM gicl_lratio_curr_recovery_ext a,
                         giis_assured b,
                         gicl_clm_recovery c,
                         giis_recovery_type d,
                         gicl_claims e,
                         giis_subline f
                   WHERE a.assd_no = b.assd_no
                     AND a.line_cd = f.line_cd
                     AND a.subline_cd = f.subline_cd
                     AND a.recovery_id = c.recovery_id
                     AND c.rec_type_cd = d.rec_type_cd
                     AND c.claim_id = e.claim_id
                     AND a.session_id = p_session_id
                GROUP BY a.subline_cd,
                         f.subline_name,
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
                ORDER BY recovery_no)
      LOOP
         mjm := FALSE;
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_cd || ' - ' || i.subline_name;
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_rec.rec_type_desc := i.rec_type_desc;
         v_rec.recovered_amt := i.recovered_amt;
         v_rec.dsp_loss_date := i.dsp_loss_date;
         v_rec.recovery_no := i.recovery_no;
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_curr_recovery_record;
   
   FUNCTION get_prev_recovery_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN prev_recovery_record_tab PIPELINED
   IS
      v_rec   prev_recovery_record_type;
      mjm     BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   a.subline_cd, f.subline_name, a.assd_no,
                         b.assd_name, d.rec_type_desc,
                         SUM (a.recovered_amt) recovered_amt,
                         e.dsp_loss_date,
                            c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (rec_year, '0999'))
                         || '-'
                         || LTRIM (TO_CHAR (rec_seq_no, '009')) recovery_no
                    FROM gicl_lratio_prev_recovery_ext a,
                         giis_assured b,
                         gicl_clm_recovery c,
                         giis_recovery_type d,
                         gicl_claims e,
                         giis_subline f
                   WHERE a.assd_no = b.assd_no
                     AND a.line_cd = f.line_cd
                     AND a.subline_cd = f.subline_cd
                     AND a.recovery_id = c.recovery_id
                     AND c.rec_type_cd = d.rec_type_cd
                     AND c.claim_id = e.claim_id
                     AND a.session_id = p_session_id
                GROUP BY a.subline_cd,
                         f.subline_name,
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
                ORDER BY recovery_no)
      LOOP
         mjm := FALSE;
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_cd || ' - ' || i.subline_name;
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := TO_CHAR (i.assd_no) || ' ' || i.assd_name;
         v_rec.rec_type_desc := i.rec_type_desc;
         v_rec.recovered_amt := i.recovered_amt;
         v_rec.dsp_loss_date := i.dsp_loss_date;
         v_rec.recovery_no := i.recovery_no;
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_prev_recovery_record;   
END giclr204b3_pkg;
/


