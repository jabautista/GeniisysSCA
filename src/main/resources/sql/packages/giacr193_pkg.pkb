CREATE OR REPLACE PACKAGE BODY CPI.giacr193_pkg
AS
   FUNCTION get_giacr193_details (
      p_user_id       giac_soa_rep_ext.user_id%TYPE,
      p_intm_no       giac_soa_rep_ext.intm_no%TYPE,
      p_intm_type     giac_soa_rep_ext.intm_type%TYPE,
      p_branch_cd     giac_soa_rep_ext.branch_cd%TYPE,
      p_inc_overdue   giac_soa_rep_ext.due_tag%TYPE,
      p_bal_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE
   )
      RETURN giacr193_soa_intm_wonet_tab PIPELINED
   IS
      v_soa   giacr193_soa_intm_wonet_type;
      v_count NUMBER(1) :=0;
   BEGIN
   
         SELECT giacr193_pkg.get_cf_company_nameformula
           INTO v_soa.company_name
           FROM DUAL;

         SELECT giacr193_pkg.get_cf_company_addformula
           INTO v_soa.company_address
           FROM DUAL;

         SELECT giacr193_pkg.get_cf_title_formula
           INTO v_soa.report_title
           FROM DUAL;

         SELECT giacr193_pkg.get_cf_date_labelformula
           INTO v_soa.date_label
           FROM DUAL;

         SELECT giacr193_pkg.get_cf_param_dateformula (p_user_id)
           INTO v_soa.extract_date
           FROM DUAL;

         SELECT giacr193_pkg.get_parameter_v_from_to
           INTO v_soa.v_from_to
           FROM DUAL;

         SELECT giacr193_pkg.get_cf_label
           INTO v_soa.label
           FROM DUAL;

         SELECT giacr193_pkg.get_cf_signatory
           INTO v_soa.signatory
           FROM DUAL;

         SELECT giacr193_pkg.get_cf_designation
           INTO v_soa.designation
           FROM DUAL;
           
         SELECT NVL(giacp.v ('SOA_SIGNATORY'), 'N')
           INTO v_soa.soa_signatory
           FROM DUAL;

         DECLARE
            v_tag          VARCHAR2 (5);
            v_name1        VARCHAR2 (75);
            v_name2        VARCHAR2 (75);
            v_from_date1   DATE;
            v_to_date1     DATE;
            v_from_date2   DATE;
            v_to_date2     DATE;
            v_and          VARCHAR2 (25);
            v_as_of_date   DATE;
            v_param_date   DATE;
            dsp_name       VARCHAR2 (300);
            v_rep_date     VARCHAR2 (1);
            v_bal_due      VARCHAR2 (16);
         BEGIN
            FOR c IN (SELECT a.date_tag, a.from_date1, a.to_date1,
                             a.balance_amt_due, a.from_date2, a.to_date2,
                             a.as_of_date, a.param_date, b.rep_date
                        FROM giac_soa_rep_ext a, giac_soa_rep_ext_param b
                       WHERE ROWNUM = 1
                         AND a.user_id = p_user_id
                         AND b.user_id = p_user_id)
            LOOP
               v_tag := c.date_tag;
               v_from_date1 := c.from_date1;
               v_to_date1 := c.to_date1;
               v_from_date2 := c.from_date2;
               v_to_date2 := c.to_date2;
               v_rep_date := c.rep_date;
               v_as_of_date := c.as_of_date;
               v_param_date := c.param_date;
               v_bal_due := c.balance_amt_due;
               EXIT;
            END LOOP;

            IF v_rep_date = 'F'
            THEN
               IF v_tag = 'BK'
               THEN
                  v_name1 :=
                        'Booking Dates from '
                     || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
                     || ' to '
                     || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
                  v_name2 := NULL;
               ELSIF v_tag = 'IN'
               THEN
                  v_name1 :=
                        'Incept Dates from '
                     || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
                     || ' to '
                     || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
                  v_name2 := NULL;
               ELSIF v_tag = 'IS'
               THEN
                  v_name1 :=
                        'Issue Dates from '
                     || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
                     || ' to '
                     || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
                  v_name2 := NULL;
               ELSIF v_tag = 'BKIN'
               THEN
                  v_name1 :=
                        'Booking Dates from '
                     || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
                     || ' to '
                     || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
                  v_name2 :=
                        'Inception Dates from '
                     || TO_CHAR (v_from_date2, 'fmMonth DD, YYYY')
                     || ' to '
                     || TO_CHAR (v_to_date2, 'fmMonth DD, YYYY');
               ELSIF v_tag = 'BKIS'
               THEN
                  v_name1 :=
                        'Booking Dates from '
                     || TO_CHAR (v_from_date1, 'fmMonth DD, YYYY')
                     || ' to '
                     || TO_CHAR (v_to_date1, 'fmMonth DD, YYYY');
                  v_name2 :=
                        'Issue Dates from '
                     || TO_CHAR (v_from_date2, 'fmMonth DD, YYYY')
                     || ' to '
                     || TO_CHAR (v_to_date2, 'fmMonth DD, YYYY');
               ELSE
                  dsp_name := '(Unknown Basis of Extraction)';
               END IF;

               SELECT DECODE (v_name2, NULL, NULL, ' and ')
                 INTO v_and
                 FROM DUAL;

               v_soa.dsp_name := ('Based on ' || v_name1);
               v_soa.dsp_name2 := (v_and || v_name2);
            ELSIF v_rep_date = 'A'
            THEN
               IF v_tag = 'BK'
               THEN
                  v_name1 :=
                        'As Of Date '
                     || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                  v_name2 := NULL;
               ELSIF v_tag = 'IN'
               THEN
                  v_name1 :=
                        'As Of Date '
                     || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                  v_name2 := NULL;
               ELSIF v_tag = 'IS'
               THEN
                  v_name1 :=
                        'As Of Date '
                     || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                  v_name2 := NULL;
               ELSIF v_tag = 'BKIN'
               THEN
                  v_name1 :=
                        'As Of Date '
                     || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                  v_name2 :=
                        'As Of Date '
                     || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
               ELSIF v_tag = 'BKIS'
               THEN
                  v_name1 :=
                        'As Of Date '
                     || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                  v_name2 :=
                        'As Of Date '
                     || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
               ELSE
                  dsp_name := '(Unknown Basis of Extraction)';
               END IF;

               SELECT DECODE (v_name2, NULL, NULL, ' and ')
                 INTO v_and
                 FROM DUAL;

               v_soa.dsp_name := ('Based on ' || v_name1);
               v_soa.dsp_name2 := (v_and || v_name2);
            END IF;
         END;
   
      FOR i IN (SELECT   UPPER (intm_name) intm_name, intm_no, intm_type,
                         column_title, assd_no, assd_name, balance_amt_due,
                         policy_no,
                         a.iss_cd || '-'
                         || LPAD (a.prem_seq_no, 12, 0) bill_no,
                         incept_date, a.expiry_date, a.due_date, no_of_days,
                         ref_pol_no, prem_bal_due, tax_bal_due, branch_cd,
                         b.col_no, iss_cd, prem_seq_no
                    FROM giac_soa_rep_ext a, giac_soa_title b
                   WHERE rep_cd = 1
                     AND a.column_title = b.col_title
                     AND a.column_no = b.col_no
                     AND balance_amt_due != 0
                     AND a.user_id = p_user_id
                     AND intm_no = NVL (p_intm_no, intm_no)
                     AND intm_type = NVL (p_intm_type, intm_type)
                     AND branch_cd = NVL (p_branch_cd, branch_cd)
                     AND due_tag =
                                DECODE (p_inc_overdue,
                                        'I', due_tag,
                                        'N', 'Y'
                                       )
                     AND a.balance_amt_due >=
                                        NVL (p_bal_amt_due, a.balance_amt_due)
                ORDER BY branch_cd,
                         intm_no,
                         intm_no,
                         intm_name,
                         col_no,
                         no_of_days) --Dren 05.12.2016 SR-5340
      LOOP
         v_soa.branch_name := '';
         v_soa.ref_intm_cd := '';
         v_soa.intm_add := '';         
         v_soa.plate_no := NULL;
         v_soa.intm_name := i.intm_name;
         v_soa.intm_no := i.intm_no;
         v_soa.intm_type := i.intm_type;
         v_soa.column_title := i.column_title;
         v_soa.assd_no := i.assd_no;
         v_soa.assd_name := i.assd_name;
         v_soa.balance_amt_due := i.balance_amt_due;
         v_soa.policy_no := i.policy_no;
         v_soa.bill_no := i.bill_no;
         v_soa.incept_date := TO_CHAR (i.incept_date, 'MM-DD-YYYY');
         v_soa.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-YYYY');
         v_soa.due_date := TO_CHAR (i.due_date, 'MM-DD-YYYY');
         v_soa.no_of_days := i.no_of_days;
         v_soa.ref_pol_no := i.ref_pol_no;
         v_soa.prem_bal_due := i.prem_bal_due;
         v_soa.tax_bal_due := i.tax_bal_due;
         v_soa.branch_cd := i.branch_cd;
         v_soa.col_no := i.col_no;
         v_soa.iss_cd := i.iss_cd;
         v_soa.prem_seq_no := i.prem_seq_no;
         v_count := 1;

         BEGIN
            FOR c IN (SELECT iss_name
                        FROM giis_issource
                       WHERE iss_cd = v_soa.branch_cd)
            LOOP
               v_soa.branch_name := c.iss_name;
            END LOOP;
         END;

         BEGIN
            FOR c IN (SELECT ref_intm_cd
                        FROM giis_intermediary
                       WHERE intm_no = v_soa.intm_no)
            LOOP
               v_soa.ref_intm_cd := c.ref_intm_cd;
            END LOOP;
         END;

         DECLARE
            v_bm   VARCHAR2 (5);
         BEGIN
            FOR c1 IN
               (SELECT DECODE (SIGN (  3
                                     - NVL (LENGTH (   bill_addr1
                                                    || bill_addr2
                                                    || bill_addr3
                                                   ),
                                            0
                                           )
                                    ),
                               1, 'MAIL',
                               -1, 'BILL',
                               'MAIL'
                              ) addr
                  FROM giis_intermediary
                 WHERE intm_no = v_soa.intm_no)
            LOOP
               v_bm := c1.addr;
               EXIT;
            END LOOP;

            IF (v_bm = 'MAIL' OR v_bm IS NULL)
            THEN
               SELECT    mail_addr1
                      || DECODE (mail_addr2, NULL, '', ' ')
                      || mail_addr2
                      || DECODE (mail_addr3, NULL, '', ' ')
                      || mail_addr3
                 INTO v_soa.intm_add
                 FROM giis_intermediary
                WHERE intm_no = v_soa.intm_no;
            ELSIF v_bm = 'BILL'
            THEN
               SELECT    bill_addr1
                      || DECODE (bill_addr2, NULL, '', ' ')
                      || bill_addr2
                      || DECODE (bill_addr3, NULL, '', ' ')
                      || bill_addr3
                 INTO v_soa.intm_add
                 FROM giis_intermediary
                WHERE intm_no = v_soa.intm_no;
            ELSE
               v_soa.intm_add := 'UNKNOWN VALUE OF ADDRESS PARAMETER.';
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_soa.intm_add :=
                        'NO SUCH INTERMEDIARY AVAILABLE IN GIIS_INTERMEDIARY';
            WHEN TOO_MANY_ROWS
            THEN
               v_soa.intm_add :=
                           'TOO MANY VALUES FOR ADDRESS IN GIIS_INTERMEDIARY';
         END;

         DECLARE
            v_count   NUMBER;
         BEGIN
            SELECT COUNT (DISTINCT plate_no)
              INTO v_count
              FROM giac_soa_rep_ext a,
                   giac_soa_title b,
                   gipi_vehicle c,
                   gipi_invoice d
             WHERE a.column_no = b.col_no
               AND intm_no = v_soa.intm_no
               AND branch_cd = v_soa.branch_cd
               AND a.column_no = v_soa.col_no
               AND c.policy_id = d.policy_id
               AND a.prem_seq_no = d.prem_seq_no
               AND a.policy_no = v_soa.policy_no
               AND a.iss_cd = d.iss_cd;

            FOR a IN (SELECT plate_no
                        FROM giac_soa_rep_ext a,
                             giac_soa_title b,
                             gipi_vehicle c,
                             gipi_invoice d
                       WHERE a.column_no = b.col_no
                         AND intm_no = v_soa.intm_no
                         AND branch_cd = v_soa.branch_cd
                         AND a.column_no = v_soa.col_no
                         AND c.policy_id = d.policy_id
                         AND a.prem_seq_no = d.prem_seq_no
                         AND a.policy_no = v_soa.policy_no
                         AND a.iss_cd = d.iss_cd)
            LOOP
               IF v_count > 1
               THEN
                  v_soa.plate_no := 'VARIOUS';
               ELSE
                  v_soa.plate_no := a.plate_no;
               END IF;
            END LOOP;
         END;

         PIPE ROW (v_soa);
      END LOOP;

      IF v_count = 0 THEN
        PIPE ROW(v_soa);
      END IF;
      --RETURN;
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

   FUNCTION get_cf_title_formula
      RETURN VARCHAR2
   IS
      v_title   giac_parameters.param_value_v%TYPE;
   BEGIN
      SELECT giacp.v ('SOA_TITLE')
        INTO v_title
        FROM DUAL;

      RETURN (v_title);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_title := '(NO EXISTING REPORT TITLE IN GIAC_PARAMETERS)';
         RETURN (v_title);
      WHEN TOO_MANY_ROWS
      THEN
         v_title := '(TOO MANY VALUES FOR REPORT TITLE IN GIAC_PARAMETERS)';
         RETURN (v_title);
   END;

   FUNCTION get_cf_date_labelformula
      RETURN VARCHAR2
   IS
      v_date_label   giac_parameters.param_value_v%TYPE;
   BEGIN
      SELECT giacp.v ('SOA_DATE_LABEL')
        INTO v_date_label
        FROM DUAL;

      RETURN (v_date_label);
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
   END;

   FUNCTION get_cf_param_dateformula (p_user_id giac_soa_rep_ext.user_id%TYPE)
      RETURN VARCHAR2
   IS
      v_param_date   VARCHAR (100);
   BEGIN
      FOR c IN (SELECT DISTINCT TO_CHAR (param_date,
                                         'fmMonth DD, RRRR'
                                        ) param_date
                           FROM giac_soa_rep_ext
                          WHERE user_id = p_user_id AND ROWNUM = 1)
      LOOP
         v_param_date := c.param_date;
         EXIT;
      END LOOP;

      IF v_param_date IS NULL
      THEN
         v_param_date := TO_CHAR (SYSDATE, 'fmMonth DD, RRRR');
      END IF;

      RETURN (v_param_date);
   END;

   FUNCTION get_parameter_v_from_to
      RETURN VARCHAR2
   IS
      v_from_to   VARCHAR2 (1);
   BEGIN
      SELECT NVL (giacp.v ('SOA_FROM_TO'), 'N')
        INTO v_from_to
        FROM DUAL;

      RETURN v_from_to;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_from_to := 'N';
         RETURN (v_from_to);
      WHEN TOO_MANY_ROWS
      THEN
         v_from_to := 'N';
         RETURN (v_from_to);
   END;

   FUNCTION get_cf_label
      RETURN VARCHAR2
   IS
      v_label   giac_rep_signatory.LABEL%TYPE; --VARCHAR2 (100);	-- SR-4016 : shan 06.19.2015
   BEGIN
      FOR i IN (SELECT label
                  FROM giac_rep_signatory
                 WHERE report_id = 'GIACR193'
                 ORDER BY item_no)	-- SR-4016 : shan 06.19.2015
      LOOP
         v_label := i.label;
         EXIT;	-- SR-4016 : shan 06.19.2015
      END LOOP;

      RETURN (v_label);
   END;

   FUNCTION get_cf_signatory
      RETURN VARCHAR2
   IS
      v_signatory   VARCHAR2 (100);
   BEGIN
      FOR i IN (SELECT signatory
                  FROM giac_rep_signatory a, giis_signatory_names b
                 WHERE a.signatory_id = b.signatory_id
                   AND report_id = 'GIACR193'
                 ORDER BY item_no)	-- SR-4016 : shan 06.19.2015
      LOOP
         v_signatory := i.signatory;
         EXIT;	-- SR-4016 : shan 06.19.2015
      END LOOP;

      RETURN (v_signatory);
   END;

   FUNCTION get_cf_designation
      RETURN VARCHAR2
   IS
      v_designation   VARCHAR2 (100);
   BEGIN
      FOR i IN (SELECT designation
                  FROM giac_rep_signatory a, giis_signatory_names b
                 WHERE a.signatory_id = b.signatory_id
                   AND report_id = 'GIACR193'
                 ORDER BY item_no)	-- SR-4016 : shan 06.19.2015
      LOOP
         v_designation := i.designation;
         EXIT;	-- SR-4016 : shan 06.19.2015
      END LOOP;

      RETURN (v_designation);
   END;
   
END giacr193_pkg;
/