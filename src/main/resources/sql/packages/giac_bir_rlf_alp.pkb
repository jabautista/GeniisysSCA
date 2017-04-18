CREATE OR REPLACE PACKAGE BODY CPI.giac_bir_rlf_alp
AS
   FUNCTION get_valid_tin (p_tin VARCHAR2)
      RETURN VARCHAR2
   IS
      v_tin   giis_assured.assd_tin%TYPE;
   BEGIN
     -- v_tin := TO_NUMBER (REPLACE (REPLACE (p_tin, '-', ''), ' '));
      v_tin := REPLACE (REPLACE (p_tin, '-', ''), ' ');

      IF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = '5'
      THEN
         v_tin := NULL;
      ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = '6'
      THEN
         v_tin := NULL;
      ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = '7'
      THEN
         v_tin := NULL;
      ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = '8'
      THEN
         v_tin := NULL;
      ELSE
         IF v_tin = '0'
         THEN
            v_tin := NULL;
         ELSIF     LENGTH (p_tin) = 15
               AND LENGTH (REPLACE (REPLACE (p_tin, '-'), ' ')) = 12
         THEN
            v_tin := REPLACE (p_tin, ' ', '-');
         ELSIF     LENGTH (REPLACE (REPLACE (p_tin, '-'), ' ')) = 12
               AND LENGTH (p_tin) = 12
         THEN
            v_tin :=
                  SUBSTR (p_tin, 1, 3)
               || '-'
               || SUBSTR (p_tin, 4, 3)
               || '-'
               || SUBSTR (p_tin, 7, 3)
               || '-'
               || SUBSTR (p_tin, 10, 3);
         ELSIF     LENGTH (p_tin) = 11
               AND LENGTH (REPLACE (REPLACE (p_tin, '-'), ' ')) = 9
         THEN
            v_tin := REPLACE (p_tin, ' ', '-') || '-000';
         ELSIF     LENGTH (REPLACE (REPLACE (p_tin, '-'), ' ')) = 9
               AND LENGTH (p_tin) = 9
         THEN
            v_tin :=
                  SUBSTR (p_tin, 1, 3)
               || '-'
               || SUBSTR (p_tin, 4, 3)
               || '-'
               || SUBSTR (p_tin, 7, 3)
               || '-000';
         ELSE
            v_tin := NULL;
         END IF;
      END IF;

      --added by mikel 09.16.2013
      IF v_tin LIKE '999-999-999%'
      THEN
         v_tin := NULL;
      END IF;

      RETURN v_tin;
   EXCEPTION
      WHEN INVALID_NUMBER OR VALUE_ERROR
      THEN
         RETURN NULL;
   END get_valid_tin;

   PROCEDURE map_expanded (
      p_return_month   giac_map_expanded_ext.return_month%TYPE,
      p_return_myear   giac_map_expanded_ext.return_year%TYPE,
      --mikel 02.15.2013; added new parameters to extract records on a montly and yearly basis
      p_return_yyear   giac_map_expanded_ext.return_year%TYPE,
      p_period_tag     giac_map_expanded_ext.period_tag%TYPE
   )
   AS
      v_seq_no     NUMBER (8)                                := 0;
      v_tin        VARCHAR2 (15);
      v_atc_code   VARCHAR2 (5);                           --mikel 01.31.2013
      --mikel 02.15.2013
      v_ret_mm     giac_map_expanded_ext.return_month%TYPE;
      v_ret_yr     giac_map_expanded_ext.return_year%TYPE;
   BEGIN
      DELETE FROM giac_map_expanded_ext
            WHERE return_month =
                               DECODE (p_period_tag,
                                       'M', p_return_month,
                                       12
                                      )
              AND return_year =
                     DECODE (p_period_tag,
                             'M', p_return_myear,
                             p_return_yyear
                            )
              AND period_tag =
                        DECODE (p_period_tag,
                                'M', NVL (period_tag, 'M'),
                                'Y'
                               )
              AND user_id = USER;                          --mikel 02.19.2013;

      FOR rec IN
         (SELECT   *
              FROM (SELECT   DECODE (b.payee_first_name,
                                     NULL, b.payee_last_name,
                                     NULL
                                    ) corporate_name,
                             DECODE (b.payee_first_name,
                                     NULL, NULL,
                                     b.payee_last_name
                                    ) last_name,
                             b.payee_first_name first_name,
                             b.payee_middle_name middle_name, b.tin,
                             e.bir_tax_cd atc_code, e.percent_rate tax_rate,
                             SUM (d.income_amt) tax_base,
                             SUM (d.wholding_tax_amt) wtax
                        FROM giis_payee_class a,
                             giis_payees b,
                             giac_acctrans c,
                             giac_taxes_wheld d,
                             giac_wholding_taxes e
                       WHERE
/*d.gacc_tran_id NOT IN (
   SELECT h.gacc_tran_id
     FROM giac_reversals h, giac_acctrans j
    WHERE h.reversing_tran_id = j.tran_id
      AND j.tran_flag <> 'D'
      AND j.tran_date <=
             (SELECT DISTINCT posting_date
                         FROM giac_acctrans
                        WHERE TO_CHAR(posting_date,'MM-YYYY') = p_return_month || '-' || p_return_year))*/
                             1 = 1                         --mikel 02.15.2013;
                         AND d.payee_class_cd = b.payee_class_cd
                         AND d.gwtx_whtax_id = e.whtax_id
                         AND d.payee_cd = b.payee_no
                         AND b.payee_class_cd = a.payee_class_cd
                         AND d.gacc_tran_id = c.tran_id
                         AND c.tran_flag <> 'D'
                         --AND TO_CHAR (c.posting_date, 'MM') = p_return_month
                         --AND TO_CHAR (c.posting_date, 'YYYY') = p_return_year
                         --mikel 02.15.2013;
                         AND DECODE (p_period_tag,
                                     'M', TO_CHAR (c.posting_date, 'MM'),
                                     'Y'
                                    ) =
                                DECODE (p_period_tag,
                                        'M', LTRIM (TO_CHAR (p_return_month,
                                                             '00'
                                                            )
                                                   ),
                                        'Y'
                                       )
                         AND TO_NUMBER (TO_CHAR (c.posting_date, 'RRRR')) =
                                DECODE (p_period_tag,
                                        'M', p_return_myear,
                                        TO_NUMBER (p_return_yyear)
                                       )
                         AND b.payee_class_cd NOT IN
                                (giacp.v ('ASSD_CLASS_CD'),
                                 giacp.v ('INTM_CLASS_CD')
                                )
                    GROUP BY DECODE (b.payee_first_name,
                                     NULL, b.payee_last_name,
                                     NULL
                                    ),
                             DECODE (b.payee_first_name,
                                     NULL, NULL,
                                     b.payee_last_name
                                    ),
                             b.payee_first_name,
                             b.payee_middle_name,
                             b.tin,
                             e.bir_tax_cd,
                             e.percent_rate
                    UNION ALL
                    SELECT   DECODE (b.lic_tag,
                                     'N', a.intm_name,
                                     b.intm_name
                                    ),
                             NULL, NULL, NULL,
                             DECODE (b.lic_tag, 'Y', b.tin, a.tin),
                             e.bir_tax_cd, e.percent_rate, SUM (d.income_amt),
                             SUM (d.wholding_tax_amt) wtax
                        FROM giis_intermediary a,
                             giis_intermediary b,
                             giac_acctrans c,
                             giac_taxes_wheld d,
                             giac_wholding_taxes e
                       WHERE
                             /*d.gacc_tran_id NOT IN (
                                SELECT h.gacc_tran_id
                                  FROM giac_reversals h, giac_acctrans j
                                 WHERE h.reversing_tran_id = j.tran_id
                                   AND j.tran_flag <> 'D'
                                   AND j.tran_date <=
                                          (SELECT DISTINCT posting_date
                                                      FROM giac_acctrans
                                                     WHERE TO_CHAR
                                                                (posting_date,
                                                                 'MM-YYYY'
                                                                ) =
                                                                 p_return_month
                                                              || '-'
                                                              || p_return_year))*/
                             1 = 1                         --mikel 02.15.2013;
                         AND d.payee_class_cd = giacp.v ('INTM_CLASS_CD')
                         AND d.gwtx_whtax_id = e.whtax_id
                         AND d.payee_cd = b.intm_no
                         AND d.gacc_tran_id = c.tran_id
                         AND a.intm_no = NVL (b.parent_intm_no, b.intm_no)
                         AND c.tran_flag <> 'D'
                         --AND TO_CHAR (c.posting_date, 'MM') = p_return_month
                         --AND TO_CHAR (c.posting_date, 'YYYY') = p_return_year
                         --mikel 02.15.2013;
                         AND DECODE (p_period_tag,
                                     'M', TO_CHAR (c.posting_date, 'MM'),
                                     'Y'
                                    ) =
                                DECODE (p_period_tag,
                                        'M', LTRIM (TO_CHAR (p_return_month,
                                                             '00'
                                                            )
                                                   ),
                                        'Y'
                                       )
                         AND TO_NUMBER (TO_CHAR (c.posting_date, 'RRRR')) =
                                DECODE (p_period_tag,
                                        'M', p_return_myear,
                                        TO_NUMBER (p_return_yyear)
                                       )
                    GROUP BY DECODE (b.lic_tag,
                                     'N', a.intm_name,
                                     b.intm_name
                                    ),
                             DECODE (b.lic_tag, 'Y', b.tin, a.tin),
                             e.bir_tax_cd,
                             e.percent_rate
                    UNION ALL
                    SELECT   DECODE (b.corporate_tag, 'C', b.assd_name, NULL),
                             DECODE (b.corporate_tag, 'I', b.last_name, NULL),
                             DECODE (b.corporate_tag,
                                     'I', b.first_name,
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', b.middle_initial,
                                     NULL
                                    ),
                             b.assd_tin, e.bir_tax_cd, e.percent_rate,
                             SUM (d.income_amt), SUM (d.wholding_tax_amt)
                        FROM giis_assured b,
                             giac_acctrans c,
                             giac_taxes_wheld d,
                             giac_wholding_taxes e
                       WHERE
                             /*d.gacc_tran_id NOT IN (
                                SELECT h.gacc_tran_id
                                  FROM giac_reversals h, giac_acctrans j
                                 WHERE h.reversing_tran_id = j.tran_id
                                   AND j.tran_flag <> 'D'
                                   AND j.tran_date <=
                                          (SELECT DISTINCT posting_date
                                                      FROM giac_acctrans
                                                     WHERE TO_CHAR
                                                                (posting_date,
                                                                 'MM-YYYY'
                                                                ) =
                                                                 p_return_month
                                                              || '-'
                                                              || p_return_year))*/
                             1 = 1                         --mikel 02.15.2013;
                         AND d.payee_class_cd = giacp.v ('ASSD_CLASS_CD')
                         AND d.gwtx_whtax_id = e.whtax_id
                         AND d.payee_cd = b.assd_no
                         AND d.gacc_tran_id = c.tran_id
                         AND c.tran_flag <> 'D'
                         --AND TO_CHAR (c.posting_date, 'MM') = p_return_month
                         --AND TO_CHAR (c.posting_date, 'YYYY') = p_return_year
                         --mikel 02.15.2013;
                         AND DECODE (p_period_tag,
                                     'M', TO_CHAR (c.posting_date, 'MM'),
                                     'Y'
                                    ) =
                                DECODE (p_period_tag,
                                        'M', LTRIM (TO_CHAR (p_return_month,
                                                             '00'
                                                            )
                                                   ),
                                        'Y'
                                       )
                         AND TO_NUMBER (TO_CHAR (c.posting_date, 'RRRR')) =
                                DECODE (p_period_tag,
                                        'M', p_return_myear,
                                        TO_NUMBER (p_return_yyear)
                                       )
                    GROUP BY DECODE (b.corporate_tag, 'C', b.assd_name, NULL),
                             DECODE (b.corporate_tag, 'I', b.last_name, NULL),
                             DECODE (b.corporate_tag,
                                     'I', b.first_name,
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', b.middle_initial,
                                     NULL
                                    ),
                             b.assd_tin,
                             e.bir_tax_cd,
                             e.percent_rate)
             WHERE wtax <> 0
          ORDER BY corporate_name || last_name, atc_code)
      LOOP
         BEGIN
            v_tin := TO_NUMBER (REPLACE (REPLACE (rec.tin, '-', ''), ' '));

            IF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 5
            THEN
               --mikel 01.31.2013; TIN start with 5, 6, 7 and 8 are invalid.
               v_tin := NULL;
            ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 6
            THEN
               v_tin := NULL;
            ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 7
            THEN
               v_tin := NULL;
            ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 8
            THEN
               v_tin := NULL;
            ELSE
               IF v_tin = 0
               THEN
                  v_tin := NULL;
               ELSIF     LENGTH (rec.tin) = 15
                     AND LENGTH (REPLACE (REPLACE (rec.tin, '-'), ' ')) = 12
               THEN
                  v_tin := REPLACE (rec.tin, ' ', '-');
               ELSIF     LENGTH (REPLACE (REPLACE (rec.tin, '-'), ' ')) = 12
                     AND LENGTH (rec.tin) = 12
               THEN
                  v_tin :=
                        SUBSTR (rec.tin, 1, 3)
                     || '-'
                     || SUBSTR (rec.tin, 4, 3)
                     || '-'
                     || SUBSTR (rec.tin, 7, 3)
                     || '-'
                     || SUBSTR (rec.tin, 10, 3);
               ELSIF     LENGTH (rec.tin) = 11
                     AND LENGTH (REPLACE (REPLACE (rec.tin, '-'), ' ')) = 9
               THEN
                  v_tin := REPLACE (rec.tin, ' ', '-') || '-000';
               ELSIF     LENGTH (REPLACE (REPLACE (rec.tin, '-'), ' ')) = 9
                     AND LENGTH (rec.tin) = 9
               THEN
                  v_tin :=
                        SUBSTR (rec.tin, 1, 3)
                     || '-'
                     || SUBSTR (rec.tin, 4, 3)
                     || '-'
                     || SUBSTR (rec.tin, 7, 3)
                     || '-000';
               ELSE
                  v_tin := NULL;
               END IF;
            END IF;
         EXCEPTION
            WHEN INVALID_NUMBER OR VALUE_ERROR
            THEN
               v_tin := NULL;
         END;

         v_atc_code := SUBSTR (rec.atc_code, 1, 5);         --mikel 01.31.2013
         v_seq_no := v_seq_no + 1;

         --mikel 02.15.2013
         SELECT DECODE (p_period_tag, 'M', p_return_month, 12)
           INTO v_ret_mm
           FROM DUAL;

         SELECT DECODE (p_period_tag, 'M', p_return_myear, p_return_yyear)
           INTO v_ret_yr
           FROM DUAL;

         INSERT INTO giac_map_expanded_ext
                     (return_month, return_year, seq_no,
                      corporate_name, last_name,
                      first_name, middle_name, tin,
                      atc_code, tax_rate, tax_base, wholding_tax_amt,
                      user_id, last_update, period_tag
                     )
              VALUES ( /*p_return_month, p_return_year,*/v_ret_mm, v_ret_yr, v_seq_no,
                      UPPER (rec.corporate_name), UPPER (rec.last_name),
                      UPPER (rec.first_name), UPPER (rec.middle_name), v_tin,
                      v_atc_code, rec.tax_rate, rec.tax_base, rec.wtax,
                      USER, SYSDATE, p_period_tag
                     );
      END LOOP;

      COMMIT;
   END;

   --added by reymon 07232013 for SAWT report
   PROCEDURE sawt_expanded (
      p_return_month   giac_sawt_ext.return_month%TYPE,
      p_return_myear   giac_sawt_ext.return_year%TYPE,
      p_return_yyear   giac_sawt_ext.return_year%TYPE,
      p_period_tag     giac_sawt_ext.period_tag%TYPE
   )
   AS
      v_seq_no           NUMBER (8)                          := 0;
      v_tin              VARCHAR2 (15);
      v_rec_tin          giis_payees.tin%TYPE;
      v_atc_code         VARCHAR2 (5);
      v_corporate_name   giac_sawt_ext.corporate_name%TYPE;
      v_last_name        giac_sawt_ext.last_name%TYPE;
      v_first_name       giac_sawt_ext.first_name%TYPE;
      v_middle_name      giac_sawt_ext.middle_name%TYPE;
      v_base_amount      giac_sawt_ext.base_amount%TYPE;
      v_creditable_amt   giac_sawt_ext.creditable_amt%TYPE;
      v_tax_rate         giac_sawt_ext.tax_rate%TYPE;
      v_ret_mm           giac_sawt_ext.return_month%TYPE;
      v_ret_yr           giac_sawt_ext.return_year%TYPE;
      v_exists           NUMBER (1)                          := 0;
   BEGIN
      DELETE FROM giac_sawt_ext
            WHERE return_month =
                               DECODE (p_period_tag,
                                       'M', p_return_month,
                                       12
                                      )
              AND return_year =
                     DECODE (p_period_tag,
                             'M', p_return_myear,
                             p_return_yyear
                            )
              AND period_tag =
                        DECODE (p_period_tag,
                                'M', NVL (period_tag, 'M'),
                                'Y'
                               )
              AND user_id = USER;

      SELECT DECODE (p_period_tag, 'M', p_return_month, 12)
        INTO v_ret_mm
        FROM DUAL;

      SELECT DECODE (p_period_tag, 'M', p_return_myear, p_return_yyear)
        INTO v_ret_yr
        FROM DUAL;

      v_atc_code := 'WC160';
      v_tax_rate := 2;

      FOR rec IN (SELECT   SUM (NVL (wtax_amt, 0)) wtax_amt, payor, tin
                      FROM (SELECT   SUM (NVL (amount, 0)) wtax_amt, c.payor,
                                     c.tin
                                FROM giac_collection_dtl a,
                                     giac_acctrans b,
                                     giac_order_of_payts c
                               WHERE 1 = 1
                                 AND a.gacc_tran_id = b.tran_id
                                 AND a.gacc_tran_id = c.gacc_tran_id
                                 AND b.tran_flag <> 'D'
                                 AND a.pay_mode = 'CW'
                                 AND DECODE (p_period_tag,
                                             'M', TO_CHAR (b.posting_date,
                                                           'MM'
                                                          ),
                                             'Y'
                                            ) =
                                        DECODE
                                             (p_period_tag,
                                              'M', LTRIM
                                                     (TO_CHAR (p_return_month,
                                                               '00'
                                                              )
                                                     ),
                                              'Y'
                                             )
                                 AND TO_NUMBER (TO_CHAR (b.posting_date,
                                                         'RRRR'
                                                        )
                                               ) =
                                        DECODE (p_period_tag,
                                                'M', p_return_myear,
                                                TO_NUMBER (p_return_yyear)
                                               )
                            GROUP BY c.payor, c.tin
                            UNION ALL
                            SELECT   -SUM (NVL (amount, 0)) wtax_amt, c.payor,
                                     c.tin
                                FROM giac_reversals a,
                                     giac_acctrans b,
                                     giac_order_of_payts c,
                                     giac_collection_dtl d
                               WHERE a.reversing_tran_id = b.tran_id
                                 AND a.gacc_tran_id = c.gacc_tran_id
                                 AND a.gacc_tran_id = d.gacc_tran_id
                                 AND b.tran_flag <> 'D'
                                 AND d.pay_mode = 'CW'
                                 AND c.or_flag = 'C'
                                 AND DECODE (p_period_tag,
                                             'M', TO_CHAR (b.posting_date,
                                                           'MM'
                                                          ),
                                             'Y'
                                            ) =
                                        DECODE
                                             (p_period_tag,
                                              'M', LTRIM
                                                     (TO_CHAR (p_return_month,
                                                               '00'
                                                              )
                                                     ),
                                              'Y'
                                             )
                                 AND TO_NUMBER (TO_CHAR (b.posting_date,
                                                         'RRRR'
                                                        )
                                               ) =
                                        DECODE (p_period_tag,
                                                'M', p_return_myear,
                                                TO_NUMBER (p_return_yyear)
                                               )
                            GROUP BY c.payor, c.tin)
                  GROUP BY payor, tin
                  ORDER BY payor ASC)
      LOOP
         FOR i IN (SELECT payee_last_name, payee_first_name,
                          payee_middle_name, tin
                     FROM giis_payees
                    WHERE    payee_last_name
                          || ' '
                          || payee_first_name
                          || ' '
                          || payee_middle_name = rec.payor
                       OR     payee_last_name = rec.payor
                          AND payee_class_cd NOT IN
                                 (giacp.v ('ASSD_CLASS_CD'),
                                  giacp.v ('INTM_CLASS_CD'),
                                  giacp.v ('RI_CLASS_CD')
                                 ))
         LOOP
            v_exists := 1;
            v_rec_tin := i.tin;

            IF i.payee_first_name IS NOT NULL
            THEN
               v_last_name := i.payee_last_name;
               v_first_name := i.payee_first_name;
               v_middle_name := i.payee_middle_name;
            ELSE
               v_corporate_name := i.payee_last_name;
            END IF;
         END LOOP;

         IF v_exists = 0
         THEN
            FOR i IN (SELECT   assd_name, last_name, first_name,
                               middle_initial middle_name, assd_tin,
                               corporate_tag
                          FROM giis_assured
                         WHERE assd_name = rec.payor
                      ORDER BY LENGTH (NVL (assd_tin, 'X')) DESC)
            LOOP
               v_exists := 1;
               v_rec_tin := i.assd_tin;

               IF i.corporate_tag IN ('C', 'J')
               THEN
                  v_corporate_name := i.assd_name;
               ELSE
                  v_last_name := i.last_name;
                  v_first_name := i.first_name;
                  v_middle_name := i.middle_name;
               END IF;
            END LOOP;
         END IF;

         IF v_exists = 0
         THEN
            FOR i IN (SELECT intm_name, tin
                        FROM giis_intermediary
                       WHERE intm_name = rec.payor)
            LOOP
               v_exists := 1;
               v_rec_tin := i.tin;
               v_corporate_name := i.intm_name;
            END LOOP;
         END IF;

         IF v_exists = 0
         THEN
            FOR i IN (SELECT ri_name, ri_tin
                        FROM giis_reinsurer
                       WHERE ri_name = rec.payor)
            LOOP
               v_exists := 1;
               v_rec_tin := i.ri_tin;
               v_corporate_name := i.ri_name;
            END LOOP;
         END IF;

         IF v_exists = 0
         THEN
            v_rec_tin := rec.tin;
            v_corporate_name := rec.payor;
         END IF;

         BEGIN
            v_tin := TO_NUMBER (REPLACE (REPLACE (v_rec_tin, '-', ''), ' '));

            IF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 5
            THEN
               v_tin := NULL;
            ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 6
            THEN
               v_tin := NULL;
            ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 7
            THEN
               v_tin := NULL;
            ELSIF TO_NUMBER (SUBSTR (v_tin, 1, 1)) = 8
            THEN
               v_tin := NULL;
            ELSE
               IF v_tin = 0
               THEN
                  v_tin := NULL;
               ELSIF     LENGTH (v_rec_tin) = 15
                     AND LENGTH (REPLACE (REPLACE (v_rec_tin, '-'), ' ')) = 12
               THEN
                  v_tin := REPLACE (v_rec_tin, ' ', '-');
               ELSIF     LENGTH (REPLACE (REPLACE (v_rec_tin, '-'), ' ')) = 12
                     AND LENGTH (v_rec_tin) = 12
               THEN
                  v_tin :=
                        SUBSTR (v_rec_tin, 1, 3)
                     || '-'
                     || SUBSTR (v_rec_tin, 4, 3)
                     || '-'
                     || SUBSTR (v_rec_tin, 7, 3)
                     || '-'
                     || SUBSTR (v_rec_tin, 10, 3);
               ELSIF     LENGTH (v_rec_tin) = 11
                     AND LENGTH (REPLACE (REPLACE (v_rec_tin, '-'), ' ')) = 9
               THEN
                  v_tin := REPLACE (v_rec_tin, ' ', '-') || '-000';
               ELSIF     LENGTH (REPLACE (REPLACE (v_rec_tin, '-'), ' ')) = 9
                     AND LENGTH (v_rec_tin) = 9
               THEN
                  v_tin :=
                        SUBSTR (v_rec_tin, 1, 3)
                     || '-'
                     || SUBSTR (v_rec_tin, 4, 3)
                     || '-'
                     || SUBSTR (v_rec_tin, 7, 3)
                     || '-000';
               ELSE
                  v_tin := NULL;
               END IF;
            END IF;
         EXCEPTION
            WHEN INVALID_NUMBER OR VALUE_ERROR
            THEN
               v_tin := NULL;
         END;

         v_base_amount := rec.wtax_amt / (v_tax_rate / 100);
         v_seq_no := v_seq_no + 1;

         INSERT INTO giac_sawt_ext
                     (return_month, return_year, seq_no, corporate_name,
                      last_name, first_name,
                      middle_name, tin, atc_code, tax_rate,
                      base_amount, creditable_amt, user_id, last_update,
                      period_tag
                     )
              VALUES (v_ret_mm, v_ret_yr, v_seq_no, UPPER (v_corporate_name),
                      UPPER (v_last_name), UPPER (v_first_name),
                      UPPER (v_middle_name), v_tin, v_atc_code, v_tax_rate,
                      v_base_amount, rec.wtax_amt, USER, SYSDATE,
                      p_period_tag
                     );

         v_corporate_name := NULL;
         v_last_name := NULL;
         v_first_name := NULL;
         v_middle_name := NULL;
         v_tin := NULL;
         v_exists := 0;
      END LOOP;

      COMMIT;
   END sawt_expanded;

   PROCEDURE sls_vat (
      p_return_month   giac_relief_sls_ext.return_month%TYPE,
      p_return_myear   giac_relief_sls_ext.return_year%TYPE,
      p_return_yyear   giac_relief_sls_ext.return_year%TYPE,
      p_period_tag     giac_relief_sls_ext.period_tag%TYPE
   )
   AS
      v_tin               giis_assured.assd_tin%TYPE;
      v_ret_mm            giac_map_expanded_ext.return_month%TYPE;
      v_ret_yr            giac_map_expanded_ext.return_year%TYPE;
      tran_month          VARCHAR2 (50);
      tin_listing_owner   VARCHAR2 (200)
                  := giac_bir_rlf_alp.get_valid_tin (giacp.v ('COMPANY_TIN'));
      v_mmrrrr            VARCHAR2 (7);
   BEGIN
      DELETE FROM giac_relief_sls_ext
            WHERE return_month =
                               DECODE (p_period_tag,
                                       'M', p_return_month,
                                       12
                                      )
              AND return_year =
                     DECODE (p_period_tag,
                             'M', p_return_myear,
                             p_return_yyear
                            )
              AND period_tag =
                        DECODE (p_period_tag,
                                'M', NVL (period_tag, 'M'),
                                'Y'
                               )
              AND user_id = USER;

      COMMIT;

      SELECT DECODE (p_period_tag, 'M', p_return_month, 12)
        INTO v_ret_mm
        FROM DUAL;

      SELECT DECODE (p_period_tag, 'M', p_return_myear, p_return_yyear)
        INTO v_ret_yr
        FROM DUAL;

      v_mmrrrr := v_ret_mm || '-' || v_ret_yr;
      tran_month :=
              TO_CHAR (LAST_DAY (TO_DATE (v_mmrrrr, 'MM-RRRR')), 'MM/DD/RRRR');

      FOR rec IN
         (SELECT   iss_source, first_name, last_name, middle_initial, corporate_name,
                   address1, address2, payor_tin, SUM (tax_amt) tax_amt,
                   SUM (exempt_sales) exempt_sales,
                   SUM (zero_rated_sales) zero_rated_sales,
                   SUM (taxable_sales) taxable_sales
              FROM (SELECT   'DIRECT' iss_source, h.gacc_tran_id, h.b140_iss_cd,
                             h.b140_prem_seq_no, h.inst_no,
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ) first_name,
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ) last_name,
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ) middle_initial,
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ) corporate_name,
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2
                                   ) address1,
                             UPPER (b.mail_addr3) address2,
                             b.assd_tin payor_tin,
                             SUM (NVL (f.tax_amt, 0)) tax_amt,
                             SUM (NVL (h.prem_vat_exempt, 0)) exempt_sales,
                             SUM (NVL (h.prem_zero_rated, 0))
                                                             zero_rated_sales,
                             
                             --SUM (NVL (h.prem_vatable, 0)) taxable_sales
                             SUM
                                (DECODE (f.tax_amt,
                                         0, 0,
                                         DECODE (h.prem_vatable,
                                                 0, (f.tax_amt / .12),
                                                 NVL (h.prem_vatable, 0)
                                                )
                                        )
                                ) taxable_sales             --mikel 09.16.2013
                        FROM gipi_polbasic a,
                             gipi_invoice d,
                             giac_tax_collns f,
                             giac_direct_prem_collns h,
                             giac_acctrans i,
                             giis_assured b
                       WHERE 1 = 1
                         AND d.policy_id = a.policy_id
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND f.b160_tax_cd = giacp.n ('EVAT')
                         AND h.gacc_tran_id = f.gacc_tran_id
                         AND h.b140_iss_cd = f.b160_iss_cd
                         AND h.b140_prem_seq_no = f.b160_prem_seq_no
                         AND h.inst_no = f.inst_no
                         AND i.tran_id = h.gacc_tran_id(+)
                         AND a.assd_no = b.assd_no
                         AND check_user_per_iss_cd_acctg (NULL,
                                                          i.gibr_branch_cd,
                                                          'GIACS115'
                                                         ) = 1
                         AND a.iss_cd <> 'BB'
                         AND NOT EXISTS (
                                SELECT n.gacc_tran_id
                                  FROM giac_reversals n, giac_acctrans o
                                 WHERE n.reversing_tran_id = o.tran_id
                                   AND o.tran_flag <> 'D'
                                   AND n.gacc_tran_id = h.gacc_tran_id
                                   AND (   TRUNC (o.posting_date) IS NOT NULL
                                        OR TRUNC (o.posting_date) <=
                                              LAST_DAY (TO_DATE (v_mmrrrr,
                                                                 'MM-RRRR'
                                                                )
                                                       )
                                       ))
                         AND NOT EXISTS (
                                SELECT p.gacc_tran_id
                                  FROM giac_advanced_payt p
                                 WHERE p.gacc_tran_id = h.gacc_tran_id
                                   AND p.iss_cd = h.b140_iss_cd
                                   AND p.prem_seq_no = h.b140_prem_seq_no
                                   AND p.inst_no = h.inst_no
                                   AND (   p.acct_ent_date IS NULL
                                        OR TRUNC (p.acct_ent_date) >=
                                              LAST_DAY
                                                     (TO_DATE (p_return_month,
                                                               'MM'
                                                              )
                                                     )
                                       ))
                         AND i.tran_class IN ('COL', 'DV', 'JV')
                         AND i.tran_flag != 'D'
                         AND DECODE (p_period_tag,
                                     'M', TO_CHAR (i.posting_date, 'MM'),
                                     'Y'
                                    ) =
                                DECODE (p_period_tag,
                                        'M', LTRIM (TO_CHAR (p_return_month,
                                                             'FM09'
                                                            )
                                                   ),
                                        'Y'
                                       )
                         AND TO_NUMBER (TO_CHAR (i.posting_date, 'RRRR')) =
                                DECODE (p_period_tag,
                                        'M', p_return_myear,
                                        TO_NUMBER (p_return_yyear)
                                       )
                    GROUP BY DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3),
                             b.assd_tin,
                             h.gacc_tran_id,
                             h.b140_iss_cd,
                             h.b140_prem_seq_no,
                             h.inst_no
                    UNION ALL
                    SELECT   'DIRECT' iss_source, h.gacc_tran_id, h.b140_iss_cd,
                             h.b140_prem_seq_no, h.inst_no,
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3), b.assd_tin,
                             SUM (NVL (f.tax_amt, 0)) tax_amt,
                             SUM (NVL (h.prem_vat_exempt, 0)) exempt_sales,
                             SUM (NVL (h.prem_zero_rated, 0))
                                                             zero_rated_sales,
                             
                             --SUM (NVL (h.prem_vatable, 0)) taxable_sales
                             SUM
                                (DECODE (f.tax_amt,
                                         0, 0,
                                         DECODE (h.prem_vatable,
                                                 0, (f.tax_amt / .12),
                                                 NVL (h.prem_vatable, 0)
                                                )
                                        )
                                ) taxable_sales             --mikel 09.16.2013
                        FROM gipi_polbasic a,
                             gipi_invoice d,
                             giac_tax_collns f,
                             giac_direct_prem_collns h,
                             giac_acctrans i,
                             giac_advanced_payt p,
                             giis_assured b
                       WHERE 1 = 1
                         AND d.policy_id = a.policy_id
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND f.b160_tax_cd = giacp.n ('EVAT')
                         AND h.gacc_tran_id = f.gacc_tran_id
                         AND i.tran_id = p.gacc_tran_id
                         AND h.gacc_tran_id = p.gacc_tran_id
                         AND h.b140_iss_cd = p.iss_cd
                         AND h.b140_prem_seq_no = p.prem_seq_no
                         AND h.inst_no = p.inst_no
                         AND h.b140_iss_cd = f.b160_iss_cd
                         AND h.b140_prem_seq_no = f.b160_prem_seq_no
                         AND h.inst_no = f.inst_no
                         AND i.tran_id = h.gacc_tran_id(+)
                         AND a.assd_no = b.assd_no
                         AND check_user_per_iss_cd_acctg (NULL,
                                                          i.gibr_branch_cd,
                                                          'GIACS115'
                                                         ) = 1
                         AND a.iss_cd <> 'BB'
                         AND NOT EXISTS (
                                SELECT n.gacc_tran_id
                                  FROM giac_reversals n, giac_acctrans o
                                 WHERE n.reversing_tran_id = o.tran_id
                                   AND o.tran_flag <> 'D'
                                   AND n.gacc_tran_id = h.gacc_tran_id
                                   AND (   TRUNC (o.posting_date) IS NOT NULL
                                        OR TRUNC (o.posting_date) <=
                                              LAST_DAY (TO_DATE (v_mmrrrr,
                                                                 'MM-RRRR'
                                                                )
                                                       )
                                       ))
                         AND p.acct_ent_date BETWEEN TO_DATE (v_mmrrrr,
                                                              'MM-RRRR'
                                                             )
                                                 AND LAST_DAY
                                                           (TO_DATE (v_mmrrrr,
                                                                     'MM-RRRR'
                                                                    )
                                                           )
                    GROUP BY DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3),
                             b.assd_tin,
                             h.gacc_tran_id,
                             h.b140_iss_cd,
                             h.b140_prem_seq_no,
                             h.inst_no
                    UNION ALL                           --for direct reversals
                    SELECT   'DIRECT' iss_source, h.gacc_tran_id, h.b140_iss_cd,
                             h.b140_prem_seq_no, h.inst_no,
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3), b.assd_tin,
                             -SUM (NVL (f.tax_amt, 0)),
                             -SUM (NVL (h.prem_vat_exempt, 0)),
                             -SUM (NVL (h.prem_zero_rated, 0)),
                             
                             ---SUM (NVL (h.prem_vatable, 0))
                             -SUM
                                 (DECODE (f.tax_amt,
                                          0, 0,
                                          DECODE (h.prem_vatable,
                                                  0, (f.tax_amt / .12),
                                                  NVL (h.prem_vatable, 0)
                                                 )
                                         )
                                 ) taxable_sales            --mikel 09.16.2013
                        FROM gipi_polbasic a,
                             gipi_invoice d,
                             giac_tax_collns f,
                             giac_direct_prem_collns h,
                             giac_acctrans i,
                             giis_assured b
                       WHERE 1 = 1
                         AND d.policy_id = a.policy_id
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND f.b160_tax_cd = giacp.n ('EVAT')
                         AND h.gacc_tran_id = f.gacc_tran_id
                         AND h.b140_iss_cd = f.b160_iss_cd
                         AND h.b140_prem_seq_no = f.b160_prem_seq_no
                         AND h.inst_no = f.inst_no
                         AND i.tran_id = h.gacc_tran_id(+)
                         AND a.assd_no = b.assd_no
                         AND check_user_per_iss_cd_acctg (NULL,
                                                          i.gibr_branch_cd,
                                                          'GIACS115'
                                                         ) = 1
                         AND a.iss_cd <> 'BB'
                         AND EXISTS (
                                SELECT n.gacc_tran_id
                                  FROM giac_reversals n, giac_acctrans o
                                 WHERE n.reversing_tran_id = o.tran_id
                                   AND o.tran_flag <> 'D'
                                   AND n.gacc_tran_id = h.gacc_tran_id
                                   AND DECODE (p_period_tag,
                                               'M', TO_CHAR (o.posting_date,
                                                             'MM'
                                                            ),
                                               'Y'
                                              ) =
                                          DECODE
                                             (p_period_tag,
                                              'M', LTRIM
                                                     (TO_CHAR (p_return_month,
                                                               'FM09'
                                                              )
                                                     ),
                                              'Y'
                                             )
                                   AND TO_NUMBER (TO_CHAR (o.posting_date,
                                                           'RRRR'
                                                          )
                                                 ) =
                                          DECODE (p_period_tag,
                                                  'M', p_return_myear,
                                                  TO_NUMBER (p_return_yyear)
                                                 ))
                         AND NOT EXISTS (
                                SELECT p.gacc_tran_id
                                  FROM giac_advanced_payt p
                                 WHERE p.gacc_tran_id = h.gacc_tran_id
                                   AND p.iss_cd = h.b140_iss_cd
                                   AND p.prem_seq_no = h.b140_prem_seq_no
                                   AND p.inst_no = h.inst_no
                                   AND (   p.acct_ent_date IS NULL
                                        OR TRUNC (p.acct_ent_date) >=
                                              LAST_DAY
                                                     (TO_DATE (p_return_month,
                                                               'MM'
                                                              )
                                                     )
                                       ))
                         AND i.tran_class IN ('COL', 'DV', 'JV')
                         AND i.tran_flag != 'D'
                         AND (   TRUNC (i.posting_date) IS NOT NULL
                              OR TRUNC (i.posting_date) <=
                                      LAST_DAY (TO_DATE (v_mmrrrr, 'MM-RRRR'))
                             )
                    GROUP BY DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3),
                             b.assd_tin,
                             h.gacc_tran_id,
                             h.b140_iss_cd,
                             h.b140_prem_seq_no,
                             h.inst_no
                    UNION ALL
                    SELECT   'DIRECT' iss_source, h.gacc_tran_id, h.b140_iss_cd,
                             h.b140_prem_seq_no, h.inst_no,
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3), b.assd_tin,
                             -SUM (NVL (f.tax_amt, 0)) tax_amt,
                             -SUM (NVL (h.prem_vat_exempt, 0)) exempt_sales,
                             -SUM (NVL (h.prem_zero_rated, 0)
                                  ) zero_rated_sales,
                             
                             ---SUM (NVL (h.prem_vatable, 0)) taxable_sales
                             -SUM
                                 (DECODE (f.tax_amt,
                                          0, 0,
                                          DECODE (h.prem_vatable,
                                                  0, (f.tax_amt / .12),
                                                  NVL (h.prem_vatable, 0)
                                                 )
                                         )
                                 ) taxable_sales            --mikel 09.16.2013
                        FROM gipi_polbasic a,
                             gipi_invoice d,
                             giac_tax_collns f,
                             giac_direct_prem_collns h,
                             giac_acctrans i,
                             giac_advanced_payt p,
                             giis_assured b
                       WHERE 1 = 1
                         AND d.policy_id = a.policy_id
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.iss_cd = h.b140_iss_cd
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND d.prem_seq_no = h.b140_prem_seq_no
                         AND f.b160_tax_cd = giacp.n ('EVAT')
                         AND h.gacc_tran_id = f.gacc_tran_id
                         AND i.tran_id = p.gacc_tran_id
                         AND h.gacc_tran_id = p.gacc_tran_id
                         AND h.b140_iss_cd = p.iss_cd
                         AND h.b140_prem_seq_no = p.prem_seq_no
                         AND h.inst_no = p.inst_no
                         AND h.b140_iss_cd = f.b160_iss_cd
                         AND h.b140_prem_seq_no = f.b160_prem_seq_no
                         AND h.inst_no = f.inst_no
                         AND i.tran_id = h.gacc_tran_id(+)
                         AND a.assd_no = b.assd_no
                         AND check_user_per_iss_cd_acctg (NULL,
                                                          i.gibr_branch_cd,
                                                          'GIACS115'
                                                         ) = 1
                         AND a.iss_cd <> 'BB'
                         AND EXISTS (
                                SELECT n.gacc_tran_id
                                  FROM giac_reversals n, giac_acctrans o
                                 WHERE n.reversing_tran_id = o.tran_id
                                   AND o.tran_flag <> 'D'
                                   AND n.gacc_tran_id = h.gacc_tran_id
                                   AND DECODE (p_period_tag,
                                               'M', TO_CHAR (o.posting_date,
                                                             'MM'
                                                            ),
                                               'Y'
                                              ) =
                                          DECODE
                                             (p_period_tag,
                                              'M', LTRIM
                                                     (TO_CHAR (p_return_month,
                                                               'FM09'
                                                              )
                                                     ),
                                              'Y'
                                             )
                                   AND TO_NUMBER (TO_CHAR (o.posting_date,
                                                           'RRRR'
                                                          )
                                                 ) =
                                          DECODE (p_period_tag,
                                                  'M', p_return_myear,
                                                  TO_NUMBER (p_return_yyear)
                                                 ))
                         AND p.acct_ent_date <=
                                      LAST_DAY (TO_DATE (v_mmrrrr, 'MM-RRRR'))
                    GROUP BY DECODE (b.corporate_tag,
                                     'I', UPPER (b.first_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.last_name),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', UPPER (b.middle_initial),
                                     NULL
                                    ),
                             DECODE (b.corporate_tag,
                                     'I', NULL,
                                     UPPER (b.assd_name)
                                    ),
                             UPPER (b.mail_addr1 || ' ' || b.mail_addr2),
                             UPPER (b.mail_addr3),
                             b.assd_tin,
                             h.gacc_tran_id,
                             h.b140_iss_cd,
                             h.b140_prem_seq_no,
                             h.inst_no)
          GROUP BY iss_source, first_name,
                   last_name,
                   middle_initial,
                   corporate_name,
                   address1,
                   address2,
                   payor_tin
                            UNION ALL                                          --RI transactions
                            SELECT   iss_source, NULL, NULL, NULL, ri_name, address1, address2, ri_tin,
                                     SUM (tax_amt), SUM (exempt_sales), SUM (zero_rated_sales),
                                     SUM (taxable_sales) exempt_sales
                                FROM (SELECT   'REINSURANCE' iss_source, UPPER (a.ri_name) ri_name,
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2
                                                     ) address1,
                                               UPPER (a.mail_address3) address2, a.ri_tin,
                                               SUM (NVL (h.tax_amount, 0)) tax_amt,
                                               0 exempt_sales,
                                               SUM (NVL (h.premium_amt, 0)) zero_rated_sales,
                                               0 taxable_sales
                                          FROM giac_inwfacul_prem_collns h,
                                               giac_acctrans i,
                                               giis_reinsurer a
                                         WHERE 1 = 1
                                           AND i.tran_id = h.gacc_tran_id
                                           AND h.a180_ri_cd = a.ri_cd
                                           AND check_user_per_iss_cd_acctg (NULL,
                                                                            i.gibr_branch_cd,
                                                                            'GIACS115'
                                                                           ) = 1
                                           AND NOT EXISTS (
                                                  SELECT n.gacc_tran_id
                                                    FROM giac_reversals n, giac_acctrans o
                                                   WHERE n.reversing_tran_id = o.tran_id
                                                     AND o.tran_flag <> 'D'
                                                     AND n.gacc_tran_id = h.gacc_tran_id
                                                     AND (   TRUNC (o.posting_date) IS NOT NULL
                                                          OR TRUNC (o.posting_date) <=
                                                                LAST_DAY (TO_DATE (v_mmrrrr,
                                                                                   'MM-RRRR'
                                                                                  )
                                                                         )
                                                         ))
                                           AND NOT EXISTS (
                                                  SELECT p.gacc_tran_id
                                                    FROM giac_advanced_payt p
                                                   WHERE p.gacc_tran_id = h.gacc_tran_id
                                                     AND p.iss_cd = h.b140_iss_cd
                                                     AND p.prem_seq_no = h.b140_prem_seq_no
                                                     AND p.inst_no = h.inst_no
                                                     AND (   p.acct_ent_date IS NULL
                                                          OR TRUNC (p.acct_ent_date) >=
                                                                LAST_DAY
                                                                       (TO_DATE (p_return_month,
                                                                                 'MM'
                                                                                )
                                                                       )
                                                         ))
                                           AND i.tran_class IN ('COL', 'DV', 'JV')
                                           AND i.tran_flag != 'D'
                                           AND DECODE (p_period_tag,
                                                       'M', TO_CHAR (i.posting_date, 'MM'),
                                                       'Y'
                                                      ) =
                                                  DECODE (p_period_tag,
                                                          'M', LTRIM (TO_CHAR (p_return_month,
                                                                               'FM09'
                                                                              )
                                                                     ),
                                                          'Y'
                                                         )
                                           AND TO_NUMBER (TO_CHAR (i.posting_date, 'RRRR')) =
                                                  DECODE (p_period_tag,
                                                          'M', p_return_myear,
                                                          TO_NUMBER (p_return_yyear)
                                                         )
                                      GROUP BY UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3),
                                               a.ri_tin
                                      UNION ALL
                                      SELECT   'REINSURANCE' iss_source, UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3), a.ri_tin,
                                               SUM (NVL (h.tax_amount, 0)) tax_amt,
                                               0 exempt_sales,
                                               SUM (NVL (h.premium_amt, 0)) zero_rated_sales,
                                               0 taxable_sales
                                          FROM giac_inwfacul_prem_collns h,
                                               giac_acctrans i,
                                               giac_advanced_payt p,
                                               giis_reinsurer a
                                         WHERE 1 = 1
                                           AND i.tran_id = p.gacc_tran_id
                                           AND h.gacc_tran_id = p.gacc_tran_id
                                           AND h.b140_iss_cd = p.iss_cd
                                           AND h.b140_prem_seq_no = p.prem_seq_no
                                           AND h.inst_no = p.inst_no
                                           AND h.a180_ri_cd = a.ri_cd
                                           AND i.tran_id = h.gacc_tran_id(+)
                                           AND check_user_per_iss_cd_acctg (NULL,
                                                                            i.gibr_branch_cd,
                                                                            'GIACS115'
                                                                           ) = 1
                                           AND NOT EXISTS (
                                                  SELECT n.gacc_tran_id
                                                    FROM giac_reversals n, giac_acctrans o
                                                   WHERE n.reversing_tran_id = o.tran_id
                                                     AND o.tran_flag <> 'D'
                                                     AND n.gacc_tran_id = h.gacc_tran_id
                                                     AND (   TRUNC (o.posting_date) IS NOT NULL
                                                          OR TRUNC (o.posting_date) <=
                                                                LAST_DAY (TO_DATE (v_mmrrrr,
                                                                                   'MM-RRRR'
                                                                                  )
                                                                         )
                                                         ))
                                           AND p.acct_ent_date BETWEEN TO_DATE (v_mmrrrr,
                                                                                'MM-RRRR'
                                                                               )
                                                                   AND LAST_DAY
                                                                             (TO_DATE (v_mmrrrr,
                                                                                       'MM-RRRR'
                                                                                      )
                                                                             )
                                      GROUP BY UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3),
                                               a.ri_tin
                                      /*UNION ALL
                                      SELECT   UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3), a.ri_tin,
                                               SUM (NVL (h.comm_vat, 0)) tax_amt,
                                               0 exempt_sales,
                                               SUM (DECODE (NVL (h.comm_vat, 0),
                                                            0, NVL (h.comm_amt, 0),
                                                            0
                                                           )
                                                   ) zero_rated_sales,
                                               SUM (DECODE (NVL (h.comm_vat, 0),
                                                            0, 0,
                                                            NVL (h.comm_amt, 0)
                                                           )
                                                   ) taxable_sales
                                          FROM giac_outfacul_prem_payts h,
                                               giac_acctrans i,
                                               giis_reinsurer a
                                         WHERE 1 = 1
                                           AND i.tran_id = h.gacc_tran_id
                                           AND check_user_per_iss_cd_acctg (NULL,
                                                                            i.gibr_branch_cd,
                                                                            'GIACS115'
                                                                           ) = 1
                                           AND h.a180_ri_cd = a.ri_cd
                                           AND NOT EXISTS (
                                                  SELECT n.gacc_tran_id
                                                    FROM giac_reversals n, giac_acctrans o
                                                   WHERE n.reversing_tran_id = o.tran_id
                                                     AND o.tran_flag <> 'D'
                                                     AND n.gacc_tran_id = h.gacc_tran_id
                                                     AND (   TRUNC (o.posting_date) IS NOT NULL
                                                          OR TRUNC (o.posting_date) <=
                                                                LAST_DAY (TO_DATE (v_mmrrrr,
                                                                                   'MM-RRRR'
                                                                                  )
                                                                         )
                                                         ))
                                           AND i.tran_class IN ('COL', 'DV', 'JV')
                                           AND i.tran_flag != 'D'
                                           AND DECODE (p_period_tag,
                                                       'M', TO_CHAR (i.posting_date, 'MM'),
                                                       'Y'
                                                      ) =
                                                  DECODE (p_period_tag,
                                                          'M', LTRIM (TO_CHAR (p_return_month,
                                                                               'FM09'
                                                                              )
                                                                     ),
                                                          'Y'
                                                         )
                                           AND TO_NUMBER (TO_CHAR (i.posting_date, 'RRRR')) =
                                                  DECODE (p_period_tag,
                                                          'M', p_return_myear,
                                                          TO_NUMBER (p_return_yyear)
                                                         )
                                      GROUP BY UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3),
                                               a.ri_tin*/
                                      UNION ALL                                   --ri reversals
                                      SELECT   'REINSURANCE' iss_source, UPPER (a.ri_name) ri_name,
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2
                                                     ) address1,
                                               UPPER (a.mail_address3) address2, a.ri_tin,
                                               -SUM (NVL (h.tax_amount, 0)) tax_amt,
                                               0 exempt_sales,
                                               -SUM (NVL (h.premium_amt, 0)) zero_rated_sales,
                                               0 taxable_sales
                                          FROM giac_inwfacul_prem_collns h,
                                               giac_acctrans i,
                                               giis_reinsurer a
                                         WHERE 1 = 1
                                           AND i.tran_id = h.gacc_tran_id
                                           AND h.a180_ri_cd = a.ri_cd
                                           AND check_user_per_iss_cd_acctg (NULL,
                                                                            i.gibr_branch_cd,
                                                                            'GIACS115'
                                                                           ) = 1
                                           AND EXISTS (
                                                  SELECT n.gacc_tran_id
                                                    FROM giac_reversals n, giac_acctrans o
                                                   WHERE n.reversing_tran_id = o.tran_id
                                                     AND o.tran_flag <> 'D'
                                                     AND n.gacc_tran_id = h.gacc_tran_id
                                                     AND DECODE (p_period_tag,
                                                                 'M', TO_CHAR (o.posting_date,
                                                                               'MM'
                                                                              ),
                                                                 'Y'
                                                                ) =
                                                            DECODE
                                                               (p_period_tag,
                                                                'M', LTRIM
                                                                       (TO_CHAR (p_return_month,
                                                                                 'FM09'
                                                                                )
                                                                       ),
                                                                'Y'
                                                               )
                                                     AND TO_NUMBER (TO_CHAR (o.posting_date,
                                                                             'RRRR'
                                                                            )
                                                                   ) =
                                                            DECODE (p_period_tag,
                                                                    'M', p_return_myear,
                                                                    TO_NUMBER (p_return_yyear)
                                                                   ))
                                           AND NOT EXISTS (
                                                  SELECT p.gacc_tran_id
                                                    FROM giac_advanced_payt p
                                                   WHERE p.gacc_tran_id = h.gacc_tran_id
                                                     AND p.iss_cd = h.b140_iss_cd
                                                     AND p.prem_seq_no = h.b140_prem_seq_no
                                                     AND p.inst_no = h.inst_no
                                                     AND (   p.acct_ent_date IS NULL
                                                          OR TRUNC (p.acct_ent_date) >=
                                                                LAST_DAY
                                                                       (TO_DATE (p_return_month,
                                                                                 'MM'
                                                                                )
                                                                       )
                                                         ))
                                           AND (   TRUNC (i.posting_date) IS NOT NULL
                                                OR TRUNC (i.posting_date) <=
                                                        LAST_DAY (TO_DATE (v_mmrrrr, 'MM-RRRR'))
                                               )
                                           AND i.tran_class IN ('COL', 'DV', 'JV')
                                           AND i.tran_flag != 'D'
                                      GROUP BY UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3),
                                               a.ri_tin
                                      UNION ALL
                                      SELECT   'REINSURANCE' iss_source, UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3), a.ri_tin,
                                               -SUM (NVL (h.tax_amount, 0)) tax_amt,
                                               0 exempt_sales,
                                               -SUM (NVL (h.premium_amt, 0)) zero_rated_sales,
                                               0 taxable_sales
                                          FROM giac_inwfacul_prem_collns h,
                                               giac_acctrans i,
                                               giac_advanced_payt p,
                                               giis_reinsurer a
                                         WHERE 1 = 1
                                           AND i.tran_id = p.gacc_tran_id
                                           AND h.gacc_tran_id = p.gacc_tran_id
                                           AND h.b140_iss_cd = p.iss_cd
                                           AND h.b140_prem_seq_no = p.prem_seq_no
                                           AND h.inst_no = p.inst_no
                                           AND h.a180_ri_cd = a.ri_cd
                                           AND i.tran_id = h.gacc_tran_id(+)
                                           AND check_user_per_iss_cd_acctg (NULL,
                                                                            i.gibr_branch_cd,
                                                                            'GIACS115'
                                                                           ) = 1
                                           AND EXISTS (
                                                  SELECT n.gacc_tran_id
                                                    FROM giac_reversals n, giac_acctrans o
                                                   WHERE n.reversing_tran_id = o.tran_id
                                                     AND o.tran_flag <> 'D'
                                                     AND n.gacc_tran_id = h.gacc_tran_id
                                                     AND DECODE (p_period_tag,
                                                                 'M', TO_CHAR (o.posting_date,
                                                                               'MM'
                                                                              ),
                                                                 'Y'
                                                                ) =
                                                            DECODE
                                                               (p_period_tag,
                                                                'M', LTRIM
                                                                       (TO_CHAR (p_return_month,
                                                                                 'FM09'
                                                                                )
                                                                       ),
                                                                'Y'
                                                               )
                                                     AND TO_NUMBER (TO_CHAR (o.posting_date,
                                                                             'RRRR'
                                                                            )
                                                                   ) =
                                                            DECODE (p_period_tag,
                                                                    'M', p_return_myear,
                                                                    TO_NUMBER (p_return_yyear)
                                                                   ))
                                           AND TRUNC (p.acct_ent_date) <=
                                                        LAST_DAY (TO_DATE (v_mmrrrr, 'MM-RRRR'))
                                      GROUP BY UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3),
                                               a.ri_tin
                                      /*UNION ALL
                                      SELECT   UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3), a.ri_tin,
                                               -SUM (NVL (h.comm_vat, 0)) tax_amt,
                                               0 exempt_sales,
                                               -SUM (DECODE (NVL (h.comm_vat, 0),
                                                             0, NVL (h.comm_amt, 0),
                                                             0
                                                            )
                                                    ) zero_rated_sales,
                                               -SUM (DECODE (NVL (h.comm_vat, 0),
                                                             0, 0,
                                                             NVL (h.comm_amt, 0)
                                                            )
                                                    ) taxable_sales
                                          FROM giac_outfacul_prem_payts h,
                                               giac_acctrans i,
                                               giis_reinsurer a
                                         WHERE 1 = 1
                                           AND i.tran_id = h.gacc_tran_id
                                           AND check_user_per_iss_cd_acctg (NULL,
                                                                            i.gibr_branch_cd,
                                                                            'GIACS115'
                                                                           ) = 1
                                           AND h.a180_ri_cd = a.ri_cd
                                           AND EXISTS (
                                                  SELECT n.gacc_tran_id
                                                    FROM giac_reversals n, giac_acctrans o
                                                   WHERE n.reversing_tran_id = o.tran_id
                                                     AND o.tran_flag <> 'D'
                                                     AND n.gacc_tran_id = h.gacc_tran_id
                                                     AND DECODE (p_period_tag,
                                                                 'M', TO_CHAR (o.posting_date,
                                                                               'MM'
                                                                              ),
                                                                 'Y'
                                                                ) =
                                                            DECODE
                                                               (p_period_tag,
                                                                'M', LTRIM
                                                                       (TO_CHAR (p_return_month,
                                                                                 'FM09'
                                                                                )
                                                                       ),
                                                                'Y'
                                                               )
                                                     AND TO_NUMBER (TO_CHAR (o.posting_date,
                                                                             'RRRR'
                                                                            )
                                                                   ) =
                                                            DECODE (p_period_tag,
                                                                    'M', p_return_myear,
                                                                    TO_NUMBER (p_return_yyear)
                                                                   ))
                                           AND i.tran_class IN ('COL', 'DV', 'JV')
                                           AND i.tran_flag != 'D'
                                           AND (   TRUNC (i.posting_date) IS NOT NULL
                                                OR TRUNC (i.posting_date) <=
                                                        LAST_DAY (TO_DATE (v_mmrrrr, 'MM-RRRR'))
                                               )
                                      GROUP BY UPPER (a.ri_name),
                                               UPPER (a.mail_address1 || ' ' || a.mail_address2),
                                               UPPER (a.mail_address3),
                                               a.ri_tin*/)
                            GROUP BY iss_source, ri_name, address1, address2, ri_tin
         )
      LOOP
         v_tin := giac_bir_rlf_alp.get_valid_tin (rec.payor_tin);

         INSERT INTO giac_relief_sls_ext
                     (return_month, return_year, iss_source, cust_tin, registered_name,
                      last_name, first_name, middle_name,
                      address1, address2, exempt_sales,
                      zero_rated_sales, taxable_sales_net_vat, output_tax,
                      tin_owner_listing, taxable_month, user_id,
                      last_update, period_tag
                     )
              VALUES (v_ret_mm, v_ret_yr, rec.iss_source, v_tin, rec.corporate_name,
                      rec.last_name, rec.first_name, rec.middle_initial,
                      rec.address1, rec.address2, rec.exempt_sales,
                      rec.zero_rated_sales, rec.taxable_sales, rec.tax_amt,
                      tin_listing_owner, tran_month, USER,
                      SYSDATE, p_period_tag
                     );
      END LOOP;

      COMMIT;
   END sls_vat;
END;
/


