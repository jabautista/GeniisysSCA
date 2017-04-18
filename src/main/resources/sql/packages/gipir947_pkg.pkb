CREATE OR REPLACE PACKAGE BODY CPI.gipir947_pkg
AS
   /*
      **  Created by   : Michael John R. Malicad
      **  Date Created : 09.18.2013
      **  Reference By : GIPIR947
      **  Description  : Risk Profile Per Line
      */
   FUNCTION cf_param_date (p_param_date VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_param_date = 'AD'
      THEN
         RETURN ('ACCOUNTING ENTRY DATE');
      ELSIF p_param_date = 'ED'
      THEN
         RETURN ('EFFECTIVITY DATE');
      ELSIF p_param_date = 'ID'
      THEN
         RETURN ('ISSUE DATE');
      ELSIF p_param_date = 'BD'
      THEN
         RETURN ('BOOKING DATE');
      END IF;

      RETURN (' ');
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

   FUNCTION cf_sec_netret_amt (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (sec_net_retention_tsi + sec_net_retention_prem
                           ) amt
                  FROM gipi_risk_profile
                 WHERE user_id = p_user_id AND line_cd = p_line_cd)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty1_amt (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (treaty + treaty_tsi) amt
                  FROM gipi_risk_profile
                 WHERE user_id = p_user_id AND line_cd = p_line_cd)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty2_amt (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (treaty2_prem + treaty2_tsi) amt
                  FROM gipi_risk_profile
                 WHERE user_id = p_user_id AND line_cd = p_line_cd)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty3_amt (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (treaty3_prem + treaty3_tsi) amt
                  FROM gipi_risk_profile
                 WHERE user_id = p_user_id AND line_cd = p_line_cd)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty4_amt (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (treaty4_prem + treaty4_tsi) amt
                  FROM gipi_risk_profile
                 WHERE user_id = p_user_id AND line_cd = p_line_cd)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty5_amt (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (treaty5_prem + treaty5_tsi) amt
                  FROM gipi_risk_profile
                 WHERE user_id = p_user_id AND line_cd = p_line_cd)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty6_amt (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (treaty6_prem + treaty6_tsi) amt
                  FROM gipi_risk_profile
                 WHERE user_id = p_user_id AND line_cd = p_line_cd)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty7_amt (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (treaty7_prem + treaty7_tsi) amt
                  FROM gipi_risk_profile
                 WHERE user_id = p_user_id AND line_cd = p_line_cd)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_from (
      p_line_cd         VARCHAR2,
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
                   AND date_from = TO_DATE (p_starting_date, 'MM-DD-YYYY')
                   AND date_to = TO_DATE (p_ending_date, 'MM-DD-YYYY')
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
      v_over := '                                                          ';

      IF p_range_to != 99999999999999.99
      THEN
         RETURN (NULL);
      END IF;

      RETURN (v_over || '                ');
   END;

   FUNCTION get_gipir947_record (
      p_line_cd         VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_param_date      VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN gipir947_record_tab PIPELINED
   IS
      v_rec   gipir947_record_type;
      mjm     BOOLEAN              := TRUE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');
      v_rec.title :=
            cf_param_date (p_param_date)
         || ' FROM '
         || TO_CHAR (TO_DATE (p_starting_date, 'MM-DD-YYYY'),
                     'fmMONTH DD, YYYY'
                    )
         || ' TO '
         || TO_CHAR (TO_DATE (p_ending_date, 'MM-DD-YYYY'),
                     'fmMONTH DD, YYYY');

      FOR i IN (SELECT   tarf_cd, line_cd tarf_line, line_cd, range_from,
                         range_to, policy_count,
                         NVL (net_retention, 0) net_retention,
                         NVL (net_retention_tsi, 0) net_retention_tsi,
                         NVL (sec_net_retention_tsi, 0) sec_net_retention_tsi,
                         NVL (sec_net_retention_prem,
                              0
                             ) sec_net_retention_prem,
                         NVL (quota_share, 0) quota_share,
                         NVL (quota_share_tsi, 0) quota_share_tsi,
                         NVL (facultative, 0) facultative,
                         NVL (facultative_tsi, 0) facultative_tsi,
                         NVL (treaty, 0) treaty_prem,
                         NVL (treaty_tsi, 0) treaty_tsi,
                         NVL (treaty2_prem, 0) treaty2_prem,
                         NVL (treaty2_tsi, 0) treaty2_tsi,
                         NVL (treaty3_tsi, 0) treaty3_tsi,
                         NVL (treaty3_prem, 0) treaty3_prem,
                         NVL (treaty4_tsi, 0) treaty4_tsi,
                         NVL (treaty4_prem, 0) treaty4_prem,
                         NVL (treaty5_tsi, 0) treaty5_tsi,
                         NVL (treaty5_prem, 0) treaty5_prem,
                         NVL (treaty6_tsi, 0) treaty6_tsi,
                         NVL (treaty6_prem, 0) treaty6_prem,
                         NVL (treaty7_tsi, 0) treaty7_tsi,
                         NVL (treaty7_prem, 0) treaty7_prem,
                         NVL (treaty8_tsi, 0) treaty8_tsi,
                         NVL (treaty8_prem, 0) treaty8_prem,
                         NVL (treaty9_tsi, 0) treaty9_tsi,
                         NVL (treaty9_prem, 0) treaty9_prem,
                         NVL (treaty10_tsi, 0) treaty10_tsi,
                         NVL (treaty10_prem, 0) treaty10_prem,
                         net_retention_cnt, facultative_cnt, treaty_cnt,
                         treaty2_cnt, treaty3_cnt, treaty4_cnt, treaty5_cnt,
                         treaty6_cnt, treaty7_cnt, treaty8_cnt, treaty9_cnt,
                         treaty10_cnt, trty_name, trty2_name, trty3_name,
                         trty4_name, trty5_name, trty6_name, trty7_name,
                         trty8_name, trty9_name, trty10_name
                    FROM gipi_risk_profile
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                     AND date_from = TO_DATE (p_starting_date, 'MM-DD-YYYY')
                     AND date_to = TO_DATE (p_ending_date, 'MM-DD-YYYY')
                     AND user_id = p_user_id
                     AND subline_cd IS NULL
                     AND all_line_tag = 'Y'
                     AND (   NVL (p_by_tarf, 'N') <> 'Y'
                          OR (NVL (p_by_tarf, 'N') = 'Y'
                              AND tarf_cd IS NOT NULL
                             )
                         )
                ORDER BY tarf_cd, line_cd, range_to ASC)
      LOOP
         v_rec.tarf_cd := i.tarf_cd;
         v_rec.tarf_line := i.tarf_line;
         v_rec.line_cd := i.line_cd;
         v_rec.range_from := i.range_from;
         v_rec.range_to := i.range_to;
         v_rec.policy_count := i.policy_count;
         v_rec.tarf_desc := cf_tarf_desc (i.tarf_cd);
         v_rec.line_name := i.line_cd || ' - ' || cf_line_name (i.line_cd);
         v_rec.net_retention := i.net_retention;
         v_rec.net_retention_tsi := i.net_retention_tsi;
         v_rec.sec_net_retention_tsi := i.sec_net_retention_tsi;
         v_rec.sec_net_retention_prem := i.sec_net_retention_prem;
         v_rec.quota_share := i.quota_share;
         v_rec.quota_share_tsi := i.quota_share_tsi;
         v_rec.facultative := i.facultative;
         v_rec.facultative_tsi := i.facultative_tsi;
         v_rec.net_retention_cnt := i.net_retention_cnt;
         v_rec.facultative_cnt := i.facultative_cnt;
         v_rec.treaty_prem := i.treaty_prem;
         v_rec.treaty2_prem := i.treaty2_prem;
         v_rec.treaty3_prem := i.treaty3_prem;
         v_rec.treaty4_prem := i.treaty4_prem;
         v_rec.treaty5_prem := i.treaty5_prem;
         v_rec.treaty6_prem := i.treaty6_prem;
         v_rec.treaty7_prem := i.treaty7_prem;
         v_rec.treaty8_prem := i.treaty8_prem;
         v_rec.treaty9_prem := i.treaty9_prem;
         v_rec.treaty10_prem := i.treaty10_prem;
         v_rec.treaty_tsi := i.treaty_tsi;
         v_rec.treaty2_tsi := i.treaty2_tsi;
         v_rec.treaty3_tsi := i.treaty3_tsi;
         v_rec.treaty4_tsi := i.treaty4_tsi;
         v_rec.treaty5_tsi := i.treaty5_tsi;
         v_rec.treaty6_tsi := i.treaty6_tsi;
         v_rec.treaty7_tsi := i.treaty7_tsi;
         v_rec.treaty8_tsi := i.treaty8_tsi;
         v_rec.treaty9_tsi := i.treaty9_tsi;
         v_rec.treaty10_tsi := i.treaty10_tsi;
         v_rec.treaty_cnt := i.treaty_cnt;
         v_rec.treaty2_cnt := i.treaty2_cnt;
         v_rec.treaty3_cnt := i.treaty3_cnt;
         v_rec.treaty4_cnt := i.treaty4_cnt;
         v_rec.treaty5_cnt := i.treaty5_cnt;
         v_rec.treaty6_cnt := i.treaty6_cnt;
         v_rec.treaty7_cnt := i.treaty7_cnt;
         v_rec.treaty8_cnt := i.treaty8_cnt;
         v_rec.treaty9_cnt := i.treaty9_cnt;
         v_rec.treaty10_cnt := i.treaty10_cnt;
         v_rec.trty_name := i.trty_name;
         v_rec.trty2_name := i.trty2_name;
         v_rec.trty3_name := i.trty3_name;
         v_rec.trty4_name := i.trty4_name;
         v_rec.trty5_name := i.trty5_name;
         v_rec.trty6_name := i.trty6_name;
         v_rec.trty7_name := i.trty7_name;
         v_rec.trty8_name := i.trty8_name;
         v_rec.trty9_name := i.trty9_name;
         v_rec.trty10_name := i.trty10_name;
         v_rec.cf_sec_netret_amt := cf_sec_netret_amt (i.line_cd, p_user_id);
         v_rec.trty_amt := cf_trty1_amt (i.line_cd, p_user_id);
         v_rec.trty2_amt := cf_trty2_amt (i.line_cd, p_user_id);
         v_rec.trty3_amt := cf_trty3_amt (i.line_cd, p_user_id);
         v_rec.trty4_amt := cf_trty4_amt (i.line_cd, p_user_id);
         v_rec.trty5_amt := cf_trty5_amt (i.line_cd, p_user_id);
         v_rec.trty6_amt := cf_trty6_amt (i.line_cd, p_user_id);
         v_rec.trty7_amt := cf_trty7_amt (i.line_cd, p_user_id);
         v_rec.cf_from :=
            cf_from (i.line_cd,
                     p_starting_date,
                     p_ending_date,
                     p_user_id,
                     i.range_to
                    );
         v_rec.cf_to := cf_to (i.range_to);
         v_rec.total_tsi :=
              NVL (i.net_retention_tsi, 0)
            + NVL (i.sec_net_retention_tsi, 0)
            + NVL (i.treaty_tsi, 0)
            + NVL (i.treaty2_tsi, 0)
            + NVL (i.treaty3_tsi, 0)
            + NVL (i.treaty4_tsi, 0)
            + NVL (i.treaty5_tsi, 0)
            + NVL (i.treaty6_tsi, 0)
            + NVL (i.treaty7_tsi, 0)
            + NVL (i.treaty8_tsi, 0)
            + NVL (i.treaty9_tsi, 0)
            + NVL (i.treaty10_tsi, 0)
            + NVL (i.quota_share_tsi, 0)
            + NVL (i.facultative_tsi, 0);
         v_rec.total_prem :=
              NVL (i.net_retention, 0)
            + NVL (i.sec_net_retention_prem, 0)
            + NVL (i.treaty_prem, 0)
            + NVL (i.treaty2_prem, 0)
            + NVL (i.treaty3_prem, 0)
            + NVL (i.treaty4_prem, 0)
            + NVL (i.treaty5_prem, 0)
            + NVL (i.treaty6_prem, 0)
            + NVL (i.treaty7_prem, 0)
            + NVL (i.treaty8_prem, 0)
            + NVL (i.treaty9_prem, 0)
            + NVL (i.treaty10_prem, 0)
            + NVL (i.quota_share, 0)
            + NVL (i.facultative, 0);
         mjm := FALSE;
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_gipir947_record;
END;
/


