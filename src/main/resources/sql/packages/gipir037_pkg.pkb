CREATE OR REPLACE PACKAGE BODY CPI.gipir037_pkg
AS
   FUNCTION get_gipir037_header_func (p_zonetype VARCHAR2)
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
   END get_gipir037_header_func;

   FUNCTION get_gipir037_bus_cd (p_bus_cd NUMBER)
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
   END get_gipir037_bus_cd;

   FUNCTION get_gipir037_date_type (p_date_type VARCHAR2)
      RETURN CHAR
   IS
      v_date_type   VARCHAR2 (100);
   BEGIN
      IF p_date_type = 'AD'
      THEN
         v_date_type := 'Based on Accounting Entry Date';  -- jhing 03.21.2015 added Based On on all date types
      ELSIF p_date_type = 'ID'
      THEN
         v_date_type := 'Based on Issue Date';
      ELSIF p_date_type = 'ED'
      THEN
         v_date_type := 'Based on Effectivity Date';
      ELSIF p_date_type = 'BD'
      THEN
         v_date_type := 'Based on Booking Date';
      END IF;

      RETURN (v_date_type);
   END get_gipir037_date_type;

   FUNCTION get_gipir037_record (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_date_type       VARCHAR2,
      p_inc_endt        VARCHAR2,
      p_inc_exp         VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_tab PIPELINED
   IS
      v_list            gipir037_type;
      v_not_exist       BOOLEAN       := TRUE;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
   BEGIN
      v_list.comp_name := giisp.v ('COMPANY_NAME');
      v_list.comp_add := giisp.v ('COMPANY_ADDRESS');
      v_list.header_func := get_gipir037_header_func (p_zonetype);
      v_list.bus_cd := get_gipir037_bus_cd (p_bus_cd);
      v_list.date_type := get_gipir037_date_type (p_date_type);
      v_list.period_end :=
           TO_CHAR (TO_DATE (p_period_end, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');
      v_list.period_start :=
         TO_CHAR (TO_DATE (p_period_start, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');
      v_list.expired_as_of :=
         TO_CHAR (TO_DATE (p_expired_as_of, 'mm-dd-yyyy'),
                  'fmMonth DD, YYYY');

      FOR i IN
         (SELECT DISTINCT b200.zone_no, share_tsi_amt, c.rv_meaning,
                          DECODE
                             (TO_CHAR (b200.zone_type),
                              '1', 'FIRE STATISTICAL REPORT (FLOOD)',
                              '2', 'FIRE STATISTICAL REPORT (TYPHOON)',
                              '4', 'FIRE STATISTICAL REPORT',
                              '5', 'FIRE STATISTICAL REPORT (TYPHOON AND FLOOD)'
                             ) header
                     FROM gipi_firestat_extract b200,
                          giis_dist_share a100,
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
                              AND rv_low_value = zone_grp) c
                    WHERE b200.share_cd = a100.share_cd
                      AND b200.zone_no = c.zone_no(+)
                      AND b200.zone_type = c.zone_type(+)
                      AND a100.line_cd = 'FI'
                      AND b200.zone_type IN ('1', '2', '3', '4', '5')
                      AND b200.zone_type = p_zonetype
                      AND a100.share_type IN (1, 2, 3)
                      AND (       b200.as_of_sw = 'Y'
                              AND b200.as_of_date = v_expired_as_of
                           OR     b200.as_of_sw = 'N'
                              AND b200.date_from = p_period_start
                              AND b200.date_to = p_period_end
                          )
                      AND NVL (b200.no_of_risk, 0) != 0
                      AND b200.user_id = p_user)
      LOOP
         SELECT DECODE (SUM (NVL (tsi, 0)), 0, 'N', 'Y')
           INTO v_list.tsi_tot
           FROM TABLE (gipir037_pkg.get_gipir037_zone (p_expired_as_of,
                                                       p_period_end,
                                                       p_period_start,
                                                       p_zonetype,
                                                       p_user,
                                                       i.zone_no
                                                      )
                      );

         SELECT DECODE (SUM (NVL (prem, 0)), 0, 'N', 'Y')
           INTO v_list.prem_tot
           FROM TABLE (gipir037_pkg.get_gipir037_zone (p_expired_as_of,
                                                       p_period_end,
                                                       p_period_start,
                                                       p_zonetype,
                                                       p_user,
                                                       i.zone_no
                                                      )
                      );

         v_not_exist := FALSE;
         v_list.zone_no := i.zone_no;
         v_list.share_tsi_amt := i.share_tsi_amt;
         v_list.rv_meaning := i.rv_meaning;
         v_list.header := i.header;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_gipir037_record;

   FUNCTION get_gipir037_zone (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2,
      p_zone_no         VARCHAR2
   )
      RETURN gipir037_zone_tab PIPELINED
   IS
      v_list            gipir037_zone_type;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_not_exist       BOOLEAN            := TRUE;
   BEGIN
      FOR i IN (SELECT   b200.zone_no, SUM (NVL (share_tsi_amt, 0)) tsi,
                         SUM (NVL (share_prem_amt, 0)) prem
                    FROM gipi_firestat_extract b200,
                         giis_dist_share a100,
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
                             AND rv_low_value = zone_grp) c
                   WHERE b200.share_cd = a100.share_cd
                     AND b200.zone_no = c.zone_no(+)
                     AND b200.zone_type = c.zone_type(+)
                     AND NVL (b200.no_of_risk, 0) != 0
                     AND a100.line_cd = 'FI'
                     AND b200.zone_type = p_zonetype
                     AND a100.share_type = 1
                     AND (       b200.as_of_sw = 'Y'
                             AND b200.as_of_date = v_expired_as_of
                          OR     b200.as_of_sw = 'N'
                             AND b200.date_from = p_period_start
                             AND b200.date_to = p_period_end
                         )
                     AND b200.user_id = p_user
                GROUP BY b200.zone_no
                ORDER BY b200.zone_no)
      LOOP
         v_not_exist := FALSE;
         v_list.zone_no := i.zone_no;
         v_list.tsi := i.tsi;
         v_list.prem := i.prem;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.zone_no := 0.00;
         v_list.tsi := 0.00;
         v_list.prem := 0.00;
         PIPE ROW (v_list);
      END IF;
   END get_gipir037_zone;

   FUNCTION get_gipir037_zone2 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2,
      p_zone_no         VARCHAR2
   )
      RETURN gipir037_zone2_tab PIPELINED
   IS
      v_list            gipir037_zone2_type;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_not_exist       BOOLEAN             := TRUE;
   BEGIN
      FOR k IN (SELECT   b200.zone_no zone_no2,
                         SUM (NVL (share_tsi_amt, 0)) tsi1,
                         SUM (NVL (share_prem_amt, 0)) prem1
                    FROM gipi_firestat_extract b200,
                         giis_dist_share a100,
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
                             AND rv_low_value = zone_grp) c
                   WHERE b200.share_cd = a100.share_cd
                     AND b200.zone_no = c.zone_no(+)
                     AND b200.zone_type = c.zone_type(+)
                     AND NVL (b200.no_of_risk, 0) != 0
                     AND a100.line_cd = 'FI'
                     AND b200.zone_type = p_zonetype
                     AND a100.share_type = 2
                     AND (       b200.as_of_sw = 'Y'
                             AND b200.as_of_date = v_expired_as_of
                          OR     b200.as_of_sw = 'N'
                             AND b200.date_from = p_period_start
                             AND b200.date_to = p_period_end
                         )
                     AND b200.user_id = p_user
                GROUP BY b200.zone_no
                ORDER BY b200.zone_no)
      LOOP
         v_not_exist := FALSE;
         v_list.zone_no2 := k.zone_no2;
         v_list.tsi1 := k.tsi1;
         v_list.prem1 := k.prem1;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.zone_no2 := 0.00;
         v_list.tsi1 := 0.00;
         v_list.prem1 := 0.00;
         PIPE ROW (v_list);
      END IF;
   END get_gipir037_zone2;

   FUNCTION get_gipir037_zone3 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2,
      p_zone_no         VARCHAR2
   )
      RETURN gipir037_zone3_tab PIPELINED
   IS
      v_list            gipir037_zone3_type;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_not_exist       BOOLEAN             := TRUE;
   BEGIN
      FOR l IN (SELECT   b200.zone_no zone_no3, SUM (share_tsi_amt) tsi2,
                         SUM (share_prem_amt) prem2
                    FROM gipi_firestat_extract b200,
                         giis_dist_share a100,
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
                             AND rv_low_value = zone_grp) c
                   WHERE b200.share_cd = a100.share_cd
                     AND b200.zone_no = c.zone_no(+)
                     AND b200.zone_type = c.zone_type(+)
                     AND NVL (b200.no_of_risk, 0) != 0
                     AND a100.line_cd = 'FI'
                     AND b200.zone_type = p_zonetype
                     AND a100.share_type = 3
                     AND (       b200.as_of_sw = 'Y'
                             AND b200.as_of_date = v_expired_as_of
                          OR     b200.as_of_sw = 'N'
                             AND b200.date_from = p_period_start
                             AND b200.date_to = p_period_end
                         )
                     AND b200.user_id = p_user
                GROUP BY b200.zone_no)
      LOOP
         v_not_exist := FALSE;
         v_list.zone_no3 := l.zone_no3;
         v_list.tsi2 := l.tsi2;
         v_list.prem2 := l.prem2;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.zone_no3 := 0.00;
         v_list.tsi2 := 0.00;
         v_list.prem2 := 0.00;
         PIPE ROW (v_list);
      END IF;
   END get_gipir037_zone3;

   FUNCTION get_gipir037_zone4 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2,
      p_zone_no         VARCHAR2
   )
      RETURN gipir037_zone4_tab PIPELINED
   IS
      v_list            gipir037_zone4_type;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_not_exist       BOOLEAN             := TRUE;
   BEGIN
      FOR m IN (SELECT   b200.zone_no zone_no4,
                         NVL (SUM (share_tsi_amt), 0) tsi3,
                         SUM (share_prem_amt) prem3
                    FROM gipi_firestat_extract b200,
                         giis_dist_share a100,
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
                             AND rv_low_value = zone_grp) c
                   WHERE b200.share_cd = a100.share_cd
                     AND b200.zone_no = c.zone_no(+)
                     AND b200.zone_type = c.zone_type(+)
                     AND NVL (b200.no_of_risk, 0) != 0
                     AND a100.line_cd = 'FI'
                     AND b200.zone_type = p_zonetype
                     AND a100.share_type IN (1, 2, 3)
                     AND (       b200.as_of_sw = 'Y'
                             AND b200.as_of_date = v_expired_as_of
                          OR     b200.as_of_sw = 'N'
                             AND b200.date_from = p_period_start
                             AND b200.date_to = p_period_end
                         )
                     AND b200.user_id = p_user
                GROUP BY b200.zone_no
                ORDER BY b200.zone_no)
      LOOP
         v_not_exist := FALSE;
         v_list.zone_no4 := m.zone_no4;
         v_list.tsi3 := m.tsi3;
         v_list.prem3 := m.prem3;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.zone_no4 := 0.00;
         v_list.tsi3 := 0.00;
         v_list.prem3 := 0.00;
         PIPE ROW (v_list);
      END IF;
   END get_gipir037_zone4;

   FUNCTION get_gipir037_rv1 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_rv1_tab PIPELINED
   IS
      v_list            gipir037_rv1_type;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_not_exist       BOOLEAN           := TRUE;
   BEGIN
      FOR i IN (SELECT DISTINCT c.rv_meaning rv_meaning1,
                                SUM (share_tsi_amt) share_tsi_amt,
                                SUM (share_prem_amt) share_prem_amt
                           FROM gipi_firestat_extract b200,
                                giis_dist_share a100,
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
                                    AND rv_low_value = zone_grp
                                 UNION
                                 SELECT rv_meaning, eq_zone zone_no,
                                        '3' zone_type
                                   FROM cg_ref_codes a, giis_eqzone b
                                  WHERE rv_domain = 'ZONE_GROUP'
                                    AND rv_low_value = zone_grp) c
                          WHERE b200.share_cd = a100.share_cd
                            AND b200.zone_no = c.zone_no(+)
                            AND b200.zone_type = c.zone_type(+)
                            AND a100.line_cd = 'FI'
                            AND b200.zone_type IN ('1', '2', '3', '4', '5')
                            AND b200.zone_type = p_zonetype
                            AND a100.share_type IN (1, 2, 3)
                            AND (       b200.as_of_sw = 'Y'
                                    AND b200.as_of_date = v_expired_as_of
                                 OR     b200.as_of_sw = 'N'
                                    AND b200.date_from = p_period_start
                                    AND b200.date_to = p_period_end
                                )
                            AND NVL (b200.no_of_risk, 0) != 0
                            AND b200.user_id = p_user
                       GROUP BY c.rv_meaning
                       ORDER BY c.rv_meaning ASC)
      LOOP
         v_not_exist := FALSE;
         v_list.rv_meaning1 := i.rv_meaning1;
         v_list.share_tsi_amt := i.share_tsi_amt;
         v_list.share_prem_amt := i.share_prem_amt;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.rv_meaning1 := 0.00;
         v_list.share_tsi_amt := 0.00;
         v_list.share_prem_amt := 0.00;
         PIPE ROW (v_list);
      END IF;
   END get_gipir037_rv1;

   FUNCTION get_gipir037_rv2 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_rv2_tab PIPELINED
   IS
      v_list            gipir037_rv2_type;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_not_exist       BOOLEAN           := TRUE;
   BEGIN
      FOR i IN (SELECT DISTINCT c.rv_meaning rv_meaning2,
                                SUM (share_tsi_amt) share_tsi_amt1,
                                SUM (share_prem_amt) share_prem_amt1
                           FROM gipi_firestat_extract b200,
                                giis_dist_share a100,
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
                                    AND rv_low_value = zone_grp
                                 UNION
                                 SELECT rv_meaning, eq_zone zone_no,
                                        '3' zone_type
                                   FROM cg_ref_codes a, giis_eqzone b
                                  WHERE rv_domain = 'ZONE_GROUP'
                                    AND rv_low_value = zone_grp) c
                          WHERE b200.share_cd = a100.share_cd
                            AND b200.zone_no = c.zone_no(+)
                            AND b200.zone_type = c.zone_type(+)
                            AND a100.line_cd = 'FI'
                            AND b200.zone_type = p_zonetype
                            AND a100.share_type = 1
                            AND (       b200.as_of_sw = 'Y'
                                    AND b200.as_of_date = v_expired_as_of
                                 OR     b200.as_of_sw = 'N'
                                    AND b200.date_from = p_period_start
                                    AND b200.date_to = p_period_end
                                )
                            AND NVL (b200.no_of_risk, 0) != 0
                            AND b200.user_id = p_user
                       GROUP BY c.rv_meaning
                       ORDER BY c.rv_meaning ASC)
      LOOP
         v_not_exist := FALSE;
         v_list.rv_meaning2 := i.rv_meaning2;
         v_list.share_tsi_amt1 := i.share_tsi_amt1;
         v_list.share_prem_amt1 := i.share_prem_amt1;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.rv_meaning2 := 0.00;
         v_list.share_tsi_amt1 := 0.00;
         v_list.share_prem_amt1 := 0.00;
         PIPE ROW (v_list);
      END IF;
   END get_gipir037_rv2;

   FUNCTION get_gipir037_rv3 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_rv3_tab PIPELINED
   IS
      v_list            gipir037_rv3_type;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_not_exist       BOOLEAN           := TRUE;
   BEGIN
      FOR i IN (SELECT DISTINCT c.rv_meaning rv_meaning3,
                                SUM (share_tsi_amt) share_tsi_amt2,
                                SUM (share_prem_amt) share_prem_amt2
                           FROM gipi_firestat_extract b200,
                                giis_dist_share a100,
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
                                    AND rv_low_value = zone_grp
                                 UNION
                                 SELECT rv_meaning, eq_zone zone_no,
                                        '3' zone_type -- added by aaron 040309
                                   FROM cg_ref_codes a, giis_eqzone b
                                  WHERE rv_domain = 'ZONE_GROUP'
                                    AND rv_low_value = zone_grp) c
                          WHERE b200.share_cd = a100.share_cd
                            AND b200.zone_no = c.zone_no(+)
                            AND b200.zone_type = c.zone_type(+)
                            AND a100.line_cd = 'FI'
                            AND b200.zone_type = p_zonetype
                            AND a100.share_type = 3
                            AND (       b200.as_of_sw = 'Y'
                                    AND b200.as_of_date = v_expired_as_of
                                 OR     b200.as_of_sw = 'N'
                                    AND b200.date_from = p_period_start
                                    AND b200.date_to = p_period_end
                                )
                            AND NVL (b200.no_of_risk, 0) != 0
                            AND b200.user_id = p_user
                       GROUP BY c.rv_meaning
                       ORDER BY c.rv_meaning ASC)
      LOOP
         v_not_exist := FALSE;
         v_list.rv_meaning3 := i.rv_meaning3;
         v_list.share_tsi_amt2 := i.share_tsi_amt2;
         v_list.share_prem_amt2 := i.share_prem_amt2;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.rv_meaning3 := 0.00;
         v_list.share_tsi_amt2 := 0.00;
         v_list.share_prem_amt2 := 0.00;
         PIPE ROW (v_list);
      END IF;
   END get_gipir037_rv3;

   FUNCTION get_gipir037_rv4 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_rv4_tab PIPELINED
   IS
      v_list            gipir037_rv4_type;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
      v_not_exist       BOOLEAN           := TRUE;
   BEGIN
      FOR i IN (SELECT DISTINCT c.rv_meaning rv_meaning4,
                                SUM (share_tsi_amt) share_tsi_amt3,
                                SUM (share_prem_amt) share_prem_amt3
                           FROM gipi_firestat_extract b200,
                                giis_dist_share a100,
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
                                    AND rv_low_value = zone_grp
                                 UNION
                                 SELECT rv_meaning, eq_zone zone_no,
                                        '3' zone_type
                                   FROM cg_ref_codes a, giis_eqzone b
                                  WHERE rv_domain = 'ZONE_GROUP'
                                    AND rv_low_value = zone_grp) c
                          WHERE b200.share_cd = a100.share_cd
                            AND b200.zone_no = c.zone_no(+)
                            AND b200.zone_type = c.zone_type(+)
                            AND a100.line_cd = 'FI'
                            AND b200.zone_type = p_zonetype
                            AND a100.share_type = 2
                            AND (       b200.as_of_sw = 'Y'
                                    AND b200.as_of_date = v_expired_as_of
                                 OR     b200.as_of_sw = 'N'
                                    AND b200.date_from = p_period_start
                                    AND b200.date_to = p_period_end
                                )
                            AND NVL (b200.no_of_risk, 0) != 0
                            AND b200.user_id = p_user
                       GROUP BY c.rv_meaning
                       ORDER BY c.rv_meaning ASC)
      LOOP
         v_not_exist := FALSE;
         v_list.rv_meaning4 := i.rv_meaning4;
         v_list.share_tsi_amt3 := i.share_tsi_amt3;
         v_list.share_prem_amt3 := i.share_prem_amt3;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.rv_meaning4 := 0.00;
         v_list.share_tsi_amt3 := 0.00;
         v_list.share_prem_amt3 := 0.00;
         PIPE ROW (v_list);
      END IF;
   END get_gipir037_rv4;
   
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
       v_expired_as_of   DATE          := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
       v_period_start    DATE           := TO_DATE (p_period_start, 'MM/DD/YYYY');
       v_period_end      DATE             := TO_DATE (p_period_end, 'MM/DD/YYYY');
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
                                   SELECT '2' zone_type, y.typhoon_zone zone_no,
                                          y.zone_grp
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
                             FROM (SELECT '2' zone_type, y.typhoon_zone zone_no,
                                          y.zone_grp
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

   FUNCTION get_gipir037_byzone_record (
      p_as_of_sw        VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_byzone_type_tab PIPELINED
   IS
      v_list            gipir037_byzone_type;
      v_not_exist       BOOLEAN       := TRUE;
   BEGIN
      FOR i IN
         (SELECT   ab.zone_no, SUM (ab.gross_tsi_amt) gross_tsi_amt,
                     SUM (ab.net_ret_tsi) net_ret_tsi, SUM (ab.facul_tsi) facul_tsi,
                     SUM (ab.treaty_tsi) treaty_tsi, SUM (ab.gross_prem_amt) gross_prem_amt,
                     SUM (ab.net_ret_prem) net_ret_prem, SUM (ab.facul_prem) facul_prem, 
                     SUM (ab.treaty_prem) treaty_prem 
                FROM (SELECT NVL(xb.zone_no, 0) zone_no,
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
                        FROM TABLE (gipir037_pkg.get_gipir037_recdtl (p_as_of_sw,
                                                                      p_expired_as_of,
                                                                      p_period_start,
                                                                      p_period_end,
                                                                      p_zonetype,
                                                                      p_user
                                                                     )
                                   ) xb) ab
            GROUP BY ab.zone_no
            ORDER BY ab.zone_no)
      LOOP
         v_not_exist := FALSE; 
         v_list.zone_no := TO_CHAR (NVL(i.zone_no, '0' ) );
         v_list.gross_tsi_amt := i.gross_tsi_amt;
         v_list.net_ret_tsi_amt := i.net_ret_tsi;
         v_list.facul_tsi_amt   := i.facul_tsi;
         v_list.treaty_tsi_amt  := i.treaty_tsi;
         v_list.gross_prem_amt := i.gross_prem_amt;
         v_list.net_ret_prem_amt := i.net_ret_prem;
         v_list.facul_prem_amt   := i.facul_prem;
         v_list.treaty_prem_amt  := i.treaty_prem;         
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN

         v_list.zone_no :=' ';
         PIPE ROW (v_list); 
      END IF;
   END get_gipir037_byzone_record;
     
   FUNCTION get_gipir037_byzgrp_record (
      p_as_of_sw        VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_byzgrp_type_tab PIPELINED
   IS
      v_list            gipir037_byzgrp_type;
      v_not_exist       BOOLEAN       := TRUE;
   BEGIN
      FOR i IN
         (SELECT   ab.zone_grp_desc, SUM (ab.gross_tsi_amt) gross_tsi_amt,
                     SUM (ab.net_ret_tsi) net_ret_tsi, SUM (ab.facul_tsi) facul_tsi,
                     SUM (ab.treaty_tsi) treaty_tsi, SUM (ab.gross_prem_amt) gross_prem_amt,
                     SUM (ab.net_ret_prem) net_ret_prem, SUM (ab.facul_prem) facul_prem, 
                     SUM (ab.treaty_prem) treaty_prem  , ab.zone_grp 
                FROM (SELECT DECODE (xb.zone_grp, NULL, 'NO ZONE GROUP', NVL( xb.zone_grp_desc, ' ') ) zone_grp_desc,
                             xb.zone_grp, 
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
                        FROM TABLE (gipir037_pkg.get_gipir037_recdtl (p_as_of_sw,
                                                                      p_expired_as_of,
                                                                      p_period_start,
                                                                      p_period_end,
                                                                      p_zonetype,
                                                                      p_user
                                                                     )
                                   ) xb) ab
            GROUP BY ab.zone_grp_desc, ab.zone_grp
            ORDER BY ab.zone_grp)
      LOOP
         v_not_exist := FALSE; 
         v_list.zone_group := i.zone_grp_desc;
         v_list.gross_tsi_amt := i.gross_tsi_amt;
         v_list.net_ret_tsi_amt := i.net_ret_tsi;
         v_list.facul_tsi_amt   := i.facul_tsi;
         v_list.treaty_tsi_amt  := i.treaty_tsi;
         v_list.gross_prem_amt := i.gross_prem_amt;
         v_list.net_ret_prem_amt := i.net_ret_prem;
         v_list.facul_prem_amt   := i.facul_prem;
         v_list.treaty_prem_amt  := i.treaty_prem;         
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN

         v_list.zone_group :=' ';
         PIPE ROW (v_list); 
      END IF;
   END get_gipir037_byzgrp_record;
   
   FUNCTION get_gipir037_v2_record (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_date_type       VARCHAR2,
      p_inc_endt        VARCHAR2,
      p_inc_exp         VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_tab PIPELINED
   IS
      v_list            gipir037_type;
      v_not_exist       BOOLEAN       := TRUE;
      v_expired_as_of   DATE       := TO_DATE (p_expired_as_of, 'MM/DD/YYYY');
   BEGIN
      v_list.comp_name := giisp.v ('COMPANY_NAME');
      v_list.comp_add := giisp.v ('COMPANY_ADDRESS');
      v_list.header_func := get_gipir037_header_func (p_zonetype);
      v_list.bus_cd := get_gipir037_bus_cd (p_bus_cd);
      IF p_as_of_sw = 'N' THEN --edgar 5/22/2015 FULL WEB SR 4437 : to restrict display of non-BY DATE date types
        v_list.date_type := get_gipir037_date_type (p_date_type);
      END IF;
      v_list.period_end :=
           TO_CHAR (TO_DATE (p_period_end, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');
      v_list.period_start :=
         TO_CHAR (TO_DATE (p_period_start, 'mm-dd-yyyy'), 'fmMonth DD, YYYY');
      v_list.expired_as_of :=
         TO_CHAR (TO_DATE (p_expired_as_of, 'mm-dd-yyyy'),
                  'fmMonth DD, YYYY');

      FOR i IN
         ( SELECT NULL zone_no, 0 share_tsi_amt, NULL rv_meaning,
                   DECODE (TO_CHAR (p_zonetype),
                           '1', 'FIRE STATISTICAL REPORT (FLOOD)',
                           '2', 'FIRE STATISTICAL REPORT (TYPHOON)',
                           '3', 'FIRE STATISTICAL REPORT (EARTHQUAKE)',
                           '4', 'FIRE STATISTICAL REPORT',
                           '5', 'FIRE STATISTICAL REPORT (TYPHOON AND FLOOD)'
                          ) header
              FROM DUAL)
     LOOP
         SELECT DECODE (SUM (NVL (tsi, 0)), 0, 'N', 'Y')
           INTO v_list.tsi_tot
           FROM TABLE (gipir037_pkg.get_gipir037_zone (p_expired_as_of,
                                                       p_period_end,
                                                       p_period_start,
                                                       p_zonetype,
                                                       p_user,
                                                       i.zone_no
                                                      )
                      );

         SELECT DECODE (SUM (NVL (prem, 0)), 0, 'N', 'Y')
           INTO v_list.prem_tot
           FROM TABLE (gipir037_pkg.get_gipir037_zone (p_expired_as_of,
                                                       p_period_end,
                                                       p_period_start,
                                                       p_zonetype,
                                                       p_user,
                                                       i.zone_no
                                                      )
                      );

         v_not_exist := FALSE;
         v_list.zone_no := i.zone_no;
         v_list.share_tsi_amt := i.share_tsi_amt;
         v_list.rv_meaning := i.rv_meaning;
         v_list.header := i.header;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_gipir037_v2_record;
   
              
   
END gipir037_pkg;
/


CREATE OR REPLACE PUBLIC SYNONYM GIPIR037_PKG FOR CPI.GIPIR037_PKG ; --edgar 05/22/2015 FULL WEB SR 4437

/ 