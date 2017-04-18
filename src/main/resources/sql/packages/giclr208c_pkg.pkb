CREATE OR REPLACE PACKAGE BODY CPI.giclr208c_pkg
AS
   FUNCTION get_giclr208c_report (
      p_session_id      NUMBER,
      p_claim_id        NUMBER,
      p_intm_break      NUMBER,
      p_cut_off_date    VARCHAR,
      p_aging_date      NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr208c_tab PIPELINED
   IS
      v_list    giclr208c_type;
      v_exist   VARCHAR2 (1)   := 'N';
   BEGIN
      FOR i IN (SELECT   a.brdrx_record_id, a.claim_no, a.buss_source,
                         a.iss_cd, a.line_cd, a.subline_cd, a.claim_id,
                         a.assd_no, a.policy_no, a.clm_file_date,
                         a.loss_date, a.loss_cat_cd, a.intm_no,
                         SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)
                             ) outstanding_loss,
                         ROUND (  NVL (TO_DATE (p_cut_off_date, 'mm-dd-yyyy'),
                                       SYSDATE
                                      )
                                - DECODE (p_aging_date,
                                          1, a.loss_date,
                                          2, a.clm_file_date,
                                          a.loss_date
                                         )
                               ) no_of_days
                    FROM gicl_res_brdrx_extr a
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) >
                                                                             0
                GROUP BY a.brdrx_record_id,
                         a.claim_no,
                         a.buss_source,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd,
                         a.claim_id,
                         a.assd_no,
                         a.policy_no,
                         a.clm_file_date,
                         a.loss_date,
                         a.loss_cat_cd,
                         a.intm_no)
      LOOP
         v_list.intm_no := NVL (LTRIM (TO_CHAR (i.intm_no, '0009')), '');
         v_list.iss_cd := i.iss_cd;
         v_list.line_cd := i.line_cd;
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.clm_file_date := i.clm_file_date;
         v_list.loss_date := i.loss_date;
         v_list.no_of_days := i.no_of_days;
         v_list.claim_id := i.claim_id;
         v_list.brdrx_record_id := i.brdrx_record_id;

         BEGIN
            SELECT NVL (intm_name, ' ')
              INTO v_list.intm_name
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.intm_name := ' ';
         END;

         BEGIN
            SELECT NVL (iss_name, ' ')
              INTO v_list.iss_name
              FROM giis_issource
             WHERE iss_cd = i.iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.iss_name := ' ';
         END;

         BEGIN
            SELECT line_name
              INTO v_list.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.line_name := NULL;
         END;

         BEGIN
            SELECT pol_eff_date
              INTO v_list.pol_eff_date
              FROM gicl_claims
             WHERE claim_id = i.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.pol_eff_date := NULL;
         END;

         BEGIN
            SELECT assd_name
              INTO v_list.assd_name
              FROM giis_assured
             WHERE assd_no = i.assd_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.assd_name := NULL;
         END;

         BEGIN
            SELECT loss_cat_des
              INTO v_list.loss_cat_des
              FROM giis_loss_ctgry
             WHERE line_cd = i.line_cd AND loss_cat_cd = i.loss_cat_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.loss_cat_des := NULL;
         END;

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

         v_list.exist := 'N';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_giclr208c_report;

   FUNCTION get_giclr208c_col_title
      RETURN giclr208c_col_title_tab PIPELINED
   IS
      v_list   giclr208c_col_title_type;
   BEGIN
      FOR i IN (SELECT   column_title, column_no
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_list.column_title := i.column_title;
         v_list.column_no := i.column_no;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr208c_col_title;

   FUNCTION get_giclr208c_columns (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_brdrx_rec_id   NUMBER,
      p_no_of_days     NUMBER
   )
      RETURN giclr208c_colums_tab PIPELINED
   IS
      v_list         giclr208c_colums_type;
      v_no_of_days   NUMBER (38)           := 0;
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_list.column_no := i.column_no;

         IF p_no_of_days < 0
         THEN
            v_no_of_days := 1;                                        ---pjd0
         ELSE
            v_no_of_days := p_no_of_days;
         END IF;

         BEGIN
            SELECT NVL (SUM (NVL (loss_reserve, 0) - NVL (losses_paid, 0)), 0)
              INTO v_list.outstanding_loss
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = p_claim_id
               AND brdrx_record_id = p_brdrx_rec_id
               AND (NVL (loss_reserve, 0) - NVL (losses_paid, 0)) > 0
               AND v_no_of_days BETWEEN i.min_days AND i.max_days;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.outstanding_loss := 0;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giclr208c_columns;

   FUNCTION get_giclr208c_line_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_line_cd        VARCHAR2,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208c_colums_tab PIPELINED
   IS
      v_list   giclr208c_colums_type;
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_list.column_no := i.column_no;

         BEGIN
            SELECT NVL (SUM (NVL (loss_reserve, 0) - NVL (losses_paid, 0)), 0)
                                                             outstanding_loss
              INTO v_list.outstanding_loss
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               AND line_cd = p_line_cd
               AND NVL (intm_no, 0) =
                          NVL (TO_NUMBER (TRIM (p_intm_no)), NVL (intm_no, 0))
               AND NVL (iss_cd, '') = NVL (p_iss_cd, NVL (iss_cd, ''))
               AND (NVL (loss_reserve, 0) - NVL (losses_paid, 0)) > 0
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
   END get_giclr208c_line_tot;

   FUNCTION get_giclr208c_branch_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208c_colums_tab PIPELINED
   IS
      v_list   giclr208c_colums_type;
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_list.column_no := i.column_no;

         BEGIN
            SELECT NVL (SUM (NVL (loss_reserve, 0) - NVL (losses_paid, 0)), 0)
                                                             outstanding_loss
              INTO v_list.outstanding_loss
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               --AND line_cd = p_line_cd
               --AND NVL(intm_no, 0) = NVL(TO_NUMBER(TRIM(p_intm_no)), NVL(intm_no, 0))
               AND iss_cd = p_iss_cd
               AND (NVL (loss_reserve, 0) - NVL (losses_paid, 0)) > 0
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
   END get_giclr208c_branch_tot;

   FUNCTION get_giclr208c_intm_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2
   )
      RETURN giclr208c_colums_tab PIPELINED
   IS
      v_list   giclr208c_colums_type;
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_list.column_no := i.column_no;

         BEGIN
            SELECT NVL (SUM (NVL (loss_reserve, 0) - NVL (losses_paid, 0)), 0)
                                                             outstanding_loss
              INTO v_list.outstanding_loss
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               AND intm_no = TO_NUMBER (TRIM (p_intm_no))
               AND (NVL (loss_reserve, 0) - NVL (losses_paid, 0)) > 0
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
   END get_giclr208c_intm_tot;

   FUNCTION get_giclr208c_grand_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER
   )
      RETURN giclr208c_colums_tab PIPELINED
   IS
      v_list   giclr208c_colums_type;
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_list.column_no := i.column_no;

         BEGIN
            SELECT NVL (SUM (NVL (loss_reserve, 0) - NVL (losses_paid, 0)), 0)
                                                             outstanding_loss
              INTO v_list.outstanding_loss
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               AND (NVL (loss_reserve, 0) - NVL (losses_paid, 0)) > 0
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
   END get_giclr208c_grand_tot;
END;
/


