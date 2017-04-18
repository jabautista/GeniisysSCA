CREATE OR REPLACE PACKAGE BODY CPI.csv_uw_risk_profile
AS
   FUNCTION get_rec_gipir948 (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN get_gipir948_tab PIPELINED
   IS
      v_get_gipir948   get_gipir948_rec_type;
   BEGIN
      FOR cur IN
         (SELECT   line_cd, subline_cd, range_from, range_to,
                   SUM (NVL (policy_count, 0)) policy_count,
                   SUM (NVL (net_retention, 0)) net_retention,
                   SUM (NVL (net_retention_tsi, 0)) net_retention_tsi,
                   SUM (NVL (sec_net_retention_prem, 0)
                       ) sec_net_retention_prem,
                   SUM (NVL (sec_net_retention_tsi, 0))
                                                       sec_net_retention_tsi,
                   SUM (NVL (quota_share, 0)) quota_share,
                   SUM (NVL (quota_share_tsi, 0)) quota_share_tsi,
                   SUM (NVL (facultative, 0)) facultative,
                   SUM (NVL (facultative_tsi, 0)) facultative_tsi,
                   SUM (NVL (treaty_tsi, 0)) treaty_tsi,
                   SUM (NVL (treaty2_tsi, 0)) treaty2_tsi,
                   SUM (NVL (treaty3_tsi, 0)) treaty3_tsi,
                   SUM (NVL (treaty4_tsi, 0)) treaty4_tsi,
                   SUM (NVL (treaty5_tsi, 0)) treaty5_tsi,
                   SUM (NVL (treaty6_tsi, 0)) treaty6_tsi,
                   SUM (NVL (treaty7_tsi, 0)) treaty7_tsi,
                   SUM (NVL (treaty8_tsi, 0)) treaty8_tsi,
                   SUM (NVL (treaty9_tsi, 0)) treaty9_tsi,
                   SUM (NVL (treaty10_tsi, 0)) treaty10_tsi,
                   SUM (NVL (treaty_prem, 0)) treaty_prem,
                   SUM (NVL (treaty2_prem, 0)) treaty2_prem,
                   SUM (NVL (treaty3_prem, 0)) treaty3_prem,
                   SUM (NVL (treaty4_prem, 0)) treaty4_prem,
                   SUM (NVL (treaty5_prem, 0)) treaty5_prem,
                   SUM (NVL (treaty6_prem, 0)) treaty6_prem,
                   SUM (NVL (treaty7_prem, 0)) treaty7_prem,
                   SUM (NVL (treaty8_prem, 0)) treaty8_prem,
                   SUM (NVL (treaty9_prem, 0)) treaty9_prem,
                   SUM (NVL (treaty10_prem, 0)) treaty10_prem,
                   DECODE (p_by_tarf, 'Y', NVL (tarf_cd, 'X'), 'X') tarf_cd,
                   trty_name, trty2_name, trty3_name, trty4_name, trty5_name,
                   trty6_name, trty7_name, trty8_name, trty9_name,
                   trty10_name
              FROM gipi_risk_profile
             WHERE line_cd = p_line_cd
               AND NVL (subline_cd, '@@@@@@@@@@@@') =
                      DECODE (p_subline_cd,
                              NULL, NVL (subline_cd, '@@@@@@@@@@@@'),
                              p_subline_cd
                             )
               AND all_line_tag = p_all_line_tag
               AND user_id = p_user_id
               AND TRUNC (date_from) =
                               TRUNC (TO_DATE (p_starting_date, 'MM-DD-YYYY'))
               AND TRUNC (date_to) =
                                 TRUNC (TO_DATE (p_ending_date, 'MM-DD-YYYY'))
               AND (   (NVL (p_by_tarf, 'N') = 'Y' AND tarf_cd IS NOT NULL)
                    OR (NVL (p_by_tarf, 'N') = 'N' AND tarf_cd IS NULL)
                   )
          GROUP BY line_cd,
                   subline_cd,
                   range_from,
                   range_to,
                   DECODE (p_by_tarf, 'Y', NVL (tarf_cd, 'X'), 'X'),
                   trty_name,
                   trty2_name,
                   trty3_name,
                   trty4_name,
                   trty5_name,
                   trty6_name,
                   trty7_name,
                   trty8_name,
                   trty9_name,
                   trty10_name)
      LOOP
         v_get_gipir948.line_cd := cur.line_cd;
         v_get_gipir948.subline_cd := cur.subline_cd;
         v_get_gipir948.range_from := cur.range_from;
         v_get_gipir948.range_to := cur.range_to;
         v_get_gipir948.policy_count := cur.policy_count;
         v_get_gipir948.net_retention := cur.net_retention;
         v_get_gipir948.net_retention_tsi := cur.net_retention_tsi;
         v_get_gipir948.sec_net_retention_prem := cur.sec_net_retention_prem;
         v_get_gipir948.sec_net_retention_tsi := cur.sec_net_retention_tsi;
         v_get_gipir948.quota_share := cur.quota_share;
         v_get_gipir948.quota_share_tsi := cur.quota_share_tsi;
         v_get_gipir948.facultative := cur.facultative;
         v_get_gipir948.facultative_tsi := cur.facultative_tsi;
         v_get_gipir948.treaty_tsi := cur.treaty_tsi;
         v_get_gipir948.treaty2_tsi := cur.treaty2_tsi;
         v_get_gipir948.treaty3_tsi := cur.treaty3_tsi;
         v_get_gipir948.treaty4_tsi := cur.treaty4_tsi;
         v_get_gipir948.treaty5_tsi := cur.treaty5_tsi;
         v_get_gipir948.treaty6_tsi := cur.treaty6_tsi;
         v_get_gipir948.treaty7_tsi := cur.treaty7_tsi;
         v_get_gipir948.treaty8_tsi := cur.treaty8_tsi;
         v_get_gipir948.treaty9_tsi := cur.treaty9_tsi;
         v_get_gipir948.treaty10_tsi := cur.treaty10_tsi;
         v_get_gipir948.treaty_prem := cur.treaty_prem;
         v_get_gipir948.treaty2_prem := cur.treaty2_prem;
         v_get_gipir948.treaty3_prem := cur.treaty3_prem;
         v_get_gipir948.treaty4_prem := cur.treaty4_prem;
         v_get_gipir948.treaty5_prem := cur.treaty5_prem;
         v_get_gipir948.treaty6_prem := cur.treaty6_prem;
         v_get_gipir948.treaty7_prem := cur.treaty7_prem;
         v_get_gipir948.treaty8_prem := cur.treaty8_prem;
         v_get_gipir948.treaty9_prem := cur.treaty9_prem;
         v_get_gipir948.treaty10_prem := cur.treaty10_prem;
         v_get_gipir948.tarf_cd := cur.tarf_cd;
         v_get_gipir948.trty_name := cur.trty_name;
         v_get_gipir948.trty2_name := cur.trty2_name;
         v_get_gipir948.trty3_name := cur.trty3_name;
         v_get_gipir948.trty4_name := cur.trty4_name;
         v_get_gipir948.trty5_name := cur.trty5_name;
         v_get_gipir948.trty6_name := cur.trty6_name;
         v_get_gipir948.trty7_name := cur.trty7_name;
         v_get_gipir948.trty8_name := cur.trty8_name;
         v_get_gipir948.trty9_name := cur.trty9_name;
         v_get_gipir948.trty10_name := cur.trty10_name;
         PIPE ROW (v_get_gipir948);
      END LOOP;

      RETURN;
   END get_rec_gipir948;

   FUNCTION get_dynsql_gipir934 (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN dyn_sql_query_tab PIPELINED
   IS
      v_dyn_query      dyn_sql_query;
      v_query          LONG                                 := '';
      v_is_fire_line   VARCHAR2 (1)                         := 'N';
      v_param_fi       giis_parameters.param_value_v%TYPE
                                        := NVL (giisp.v ('LINE_CODE_FI'), '');
   BEGIN
      FOR cur2 IN (SELECT menu_line_cd
                     FROM giis_line
                    WHERE line_cd = p_line_cd)
      LOOP
         IF cur2.menu_line_cd IS NULL AND p_line_cd = v_param_fi
         THEN
            v_is_fire_line := 'Y';
         ELSIF cur2.menu_line_cd IS NOT NULL AND cur2.menu_line_cd = 'FI'
         THEN
            v_is_fire_line := 'Y';
         END IF;
      END LOOP;

      -- compose the query
      v_query :=
         ' SELECT   a.line_cd line_cd, c.line_name, a.subline_cd subline_cd, d.subline_name, ';

      IF v_is_fire_line = 'Y'
      THEN
         v_query :=
               v_query
            || ' csv_uw_risk_profile.get_tariff_desc (a.tarf_cd) tariff, ';
      END IF;

      v_query := v_query || ' a.range_from,   a.range_to, ';

      FOR curperil IN (SELECT DISTINCT b.peril_cd, b.peril_name, b.peril_type
                                  FROM gipi_risk_profile a, giis_peril b
                                 WHERE 1 = 1
                                   AND a.peril_cd IS NOT NULL
                                   AND a.line_cd = b.line_cd
                                   AND a.peril_cd = b.peril_cd
                                   AND a.line_cd = p_line_cd
                                   AND NVL (a.subline_cd, '@@@@@@@@@@@@@') =
                                          NVL (p_subline_cd,
                                               NVL (a.subline_cd,
                                                    '@@@@@@@@@@@@@'
                                                   )
                                              )
                                   AND TRUNC (date_from) =
                                          TRUNC (TO_DATE (p_starting_date,
                                                          'MM-DD-YYYY'
                                                         )
                                                )
                                   AND TRUNC (date_to) =
                                          TRUNC (TO_DATE (p_ending_date,
                                                          'MM-DD-YYYY'
                                                         )
                                                )
                                   AND a.user_id = p_user_id
                                   AND a.all_line_tag = p_all_line_tag
                              ORDER BY b.peril_cd)
      LOOP
         v_query :=
               v_query
            || ' SUM (DECODE (a.peril_cd, '
            || curperil.peril_cd
            || ', NVL (a.policy_count, 0), 0) ) AS "'
            || curperil.peril_name
            || '-POL_CNT", ';
         v_query :=
               v_query
            || ' SUM (DECODE (a.peril_cd, '
            || curperil.peril_cd
            || ', NVL (a.peril_tsi, 0), 0) ) AS "'
            || curperil.peril_name
            || '-TSI_AMT", ';
         v_query :=
               v_query
            || ' SUM (DECODE (a.peril_cd, '
            || curperil.peril_cd
            || ', NVL (a.peril_prem , 0), 0) ) AS "'
            || curperil.peril_name
            || '-PREM_AMT", ';
      END LOOP;

      v_query :=
            v_query
         || ' SUM (NVL (a.policy_count, 0)) total_policy_count, '
         || ' SUM (DECODE (b.peril_type, ''B'', NVL (a.peril_tsi, 0), 0) ) total_sum_insured, '
         || '  SUM (NVL (a.peril_prem, 0)) total_premium FROM gipi_risk_profile a, giis_peril b,  '
         || '  giis_line c, giis_subline d WHERE a.peril_cd IS NOT NULL AND a.line_cd = b.line_cd '
         || ' AND a.peril_cd = b.peril_cd  AND a.line_cd = '''
         || p_line_cd
         || ''' AND NVL (a.subline_cd, ''@@@@@@@@@@@@@'') =  '
         || ' NVL ('''
         || p_subline_cd
         || ''', NVL (a.subline_cd, ''@@@@@@@@@@@@@'')) '
         || ' AND TRUNC (date_from) = TRUNC (TO_DATE ('''
         || p_starting_date
         || ''', ''MM-DD-YYYY'')) '
         || '  AND TRUNC (date_to) = TRUNC (TO_DATE ('''
         || p_ending_date
         || ''', ''MM-DD-YYYY'')) '
         || ' AND a.user_id = '''
         || p_user_id
         || '''  AND a.all_line_tag = '''
         || p_all_line_tag
         || ''''
         || ' AND a.line_cd = c.line_cd AND a.line_cd = d.line_cd  AND a.subline_cd = d.subline_cd  GROUP BY a.line_cd, '
         || ' c.line_name, a.subline_cd, d.subline_name,  a.range_from, a.range_to ';

      IF v_is_fire_line = 'Y'
      THEN
         v_query := v_query || ' , a.tarf_cd  ORDER BY a.tarf_cd,  ';
      ELSE
         v_query := v_query || ' ORDER BY ';
      END IF;

      v_query := v_query || '  a.range_from, a.range_to ';
      -- return the query
      v_dyn_query.query1 := SUBSTR (v_query, 1, 4000);
      v_dyn_query.query2 := SUBSTR (v_query, 4001, 8000);
      v_dyn_query.query3 := SUBSTR (v_query, 8001, 12000);
      v_dyn_query.query4 := SUBSTR (v_query, 12001, 16000);
      v_dyn_query.query5 := SUBSTR (v_query, 16001, 20000);
      v_dyn_query.query6 := SUBSTR (v_query, 20001, 24000);
      v_dyn_query.query7 := SUBSTR (v_query, 24001, 28000);
      v_dyn_query.query8 := SUBSTR (v_query, 28001, 32000);
      PIPE ROW (v_dyn_query);
      RETURN;
   END get_dynsql_gipir934;

   FUNCTION get_dynsql_gipir941 (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN dyn_sql_query_tab PIPELINED
   IS
      v_dyn_query   dyn_sql_query;
      v_query       LONG          := '';
   BEGIN
      v_query := ' SELECT   tbx001.line_cd, tbx001.line_name, ';

      IF p_subline_cd IS NOT NULL
      THEN
         v_query := v_query || ' tbx001.subline_cd, tbx001.subline_name, ';
      END IF;

      IF NVL (p_by_tarf, 'N') = 'Y'
      THEN
         v_query := v_query || ' tbx001.tariff,  ';
      END IF;

      v_query :=
            v_query
         || '  tbx001.range_from,  tbx001.range_to, SUM (tbx001.policy_count) policy_count, SUM (tbx001.net_retention) net_retention, '
         || ' SUM (tbx001.quota_share) quota_share, SUM (tbx001.treaty) treaty, SUM (tbx001.facultative) facultative,   SUM (tbx001.net_retention) '
         || '  + SUM (tbx001.quota_share) + SUM (tbx001.treaty) + SUM (tbx001.facultative) total  FROM (SELECT x.all_line_tag, x.line_cd, x.subline_cd, y.line_name,  ';

      IF p_subline_cd IS NOT NULL
      THEN
         v_query := v_query || ' z.subline_name,  ';
      END IF;

      IF NVL (p_by_tarf, 'N') = 'Y'
      THEN
         v_query :=
               v_query
            || ' csv_uw_risk_profile.get_tariff_desc (x.tarf_cd) tariff,   x.tarf_cd,  ';
      END IF;

      v_query :=
            v_query
         || ' x.range_from, x.range_to, NVL (x.policy_count, 0) policy_count,  NVL (x.net_retention, 0) net_retention,  NVL (x.quota_share, 0) quota_share, '
         || ' NVL (x.facultative, 0) facultative,  (  NVL (x.treaty_prem, 0) + NVL (x.treaty2_prem, 0)  + NVL (x.treaty3_prem, 0) + NVL (x.treaty4_prem, 0) '
         || ' + NVL (x.treaty5_prem, 0) + NVL (x.treaty6_prem, 0)   + NVL (x.treaty7_prem, 0)   + NVL (x.treaty8_prem, 0)   + NVL (x.treaty9_prem, 0) '
         || '  + NVL (x.treaty10_prem, 0)  ) treaty   FROM gipi_risk_profile x, giis_line y ';

      IF p_subline_cd IS NOT NULL
      THEN
         v_query := v_query || '  , giis_subline z  ';
      END IF;

      v_query :=
            v_query
         || ' WHERE  1 = 1   AND x.line_cd = NVL ('''
         || p_line_cd
         || ''', x.line_cd)  '
         || ' AND NVL (x.subline_cd, ''@@@@@@@@@@@'') = NVL (';

      IF p_subline_cd IS NULL
      THEN
         v_query := v_query || ' NULL , ';
      ELSE
         v_query := v_query || '''' || p_subline_cd || ''', ';
      END IF;

      v_query :=
            v_query
         || ' NVL (x.subline_cd, ''@@@@@@@@@@@'')) '
         || ' AND TRUNC (x.date_from) =  TRUNC (TO_DATE ('''
         || p_starting_date
         || ''', ''MM-DD-YYYY'')) '
         || '  AND TRUNC (x.date_to) = TRUNC (TO_DATE ('''
         || p_ending_date
         || ''',   ''MM-DD-YYYY'')) '
         || ' AND x.user_id = '''
         || p_user_id
         || '''    AND (   ( NVL( '''
         || p_by_tarf
         || ''', ''N'') = ''Y'' AND tarf_cd IS NOT NULL)  '
         || '  OR ( NVL( '''
         || p_by_tarf
         || ''', ''N'') = ''N'' AND tarf_cd IS NULL)  ) '
         || ' AND x.all_line_tag = '''
         || p_all_line_tag
         || ''' AND x.line_cd = y.line_cd ';

      IF p_subline_cd IS NOT NULL
      THEN
         v_query :=
               v_query
            || ' AND x.line_cd = z.line_cd  AND x.subline_cd = z.subline_cd    ';
      END IF;

      v_query :=
            v_query
         || '  ) tbx001 '
         || ' GROUP BY tbx001.line_cd,  tbx001.line_name,   tbx001.subline_cd, ';

      IF p_subline_cd IS NOT NULL
      THEN
         v_query := v_query || ' tbx001.subline_name,  ';
      END IF;

      IF NVL (p_by_tarf, 'N') = 'Y'
      THEN
         v_query := v_query || ' tbx001.tariff,    tbx001.tarf_cd,  ';
      END IF;

      v_query :=
            v_query
         || '  tbx001.range_from,  tbx001.range_to  ORDER BY tbx001.line_cd,     tbx001.line_name,   tbx001.subline_cd, ';

      IF p_subline_cd IS NOT NULL
      THEN
         v_query := v_query || '  tbx001.subline_name,  ';
      END IF;

      IF NVL (p_by_tarf, 'N') = 'Y'
      THEN
         v_query := v_query || ' tbx001.tariff,  ';
      END IF;

      v_query := v_query || '  tbx001.range_from,  tbx001.range_to       ';
      -- return the query
      v_dyn_query.query1 := SUBSTR (v_query, 1, 4000);
      v_dyn_query.query2 := SUBSTR (v_query, 4001, 8000);
      v_dyn_query.query3 := SUBSTR (v_query, 8001, 12000);
      v_dyn_query.query4 := SUBSTR (v_query, 12001, 16000);
      v_dyn_query.query5 := SUBSTR (v_query, 16001, 20000);
      v_dyn_query.query6 := SUBSTR (v_query, 20001, 24000);
      v_dyn_query.query7 := SUBSTR (v_query, 24001, 28000);
      v_dyn_query.query8 := SUBSTR (v_query, 28001, 32000);
      PIPE ROW (v_dyn_query);
      RETURN;
   END get_dynsql_gipir941;

   FUNCTION get_dynsql_gipir948 (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN dyn_sql_query_tab PIPELINED
   IS
      v_query                LONG                             := '';
      v_query1               VARCHAR2 (4000)                  := '';
      v_query2               VARCHAR2 (4000)                  := '';
      v_query3               VARCHAR2 (4000)                  := '';
      v_query4               VARCHAR2 (4000)                  := '';
      v_query5               VARCHAR2 (4000)                  := '';
      v_query6               VARCHAR2 (4000)                  := '';
      v_query7               VARCHAR2 (4000)                  := '';
      v_query8               VARCHAR2 (4000)                  := '';
      v_dist_share_tsi_nm    VARCHAR2 (30);
      v_dist_share_prem_nm   VARCHAR2 (30);
      v_target_trty_name     giis_dist_share.trty_name%TYPE;
      v_dyn_select           dyn_sql_query;
   BEGIN
      v_query := 'SELECT ';

      IF NVL (p_by_tarf, 'N') = 'Y'
      THEN
         v_query :=
               v_query
            || ' csv_uw_risk_profile.get_tariff_desc (a.tarf_cd) tariff, ';
      END IF;

      v_query := v_query || ' a.line_cd, b.line_name, ';

      IF p_subline_cd IS NOT NULL
      THEN
         v_query := v_query || ' c.subline_cd, c.subline_name,  ';
      END IF;

      v_query :=
            v_query
         || ' a.range_from, a.range_to, a.policy_count, a.net_retention_tsi, '
         || ' a.net_retention, a.quota_share_tsi, a.quota_share, a.facultative_tsi,  a.facultative ';

      FOR cur IN
         (SELECT   SUM (sec_net_retention_tsi) sec_net_retention_tsi,
                   SUM (sec_net_retention_prem) sec_net_retention_prem,
                   trty_name, trty2_name, trty3_name, trty4_name, trty5_name,
                   trty6_name, trty7_name, trty8_name, trty9_name,
                   trty10_name
              FROM TABLE
                      (cpi.csv_uw_risk_profile.get_rec_gipir948
                                                             (p_starting_date,
                                                              p_ending_date,
                                                              p_line_cd,
                                                              p_subline_cd,
                                                              p_all_line_tag,
                                                              p_param_date,
                                                              p_by_tarf,
                                                              p_user_id
                                                             )
                      )
          GROUP BY trty_name,
                   trty2_name,
                   trty3_name,
                   trty4_name,
                   trty5_name,
                   trty6_name,
                   trty7_name,
                   trty8_name,
                   trty9_name,
                   trty10_name)
      LOOP
         IF cur.sec_net_retention_tsi <> 0 OR cur.sec_net_retention_prem <> 0
         THEN
            v_query :=
                  v_query
               || ' , a.sec_net_retention_tsi, a.sec_net_retention_prem ';
         END IF;

/*** ****************************************************************************************************
***                                           FIRST TREATY
***  *************************************************************************************************** */
         IF cur.trty_name IS NOT NULL
         THEN
            -- table/column field names and aliases can only have column names up to 30 characters ( oracle restriction)
            -- that is why we have to ensure the column names does not exceed 30 characters
            -- we also need to ensure there are no duplicate column names as this would cause problem on the writing of the file
            v_target_trty_name := cur.trty_name;
            v_dist_share_tsi_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_tsi_nm) <= 26
            THEN
               v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
            ELSIF LENGTH (v_dist_share_tsi_nm) > 30
            THEN
               v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
            END IF;

            -- TSI column name should be different from Premium column name
            v_dist_share_prem_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_prem_nm) <= 25
            THEN
               v_dist_share_prem_nm := v_dist_share_prem_nm || '-PREM';
            ELSIF LENGTH (v_dist_share_prem_nm) > 30
            THEN
               v_dist_share_prem_nm :=
                                   SUBSTR (v_dist_share_prem_nm, 1, 29)
                                   || '2';
            ELSIF LENGTH (v_dist_share_prem_nm) BETWEEN 26 AND 30
            THEN
               v_dist_share_prem_nm :=
                                   SUBSTR (v_dist_share_prem_nm, 1, 29)
                                   || '2';
            END IF;

            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_tsi, '
               || ' a.trty2_name, a.treaty2_tsi, a.trty3_name, a.treaty3_tsi,  a.trty4_name, a.treaty4_tsi,'
               || ' a.trty5_name, a.treaty5_tsi, a.trty6_name, a.treaty6_tsi,  a.trty7_name, a.treaty7_tsi,'
               || ' a.trty8_name, a.treaty8_tsi, a.trty9_name, a.treaty9_tsi,  a.trty10_name, a.treaty10_tsi '
               || ' ) AS "'
               || v_dist_share_tsi_nm
               || '"';
            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_prem, '
               || ' a.trty2_name, a.treaty2_prem, a.trty3_name, a.treaty3_prem,  a.trty4_name, a.treaty4_prem,'
               || ' a.trty5_name, a.treaty5_prem, a.trty6_name, a.treaty6_prem,  a.trty7_name, a.treaty7_prem,'
               || ' a.trty8_name, a.treaty8_prem, a.trty9_name, a.treaty9_prem,  a.trty10_name, a.treaty10_prem '
               || ' ) AS "'
               || v_dist_share_prem_nm
               || '"';
         END IF;

/*** ****************************************************************************************************
 ***                                           SECOND  TREATY
 ***  *************************************************************************************************** */
         IF cur.trty2_name IS NOT NULL
         THEN
            -- table/column field names and aliases can only have column names up to 30 characters ( oracle restriction)
            -- that is why we have to ensure the column names does not exceed 30 characters
            -- we also need to ensure there are no duplicate column names as this would cause problem on the writing of the file
            v_target_trty_name := cur.trty2_name;
            v_dist_share_tsi_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_tsi_nm) <= 26
            THEN
               v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
            ELSIF LENGTH (v_dist_share_tsi_nm) > 30
            THEN
               v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
            END IF;

            -- TSI column name should be different from Premium column name
            v_dist_share_prem_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_prem_nm) <= 25
            THEN
               v_dist_share_prem_nm := v_dist_share_prem_nm || '-PREM';
            ELSIF LENGTH (v_dist_share_prem_nm) > 30
            THEN
               v_dist_share_prem_nm := SUBSTR (v_dist_share_prem_nm, 1, 30);
            ELSIF LENGTH (v_dist_share_prem_nm) BETWEEN 26 AND 30
            THEN
               v_dist_share_prem_nm :=
                                   SUBSTR (v_dist_share_prem_nm, 1, 29)
                                   || '2';
            END IF;

            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_tsi, '
               || ' a.trty2_name, a.treaty2_tsi, a.trty3_name, a.treaty3_tsi,  a.trty4_name, a.treaty4_tsi,'
               || ' a.trty5_name, a.treaty5_tsi, a.trty6_name, a.treaty6_tsi,  a.trty7_name, a.treaty7_tsi,'
               || ' a.trty8_name, a.treaty8_tsi, a.trty9_name, a.treaty9_tsi,  a.trty10_name, a.treaty10_tsi '
               || ' ) AS "'
               || v_dist_share_tsi_nm
               || '"';
            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_prem, '
               || ' a.trty2_name, a.treaty2_prem, a.trty3_name, a.treaty3_prem,  a.trty4_name, a.treaty4_prem,'
               || ' a.trty5_name, a.treaty5_prem, a.trty6_name, a.treaty6_prem,  a.trty7_name, a.treaty7_prem,'
               || ' a.trty8_name, a.treaty8_prem, a.trty9_name, a.treaty9_prem,  a.trty10_name, a.treaty10_prem '
               || ' ) AS "'
               || v_dist_share_prem_nm
               || '"';
         END IF;

/*** ****************************************************************************************************
 ***                                           THIRD  TREATY
 ***  *************************************************************************************************** */
         IF cur.trty3_name IS NOT NULL
         THEN
            -- table/column field names and aliases can only have column names up to 30 characters ( oracle restriction)
            -- that is why we have to ensure the column names does not exceed 30 characters
            -- we also need to ensure there are no duplicate column names as this would cause problem on the writing of the file
            v_target_trty_name := cur.trty3_name;
            v_dist_share_tsi_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_tsi_nm) <= 26
            THEN
               v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
            ELSIF LENGTH (v_dist_share_tsi_nm) > 30
            THEN
               v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
            END IF;

            -- TSI column name should be different from Premium column name
            v_dist_share_prem_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_prem_nm) <= 25
            THEN
               v_dist_share_prem_nm := v_dist_share_prem_nm || '-PREM';
            ELSIF LENGTH (v_dist_share_prem_nm) > 30
            THEN
               v_dist_share_prem_nm := SUBSTR (v_dist_share_prem_nm, 1, 30);
            ELSIF LENGTH (v_dist_share_prem_nm) BETWEEN 26 AND 30
            THEN
               v_dist_share_prem_nm :=
                                   SUBSTR (v_dist_share_prem_nm, 1, 29)
                                   || '2';
            END IF;

            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_tsi, '
               || ' a.trty2_name, a.treaty2_tsi, a.trty3_name, a.treaty3_tsi,  a.trty4_name, a.treaty4_tsi,'
               || ' a.trty5_name, a.treaty5_tsi, a.trty6_name, a.treaty6_tsi,  a.trty7_name, a.treaty7_tsi,'
               || ' a.trty8_name, a.treaty8_tsi, a.trty9_name, a.treaty9_tsi,  a.trty10_name, a.treaty10_tsi '
               || ' ) AS "'
               || v_dist_share_tsi_nm
               || '"';
            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_prem, '
               || ' a.trty2_name, a.treaty2_prem, a.trty3_name, a.treaty3_prem,  a.trty4_name, a.treaty4_prem,'
               || ' a.trty5_name, a.treaty5_prem, a.trty6_name, a.treaty6_prem,  a.trty7_name, a.treaty7_prem,'
               || ' a.trty8_name, a.treaty8_prem, a.trty9_name, a.treaty9_prem,  a.trty10_name, a.treaty10_prem '
               || ' ) AS "'
               || v_dist_share_prem_nm
               || '"';
         END IF;

/*** ****************************************************************************************************
 ***                                           FOURTH  TREATY
 ***  *************************************************************************************************** */
         IF cur.trty4_name IS NOT NULL
         THEN
            -- table/column field names and aliases can only have column names up to 30 characters ( oracle restriction)
            -- that is why we have to ensure the column names does not exceed 30 characters
            -- we also need to ensure there are no duplicate column names as this would cause problem on the writing of the file
            v_target_trty_name := cur.trty4_name;
            v_dist_share_tsi_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_tsi_nm) <= 26
            THEN
               v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
            ELSIF LENGTH (v_dist_share_tsi_nm) > 30
            THEN
               v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
            END IF;

            -- TSI column name should be different from Premium column name
            v_dist_share_prem_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_prem_nm) <= 25
            THEN
               v_dist_share_prem_nm := v_dist_share_prem_nm || '-PREM';
            ELSIF LENGTH (v_dist_share_prem_nm) > 30
            THEN
               v_dist_share_prem_nm := SUBSTR (v_dist_share_prem_nm, 1, 30);
            ELSIF LENGTH (v_dist_share_prem_nm) BETWEEN 26 AND 30
            THEN
               v_dist_share_prem_nm :=
                                   SUBSTR (v_dist_share_prem_nm, 1, 29)
                                   || '2';
            END IF;

            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_tsi, '
               || ' a.trty2_name, a.treaty2_tsi, a.trty3_name, a.treaty3_tsi,  a.trty4_name, a.treaty4_tsi,'
               || ' a.trty5_name, a.treaty5_tsi, a.trty6_name, a.treaty6_tsi,  a.trty7_name, a.treaty7_tsi,'
               || ' a.trty8_name, a.treaty8_tsi, a.trty9_name, a.treaty9_tsi,  a.trty10_name, a.treaty10_tsi '
               || ' ) AS "'
               || v_dist_share_tsi_nm
               || '"';
            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_prem, '
               || ' a.trty2_name, a.treaty2_prem, a.trty3_name, a.treaty3_prem,  a.trty4_name, a.treaty4_prem,'
               || ' a.trty5_name, a.treaty5_prem, a.trty6_name, a.treaty6_prem,  a.trty7_name, a.treaty7_prem,'
               || ' a.trty8_name, a.treaty8_prem, a.trty9_name, a.treaty9_prem,  a.trty10_name, a.treaty10_prem '
               || ' ) AS "'
               || v_dist_share_prem_nm
               || '"';
         END IF;

/*** ****************************************************************************************************
 ***                                           FIFTH  TREATY
 ***  *************************************************************************************************** */
         IF cur.trty5_name IS NOT NULL
         THEN
            -- table/column field names and aliases can only have column names up to 30 characters ( oracle restriction)
            -- that is why we have to ensure the column names does not exceed 30 characters
            -- we also need to ensure there are no duplicate column names as this would cause problem on the writing of the file
            v_target_trty_name := cur.trty5_name;
            v_dist_share_tsi_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_tsi_nm) <= 26
            THEN
               v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
            ELSIF LENGTH (v_dist_share_tsi_nm) > 30
            THEN
               v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
            END IF;

            -- TSI column name should be different from Premium column name
            v_dist_share_prem_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_prem_nm) <= 25
            THEN
               v_dist_share_prem_nm := v_dist_share_prem_nm || '-PREM';
            ELSIF LENGTH (v_dist_share_prem_nm) > 30
            THEN
               v_dist_share_prem_nm := SUBSTR (v_dist_share_prem_nm, 1, 30);
            ELSIF LENGTH (v_dist_share_prem_nm) BETWEEN 26 AND 30
            THEN
               v_dist_share_prem_nm :=
                                   SUBSTR (v_dist_share_prem_nm, 1, 29)
                                   || '2';
            END IF;

            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_tsi, '
               || ' a.trty2_name, a.treaty2_tsi, a.trty3_name, a.treaty3_tsi,  a.trty4_name, a.treaty4_tsi,'
               || ' a.trty5_name, a.treaty5_tsi, a.trty6_name, a.treaty6_tsi,  a.trty7_name, a.treaty7_tsi,'
               || ' a.trty8_name, a.treaty8_tsi, a.trty9_name, a.treaty9_tsi,  a.trty10_name, a.treaty10_tsi '
               || ' ) AS "'
               || v_dist_share_tsi_nm
               || '"';
            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_prem, '
               || ' a.trty2_name, a.treaty2_prem, a.trty3_name, a.treaty3_prem,  a.trty4_name, a.treaty4_prem,'
               || ' a.trty5_name, a.treaty5_prem, a.trty6_name, a.treaty6_prem,  a.trty7_name, a.treaty7_prem,'
               || ' a.trty8_name, a.treaty8_prem, a.trty9_name, a.treaty9_prem,  a.trty10_name, a.treaty10_prem '
               || ' ) AS "'
               || v_dist_share_prem_nm
               || '"';
         END IF;

/*** ****************************************************************************************************
 ***                                           SIXTH  TREATY
 ***  *************************************************************************************************** */
         IF cur.trty6_name IS NOT NULL
         THEN
            -- table/column field names and aliases can only have column names up to 30 characters ( oracle restriction)
            -- that is why we have to ensure the column names does not exceed 30 characters
            -- we also need to ensure there are no duplicate column names as this would cause problem on the writing of the file
            v_target_trty_name := cur.trty6_name;
            v_dist_share_tsi_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_tsi_nm) <= 26
            THEN
               v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
            ELSIF LENGTH (v_dist_share_tsi_nm) > 30
            THEN
               v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
            END IF;

            -- TSI column name should be different from Premium column name
            v_dist_share_prem_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_prem_nm) <= 25
            THEN
               v_dist_share_prem_nm := v_dist_share_prem_nm || '-PREM';
            ELSIF LENGTH (v_dist_share_prem_nm) > 30
            THEN
               v_dist_share_prem_nm := SUBSTR (v_dist_share_prem_nm, 1, 30);
            ELSIF LENGTH (v_dist_share_prem_nm) BETWEEN 26 AND 30
            THEN
               v_dist_share_prem_nm :=
                                   SUBSTR (v_dist_share_prem_nm, 1, 29)
                                   || '2';
            END IF;

            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_tsi, '
               || ' a.trty2_name, a.treaty2_tsi, a.trty3_name, a.treaty3_tsi,  a.trty4_name, a.treaty4_tsi,'
               || ' a.trty5_name, a.treaty5_tsi, a.trty6_name, a.treaty6_tsi,  a.trty7_name, a.treaty7_tsi,'
               || ' a.trty8_name, a.treaty8_tsi, a.trty9_name, a.treaty9_tsi,  a.trty10_name, a.treaty10_tsi '
               || ' ) AS "'
               || v_dist_share_tsi_nm
               || '"';
            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_prem, '
               || ' a.trty2_name, a.treaty2_prem, a.trty3_name, a.treaty3_prem,  a.trty4_name, a.treaty4_prem,'
               || ' a.trty5_name, a.treaty5_prem, a.trty6_name, a.treaty6_prem,  a.trty7_name, a.treaty7_prem,'
               || ' a.trty8_name, a.treaty8_prem, a.trty9_name, a.treaty9_prem,  a.trty10_name, a.treaty10_prem '
               || ' ) AS "'
               || v_dist_share_prem_nm
               || '"';
         END IF;

/*** ****************************************************************************************************
 ***                                           SEVENTH  TREATY
 ***  *************************************************************************************************** */
         IF cur.trty7_name IS NOT NULL
         THEN
            -- table/column field names and aliases can only have column names up to 30 characters ( oracle restriction)
            -- that is why we have to ensure the column names does not exceed 30 characters
            -- we also need to ensure there are no duplicate column names as this would cause problem on the writing of the file
            v_target_trty_name := cur.trty7_name;
            v_dist_share_tsi_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_tsi_nm) <= 26
            THEN
               v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
            ELSIF LENGTH (v_dist_share_tsi_nm) > 30
            THEN
               v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
            END IF;

            -- TSI column name should be different from Premium column name
            v_dist_share_prem_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_prem_nm) <= 25
            THEN
               v_dist_share_prem_nm := v_dist_share_prem_nm || '-PREM';
            ELSIF LENGTH (v_dist_share_prem_nm) > 30
            THEN
               v_dist_share_prem_nm := SUBSTR (v_dist_share_prem_nm, 1, 30);
            ELSIF LENGTH (v_dist_share_prem_nm) BETWEEN 26 AND 30
            THEN
               v_dist_share_prem_nm :=
                                   SUBSTR (v_dist_share_prem_nm, 1, 29)
                                   || '2';
            END IF;

            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_tsi, '
               || ' a.trty2_name, a.treaty2_tsi, a.trty3_name, a.treaty3_tsi,  a.trty4_name, a.treaty4_tsi,'
               || ' a.trty5_name, a.treaty5_tsi, a.trty6_name, a.treaty6_tsi,  a.trty7_name, a.treaty7_tsi,'
               || ' a.trty8_name, a.treaty8_tsi, a.trty9_name, a.treaty9_tsi,  a.trty10_name, a.treaty10_tsi '
               || ' ) AS "'
               || v_dist_share_tsi_nm
               || '"';
            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_prem, '
               || ' a.trty2_name, a.treaty2_prem, a.trty3_name, a.treaty3_prem,  a.trty4_name, a.treaty4_prem,'
               || ' a.trty5_name, a.treaty5_prem, a.trty6_name, a.treaty6_prem,  a.trty7_name, a.treaty7_prem,'
               || ' a.trty8_name, a.treaty8_prem, a.trty9_name, a.treaty9_prem,  a.trty10_name, a.treaty10_prem '
               || ' ) AS "'
               || v_dist_share_prem_nm
               || '"';
         END IF;

/*** ****************************************************************************************************
 ***                                           EIGHTH  TREATY
 ***  *************************************************************************************************** */
         IF cur.trty8_name IS NOT NULL
         THEN
            -- table/column field names and aliases can only have column names up to 30 characters ( oracle restriction)
            -- that is why we have to ensure the column names does not exceed 30 characters
            -- we also need to ensure there are no duplicate column names as this would cause problem on the writing of the file
            v_target_trty_name := cur.trty8_name;
            v_dist_share_tsi_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_tsi_nm) <= 26
            THEN
               v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
            ELSIF LENGTH (v_dist_share_tsi_nm) > 30
            THEN
               v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
            END IF;

            -- TSI column name should be different from Premium column name
            v_dist_share_prem_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_prem_nm) <= 25
            THEN
               v_dist_share_prem_nm := v_dist_share_prem_nm || '-PREM';
            ELSIF LENGTH (v_dist_share_prem_nm) > 30
            THEN
               v_dist_share_prem_nm := SUBSTR (v_dist_share_prem_nm, 1, 30);
            ELSIF LENGTH (v_dist_share_prem_nm) BETWEEN 26 AND 30
            THEN
               v_dist_share_prem_nm :=
                                   SUBSTR (v_dist_share_prem_nm, 1, 29)
                                   || '2';
            END IF;

            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_tsi, '
               || ' a.trty2_name, a.treaty2_tsi, a.trty3_name, a.treaty3_tsi,  a.trty4_name, a.treaty4_tsi,'
               || ' a.trty5_name, a.treaty5_tsi, a.trty6_name, a.treaty6_tsi,  a.trty7_name, a.treaty7_tsi,'
               || ' a.trty8_name, a.treaty8_tsi, a.trty9_name, a.treaty9_tsi,  a.trty10_name, a.treaty10_tsi '
               || ' ) AS "'
               || v_dist_share_tsi_nm
               || '"';
            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_prem, '
               || ' a.trty2_name, a.treaty2_prem, a.trty3_name, a.treaty3_prem,  a.trty4_name, a.treaty4_prem,'
               || ' a.trty5_name, a.treaty5_prem, a.trty6_name, a.treaty6_prem,  a.trty7_name, a.treaty7_prem,'
               || ' a.trty8_name, a.treaty8_prem, a.trty9_name, a.treaty9_prem,  a.trty10_name, a.treaty10_prem '
               || ' ) AS "'
               || v_dist_share_prem_nm
               || '"';
         END IF;

/*** ****************************************************************************************************
 ***                                           NINTH  TREATY
 ***  *************************************************************************************************** */
         IF cur.trty9_name IS NOT NULL
         THEN
            -- table/column field names and aliases can only have column names up to 30 characters ( oracle restriction)
            -- that is why we have to ensure the column names does not exceed 30 characters
            -- we also need to ensure there are no duplicate column names as this would cause problem on the writing of the file
            v_target_trty_name := cur.trty9_name;
            v_dist_share_tsi_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_tsi_nm) <= 26
            THEN
               v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
            ELSIF LENGTH (v_dist_share_tsi_nm) > 30
            THEN
               v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
            END IF;

            -- TSI column name should be different from Premium column name
            v_dist_share_prem_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_prem_nm) <= 25
            THEN
               v_dist_share_prem_nm := v_dist_share_prem_nm || '-PREM';
            ELSIF LENGTH (v_dist_share_prem_nm) > 30
            THEN
               v_dist_share_prem_nm := SUBSTR (v_dist_share_prem_nm, 1, 30);
            ELSIF LENGTH (v_dist_share_prem_nm) BETWEEN 26 AND 30
            THEN
               v_dist_share_prem_nm :=
                                   SUBSTR (v_dist_share_prem_nm, 1, 29)
                                   || '2';
            END IF;

            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_tsi, '
               || ' a.trty2_name, a.treaty2_tsi, a.trty3_name, a.treaty3_tsi,  a.trty4_name, a.treaty4_tsi,'
               || ' a.trty5_name, a.treaty5_tsi, a.trty6_name, a.treaty6_tsi,  a.trty7_name, a.treaty7_tsi,'
               || ' a.trty8_name, a.treaty8_tsi, a.trty9_name, a.treaty9_tsi,  a.trty10_name, a.treaty10_tsi '
               || ' ) AS "'
               || v_dist_share_tsi_nm
               || '"';
            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_prem, '
               || ' a.trty2_name, a.treaty2_prem, a.trty3_name, a.treaty3_prem,  a.trty4_name, a.treaty4_prem,'
               || ' a.trty5_name, a.treaty5_prem, a.trty6_name, a.treaty6_prem,  a.trty7_name, a.treaty7_prem,'
               || ' a.trty8_name, a.treaty8_prem, a.trty9_name, a.treaty9_prem,  a.trty10_name, a.treaty10_prem '
               || ' ) AS "'
               || v_dist_share_prem_nm
               || '"';
         END IF;

/*** ****************************************************************************************************
 ***                                           NINTH  TREATY
 ***  *************************************************************************************************** */
         IF cur.trty10_name IS NOT NULL
         THEN
            -- table/column field names and aliases can only have column names up to 30 characters ( oracle restriction)
            -- that is why we have to ensure the column names does not exceed 30 characters
            -- we also need to ensure there are no duplicate column names as this would cause problem on the writing of the file
            v_target_trty_name := cur.trty10_name;
            v_dist_share_tsi_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_tsi_nm) <= 26
            THEN
               v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
            ELSIF LENGTH (v_dist_share_tsi_nm) > 30
            THEN
               v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
            END IF;

            -- TSI column name should be different from Premium column name
            v_dist_share_prem_nm := v_target_trty_name;

            IF LENGTH (v_dist_share_prem_nm) <= 25
            THEN
               v_dist_share_prem_nm := v_dist_share_prem_nm || '-PREM';
            ELSIF LENGTH (v_dist_share_prem_nm) > 30
            THEN
               v_dist_share_prem_nm := SUBSTR (v_dist_share_prem_nm, 1, 30);
            ELSIF LENGTH (v_dist_share_prem_nm) BETWEEN 26 AND 30
            THEN
               v_dist_share_prem_nm :=
                                   SUBSTR (v_dist_share_prem_nm, 1, 29)
                                   || '2';
            END IF;

            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_tsi, '
               || ' a.trty2_name, a.treaty2_tsi, a.trty3_name, a.treaty3_tsi,  a.trty4_name, a.treaty4_tsi,'
               || ' a.trty5_name, a.treaty5_tsi, a.trty6_name, a.treaty6_tsi,  a.trty7_name, a.treaty7_tsi,'
               || ' a.trty8_name, a.treaty8_tsi, a.trty9_name, a.treaty9_tsi,  a.trty10_name, a.treaty10_tsi '
               || ' ) AS "'
               || v_dist_share_tsi_nm
               || '"';
            v_query :=
                  v_query
               || ', DECODE ('''
               || REPLACE(v_target_trty_name, '''', '''''') -- benjo 07.09.2015 added REPLACE (GENQA-SR-4326)
               || ''',  a.trty_name, a.treaty_prem, '
               || ' a.trty2_name, a.treaty2_prem, a.trty3_name, a.treaty3_prem,  a.trty4_name, a.treaty4_prem,'
               || ' a.trty5_name, a.treaty5_prem, a.trty6_name, a.treaty6_prem,  a.trty7_name, a.treaty7_prem,'
               || ' a.trty8_name, a.treaty8_prem, a.trty9_name, a.treaty9_prem,  a.trty10_name, a.treaty10_prem '
               || ' ) AS "'
               || v_dist_share_prem_nm
               || '"';
         END IF;
      END LOOP;

/*** *********************************************************************************************************
 ***                        ADD THE FINAL CLOSING SQL STATEMENT
 *** ******************************************************************************************************** */
      v_query :=
            v_query
         || ' FROM TABLE (cpi.csv_uw_risk_profile.get_rec_gipir948 ('''
         || p_starting_date
         || ''', '
         || ''''
         || p_ending_date
         || ''', '''
         || p_line_cd
         || ''' , ';

      IF p_subline_cd IS NULL
      THEN
         v_query := v_query || ' NULL  ';
      ELSE
         v_query := v_query || ' ''' || p_subline_cd || '''';
      END IF;

      v_query :=
            v_query
         || ', '''
         || p_all_line_tag
         || ''', '''
         || p_param_date
         || ''' , '''
         || p_by_tarf
         || ''', '''
         || p_user_id
         || ''''
         || ') ';
      v_query := v_query || ' ) a, giis_line b ';

      IF p_subline_cd IS NOT NULL
      THEN
         v_query := v_query || ' , giis_subline c ';
      END IF;

      v_query := v_query || ' where a.line_cd = b.line_cd  ';

      IF p_subline_cd IS NOT NULL
      THEN
         v_query :=
               v_query
            || '  AND a.line_cd = c.line_cd AND a.subline_cd = c.subline_cd ';
      END IF;

      IF NVL (p_by_tarf, 'N') = 'Y'
      THEN
         v_query :=
               v_query
            || '  ORDER BY csv_uw_risk_profile.get_tariff_desc (a.tarf_cd) , a.range_from , a.range_to ';
      ELSE
         v_query :=
                v_query || ' ORDER BY a.line_cd , a.range_from , a.range_to ';
      END IF;

      v_dyn_select.query1 := SUBSTR (v_query, 1, 4000);
      v_dyn_select.query2 := SUBSTR (v_query, 4001, 8000);
      v_dyn_select.query3 := SUBSTR (v_query, 8001, 12000);
      v_dyn_select.query4 := SUBSTR (v_query, 12001, 16000);
      v_dyn_select.query5 := SUBSTR (v_query, 16001, 20000);
      v_dyn_select.query6 := SUBSTR (v_query, 20001, 24000);
      v_dyn_select.query7 := SUBSTR (v_query, 24001, 28000);
      v_dyn_select.query8 := SUBSTR (v_query, 28001, 32000);
      PIPE ROW (v_dyn_select);
   END get_dynsql_gipir948;

   FUNCTION get_dynsql_gipir949 (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN dyn_sql_query_tab PIPELINED
   IS
      v_query_substr   dyn_sql_query;
      v_query          LONG          := '';
   BEGIN
      v_query := 'SELECT   tb001.line_cd, tb001.line_name, ';

      IF p_subline_cd IS NOT NULL
      THEN
         v_query := v_query || ' tb001.subline_cd, tb001.subline_name, ';
      END IF;

      IF NVL (p_by_tarf, 'N') = 'Y'
      THEN
         v_query := v_query || ' tb001.tariff, ';
      END IF;

      v_query :=
            v_query
         || '  tb001.range_from range_from , tb001.range_to range_to, tb001.policy_no,  SUM (tb001.ann_tsi_amt) ann_tsi_amt, '
         || ' SUM (tb001.netret_prem) net_ret_prem,  SUM (tb001.quota_prem) quota_prem, SUM (tb001.treaty_prem) treaty_prem, '
         || ' SUM (tb001.facul_prem) facul_prem,   SUM (tb001.netret_prem)  + SUM (tb001.quota_prem)  + SUM (tb001.treaty_prem) '
         || '  + SUM (tb001.facul_prem) total_premium  FROM (SELECT y.line_cd, y.line_name, z.subline_cd, z.subline_name,     ';

      IF NVL (p_by_tarf, 'N') = 'Y'
      THEN
         v_query :=
               v_query
            || '   csv_uw_risk_profile.get_tariff_desc (x.tarf_cd) tariff,  x.tarf_cd,  ';
      END IF;

      v_query :=
            v_query
         || '  x.range_from, x.range_to,   x.line_cd || ''-''  || x.subline_cd    || ''-''  || x.iss_cd  '
         || ' || ''-''  || LPAD (x.issue_yy, 2, ''0'') || ''-'' || LPAD (x.pol_seq_no, 7, ''0'')  || ''-''  || LPAD (x.renew_no, 2, ''0'') policy_no, '
         || '    NVL (x.ann_tsi_amt, 0) ann_tsi_amt, NVL (x.net_retention, 0) netret_prem,  NVL (x.quota_share, 0) quota_prem, '
         || '   (  NVL (treaty_prem, 0) + NVL (treaty2_prem, 0) + NVL (treaty3_prem, 0) + NVL (treaty4_prem, 0)+ NVL (treaty5_prem, 0) '
         || '   + NVL (treaty6_prem, 0) + NVL (treaty7_prem, 0)  + NVL (treaty8_prem, 0)  + NVL (treaty9_prem, 0) + NVL (treaty10_prem, 0) ) treaty_prem, '
         || ' NVL (x.facultative, 0) facul_prem  , x.iss_cd, x.issue_yy, x.pol_seq_no, x.renew_no FROM gipi_risk_profile_dtl x, giis_line y, giis_subline z  '
         || '    WHERE x.user_id = '''
         || p_user_id
         || '''   AND x.all_line_tag = '''
         || p_all_line_tag
         || ''' '
         || ' AND TRUNC (x.date_from) = TO_DATE ('''
         || p_starting_date
         || ''', ''MM/DD/RRRR'') '
         || ' AND TRUNC (x.date_to) = TO_DATE ( '''
         || p_ending_date
         || ''', ''MM/DD/RRRR'') '
         || ' AND x.line_cd = NVL ('''
         || p_line_cd
         || ''', x.line_cd)    AND x.subline_cd = NVL ('''
         || p_subline_cd
         || ''', x.subline_cd)     '
         || ' AND x.line_cd = y.line_cd  AND x.line_cd = z.line_cd   AND x.subline_cd = z.subline_cd) tb001  '
         || ' GROUP BY tb001.line_cd,     tb001.line_name,     tb001.subline_cd,   tb001.subline_name, ';

      IF NVL (p_by_tarf, 'N') = 'Y'
      THEN
         v_query := v_query || '   tb001.tariff, tb001.tarf_cd , ';
      END IF;

      v_query :=
            v_query
         || '  tb001.range_from,  tb001.range_to,  tb001.iss_cd,  tb001.issue_yy, tb001.pol_seq_no,  tb001.renew_no, tb001.policy_no '
         || ' ORDER BY tb001.line_cd,   tb001.line_name,  tb001.subline_cd, tb001.subline_name, ';

      IF NVL (p_by_tarf, 'N') = 'Y'
      THEN
         v_query := v_query || '   tb001.tariff,  ';
      END IF;

      v_query :=
            v_query
         || '  tb001.range_from, tb001.range_to, tb001.iss_cd, tb001.issue_yy,  tb001.pol_seq_no, tb001.renew_no, tb001.policy_no  ';
      -- divide the query into substring of 4000 characters
      v_query_substr.query1 := SUBSTR (v_query, 1, 4000);
      v_query_substr.query2 := SUBSTR (v_query, 4001, 8000);
      v_query_substr.query3 := SUBSTR (v_query, 8001, 12000);
      v_query_substr.query4 := SUBSTR (v_query, 12001, 16000);
      v_query_substr.query5 := SUBSTR (v_query, 16001, 20000);
      v_query_substr.query6 := SUBSTR (v_query, 20001, 24000);
      v_query_substr.query7 := SUBSTR (v_query, 24001, 28000);
      v_query_substr.query8 := SUBSTR (v_query, 28001, 32000);
      PIPE ROW (v_query_substr);
      RETURN;
   END get_dynsql_gipir949;

   FUNCTION get_dynsql_gipir949b (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN dyn_sql_query_tab PIPELINED
   IS
   BEGIN
      RETURN;
   END get_dynsql_gipir949b;

   FUNCTION get_dynsql_gipir949c (
      p_starting_date   VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_ending_date     VARCHAR2, -- should be passed in the format mm/dd/yyyy
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN dyn_sql_query_tab PIPELINED
   IS
   BEGIN
      RETURN;
   END get_dynsql_gipir949c;

   FUNCTION get_tariff_desc (p_tarf_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_tariff_desc   VARCHAR2 (100) := 'UNCATEGORIZED TARIFF';
   BEGIN
      FOR cur IN (SELECT rv_meaning tariff_desc
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIIS_TARIFF.TARF_CD'
                     AND rv_low_value = p_tarf_cd)
      LOOP
         v_tariff_desc := cur.tariff_desc;
      END LOOP;

      RETURN v_tariff_desc;
   END get_tariff_desc;
END csv_uw_risk_profile;
/

CREATE OR REPLACE PUBLIC SYNONYM csv_uw_risk_profile FOR cpi.csv_uw_risk_profile;

/