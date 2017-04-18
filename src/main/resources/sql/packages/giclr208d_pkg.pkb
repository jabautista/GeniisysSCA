CREATE OR REPLACE PACKAGE BODY CPI.giclr208d_pkg
AS
   FUNCTION get_giclr208d_report (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_intm_break     NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_date_as_of     VARCHAR2,
      p_date_from      VARCHAR2,
      p_date_to        VARCHAR2
   )
      RETURN giclr208d_tab PIPELINED
   IS
      v_list    giclr208d_type;
      v_exist   VARCHAR2 (1)   := 'N';
   BEGIN
      FOR i IN (SELECT   a.session_id, a.brdrx_record_id, a.buss_source,
                         a.iss_cd, a.line_cd, a.subline_cd, a.claim_id,
                         a.assd_no, a.claim_no, a.policy_no, a.clm_file_date,
                         a.loss_date, a.loss_cat_cd, a.intm_no, b.intm_name,
                         c.iss_name, d.line_name, e.assd_name,
                         f.loss_cat_des, g.pol_eff_date,
                         SUM (  NVL (a.expense_reserve, 0)
                              - NVL (a.expenses_paid, 0)
                             ) outstanding_loss,
                         ROUND (  NVL (TO_DATE (p_cut_off_date, 'mm-dd-yyyy'),
                                       SYSDATE
                                      )
                                - DECODE (p_aging_date,
                                          1, a.loss_date,
                                          2, a.clm_file_date
                                         )
                               ) no_of_days
                    FROM gicl_res_brdrx_extr a,
                         giis_intermediary b,
                         giis_issource c,
                         giis_line d,
                         giis_assured e,
                         giis_loss_ctgry f,
                         gicl_claims g
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND (NVL (a.expense_reserve, 0)
                          - NVL (a.expenses_paid, 0)
                         ) > 0
                     AND a.intm_no = b.intm_no(+)
                     AND a.iss_cd = c.iss_cd(+)
                     AND a.line_cd = d.line_cd
                     AND a.assd_no = e.assd_no
                     AND a.loss_cat_cd = f.loss_cat_cd(+)
                     AND a.line_cd = f.line_cd(+)
                     AND a.claim_id = g.claim_id
                GROUP BY a.session_id,
                         a.brdrx_record_id,
                         a.buss_source,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd,
                         a.claim_id,
                         a.assd_no,
                         a.claim_no,
                         a.policy_no,
                         a.clm_file_date,
                         a.loss_date,
                         a.loss_cat_cd,
                         a.intm_no,
                         b.intm_name,
                         c.iss_name,
                         d.line_name,
                         e.assd_name,
                         f.loss_cat_des,
                         g.pol_eff_date
                ORDER BY a.intm_no,
                         a.iss_cd,
                         a.line_cd,
                         a.claim_no,
                         a.policy_no)
      LOOP
         v_list.session_id := i.session_id;
         v_list.intm_no := NVL (LTRIM (TO_CHAR (i.intm_no, '0009')), ' ');
         v_list.intm_name := NVL (i.intm_name, ' ');
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := NVL (i.iss_name, ' ');
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         v_list.claim_id := i.claim_id;
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.clm_file_date := i.clm_file_date;
         v_list.loss_date := i.loss_date;
         v_list.eff_date := i.pol_eff_date;
         v_list.assd_name := i.assd_name;
         v_list.loss_cat_cd := i.loss_cat_cd;
         v_list.loss_cat_des := i.loss_cat_des;
         v_list.brdrx_record_id := i.brdrx_record_id;
         v_list.no_of_days := i.no_of_days;

         IF v_list.date_as_of IS NULL AND p_date_as_of IS NOT NULL
         THEN
            v_list.date_as_of :=
                  TRIM (TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'),
                                 'Month')
                       )
               || TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF v_list.date_from IS NULL AND p_date_from IS NOT NULL
         THEN
            v_list.date_from :=
                  TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')
                       )
               || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.date_to :=
                  TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month'))
               || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF v_list.company_name IS NULL
         THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;

         v_exist := 'Y';
         v_list.exist := 'Y';
         PIPE ROW (v_list);
      END LOOP;

      IF v_exist = 'N'
      THEN
         IF v_list.date_from IS NULL AND p_date_from IS NOT NULL
         THEN
            v_list.date_from :=
                  TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')
                       )
               || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.date_to :=
                  TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month'))
               || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF v_list.company_name IS NULL
         THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;

         v_list.exist := 'N';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_giclr208d_report;

   FUNCTION get_column_title
      RETURN column_title_tab PIPELINED
   IS
      v_list   column_title_type;
   BEGIN
      FOR i IN (SELECT   column_title, column_no
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208D'
                ORDER BY column_no)
      LOOP
         v_list.column_title := i.column_title;
         v_list.column_no := i.column_no;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_column_title;

   FUNCTION get_giclr208d_columns (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_brdrx_rec_id   NUMBER,
      p_no_of_days     NUMBER
   )
      RETURN giclr208d_colums_tab PIPELINED
   IS
      v_list         giclr208d_colums_type;
      v_no_of_days   NUMBER (38)           := 0;
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208D'
                ORDER BY column_no)
      LOOP
         v_list.column_no := i.column_no;

         IF p_no_of_days < 0
         THEN
            v_no_of_days := 0;
         ELSE
            v_no_of_days := p_no_of_days;
         END IF;

         BEGIN
            SELECT NVL (SUM (NVL (expense_reserve, 0) - NVL (expenses_paid, 0)),
                        0
                       )
              INTO v_list.outstanding_loss
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = p_claim_id
               AND brdrx_record_id = p_brdrx_rec_id
               AND (NVL (expense_reserve, 0) - NVL (expenses_paid, 0)) > 0
               AND v_no_of_days BETWEEN i.min_days AND i.max_days;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.outstanding_loss := 0;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr208d_columns;

   FUNCTION get_giclr208d_line_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_line_cd        VARCHAR2,
      p_cut_off_date   VARCHAR2,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208d_colums_tab PIPELINED
   IS
      v_list   giclr208d_colums_type;
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208D'
                ORDER BY column_no)
      LOOP
         v_list.column_no := i.column_no;

         BEGIN
            SELECT NVL (SUM (NVL (expense_reserve, 0) - NVL (expenses_paid, 0)),
                        0
                       ) outstanding_loss
              INTO v_list.outstanding_loss
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               AND line_cd = p_line_cd
               AND NVL (intm_no, 0) =
                          NVL (TO_NUMBER (TRIM (p_intm_no)), NVL (intm_no, 0))
               AND NVL (iss_cd, '') = NVL (p_iss_cd, NVL (iss_cd, ''))
               AND (NVL (expense_reserve, 0) - NVL (expenses_paid, 0)) > 0
               AND ROUND (  NVL (TO_DATE (p_cut_off_date, 'mm-dd-yyyy'),
                                 SYSDATE
                                )
                          - DECODE (p_aging_date,
                                    1, loss_date,
                                    2, clm_file_date,
                                    loss_date
                                   )
                         )
                      BETWEEN DECODE (i.min_days,
                                      0, ROUND
                                              (  NVL
                                                    (TO_DATE (p_cut_off_date,
                                                              'mm-dd-yyyy'
                                                             ),
                                                     SYSDATE
                                                    )
                                               - DECODE (p_aging_date,
                                                         1, loss_date,
                                                         2, clm_file_date,
                                                         loss_date
                                                        )
                                              )
                                       - 1,
                                      i.min_days
                                     )
                          AND i.max_days;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr208d_line_tot;

   FUNCTION get_giclr208d_branch_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208d_colums_tab PIPELINED
   IS
      v_list   giclr208d_colums_type;
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208D'
                ORDER BY column_no)
      LOOP
         v_list.column_no := i.column_no;

         BEGIN
            SELECT NVL (SUM (NVL (expense_reserve, 0) - NVL (expenses_paid, 0)),
                        0
                       ) outstanding_loss
              INTO v_list.outstanding_loss
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               AND iss_cd = p_iss_cd
               AND (NVL (expense_reserve, 0) - NVL (expenses_paid, 0)) > 0
               AND ROUND (  NVL (TO_DATE (p_cut_off_date, 'mm-dd-yyyy'),
                                 SYSDATE
                                )
                          - DECODE (p_aging_date,
                                    1, loss_date,
                                    2, clm_file_date,
                                    loss_date
                                   )
                         )
                      BETWEEN DECODE (i.min_days,
                                      0, ROUND
                                              (  NVL
                                                    (TO_DATE (p_cut_off_date,
                                                              'mm-dd-yyyy'
                                                             ),
                                                     SYSDATE
                                                    )
                                               - DECODE (p_aging_date,
                                                         1, loss_date,
                                                         2, clm_file_date,
                                                         loss_date
                                                        )
                                              )
                                       - 1,
                                      i.min_days
                                     )
                          AND i.max_days;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr208d_branch_tot;

   FUNCTION get_giclr208d_intm_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2
   )
      RETURN giclr208d_colums_tab PIPELINED
   IS
      v_list   giclr208d_colums_type;
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208D'
                ORDER BY column_no)
      LOOP
         v_list.column_no := i.column_no;

         BEGIN
            SELECT NVL (SUM (NVL (expense_reserve, 0) - NVL (expenses_paid, 0)),
                        0
                       ) outstanding_loss
              INTO v_list.outstanding_loss
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               AND NVL (intm_no, 0) = NVL (TO_NUMBER (TRIM (p_intm_no)), 0)
               AND (NVL (expense_reserve, 0) - NVL (expenses_paid, 0)) > 0
               AND ROUND (  NVL (TO_DATE (p_cut_off_date, 'mm-dd-yyyy'),
                                 SYSDATE
                                )
                          - DECODE (p_aging_date,
                                    1, loss_date,
                                    2, clm_file_date,
                                    loss_date
                                   )
                         )
                      BETWEEN DECODE (i.min_days,
                                      0, ROUND
                                              (  NVL
                                                    (TO_DATE (p_cut_off_date,
                                                              'mm-dd-yyyy'
                                                             ),
                                                     SYSDATE
                                                    )
                                               - DECODE (p_aging_date,
                                                         1, loss_date,
                                                         2, clm_file_date,
                                                         loss_date
                                                        )
                                              )
                                       - 1,
                                      i.min_days
                                     )
                          AND i.max_days;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr208d_intm_tot;

   FUNCTION get_giclr208d_grand_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER
   )
      RETURN giclr208d_colums_tab PIPELINED
   IS
      v_list   giclr208d_colums_type;
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208D'
                ORDER BY column_no)
      LOOP
         v_list.column_no := i.column_no;

         BEGIN
            SELECT NVL (SUM (NVL (expense_reserve, 0) - NVL (expenses_paid, 0)),
                        0
                       ) outstanding_loss
              INTO v_list.outstanding_loss
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               AND (NVL (expense_reserve, 0) - NVL (expenses_paid, 0)) > 0
               AND ROUND (  NVL (TO_DATE (p_cut_off_date, 'mm-dd-yyyy'),
                                 SYSDATE
                                )
                          - DECODE (p_aging_date,
                                    1, loss_date,
                                    2, clm_file_date,
                                    loss_date
                                   )
                         )
                      BETWEEN DECODE (i.min_days,
                                      0, ROUND
                                              (  NVL
                                                    (TO_DATE (p_cut_off_date,
                                                              'mm-dd-yyyy'
                                                             ),
                                                     SYSDATE
                                                    )
                                               - DECODE (p_aging_date,
                                                         1, loss_date,
                                                         2, clm_file_date,
                                                         loss_date
                                                        )
                                              )
                                       - 1,
                                      i.min_days
                                     )
                          AND i.max_days;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr208d_grand_tot;
END;
/


