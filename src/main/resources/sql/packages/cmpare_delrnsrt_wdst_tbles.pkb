CREATE OR REPLACE PACKAGE BODY CPI.cmpare_delrnsrt_wdst_tbles
AS
   PROCEDURE wpolicyds_vs_wpolicyds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      msg1   VARCHAR2 (100);
      msg2   VARCHAR2 (2);
      msg3   BOOLEAN;
   BEGIN
      msg4 := NULL;
      cmpare_amts_wrking_tbls.wpolicyds_vs_wpolicyds_dtl (p_dist_no,
                                                          msg1,
                                                          msg2,
                                                          msg3
                                                         );

      IF msg1 IS NOT NULL AND msg2 IS NOT NULL AND msg3 IS NOT NULL
      THEN
         cmpare_delrnsrt_wdst_tbles.del_rnsrt_wdst_tbls (p_dist_no);
         msg4 := '1';
      END IF;
   END;

   PROCEDURE wperilds_vs_wperilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      msg1   VARCHAR2 (100);
      msg2   VARCHAR2 (2);
      msg3   BOOLEAN;
   BEGIN
      msg4 := NULL;
      cmpare_amts_wrking_tbls.wperilds_vs_wperilds_dtl (p_dist_no,
                                                        msg1,
                                                        msg2,
                                                        msg3
                                                       );

      IF msg1 IS NOT NULL AND msg2 IS NOT NULL AND msg3 IS NOT NULL
      THEN
         cmpare_delrnsrt_wdst_tbles.del_rnsrt_wdst_tbls (p_dist_no);
         msg4 := '1';
      END IF;
   END;

   PROCEDURE witemds_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      msg1   VARCHAR2 (100);
      msg2   VARCHAR2 (2);
      msg3   BOOLEAN;
   BEGIN
      msg4 := NULL;
      cmpare_amts_wrking_tbls.witemds_vs_witemds_dtl (p_dist_no,
                                                      msg1,
                                                      msg2,
                                                      msg3
                                                     );

      IF msg1 IS NOT NULL AND msg2 IS NOT NULL AND msg3 IS NOT NULL
      THEN
         cmpare_delrnsrt_wdst_tbles.del_rnsrt_wdst_tbls (p_dist_no);
         msg4 := '1';
      END IF;
   END;

   PROCEDURE witmprilds_vs_witmprilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      msg1   VARCHAR2 (100);
      msg2   VARCHAR2 (2);
      msg3   BOOLEAN;
   BEGIN
      msg4 := NULL;
      cmpare_amts_wrking_tbls.witmprilds_vs_witmprilds_dtl (p_dist_no,
                                                            msg1,
                                                            msg2,
                                                            msg3
                                                           );

      IF msg1 IS NOT NULL AND msg2 IS NOT NULL AND msg3 IS NOT NULL
      THEN
         cmpare_delrnsrt_wdst_tbles.del_rnsrt_wdst_tbls (p_dist_no);
         msg4 := '1';
      END IF;
   END;

   PROCEDURE witmprlds_dtl_vs_wplicyds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      msg1   VARCHAR2 (100);
      msg2   VARCHAR2 (2);
      msg3   BOOLEAN;
   BEGIN
      msg4 := NULL;
      cmpare_amts_wrking_tbls.witmprlds_dtl_vs_wplicyds_dtl (p_dist_no,
                                                             msg1,
                                                             msg2,
                                                             msg3
                                                            );

      IF msg1 IS NOT NULL AND msg2 IS NOT NULL AND msg3 IS NOT NULL
      THEN
         cmpare_delrnsrt_wdst_tbles.del_rnsrt_wdst_tbls (p_dist_no);
         msg4 := '1';
      END IF;
   END;

   PROCEDURE witmprilds_dtl_vs_wprilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      msg1   VARCHAR2 (100);
      msg2   VARCHAR2 (2);
      msg3   BOOLEAN;
   BEGIN
      msg4 := NULL;
      cmpare_amts_wrking_tbls.witmprilds_dtl_vs_wprilds_dtl (p_dist_no,
                                                             msg1,
                                                             msg2,
                                                             msg3
                                                            );

      IF msg1 IS NOT NULL AND msg2 IS NOT NULL AND msg3 IS NOT NULL
      THEN
         cmpare_delrnsrt_wdst_tbles.del_rnsrt_wdst_tbls (p_dist_no);
         msg4 := '1';
      END IF;
   END;

   PROCEDURE witmprilds_dtl_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      msg1   VARCHAR2 (100);
      msg2   VARCHAR2 (2);
      msg3   BOOLEAN;
   BEGIN
      msg4 := NULL;
      cmpare_amts_wrking_tbls.witmprilds_dtl_vs_witemds_dtl (p_dist_no,
                                                             msg1,
                                                             msg2,
                                                             msg3
                                                            );

      IF msg1 IS NOT NULL AND msg2 IS NOT NULL AND msg3 IS NOT NULL
      THEN
         cmpare_delrnsrt_wdst_tbles.del_rnsrt_wdst_tbls (p_dist_no);
         msg4 := '1';
      END IF;
   END;

   PROCEDURE wpolicyds_dtl_vs_witemds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      msg1   VARCHAR2 (100);
      msg2   VARCHAR2 (2);
      msg3   BOOLEAN;
   BEGIN
      msg4 := NULL;
      cmpare_amts_wrking_tbls.wpolicyds_dtl_vs_witemds_dtl (p_dist_no,
                                                            msg1,
                                                            msg2,
                                                            msg3
                                                           );

      IF msg1 IS NOT NULL AND msg2 IS NOT NULL AND msg3 IS NOT NULL
      THEN
         cmpare_delrnsrt_wdst_tbles.del_rnsrt_wdst_tbls (p_dist_no);
         msg4 := '1';
      END IF;
   END;

   PROCEDURE wpolcyds_dtl_vs_wperilds_dtl (
      p_dist_no   IN       giuw_pol_dist.dist_no%TYPE,
      msg4        OUT      VARCHAR2
   )
   IS
      msg1   VARCHAR2 (100);
      msg2   VARCHAR2 (2);
      msg3   BOOLEAN;
   BEGIN
      msg4 := NULL;
      cmpare_amts_wrking_tbls.wpolcyds_dtl_vs_wperilds_dtl (p_dist_no,
                                                            msg1,
                                                            msg2,
                                                            msg3
                                                           );

      IF msg1 IS NOT NULL AND msg2 IS NOT NULL AND msg3 IS NOT NULL
      THEN
         cmpare_delrnsrt_wdst_tbles.del_rnsrt_wdst_tbls (p_dist_no);
         msg4 := '1';
      END IF;
   END;

   PROCEDURE del_rnsrt_wdst_tbls (p_dist_no IN giuw_pol_dist.dist_no%TYPE)
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
         FOR rec4 IN (SELECT f.line_cd, f.dist_no, f.dist_seq_no, f.share_cd,
                             (f.dist_spct / 100) dist_spct, f.dist_grp,
                             (f.dist_spct1 / 100) dist_spct1
                        FROM giuw_wpolicyds_dtl f
                       WHERE dist_no = p_dist_no
                         AND dist_seq_no = rec3.dist_seq_no)
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
                              rec5.prem_amt
                            * NVL (rec4.dist_spct1, rec4.dist_spct),
                            rec4.dist_spct * 100,
                            rec5.ann_tsi_amt * rec4.dist_spct,
                            rec4.dist_grp, ROUND (rec4.dist_spct1 * 100, 9)
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
                              rec6.prem_amt
                            * NVL (rec4.dist_spct1, rec4.dist_spct),
                            rec4.dist_spct * 100,
                            rec6.ann_tsi_amt * rec4.dist_spct,
                            rec4.dist_grp, ROUND (rec4.dist_spct1 * 100, 9)
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
                              rec7.prem_amt
                            * NVL (rec4.dist_spct1, rec4.dist_spct),
                            rec4.dist_spct * 100,
                            rec7.ann_tsi_amt * rec4.dist_spct,
                            rec4.dist_grp, ROUND (rec4.dist_spct1 * 100, 9)
                           );
            END LOOP;
         END LOOP;
      END LOOP;
   END;
END cmpare_delrnsrt_wdst_tbles;
/


