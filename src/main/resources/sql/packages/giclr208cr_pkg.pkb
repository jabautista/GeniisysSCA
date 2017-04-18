CREATE OR REPLACE PACKAGE BODY CPI.giclr208cr_pkg
AS
/*
    **  Created by    : Paul Joseph Diaz
    **  Date Created  : April 24, 2013
    **  Reference By  : GICLR208CR - Outstanding Loss Register With Aging
    */
   FUNCTION get_giclr208cr_details (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_date_option    NUMBER,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_as_of_date     VARCHAR2,
      p_os_date        NUMBER,
      p_aging_date     VARCHAR2,
      p_cut_off_date   VARCHAR2,
      p_intm_break     NUMBER,
      p_iss_break      NUMBER
   )
      RETURN giclr208cr_tab PIPELINED
   IS
      v_report         giclr208cr_type;
      v_param_date     VARCHAR2 (100);
      v_intm_name      giis_intermediary.intm_name%TYPE;
      v_iss_name       giis_issource.iss_name%TYPE;
      v_line_name      giis_line.line_name%TYPE;
      v_eff_date       gicl_claims.pol_eff_date%TYPE;
      v_assd_name      giis_assured.assd_name%TYPE;
      v_loss_cat_des   giis_loss_ctgry.loss_cat_des%TYPE;
      v_exist          VARCHAR2 (1)                        := 'N';
   BEGIN
      v_report.v_company_name := giisp.v ('COMPANY_NAME');
      v_report.v_company_address := giisp.v ('COMPANY_ADDRESS');

      BEGIN
         IF p_intm_break = 0
         THEN
            v_report.v_title :=
                           'OUTSTANDING LOSS REGISTER WITH AGING- PER BRANCH';
         ELSIF p_intm_break = 1
         THEN
            v_report.v_title :=
                    'OUTSTANDING LOSS REGISTER WITH AGING - PER INTERMEDIARY';
         END IF;
      END;

      BEGIN
         BEGIN
            SELECT DECODE (p_os_date,
                           1, 'Loss Date',
                           2, 'Claim File Date',
                           3, 'Booking Month'
                          )
              INTO v_param_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_param_date := NULL;
         END;

         v_report.v_param_date :=
                                 NVL ('(Based on ' || v_param_date || ')', '');
      END;

      BEGIN
         IF p_date_option = 1
         THEN
            BEGIN
               SELECT    'from '
                      || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                                  'fmMonth DD, YYYY'
                                 )
                      || ' to '
                      || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'),
                                  'fmMonth DD, YYYY'
                                 )
                 INTO v_report.v_date
                 FROM DUAL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_report.v_date := NULL;
            END;
         ELSIF p_date_option = 2
         THEN
            BEGIN
               SELECT    'as of '
                      || TO_CHAR (TO_DATE (p_as_of_date, 'MM-DD-YYYY'),
                                  'fmMonth DD, YYYY'
                                 )
                 INTO v_report.v_date
                 FROM DUAL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_report.v_date := NULL;
            END;
         END IF;
      END;

      FOR xtract_rec IN
         (SELECT   a.brdrx_record_id, a.claim_no, a.buss_source, a.iss_cd,
                   a.line_cd, a.subline_cd, a.claim_id, a.assd_no,
                   a.policy_no, a.clm_file_date, a.loss_date, a.loss_cat_cd,
                   a.intm_no,
                   SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)
                       ) outstanding_loss,
                   ROUND (  NVL (TO_DATE (TO_CHAR (p_cut_off_date),
                                          'mm-dd-yyyy'
                                         ),
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
               AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0
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
         v_report.intm_no := xtract_rec.intm_no;
         v_report.claim_no := xtract_rec.claim_no;
         v_report.policy_no := xtract_rec.policy_no;
         v_report.clm_file_date := xtract_rec.clm_file_date;
         v_report.loss_date := xtract_rec.loss_date;
         v_report.claim_id := xtract_rec.claim_id;
         v_report.iss_cd := xtract_rec.iss_cd;
         v_report.line_cd := xtract_rec.line_cd;
         v_report.no_of_days := xtract_rec.no_of_days;
         v_report.brdrx_record_id := xtract_rec.brdrx_record_id;

         BEGIN
            FOR i IN (SELECT intm_name
                        FROM giis_intermediary
                       WHERE intm_no = xtract_rec.intm_no)
            LOOP
               v_intm_name := i.intm_name;
            END LOOP;

            v_report.intm_name := v_intm_name;
         END;

         BEGIN
            FOR b IN (SELECT iss_name
                        FROM giis_issource
                       WHERE iss_cd = xtract_rec.iss_cd)
            LOOP
               v_iss_name := b.iss_name;
            END LOOP;

            v_report.iss_name := v_iss_name;
         END;

         BEGIN
            FOR l IN (SELECT line_name
                        FROM giis_line
                       WHERE line_cd = xtract_rec.line_cd)
            LOOP
               v_line_name := l.line_name;
            END LOOP;

            v_report.line_name := v_line_name;
         END;

         BEGIN
            FOR f IN (SELECT pol_eff_date
                        FROM gicl_claims
                       WHERE claim_id = xtract_rec.claim_id)
            LOOP
               v_eff_date := f.pol_eff_date;
            END LOOP;

            v_report.eff_date := v_eff_date;
         END;

         BEGIN
            FOR a IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_no = xtract_rec.assd_no)
            LOOP
               v_assd_name := a.assd_name;
            END LOOP;

            v_report.assd_name := v_assd_name;
         END;

         BEGIN
            FOR c IN (SELECT loss_cat_des
                        FROM giis_loss_ctgry
                       WHERE line_cd = xtract_rec.line_cd
                         AND loss_cat_cd = xtract_rec.loss_cat_cd)
            LOOP
               v_loss_cat_des := c.loss_cat_des;
            END LOOP;

            v_report.loss_cat_des := v_loss_cat_des;
         END;

         v_exist := 'Y';
         v_report.exist := 'Y';
         PIPE ROW (v_report);
      END LOOP;

      IF v_exist = 'N'
      THEN
         v_report.exist := 'N';
         PIPE ROW (v_report);
      END IF;
   END;

   FUNCTION get_giclr208cr_col_title
      RETURN giclr208cr_col_title_tab PIPELINED
   IS
      v_column   giclr208cr_col_title_type;
   BEGIN
      FOR i IN (SELECT   column_title, column_no
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_column.column_title := i.column_title;
         v_column.column_no := i.column_no;
         PIPE ROW (v_column);
      END LOOP;

      RETURN;
   END get_giclr208cr_col_title;

   FUNCTION get_giclr208cr_os_loss (
      p_session_id   NUMBER,
      p_claim_id     NUMBER,
      p_no_of_days   NUMBER
   )
      RETURN giclr208cr_os_loss_tab PIPELINED
   IS
      v_loss               giclr208cr_os_loss_type;
      v_no_of_days         NUMBER (38);
      v_outstanding_loss   NUMBER (16, 2);
      v_os_loss            NUMBER (16, 2);
      v_column_no          NUMBER (2);
   BEGIN
      FOR i IN (SELECT   column_no
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_loss.column_no := i.column_no;

         BEGIN
            SELECT NVL (SUM (NVL (loss_reserve, 0) - NVL (losses_paid, 0)), 0)
              INTO v_outstanding_loss
              FROM gicl_res_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               AND (NVL (loss_reserve, 0) - NVL (losses_paid, 0)) > 0;
         END;

         BEGIN
            v_os_loss := v_outstanding_loss;

            FOR i IN (SELECT SUM (recovered_amt) rec_amt
                        FROM gicl_rcvry_brdrx_extr
                       WHERE session_id = p_session_id
                         AND claim_id = p_claim_id
                         AND payee_type = 'L')
            LOOP
               IF i.rec_amt IS NOT NULL
               THEN
                  v_os_loss := v_os_loss - i.rec_amt;
               END IF;
            END LOOP;
         END;

         BEGIN
            IF p_no_of_days < 0
            THEN
               v_column_no := 1;
            ELSE
               FOR a_rec IN (SELECT column_no
                               FROM giis_report_aging
                              WHERE report_id = 'GICLR208C'
                                AND min_days <= p_no_of_days
                                AND max_days >= p_no_of_days)
               LOOP
                  v_column_no := a_rec.column_no;
               END LOOP;
            END IF;
         END;

         BEGIN
            IF v_column_no = i.column_no
            THEN
               v_loss.outstanding_loss := v_os_loss;
            ELSE
               v_loss.outstanding_loss := 0;
            END IF;
         END;

         PIPE ROW (v_loss);
      END LOOP;
   END get_giclr208cr_os_loss;

   FUNCTION get_giclr208cr_line_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_line_cd        VARCHAR2,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208cr_os_loss_tab PIPELINED
   IS
      v_loss      giclr208cr_os_loss_type;
      v_rec_amt   NUMBER (16, 2);
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_loss.column_no := i.column_no;

         BEGIN
            SELECT SUM (recovered_amt) rec_amt
              INTO v_rec_amt
              FROM gicl_rcvry_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               AND payee_type = 'L';
         END;

         BEGIN
            FOR rec IN
               (SELECT NVL (SUM (NVL (loss_reserve, 0) - NVL (losses_paid, 0)),
                            0
                           ) outstanding_loss
                  FROM gicl_res_brdrx_extr
                 WHERE session_id = p_session_id
                   AND claim_id = NVL (p_claim_id, claim_id)
                   AND line_cd = p_line_cd
                   AND NVL (intm_no, 0) =
                          NVL (TO_NUMBER (TRIM (p_intm_no)), NVL (intm_no, 0))
                   AND NVL (iss_cd, '') = NVL (p_iss_cd, NVL (iss_cd, ''))
                   AND (NVL (loss_reserve, 0) - NVL (losses_paid, 0)) > 0
                   AND ROUND (  NVL (TO_DATE (TO_CHAR (p_cut_off_date),
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
                          BETWEEN DECODE
                                    (i.min_days,
                                     0, ROUND
                                           (  NVL
                                                 (TO_DATE
                                                     (TO_CHAR (p_cut_off_date),
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
                              AND i.max_days)
            LOOP
               IF v_rec_amt IS NOT NULL
               THEN
                  v_loss.outstanding_loss := rec.outstanding_loss - v_rec_amt;
               ELSE
                  v_loss.outstanding_loss := rec.outstanding_loss;
               END IF;
            END LOOP;
         END;

         PIPE ROW (v_loss);
      END LOOP;

      RETURN;
   END get_giclr208cr_line_tot;

   FUNCTION get_giclr208cr_branch_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208cr_os_loss_tab PIPELINED
   IS
      v_loss      giclr208cr_os_loss_type;
      v_rec_amt   NUMBER (16, 2);
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_loss.column_no := i.column_no;

         BEGIN
            SELECT SUM (recovered_amt) rec_amt
              INTO v_rec_amt
              FROM gicl_rcvry_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               AND payee_type = 'L';
         END;

         BEGIN
            FOR rec IN
               (SELECT NVL (SUM (NVL (loss_reserve, 0) - NVL (losses_paid, 0)),
                            0
                           ) outstanding_loss
                  FROM gicl_res_brdrx_extr
                 WHERE session_id = p_session_id
                   AND claim_id = NVL (p_claim_id, claim_id)
                   AND iss_cd = p_iss_cd
                   AND (NVL (loss_reserve, 0) - NVL (losses_paid, 0)) > 0
                   AND ROUND (  NVL (TO_DATE (TO_CHAR (p_cut_off_date),
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
                          BETWEEN DECODE
                                    (i.min_days,
                                     0, ROUND
                                           (  NVL
                                                 (TO_DATE
                                                     (TO_CHAR (p_cut_off_date),
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
                              AND i.max_days)
            LOOP
               IF v_rec_amt IS NOT NULL
               THEN
                  v_loss.outstanding_loss := rec.outstanding_loss - v_rec_amt;
               ELSE
                  v_loss.outstanding_loss := rec.outstanding_loss;
               END IF;
            END LOOP;
         END;

         PIPE ROW (v_loss);
      END LOOP;

      RETURN;
   END get_giclr208cr_branch_tot;

   FUNCTION get_giclr208cr_intm_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2
   )
      RETURN giclr208cr_os_loss_tab PIPELINED
   IS
      v_loss      giclr208cr_os_loss_type;
      v_rec_amt   NUMBER (16, 2);
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_loss.column_no := i.column_no;

         BEGIN
            SELECT SUM (recovered_amt) rec_amt
              INTO v_rec_amt
              FROM gicl_rcvry_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               AND payee_type = 'L';
         END;

         BEGIN
            FOR rec IN
               (SELECT NVL (SUM (NVL (loss_reserve, 0) - NVL (losses_paid, 0)),
                            0
                           ) outstanding_loss
                  INTO v_loss.outstanding_loss
                  FROM gicl_res_brdrx_extr
                 WHERE session_id = p_session_id
                   AND claim_id = NVL (p_claim_id, claim_id)
                   AND intm_no = TO_NUMBER (TRIM (p_intm_no))
                   AND (NVL (loss_reserve, 0) - NVL (losses_paid, 0)) > 0
                   AND ROUND (  NVL (TO_DATE (TO_CHAR (p_cut_off_date),
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
                          BETWEEN DECODE
                                    (i.min_days,
                                     0, ROUND
                                           (  NVL
                                                 (TO_DATE
                                                     (TO_CHAR (p_cut_off_date),
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
                              AND i.max_days)
            LOOP
               IF v_rec_amt IS NOT NULL
               THEN
                  v_loss.outstanding_loss := rec.outstanding_loss - v_rec_amt;
               ELSE
                  v_loss.outstanding_loss := rec.outstanding_loss;
               END IF;
            END LOOP;
         END;

         PIPE ROW (v_loss);
      END LOOP;

      RETURN;
   END get_giclr208cr_intm_tot;

   FUNCTION get_giclr208cr_grand_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER
   )
      RETURN giclr208cr_os_loss_tab PIPELINED
   IS
      v_loss      giclr208cr_os_loss_type;
      v_rec_amt   NUMBER (16, 2);
   BEGIN
      FOR i IN (SELECT   column_no, min_days, max_days
                    FROM giis_report_aging
                   WHERE report_id = 'GICLR208C'
                ORDER BY column_no)
      LOOP
         v_loss.column_no := i.column_no;

         BEGIN
            SELECT SUM (recovered_amt) rec_amt
              INTO v_rec_amt
              FROM gicl_rcvry_brdrx_extr
             WHERE session_id = p_session_id
               AND claim_id = NVL (p_claim_id, claim_id)
               AND payee_type = 'L';
         END;

         BEGIN
            FOR rec IN
               (SELECT NVL (SUM (NVL (loss_reserve, 0) - NVL (losses_paid, 0)),
                            0
                           ) outstanding_loss
                  FROM gicl_res_brdrx_extr
                 WHERE session_id = p_session_id
                   AND claim_id = NVL (p_claim_id, claim_id)
                   AND (NVL (loss_reserve, 0) - NVL (losses_paid, 0)) > 0
                   AND ROUND (  NVL (TO_DATE (TO_CHAR (p_cut_off_date),
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
                          BETWEEN DECODE
                                    (i.min_days,
                                     0, ROUND
                                           (  NVL
                                                 (TO_DATE
                                                     (TO_CHAR (p_cut_off_date),
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
                              AND i.max_days)
            LOOP
               IF v_rec_amt IS NOT NULL
               THEN
                  v_loss.outstanding_loss := rec.outstanding_loss - v_rec_amt;
               ELSE
                  v_loss.outstanding_loss := rec.outstanding_loss;
               END IF;
            END LOOP;
         END;

         PIPE ROW (v_loss);
      END LOOP;

      RETURN;
   END get_giclr208cr_grand_tot;
END giclr208cr_pkg;
/


