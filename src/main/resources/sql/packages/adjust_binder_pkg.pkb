CREATE OR REPLACE PACKAGE BODY CPI.adjust_binder_pkg
AS
   PROCEDURE offset_adjustment_pkg (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE
   )
/* Created by Edgar base on Melvin's package 09/24/2014
** new offsetting process of binder
*/
   AS
      v_discrep_tsi      giri_wfrperil.ri_tsi_amt%TYPE        := 0;
      v_discrep_prem     giri_wfrperil.ri_prem_amt%TYPE       := 0;
      v_discrep_spct     giri_wfrperil.ri_shr_pct%TYPE        := 0;
      v_max_ri           giis_reinsurer.ri_cd%TYPE;
      v_max_ri_seq       giri_wfrps_ri.ri_seq_no%TYPE;
      v_max_perl_1       giis_peril.peril_cd%TYPE;
      v_peril_cd         giis_peril.peril_cd%TYPE;
      v_param_value_n    giis_parameters.param_value_n%TYPE   := 0;
      v_input_vat        giis_reinsurer.input_vat_rate%TYPE;
      v_last_ri_seq      giri_wfrps_ri.ri_seq_no%TYPE;
      v_last_ri_cd       giri_wfrps_ri.ri_cd%TYPE;
      v_adjust_limit     NUMBER (12, 9)                       := 0.5;
      v_tsi_adjusted     BOOLEAN;
      v_prem_adjusted    BOOLEAN;
      v_temp_peril_cd    giis_peril.peril_cd%TYPE;
      v_peril_to_adj     giis_peril.peril_cd%TYPE;
      v_total_tsi        giri_wfrps_ri.ri_tsi_amt%TYPE;
      v_total_prem       giri_wfrps_ri.ri_prem_amt%TYPE;
      v_equal_share      NUMBER (10);
      v_dist_no          giri_distfrps.dist_no%TYPE;
      v_post_flag        giuw_pol_dist.post_flag%TYPE;
      v_post_flag2       BOOLEAN;
      v_tot_fac_spct     giri_distfrps.tot_fac_spct%TYPE      := 0;
      v_tot_fac_spct2    giri_distfrps.tot_fac_spct2%TYPE     := 0;
      v_diff_tot_spct    giri_distfrps.tot_fac_spct%TYPE      := 0;
      v_diff_tot_spct2   giri_distfrps.tot_fac_spct2%TYPE     := 0;
      v_iss_cd           gipi_parlist.iss_cd%TYPE             := NULL;
      v_dist_seq_no      giri_distfrps.dist_seq_no%TYPE;
   BEGIN
      FOR frps IN (SELECT tot_fac_spct, tot_fac_spct2, dist_no, dist_seq_no
                     FROM giri_distfrps
                    WHERE line_cd = p_line_cd
                      AND frps_yy = p_frps_yy
                      AND frps_seq_no = p_frps_seq_no
                   UNION
                   SELECT tot_fac_spct, tot_fac_spct2, dist_no, dist_seq_no
                     FROM giri_wdistfrps
                    WHERE line_cd = p_line_cd
                      AND frps_yy = p_frps_yy
                      AND frps_seq_no = p_frps_seq_no)
      LOOP
         DBMS_OUTPUT.put_line (' Checking FRPS Details .....');
         v_tot_fac_spct := NVL (frps.tot_fac_spct, 0);
         v_tot_fac_spct2 :=
                NVL (NVL (frps.tot_fac_spct2, NVL (frps.tot_fac_spct, 0)), 0);
         v_dist_no := frps.dist_no;
         v_dist_seq_no := frps.dist_seq_no;
         EXIT;
      END LOOP;

      --    correct_unrvrsd_bndr_rcrds (p_line_cd, p_frps_yy, p_frps_seq_no);

      -- this procedure will correct the amounts stored in working binder tables for un-reversed binders if they were not inserted by GIUTS004 or if they were updated by GIRIS001
      FOR ri_share IN (SELECT   SUM (NVL (ri_shr_pct, 0)) sum_spct,
                                SUM (NVL (NVL (ri_shr_pct2, ri_shr_pct2), 0)
                                    ) sum_spct2,
                                line_cd, frps_yy, frps_seq_no
                           FROM giri_wfrps_ri
                          WHERE line_cd = p_line_cd
                            AND frps_yy = p_frps_yy
                            AND frps_seq_no = p_frps_seq_no
                       GROUP BY line_cd, frps_yy, frps_seq_no)
      LOOP
         v_diff_tot_spct := v_tot_fac_spct - ri_share.sum_spct;
         v_diff_tot_spct2 := v_tot_fac_spct2 - ri_share.sum_spct2;
         EXIT;
      END LOOP;

      FOR get_post_flag IN (SELECT a.post_flag, b.iss_cd
                              FROM giuw_pol_dist a, gipi_parlist b
                             WHERE a.dist_no = v_dist_no
                               AND a.par_id = b.par_id)
      LOOP
         v_post_flag := get_post_flag.post_flag;
         v_iss_cd := get_post_flag.iss_cd;
      END LOOP;

      v_post_flag2 := check_if_peril_dist (v_dist_no);

      IF v_diff_tot_spct = 0 AND v_diff_tot_spct2 = 0
      THEN
         DBMS_OUTPUT.put_line (' Adjusting binder amounts .....');
         adjust_binder_amounts (p_line_cd,
                                p_frps_yy,
                                p_frps_seq_no,
                                v_dist_no,
                                v_dist_seq_no
                               );

         IF v_post_flag = 'P' OR v_post_flag2 = TRUE
         THEN
            DBMS_OUTPUT.put_line
               (' Adjusting peril share percentage for peril distributed FRPS .....'
               );
            adjust_ri_shr_pct (p_line_cd,
                               p_frps_yy,
                               p_frps_seq_no,
                               v_dist_no,
                               v_dist_seq_no
                              );
         END IF;


         DBMS_OUTPUT.put_line
                 (' Adjusting FRPS RI and FRPERIL commission and taxes  .....');
         adjust_ri_comm_and_taxes (p_line_cd, p_frps_yy, p_frps_seq_no);
      ELSE
         adjust_ri_comm_and_taxes (p_line_cd, p_frps_yy, p_frps_seq_no);
      END IF;
   END offset_adjustment_pkg;

   PROCEDURE adjust_ri_shr_pct (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE,
      p_dist_no       giri_wdistfrps.dist_no%TYPE,
      p_dist_seq_no   giri_wdistfrps.dist_seq_no%TYPE
   )
   AS
      v_discrep_shr_pct        giri_wfrperil.ri_shr_pct%TYPE   := 0;
      v_max_ri                 giis_reinsurer.ri_cd%TYPE;
      v_max_ri_seq             giri_wfrps_ri.ri_seq_no%TYPE;
      v_tolerable_disc_limit   NUMBER                          := 0.5;
   BEGIN
      FOR mel IN (SELECT t2.peril_cd, NVL (t2.dist_spct, 0) dist_spct
                    FROM giuw_perilds_dtl t2, giis_dist_share t3
                   WHERE 1 = 1
                     AND t2.line_cd = t3.line_cd
                     AND t2.share_cd = t3.share_cd
                     AND t3.share_type = '3'
                     AND t2.dist_no = p_dist_no
                     AND t2.dist_seq_no = p_dist_seq_no)
      LOOP
         FOR mel1 IN (SELECT SUM (NVL (ri_shr_pct, 0)) ri_shr_pct
                        FROM giri_wfrperil
                       WHERE line_cd = p_line_cd
                         AND frps_yy = p_frps_yy
                         AND frps_seq_no = p_frps_seq_no
                         AND peril_cd = mel.peril_cd)
         LOOP
            v_max_ri := NULL;
            v_max_ri_seq := NULL;
            v_discrep_shr_pct := mel.dist_spct - mel1.ri_shr_pct;

            IF     v_discrep_shr_pct <> 0
               AND ABS (v_discrep_shr_pct) <= v_tolerable_disc_limit
            THEN
               FOR ricd IN (SELECT   a.ri_cd, a.ri_seq_no
                                FROM giri_wfrps_ri a, giri_wfrperil b
                               WHERE a.line_cd = b.line_cd
                                 AND a.frps_yy = b.frps_yy
                                 AND a.frps_seq_no = b.frps_seq_no
                                 AND a.ri_cd = b.ri_cd
                                 AND a.ri_seq_no = b.ri_seq_no
                                 AND b.line_cd = p_line_cd
                                 AND b.frps_yy = p_frps_yy
                                 AND b.frps_seq_no = p_frps_seq_no
                                 AND b.peril_cd = mel.peril_cd
                                 AND ABS (b.ri_shr_pct) >=
                                                       ABS (v_discrep_shr_pct)
                                 AND NOT EXISTS (
                                        SELECT 1
                                          FROM giri_frps_ri tx
                                         WHERE tx.fnl_binder_id =
                                                               a.pre_binder_id)
                            ORDER BY a.ri_seq_no DESC)
               LOOP
                  v_max_ri := ricd.ri_cd;
                  v_max_ri_seq := ricd.ri_seq_no;
                  EXIT;
               END LOOP;

               IF v_max_ri IS NOT NULL AND v_max_ri_seq IS NOT NULL
               THEN
                  UPDATE giri_wfrperil
                     SET ri_shr_pct = ri_shr_pct + v_discrep_shr_pct
                   WHERE line_cd = p_line_cd
                     AND frps_yy = p_frps_yy
                     AND frps_seq_no = p_frps_seq_no
                     AND ri_cd = v_max_ri
                     AND ri_seq_no = v_max_ri_seq
                     AND peril_cd = mel.peril_cd;
               END IF;
            END IF;
         END LOOP;
      END LOOP;
   END adjust_ri_shr_pct;                           --end of adjust_ri_shr_pct

   PROCEDURE adjust_binder_amounts (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE,
      p_dist_no       giri_wdistfrps.dist_no%TYPE,
      p_dist_seq_no   giri_wdistfrps.dist_seq_no%TYPE
   )
   IS
      v_discrep_tsi     NUMBER                               := 0;
      v_discrep_prem    NUMBER                               := 0;
      v_discrep_spct    NUMBER                               := 0;
      v_max_ri          giis_reinsurer.ri_cd%TYPE;
      v_max_ri_seq      giri_wfrps_ri.ri_seq_no%TYPE;
      v_max_perl_1      giis_peril.peril_cd%TYPE;
      v_peril_cd        giis_peril.peril_cd%TYPE;
      v_param_value_n   giis_parameters.param_value_n%TYPE   := 0;
      v_input_vat       giis_reinsurer.input_vat_rate%TYPE;
      v_last_ri_seq     giri_wfrps_ri.ri_seq_no%TYPE;
      v_last_ri_cd      giri_wfrps_ri.ri_cd%TYPE;
      v_adjust_limit    NUMBER (12, 9)                       := 0.5;
      v_tsi_adjusted    BOOLEAN;
      v_prem_adjusted   BOOLEAN;
      v_temp_peril_cd   giis_peril.peril_cd%TYPE;
      v_peril_to_adj    giis_peril.peril_cd%TYPE;
      v_total_tsi       giri_wfrps_ri.ri_tsi_amt%TYPE;
      v_total_prem      giri_wfrps_ri.ri_prem_amt%TYPE;
      v_equal_share     NUMBER (10);
      v_dist_no         giri_distfrps.dist_no%TYPE;
      v_post_flag       giuw_pol_dist.post_flag%TYPE;
      v_post_flag2      BOOLEAN;
      v_exists          VARCHAR2 (1);
   BEGIN
      -- ## first correct the amount between GIUW_PERILDS_DTL and GIRI_WFRPERIL. These perils should be tally.
      -- ## Adjust the last encoded RI.
      FOR perilds IN (SELECT   t2.peril_cd, t2.dist_tsi, t2.dist_prem,
                               t2.dist_spct
                          FROM giuw_perilds_dtl t2, giis_dist_share t3
                         WHERE 1 = 1
                           AND t2.line_cd = t3.line_cd
                           AND t2.share_cd = t3.share_cd
                           AND t3.share_type = '3'
                           AND t2.dist_no = p_dist_no
                           AND t2.dist_seq_no = p_dist_seq_no
                      ORDER BY t2.peril_cd)
      LOOP
         FOR sumfrperil IN (SELECT SUM (NVL (ri_tsi_amt, 0)) sum_tsi,
                                   SUM (NVL (ri_prem_amt, 0)) sum_prem,
                                   SUM (NVL (ri_shr_pct, 0)) sum_shr_pct
                              FROM giri_wfrperil
                             WHERE line_cd = p_line_cd
                               AND frps_yy = p_frps_yy
                               AND frps_seq_no = p_frps_seq_no
                               AND peril_cd = perilds.peril_cd)
         LOOP
            v_discrep_tsi := 0;
            v_discrep_prem := 0;
            v_discrep_spct := 0;
            v_max_ri := NULL;
            v_max_ri_seq := NULL;

            IF NVL (perilds.dist_tsi, 0) <> NVL (sumfrperil.sum_tsi, 0)
            THEN
               v_discrep_tsi :=
                       NVL (perilds.dist_tsi, 0)
                       - NVL (sumfrperil.sum_tsi, 0);
            END IF;

            IF NVL (perilds.dist_prem, 0) <> NVL (sumfrperil.sum_prem, 0)
            THEN
               v_discrep_prem :=
                     NVL (perilds.dist_prem, 0)
                     - NVL (sumfrperil.sum_prem, 0);
            END IF;

            IF ABS (v_discrep_tsi) <= v_adjust_limit AND v_discrep_tsi <> 0
            THEN
               FOR ricd IN (SELECT   a.ri_cd, a.ri_seq_no
                                FROM giri_wfrps_ri a, giri_wfrperil b
                               WHERE a.line_cd = b.line_cd
                                 AND a.frps_yy = b.frps_yy
                                 AND a.frps_seq_no = b.frps_seq_no
                                 AND a.ri_cd = b.ri_cd
                                 AND a.ri_seq_no = b.ri_seq_no
                                 AND b.line_cd = p_line_cd
                                 AND b.frps_yy = p_frps_yy
                                 AND b.frps_seq_no = p_frps_seq_no
                                 AND b.peril_cd = perilds.peril_cd
                                 AND ABS (b.ri_tsi_amt) >= ABS (v_discrep_tsi)
                                 AND NOT EXISTS (
                                        SELECT 1
                                          FROM giri_frps_ri tx
                                         WHERE tx.fnl_binder_id =
                                                               a.pre_binder_id)
                            ORDER BY a.ri_seq_no DESC)
               LOOP
                  v_max_ri := ricd.ri_cd;
                  v_max_ri_seq := ricd.ri_seq_no;
                  EXIT;
               END LOOP;

               UPDATE giri_wfrperil
                  SET ri_tsi_amt = ri_tsi_amt + v_discrep_tsi
                WHERE line_cd = p_line_cd
                  AND frps_yy = p_frps_yy
                  AND frps_seq_no = p_frps_seq_no
                  AND ri_cd = v_max_ri
                  AND ri_seq_no = v_max_ri_seq
                  AND peril_cd = perilds.peril_cd;
            END IF;

            IF ABS (v_discrep_prem) <= v_adjust_limit AND v_discrep_prem <> 0
            THEN
               v_max_ri := NULL;
               v_max_ri_seq := NULL;

               FOR ricd IN (SELECT   a.ri_cd, a.ri_seq_no
                                FROM giri_wfrps_ri a, giri_wfrperil b
                               WHERE a.line_cd = b.line_cd
                                 AND a.frps_yy = b.frps_yy
                                 AND a.frps_seq_no = b.frps_seq_no
                                 AND a.ri_cd = b.ri_cd
                                 AND a.ri_seq_no = b.ri_seq_no
                                 AND b.line_cd = p_line_cd
                                 AND b.frps_yy = p_frps_yy
                                 AND b.frps_seq_no = p_frps_seq_no
                                 AND b.peril_cd = perilds.peril_cd
                                 AND ABS (b.ri_prem_amt) >=
                                                          ABS (v_discrep_prem)
                                 AND NOT EXISTS (
                                        SELECT 1
                                          FROM giri_frps_ri tx
                                         WHERE tx.fnl_binder_id =
                                                               a.pre_binder_id)
                            ORDER BY a.ri_seq_no DESC)
               LOOP
                  v_max_ri := ricd.ri_cd;
                  v_max_ri_seq := ricd.ri_seq_no;
                  EXIT;
               END LOOP;

               UPDATE giri_wfrperil
                  SET ri_prem_amt = ri_prem_amt + v_discrep_prem
                WHERE line_cd = p_line_cd
                  AND frps_yy = p_frps_yy
                  AND frps_seq_no = p_frps_seq_no
                  AND ri_cd = v_max_ri
                  AND ri_seq_no = v_max_ri_seq
                  AND peril_cd = perilds.peril_cd;
            END IF;
         END LOOP;
-- end sumfrperil for loop                                                                                                                                                                     --sumfrperil
      END LOOP;

-- end perilds for loop                                                                                                                                                                           --perilds
      v_last_ri_seq := 0;
      v_last_ri_cd := 0;

      FOR ri IN (SELECT   x.ri_seq_no, x.ri_cd
                     FROM giri_wfrps_ri x
                    WHERE x.line_cd = p_line_cd
                      AND x.frps_yy = p_frps_yy
                      AND x.frps_seq_no = p_frps_seq_no
                      AND NOT EXISTS (SELECT 1
                                        FROM giri_frps_ri y
                                       WHERE y.fnl_binder_id = x.pre_binder_id)
                 ORDER BY ri_seq_no DESC)
      LOOP
         v_last_ri_seq := ri.ri_seq_no;
         v_last_ri_cd := ri.ri_cd;
         EXIT;
      END LOOP;

-- **************************************************************************************************
-- ## adjust the frperil so that the frps_ri should tally with frperil
      FOR frps_ri IN (SELECT   ri_tsi_amt, ri_prem_amt, ri_cd, ri_seq_no,
                               pre_binder_id
                          FROM giri_wfrps_ri x
                         WHERE x.line_cd = p_line_cd
                           AND x.frps_yy = p_frps_yy
                           AND x.frps_seq_no = p_frps_seq_no
                           --  AND x.ri_seq_no < v_last_ri_seq
                           AND NOT EXISTS (
                                       SELECT 1
                                         FROM giri_frps_ri y
                                        WHERE y.fnl_binder_id =
                                                               x.pre_binder_id)
                      ORDER BY x.ri_seq_no ASC, x.ri_cd)
      LOOP
         v_discrep_tsi := 0;
         v_discrep_prem := 0;

         IF frps_ri.ri_seq_no < v_last_ri_seq
         THEN
            FOR frperil IN (SELECT SUM (DECODE (b.peril_type,
                                                'B', NVL (ri_tsi_amt, 0),
                                                0
                                               )
                                       ) sum_tsi,
                                   SUM (NVL (ri_prem_amt, 0)) sum_prem
                              FROM giri_wfrperil a, giis_peril b
                             WHERE 1 = 1
                               AND a.line_cd = b.line_cd
                               AND a.peril_cd = b.peril_cd
                               AND a.line_cd = p_line_cd
                               AND a.frps_yy = p_frps_yy
                               AND a.frps_seq_no = p_frps_seq_no
                               AND a.ri_cd = frps_ri.ri_cd
                               AND a.ri_seq_no = frps_ri.ri_seq_no)
            LOOP
               IF frps_ri.ri_tsi_amt <> frperil.sum_tsi
               THEN
                  v_discrep_tsi :=
                        NVL (frps_ri.ri_tsi_amt, 0)
                        - NVL (frperil.sum_tsi, 0);
               END IF;

               IF frps_ri.ri_prem_amt <> frperil.sum_prem
               THEN
                  v_discrep_prem :=
                      NVL (frps_ri.ri_prem_amt, 0)
                      - NVL (frperil.sum_prem, 0);
               END IF;

--         END LOOP;                          -- end frperil for loop ( second )
               DBMS_OUTPUT.put_line ('Discrepancy for TSI : ' || v_discrep_tsi);
               DBMS_OUTPUT.put_line (   'Discrepancy for Premium : '
                                     || v_discrep_prem
                                    );
               -- query which peril can be adjusted for TSI
               v_tsi_adjusted := FALSE;
               v_max_ri := 0;
               v_max_ri_seq := 0;
               v_temp_peril_cd := NULL;

               IF v_discrep_tsi <> 0 AND ABS (v_discrep_tsi) <= v_adjust_limit
               THEN
                  DBMS_OUTPUT.put_line
                               ('Adjusting FRPERIL TSI for one reinsurer....');

                  FOR peril IN (SELECT   t2.peril_cd, t2.dist_tsi,
                                         t2.dist_prem, t2.dist_spct
                                    FROM giuw_perilds_dtl t2,
                                         giis_dist_share t3,
                                         giis_peril t4
                                   WHERE 1 = 1
                                     AND t2.line_cd = t3.line_cd
                                     AND t2.share_cd = t3.share_cd
                                     AND t3.share_type = '3'
                                     AND t2.line_cd = t4.line_cd
                                     AND t2.peril_cd = t4.peril_cd
                                     AND t2.dist_no = p_dist_no
                                     AND t2.dist_seq_no = p_dist_seq_no
                                     AND t4.peril_type = 'B'
                                     AND t2.dist_tsi <> 0
                                ORDER BY t2.peril_cd)
                  LOOP
                     v_max_ri := 0;
                     v_max_ri_seq := 0;
                     v_exists := 'N';

--            WHILE NOT v_tsi_adjusted
--            LOOP
                     FOR ricd IN (SELECT   b.peril_cd
                                      FROM giri_wfrps_ri a,
                                           giri_wfrperil b,
                                           giis_peril c
                                     WHERE a.line_cd = b.line_cd
                                       AND a.frps_yy = b.frps_yy
                                       AND a.frps_seq_no = b.frps_seq_no
                                       AND a.ri_cd = b.ri_cd
                                       AND a.ri_seq_no = b.ri_seq_no
                                       AND b.line_cd = c.line_cd
                                       AND b.peril_cd = c.peril_cd
                                       AND c.peril_type = 'B'
                                       AND b.line_cd = p_line_cd
                                       AND b.frps_yy = p_frps_yy
                                       AND b.frps_seq_no = p_frps_seq_no
                                       AND b.ri_cd = frps_ri.ri_cd
                                       AND b.ri_seq_no = frps_ri.ri_seq_no
                                       AND b.peril_cd > peril.peril_cd
                                       AND ABS (b.ri_tsi_amt) >=
                                                           ABS (v_discrep_tsi)
                                  ORDER BY b.peril_cd ASC)
                     LOOP
                        v_exists := 'Y';
                        EXIT;
                     END LOOP;

                     IF v_exists = 'Y'
                     THEN
                        NULL;

                        FOR ricd IN
                           (SELECT   a.ri_cd, a.ri_seq_no
                                FROM giri_wfrps_ri a, giri_wfrperil b
                               WHERE a.line_cd = b.line_cd
                                 AND a.frps_yy = b.frps_yy
                                 AND a.frps_seq_no = b.frps_seq_no
                                 AND a.ri_cd = b.ri_cd
                                 AND a.ri_seq_no = b.ri_seq_no
                                 AND b.line_cd = p_line_cd
                                 AND b.frps_yy = p_frps_yy
                                 AND b.frps_seq_no = p_frps_seq_no
                                 AND b.peril_cd = peril.peril_cd
                                 AND ABS (b.ri_tsi_amt) >= ABS (v_discrep_tsi)
                                 AND a.ri_seq_no > frps_ri.ri_seq_no
                                 AND NOT EXISTS (
                                        SELECT 1
                                          FROM giri_frps_ri tx
                                         WHERE tx.fnl_binder_id =
                                                               a.pre_binder_id)
                            ORDER BY a.ri_seq_no DESC)
                        LOOP
                           v_max_ri := ricd.ri_cd;
                           v_max_ri_seq := ricd.ri_seq_no;
                           EXIT;
                        END LOOP;

                        IF NVL (v_max_ri_seq, 0) > 0
                        THEN
                           UPDATE giri_wfrperil
                              SET ri_tsi_amt = ri_tsi_amt + v_discrep_tsi
                            WHERE line_cd = p_line_cd
                              AND frps_yy = p_frps_yy
                              AND frps_seq_no = p_frps_seq_no
                              AND ri_cd = frps_ri.ri_cd
                              AND ri_seq_no = frps_ri.ri_seq_no
                              AND peril_cd = v_temp_peril_cd;

                           -- max peril ...last ri... -discrep
                           UPDATE giri_wfrperil
                              SET ri_tsi_amt = ri_tsi_amt - v_discrep_tsi
                            WHERE line_cd = p_line_cd
                              AND frps_yy = p_frps_yy
                              AND frps_seq_no = p_frps_seq_no
                              AND ri_cd = v_max_ri
                              AND ri_seq_no = v_max_ri_seq
                              AND peril_cd = v_temp_peril_cd;

                           v_tsi_adjusted := TRUE;
                        END IF;

                        IF v_tsi_adjusted
                        THEN
                           EXIT;
                        END IF;
--            END LOOP;                          -- end while not v_tsi_adjusted
                     END IF;
                  END LOOP;
               END IF;

               -- query which peril can be adjusted for premium
               v_prem_adjusted := FALSE;
               v_max_ri := 0;
               v_max_ri_seq := 0;
               v_temp_peril_cd := NULL;

               IF v_discrep_prem <> 0
                  AND ABS (v_discrep_prem) <= v_adjust_limit
               THEN
                  DBMS_OUTPUT.put_line
                           ('Adjusting FRPERIL PREMIUM for one reinsurer....');

                  FOR peril IN (SELECT   t2.peril_cd, t2.dist_tsi,
                                         t2.dist_prem, t2.dist_spct
                                    FROM giuw_perilds_dtl t2,
                                         giis_dist_share t3
                                   WHERE 1 = 1
                                     AND t2.line_cd = t3.line_cd
                                     AND t2.share_cd = t3.share_cd
                                     AND t3.share_type = '3'
                                     AND t2.dist_no = p_dist_no
                                     AND t2.dist_seq_no = p_dist_seq_no
                                     AND t2.dist_prem <> 0
                                ORDER BY t2.peril_cd)
                  LOOP
                     v_max_ri := 0;
                     v_max_ri_seq := 0;
                     v_exists := 'N';

                     FOR ricd IN (SELECT b.peril_cd
                                    FROM giri_wfrps_ri a,
                                         giri_wfrperil b,
                                         giis_peril c
                                   WHERE a.line_cd = b.line_cd
                                     AND a.frps_yy = b.frps_yy
                                     AND a.frps_seq_no = b.frps_seq_no
                                     AND a.ri_cd = b.ri_cd
                                     AND a.ri_seq_no = b.ri_seq_no
                                     AND b.line_cd = c.line_cd
                                     AND b.peril_cd = c.peril_cd
                                     AND b.line_cd = p_line_cd
                                     AND b.frps_yy = p_frps_yy
                                     AND b.frps_seq_no = p_frps_seq_no
                                     AND b.ri_cd = frps_ri.ri_cd
                                     AND b.ri_seq_no = frps_ri.ri_seq_no
                                     AND b.peril_cd = peril.peril_cd
                                     AND ABS (b.ri_prem_amt) >=
                                                          ABS (v_discrep_prem))
                     LOOP
                        v_exists := 'Y';
                        EXIT;
                     END LOOP;

                     IF v_exists = 'Y'
                     THEN
                        FOR ricd IN
                           (SELECT   a.ri_cd, a.ri_seq_no
                                FROM giri_wfrps_ri a, giri_wfrperil b
                               WHERE a.line_cd = b.line_cd
                                 AND a.frps_yy = b.frps_yy
                                 AND a.frps_seq_no = b.frps_seq_no
                                 AND a.ri_cd = b.ri_cd
                                 AND a.ri_seq_no = b.ri_seq_no
                                 AND b.line_cd = p_line_cd
                                 AND b.frps_yy = p_frps_yy
                                 AND b.frps_seq_no = p_frps_seq_no
                                 AND b.peril_cd = peril.peril_cd
                                 AND ABS (b.ri_prem_amt) >=
                                                          ABS (v_discrep_prem)
                                 AND a.ri_seq_no > frps_ri.ri_seq_no
                                 AND NOT EXISTS (
                                        SELECT 1
                                          FROM giri_frps_ri tx
                                         WHERE tx.fnl_binder_id =
                                                               a.pre_binder_id)
                            ORDER BY a.ri_seq_no DESC)
                        LOOP
                           v_max_ri := ricd.ri_cd;
                           v_max_ri_seq := ricd.ri_seq_no;
                           EXIT;
                        END LOOP;

                        IF NVL (v_max_ri_seq, 0) > 0
                        THEN
                           DBMS_OUTPUT.put_line
                              ('Adjusting premium of one peril and two reinsurers....'
                              );

                           UPDATE giri_wfrperil
                              SET ri_prem_amt = ri_prem_amt + v_discrep_prem
                            WHERE line_cd = p_line_cd
                              AND frps_yy = p_frps_yy
                              AND frps_seq_no = p_frps_seq_no
                              AND ri_cd = frps_ri.ri_cd
                              AND ri_seq_no = frps_ri.ri_seq_no
                              AND peril_cd = v_temp_peril_cd;

                           -- max peril ...last ri... -discrep
                           UPDATE giri_wfrperil
                              SET ri_prem_amt = ri_prem_amt - v_discrep_prem
                            WHERE line_cd = p_line_cd
                              AND frps_yy = p_frps_yy
                              AND frps_seq_no = p_frps_seq_no
                              AND ri_cd = v_max_ri
                              AND ri_seq_no = v_max_ri_seq
                              AND peril_cd = v_temp_peril_cd;

                           v_prem_adjusted := TRUE;
                        END IF;

                        IF v_prem_adjusted
                        THEN
                           EXIT;
                        END IF;
                     END IF;
                  END LOOP;
               END IF;
            --
            END LOOP;

            -- adjust frps ri based on frperil
            FOR cur IN (SELECT SUM (NVL (a.ri_tsi_amt, 0)) ri_tsi_amt
                          FROM giri_wfrperil a, giis_peril b
                         WHERE a.line_cd = b.line_cd
                           AND a.peril_cd = b.peril_cd
                           AND a.line_cd = p_line_cd
                           AND a.frps_yy = p_frps_yy
                           AND a.frps_seq_no = p_frps_seq_no
                           AND a.ri_seq_no = frps_ri.ri_seq_no
                           AND a.ri_cd = frps_ri.ri_cd
                           AND b.peril_type = 'B')
            LOOP
               IF ABS (NVL (frps_ri.ri_tsi_amt, 0) - cur.ri_tsi_amt) <=
                                                               v_adjust_limit
               THEN
                  UPDATE giri_wfrps_ri
                     SET ri_tsi_amt = cur.ri_tsi_amt
                   WHERE line_cd = p_line_cd
                     AND frps_yy = p_frps_yy
                     AND frps_seq_no = p_frps_seq_no
                     AND ri_seq_no = frps_ri.ri_seq_no
                     AND ri_cd = frps_ri.ri_cd;
               END IF;
            END LOOP;

            FOR cur IN (SELECT SUM (NVL (a.ri_prem_amt, 0)) ri_prem_amt
                          FROM giri_wfrperil a
                         WHERE 1 = 1
                           AND a.line_cd = p_line_cd
                           AND a.frps_yy = p_frps_yy
                           AND a.frps_seq_no = p_frps_seq_no
                           AND a.ri_seq_no = frps_ri.ri_seq_no
                           AND a.ri_cd = frps_ri.ri_cd)
            LOOP
               IF ABS (NVL (frps_ri.ri_prem_amt, 0) - cur.ri_prem_amt) <=
                                                               v_adjust_limit
               THEN
                  UPDATE giri_wfrps_ri
                     SET ri_prem_amt = cur.ri_prem_amt
                   WHERE line_cd = p_line_cd
                     AND frps_yy = p_frps_yy
                     AND frps_seq_no = p_frps_seq_no
                     AND ri_seq_no = frps_ri.ri_seq_no
                     AND ri_cd = frps_ri.ri_cd;
               END IF;
            END LOOP;
         ELSE
            -- adjust frps ri based on frperil
            FOR cur IN (SELECT SUM (NVL (a.ri_tsi_amt, 0)) ri_tsi_amt
                          FROM giri_wfrperil a, giis_peril b
                         WHERE a.line_cd = b.line_cd
                           AND a.peril_cd = b.peril_cd
                           AND a.line_cd = p_line_cd
                           AND a.frps_yy = p_frps_yy
                           AND a.frps_seq_no = p_frps_seq_no
                           AND a.ri_seq_no = frps_ri.ri_seq_no
                           AND a.ri_cd = frps_ri.ri_cd
                           AND b.peril_type = 'B')
            LOOP
               IF ABS (NVL (frps_ri.ri_tsi_amt, 0) - cur.ri_tsi_amt) <=
                                                               v_adjust_limit
               THEN
                  UPDATE giri_wfrps_ri
                     SET ri_tsi_amt = cur.ri_tsi_amt
                   WHERE line_cd = p_line_cd
                     AND frps_yy = p_frps_yy
                     AND frps_seq_no = p_frps_seq_no
                     AND ri_seq_no = frps_ri.ri_seq_no
                     AND ri_cd = frps_ri.ri_cd;
               END IF;
            END LOOP;

            FOR cur IN (SELECT SUM (NVL (a.ri_prem_amt, 0)) ri_prem_amt
                          FROM giri_wfrperil a
                         WHERE 1 = 1
                           AND a.line_cd = p_line_cd
                           AND a.frps_yy = p_frps_yy
                           AND a.frps_seq_no = p_frps_seq_no
                           AND a.ri_seq_no = frps_ri.ri_seq_no
                           AND a.ri_cd = frps_ri.ri_cd)
            LOOP
               IF ABS (NVL (frps_ri.ri_prem_amt, 0) - cur.ri_prem_amt) <=
                                                               v_adjust_limit
               THEN
                  UPDATE giri_wfrps_ri
                     SET ri_prem_amt = cur.ri_prem_amt
                   WHERE line_cd = p_line_cd
                     AND frps_yy = p_frps_yy
                     AND frps_seq_no = p_frps_seq_no
                     AND ri_seq_no = frps_ri.ri_seq_no
                     AND ri_cd = frps_ri.ri_cd;
               END IF;
            END LOOP;
         END IF;
      END LOOP;
   END adjust_binder_amounts;


   PROCEDURE adjust_ri_comm_and_taxes (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE
   )
   IS
      CURSOR tmp_area
      IS
         SELECT   x.ri_cd, x.ri_seq_no,
                  SUM (NVL (x.ri_comm_amt, 0)) ri_comm_amt,
                  SUM (NVL (x.ri_comm_vat, 0)) ri_comm_vat,
                  SUM (NVL (x.ri_prem_vat, 0)) ri_prem_vat,
                  SUM (NVL (x.prem_tax, 0)) prem_tax
             FROM giri_wfrperil x, giri_wfrps_ri t
            WHERE x.line_cd = p_line_cd
              AND x.frps_yy = p_frps_yy
              AND x.frps_seq_no = p_frps_seq_no
              AND x.line_cd = t.line_cd
              AND x.frps_yy = t.frps_yy
              AND x.frps_seq_no = t.frps_seq_no
              AND x.ri_seq_no = t.ri_seq_no
              AND x.ri_cd = t.ri_cd
              AND NOT EXISTS (SELECT 1
                                FROM giri_frps_ri q
                               WHERE q.fnl_binder_id = t.pre_binder_id)
         GROUP BY x.line_cd, x.frps_yy, x.frps_seq_no, x.ri_cd, x.ri_seq_no;
   BEGIN
      FOR c1_rec IN tmp_area
      LOOP
         UPDATE giri_wfrps_ri
            SET ri_comm_amt = c1_rec.ri_comm_amt,
                ri_comm_rt =
                   ROUND (  (  NVL (c1_rec.ri_comm_amt, 0)
                             / DECODE (ri_prem_amt, 0, 1, ri_prem_amt)
                            )
                          * 100,
                          9
                         ),
                ri_comm_vat = c1_rec.ri_comm_vat,
                ri_prem_vat = c1_rec.ri_prem_vat,
                prem_tax = c1_rec.prem_tax
          WHERE line_cd = p_line_cd
            AND frps_yy = p_frps_yy
            AND frps_seq_no = p_frps_seq_no
            AND ri_cd = c1_rec.ri_cd
            AND ri_seq_no = c1_rec.ri_seq_no;
      END LOOP;
   END adjust_ri_comm_and_taxes;

   FUNCTION check_if_peril_dist (p_dist_no giri_distfrps.dist_no%TYPE)
      RETURN BOOLEAN
/*Created by Melvin John O. Ostia 07152014*/
   IS
      p_dist   BOOLEAN := FALSE;
   BEGIN
      FOR i IN (SELECT 1
                  FROM giuw_wperilds_dtl a
                 WHERE dist_no = p_dist_no
                   AND EXISTS (
                          SELECT 1
                            FROM giuw_wpolicyds_dtl b
                           WHERE b.dist_no = a.dist_no
                             AND b.share_cd = a.share_cd
                             AND b.dist_seq_no = a.dist_seq_no
                             AND (   NVL(b.dist_spct,0) <> NVL(a.dist_spct,0)
                                  OR (NVL (b.dist_spct1, NVL(b.dist_spct,0)) <>
                                               NVL (a.dist_spct1, NVL(a.dist_spct,0))
                                     )
                                 )))
      LOOP
         p_dist := TRUE;                --meaning, this is peril distribution
         EXIT;
      END LOOP;

      RETURN (p_dist);
   END;                                      --end of CHECK_ONERISK_PERIL_DIST
   
 
END;
/


