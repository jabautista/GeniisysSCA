CREATE OR REPLACE PACKAGE BODY CPI.giclr204b2_pkg
AS
/*
** Created by   : Paolo J. Santos
** Date Created : 08.05.2013
** Reference By : giclr204b2
** Description  : LOSS RATIO PER LINE/SUBLINE DETAIL REPORT */
   FUNCTION cf_assd6formula (p_assd_no1 NUMBER, p_assd_name1 VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (TO_CHAR (p_assd_no1) || ' ' || p_assd_name1);
   END;

   FUNCTION cf_subline6formula (
      p_subline_cd7     VARCHAR2,
      p_subline_name7   VARCHAR2
   )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (p_subline_cd7 || ' - ' || p_subline_name7);
   END;

   FUNCTION cf_assd5formula (p_assd_no6 NUMBER, p_assd_name6 VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (TO_CHAR (p_assd_no6) || ' ' || p_assd_name6);
   END;

   FUNCTION cf_subline5formula (
      p_subline_cd6     VARCHAR2,
      p_subline_name6   VARCHAR2
   )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (p_subline_cd6 || ' - ' || p_subline_name6);
   END;

   FUNCTION cf_assd4formula (p_assd_no7 NUMBER, p_assd_name7 VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (TO_CHAR (p_assd_no7) || ' ' || p_assd_name7);
   END;

   FUNCTION cf_subline4formula (
      p_subline_cd1     VARCHAR2,
      p_subline_name1   VARCHAR2
   )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (p_subline_cd1 || ' - ' || p_subline_name1);
   END;

   FUNCTION cf_subline3formula (
      p_subline_cd4     VARCHAR2,
      p_subline_name4   VARCHAR2
   )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (p_subline_cd4 || ' - ' || p_subline_name4);
   END;

   FUNCTION cf_assd2formula (p_assd_no3 NUMBER, p_assd_name3 VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (TO_CHAR (p_assd_no3) || ' ' || p_assd_name3);
   END;

   FUNCTION cf_assd1formula (p_assd_no2 NUMBER, p_assd_name2 VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (TO_CHAR (p_assd_no2) || ' ' || p_assd_name2);
   END;

   FUNCTION cf_subline2formula (
      p_subline_cd3     VARCHAR2,
      p_subline_name3   VARCHAR2
   )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (p_subline_cd3 || ' - ' || p_subline_name3);
   END;

   FUNCTION cf_assd3formula (p_assd_no4 NUMBER, p_assd_name4 VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (TO_CHAR (p_assd_no4) || ' ' || p_assd_name4);
   END;

   FUNCTION cf_policy2formula (
      p_endt_seq_no2   NUMBER,
      p_policy1        VARCHAR2,
      p_endt_iss_cd2   VARCHAR2,
      p_endt_yy2       NUMBER
   )
      RETURN VARCHAR2
   IS
   BEGIN
      IF p_endt_seq_no2 != 0
      THEN
         RETURN (   p_policy1
                 || '/'
                 || p_endt_iss_cd2
                 || '-'
                 || TO_CHAR (p_endt_yy2)
                 || '-'
                 || TO_CHAR (p_endt_seq_no2)
                );
      ELSE
         RETURN (p_policy1);
      END IF;

      RETURN NULL;
   END;

   FUNCTION cf_date1formula (p_prnt_date VARCHAR2, p_policy_id1 NUMBER)
      RETURN CHAR
   IS
   BEGIN
      IF p_prnt_date = 1
      THEN
         FOR rec IN (SELECT issue_date
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id1)
         LOOP
            RETURN (TO_CHAR (rec.issue_date, 'MM-DD-RRRR'));
         END LOOP;
      ELSIF p_prnt_date = 3
      THEN
         FOR rec IN (SELECT acct_ent_date
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id1)
         LOOP
            RETURN (TO_CHAR (rec.acct_ent_date, 'MM-DD-RRRR'));
         END LOOP;
      ELSIF p_prnt_date = 4
      THEN
         FOR rec IN (SELECT    booking_mth
                            || ' '
                            || TO_CHAR (booking_year) booking_date
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id1)
         LOOP
            RETURN (rec.booking_date);
         END LOOP;
      ELSE
         RETURN (NULL);
      END IF;
   END;

   FUNCTION cf_subline1formula (
      p_subline_cd2     VARCHAR2,
      p_subline_name2   VARCHAR2
   )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (p_subline_cd2 || ' - ' || p_subline_name2);
   END;

   FUNCTION cf_company_addressformula
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

   FUNCTION cf_company_nameformula
      RETURN VARCHAR2
   IS
      --v_company varchar2(500);
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

   FUNCTION cf_assdformula (p_assd_no NUMBER, p_assd_name VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (TO_CHAR (p_assd_no) || ' ' || p_assd_name);
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

   FUNCTION cf_policyformula (
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
   END;

   FUNCTION cf_sublineformula (p_subline_cd VARCHAR2, p_subline_name VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (p_subline_cd || ' - ' || p_subline_name);
   END;

   FUNCTION get_giclr204b2_record (
      p_session_id              NUMBER, 
      p_prnt_date               VARCHAR2
   )
      RETURN giclr204b2_record_tab PIPELINED
   IS
      v_list   giclr204b2_record_type;
      pjs      BOOLEAN                := TRUE;
   BEGIN
      v_list.cf_company_name := cf_company_nameformula;
      v_list.cf_company_address := cf_company_addressformula;

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
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy1,
                         a.policy_id, a.endt_iss_cd, a.endt_yy,
                         a.endt_seq_no, a.incept_date, a.expiry_date,
                         a.tsi_amt, SUM (b.prem_amt) sum_prem_amt,
                         c.subline_name, d.assd_name
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
                         d.assd_name
                ORDER BY policy1)
      LOOP
         pjs := FALSE;
         v_list.subline_cd := i.subline_cd;
         v_list.assd_no := i.assd_no;
         v_list.policy1 := i.policy1;
         v_list.policy_id := i.policy_id;
         v_list.endt_iss_cd := i.endt_iss_cd;
         v_list.endt_yy := i.endt_yy;
         v_list.endt_seq_no := i.endt_seq_no;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;
         v_list.tsi_amt := i.tsi_amt;
         v_list.sum_prem_amt := NVL(i.sum_prem_amt, 0);
         v_list.subline_name := i.subline_name;
         v_list.assd_name := i.assd_name;
         v_list.p_session_id := p_session_id;
         v_list.cf_subline :=
                             cf_sublineformula (i.subline_cd, i.subline_name);
         v_list.cf_date := cf_dateformula (p_prnt_date, i.policy_id);
         v_list.cf_policy :=
            cf_policyformula (i.endt_seq_no,
                              i.policy1,
                              i.endt_iss_cd,
                              i.endt_yy
                             );
         v_list.cf_assd := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF pjs = TRUE
      THEN
         v_list.pjs := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204b2_record;

   FUNCTION get_giclr204b2_q2_record (p_session_id NUMBER, p_prnt_date VARCHAR2)
      RETURN giclr204b2_q2_record_tab PIPELINED
   IS
      v_list   giclr204b2_q2_record_type;
      pjs2     BOOLEAN                   := TRUE;
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
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy1,
                         a.policy_id, a.endt_iss_cd, a.endt_yy,
                         a.endt_seq_no, a.incept_date, a.expiry_date,
                         a.tsi_amt, SUM (b.prem_amt) sum_prem_amt,
                         c.assd_name, d.subline_name
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
                         d.subline_name
                ORDER BY policy1)
      LOOP
         pjs2 := FALSE;
         v_list.subline_cd := i.subline_cd;
         v_list.assd_no := i.assd_no;
         v_list.policy1 := i.policy1;
         v_list.policy_id := i.policy_id;
         v_list.endt_iss_cd := i.endt_iss_cd;
         v_list.endt_yy := i.endt_yy;
         v_list.endt_seq_no := i.endt_seq_no;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;
         v_list.tsi_amt := i.tsi_amt;
         v_list.sum_prem_amt := NVL(i.sum_prem_amt,0);
         v_list.subline_name := i.subline_name;
         v_list.assd_name := i.assd_name;
         v_list.p_session_id := p_session_id;
         v_list.cf_subline1 :=
                            cf_subline1formula (i.subline_cd, i.subline_name);
         v_list.cf_date1 := cf_date1formula (p_prnt_date, i.policy_id);
         v_list.cf_policy2 :=
            cf_policy2formula (i.endt_seq_no,
                               i.policy1,
                               i.endt_iss_cd,
                               i.endt_yy
                              );
         v_list.cf_assd3 := cf_assd3formula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF pjs2 = TRUE
      THEN
         v_list.pjs2 := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204b2_q2_record;

   FUNCTION get_giclr204b2_q3_record (p_session_id NUMBER)
      RETURN giclr204b2_q3_record_tab PIPELINED
   IS
      v_list   giclr204b2_q3_record_type;
      pjs3     BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   e.subline_name, a.subline_cd, a.assd_no,
                         d.assd_name, a.claim_id, SUM (os_amt) sum_os_amt,
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
         pjs3 := FALSE;
         v_list.subline_cd := i.subline_cd;
         v_list.assd_no := i.assd_no;
         v_list.claim_id := i.claim_id;
         v_list.sum_os_amt := NVL(i.sum_os_amt,0);
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.claim := i.claim;
         v_list.subline_name := i.subline_name;
         v_list.assd_name := i.assd_name;
         v_list.cf_subline2 :=
                            cf_subline2formula (i.subline_cd, i.subline_name);
         v_list.cf_assd1 := cf_assd1formula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF pjs3 = TRUE
      THEN
         v_list.pjs3 := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204b2_q3_record;

   FUNCTION get_giclr204b2_q4_record (p_session_id NUMBER)
      RETURN giclr204b2_q4_record_tab PIPELINED
   IS
      v_list   giclr204b2_q4_record_type;
      pjs4     BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   e.subline_name, a.subline_cd, a.assd_no,
                         d.assd_name, a.claim_id, SUM (os_amt) sum_os_amt,
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
         pjs4 := FALSE;
         v_list.subline_cd := i.subline_cd;
         v_list.assd_no := i.assd_no;
         v_list.claim_id := i.claim_id;
         v_list.sum_os_amt := i.sum_os_amt;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.claim := i.claim;
         v_list.subline_name := i.subline_name;
         v_list.assd_name := i.assd_name;
         v_list.cf_subline3 :=
                            cf_subline3formula (i.subline_cd, i.subline_name);
         v_list.cf_assd2 := cf_assd2formula (i.assd_no, i.assd_name);
         
         PIPE ROW (v_list);
      END LOOP;

      IF pjs4 = TRUE
      THEN
         v_list.pjs4 := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204b2_q4_record;

   FUNCTION get_giclr204b2_q5_record (p_session_id NUMBER)
      RETURN giclr204b2_q5_record_tab PIPELINED
   IS
      v_list   giclr204b2_q5_record_type;
      pjs5     BOOLEAN                   := TRUE;
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
                         b.dsp_loss_date, SUM (a.loss_paid) sum_loss_pd
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
         pjs5 := FALSE;
         v_list.subline_cd := i.subline_cd;
         v_list.assd_no := i.assd_no;
         v_list.sum_loss_pd := i.sum_loss_pd;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.claim := i.claim;
         v_list.subline_name := i.subline_name;
         v_list.assd_name := i.assd_name;
         v_list.cf_subline4 :=
                            cf_subline4formula (i.subline_cd, i.subline_name);
         v_list.cf_assd4 := cf_assd4formula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF pjs5 = TRUE
      THEN
         v_list.pjs5 := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204b2_q5_record;

   FUNCTION get_giclr204b2_q6_record (p_session_id NUMBER)
      RETURN giclr204b2_q6_record_tab PIPELINED
   IS
      v_list   giclr204b2_q6_record_type;
      pjs6     BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   a.subline_cd, f.subline_name, a.assd_no,
                         b.assd_name, d.rec_type_desc,
                         SUM (a.recovered_amt) sum_rec_amt, e.dsp_loss_date,
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
                ORDER BY recovery1)
      LOOP
         pjs6 := FALSE;
         v_list.subline_cd := i.subline_cd;
         v_list.assd_no := i.assd_no;
         v_list.sum_rec_amt := i.sum_rec_amt;
         v_list.rec_type_desc := i.rec_type_desc;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.subline_name := i.subline_name;
         v_list.assd_name := i.assd_name;
         v_list.recovery1 := i.recovery1;
         v_list.cf_subline5 :=
                            cf_subline5formula (i.subline_cd, i.subline_name);
         v_list.cf_assd5 := cf_assd5formula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF pjs6 = TRUE
      THEN
         v_list.pjs6 := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204b2_q6_record;

   FUNCTION get_giclr204b2_q7_record (p_session_id NUMBER)
      RETURN giclr204b2_q7_record_tab PIPELINED
   IS
      v_list   giclr204b2_q7_record_type;
      pjs7     BOOLEAN                   := TRUE;
   BEGIN
      FOR i IN (SELECT   a.subline_cd, f.subline_name, a.assd_no,
                         b.assd_name, d.rec_type_desc, SUM (a.recovered_amt) sum_rec_amt,
                         e.dsp_loss_date,
                            c.line_cd
                         || '-'
                         || c.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (rec_year, '0999'))
                         || '-'
                         || LTRIM (TO_CHAR (rec_seq_no, '009')) RECOVERY1
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
                ORDER BY RECOVERY1)
      LOOP
         pjs7 := FALSE;
         v_list.subline_cd := i.subline_cd;
         v_list.assd_no := i.assd_no;
         v_list.sum_rec_amt := i.sum_rec_amt;
         v_list.rec_type_desc := i.rec_type_desc;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.subline_name := i.subline_name;
         v_list.assd_name := i.assd_name;
         v_list.recovery1 := i.recovery1;
         v_list.cf_subline6 :=
                            cf_subline6formula (i.subline_cd, i.subline_name);
         v_list.cf_assd6 := cf_assd6formula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF pjs7 = TRUE
      THEN
         v_list.pjs7 := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204b2_q7_record;
END;
/


