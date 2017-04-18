CREATE OR REPLACE PACKAGE BODY CPI.gipir934_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 09.16.2013
     **  Reference By : GIPIR934
     **  Description  : Risk Profile Per Peril
     */
   FUNCTION cf_paramdate (p_paramdate VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      IF p_paramdate = 'AD'
      THEN
         RETURN ('Accounting Entry Date');
      ELSIF p_paramdate = 'ED'
      THEN
         RETURN ('Effectivity Date');
      ELSIF p_paramdate = 'ID'
      THEN
         RETURN ('Issue Date');
      ELSIF p_paramdate = 'BD'
      THEN
         RETURN ('Booking Date');
      END IF;

      RETURN (' ');
   END;

   FUNCTION cf_line_name (p_line_cd VARCHAR2)
      RETURN CHAR
   IS
      v_line_name   giis_line.line_name%TYPE;
   BEGIN
      SELECT line_name
        INTO v_line_name
        FROM giis_line
       WHERE line_cd = p_line_cd;

      RETURN (v_line_name);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_line_name := ' ';
         RETURN (v_line_name);
   END;

   FUNCTION cf_subline_name (p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
      RETURN CHAR
   IS
      v_subline_name   giis_subline.subline_name%TYPE;
   BEGIN
      SELECT subline_name
        INTO v_subline_name
        FROM giis_subline
       WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd;

      RETURN (v_subline_name);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_subline_name := NULL;
         RETURN (v_subline_name);
   END;

   FUNCTION cf_tarf_name (p_tarf_cd VARCHAR2)
      RETURN CHAR
   IS
      v_tarf_name   cg_ref_codes.rv_meaning%TYPE;
   BEGIN
      FOR tarf IN (SELECT rv_meaning
                     FROM cg_ref_codes
                    WHERE rv_low_value = p_tarf_cd
                      AND rv_domain = 'GIIS_TARIFF.TARF_CD')
      LOOP
         RETURN (tarf.rv_meaning);
         EXIT;
      END LOOP;

      RETURN (NULL);
   END;

   FUNCTION cf_2formula (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_paramdate    VARCHAR2,
      p_user_id      VARCHAR2,
      p_range_from   NUMBER,
      p_range_to     NUMBER
   )
      RETURN NUMBER
   IS
   BEGIN
      IF p_subline_cd IS NULL
      THEN
         FOR x IN (SELECT SUM (peril_tsi) peril_tsi_sum
                     FROM gipi_risk_profile a, giis_peril b
                    WHERE a.line_cd = b.line_cd
                      AND a.peril_cd = b.peril_cd
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd IS NULL
                      AND date_from = p_from_date
                      AND date_to = p_to_date
                      AND a.user_id = p_user_id
                      AND all_line_tag = 'P'
                      AND b.peril_type = 'B'
                      AND a.range_from = p_range_from
                      AND a.range_to = p_range_to)
         LOOP
            RETURN x.peril_tsi_sum;
         END LOOP;
      ELSE
         FOR x IN (SELECT SUM (peril_tsi) peril_tsi_sum
                     FROM gipi_risk_profile a, giis_peril b
                    WHERE a.line_cd = b.line_cd
                      AND a.peril_cd = b.peril_cd
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                      AND date_from = p_from_date
                      AND date_to = p_to_date
                      AND a.user_id = p_user_id
                      AND all_line_tag = 'P'
                      AND b.peril_type = 'B'
                      AND a.range_from = p_range_from
                      AND a.range_to = p_range_to)
         LOOP
            RETURN x.peril_tsi_sum;
         END LOOP;
      END IF;

      RETURN NULL;
   END;

   FUNCTION get_gipir934_record (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_paramdate    VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir934_record_tab PIPELINED
   IS
      v_rec   gipir934_record_type;
      mjm     BOOLEAN              := TRUE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');
      v_rec.title :=
            'Based on '
         || cf_paramdate (p_paramdate)
         || ' From '
         || p_from_date
         || ' to '
         || p_to_date;
        
      v_rec.line_cd_fi  := GIISP.V('LINE_CODE_FI');

      FOR i IN (SELECT   a.line_cd, a.subline_cd, range_from, range_to,
                         policy_count, tarf_cd, b.peril_cd, b.peril_name,
                         peril_tsi, peril_prem, b.peril_type
                    FROM gipi_risk_profile a, giis_peril b
                   WHERE a.line_cd = b.line_cd
                     AND a.peril_cd = b.peril_cd
                     AND a.line_cd = p_line_cd
                     AND NVL (a.subline_cd, 'xx') =
                                  NVL (p_subline_cd, NVL (a.subline_cd, 'xx'))
                     AND date_from = TO_DATE (p_from_date, 'MM-DD-YYYY')
                     AND date_to = TO_DATE (p_to_date, 'MM-DD-YYYY')
                     AND a.user_id = p_user_id
                     AND all_line_tag = 'P'
                ORDER BY line_cd, subline_cd, tarf_cd, peril_cd)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.range_from := i.range_from;
         v_rec.range_to := i.range_to;
         v_rec.policy_count := i.policy_count;
         v_rec.tarf_cd := i.tarf_cd;
         v_rec.peril_cd := i.peril_cd;
         v_rec.peril_name := i.peril_name;
         v_rec.peril_tsi := i.peril_tsi;
         v_rec.peril_prem := i.peril_prem;
         v_rec.peril_type := i.peril_type;
         v_rec.line_name := cf_line_name (i.line_cd);
         v_rec.subline_name := cf_subline_name (i.line_cd, i.subline_cd);
         v_rec.tarf_name := cf_tarf_name (i.tarf_cd);
         v_rec.tsi_amt :=
            cf_2formula (p_line_cd,
                         p_subline_cd,
                         TO_DATE (p_from_date, 'MM-DD-YYYY'),
                         TO_DATE (p_to_date, 'MM-DD-YYYY'),
                         p_paramdate,
                         p_user_id,
                         i.range_from,
                         i.range_to
                        );
         mjm := FALSE;
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_gipir934_record;

   FUNCTION get_detail_record (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_paramdate    VARCHAR2,
      p_user_id      VARCHAR2,
      p_tarf_cd      VARCHAR2
   )
      RETURN detail_record_tab PIPELINED
   IS
      v_rec   detail_record_type;
      mjm     BOOLEAN            := TRUE;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.subline_cd, range_from, range_to,
                         policy_count, tarf_cd, b.peril_cd, b.peril_name,
                         peril_tsi, peril_prem, b.peril_type
                    FROM gipi_risk_profile a, giis_peril b
                   WHERE a.line_cd = b.line_cd
                     AND a.peril_cd = b.peril_cd
                     AND a.line_cd = p_line_cd
                     AND NVL (a.subline_cd, 'xx') =
                                  NVL (p_subline_cd, NVL (a.subline_cd, 'xx'))
                     AND date_from = TO_DATE (p_from_date, 'MM-DD-YYYY')
                     AND date_to = TO_DATE (p_to_date, 'MM-DD-YYYY')
                     AND a.user_id = p_user_id
                     AND all_line_tag = 'P'
                     AND tarf_cd = p_tarf_cd
                ORDER BY line_cd, subline_cd, tarf_cd, peril_cd)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.range_from := i.range_from;
         v_rec.range_to := i.range_to;
         v_rec.policy_count := i.policy_count;
         v_rec.tarf_cd := i.tarf_cd;
         v_rec.peril_cd := i.peril_cd;
         v_rec.peril_name := i.peril_name;
         v_rec.peril_tsi := i.peril_tsi;
         v_rec.peril_prem := i.peril_prem;
         v_rec.peril_type := i.peril_type;
         v_rec.line_name := cf_line_name (i.line_cd);
         v_rec.subline_name := cf_subline_name (i.line_cd, i.subline_cd);
         v_rec.tarf_name := cf_tarf_name (i.tarf_cd);
         v_rec.tsi_amt :=
            cf_2formula (p_line_cd,
                         p_subline_cd,
                         TO_DATE (p_from_date, 'MM-DD-YYYY'),
                         TO_DATE (p_to_date, 'MM-DD-YYYY'),
                         p_paramdate,
                         p_user_id,
                         i.range_from,
                         i.range_to
                        );
         mjm := FALSE;
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_detail_record;
END;
/


