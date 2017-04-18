CREATE OR REPLACE PACKAGE BODY CPI.cmpare_del_rnsrt_wdist_tables
AS
   PROCEDURE wperilds_vs_wperilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      v_check_discrep_del   NUMBER := 0;
   BEGIN
      msg4 := NULL;

      FOR rec IN (SELECT   dist_no, dist_seq_no,
                           ROUND (NVL (SUM (tsi_amt), 0), 2) tsi_amt,
                           ROUND (NVL (SUM (a.prem_amt), 0), 2) prem_amt,
                           peril_cd,
                           ROUND (NVL (SUM (a.ann_tsi_amt), 0),
                                  2) ann_tsi_amt
                      FROM giuw_wperilds a
                     WHERE a.dist_no = p_dist_no
                  GROUP BY a.dist_no, a.dist_seq_no, a.peril_cd)
      LOOP
         FOR rec1 IN (SELECT   b.dist_no, b.dist_seq_no,
                               ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                               ROUND (NVL (SUM (b.dist_prem), 0),
                                      2) dist_prem,
                               b.peril_cd,
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
               v_check_discrep_del := v_check_discrep_del + 1;
               msg4 := '1';
               EXIT;
            END IF;
         END LOOP;
      END LOOP;

      IF v_check_discrep_del <> 0
      THEN
         cmpare_del_rnsrt_wdist_tables.del_rnsrt_wdist_tables (p_dist_no);
      END IF;
   END;

   PROCEDURE witemds_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      v_check_discrep_del   NUMBER := 0;
   BEGIN
      msg4 := NULL;

      FOR rec IN (SELECT   a.dist_no, a.dist_seq_no,
                           ROUND (NVL (SUM (a.tsi_amt), 0), 2) tsi_amt,
                           ROUND (NVL (SUM (a.ann_tsi_amt), 0),
                                  2) ann_tsi_amt,
                           ROUND (NVL (SUM (a.prem_amt), 0), 2) prem_amt,
                           a.item_no
                      FROM giuw_witemds a
                     WHERE a.dist_no = p_dist_no
                  GROUP BY a.dist_no, a.dist_seq_no, a.item_no)
      LOOP
         FOR rec1 IN (SELECT   b.dist_no, b.dist_seq_no,
                               ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                               ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                      2
                                     ) ann_dist_tsi,
                               ROUND (NVL (SUM (b.dist_prem), 0),
                                      2) dist_prem,
                               b.item_no
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
               v_check_discrep_del := v_check_discrep_del + 1;
               msg4 := '1';
               EXIT;
            END IF;
         END LOOP;
      END LOOP;

      IF v_check_discrep_del <> 0
      THEN
         cmpare_del_rnsrt_wdist_tables.del_rnsrt_wdist_tables (p_dist_no);
      END IF;
   END;

   PROCEDURE witmprilds_vs_witmprilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      v_check_discrep_del   NUMBER := 0;
   BEGIN
      msg4 := NULL;

      FOR rec IN
         (SELECT c.dist_no, c.dist_seq_no, (c.tsi_amt - d.dist_tsi) tsi_diff,
                 (c.ann_tsi_amt - d.ann_dist_tsi) ann_tsi_diff,
                 (c.prem_amt - d.dist_prem) prem_diff, c.item_no, c.peril_cd,
                 c.tsi_amt, c.prem_amt
            FROM (SELECT   a.dist_no, a.dist_seq_no,
                           ROUND (NVL (SUM (a.tsi_amt), 0), 2) tsi_amt,
                           ROUND (NVL (SUM (a.ann_tsi_amt), 0),
                                  2) ann_tsi_amt,
                           ROUND (NVL (SUM (a.prem_amt), 0), 2) prem_amt,
                           a.item_no, a.peril_cd
                      FROM giuw_witemperilds a
                     WHERE a.dist_no = p_dist_no
                  GROUP BY a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd) c,
                 (SELECT   b.dist_no, b.dist_seq_no,
                           ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
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
            v_check_discrep_del := v_check_discrep_del + 1;
            msg4 := '1';
            EXIT;
         END IF;
      END LOOP;

      IF v_check_discrep_del <> 0
      THEN
         cmpare_del_rnsrt_wdist_tables.del_rnsrt_wdist_tables (p_dist_no);
      END IF;
   END;

   PROCEDURE witmprlds_dtl_vs_wplicyds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      v_check_discrep_del   NUMBER := 0;
   BEGIN
      msg4 := NULL;

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
                           ROUND
                              (NVL (SUM (DECODE (c.peril_type,
                                                 'A', 0,
                                                 'B', a.ann_dist_tsi
                                                )
                                        ),
                                    0
                                   ),
                               2
                              ) ann_dist_tsi,
                           ROUND (NVL (SUM (a.dist_prem), 0), 2) dist_prem,
                           a.share_cd
                      FROM giuw_witemperilds_dtl a, giis_peril c
                     WHERE a.dist_no = p_dist_no
                       AND a.line_cd = c.line_cd
                       AND a.peril_cd = c.peril_cd
                  GROUP BY a.dist_no, a.dist_seq_no, a.share_cd) d,
                 (SELECT   b.dist_no, b.dist_seq_no,
                           ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
                           b.share_cd
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
            v_check_discrep_del := v_check_discrep_del + 1;
            msg4 := '1';
            EXIT;
         END IF;
      END LOOP;

      IF v_check_discrep_del <> 0
      THEN
         cmpare_del_rnsrt_wdist_tables.del_rnsrt_wdist_tables (p_dist_no);
      END IF;
   END;

   PROCEDURE witmprilds_dtl_vs_wprilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      v_check_discrep_del   NUMBER := 0;
   BEGIN
      msg4 := NULL;

      FOR rec IN
         (SELECT d.dist_no, d.dist_seq_no, d.share_cd, d.peril_cd,
                 d.dist_tsi, d.dist_prem,
                 (c.dist_tsi - d.dist_tsi) diff_dist_tsi,
                 (c.ann_dist_tsi - d.ann_dist_tsi) diff_ann_dist_tsi,
                 (c.dist_prem - d.dist_prem) diff_dist_prem
            FROM (SELECT   a.dist_no, a.dist_seq_no, a.peril_cd, a.share_cd,
                           ROUND (NVL (SUM (a.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (a.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi,
                           ROUND (NVL (SUM (a.dist_prem), 0), 2) dist_prem
                      FROM giuw_witemperilds_dtl a
                     WHERE a.dist_no = p_dist_no
                  GROUP BY a.dist_no, a.dist_seq_no, a.peril_cd, a.share_cd) c,
                 (SELECT   b.dist_no, b.dist_seq_no, share_cd, peril_cd,
                           ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem
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
            v_check_discrep_del := v_check_discrep_del + 1;
            msg4 := '1';
            EXIT;
         END IF;
      END LOOP;

      IF v_check_discrep_del <> 0
      THEN
         cmpare_del_rnsrt_wdist_tables.del_rnsrt_wdist_tables (p_dist_no);
      END IF;
   END;

   PROCEDURE witmprilds_dtl_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      v_check_discrep_del   NUMBER := 0;
   BEGIN
      msg4 := NULL;

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
                           ROUND
                              (NVL (SUM (DECODE (c.peril_type,
                                                 'A', 0,
                                                 'B', a.ann_dist_tsi
                                                )
                                        ),
                                    0
                                   ),
                               2
                              ) ann_dist_tsi,
                           ROUND (NVL (SUM (a.dist_prem), 0), 2) dist_prem,
                           a.share_cd, a.item_no
                      FROM giuw_witemperilds_dtl a, giis_peril c
                     WHERE a.dist_no = p_dist_no
                       AND a.line_cd = c.line_cd
                       AND a.peril_cd = c.peril_cd
                  GROUP BY a.dist_no, a.dist_seq_no, a.item_no, a.share_cd) d,
                 (SELECT   b.dist_no, b.dist_seq_no,
                           ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
                           b.share_cd, b.item_no
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
            v_check_discrep_del := v_check_discrep_del + 1;
            msg4 := '1';
            EXIT;
         END IF;
      END LOOP;

      IF v_check_discrep_del <> 0
      THEN
         cmpare_del_rnsrt_wdist_tables.del_rnsrt_wdist_tables (p_dist_no);
      END IF;
   END;

   PROCEDURE wpolicyds_dtl_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      v_check_discrep_del   NUMBER := 0;
   BEGIN
      msg4 := NULL;

      FOR rec IN
         (SELECT c.dist_tsi, c.dist_prem,
                 (c.dist_tsi - d.dist_tsi) diff_dist_tsi,
                 (c.ann_dist_tsi - d.ann_dist_tsi) diff_ann_dist_tsi,
                 (c.dist_prem - d.dist_prem) diff_dist_prem
            FROM (SELECT   a.dist_no, a.dist_seq_no,
                           ROUND (NVL (SUM (a.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (a.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi,
                           ROUND (NVL (SUM (a.dist_prem), 0), 2) dist_prem,
                           a.share_cd
                      FROM giuw_wpolicyds_dtl a
                     WHERE a.dist_no = p_dist_no
                  GROUP BY a.dist_no, a.dist_seq_no, a.share_cd) c,
                 (SELECT   b.dist_no, b.dist_seq_no,
                           ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
                           b.share_cd
                      FROM giuw_witemds_dtl b
                     WHERE b.dist_no = p_dist_no
                  GROUP BY b.dist_no, b.dist_seq_no, b.share_cd) d
           WHERE c.dist_no = d.dist_no
             AND c.dist_seq_no = d.dist_seq_no
             AND c.share_cd = d.share_cd)
      LOOP
         IF    rec.diff_dist_tsi <> 0
            OR rec.diff_dist_prem <> 0
            OR rec.diff_ann_dist_tsi <> 0
         THEN
            v_check_discrep_del := v_check_discrep_del + 1;
            msg4 := '1';
            EXIT;
         END IF;
      END LOOP;

      IF v_check_discrep_del <> 0
      THEN
         cmpare_del_rnsrt_wdist_tables.del_rnsrt_wdist_tables (p_dist_no);
      END IF;
   END;

   PROCEDURE wpolcyds_dtl_vs_wperilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      v_check_discrep_del   NUMBER := 0;
   BEGIN
      msg4 := NULL;

      FOR rec IN
         (SELECT d.dist_tsi, (d.dist_tsi - e.dist_tsi) diff_dist_tsi,
                 (d.ann_dist_tsi - e.ann_dist_tsi) diff_ann_dist_tsi,
                 d.dist_prem, (d.dist_prem - e.dist_prem) diff_dist_prem
            FROM (SELECT   a.dist_no, a.dist_seq_no,
                           ROUND (NVL (SUM (a.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (a.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi,
                           ROUND (NVL (SUM (a.dist_prem), 0), 2) dist_prem,
                           a.share_cd
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
                           ROUND
                              (NVL (SUM (DECODE (c.peril_type,
                                                 'A', 0,
                                                 b.ann_dist_tsi
                                                )
                                        ),
                                    0
                                   ),
                               2
                              ) ann_dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
                           b.share_cd
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
            v_check_discrep_del := v_check_discrep_del + 1;
            msg4 := '1';
            EXIT;
         END IF;
      END LOOP;

      IF v_check_discrep_del <> 0
      THEN
         cmpare_del_rnsrt_wdist_tables.del_rnsrt_wdist_tables (p_dist_no);
      END IF;
   END;

   PROCEDURE del_rnsrt_wdist_tables (p_dist_no IN giuw_pol_dist.dist_no%TYPE)
   IS
   BEGIN
      DELETE      giuw_witemds_dtl c
            WHERE c.dist_no = p_dist_no;

      DELETE      giuw_wperilds_dtl d
            WHERE d.dist_no = p_dist_no;

      DELETE      giuw_witemperilds_dtl e
            WHERE e.dist_no = p_dist_no;

      FOR rec3 IN (SELECT   a.dist_no, a.dist_seq_no,
                            ROUND (NVL (SUM (tsi_amt), 0), 2) tsi_amt,
                            ROUND (NVL (SUM (a.prem_amt), 0), 2) prem_amt
                       FROM giuw_wpolicyds a
                      WHERE a.dist_no = p_dist_no
                   GROUP BY a.dist_no, a.dist_seq_no)
      LOOP
         FOR rec4 IN (SELECT   f.line_cd, f.dist_no, f.dist_seq_no,
                               f.share_cd,
                               NVL (SUM (f.dist_spct / 100), 0) dist_spct,
                               f.dist_grp, f.dist_spct1
                          FROM giuw_wpolicyds_dtl f
                         WHERE dist_no = p_dist_no
                           AND dist_seq_no = rec3.dist_seq_no
                      GROUP BY f.dist_no,
                               f.dist_seq_no,
                               f.share_cd,
                               f.dist_grp,
                               f.line_cd,
                               f.dist_spct1)
         LOOP
            FOR rec5 IN (SELECT   c.item_no,
                                  ROUND (NVL (SUM (tsi_amt), 0), 2) tsi_amt,
                                  ROUND (NVL (SUM (prem_amt), 0), 2)
                                                                    prem_amt,
                                  ROUND
                                       (NVL (SUM (c.ann_tsi_amt), 0),
                                        2
                                       ) ann_tsi_amt
                             FROM giuw_witemds c
                            WHERE c.dist_no = p_dist_no
                              AND c.dist_seq_no = rec3.dist_seq_no
                         GROUP BY c.dist_no, c.dist_seq_no, c.item_no)
            LOOP
               INSERT INTO giuw_witemds_dtl
                           (dist_no, dist_seq_no, item_no,
                            line_cd, share_cd,
                            dist_spct,
                            dist_tsi,
                            dist_prem,
                            ann_dist_spct,
                            ann_dist_tsi,
                            dist_grp, dist_spct1
                           )
                    VALUES (p_dist_no, rec3.dist_seq_no, rec5.item_no,
                            rec4.line_cd, rec4.share_cd,
                            ROUND (rec4.dist_spct * 100, 9),
                            rec5.tsi_amt * rec4.dist_spct,
                            rec5.prem_amt * rec4.dist_spct,
                            rec4.dist_spct * 100,
                            rec5.ann_tsi_amt * rec4.dist_spct,
                            rec4.dist_grp, rec4.dist_spct1
                           );
            END LOOP;

            FOR rec6 IN (SELECT   g.line_cd, g.peril_cd,
                                  ROUND (NVL (SUM (g.tsi_amt), 0), 2) tsi_amt,
                                  ROUND (NVL (SUM (g.prem_amt), 0),
                                         2
                                        ) prem_amt,
                                  ROUND
                                       (NVL (SUM (g.ann_tsi_amt), 0),
                                        2
                                       ) ann_tsi_amt
                             FROM giuw_wperilds g
                            WHERE g.dist_no = p_dist_no
                              AND g.dist_seq_no = rec3.dist_seq_no
                         GROUP BY g.dist_no,
                                  g.dist_seq_no,
                                  g.peril_cd,
                                  g.line_cd)
            LOOP
               INSERT INTO giuw_wperilds_dtl
                           (dist_no, dist_seq_no, line_cd,
                            peril_cd, share_cd,
                            dist_spct,
                            dist_tsi,
                            dist_prem,
                            ann_dist_spct,
                            ann_dist_tsi,
                            dist_grp, dist_spct1
                           )
                    VALUES (p_dist_no, rec3.dist_seq_no, rec6.line_cd,
                            rec6.peril_cd, rec4.share_cd,
                            ROUND (rec4.dist_spct * 100, 9),
                            rec6.tsi_amt * rec4.dist_spct,
                            rec6.prem_amt * rec4.dist_spct,
                            (rec4.dist_spct) * 100,
                            rec6.ann_tsi_amt * rec4.dist_spct,
                            rec4.dist_grp, rec4.dist_spct1
                           );
            END LOOP;

            FOR rec7 IN (SELECT   h.peril_cd,
                                  ROUND (NVL (SUM (h.tsi_amt), 0), 2) tsi_amt,
                                  ROUND (NVL (SUM (h.prem_amt), 0),
                                         2
                                        ) prem_amt,
                                  ROUND
                                       (NVL (SUM (h.ann_tsi_amt), 0),
                                        2
                                       ) ann_tsi_amt,
                                  h.item_no
                             FROM giuw_witemperilds h
                            WHERE h.dist_no = p_dist_no
                              AND h.dist_seq_no = rec3.dist_seq_no
                         GROUP BY h.dist_no,
                                  h.dist_seq_no,
                                  h.peril_cd,
                                  h.item_no)
            LOOP
               INSERT INTO giuw_witemperilds_dtl
                           (dist_no, dist_seq_no, item_no,
                            line_cd, peril_cd, share_cd,
                            dist_spct,
                            dist_tsi,
                            dist_prem,
                            ann_dist_spct,
                            ann_dist_tsi,
                            dist_grp, dist_spct1
                           )
                    VALUES (p_dist_no, rec3.dist_seq_no, rec7.item_no,
                            rec4.line_cd, rec7.peril_cd, rec4.share_cd,
                            ROUND (rec4.dist_spct * 100, 9),
                            rec7.tsi_amt * rec4.dist_spct,
                            rec7.prem_amt * rec4.dist_spct,
                            rec4.dist_spct * 100,
                            rec7.ann_tsi_amt * rec4.dist_spct,
                            rec4.dist_grp, rec4.dist_spct1
                           );
            END LOOP;
         END LOOP;
      END LOOP;
   END;
END cmpare_del_rnsrt_wdist_tables;
/


