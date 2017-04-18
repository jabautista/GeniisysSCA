CREATE OR REPLACE PACKAGE BODY CPI.gipir037a_pkg
AS
   FUNCTION get_gipir037a_header_func (p_zonetype VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_zonetype = 1
      THEN
         RETURN ('FIRE STATISTICAL REPORT (FLOOD)');
      ELSIF p_zonetype = 2
      THEN
         RETURN ('FIRE STATISTICAL REPORT (TYPHOON)');
      ELSIF p_zonetype = 3
      THEN
         RETURN ('FIRE STATISTICAL REPORT (EARTHQUAKE)');
      ELSIF p_zonetype = 5
      THEN
         RETURN ('FIRE STATISTICAL REPORT (TYPHOON AND FLOOD)');
      ELSE
         RETURN ('FIRE STATISTICAL REPORT');
      END IF;
   END get_gipir037a_header_func;

   FUNCTION get_gipir037a_bus_cd (p_bus_cd NUMBER)
      RETURN CHAR
   IS
      v_business_cd   VARCHAR2 (100);
   BEGIN
      IF p_bus_cd = 1
      THEN
         v_business_cd := 'Direct Business Only';
      ELSIF p_bus_cd = 2
      THEN
         v_business_cd := 'Assumed Business Only';
      ELSIF p_bus_cd = 3
      THEN
         v_business_cd := 'Direct and Assumed Business';
      END IF;

      RETURN (v_business_cd);
   END get_gipir037a_bus_cd;

   FUNCTION get_gipir037a_zone_desc (p_zone_no VARCHAR2)
      RETURN CHAR
   IS
      v_flood_zone_desc   giis_flood_zone.flood_zone_desc%TYPE;
   BEGIN
      FOR a IN (SELECT flood_zone_desc
                  FROM giis_flood_zone
                 WHERE flood_zone = p_zone_no)
      LOOP
         v_flood_zone_desc := a.flood_zone_desc;
         RETURN (v_flood_zone_desc);
         EXIT;
      END LOOP;

      RETURN (v_flood_zone_desc);
   END get_gipir037a_zone_desc;

   FUNCTION get_gipir037a_zone_risk (
      p_zonetype   VARCHAR2,
      p_zone_no    VARCHAR2,
      p_as_of_sw   VARCHAR2,
      p_risk_cnt   VARCHAR2,                                --edgar 03/13/2015
      p_user       VARCHAR2                                 --edgar 03/13/2015
   )
      RETURN NUMBER
   IS
      v_zone_risk      NUMBER (10) := 0;
      v_risk_cnt       NUMBER      := 0;
      v_sum_tsi        NUMBER      := 0;
      v_risk_cnt_sum   NUMBER      := 0;
   BEGIN
      --FOR a IN (SELECT SUM (no_of_risk) total_risk
      --            FROM gipi_firestat_extract
      --           WHERE zone_type = p_zonetype
      --             AND zone_no = p_zone_no
      --             AND as_of_sw = NVL (p_as_of_sw, as_of_sw))
      --LOOP
      --   v_zone_risk := a.total_risk;
      --   RETURN (v_zone_risk);
      --   EXIT;
      --END LOOP; --commented out edgar 03/13/2015
      IF p_risk_cnt = 'R'
      THEN
         v_risk_cnt_sum := 0;

         FOR i IN (SELECT DISTINCT    a.line_cd
                                   || '-'
                                   || a.subline_cd
                                   || '-'
                                   || a.iss_cd
                                   || '-'
                                   || a.issue_yy
                                   || '-'
                                   || a.pol_seq_no
                                   || '-'
                                   || a.renew_no policy_no,
                                   a.line_cd, a.subline_cd, a.iss_cd,
                                   a.issue_yy, a.pol_seq_no, a.renew_no
                              FROM gipi_polbasic a,
                                   gipi_firestat_extract_dtl b
                             WHERE a.policy_id = b.policy_id
                               AND b.zone_type = p_zonetype
                               AND NVL (b.zone_no, 0) = NVL (p_zone_no, 0)
                               AND b.user_id = p_user
                               AND b.as_of_sw = NVL (p_as_of_sw, b.as_of_sw)
                          ORDER BY a.line_cd,
                                   a.subline_cd,
                                   a.iss_cd,
                                   a.issue_yy,
                                   a.pol_seq_no,
                                   a.renew_no)
         LOOP
            v_sum_tsi := 0;
            v_risk_cnt := 0;

            FOR b IN (SELECT DISTINCT policy_id
                                 FROM gipi_polbasic x
                                WHERE line_cd = i.line_cd
                                  AND subline_cd = i.subline_cd
                                  AND iss_cd = i.iss_cd
                                  AND issue_yy = i.issue_yy
                                  AND pol_seq_no = i.pol_seq_no
                                  AND renew_no = i.renew_no
                                  AND EXISTS (
                                              SELECT policy_id
                                                FROM gipi_firestat_extract_dtl y
                                               WHERE x.policy_id = y.policy_id))
            LOOP
               FOR c IN (SELECT COUNT (DISTINCT NVL (block_id, -999999)
                                        || '-'
                                        || NVL (risk_cd, '-999999')
                                      ) risk_no,
                                SUM (NVL (share_tsi_amt, 0)) sum_tsi
                           FROM gipi_firestat_extract_dtl
                          WHERE zone_type = p_zonetype
                            AND NVL (zone_no, 0) = NVL (p_zone_no, 0)
                            AND user_id = p_user
                            AND as_of_sw = NVL (p_as_of_sw, as_of_sw)
                            AND policy_id = b.policy_id)
               LOOP
                  v_risk_cnt := v_risk_cnt + c.risk_no;
                  v_sum_tsi := v_sum_tsi + c.sum_tsi;
               END LOOP;
            END LOOP;

            IF v_sum_tsi = 0
            THEN
               v_risk_cnt := 0;
            END IF;

            v_risk_cnt_sum := v_risk_cnt_sum + v_risk_cnt;
         END LOOP;

         v_zone_risk := v_risk_cnt_sum;
         RETURN (v_zone_risk);
      ELSE
         v_risk_cnt_sum := 0;

         FOR i IN (SELECT DISTINCT    a.line_cd
                                   || '-'
                                   || a.subline_cd
                                   || '-'
                                   || a.iss_cd
                                   || '-'
                                   || a.issue_yy
                                   || '-'
                                   || a.pol_seq_no
                                   || '-'
                                   || a.renew_no policy_no,
                                   a.line_cd, a.subline_cd, a.iss_cd,
                                   a.issue_yy, a.pol_seq_no, a.renew_no
                              FROM gipi_polbasic a,
                                   gipi_firestat_extract_dtl b
                             WHERE a.policy_id = b.policy_id
                               AND b.zone_type = p_zonetype
                               AND NVL (b.zone_no, 0) = NVL (p_zone_no, 0)
                               AND b.user_id = p_user
                               AND b.as_of_sw = NVL (p_as_of_sw, b.as_of_sw)
                          ORDER BY a.line_cd,
                                   a.subline_cd,
                                   a.iss_cd,
                                   a.issue_yy,
                                   a.pol_seq_no,
                                   a.renew_no)
         LOOP
            v_sum_tsi := 0;
            v_risk_cnt := 0;

            FOR b IN (SELECT DISTINCT policy_id
                                 FROM gipi_polbasic x
                                WHERE line_cd = i.line_cd
                                  AND subline_cd = i.subline_cd
                                  AND iss_cd = i.iss_cd
                                  AND issue_yy = i.issue_yy
                                  AND pol_seq_no = i.pol_seq_no
                                  AND renew_no = i.renew_no
                                  AND EXISTS (
                                              SELECT policy_id
                                                FROM gipi_firestat_extract_dtl y
                                               WHERE x.policy_id = y.policy_id))
            LOOP
               FOR c IN (SELECT COUNT (item_no) risk_no,
                                SUM (NVL (share_tsi_amt, 0)) sum_tsi
                           FROM gipi_firestat_extract_dtl
                          WHERE zone_type = p_zonetype
                            AND NVL (zone_no, 0) = NVL (p_zone_no, 0)
                            AND user_id = p_user
                            AND as_of_sw = NVL (p_as_of_sw, as_of_sw)
                            AND policy_id = b.policy_id)
               LOOP
                  v_risk_cnt := v_risk_cnt + c.risk_no;
                  v_sum_tsi := v_sum_tsi + c.sum_tsi;
               END LOOP;
            END LOOP;

            IF v_sum_tsi = 0
            THEN
               v_risk_cnt := 0;
            END IF;

            v_risk_cnt_sum := v_risk_cnt_sum + v_risk_cnt;
         END LOOP;

         v_zone_risk := v_risk_cnt_sum;
         RETURN (v_zone_risk);
      END IF;

      RETURN (v_zone_risk);
   END get_gipir037a_zone_risk;

   FUNCTION get_gipir037a_no_risks (
      p_zonetype     VARCHAR2,
      p_zone_class   VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_risk_cnt     VARCHAR2,                              --edgar 03/13/2015
      p_user         VARCHAR2                               --edgar 03/16/2015
   )
      RETURN NUMBER
   IS
      v_risks   NUMBER (12);
   BEGIN
      /*FOR a IN (SELECT SUM (no_of_risk) no_risk
                  FROM gipi_firestat_extract a,
                       (SELECT rv_meaning, flood_zone zone_no, '1' zone_type
                          FROM cg_ref_codes a, giis_flood_zone b
                         WHERE rv_domain = 'ZONE_GROUP'
                           AND rv_low_value = zone_grp
                        UNION ALL
                        SELECT rv_meaning, typhoon_zone zone_no,
                               '2' zone_type
                          FROM cg_ref_codes a, giis_typhoon_zone b
                         WHERE rv_domain = 'ZONE_GROUP'
                           AND rv_low_value = zone_grp
                        UNION ALL
                        SELECT rv_meaning, eq_zone zone_no, '3' zone_type
                          FROM cg_ref_codes a, giis_eqzone b
                         WHERE rv_domain = 'ZONE_GROUP'
                           AND rv_low_value = zone_grp) b
                 WHERE a.user_id = USER
                   AND a.zone_no = b.zone_no
                   AND a.zone_type = b.zone_type
                   AND b.rv_meaning = p_zone_class
                   AND a.zone_type = p_zonetype
                   AND a.as_of_sw = NVL (p_as_of_sw, a.as_of_sw))
      LOOP
         v_risks := a.no_risk;
      END LOOP;

      RETURN (v_risks);*/--commented out codes edgar 03/16/2015 replaced with codes below
      IF p_risk_cnt = 'R'
      THEN
         FOR a IN (SELECT   SUM (risk_no) no_risk, zone_class
                       FROM (SELECT   COUNT
                                         (DISTINCT NVL (a.block_id, -999999)
                                           || '-'
                                           || NVL (a.risk_cd, '-999999')
                                         ) risk_no,
                                      a.policy_id,
                                      NVL (b.rv_meaning,
                                           'NO ZONE') zone_class
                                 FROM gipi_firestat_extract_dtl a,
                                      (SELECT rv_meaning, flood_zone zone_no,
                                              '1' zone_type
                                         FROM cg_ref_codes a,
                                              giis_flood_zone b
                                        WHERE rv_domain = 'ZONE_GROUP'
                                          AND rv_low_value = zone_grp
                                       UNION ALL
                                       SELECT rv_meaning,
                                              typhoon_zone zone_no,
                                              '2' zone_type
                                         FROM cg_ref_codes a,
                                              giis_typhoon_zone b
                                        WHERE rv_domain = 'ZONE_GROUP'
                                          AND rv_low_value = zone_grp
                                       UNION ALL
                                       SELECT rv_meaning, eq_zone zone_no,
                                              '3' zone_type
                                         FROM cg_ref_codes a, giis_eqzone b
                                        WHERE rv_domain = 'ZONE_GROUP'
                                          AND rv_low_value = zone_grp) b
                                WHERE a.zone_type = p_zonetype
                                  AND NVL (a.zone_no, 0) = b.zone_no(+)
                                  AND a.zone_type = b.zone_type(+)
                                  AND a.user_id = p_user
                                  AND a.as_of_sw =
                                                  NVL (p_as_of_sw, a.as_of_sw)
                             GROUP BY a.policy_id, b.rv_meaning)
                      WHERE zone_class = p_zone_class
                   GROUP BY zone_class)
         LOOP
            v_risks := a.no_risk;
            RETURN (v_risks);
            EXIT;
         END LOOP;
      ELSE
         FOR a IN (SELECT   SUM (risk_no) no_risk, zone_class
                       FROM (SELECT   COUNT (a.item_no) risk_no, a.policy_id,
                                      NVL (b.rv_meaning,
                                           'NO ZONE') zone_class
                                 FROM gipi_firestat_extract_dtl a,
                                      (SELECT rv_meaning, flood_zone zone_no,
                                              '1' zone_type
                                         FROM cg_ref_codes a,
                                              giis_flood_zone b
                                        WHERE rv_domain = 'ZONE_GROUP'
                                          AND rv_low_value = zone_grp
                                       UNION ALL
                                       SELECT rv_meaning,
                                              typhoon_zone zone_no,
                                              '2' zone_type
                                         FROM cg_ref_codes a,
                                              giis_typhoon_zone b
                                        WHERE rv_domain = 'ZONE_GROUP'
                                          AND rv_low_value = zone_grp
                                       UNION ALL
                                       SELECT rv_meaning, eq_zone zone_no,
                                              '3' zone_type
                                         FROM cg_ref_codes a, giis_eqzone b
                                        WHERE rv_domain = 'ZONE_GROUP'
                                          AND rv_low_value = zone_grp) b
                                WHERE a.zone_type = p_zonetype
                                  AND NVL (a.zone_no, 0) = b.zone_no(+)
                                  AND a.zone_type = b.zone_type(+)
                                  AND user_id = p_user
                                  AND as_of_sw = NVL (p_as_of_sw, as_of_sw)
                             GROUP BY policy_id, b.rv_meaning)
                      WHERE zone_class = p_zone_class
                   GROUP BY zone_class)
         LOOP
            v_risks := a.no_risk;
            RETURN (v_risks);
            EXIT;
         END LOOP;
      END IF;

      RETURN (v_risks);
   END get_gipir037a_no_risks;

   FUNCTION get_gipir037a_e_zone_desc (p_zone_no1 VARCHAR2)
      RETURN CHAR
   IS
      v_zone_desc   giis_eqzone.eq_desc%TYPE;
   BEGIN
      FOR a IN (SELECT eq_desc
                  FROM giis_eqzone
                 WHERE eq_zone = p_zone_no1)
      LOOP
         v_zone_desc := a.eq_desc;
      END LOOP;

      RETURN (v_zone_desc);
   END get_gipir037a_e_zone_desc;

   FUNCTION get_gipir037a_e_zone_risk (p_zonetype VARCHAR2, p_zone_no1 VARCHAR2)
      RETURN NUMBER
   IS
      v_zone_risk   NUMBER (10) := 0;
   BEGIN
      FOR a IN (SELECT SUM (no_of_risk) total_risk
                  FROM gipi_firestat_extract
                 WHERE zone_type = p_zonetype
                   AND zone_no = p_zone_no1
                   AND TO_CHAR (extract_dt, 'MM-DD-YYYY') =
                                               TO_CHAR (SYSDATE, 'MM-DD-YYYY'))
      LOOP
         v_zone_risk := a.total_risk;
      END LOOP;

      RETURN (v_zone_risk);
   END get_gipir037a_e_zone_risk;

   FUNCTION get_gipir037a_record (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2                            --edgar 03/13/2015
   )
      RETURN gipir037a_tab PIPELINED
   IS
      v_list            gipir037a_type;
      v_not_exist       BOOLEAN        := TRUE;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start    DATE        := TO_DATE (p_period_start, 'MM/DD/YYYY');
      v_period_end      DATE          := TO_DATE (p_period_end, 'MM/DD/YYYY');
   BEGIN
      v_list.comp_name := giisp.v ('COMPANY_NAME');
      v_list.comp_add := giisp.v ('COMPANY_ADDRESS');
      v_list.header_func := get_gipir037a_header_func (p_zonetype);
      v_list.bus_cd := get_gipir037a_bus_cd (p_bus_cd);
      v_list.period_end :=
           TO_CHAR (TO_DATE (p_period_end, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');
      v_list.period_start :=
         TO_CHAR (TO_DATE (p_period_start, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');
      v_list.expired_as_of :=
         TO_CHAR (TO_DATE (p_expired_as_of, 'mm-dd-yyyy'),
                  'fmMonth DD, YYYY');

      FOR i IN (
                /*SELECT   b260.extract_dt,
                         DECODE
                              (b260.zone_type,
                               '1', 'FIRE STATISTICAL REPORT (FLOOD)',
                               '2', 'FIRE STATISTICAL REPORT (TYPHOON)',
                               '4', 'FIRE STATISTICAL REPORT',
                               '5', 'FIRE STATISTICAL REPORT (TYPHOON AND FLOOD)'
                              ) header,
                         b260.zone_no zone_no, b260.no_of_risk, b260.share_cd,
                         b260.share_tsi_amt, b260.share_prem_amt, a160.share_type,
                         a160.trty_name, c.rv_meaning zone_class
                    FROM gipi_firestat_extract b260,
                         giis_dist_share a160,
                         (SELECT rv_meaning, flood_zone zone_no, '1' zone_type
                            FROM cg_ref_codes a, giis_flood_zone b
                           WHERE rv_domain = 'ZONE_GROUP'
                                 AND rv_low_value = zone_grp
                          UNION
                          SELECT rv_meaning, typhoon_zone zone_no, '2' zone_type
                            FROM cg_ref_codes a, giis_typhoon_zone b
                           WHERE rv_domain = 'ZONE_GROUP'
                                 AND rv_low_value = zone_grp) c
                   WHERE a160.line_cd = 'FI'
                     AND a160.share_cd = b260.share_cd
                     AND b260.zone_type IN ('1', '2', '4', '5')
                     AND b260.zone_type = p_zonetype
                     AND b260.zone_no = c.zone_no(+)
                     AND b260.zone_type = c.zone_type(+)
                     AND b260.as_of_sw = p_as_of_sw
                     AND (       b260.as_of_sw = 'Y'
                             AND b260.as_of_date =
                                              NVL (v_expired_as_of, b260.as_of_date)
                          OR     b260.as_of_sw = 'N'
                             AND b260.date_from =
                                                NVL (v_period_start, b260.date_from)
                             AND b260.date_to = NVL (v_period_end, b260.date_to)
                         )
                     AND b260.user_id = p_user
                ORDER BY b260.extract_dt,
                         b260.zone_no,
                         b260.share_cd,
                         b260.no_of_risk,
                         a160.share_type,
                         a160.trty_name*/
                SELECT   b260.extract_dt,
                         DECODE (b260.zone_type,
                                 '1', 'FIRE STATISTICAL REPORT ('''
                                  || d.zone_desc
                                  || ''')',
                                 '2', 'FIRE STATISTICAL REPORT ('''
                                  || d.zone_desc
                                  || ''')',
                                 '4', 'FIRE STATISTICAL REPORT ('''
                                  || d.zone_desc
                                  || ''')',
                                 '5', 'FIRE STATISTICAL REPORT ('''
                                  || d.zone_desc
                                  || ''')'
                                ) header,
                         NVL (b260.zone_no, 0) zone_no, 0 no_of_risk,
                         b260.share_cd,
                         SUM (NVL (b260.share_tsi_amt, 0)) share_tsi_amt,
                         SUM (NVL (b260.share_prem_amt, 0)) share_prem_amt,
                         a160.share_type, a160.trty_name,
                         NVL (c.rv_meaning, 'NO ZONE') zone_class
                    FROM gipi_firestat_extract_dtl b260,
                         giis_dist_share a160,
                         (SELECT rv_meaning, flood_zone zone_no,
                                 '1' zone_type
                            FROM cg_ref_codes a, giis_flood_zone b
                           WHERE rv_domain = 'ZONE_GROUP'
                             AND rv_low_value = zone_grp
                          UNION
                          SELECT rv_meaning, typhoon_zone zone_no,
                                 '2' zone_type
                            FROM cg_ref_codes a, giis_typhoon_zone b
                           WHERE rv_domain = 'ZONE_GROUP'
                             AND rv_low_value = zone_grp) c,
                         (SELECT rv_low_value zone_type, rv_meaning zone_desc
                            FROM cg_ref_codes
                           WHERE rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE') d
                   WHERE a160.line_cd = b260.line_cd
                     AND a160.share_cd = b260.share_cd
                     AND b260.zone_type IN ('1', '2', '4', '5')
                     AND b260.zone_type = p_zonetype
                     AND b260.zone_no = c.zone_no(+)
                     AND b260.zone_type = c.zone_type(+)
                     AND b260.zone_type = d.zone_type
                     AND b260.as_of_sw = p_as_of_sw
                     AND (       b260.as_of_sw = 'Y'
                             AND TRUNC (b260.as_of_date) =
                                    TRUNC (NVL (v_expired_as_of,
                                                b260.as_of_date
                                               )
                                          )
                          OR     b260.as_of_sw = 'N'
                             AND TRUNC (b260.date_from) =
                                    TRUNC (NVL (v_period_start,
                                                b260.date_from)
                                          )
                             AND TRUNC (b260.date_to) =
                                      TRUNC (NVL (v_period_end, b260.date_to))
                         )
                     AND b260.user_id = p_user
                GROUP BY b260.extract_dt,
                         DECODE (b260.zone_type,
                                 '1', 'FIRE STATISTICAL REPORT ('''
                                  || d.zone_desc
                                  || ''')',
                                 '2', 'FIRE STATISTICAL REPORT ('''
                                  || d.zone_desc
                                  || ''')',
                                 '4', 'FIRE STATISTICAL REPORT ('''
                                  || d.zone_desc
                                  || ''')',
                                 '5', 'FIRE STATISTICAL REPORT ('''
                                  || d.zone_desc
                                  || ''')'
                                ),
                         b260.zone_no,
                         b260.share_cd,
                         a160.share_type,
                         a160.trty_name,
                         c.rv_meaning
                ORDER BY b260.extract_dt,
                         b260.zone_no,
                         b260.share_cd,
                         a160.share_type,
                         a160.trty_name)
      LOOP
         v_not_exist := FALSE;
         v_list.extract_dt := i.extract_dt;
         v_list.header := i.header;
         v_list.zone_no := i.zone_no;
         v_list.no_of_risk := i.no_of_risk;
         v_list.share_cd := i.share_cd;
         v_list.share_tsi_amt := i.share_tsi_amt;
         v_list.share_prem_amt := i.share_prem_amt;
         v_list.share_type := i.share_type;
         v_list.trty_name := i.trty_name;
         v_list.zone_class := i.zone_class;
         v_list.zone_desc := get_gipir037a_zone_desc (i.zone_no);
         v_list.zone_risk :=
            get_gipir037a_zone_risk (p_zonetype,
                                     i.zone_no,
                                     p_as_of_sw,
                                     p_risk_cnt,
                                     p_user
                                    );                --added edgar 03/13/2015
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_gipir037a_record;

   FUNCTION get_gipir037a_b_record (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2                            --edgar 03/13/2015
   )
      RETURN gipir037a_tab PIPELINED
   IS
      v_list            gipir037a_type;
      v_not_exist       BOOLEAN        := TRUE;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start    DATE        := TO_DATE (p_period_start, 'MM/DD/YYYY');
      v_period_end      DATE          := TO_DATE (p_period_end, 'MM/DD/YYYY');
      v_loop            NUMBER         := 0;               --edgar 04/15/2015
      v_from            NUMBER         := 0;               --edgar 04/15/2015
      v_to              NUMBER         := 0;               --edgar 04/15/2015
      v_count_dist      NUMBER         := 0;
   BEGIN
      SELECT
--DECODE(REMAINDER(COUNT (*),4),0,MOD(COUNT (*),4),MOD(COUNT (*),4)+1) modulus
             DECODE (MOD (COUNT (1), 4),
                     0, TRUNC (COUNT (1) / 4),
                     TRUNC (COUNT (1) / 4) + 1
                    ) modulus,
             COUNT (1)
        INTO v_loop,
             v_count_dist
        FROM (SELECT DISTINCT '1' zone_no, share_cd, trty_name
                         FROM TABLE
                                 (gipir037a_pkg.get_gipir037a_distr_record
                                                             (p_as_of_sw,
                                                              p_bus_cd,
                                                              p_expired_as_of,
                                                              p_period_end,
                                                              p_period_start,
                                                              p_user,
                                                              p_zonetype,
                                                              p_risk_cnt,
                                                              NULL
                                                             )
                                 )
                     ORDER BY share_cd);                    --edgar 04/15/2015

      v_from := 0;                                          --edgar 04/15/2015
      --v_to := v_loop;                                       --edgar 04/15/2015
      v_to := 3;

      FOR i IN 1 .. v_loop + 1
      LOOP
      
         IF v_from > v_count_dist THEN
            EXIT;
         END IF;
         v_list.comp_name := giisp.v ('COMPANY_NAME');
         v_list.comp_add := giisp.v ('COMPANY_ADDRESS');
         v_list.header_func := get_gipir037a_header_func (p_zonetype);
         v_list.bus_cd := get_gipir037a_bus_cd (p_bus_cd);
         v_list.period_end :=
            TO_CHAR (TO_DATE (p_period_end, 'mm-dd-yyyy'),
                     'fmMonth DD, YYYY');
         v_list.period_start :=
            TO_CHAR (TO_DATE (p_period_start, 'mm-dd-yyyy'),
                     'fmMonth DD, YYYY'
                    );
         v_list.expired_as_of :=
            TO_CHAR (TO_DATE (p_expired_as_of, 'mm-dd-yyyy'),
                     'fmMonth DD, YYYY'
                    );
         v_list.row_from := v_from;
         v_list.row_to := v_to;
         -- v_from := v_list.row_to + 1;
         -- v_to := v_from + v_loop;
--         v_from := ((i) * 4) + 1;
--         v_to := (i + 1) * 4;
         v_from := v_list.row_to + 1;
         v_to := v_from + 3;

         FOR i IN (SELECT DECODE (p_zonetype,
                                  4, 'FIRE STATISTICAL REPORT',
                                     'FIRE STATISTICAL REPORT ( '
                                  || rv_meaning
                                  || ' ) '
                                 ) header
                     FROM cg_ref_codes
                    WHERE rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
                      AND rv_low_value = p_zonetype)
         LOOP
            v_not_exist := FALSE;
            v_list.header := i.header;
         --PIPE ROW (v_list);
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         v_list.header := 'FIRE STATISTICAL REPORT';
         PIPE ROW (v_list);
      END IF;
   END get_gipir037a_b_record;

   FUNCTION get_gipir037a_distr_record (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2,
      p_zone_no         gipi_firestat_extract_dtl.zone_no%TYPE
   )
      RETURN gipir037a_distr_type_tab PIPELINED
   IS
      v_list            gipir037a_distr_type;
      v_not_exist       BOOLEAN              := TRUE;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start    DATE        := TO_DATE (p_period_start, 'MM/DD/YYYY');
      v_period_end      DATE          := TO_DATE (p_period_end, 'MM/DD/YYYY');
   BEGIN
      FOR i IN (SELECT   x.zone_type,
                         DECODE (x.zone_no, NULL, 0, x.zone_no) zone_no,
                         x.line_cd, x.share_cd, x.share_type,
                         x.dist_share_name trty_name,
                         SUM (NVL (x.share_tsi_amt, 0)) share_tsi_amt,
                         SUM (NVL (x.share_prem_amt, 0)) share_prem_amt
                    FROM gipi_firestat_extract_dtl_vw x
                   WHERE x.user_id = p_user
                     AND x.as_of_sw = p_as_of_sw
                     AND x.zone_type = p_zonetype
--                     AND DECODE (x.zone_no, NULL, 0, x.zone_no) =
--                                       DECODE (p_zone_no,
--                                               NULL, 0,
--                                               p_zone_no
--                                              )
                     AND (   (    x.as_of_sw = 'Y'
                              AND TRUNC (x.as_of_date) =
                                     TRUNC (NVL (v_expired_as_of,
                                                 x.as_of_date)
                                           )
                             )
                          OR (    x.as_of_sw = 'N'
                              AND TRUNC (x.date_from) =
                                     TRUNC (NVL (v_period_start, x.date_from))
                              AND TRUNC (x.date_to) =
                                         TRUNC (NVL (v_period_end, x.date_to))
                             )
                         )
                GROUP BY x.zone_type,
                         x.zone_no,
                         x.zone_desc,
                         x.line_cd,
                         x.share_cd,
                         x.dist_share_name,
                         x.share_type
                ORDER BY x.line_cd,
                         x.share_type,
                         x.share_cd,
                         x.dist_share_name)
      LOOP
         v_not_exist := FALSE;
         v_list.zone_no := i.zone_no;
         v_list.line_cd := i.line_cd;
         v_list.zone_type := p_zonetype;
         v_list.share_cd := i.share_cd;
         v_list.share_tsi_amt := i.share_tsi_amt;
         v_list.share_prem_amt := i.share_prem_amt;
         v_list.share_type := i.share_type;
         v_list.trty_name := i.trty_name;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.zone_type := p_zonetype;
         PIPE ROW (v_list);
      END IF;
   END get_gipir037a_distr_record;

   FUNCTION get_gipir037a_v2_record (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2                            --edgar 03/13/2015
   )
      RETURN gipir037a_tab PIPELINED
   IS
      v_list            gipir037a_type;
      v_not_exist       BOOLEAN        := TRUE;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start    DATE        := TO_DATE (p_period_start, 'MM/DD/YYYY');
      v_period_end      DATE          := TO_DATE (p_period_end, 'MM/DD/YYYY');
   BEGIN
      v_list.comp_name := giisp.v ('COMPANY_NAME');
      v_list.comp_add := giisp.v ('COMPANY_ADDRESS');
      v_list.header_func := get_gipir037a_header_func (p_zonetype);
      v_list.bus_cd := get_gipir037a_bus_cd (p_bus_cd);
      v_list.period_end :=
           TO_CHAR (TO_DATE (p_period_end, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');
      v_list.period_start :=
         TO_CHAR (TO_DATE (p_period_start, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');
      v_list.expired_as_of :=
         TO_CHAR (TO_DATE (p_expired_as_of, 'mm-dd-yyyy'),
                  'fmMonth DD, YYYY');

      FOR i IN
         (SELECT   abc.zone_type, abc.zone_no, abc.zone_desc,
                   SUM (share_tsi_amt) share_tsi_amt,
                   SUM (share_prem_amt) share_prem_amt, SUM (cnt) risk_cnt
              FROM (SELECT   bg.zone_type, bg.zone_no, bg.zone_desc,
                             bg.policy_no, SUM (share_tsi_amt) share_tsi_amt,
                             SUM (share_prem_amt) share_prem_amt, risk_item,
                             DECODE (SUM (share_tsi_amt), 0, 0, 1) cnt
                        FROM (SELECT x.zone_type,
                                     DECODE (x.zone_no,
                                             NULL, 0,
                                             x.zone_no
                                            ) zone_no,
                                     DECODE (x.zone_no,
                                             NULL, 'NULL ZONE',
                                             x.zone_desc
                                            ) zone_desc,
                                     x.policy_no,
                                     DECODE (p_risk_cnt,
                                             'P', TO_CHAR (x.item_no),
                                             'R', x.block_id
                                              || '-'
                                              || NVL (x.risk_cd, '@@@@@@@'),
                                             ''
                                            ) risk_item,
                                     NVL (x.share_tsi_amt, 0) share_tsi_amt,
                                     NVL (x.share_prem_amt, 0) share_prem_amt
                                FROM gipi_firestat_extract_dtl_vw x
                               WHERE x.user_id = p_user
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
                                 AND x.zone_type = p_zonetype) bg
                    GROUP BY bg.zone_type,
                             bg.zone_no,
                             bg.zone_desc,
                             bg.policy_no,
                             bg.risk_item) abc
          GROUP BY abc.zone_type, abc.zone_no, abc.zone_desc
          ORDER BY abc.zone_no ASC)
      LOOP
         v_not_exist := FALSE;
--         v_list.extract_dt := i.extract_dt;
         v_list.header := NULL;                                   --i.header;
         v_list.zone_no := i.zone_no;
         v_list.no_of_risk := i.risk_cnt;
--         v_list.share_cd := i.share_cd;
         v_list.share_tsi_amt := i.share_tsi_amt;
         v_list.share_prem_amt := i.share_prem_amt;
--         v_list.share_type := i.share_type;
--         v_list.trty_name := i.trty_name;
--         v_list.zone_class := i.zone_class;
         v_list.zone_desc := i.zone_desc;
         --get_gipir037a_zone_desc (i.zone_no);
         v_list.zone_risk := i.risk_cnt;
         --  get_gipir037a_zone_risk (p_zonetype, i.zone_no, p_as_of_sw, p_risk_cnt, p_user);--added edgar 03/13/2015
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_gipir037a_v2_record;

   FUNCTION get_gipir037a_q3 (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2                            --edgar 03/16/2015
   )
      RETURN gipir037a_q3_tab PIPELINED
   IS
      v_list             gipir037a_q3_type;
      v_expired_as_of    DATE      := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start     DATE       := TO_DATE (p_period_start, 'MM/DD/YYYY');
      v_period_end       DATE         := TO_DATE (p_period_end, 'MM/DD/YYYY');
      v_share_tsi_amt    NUMBER (16, 2);
      v_share_prem_amt   NUMBER (16, 2);
   BEGIN
      FOR i IN
         (     /*SELECT   1 ROWCOUNT, rv_meaning zone_class,
                        SUM (b260.no_of_risk) zone_risk,
                        b260.share_cd zone_share_cd,
                        SUM (b260.share_tsi_amt) zone_share_tsi_amt,
                        SUM (b260.share_prem_amt) zone_share_prem_amt,
                        a160.trty_name zone_trty_name
                   FROM gipi_firestat_extract b260,
                        giis_dist_share a160,
                        (SELECT rv_meaning, flood_zone zone_no,
                                '1' zone_type
                           FROM cg_ref_codes a, giis_flood_zone b
                          WHERE rv_domain = 'ZONE_GROUP'
                            AND rv_low_value = zone_grp
                         UNION ALL
                         SELECT rv_meaning, typhoon_zone zone_no,
                                '2' zone_type
                           FROM cg_ref_codes a, giis_typhoon_zone b
                          WHERE rv_domain = 'ZONE_GROUP'
                            AND rv_low_value = zone_grp
                         UNION ALL
                         SELECT rv_meaning, eq_zone zone_no, '3' zone_type
                           FROM cg_ref_codes a, giis_eqzone b
                          WHERE rv_domain = 'ZONE_GROUP'
                            AND rv_low_value = zone_grp) c
                  WHERE a160.line_cd = 'FI'
                    AND a160.share_cd = b260.share_cd
                    AND b260.zone_type = p_zonetype
                    AND b260.zone_type = c.zone_type
                    AND b260.zone_no = c.zone_no
                    AND b260.as_of_sw = p_as_of_sw
                    AND (       b260.as_of_sw = 'Y'
                            AND b260.as_of_date =
                                       NVL (v_expired_as_of, b260.as_of_date)
                         OR     b260.as_of_sw = 'N'
                            AND b260.date_from =
                                         NVL (v_period_start, b260.date_from)
                            AND b260.date_to =
                                             NVL (v_period_end, b260.date_to)
                        )
                    AND b260.user_id = p_user
               GROUP BY rv_meaning, b260.share_cd, a160.trty_name*/
          SELECT   1 ROWCOUNT, NVL (rv_meaning, 'NO ZONE') zone_class,
                   0 zone_risk, SUM (b260.share_tsi_amt) zone_share_tsi_amt,
                   SUM (b260.share_prem_amt) zone_share_prem_amt
              FROM gipi_firestat_extract_dtl b260,
                   giis_dist_share a160,
                   (SELECT rv_meaning, flood_zone zone_no, '1' zone_type
                      FROM cg_ref_codes a, giis_flood_zone b
                     WHERE rv_domain = 'ZONE_GROUP'
                           AND rv_low_value = zone_grp
                    UNION ALL
                    SELECT rv_meaning, typhoon_zone zone_no, '2' zone_type
                      FROM cg_ref_codes a, giis_typhoon_zone b
                     WHERE rv_domain = 'ZONE_GROUP'
                           AND rv_low_value = zone_grp
                    UNION ALL
                    SELECT rv_meaning, eq_zone zone_no, '3' zone_type
                      FROM cg_ref_codes a, giis_eqzone b
                     WHERE rv_domain = 'ZONE_GROUP'
                           AND rv_low_value = zone_grp) c
             WHERE a160.line_cd = b260.line_cd
               AND a160.share_cd = b260.share_cd
               AND b260.zone_type = p_zonetype
               AND b260.zone_type = c.zone_type(+)
               AND b260.zone_no = c.zone_no(+)
               AND b260.as_of_sw = p_as_of_sw
               AND (       b260.as_of_sw = 'Y'
                       AND TRUNC (b260.as_of_date) =
                                TRUNC (NVL (v_expired_as_of, b260.as_of_date))
                    OR     b260.as_of_sw = 'N'
                       AND TRUNC (b260.date_from) =
                                  TRUNC (NVL (v_period_start, b260.date_from))
                       AND TRUNC (b260.date_to) =
                                      TRUNC (NVL (v_period_end, b260.date_to))
                   )
               AND b260.user_id = p_user
          GROUP BY rv_meaning
          ORDER BY rv_meaning)
      LOOP
         v_list.ROWCOUNT := i.ROWCOUNT;
         v_list.zone_class := i.zone_class;
         v_list.zone_risk := i.zone_risk;
         --v_list.zone_share_cd := i.zone_share_cd;
         v_list.zone_share_tsi_amt := i.zone_share_tsi_amt;
         v_list.zone_share_prem_amt := i.zone_share_prem_amt;
         --v_list.zone_trty_name := i.zone_trty_name;
         v_list.no_risks :=
            get_gipir037a_no_risks (p_zonetype,
                                    i.zone_class,
                                    p_as_of_sw,
                                    p_risk_cnt,
                                    p_user
                                   );

         -- added p_risk_cnt and p_user : edgar 03/16/2015
         FOR a IN (SELECT SUM (share_tsi_amt) share_tsi_amt,
                          SUM (share_prem_amt) share_prem_amt
                     FROM gipi_firestat_extract_dtl a,
                          (SELECT rv_meaning, flood_zone zone_no,
                                  '1' zone_type
                             FROM cg_ref_codes a, giis_flood_zone b
                            WHERE rv_domain = 'ZONE_GROUP'
                              AND rv_low_value = zone_grp
                           UNION
                           SELECT rv_meaning, typhoon_zone zone_no,
                                  '2' zone_type
                             FROM cg_ref_codes a, giis_typhoon_zone b
                            WHERE rv_domain = 'ZONE_GROUP'
                              AND rv_low_value = zone_grp) b
                    WHERE a.user_id = p_user
                      AND a.zone_no = b.zone_no(+)          --edgar 03/16/2015
                      AND a.zone_type = b.zone_type(+)      --edgar 03/16/2015
                      --AND a.share_cd = i.zone_share_cd
                      AND a.as_of_sw = NVL (p_as_of_sw, a.as_of_sw))
         LOOP
            v_list.share_tsi_amt := a.share_tsi_amt;
            v_list.share_prem_amt := a.share_prem_amt;
            v_list.cp_zone_share_prem := NVL (v_share_prem_amt, 0);
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;
   END get_gipir037a_q3;

   FUNCTION get_gipir037a_q3_v2 (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2
   )
      RETURN gipir037a_q3_tab PIPELINED
   IS
      v_list             gipir037a_q3_type;
      v_expired_as_of    DATE      := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start     DATE       := TO_DATE (p_period_start, 'MM/DD/YYYY');
      v_period_end       DATE         := TO_DATE (p_period_end, 'MM/DD/YYYY');
      v_share_tsi_amt    NUMBER (16, 2);
      v_share_prem_amt   NUMBER (16, 2);
   BEGIN
      FOR i IN
         (SELECT   1 ROWCOUNT, abc.zone_type, abc.zone_grp, abc.zone_class,
                   SUM (share_tsi_amt) share_tsi_amt,
                   SUM (share_prem_amt) share_prem_amt, SUM (cnt) zone_risk
              FROM (SELECT   bg.zone_type, bg.zone_grp, bg.zone_class,
                             bg.policy_no, SUM (share_tsi_amt) share_tsi_amt,
                             SUM (share_prem_amt) share_prem_amt, risk_item,
                             DECODE (SUM (share_tsi_amt), 0, 0, 1) cnt
                        FROM (SELECT x.zone_type,
                                     DECODE (x.zone_grp,
                                             NULL, 0,
                                             x.zone_grp
                                            ) zone_grp,
                                     DECODE (x.zone_grp,
                                             NULL, 'NO ZONE GROUP',
                                             x.zone_grp_desc
                                            ) zone_class,
                                     x.policy_no,
                                     DECODE (p_risk_cnt,
                                             'P', TO_CHAR (x.item_no),
                                             'R', x.block_id
                                              || '-'
                                              || NVL (x.risk_cd, '@@@@@@@'),
                                             ''
                                            ) risk_item,
                                     NVL (x.share_tsi_amt, 0) share_tsi_amt,
                                     NVL (x.share_prem_amt, 0) share_prem_amt
                                FROM gipi_firestat_extract_dtl_vw x
                               WHERE x.user_id = p_user
                                 AND x.as_of_sw = p_as_of_sw
                                 AND x.zone_type = p_zonetype
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
                                     )) bg
                    GROUP BY bg.zone_type,
                             bg.zone_grp,
                             bg.zone_class,
                             bg.policy_no,
                             bg.risk_item) abc
          GROUP BY abc.zone_type, abc.zone_grp, abc.zone_class
          ORDER BY abc.zone_grp)
      LOOP
         v_list.ROWCOUNT := i.ROWCOUNT;
         v_list.zone_class := i.zone_class;
         v_list.zone_risk := i.zone_risk;
         v_list.zone_share_tsi_amt := i.share_tsi_amt;
         v_list.zone_share_prem_amt := i.share_prem_amt;
         PIPE ROW (v_list);
      END LOOP;
   END get_gipir037a_q3_v2;

   FUNCTION get_gipir037a_q2 (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2                            --edgar 03/16/2015
   )
      RETURN gipir037a_q2_tab PIPELINED
   IS
      v_list            gipir037a_q2_type;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start    DATE        := TO_DATE (p_period_start, 'MM/DD/YYYY');
      v_period_end      DATE          := TO_DATE (p_period_end, 'MM/DD/YYYY');
   BEGIN
      FOR i IN
         (
/*SELECT   b260.extract_dt extract_dt1,
         DECODE (b260.zone_type,
                 '3', 'FIRE STATISTICAL REPORT (EARTHQUAKE)'
                ) header1,
         b260.zone_type zone_type1, b260.zone_no zone_no1,
         b260.no_of_risk no_of_risk1, b260.share_cd share_cd1,
         b260.share_tsi_amt share_tsi_amt1,
         b260.share_prem_amt share_prem_amt1,
         a160.share_type share_type1, a160.trty_name trty_name1
    FROM gipi_firestat_extract b260, giis_dist_share a160
   WHERE a160.line_cd = 'FI'
     AND a160.share_cd = b260.share_cd
     AND b260.zone_type = '3'
     AND b260.zone_type = p_zonetype
     AND b260.as_of_sw = p_as_of_sw
     AND (       b260.as_of_sw = 'Y'
             AND b260.as_of_date =
                              NVL (v_expired_as_of, b260.as_of_date)
          OR     b260.as_of_sw = 'N'
             AND b260.date_from =
                                NVL (v_period_start, b260.date_from)
             AND b260.date_to = NVL (v_period_end, b260.date_to)
         )
     AND b260.user_id = p_user
ORDER BY b260.extract_dt,
         b260.zone_no,
         b260.share_cd,
         b260.no_of_risk,
         a160.share_type,
         a160.trty_name*/--commented out edgar 03/16/2015 replaced with codes below
          SELECT   b260.extract_dt extract_dt1,
                   DECODE (b260.zone_type,
                           '3', 'FIRE STATISTICAL REPORT (EARTHQUAKE)'
                          ) header1,
                   b260.zone_type zone_type1, NVL (b260.zone_no, 0) zone_no1,
                   b260.share_cd share_cd1,
                   SUM (NVL (b260.share_tsi_amt, 0)) share_tsi_amt1,
                   SUM (NVL (b260.share_prem_amt, 0)) share_prem_amt1,
                   a160.share_type share_type1, a160.trty_name trty_name1
              FROM gipi_firestat_extract_dtl b260, giis_dist_share a160
             WHERE a160.line_cd = b260.line_cd
               AND a160.share_cd = b260.share_cd
               AND b260.zone_type = '3'
               AND b260.zone_type = p_zonetype
               AND b260.as_of_sw = p_as_of_sw
               AND (       b260.as_of_sw = 'Y'
                       AND b260.as_of_date =
                                        NVL (v_expired_as_of, b260.as_of_date)
                    OR     b260.as_of_sw = 'N'
                       AND b260.date_from =
                                          NVL (v_period_start, b260.date_from)
                       AND b260.date_to = NVL (v_period_end, b260.date_to)
                   )
               AND b260.user_id = p_user
          GROUP BY b260.extract_dt,
                   DECODE (b260.zone_type,
                           '3', 'FIRE STATISTICAL REPORT (EARTHQUAKE)'
                          ),
                   b260.zone_type,
                   b260.zone_no,
                   b260.share_cd,
                   a160.share_type,
                   a160.trty_name
          ORDER BY b260.extract_dt,
                   b260.zone_no,
                   b260.share_cd,
                   a160.share_type,
                   a160.trty_name)
      LOOP
         v_list.extract_dt1 := i.extract_dt1;
         v_list.header1 := i.header1;
         v_list.zone_type1 := i.zone_type1;
         v_list.zone_no1 := i.zone_no1;
         --v_list.no_of_risk1 := i.no_of_risk1;
         v_list.share_cd1 := i.share_cd1;
         v_list.share_tsi_amt1 := i.share_tsi_amt1;
         v_list.share_prem_amt1 := i.share_prem_amt1;
         v_list.share_type1 := i.share_type1;
         v_list.trty_name1 := i.trty_name1;
         v_list.e_zone_desc := get_gipir037a_e_zone_desc (i.zone_no1);
         v_list.e_zone_risk :=
            get_gipir037a_zone_risk (p_zonetype,
                                     i.zone_no1,
                                     p_as_of_sw,
                                     p_risk_cnt,
                                     p_user
                                    );                --added edgar 03/13/2015
         --get_gipir037a_e_zone_risk (p_zonetype, i.zone_no1); --commented out edgar 03/13/2015
         PIPE ROW (v_list);
      END LOOP;
   END get_gipir037a_q2;

   /*Created by : Edgar Nobleza
   **Date created : 03/16/2015
   **Description: to separate the query of the summarized amounts from the tabular amounts (per share code)
   */
   FUNCTION get_gipir037a_q3_2 (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2
   )
      RETURN gipir037a_q3_tab PIPELINED
   IS
      v_list             gipir037a_q3_type;
      v_expired_as_of    DATE      := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start     DATE       := TO_DATE (p_period_start, 'MM/DD/YYYY');
      v_period_end       DATE         := TO_DATE (p_period_end, 'MM/DD/YYYY');
      v_share_tsi_amt    NUMBER (16, 2);
      v_share_prem_amt   NUMBER (16, 2);
   BEGIN
      FOR i IN (SELECT   1 ROWCOUNT, NVL (rv_meaning, 'NO ZONE') zone_class,
                         0 zone_risk, b260.share_cd zone_share_cd,
                         SUM (b260.share_tsi_amt) zone_share_tsi_amt,
                         SUM (b260.share_prem_amt) zone_share_prem_amt,
                         a160.trty_name zone_trty_name
                    FROM gipi_firestat_extract_dtl b260,
                         giis_dist_share a160,
                         (SELECT rv_meaning, flood_zone zone_no,
                                 '1' zone_type
                            FROM cg_ref_codes a, giis_flood_zone b
                           WHERE rv_domain = 'ZONE_GROUP'
                             AND rv_low_value = zone_grp
                          UNION ALL
                          SELECT rv_meaning, typhoon_zone zone_no,
                                 '2' zone_type
                            FROM cg_ref_codes a, giis_typhoon_zone b
                           WHERE rv_domain = 'ZONE_GROUP'
                             AND rv_low_value = zone_grp
                          UNION ALL
                          SELECT rv_meaning, eq_zone zone_no, '3' zone_type
                            FROM cg_ref_codes a, giis_eqzone b
                           WHERE rv_domain = 'ZONE_GROUP'
                             AND rv_low_value = zone_grp) c
                   WHERE a160.line_cd = b260.line_cd
                     AND a160.share_cd = b260.share_cd
                     AND b260.zone_type = p_zonetype
                     AND b260.zone_type = c.zone_type(+)
                     AND b260.zone_no = c.zone_no(+)
                     AND b260.as_of_sw = p_as_of_sw
                     AND (       b260.as_of_sw = 'Y'
                             AND TRUNC (b260.as_of_date) =
                                    TRUNC (NVL (v_expired_as_of,
                                                b260.as_of_date
                                               )
                                          )
                          OR     b260.as_of_sw = 'N'
                             AND TRUNC (b260.date_from) =
                                    TRUNC (NVL (v_period_start,
                                                b260.date_from)
                                          )
                             AND TRUNC (b260.date_to) =
                                      TRUNC (NVL (v_period_end, b260.date_to))
                         )
                     AND b260.user_id = p_user
                GROUP BY rv_meaning, b260.share_cd, a160.trty_name
                ORDER BY rv_meaning, b260.share_cd, a160.trty_name)
      LOOP
         v_list.ROWCOUNT := i.ROWCOUNT;
         v_list.zone_class := i.zone_class;
         v_list.zone_risk := i.zone_risk;
         v_list.zone_share_cd := i.zone_share_cd;
         v_list.zone_share_tsi_amt := i.zone_share_tsi_amt;
         v_list.zone_share_prem_amt := i.zone_share_prem_amt;
         v_list.zone_trty_name := i.zone_trty_name;
         v_list.no_risks := 0;

         FOR a IN (SELECT SUM (NVL (share_tsi_amt, 0)) share_tsi_amt,
                          SUM (NVL (share_prem_amt, 0)) share_prem_amt
                     FROM gipi_firestat_extract_dtl a,
                          (SELECT rv_meaning, flood_zone zone_no,
                                  '1' zone_type
                             FROM cg_ref_codes a, giis_flood_zone b
                            WHERE rv_domain = 'ZONE_GROUP'
                              AND rv_low_value = zone_grp
                           UNION
                           SELECT rv_meaning, typhoon_zone zone_no,
                                  '2' zone_type
                             FROM cg_ref_codes a, giis_typhoon_zone b
                            WHERE rv_domain = 'ZONE_GROUP'
                              AND rv_low_value = zone_grp) b
                    WHERE a.user_id = p_user
                      AND a.zone_type = p_zonetype
                      AND a.zone_no = b.zone_no(+)
                      AND a.zone_type = b.zone_type(+)
                      AND a.share_cd = i.zone_share_cd
                      AND a.as_of_sw = NVL (p_as_of_sw, a.as_of_sw)
                      AND NVL (b.rv_meaning, 'NO ZONE') = i.zone_class)
         LOOP
            v_list.share_tsi_amt := a.share_tsi_amt;
            v_list.share_prem_amt := a.share_prem_amt;
            v_list.cp_zone_share_prem := a.share_prem_amt;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;
   END get_gipir037a_q3_2;

   FUNCTION get_gipir037a_q3_2_b (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2
   )
      RETURN gipir037a_q3_b_tab PIPELINED
   IS
      v_list             gipir037a_q3_b_type;
      v_expired_as_of    DATE      := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_period_start     DATE       := TO_DATE (p_period_start, 'MM/DD/YYYY');
      v_period_end       DATE         := TO_DATE (p_period_end, 'MM/DD/YYYY');
      v_share_tsi_amt    NUMBER (16, 2);
      v_share_prem_amt   NUMBER (16, 2);
   BEGIN
      FOR i IN (SELECT   1 ROWCOUNT, bg.zone_type, bg.zone_grp,
                         bg.zone_class, SUM (bg.share_tsi_amt) share_tsi_amt,
                         SUM (bg.share_prem_amt) share_prem_amt, bg.line_cd,
                         bg.trty_name, bg.share_cd
                    FROM (SELECT x.zone_type,
                                 DECODE (x.zone_grp,
                                         NULL, 0,
                                         x.zone_grp
                                        ) zone_grp,
                                 DECODE (x.zone_grp,
                                         NULL, 'NO ZONE GROUP',
                                         x.zone_grp_desc
                                        ) zone_class,
                                 x.policy_no,
                                 NVL (x.share_tsi_amt, 0) share_tsi_amt,
                                 NVL (x.share_prem_amt, 0) share_prem_amt,
                                 x.line_cd, x.share_cd,
                                 x.dist_share_name trty_name
                            FROM gipi_firestat_extract_dtl_vw x
                           WHERE x.user_id = p_user
                             AND x.as_of_sw = p_as_of_sw
                             AND x.zone_type = p_zonetype
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
                                 )) bg
                GROUP BY bg.zone_type,
                         bg.zone_grp,
                         bg.zone_class,
                         bg.line_cd,
                         bg.share_cd,
                         bg.trty_name
                ORDER BY bg.zone_grp, bg.zone_class, bg.line_cd, bg.share_cd)
      LOOP
         v_list.ROWCOUNT := i.ROWCOUNT;
         v_list.zone_class := i.zone_class;
         v_list.zone_grp := i.zone_grp;
         v_list.zone_share_cd := i.share_cd;
         v_list.zone_share_tsi_amt := i.share_tsi_amt;
         v_list.zone_share_prem_amt := i.share_prem_amt;
         v_list.zone_trty_name := i.trty_name;
         v_list.zone_line_cd := i.line_cd;
         PIPE ROW (v_list);
      END LOOP;
   END get_gipir037a_q3_2_b;

   -- jhing 03.22.2015 added new program units
   FUNCTION get_maintained_zones (
      p_zone_type   gipi_firestat_extract_dtl.zone_type%TYPE
   )
      RETURN get_maint_zones_rec_type_tab PIPELINED
   IS
      v_list   get_maint_zones_rec_type;
   BEGIN
      FOR cur IN (SELECT   '1' zone_type, a.flood_zone zone_no,
                           a.flood_zone_desc zone_desc, a.zone_grp,
                           b.rv_meaning zone_grp_desc
                      FROM giis_flood_zone a, cg_ref_codes b
                     WHERE b.rv_domain = 'ZONE_GROUP'
                  UNION
                  SELECT   '2' zone_type, a.typhoon_zone zone_no,
                           a.typhoon_zone_desc zone_desc, a.zone_grp,
                           b.rv_meaning zone_grp_desc
                      FROM giis_typhoon_zone a, cg_ref_codes b
                     WHERE b.rv_domain = 'ZONE_GROUP'
                  UNION
                  SELECT   '3' zone_type, a.eq_zone zone_no,
                           a.eq_desc zone_desc, a.zone_grp,
                           b.rv_meaning zone_grp_desc
                      FROM giis_eqzone a, cg_ref_codes b
                     WHERE b.rv_domain = 'ZONE_GROUP'
                  UNION
                  SELECT   '5' zone_type, a.flood_zone zone_no,
                           a.flood_zone_desc zone_desc, a.zone_grp,
                           b.rv_meaning zone_grp_desc
                      FROM giis_flood_zone a, cg_ref_codes b
                     WHERE b.rv_domain = 'ZONE_GROUP'
                  UNION
                  SELECT   '5' zone_type, a.typhoon_zone zone_no,
                           a.typhoon_zone_desc zone_desc, a.zone_grp,
                           b.rv_meaning zone_grp_desc
                      FROM giis_typhoon_zone a, cg_ref_codes b
                     WHERE b.rv_domain = 'ZONE_GROUP'
                  ORDER BY zone_type, zone_no, zone_grp)
      LOOP
         v_list.zone_type := cur.zone_type;
         v_list.zone_no := cur.zone_no;
         v_list.zone_desc := cur.zone_desc;
         v_list.zone_grp := cur.zone_grp;
         v_list.zone_grp_desc := cur.zone_grp_desc;
         PIPE ROW (v_list);
      END LOOP;
   END get_maintained_zones;
END;
/


