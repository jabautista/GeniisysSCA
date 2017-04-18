CREATE OR REPLACE PACKAGE BODY CPI.adjust_distribution_peril_pkg
AS
/*Modified: apignas_jr.
**Date Modified: 06.09.14
**Modification(s): added procedure adjust_share_wdistfrps*/
   PROCEDURE adjust_peril_dtl (p_dist_no giuw_wperilds.dist_no%TYPE)
   IS
      v_exist                   VARCHAR2 (1)                           := 'N';
      v_tsi_amt                 giuw_wperilds.tsi_amt%TYPE;
      v_prem_amt                giuw_wperilds.prem_amt%TYPE;
      v_ann_tsi_amt             giuw_wperilds.ann_tsi_amt%TYPE;
      v_dist_tsi                giuw_wperilds_dtl.dist_tsi%TYPE;
      v_dist_spct               giuw_wperilds_dtl.dist_spct%TYPE;
      --v_dist_spct                     VARCHAR2(50);
      v_dist_prem               giuw_wperilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi            giuw_wperilds_dtl.ann_dist_tsi%TYPE;
      v_sum_dist_tsi            giuw_wperilds_dtl.dist_tsi%TYPE;
      v_sum_dist_spct           giuw_wperilds_dtl.dist_spct%TYPE;
      v_sum_dist_prem           giuw_wperilds_dtl.dist_prem%TYPE;
      v_correct_dist_tsi        giuw_wperilds_dtl.dist_tsi%TYPE;
      v_sum_ann_dist_tsi        giuw_wperilds_dtl.ann_dist_tsi%TYPE;
      v_sum_ann_dist_spct       giuw_wperilds_dtl.ann_dist_spct%TYPE;
      v_correct_dist_spct       giuw_wperilds_dtl.dist_spct%TYPE;
      v_correct_dist_prem       giuw_wperilds_dtl.dist_prem%TYPE;
      v_correct_ann_dist_tsi    giuw_wperilds_dtl.ann_dist_tsi%TYPE;
      v_correct_ann_dist_spct   giuw_wperilds_dtl.ann_dist_spct%TYPE;
   BEGIN
      /*Based on the package in GIUWS003 for comparing giuw_wperilds and giuw_perilds_dtl*/
      FOR perl IN (SELECT dist_no, dist_seq_no, line_cd, peril_cd,
                          ROUND (NVL (a.tsi_amt, 0), 2) tsi_amt,
                          ROUND (NVL (a.prem_amt, 0), 2) prem_amt,
                          ROUND (NVL (a.ann_tsi_amt, 0), 2) ann_tsi_amt
                     FROM giuw_wperilds a
                    WHERE a.dist_no = p_dist_no)
      LOOP
         v_tsi_amt := perl.tsi_amt;
         v_prem_amt := perl.prem_amt;
         v_ann_tsi_amt := perl.ann_tsi_amt;

         BEGIN
            FOR i IN (SELECT   share_cd,
                               ROUND (SUM (NVL (a.dist_tsi, 0)), 2) dist_tsi,
                               ROUND (SUM (NVL (a.dist_prem, 0)),
                                      2) dist_prem,
                               ROUND (SUM (NVL (a.dist_spct, 0)),
                                      9) dist_spct,
                               ROUND (SUM (NVL (a.ann_dist_tsi, 0)),
                                      2
                                     ) ann_dist_tsi
                          FROM giuw_witemperilds_dtl a
                         WHERE a.dist_no = perl.dist_no
                           AND a.dist_seq_no = perl.dist_seq_no
                           AND a.line_cd = perl.line_cd
                           AND a.peril_cd = perl.peril_cd
                      GROUP BY share_cd)
            LOOP
               UPDATE giuw_wperilds_dtl
                  SET dist_tsi = i.dist_tsi,
                      dist_prem = i.dist_prem,
                      ann_dist_tsi = i.ann_dist_tsi
                WHERE share_cd = i.share_cd
                  AND peril_cd = perl.peril_cd
                  AND line_cd = perl.line_cd
                  AND dist_seq_no = perl.dist_seq_no
                  AND dist_no = perl.dist_no;
            END LOOP;
         END;
      END LOOP;
   END adjust_peril_dtl;

   PROCEDURE adjust_itemperil_dtl (p_dist_no giuw_witemperilds.dist_no%TYPE)
   IS
      v_exist                   VARCHAR2 (1)                           := 'N';
      v_net_exist               VARCHAR2 (1)                           := 'N';
      v_tsi_amt                 giuw_witemperilds.tsi_amt%TYPE;
      v_prem_amt                giuw_witemperilds.prem_amt%TYPE;
      v_ann_tsi_amt             giuw_witemperilds.ann_tsi_amt%TYPE;
      v_dist_tsi                giuw_witemperilds_dtl.dist_tsi%TYPE;
      v_dist_spct               giuw_witemperilds_dtl.dist_spct%TYPE;
      v_dist_prem               giuw_witemperilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi            giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
      v_sum_dist_tsi            giuw_witemperilds_dtl.dist_tsi%TYPE;
      v_sum_dist_spct           giuw_witemperilds_dtl.dist_spct%TYPE;
      v_sum_dist_prem           giuw_witemperilds_dtl.dist_prem%TYPE;
      v_correct_dist_tsi        giuw_witemperilds_dtl.dist_tsi%TYPE;
      v_sum_ann_dist_tsi        giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
      v_sum_ann_dist_spct       giuw_witemperilds_dtl.ann_dist_spct%TYPE;
      v_correct_dist_spct       giuw_witemperilds_dtl.dist_spct%TYPE;
      v_correct_dist_prem       giuw_witemperilds_dtl.dist_prem%TYPE;
      v_correct_ann_dist_tsi    giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
      v_correct_ann_dist_spct   giuw_witemperilds_dtl.ann_dist_spct%TYPE;
      v_perl_dist_tsi           giuw_wperilds_dtl.dist_tsi%TYPE;
      v_perl_dist_prem          giuw_wperilds_dtl.dist_prem%TYPE;
      v_perl_dist_spct          giuw_wperilds_dtl.dist_spct%TYPE;
      v_perl_ann_dist_tsi       giuw_wperilds_dtl.ann_dist_tsi%TYPE;
      v_itmperl_dist_tsi        giuw_witemperilds_dtl.dist_tsi%TYPE;
      v_itmperl_dist_prem       giuw_witemperilds_dtl.dist_prem%TYPE;
      v_itmperl_dist_spct       giuw_witemperilds_dtl.dist_spct%TYPE;
      v_itmperl_ann_dist_tsi    giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
      v_peril_type              giis_peril.peril_type%TYPE;
      v_diff_tsi                giuw_wperilds_dtl.dist_tsi%TYPE;
      v_diff_prem               giuw_wperilds_dtl.dist_prem%TYPE;
      v_diff_ann_tsi            giuw_wperilds_dtl.ann_dist_tsi%TYPE;
      v_item                    giuw_witemperilds_dtl.item_no%TYPE;
      v_tsi_discrep             giuw_wperilds_dtl.dist_tsi%TYPE;
      v_prem_discrep            giuw_wperilds_dtl.dist_prem%TYPE;
      v_ann_tsi_discrep         giuw_wperilds_dtl.ann_dist_tsi%TYPE;
      v_discrep_limit           giuw_wperilds_dtl.dist_tsi%TYPE       := 0.05;
   BEGIN
      --2. compare giuw_witemperilds_dtl and giuw_witemperilds
      FOR itmperl IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.line_cd,
                             a.peril_cd,
                             ROUND (NVL (a.tsi_amt, 0), 2) tsi_amt,
                             ROUND (NVL (a.prem_amt, 0), 2) prem_amt,
                             ROUND (NVL (a.ann_tsi_amt, 0), 2) ann_tsi_amt
                        FROM giuw_witemperilds a
                       WHERE dist_no = p_dist_no)
      LOOP
         BEGIN
            v_tsi_amt := itmperl.tsi_amt;
            v_prem_amt := itmperl.prem_amt;
            v_ann_tsi_amt := itmperl.ann_tsi_amt;

            FOR itmperl_dtl IN
               (SELECT ROUND (SUM (NVL (dist_tsi, 0)), 2) dist_tsi,
                       ROUND (SUM (NVL (dist_prem, 0)), 2) dist_prem,
                       ROUND (SUM (NVL (dist_spct, 0)), 9) dist_spct,
                       ROUND (SUM (NVL (ann_dist_tsi, 0)), 2) ann_dist_tsi
                  FROM giuw_witemperilds_dtl
                 WHERE peril_cd = itmperl.peril_cd
                   AND line_cd = itmperl.line_cd
                   AND item_no = itmperl.item_no
                   AND dist_seq_no = itmperl.dist_seq_no
                   AND dist_no = itmperl.dist_no)
            LOOP
               v_dist_tsi := itmperl_dtl.dist_tsi;
               v_dist_prem := itmperl_dtl.dist_prem;
               v_dist_spct := itmperl_dtl.dist_spct;
               v_ann_dist_tsi := itmperl_dtl.ann_dist_tsi;
               EXIT;
            END LOOP;
            
            IF    (100 != v_dist_spct)
               OR (v_tsi_amt != v_dist_tsi)
               OR (v_prem_amt != v_dist_prem)
               OR (v_ann_tsi_amt != v_ann_dist_tsi)
            THEN
               v_tsi_discrep := v_tsi_amt - v_dist_tsi;
               v_prem_discrep := v_prem_amt - v_dist_prem;
               v_ann_tsi_discrep := v_ann_tsi_amt - v_ann_dist_tsi;

               BEGIN
                  IF ABS (v_tsi_discrep) <= v_discrep_limit
                  THEN
                     v_exist := 'N';

                     FOR itmperl_dtl2 IN (SELECT   share_cd
                                              FROM giuw_witemperilds_dtl
                                             WHERE dist_no = itmperl.dist_no
                                               AND peril_cd = itmperl.peril_cd
                                               AND dist_seq_no =
                                                           itmperl.dist_seq_no
                                               AND line_cd = itmperl.line_cd
                                               AND item_no = itmperl.item_no
                                               AND ABS (ROUND (dist_tsi, 2)) >=
                                                      ABS
                                                         (ROUND
                                                               (v_tsi_discrep,
                                                                2
                                                               )
                                                         )
                                          ORDER BY share_cd)
                     LOOP
                        UPDATE giuw_witemperilds_dtl
                           SET dist_tsi = NVL (dist_tsi, 0) + v_tsi_discrep
                         WHERE dist_no = itmperl.dist_no
                           AND peril_cd = itmperl.peril_cd
                           AND dist_seq_no = itmperl.dist_seq_no
                           AND line_cd = itmperl.line_cd
                           AND share_cd = itmperl_dtl2.share_cd
                           AND item_no = itmperl.item_no;
                           
                        EXIT;
                     END LOOP;
                  END IF;

                  IF ABS (v_prem_discrep) <= v_discrep_limit
                  THEN
                     v_exist := 'N';

                     FOR itmperl_dtl2 IN (SELECT   share_cd
                                              FROM giuw_witemperilds_dtl
                                             WHERE dist_no = itmperl.dist_no
                                               AND peril_cd = itmperl.peril_cd
                                               AND dist_seq_no =
                                                           itmperl.dist_seq_no
                                               AND line_cd = itmperl.line_cd
                                               AND item_no = itmperl.item_no
                                               AND ABS (ROUND (dist_prem, 2)) >=
                                                      ABS
                                                         (ROUND
                                                              (v_prem_discrep,
                                                               2
                                                              )
                                                         )
                                          ORDER BY share_cd)
                     LOOP
                        UPDATE giuw_witemperilds_dtl
                           SET dist_prem = NVL (dist_prem, 0) + v_prem_discrep
                         WHERE dist_no = itmperl.dist_no
                           AND peril_cd = itmperl.peril_cd
                           AND dist_seq_no = itmperl.dist_seq_no
                           AND line_cd = itmperl.line_cd
                           AND share_cd = itmperl_dtl2.share_cd
                           AND item_no = itmperl.item_no;
                           
                        EXIT;
                     END LOOP;
                  END IF;

                  IF ABS (v_ann_tsi_discrep) <= v_discrep_limit
                  THEN
                     v_exist := 'N';

                     FOR itmperl_dtl2 IN
                        (SELECT   share_cd
                             FROM giuw_witemperilds_dtl
                            WHERE dist_no = itmperl.dist_no
                              AND peril_cd = itmperl.peril_cd
                              AND dist_seq_no = itmperl.dist_seq_no
                              AND line_cd = itmperl.line_cd
                              AND item_no = itmperl.item_no
                              AND ABS (ROUND (ann_dist_tsi, 2)) >=
                                            ABS (ROUND (v_ann_tsi_discrep, 2))
                         ORDER BY share_cd)
                     LOOP
                        UPDATE giuw_witemperilds_dtl
                           SET ann_dist_tsi =
                                      NVL (ann_dist_tsi, 0)
                                      + v_ann_tsi_discrep
                         WHERE dist_no = itmperl.dist_no
                           AND peril_cd = itmperl.peril_cd
                           AND dist_seq_no = itmperl.dist_seq_no
                           AND line_cd = itmperl.line_cd
                           AND share_cd = itmperl_dtl2.share_cd
                           AND item_no = itmperl.item_no;
                        EXIT;
                     END LOOP;
                  END IF;
               END;
            END IF;
         END;
      END LOOP;
   END adjust_itemperil_dtl;

   PROCEDURE adjust_item_dtl (p_dist_no giuw_witemds.dist_no%TYPE)
   IS
      v_exist                   VARCHAR2 (1)                           := 'N';
      v_tsi_amt                 giuw_witemds.tsi_amt%TYPE;
      v_prem_amt                giuw_witemds.prem_amt%TYPE;
      v_ann_tsi_amt             giuw_witemds.ann_tsi_amt%TYPE;
      v_dist_tsi                giuw_witemds_dtl.dist_tsi%TYPE;
      v_dist_spct               giuw_witemds_dtl.dist_spct%TYPE;
      v_dist_prem               giuw_witemds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi            giuw_witemds_dtl.ann_dist_tsi%TYPE;
      v_sum_dist_tsi            giuw_witemds_dtl.dist_tsi%TYPE;
      v_sum_dist_spct           giuw_witemds_dtl.dist_spct%TYPE;
      v_sum_dist_prem           giuw_witemds_dtl.dist_prem%TYPE;
      v_correct_dist_tsi        giuw_witemds_dtl.dist_tsi%TYPE;
      v_sum_ann_dist_tsi        giuw_witemds_dtl.ann_dist_tsi%TYPE;
      v_sum_ann_dist_spct       giuw_witemds_dtl.ann_dist_spct%TYPE;
      v_correct_dist_spct       giuw_witemds_dtl.dist_spct%TYPE;
      v_correct_dist_prem       giuw_witemds_dtl.dist_prem%TYPE;
      v_correct_ann_dist_tsi    giuw_witemds_dtl.ann_dist_tsi%TYPE;
      v_correct_ann_dist_spct   giuw_witemds_dtl.ann_dist_spct%TYPE;
      v_item_dist_tsi           giuw_witemds_dtl.dist_tsi%TYPE;
      v_item_dist_prem          giuw_witemds_dtl.dist_prem%TYPE;
      v_item_dist_spct          giuw_witemds_dtl.dist_spct%TYPE;
      v_item_ann_dist_tsi       giuw_witemds_dtl.ann_dist_tsi%TYPE;
      v_itmperl_dist_tsi        giuw_witemperilds_dtl.dist_tsi%TYPE;
      v_itmperl_dist_prem       giuw_witemperilds_dtl.dist_prem%TYPE;
      v_itmperl_dist_spct       giuw_witemperilds_dtl.dist_spct%TYPE;
      v_itmperl_ann_dist_tsi    giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
      v_peril_type              giis_peril.peril_type%TYPE;
      v_diff_tsi                giuw_witemperilds_dtl.dist_tsi%TYPE;
      v_diff_prem               giuw_witemperilds_dtl.dist_prem%TYPE;
      v_diff_ann_tsi            giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
      v_item                    giuw_witemds_dtl.item_no%TYPE;
   BEGIN
      --4. compare giuw_witem and giuw_witemds_dtl
      FOR item IN (SELECT dist_no, dist_seq_no, item_no,
                          ROUND (NVL (tsi_amt, 0), 2) tsi_amt,
                          ROUND (NVL (prem_amt, 0), 2) prem_amt,
                          ROUND (NVL (ann_tsi_amt, 0), 2) ann_tsi_amt
                     FROM giuw_witemds
                    WHERE dist_no = p_dist_no)
      LOOP
         BEGIN
            v_tsi_amt := item.tsi_amt;
            v_prem_amt := item.prem_amt;
            v_ann_tsi_amt := item.ann_tsi_amt;

            BEGIN
               v_exist := 'N';

               FOR itemperl_dtl IN
                  (SELECT   a.share_cd, a.line_cd,
                            SUM (ROUND (NVL (DECODE (b.peril_type,
                                                     'B', a.dist_tsi,
                                                     0
                                                    ),
                                             0
                                            ),
                                        2
                                       )
                                ) dist_tsi,
                            SUM (ROUND (NVL (a.dist_prem, 0), 2)) dist_prem,
                            SUM
                               (ROUND (NVL (DECODE (b.peril_type,
                                                    'B', a.ann_dist_tsi,
                                                    0
                                                   ),
                                            0
                                           ),
                                       2
                                      )
                               ) ann_dist_tsi
                       FROM giuw_witemperilds_dtl a, giis_peril b
                      WHERE a.dist_no = item.dist_no
                        AND a.dist_seq_no = item.dist_seq_no
                        AND a.item_no = item.item_no
                        AND a.peril_cd = b.peril_cd
                        AND a.line_cd = b.line_cd
                   GROUP BY a.share_cd, a.line_cd
                   ORDER BY a.share_cd, a.line_cd)
               LOOP
                  UPDATE giuw_witemds_dtl
                     SET dist_tsi = itemperl_dtl.dist_tsi,
                         dist_prem = itemperl_dtl.dist_prem,
                         ann_dist_tsi = itemperl_dtl.ann_dist_tsi
                   WHERE dist_no = item.dist_no
                     AND dist_seq_no = item.dist_seq_no
                     AND item_no = item.item_no
                     AND line_cd = itemperl_dtl.line_cd
                     AND share_cd = itemperl_dtl.share_cd;
               END LOOP;
            END;
--            END IF;
         END;
      END LOOP;
   END adjust_item_dtl;

   PROCEDURE adjust_pol_dtl (p_dist_no giuw_wpolicyds.dist_no%TYPE)
   IS
      v_exist                   VARCHAR2 (1)                           := 'N';
      v_tsi_amt                 giuw_witemds.tsi_amt%TYPE;
      v_prem_amt                giuw_witemds.prem_amt%TYPE;
      v_ann_tsi_amt             giuw_witemds.ann_tsi_amt%TYPE;
      v_dist_tsi                giuw_witemds_dtl.dist_tsi%TYPE;
      v_dist_spct               giuw_witemds_dtl.dist_spct%TYPE;
      v_dist_prem               giuw_witemds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi            giuw_witemds_dtl.ann_dist_tsi%TYPE;
      v_sum_dist_tsi            giuw_witemds_dtl.dist_tsi%TYPE;
      v_sum_dist_spct           giuw_witemds_dtl.dist_spct%TYPE;
      v_sum_dist_prem           giuw_witemds_dtl.dist_prem%TYPE;
      v_correct_dist_tsi        giuw_witemds_dtl.dist_tsi%TYPE;
      v_sum_ann_dist_tsi        giuw_witemds_dtl.ann_dist_tsi%TYPE;
      v_sum_ann_dist_spct       giuw_witemds_dtl.ann_dist_spct%TYPE;
      v_correct_dist_spct       giuw_witemds_dtl.dist_spct%TYPE;
      v_correct_dist_prem       giuw_witemds_dtl.dist_prem%TYPE;
      v_correct_ann_dist_tsi    giuw_witemds_dtl.ann_dist_tsi%TYPE;
      v_correct_ann_dist_spct   giuw_witemds_dtl.ann_dist_spct%TYPE;
      v_pol_dist_tsi            giuw_wpolicyds_dtl.dist_tsi%TYPE;
      v_pol_dist_prem           giuw_wpolicyds_dtl.dist_prem%TYPE;
      v_pol_dist_spct           giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_pol_ann_dist_tsi        giuw_wpolicyds_dtl.ann_dist_tsi%TYPE;
      v_itmperl_dist_tsi        giuw_witemperilds_dtl.dist_tsi%TYPE;
      v_itmperl_dist_prem       giuw_witemperilds_dtl.dist_prem%TYPE;
      v_itmperl_dist_spct       giuw_witemperilds_dtl.dist_spct%TYPE;
      v_itmperl_ann_dist_tsi    giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
      v_peril_type              giis_peril.peril_type%TYPE;
      v_diff_tsi                giuw_witemperilds_dtl.dist_tsi%TYPE;
      v_diff_prem               giuw_witemperilds_dtl.dist_prem%TYPE;
      v_diff_ann_tsi            giuw_witemperilds_dtl.ann_dist_tsi%TYPE;
      v_diff_spct               giuw_wpolicyds_dtl.dist_spct%TYPE;
      v_item                    giuw_witemds_dtl.item_no%TYPE;
   BEGIN
      --6. compare giuw_wpolicyds with giuw_wpolicyds_dtl
      FOR pol IN (SELECT dist_no, dist_seq_no,
                         ROUND (NVL (tsi_amt, 0), 2) tsi_amt,
                         ROUND (NVL (prem_amt, 0), 2) prem_amt,
                         ROUND (NVL (ann_tsi_amt, 0), 2) ann_tsi_amt
                    FROM giuw_wpolicyds
                   WHERE dist_no = p_dist_no)
      LOOP
         BEGIN
            v_tsi_amt := pol.tsi_amt;
            v_prem_amt := pol.prem_amt;
            v_ann_tsi_amt := pol.ann_tsi_amt;

            FOR pol_dtl IN
               (SELECT SUM (ROUND (NVL (dist_tsi, 0), 2)) dist_tsi,
                       SUM (ROUND (NVL (dist_prem, 0), 2)) dist_prem,
                       SUM (ROUND (NVL (ann_dist_tsi, 0), 2)) ann_dist_tsi,
                       SUM (ROUND (NVL (dist_spct, 0), 9)) dist_spct
                  FROM giuw_wpolicyds_dtl
                 WHERE dist_no = pol.dist_no
                       AND dist_seq_no = pol.dist_seq_no)
            LOOP
               v_dist_tsi := pol_dtl.dist_tsi;
               v_dist_prem := pol_dtl.dist_prem;
               v_dist_spct := pol_dtl.dist_spct;
               v_ann_dist_tsi := pol_dtl.ann_dist_tsi;
               EXIT;
            END LOOP;

            BEGIN
               FOR itmperl_dtl5 IN
                  (SELECT   a.share_cd, a.line_cd,
                            SUM (ROUND (NVL (DECODE (b.peril_type,
                                                     'B', a.dist_tsi,
                                                     0
                                                    ),
                                             0
                                            ),
                                        2
                                       )
                                ) dist_tsi,
                            SUM (ROUND (NVL (a.dist_prem, 0), 2)) dist_prem,
                            SUM
                               (ROUND (NVL (DECODE (b.peril_type,
                                                    'B', a.ann_dist_tsi,
                                                    0
                                                   ),
                                            0
                                           ),
                                       2
                                      )
                               ) ann_dist_tsi
                       FROM giuw_witemperilds_dtl a, giis_peril b
                      WHERE a.dist_no = pol.dist_no
                        AND a.dist_seq_no = pol.dist_seq_no
                        AND a.peril_cd = b.peril_cd
                        AND a.line_cd = b.line_cd
                   GROUP BY a.share_cd, a.line_cd
                   ORDER BY a.share_cd, a.line_cd)
               LOOP
                  UPDATE giuw_wpolicyds_dtl
                     SET dist_tsi = itmperl_dtl5.dist_tsi,
                         dist_prem = itmperl_dtl5.dist_prem,
                         ann_dist_tsi = itmperl_dtl5.ann_dist_tsi
                   WHERE dist_no = pol.dist_no
                     AND dist_seq_no = pol.dist_seq_no
                     AND line_cd = itmperl_dtl5.line_cd
                     AND share_cd = itmperl_dtl5.share_cd;
               END LOOP;
            END;
         END;
      END LOOP;
   END adjust_pol_dtl;

   PROCEDURE adjust_share (p_dist_no giuw_wpolicyds.dist_no%TYPE)
   IS
      v_dist_spct               giuw_witemperilds_dtl.dist_spct%TYPE;
      v_dist_spct1              giuw_witemperilds_dtl.dist_spct%TYPE;
      v_ann_dist_spct           giuw_witemperilds_dtl.dist_spct%TYPE;
      v_dist_spct_discrep       giuw_witemperilds_dtl.dist_spct%TYPE;
      v_dist_spct1_discrep      giuw_witemperilds_dtl.dist_spct%TYPE;
      v_ann_dist_spct_discrep   giuw_witemperilds_dtl.dist_spct%TYPE;
      v_discrep_limit           giuw_wperilds_dtl.dist_tsi%TYPE        := 0.5;
   BEGIN
      /*for witemperilds_dtl*/
      FOR itmperl IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.line_cd,
                             a.peril_cd
                        FROM giuw_witemperilds a
                       WHERE dist_no = p_dist_no)
      LOOP
         v_dist_spct := 0;
         v_dist_spct1 := NULL;
         v_ann_dist_spct := 0;
         v_dist_spct_discrep := 0;
         v_dist_spct1_discrep := NULL;
         v_ann_dist_spct_discrep := 0;

         FOR itmperl_dtl IN
            (SELECT ROUND (SUM (NVL (dist_spct, 0)), 9) dist_spct,
                    ROUND (SUM (NVL (ann_dist_spct, 0)), 9) ann_dist_spct,
                    ROUND (SUM (dist_spct1), 9) dist_spct1
               FROM giuw_witemperilds_dtl
              WHERE peril_cd = itmperl.peril_cd
                AND line_cd = itmperl.line_cd
                AND item_no = itmperl.item_no
                AND dist_seq_no = itmperl.dist_seq_no
                AND dist_no = itmperl.dist_no)
         LOOP
            v_dist_spct := itmperl_dtl.dist_spct;
            v_ann_dist_spct := itmperl_dtl.ann_dist_spct;

            IF itmperl_dtl.dist_spct1 IS NOT NULL
            THEN
               v_dist_spct1 := itmperl_dtl.dist_spct1;
            END IF;

            EXIT;
         END LOOP;

         IF    (100 != v_dist_spct)
            OR (100 != v_ann_dist_spct)
            OR (v_dist_spct1 IS NOT NULL AND 100 != v_dist_spct1)
         THEN
            v_dist_spct_discrep := 100 - v_dist_spct;
            v_ann_dist_spct_discrep := 100 - v_ann_dist_spct;

            IF v_dist_spct1 IS NOT NULL
            THEN
               v_dist_spct1_discrep := 100 - v_dist_spct1;
            END IF;

            IF ABS (v_dist_spct_discrep) <= v_discrep_limit
            THEN
               BEGIN
                  FOR itmperl_dtl2 IN
                     (SELECT   share_cd
                          FROM giuw_witemperilds_dtl
                         WHERE dist_no = itmperl.dist_no
                           AND peril_cd = itmperl.peril_cd
                           AND dist_seq_no = itmperl.dist_seq_no
                           AND line_cd = itmperl.line_cd
                           AND item_no = itmperl.item_no
                           AND ABS (ROUND (dist_spct, 9)) >
                                          ABS (ROUND (v_dist_spct_discrep, 9))
                      ORDER BY share_cd)
                  LOOP
                     UPDATE giuw_witemperilds_dtl
                        SET dist_spct =
                                       NVL (dist_spct, 0)
                                       + v_dist_spct_discrep
                      WHERE dist_no = itmperl.dist_no
                        AND peril_cd = itmperl.peril_cd
                        AND dist_seq_no = itmperl.dist_seq_no
                        AND line_cd = itmperl.line_cd
                        AND share_cd = itmperl_dtl2.share_cd
                        AND item_no = itmperl.item_no;

                     EXIT;
                  END LOOP;
               END;
            END IF;

            IF ABS (v_ann_dist_spct_discrep) <= v_discrep_limit
            THEN
               BEGIN
                  FOR itmperl_dtl2 IN
                     (SELECT   share_cd
                          FROM giuw_witemperilds_dtl
                         WHERE dist_no = itmperl.dist_no
                           AND peril_cd = itmperl.peril_cd
                           AND dist_seq_no = itmperl.dist_seq_no
                           AND line_cd = itmperl.line_cd
                           AND item_no = itmperl.item_no
                           AND ABS (ROUND (ann_dist_spct, 9)) >
                                      ABS (ROUND (v_ann_dist_spct_discrep, 9))
                      ORDER BY share_cd)
                  LOOP
                     UPDATE giuw_witemperilds_dtl
                        SET ann_dist_spct =
                               NVL (ann_dist_spct, 0)
                               + v_ann_dist_spct_discrep
                      WHERE dist_no = itmperl.dist_no
                        AND peril_cd = itmperl.peril_cd
                        AND dist_seq_no = itmperl.dist_seq_no
                        AND line_cd = itmperl.line_cd
                        AND share_cd = itmperl_dtl2.share_cd
                        AND item_no = itmperl.item_no;

                     EXIT;
                  END LOOP;
               END;
            END IF;

            IF     (v_dist_spct1_discrep IS NOT NULL)
               AND ABS (v_dist_spct1_discrep) <= v_discrep_limit
            THEN
               FOR itmperl_dtl2 IN (SELECT   share_cd
                                        FROM giuw_witemperilds_dtl
                                       WHERE dist_no = itmperl.dist_no
                                         AND peril_cd = itmperl.peril_cd
                                         AND dist_seq_no = itmperl.dist_seq_no
                                         AND line_cd = itmperl.line_cd
                                         AND item_no = itmperl.item_no
                                         AND ABS (ROUND (dist_spct1, 9)) >
                                                ABS
                                                   (ROUND
                                                        (v_dist_spct1_discrep,
                                                         9
                                                        )
                                                   )
                                    ORDER BY share_cd)
               LOOP
                  UPDATE giuw_witemperilds_dtl
                     SET dist_spct1 =
                                     NVL (dist_spct1, 0)
                                     + v_dist_spct1_discrep
                   WHERE dist_no = itmperl.dist_no
                     AND peril_cd = itmperl.peril_cd
                     AND dist_seq_no = itmperl.dist_seq_no
                     AND line_cd = itmperl.line_cd
                     AND share_cd = itmperl_dtl2.share_cd
                     AND item_no = itmperl.item_no;

                  EXIT;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      /*for wperilds_dtl*/
      FOR perl IN (SELECT a.dist_no, a.dist_seq_no, a.line_cd, a.peril_cd
                     FROM giuw_wperilds a
                    WHERE dist_no = p_dist_no)
      LOOP
         v_dist_spct := 0;
         v_dist_spct1 := NULL;
         v_ann_dist_spct := 0;
         v_dist_spct_discrep := 0;
         v_dist_spct1_discrep := NULL;
         v_ann_dist_spct_discrep := 0;

         FOR perl_dtl IN
            (SELECT ROUND (SUM (NVL (dist_spct, 0)), 9) dist_spct,
                    ROUND (SUM (NVL (ann_dist_spct, 0)), 9) ann_dist_spct,
                    ROUND (SUM (dist_spct1), 9) dist_spct1
               FROM giuw_wperilds_dtl
              WHERE peril_cd = perl.peril_cd
                AND line_cd = perl.line_cd
                AND dist_seq_no = perl.dist_seq_no
                AND dist_no = perl.dist_no)
         LOOP
            v_dist_spct := perl_dtl.dist_spct;
            v_ann_dist_spct := perl_dtl.ann_dist_spct;

            IF perl_dtl.dist_spct1 IS NOT NULL
            THEN
               v_dist_spct1 := perl_dtl.dist_spct1;
            END IF;

            EXIT;
         END LOOP;

         IF    (100 != v_dist_spct)
            OR (100 != v_ann_dist_spct)
            OR (v_dist_spct1 IS NOT NULL AND 100 != v_dist_spct1)
         THEN
            v_dist_spct_discrep := 100 - v_dist_spct;
            v_ann_dist_spct_discrep := 100 - v_ann_dist_spct;

            IF v_dist_spct1 IS NOT NULL
            THEN
               v_dist_spct1_discrep := 100 - v_dist_spct1;
            END IF;

            IF ABS (v_dist_spct_discrep) <= v_discrep_limit
            THEN
               BEGIN
                  FOR perl_dtl2 IN (SELECT   share_cd
                                        FROM giuw_wperilds_dtl
                                       WHERE dist_no = perl.dist_no
                                         AND peril_cd = perl.peril_cd
                                         AND dist_seq_no = perl.dist_seq_no
                                         AND line_cd = perl.line_cd
                                         AND ABS (ROUND (dist_spct, 9)) >
                                                ABS
                                                   (ROUND
                                                         (v_dist_spct_discrep,
                                                          9
                                                         )
                                                   )
                                    ORDER BY share_cd)
                  LOOP
                     UPDATE giuw_wperilds_dtl
                        SET dist_spct =
                                       NVL (dist_spct, 0)
                                       + v_dist_spct_discrep
                      WHERE dist_no = perl.dist_no
                        AND peril_cd = perl.peril_cd
                        AND dist_seq_no = perl.dist_seq_no
                        AND line_cd = perl.line_cd
                        AND share_cd = perl_dtl2.share_cd;

                     EXIT;
                  END LOOP;
               END;
            END IF;

            IF ABS (v_ann_dist_spct_discrep) <= v_discrep_limit
            THEN
               BEGIN
                  FOR perl_dtl2 IN
                     (SELECT   share_cd
                          FROM giuw_wperilds_dtl
                         WHERE dist_no = perl.dist_no
                           AND peril_cd = perl.peril_cd
                           AND dist_seq_no = perl.dist_seq_no
                           AND line_cd = perl.line_cd
                           AND ABS (ROUND (ann_dist_spct, 9)) >
                                      ABS (ROUND (v_ann_dist_spct_discrep, 9))
                      ORDER BY share_cd)
                  LOOP
                     UPDATE giuw_wperilds_dtl
                        SET ann_dist_spct =
                               NVL (ann_dist_spct, 0)
                               + v_ann_dist_spct_discrep
                      WHERE dist_no = perl.dist_no
                        AND peril_cd = perl.peril_cd
                        AND dist_seq_no = perl.dist_seq_no
                        AND line_cd = perl.line_cd
                        AND share_cd = perl_dtl2.share_cd;

                     EXIT;
                  END LOOP;
               END;
            END IF;

            IF     (v_dist_spct1_discrep IS NOT NULL)
               AND ABS (v_dist_spct1_discrep) <= v_discrep_limit
            THEN
               FOR perl_dtl2 IN (SELECT   share_cd
                                     FROM giuw_wperilds_dtl
                                    WHERE dist_no = perl.dist_no
                                      AND peril_cd = perl.peril_cd
                                      AND dist_seq_no = perl.dist_seq_no
                                      AND line_cd = perl.line_cd
                                      AND ABS (ROUND (dist_spct1, 9)) >
                                             ABS (ROUND (v_dist_spct1_discrep,
                                                         9
                                                        )
                                                 )
                                 ORDER BY share_cd)
               LOOP
                  UPDATE giuw_wperilds_dtl
                     SET dist_spct1 =
                                     NVL (dist_spct1, 0)
                                     + v_dist_spct1_discrep
                   WHERE dist_no = perl.dist_no
                     AND peril_cd = perl.peril_cd
                     AND dist_seq_no = perl.dist_seq_no
                     AND line_cd = perl.line_cd
                     AND share_cd = perl_dtl2.share_cd;

                  EXIT;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      /*for witemds_dtl*/
      FOR itm IN (SELECT a.dist_no, a.dist_seq_no, a.item_no
                    FROM giuw_witemds a
                   WHERE dist_no = p_dist_no)
      LOOP
         v_dist_spct := 0;
         v_dist_spct1 := NULL;
         v_ann_dist_spct := 0;
         v_dist_spct_discrep := 0;
         v_dist_spct1_discrep := NULL;
         v_ann_dist_spct_discrep := 0;

         FOR itm_dtl IN
            (SELECT ROUND (SUM (NVL (dist_spct, 0)), 9) dist_spct,
                    ROUND (SUM (NVL (ann_dist_spct, 0)), 9) ann_dist_spct,
                    ROUND (SUM (dist_spct1), 9) dist_spct1
               FROM giuw_witemds_dtl
              WHERE item_no = itm.item_no
                AND dist_seq_no = itm.dist_seq_no
                AND dist_no = itm.dist_no)
         LOOP
            v_dist_spct := itm_dtl.dist_spct;
            v_ann_dist_spct := itm_dtl.ann_dist_spct;

            IF itm_dtl.dist_spct1 IS NOT NULL
            THEN
               v_dist_spct1 := itm_dtl.dist_spct1;
            END IF;

            EXIT;
         END LOOP;

         IF    (100 != v_dist_spct)
            OR (100 != v_ann_dist_spct)
            OR (v_dist_spct1 IS NOT NULL AND 100 != v_dist_spct1)
         THEN
            v_dist_spct_discrep := 100 - v_dist_spct;
            v_ann_dist_spct_discrep := 100 - v_ann_dist_spct;

            IF v_dist_spct1 IS NOT NULL
            THEN
               v_dist_spct1_discrep := 100 - v_dist_spct1;
            END IF;

            IF ABS (v_dist_spct_discrep) <= v_discrep_limit
            THEN
               BEGIN
                  FOR itm_dtl2 IN (SELECT   share_cd
                                       FROM giuw_witemds_dtl
                                      WHERE dist_no = itm.dist_no
                                        AND dist_seq_no = itm.dist_seq_no
                                        AND item_no = itm.item_no
                                        AND ABS (ROUND (dist_spct, 9)) >
                                               ABS
                                                  (ROUND (v_dist_spct_discrep,
                                                          9
                                                         )
                                                  )
                                   ORDER BY share_cd)
                  LOOP
                     UPDATE giuw_witemds_dtl
                        SET dist_spct =
                                       NVL (dist_spct, 0)
                                       + v_dist_spct_discrep
                      WHERE dist_no = itm.dist_no
                        AND dist_seq_no = itm.dist_seq_no
                        AND share_cd = itm_dtl2.share_cd
                        AND item_no = itm.item_no;

                     EXIT;
                  END LOOP;
               END;
            END IF;

            IF ABS (v_ann_dist_spct_discrep) <= v_discrep_limit
            THEN
               BEGIN
                  FOR itm_dtl2 IN
                     (SELECT   share_cd
                          FROM giuw_witemds_dtl
                         WHERE dist_no = itm.dist_no
                           AND dist_seq_no = itm.dist_seq_no
                           AND item_no = itm.item_no
                           AND ABS (ROUND (ann_dist_spct, 9)) >
                                      ABS (ROUND (v_ann_dist_spct_discrep, 9))
                      ORDER BY share_cd)
                  LOOP
                     UPDATE giuw_witemds_dtl
                        SET ann_dist_spct =
                               NVL (ann_dist_spct, 0)
                               + v_ann_dist_spct_discrep
                      WHERE dist_no = itm.dist_no
                        AND dist_seq_no = itm.dist_seq_no
                        AND share_cd = itm_dtl2.share_cd
                        AND item_no = itm.item_no;

                     EXIT;
                  END LOOP;
               END;
            END IF;

            IF     (v_dist_spct1_discrep IS NOT NULL)
               AND ABS (v_dist_spct1_discrep) <= v_discrep_limit
            THEN
               FOR itm_dtl2 IN (SELECT   share_cd
                                    FROM giuw_witemds_dtl
                                   WHERE dist_no = itm.dist_no
                                     AND dist_seq_no = itm.dist_seq_no
                                     AND item_no = itm.item_no
                                     AND ABS (ROUND (dist_spct1, 9)) >
                                            ABS (ROUND (v_dist_spct1_discrep,
                                                        9
                                                       )
                                                )
                                ORDER BY share_cd)
               LOOP
                  UPDATE giuw_witemds_dtl
                     SET dist_spct1 =
                                     NVL (dist_spct1, 0)
                                     + v_dist_spct1_discrep
                   WHERE dist_no = itm.dist_no
                     AND dist_seq_no = itm.dist_seq_no
                     AND share_cd = itm_dtl2.share_cd
                     AND item_no = itm.item_no;

                  EXIT;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      /*for wpolicyds_dtl*/
      FOR pol IN (SELECT a.dist_no, a.dist_seq_no
                    FROM giuw_wpolicyds a
                   WHERE dist_no = p_dist_no)
      LOOP
         v_dist_spct := 0;
         v_dist_spct1 := NULL;
         v_ann_dist_spct := 0;
         v_dist_spct_discrep := 0;
         v_dist_spct1_discrep := NULL;
         v_ann_dist_spct_discrep := 0;

         FOR pol_dtl IN
            (SELECT ROUND (SUM (NVL (dist_spct, 0)), 9) dist_spct,
                    ROUND (SUM (NVL (ann_dist_spct, 0)), 9) ann_dist_spct,
                    ROUND (SUM (dist_spct1), 9) dist_spct1
               FROM giuw_wpolicyds_dtl
              WHERE dist_seq_no = pol.dist_seq_no AND dist_no = pol.dist_no)
         LOOP
            v_dist_spct := pol_dtl.dist_spct;
            v_ann_dist_spct := pol_dtl.ann_dist_spct;

            IF pol_dtl.dist_spct1 IS NOT NULL
            THEN
               v_dist_spct1 := pol_dtl.dist_spct1;
            END IF;

            EXIT;
         END LOOP;

         IF    (100 != v_dist_spct)
            OR (100 != v_ann_dist_spct)
            OR (v_dist_spct1 IS NOT NULL AND 100 != v_dist_spct1)
         THEN
            v_dist_spct_discrep := 100 - v_dist_spct;
            v_ann_dist_spct_discrep := 100 - v_ann_dist_spct;

            IF v_dist_spct1 IS NOT NULL
            THEN
               v_dist_spct1_discrep := 100 - v_dist_spct1;
            END IF;

            IF ABS (v_dist_spct_discrep) <= v_discrep_limit
            THEN
               BEGIN
                  FOR pol_dtl2 IN (SELECT   share_cd
                                       FROM giuw_wpolicyds_dtl
                                      WHERE dist_no = pol.dist_no
                                        AND dist_seq_no = pol.dist_seq_no
                                        AND ABS (ROUND (dist_spct, 9)) >
                                               ABS
                                                  (ROUND (v_dist_spct_discrep,
                                                          9
                                                         )
                                                  )
                                   ORDER BY share_cd)
                  LOOP
                     UPDATE giuw_wpolicyds_dtl
                        SET dist_spct =
                                       NVL (dist_spct, 0)
                                       + v_dist_spct_discrep
                      WHERE dist_no = pol.dist_no
                        AND dist_seq_no = pol.dist_seq_no
                        AND share_cd = pol_dtl2.share_cd;

                     EXIT;
                  END LOOP;
               END;
            END IF;

            IF ABS (v_ann_dist_spct_discrep) <= v_discrep_limit
            THEN
               BEGIN
                  FOR pol_dtl2 IN
                     (SELECT   share_cd
                          FROM giuw_wpolicyds_dtl
                         WHERE dist_no = pol.dist_no
                           AND dist_seq_no = pol.dist_seq_no
                           AND ABS (ROUND (ann_dist_spct, 9)) >
                                      ABS (ROUND (v_ann_dist_spct_discrep, 9))
                      ORDER BY share_cd)
                  LOOP
                     UPDATE giuw_wpolicyds_dtl
                        SET ann_dist_spct =
                               NVL (ann_dist_spct, 0)
                               + v_ann_dist_spct_discrep
                      WHERE dist_no = pol.dist_no
                        AND dist_seq_no = pol.dist_seq_no
                        AND share_cd = pol_dtl2.share_cd;

                     EXIT;
                  END LOOP;
               END;
            END IF;

            IF     (v_dist_spct1_discrep IS NOT NULL)
               AND ABS (v_dist_spct1_discrep) <= v_discrep_limit
            THEN
               FOR pol_dtl2 IN (SELECT   share_cd
                                    FROM giuw_wpolicyds_dtl
                                   WHERE dist_no = pol.dist_no
                                     AND dist_seq_no = pol.dist_seq_no
                                     AND ABS (ROUND (dist_spct1, 9)) >
                                            ABS (ROUND (v_dist_spct1_discrep,
                                                        9
                                                       )
                                                )
                                ORDER BY share_cd)
               LOOP
                  UPDATE giuw_wpolicyds_dtl
                     SET dist_spct1 =
                                     NVL (dist_spct1, 0)
                                     + v_dist_spct1_discrep
                   WHERE dist_no = pol.dist_no
                     AND dist_seq_no = pol.dist_seq_no
                     AND share_cd = pol_dtl2.share_cd;

                  EXIT;
               END LOOP;
            END IF;
         END IF;
      END LOOP;
   END adjust_share;

   PROCEDURE adjust_share_wdistfrps (p_dist_no giuw_wpolicyds.dist_no%TYPE)
   IS
   /*added procedure. 06.09.14 apignas_jr.*/
   BEGIN
      FOR upd_gwd IN (SELECT   poldtl.dist_no, poldtl.dist_seq_no,
                               SUM (NVL (poldtl.dist_tsi, 0)) dist_tsi,
                               SUM (NVL (poldtl.dist_prem, 0)) dist_prem,                               
                               poldtl.dist_spct, poldtl.dist_spct1,
                               NVL(polds.tsi_amt,0) tsi_amt,NVL(polds.prem_amt,0) prem_amt 
                          FROM giuw_wpolicyds_dtl poldtl , giuw_wpolicyds polds 
                         WHERE poldtl.dist_no = p_dist_no AND poldtl.share_cd = 999
                               AND poldtl.dist_no = polds.dist_no
                               AND poldtl.dist_seq_no = polds.dist_seq_no
                      GROUP BY poldtl.dist_no, poldtl.dist_seq_no, poldtl.dist_spct, poldtl.dist_spct1,
                            NVL(polds.tsi_amt,0) ,NVL(polds.prem_amt,0) )    -- jhing 02.19.2016  added connection to giuw_wpolicyds to correct incorrect tsi_amt and/or prem_amt
      LOOP
         UPDATE giri_wdistfrps gwd
            SET gwd.tot_fac_spct = upd_gwd.dist_spct,
                gwd.tot_fac_spct2 = upd_gwd.dist_spct1,
                gwd.tot_fac_tsi = upd_gwd.dist_tsi,
                gwd.tot_fac_prem = upd_gwd.dist_prem,
                gwd.tsi_amt      = upd_gwd.tsi_amt,  -- reikoh added tsi_amt and prem_amt
                gwd.prem_amt     = upd_gwd.prem_amt
          WHERE gwd.dist_no = upd_gwd.dist_no
            AND gwd.dist_seq_no = upd_gwd.dist_seq_no;
      END LOOP;
      
     
   END adjust_share_wdistfrps;

   PROCEDURE recompute_before_adjust_share (
      p_dist_no   giuw_wpolicyds.dist_no%TYPE
   )
   IS
      v_dist_spct       giuw_witemperilds_dtl.dist_spct%TYPE;
      v_dist_spct1      giuw_witemperilds_dtl.dist_spct%TYPE;
      v_ann_dist_spct   giuw_witemperilds_dtl.dist_spct%TYPE;
   BEGIN
      /*recomputes %share of giuw_wpolicyds_dtl*/
      FOR pol IN (SELECT a.dist_no, a.dist_seq_no,
                         ROUND (NVL (a.tsi_amt, 0), 2) tsi_amt,
                         ROUND (NVL (a.ann_tsi_amt, 0), 2) ann_tsi_amt,
                         ROUND (NVL (a.prem_amt, 0), 2) prem_amt
                    FROM giuw_wpolicyds a
                   WHERE dist_no = p_dist_no)
      LOOP
         v_dist_spct := 0;
         v_dist_spct1 := NULL;
         v_ann_dist_spct := 0;

         FOR pol_dtl IN (SELECT share_cd,
                                ROUND (NVL (dist_tsi, 0), 2) dist_tsi,
                                ROUND (NVL (ann_dist_tsi, 0), 2)
                                                                ann_dist_tsi,
                                ROUND (NVL (dist_prem, 0), 2) dist_prem,
                                dist_spct1
                           FROM giuw_wpolicyds_dtl
                          WHERE dist_seq_no = pol.dist_seq_no
                            AND dist_no = pol.dist_no)
         LOOP
            IF pol.tsi_amt = 0 AND pol.prem_amt <> 0
            THEN
               v_dist_spct :=
                       ROUND (((pol_dtl.dist_prem / pol.prem_amt) * 100), 9);
            ELSIF pol.tsi_amt = 0 AND pol.prem_amt = 0
            THEN
               v_dist_spct := 0;
            ELSE
               v_dist_spct :=
                         ROUND (((pol_dtl.dist_tsi / pol.tsi_amt) * 100), 9);
            END IF;
            
            IF pol.ann_tsi_amt = 0 --added by steven 06.23.2014
            THEN
               v_ann_dist_spct := 0;
            ELSE
               v_ann_dist_spct :=
                  ROUND (((pol_dtl.ann_dist_tsi / pol.ann_tsi_amt) * 100), 9);
            END IF;

            IF pol_dtl.dist_spct1 IS NOT NULL
            THEN
               IF pol.tsi_amt <> 0 AND pol.prem_amt = 0
               THEN
                  v_dist_spct1 :=
                         ROUND (((pol_dtl.dist_tsi / pol.tsi_amt) * 100), 9);
               ELSIF pol.prem_amt <> 0
               THEN
                  v_dist_spct1 :=
                       ROUND (((pol_dtl.dist_prem / pol.prem_amt) * 100), 9);
               ELSE
                  v_dist_spct1 := 0;
               END IF;
            ELSE
               v_dist_spct1 := NULL;
            END IF;

            UPDATE giuw_wpolicyds_dtl
               SET dist_spct = v_dist_spct,
                   dist_spct1 = v_dist_spct1,
                   ann_dist_spct = v_ann_dist_spct
             WHERE dist_no = pol.dist_no
               AND dist_seq_no = pol.dist_seq_no
               AND share_cd = pol_dtl.share_cd;
         END LOOP;
      END LOOP;

      /*recomputes %shares of giuw_witemds_dtl*/
      FOR itm IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                         ROUND (NVL (a.tsi_amt, 0), 2) tsi_amt,
                         ROUND (NVL (a.ann_tsi_amt, 0), 2) ann_tsi_amt,
                         ROUND (NVL (a.prem_amt, 0), 2) prem_amt
                    FROM giuw_witemds a
                   WHERE dist_no = p_dist_no)
      LOOP
         v_dist_spct := 0;
         v_dist_spct1 := NULL;
         v_ann_dist_spct := 0;

         FOR itm_dtl IN (SELECT share_cd,
                                ROUND (NVL (dist_tsi, 0), 2) dist_tsi,
                                ROUND (NVL (ann_dist_tsi, 0), 2)
                                                                ann_dist_tsi,
                                ROUND (NVL (dist_prem, 0), 2) dist_prem,
                                dist_spct1
                           FROM giuw_witemds_dtl
                          WHERE item_no = itm.item_no
                            AND dist_seq_no = itm.dist_seq_no
                            AND dist_no = itm.dist_no)
         LOOP
            IF itm.tsi_amt = 0 AND itm.prem_amt <> 0
            THEN
               v_dist_spct :=
                       ROUND (((itm_dtl.dist_prem / itm.prem_amt) * 100), 9);
            ELSIF itm.tsi_amt = 0 AND itm.prem_amt = 0
            THEN
               v_dist_spct := 0;
            ELSE
               v_dist_spct :=
                         ROUND (((itm_dtl.dist_tsi / itm.tsi_amt) * 100), 9);
            END IF;

            IF itm.ann_tsi_amt = 0 --added by steven 06.23.2014
            THEN
               v_ann_dist_spct := 0;
            ELSE
               v_ann_dist_spct :=
                  ROUND (((itm_dtl.ann_dist_tsi / itm.ann_tsi_amt) * 100), 9);
            END IF;

            IF itm_dtl.dist_spct1 IS NOT NULL
            THEN
               IF itm.tsi_amt <> 0 AND itm.prem_amt = 0
               THEN
                  v_dist_spct1 :=
                         ROUND (((itm_dtl.dist_tsi / itm.tsi_amt) * 100), 9);
               ELSIF itm.prem_amt <> 0
               THEN
                  v_dist_spct1 :=
                       ROUND (((itm_dtl.dist_prem / itm.prem_amt) * 100), 9);
               ELSE
                  v_dist_spct1 := 0;
               END IF;
            ELSE
               v_dist_spct1 := NULL;
            END IF;

            UPDATE giuw_witemds_dtl
               SET dist_spct = v_dist_spct,
                   dist_spct1 = v_dist_spct1,
                   ann_dist_spct = v_ann_dist_spct
             WHERE dist_no = itm.dist_no
               AND dist_seq_no = itm.dist_seq_no
               AND item_no = itm.item_no
               AND share_cd = itm_dtl.share_cd;
         END LOOP;
      END LOOP;
   END recompute_before_adjust_share;

   PROCEDURE adjust_distribution (p_dist_no giuw_wpolicyds.dist_no%TYPE)
   IS
   BEGIN
      adjust_distribution_peril_pkg.adjust_itemperil_dtl (p_dist_no);
      adjust_distribution_peril_pkg.adjust_dist (p_dist_no); --added edgar 12/20/2014
      adjust_distribution_peril_pkg.adjust_peril_dtl (p_dist_no);
      adjust_distribution_peril_pkg.adjust_item_dtl (p_dist_no);
      adjust_distribution_peril_pkg.adjust_pol_dtl (p_dist_no);
      adjust_distribution_peril_pkg.recompute_before_adjust_share (p_dist_no);
      adjust_distribution_peril_pkg.adjust_share (p_dist_no);
	  adjust_distribution_peril_pkg.rec_witemds_wpolicyds_dtls (p_dist_no); --added by robert SR 5053 01.08.16 
      adjust_distribution_peril_pkg.adjust_share_wdistfrps (p_dist_no);
   END adjust_distribution;
   
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
    /*added by procedure edgar 12/10/2014*/
   CURSOR peril1
   IS
      SELECT   dist_no, dist_seq_no, line_cd, peril_cd, share_cd,
               ROUND (NVL (dist_tsi, 0), 2) dist_tsi,
               ROUND (NVL (dist_prem, 0), 2) dist_prem,
               ROUND (NVL (ann_dist_tsi, 0), 2) ann_dist_tsi
          FROM giuw_wperilds_dtl
         WHERE dist_no = p_dist_no
      ORDER BY dist_no, dist_seq_no, line_cd, peril_cd, share_cd DESC;
    BEGIN
       FOR i IN (SELECT '1'
                   FROM giuw_wperilds_dtl
                  WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL)
       LOOP
          v_dist_spct1_exists := 'Y';
          EXIT;
       END LOOP;

       /*adjusting of TSI amounts in giuw_witemperilds_dtl*/
       FOR perl IN peril1
       LOOP
          v_share_cd1 := NULL;
          v_share_cd2 := NULL;
          v_tsi_discrep1 := 0;
          v_item_no := NULL;
          v_peril_cd := NULL;
          v_ok       := FALSE;

          FOR itmperl IN
             (SELECT   dist_no, dist_seq_no,
                       SUM (ROUND (NVL (dist_tsi, 0),
                                   2
                                  )
                           ) dist_tsi,
                       SUM (ROUND (NVL (dist_prem, 0), 2)) dist_prem,
                       SUM (ROUND (NVL ( ann_dist_tsi,
                                                0
                                               ),
                                   2
                                  )
                           ) ann_dist_tsi
                  FROM giuw_witemperilds_dtl
                 WHERE dist_no = perl.dist_no
                   AND dist_seq_no = perl.dist_seq_no
                   AND line_cd = perl.line_cd
                   AND peril_cd = perl.peril_cd
                   AND share_cd = perl.share_cd
              GROUP BY dist_no, dist_seq_no)
          LOOP
             v_tsi_discrep1 := perl.dist_tsi - itmperl.dist_tsi;

             IF v_tsi_discrep1 <> 0
             THEN
                v_share_cd1 := perl.share_cd;
             END IF;

             EXIT;
          END LOOP;

          IF v_share_cd1 IS NOT NULL
          THEN
             FOR perl2 IN (SELECT   dist_no, dist_seq_no, line_cd, peril_cd, share_cd,
                                   ROUND (NVL (dist_tsi, 0), 2) dist_tsi,
                                   ROUND (NVL (dist_prem, 0), 2) dist_prem,
                                   ROUND (NVL (ann_dist_tsi, 0), 2) ann_dist_tsi
                              FROM giuw_wperilds_dtl
                             WHERE dist_no = p_dist_no
                               AND share_cd < v_share_cd1
                               AND dist_seq_no = perl.dist_seq_no
                               AND line_cd = perl.line_cd
                               AND peril_cd = perl.peril_cd
                          ORDER BY dist_no, dist_seq_no, line_cd, peril_cd, share_cd DESC)
             LOOP
                v_share_cd2 := NULL;
                v_tsi_discrep2 := 0;

                FOR itmperl2 IN
                   (SELECT   dist_no, dist_seq_no,
                             SUM (ROUND (NVL (dist_tsi,
                                                      0
                                                     ),
                                         2
                                        )
                                 ) dist_tsi,
                             SUM (ROUND (NVL (dist_prem, 0), 2)) dist_prem,
                             SUM
                                (ROUND (NVL ( ann_dist_tsi,
                                                     0
                                                    ),
                                        2
                                       )
                                ) ann_dist_tsi
                        FROM giuw_witemperilds_dtl
                       WHERE dist_no = perl2.dist_no
                         AND dist_seq_no = perl2.dist_seq_no
                         AND share_cd = perl2.share_cd
                         AND line_cd = perl2.line_cd
                         AND peril_cd = perl2.peril_cd
                    GROUP BY dist_no, dist_seq_no)
                LOOP
                   v_tsi_discrep2 := perl2.dist_tsi - itmperl2.dist_tsi;

                   IF (    v_tsi_discrep2 <> 0
                       AND ABS (v_tsi_discrep2) >= ABS (v_tsi_discrep1)
                      )
                   THEN
                      v_share_cd2 := perl2.share_cd;
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
                   (SELECT   dist_no, dist_seq_no, peril_cd, line_cd, share_cd,
                             SUM (ROUND (NVL ( dist_tsi,
                                                      0
                                                     ),
                                         2
                                        )
                                 ) dist_tsi,
                             SUM (ROUND (NVL (dist_prem, 0), 2)) dist_prem,
                             SUM
                                (ROUND (NVL ( ann_dist_tsi,
                                                     0
                                                    ),
                                        2
                                       )
                                ) ann_dist_tsi
                        FROM giuw_witemperilds_dtl
                       WHERE dist_no = perl.dist_no
                         AND dist_seq_no = perl.dist_seq_no
                         AND line_cd = perl.line_cd
                         AND peril_cd = perl.peril_cd
                         AND share_cd < v_share_cd1
                    GROUP BY dist_no, dist_seq_no, line_cd, peril_cd, share_cd
                    ORDER BY dist_no, dist_seq_no, line_cd, peril_cd, share_cd ASC)
                LOOP
                   v_share_cd2 := NULL;

                   IF ABS (itmperl3.dist_tsi) >= ABS (v_tsi_discrep1)
                   THEN
                      v_share_cd2 := itmperl3.share_cd;
                      EXIT;
                   END IF;
                END LOOP;
             END IF;

             FOR itmperl4 IN (SELECT   dist_no, dist_seq_no, item_no, line_cd, peril_cd
                                  FROM giuw_witemperilds
                                 WHERE dist_no = perl.dist_no
                                   AND dist_seq_no = perl.dist_seq_no
                                   AND line_cd = perl.line_cd
                                   AND peril_cd = perl.peril_cd
                              ORDER BY item_no DESC, peril_cd DESC)
             LOOP
                 v_ok := FALSE;
                 FOR itmperl5 IN (SELECT   share_cd, ROUND(NVL(dist_tsi,0),2) dist_tsi
                                      FROM giuw_witemperilds_dtl
                                     WHERE dist_no = itmperl4.dist_no
                                       AND dist_seq_no = itmperl4.dist_seq_no
                                       AND item_no = itmperl4.item_no
                                       AND line_cd = itmperl4.line_cd
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
                  WHERE dist_no = perl.dist_no
                    AND dist_seq_no = perl.dist_seq_no
                    AND line_cd = perl.line_cd
                    AND item_no = v_item_no
                    AND peril_cd = v_peril_cd
                    AND share_cd = v_share_cd1;

                 UPDATE giuw_witemperilds_dtl
                    SET dist_tsi = dist_tsi - v_tsi_discrep1
                  WHERE dist_no = perl.dist_no
                    AND dist_seq_no = perl.dist_seq_no
                    AND line_cd = perl.line_cd
                    AND item_no = v_item_no
                    AND peril_cd = v_peril_cd
                    AND share_cd = v_share_cd2;
             END IF;
          END IF;
       END LOOP;

       IF v_dist_spct1_exists = 'Y'
       THEN
          --adjusting of Premium amounts in giuw_witemperilds_dtl
           FOR perl IN peril1
           LOOP
              v_share_cd1 := NULL;
              v_share_cd2 := NULL;
              v_prem_discrep1 := 0;
              v_item_no := NULL;
              v_peril_cd := NULL;
              v_ok       := FALSE;

              FOR itmperl IN
                 (SELECT   dist_no, dist_seq_no,
                           SUM (ROUND (NVL (dist_tsi, 0),
                                       2
                                      )
                               ) dist_tsi,
                           SUM (ROUND (NVL (dist_prem, 0), 2)) dist_prem,
                           SUM (ROUND (NVL ( ann_dist_tsi,
                                                    0
                                                   ),
                                       2
                                      )
                               ) ann_dist_tsi
                      FROM giuw_witemperilds_dtl
                     WHERE dist_no = perl.dist_no
                       AND dist_seq_no = perl.dist_seq_no
                       AND line_cd = perl.line_cd
                       AND peril_cd = perl.peril_cd
                       AND share_cd = perl.share_cd
                  GROUP BY dist_no, dist_seq_no)
              LOOP
                 v_prem_discrep1 := perl.dist_prem - itmperl.dist_prem;

                 IF v_prem_discrep1 <> 0
                 THEN
                    v_share_cd1 := perl.share_cd;
                 END IF;

                 EXIT;
              END LOOP;

              IF v_share_cd1 IS NOT NULL
              THEN
                 FOR perl2 IN (SELECT   dist_no, dist_seq_no, line_cd, peril_cd, share_cd,
                                       ROUND (NVL (dist_tsi, 0), 2) dist_tsi,
                                       ROUND (NVL (dist_prem, 0), 2) dist_prem,
                                       ROUND (NVL (ann_dist_tsi, 0), 2) ann_dist_tsi
                                  FROM giuw_wperilds_dtl
                                 WHERE dist_no = p_dist_no
                                   AND share_cd < v_share_cd1
                                   AND dist_seq_no = perl.dist_seq_no
                                   AND line_cd = perl.line_cd
                                   AND peril_cd = perl.peril_cd
                              ORDER BY dist_no, dist_seq_no, line_cd, peril_cd, share_cd DESC)
                 LOOP
                    v_share_cd2 := NULL;
                    v_prem_discrep2 := 0;

                    FOR itmperl2 IN
                       (SELECT   dist_no, dist_seq_no,
                                 SUM (ROUND (NVL (dist_tsi,
                                                          0
                                                         ),
                                             2
                                            )
                                     ) dist_tsi,
                                 SUM (ROUND (NVL (dist_prem, 0), 2)) dist_prem,
                                 SUM
                                    (ROUND (NVL ( ann_dist_tsi,
                                                         0
                                                        ),
                                            2
                                           )
                                    ) ann_dist_tsi
                            FROM giuw_witemperilds_dtl
                           WHERE dist_no = perl2.dist_no
                             AND dist_seq_no = perl2.dist_seq_no
                             AND line_cd = perl2.line_cd
                             AND share_cd = perl2.share_cd
                             AND peril_cd = perl2.peril_cd
                        GROUP BY dist_no, dist_seq_no)
                    LOOP
                       v_prem_discrep2 := perl2.dist_prem - itmperl2.dist_prem;

                       IF (    v_prem_discrep2 <> 0
                           AND ABS (v_prem_discrep2) >= ABS (v_prem_discrep1)
                          )
                       THEN
                          v_share_cd2 := perl2.share_cd;
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
                       (SELECT   dist_no, dist_seq_no, line_cd, peril_cd, share_cd,
                                 SUM (ROUND (NVL ( dist_tsi,
                                                          0
                                                         ),
                                             2
                                            )
                                     ) dist_tsi,
                                 SUM (ROUND (NVL (dist_prem, 0), 2)) dist_prem,
                                 SUM
                                    (ROUND (NVL ( ann_dist_tsi,
                                                         0
                                                        ),
                                            2
                                           )
                                    ) ann_dist_tsi
                            FROM giuw_witemperilds_dtl
                           WHERE dist_no = perl.dist_no
                             AND dist_seq_no = perl.dist_seq_no
                             AND line_cd = perl.line_cd
                             AND peril_cd = perl.peril_cd
                             AND share_cd < v_share_cd1
                        GROUP BY dist_no, dist_seq_no, line_cd, peril_cd, share_cd
                        ORDER BY dist_no, dist_seq_no, line_cd, peril_cd, share_cd ASC)
                    LOOP
                       v_share_cd2 := NULL;

                       IF ABS (itmperl3.dist_prem) >= ABS (v_prem_discrep1)
                       THEN
                          v_share_cd2 := itmperl3.share_cd;
                          EXIT;
                       END IF;
                    END LOOP;
                 END IF;

                 FOR itmperl4 IN (SELECT   dist_no, dist_seq_no, item_no, line_cd, peril_cd
                                      FROM giuw_witemperilds
                                     WHERE dist_no = perl.dist_no
                                       AND dist_seq_no = perl.dist_seq_no
                                       AND line_cd = perl.line_cd
                                       AND peril_cd = perl.peril_cd
                                  ORDER BY item_no DESC, peril_cd DESC)
                 LOOP
                     v_ok := FALSE;
                     FOR itmperl5 IN (SELECT   share_cd, ROUND(NVL(dist_prem,0),2) dist_prem
                                          FROM giuw_witemperilds_dtl
                                         WHERE dist_no = itmperl4.dist_no
                                           AND dist_seq_no = itmperl4.dist_seq_no
                                           AND item_no = itmperl4.item_no
                                           AND line_cd = itmperl4.line_cd
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
                      WHERE dist_no = perl.dist_no
                        AND dist_seq_no = perl.dist_seq_no
                        AND line_cd = perl.line_cd
                        AND item_no = v_item_no
                        AND peril_cd = v_peril_cd
                        AND share_cd = v_share_cd1;

                     UPDATE giuw_witemperilds_dtl
                        SET dist_prem = dist_prem - v_prem_discrep1
                      WHERE dist_no = perl.dist_no
                        AND dist_seq_no = perl.dist_seq_no
                        AND line_cd = perl.line_cd
                        AND item_no = v_item_no
                        AND peril_cd = v_peril_cd
                        AND share_cd = v_share_cd2;
                 END IF;
              END IF;
           END LOOP;
       END IF;
    END adjust_dist;   
	
     --added by robert SR 5053 01.08.16 
    PROCEDURE rec_witemds_wpolicyds_dtls (p_dist_no giuw_pol_dist.dist_no%TYPE)
    IS
       v_dist_spct       giuw_witemds_dtl.dist_spct%TYPE;
       v_dist_spct1      giuw_witemds_dtl.dist_spct1%TYPE;
       v_ann_dist_spct   giuw_witemds_dtl.ann_dist_spct%TYPE;
    BEGIN
       /*recomputes %shares of giuw_witemds_dtl when illegally distributing in GIUWS012*/
       FOR c1 IN (SELECT   dist_seq_no dist_seq_no, line_cd line_cd,
                           item_no item_no, share_cd share_cd, dist_grp dist_grp
                      FROM giuw_witemperilds_dtl
                     WHERE dist_no = p_dist_no
                  GROUP BY dist_seq_no, item_no, line_cd, share_cd, dist_grp)
       LOOP
          FOR c2 IN (SELECT SUM (DECODE (a170.peril_type, 'B', a.dist_tsi, 0)
                                ) dist_tsi,
                            SUM (a.dist_prem) dist_prem,
                            SUM (DECODE (a170.peril_type, 'B', a.ann_dist_tsi, 0)
                                ) ann_dist_tsi
                       FROM giuw_witemperilds_dtl a, giis_peril a170
                      WHERE a170.peril_cd = a.peril_cd
                        AND a170.line_cd = a.line_cd
                        AND a.dist_grp = c1.dist_grp
                        AND a.share_cd = c1.share_cd
                        AND a.line_cd = c1.line_cd
                        AND a.item_no = c1.item_no
                        AND a.dist_seq_no = c1.dist_seq_no
                        AND a.dist_no = p_dist_no)
          LOOP
             FOR c3 IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, dist_no,
                               dist_seq_no, item_no
                          FROM giuw_witemds
                         WHERE item_no = c1.item_no
                           AND dist_seq_no = c1.dist_seq_no
                           AND dist_no = p_dist_no)
             LOOP
                v_dist_spct := 0;
                v_dist_spct1 := 0;
                v_ann_dist_spct := 0;
             
                IF c3.prem_amt = 0
                THEN
                   v_dist_spct1 := 0;
                ELSE
                   v_dist_spct1 :=
                                 ROUND (((c2.dist_prem / c3.prem_amt) * 100), 9);
                END IF;

                IF c3.tsi_amt = 0
                THEN
                   FOR c4 IN (SELECT SUM (tsi_amt) tsi_amt
                                FROM giuw_witemperilds a, giis_peril b
                               WHERE a.dist_seq_no = c3.dist_seq_no
                                 AND a.item_no = c3.item_no
                                 AND a.dist_no = p_dist_no
                                 AND a.line_cd = b.line_cd
                                 AND a.peril_cd = b.peril_cd
                                 AND b.peril_type = 'A')
                   LOOP
                      IF c4.tsi_amt = 0
                      THEN
                         IF c3.prem_amt = 0
                         THEN
                            v_dist_spct := 0;
                         ELSE
                            FOR c5 IN (SELECT SUM (dist_prem) dist_prem
                                         FROM giuw_witemperilds_dtl a
                                        WHERE a.dist_seq_no = c1.dist_seq_no
                                          AND a.share_cd = c1.share_cd
                                          AND a.item_no = c3.item_no
                                          AND a.dist_no = p_dist_no)
                            LOOP
                               v_dist_spct :=
                                  ROUND (((c5.dist_prem / c3.prem_amt) * 100), 9);
                            END LOOP;
                         END IF;
                      ELSE
                         FOR c5 IN (SELECT SUM (dist_tsi) dist_tsi
                                      FROM giuw_witemperilds_dtl a, giis_peril b
                                     WHERE a.dist_seq_no = c1.dist_seq_no
                                       AND a.share_cd = c1.share_cd
                                       AND a.item_no = c3.item_no
                                       AND a.dist_no = p_dist_no
                                       AND a.line_cd = b.line_cd
                                       AND a.peril_cd = b.peril_cd
                                       AND b.peril_type = 'A')
                         LOOP
                            v_dist_spct :=
                                   ROUND (((c5.dist_tsi / c4.tsi_amt) * 100), 9);
                         END LOOP;
                      END IF;
                   END LOOP;

                   IF v_dist_spct1 = 0
                   THEN
                      v_dist_spct1 := v_dist_spct;
                   END IF;

                   v_ann_dist_spct := v_dist_spct;

                   UPDATE giuw_witemds_dtl
                      SET dist_spct = v_dist_spct,
                          dist_spct1 = v_dist_spct1,
                          ann_dist_spct = v_ann_dist_spct
                    WHERE dist_no = c3.dist_no
                      AND dist_seq_no = c3.dist_seq_no
                      AND item_no = c3.item_no
                      AND line_cd = c1.line_cd
                      AND share_cd = c1.share_cd;
                END IF;
             END LOOP;

             EXIT;
          END LOOP;
       END LOOP;
       
       /*recomputes %shares of giuw_wpolicyds_dtl when illegally distributing in GIUWS012*/
       FOR d1 IN (SELECT   SUM (dist_tsi) dist_tsi, SUM (dist_prem) dist_prem,
                           SUM (ann_dist_tsi) ann_dist_tsi,
                           dist_seq_no dist_seq_no, line_cd line_cd,
                           share_cd share_cd, dist_grp dist_grp
                      FROM giuw_witemds_dtl
                     WHERE dist_no = p_dist_no
                  GROUP BY dist_seq_no, line_cd, share_cd, dist_grp)
       LOOP
          FOR d2 IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, dist_no, dist_seq_no
                       FROM giuw_wpolicyds
                      WHERE dist_seq_no = d1.dist_seq_no AND dist_no = p_dist_no)
          LOOP
             v_dist_spct := 0;
             v_dist_spct1 := 0;
             v_ann_dist_spct := 0;
             
             IF d2.prem_amt = 0
             THEN
                v_dist_spct1 := 0;
             ELSE
                v_dist_spct1 := ROUND (((d1.dist_prem / d2.prem_amt) * 100), 9);
             END IF;

             IF d2.tsi_amt = 0
             THEN
                FOR d3 IN (SELECT SUM (tsi_amt) tsi_amt, SUM (prem_amt) prem_amt
                             FROM giuw_wperilds a, giis_peril b
                            WHERE a.dist_seq_no = d2.dist_seq_no
                              AND a.dist_no = p_dist_no
                              AND a.line_cd = b.line_cd
                              AND a.peril_cd = b.peril_cd
                              AND b.peril_type = 'A')
                LOOP
                   IF d3.tsi_amt = 0
                   THEN
                      IF d2.prem_amt = 0
                      THEN
                         v_dist_spct := 0;
                      ELSE
                         FOR d4 IN (SELECT SUM (dist_prem) dist_prem
                                      FROM giuw_wperilds_dtl a
                                     WHERE a.dist_seq_no = d2.dist_seq_no
                                       AND a.dist_no = p_dist_no
                                       AND a.share_cd = d1.share_cd)
                         LOOP
                            v_dist_spct :=
                                 ROUND (((d4.dist_prem / d2.prem_amt) * 100), 9);
                         END LOOP;
                      END IF;
                   ELSE
                      FOR d4 IN (SELECT SUM (dist_tsi) dist_tsi, SUM (dist_prem)
                                   FROM giuw_wperilds_dtl a, giis_peril b
                                  WHERE a.dist_seq_no = d2.dist_seq_no
                                    AND a.dist_no = p_dist_no
                                    AND a.share_cd = d1.share_cd
                                    AND a.line_cd = b.line_cd
                                    AND a.peril_cd = b.peril_cd
                                    AND b.peril_type = 'A')
                      LOOP
                         v_dist_spct :=
                                   ROUND (((d4.dist_tsi / d3.tsi_amt) * 100), 9);
                      END LOOP;
                   END IF;
                END LOOP;

                IF v_dist_spct1 = 0
                THEN
                   v_dist_spct1 := v_dist_spct;
                END IF;

                v_ann_dist_spct := v_dist_spct;

                UPDATE giuw_wpolicyds_dtl
                   SET dist_spct = v_dist_spct,
                       dist_spct1 = v_dist_spct1,
                       ann_dist_spct = v_ann_dist_spct
                 WHERE dist_no = d2.dist_no
                   AND dist_seq_no = d2.dist_seq_no
                   AND line_cd = d1.line_cd
                   AND share_cd = d1.share_cd;
             END IF;
          END LOOP;
       END LOOP;
    END;
END adjust_distribution_peril_pkg;
/


