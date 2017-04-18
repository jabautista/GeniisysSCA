CREATE OR REPLACE PACKAGE BODY CPI.giclr204a3_pkg
AS
/*
   ** Created by : Ariel P. Ignas Jr
   ** Date Created : 08.05.2013
   ** Reference By : GICLR204A3
   ** Description : LOSS RATIO DETAIL REPORT BY LINE (24th Method)
   */
   FUNCTION cf_company_nameformula
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

   FUNCTION get_giclr204a3_q1_record (p_session_id NUMBER)
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
         v_list.line_name := i.line_name;
         v_list.line_cd := i.line_cd;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.claim_id := i.claim_id;
         v_list.sum_os_amt := i.sum_os_amt;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.claim := i.claim;
         v_list.cf_lineformula := cf_lineformula (i.line_cd, i.line_name);
         v_list.cf_assdformula := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         v_list.v_test := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204a3_q1_record;

   FUNCTION get_giclr204a3_q2_record (p_session_id NUMBER)
      RETURN giclr204a3_q2_record_tab PIPELINED
   IS
      v_list   giclr204a3_q2_record_type;
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
         v_list.line_name := i.line_name;
         v_list.line_cd := i.line_cd;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.claim_id := i.claim_id;
         v_list.sum_os_amt := i.sum_os_amt;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.claim := i.claim;
         v_list.cf_lineformula := cf_lineformula (i.line_cd, i.line_name);
         v_list.cf_assdformula := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         v_list.v_test := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204a3_q2_record;

   FUNCTION get_giclr204a3_q3_record (p_session_id NUMBER, p_prnt_date VARCHAR2)
      RETURN giclr204a3_q3_record_tab PIPELINED
   IS
      v_list   giclr204a3_q3_record_type;
      v_test   BOOLEAN                   := TRUE;
   BEGIN
      v_list.cf_company_nameformula := cf_company_nameformula;
      v_list.cf_company_addressformula := cf_company_addressformula;

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
         v_list.line_cd := i.line_cd;
         v_list.assd_no := i.assd_no;
         v_list.policy1 := i.policy1;
         v_list.endt_iss_cd := i.endt_iss_cd;
         v_list.endt_yy := i.endt_yy;
         v_list.endt_seq_no := i.endt_seq_no;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;
         v_list.tsi_amt := i.tsi_amt;
         v_list.sum_prem_amt := i.sum_prem_amt;
         v_list.line_name := i.line_name;
         v_list.policy_id := i.policy_id;
         v_list.assd_name := i.assd_name;
         v_list.month1 := TO_CHAR (i.month1, 'MONTH YYYY');
         v_list.cf_lineformula := cf_lineformula (i.line_cd, i.line_name);
         v_list.cf_dateformula := cf_dateformula (p_prnt_date, i.policy_id);
         v_list.cf_policyformula :=
            cf_policyformula (i.endt_seq_no,
                              i.policy1,
                              i.endt_iss_cd,
                              i.endt_yy
                             );
         v_list.cf_assdformula := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         v_list.v_test := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204a3_q3_record;

   FUNCTION get_giclr204a3_q4_record (p_session_id NUMBER, p_prnt_date VARCHAR2)
      RETURN giclr204a3_q4_record_tab PIPELINED
   IS
      v_list   giclr204a3_q4_record_type;
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
         v_list.line_cd := i.line_cd;
         v_list.assd_no := i.assd_no;
         v_list.policy1 := i.policy1;
         v_list.endt_iss_cd := i.endt_iss_cd;
         v_list.endt_yy := i.endt_yy;
         v_list.endt_seq_no := i.endt_seq_no;
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;
         v_list.tsi_amt := i.tsi_amt;
         v_list.sum_prem_amt := i.sum_prem_amt;
         v_list.line_name := i.line_name;
         v_list.policy_id := i.policy_id;
         v_list.assd_name := i.assd_name;
         v_list.month1 := i.month1;
         v_list.cf_lineformula := cf_lineformula (i.line_cd, i.line_name);
         v_list.cf_dateformula := cf_dateformula (p_prnt_date, i.policy_id);
         v_list.cf_policyformula :=
            cf_policyformula (i.endt_seq_no,
                              i.policy1,
                              i.endt_iss_cd,
                              i.endt_yy
                             );
         v_list.cf_assdformula := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         v_list.v_test := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204a3_q4_record;

   FUNCTION get_giclr204a3_q5_record (p_session_id NUMBER)
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
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.claim := i.claim;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.sum_loss_paid := i.sum_loss_paid;
         v_list.cf_lineformula := cf_lineformula (i.line_cd, i.line_name);
         v_list.cf_assdformula := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         v_list.v_test := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204a3_q5_record;

   FUNCTION get_giclr204a3_q6_record (p_session_id NUMBER)
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
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.rec_type_desc := i.rec_type_desc;
         v_list.sum_recovered_amt := i.sum_recovered_amt;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.recovery1 := i.recovery1;
         v_list.cf_lineformula := cf_lineformula (i.line_cd, i.line_name);
         v_list.cf_assdformula := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         v_list.v_test := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204a3_q6_record;

   FUNCTION get_giclr204a3_q7_record (p_session_id NUMBER)
      RETURN giclr204a3_q7_record_tab PIPELINED
   IS
      v_list   giclr204a3_q7_record_type;
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
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.rec_type_desc := i.rec_type_desc;
         v_list.sum_recovered_amt := i.sum_recovered_amt;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.recovery1 := i.recovery1;
         v_list.cf_lineformula := cf_lineformula (i.line_cd, i.line_name);
         v_list.cf_assdformula := cf_assdformula (i.assd_no, i.assd_name);
         PIPE ROW (v_list);
      END LOOP;

      IF v_test = TRUE
      THEN
         v_list.v_test := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr204a3_q7_record;
END;
/


