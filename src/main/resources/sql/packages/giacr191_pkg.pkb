CREATE OR REPLACE PACKAGE BODY CPI.giacr191_pkg
AS
   FUNCTION get_report_header (p_user_id giac_soa_rep_ext.user_id%TYPE)
      RETURN report_header_tab PIPELINED
   AS
      rep            report_header_type;
      v_print_user   VARCHAR2 (1);
      v_from_to      GIAC_PARAMETERS.param_value_v%TYPE; --VARCHAR2 (1);	-- SR-4040 : shan 06.19.2015
      v_ref_date     GIAC_PARAMETERS.param_value_v%TYPE; --VARCHAR2 (1);	-- SR-4040 : shan 06.19.2015
   BEGIN
      beforereport ();
      rep.company_name := cf_company_name;
      rep.company_address := cf_company_address;
      rep.print_company := giacp.v ('SOA_HEADER');
      rep.rundate := TO_CHAR (SYSDATE, 'MM-DD-RRRR'); --giacr191_pkg.rep_date_format);	-- SR-4040 : shan 06.19.2015
      rep.title := cf_title;
      rep.date_label := cf_date_label;
      rep.paramdate := cf_date (p_user_id);
      rep.date_tag1 := cf_date_tag1 (p_user_id);
      rep.date_tag2 := cf_date_tag2 (p_user_id);
      rep.print_date_tag := giacp.v ('SOA_FROM_TO');
      rep.label := cf_label;
      rep.signatory := cf_signatory;
      rep.designation := cf_designation;
      rep.print_signatory := giacp.v ('SOA_SIGNATORY');

      IF v_print_user = 'Y'
      THEN
         rep.print_user_id := 'N';
      END IF;

      v_from_to := giacp.v ('SOA_FROM_TO');
      v_ref_date := giacp.v ('SOA_REF_DATE');

      IF v_from_to = 'N'
      THEN
         IF v_ref_date = 'Y'
         THEN
            rep.print_footer_date := 'Y';
         ELSE
            rep.print_footer_date := 'N';
         END IF;
      ELSE
         rep.print_footer_date := 'N';
      END IF;

      PIPE ROW (rep);
   END get_report_header;

   FUNCTION cf_label
      RETURN VARCHAR2
   AS
      v_label   giac_rep_signatory.LABEL%TYPE; --VARCHAR2 (100);	-- SR-4040 : shan 06.19.2015
   BEGIN
      FOR i IN (SELECT label
                  FROM giac_rep_signatory
                 WHERE report_id = 'GIACR191'
                 ORDER BY item_no)	-- SR-4040 : shan 06.19.2015
      LOOP
         v_label := i.label;
         EXIT;
      END LOOP;

      RETURN (v_label);
   END cf_label;

   FUNCTION cf_signatory
      RETURN VARCHAR2
   AS
      v_signatory   VARCHAR2 (100);
   BEGIN
      FOR i IN (SELECT signatory
                  FROM giac_rep_signatory a, giis_signatory_names b
                 WHERE a.signatory_id = b.signatory_id
                   AND report_id = 'GIACR191'
                 ORDER BY item_no)	-- SR-4040 : shan 06.19.2015
      LOOP
         v_signatory := i.signatory;
         EXIT;
      END LOOP;

      RETURN (v_signatory);
   END cf_signatory;

   FUNCTION cf_designation
      RETURN VARCHAR2
   AS
      v_designation   VARCHAR2 (100);
   BEGIN
      FOR i IN (SELECT designation
                  FROM giac_rep_signatory a, giis_signatory_names b
                 WHERE a.signatory_id = b.signatory_id
                   AND report_id = 'GIACR191'
                 ORDER BY item_no)	-- SR-4040 : shan 06.19.2015
      LOOP
         v_designation := i.designation;
         EXIT;
      END LOOP;

      RETURN (v_designation);
   END cf_designation;

   PROCEDURE beforereport
   AS
   BEGIN
      SELECT get_rep_date_format
        INTO giacr191_pkg.rep_date_format
        FROM DUAL;
   END beforereport;

   FUNCTION cf_company_name
      RETURN VARCHAR2
   AS
      v_co_name     giac_parameters.param_value_v%TYPE;
      v_co_exists   BOOLEAN                              := FALSE;
   BEGIN
      FOR c IN (SELECT param_value_v
                  FROM giac_parameters
                 WHERE param_name = 'COMPANY_NAME')
      LOOP
         v_co_name := c.param_value_v;
         v_co_exists := TRUE;
         EXIT;
      END LOOP;

      IF v_co_exists = TRUE
      THEN
         RETURN (v_co_name);
      ELSE
         v_co_name := 'Company name not available in GIAC_PARAMETERS.';
         RETURN (v_co_name);
      END IF;

      RETURN NULL;
   END cf_company_name;

   FUNCTION cf_company_address
      RETURN VARCHAR2
   AS
      v_co_add      giac_parameters.param_value_v%TYPE;
      v_co_exists   BOOLEAN                              := FALSE;
   BEGIN
      FOR c IN (SELECT param_value_v
                  FROM giac_parameters
                 WHERE param_name = 'COMPANY_ADDRESS')
      LOOP
         v_co_add := c.param_value_v;
         v_co_exists := TRUE;
         EXIT;
      END LOOP;

      IF v_co_exists = TRUE
      THEN
         RETURN (v_co_add);
      ELSE
         v_co_add := 'Company address not available in GIAC_PARAMETERS.';
         RETURN (v_co_add);
      END IF;

      RETURN NULL;
   END cf_company_address;

   FUNCTION cf_title
      RETURN VARCHAR2
   AS
      v_title   GIAC_PARAMETERS.param_value_v%TYPE;-- VARCHAR2 (100);	-- SR-4040 : shan 06.19.2015
   BEGIN
      v_title := giacp.v ('SOA_TITLE');
      RETURN (v_title);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_title := '(NO EXISTING REPORT TITLE IN GIAC_PARAMETERS)';
         RETURN (v_title);
      WHEN TOO_MANY_ROWS
      THEN
         v_title := '(TOO MANY VALUES FOR REPORT TITLE IN GIAC_PARAMETERS)';
         RETURN (v_title);
   END cf_title;

   FUNCTION cf_date_label
      RETURN VARCHAR2
   AS
      v_date_label   GIAC_PARAMETERS.param_value_v%TYPE; --VARCHAR2 (100);	-- SR-4040 : shan 06.19.2015
   BEGIN
      v_date_label := giacp.v ('SOA_DATE_LABEL');
      RETURN (v_date_label);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_date_label := '(NO EXISTING DATE LABEL IN GIAC_PARAMETERS)';
         RETURN (v_date_label);
      WHEN TOO_MANY_ROWS
      THEN
         v_date_label :=
                        '(TOO MANY VALUES FOR DATE LABEL IN GIAC_PARAMETERS)';
         RETURN (v_date_label);
   END cf_date_label;

   FUNCTION cf_date (p_user_id giac_soa_rep_ext.user_id%TYPE)
      RETURN DATE
   AS
      v_date   DATE;
   BEGIN
      FOR c IN (SELECT param_date
                  FROM giac_soa_rep_ext
                 WHERE user_id = p_user_id AND ROWNUM = 1)
      LOOP
         v_date := c.param_date;
         EXIT;
      END LOOP;

      IF v_date IS NULL
      THEN
         v_date := SYSDATE;
      END IF;

      RETURN (v_date);
   END cf_date;

   FUNCTION cf_date_tag1 (p_user_id giac_soa_rep_ext.user_id%TYPE)
      RETURN VARCHAR2
   AS
      v_tag          VARCHAR2 (5);
      v_name1        VARCHAR2 (75);
      v_name2        VARCHAR2 (75);
      v_from_date1   DATE;
      v_to_date1     DATE;
      v_from_date2   DATE;
      v_to_date2     DATE;
      v_and          VARCHAR2 (25);
      dsp_name       VARCHAR2 (300);
      v_as_of_date   DATE;
   BEGIN
      FOR c IN (SELECT date_tag, from_date1, to_date1, from_date2, to_date2,
                       as_of_date
                  FROM giac_soa_rep_ext
                 WHERE user_id = p_user_id AND ROWNUM = 1)
      LOOP
         v_tag := c.date_tag;
         v_from_date1 := c.from_date1;
         v_to_date1 := c.to_date1;
         v_from_date2 := c.from_date2;
         v_to_date2 := c.to_date2;
         v_as_of_date := c.as_of_date;
         EXIT;
      END LOOP;

      IF v_as_of_date IS NOT NULL
      THEN
         v_name1 :=
                  'As of date ' || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
      ELSIF v_tag = 'BK'
      THEN
         v_name1 :=
               'Booking Date from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 := NULL;
      ELSIF v_tag = 'IN'
      THEN
         v_name1 :=
               'Incept Date from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 := NULL;
      ELSIF v_tag = 'IS'
      THEN
         v_name1 :=
               'Issue Date from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 := NULL;
      ELSIF v_tag = 'BKIN'
      THEN
         v_name1 :=
               'Booking Date from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 :=
               'Incept Date from '
            || TO_CHAR (v_from_date2, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date2, 'fmMonth DD, YYYY');
      ELSIF v_tag = 'BKIS'
      THEN
         v_name1 :=
               'Booking Date from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 :=
               'Issue Date from '
            || TO_CHAR (v_from_date2, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date2, 'fmMonth DD, YYYY');
      ELSE
         dsp_name := '(Unknown Basis of Extraction)';
      END IF;

      SELECT DECODE (v_name2, NULL, NULL, ' and ')
        INTO v_and
        FROM DUAL;

      dsp_name := ('Based on ' || v_name1);
      RETURN (dsp_name);
   END cf_date_tag1;

   FUNCTION cf_date_tag2 (p_user_id giac_soa_rep_ext.user_id%TYPE)
      RETURN VARCHAR2
   AS
      v_tag          VARCHAR2 (5);
      v_name1        VARCHAR2 (75);
      v_name2        VARCHAR2 (75);
      v_from_date1   DATE;
      v_to_date1     DATE;
      v_from_date2   DATE;
      v_to_date2     DATE;
      v_and          VARCHAR2 (25);
      dsp_name       VARCHAR2 (300);
      v_as_of_date   DATE;
   BEGIN
      FOR c IN (SELECT date_tag, from_date1, to_date1, from_date2, to_date2,
                       as_of_date
                  FROM giac_soa_rep_ext
                 WHERE user_id = p_user_id AND ROWNUM = 1)
      LOOP
         v_tag := c.date_tag;
         v_from_date1 := c.from_date1;
         v_to_date1 := c.to_date1;
         v_from_date2 := c.from_date2;
         v_to_date2 := c.to_date2;
         v_as_of_date := c.as_of_date;
         EXIT;
      END LOOP;

      IF v_as_of_date IS NOT NULL
      THEN
         NULL;
      ELSIF v_tag = 'BK'
      THEN
         v_name1 :=
               'Booking Date from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 := NULL;
      ELSIF v_tag = 'IN'
      THEN
         v_name1 :=
               'Incept Date from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 := NULL;
      ELSIF v_tag = 'IS'
      THEN
         v_name1 :=
               'Issue Date from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 := NULL;
      ELSIF v_tag = 'BKIN'
      THEN
         v_name1 :=
               'Booking Date from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 :=
               'Incept Date from '
            || TO_CHAR (v_from_date2, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date2, 'fmMonth DD, YYYY');
      ELSIF v_tag = 'BKIS'
      THEN
         v_name1 :=
               'Booking Date from '
            || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
         v_name2 :=
               'Issue Date from '
            || TO_CHAR (v_from_date2, 'fmMonth DD, YYYY')
            || ' to '
            || TO_CHAR (v_to_date2, 'fmMonth DD, YYYY');
      ELSE
         dsp_name := '(Unknown Basis of Extraction)';
      END IF;

      SELECT DECODE (v_name2, NULL, NULL, 'and ')
        INTO v_and
        FROM DUAL;

      dsp_name := (v_and || v_name2);
      RETURN (dsp_name);
   END cf_date_tag2;

   FUNCTION get_report_parent_details (
      p_branch_cd     giac_soa_rep_ext.branch_cd%TYPE,
      p_assd_no       giac_soa_rep_ext.assd_no%TYPE,
      p_inc_overdue   giac_soa_rep_ext.due_tag%TYPE,
      p_user          giac_soa_rep_ext.user_id%TYPE
   )
      RETURN report_parent_tab PIPELINED
   AS
      rep   report_parent_type;
   BEGIN
      beforereport ();

      FOR i IN (SELECT   a.policy_no, a.branch_cd,
                         UPPER (a.intm_name) intm_name, a.assd_no,
                         a.ref_pol_no, a.assd_name,
                            a.iss_cd
                         || '-'
                         || a.prem_seq_no
                         || '-'
                         || a.inst_no bill_no,
                         a.prem_bal_due, a.tax_bal_due, a.balance_amt_due,
                         a.aging_id, a.no_of_days, a.due_date, a.column_no,
                         a.column_title, a.iss_cd, a.prem_seq_no, a.inst_no,
                         a.incept_date, b.iss_name
                    FROM giac_soa_rep_ext a, giis_issource b
                   WHERE a.balance_amt_due != 0
                     AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                     AND a.assd_no = NVL (p_assd_no, a.assd_no)
                     AND a.user_id = UPPER (p_user)
                     AND a.due_tag =
                              DECODE (p_inc_overdue,
                                      'I', a.due_tag,
                                      'N', 'Y'
                                     )
                     AND a.iss_cd = b.iss_cd
                GROUP BY a.branch_cd,
                         a.policy_no,
                         a.intm_name,
                         a.assd_no,
                         a.ref_pol_no,
                         a.assd_name,
                         a.iss_cd || '-' || a.prem_seq_no || '-' || a.inst_no,
                         a.prem_bal_due,
                         a.tax_bal_due,
                         a.balance_amt_due,
                         a.aging_id,
                         a.no_of_days,
                         a.due_date,
                         a.column_no,
                         a.column_title,
                         a.iss_cd,
                         a.prem_seq_no,
                         a.inst_no,
                         a.incept_date,
                         b.iss_name,
                         b.iss_cd
                ORDER BY 2, a.assd_name, UPPER (intm_name), 1, 4, inst_no)
      LOOP
         rep.branch_cd := i.branch_cd;
         rep.cf_branch := i.branch_cd || '-' || i.iss_name;
         rep.assd_no := i.assd_no;
         rep.assd_name := i.assd_name;
         rep.policy_no := i.policy_no;
         rep.incept_date :=
                        TO_CHAR (i.incept_date, 'MM-DD-RRRR'); --giacr191_pkg.rep_date_format);	-- SR-4040 : shan 06.19.2015
         rep.ref_pol_no := i.ref_pol_no;
         rep.intm_name := i.intm_name;
         rep.bill_no := i.bill_no;
         rep.due_date := TO_CHAR (i.due_date, 'MM-DD-RRRR'); --giacr191_pkg.rep_date_format);	-- SR-4040 : shan 06.19.2015
         rep.prem_bal_due := i.prem_bal_due;
         rep.tax_bal_due := i.tax_bal_due;
         rep.balance_amt_due := i.balance_amt_due;
         rep.column_no := i.column_no;
         rep.column_title := i.column_title;
         PIPE ROW (rep);
      END LOOP;
   END get_report_parent_details;

   FUNCTION get_col_no_header
      RETURN col_no_header_tab PIPELINED
   AS
      rep   col_no_header_type;
   BEGIN
      FOR i IN (SELECT DISTINCT col_title, col_no
                           FROM giac_soa_title
                          WHERE rep_cd = 1
                            --AND rownum < 5
                       ORDER BY col_no)
      LOOP
         rep.col_title := i.col_title;
         rep.col_no := i.col_no;
         PIPE ROW (rep);
      END LOOP;
   END get_col_no_header;

   FUNCTION get_report_col_no_details (
      p_branch_cd     giac_soa_rep_ext.branch_cd%TYPE,
      p_assd_no       giac_soa_rep_ext.assd_no%TYPE,
      p_inc_overdue   giac_soa_rep_ext.due_tag%TYPE,
      p_user          giac_soa_rep_ext.user_id%TYPE,
      p_policy_no     giac_soa_rep_ext.policy_no%TYPE,
      p_bill_no       VARCHAR2
   )
      RETURN col_no_details_tab PIPELINED
   AS
      rep           col_no_details_type;
      v_col_title   giac_soa_rep_ext.column_title%TYPE;
   BEGIN
      beforereport ();

      FOR i IN (SELECT DISTINCT a.branch_cd, a.assd_no, a.policy_no,
                                UPPER (a.intm_name) intm_name,
                                   a.iss_cd
                                || '-'
                                || a.prem_seq_no
                                || '-'
                                || a.inst_no bill_no
                           FROM giac_soa_rep_ext a, giis_issource b
                          WHERE a.balance_amt_due != 0
                            AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                            AND a.assd_no = NVL (p_assd_no, a.assd_no)
                            AND a.user_id = UPPER (p_user)
                            AND a.due_tag =
                                   DECODE (p_inc_overdue,
                                           'I', a.due_tag,
                                           'N', 'Y'
                                          )
                            AND a.iss_cd = b.iss_cd
                            AND a.policy_no = NVL (p_policy_no, a.policy_no)
                            AND    a.iss_cd
                                || '-'
                                || a.prem_seq_no
                                || '-'
                                || a.inst_no =
                                   NVL (p_bill_no,
                                           a.iss_cd
                                        || '-'
                                        || a.prem_seq_no
                                        || '-'
                                        || a.inst_no
                                       )
                       GROUP BY a.branch_cd,
                                a.assd_no,
                                a.policy_no,
                                UPPER (a.intm_name),
                                   a.iss_cd
                                || '-'
                                || a.prem_seq_no
                                || '-'
                                || a.inst_no
                       ORDER BY 1, 2, 3, 4, 5)
      LOOP
         FOR j IN (SELECT DISTINCT col_title, col_no
                              FROM giac_soa_title
                             WHERE rep_cd = 1 --AND ROWNUM < 5
                          ORDER BY col_no)
         LOOP
            FOR k IN (SELECT   a.branch_cd, a.assd_no, a.policy_no,
                               UPPER (a.intm_name) intm_name,
                                  a.iss_cd
                               || '-'
                               || a.prem_seq_no
                               || '-'
                               || a.inst_no bill_no,
                               balance_amt_due, a.column_title
                          FROM giac_soa_rep_ext a, giis_issource b
                         WHERE a.balance_amt_due != 0
                           AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                           AND a.assd_no = NVL (p_assd_no, a.assd_no)
                           AND a.user_id = UPPER (p_user)
                           AND a.due_tag =
                                  DECODE (p_inc_overdue,
                                          'I', a.due_tag,
                                          'N', 'Y'
                                         )
                           AND a.iss_cd = b.iss_cd
                           AND a.policy_no = i.policy_no
                           AND a.column_title = j.col_title
                           AND a.intm_name = i.intm_name
                           AND    a.iss_cd
                               || '-'
                               || a.prem_seq_no
                               || '-'
                               || a.inst_no = i.bill_no
                           AND a.intm_name = i.intm_name
                      GROUP BY a.branch_cd,
                               a.assd_no,
                               a.policy_no,
                               UPPER (a.intm_name),
                                  a.iss_cd
                               || '-'
                               || a.prem_seq_no
                               || '-'
                               || a.inst_no,
                               balance_amt_due,
                               a.column_title
                      ORDER BY 1, 2, 3, 4, 5, 6)
            LOOP
               rep.branch_cd := k.branch_cd;
               rep.assd_no := k.assd_no;
               rep.policy_no := k.policy_no;
               rep.intm_name := k.intm_name;
               rep.bill_no := k.bill_no;
               rep.balance_amt_due := k.balance_amt_due;
               rep.column_title := k.column_title;
               v_col_title := k.column_title;
               PIPE ROW (rep);
            END LOOP;

            IF j.col_title <> v_col_title OR v_col_title IS NULL
            THEN
               rep.branch_cd := i.branch_cd;
               rep.assd_no := i.assd_no;
               rep.policy_no := i.policy_no;
               rep.intm_name := i.intm_name;
               rep.bill_no := i.bill_no;
               rep.balance_amt_due := 0;
               rep.column_title := j.col_title;
               PIPE ROW (rep);
            END IF;
         END LOOP;
      END LOOP;
   END get_report_col_no_details;

   FUNCTION get_report_totals (
      p_branch_cd     giac_soa_rep_ext.branch_cd%TYPE,
      p_assd_no       giac_soa_rep_ext.assd_no%TYPE,
      p_inc_overdue   giac_soa_rep_ext.due_tag%TYPE,
      p_user          giac_soa_rep_ext.user_id%TYPE
   )
      RETURN report_total_tab PIPELINED
   AS
      rep           report_total_type;
      v_col_title   giac_soa_rep_ext.column_title%TYPE;
   BEGIN
      FOR i IN (SELECT DISTINCT a.branch_cd, a.assd_no
                           FROM giac_soa_rep_ext a, giis_issource b
                          WHERE a.balance_amt_due != 0
                            AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                            AND a.assd_no = NVL (p_assd_no, a.assd_no)
                            AND a.user_id = UPPER (p_user)
                            AND a.due_tag =
                                   DECODE (p_inc_overdue,
                                           'I', a.due_tag,
                                           'N', 'Y'
                                          )
                            AND a.iss_cd = b.iss_cd
                       GROUP BY a.branch_cd, a.assd_no
                       ORDER BY 1, 2)
      LOOP
         FOR j IN (SELECT DISTINCT col_title, col_no
                              FROM giac_soa_title
                             WHERE rep_cd = 1 --AND ROWNUM < 5
                          ORDER BY col_no)
         LOOP
            FOR k IN (SELECT   a.branch_cd, a.assd_no,
                               SUM (balance_amt_due) balance_amt_due,
                               a.column_title
                          FROM giac_soa_rep_ext a, giis_issource b
                         WHERE a.balance_amt_due != 0
                           AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                           AND a.assd_no = NVL (p_assd_no, a.assd_no)
                           AND a.user_id = UPPER (p_user)
                           AND a.due_tag =
                                  DECODE (p_inc_overdue,
                                          'I', a.due_tag,
                                          'N', 'Y'
                                         )
                           AND a.iss_cd = b.iss_cd
                           AND a.column_title = j.col_title
                      GROUP BY a.branch_cd, a.assd_no, a.column_title
                      ORDER BY 1, 2)
            LOOP
               rep.branch_cd := k.branch_cd;
               rep.assd_no := k.assd_no;
               rep.balance_amt_due := k.balance_amt_due;
               rep.column_title := k.column_title;
               v_col_title := k.column_title;
               PIPE ROW (rep);
            END LOOP;

            IF j.col_title <> v_col_title OR v_col_title IS NULL
            THEN
               rep.branch_cd := i.branch_cd;
               rep.assd_no := i.assd_no;
               rep.balance_amt_due := 0;
               rep.column_title := j.col_title;
               PIPE ROW (rep);
            END IF;
         END LOOP;
      END LOOP;
   END get_report_totals;

   FUNCTION get_report_apdc_details (
      p_branch_cd   giac_soa_rep_ext.branch_cd%TYPE,
      p_assd_no     giac_soa_rep_ext.assd_no%TYPE,
      p_user        giac_soa_rep_ext.user_id%TYPE,
      p_cut_off     VARCHAR2
   )
      RETURN apdc_details_tab PIPELINED
   AS
      rep   apdc_details_type;
   BEGIN
      beforereport ();

      FOR i IN (SELECT      d.apdc_pref
                         || '-'
                         || d.branch_cd
                         || '-'
                         || d.apdc_no apdc_number,
                         d.apdc_date, c.bank_cd, e.bank_sname, c.bank_branch,
                         c.check_no, c.check_date,
                            'PHP'
                         || ' '
                         || LTRIM (TO_CHAR (c.check_amt, '999,999,990.90'))
                                                                   check_amt,
                         b.iss_cd, b.prem_seq_no, b.inst_no,
                            b.iss_cd
                         || '-'
                         || b.prem_seq_no
                         || '-'
                         || b.inst_no bill_no,
                            'PHP'
                         || ' '
                         || LTRIM (TO_CHAR (b.collection_amt,
                                            '999,999,990.90')
                                  ) collection_amt,
                         a.intm_type, d.apdc_pref, d.branch_cd, d.apdc_no,
                         a.assd_no
                    FROM giac_soa_rep_ext a,
                         giac_pdc_prem_colln b,
                         giac_apdc_payt_dtl c,
                         giac_apdc_payt d,
                         giac_banks e
                   WHERE b.pdc_id = c.pdc_id
                     AND c.apdc_id = d.apdc_id
                     AND c.bank_cd = e.bank_cd
                     AND d.apdc_flag = 'P'
                     AND c.check_flag NOT IN ('C', 'R')
                     AND TRUNC (d.apdc_date) <=
                                             TO_DATE (p_cut_off, 'MM-DD-RRRR')
                     AND a.iss_cd = b.iss_cd
                     AND a.prem_seq_no = b.prem_seq_no
                     AND a.inst_no = b.inst_no
                     AND a.balance_amt_due <> 0
                     AND a.user_id = UPPER (p_user)
                     AND a.assd_no = NVL (p_assd_no, a.assd_no)
                     AND d.branch_cd = NVL (p_branch_cd, d.branch_cd)
                ORDER BY d.apdc_pref, d.branch_cd, d.apdc_no)
      LOOP
         rep.apdc_number := i.apdc_number;
         rep.apdc_date := TO_CHAR (i.apdc_date, 'MM-DD-RRRR'); --giacr191_pkg.rep_date_format);	-- SR-4040 : shan 06.19.2015
         rep.bank_cd := i.bank_cd;
         rep.bank_sname := i.bank_sname;
         rep.bank_branch := i.bank_branch;
         rep.check_no := i.check_no;
         rep.check_date :=
                         TO_CHAR (i.check_date, 'MM-DD-RRRR'); --giacr191_pkg.rep_date_format);	-- SR-4040 : shan 06.19.2015
         rep.check_amt := i.check_amt;
         rep.iss_cd := i.iss_cd;
         rep.prem_seq_no := i.prem_seq_no;
         rep.inst_no := i.inst_no;
         rep.bill_no := i.bill_no;
         rep.collection_amt := i.collection_amt;
         rep.intm_type := i.intm_type;
         rep.apdc_pref := i.apdc_pref;
         rep.branch_cd := i.branch_cd;
         rep.apdc_no := i.apdc_no;
         rep.assd_no := i.assd_no;
         PIPE ROW (rep);
      END LOOP;
   END get_report_apdc_details;
   
   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED
   IS
      v_list csv_col_type;
   BEGIN
      FOR i IN (SELECT argument_name
                  FROM all_arguments
   		        WHERE owner = 'CPI'
     	             AND package_name = 'CSV_SOA'
     	             AND object_name = 'CSV_GIACR191'
     	             AND in_out = 'OUT'
     	             AND argument_name IS NOT NULL
	           ORDER BY position)
      LOOP
         v_list.col_name := i.argument_name;
         
         IF(SUBSTR(i.argument_name, 0, 6) = 'COL_NO') THEN
            v_list.col_name := csv_soa.get_col_title(SUBSTR(i.argument_name, 7));
         END IF;
         
         IF v_list.col_name IS NULL THEN
            v_list.col_name := i.argument_name;
         END IF;
         PIPE ROW(v_list);
      END LOOP;              
   END get_csv_cols;
END giacr191_pkg;
/