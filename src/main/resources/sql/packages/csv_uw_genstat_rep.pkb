CREATE OR REPLACE PACKAGE BODY CPI.csv_uw_genstat_rep
AS
/*Created by : Edgar Nobleza
**Description : Based on CSV_UNDRWRTNG Package to separate Fire Statistical CSV Reports
**
*/
   FUNCTION csv_gipir039b_old (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_table           VARCHAR2,
      p_column          VARCHAR2
   )
      RETURN gipir039b_type PIPELINED
   IS
      TYPE ref_cursor IS REF CURSOR;

      v_gipir039b         gipir039b_rec_type;
      cur1                ref_cursor;
      cur2                ref_cursor;
      v_query             VARCHAR2 (4000);
      v_tot_cnt           NUMBER;
      v_tot_tsi           NUMBER (18, 2);
      v_tot_prem          NUMBER (18, 2);
      v_zone_no           gipi_firestat_extract_dtl.zone_no%TYPE;
      v_zone_type         gipi_firestat_extract_dtl.zone_type%TYPE;
      v_zone_grp          VARCHAR2 (5);
      v_query2            VARCHAR2 (4000);
      v_pol_cnt           NUMBER;
      v_sum_tsi           NUMBER (20, 2);
      v_sum_prem          NUMBER (18, 2);
      v_fi_item_grp       gipi_firestat_extract_dtl.fi_item_grp%TYPE;
      v_bldg_pol_cnt      NUMBER                                       := 0;
      v_content_pol_cnt   NUMBER                                       := 0;
      v_loss_pol_cnt      NUMBER                                       := 0;
      v_expired_as_of     DATE     := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start      DATE     := TO_DATE (p_starting_date, 'MM/DD/YYYY');
      v_period_end        DATE       := TO_DATE (p_ending_date, 'MM/DD/YYYY');

      CURSOR curnew
      IS
         SELECT   tb.zone_grp_desc, tb.zone_no,
                  SUM (tb.bldg_pol_cnt) bldg_pol_cnt,
                  SUM (tb.bldg_exposure) bldg_exposure,
                  SUM (tb.bldg_premium) bldg_premium,
                  SUM (tb.contents_pol_cnt) contents_pol_cnt,
                  SUM (tb.contents_exposure) contents_exposure,
                  SUM (tb.contents_premium) contents_premium,
                  SUM (tb.lossprofit_pol_cnt) lossprofit_pol_cnt,
                  SUM (tb.lossprofit_exposure) lossprofit_exposure,
                  SUM (tb.lossprofit_premium) lossprofit_premium,
                  SUM (tb.total_share_tsi) total_share_tsi,
                  SUM (tb.total_share_prem_amt) total_share_prem_amt
             FROM (SELECT   ab.zone_no, ab.zone_grp, ab.zone_grp_desc,
                            ab.occupancy_desc, ab.occupancy_cd, ab.line_cd,
                            ab.subline_cd, ab.iss_cd, ab.issue_yy,
                            ab.pol_seq_no, ab.renew_no, ab.risk_item,
                            DECODE (SUM (ab.share_tsi_amt),
                                    0, 0,
                                    (DECODE (ab.fi_item_grp, 'B', 1, 0)
                                    )
                                   ) bldg_pol_cnt,
                            DECODE (SUM (ab.share_tsi_amt),
                                    0, 0,
                                    (DECODE (ab.fi_item_grp, 'C', 1, 0)
                                    )
                                   ) contents_pol_cnt,
                            DECODE
                                 (SUM (ab.share_tsi_amt),
                                  0, 0,
                                  (DECODE (ab.fi_item_grp, 'L', 1, 0))
                                 ) lossprofit_pol_cnt,
                            SUM (ab.bldg_exposure) bldg_exposure,
                            SUM (ab.bldg_premium) bldg_premium,
                            SUM (ab.contents_exposure) contents_exposure,
                            SUM (ab.contents_premium) contents_premium,
                            SUM (ab.lossprofit_exposure) lossprofit_exposure,
                            SUM (ab.lossprofit_premium) lossprofit_premium,
                            SUM (ab.share_tsi_amt) total_share_tsi,
                            SUM (ab.share_prem_amt) total_share_prem_amt,
                            ab.fi_item_grp
                       FROM (SELECT x.zone_no, x.zone_grp, x.zone_grp_desc,
                                    p.occupancy_desc, x.item_no risk_item,
                                    NVL (x.share_tsi_amt, 0) share_tsi_amt,
                                    NVL (x.share_prem_amt, 0) share_prem_amt,
                                    x.occupancy_cd, x.line_cd, x.subline_cd,
                                    x.iss_cd, x.issue_yy, x.pol_seq_no,
                                    x.renew_no, x.fi_item_grp,
                                    DECODE
                                        (x.fi_item_grp,
                                         'B', NVL (x.share_tsi_amt, 0),
                                         0
                                        ) bldg_exposure,
                                    DECODE
                                        (x.fi_item_grp,
                                         'B', NVL (x.share_prem_amt, 0),
                                         0
                                        ) bldg_premium,
                                    DECODE
                                       (x.fi_item_grp,
                                        'C', NVL (x.share_tsi_amt, 0),
                                        0
                                       ) contents_exposure,
                                    DECODE
                                       (x.fi_item_grp,
                                        'C', NVL (x.share_prem_amt, 0),
                                        0
                                       ) contents_premium,
                                    DECODE
                                       (x.fi_item_grp,
                                        'L', NVL (x.share_tsi_amt, 0),
                                        0
                                       ) lossprofit_exposure,
                                    DECODE
                                       (x.fi_item_grp,
                                        'L', NVL (x.share_prem_amt, 0),
                                        0
                                       ) lossprofit_premium
                               FROM gipi_firestat_extract_dtl_vw x,
                                    giis_fire_occupancy p
                              WHERE 1 = 1
                                AND x.occupancy_cd = p.occupancy_cd(+)
                                AND x.user_id = p_user
                                AND x.as_of_sw = p_as_of_sw
                                AND x.zone_type = p_zone_type
                                AND x.fi_item_grp IS NOT NULL
                                AND (   (    x.as_of_sw = 'Y'
                                         AND TRUNC (x.as_of_date) =
                                                TRUNC (NVL (v_expired_as_of,
                                                            x.as_of_date
                                                           )
                                                      )
                                        )
                                     OR (    x.as_of_sw = 'N'
                                         AND TRUNC (x.date_from) =
                                                TRUNC (NVL (v_period_start,
                                                            x.date_from
                                                           )
                                                      )
                                         AND TRUNC (x.date_to) =
                                                TRUNC (NVL (v_period_end,
                                                            x.date_to
                                                           )
                                                      )
                                        )
                                    )
                                AND (   NVL (x.share_tsi_amt, 0) <> 0
                                     OR NVL (x.share_prem_amt, 0) <> 0
                                    )) ab
                   GROUP BY ab.zone_no,
                            ab.zone_grp,
                            ab.zone_grp_desc,
                            ab.occupancy_cd,
                            ab.occupancy_desc,
                            ab.line_cd,
                            ab.subline_cd,
                            ab.iss_cd,
                            ab.issue_yy,
                            ab.pol_seq_no,
                            ab.renew_no,
                            ab.risk_item,
                            ab.fi_item_grp) tb
         GROUP BY tb.zone_no, tb.zone_grp, tb.zone_grp_desc
         ORDER BY tb.zone_grp, tb.zone_no;
   BEGIN
      v_query :=
            'SELECT COUNT(DISTINCT a.line_cd||''-''||a.subline_cd||''-''||a.iss_cd||''-''||LTRIM(TO_CHAR(a.issue_yy, ''09''))||''-''||LTRIM(TO_CHAR(a.pol_seq_no, ''0000009''))||''-''||LTRIM(TO_CHAR(a.renew_no, ''09''))) policy_no
                                   , SUM(NVL(share_tsi_amt,TO_NUMBER(''0.00''))) sum_tsi
                                   , SUM(NVL(share_prem_amt,TO_NUMBER(''0.00''))) sum_prem
                                   , b.zone_no
                                   , b.zone_type
                                   , c.zone_grp
                              FROM gipi_polbasic a,
                                   gipi_firestat_extract_dtl b,
                                   '
         || p_table
         || ' c
                             WHERE a.policy_id = b.policy_id
                                AND b.zone_type = '''
         || p_zone_type
         || '''
                                AND b.zone_no = '
         || p_column
         || '
                                AND b.as_of_sw = NVL('''
         || p_as_of_sw
         || ''',''N'')
                                AND b.fi_item_grp IS NOT NULL
                                AND b.user_id = '''
         || p_user
         || '''
                            GROUP BY  c.zone_grp, b.zone_no, b.zone_type
                            ORDER BY c.zone_grp';

      OPEN cur1 FOR v_query;

      LOOP
         FETCH cur1
          INTO v_tot_cnt, v_tot_tsi, v_tot_prem, v_zone_no, v_zone_type,
               v_zone_grp;

         EXIT WHEN cur1%NOTFOUND;

         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir039b.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir039b.period := p_starting_date || ' TO ' || p_ending_date;
         END IF;

         -- Zone Group - Zone No
         v_gipir039b.zone_grp := v_zone_grp;
         v_gipir039b.zone_no := v_zone_no;
         -- total
         v_gipir039b.tot_pol_cnt := v_tot_cnt;
         v_gipir039b.total_tsi := v_tot_tsi;
         v_gipir039b.total_prem := v_tot_prem;
         v_query2 :=
               'SELECT COUNT(DISTINCT a.line_cd||''-''||a.subline_cd||''-''||a.iss_cd||''-''||LTRIM(TO_CHAR(a.issue_yy, ''09''))||''-''||LTRIM(TO_CHAR(a.pol_seq_no, ''0000009''))||''-''||LTRIM(TO_CHAR(a.renew_no, ''09''))) policy_no
                                           , SUM(NVL(share_tsi_amt,TO_NUMBER(''0.00''))) sum_tsi
                                           , SUM(NVL(share_prem_amt,TO_NUMBER(''0.00''))) sum_prem
                                           , b.fi_item_grp
                                      FROM gipi_polbasic a,
                                           gipi_firestat_extract_dtl b,
                                           '
            || p_table
            || ' c
                                     WHERE a.policy_id = b.policy_id
                                        AND b.zone_type = '''
            || p_zone_type
            || '''
                                        AND b.zone_no = '
            || p_column
            || '
                                        AND b.as_of_sw = NVL('''
            || p_as_of_sw
            || ''',''N'')
                                        AND b.fi_item_grp IS NOT NULL
                                        AND b.user_id = '''
            || p_user
            || '''
                                        AND b.zone_no = '''
            || v_zone_no
            || '''
                                        AND c.zone_grp = '''
            || v_zone_grp
            || '''
                                    GROUP BY b.fi_item_grp';

         OPEN cur2 FOR v_query2;  --change by steven from v_query to v_query22

         LOOP
            FETCH cur2
             INTO v_pol_cnt, v_sum_tsi, v_sum_prem, v_fi_item_grp;

            EXIT WHEN cur2%NOTFOUND;

            IF UPPER (v_fi_item_grp) = 'B'
            THEN
               v_gipir039b.bldg_pol_cnt := v_pol_cnt;
               v_gipir039b.bldg_tot_tsi := v_sum_tsi;
               v_gipir039b.bldg_tot_prem := v_sum_prem;
            ELSIF UPPER (v_fi_item_grp) = 'C'
            THEN
               v_gipir039b.content_pol_cnt := v_pol_cnt;
               v_gipir039b.content_tot_tsi := v_sum_tsi;
               v_gipir039b.content_tot_prem := v_sum_prem;
            ELSIF UPPER (v_fi_item_grp) = 'L'
            THEN
               v_gipir039b.loss_pol_cnt := v_pol_cnt;
               v_gipir039b.loss_tot_tsi := v_sum_tsi;
               v_gipir039b.loss_tot_prem := v_sum_prem;
            END IF;
         END LOOP;

         PIPE ROW (v_gipir039b);
      END LOOP;

      RETURN;
   END csv_gipir039b_old;

   FUNCTION csv_gipir039b (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_table           VARCHAR2,
      p_column          VARCHAR2
   )
      RETURN gipir039b_type PIPELINED
   IS
      TYPE ref_cursor IS REF CURSOR;

      v_gipir039b         gipir039b_rec_type;
      cur1                ref_cursor;
      cur2                ref_cursor;
      v_query             VARCHAR2 (4000);
      v_tot_cnt           NUMBER;
      v_tot_tsi           NUMBER (18, 2);
      v_tot_prem          NUMBER (18, 2);
      v_zone_no           gipi_firestat_extract_dtl.zone_no%TYPE;
      v_zone_type         gipi_firestat_extract_dtl.zone_type%TYPE;
      v_zone_grp          VARCHAR2 (5);
      v_query2            VARCHAR2 (4000);
      v_pol_cnt           NUMBER;
      v_sum_tsi           NUMBER (20, 2);
      v_sum_prem          NUMBER (18, 2);
      v_fi_item_grp       gipi_firestat_extract_dtl.fi_item_grp%TYPE;
      v_bldg_pol_cnt      NUMBER                                       := 0;
      v_content_pol_cnt   NUMBER                                       := 0;
      v_loss_pol_cnt      NUMBER                                       := 0;
      v_expired_as_of     DATE     := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start      DATE     := TO_DATE (p_starting_date, 'MM/DD/YYYY');
      v_period_end        DATE       := TO_DATE (p_ending_date, 'MM/DD/YYYY');
      v_period            VARCHAR (2000);
   BEGIN
      IF p_as_of_sw = 'Y'
      THEN
         v_period := 'As of ' || p_expired_as_of;
      ELSE
         v_period := p_starting_date || ' TO ' || p_ending_date;
      END IF;

      FOR rec IN
         (SELECT   tb.zone_grp_desc, tb.zone_no,
                   SUM (tb.bldg_pol_cnt) bldg_pol_cnt,
                   SUM (tb.bldg_exposure) bldg_exposure,
                   SUM (tb.bldg_premium) bldg_premium,
                   SUM (tb.contents_pol_cnt) contents_pol_cnt,
                   SUM (tb.contents_exposure) contents_exposure,
                   SUM (tb.contents_premium) contents_premium,
                   SUM (tb.lossprofit_pol_cnt) lossprofit_pol_cnt,
                   SUM (tb.lossprofit_exposure) lossprofit_exposure,
                   SUM (tb.lossprofit_premium) lossprofit_premium,
                   SUM (tb.total_share_tsi) total_share_tsi,
                   SUM (tb.total_share_prem_amt) total_share_prem_amt
              FROM (SELECT   ab.zone_no, ab.zone_grp, ab.zone_grp_desc,
                             ab.occupancy_desc, ab.occupancy_cd, ab.line_cd,
                             ab.subline_cd, ab.iss_cd, ab.issue_yy,
                             ab.pol_seq_no, ab.renew_no, ab.risk_item,
                             DECODE (SUM (ab.share_tsi_amt),
                                     0, 0,
                                     (DECODE (ab.fi_item_grp, 'B', 1, 0)
                                     )
                                    ) bldg_pol_cnt,
                             DECODE
                                   (SUM (ab.share_tsi_amt),
                                    0, 0,
                                    (DECODE (ab.fi_item_grp, 'C', 1, 0)
                                    )
                                   ) contents_pol_cnt,
                             DECODE
                                 (SUM (ab.share_tsi_amt),
                                  0, 0,
                                  (DECODE (ab.fi_item_grp, 'L', 1, 0))
                                 ) lossprofit_pol_cnt,
                             SUM (ab.bldg_exposure) bldg_exposure,
                             SUM (ab.bldg_premium) bldg_premium,
                             SUM (ab.contents_exposure) contents_exposure,
                             SUM (ab.contents_premium) contents_premium,
                             SUM (ab.lossprofit_exposure) lossprofit_exposure,
                             SUM (ab.lossprofit_premium) lossprofit_premium,
                             SUM (ab.share_tsi_amt) total_share_tsi,
                             SUM (ab.share_prem_amt) total_share_prem_amt,
                             ab.fi_item_grp
                        FROM (SELECT DECODE (x.zone_no,
                                             NULL, '0',
                                             x.zone_no
                                            ) zone_no,
                                     x.zone_grp,
                                     DECODE (x.zone_grp,
                                             NULL, 'NO ZONE GROUP',
                                             x.zone_grp_desc
                                            ) zone_grp_desc,
                                     p.occupancy_desc, x.item_no risk_item,
                                     NVL (x.share_tsi_amt, 0) share_tsi_amt,
                                     NVL (x.share_prem_amt, 0) share_prem_amt,
                                     x.occupancy_cd, x.line_cd, x.subline_cd,
                                     x.iss_cd, x.issue_yy, x.pol_seq_no,
                                     x.renew_no, x.fi_item_grp,
                                     DECODE
                                        (x.fi_item_grp,
                                         'B', NVL (x.share_tsi_amt, 0),
                                         0
                                        ) bldg_exposure,
                                     DECODE
                                        (x.fi_item_grp,
                                         'B', NVL (x.share_prem_amt, 0),
                                         0
                                        ) bldg_premium,
                                     DECODE
                                        (x.fi_item_grp,
                                         'C', NVL (x.share_tsi_amt, 0),
                                         0
                                        ) contents_exposure,
                                     DECODE
                                        (x.fi_item_grp,
                                         'C', NVL (x.share_prem_amt, 0),
                                         0
                                        ) contents_premium,
                                     DECODE
                                        (x.fi_item_grp,
                                         'L', NVL (x.share_tsi_amt, 0),
                                         0
                                        ) lossprofit_exposure,
                                     DECODE
                                        (x.fi_item_grp,
                                         'L', NVL (x.share_prem_amt, 0),
                                         0
                                        ) lossprofit_premium
                                FROM gipi_firestat_extract_dtl_vw x,
                                     giis_fire_occupancy p
                               WHERE 1 = 1
                                 AND x.occupancy_cd = p.occupancy_cd(+)
                                 AND x.user_id = p_user
                                 AND x.as_of_sw = p_as_of_sw
                                 AND x.zone_type = p_zone_type
                                 AND x.fi_item_grp IS NOT NULL
                                 AND (   (    x.as_of_sw = 'Y'
                                          AND TRUNC (x.as_of_date) =
                                                 TRUNC (NVL (v_expired_as_of,
                                                             x.as_of_date
                                                            )
                                                       )
                                         )
                                      OR (    x.as_of_sw = 'N'
                                          AND TRUNC (x.date_from) =
                                                 TRUNC (NVL (v_period_start,
                                                             x.date_from
                                                            )
                                                       )
                                          AND TRUNC (x.date_to) =
                                                 TRUNC (NVL (v_period_end,
                                                             x.date_to
                                                            )
                                                       )
                                         )
                                     )
                                 AND (   NVL (x.share_tsi_amt, 0) <> 0
                                      OR NVL (x.share_prem_amt, 0) <> 0
                                     )) ab
                    GROUP BY ab.zone_no,
                             ab.zone_grp,
                             ab.zone_grp_desc,
                             ab.occupancy_cd,
                             ab.occupancy_desc,
                             ab.line_cd,
                             ab.subline_cd,
                             ab.iss_cd,
                             ab.issue_yy,
                             ab.pol_seq_no,
                             ab.renew_no,
                             ab.risk_item,
                             ab.fi_item_grp) tb
          GROUP BY tb.zone_no, tb.zone_grp, tb.zone_grp_desc
          ORDER BY tb.zone_grp, tb.zone_no)
      LOOP
         v_gipir039b.period := v_period;
         v_gipir039b.zone_grp := rec.zone_grp_desc;
         v_gipir039b.zone_no := rec.zone_no;
         v_gipir039b.bldg_pol_cnt := rec.bldg_pol_cnt;
         v_gipir039b.bldg_tot_tsi := rec.bldg_exposure;
         v_gipir039b.bldg_tot_prem := rec.bldg_premium;
         v_gipir039b.content_pol_cnt := rec.contents_pol_cnt;
         v_gipir039b.content_tot_tsi := rec.contents_exposure;
         v_gipir039b.content_tot_prem := rec.contents_premium;
         v_gipir039b.loss_pol_cnt := rec.lossprofit_pol_cnt;
         v_gipir039b.loss_tot_tsi := rec.lossprofit_exposure;
         v_gipir039b.loss_tot_prem := rec.lossprofit_premium;
         v_gipir039b.tot_pol_cnt :=
             rec.bldg_pol_cnt + rec.contents_pol_cnt + rec.lossprofit_pol_cnt;
         v_gipir039b.total_tsi := rec.total_share_tsi;
         v_gipir039b.total_prem := rec.total_share_prem_amt;
         PIPE ROW (v_gipir039b);
      END LOOP;

      RETURN;
   END csv_gipir039b;

   FUNCTION get_gipir037_recdtl (
      p_as_of_sw        VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_recdtl_tab PIPELINED
   IS
      v_list            gipir037_recdtl_type;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start    DATE        := TO_DATE (p_period_start, 'MM/DD/YYYY');
      v_period_end      DATE          := TO_DATE (p_period_end, 'MM/DD/YYYY');
   BEGIN
      FOR i IN (SELECT   b200.zone_type, b200.zone_no, c.zone_grp,
                         SUM (NVL (b200.share_tsi_amt, 0)) share_tsi_amt,
                         SUM (NVL (b200.share_prem_amt, 0)) share_prem_amt,
                         c.zone_grp_desc, b100.line_cd, b100.share_cd,
                         b100.share_type
                    FROM gipi_firestat_extract_dtl b200,
                         giis_dist_share b100,
                         (SELECT ax.zone_type, ax.zone_no, ax.zone_grp,
                                 tx.rv_meaning zone_grp_desc
                            FROM (SELECT '1' zone_type, x.flood_zone zone_no,
                                         x.zone_grp
                                    FROM giis_flood_zone x
                                  UNION
                                  SELECT '2' zone_type,
                                         y.typhoon_zone zone_no, y.zone_grp
                                    FROM giis_typhoon_zone y
                                  UNION
                                  SELECT '3' zone_type, z.eq_zone zone_no,
                                         z.zone_grp
                                    FROM giis_eqzone z) ax,
                                 cg_ref_codes tx
                           WHERE tx.rv_domain = 'ZONE_GROUP'
                             AND tx.rv_low_value = ax.zone_grp) c
                   WHERE 1 = 1
                     AND b200.zone_type = p_zonetype
                     AND b200.user_id = p_user
                     AND b200.as_of_sw = p_as_of_sw
                     AND b200.zone_type IN ('1', '2', '3', '4')
                     AND b200.line_cd = b100.line_cd
                     AND b200.share_cd = b100.share_cd
                     AND b100.share_type IN (1, 2, 3)
                     AND b200.zone_no = c.zone_no(+)
                     AND b200.zone_type = c.zone_type(+)
                     AND (       p_as_of_sw = 'Y'
                             AND b200.as_of_date = v_expired_as_of
                          OR     p_as_of_sw = 'N'
                             AND b200.date_from = v_period_start
                             AND b200.date_to = v_period_end
                         )
                GROUP BY b200.zone_type,
                         b200.zone_no,
                         c.zone_grp,
                         c.zone_grp_desc,
                         b100.line_cd,
                         b100.share_cd,
                         b100.share_type
                  HAVING SUM (NVL (b200.share_tsi_amt, 0)) <> 0
                      OR SUM (NVL (b200.share_prem_amt, 0)) <> 0
                UNION ALL
                SELECT   b200.zone_type, b200.zone_no, c.zone_grp,
                         SUM (NVL (b200.share_tsi_amt, 0)) share_tsi_amt,
                         SUM (NVL (b200.share_prem_amt, 0)) share_prem_amt,
                         c.zone_grp_desc, b100.line_cd, b100.share_cd,
                         b100.share_type
                    FROM gipi_firestat_extract_dtl b200,
                         giis_dist_share b100,
                         (SELECT '5' zone_type, ax.zone_no, ax.zone_grp,
                                 tx.rv_meaning zone_grp_desc
                            FROM (SELECT '2' zone_type,
                                         y.typhoon_zone zone_no, y.zone_grp
                                    FROM giis_typhoon_zone y) ax,
                                 cg_ref_codes tx
                           WHERE tx.rv_domain = 'ZONE_GROUP'
                             AND tx.rv_low_value = ax.zone_grp) c
                   WHERE 1 = 1
                     AND b200.zone_type = p_zonetype
                     AND b200.user_id = p_user
                     AND b200.as_of_sw = p_as_of_sw
                     AND b200.zone_type = '5'
                     AND b200.line_cd = b100.line_cd
                     AND b200.share_cd = b100.share_cd
                     AND (   b200.typhoon_zone IS NOT NULL
                          OR (    b200.typhoon_zone IS NULL
                              AND b200.flood_zone IS NULL
                             )
                         )
                     AND b200.zone_no = c.zone_no(+)
                     AND b200.zone_type = c.zone_type(+)
                     AND (       p_as_of_sw = 'Y'
                             AND b200.as_of_date = v_expired_as_of
                          OR     p_as_of_sw = 'N'
                             AND b200.date_from = v_period_start
                             AND b200.date_to = v_period_end
                         )
                GROUP BY b200.zone_type,
                         b200.zone_no,
                         c.zone_grp,
                         c.zone_grp_desc,
                         b100.line_cd,
                         b100.share_cd,
                         b100.share_type
                  HAVING SUM (NVL (b200.share_tsi_amt, 0)) <> 0
                      OR SUM (NVL (b200.share_prem_amt, 0)) <> 0
                UNION ALL
                SELECT   b200.zone_type, b200.zone_no, c.zone_grp,
                         SUM (NVL (b200.share_tsi_amt, 0)) share_tsi_amt,
                         SUM (NVL (b200.share_prem_amt, 0)) share_prem_amt,
                         c.zone_grp_desc, b100.line_cd, b100.share_cd,
                         b100.share_type
                    FROM gipi_firestat_extract_dtl b200,
                         giis_dist_share b100,
                         (SELECT '5' zone_type, ax.zone_no, ax.zone_grp,
                                 tx.rv_meaning zone_grp_desc
                            FROM (SELECT '2' zone_type, y.flood_zone zone_no,
                                         y.zone_grp
                                    FROM giis_flood_zone y) ax,
                                 cg_ref_codes tx
                           WHERE tx.rv_domain = 'ZONE_GROUP'
                             AND tx.rv_low_value = ax.zone_grp) c
                   WHERE 1 = 1
                     AND b200.zone_type = p_zonetype
                     AND b200.user_id = p_user
                     AND b200.as_of_sw = p_as_of_sw
                     AND b200.zone_type = '5'
                     AND b200.line_cd = b100.line_cd
                     AND b200.share_cd = b100.share_cd
                     AND (    b200.typhoon_zone IS NULL
                          AND b200.flood_zone IS NOT NULL
                         )
                     AND b200.zone_no = c.zone_no(+)
                     AND b200.zone_type = c.zone_type(+)
                     AND (       p_as_of_sw = 'Y'
                             AND b200.as_of_date = v_expired_as_of
                          OR     p_as_of_sw = 'N'
                             AND b200.date_from = v_period_start
                             AND b200.date_to = v_period_end
                         )
                GROUP BY b200.zone_type,
                         b200.zone_no,
                         c.zone_grp,
                         c.zone_grp_desc,
                         b100.line_cd,
                         b100.share_cd,
                         b100.share_type
                  HAVING SUM (NVL (b200.share_tsi_amt, 0)) <> 0
                      OR SUM (NVL (b200.share_prem_amt, 0)) <> 0
                ORDER BY zone_type,
                         zone_no,
                         zone_grp,
                         line_cd,
                         share_cd,
                         share_type,
                         share_cd)
      LOOP
         v_list.zone_type := i.zone_type;
         v_list.zone_no := i.zone_no;
         v_list.zone_grp := i.zone_grp;
         v_list.zone_grp_desc := i.zone_grp_desc;
         v_list.line_cd := i.line_cd;
         v_list.share_cd := i.share_cd;
         v_list.share_type := i.share_type;
         v_list.share_tsi_amt := i.share_tsi_amt;
         v_list.share_prem_amt := i.share_prem_amt;
         PIPE ROW (v_list);
      END LOOP;
   END get_gipir037_recdtl;

   FUNCTION get_gipir037a_core_rec (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_risk_cnt        VARCHAR2
   )
      RETURN gipir037a_base_tab PIPELINED
   IS
      v_expired_as_of    DATE      := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start     DATE      := TO_DATE (p_starting_date, 'MM/DD/YYYY');
      v_period_end       DATE        := TO_DATE (p_ending_date, 'MM/DD/YYYY');
      v_gipir037a_core   gipir037a_base_tbl_rec;
   BEGIN
      FOR cur IN
         (SELECT   tb.zone_no, tb.zone_grp, SUM (tb.risk_cnt) risk_cnt,
                   SUM (tb.total_share_tsi) total_share_tsi,
                   SUM (tb.total_share_prem_amt) total_share_prem_amt
              FROM (SELECT   ab.zone_no, ab.zone_grp, ab.occupancy_cd,
                             ab.line_cd, ab.subline_cd, ab.iss_cd,
                             ab.issue_yy, ab.pol_seq_no, ab.renew_no,
                             ab.risk_item,
                             DECODE (SUM (share_tsi_amt), 0, 0, 1) risk_cnt,
                             SUM (share_tsi_amt) total_share_tsi,
                             SUM (share_prem_amt) total_share_prem_amt
                        FROM (SELECT x.zone_no, x.zone_grp,
                                     DECODE (p_risk_cnt,
                                             'P', TO_CHAR (x.item_no),
                                             'R', x.block_id
                                              || '-'
                                              || NVL (x.risk_cd, '@@@@@@@'),
                                             ''
                                            ) risk_item,
                                     NVL (x.share_tsi_amt, 0) share_tsi_amt,
                                     NVL (x.share_prem_amt, 0) share_prem_amt,
                                     x.occupancy_cd, x.line_cd, x.subline_cd,
                                     x.iss_cd, x.issue_yy, x.pol_seq_no,
                                     x.renew_no
                                FROM gipi_firestat_extract_dtl_vw x
                               WHERE x.user_id = p_user_id
                                 AND x.as_of_sw = p_as_of_sw
                                 AND x.zone_type = p_zone_type
                                 AND (   (    x.as_of_sw = 'Y'
                                          AND TRUNC (x.as_of_date) =
                                                 TRUNC (NVL (v_expired_as_of,
                                                             x.as_of_date
                                                            )
                                                       )
                                         )
                                      OR (    x.as_of_sw = 'N'
                                          AND TRUNC (x.date_from) =
                                                 TRUNC (NVL (v_period_start,
                                                             x.date_from
                                                            )
                                                       )
                                          AND TRUNC (x.date_to) =
                                                 TRUNC (NVL (v_period_end,
                                                             x.date_to
                                                            )
                                                       )
                                         )
                                     )
                                 AND (   NVL (x.share_tsi_amt, 0) <> 0
                                      OR NVL (x.share_prem_amt, 0) <> 0
                                     )) ab
                    GROUP BY ab.zone_no,
                             ab.zone_grp,
                             ab.occupancy_cd,
                             ab.line_cd,
                             ab.subline_cd,
                             ab.iss_cd,
                             ab.issue_yy,
                             ab.pol_seq_no,
                             ab.renew_no,
                             ab.risk_item) tb
          GROUP BY tb.zone_no, tb.zone_grp)
      LOOP
         v_gipir037a_core.zone_no := cur.zone_no;
         v_gipir037a_core.zone_grp := cur.zone_grp;
         v_gipir037a_core.risk_cnt := cur.risk_cnt;
         v_gipir037a_core.gross_sum_insured := cur.total_share_tsi;
         v_gipir037a_core.gross_premium := cur.total_share_prem_amt;
         PIPE ROW (v_gipir037a_core);
      END LOOP;

      RETURN;
   END get_gipir037a_core_rec;

   FUNCTION get_gipir037a_dynsql (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_risk_cnt        VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED
   IS
      v_query                LONG                             := '';
      v_query1               VARCHAR2 (4000);
      v_query2               VARCHAR2 (4000);
      v_query3               VARCHAR2 (4000);
      v_query4               VARCHAR2 (4000);
      v_query5               VARCHAR2 (4000);
      v_query6               VARCHAR2 (4000);
      v_query7               VARCHAR2 (4000);
      v_query8               VARCHAR2 (4000);
      v_dyn_query            csv_dynamicsql;
      v_expired_as_of        DATE  := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start         DATE  := TO_DATE (p_starting_date, 'MM/DD/YYYY');
      v_period_end           DATE    := TO_DATE (p_ending_date, 'MM/DD/YYYY');
      v_dist_share_tsi_nm    VARCHAR2 (30);
      v_dist_share_prem_nm   VARCHAR2 (30);
      v_target_trty_name     giis_dist_share.trty_name%TYPE;
   BEGIN
      v_query :=
            ' SELECT   t001.zone_type,  '
         || ' DECODE (t001.zone_grp,   NULL, ''NO ZONE GROUP'',  t001.zone_grp_desc ) zone_group, '
         || ' DECODE (t001.zone_no, NULL, ''Zone 0'', t001.zone_no) zone_no, NVL (t001.zone_desc, '''') zone_desc, t002.risk_cnt, ';

      FOR curdist IN (SELECT DISTINCT x.share_type, x.share_cd,
                                      x.dist_share_name
                                 FROM gipi_firestat_extract_dtl_vw x
                                WHERE x.user_id = p_user_id
                                  AND x.zone_type = p_zone_type
                                  AND x.as_of_sw = p_as_of_sw
                                  AND (   (    x.as_of_sw = 'Y'
                                           AND TRUNC (x.as_of_date) =
                                                  TRUNC (NVL (v_expired_as_of,
                                                              x.as_of_date
                                                             )
                                                        )
                                          )
                                       OR (    x.as_of_sw = 'N'
                                           AND TRUNC (x.date_from) =
                                                  TRUNC (NVL (v_period_start,
                                                              x.date_from
                                                             )
                                                        )
                                           AND TRUNC (x.date_to) =
                                                  TRUNC (NVL (v_period_end,
                                                              x.date_to
                                                             )
                                                        )
                                          )
                                      )
                                  AND (   NVL (x.share_tsi_amt, 0) <> 0
                                       OR NVL (x.share_prem_amt, 0) <> 0
                                      )
                             ORDER BY x.share_type, x.share_cd)
      LOOP
         v_target_trty_name := curdist.dist_share_name;
         v_dist_share_tsi_nm := v_target_trty_name;

         IF LENGTH (v_dist_share_tsi_nm) <= 26
         THEN
            v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
         ELSIF LENGTH (v_dist_share_tsi_nm) > 30
         THEN
            v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
         END IF;

         v_query :=
               v_query
            || 'SUM (DECODE (t001.share_cd, '
            || curdist.share_cd
            || ' , NVL (t001.share_tsi_amt, 0) , 0 ) ) AS "'
            || v_dist_share_tsi_nm
            || '", ';
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
            || 'SUM (DECODE (t001.share_cd, '
            || curdist.share_cd
            || ' , NVL (t001.share_prem_amt, 0) , 0 ) ) AS "'
            || v_dist_share_prem_nm
            || '", ';
      END LOOP;

      v_query :=
            v_query
         || 't002.gross_sum_insured  , t002.gross_premium  FROM gipi_firestat_extract_dtl_vw t001, '
         || ' (SELECT zone_no, zone_grp, gross_sum_insured, gross_premium,  risk_cnt '
         || '  FROM TABLE  (csv_uw_genstat_rep.get_gipir037a_core_rec   ( '''
         || p_starting_date
         || ''', '
         || ' '''
         || p_ending_date
         || ''', '''
         || p_user_id
         || ''',  '''
         || p_as_of_sw
         || ''',  '''
         || p_zone_type
         || ''', '
         || '   '''
         || p_expired_as_of
         || ''',   '''
         || p_risk_cnt
         || '''   ) )) t002 '
         || ' WHERE t001.user_id = '''
         || p_user_id
         || '''    AND t001.zone_type = '''
         || p_zone_type
         || '''  AND t001.as_of_sw =  '''
         || p_as_of_sw
         || ''' '
         || '  AND (   (    t001.as_of_sw = ''Y''    AND TRUNC (t001.as_of_date) =  TRUNC (NVL (TO_DATE ('''
         || p_expired_as_of
         || ''' , ''MM/DD/YYYY''), t001.as_of_date)) '
         || '      )   OR (    t001.as_of_sw = ''N''  AND TRUNC (t001.date_from) = TRUNC (NVL (TO_DATE ( '''
         || p_starting_date
         || ''', ''MM/DD/YYYY''), t001.date_from)) '
         || '         AND TRUNC (t001.date_to) =   TRUNC (NVL (TO_DATE ('''
         || p_ending_date
         || ''', ''MM/DD/YYYY''), t001.date_to))    )      ) '
         || '  AND (NVL (t001.share_tsi_amt, 0) <> 0 OR NVL (t001.share_prem_amt, 0) <>   0     ) '
         || '  AND NVL (t001.zone_no, 0) = NVL (t002.zone_no, 0)   AND NVL (t001.zone_grp, ''-1'') = NVL (t002.zone_grp, ''-1'') '
         || ' GROUP BY t001.zone_type,      t001.zone_grp,   t001.zone_grp_desc,     t001.zone_no,     t001.zone_desc,    t002.risk_cnt, '
         || '    t002.gross_sum_insured,   t002.gross_premium';
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
   END get_gipir037a_dynsql;

   FUNCTION csv_gipir037 (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir037_type PIPELINED
   IS
      v_list            gipir037_rec_type;
      v_expired_as_of   VARCHAR2 (100)                 := '';
      v_period_start    VARCHAR2 (100)                 := '';
      v_period_end      VARCHAR2 (100)                 := '';
      v_zone_type       cg_ref_codes.rv_meaning%TYPE   := '';
      v_date_format     VARCHAR2 (500);
   BEGIN
      IF p_as_of_sw = 'Y'
      THEN
         v_expired_as_of := TO_CHAR (TO_DATE (p_expired_as_of, 'MM/DD/YYYY'));
      ELSE
         v_period_start := TO_CHAR (TO_DATE (p_starting_date, 'MM/DD/YYYY'));
         v_period_end := TO_CHAR (TO_DATE (p_ending_date, 'MM/DD/YYYY'));
      END IF;

      FOR cur IN
         (SELECT rv_meaning
            FROM cg_ref_codes
           WHERE rv_domain LIKE '%GIPI_FIRESTAT_EXTRACT.ZONE_TYPE%'
             AND rv_low_value = p_zone_type)
      LOOP
         v_zone_type := cur.rv_meaning;
         EXIT;
      END LOOP;

      FOR i IN
         (SELECT   ab.zone_no, ab.zone_grp, ab.division,
                   SUM (ab.gross_tsi_amt) gross_tsi_amt,
                   SUM (ab.gross_prem_amt) gross_prem_amt,
                   SUM (ab.net_ret_tsi) net_ret_tsi_amt,
                   SUM (ab.net_ret_prem) net_ret_prem_amt,
                   SUM (ab.facul_tsi) facul_tsi_amt,
                   SUM (ab.facul_prem) facul_prem_amt,
                   SUM (ab.treaty_tsi) treaty_tsi_amt,
                   SUM (ab.treaty_prem) treaty_prem_amt
              FROM (SELECT DECODE (xb.zone_no,
                                   NULL, 'NULL ZONE',
                                   xb.zone_no
                                  ) zone_no,
                           xb.zone_grp,
                           DECODE (xb.zone_grp,
                                   NULL, 'NO ZONE GROUP',
                                   xb.zone_grp_desc
                                  ) division,
                           NVL (xb.share_tsi_amt, 0) gross_tsi_amt,
                           DECODE (xb.share_type,
                                   1, NVL (xb.share_tsi_amt, 0),
                                   0
                                  ) net_ret_tsi,
                           DECODE (xb.share_type,
                                   3, NVL (xb.share_tsi_amt, 0),
                                   0
                                  ) facul_tsi,
                           DECODE (xb.share_type,
                                   2, NVL (xb.share_tsi_amt, 0),
                                   0
                                  ) treaty_tsi,
                           NVL (xb.share_prem_amt, 0) gross_prem_amt,
                           DECODE (xb.share_type,
                                   1, NVL (xb.share_prem_amt, 0),
                                   0
                                  ) net_ret_prem,
                           DECODE (xb.share_type,
                                   3, NVL (xb.share_prem_amt, 0),
                                   0
                                  ) facul_prem,
                           DECODE (xb.share_type,
                                   2, NVL (xb.share_prem_amt, 0),
                                   0
                                  ) treaty_prem
                      FROM TABLE
                              (csv_uw_genstat_rep.get_gipir037_recdtl
                                                             (p_as_of_sw,
                                                              p_expired_as_of,
                                                              p_starting_date,
                                                              p_ending_date,
                                                              p_zone_type,
                                                              p_user
                                                             )
                              ) xb) ab
          GROUP BY ab.zone_no, ab.zone_grp, ab.division
          ORDER BY ab.zone_no, ab.zone_grp)
      LOOP
         v_list.start_date := v_period_start;
         v_list.end_date := v_period_end;
         v_list.as_of_date := v_expired_as_of;
         v_list.zone_type := v_zone_type;
         v_list.zone_no := i.zone_no;
         v_list.division := i.division;
         v_list.gross_tsi_amt := i.gross_tsi_amt;
         v_list.gross_prem_amt := i.gross_prem_amt;
         v_list.net_ret_tsi_amt := i.net_ret_tsi_amt;
         v_list.net_ret_prem_amt := i.net_ret_prem_amt;
         v_list.facul_tsi_amt := i.facul_tsi_amt;
         v_list.facul_prem_amt := i.facul_prem_amt;
         v_list.treaty_tsi_amt := i.treaty_tsi_amt;
         v_list.treaty_prem_amt := i.treaty_prem_amt;
         PIPE ROW (v_list);
      END LOOP;
   END csv_gipir037;

   FUNCTION csv_gipir037b (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir037b_type PIPELINED
   IS
      v_gipir037b        gipir037b_rec_type;
      v_period_start     DATE      := TO_DATE (p_starting_date, 'MM-DD-YYYY');
      v_period_end       DATE        := TO_DATE (p_ending_date, 'MM-DD-YYYY');
      v_expired_as_of    DATE      := TO_DATE (p_expired_as_of, 'MM-DD-YYYY');
      v_zone_type_desc   cg_ref_codes.rv_meaning%TYPE;
   BEGIN
      -- Zone desc
      BEGIN
         SELECT NVL (rv_meaning, ' ')
           INTO v_zone_type_desc
           FROM cg_ref_codes
          WHERE rv_low_value = p_zone_type
            AND UPPER (rv_domain) = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
            AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_zone_type_desc := NULL;
      END;

      FOR rec IN (SELECT   b.policy_no, b.dist_share_name,
                           get_assd_name (b.assd_no) assd_name, b.share_cd,
                           b.zone_type,
                           SUM (NVL (b.share_tsi_amt, 0)) share_tsi_amt,
                           SUM (NVL (b.share_prem_amt, 0)) share_prem_amt
                      FROM gipi_firestat_extract_dtl_vw b
                     WHERE 1 = 1
                       AND b.user_id = p_user
                       AND b.as_of_sw = p_as_of_sw
                       AND b.zone_type = p_zone_type
                       AND (   (    p_as_of_sw = 'Y'
                                AND b.as_of_date = v_expired_as_of
                               )
                            OR (    p_as_of_sw = 'N'
                                AND TRUNC (b.date_from) =
                                                        TRUNC (v_period_start)
                                AND TRUNC (b.date_to) = TRUNC (v_period_end)
                               )
                           )
                  GROUP BY b.policy_no,
                           b.line_cd,
                           b.subline_cd,
                           b.iss_cd,
                           b.issue_yy,
                           b.pol_seq_no,
                           b.renew_no,
                           b.dist_share_name,
                           b.assd_no,
                           get_assd_name (b.assd_no),
                           b.share_cd,
                           b.zone_type
                  ORDER BY b.dist_share_name,
                           get_assd_name (b.assd_no),
                           b.line_cd,
                           b.subline_cd,
                           b.iss_cd,
                           b.issue_yy,
                           b.pol_seq_no,
                           b.renew_no)
      LOOP
         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir037b.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir037b.period := p_starting_date || ' TO ' || p_ending_date;
         END IF;

         v_gipir037b.zone_desc := v_zone_type_desc;
         v_gipir037b.distribution_share_name := rec.dist_share_name;
         v_gipir037b.assured_name := rec.assd_name;
         v_gipir037b.policy_no := rec.policy_no;
         v_gipir037b.share_tsi_amt := rec.share_tsi_amt;
         v_gipir037b.share_prem_amt := rec.share_prem_amt;
         PIPE ROW (v_gipir037b);
      END LOOP;

      RETURN;
   END csv_gipir037b;

   FUNCTION csv_gipir037c (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir037c_type PIPELINED
   IS
      v_gipir037c       gipir037c_rec_type;
      v_period_start    DATE       := TO_DATE (p_starting_date, 'MM-DD-YYYY');
      v_period_end      DATE         := TO_DATE (p_ending_date, 'MM-DD-YYYY');
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM-DD-YYYY');
   BEGIN
      FOR rec IN (SELECT   TRIM (c.assd_name) assd_name,
                           SUM (NVL (a.share_tsi_amt, 0)) tsi_amt,
                           SUM (NVL (a.share_prem_amt, 0)) prem_amt,
                           a.tarf_cd, a.policy_no, b.tarf_desc
                      FROM gipi_firestat_extract_dtl_vw a,
                           giis_tariff b,
                           giis_assured c
                     WHERE a.tarf_cd = b.tarf_cd
                       AND a.assd_no = c.assd_no
                       AND a.as_of_sw = p_as_of_sw
                       AND a.user_id = p_user
                       AND a.zone_type = p_zone_type
                       AND (   (    p_as_of_sw = 'Y'
                                AND a.as_of_date = v_expired_as_of
                               )
                            OR (    p_as_of_sw = 'N'
                                AND TRUNC (a.date_from) =
                                                        TRUNC (v_period_start)
                                AND TRUNC (a.date_to) = TRUNC (v_period_end)
                               )
                           )
                  GROUP BY TRIM (c.assd_name),
                           b.tarf_desc,
                           a.tarf_cd,
                           a.policy_no,
                           a.line_cd,
                           a.subline_cd,
                           a.iss_cd,
                           a.issue_yy,
                           a.pol_seq_no,
                           a.renew_no
                    HAVING SUM (NVL (a.share_tsi_amt, 0)) <> 0
                        OR SUM (NVL (a.share_prem_amt, 0)) <> 0
                  ORDER BY a.tarf_cd,
                           TRIM (c.assd_name),
                           a.line_cd,
                           a.subline_cd,
                           a.iss_cd,
                           a.issue_yy,
                           a.pol_seq_no,
                           a.renew_no)
      LOOP
         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir037c.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir037c.period := p_starting_date || ' TO ' || p_ending_date;
         END IF;

         -- Zone desc
         BEGIN
            SELECT NVL (rv_meaning, ' ')
              INTO v_gipir037c.zone_desc
              FROM cg_ref_codes
             WHERE rv_low_value = p_zone_type
               AND UPPER (rv_domain) = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir037c.zone_desc := NULL;
         END;

         v_gipir037c.tariff_cd := rec.tarf_cd;
         v_gipir037c.tariff_desc := rec.tarf_desc;
         v_gipir037c.policy_no := rec.policy_no;
         v_gipir037c.assured_name := rec.assd_name;
         v_gipir037c.share_tsi_amt := rec.tsi_amt;
         v_gipir037c.share_prem_amt := rec.prem_amt;
         PIPE ROW (v_gipir037c);
      END LOOP;

      RETURN;
   END csv_gipir037c;

   FUNCTION csv_gipir038a (
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir038_type PIPELINED
   IS
      v_gipir038a       gipir038_rec_type;
      v_period_start    DATE        := TO_DATE (p_period_start, 'MM-DD-YYYY');
      v_period_end      DATE          := TO_DATE (p_period_end, 'MM-DD-YYYY');
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM-DD-YYYY');
   BEGIN
      FOR rec IN (SELECT   tariff_zone, SUM (NVL (tsi_amt, 0)) tsi_amt,
                           SUM (NVL (prem_amt, 0)) prem_amt
                      FROM gixx_firestat_summary
                     WHERE peril_cd IN (SELECT peril_cd
                                          FROM giis_peril
                                         WHERE zone_type = p_zone_type)
                       AND user_id = p_user
                       AND as_of_sw = p_as_of_sw
                       AND DECODE (p_as_of_sw,
                                   'Y', TRUNC (as_of_date),
                                   TRUNC (SYSDATE)
                                  ) =
                              DECODE (p_as_of_sw,
                                      'Y', TRUNC (v_expired_as_of),
                                      TRUNC (SYSDATE)
                                     )
                       AND DECODE (p_as_of_sw,
                                   'N', TRUNC (date_from),
                                   TRUNC (SYSDATE)
                                  ) =
                              DECODE (p_as_of_sw,
                                      'N', TRUNC (v_period_start),
                                      TRUNC (SYSDATE)
                                     )
                       AND DECODE (p_as_of_sw,
                                   'N', TRUNC (date_to),
                                   TRUNC (SYSDATE)
                                  ) =
                              DECODE (p_as_of_sw,
                                      'N', TRUNC (v_period_end),
                                      TRUNC (SYSDATE)
                                     )
                  GROUP BY tariff_zone
                  ORDER BY tariff_zone)
      LOOP
         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir038a.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir038a.period := p_period_start || ' TO ' || p_period_end;
         END IF;

         -- Tariff Interpretation
         IF rec.tariff_zone IS NULL
         THEN
            v_gipir038a.tariff_interpretation := NULL;
         ELSE
            v_gipir038a.tariff_interpretation :=
                                           '(Zone ' || rec.tariff_zone || ')';
         END IF;

         -- Number of Policies
         BEGIN
            SELECT COUNT (*)
              INTO v_gipir038a.policy_cnt
              FROM (SELECT DISTINCT line_cd, subline_cd, iss_cd, issue_yy,
                                    pol_seq_no, renew_no
                               FROM gixx_firestat_summary
                              WHERE NVL (tariff_zone, 'x') =
                                                    NVL (rec.tariff_zone, 'x')
                                AND peril_cd IN (
                                                 SELECT peril_cd
                                                   FROM giis_peril
                                                  WHERE zone_type =
                                                                   p_zone_type)
                                AND user_id = p_user
                                AND as_of_sw = p_as_of_sw
                                AND DECODE (p_as_of_sw,
                                            'Y', TRUNC (as_of_date),
                                            TRUNC (SYSDATE)
                                           ) =
                                       DECODE (p_as_of_sw,
                                               'Y', TRUNC (v_expired_as_of),
                                               TRUNC (SYSDATE)
                                              )
                                AND DECODE (p_as_of_sw,
                                            'N', TRUNC (date_from),
                                            TRUNC (SYSDATE)
                                           ) =
                                       DECODE (p_as_of_sw,
                                               'N', TRUNC (v_period_start),
                                               TRUNC (SYSDATE)
                                              )
                                AND DECODE (p_as_of_sw,
                                            'N', TRUNC (date_to),
                                            TRUNC (SYSDATE)
                                           ) =
                                       DECODE (p_as_of_sw,
                                               'N', TRUNC (v_period_end),
                                               TRUNC (SYSDATE)
                                              )
                                AND (tsi_amt <> 0 OR prem_amt != 0));
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir038a.policy_cnt := NULL;
         END;

         -- Aggregate Sum Insured
         v_gipir038a.aggr_sum_insured := rec.tsi_amt;
         -- Aggregate Premium Written
         v_gipir038a.aggr_prem_amt := rec.prem_amt;
         PIPE ROW (v_gipir038a);
      END LOOP;

      RETURN;
   END csv_gipir038a;

   FUNCTION csv_gipir038b (
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir038_type PIPELINED
   IS
      v_gipir038b       gipir038_rec_type;
      v_period_start    DATE        := TO_DATE (p_period_start, 'MM-DD-YYYY');
      v_period_end      DATE          := TO_DATE (p_period_end, 'MM-DD-YYYY');
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM-DD-YYYY');
   BEGIN
      FOR rec IN
         (SELECT   tarf_cd,
                   COUNT (DISTINCT line_cd
                           || '-'
                           || subline_cd
                           || '-'
                           || iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (issue_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (pol_seq_no, '0000009'))
                           || '-'
                           || LTRIM (TO_CHAR (renew_no, '09'))
                         ) policy_cnt,
                   SUM (NVL (tsi_amt, 0)) tsi_amt,
                   SUM (NVL (prem_amt, 0)) prem_amt
              FROM gixx_firestat_summary
             WHERE peril_cd IN (
                      SELECT peril_cd
                        FROM giis_peril
                       WHERE zone_type = p_zone_type
                             AND zone_type IS NOT NULL)
               AND user_id = p_user
               AND as_of_sw = p_as_of_sw
               AND DECODE (p_as_of_sw,
                           'Y', TRUNC (as_of_date),
                           TRUNC (SYSDATE)
                          ) =
                      DECODE (p_as_of_sw,
                              'Y', TRUNC (v_expired_as_of),
                              TRUNC (SYSDATE)
                             )
               AND DECODE (p_as_of_sw,
                           'N', TRUNC (date_from),
                           TRUNC (SYSDATE)
                          ) =
                      DECODE (p_as_of_sw,
                              'N', TRUNC (v_period_start),
                              TRUNC (SYSDATE)
                             )
               AND DECODE (p_as_of_sw, 'N', TRUNC (date_to), TRUNC (SYSDATE)) =
                      DECODE (p_as_of_sw,
                              'N', TRUNC (v_period_end),
                              TRUNC (SYSDATE)
                             )
          GROUP BY tarf_cd
          ORDER BY tarf_cd)
      LOOP
         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir038b.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir038b.period := p_period_start || ' TO ' || p_period_end;
         END IF;

         -- Zone desc
         BEGIN
            SELECT NVL (rv_meaning, ' ')
              INTO v_gipir038b.eq_zone_type_desc
              FROM cg_ref_codes
             WHERE rv_low_value = p_zone_type
               AND UPPER (rv_domain) = 'GIPI_FIRESTAT_EXTRACT.EQ_ZONE_TYPE'
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir038b.eq_zone_type_desc := NULL;
         END;

         -- Tariff Interpretation
         v_gipir038b.tariff_interpretation := rec.tarf_cd;
         -- Policy Count
         v_gipir038b.policy_cnt := rec.policy_cnt;
         --Aggregate TSI - Prem
         v_gipir038b.aggr_sum_insured := rec.tsi_amt;
         v_gipir038b.aggr_prem_amt := rec.prem_amt;
         PIPE ROW (v_gipir038b);
      END LOOP;

      RETURN;
   END csv_gipir038b;

   FUNCTION csv_gipir038c (
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir038_type PIPELINED
   IS
      v_gipir038c              gipir038_rec_type;
      v_period_start           DATE := TO_DATE (p_period_start, 'MM-DD-YYYY');
      v_period_end             DATE   := TO_DATE (p_period_end, 'MM-DD-YYYY');
      v_expired_as_of          DATE
                                   := TO_DATE (p_expired_as_of, 'MM-DD-YYYY');
      v_zone_type              cg_ref_codes.rv_meaning%TYPE;
      v_fire_zone_type         cg_ref_codes.rv_low_value%TYPE;
      v_earthquake_zone_type   cg_ref_codes.rv_low_value%TYPE;
   BEGIN
      FOR cgref IN (SELECT TRIM (rv_low_value) zone_type,
                           UPPER (rv_meaning) zone_type_desc
                      FROM cg_ref_codes
                     WHERE rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE')
      LOOP
         IF cgref.zone_type_desc = 'FIRE'
         THEN
            v_fire_zone_type := cgref.zone_type;
         ELSIF cgref.zone_type_desc = 'EARTHQUAKE'
         THEN
            v_earthquake_zone_type := cgref.zone_type;
         END IF;

         IF cgref.zone_type = p_zone_type
         THEN
            v_zone_type := cgref.zone_type_desc;
         END IF;
      END LOOP;

      FOR rec1 IN
         (SELECT   1 priority, ab.eq_zone_type,
                   NVL (ac.rv_meaning,
                        'NO EARTHQUAKE ZONE TYPE'
                       ) eq_zone_type_desc,
                   DECODE (p_zone_type,
                           v_earthquake_zone_type, ab.tarf_cd,
                           v_fire_zone_type, ab.tarf_cd,
                              ab.tarf_cd
                           || ' (Zone '
                           || NVL (ab.zone_no, '0')
                           || ') '
                          ) tariff_interpretation,
                   SUM (DECODE (ab.share_tsi_amt, 0, 0, 1)) pol_count,
                   SUM (ab.share_tsi_amt) aggregate_tsi,
                   SUM (ab.share_prem_amt) aggregate_prem
              FROM (SELECT   x.line_cd, x.subline_cd, x.iss_cd, x.issue_yy,
                             x.pol_seq_no, x.renew_no, x.zone_no, x.tarf_cd,
                             SUM (NVL (x.share_tsi_amt, 0)) share_tsi_amt,
                             SUM (NVL (x.share_prem_amt, 0)) share_prem_amt,
                             x.eq_zone_type
                        FROM gipi_firestat_extract_dtl_vw x
                       WHERE 1 = 1
                         AND p_zone_type = v_earthquake_zone_type
                         AND x.zone_type = p_zone_type
                         AND x.as_of_sw = p_as_of_sw
                         AND x.user_id = p_user
                         AND (   (    p_as_of_sw = 'Y'
                                  AND x.as_of_date = v_expired_as_of
                                 )
                              OR (    p_as_of_sw = 'N'
                                  AND TRUNC (x.date_from) =
                                                        TRUNC (v_period_start)
                                  AND TRUNC (x.date_to) = TRUNC (v_period_end)
                                 )
                             )
                    GROUP BY x.line_cd,
                             x.subline_cd,
                             x.iss_cd,
                             x.issue_yy,
                             x.pol_seq_no,
                             x.renew_no,
                             x.tarf_cd,
                             x.zone_no,
                             x.eq_zone_type) ab,
                   cg_ref_codes ac
             WHERE ab.eq_zone_type = ac.rv_low_value(+)
               AND rv_domain(+) = 'GIPI_FIRESTAT_EXTRACT.EQ_ZONE_TYPE'
          GROUP BY ab.eq_zone_type,
                   ac.rv_meaning,
                   DECODE (p_zone_type,
                           v_earthquake_zone_type, ab.tarf_cd,
                           v_fire_zone_type, ab.tarf_cd,
                              ab.tarf_cd
                           || ' (Zone '
                           || NVL (ab.zone_no, '0')
                           || ') '
                          )
          UNION
          SELECT   1 priority, '' eq_zone_type, '' eq_zone_type_desc,
                   DECODE (p_zone_type,
                           v_earthquake_zone_type, ab.tarf_cd,
                           v_fire_zone_type, ab.tarf_cd,
                              ab.tarf_cd
                           || ' (Zone '
                           || NVL (ab.zone_no, '0')
                           || ') '
                          ) tariff_interpretation,
                   SUM (DECODE (ab.share_tsi_amt, 0, 0, 1)) pol_count,
                   SUM (ab.share_tsi_amt) aggregate_tsi,
                   SUM (ab.share_prem_amt) aggregate_prem
              FROM (SELECT   x.line_cd, x.subline_cd, x.iss_cd, x.issue_yy,
                             x.pol_seq_no, x.renew_no, x.zone_no, x.tarf_cd,
                             SUM (NVL (x.share_tsi_amt, 0)) share_tsi_amt,
                             SUM (NVL (x.share_prem_amt, 0)) share_prem_amt,
                             NULL eq_zone_type
                        FROM gipi_firestat_extract_dtl_vw x
                       WHERE 1 = 1
                         AND p_zone_type <> v_earthquake_zone_type
                         AND x.zone_type = p_zone_type
                         AND x.as_of_sw = p_as_of_sw
                         AND x.user_id = p_user
                         AND (   (    p_as_of_sw = 'Y'
                                  AND x.as_of_date = v_expired_as_of
                                 )
                              OR (    p_as_of_sw = 'N'
                                  AND TRUNC (x.date_from) =
                                                        TRUNC (v_period_start)
                                  AND TRUNC (x.date_to) = TRUNC (v_period_end)
                                 )
                             )
                    GROUP BY x.line_cd,
                             x.subline_cd,
                             x.iss_cd,
                             x.issue_yy,
                             x.pol_seq_no,
                             x.renew_no,
                             x.tarf_cd,
                             x.zone_no,
                             x.eq_zone_type) ab
          GROUP BY ab.eq_zone_type,
                   DECODE (p_zone_type,
                           v_earthquake_zone_type, ab.tarf_cd,
                           v_fire_zone_type, ab.tarf_cd,
                              ab.tarf_cd
                           || ' (Zone '
                           || NVL (ab.zone_no, '0')
                           || ') '
                          )
          UNION
          SELECT   2 priority, '' eq_zone_type, '' eq_zone_type_desc,
                   y.tarf_cd tariff_interpretation, 0 pol_count,
                   0 aggregate_tsi, 0 aggregate_prem
              FROM giis_tariff y
             WHERE p_zone_type <> v_earthquake_zone_type
               AND NOT EXISTS (
                      SELECT 1
                        FROM gipi_firestat_extract_dtl t
                       WHERE t.zone_type = p_zone_type
                         AND t.user_id = p_user
                         AND t.as_of_sw = p_as_of_sw
                         AND (   (    p_as_of_sw = 'Y'
                                  AND t.as_of_date = v_expired_as_of
                                 )
                              OR (    p_as_of_sw = 'N'
                                  AND TRUNC (t.date_from) =
                                                        TRUNC (v_period_start)
                                  AND TRUNC (t.date_to) = TRUNC (v_period_end)
                                 )
                             )
                         AND NVL (t.tarf_cd, '') = NVL (y.tarf_cd, ''))
          UNION
          SELECT   2 priority, rv_low_value eq_zone_type,
                   r.rv_meaning eq_zone_type_desc,
                   s.tarf_cd tariff_interpretation, 0 pol_count,
                   0 aggregate_tsi, 0 aggregate_prem
              FROM cg_ref_codes r, giis_tariff s
             WHERE p_zone_type = v_earthquake_zone_type
               AND r.rv_domain = 'GIPI_FIRESTAT_EXTRACT.EQ_ZONE_TYPE'
               AND NOT EXISTS (
                      SELECT 1
                        FROM gipi_firestat_extract_dtl t
                       WHERE t.zone_type = p_zone_type
                         AND t.user_id = p_user
                         AND t.as_of_sw = p_as_of_sw
                         AND (   (    p_as_of_sw = 'Y'
                                  AND t.as_of_date = v_expired_as_of
                                 )
                              OR (    p_as_of_sw = 'N'
                                  AND TRUNC (t.date_from) =
                                                        TRUNC (v_period_start)
                                  AND TRUNC (t.date_to) = TRUNC (v_period_end)
                                 )
                             )
                         AND NVL (t.tarf_cd, '') = NVL (s.tarf_cd, '')
                         AND t.eq_zone_type = r.rv_low_value)
          ORDER BY priority,
                   eq_zone_type,
                   eq_zone_type_desc,
                   pol_count,
                   aggregate_tsi,
                   tariff_interpretation)
      LOOP
         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir038c.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir038c.period := p_period_start || ' TO ' || p_period_end;
         END IF;

         v_gipir038c.zone_type := v_zone_type;
         v_gipir038c.eq_zone_type := rec1.eq_zone_type;
         v_gipir038c.tariff_interpretation := rec1.tariff_interpretation;
         v_gipir038c.eq_zone_type_desc := rec1.eq_zone_type_desc;
         v_gipir038c.policy_cnt := rec1.pol_count;
         v_gipir038c.aggr_sum_insured := rec1.aggregate_tsi;
         v_gipir038c.aggr_prem_amt := rec1.aggregate_prem;
         PIPE ROW (v_gipir038c);
      END LOOP;

      RETURN;
   END csv_gipir038c;

   FUNCTION get_gipir038c_dynsql (
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED
   IS
      v_dyn_query       csv_dynamicsql;
      v_query           LONG           := '';
      v_is_earthquake   VARCHAR2 (1)   := 'N';
   BEGIN
      FOR cgref IN (SELECT TRIM (rv_low_value) zone_type,
                           UPPER (rv_meaning) zone_type_desc
                      FROM cg_ref_codes
                     WHERE rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE')
      LOOP
         IF     cgref.zone_type = p_zone_type
            AND cgref.zone_type_desc = 'EARTHQUAKE'
         THEN
            v_is_earthquake := 'Y';
         END IF;
      END LOOP;

      v_query := 'SELECT period, zone_type,  ';

      IF v_is_earthquake = 'Y'
      THEN
         v_query := v_query || ' eq_zone_type_desc,  ';
      END IF;

      v_query :=
            v_query
         || ' tariff_interpretation,  policy_cnt, aggr_sum_insured, aggr_prem_amt ';

      IF p_period_start IS NOT NULL
      THEN
         v_query :=
               v_query
            || ' FROM TABLE (csv_uw_genstat_rep.csv_gipir038c ('''
            || p_period_start
            || ''', '''
            || p_period_end
            || ''' , ''';
      ELSE
         v_query :=
               v_query
            || ' FROM TABLE (csv_uw_genstat_rep.csv_gipir038c (NULL , NULL , ''';
      END IF;

      v_query :=
               v_query || UPPER (p_user) || ''' , ''' || p_as_of_sw
               || ''', ''';

      IF p_expired_as_of IS NOT NULL
      THEN
         v_query :=
               v_query
            || p_zone_type
            || ''', '''
            || p_expired_as_of
            || ''' ) ) ORDER BY ';
      ELSE
         v_query := v_query || p_zone_type || ''', NULL ) ) ORDER BY ';
      END IF;

      IF v_is_earthquake = 'Y'
      THEN
         v_query := v_query || ' eq_zone_type, eq_zone_type_desc,  ';
      END IF;

      v_query := v_query || ' tariff_interpretation ';
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
   END get_gipir038c_dynsql;

   FUNCTION csv_gipir039a (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_risk_cnt        VARCHAR2 
   )
      RETURN gipir039a_type PIPELINED
   IS
      v_gipir039a       gipir039a_rec_type;
      v_period_start    DATE       := TO_DATE (p_starting_date, 'MM-DD-YYYY');
      v_period_end      DATE         := TO_DATE (p_ending_date, 'MM-DD-YYYY');
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM-DD-YYYY');
      v_period          VARCHAR2 (100)                 := '';
      v_zone_type       cg_ref_codes.rv_meaning%TYPE   := '';
   BEGIN
      IF p_as_of_sw = 'Y'
      THEN
         v_period := 'As of ' || p_expired_as_of;
      ELSE
         v_period := p_starting_date || ' TO ' || p_ending_date;
      END IF;

      FOR cg IN (SELECT rv_meaning
                   FROM cg_ref_codes
                  WHERE rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
                    AND rv_low_value = p_zone_type)
      LOOP
         v_zone_type := cg.rv_meaning;
         EXIT;
      END LOOP;

      FOR rec IN
         (SELECT   tx001.zone_no, tx001.zone_grp_desc zone_group,
                   tx001.policy_no, SUM (tx001.share_tsi_amt) total_share_tsi,
                   SUM (tx001.share_prem_amt) total_share_premium,
                   SUM (tx001.bldg_exposure) bldg_sum_insured,
                   SUM (tx001.bldg_premium) bldg_premium,
                   SUM (tx001.contents_exposure) contents_sum_insured,
                   SUM (tx001.contents_premium) contents_premium,
                   SUM (tx001.lossprofit_exposure) lossprofit_sum_insured,
                   SUM (tx001.lossprofit_premium) lossprofit_premium,
                   SUM (DECODE (tx001.share_tsi_amt, 0, 0, 1)
                       ) total_risk_count,
                   SUM
                      (DECODE (tx001.fi_item_grp,
                               'C', DECODE (tx001.share_tsi_amt, 0, 0, 1),
                               0
                              )
                      ) contents_risk_count,
                   SUM (DECODE (tx001.fi_item_grp,
                                'B', DECODE (tx001.share_tsi_amt, 0, 0, 1),
                                0
                               )
                       ) bldg_risk_count,
                   SUM
                      (DECODE (tx001.fi_item_grp,
                               'L', DECODE (tx001.share_tsi_amt, 0, 0, 1),
                               0
                              )
                      ) lossprofit_risk_count
              FROM (SELECT   DECODE (x.zone_no,
                                     NULL, '0',
                                     x.zone_no
                                    ) zone_no, x.zone_grp,
                             DECODE (x.zone_grp,
                                     NULL, 'NO ZONE GROUP',
                                     x.zone_grp_desc
                                    ) zone_grp_desc,
                             x.item_no risk_item, x.fi_item_grp,
                             SUM (NVL (x.share_tsi_amt, 0)) share_tsi_amt,
                             SUM (NVL (x.share_prem_amt, 0)) share_prem_amt,
                             x.policy_no, x.line_cd, x.subline_cd, x.iss_cd,
                             x.issue_yy, x.pol_seq_no, x.renew_no,
                             SUM
                                (DECODE (x.fi_item_grp,
                                         'B', NVL (x.share_tsi_amt, 0),
                                         0
                                        )
                                ) bldg_exposure,
                             SUM
                                (DECODE (x.fi_item_grp,
                                         'B', NVL (x.share_prem_amt, 0),
                                         0
                                        )
                                ) bldg_premium,
                             SUM
                                (DECODE (x.fi_item_grp,
                                         'C', NVL (x.share_tsi_amt, 0),
                                         0
                                        )
                                ) contents_exposure,
                             SUM
                                (DECODE (x.fi_item_grp,
                                         'C', NVL (x.share_prem_amt, 0),
                                         0
                                        )
                                ) contents_premium,
                             SUM
                                (DECODE (x.fi_item_grp,
                                         'L', NVL (x.share_tsi_amt, 0),
                                         0
                                        )
                                ) lossprofit_exposure,
                             SUM
                                (DECODE (x.fi_item_grp,
                                         'L', NVL (x.share_prem_amt, 0),
                                         0
                                        )
                                ) lossprofit_premium
                        FROM gipi_firestat_extract_dtl_vw x
                       WHERE 1 = 1
                         AND x.user_id = p_user_id
                         AND x.as_of_sw = p_as_of_sw
                         AND x.zone_type = p_zone_type
                         AND x.fi_item_grp IS NOT NULL
                         AND (   (    x.as_of_sw = 'Y'
                                  AND TRUNC (x.as_of_date) =
                                         TRUNC (NVL (v_expired_as_of,
                                                     x.as_of_date
                                                    )
                                               )
                                 )
                              OR (    x.as_of_sw = 'N'
                                  AND TRUNC (x.date_from) =
                                         TRUNC (NVL (v_period_start,
                                                     x.date_from
                                                    )
                                               )
                                  AND TRUNC (x.date_to) =
                                         TRUNC (NVL (v_period_end, x.date_to))
                                 )
                             )
                    GROUP BY x.zone_grp,
                             x.zone_no,
                             x.zone_grp_desc,
                             x.item_no,
                             x.fi_item_grp,
                             x.policy_no,
                             x.line_cd,
                             x.subline_cd,
                             x.iss_cd,
                             x.issue_yy,
                             x.pol_seq_no,
                             x.renew_no
                      HAVING SUM (NVL (x.share_tsi_amt, 0)) <> 0
                          OR SUM (NVL (x.share_prem_amt, 0)) <> 0) tx001
          GROUP BY tx001.zone_no,
                   tx001.zone_grp_desc,
                   tx001.policy_no,
                   tx001.line_cd,
                   tx001.subline_cd,
                   tx001.iss_cd,
                   tx001.issue_yy,
                   tx001.pol_seq_no,
                   tx001.renew_no)
      LOOP
         v_gipir039a.period := v_period;
         v_gipir039a.zone_type := v_zone_type;
         v_gipir039a.zone_grp := rec.zone_group;
         v_gipir039a.zone_no := rec.zone_no;
         v_gipir039a.policy_no := rec.policy_no;
         v_gipir039a.bldg_tsi := rec.bldg_sum_insured;
         v_gipir039a.bldg_prem_amt := rec.bldg_premium;
         v_gipir039a.content_tsi := rec.contents_sum_insured;
         v_gipir039a.content_prem_amt := rec.contents_premium;
         v_gipir039a.loss_tsi := rec.lossprofit_sum_insured;
         v_gipir039a.loss_prem_amt := rec.lossprofit_premium;
         v_gipir039a.total_risk_cnt := rec.total_risk_count;
         v_gipir039a.contents_risk_cnt := rec.contents_risk_count;
         v_gipir039a.bldg_risk_cnt := rec.bldg_risk_count;
         v_gipir039a.lossprofit_risk_cnt := rec.lossprofit_risk_count;
         -- Total (Insured Amount - Premium Amount)
         v_gipir039a.total_tsi := rec.total_share_tsi;
         v_gipir039a.total_prem := rec.total_share_premium;
         PIPE ROW (v_gipir039a);
      END LOOP;

      RETURN;
   END csv_gipir039a;

   FUNCTION csv_gipir039d (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_table           VARCHAR2,
      p_column          VARCHAR2,
      p_by_count        VARCHAR2
   )
      RETURN gipir039d_type PIPELINED
   IS
      TYPE ref_cursor IS REF CURSOR;

      v_gipir039d        gipir039d_rec_type;
      cur1               ref_cursor;
      cur2               ref_cursor;
      cur3               ref_cursor;
      v_query1           VARCHAR (5000);
      v_query2           VARCHAR (5000);
      v_query3           VARCHAR (5000);
      -- query 1
      v_zone_no1         VARCHAR2 (10);
      v_occ_cd1          VARCHAR2 (3);
      v_occupancy1       VARCHAR2 (2000);
      v_per_cnt1         NUMBER;
      --query2
      v_zone_no2         VARCHAR2 (10);
      v_occ_cd2          VARCHAR2 (3);
      v_occupancy2       VARCHAR2 (2000);
      v_per_cnt2         NUMBER;
      v_fi_itm_grp       VARCHAR2 (1);
      v_tot_tsi2         NUMBER (16, 2);
      v_tot_prem2        NUMBER (16, 2);
      --query3
      v_zone_no3         VARCHAR2 (10);
      v_occ_cd3          VARCHAR2 (3);
      v_occupancy3       VARCHAR2 (2000);
      v_per_cnt3         NUMBER;
      v_desc             VARCHAR (30);
      v_tot_tsi3         NUMBER (16, 2);
      v_tot_prem3        NUMBER (16, 2);
      -- amt
      v_bldg_exposure    NUMBER (16, 2)     := NULL;
      v_bldg_prem        NUMBER (16, 2)     := NULL;
      v_cont_exposure    NUMBER (16, 2)     := NULL;
      v_cont_prem        NUMBER (16, 2)     := NULL;
      v_loss_exposure    NUMBER (16, 2)     := NULL;
      v_loss_prem        NUMBER (16, 2)     := NULL;
      v_ret_exposure     NUMBER (16, 2)     := NULL;
      v_ret_prem         NUMBER (16, 2)     := NULL;
      v_trty_exposure    NUMBER (16, 2)     := NULL;
      v_trty_prem        NUMBER (16, 2)     := NULL;
      v_facul_exposure   NUMBER (16, 2)     := NULL;
      v_facul_prem       NUMBER (16, 2)     := NULL;
   BEGIN
      v_query1 :=
            'SELECT a.zone_no, a.occupancy_cd
                            , decode(a.occupancy_cd,null,''UNKNOWN'', d.occupancy_desc) occupancy
                            , decode('''
         || p_by_count
         || ''', ''R'', COUNT(DISTINCT(c.block_id||NVL(c.risk_cd,''*''))), COUNT(DISTINCT c.item_no)) per_cnt
                        FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || p_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d
                            WHERE a.zone_no = b.'
         || p_column
         || '
                                AND A.zone_type = '''
         || p_zone_type
         || '''
                                AND A.as_of_sw = '''
         || p_as_of_sw
         || '''
                                AND a.fi_item_grp IS NOT NULL
                                AND main.policy_id = a.policy_id
                                AND a.policy_id = c.policy_id
                                AND a.item_no = c.item_no
                                AND a.occupancy_cd = d.occupancy_cd(+)
                                AND a.user_id = '''
         || p_user
         || '''
                            GROUP BY a.zone_no, a.occupancy_cd, d.occupancy_desc
                            ORDER BY a.zone_no, d.occupancy_desc';

      OPEN cur1 FOR v_query1;

      LOOP
         FETCH cur1
          INTO v_zone_no1, v_occ_cd1, v_occupancy1, v_per_cnt1;

         EXIT WHEN cur1%NOTFOUND;

         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir039d.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir039d.period := p_starting_date || ' TO ' || p_ending_date;
         END IF;

         -- Zone No, Occupancy, Count
         v_gipir039d.zone_no := v_zone_no1;
         v_gipir039d.occupancy := v_occupancy1;
         v_gipir039d.risk := v_per_cnt1;
         v_query2 :=
               'SELECT a.zone_no, a.occupancy_cd
                                            , decode(a.occupancy_cd,null,''UNKNOWN'', d.occupancy_desc) occupancy
                                            , decode('''
            || p_by_count
            || ''', ''R'', COUNT(DISTINCT(c.block_id||NVL(c.risk_cd,''*''))), COUNT(DISTINCT c.item_no)) per_cnt
                                            , a.fi_item_grp, SUM(a.share_tsi_amt) total_tsi, SUM(a.share_prem_amt) total_prem
                                        FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
            || p_table
            || ' b,  gipi_fireitem c, giis_fire_occupancy d
                                    WHERE a.zone_no = b. '
            || p_column
            || '
                                        AND A.zone_type = '''
            || p_zone_type
            || '''
                                        AND A.as_of_sw = '''
            || p_as_of_sw
            || '''
                                        AND a.fi_item_grp IS NOT NULL
                                        AND main.policy_id = a.policy_id
                                        AND a.policy_id = c.policy_id
                                        AND a.item_no = c.item_no
                                        AND a.occupancy_cd = d.occupancy_cd(+)
                                        AND a.user_id = '''
            || p_user
            || '''
                                        AND a.zone_no = '''
            || v_zone_no1
            || '''
                                        AND NVL(a.occupancy_cd, ''x'') = '''
            || NVL (v_occ_cd1, 'x')
            || '''
                                    GROUP BY a.zone_no, a.occupancy_cd, a.fi_item_grp, d.occupancy_desc
                                    ORDER BY a.zone_no, d.occupancy_desc';

         OPEN cur2 FOR v_query2;

         LOOP
            FETCH cur2
             INTO v_zone_no2, v_occ_cd2, v_occupancy2, v_per_cnt2,
                  v_fi_itm_grp, v_tot_tsi2, v_tot_prem2;

            EXIT WHEN cur2%NOTFOUND;

            IF v_fi_itm_grp = 'B'
            THEN
               v_bldg_exposure :=
                                NVL (v_bldg_exposure, 0)
                                + NVL (v_tot_tsi2, 0);
               v_bldg_prem := NVL (v_bldg_prem, 0) + NVL (v_tot_prem2, 0);
            ELSIF v_fi_itm_grp = 'C'
            THEN
               v_cont_exposure :=
                                NVL (v_cont_exposure, 0)
                                + NVL (v_tot_tsi2, 0);
               v_cont_prem := NVL (v_cont_prem, 0) + NVL (v_tot_prem2, 0);
            ELSIF v_fi_itm_grp = 'L'
            THEN
               v_loss_exposure :=
                                NVL (v_loss_exposure, 0)
                                + NVL (v_tot_tsi2, 0);
               v_loss_prem := NVL (v_loss_prem, 0) + NVL (v_tot_prem2, 0);
            END IF;
         END LOOP;

         CLOSE cur2;

         -- Building Exposure and Premium - Content Exposure and Premium - Loss Exposure and Content Prem - Gross Exposure and Premium
         v_gipir039d.bldg_exposure := v_bldg_exposure;
         v_gipir039d.bldg_prem := v_bldg_prem;
         v_gipir039d.content_exposure := v_cont_exposure;
         v_gipir039d.content_prem := v_cont_prem;
         v_gipir039d.loss_exposure := v_loss_exposure;
         v_gipir039d.loss_prem := v_loss_prem;
         v_gipir039d.gross_exposure :=
              NVL (v_bldg_exposure, 0)
            + NVL (v_cont_exposure, 0)
            + NVL (v_loss_exposure, 0);
         v_gipir039d.gross_prem :=
              NVL (v_bldg_prem, 0) + NVL (v_cont_prem, 0)
              + NVL (v_loss_prem, 0);
         -- reset variables
         v_bldg_exposure := NULL;
         v_bldg_prem := NULL;
         v_cont_exposure := NULL;
         v_cont_prem := NULL;
         v_loss_exposure := NULL;
         v_loss_prem := NULL;
         v_query3 :=
               'SELECT a.zone_no, a.occupancy_cd
                                        , DECODE(a.occupancy_cd,null,''UNKNOWN'', d.occupancy_desc) occupancy
                                        , DECODE('''
            || p_by_count
            || ''', ''R'', COUNT(DISTINCT(c.block_id||NVL(c.risk_cd,''*''))), COUNT(DISTINCT c.item_no)) per_cnt
                                        , DECODE(a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'') description
                                        , SUM(a.share_tsi_amt) total_tsi
                                        , SUM(a.share_prem_amt) total_prem
                                    FROM gipi_polbasic main, gipi_firestat_extract_dtl a
                                        , '
            || p_table
            || ' b,  gipi_fireitem c, giis_fire_occupancy d
                                        , giis_dist_share e
                                    WHERE a.zone_no = b. '
            || p_column
            || '
                                        AND A.zone_type = '''
            || p_zone_type
            || '''
                                        AND A.as_of_sw = '''
            || p_as_of_sw
            || '''
                                        AND a.fi_item_grp IS NOT NULL
                                        AND main.policy_id = a.policy_id
                                        AND a.policy_id = c.policy_id
                                        AND a.item_no = c.item_no
                                        AND a.occupancy_cd = d.occupancy_cd(+)
                                        AND a.share_Cd = e.share_Cd
                                        AND main.line_cd = e.line_Cd
                                        AND a.user_id = '''
            || p_user
            || '''
                                        AND a.zone_no = '''
            || v_zone_no1
            || '''
                                        AND a.occupancy_cd = '''
            || v_occ_cd1
            || '''
                                    GROUP BY a.zone_no, a.occupancy_cd, d.occupancy_desc
                                        , DECODE(a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'')
                                    ORDER BY a.zone_no, d.occupancy_desc';

         OPEN cur3 FOR v_query3;

         LOOP
            FETCH cur3
             INTO v_zone_no3, v_occ_cd3, v_occupancy3, v_per_cnt3, v_desc,
                  v_tot_tsi3, v_tot_prem3;

            EXIT WHEN cur3%NOTFOUND;

            -- Net Retemtion, Treaty, Facultative Exposure and Premium
            IF v_desc = 'RETENTION'
            THEN
               v_ret_exposure := v_tot_tsi3;
               v_ret_prem := v_tot_prem3;
            ELSIF v_desc = 'FACULTATIVE'
            THEN
               v_facul_exposure := v_tot_tsi3;
               v_facul_prem := v_tot_prem3;
            ELSIF v_desc = 'TREATY'
            THEN
               v_trty_exposure := v_tot_tsi3;
               v_trty_prem := v_tot_prem3;
            END IF;
         END LOOP;

         CLOSE cur3;

         v_gipir039d.ret_exposure := v_ret_exposure;
         v_gipir039d.ret_prem := v_ret_prem;
         v_gipir039d.facul_exposure := v_facul_exposure;
         v_gipir039d.facul_prem := v_facul_prem;
         v_gipir039d.treaty_exposure := v_trty_exposure;
         v_gipir039d.treaty_prem := v_trty_prem;
         -- reset variables
         v_ret_exposure := NULL;
         v_ret_prem := NULL;
         v_facul_exposure := NULL;
         v_facul_prem := NULL;
         v_trty_exposure := NULL;
         v_trty_prem := NULL;
         PIPE ROW (v_gipir039d);
      END LOOP;

      CLOSE cur1;

      RETURN;
   END csv_gipir039d;

   FUNCTION get_gipir039d_dynsql (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_risk_cnt        VARCHAR2
   )
      --RETURN csv_dynamicsql_tab PIPELINED --Commented out by Jerome Bautista SR 21338 02.04.2016
      RETURN dynamic_csv_rec_tab PIPELINED --Added by Jerome Bautista SR 21338 02.04.2016
   IS
      v                      dynamic_csv_rec_type; --Added by Jerome Bautista SR 21338 02.03.2016
      v_query                VARCHAR2(32000); --Modified by Jerome Bautista SR 21338 02.03.2016
      v_query2               VARCHAR2(32000); --Added by Jerome Bautista SR 21338 02.03.2016
      v_dyn_query            csv_dynamicsql;
      v_expired_as_of        DATE  := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start         DATE  := TO_DATE (p_starting_date, 'MM/DD/YYYY');
      v_period_end           DATE    := TO_DATE (p_ending_date, 'MM/DD/YYYY');
      v_dist_share_tsi_nm    VARCHAR2 (30);
      v_dist_share_prem_nm   VARCHAR2 (30);
      v_target_trty_name     giis_dist_share.trty_name%TYPE;
      v_cur                  sys_refcursor; --Added by Jerome Bautista SR 21338 02.03.2016
   BEGIN
      v.rec := 'ZONE_NO,ZONE_GRP,OCC_CD,RISK_CNT,BLDG_EXPOSURE,BLDG_PREMIUM,CONTENTS_EXPOSURE,CONTENTS_PREMIUM,LOSSPROFIT_EXPOSURE,LOSSPROFIT_PREMIUM,TOTAL_SHARE_TSI,TOTAL_SHARE_PREM_AMT,'; -- Added by Jerome Bautista SR 21338 02.04.2016
      v_query :=
            ' SELECT   tb.zone_no||'',''|| tb.zone_grp||'',''|| tb.occupancy_desc||'',''|| '
         || ' SUM (tb.risk_cnt)||'',''|| SUM (tb.bldg_exposure) ||'',''|| '
         || '  SUM (tb.bldg_premium)||'',''||  SUM (tb.contents_exposure)||'',''|| '
         || ' SUM (tb.contents_premium)||'',''|| SUM (tb.lossprofit_exposure)||'',''|| '
         || ' SUM (tb.lossprofit_premium)||'',''|| SUM (tb.total_share_tsi)||'',''|| '
         || ' SUM (tb.total_share_prem_amt)  '; --Modified by Jerome Bautista SR 21338 02.03.2016

      FOR curdist IN (SELECT DISTINCT x.share_type, x.share_cd,
                                      x.dist_share_name
                                 FROM gipi_firestat_extract_dtl_vw x
                                WHERE x.user_id = p_user_id
                                  AND x.zone_type = p_zone_type
                                  AND x.as_of_sw = p_as_of_sw
                                  AND (   (    x.as_of_sw = 'Y'
                                           AND TRUNC (x.as_of_date) =
                                                  TRUNC (NVL (v_expired_as_of,
                                                              x.as_of_date
                                                             )
                                                        )
                                          )
                                       OR (    x.as_of_sw = 'N'
                                           AND TRUNC (x.date_from) =
                                                  TRUNC (NVL (v_period_start,
                                                              x.date_from
                                                             )
                                                        )
                                           AND TRUNC (x.date_to) =
                                                  TRUNC (NVL (v_period_end,
                                                              x.date_to
                                                             )
                                                        )
                                          )
                                      )
                                  AND (   NVL (x.share_tsi_amt, 0) <> 0
                                       OR NVL (x.share_prem_amt, 0) <> 0
                                      )
                             ORDER BY x.share_type, x.share_cd)
      LOOP
         v_target_trty_name := curdist.dist_share_name;
         v_dist_share_tsi_nm := v_target_trty_name;

         IF LENGTH (v_dist_share_tsi_nm) <= 26
         THEN
            v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
         ELSIF LENGTH (v_dist_share_tsi_nm) > 30
         THEN
            v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
         END IF;

         v_query :=
               v_query
            || '||'',''|| SUM (tb."'
            || v_dist_share_tsi_nm
            || '")'; --Modified by Jerome Bautista SR 21338 02.03.2016
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
            || ' ||'',''|| SUM (tb."'
            || v_dist_share_prem_nm
            || '")'; --Modified by Jerome Bautista SR 21338 02.03.2016
      END LOOP;

      v_query :=
            v_query
         || '  FROM (SELECT   ab.zone_no, ab.zone_grp, ab.occupancy_desc, '
         || ' ab.occupancy_cd, ab.line_cd, ab.subline_cd, ab.iss_cd, '
         || ' ab.issue_yy, ab.pol_seq_no, ab.renew_no, ab.risk_item, ab.fi_item_grp, ab.share_cd,' --added fi_item_grp and share_cd : edgar 05/22/2015 SR 4328
         || ' DECODE (SUM (ab.share_tsi_amt), 0, 0, 1) risk_cnt, '
         || ' SUM (ab.bldg_exposure) bldg_exposure, '
         || ' SUM (ab.bldg_premium) bldg_premium, '
         || ' SUM (ab.contents_exposure) contents_exposure, '
         || ' SUM (ab.contents_premium) contents_premium, '
         || ' SUM (ab.lossprofit_exposure) lossprofit_exposure, '
         || ' SUM (ab.lossprofit_premium) lossprofit_premium ';

      FOR curdist IN (SELECT DISTINCT x.share_type, x.share_cd,
                                      x.dist_share_name
                                 FROM gipi_firestat_extract_dtl_vw x
                                WHERE x.user_id = p_user_id
                                  AND x.zone_type = p_zone_type
                                  AND x.as_of_sw = p_as_of_sw
                                  AND (   (    x.as_of_sw = 'Y'
                                           AND TRUNC (x.as_of_date) =
                                                  TRUNC (NVL (v_expired_as_of,
                                                              x.as_of_date
                                                             )
                                                        )
                                          )
                                       OR (    x.as_of_sw = 'N'
                                           AND TRUNC (x.date_from) =
                                                  TRUNC (NVL (v_period_start,
                                                              x.date_from
                                                             )
                                                        )
                                           AND TRUNC (x.date_to) =
                                                  TRUNC (NVL (v_period_end,
                                                              x.date_to
                                                             )
                                                        )
                                          )
                                      )
                                  AND (   NVL (x.share_tsi_amt, 0) <> 0
                                       OR NVL (x.share_prem_amt, 0) <> 0
                                      )
                             ORDER BY x.share_type, x.share_cd)
      LOOP
         v_target_trty_name := curdist.dist_share_name;
         v_dist_share_tsi_nm := v_target_trty_name;

         IF LENGTH (v_dist_share_tsi_nm) <= 26
         THEN
            v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
         ELSIF LENGTH (v_dist_share_tsi_nm) > 30
         THEN
            v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
         END IF;

         v_query :=
               v_query
            || ' , SUM (ab."'
            || v_dist_share_tsi_nm
            || '") AS "'
            || v_dist_share_tsi_nm
            || '"  ';
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
            || ' , SUM (ab."'
            || v_dist_share_prem_nm
            || '") AS "'
            || v_dist_share_prem_nm
            || '"  ';
      END LOOP;

      v_query :=
            v_query
         || '    ,  SUM (ab.share_tsi_amt) total_share_tsi, '
         || ' SUM (ab.share_prem_amt) total_share_prem_amt '
         || '  FROM (SELECT NVL(x.zone_no,0) zone_no, x.zone_grp, DECODE(p.occupancy_desc, NULL, ''NO OCCUPANCY'', p.occupancy_desc) occupancy_desc, '--modified for null values : edgar 05/22/2015 SR 4328
         || ' DECODE ('''
         || p_risk_cnt
         || ''', '
         || '''P'', TO_CHAR (x.item_no),  ''R'', x.block_id || ''-''  || NVL (x.risk_cd, ''@@@@@@@''),  ''''   ) risk_item, '
         || '  NVL (x.share_tsi_amt, 0) share_tsi_amt, NVL (x.share_prem_amt, 0) share_prem_amt, '
         || '  x.occupancy_cd, x.line_cd, x.subline_cd, x.iss_cd,  x.issue_yy, x.pol_seq_no, x.renew_no, x.fi_item_grp, x.share_cd,' --added share_cd : edgar 05/22/2015 SR 4328
         || '  DECODE (x.fi_item_grp, ''B'', NVL (x.share_tsi_amt, 0),  0   ) bldg_exposure, '
         || ' DECODE (x.fi_item_grp,  ''B'', NVL (x.share_prem_amt, 0),  0   ) bldg_premium, '
         || ' DECODE (x.fi_item_grp, ''C'', NVL (x.share_tsi_amt, 0),   0  ) contents_exposure, '
         || ' DECODE (x.fi_item_grp, ''C'', NVL (x.share_prem_amt, 0), 0  ) contents_premium, '
         || ' DECODE (x.fi_item_grp,  ''L'', NVL (x.share_tsi_amt, 0),    0  ) lossprofit_exposure, '
         || ' DECODE (x.fi_item_grp,  ''L'', NVL (x.share_prem_amt, 0), 0   ) lossprofit_premium  ';

      FOR curdist IN (SELECT DISTINCT x.share_type, x.share_cd,
                                      x.dist_share_name
                                 FROM gipi_firestat_extract_dtl_vw x
                                WHERE x.user_id = p_user_id
                                  AND x.zone_type = p_zone_type
                                  AND x.as_of_sw = p_as_of_sw
                                  AND (   (    x.as_of_sw = 'Y'
                                           AND TRUNC (x.as_of_date) =
                                                  TRUNC (NVL (v_expired_as_of,
                                                              x.as_of_date
                                                             )
                                                        )
                                          )
                                       OR (    x.as_of_sw = 'N'
                                           AND TRUNC (x.date_from) =
                                                  TRUNC (NVL (v_period_start,
                                                              x.date_from
                                                             )
                                                        )
                                           AND TRUNC (x.date_to) =
                                                  TRUNC (NVL (v_period_end,
                                                              x.date_to
                                                             )
                                                        )
                                          )
                                      )
                                  AND (   NVL (x.share_tsi_amt, 0) <> 0
                                       OR NVL (x.share_prem_amt, 0) <> 0
                                      )
                             ORDER BY x.share_type, x.share_cd)
      LOOP
         v_target_trty_name := curdist.dist_share_name;
         v_dist_share_tsi_nm := v_target_trty_name;

         IF LENGTH (v_dist_share_tsi_nm) <= 26
         THEN
            v_dist_share_tsi_nm := v_dist_share_tsi_nm || '-TSI';
         ELSIF LENGTH (v_dist_share_tsi_nm) > 30
         THEN
            v_dist_share_tsi_nm := SUBSTR (v_dist_share_tsi_nm, 1, 30);
         END IF;

         v_query :=
               v_query
            || ' , DECODE  (x.share_cd, '
            || curdist.share_cd
            || ' , NVL (x.share_tsi_amt, 0),  0   ) AS "'
            || v_dist_share_tsi_nm
            || '"  ';
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
            || '  , DECODE  (x.share_cd, '
            || curdist.share_cd
            || ' , NVL (x.share_prem_amt, 0),  0   ) AS "'
            || v_dist_share_prem_nm
            || '"  ';
            
           v.rec := v.rec || v_dist_share_tsi_nm || ',' || v_dist_share_prem_nm || ','; --Added by Jerome Bautista SR 21338 02.03.2016;
      END LOOP;

      v.rec := SUBSTR(v.rec,0,LENGTH(v.rec)-1); --Added by Jerome Bautista SR 21338 02.03.2016
      PIPE ROW(v); --Added by Jerome Bautista SR 21338 02.03.2016
      
      v_query :=
            v_query
         || '  FROM gipi_firestat_extract_dtl_vw x,  giis_fire_occupancy p '
         || ' WHERE 1 = 1  AND x.occupancy_cd = p.occupancy_cd(+)  AND x.user_id = '''
         || p_user_id
         || ''' '
         || ' AND x.as_of_sw = '''
         || p_as_of_sw
         || ''' AND x.zone_type = '''
         || p_zone_type
         || ''' '
         || ' AND (   (    x.as_of_sw = ''Y''  AND TRUNC (x.as_of_date) =  TRUNC (NVL (TO_DATE ('''
         || p_expired_as_of
         || ''' , ''MM/DD/YYYY''), x.as_of_date)) '
         || '      )   OR (    x.as_of_sw = ''N''  AND TRUNC (x.date_from) = TRUNC (NVL (TO_DATE ( '''
         || p_starting_date
         || ''', ''MM/DD/YYYY''), x.date_from)) '
         || '         AND TRUNC (x.date_to) =   TRUNC (NVL (TO_DATE ('''
         || p_ending_date
         || ''', ''MM/DD/YYYY''), x.date_to))    )      ) '
         || '  AND (   NVL (x.share_tsi_amt, 0) <> 0   OR NVL (x.share_prem_amt, 0) <> 0  )) ab  '
         || '  GROUP BY ab.zone_no,    ab.zone_grp,  ab.occupancy_cd,  ab.occupancy_desc,   ab.fi_item_grp, ab.share_cd, ab.line_cd,   ab.subline_cd,  ab.iss_cd,   ab.issue_yy, ab.pol_seq_no,' --added fi_item_grp and share_cd : edgar 05/22/2015 SR 4328
         || ' ab.renew_no,  ab.risk_item) tb  GROUP BY tb.zone_no, tb.zone_grp, tb.occupancy_desc ';
      -- return the query
      v_dyn_query.query1 := SUBSTR (v_query, 1, 4000);
      v_dyn_query.query2 := SUBSTR (v_query, 4001, 8000);
      v_dyn_query.query3 := SUBSTR (v_query, 8001, 12000);
      v_dyn_query.query4 := SUBSTR (v_query, 12001, 16000);
      v_dyn_query.query5 := SUBSTR (v_query, 16001, 20000);
      v_dyn_query.query6 := SUBSTR (v_query, 20001, 24000);
      v_dyn_query.query7 := SUBSTR (v_query, 24001, 28000);
      v_dyn_query.query8 := SUBSTR (v_query, 28001, 32000);
      
      v_query2 := v_dyn_query.query1 || v_dyn_query.query2 || v_dyn_query.query3 || v_dyn_query.query4 || v_dyn_query.query5 || v_dyn_query.query6 || v_dyn_query.query7 || v_dyn_query.query8; --Added by Jerome Bautista SR 21338 02.03.2016

       OPEN v_cur FOR v_query2; --Added by Jerome Bautista SR 21338 02.03.2016
        LOOP
           FETCH v_cur
           INTO v.rec;
           
           EXIT WHEN v_cur%NOTFOUND;
           PIPE ROW(v);
        END LOOP;
      --PIPE ROW (v_dyn_query);
   END get_gipir039d_dynsql;

   FUNCTION csv_gipir039e (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user_id         VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_print_sw        VARCHAR2,
      p_trty_type_cd    VARCHAR2,
      p_risk_cnt        VARCHAR2
   )
      RETURN gipir039e_type PIPELINED
   IS
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start    DATE       := TO_DATE (p_starting_date, 'MM/DD/YYYY');
      v_period_end      DATE         := TO_DATE (p_ending_date, 'MM/DD/YYYY');
      v_period          VARCHAR (2000);
      v_zone_type       cg_ref_codes.rv_meaning%TYPE;
      v_gipir039e       gipir039e_rec_type;
   BEGIN
      IF p_as_of_sw = 'Y'
      THEN
         v_period := 'As of ' || p_expired_as_of;
      ELSE
         v_period := p_starting_date || ' TO ' || p_ending_date;
      END IF;

      FOR cgref IN (SELECT TRIM (rv_low_value) zone_type,
                           UPPER (rv_meaning) zone_type_desc
                      FROM cg_ref_codes
                     WHERE rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
                       AND rv_low_value = p_zone_type)
      LOOP
         v_zone_type := cgref.zone_type_desc;
         EXIT;
      END LOOP;

      FOR cur IN
         (SELECT   NVL (outerq.zone_no, '0') zone_no,
                   DECODE (outerq.zone_grp,
                           NULL, 'NO ZONE GROUP',
                           outerq.zone_grp_desc
                          ) zone_grp,
                   outerq.policy_no, SUM (outerq.bldg_risk_cnt) bldg_risk_cnt,
                   SUM (outerq.contents_risk_cnt) contents_risk_cnt,
                   SUM (outerq.loss_risk_cnt) loss_risk_cnt,
                   SUM (outerq.bldg_exposure) bldg_exposure,
                   SUM (outerq.contents_exposure) contents_exposure,
                   SUM (outerq.loss_exposure) loss_exposure,
                   SUM (outerq.bldg_premium) bldg_premium,
                   SUM (outerq.contents_premium) contents_premium,
                   SUM (outerq.loss_premium) loss_premium, --outerq.occupancy, --comment out : edgar 05/22/2015 SR 4328
                   outerq.distribution_shr_name
              FROM (SELECT   ab.zone_no, ab.zone_grp, ab.policy_no,
                             ab.line_cd, ab.subline_cd, ab.iss_cd,
                             ab.issue_yy, ab.pol_seq_no, ab.renew_no,
                             ab.risk_item, ab.zone_grp_desc, --ab.occupancy, --comment out : edgar 05/22/2015 SR 4328
                             DECODE (SUM (ab.bldg_exposure),
                                     0, 0,
                                     1
                                    ) bldg_risk_cnt,
                             DECODE
                                (SUM (ab.contents_exposure),
                                 0, 0,
                                 1
                                ) contents_risk_cnt,
                             DECODE (SUM (ab.loss_exposure),--modified : edgar 05/22/2015 SR 4328
                                     0, 0,
                                     1
                                    ) loss_risk_cnt,
                             SUM (ab.share_tsi_amt) total_share_tsi,
                             SUM (ab.share_prem_amt) total_share_prem_amt,
                             SUM (ab.bldg_exposure) bldg_exposure,
                             SUM (ab.contents_exposure) contents_exposure,
                             SUM (ab.loss_exposure) loss_exposure,
                             SUM (ab.bldg_premium) bldg_premium,
                             SUM (ab.contents_premium) contents_premium,
                             SUM (ab.loss_premium) loss_premium,
                             ab.distribution_shr_name
                        FROM (SELECT x.zone_no, x.zone_grp, x.policy_no,
                                     x.zone_grp_desc,
                                     DECODE (p_risk_cnt,
                                             'P', TO_CHAR (x.item_no),
                                             'R', x.block_id
                                              || '-'
                                              || NVL (x.risk_cd, '@@@@@@@'),
                                             ''
                                            ) risk_item,
                                     NVL (x.share_tsi_amt, 0) share_tsi_amt,
                                     NVL (x.share_prem_amt, 0) share_prem_amt,
                                     x.occupancy_cd, x.line_cd, x.subline_cd,
                                     x.iss_cd, x.issue_yy, x.pol_seq_no,
                                     x.renew_no,
                                     DECODE
                                        (x.fi_item_grp,
                                         'B', NVL (x.share_tsi_amt, 0),
                                         0
                                        ) bldg_exposure,
                                     DECODE
                                        (x.fi_item_grp,
                                         'C', NVL (x.share_tsi_amt, 0),
                                         0
                                        ) contents_exposure,
                                     DECODE
                                        (x.fi_item_grp,
                                         'L', NVL (x.share_tsi_amt, 0),
                                         0
                                        ) loss_exposure,
                                     DECODE
                                        (x.fi_item_grp,
                                         'B', NVL (x.share_prem_amt, 0),
                                         0
                                        ) bldg_premium,
                                     DECODE
                                        (x.fi_item_grp,
                                         'C', NVL (x.share_prem_amt, 0),
                                         0
                                        ) contents_premium,
                                     DECODE
                                        (x.fi_item_grp,
                                         'L', NVL (x.share_prem_amt, 0),
                                         0
                                        ) loss_premium,
                                     DECODE
                                        (x.share_type,
                                         '1', 'NET RETENTION',
                                         '3', 'FACULTATIVE',
                                         x.acct_trty_type_lname
                                        ) distribution_shr_name/*, --comment out : edgar 05/22/2015 SR 4328
                                     DECODE (x.occupancy_cd,
                                             'NULL', 'NO OCCUPANCY',
                                             x.occupancy_desc
                                            ) occupancy*/ --comment out : edgar 05/22/2015 SR 4328
                                FROM gipi_firestat_extract_dtl_vw x
                               WHERE x.user_id = p_user_id
                                 AND x.as_of_sw = p_as_of_sw
                                 AND x.zone_type = p_zone_type
                                 AND x.fi_item_grp IS NOT NULL --added condition : edgar 05/22/2015 SR 4328
                                 AND (   (    x.as_of_sw = 'Y'
                                          AND TRUNC (x.as_of_date) =
                                                 TRUNC (NVL (v_expired_as_of,
                                                             x.as_of_date
                                                            )
                                                       )
                                         )
                                      OR (    x.as_of_sw = 'N'
                                          AND TRUNC (x.date_from) =
                                                 TRUNC (NVL (v_period_start,
                                                             x.date_from
                                                            )
                                                       )
                                          AND TRUNC (x.date_to) =
                                                 TRUNC (NVL (v_period_end,
                                                             x.date_to
                                                            )
                                                       )
                                         )
                                     )
                                 AND (   (    p_print_sw = 'F'
                                          AND x.share_type = '3'
                                         )
                                      OR (    p_print_sw = 'R'
                                          AND x.share_type = '1'
                                         )
                                      OR (    p_print_sw = 'T'
                                          AND x.share_type = '2'
                                          AND x.acct_trty_type =
                                                                p_trty_type_cd
                                         )
                                     )
                                 AND (   NVL (x.share_tsi_amt, 0) <> 0
                                      OR NVL (x.share_prem_amt, 0) <> 0
                                     )) ab
                    GROUP BY ab.zone_no,
                             ab.zone_grp,
                             ab.zone_grp_desc,
                             ab.policy_no,
                             ab.line_cd,
                             ab.subline_cd,
                             ab.iss_cd,
                             ab.issue_yy,
                             ab.pol_seq_no,
                             ab.renew_no,
                             ab.risk_item,
                             ab.distribution_shr_name,
                             ab.line_cd,
                             ab.subline_cd,
                             ab.iss_cd,
                             ab.issue_yy,
                             ab.pol_seq_no,
                             ab.renew_no/*,--comment out occupancy : edgar 05/22/2015 SR 4328
                             ab.occupancy*/) outerq
          GROUP BY outerq.zone_no,
                   outerq.zone_grp,
                   --outerq.occupancy, --comment out : edgar 05/22/2015 SR 4328
                   outerq.zone_grp_desc,
                   outerq.policy_no,
                   outerq.line_cd,
                   outerq.subline_cd,
                   outerq.iss_cd,
                   outerq.issue_yy,
                   outerq.pol_seq_no,
                   outerq.renew_no,
                   outerq.distribution_shr_name)
      LOOP
         v_gipir039e.period := v_period;
         v_gipir039e.zone_type := v_zone_type;
         v_gipir039e.zone_no := cur.zone_no;
         v_gipir039e.zone_grp := cur.zone_grp;
         --v_gipir039e.occupancy := cur.occupancy; --comment out : edgar 05/22/2015 SR 4328
         v_gipir039e.policy_no := cur.policy_no;
         v_gipir039e.dist_grp_shr_name := cur.distribution_shr_name;
         v_gipir039e.bldg_risk_cnt := cur.bldg_risk_cnt;
         v_gipir039e.bldg_insured_amt := cur.bldg_exposure;
         v_gipir039e.bldg_premium := cur.bldg_premium;
         v_gipir039e.contents_risk_cnt := cur.contents_risk_cnt;
         v_gipir039e.contents_insured_amt := cur.contents_exposure;
         v_gipir039e.contents_premium := cur.contents_premium;
         v_gipir039e.loss_of_profit_risk_cnt := cur.loss_risk_cnt;
         v_gipir039e.loss_of_profit_tsi := cur.loss_exposure;
         v_gipir039e.loss_of_profit_premium := cur.loss_premium;
         v_gipir039e.total_sum_insured :=
                cur.bldg_exposure + cur.contents_exposure + cur.loss_exposure;
         v_gipir039e.total_premium :=
                   cur.bldg_premium + cur.contents_premium + cur.loss_premium;
         v_gipir039e.total_risk_cnt :=
                cur.bldg_risk_cnt + cur.contents_risk_cnt + cur.loss_risk_cnt;
         PIPE ROW (v_gipir039e);
      END LOOP;

      RETURN;
   END csv_gipir039e;

   FUNCTION csv_gipir039h (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir039h_tab PIPELINED
   IS
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start    DATE       := TO_DATE (p_starting_date, 'MM/DD/YYYY');
      v_period_end      DATE         := TO_DATE (p_ending_date, 'MM/DD/YYYY');
      v_gipir039h       gipir039h_rec_type;
      v_zone_type       cg_ref_codes.rv_meaning%TYPE;
   BEGIN
      FOR cg IN (SELECT rv_meaning
                   FROM cg_ref_codes
                  WHERE rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
                    AND rv_low_value = p_zone_type)
      LOOP
         v_zone_type := cg.rv_meaning;
         EXIT;
      END LOOP;

      FOR cur IN
         (SELECT   NVL (a.zone_no, '0') zone_no,
                   DECODE (a.zone_grp,
                           NULL, 'NO ZONE GROUP',
                           a.zone_grp_desc
                          ) zone_grp_desc,
                   NVL (b.occupancy_desc, 'NO OCCUPANCY') occupancy_desc,
                   a.policy_no, a.item_no, a.block_id, a.risk_cd,
                   a.dist_share_name,
                   SUM (DECODE (a.fi_item_grp,
                                'B', NVL (a.share_tsi_amt, 0),
                                0
                               )
                       ) building_sum_insured,
                   SUM
                      (DECODE (a.fi_item_grp,
                               'B', NVL (a.share_prem_amt, 0),
                               0
                              )
                      ) building_premium_amount,
                   SUM (DECODE (a.fi_item_grp,
                                'C', NVL (a.share_tsi_amt, 0),
                                0
                               )
                       ) contents_sum_insured,
                   SUM
                      (DECODE (a.fi_item_grp,
                               'C', NVL (a.share_prem_amt, 0),
                               0
                              )
                      ) contents_premium_amount,
                   SUM
                      (DECODE (a.fi_item_grp,
                               'L', NVL (a.share_tsi_amt, 0),
                               0
                              )
                      ) loss_of_profit_sum_insured,
                   SUM
                      (DECODE (a.fi_item_grp,
                               'L', NVL (a.share_prem_amt, 0),
                               0
                              )
                      ) loss_of_profit_prem_amount,
                   SUM (NVL (a.share_tsi_amt, 0)) total_sum_insured,
                   SUM (NVL (a.share_prem_amt, 0)) total_prem_amt
              FROM gipi_firestat_extract_dtl_vw a, giis_fire_occupancy b
             WHERE a.occupancy_cd = b.occupancy_cd(+)
               AND a.zone_type = p_zone_type
               AND a.as_of_sw = p_as_of_sw
               AND a.user_id = p_user
               AND (   (    a.as_of_sw = 'Y'
                        AND TRUNC (a.as_of_date) =
                                   TRUNC (NVL (v_expired_as_of, a.as_of_date))
                       )
                    OR (    a.as_of_sw = 'N'
                        AND TRUNC (a.date_from) =
                                     TRUNC (NVL (v_period_start, a.date_from))
                        AND TRUNC (a.date_to) =
                                         TRUNC (NVL (v_period_end, a.date_to))
                       )
                   )
          GROUP BY a.zone_grp,
                   a.zone_no,
                   a.zone_grp_desc,
                   b.occupancy_desc,
                   a.policy_no,
                   a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.issue_yy,
                   a.pol_seq_no,
                   a.renew_no,
                   a.share_type,
                   a.dist_share_name,
                   a.item_no,
                   a.block_id,
                   a.risk_cd
            HAVING SUM (NVL (a.share_tsi_amt, 0)) <> 0
                OR SUM (NVL (a.share_prem_amt, 0)) <> 0
          ORDER BY a.zone_grp,
                   a.zone_no,
                   b.occupancy_desc,
                   a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.issue_yy,
                   a.pol_seq_no,
                   a.renew_no,
                   a.policy_no,
                   a.item_no,
                   a.share_type,
                   a.dist_share_name)
      LOOP
         v_gipir039h.zone_type := v_zone_type;
         v_gipir039h.zone_no := cur.zone_no;
         v_gipir039h.zone_grp := cur.zone_grp_desc;
         v_gipir039h.occupancy := cur.occupancy_desc;
         v_gipir039h.policy_no := cur.policy_no;
         v_gipir039h.item_no := cur.item_no;
         v_gipir039h.block_id := cur.block_id;
         v_gipir039h.risk_cd := cur.risk_cd;
         v_gipir039h.dist_share_name := cur.dist_share_name;
         v_gipir039h.bldg_sum_insured := cur.building_sum_insured;
         v_gipir039h.bldg_premium_amt := cur.building_premium_amount;
         v_gipir039h.contents_sum_insured := cur.contents_sum_insured;
         v_gipir039h.contents_premium_amt := cur.contents_premium_amount;
         v_gipir039h.loss_of_profit_sum_insured :=
                                               cur.loss_of_profit_sum_insured;
         v_gipir039h.loss_of_profit_prem_amt :=
                                               cur.loss_of_profit_prem_amount;
         v_gipir039h.total_sum_insured := cur.total_sum_insured;
         v_gipir039h.total_premium_amt := cur.total_prem_amt;
         PIPE ROW (v_gipir039h);
      END LOOP;

      RETURN;
   END csv_gipir039h;
   FUNCTION escape_string (p_string VARCHAR2) --Added by Jerome Bautista SR 21338 02.04.2016
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN '"' || REPLACE (p_string, '"', '""') || '"';
   END;
END csv_uw_genstat_rep;
/

CREATE OR REPLACE PUBLIC SYNONYM csv_uw_genstat_rep FOR cpi.csv_uw_genstat_rep; -- edgar 05/22/2015 SR 4328

/