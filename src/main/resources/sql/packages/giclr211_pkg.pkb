CREATE OR REPLACE PACKAGE BODY CPI.giclr211_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 08.23.2013
     **  Reference By : GICLR211
     **  Description  : Loss Profile Report By Line
     */
   FUNCTION cf_title (p_extract NUMBER)
      RETURN CHAR
   IS
      v_addl   VARCHAR2 (200);
   BEGIN
      FOR rpt IN (SELECT report_title title
                    FROM giis_reports
                   WHERE report_id = 'GICLR211')
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
   END;

   FUNCTION cf_heading2 (
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
         SELECT INITCAP (line_name)
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

   FUNCTION cf_from (p_line_cd VARCHAR2, p_user_id VARCHAR2, p_range_to NUMBER)
      RETURN VARCHAR2
   IS
      v_over      VARCHAR2 (5);
      max_range   NUMBER;
   BEGIN
      FOR a IN (SELECT MAX (range_to) range_to
                  FROM gicl_loss_profile
                 WHERE line_cd = NVL (p_line_cd, line_cd)
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

   FUNCTION cf_to (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_user_id      VARCHAR2,
      p_range_to     NUMBER
   )
      RETURN NUMBER
   IS
      max_range   NUMBER;
   BEGIN
      BEGIN
         SELECT MAX (range_to)
           INTO max_range
           FROM gicl_loss_profile
          WHERE line_cd = UPPER (NVL (p_line_cd, line_cd))
            AND NVL (subline_cd, '***') = UPPER (NVL (p_subline_cd, '***'))
            AND user_id = UPPER (p_user_id)
            AND range_to != 99999999999999.99;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF TO_CHAR (p_range_to, '99,999,999,999,999.99') !=
                          TO_CHAR (99999999999999.99, '99,999,999,999,999.99')
      THEN
         RETURN (NULL);
      ELSE
         RETURN (max_range);
      END IF;

      RETURN NULL;
   END;

   FUNCTION cf_total_label (p_subline_cd VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      IF p_subline_cd IS NULL
      THEN
         RETURN ('       Totals :');
      ELSE
         RETURN (' Grand Totals :');
      END IF;

      RETURN NULL;
   END;

   FUNCTION get_giclr211_record (
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
      RETURN giclr211_record_tab PIPELINED
   IS
      v_rec   giclr211_record_type;
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
      v_rec.total_label := cf_total_label (p_subline_cd);

      FOR i IN (SELECT   range_from, range_to, line_cd, policy_count,
                         net_retention, quota_share, treaty,
                         NVL (total_tsi_amt, 0) total_tsi_amt, facultative,
                         (  NVL (net_retention, 0)
                          + NVL (treaty, 0)
                          + NVL (facultative, 0)
                          + NVL (xol_treaty, 0)
                         ) gross_loss,
                         xol_treaty
                    FROM gicl_loss_profile
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                     AND user_id = UPPER (p_user_id)
                     AND NVL (subline_cd, '***') = NVL (p_subline_cd, '***')
                ORDER BY range_from ASC)
      LOOP
         mjm := FALSE;
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
         v_rec.line_cd := i.line_cd;
         v_rec.policy_count := i.policy_count;
         v_rec.net_retention := i.net_retention;
         v_rec.quota_share := i.quota_share;
         v_rec.treaty := i.treaty;
         v_rec.total_tsi_amt := i.total_tsi_amt;
         v_rec.facultative := i.facultative;
         v_rec.gross_loss := i.gross_loss;
         v_rec.xol_treaty := i.xol_treaty;
         v_rec.line_name := cf_line_name (p_line_cd);
         v_rec.cf_from := cf_from (i.line_cd, p_user_id, i.range_to);
         v_rec.cf_to :=
                       cf_to (i.line_cd, p_subline_cd, p_user_id, i.range_to);
         v_rec.cf_line :=
              i.line_cd || ' - ' || cf_line_name (NVL (p_line_cd, i.line_cd));
         PIPE ROW (v_rec);
      END LOOP;

      /*IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;*/
   END get_giclr211_record;
END;
/


