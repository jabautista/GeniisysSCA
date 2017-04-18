CREATE OR REPLACE PACKAGE BODY CPI.gipir902d_pkg
AS
   FUNCTION get_gipir902d (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_all_line_tag     VARCHAR2
   )
      RETURN gipir902d_tab PIPELINED
   IS
      v   gipir902d_type;
   BEGIN
      FOR i IN
         (SELECT a.subline_cd, e.subline, c.range_from, c.ranges2, c.range_to, --added by gab 06.20.2016 SR 21538
                 b.claim_id AS "CLAIM_ID", d.close_sw AS "CLOSE_SW", a.pol1,
                 NVL (a.sum_insured, 0) sum_insured,
                 NVL (a.premium, 0) premium,
                 NVL (a.net_ret_sum_insured, 0) net_ret_sum_insured,
                 NVL (a.net_ret_premium, 0) net_ret_premium,
                 net_ret_loss (NVL (b.claim_id, 0),
                               NVL (d.close_sw, ' ')
                              ) AS "NET_RET_LOSS_AMT0",
                 NVL (a.treaty_sum_insured, 0) treaty_sum_insured,
                 NVL (a.treaty_premium, 0) treaty_premium,
                 treaty_xol_loss (NVL (b.claim_id, 0),
                                  NVL (d.close_sw, ' ')
                                 ) AS "TREATY_LOSS_AMT0",
                 NVL (a.facul_sum_insured, 0) facul_sum_insured,
                 NVL (a.facul_premium, 0) facul_premium,
                 facul_loss (NVL (b.claim_id, 0),
                             NVL (d.close_sw, ' ')
                            ) AS "FACUL_LOSS_AMT0", a.claim_count
            FROM (SELECT subline_cd,
                            line_cd
                         || '-'
                         || subline_cd
                         || '-'
                         || iss_cd
                         || '-'
                         || issue_yy
                         || '-'
                         || LTRIM (TO_CHAR (pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (renew_no, '09')) pol1,
                           NVL (net_retention_tsi, 0)
                         + NVL (treaty_tsi, 0)
                         + NVL (facultative_tsi, 0)
                         + NVL (quota_share_tsi, 0) AS "SUM_INSURED",
                           NVL (net_retention, 0)
                         + NVL (treaty, 0)
                         + NVL (quota_share, 0)
                         + NVL (facultative, 0) AS "PREMIUM",
                         NVL (net_retention_tsi, 0) AS "NET_RET_SUM_INSURED",
                         NVL (net_retention, 0) AS "NET_RET_PREMIUM",
                           NVL (treaty_tsi, 0)
                         + NVL (quota_share_tsi, 0) AS "TREATY_SUM_INSURED",
                           NVL (treaty, 0)
                         + NVL (quota_share, 0) AS "TREATY_PREMIUM",
                         NVL (facultative_tsi, 0) AS "FACUL_SUM_INSURED",
                         NVL (facultative, 0) AS "FACUL_PREMIUM",
                            LTRIM (TO_CHAR (range_from, '999,999,999,999,999')
                                  )
                         || ' - '
                         || LTRIM
                               (DECODE
                                      ((LTRIM (TO_CHAR (range_to,
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
                               ) AS "RANGES", NVL(claim_count, 0) claim_count
                    FROM gipi_risk_loss_profile_dtl
                   WHERE 1 = 1
                     AND line_cd = p_line_cd
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND user_id = UPPER (p_user_id)
                     AND date_from = TO_DATE (p_date_from, 'mm-dd-yyyy')
                     AND date_to = TO_DATE (p_date_to, 'mm-dd-yyyy')
                     AND all_line_tag = p_all_line_tag) a,
                 (SELECT    line_cd
                         || '-'
                         || subline_cd
                         || '-'
                         || pol_iss_cd
                         || '-'
                         || issue_yy
                         || '-'
                         || LTRIM (TO_CHAR (pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (renew_no, '09')) pol2,
                         claim_id
                    FROM gicl_claims
                   WHERE claim_id IN (SELECT claim_id
                                        FROM gicl_risk_loss_profile_ext3)) b,
                 (SELECT    LTRIM
                                 (TO_CHAR (range_from, '999,999,999,999,999')
                                 )
                         || ' - '
                         || LTRIM
                               (DECODE
                                      ((LTRIM (TO_CHAR (range_to,
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
                               ) AS "RANGES2",
                         range_from, range_to --added by gab 06.20.2016 SR 21538
                    FROM gipi_risk_loss_profile
                   WHERE 1 = 1
                     AND line_cd = p_line_cd
                     AND NVL (subline_cd, '***') = NVL (p_subline_cd, '***')
                     AND user_id = p_user_id
                     AND date_from = TO_DATE (p_date_from, 'mm-dd-yyyy')
                     AND date_to = TO_DATE (p_date_to, 'mm-dd-yyyy')
                     AND all_line_tag = p_all_line_tag
                     AND loss_date_from =
                                      TO_DATE (p_loss_date_from, 'mm-dd-yyyy')
                     AND loss_date_to = TO_DATE (p_loss_date_to, 'mm-dd-yyyy')) c,
                 (SELECT close_sw, claim_id
                    FROM gicl_risk_loss_profile_ext3) d,
                 (SELECT subline_cd,
                         subline_cd || ' - ' || subline_name subline
                    FROM giis_subline d0
                   WHERE EXISTS (
                            SELECT 'X'
                              FROM gipi_risk_loss_profile_dtl e0
                             WHERE 1 = 1
                               AND e0.subline_cd = d0.subline_cd
                               AND e0.line_cd = p_line_cd
                               AND e0.subline_cd =
                                             NVL (p_subline_cd, e0.subline_cd)
                               AND e0.user_id = p_user_id
                               AND e0.date_from =
                                           TO_DATE (p_date_from, 'mm-dd-yyyy')
                               AND e0.date_to =
                                             TO_DATE (p_date_to, 'mm-dd-yyyy')
                               AND e0.all_line_tag = p_all_line_tag)) e
           WHERE a.pol1 = b.pol2(+)
             AND a.ranges = c.ranges2
             AND a.subline_cd = e.subline_cd
             AND d.claim_id(+) = b.claim_id
          UNION ALL
          SELECT b00.subline_cd, b00.subline, a00.range_from, a00.ranges2, a00.range_to, --added by gab 06.20.2016 SR 21538
                 0 claim_id, ' ' close_sw, NULL AS pol1, 0 sum_insured,
                 0 premium, 0 net_ret_sum_insured, 0 net_ret_premium,
                 0 net_ret_loss_amt0, 0 treaty_sum_insured, 0 treaty_premium,
                 0 treaty_loss_amt0, 0 facul_sum_insured, 0 facul_premium,
                 0 facul_loss_amt0, 0 claim_count
            FROM (SELECT    LTRIM
                                 (TO_CHAR (range_from, '999,999,999,999,999')
                                 )
                         || ' - '
                         || LTRIM
                               (DECODE
                                      ((LTRIM (TO_CHAR (range_to,
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
                               ) AS "RANGES2",
                         range_from, range_to --added by gab 06.20.2016 SR 21538
                    FROM gipi_risk_loss_profile
                   WHERE 1 = 1
                     AND line_cd = p_line_cd
                     AND NVL (subline_cd, '***') = NVL (p_subline_cd, '***')
                     AND user_id = p_user_id
                     AND date_from = TO_DATE (p_date_from, 'mm-dd-yyyy')
                     AND date_to = TO_DATE (p_date_to, 'mm-dd-yyyy')
                     AND all_line_tag = p_all_line_tag
                     AND loss_date_from =
                                      TO_DATE (p_loss_date_from, 'mm-dd-yyyy')
                     AND loss_date_to = TO_DATE (p_loss_date_to, 'mm-dd-yyyy')) a00,
                 (SELECT subline_cd,
                         subline_cd || ' - ' || subline_name subline
                    FROM giis_subline d
                   WHERE EXISTS (
                            SELECT 'X'
                              FROM gipi_risk_loss_profile_dtl e
                             WHERE 1 = 1
                               AND e.subline_cd = d.subline_cd
                               AND e.line_cd = p_line_cd
                               AND e.subline_cd =
                                              NVL (p_subline_cd, e.subline_cd)
                               AND e.user_id = p_user_id
                               AND e.date_from =
                                           TO_DATE (p_date_from, 'mm-dd-yyyy')
                               AND e.date_to =
                                             TO_DATE (p_date_to, 'mm-dd-yyyy')
                               AND e.all_line_tag = p_all_line_tag)) b00)
      LOOP
         v.subline := i.subline;
         v.range_from := i.range_from;
         v.range_to := i.range_to; --added by gab 06.20.2016 SR 21538
         v.ranges2 := i.ranges2;
         v.pol1 := NVL(i.pol1, 'PLACE_HOLDER');
         v.sum_insured := i.sum_insured;
         v.premium := i.premium;
         v.net_ret_sum_insured := i.net_ret_sum_insured;
         v.net_ret_premium := i.net_ret_premium;
         v.net_ret_loss_amt0 := i.net_ret_loss_amt0;
         v.treaty_sum_insured := i.treaty_sum_insured;
         v.treaty_premium := i.treaty_premium;
         v.treaty_loss_amt0 := i.treaty_loss_amt0;
         v.facul_sum_insured := i.facul_sum_insured;
         v.facul_premium := i.facul_premium;
         v.facul_loss_amt0 := i.facul_loss_amt0;
         v.subline_cd := i.subline_cd;
         v.claim_id := i.claim_id;
         v.close_sw := i.close_sw;
         v.claim_count := i.claim_count;
         
         IF i.pol1 IS NOT NULL THEN
            v.policy_count := 1;
         ELSE
            v.policy_count := 0;
         END IF;      
         
         IF v.line_name IS NULL THEN
            SELECT line_name
              INTO v.line_name
              FROM giis_line
             WHERE line_cd = p_line_cd; 
         END IF;
         
         v.date_from := TRIM(TO_CHAR(TO_DATE(p_date_from, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_date_from, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_date_from, 'mm-dd-yyyy'), 'YYYY');
         v.date_to := TRIM(TO_CHAR(TO_DATE(p_date_to, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_date_to, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_date_to, 'mm-dd-yyyy'), 'YYYY');
         v.loss_date_from := TRIM(TO_CHAR(TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), 'YYYY');
         v.loss_date_to := TRIM(TO_CHAR(TO_DATE(p_loss_date_to, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_loss_date_to, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_loss_date_to, 'mm-dd-yyyy'), 'YYYY');
         
         PIPE ROW (v);
      END LOOP;
   END get_gipir902d;
END;
/


