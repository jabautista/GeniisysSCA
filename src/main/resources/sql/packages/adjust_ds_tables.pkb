CREATE OR REPLACE PACKAGE BODY CPI.adjust_ds_tables
AS
   PROCEDURE adjust_perilds (p_dist_no giuw_wperilds.dist_no%TYPE)
   IS
      v_limit          NUMBER                           := 0.5;
      v_tsi_amt        giuw_wperilds.tsi_amt%TYPE;
      v_prem_amt       giuw_wperilds.prem_amt%TYPE;
      v_ann_tsi_amt    giuw_wperilds.ann_tsi_amt%TYPE;
      v_tsi_discrep    NUMBER                           := 0;
      v_prem_discrep   NUMBER                           := 0;
      v_ann_discrep    NUMBER                           := 0;
   BEGIN
      FOR i IN (SELECT   a.dist_no, a.dist_seq_no, a.peril_cd,
                         a.tsi_amt iperl_tsi, a.prem_amt iperl_prem,
                         a.ann_tsi_amt iperl_ann, b.tsi_amt perl_tsi,
                         b.prem_amt perl_prem, b.ann_tsi_amt perl_ann
                    FROM (SELECT   dist_no, dist_seq_no, peril_cd,
                                   SUM (ROUND (NVL (tsi_amt, 0), 2)) tsi_amt,
                                   SUM (ROUND (NVL (prem_amt, 0), 2))
                                                                     prem_amt,
                                   SUM (ROUND (NVL (ann_tsi_amt, 0), 2)
                                       ) ann_tsi_amt
                              FROM giuw_witemperilds
                             WHERE dist_no = p_dist_no
                          GROUP BY dist_no, dist_seq_no, peril_cd) a,
                         (SELECT dist_no, dist_seq_no, peril_cd,
                                 ROUND (NVL (tsi_amt, 0), 2) tsi_amt,
                                 ROUND (NVL (prem_amt, 0), 2) prem_amt,
                                 ROUND (NVL (ann_tsi_amt, 0), 2) ann_tsi_amt
                            FROM giuw_wperilds
                           WHERE dist_no = p_dist_no) b
                   WHERE a.dist_no = b.dist_no
                     AND a.dist_seq_no = b.dist_seq_no
                     AND a.peril_cd = b.peril_cd
                     AND (   (    a.tsi_amt - b.tsi_amt <> 0
                              AND ABS (a.tsi_amt - b.tsi_amt) <= v_limit
                             )
                          OR (    a.prem_amt - b.prem_amt <> 0
                              AND ABS (a.prem_amt - b.prem_amt) <= v_limit
                             )
                          OR (    a.ann_tsi_amt - b.ann_tsi_amt <> 0
                              AND ABS (a.ann_tsi_amt - b.ann_tsi_amt) <= v_limit
                             )
                         )
                ORDER BY a.dist_no, a.dist_seq_no, a.peril_cd)
      LOOP
         UPDATE giuw_wperilds
            SET tsi_amt = i.iperl_tsi,
                prem_amt = i.iperl_prem,
                ann_tsi_amt = i.iperl_ann
          WHERE dist_no = i.dist_no
            AND dist_seq_no = i.dist_seq_no
            AND peril_cd = i.peril_cd;
      END LOOP;
   END;

   PROCEDURE adjust_itemds (p_dist_no giuw_witemds.dist_no%TYPE)
   IS
      v_limit          NUMBER                           := 0.5;   
   BEGIN
      FOR i IN
         (SELECT   a.dist_no, a.dist_seq_no, a.item_no, a.tsi_amt iperl_tsi,
                   a.prem_amt iperl_prem, a.ann_tsi_amt iperl_ann,
                   b.tsi_amt item_tsi, b.prem_amt item_prem,
                   b.ann_tsi_amt item_ann
              FROM (SELECT   dist_no, dist_seq_no, item_no,
                             SUM (ROUND (DECODE (d.peril_type,
                                                 'B', NVL (tsi_amt, 0),
                                                 0
                                                ),
                                         2
                                        )
                                 ) tsi_amt,
                             SUM (ROUND (NVL (prem_amt, 0), 2)) prem_amt,
                             SUM
                                (ROUND (DECODE (d.peril_type,
                                                'B', NVL (ann_tsi_amt, 0),
                                                0
                                               ),
                                        2
                                       )
                                ) ann_tsi_amt
                        FROM giuw_witemperilds c, giis_peril d
                       WHERE c.dist_no = p_dist_no
                         AND c.peril_cd = d.peril_cd
                         AND c.line_cd = d.line_cd
                    GROUP BY dist_no, dist_seq_no, item_no) a,
                   (SELECT dist_no, dist_seq_no, item_no,
                           ROUND (NVL (tsi_amt, 0), 2) tsi_amt,
                           ROUND (NVL (prem_amt, 0), 2) prem_amt,
                           ROUND (NVL (ann_tsi_amt, 0), 2) ann_tsi_amt
                      FROM giuw_witemds
                     WHERE dist_no = p_dist_no) b
             WHERE a.dist_no = b.dist_no
               AND a.dist_seq_no = b.dist_seq_no
               AND a.item_no = b.item_no
               AND (   (    a.tsi_amt - b.tsi_amt <> 0
                        AND ABS (a.tsi_amt - b.tsi_amt) <= v_limit 
                       )
                    OR (    a.prem_amt - b.prem_amt <> 0
                        AND ABS (a.prem_amt - b.prem_amt) <= v_limit 
                       )
                    OR (    a.ann_tsi_amt - b.ann_tsi_amt <> 0
                        AND ABS (a.ann_tsi_amt - b.ann_tsi_amt) <= v_limit 
                       )
                   )
          ORDER BY a.dist_no, a.dist_seq_no, a.item_no)
      LOOP
         UPDATE giuw_witemds
            SET tsi_amt = i.iperl_tsi,
                prem_amt = i.iperl_prem,
                ann_tsi_amt = i.iperl_ann
          WHERE dist_no = i.dist_no
            AND dist_seq_no = i.dist_seq_no
            AND item_no = i.item_no;
      END LOOP;
   END;

   PROCEDURE adjust_policyds (p_dist_no giuw_wpolicyds.dist_no%TYPE)
   IS
      v_limit          NUMBER                           := 0.5;   
   BEGIN
      FOR i IN
         (SELECT   a.dist_no, a.dist_seq_no, a.tsi_amt iperl_tsi,
                   a.prem_amt iperl_prem, a.ann_tsi_amt iperl_ann,
                   b.tsi_amt pol_tsi, b.prem_amt pol_prem,
                   b.ann_tsi_amt pol_ann
              FROM (SELECT   dist_no, dist_seq_no,
                             SUM (ROUND (DECODE (d.peril_type,
                                                 'B', NVL (tsi_amt, 0),
                                                 0
                                                ),
                                         2
                                        )
                                 ) tsi_amt,
                             SUM (ROUND (NVL (prem_amt, 0), 2)) prem_amt,
                             SUM
                                (ROUND (DECODE (d.peril_type,
                                                'B', NVL (ann_tsi_amt, 0),
                                                0
                                               ),
                                        2
                                       )
                                ) ann_tsi_amt
                        FROM giuw_witemperilds c, giis_peril d
                       WHERE c.dist_no = p_dist_no
                         AND c.peril_cd = d.peril_cd
                         AND c.line_cd = d.line_cd
                    GROUP BY dist_no, dist_seq_no) a,
                   (SELECT dist_no, dist_seq_no,
                           ROUND (NVL (tsi_amt, 0), 2) tsi_amt,
                           ROUND (NVL (prem_amt, 0), 2) prem_amt,
                           ROUND (NVL (ann_tsi_amt, 0), 2) ann_tsi_amt
                      FROM giuw_wpolicyds
                     WHERE dist_no = p_dist_no) b
             WHERE a.dist_no = b.dist_no
               AND a.dist_seq_no = b.dist_seq_no
               AND (   (    a.tsi_amt - b.tsi_amt <> 0
                        AND ABS (a.tsi_amt - b.tsi_amt) <= v_limit 
                       )
                    OR (    a.prem_amt - b.prem_amt <> 0
                        AND ABS (a.prem_amt - b.prem_amt) <= v_limit 
                       )
                    OR (    a.ann_tsi_amt - b.ann_tsi_amt <> 0
                        AND ABS (a.ann_tsi_amt - b.ann_tsi_amt) <= v_limit 
                       )
                   )
          ORDER BY a.dist_no, a.dist_seq_no)
      LOOP
         UPDATE giuw_wpolicyds
            SET tsi_amt = i.iperl_tsi,
                prem_amt = i.iperl_prem,
                ann_tsi_amt = i.iperl_ann
          WHERE dist_no = i.dist_no AND dist_seq_no = i.dist_seq_no;
      END LOOP;
   END;

   PROCEDURE adjust_dist_tables (p_dist_no giuw_wpolicyds.dist_no%TYPE)
   IS
   BEGIN
      adjust_ds_tables.adjust_perilds (p_dist_no);
      adjust_ds_tables.adjust_itemds (p_dist_no);
      adjust_ds_tables.adjust_policyds (p_dist_no);
   END adjust_dist_tables;

   FUNCTION validate_dist_tables (p_dist_no giuw_wpolicyds.dist_no%TYPE)
      RETURN BOOLEAN
   IS
      v_unbalance   BOOLEAN := FALSE;
   BEGIN
      FOR i IN (SELECT   a.dist_no, a.dist_seq_no, a.peril_cd,
                         a.tsi_amt iperl_tsi, a.prem_amt iperl_prem,
                         a.ann_tsi_amt iperl_ann, b.tsi_amt perl_tsi,
                         b.prem_amt perl_prem, b.ann_tsi_amt perl_ann
                    FROM (SELECT   dist_no, dist_seq_no, peril_cd,
                                   SUM (ROUND (NVL (tsi_amt, 0), 2)) tsi_amt,
                                   SUM (ROUND (NVL (prem_amt, 0), 2))
                                                                     prem_amt,
                                   SUM (ROUND (NVL (ann_tsi_amt, 0), 2)
                                       ) ann_tsi_amt
                              FROM giuw_witemperilds
                             WHERE dist_no = p_dist_no
                          GROUP BY dist_no, dist_seq_no, peril_cd) a,
                         (SELECT dist_no, dist_seq_no, peril_cd,
                                 ROUND (NVL (tsi_amt, 0), 2) tsi_amt,
                                 ROUND (NVL (prem_amt, 0), 2) prem_amt,
                                 ROUND (NVL (ann_tsi_amt, 0), 2) ann_tsi_amt
                            FROM giuw_wperilds
                           WHERE dist_no = p_dist_no) b
                   WHERE a.dist_no = b.dist_no
                     AND a.dist_seq_no = b.dist_seq_no
                     AND a.peril_cd = b.peril_cd
                     AND (   (a.tsi_amt - b.tsi_amt <> 0)
                          OR (a.prem_amt - b.prem_amt <> 0)
                          OR (a.ann_tsi_amt - b.ann_tsi_amt <> 0)
                         )
                ORDER BY a.dist_no, a.dist_seq_no, a.peril_cd)
      LOOP
         v_unbalance := TRUE;
         EXIT;
      END LOOP;

      FOR i IN
         (SELECT   a.dist_no, a.dist_seq_no, a.item_no, a.tsi_amt iperl_tsi,
                   a.prem_amt iperl_prem, a.ann_tsi_amt iperl_ann,
                   b.tsi_amt item_tsi, b.prem_amt item_prem,
                   b.ann_tsi_amt item_ann
              FROM (SELECT   dist_no, dist_seq_no, item_no,
                             SUM (ROUND (DECODE (d.peril_type,
                                                 'B', NVL (tsi_amt, 0),
                                                 0
                                                ),
                                         2
                                        )
                                 ) tsi_amt,
                             SUM (ROUND (NVL (prem_amt, 0), 2)) prem_amt,
                             SUM
                                (ROUND (DECODE (d.peril_type,
                                                'B', NVL (ann_tsi_amt, 0),
                                                0
                                               ),
                                        2
                                       )
                                ) ann_tsi_amt
                        FROM giuw_witemperilds c, giis_peril d
                       WHERE c.dist_no = p_dist_no
                         AND c.peril_cd = d.peril_cd
                         AND c.line_cd = d.line_cd
                    GROUP BY dist_no, dist_seq_no, item_no) a,
                   (SELECT dist_no, dist_seq_no, item_no,
                           ROUND (NVL (tsi_amt, 0), 2) tsi_amt,
                           ROUND (NVL (prem_amt, 0), 2) prem_amt,
                           ROUND (NVL (ann_tsi_amt, 0), 2) ann_tsi_amt
                      FROM giuw_witemds
                     WHERE dist_no = p_dist_no) b
             WHERE a.dist_no = b.dist_no
               AND a.dist_seq_no = b.dist_seq_no
               AND a.item_no = b.item_no
               AND (   (a.tsi_amt - b.tsi_amt <> 0)
                    OR (a.prem_amt - b.prem_amt <> 0)
                    OR (a.ann_tsi_amt - b.ann_tsi_amt <> 0)
                   )
          ORDER BY a.dist_no, a.dist_seq_no, a.item_no)
      LOOP
         v_unbalance := TRUE;
         EXIT;
      END LOOP;

      FOR i IN
         (SELECT   a.dist_no, a.dist_seq_no, a.tsi_amt iperl_tsi,
                   a.prem_amt iperl_prem, a.ann_tsi_amt iperl_ann,
                   b.tsi_amt pol_tsi, b.prem_amt pol_prem,
                   b.ann_tsi_amt pol_ann
              FROM (SELECT   dist_no, dist_seq_no,
                             SUM (ROUND (DECODE (d.peril_type,
                                                 'B', NVL (tsi_amt, 0),
                                                 0
                                                ),
                                         2
                                        )
                                 ) tsi_amt,
                             SUM (ROUND (NVL (prem_amt, 0), 2)) prem_amt,
                             SUM
                                (ROUND (DECODE (d.peril_type,
                                                'B', NVL (ann_tsi_amt, 0),
                                                0
                                               ),
                                        2
                                       )
                                ) ann_tsi_amt
                        FROM giuw_witemperilds c, giis_peril d
                       WHERE c.dist_no = p_dist_no
                         AND c.peril_cd = d.peril_cd
                         AND c.line_cd = d.line_cd
                    GROUP BY dist_no, dist_seq_no) a,
                   (SELECT dist_no, dist_seq_no,
                           ROUND (NVL (tsi_amt, 0), 2) tsi_amt,
                           ROUND (NVL (prem_amt, 0), 2) prem_amt,
                           ROUND (NVL (ann_tsi_amt, 0), 2) ann_tsi_amt
                      FROM giuw_wpolicyds
                     WHERE dist_no = p_dist_no) b
             WHERE a.dist_no = b.dist_no
               AND a.dist_seq_no = b.dist_seq_no
               AND (   (a.tsi_amt - b.tsi_amt <> 0)
                    OR (a.prem_amt - b.prem_amt <> 0)
                    OR (a.ann_tsi_amt - b.ann_tsi_amt <> 0)
                   )
          ORDER BY a.dist_no, a.dist_seq_no)
      LOOP
         v_unbalance := TRUE;
         EXIT;
      END LOOP;

      RETURN v_unbalance;
   END;
END adjust_ds_tables;
/


