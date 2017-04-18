CREATE OR REPLACE PACKAGE BODY CPI.giclr212_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 08.23.2013
     **  Reference By : GICLR212
     **  Description  : Loss Profile Report By Line and Subline
     */
   FUNCTION cf_title (p_extract NUMBER)
      RETURN CHAR
   IS
      v_rep_title   VARCHAR2 (150);
   BEGIN
      FOR rep IN (SELECT report_title
                    FROM giis_reports
                   WHERE report_id = 'GICLR212')
      LOOP
         v_rep_title := UPPER (rep.report_title);
      END LOOP;

      IF NVL (p_extract, 1) = 2
      THEN
         v_rep_title := v_rep_title || CHR (10) || '(BASED ON LOSS AMOUNT)';
      ELSIF NVL (p_extract, 1) = 1
      THEN
         v_rep_title :=
                     v_rep_title || CHR (10)
                     || '(BASED ON TOTAL SUM INSURED)';
      END IF;

      RETURN (v_rep_title);
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

   FUNCTION cf_subline_name (p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_subline_name   giis_subline.subline_name%TYPE;
   BEGIN
      FOR a IN (SELECT INITCAP (subline_name) subline_name
                  FROM giis_subline
                 WHERE subline_cd = NVL (UPPER (p_subline_cd), subline_cd)
                   AND line_cd = NVL (UPPER (p_line_cd), line_cd))
      LOOP
         v_subline_name := a.subline_name;
      END LOOP;

      RETURN (v_subline_name);
   END;

   FUNCTION cf_from (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_user_id      VARCHAR2,
      p_range_to     NUMBER
   )
      RETURN VARCHAR2
   IS
      v_over      VARCHAR2 (10);
      max_range   NUMBER;
   BEGIN
      FOR a IN (SELECT MAX (range_to) range_to
                  FROM gicl_loss_profile
                 WHERE line_cd = NVL (p_line_cd, line_cd)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
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
      ELSE
         RETURN (v_over);
      END IF;

      RETURN NULL;
   END;

   FUNCTION cf_to (p_line_cd VARCHAR2, p_user_id VARCHAR2, p_range_to NUMBER)
      RETURN NUMBER
   IS
      max_range   NUMBER;
   BEGIN
      FOR a IN (SELECT MAX (range_to) range_to
                  FROM gicl_loss_profile
                 WHERE line_cd = UPPER (NVL (p_line_cd, line_cd))
                   AND user_id = UPPER (p_user_id)
                   AND range_to != 99999999999999.99)
      LOOP
         max_range := a.range_to;
         EXIT;
      END LOOP;

      IF TO_CHAR (p_range_to, '99,999,999,999,999.99') !=
                          TO_CHAR (99999999999999.99, '99,999,999,999,999.99')
      THEN
         RETURN (NULL);
      ELSE
         RETURN (max_range);
      END IF;

      RETURN NULL;
   END;

   FUNCTION get_giclr212_record (
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
      RETURN giclr212_record_tab PIPELINED
   IS
      v_rec   giclr212_record_type;
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

      FOR i IN (SELECT   line_cd, NVL (subline_cd, '1') subline_cd,
                         range_from, range_to, policy_count, net_retention,
                         quota_share, NVL (total_tsi_amt, 0) total_tsi_amt,
                         treaty, facultative,
                         (  NVL (net_retention, 0)
                          + NVL (treaty, 0)
                          + NVL (facultative, 0)
                          + NVL (xol_treaty, 0)
                         ) gross_loss,
                         xol_treaty
                    FROM gicl_loss_profile
                   WHERE line_cd = NVL (p_line_cd, line_cd)
--                     AND NVL (subline_cd, '1') =
--                                     NVL (p_subline_cd, NVL (subline_cd, '2'))
                     AND NVL (subline_cd, '***') = NVL (p_subline_cd, '***')
                     AND user_id = UPPER (p_user_id)
                ORDER BY line_cd, range_from)
      LOOP
         mjm := FALSE;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
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
         --end
         v_rec.policy_count := i.policy_count;
         v_rec.net_retention := i.net_retention;
         v_rec.quota_share := i.quota_share;
         v_rec.treaty := i.treaty;
         v_rec.total_tsi_amt := i.total_tsi_amt;
         v_rec.facultative := i.facultative;
         v_rec.gross_loss := i.gross_loss;
         v_rec.xol_treaty := i.xol_treaty;
         v_rec.cf_line :=
              i.line_cd || ' - ' || cf_line_name (NVL (p_line_cd, i.line_cd));
         v_rec.cf_subline :=
               i.subline_cd
            || ' - '
            || cf_subline_name (NVL (p_line_cd, i.line_cd),
                                NVL (p_subline_cd, i.subline_cd)
                               );
         v_rec.cf_from :=
                      cf_from (i.line_cd, p_subline_cd, p_user_id, i.range_to);
         v_rec.cf_to := cf_to (i.line_cd, p_user_id, i.range_to);
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_giclr212_record;
END;
/


