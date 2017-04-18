CREATE OR REPLACE PACKAGE BODY CPI.giclr204c2_pkg
AS
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

   FUNCTION get_giclr204c2_records (
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
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_record_tab PIPELINED
   IS
      v_list        giclr204c2_record_type;
      v_not_exist   BOOLEAN                := TRUE;
   BEGIN
      v_list.company_name := giisp.v ('COMPANY_NAME');
      v_list.company_add := giisp.v ('COMPANY_ADDRESS');

      --v_list.as_of_date := get_giclr207l_as_of_date (p_tran_id);
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
                         
                         --a.iss_cd,
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
         v_not_exist := FALSE;
         v_list.iss_cd := i.iss_cd;
         v_list.assd_no := i.assd_no;
         v_list.POLICY := i.POLICY;
         v_list.endt_iss_cd := i.endt_iss_cd;
         v_list.endt_yy := i.endt_yy;
         v_list.endt_seq_no := i.endt_seq_no;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;
         v_list.tsi_amt := i.tsi_amt;
         v_list.prem_amt := i.prem_amt;
         v_list.iss_name := i.iss_name;
         v_list.assd_name := i.assd_name;
         --iss_cd
         v_list.policy_id := i.policy_id;
         v_list.policy_func :=
            get_giclr204c2_policy_func (i.endt_seq_no,
                                        i.POLICY,
                                        i.endt_iss_cd,
                                        i.endt_yy
                                       );
         v_list.assd := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.iss := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.as_date := get_giclr204c2_as_date (i.policy_id, p_prnt_date);
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204c2_records;

   FUNCTION get_giclr204c2g7_records (
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
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2g7_record_tab PIPELINED
   IS
      v_list        giclr204c2g7_record_type;
      v_not_exist   BOOLEAN                  := TRUE;
   BEGIN
      --v_list.company_name := giisp.v ('COMPANY_NAME');
       --v_list.company_add := giisp.v ('COMPANY_ADDRESS');

      --v_list.as_of_date := get_giclr207l_as_of_date (p_tran_id);
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
         v_not_exist := FALSE;
         v_list.iss_cd := i.iss_cd;
         v_list.assd_no := i.assd_no;
         v_list.POLICY := i.POLICY;
         v_list.endt_iss_cd := i.endt_iss_cd;
         v_list.endt_yy := i.endt_yy;
         v_list.endt_seq_no := i.endt_seq_no;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;
         v_list.tsi_amt := i.tsi_amt;
         v_list.prem_amt := i.prem_amt;
         v_list.iss_name := i.iss_name;
         v_list.assd_name := i.assd_name;
         v_list.a_iss_cd := i.a_iss_cd;
         v_list.policy_id := i.policy_id;
         v_list.policy_func :=
            get_giclr204c2_policy_func (i.endt_seq_no,
                                        i.POLICY,
                                        i.endt_iss_cd,
                                        i.endt_yy
                                       );
         v_list.assd := get_giclr204c2_assd (i.assd_no, i.assd_name);
         v_list.iss := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.as_date := get_giclr204c2_as_date (i.policy_id, p_prnt_date);
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204c2g7_records;

   FUNCTION get_giclr204c2_claim (
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
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_claim_tab PIPELINED
   IS
      v_list        giclr204c2_claim_type;
      v_not_exist   BOOLEAN               := TRUE;
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
         v_not_exist := FALSE;
         v_list.iss_name := i.iss_name;
         v_list.iss_cd := i.iss_cd;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.claim_id := i.claim_id;
         v_list.os_amt := i.os_amt;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.claim := i.claim;
         v_list.iss := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.assd := get_giclr204c2_assd (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204c2_claim;

   FUNCTION get_giclr204c2_claimg5 (
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
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_claimg5_tab PIPELINED
   IS
      v_list        giclr204c2_claimg5_type;
      v_not_exist   BOOLEAN                 := TRUE;
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
         v_not_exist := FALSE;
         v_list.iss_name := i.iss_name;
         v_list.iss_cd := i.iss_cd;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.claim_id := i.claim_id;
         v_list.os_amt := i.os_amt;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.claim := i.claim;
         v_list.iss := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.assd := get_giclr204c2_assd (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204c2_claimg5;

   FUNCTION get_giclr204c2_claimg9 (
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
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_claimg9_tab PIPELINED
   IS
      v_list        giclr204c2_claimg9_type;
      v_not_exist   BOOLEAN                 := TRUE;
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
                ORDER BY claim)
      LOOP
         v_not_exist := FALSE;
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.claim := i.claim;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.loss_paid := i.loss_paid;
         v_list.iss := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.assd := get_giclr204c2_assd (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204c2_claimg9;

   FUNCTION get_giclr204c2_recoveryg11 (
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
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_recoveryg11_tab PIPELINED
   IS
      v_list        giclr204c2_recoveryg11_type;
      v_not_exist   BOOLEAN                     := TRUE;
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
         v_not_exist := FALSE;
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.rec_type_desc := i.rec_type_desc;
         v_list.recovered_amt := i.recovered_amt;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.RECOVERY := i.RECOVERY;
         v_list.iss := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.assd := get_giclr204c2_assd (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204c2_recoveryg11;

   FUNCTION get_giclr204c2_recoveryg13 (
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
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_recoveryg13_tab PIPELINED
   IS
      v_list        giclr204c2_recoveryg13_type;
      v_not_exist   BOOLEAN                     := TRUE;
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
         v_not_exist := FALSE;
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.rec_type_desc := i.rec_type_desc;
         v_list.recovered_amt := i.recovered_amt;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.RECOVERY := i.RECOVERY;
         v_list.iss := get_giclr204c2_iss (i.iss_cd, i.iss_name);
         v_list.assd := get_giclr204c2_assd (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204c2_recoveryg13;
END;
/


