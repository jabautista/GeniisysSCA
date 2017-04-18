CREATE OR REPLACE PACKAGE BODY CPI.gipir039a_pkg
AS
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 09.20.2013
   **  Reference By : GIPIR039A- COMMITMENT AND ACCUMULATION SUMMARY-TOTAL AS A WHOLE
   **  Description  :
   */
   FUNCTION populate_gipir039a (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2
   )
      RETURN gipir039a_tab PIPELINED
   AS
      TYPE cur_typ IS REF CURSOR;

      custom        cur_typ;
      v_rec         gipir039a_type;
      v_not_exist   BOOLEAN                         := TRUE;
      v_column      VARCHAR2 (50);
      v_table       VARCHAR2 (50);
      v_query       VARCHAR (10000);
      v_zone_grp    giis_flood_zone.zone_grp%TYPE;
   BEGIN
      v_rec.company_name := giacp.v ('COMPANY_NAME');
      v_rec.company_add := giacp.v ('COMPANY_ADDRESS');

      IF p_zone_type = 1
      THEN
         v_column := 'FLOOD_ZONE';
         v_table := 'GIIS_FLOOD_ZONE';
      ELSIF p_zone_type = 2
      THEN
         v_column := 'TYPHOON_ZONE';
         v_table := 'GIIS_TYPHOON_ZONE';
      ELSE
         v_column := 'EQ_ZONE';
         v_table := 'GIIS_EQZONE';
      END IF;

      IF p_zone_type = 1
      THEN
         v_rec.title := 'Flood Accumulation Limit Summary';
      ELSIF p_zone_type = 2
      THEN
         v_rec.title := 'Typhoon Accumulation Limit Summary';
      ELSIF p_zone_type = 3
      THEN
         v_rec.title := 'Earthquake Accumulation Limit Summary';
      ELSIF p_zone_type = 4
      THEN
         v_rec.title := 'Fire Accumulation Limit Summary';
      ELSE
         v_rec.title := 'Typhoon and Flood Accumulation Limit Summary';
      END IF;

      IF p_date = '1'
      THEN
         v_rec.date_title :=
               'From '
            || TO_CHAR (TO_DATE(p_from_date, 'MM-DD-RRRR'), 'fmMonth DD, YYYY')
            || ' To '
            || TO_CHAR (TO_DATE(p_to_date, 'MM-DD-RRRR'), 'fmMonth DD, YYYY');
      ELSE
         v_rec.date_title :=
                            'As of ' || TO_CHAR (TO_DATE(p_as_of, 'MM-DD-RRRR'), 'fmMonth DD, YYYY');
      END IF;

      v_query :=
            'SELECT DISTINCT a.policy_id, zone_grp, zone_no, SUM (share_tsi_amt) total_tsi,
                SUM (share_prem_amt) total_prem,
                c.line_cd||''-''||c.subline_cd||''-''||c.iss_cd||''-''||LTRIM(TO_CHAR(c.issue_yy, ''09''))||''-''||LTRIM(TO_CHAR(c.pol_seq_no, ''0000009''))||''-''||LTRIM(TO_CHAR(c.renew_no, ''09'')) policy_no,
                a.zone_type,a.fi_item_grp
           FROM gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,
                gipi_polbasic c                          
          WHERE a.zone_no = b.'
         || v_column
         || ' AND a.zone_type = '''
         || p_zone_type
         || ''' AND a.as_of_sw = '''
         || p_as_of_sw
         || ''' AND fi_item_grp IS NOT NULL
            AND a.user_id = '''
         || p_user_id
         || ''' AND a.policy_id = c.policy_id                 
            AND check_user_per_iss_cd2 (c.line_cd, c.iss_cd, ''GIPIS901'','''
         || p_user_id
         || ''') =1
         AND a.as_of_date <= NVL('''
         || TO_DATE(p_as_of, 'MM-DD-RRRR')
         || ''',a.as_of_date)
         OR (a.date_from >= NVL('''
         || TO_DATE(p_from_date, 'MM-DD-RRRR')
         || ''',a.date_from) AND a.date_to <= NVL('''
         || TO_DATE(p_to_date, 'MM-DD-RRRR')
         || ''',a.date_to))
       GROUP BY c.line_cd, 
         c.subline_cd, 
		 c.iss_cd, 
		 c.issue_yy, 
		 c.pol_seq_no, 
		 c.renew_no, 
		 a.zone_no,
		 a.zone_type,
		 b.zone_grp, 
         a.policy_id,
         a.fi_item_grp
         ORDER BY b.zone_grp';

--raise_application_error (-20001,v_query);
      OPEN custom FOR v_query;

      LOOP
         FETCH custom
          INTO v_rec.policy_id, v_zone_grp, v_rec.zone_no, v_rec.total_tsi,
               v_rec.total_prem, v_rec.policy_no, v_rec.zone_type,
               v_rec.fi_item_grp;

         v_rec.exist := 'Y';
         v_not_exist := FALSE;

         IF v_zone_grp = 1
         THEN
            v_rec.zone_grp := 'Zone A';
         ELSE
            v_rec.zone_grp := 'Zone B';
         END IF;

         IF v_rec.policy_id IS NULL
         THEN
            v_not_exist := TRUE;
         END IF;

         EXIT WHEN custom%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE custom;

      IF v_not_exist
      THEN
         v_rec.zone_grp := NULL;
         v_rec.exist := 'N';
         PIPE ROW (v_rec);
      END IF;
--   EXCEPTION
--      WHEN OTHERS
--      THEN
--         -- NULL;
--         raise_application_error (-20001, 'steven - error');
   END populate_gipir039a;

   FUNCTION get_fi_item_grp (
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2
   )
      RETURN fi_item_grp_tab PIPELINED
   IS
      v_rec   fi_item_grp_type;
   BEGIN
      FOR j IN (SELECT DISTINCT DECODE (fi_item_grp,
                                        'B', 'BUILDING',
                                        'C', 'CONTENT',
                                        'L', 'LOSS'
                                       ) fi_item_grp
                           FROM gipi_firestat_extract_dtl a, gipi_polbasic b
                          WHERE     fi_item_grp IS NOT NULL
                                AND a.user_id = p_user_id
                                AND a.policy_id = b.policy_id
                                AND check_user_per_iss_cd2 (b.line_cd,
                                                            b.iss_cd,
                                                            'GIPIS901',
                                                            p_user_id
                                                           ) = 1
                                AND a.as_of_date <=
                                                   NVL (TO_DATE(p_as_of, 'MM-DD-RRRR'), a.as_of_date)
                             OR (    a.date_from >=
                                                NVL (TO_DATE(p_from_date, 'MM-DD-RRRR'), a.date_from)
                                 AND a.date_to <= NVL (TO_DATE(p_to_date, 'MM-DD-RRRR'), a.date_to)
                                ))
      LOOP
         v_rec.fi_item_grp := j.fi_item_grp;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_fire_stat_dtl_crosstab (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_zone_grp    VARCHAR2,
      p_policy_id   gipi_firestat_extract_dtl.policy_id%TYPE
   )
      RETURN fire_stat_dtl_crosstab_tab PIPELINED
   IS
      v_rec   fire_stat_dtl_crosstab_type;
   BEGIN
      FOR i IN (SELECT DISTINCT policy_id, zone_grp, zone_no, zone_type,
                                policy_no
                           FROM TABLE
                                   (gipir039a_pkg.populate_gipir039a
                                                                 (p_zone_type,
                                                                  p_date,
                                                                  p_as_of_sw,
                                                                  p_user_id,
                                                                  p_from_date,
                                                                  p_to_date,
                                                                  p_as_of
                                                                 )
                                   )
                          WHERE policy_id = NVL (p_policy_id, policy_id)
                            AND zone_grp = NVL (p_zone_grp, zone_grp))
      LOOP
         v_rec.policy_id := i.policy_id;
         v_rec.zone_grp := i.zone_grp;
         v_rec.zone_no := i.zone_no;
         v_rec.zone_type := i.zone_type;
         v_rec.policy_no := i.policy_no;

         FOR j IN (SELECT DISTINCT fi_item_grp
                              FROM gipi_firestat_extract_dtl a,
                                   gipi_polbasic b
                             WHERE fi_item_grp IS NOT NULL
                               AND a.user_id = p_user_id
                               AND a.policy_id = b.policy_id
                               AND check_user_per_iss_cd2 (b.line_cd,
                                                           b.iss_cd,
                                                           'GIPIS901',
                                                           p_user_id
                                                          ) = 1)
         LOOP
            v_rec.fi_item_grp := j.fi_item_grp;
            v_rec.total_tsi := NULL;
            v_rec.total_prem := NULL;

            FOR k IN
               (SELECT total_tsi, total_prem
                  FROM TABLE (gipir039a_pkg.populate_gipir039a (p_zone_type,
                                                                p_date,
                                                                p_as_of_sw,
                                                                p_user_id,
                                                                p_from_date,
                                                                p_to_date,
                                                                p_as_of
                                                               )
                             )
                 WHERE policy_id = i.policy_id
                   AND zone_grp = NVL (p_zone_grp, zone_grp)
                   AND fi_item_grp = j.fi_item_grp)
            LOOP
               v_rec.total_tsi := k.total_tsi;
               v_rec.total_prem := k.total_prem;
            END LOOP;

            PIPE ROW (v_rec);
         END LOOP;
      END LOOP;
   END;

   FUNCTION populate_gipir039a_recap (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gipir039a_recap_tab PIPELINED
   AS
      v_rec           gipir039a_recap_type;
      cnt             NUMBER               := 0;
      v_fi_item_grp   VARCHAR2 (1)         := 'B';
      tsi_amt         NUMBER               := 0;
      prem_amt        NUMBER               := 0;
   BEGIN
      --CF_bldg_pol formula
      v_rec.cf_bldg_pol :=
         gipir039a_pkg.get_cf_pol_cnt ('B',
                                       p_zone_type,
                                       p_as_of_sw,
                                       p_user_id
                                      );
      --CF_content_pol Formula
      v_rec.cf_content_pol :=
         gipir039a_pkg.get_cf_pol_cnt ('C', p_zone_type, p_as_of_sw,
                                       p_user_id);
      --CF_loss_pol Formula
      v_rec.cf_loss_pol :=
         gipir039a_pkg.get_cf_pol_cnt ('L', p_zone_type, p_as_of_sw,
                                       p_user_id);
      --CF_grnd_pol Formula
      cnt := 0;

      BEGIN
         IF p_zone_type = 1
         THEN
            FOR a IN (SELECT   1
                          FROM gipi_polbasic a,
                               gipi_firestat_extract_dtl b,
                               giis_flood_zone c
                         WHERE a.policy_id = b.policy_id
                           AND b.zone_type = p_zone_type
                           AND b.zone_no = c.flood_zone --edgar 03/20/2015
                           AND b.as_of_sw = p_as_of_sw
                           AND b.user_id = p_user_id
                           AND b.fi_item_grp IS NOT NULL
                      GROUP BY b.policy_id, fi_item_grp)
            LOOP
               cnt := cnt + 1;
            END LOOP;
         ELSIF p_zone_type = 2
         THEN
            FOR a IN (SELECT   1
                          FROM gipi_polbasic a,
                               gipi_firestat_extract_dtl b,
                               giis_typhoon_zone c
                         WHERE a.policy_id = b.policy_id
                           AND b.zone_type = p_zone_type
                           AND b.zone_no = c.typhoon_zone--edgar 03/20/2015
                           AND b.as_of_sw = p_as_of_sw
                           AND b.user_id = p_user_id
                           AND b.fi_item_grp IS NOT NULL
                      GROUP BY b.policy_id, fi_item_grp)
            LOOP
               cnt := cnt + 1;
            END LOOP;
         ELSE
            FOR a IN (SELECT   1
                          FROM gipi_polbasic a,
                               gipi_firestat_extract_dtl b,
                               giis_eqzone c
                         WHERE a.policy_id = b.policy_id
                           AND b.zone_type = p_zone_type
                           AND b.zone_no = c.eq_zone--edgar 03/20/2015
                           AND b.as_of_sw = p_as_of_sw
                           AND b.user_id = p_user_id
                           AND b.fi_item_grp IS NOT NULL
                      GROUP BY b.policy_id, fi_item_grp)
            LOOP
               cnt := cnt + 1;
            END LOOP;
         END IF;

         v_rec.cf_grnd_pol := cnt;
      END;

      v_rec.cf_bldg_tsi_amt :=
         gipir039a_pkg.get_cf_tsi_amt ('B', p_zone_type, p_as_of_sw,
                                       p_user_id);
      v_rec.cf_content_tsi_amt :=
         gipir039a_pkg.get_cf_tsi_amt ('C', p_zone_type, p_as_of_sw,
                                       p_user_id);
      v_rec.cf_loss_tsi_amt :=
         gipir039a_pkg.get_cf_tsi_amt ('L', p_zone_type, p_as_of_sw,
                                       p_user_id);

      BEGIN
         IF p_zone_type = 1
         THEN
            SELECT SUM (share_tsi_amt)
              INTO tsi_amt
              FROM gipi_polbasic a,
                   gipi_firestat_extract_dtl b,
                   giis_flood_zone c
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = c.flood_zone--edgar 03/20/2015
               AND b.as_of_sw = p_as_of_sw
               AND b.user_id = p_user_id
               AND b.fi_item_grp IS NOT NULL;
         ELSIF p_zone_type = 2
         THEN
            SELECT SUM (share_tsi_amt)
              INTO tsi_amt
              FROM gipi_polbasic a,
                   gipi_firestat_extract_dtl b,
                   giis_typhoon_zone c
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = c.typhoon_zone--edgar 03/20/2015
               AND b.as_of_sw = p_as_of_sw
               AND b.user_id = p_user_id
               AND b.fi_item_grp IS NOT NULL;
         ELSE
            SELECT SUM (share_tsi_amt)
              INTO tsi_amt
              FROM gipi_polbasic a, gipi_firestat_extract_dtl b,
                   giis_eqzone c
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = c.eq_zone--edgar 03/20/2015
               AND b.as_of_sw = p_as_of_sw
               AND b.user_id = p_user_id
               AND b.fi_item_grp IS NOT NULL;
         END IF;

         v_rec.cf_grnd_tsi_amt := tsi_amt;
      END;

      v_rec.cf_bldg_prem_amt :=
         gipir039a_pkg.get_cf_prem_amt ('B',
                                        p_zone_type,
                                        p_as_of_sw,
                                        p_user_id
                                       );
      v_rec.cf_content_prem_amt :=
         gipir039a_pkg.get_cf_prem_amt ('C',
                                        p_zone_type,
                                        p_as_of_sw,
                                        p_user_id
                                       );
      v_rec.cf_loss_prem_amt :=
         gipir039a_pkg.get_cf_prem_amt ('L',
                                        p_zone_type,
                                        p_as_of_sw,
                                        p_user_id
                                       );

      BEGIN
         IF p_zone_type = 1
         THEN
            SELECT SUM (share_prem_amt)
              INTO prem_amt
              FROM gipi_polbasic a,
                   gipi_firestat_extract_dtl b,
                   giis_flood_zone c
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = c.flood_zone--edgar 03/20/2015
               AND b.as_of_sw = p_as_of_sw
               AND b.user_id = p_user_id
               AND b.fi_item_grp IS NOT NULL;
         ELSIF p_zone_type = 2
         THEN
            SELECT SUM (share_prem_amt)
              INTO prem_amt
              FROM gipi_polbasic a,
                   gipi_firestat_extract_dtl b,
                   giis_typhoon_zone c
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = c.typhoon_zone--edgar 03/20/2015
               AND b.as_of_sw = p_as_of_sw
               AND b.user_id = p_user_id
               AND b.fi_item_grp IS NOT NULL;
         ELSE
            SELECT SUM (share_prem_amt)
              INTO prem_amt
              FROM gipi_polbasic a, gipi_firestat_extract_dtl b,
                   giis_eqzone c
             WHERE a.policy_id = b.policy_id
               AND b.zone_type = p_zone_type
               AND b.zone_no = c.eq_zone--edgar 03/20/2015
               AND b.as_of_sw = p_as_of_sw
               AND b.user_id = p_user_id
               AND b.fi_item_grp IS NOT NULL;
         END IF;

         v_rec.cf_grnd_prem_amt := prem_amt;
      END;

      PIPE ROW (v_rec);
   END;

   FUNCTION get_cf_pol_cnt (
      v_fi_item_grp   VARCHAR2,
      p_zone_type     NUMBER,
      p_as_of_sw      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN NUMBER
   IS
      cnt   NUMBER := 0;
   BEGIN
      IF p_zone_type = 1
      THEN
         FOR a IN (SELECT   1
                       FROM gipi_polbasic a,
                            gipi_firestat_extract_dtl b,
                            giis_flood_zone c
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = c.flood_zone--edgar 03/20/2015
                        AND b.as_of_sw = p_as_of_sw
                        AND b.user_id = p_user_id
                        AND b.fi_item_grp IS NOT NULL
                        AND b.fi_item_grp = v_fi_item_grp
                   GROUP BY a.line_cd,
                            a.subline_cd,
                            a.iss_cd,
                            a.issue_yy,
                            a.pol_seq_no,
                            a.renew_no,
                            b.zone_no,
                            b.zone_type,
                            c.zone_grp,
                            b.policy_id
                   ORDER BY c.zone_grp)
         LOOP
            cnt := cnt + 1;
         END LOOP;
      ELSIF p_zone_type = 2
      THEN
         FOR a IN (SELECT   1
                       FROM gipi_polbasic a,
                            gipi_firestat_extract_dtl b,
                            giis_typhoon_zone c
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = c.typhoon_zone--edgar 03/20/2015
                        AND b.as_of_sw = p_as_of_sw
                        AND b.user_id = p_user_id
                        AND b.fi_item_grp IS NOT NULL
                        AND b.fi_item_grp = v_fi_item_grp
                   GROUP BY a.line_cd,
                            a.subline_cd,
                            a.iss_cd,
                            a.issue_yy,
                            a.pol_seq_no,
                            a.renew_no,
                            b.zone_no,
                            b.zone_type,
                            c.zone_grp,
                            b.policy_id
                   ORDER BY c.zone_grp)
         LOOP
            cnt := cnt + 1;
         END LOOP;
      ELSE
         FOR a IN (SELECT   1
                       FROM gipi_polbasic a,
                            gipi_firestat_extract_dtl b,
                            giis_eqzone c
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = c.eq_zone--edgar 03/20/2015
                        AND b.as_of_sw = p_as_of_sw
                        AND b.user_id = p_user_id
                        AND b.fi_item_grp IS NOT NULL
                        AND b.fi_item_grp = v_fi_item_grp
                   GROUP BY a.line_cd,
                            a.subline_cd,
                            a.iss_cd,
                            a.issue_yy,
                            a.pol_seq_no,
                            a.renew_no,
                            b.zone_no,
                            b.zone_type,
                            c.zone_grp,
                            b.policy_id
                   ORDER BY c.zone_grp)
         LOOP
            cnt := cnt + 1;
         END LOOP;
      END IF;

      RETURN (cnt);
   END;

   FUNCTION get_cf_tsi_amt (
      v_fi_item_grp   VARCHAR2,
      p_zone_type     NUMBER,
      p_as_of_sw      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN NUMBER
   IS
      tsi_amt   NUMBER := 0;
   BEGIN
      IF p_zone_type = 1
      THEN
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_flood_zone c
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = c.flood_zone--edgar 03/20/2015
            AND b.as_of_sw = p_as_of_sw
            AND b.user_id = p_user_id
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSIF p_zone_type = 2
      THEN
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_typhoon_zone c
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = c.typhoon_zone--edgar 03/20/2015
            AND b.as_of_sw = p_as_of_sw
            AND b.user_id = p_user_id
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSE
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a, gipi_firestat_extract_dtl b, giis_eqzone c
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = c.eq_zone--edgar 03/20/2015
            AND b.as_of_sw = p_as_of_sw
            AND b.user_id = p_user_id
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      END IF;

      RETURN (tsi_amt);
   END;

   FUNCTION get_cf_prem_amt (
      v_fi_item_grp   VARCHAR2,
      p_zone_type     NUMBER,
      p_as_of_sw      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN NUMBER
   IS
      prem_amt   NUMBER := 0;
   BEGIN
      IF p_zone_type = 1
      THEN
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_flood_zone c
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = c.flood_zone--edgar 03/20/2015
            AND b.as_of_sw = p_as_of_sw
            AND b.user_id = p_user_id
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSIF p_zone_type = 2
      THEN
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_typhoon_zone c
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = c.typhoon_zone--edgar 03/20/2015
            AND b.as_of_sw = p_as_of_sw
            AND b.user_id = p_user_id
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSE
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a, gipi_firestat_extract_dtl b, giis_eqzone c
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = c.eq_zone--edgar 03/20/2015
            AND b.as_of_sw = p_as_of_sw
            AND b.user_id = p_user_id
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      END IF;

      RETURN (prem_amt);
   END;
   
   FUNCTION populate_gipir039a_v2 (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_risk_cnt    VARCHAR2
   )
      RETURN gipir039a_tab PIPELINED
   AS
      TYPE cur_typ IS REF CURSOR;

      custom        cur_typ;
      v_rec         gipir039a_type;
      v_not_exist   BOOLEAN                         := TRUE;
      v_column      VARCHAR2 (50);
      v_table       VARCHAR2 (50);
      v_query       VARCHAR (10000);
      v_zone_grp    giis_flood_zone.zone_grp%TYPE;
      
      v_expired_as_of   DATE := TO_DATE(p_as_of, 'MM-DD-RRRR');
      v_period_start    DATE := TO_DATE(p_from_date, 'MM-DD-RRRR');
      v_period_end      DATE := TO_DATE(p_to_date, 'MM-DD-RRRR');
   BEGIN
      v_rec.company_name := giacp.v ('COMPANY_NAME');
      v_rec.company_add := giacp.v ('COMPANY_ADDRESS');

      IF p_zone_type = 1
      THEN
         v_column := 'FLOOD_ZONE';
         v_table := 'GIIS_FLOOD_ZONE';
      ELSIF p_zone_type = 2
      THEN
         v_column := 'TYPHOON_ZONE';
         v_table := 'GIIS_TYPHOON_ZONE';
      ELSE
         v_column := 'EQ_ZONE';
         v_table := 'GIIS_EQZONE';
      END IF;

      IF p_zone_type = 1
      THEN
         v_rec.title := 'Flood Accumulation Limit Summary';
      ELSIF p_zone_type = 2
      THEN
         v_rec.title := 'Typhoon Accumulation Limit Summary';
      ELSIF p_zone_type = 3
      THEN
         v_rec.title := 'Earthquake Accumulation Limit Summary';
      ELSIF p_zone_type = 4
      THEN
         v_rec.title := 'Fire Accumulation Limit Summary';
      ELSIF p_zone_type = 5
      THEN
         v_rec.title := 'Typhoon and Flood Accumulation Limit Summary';
      ELSE
         v_rec.title := 'No Title. Report Error:(9400936555)';
      END IF;

      IF NVL(p_as_of_sw,'N') = 'N'
      THEN
         v_rec.date_title :=
               'From '
            || TO_CHAR (TO_DATE(p_from_date, 'MM-DD-RRRR'), 'fmMonth DD, YYYY')
            || ' To '
            || TO_CHAR (TO_DATE(p_to_date, 'MM-DD-RRRR'), 'fmMonth DD, YYYY');
      ELSE
         v_rec.date_title :=
                            'As of ' || TO_CHAR (TO_DATE(p_as_of, 'MM-DD-RRRR'), 'fmMonth DD, YYYY');
      END IF;

     FOR i IN (
                SELECT DISTINCT policy_no, risk_item, zone_grp, zone_no, SUM (total_tsi) total_tsi,
                                SUM (total_prem) total_prem, zone_type, fi_item_grp,
                                zone_grp_desc, fi_item_grp_desc,
                                DECODE (SUM (total_tsi), 0, 0, 1) cnt
                           FROM (SELECT policy_no, NVL (a.zone_grp, '0') zone_grp,
                                        NVL (a.zone_no, '0') zone_no,
                                        NVL (share_tsi_amt, 0) total_tsi,
                                        NVL (share_prem_amt, 0) total_prem, a.zone_type,
                                        a.fi_item_grp,
                                        NVL (a.zone_grp_desc, 'NO ZONE GROUP') zone_grp_desc,
                                        a.fi_item_grp_desc,
                                        TO_CHAR (a.item_no) risk_item
                                   FROM gipi_firestat_extract_dtl_vw a
                                  WHERE a.zone_type = p_zone_type
                                    AND a.as_of_sw = p_as_of_sw
                                    AND fi_item_grp IS NOT NULL
                                    AND a.user_id = p_user_id
                                    AND (       a.as_of_sw = 'Y'
                                            AND TRUNC (a.as_of_date) =
                                                          NVL (v_expired_as_of, a.as_of_date)
                                         OR     a.as_of_sw = 'N'
                                            AND TRUNC (a.date_from) =
                                                            NVL (v_period_start, a.date_from)
                                            AND TRUNC (a.date_to) =
                                                                NVL (v_period_end, a.date_to)
                                        ))
                       GROUP BY policy_no, risk_item,
                                zone_no,
                                zone_type,
                                zone_grp,
                                fi_item_grp,
                                zone_grp_desc,
                                fi_item_grp_desc
                         HAVING SUM (total_tsi) <> 0 OR SUM (total_prem) <> 0
                       ORDER BY zone_grp, zone_no, fi_item_grp  
     )
     LOOP
         v_rec.exist := 'Y';
         v_not_exist := FALSE;

         v_rec.zone_grp             :=  i.zone_grp;
         v_rec.zone_no          :=  i.zone_no;
         v_rec.total_tsi        :=  i.total_tsi;
         v_rec.total_prem       :=  i.total_prem;
         v_rec.policy_no        :=  i.policy_no;
         v_rec.zone_type        :=  i.zone_type;
         v_rec.fi_item_grp      :=  i.fi_item_grp;
         v_rec.item_grp_name    :=  i.FI_ITEM_GRP_DESC;
         v_rec.zone_grp_desc    :=  i.zone_grp_desc;
         v_rec.policy_cnt       :=  i.cnt;

         IF v_rec.policy_no IS NULL
         THEN
            v_not_exist := TRUE;
         END IF;

         PIPE ROW (v_rec);

     END LOOP;

      IF v_not_exist
      THEN
         v_rec.zone_grp := NULL;
         v_rec.exist := 'N';
         PIPE ROW (v_rec);
      END IF;
   END populate_gipir039a_v2;   
   
   FUNCTION get_fi_item_grp_v2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_zone_grp    VARCHAR2
   )
      RETURN fi_item_grp_tab PIPELINED
   IS
      v_rec   fi_item_grp_type;
      
      v_expired_as_of   DATE := TO_DATE(p_as_of, 'MM-DD-RRRR');
      v_period_start    DATE := TO_DATE(p_from_date, 'MM-DD-RRRR');
      v_period_end      DATE := TO_DATE(p_to_date, 'MM-DD-RRRR');      
   BEGIN
      FOR j IN (
                SELECT DISTINCT a.fi_item_grp, a.fi_item_grp_desc, a.zone_type
                           FROM gipi_firestat_extract_dtl_vw a
                          WHERE a.zone_type = p_zone_type
                            AND a.as_of_sw = p_as_of_sw
                            AND fi_item_grp IS NOT NULL
                            AND a.user_id = p_user_id
                            AND (       a.as_of_sw = 'Y'
                                    AND TRUNC(a.as_of_date) = NVL (v_expired_as_of, a.as_of_date)
                                 OR     a.as_of_sw = 'N'
                                    AND TRUNC(a.date_from) = NVL (v_period_start, a.date_from)
                                    AND TRUNC(a.date_to) = NVL (v_period_end, a.date_to)
                                )
                            AND NVL (a.zone_grp, '0') = NVL(p_zone_grp, NVL (a.zone_grp, '0'))
                       GROUP BY a.zone_type, a.fi_item_grp, a.fi_item_grp_desc
                       ORDER BY a.fi_item_grp 
                )
      LOOP
         v_rec.fi_item_grp      := j.fi_item_grp;
         v_rec.fi_item_grp_desc := j.fi_item_grp_desc;
         PIPE ROW (v_rec);
      END LOOP;
   END get_fi_item_grp_v2;   
   
   FUNCTION get_fire_stat_dtl_crosstab_v2 (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_zone_grp    VARCHAR2,
      p_policy_no   VARCHAR2,
      p_zone_no     VARCHAR2,
      p_risk_cnt    VARCHAR2
   )
      RETURN fire_stat_dtl_crosstab_tab PIPELINED
   IS
      v_rec   fire_stat_dtl_crosstab_type;
   BEGIN

      FOR i IN (
                SELECT DISTINCT policy_no, zone_grp, zone_no, zone_type, total_tsi,
                                total_prem, fi_item_grp, item_grp_name
                           FROM TABLE (gipir039a_pkg.populate_gipir039a_v2 (p_zone_type,
                                                                            p_date,
                                                                            p_as_of_sw,
                                                                            p_user_id,
                                                                            p_from_date,
                                                                            p_to_date,
                                                                            p_as_of,
                                                                            p_risk_cnt
                                                                           )
                                      )
                          WHERE zone_grp = NVL (p_zone_grp, zone_grp)
              )
      LOOP
         v_rec.zone_grp := i.zone_grp;
         v_rec.zone_no := i.zone_no;
         v_rec.zone_type := i.zone_type;
         v_rec.policy_no := i.policy_no;

         v_rec.fi_item_grp := i.fi_item_grp;
         v_rec.fi_item_grp_desc := i.item_grp_name;

         v_rec.total_tsi := i.total_tsi;
         v_rec.total_prem := i.total_prem;


         PIPE ROW (v_rec);
      END LOOP;
   END get_fire_stat_dtl_crosstab_v2;   
   
   FUNCTION get_fire_stat_dtl_crosstab_v3 (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_zone_grp    VARCHAR2,
      p_policy_no   VARCHAR2,
      p_zone_no     VARCHAR2,
      p_risk_cnt    VARCHAR2
   )
      RETURN gipir039a_tab PIPELINED
   IS
      v_rec   gipir039a_type;
   BEGIN

      FOR i IN (
                SELECT a.fi_item_grp, a.fi_item_grp_desc, b.zone_type, b.zone_grp, b.zone_no, b.policy_no,
                       DECODE (a.fi_item_grp, b.fi_item_grp, b.total_tsi, 0) total_tsi,
                       DECODE (a.fi_item_grp, b.fi_item_grp, b.total_prem, 0) total_prem
                  FROM TABLE (gipir039a_pkg.get_fi_item_grp_v2 (p_zone_type,
                                                                p_as_of_sw,
                                                                p_user_id,
                                                                p_from_date,
                                                                p_to_date,
                                                                p_as_of,
                                                                p_zone_grp
                                                               )
                             ) a,
                       TABLE (gipir039a_pkg.get_fire_stat_dtl_crosstab_v2 (p_zone_type,
                                                                           p_date,
                                                                           p_as_of_sw,
                                                                           p_user_id,
                                                                           p_from_date,
                                                                           p_to_date,
                                                                           p_as_of,
                                                                           p_zone_grp,
                                                                           p_policy_no,
                                                                           p_zone_no,
                                                                           p_risk_cnt
                                                                          )
                             ) b
              )
      LOOP
         v_rec.zone_grp := i.zone_grp;
         v_rec.zone_no := i.zone_no;
         v_rec.zone_type := i.zone_type;
         v_rec.policy_no := i.policy_no;

         v_rec.fi_item_grp := i.fi_item_grp;
         v_rec.item_grp_name := i.fi_item_grp_desc;

         v_rec.total_tsi := i.total_tsi;
         v_rec.total_prem := i.total_prem;


         PIPE ROW (v_rec);
      END LOOP;
   END get_fire_stat_dtl_crosstab_v3;  
   
   FUNCTION get_fire_stat_dtl_sub_tot (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_zone_grp    VARCHAR2,
      p_risk_cnt    VARCHAR2
   )
      RETURN gipir039a_tab PIPELINED
   IS
      v_rec   gipir039a_type;
   BEGIN

      FOR i IN (
                SELECT a.fi_item_grp, a.fi_item_grp_desc, b.zone_type, b.zone_grp,
                       SUM(DECODE (a.fi_item_grp, b.fi_item_grp, b.total_tsi, 0)) total_tsi,
                       SUM(DECODE (a.fi_item_grp, b.fi_item_grp, b.total_prem, 0)) total_prem
                  FROM TABLE (gipir039a_pkg.get_fi_item_grp_v2 (p_zone_type,
                                                                p_as_of_sw,
                                                                p_user_id,
                                                                p_from_date,
                                                                p_to_date,
                                                                p_as_of,
                                                                p_zone_grp
                                                               )
                             ) a,
                       TABLE (gipir039a_pkg.get_fire_stat_dtl_crosstab_v2 (p_zone_type,
                                                                           p_date,
                                                                           p_as_of_sw,
                                                                           p_user_id,
                                                                           p_from_date,
                                                                           p_to_date,
                                                                           p_as_of,
                                                                           p_zone_grp,
                                                                           NULL,
                                                                           NULL,
                                                                           p_risk_cnt
                                                                          )
                             ) b
                GROUP BY b.zone_type,  b.zone_grp, a.fi_item_grp, a.fi_item_grp_desc
                ORDER BY b.zone_type,  b.zone_grp, a.fi_item_grp, a.fi_item_grp_desc
              )
      LOOP
         v_rec.zone_grp := i.zone_grp;
         v_rec.zone_type := i.zone_type;

         v_rec.fi_item_grp := i.fi_item_grp;
         v_rec.item_grp_name := i.fi_item_grp_desc;

         v_rec.total_tsi := i.total_tsi;
         v_rec.total_prem := i.total_prem;


         PIPE ROW (v_rec);
      END LOOP;
   END get_fire_stat_dtl_sub_tot;    
   
   FUNCTION get_fire_stat_dtl_grand_tot (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_risk_cnt    VARCHAR2
   )
      RETURN gipir039a_tab PIPELINED
   IS
      v_rec   gipir039a_type;
   BEGIN

      FOR i IN (
                SELECT a.fi_item_grp, a.fi_item_grp_desc, b.zone_type,
                       SUM(DECODE (a.fi_item_grp, b.fi_item_grp, b.total_tsi, 0)) total_tsi,
                       SUM(DECODE (a.fi_item_grp, b.fi_item_grp, b.total_prem, 0)) total_prem
                  FROM TABLE (gipir039a_pkg.get_fi_item_grp_v2 (p_zone_type,
                                                                p_as_of_sw,
                                                                p_user_id,
                                                                p_from_date,
                                                                p_to_date,
                                                                p_as_of,
                                                                NULL
                                                               )
                             ) a,
                       TABLE (gipir039a_pkg.get_fire_stat_dtl_crosstab_v2 (p_zone_type,
                                                                           p_date,
                                                                           p_as_of_sw,
                                                                           p_user_id,
                                                                           p_from_date,
                                                                           p_to_date,
                                                                           p_as_of,
                                                                           NULL,
                                                                           NULL,
                                                                           NULL,
                                                                           p_risk_cnt
                                                                          )
                             ) b
                GROUP BY b.zone_type, a.fi_item_grp, a.fi_item_grp_desc
                ORDER BY b.zone_type, a.fi_item_grp, a.fi_item_grp_desc
              )
      LOOP
         v_rec.zone_type := i.zone_type;

         v_rec.fi_item_grp := i.fi_item_grp;
         v_rec.item_grp_name := i.fi_item_grp_desc;

         v_rec.total_tsi := i.total_tsi;
         v_rec.total_prem := i.total_prem;


         PIPE ROW (v_rec);
      END LOOP;
   END get_fire_stat_dtl_grand_tot;   

   FUNCTION populate_gipir039a_recap_v2 (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_risk_cnt    VARCHAR2
   )
      RETURN gipir039a_recap_tab PIPELINED
   AS
      v_rec         gipir039a_recap_type;
      v_not_exist   BOOLEAN                         := TRUE;
      v_column      VARCHAR2 (50);
      v_table       VARCHAR2 (50);
      v_query       VARCHAR (10000);
      v_zone_grp    giis_flood_zone.zone_grp%TYPE;
      
      v_expired_as_of   DATE := TO_DATE(p_as_of, 'MM-DD-RRRR');
      v_period_start    DATE := TO_DATE(p_from_date, 'MM-DD-RRRR');
      v_period_end      DATE := TO_DATE(p_to_date, 'MM-DD-RRRR');
   BEGIN

     FOR i IN (
            SELECT SUM(policy_cnt) pol_cnt, SUM(total_tsi) total_tsi, SUM(total_prem) total_prem, 
                   fi_item_grp, item_grp_name
              FROM TABLE (gipir039a_pkg.populate_gipir039a_v2 (p_zone_type,
                                                               p_date,
                                                               p_as_of_sw,
                                                               p_user_id,
                                                               p_from_date,
                                                               p_to_date,
                                                               p_as_of,
                                                               p_risk_cnt
                                                              )
                         )
            GROUP BY fi_item_grp, item_grp_name
            ORDER BY fi_item_grp    
     )
     LOOP
       IF i.fi_item_grp  = 'B' THEN   
          v_rec.cf_bldg_pol           := i.pol_cnt;
          v_rec.cf_bldg_tsi_amt       := i.total_tsi;          
          v_rec.cf_bldg_prem_amt      := i.total_prem;
       ELSIF i.fi_item_grp  = 'C' THEN
          v_rec.cf_content_pol        := i.pol_cnt;
          v_rec.cf_content_tsi_amt    := i.total_tsi;
          v_rec.cf_content_prem_amt   := i.total_prem;
       ELSIF i.fi_item_grp  = 'L' THEN
          v_rec.cf_loss_pol           := i.pol_cnt;          
          v_rec.cf_loss_tsi_amt       := i.total_tsi;
          v_rec.cf_loss_prem_amt      := i.total_prem;
       END IF;      

         PIPE ROW (v_rec);

     END LOOP;

   END populate_gipir039a_recap_v2;      
END gipir039a_pkg;
/


