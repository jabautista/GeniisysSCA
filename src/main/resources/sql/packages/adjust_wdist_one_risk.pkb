CREATE OR REPLACE PACKAGE BODY CPI.adjust_wdist_one_risk
AS
   PROCEDURE adjust_witemperilds_dtl (p_dist_no giuw_pol_dist.dist_no%TYPE)
   IS
      v_discrep_limit   NUMBER (2, 2) := .05;
   BEGIN
      FOR rec IN
         (SELECT s.peril_type, d.item_no, c.line_cd, c.peril_cd, c.tsi_amt,
                 d.dist_tsi, (c.tsi_amt - d.dist_tsi) tsi_diff,
                 (c.ann_tsi_amt - d.ann_dist_tsi) ann_tsi_diff, c.prem_amt,
                 (c.prem_amt - d.dist_prem) prem_diff, c.dist_seq_no
            FROM (SELECT   r.line_cd, r.dist_no, r.dist_seq_no,
                           ROUND (NVL (SUM (r.tsi_amt), 0), 2) tsi_amt,
                           ROUND (NVL (SUM (r.ann_tsi_amt), 0),
                                  2) ann_tsi_amt,
                           ROUND (NVL (SUM (r.prem_amt), 0), 2) prem_amt,
                           r.item_no, r.peril_cd
                      FROM giuw_witemperilds r
                     WHERE 1 = 1 AND r.dist_no = p_dist_no
                  GROUP BY r.dist_no,
                           r.dist_seq_no,
                           r.item_no,
                           r.peril_cd,
                           r.line_cd) c,
                 (SELECT   b.line_cd, b.dist_no, b.dist_seq_no,
                           ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                           ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                  2
                                 ) ann_dist_tsi,
                           ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem,
                           b.item_no, b.peril_cd
                      FROM giuw_witemperilds_dtl b
                     WHERE 1 = 1 AND b.dist_no = p_dist_no
                  GROUP BY b.dist_no,
                           b.dist_seq_no,
                           b.item_no,
                           b.peril_cd,
                           b.line_cd) d,
                 giis_peril s
           WHERE 1 = 1
             AND c.dist_no = d.dist_no
             AND c.dist_seq_no = d.dist_seq_no
             AND c.item_no = d.item_no
             AND c.peril_cd = d.peril_cd
             AND c.line_cd = s.line_cd
             AND c.peril_cd = s.peril_cd)
      LOOP
         IF rec.tsi_diff <> 0
         THEN
            IF ABS (rec.tsi_diff) <= v_discrep_limit
            THEN
               FOR rec1 IN (SELECT   a.share_cd,
                                     ROUND (NVL (a.dist_tsi, 0), 2) dist_tsi
                                FROM giuw_witemperilds_dtl a, giis_peril c
                               WHERE a.dist_no = p_dist_no
                                 AND a.dist_seq_no = rec.dist_seq_no
                                 AND a.item_no = rec.item_no
                                 AND a.line_cd = rec.line_cd
                                 AND a.peril_cd = rec.peril_cd
                                 AND a.line_cd = c.line_cd
                                 AND a.peril_cd = c.peril_cd
                            ORDER BY a.share_cd)
               LOOP
                  IF ABS (rec.tsi_diff) <= ABS (rec1.dist_tsi)
                  THEN
                     UPDATE giuw_witemperilds_dtl e
                        SET e.dist_tsi = e.dist_tsi + rec.tsi_diff
                      WHERE 1 = 1
                        AND e.share_cd = rec1.share_cd
                        AND e.item_no = rec.item_no
                        AND e.peril_cd = rec.peril_cd
                        AND e.dist_seq_no = rec.dist_seq_no
                        AND e.dist_no = p_dist_no
                        AND e.line_cd = rec.line_cd;

                     EXIT;
                  END IF;
               END LOOP;
            END IF;
         END IF;

         IF rec.prem_diff <> 0
         THEN
            IF ABS (rec.prem_diff) <= v_discrep_limit
            THEN
               FOR rec1 IN (SELECT   a.share_cd,
                                     ROUND (NVL (a.dist_prem, 0),
                                            2) dist_prem
                                FROM giuw_witemperilds_dtl a, giis_peril c
                               WHERE a.dist_no = p_dist_no
                                 AND a.dist_seq_no = rec.dist_seq_no
                                 AND a.item_no = rec.item_no
                                 AND a.line_cd = rec.line_cd
                                 AND a.peril_cd = rec.peril_cd
                                 AND a.line_cd = c.line_cd
                                 AND a.peril_cd = c.peril_cd
                            ORDER BY a.share_cd)
               LOOP
                  IF ABS (rec.prem_diff) <= ABS (rec1.dist_prem)
                  THEN
                     UPDATE giuw_witemperilds_dtl e
                        SET e.dist_prem = e.dist_prem + rec.prem_diff
                      WHERE 1 = 1
                        AND e.share_cd = rec1.share_cd
                        AND e.item_no = rec.item_no
                        AND e.peril_cd = rec.peril_cd
                        AND e.dist_seq_no = rec.dist_seq_no
                        AND e.dist_no = p_dist_no
                        AND e.line_cd = rec.line_cd;

                     EXIT;
                  END IF;
               END LOOP;
            END IF;
         END IF;

         IF rec.ann_tsi_diff <> 0
         THEN
            IF ABS (rec.ann_tsi_diff) <= v_discrep_limit
            THEN
               FOR rec1 IN (SELECT   a.share_cd,
                                     ROUND
                                          (NVL (a.ann_dist_tsi, 0),
                                           2
                                          ) ann_dist_tsi
                                FROM giuw_witemperilds_dtl a, giis_peril c
                               WHERE a.dist_no = p_dist_no
                                 AND a.dist_seq_no = rec.dist_seq_no
                                 AND a.item_no = rec.item_no
                                 AND a.line_cd = rec.line_cd
                                 AND a.peril_cd = rec.peril_cd
                                 AND a.line_cd = c.line_cd
                                 AND a.peril_cd = c.peril_cd
                            ORDER BY a.share_cd)
               LOOP
                  IF ABS (rec.ann_tsi_diff) <= ABS (rec1.ann_dist_tsi)
                  THEN
                     UPDATE giuw_witemperilds_dtl e
                        SET e.ann_dist_tsi = e.ann_dist_tsi + rec.ann_tsi_diff
                      WHERE 1 = 1
                        AND e.share_cd = rec1.share_cd
                        AND e.item_no = rec.item_no
                        AND e.peril_cd = rec.peril_cd
                        AND e.dist_seq_no = rec.dist_seq_no
                        AND e.dist_no = p_dist_no
                        AND e.line_cd = rec.line_cd;

                     EXIT;
                  END IF;
               END LOOP;
            END IF;
         END IF;
      END LOOP;
   END;

   PROCEDURE adjust_wpolicyds_dtl (p_dist_no giuw_pol_dist.dist_no%TYPE)
   IS
   BEGIN
      FOR rec IN (SELECT a.dist_no, a.dist_seq_no, a.line_cd, a.share_cd
                    FROM giuw_wpolicyds_dtl a
                   WHERE a.dist_no = p_dist_no)
      LOOP
         FOR rec1 IN
            (SELECT   ROUND (NVL (SUM (DECODE (c.peril_type,
                                               'A', 0,
                                               b.dist_tsi
                                              )
                                      ),
                                  0
                                 ),
                             2
                            ) dist_tsi,
                      ROUND (NVL (SUM (DECODE (c.peril_type,
                                               'A', 0,
                                               b.ann_dist_tsi
                                              )
                                      ),
                                  0
                                 ),
                             2
                            ) ann_dist_tsi,
                      ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem
                 FROM giuw_witemperilds_dtl b, giis_peril c
                WHERE b.line_cd = c.line_cd
                  AND b.peril_cd = c.peril_cd
                  AND b.dist_no = p_dist_no
                  AND b.share_cd = rec.share_cd
                  AND b.dist_seq_no = rec.dist_seq_no
                  AND b.line_cd = rec.line_cd
             GROUP BY b.dist_no, b.dist_seq_no, b.line_cd, b.share_cd)
         LOOP
            UPDATE giuw_wpolicyds_dtl d
               SET d.dist_tsi = rec1.dist_tsi,
                   d.dist_prem = rec1.dist_prem,
                   d.ann_dist_tsi = rec1.ann_dist_tsi
             WHERE d.dist_no = p_dist_no
               AND d.dist_seq_no = rec.dist_seq_no
               AND d.line_cd = rec.line_cd
               AND d.share_cd = rec.share_cd;
         END LOOP;
      END LOOP;
   END;

   PROCEDURE adjust_witemds_dtl (p_dist_no giuw_pol_dist.dist_no%TYPE)
   IS
   BEGIN
      FOR rec IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.line_cd,
                         a.share_cd
                    FROM giuw_witemds_dtl a
                   WHERE a.dist_no = p_dist_no)
      LOOP
         FOR rec1 IN
            (SELECT   ROUND (NVL (SUM (DECODE (c.peril_type,
                                               'A', 0,
                                               b.dist_tsi
                                              )
                                      ),
                                  0
                                 ),
                             2
                            ) dist_tsi,
                      ROUND (NVL (SUM (DECODE (c.peril_type,
                                               'A', 0,
                                               b.ann_dist_tsi
                                              )
                                      ),
                                  0
                                 ),
                             2
                            ) ann_dist_tsi,
                      ROUND (NVL (SUM (b.dist_prem), 0), 2) dist_prem
                 FROM giuw_witemperilds_dtl b, giis_peril c
                WHERE b.line_cd = c.line_cd
                  AND b.peril_cd = c.peril_cd
                  AND b.dist_no = p_dist_no
                  AND b.item_no = rec.item_no
                  AND b.share_cd = rec.share_cd
                  AND b.dist_seq_no = rec.dist_seq_no
                  AND b.line_cd = rec.line_cd
             GROUP BY b.dist_no,
                      b.dist_seq_no,
                      b.item_no,
                      b.line_cd,
                      b.share_cd)
         LOOP
            UPDATE giuw_witemds_dtl d
               SET d.dist_tsi = rec1.dist_tsi,
                   d.dist_prem = rec1.dist_prem,
                   d.ann_dist_tsi = rec1.ann_dist_tsi
             WHERE d.dist_no = p_dist_no
               AND d.dist_seq_no = rec.dist_seq_no
               AND d.item_no = rec.item_no
               AND d.line_cd = rec.line_cd
               AND d.share_cd = rec.share_cd;
         END LOOP;
      END LOOP;
   END;

   PROCEDURE adjust_wperilds_dtl (p_dist_no giuw_pol_dist.dist_no%TYPE)
   IS
   BEGIN
      FOR rec IN (SELECT a.dist_no, a.dist_seq_no, a.line_cd, a.share_cd,
                         a.peril_cd
                    FROM giuw_wperilds_dtl a
                   WHERE a.dist_no = p_dist_no)
      LOOP
         FOR rec1 IN (SELECT   ROUND (NVL (SUM (b.dist_tsi), 0), 2) dist_tsi,
                               ROUND (NVL (SUM (b.ann_dist_tsi), 0),
                                      2
                                     ) ann_dist_tsi,
                               ROUND (NVL (SUM (b.dist_prem), 0),
                                      2) dist_prem
                          FROM giuw_witemperilds_dtl b
                         WHERE b.dist_no = p_dist_no
                           AND b.dist_seq_no = rec.dist_seq_no
                           AND b.line_cd = rec.line_cd
                           AND b.peril_cd = rec.peril_cd
                           AND b.share_cd = rec.share_cd
                      GROUP BY b.dist_no,
                               b.dist_seq_no,
                               b.line_cd,
                               b.peril_cd,
                               b.share_cd)
         LOOP
            UPDATE giuw_wperilds_dtl c
               SET c.dist_tsi = rec1.dist_tsi,
                   c.dist_prem = rec1.dist_prem,
                   c.ann_dist_tsi = rec1.ann_dist_tsi
             WHERE c.dist_no = p_dist_no
               AND c.dist_seq_no = rec.dist_seq_no
               AND c.line_cd = rec.line_cd
               AND c.peril_cd = rec.peril_cd
               AND c.share_cd = rec.share_cd;
         END LOOP;
      END LOOP;
   END;

   PROCEDURE adjust_tot_spct_to_100 (p_dist_no giuw_pol_dist.dist_no%TYPE)
   IS
      v_discrep_spct   NUMBER (20, 15);
   BEGIN
      FOR rec1 IN (SELECT   d.dist_no, d.dist_seq_no,
                            ROUND (SUM (d.dist_spct), 9) dist_spct,
                            ROUND (SUM (d.ann_dist_spct), 9) ann_dist_spct,
                            ROUND (SUM (d.dist_spct1), 9) dist_spct1
                       FROM giuw_wpolicyds_dtl d
                      WHERE d.dist_no = p_dist_no
                   GROUP BY d.dist_no, d.dist_seq_no)
      LOOP
         IF    rec1.dist_spct <> 100
            OR rec1.dist_spct1 <> 100
            OR rec1.ann_dist_spct <> 100
         THEN
            IF rec1.dist_spct <> 100
            THEN
               v_discrep_spct := 100 - rec1.dist_spct;

               FOR rec IN (SELECT   d.dist_no, d.dist_seq_no, d.share_cd,
                                    d.dist_spct
                               FROM giuw_wpolicyds_dtl d
                              WHERE d.dist_no = p_dist_no
                                AND d.dist_seq_no = rec1.dist_seq_no
                                AND d.dist_spct > ABS (v_discrep_spct)
                           ORDER BY share_cd)
               LOOP
                  UPDATE giuw_wpolicyds_dtl a
                     SET a.dist_spct = dist_spct + v_discrep_spct
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = rec1.dist_seq_no
                     AND a.share_cd = rec.share_cd;

                  EXIT;
               END LOOP;
            END IF;

            IF rec1.dist_spct1 <> 100
            THEN
               v_discrep_spct := 100 - rec1.dist_spct1;

               FOR rec IN (SELECT   d.dist_no, d.dist_seq_no, d.share_cd,
                                    d.dist_spct1
                               FROM giuw_wpolicyds_dtl d
                              WHERE d.dist_no = p_dist_no
                                AND d.dist_seq_no = rec1.dist_seq_no
                                AND d.dist_spct1 > ABS (v_discrep_spct)
                           ORDER BY share_cd)
               LOOP
                  UPDATE giuw_wpolicyds_dtl a
                     SET a.dist_spct1 = dist_spct1 + v_discrep_spct
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = rec1.dist_seq_no
                     AND a.share_cd = rec.share_cd;

                  EXIT;
               END LOOP;
            END IF;

            IF rec1.ann_dist_spct <> 100
            THEN
               v_discrep_spct := 100 - rec1.ann_dist_spct;

               FOR rec IN (SELECT   d.dist_no, d.dist_seq_no, d.share_cd,
                                    d.ann_dist_spct
                               FROM giuw_wpolicyds_dtl d
                              WHERE d.dist_no = p_dist_no
                                AND d.dist_seq_no = rec1.dist_seq_no
                                AND d.ann_dist_spct > ABS (v_discrep_spct)
                           ORDER BY share_cd)
               LOOP
                  UPDATE giuw_wpolicyds_dtl a
                     SET a.ann_dist_spct = ann_dist_spct + v_discrep_spct
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = rec1.dist_seq_no
                     AND a.share_cd = rec.share_cd;

                  EXIT;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      FOR rec1 IN (SELECT   d.dist_no, d.dist_seq_no, d.item_no,
                            ROUND (SUM (d.dist_spct), 9) dist_spct,
                            ROUND (SUM (d.ann_dist_spct), 9) ann_dist_spct,
                            ROUND (SUM (d.dist_spct1), 9) dist_spct1
                       FROM giuw_witemds_dtl d
                      WHERE d.dist_no = p_dist_no
                   GROUP BY d.dist_no, d.dist_seq_no, d.item_no)
      LOOP
         IF    rec1.dist_spct <> 100
            OR rec1.dist_spct1 <> 100
            OR rec1.ann_dist_spct <> 100
         THEN
            IF rec1.dist_spct <> 100
            THEN
               v_discrep_spct := 100 - rec1.dist_spct;

               FOR rec IN (SELECT   d.dist_no, d.dist_seq_no, d.item_no,
                                    d.share_cd, d.dist_spct
                               FROM giuw_witemds_dtl d
                              WHERE d.dist_no = p_dist_no
                                AND d.dist_seq_no = rec1.dist_seq_no
                                AND d.item_no = rec1.item_no
                                AND d.dist_spct > ABS (v_discrep_spct)
                           ORDER BY share_cd)
               LOOP
                  UPDATE giuw_witemds_dtl a
                     SET a.dist_spct = dist_spct + v_discrep_spct
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = rec1.dist_seq_no
                     AND a.item_no = rec1.item_no
                     AND a.share_cd = rec.share_cd;

                  EXIT;
               END LOOP;
            END IF;

            IF rec1.dist_spct1 <> 100
            THEN
               v_discrep_spct := 100 - rec1.dist_spct1;

               FOR rec IN (SELECT   d.dist_no, d.dist_seq_no, d.item_no,
                                    d.share_cd, d.dist_spct1
                               FROM giuw_witemds_dtl d
                              WHERE d.dist_no = p_dist_no
                                AND d.dist_seq_no = rec1.dist_seq_no
                                AND d.item_no = rec1.item_no
                                AND d.dist_spct1 > ABS (v_discrep_spct)
                           ORDER BY share_cd)
               LOOP
                  UPDATE giuw_witemds_dtl a
                     SET a.dist_spct1 = dist_spct1 + v_discrep_spct
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = rec1.dist_seq_no
                     AND a.item_no = rec1.item_no
                     AND a.share_cd = rec.share_cd;

                  EXIT;
               END LOOP;
            END IF;

            IF rec1.ann_dist_spct <> 100
            THEN
               v_discrep_spct := 100 - rec1.ann_dist_spct;

               FOR rec IN (SELECT   d.dist_no, d.dist_seq_no, d.item_no,
                                    d.share_cd, d.ann_dist_spct
                               FROM giuw_witemds_dtl d
                              WHERE d.dist_no = p_dist_no
                                AND d.dist_seq_no = rec1.dist_seq_no
                                AND d.item_no = rec1.item_no
                                AND d.ann_dist_spct > ABS (v_discrep_spct)
                           ORDER BY share_cd)
               LOOP
                  UPDATE giuw_witemds_dtl a
                     SET a.ann_dist_spct = ann_dist_spct + v_discrep_spct
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = rec1.dist_seq_no
                     AND a.item_no = rec1.item_no
                     AND a.share_cd = rec.share_cd;

                  EXIT;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      FOR rec1 IN (SELECT   d.dist_no, d.dist_seq_no, d.peril_cd,
                            ROUND (SUM (d.dist_spct), 9) dist_spct,
                            ROUND (SUM (d.ann_dist_spct), 9) ann_dist_spct,
                            ROUND (SUM (d.dist_spct1), 9) dist_spct1
                       FROM giuw_wperilds_dtl d
                      WHERE d.dist_no = p_dist_no
                   GROUP BY d.dist_no, d.dist_seq_no, d.peril_cd)
      LOOP
         IF    rec1.dist_spct <> 100
            OR rec1.dist_spct1 <> 100
            OR rec1.ann_dist_spct <> 100
         THEN
            IF rec1.dist_spct <> 100
            THEN
               v_discrep_spct := 100 - rec1.dist_spct;

               FOR rec IN (SELECT   d.dist_no, d.dist_seq_no, d.peril_cd,
                                    d.share_cd, d.dist_spct
                               FROM giuw_wperilds_dtl d
                              WHERE d.dist_no = p_dist_no
                                AND d.dist_seq_no = rec1.dist_seq_no
                                AND d.peril_cd = rec1.peril_cd
                                AND d.dist_spct > ABS (v_discrep_spct)
                           ORDER BY share_cd)
               LOOP
                  UPDATE giuw_wperilds_dtl a
                     SET a.dist_spct = dist_spct + v_discrep_spct
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = rec1.dist_seq_no
                     AND a.peril_cd = rec1.peril_cd
                     AND a.share_cd = rec.share_cd;

                  EXIT;
               END LOOP;
            END IF;

            IF rec1.dist_spct1 <> 100
            THEN
               v_discrep_spct := 100 - rec1.dist_spct1;

               FOR rec IN (SELECT   d.dist_no, d.dist_seq_no, d.peril_cd,
                                    d.share_cd, d.dist_spct1
                               FROM giuw_wperilds_dtl d
                              WHERE d.dist_no = p_dist_no
                                AND d.dist_seq_no = rec1.dist_seq_no
                                AND d.peril_cd = rec1.peril_cd
                                AND d.dist_spct1 > ABS (v_discrep_spct)
                           ORDER BY share_cd)
               LOOP
                  UPDATE giuw_wperilds_dtl a
                     SET a.dist_spct1 = dist_spct1 + v_discrep_spct
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = rec1.dist_seq_no
                     AND a.peril_cd = rec1.peril_cd
                     AND a.share_cd = rec.share_cd;

                  EXIT;
               END LOOP;
            END IF;

            IF rec1.ann_dist_spct <> 100
            THEN
               v_discrep_spct := 100 - rec1.ann_dist_spct;

               FOR rec IN (SELECT   d.dist_no, d.dist_seq_no, d.peril_cd,
                                    d.share_cd, d.ann_dist_spct
                               FROM giuw_wperilds_dtl d
                              WHERE d.dist_no = p_dist_no
                                AND d.dist_seq_no = rec1.dist_seq_no
                                AND d.peril_cd = rec1.peril_cd
                                AND d.ann_dist_spct > ABS (v_discrep_spct)
                           ORDER BY share_cd)
               LOOP
                  UPDATE giuw_wperilds_dtl a
                     SET a.ann_dist_spct = ann_dist_spct + v_discrep_spct
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = rec1.dist_seq_no
                     AND a.peril_cd = rec1.peril_cd
                     AND a.share_cd = rec.share_cd;

                  EXIT;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      FOR rec1 IN (SELECT   d.dist_no, d.dist_seq_no, d.item_no, d.peril_cd,
                            ROUND (SUM (d.dist_spct), 9) dist_spct,
                            ROUND (SUM (d.ann_dist_spct), 9) ann_dist_spct,
                            ROUND (SUM (d.dist_spct1), 9) dist_spct1
                       FROM giuw_witemperilds_dtl d
                      WHERE d.dist_no = p_dist_no
                   GROUP BY d.dist_no, d.dist_seq_no, d.item_no, d.peril_cd)
      LOOP
         IF    rec1.dist_spct <> 100
            OR rec1.dist_spct1 <> 100
            OR rec1.ann_dist_spct <> 100
         THEN
            IF rec1.dist_spct <> 100
            THEN
               v_discrep_spct := 100 - rec1.dist_spct;

               FOR rec IN (SELECT   d.dist_no, d.dist_seq_no, d.item_no,
                                    d.peril_cd, d.share_cd, d.dist_spct
                               FROM giuw_witemperilds_dtl d
                              WHERE d.dist_no = p_dist_no
                                AND d.dist_seq_no = rec1.dist_seq_no
                                AND d.item_no = rec1.item_no
                                AND d.peril_cd = rec1.peril_cd
                                AND d.dist_spct > ABS (v_discrep_spct)
                           ORDER BY share_cd)
               LOOP
                  UPDATE giuw_witemperilds_dtl a
                     SET a.dist_spct = dist_spct + v_discrep_spct
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = rec1.dist_seq_no
                     AND a.item_no = rec1.item_no
                     AND a.peril_cd = rec1.peril_cd
                     AND a.share_cd = rec.share_cd;

                  EXIT;
               END LOOP;
            END IF;

            IF rec1.dist_spct1 <> 100
            THEN
               v_discrep_spct := 100 - rec1.dist_spct1;

               FOR rec IN (SELECT   d.dist_no, d.dist_seq_no, d.item_no,
                                    d.peril_cd, d.share_cd, d.dist_spct1
                               FROM giuw_witemperilds_dtl d
                              WHERE d.dist_no = p_dist_no
                                AND d.dist_seq_no = rec1.dist_seq_no
                                AND d.item_no = rec1.item_no
                                AND d.peril_cd = rec1.peril_cd
                                AND d.dist_spct1 > ABS (v_discrep_spct)
                           ORDER BY share_cd)
               LOOP
                  UPDATE giuw_witemperilds_dtl a
                     SET a.dist_spct1 = dist_spct1 + v_discrep_spct
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = rec1.dist_seq_no
                     AND a.peril_cd = rec1.peril_cd
                     AND a.item_no = rec1.item_no
                     AND a.share_cd = rec.share_cd;

                  EXIT;
               END LOOP;
            END IF;

            IF rec1.ann_dist_spct <> 100
            THEN
               v_discrep_spct := 100 - rec1.ann_dist_spct;

               FOR rec IN (SELECT   d.dist_no, d.dist_seq_no, d.item_no,
                                    d.peril_cd, d.share_cd,
                                    ROUND
                                         (SUM (d.ann_dist_spct),
                                          9
                                         ) ann_dist_spct
                               FROM giuw_witemperilds_dtl d
                              WHERE d.dist_no = p_dist_no
                                AND d.dist_seq_no = rec1.dist_seq_no
                                AND d.item_no = rec1.item_no
                                AND d.peril_cd = rec1.peril_cd
                                AND d.ann_dist_spct > ABS (v_discrep_spct)
                           GROUP BY d.dist_no, d.dist_seq_no, d.item_no,
                                    d.peril_cd, d.share_cd
                           ORDER BY share_cd)
               LOOP
                  UPDATE giuw_witemperilds_dtl a
                     SET a.ann_dist_spct = ann_dist_spct + v_discrep_spct
                   WHERE a.dist_no = p_dist_no
                     AND a.dist_seq_no = rec1.dist_seq_no
                     AND a.item_no = rec1.item_no
                     AND a.peril_cd = rec1.peril_cd
                     AND a.share_cd = rec.share_cd;

                  EXIT;
               END LOOP;
            END IF;
         END IF;
      END LOOP;
   END adjust_tot_spct_to_100;

   PROCEDURE adjust_share_wdistfrps (p_dist_no giuw_wpolicyds.dist_no%TYPE)
   IS

   BEGIN
      FOR upd_gwd IN (SELECT   poldtl.dist_no, poldtl.dist_seq_no,
                               SUM (NVL (poldtl.dist_tsi, 0)) dist_tsi,
                               SUM (NVL (poldtl.dist_prem, 0)) dist_prem,
                               poldtl.dist_spct, poldtl.dist_spct1
                          FROM giuw_wpolicyds_dtl poldtl
                         WHERE dist_no = p_dist_no AND share_cd = 999
                      GROUP BY dist_no, dist_seq_no, dist_spct, dist_spct1)
      LOOP
         UPDATE giri_wdistfrps gwd
            SET gwd.tot_fac_spct = upd_gwd.dist_spct,
                gwd.tot_fac_spct2 = upd_gwd.dist_spct1,
                gwd.tot_fac_tsi = upd_gwd.dist_tsi,
                gwd.tot_fac_prem = upd_gwd.dist_prem
          WHERE gwd.dist_no = upd_gwd.dist_no
            AND gwd.dist_seq_no = upd_gwd.dist_seq_no;
      END LOOP;
   END adjust_share_wdistfrps; 
   
   PROCEDURE adjust_dist (
   p_dist_no   giuw_pol_dist.dist_no%TYPE
)
AS
   v_tsi_discrep1        giuw_wpolicyds_dtl.dist_tsi%TYPE;
   v_prem_discrep1       giuw_wpolicyds_dtl.dist_prem%TYPE;
   v_ann_tsi_discrep1    giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
   v_share_cd1           giuw_wpolicyds_dtl.share_cd%TYPE;
   v_share_cd2           giuw_wpolicyds_dtl.share_cd%TYPE;
   v_tsi_discrep2        giuw_wpolicyds_dtl.dist_tsi%TYPE;
   v_prem_discrep2       giuw_wpolicyds_dtl.dist_prem%TYPE;
   v_ann_tsi_discrep2    giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
   v_item_no             giuw_itemperilds_dtl.item_no%TYPE;
   v_peril_cd            giuw_itemperilds_dtl.item_no%TYPE;
   v_dist_spct1_exists   VARCHAR2 (1)                           := 'N';
   v_ok                  BOOLEAN := FALSE;

   CURSOR policy1
   IS
      SELECT   dist_no, dist_seq_no, share_cd,
               ROUND (NVL (dist_tsi, 0), 2) dist_tsi,
               ROUND (NVL (dist_prem, 0), 2) dist_prem,
               ROUND (NVL (ann_dist_tsi, 0), 2) ann_dist_tsi
          FROM giuw_wpolicyds_dtl
         WHERE dist_no = p_dist_no
      ORDER BY dist_no, dist_seq_no, share_cd DESC;
    BEGIN
       FOR i IN (SELECT '1'
                   FROM giuw_wpolicyds_dtl
                  WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL)
       LOOP
          v_dist_spct1_exists := 'Y';
          EXIT;
       END LOOP;

       /*adjusting of TSI amounts in giuw_witemperilds_dtl*/
       FOR pol IN policy1
       LOOP
          v_share_cd1 := NULL;
          v_share_cd2 := NULL;
          v_tsi_discrep1 := 0;
          v_item_no := NULL;
          v_peril_cd := NULL;
          v_ok       := FALSE;

          FOR itmperl IN
             (SELECT   dist_no, dist_seq_no,
                       SUM (ROUND (NVL (DECODE (b.peril_type, 'B', dist_tsi, 0),
                                        0),
                                   2
                                  )
                           ) dist_tsi,
                       SUM (ROUND (NVL (dist_prem, 0), 2)) dist_prem,
                       SUM (ROUND (NVL (DECODE (b.peril_type,
                                                'B', ann_dist_tsi,
                                                0
                                               ),
                                        0
                                       ),
                                   2
                                  )
                           ) ann_dist_tsi
                  FROM giuw_witemperilds_dtl a, giis_peril b
                 WHERE dist_no = pol.dist_no
                   AND dist_seq_no = pol.dist_seq_no
                   AND share_cd = pol.share_cd
                   AND a.line_cd = b.line_cd
                   AND a.peril_cd = b.peril_cd
              GROUP BY dist_no, dist_seq_no)
          LOOP
             v_tsi_discrep1 := pol.dist_tsi - itmperl.dist_tsi;

             IF v_tsi_discrep1 <> 0
             THEN
                v_share_cd1 := pol.share_cd;
             END IF;

             EXIT;
          END LOOP;

          IF v_share_cd1 IS NOT NULL
          THEN
             FOR pol2 IN (SELECT   dist_no, dist_seq_no, share_cd,
                                   ROUND (NVL (dist_tsi, 0), 2) dist_tsi,
                                   ROUND (NVL (dist_prem, 0), 2) dist_prem,
                                   ROUND (NVL (ann_dist_tsi, 0), 2) ann_dist_tsi
                              FROM giuw_wpolicyds_dtl
                             WHERE dist_no = p_dist_no
                               AND share_cd < v_share_cd1
                               AND dist_seq_no = pol.dist_seq_no
                          ORDER BY dist_no, dist_seq_no, share_cd DESC)
             LOOP
                v_share_cd2 := NULL;
                v_tsi_discrep2 := 0;

                FOR itmperl2 IN
                   (SELECT   dist_no, dist_seq_no,
                             SUM (ROUND (NVL (DECODE (b.peril_type,
                                                      'B', dist_tsi,
                                                      0
                                                     ),
                                              0
                                             ),
                                         2
                                        )
                                 ) dist_tsi,
                             SUM (ROUND (NVL (dist_prem, 0), 2)) dist_prem,
                             SUM
                                (ROUND (NVL (DECODE (b.peril_type,
                                                     'B', ann_dist_tsi,
                                                     0
                                                    ),
                                             0
                                            ),
                                        2
                                       )
                                ) ann_dist_tsi
                        FROM giuw_witemperilds_dtl a, giis_peril b
                       WHERE dist_no = pol2.dist_no
                         AND dist_seq_no = pol2.dist_seq_no
                         AND share_cd = pol2.share_cd
                         AND a.line_cd = b.line_cd
                         AND a.peril_cd = b.peril_cd
                    GROUP BY dist_no, dist_seq_no)
                LOOP
                   v_tsi_discrep2 := pol2.dist_tsi - itmperl2.dist_tsi;

                   IF (    v_tsi_discrep2 <> 0
                       AND ABS (v_tsi_discrep2) >= ABS (v_tsi_discrep1)
                      )
                   THEN
                      v_share_cd2 := pol2.share_cd;
                      EXIT;
                   END IF;
                END LOOP;

                IF v_share_cd2 IS NOT NULL
                THEN
                   EXIT;
                END IF;
             END LOOP;

             IF v_share_cd2 IS NULL
             THEN
                FOR itmperl3 IN
                   (SELECT   dist_no, dist_seq_no, share_cd,
                             SUM (ROUND (NVL (DECODE (b.peril_type,
                                                      'B', dist_tsi,
                                                      0
                                                     ),
                                              0
                                             ),
                                         2
                                        )
                                 ) dist_tsi,
                             SUM (ROUND (NVL (dist_prem, 0), 2)) dist_prem,
                             SUM
                                (ROUND (NVL (DECODE (b.peril_type,
                                                     'B', ann_dist_tsi,
                                                     0
                                                    ),
                                             0
                                            ),
                                        2
                                       )
                                ) ann_dist_tsi
                        FROM giuw_witemperilds_dtl a, giis_peril b
                       WHERE dist_no = pol.dist_no
                         AND dist_seq_no = pol.dist_seq_no
                         AND a.line_cd = b.line_cd
                         AND a.peril_cd = b.peril_cd
                         AND a.share_cd < v_share_cd1
                    GROUP BY dist_no, dist_seq_no, share_cd
                    ORDER BY dist_no, dist_seq_no, share_cd ASC)
                LOOP
                   v_share_cd2 := NULL;

                   IF ABS (itmperl3.dist_tsi) >= ABS (v_tsi_discrep1)
                   THEN
                      v_share_cd2 := itmperl3.share_cd;
                      EXIT;
                   END IF;
                END LOOP;
             END IF;

             FOR itmperl4 IN (SELECT   a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd
                                  FROM giuw_witemperilds a, giis_peril b
                                 WHERE dist_no = pol.dist_no
                                   AND dist_seq_no = pol.dist_seq_no
                                   AND a.line_cd = b.line_cd
                                   AND a.peril_cd = b.peril_cd
                                   AND b.peril_type = 'B'
                              ORDER BY a.item_no DESC, a.peril_cd DESC)
             LOOP
                 v_ok := FALSE;
                 FOR itmperl5 IN (SELECT   share_cd, ROUND(NVL(dist_tsi,0),2) dist_tsi
                                      FROM giuw_witemperilds_dtl
                                     WHERE dist_no = itmperl4.dist_no
                                       AND dist_seq_no = itmperl4.dist_seq_no
                                       AND item_no = itmperl4.item_no
                                       AND peril_cd = itmperl4.peril_cd
                                       AND share_cd IN (v_share_cd1, v_share_cd2)
                                  ORDER BY item_no DESC, share_cd DESC)
                 LOOP
                    IF ABS(itmperl5.dist_tsi) >= ABS(v_tsi_discrep1) THEN
                        IF itmperl5.share_cd = v_share_cd1 THEN
                            v_ok := TRUE;
                        ELSIF itmperl5.share_cd = v_share_cd2 AND v_ok THEN
                            v_item_no := itmperl4.item_no;
                            v_peril_cd := itmperl4.peril_cd; 
                            EXIT;                           
                        END IF;
                    END IF;               
                 END LOOP;                
                
                 IF v_item_no IS NOT NULL AND v_peril_cd IS NOT NULL THEN
                    EXIT;
                 END IF;
             END LOOP;

             IF v_share_cd1 IS NOT NULL AND v_share_cd2 IS NOT NULL AND v_item_no IS NOT NULL AND v_peril_cd IS NOT NULL THEN
                 UPDATE giuw_witemperilds_dtl
                    SET dist_tsi = dist_tsi + v_tsi_discrep1
                  WHERE dist_no = pol.dist_no
                    AND dist_seq_no = pol.dist_seq_no
                    AND item_no = v_item_no
                    AND peril_cd = v_peril_cd
                    AND share_cd = v_share_cd1;

                 UPDATE giuw_witemperilds_dtl
                    SET dist_tsi = dist_tsi - v_tsi_discrep1
                  WHERE dist_no = pol.dist_no
                    AND dist_seq_no = pol.dist_seq_no
                    AND item_no = v_item_no
                    AND peril_cd = v_peril_cd
                    AND share_cd = v_share_cd2;
             END IF;
          END IF;
       END LOOP;

       IF v_dist_spct1_exists = 'Y'
       THEN
          --adjusting of Premium amounts in giuw_witemperilds_dtl
          FOR pol IN policy1
          LOOP
             v_share_cd1 := NULL;
             v_share_cd2 := NULL;
             v_prem_discrep1 := 0;
             v_item_no := NULL;
             v_peril_cd := NULL;
             v_ok       := FALSE;

             FOR itmperl IN (SELECT   dist_no, dist_seq_no,
                                      SUM (ROUND (NVL (dist_tsi, 0), 2))
                                                                        dist_tsi,
                                      SUM (ROUND (NVL (dist_prem, 0), 2)
                                          ) dist_prem,
                                      SUM
                                         (ROUND (NVL (ann_dist_tsi, 0), 2)
                                         ) ann_dist_tsi
                                 FROM giuw_witemperilds_dtl
                                WHERE dist_no = pol.dist_no
                                  AND dist_seq_no = pol.dist_seq_no
                                  AND share_cd = pol.share_cd
                             GROUP BY dist_no, dist_seq_no)
             LOOP
                v_prem_discrep1 := pol.dist_prem - itmperl.dist_prem;

                IF v_prem_discrep1 <> 0
                THEN
                   v_share_cd1 := pol.share_cd;
                END IF;

                EXIT;
             END LOOP;

             IF v_share_cd1 IS NOT NULL
             THEN
                FOR pol2 IN (SELECT   dist_no, dist_seq_no, share_cd,
                                      ROUND (NVL (dist_tsi, 0), 2) dist_tsi,
                                      ROUND (NVL (dist_prem, 0), 2) dist_prem,
                                      ROUND (NVL (ann_dist_tsi, 0),
                                             2
                                            ) ann_dist_tsi
                                 FROM giuw_wpolicyds_dtl
                                WHERE dist_no = p_dist_no
                                  AND share_cd < v_share_cd1
                                  AND dist_seq_no = pol.dist_seq_no
                             ORDER BY dist_no, dist_seq_no, share_cd DESC)
                LOOP
                   v_share_cd2 := NULL;
                   v_prem_discrep2 := 0;

                   FOR itmperl2 IN
                      (SELECT   dist_no, dist_seq_no,
                                SUM (ROUND (NVL (dist_tsi, 0), 2)) dist_tsi,
                                SUM (ROUND (NVL (dist_prem, 0), 2)) dist_prem,
                                SUM (ROUND (NVL (ann_dist_tsi, 0), 2)
                                    ) ann_dist_tsi
                           FROM giuw_witemperilds_dtl
                          WHERE dist_no = pol2.dist_no
                            AND dist_seq_no = pol2.dist_seq_no
                            AND share_cd = pol2.share_cd
                       GROUP BY dist_no, dist_seq_no)
                   LOOP
                      v_prem_discrep2 := pol2.dist_prem - itmperl2.dist_prem;

                      IF (    v_prem_discrep2 <> 0
                          AND ABS (v_prem_discrep2) >= ABS (v_prem_discrep1)
                         )
                      THEN
                         v_share_cd2 := pol2.share_cd;
                         EXIT;
                      END IF;
                   END LOOP;

                   IF v_share_cd2 IS NOT NULL
                   THEN
                      EXIT;
                   END IF;
                END LOOP;

                IF v_share_cd2 IS NULL
                THEN
                   FOR itmperl3 IN
                      (SELECT   dist_no, dist_seq_no, share_cd,
                                SUM (ROUND (NVL (dist_tsi, 0), 2)) dist_tsi,
                                SUM (ROUND (NVL (dist_prem, 0), 2)) dist_prem,
                                SUM (ROUND (NVL (ann_dist_tsi, 0), 2)
                                    ) ann_dist_tsi
                           FROM giuw_witemperilds_dtl
                          WHERE dist_no = pol.dist_no
                            AND dist_seq_no = pol.dist_seq_no
                            AND share_cd < v_share_cd1
                       GROUP BY dist_no, dist_seq_no, share_cd
                       ORDER BY dist_no, dist_seq_no, share_cd ASC)
                   LOOP
                      v_share_cd2 := NULL;

                      IF ABS (itmperl3.dist_prem) >= ABS (v_prem_discrep1)
                      THEN
                         v_share_cd2 := itmperl3.share_cd;
                         EXIT;
                      END IF;
                   END LOOP;
                END IF;

                FOR itmperl4 IN (SELECT   dist_no, dist_seq_no, item_no, peril_cd
                                     FROM giuw_witemperilds
                                    WHERE dist_no = pol.dist_no
                                      AND dist_seq_no = pol.dist_seq_no
                                 ORDER BY item_no DESC, peril_cd DESC)
                LOOP
                    v_ok := FALSE;
                    FOR itmperl5 IN (SELECT   share_cd, ROUND(NVL(dist_prem,0),2) dist_prem
                                         FROM giuw_witemperilds_dtl
                                        WHERE dist_no = itmperl4.dist_no
                                          AND dist_seq_no = itmperl4.dist_seq_no
                                          AND item_no = itmperl4.item_no
                                          AND peril_cd = itmperl4.peril_cd
                                          AND share_cd IN (v_share_cd1, v_share_cd2)
                                     ORDER BY item_no DESC, share_cd DESC)
                    LOOP
                       IF ABS(itmperl5.dist_prem) >= ABS(v_prem_discrep1) THEN
                           IF itmperl5.share_cd = v_share_cd1 THEN
                               v_ok := TRUE;
                           ELSIF itmperl5.share_cd = v_share_cd2 AND v_ok THEN
                               v_item_no := itmperl4.item_no;
                               v_peril_cd := itmperl4.peril_cd; 
                               EXIT;                           
                           END IF;
                       END IF;               
                    END LOOP;                
                   
                    IF v_item_no IS NOT NULL AND v_peril_cd IS NOT NULL THEN
                       EXIT;
                    END IF;
                END LOOP;

                IF v_share_cd1 IS NOT NULL AND v_share_cd2 IS NOT NULL AND v_item_no IS NOT NULL AND v_peril_cd IS NOT NULL THEN
                   UPDATE giuw_witemperilds_dtl
                      SET dist_prem = dist_prem + v_prem_discrep1
                    WHERE dist_no = pol.dist_no
                      AND dist_seq_no = pol.dist_seq_no
                      AND item_no = v_item_no
                      AND peril_cd = v_peril_cd
                      AND share_cd = v_share_cd1;

                   UPDATE giuw_witemperilds_dtl
                      SET dist_prem = dist_prem - v_prem_discrep1
                    WHERE dist_no = pol.dist_no
                      AND dist_seq_no = pol.dist_seq_no
                      AND item_no = v_item_no
                      AND peril_cd = v_peril_cd
                      AND share_cd = v_share_cd2;
                END IF;
             END IF;
          END LOOP;
       END IF;
    END adjust_dist;
    
    PROCEDURE adjust_dist_one_risk (
       p_dist_no   giuw_pol_dist.dist_no%TYPE
    )
    AS
       v_limit          giuw_wpolicyds_dtl.dist_spct%TYPE   := 0.05;
       v_share_cd       giuw_wpolicyds_dtl.share_cd%TYPE;
       v_with_adjust    VARCHAR2 (1)                        := 'N';
       v_spct_discrep   giuw_wpolicyds_dtl.dist_spct%TYPE;
       v_dist_tsi       giuw_wpolicyds_dtl.dist_tsi%TYPE;
       v_group_tsi      giuw_wpolicyds.tsi_amt%TYPE;
    BEGIN
       FOR policy1 IN (SELECT   dist_no, dist_seq_no,
                                ROUND (NVL (tsi_amt, 0), 2) tsi_amt
                           FROM giuw_wpolicyds
                          WHERE dist_no = p_dist_no
                       ORDER BY dist_no, dist_seq_no)
       LOOP
          v_group_tsi := policy1.tsi_amt;

          FOR pol IN (SELECT   SUM (ROUND (NVL (dist_spct, 0), 9)) dist_spct,
                               SUM(ROUND(NVL(dist_tsi,0),2)) dist_tsi
                          FROM giuw_wpolicyds_dtl
                         WHERE dist_no = policy1.dist_no
                           AND dist_seq_no = policy1.dist_seq_no
                      GROUP BY dist_no, dist_seq_no)
          LOOP
             v_spct_discrep := 100 - pol.dist_spct;
             v_dist_tsi := pol.dist_tsi;
          END LOOP;

          v_with_adjust := 'N';

          IF v_spct_discrep <> 0 AND ABS (v_spct_discrep) <= v_limit AND v_dist_tsi = policy1.tsi_amt
          THEN
             FOR shr IN (SELECT   share_cd,
                                  ROUND (NVL (dist_spct, 0), 9) dist_spct,
                                  ROUND (NVL (dist_tsi, 0), 9) dist_tsi
                             FROM giuw_wpolicyds_dtl
                            WHERE dist_no = policy1.dist_no
                              AND dist_seq_no = policy1.dist_seq_no
                         ORDER BY dist_no, dist_seq_no, share_cd ASC)
             LOOP
                IF shr.dist_tsi =
                        ROUND((v_group_tsi * ((shr.dist_spct + v_spct_discrep) / 100)
                        ),2)
                THEN
                   v_with_adjust := 'Y';
                   v_share_cd := shr.share_cd;
                   EXIT;
                END IF;
             END LOOP;
          END IF;

          IF v_with_adjust = 'Y'
          THEN
             UPDATE giuw_wpolicyds_dtl
                SET dist_spct = dist_spct + v_spct_discrep,
                    ann_dist_spct = ann_dist_spct + v_spct_discrep
              WHERE dist_no = policy1.dist_no
                AND dist_seq_no = policy1.dist_seq_no
                AND share_cd = v_share_cd;

             cmpare_del_rnsrt_wdist_tables.del_rnsrt_wdist_tables (p_dist_no);
             adjust_wdist_one_risk.adjust_witemperilds_dtl (p_dist_no);
             adjust_wdist_one_risk.adjust_dist (p_dist_no);
             adjust_wdist_one_risk.adjust_wpolicyds_dtl (p_dist_no);
             adjust_wdist_one_risk.adjust_witemds_dtl (p_dist_no);
             adjust_wdist_one_risk.adjust_wperilds_dtl (p_dist_no);
          ELSE
             FOR shr IN (SELECT   share_cd,
                                  ROUND (NVL (dist_spct, 0), 9) dist_spct,
                                  ROUND (NVL (dist_tsi, 0), 9) dist_tsi
                             FROM giuw_wpolicyds_dtl
                            WHERE dist_no = policy1.dist_no
                              AND dist_seq_no = policy1.dist_seq_no
                         ORDER BY dist_no, dist_seq_no, share_cd ASC)
             LOOP
                UPDATE giuw_wpolicyds_dtl
                   SET dist_spct = dist_spct + v_spct_discrep,
                       ann_dist_spct = ann_dist_spct + v_spct_discrep
                 WHERE dist_no = policy1.dist_no
                   AND dist_seq_no = policy1.dist_seq_no
                   AND share_cd = shr.share_cd;

                cmpare_del_rnsrt_wdist_tables.del_rnsrt_wdist_tables (p_dist_no);
                adjust_wdist_one_risk.adjust_witemperilds_dtl (p_dist_no);
                adjust_wdist_one_risk.adjust_wpolicyds_dtl (p_dist_no);
                adjust_wdist_one_risk.adjust_witemds_dtl (p_dist_no);
                adjust_wdist_one_risk.adjust_wperilds_dtl (p_dist_no);
                EXIT;
             END LOOP;
          END IF;
       END LOOP;
    END adjust_dist_one_risk;    
END adjust_wdist_one_risk;
/


