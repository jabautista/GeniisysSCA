CREATE OR REPLACE PACKAGE BODY CPI.gipir039b_pkg
AS
   FUNCTION get_gipir039b (p_zone_type VARCHAR2, p_as_of_sw VARCHAR2)
      RETURN gipir039b_tab PIPELINED
   IS
      v_list        gipir039b_type;
      v_not_exist   BOOLEAN        := TRUE;
   BEGIN
      IF p_zone_type = 1
      THEN
         FOR i IN
            (SELECT   COUNT
                         (DISTINCT a.line_cd
                           || '-'
                           || a.subline_cd
                           || '-'
                           || a.iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (a.issue_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                           || '-'
                           || LTRIM (TO_CHAR (a.renew_no, '09'))
                         ) policy_no1,
                      SUM (NVL (share_tsi_amt, TO_NUMBER ('0.00'))) sum_tsi,
                      SUM (NVL (share_prem_amt, TO_NUMBER ('0.00'))
                          ) sum_prem_amt,
                      b.zone_no, b.zone_type, b.fi_item_grp,
                      c.zone_grp zone_grp1                    --, b.policy_id
                 FROM gipi_polbasic a,
                      gipi_firestat_extract_dtl b,
                      giis_flood_zone c
                WHERE a.policy_id = b.policy_id
                  AND b.zone_type = p_zone_type
                  AND b.zone_no = c.flood_zone              --edgar 03/23/2015
                  AND b.as_of_sw = NVL (p_as_of_sw, 'N')
                  AND b.fi_item_grp IS NOT NULL
                  AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GIPIS901') =
                                                                             1
             GROUP BY b.zone_no,
                      b.zone_type,
                      b.fi_item_grp,
                      c.zone_grp                               --, b.policy_id
             ORDER BY c.zone_grp)
         LOOP
            v_not_exist := FALSE;
            v_list.policy_no := i.policy_no1;
            v_list.sum_tsi := i.sum_tsi;
            v_list.sum_prem_amt := i.sum_prem_amt;
            v_list.zone_no := i.zone_no;
            v_list.zone_type := i.zone_type;
            v_list.fi_item_grp := i.fi_item_grp;
            v_list.zone_grp1 := i.zone_grp1;

            FOR rec IN (SELECT rv_meaning
                          FROM cg_ref_codes
                         WHERE rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP'
                           AND rv_low_value = i.fi_item_grp)
            LOOP
               v_list.item_grp_name := rec.rv_meaning;
            END LOOP;

            IF i.zone_grp1 = 1
            THEN
               v_list.zone_grp_name := 'Zone A';
            ELSE
               v_list.zone_grp_name := 'Zone B';
            END IF;

            PIPE ROW (v_list);
         END LOOP;
      ELSIF p_zone_type = 2
      THEN
         FOR i IN
            (SELECT   COUNT
                         (DISTINCT a.line_cd
                           || '-'
                           || a.subline_cd
                           || '-'
                           || a.iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (a.issue_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                           || '-'
                           || LTRIM (TO_CHAR (a.renew_no, '09'))
                         ) policy_no1,
                      SUM (NVL (share_tsi_amt, TO_NUMBER ('0.00'))) sum_tsi,
                      SUM (NVL (share_prem_amt, TO_NUMBER ('0.00'))
                          ) sum_prem_amt,
                      b.zone_no, b.zone_type, b.fi_item_grp,
                      c.zone_grp zone_grp1                    --, b.policy_id
                 FROM gipi_polbasic a,
                      gipi_firestat_extract_dtl b,
                      giis_typhoon_zone c
                WHERE a.policy_id = b.policy_id
                  AND b.zone_type = p_zone_type
                  AND b.zone_no = c.typhoon_zone            --edgar 03/23/2015
                  AND b.as_of_sw = NVL (p_as_of_sw, 'N')
                  AND b.fi_item_grp IS NOT NULL
                  AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GIPIS901') =
                                                                             1
             GROUP BY b.zone_no,
                      b.zone_type,
                      b.fi_item_grp,
                      c.zone_grp                               --, b.policy_id
             ORDER BY c.zone_grp)
         LOOP
            v_not_exist := FALSE;
            v_list.policy_no := i.policy_no1;
            v_list.sum_tsi := i.sum_tsi;
            v_list.sum_prem_amt := i.sum_prem_amt;
            v_list.zone_no := i.zone_no;
            v_list.zone_type := i.zone_type;
            v_list.fi_item_grp := i.fi_item_grp;
            v_list.zone_grp1 := i.zone_grp1;

            FOR rec IN (SELECT rv_meaning
                          FROM cg_ref_codes
                         WHERE rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP'
                           AND rv_low_value = i.fi_item_grp)
            LOOP
               v_list.item_grp_name := rec.rv_meaning;
            END LOOP;

            IF i.zone_grp1 = 1
            THEN
               v_list.zone_grp_name := 'Zone A';
            ELSE
               v_list.zone_grp_name := 'Zone B';
            END IF;

            PIPE ROW (v_list);
         END LOOP;
      ELSE
         FOR i IN
            (SELECT   COUNT
                         (DISTINCT a.line_cd
                           || '-'
                           || a.subline_cd
                           || '-'
                           || a.iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (a.issue_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                           || '-'
                           || LTRIM (TO_CHAR (a.renew_no, '09'))
                         ) policy_no1,
                      SUM (NVL (share_tsi_amt, TO_NUMBER ('0.00'))) sum_tsi,
                      SUM (NVL (share_prem_amt, TO_NUMBER ('0.00'))
                          ) sum_prem_amt,
                      b.zone_no, b.zone_type, b.fi_item_grp,
                      c.zone_grp zone_grp1                    --, b.policy_id
                 FROM gipi_polbasic a,
                      gipi_firestat_extract_dtl b,
                      giis_eqzone c
                WHERE a.policy_id = b.policy_id
                  AND b.zone_type = p_zone_type
                  AND b.zone_no = c.eq_zone                 --edgar 03/23/2015
                  AND b.as_of_sw = NVL (p_as_of_sw, 'N')
                  AND b.fi_item_grp IS NOT NULL
                  AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GIPIS901') =
                                                                             1
             GROUP BY b.zone_no,
                      b.zone_type,
                      b.fi_item_grp,
                      c.zone_grp                               --, b.policy_id
             ORDER BY c.zone_grp)
         LOOP
            v_not_exist := FALSE;
            v_list.policy_no := i.policy_no1;
            v_list.sum_tsi := i.sum_tsi;
            v_list.sum_prem_amt := i.sum_prem_amt;
            v_list.zone_no := i.zone_no;
            v_list.zone_type := i.zone_type;
            v_list.fi_item_grp := i.fi_item_grp;
            v_list.zone_grp1 := i.zone_grp1;

            FOR rec IN (SELECT rv_meaning
                          FROM cg_ref_codes
                         WHERE rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP'
                           AND rv_low_value = i.fi_item_grp)
            LOOP
               v_list.item_grp_name := rec.rv_meaning;
            END LOOP;

            IF i.zone_grp1 = 1
            THEN
               v_list.zone_grp_name := 'Zone A';
            ELSE
               v_list.zone_grp_name := 'Zone B';
            END IF;

            PIPE ROW (v_list);
         END LOOP;
      END IF;

      IF v_not_exist
      THEN
         v_list.not_exist := 'y';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END;

   FUNCTION get_gipir039b_header (
      p_zone_type    VARCHAR2,
      p_date         VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_bus_cd       VARCHAR2
   )
      RETURN gipir039b_header_tab PIPELINED
   IS
      v_list   gipir039b_header_type;
   BEGIN
      SELECT param_value_v
        INTO v_list.company_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      SELECT param_value_v
        INTO v_list.company_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      IF p_zone_type = 1
      THEN
         v_list.report_title := 'Flood Accumulation Limit Summary';
      ELSIF p_zone_type = 2
      THEN
         v_list.report_title := 'Typhoon Accumulation Limit Summary';
      ELSIF p_zone_type = 3
      THEN
         v_list.report_title := 'Earthquake Accumulation Limit Summary';
      ELSIF p_zone_type = 4
      THEN
         v_list.report_title := 'Fire Accumulation Limit Summary';
      ELSIF p_zone_type = 5
      THEN                                         --modified edgar 04/15/2015
         v_list.report_title :=
                               'Typhoon and Flood Accumulation Limit Summary';
      ELSE
         v_list.report_title := 'No Report Title. Report Error:(9400936555)';
      END IF;

      IF /*p_date = '1' : replaced condition edgar 04/15/2015 */     p_from_date IS NOT NULL
                                                                 AND p_to_date IS NOT NULL
      THEN
         v_list.report_date :=
               'From '
            || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                        'fmMonth DD, YYYY'
                       )
            || ' To '
            || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'), 'fmMonth DD, YYYY');
      ELSE
         v_list.report_date :=
               'As of '
            || TO_CHAR (TO_DATE (p_as_of_date, 'MM-DD-YYYY'),
                        'fmMonth DD, YYYY'
                       );
      END IF;

      IF p_bus_cd = 1
      THEN
         v_list.report_bus_head := 'DIRECT BUSINESS ONLY';
      ELSIF p_bus_cd = 2
      THEN
         v_list.report_bus_head := 'ASSUMED BUSINESS ONLY';
      ELSIF p_bus_cd = 3
      THEN
         v_list.report_bus_head := 'DIRECT AND ASSUMED BUSINESS';
      ELSE
         v_list.report_bus_head := 'No Header. Report Error:(9400936555)';
      END IF;

      PIPE ROW (v_list);
      RETURN;
   END get_gipir039b_header;

   FUNCTION get_gipir039b_v2 (
      p_zone_type    VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir039b_tab PIPELINED
   IS
      v_list              gipir039b_type;
      v_not_exist         BOOLEAN        := TRUE;
      v_bldg_total_cnt    NUMBER (18);
      v_bldg_total_tsi    NUMBER (18, 2);
      v_bldg_total_prem   NUMBER (18, 2);
      v_cont_total_cnt    NUMBER (18);
      v_cont_total_tsi    NUMBER (18, 2);
      v_cont_total_prem   NUMBER (18, 2);
      v_loss_total_cnt    NUMBER (18);
      v_loss_total_tsi    NUMBER (18, 2);
      v_loss_total_prem   NUMBER (18, 2);
      v_date_from         DATE         := TO_DATE (p_from_date, 'MM-DD-YYYY');
      v_date_to           DATE           := TO_DATE (p_to_date, 'MM-DD-YYYY');
      v_as_of_date        DATE        := TO_DATE (p_as_of_date, 'MM-DD-YYYY');
   BEGIN
      FOR i IN (SELECT DISTINCT NVL (a.zone_grp, 0) zone_grp1,
                                NVL (a.zone_grp_desc,
                                     'NO ZONE GROUP'
                                    ) zone_grp_desc
                           FROM gipi_firestat_extract_dtl_vw a
                          WHERE a.zone_type = p_zone_type
                            AND a.as_of_sw = NVL (p_as_of_sw, 'N')
                            AND (       a.as_of_sw = 'Y'
                                    AND TRUNC (a.as_of_date) =
                                           TRUNC (NVL (v_as_of_date,
                                                       a.as_of_date
                                                      )
                                                 )
                                 OR     a.as_of_sw = 'N'
                                    AND TRUNC (a.date_from) =
                                           TRUNC (NVL (v_date_from,
                                                       a.date_from
                                                      )
                                                 )
                                    AND TRUNC (a.date_to) =
                                            TRUNC (NVL (v_date_to, a.date_to))
                                )
                            AND a.user_id = p_user_id
                            AND a.fi_item_grp IS NOT NULL
                       ORDER BY NVL (a.zone_grp, 0))
      LOOP
         v_not_exist := FALSE;
         v_list.zone_grp1 := i.zone_grp1;
         v_list.zone_grp_name := i.zone_grp_desc;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.not_exist := 'y';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END;

   FUNCTION get_gipir039b_2 (
      p_zone_type    VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_zone_grp     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir039b_tab PIPELINED
   IS
      v_list         gipir039b_type;
      v_not_exist    BOOLEAN        := TRUE;
      v_date_from    DATE           := TO_DATE (p_from_date, 'MM-DD-YYYY');
      v_date_to      DATE           := TO_DATE (p_to_date, 'MM-DD-YYYY');
      v_as_of_date   DATE           := TO_DATE (p_as_of_date, 'MM-DD-YYYY');
   BEGIN
      FOR i IN
         (SELECT   y.zone_type, y.zone_grp, y.zone_grp_desc, y.fi_item_grp,
                   y.zone_no, SUM (y.share_tsi_amt) sum_tsi,
                   SUM (y.share_prem_amt) sum_prem_amt,
                   SUM (y.cnt) policy_cnt
              FROM (SELECT   x.zone_type, x.zone_grp, x.zone_grp_desc,
                             x.fi_item_grp, x.zone_no, x.policy_no,
                             SUM (x.share_tsi_amt) share_tsi_amt,
                             SUM (x.share_prem_amt) share_prem_amt,
                             DECODE (SUM (x.share_tsi_amt), 0, 0, 1) cnt
                        FROM (SELECT    a.line_cd
                                     || '-'
                                     || a.subline_cd
                                     || '-'
                                     || a.iss_cd
                                     || '-'
                                     || LTRIM (TO_CHAR (a.issue_yy, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.pol_seq_no,
                                                        '0000009'
                                                       )
                                              )
                                     || '-'
                                     || LTRIM (   TO_CHAR (a.renew_no, '09')
                                               || a.item_no
                                              ) policy_no,
                                     NVL (a.share_tsi_amt, 0) share_tsi_amt,
                                     NVL (a.share_prem_amt, 0) share_prem_amt,
                                     NVL (a.zone_no, '0') zone_no,
                                     a.zone_type, a.fi_item_grp,
                                     NVL (a.zone_grp, '0') zone_grp,
                                     NVL (a.zone_grp_desc,
                                          'NO ZONE GROUP'
                                         ) zone_grp_desc
                                FROM gipi_firestat_extract_dtl_vw a
                               WHERE a.zone_type = p_zone_type
                                 AND a.as_of_sw = NVL (p_as_of_sw, 'N')
                                 AND (       a.as_of_sw = 'Y'
                                         AND TRUNC (a.as_of_date) =
                                                TRUNC (NVL (v_as_of_date,
                                                            a.as_of_date
                                                           )
                                                      )
                                      OR     a.as_of_sw = 'N'
                                         AND TRUNC (a.date_from) =
                                                TRUNC (NVL (v_date_from,
                                                            a.date_from
                                                           )
                                                      )
                                         AND TRUNC (a.date_to) =
                                                TRUNC (NVL (v_date_to,
                                                            a.date_to
                                                           )
                                                      )
                                     )
                                 AND a.user_id = p_user_id
                                 AND a.fi_item_grp IS NOT NULL
                                 AND NVL (a.zone_grp, '0') =
                                        NVL (p_zone_grp,
                                             NVL (a.zone_grp, '0'))) x
                    GROUP BY x.zone_type,
                             x.zone_grp,
                             x.zone_grp_desc,
                             x.fi_item_grp,
                             x.zone_no,
                             x.policy_no) y
          GROUP BY y.zone_type,
                   y.zone_grp,
                   y.zone_grp_desc,
                   y.fi_item_grp,
                   y.zone_no
            HAVING SUM (y.share_tsi_amt) <> 0 OR SUM (y.share_prem_amt) <> 0
          ORDER BY y.fi_item_grp, y.zone_no)
      LOOP
         v_not_exist := FALSE;
         v_list.policy_no := i.policy_cnt;
         v_list.sum_tsi := i.sum_tsi;
         v_list.sum_prem_amt := i.sum_prem_amt;
         v_list.zone_no := i.zone_no;
         v_list.zone_type := i.zone_type;
         v_list.fi_item_grp := i.fi_item_grp;
         v_list.zone_grp1 := i.zone_grp;

         FOR rec IN (SELECT rv_meaning
                       FROM cg_ref_codes
                      WHERE rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP'
                        AND rv_low_value = i.fi_item_grp)
         LOOP
            v_list.item_grp_name := rec.rv_meaning;
         END LOOP;

         v_list.zone_grp_name := i.zone_grp_desc;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.not_exist := 'y';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END;

   FUNCTION get_gipir039b_tot_by_zone_grp (
      p_zone_type    VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_zone_grp     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir039b_tab PIPELINED
   IS
      v_list        gipir039b_type;
      v_not_exist   BOOLEAN        := TRUE;
   BEGIN
      FOR i IN (SELECT   SUM (a.policy_no) group_cnt,
                         SUM (a.sum_tsi) group_tsi,
                         SUM (a.sum_prem_amt) group_prem,
                         a.zone_grp1 zone_grp
                    FROM TABLE (gipir039b_pkg.get_gipir039b_2 (p_zone_type,
                                                               p_as_of_sw,
                                                               p_zone_grp,
                                                               p_as_of_date,
                                                               p_from_date,
                                                               p_to_date,
                                                               p_user_id
                                                              )
                               ) a
                GROUP BY zone_grp1)
      LOOP
         v_not_exist := FALSE;
         v_list.zone_grp1 := i.zone_grp;
         v_list.sum_tsi_per_zone := i.group_tsi;
         v_list.sum_prem_per_zone := i.group_prem;
         v_list.sum_pol_per_zone := i.group_cnt;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.not_exist := 'y';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END;

   FUNCTION get_gipir039b_tot_by_item_grp (
      p_zone_type    VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_zone_grp     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir039b_tab PIPELINED
   IS
      v_list        gipir039b_type;
      v_not_exist   BOOLEAN        := TRUE;
   BEGIN
      FOR i IN (SELECT   SUM (a.policy_no) group_cnt,
                         SUM (a.sum_tsi) group_tsi,
                         SUM (a.sum_prem_amt) group_prem,
                         a.zone_grp1 zone_grp, a.fi_item_grp
                    FROM TABLE (gipir039b_pkg.get_gipir039b_2 (p_zone_type,
                                                               p_as_of_sw,
                                                               p_zone_grp,
                                                               p_as_of_date,
                                                               p_from_date,
                                                               p_to_date,
                                                               p_user_id
                                                              )
                               ) a
                GROUP BY a.zone_grp1, a.fi_item_grp
                ORDER BY a.zone_grp1, a.fi_item_grp)
      LOOP
         v_not_exist := FALSE;
         v_list.zone_grp1 := i.zone_grp;
         v_list.fi_item_grp := i.fi_item_grp;
         v_list.sum_tsi_per_grp := i.group_tsi;
         v_list.sum_prem_per_grp := i.group_prem;
         v_list.sum_pol_per_grp := i.group_cnt;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.not_exist := 'y';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END;

   FUNCTION get_gipir039b_tot_by_zone (
      p_zone_type    VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_zone_grp     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir039b_tab PIPELINED
   IS
      v_list        gipir039b_type;
      v_not_exist   BOOLEAN        := TRUE;
   BEGIN
      FOR i IN (SELECT   SUM (a.policy_no) group_cnt,
                         SUM (a.sum_tsi) group_tsi,
                         SUM (a.sum_prem_amt) group_prem,
                         a.zone_grp1 zone_grp, a.zone_no
                    FROM TABLE (gipir039b_pkg.get_gipir039b_2 (p_zone_type,
                                                               p_as_of_sw,
                                                               p_zone_grp,
                                                               p_as_of_date,
                                                               p_from_date,
                                                               p_to_date,
                                                               p_user_id
                                                              )
                               ) a
                GROUP BY a.zone_grp1, a.zone_no
                ORDER BY a.zone_grp1, a.zone_no)
      LOOP
         v_not_exist := FALSE;
         v_list.zone_grp1 := i.zone_grp;
         v_list.zone_no := i.zone_no;
         v_list.sum_tsi_zoneno := i.group_tsi;
         v_list.sum_prem_zoneno := i.group_prem;
         v_list.sum_pol_zoneno := i.group_cnt;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.not_exist := 'y';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END;

   FUNCTION get_gipir039b_summary (
      p_zone_type    VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir039b_tab PIPELINED
   IS
      v_list         gipir039b_type;
      v_not_exist    BOOLEAN        := TRUE;
      v_date_from    DATE           := TO_DATE (p_from_date, 'MM-DD-YYYY');
      v_date_to      DATE           := TO_DATE (p_to_date, 'MM-DD-YYYY');
      v_as_of_date   DATE           := TO_DATE (p_as_of_date, 'MM-DD-YYYY');
   BEGIN
      FOR x IN (SELECT   zone_type, fi_item_grp, SUM (policy_no) policy_cnt,
                         SUM (sum_tsi) share_tsi_amt,
                         SUM (sum_prem_amt) share_prem_amt
                    FROM TABLE (gipir039b_pkg.get_gipir039b_2 (p_zone_type,
                                                               p_as_of_sw,
                                                               NULL,
                                                               p_as_of_date,
                                                               p_from_date,
                                                               p_to_date,
                                                               p_user_id
                                                              )
                               )
                GROUP BY zone_type, fi_item_grp
                ORDER BY zone_type, fi_item_grp)
      LOOP
         v_not_exist := FALSE;
         v_list.zone_type := x.zone_type;
         v_list.fi_item_grp := x.fi_item_grp;
         v_list.total_cnt := x.policy_cnt;
         v_list.total_tsi := x.share_tsi_amt;
         v_list.total_prem := x.share_prem_amt;

         FOR rec IN (SELECT rv_meaning
                       FROM cg_ref_codes
                      WHERE rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP'
                        AND rv_low_value = x.fi_item_grp)
         LOOP
            v_list.item_grp_name := rec.rv_meaning;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.not_exist := 'y';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END;
END;
/


