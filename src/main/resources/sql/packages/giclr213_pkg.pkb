CREATE OR REPLACE PACKAGE BODY CPI.giclr213_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 08.27.2013
     **  Reference By : GICLR213
     **  Description  : Loss Profile Report By Line, All Treaties
     */
   FUNCTION cf_title (p_extract NUMBER)
      RETURN CHAR
   IS
      v_addl   giis_reports.report_title%TYPE;
   BEGIN
      FOR rpt IN (SELECT report_title title
                    FROM giis_reports
                   WHERE report_id = 'GICLR213')
      LOOP
         v_addl := rpt.title;
      END LOOP;

      IF NVL (v_addl, '1') != '1'
      THEN
         IF p_extract = 1
         THEN
            v_addl :=
                   v_addl || CHR (10)
                   || '(BASED ON TOTAL SUM INSURED AMOUNT)';
         ELSE
            v_addl := v_addl || CHR (10) || '(BASED ON LOSS AMOUNT)';
         END IF;
      ELSE
         v_addl := ' ';
      END IF;

      RETURN (UPPER (v_addl));
   END;

   FUNCTION cf_heading1 (
      p_param_date       VARCHAR2,
      p_starting_date    DATE,
      p_ending_date      DATE,
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_extract          NUMBER
   )
      RETURN CHAR
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      IF p_extract = 1
      THEN
         BEGIN
            SELECT    p_param_date
                   || ' from '
                   || TO_CHAR (p_starting_date, 'fmMonth DD, YYYY')
                   || ' to '
                   || TO_CHAR (p_ending_date, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;

         RETURN (v_date);
      ELSIF p_extract = 2
      THEN
         BEGIN
            SELECT    p_claim_date
                   || ' from '
                   || TO_CHAR (p_loss_date_from, 'fmMonth DD, YYYY')
                   || ' to '
                   || TO_CHAR (p_loss_date_to, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;

         RETURN (v_date);
      END IF;
   END;

   FUNCTION cf_heading2 (
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_extract          NUMBER
   )
      RETURN CHAR
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      IF p_extract = 1
      THEN
         BEGIN
            SELECT    p_claim_date
                   || ' from '
                   || TO_CHAR (p_loss_date_from, 'fmMonth DD, YYYY')
                   || ' to '
                   || TO_CHAR (p_loss_date_to, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;
      ELSE
         v_date := NULL;
      END IF;

      RETURN (v_date);
   END;

   FUNCTION cf_line_name (p_line_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_line_name   giis_line.line_name%TYPE;
   BEGIN
      BEGIN
         SELECT INITCAP (line_name) line_name
           INTO v_line_name
           FROM giis_line
          WHERE line_cd = UPPER (p_line_cd);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN (v_line_name);
   END;

   FUNCTION cf_treaty1 (p_line_cd VARCHAR2, p_treaty1_cd NUMBER)
      RETURN CHARACTER
   IS
      v_trty_name   VARCHAR2 (70)                 := NULL;
      v_xol_id      giis_dist_share.xol_id%TYPE   := 0;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line_cd, line_cd) AND share_cd = p_treaty1_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
            v_xol_id := 0;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR i IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := i.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END;

   FUNCTION cf_treaty2 (p_line_cd VARCHAR2, p_treaty2_cd NUMBER)
      RETURN CHARACTER
   IS
      v_trty_name   VARCHAR2 (70)                 := NULL;
      v_xol_id      giis_dist_share.xol_id%TYPE   := 0;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line_cd, line_cd) AND share_cd = p_treaty2_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
            v_xol_id := 0;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR i IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := i.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END;

   FUNCTION cf_treaty3 (p_line_cd VARCHAR2, p_treaty3_cd NUMBER)
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70)                 := NULL;
      v_xol_id      giis_dist_share.xol_id%TYPE   := 0;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line_cd, line_cd) AND share_cd = p_treaty3_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
            v_xol_id := 0;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR i IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := i.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END;

   FUNCTION cf_treaty4 (p_line_cd VARCHAR2, p_treaty4_cd NUMBER)
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (500);
      v_xol_id      giis_dist_share.xol_id%TYPE;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = UPPER (NVL (p_line_cd, line_cd))
            AND share_cd = p_treaty4_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
            v_xol_id := 0;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR i IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := i.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END;

   FUNCTION cf_treaty5 (p_line_cd VARCHAR2, p_treaty5_cd NUMBER)
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70)                 := NULL;
      v_xol_id      giis_dist_share.xol_id%TYPE   := 0;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line_cd, line_cd) AND share_cd = p_treaty5_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
            v_xol_id := 0;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR i IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := i.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END;

   FUNCTION cf_treaty6 (p_line_cd VARCHAR2, p_treaty6_cd NUMBER)
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70)                 := NULL;
      v_xol_id      giis_dist_share.xol_id%TYPE   := 0;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line_cd, line_cd) AND share_cd = p_treaty6_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
            v_xol_id := 0;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR i IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := i.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END;

   FUNCTION cf_treaty7 (p_line_cd VARCHAR2, p_treaty7_cd NUMBER)
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70)                 := NULL;
      v_xol_id      giis_dist_share.xol_id%TYPE   := 0;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line_cd, line_cd) AND share_cd = p_treaty7_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR i IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := i.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END;

   FUNCTION cf_treaty8 (p_line_cd VARCHAR2, p_treaty8_cd NUMBER)
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70)                 := NULL;
      v_xol_id      giis_dist_share.xol_id%TYPE   := 0;
   BEGIN
      BEGIN
         SELECT (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line_cd, line_cd) AND share_cd = p_treaty8_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
            v_xol_id := 0;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR i IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := i.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END;

   FUNCTION cf_treaty9 (p_line_cd VARCHAR2, p_treaty9_cd NUMBER)
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70)                 := NULL;
      v_xol_id      giis_dist_share.xol_id%TYPE   := 0;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line_cd, line_cd) AND share_cd = p_treaty9_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
            v_xol_id := 0;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR i IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := i.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END;

   FUNCTION cf_treaty10 (p_line_cd VARCHAR2, p_treaty10_cd NUMBER)
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70)                 := NULL;
      v_xol_id      giis_dist_share.xol_id%TYPE   := 0;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line_cd, line_cd)
                AND share_cd = p_treaty10_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
            v_xol_id := 0;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR i IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := i.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END;

   FUNCTION cf_from (p_line_cd VARCHAR2, p_user_id VARCHAR2, p_range_to NUMBER)
      RETURN VARCHAR2
   IS
      v_over      VARCHAR2 (10);
      max_range   NUMBER;
   BEGIN
      FOR a IN (SELECT MAX (range_to) range_to
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line_cd
                   AND user_id = p_user_id
                   AND range_to != 99999999999999.99)
      LOOP
         max_range := a.range_to;
         EXIT;
      END LOOP;

      v_over := 'OVER ';

      IF TO_CHAR (p_range_to, '99,999,999,999,999.99') !=
                          TO_CHAR (99999999999999.99, '99,999,999,999,999.99')
      THEN
         RETURN (NULL);
      END IF;

      RETURN (v_over);
   END;

   FUNCTION cf_to (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_user_id      VARCHAR2,
      p_range_to     NUMBER
   )
      RETURN NUMBER
   IS
      v_over      VARCHAR2 (10);
      max_range   NUMBER;
   BEGIN
      FOR a IN (SELECT MAX (range_to) range_to
                  FROM gicl_loss_profile
                 WHERE line_cd = UPPER (NVL (p_line_cd, line_cd))
                   AND NVL (subline_cd, '***') = NVL (p_subline_cd, '***')
                   AND user_id = UPPER (p_user_id)
                   AND range_to != 99999999999999.99)
      LOOP
         max_range := a.range_to;
         EXIT;
      END LOOP;

      v_over := 'OVER ';

      IF TO_CHAR (p_range_to, '99,999,999,999,999.99') !=
                          TO_CHAR (99999999999999.99, '99,999,999,999,999.99')
      THEN
         RETURN (NULL);
      END IF;

      RETURN (max_range);
   END;

   FUNCTION cf_sec_net_amt
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (  NVL (sec_net_retention_tsi, 0)
                            + NVL (sec_net_retention_loss, 0)
                           ) amt
                  FROM gicl_loss_profile)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty1_amt
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty1_loss, 0) + NVL (treaty_tsi, 0)) amt
                  FROM gicl_loss_profile)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty2_amt
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty2_loss, 0) + NVL (treaty2_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty3_amt
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty3_loss, 0) + NVL (treaty3_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty4_amt
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty4_loss, 0) + NVL (treaty4_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty5_amt
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty5_loss, 0) + NVL (treaty5_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty6_amt
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty6_loss, 0) + NVL (treaty6_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty7_amt
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty7_loss, 0) + NVL (treaty7_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty8_amt
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty8_loss, 0) + NVL (treaty8_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty9_amt
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty9_loss, 0) + NVL (treaty9_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_trty10_amt
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty10_loss, 0)
                            + NVL (treaty10_tsi, 0)) amt
                  FROM gicl_loss_profile)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION cf_quota_sh
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (quota_share + quota_share_tsi) amt
                  FROM gicl_loss_profile)
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END;

   FUNCTION get_giclr213_record (
      p_line_cd          VARCHAR2,
      p_starting_date    DATE,
      p_ending_date      DATE,
      p_user_id          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_param_date       VARCHAR2,
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_extract          NUMBER
   )
      RETURN giclr213_record_tab PIPELINED
   IS
      v_rec   giclr213_record_type;
      mjm     BOOLEAN              := TRUE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.title := cf_title (p_extract);
      v_rec.heading1 :=
         cf_heading1 (p_param_date,
                      p_starting_date,
                      p_ending_date,
                      p_claim_date,
                      p_loss_date_from,
                      p_loss_date_to,
                      p_extract
                     );
      v_rec.heading2 :=
         cf_heading2 (p_claim_date,
                      p_loss_date_from,
                      p_loss_date_to,
                      p_extract
                     );
      v_rec.sec_net_amt := cf_sec_net_amt;
      v_rec.treaty1_amt := cf_trty1_amt;
      v_rec.treaty2_amt := cf_trty2_amt;
      v_rec.treaty3_amt := cf_trty3_amt;
      v_rec.treaty4_amt := cf_trty4_amt;
      v_rec.treaty5_amt := cf_trty5_amt;
      v_rec.treaty6_amt := cf_trty6_amt;
      v_rec.treaty7_amt := cf_trty7_amt;
      v_rec.treaty8_amt := cf_trty8_amt;
      v_rec.treaty9_amt := cf_trty9_amt;
      v_rec.treaty10_amt := cf_trty10_amt;
      v_rec.quota_sh := cf_quota_sh;

      FOR i IN (SELECT   line_cd, NVL (total_tsi_amt, 0) total_tsi_amt,
                         (  NVL (net_retention, 0)
                          + NVL (facultative, 0)
                          + NVL (sec_net_retention_loss, 0)
                          + NVL (treaty1_loss, 0)
                          + NVL (treaty2_loss, 0)
                          + NVL (treaty3_loss, 0)
                          + NVL (treaty4_loss, 0)
                          + NVL (treaty5_loss, 0)
                          + NVL (treaty6_loss, 0)
                          + NVL (treaty7_loss, 0)
                          + NVL (treaty8_loss, 0)
                          + NVL (treaty9_loss, 0)
                          + NVL (treaty10_loss, 0)
                          + NVL (quota_share, 0)
                         ) gross_loss,
                         range_from, range_to,
                         NVL (policy_count, 0) policy_count,
                         NVL (net_retention, 0) net_retention,
                         NVL (net_retention_tsi, 0) nr_tsi,
                         NVL (sec_net_retention_tsi, 0) secnr_tsi,
                         NVL (sec_net_retention_loss, 0) secnr_loss,
                         NVL (facultative, 0) facultative,
                         NVL (facultative_tsi, 0) facultative_tsi,
                         NVL (treaty, 0) treaty,
                         NVL (treaty_tsi, 0) treaty_tsi,
                         NVL (treaty1_loss, 0) treaty1_loss,
                         NVL (treaty2_loss, 0) treaty2_loss,
                         NVL (treaty2_tsi, 0) treaty2_tsi,
                         NVL (treaty3_loss, 0) treaty3_loss,
                         NVL (treaty3_tsi, 0) treaty3_tsi,
                         NVL (treaty4_loss, 0) treaty4_loss,
                         NVL (treaty4_tsi, 0) treaty4_tsi,
                         NVL (treaty5_loss, 0) treaty5_loss,
                         NVL (treaty5_tsi, 0) treaty5_tsi,
                         NVL (treaty6_loss, 0) treaty6_loss,
                         NVL (treaty6_tsi, 0) treaty6_tsi,
                         NVL (treaty7_loss, 0) treaty7_loss,
                         NVL (treaty7_tsi, 0) treaty7_tsi,
                         NVL (treaty8_loss, 0) treaty8_loss,
                         NVL (treaty8_tsi, 0) treaty8_tsi,
                         NVL (treaty9_loss, 0) treaty9_loss,
                         NVL (treaty9_tsi, 0) treaty9_tsi,
                         NVL (treaty10_loss, 0) treaty10_loss,
                         NVL (treaty10_tsi, 0) treaty10_tsi,
                         net_retention_cnt nr_cnt, facultative_cnt,
                         treaty_cnt, treaty2_cnt, treaty3_cnt, treaty4_cnt,
                         treaty5_cnt, treaty6_cnt, treaty7_cnt, treaty8_cnt,
                         treaty9_cnt, treaty10_cnt, treaty1_cd, treaty2_cd,
                         treaty3_cd, treaty4_cd, treaty5_cd, treaty6_cd,
                         treaty7_cd, treaty8_cd, treaty9_cd, treaty10_cd,
                         NVL (quota_share, 0) quota_share,
                         NVL (quota_share_tsi, 0) qs_tsi
                    FROM gicl_loss_profile
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                     AND user_id = UPPER (p_user_id)
                     AND NVL (subline_cd, '***') = NVL (p_subline_cd, '***')
                ORDER BY line_cd, range_from)
      LOOP
         mjm := FALSE;
         v_rec.line_cd := i.line_cd;
         v_rec.total_tsi_amt := i.total_tsi_amt;
         v_rec.gross_loss := i.gross_loss;
         --modified by gab 03.15.2016
--         v_rec.range_from := i.range_from;
--         v_rec.range_to := i.range_to;
        IF i.range_from <> 0
        THEN
         v_rec.range_from := TO_CHAR(i.range_from, '99,999,999,999,999.99');
        ELSE
         v_rec.range_from := TO_CHAR(i.range_from, '99,999,999,999,990.99');
        END IF;
         v_rec.range_to := TO_CHAR(i.range_to, '99,999,999,999,999.99');
         v_rec.cf_range := v_rec.range_from || '-' || v_rec.range_to;
         --end
         v_rec.policy_count := i.policy_count;
         v_rec.net_retention := i.net_retention;
         v_rec.nr_tsi := i.nr_tsi;
         v_rec.secnr_tsi := i.secnr_tsi;
         v_rec.secnr_loss := i.secnr_loss;
         v_rec.facultative := i.facultative;
         v_rec.facultative_tsi := i.facultative_tsi;
         v_rec.treaty := i.treaty;
         v_rec.treaty1_loss := i.treaty1_loss;
         v_rec.treaty2_loss := i.treaty2_loss;
         v_rec.treaty3_loss := i.treaty3_loss;
         v_rec.treaty4_loss := i.treaty4_loss;
         v_rec.treaty5_loss := i.treaty5_loss;
         v_rec.treaty6_loss := i.treaty6_loss;
         v_rec.treaty7_loss := i.treaty7_loss;
         v_rec.treaty8_loss := i.treaty8_loss;
         v_rec.treaty9_loss := i.treaty9_loss;
         v_rec.treaty10_loss := i.treaty10_loss;
         v_rec.nr_cnt := i.nr_cnt;
         v_rec.facultative_cnt := i.facultative_cnt;
         v_rec.quota_share := i.quota_share;
         v_rec.qs_tsi := i.qs_tsi;
         v_rec.cf_treaty1 := cf_treaty1 (i.line_cd, i.treaty1_cd);
         v_rec.cf_treaty2 := cf_treaty2 (i.line_cd, i.treaty1_cd);
         v_rec.cf_treaty3 := cf_treaty3 (i.line_cd, i.treaty1_cd);
         v_rec.cf_treaty4 := cf_treaty4 (i.line_cd, i.treaty1_cd);
         v_rec.cf_treaty5 := cf_treaty5 (i.line_cd, i.treaty1_cd);
         v_rec.cf_treaty6 := cf_treaty6 (i.line_cd, i.treaty1_cd);
         v_rec.cf_treaty7 := cf_treaty7 (i.line_cd, i.treaty1_cd);
         v_rec.cf_treaty8 := cf_treaty8 (i.line_cd, i.treaty1_cd);
         v_rec.cf_treaty9 := cf_treaty9 (i.line_cd, i.treaty1_cd);
         v_rec.cf_treaty10 := cf_treaty10 (i.line_cd, i.treaty1_cd);
         v_rec.cf_line :=
              i.line_cd || ' - ' || cf_line_name (NVL (p_line_cd, i.line_cd));
         v_rec.cf_from := cf_from (i.line_cd, p_user_id, i.range_to);
         v_rec.cf_to :=
                       cf_to (i.line_cd, p_subline_cd, p_user_id, i.range_to);
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_giclr213_record;
END;
/


