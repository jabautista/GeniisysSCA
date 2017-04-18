CREATE OR REPLACE PACKAGE BODY CPI.GIACR227_PKG
AS
   /*
   **  Created by   :  Michael John R. Malicad
   **  Date Created : 07.31.2013
   **  Reference By : GIACR227
   **  Description  :  Treaty Distribution - Detailed per Line / Subline
   */
   FUNCTION cf_company_name
      RETURN CHAR
   IS
      v_name   VARCHAR2 (100);
   BEGIN
      SELECT param_value_v
        INTO v_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_name);
   END;

   FUNCTION cf_company_address
      RETURN CHAR
   IS
      v_address   VARCHAR2 (100);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN UPPER (v_address);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_address := 'No Existing Address In GIIS_PARAMETERS';
         RETURN UPPER (v_address);
   END;

   FUNCTION get_giacr227_record (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_user_id          VARCHAR2
   )
      RETURN giacr227_record_tab PIPELINED
   AS
      v_rec    giacr227_record_type;
      v_flag   BOOLEAN              := FALSE;
   BEGIN
      v_rec.company_name := cf_company_name;
      v_rec.company_address := cf_company_address;
      v_rec.f_date :=
            TO_CHAR (TO_DATE (TO_CHAR (p_acct_ent_month, '99'), 'MM'),
                     'fmMonth'
                    )
         || ' '
         || TO_CHAR (TO_DATE (TO_CHAR (p_acct_ent_year, '9999'), 'YYYY'),
                     'YYYY'
                    );
      v_rec.v_flag := 'N';

         -- TO_CHAR (p_acct_ent_month, 'fmMonth ')
      -- || TO_CHAR (p_acct_ent_year, 'YYYY');
      FOR i IN (SELECT DISTINCT a.line_cd, c.line_name, a.subline_cd,
                                e.subline_name, d.peril_cd, g.peril_sname
                           FROM giuw_perilds_dtl d,
                                giuw_perilds f,
                                gipi_polbasic a,
                                giuw_pol_dist b,
                                giis_line c,
                                giis_subline e,
                                giis_peril g
                          WHERE c.line_cd = a.line_cd
                            AND d.peril_cd = f.peril_cd
                            AND d.dist_seq_no = f.dist_seq_no
                            AND e.subline_cd = a.subline_cd
                            AND e.line_cd = a.line_cd
                            AND d.dist_no = f.dist_no
                            AND f.dist_no = b.dist_no
                            AND g.peril_cd = d.peril_cd
                            AND d.peril_cd = f.peril_cd
                            AND g.line_cd = d.line_cd
                            AND check_user_per_iss_cd_acctg2 (NULL,
                                                              a.iss_cd,
                                                              'GIARPR001',
                                                              p_user_id
                                                             ) = 1
                            AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                            AND a.policy_id = b.policy_id
                            AND (   (    TO_CHAR (b.acct_ent_date, 'MON') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            ),
                                                    'MM'
                                                   ),
                                                'MON'
                                               )
                                     AND TO_CHAR (b.acct_ent_date, 'YYYY') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                                'YYYY'
                                               )
                                    )
                                 OR (    TO_CHAR (b.acct_neg_date, 'MON') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            ),
                                                    'MM'
                                                   ),
                                                'MON'
                                               )
                                     AND TO_CHAR (b.acct_neg_date, 'YYYY') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                                'YYYY'
                                               )
                                    )
                                )
                       ORDER BY c.line_name DESC, a.line_cd)
      LOOP
         v_flag := TRUE;
         v_rec.v_flag := 'Y';
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_name;
         v_rec.peril_cd := i.peril_cd;
         v_rec.peril_sname := i.peril_sname;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_flag = FALSE
      THEN
         PIPE ROW (v_rec);
      END IF;
   END get_giacr227_record;

   FUNCTION get_col_header_record (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_user_id          VARCHAR2
   )
      RETURN col_header_record_tab PIPELINED
   AS
      v_rec   col_header_record_type;
   BEGIN
      FOR i IN (SELECT DISTINCT LPAD (f.trty_name, 25, ' ') trty_name,
                                f.share_cd, f.line_cd
                           FROM giuw_perilds_dtl c,
                                giuw_perilds d,
                                giuw_pol_dist b,
                                gipi_polbasic a,
                                giis_dist_share f
                          WHERE f.line_cd = c.line_cd
                            AND f.share_cd = c.share_cd
                            AND c.peril_cd = d.peril_cd
                            AND check_user_per_iss_cd_acctg2 (NULL,
                                                              a.iss_cd,
                                                              'GIARPR001',
                                                              p_user_id
                                                             ) = 1
                            AND c.line_cd = d.line_cd
                            AND c.dist_seq_no = d.dist_seq_no
                            AND c.dist_no = d.dist_no
                            AND d.dist_no = b.dist_no
                            AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                            AND a.policy_id = b.policy_id
                            AND f.line_cd = NVL (p_line_cd, f.line_cd)
                            AND (   (    TO_CHAR (b.acct_ent_date, 'MON') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            ),
                                                    'MM'
                                                   ),
                                                'MON'
                                               )
                                     AND TO_CHAR (b.acct_ent_date, 'YYYY') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                                'YYYY'
                                               )
                                    )
                                 OR (    TO_CHAR (b.acct_neg_date, 'MON') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            ),
                                                    'MM'
                                                   ),
                                                'MON'
                                               )
                                     AND TO_CHAR (b.acct_neg_date, 'YYYY') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                                'YYYY'
                                               )
                                    )
                                )
                       ORDER BY f.share_cd)
      LOOP
         v_rec.trty_name := i.trty_name;
         v_rec.share_cd := i.share_cd;
         v_rec.line_cd := i.line_cd;
         PIPE ROW (v_rec);
      END LOOP;
   END get_col_header_record;

   FUNCTION get_subline_detail (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_peril_cd         NUMBER,
      p_dist_tsi         NUMBER,
      p_dist_prem        NUMBER,
      p_trty_name        VARCHAR2,
      p_user_id          VARCHAR2
   )
      RETURN subline_details_tab PIPELINED
   AS
      v_rec    subline_details_type;
      treaty   VARCHAR2 (50);
   BEGIN
      FOR y IN (SELECT DISTINCT LPAD (f.trty_name, 25, ' ') trty_name_orig,
                                f.share_cd, f.line_cd, f.trty_name
                           FROM giuw_perilds_dtl c,
                                giuw_perilds d,
                                giuw_pol_dist b,
                                gipi_polbasic a,
                                giis_dist_share f
                          WHERE f.line_cd = c.line_cd
                            AND f.share_cd = c.share_cd
                            AND c.peril_cd = d.peril_cd
                            AND check_user_per_iss_cd_acctg2 (NULL,
                                                              a.iss_cd,
                                                              'GIARPR001',
                                                              p_user_id
                                                             ) = 1
                            AND c.line_cd = d.line_cd
                            AND c.dist_seq_no = d.dist_seq_no
                            AND c.dist_no = d.dist_no
                            AND d.dist_no = b.dist_no
                            AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                            AND a.policy_id = b.policy_id
                            AND f.line_cd = p_line_cd
                            AND (   (    TO_CHAR (b.acct_ent_date, 'MON') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            ),
                                                    'MM'
                                                   ),
                                                'MON'
                                               )
                                     AND TO_CHAR (b.acct_ent_date, 'YYYY') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                                'YYYY'
                                               )
                                    )
                                 OR (    TO_CHAR (b.acct_neg_date, 'MON') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            ),
                                                    'MM'
                                                   ),
                                                'MON'
                                               )
                                     AND TO_CHAR (b.acct_neg_date, 'YYYY') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                                'YYYY'
                                               )
                                    )
                                )
                       ORDER BY f.share_cd)
      LOOP
         v_rec.d_trty_name := y.trty_name_orig;
         v_rec.d_share_cd := y.share_cd;
         v_rec.d_dist_tsi := NULL;
         v_rec.d_dist_prem := NULL;

         FOR x IN
            (SELECT DISTINCT a.subline_cd, h.subline_name, f.peril_sname,
                             a.line_cd, c.peril_cd
                        FROM giuw_perilds_dtl c,
                             giuw_perilds d,
                             giuw_pol_dist b,
                             gipi_polbasic a,
                             giis_peril f,
                             giis_subline h
                       WHERE f.peril_cd = c.peril_cd
                         AND f.line_cd = c.line_cd
                         AND h.subline_cd = a.subline_cd
                         AND check_user_per_iss_cd_acctg2 (NULL,
                                                           a.iss_cd,
                                                           'GIARPR001',
                                                           p_user_id
                                                          ) = 1
                         AND h.line_cd = a.line_cd
                         AND c.peril_cd = d.peril_cd
                         AND c.line_cd = d.line_cd
                         AND c.dist_seq_no = d.dist_seq_no
                         AND c.dist_no = d.dist_no
                         AND d.dist_no = b.dist_no
                         AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                         AND a.policy_id = b.policy_id
                         AND a.line_cd = p_line_cd
                         AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                         AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
                         AND (   (    TO_CHAR (b.acct_ent_date, 'MON') =
                                         TO_CHAR
                                            (TO_DATE
                                                  (TO_CHAR (p_acct_ent_month,
                                                            '99'
                                                           ),
                                                   'MM'
                                                  ),
                                             'MON'
                                            )
                                  AND TO_CHAR (b.acct_ent_date, 'YYYY') =
                                         TO_CHAR
                                            (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                             'YYYY'
                                            )
                                 )
                              OR (    TO_CHAR (b.acct_neg_date, 'MON') =
                                         TO_CHAR
                                            (TO_DATE
                                                  (TO_CHAR (p_acct_ent_month,
                                                            '99'
                                                           ),
                                                   'MM'
                                                  ),
                                             'MON'
                                            )
                                  AND TO_CHAR (b.acct_neg_date, 'YYYY') =
                                         TO_CHAR
                                            (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                             'YYYY'
                                            )
                                 )
                             )
                    ORDER BY a.subline_cd, c.peril_cd)
         LOOP
            v_rec.d_peril_cd := x.peril_cd;
            v_rec.d_line_cd := x.line_cd;
            v_rec.d_subline_cd := x.subline_cd;
            v_rec.d_dist_tsi := NULL;
            v_rec.d_dist_prem := NULL;
            
            FOR z IN
               (SELECT   a.line_cd, a.subline_cd,
                         LPAD (f.trty_name, 25, ' ') trty_name_orig,
                         SUM (NVL (c.dist_tsi, 0)) dist_tsi,
                         SUM (NVL (c.dist_prem, 0)) dist_prem, f.trty_name
                    FROM giuw_perilds_dtl c,
                         giuw_perilds d,
                         giuw_pol_dist b,
                         gipi_polbasic a,
                         giis_dist_share f
                   WHERE f.line_cd = c.line_cd
                     AND f.share_cd = c.share_cd
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       a.iss_cd,
                                                       'GIARPR001',
                                                       p_user_id
                                                      ) = 1
                     AND c.peril_cd = d.peril_cd
                     AND c.line_cd = d.line_cd
                     AND c.dist_seq_no = d.dist_seq_no
                     AND c.dist_no = d.dist_no
                     AND d.dist_no = b.dist_no
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.policy_id = b.policy_id
                     AND a.line_cd = x.line_cd
                     AND a.subline_cd = x.subline_cd
                     AND f.trty_name = y.trty_name
                     AND d.peril_cd = x.peril_cd
                     AND (   (    TO_CHAR (b.acct_ent_date, 'MON') =
                                     TO_CHAR
                                        (TO_DATE (TO_CHAR (p_acct_ent_month,
                                                           '99'
                                                          ),
                                                  'MM'
                                                 ),
                                         'MON'
                                        )
                              AND TO_CHAR (b.acct_ent_date, 'YYYY') =
                                     TO_CHAR
                                         (TO_DATE (TO_CHAR (p_acct_ent_year,
                                                            '9999'
                                                           ),
                                                   'YYYY'
                                                  ),
                                          'YYYY'
                                         )
                             )
                          OR (    TO_CHAR (b.acct_neg_date, 'MON') =
                                     TO_CHAR
                                        (TO_DATE (TO_CHAR (p_acct_ent_month,
                                                           '99'
                                                          ),
                                                  'MM'
                                                 ),
                                         'MON'
                                        )
                              AND TO_CHAR (b.acct_neg_date, 'YYYY') =
                                     TO_CHAR
                                         (TO_DATE (TO_CHAR (p_acct_ent_year,
                                                            '9999'
                                                           ),
                                                   'YYYY'
                                                  ),
                                          'YYYY'
                                         )
                             )
                         )
                GROUP BY a.line_cd, a.subline_cd, f.trty_name)
            LOOP
               v_rec.d_dist_tsi := z.dist_tsi;
               v_rec.d_dist_prem := z.dist_prem;
            END LOOP;

            PIPE ROW (v_rec);
         END LOOP;
      END LOOP;
   END get_subline_detail;

   FUNCTION get_line_details_record (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_user_id          VARCHAR2
   )
      RETURN line_details_record_tab PIPELINED
   AS
      v_rec   line_details_record_type;
   BEGIN
      FOR i IN (SELECT DISTINCT c.peril_cd, f.peril_sname, a.line_cd
                           FROM giuw_perilds_dtl c,
                                giuw_perilds d,
                                giuw_pol_dist b,
                                gipi_polbasic a,
                                giis_peril f
                          WHERE f.peril_cd = c.peril_cd
                            AND f.line_cd = c.line_cd
                            AND c.peril_cd = d.peril_cd
                            AND check_user_per_iss_cd_acctg2 (NULL,
                                                              a.iss_cd,
                                                              'GIARPR001',
                                                              p_user_id
                                                             ) = 1
                            AND c.line_cd = d.line_cd
                            AND c.dist_seq_no = d.dist_seq_no
                            AND c.dist_no = d.dist_no
                            AND d.dist_no = b.dist_no
                            AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                            AND a.policy_id = b.policy_id
                            AND a.line_cd = NVL (p_line_cd, a.line_cd)
                            AND (   (    TO_CHAR (b.acct_ent_date, 'MON') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            ),
                                                    'MM'
                                                   ),
                                                'MON'
                                               )
                                     AND TO_CHAR (b.acct_ent_date, 'YYYY') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                                'YYYY'
                                               )
                                    )
                                 OR (    TO_CHAR (b.acct_neg_date, 'MON') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            ),
                                                    'MM'
                                                   ),
                                                'MON'
                                               )
                                     AND TO_CHAR (b.acct_neg_date, 'YYYY') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                                'YYYY'
                                               )
                                    )
                                )
                       ORDER BY c.peril_cd)
      LOOP
         v_rec.peril_cd := i.peril_cd;
         v_rec.peril_sname := i.peril_sname;
         v_rec.line_cd := i.line_cd;
         PIPE ROW (v_rec);
      END LOOP;
   END get_line_details_record;

   FUNCTION populate_line_ttl_details (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_line_cd          VARCHAR2,
      p_peril_cd         NUMBER,
      p_dist_tsi         NUMBER,
      p_dist_prem        NUMBER,
      p_trty_name        VARCHAR2,
      p_user_id          VARCHAR2
   )
      RETURN line_ttl_details_tab PIPELINED
   AS
      v_rec   line_ttl_details_type;
   BEGIN
      FOR y IN (SELECT DISTINCT LPAD (f.trty_name, 25, ' ') trty_name_orig,
                                f.share_cd, f.line_cd, f.trty_name
                           FROM giuw_perilds_dtl c,
                                giuw_perilds d,
                                giuw_pol_dist b,
                                gipi_polbasic a,
                                giis_dist_share f
                          WHERE f.line_cd = c.line_cd
                            AND f.share_cd = c.share_cd
                            AND c.peril_cd = d.peril_cd
                            AND check_user_per_iss_cd_acctg2 (NULL,
                                                              a.iss_cd,
                                                              'GIARPR001',
                                                              p_user_id
                                                             ) = 1
                            AND c.line_cd = d.line_cd
                            AND c.dist_seq_no = d.dist_seq_no
                            AND c.dist_no = d.dist_no
                            AND d.dist_no = b.dist_no
                            AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                            AND a.policy_id = b.policy_id
                            AND a.line_cd = NVL (p_line_cd, a.line_cd)
                            AND (   (    TO_CHAR (b.acct_ent_date, 'MON') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            ),
                                                    'MM'
                                                   ),
                                                'MON'
                                               )
                                     AND TO_CHAR (b.acct_ent_date, 'YYYY') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                                'YYYY'
                                               )
                                    )
                                 OR (    TO_CHAR (b.acct_neg_date, 'MON') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            ),
                                                    'MM'
                                                   ),
                                                'MON'
                                               )
                                     AND TO_CHAR (b.acct_neg_date, 'YYYY') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                                'YYYY'
                                               )
                                    )
                                )
                       ORDER BY f.share_cd)
      LOOP
         v_rec.d_trty_name := y.trty_name_orig;
         v_rec.d_dist_prem := NULL;
         v_rec.d_dist_tsi := NULL;

         FOR z IN (SELECT   a.line_cd, d.peril_cd, f.share_cd,
                            LPAD (f.trty_name, 25, ' ') trty_name_orig,
                            SUM (NVL (c.dist_tsi, 0)) dist_tsi,
                            SUM (NVL (c.dist_prem, 0)) dist_prem,
                            f.trty_name
                       FROM giuw_perilds_dtl c,
                            giuw_perilds d,
                            giuw_pol_dist b,
                            gipi_polbasic a,
                            giis_dist_share f
                      WHERE f.line_cd = c.line_cd
                        AND f.share_cd = c.share_cd
                        AND check_user_per_iss_cd_acctg2 (NULL,
                                                          a.iss_cd,
                                                          'GIARPR001',
                                                          p_user_id
                                                         ) = 1
                        AND c.peril_cd = d.peril_cd
                        AND c.line_cd = d.line_cd
                        AND c.dist_seq_no = d.dist_seq_no
                        AND c.dist_no = d.dist_no
                        AND d.dist_no = b.dist_no
                        AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                        AND a.policy_id = b.policy_id
                        AND a.line_cd = NVL (p_line_cd, a.line_cd)
                        AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
                        AND f.trty_name = y.trty_name
                        AND f.share_cd = y.share_cd
                        AND TO_CHAR (b.acct_ent_date, 'MON') =
                               TO_CHAR (TO_DATE (TO_CHAR (p_acct_ent_month,
                                                          '99'
                                                         ),
                                                 'MM'
                                                ),
                                        'MON'
                                       )
                        AND TO_CHAR (b.acct_ent_date, 'YYYY') =
                               TO_CHAR (TO_DATE (TO_CHAR (p_acct_ent_year,
                                                          '9999'
                                                         ),
                                                 'YYYY'
                                                ),
                                        'YYYY'
                                       )
                   GROUP BY a.line_cd, d.peril_cd, f.share_cd, f.trty_name)
         LOOP
            v_rec.d_dist_tsi := z.dist_tsi;
            v_rec.d_dist_prem := z.dist_prem;
            v_rec.d_line_cd := z.line_cd;
            v_rec.d_peril_cd := z.peril_cd;
            v_rec.d_share_cd := z.share_cd;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;
   END populate_line_ttl_details;

   FUNCTION populate_matrix_linettl (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_line_cd          VARCHAR2,
      p_peril_cd         NUMBER,
      p_dist_tsi         NUMBER,
      p_dist_prem        NUMBER,
      p_trty_name        VARCHAR2,
      p_user_id          VARCHAR2
   )
      RETURN giacr227_linettl_tab PIPELINED
   AS
      v_rec   giacr227_linettl_type;
   BEGIN
      FOR b IN (SELECT DISTINCT LPAD (f.trty_name, 25, ' ') trty_name,
                                f.share_cd, f.line_cd, f.trty_name trty
                           FROM giuw_perilds_dtl c,
                                giuw_perilds d,
                                giuw_pol_dist b,
                                gipi_polbasic a,
                                giis_dist_share f
                          WHERE f.line_cd = c.line_cd
                            AND f.share_cd = c.share_cd
                            AND c.peril_cd = d.peril_cd
                            AND check_user_per_iss_cd_acctg2 (NULL,
                                                              a.iss_cd,
                                                              'GIARPR001',
                                                              p_user_id
                                                             ) = 1
                            AND c.line_cd = d.line_cd
                            AND c.dist_seq_no = d.dist_seq_no
                            AND c.dist_no = d.dist_no
                            AND d.dist_no = b.dist_no
                            AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                            AND a.policy_id = b.policy_id
                            AND f.line_cd = NVL (p_line_cd, f.line_cd)
                            AND (   (    TO_CHAR (b.acct_ent_date, 'MON') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            ),
                                                    'MM'
                                                   ),
                                                'MON'
                                               )
                                     AND TO_CHAR (b.acct_ent_date, 'YYYY') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                                'YYYY'
                                               )
                                    )
                                 OR (    TO_CHAR (b.acct_neg_date, 'MON') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            ),
                                                    'MM'
                                                   ),
                                                'MON'
                                               )
                                     AND TO_CHAR (b.acct_neg_date, 'YYYY') =
                                            TO_CHAR
                                               (TO_DATE
                                                   (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            ),
                                                    'YYYY'
                                                   ),
                                                'YYYY'
                                               )
                                    )
                                )
                       ORDER BY f.share_cd)
      LOOP
         FOR z IN (SELECT   a.line_cd, d.peril_cd, f.share_cd,
                            LPAD (f.trty_name, 25, ' ') trty_name,
                            SUM (NVL (c.dist_tsi, 0)) dist_tsi,
                            SUM (NVL (c.dist_prem, 0)) dist_prem
                       FROM giuw_perilds_dtl c,
                            giuw_perilds d,
                            giuw_pol_dist b,
                            gipi_polbasic a,
                            giis_dist_share f
                      WHERE f.line_cd = c.line_cd
                        AND check_user_per_iss_cd_acctg2 (NULL,
                                                          a.iss_cd,
                                                          'GIARPR001',
                                                          p_user_id
                                                         ) = 1
                        AND f.share_cd = c.share_cd
                        AND c.peril_cd = d.peril_cd
                        AND c.line_cd = d.line_cd
                        AND c.dist_seq_no = d.dist_seq_no
                        AND c.dist_no = d.dist_no
                        AND d.dist_no = b.dist_no
                        AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                        AND a.policy_id = b.policy_id
                        AND a.line_cd = b.line_cd
                        AND c.peril_cd = NVL (p_peril_cd, c.peril_cd)
                        AND trty_name = b.trty
                        AND TO_CHAR (b.acct_ent_date, 'MON') =
                               TO_CHAR (TO_DATE (TO_CHAR (p_acct_ent_month,
                                                          '99'
                                                         ),
                                                 'MM'
                                                ),
                                        'MON'
                                       )
                        AND TO_CHAR (b.acct_ent_date, 'YYYY') =
                               TO_CHAR (TO_DATE (TO_CHAR (p_acct_ent_year,
                                                          '9999'
                                                         ),
                                                 'YYYY'
                                                ),
                                        'YYYY'
                                       )
                   GROUP BY a.line_cd, d.peril_cd, f.share_cd, f.trty_name)
         LOOP
            v_rec.d_line_cd := z.line_cd;
            v_rec.d_peril_cd := z.peril_cd;
            v_rec.d_trty_name := z.trty_name;
            v_rec.d_dist_tsi := z.dist_tsi;
            v_rec.d_dist_prem := z.dist_prem;
            v_rec.d_share_cd := z.share_cd;
            PIPE ROW (v_rec);
         END LOOP;
      END LOOP;
   END populate_matrix_linettl;

   FUNCTION get_gl_acct_record (
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_acct_ent_month   NUMBER,
      p_acct_ent_year    NUMBER,
      p_user_id          VARCHAR2
   )
      RETURN gl_acct_record_tab PIPELINED
   AS
      v_rec    gl_acct_record_type;
      v_flag   BOOLEAN             := FALSE;
   BEGIN
      v_rec.v_flag := 'N';

      FOR i IN
         (SELECT      a.gl_acct_category
                   || '-'
                   || a.gl_control_acct
                   || '-'
                   || a.gl_sub_acct_1
                   || '-'
                   || a.gl_sub_acct_2
                   || '-'
                   || a.gl_sub_acct_3
                   || '-'
                   || a.gl_sub_acct_4
                   || '-'
                   || a.gl_sub_acct_5
                   || '-'
                   || a.gl_sub_acct_6
                   || '-'
                   || a.gl_sub_acct_7 gl_acct,
                   b.gl_acct_name, debit_amt, credit_amt, sl_cd,
                   gslt_sl_type_cd, gacc_tran_id
              FROM giac_acct_entries a, giac_chart_of_accts b
             WHERE b.gl_acct_id = a.gl_acct_id
               AND check_user_per_iss_cd_acctg2 (NULL,
                                                 a.gacc_gibr_branch_cd,
                                                 'GIARPR001',
                                                 p_user_id
                                                ) = 1
               AND a.gacc_tran_id IN (
                      SELECT DISTINCT gacc_tran_id
                                 FROM giac_treaty_cessions
                                WHERE branch_cd = NVL (p_iss_cd, branch_cd)
                                  AND cession_mm =
                                         TO_NUMBER (TO_CHAR (p_acct_ent_month,
                                                             '99'
                                                            )
                                                   )
                                  AND cession_year =
                                         TO_NUMBER (TO_CHAR (p_acct_ent_year,
                                                             '9999'
                                                            )
                                                   ))
          --ORDER BY 1, 5)
          ORDER BY gl_acct_name)
      LOOP
         v_flag := TRUE;
         v_rec.v_flag := 'Y';
         v_rec.gl_acct := i.gl_acct;
         v_rec.gl_acct_name := i.gl_acct_name;
         v_rec.debit_amt := i.debit_amt;
         v_rec.credit_amt := i.credit_amt;
         v_rec.sl_cd := i.sl_cd;
         v_rec.gslt_sl_type_cd := i.gslt_sl_type_cd;
         v_rec.gacc_tran_id := i.gacc_tran_id;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_flag = FALSE
      THEN
         PIPE ROW (v_rec);
      END IF;
   END get_gl_acct_record;
END GIACR227_PKG;
/


