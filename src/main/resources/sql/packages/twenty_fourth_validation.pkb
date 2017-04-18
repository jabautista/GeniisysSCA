CREATE OR REPLACE PACKAGE BODY CPI.twenty_fourth_validation
AS
   PROCEDURE extract_gross_premium (p_extract_mm NUMBER, p_extract_year NUMBER)
   IS
      v_paramdate     VARCHAR2 (10) := giacp.v ('24TH_METHOD_PARAMDATE');
      v_exclude_mn    VARCHAR2 (10)
                                := NVL (giacp.v ('EXCLUDE_MARINE_24TH'), 'N');
      v_mn            VARCHAR2 (10) := giisp.v ('LINE_CODE_MN');
      v_mm_year_mn1   VARCHAR2 (30);
      v_mm_year_mn2   VARCHAR2 (30);
      v_mm_year       VARCHAR2 (30);
      v_start_date    DATE
         := LAST_DAY (TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY'));

      CURSOR gross (
         p_mm_year       VARCHAR2,
         p_paramdate     VARCHAR2,
         p_year          NUMBER,
         p_mm            NUMBER,
         p_ext_mm        NUMBER,
         p_ext_year      NUMBER,
         p_exclude_mn    VARCHAR2,
         p_mn            VARCHAR2,
         p_mm_year_mn1   VARCHAR2,
         p_mm_year_mn2   VARCHAR2
      )
      IS
         SELECT b.policy_id, b.iss_cd, b.cred_branch, b.line_cd,
                get_policy_no (b.policy_id) policy_no,
                b.booking_mth booking_month, b.booking_year,
                TRUNC (b.eff_date) effectivity_date, b.acct_ent_date,
                a.prem_amt * a.currency_rt prem_amt, spld_date spoiled_date,
                spoiled_acct_ent_date, pol_flag
           FROM gipi_invoice a, gipi_polbasic b
          WHERE a.policy_id = b.policy_id
            AND DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
            AND (   a.acct_ent_date <=
                       LAST_DAY (TO_DATE (p_ext_mm || '-' || p_ext_year,
                                          'MM-YYYY'
                                         )
                                )
                 OR a.spoiled_acct_ent_date <=
                       LAST_DAY (TO_DATE (p_ext_mm || '-' || p_ext_year,
                                          'MM-YYYY'
                                         )
                                )
                )
            AND b.reg_policy_sw = 'Y'
            AND (   (p_exclude_mn = 'Y' AND b.line_cd <> p_mn)
                 OR (    p_exclude_mn = 'N'
                     AND (       b.line_cd = p_mn
                             AND (   (    p_paramdate = 'A'
                                      AND p_mm_year IN
                                               (p_mm_year_mn1, p_mm_year_mn2)
                                     )
                                  OR (p_paramdate = 'E')
                                 )
                          OR b.line_cd <> p_mn
                         )
                    )
                );
   BEGIN
      DELETE FROM gross_prem_ext;

      v_mm_year :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);
      v_mm_year_mn1 :=
            TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'MM'
                    )
         || '-'
         || TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'YYYY'
                    );
      v_mm_year_mn2 :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);

      FOR gross_rec IN gross (v_mm_year,
                              v_paramdate,
                              p_extract_year,
                              p_extract_mm,
                              p_extract_mm,
                              p_extract_year,
                              v_exclude_mn,
                              v_mn,
                              v_mm_year_mn1,
                              v_mm_year_mn2
                             )
      LOOP
         INSERT INTO gross_prem_ext
                     (policy_id, iss_cd,
                      cred_branch, line_cd,
                      policy_no, booking_month,
                      booking_year, effectivity_date,
                      acct_ent_date, prem_amt,
                      spoiled_date, spld_acct_ent_date,
                      pol_flag, extract_mm, extract_year
                     )
              VALUES (gross_rec.policy_id, gross_rec.iss_cd,
                      gross_rec.cred_branch, gross_rec.line_cd,
                      gross_rec.policy_no, gross_rec.booking_month,
                      gross_rec.booking_year, gross_rec.effectivity_date,
                      gross_rec.acct_ent_date, gross_rec.prem_amt,
                      gross_rec.spoiled_date, gross_rec.spoiled_acct_ent_date,
                      gross_rec.pol_flag, p_extract_mm, p_extract_year
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_ri_prem (p_extract_mm NUMBER, p_extract_year NUMBER)
   IS
      v_paramdate     VARCHAR2 (10) := giacp.v ('24TH_METHOD_PARAMDATE');
      v_exclude_mn    VARCHAR2 (10)
                                := NVL (giacp.v ('EXCLUDE_MARINE_24TH'), 'N');
      v_mn            VARCHAR2 (10) := giisp.v ('LINE_CODE_MN');
      v_mm_year_mn1   VARCHAR2 (30);
      v_mm_year_mn2   VARCHAR2 (30);
      v_mm_year       VARCHAR2 (30);
      v_start_date    DATE
         := LAST_DAY (TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY'));

      CURSOR ri (
         p_mm_year       VARCHAR2,
         p_paramdate     VARCHAR2,
         p_year          NUMBER,
         p_mm            NUMBER,
         p_ext_mm        NUMBER,
         p_ext_year      NUMBER,
         p_exclude_mn    VARCHAR2,
         p_mn            VARCHAR2,
         p_mm_year_mn1   VARCHAR2,
         p_mm_year_mn2   VARCHAR2
      )
      IS
         SELECT   a.line_cd, NVL (c.acct_trty_type, 0) acct_trty_type,
                  b.policy_id, b.iss_cd, b.cred_branch,
                  get_policy_no (b.policy_id) policy_no,
                  b.booking_mth booking_month, b.booking_year,
                  TRUNC (b.eff_date) effectivity_date, a.acct_ent_date,
                  spld_date spoiled_date, spld_acct_ent_date, pol_flag,
                  dist_no, dist_flag, SUM (NVL (a.premium_amt, 0)) premium
             FROM giac_treaty_cessions a, gipi_polbasic b, giis_dist_share c
            WHERE a.policy_id = b.policy_id
              AND DECODE (v_start_date,
                          NULL, SYSDATE,
                          LAST_DAY (TO_DATE (   a.cession_mm
                                             || '-'
                                             || a.cession_year,
                                             'MM-YYYY'
                                            )
                                   )
                         ) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
              AND LAST_DAY (TO_DATE (a.cession_mm || '-' || a.cession_year,
                                     'MM-RRRR'
                                    )
                           ) BETWEEN ADD_MONTHS (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         ),
                                                 -11
                                                )
                                 AND LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
              AND a.line_cd = c.line_cd
              AND a.share_cd = c.share_cd
              AND b.reg_policy_sw = 'Y'
              AND (   (p_exclude_mn = 'Y' AND b.line_cd <> p_mn)
                   OR (    p_exclude_mn = 'N'
                       AND (       b.line_cd = p_mn
                               AND (   (    p_paramdate = 'A'
                                        AND p_mm_year IN
                                               (p_mm_year_mn1, p_mm_year_mn2)
                                       )
                                    OR (p_paramdate = 'E')
                                   )
                            OR b.line_cd <> p_mn
                           )
                      )
                  )
         GROUP BY a.line_cd,
                  NVL (c.acct_trty_type, 0),
                  b.policy_id,
                  b.iss_cd,
                  b.cred_branch,
                  get_policy_no (b.policy_id),
                  b.booking_mth,
                  b.booking_year,
                  TRUNC (b.eff_date),
                  a.acct_ent_date,
                  spld_date,
                  spld_acct_ent_date,
                  pol_flag,
                  dist_no,
                  dist_flag;
   BEGIN
      DELETE FROM ri_prem_ext;

      v_mm_year :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);
      v_mm_year_mn1 :=
            TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'MM'
                    )
         || '-'
         || TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'YYYY'
                    );
      v_mm_year_mn2 :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);

      FOR ri_rec IN ri (v_mm_year,
                        v_paramdate,
                        p_extract_year,
                        p_extract_mm,
                        p_extract_mm,
                        p_extract_year,
                        v_exclude_mn,
                        v_mn,
                        v_mm_year_mn1,
                        v_mm_year_mn2
                       )
      LOOP
         INSERT INTO ri_prem_ext
                     (line_cd, acct_trty_type,
                      policy_id, iss_cd, cred_branch,
                      policy_no, prem_amt,
                      booking_month, booking_year,
                      effectivity_date, acct_ent_date,
                      spld_date, spld_acct_ent_date,
                      pol_flag, dist_no, dist_flag,
                      extract_mm, extract_year
                     )
              VALUES (ri_rec.line_cd, ri_rec.acct_trty_type,
                      ri_rec.policy_id, ri_rec.iss_cd, ri_rec.cred_branch,
                      ri_rec.policy_no, ri_rec.premium,
                      ri_rec.booking_month, ri_rec.booking_year,
                      ri_rec.effectivity_date, ri_rec.acct_ent_date,
                      ri_rec.spoiled_date, ri_rec.spld_acct_ent_date,
                      ri_rec.pol_flag, ri_rec.dist_no, ri_rec.dist_flag,
                      p_extract_mm, p_extract_year
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_ri_income1 (p_extract_mm NUMBER, p_extract_year NUMBER)
   IS
      v_paramdate     VARCHAR2 (10) := giacp.v ('24TH_METHOD_PARAMDATE');
      v_exclude_mn    VARCHAR2 (10)
                                := NVL (giacp.v ('EXCLUDE_MARINE_24TH'), 'N');
      v_mn            VARCHAR2 (10) := giisp.v ('LINE_CODE_MN');
      v_mm_year_mn1   VARCHAR2 (30);
      v_mm_year_mn2   VARCHAR2 (30);
      v_mm_year       VARCHAR2 (30);
      v_start_date    DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');

      CURSOR ri_comm_inc (
         p_mm_year       VARCHAR2,
         p_paramdate     VARCHAR2,
         p_year          NUMBER,
         p_mm            NUMBER,
         p_ext_mm        NUMBER,
         p_ext_year      NUMBER,
         p_exclude_mn    VARCHAR2,
         p_mn            VARCHAR2,
         p_mm_year_mn1   VARCHAR2,
         p_mm_year_mn2   VARCHAR2
      )
      IS
         SELECT   b.cred_branch, b.iss_cd, a.line_cd,
                  NVL (c.acct_trty_type, 0) acct_trty_type, a.ri_cd,
                  b.policy_id, get_policy_no (b.policy_id) policy_no,
                  booking_mth booking_month, booking_year, b.eff_date,
                  a.acct_ent_date, b.spld_date, spld_acct_ent_date, pol_flag,
                  dist_no, dist_flag, SUM (NVL (a.premium_amt, 0)) prem_amt,
                  SUM (NVL (a.commission_amt, 0)) commission_amt
             FROM giac_treaty_cessions a, gipi_polbasic b, giis_dist_share c
            WHERE NVL (a.policy_id, a.policy_id) = b.policy_id
              AND DECODE (v_start_date,
                          NULL, SYSDATE,
                          LAST_DAY (TO_DATE (   a.cession_mm
                                             || '-'
                                             || a.cession_year,
                                             'MM-YYYY'
                                            )
                                   )
                         ) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
              AND LAST_DAY (TO_DATE (a.cession_mm || '-' || a.cession_year,
                                     'MM-RRRR'
                                    )
                           ) BETWEEN ADD_MONTHS (TO_DATE (   p_ext_mm
                                                          || '-'
                                                          || p_ext_year,
                                                          'MM-YYYY'
                                                         ),
                                                 -11
                                                )
                                 AND LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
              AND a.line_cd = c.line_cd
              AND a.share_cd = c.share_cd
              AND b.reg_policy_sw = 'Y'
              AND (   (p_exclude_mn = 'Y' AND b.line_cd <> p_mn)
                   OR (    p_exclude_mn = 'N'
                       AND (       b.line_cd = p_mn
                               AND (   (    p_paramdate = 'A'
                                        AND p_mm_year IN
                                               (p_mm_year_mn1, p_mm_year_mn2)
                                       )
                                    OR (p_paramdate = 'E')
                                   )
                            OR b.line_cd <> p_mn
                           )
                      )
                  )
         GROUP BY b.cred_branch,
                  b.iss_cd,
                  a.line_cd,
                  NVL (c.acct_trty_type, 0),
                  a.ri_cd,
                  b.policy_id,
                  b.iss_cd,
                  b.cred_branch,
                  get_policy_no (b.policy_id),
                  prem_amt,
                  booking_mth,
                  booking_year,
                  b.eff_date,
                  a.acct_ent_date,
                  spld_date,
                  spld_acct_ent_date,
                  pol_flag,
                  dist_no,
                  dist_flag;
   BEGIN
      v_mm_year :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);
      v_mm_year_mn1 :=
            TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'MM'
                    )
         || '-'
         || TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'YYYY'
                    );
      v_mm_year_mn2 :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);

      DELETE FROM ri_comm_income_ext
            WHERE extracted_from = 'extract_ri_income1';

      FOR ri_comm_income IN ri_comm_inc (v_mm_year,
                                         v_paramdate,
                                         p_extract_year,
                                         p_extract_mm,
                                         p_extract_mm,
                                         p_extract_year,
                                         v_exclude_mn,
                                         v_mn,
                                         v_mm_year_mn1,
                                         v_mm_year_mn2
                                        )
      LOOP
         INSERT INTO ri_comm_income_ext
                     (line_cd, acct_trty_type,
                      policy_id, iss_cd,
                      cred_branch, policy_no,
                      prem_amt,
                      commission_amt,
                      booking_month,
                      booking_year, effectivity_date,
                      acct_ent_date,
                      spld_date,
                      spld_acct_ent_date,
                      pol_flag, dist_no,
                      dist_flag, ri_cd,
                      extract_mm, extract_year, extracted_from
                     )
              VALUES (ri_comm_income.line_cd, ri_comm_income.acct_trty_type,
                      ri_comm_income.policy_id, ri_comm_income.iss_cd,
                      ri_comm_income.cred_branch, ri_comm_income.policy_no,
                      ri_comm_income.prem_amt,
                      ri_comm_income.commission_amt,
                      ri_comm_income.booking_month,
                      ri_comm_income.booking_year, ri_comm_income.eff_date,
                      ri_comm_income.acct_ent_date,
                      ri_comm_income.spld_date,
                      ri_comm_income.spld_acct_ent_date,
                      ri_comm_income.pol_flag, ri_comm_income.dist_no,
                      ri_comm_income.dist_flag, ri_comm_income.ri_cd,
                      p_extract_mm, p_extract_year, 'extract_ri_income1'
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_ri_income2 (p_extract_mm NUMBER, p_extract_year NUMBER)
   IS
      v_paramdate     VARCHAR2 (10) := giacp.v ('24TH_METHOD_PARAMDATE');
      v_exclude_mn    VARCHAR2 (10)
                                := NVL (giacp.v ('EXCLUDE_MARINE_24TH'), 'N');
      v_mn            VARCHAR2 (10) := giisp.v ('LINE_CODE_MN');
      v_mm_year_mn1   VARCHAR2 (30);
      v_mm_year_mn2   VARCHAR2 (30);
      v_mm_year       VARCHAR2 (30);
      v_start_date    DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');

      CURSOR ri_comm_inc (
         p_mm_year       VARCHAR2,
         p_paramdate     VARCHAR2,
         p_year          NUMBER,
         p_mm            NUMBER,
         p_ext_mm        NUMBER,
         p_ext_year      NUMBER,
         p_exclude_mn    VARCHAR2,
         p_mn            VARCHAR2,
         p_mm_year_mn1   VARCHAR2,
         p_mm_year_mn2   VARCHAR2
      )
      IS
         SELECT   e.cred_branch, e.iss_cd, e.line_cd, a.ri_cd, e.policy_id,
                  get_policy_no (e.policy_id) policy_no,
                  booking_mth booking_month, booking_year, e.eff_date,
                  DECODE(a.acc_ent_date,NULL, d.acct_neg_date, a.acc_ent_date) acc_ent_date, e.spld_date, spld_acct_ent_date, pol_flag,
                  d.dist_no, d.dist_flag, SUM (NVL (c.prem_amt, 0)) prem_amt,
                  SUM
                     (NVL (  DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'),
                                     p_mm_year, -1,
                                     1
                                    )
                           * a.ri_comm_amt
                           * c.currency_rt,
                           0
                          )
                     ) commission_amt
             FROM giri_binder a,
                  giri_frps_ri b,
                  giri_distfrps c,
                  giuw_pol_dist d,
                  gipi_polbasic e
            WHERE a.fnl_binder_id = b.fnl_binder_id
              AND b.line_cd = c.line_cd
              AND b.frps_yy = c.frps_yy
              AND b.frps_seq_no = c.frps_seq_no
              AND c.dist_no = d.dist_no
              AND d.policy_id = e.policy_id
              AND (DECODE (v_start_date, NULL, SYSDATE, a.acc_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                   OR 
                   DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   ))
              AND ((a.acc_ent_date <= LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                    AND (DECODE(a.acc_ent_date, LAST_DAY(TO_DATE (p_mm_year, 'MM-YYYY')), a.acc_ent_date,
                            a.acc_rev_date) <= LAST_DAY(TO_DATE (p_mm_year, 'MM-YYYY'))
                         OR a.acc_rev_date IS NULL))
                   OR a.acc_rev_date <=
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                  )         
              AND e.reg_policy_sw = 'Y'
              AND (   (p_exclude_mn = 'Y' AND e.line_cd <> p_mn)
                   OR (    p_exclude_mn = 'N'
                       AND (       e.line_cd = p_mn
                               AND (   (    p_paramdate = 'A'
                                        AND p_mm_year IN
                                               (p_mm_year_mn1, p_mm_year_mn2)
                                       )
                                    OR (p_paramdate = 'E')
                                   )
                            OR e.line_cd <> p_mn
                           )
                      )
                  )
         GROUP BY e.cred_branch,
                  e.iss_cd,
                  e.line_cd,
                  a.ri_cd,
                  e.policy_id,
                  get_policy_no (e.policy_id),
                  booking_mth,
                  booking_year,
                  e.eff_date,
                  DECODE(a.acc_ent_date,NULL, d.acct_neg_date, a.acc_ent_date),
                  e.spld_date,
                  spld_acct_ent_date,
                  pol_flag,
                  d.dist_no,
                  d.dist_flag;
   BEGIN
      v_mm_year :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);
      v_mm_year_mn1 :=
            TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'MM'
                    )
         || '-'
         || TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'YYYY'
                    );
      v_mm_year_mn2 :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);

      DELETE FROM ri_comm_income_ext
            WHERE extracted_from = 'extract_ri_income2';

      FOR ri_comm_income IN ri_comm_inc (v_mm_year,
                                         v_paramdate,
                                         p_extract_year,
                                         p_extract_mm,
                                         p_extract_mm,
                                         p_extract_year,
                                         v_exclude_mn,
                                         v_mn,
                                         v_mm_year_mn1,
                                         v_mm_year_mn2
                                        )
      LOOP
         INSERT INTO ri_comm_income_ext
                     (line_cd, acct_trty_type, policy_id,
                      iss_cd, cred_branch,
                      policy_no, prem_amt,
                      commission_amt,
                      booking_month,
                      booking_year, effectivity_date,
                      acct_ent_date, spld_date,
                      spld_acct_ent_date,
                      pol_flag, dist_no,
                      dist_flag, ri_cd,
                      extract_mm, extract_year, extracted_from
                     )
              VALUES (ri_comm_income.line_cd, 0, ri_comm_income.policy_id,
                      ri_comm_income.iss_cd, ri_comm_income.cred_branch,
                      ri_comm_income.policy_no,                        --0, 0,
                                               ri_comm_income.prem_amt,
                      ri_comm_income.commission_amt,
                      ri_comm_income.booking_month,
                      ri_comm_income.booking_year, ri_comm_income.eff_date,
                      ri_comm_income.acc_ent_date, ri_comm_income.spld_date,
                      ri_comm_income.spld_acct_ent_date,
                      ri_comm_income.pol_flag, ri_comm_income.dist_no,
                      ri_comm_income.dist_flag, ri_comm_income.ri_cd,
                      p_extract_mm, p_extract_year, 'extract_ri_income2'
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_facul_prem (p_extract_mm NUMBER, p_extract_year NUMBER)
   IS
      v_paramdate     VARCHAR2 (10) := giacp.v ('24TH_METHOD_PARAMDATE');
      v_exclude_mn    VARCHAR2 (10)
                                := NVL (giacp.v ('EXCLUDE_MARINE_24TH'), 'N');
      v_mn            VARCHAR2 (10) := giisp.v ('LINE_CODE_MN');
      v_mm_year_mn1   VARCHAR2 (30);
      v_mm_year_mn2   VARCHAR2 (30);
      v_mm_year       VARCHAR2 (30);
      v_start_date    DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');

      CURSOR ri_facul (
         p_mm_year       VARCHAR2,
         p_paramdate     VARCHAR2,
         p_year          NUMBER,
         p_mm            NUMBER,
         p_ext_mm        NUMBER,
         p_ext_year      NUMBER,
         p_exclude_mn    VARCHAR2,
         p_mn            VARCHAR2,
         p_mm_year_mn1   VARCHAR2,
         p_mm_year_mn2   VARCHAR2
      )
      IS
         SELECT   e.line_cd, e.policy_id, e.iss_cd, e.cred_branch,
                  get_policy_no (e.policy_id) policy_no,
                  booking_mth booking_month, booking_year, e.eff_date,
                  DECODE(a.acc_ent_date,NULL, d.acct_neg_date, a.acc_ent_date) acc_ent_date, a.acc_rev_date, e.spld_date,
                  e.spld_acct_ent_date, e.pol_flag, d.dist_no, e.dist_flag,
                  SUM (  DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'),
                                 p_mm_year, -1,
                                 1
                                )
                       * a.ri_prem_amt
                       * c.currency_rt
                      ) prem_amt
             FROM giri_binder a,
                  giri_frps_ri b,
                  giri_distfrps c,
                  giuw_pol_dist d,
                  gipi_polbasic e
            WHERE a.fnl_binder_id = b.fnl_binder_id
              AND b.line_cd = c.line_cd
              AND b.frps_yy = c.frps_yy
              AND b.frps_seq_no = c.frps_seq_no
              AND c.dist_no = d.dist_no
              AND d.policy_id = e.policy_id
              AND (DECODE (v_start_date, NULL, SYSDATE, a.acc_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                      OR 
                   DECODE (v_start_date, NULL, SYSDATE, a.acc_rev_date) >=
                            DECODE(v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                  )
                                   )
              AND ((a.acc_ent_date <= LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                    AND (DECODE(a.acc_ent_date, LAST_DAY(TO_DATE (p_mm_year, 'MM-YYYY')), a.acc_ent_date,
                            a.acc_rev_date) <= LAST_DAY(TO_DATE (p_mm_year, 'MM-YYYY'))
                         OR a.acc_rev_date IS NULL))
                   OR a.acc_rev_date <=
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                 --  OR d.acct_neg_date <=
                 --                    LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                  )
              AND e.reg_policy_sw = 'Y'
              AND (   (p_exclude_mn = 'Y' AND e.line_cd <> p_mn)
                   OR (    p_exclude_mn = 'N'
                       AND (       e.line_cd = p_mn
                               AND (   (    p_paramdate = 'A'
                                        AND p_mm_year IN
                                               (p_mm_year_mn1, p_mm_year_mn2)
                                       )
                                    OR (p_paramdate = 'E')
                                   )
                            OR e.line_cd <> p_mn
                           )
                      )
                  )
         GROUP BY e.line_cd,
                  e.policy_id,
                  e.iss_cd,
                  e.cred_branch,
                  get_policy_no (e.policy_id),
                  booking_mth,
                  booking_year,
                  e.eff_date,
                  DECODE(a.acc_ent_date,NULL, d.acct_neg_date, a.acc_ent_date),
                  a.acc_rev_date,
                  e.spld_date,
                  e.spld_acct_ent_date,
                  pol_flag,
                  d.dist_no,
                  e.dist_flag;
   BEGIN
      v_mm_year :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);
      v_mm_year_mn1 :=
            TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'MM'
                    )
         || '-'
         || TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'YYYY'
                    );
      v_mm_year_mn2 :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);

      DELETE FROM ri_facul_prem_ext;

      FOR ri_facul_rec IN ri_facul (v_mm_year,
                                    v_paramdate,
                                    p_extract_year,
                                    p_extract_mm,
                                    p_extract_mm,
                                    p_extract_year,
                                    v_exclude_mn,
                                    v_mn,
                                    v_mm_year_mn1,
                                    v_mm_year_mn2
                                   )
      LOOP
         INSERT INTO ri_facul_prem_ext
                     (line_cd, acct_trty_type, policy_id,
                      iss_cd, cred_branch,
                      policy_no, prem_amt,
                      booking_month, booking_year,
                      effectivity_date, acct_ent_date,
                      acc_rev_date, spld_date,
                      spld_acct_ent_date,
                      pol_flag, dist_no,
                      dist_flag, extract_mm, extract_year
                     )
              VALUES (ri_facul_rec.line_cd, 0, ri_facul_rec.policy_id,
                      ri_facul_rec.iss_cd, ri_facul_rec.cred_branch,
                      ri_facul_rec.policy_no, ri_facul_rec.prem_amt,
                      ri_facul_rec.booking_month, ri_facul_rec.booking_year,
                      ri_facul_rec.eff_date, ri_facul_rec.acc_ent_date,
                      ri_facul_rec.acc_rev_date, ri_facul_rec.spld_date,
                      ri_facul_rec.spld_acct_ent_date,
                      ri_facul_rec.pol_flag, ri_facul_rec.dist_no,
                      ri_facul_rec.dist_flag, p_extract_mm, p_extract_year
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_comm_exp (p_extract_mm NUMBER, p_extract_year NUMBER)
   IS
      v_paramdate     VARCHAR2 (10) := giacp.v ('24TH_METHOD_PARAMDATE');
      v_exclude_mn    VARCHAR2 (10)
                                := NVL (giacp.v ('EXCLUDE_MARINE_24TH'), 'N');
      v_mn            VARCHAR2 (10) := giisp.v ('LINE_CODE_MN');
      v_mm_year_mn1   VARCHAR2 (30);
      v_mm_year_mn2   VARCHAR2 (30);
      v_mm_year       VARCHAR2 (30);
      v_iss_cd_ri     VARCHAR2 (5)  := giisp.v ('ISS_CD_RI');
      v_iss_cd_rv     VARCHAR2 (5)  := giisp.v ('ISS_CD_RV');
      v_start_date    DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');

      CURSOR comm_exp (
         p_mm_year       VARCHAR2,
         p_paramdate     VARCHAR2,
         p_year          NUMBER,
         p_mm            NUMBER,
         p_ext_mm        NUMBER,
         p_ext_year      NUMBER,
         p_exclude_mn    VARCHAR2,
         p_mn            VARCHAR2,
         p_mm_year_mn1   VARCHAR2,
         p_mm_year_mn2   VARCHAR2,
         p_iss_cd_ri     VARCHAR2,
         p_iss_cd_rv     VARCHAR2
      )
      IS
         SELECT b.cred_branch, b.iss_cd, b.line_cd, b.policy_id,
                get_policy_no (b.policy_id) policy_no,
                d.intrmdry_intm_no intm_no, booking_mth booking_month,
                booking_year, b.eff_date, a.acct_ent_date, b.spld_date,
                spoiled_acct_ent_date, pol_flag,
                  d.commission_amt
                * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'),
                          p_mm_year, -1,
                          1
                         )
                * a.currency_rt comm_expense
           FROM gipi_invoice a, gipi_polbasic b, gipi_comm_invoice d
          WHERE a.iss_cd = d.iss_cd
            AND a.prem_seq_no = d.prem_seq_no
            AND a.policy_id = d.policy_id
            AND a.policy_id = b.policy_id
            AND (DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                 OR DECODE (v_start_date,
                            NULL, SYSDATE,
                            a.spoiled_acct_ent_date
                           ) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                )
            AND (   a.acct_ent_date <=
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                 OR a.spoiled_acct_ent_date <=
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                )
            AND b.iss_cd NOT IN (p_iss_cd_ri, p_iss_cd_rv)
            AND b.reg_policy_sw = 'Y'
            AND (   (p_exclude_mn = 'Y' AND b.line_cd <> p_mn)
                 OR (    p_exclude_mn = 'N'
                     AND (       b.line_cd = p_mn
                             AND (   (    p_paramdate = 'A'
                                      AND p_mm_year IN
                                               (p_mm_year_mn1, p_mm_year_mn2)
                                     )
                                  OR (p_paramdate = 'E')
                                 )
                          OR b.line_cd <> p_mn
                         )
                    )
                )
            AND NOT EXISTS (
                   SELECT 'X'
                     FROM giac_prev_comm_inv g, giac_new_comm_inv h
                    WHERE g.fund_cd = h.fund_cd
                      AND g.branch_cd = h.branch_cd
                      AND g.comm_rec_id = h.comm_rec_id
                      AND g.intm_no = h.intm_no
                      AND TO_CHAR (g.acct_ent_date, 'MM-YYYY') = p_mm_year
                      AND h.acct_ent_date >
                                     a.acct_ent_date--LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                      AND h.tran_flag = 'P'
                      AND h.iss_cd = d.iss_cd
                      AND h.prem_seq_no = d.prem_seq_no
                      AND DECODE (v_start_date,
                            NULL, SYSDATE,
                            h.acct_ent_date
                           ) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   ))
         UNION ALL
         SELECT b.cred_branch, b.iss_cd, b.line_cd, b.policy_id,
                get_policy_no (b.policy_id) policy_no, c.intm_no,
                booking_mth booking_month, booking_year, b.eff_date,
                a.acct_ent_date, b.spld_date, spoiled_acct_ent_date, pol_flag,
                  c.commission_amt
                * DECODE (TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY'),
                          p_mm_year, -1,
                          1
                         )
                * a.currency_rt comm_expense
           FROM gipi_invoice a,
                gipi_polbasic b,
                giac_prev_comm_inv c,
                giac_new_comm_inv d
          WHERE a.policy_id = b.policy_id
            AND a.iss_cd = d.iss_cd
            AND a.prem_seq_no = d.prem_seq_no
            AND a.policy_id = d.policy_id            
            AND (DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                 OR DECODE (v_start_date,
                            NULL, SYSDATE,
                            a.spoiled_acct_ent_date
                           ) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                 )
            AND (   a.acct_ent_date <=
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                 OR a.spoiled_acct_ent_date <=
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                )
            AND b.iss_cd NOT IN (p_iss_cd_ri, p_iss_cd_rv)
            AND b.reg_policy_sw = 'Y'
            AND (   (p_exclude_mn = 'Y' AND b.line_cd <> p_mn)
                 OR (    p_exclude_mn = 'N'
                     AND (       b.line_cd = p_mn
                             AND (   (    p_paramdate = 'A'
                                      AND p_mm_year IN
                                               (p_mm_year_mn1, p_mm_year_mn2)
                                     )
                                  OR (p_paramdate = 'E')
                                 )
                          OR b.line_cd <> p_mn
                         )
                    )
                )
            AND c.fund_cd = d.fund_cd
            AND c.branch_cd = d.branch_cd
            AND c.comm_rec_id = d.comm_rec_id
            AND c.intm_no = d.intm_no
            AND /*TO_CHAR (c.acct_ent_date, 'MM-YYYY')*/ c.acct_ent_date = a.acct_ent_date --p_mm_year
            AND d.acct_ent_date > a.acct_ent_date --LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
            AND d.acct_ent_date > LAST_DAY(TO_DATE (p_ext_mm|| '-'||p_ext_year,'MM-YYYY'))
            --AND d.acct_ent_date > LAST_DAY(TO_DATE (p_ext_mm||'-'||p_ext_year,'MM-YYYY'))
            AND d.tran_flag = 'P'
            AND c.comm_rec_id =
                   (SELECT MIN (g.comm_rec_id)
                      FROM giac_prev_comm_inv g, giac_new_comm_inv h
                     WHERE g.fund_cd = h.fund_cd
                       AND g.branch_cd = h.branch_cd
                       AND g.comm_rec_id = h.comm_rec_id
                       AND g.intm_no = h.intm_no
                       AND /*TO_CHAR (g.acct_ent_date, 'MM-YYYY')*/ g.acct_ent_date = a.acct_ent_date--p_mm_year
                       AND h.acct_ent_date >
                                     a.acct_ent_date --LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                       AND h.tran_flag = 'P'
                       AND h.iss_cd = d.iss_cd
                       AND h.prem_seq_no = d.prem_seq_no
                       AND h.intm_no = d.intm_no)
         UNION ALL
         SELECT b.cred_branch, b.iss_cd, b.line_cd, b.policy_id,
                get_policy_no (b.policy_id) policy_no, d.intm_no,
                booking_mth booking_month, booking_year, b.eff_date,
                d.acct_ent_date, b.spld_date, spoiled_acct_ent_date, pol_flag,
                (d.commission_amt * a.currency_rt) comm_expense
           FROM gipi_invoice a, gipi_polbasic b, giac_new_comm_inv d
          WHERE a.policy_id = b.policy_id
            AND a.iss_cd = d.iss_cd
            AND a.prem_seq_no = d.prem_seq_no
            AND a.policy_id = d.policy_id
            AND b.iss_cd NOT IN (p_iss_cd_ri, p_iss_cd_rv)
            AND b.reg_policy_sw = 'Y'
            AND (   (p_exclude_mn = 'Y' AND b.line_cd <> p_mn)
                 OR (    p_exclude_mn = 'N'
                     AND (       b.line_cd = p_mn
                             AND (   (    p_paramdate = 'A'
                                      AND p_mm_year IN
                                               (p_mm_year_mn1, p_mm_year_mn2)
                                     )
                                  OR (p_paramdate = 'E')
                                 )
                          OR b.line_cd <> p_mn
                         )
                    )
                )
                        
            AND (DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                 OR
                 DECODE (v_start_date, NULL, SYSDATE, d.acct_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                 OR
                 DECODE (v_start_date, NULL, SYSDATE, a.spoiled_acct_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                )
            AND /*TO_CHAR (d.acct_ent_date, 'MM-YYYY')*/d.acct_ent_date = LAST_DAY(TO_DATE(p_mm_year,'MM-YYYY'))
            AND NVL (d.delete_sw, 'N') = 'N'
            AND d.tran_flag = 'P'
         UNION ALL
         SELECT b.cred_branch, b.iss_cd, b.line_cd, b.policy_id,
                get_policy_no (b.policy_id) policy_no, c.intm_no,
                booking_mth booking_month, booking_year, b.eff_date,
                d.acct_ent_date, b.spld_date, spld_acct_ent_date, pol_flag,
                ((c.commission_amt * a.currency_rt) * -1) comm_expense
           FROM gipi_invoice a,
                gipi_polbasic b,
                giac_prev_comm_inv c,
                giac_new_comm_inv d
          WHERE a.policy_id = b.policy_id
            AND a.iss_cd = d.iss_cd
            AND a.prem_seq_no = d.prem_seq_no
            AND a.policy_id = d.policy_id
            AND c.comm_rec_id = d.comm_rec_id
            AND b.iss_cd NOT IN (p_iss_cd_ri, p_iss_cd_rv)
            AND b.reg_policy_sw = 'Y'
            AND (   (p_exclude_mn = 'Y' AND b.line_cd <> p_mn)
                 OR (    p_exclude_mn = 'N'
                     AND (       b.line_cd = p_mn
                             AND (   (    p_paramdate = 'A'
                                      AND p_mm_year IN
                                               (p_mm_year_mn1, p_mm_year_mn2)
                                     )
                                  OR (p_paramdate = 'E')
                                 )
                          OR b.line_cd <> p_mn
                         )
                    )
                )
            AND (DECODE (v_start_date, NULL, SYSDATE, a.acct_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                 OR
                 DECODE (v_start_date, NULL, SYSDATE, d.acct_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                 OR
                 DECODE (v_start_date, NULL, SYSDATE, A.spoiled_acct_ent_date) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                )
            AND /*TO_CHAR (d.acct_ent_date, 'MM-YYYY')*/ d.acct_ent_date = LAST_DAY(TO_DATE(p_mm_year,'MM-YYYY'))
            AND NVL (d.delete_sw, 'N') = 'N'
            AND d.tran_flag = 'P';
   BEGIN
      v_mm_year :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);
      v_mm_year_mn1 :=
            TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'MM'
                    )
         || '-'
         || TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'YYYY'
                    );
      v_mm_year_mn2 :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);

      DELETE FROM comm_expense_ext
            WHERE NVL (cred_branch, iss_cd) != 'RI';

      FOR comm_exp_rec IN comm_exp (v_mm_year,
                                    v_paramdate,
                                    p_extract_year,
                                    p_extract_mm,
                                    p_extract_mm,
                                    p_extract_year,
                                    v_exclude_mn,
                                    v_mn,
                                    v_mm_year_mn1,
                                    v_mm_year_mn2,
                                    v_iss_cd_ri,
                                    v_iss_cd_rv
                                   )
      LOOP
         INSERT INTO comm_expense_ext
                     (cred_branch, iss_cd,
                      line_cd, policy_id,
                      policy_no, intm_no,
                      booking_month, booking_year,
                      eff_date, acct_ent_date,
                      spld_date,
                      spld_acct_ent_date,
                      pol_flag, comm_amt,
                      extract_mm, extract_year
                     )
              VALUES (comm_exp_rec.cred_branch, comm_exp_rec.iss_cd,
                      comm_exp_rec.line_cd, comm_exp_rec.policy_id,
                      comm_exp_rec.policy_no, comm_exp_rec.intm_no,
                      comm_exp_rec.booking_month, comm_exp_rec.booking_year,
                      comm_exp_rec.eff_date, comm_exp_rec.acct_ent_date,
                      comm_exp_rec.spld_date,
                      comm_exp_rec.spoiled_acct_ent_date,
                      comm_exp_rec.pol_flag, comm_exp_rec.comm_expense,
                      p_extract_mm, p_extract_year
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_comm_exp_ri (p_extract_mm NUMBER, p_extract_year NUMBER)
   IS
      v_paramdate     VARCHAR2 (10) := giacp.v ('24TH_METHOD_PARAMDATE');
      v_exclude_mn    VARCHAR2 (10)
                                := NVL (giacp.v ('EXCLUDE_MARINE_24TH'), 'N');
      v_mn            VARCHAR2 (10) := giisp.v ('LINE_CODE_MN');
      v_mm_year_mn1   VARCHAR2 (30);
      v_mm_year_mn2   VARCHAR2 (30);
      v_mm_year       VARCHAR2 (30);
      v_iss_cd_ri     VARCHAR2 (5)  := giisp.v ('ISS_CD_RI');
      v_iss_cd_rv     VARCHAR2 (5)  := giisp.v ('ISS_CD_RV');
      v_start_date    DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');

      CURSOR comm_exp (
         p_mm_year       VARCHAR2,
         p_paramdate     VARCHAR2,
         p_year          NUMBER,
         p_mm            NUMBER,
         p_ext_mm        NUMBER,
         p_ext_year      NUMBER,
         p_exclude_mn    VARCHAR2,
         p_mn            VARCHAR2,
         p_mm_year_mn1   VARCHAR2,
         p_mm_year_mn2   VARCHAR2,
         p_iss_cd_ri     VARCHAR2,
         p_iss_cd_rv     VARCHAR2
      )
      IS
         SELECT   ri_cd, cred_branch, iss_cd, line_cd, policy_id,
                  get_policy_no (policy_id) policy_no,
                  booking_mth booking_month, booking_year, eff_date,
                  acct_ent_date, spld_date, spld_acct_ent_date, pol_flag,
                  SUM (comm_expense) comm_expense
             FROM (SELECT b.cred_branch, a.iss_cd, b.line_cd, c.ri_cd,
                            a.ri_comm_amt
                          * DECODE (TO_CHAR (a.spoiled_acct_ent_date,
                                             'MM-YYYY'
                                            ),
                                    p_mm_year, -1,
                                    1
                                   )
                          * a.currency_rt comm_expense,
                          b.eff_date, b.policy_id, booking_mth, booking_year,
                          b.acct_ent_date, spld_date, spld_acct_ent_date,
                          pol_flag
                     FROM gipi_invoice a, gipi_polbasic b, giri_inpolbas c
                    WHERE a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND (   a.acct_ent_date <=
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                           OR a.spoiled_acct_ent_date <=
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                          )
                      AND (DECODE(v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
                           OR
                           DECODE(v_start_date, NULL, SYSDATE, a.spoiled_acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
                          )
                      AND b.iss_cd IN (p_iss_cd_ri, p_iss_cd_rv)
                      AND b.reg_policy_sw = 'Y'
                      AND (   (p_exclude_mn = 'Y' AND b.line_cd <> p_mn)
                           OR (    p_exclude_mn = 'N'
                               AND (       b.line_cd = p_mn
                                       AND (   (    p_paramdate = 'A'
                                                AND p_mm_year IN
                                                       (p_mm_year_mn1,
                                                        p_mm_year_mn2
                                                       )
                                               )
                                            OR (p_paramdate = 'E')
                                           )
                                    OR b.line_cd <> p_mn
                                   )
                              )
                          )
                      AND NOT EXISTS (
                             SELECT 'X'
                               FROM giac_ri_comm_hist c
                              WHERE c.policy_id = b.policy_id
                                AND TO_CHAR (c.acct_ent_date, 'MM-YYYY') =
                                                                     p_mm_year
                                AND LAST_DAY (TRUNC (c.post_date)) >
                                       LAST_DAY (TO_DATE (p_mm_year,
                                                          'MM-YYYY')
                                                ))
                   UNION ALL
                   SELECT b.cred_branch, a.iss_cd, b.line_cd, d.ri_cd,
                            c.old_ri_comm_amt
                          * DECODE (TO_CHAR (a.spoiled_acct_ent_date,
                                             'MM-YYYY'
                                            ),
                                    p_mm_year, -1,
                                    1
                                   )
                          * a.currency_rt comm_expense,
                          b.eff_date, b.policy_id, booking_mth, booking_year,
                          b.acct_ent_date, spld_date, spld_acct_ent_date,
                          pol_flag
                     FROM gipi_invoice a,
                          giac_ri_comm_hist c,
                          gipi_polbasic b,
                          giri_inpolbas d
                    WHERE a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.policy_id = d.policy_id
                      AND (DECODE(v_start_date, NULL, SYSDATE, c.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
                           OR
                           DECODE(v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
                           OR
                           DECODE(v_start_date, NULL, SYSDATE, a.spoiled_acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
                          )
                      AND TO_CHAR (c.acct_ent_date, 'MM-YYYY') = p_mm_year
                      AND LAST_DAY (TRUNC (c.post_date)) >
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                      AND (   TO_CHAR (a.acct_ent_date, 'MM-YYYY') <=
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                           OR TO_CHAR (a.spoiled_acct_ent_date, 'MM-YYYY') <=
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
                          )
                      AND b.iss_cd IN (p_iss_cd_ri, p_iss_cd_rv)
                      AND b.reg_policy_sw = 'Y'
                      AND (   (p_exclude_mn = 'Y' AND b.line_cd <> p_mn)
                           OR (    p_exclude_mn = 'N'
                               AND (       b.line_cd = p_mn
                                       AND (   (    p_paramdate = 'A'
                                                AND p_mm_year IN
                                                       (p_mm_year_mn1,
                                                        p_mm_year_mn2
                                                       )
                                               )
                                            OR (p_paramdate = 'E')
                                           )
                                    OR b.line_cd <> p_mn
                                   )
                              )
                          )
                      AND c.tran_id_rev =
                             (SELECT MIN (tran_id_rev)
                                FROM giac_ri_comm_hist d
                               WHERE d.policy_id = b.policy_id
                                 AND TO_CHAR (d.acct_ent_date, 'MM-YYYY') =
                                                                     p_mm_year
                                 AND LAST_DAY (TRUNC (d.post_date)) >
                                        LAST_DAY (TO_DATE (p_mm_year,
                                                           'MM-YYYY'
                                                          )
                                                 ))
                   UNION ALL
                   SELECT b.cred_branch, a.iss_cd, b.line_cd, d.ri_cd,
                            c.new_ri_comm_amt
                          * DECODE (TO_CHAR (a.spoiled_acct_ent_date,
                                             'MM-YYYY'
                                            ),
                                    p_mm_year, -1,
                                    1
                                   )
                          * a.currency_rt comm_expense,
                          b.eff_date, b.policy_id, booking_mth, booking_year,
                          b.acct_ent_date, spld_date, spld_acct_ent_date,
                          pol_flag
                     FROM gipi_invoice a,
                          giac_ri_comm_hist c,
                          gipi_polbasic b,
                          giri_inpolbas d
                    WHERE a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.policy_id = d.policy_id
                      AND (DECODE(v_start_date, NULL, SYSDATE, a.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
                           OR
                           DECODE(v_start_date, NULL, SYSDATE, a.spoiled_acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date)
                           OR
                           DECODE(v_start_date, NULL, SYSDATE, c.acct_ent_date) >= DECODE(v_start_date, NULL, SYSDATE, v_start_date))
                      AND TO_CHAR (c.post_date, 'MM-YYYY') = p_mm_year
                      AND b.iss_cd IN (p_iss_cd_ri, p_iss_cd_rv)
                      AND b.reg_policy_sw = 'Y'
                      AND (   (p_exclude_mn = 'Y' AND b.line_cd <> p_mn)
                           OR (    p_exclude_mn = 'N'
                               AND (       b.line_cd = p_mn
                                       AND (   (    p_paramdate = 'A'
                                                AND p_mm_year IN
                                                       (p_mm_year_mn1,
                                                        p_mm_year_mn2
                                                       )
                                               )
                                            OR (p_paramdate = 'E')
                                           )
                                    OR b.line_cd <> p_mn
                                   )
                              )
                          )
                      AND c.tran_id =
                             (SELECT MAX (tran_id)
                                FROM giac_ri_comm_hist d
                               WHERE d.policy_id = b.policy_id
                                 AND TO_CHAR (d.post_date, 'MM-YYYY') =
                                                                     p_mm_year))
         GROUP BY ri_cd,
                  cred_branch,
                  iss_cd,
                  line_cd,
                  policy_id,
                  get_policy_no (policy_id),
                  booking_mth,
                  booking_year,
                  eff_date,
                  acct_ent_date,
                  spld_date,
                  spld_acct_ent_date,
                  pol_flag;
   BEGIN
      v_mm_year :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);
      v_mm_year_mn1 :=
            TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'MM'
                    )
         || '-'
         || TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                                || '-'
                                || TO_CHAR (p_extract_year),
                                'MM-YYYY'
                               )
                     - 1,
                     'YYYY'
                    );
      v_mm_year_mn2 :=
            LPAD (TO_CHAR (p_extract_mm), 2, '0')
         || '-'
         || TO_CHAR (p_extract_year);

      DELETE FROM comm_expense_ext
            WHERE NVL (cred_branch, iss_cd) = 'RI';

      FOR comm_exp_rec IN comm_exp (v_mm_year,
                                    v_paramdate,
                                    p_extract_year,
                                    p_extract_mm,
                                    p_extract_mm,
                                    p_extract_year,
                                    v_exclude_mn,
                                    v_mn,
                                    v_mm_year_mn1,
                                    v_mm_year_mn2,
                                    v_iss_cd_ri,
                                    v_iss_cd_rv
                                   )
      LOOP
         INSERT INTO comm_expense_ext
                     (cred_branch, iss_cd,
                      line_cd, policy_id,
                      policy_no, intm_no,
                      booking_month, booking_year,
                      eff_date, acct_ent_date,
                      spld_date,
                      spld_acct_ent_date,
                      pol_flag, comm_amt,
                      extract_mm, extract_year
                     )
              VALUES (comm_exp_rec.cred_branch, comm_exp_rec.iss_cd,
                      comm_exp_rec.line_cd, comm_exp_rec.policy_id,
                      comm_exp_rec.policy_no, comm_exp_rec.ri_cd,
                      comm_exp_rec.booking_month, comm_exp_rec.booking_year,
                      comm_exp_rec.eff_date, comm_exp_rec.acct_ent_date,
                      comm_exp_rec.spld_date,
                      comm_exp_rec.spld_acct_ent_date,
                      comm_exp_rec.pol_flag, comm_exp_rec.comm_expense,
                      p_extract_mm, p_extract_year
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_grossprem_prod (p_extract_mm NUMBER, p_extract_year NUMBER)
   IS
      v_date         DATE
                := TO_DATE (p_extract_mm || '-' || p_extract_year, 'MM-YYYY');
      v_start_date   DATE
         := LAST_DAY (TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY'));
   BEGIN
      DELETE FROM grossprem_prod_ext;

      FOR i IN (SELECT   line_cd, NVL (cred_branch, b.iss_cd) iss_cd,
                         get_policy_no (a.policy_id) policy_no, a.eff_date,
                         a.expiry_date, b.acct_ent_date,
                         spoiled_acct_ent_date,
                         b.prem_amt * b.currency_rt prem_amt
                    FROM gipi_polbasic a, gipi_invoice b
                   WHERE b.policy_id = a.policy_id
                     AND DECODE (v_start_date,
                                 NULL, SYSDATE,
                                 a.acct_ent_date
                                ) >=
                            DECODE (v_start_date,
                                    NULL, SYSDATE,
                                    v_start_date
                                   )
                     AND (   TRUNC (b.acct_ent_date) BETWEEN ADD_MONTHS
                                                                      (v_date,
                                                                       -11
                                                                      )
                                                         AND LAST_DAY (v_date)
                          OR TRUNC (spld_acct_ent_date)
                                BETWEEN ADD_MONTHS (v_date, -11)
                                    AND LAST_DAY (v_date)
                         )
                ORDER BY line_cd, iss_cd)
      LOOP
         INSERT INTO grossprem_prod_ext
                     (line_cd, iss_cd, policy_no, eff_date,
                      expiry_date, acct_ent_date,
                      spoiled_acct_ent_date, prem_amt
                     )
              VALUES (i.line_cd, i.iss_cd, i.policy_no, i.eff_date,
                      i.expiry_date, i.acct_ent_date,
                      i.spoiled_acct_ent_date, i.prem_amt
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_premceded_prod (p_extract_mm NUMBER, p_extract_year NUMBER)
   IS
      v_date      DATE
                := TO_DATE (p_extract_mm || '-' || p_extract_year, 'MM-YYYY');
      v_mm_year   VARCHAR2 (20)
                         := LPAD (p_extract_mm, 2, 0) || '-'
                            || p_extract_year;
   BEGIN
      DELETE FROM premceded_prod_ext;

      FOR i IN
         (SELECT   NVL (b.cred_branch, b.iss_cd) iss_cd, a.line_cd,
                   NVL (c.acct_trty_type, 0) acct_trty_type, b.eff_date,
                   b.expiry_date, a.acct_ent_date, spld_acct_ent_date,
                   a.share_cd, get_policy_no (b.policy_id) policy_no,
                   SUM (NVL (a.premium_amt, 0)) prem_amt
              FROM giac_treaty_cessions a, gipi_polbasic b,
                   giis_dist_share c
             WHERE a.policy_id = b.policy_id
               AND LAST_DAY (TO_DATE (a.cession_mm || '-' || a.cession_year,
                                      'MM-RRRR'
                                     )
                            ) BETWEEN ADD_MONTHS (v_date, -11)
                                  AND LAST_DAY (v_date)
               AND a.line_cd = c.line_cd
               AND a.share_cd = c.share_cd
               AND b.reg_policy_sw = 'Y'
          GROUP BY NVL (b.cred_branch, b.iss_cd),
                   a.line_cd,
                   NVL (c.acct_trty_type, 0),
                   b.eff_date,
                   b.expiry_date,
                   a.acct_ent_date,
                   spld_acct_ent_date,
                   a.share_cd,
                   get_policy_no (b.policy_id)
          UNION
          SELECT   NVL (e.cred_branch, e.iss_cd) iss_cd, e.line_cd,
                   0 acct_trty_type, e.eff_date, e.expiry_date,
                   e.acct_ent_date, spld_acct_ent_date, 999 share_cd,
                   get_policy_no (e.policy_id) policy_no,
                   SUM (  DECODE (TO_CHAR (a.acc_rev_date, 'MM-YYYY'),
                                  v_mm_year, -1,
                                  1
                                 )
                        * a.ri_prem_amt
                        * c.currency_rt
                       ) prem_amt
              FROM giri_binder a,
                   giri_frps_ri b,
                   giri_distfrps c,
                   giuw_pol_dist d,
                   gipi_polbasic e
             WHERE a.fnl_binder_id = b.fnl_binder_id
               AND b.line_cd = c.line_cd
               AND b.frps_yy = c.frps_yy
               AND b.frps_seq_no = c.frps_seq_no
               AND c.dist_no = d.dist_no
               AND d.policy_id = e.policy_id
               AND (   a.acc_ent_date BETWEEN ADD_MONTHS (v_date, -11)
                                          AND LAST_DAY (v_date)
                    OR a.acc_rev_date BETWEEN ADD_MONTHS (v_date, -11)
                                          AND LAST_DAY (v_date)
                   )
               AND e.reg_policy_sw = 'Y'
          GROUP BY NVL (e.cred_branch, e.iss_cd),
                   e.line_cd,
                   0,
                   e.eff_date,
                   e.expiry_date,
                   e.acct_ent_date,
                   spld_acct_ent_date,
                   999,
                   get_policy_no (e.policy_id))
      LOOP
         INSERT INTO premceded_prod_ext
                     (iss_cd, line_cd, acct_trty_type, eff_date,
                      expiry_date, acct_ent_date, spoiled_acct_ent_date,
                      share_cd, prem_amt, policy_no
                     )
              VALUES (i.iss_cd, i.line_cd, i.acct_trty_type, i.eff_date,
                      i.expiry_date, i.acct_ent_date, i.spld_acct_ent_date,
                      i.share_cd, i.prem_amt, i.policy_no
                     );
      END LOOP;

      COMMIT;
   END;

   PROCEDURE extract_all (p_extract_mm NUMBER, p_extract_year NUMBER)
   IS
   BEGIN
      twenty_fourth_validation.extract_gross_premium (p_extract_mm,
                                                      p_extract_year
                                                     );
      twenty_fourth_validation.extract_ri_prem (p_extract_mm, p_extract_year);
      twenty_fourth_validation.extract_ri_income1 (p_extract_mm,
                                                   p_extract_year
                                                  );
      twenty_fourth_validation.extract_ri_income2 (p_extract_mm,
                                                   p_extract_year
                                                  );
      twenty_fourth_validation.extract_facul_prem (p_extract_mm,
                                                   p_extract_year
                                                  );
      twenty_fourth_validation.extract_comm_exp (p_extract_mm, p_extract_year);
      twenty_fourth_validation.extract_comm_exp_ri (p_extract_mm,
                                                    p_extract_year
                                                   );
      twenty_fourth_validation.extract_grossprem_prod (p_extract_mm,
                                                       p_extract_year
                                                      );
      twenty_fourth_validation.extract_premceded_prod (p_extract_mm,
                                                       p_extract_year
                                                      );
   END;

   FUNCTION get_gross_premium_dtl
      RETURN deff_rec_type_table PIPELINED
   IS
      v_deff_rec_type   deff_rec_type;
      v_line_cd_mn      VARCHAR2 (7)  := giisp.v ('LINE_CODE_MN');
      v_date            DATE;
      v_month           VARCHAR2 (30);
      v_factor          NUMBER;
      v_year            NUMBER;
      v_ctr             NUMBER        := 0;
      v_start_date      DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   BEGIN
      FOR rec IN (SELECT *
                    FROM gross_prem_ext)
      LOOP
         v_deff_rec_type.jan_1 := NULL;
         v_deff_rec_type.feb_1 := NULL;
         v_deff_rec_type.mar_1 := NULL;
         v_deff_rec_type.apr_1 := NULL;
         v_deff_rec_type.may_1 := NULL;
         v_deff_rec_type.jun_1 := NULL;
         v_deff_rec_type.jul_1 := NULL;
         v_deff_rec_type.aug_1 := NULL;
         v_deff_rec_type.sep_1 := NULL;
         v_deff_rec_type.oct_1 := NULL;
         v_deff_rec_type.nov_1 := NULL;
         v_deff_rec_type.dec_1 := NULL;
         v_deff_rec_type.jan_2 := NULL;
         v_deff_rec_type.feb_2 := NULL;
         v_deff_rec_type.mar_2 := NULL;
         v_deff_rec_type.apr_2 := NULL;
         v_deff_rec_type.may_2 := NULL;
         v_deff_rec_type.jun_2 := NULL;
         v_deff_rec_type.jul_2 := NULL;
         v_deff_rec_type.aug_2 := NULL;
         v_deff_rec_type.sep_2 := NULL;
         v_deff_rec_type.oct_2 := NULL;
         v_deff_rec_type.nov_2 := NULL;
         v_deff_rec_type.dec_2 := NULL;

         IF TRUNC (rec.effectivity_date) >
               LAST_DAY (ADD_MONTHS (TO_DATE (   rec.extract_mm
                                              || '-'
                                              || rec.extract_year,
                                              'MM-YYYY'
                                             ),
                                     -12
                                    )
                        )
         THEN
            LOOP
               v_date := ADD_MONTHS (rec.acct_ent_date, v_ctr);

               IF v_date >
                     LAST_DAY (TO_DATE (   rec.extract_mm
                                        || '-'
                                        || rec.extract_year,
                                        'MM-YYYY'
                                       )
                              )
               THEN
                  EXIT;
               END IF;

               v_month := TO_CHAR (v_date, 'fmMONTH');
               v_year := TO_CHAR (v_date, 'fmRRRR');

               IF LAST_DAY (v_start_date) <= rec.acct_ent_date
               THEN
                  IF v_month = 'JANUARY' AND v_year = rec.extract_year
                  THEN
                     v_deff_rec_type.jan_2 := rec.prem_amt;
                  ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                  THEN
                     v_deff_rec_type.feb_2 := rec.prem_amt;
                  ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                  THEN
                     v_deff_rec_type.mar_2 := rec.prem_amt;
                  ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                  THEN
                     v_deff_rec_type.apr_2 := rec.prem_amt;
                  ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                  THEN
                     v_deff_rec_type.may_2 := rec.prem_amt;
                  ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                  THEN
                     v_deff_rec_type.jun_2 := rec.prem_amt;
                  ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                  THEN
                     v_deff_rec_type.jul_2 := rec.prem_amt;
                  ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                  THEN
                     v_deff_rec_type.aug_2 := rec.prem_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                  THEN
                     v_deff_rec_type.sep_2 := rec.prem_amt;
                  ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                  THEN
                     v_deff_rec_type.oct_2 := rec.prem_amt;
                  ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                  THEN
                     v_deff_rec_type.nov_2 := rec.prem_amt;
                  ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                  THEN
                     v_deff_rec_type.dec_2 := rec.prem_amt;
                  ELSIF v_month = 'JANUARY' AND v_year != rec.extract_year
                  THEN
                     v_deff_rec_type.jan_1 := rec.prem_amt;
                  ELSIF     v_month = 'FEBRUARY'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     v_deff_rec_type.feb_1 := rec.prem_amt;
                  ELSIF v_month = 'MARCH' AND v_year = (rec.extract_year - 1)
                  THEN
                     v_deff_rec_type.mar_1 := rec.prem_amt;
                  ELSIF v_month = 'APRIL' AND v_year = (rec.extract_year - 1)
                  THEN
                     v_deff_rec_type.apr_1 := rec.prem_amt;
                  ELSIF v_month = 'MAY' AND v_year = (rec.extract_year - 1)
                  THEN
                     v_deff_rec_type.may_1 := rec.prem_amt;
                  ELSIF v_month = 'JUNE' AND v_year = (rec.extract_year - 1)
                  THEN
                     v_deff_rec_type.jun_1 := rec.prem_amt;
                  ELSIF v_month = 'JULY' AND v_year = (rec.extract_year - 1)
                  THEN
                     v_deff_rec_type.jul_1 := rec.prem_amt;
                  ELSIF v_month = 'AUGUST' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                  THEN
                     v_deff_rec_type.aug_1 := rec.prem_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year != rec.extract_year
                  THEN
                     v_deff_rec_type.sep_1 := rec.prem_amt;
                  ELSIF v_month = 'OCTOBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     v_deff_rec_type.oct_1 := rec.prem_amt;
                  ELSIF     v_month = 'NOVEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     v_deff_rec_type.nov_1 := rec.prem_amt;
                  ELSIF     v_month = 'DECEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     v_deff_rec_type.dec_1 := rec.prem_amt;
                  END IF;
               END IF;

               v_ctr := v_ctr + 1;
            END LOOP;

            v_ctr := 0;

            FOR f IN
               (SELECT *
                  FROM (SELECT   MONTH, numerator_factor, denominator_factor
                            FROM giac_deferred_factors
                           WHERE procedure_id != 2
                             AND line_cd IS NULL
                             AND def_tag IS NULL
                             AND MONTH >
                                    MONTHS_BETWEEN
                                               (rec.acct_ent_date,
                                                LAST_DAY (rec.effectivity_date)
                                               )
                        ORDER BY line_cd, MONTH) a,
                       (SELECT   MONTH month_mn,
                                 numerator_factor numerator_factor_mn,
                                 numerator_factor denominator_factor_mn,
                                 line_cd line_cd_mn
                            FROM giac_deferred_factors
                           WHERE procedure_id != 2
                             AND line_cd = 'MN'
                             AND def_tag IS NULL
                        ORDER BY line_cd, MONTH) b
                 WHERE a.MONTH(+) = b.month_mn)
            LOOP
               IF f.MONTH != 0
               THEN
                  v_date :=
                     ADD_MONTHS (TRUNC (rec.effectivity_date),
                                 (f.MONTH - 1));

                  IF v_date <=
                        LAST_DAY (TO_DATE (   rec.extract_mm
                                           || '/01/'
                                           || rec.extract_year,
                                           'MM/DD/RRRR'
                                          )
                                 )
                  THEN
                     v_month := TO_CHAR (v_date, 'fmMONTH');
                     v_year := TO_CHAR (v_date, 'fmRRRR');

                     BEGIN
                        SELECT DECODE (rec.line_cd,
                                       v_line_cd_mn, f.numerator_factor_mn
                                        / f.denominator_factor_mn,
                                         f.numerator_factor
                                       / f.denominator_factor
                                      )
                          INTO v_factor
                          FROM DUAL;
                     EXCEPTION
                        WHEN ZERO_DIVIDE
                        THEN
                           v_factor := 0;
                     END;

                     IF v_month = 'JANUARY' AND v_year = rec.extract_year
                     THEN
                        v_deff_rec_type.jan_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                     THEN
                        v_deff_rec_type.feb_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                     THEN
                        v_deff_rec_type.mar_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                     THEN
                        v_deff_rec_type.apr_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                     THEN
                        v_deff_rec_type.may_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                     THEN
                        v_deff_rec_type.jun_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                     THEN
                        v_deff_rec_type.jul_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                     THEN
                        v_deff_rec_type.aug_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                     THEN
                        v_deff_rec_type.sep_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                     THEN
                        v_deff_rec_type.oct_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                     THEN
                        v_deff_rec_type.nov_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                     THEN
                        v_deff_rec_type.dec_2 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'JANUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        v_deff_rec_type.jan_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'FEBRUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        v_deff_rec_type.feb_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'MARCH'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        v_deff_rec_type.mar_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'APRIL'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        v_deff_rec_type.apr_1 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                     THEN
                        v_deff_rec_type.may_1 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'JUNE'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        v_deff_rec_type.jun_1 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'JULY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        v_deff_rec_type.jul_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'AUGUST'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        v_deff_rec_type.aug_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'SEPTEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        v_deff_rec_type.sep_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'OCTOBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        v_deff_rec_type.oct_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'NOVEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        v_deff_rec_type.nov_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'DECEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        v_deff_rec_type.dec_1 := rec.prem_amt * v_factor;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         END IF;

         v_deff_rec_type.policy_id := rec.policy_id;
         v_deff_rec_type.policy_no := rec.policy_no;
         v_deff_rec_type.booking_month := rec.booking_month;
         v_deff_rec_type.booking_year := rec.booking_year;
         v_deff_rec_type.effectivity_date := rec.effectivity_date;
         v_deff_rec_type.acct_ent_date := rec.acct_ent_date;
         v_deff_rec_type.prem_amt := rec.prem_amt;
         v_deff_rec_type.iss_cd := rec.iss_cd;
         v_deff_rec_type.cred_branch := rec.cred_branch;
         v_deff_rec_type.line_cd := rec.line_cd;
         v_deff_rec_type.spoiled_date := rec.spoiled_date;
         v_deff_rec_type.spld_acct_ent_date := rec.spld_acct_ent_date;
         v_deff_rec_type.pol_flag := rec.pol_flag;
         PIPE ROW (v_deff_rec_type);
      END LOOP;
   END;

   FUNCTION get_gross_premium_summary
      RETURN deff_rec_type_sum_table PIPELINED
   IS
      v_deff_rec_type_sum   deff_rec_type_sum;
   BEGIN
      FOR rec IN
         (SELECT   NVL (cred_branch, iss_cd) cred_branch, line_cd,
                   SUM (prem_amt) prem_amt, SUM (jan_1) jan_1,
                   SUM (feb_1) feb_1, SUM (mar_1) mar_1, SUM (apr_1) apr_1,
                   SUM (may_1) may_1, SUM (jun_1) jun_1, SUM (jul_1) jul_1,
                   SUM (aug_1) aug_1, SUM (sep_1) sep_1, SUM (oct_1) oct_1,
                   SUM (nov_1) nov_1, SUM (dec_1) dec_1, SUM (jan_2) jan_2,
                   SUM (feb_2) feb_2, SUM (mar_2) mar_2, SUM (apr_2) apr_2,
                   SUM (may_2) may_2, SUM (jun_2) jun_2, SUM (jul_2) jul_2,
                   SUM (aug_2) aug_2, SUM (sep_2) sep_2, SUM (oct_2) oct_2,
                   SUM (nov_2) nov_2, SUM (dec_2) dec_2
              FROM TABLE (twenty_fourth_validation.get_gross_premium_dtl)
          GROUP BY NVL (cred_branch, iss_cd), line_cd
          ORDER BY cred_branch, line_cd)
      LOOP
         v_deff_rec_type_sum.cred_branch := rec.cred_branch;
         v_deff_rec_type_sum.line_cd := rec.line_cd;
         v_deff_rec_type_sum.prem_amt := rec.prem_amt;
         v_deff_rec_type_sum.jan_1 := rec.jan_1;
         v_deff_rec_type_sum.feb_1 := rec.feb_1;
         v_deff_rec_type_sum.mar_1 := rec.mar_1;
         v_deff_rec_type_sum.apr_1 := rec.apr_1;
         v_deff_rec_type_sum.may_1 := rec.may_1;
         v_deff_rec_type_sum.jun_1 := rec.jun_1;
         v_deff_rec_type_sum.jul_1 := rec.jul_1;
         v_deff_rec_type_sum.aug_1 := rec.aug_1;
         v_deff_rec_type_sum.sep_1 := rec.sep_1;
         v_deff_rec_type_sum.oct_1 := rec.oct_1;
         v_deff_rec_type_sum.nov_1 := rec.nov_1;
         v_deff_rec_type_sum.dec_1 := rec.dec_1;
         v_deff_rec_type_sum.jan_2 := rec.jan_2;
         v_deff_rec_type_sum.feb_2 := rec.feb_2;
         v_deff_rec_type_sum.mar_2 := rec.mar_2;
         v_deff_rec_type_sum.apr_2 := rec.apr_2;
         v_deff_rec_type_sum.may_2 := rec.may_2;
         v_deff_rec_type_sum.jun_2 := rec.jun_2;
         v_deff_rec_type_sum.jul_2 := rec.jul_2;
         v_deff_rec_type_sum.aug_2 := rec.aug_2;
         v_deff_rec_type_sum.sep_2 := rec.sep_2;
         v_deff_rec_type_sum.oct_2 := rec.oct_2;
         v_deff_rec_type_sum.nov_2 := rec.nov_2;
         v_deff_rec_type_sum.dec_2 := rec.dec_2;
         PIPE ROW (v_deff_rec_type_sum);
      END LOOP;
   END;

   FUNCTION get_ri_premium_dtl
      RETURN deff_rec_type_table_ri PIPELINED
   IS
      ri_deff        deff_rec_type_ri;
      v_line_cd_mn   VARCHAR2 (7)     := giisp.v ('LINE_CODE_MN');
      v_date         DATE;
      v_month        VARCHAR2 (30);
      v_factor       NUMBER;
      v_year         NUMBER;
      v_ctr          NUMBER           := 0;
      v_start_date   DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   BEGIN
      FOR rec IN (SELECT *
                    FROM ri_prem_ext)
      LOOP
         ri_deff.jan_1 := NULL;
         ri_deff.feb_1 := NULL;
         ri_deff.mar_1 := NULL;
         ri_deff.apr_1 := NULL;
         ri_deff.may_1 := NULL;
         ri_deff.jun_1 := NULL;
         ri_deff.jul_1 := NULL;
         ri_deff.aug_1 := NULL;
         ri_deff.sep_1 := NULL;
         ri_deff.oct_1 := NULL;
         ri_deff.nov_1 := NULL;
         ri_deff.dec_1 := NULL;
         ri_deff.jan_2 := NULL;
         ri_deff.feb_2 := NULL;
         ri_deff.mar_2 := NULL;
         ri_deff.apr_2 := NULL;
         ri_deff.may_2 := NULL;
         ri_deff.jun_2 := NULL;
         ri_deff.jul_2 := NULL;
         ri_deff.aug_2 := NULL;
         ri_deff.sep_2 := NULL;
         ri_deff.oct_2 := NULL;
         ri_deff.nov_2 := NULL;
         ri_deff.dec_2 := NULL;

         IF TRUNC (rec.effectivity_date) >
               LAST_DAY (ADD_MONTHS (TO_DATE (   rec.extract_mm
                                              || '-'
                                              || rec.extract_year,
                                              'MM-YYYY'
                                             ),
                                     -12
                                    )
                        )
         THEN
            LOOP
               v_date := ADD_MONTHS (rec.acct_ent_date, v_ctr);

               IF v_date >
                     LAST_DAY (TO_DATE (   rec.extract_mm
                                        || '-'
                                        || rec.extract_year,
                                        'MM-YYYY'
                                       )
                              )
               THEN
                  EXIT;
               END IF;

               v_month := TO_CHAR (v_date, 'fmMONTH');
               v_year := TO_CHAR (v_date, 'fmRRRR');

               IF LAST_DAY (v_start_date) <= rec.acct_ent_date
               THEN
                  IF v_month = 'JANUARY' AND v_year = rec.extract_year
                  THEN
                     ri_deff.jan_2 := rec.prem_amt;
                  ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                  THEN
                     ri_deff.feb_2 := rec.prem_amt;
                  ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                  THEN
                     ri_deff.mar_2 := rec.prem_amt;
                  ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                  THEN
                     ri_deff.apr_2 := rec.prem_amt;
                  ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                  THEN
                     ri_deff.may_2 := rec.prem_amt;
                  ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                  THEN
                     ri_deff.jun_2 := rec.prem_amt;
                  ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                  THEN
                     ri_deff.jul_2 := rec.prem_amt;
                  ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                  THEN
                     ri_deff.aug_2 := rec.prem_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                  THEN
                     ri_deff.sep_2 := rec.prem_amt;
                  ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                  THEN
                     ri_deff.oct_2 := rec.prem_amt;
                  ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                  THEN
                     ri_deff.nov_2 := rec.prem_amt;
                  ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                  THEN
                     ri_deff.dec_2 := rec.prem_amt;
                  ELSIF v_month = 'JANUARY' AND v_year != rec.extract_year
                  THEN
                     ri_deff.jan_1 := rec.prem_amt;
                  ELSIF     v_month = 'FEBRUARY'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_deff.feb_1 := rec.prem_amt;
                  ELSIF v_month = 'MARCH' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_deff.mar_1 := rec.prem_amt;
                  ELSIF v_month = 'APRIL' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_deff.apr_1 := rec.prem_amt;
                  ELSIF v_month = 'MAY' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_deff.may_1 := rec.prem_amt;
                  ELSIF v_month = 'JUNE' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_deff.jun_1 := rec.prem_amt;
                  ELSIF v_month = 'JULY' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_deff.jul_1 := rec.prem_amt;
                  ELSIF v_month = 'AUGUST' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                  THEN
                     ri_deff.aug_1 := rec.prem_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year != rec.extract_year
                  THEN
                     ri_deff.sep_1 := rec.prem_amt;
                  ELSIF v_month = 'OCTOBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_deff.oct_1 := rec.prem_amt;
                  ELSIF     v_month = 'NOVEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_deff.nov_1 := rec.prem_amt;
                  ELSIF     v_month = 'DECEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_deff.dec_1 := rec.prem_amt;
                  END IF;
               END IF;

               v_ctr := v_ctr + 1;
            END LOOP;

            v_ctr := 0;

            FOR f IN
               (SELECT *
                  FROM (SELECT   MONTH, numerator_factor, denominator_factor
                            FROM giac_deferred_factors
                           WHERE procedure_id != 2
                             AND line_cd IS NULL
                             AND def_tag IS NULL
                             AND MONTH >
                                    MONTHS_BETWEEN
                                               (rec.acct_ent_date,
                                                LAST_DAY (rec.effectivity_date)
                                               )
                        ORDER BY line_cd, MONTH) a,
                       (SELECT   MONTH month_mn,
                                 numerator_factor numerator_factor_mn,
                                 numerator_factor denominator_factor_mn,
                                 line_cd line_cd_mn
                            FROM giac_deferred_factors
                           WHERE procedure_id != 2
                             AND line_cd = 'MN'
                             AND def_tag IS NULL
                        ORDER BY line_cd, MONTH) b
                 WHERE a.MONTH(+) = b.month_mn)
            LOOP
               IF f.MONTH != 0
               THEN
                  v_date :=
                     ADD_MONTHS (TRUNC (rec.effectivity_date),
                                 (f.MONTH - 1));

                  IF v_date <=
                        LAST_DAY (TO_DATE (   rec.extract_mm
                                           || '/01/'
                                           || rec.extract_year,
                                           'MM/DD/RRRR'
                                          )
                                 )
                  THEN
                     v_month := TO_CHAR (v_date, 'fmMONTH');
                     v_year := TO_CHAR (v_date, 'fmRRRR');

                     BEGIN
                        SELECT DECODE (rec.line_cd,
                                       v_line_cd_mn, f.numerator_factor_mn
                                        / f.denominator_factor_mn,
                                         f.numerator_factor
                                       / f.denominator_factor
                                      )
                          INTO v_factor
                          FROM DUAL;
                     EXCEPTION
                        WHEN ZERO_DIVIDE
                        THEN
                           v_factor := 0;
                     END;

                     IF v_month = 'JANUARY' AND v_year = rec.extract_year
                     THEN
                        ri_deff.jan_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                     THEN
                        ri_deff.feb_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                     THEN
                        ri_deff.mar_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                     THEN
                        ri_deff.apr_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                     THEN
                        ri_deff.may_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                     THEN
                        ri_deff.jun_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                     THEN
                        ri_deff.jul_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                     THEN
                        ri_deff.aug_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                     THEN
                        ri_deff.sep_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                     THEN
                        ri_deff.oct_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                     THEN
                        ri_deff.nov_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                     THEN
                        ri_deff.dec_2 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'JANUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_deff.jan_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'FEBRUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_deff.feb_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'MARCH'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_deff.mar_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'APRIL'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_deff.apr_1 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                     THEN
                        ri_deff.may_1 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'JUNE'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_deff.jun_1 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'JULY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_deff.jul_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'AUGUST'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_deff.aug_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'SEPTEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_deff.sep_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'OCTOBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_deff.oct_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'NOVEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_deff.nov_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'DECEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_deff.dec_1 := rec.prem_amt * v_factor;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         END IF;

         ri_deff.policy_id := rec.policy_id;
         ri_deff.policy_no := rec.policy_no;
         ri_deff.booking_month := rec.booking_month;
         ri_deff.booking_year := rec.booking_year;
         ri_deff.effectivity_date := rec.effectivity_date;
         ri_deff.acct_ent_date := rec.acct_ent_date;
         ri_deff.prem_amt := rec.prem_amt;
         ri_deff.iss_cd := rec.iss_cd;
         ri_deff.cred_branch := rec.cred_branch;
         ri_deff.line_cd := rec.line_cd;
         ri_deff.spoiled_date := rec.spld_date;
         ri_deff.spld_acct_ent_date := rec.spld_acct_ent_date;
         ri_deff.pol_flag := rec.pol_flag;
         PIPE ROW (ri_deff);
      END LOOP;
   END;

   FUNCTION get_ri_premium_summary
      RETURN deff_rec_type_sum_table PIPELINED
   IS
      ri_deff_sum   deff_rec_type_sum;
   BEGIN
      FOR rec IN (SELECT   NVL (cred_branch, iss_cd) cred_branch, line_cd,
                           SUM (prem_amt) prem_amt, SUM (jan_1) jan_1,
                           SUM (feb_1) feb_1, SUM (mar_1) mar_1,
                           SUM (apr_1) apr_1, SUM (may_1) may_1,
                           SUM (jun_1) jun_1, SUM (jul_1) jul_1,
                           SUM (aug_1) aug_1, SUM (sep_1) sep_1,
                           SUM (oct_1) oct_1, SUM (nov_1) nov_1,
                           SUM (dec_1) dec_1, SUM (jan_2) jan_2,
                           SUM (feb_2) feb_2, SUM (mar_2) mar_2,
                           SUM (apr_2) apr_2, SUM (may_2) may_2,
                           SUM (jun_2) jun_2, SUM (jul_2) jul_2,
                           SUM (aug_2) aug_2, SUM (sep_2) sep_2,
                           SUM (oct_2) oct_2, SUM (nov_2) nov_2,
                           SUM (dec_2) dec_2
                      FROM TABLE (twenty_fourth_validation.get_ri_premium_dtl)
                  GROUP BY NVL (cred_branch, iss_cd), line_cd
                  ORDER BY cred_branch, line_cd)
      LOOP
         ri_deff_sum.cred_branch := rec.cred_branch;
         ri_deff_sum.line_cd := rec.line_cd;
         ri_deff_sum.prem_amt := rec.prem_amt;
         ri_deff_sum.jan_1 := rec.jan_1;
         ri_deff_sum.feb_1 := rec.feb_1;
         ri_deff_sum.mar_1 := rec.mar_1;
         ri_deff_sum.apr_1 := rec.apr_1;
         ri_deff_sum.may_1 := rec.may_1;
         ri_deff_sum.jun_1 := rec.jun_1;
         ri_deff_sum.jul_1 := rec.jul_1;
         ri_deff_sum.aug_1 := rec.aug_1;
         ri_deff_sum.sep_1 := rec.sep_1;
         ri_deff_sum.oct_1 := rec.oct_1;
         ri_deff_sum.nov_1 := rec.nov_1;
         ri_deff_sum.dec_1 := rec.dec_1;
         ri_deff_sum.jan_2 := rec.jan_2;
         ri_deff_sum.feb_2 := rec.feb_2;
         ri_deff_sum.mar_2 := rec.mar_2;
         ri_deff_sum.apr_2 := rec.apr_2;
         ri_deff_sum.may_2 := rec.may_2;
         ri_deff_sum.jun_2 := rec.jun_2;
         ri_deff_sum.jul_2 := rec.jul_2;
         ri_deff_sum.aug_2 := rec.aug_2;
         ri_deff_sum.sep_2 := rec.sep_2;
         ri_deff_sum.oct_2 := rec.oct_2;
         ri_deff_sum.nov_2 := rec.nov_2;
         ri_deff_sum.dec_2 := rec.dec_2;
         PIPE ROW (ri_deff_sum);
      END LOOP;
   END;

   FUNCTION get_ri_income1_dtl
      RETURN def_ri_comm_income_tab PIPELINED
   IS
      ri_comm_income   def_ri_comm_income;
      v_line_cd_mn     VARCHAR2 (7)       := giisp.v ('LINE_CODE_MN');
      v_date           DATE;
      v_month          VARCHAR2 (30);
      v_factor         NUMBER;
      v_year           NUMBER;
      v_ctr            NUMBER             := 0;
      v_start_date     DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   BEGIN
      FOR rec IN (SELECT *
                    FROM ri_comm_income_ext
                   WHERE extracted_from = 'extract_ri_income1')
      LOOP
         ri_comm_income.jan_1 := NULL;
         ri_comm_income.feb_1 := NULL;
         ri_comm_income.mar_1 := NULL;
         ri_comm_income.apr_1 := NULL;
         ri_comm_income.may_1 := NULL;
         ri_comm_income.jun_1 := NULL;
         ri_comm_income.jul_1 := NULL;
         ri_comm_income.aug_1 := NULL;
         ri_comm_income.sep_1 := NULL;
         ri_comm_income.oct_1 := NULL;
         ri_comm_income.nov_1 := NULL;
         ri_comm_income.dec_1 := NULL;
         ri_comm_income.jan_2 := NULL;
         ri_comm_income.feb_2 := NULL;
         ri_comm_income.mar_2 := NULL;
         ri_comm_income.apr_2 := NULL;
         ri_comm_income.may_2 := NULL;
         ri_comm_income.jun_2 := NULL;
         ri_comm_income.jul_2 := NULL;
         ri_comm_income.aug_2 := NULL;
         ri_comm_income.sep_2 := NULL;
         ri_comm_income.oct_2 := NULL;
         ri_comm_income.nov_2 := NULL;
         ri_comm_income.dec_2 := NULL;

         IF TRUNC (rec.effectivity_date) >
               LAST_DAY (ADD_MONTHS (TO_DATE (   rec.extract_mm
                                              || '-'
                                              || rec.extract_year,
                                              'MM-YYYY'
                                             ),
                                     -12
                                    )
                        )
         THEN
            LOOP
               v_date := ADD_MONTHS (rec.acct_ent_date, v_ctr);

               IF v_date >
                     LAST_DAY (TO_DATE (   rec.extract_mm
                                        || '-'
                                        || rec.extract_year,
                                        'MM-YYYY'
                                       )
                              )
               THEN
                  EXIT;
               END IF;

               v_month := TO_CHAR (v_date, 'fmMONTH');
               v_year := TO_CHAR (v_date, 'fmRRRR');

               IF LAST_DAY (v_start_date) <= rec.acct_ent_date
               THEN
                  IF v_month = 'JANUARY' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.jan_2 := rec.commission_amt;
                  ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.feb_2 := rec.commission_amt;
                  ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.mar_2 := rec.commission_amt;
                  ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.apr_2 := rec.commission_amt;
                  ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.may_2 := rec.commission_amt;
                  ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.jun_2 := rec.commission_amt;
                  ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.jul_2 := rec.commission_amt;
                  ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.aug_2 := rec.commission_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.sep_2 := rec.commission_amt;
                  ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.oct_2 := rec.commission_amt;
                  ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.nov_2 := rec.commission_amt;
                  ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.dec_2 := rec.commission_amt;
                  ELSIF v_month = 'JANUARY' AND v_year != rec.extract_year
                  THEN
                     ri_comm_income.jan_1 := rec.commission_amt;
                  ELSIF     v_month = 'FEBRUARY'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.feb_1 := rec.commission_amt;
                  ELSIF v_month = 'MARCH' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.mar_1 := rec.commission_amt;
                  ELSIF v_month = 'APRIL' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.apr_1 := rec.commission_amt;
                  ELSIF v_month = 'MAY' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.may_1 := rec.commission_amt;
                  ELSIF v_month = 'JUNE' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.jun_1 := rec.commission_amt;
                  ELSIF v_month = 'JULY' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.jul_1 := rec.commission_amt;
                  ELSIF v_month = 'AUGUST' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                  THEN
                     ri_comm_income.aug_1 := rec.commission_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year != rec.extract_year
                  THEN
                     ri_comm_income.sep_1 := rec.commission_amt;
                  ELSIF v_month = 'OCTOBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.oct_1 := rec.commission_amt;
                  ELSIF     v_month = 'NOVEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.nov_1 := rec.commission_amt;
                  ELSIF     v_month = 'DECEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.dec_1 := rec.commission_amt;
                  END IF;
               END IF;

               v_ctr := v_ctr + 1;
            END LOOP;

            v_ctr := 0;

            FOR f IN
               (SELECT *
                  FROM (SELECT   MONTH, numerator_factor, denominator_factor
                            FROM giac_deferred_factors
                           WHERE procedure_id != 2
                             AND line_cd IS NULL
                             AND def_tag IS NULL
                             AND MONTH >
                                    MONTHS_BETWEEN
                                               (rec.acct_ent_date,
                                                LAST_DAY (rec.effectivity_date)
                                               )
                        ORDER BY line_cd, MONTH) a,
                       (SELECT   MONTH month_mn,
                                 numerator_factor numerator_factor_mn,
                                 numerator_factor denominator_factor_mn,
                                 line_cd line_cd_mn
                            FROM giac_deferred_factors
                           WHERE procedure_id != 2
                             AND line_cd = 'MN'
                             AND def_tag IS NULL
                        ORDER BY line_cd, MONTH) b
                 WHERE a.MONTH(+) = b.month_mn)
            LOOP
               IF f.MONTH != 0
               THEN
                  v_date :=
                     ADD_MONTHS (TRUNC (rec.effectivity_date),
                                 (f.MONTH - 1));

                  IF v_date <=
                        LAST_DAY (TO_DATE (   rec.extract_mm
                                           || '/01/'
                                           || rec.extract_year,
                                           'MM/DD/RRRR'
                                          )
                                 )
                  THEN
                     v_month := TO_CHAR (v_date, 'fmMONTH');
                     v_year := TO_CHAR (v_date, 'fmRRRR');

                     BEGIN
                        SELECT DECODE (rec.line_cd,
                                       v_line_cd_mn, f.numerator_factor_mn
                                        / f.denominator_factor_mn,
                                         f.numerator_factor
                                       / f.denominator_factor
                                      )
                          INTO v_factor
                          FROM DUAL;
                     EXCEPTION
                        WHEN ZERO_DIVIDE
                        THEN
                           v_factor := 0;
                     END;

                     IF v_month = 'JANUARY' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.jan_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.feb_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.mar_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.apr_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.may_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.jun_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.jul_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.aug_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.sep_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.oct_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.nov_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.dec_2 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'JANUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.jan_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'FEBRUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.feb_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'MARCH'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.mar_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'APRIL'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.apr_1 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                     THEN
                        ri_comm_income.may_1 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'JUNE'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.jun_1 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'JULY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.jul_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'AUGUST'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.aug_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'SEPTEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.sep_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'OCTOBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.oct_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'NOVEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.nov_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'DECEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.dec_1 := rec.commission_amt * v_factor;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         END IF;

         ri_comm_income.policy_id := rec.policy_id;
         ri_comm_income.policy_no := rec.policy_no;
         ri_comm_income.booking_month := rec.booking_month;
         ri_comm_income.booking_year := rec.booking_year;
         ri_comm_income.effectivity_date := rec.effectivity_date;
         ri_comm_income.acct_ent_date := rec.acct_ent_date;
         ri_comm_income.commission_amt := rec.commission_amt;
         ri_comm_income.iss_cd := rec.iss_cd;
         ri_comm_income.cred_branch := rec.cred_branch;
         ri_comm_income.line_cd := rec.line_cd;
         ri_comm_income.spld_date := rec.spld_date;
         ri_comm_income.spld_acct_ent_date := rec.spld_acct_ent_date;
         ri_comm_income.pol_flag := rec.pol_flag;
         ri_comm_income.acct_trty_type := rec.acct_trty_type;
         ri_comm_income.dist_no := rec.dist_no;
         ri_comm_income.dist_flag := rec.dist_flag;
         ri_comm_income.ri_cd := rec.ri_cd;
         PIPE ROW (ri_comm_income);
      END LOOP;
   END;

   FUNCTION get_ri_income1_summary
      RETURN def_rec_type_sum_tab PIPELINED
   IS
      income_def_sum   def_rec_type_sum;
   BEGIN
      FOR rec IN (SELECT   NVL (cred_branch, iss_cd) cred_branch, line_cd,
                           SUM (commission_amt) commission_amt,
                           SUM (jan_1) jan_1, SUM (feb_1) feb_1,
                           SUM (mar_1) mar_1, SUM (apr_1) apr_1,
                           SUM (may_1) may_1, SUM (jun_1) jun_1,
                           SUM (jul_1) jul_1, SUM (aug_1) aug_1,
                           SUM (sep_1) sep_1, SUM (oct_1) oct_1,
                           SUM (nov_1) nov_1, SUM (dec_1) dec_1,
                           SUM (jan_2) jan_2, SUM (feb_2) feb_2,
                           SUM (mar_2) mar_2, SUM (apr_2) apr_2,
                           SUM (may_2) may_2, SUM (jun_2) jun_2,
                           SUM (jul_2) jul_2, SUM (aug_2) aug_2,
                           SUM (sep_2) sep_2, SUM (oct_2) oct_2,
                           SUM (nov_2) nov_2, SUM (dec_2) dec_2
                      FROM TABLE (twenty_fourth_validation.get_ri_income1_dtl)
                  GROUP BY NVL (cred_branch, iss_cd), line_cd
                  ORDER BY cred_branch, line_cd)
      LOOP
         income_def_sum.cred_branch := rec.cred_branch;
         income_def_sum.line_cd := rec.line_cd;
         income_def_sum.comm_amt := rec.commission_amt;
         income_def_sum.jan_1 := rec.jan_1;
         income_def_sum.feb_1 := rec.feb_1;
         income_def_sum.mar_1 := rec.mar_1;
         income_def_sum.apr_1 := rec.apr_1;
         income_def_sum.may_1 := rec.may_1;
         income_def_sum.jun_1 := rec.jun_1;
         income_def_sum.jul_1 := rec.jul_1;
         income_def_sum.aug_1 := rec.aug_1;
         income_def_sum.sep_1 := rec.sep_1;
         income_def_sum.oct_1 := rec.oct_1;
         income_def_sum.nov_1 := rec.nov_1;
         income_def_sum.dec_1 := rec.dec_1;
         income_def_sum.jan_2 := rec.jan_2;
         income_def_sum.feb_2 := rec.feb_2;
         income_def_sum.mar_2 := rec.mar_2;
         income_def_sum.apr_2 := rec.apr_2;
         income_def_sum.may_2 := rec.may_2;
         income_def_sum.jun_2 := rec.jun_2;
         income_def_sum.jul_2 := rec.jul_2;
         income_def_sum.aug_2 := rec.aug_2;
         income_def_sum.sep_2 := rec.sep_2;
         income_def_sum.oct_2 := rec.oct_2;
         income_def_sum.nov_2 := rec.nov_2;
         income_def_sum.dec_2 := rec.dec_2;
         PIPE ROW (income_def_sum);
      END LOOP;
   END;

   FUNCTION get_ri_income2_dtl
      RETURN def_ri_comm_income_tab PIPELINED
   IS
      ri_comm_income   def_ri_comm_income;
      v_line_cd_mn     VARCHAR2 (7)       := giisp.v ('LINE_CODE_MN');
      v_date           DATE;
      v_month          VARCHAR2 (30);
      v_factor         NUMBER;
      v_year           NUMBER;
      v_ctr            NUMBER             := 0;
      v_start_date     DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   BEGIN
      FOR rec IN (SELECT *
                    FROM ri_comm_income_ext
                   WHERE extracted_from = 'extract_ri_income2')
      LOOP
         ri_comm_income.jan_1 := NULL;
         ri_comm_income.feb_1 := NULL;
         ri_comm_income.mar_1 := NULL;
         ri_comm_income.apr_1 := NULL;
         ri_comm_income.may_1 := NULL;
         ri_comm_income.jun_1 := NULL;
         ri_comm_income.jul_1 := NULL;
         ri_comm_income.aug_1 := NULL;
         ri_comm_income.sep_1 := NULL;
         ri_comm_income.oct_1 := NULL;
         ri_comm_income.nov_1 := NULL;
         ri_comm_income.dec_1 := NULL;
         ri_comm_income.jan_2 := NULL;
         ri_comm_income.feb_2 := NULL;
         ri_comm_income.mar_2 := NULL;
         ri_comm_income.apr_2 := NULL;
         ri_comm_income.may_2 := NULL;
         ri_comm_income.jun_2 := NULL;
         ri_comm_income.jul_2 := NULL;
         ri_comm_income.aug_2 := NULL;
         ri_comm_income.sep_2 := NULL;
         ri_comm_income.oct_2 := NULL;
         ri_comm_income.nov_2 := NULL;
         ri_comm_income.dec_2 := NULL;

         IF TRUNC (rec.effectivity_date) >
               LAST_DAY (ADD_MONTHS (TO_DATE (   rec.extract_mm
                                              || '-'
                                              || rec.extract_year,
                                              'MM-YYYY'
                                             ),
                                     -12
                                    )
                        )
         THEN
            LOOP
               v_date := ADD_MONTHS (rec.acct_ent_date, v_ctr);

               IF v_date >
                     LAST_DAY (TO_DATE (   rec.extract_mm
                                        || '-'
                                        || rec.extract_year,
                                        'MM-YYYY'
                                       )
                              )
               THEN
                  EXIT;
               END IF;

               v_month := TO_CHAR (v_date, 'fmMONTH');
               v_year := TO_CHAR (v_date, 'fmRRRR');

               IF LAST_DAY (v_start_date) <= rec.acct_ent_date
               THEN
                  IF v_month = 'JANUARY' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.jan_2 := rec.commission_amt;
                  ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.feb_2 := rec.commission_amt;
                  ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.mar_2 := rec.commission_amt;
                  ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.apr_2 := rec.commission_amt;
                  ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.may_2 := rec.commission_amt;
                  ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.jun_2 := rec.commission_amt;
                  ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.jul_2 := rec.commission_amt;
                  ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.aug_2 := rec.commission_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.sep_2 := rec.commission_amt;
                  ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.oct_2 := rec.commission_amt;
                  ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.nov_2 := rec.commission_amt;
                  ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.dec_2 := rec.commission_amt;
                  ELSIF v_month = 'JANUARY' AND v_year != rec.extract_year
                  THEN
                     ri_comm_income.jan_1 := rec.commission_amt;
                  ELSIF     v_month = 'FEBRUARY'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.feb_1 := rec.commission_amt;
                  ELSIF v_month = 'MARCH' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.mar_1 := rec.commission_amt;
                  ELSIF v_month = 'APRIL' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.apr_1 := rec.commission_amt;
                  ELSIF v_month = 'MAY' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.may_1 := rec.commission_amt;
                  ELSIF v_month = 'JUNE' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.jun_1 := rec.commission_amt;
                  ELSIF v_month = 'JULY' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.jul_1 := rec.commission_amt;
                  ELSIF v_month = 'AUGUST' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                  THEN
                     ri_comm_income.aug_1 := rec.commission_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year != rec.extract_year
                  THEN
                     ri_comm_income.sep_1 := rec.commission_amt;
                  ELSIF v_month = 'OCTOBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.oct_1 := rec.commission_amt;
                  ELSIF     v_month = 'NOVEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.nov_1 := rec.commission_amt;
                  ELSIF     v_month = 'DECEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.dec_1 := rec.commission_amt;
                  END IF;
               END IF;

               v_ctr := v_ctr + 1;
            END LOOP;

            v_ctr := 0;

            FOR f IN
               (SELECT *
                  FROM (SELECT   MONTH, numerator_factor, denominator_factor
                            FROM giac_deferred_factors
                           WHERE procedure_id != 2
                             AND line_cd IS NULL
                             AND def_tag IS NULL
                             AND MONTH >
                                    MONTHS_BETWEEN
                                               (rec.acct_ent_date,
                                                LAST_DAY (rec.effectivity_date)
                                               )
                        ORDER BY line_cd, MONTH) a,
                       (SELECT   MONTH month_mn,
                                 numerator_factor numerator_factor_mn,
                                 numerator_factor denominator_factor_mn,
                                 line_cd line_cd_mn
                            FROM giac_deferred_factors
                           WHERE procedure_id != 2
                             AND line_cd = 'MN'
                             AND def_tag IS NULL
                        ORDER BY line_cd, MONTH) b
                 WHERE a.MONTH(+) = b.month_mn)
            LOOP
               IF f.MONTH != 0
               THEN
                  v_date :=
                     ADD_MONTHS (TRUNC (rec.effectivity_date),
                                 (f.MONTH - 1));

                  IF v_date <=
                        LAST_DAY (TO_DATE (   rec.extract_mm
                                           || '/01/'
                                           || rec.extract_year,
                                           'MM/DD/RRRR'
                                          )
                                 )
                  THEN
                     v_month := TO_CHAR (v_date, 'fmMONTH');
                     v_year := TO_CHAR (v_date, 'fmRRRR');

                     BEGIN
                        SELECT DECODE (rec.line_cd,
                                       v_line_cd_mn, f.numerator_factor_mn
                                        / f.denominator_factor_mn,
                                         f.numerator_factor
                                       / f.denominator_factor
                                      )
                          INTO v_factor
                          FROM DUAL;
                     EXCEPTION
                        WHEN ZERO_DIVIDE
                        THEN
                           v_factor := 0;
                     END;

                     IF v_month = 'JANUARY' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.jan_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.feb_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.mar_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.apr_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.may_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.jun_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.jul_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.aug_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.sep_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.oct_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.nov_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.dec_2 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'JANUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.jan_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'FEBRUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.feb_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'MARCH'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.mar_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'APRIL'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.apr_1 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                     THEN
                        ri_comm_income.may_1 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'JUNE'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.jun_1 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'JULY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.jul_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'AUGUST'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.aug_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'SEPTEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.sep_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'OCTOBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.oct_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'NOVEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.nov_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'DECEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.dec_1 := rec.commission_amt * v_factor;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         END IF;

         ri_comm_income.policy_id := rec.policy_id;
         ri_comm_income.policy_no := rec.policy_no;
         ri_comm_income.booking_month := rec.booking_month;
         ri_comm_income.booking_year := rec.booking_year;
         ri_comm_income.effectivity_date := rec.effectivity_date;
         ri_comm_income.acct_ent_date := rec.acct_ent_date;
         ri_comm_income.commission_amt := rec.commission_amt;
         ri_comm_income.iss_cd := rec.iss_cd;
         ri_comm_income.cred_branch := rec.cred_branch;
         ri_comm_income.line_cd := rec.line_cd;
         ri_comm_income.spld_date := rec.spld_date;
         ri_comm_income.spld_acct_ent_date := rec.spld_acct_ent_date;
         ri_comm_income.pol_flag := rec.pol_flag;
         ri_comm_income.acct_trty_type := rec.acct_trty_type;
         ri_comm_income.dist_no := rec.dist_no;
         ri_comm_income.dist_flag := rec.dist_flag;
         ri_comm_income.ri_cd := rec.ri_cd;
         PIPE ROW (ri_comm_income);
      END LOOP;
   END;

   FUNCTION get_ri_income2_summary
      RETURN def_rec_type_sum_tab PIPELINED
   IS
      income_def_sum   def_rec_type_sum;
   BEGIN
      FOR rec IN (SELECT   NVL (cred_branch, iss_cd) cred_branch, line_cd,
                           SUM (commission_amt) commission_amt,
                           SUM (jan_1) jan_1, SUM (feb_1) feb_1,
                           SUM (mar_1) mar_1, SUM (apr_1) apr_1,
                           SUM (may_1) may_1, SUM (jun_1) jun_1,
                           SUM (jul_1) jul_1, SUM (aug_1) aug_1,
                           SUM (sep_1) sep_1, SUM (oct_1) oct_1,
                           SUM (nov_1) nov_1, SUM (dec_1) dec_1,
                           SUM (jan_2) jan_2, SUM (feb_2) feb_2,
                           SUM (mar_2) mar_2, SUM (apr_2) apr_2,
                           SUM (may_2) may_2, SUM (jun_2) jun_2,
                           SUM (jul_2) jul_2, SUM (aug_2) aug_2,
                           SUM (sep_2) sep_2, SUM (oct_2) oct_2,
                           SUM (nov_2) nov_2, SUM (dec_2) dec_2
                      FROM TABLE (twenty_fourth_validation.get_ri_income2_dtl)
                  GROUP BY NVL (cred_branch, iss_cd), line_cd
                  ORDER BY cred_branch, line_cd)
      LOOP
         income_def_sum.cred_branch := rec.cred_branch;
         income_def_sum.line_cd := rec.line_cd;
         income_def_sum.comm_amt := rec.commission_amt;
         income_def_sum.jan_1 := rec.jan_1;
         income_def_sum.feb_1 := rec.feb_1;
         income_def_sum.mar_1 := rec.mar_1;
         income_def_sum.apr_1 := rec.apr_1;
         income_def_sum.may_1 := rec.may_1;
         income_def_sum.jun_1 := rec.jun_1;
         income_def_sum.jul_1 := rec.jul_1;
         income_def_sum.aug_1 := rec.aug_1;
         income_def_sum.sep_1 := rec.sep_1;
         income_def_sum.oct_1 := rec.oct_1;
         income_def_sum.nov_1 := rec.nov_1;
         income_def_sum.dec_1 := rec.dec_1;
         income_def_sum.jan_2 := rec.jan_2;
         income_def_sum.feb_2 := rec.feb_2;
         income_def_sum.mar_2 := rec.mar_2;
         income_def_sum.apr_2 := rec.apr_2;
         income_def_sum.may_2 := rec.may_2;
         income_def_sum.jun_2 := rec.jun_2;
         income_def_sum.jul_2 := rec.jul_2;
         income_def_sum.aug_2 := rec.aug_2;
         income_def_sum.sep_2 := rec.sep_2;
         income_def_sum.oct_2 := rec.oct_2;
         income_def_sum.nov_2 := rec.nov_2;
         income_def_sum.dec_2 := rec.dec_2;
         PIPE ROW (income_def_sum);
      END LOOP;
   END;

   FUNCTION get_all_ri_income_dtl
      RETURN def_ri_comm_income_tab PIPELINED
   IS
      ri_comm_income   def_ri_comm_income;
      v_line_cd_mn     VARCHAR2 (7)       := giisp.v ('LINE_CODE_MN');
      v_date           DATE;
      v_month          VARCHAR2 (30);
      v_factor         NUMBER;
      v_year           NUMBER;
      v_ctr            NUMBER             := 0;
      v_start_date     DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   BEGIN
      FOR rec IN (SELECT *
                    FROM ri_comm_income_ext)
      LOOP
         ri_comm_income.jan_1 := NULL;
         ri_comm_income.feb_1 := NULL;
         ri_comm_income.mar_1 := NULL;
         ri_comm_income.apr_1 := NULL;
         ri_comm_income.may_1 := NULL;
         ri_comm_income.jun_1 := NULL;
         ri_comm_income.jul_1 := NULL;
         ri_comm_income.aug_1 := NULL;
         ri_comm_income.sep_1 := NULL;
         ri_comm_income.oct_1 := NULL;
         ri_comm_income.nov_1 := NULL;
         ri_comm_income.dec_1 := NULL;
         ri_comm_income.jan_2 := NULL;
         ri_comm_income.feb_2 := NULL;
         ri_comm_income.mar_2 := NULL;
         ri_comm_income.apr_2 := NULL;
         ri_comm_income.may_2 := NULL;
         ri_comm_income.jun_2 := NULL;
         ri_comm_income.jul_2 := NULL;
         ri_comm_income.aug_2 := NULL;
         ri_comm_income.sep_2 := NULL;
         ri_comm_income.oct_2 := NULL;
         ri_comm_income.nov_2 := NULL;
         ri_comm_income.dec_2 := NULL;

         IF TRUNC (rec.effectivity_date) >
               LAST_DAY (ADD_MONTHS (TO_DATE (   rec.extract_mm
                                              || '-'
                                              || rec.extract_year,
                                              'MM-YYYY'
                                             ),
                                     -12
                                    )
                        )
         THEN
            LOOP
               v_date := ADD_MONTHS (rec.acct_ent_date, v_ctr);

               IF v_date >
                     LAST_DAY (TO_DATE (   rec.extract_mm
                                        || '-'
                                        || rec.extract_year,
                                        'MM-YYYY'
                                       )
                              )
               THEN
                  EXIT;
               END IF;

               v_month := TO_CHAR (v_date, 'fmMONTH');
               v_year := TO_CHAR (v_date, 'fmRRRR');

               IF LAST_DAY (v_start_date) <= rec.acct_ent_date
               THEN
                  IF v_month = 'JANUARY' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.jan_2 := rec.commission_amt;
                  ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.feb_2 := rec.commission_amt;
                  ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.mar_2 := rec.commission_amt;
                  ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.apr_2 := rec.commission_amt;
                  ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.may_2 := rec.commission_amt;
                  ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.jun_2 := rec.commission_amt;
                  ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.jul_2 := rec.commission_amt;
                  ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.aug_2 := rec.commission_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.sep_2 := rec.commission_amt;
                  ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.oct_2 := rec.commission_amt;
                  ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.nov_2 := rec.commission_amt;
                  ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                  THEN
                     ri_comm_income.dec_2 := rec.commission_amt;
                  ELSIF v_month = 'JANUARY' AND v_year != rec.extract_year
                  THEN
                     ri_comm_income.jan_1 := rec.commission_amt;
                  ELSIF     v_month = 'FEBRUARY'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.feb_1 := rec.commission_amt;
                  ELSIF v_month = 'MARCH' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.mar_1 := rec.commission_amt;
                  ELSIF v_month = 'APRIL' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.apr_1 := rec.commission_amt;
                  ELSIF v_month = 'MAY' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.may_1 := rec.commission_amt;
                  ELSIF v_month = 'JUNE' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.jun_1 := rec.commission_amt;
                  ELSIF v_month = 'JULY' AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.jul_1 := rec.commission_amt;
                  ELSIF v_month = 'AUGUST' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                  THEN
                     ri_comm_income.aug_1 := rec.commission_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year != rec.extract_year
                  THEN
                     ri_comm_income.sep_1 := rec.commission_amt;
                  ELSIF v_month = 'OCTOBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.oct_1 := rec.commission_amt;
                  ELSIF     v_month = 'NOVEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.nov_1 := rec.commission_amt;
                  ELSIF     v_month = 'DECEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     ri_comm_income.dec_1 := rec.commission_amt;
                  END IF;
               END IF;

               v_ctr := v_ctr + 1;
            END LOOP;

            v_ctr := 0;

            FOR f IN
               (SELECT *
                  FROM (SELECT   MONTH, numerator_factor, denominator_factor
                            FROM giac_deferred_factors
                           WHERE procedure_id != 2
                             AND line_cd IS NULL
                             AND def_tag IS NULL
                             AND MONTH >
                                    MONTHS_BETWEEN
                                               (rec.acct_ent_date,
                                                LAST_DAY (rec.effectivity_date)
                                               )
                        ORDER BY line_cd, MONTH) a,
                       (SELECT   MONTH month_mn,
                                 numerator_factor numerator_factor_mn,
                                 numerator_factor denominator_factor_mn,
                                 line_cd line_cd_mn
                            FROM giac_deferred_factors
                           WHERE procedure_id != 2
                             AND line_cd = 'MN'
                             AND def_tag IS NULL
                        ORDER BY line_cd, MONTH) b
                 WHERE a.MONTH(+) = b.month_mn)
            LOOP
               IF f.MONTH != 0
               THEN
                  v_date :=
                     ADD_MONTHS (TRUNC (rec.effectivity_date),
                                 (f.MONTH - 1));

                  IF v_date <=
                        LAST_DAY (TO_DATE (   rec.extract_mm
                                           || '/01/'
                                           || rec.extract_year,
                                           'MM/DD/RRRR'
                                          )
                                 )
                  THEN
                     v_month := TO_CHAR (v_date, 'fmMONTH');
                     v_year := TO_CHAR (v_date, 'fmRRRR');

                     BEGIN
                        SELECT DECODE (rec.line_cd,
                                       v_line_cd_mn, f.numerator_factor_mn
                                        / f.denominator_factor_mn,
                                         f.numerator_factor
                                       / f.denominator_factor
                                      )
                          INTO v_factor
                          FROM DUAL;
                     EXCEPTION
                        WHEN ZERO_DIVIDE
                        THEN
                           v_factor := 0;
                     END;

                     IF v_month = 'JANUARY' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.jan_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.feb_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.mar_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.apr_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.may_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.jun_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.jul_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.aug_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.sep_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.oct_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.nov_2 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                     THEN
                        ri_comm_income.dec_2 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'JANUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.jan_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'FEBRUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.feb_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'MARCH'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.mar_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'APRIL'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.apr_1 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                     THEN
                        ri_comm_income.may_1 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'JUNE'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.jun_1 := rec.commission_amt * v_factor;
                     ELSIF v_month = 'JULY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.jul_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'AUGUST'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.aug_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'SEPTEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.sep_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'OCTOBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.oct_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'NOVEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.nov_1 := rec.commission_amt * v_factor;
                     ELSIF     v_month = 'DECEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        ri_comm_income.dec_1 := rec.commission_amt * v_factor;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         END IF;

         ri_comm_income.policy_id := rec.policy_id;
         ri_comm_income.policy_no := rec.policy_no;
         ri_comm_income.booking_month := rec.booking_month;
         ri_comm_income.booking_year := rec.booking_year;
         ri_comm_income.effectivity_date := rec.effectivity_date;
         ri_comm_income.acct_ent_date := rec.acct_ent_date;
         ri_comm_income.commission_amt := rec.commission_amt;
         ri_comm_income.iss_cd := rec.iss_cd;
         ri_comm_income.cred_branch := rec.cred_branch;
         ri_comm_income.line_cd := rec.line_cd;
         ri_comm_income.spld_date := rec.spld_date;
         ri_comm_income.spld_acct_ent_date := rec.spld_acct_ent_date;
         ri_comm_income.pol_flag := rec.pol_flag;
         ri_comm_income.acct_trty_type := rec.acct_trty_type;
         ri_comm_income.dist_no := rec.dist_no;
         ri_comm_income.dist_flag := rec.dist_flag;
         ri_comm_income.ri_cd := rec.ri_cd;
         PIPE ROW (ri_comm_income);
      END LOOP;
   END;

   FUNCTION get_all_ri_income_summary
      RETURN def_rec_type_sum_tab PIPELINED
   IS
      income_def_sum   def_rec_type_sum;
   BEGIN
      FOR rec IN
         (SELECT   NVL (cred_branch, iss_cd) cred_branch, line_cd,
                   SUM (commission_amt) commission_amt, SUM (jan_1) jan_1,
                   SUM (feb_1) feb_1, SUM (mar_1) mar_1, SUM (apr_1) apr_1,
                   SUM (may_1) may_1, SUM (jun_1) jun_1, SUM (jul_1) jul_1,
                   SUM (aug_1) aug_1, SUM (sep_1) sep_1, SUM (oct_1) oct_1,
                   SUM (nov_1) nov_1, SUM (dec_1) dec_1, SUM (jan_2) jan_2,
                   SUM (feb_2) feb_2, SUM (mar_2) mar_2, SUM (apr_2) apr_2,
                   SUM (may_2) may_2, SUM (jun_2) jun_2, SUM (jul_2) jul_2,
                   SUM (aug_2) aug_2, SUM (sep_2) sep_2, SUM (oct_2) oct_2,
                   SUM (nov_2) nov_2, SUM (dec_2) dec_2
              FROM TABLE (twenty_fourth_validation.get_all_ri_income_dtl)
          GROUP BY NVL (cred_branch, iss_cd), line_cd
          ORDER BY cred_branch, line_cd)
      LOOP
         income_def_sum.cred_branch := rec.cred_branch;
         income_def_sum.line_cd := rec.line_cd;
         income_def_sum.comm_amt := rec.commission_amt;
         income_def_sum.jan_1 := rec.jan_1;
         income_def_sum.feb_1 := rec.feb_1;
         income_def_sum.mar_1 := rec.mar_1;
         income_def_sum.apr_1 := rec.apr_1;
         income_def_sum.may_1 := rec.may_1;
         income_def_sum.jun_1 := rec.jun_1;
         income_def_sum.jul_1 := rec.jul_1;
         income_def_sum.aug_1 := rec.aug_1;
         income_def_sum.sep_1 := rec.sep_1;
         income_def_sum.oct_1 := rec.oct_1;
         income_def_sum.nov_1 := rec.nov_1;
         income_def_sum.dec_1 := rec.dec_1;
         income_def_sum.jan_2 := rec.jan_2;
         income_def_sum.feb_2 := rec.feb_2;
         income_def_sum.mar_2 := rec.mar_2;
         income_def_sum.apr_2 := rec.apr_2;
         income_def_sum.may_2 := rec.may_2;
         income_def_sum.jun_2 := rec.jun_2;
         income_def_sum.jul_2 := rec.jul_2;
         income_def_sum.aug_2 := rec.aug_2;
         income_def_sum.sep_2 := rec.sep_2;
         income_def_sum.oct_2 := rec.oct_2;
         income_def_sum.nov_2 := rec.nov_2;
         income_def_sum.dec_2 := rec.dec_2;
         PIPE ROW (income_def_sum);
      END LOOP;
   END;

   FUNCTION get_facul_prem_dtl
      RETURN def_facul_prem_tab PIPELINED
   IS
      facul_prem     def_facul_prem;
      v_line_cd_mn   VARCHAR2 (7)   := giisp.v ('LINE_CODE_MN');
      v_date         DATE;
      v_month        VARCHAR2 (30);
      v_factor       NUMBER;
      v_year         NUMBER;
      v_ctr          NUMBER         := 0;
      v_start_date   DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   BEGIN
      FOR rec IN (SELECT *
                    FROM ri_facul_prem_ext)
      LOOP
         facul_prem.jan_1 := NULL;
         facul_prem.feb_1 := NULL;
         facul_prem.mar_1 := NULL;
         facul_prem.apr_1 := NULL;
         facul_prem.may_1 := NULL;
         facul_prem.jun_1 := NULL;
         facul_prem.jul_1 := NULL;
         facul_prem.aug_1 := NULL;
         facul_prem.sep_1 := NULL;
         facul_prem.oct_1 := NULL;
         facul_prem.nov_1 := NULL;
         facul_prem.dec_1 := NULL;
         facul_prem.jan_2 := NULL;
         facul_prem.feb_2 := NULL;
         facul_prem.mar_2 := NULL;
         facul_prem.apr_2 := NULL;
         facul_prem.may_2 := NULL;
         facul_prem.jun_2 := NULL;
         facul_prem.jul_2 := NULL;
         facul_prem.aug_2 := NULL;
         facul_prem.sep_2 := NULL;
         facul_prem.oct_2 := NULL;
         facul_prem.nov_2 := NULL;
         facul_prem.dec_2 := NULL;

         IF TRUNC (rec.effectivity_date) >
               LAST_DAY (ADD_MONTHS (TO_DATE (   rec.extract_mm
                                              || '-'
                                              || rec.extract_year,
                                              'MM-YYYY'
                                             ),
                                     -12
                                    )
                        )
         THEN
            LOOP
               v_date := ADD_MONTHS (rec.acct_ent_date, v_ctr);
               
               IF v_date >
                     LAST_DAY (TO_DATE (   rec.extract_mm
                                        || '-'
                                        || rec.extract_year,
                                        'MM-YYYY'
                                       )
                              )
               THEN
                  EXIT;
               END IF;

               v_month := TO_CHAR (v_date, 'fmMONTH');
               v_year := TO_CHAR (v_date, 'fmRRRR');

               IF LAST_DAY (v_start_date) <= rec.acct_ent_date
               THEN
                  IF v_month = 'JANUARY' AND v_year = rec.extract_year
                  THEN
                     facul_prem.jan_2 := rec.prem_amt;
                  ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                  THEN
                     facul_prem.feb_2 := rec.prem_amt;
                  ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                  THEN
                     facul_prem.mar_2 := rec.prem_amt;
                  ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                  THEN
                     facul_prem.apr_2 := rec.prem_amt;
                  ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                  THEN
                     facul_prem.may_2 := rec.prem_amt;
                  ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                  THEN
                     facul_prem.jun_2 := rec.prem_amt;
                  ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                  THEN
                     facul_prem.jul_2 := rec.prem_amt;
                  ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                  THEN
                     facul_prem.aug_2 := rec.prem_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                  THEN
                     facul_prem.sep_2 := rec.prem_amt;
                  ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                  THEN
                     facul_prem.oct_2 := rec.prem_amt;
                  ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                  THEN
                     facul_prem.nov_2 := rec.prem_amt;
                  ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                  THEN
                     facul_prem.dec_2 := rec.prem_amt;
                  ELSIF v_month = 'JANUARY' AND v_year != rec.extract_year
                  THEN
                     facul_prem.jan_1 := rec.prem_amt;
                  ELSIF     v_month = 'FEBRUARY'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     facul_prem.feb_1 := rec.prem_amt;
                  ELSIF v_month = 'MARCH' AND v_year = (rec.extract_year - 1)
                  THEN
                     facul_prem.mar_1 := rec.prem_amt;
                  ELSIF v_month = 'APRIL' AND v_year = (rec.extract_year - 1)
                  THEN
                     facul_prem.apr_1 := rec.prem_amt;
                  ELSIF v_month = 'MAY' AND v_year = (rec.extract_year - 1)
                  THEN
                     facul_prem.may_1 := rec.prem_amt;
                  ELSIF v_month = 'JUNE' AND v_year = (rec.extract_year - 1)
                  THEN
                     facul_prem.jun_1 := rec.prem_amt;
                  ELSIF v_month = 'JULY' AND v_year = (rec.extract_year - 1)
                  THEN
                     facul_prem.jul_1 := rec.prem_amt;
                  ELSIF v_month = 'AUGUST' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                  THEN
                     facul_prem.aug_1 := rec.prem_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year != rec.extract_year
                  THEN
                     facul_prem.sep_1 := rec.prem_amt;
                  ELSIF v_month = 'OCTOBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     facul_prem.oct_1 := rec.prem_amt;
                  ELSIF     v_month = 'NOVEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     facul_prem.nov_1 := rec.prem_amt;
                  ELSIF     v_month = 'DECEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     facul_prem.dec_1 := rec.prem_amt;
                  END IF;
               END IF;

               v_ctr := v_ctr + 1;
            END LOOP;

            v_ctr := 0;

            FOR f IN
               (SELECT *
                  FROM (SELECT   MONTH, numerator_factor, denominator_factor
                            FROM giac_deferred_factors
                           WHERE procedure_id != 2
                             AND line_cd IS NULL
                             AND def_tag IS NULL
                             AND MONTH >
                                    MONTHS_BETWEEN
                                               (rec.acct_ent_date,
                                                LAST_DAY (rec.effectivity_date)
                                               )
                        ORDER BY line_cd, MONTH) a,
                       (SELECT   MONTH month_mn,
                                 numerator_factor numerator_factor_mn,
                                 numerator_factor denominator_factor_mn,
                                 line_cd line_cd_mn
                            FROM giac_deferred_factors
                           WHERE procedure_id != 2
                             AND line_cd = 'MN'
                             AND def_tag IS NULL
                        ORDER BY line_cd, MONTH) b
                 WHERE a.MONTH(+) = b.month_mn)
            LOOP
               IF f.MONTH != 0
               THEN
                  v_date :=
                     ADD_MONTHS (TRUNC (rec.effectivity_date),
                                 (f.MONTH - 1));

                  IF v_date <=
                        LAST_DAY (TO_DATE (   rec.extract_mm
                                           || '/01/'
                                           || rec.extract_year,
                                           'MM/DD/RRRR'
                                          )
                                 )
                  THEN
                     v_month := TO_CHAR (v_date, 'fmMONTH');
                     v_year := TO_CHAR (v_date, 'fmRRRR');

                     BEGIN
                        SELECT DECODE (rec.line_cd,
                                       v_line_cd_mn, f.numerator_factor_mn
                                        / f.denominator_factor_mn,
                                         f.numerator_factor
                                       / f.denominator_factor
                                      )
                          INTO v_factor
                          FROM DUAL;
                     EXCEPTION
                        WHEN ZERO_DIVIDE
                        THEN
                           v_factor := 0;
                     END;

                     IF v_month = 'JANUARY' AND v_year = rec.extract_year
                     THEN
                        facul_prem.jan_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                     THEN
                        facul_prem.feb_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                     THEN
                        facul_prem.mar_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                     THEN
                        facul_prem.apr_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                     THEN
                        facul_prem.may_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                     THEN
                        facul_prem.jun_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                     THEN
                        facul_prem.jul_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                     THEN
                        facul_prem.aug_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                     THEN
                        facul_prem.sep_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                     THEN
                        facul_prem.oct_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                     THEN
                        facul_prem.nov_2 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                     THEN
                        facul_prem.dec_2 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'JANUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        facul_prem.jan_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'FEBRUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        facul_prem.feb_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'MARCH'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        facul_prem.mar_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'APRIL'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        facul_prem.apr_1 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                     THEN
                        facul_prem.may_1 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'JUNE'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        facul_prem.jun_1 := rec.prem_amt * v_factor;
                     ELSIF v_month = 'JULY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        facul_prem.jul_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'AUGUST'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        facul_prem.aug_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'SEPTEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        facul_prem.sep_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'OCTOBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        facul_prem.oct_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'NOVEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        facul_prem.nov_1 := rec.prem_amt * v_factor;
                     ELSIF     v_month = 'DECEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        facul_prem.dec_1 := rec.prem_amt * v_factor;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         END IF;

         facul_prem.policy_id := rec.policy_id;
         facul_prem.policy_no := rec.policy_no;
         facul_prem.booking_month := rec.booking_month;
         facul_prem.booking_year := rec.booking_year;
         facul_prem.effectivity_date := rec.effectivity_date;
         facul_prem.acct_ent_date := rec.acct_ent_date;
         facul_prem.prem_amt := rec.prem_amt;
         facul_prem.iss_cd := rec.iss_cd;
         facul_prem.cred_branch := rec.cred_branch;
         facul_prem.line_cd := rec.line_cd;
         facul_prem.spld_date := rec.spld_date;
         facul_prem.spld_acct_ent_date := rec.spld_acct_ent_date;
         facul_prem.pol_flag := rec.pol_flag;
         facul_prem.acct_trty_type := rec.acct_trty_type;
         facul_prem.dist_no := rec.dist_no;
         facul_prem.dist_flag := rec.dist_flag;
         facul_prem.acc_rev_date := rec.acc_rev_date;
         PIPE ROW (facul_prem);
      END LOOP;
   END;

   FUNCTION get_facul_prem_summary
      RETURN deff_rec_type_sum_table PIPELINED
   IS
      facul_prem_sum   deff_rec_type_sum;
   BEGIN
      FOR rec IN (SELECT   NVL (cred_branch, iss_cd) cred_branch, line_cd,
                           SUM (prem_amt) prem_amt, SUM (jan_1) jan_1,
                           SUM (feb_1) feb_1, SUM (mar_1) mar_1,
                           SUM (apr_1) apr_1, SUM (may_1) may_1,
                           SUM (jun_1) jun_1, SUM (jul_1) jul_1,
                           SUM (aug_1) aug_1, SUM (sep_1) sep_1,
                           SUM (oct_1) oct_1, SUM (nov_1) nov_1,
                           SUM (dec_1) dec_1, SUM (jan_2) jan_2,
                           SUM (feb_2) feb_2, SUM (mar_2) mar_2,
                           SUM (apr_2) apr_2, SUM (may_2) may_2,
                           SUM (jun_2) jun_2, SUM (jul_2) jul_2,
                           SUM (aug_2) aug_2, SUM (sep_2) sep_2,
                           SUM (oct_2) oct_2, SUM (nov_2) nov_2,
                           SUM (dec_2) dec_2
                      FROM TABLE (twenty_fourth_validation.get_facul_prem_dtl)
                  GROUP BY NVL (cred_branch, iss_cd), line_cd
                  ORDER BY cred_branch, line_cd)
      LOOP
         facul_prem_sum.cred_branch := rec.cred_branch;
         facul_prem_sum.line_cd := rec.line_cd;
         facul_prem_sum.prem_amt := rec.prem_amt;
         facul_prem_sum.jan_1 := rec.jan_1;
         facul_prem_sum.feb_1 := rec.feb_1;
         facul_prem_sum.mar_1 := rec.mar_1;
         facul_prem_sum.apr_1 := rec.apr_1;
         facul_prem_sum.may_1 := rec.may_1;
         facul_prem_sum.jun_1 := rec.jun_1;
         facul_prem_sum.jul_1 := rec.jul_1;
         facul_prem_sum.aug_1 := rec.aug_1;
         facul_prem_sum.sep_1 := rec.sep_1;
         facul_prem_sum.oct_1 := rec.oct_1;
         facul_prem_sum.nov_1 := rec.nov_1;
         facul_prem_sum.dec_1 := rec.dec_1;
         facul_prem_sum.jan_2 := rec.jan_2;
         facul_prem_sum.feb_2 := rec.feb_2;
         facul_prem_sum.mar_2 := rec.mar_2;
         facul_prem_sum.apr_2 := rec.apr_2;
         facul_prem_sum.may_2 := rec.may_2;
         facul_prem_sum.jun_2 := rec.jun_2;
         facul_prem_sum.jul_2 := rec.jul_2;
         facul_prem_sum.aug_2 := rec.aug_2;
         facul_prem_sum.sep_2 := rec.sep_2;
         facul_prem_sum.oct_2 := rec.oct_2;
         facul_prem_sum.nov_2 := rec.nov_2;
         facul_prem_sum.dec_2 := rec.dec_2;
         PIPE ROW (facul_prem_sum);
      END LOOP;
   END;

   FUNCTION get_comm_exp_dtl
      RETURN def_comm_exp_tab PIPELINED
   IS
      comm_exp       def_comm_exp;
      v_line_cd_mn   VARCHAR2 (7)  := giisp.v ('LINE_CODE_MN');
      v_date         DATE;
      v_month        VARCHAR2 (30);
      v_factor       NUMBER;
      v_year         NUMBER;
      v_ctr          NUMBER        := 0;
      v_start_date   DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   BEGIN
      FOR rec IN (SELECT *
                    FROM comm_expense_ext
                   WHERE NVL (cred_branch, iss_cd) != 'RI')
      LOOP
         comm_exp.jan_1 := NULL;
         comm_exp.feb_1 := NULL;
         comm_exp.mar_1 := NULL;
         comm_exp.apr_1 := NULL;
         comm_exp.may_1 := NULL;
         comm_exp.jun_1 := NULL;
         comm_exp.jul_1 := NULL;
         comm_exp.aug_1 := NULL;
         comm_exp.sep_1 := NULL;
         comm_exp.oct_1 := NULL;
         comm_exp.nov_1 := NULL;
         comm_exp.dec_1 := NULL;
         comm_exp.jan_2 := NULL;
         comm_exp.feb_2 := NULL;
         comm_exp.mar_2 := NULL;
         comm_exp.apr_2 := NULL;
         comm_exp.may_2 := NULL;
         comm_exp.jun_2 := NULL;
         comm_exp.jul_2 := NULL;
         comm_exp.aug_2 := NULL;
         comm_exp.sep_2 := NULL;
         comm_exp.oct_2 := NULL;
         comm_exp.nov_2 := NULL;
         comm_exp.dec_2 := NULL;

         IF TRUNC (rec.eff_date) >
               LAST_DAY (ADD_MONTHS (TO_DATE (   rec.extract_mm
                                              || '-'
                                              || rec.extract_year,
                                              'MM-YYYY'
                                             ),
                                     -12
                                    )
                        )
         THEN
            LOOP
               v_date := ADD_MONTHS (rec.acct_ent_date, v_ctr);

               IF v_date >
                     LAST_DAY (TO_DATE (   rec.extract_mm
                                        || '-'
                                        || rec.extract_year,
                                        'MM-YYYY'
                                       )
                              )
               THEN
                  EXIT;
               END IF;

               v_month := TO_CHAR (v_date, 'fmMONTH');
               v_year := TO_CHAR (v_date, 'fmRRRR');

               IF LAST_DAY (v_start_date) <= rec.acct_ent_date
               THEN
                  IF v_month = 'JANUARY' AND v_year = rec.extract_year
                  THEN
                     comm_exp.jan_2 := rec.comm_amt;
                  ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                  THEN
                     comm_exp.feb_2 := rec.comm_amt;
                  ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                  THEN
                     comm_exp.mar_2 := rec.comm_amt;
                  ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                  THEN
                     comm_exp.apr_2 := rec.comm_amt;
                  ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                  THEN
                     comm_exp.may_2 := rec.comm_amt;
                  ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                  THEN
                     comm_exp.jun_2 := rec.comm_amt;
                  ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                  THEN
                     comm_exp.jul_2 := rec.comm_amt;
                  ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                  THEN
                     comm_exp.aug_2 := rec.comm_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                  THEN
                     comm_exp.sep_2 := rec.comm_amt;
                  ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                  THEN
                     comm_exp.oct_2 := rec.comm_amt;
                  ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                  THEN
                     comm_exp.nov_2 := rec.comm_amt;
                  ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                  THEN
                     comm_exp.dec_2 := rec.comm_amt;
                  ELSIF v_month = 'JANUARY' AND v_year != rec.extract_year
                  THEN
                     comm_exp.jan_1 := rec.comm_amt;
                  ELSIF     v_month = 'FEBRUARY'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.feb_1 := rec.comm_amt;
                  ELSIF v_month = 'MARCH' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.mar_1 := rec.comm_amt;
                  ELSIF v_month = 'APRIL' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.apr_1 := rec.comm_amt;
                  ELSIF v_month = 'MAY' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.may_1 := rec.comm_amt;
                  ELSIF v_month = 'JUNE' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.jun_1 := rec.comm_amt;
                  ELSIF v_month = 'JULY' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.jul_1 := rec.comm_amt;
                  ELSIF v_month = 'AUGUST' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                  THEN
                     comm_exp.aug_1 := rec.comm_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year != rec.extract_year
                  THEN
                     comm_exp.sep_1 := rec.comm_amt;
                  ELSIF v_month = 'OCTOBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.oct_1 := rec.comm_amt;
                  ELSIF     v_month = 'NOVEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.nov_1 := rec.comm_amt;
                  ELSIF     v_month = 'DECEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.dec_1 := rec.comm_amt;
                  END IF;
               END IF;

               v_ctr := v_ctr + 1;
            END LOOP;

            v_ctr := 0;

            FOR f IN (SELECT *
                        FROM (SELECT   MONTH, numerator_factor,
                                       denominator_factor
                                  FROM giac_deferred_factors
                                 WHERE procedure_id != 2
                                   AND line_cd IS NULL
                                   AND def_tag IS NULL
                                   AND MONTH >
                                          MONTHS_BETWEEN
                                                       (rec.acct_ent_date,
                                                        LAST_DAY (rec.eff_date)
                                                       )
                              ORDER BY line_cd, MONTH) a,
                             (SELECT   MONTH month_mn,
                                       numerator_factor numerator_factor_mn,
                                       numerator_factor denominator_factor_mn,
                                       line_cd line_cd_mn
                                  FROM giac_deferred_factors
                                 WHERE procedure_id != 2
                                   AND line_cd = 'MN'
                                   AND def_tag IS NULL
                              ORDER BY line_cd, MONTH) b
                       WHERE a.MONTH(+) = b.month_mn)
            LOOP
               IF f.MONTH != 0
               THEN
                  v_date := ADD_MONTHS (TRUNC (rec.eff_date), (f.MONTH - 1));

                  IF v_date <=
                        LAST_DAY (TO_DATE (   rec.extract_mm
                                           || '/01/'
                                           || rec.extract_year,
                                           'MM/DD/RRRR'
                                          )
                                 )
                  THEN
                     v_month := TO_CHAR (v_date, 'fmMONTH');
                     v_year := TO_CHAR (v_date, 'fmRRRR');

                     BEGIN
                        SELECT DECODE (rec.line_cd,
                                       v_line_cd_mn, f.numerator_factor_mn
                                        / f.denominator_factor_mn,
                                         f.numerator_factor
                                       / f.denominator_factor
                                      )
                          INTO v_factor
                          FROM DUAL;
                     EXCEPTION
                        WHEN ZERO_DIVIDE
                        THEN
                           v_factor := 0;
                     END;

                     IF v_month = 'JANUARY' AND v_year = rec.extract_year
                     THEN
                        comm_exp.jan_2 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                     THEN
                        comm_exp.feb_2 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                     THEN
                        comm_exp.mar_2 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                     THEN
                        comm_exp.apr_2 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                     THEN
                        comm_exp.may_2 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                     THEN
                        comm_exp.jun_2 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                     THEN
                        comm_exp.jul_2 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                     THEN
                        comm_exp.aug_2 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                     THEN
                        comm_exp.sep_2 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                     THEN
                        comm_exp.oct_2 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                     THEN
                        comm_exp.nov_2 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                     THEN
                        comm_exp.dec_2 := rec.comm_amt * v_factor;
                     ELSIF     v_month = 'JANUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        comm_exp.jan_1 := rec.comm_amt * v_factor;
                     ELSIF     v_month = 'FEBRUARY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        comm_exp.feb_1 := rec.comm_amt * v_factor;
                     ELSIF     v_month = 'MARCH'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        comm_exp.mar_1 := rec.comm_amt * v_factor;
                     ELSIF     v_month = 'APRIL'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        comm_exp.apr_1 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'MAY' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                     THEN
                        comm_exp.may_1 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'JUNE'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        comm_exp.jun_1 := rec.comm_amt * v_factor;
                     ELSIF v_month = 'JULY'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        comm_exp.jul_1 := rec.comm_amt * v_factor;
                     ELSIF     v_month = 'AUGUST'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        comm_exp.aug_1 := rec.comm_amt * v_factor;
                     ELSIF     v_month = 'SEPTEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        comm_exp.sep_1 := rec.comm_amt * v_factor;
                     ELSIF     v_month = 'OCTOBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        comm_exp.oct_1 := rec.comm_amt * v_factor;
                     ELSIF     v_month = 'NOVEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        comm_exp.nov_1 := rec.comm_amt * v_factor;
                     ELSIF     v_month = 'DECEMBER'
                           AND v_year = (rec.extract_year - 1)
                     THEN
                        comm_exp.dec_1 := rec.comm_amt * v_factor;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         END IF;

         comm_exp.policy_id := rec.policy_id;
         comm_exp.policy_no := rec.policy_no;
         comm_exp.booking_month := rec.booking_month;
         comm_exp.booking_year := rec.booking_year;
         comm_exp.eff_date := rec.eff_date;
         comm_exp.acct_ent_date := rec.acct_ent_date;
         comm_exp.comm_amt := rec.comm_amt;
         comm_exp.iss_cd := rec.iss_cd;
         comm_exp.cred_branch := rec.cred_branch;
         comm_exp.line_cd := rec.line_cd;
         comm_exp.spld_date := rec.spld_date;
         comm_exp.spld_acct_ent_date := rec.spld_acct_ent_date;
         comm_exp.pol_flag := rec.pol_flag;
         comm_exp.intm_no := rec.intm_no;
         PIPE ROW (comm_exp);
      END LOOP;
   END;

   FUNCTION get_comm_exp_summary
      RETURN def_rec_type_sum_tab PIPELINED
   IS
      comm_exp_sum   def_rec_type_sum;
   BEGIN
      FOR rec IN (SELECT   NVL (cred_branch, iss_cd) cred_branch, line_cd,
                           SUM (comm_amt) comm_amt, SUM (jan_1) jan_1,
                           SUM (feb_1) feb_1, SUM (mar_1) mar_1,
                           SUM (apr_1) apr_1, SUM (may_1) may_1,
                           SUM (jun_1) jun_1, SUM (jul_1) jul_1,
                           SUM (aug_1) aug_1, SUM (sep_1) sep_1,
                           SUM (oct_1) oct_1, SUM (nov_1) nov_1,
                           SUM (dec_1) dec_1, SUM (jan_2) jan_2,
                           SUM (feb_2) feb_2, SUM (mar_2) mar_2,
                           SUM (apr_2) apr_2, SUM (may_2) may_2,
                           SUM (jun_2) jun_2, SUM (jul_2) jul_2,
                           SUM (aug_2) aug_2, SUM (sep_2) sep_2,
                           SUM (oct_2) oct_2, SUM (nov_2) nov_2,
                           SUM (dec_2) dec_2
                      FROM TABLE (twenty_fourth_validation.get_comm_exp_dtl)
                  GROUP BY NVL (cred_branch, iss_cd), line_cd
                  ORDER BY cred_branch, line_cd)
      LOOP
         comm_exp_sum.cred_branch := rec.cred_branch;
         comm_exp_sum.line_cd := rec.line_cd;
         comm_exp_sum.comm_amt := rec.comm_amt;
         comm_exp_sum.jan_1 := rec.jan_1;
         comm_exp_sum.feb_1 := rec.feb_1;
         comm_exp_sum.mar_1 := rec.mar_1;
         comm_exp_sum.apr_1 := rec.apr_1;
         comm_exp_sum.may_1 := rec.may_1;
         comm_exp_sum.jun_1 := rec.jun_1;
         comm_exp_sum.jul_1 := rec.jul_1;
         comm_exp_sum.aug_1 := rec.aug_1;
         comm_exp_sum.sep_1 := rec.sep_1;
         comm_exp_sum.oct_1 := rec.oct_1;
         comm_exp_sum.nov_1 := rec.nov_1;
         comm_exp_sum.dec_1 := rec.dec_1;
         comm_exp_sum.jan_2 := rec.jan_2;
         comm_exp_sum.feb_2 := rec.feb_2;
         comm_exp_sum.mar_2 := rec.mar_2;
         comm_exp_sum.apr_2 := rec.apr_2;
         comm_exp_sum.may_2 := rec.may_2;
         comm_exp_sum.jun_2 := rec.jun_2;
         comm_exp_sum.jul_2 := rec.jul_2;
         comm_exp_sum.aug_2 := rec.aug_2;
         comm_exp_sum.sep_2 := rec.sep_2;
         comm_exp_sum.oct_2 := rec.oct_2;
         comm_exp_sum.nov_2 := rec.nov_2;
         comm_exp_sum.dec_2 := rec.dec_2;
         PIPE ROW (comm_exp_sum);
      END LOOP;
   END;

   FUNCTION get_comm_exp_ri_dtl
      RETURN def_comm_exp_tab PIPELINED
   IS
      comm_exp       def_comm_exp;
      v_line_cd_mn   VARCHAR2 (7)  := giisp.v ('LINE_CODE_MN');
      v_date         DATE;
      v_month        VARCHAR2 (30);
      v_factor       NUMBER;
      v_year         NUMBER;
      v_ctr          NUMBER        := 0;
      v_start_date   DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   BEGIN
      FOR rec IN (SELECT *
                    FROM comm_expense_ext
                   WHERE NVL (cred_branch, iss_cd) = 'RI')
      LOOP
         comm_exp.jan_1 := NULL;
         comm_exp.feb_1 := NULL;
         comm_exp.mar_1 := NULL;
         comm_exp.apr_1 := NULL;
         comm_exp.may_1 := NULL;
         comm_exp.jun_1 := NULL;
         comm_exp.jul_1 := NULL;
         comm_exp.aug_1 := NULL;
         comm_exp.sep_1 := NULL;
         comm_exp.oct_1 := NULL;
         comm_exp.nov_1 := NULL;
         comm_exp.dec_1 := NULL;
         comm_exp.jan_2 := NULL;
         comm_exp.feb_2 := NULL;
         comm_exp.mar_2 := NULL;
         comm_exp.apr_2 := NULL;
         comm_exp.may_2 := NULL;
         comm_exp.jun_2 := NULL;
         comm_exp.jul_2 := NULL;
         comm_exp.aug_2 := NULL;
         comm_exp.sep_2 := NULL;
         comm_exp.oct_2 := NULL;
         comm_exp.nov_2 := NULL;
         comm_exp.dec_2 := NULL;

         IF TRUNC (rec.eff_date) >
               LAST_DAY (ADD_MONTHS (TO_DATE (   rec.extract_mm
                                              || '-'
                                              || rec.extract_year,
                                              'MM-YYYY'
                                             ),
                                     -12
                                    )
                        )
         THEN
            LOOP
               v_date := ADD_MONTHS (rec.acct_ent_date, v_ctr);

               IF v_date >
                     LAST_DAY (TO_DATE (   rec.extract_mm
                                        || '-'
                                        || rec.extract_year,
                                        'MM-YYYY'
                                       )
                              )
               THEN
                  EXIT;
               END IF;

               v_month := TO_CHAR (v_date, 'fmMONTH');
               v_year := TO_CHAR (v_date, 'fmRRRR');

               IF LAST_DAY (v_start_date) <= rec.acct_ent_date
               THEN
                  IF v_month = 'JANUARY' AND v_year = rec.extract_year
                  THEN
                     comm_exp.jan_2 := rec.comm_amt;
                  ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                  THEN
                     comm_exp.feb_2 := rec.comm_amt;
                  ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                  THEN
                     comm_exp.mar_2 := rec.comm_amt;
                  ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                  THEN
                     comm_exp.apr_2 := rec.comm_amt;
                  ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                  THEN
                     comm_exp.may_2 := rec.comm_amt;
                  ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                  THEN
                     comm_exp.jun_2 := rec.comm_amt;
                  ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                  THEN
                     comm_exp.jul_2 := rec.comm_amt;
                  ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                  THEN
                     comm_exp.aug_2 := rec.comm_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                  THEN
                     comm_exp.sep_2 := rec.comm_amt;
                  ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                  THEN
                     comm_exp.oct_2 := rec.comm_amt;
                  ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                  THEN
                     comm_exp.nov_2 := rec.comm_amt;
                  ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                  THEN
                     comm_exp.dec_2 := rec.comm_amt;
                  ELSIF v_month = 'JANUARY' AND v_year != rec.extract_year
                  THEN
                     comm_exp.jan_1 := rec.comm_amt;
                  ELSIF     v_month = 'FEBRUARY'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.feb_1 := rec.comm_amt;
                  ELSIF v_month = 'MARCH' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.mar_1 := rec.comm_amt;
                  ELSIF v_month = 'APRIL' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.apr_1 := rec.comm_amt;
                  ELSIF v_month = 'MAY' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.may_1 := rec.comm_amt;
                  ELSIF v_month = 'JUNE' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.jun_1 := rec.comm_amt;
                  ELSIF v_month = 'JULY' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.jul_1 := rec.comm_amt;
                  ELSIF v_month = 'AUGUST' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                  THEN
                     comm_exp.aug_1 := rec.comm_amt;
                  ELSIF v_month = 'SEPTEMBER' AND v_year != rec.extract_year
                  THEN
                     comm_exp.sep_1 := rec.comm_amt;
                  ELSIF v_month = 'OCTOBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.oct_1 := rec.comm_amt;
                  ELSIF     v_month = 'NOVEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.nov_1 := rec.comm_amt;
                  ELSIF     v_month = 'DECEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.dec_1 := rec.comm_amt;
                  END IF;
               END IF;

               v_ctr := v_ctr + 1;
            END LOOP;

            v_ctr := 0;

            FOR f IN (SELECT *
                        FROM (SELECT   MONTH, numerator_factor,
                                       denominator_factor
                                  FROM giac_deferred_factors
                                 WHERE procedure_id != 2
                                   AND line_cd IS NULL
                                   AND def_tag IS NULL
                                   AND MONTH >
                                          MONTHS_BETWEEN
                                                       (rec.acct_ent_date,
                                                        LAST_DAY (rec.eff_date)
                                                       )
                              ORDER BY line_cd, MONTH) a,
                             (SELECT   MONTH month_mn,
                                       numerator_factor numerator_factor_mn,
                                       numerator_factor denominator_factor_mn,
                                       line_cd line_cd_mn
                                  FROM giac_deferred_factors
                                 WHERE procedure_id != 2
                                   AND line_cd = 'MN'
                                   AND def_tag IS NULL
                              ORDER BY line_cd, MONTH) b
                       WHERE a.MONTH(+) = b.month_mn)
            LOOP
               v_date := ADD_MONTHS (TRUNC (rec.eff_date), (f.MONTH - 1));

               IF v_date <=
                     LAST_DAY (TO_DATE (   rec.extract_mm
                                        || '/01/'
                                        || rec.extract_year,
                                        'MM/DD/RRRR'
                                       )
                              )
               THEN
                  v_month := TO_CHAR (v_date, 'fmMONTH');
                  v_year := TO_CHAR (v_date, 'fmRRRR');

                  BEGIN
                     SELECT DECODE (rec.line_cd,
                                    v_line_cd_mn, f.numerator_factor_mn
                                     / f.denominator_factor_mn,
                                    f.numerator_factor / f.denominator_factor
                                   )
                       INTO v_factor
                       FROM DUAL;
                  EXCEPTION
                     WHEN ZERO_DIVIDE
                     THEN
                        v_factor := 0;
                  END;

                  IF v_month = 'JANUARY' AND v_year = rec.extract_year
                  THEN
                     comm_exp.jan_2 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'FEBRUARY' AND v_year = rec.extract_year
                  THEN
                     comm_exp.feb_2 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'MARCH' AND v_year = rec.extract_year
                  THEN
                     comm_exp.mar_2 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'APRIL' AND v_year = rec.extract_year
                  THEN
                     comm_exp.apr_2 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'MAY' AND v_year = rec.extract_year
                  THEN
                     comm_exp.may_2 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'JUNE' AND v_year = rec.extract_year
                  THEN
                     comm_exp.jun_2 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'JULY' AND v_year = rec.extract_year
                  THEN
                     comm_exp.jul_2 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'AUGUST' AND v_year = rec.extract_year
                  THEN
                     comm_exp.aug_2 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'SEPTEMBER' AND v_year = rec.extract_year
                  THEN
                     comm_exp.sep_2 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'OCTOBER' AND v_year = rec.extract_year
                  THEN
                     comm_exp.oct_2 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'NOVEMBER' AND v_year = rec.extract_year
                  THEN
                     comm_exp.nov_2 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'DECEMBER' AND v_year = rec.extract_year
                  THEN
                     comm_exp.dec_2 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'JANUARY'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.jan_1 := rec.comm_amt * v_factor;
                  ELSIF     v_month = 'FEBRUARY'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.feb_1 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'MARCH' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.mar_1 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'APRIL' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.apr_1 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'MAY' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.may_1 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'JUNE' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.jun_1 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'JULY' AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.jul_1 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'AUGUST' AND v_year =
                                                       (rec.extract_year - 1
                                                       )
                  THEN
                     comm_exp.aug_1 := rec.comm_amt * v_factor;
                  ELSIF     v_month = 'SEPTEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.sep_1 := rec.comm_amt * v_factor;
                  ELSIF v_month = 'OCTOBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.oct_1 := rec.comm_amt * v_factor;
                  ELSIF     v_month = 'NOVEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.nov_1 := rec.comm_amt * v_factor;
                  ELSIF     v_month = 'DECEMBER'
                        AND v_year = (rec.extract_year - 1)
                  THEN
                     comm_exp.dec_1 := rec.comm_amt * v_factor;
                  END IF;
               END IF;
            END LOOP;
         END IF;

         comm_exp.policy_id := rec.policy_id;
         comm_exp.policy_no := rec.policy_no;
         comm_exp.booking_month := rec.booking_month;
         comm_exp.booking_year := rec.booking_year;
         comm_exp.eff_date := rec.eff_date;
         comm_exp.acct_ent_date := rec.acct_ent_date;
         comm_exp.comm_amt := rec.comm_amt;
         comm_exp.iss_cd := rec.iss_cd;
         comm_exp.cred_branch := rec.cred_branch;
         comm_exp.line_cd := rec.line_cd;
         comm_exp.spld_date := rec.spld_date;
         comm_exp.spld_acct_ent_date := rec.spld_acct_ent_date;
         comm_exp.pol_flag := rec.pol_flag;
         comm_exp.intm_no := rec.intm_no;
         PIPE ROW (comm_exp);
      END LOOP;
   END;

   FUNCTION get_comm_exp_ri_summary
      RETURN def_rec_type_sum_tab PIPELINED
   IS
      comm_exp_sum_ri   def_rec_type_sum;
   BEGIN
      FOR rec IN (SELECT   NVL (cred_branch, iss_cd) cred_branch, line_cd,
                           SUM (comm_amt) comm_amt, SUM (jan_1) jan_1,
                           SUM (feb_1) feb_1, SUM (mar_1) mar_1,
                           SUM (apr_1) apr_1, SUM (may_1) may_1,
                           SUM (jun_1) jun_1, SUM (jul_1) jul_1,
                           SUM (aug_1) aug_1, SUM (sep_1) sep_1,
                           SUM (oct_1) oct_1, SUM (nov_1) nov_1,
                           SUM (dec_1) dec_1, SUM (jan_2) jan_2,
                           SUM (feb_2) feb_2, SUM (mar_2) mar_2,
                           SUM (apr_2) apr_2, SUM (may_2) may_2,
                           SUM (jun_2) jun_2, SUM (jul_2) jul_2,
                           SUM (aug_2) aug_2, SUM (sep_2) sep_2,
                           SUM (oct_2) oct_2, SUM (nov_2) nov_2,
                           SUM (dec_2) dec_2
                      FROM TABLE (twenty_fourth_validation.get_comm_exp_ri_dtl)
                  GROUP BY NVL (cred_branch, iss_cd), line_cd
                  ORDER BY cred_branch, line_cd)
      LOOP
         comm_exp_sum_ri.cred_branch := rec.cred_branch;
         comm_exp_sum_ri.line_cd := rec.line_cd;
         comm_exp_sum_ri.comm_amt := rec.comm_amt;
         comm_exp_sum_ri.jan_1 := rec.jan_1;
         comm_exp_sum_ri.feb_1 := rec.feb_1;
         comm_exp_sum_ri.mar_1 := rec.mar_1;
         comm_exp_sum_ri.apr_1 := rec.apr_1;
         comm_exp_sum_ri.may_1 := rec.may_1;
         comm_exp_sum_ri.jun_1 := rec.jun_1;
         comm_exp_sum_ri.jul_1 := rec.jul_1;
         comm_exp_sum_ri.aug_1 := rec.aug_1;
         comm_exp_sum_ri.sep_1 := rec.sep_1;
         comm_exp_sum_ri.oct_1 := rec.oct_1;
         comm_exp_sum_ri.nov_1 := rec.nov_1;
         comm_exp_sum_ri.dec_1 := rec.dec_1;
         comm_exp_sum_ri.jan_2 := rec.jan_2;
         comm_exp_sum_ri.feb_2 := rec.feb_2;
         comm_exp_sum_ri.mar_2 := rec.mar_2;
         comm_exp_sum_ri.apr_2 := rec.apr_2;
         comm_exp_sum_ri.may_2 := rec.may_2;
         comm_exp_sum_ri.jun_2 := rec.jun_2;
         comm_exp_sum_ri.jul_2 := rec.jul_2;
         comm_exp_sum_ri.aug_2 := rec.aug_2;
         comm_exp_sum_ri.sep_2 := rec.sep_2;
         comm_exp_sum_ri.oct_2 := rec.oct_2;
         comm_exp_sum_ri.nov_2 := rec.nov_2;
         comm_exp_sum_ri.dec_2 := rec.dec_2;
         PIPE ROW (comm_exp_sum_ri);
      END LOOP;
   END;
END;
/


DROP PACKAGE BODY CPI.TWENTY_FOURTH_VALIDATION;

