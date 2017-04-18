CREATE OR REPLACE PACKAGE BODY cpi.gipir948_pkg
AS
/*
** Created By:   Benjo Brito
** Date Created: 07.09.2015
** Description:  Redesign of GIPIR948, also merged reports GIPIR947 and GIPIR947B
**               UW-SPECS-2015-048 | GENQA AFPGEN-IMPLEM SR 4268, 4264, 4577
*/
   FUNCTION get_term (p_param_date VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_param_date = 'AD'
      THEN
         RETURN ('ACCOUNTING ENTRY DATE');
      ELSIF p_param_date = 'ED'
      THEN
         RETURN ('EFFECTIVITY DATE');
      ELSIF p_param_date = 'ID'
      THEN
         RETURN ('ISSUE DATE');
      ELSIF p_param_date = 'BD'
      THEN
         RETURN ('BOOKING DATE');
      ELSE
         RETURN (' ');
      END IF;
   END;

   FUNCTION get_gipir948_header (
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_param_date      VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN gipir948_header_tab PIPELINED
   IS
      v_rec   gipir948_header_type;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');

      IF p_all_line_tag = 'Y'
      THEN
         v_rec.title := 'RISK PROFILE PER LINE';
      ELSE
         v_rec.title := 'RISK PROFILE PER SUBLINE';
      END IF;

      v_rec.term :=
            get_term (p_param_date)
         || ' FROM '
         || TO_CHAR (TO_DATE (p_starting_date, 'MM-DD-YYYY'),
                     'fmMONTH DD, YYYY'
                    )
         || ' TO '
         || TO_CHAR (TO_DATE (p_ending_date, 'MM-DD-YYYY'),
                     'fmMONTH DD, YYYY');
      v_rec.print_page2 := 'N';
      v_rec.print_page3 := 'N';

      FOR i IN
         (SELECT header8, header15
            FROM TABLE (gipir948_pkg.get_gipir948_details (p_line_cd,
                                                           p_subline_cd,
                                                           p_starting_date,
                                                           p_ending_date,
                                                           p_all_line_tag,
                                                           p_by_tarf,
                                                           p_param_date,
                                                           p_user_id
                                                          )
                       ))
      LOOP
         IF i.header8 IS NOT NULL
         THEN
            v_rec.print_page2 := 'Y';
         END IF;

         IF i.header15 IS NOT NULL
         THEN
            v_rec.print_page3 := 'Y';
         END IF;
      END LOOP;

      PIPE ROW (v_rec);
   END;

   FUNCTION get_gipir948_details (
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_param_date      VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN gipir948_details_tab PIPELINED
   IS
      v_rec           gipir948_details_type;
      v_sec_net_ret   VARCHAR2 (30);
      v_total_tsi     NUMBER                := 0;
      v_total_prem    NUMBER                := 0;
   BEGIN
      FOR i IN (SELECT   range_from, range_to, policy_count, tarf_cd,
                         line_cd, subline_cd, trty_name, trty2_name,
                         trty3_name, trty4_name, trty5_name, trty6_name,
                         trty7_name, trty8_name, trty9_name, trty10_name,
                         net_retention_tsi, net_retention,
                         sec_net_retention_tsi, sec_net_retention_prem,
                         quota_share_tsi, quota_share, treaty_tsi, treaty_prem,
                         treaty2_tsi, treaty2_prem, treaty3_tsi,
                         treaty3_prem, treaty4_tsi, treaty4_prem,
                         treaty5_tsi, treaty5_prem, treaty6_tsi,
                         treaty6_prem, treaty7_tsi, treaty7_prem,
                         treaty8_tsi, treaty8_prem, treaty9_tsi,
                         treaty9_prem, treaty10_tsi, treaty10_prem,
                         facultative_tsi, facultative
                    FROM gipi_risk_profile
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                     AND NVL (subline_cd, '&') =
                                     NVL (p_subline_cd, NVL (subline_cd, '&'))
                     AND TRUNC (date_from) =
                               TRUNC (TO_DATE (p_starting_date, 'MM-DD-RRRR'))
                     AND TRUNC (date_to) =
                                 TRUNC (TO_DATE (p_ending_date, 'MM-DD-RRRR'))
                     AND user_id = p_user_id
                     AND all_line_tag = NVL (p_all_line_tag, 'N')
                     AND (   NVL (p_by_tarf, 'N') <> 'Y'
                          OR (NVL (p_by_tarf, 'N') = 'Y'
                              AND tarf_cd IS NOT NULL
                             )
                         )
                ORDER BY tarf_cd, line_cd, subline_cd, range_to)
      LOOP
         v_rec.range_from :=
                       TRIM (TO_CHAR (i.range_from, '99,999,999,999,990.00'));
         v_rec.range_to :=
                         TRIM (TO_CHAR (i.range_to, '99,999,999,999,990.00'));
         v_rec.policy_count := i.policy_count;
         v_rec.tarf_cd := i.tarf_cd;
         v_rec.tarf_desc := get_riskprofile_tariff_desc (i.tarf_cd);
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_cd || ' - ' || get_line_name (i.line_cd);
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name :=
                     i.subline_cd || ' - ' || get_subline_name (i.subline_cd);
         v_rec.header1 := '1st Retention';
         v_rec.header2 := NULL;
         v_rec.header3 := NULL;
         v_rec.header4 := NULL;
         v_rec.header5 := NULL;
         v_rec.header6 := NULL;
         v_rec.header7 := NULL;
         v_rec.header8 := NULL;
         v_rec.header9 := NULL;
         v_rec.header10 := NULL;
         v_rec.header11 := NULL;
         v_rec.header12 := NULL;
         v_rec.header13 := NULL;
         v_rec.header14 := NULL;
         v_rec.header15 := NULL;
         v_rec.tsi1 := i.net_retention_tsi;
         v_rec.tsi2 := NULL;
         v_rec.tsi3 := NULL;
         v_rec.tsi4 := NULL;
         v_rec.tsi5 := NULL;
         v_rec.tsi6 := NULL;
         v_rec.tsi7 := NULL;
         v_rec.tsi8 := NULL;
         v_rec.tsi9 := NULL;
         v_rec.tsi10 := NULL;
         v_rec.tsi11 := NULL;
         v_rec.tsi12 := NULL;
         v_rec.tsi13 := NULL;
         v_rec.tsi14 := NULL;
         v_rec.tsi15 := NULL;
         v_rec.prem1 := i.net_retention;
         v_rec.prem2 := NULL;
         v_rec.prem3 := NULL;
         v_rec.prem4 := NULL;
         v_rec.prem5 := NULL;
         v_rec.prem6 := NULL;
         v_rec.prem7 := NULL;
         v_rec.prem8 := NULL;
         v_rec.prem9 := NULL;
         v_rec.prem10 := NULL;
         v_rec.prem11 := NULL;
         v_rec.prem12 := NULL;
         v_rec.prem13 := NULL;
         v_rec.prem14 := NULL;
         v_rec.prem15 := NULL;
         v_total_tsi :=
              NVL (i.net_retention_tsi, 0)
            + NVL (i.sec_net_retention_tsi, 0)
            + NVL (i.treaty_tsi, 0)
            + NVL (i.treaty2_tsi, 0)
            + NVL (i.treaty3_tsi, 0)
            + NVL (i.treaty4_tsi, 0)
            + NVL (i.treaty5_tsi, 0)
            + NVL (i.treaty6_tsi, 0)
            + NVL (i.treaty7_tsi, 0)
            + NVL (i.treaty8_tsi, 0)
            + NVL (i.treaty9_tsi, 0)
            + NVL (i.treaty10_tsi, 0)
            + NVL (i.quota_share_tsi, 0)
            + NVL (i.facultative_tsi, 0);
         v_total_prem :=
              NVL (i.net_retention, 0)
            + NVL (i.sec_net_retention_prem, 0)
            + NVL (i.treaty_prem, 0)
            + NVL (i.treaty2_prem, 0)
            + NVL (i.treaty3_prem, 0)
            + NVL (i.treaty4_prem, 0)
            + NVL (i.treaty5_prem, 0)
            + NVL (i.treaty6_prem, 0)
            + NVL (i.treaty7_prem, 0)
            + NVL (i.treaty8_prem, 0)
            + NVL (i.treaty9_prem, 0)
            + NVL (i.treaty10_prem, 0)
            + NVL (i.quota_share, 0)
            + NVL (i.facultative, 0);

         BEGIN
            SELECT DECODE (NVL (SUM (  sec_net_retention_tsi
                                     + sec_net_retention_prem
                                    ),
                                0
                               ),
                           0, NULL,
                           '2nd Retention'
                          )
              INTO v_sec_net_ret
              FROM gipi_risk_profile
             WHERE line_cd = NVL (p_line_cd, line_cd)
               AND subline_cd = NVL (p_subline_cd, subline_cd)
               AND TRUNC (date_from) =
                               TRUNC (TO_DATE (p_starting_date, 'MM-DD-RRRR'))
               AND TRUNC (date_to) =
                                 TRUNC (TO_DATE (p_ending_date, 'MM-DD-RRRR'))
               AND user_id = p_user_id
               AND all_line_tag = 'N'
               AND (   NVL (p_by_tarf, 'N') <> 'Y'
                    OR (NVL (p_by_tarf, 'N') = 'Y' AND tarf_cd IS NOT NULL)
                   );
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_sec_net_ret := NULL;
         END;

         IF v_sec_net_ret IS NOT NULL
         THEN
            v_rec.header2 := v_sec_net_ret;
            v_rec.tsi2 := i.sec_net_retention_tsi;
            v_rec.prem2 := i.sec_net_retention_prem;
            v_rec.header3 := 'Quota Share';
            v_rec.tsi3 := i.quota_share_tsi;
            v_rec.prem3 := i.quota_share;

            IF i.trty_name IS NOT NULL
            THEN
               v_rec.header4 := i.trty_name;
               v_rec.tsi4 := i.treaty_tsi;
               v_rec.prem4 := i.treaty_prem;

               IF i.trty2_name IS NOT NULL
               THEN
                  v_rec.header5 := i.trty2_name;
                  v_rec.tsi5 := i.treaty2_tsi;
                  v_rec.prem5 := i.treaty2_prem;

                  IF i.trty3_name IS NOT NULL
                  THEN
                     v_rec.header6 := i.trty3_name;
                     v_rec.tsi6 := i.treaty3_tsi;
                     v_rec.prem6 := i.treaty3_prem;

                     IF i.trty4_name IS NOT NULL
                     THEN
                        v_rec.header7 := i.trty4_name;
                        v_rec.tsi7 := i.treaty4_tsi;
                        v_rec.prem7 := i.treaty4_prem;

                        IF i.trty5_name IS NOT NULL
                        THEN
                           v_rec.header8 := i.trty5_name;
                           v_rec.tsi8 := i.treaty5_tsi;
                           v_rec.prem8 := i.treaty5_prem;

                           IF i.trty6_name IS NOT NULL
                           THEN
                              v_rec.header9 := i.trty6_name;
                              v_rec.tsi9 := i.treaty6_tsi;
                              v_rec.prem9 := i.treaty6_prem;

                              IF i.trty7_name IS NOT NULL
                              THEN
                                 v_rec.header10 := i.trty7_name;
                                 v_rec.tsi10 := i.treaty7_tsi;
                                 v_rec.prem10 := i.treaty7_prem;

                                 IF i.trty8_name IS NOT NULL
                                 THEN
                                    v_rec.header11 := i.trty8_name;
                                    v_rec.tsi11 := i.treaty8_tsi;
                                    v_rec.prem11 := i.treaty8_prem;

                                    IF i.trty9_name IS NOT NULL
                                    THEN
                                       v_rec.header12 := i.trty9_name;
                                       v_rec.tsi12 := i.treaty9_tsi;
                                       v_rec.prem12 := i.treaty9_prem;

                                       IF i.trty10_name IS NOT NULL
                                       THEN
                                          v_rec.header13 := i.trty10_name;
                                          v_rec.tsi13 := i.treaty10_tsi;
                                          v_rec.prem13 := i.treaty10_prem;
                                          v_rec.header14 := 'FACULTATIVE';
                                          v_rec.tsi14 := i.facultative_tsi;
                                          v_rec.prem14 := i.facultative;
                                          v_rec.header15 := 'TOTAL';
                                          v_rec.tsi15 := v_total_tsi;
                                          v_rec.prem15 := v_total_prem;
                                       ELSE
                                          v_rec.header13 := 'FACULTATIVE';
                                          v_rec.tsi13 := i.facultative_tsi;
                                          v_rec.prem13 := i.facultative;
                                          v_rec.header14 := 'TOTAL';
                                          v_rec.tsi14 := v_total_tsi;
                                          v_rec.prem14 := v_total_prem;
                                       END IF;
                                    ELSE
                                       v_rec.header12 := 'FACULTATIVE';
                                       v_rec.tsi12 := i.facultative_tsi;
                                       v_rec.prem12 := i.facultative;
                                       v_rec.header13 := 'TOTAL';
                                       v_rec.tsi13 := v_total_tsi;
                                       v_rec.prem13 := v_total_prem;
                                    END IF;
                                 ELSE
                                    v_rec.header11 := 'FACULTATIVE';
                                    v_rec.tsi11 := i.facultative_tsi;
                                    v_rec.prem11 := i.facultative;
                                    v_rec.header12 := 'TOTAL';
                                    v_rec.tsi12 := v_total_tsi;
                                    v_rec.prem12 := v_total_prem;
                                 END IF;
                              ELSE
                                 v_rec.header10 := 'FACULTATIVE';
                                 v_rec.tsi10 := i.facultative_tsi;
                                 v_rec.prem10 := i.facultative;
                                 v_rec.header11 := 'TOTAL';
                                 v_rec.tsi11 := v_total_tsi;
                                 v_rec.prem11 := v_total_prem;
                              END IF;
                           ELSE
                              v_rec.header9 := 'FACULTATIVE';
                              v_rec.tsi9 := i.facultative_tsi;
                              v_rec.prem9 := i.facultative;
                              v_rec.header10 := 'TOTAL';
                              v_rec.tsi10 := v_total_tsi;
                              v_rec.prem10 := v_total_prem;
                           END IF;
                        ELSE
                           v_rec.header8 := 'FACULTATIVE';
                           v_rec.tsi8 := i.facultative_tsi;
                           v_rec.prem8 := i.facultative;
                           v_rec.header9 := 'TOTAL';
                           v_rec.tsi9 := v_total_tsi;
                           v_rec.prem9 := v_total_prem;
                        END IF;
                     ELSE
                        v_rec.header7 := 'FACULTATIVE';
                        v_rec.tsi7 := i.facultative_tsi;
                        v_rec.prem7 := i.facultative;
                        v_rec.header8 := 'TOTAL';
                        v_rec.tsi8 := v_total_tsi;
                        v_rec.prem8 := v_total_prem;
                     END IF;
                  ELSE
                     v_rec.header6 := 'FACULTATIVE';
                     v_rec.tsi6 := i.facultative_tsi;
                     v_rec.prem6 := i.facultative;
                     v_rec.header7 := 'TOTAL';
                     v_rec.tsi7 := v_total_tsi;
                     v_rec.prem7 := v_total_prem;
                  END IF;
               ELSE
                  v_rec.header5 := 'FACULTATIVE';
                  v_rec.tsi5 := i.facultative_tsi;
                  v_rec.prem5 := i.facultative;
                  v_rec.header6 := 'TOTAL';
                  v_rec.tsi6 := v_total_tsi;
                  v_rec.prem6 := v_total_prem;
               END IF;
            ELSE
               v_rec.header4 := 'FACULTATIVE';
               v_rec.tsi4 := i.facultative_tsi;
               v_rec.prem4 := i.facultative;
               v_rec.header5 := 'TOTAL';
               v_rec.tsi5 := v_total_tsi;
               v_rec.prem5 := v_total_prem;
            END IF;
         ELSE
            v_rec.header2 := 'Quota Share';
            v_rec.tsi2 := i.quota_share_tsi;
            v_rec.prem2 := i.quota_share;

            IF i.trty_name IS NOT NULL
            THEN
               v_rec.header3 := i.trty_name;
               v_rec.tsi3 := i.treaty_tsi;
               v_rec.prem3 := i.treaty_prem;

               IF i.trty2_name IS NOT NULL
               THEN
                  v_rec.header4 := i.trty2_name;
                  v_rec.tsi4 := i.treaty2_tsi;
                  v_rec.prem4 := i.treaty2_prem;

                  IF i.trty3_name IS NOT NULL
                  THEN
                     v_rec.header5 := i.trty3_name;
                     v_rec.tsi5 := i.treaty3_tsi;
                     v_rec.prem5 := i.treaty3_prem;

                     IF i.trty4_name IS NOT NULL
                     THEN
                        v_rec.header6 := i.trty4_name;
                        v_rec.tsi6 := i.treaty4_tsi;
                        v_rec.prem6 := i.treaty4_prem;

                        IF i.trty5_name IS NOT NULL
                        THEN
                           v_rec.header7 := i.trty5_name;
                           v_rec.tsi7 := i.treaty5_tsi;
                           v_rec.prem7 := i.treaty5_prem;

                           IF i.trty6_name IS NOT NULL
                           THEN
                              v_rec.header8 := i.trty6_name;
                              v_rec.tsi8 := i.treaty6_tsi;
                              v_rec.prem8 := i.treaty6_prem;

                              IF i.trty7_name IS NOT NULL
                              THEN
                                 v_rec.header9 := i.trty7_name;
                                 v_rec.tsi9 := i.treaty7_tsi;
                                 v_rec.prem9 := i.treaty7_prem;

                                 IF i.trty8_name IS NOT NULL
                                 THEN
                                    v_rec.header10 := i.trty8_name;
                                    v_rec.tsi10 := i.treaty8_tsi;
                                    v_rec.prem10 := i.treaty8_prem;

                                    IF i.trty9_name IS NOT NULL
                                    THEN
                                       v_rec.header11 := i.trty9_name;
                                       v_rec.tsi11 := i.treaty9_tsi;
                                       v_rec.prem11 := i.treaty9_prem;

                                       IF i.trty10_name IS NOT NULL
                                       THEN
                                          v_rec.header12 := i.trty10_name;
                                          v_rec.tsi12 := i.treaty10_tsi;
                                          v_rec.prem12 := i.treaty10_prem;
                                          v_rec.header13 := 'FACULTATIVE';
                                          v_rec.tsi13 := i.facultative_tsi;
                                          v_rec.prem13 := i.facultative;
                                          v_rec.header14 := 'TOTAL';
                                          v_rec.tsi14 := v_total_tsi;
                                          v_rec.prem14 := v_total_prem;
                                       ELSE
                                          v_rec.header12 := 'FACULTATIVE';
                                          v_rec.tsi12 := i.facultative_tsi;
                                          v_rec.prem12 := i.facultative;
                                          v_rec.header13 := 'TOTAL';
                                          v_rec.tsi13 := v_total_tsi;
                                          v_rec.prem13 := v_total_prem;
                                       END IF;
                                    ELSE
                                       v_rec.header11 := 'FACULTATIVE';
                                       v_rec.tsi11 := i.facultative_tsi;
                                       v_rec.prem11 := i.facultative;
                                       v_rec.header12 := 'TOTAL';
                                       v_rec.tsi12 := v_total_tsi;
                                       v_rec.prem12 := v_total_prem;
                                    END IF;
                                 ELSE
                                    v_rec.header10 := 'FACULTATIVE';
                                    v_rec.tsi10 := i.facultative_tsi;
                                    v_rec.prem10 := i.facultative;
                                    v_rec.header11 := 'TOTAL';
                                    v_rec.tsi11 := v_total_tsi;
                                    v_rec.prem11 := v_total_prem;
                                 END IF;
                              ELSE
                                 v_rec.header9 := 'FACULTATIVE';
                                 v_rec.tsi9 := i.facultative_tsi;
                                 v_rec.prem9 := i.facultative;
                                 v_rec.header10 := 'TOTAL';
                                 v_rec.tsi10 := v_total_tsi;
                                 v_rec.prem10 := v_total_prem;
                              END IF;
                           ELSE
                              v_rec.header8 := 'FACULTATIVE';
                              v_rec.tsi8 := i.facultative_tsi;
                              v_rec.prem8 := i.facultative;
                              v_rec.header9 := 'TOTAL';
                              v_rec.tsi9 := v_total_tsi;
                              v_rec.prem9 := v_total_prem;
                           END IF;
                        ELSE
                           v_rec.header7 := 'FACULTATIVE';
                           v_rec.tsi7 := i.facultative_tsi;
                           v_rec.prem7 := i.facultative;
                           v_rec.header8 := 'TOTAL';
                           v_rec.tsi8 := v_total_tsi;
                           v_rec.prem8 := v_total_prem;
                        END IF;
                     ELSE
                        v_rec.header6 := 'FACULTATIVE';
                        v_rec.tsi6 := i.facultative_tsi;
                        v_rec.prem6 := i.facultative;
                        v_rec.header7 := 'TOTAL';
                        v_rec.tsi7 := v_total_tsi;
                        v_rec.prem7 := v_total_prem;
                     END IF;
                  ELSE
                     v_rec.header5 := 'FACULTATIVE';
                     v_rec.tsi5 := i.facultative_tsi;
                     v_rec.prem5 := i.facultative;
                     v_rec.header6 := 'TOTAL';
                     v_rec.tsi6 := v_total_tsi;
                     v_rec.prem6 := v_total_prem;
                  END IF;
               ELSE
                  v_rec.header4 := 'FACULTATIVE';
                  v_rec.tsi4 := i.facultative_tsi;
                  v_rec.prem4 := i.facultative;
                  v_rec.header5 := 'TOTAL';
                  v_rec.tsi5 := v_total_tsi;
                  v_rec.prem5 := v_total_prem;
               END IF;
            ELSE
               v_rec.header3 := 'FACULTATIVE';
               v_rec.tsi3 := i.facultative_tsi;
               v_rec.prem3 := i.facultative;
               v_rec.header4 := 'TOTAL';
               v_rec.tsi4 := v_total_tsi;
               v_rec.prem4 := v_total_prem;
            END IF;
         END IF;

         PIPE ROW (v_rec);
      END LOOP;
   END;
END;
/

CREATE OR REPLACE PUBLIC SYNONYM gipir948_pkg FOR cpi.gipir948_pkg;