CREATE OR REPLACE PACKAGE BODY CPI.gipir039c_pkg
AS
   FUNCTION get_gipir039c_dtls (
      as_of_sw      VARCHAR2,
      p_as_of       DATE,
      p_column      VARCHAR2,
      p_date        VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE,
      p_table       VARCHAR2,
      p_zone_type   VARCHAR2
   )
      RETURN gipir039c_dtls_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_gipir039c   gipir039c_dtls_type;
      custom        cur_typ;
      v_column      VARCHAR2 (50);
      v_table       VARCHAR2 (50);
      v_query       VARCHAR (10000);
      v_zone_grp    giis_flood_zone.zone_grp%TYPE;
   BEGIN
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
            'SELECT      a.line_cd
                         || ''-''
                         || a.subline_cd
                         || ''-''
                         || a.iss_cd
                         || ''-''
                         || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                         || ''-''
                         || LTRIM (TO_CHAR (a.pol_seq_no, ''0000009''))
                         || ''-''
                         || LTRIM (TO_CHAR (a.renew_no, ''09'')) policy_no1,
                         TO_CHAR (b.zone_no) zone_no, b.zone_type,
                         c.zone_grp zone_grp1, b.policy_id, c.zone_grp
           FROM gipi_firestat_extract_dtl b, 
                giis_dist_share d, '
         || v_table
         || ' c,
                gipi_polbasic a                          
          WHERE a.policy_id = b.policy_id 
            AND b.share_cd = d.share_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND a.line_cd = d.line_cd 
            AND b.zone_no = c.'
         || v_column
         || ' 
            AND b.zone_type = '''
         || p_zone_type
         || ''' 
            AND b.as_of_sw = '''
         || as_of_sw
         || ''' 
            AND fi_item_grp IS NOT NULL
            AND b.user_id = USER                 
            AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, ''GIPIS901'',USER) =1
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
       ORDER BY c.zone_grp';

      OPEN custom FOR v_query;

      LOOP
         FETCH custom
          INTO v_gipir039c.policy_no1, v_gipir039c.zone_no,
               v_gipir039c.zone_type, v_gipir039c.zone_grp1,
               v_gipir039c.policy_id, v_gipir039c.zone_grp;

         IF v_gipir039c.zone_grp = 1
         THEN
            v_gipir039c.cf_zone_grp := 'Zone A';
         ELSE
            v_gipir039c.cf_zone_grp := 'Zone B';
         END IF;

         BEGIN
            SELECT param_value_v
              INTO v_gipir039c.cf_company_name
              FROM giac_parameters
             WHERE param_name = 'COMPANY_NAME';
         END;

         BEGIN
            SELECT param_value_v
              INTO v_gipir039c.cf_company_address
              FROM giac_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         END;

         BEGIN
            IF p_zone_type = 1
            THEN
               v_gipir039c.cf_rep_title := 'Flood Accumulation Limit Summary';
            ELSIF p_zone_type = 2
            THEN
               v_gipir039c.cf_rep_title :=
                                         'Typhoon Accumulation Limit Summary';
            ELSIF p_zone_type = 3
            THEN
               v_gipir039c.cf_rep_title :=
                                      'Earthquake Accumulation Limit Summary';
            ELSIF p_zone_type = 4
            THEN
               v_gipir039c.cf_rep_title := 'Fire Accumulation Limit Summary';
            ELSE
               v_gipir039c.cf_rep_title :=
                               'Typhoon and Flood Accumulation Limit Summary';
            END IF;
         END;

         IF p_date = '1'
         THEN
            v_gipir039c.cf_date_title :=
                  'From '
               || TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
               || ' To '
               || TO_CHAR (p_to_date, 'fmMonth DD, YYYY');
         ELSE
            v_gipir039c.cf_date_title :=
                            'As of ' || TO_CHAR (p_as_of, 'fmMonth DD, YYYY');
         END IF;

         EXIT WHEN custom%NOTFOUND;
         PIPE ROW (v_gipir039c);
      END LOOP;

      CLOSE custom;

      RETURN;
   END get_gipir039c_dtls;

   FUNCTION get_gipir039c_title
      RETURN gipir039c_title_tab PIPELINED
   IS
      v_rec   gipir039c_title_type;
   BEGIN
      FOR i IN (SELECT DISTINCT DECODE (fi_item_grp,
                                        'B', 'BUILDING',
                                        'C', 'CONTENT',
                                        'L', 'LOSS'
                                       ) fi_item_grp
                           FROM gipi_firestat_extract_dtl
                          WHERE fi_item_grp IS NOT NULL AND user_id = USER
                UNION ALL
                SELECT   'Total'
                    FROM DUAL
                ORDER BY fi_item_grp)
      LOOP
         v_rec.fi_item_grp := i.fi_item_grp;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_gipir039c_title;

   FUNCTION get_figrp_amt (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_column      gipi_firestat_extract_dtl.zone_no%TYPE,
      p_table       VARCHAR2
   )
      RETURN gipi039c_figrp_amt_tab PIPELINED
   IS
      v_rec           gipi039c_figrp_amt;
      v_fi_item_grp   gipi_firestat_extract_dtl.fi_item_grp%TYPE;
      v_i_item_grp    gipi_firestat_extract_dtl.fi_item_grp%TYPE;
   BEGIN
      FOR i IN (SELECT DISTINCT zone_grp, zone_no, policy_id, fi_item_grp,
                                SUM (share_tsi_amt) share_tsi,
                                SUM (share_prem_amt) share_prem
                           FROM gipi_firestat_extract_dtl a,
                                giis_flood_zone b
                          WHERE a.zone_no = p_column
                            AND b.flood_zone = p_column
                            AND fi_item_grp IS NOT NULL
                            AND a.user_id = USER
                            AND a.share_cd = 1
                            AND policy_id = NVL (p_policy_id, policy_id)
                       GROUP BY zone_grp, zone_no, policy_id, fi_item_grp
                UNION ALL
                SELECT DISTINCT zone_grp, zone_no, policy_id, 'T',
                                SUM (share_tsi_amt) share_tsi,
                                SUM (share_prem_amt) share_prem
                           FROM gipi_firestat_extract_dtl a,
                                giis_flood_zone b,
                                giis_dist_share c
                          WHERE a.zone_no = flood_zone
                            AND b.flood_zone = p_column
                            AND fi_item_grp IS NOT NULL
                            AND a.user_id = USER
                            AND a.share_cd = c.share_cd
                            AND c.share_cd = 1
                            AND c.share_type = 1
                            AND c.line_cd = 'FI'
                            AND policy_id = NVL (p_policy_id, policy_id)
                       GROUP BY zone_grp, zone_no, policy_id, fi_item_grp)
      LOOP
         v_i_item_grp := NULL;
         v_i_item_grp := i.fi_item_grp;

         FOR j IN (SELECT DISTINCT DECODE (fi_item_grp,
                                           'B', 'BUILDING',
                                           'C', 'CONTENT',
                                           'L', 'LOSS'
                                          ) fi_item_grp,
                                   fi_item_grp fi_item_grp_cd
                              FROM gipi_firestat_extract_dtl
                             WHERE fi_item_grp IS NOT NULL AND user_id = USER
                   UNION ALL
                   SELECT   'Total', 'T' fi_item_grp_cd
                       FROM DUAL
                   ORDER BY fi_item_grp)
         LOOP
            v_rec.fi_item_grp := NULL;
            v_fi_item_grp := NULL;
            v_rec.policy_id := NULL;
            v_rec.share_tsi := NULL;
            v_rec.share_prem := NULL;
            v_rec.fi_item_grp := j.fi_item_grp;
            v_fi_item_grp := j.fi_item_grp_cd;

            IF v_i_item_grp <> v_fi_item_grp OR v_fi_item_grp IS NULL
            THEN
               v_rec.policy_id := i.policy_id;
               v_rec.share_tsi := 0;
               v_rec.share_prem := 0;
            ELSE
               v_rec.policy_id := i.policy_id;
               v_rec.share_tsi := i.share_tsi;
               v_rec.share_prem := i.share_prem;
            END IF;

            PIPE ROW (v_rec);
         END LOOP;
      END LOOP;

      RETURN;
   END get_figrp_amt;

   FUNCTION get_figrp_amt_total (
      p_item_grp   VARCHAR2,
      p_column     gipi_firestat_extract_dtl.zone_no%TYPE,
      p_table      VARCHAR2
   )
      RETURN gipi039c_figrp_amt_tab PIPELINED
   IS
      v_rec           gipi039c_figrp_amt;
      v_fi_item_grp   gipi_firestat_extract_dtl.fi_item_grp%TYPE;
   BEGIN
      FOR i IN (SELECT DISTINCT zone_grp, zone_no, policy_id, fi_item_grp,
                                SUM (share_tsi_amt) share_tsi,
                                SUM (share_prem_amt) share_prem,
                                DECODE (zone_grp,
                                        '1', 'Zone A',
                                        'Zone B'
                                       ) cf_itm_grp
                           FROM gipi_firestat_extract_dtl a,
                                giis_flood_zone b
                          WHERE 1 = 1
                            AND a.zone_no = p_column
                            AND b.flood_zone = p_column
                            AND fi_item_grp IS NOT NULL
                            AND a.user_id = USER
                            AND a.share_cd = 1
                            AND DECODE (zone_grp, '1', 'Zone A', 'Zone B') =
                                   NVL (p_item_grp,
                                        DECODE (zone_grp,
                                                '1', 'Zone A',
                                                'Zone B'
                                               )
                                       )
                       GROUP BY zone_grp, zone_no, policy_id, fi_item_grp
                UNION ALL
                SELECT DISTINCT zone_grp, zone_no, policy_id, 'T',
                                SUM (share_tsi_amt) share_tsi,
                                SUM (share_prem_amt) share_prem,
                                DECODE (zone_grp,
                                        '1', 'Zone A',
                                        'Zone B'
                                       ) cf_itm_grp
                           FROM gipi_firestat_extract_dtl a,
                                giis_flood_zone b,
                                giis_dist_share c
                          WHERE 1 = 1
                            AND a.zone_no = p_column
                            AND b.flood_zone = p_column
                            AND fi_item_grp IS NOT NULL
                            AND a.user_id = USER
                            AND a.share_cd = c.share_cd
                            AND c.share_cd = 1
                            AND c.share_type = 1
                            AND c.line_cd = 'FI'
                            AND DECODE (zone_grp, '1', 'Zone A', 'Zone B') =
                                   NVL (p_item_grp,
                                        DECODE (zone_grp,
                                                '1', 'Zone A',
                                                'Zone B'
                                               )
                                       )
                       GROUP BY zone_grp, zone_no, policy_id, fi_item_grp)
      LOOP
         FOR j IN (SELECT DISTINCT DECODE (fi_item_grp,
                                           'B', 'BUILDING',
                                           'C', 'CONTENT',
                                           'L', 'LOSS'
                                          ) fi_item_grp,
                                   fi_item_grp fi_item_grp_cd
                              FROM gipi_firestat_extract_dtl
                             WHERE fi_item_grp IS NOT NULL AND user_id = USER
                   UNION ALL
                   SELECT   'Total', 'T' fi_item_grp_cd
                       FROM DUAL
                   ORDER BY fi_item_grp)
         LOOP
            v_rec.fi_item_grp := '';
            v_fi_item_grp := '';
            v_rec.fi_item_grp := j.fi_item_grp;
            v_fi_item_grp := j.fi_item_grp_cd;

            IF i.fi_item_grp <> v_fi_item_grp OR v_fi_item_grp IS NULL
            THEN
               v_rec.policy_id := i.policy_id;
               v_rec.zone_grp := i.cf_itm_grp;
               v_rec.share_tsi := 0;
               v_rec.share_prem := 0;
            ELSE
               v_rec.policy_id := i.policy_id;
               v_rec.zone_grp := i.cf_itm_grp;
               v_rec.share_tsi := i.share_tsi;
               v_rec.share_prem := i.share_prem;
            END IF;

            PIPE ROW (v_rec);
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_figrp_amt_total;

   FUNCTION get_figrp_amt_gtotal (
      p_item_grp    VARCHAR2,
      p_column      gipi_firestat_extract_dtl.zone_no%TYPE,
      p_table       VARCHAR2,
      as_of_sw      VARCHAR2,
      p_zone_type   VARCHAR2
   )
      RETURN gipi039c_figrp_amt_tab PIPELINED
   IS
      v_rec   gipi039c_figrp_amt;
   BEGIN
      FOR i IN (SELECT DISTINCT DECODE (fi_item_grp,
                                        'B', 'BUILDING',
                                        'C', 'CONTENT',
                                        'L', 'LOSS'
                                       ) fi_item_grp,
                                fi_item_grp fi_item_grp_cd
                           FROM gipi_firestat_extract_dtl
                          WHERE fi_item_grp IS NOT NULL AND user_id = USER
                UNION ALL
                SELECT   'Total', 'T' fi_item_grp_cd
                    FROM DUAL
                ORDER BY fi_item_grp)
      LOOP
         IF i.fi_item_grp_cd = 'B'
         THEN
            v_rec.fi_item_grp := i.fi_item_grp;
            v_rec.share_tsi := get_cf_bldg_tsi_amt (as_of_sw, p_zone_type);
            v_rec.share_prem := get_cf_bldg_prem_amt (as_of_sw, p_zone_type);
         ELSIF i.fi_item_grp_cd = 'C'
         THEN
            v_rec.fi_item_grp := i.fi_item_grp;
            v_rec.share_tsi := get_cf_content_tsi_amt (as_of_sw, p_zone_type);
            v_rec.share_prem :=
                              get_cf_content_prem_amt (as_of_sw, p_zone_type);
         ELSIF i.fi_item_grp_cd = 'L'
         THEN
            v_rec.fi_item_grp := i.fi_item_grp;
            v_rec.share_tsi := get_cf_bldg_tsi_amt (as_of_sw, p_zone_type);
            v_rec.share_prem := get_cf_bldg_prem_amt (as_of_sw, p_zone_type);
         ELSIF i.fi_item_grp_cd = 'T'
         THEN
            v_rec.fi_item_grp := i.fi_item_grp;
            v_rec.share_tsi :=
                 NVL (get_cf_bldg_tsi_amt (as_of_sw, p_zone_type), 0)
               + NVL (get_cf_content_tsi_amt (as_of_sw, p_zone_type), 0)
               + NVL (get_cf_bldg_tsi_amt (as_of_sw, p_zone_type), 0);
            v_rec.share_prem :=
                 NVL (get_cf_bldg_prem_amt (as_of_sw, p_zone_type), 0)
               + NVL (get_cf_content_prem_amt (as_of_sw, p_zone_type), 0)
               + NVL (get_cf_bldg_prem_amt (as_of_sw, p_zone_type), 0);
         END IF;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_figrp_amt_gtotal;

   FUNCTION get_recap_dtl (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN gipir039c_recap_dtl_tab PIPELINED
   IS
      v_rec   gipir039c_recap_dtl;
   BEGIN
      v_rec.cf_bldg_pol_cnt := get_cf_bldg_pol_cnt (as_of_sw, p_zone_type);
      v_rec.cf_content_pol_cnt :=
                               get_cf_content_pol_cnt (as_of_sw, p_zone_type);
      v_rec.cf_loss_pol_cnt := get_cf_loss_pol_cnt (as_of_sw, p_zone_type);
      v_rec.cf_bldg_tsi_amt := get_cf_bldg_tsi_amt (as_of_sw, p_zone_type);
      v_rec.cf_content_tsi_amt :=
                               get_cf_content_tsi_amt (as_of_sw, p_zone_type);
      v_rec.cf_loss_tsi_amt := get_cf_loss_tsi_amt (as_of_sw, p_zone_type);
      v_rec.cf_bldg_prem_amt := get_cf_bldg_prem_amt (as_of_sw, p_zone_type);
      v_rec.cf_content_prem_amt :=
                              get_cf_content_prem_amt (as_of_sw, p_zone_type);
      v_rec.cf_loss_prem_amt := get_cf_loss_prem_amt (as_of_sw, p_zone_type);
      v_rec.cf_grand_pol_cnt := get_cf_grand_pol_cnt (as_of_sw, p_zone_type);
      v_rec.cf_grand_tsi_amt := get_cf_grand_tsi_amt (as_of_sw, p_zone_type);
      v_rec.cf_grand_prem_amt :=
                                get_cf_grand_prem_amt (as_of_sw, p_zone_type);
      PIPE ROW (v_rec);
      RETURN;
   END get_recap_dtl;

   FUNCTION get_cf_bldg_pol_cnt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER
   IS
      cnt             NUMBER       := 0;
      v_fi_item_grp   VARCHAR2 (1) := 'B';
   BEGIN
      IF p_zone_type = 1
      THEN
         FOR a IN (SELECT   1
                       FROM gipi_polbasic a,
                            gipi_firestat_extract_dtl b,
                            giis_flood_zone c,
                            giis_dist_share d
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = flood_zone
                        AND b.as_of_sw = as_of_sw
                        AND d.share_cd = b.share_cd
                        AND d.line_cd = a.line_cd
                        AND d.share_cd = 1
                        AND d.share_type = 1
                        AND b.user_id = USER
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
                            giis_typhoon_zone c,
                            giis_dist_share d
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = typhoon_zone
                        AND b.as_of_sw = as_of_sw
                        AND d.share_cd = b.share_cd
                        AND d.line_cd = a.line_cd
                        AND d.share_cd = 1
                        AND d.share_type = 1
                        AND b.user_id = USER
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
                            giis_eqzone c,
                            giis_dist_share d
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = eq_zone
                        AND b.as_of_sw = as_of_sw
                        AND d.share_cd = b.share_cd
                        AND d.line_cd = a.line_cd
                        AND d.share_cd = 1
                        AND d.share_type = 1
                        AND b.user_id = USER
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
   END get_cf_bldg_pol_cnt;

   FUNCTION get_cf_content_pol_cnt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER
   IS
      cnt             NUMBER       := 0;
      v_fi_item_grp   VARCHAR2 (1) := 'C';
   BEGIN
      IF p_zone_type = 1
      THEN
         FOR a IN (SELECT   1
                       FROM gipi_polbasic a,
                            gipi_firestat_extract_dtl b,
                            giis_flood_zone c,
                            giis_dist_share d
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = flood_zone
                        AND b.as_of_sw = as_of_sw
                        AND d.share_cd = b.share_cd
                        AND d.line_cd = a.line_cd
                        AND d.share_cd = 1
                        AND d.share_type = 1
                        AND b.user_id = USER
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
                            giis_typhoon_zone c,
                            giis_dist_share d
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = typhoon_zone
                        AND b.as_of_sw = as_of_sw
                        AND d.share_cd = b.share_cd
                        AND d.line_cd = a.line_cd
                        AND d.share_cd = 1
                        AND d.share_type = 1
                        AND b.user_id = USER
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
                            giis_eqzone c,
                            giis_dist_share d
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = eq_zone
                        AND b.as_of_sw = as_of_sw
                        AND d.share_cd = b.share_cd
                        AND d.line_cd = a.line_cd
                        AND d.share_cd = 1
                        AND d.share_type = 1
                        AND b.user_id = USER
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
   END get_cf_content_pol_cnt;

   FUNCTION get_cf_loss_pol_cnt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER
   IS
      cnt             NUMBER       := 0;
      v_fi_item_grp   VARCHAR2 (1) := 'L';
   BEGIN
      IF p_zone_type = 1
      THEN
         FOR a IN (SELECT   1
                       FROM gipi_polbasic a,
                            gipi_firestat_extract_dtl b,
                            giis_flood_zone c,
                            giis_dist_share d
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = flood_zone
                        AND b.as_of_sw = as_of_sw
                        AND d.share_cd = b.share_cd
                        AND d.line_cd = a.line_cd
                        AND d.share_cd = 1
                        AND d.share_type = 1
                        AND b.user_id = USER
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
                            giis_typhoon_zone c,
                            giis_dist_share d
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = typhoon_zone
                        AND b.as_of_sw = as_of_sw
                        AND d.share_cd = b.share_cd
                        AND d.line_cd = a.line_cd
                        AND d.share_cd = 1
                        AND d.share_type = 1
                        AND b.user_id = USER
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
                            giis_eqzone c,
                            giis_dist_share d
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = eq_zone
                        AND b.as_of_sw = as_of_sw
                        AND d.share_cd = b.share_cd
                        AND d.line_cd = a.line_cd
                        AND d.share_cd = 1
                        AND d.share_type = 1
                        AND b.user_id = USER
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
   END get_cf_loss_pol_cnt;

   FUNCTION get_cf_bldg_tsi_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER
   IS
      tsi_amt         NUMBER       := 0;
      v_fi_item_grp   VARCHAR2 (1) := 'B';
   BEGIN
      IF p_zone_type = 1
      THEN
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_flood_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = flood_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSIF p_zone_type = 2
      THEN
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_typhoon_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = typhoon_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSE
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_eqzone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = eq_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      END IF;

      RETURN (tsi_amt);
   END;

   FUNCTION get_cf_content_tsi_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER
   IS
      tsi_amt         NUMBER       := 0;
      v_fi_item_grp   VARCHAR2 (1) := 'C';
   BEGIN
      IF p_zone_type = 1
      THEN
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_flood_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = flood_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSIF p_zone_type = 2
      THEN
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_typhoon_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = typhoon_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSE
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_eqzone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = eq_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      END IF;

      RETURN (tsi_amt);
   END get_cf_content_tsi_amt;

   FUNCTION get_cf_loss_tsi_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER
   IS
      tsi_amt         NUMBER       := 0;
      v_fi_item_grp   VARCHAR2 (1) := 'L';
   BEGIN
      IF p_zone_type = 1
      THEN
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_flood_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = flood_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSIF p_zone_type = 2
      THEN
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_typhoon_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = typhoon_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSE
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_eqzone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = eq_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      END IF;

      RETURN (tsi_amt);
   END;

   FUNCTION get_cf_bldg_prem_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER
   IS
      prem_amt        NUMBER       := 0;
      v_fi_item_grp   VARCHAR2 (1) := 'B';
   BEGIN
      IF p_zone_type = 1
      THEN
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_flood_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = flood_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSIF p_zone_type = 2
      THEN
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_typhoon_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = typhoon_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSE
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_eqzone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = eq_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      END IF;

      RETURN (prem_amt);
   END get_cf_bldg_prem_amt;

   FUNCTION get_cf_content_prem_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER
   IS
      prem_amt        NUMBER       := 0;
      v_fi_item_grp   VARCHAR2 (1) := 'C';
   BEGIN
      IF p_zone_type = 1
      THEN
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_flood_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = flood_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSIF p_zone_type = 2
      THEN
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_typhoon_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = typhoon_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSE
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_eqzone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = eq_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      END IF;

      RETURN (prem_amt);
   END get_cf_content_prem_amt;

   FUNCTION get_cf_loss_prem_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER
   IS
      prem_amt        NUMBER       := 0;
      v_fi_item_grp   VARCHAR2 (1) := 'L';
   BEGIN
      IF p_zone_type = 1
      THEN
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_flood_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = flood_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSIF p_zone_type = 2
      THEN
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_typhoon_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = typhoon_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      ELSE
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_eqzone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = eq_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL
            AND b.fi_item_grp = v_fi_item_grp;
      END IF;

      RETURN (prem_amt);
   END get_cf_loss_prem_amt;

   FUNCTION get_cf_grand_pol_cnt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER
   IS
      cnt   NUMBER := 0;
   BEGIN
      IF p_zone_type = 1
      THEN
         FOR a IN (SELECT   1
                       FROM gipi_polbasic a,
                            gipi_firestat_extract_dtl b,
                            giis_flood_zone c,
                            giis_dist_share d
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = flood_zone
                        AND b.as_of_sw = as_of_sw
                        AND d.share_cd = b.share_cd
                        AND d.line_cd = a.line_cd
                        AND d.share_cd = 1
                        AND d.share_type = 1
                        AND b.user_id = USER
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
                            giis_typhoon_zone c,
                            giis_dist_share d
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = typhoon_zone
                        AND b.as_of_sw = as_of_sw
                        AND d.share_cd = b.share_cd
                        AND d.line_cd = a.line_cd
                        AND d.share_cd = 1
                        AND d.share_type = 1
                        AND b.user_id = USER
                        AND b.fi_item_grp IS NOT NULL
                   GROUP BY b.policy_id, fi_item_grp)
         LOOP
            cnt := cnt + 1;
         END LOOP;
      ELSE
         FOR a IN (SELECT   1
                       FROM gipi_polbasic a,
                            gipi_firestat_extract_dtl b,
                            giis_eqzone c,
                            giis_dist_share d
                      WHERE a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = eq_zone
                        AND b.as_of_sw = as_of_sw
                        AND d.share_cd = b.share_cd
                        AND d.line_cd = a.line_cd
                        AND d.share_cd = 1
                        AND d.share_type = 1
                        AND b.user_id = USER
                        AND b.fi_item_grp IS NOT NULL
                   GROUP BY b.policy_id, fi_item_grp)
         LOOP
            cnt := cnt + 1;
         END LOOP;
      END IF;

      RETURN (cnt);
   END get_cf_grand_pol_cnt;

   FUNCTION get_cf_grand_tsi_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
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
                giis_flood_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = flood_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL;
      ELSIF p_zone_type = 2
      THEN
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_typhoon_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = typhoon_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL;
      ELSE
         SELECT SUM (share_tsi_amt)
           INTO tsi_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_eqzone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = eq_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL;
      END IF;

      RETURN (tsi_amt);
   END get_cf_grand_tsi_amt;

   FUNCTION get_cf_grand_prem_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
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
                giis_flood_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = flood_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL;
      ELSIF p_zone_type = 2
      THEN
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_typhoon_zone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = typhoon_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL;
      ELSE
         SELECT SUM (share_prem_amt)
           INTO prem_amt
           FROM gipi_polbasic a,
                gipi_firestat_extract_dtl b,
                giis_eqzone c,
                giis_dist_share d
          WHERE a.policy_id = b.policy_id
            AND b.zone_type = p_zone_type
            AND b.zone_no = eq_zone
            AND b.as_of_sw = as_of_sw
            AND d.share_cd = b.share_cd
            AND d.line_cd = a.line_cd
            AND d.share_cd = 1
            AND d.share_type = 1
            AND b.user_id = USER
            AND b.fi_item_grp IS NOT NULL;
      END IF;

      RETURN (prem_amt);
   END get_cf_grand_prem_amt;
END;
/


