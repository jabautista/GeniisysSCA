/*
Created by Apollo Francis A. Cruz
05.21.2015
AFPGEN-IMPLEM-SR  0004366
Matrix Reloaded!

Redesigned version of gipir928_pkg
-to handle displaying of treaties exceeding the page width
-for faster report generation
*/

CREATE OR REPLACE PACKAGE BODY cpi.gipir928_pkg
AS
   FUNCTION get_main (
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN main_tab PIPELINED
   IS
      v                       main_type;
      v_peril_row_no          NUMBER;
      v_col_counter           NUMBER           := 0;
      v_dummy_group_counter   NUMBER           := 0;
      v_iss_line              VARCHAR2 (50);
      v_peril_recs            VARCHAR2 (32767);
      v_tsi                   NUMBER;
      v_prem                  NUMBER;
      v_pol_tsi               NUMBER           := 0;
      v_pol_prem              NUMBER           := 0;

      TYPE share_cd_type IS TABLE OF NUMBER;

      iss_line_share_cds      share_cd_type;

      TYPE peril_recs_type IS RECORD (
         share_cd   NUMBER,
         peril_cd   NUMBER,
         tsi        NUMBER,
         prem       NUMBER
      );

      TYPE peril_recs_tab IS TABLE OF peril_recs_type;

      peril_recs              peril_recs_tab;
   BEGIN
      FOR i IN (SELECT DISTINCT DECODE (p_iss_param,
                                        1, NVL (b.cred_branch, b.iss_cd),
                                        b.iss_cd
                                       ) iss_cd,
                                g.iss_name, b.line_cd, e.line_name,
                                b.subline_cd, f.subline_name, b.policy_id,
                                b.policy_no, b.peril_cd,
                                DECODE (c.peril_type,
                                        'B', '*' || c.peril_sname,
                                        ' ' || c.peril_sname
                                       ) peril_sname
                           FROM gipi_uwreports_dist_peril_ext b,
                                giis_peril c,
                                giis_subline f,
                                giis_issource g,
                                giis_line e
                          WHERE 1 = 1
                            AND b.line_cd = c.line_cd
                            AND b.peril_cd = c.peril_cd
                            AND b.line_cd = f.line_cd
                            AND b.subline_cd = f.subline_cd
                            AND b.line_cd = e.line_cd
                            AND DECODE (p_iss_param,
                                        1, NVL (b.cred_branch, b.iss_cd),
                                        b.iss_cd
                                       ) = g.iss_cd
                            AND DECODE (p_iss_param,
                                        1, NVL (b.cred_branch, b.iss_cd),
                                        b.iss_cd
                                       ) LIKE NVL (p_iss_cd, '%')
                            AND b.line_cd LIKE NVL (p_line_cd, '%')
                            AND b.share_type = 2
                            AND b.user_id = p_user_id
                            AND (   (    p_scope = 3
                                     AND b.endt_seq_no = b.endt_seq_no
                                    )
                                 OR (p_scope = 1 AND b.endt_seq_no = 0)
                                 OR (p_scope = 2 AND b.endt_seq_no > 0)
                                )
                            AND b.subline_cd LIKE NVL (p_subline_cd, '%')
                       ORDER BY DECODE (p_iss_param,
                                        1, NVL (b.cred_branch, b.iss_cd),
                                        b.iss_cd
                                       ),
                                b.line_cd,
                                f.subline_name,
                                b.policy_no,
                                b.peril_cd)
      LOOP
         IF v.company_name IS NULL
         THEN
            v.company_name := giisp.v ('COMPANY_NAME');
            v.company_address := giisp.v ('COMPANY_ADDRESS');

            BEGIN
               SELECT report_title
                 INTO v.report_title
                 FROM giis_reports
                WHERE report_id = 'GIPIR928';
            END;

            BEGIN
               SELECT    'From '
                      || TRIM (TO_CHAR (from_date1, 'Month'))
                      || ' '
                      || TO_CHAR (from_date1, 'DD, YYYY')
                      || ' to '
                      || TRIM (TO_CHAR (to_date1, 'Month'))
                      || ' '
                      || TO_CHAR (to_date1, 'DD, YYYY') TO_DATE
                 INTO v.date_range
                 FROM gipi_uwreports_dist_peril_ext
                WHERE user_id = p_user_id AND ROWNUM = 1;
            END;

            DECLARE
               v_param_date   gipi_uwreports_dist_peril_ext.param_date%TYPE;
            BEGIN
               SELECT param_date
                 INTO v_param_date
                 FROM gipi_uwreports_dist_peril_ext
                WHERE user_id = p_user_id AND ROWNUM = 1;

               IF v_param_date = 1
               THEN
                  v.based_on := 'Based on Issue Date';
               ELSIF v_param_date = 2
               THEN
                  v.based_on := 'Based on Inception Date';
               ELSIF v_param_date = 3
               THEN
                  v.based_on := 'Based on Booking month - year';
               ELSIF v_param_date = 4
               THEN
                  v.based_on := 'Based on Acctg Entry Date';
               END IF;
            END;
         END IF;

         IF v.policy_id IS NULL OR v.policy_id <> i.policy_id
         THEN
            v_peril_row_no := 1;
         ELSE
            v_peril_row_no := v_peril_row_no + 1;
         END IF;

         IF v_iss_line IS NULL OR v_iss_line <> i.iss_cd || '-' || i.line_cd
         THEN
            SELECT   share_cd
            BULK COLLECT INTO iss_line_share_cds
                FROM gipi_uwreports_dist_peril_ext
               WHERE DECODE (p_iss_param,
                             1, NVL (cred_branch, iss_cd),
                             iss_cd
                            ) = i.iss_cd
                 AND line_cd = i.line_cd
                 AND share_type = 2
                 AND user_id = p_user_id
                 AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                      OR (p_scope = 1 AND endt_seq_no = 0)
                      OR (p_scope = 2 AND endt_seq_no > 0)
                     )
            GROUP BY share_cd, trty_name
            ORDER BY share_cd;
         END IF;

         SELECT share_cd,
                peril_cd,
                NVL (tr_dist_tsi, 0) tsi,
                NVL (tr_dist_prem, 0) prem
         BULK COLLECT INTO peril_recs
           FROM gipi_uwreports_dist_peril_ext
          WHERE DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd) =
                                                                      i.iss_cd
            AND line_cd = i.line_cd
            AND subline_cd = i.subline_cd
            AND policy_id = i.policy_id
            AND share_type = 2
            AND user_id = p_user_id
            AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                 OR (p_scope = 1 AND endt_seq_no = 0)
                 OR (p_scope = 2 AND endt_seq_no > 0)
                );

         v_iss_line := i.iss_cd || '-' || i.line_cd;
         v.iss_cd := i.iss_cd;
         v.iss_name := i.iss_name;
         v.line_cd := i.line_cd;
         v.line_name := i.line_name;
         v.subline_cd := i.subline_cd;
         v.subline_name := i.subline_name;
         v.policy_id := i.policy_id;
         v.policy_no := i.policy_no;
         v.peril_cd := i.peril_cd;
         v.peril_sname := i.peril_sname;
         v.peril_row_no := v_peril_row_no;
         v.share_cds := NULL;

         FOR j IN 1 .. iss_line_share_cds.LAST
         LOOP
            v.share_cds := v.share_cds || iss_line_share_cds (j) || ',';
         END LOOP;

         v.share_cds := SUBSTR (v.share_cds, 1, LENGTH (v.share_cds) - 1);

         FOR j IN 1 .. iss_line_share_cds.LAST
         LOOP
            FOR k IN 1 .. peril_recs.LAST
            LOOP
               IF     iss_line_share_cds (j) = peril_recs (k).share_cd
                  AND i.peril_cd = peril_recs (k).peril_cd
               THEN
                  v_tsi := peril_recs (k).tsi;
                  v_prem := peril_recs (k).prem;
                  EXIT;
               ELSE
                  v_tsi := 0;
                  v_prem := 0;
               END IF;
            END LOOP;

            FOR l IN 1 .. peril_recs.LAST
            LOOP
               IF iss_line_share_cds (j) = peril_recs (l).share_cd
               THEN
                  v_pol_tsi := v_pol_tsi + peril_recs (l).tsi;
                  v_pol_prem := v_pol_prem + peril_recs (l).prem;
               END IF;
            END LOOP;

            v_col_counter := v_col_counter + 1;

            IF v_col_counter = 1
            THEN
               v.tsi1 := v_tsi;
               v.prem1 := v_prem;
               v.pol_tsi1 := v_pol_tsi;
               v.pol_prem1 := v_pol_prem;
            ELSIF v_col_counter = 2
            THEN
               v.tsi2 := v_tsi;
               v.prem2 := v_prem;
               v.pol_tsi2 := v_pol_tsi;
               v.pol_prem2 := v_pol_prem;
            ELSIF v_col_counter = 3
            THEN
               v.tsi3 := v_tsi;
               v.prem3 := v_prem;
               v.pol_tsi3 := v_pol_tsi;
               v.pol_prem3 := v_pol_prem;
            ELSIF v_col_counter = 4
            THEN
               v.tsi4 := v_tsi;
               v.prem4 := v_prem;
               v.pol_tsi4 := v_pol_tsi;
               v.pol_prem4 := v_pol_prem;
            ELSIF v_col_counter = 5
            THEN
               v.tsi5 := v_tsi;
               v.prem5 := v_prem;
               v.pol_tsi5 := v_pol_tsi;
               v.pol_prem5 := v_pol_prem;
               v_dummy_group_counter := v_dummy_group_counter + 1;
               v.dummy_group :=
                  i.iss_cd || '-' || i.line_cd || '-'
                  || v_dummy_group_counter;
               v_col_counter := 0;
               PIPE ROW (v);
               v.tsi1 := NULL;
               v.prem1 := NULL;
               v.tsi2 := NULL;
               v.prem2 := NULL;
               v.tsi3 := NULL;
               v.prem3 := NULL;
               v.tsi4 := NULL;
               v.prem4 := NULL;
               v.tsi5 := NULL;
               v.prem5 := NULL;
               v.pol_tsi1 := NULL;
               v.pol_prem1 := NULL;
               v.pol_tsi2 := NULL;
               v.pol_prem2 := NULL;
               v.pol_tsi3 := NULL;
               v.pol_prem3 := NULL;
               v.pol_tsi4 := NULL;
               v.pol_prem4 := NULL;
               v.pol_tsi5 := NULL;
               v.pol_prem5 := NULL;
            END IF;

            v_pol_tsi := 0;
            v_pol_prem := 0;
         END LOOP;

         IF v_col_counter <> 0
         THEN
            v_dummy_group_counter := v_dummy_group_counter + 1;
            v.dummy_group :=
                 i.iss_cd || '-' || i.line_cd || '-' || v_dummy_group_counter;
            PIPE ROW (v);
            v.tsi1 := NULL;
            v.prem1 := NULL;
            v.tsi2 := NULL;
            v.prem2 := NULL;
            v.tsi3 := NULL;
            v.prem3 := NULL;
            v.tsi4 := NULL;
            v.prem4 := NULL;
            v.tsi5 := NULL;
            v.prem5 := NULL;
            v.pol_tsi1 := NULL;
            v.pol_prem1 := NULL;
            v.pol_tsi2 := NULL;
            v.pol_prem2 := NULL;
            v.pol_tsi3 := NULL;
            v.pol_prem3 := NULL;
            v.pol_tsi4 := NULL;
            v.pol_prem4 := NULL;
            v.pol_tsi5 := NULL;
            v.pol_prem5 := NULL;
         END IF;

         v_col_counter := 0;
         v_dummy_group_counter := 0;
         v_pol_tsi := 0;
         v_pol_prem := 0;
      END LOOP i;
      
      IF v.company_name IS NULL
         THEN
            v.company_name := giisp.v ('COMPANY_NAME');
            v.company_address := giisp.v ('COMPANY_ADDRESS');

            BEGIN
               SELECT report_title
                 INTO v.report_title
                 FROM giis_reports
                WHERE report_id = 'GIPIR928';
            END;

            BEGIN
               SELECT    'From '
                      || TRIM (TO_CHAR (from_date1, 'Month'))
                      || ' '
                      || TO_CHAR (from_date1, 'DD, YYYY')
                      || ' to '
                      || TRIM (TO_CHAR (to_date1, 'Month'))
                      || ' '
                      || TO_CHAR (to_date1, 'DD, YYYY') TO_DATE
                 INTO v.date_range
                 FROM gipi_uwreports_dist_peril_ext
                WHERE user_id = p_user_id AND ROWNUM = 1;
            END;

            DECLARE
               v_param_date   gipi_uwreports_dist_peril_ext.param_date%TYPE;
            BEGIN
               SELECT param_date
                 INTO v_param_date
                 FROM gipi_uwreports_dist_peril_ext
                WHERE user_id = p_user_id AND ROWNUM = 1;

               IF v_param_date = 1
               THEN
                  v.based_on := 'Based on Issue Date';
               ELSIF v_param_date = 2
               THEN
                  v.based_on := 'Based on Inception Date';
               ELSIF v_param_date = 3
               THEN
                  v.based_on := 'Based on Booking month - year';
               ELSIF v_param_date = 4
               THEN
                  v.based_on := 'Based on Acctg Entry Date';
               END IF;
            END;
            PIPE ROW(v);
         END IF;
      
   END get_main;

   FUNCTION get_cols (
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_share_cds   VARCHAR2
   )
      RETURN col_tab PIPELINED
   IS
      v                       col_type;
      v_col_counter           NUMBER   := 1;
      v_dummy_group_counter   NUMBER   := 0;
   BEGIN
      FOR i IN (SELECT   a.share_cd, b.trty_name
                    FROM (SELECT     REGEXP_SUBSTR (p_share_cds,
                                                    '[^,]+',
                                                    1,
                                                    LEVEL
                                                   ) share_cd
                                FROM DUAL
                          CONNECT BY REGEXP_SUBSTR (p_share_cds,
                                                    '[^,]+',
                                                    1,
                                                    LEVEL
                                                   ) IS NOT NULL) a,
                         giis_dist_share b
                   WHERE b.line_cd = p_line_cd AND a.share_cd = b.share_cd
                ORDER BY a.share_cd)
      LOOP
         IF v_col_counter = 1
         THEN
            v.col1 := i.trty_name;
         ELSIF v_col_counter = 2
         THEN
            v.col2 := i.trty_name;
         ELSIF v_col_counter = 3
         THEN
            v.col3 := i.trty_name;
         ELSIF v_col_counter = 4
         THEN
            v.col4 := i.trty_name;
         ELSIF v_col_counter = 5
         THEN
            v.col5 := i.trty_name;
            v_dummy_group_counter := v_dummy_group_counter + 1;
            v.dummy_group :=
                 p_iss_cd || '-' || p_line_cd || '-' || v_dummy_group_counter;
            PIPE ROW (v);
            v.col1 := NULL;
            v.col2 := NULL;
            v.col3 := NULL;
            v.col4 := NULL;
            v.col5 := NULL;
            v_col_counter := 0;
         END IF;

         v_col_counter := v_col_counter + 1;
         v.dummy_group := p_iss_cd || '-' || p_line_cd;
      END LOOP;

      IF v_col_counter <> 1
      THEN
         v_dummy_group_counter := v_dummy_group_counter + 1;
         v.dummy_group := v.dummy_group || '-' || v_dummy_group_counter;
         PIPE ROW (v);
      END IF;
   END get_cols;

   FUNCTION get_recaps (
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_user_id      VARCHAR2,
      p_share_cds    VARCHAR2
   )
      RETURN recap_tab PIPELINED
   IS
      v                       recap_type;
      v_tsi                   NUMBER;
      v_prem                  NUMBER;
      v_col_counter           NUMBER         := 0;
      v_dummy_group_counter   NUMBER         := 0;

      TYPE share_cd_type IS TABLE OF NUMBER;

      iss_line_share_cds      share_cd_type;

      TYPE peril_recs_type IS RECORD (
         share_cd   NUMBER,
         peril_cd   NUMBER,
         tsi        NUMBER,
         prem       NUMBER
      );

      TYPE peril_recs_tab IS TABLE OF peril_recs_type;

      peril_recs              peril_recs_tab;
   BEGIN
      SELECT share_cd
      BULK COLLECT INTO iss_line_share_cds
        FROM (SELECT     REGEXP_SUBSTR (p_share_cds,
                                        '[^,]+',
                                        1,
                                        LEVEL
                                       ) share_cd
                    FROM DUAL
              CONNECT BY REGEXP_SUBSTR (p_share_cds, '[^,]+', 1, LEVEL) IS NOT NULL);

      SELECT   share_cd,
               peril_cd,
               SUM (NVL (tr_dist_tsi, 0)) tsi,
               SUM (NVL (tr_dist_prem, 0)) prem
      BULK COLLECT INTO peril_recs
          FROM gipi_uwreports_dist_peril_ext
         WHERE DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd) =
                                                                      p_iss_cd
           AND line_cd = p_line_cd
           AND subline_cd LIKE NVL (p_subline_cd, '%')
           AND share_type = 2
           AND user_id = p_user_id
           AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                OR (p_scope = 1 AND endt_seq_no = 0)
                OR (p_scope = 2 AND endt_seq_no > 0)
               )
      GROUP BY share_cd, trty_name, peril_cd;

      FOR i IN (SELECT   b.peril_cd,
                         DECODE (b.peril_type,
                                 'B', '*' || b.peril_sname,
                                 ' ' || b.peril_sname
                                ) peril_sname
                    FROM gipi_uwreports_dist_peril_ext a, giis_peril b
                   WHERE a.line_cd = b.line_cd
                     AND a.peril_cd = b.peril_cd
                     AND DECODE (p_iss_param,
                                 1, NVL (a.cred_branch, a.iss_cd),
                                 a.iss_cd
                                ) = p_iss_cd
                     AND a.line_cd = p_line_cd
                     AND a.subline_cd LIKE NVL (p_subline_cd, '%')
                     AND a.share_type = 2
                     AND a.user_id = p_user_id
                     AND (   (p_scope = 3 AND a.endt_seq_no = a.endt_seq_no)
                          OR (p_scope = 1 AND a.endt_seq_no = 0)
                          OR (p_scope = 2 AND a.endt_seq_no > 0)
                         )
                GROUP BY b.peril_cd,
                         DECODE (b.peril_type,
                                 'B', '*' || b.peril_sname,
                                 ' ' || b.peril_sname
                                )
                ORDER BY b.peril_cd)
      LOOP
         v.peril_sname := i.peril_sname;

         FOR j IN 1 .. iss_line_share_cds.LAST
         LOOP
            FOR k IN 1 .. peril_recs.LAST
            LOOP
               IF     iss_line_share_cds (j) = peril_recs (k).share_cd
                  AND peril_recs (k).peril_cd = i.peril_cd
               THEN
                  v_tsi := peril_recs (k).tsi;
                  v_prem := peril_recs (k).prem;
                  EXIT;
               ELSE
                  v_tsi := 0;
                  v_prem := 0;
               END IF;
            END LOOP;

            v_col_counter := v_col_counter + 1;

            IF v_col_counter = 1
            THEN
               v.tsi1 := v_tsi;
               v.prem1 := v_prem;
            ELSIF v_col_counter = 2
            THEN
               v.tsi2 := v_tsi;
               v.prem2 := v_prem;
            ELSIF v_col_counter = 3
            THEN
               v.tsi3 := v_tsi;
               v.prem3 := v_prem;
            ELSIF v_col_counter = 4
            THEN
               v.tsi4 := v_tsi;
               v.prem4 := v_prem;
            ELSIF v_col_counter = 5
            THEN
               v.tsi5 := v_tsi;
               v.prem5 := v_prem;
               v_dummy_group_counter := v_dummy_group_counter + 1;
               v.dummy_group :=
                  p_iss_cd || '-' || p_line_cd || '-'
                  || v_dummy_group_counter;
               v_col_counter := 0;
               PIPE ROW (v);
               v.tsi1 := NULL;
               v.prem1 := NULL;
               v.tsi2 := NULL;
               v.prem2 := NULL;
               v.tsi3 := NULL;
               v.prem3 := NULL;
               v.tsi4 := NULL;
               v.prem4 := NULL;
               v.tsi5 := NULL;
               v.prem5 := NULL;
            END IF;
         END LOOP;

         IF v_col_counter <> 0
         THEN
            v_dummy_group_counter := v_dummy_group_counter + 1;
            v.dummy_group :=
                 p_iss_cd || '-' || p_line_cd || '-' || v_dummy_group_counter;
            PIPE ROW (v);
            v.tsi1 := NULL;
            v.prem1 := NULL;
            v.tsi2 := NULL;
            v.prem2 := NULL;
            v.tsi3 := NULL;
            v.prem3 := NULL;
            v.tsi4 := NULL;
            v.prem4 := NULL;
            v.tsi5 := NULL;
            v.prem5 := NULL;
         END IF;

         v_dummy_group_counter := 0;
         v_col_counter := 0;
      END LOOP;
   END get_recaps;
END gipir928_pkg;
/