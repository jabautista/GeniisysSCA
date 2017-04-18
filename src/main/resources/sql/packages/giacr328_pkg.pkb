CREATE OR REPLACE PACKAGE BODY CPI.GIACR328_PKG
AS
/*
    **  Created by   :  Kenneth Mark C. Labrador
    **  Date Created : 07.03.2013
    **  Reference By : GIACR328_PKG - AGING OF COLLECTION
    */
   FUNCTION get_giacr328_rec (
      p_user_id     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE
   )
      RETURN giacr328_rec_tab PIPELINED
   IS
      v_list   giacr328_rec_type;
   BEGIN
      FOR i IN (SELECT   a.prem_amt, a.intm_no, a.line_cd, a.ref_intm_cd,
                         a.invoice_no, a.policy_no, a.iss_cd, a.eff_date,
                         a.incept_date, a.age, a.last_update, a.user_id,
                         a.gross_prem_amt, b.iss_name, c.intm_name,
                         d.line_name, e.column_title, SUM (a.prem_amt) prem
                    FROM giac_aging_prem_paid_ext a,
                         giis_issource b,
                         giis_intermediary c,
                         giis_line d,
                         giis_report_aging e
                   WHERE a.iss_cd = b.iss_cd
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.user_id = NVL (p_user_id, a.user_id)
                     AND a.intm_no = c.intm_no
                     AND a.line_cd = d.line_cd
                     AND e.report_id = 'GIACR328'
                     AND a.age BETWEEN e.min_days AND e.max_days
                     AND a.eff_date BETWEEN p_from_date AND p_to_date
                GROUP BY a.intm_no,
                         a.line_cd,
                         a.ref_intm_cd,
                         a.invoice_no,
                         a.policy_no,
                         a.iss_cd,
                         a.eff_date,
                         a.incept_date,
                         a.prem_amt,
                         a.age,
                         a.last_update,
                         a.user_id,
                         a.gross_prem_amt,
                         b.iss_name,
                         c.intm_name,
                         d.line_name,
                         e.column_title
                ORDER BY c.intm_name)
      LOOP
         v_list.cf_company_add := giacp.v ('COMPANY_ADDRESS');
         v_list.cf_company_name := giacp.v ('COMPANY_NAME');
         v_list.cf_title :=
               'Cash Receipts for the Period of '
            || INITCAP (TO_CHAR (p_from_date, 'fmMonth DD, YYYY'))
            || ' to '
            || INITCAP (TO_CHAR (p_to_date, 'fmMonth DD, YYYY'));
         v_list.prem_amt := i.prem_amt;
         v_list.intm_no := i.intm_no;
         v_list.line_cd := i.line_cd;
         v_list.ref_intm_cd := i.ref_intm_cd;
         v_list.invoice_no := i.invoice_no;
         v_list.policy_no := i.policy_no;
         v_list.iss_cd := i.iss_cd;
         v_list.eff_date := i.eff_date;
         v_list.incept_date := i.incept_date;
         v_list.age := i.age;
         v_list.gross_prem_amt := i.gross_prem_amt;
         v_list.iss_name := i.iss_name;
         v_list.intm_name := i.intm_name;
         v_list.line_name := i.line_name;
         v_list.column_title := i.column_title;
         v_list.prem := i.prem;
         PIPE ROW (v_list);
      END LOOP;
   END get_giacr328_rec;

   FUNCTION get_distinct_details (
      p_user_id     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE,
      p_date        VARCHAR2
   )
      RETURN distinct_details_tab PIPELINED
   IS
      v_list   distinct_details_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.prem_amt, a.intm_no, a.line_cd,
                                a.ref_intm_cd, a.iss_cd, b.iss_name,
                                c.intm_name, d.line_name, a.gross_prem_amt,
                                SUM (a.gross_prem_amt) sum_gross
                           FROM giac_aging_prem_paid_ext a,
                                giis_issource b,
                                giis_intermediary c,
                                giis_line d,
                                giis_report_aging e
                          WHERE a.iss_cd = b.iss_cd
                            AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                            AND a.user_id = NVL (p_user_id, a.user_id)
                            AND a.intm_no = c.intm_no
                            AND a.line_cd = d.line_cd
                            AND e.report_id = 'GIACR328'
                            AND a.age BETWEEN e.min_days AND e.max_days
                            AND a.eff_date BETWEEN p_from_date AND p_to_date
                       GROUP BY a.prem_amt,
                                a.intm_no,
                                a.line_cd,
                                a.ref_intm_cd,
                                a.iss_cd,
                                b.iss_name,
                                c.intm_name,
                                d.line_name,
                                a.gross_prem_amt)
      LOOP
         v_list.cf_company_add := giacp.v ('COMPANY_ADDRESS');
         v_list.cf_company_name := giacp.v ('COMPANY_NAME');
         v_list.cf_title :=
               'Cash Receipts for the Period of '
            || INITCAP (TO_CHAR (p_from_date, 'fmMonth DD, YYYY'))
            || ' to '
            || INITCAP (TO_CHAR (p_to_date, 'fmMonth DD, YYYY'));
         v_list.prem_amt := i.prem_amt;
         v_list.intm_no := i.intm_no;
         v_list.line_cd := i.line_cd;
         v_list.ref_intm_cd := i.ref_intm_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         v_list.intm_name := i.intm_name;
         v_list.line_name := i.line_name;
         v_list.gross_prem_amt := i.gross_prem_amt;
         v_list.dummy_total := i.sum_gross;
         PIPE ROW (v_list);
      END LOOP;
   END get_distinct_details;

   FUNCTION get_column_title
      RETURN column_title_tab PIPELINED
   IS
      v_list   column_title_type;
   BEGIN
      FOR i IN (SELECT   column_title
                    FROM giis_report_aging
                   WHERE report_id = 'GIACR328'
                ORDER BY column_no)
      LOOP
         v_list.column_title := i.column_title;
         v_list.dummy_row := 1;
         PIPE ROW (v_list);
      END LOOP;
   END get_column_title;

   FUNCTION get_column_details (
      p_user_id     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE
   )
      RETURN column_details_tab PIPELINED
   IS
      v_list   column_details_type;
   BEGIN
      FOR h IN (SELECT   column_title
                    FROM giis_report_aging
                   WHERE report_id = 'GIACR328'
                ORDER BY column_no)
      LOOP
         FOR i IN (SELECT DISTINCT a.prem_amt, a.intm_no, a.line_cd,
                                   a.ref_intm_cd, a.invoice_no, a.policy_no,
                                   a.iss_cd, a.eff_date, a.incept_date,
                                   a.age, a.last_update, a.user_id,
                                   a.gross_prem_amt, b.iss_name, c.intm_name,
                                   d.line_name, e.column_title,
                                   SUM (a.prem_amt) prem
                              FROM giac_aging_prem_paid_ext a,
                                   giis_issource b,
                                   giis_intermediary c,
                                   giis_line d,
                                   giis_report_aging e
                             WHERE a.iss_cd = b.iss_cd
                               AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                               AND a.user_id = NVL (p_user_id, a.user_id)
                               AND a.intm_no = c.intm_no
                               AND a.line_cd = d.line_cd
                               AND e.report_id = 'GIACR328'
                               AND a.age BETWEEN e.min_days AND e.max_days
                               AND a.eff_date BETWEEN p_from_date AND p_to_date
                          GROUP BY a.intm_no,
                                   a.line_cd,
                                   a.ref_intm_cd,
                                   a.invoice_no,
                                   a.policy_no,
                                   a.iss_cd,
                                   a.eff_date,
                                   a.incept_date,
                                   a.prem_amt,
                                   a.age,
                                   a.last_update,
                                   a.user_id,
                                   a.gross_prem_amt,
                                   b.iss_name,
                                   c.intm_name,
                                   d.line_name,
                                   e.column_title
                          ORDER BY a.iss_cd)
         LOOP
            IF i.column_title = h.column_title
            THEN
               v_list.intm_no := i.intm_no;
               v_list.prem_amt := i.prem;
               v_list.iss_cd := i.iss_cd;
               v_list.eff_date := i.eff_date;
               v_list.incept_date := i.incept_date;
               v_list.age := i.age;
               v_list.iss_name := i.iss_name;
               v_list.line_name := i.line_name;
            ELSE
               v_list := NULL;
            END IF;

            v_list.invoice_no := i.invoice_no;
            v_list.intm_name := i.intm_name;
            v_list.gross_prem_amt := i.gross_prem_amt;
            v_list.line_cd := i.line_cd;
            v_list.ref_intm_cd := i.ref_intm_cd;
            v_list.policy_no := i.policy_no;
            v_list.column_title := h.column_title;
            PIPE ROW (v_list);
         END LOOP;
      END LOOP;
   END get_column_details;

   FUNCTION get_giacr328_header (
      p_user_id     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE,
      p_date        VARCHAR2
   )
      RETURN giacr328_header_tab PIPELINED
   IS
      v_row          giacr328_header_type;
      v_column_tab   column_tab;
      v_index        NUMBER               := 0;
      v_id           NUMBER               := 0;
      v_flag         BOOLEAN              := FALSE;
   BEGIN
      v_row.v_flag := 'N';

      FOR iss IN (SELECT DISTINCT a.iss_cd, b.iss_name
                             FROM giac_aging_prem_paid_ext a,
                                  giis_issource b,
                                  giis_intermediary c,
                                  giis_line d,
                                  giis_report_aging e
                            WHERE a.iss_cd = b.iss_cd
                              AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                              AND a.user_id = NVL (p_user_id, a.user_id)
                              AND a.intm_no = c.intm_no
                              AND a.line_cd = d.line_cd
                              AND e.report_id = 'GIACR328'
                              AND a.age BETWEEN e.min_days AND e.max_days
                              AND a.eff_date BETWEEN p_from_date AND p_to_date
                         ORDER BY b.iss_name)
      LOOP
         v_id := 0;
         v_index := 0;
         v_column_tab := column_tab ();
         v_flag := TRUE;

         FOR col IN (SELECT   column_no, column_title
                         FROM giis_report_aging
                        WHERE report_id = 'GIACR328'
                     ORDER BY column_no)
         LOOP
            v_index := v_index + 1;
            v_column_tab.EXTEND;
            v_column_tab (v_index).col_no := col.column_no;
            v_column_tab (v_index).col_name := col.column_title;

            FOR aging_prem IN (SELECT   a.iss_cd, SUM (a.prem_amt) prem_amt
                                   FROM giac_aging_prem_paid_ext a,
                                        giis_issource b,
                                        giis_intermediary c,
                                        giis_line d,
                                        giis_report_aging e
                                  WHERE a.iss_cd = b.iss_cd
                                    AND a.iss_cd = NVL (iss.iss_cd, a.iss_cd)
                                    AND a.user_id = NVL (p_user_id, a.user_id)
                                    AND a.intm_no = c.intm_no
                                    AND a.line_cd = d.line_cd
                                    AND e.report_id = 'GIACR328'
                                    AND e.column_no =
                                                 v_column_tab (v_index).col_no
                                    AND a.age BETWEEN e.min_days AND e.max_days
                                    AND a.eff_date BETWEEN p_from_date
                                                       AND p_to_date
                               GROUP BY a.iss_cd
                               ORDER BY a.iss_cd)
            LOOP
               v_column_tab (v_index).aging_value := aging_prem.prem_amt;
            END LOOP;
         END LOOP;

         v_index := 1;

         LOOP
            v_id := v_id + 1;
            v_row := NULL;
            v_row.iss_cd := iss.iss_cd;
            v_row.iss_name := iss.iss_name;
            v_row.iss_cd_dummy := iss.iss_cd || '_' || v_id;

            IF v_column_tab.EXISTS (v_index)
            THEN
               v_row.col_no_1 := v_column_tab (v_index).col_no;
               v_row.col_name_1 := v_column_tab (v_index).col_name;
               v_row.aging_value_1 :=
                                  NVL (v_column_tab (v_index).aging_value, 0);
               v_index := v_index + 1;
            END IF;

            IF v_column_tab.EXISTS (v_index)
            THEN
               v_row.col_no_2 := v_column_tab (v_index).col_no;
               v_row.col_name_2 := v_column_tab (v_index).col_name;
               v_row.aging_value_2 :=
                                  NVL (v_column_tab (v_index).aging_value, 0);
               v_index := v_index + 1;
            END IF;

            IF v_column_tab.EXISTS (v_index)
            THEN
               v_row.col_no_3 := v_column_tab (v_index).col_no;
               v_row.col_name_3 := v_column_tab (v_index).col_name;
               v_row.aging_value_3 :=
                                  NVL (v_column_tab (v_index).aging_value, 0);
               v_index := v_index + 1;
            END IF;

            IF v_column_tab.EXISTS (v_index)
            THEN
               v_row.col_no_4 := v_column_tab (v_index).col_no;
               v_row.col_name_4 := v_column_tab (v_index).col_name;
               v_row.aging_value_4 :=
                                  NVL (v_column_tab (v_index).aging_value, 0);
               v_index := v_index + 1;
            END IF;

            FOR prem IN (SELECT   a.iss_cd, SUM (a.gross_prem_amt) prem_amt
                             FROM giac_aging_prem_paid_ext a,
                                  giis_issource b,
                                  giis_intermediary c,
                                  giis_line d,
                                  giis_report_aging e
                            WHERE a.iss_cd = b.iss_cd
                              AND a.iss_cd = NVL (iss.iss_cd, a.iss_cd)
                              AND a.user_id = NVL (p_user_id, a.user_id)
                              AND a.intm_no = c.intm_no
                              AND a.line_cd = d.line_cd
                              AND e.report_id = 'GIACR328'
                              AND a.age BETWEEN e.min_days AND e.max_days
                              AND a.eff_date BETWEEN p_from_date AND p_to_date
                         GROUP BY a.iss_cd
                         ORDER BY a.iss_cd)
            LOOP
               v_row.prem_amt := NVL (prem.prem_amt, 0);
            END LOOP;

            v_row.cf_company_add := giacp.v ('COMPANY_ADDRESS');
            v_row.cf_company_name := giacp.v ('COMPANY_NAME');
            v_row.cf_title :=
                  'Cash Receipts for the Period of '
               || INITCAP (TO_CHAR (p_from_date, 'fmMonth DD, YYYY'))
               || ' to '
               || INITCAP (TO_CHAR (p_to_date, 'fmMonth DD, YYYY'));
            v_row.v_flag := 'Y';
            PIPE ROW (v_row);
            EXIT WHEN v_index > v_column_tab.COUNT;
         END LOOP;
      END LOOP;

      IF v_flag = FALSE
      THEN
         v_row.v_flag := 'N';
         v_row.cf_company_add := giacp.v ('COMPANY_ADDRESS');
         v_row.cf_company_name := giacp.v ('COMPANY_NAME');
         v_row.cf_title :=
               'Cash Receipts for the Period of '
            || INITCAP (TO_CHAR (p_from_date, 'fmMonth DD, YYYY'))
            || ' to '
            || INITCAP (TO_CHAR (p_to_date, 'fmMonth DD, YYYY'));
         PIPE ROW (v_row);
      END IF;
   END;

   FUNCTION get_aging_values (
      p_iss_cd_dummy   VARCHAR2,
      p_user_id        VARCHAR2,
      p_iss_cd         VARCHAR2,
      p_from_date      DATE,
      p_to_date        DATE,
      p_date           VARCHAR2,
      p_line_cd        VARCHAR2,
      p_intm_no        NUMBER,
      p_gross_prem     giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      p_policy_no      VARCHAR2
   )
      RETURN aging_values_tab PIPELINED
   IS
      TYPE t_tab IS TABLE OF aging_values_type
         INDEX BY PLS_INTEGER;

      v_row      aging_values_type;
      v_tab      t_tab;
      v_col_no   giis_report_aging.column_no%TYPE;
      v_index    NUMBER                             := 0;
   BEGIN
      FOR i IN (SELECT iss_cd, col_no_1, col_no_2, col_no_3, col_no_4
                  FROM TABLE (giacr328_pkg.get_giacr328_header (p_user_id,
                                                                p_iss_cd,
                                                                p_from_date,
                                                                p_to_date,
                                                                p_date
                                                               )
                             )
                 WHERE iss_cd_dummy = p_iss_cd_dummy)
      LOOP
         FOR c IN 1 .. 4
         LOOP
            IF c = 1
            THEN
               v_col_no := i.col_no_1;
            --==v_tab (v_index).col_no_1 := i.col_no_1;
            ELSIF c = 2
            THEN
               v_col_no := i.col_no_2;
            -- v_tab (v_index).col_no_2 := i.col_no_2;
            ELSIF c = 3
            THEN
               v_col_no := i.col_no_3;
            --v_tab (v_index).col_no_3 := i.col_no_3;
            ELSIF c = 4
            THEN
               v_col_no := i.col_no_4;
            -- v_tab (v_index).col_no_4 := i.col_no_4;
            END IF;

            IF v_col_no IS NULL
            THEN
               EXIT;
            END IF;

            v_index := 1;

            FOR d IN (SELECT   a.prem_amt prem_amt, a.iss_cd, a.intm_no,
                               a.line_cd, a.gross_prem_amt, a.policy_no
                          FROM giac_aging_prem_paid_ext a,
                               giis_issource b,
                               giis_intermediary c,
                               giis_line d,
                               giis_report_aging e
                         WHERE a.iss_cd = b.iss_cd
                           AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                           AND a.user_id = NVL (p_user_id, a.user_id)
                           AND a.intm_no = c.intm_no
                           AND a.line_cd = d.line_cd
                           AND e.report_id = 'GIACR328'
                           AND a.age BETWEEN e.min_days AND e.max_days
                           AND a.eff_date BETWEEN p_from_date AND p_to_date
                           AND e.column_no = NVL (v_col_no, e.column_no)
                           AND a.intm_no = NVL (p_intm_no, a.intm_no)
                           AND a.line_cd = NVL (p_line_cd, a.line_cd)
                           AND a.policy_no = NVL (p_policy_no, a.policy_no)
                           AND a.gross_prem_amt =
                                          NVL (p_gross_prem, a.gross_prem_amt)
                      ORDER BY a.iss_cd)
            LOOP
               IF c = 1
               THEN
                  v_tab (v_index).aging_value_1 := d.prem_amt;
               ELSIF c = 2
               THEN
                  v_tab (v_index).aging_value_2 := d.prem_amt;
               ELSIF c = 3
               THEN
                  v_tab (v_index).aging_value_3 := d.prem_amt;
               ELSIF c = 4
               THEN
                  v_tab (v_index).aging_value_4 := d.prem_amt;
               END IF;

               v_tab (v_index).iss_cd := i.iss_cd;
               --v_tab (v_index).iss_cd := i.iss_cd || '_' || v_index;
               v_tab (v_index).policy_no := d.policy_no;
               v_index := v_index + 1;
            END LOOP;
         END LOOP;
      END LOOP;

      v_index := v_tab.FIRST;

      WHILE v_index IS NOT NULL
      LOOP
         v_row := NULL;
         -- v_row.col_no_1 := v_tab (v_index).col_no_1;
         v_row.aging_value_1 := NVL (v_tab (v_index).aging_value_1, 0);
         -- v_row.col_no_2 := v_tab (v_index).col_no_2;
         v_row.aging_value_2 := NVL (v_tab (v_index).aging_value_2, 0);
         -- v_row.col_no_3 := v_tab (v_index).col_no_3;
         v_row.aging_value_3 := NVL (v_tab (v_index).aging_value_3, 0);
         --  v_row.col_no_4 := v_tab (v_index).col_no_4;
         v_row.aging_value_4 := NVL (v_tab (v_index).aging_value_4, 0);
         v_row.iss_cd := v_tab (v_index).iss_cd;
         v_row.policy_no := v_tab (v_index).policy_no;
         PIPE ROW (v_row);
         v_index := v_tab.NEXT (v_index);
      END LOOP;
   END;

   FUNCTION get_aging_values_total (
      p_iss_cd_dummy   VARCHAR2,
      p_user_id        VARCHAR2,
      p_iss_cd         VARCHAR2,
      p_from_date      DATE,
      p_to_date        DATE,
      p_date           VARCHAR2,
      p_intm_no        NUMBER,
      p_gross_prem     giac_aging_prem_paid_ext.gross_prem_amt%TYPE
   )
      RETURN aging_values_tab PIPELINED
   IS
      TYPE t_tab IS TABLE OF aging_values_type
         INDEX BY PLS_INTEGER;

      v_row      aging_values_type;
      v_tab      t_tab;
      v_col_no   giis_report_aging.column_no%TYPE;
      v_index    NUMBER                             := 0;
   BEGIN
      FOR i IN (SELECT iss_cd, col_no_1, col_no_2, col_no_3, col_no_4
                  FROM TABLE (giacr328_pkg.get_giacr328_header (p_user_id,
                                                                p_iss_cd,
                                                                p_from_date,
                                                                p_to_date,
                                                                p_date
                                                               )
                             )
                 WHERE iss_cd_dummy = p_iss_cd_dummy)
      LOOP
         FOR c IN 1 .. 4
         LOOP
            IF c = 1
            THEN
               v_col_no := i.col_no_1;
            ELSIF c = 2
            THEN
               v_col_no := i.col_no_2;
            ELSIF c = 3
            THEN
               v_col_no := i.col_no_3;
            ELSIF c = 4
            THEN
               v_col_no := i.col_no_4;
            END IF;

            IF v_col_no IS NULL
            THEN
               EXIT;
            END IF;

            v_index := 1;

            FOR d IN (SELECT DISTINCT SUM (a.prem_amt) prem_amt, a.iss_cd,
                                      a.intm_no, a.line_cd, a.gross_prem_amt
                                 FROM giac_aging_prem_paid_ext a,
                                      giis_issource b,
                                      giis_intermediary c,
                                      giis_line d,
                                      giis_report_aging e
                                WHERE a.iss_cd = b.iss_cd
                                  AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                                  AND a.user_id = NVL (p_user_id, a.user_id)
                                  AND a.intm_no = c.intm_no
                                  AND a.line_cd = d.line_cd
                                  AND e.report_id = 'GIACR328'
                                  AND a.age BETWEEN e.min_days AND e.max_days
                                  AND a.eff_date BETWEEN p_from_date AND p_to_date
                                  AND e.column_no = v_col_no
                                  AND a.intm_no = NVL (p_intm_no, a.intm_no)
                                  AND a.gross_prem_amt =
                                          NVL (p_gross_prem, a.gross_prem_amt)
                             GROUP BY a.iss_cd,
                                      a.intm_no,
                                      a.line_cd,
                                      a.gross_prem_amt
                             ORDER BY a.iss_cd)
            LOOP
               IF c = 1
               THEN
                  v_tab (v_index).aging_value_1 := d.prem_amt;
               ELSIF c = 2
               THEN
                  v_tab (v_index).aging_value_2 := d.prem_amt;
               ELSIF c = 3
               THEN
                  v_tab (v_index).aging_value_3 := d.prem_amt;
               ELSIF c = 4
               THEN
                  v_tab (v_index).aging_value_4 := d.prem_amt;
               END IF;

               v_tab (v_index).iss_cd := d.iss_cd;
               v_index := v_index + 1;
            END LOOP;
         END LOOP;
      END LOOP;

      v_index := v_tab.FIRST;

      WHILE v_index IS NOT NULL
      LOOP
         v_row := NULL;
         v_row.aging_value_1 := NVL (v_tab (v_index).aging_value_1, 0);
         v_row.aging_value_2 := NVL (v_tab (v_index).aging_value_2, 0);
         v_row.aging_value_3 := NVL (v_tab (v_index).aging_value_3, 0);
         v_row.aging_value_4 := NVL (v_tab (v_index).aging_value_4, 0);
         v_row.iss_cd := v_tab (v_index).iss_cd;
         PIPE ROW (v_row);
         v_index := v_tab.NEXT (v_index);
      END LOOP;
   END;
   
    -- start SR-3247 : shan 07.28.2015
    FUNCTION GET_COLUMN_HEADER
        RETURN column_header_tab PIPELINED
    AS
        rep     column_header_type;
        v_no_of_col_allowed     NUMBER := 4;
        v_dummy     NUMBER := 0;
        v_count     NUMBER := 0;
        v_title_tab     title_tab;
        v_index     NUMBER := 0;
        v_id        NUMBER := 0;
    BEGIN
        -- for column matrix
        v_title_tab := title_tab ();

        FOR t IN (SELECT column_no, column_title
                    FROM giis_report_aging
                   WHERE report_id = 'GIACR328'
                   ORDER BY column_no)
        LOOP
            v_index := v_index + 1;
            v_title_tab.EXTEND;
            v_title_tab (v_index).col_title := t.column_title;
            v_title_tab (v_index).col_no := t.column_no;
        END LOOP;

        v_index := 1;
        
        rep.no_of_dummy := 1;

          IF v_title_tab.COUNT > v_no_of_col_allowed
          THEN
             rep.no_of_dummy :=
                                  TRUNC (v_title_tab.COUNT / v_no_of_col_allowed);

             IF MOD (v_title_tab.COUNT, v_no_of_col_allowed) > 0
             THEN
                rep.no_of_dummy := rep.no_of_dummy + 1;
             END IF;
          END IF;
                                       
        LOOP
            v_id := v_id + 1;
            rep.dummy := v_id;            
            
            rep.col_title1 := NULL;
            rep.col_no1 := NULL;
            rep.col_title2 := NULL;
            rep.col_no2 := NULL;
            rep.col_title3 := NULL;
            rep.col_no3 := NULL;
            rep.col_title4 := NULL;
            rep.col_no4 := NULL;
            
             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title1 := v_title_tab (v_index).col_title;
                rep.col_no1 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title2 := v_title_tab (v_index).col_title;
                rep.col_no2 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title3 := v_title_tab (v_index).col_title;
                rep.col_no3 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             IF v_title_tab.EXISTS (v_index)
             THEN
                rep.col_title4 := v_title_tab (v_index).col_title;
                rep.col_no4 := v_title_tab (v_index).col_no;
                v_index := v_index + 1;
             END IF;

             PIPE ROW (rep);
             EXIT WHEN v_index > v_title_tab.COUNT;
        END LOOP;
         
    END GET_COLUMN_HEADER;
    
    
    FUNCTION get_report_details(
        p_user_id     VARCHAR2,
        p_iss_cd      VARCHAR2,
        p_from_date   DATE,
        p_to_date     DATE,
        p_date        VARCHAR2
    ) RETURN report_tab PIPELINED
    AS
        v_list      report_type;
        v_exist     VARCHAR2(1) := 'N';
    BEGIN
        v_list.cf_company_add := giacp.v ('COMPANY_ADDRESS');
        v_list.cf_company_name := giacp.v ('COMPANY_NAME');
        v_list.cf_title := 'Cash Receipts for the Period of '
                                || INITCAP (TO_CHAR (p_from_date, 'fmMonth DD, YYYY'))
                                || ' to '
                                || INITCAP (TO_CHAR (p_to_date, 'fmMonth DD, YYYY'));
                                
    
        FOR i IN ( SELECT  a.prem_amt,
                           a.intm_no,
                           a.line_cd, 
                           a.ref_intm_cd,
                           a.invoice_no,
                           a.policy_no,
                           a.iss_cd,
                           a.eff_date, 
                           a.due_date,
                           DECODE(P_DATE, 'Effectivity Date', A.EFF_DATE, 'Due Date', A.DUE_DATE) ext_by_date,  -- Deo [07.22.2013]
                           a.incept_date,
                           a.age, 
                           a.last_update, 
                           a.user_id,
                           a.gross_prem_amt, 
                           b.iss_name, 
                           c.intm_name, 
                           d.line_name, 
                           e.column_title, 
                           e.column_no,
                           SUM(a.prem_amt) prem
                      FROM giac_aging_prem_paid_ext a ,  
                           giis_issource b, 
                           giis_intermediary c, 
                           giis_line d, 
                           giis_report_aging e
                     WHERE a.iss_cd = b.iss_cd
                       AND a. iss_cd = NVL(p_iss_cd, a.iss_cd) 
                       AND a.user_id = NVL(p_user_id, a.user_id)
                       AND a.intm_no = c.intm_no
                       AND a.line_cd = d.line_cd
                       AND e.report_id = 'GIACR328'
                       AND a.age BETWEEN e.min_days AND e.max_days
                       AND DECODE(P_DATE, 'Effectivity Date', A.EFF_DATE, 'Due Date', A.DUE_DATE) BETWEEN P_FROM_DATE AND P_TO_DATE -- Deo [07.22.2013]
                     GROUP BY a.intm_no,
                               a.line_cd, 
                               a.ref_intm_cd,
                               a.invoice_no,
                               a.policy_no, 
                               a.iss_cd,
                               a.eff_date, 
                               a.due_date,
                               a.incept_date,
                               DECODE(P_DATE, 'Effectivity Date', A.EFF_DATE, 'Due Date', A.DUE_DATE),  -- Deo [07.22.2013]
                               a.prem_amt,
                               a.age, 
                               a.last_update, 
                               a.user_id,
                               a.gross_prem_amt,
                               b.iss_name, 
                               c.intm_name, 
                               d.line_name, 
                               e.column_title,
                               e.column_no
                     ORDER BY a.ISS_cd, c.intm_name, a.ref_intm_cd, d.line_name)
        LOOP
            v_exist := 'Y';
            v_list.prem_amt := NULL;
            v_list.intm_no := NULL;
            v_list.line_cd := NULL;
            v_list.ref_intm_cd := NULL;
            v_list.invoice_no := NULL;
            v_list.policy_no := NULL;
            v_list.iss_cd := NULL;
            v_list.eff_date := NULL;
            v_list.due_date := NULL;
            v_list.incept_date := NULL;
            v_list.ext_by_date := NULL;
            v_list.age := NULL;
            v_list.gross_prem_amt := NULL;
            v_list.iss_name := NULL;
            v_list.intm_name := NULL;
            v_list.line_name := NULL;
            v_list.prem := NULL;
            
            v_list.col_no_1 := NULL;
            v_list.col_no_2 := NULL;
            v_list.col_no_3 := NULL;
            v_list.col_no_4 := NULL;
            v_list.col_name_1 := NULL;
            v_list.col_name_2 := NULL;
            v_list.col_name_3 := NULL;
            v_list.col_name_4 := NULL;
                
            -- column header
            FOR j IN (SELECT *
                        FROM TABLE(giacr328_pkg.GET_COLUMN_HEADER))
            LOOP
                v_list.prem_amt := i.prem_amt;
                v_list.intm_no := i.intm_no;
                v_list.line_cd := i.line_cd;
                v_list.ref_intm_cd := i.ref_intm_cd;
                v_list.invoice_no := i.invoice_no;
                v_list.policy_no := i.policy_no;
                v_list.iss_cd := i.iss_cd;
                v_list.eff_date := i.eff_date;
                v_list.due_date := i.due_date;
                v_list.incept_date := i.incept_date;
                v_list.ext_by_date := i.ext_by_date;
                v_list.age := i.age;
                v_list.gross_prem_amt := i.gross_prem_amt;
                v_list.iss_name := i.iss_name;
                v_list.intm_name := i.intm_name;
                v_list.line_name := i.line_name;
                --v_list.column_title := i.column_title;
                v_list.prem := i.prem;
                
                v_list.iss_cd_dummy := i.iss_cd || '-' || j.dummy;
                v_list.col_no_1 := j.col_no1;
                v_list.col_no_2 := j.col_no2;
                v_list.col_no_3 := j.col_no3;
                v_list.col_no_4 := j.col_no4;
                v_list.col_name_1 := j.col_title1;
                v_list.col_name_2 := j.col_title2;
                v_list.col_name_3 := j.col_title3;
                v_list.col_name_4 := j.col_title4;
                
                IF j.col_no1 IS NOT NULL THEN
                    v_list.col_prem_amt_1 := 0;
                ELSE
                    v_list.col_prem_amt_1 := NULL;
                END IF;
                
                IF j.col_no2 IS NOT NULL THEN
                    v_list.col_prem_amt_2 := 0;
                ELSE
                    v_list.col_prem_amt_2 := NULL;
                END IF;
                
                IF j.col_no3 IS NOT NULL THEN
                    v_list.col_prem_amt_3 := 0;
                ELSE
                    v_list.col_prem_amt_3 := NULL;
                END IF;
                
                IF j.col_no4 IS NOT NULL THEN
                    v_list.col_prem_amt_4 := 0;
                ELSE
                    v_list.col_prem_amt_4 := NULL;
                END IF;
                    
                IF i.column_no = j.col_no1 THEN
                    v_list.col_prem_amt_1 := i.prem;
                ELSIF i.column_no = j.col_no2 THEN
                    v_list.col_prem_amt_2 := i.prem;
                ELSIF i.column_no = j.col_no3 THEN
                    v_list.col_prem_amt_3 := i.prem;
                ELSIF i.column_no = j.col_no4 THEN
                    v_list.col_prem_amt_4 := i.prem;
                END IF;                
                    
                PIPE ROW(v_list);
            END LOOP;
        END LOOP;
        
        IF v_exist = 'N' THEN
            PIPE ROW(v_list);
        END IF;
    END get_report_details;
    -- end SR-3247
    
END GIACR328_PKG;
/


