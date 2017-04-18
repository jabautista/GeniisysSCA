CREATE OR REPLACE PACKAGE BODY cpi.gipir941_pkg
AS
   /*
      **  Created by   : Michael John R. Malicad
      **  Date Created : 09.16.2013
      **  Reference By : GIPIR941
      **  Description  : Risk Profile Per Line/Subline
      */
   FUNCTION cf_line_name (p_line_cd VARCHAR2)
      RETURN CHAR
   IS
      v_line_name   giis_line.line_name%TYPE;
   BEGIN
      BEGIN
         SELECT line_name
           INTO v_line_name
           FROM giis_line
          WHERE line_cd = p_line_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN (v_line_name);
   END;

   FUNCTION cf_subline_name (p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
      RETURN CHAR
   IS
      v_subline_name   giis_subline.subline_name%TYPE;
   BEGIN
      FOR a IN (SELECT subline_name
                  FROM giis_subline
                 WHERE subline_cd = p_subline_cd AND line_cd = p_line_cd)
      LOOP
         v_subline_name := a.subline_name;
      END LOOP;

      RETURN (v_subline_name);
   END;

   FUNCTION cf_tarf_desc (p_tarf_cd VARCHAR2)
      RETURN CHAR
   IS
      v_tarf_desc   giis_tariff.tarf_desc%TYPE;
   BEGIN
      FOR tarf IN (SELECT rv_meaning
                     FROM cg_ref_codes
                    WHERE rv_low_value = p_tarf_cd
                      AND rv_domain = 'GIIS_TARIFF.TARF_CD')
      LOOP
         v_tarf_desc := tarf.rv_meaning;
         EXIT;
      END LOOP;

      RETURN (v_tarf_desc);
   END;

   FUNCTION cf_from (
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user_id         VARCHAR2,
      p_range_to        NUMBER
   )
      RETURN CHAR
   IS
      v_over      VARCHAR2 (5);
      max_range   NUMBER;
   BEGIN
      FOR a IN (SELECT MAX (range_to) range_to
                  FROM gipi_risk_profile
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND date_from = TO_DATE(p_starting_date, 'MM-DD-RRRR')
                   AND date_to = TO_DATE(p_ending_date, 'MM-DD-RRRR')
                   AND user_id = p_user_id
                   AND range_to != 99999999999999.99)
      LOOP
         max_range := a.range_to;
         EXIT;
      END LOOP;

      v_over := 'OVER ';

      IF p_range_to != 99999999999999.99
      THEN
         RETURN (NULL);
      END IF;

      RETURN (v_over || LTRIM (TO_CHAR (max_range, '99,999,999,999,999.99')));
   END;

   FUNCTION cf_to (p_range_to NUMBER)
      RETURN CHAR
   IS
      v_over   VARCHAR2 (100);
   BEGIN
      v_over := '                                                           ';

      IF p_range_to != 99999999999999.99
      THEN
         RETURN (NULL);
      END IF;

      RETURN (v_over || '                ');
   END;

   FUNCTION get_gipir941_record (
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2, 
      p_all_line_tag    VARCHAR2, --benjo 05.22.2015 UW-SPECS-2015-047
      p_by_tarf         VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN gipir941_record_tab PIPELINED
   IS
      v_rec   gipir941_record_type;
      mjm     BOOLEAN              := TRUE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');
      v_rec.title :=
            'FROM '
         || TO_CHAR (TO_DATE (p_starting_date, 'MM-DD-YYYY'),
                     'fmMONTH DD, YYYY'
                    )
         || ' TO '
         || TO_CHAR (TO_DATE (p_ending_date, 'MM-DD-YYYY'),
                     'fmMONTH DD, YYYY');

      FOR i IN (SELECT   tarf_cd, line_cd, subline_cd, range_from, range_to,
                         policy_count, net_retention, quota_share,
                         facultative,
                         (  NVL (treaty, 0)
                          + NVL (treaty2_prem, 0)
                          + NVL (treaty3_prem, 0)
                          + NVL (treaty4_prem, 0)
                          + NVL (treaty5_prem, 0)
                          + NVL (treaty6_prem, 0)
                          + NVL (treaty7_prem, 0)
                          + NVL (treaty8_prem, 0)
                          + NVL (treaty9_prem, 0)
                          + NVL (treaty10_prem, 0)
                         ) treaty
                    FROM gipi_risk_profile
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                     AND NVL (subline_cd, '&') = NVL (p_subline_cd, NVL (subline_cd, '&')) --benjo 05.22.2015 added NVL('&')
                     AND date_from = TO_DATE (p_starting_date, 'MM-DD-YYYY')
                     AND date_to = TO_DATE (p_ending_date, 'MM-DD-YYYY')
                     AND all_line_tag = p_all_line_tag --benjo 05.22.2015 UW-SPECS-2015-047
                     AND user_id = p_user_id
                     AND (   NVL (p_by_tarf, 'N') <> 'Y'
                          OR (NVL (p_by_tarf, 'N') = 'Y'
                              AND tarf_cd IS NOT NULL
                             )
                         )
                ORDER BY line_cd, subline_cd, range_from)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.range_from := i.range_from;
         v_rec.range_to := i.range_to;
         v_rec.policy_count := i.policy_count;
         v_rec.tarf_cd := i.tarf_cd;
         v_rec.net_retention := i.net_retention;
         v_rec.quota_share := i.quota_share;
         v_rec.facultative := i.facultative;
         v_rec.treaty := i.treaty;
         v_rec.line_name := i.line_cd || ' - ' || cf_line_name (i.line_cd);
         v_rec.subline_name :=
            p_subline_cd || ' - '
            || cf_subline_name (p_line_cd, p_subline_cd);
         v_rec.tarf_desc := cf_tarf_desc (i.tarf_cd);
         v_rec.cf_from :=
            cf_from (i.line_cd,
                     i.subline_cd,
                     p_starting_date,
                     p_ending_date,
                     p_user_id,
                     i.range_to
                    );
         v_rec.cf_to := cf_to (i.range_to);
         mjm := FALSE;
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_gipir941_record;
END;