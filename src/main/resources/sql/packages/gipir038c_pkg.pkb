CREATE OR REPLACE PACKAGE BODY CPI.gipir038c_pkg
AS
   /** Created By:     Shan Bati
    ** Date Created:   09.20.2013
    ** Referenced By:  GIPIR038B - Fire Statistical Report
    **/
   FUNCTION populate_report (
      p_zone_type       giis_peril.zone_type%TYPE,
      p_as_of_sw        VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN report_tab PIPELINED
   AS
      rep                      report_type;
      v_print                  BOOLEAN                               := FALSE;
      v_days                   NUMBER;
      v_year                   VARCHAR2 (5);
      v_expired_as_of          DATE
                                   := TO_DATE (p_expired_as_of, 'MM-DD-RRRR');
      v_period_start           DATE := TO_DATE (p_period_start, 'MM-DD-RRRR');
      v_period_end             DATE   := TO_DATE (p_period_end, 'MM-DD-RRRR');
      v_peril_cd               gixx_firestat_summary.peril_cd%TYPE;
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
            rep.zone_type_eq := cgref.zone_type;
         END IF;
      END LOOP;

      BEGIN
         SELECT param_value_v
           INTO rep.company_name
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            rep.company_name := ' ';
      END;

      BEGIN
         SELECT param_value_v
           INTO rep.company_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            rep.company_address := NULL;
      END;

      BEGIN
         SELECT rv_meaning || ' STATISTICS'
           INTO rep.cf_title
           FROM cg_ref_codes
          WHERE rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
            AND rv_low_value = p_zone_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            rep.cf_title := ' ';
      END;

      IF p_as_of_sw = 'Y'
      THEN
         v_days := SYSDATE - v_expired_as_of;
      ELSE
         v_days := v_period_end - v_period_start;
      END IF;

      IF p_as_of_sw = 'Y'
      THEN
         v_year := TO_CHAR (v_expired_as_of, 'YYYY');
      ELSE
         v_year := TO_CHAR (v_period_end, 'YYYY');
      END IF;

      IF v_days < 364 AND p_as_of_sw = 'N'
      THEN
         rep.cf_header :=
               'DIRECT PREMIUMS WRITTEN FROM '
            || TO_CHAR (v_period_start, 'fmMonth DD, RRRR')
            || ' TO '
            || TO_CHAR (v_period_end, 'fmMonth DD, RRRR');
      ELSIF v_days = 364 OR v_days > 365
      THEN
         rep.cf_header := 'DIRECT PREMIUMS WRITTEN FOR THE YEAR ' || v_year;
      ELSIF v_days < 364 AND p_as_of_sw = 'Y'
      THEN
         rep.cf_header :=
               'DIRECT PREMIUMS WRITTEN AS OF '
            || TO_CHAR (v_expired_as_of, 'fmMonth DD, RRRR');
      END IF;

      FOR i IN (SELECT   1 priority, ab.eq_zone_type,
                         NVL (ac.rv_meaning,
                              'NO EARTHQUAKE ZONE TYPE'
                             ) eq_zone_type_desc,
                         DECODE
                               (p_zone_type,
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
                    FROM (SELECT   x.line_cd, x.subline_cd, x.iss_cd,
                                   x.issue_yy, x.pol_seq_no, x.renew_no,
                                   x.zone_no, x.tarf_cd,
                                   SUM (NVL (x.share_tsi_amt, 0)
                                       ) share_tsi_amt,
                                   SUM (NVL (x.share_prem_amt, 0)
                                       ) share_prem_amt,
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
                                        AND TRUNC (x.date_to) =
                                                          TRUNC (v_period_end)
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
                         DECODE
                               (p_zone_type,
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
                    FROM (SELECT   x.line_cd, x.subline_cd, x.iss_cd,
                                   x.issue_yy, x.pol_seq_no, x.renew_no,
                                   x.zone_no, x.tarf_cd,
                                   SUM (NVL (x.share_tsi_amt, 0)
                                       ) share_tsi_amt,
                                   SUM (NVL (x.share_prem_amt, 0)
                                       ) share_prem_amt,
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
                                        AND TRUNC (x.date_to) =
                                                          TRUNC (v_period_end)
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
                                        AND TRUNC (t.date_to) =
                                                          TRUNC (v_period_end)
                                       )
                                   )
                               AND NVL (t.tarf_cd, '') = NVL (y.tarf_cd, ''))
                UNION
                SELECT   2 priority, rv_low_value eq_zone_type,
                         r.rv_meaning eq_zone_type_desc,
                         s.tarf_cd tariff_interpretation, 0 pol_count,
                         0 aggregate_tsi, 0 aggregate_premium
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
                                        AND TRUNC (t.date_to) =
                                                          TRUNC (v_period_end)
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
         rep.cf_count := i.pol_count;
         rep.print_details := 'Y';
         v_print := TRUE;
         rep.tariff := i.tariff_interpretation;
         rep.sum_tsi_amt := i.aggregate_tsi;
         rep.sum_prem_amt := i.aggregate_prem;
         rep.eq_zone_type := i.eq_zone_type_desc;
         PIPE ROW (rep);
         NULL;
      END LOOP;

      IF v_print = FALSE
      THEN
         rep.print_details := 'N';
         PIPE ROW (rep);
      END IF;
   END populate_report;
END gipir038c_pkg;
/


