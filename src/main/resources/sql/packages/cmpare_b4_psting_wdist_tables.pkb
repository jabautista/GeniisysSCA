CREATE OR REPLACE PACKAGE BODY CPI.cmpare_b4_psting_wdist_tables
AS
/*Modified by: Ariel P. Ignas Jr.
 *Date Modified: 06.05.14
 *Modification: Added validation to check if there are shares with 0 tsi/ 0 prem/ 0 dist_spct*/

   /*Created by: Aldren Retardo
   *Purpose: Compares amounts of a certain working distribution table against a certain working distribution table. If there's a discrep, distribution
   *will not be posted.
   *Version Date: 05272014*/
   PROCEDURE wpolicyds_vs_wpolicyds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   )
   IS
      v_valid       BOOLEAN := TRUE;
      v_exit_loop   BOOLEAN := FALSE;
   BEGIN
      --added. 06.04.14 apignas_jr.
      FOR chk IN (SELECT a.tsi_amt, a.prem_amt, b.dist_spct,
                         NVL (b.dist_spct1, 0) dist_spct1, c.post_flag
                    FROM giuw_wpolicyds a,
                         giuw_wpolicyds_dtl b,
                         giuw_pol_dist c
                   WHERE a.dist_no = b.dist_no
                     AND a.dist_seq_no = b.dist_seq_no
                     AND a.dist_no = c.dist_no
                     AND a.dist_no = p_dist_no
                     AND c.post_flag = 'P'
--                     AND a.tsi_amt = 0
--                     AND a.prem_amt = 0
                     AND b.dist_spct = 0
                     AND NVL (b.dist_spct1, b.dist_spct) = 0)
      LOOP
         msg1 := 'Cannot post distribution. Please distribute by group.';
         msg2 := 'I';
         msg3 := TRUE;
         v_valid := FALSE;
         EXIT;
      END LOOP;

      --06.04.14
      IF v_valid
      THEN
         FOR rec IN (SELECT c.dist_no, c.dist_seq_no,
                            ROUND (c.tsi_amt, 2) tsi_amt,
                            ROUND (c.prem_amt, 2) prem_amt,
                            ROUND (c.ann_tsi_amt, 2) ann_tsi_amt,
                            f.post_flag
                       FROM giuw_wpolicyds c, giuw_pol_dist f
                      WHERE c.dist_no = p_dist_no AND c.dist_no = f.dist_no)
         LOOP
            FOR rec1 IN
               (SELECT   d.dist_no, d.dist_seq_no,
                         ROUND (NVL (SUM (d.dist_tsi), 0), 2) tsi_amt,
                         ROUND (NVL (SUM (d.dist_prem), 0), 2) prem_amt,
                         ROUND (NVL (SUM (d.dist_spct), 0), 9) dist_spct,
                         ROUND (NVL (SUM (d.dist_spct1), 0), 9) dist_spct1,
                         ROUND (NVL (SUM (d.ann_dist_tsi), 0),
                                2) ann_dist_tsi
                    FROM giuw_wpolicyds_dtl d
                   WHERE d.dist_no = p_dist_no
                     AND d.dist_seq_no = rec.dist_seq_no
                GROUP BY d.dist_no, d.dist_seq_no)
            LOOP
               IF    rec.tsi_amt <> rec1.tsi_amt
                  OR rec.prem_amt <> rec1.prem_amt
                  OR rec.ann_tsi_amt <> rec1.ann_dist_tsi
               THEN
                  msg1 :=
                     'Amounts in giuw_wpolicyds and giuw_wpolicyds_dtl are not equal. Please recreate items.';
                  msg2 := 'I';
                  msg3 := TRUE;
                  v_exit_loop := TRUE;
                  EXIT;
               ELSIF     rec1.dist_spct <> 100
                     AND NVL (rec1.dist_spct1, rec1.dist_spct) <> 100
               THEN
                  IF     rec.post_flag = 'P'
                     AND rec.tsi_amt = 0
                     AND rec.prem_amt = 0
                  THEN
                     msg1 :=
                         'Invalid Distribution Share %. Please consult CPI. ';
                     msg2 := 'I';
                     msg3 := TRUE;
                     v_exit_loop := TRUE;
                     EXIT;
                  ELSE
                     msg1 :=
                        'Invalid Distribution Share %. Please recreate items.';
                     msg2 := 'I';
                     msg3 := TRUE;
                     v_exit_loop := TRUE;
                     EXIT;
                  END IF;
               END IF;
            END LOOP;

            IF v_exit_loop                      --added. 06.25 .14 apignas_jr.
            THEN
               EXIT;
            END IF;
         END LOOP;
      END IF;
   END;

   PROCEDURE wperilds_vs_wperilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   )
   IS
      v_check_discrep   NUMBER  := 0;
      v_exit_loop       BOOLEAN := FALSE;
   BEGIN
      FOR rec IN (SELECT   dist_no, dist_seq_no,
                           ROUND (NVL (SUM (tsi_amt), 0), 2) tsi_amt,
                           ROUND (NVL (SUM (a.prem_amt), 0), 2) prem_amt,
                           ROUND (NVL (SUM (a.ann_tsi_amt), 0),
                                  2) ann_tsi_amt,
                           peril_cd
                      FROM giuw_wperilds a
                     WHERE a.dist_no = p_dist_no
                  GROUP BY a.dist_no, a.dist_seq_no, a.peril_cd)
      LOOP
         FOR rec1 IN (SELECT   b.dist_no, b.dist_seq_no,
                               ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                               ROUND (NVL (SUM (b.dist_prem), 0),
                                      2) dist_prem,
                               ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                      2
                                     ) ann_dist_tsi
                          FROM giuw_wperilds_dtl b
                         WHERE b.dist_no = p_dist_no
                           AND b.dist_seq_no = rec.dist_seq_no
                           AND b.peril_cd = rec.peril_cd
                      GROUP BY b.dist_no, b.dist_seq_no, b.peril_cd)
         LOOP
            IF    rec.tsi_amt <> rec1.dist_tsi
               OR rec.prem_amt <> rec1.dist_prem
               OR rec.ann_tsi_amt <> rec1.ann_dist_tsi
            THEN
               msg1 :=
                  'Amounts in wperilds and wperilds_dtl are not equal. Please recreate items.';
               msg2 := 'I';
               msg3 := TRUE;
               v_exit_loop := TRUE;
               EXIT;
            END IF;
         END LOOP;

         IF v_exit_loop
         THEN                                    --added. 06.25.14 apignas_jr.
            EXIT;
         END IF;
      END LOOP;
   END;

   PROCEDURE witemds_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   )
   IS
      v_check_discrep   NUMBER  := 0;
      v_valid           BOOLEAN := TRUE;
      v_exit_loop       BOOLEAN := FALSE;
   BEGIN
      --added. 06.04.14 apignas_jr.
      FOR chk IN (SELECT a.tsi_amt, a.prem_amt, b.dist_spct,
                         NVL (b.dist_spct1, 0) dist_spct1, c.post_flag
                    FROM giuw_witemds a, giuw_witemds_dtl b, giuw_pol_dist c
                   WHERE a.dist_no = b.dist_no
                     AND a.dist_seq_no = b.dist_seq_no
                     AND a.item_no = b.item_no
                     AND a.dist_no = c.dist_no
                     AND a.dist_no = p_dist_no
                     AND c.post_flag = 'P'
--                     AND a.tsi_amt = 0
--                     AND a.prem_amt = 0
                     AND b.dist_spct = 0
                     AND NVL (b.dist_spct1, b.dist_spct) = 0)
      LOOP
         msg1 := 'Cannot post distribution. Please distribute by group.';
         msg2 := 'I';
         msg3 := TRUE;
         v_valid := FALSE;
         EXIT;
      END LOOP;

      --06.04.14
      IF v_valid
      THEN
         FOR rec IN (SELECT a.dist_no, a.dist_seq_no,
                            ROUND (a.tsi_amt, 2) tsi_amt,
                            ROUND (a.prem_amt, 2) prem_amt, a.item_no,
                            ROUND (a.ann_tsi_amt, 2) ann_tsi_amt,
                            f.post_flag
                       FROM giuw_witemds a, giuw_pol_dist f
                      WHERE a.dist_no = p_dist_no AND a.dist_no = f.dist_no)
         LOOP
            FOR rec1 IN
               (SELECT   b.dist_no, b.dist_seq_no,
                         ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                         ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
                         b.item_no,
                         ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                2) ann_dist_tsi,
                         ROUND (NVL (SUM (b.dist_spct), 0), 9) dist_spct,
                         ROUND (NVL (SUM (b.dist_spct1), 0), 9) dist_spct1
                    FROM giuw_witemds_dtl b
                   WHERE b.dist_no = p_dist_no
                     AND b.dist_seq_no = rec.dist_seq_no
                     AND b.item_no = rec.item_no
                GROUP BY b.dist_no, b.dist_seq_no, b.item_no)
            LOOP
               IF    rec.tsi_amt <> rec1.dist_tsi
                  OR rec.prem_amt <> rec1.dist_prem
                  OR rec.ann_tsi_amt <> rec1.ann_dist_tsi
               THEN
                  msg1 :=
                     'Amounts in witemds and witemds_dtl are not equal. Please recreate items.';
                  msg2 := 'I';
                  msg3 := TRUE;
                  v_exit_loop := TRUE;
                  EXIT;
               ELSIF     rec1.dist_spct <> 100
                     AND NVL (rec1.dist_spct1, rec1.dist_spct) <> 100
               THEN
                  IF     rec.post_flag = 'P'
                     AND rec.tsi_amt = 0
                     AND rec.prem_amt = 0
                  THEN
                     msg1 :=
                          'Invalid Distribution Share %. Please consult CPI.';
                     msg2 := 'I';
                     msg3 := TRUE;
                     v_exit_loop := TRUE;
                     EXIT;
                  ELSE
                     msg1 :=
                        'Invalid Distribution Share %. Please recreate items.';
                     msg2 := 'I';
                     msg3 := TRUE;
                     v_exit_loop := TRUE;
                     EXIT;
                  END IF;
               END IF;
            END LOOP;

            IF v_exit_loop
            THEN                                 --added. 06.25.14 apignas_jr.
               EXIT;
            END IF;
         END LOOP;
      END IF;
   END;

   PROCEDURE witmprilds_vs_witmprilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   )
   IS
      v_check_discrep   NUMBER := 0;
   BEGIN
      FOR rec IN
         (SELECT c.dist_no, c.dist_seq_no, (c.tsi_amt - d.dist_tsi) tsi_diff,
                 (c.ann_tsi_amt - d.ann_dist_tsi) ann_tsi_diff,
                 (c.prem_amt - d.dist_prem) prem_diff, c.item_no, c.peril_cd,
                 c.tsi_amt, c.prem_amt
            FROM (SELECT   a.dist_no, a.dist_seq_no,
                           ROUND (NVL (SUM (a.tsi_amt), 0), 2) tsi_amt,
                           ROUND (NVL (SUM (a.prem_amt), 0), 2) prem_amt,
                           ROUND (NVL (SUM (a.ann_tsi_amt), 0),
                                  2) ann_tsi_amt, a.item_no, a.peril_cd
                      FROM giuw_witemperilds a
                     WHERE a.dist_no = p_dist_no
                  GROUP BY a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd) c,
                 (SELECT   b.dist_no, b.dist_seq_no,
                           ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
                           ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi,
                           b.item_no, b.peril_cd
                      FROM giuw_witemperilds_dtl b
                     WHERE b.dist_no = p_dist_no
                  GROUP BY b.dist_no, b.dist_seq_no, b.item_no, b.peril_cd) d
           WHERE c.dist_no = d.dist_no
             AND c.dist_seq_no = d.dist_seq_no
             AND c.item_no = d.item_no
             AND c.peril_cd = d.peril_cd)
      LOOP
         IF rec.tsi_diff <> 0 OR rec.prem_diff <> 0 OR rec.ann_tsi_diff <> 0
         THEN
            msg1 :=
               'Amounts in witemperilds and witemperilds_dtl are not equal. Please recreate items.';
            msg2 := 'I';
            msg3 := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END;

   PROCEDURE witmprlds_dtl_vs_wplicyds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   )
   IS
      v_check_discrep   NUMBER := 0;
   BEGIN
      FOR rec IN
         (SELECT e.dist_no, e.dist_seq_no, e.dist_tsi, e.dist_prem,
                 e.share_cd, (d.dist_tsi - e.dist_tsi) diff_dist_tsi,
                 (d.ann_dist_tsi - e.ann_dist_tsi) diff_ann_dist_tsi,
                 (d.dist_prem - e.dist_prem) diff_dist_prem
            FROM (SELECT   a.dist_no, a.dist_seq_no,
                           ROUND (NVL (SUM (DECODE (c.peril_type,
                                                    'A', 0,
                                                    'B', a.dist_tsi
                                                   )
                                           ),
                                       0
                                      ),
                                  2
                                 ) dist_tsi,
                           ROUND (NVL (SUM (a.dist_prem), 0), 2) dist_prem,
                           a.share_cd,
                           ROUND
                              (NVL (SUM (DECODE (c.peril_type,
                                                 'A', 0,
                                                 'B', a.ann_dist_tsi
                                                )
                                        ),
                                    0
                                   ),
                               2
                              ) ann_dist_tsi
                      FROM giuw_witemperilds_dtl a, giis_peril c
                     WHERE a.dist_no = p_dist_no
                       AND a.line_cd = c.line_cd
                       AND a.peril_cd = c.peril_cd
                  GROUP BY a.dist_no, a.dist_seq_no, a.share_cd) d,
                 (SELECT   b.dist_no, b.dist_seq_no,
                           ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
                           b.share_cd,
                           ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi
                      FROM giuw_wpolicyds_dtl b
                     WHERE b.dist_no = p_dist_no
                  GROUP BY b.dist_no, b.dist_seq_no, b.share_cd) e
           WHERE d.dist_no = e.dist_no
             AND d.dist_seq_no = e.dist_seq_no
             AND d.share_cd = e.share_cd)
      LOOP
         IF    rec.diff_dist_tsi <> 0
            OR rec.diff_dist_prem <> 0
            OR rec.diff_ann_dist_tsi <> 0
         THEN
            msg1 :=
               'Amounts in witemperilds_dtl and wpolicyds_dtl are not equal. Please recreate items.';
            msg2 := 'I';
            msg3 := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END;

   PROCEDURE witmprilds_dtl_vs_wprilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   )
   IS
      v_check_discrep   NUMBER := 0;
   BEGIN
      FOR rec IN
         (SELECT d.dist_no, d.dist_seq_no, d.share_cd, d.peril_cd,
                 d.dist_tsi, d.dist_prem,
                 (c.dist_tsi - d.dist_tsi) diff_dist_tsi,
                 (c.ann_dist_tsi - d.ann_dist_tsi) diff_ann_dist_tsi,
                 (c.dist_prem - d.dist_prem) diff_dist_prem
            FROM (SELECT   a.dist_no, a.dist_seq_no, a.peril_cd, a.share_cd,
                           ROUND (NVL (SUM (a.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (a.dist_prem), 0), 2) dist_prem,
                           ROUND (NVL (SUM (a.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi
                      FROM giuw_witemperilds_dtl a
                     WHERE a.dist_no = p_dist_no
                  GROUP BY a.dist_no, a.dist_seq_no, a.peril_cd, a.share_cd) c,
                 (SELECT   b.dist_no, b.dist_seq_no, share_cd, peril_cd,
                           ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
                           ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi
                      FROM giuw_wperilds_dtl b
                     WHERE b.dist_no = p_dist_no
                  GROUP BY b.dist_no, b.dist_seq_no, b.share_cd, b.peril_cd) d
           WHERE c.dist_no = d.dist_no
             AND c.dist_seq_no = d.dist_seq_no
             AND c.share_cd = d.share_cd
             AND c.peril_cd = d.peril_cd)
      LOOP
         IF    rec.diff_dist_tsi <> 0
            OR rec.diff_dist_prem <> 0
            OR rec.diff_ann_dist_tsi <> 0
         THEN
            msg1 :=
               'Amounts in witemperilds_dtl and wperilds_dtl are not equal. Please recreate items.';
            msg2 := 'I';
            msg3 := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END;

   PROCEDURE witmprilds_dtl_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   )
   IS
      v_check_discrep   NUMBER := 0;
   BEGIN
      FOR rec IN
         (SELECT e.dist_no, e.dist_seq_no, e.dist_tsi, e.dist_prem,
                 e.share_cd, e.item_no,
                 (d.dist_tsi - e.dist_tsi) diff_dist_tsi,
                 (d.ann_dist_tsi - e.ann_dist_tsi) diff_ann_dist_tsi,
                 (d.dist_prem - e.dist_prem) diff_dist_prem
            FROM (SELECT   a.dist_no, a.dist_seq_no,
                           ROUND (NVL (SUM (DECODE (c.peril_type,
                                                    'A', 0,
                                                    'B', a.dist_tsi
                                                   )
                                           ),
                                       0
                                      ),
                                  2
                                 ) dist_tsi,
                           ROUND (NVL (SUM (a.dist_prem), 0), 2) dist_prem,
                           a.share_cd, a.item_no,
                           ROUND
                              (NVL (SUM (DECODE (c.peril_type,
                                                 'A', 0,
                                                 'B', a.ann_dist_tsi
                                                )
                                        ),
                                    0
                                   ),
                               2
                              ) ann_dist_tsi
                      FROM giuw_witemperilds_dtl a, giis_peril c
                     WHERE a.dist_no = p_dist_no
                       AND a.line_cd = c.line_cd
                       AND a.peril_cd = c.peril_cd
                  GROUP BY a.dist_no, a.dist_seq_no, a.item_no, a.share_cd) d,
                 (SELECT   b.dist_no, b.dist_seq_no,
                           ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
                           b.share_cd, b.item_no,
                           ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi
                      FROM giuw_witemds_dtl b
                     WHERE b.dist_no = p_dist_no
                  GROUP BY b.dist_no, b.dist_seq_no, b.item_no, b.share_cd) e
           WHERE d.dist_no = p_dist_no
             AND d.dist_seq_no = e.dist_seq_no
             AND d.item_no = e.item_no
             AND d.share_cd = e.share_cd)
      LOOP
         IF    rec.diff_dist_tsi <> 0
            OR rec.diff_dist_prem <> 0
            OR rec.diff_ann_dist_tsi <> 0
         THEN
            msg1 :=
               'Amounts in witemperilds_dtl and witemds_dtl are not equal. Please recreate items.';
            msg2 := 'I';
            msg3 := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END;

   PROCEDURE wpolicyds_dtl_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   )
   IS
      v_check_discrep   NUMBER := 0;
   BEGIN
      FOR rec IN
         (SELECT c.dist_tsi, c.dist_prem,
                 (c.dist_tsi - d.dist_tsi) diff_dist_tsi,
                 (c.ann_dist_tsi - d.ann_dist_tsi) diff_ann_dist_tsi,
                 (c.dist_prem - d.dist_prem) diff_dist_prem
            FROM (SELECT   a.dist_no, a.dist_seq_no,
                           ROUND (NVL (SUM (a.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (a.dist_prem), 0), 2) dist_prem,
                           a.line_cd, a.share_cd,
                           ROUND (NVL (SUM (a.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi
                      FROM giuw_wpolicyds_dtl a
                     WHERE a.dist_no = p_dist_no
                  GROUP BY a.dist_no, a.dist_seq_no, a.share_cd, a.line_cd) c,
                 (SELECT   b.dist_no, b.dist_seq_no,
                           ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
                           b.line_cd, b.share_cd,
                           ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi
                      FROM giuw_witemds_dtl b
                     WHERE b.dist_no = p_dist_no
                  GROUP BY b.dist_no, b.dist_seq_no, b.share_cd, b.line_cd) d
           WHERE c.dist_no = d.dist_no
             AND c.dist_seq_no = d.dist_seq_no
             AND c.share_cd = d.share_cd
             AND c.line_cd = d.line_cd)
      LOOP
         IF    rec.diff_dist_tsi <> 0
            OR rec.diff_dist_prem <> 0
            OR rec.diff_ann_dist_tsi <> 0
         THEN
            msg1 :=
               'Amounts in wpolicyds_dtl and witemds_dtl are not equal. Please recreate items.';
            msg2 := 'I';
            msg3 := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END;

   PROCEDURE wpolcyds_dtl_vs_wperilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg1        OUT      VARCHAR2,
      msg2        OUT      VARCHAR2,
      msg3        OUT      BOOLEAN
   )
   IS
      v_check_discrep   NUMBER  := 0;
      v_valid           BOOLEAN := TRUE;           --added by aldren 06062014
   BEGIN
      FOR rec IN
         (SELECT d.dist_tsi, (d.dist_tsi - e.dist_tsi) diff_dist_tsi,
                 (d.ann_dist_tsi - e.ann_dist_tsi) diff_ann_dist_tsi,
                 d.dist_prem, (d.dist_prem - e.dist_prem) diff_dist_prem
            FROM (SELECT   a.dist_no, a.dist_seq_no,
                           ROUND (NVL (SUM (a.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (a.dist_prem), 0), 2) dist_prem,
                           a.share_cd,
                           ROUND (NVL (SUM (a.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi
                      FROM giuw_wpolicyds_dtl a
                     WHERE a.dist_no = p_dist_no
                  GROUP BY a.dist_no, a.dist_seq_no, a.share_cd) d,
                 (SELECT   b.dist_no, b.dist_seq_no,
                           ROUND (NVL (SUM (DECODE (c.peril_type,
                                                    'A', 0,
                                                    b.dist_tsi
                                                   )
                                           ),
                                       0
                                      ),
                                  2
                                 ) dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
                           b.share_cd,
                           ROUND
                              (NVL (SUM (DECODE (c.peril_type,
                                                 'A', 0,
                                                 b.ann_dist_tsi
                                                )
                                        ),
                                    0
                                   ),
                               2
                              ) ann_dist_tsi
                      FROM giuw_wperilds_dtl b, giis_peril c
                     WHERE b.dist_no = p_dist_no
                       AND b.line_cd = c.line_cd
                       AND b.peril_cd = c.peril_cd
                  GROUP BY b.dist_no, b.dist_seq_no, b.share_cd) e
           WHERE d.dist_no = e.dist_no
             AND d.dist_seq_no = e.dist_seq_no
             AND d.share_cd = e.share_cd)
      LOOP
         IF    rec.diff_dist_tsi <> 0
            OR rec.diff_dist_prem <> 0
            OR rec.diff_ann_dist_tsi <> 0
         THEN
            msg1 :=
               'Amounts in wpolicyds_dtl and wperilds_dtl are not equal. Please recreate items.';
            msg2 := 'I';
            msg3 := TRUE;
            v_valid := FALSE;                      --added by aldren 06062014
            EXIT;
         END IF;
      END LOOP;

--added by aldren 06062014--
      IF v_valid
      THEN
         FOR chk IN (SELECT a.dist_no, a.dist_seq_no, a.tot_fac_tsi,
                            b.dist_tsi, a.tot_fac_prem, b.dist_prem,
                            b.dist_spct, a.tot_fac_spct, b.dist_spct1,
                            a.tot_fac_spct2,
                              NVL (a.tot_fac_tsi, 0)
                            - NVL (b.dist_tsi, 0) diff_tsi,
                              NVL (a.tot_fac_prem, 0)
                            - NVL (b.dist_prem, 0) diff_prem
                       FROM giri_wdistfrps a, giuw_wpolicyds_dtl b
                      WHERE a.dist_no = b.dist_no
                        AND a.dist_seq_no = b.dist_seq_no
                        AND a.dist_no = p_dist_no
                        AND b.share_cd = 999
                        AND (   NVL (a.tot_fac_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                             OR NVL (a.tot_fac_prem, 0) - NVL (b.dist_prem, 0) <>
                                                                             0
                             OR b.dist_spct <> a.tot_fac_spct
                             OR NVL (b.dist_spct1, dist_spct) <>
                                         NVL (a.tot_fac_spct2, a.tot_fac_spct)
                            ))
         LOOP
            msg1 :=
                 'Amounts in wdistfrps and giuw_wpolicyds_dtl are not equal.';
            msg2 := 'I';
            msg3 := TRUE;
            EXIT;
         END LOOP;
      END IF;
   --end by aldren 06062014--
   END;
END cmpare_b4_psting_wdist_tables;
/


