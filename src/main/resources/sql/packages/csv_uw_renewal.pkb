CREATE OR REPLACE PACKAGE BODY cpi.csv_uw_renewal
AS
   FUNCTION get_giexr104 (
      p_policy_id       NUMBER,
      p_assd_no         NUMBER,
      p_intm_no         NUMBER,
      p_iss_cd          VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_line_cd         VARCHAR2,
      p_ending_date     VARCHAR2,
      p_starting_date   VARCHAR2,
      p_include_pack    VARCHAR2,
      p_claims_flag     VARCHAR2,
      p_balance_flag    VARCHAR2,
      p_is_package      VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN get_giexr104_tab PIPELINED
   IS
      details        get_giexr104_type;
      v_intm_no      VARCHAR2 (2000);
      v_intm_no2     VARCHAR2 (2000);
      v_intm_name    VARCHAR2 (240);
      item_desc      VARCHAR2 (500);
      makeformula    VARCHAR2 (500);
      v_assd_name    giis_assured.assd_name%TYPE;
      v_assd_name2   giis_assured.assd_name%TYPE;
   BEGIN
      FOR i IN
         (SELECT   b.pack_policy_id, b.iss_cd, b.line_cd, b.subline_cd,
                      b.line_cd
                   || '-'
                   || RTRIM (b.subline_cd)
                   || '-'
                   || RTRIM (b.iss_cd)
                   || '-'
                   || LTRIM (TO_CHAR (b.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (b.renew_no, '09')) policy_no,
                   b.issue_yy, b.pol_seq_no, b.renew_no, b.iss_cd iss_cd2,
                   b.line_cd line_cd2, b.subline_cd subline_cd2, b.tsi_amt,
                   b.ren_tsi_amt, b.prem_amt, b.ren_prem_amt, b.tax_amt,
                   b.expiry_date, d.line_name, e.subline_name, b.policy_id,
                   DECODE (b.balance_flag, 'Y', '*', NULL) balance_flag,
                   DECODE (b.claim_flag, 'Y', '*', NULL) claim_flag
              FROM giex_expiry b, giis_line d, giis_subline e
             WHERE 1 = 1
               AND b.line_cd = d.line_cd
               AND b.subline_cd = e.subline_cd
               AND d.line_cd = e.line_cd
               AND b.renew_flag = '2'
               AND NVL (b.post_flag, 'N') = 'N'
               AND b.policy_id = NVL (p_policy_id, b.policy_id)
               AND b.assd_no = NVL (p_assd_no, b.assd_no)
               AND NVL (b.intm_no, 0) = NVL (p_intm_no, NVL (b.intm_no, 0))
               AND UPPER (b.iss_cd) = NVL (UPPER (p_iss_cd), UPPER (b.iss_cd))
               AND UPPER (b.subline_cd) =
                              NVL (UPPER (p_subline_cd), UPPER (b.subline_cd))
               AND UPPER (b.line_cd) =
                                    NVL (UPPER (p_line_cd), UPPER (b.line_cd))
               AND TRUNC (b.expiry_date) <=
                      TRUNC (NVL (TO_DATE (p_ending_date, 'DD-MON-YYYY'),
                                  NVL (TO_DATE (p_starting_date,
                                                'DD-MON-YYYY'),
                                       b.expiry_date
                                      )
                                 )
                            )
               AND TRUNC (b.expiry_date) >=
                      DECODE (TO_DATE (p_ending_date, 'DD-MON-YYYY'),
                              NULL, TRUNC (b.expiry_date),
                              TRUNC (NVL (TO_DATE (p_starting_date,
                                                   'DD-MON-YYYY'
                                                  ),
                                          b.expiry_date
                                         )
                                    )
                             )
               AND NVL (b.claim_flag, 'N') LIKE
                      NVL (p_claims_flag,
                           DECODE (p_balance_flag, 'Y', 'N', '%')
                          )
               AND NVL (b.balance_flag, 'N') LIKE
                      NVL (p_balance_flag,
                           DECODE (p_claims_flag, 'Y', 'N', '%')
                          )
               AND (   check_user_per_iss_cd (NVL (UPPER (p_line_cd),
                                                   UPPER (b.line_cd)
                                                  ),
                                              NVL (UPPER (p_iss_cd),
                                                   UPPER (b.iss_cd)
                                                  ),
                                              'GIEXS006'
                                             ) = 1
                    OR check_user_per_line (NVL (UPPER (p_line_cd),
                                                 UPPER (b.line_cd)
                                                ),
                                            NVL (UPPER (p_iss_cd),
                                                 UPPER (b.iss_cd)
                                                ),
                                            'GIEXS006'
                                           ) = 1
                   )
               AND NVL (p_is_package, 'N') = 'N'
          UNION ALL
          SELECT DISTINCT b.pack_policy_id pack_policy_id, b.iss_cd,
                          b.line_cd, b.subline_cd,
                             b.line_cd
                          || '-'
                          || RTRIM (b.subline_cd)
                          || '-'
                          || RTRIM (b.iss_cd)
                          || '-'
                          || LTRIM (TO_CHAR (b.issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                          || '-'
                          || LTRIM (TO_CHAR (b.renew_no, '09')) policy_no,
                          b.issue_yy, b.pol_seq_no, b.renew_no,
                          b.iss_cd iss_cd2, b.line_cd line_cd2,
                          b.subline_cd subline_cd2, b.tsi_amt, b.ren_tsi_amt,
                          b.prem_amt, b.ren_prem_amt, b.tax_amt,
                          b.expiry_date, d.line_name, e.subline_name,
                          0 policy_id,
                          DECODE (b.balance_flag,
                                  'Y', '*',
                                  NULL
                                 ) balance_flag,
                          DECODE (b.claim_flag, 'Y', '*', NULL) claim_flag
                     FROM giex_pack_expiry b,
                          giex_expiry c,
                          giis_line d,
                          giis_subline e
                    WHERE 1 = 1
                      AND b.line_cd = d.line_cd
                      AND b.subline_cd = e.subline_cd
                      AND d.line_cd = e.line_cd
                      AND b.pack_policy_id = c.pack_policy_id
                      AND b.renew_flag = '2'
                      AND NVL (b.post_flag, 'N') = 'N'
                      AND b.pack_policy_id =
                                           NVL (p_policy_id, b.pack_policy_id)
                      AND b.assd_no = NVL (p_assd_no, b.assd_no)
                      AND NVL (b.intm_no, 0) =
                                           NVL (p_intm_no, NVL (b.intm_no, 0))
                      AND UPPER (b.iss_cd) =
                                      NVL (UPPER (p_iss_cd), UPPER (b.iss_cd))
                      AND UPPER (b.subline_cd) =
                              NVL (UPPER (p_subline_cd), UPPER (b.subline_cd))
                      AND UPPER (b.line_cd) =
                                    NVL (UPPER (p_line_cd), UPPER (b.line_cd))
                      AND TRUNC (b.expiry_date) <=
                             TRUNC (NVL (TO_DATE (p_ending_date,
                                                  'DD-MON-YYYY'),
                                         NVL (TO_DATE (p_starting_date,
                                                       'DD-MON-YYYY'
                                                      ),
                                              b.expiry_date
                                             )
                                        )
                                   )
                      AND TRUNC (b.expiry_date) >=
                             DECODE (TO_DATE (p_ending_date, 'DD-MON-YYYY'),
                                     NULL, TRUNC (b.expiry_date),
                                     TRUNC (NVL (TO_DATE (p_starting_date,
                                                          'DD-MON-YYYY'
                                                         ),
                                                 b.expiry_date
                                                )
                                           )
                                    )
                      AND DECODE (p_include_pack, 'N', b.pack_policy_id, 0) =
                                                                             0
                      AND NVL (b.claim_flag, 'N') LIKE
                             NVL (p_claims_flag,
                                  DECODE (p_balance_flag, 'Y', 'N', '%')
                                 )
                      AND NVL (b.balance_flag, 'N') LIKE
                             NVL (p_balance_flag,
                                  DECODE (p_claims_flag, 'Y', 'N', '%')
                                 )
                      AND (   check_user_per_iss_cd (NVL (UPPER (p_line_cd),
                                                          UPPER (b.line_cd)
                                                         ),
                                                     NVL (UPPER (p_iss_cd),
                                                          UPPER (b.iss_cd)
                                                         ),
                                                     'GIEXS006'
                                                    ) = 1
                           OR check_user_per_line (NVL (UPPER (p_line_cd),
                                                        UPPER (b.line_cd)
                                                       ),
                                                   NVL (UPPER (p_iss_cd),
                                                        UPPER (b.iss_cd)
                                                       ),
                                                   'GIEXS006'
                                                  ) = 1
                          )
                      AND NVL (p_is_package, 'Y') = 'Y'
                 ORDER BY 2, 3, 4, 5)
      LOOP
         details.policy_no := i.policy_no;
         details.tsi_amt := i.tsi_amt;
         details.prem_amt := i.prem_amt;
         details.tax_amt := i.tax_amt;
         details.expiry_date := i.expiry_date;
         details.line_name := i.line_cd || ' - ' || i.line_name;
         details.subline_name := i.subline_cd || ' - ' || i.subline_name;
         details.with_bal := i.balance_flag;
         details.with_clm := i.claim_flag;
         details.ren_tsi_amt := i.ren_tsi_amt;
         details.ren_prem_amt := i.ren_prem_amt;
         details.with_ri := NULL;

         FOR a IN (SELECT '*' marker
                     FROM giuw_pol_dist a, giuw_policyds_dtl b,
                          giex_expiry c
                    WHERE c.renew_flag = '2'
                      AND a.policy_id = c.policy_id
                      AND a.dist_no = b.dist_no
                      AND b.share_cd = '999'
                      AND c.policy_id = i.policy_id)
         LOOP
            details.with_ri := a.marker;
         END LOOP;

         BEGIN
            FOR j IN (SELECT a.assd_name
                        FROM giis_assured a, giex_expiry b
                       WHERE a.assd_no = b.assd_no
                         AND b.policy_id = i.policy_id)
            LOOP
               v_assd_name := j.assd_name;
            END LOOP;

            IF v_assd_name IS NULL
            THEN
               FOR c2 IN (SELECT a.assd_name
                            FROM giis_assured a, gipi_polbasic b
                           WHERE a.assd_no = b.assd_no
                             AND b.line_cd = i.line_cd
                             AND b.subline_cd = i.subline_cd
                             AND b.iss_cd = i.iss_cd
                             AND b.issue_yy = i.issue_yy
                             AND b.pol_seq_no = i.pol_seq_no
                             AND b.renew_no = i.renew_no)
               LOOP
                  v_assd_name := c2.assd_name;
               END LOOP;
            END IF;

            details.assd_name := v_assd_name;
         END;

         FOR c IN (SELECT a.ref_pol_no ref_pol_no
                     FROM gipi_polbasic a
                    WHERE a.policy_id = i.policy_id)
         LOOP
            details.ref_pol_no := c.ref_pol_no;
         END LOOP;

         BEGIN
            FOR k IN (SELECT   a.intm_name intm_name
                          FROM giis_intermediary a,
                               gipi_polbasic b,
                               gipi_invoice c,
                               gipi_comm_invoice d
                         WHERE b.policy_id = c.policy_id
                           AND c.iss_cd = d.iss_cd
                           AND c.prem_seq_no = d.prem_seq_no
                           AND c.policy_id = d.policy_id
                           AND b.line_cd = i.line_cd
                           AND b.subline_cd = i.subline_cd
                           AND b.iss_cd = i.iss_cd
                           AND b.issue_yy = i.issue_yy
                           AND b.pol_seq_no = i.pol_seq_no
                           AND b.renew_no = i.renew_no
                           AND a.intm_no = d.intrmdry_intm_no
                      ORDER BY a.intm_no)
            LOOP
               v_intm_name := k.intm_name;
            END LOOP;

            details.AGENT := v_intm_name;
         END;

         SELECT iss_cd || ' - ' || iss_name
           INTO details.iss_name
           FROM giis_issource
          WHERE iss_cd = i.iss_cd;

         IF    i.pack_policy_id IS NULL
            OR i.pack_policy_id = 0
            OR i.pack_policy_id = ''
         THEN
            details.tax_amt := 0;

            FOR tax IN (SELECT DISTINCT (NVL (b.policy_id, a.policy_id)
                                        ) policy_id,
                                        NVL (b.tax_cd, a.tax_cd) tax_cd,
                                        NVL (b.tax_amt, a.tax_amt) tax_amt
                                   FROM giex_old_group_tax a,
                                        giex_new_group_tax b
                                  WHERE a.policy_id = b.policy_id(+)
                                    AND a.line_cd = b.line_cd(+)
                                    AND a.iss_cd = b.iss_cd(+)
                                    AND a.iss_cd = i.iss_cd2
                                    AND a.policy_id = i.policy_id)
            LOOP
               details.tax_amt := details.tax_amt + NVL (tax.tax_amt, 0);
            END LOOP;
         ELSE
            details.tax_amt := 0;

            FOR tax IN (SELECT DISTINCT (NVL (b.policy_id, a.policy_id)
                                        ) policy_id,
                                        NVL (b.tax_cd, a.tax_cd) tax_cd,
                                        NVL (b.tax_amt, a.tax_amt) tax_amt
                                   FROM giex_old_group_tax a,
                                        giex_new_group_tax b,
                                        giex_expiry c
                                  WHERE a.policy_id = b.policy_id(+)
                                    AND a.line_cd = b.line_cd(+)
                                    AND a.iss_cd = b.iss_cd(+)
                                    AND a.iss_cd = c.iss_cd(+)
                                    AND a.policy_id = c.policy_id
                                    AND c.pack_policy_id = i.pack_policy_id)
            LOOP
               details.tax_amt := details.tax_amt + NVL (tax.tax_amt, 0);
            END LOOP;
         END IF;

         PIPE ROW (details);
      END LOOP;
   END;

   FUNCTION get_giexr105 (
      p_policy_id       NUMBER,
      p_assd_no         NUMBER,
      p_intm_no         NUMBER,
      p_iss_cd          VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_line_cd         VARCHAR2,
      p_ending_date     VARCHAR2,
      p_starting_date   VARCHAR2,
      p_include_pack    VARCHAR2,
      p_claims_flag     VARCHAR2,
      p_balance_flag    VARCHAR2,
      p_is_package      VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN get_giexr105_tab PIPELINED
   IS
      details        get_giexr105_type;
      v_intm_no      VARCHAR2 (2000);
      v_intm_no2     VARCHAR2 (2000);
      v_intm_name    VARCHAR2 (240);
      item_desc      VARCHAR2 (500);
      makeformula    VARCHAR2 (500);
      v_assd_name    giis_assured.assd_name%TYPE;
      v_assd_name2   giis_assured.assd_name%TYPE;
   BEGIN
      FOR i IN
         (SELECT   b.pack_policy_id, b.iss_cd, b.line_cd, b.subline_cd,
                      b.line_cd
                   || '-'
                   || RTRIM (b.subline_cd)
                   || '-'
                   || RTRIM (b.iss_cd)
                   || '-'
                   || LTRIM (TO_CHAR (b.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (b.renew_no, '09')) policy_no,
                   b.issue_yy, 
                   b.pol_seq_no, 
                   b.renew_no, 
                   b.iss_cd iss_cd2,
                   b.line_cd line_cd2, 
                   b.subline_cd subline_cd2, 
                   b.tsi_amt,
                   b.ren_tsi_amt, 
                   b.prem_amt, 
                   b.ren_prem_amt, 
                   b.tax_amt,
                   b.expiry_date, 
                   d.line_name, 
                   e.subline_name, 
                   b.policy_id,
                   DECODE (b.balance_flag, 'Y', '*', NULL) balance_flag,
                   DECODE (b.claim_flag, 'Y', '*', NULL) claim_flag
              FROM giex_expiry b, giis_line d, giis_subline e
             WHERE 1 = 1
               AND b.line_cd = d.line_cd
               AND b.subline_cd = e.subline_cd
               AND d.line_cd = e.line_cd
               AND b.renew_flag = '1'
               AND NVL (b.post_flag, 'N') = 'N'
               AND b.policy_id = NVL (p_policy_id, b.policy_id)
               AND b.assd_no = NVL (p_assd_no, b.assd_no)
               AND NVL (b.intm_no, 0) = NVL (p_intm_no, NVL (b.intm_no, 0))
               AND UPPER (b.iss_cd) = NVL (UPPER (p_iss_cd), UPPER (b.iss_cd))
               AND UPPER (b.subline_cd) =
                              NVL (UPPER (p_subline_cd), UPPER (b.subline_cd))
               AND UPPER (b.line_cd) =
                                    NVL (UPPER (p_line_cd), UPPER (b.line_cd))
               AND TRUNC (b.expiry_date) <=
                      TRUNC (NVL (TO_DATE (p_ending_date, 'DD-MON-YYYY'),
                                  NVL (TO_DATE (p_starting_date,
                                                'DD-MON-YYYY'),
                                       b.expiry_date
                                      )
                                 )
                            )
               AND TRUNC (b.expiry_date) >=
                      DECODE (TO_DATE (p_ending_date, 'DD-MON-YYYY'),
                              NULL, TRUNC (b.expiry_date),
                              TRUNC (NVL (TO_DATE (p_starting_date,
                                                   'DD-MON-YYYY'
                                                  ),
                                          b.expiry_date
                                         )
                                    )
                             )
               AND NVL (b.claim_flag, 'N') LIKE
                      NVL (p_claims_flag,
                           DECODE (p_balance_flag, 'Y', 'N', '%')
                          )
               AND NVL (b.balance_flag, 'N') LIKE
                      NVL (p_balance_flag,
                           DECODE (p_claims_flag, 'Y', 'N', '%')
                          )
               AND check_user_per_iss_cd2 (b.line_cd,
                                           b.iss_cd,
                                           'GIEXS006',
                                           p_user_id
                                          ) = 1
               AND NVL (p_is_package, 'N') = 'N'
               AND pack_policy_id IS NULL
          UNION ALL
          SELECT DISTINCT b.pack_policy_id pack_policy_id, c.iss_cd, c.line_cd, c.subline_cd,
                          get_policy_no (c.policy_id) policy_no, 
                          c.issue_yy,
                          c.pol_seq_no, 
                          b.renew_no, 
                          c.iss_cd iss_cd2,
                          c.line_cd line_cd2, 
                          c.subline_cd subline_cd2,
                          b.tsi_amt, 
                          b.ren_tsi_amt, 
                          b.prem_amt,
                          b.ren_prem_amt, 
                          b.tax_amt, 
                          b.expiry_date,
                          d.line_name, 
                          e.subline_name, 
                          c.policy_id,
                          DECODE (b.balance_flag,
                                  'Y', '*',
                                  NULL
                                 ) balance_flag,
                          DECODE (b.claim_flag, 'Y', '*', NULL) claim_flag
                     FROM giex_pack_expiry b,
                          giex_expiry c,
                          giis_line d,
                          giis_subline e
                    WHERE 1 = 1
                      AND c.line_cd = d.line_cd
                      AND c.subline_cd = e.subline_cd
                      AND d.line_cd = e.line_cd
                      AND b.pack_policy_id = c.pack_policy_id
                      AND b.renew_flag = '1'
                      AND NVL (b.post_flag, 'N') = 'N'
                      AND b.pack_policy_id =
                                           NVL (p_policy_id, b.pack_policy_id)
                      AND b.assd_no = NVL (p_assd_no, b.assd_no)
                      AND NVL (b.intm_no, 0) =
                                           NVL (p_intm_no, NVL (b.intm_no, 0))
                      AND UPPER (c.iss_cd) =
                                      NVL (UPPER (p_iss_cd), UPPER (c.iss_cd))
                      AND UPPER (c.subline_cd) =
                              NVL (UPPER (p_subline_cd), UPPER (c.subline_cd))
                      AND UPPER (c.line_cd) =
                                    NVL (UPPER (p_line_cd), UPPER (c.line_cd))
                      AND TRUNC (b.expiry_date) <=
                             TRUNC (NVL (TO_DATE (p_ending_date,
                                                  'DD-MON-YYYY'),
                                         NVL (TO_DATE (p_starting_date,
                                                       'DD-MON-YYYY'
                                                      ),
                                              b.expiry_date
                                             )
                                        )
                                   )
                      AND TRUNC (b.expiry_date) >=
                             DECODE (TO_DATE (p_ending_date, 'DD-MON-YYYY'),
                                     NULL, TRUNC (b.expiry_date),
                                     TRUNC (NVL (TO_DATE (p_starting_date,
                                                          'DD-MON-YYYY'
                                                         ),
                                                 b.expiry_date
                                                )
                                           )
                                    )
                      AND DECODE (p_include_pack, 'N', b.pack_policy_id, 0) =
                                                                             0
                      AND NVL (b.claim_flag, 'N') LIKE
                             NVL (p_claims_flag,
                                  DECODE (p_balance_flag, 'Y', 'N', '%')
                                 )
                      AND NVL (b.balance_flag, 'N') LIKE
                             NVL (p_balance_flag,
                                  DECODE (p_claims_flag, 'Y', 'N', '%')
                                 )
                      AND check_user_per_iss_cd2 (c.line_cd,
                                                  c.iss_cd,
                                                  'GIEXS006',
                                                  p_user_id
                                                 ) = 1
                      AND NVL (p_is_package, 'Y') = 'Y'
                 ORDER BY 2, 3, 4, 5)
      LOOP
         details.policy_no      := i.policy_no;
         details.tsi_amount     := i.tsi_amt;
         details.premium_amount := i.prem_amt;
         details.tax_amount     := i.tax_amt;
         details.total_due      := (i.prem_amt + i.tax_amt);
         details.expiry_date    := i.expiry_date;
         details.line_code      := i.line_cd || ' - ' || i.line_name;
         details.subline_code   := i.subline_cd || ' - ' || i.subline_name;
         details.with_balance   := i.balance_flag;
         details.with_claim     := i.claim_flag;

         FOR p IN (SELECT a.ref_pol_no ref_pol_no
                     FROM gipi_polbasic a
                    WHERE a.policy_id = i.policy_id)
         LOOP
            details.ref_policy_no := p.ref_pol_no;
         END LOOP;

         FOR t IN (SELECT DISTINCT a.intm_no,
                                      TO_CHAR (a.intm_no)
                                   || '/'
                                   || ref_intm_cd v_intm_no
                              FROM giis_intermediary a,
                                   gipi_polbasic b,
                                   gipi_invoice c,
                                   gipi_comm_invoice d
                             WHERE b.policy_id = c.policy_id
                               AND c.iss_cd = d.iss_cd
                               AND c.prem_seq_no = d.prem_seq_no
                               AND c.policy_id = d.policy_id
                               AND b.line_cd = i.line_cd
                               AND b.subline_cd = i.subline_cd
                               AND b.iss_cd = i.iss_cd
                               AND b.issue_yy = i.issue_yy
                               AND b.pol_seq_no = i.pol_seq_no
                               AND b.renew_no = i.renew_no
                               AND a.intm_no = d.intrmdry_intm_no
                          ORDER BY a.intm_no)
         LOOP
            IF v_intm_no = NULL
            THEN
               details.AGENT := RTRIM (t.v_intm_no, '/');
            ELSE
               details.AGENT := v_intm_no || ', ' || RTRIM (t.v_intm_no, '/');
            END IF;
         END LOOP;

         SELECT iss_cd || ' - ' || iss_name
           INTO details.issue_code
           FROM giis_issource
          WHERE iss_cd = i.iss_cd;

         SELECT a.assd_name
           INTO details.assured
           FROM giis_assured a, giex_expiry b
          WHERE a.assd_no = b.assd_no AND b.policy_id = i.policy_id;

         IF    i.pack_policy_id IS NULL
            OR i.pack_policy_id = 0
            OR i.pack_policy_id = ''
         THEN
            SELECT SUM (DISTINCT NVL (b.tax_amt, a.tax_amt)) tax_amt
              INTO details.tax_amount
              FROM giex_old_group_tax a, giex_new_group_tax b
             WHERE a.policy_id = b.policy_id(+)
               AND a.line_cd = b.line_cd(+)
               AND a.iss_cd = b.iss_cd(+)
               AND a.iss_cd = i.iss_cd2
               AND a.policy_id = i.policy_id;
         ELSE
            SELECT SUM (DISTINCT NVL (b.tax_amt, a.tax_amt)) tax_amt
              INTO details.tax_amount
              FROM giex_old_group_tax a, giex_new_group_tax b, giex_expiry c
             WHERE a.policy_id = b.policy_id(+)
               AND a.line_cd = b.line_cd(+)
               AND a.iss_cd = b.iss_cd(+)
               AND a.iss_cd = c.iss_cd(+)
               AND a.policy_id = c.policy_id
               AND c.pack_policy_id = i.pack_policy_id;
         END IF;

         PIPE ROW (details);
      END LOOP;
   END get_giexr105;
       
    FUNCTION get_giexr113 (
       p_line_cd         giex_expiries_v.line_cd%TYPE,
       p_subline_cd      giex_expiries_v.subline_cd%TYPE,
       p_iss_cd          giex_expiries_v.iss_cd%TYPE,
       p_intm_no         giex_expiries_v.intm_no%TYPE,
       p_assd_no         giex_expiries_v.assd_no%TYPE,
       p_policy_id       giex_expiries_v.policy_id%TYPE,
       p_starting_date   VARCHAR2,
       p_ending_date     VARCHAR2,
       p_include_pack    VARCHAR2,
       p_claim_flag      giex_expiries_v.claim_flag%TYPE,
       p_balance_flag    giex_expiries_v.balance_flag%TYPE
    )
       RETURN get_giexr113_tab PIPELINED
    IS
       res   get_giexr113_type;
    BEGIN
       FOR i IN
          (SELECT   a.policy_id, a.pack_policy_id,
                       a.line_cd
                    || '-'
                    || RTRIM (a.subline_cd)
                    || '-'
                    || RTRIM (a.iss_cd)
                    || '-'
                    || LTRIM (TO_CHAR (a.issue_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                    || '-'
                    || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                    a.line_cd, 
                    a.subline_cd, 
                    a.iss_cd, 
                    a.tsi_amt, 
                    a.prem_amt,
                    NVL (a.ren_tsi_amt, 0) ren_tsi_amt,
                    NVL (a.ren_prem_amt, 0) ren_prem_amt, 
                    a.tax_amt,
                    a.expiry_date,
                    DECODE (a.balance_flag, 'Y', '*', NULL) balance_flag,
                    DECODE (a.claim_flag, 'Y', '*', NULL) claim_flag,
                    b.line_name, 
                    c.subline_name, 
                    d.iss_name, 
                    a.assd_no,
                    e.assd_name
               FROM giex_expiry a,
                    giis_line b,
                    giis_subline c,
                    giis_issource d,
                    giis_assured e
              WHERE a.line_cd = b.line_cd
                AND a.line_cd = c.line_cd
                AND a.subline_cd = c.subline_cd
                AND a.iss_cd = d.iss_cd
                AND a.assd_no = e.assd_no
                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                AND NVL (a.intm_no, 0) = NVL (p_intm_no, NVL (a.intm_no, 0))
                AND a.assd_no = NVL (p_assd_no, a.assd_no)
                AND NVL (a.post_flag, 'N') = 'N'
                AND a.policy_id = NVL (p_policy_id, a.policy_id)
                AND TRUNC (a.expiry_date)
                       BETWEEN TRUNC (NVL (TO_DATE (p_starting_date, 'dd-MM-RRRR'),
                                           NVL (TO_DATE (p_ending_date,
                                                         'dd-MM-RRRR'
                                                        ),
                                                a.expiry_date
                                               )
                                          )
                                     )
                           AND TRUNC (NVL (TO_DATE (p_ending_date, 'dd-MM-RRRR'),
                                           NVL (TO_DATE (p_starting_date,
                                                         'dd-MM-RRRR'
                                                        ),
                                                a.expiry_date
                                               )
                                          )
                                     )
                AND NVL (a.claim_flag, 'N') LIKE
                        NVL (p_claim_flag, DECODE (p_balance_flag, 'Y', 'N', '%'))
                AND NVL (a.balance_flag, 'N') LIKE
                        NVL (p_balance_flag, DECODE (p_claim_flag, 'Y', 'N', '%'))
                AND pack_policy_id IS NULL
           UNION ALL
           SELECT   f.policy_id, a.pack_policy_id,
                       f.line_cd
                    || '-'
                    || RTRIM (f.subline_cd)
                    || '-'
                    || RTRIM (f.iss_cd)
                    || '-'
                    || LTRIM (TO_CHAR (f.issue_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (f.pol_seq_no, '0999999'))
                    || '-'
                    || LTRIM (TO_CHAR (f.renew_no, '09')) policy_no,
                    f.line_cd, 
                    f.subline_cd,
                    f.iss_cd, 
                    a.tsi_amt, 
                    a.prem_amt,
                    NVL (a.ren_tsi_amt, 0) ren_tsi_amt,
                    NVL (a.ren_prem_amt, 0) ren_prem_amt, 
                    a.tax_amt,
                    a.expiry_date,
                    DECODE (a.balance_flag, 'Y', '*', NULL) balance_flag,
                    DECODE (a.claim_flag, 'Y', '*', NULL) claim_flag, 
                    b.line_name,
                    c.subline_name,
                    d.iss_name, 
                    a.assd_no, 
                    e.assd_name
               FROM giex_pack_expiry a,
                    giex_expiry f,
                    giis_line b,
                    giis_subline c,
                    giis_issource d,
                    giis_assured e
              WHERE c.line_cd = b.line_cd
                AND a.pack_policy_id = f.pack_policy_id
                AND b.line_cd = c.line_cd
                AND f.subline_cd = c.subline_cd
                AND f.iss_cd = d.iss_cd
                AND a.assd_no = e.assd_no
                AND a.pack_policy_id = NVL (p_policy_id, a.pack_policy_id)
                AND f.line_cd = NVL (p_line_cd, f.line_cd)
                AND f.subline_cd = NVL (p_subline_cd, f.subline_cd)
                AND f.iss_cd = NVL (p_iss_cd, f.iss_cd)
                AND NVL (f.intm_no, 0) = NVL (p_intm_no, NVL (f.intm_no, 0))
                AND a.assd_no = NVL (p_assd_no, a.assd_no)
                AND NVL (a.post_flag, 'N') = 'N'
                AND TRUNC (a.expiry_date)
                       BETWEEN TRUNC (NVL (TO_DATE (p_starting_date,
                                                    'dd-MM-RRRR'),
                                           NVL (TO_DATE (p_ending_date,
                                                         'dd-MM-RRRR'
                                                        ),
                                                a.expiry_date
                                               )
                                          )
                                     )
                           AND TRUNC (NVL (TO_DATE (p_ending_date, 'dd-MM-RRRR'),
                                           NVL (TO_DATE (p_starting_date,
                                                         'dd-MM-RRRR'
                                                        ),
                                                a.expiry_date
                                               )
                                          )
                                     )
                AND DECODE (p_include_pack, 'N', a.pack_policy_id, 0) = 0
                AND NVL (a.claim_flag, 'N') LIKE
                       NVL (p_claim_flag,
                            DECODE (p_balance_flag, 'Y', 'N', '%'))
                AND NVL (a.balance_flag, 'N') LIKE
                       NVL (p_balance_flag,
                            DECODE (p_claim_flag, 'Y', 'N', '%'))
           ORDER BY assd_name, line_cd)
   LOOP
      res.policy_no     := i.policy_no;
      res.tsi_amt       := i.tsi_amt;
      res.prem_amt      := i.prem_amt;
      res.ren_tsi_amt   := i.ren_tsi_amt;
      res.ren_prem_amt  := i.ren_prem_amt;
      res.tax_amt       := i.tax_amt;
      res.expiry_date   := i.expiry_date;
      res.balance_flag  := i.balance_flag;
      res.claim_flag    := i.claim_flag;
      res.assd_name     := i.assd_no || ' - ' || i.assd_name;
      res.line_name     := i.line_cd || ' - ' || i.line_name;
      res.subline_name  := i.subline_cd || ' - ' || i.subline_name;
      res.iss_name      := i.iss_cd || ' - ' || i.iss_name;
      res.total_due     := i.ren_prem_amt + NVL(i.tax_amt, 0);

      SELECT ref_pol_no
        INTO res.ref_pol_no
        FROM gipi_polbasic
       WHERE policy_id = i.policy_id AND ROWNUM = 1;

      PIPE ROW (res);
   END LOOP;
END get_giexr113;

--  Start: Added by Kevin 4-6-2016 SR-5491
   FUNCTION get_giexr108 (
      p_date_from   DATE,
      p_date_to     DATE,
      p_iss_cd      VARCHAR2,
      p_cred_cd     VARCHAR2,
      p_intm_no     NUMBER,
      p_line_cd     VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN get_giexr108_tab PIPELINED
   IS
      details             get_giexr108_type;
      v_report_title      giis_reports.report_title%TYPE;
      v_new_pol_id        VARCHAR2 (50)                     := NULL;
      v_pack_policy_id    VARCHAR2 (500);
   BEGIN
      BEGIN
         SELECT report_title
           INTO v_report_title
           FROM giis_reports
          WHERE report_id = 'GIEXR108';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_report_title := NULL;
      END;

      FOR i IN
         (SELECT DISTINCT h.iss_name iss_name, f.line_name line_name,
                          g.subline_name subline_name,
                          TO_CHAR (a.intm_no, '099999999999') intm_number,
                          a.assd_no assured_no, b.assd_name assured_name,
                          TO_CHAR (c.expiry_date, 'MM/DD/RRRR') expiry_date,
                          c.policy_id,
                             c.line_cd
                          || '-'
                          || c.subline_cd
                          || '-'
                          || c.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (c.issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                          || '-'
                          || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                          a.prem_amt premium_amt,
                          DECODE (a.renewal_tag,
                                  'Y', a.prem_renew_amt,
                                  0
                                 ) premium_renew_amt,
                          DECODE
                              (a.renewal_tag,
                               'Y', c.line_cd
                                || '-'
                                || c.iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                || '-'
                                || LTRIM (TO_CHAR (c.renew_no, '09'))
                              ) renewal_policy,
                          DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                          c.ref_pol_no
                     FROM giex_ren_ratio_dtl a,
                          gipi_polbasic c,
                          giis_assured b,
                          giis_line f,
                          giis_subline g,
                          giis_issource h
                    WHERE 1 = 1
                      AND h.iss_cd = a.iss_cd
                      AND f.line_cd = a.line_cd
                      AND g.subline_cd = a.subline_cd
                      AND g.line_cd = a.line_cd
                      AND b.assd_no = a.assd_no
                      AND c.policy_id = a.policy_id
                      AND a.user_id = p_user_id
                      AND TRUNC (c.expiry_date) BETWEEN TRUNC (p_date_from)
                                                    AND TRUNC (p_date_to)
                      AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                      AND c.cred_branch = NVL (p_cred_cd, c.cred_branch)
                      AND a.intm_no = NVL (p_intm_no, a.intm_no)
                      AND a.line_cd = NVL (p_line_cd, a.line_cd)
                      AND a.pack_policy_id = 0
          UNION
          SELECT DISTINCT h.iss_name iss_name, f.line_name line_name,
                          g.subline_name subline_name,
                          TO_CHAR (a.intm_no, '099999999999') intm_number,
                          a.assd_no assured_no, b.assd_name assured_name,
                          TO_CHAR (c.expiry_date, 'MM/DD/RRRR') expiry_date,
                          c.pack_policy_id policy_id,
                             c.line_cd
                          || '-'
                          || c.subline_cd
                          || '-'
                          || c.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (c.issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                          || '-'
                          || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                          a.prem_amt premium_amt,
                          DECODE (a.renewal_tag,
                                  'Y', a.prem_renew_amt,
                                  0
                                 ) premium_renew_amt,
                          DECODE
                              (a.renewal_tag,
                               'Y', c.line_cd
                                || '-'
                                || c.iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                || '-'
                                || LTRIM (TO_CHAR (c.renew_no, '09'))
                              ) renewal_policy,
                          DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                          c.ref_pol_no
                     FROM giex_ren_ratio_dtl a,
                          gipi_pack_polbasic c,
                          giis_assured b,
                          giis_line f,
                          giis_subline g,
                          giis_issource h
                    WHERE 1 = 1
                      AND h.iss_cd = a.iss_cd
                      AND f.line_cd = a.line_cd
                      AND g.subline_cd = a.subline_cd
                      AND g.line_cd = a.line_cd
                      AND b.assd_no = a.assd_no
                      AND c.pack_policy_id = a.pack_policy_id
                      AND a.pack_policy_id = a.policy_id
                      AND a.user_id = p_user_id
                      AND TRUNC (c.expiry_date) BETWEEN TRUNC (p_date_from)
                                                    AND TRUNC (p_date_to)
                      AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                      AND c.cred_branch = NVL (p_cred_cd, c.cred_branch)
                      AND a.intm_no = NVL (p_intm_no, a.intm_no)
                      AND a.line_cd = NVL (p_line_cd, a.line_cd)
                 ORDER BY intm_number)
      LOOP
         BEGIN
            BEGIN
               FOR a IN (SELECT pack_policy_id
                           FROM giex_ren_ratio_dtl
                          WHERE policy_id = i.policy_id)
               LOOP
                  v_pack_policy_id := a.pack_policy_id;
               END LOOP;
            END;

            IF i.remarks = 'RENEWED'
            THEN
               IF v_pack_policy_id = 0
               THEN
                  FOR c1 IN
                     (SELECT get_policy_no (new_policy_id) renewal_policy,
                             new_policy_id
                        FROM gipi_polnrep a
                       WHERE old_policy_id = i.policy_id)
                  LOOP
                     v_new_pol_id := c1.new_policy_id;                  --jen
                  END LOOP;
               ELSE
                  FOR c1 IN
                     (SELECT get_pack_policy_no
                                           (new_pack_policy_id)
                                                              renewal_policy,
                             new_pack_policy_id
                        FROM gipi_pack_polnrep a
                       WHERE old_pack_policy_id = i.policy_id)
                  LOOP
                     v_new_pol_id := c1.new_pack_policy_id;             --jen
                  END LOOP;
               END IF;
            END IF;
         END;

         details.issue_source := i.iss_name;
         details.line_name := i.line_name;
         details.subline_name := i.subline_name;
         details.agent_code := i.intm_number;
         details.agent_name := giexr108_pkg.intm_name_formula (i.intm_number);
         details.assured_name := i.assured_name;
         details.expiry_date :=
                TO_CHAR (giexr108_pkg.expiry_date (i.policy_id), 'MM-DD-RRRR');
         details.premium_amount :=
                                  TO_CHAR (i.premium_amt, '99,999,999,999.99');
         details.premium_renewal_amount :=
                            TO_CHAR (i.premium_renew_amt, '99,999,999,999.99');
         details.policy_number := i.policy_no;
         details.reference_policy_number := i.ref_pol_no;
         details.remarks := i.remarks;
         details.renewal_policy_number :=
                  giexr108_pkg.renewal_policy_formula (i.remarks, i.policy_id);
         details.ref_renewal_policy_number :=
                                       giexr108_pkg.ref_ren_pol (v_new_pol_id);
         PIPE ROW (details);
      END LOOP;
   END;

   FUNCTION intm_name_formula (p_intm_no giex_ren_ratio_dtl.intm_no%TYPE)
      RETURN VARCHAR2
   IS
      v_intm_name   giis_intermediary.intm_name%TYPE;
   BEGIN
      FOR a IN (SELECT intm_name
                  FROM giis_intermediary
                 WHERE intm_no = p_intm_no)
      LOOP
         v_intm_name := a.intm_name;
      END LOOP;

      RETURN (v_intm_name);
   END;

   FUNCTION renewal_policy_formula (
      p_remarks     VARCHAR2,
      p_policy_id   gipi_polbasic.policy_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_renewal_policy   VARCHAR2 (500) := NULL;
      v_new_pol_id       VARCHAR2 (50)  := NULL;                        --jen
      v_pack_policy_id   VARCHAR (500)  := NULL;
   BEGIN
      BEGIN
         FOR a IN (SELECT pack_policy_id
                     FROM giex_ren_ratio_dtl
                    WHERE policy_id = p_policy_id)
         LOOP
            v_pack_policy_id := a.pack_policy_id;
         END LOOP;
      END;

      IF p_remarks = 'RENEWED'
      THEN
         IF v_pack_policy_id = 0
         THEN
            FOR c1 IN
               (SELECT DISTINCT (get_policy_no (new_policy_id)
                                ) renewal_policy,
                                new_policy_id
                           FROM gipi_polnrep a, gipi_polbasic b
                          WHERE old_policy_id = p_policy_id
                            AND ren_rep_sw = 1
                            AND EXISTS (
                                   SELECT '1'
                                     FROM gipi_polbasic c
                                    WHERE c.policy_id = a.new_policy_id
                                      AND c.pol_flag IN ('1', '2', '3', 'X')))
            LOOP
               FOR c2 IN
                  (SELECT DISTINCT (get_policy_no (new_policy_id)
                                   ) renewal_policy,
                                   new_policy_id
                              FROM gipi_polnrep a, gipi_polbasic b
                             WHERE old_policy_id = c1.new_policy_id
                               AND ren_rep_sw = 1
                               AND EXISTS (
                                      SELECT '1'
                                        FROM gipi_polbasic c
                                       WHERE c.policy_id = a.new_policy_id
                                         AND c.pol_flag IN
                                                         ('1', '2', '3', 'X')))
               LOOP
                  v_renewal_policy :=
                             v_renewal_policy || CHR (10)
                             || c2.renewal_policy;
                  v_new_pol_id := v_new_pol_id || CHR (10)
                                  || c2.new_policy_id;
               END LOOP;

               v_renewal_policy :=
                              v_renewal_policy || CHR (10)
                              || c1.renewal_policy;
               v_new_pol_id := v_new_pol_id || CHR (10) || c1.new_policy_id;
            --jen
            END LOOP;
         ELSE
            FOR c1 IN
               (SELECT DISTINCT (get_pack_policy_no (new_pack_policy_id)
                                ) renewal_policy,
                                new_pack_policy_id
                           FROM gipi_pack_polnrep a, gipi_pack_polbasic b
                          WHERE old_pack_policy_id = p_policy_id
                            AND ren_rep_sw = 1
                            AND EXISTS (
                                   SELECT '1'
                                     FROM gipi_polbasic c
                                    WHERE c.pack_policy_id =
                                                          a.new_pack_policy_id
                                      AND c.pol_flag IN ('1', '2', '3', 'X')))
            LOOP
               FOR c2 IN
                  (SELECT DISTINCT (get_pack_policy_no (new_pack_policy_id)
                                   ) renewal_policy,
                                   new_pack_policy_id
                              FROM gipi_pack_polnrep a, gipi_pack_polbasic b
                             WHERE old_pack_policy_id = c1.new_pack_policy_id
                               AND ren_rep_sw = 1
                               AND EXISTS (
                                      SELECT '1'
                                        FROM gipi_polbasic c
                                       WHERE c.pack_policy_id =
                                                          a.new_pack_policy_id
                                         AND c.pol_flag IN
                                                         ('1', '2', '3', 'X')))
               LOOP
                  v_renewal_policy :=
                             v_renewal_policy || CHR (10)
                             || c2.renewal_policy;
                  v_new_pol_id :=
                             v_new_pol_id || CHR (10)
                             || c2.new_pack_policy_id;
               END LOOP;

               v_renewal_policy :=
                              v_renewal_policy || CHR (10)
                              || c1.renewal_policy;
               v_new_pol_id :=
                              v_new_pol_id || CHR (10)
                              || c1.new_pack_policy_id;                  --jen
            END LOOP;
         END IF;
      END IF;

      RETURN LTRIM (v_renewal_policy, CHR (10));
   END;

   FUNCTION ref_ren_pol (p_cp_1 NUMBER)
      RETURN VARCHAR2
   IS
      v_ref_ren_pol      VARCHAR2 (30);
      v_pack_policy_id   VARCHAR2 (500);
   BEGIN
      BEGIN
         FOR a IN (SELECT pack_policy_id
                     FROM giex_ren_ratio_dtl
                    WHERE policy_id = p_cp_1)
         LOOP
            v_pack_policy_id := a.pack_policy_id;
         END LOOP;
      END;

      IF v_pack_policy_id = 0
      THEN
         FOR i IN (SELECT ref_pol_no
                     FROM gipi_polbasic
                    WHERE policy_id = p_cp_1)
         LOOP
            v_ref_ren_pol := i.ref_pol_no;
         END LOOP;
      ELSE
         FOR i IN (SELECT ref_pol_no
                     FROM gipi_pack_polbasic
                    WHERE pack_policy_id = p_cp_1)
         LOOP
            v_ref_ren_pol := i.ref_pol_no;
         END LOOP;
      END IF;

      RETURN (v_ref_ren_pol);
   END;

   FUNCTION expiry_date (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN DATE
   IS
      v_expiry_date      DATE;
      v_pack_policy_id   VARCHAR2 (500);
   BEGIN
      BEGIN
         FOR a IN (SELECT pack_policy_id
                     FROM giex_ren_ratio_dtl
                    WHERE policy_id = p_policy_id)
         LOOP
            v_pack_policy_id := a.pack_policy_id;
         END LOOP;
      END;

      IF v_pack_policy_id = 0
      THEN
         FOR a IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                          renew_no
                     FROM gipi_polbasic
                    WHERE policy_id = p_policy_id)
         LOOP
            FOR b IN (SELECT   expiry_date
                          FROM gipi_polbasic
                         WHERE line_cd = a.line_cd
                           AND subline_cd = a.subline_cd
                           AND iss_cd = a.iss_cd
                           AND issue_yy = a.issue_yy
                           AND pol_seq_no = a.pol_seq_no
                           AND renew_no = a.renew_no
                      ORDER BY endt_seq_no DESC)
            LOOP
               v_expiry_date := b.expiry_date;
               EXIT;
            END LOOP;
         END LOOP;
      ELSE
         FOR a IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                          renew_no
                     FROM gipi_pack_polbasic
                    WHERE pack_policy_id = p_policy_id)
         LOOP
            FOR b IN (SELECT   expiry_date
                          FROM gipi_pack_polbasic
                         WHERE line_cd = a.line_cd
                           AND subline_cd = a.subline_cd
                           AND iss_cd = a.iss_cd
                           AND issue_yy = a.issue_yy
                           AND pol_seq_no = a.pol_seq_no
                           AND renew_no = a.renew_no
                      ORDER BY endt_seq_no DESC)
            LOOP
               v_expiry_date := b.expiry_date;
               EXIT;
            END LOOP;
         END LOOP;
      END IF;

      RETURN (v_expiry_date);
   END;
--  End: Added by Kevin 4-6-2016 SR-5491

 /*
 * Created by : Herbert Tagudin
 * Date Created : 04/07/2016
 * Reference By : GIEXR112
 */
 
    FUNCTION csv_giexr112  (
        p_line_cd           GIEX_REN_RATIO_DTL.line_cd%TYPE,
        p_iss_cd            GIEX_REN_RATIO_DTL.iss_cd%TYPE,
        p_subline_cd        GIEX_REN_RATIO_DTL.subline_cd%TYPE,
        p_policy_id         GIEX_REN_RATIO_DTL.policy_id%TYPE,
        p_assd_no           GIEX_REN_RATIO_DTL.assd_no%TYPE,
        p_intm_no           GIEX_REN_RATIO_DTL.intm_no%TYPE,
        p_starting_date     DATE,
        p_ending_date       DATE,
        p_user_id           GIEX_REN_RATIO_DTL.user_id%TYPE
    )
      RETURN get_giexr112_tab PIPELINED  AS
        v_main              get_giexr112_type;
        v_due               NUMBER := 0;
        v_bal               VARCHAR2(1);
        v_claim             VARCHAR2(1);
        v_intm_no           VARCHAR2(2000);
        v_intm_name         VARCHAR2(5000);
    BEGIN
        FOR i IN (SELECT DISTINCT a.policy_id,
                         a.pack_policy_id,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd,
                         a.iss_cd iss_cd2,
                         a.line_cd line_cd2,
                         a.subline_cd subline_cd2,
                         b.issue_yy,
                         b.pol_seq_no,
                         b.renew_no,
                         a.line_cd||'-'||
                         RTRIM(a.subline_cd)||'-'||
                         RTRIM(a.iss_cd)||'-'||
                         LTRIM(TO_CHAR(b.issue_yy,'09'))||'-'||
                         LTRIM(TO_CHAR(b.pol_seq_no,'0999999'))||'-'||
                         LTRIM(TO_CHAR(b.renew_no,'09')) policy_no,
                         b.tsi_amt,
                         b.prem_amt,
                         c.tax_amt,
                         b.expiry_date,
                         d.line_name,
                         e.subline_name ,
                         get_assd_name(b.assd_no) assd_name
                    FROM GIEX_REN_RATIO_DTL a,
                         GIPI_POLBASIC b,
                         GIPI_INVOICE c,
                         GIIS_LINE d,
                         GIIS_SUBLINE e
                   WHERE a.policy_id = b.policy_id
                     AND a.policy_id = c.policy_id 
                     AND a.line_cd = d.line_cd
                     AND a.subline_cd = e.subline_cd   
                     AND a.renewal_tag = 'N'             
                     AND a.policy_id = NVL(p_policy_id, a.policy_id)
                     AND a.assd_no = NVL(p_assd_no, a.assd_no)
                     AND NVL(a.intm_no,0) = NVL(p_intm_no,NVL(a.intm_no,0)) 
                     AND UPPER(a.iss_cd) = NVL(UPPER(p_iss_cd),UPPER(a.iss_cd))
                     AND UPPER(a.subline_cd) = NVL(UPPER(p_subline_cd),UPPER(a.subline_cd))
                     AND UPPER(a.line_cd) = NVL(UPPER(p_line_cd),UPPER(a.line_cd))
                     AND NVL(a.pack_policy_id,0) = 0
                     AND a.user_id = p_user_id
                     AND e.line_cd =  b.line_cd
                     AND TRUNC(b.expiry_date) <= TRUNC(NVL(p_ending_date, NVL(p_starting_date, b.expiry_date)))
                     AND TRUNC(b.expiry_date) >= DECODE(p_ending_date, NULL, TRUNC(b.expiry_date), TRUNC(NVL(p_starting_date, b.expiry_date)))
                   UNION ALL
                  SELECT DISTINCT a.policy_id,
                         a.pack_policy_id,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd,
                         a.iss_cd iss_cd2,
                         a.line_cd line_cd2,
                         a.subline_cd subline_cd2,
                         b.issue_yy,
                         b.pol_seq_no,
                         b.renew_no,
                         a.line_cd||'-'||
                         RTRIM(a.subline_cd)||'-'||
                         RTRIM(a.iss_cd)||'-'||
                         LTRIM(TO_CHAR(b.issue_yy,'09'))||'-'||
                         LTRIM(TO_CHAR(b.pol_seq_no,'0999999'))||'-'||
                         LTRIM(TO_CHAR(b.renew_no,'09')) policy_no,
                         b.tsi_amt,
                         b.prem_amt,
                         c.tax_amt,
                         b.expiry_date,
                         d.line_name,
                         e.subline_name,
                         get_assd_name(b.assd_no) assd_name
                    FROM GIEX_REN_RATIO_DTL a,
                         GIPI_PACK_POLBASIC b,
                         GIPI_INVOICE c,
                         GIIS_LINE d,
                         GIIS_SUBLINE e
                 WHERE a.pack_policy_id       = b.pack_policy_id
                   AND a.policy_id               = c.policy_id 
                   AND a.line_cd               = d.line_cd
                   AND a.subline_cd           = e.subline_cd   
                   AND a.renewal_tag          = 'N'             
                   AND a.pack_policy_id    = NVL(p_policy_id, a.pack_policy_id)
                   AND a.assd_no               = NVL(p_assd_no, a.assd_no)
                   AND NVL(a.intm_no,0)       = NVL(p_intm_no,NVL(a.intm_no,0)) 
                   AND UPPER(a.iss_cd)     = NVL(UPPER(p_iss_cd),UPPER(a.iss_cd))
                   AND UPPER(a.subline_cd) = NVL(UPPER(p_subline_cd),UPPER(a.subline_cd))
                   AND UPPER(a.line_cd)    = NVL(UPPER(p_line_cd),UPPER(a.line_cd))
                   AND ((a.pack_policy_id = a.policy_id AND a.pack_policy_id > 0) OR a.pack_policy_id = 0)
                   AND a.user_id = p_user_id
                   AND TRUNC(b.expiry_date) <=TRUNC(NVL(p_ending_date, NVL(p_starting_date, b.expiry_date)))
                   AND TRUNC(b.expiry_date) >= DECODE(p_ending_date, NULL, TRUNC(b.expiry_date), TRUNC(NVL(p_starting_date, b.expiry_date)))
                 ORDER BY iss_cd, line_cd, subline_cd, expiry_date, policy_no) --added by Carlo Rubenecia SR5499 05.30.2016
        LOOP
            BEGIN
                SELECT iss_cd || ' - ' || iss_name
                  INTO v_main.issue_code
                  FROM GIIS_ISSOURCE
                 WHERE iss_cd  = i.iss_cd;
            END;
            
            BEGIN
                IF NVL(i.pack_policy_id, 0) > 0 THEN
                    FOR d IN(SELECT SUM(c.balance_amt_due) due
                               FROM GIPI_POLBASIC a,
                                    GIPI_INVOICE b,
                                    GIAC_AGING_SOA_DETAILS c,
                                    GIEX_REN_RATIO_DTL d,
                                    GIPI_PACK_POLBASIC x
                              WHERE a.pack_policy_id = x.pack_policy_id
                                AND a.line_cd     = i.line_cd
                                AND a.subline_cd  = i.subline_cd
                                AND a.iss_cd      = i.iss_cd
                                AND a.issue_yy    = i.issue_yy
                                AND a.pol_seq_no  = i.pol_seq_no
                                AND a.renew_no    = i.renew_no
                                AND a.pol_flag IN ('1','2','3')
                                AND a.policy_id = b.policy_id
                                AND a.policy_id = d.policy_id
                                AND b.iss_cd = c.iss_cd
                                AND b.prem_seq_no = c.prem_seq_no)
                    LOOP
                        v_due := d.due;
                    END LOOP;
                ELSE    
                    FOR d IN(SELECT SUM(c.balance_amt_due) due
                               FROM GIPI_POLBASIC a,
                                    GIPI_INVOICE b,
                                    GIAC_AGING_SOA_DETAILS c,
                                    GIEX_REN_RATIO_DTL d
                              WHERE a.line_cd     = i.line_cd
                                AND a.subline_cd  = i.subline_cd
                                AND a.iss_cd      = i.iss_cd
                                AND a.issue_yy    = i.issue_yy
                                AND a.pol_seq_no  = i.pol_seq_no
                                AND a.renew_no    = i.renew_no
                                AND a.pol_flag IN ('1','2','3')
                                AND a.policy_id = b.policy_id
                                AND a.policy_id = d.policy_id
                                AND b.iss_cd = c.iss_cd
                                AND b.prem_seq_no = c.prem_seq_no)
                    LOOP
                        v_due := d.due;
                    END LOOP;    
                END IF;
                    
                IF v_due <> 0 THEN
                    v_bal := '*';
                ELSE
                    v_bal := NULL;
                END IF;
            END;
            
            v_claim := NULL;
            IF NVL(i.pack_policy_id, 0) <> 0 THEN
                FOR a3 IN (SELECT '1'
                             FROM GICL_CLAIMS x
                            WHERE clm_stat_cd NOT IN ('CC','WD','DN')
                              AND EXISTS (SELECT '1' 
                                            FROM gipi_polbasic a, gipi_pack_polbasic b
                                           WHERE a.pack_policy_id = b.pack_policy_id
                                             AND b.line_cd     = i.line_cd
                                             AND b.subline_cd  = i.subline_cd
                                             AND b.iss_cd      = i.iss_cd
                                             AND b.issue_yy    = i.issue_yy
                                             AND b.pol_seq_no  = i.pol_seq_no
                                             AND b.renew_no    = i.renew_no
                                             AND x.line_cd     = a.line_cd
                                             AND x.subline_cd  = a.subline_cd
                                             AND x.pol_iss_cd  = a.iss_cd
                                             AND x.issue_yy    = a.issue_yy
                                             AND x.pol_seq_no  = a.pol_seq_no
                                             AND x.renew_no    = a.renew_no))
                 LOOP
                     v_claim := '*';
                     EXIT;
                 END LOOP;
            ELSE
                FOR a3 IN (SELECT '1'
                             FROM GICL_CLAIMS
                            WHERE line_cd     = i.line_cd
                              AND subline_cd  = i.subline_cd
                              AND pol_iss_cd  = i.iss_cd
                              AND issue_yy    = i.issue_yy
                              AND pol_seq_no  = i.pol_seq_no
                              AND renew_no    = i.renew_no
                              AND clm_stat_cd NOT IN ('CC','WD','DN'))
                LOOP
                    v_claim := '*';
                    EXIT;
                END LOOP;
            END IF;
                
            v_main.ref_policy_no := NULL;
            FOR c IN(SELECT a.ref_pol_no
                       FROM GIPI_POLBASIC a
                      WHERE a.policy_id = i.policy_id 
                        AND a.pack_policy_id = NVL(i.pack_policy_id,0))
            LOOP
                v_main.ref_policy_no := c.ref_pol_no;
                EXIT;
            END LOOP;
                
            FOR c IN(SELECT a.ref_pol_no
                       FROM GIPI_PACK_POLBASIC a
                      WHERE a.pack_policy_id = i.pack_policy_id)
            LOOP
                v_main.ref_policy_no := c.ref_pol_no;
                EXIT;
            END LOOP;
                
            v_intm_no := NULL;
            IF NVL(i.pack_policy_id,0) = 0 THEN
                FOR c IN(SELECT DISTINCT a.intm_no, TO_CHAR(a.intm_no)||'/'||ref_intm_cd v_intm_no, a.intm_name
                           FROM GIIS_INTERMEDIARY a,
                                GIPI_POLBASIC b,
                                GIPI_INVOICE c,
                                GIPI_COMM_INVOICE d
                          WHERE b.policy_id = c.policy_id
                            AND c.iss_cd = d.iss_cd
                            AND c.prem_seq_no = d.prem_seq_no
                            AND c.policy_id = d.policy_id
                            AND b.line_cd = i.line_cd
                            AND b.subline_cd = i.subline_cd
                            AND b.iss_cd = i.iss_cd
                            AND b.issue_yy = i.issue_yy
                            AND b.pol_seq_no = i.pol_seq_no
                            AND b.renew_no = i.renew_no
                            AND a.intm_no = d.intrmdry_intm_no
                          ORDER BY a.intm_no)
                LOOP
                    IF v_intm_no IS NULL THEN
                       v_intm_no := RTRIM(c.v_intm_no,'/');
                       v_intm_name := c.intm_name;
                    ELSE
                       v_intm_no := v_intm_no||', '||RTRIM(c.v_intm_no,'/');
                       v_intm_name := c.intm_name;
                    END IF;
                END LOOP;
            END IF;
                
            IF NVL(i.pack_policy_id,0) > 0 THEN        
                SELECT SUM(NVL(c.tax_amt,0))
                  INTO v_main.tax_amt 
                  FROM GIEX_REN_RATIO_DTL a,
                       GIPI_POLBASIC b,
                       GIPI_INVOICE c               
                 WHERE a.policy_id = b.policy_id
                   AND a.policy_id = c.policy_id       
                   AND a.renewal_tag = 'N'             
                   AND a.pack_policy_id = i.pack_policy_id;
            ELSE
                v_main.tax_amt := NVL(i.tax_amt,0);
            END IF;
            
                
            v_main.policy_no := i.policy_no;
            v_main.total_sum_insured := TRIM(TO_CHAR(i.tsi_amt,'999,999,999,999,990.99'));
            v_main.premium_amt := TRIM(TO_CHAR(NVL(i.prem_amt,0),'999,999,999,999,990.99'));
            v_main.expiry := TO_CHAR(i.expiry_date,'MM-DD-RRRR');
            v_main.line := i.line_cd || ' - ' || i.line_name;
            v_main.subline := i.subline_cd || ' - ' || i.subline_name;
            v_main.assured := i.assd_name;
            v_main.w_balance := v_bal;
            v_main.w_clm := v_claim;
            v_main.agent := v_intm_no;
            v_main.total_due := TRIM(TO_CHAR(NVL(i.prem_amt,0) + NVL(v_main.tax_amt,0),'999,999,999,999,990.99'));
            v_main.tax_amt := TRIM(TO_CHAR(NVL(v_main.tax_amt,0),'999,999,999,999,990.99'));
            v_main.agent_name := v_intm_name;
            PIPE ROW(v_main);
        END LOOP;
     END csv_giexr112;
     
--   Start: added by Kevin 4-6-2016 SR-5322
   FUNCTION amount_format (amount NUMBER)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN TO_CHAR (amount, '99,999,999,999.99');
   END;

   FUNCTION csv_giexr106a (
      p_policy_id       NUMBER,
      p_assd_no         NUMBER,
      p_intm_no         NUMBER,
      p_iss_cd          VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_line_cd         VARCHAR2,
      p_ending_date     VARCHAR2,
      p_starting_date   VARCHAR2,
      p_include_pack    VARCHAR2,
      p_claims_flag     VARCHAR2,
      p_balance_flag    VARCHAR2,
      p_is_package      VARCHAR2
   )
      RETURN get_giexr106a_tab PIPELINED
   IS
      details        get_giexr106a_type;
      v_intm_no      VARCHAR2 (3000);
      v_intm_no2     VARCHAR2 (2000);
      v_intm_name    VARCHAR2 (240);
      item_desc      VARCHAR2 (500);
      makeformula    VARCHAR2 (500);
      v_iss_name     giis_issource.iss_name%TYPE;
      v_assd_name    giis_assured.assd_name%TYPE;
      v_assd_name2   giis_assured.assd_name%TYPE;
   BEGIN
      FOR i IN
         (SELECT b.iss_cd, b.line_cd, b.subline_cd, b.issue_yy, b.pol_seq_no,
                 b.renew_no, b.iss_cd iss_cd2, b.line_cd line_cd2,
                 b.subline_cd subline_cd2,
                    b.line_cd
                 || '-'
                 || RTRIM (b.subline_cd)
                 || '-'
                 || RTRIM (b.iss_cd)
                 || '-'
                 || LTRIM (TO_CHAR (b.issue_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                 || '-'
                 || LTRIM (TO_CHAR (b.renew_no, '09')) policy_no,
                 b.tsi_amt, b.prem_amt, b.tax_amt, b.expiry_date,
                 d.line_name, e.subline_name, b.policy_id, b.plate_no,
                 b.model_year, b.color, b.serialno,
                 b.car_company || ' ' || b.make make, b.motor_no,
                 b.item_title,
                 DECODE (b.balance_flag, 'Y', '*', NULL) balance_flag,
                 DECODE (b.claim_flag, 'Y', '*', NULL) claim_flag,
                 g.ren_tsi_amt, g.ren_prem_amt, b.is_package
            FROM giex_expiries_v b,
                 giis_line d,
                 giis_subline e,
                 (SELECT   a.policy_id, SUM (a.prem_amt) ren_prem_amt,
                           SUM (DECODE (b.peril_type, 'B', a.tsi_amt, 0)
                               ) ren_tsi_amt,
                           'N' is_package
                      FROM (SELECT policy_id, line_cd, peril_cd, tsi_amt,
                                   prem_amt
                              FROM giex_old_group_peril a
                             WHERE NOT EXISTS (SELECT 1
                                                 FROM giex_new_group_peril
                                                WHERE policy_id = a.policy_id)
                            UNION ALL
                            SELECT policy_id, line_cd, peril_cd, tsi_amt,
                                   prem_amt
                              FROM giex_new_group_peril) a,
                           giis_peril b
                     WHERE a.line_cd = b.line_cd
                       AND a.peril_cd = b.peril_cd
                       AND a.policy_id IN (SELECT policy_id
                                             FROM giex_expiry
                                            WHERE pack_policy_id IS NULL)
                  GROUP BY a.policy_id
                  UNION ALL
                  SELECT   a.pack_policy_id policy_id,
                           SUM (b.prem_amt) ren_prem_amt,
                           SUM (DECODE (c.peril_type, 'B', b.tsi_amt, 0)
                               ) ren_tsi_amt,
                           'Y' is_package
                      FROM giex_pack_expiry a,
                           (SELECT policy_id, line_cd, peril_cd, tsi_amt,
                                   prem_amt
                              FROM giex_old_group_peril a
                             WHERE NOT EXISTS (SELECT 1
                                                 FROM giex_new_group_peril
                                                WHERE policy_id = a.policy_id)
                            UNION ALL
                            SELECT policy_id, line_cd, peril_cd, tsi_amt,
                                   prem_amt
                              FROM giex_new_group_peril) b,
                           giis_peril c
                     WHERE b.line_cd = c.line_cd
                       AND b.peril_cd = c.peril_cd
                       AND b.policy_id IN (
                                       SELECT policy_id
                                         FROM giex_expiry
                                        WHERE pack_policy_id =
                                                              a.pack_policy_id)
                  GROUP BY a.pack_policy_id) g
           WHERE 1 = 1
             AND b.policy_id = g.policy_id
             AND b.is_package = g.is_package
             AND b.line_cd = d.line_cd
             AND b.subline_cd = e.subline_cd
             AND d.line_cd = e.line_cd
             AND (   (b.line_cd = 'MC' AND b.is_package <> 'Y')
                  OR (    b.line_cd = giisp.v ('LINE_CODE_PK')
                      AND b.is_package = 'Y'
                     )
                 )
             AND b.policy_id = NVL (p_policy_id, b.policy_id)
             AND b.assd_no = NVL (p_assd_no, b.assd_no)
             AND NVL (b.post_flag, 'N') = 'N'
             AND NVL (b.intm_no, 0) = NVL (p_intm_no, NVL (b.intm_no, 0))
             AND UPPER (b.iss_cd) = NVL (UPPER (p_iss_cd), UPPER (b.iss_cd))
             AND UPPER (b.subline_cd) =
                              NVL (UPPER (p_subline_cd), UPPER (b.subline_cd))
             AND UPPER (b.line_cd) =
                                    NVL (UPPER (p_line_cd), UPPER (b.line_cd))
             AND TRUNC (b.expiry_date) <=
                    TRUNC (NVL (TO_DATE (p_ending_date,'DD-MON-YYYY'),
                                NVL (TO_DATE (p_starting_date,'DD-MON-YYYY'), b.expiry_date)
                               )
                          )
             AND TRUNC (b.expiry_date) >=
                    DECODE (TO_DATE (p_ending_date,'DD-MON-YYYY'),
                            NULL, TRUNC (b.expiry_date),
                            TRUNC (NVL (TO_DATE (p_starting_date,'DD-MON-YYYY'),
                                        b.expiry_date
                                       )
                                  )
                           )
             AND DECODE (p_include_pack, 'N', b.pack_policy_id, 0) = 0
             AND NVL (b.claim_flag, 'N') LIKE
                    NVL (p_claims_flag,
                         DECODE (p_balance_flag, 'Y', 'N', '%'))
             AND NVL (b.balance_flag, 'N') LIKE
                    NVL (p_balance_flag,
                         DECODE (p_claims_flag, 'Y', 'N', '%'))
             AND NVL (p_is_package, b.is_package) = b.is_package
             AND 1 = check_user_per_iss_cd (b.line_cd, b.iss_cd, 'GIEXS006'))
      LOOP
         details.with_balance := i.balance_flag;
         details.with_claim := i.claim_flag;
         details.policy_no := i.policy_no;
         details.expiry := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         details.plate_no := i.plate_no;
         details.model_year := i.model_year;
         details.total_sum_insured := amount_format (i.tsi_amt);
         details.ren_total_sum_insured := amount_format (i.ren_tsi_amt);
         details.premium_amount := amount_format (i.prem_amt);
         details.ren_premium_amount := amount_format (i.ren_prem_amt);

         IF i.color IS NULL
         THEN
            IF i.serialno IS NULL
            THEN
               details.color_serial_no := '';
            ELSE
               details.color_serial_no := i.serialno;
            END IF;
         ELSE
            IF i.serialno IS NULL
            THEN
               details.color_serial_no := i.color;
            ELSE
               details.color_serial_no := i.color || '/' || i.serialno;
            END IF;
         END IF;

         BEGIN
            FOR c IN (SELECT a.assd_name
                        FROM giis_assured a, giex_expiry b
                       WHERE a.assd_no = b.assd_no
                         AND b.policy_id = i.policy_id)
            LOOP
               v_assd_name := c.assd_name;
            END LOOP;

            IF v_assd_name IS NULL
            THEN
               FOR c2 IN (SELECT a.assd_name
                            FROM giis_assured a, gipi_polbasic b
                           WHERE a.assd_no = b.assd_no
                             AND b.line_cd = i.line_cd
                             AND b.subline_cd = i.subline_cd
                             AND b.iss_cd = i.iss_cd
                             AND b.issue_yy = i.issue_yy
                             AND b.pol_seq_no = i.pol_seq_no
                             AND b.renew_no = i.renew_no)
               LOOP
                  v_assd_name := c2.assd_name;
               END LOOP;
            END IF;

            details.assured := v_assd_name;
         END;

         FOR c IN (SELECT a.ref_pol_no ref_pol_no
                     FROM gipi_polbasic a
                    WHERE a.policy_id = i.policy_id)
         LOOP
            details.ref_policy_no := c.ref_pol_no;
         END LOOP;

         BEGIN
            v_intm_no := NULL;

            FOR l IN (SELECT DISTINCT a.intm_no,
                                         TO_CHAR (a.intm_no)
                                      || '/'
                                      || ref_intm_cd v_intm_no
                                 FROM giis_intermediary a,
                                      gipi_polbasic b,
                                      gipi_invoice c,
                                      gipi_comm_invoice d
                                WHERE b.policy_id = c.policy_id
                                  AND c.iss_cd = d.iss_cd
                                  AND c.prem_seq_no = d.prem_seq_no
                                  AND c.policy_id = d.policy_id
                                  AND b.line_cd = i.line_cd
                                  AND b.subline_cd = i.subline_cd
                                  AND b.iss_cd = i.iss_cd
                                  AND b.issue_yy = i.issue_yy
                                  AND b.pol_seq_no = i.pol_seq_no
                                  AND b.renew_no = i.renew_no
                                  AND a.intm_no = d.intrmdry_intm_no
                             ORDER BY a.intm_no)
            LOOP
               IF v_intm_no IS NULL
               THEN
                  v_intm_no := RTRIM (l.v_intm_no, '/');
               ELSE
                  v_intm_no := v_intm_no || ', ' || RTRIM (l.v_intm_no, '/');
               END IF;
            END LOOP;

            details.AGENT := v_intm_no;
         END;

         BEGIN
            BEGIN
               SELECT iss_name
                 INTO v_iss_name
                 FROM giis_issource
                WHERE iss_cd = i.iss_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_iss_name := ' ';
            END;

            details.issue_code := i.iss_cd || ' - ' || v_iss_name;
         END;

         details.line_code := i.line_cd || ' - ' || i.line_name;
         details.subline_code := i.subline_cd || ' - ' || i.subline_name;
         PIPE ROW (details);
      END LOOP;
   END;

   FUNCTION csv_giexr106b (
      p_policy_id       NUMBER,
      p_assd_no         NUMBER,
      p_intm_no         NUMBER,
      p_iss_cd          VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_line_cd         VARCHAR2,
      p_ending_date     VARCHAR2,
      p_starting_date   VARCHAR2,
      p_include_pack    VARCHAR2,
      p_claims_flag     VARCHAR2,
      p_balance_flag    VARCHAR2,
      p_is_package      VARCHAR2
   )
      RETURN get_giexr106b_tab PIPELINED
   IS
      details        get_giexr106b_type;
      v_intm_no      VARCHAR2 (32000);
      v_intm_no2     VARCHAR2 (2000);
      v_acct_of_cd   VARCHAR2 (550);
      v_intm_name    VARCHAR2 (240);
      item_desc      VARCHAR2 (500);
      makeformula    VARCHAR2 (500);
      v_ref_pol_no   VARCHAR2 (50);
      v_iss_name     giis_issource.iss_name%TYPE;
      v_assd_name    giis_assured.assd_name%TYPE;
      v_assd_name2   giis_assured.assd_name%TYPE;
   BEGIN
      FOR i IN
         (SELECT   b.iss_cd, b.line_cd, b.subline_cd, b.issue_yy,
                   b.pol_seq_no, b.renew_no, b.iss_cd iss_cd2,
                   b.line_cd line_cd2, b.subline_cd subline_cd2,
                      b.line_cd
                   || '-'
                   || RTRIM (b.subline_cd)
                   || '-'
                   || RTRIM (b.iss_cd)
                   || '-'
                   || LTRIM (TO_CHAR (b.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (b.renew_no, '09')) policy_no,
                   b.tsi_amt, b.prem_amt, h.tax_amt, b.expiry_date,
                   d.line_name, e.subline_name, b.policy_id,
                   DECODE (b.balance_flag, 'Y', '*', NULL) balance_flag,
                   DECODE (b.claim_flag, 'Y', '*', NULL) claim_flag,
                   g.ren_tsi_amt, g.ren_prem_amt, a.acct_of_cd acct_of_cd,
                   DECODE (a.label_tag,
                           'Y', 'Leased to :',
                           'In acct of :'
                          ) label_tag,
                   b.is_package
              FROM (SELECT policy_id, acct_of_cd, label_tag, 'N' is_package
                      FROM gipi_polbasic
                    UNION ALL
                    SELECT pack_policy_id policy_id, acct_of_cd, label_tag,
                           'Y' is_package
                      FROM gipi_pack_polbasic) a,
                   giex_expiries_v b,
                   giis_line d,
                   giis_subline e,
                   (SELECT   a.policy_id, SUM (a.prem_amt) ren_prem_amt,
                             SUM (DECODE (b.peril_type, 'B', a.tsi_amt, 0)
                                 ) ren_tsi_amt,
                             'N' is_package
                        FROM (SELECT policy_id, line_cd, peril_cd, tsi_amt,
                                     prem_amt
                                FROM giex_old_group_peril a
                               WHERE NOT EXISTS (
                                                 SELECT 1
                                                   FROM giex_new_group_peril
                                                  WHERE policy_id =
                                                                   a.policy_id)
                              UNION ALL
                              SELECT policy_id, line_cd, peril_cd, tsi_amt,
                                     prem_amt
                                FROM giex_new_group_peril) a,
                             giis_peril b
                       WHERE a.line_cd = b.line_cd
                         AND a.peril_cd = b.peril_cd
                         AND a.policy_id IN (SELECT policy_id
                                               FROM giex_expiry
                                              WHERE pack_policy_id IS NULL)
                    GROUP BY a.policy_id
                    UNION ALL
                    SELECT   a.pack_policy_id policy_id,
                             SUM (b.prem_amt) ren_prem_amt,
                             SUM (DECODE (c.peril_type, 'B', b.tsi_amt, 0)
                                 ) ren_tsi_amt,
                             'Y' is_package
                        FROM giex_pack_expiry a,
                             (SELECT policy_id, line_cd, peril_cd, tsi_amt,
                                     prem_amt
                                FROM giex_old_group_peril a
                               WHERE NOT EXISTS (
                                                 SELECT 1
                                                   FROM giex_new_group_peril
                                                  WHERE policy_id =
                                                                   a.policy_id)
                              UNION ALL
                              SELECT policy_id, line_cd, peril_cd, tsi_amt,
                                     prem_amt
                                FROM giex_new_group_peril) b,
                             giis_peril c
                       WHERE b.line_cd = c.line_cd
                         AND b.peril_cd = c.peril_cd
                         AND b.policy_id IN (
                                       SELECT policy_id
                                         FROM giex_expiry
                                        WHERE pack_policy_id =
                                                              a.pack_policy_id)
                    GROUP BY a.pack_policy_id) g,
                   (SELECT   a.policy_id, SUM (a.tax_amt) tax_amt,
                             'N' is_package
                        FROM (SELECT policy_id, tax_amt
                                FROM giex_old_group_tax a
                               WHERE NOT EXISTS (
                                                 SELECT 1
                                                   FROM giex_new_group_tax
                                                  WHERE policy_id =
                                                                   a.policy_id)
                              UNION ALL
                              SELECT policy_id, tax_amt
                                FROM giex_new_group_tax) a
                       WHERE a.policy_id IN (SELECT policy_id
                                               FROM giex_expiry
                                              WHERE pack_policy_id IS NULL)
                    GROUP BY a.policy_id
                    UNION
                    SELECT   a.pack_policy_id policy_id,
                             SUM (b.tax_amt) tax_amt, 'Y' is_package
                        FROM giex_pack_expiry a,
                             (SELECT policy_id, tax_amt
                                FROM giex_old_group_tax a
                               WHERE NOT EXISTS (
                                                 SELECT 1
                                                   FROM giex_new_group_tax
                                                  WHERE policy_id =
                                                                   a.policy_id)
                              UNION ALL
                              SELECT policy_id, tax_amt
                                FROM giex_new_group_tax) b
                       WHERE b.policy_id IN (
                                       SELECT policy_id
                                         FROM giex_expiry
                                        WHERE pack_policy_id =
                                                              a.pack_policy_id)
                    GROUP BY a.pack_policy_id) h
             WHERE b.policy_id = a.policy_id
               AND a.is_package = b.is_package
               AND b.policy_id = g.policy_id
               AND b.is_package = g.is_package
               AND b.policy_id = h.policy_id
               AND b.is_package = h.is_package
               AND NVL (b.post_flag, 'N') = 'N'
               AND b.line_cd = d.line_cd
               AND b.subline_cd = e.subline_cd
               AND d.line_cd = e.line_cd
               AND b.policy_id = NVL (p_policy_id, b.policy_id)
               AND b.assd_no = NVL (p_assd_no, b.assd_no)
               AND NVL (b.intm_no, 0) = NVL (p_intm_no, NVL (b.intm_no, 0))
               AND UPPER (b.iss_cd) = NVL (UPPER (p_iss_cd), UPPER (b.iss_cd))
               AND UPPER (b.subline_cd) =
                              NVL (UPPER (p_subline_cd), UPPER (b.subline_cd))
               AND UPPER (b.line_cd) =
                                    NVL (UPPER (p_line_cd), UPPER (b.line_cd))
               AND TRUNC (b.expiry_date) <=
                      TRUNC (NVL (TO_DATE (p_ending_date, 'dd-mon-yyyy'),
                                  NVL (TO_DATE (p_starting_date,
                                                'dd-mon-yyyy'),
                                       b.expiry_date
                                      )
                                 )
                            )
               AND TRUNC (b.expiry_date) >=
                      DECODE (TO_DATE (p_ending_date, 'dd-mon-yyyy'),
                              NULL, TRUNC (b.expiry_date),
                              TRUNC (NVL (TO_DATE (p_starting_date,
                                                   'dd-mon-yyyy'
                                                  ),
                                          b.expiry_date
                                         )
                                    )
                             )
               AND DECODE (p_include_pack, 'N', b.pack_policy_id, 0) = 0
               AND NVL (b.claim_flag, 'N') LIKE
                      NVL (p_claims_flag,
                           DECODE (p_balance_flag, 'Y', 'N', '%')
                          )
               AND NVL (b.balance_flag, 'N') LIKE
                      NVL (p_balance_flag,
                           DECODE (p_claims_flag, 'Y', 'N', '%')
                          )
               AND NVL (p_is_package, b.is_package) = b.is_package
          ORDER BY b.expiry_date, policy_no)
      LOOP
         details.policy_no := i.policy_no;
         details.expiry := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         details.with_balance := i.balance_flag;
         details.with_claim := i.claim_flag;
         details.total_sum_insured := amount_format (i.tsi_amt);
         details.premium_amount := amount_format (i.prem_amt);
         details.tax_amount := amount_format (i.tax_amt);
         details.ren_total_sum_insured := amount_format (i.ren_tsi_amt);
         details.ren_premium_amount := amount_format (i.ren_prem_amt);
         details.total_due := amount_format (i.ren_prem_amt + i.tax_amt);

         BEGIN
            FOR c IN (SELECT a.assd_name
                        FROM giis_assured a, giex_expiry b
                       WHERE a.assd_no = b.assd_no
                         AND b.policy_id = i.policy_id)
            LOOP
               v_assd_name := c.assd_name;
            END LOOP;

            IF v_assd_name IS NULL
            THEN
               FOR c2 IN (SELECT a.assd_name
                            FROM giis_assured a, gipi_polbasic b
                           WHERE a.assd_no = b.assd_no
                             AND b.line_cd = i.line_cd
                             AND b.subline_cd = i.subline_cd
                             AND b.iss_cd = i.iss_cd
                             AND b.issue_yy = i.issue_yy
                             AND b.pol_seq_no = i.pol_seq_no
                             AND b.renew_no = i.renew_no)
               LOOP
                  v_assd_name := c2.assd_name;
               END LOOP;
            END IF;
         END;

         FOR c IN (SELECT a.ref_pol_no ref_pol_no
                     FROM gipi_polbasic a
                    WHERE a.policy_id = i.policy_id)
         LOOP
            details.ref_policy_no := c.ref_pol_no;
         END LOOP;

         BEGIN
            BEGIN
               SELECT iss_name
                 INTO v_iss_name
                 FROM giis_issource
                WHERE iss_cd = i.iss_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_iss_name := ' ';
            END;

            details.issue_code := i.iss_cd || ' - ' || v_iss_name;
         END;

         BEGIN
            FOR c IN (SELECT a.assd_name
                        FROM giis_assured a, giex_expiry b
                       WHERE a.assd_no = b.assd_no
                         AND b.policy_id = i.policy_id)
            LOOP
               v_assd_name := c.assd_name;
               EXIT;
            END LOOP;

            IF v_assd_name IS NULL
            THEN
               FOR c2 IN (SELECT a.assd_name
                            FROM giis_assured a, gipi_polbasic b
                           WHERE a.assd_no = b.assd_no
                             AND b.line_cd = i.line_cd
                             AND b.subline_cd = i.subline_cd
                             AND b.iss_cd = i.iss_cd
                             AND b.issue_yy = i.issue_yy
                             AND b.pol_seq_no = i.pol_seq_no
                             AND b.renew_no = i.renew_no)
               LOOP
                  v_assd_name := c2.assd_name;
               END LOOP;
            END IF;
         END;

         BEGIN
            FOR k IN (SELECT i.label_tag || ' ' || a.assd_name assd_name
                        FROM giis_assured a, gixx_polbasic b
                       WHERE b.acct_of_cd > 0
                         AND b.acct_of_cd = i.acct_of_cd
                         AND a.assd_no = b.acct_of_cd)
            LOOP
               v_acct_of_cd := k.assd_name;
            END LOOP;

            details.assured := v_assd_name || ' ' || v_acct_of_cd;
         END;

         BEGIN
            FOR j IN (SELECT a.ref_pol_no ref_pol_no
                        FROM gipi_polbasic a
                       WHERE a.policy_id = i.policy_id)
            LOOP
               v_ref_pol_no := j.ref_pol_no;
               EXIT;
            END LOOP;

            details.ref_policy_no := v_ref_pol_no;
         END;

         BEGIN
            FOR c IN (SELECT DISTINCT a.intm_no,
                                         TO_CHAR (a.intm_no)
                                      || '/'
                                      || ref_intm_cd v_intm_no
                                 FROM giis_intermediary a,
                                      gipi_polbasic b,
                                      gipi_invoice c,
                                      gipi_comm_invoice d
                                WHERE b.policy_id = c.policy_id
                                  AND c.iss_cd = d.iss_cd
                                  AND c.prem_seq_no = d.prem_seq_no
                                  AND c.policy_id = d.policy_id
                                  AND b.line_cd = i.line_cd
                                  AND b.subline_cd = i.subline_cd
                                  AND b.iss_cd = i.iss_cd
                                  AND b.issue_yy = i.issue_yy
                                  AND b.pol_seq_no = i.pol_seq_no
                                  AND b.renew_no = i.renew_no
                                  AND a.intm_no = d.intrmdry_intm_no
                             ORDER BY a.intm_no)
            LOOP
               IF v_intm_no IS NULL
               THEN
                  v_intm_no := RTRIM (c.v_intm_no, '/');
               ELSE
                  v_intm_no := v_intm_no || ', ' || RTRIM (c.v_intm_no, '/');
               END IF;
            END LOOP;

            IF v_intm_no IS NULL
            THEN
               details.AGENT := '';
            ELSE
               details.AGENT := v_intm_no;
            END IF;
         END;

         details.line := i.line_cd || ' - ' || i.line_name;
         details.subline := i.subline_cd || ' - ' || i.subline_name;
         v_intm_no := NULL;
         PIPE ROW (details);
      END LOOP;
   END;
--   End: added by Kevin 4-6-2016 SR-5322
END csv_uw_renewal;
/