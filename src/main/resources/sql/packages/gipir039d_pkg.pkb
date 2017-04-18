CREATE OR REPLACE PACKAGE BODY CPI.gipir039d_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 09.05.2013
     **  Reference By : GIPIR039D
     **  Description  : Commitment and Accumulation Summary
     */
   FUNCTION cf_title (p_zone_type NUMBER)
      RETURN CHAR
   IS
      v_title   VARCHAR2 (200) := ' ';
   BEGIN
      IF p_zone_type = 1
      THEN
         v_title := 'Flood Accumulation Limit Summary';
      ELSIF p_zone_type = 2
      THEN
         v_title := 'Typhoon Accumulation Limit Summary';
      ELSIF p_zone_type = 3
      THEN
         v_title := 'Earthquake Accumulation Limit Summary';
      ELSIF p_zone_type = 4
      THEN
         v_title := 'Fire Accumulation Limit Summary';
      ELSE
         v_title := 'Typhoon and Flood Accumulation Limit Summary';
      END IF;

      RETURN (v_title);
   END;

   FUNCTION cf_date_title (
      p_date        VARCHAR2,
      p_as_of       VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2
   )
      RETURN CHAR
   IS
      v_date   VARCHAR2 (100) := ' ';
   BEGIN
      IF p_date = '1'
      THEN
         v_date :=
               'From '
            || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                        'fmMonth DD, YYYY'
                       )
            || ' To '
            || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), 'fmMonth DD, YYYY');
      ELSE
         v_date :=
               'As of '
            || TO_CHAR (TO_DATE (p_as_of, 'MM-DD-YYYY'), 'fmMonth DD, YYYY');
      END IF;

      RETURN (v_date);
   END;

   FUNCTION cf_date_type (p_date_type VARCHAR2)
      RETURN CHAR
   IS
      v_date_type   VARCHAR2 (100);
   BEGIN
      IF p_date_type = 'AD'
      THEN
         v_date_type := 'Accounting Entry Date';
      ELSIF p_date_type = 'ID'
      THEN
         v_date_type := 'Issue Date';
      ELSIF p_date_type = 'ED'
      THEN
         v_date_type := 'Effectivity Date';
      ELSIF p_date_type = 'BD'
      THEN
         v_date_type := 'Booking Date';
      END IF;

      RETURN (v_date_type);
   END;

/* Benjo 04.13.2015*/
   FUNCTION count_rownum (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2
   )
      RETURN NUMBER
   IS
      v_cnt   NUMBER := 0;
   BEGIN
      SELECT COUNT (*)
        INTO v_cnt
        FROM (SELECT *
                FROM TABLE (gipir039d_pkg.get_fi_item_grp2_v2 (p_zone_type,
                                                               p_as_of_sw,
                                                               p_user_id,
                                                               p_from_date,
                                                               p_to_date,
                                                               p_as_of
                                                              )
                           )
              UNION ALL
              SELECT 'GROSS'
                FROM DUAL
              UNION ALL
              SELECT *
                FROM (SELECT description
                        FROM TABLE
                                (gipir039d_pkg.get_description_record_v2
                                                                 (p_zone_type,
                                                                  p_as_of_sw,
                                                                  p_user_id,
                                                                  p_from_date,
                                                                  p_to_date,
                                                                  p_as_of
                                                                 )
                                )));

      RETURN (v_cnt);
   END;

   FUNCTION get_gipir039d_record (
      p_zone_type   NUMBER,
      p_column      VARCHAR2,
      p_table       VARCHAR2,
      p_date        VARCHAR2,
      p_as_of       VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_by_count    VARCHAR2,
      p_where       VARCHAR2,
      p_inc_exp     VARCHAR2,
      p_inc_endt    VARCHAR2,
      p_date_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gipir039d_record_tab PIPELINED
   IS
      v_rec   gipir039d_record_type;
      mjm     BOOLEAN               := TRUE;
   BEGIN
      v_rec.company_name := giacp.v ('COMPANY_NAME');
      v_rec.company_address := giacp.v ('COMPANY_ADDRESS');
      v_rec.title := cf_title (p_zone_type);
      v_rec.date_title :=
                      cf_date_title (p_date, p_as_of, p_from_date, p_to_date);
      v_rec.date_type := cf_date_type (p_date_type);

      IF p_zone_type = 1
      THEN
         FOR i IN
            (SELECT   a.zone_no, a.occupancy_cd,
                      DECODE (a.occupancy_cd,
                              NULL, 'NO OCCUPANCY',
                              d.occupancy_desc
                             ) occ_code,
                      DECODE (p_by_count,
                              'R', COUNT (DISTINCT (   c.block_id
                                                    || NVL (c.risk_cd, '*')
                                           )
                                         ),
                              COUNT (DISTINCT c.item_no)
                             ) per_count
                 FROM gipi_polbasic main,
                      gipi_firestat_extract_dtl a,
                      giis_flood_zone b,
                      gipi_fireitem c,
                      giis_fire_occupancy d
                WHERE a.zone_no = b.flood_zone
                  AND a.zone_type = p_zone_type
                  AND a.as_of_sw = p_as_of_sw
                  AND a.fi_item_grp IS NOT NULL
                  AND main.policy_id = a.policy_id
                  AND a.policy_id = c.policy_id
                  AND a.item_no = c.item_no
                  AND a.occupancy_cd = d.occupancy_cd(+)
                  AND a.user_id = p_user_id
             GROUP BY a.zone_no, a.occupancy_cd, d.occupancy_desc
             ORDER BY a.zone_no, d.occupancy_desc)
         LOOP
            mjm := FALSE;
            v_rec.zone_no := i.zone_no;
            v_rec.occupancy_cd := i.occupancy_cd;
            v_rec.occ_code := i.occ_code;
            v_rec.per_count := i.per_count;
            PIPE ROW (v_rec);
         END LOOP;
      ELSIF p_zone_type = 2
      THEN
         FOR i IN
            (SELECT   a.zone_no, a.occupancy_cd,
                      DECODE (a.occupancy_cd,
                              NULL, 'NO OCCUPANCY',
                              d.occupancy_desc
                             ) occ_code,
                      DECODE (p_by_count,
                              'R', COUNT (DISTINCT (   c.block_id
                                                    || NVL (c.risk_cd, '*')
                                           )
                                         ),
                              COUNT (DISTINCT c.item_no)
                             ) per_count
                 FROM gipi_polbasic main,
                      gipi_firestat_extract_dtl a,
                      giis_typhoon_zone b,
                      gipi_fireitem c,
                      giis_fire_occupancy d
                WHERE a.zone_no = b.typhoon_zone
                  AND a.zone_type = p_zone_type
                  AND a.as_of_sw = p_as_of_sw
                  AND a.fi_item_grp IS NOT NULL
                  AND main.policy_id = a.policy_id
                  AND a.policy_id = c.policy_id
                  AND a.item_no = c.item_no
                  AND a.occupancy_cd = d.occupancy_cd(+)
                  AND a.user_id = p_user_id
             GROUP BY a.zone_no, a.occupancy_cd, d.occupancy_desc
             ORDER BY a.zone_no, d.occupancy_desc)
         LOOP
            mjm := FALSE;
            v_rec.zone_no := i.zone_no;
            v_rec.occupancy_cd := i.occupancy_cd;
            v_rec.occ_code := i.occ_code;
            v_rec.per_count := i.per_count;
            PIPE ROW (v_rec);
         END LOOP;
      ELSE
         FOR i IN
            (SELECT   a.zone_no, a.occupancy_cd,
                      DECODE (a.occupancy_cd,
                              NULL, 'NO OCCUPANCY',
                              d.occupancy_desc
                             ) occ_code,
                      DECODE (p_by_count,
                              'R', COUNT (DISTINCT (   c.block_id
                                                    || NVL (c.risk_cd, '*')
                                           )
                                         ),
                              COUNT (DISTINCT c.item_no)
                             ) per_count
                 FROM gipi_polbasic main,
                      gipi_firestat_extract_dtl a,
                      giis_eqzone b,
                      gipi_fireitem c,
                      giis_fire_occupancy d
                WHERE a.zone_no = b.eq_zone
                  AND a.zone_type = p_zone_type
                  AND a.as_of_sw = p_as_of_sw
                  AND a.fi_item_grp IS NOT NULL
                  AND main.policy_id = a.policy_id
                  AND a.policy_id = c.policy_id
                  AND a.item_no = c.item_no
                  AND a.occupancy_cd = d.occupancy_cd(+)
                  AND a.user_id = p_user_id
             GROUP BY a.zone_no, a.occupancy_cd, d.occupancy_desc
             ORDER BY a.zone_no, d.occupancy_desc)
         LOOP
            mjm := FALSE;
            v_rec.zone_no := i.zone_no;
            v_rec.occupancy_cd := i.occupancy_cd;
            v_rec.occ_code := i.occ_code;
            v_rec.per_count := i.per_count;
            PIPE ROW (v_rec);
         END LOOP;
      END IF;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_gipir039d_record;

   FUNCTION get_fi_item_grp2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN fi_item_grp2_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_rec         fi_item_grp2_type;
      c             cur_typ;
      v_query       VARCHAR2 (1000);
      v_table       VARCHAR2 (50);
      v_column      VARCHAR2 (50);
      v_zone_type   NUMBER;
      v_as_of_sw    VARCHAR2 (10);
      v_user_id     VARCHAR2 (20);
   BEGIN
      v_zone_type := NVL (p_zone_type, 0);
      v_as_of_sw := NVL (p_as_of_sw, '-');
      v_user_id := NVL (p_user_id, '-');

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

      v_query :=
            'SELECT DISTINCT DECODE(a.fi_item_grp,''B'',''BUILDING'',''C'',''CONTENT'',''L'',''LOSS'') fi_item_grp'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d '
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' GROUP BY a.fi_item_grp'
         || ' ORDER BY 1';

      OPEN c FOR v_query;

      LOOP
         FETCH c
          INTO v_rec.fi_item_grp;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END get_fi_item_grp2;

   FUNCTION get_description_record (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN description_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_rec         description_type;
      c             cur_typ;
      v_query       VARCHAR2 (5000);
      v_table       VARCHAR2 (50);
      v_column      VARCHAR2 (50);
      v_zone_type   NUMBER;
      v_as_of_sw    VARCHAR2 (10);
      v_user_id     VARCHAR2 (20);
   BEGIN
      v_zone_type := NVL (p_zone_type, 0);
      v_as_of_sw := NVL (p_as_of_sw, '-');
      v_user_id := NVL (p_user_id, '-');

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

      v_query :=
            'SELECT DISTINCT 1, ''RETENTION'' DESCRIPTION'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.share_cd = 1'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' UNION'
         || ' SELECT DISTINCT 2, ''TREATY'' DESCRIPTION'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.share_cd NOT IN (1,999)'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' UNION'
         || ' SELECT DISTINCT 999, ''FACULTATIVE'' DESCRIPTION'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.share_cd =999'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' order by 1';

      OPEN c FOR v_query;

      LOOP
         FETCH c
          INTO v_rec.num, v_rec.description;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END get_description_record;

   FUNCTION get_fi_item_details (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2
   )
      RETURN fi_item_details_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_rec         fi_item_details_type;
      c             cur_typ;
      d             cur_typ;
      e             cur_typ;
      v_query       VARCHAR2 (5000);
      v_query_2     VARCHAR2 (5000);
      v_query_3     VARCHAR2 (5000);
      v_table       VARCHAR2 (50);
      v_column      VARCHAR2 (50);
      v_zone_type   NUMBER;
      v_as_of_sw    VARCHAR2 (10);
      v_user_id     VARCHAR2 (20);
      v_by_count    VARCHAR2 (20);
   BEGIN
      v_zone_type := NVL (p_zone_type, 0);
      v_as_of_sw := NVL (p_as_of_sw, '-');
      v_user_id := NVL (p_user_id, '-');
      v_by_count := NVL (p_by_count, '-');

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

      v_query :=
            'SELECT DISTINCT a.fi_item_grp'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' GROUP BY a.fi_item_grp'
         || ' ORDER BY 1';

      OPEN c FOR v_query;

      LOOP
         FETCH c
          INTO v_rec.fi_item_grp;

         v_query_2 :=
               'SELECT a.occupancy_cd, decode(a.occupancy_cd,null,''NO OCCUPANCY'', d.occupancy_desc) OCC_CODE,'
            || ' a.zone_no , decode('''
            || v_by_count
            || ''''
            || ', ''R'', count(distinct(c.block_id||NVL(c.risk_cd,''*''))), count(distinct c.item_no)) PER_COUNT,'
            || ' SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
            || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
            || v_table
            || ' b,  gipi_fireitem c, giis_fire_occupancy d'
            || ' WHERE a.zone_no = b.'
            || v_column
            || ' AND A.zone_type = '
            || v_zone_type
            || ' AND A.as_of_sw = '''
            || v_as_of_sw
            || ''''
            || ' AND a.fi_item_grp IS NOT NULL'
            || ' AND main.policy_id = a.policy_id'
            || ' AND a.policy_id = c.policy_id'
            || ' AND a.item_no = c.item_no'
            || ' AND a.occupancy_cd = d.occupancy_cd(+)'
            || ' AND a.user_id = '''
            || v_user_id
            || ''''
            || ' GROUP BY a.zone_no,  a.occupancy_cd, d.occupancy_desc'
            || ' ORDER BY a.zone_no, d.OCCUPANCY_DESC';

         OPEN d FOR v_query_2;

         LOOP
            FETCH d
             INTO v_rec.occupancy_cd, v_rec.occ_code, v_rec.zone_no,
                  v_rec.per_count, v_rec.total_tsi, v_rec.total_prem;

            v_query_3 :=
                  ' SELECT a.zone_no, a.occupancy_cd, decode(a.occupancy_cd,null,''NO OCCUPANCY'', d.occupancy_desc) OCC_CODE,'
               || ' DECODE('''
               || v_by_count
               || ''''
               || ', ''R'', count(distinct(c.block_id||NVL(c.risk_cd,''*''))), COUNT(distinct c.item_no)) PER_COUNT,'
               || ' a.fi_item_grp, SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
               || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
               || v_table
               || ' b,  gipi_fireitem c, giis_fire_occupancy d'
               || ' WHERE a.zone_no = b.'
               || v_column
               || ' AND A.zone_type = '
               || v_zone_type
               || ' AND A.as_of_sw = '''
               || v_as_of_sw
               || ''''
               || ' AND a.fi_item_grp IS NOT NULL'
               || ' AND main.policy_id = a.policy_id'
               || ' AND a.policy_id = c.policy_id'
               || ' AND a.item_no = c.item_no'
               || ' AND a.occupancy_cd = d.occupancy_cd(+)'
               || ' AND a.user_id = '''
               || v_user_id
               || ''''
               || ' AND a.fi_item_grp = '''
               || v_rec.fi_item_grp
               || ''''
               || ' AND decode(a.occupancy_cd,null,''NO OCCUPANCY'', d.occupancy_desc) = '''
               || v_rec.occ_code
               || ''''
               || ' AND a.zone_no = '''
               || v_rec.zone_no
               || ''''
               || ' GROUP BY a.zone_no, a.occupancy_cd, a.fi_item_grp, d.occupancy_desc'
               || ' ORDER BY a.zone_no, d.OCCUPANCY_DESC';

            OPEN e FOR v_query_3;

            LOOP
               FETCH e
                INTO v_rec.zone_no, v_rec.occupancy_cd, v_rec.occ_code,
                     v_rec.per_count, v_rec.fi_item_grp, v_rec.total_tsi,
                     v_rec.total_prem;

               EXIT WHEN e%NOTFOUND;
            END LOOP;

            EXIT WHEN d%NOTFOUND;
         END LOOP;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE e;

      CLOSE d;

      CLOSE c;
   END get_fi_item_details;

   FUNCTION get_share_details (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2
   )
      RETURN share_details_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_rec         share_details_type;
      c             cur_typ;
      d             cur_typ;
      e             cur_typ;
      v_query       VARCHAR2 (5000);
      v_query_2     VARCHAR2 (5000);
      v_query_3     VARCHAR2 (5000);
      v_table       VARCHAR2 (50);
      v_column      VARCHAR2 (50);
      v_zone_type   NUMBER;
      v_as_of_sw    VARCHAR2 (10);
      v_user_id     VARCHAR2 (20);
      v_by_count    VARCHAR2 (20);
   BEGIN
      v_zone_type := NVL (p_zone_type, 0);
      v_as_of_sw := NVL (p_as_of_sw, '-');
      v_user_id := NVL (p_user_id, '-');
      v_by_count := NVL (p_by_count, '-');

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

      v_query :=
            'SELECT DISTINCT 1, ''RETENTION'' DESCRIPTION'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.share_cd = 1'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' UNION'
         || ' SELECT DISTINCT 2, ''TREATY'' DESCRIPTION'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.share_cd NOT IN (1,999)'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' UNION'
         || ' SELECT DISTINCT 999, ''FACULTATIVE'' DESCRIPTION'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.share_cd =999'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' order by 1';

      OPEN c FOR v_query;

      LOOP
         FETCH c
          INTO v_rec.num, v_rec.description;

         v_query_2 :=
               ' SELECT a.occupancy_cd, decode(a.occupancy_cd,null,''NO OCCUPANCY'', d.occupancy_desc) OCC_CODE,'
            || ' a.zone_no, decode('''
            || v_by_count
            || ''''
            || ', ''R'', count(distinct(c.block_id||NVL(c.risk_cd,''*''))), count(distinct c.item_no)) PER_COUNT,'
            || ' SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
            || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a,'
            || v_table
            || ' b,  gipi_fireitem c, giis_fire_occupancy d, giis_dist_share e'
            || ' WHERE a.zone_no = b.'
            || v_column
            || ' AND A.zone_type = '
            || v_zone_type
            || ' AND A.as_of_sw = '''
            || v_as_of_sw
            || ''''
            || ' AND a.fi_item_grp IS NOT NULL'
            || ' AND main.policy_id = a.policy_id'
            || ' AND a.policy_id = c.policy_id'
            || ' AND a.item_no = c.item_no'
            || ' AND a.occupancy_cd = d.occupancy_cd(+)'
            || ' AND a.share_Cd = e.share_Cd'
            || ' AND main.line_cd = e.line_Cd'
            || ' AND a.user_id = '''
            || p_user_id
            || ''''
            || ' GROUP BY a.zone_no,  a.occupancy_cd, d.occupancy_desc'
            || ' ORDER BY a.zone_no, d.OCCUPANCY_DESC';

         OPEN d FOR v_query_2;

         LOOP
            FETCH d
             INTO v_rec.occupancy_cd, v_rec.occ_code, v_rec.zone_no,
                  v_rec.per_count, v_rec.total_tsi, v_rec.total_prem;

            v_query_3 :=
                  ' SELECT a.zone_no , a.occupancy_cd, decode(a.occupancy_cd,null,''NO OCCUPANCY'', d.occupancy_desc) OCC_CODE,'
               || ' DECODE('''
               || v_by_count
               || ''''
               || ', ''R'', count(distinct(c.block_id||NVL(c.risk_cd,''*''))), count(distinct c.item_no)) PER_COUNT,'
               || ' DECODE(a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'') DESCRIPTION,'
               || ' SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
               || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a,'
               || v_table
               || ' b,  gipi_fireitem c, giis_fire_occupancy d, giis_dist_share e'
               || ' WHERE a.zone_no = b.'
               || v_column
               || ' AND a.zone_type = '
               || v_zone_type
               || ' AND a.as_of_sw = '''
               || v_as_of_sw
               || ''''
               || ' AND a.fi_item_grp IS NOT NULL'
               || ' AND main.policy_id = a.policy_id'
               || ' AND a.policy_id = c.policy_id'
               || ' AND a.item_no = c.item_no'
               || ' AND a.occupancy_cd = d.occupancy_cd(+)'
               || ' AND a.share_Cd = e.share_Cd'
               || ' AND main.line_cd = e.line_Cd'
               || ' AND a.user_id = '''
               || v_user_id
               || ''''
               || ' AND decode(a.occupancy_cd,null,''NO OCCUPANCY'', d.occupancy_desc) = '''
               || v_rec.occ_code
               || ''''
               || ' AND a.zone_no = '''
               || v_rec.zone_no
               || ''''
               || ' AND DECODE(a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'') = '''
               || v_rec.description
               || ''''
               || ' GROUP BY a.zone_no, a.occupancy_cd, d.occupancy_desc, DECODE(a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'')'
               || ' ORDER BY a.zone_no, d.OCCUPANCY_DESC';

            OPEN e FOR v_query_3;

            LOOP
               FETCH e
                INTO v_rec.zone_no, v_rec.occupancy_cd, v_rec.occ_code,
                     v_rec.per_count, v_rec.description, v_rec.total_tsi,
                     v_rec.total_prem;

               EXIT WHEN e%NOTFOUND;
            END LOOP;

            EXIT WHEN d%NOTFOUND;
         END LOOP;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE e;

      CLOSE d;

      CLOSE c;
   END get_share_details;

   FUNCTION get_fi_item_totals (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN fi_item_totals_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_rec         fi_item_totals_type;
      c             cur_typ;
      d             cur_typ;
      e             cur_typ;
      v_query       VARCHAR2 (5000);
      v_query_2     VARCHAR2 (5000);
      v_query_3     VARCHAR2 (5000);
      v_table       VARCHAR2 (50);
      v_column      VARCHAR2 (50);
      v_zone_type   NUMBER;
      v_as_of_sw    VARCHAR2 (10);
      v_user_id     VARCHAR2 (20);
   BEGIN
      v_zone_type := NVL (p_zone_type, 0);
      v_as_of_sw := NVL (p_as_of_sw, '-');
      v_user_id := NVL (p_user_id, '-');

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

      v_query :=
            'SELECT DISTINCT a.fi_item_grp'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' GROUP BY a.fi_item_grp'
         || ' ORDER BY 1';

      OPEN c FOR v_query;

      LOOP
         FETCH c
          INTO v_rec.fi_item_grp;

         v_query_2 :=
               'SELECT a.occupancy_cd, decode(a.occupancy_cd,null,''NO OCCUPANCY'', d.occupancy_desc) OCC_CODE,'
            || ' a.zone_no, SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
            || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
            || v_table
            || ' b,  gipi_fireitem c, giis_fire_occupancy d'
            || ' WHERE a.zone_no = b.'
            || v_column
            || ' AND A.zone_type = '
            || v_zone_type
            || ' AND A.as_of_sw = '''
            || v_as_of_sw
            || ''''
            || ' AND a.fi_item_grp IS NOT NULL'
            || ' AND main.policy_id = a.policy_id'
            || ' AND a.policy_id = c.policy_id'
            || ' AND a.item_no = c.item_no'
            || ' AND a.occupancy_cd = d.occupancy_cd(+)'
            || ' AND a.user_id = '''
            || v_user_id
            || ''''
            || ' AND rownum = 1'
            || ' GROUP BY a.zone_no,  a.occupancy_cd, d.occupancy_desc'
            || ' ORDER BY a.zone_no, d.OCCUPANCY_DESC';

         OPEN d FOR v_query_2;

         LOOP
            FETCH d
             INTO v_rec.occupancy_cd, v_rec.occ_code, v_rec.zone_no,
                  v_rec.total_tsi, v_rec.total_prem;

            v_query_3 :=
                  'SELECT a.zone_no, a.fi_item_grp, SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
               || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a,'
               || v_table
               || ' b,  gipi_fireitem c, giis_fire_occupancy d'
               || ' WHERE a.zone_no = b.'
               || v_column
               || ' AND A.zone_type = '
               || v_zone_type
               || ' AND A.as_of_sw = '''
               || v_as_of_sw
               || ''''
               || ' AND a.fi_item_grp IS NOT NULL'
               || ' AND main.policy_id = a.policy_id'
               || ' AND a.policy_id = c.policy_id'
               || ' AND a.item_no = c.item_no'
               || ' AND a.occupancy_cd = d.occupancy_cd(+)'
               || ' AND a.user_id = '''
               || v_user_id
               || ''''
               || ' AND a.fi_item_grp = '''
               || v_rec.fi_item_grp
               || ''''
               || ' AND a.zone_no = '''
               || v_rec.zone_no
               || ''''
               || ' GROUP BY a.zone_no, a.fi_item_grp'
               || ' ORDER BY a.zone_no, a.fi_item_grp';

            OPEN e FOR v_query_3;

            LOOP
               FETCH e
                INTO v_rec.zone_no, v_rec.fi_item_grp, v_rec.total_tsi,
                     v_rec.total_prem;

               EXIT WHEN e%NOTFOUND;
            END LOOP;

            EXIT WHEN d%NOTFOUND;
         END LOOP;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE e;

      CLOSE d;

      CLOSE c;
   END get_fi_item_totals;

   FUNCTION get_share_totals (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN share_totals_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_rec         share_totals_type;
      c             cur_typ;
      d             cur_typ;
      e             cur_typ;
      v_query       VARCHAR2 (5000);
      v_query_2     VARCHAR2 (5000);
      v_query_3     VARCHAR2 (5000);
      v_table       VARCHAR2 (50);
      v_column      VARCHAR2 (50);
      v_zone_type   NUMBER;
      v_as_of_sw    VARCHAR2 (10);
      v_user_id     VARCHAR2 (20);
   BEGIN
      v_zone_type := NVL (p_zone_type, 0);
      v_as_of_sw := NVL (p_as_of_sw, '-');
      v_user_id := NVL (p_user_id, '-');

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

      v_query :=
            'SELECT DISTINCT 1, ''RETENTION'' DESCRIPTION'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.share_cd = 1'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' UNION'
         || ' SELECT DISTINCT 2, ''TREATY'' DESCRIPTION'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.share_cd NOT IN (1,999)'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' UNION'
         || ' SELECT DISTINCT 999, ''FACULTATIVE'' DESCRIPTION'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.share_cd =999'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' ORDER by 1';

      OPEN c FOR v_query;

      LOOP
         FETCH c
          INTO v_rec.num, v_rec.description;

         v_query_2 :=
               'SELECT a.occupancy_cd, decode(a.occupancy_cd,null,''NO OCCUPANCY'', d.occupancy_desc) OCC_CODE,'
            || ' a.zone_no, SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
            || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a,'
            || v_table
            || ' b,  gipi_fireitem c, giis_fire_occupancy d, giis_dist_share e'
            || ' WHERE a.zone_no = b.'
            || v_column
            || ' AND A.zone_type = '
            || v_zone_type
            || ' AND A.as_of_sw = '''
            || v_as_of_sw
            || ''''
            || ' AND a.fi_item_grp IS NOT NULL'
            || ' AND main.policy_id = a.policy_id'
            || ' AND a.policy_id = c.policy_id'
            || ' AND a.item_no = c.item_no'
            || ' AND a.occupancy_cd = d.occupancy_cd(+)'
            || ' AND a.share_Cd = e.share_Cd'
            || ' AND main.line_cd = e.line_Cd'
            || ' AND a.user_id = '''
            || p_user_id
            || ''''
            || ' AND rownum =1'
            || ' GROUP BY a.zone_no,  a.occupancy_cd, d.occupancy_desc'
            || ' ORDER BY a.zone_no, d.OCCUPANCY_DESC';

         OPEN d FOR v_query_2;

         LOOP
            FETCH d
             INTO v_rec.occupancy_cd, v_rec.occ_code, v_rec.zone_no,
                  v_rec.total_tsi, v_rec.total_prem;

            v_query_3 :=
                  'SELECT a.zone_no, 1, ''RETENTION'' DESCRIPTION, SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
               || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a,'
               || v_table
               || ' b,  gipi_fireitem c, giis_fire_occupancy d, giis_dist_share e'
               || ' WHERE a.zone_no = b.'
               || v_column
               || ' AND A.zone_type = '
               || v_zone_type
               || ' AND A.as_of_sw = '''
               || v_as_of_sw
               || ''''
               || ' AND a.fi_item_grp IS NOT NULL'
               || ' AND main.policy_id = a.policy_id'
               || ' AND a.policy_id = c.policy_id'
               || ' AND a.item_no = c.item_no'
               || ' AND a.occupancy_cd = d.occupancy_cd(+)'
               || ' AND a.share_Cd = e.share_Cd'
               || ' AND e.share_cd = 1'
               || ' AND main.line_cd = e.line_Cd'
               || ' AND a.user_id = '''
               || v_user_id
               || ''''
               || ' AND a.zone_no = '''
               || v_rec.zone_no
               || ''''
               || ' AND ''RETENTION'' = '''
               || v_rec.description
               || ''''
               || ' GROUP BY a.zone_no'
               || ' UNION'
               || ' SELECT a.zone_no, 2, ''TREATY'' DESCRIPTION, SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
               || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a,'
               || v_table
               || ' b,  gipi_fireitem c, giis_fire_occupancy d, giis_dist_share e'
               || ' WHERE a.zone_no = b.'
               || v_column
               || ' AND A.zone_type = '
               || v_zone_type
               || ' AND A.as_of_sw = '''
               || v_as_of_sw
               || ''''
               || ' AND a.fi_item_grp IS NOT NULL'
               || ' AND main.policy_id = a.policy_id'
               || ' AND a.policy_id = c.policy_id'
               || ' AND a.item_no = c.item_no'
               || ' AND a.occupancy_cd = d.occupancy_cd(+)'
               || ' AND a.share_Cd = e.share_Cd'
               || ' AND e.share_cd NOT IN (1,999)'
               || ' AND main.line_cd = e.line_Cd'
               || ' AND a.user_id = '''
               || v_user_id
               || ''''
               || ' AND a.zone_no = '''
               || v_rec.zone_no
               || ''''
               || ' AND ''TREATY'' = '''
               || v_rec.description
               || ''''
               || ' GROUP BY a.zone_no'
               || ' UNION'
               || ' SELECT a.zone_no, 999, ''FACULTATIVE'' DESCRIPTION, SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
               || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a,'
               || v_table
               || ' b,  gipi_fireitem c, giis_fire_occupancy d, giis_dist_share e'
               || ' WHERE a.zone_no = b.'
               || v_column
               || ' AND A.zone_type = '
               || v_zone_type
               || ' AND A.as_of_sw = '''
               || v_as_of_sw
               || ''''
               || ' AND a.fi_item_grp IS NOT NULL'
               || ' AND main.policy_id = a.policy_id'
               || ' AND a.policy_id = c.policy_id'
               || ' AND a.item_no = c.item_no'
               || ' AND a.occupancy_cd = d.occupancy_cd(+)'
               || ' AND a.share_Cd = e.share_Cd'
               || ' AND e.share_cd = 999'
               || ' AND main.line_cd = e.line_Cd'
               || ' AND a.user_id = '''
               || v_user_id
               || ''''
               || ' AND a.zone_no = '''
               || v_rec.zone_no
               || ''''
               || ' AND ''FACULTATIVE'' = '''
               || v_rec.description
               || ''''
               || ' GROUP BY a.zone_no'
               || ' ORDER BY 1, 2';

            OPEN e FOR v_query_3;

            LOOP
               FETCH e
                INTO v_rec.zone_no, v_rec.num, v_rec.description,
                     v_rec.total_tsi, v_rec.total_prem;

               EXIT WHEN e%NOTFOUND;
            END LOOP;

            EXIT WHEN d%NOTFOUND;
         END LOOP;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE e;

      CLOSE d;

      CLOSE c;
   END get_share_totals;

   FUNCTION get_fi_item_grand_totals (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN fi_item_grand_totals_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_rec         fi_item_grand_totals;
      c             cur_typ;
      v_query       VARCHAR2 (5000);
      v_table       VARCHAR2 (50);
      v_column      VARCHAR2 (50);
      v_zone_type   NUMBER;
      v_as_of_sw    VARCHAR2 (10);
      v_user_id     VARCHAR2 (20);
   BEGIN
      v_zone_type := NVL (p_zone_type, 0);
      v_as_of_sw := NVL (p_as_of_sw, '-');
      v_user_id := NVL (p_user_id, '-');

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

      v_query :=
            'SELECT count(main.policy_id) policy_count, SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a,'
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' GROUP BY a.fi_item_grp'
         || ' ORDER BY a.fi_item_grp';

      OPEN c FOR v_query;

      LOOP
         FETCH c
          INTO v_rec.policy_count, v_rec.total_tsi, v_rec.total_prem;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END get_fi_item_grand_totals;

   FUNCTION get_gross_grand_totals (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gross_grand_totals_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_rec         gross_grand_totals;
      c             cur_typ;
      v_query       VARCHAR2 (5000);
      v_table       VARCHAR2 (50);
      v_column      VARCHAR2 (50);
      v_zone_type   NUMBER;
      v_as_of_sw    VARCHAR2 (10);
      v_user_id     VARCHAR2 (20);
   BEGIN
      v_zone_type := NVL (p_zone_type, 0);
      v_as_of_sw := NVL (p_as_of_sw, '-');
      v_user_id := NVL (p_user_id, '-');

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

      v_query :=
            'SELECT SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.user_id = '''
         || v_user_id
         || '''';

      OPEN c FOR v_query;

      LOOP
         FETCH c
          INTO v_rec.total_tsi, v_rec.total_prem;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END get_gross_grand_totals;

   FUNCTION get_share_grand_totals (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN share_grand_totals_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_rec         share_grand_totals;
      c             cur_typ;
      v_query       VARCHAR2 (5000);
      v_table       VARCHAR2 (50);
      v_column      VARCHAR2 (50);
      v_zone_type   NUMBER;
      v_as_of_sw    VARCHAR2 (10);
      v_user_id     VARCHAR2 (20);
   BEGIN
      v_zone_type := NVL (p_zone_type, 0);
      v_as_of_sw := NVL (p_as_of_sw, '-');
      v_user_id := NVL (p_user_id, '-');

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

      v_query :=
            'SELECT SUM(a.share_tsi_amt) Total_tsi, SUM(a.share_prem_amt) Total_prem'
         || ' FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || v_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d, giis_dist_share e'
         || ' WHERE a.zone_no = b.'
         || v_column
         || ' AND A.zone_type = '
         || v_zone_type
         || ' AND A.as_of_sw = '''
         || v_as_of_sw
         || ''''
         || ' AND a.fi_item_grp IS NOT NULL'
         || ' AND main.policy_id = a.policy_id'
         || ' AND a.policy_id = c.policy_id'
         || ' AND a.item_no = c.item_no'
         || ' AND a.occupancy_cd = d.occupancy_cd(+)'
         || ' AND a.share_Cd = e.share_Cd'
         || ' AND main.line_cd = e.line_Cd'
         || ' AND a.user_id = '''
         || v_user_id
         || ''''
         || ' GROUP BY DECODE(DECODE(a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY''),''RETENTION'',1,''FACULTATIVE'',999,2)'
         || ' ORDER BY DECODE(DECODE(a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY''),''RETENTION'',1,''FACULTATIVE'',999,2)';

      OPEN c FOR v_query;

      LOOP
         FETCH c
          INTO v_rec.total_tsi, v_rec.total_prem;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END get_share_grand_totals;

   --Added by Pol Cruz 01.26.2015
   FUNCTION get_fi_item_details2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2,
      p_table       VARCHAR2,
      p_column      VARCHAR2,
      p_zone_no     VARCHAR2,
      p_occ_code    VARCHAR2
   )
      RETURN fi_item_details_tab PIPELINED
   IS
      v_query            VARCHAR (32767);

      TYPE v_rec IS RECORD (
         zone_no        gipi_firestat_extract_dtl.zone_no%TYPE,
         occupancy_cd   gipi_firestat_extract_dtl.occupancy_cd%TYPE,
         occ_code       giis_fire_occupancy.occupancy_desc%TYPE,
         per_count      NUMBER,
         fi_item_grp    gipi_firestat_extract_dtl.fi_item_grp%TYPE,
         total_tsi      NUMBER,
         total_prem     NUMBER
      );

      TYPE v_tab IS TABLE OF v_rec;

      v_tab_dum          v_tab;
      v                  fi_item_details_type;
      v_tot_total_tsi    NUMBER               := 0;
      v_tot_total_prem   NUMBER               := 0;
      v_tot_per_count    NUMBER               := 0;
   BEGIN
      v_query :=
            'SELECT a.zone_no, a.occupancy_cd,
                         DECODE (a.occupancy_cd, NULL, ''NO OCCUPANCY'', d.occupancy_desc) occ_code,
                         DECODE ('''
         || p_by_count
         || ''',
                                 ''R'', COUNT (DISTINCT (c.block_id || NVL (c.risk_cd, ''*''))),
                                 COUNT (DISTINCT c.item_no)) per_count,
                         a.fi_item_grp, SUM (a.share_tsi_amt) total_tsi,
                         SUM (a.share_prem_amt) total_prem
                    FROM gipi_polbasic main,
                         gipi_firestat_extract_dtl a,'
         || p_table
         || ' b,
                         gipi_fireitem c,
                         giis_fire_occupancy d
                   WHERE a.zone_no = b.'
         || p_column
         || '
                     AND a.zone_type = '
         || p_zone_type
         || ' 
                     AND a.as_of_sw = '''
         || p_as_of_sw
         || '''
                     AND a.fi_item_grp IS NOT NULL
                     AND main.policy_id = a.policy_id
                     AND a.policy_id = c.policy_id
                     AND a.item_no = c.item_no
                     AND a.occupancy_cd = d.occupancy_cd(+)
                     AND a.user_id = '''
         || p_user_id
         || '''
                     AND a.zone_no = '''
         || p_zone_no
         || '''
                     AND DECODE (a.occupancy_cd, NULL, ''NO OCCUPANCY'', d.occupancy_desc) LIKE '''
         || p_occ_code
         || '''
                GROUP BY a.zone_no, a.occupancy_cd, a.fi_item_grp, d.occupancy_desc
                ORDER BY a.fi_item_grp, a.zone_no, d.occupancy_desc';

      EXECUTE IMMEDIATE v_query
      BULK COLLECT INTO v_tab_dum;

      FOR j IN (SELECT SUBSTR (fi_item_grp, 1, 1) fi_item_grp
                  FROM TABLE (gipir039d_pkg.get_fi_item_grp2 (p_zone_type,
                                                              p_as_of_sw,
                                                              p_user_id
                                                             )
                             )
                UNION ALL
                SELECT 'G'
                  FROM DUAL)
      LOOP
         v.fi_item_grp := j.fi_item_grp;
         v.per_count := 0;
         v.total_tsi := 0;
         v.total_prem := 0;

         FOR counter IN 1 .. v_tab_dum.COUNT
         LOOP
            IF j.fi_item_grp = v_tab_dum (counter).fi_item_grp
            THEN
               v.fi_item_grp := v_tab_dum (counter).fi_item_grp;
               v.occupancy_cd := v_tab_dum (counter).occupancy_cd;
               v.occ_code := v_tab_dum (counter).occ_code;
               v.zone_no := v_tab_dum (counter).zone_no;
               v.per_count := v_tab_dum (counter).per_count;
               v.total_tsi := v_tab_dum (counter).total_tsi;
               v.total_prem := v_tab_dum (counter).total_prem;
               v_tot_per_count :=
                              v_tot_per_count + v_tab_dum (counter).per_count;
               v_tot_total_tsi :=
                              v_tot_total_tsi + v_tab_dum (counter).total_tsi;
               v_tot_total_prem :=
                            v_tot_total_prem + v_tab_dum (counter).total_prem;
            END IF;
         END LOOP;

         IF j.fi_item_grp = 'G'
         THEN
            v.per_count := v_tot_per_count;
            v.total_tsi := v_tot_total_tsi;
            v.total_prem := v_tot_total_prem;
         END IF;

         PIPE ROW (v);
      END LOOP;
   END get_fi_item_details2;

   FUNCTION get_fi_item_totals2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2,
      p_table       VARCHAR2,
      p_column      VARCHAR2,
      p_zone_no     VARCHAR2
   )
      RETURN fi_item_totals2_tab PIPELINED
   IS
      v_query            VARCHAR (32767);

      TYPE v_rec IS RECORD (
         zone_no       gipi_firestat_extract_dtl.zone_no%TYPE,
         per_count     NUMBER,
         fi_item_grp   gipi_firestat_extract_dtl.fi_item_grp%TYPE,
         total_tsi     NUMBER,
         total_prem    NUMBER
      );

      TYPE v_tab IS TABLE OF v_rec;

      v_tab_dum          v_tab;
      v                  fi_item_totals2_type;
      v_tot_total_tsi    NUMBER               := 0;
      v_tot_total_prem   NUMBER               := 0;
      v_tot_per_count    NUMBER               := 0;
   BEGIN
      v_query :=
            'SELECT a.zone_no,
                         DECODE ('''
         || p_by_count
         || ''',
                                 ''R'', COUNT (DISTINCT (c.block_id || NVL (c.risk_cd, ''*''))),
                                 COUNT (DISTINCT c.item_no)) per_count,
                         a.fi_item_grp, SUM (a.share_tsi_amt) total_tsi,
                         SUM (a.share_prem_amt) total_prem
                    FROM gipi_polbasic main,
                         gipi_firestat_extract_dtl a,'
         || p_table
         || ' b,
                         gipi_fireitem c,
                         giis_fire_occupancy d
                   WHERE a.zone_no = b.'
         || p_column
         || '
                     AND a.zone_type = '
         || p_zone_type
         || ' 
                     AND a.as_of_sw = '''
         || p_as_of_sw
         || '''
                     AND a.fi_item_grp IS NOT NULL
                     AND main.policy_id = a.policy_id
                     AND a.policy_id = c.policy_id
                     AND a.item_no = c.item_no
                     AND a.occupancy_cd = d.occupancy_cd(+)
                     AND a.user_id = '''
         || p_user_id
         || '''
                     AND a.zone_no = '''
         || p_zone_no
         || '''
                GROUP BY a.zone_no, a.fi_item_grp
                ORDER BY a.fi_item_grp, a.zone_no';

      EXECUTE IMMEDIATE v_query
      BULK COLLECT INTO v_tab_dum;

      FOR j IN (SELECT SUBSTR (fi_item_grp, 1, 1) fi_item_grp
                  FROM TABLE (gipir039d_pkg.get_fi_item_grp2 (p_zone_type,
                                                              p_as_of_sw,
                                                              p_user_id
                                                             )
                             )
                UNION ALL
                SELECT 'G'
                  FROM DUAL)
      LOOP
         v.per_count := 0;
         v.total_tsi := 0;
         v.total_prem := 0;

         FOR counter IN 1 .. v_tab_dum.COUNT
         LOOP
            IF j.fi_item_grp = v_tab_dum (counter).fi_item_grp
            THEN
               v.per_count := v_tab_dum (counter).per_count;
               v.total_tsi := v_tab_dum (counter).total_tsi;
               v.total_prem := v_tab_dum (counter).total_prem;
               v_tot_per_count :=
                              v_tot_per_count + v_tab_dum (counter).per_count;
               v_tot_total_tsi :=
                              v_tot_total_tsi + v_tab_dum (counter).total_tsi;
               v_tot_total_prem :=
                            v_tot_total_prem + v_tab_dum (counter).total_prem;
            END IF;
         END LOOP;

         IF j.fi_item_grp = 'G'
         THEN
            v.per_count := v_tot_per_count;
            v.total_tsi := v_tot_total_tsi;
            v.total_prem := v_tot_total_prem;
         END IF;

         PIPE ROW (v);
      END LOOP;
   END get_fi_item_totals2;

   FUNCTION get_share_details2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2,
      p_table       VARCHAR2,
      p_column      VARCHAR2,
      p_zone_no     VARCHAR2,
      p_occ_code    VARCHAR2
   )
      RETURN share_details_tab PIPELINED
   IS
      v_query     VARCHAR2 (32767);

      TYPE v_rec IS RECORD (
         zone_no        gipi_firestat_extract_dtl.zone_no%TYPE,
         occupancy_cd   gipi_firestat_extract_dtl.occupancy_cd%TYPE,
         occ_code       giis_fire_occupancy.occupancy_desc%TYPE,
         per_count      NUMBER,
         description    VARCHAR2 (100),
         total_tsi      NUMBER,
         total_prem     NUMBER
      );

      TYPE v_tab IS TABLE OF v_rec;

      v_tab_dum   v_tab;
      v           share_details_type;
   BEGIN
      v_query :=
            ' SELECT   a.zone_no, a.occupancy_cd,
                   DECODE (a.occupancy_cd, NULL, ''NO OCCUPANCY'', d.occupancy_desc) occ_code,
                   DECODE ('''
         || p_by_count
         || ''', ''R'', COUNT (DISTINCT (c.block_id || NVL (c.risk_cd, ''*''))), COUNT (DISTINCT c.item_no)) per_count,
                   DECODE (a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'') description,
                      SUM (a.share_tsi_amt) total_tsi, SUM (a.share_prem_amt) total_prem
                     FROM gipi_polbasic main,
                          gipi_firestat_extract_dtl a, '
         || p_table
         || ' b,
                          gipi_fireitem c,
                          giis_fire_occupancy d,
                          giis_dist_share e
                    WHERE a.zone_no = b.'
         || p_column
         || '
                      AND a.zone_type = '
         || p_zone_type
         || '
                      AND a.as_of_sw = '''
         || p_as_of_sw
         || '''
                      AND a.fi_item_grp IS NOT NULL
                      AND main.policy_id = a.policy_id
                      AND a.policy_id = c.policy_id
                      AND a.item_no = c.item_no
                      AND a.occupancy_cd = d.occupancy_cd(+)
                      AND a.share_cd = e.share_cd
                      AND main.line_cd = e.line_cd
                      AND a.user_id = '''
         || p_user_id
         || '''
                      AND a.zone_no = '''
         || p_zone_no
         || '''
                      AND DECODE (a.occupancy_cd, NULL, ''NO OCCUPANCY'', d.occupancy_desc) LIKE '''
         || p_occ_code
         || '''
                 GROUP BY a.zone_no,
                          a.occupancy_cd,
                          d.occupancy_desc,
                          DECODE (a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'')
                 ORDER BY a.zone_no, d.occupancy_desc';

      EXECUTE IMMEDIATE v_query
      BULK COLLECT INTO v_tab_dum;

      FOR i IN
         (SELECT *
            FROM TABLE (gipir039d_pkg.get_description_record (p_zone_type,
                                                              p_as_of_sw,
                                                              p_user_id
                                                             )
                       ))
      LOOP
         v.num := i.num;
         v.description := i.description;
         v.per_count := 0;
         v.total_prem := 0;
         v.total_tsi := 0;

         FOR j IN 1 .. v_tab_dum.COUNT
         LOOP
            IF i.description = v_tab_dum (j).description
            THEN
               v.per_count := v_tab_dum (j).per_count;
               v.total_prem := v_tab_dum (j).total_prem;
               v.total_tsi := v_tab_dum (j).total_tsi;
            END IF;
         END LOOP;

         PIPE ROW (v);
      END LOOP;
   END get_share_details2;

   FUNCTION get_share_details2_totals (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2,
      p_table       VARCHAR2,
      p_column      VARCHAR2,
      p_zone_no     VARCHAR2
   )
      RETURN fi_item_totals2_tab PIPELINED
   IS
      v_query     VARCHAR2 (32767);

      TYPE v_rec IS RECORD (
         zone_no       gipi_firestat_extract_dtl.zone_no%TYPE,
         per_count     NUMBER,
         description   VARCHAR2 (100),
         total_tsi     NUMBER,
         total_prem    NUMBER
      );

      TYPE v_tab IS TABLE OF v_rec;

      v_tab_dum   v_tab;
      v           fi_item_totals2_type;
   BEGIN
      v_query :=
            ' SELECT   a.zone_no,
                   DECODE ('''
         || p_by_count
         || ''', ''R'', COUNT (DISTINCT (c.block_id || NVL (c.risk_cd, ''*''))), COUNT (DISTINCT c.item_no)) per_count,
                   DECODE (a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'') description,
                      SUM (a.share_tsi_amt) total_tsi, SUM (a.share_prem_amt) total_prem
                     FROM gipi_polbasic main,
                          gipi_firestat_extract_dtl a, '
         || p_table
         || ' b,
                          gipi_fireitem c,
                          giis_fire_occupancy d,
                          giis_dist_share e
                    WHERE a.zone_no = b.'
         || p_column
         || '
                      AND a.zone_type = '
         || p_zone_type
         || '
                      AND a.as_of_sw = '''
         || p_as_of_sw
         || '''
                      AND a.fi_item_grp IS NOT NULL
                      AND main.policy_id = a.policy_id
                      AND a.policy_id = c.policy_id
                      AND a.item_no = c.item_no
                      AND a.occupancy_cd = d.occupancy_cd(+)
                      AND a.share_cd = e.share_cd
                      AND main.line_cd = e.line_cd
                      AND a.user_id = '''
         || p_user_id
         || '''
                      AND a.zone_no = '''
         || p_zone_no
         || '''
                 GROUP BY a.zone_no, DECODE (a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'')
                 ORDER BY a.zone_no';

      EXECUTE IMMEDIATE v_query
      BULK COLLECT INTO v_tab_dum;

      FOR i IN
         (SELECT *
            FROM TABLE (gipir039d_pkg.get_description_record (p_zone_type,
                                                              p_as_of_sw,
                                                              p_user_id
                                                             )
                       ))
      LOOP
         v.per_count := 0;
         v.total_prem := 0;
         v.total_tsi := 0;

         FOR j IN 1 .. v_tab_dum.COUNT
         LOOP
            IF i.description = v_tab_dum (j).description
            THEN
               v.per_count := v_tab_dum (j).per_count;
               v.total_prem := v_tab_dum (j).total_prem;
               v.total_tsi := v_tab_dum (j).total_tsi;
            END IF;
         END LOOP;

         PIPE ROW (v);
      END LOOP;
   END get_share_details2_totals;

   FUNCTION get_fi_item_grand_totals2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2,
      p_table       VARCHAR2,
      p_column      VARCHAR2
   )
      RETURN fi_item_totals2_tab PIPELINED
   IS
      v_query            VARCHAR (32767);

      TYPE v_rec IS RECORD (
         per_count     NUMBER,
         fi_item_grp   gipi_firestat_extract_dtl.fi_item_grp%TYPE,
         total_tsi     NUMBER,
         total_prem    NUMBER
      );

      TYPE v_tab IS TABLE OF v_rec;

      v_tab_dum          v_tab;
      v                  fi_item_totals2_type;
      v_tot_total_tsi    NUMBER               := 0;
      v_tot_total_prem   NUMBER               := 0;
      v_tot_per_count    NUMBER               := 0;
   BEGIN
      v_query :=
            'SELECT DECODE ('''
         || p_by_count
         || ''',
                                 ''R'', COUNT (DISTINCT (c.block_id || NVL (c.risk_cd, ''*''))),
                                 COUNT (DISTINCT c.item_no)) per_count,
                         a.fi_item_grp, SUM (a.share_tsi_amt) total_tsi,
                         SUM (a.share_prem_amt) total_prem
                    FROM gipi_polbasic main,
                         gipi_firestat_extract_dtl a,'
         || p_table
         || ' b,
                         gipi_fireitem c,
                         giis_fire_occupancy d
                   WHERE a.zone_no = b.'
         || p_column
         || '
                     AND a.zone_type = '
         || p_zone_type
         || ' 
                     AND a.as_of_sw = '''
         || p_as_of_sw
         || '''
                     AND a.fi_item_grp IS NOT NULL
                     AND main.policy_id = a.policy_id
                     AND a.policy_id = c.policy_id
                     AND a.item_no = c.item_no
                     AND a.occupancy_cd = d.occupancy_cd(+)
                     AND a.user_id = '''
         || p_user_id
         || '''
                GROUP BY a.fi_item_grp
                ORDER BY a.fi_item_grp';

      EXECUTE IMMEDIATE v_query
      BULK COLLECT INTO v_tab_dum;

      FOR j IN (SELECT SUBSTR (fi_item_grp, 1, 1) fi_item_grp
                  FROM TABLE (gipir039d_pkg.get_fi_item_grp2 (p_zone_type,
                                                              p_as_of_sw,
                                                              p_user_id
                                                             )
                             )
                UNION ALL
                SELECT 'G'
                  FROM DUAL)
      LOOP
         v.per_count := 0;
         v.total_tsi := 0;
         v.total_prem := 0;

         FOR counter IN 1 .. v_tab_dum.COUNT
         LOOP
            IF j.fi_item_grp = v_tab_dum (counter).fi_item_grp
            THEN
               v.per_count := v_tab_dum (counter).per_count;
               v.total_tsi := v_tab_dum (counter).total_tsi;
               v.total_prem := v_tab_dum (counter).total_prem;
               v_tot_per_count :=
                              v_tot_per_count + v_tab_dum (counter).per_count;
               v_tot_total_tsi :=
                              v_tot_total_tsi + v_tab_dum (counter).total_tsi;
               v_tot_total_prem :=
                            v_tot_total_prem + v_tab_dum (counter).total_prem;
            END IF;
         END LOOP;

         IF j.fi_item_grp = 'G'
         THEN
            v.per_count := v_tot_per_count;
            v.total_tsi := v_tot_total_tsi;
            v.total_prem := v_tot_total_prem;
         END IF;

         PIPE ROW (v);
      END LOOP;
   END get_fi_item_grand_totals2;

   FUNCTION get_share_grand_totals2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2,
      p_table       VARCHAR2,
      p_column      VARCHAR2
   )
      RETURN fi_item_totals2_tab PIPELINED
   IS
      v_query     VARCHAR2 (32767);

      TYPE v_rec IS RECORD (
         per_count     NUMBER,
         description   VARCHAR2 (100),
         total_tsi     NUMBER,
         total_prem    NUMBER
      );

      TYPE v_tab IS TABLE OF v_rec;

      v_tab_dum   v_tab;
      v           fi_item_totals2_type;
   BEGIN
      v_query :=
            ' SELECT DECODE ('''
         || p_by_count
         || ''', ''R'', COUNT (DISTINCT (c.block_id || NVL (c.risk_cd, ''*''))), COUNT (DISTINCT c.item_no)) per_count,
                          DECODE (a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'') description,
                          SUM (a.share_tsi_amt) total_tsi, SUM (a.share_prem_amt) total_prem
                     FROM gipi_polbasic main,
                          gipi_firestat_extract_dtl a, '
         || p_table
         || ' b,
                          gipi_fireitem c,
                          giis_fire_occupancy d,
                          giis_dist_share e
                    WHERE a.zone_no = b.'
         || p_column
         || '
                      AND a.zone_type = '
         || p_zone_type
         || '
                      AND a.as_of_sw = '''
         || p_as_of_sw
         || '''
                      AND a.fi_item_grp IS NOT NULL
                      AND main.policy_id = a.policy_id
                      AND a.policy_id = c.policy_id
                      AND a.item_no = c.item_no
                      AND a.occupancy_cd = d.occupancy_cd(+)
                      AND a.share_cd = e.share_cd
                      AND main.line_cd = e.line_cd
                      AND a.user_id = '''
         || p_user_id
         || '''
                 GROUP BY DECODE (a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'')';

      EXECUTE IMMEDIATE v_query
      BULK COLLECT INTO v_tab_dum;

      FOR i IN
         (SELECT *
            FROM TABLE (gipir039d_pkg.get_description_record (p_zone_type,
                                                              p_as_of_sw,
                                                              p_user_id
                                                             )
                       ))
      LOOP
         v.per_count := 0;
         v.total_prem := 0;
         v.total_tsi := 0;

         FOR j IN 1 .. v_tab_dum.COUNT
         LOOP
            IF i.description = v_tab_dum (j).description
            THEN
               v.per_count := v_tab_dum (j).per_count;
               v.total_prem := v_tab_dum (j).total_prem;
               v.total_tsi := v_tab_dum (j).total_tsi;
            END IF;
         END LOOP;

         PIPE ROW (v);
      END LOOP;
   END get_share_grand_totals2;

   FUNCTION get_gipir039d_record_v2 (
      p_zone_type   NUMBER,
      p_column      VARCHAR2,
      p_table       VARCHAR2,
      p_date        VARCHAR2,
      p_as_of       VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_by_count    VARCHAR2,
      p_where       VARCHAR2,
      p_inc_exp     VARCHAR2,
      p_inc_endt    VARCHAR2,
      p_date_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gipir039d_record_tab PIPELINED
   IS
      v_rec             gipir039d_record_type;
      mjm               BOOLEAN               := TRUE;
      v_expired_as_of   DATE               := TO_DATE (p_as_of, 'MM-DD-RRRR');
      v_period_start    DATE           := TO_DATE (p_from_date, 'MM-DD-RRRR');
      v_period_end      DATE             := TO_DATE (p_to_date, 'MM-DD-RRRR');
      v_loop            NUMBER := 0; --edgar 04/15/2015 SR 4318
      v_from            NUMBER := 0; --edgar 04/15/2015 SR 4318
      v_to              NUMBER := 0; --edgar 04/15/2015 SR 4318   
   BEGIN
   --modified previous and enclosed in FOR LOOP : edgar 05/22/2015 SR 4318     
        SELECT DECODE(((COUNT (*)-MOD(COUNT (*),7))/7),1,1,((COUNT (*)-MOD(COUNT (*),7))/7)+1) modulus
          INTO v_loop
          FROM (SELECT 1, fi_item_grp
                  FROM TABLE (gipir039d_pkg.get_fi_item_grp2_v2 (P_ZONE_TYPE,
                                                                 P_AS_OF_SW,
                                                                 P_USER_ID,
                                                                 P_FROM_DATE,
                                                                 P_TO_DATE,
                                                                 P_AS_OF
                                                                )
                             )    
                UNION
                SELECT 1, 'GROSS'
                  FROM dual
                UNION
                SELECT DISTINCT share_cd, share_name
                           FROM TABLE (gipir039d_pkg.get_fi_share_details2_v2 (P_ZONE_TYPE,
                                                                               P_AS_OF,
                                                                               P_FROM_DATE,
                                                                               P_TO_DATE,
                                                                               P_AS_OF_SW,
                                                                               P_BY_COUNT,
                                                                               P_USER_ID
                                                                              )
                                      ) );       
        v_from    := 1; --edgar 04/15/2015
        v_to      := v_from + 6; --edgar 04/15/2015                       
        FOR i IN 1 .. v_loop
        LOOP           
              mjm := FALSE;      
              v_rec.company_name := giacp.v ('COMPANY_NAME');
              v_rec.company_address := giacp.v ('COMPANY_ADDRESS');
              v_rec.row_from := v_from;
              v_rec.row_to   := v_to;
              v_from          := v_rec.row_to + 6;
              v_to            := v_from + 6;
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

              IF NVL (p_as_of_sw, 'N') = 'N'
              THEN
                 v_rec.date_title :=
                       'From '
                    || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-RRRR'),
                                'fmMonth DD, YYYY'
                               )
                    || ' To '
                    || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-RRRR'), 'fmMonth DD, YYYY');
              ELSE
                 v_rec.date_title :=
                       'As of '
                    || TO_CHAR (TO_DATE (p_as_of, 'MM-DD-RRRR'), 'fmMonth DD, YYYY');
              END IF;
         PIPE ROW (v_rec);
        END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_gipir039d_record_v2;

   FUNCTION get_fi_item_grp2_v2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2
   )
      RETURN fi_item_grp2_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_rec             fi_item_grp2_type;
      v_expired_as_of   DATE              := TO_DATE (p_as_of, 'MM-DD-RRRR');
      v_period_start    DATE           := TO_DATE (p_from_date, 'MM-DD-RRRR');
      v_period_end      DATE             := TO_DATE (p_to_date, 'MM-DD-RRRR');
   BEGIN
      FOR j IN
         (SELECT DISTINCT fi_item_grp, fi_item_grp_desc
                     FROM TABLE
                             (gipir039d_pkg.get_fi_item_details2_v2
                                                                 (p_zone_type,
                                                                  p_as_of,
                                                                  p_from_date,
                                                                  p_to_date,
                                                                  p_as_of_sw,
                                                                  NULL,
                                                                  p_user_id
                                                                 )
                             )
                 ORDER BY fi_item_grp ASC, fi_item_grp_desc)
      LOOP
         v_rec.fi_item_grp := j.fi_item_grp_desc;
         PIPE ROW (v_rec);
      END LOOP;
   END get_fi_item_grp2_v2;

   FUNCTION get_description_record_v2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2
   )
      RETURN description_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_rec             description_type;
      v_expired_as_of   DATE             := TO_DATE (p_as_of, 'MM-DD-RRRR');
      v_period_start    DATE           := TO_DATE (p_from_date, 'MM-DD-RRRR');
      v_period_end      DATE             := TO_DATE (p_to_date, 'MM-DD-RRRR');
   BEGIN
      FOR j IN
         (SELECT DISTINCT 1 row_num, share_cd, share_name dist_share_name
                     FROM TABLE
                             (gipir039d_pkg.get_fi_share_details2_v2
                                                                 (p_zone_type,
                                                                  p_as_of,
                                                                  p_from_date,
                                                                  p_to_date,
                                                                  p_as_of_sw,
                                                                  NULL,
                                                                  p_user_id
                                                                 )
                             )
                 ORDER BY share_cd)
      LOOP
         v_rec.num := j.row_num;
         v_rec.description := j.dist_share_name;
         PIPE ROW (v_rec);
      END LOOP;
   END get_description_record_v2;

   FUNCTION get_fi_item_details2_v2 (
      p_zone_type   NUMBER,
      p_as_of       VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_by_count    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gipir039d_record_tab PIPELINED
   IS
      v_rec             gipir039d_record_type;
      mjm               BOOLEAN               := TRUE;
      v_expired_as_of   DATE               := TO_DATE (p_as_of, 'MM-DD-RRRR');
      v_period_start    DATE           := TO_DATE (p_from_date, 'MM-DD-RRRR');
      v_period_end      DATE             := TO_DATE (p_to_date, 'MM-DD-RRRR');
   BEGIN
      FOR i IN (SELECT   zone_no, occupancy_cd, occ_code, fi_item_grp,
                         fi_item_grp_desc, SUM (share_tsi_amt) total_tsi,
                         SUM (share_prem_amt) total_prem,
                         DECODE (SUM (share_tsi_amt), 0, 0, 1) per_count
                    FROM (SELECT NVL (a.zone_no, 0) zone_no, a.occupancy_cd,
                                 DECODE (a.occupancy_cd,
                                         NULL, 'NO OCCUPANCY',
                                         a.occupancy_desc
                                        ) occ_code,
                                 fi_item_grp, fi_item_grp_desc,
                                 DECODE (p_by_count,
                                         'P', TO_CHAR (a.item_no),
                                         'R', a.block_id
                                          || '-'
                                          || NVL (a.risk_cd, '@@@@@@@'),
                                         ''
                                        ) risk_item,
                                 NVL (a.share_tsi_amt, 0) share_tsi_amt,
                                 NVL (a.share_prem_amt, 0) share_prem_amt
                            FROM gipi_firestat_extract_dtl_vw a
                           WHERE a.zone_type = p_zone_type
                             AND a.as_of_sw = p_as_of_sw
                             AND fi_item_grp IS NOT NULL
                             AND a.user_id = p_user_id
                             AND (       a.as_of_sw = 'Y'
                                     AND TRUNC (a.as_of_date) =
                                            NVL (v_expired_as_of,
                                                 a.as_of_date)
                                  OR     a.as_of_sw = 'N'
                                     AND TRUNC (a.date_from) =
                                             NVL (v_period_start, a.date_from)
                                     AND TRUNC (a.date_to) =
                                                 NVL (v_period_end, a.date_to)
                                 ))
                GROUP BY fi_item_grp,
                         fi_item_grp_desc,
                         zone_no,
                         occupancy_cd,
                         occ_code
                  HAVING SUM (share_tsi_amt) <> 0 OR SUM (share_prem_amt) <> 0
                ORDER BY fi_item_grp ASC,
                         fi_item_grp_desc,
                         zone_no,
                         occupancy_cd,
                         occ_code)
      LOOP
         mjm := FALSE;
         v_rec.zone_no := i.zone_no;
         v_rec.occupancy_cd := i.occupancy_cd;
         v_rec.occ_code := i.occ_code;
         v_rec.per_count := i.per_count;
         v_rec.total_tsi := i.total_tsi;
         v_rec.total_prem := i.total_prem;
         v_rec.fi_item_grp := i.fi_item_grp;
         v_rec.fi_item_grp_desc := i.fi_item_grp_desc;
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_fi_item_details2_v2;

   FUNCTION get_fi_share_details2_v2 (
      p_zone_type   NUMBER,
      p_as_of       VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_by_count    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gipir039d_record_tab PIPELINED
   IS
      v_rec             gipir039d_record_type;
      mjm               BOOLEAN               := TRUE;
      v_expired_as_of   DATE               := TO_DATE (p_as_of, 'MM-DD-RRRR');
      v_period_start    DATE           := TO_DATE (p_from_date, 'MM-DD-RRRR');
      v_period_end      DATE             := TO_DATE (p_to_date, 'MM-DD-RRRR');
   BEGIN
      FOR i IN (SELECT   zone_no, occupancy_cd, occ_code, share_cd,
                         dist_share_name, SUM (share_tsi_amt) total_tsi,
                         SUM (share_prem_amt) total_prem,
                         DECODE (SUM (share_tsi_amt), 0, 0, 1) per_count
                    FROM (SELECT a.zone_no, a.occupancy_cd,
                                 DECODE (a.occupancy_cd,
                                         NULL, 'NO OCCUPANCY',
                                         a.occupancy_desc
                                        ) occ_code,
                                 share_cd, dist_share_name,
                                 DECODE (p_by_count,
                                         'P', TO_CHAR (a.item_no),
                                         'R', a.block_id
                                          || '-'
                                          || NVL (a.risk_cd, '@@@@@@@'),
                                         ''
                                        ) risk_item,
                                 NVL (a.share_tsi_amt, 0) share_tsi_amt,
                                 NVL (a.share_prem_amt, 0) share_prem_amt
                            FROM gipi_firestat_extract_dtl_vw a
                           WHERE a.zone_type = p_zone_type
                             AND a.as_of_sw = p_as_of_sw
                             AND fi_item_grp IS NOT NULL
                             AND a.user_id = p_user_id
                             AND (       a.as_of_sw = 'Y'
                                     AND TRUNC (a.as_of_date) =
                                            NVL (v_expired_as_of,
                                                 a.as_of_date)
                                  OR     a.as_of_sw = 'N'
                                     AND TRUNC (a.date_from) =
                                             NVL (v_period_start, a.date_from)
                                     AND TRUNC (a.date_to) =
                                                 NVL (v_period_end, a.date_to)
                                 ))
                GROUP BY zone_no,
                         occupancy_cd,
                         occ_code,
                         share_cd,
                         dist_share_name
                  HAVING SUM (share_tsi_amt) <> 0 OR SUM (share_prem_amt) <> 0
                ORDER BY zone_no,
                         occupancy_cd,
                         occ_code,
                         share_cd,
                         dist_share_name)
      LOOP
         mjm := FALSE;
         v_rec.zone_no := i.zone_no;
         v_rec.occupancy_cd := i.occupancy_cd;
         v_rec.occ_code := i.occ_code;
         v_rec.per_count := i.per_count;
         v_rec.total_tsi := i.total_tsi;
         v_rec.total_prem := i.total_prem;
         v_rec.share_cd := i.share_cd;
         v_rec.share_name := i.dist_share_name;
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_fi_share_details2_v2;
   --added function for single query to be used in entire report : edgar 05/22/2015 SR 4318   
   FUNCTION get_fi_gipir039D_details (
      p_zone_type   NUMBER,
      p_as_of       VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_by_count    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gipir039d_record_tab PIPELINED   
   IS
      v_rec             gipir039d_record_type;
      mjm               BOOLEAN               := TRUE;
      v_expired_as_of   DATE               := TO_DATE (p_as_of, 'MM-DD-RRRR');
      v_period_start    DATE           := TO_DATE (p_from_date, 'MM-DD-RRRR');
      v_period_end      DATE             := TO_DATE (p_to_date, 'MM-DD-RRRR');
   BEGIN
      FOR i IN (
                SELECT   zone_no, occupancy_cd, occ_code, fi_item_grp, fi_item_grp_desc,
                         share_cd, dist_share_name, risk_item, SUM (share_tsi_amt) total_tsi,
                         SUM (share_prem_amt) total_prem,
                         DECODE (SUM (share_tsi_amt), 0, 0, 1) per_count, policy_no
                    FROM (SELECT a.line_cd
                               || '-'
                               || a.subline_cd
                               || '-'
                               || a.iss_cd
                               || '-'
                               || LTRIM (TO_CHAR (a.issue_yy, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                               || '-'
                               || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                                 NVL (a.zone_no, 0) zone_no, a.occupancy_cd,
                                 DECODE (a.occupancy_cd,
                                         NULL, 'NO OCCUPANCY',
                                         a.occupancy_desc
                                        ) occ_code,
                                 fi_item_grp, fi_item_grp_desc, share_cd, dist_share_name,
                                 DECODE (p_by_count,
                                         'P', TO_CHAR (a.item_no),
                                         'R', a.block_id || '-' || NVL (a.risk_cd, '@@@@@@@'),
                                         ''
                                        ) risk_item,
                                 NVL (a.share_tsi_amt, 0) share_tsi_amt,
                                 NVL (a.share_prem_amt, 0) share_prem_amt
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
                                     AND TRUNC (a.date_to) = NVL (v_period_end, a.date_to)
                                 ))
                GROUP BY fi_item_grp,
                         fi_item_grp_desc,
                         share_cd,
                         dist_share_name,
                         zone_no,
                         occupancy_cd,
                         occ_code,
                         policy_no,
                         risk_item
                  HAVING SUM (share_tsi_amt) <> 0 OR SUM (share_prem_amt) <> 0
                ORDER BY zone_no,
                         policy_no,
                         occupancy_cd,
                         occ_code,
                         fi_item_grp,
                         fi_item_grp_desc,
                         share_cd,
                         dist_share_name
      )
      LOOP
         mjm := FALSE;
         v_rec.zone_no := i.zone_no;
         v_rec.occupancy_cd := i.occupancy_cd;
         v_rec.occ_code := i.occ_code;
         v_rec.per_count := i.per_count;
         v_rec.total_tsi := i.total_tsi;
         v_rec.total_prem := i.total_prem;
         v_rec.share_cd := i.share_cd;
         v_rec.share_name := i.dist_share_name;
         v_rec.fi_item_grp := i.fi_item_grp;
         v_rec.fi_item_grp_desc := i.fi_item_grp_desc;         
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_fi_gipir039D_details;      
END;
/


