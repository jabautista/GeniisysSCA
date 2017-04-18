CREATE OR REPLACE PACKAGE BODY CPI.giclr214_pkg
AS
   FUNCTION get_giclr214_title (p_extract NUMBER)
      RETURN CHAR
   IS
      --v_addl  VARCHAR2(200);
      v_addl   giis_reports.report_title%TYPE;
   BEGIN
      FOR rpt IN (SELECT report_title title
                    FROM giis_reports
                   WHERE report_id = 'GICLR214')
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
   END get_giclr214_title;

   FUNCTION get_giclr214_heading (
      p_extract          NUMBER,
      p_param_date       VARCHAR2,
      p_starting_date    DATE,
      p_ending_date      DATE,
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE
   )
      RETURN VARCHAR2
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
      ELSE
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
      END IF;

      RETURN (v_date);
   END get_giclr214_heading;

   FUNCTION get_giclr214_heading2 (
      p_extract          NUMBER,
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE
   )
      RETURN VARCHAR2
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
   END get_giclr214_heading2;

   FUNCTION get_giclr214_linecd (p_line VARCHAR2, v_line_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_linecd   VARCHAR2 (10);
   BEGIN
      v_linecd := UPPER (NVL (p_line, v_line_cd));
      RETURN (v_linecd);
   END get_giclr214_linecd;

   FUNCTION get_giclr214_line_name (p_line_cd VARCHAR2)
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
   END get_giclr214_line_name;

   FUNCTION get_giclr214_subline_name (
      p_subline      VARCHAR2,
      p_line         VARCHAR2,
      v_line_cd      VARCHAR2,
      v_subline_cd   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_subline_name   giis_subline.subline_name%TYPE;
   BEGIN
      FOR a IN (SELECT INITCAP (subline_name) subline_name
                  FROM giis_subline
                 WHERE subline_cd = NVL (UPPER (p_subline), v_subline_cd)
                   AND line_cd = NVL (UPPER (p_line), v_line_cd))
      LOOP
         v_subline_name := a.subline_name;
      END LOOP;

      RETURN (v_subline_name);
   END get_giclr214_subline_name;

   FUNCTION get_giclr214_range_to (
      p_line        VARCHAR2,
      p_line_cd     VARCHAR2,
      p_subline     VARCHAR2,
      p_range_to1   NUMBER,
      p_user        VARCHAR2
   )
      RETURN NUMBER
   IS
      max_range   NUMBER;
   BEGIN
      FOR a IN (SELECT MAX (range_to) range_to
                  FROM gicl_loss_profile
                 WHERE line_cd = UPPER (NVL (p_line, p_line_cd))
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2'))
                   AND user_id = UPPER (p_user)
                   AND range_to != 99999999999999.99)
      LOOP
         max_range := a.range_to;
         EXIT;
      END LOOP;

      IF TO_CHAR (p_range_to1, '99,999,999,999,999.99') !=
                          TO_CHAR (99999999999999.99, '99,999,999,999,999.99')
      THEN
         RETURN (NULL);
      ELSE
         RETURN (max_range);
      END IF;

      RETURN NULL;
   END get_giclr214_range_to;

   FUNCTION get_giclr214_range_from (
      p_user         VARCHAR2,
      p_line         VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_range_to1    NUMBER
   )
      RETURN VARCHAR2
   IS
      v_over      VARCHAR2 (10);
      max_range   NUMBER;
   BEGIN
      FOR a IN (SELECT MAX (range_to) range_to
                  FROM gicl_loss_profile
                 WHERE line_cd = NVL (p_line, p_line_cd)
                   AND subline_cd = NVL (p_subline, p_subline_cd)
                   AND user_id = p_user
                   AND range_to != 99999999999999.99)
      LOOP
         max_range := a.range_to;
         EXIT;
      END LOOP;

      v_over := 'OVER ';

      IF TO_CHAR (p_range_to1, '99,999,999,999,999.99') !=
                          TO_CHAR (99999999999999.99, '99,999,999,999,999.99')
      THEN
         RETURN (NULL);
      ELSE
         RETURN (v_over);
      END IF;

      RETURN NULL;
   END get_giclr214_range_from;

   FUNCTION get_giclr214_sec_netret_func (p_line VARCHAR2, p_subline VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (  NVL (sec_net_retention_tsi, 0)
                            + NVL (sec_net_retention_loss, 0)
                           ) amt
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2')))
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END get_giclr214_sec_netret_func;

   FUNCTION get_giclr214_treaty1_func (
      p_line         VARCHAR2,
      p_line_cd      VARCHAR2,
      p_treaty1_cd   NUMBER
   )
      RETURN CHARACTER
   IS
      v_trty_name   VARCHAR2 (500);
      v_xol_id      giis_dist_share.xol_id%TYPE;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line, p_line_cd) AND share_cd = p_treaty1_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      -- get_xol_trty_name(v_xol_id, v_trty_name);
      FOR j IN (SELECT xol_trty_name
                  --into get_xol_trty_name
                FROM   giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := j.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END get_giclr214_treaty1_func;

   FUNCTION get_giclr214_treaty2_func (
      p_line         VARCHAR2,
      p_line_cd      VARCHAR2,
      p_treaty2_cd   NUMBER
   )
      RETURN CHARACTER
   IS
      v_trty_name   VARCHAR2 (70);
      v_xol_id      giis_dist_share.xol_id%TYPE;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line, p_line_cd) AND share_cd = p_treaty2_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR j IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := j.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END get_giclr214_treaty2_func;

   FUNCTION get_giclr214_treaty3_func (
      p_line         VARCHAR2,
      p_line_cd      VARCHAR2,
      p_treaty3_cd   NUMBER
   )
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70);
      v_xol_id      giis_dist_share.xol_id%TYPE;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line, p_line_cd) AND share_cd = p_treaty3_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR j IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := j.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END get_giclr214_treaty3_func;

   FUNCTION get_giclr214_treaty4_func (
      p_line         VARCHAR2,
      p_line_cd      VARCHAR2,
      p_treaty4_cd   NUMBER
   )
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70);
      v_xol_id      giis_dist_share.trty_name%TYPE;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = UPPER (NVL (p_line, p_line_cd))
            AND share_cd = p_treaty4_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR j IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := j.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END get_giclr214_treaty4_func;

   FUNCTION get_giclr214_treaty5_func (
      p_line         VARCHAR2,
      p_line_cd      VARCHAR2,
      p_treaty5_cd   NUMBER
   )
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70);
      v_xol_id      giis_dist_share.xol_id%TYPE;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line, p_line_cd) AND share_cd = p_treaty5_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR j IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := j.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END get_giclr214_treaty5_func;

   FUNCTION get_giclr214_treaty6_func (
      p_line         VARCHAR2,
      p_line_cd      VARCHAR2,
      p_treaty6_cd   NUMBER
   )
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70);
      v_xol_id      giis_dist_share.xol_id%TYPE;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line, p_line_cd) AND share_cd = p_treaty6_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR j IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := j.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END get_giclr214_treaty6_func;

   FUNCTION get_giclr214_treaty7_func (
      p_line         VARCHAR2,
      p_line_cd      VARCHAR2,
      p_treaty7_cd   NUMBER
   )
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70);
      v_xol_id      giis_dist_share.xol_id%TYPE;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line, p_line_cd) AND share_cd = p_treaty7_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR j IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := j.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END get_giclr214_treaty7_func;

   FUNCTION get_giclr214_treaty8_func (
      p_line         VARCHAR2,
      p_line_cd      VARCHAR2,
      p_treaty8_cd   NUMBER
   )
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70);
      v_xol_id      giis_dist_share.xol_id%TYPE;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line, p_line_cd) AND share_cd = p_treaty8_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR j IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := j.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END get_giclr214_treaty8_func;

   FUNCTION get_giclr214_treaty9_func (
      p_line         VARCHAR2,
      p_line_cd      VARCHAR2,
      p_treaty9_cd   NUMBER
   )
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70);
      v_xol_id      giis_dist_share.xol_id%TYPE;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line, p_line_cd) AND share_cd = p_treaty9_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR j IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := j.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END get_giclr214_treaty9_func;

   FUNCTION get_giclr214_treaty10_func (
      p_line          VARCHAR2,
      p_line_cd       VARCHAR2,
      p_treaty10_cd   NUMBER
   )
      RETURN VARCHAR2
   IS
      v_trty_name   VARCHAR2 (70);
      v_xol_id      giis_dist_share.xol_id%TYPE;
   BEGIN
      BEGIN
         SELECT INITCAP (trty_name), xol_id
           INTO v_trty_name, v_xol_id
           FROM giis_dist_share
          WHERE line_cd = NVL (p_line, p_line_cd) AND share_cd = p_treaty10_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_trty_name := NULL;
      END;

      v_trty_name := CHR (10) || v_trty_name;

      FOR j IN (SELECT xol_trty_name
                  FROM giis_xol
                 WHERE xol_id = v_xol_id)
      LOOP
         v_trty_name := j.xol_trty_name || v_trty_name;
         EXIT;
      END LOOP;

      RETURN (v_trty_name);
   END get_giclr214_treaty10_func;

   FUNCTION get_giclr214_trty1_amt_func (p_line VARCHAR2, p_subline VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty1_loss, 0) + NVL (treaty_tsi, 0)) amt
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2')))
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END get_giclr214_trty1_amt_func;

   FUNCTION get_giclr214_trty2_amt_func (p_line VARCHAR2, p_subline VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty2_loss, 0) + NVL (treaty2_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2')))
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END get_giclr214_trty2_amt_func;

   FUNCTION get_giclr214_trty3_amt_func (p_line VARCHAR2, p_subline VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty3_loss, 0) + NVL (treaty3_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2')))
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END get_giclr214_trty3_amt_func;

   FUNCTION get_giclr214_trty4_amt_func (p_line VARCHAR2, p_subline VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty4_loss, 0) + NVL (treaty4_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2')))
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END get_giclr214_trty4_amt_func;

   FUNCTION get_giclr214_trty5_amt_func (p_line VARCHAR2, p_subline VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty5_loss, 0) + NVL (treaty5_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2')))
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END get_giclr214_trty5_amt_func;

   FUNCTION get_giclr214_trty6_amt_func (p_line VARCHAR2, p_subline VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty6_loss, 0) + NVL (treaty6_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2')))
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END get_giclr214_trty6_amt_func;

   FUNCTION get_giclr214_trty7_amt_func (p_line VARCHAR2, p_subline VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty7_loss, 0) + NVL (treaty7_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2')))
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END get_giclr214_trty7_amt_func;

   FUNCTION get_giclr214_trty8_amt_func (p_line VARCHAR2, p_subline VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty8_loss, 0) + NVL (treaty8_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2')))
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END get_giclr214_trty8_amt_func;

   FUNCTION get_giclr214_trty9_amt_func (p_line VARCHAR2, p_subline VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty9_loss, 0) + NVL (treaty9_tsi, 0))
                                                                         amt
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2')))
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END get_giclr214_trty9_amt_func;

   FUNCTION get_giclr214_trty10_amt_func (p_line VARCHAR2, p_subline VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (NVL (treaty10_loss, 0)
                            + NVL (treaty10_tsi, 0)) amt
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2')))
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END get_giclr214_trty10_amt_func;

   FUNCTION get_giclr214_quota_sh (p_line VARCHAR2, p_subline VARCHAR2)
      RETURN NUMBER
   IS
      v_amt   NUMBER (20, 2);
   BEGIN
      FOR c IN (SELECT SUM (quota_share + quota_share_tsi) amt
                  FROM gicl_loss_profile
                 WHERE line_cd = p_line
                   AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2')))
      LOOP
         v_amt := NVL (c.amt, 0);
      END LOOP;

      RETURN (v_amt);
   END get_giclr214_quota_sh;

   FUNCTION get_giclr214_record (
      p_claim_date       VARCHAR2,
      p_ending_date      VARCHAR2,
      p_extract          NUMBER,
      p_line             VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_param_date       VARCHAR2,
      p_starting_date    VARCHAR2,
      p_subline          VARCHAR2,
      p_user             VARCHAR2
   )
      RETURN giclr214_tab PIPELINED
   IS
      v_list             giclr214_type;
      v_not_exist        BOOLEAN                       := TRUE;
      v_starting_date    DATE      := TO_DATE (p_starting_date, 'MM/DD/YYYY');
      v_ending_date      DATE        := TO_DATE (p_ending_date, 'MM/DD/YYYY');
      v_loss_date_from   DATE     := TO_DATE (p_loss_date_from, 'MM/DD/YYYY');
      v_loss_date_to     DATE       := TO_DATE (p_loss_date_to, 'MM/DD/YYYY');
      v_xol_id           giis_dist_share.xol_id%TYPE;
      v_trty_name        VARCHAR2 (500);
   BEGIN
      v_list.comp_name := giisp.v ('COMPANY_NAME');
      v_list.title := get_giclr214_title (p_extract);
      v_list.heading :=
         get_giclr214_heading (p_extract,
                               p_param_date,
                               v_starting_date,
                               v_ending_date,
                               p_claim_date,
                               v_loss_date_from,
                               v_loss_date_to
                              );
      v_list.heading2 :=
         get_giclr214_heading2 (p_extract,
                                p_claim_date,
                                v_loss_date_from,
                                v_loss_date_to
                               );

      FOR i IN (SELECT   line_cd, NVL (subline_cd, '1') subline_cd,
                         (range_from) range_from1, (range_to) range_to1,
                         policy_count, NVL (total_tsi_amt, 0) total_tsi_amt,
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
                         NVL (treaty10_tsi, 0) treaty10_tsi, treaty1_cd,
                         treaty2_cd, treaty3_cd, treaty4_cd, treaty5_cd,
                         treaty6_cd, treaty7_cd, treaty8_cd, treaty9_cd,
                         treaty10_cd, net_retention_cnt nr_cnt,
                         facultative_cnt, treaty_cnt, treaty2_cnt,
                         treaty3_cnt, treaty4_cnt, treaty5_cnt, treaty6_cnt,
                         treaty7_cnt, treaty8_cnt, treaty9_cnt, treaty10_cnt,
                         NVL (quota_share, 0) quota_share,
                         NVL (quota_share_tsi, 0) qs_tsi
                    FROM gicl_loss_profile
                   WHERE line_cd = NVL (UPPER (p_line), line_cd)
                     AND NVL (subline_cd, '1') =
                                NVL (UPPER (p_subline), NVL (subline_cd, '2'))
                     AND user_id = UPPER (p_user)
                ORDER BY line_cd, range_to ASC)
      LOOP
         v_not_exist := FALSE;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.range_from1 := i.range_from1;
         v_list.range_to1 := i.range_to1;
         v_list.policy_count := i.policy_count;
         v_list.total_tsi_amt := i.total_tsi_amt;
         v_list.gross_loss := i.gross_loss;
         v_list.net_retention := i.net_retention;
         v_list.nr_tsi := i.nr_tsi;
         v_list.secnr_tsi := i.secnr_tsi;
         v_list.secnr_loss := i.secnr_loss;
         v_list.facultative := i.facultative;
         v_list.facultative_tsi := i.facultative_tsi;
         v_list.treaty := i.treaty;
         v_list.treaty_tsi := i.treaty_tsi;
         v_list.treaty1_loss := i.treaty1_loss;
         v_list.treaty2_loss := i.treaty2_loss;
         v_list.treaty2_tsi := i.treaty2_tsi;
         v_list.treaty3_loss := i.treaty3_loss;
         v_list.treaty3_tsi := i.treaty3_tsi;
         v_list.treaty4_loss := i.treaty4_loss;
         v_list.treaty4_tsi := i.treaty4_tsi;
         v_list.treaty5_loss := i.treaty5_loss;
         v_list.treaty5_tsi := i.treaty5_tsi;
         v_list.treaty6_loss := i.treaty6_loss;
         v_list.treaty6_tsi := i.treaty6_tsi;
         v_list.treaty7_loss := i.treaty7_loss;
         v_list.treaty7_tsi := i.treaty7_tsi;
         v_list.treaty8_loss := i.treaty8_loss;
         v_list.treaty8_tsi := i.treaty8_tsi;
         v_list.treaty9_loss := i.treaty9_loss;
         v_list.treaty9_tsi := i.treaty9_tsi;
         v_list.treaty10_loss := i.treaty10_loss;
         v_list.treaty10_tsi := i.treaty10_tsi;
         v_list.treaty1_cd := i.treaty1_cd;
         v_list.treaty2_cd := i.treaty2_cd;
         v_list.treaty3_cd := i.treaty3_cd;
         v_list.treaty4_cd := i.treaty4_cd;
         v_list.treaty5_cd := i.treaty5_cd;
         v_list.treaty6_cd := i.treaty6_cd;
         v_list.treaty7_cd := i.treaty7_cd;
         v_list.treaty8_cd := i.treaty8_cd;
         v_list.treaty9_cd := i.treaty9_cd;
         v_list.treaty10_cd := i.treaty10_cd;
         v_list.nr_cnt := i.nr_cnt;
         v_list.facultative_cnt := i.facultative_cnt;
         v_list.treaty_cnt := i.treaty_cnt;
         v_list.treaty2_cnt := i.treaty2_cnt;
         v_list.treaty3_cnt := i.treaty3_cnt;
         v_list.treaty4_cnt := i.treaty4_cnt;
         v_list.treaty5_cnt := i.treaty5_cnt;
         v_list.treaty6_cnt := i.treaty6_cnt;
         v_list.treaty7_cnt := i.treaty7_cnt;
         v_list.treaty8_cnt := i.treaty8_cnt;
         v_list.treaty9_cnt := i.treaty9_cnt;
         v_list.treaty10_cnt := i.treaty10_cnt;
         v_list.quota_share := i.quota_share;
         v_list.qs_tsi := i.qs_tsi;
         v_list.linecd := get_giclr214_linecd (p_line, i.line_cd);
         v_list.line_name := get_giclr214_line_name (i.line_cd);
         v_list.subline_name :=
            get_giclr214_subline_name (p_subline,
                                       p_line,
                                       i.line_cd,
                                       i.subline_cd
                                      );
          --modified by gab 03.16.2016
--         v_list.range_to :=
--            get_giclr214_range_to (p_line,
--                                   i.line_cd,
--                                   p_subline,
--                                   i.range_to1,
--                                   p_user
--                                  );
--         v_list.range_from :=
--            get_giclr214_range_from (p_user,
--                                     p_line,
--                                     i.line_cd,
--                                     p_subline,
--                                     i.subline_cd,
--                                     i.range_to1
--                                    );
        IF i.range_from1 <> 0
        THEN
         v_list.range_from := TO_CHAR(i.range_from1, '99,999,999,999,999.99');
        ELSE
            v_list.range_from := TO_CHAR(i.range_from1, '99,999,999,999,990.99');
        END IF;
         v_list.range_to := TO_CHAR(i.range_to1, '99,999,999,999,999.99');
         v_list.cf_range := v_list.range_from || '-' || v_list.range_to;
         --end                                  
         v_list.sec_netret_func :=
                              get_giclr214_sec_netret_func (p_line, p_subline);
         v_list.treaty1_func :=
                   get_giclr214_treaty1_func (p_line, i.line_cd, i.treaty1_cd);
         v_list.treaty2_func :=
                   get_giclr214_treaty2_func (p_line, i.line_cd, i.treaty2_cd);
         v_list.treaty3_func :=
                   get_giclr214_treaty3_func (p_line, i.line_cd, i.treaty3_cd);
         v_list.treaty4_func :=
                   get_giclr214_treaty4_func (p_line, i.line_cd, i.treaty4_cd);
         v_list.treaty5_func :=
                   get_giclr214_treaty5_func (p_line, i.line_cd, i.treaty5_cd);
         v_list.treaty6_func :=
                   get_giclr214_treaty6_func (p_line, i.line_cd, i.treaty6_cd);
         v_list.treaty7_func :=
                   get_giclr214_treaty7_func (p_line, i.line_cd, i.treaty7_cd);
         v_list.treaty8_func :=
                   get_giclr214_treaty8_func (p_line, i.line_cd, i.treaty8_cd);
         v_list.treaty9_func :=
                   get_giclr214_treaty9_func (p_line, i.line_cd, i.treaty9_cd);
         v_list.treaty10_func :=
                 get_giclr214_treaty10_func (p_line, i.line_cd, i.treaty10_cd);
         v_list.trty1_amt_func :=
                               get_giclr214_trty1_amt_func (p_line, p_subline);
         v_list.trty2_amt_func :=
                               get_giclr214_trty2_amt_func (p_line, p_subline);
         v_list.trty3_amt_func :=
                               get_giclr214_trty3_amt_func (p_line, p_subline);
         v_list.trty4_amt_func :=
                               get_giclr214_trty4_amt_func (p_line, p_subline);
         v_list.trty5_amt_func :=
                               get_giclr214_trty5_amt_func (p_line, p_subline);
         v_list.trty6_amt_func :=
                               get_giclr214_trty6_amt_func (p_line, p_subline);
         v_list.trty7_amt_func :=
                               get_giclr214_trty7_amt_func (p_line, p_subline);
         v_list.trty8_amt_func :=
                               get_giclr214_trty8_amt_func (p_line, p_subline);
         v_list.trty9_amt_func :=
                               get_giclr214_trty9_amt_func (p_line, p_subline);
         v_list.trty10_amt_func :=
                              get_giclr214_trty10_amt_func (p_line, p_subline);
         v_list.quota_sh := get_giclr214_quota_sh (p_line, p_subline);
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr214_record;
END;
/


