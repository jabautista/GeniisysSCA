CREATE OR REPLACE PACKAGE BODY CPI.giacr190_pkg
AS
   FUNCTION get_giacr190_report (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_month         VARCHAR2,
      p_user          VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list                report_type;
      v_tag                 VARCHAR2 (5);
      v_name1               VARCHAR2 (75);
      v_name2               VARCHAR2 (75);
      v_from_date1          DATE;
      v_to_date1            DATE;
      v_from_date2          DATE;
      v_to_date2            DATE;
      v_and                 VARCHAR2 (25);
      v_as_of_date          DATE;
      v_param_date          DATE;
      dsp_name              VARCHAR2 (300);
      v_rep_date            VARCHAR2 (1);
      v_bal_due             VARCHAR2 (16);
      v_header              giac_parameters.param_value_v%TYPE
                                                    := giacp.v ('SOA_HEADER');
      v_from_to             giac_parameters.param_value_v%TYPE
                                                   := giacp.v ('SOA_FROM_TO');
      v_ref_date            giac_parameters.param_value_v%TYPE
                                                  := giacp.v ('SOA_REF_DATE');
      v_count               NUMBER (1)                           := 0;
      v_title_tab           title_tab;
      v_index               NUMBER                               := 0;
      v_id                  NUMBER                               := 0;
      v_no_of_col_allowed   NUMBER                               := 5;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.company_name
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.company_name := '(NO COMPANY_NAME IN GIIS_PARAMETERS)';
         WHEN TOO_MANY_ROWS
         THEN
            v_list.company_name :=
                       '(TOO MANY VALUES OF COMPANY_NAME IN GIIS_PARAMETERS)';
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.company_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.company_address :=
                                    '(NO COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         WHEN TOO_MANY_ROWS
         THEN
            v_list.company_address :=
                    '(TOO MANY VALUES OF COMPANY_ADDRESS IN GIIS_PARAMETERS)';
      END;

      BEGIN
         v_list.report_title := giacp.v ('SOA_TITLE');
      END;

      BEGIN
         FOR c IN (SELECT param_date
                     FROM giac_soa_rep_ext
                    WHERE user_id = p_user AND ROWNUM = 1)
         LOOP
            v_list.report_date := c.param_date;
         END LOOP;

         IF v_list.report_date IS NULL
         THEN
            v_list.report_date := SYSDATE;
         END IF;
      END;

      BEGIN
         v_list.date_label := giacp.v ('SOA_DATE_LABEL');
      END;

      v_list.soa_branch_total_sw := 'N';

      FOR i IN (SELECT param_value_v
                  FROM giac_parameters
                 WHERE param_name LIKE 'SOA_BRANCH_TOTALS')
      LOOP
         v_list.soa_branch_total_sw := i.param_value_v;
      END LOOP;

      BEGIN
         IF v_from_to = 'Y'
         THEN
            BEGIN
               FOR c IN (SELECT a.date_tag, a.from_date1, a.to_date1,
                                a.balance_amt_due, a.from_date2, a.to_date2,
                                a.as_of_date, a.param_date, b.rep_date      --
                           FROM giac_soa_rep_ext a, giac_soa_rep_ext_param b
                          WHERE ROWNUM = 1
                            AND a.user_id = p_user
                            AND b.user_id = p_user)
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
                     v_list.date_tag1 := '(Unknown Basis of Extraction)';
                  END IF;

                  SELECT DECODE (v_name2, NULL, NULL, ' and ')
                    INTO v_and
                    FROM DUAL;

                  v_list.date_tag1 := ('Based on ' || v_name1);
                  v_list.date_tag2 := (v_and || v_name2);
               ELSIF v_rep_date = 'A'
               THEN
                  IF v_tag = 'BK'
                  THEN
                     v_name1 :=
                        'As Of '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                     v_name2 := NULL;
                  ELSIF v_tag = 'IN'
                  THEN
                     v_name1 :=
                        'As Of '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                     v_name2 := NULL;
                  ELSIF v_tag = 'IS'
                  THEN
                     v_name1 :=
                        'As Of '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                     v_name2 := NULL;
                  ELSIF v_tag = 'BKIN'
                  THEN
                     v_name1 :=
                        'As Of '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                     v_name2 :=
                        'As Of '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                  ELSIF v_tag = 'BKIS'
                  THEN
                     v_name1 :=
                        'As Of '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                     v_name2 :=
                        'As Of '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                  ELSE
                     v_list.date_tag1 := '(Unknown Basis of Extraction)';
                  END IF;

                  SELECT DECODE (v_name2, NULL, NULL, ' and ')
                    INTO v_and
                    FROM DUAL;

                  v_list.date_tag1 := ('Based on ' || v_name1);
                  v_list.date_tag2 := (v_and || v_name2);
               END IF;
            END;
         ELSE
            v_list.date_tag1 := NULL;
            v_list.date_tag2 := NULL;
         END IF;
      END;

      BEGIN
         v_list.date_tag2 := NVL (v_list.date_tag2, NULL);
      END;

      BEGIN
         IF v_from_to = 'N'
         THEN
            IF v_ref_date = 'Y'
            THEN
               BEGIN
                  FOR c IN (SELECT date_tag, from_date1, to_date1,
                                   from_date2, to_date2, as_of_date
                              FROM giac_soa_rep_ext
                             WHERE user_id = p_user AND ROWNUM = 1)
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
                           'As Of Date '
                        || TO_CHAR (v_as_of_date, 'fmMonth DD, YYYY');
                  ELSIF v_tag = 'BK'
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
                           'Inception Dates from '
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
                     v_list.date_tag3 := '(Unknown Basis of Extraction)';
                  END IF;

                  SELECT DECODE (v_name2, NULL, NULL, ' and ')
                    INTO v_and
                    FROM DUAL;

                  v_list.date_tag3 := ('Based on ' || v_name1);
                  v_list.date_tag4 := (v_and || v_name2);
               END;
            ELSE
               v_list.date_tag3 := NULL;
               v_list.date_tag4 := NULL;
            END IF;
         ELSE
            v_list.date_tag3 := NULL;
            v_list.date_tag4 := NULL;
         END IF;
      END;

      FOR i IN (SELECT DISTINCT a.branch_cd, UPPER (a.intm_name) intm_name,
                                a.intm_no, a.intm_type,
                                SUM (balance_amt_due) balance_amt_due,
                                SUM (prem_bal_due) prem_bal_due,
                                SUM (tax_bal_due) tax_bal_due, b.ref_intm_cd
                           FROM giac_soa_rep_ext a, giis_intermediary b
                          WHERE a.intm_no = b.intm_no
                            AND a.user_id = UPPER (p_user)
                            AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                            AND a.intm_no = NVL (p_intm_no, a.intm_no)
                            AND a.intm_type = NVL (p_intm_type, a.intm_type)
                            AND a.due_tag =
                                   DECODE (p_inc_overdue,
                                           'I', a.due_tag,
                                           'N', 'Y'
                                          )
                         HAVING NVL2 (p_bal_amt_due,
                                      SUM (balance_amt_due),
                                      SUM (ABS (balance_amt_due))
                                     ) >= NVL (p_bal_amt_due, 0.01)
                       GROUP BY a.branch_cd,
                                a.intm_name,
                                a.intm_no,
                                b.ref_intm_cd,
                                a.intm_type)
      LOOP
         v_id := 0;
         v_index := 0;
         v_title_tab := title_tab ();

         FOR t IN (SELECT DISTINCT col_title, col_no
                              FROM giac_soa_title
                             WHERE rep_cd = 1
                          ORDER BY col_no)
         LOOP
            v_index := v_index + 1;
            v_title_tab.EXTEND;
            v_title_tab (v_index).col_title := t.col_title;
            v_title_tab (v_index).col_no := t.col_no;
         END LOOP;

         v_index := 1;
         v_list.no_of_dummy := 1;

         IF v_title_tab.COUNT > v_no_of_col_allowed
         THEN
            v_list.no_of_dummy :=
                              TRUNC (v_title_tab.COUNT / v_no_of_col_allowed);

            IF MOD (v_title_tab.COUNT, v_no_of_col_allowed) > 0
            THEN
               v_list.no_of_dummy := v_list.no_of_dummy + 1;
            END IF;
         END IF;

         v_list.grp_dummy := 1;

         LOOP
            v_id := v_id + 1;
            v_list.branch_cd := NULL;
            v_list.intm_no := NULL;
            v_list.ref_intm_cd := NULL;
            v_list.intm_name := NULL;
            v_list.prem_bal_due := NULL;
            v_list.tax_bal_due := NULL;
            v_list.balance_amt_due := NULL;
            v_list.col_title1 := NULL;
            v_list.col_no1 := NULL;
            v_list.col_title2 := NULL;
            v_list.col_no2 := NULL;
            v_list.col_title3 := NULL;
            v_list.col_no3 := NULL;
            v_list.col_title4 := NULL;
            v_list.col_no4 := NULL;
            v_list.col_title5 := NULL;
            v_list.col_no5 := NULL;
            v_list.branch_cd := i.branch_cd;
            v_list.intm_no := i.intm_no;
            v_list.ref_intm_cd := i.ref_intm_cd;
            v_list.intm_name := i.intm_name;
            v_list.prem_bal_due := i.prem_bal_due;
            v_list.tax_bal_due := i.tax_bal_due;
            v_list.balance_amt_due := i.balance_amt_due;
            v_count := 1;

            BEGIN
               SELECT branch_name
                 INTO v_list.iss_name
                 FROM giac_branches
                WHERE branch_cd = i.branch_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_list.iss_name :=
                        'Branch code '
                     || i.branch_cd
                     || ' does not exists in GIAC_BRANCHES';
            END;

            v_list.branch_cd_dummy := v_list.branch_cd || '_' || v_id;

            IF v_index > v_no_of_col_allowed
            THEN
               v_list.grp_dummy := TRUNC (v_index / v_no_of_col_allowed);

               IF MOD (v_index, v_no_of_col_allowed) > 0
               THEN
                  v_list.grp_dummy := v_list.grp_dummy + 1;
               END IF;
            END IF;

            IF v_title_tab.EXISTS (v_index)
            THEN
               v_list.col_title1 := v_title_tab (v_index).col_title;
               v_list.col_no1 := v_title_tab (v_index).col_no;
               v_index := v_index + 1;
            END IF;

            IF v_title_tab.EXISTS (v_index)
            THEN
               v_list.col_title2 := v_title_tab (v_index).col_title;
               v_list.col_no2 := v_title_tab (v_index).col_no;
               v_index := v_index + 1;
            END IF;

            IF v_title_tab.EXISTS (v_index)
            THEN
               v_list.col_title3 := v_title_tab (v_index).col_title;
               v_list.col_no3 := v_title_tab (v_index).col_no;
               v_index := v_index + 1;
            END IF;

            IF v_title_tab.EXISTS (v_index)
            THEN
               v_list.col_title4 := v_title_tab (v_index).col_title;
               v_list.col_no4 := v_title_tab (v_index).col_no;
               v_index := v_index + 1;
            END IF;

            IF v_title_tab.EXISTS (v_index)
            THEN
               v_list.col_title5 := v_title_tab (v_index).col_title;
               v_list.col_no5 := v_title_tab (v_index).col_no;
               v_index := v_index + 1;
            END IF;

            PIPE ROW (v_list);
            EXIT WHEN v_index > v_title_tab.COUNT;
         END LOOP;
      END LOOP;

      IF v_count = 0
      THEN
         PIPE ROW (v_list);
      END IF;
   END get_giacr190_report;

   FUNCTION get_intm_bal (
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_user          VARCHAR2,
      p_col_title     VARCHAR2
   )
      RETURN intm_bal_tab PIPELINED
   IS
      v_rec     intm_bal_type;
      v_count   NUMBER        := 0;
   BEGIN
      FOR i IN (SELECT   branch_cd, intm_no, intm_type,
                         
                         -- jenny vi lim 01062005
                         get_ref_intm_cd (intm_no) intm_cd, column_title,
                         SUM (balance_amt_due) intmbal,
                         SUM (prem_bal_due) intmprem,
                         SUM (tax_bal_due) intmtax
                    FROM giac_soa_rep_ext
                   WHERE user_id = UPPER (p_user)
                     AND branch_cd = NVL (p_branch_cd, branch_cd)
                     AND intm_no = NVL (p_intm_no, intm_no)
                     AND intm_type = NVL (p_intm_type, intm_type)
                     -- jenny vi lim 01062005
                     AND due_tag =
                                DECODE (p_inc_overdue,
                                        'I', due_tag,
                                        'N', 'Y'
                                       )
                     AND column_title = p_col_title
                  HAVING SUM (balance_amt_due) <> 0
                GROUP BY branch_cd,
                         intm_no,
                         get_ref_intm_cd (intm_no),
                         column_title,
                         intm_type)
      LOOP
         v_count := 1;
         v_rec.branch_cd := i.branch_cd;
         v_rec.intm_no := i.intm_no;
         v_rec.intm_type := i.intm_type;
         v_rec.intm_cd := i.intm_cd;
         v_rec.col_title := i.column_title;
         v_rec.intmbal := i.intmbal;
         v_rec.intmprem := i.intmprem;
         v_rec.intmtax := i.intmtax;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_count = 0
      THEN
         v_rec.intmbal := 0;
         v_rec.intmprem := 0;
         v_rec.intmtax := 0;
         PIPE ROW (v_rec);
      END IF;
   END;

   FUNCTION get_summary_title_dtl (
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_user          VARCHAR2
   )
      RETURN intm_bal_tab PIPELINED
   IS
      v_rec     intm_bal_type;
      v_count   NUMBER        := 0;
   BEGIN
      FOR i IN (SELECT DISTINCT col_title, col_no
                           FROM giac_soa_title
                          WHERE rep_cd = 1
                       ORDER BY col_no)
      LOOP
         v_count := 1;
         v_rec.intmbal := 0;

         FOR j IN (SELECT SUM (intmbal) intmbal
                     FROM TABLE (giacr190_pkg.get_intm_bal (p_branch_cd,
                                                            p_inc_overdue,
                                                            p_intm_no,
                                                            p_intm_type,
                                                            p_user,
                                                            i.col_title
                                                           )
                                ))
         LOOP
            v_rec.intmbal := j.intmbal;
            EXIT;
         END LOOP;

         v_rec.col_title := i.col_title;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_count = 0
      THEN
         v_rec.intmbal := 0;
         PIPE ROW (v_rec);
      END IF;
   END;

   FUNCTION get_giacr190_columns
      RETURN giacr190_column_tab PIPELINED
   IS
      v_list   giacr190_column_type;
   BEGIN
      FOR i IN (SELECT DISTINCT col_title, col_no, rep_cd
                           FROM giac_soa_title
                          WHERE rep_cd = 1
                       ORDER BY col_no)
      LOOP
         v_list.col_title := i.col_title;
         v_list.col_no := i.col_no;
         v_list.rep_cd := i.rep_cd;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacr190_columns;

   FUNCTION get_giacr190_details (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_month         VARCHAR2,
      p_user          VARCHAR2
   )
      RETURN giacr190_tab PIPELINED
   IS
      v_list   giacr190_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.branch_cd, c.iss_name,
                                UPPER (b.intm_name) intm_name,
                                DECODE (a.lic_tag,
                                        'Y', a.intm_no,
                                        a.parent_intm_no
                                       ) intm_no,
                                DECODE (a.lic_tag,
                                        'Y', a.intm_type,
                                        b.intm_type
                                       ) intm_type,
                                SUM (a.balance_amt_due) balance_amt_due,
                                SUM (a.prem_bal_due) prem_bal_due,
                                SUM (a.tax_bal_due) tax_bal_due,
                                b.ref_intm_cd
                           FROM giac_soa_rep_ext a,
                                giis_intermediary b,
                                giis_issource c
                          WHERE b.intm_no =
                                   DECODE (a.lic_tag,
                                           'Y', a.intm_no,
                                           a.parent_intm_no
                                          )
                            AND a.user_id = UPPER (p_user)
                            AND a.iss_cd = c.iss_cd
                            AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
                            AND b.intm_no = NVL (p_intm_no, b.intm_no)
                            AND b.intm_type = NVL (p_intm_type, b.intm_type)
                            AND a.due_tag =
                                   DECODE (p_inc_overdue,
                                           'I', due_tag,
                                           'N', 'Y'
                                          )
                         HAVING SUM (a.balance_amt_due) >=
                                   NVL (p_bal_amt_due,
                                        SUM (a.balance_amt_due))
                            AND SUM (a.balance_amt_due) <> 0
                       GROUP BY a.branch_cd,
                                c.iss_name,
                                UPPER (b.intm_name),
                                DECODE (a.lic_tag,
                                        'Y', a.intm_no,
                                        a.parent_intm_no
                                       ),
                                DECODE (a.lic_tag,
                                        'Y', a.intm_type,
                                        b.intm_type
                                       ),
                                b.ref_intm_cd
                       ORDER BY intm_name)
      LOOP
         FOR j IN (SELECT DISTINCT col_title, col_no
                              FROM giac_soa_title
                             WHERE rep_cd = 1
                          ORDER BY col_no)
         LOOP
            v_list.col_no := j.col_no;
            v_list.column_title := j.col_title;
            v_list.intm_no := i.intm_no;
            v_list.intm_name := i.intm_name;
            v_list.intmbal := NULL;

            FOR t IN (SELECT   a.branch_cd,
                               DECODE (a.lic_tag,
                                       'Y', a.intm_no,
                                       a.parent_intm_no
                                      ) intm_no,
                               DECODE (a.lic_tag,
                                       'Y', a.intm_type,
                                       b.intm_type
                                      ) intm_type,
                               a.column_title,
                               NVL (SUM (balance_amt_due), 0.00) intmbal,
                               NVL (SUM (prem_bal_due), 0.00) intmprem,
                               NVL (SUM (tax_bal_due), 0.00) intmtax
                          FROM giac_soa_rep_ext a, giis_intermediary b
                         WHERE a.user_id = UPPER (p_user)
                           AND branch_cd = NVL (p_branch_cd, branch_cd)
                           AND DECODE (a.lic_tag,
                                       'Y', a.intm_no,
                                       a.parent_intm_no
                                      ) =
                                  NVL (i.intm_no,
                                       DECODE (a.lic_tag,
                                               'Y', a.intm_no,
                                               a.parent_intm_no
                                              )
                                      )
                           AND DECODE (a.lic_tag,
                                       'Y', a.intm_type,
                                       b.intm_type
                                      ) =
                                  NVL (p_intm_type,
                                       DECODE (a.lic_tag,
                                               'Y', a.intm_type,
                                               b.intm_type
                                              )
                                      )
                           AND due_tag =
                                  DECODE (p_inc_overdue,
                                          'I', due_tag,
                                          'N', 'Y'
                                         )
                           AND b.intm_no =
                                  DECODE (a.lic_tag,
                                          'Y', a.intm_no,
                                          a.parent_intm_no
                                         )
                           AND a.column_title = j.col_title
                        HAVING SUM (balance_amt_due) <> 0
                      GROUP BY branch_cd,
                               DECODE (a.lic_tag,
                                       'Y', a.intm_no,
                                       a.parent_intm_no
                                      ),
                               DECODE (a.lic_tag,
                                       'Y', a.intm_type,
                                       b.intm_type
                                      ),
                               column_title)
            LOOP
               v_list.intm_type := t.intm_type;
               v_list.branch_cd := t.branch_cd;
               v_list.intmbal := t.intmbal;
               v_list.intmprem := t.intmprem;
               v_list.intmtax := t.intmtax;
            END LOOP;

            PIPE ROW (v_list);
         END LOOP;
      END LOOP;

      RETURN;
   END get_giacr190_details;

   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED
   IS
      v_list   csv_col_type;
   BEGIN
      FOR i IN (SELECT   argument_name
                    FROM all_arguments
                   WHERE owner = 'CPI'
                     AND package_name = 'CSV_SOA'
                     AND object_name = 'CSV_GIACR190'
                     AND in_out = 'OUT'
                     AND argument_name IS NOT NULL
                ORDER BY POSITION)
      LOOP
         v_list.col_name := i.argument_name;

         IF (SUBSTR (i.argument_name, 0, 6) = 'COL_NO')
         THEN
            v_list.col_name :=
                          csv_soa.get_col_title (SUBSTR (i.argument_name, 7));
         END IF;

         IF v_list.col_name IS NULL
         THEN
            v_list.col_name := i.argument_name;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_csv_cols;
END;
/


