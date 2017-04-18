CREATE OR REPLACE PACKAGE BODY CPI.giclr208dr_pkg
AS
   FUNCTION get_giclr_208dr_report (
      p_aging_date     NUMBER,
      p_as_of_date     VARCHAR2,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR2,
      p_date_option    NUMBER,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_intm_break     NUMBER,
      p_iss_break      NUMBER,
      p_os_date        NUMBER,
      p_session_id     NUMBER
   )
      RETURN report_tab PIPELINED
   IS
      v_list    report_type;
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT   a.buss_source, a.iss_cd, a.line_cd, a.subline_cd,
                         a.claim_id, a.assd_no, a.claim_no, a.policy_no,
                         a.clm_file_date, a.loss_date, a.brdrx_record_id,
                         a.loss_cat_cd, a.intm_no,
                         SUM (  NVL (a.expense_reserve, 0)
                              - NVL (a.expenses_paid, 0)
                             ) outstanding_loss,
                         ROUND (  NVL (TO_DATE (p_cut_off_date, 'MM-dd-YYYY'),
                                       SYSDATE
                                      )
                                - DECODE (p_aging_date,
                                          1, a.loss_date,
                                          2, a.clm_file_date
                                         )
                               ) no_of_days
                    FROM gicl_res_brdrx_extr a
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND (NVL (a.expense_reserve, 0)
                          - NVL (a.expenses_paid, 0)
                         ) > 0
                GROUP BY a.buss_source,
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
                         a.claim_id,
                         a.brdrx_record_id
                ORDER BY a.intm_no,
                         a.iss_cd,
                         a.line_cd,
                         a.claim_no,
                         a.policy_no,
                         a.clm_file_date,
                         a.loss_date)
      LOOP
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         v_list.intm_no := i.intm_no;
         v_list.iss_cd := i.iss_cd;
         v_list.line_cd := i.line_cd;
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.clm_file_date := i.clm_file_date;
         v_list.loss_date := i.loss_date;
         v_list.claim_id := i.claim_id;
         v_list.brdrx_record_id := i.brdrx_record_id;
         v_list.no_of_days := i.no_of_days;

         BEGIN
            IF p_intm_break = 0
            THEN
               v_list.report_title :=
                   'OUTSTANDING LOSS EXPENSE REGISTER WITH AGING- PER BRANCH';
            ELSIF p_intm_break = 1
            THEN
               v_list.report_title :=
                  'OUTSTANDING LOSS EXPENSE REGISTER WITH AGING - PER INTERMEDIARY';
            END IF;
         END;

         BEGIN
            SELECT DECODE (p_os_date,
                           1, 'Loss Date',
                           2, 'Claim File Date',
                           3, 'Booking Month'
                          )
              INTO v_list.date_title
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.date_title := NULL;
         END;

         BEGIN
            IF p_date_option = 1
            THEN
               BEGIN
                  SELECT    'from '
                         || TO_CHAR (TO_DATE (p_from_date, 'mm-dd-yyyy'),
                                     'fmMonth DD, YYYY'
                                    )
                         || ' to '
                         || TO_CHAR (TO_DATE (p_to_date, 'mm-dd-yyyy'),
                                     'fmMonth DD, YYYY'
                                    )
                    INTO v_list.date_sw
                    FROM DUAL;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_list.date_sw := NULL;
               END;
            ELSIF p_date_option = 2
            THEN
               BEGIN
                  SELECT    'as of '
                         || TO_CHAR (TO_DATE (p_as_of_date, 'mm-dd-yyyy'),
                                     'fmMonth DD, YYYY'
                                    )
                    INTO v_list.date_sw
                    FROM DUAL;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_list.date_sw := NULL;
               END;
            END IF;
         END;

         BEGIN
            FOR p IN (SELECT intm_name
                        FROM giis_intermediary
                       WHERE intm_no = i.intm_no)
            LOOP
               v_list.intm_name := p.intm_name;
            END LOOP;
         END;

         BEGIN
            FOR b IN (SELECT iss_name
                        FROM giis_issource
                       WHERE iss_cd = i.iss_cd)
            LOOP
               v_list.iss_name := b.iss_name;
            END LOOP;
         END;

         BEGIN
            FOR l IN (SELECT line_name
                        FROM giis_line
                       WHERE line_cd = i.line_cd)
            LOOP
               v_list.line_name := l.line_name;
            END LOOP;
         END;

         BEGIN
            FOR f IN (SELECT pol_eff_date
                        FROM gicl_claims
                       WHERE claim_id = i.claim_id)
            LOOP
               v_list.eff_date := f.pol_eff_date;
            END LOOP;
         END;

         BEGIN
            FOR a IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_no = i.assd_no)
            LOOP
               v_list.assd_name := a.assd_name;
            END LOOP;
         END;

         BEGIN
            FOR c IN (SELECT loss_cat_des
                        FROM giis_loss_ctgry
                       WHERE line_cd = i.line_cd
                         AND loss_cat_cd = i.loss_cat_cd)
            LOOP
               v_list.loss_cat_des := c.loss_cat_des;
            END LOOP;
         END;

         v_exist := 'Y';
         v_list.exist := 'Y';
         PIPE ROW (v_list);
      END LOOP;

      IF v_exist = 'N'
      THEN
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');

         BEGIN
            IF p_intm_break = 0
            THEN
               v_list.report_title :=
                   'OUTSTANDING LOSS EXPENSE REGISTER WITH AGING- PER BRANCH';
            ELSIF p_intm_break = 1
            THEN
               v_list.report_title :=
                  'OUTSTANDING LOSS EXPENSE REGISTER WITH AGING - PER INTERMEDIARY';
            END IF;
         END;

         BEGIN
            SELECT DECODE (p_os_date,
                           1, 'Loss Date',
                           2, 'Claim File Date',
                           3, 'Booking Month'
                          )
              INTO v_list.date_title
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.date_title := NULL;
         END;

         BEGIN
            IF p_date_option = 1
            THEN
               BEGIN
                  SELECT    'from '
                         || TO_CHAR (TO_DATE (p_from_date, 'mm-dd-yyyy'),
                                     'fmMonth DD, YYYY'
                                    )
                         || ' to '
                         || TO_CHAR (TO_DATE (p_to_date, 'mm-dd-yyyy'),
                                     'fmMonth DD, YYYY'
                                    )
                    INTO v_list.date_sw
                    FROM DUAL;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_list.date_sw := NULL;
               END;
            ELSIF p_date_option = 2
            THEN
               BEGIN
                  SELECT    'as of '
                         || TO_CHAR (TO_DATE (p_as_of_date, 'mm-dd-yyyy'),
                                     'fmMonth DD, YYYY'
                                    )
                    INTO v_list.date_sw
                    FROM DUAL;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_list.date_sw := NULL;
               END;
            END IF;
         END;

         v_list.exist := 'N';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_giclr_208dr_report;

   FUNCTION get_giclr_208dr_coltitle
      RETURN giclr208dr_coltitle_tab PIPELINED
   IS
      v_list   giclr208dr_coltitle_type;
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
   END get_giclr_208dr_coltitle;

   FUNCTION get_giclr208dr_coldtls (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_brdrx_rec_id   NUMBER,
      p_no_of_days     NUMBER
   )
      RETURN giclr208dr_coldtls_tab PIPELINED
   IS
      v_list         giclr208dr_coldtls_type;
      v_no_of_days   NUMBER (38)             := 0;
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_list.column_no := i.column_no;

         IF p_no_of_days < 0
         THEN
            v_no_of_days := 1;
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
   END get_giclr208dr_coldtls;

   FUNCTION get_giclr208dr_line_total (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_line_cd        VARCHAR2,
      p_cut_off_date   VARCHAR2,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208dr_coldtls_tab PIPELINED
   IS
      v_list   giclr208dr_coldtls_type;
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
   END get_giclr208dr_line_total;

   FUNCTION get_giclr208dr_branch_total (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR2,
      p_aging_date     NUMBER,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208dr_coldtls_tab PIPELINED
   IS
      v_list   giclr208dr_coldtls_type;
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
               AND iss_cd = p_iss_cd
               AND (NVL (loss_reserve, 0) - NVL (losses_paid, 0)) > 0
               AND ROUND (  NVL (TO_DATE (p_cut_off_date, 'MM-dd-YYYY'),
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
                                                              'MM-dd-YYYY'
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
   END get_giclr208dr_branch_total;

   FUNCTION get_giclr208dr_intm_total (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR2,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2
   )
      RETURN giclr208dr_coldtls_tab PIPELINED
   IS
      v_list   giclr208dr_coldtls_type;
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
               AND ROUND (  NVL (TO_DATE (p_cut_off_date, 'MM-dd-YYYY'),
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
                                                              'MM-dd-YYYY'
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
   END get_giclr208dr_intm_total;

   FUNCTION get_giclr208dr_grand_total (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR2,
      p_aging_date     NUMBER
   )
      RETURN giclr208dr_coldtls_tab PIPELINED
   IS
      v_list   giclr208dr_coldtls_type;
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
               AND ROUND (  NVL (TO_DATE (p_cut_off_date, 'MM-dd-YYYY'),
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
                                                              'MM-dd-YYYY'
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
   END get_giclr208dr_grand_total;
END;
/


