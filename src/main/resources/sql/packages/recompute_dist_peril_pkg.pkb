CREATE OR REPLACE PACKAGE BODY CPI.recompute_dist_peril_pkg
AS
   PROCEDURE recompute_dtl_tables (p_dist_no giuw_perilds_dtl.dist_no%TYPE)
   IS
      v_dist_tsi           giuw_perilds_dtl.dist_tsi%TYPE;
      v_dist_prem          giuw_perilds_dtl.dist_prem%TYPE;
      v_ann_dist_tsi       giuw_perilds_dtl.ann_dist_tsi%TYPE;
      v_dist_spct          giuw_witemds_dtl.dist_spct%TYPE;
      v_dist_spct1         giuw_witemds_dtl.dist_spct1%TYPE;
      v_ann_dist_spct      giuw_witemds_dtl.ann_dist_spct%TYPE;
      v_allied_dist_prem   giuw_witemds_dtl.dist_prem%TYPE;
   BEGIN
      DELETE FROM giuw_witemperilds_dtl
            WHERE dist_no = p_dist_no;

      DELETE FROM giuw_witemds_dtl
            WHERE dist_no = p_dist_no;

      DELETE FROM giuw_wpolicyds_dtl
            WHERE dist_no = p_dist_no;

      --based on populate procedure on GIUWS003

      /*RECOMPUTES GIUW_WITEMPERILDS_DTL DISTRIBUTION TABLE*/
      FOR c1 IN (SELECT dist_spct, ann_dist_spct, dist_grp, share_cd,
                        line_cd, dist_seq_no, peril_cd, dist_spct1
                   FROM giuw_wperilds_dtl
                  WHERE dist_no = p_dist_no)
      LOOP
         FOR c2 IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, dist_no,
                           dist_seq_no, item_no, line_cd, peril_cd
                      FROM giuw_witemperilds
                     WHERE peril_cd = c1.peril_cd
                       AND line_cd = c1.line_cd
                       AND dist_seq_no = c1.dist_seq_no
                       AND dist_no = p_dist_no)
         LOOP
            v_dist_tsi := ROUND (c1.dist_spct / 100 * c2.tsi_amt, 2);

            IF c1.dist_spct1 IS NOT NULL
            THEN
               v_dist_prem := ROUND (c1.dist_spct1 / 100 * c2.prem_amt, 2);
            ELSE
               v_dist_prem := ROUND (c1.dist_spct / 100 * c2.prem_amt, 2);
            END IF;

            v_ann_dist_tsi :=
                            ROUND (c1.ann_dist_spct / 100 * c2.ann_tsi_amt, 2);

            INSERT INTO giuw_witemperilds_dtl
                        (dist_no, dist_seq_no, item_no, line_cd,
                         peril_cd, share_cd, dist_spct, dist_tsi,
                         dist_prem, ann_dist_spct, ann_dist_tsi,
                         dist_grp, dist_spct1
                        )
                 VALUES (c2.dist_no, c2.dist_seq_no, c2.item_no, c2.line_cd,
                         c2.peril_cd, c1.share_cd, c1.dist_spct, v_dist_tsi,
                         v_dist_prem, c1.ann_dist_spct, v_ann_dist_tsi,
                         c1.dist_grp, c1.dist_spct1
                        );
         END LOOP;
      END LOOP;

      /*RECOMPUTES GIUW_WITEMDS_DTL DISTRIBUTION TABLE*/
      FOR c3 IN (SELECT   dist_seq_no dist_seq_no, line_cd line_cd,
                          item_no item_no, share_cd share_cd,
                          dist_grp dist_grp, SUM (dist_spct1) dist_spct1
                     FROM giuw_witemperilds_dtl
                    WHERE dist_no = p_dist_no
                 GROUP BY dist_seq_no, item_no, line_cd, share_cd, dist_grp)
      LOOP
         FOR c4 IN (SELECT SUM (DECODE (a170.peril_type, 'B', a.dist_tsi, 0)
                               ) dist_tsi,
                           SUM (a.dist_prem) dist_prem,
                           SUM (DECODE (a170.peril_type,
                                        'B', a.ann_dist_tsi,
                                        0
                                       )
                               ) ann_dist_tsi
                      FROM giuw_witemperilds_dtl a, giis_peril a170
                     WHERE a170.peril_cd = a.peril_cd
                       AND a170.line_cd = a.line_cd
                       AND a.dist_grp = c3.dist_grp
                       AND a.share_cd = c3.share_cd
                       AND a.line_cd = c3.line_cd
                       AND a.item_no = c3.item_no
                       AND a.dist_seq_no = c3.dist_seq_no
                       AND a.dist_no = p_dist_no)
         LOOP
            FOR c5 IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, dist_no,
                              dist_seq_no, item_no
                         FROM giuw_witemds
                        WHERE item_no = c3.item_no
                          AND dist_seq_no = c3.dist_seq_no
                          AND dist_no = p_dist_no)
            LOOP
               v_dist_spct1 := NULL;

               IF c5.tsi_amt != 0
               THEN
                  v_dist_spct := ROUND (c4.dist_tsi / c5.tsi_amt, 9) * 100;

                  IF c3.dist_spct1 IS NOT NULL
                  THEN
                     v_dist_spct1 :=
                                  ROUND (c4.dist_prem / c5.prem_amt, 9)
                                  * 100;
                  END IF;
               ELSIF c5.prem_amt != 0
               THEN
                  IF c3.dist_spct1 IS NOT NULL
                  THEN
                     v_dist_spct1 :=
                                  ROUND (c4.dist_prem / c5.prem_amt, 9)
                                  * 100;
                     v_dist_spct := 0;
                  ELSE
                     v_dist_spct :=
                                  ROUND (c4.dist_prem / c5.prem_amt, 9)
                                  * 100;
                  END IF;
               ELSE
                  v_dist_spct := 0;
               END IF;

               IF c5.ann_tsi_amt != 0
               THEN
                  v_ann_dist_spct :=
                            ROUND (c4.ann_dist_tsi / c5.ann_tsi_amt, 9)
                            * 100;
               ELSE
                  v_ann_dist_spct := 0;
               END IF;

               INSERT INTO giuw_witemds_dtl
                           (dist_no, dist_seq_no, item_no,
                            line_cd, share_cd, dist_spct,
                            dist_tsi, dist_prem, ann_dist_spct,
                            ann_dist_tsi, dist_grp, dist_spct1
                           )
                    VALUES (c5.dist_no, c5.dist_seq_no, c5.item_no,
                            c3.line_cd, c3.share_cd, v_dist_spct,
                            c4.dist_tsi, c4.dist_prem, v_ann_dist_spct,
                            c4.ann_dist_tsi, c3.dist_grp, v_dist_spct1
                           );
            END LOOP;

            EXIT;
         END LOOP;
      END LOOP;

      /*RECOMPUTES GIUW_WPOLICYDS_DTL DISTRIBUTION TABLE*/
      FOR c6 IN (SELECT   SUM (dist_tsi) dist_tsi, SUM (dist_prem) dist_prem,
                          SUM (ann_dist_tsi) ann_dist_tsi,
                          dist_seq_no dist_seq_no, line_cd line_cd,
                          share_cd share_cd, dist_grp dist_grp,
                          SUM (dist_spct1) dist_spct1
                     FROM giuw_witemds_dtl
                    WHERE dist_no = p_dist_no
                 GROUP BY dist_seq_no, line_cd, share_cd, dist_grp)
      LOOP
         FOR c7 IN (SELECT tsi_amt, prem_amt, ann_tsi_amt, dist_no,
                           dist_seq_no
                      FROM giuw_wpolicyds
                     WHERE dist_seq_no = c6.dist_seq_no
                       AND dist_no = p_dist_no)
         LOOP
            v_dist_spct1 := NULL;

            IF c7.tsi_amt != 0
            THEN
               v_dist_spct := ROUND (c6.dist_tsi / c7.tsi_amt, 9) * 100;

               IF c6.dist_spct1 IS NOT NULL
               THEN
                  v_dist_spct1 := ROUND (c6.dist_prem / c7.prem_amt, 9)
                                  * 100;
               END IF;
            ELSIF c7.prem_amt != 0
            THEN
               IF c6.dist_spct1 IS NOT NULL
               THEN
                  v_dist_spct1 := ROUND (c6.dist_prem / c7.prem_amt, 9)
                                  * 100;
                  v_dist_spct := 0;
               ELSE
                  v_dist_spct := ROUND (c6.dist_prem / c7.prem_amt, 9) * 100;
               END IF;
            ELSE
               v_dist_spct := 0;
            END IF;

            IF c7.ann_tsi_amt != 0
            THEN
               v_ann_dist_spct :=
                            ROUND (c6.ann_dist_tsi / c7.ann_tsi_amt, 9)
                            * 100;
            ELSE
               v_ann_dist_spct := 0;
            END IF;

            INSERT INTO giuw_wpolicyds_dtl
                        (dist_no, dist_seq_no, line_cd, share_cd,
                         dist_spct, dist_tsi, dist_prem,
                         ann_dist_spct, ann_dist_tsi, dist_grp,
                         dist_spct1
                        )
                 VALUES (c7.dist_no, c7.dist_seq_no, c6.line_cd, c6.share_cd,
                         v_dist_spct, c6.dist_tsi, c6.dist_prem,
                         v_ann_dist_spct, c6.ann_dist_tsi, c6.dist_grp,
                         v_dist_spct1
                        );
         END LOOP;
      END LOOP;
   END recompute_dtl_tables;

   PROCEDURE recompute_dtl_dist_prem (p_dist_no giuw_perilds_dtl.dist_no%TYPE)
   IS
    v_exist     VARCHAR2(1) := 'N';
   BEGIN
        FOR prem IN (SELECT dist_no, dist_seq_no, peril_cd, line_cd,
                                         share_cd, dist_spct
                                    FROM giuw_wperilds_dtl
                                   WHERE dist_no = p_dist_no
                                     AND dist_spct <> dist_spct1)
        LOOP
              v_exist := 'Y';
              /*RECOMPUTES DIST_PREM IN giuw_wperilds_dtl*/
              FOR perl IN (SELECT dist_no, dist_seq_no, peril_cd, line_cd, prem_amt
                             FROM giuw_wperilds
                            WHERE dist_no = p_dist_no)
              LOOP
                 FOR perl_dtl IN (SELECT dist_no, dist_seq_no, peril_cd, line_cd,
                                         share_cd, dist_spct
                                    FROM giuw_wperilds_dtl
                                   WHERE dist_no = perl.dist_no
                                     AND dist_seq_no = perl.dist_seq_no
                                     AND peril_cd = perl.peril_cd
                                     AND line_cd = perl.line_cd)
                 LOOP
                    UPDATE giuw_wperilds_dtl
                       SET dist_spct1 = NULL,
                           dist_prem =
                                 ROUND ((perl_dtl.dist_spct / 100) * perl.prem_amt, 2)
                     WHERE dist_no = perl_dtl.dist_no
                       AND dist_seq_no = perl_dtl.dist_seq_no
                       AND peril_cd = perl_dtl.peril_cd
                       AND line_cd = perl_dtl.line_cd
                       AND share_cd = perl_dtl.share_cd;
                 END LOOP;
              END LOOP;

              /*RECOMPUTES DIST_PREM IN giuw_witemperilds_dtl*/
              FOR itmperl IN (SELECT dist_no, dist_seq_no, item_no, peril_cd, line_cd,
                                     prem_amt
                                FROM giuw_witemperilds
                               WHERE dist_no = p_dist_no)
              LOOP
                 FOR itmperl_dtl IN (SELECT dist_no, dist_seq_no, item_no, peril_cd,
                                            line_cd, share_cd, dist_spct
                                       FROM giuw_witemperilds_dtl
                                      WHERE dist_no = itmperl.dist_no
                                        AND dist_seq_no = itmperl.dist_seq_no
                                        AND item_no = itmperl.item_no
                                        AND peril_cd = itmperl.peril_cd
                                        AND line_cd = itmperl.line_cd)
                 LOOP
                    UPDATE giuw_witemperilds_dtl
                       SET dist_spct1 = NULL,
                           dist_prem =
                              ROUND ((itmperl_dtl.dist_spct / 100) * itmperl.prem_amt,
                                     2
                                    )
                     WHERE dist_no = itmperl_dtl.dist_no
                       AND dist_seq_no = itmperl_dtl.dist_seq_no
                       AND peril_cd = itmperl_dtl.peril_cd
                       AND item_no = itmperl_dtl.item_no
                       AND line_cd = itmperl_dtl.line_cd
                       AND share_cd = itmperl_dtl.share_cd;
                 END LOOP;
              END LOOP;

              /*RECOMPUTES DIST_PREM IN giuw_witemds_dtl*/
              FOR itm IN (SELECT dist_no, dist_seq_no, item_no, prem_amt
                            FROM giuw_witemds
                           WHERE dist_no = p_dist_no)
              LOOP
                 FOR itm_dtl IN (SELECT dist_no, dist_seq_no, item_no, share_cd,
                                        dist_spct
                                   FROM giuw_witemds_dtl
                                  WHERE dist_no = itm.dist_no
                                    AND dist_seq_no = itm.dist_seq_no
                                    AND item_no = itm.item_no)
                 LOOP
                    UPDATE giuw_witemds_dtl
                       SET dist_spct1 = NULL,
                           dist_prem =
                                   ROUND ((itm_dtl.dist_spct / 100) * itm.prem_amt, 2)
                     WHERE dist_no = itm_dtl.dist_no
                       AND dist_seq_no = itm_dtl.dist_seq_no
                       AND item_no = itm_dtl.item_no
                       AND share_cd = itm_dtl.share_cd;
                 END LOOP;
              END LOOP;

              /*RECOMPUTES DIST_PREM IN giuw_wpolicyds_dtl*/
              FOR pol IN (SELECT dist_no, dist_seq_no, prem_amt
                            FROM giuw_wpolicyds
                           WHERE dist_no = p_dist_no)
              LOOP
                 FOR pol_dtl IN (SELECT dist_no, dist_seq_no, share_cd, dist_spct
                                   FROM giuw_wpolicyds_dtl
                                  WHERE dist_no = pol.dist_no
                                    AND dist_seq_no = pol.dist_seq_no)
                 LOOP
                    UPDATE giuw_wpolicyds_dtl
                       SET dist_spct1 = NULL,
                           dist_prem =
                                   ROUND ((pol_dtl.dist_spct / 100) * pol.prem_amt, 2)
                     WHERE dist_no = pol_dtl.dist_no
                       AND dist_seq_no = pol_dtl.dist_seq_no
                       AND share_cd = pol_dtl.share_cd;
                 END LOOP;
              END LOOP;
              
              EXIT;
        END LOOP;
        
        IF v_exist = 'N' THEN
                UPDATE giuw_wperilds_dtl
                   SET dist_spct1 = NULL
                 WHERE dist_no = p_dist_no;
                     
                UPDATE giuw_witemperilds_dtl
                   SET dist_spct1 = NULL
                 WHERE dist_no = p_dist_no;
                     
                UPDATE giuw_witemds_dtl
                   SET dist_spct1 = NULL
                 WHERE dist_no = p_dist_no;
                     
                UPDATE giuw_wpolicyds_dtl
                   SET dist_spct1 = NULL
                 WHERE dist_no = p_dist_no;
        END IF;
      adjust_distribution_peril_pkg.ADJUST_DISTRIBUTION(p_dist_no);
   END recompute_dtl_dist_prem;

   PROCEDURE update_dist_spct1 (p_dist_no giuw_perilds_dtl.dist_no%TYPE)
   IS
   BEGIN
      FOR i IN (SELECT dist_no, dist_seq_no, peril_cd, line_cd, share_cd,
                       dist_spct
                  FROM giuw_wperilds_dtl
                 WHERE dist_no = p_dist_no)
      LOOP
         UPDATE giuw_wperilds_dtl
            SET dist_spct1 = NVL(dist_spct1,i.dist_spct)
          WHERE dist_no = i.dist_no
            AND dist_seq_no = i.dist_seq_no
            AND peril_cd = i.peril_cd
            AND line_cd = i.line_cd
            AND share_cd = i.share_cd;
      END LOOP;
      
      FOR i IN (SELECT dist_no, dist_seq_no, item_no, peril_cd, line_cd, share_cd,
                       dist_spct
                  FROM giuw_witemperilds_dtl
                 WHERE dist_no = p_dist_no)
      LOOP
         UPDATE giuw_witemperilds_dtl
            SET dist_spct1 = NVL(dist_spct1,i.dist_spct)
          WHERE dist_no = i.dist_no
            AND dist_seq_no = i.dist_seq_no
            AND item_no = i.item_no
            AND peril_cd = i.peril_cd
            AND line_cd = i.line_cd
            AND share_cd = i.share_cd;
      END LOOP;
      
      FOR i IN (SELECT dist_no, dist_seq_no, item_no, line_cd, share_cd,
                       dist_spct
                  FROM giuw_witemds_dtl
                 WHERE dist_no = p_dist_no)
      LOOP
         UPDATE giuw_witemds_dtl
            SET dist_spct1 = NVL(dist_spct1,i.dist_spct)
          WHERE dist_no = i.dist_no
            AND dist_seq_no = i.dist_seq_no
            AND item_no = i.item_no
            AND line_cd = i.line_cd
            AND share_cd = i.share_cd;
      END LOOP;
      
            FOR i IN (SELECT dist_no, dist_seq_no, line_cd, share_cd,
                       dist_spct
                  FROM giuw_wpolicyds_dtl
                 WHERE dist_no = p_dist_no)
      LOOP
         UPDATE giuw_wpolicyds_dtl
            SET dist_spct1 = NVL(dist_spct1,i.dist_spct)
          WHERE dist_no = i.dist_no
            AND dist_seq_no = i.dist_seq_no
            AND line_cd = i.line_cd
            AND share_cd = i.share_cd;
      END LOOP;
   END update_dist_spct1;
END recompute_dist_peril_pkg;
/


