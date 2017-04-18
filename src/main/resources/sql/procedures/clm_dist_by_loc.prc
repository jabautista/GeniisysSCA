DROP PROCEDURE CPI.CLM_DIST_BY_LOC;

CREATE OR REPLACE PROCEDURE CPI.clm_dist_by_loc (
   v_claim_id            gicl_clm_res_hist.claim_id%TYPE,
   v_clm_res_hist_id     gicl_clm_res_hist.clm_res_hist_id%TYPE,
   v_eff_date            DATE,
   v_expiry_date         DATE,
   v_distribution_date   DATE,
   v_location_cd         gipi_casualty_item.location_cd%TYPE,
   v_nbt_cat_cd          gicl_claims.catastrophic_cd%TYPE
)
IS
--Cursor for item/peril loss amount
   CURSOR cur_clm_res
   IS
      SELECT        claim_id, clm_res_hist_id, hist_seq_no, item_no,
                    peril_cd, loss_reserve, expense_reserve, convert_rate,
                    grouped_item_no
               FROM gicl_clm_res_hist
              WHERE claim_id = v_claim_id
                AND clm_res_hist_id = v_clm_res_hist_id
      FOR UPDATE OF dist_sw;

--Cursor for peril distribution in underwriting table.
   CURSOR cur_facul (
      v_peril_cd   giri_ri_dist_item_v.peril_cd%TYPE,
      v_item_no    giri_ri_dist_item_v.item_no%TYPE
   )
   IS
      SELECT   a.line_cd, d.share_cd, f.share_type, f.trty_yy, f.prtfolio_sw,
               f.acct_trty_type, SUM (d.dist_tsi) ann_dist_tsi, f.expiry_date,
               g.loss_date
          FROM gipi_polbasic a,
               gipi_item b,
               giuw_pol_dist c,
               giuw_itemperilds_dtl d,
               giis_dist_share f,
               gicl_claims g
         WHERE f.share_cd = d.share_cd
           AND f.line_cd = d.line_cd
           AND d.peril_cd = v_peril_cd
           AND d.item_no = v_item_no
           AND d.item_no = b.item_no
           AND d.dist_no = c.dist_no
           AND f.share_type = giacp.v ('FACUL_SHARE_TYPE')
           AND c.dist_flag = giisp.v ('DISTRIBUTED')
           AND c.policy_id = b.policy_id
           AND TRUNC (DECODE (TRUNC (c.eff_date),
                              TRUNC (a.eff_date), DECODE
                                                        (TRUNC (a.eff_date),
                                                         TRUNC (a.incept_date), v_eff_date,
                                                         a.eff_date
                                                        ),
                              c.eff_date
                             )
                     ) <= g.loss_date
           AND TRUNC (DECODE (TRUNC (c.expiry_date),
                              TRUNC (a.expiry_date), DECODE
                                                    (NVL (a.endt_expiry_date,
                                                          a.expiry_date
                                                         ),
                                                     a.expiry_date, v_expiry_date,
                                                     a.endt_expiry_date
                                                    ),
                              c.expiry_date
                             )
                     ) >= g.loss_date
           AND b.policy_id = a.policy_id
           AND a.pol_flag IN ('1', '2', '3', '4', 'X')  --kenneth SR 4855 100715
           AND a.line_cd = g.line_cd
           AND a.subline_cd = g.subline_cd
           AND a.iss_cd = g.pol_iss_cd
           AND a.issue_yy = g.issue_yy
           AND a.pol_seq_no = g.pol_seq_no
           AND a.renew_no = g.renew_no
           AND g.claim_id = v_claim_id
      GROUP BY a.line_cd,
               a.subline_cd,
               a.iss_cd,
               a.issue_yy,
               a.pol_seq_no,
               a.renew_no,
               d.share_cd,
               f.share_type,
               f.trty_yy,
               f.acct_trty_type,
               d.item_no,
               d.peril_cd,
               f.prtfolio_sw,
               f.expiry_date,
               g.loss_date;

   CURSOR cur_dist (
      v_location_cd   gipi_casualty_item.location_cd%TYPE,
      v_loss_date     DATE
   )
   IS
      SELECT   d.share_cd, f.share_type, f.trty_yy, f.acct_trty_type,
               f.prtfolio_sw, v_location_cd, SUM (d.dist_tsi) ann_dist_tsi,
               f.expiry_date
          FROM gipi_polbasic a,
               gipi_item b,
               giis_peril b3,
               giuw_pol_dist c,
               giuw_itemperilds_dtl d,
               giis_dist_share f
         WHERE f.share_cd = d.share_cd
           AND b3.line_cd = a.line_cd
           AND b3.peril_cd = d.peril_cd
           AND b3.peril_type = 'B'
           AND f.line_cd = d.line_cd
           AND d.item_no = b.item_no
           AND d.dist_no = c.dist_no
           AND c.dist_flag = giisp.v ('DISTRIBUTED')
           AND c.policy_id = b.policy_id
           AND TRUNC (a.eff_date) <= TRUNC (v_loss_date)
           AND TRUNC (a.expiry_date) >= TRUNC (v_loss_date)
           AND b.policy_id = a.policy_id
           AND a.pol_flag IN ('1', '2', '3', '4', 'X')  --kenneth SR 4855 100715
           AND EXISTS (
                  SELECT 1
                    FROM gipi_polbasic sub_a,
                         gipi_item sub_b,
                         gipi_casualty_item sub_c
                   WHERE sub_a.line_cd = a.line_cd
                     AND sub_a.subline_cd = a.subline_cd
                     AND sub_a.iss_cd = a.iss_cd
                     AND sub_a.issue_yy = a.issue_yy
                     AND sub_a.pol_seq_no = a.pol_seq_no
                     AND sub_a.renew_no = a.renew_no
                     AND sub_b.item_no = d.item_no
                     AND TRUNC (sub_a.eff_date) <= TRUNC (v_loss_date)
                     AND TRUNC (sub_a.expiry_date) >= TRUNC (v_loss_date)
                     AND sub_c.location_cd = v_location_cd
                     AND sub_a.policy_id = sub_b.policy_id
                     AND sub_b.policy_id = sub_c.policy_id
                     AND sub_b.item_no = sub_c.item_no)
      GROUP BY d.share_cd,
               f.share_type,
               f.trty_yy,
               f.acct_trty_type,
               f.prtfolio_sw,
               v_location_cd,
               f.expiry_date;

--Cursor for peril distribution in treaty table.
   CURSOR cur_trty (
      v_line_cd    giis_line.line_cd%TYPE,
      v_share_cd   giis_dist_share.share_cd%TYPE,
      v_trty_yy    giis_dist_share.trty_yy%TYPE
   )
   IS
      SELECT ri_cd, trty_shr_pct, prnt_ri_cd
        FROM giis_trty_panel
       WHERE line_cd = v_line_cd
         AND trty_yy = v_trty_yy
         AND trty_seq_no = v_share_cd;

--Cursor for peril distribution in ri table.
   CURSOR cur_frperil (
      v_peril_cd   giri_ri_dist_item_v.peril_cd%TYPE,
      v_item_no    giri_ri_dist_item_v.item_no%TYPE
   )
   IS
      SELECT   t2.ri_cd,
               SUM (NVL ((t2.ri_shr_pct / 100) * t8.tsi_amt, 0)
                   ) sum_ri_tsi_amt
          FROM gipi_polbasic t5,
               gipi_itmperil t8,
               giuw_pol_dist t4,
               giuw_itemperilds t6,
               giri_distfrps t3,
               giri_frps_ri t2,
               gicl_claims t1
         WHERE t1.claim_id = v_claim_id
           AND t5.line_cd = t1.line_cd
           AND t5.subline_cd = t1.subline_cd
           AND t5.iss_cd = t1.pol_iss_cd
           AND t5.issue_yy = t1.issue_yy
           AND t5.pol_seq_no = t1.pol_seq_no
           AND t5.renew_no = t1.renew_no
           AND t5.pol_flag IN ('1', '2', '3', '4', 'X')  --kenneth SR 4855 100715
           AND t5.policy_id = t8.policy_id
           AND t8.peril_cd = v_peril_cd
           AND t8.item_no = v_item_no
           AND t5.policy_id = t4.policy_id
           AND TRUNC (DECODE (TRUNC (t4.eff_date),
                              TRUNC (t5.eff_date), DECODE
                                                       (TRUNC (t5.eff_date),
                                                        TRUNC (t5.incept_date), v_eff_date,
                                                        t5.eff_date
                                                       ),
                              t4.eff_date
                             )
                     ) <= t1.loss_date
           AND TRUNC (DECODE (TRUNC (t4.expiry_date),
                              TRUNC (t5.expiry_date), DECODE
                                                   (NVL (t5.endt_expiry_date,
                                                         t5.expiry_date
                                                        ),
                                                    t5.expiry_date, v_expiry_date,
                                                    t5.endt_expiry_date
                                                   ),
                              t4.expiry_date
                             )
                     ) >= t1.loss_date
           AND t4.dist_flag = '3'
           AND t4.dist_no = t6.dist_no
           AND t8.item_no = t6.item_no
           AND t8.peril_cd = t6.peril_cd
           AND t4.dist_no = t3.dist_no
           AND t6.dist_seq_no = t3.dist_seq_no
           AND t3.line_cd = t2.line_cd
           AND t3.frps_yy = t2.frps_yy
           AND t3.frps_seq_no = t2.frps_seq_no
           AND NVL (t2.reverse_sw, 'N') = 'N'
           AND NVL (t2.delete_sw, 'N') = 'N'
           AND t3.ri_flag = '2'
      GROUP BY t2.ri_cd;

   TYPE tab_share_cd IS TABLE OF giis_dist_share.share_cd%TYPE;

   TYPE tab_share_type IS TABLE OF giis_dist_share.share_type%TYPE;

   TYPE tab_acct_trty_type IS TABLE OF giis_dist_share.acct_trty_type%TYPE;

   TYPE tab_trty_yy IS TABLE OF giis_dist_share.trty_yy%TYPE;

   TYPE tab_prtfolio_sw IS TABLE OF giis_dist_share.prtfolio_sw%TYPE;

   TYPE tab_shr_expiry_date IS TABLE OF giis_dist_share.expiry_date%TYPE;

   TYPE tab_ann_dist_tsi IS TABLE OF NUMBER;

   v_share_cd           tab_share_cd                        := tab_share_cd
                                                                           ();
   v_share_type         tab_share_type                    := tab_share_type
                                                                           ();
   v_trty_yy            tab_trty_yy                          := tab_trty_yy
                                                                           ();
   v_acct_trty_type     tab_acct_trty_type            := tab_acct_trty_type
                                                                           ();
   v_prtfolio_sw        tab_prtfolio_sw                  := tab_prtfolio_sw
                                                                           ();
   v_shr_expiry_date    tab_shr_expiry_date          := tab_shr_expiry_date
                                                                           ();
   v_ann_dist_tsi       tab_ann_dist_tsi                := tab_ann_dist_tsi
                                                                           ();
   v_line_cd            giis_line.line_cd%TYPE;
   v_total_tsi          NUMBER                                    := 0;
   v_ctr                INTEGER                                   := 0;
   v_clm_dist_no        gicl_reserve_ds.clm_dist_no%TYPE;
   v_total_facul        NUMBER                                    := 0;
   v_dist_facul         NUMBER                                    := 0;
   sum_tsi_amt          giri_basic_info_item_sum_v.tsi_amt%TYPE;
   v_shr_pct            NUMBER                                    := 0;
   v_shr_loss_res_amt   NUMBER                                    := 0;
   v_shr_exp_res_amt    NUMBER                                    := 0;
   ann_ri_pct           NUMBER (12, 9);
   v_loss_date          DATE;

   FUNCTION share_exists (
      v_claim_id          gicl_reserve_ds.claim_id%TYPE,
      v_hist_seq_no       gicl_reserve_ds.hist_seq_no%TYPE,
      v_grouped_item_no   gicl_reserve_ds.grouped_item_no%TYPE,
      v_item_no           gicl_reserve_ds.item_no%TYPE,
      v_peril_cd          gicl_reserve_ds.peril_cd%TYPE,
      v_share_cd          gicl_reserve_ds.grp_seq_no%TYPE,
      v_dsp_line_cd       gicl_reserve_ds.line_cd%TYPE
   )
      RETURN BOOLEAN
   IS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gicl_reserve_ds
                 WHERE claim_id = v_claim_id
                   AND hist_seq_no = v_hist_seq_no
                   AND grouped_item_no = v_grouped_item_no
                   AND item_no = v_item_no
                   AND peril_cd = v_peril_cd
                   AND grp_seq_no = v_share_cd
                   AND line_cd = v_dsp_line_cd)
      LOOP
         RETURN (TRUE);
      END LOOP;

      RETURN (FALSE);
   END;
BEGIN
   FOR clm_res IN cur_clm_res
   LOOP
      BEGIN
         SELECT MAX (clm_dist_no)
           INTO v_clm_dist_no
           FROM gicl_reserve_ds
          WHERE claim_id = clm_res.claim_id
            AND clm_res_hist_id = v_clm_res_hist_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_clm_dist_no := 0;
      END;

      v_clm_dist_no := NVL (v_clm_dist_no, 0) + 1;

      SELECT   c.line_cd, c.loss_date, SUM (aa.tsi_amt)
          INTO v_line_cd, v_loss_date, sum_tsi_amt
          FROM giri_basic_info_item_sum_v aa, giuw_pol_dist b, gicl_claims c
         WHERE aa.policy_id = b.policy_id
           AND TRUNC (DECODE (TRUNC (b.eff_date),
                              TRUNC (aa.eff_date), DECODE
                                                       (TRUNC (aa.eff_date),
                                                        TRUNC (aa.incept_date), v_eff_date,
                                                        aa.eff_date
                                                       ),
                              b.eff_date
                             )
                     ) <= c.loss_date
           AND TRUNC (DECODE (TRUNC (b.expiry_date),
                              TRUNC (aa.expiry_date), DECODE
                                                   (NVL (aa.endt_expiry_date,
                                                         aa.expiry_date
                                                        ),
                                                    aa.expiry_date, v_expiry_date,
                                                    aa.endt_expiry_date
                                                   ),
                              b.expiry_date
                             )
                     ) >= c.loss_date
           AND aa.item_no = clm_res.item_no
           AND aa.peril_cd = clm_res.peril_cd
           AND c.claim_id = clm_res.claim_id
           AND aa.line_cd = c.line_cd
           AND aa.subline_cd = c.subline_cd
           AND aa.iss_cd = c.pol_iss_cd
           AND aa.issue_yy = c.issue_yy
           AND aa.pol_seq_no = c.pol_seq_no
           AND aa.renew_no = c.renew_no
           AND b.dist_flag = giisp.v ('DISTRIBUTED')
      GROUP BY c.line_cd, c.loss_date;

      FOR fac_dist IN cur_facul (clm_res.peril_cd, clm_res.item_no)
      LOOP
         v_dist_facul := v_dist_facul + fac_dist.ann_dist_tsi;
      END LOOP;

      FOR dist IN cur_dist (v_location_cd, v_loss_date)
      LOOP
         v_ctr := v_ctr + 1;
         v_share_cd.EXTEND;
         v_share_type.EXTEND;
         v_acct_trty_type.EXTEND;
         v_ann_dist_tsi.EXTEND;
         v_trty_yy.EXTEND;
         v_prtfolio_sw.EXTEND;
         v_shr_expiry_date.EXTEND;
         v_share_cd (v_ctr) := dist.share_cd;
         v_share_type (v_ctr) := dist.share_type;
         v_trty_yy (v_ctr) := dist.trty_yy;
         v_prtfolio_sw (v_ctr) := dist.prtfolio_sw;
         v_shr_expiry_date (v_ctr) := dist.expiry_date;
         v_acct_trty_type (v_ctr) := dist.acct_trty_type;
         v_ann_dist_tsi (v_ctr) := dist.ann_dist_tsi;
         v_total_tsi := v_total_tsi + dist.ann_dist_tsi;

         IF dist.share_type = giacp.v ('FACUL_SHARE_TYPE')
         THEN
            v_total_facul := v_total_facul + dist.ann_dist_tsi;
         END IF;
      END LOOP;

      FOR ctr IN v_share_cd.FIRST .. v_share_cd.LAST
      LOOP
         IF     NVL (v_prtfolio_sw (ctr), 'N') = 'P'
            AND v_shr_expiry_date (ctr) < v_distribution_date
         THEN
            BEGIN
               SELECT share_cd, acct_trty_type,
                      share_type
                 INTO v_share_cd (ctr), v_acct_trty_type (ctr),
                      v_share_type (ctr)
                 FROM giis_dist_share
                WHERE line_cd = v_line_cd
                  AND old_trty_seq_no = v_share_cd (ctr);
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error
                                         (-20888,
                                             'No new treaty set-up for year'
                                          || TO_CHAR
                                                   (NVL (v_distribution_date,
                                                         SYSDATE
                                                        ),
                                                    'YYYY'
                                                   )
                                         );
               WHEN TOO_MANY_ROWS
               THEN
                  raise_application_error
                                        (-20889,
                                            'Too many treaty set-up for year'
                                         || TO_CHAR
                                                   (NVL (v_distribution_date,
                                                         SYSDATE
                                                        ),
                                                    'YYYY'
                                                   )
                                        );
            END;
         END IF;

         IF v_share_type (ctr) = giacp.v ('FACUL_SHARE_TYPE')
         THEN
            v_shr_pct := v_dist_facul / sum_tsi_amt * 100;
            v_shr_loss_res_amt :=
                            clm_res.loss_reserve * v_dist_facul / sum_tsi_amt;
            v_shr_exp_res_amt :=
                         clm_res.expense_reserve * v_dist_facul / sum_tsi_amt;
         ELSIF v_share_type (ctr) <> giacp.v ('FACUL_SHARE_TYPE')
         THEN
            v_shr_pct :=
                 v_ann_dist_tsi (ctr)
               / (v_total_tsi - v_total_facul)
               * (1 - v_dist_facul / sum_tsi_amt)
               * 100;
            v_shr_loss_res_amt :=
                 clm_res.loss_reserve
               * v_ann_dist_tsi (ctr)
               / (v_total_tsi - v_total_facul)
               * (1 - v_dist_facul / sum_tsi_amt);
            v_shr_exp_res_amt :=
                 clm_res.expense_reserve
               * v_ann_dist_tsi (ctr)
               / (v_total_tsi - v_total_facul)
               * (1 - v_dist_facul / sum_tsi_amt);
         END IF;

         IF share_exists (clm_res.claim_id,
                          clm_res.hist_seq_no,
                          clm_res.grouped_item_no,
                          clm_res.item_no,
                          clm_res.peril_cd,
                          v_share_cd (ctr),
                          v_line_cd
                         )
         THEN
            UPDATE gicl_reserve_ds
               SET shr_pct = NVL (shr_pct, 0) + NVL (v_shr_pct, 0),
                   shr_loss_res_amt =
                        NVL (shr_loss_res_amt, 0)
                        + NVL (v_shr_loss_res_amt, 0),
                   shr_exp_res_amt =
                          NVL (shr_exp_res_amt, 0)
                          + NVL (v_shr_exp_res_amt, 0)
             WHERE claim_id = clm_res.claim_id
               AND hist_seq_no = clm_res.hist_seq_no
               AND grouped_item_no = clm_res.grouped_item_no
               AND item_no = clm_res.item_no
               AND peril_cd = clm_res.peril_cd
               AND grp_seq_no = v_share_cd (ctr)
               AND line_cd = v_line_cd;
         ELSIF    (    v_dist_facul <> 0
                   AND v_share_type (ctr) = giacp.v ('FACUL_SHARE_TYPE')
                  )
               OR (v_share_type (ctr) <> giacp.v ('FACUL_SHARE_TYPE'))
         THEN
            INSERT INTO gicl_reserve_ds
                        (claim_id, clm_res_hist_id,
                         dist_year,
                         clm_dist_no, item_no, peril_cd,
                         grouped_item_no, grp_seq_no,
                         share_type, shr_pct, shr_loss_res_amt,
                         shr_exp_res_amt, line_cd,
                         acct_trty_type, user_id, last_update,
                         hist_seq_no
                        )
                 VALUES (clm_res.claim_id, clm_res.clm_res_hist_id,
                         TO_CHAR (NVL (v_distribution_date, SYSDATE), 'YYYY'),
                         v_clm_dist_no, clm_res.item_no, clm_res.peril_cd,
                         clm_res.grouped_item_no, v_share_cd (ctr),
                         v_share_type (ctr), v_shr_pct, v_shr_loss_res_amt,
                         v_shr_exp_res_amt, v_line_cd,
                         v_acct_trty_type (ctr), USER, SYSDATE,
                         clm_res.hist_seq_no
                        );
         END IF;

         IF v_share_type (ctr) = giacp.v ('TRTY_SHARE_TYPE')
         THEN
            FOR c_trty IN cur_trty (v_line_cd,
                                    v_share_cd (ctr),
                                    v_trty_yy (ctr)
                                   )
            LOOP
               INSERT INTO gicl_reserve_rids
                           (claim_id, clm_res_hist_id,
                            dist_year,
                            clm_dist_no, item_no,
                            peril_cd, grp_seq_no,
                            share_type, ri_cd,
                            shr_ri_pct,
                            shr_ri_pct_real,
                            shr_loss_ri_res_amt,
                            shr_exp_ri_res_amt,
                            line_cd, acct_trty_type,
                            prnt_ri_cd, hist_seq_no,
                            grouped_item_no
                           )
                    VALUES (clm_res.claim_id, clm_res.clm_res_hist_id,
                            TO_CHAR (NVL (v_distribution_date, SYSDATE),
                                     'YYYY'
                                    ),
                            v_clm_dist_no, clm_res.item_no,
                            clm_res.peril_cd, v_share_cd (ctr),
                            giacp.v ('TRTY_SHARE_TYPE'), c_trty.ri_cd,
                            (v_shr_pct * c_trty.trty_shr_pct / 100
                            ),
                            c_trty.trty_shr_pct,
                            (v_shr_loss_res_amt * c_trty.trty_shr_pct / 100
                            ),
                            (v_shr_exp_res_amt * c_trty.trty_shr_pct / 100
                            ),
                            v_line_cd, v_acct_trty_type (ctr),
                            c_trty.prnt_ri_cd, clm_res.hist_seq_no,
                            clm_res.grouped_item_no
                           );
            END LOOP;
         ELSIF v_share_type (ctr) = giacp.v ('FACUL_SHARE_TYPE')
         THEN
            FOR c_facul IN cur_frperil (clm_res.peril_cd, clm_res.item_no)
            LOOP                                    /*RI peril distribution*/
               ann_ri_pct := (c_facul.sum_ri_tsi_amt / sum_tsi_amt) * 100;

               INSERT INTO gicl_reserve_rids
                           (claim_id, clm_res_hist_id,
                            dist_year,
                            clm_dist_no, item_no,
                            peril_cd, grp_seq_no,
                            share_type, ri_cd,
                            shr_ri_pct, shr_ri_pct_real,
                            shr_loss_ri_res_amt,
                            shr_exp_ri_res_amt,
                            line_cd, acct_trty_type,
                            prnt_ri_cd, hist_seq_no,
                            grouped_item_no
                           )
                    VALUES (clm_res.claim_id, clm_res.clm_res_hist_id,
                            TO_CHAR (NVL (v_distribution_date, SYSDATE),
                                     'YYYY'
                                    ),
                            v_clm_dist_no, clm_res.item_no,
                            clm_res.peril_cd, v_share_cd (ctr),
                            giacp.v ('FACUL_SHARE_TYPE'), c_facul.ri_cd,
                            ann_ri_pct, ann_ri_pct / v_shr_pct * 100,
                            (v_shr_loss_res_amt * ann_ri_pct / 100
                            ),
                            (v_shr_exp_res_amt * ann_ri_pct / 100),
                            v_line_cd, v_acct_trty_type (ctr),
                            c_facul.ri_cd, clm_res.hist_seq_no,
                            clm_res.grouped_item_no
                           );
            END LOOP;
         END IF;
      END LOOP;

      UPDATE gicl_clm_res_hist
         SET dist_type = 3
       WHERE claim_id = clm_res.claim_id
         AND clm_res_hist_id = clm_res.clm_res_hist_id;

----------------------------------************************************************************************************************************************
   --EXCESS OF LOSS  (copied from XOL part GICLS024 DISTRIBUTE_RESERVE )
      DECLARE
         v_retention               gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_retention_orig          gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_running_retention       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_total_retention         gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_allowed_retention       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_total_xol_share         gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_overall_xol_share       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_overall_allowed_share   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_old_xol_share           gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_allowed_ret             gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_shr_pct                 gicl_reserve_ds.shr_pct%TYPE;
      BEGIN
         IF v_nbt_cat_cd IS NULL
         THEN
            FOR net_shr IN (SELECT (shr_loss_res_amt * clm_res.convert_rate
                                   ) loss_reserve,
                                   (shr_exp_res_amt * clm_res.convert_rate
                                   ) exp_reserve,
                                   shr_pct
                              FROM gicl_reserve_ds
                             WHERE claim_id = clm_res.claim_id
                               AND grouped_item_no = clm_res.grouped_item_no
                               --added by gmi 02/28/06
                               AND hist_seq_no = clm_res.hist_seq_no
                               AND item_no = clm_res.item_no
                               AND peril_cd = clm_res.peril_cd
                               AND share_type = '1')
            LOOP
               v_retention :=
                  NVL (net_shr.loss_reserve, 0)
                  + NVL (net_shr.exp_reserve, 0);
               v_retention_orig :=
                  NVL (net_shr.loss_reserve, 0)
                  + NVL (net_shr.exp_reserve, 0);

               FOR tot_net IN
                  (SELECT SUM (  NVL (a.shr_loss_res_amt * c.convert_rate, 0)
                               + NVL (a.shr_exp_res_amt * c.convert_rate, 0)
                              ) ret_amt
                     FROM gicl_reserve_ds a,
                          gicl_item_peril b,
                          gicl_clm_res_hist c
                    WHERE a.claim_id = clm_res.claim_id
                      AND a.claim_id = b.claim_id
                      AND a.grouped_item_no = b.grouped_item_no
                      --added by gmi 02/28/06
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND a.claim_id = c.claim_id
                      AND a.grouped_item_no = c.grouped_item_no
                      --added by gmi 02/28/06
                      AND a.item_no = c.item_no
                      AND a.peril_cd = c.peril_cd
                      AND a.clm_dist_no = c.dist_no
                      AND a.clm_res_hist_id = c.clm_res_hist_id
                      AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                      AND NVL (a.negate_tag, 'N') = 'N'
                      AND a.share_type = '1'
                      AND (   a.item_no <> clm_res.item_no
                           OR a.peril_cd <> clm_res.peril_cd
                           OR a.grouped_item_no <> clm_res.grouped_item_no
                          ))
               LOOP
                  v_total_retention := v_retention + NVL (tot_net.ret_amt, 0);
               END LOOP;

               FOR chk_xol IN (SELECT   a.share_cd, acct_trty_type,
                                        xol_allowed_amount, xol_base_amount,
                                        xol_reserve_amount, trty_yy,
                                        xol_aggregate_sum, a.line_cd,
                                        a.share_type
                                   FROM giis_dist_share a, giis_trty_peril b
                                  WHERE a.line_cd = b.line_cd
                                    AND a.share_cd = b.trty_seq_no
                                    AND a.share_type = '4'
                                    AND TRUNC (a.eff_date) <=
                                                           TRUNC (v_loss_date)
                                    AND TRUNC (a.expiry_date) >=
                                                           TRUNC (v_loss_date)
                                    AND b.peril_cd = clm_res.peril_cd
                                    AND a.line_cd = v_line_cd
                               ORDER BY xol_base_amount ASC)
               LOOP
                  v_allowed_retention :=
                                  v_total_retention - chk_xol.xol_base_amount;

                  IF v_allowed_retention < 1
                  THEN
                     EXIT;
                  END IF;

                  FOR get_all_xol IN
                     (SELECT SUM (  NVL (a.shr_loss_res_amt * c.convert_rate,
                                         0
                                        )
                                  + NVL (a.shr_exp_res_amt * c.convert_rate,
                                         0)
                                 ) ret_amt
                        FROM gicl_reserve_ds a,
                             gicl_item_peril b,
                             gicl_clm_res_hist c
                       WHERE NVL (a.negate_tag, 'N') = 'N'
                         AND a.item_no = b.item_no
                         AND a.grouped_item_no = b.grouped_item_no
                         -- added by gmi 02/28/06
                         AND a.peril_cd = b.peril_cd
                         AND a.claim_id = b.claim_id
                         AND a.item_no = c.item_no
                         AND a.grouped_item_no = c.grouped_item_no
                         -- added by gmi 02/28/06
                         AND a.peril_cd = c.peril_cd
                         AND a.claim_id = c.claim_id
                         AND NVL (a.clm_dist_no, -1) = NVL (c.dist_no, -1)
                         --modified by ailene to handle ORA-01722 12/05/2006
                         AND a.clm_res_hist_id = c.clm_res_hist_id
                         AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                         AND a.grp_seq_no = chk_xol.share_cd
                         AND a.line_cd = chk_xol.line_cd)
                  LOOP
                     v_overall_xol_share :=
                              chk_xol.xol_aggregate_sum - get_all_xol.ret_amt;
                  END LOOP;

                  IF v_overall_xol_share < 1
                  THEN
                     -- added adrel 01082010, should exit loop if already exceeded aggregate limit
                     EXIT;
                  END IF;

                  IF v_allowed_retention > v_overall_xol_share
                  THEN
                     v_allowed_retention := v_overall_xol_share;
                  END IF;

                  IF v_allowed_retention > v_retention
                  THEN
                     v_allowed_retention := v_retention;
                  END IF;

                  v_total_xol_share := 0;
                  v_old_xol_share := 0;

                  FOR total_xol IN
                     (SELECT SUM (  NVL (a.shr_loss_res_amt * c.convert_rate,
                                         0
                                        )
                                  + NVL (a.shr_exp_res_amt * c.convert_rate,
                                         0)
                                 ) ret_amt
                        FROM gicl_reserve_ds a,
                             gicl_item_peril b,
                             gicl_clm_res_hist c
                       WHERE a.claim_id = clm_res.claim_id
                         AND a.claim_id = b.claim_id
                         AND a.grouped_item_no = b.grouped_item_no
                         --added by gmi 02/28/06
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b.peril_cd
                         AND a.claim_id = c.claim_id
                         AND a.item_no = c.item_no
                         AND a.peril_cd = c.peril_cd
                         AND a.grouped_item_no = c.grouped_item_no
                         --added by gmi 02/28/06
                         AND a.clm_res_hist_id = c.clm_res_hist_id
                         AND a.clm_dist_no = c.dist_no
                         AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                         AND NVL (a.negate_tag, 'N') = 'N'
                         AND a.grp_seq_no = chk_xol.share_cd)
                  LOOP
                     v_total_xol_share := NVL (total_xol.ret_amt, 0);
                     v_old_xol_share := NVL (total_xol.ret_amt, 0);
                  END LOOP;

                  IF v_total_xol_share <= chk_xol.xol_allowed_amount
                  THEN
                     v_total_xol_share :=
                               chk_xol.xol_allowed_amount - v_total_xol_share;
                  END IF;

                  IF v_total_xol_share >= v_allowed_retention
                  THEN
                     v_total_xol_share := v_allowed_retention;
                  END IF;

                  IF v_total_xol_share <> 0
                  THEN
                     v_shr_pct := v_total_xol_share / v_retention_orig;
                     v_running_retention :=
                                      v_running_retention + v_total_xol_share;

                     INSERT INTO gicl_reserve_ds
                                 (claim_id, clm_res_hist_id,
                                  dist_year,
                                  clm_dist_no, item_no,
                                  peril_cd, grouped_item_no,
                                  --added by gmi 02/28/06
                                  grp_seq_no, share_type,
                                  shr_pct,
                                  shr_loss_res_amt,
                                  shr_exp_res_amt,
                                  line_cd, acct_trty_type,
                                  hist_seq_no
                                 )
                          VALUES (clm_res.claim_id, clm_res.clm_res_hist_id,
                                  TO_CHAR (NVL (v_distribution_date, SYSDATE),
                                           'YYYY'
                                          ),
                                  v_clm_dist_no, clm_res.item_no,
                                  clm_res.peril_cd, clm_res.grouped_item_no,
                                  --added by gmi 02/28/06
                                  chk_xol.share_cd, chk_xol.share_type,
                                  (net_shr.shr_pct * v_shr_pct
                                  ),
                                    (net_shr.loss_reserve * v_shr_pct)
                                  / clm_res.convert_rate,
                                    (net_shr.exp_reserve * v_shr_pct
                                    )
                                  / clm_res.convert_rate,
                                  v_line_cd, chk_xol.acct_trty_type,
                                  clm_res.hist_seq_no
                                 );

                     FOR update_xol_trty IN
                        (SELECT SUM (  (  NVL (a.shr_loss_res_amt, 0)
                                        * b.convert_rate
                                       )
                                     + (  NVL (shr_exp_res_amt, 0)
                                        * b.convert_rate
                                       )
                                    ) ret_amt
                           FROM gicl_reserve_ds a,
                                gicl_clm_res_hist b,
                                gicl_item_peril c
                          WHERE NVL (a.negate_tag, 'N') = 'N'
                            AND a.claim_id = b.claim_id
                            AND a.clm_res_hist_id = b.clm_res_hist_id
                            AND a.claim_id = c.claim_id
                            AND a.item_no = c.item_no
                            AND a.peril_cd = c.peril_cd
                            AND a.grouped_item_no = c.grouped_item_no
                            --added by gmi 02/28/06
                            AND a.clm_dist_no = b.dist_no
                            AND NVL (c.close_flag, 'AP') IN
                                                           ('AP', 'CC', 'CP')
                            AND a.grp_seq_no = chk_xol.share_cd
                            AND a.line_cd = chk_xol.line_cd)
                     LOOP
                        UPDATE giis_dist_share
                           SET xol_reserve_amount = update_xol_trty.ret_amt
                         WHERE share_cd = chk_xol.share_cd
                           AND line_cd = chk_xol.line_cd;
                     END LOOP;

                     FOR xol_trty IN cur_trty (v_line_cd,
                                               chk_xol.share_cd,
                                               chk_xol.trty_yy
                                              )
                     LOOP
                        INSERT INTO gicl_reserve_rids
                                    (claim_id,
                                     clm_res_hist_id,
                                     dist_year,
                                     clm_dist_no, item_no,
                                     peril_cd, grp_seq_no,
                                     share_type, ri_cd,
                                     shr_ri_pct,
                                     shr_ri_pct_real,
                                     shr_loss_ri_res_amt,
                                     shr_exp_ri_res_amt,
                                     line_cd, acct_trty_type,
                                     prnt_ri_cd,
                                     hist_seq_no,
                                     grouped_item_no
                                    )                           --gmi 02/23/06
                             VALUES (clm_res.claim_id,
                                     clm_res.clm_res_hist_id,
                                     TO_CHAR (NVL (v_distribution_date,
                                                   SYSDATE
                                                  ),
                                              'YYYY'
                                             ),
                                     v_clm_dist_no, clm_res.item_no,
                                     clm_res.peril_cd, chk_xol.share_cd,
                                     chk_xol.share_type, xol_trty.ri_cd,
                                     (  (net_shr.shr_pct * v_shr_pct)
                                      * (xol_trty.trty_shr_pct / 100)
                                     ),
                                     xol_trty.trty_shr_pct,
                                       (  (net_shr.loss_reserve * v_shr_pct)
                                        * (xol_trty.trty_shr_pct / 100)
                                       )
                                     / clm_res.convert_rate,
                                       (  (net_shr.exp_reserve * v_shr_pct)
                                        * (xol_trty.trty_shr_pct / 100)
                                       )
                                     / clm_res.convert_rate,
                                     v_line_cd, chk_xol.acct_trty_type,
                                     xol_trty.prnt_ri_cd,
                                     clm_res.hist_seq_no,
                                     clm_res.grouped_item_no
                                    );                          --gmi 02/23/06
                     END LOOP;
                  END IF;

                  v_retention := v_retention - v_total_xol_share;
                  v_total_retention := v_total_retention + v_old_xol_share;
               END LOOP;                                             --CHK_XOL
            END LOOP;                                               -- NET_SHR
         ELSE
            FOR net_shr IN (SELECT (shr_loss_res_amt * clm_res.convert_rate
                                   ) loss_reserve,
                                   (shr_exp_res_amt * clm_res.convert_rate
                                   ) exp_reserve,
                                   shr_pct
                              FROM gicl_reserve_ds
                             WHERE claim_id = clm_res.claim_id
                               AND hist_seq_no = clm_res.hist_seq_no
                               AND grouped_item_no = clm_res.grouped_item_no
                               --added by gmi 02/28/06
                               AND item_no = clm_res.item_no
                               AND peril_cd = clm_res.peril_cd
                               AND share_type = '1')
            LOOP
               v_retention :=
                  NVL (net_shr.loss_reserve, 0)
                  + NVL (net_shr.exp_reserve, 0);
               v_retention_orig :=
                  NVL (net_shr.loss_reserve, 0)
                  + NVL (net_shr.exp_reserve, 0);

               FOR tot_net IN (SELECT SUM (  NVL (  shr_loss_res_amt
                                                  * d.convert_rate,
                                                  0
                                                 )
                                           + NVL (  shr_exp_res_amt
                                                  * d.convert_rate,
                                                  0
                                                 )
                                          ) ret_amt
                                 FROM gicl_reserve_ds a,
                                      gicl_claims c,
                                      gicl_item_peril b,
                                      gicl_clm_res_hist d
                                WHERE a.claim_id = c.claim_id
                                  AND a.claim_id = b.claim_id
                                  AND a.grouped_item_no = b.grouped_item_no
                                  --added by gmi 02/28/06
                                  AND a.item_no = b.item_no
                                  AND a.peril_cd = b.peril_cd
                                  AND NVL (b.close_flag, 'AP') IN
                                                           ('AP', 'CC', 'CP')
                                  AND c.catastrophic_cd = v_nbt_cat_cd
                                  AND c.line_cd = v_line_cd
                                  --jen.060210: to hadle cat multi line.
                                  AND NVL (negate_tag, 'N') = 'N'
                                  AND share_type = '1'
                                  AND a.claim_id = d.claim_id
                                  AND a.grouped_item_no = d.grouped_item_no
                                  --added by gmi 02/28/06
                                  AND a.item_no = d.item_no
                                  AND a.peril_cd = d.peril_cd
                                  AND a.clm_dist_no = d.dist_no
                                  AND a.clm_res_hist_id = d.clm_res_hist_id
                                  AND (   a.claim_id <> clm_res.claim_id
                                       OR a.item_no <> clm_res.item_no
                                       OR a.peril_cd <> clm_res.peril_cd
                                      ))
               LOOP
                  v_total_retention := v_retention + NVL (tot_net.ret_amt, 0);
               END LOOP;

               FOR chk_xol IN (SELECT   a.share_cd, acct_trty_type,
                                        xol_allowed_amount, xol_base_amount,
                                        xol_reserve_amount, trty_yy,
                                        xol_aggregate_sum, a.line_cd,
                                        a.share_type
                                   FROM giis_dist_share a, giis_trty_peril b
                                  WHERE a.line_cd = b.line_cd
                                    AND a.share_cd = b.trty_seq_no
                                    AND a.share_type = '4'
                                    AND TRUNC (a.eff_date) <=
                                                           TRUNC (v_loss_date)
                                    AND TRUNC (a.expiry_date) >=
                                                           TRUNC (v_loss_date)
                                    AND b.peril_cd = clm_res.peril_cd
                                    AND a.line_cd = v_line_cd
                               ORDER BY xol_base_amount ASC)
               LOOP
                  v_allowed_retention :=
                                  v_total_retention - chk_xol.xol_base_amount;

                  IF v_allowed_retention < 1
                  THEN
                     EXIT;
                  END IF;

                  FOR get_all_xol IN
                     (SELECT SUM (  NVL (shr_loss_res_amt * c.convert_rate, 0)
                                  + NVL (shr_exp_res_amt * c.convert_rate, 0)
                                 ) ret_amt
                        FROM gicl_reserve_ds a,
                             gicl_item_peril b,
                             gicl_clm_res_hist c
                       WHERE NVL (negate_tag, 'N') = 'N'
                         AND a.claim_id = b.claim_id
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b.peril_cd
                         AND a.grouped_item_no = b.grouped_item_no
                         --added by gmi 02/28/06
                         AND a.claim_id = c.claim_id
                         AND a.grouped_item_no = c.grouped_item_no
                         --added by gmi 02/28/06
                         AND a.item_no = c.item_no
                         AND a.peril_cd = c.peril_cd
                         AND a.clm_dist_no = c.dist_no
                         AND a.clm_res_hist_id = c.clm_res_hist_id
                         AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                         AND grp_seq_no = chk_xol.share_cd
                         AND a.line_cd = chk_xol.line_cd)
                  LOOP
                     v_overall_xol_share :=
                              chk_xol.xol_aggregate_sum - get_all_xol.ret_amt;
                  END LOOP;

                  IF v_overall_xol_share < 1
                  THEN
                     -- added adrel 01082010, should exit loop if already exceeded aggregate limit
                     EXIT;
                  END IF;

                  IF v_allowed_retention > v_overall_xol_share
                  THEN
                     v_allowed_retention := v_overall_xol_share;
                  END IF;

                  IF v_allowed_retention > v_retention
                  THEN
                     v_allowed_retention := v_retention;
                  END IF;

                  v_total_xol_share := 0;
                  v_old_xol_share := 0;

                  FOR total_xol IN
                     (SELECT SUM (  NVL (shr_loss_res_amt * d.convert_rate, 0)
                                  + NVL (shr_exp_res_amt * d.convert_rate, 0)
                                 ) ret_amt
                        FROM gicl_reserve_ds a,
                             gicl_claims c,
                             gicl_item_peril b,
                             gicl_clm_res_hist d
                       WHERE c.claim_id = a.claim_id
                         AND a.grouped_item_no = b.grouped_item_no
                         --added by gmi 02/28/06
                         AND a.claim_id = b.claim_id
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b.peril_cd
                         AND a.claim_id = d.claim_id
                         AND a.grouped_item_no = d.grouped_item_no
                         --added by gmi 02/28/06
                         AND a.item_no = d.item_no
                         AND a.peril_cd = d.peril_cd
                         AND a.clm_dist_no = d.dist_no
                         AND a.clm_res_hist_id = d.clm_res_hist_id
                         AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                         AND c.catastrophic_cd = v_nbt_cat_cd
                         AND c.line_cd = v_line_cd
                         --jen.060210: to hadle cat multi line.
                         AND NVL (negate_tag, 'N') = 'N'
                         AND grp_seq_no = chk_xol.share_cd)
                  LOOP
                     v_total_xol_share := NVL (total_xol.ret_amt, 0);
                     v_old_xol_share := NVL (total_xol.ret_amt, 0);
                  END LOOP;

                  IF v_total_xol_share <= chk_xol.xol_allowed_amount
                  THEN
                     v_total_xol_share :=
                               chk_xol.xol_allowed_amount - v_total_xol_share;
                  ELSE
                     v_total_xol_share := 0;
                  -- jen.060210:will not insert record if xol share exceeds allowed xol amt
                  END IF;

                  IF v_total_xol_share >= v_allowed_retention
                  THEN
                     v_total_xol_share := v_allowed_retention;
                  END IF;

                  IF v_total_xol_share <> 0
                  THEN
                     v_shr_pct := v_total_xol_share / v_retention_orig;
                     v_running_retention :=
                                      v_running_retention + v_total_xol_share;

                     INSERT INTO gicl_reserve_ds
                                 (claim_id, clm_res_hist_id,
                                  dist_year,
                                  clm_dist_no, item_no,
                                  peril_cd, grouped_item_no,
                                  --added by gmi 02/28/06
                                  grp_seq_no, share_type,
                                  shr_pct,
                                  shr_loss_res_amt,
                                  shr_exp_res_amt,
                                  line_cd, acct_trty_type,
                                  hist_seq_no
                                 )
                          VALUES (clm_res.claim_id, clm_res.clm_res_hist_id,
                                  TO_CHAR (NVL (v_distribution_date, SYSDATE),
                                           'YYYY'
                                          ),
                                  v_clm_dist_no, clm_res.item_no,
                                  clm_res.peril_cd, clm_res.grouped_item_no,
                                  --added by gmi 02/28/06
                                  chk_xol.share_cd, chk_xol.share_type,
                                  (net_shr.shr_pct * v_shr_pct
                                  ),
                                    (net_shr.loss_reserve * v_shr_pct)
                                  / clm_res.convert_rate,
                                    (net_shr.exp_reserve * v_shr_pct
                                    )
                                  / clm_res.convert_rate,
                                  v_line_cd, chk_xol.acct_trty_type,
                                  clm_res.hist_seq_no
                                 );

                     FOR update_xol_trty IN
                        (SELECT SUM (  (  NVL (a.shr_loss_res_amt, 0)
                                        * b.convert_rate
                                       )
                                     + (  NVL (shr_exp_res_amt, 0)
                                        * b.convert_rate
                                       )
                                    ) ret_amt
                           FROM gicl_reserve_ds a,
                                gicl_clm_res_hist b,
                                gicl_item_peril c
                          WHERE NVL (a.negate_tag, 'N') = 'N'
                            AND a.claim_id = b.claim_id
                            AND a.clm_res_hist_id = b.clm_res_hist_id
                            AND a.claim_id = c.claim_id
                            AND a.item_no = c.item_no
                            AND a.peril_cd = c.peril_cd
                            AND a.grouped_item_no = c.grouped_item_no
                            --added by gmi 02/28/06
                            AND NVL (c.close_flag, 'AP') IN
                                                           ('AP', 'CC', 'CP')
                            AND a.grp_seq_no = chk_xol.share_cd
                            AND a.line_cd = chk_xol.line_cd)
                     LOOP
                        UPDATE giis_dist_share
                           SET xol_reserve_amount = update_xol_trty.ret_amt
                         WHERE share_cd = chk_xol.share_cd
                           AND line_cd = chk_xol.line_cd;
                     END LOOP;

                     FOR xol_trty IN cur_trty (v_line_cd,
                                               chk_xol.share_cd,
                                               chk_xol.trty_yy
                                              )
                     LOOP
                        --msg_alert('beth15','i',false);
                        INSERT INTO gicl_reserve_rids
                                    (claim_id,
                                     clm_res_hist_id,
                                     dist_year,
                                     clm_dist_no, item_no,
                                     peril_cd, grp_seq_no,
                                     share_type, ri_cd,
                                     shr_ri_pct,
                                     shr_ri_pct_real,
                                     shr_loss_ri_res_amt,
                                     shr_exp_ri_res_amt,
                                     line_cd, acct_trty_type,
                                     prnt_ri_cd,
                                     hist_seq_no,
                                     grouped_item_no
                                    )                           --gmi 02/23/06
                             VALUES (clm_res.claim_id,
                                     clm_res.clm_res_hist_id,
                                     TO_CHAR (NVL (v_distribution_date,
                                                   SYSDATE
                                                  ),
                                              'YYYY'
                                             ),
                                     v_clm_dist_no, clm_res.item_no,
                                     clm_res.peril_cd, chk_xol.share_cd,
                                     chk_xol.share_type, xol_trty.ri_cd,
                                     (  (net_shr.shr_pct * v_shr_pct)
                                      * (xol_trty.trty_shr_pct / 100)
                                     ),
                                     xol_trty.trty_shr_pct,
                                       (  (net_shr.loss_reserve * v_shr_pct)
                                        * (xol_trty.trty_shr_pct / 100)
                                       )
                                     / clm_res.convert_rate,
                                       (  (net_shr.exp_reserve * v_shr_pct)
                                        * (xol_trty.trty_shr_pct / 100)
                                       )
                                     / clm_res.convert_rate,
                                     v_line_cd, chk_xol.acct_trty_type,
                                     xol_trty.prnt_ri_cd,
                                     clm_res.hist_seq_no,
                                     clm_res.grouped_item_no
                                    );                          --gmi 02/23/06
                     END LOOP;
                  END IF;

                  v_retention := v_retention - v_total_xol_share;
                  v_total_retention := v_total_retention + v_old_xol_share;
               END LOOP;                                             --CHK_XOL
            END LOOP;                                               -- NET_SHR
         END IF;

         IF v_retention = 0
         THEN
            DELETE FROM gicl_reserve_ds
                  WHERE claim_id = clm_res.claim_id
                    AND hist_seq_no = clm_res.hist_seq_no
                    AND item_no = clm_res.item_no
                    AND peril_cd = clm_res.peril_cd
                    AND grouped_item_no = clm_res.grouped_item_no
                    --added by gmi 02/28/06
                    AND share_type = '1';
         ELSIF v_retention <> v_retention_orig
         THEN
            UPDATE gicl_reserve_ds
               SET shr_loss_res_amt =
                        shr_loss_res_amt
                      * (v_retention_orig - v_running_retention)
                      / v_retention_orig,
                   shr_exp_res_amt =
                        shr_exp_res_amt
                      * (v_retention_orig - v_running_retention)
                      / v_retention_orig,
                   shr_pct =
                        shr_pct
                      * (v_retention_orig - v_running_retention)
                      / v_retention_orig
             WHERE claim_id = clm_res.claim_id
               AND hist_seq_no = clm_res.hist_seq_no
               AND item_no = clm_res.item_no
               AND peril_cd = clm_res.peril_cd
               AND grouped_item_no = clm_res.grouped_item_no
               --added by gmi 02/28/06
               AND share_type = '1';
         END IF;
      END;

      UPDATE gicl_clm_res_hist
         SET dist_sw = 'Y',
             dist_no = v_clm_dist_no
       WHERE CURRENT OF cur_clm_res;
-----------------------------------***********************************************************************************************************************
   END LOOP;
END;
/


