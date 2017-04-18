CREATE OR REPLACE PACKAGE BODY CPI.gipir902c_pkg
AS
   FUNCTION get_cols (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_user_id      VARCHAR2,
      p_date_from    VARCHAR2,
      p_date_to      VARCHAR2
   )
      RETURN col_tab PIPELINED
   IS
      v   col_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.peril_cd, c.peril_name
                     FROM (SELECT peril_cd,
                                     LTRIM
                                        (TO_CHAR (range_from,
                                                  '999,999,999,999,999'
                                                 )
                                        )
                                  || ' - '
                                  || LTRIM
                                        (DECODE
                                            ((LTRIM
                                                 (TO_CHAR
                                                        (range_to,
                                                         '999,999,999,999,999'
                                                        )
                                                 )
                                             ),
                                             '100,000,000,000,000', 'OVER',
                                             (TO_CHAR (range_to,
                                                       '999,999,999,999,999'
                                                      )
                                             )
                                            )
                                        ) AS "RANGES",
                                  policy_count, date_from, date_to,
                                  all_line_tag, peril_tsi, peril_prem
                             FROM gipi_risk_loss_profile
                            WHERE 1 = 1
                              AND line_cd = p_line_cd
                              AND NVL (subline_cd, '***') =
                                     NVL (p_subline_cd,
                                          NVL (subline_cd, '***')
                                         )
                              AND user_id = p_user_id
                              AND date_from =
                                           TO_DATE (p_date_from, 'mm-dd-yyyy')
                              AND date_to = TO_DATE (p_date_to, 'mm-dd-yyyy')
                              AND all_line_tag = 'P') a,
                          (SELECT b1.ranges, a1.peril_cd
                             FROM (SELECT b0.peril_cd,
                                             LTRIM
                                                (TO_CHAR
                                                        (c0.range_from,
                                                         '999,999,999,999,999'
                                                        )
                                                )
                                          || ' - '
                                          || LTRIM
                                                (DECODE
                                                    ((LTRIM
                                                         (TO_CHAR
                                                             (c0.range_to,
                                                              '999,999,999,999,999'
                                                             )
                                                         )
                                                     ),
                                                     '100,000,000,000,000', 'OVER',
                                                     (TO_CHAR
                                                         (c0.range_to,
                                                          '999,999,999,999,999'
                                                         )
                                                     )
                                                    )
                                                ) AS "RANGES"
                                     FROM gicl_claims a0,
                                          gicl_risk_loss_profile_ext3 b0,
                                          gipi_risk_loss_profile_dtl c0
                                    WHERE b0.claim_id = a0.claim_id
                                      AND c0.date_from =
                                             TO_DATE (p_date_from,
                                                      'mm-dd-yyyy'
                                                     )
                                      AND c0.date_to =
                                             TO_DATE (p_date_to, 'mm-dd-yyyy')
                                      AND c0.all_line_tag = 'P'
                                      AND c0.peril_cd = b0.peril_cd
                                      AND c0.line_cd = a0.line_cd
                                      AND c0.subline_cd = a0.subline_cd
                                      AND c0.iss_cd = a0.pol_iss_cd
                                      AND c0.issue_yy = a0.issue_yy
                                      AND c0.pol_seq_no = a0.pol_seq_no
                                      AND c0.renew_no = a0.renew_no) a1,
                                  (SELECT    LTRIM
                                                (TO_CHAR
                                                        (x.range_from,
                                                         '999,999,999,999,999'
                                                        )
                                                )
                                          || ' - '
                                          || LTRIM
                                                (DECODE
                                                    ((LTRIM
                                                         (TO_CHAR
                                                             (x.range_to,
                                                              '999,999,999,999,999'
                                                             )
                                                         )
                                                     ),
                                                     '100,000,000,000,000', 'OVER',
                                                     (TO_CHAR
                                                         (x.range_to,
                                                          '999,999,999,999,999'
                                                         )
                                                     )
                                                    )
                                                ) AS "RANGES",
                                          x.peril_cd
                                     FROM gipi_risk_loss_profile x
                                    WHERE 1 = 1
                                      AND x.line_cd = p_line_cd
                                      AND NVL (x.subline_cd, '@@@') =
                                             NVL (p_subline_cd,
                                                  NVL (x.subline_cd, '@@@')
                                                 )
                                      AND x.user_id = p_user_id
                                      AND x.date_from =
                                             TO_DATE (p_date_from,
                                                      'mm-dd-yyyy'
                                                     )
                                      AND x.date_to =
                                             TO_DATE (p_date_to, 'mm-dd-yyyy')
                                      AND x.all_line_tag = 'P'
                                      AND x.peril_cd IS NOT NULL) b1
                            WHERE 1 = 1
                              AND a1.peril_cd = b1.peril_cd
                              AND a1.ranges = b1.ranges) b,
                          (SELECT peril_cd, peril_type, peril_name
                             FROM giis_peril
                            WHERE line_cd = p_line_cd) c
                    WHERE a.peril_cd = b.peril_cd(+)
                      AND a.ranges = b.ranges(+)
                      AND a.peril_cd = c.peril_cd
                 ORDER BY peril_cd)
      LOOP
         v.peril_cd := i.peril_cd;
         v.peril_name := i.peril_name;
         PIPE ROW (v);
      END LOOP;
   END;

   FUNCTION get_main (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2
   )
      RETURN main_tab PIPELINED
   IS
      v             main_type;
      v_counter     NUMBER    := 1;
      v_row_count   NUMBER    := 1;
   BEGIN
      FOR i IN (SELECT peril_cd, peril_name
                  FROM TABLE (gipir902c_pkg.get_cols (p_line_cd,
                                                      p_subline_cd,
                                                      p_user_id,
                                                      p_date_from,
                                                      p_date_to
                                                     )
                             )
                UNION ALL
                SELECT 0, 'Grand Total'
                  FROM DUAL)
      LOOP
         v.date_from :=
               TRIM (TO_CHAR (TO_DATE (p_date_from, 'mm-dd-yyyy'), 'Month'))
            || ' '
            || TO_NUMBER (TO_CHAR (TO_DATE (p_date_from, 'mm-dd-yyyy'), 'dd'))
            || ', '
            || TO_CHAR (TO_DATE (p_date_from, 'mm-dd-yyyy'), 'YYYY');
         v.date_to :=
               TRIM (TO_CHAR (TO_DATE (p_date_to, 'mm-dd-yyyy'), 'Month'))
            || ' '
            || TO_NUMBER (TO_CHAR (TO_DATE (p_date_to, 'mm-dd-yyyy'), 'dd'))
            || ', '
            || TO_CHAR (TO_DATE (p_date_to, 'mm-dd-yyyy'), 'YYYY');
         v.loss_date_from :=
               TRIM (TO_CHAR (TO_DATE (p_loss_date_from, 'mm-dd-yyyy'),
                              'Month'
                             )
                    )
            || ' '
            || TO_NUMBER (TO_CHAR (TO_DATE (p_loss_date_from, 'mm-dd-yyyy'),
                                   'dd'
                                  )
                         )
            || ', '
            || TO_CHAR (TO_DATE (p_loss_date_from, 'mm-dd-yyyy'), 'YYYY');
         v.loss_date_to :=
               TRIM (TO_CHAR (TO_DATE (p_loss_date_to, 'mm-dd-yyyy'), 'Month'))
            || ' '
            || TO_NUMBER (TO_CHAR (TO_DATE (p_loss_date_to, 'mm-dd-yyyy'),
                                   'dd'
                                  )
                         )
            || ', '
            || TO_CHAR (TO_DATE (p_loss_date_to, 'mm-dd-yyyy'), 'YYYY');

         IF v_counter = 1
         THEN
            v.peril_cd_1 := i.peril_cd;
            v.peril_name_1 := i.peril_name;
            v.row_count := v_row_count;
            v.peril_cd_2 := NULL;
            v.peril_name_2 := NULL;
            v.peril_cd_3 := NULL;
            v.peril_name_3 := NULL;
         ELSIF v_counter = 2
         THEN
            v.peril_cd_2 := i.peril_cd;
            v.peril_name_2 := i.peril_name;
            v.row_count := v_row_count;
            v.peril_cd_3 := NULL;
            v.peril_name_3 := NULL;
         ELSE
            v.peril_cd_3 := i.peril_cd;
            v.peril_name_3 := i.peril_name;
            v.row_count := v_row_count;
            v_counter := 0;
            v_row_count := v_row_count + 1;
            PIPE ROW (v);
         END IF;

         v_counter := v_counter + 1;
      END LOOP;

      IF v_counter <> 0
      THEN
         PIPE ROW (v);
      END IF;
   END get_main;

   FUNCTION get_details (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2
   )
      RETURN detail_tab PIPELINED
   IS
      v                     detail_type;
      v_range_from_ranges   VARCHAR2 (1000);
      v_counter             NUMBER          := 1;
      v_row_count           NUMBER          := 1;
      v_tot_peril_tsi       NUMBER          := 0;
      v_tot_peril_prem      NUMBER          := 0;
      v_tot_loss            NUMBER          := 0;
      v_tot_policy_count    NUMBER          := 0;
      v_tot_claim_count     NUMBER          := 0;
   BEGIN
      FOR i IN
         (SELECT   a.peril_cd, a.range_from, a.ranges, a.policy_count,
                   a.peril_tsi, a.peril_prem, NVL (b.loss_amt, 0) loss,
                   DECODE (c.peril_type,
                           'B', a.peril_tsi,
                           0
                          ) basic_peril_tsi, a.claim_count
              FROM (SELECT   a.line_cd, a.subline_cd, a.user_id, a.peril_cd,
                             a.range_from, a.range_to, a.ranges,
                             SUM (a.policy_count) policy_count, a.date_from,
                             a.date_to, a.all_line_tag,
                             SUM (a.peril_tsi) peril_tsi,
                             SUM (a.peril_prem) peril_prem,
                             SUM (a.claim_count) claim_count
                        FROM (SELECT line_cd, subline_cd, user_id, peril_cd,
                                     range_from, range_to,
                                        LTRIM
                                           (TO_CHAR (range_from,
                                                     '999,999,999,999,999'
                                                    )
                                           )
                                     || ' - '
                                     || LTRIM
                                           (DECODE
                                               ((LTRIM
                                                    (TO_CHAR
                                                        (range_to,
                                                         '999,999,999,999,999'
                                                        )
                                                    )
                                                ),
                                                '100,000,000,000,000', 'OVER',
                                                (TO_CHAR
                                                        (range_to,
                                                         '999,999,999,999,999'
                                                        )
                                                )
                                               )
                                           ) AS "RANGES",
                                     policy_count, date_from, date_to,
                                     all_line_tag, peril_tsi, peril_prem,
                                     NVL (claim_count, 0) claim_count
                                FROM gipi_risk_loss_profile
                               WHERE 1 = 1
                                 AND line_cd = p_line_cd
                                 AND NVL (subline_cd, '***') =
                                        NVL (p_subline_cd,
                                             NVL (subline_cd, '***')
                                            )
                                 AND user_id = p_user_id
                                 AND date_from =
                                           TO_DATE (p_date_from, 'mm-dd-yyyy')
                                 AND date_to =
                                             TO_DATE (p_date_to, 'mm-dd-yyyy')
                                 AND all_line_tag = 'P') a
                    GROUP BY a.peril_cd,
                             a.line_cd,
                             a.subline_cd,
                             a.user_id,
                             a.range_from,
                             a.range_to,
                             a.ranges,
                             a.date_from,
                             a.date_to,
                             a.all_line_tag) a,
                   (SELECT      LTRIM
                                   (TO_CHAR (b1.range_from,
                                             '999,999,999,999,999'
                                            )
                                   )
                             || ' - '
                             || LTRIM
                                   (DECODE
                                       ((LTRIM (TO_CHAR (b1.range_to,
                                                         '999,999,999,999,999'
                                                        )
                                               )
                                        ),
                                        '100,000,000,000,000', 'OVER',
                                        (TO_CHAR (b1.range_to,
                                                  '999,999,999,999,999'
                                                 )
                                        )
                                       )
                                   ) AS "RANGES",
                             SUM (a1.loss_amt) loss_amt, a1.peril_cd
                        FROM (SELECT   SUM (b0.loss_amt) loss_amt,
                                       b0.peril_cd,
                                          LTRIM
                                             (TO_CHAR (c0.range_from,
                                                       '999,999,999,999,999'
                                                      )
                                             )
                                       || ' - '
                                       || LTRIM
                                             (DECODE
                                                 ((LTRIM
                                                      (TO_CHAR
                                                          (c0.range_to,
                                                           '999,999,999,999,999'
                                                          )
                                                      )
                                                  ),
                                                  '100,000,000,000,000', 'OVER',
                                                  (TO_CHAR
                                                        (c0.range_to,
                                                         '999,999,999,999,999'
                                                        )
                                                  )
                                                 )
                                             ) AS "RANGES"
                                  FROM gicl_claims a0,
                                       gicl_risk_loss_profile_ext3 b0,
                                       gipi_risk_loss_profile_dtl c0
                                 WHERE b0.claim_id = a0.claim_id
                                   AND c0.date_from =
                                           TO_DATE (p_date_from, 'mm-dd-yyyy')
                                   AND c0.date_to =
                                             TO_DATE (p_date_to, 'mm-dd-yyyy')
                                   AND c0.all_line_tag = 'P'
                                   AND c0.peril_cd = b0.peril_cd
                                   AND c0.line_cd = a0.line_cd
                                   AND c0.subline_cd = a0.subline_cd
                                   AND c0.iss_cd = a0.pol_iss_cd
                                   AND c0.issue_yy = a0.issue_yy
                                   AND c0.pol_seq_no = a0.pol_seq_no
                                   AND c0.renew_no = a0.renew_no
                              GROUP BY b0.peril_cd, c0.range_from,
                                       c0.range_to) a1,
                             (SELECT      LTRIM
                                             (TO_CHAR (x.range_from,
                                                       '999,999,999,999,999'
                                                      )
                                             )
                                       || ' - '
                                       || LTRIM
                                             (DECODE
                                                 ((LTRIM
                                                      (TO_CHAR
                                                          (x.range_to,
                                                           '999,999,999,999,999'
                                                          )
                                                      )
                                                  ),
                                                  '100,000,000,000,000', 'OVER',
                                                  (TO_CHAR
                                                        (x.range_to,
                                                         '999,999,999,999,999'
                                                        )
                                                  )
                                                 )
                                             ) AS "RANGES",
                                       x.range_from, x.range_to, x.peril_cd
                                  FROM gipi_risk_loss_profile x
                                 WHERE 1 = 1
                                   AND x.line_cd = p_line_cd
                                   AND NVL (x.subline_cd, '@@@') =
                                          NVL (p_subline_cd,
                                               NVL (x.subline_cd, '@@@')
                                              )
                                   AND x.user_id = p_user_id
                                   AND x.date_from =
                                           TO_DATE (p_date_from, 'mm-dd-yyyy')
                                   AND x.date_to =
                                             TO_DATE (p_date_to, 'mm-dd-yyyy')
                                   AND x.all_line_tag = 'P'
                                   AND x.peril_cd IS NOT NULL
                              GROUP BY x.range_from, x.range_to, x.peril_cd) b1
                       WHERE 1 = 1
                         AND a1.peril_cd = b1.peril_cd
                         AND a1.ranges = b1.ranges
                    GROUP BY a1.peril_cd, b1.range_from, b1.range_to) b,
                   (SELECT peril_cd, peril_type, peril_name
                      FROM giis_peril
                     WHERE line_cd = p_line_cd) c
             WHERE a.peril_cd = b.peril_cd(+)
               AND a.ranges = b.ranges(+)
               AND a.peril_cd = c.peril_cd
          ORDER BY range_from, ranges, peril_cd)
      LOOP
         IF v_range_from_ranges IS NULL
         THEN
            v_range_from_ranges := i.range_from || i.ranges;
         END IF;

         IF v_range_from_ranges <> i.range_from || i.ranges AND v_counter <> 3
         THEN
            v.row_count := v_row_count;

            IF v_counter = 1
            THEN
               v.peril_tsi_1 := v_tot_peril_tsi;
               v.peril_prem_1 := v_tot_peril_prem;
               v.loss_1 := v_tot_loss;
               v.policy_count_1 := v_tot_policy_count;
               v.claim_count_1 := v_tot_claim_count;
               v.peril_tsi_2 := NULL;
               v.peril_prem_2 := NULL;
               v.loss_2 := NULL;
               v.peril_tsi_3 := NULL;
               v.peril_prem_3 := NULL;
               v.loss_3 := NULL;
               v.policy_count_2 := NULL;
               v.claim_count_2 := NULL;
               v.policy_count_3 := NULL;
               v.claim_count_3 := NULL;
            ELSIF v_counter = 2
            THEN
               v.peril_tsi_2 := v_tot_peril_tsi;
               v.peril_prem_2 := v_tot_peril_prem;
               v.loss_2 := v_tot_loss;
               v.policy_count_2 := v_tot_policy_count;
               v.claim_count_2 := v_tot_claim_count;
               v.peril_tsi_3 := NULL;
               v.peril_prem_3 := NULL;
               v.loss_3 := NULL;
               v.policy_count_3 := NULL;
               v.claim_count_3 := NULL;
            ELSE
               v.peril_tsi_3 := v_tot_peril_tsi;
               v.peril_prem_3 := v_tot_peril_prem;
               v.loss_3 := v_tot_loss;
               v.policy_count_3 := v_tot_policy_count;
               v.claim_count_3 := v_tot_claim_count;
            END IF;

            PIPE ROW (v);
            v.policy_count_1 := NULL;
            v.policy_count_2 := NULL;
            v.policy_count_3 := NULL;
            v.claim_count_1 := NULL;
            v.claim_count_2 := NULL;
            v.claim_count_3 := NULL;
            v.peril_tsi_1 := NULL;
            v.peril_tsi_2 := NULL;
            v.peril_tsi_3 := NULL;
            v.peril_prem_1 := NULL;
            v.peril_prem_2 := NULL;
            v.peril_prem_3 := NULL;
            v.loss_1 := NULL;
            v.loss_2 := NULL;
            v.loss_3 := NULL;
            v_counter := 1;
            v_row_count := 1;
            v_tot_peril_tsi := 0;
            v_tot_peril_prem := 0;
            v_tot_loss := 0;
            v_tot_policy_count := 0;
            v_tot_claim_count := 0;
         END IF;

         v_range_from_ranges := i.range_from || i.ranges;
         v.range_from := i.range_from;
         v.ranges := i.ranges;

         IF v_counter = 1
         THEN
            v.peril_tsi_1 := i.peril_tsi;
            v.peril_prem_1 := i.peril_prem;
            v.policy_count_1 := i.policy_count;
            v.claim_count_1 := i.claim_count;
            v.row_count := v_row_count;
            v.loss_1 := i.loss;
            v.policy_count_2 := NULL;
            v.policy_count_3 := NULL;
            v.claim_count_2 := NULL;
            v.claim_count_3 := NULL;
            v.peril_tsi_2 := NULL;
            v.peril_tsi_3 := NULL;
            v.peril_prem_2 := NULL;
            v.peril_prem_3 := NULL;
            v.loss_2 := NULL;
            v.loss_3 := NULL;
         ELSIF v_counter = 2
         THEN
            v.peril_tsi_2 := i.peril_tsi;
            v.peril_prem_2 := i.peril_prem;
            v.policy_count_2 := i.policy_count;
            v.claim_count_2 := i.claim_count;
            v.loss_2 := i.loss;
            v.policy_count_3 := NULL;
            v.claim_count_3 := NULL;
            v.row_count := v_row_count;
            v.peril_tsi_3 := NULL;
            v.peril_prem_3 := NULL;
            v.loss_3 := NULL;
         ELSE
            v.peril_tsi_3 := i.peril_tsi;
            v.policy_count_3 := i.policy_count;
            v.claim_count_3 := i.claim_count;
            v.peril_prem_3 := i.peril_prem;
            v.loss_3 := i.loss;
            v.row_count := v_row_count;
            v_counter := 0;
            v_row_count := v_row_count + 1;
            PIPE ROW (v);
         END IF;

         v_tot_peril_tsi := v_tot_peril_tsi + i.peril_tsi;
         v_tot_peril_prem := v_tot_peril_prem + i.peril_prem;
         v_tot_loss := v_tot_loss + i.loss;
         v_tot_policy_count := v_tot_policy_count + i.policy_count;
         v_tot_claim_count := v_tot_claim_count + i.claim_count;
         v_counter := v_counter + 1;
      END LOOP;

      v.row_count := v_row_count;

      IF v_counter = 1
      THEN
         v.peril_tsi_1 := v_tot_peril_tsi;
         v.peril_prem_1 := v_tot_peril_prem;
         v.loss_1 := v_tot_loss;
         v.policy_count_1 := v_tot_policy_count;
         v.claim_count_1 := v_tot_claim_count;
         v.peril_tsi_2 := NULL;
         v.peril_prem_2 := NULL;
         v.loss_2 := NULL;
         v.peril_tsi_3 := NULL;
         v.peril_prem_3 := NULL;
         v.loss_3 := NULL;
         v.policy_count_2 := NULL;
         v.claim_count_2 := NULL;
         v.policy_count_3 := NULL;
         v.claim_count_3 := NULL;
      ELSIF v_counter = 2
      THEN
         v.peril_tsi_2 := v_tot_peril_tsi;
         v.peril_prem_2 := v_tot_peril_prem;
         v.loss_2 := v_tot_loss;
         v.policy_count_2 := v_tot_policy_count;
         v.claim_count_2 := v_tot_claim_count;
         v.peril_tsi_3 := NULL;
         v.peril_prem_3 := NULL;
         v.loss_3 := NULL;
         v.policy_count_3 := NULL;
         v.claim_count_3 := NULL;
      ELSE
         v.peril_tsi_3 := v_tot_peril_tsi;
         v.peril_prem_3 := v_tot_peril_prem;
         v.loss_3 := v_tot_loss;
         v.policy_count_3 := v_tot_policy_count;
         v.claim_count_3 := v_tot_claim_count;
      END IF;

      PIPE ROW (v);
   END get_details;
END;
/


