CREATE OR REPLACE PACKAGE BODY CPI.gipir902b_pkg
AS
   FUNCTION get_gipir902b (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_all_line_tag     VARCHAR2
   )
      RETURN gipir902b_tab PIPELINED
   IS
      v           gipir902b_type;
   BEGIN
      FOR i IN
          --modified by gab 06.20.2016 SR 21538  
         (SELECT range_from, range_to, ranges2, pol1, avg(sum_insured) sum_insured,
                 avg(premium) premium, avg(net_ret_sum_insured) net_ret_sum_insured,
                 avg(net_ret_premium) net_ret_premium, /*avg*/sum(net_ret_loss) net_ret_loss,
                 avg(treaty_sum_insured) treaty_sum_insured, avg(treaty_premium) treaty_premium,
                 /*avg*/sum(treaty_loss) treaty_loss, avg(facul_sum_insured) facul_sum_insured,
                 avg(facul_premium) facul_premium, /*avg*/sum(facul_loss) facul_loss, /*sum(claim_count)*/ claim_count claim_count                   
            FROM (SELECT c.range_from, c.range_to, c.ranges2, b.claim_id AS "CLAIM_ID",
                         d.close_sw AS "CLOSE_SW", a.pol1,
                         NVL (a.sum_insured, 0) sum_insured,
                         NVL (a.premium, 0) premium,
                         NVL (a.net_ret_sum_insured, 0) net_ret_sum_insured,
                         NVL (a.net_ret_premium, 0) net_ret_premium,
                         net_ret_loss (NVL (b.claim_id, 0),
                                       NVL (d.close_sw, ' ')
                                      ) AS "NET_RET_LOSS",
                         NVL (a.treaty_sum_insured, 0) treaty_sum_insured,
                         NVL (a.treaty_premium, 0) treaty_premium,
                         treaty_xol_loss (NVL (b.claim_id, 0),
                                          NVL (d.close_sw, ' ')
                                         ) AS "TREATY_LOSS",
                         NVL (a.facul_sum_insured, 0) facul_sum_insured,
                         NVL (a.facul_premium, 0) facul_premium,
                         facul_loss (NVL (b.claim_id, 0),
                                     NVL (d.close_sw, ' ')
                                    ) AS "FACUL_LOSS",
                         a.claim_count
                    FROM (SELECT    line_cd
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
                                   NVL (net_retention_tsi,
                                        0)
                                 + NVL (treaty_tsi, 0)
                                 + NVL (facultative_tsi, 0)
                                 + NVL (quota_share_tsi, 0) AS "SUM_INSURED",
                                   NVL (net_retention, 0)
                                 + NVL (treaty, 0)
                                 + NVL (quota_share, 0)
                                 + NVL (facultative, 0) AS "PREMIUM",
                                 NVL
                                    (net_retention_tsi,
                                     0
                                    ) AS "NET_RET_SUM_INSURED",
                                 NVL (net_retention, 0) AS "NET_RET_PREMIUM",
                                   NVL (treaty_tsi,
                                        0)
                                 + NVL (quota_share_tsi, 0)
                                                      AS "TREATY_SUM_INSURED",
                                   NVL (treaty, 0)
                                 + NVL (quota_share, 0) AS "TREATY_PREMIUM",
                                 NVL (facultative_tsi,
                                      0
                                     ) AS "FACUL_SUM_INSURED",
                                 NVL (facultative, 0) AS "FACUL_PREMIUM",
                                    LTRIM
                                       (TO_CHAR (range_from,
                                                 '999,999,999,999,999'
                                                )
                                       )
                                 || '-'
                                 || LTRIM (TO_CHAR (range_to,
                                                    '999,999,999,999,999'
                                                   )
                                          ) AS "RANGES",
                                 claim_count
                            FROM gipi_risk_loss_profile_dtl
                           WHERE 1 = 1
                             AND line_cd = NVL (p_line_cd, line_cd)
                             AND subline_cd = NVL (p_subline_cd, subline_cd)
                             AND user_id = UPPER (p_user_id)
                             AND date_from = TO_DATE(p_date_from, 'mm-dd-yyyy')
                             AND date_to = TO_DATE(p_date_to, 'mm-dd-yyyy')
                             AND all_line_tag = p_all_line_tag
                         ) a,
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
                           WHERE claim_id IN (
                                              SELECT claim_id
                                                FROM gicl_risk_loss_profile_ext3)) b,
                         (SELECT    LTRIM
                                       (TO_CHAR (range_from,
                                                 '999,999,999,999,999'
                                                )
                                       )
                                 || '-'
                                 || LTRIM (TO_CHAR (range_to,
                                                    '999,999,999,999,999'
                                                   )
                                          ) AS "RANGES2",
                                 range_from,
                                 range_to --added by gab 06.20.2016 SR 21538
                            FROM gipi_risk_loss_profile
                           WHERE 1 = 1
                             AND line_cd = NVL (p_line_cd, line_cd)
                             AND NVL (subline_cd, '***') =
                                                     NVL (p_subline_cd, '***')
                             AND user_id = UPPER (p_user_id)
                             AND date_from = TO_DATE(p_date_from, 'mm-dd-yyyy')
                             AND date_to = TO_DATE(p_date_to, 'mm-dd-yyyy')
                             AND all_line_tag = p_all_line_tag
                             AND loss_date_from = TO_DATE(p_loss_date_from, 'mm-dd-yyyy')
                             AND loss_date_to = TO_DATE(p_loss_date_to, 'mm-dd-yyyy')
                         ) c,
                         (SELECT close_sw, claim_id
                            FROM gicl_risk_loss_profile_ext3) d
                   WHERE a.pol1 = b.pol2(+) AND a.ranges(+) = c.ranges2
                         AND d.claim_id(+) = b.claim_id)
         GROUP BY range_from, range_to, ranges2, pol1, claim_count --modified by gab 06.20.2016 SR 21538
         ORDER BY range_from, ranges2)
      LOOP
         
         IF i.pol1 IS NOT NULL OR i.pol1 <> '' THEN
            v.policy_count := 1;
         ELSE
            v.policy_count := 0;
         END IF;
         
         v.range_from := i.range_from;
         v.range_to := i.range_to; --added by gab 06.20.2016 SR 21538
         v.ranges2 := i.ranges2;
         v.pol1 := i.pol1;
         v.claim_count := NVL (i.claim_count, 0);
         v.sum_insured := i.sum_insured;
         v.premium := i.premium;
         v.net_ret_sum_insured := i.net_ret_sum_insured;
         v.net_ret_premium := i.net_ret_premium;
         v.net_ret_loss := i.net_ret_loss;
         v.treaty_sum_insured := i.treaty_sum_insured;
         v.treaty_premium := i.treaty_premium;
         v.treaty_loss := i.treaty_loss;
         v.facul_sum_insured := i.facul_sum_insured;
         v.facul_premium := i.facul_premium;
         v.facul_loss := i.facul_loss;
         
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
         PIPE ROW (v);
      END LOOP;
      
      IF v.range_from IS NULL THEN
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
            
         PIPE ROW(v);
      END IF;
   END get_gipir902b;
END;
/


