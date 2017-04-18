CREATE OR REPLACE PACKAGE BODY CPI.BINDER_ADJUST_WEB_PKG
AS
   PROCEDURE offset_adjustment_pkg (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE
   )
/* Created by Melvin John O. Ostia 07152014
** new offsetting process of binder
**
** Applied by Bonok
** 09.25.2014
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

      correct_unrvrsd_bndr_rcrds (p_line_cd, p_frps_yy, p_frps_seq_no);

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

         -- due to possible changes in amounts due to adjustment, it is necessary to recompute the amounts
         DBMS_OUTPUT.put_line (' Recomputing RI Taxes nad Commission .....');
         recompute_ri_taxes_and_comm (p_line_cd,
                                      p_frps_yy,
                                      p_frps_seq_no,
                                      v_iss_cd,
                                      v_dist_no
                                     );
         DBMS_OUTPUT.put_line
                 (' Adjusting FRPS RI and FRPERIL commission and taxes  .....');
         adjust_ri_comm_and_taxes (p_line_cd, p_frps_yy, p_frps_seq_no);
      ELSE
         adjust_ri_comm_and_taxes (p_line_cd, p_frps_yy, p_frps_seq_no);
      END IF;
   END offset_adjustment_pkg;                  -- end of offset_adjustment_pkg

   PROCEDURE adjust_ri_shr_pct (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE,
      p_dist_no       giri_wdistfrps.dist_no%TYPE,
      p_dist_seq_no   giri_wdistfrps.dist_seq_no%TYPE
   )
   AS
/* Created by Melvin John O. Ostia 07172014
** to adjust the last ri_seq_no of peril if discrepancy occur
*/
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
   END;                                             --end of adjust_ri_shr_pct

   PROCEDURE check_dist_exist (p_dist_no giuw_pol_dist.dist_no%TYPE)
   AS
      /* created by Melvin John O, Ostia 07182014
      ** to delete records in working dist table if last frps is being posted
      */
      v_count   NUMBER (5);
   BEGIN
      SELECT COUNT (frps_seq_no)
        INTO v_count
        FROM giri_wdistfrps
       WHERE dist_no = p_dist_no;

      IF v_count = 0
      THEN
         DELETE FROM giuw_witemperilds_dtl
               WHERE dist_no = p_dist_no;

         DELETE FROM giuw_wperilds_dtl
               WHERE dist_no = p_dist_no;

         DELETE FROM giuw_witemds_dtl
               WHERE dist_no = p_dist_no;

         DELETE FROM giuw_wpolicyds_dtl
               WHERE dist_no = p_dist_no;

         DELETE FROM giuw_witemperilds
               WHERE dist_no = p_dist_no;

         DELETE FROM giuw_wperilds
               WHERE dist_no = p_dist_no;

         DELETE FROM giuw_witemds
               WHERE dist_no = p_dist_no;

         DELETE FROM giuw_wpolicyds
               WHERE dist_no = p_dist_no;
      END IF;
   END;                                              --end of check_dist_exist

   PROCEDURE check_share_percent (p_dist_no giuw_pol_dist.dist_no%TYPE)
   AS
/* Created by Melvin John O. Ostia 07212014
** to check if there are discrepancy in share%
*/
   BEGIN
      FOR mel IN (SELECT   a.frps_seq_no, a.peril_cd, c.dist_seq_no,
                           SUM (a.ri_shr_pct) ri_shr_pct, c.dist_spct,
                           (SUM (a.ri_shr_pct) - c.dist_spct) discrep
                      FROM giri_wfrperil a,
                           giri_wdistfrps b,
                           giuw_perilds_dtl c
                     WHERE 1 = 1
                       AND a.line_cd = b.line_cd
                       AND a.frps_yy = b.frps_yy
                       AND a.frps_seq_no = b.frps_seq_no
                       AND b.dist_no = c.dist_no
                       AND b.dist_seq_no = c.dist_seq_no
                       AND a.line_cd = c.line_cd
                       AND a.peril_cd = c.peril_cd
                       AND c.share_cd = 999
                       AND b.dist_no = p_dist_no
                  GROUP BY a.frps_seq_no,
                           a.peril_cd,
                           c.dist_seq_no,
                           c.dist_spct
                  ORDER BY a.frps_seq_no, a.peril_cd)
      LOOP
         IF mel.discrep <> 0
         THEN
            raise_application_error
               (-20003,
                'There are discrepancy in share % between perilds_dtl and binder-peril tables. Please contact CPI.'
               );
         END IF;
      END LOOP;
   END;

   FUNCTION get_local_sw (p_ri_cd giis_reinsurer.ri_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_lf_sw   giis_reinsurer.local_foreign_sw%TYPE;
   BEGIN
      SELECT local_foreign_sw
        INTO v_lf_sw
        FROM giis_reinsurer
       WHERE ri_cd = p_ri_cd;

      RETURN NVL (v_lf_sw, 'L');
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_lf_sw := 'L';
         RETURN v_lf_sw;
   END;

   PROCEDURE adjust_prem_vat_new (
      p_prem_vat      IN OUT   NUMBER,
      p_ri_cd         IN       NUMBER,
      p_line_cd                giri_wdistfrps.line_cd%TYPE,
      p_frps_yy                giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no            giri_wdistfrps.frps_seq_no%TYPE
   )
   IS
         /* Created by Melvin John O. Ostia 08282014,
      ** to replace old procedure (ADJUST_PREM_VAT)
      */
      v_par_id       gipi_parlist.par_id%TYPE;
      v_par_status   gipi_parlist.par_status%TYPE;
      v_booking      DATE;
      v_pol_flag     gipi_polbasic.pol_flag%TYPE;
      v_prem_vat     VARCHAR2 (1)                                := 'N';
      v_acrpv        giis_parameters.param_value_v%TYPE;
      v_cpvf         giis_parameters.param_value_v%TYPE;
      v_loc_sw       giis_reinsurer.local_foreign_sw%TYPE;
      v_line_cd      giri_distfrps_wdistfrps_v.line_cd%TYPE;
      v_iss_cd       giri_distfrps_wdistfrps_v.iss_cd%TYPE;
      v_par_yy       giri_distfrps_wdistfrps_v.par_yy%TYPE;
      v_par_seq_no   giri_distfrps_wdistfrps_v.par_seq_no%TYPE;
      v_subline_cd   giri_distfrps_wdistfrps_v.subline_cd%TYPE;
      v_issue_yy     giri_distfrps_wdistfrps_v.issue_yy%TYPE;
      v_pol_seq_no   giri_distfrps_wdistfrps_v.pol_seq_no%TYPE;
      v_renew_no     giri_distfrps_wdistfrps_v.renew_no%TYPE;
   BEGIN
      FOR gr_dstfrps_wdstfrps_v IN (SELECT line_cd, iss_cd, par_yy,
                                           par_seq_no, subline_cd, issue_yy,
                                           pol_seq_no, renew_no
                                      FROM giri_distfrps_wdistfrps_v
                                     WHERE line_cd = p_line_cd
                                       AND frps_yy = p_frps_yy
                                       AND frps_seq_no = p_frps_seq_no)
      LOOP
         v_line_cd := gr_dstfrps_wdstfrps_v.line_cd;
         v_iss_cd := gr_dstfrps_wdstfrps_v.iss_cd;
         v_par_yy := gr_dstfrps_wdstfrps_v.par_yy;
         v_par_seq_no := gr_dstfrps_wdstfrps_v.par_seq_no;
         v_subline_cd := gr_dstfrps_wdstfrps_v.subline_cd;
         v_issue_yy := gr_dstfrps_wdstfrps_v.issue_yy;
         v_pol_seq_no := gr_dstfrps_wdstfrps_v.pol_seq_no;
         v_renew_no := gr_dstfrps_wdstfrps_v.renew_no;
      END LOOP;

      BEGIN
         SELECT NVL (param_value_v, 'N')
           INTO v_acrpv
           FROM giis_parameters
          WHERE param_name = 'AUTO_COMPUTE_RI_PREM_VAT';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_acrpv := 'N';
      END;

      BEGIN
         SELECT NVL (param_value_v, 'N')
           INTO v_cpvf
           FROM giis_parameters
          WHERE param_name = 'COMPUTE_PREM_VAT_FOREIGN';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_cpvf := 'N';
      END;

      BEGIN
         SELECT NVL (local_foreign_sw, 'L')
           INTO v_loc_sw
           FROM giis_reinsurer
          WHERE ri_cd = p_ri_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_loc_sw := 'L';
      END;

      FOR c1 IN (SELECT par_id, par_status
                   FROM gipi_parlist
                  WHERE line_cd = v_line_cd
                    AND iss_cd = v_iss_cd
                    AND par_yy = v_par_yy
                    AND par_seq_no = v_par_seq_no)
      LOOP
         v_par_id := c1.par_id;
         v_par_status := c1.par_status;
      END LOOP;

      IF v_par_status = 10
      THEN
         FOR c1 IN (SELECT booking_mth, booking_year, pol_flag
                      FROM gipi_polbasic
                     WHERE par_id = v_par_id)
         LOOP
            v_booking :=
               TO_DATE (c1.booking_mth || '/' || c1.booking_year,
                        'MONTH/YYYY'
                       );
            v_pol_flag := c1.pol_flag;
         END LOOP;
      ELSE
         FOR c1 IN (SELECT booking_mth, booking_year, pol_flag
                      FROM gipi_wpolbas
                     WHERE par_id = v_par_id)
         LOOP
            v_booking :=
               TO_DATE (c1.booking_mth || '/' || c1.booking_year,
                        'MONTH/YYYY'
                       );
            v_pol_flag := c1.pol_flag;
         END LOOP;
      END IF;

      FOR c1 IN (SELECT policy_id
                   FROM gipi_polbasic
                  WHERE line_cd = v_line_cd
                    AND subline_cd = v_subline_cd
                    AND iss_cd = v_iss_cd
                    AND issue_yy = v_issue_yy
                    AND pol_seq_no = v_pol_seq_no
                    AND renew_no = v_renew_no
                    AND endt_seq_no = 0)
      LOOP
         FOR c2 IN (SELECT 1
                      FROM giri_binder d,
                           giri_frps_ri c,
                           giri_distfrps b,
                           giuw_pol_dist a
                     WHERE d.fnl_binder_id = c.fnl_binder_id
                       AND d.reverse_date IS NULL
                       AND d.ri_cd = p_ri_cd
                       AND NVL (d.ri_prem_vat, 0) <> 0
                       AND c.line_cd = b.line_cd
                       AND c.frps_yy = b.frps_yy
                       AND c.frps_seq_no = b.frps_seq_no
                       AND b.dist_no = a.dist_no
                       AND a.policy_id = c1.policy_id)
         LOOP
            v_prem_vat := 'Y';
         END LOOP;
      END LOOP;

      IF v_acrpv = 'N'
      THEN
         p_prem_vat := 0;
      ELSE
         IF v_pol_flag = '4' AND v_prem_vat = 'N'
         THEN
            p_prem_vat := 0;
         ELSE                                              -- if pol flag <> 4
            IF v_loc_sw = 'L'
            THEN
               p_prem_vat := p_prem_vat;
            ELSE
               IF v_cpvf = 'Y'
               THEN
                  p_prem_vat := p_prem_vat;
               ELSE
                  p_prem_vat := 0;
               END IF;
            END IF;
         END IF;
      END IF;
   END;

   PROCEDURE correct_unrvrsd_bndr_rcrds (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE
   )
   /* Created by Melvin John O. Ostia 09052014
   ** To correct first the unreversed binder records if there are anomalies.
   */
   AS
      v_ri_flag   giri_wdistfrps.ri_flag%TYPE   := NULL;
   BEGIN
      FOR flg IN (SELECT ri_flag
                    FROM giri_distfrps
                   WHERE line_cd = p_line_cd
                     AND frps_yy = p_frps_yy
                     AND frps_seq_no = p_frps_seq_no)
      LOOP
         v_ri_flag := flg.ri_flag;
         EXIT;
      END LOOP;

      IF NVL (v_ri_flag, 1) = 3
      THEN
         FOR chck_pre_bndr_id IN (SELECT b.line_cd, b.frps_yy, b.frps_seq_no,
                                         b.ri_seq_no, b.ri_cd,
                                         a.pre_binder_id, b.ri_shr_pct,
                                         b.ri_shr_pct2, b.ri_tsi_amt,
                                         b.ri_prem_amt, b.ri_comm_rt,
                                         b.ri_comm_amt, b.ri_comm_vat,
                                         b.prem_tax, b.ri_prem_vat,
                                         b.fnl_binder_id
                                    FROM giri_wfrps_ri a, giri_frps_ri b
                                   WHERE a.line_cd = b.line_cd
                                     AND a.frps_yy = b.frps_yy
                                     AND a.frps_seq_no = b.frps_seq_no
                                     AND a.ri_seq_no = b.ri_seq_no
                                     AND a.ri_cd = b.ri_cd
                                     AND a.pre_binder_id = b.fnl_binder_id
                                     AND a.line_cd = p_line_cd
                                     AND a.frps_yy = p_frps_yy
                                     AND a.frps_seq_no = p_frps_seq_no
                                     AND NVL(b.reverse_sw,'N') = 'N'
                                     AND (   NVL (a.ri_shr_pct, 0) <>
                                                         NVL (b.ri_shr_pct, 0)
                                          OR NVL (a.ri_shr_pct2, 0) <>
                                                        NVL (b.ri_shr_pct2, 0)
                                          OR NVL (a.ri_tsi_amt, 0) <>
                                                         NVL (b.ri_tsi_amt, 0)
                                          OR NVL (a.ri_prem_amt, 0) <>
                                                        NVL (b.ri_prem_amt, 0)
                                          OR NVL (a.ri_comm_amt, 0) <>
                                                        NVL (b.ri_comm_amt, 0)
                                          OR NVL (a.ri_comm_vat, 0) <>
                                                        NVL (b.ri_comm_vat, 0)
                                          OR NVL (a.ri_prem_vat, 0) <>
                                                        NVL (b.ri_prem_vat, 0)
                                          OR NVL (a.prem_tax, 0) <>
                                                           NVL (b.prem_tax, 0)
                                          OR NVL (a.ri_comm_rt, 0) <>
                                                         NVL (b.ri_comm_rt, 0)
                                         ))
         LOOP
            UPDATE giri_wfrps_ri
               SET ri_tsi_amt = chck_pre_bndr_id.ri_tsi_amt,
                   ri_prem_amt = chck_pre_bndr_id.ri_prem_amt,
                   ri_comm_vat = chck_pre_bndr_id.ri_comm_vat,
                   ri_prem_vat = chck_pre_bndr_id.ri_prem_vat,
                   prem_tax = chck_pre_bndr_id.prem_tax,
                   ri_shr_pct = chck_pre_bndr_id.ri_shr_pct,
                   ri_shr_pct2 = chck_pre_bndr_id.ri_shr_pct2,
                   ri_comm_amt = chck_pre_bndr_id.ri_comm_amt,
                   ri_comm_rt = chck_pre_bndr_id.ri_comm_rt
             WHERE line_cd = chck_pre_bndr_id.line_cd
               AND frps_yy = chck_pre_bndr_id.frps_yy
               AND frps_seq_no = chck_pre_bndr_id.frps_seq_no
               AND ri_seq_no = chck_pre_bndr_id.ri_seq_no
               AND ri_cd = chck_pre_bndr_id.ri_cd
               AND pre_binder_id = chck_pre_bndr_id.fnl_binder_id;
         END LOOP;

         -- review giri_wfrperil
         /*FOR frperil IN (SELECT b.line_cd, b.frps_yy, b.frps_seq_no,
                                b.ri_seq_no, b.ri_cd, b.peril_cd,
                                b.ri_tsi_amt, b.ri_prem_amt, b.ri_comm_vat,
                                b.ri_comm_amt, b.ri_comm_rt, b.prem_tax,
                                b.ri_prem_vat, b.ri_shr_pct
                           FROM giri_wfrperil a, giri_frperil b
                          WHERE 1 = 1 
                            AND a.line_cd = p_line_cd
                            AND a.frps_yy = p_frps_yy
                            AND a.frps_seq_no = p_frps_seq_no
                            AND a.line_cd = b.line_cd
                            AND a.frps_yy = b.frps_yy
                            AND a.frps_seq_no = b.frps_seq_no
                            AND a.ri_seq_no = b.ri_seq_no
                            AND a.ri_cd = b.ri_cd
                            AND a.peril_cd = b.peril_cd
                            AND (   NVL (a.ri_shr_pct, 0) <>
                                                         NVL (b.ri_shr_pct, 0)
                                 OR NVL (a.ri_tsi_amt, 0) <>
                                                         NVL (b.ri_tsi_amt, 0)
                                 OR NVL (a.ri_prem_amt, 0) <>
                                                        NVL (b.ri_prem_amt, 0)
                                 OR NVL (a.ri_comm_rt, 0) <>
                                                         NVL (b.ri_comm_rt, 0)
                                 OR NVL (a.ri_comm_amt, 0) <>
                                                        NVL (b.ri_comm_amt, 0)
                                 OR NVL (a.ri_prem_vat, 0) <>
                                                        NVL (b.ri_prem_vat, 0)
                                 OR NVL (a.ri_comm_amt, 0) <>
                                                        NVL (b.ri_comm_amt, 0)
                                 OR NVL (a.prem_tax, 0) <> NVL (b.prem_tax, 0)
                                 OR NVL (a.ri_comm_rt, 0) <>
                                                         NVL (b.ri_comm_rt, 0)
                                ))
         LOOP
            UPDATE giri_wfrperil x
               SET ri_shr_pct = frperil.ri_shr_pct,
                   ri_tsi_amt = frperil.ri_tsi_amt,
                   ri_prem_amt = frperil.ri_prem_amt,
                   ri_comm_rt = frperil.ri_comm_rt,
                   ri_comm_amt = frperil.ri_comm_amt,
                   ri_prem_vat = frperil.ri_prem_vat,
                   ri_comm_vat = frperil.ri_comm_vat,
                   prem_tax = frperil.prem_tax
             WHERE x.line_cd = frperil.line_cd
               AND x.frps_yy = frperil.frps_yy
               AND x.frps_seq_no = frperil.frps_seq_no
               AND x.ri_seq_no = frperil.ri_seq_no
               AND x.ri_cd = frperil.ri_cd
               AND x.peril_cd = frperil.peril_cd;
         END LOOP;*/
      END IF;
   END;                             --end of correct_unreversed_binder_records

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
                             AND (   NVL(b.dist_spct, 0) <> NVL(a.dist_spct, 0)
                                  OR (NVL (b.dist_spct1, NVL(b.dist_spct, 0)) <>
                                               NVL (a.dist_spct1, NVL(a.dist_spct, 0))
                                     )
                                 )))
      LOOP
         p_dist := TRUE;                --meaning, this is peril distribution
         EXIT;
      END LOOP;

      RETURN (p_dist);
   END;                                      --end of CHECK_ONERISK_PERIL_DIST

   PROCEDURE recompute_peril_ri_shr (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE
   )
   AS
      /* Created by Melvin John O. Ostia 09052014
      ** to recompute the ri_shr_pct even from the start.
      */
      v_check_dist   BOOLEAN;
      v_dist_no      giri_distfrps.dist_no%TYPE;
   BEGIN
      FOR get_dist_no IN (SELECT dist_no
                            FROM giri_distfrps
                           WHERE line_cd = p_line_cd
                             AND frps_yy = p_frps_yy
                             AND frps_seq_no = p_frps_seq_no)
      LOOP
         v_dist_no := get_dist_no.dist_no;
      END LOOP;

      v_check_dist := check_if_peril_dist (v_dist_no);

      IF v_check_dist
      THEN
         FOR updt_wfrperil IN
            (SELECT ROUND ((a.ri_tsi_amt / b.tot_fac_tsi) * c.dist_spct,
                           9
                          ) ri_shr_pct,
                    a.ri_seq_no, a.ri_cd, c.peril_cd
               FROM giri_wfrps_ri a,
                    giri_wdistfrps b,
                    giuw_perilds_dtl c,
                    giuw_perilds d
              WHERE d.dist_no = c.dist_no
                AND d.dist_seq_no = c.dist_seq_no
                AND d.line_cd = c.line_cd
                AND d.peril_cd = c.peril_cd
                AND d.dist_no = b.dist_no
                AND d.dist_seq_no = b.dist_seq_no
                AND b.line_cd = a.line_cd
                AND b.frps_yy = a.frps_yy
                AND b.frps_seq_no = a.frps_seq_no
                AND b.dist_no = c.dist_no
                AND d.dist_seq_no = c.dist_seq_no
                AND c.share_cd = 999
                AND b.line_cd = p_line_cd
                AND b.frps_yy = p_frps_yy
                AND b.frps_seq_no = p_frps_seq_no
                AND a.pre_binder_id NOT IN (SELECT fnl_binder_id
                                              FROM giri_frps_ri))
         LOOP
            UPDATE giri_wfrperil
               SET ri_shr_pct = updt_wfrperil.ri_shr_pct
             WHERE line_cd = p_line_cd
               AND frps_yy = p_frps_yy
               AND frps_seq_no = p_frps_seq_no
               AND ri_seq_no = updt_wfrperil.ri_seq_no
               AND ri_cd = updt_wfrperil.ri_cd
               AND peril_cd = updt_wfrperil.peril_cd;
         END LOOP;
      END IF;
   END;

   PROCEDURE adjust_binder_amounts_old (                             -- renamed procedure to old. REPUBLICFULLWEB 21983
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
   END adjust_binder_amounts_old;
   
   PROCEDURE adjust_binder_amounts (                                      -- new adjustment procedure . REPUBLICFULLWEB 21983
      p_line_cd        giri_wdistfrps.line_cd%TYPE,
      p_frps_yy        giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no    giri_wdistfrps.frps_seq_no%TYPE,
      p_dist_no        giri_wdistfrps.dist_no%TYPE,
      p_dist_seq_no    giri_wdistfrps.dist_seq_no%TYPE)
   IS
      v_discrep_tsi     NUMBER := 0;
      v_discrep_prem    NUMBER := 0;
      v_discrep_spct    NUMBER := 0;
      v_max_ri          giis_reinsurer.ri_cd%TYPE;
      v_max_ri_seq      giri_wfrps_ri.ri_seq_no%TYPE;
      v_max_perl_1      giis_peril.peril_cd%TYPE;
      v_peril_cd        giis_peril.peril_cd%TYPE;
      v_param_value_n   giis_parameters.param_value_n%TYPE := 0;
      v_input_vat       giis_reinsurer.input_vat_rate%TYPE;
      v_last_ri_seq     giri_wfrps_ri.ri_seq_no%TYPE;
      v_last_ri_cd      giri_wfrps_ri.ri_cd%TYPE;
      v_adjust_limit    NUMBER (12, 9) := 0.5;
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
      v_amt1            giri_wfrps_ri.ri_tsi_amt%TYPE;
      v_amt2            giri_wfrps_ri.ri_tsi_amt%TYPE;
   BEGIN
      -- ## first correct the amount between GIUW_PERILDS_DTL and GIRI_WFRPERIL. These perils should be tally.
      -- ## Adjust the last encoded RI.
      FOR perilds
         IN (  SELECT t2.peril_cd,
                      t2.dist_tsi,
                      t2.dist_prem,
                      t4.peril_type
                 FROM giuw_perilds_dtl t2, giis_dist_share t3, giis_peril t4
                WHERE     1 = 1
                      AND t2.line_cd = t3.line_cd
                      AND t2.share_cd = t3.share_cd
                      AND t3.share_type = '3'
                      AND t2.dist_no = p_dist_no
                      AND t2.dist_seq_no = p_dist_seq_no
                      AND t2.line_cd = t4.line_cd
                      AND t2.peril_cd = t4.peril_cd
             ORDER BY t2.peril_cd)
      LOOP
         v_discrep_tsi := 0;
         v_discrep_prem := 0;

         FOR sumfrperil
            IN (SELECT SUM (NVL (ri_tsi_amt, 0)) sum_tsi,
                       SUM (NVL (ri_prem_amt, 0)) sum_prem,
                       SUM (NVL (ri_shr_pct, 0)) sum_shr_pct
                  FROM giri_wfrperil
                 WHERE     line_cd = p_line_cd
                       AND frps_yy = p_frps_yy
                       AND frps_seq_no = p_frps_seq_no
                       AND peril_cd = perilds.peril_cd)
         LOOP
            IF NVL (perilds.dist_tsi, 0) <> NVL (sumfrperil.sum_tsi, 0)
            THEN
               v_discrep_tsi :=
                  NVL (perilds.dist_tsi, 0) - NVL (sumfrperil.sum_tsi, 0);
            END IF;

            IF NVL (perilds.dist_prem, 0) <> NVL (sumfrperil.sum_prem, 0)
            THEN
               v_discrep_prem :=
                  NVL (perilds.dist_prem, 0) - NVL (sumfrperil.sum_prem, 0);
            END IF;
         END LOOP;

         v_max_ri := NULL;
         v_max_ri_seq := NULL;

         IF ABS (v_discrep_tsi) <= v_adjust_limit AND v_discrep_tsi <> 0
         THEN
            FOR ricd
               IN (  SELECT a.ri_cd, a.ri_seq_no
                       FROM giri_wfrps_ri a, giri_wfrperil b
                      WHERE     a.line_cd = b.line_cd
                            AND a.frps_yy = b.frps_yy
                            AND a.frps_seq_no = b.frps_seq_no
                            AND a.ri_cd = b.ri_cd
                            AND a.ri_seq_no = b.ri_seq_no
                            AND b.line_cd = p_line_cd
                            AND b.frps_yy = p_frps_yy
                            AND b.frps_seq_no = p_frps_seq_no
                            AND b.peril_cd = perilds.peril_cd
                            AND ABS (b.ri_tsi_amt) >= ABS (v_discrep_tsi)
                            AND NOT EXISTS
                                   (SELECT 1
                                      FROM giri_frps_ri tx
                                     WHERE tx.fnl_binder_id = a.pre_binder_id)
                   ORDER BY a.ri_seq_no DESC)
            LOOP
               v_max_ri := ricd.ri_cd;
               v_max_ri_seq := ricd.ri_seq_no;
               EXIT;
            END LOOP;

            IF v_max_ri IS NOT NULL
            THEN
               UPDATE giri_wfrperil
                  SET ri_tsi_amt = ri_tsi_amt + v_discrep_tsi
                WHERE     line_cd = p_line_cd
                      AND frps_yy = p_frps_yy
                      AND frps_seq_no = p_frps_seq_no
                      AND ri_cd = v_max_ri
                      AND ri_seq_no = v_max_ri_seq
                      AND peril_cd = perilds.peril_cd;
            END IF;
         END IF;

         v_max_ri := NULL;
         v_max_ri_seq := NULL;

         IF ABS (v_discrep_prem) <= v_adjust_limit AND v_discrep_prem <> 0
         THEN
            FOR ricd
               IN (  SELECT a.ri_cd, a.ri_seq_no
                       FROM giri_wfrps_ri a, giri_wfrperil b
                      WHERE     a.line_cd = b.line_cd
                            AND a.frps_yy = b.frps_yy
                            AND a.frps_seq_no = b.frps_seq_no
                            AND a.ri_cd = b.ri_cd
                            AND a.ri_seq_no = b.ri_seq_no
                            AND b.line_cd = p_line_cd
                            AND b.frps_yy = p_frps_yy
                            AND b.frps_seq_no = p_frps_seq_no
                            AND b.peril_cd = perilds.peril_cd
                            AND ABS (b.ri_prem_amt) >= ABS (v_discrep_prem)
                            AND NOT EXISTS
                                   (SELECT 1
                                      FROM giri_frps_ri tx
                                     WHERE tx.fnl_binder_id = a.pre_binder_id)
                   ORDER BY a.ri_seq_no DESC)
            LOOP
               v_max_ri := ricd.ri_cd;
               v_max_ri_seq := ricd.ri_seq_no;
               EXIT;
            END LOOP;

            IF v_max_ri IS NOT NULL
            THEN
               UPDATE giri_wfrperil
                  SET ri_prem_amt = ri_prem_amt + v_discrep_prem
                WHERE     line_cd = p_line_cd
                      AND frps_yy = p_frps_yy
                      AND frps_seq_no = p_frps_seq_no
                      AND ri_cd = v_max_ri
                      AND ri_seq_no = v_max_ri_seq
                      AND peril_cd = perilds.peril_cd;
            END IF;
         END IF;
      END LOOP;

      -- get the last reinsurer ( new binders)                                                                                                                                                                         --perilds
      v_last_ri_seq := 0;
      v_last_ri_cd := 0;

      FOR ri IN (  SELECT x.ri_seq_no, x.ri_cd
                     FROM giri_wfrps_ri x
                    WHERE     x.line_cd = p_line_cd
                          AND x.frps_yy = p_frps_yy
                          AND x.frps_seq_no = p_frps_seq_no
                          AND NOT EXISTS
                                 (SELECT 1
                                    FROM giri_frps_ri y
                                   WHERE y.fnl_binder_id = x.pre_binder_id)
                 ORDER BY ri_seq_no DESC)
      LOOP
         v_last_ri_seq := ri.ri_seq_no;
         v_last_ri_cd := ri.ri_cd;
         EXIT;
      END LOOP;

      -- compare frps_ri and frperil

      FOR frps_ri
         IN (  SELECT ri_tsi_amt,
                      ri_prem_amt,
                      ri_cd,
                      ri_seq_no,
                      pre_binder_id
                 FROM giri_wfrps_ri x
                WHERE     x.line_cd = p_line_cd
                      AND x.frps_yy = p_frps_yy
                      AND x.frps_seq_no = p_frps_seq_no
                      AND NOT EXISTS
                             (SELECT 1
                                FROM giri_frps_ri y
                               WHERE y.fnl_binder_id = x.pre_binder_id)
             ORDER BY x.ri_seq_no ASC, x.ri_cd)
      LOOP
         v_discrep_tsi := 0;
         v_discrep_prem := 0;

         -- for the last RI, just update the frps_ri to the total amt of frperil
         IF     frps_ri.ri_cd = v_last_ri_cd
            AND frps_ri.ri_seq_no = v_last_ri_seq
         THEN
            FOR cur
               IN (SELECT SUM (NVL (a.ri_tsi_amt, 0)) ri_tsi_amt
                     FROM giri_wfrperil a, giis_peril b
                    WHERE     a.line_cd = b.line_cd
                          AND a.peril_cd = b.peril_cd
                          AND a.line_cd = p_line_cd
                          AND a.frps_yy = p_frps_yy
                          AND a.frps_seq_no = p_frps_seq_no
                          AND a.ri_seq_no = frps_ri.ri_seq_no
                          AND a.ri_cd = frps_ri.ri_cd
                          AND b.peril_type = 'B')
            LOOP
               IF ABS (NVL (frps_ri.ri_tsi_amt, 0) - cur.ri_tsi_amt) <=
                     v_adjust_limit AND ABS (NVL (frps_ri.ri_tsi_amt, 0) - cur.ri_tsi_amt)  <> 0 
               THEN
                  UPDATE giri_wfrps_ri
                     SET ri_tsi_amt = cur.ri_tsi_amt
                   WHERE     line_cd = p_line_cd
                         AND frps_yy = p_frps_yy
                         AND frps_seq_no = p_frps_seq_no
                         AND ri_seq_no = frps_ri.ri_seq_no
                         AND ri_cd = frps_ri.ri_cd;
               END IF;
            END LOOP;

            FOR cur
               IN (SELECT SUM (NVL (a.ri_prem_amt, 0)) ri_prem_amt
                     FROM giri_wfrperil a
                    WHERE     1 = 1
                          AND a.line_cd = p_line_cd
                          AND a.frps_yy = p_frps_yy
                          AND a.frps_seq_no = p_frps_seq_no
                          AND a.ri_seq_no = frps_ri.ri_seq_no
                          AND a.ri_cd = frps_ri.ri_cd)
            LOOP
               IF ABS (NVL (frps_ri.ri_prem_amt, 0) - cur.ri_prem_amt) <=
                     v_adjust_limit AND ABS (NVL (frps_ri.ri_prem_amt, 0) - cur.ri_prem_amt)  <> 0 
               THEN
                  UPDATE giri_wfrps_ri
                     SET ri_prem_amt = cur.ri_prem_amt
                   WHERE     line_cd = p_line_cd
                         AND frps_yy = p_frps_yy
                         AND frps_seq_no = p_frps_seq_no
                         AND ri_seq_no = frps_ri.ri_seq_no
                         AND ri_cd = frps_ri.ri_cd;
               END IF;
            END LOOP;
         END IF;


         -- for other reinsurers ( not last encoded RI ), update the compare giri_wfrps_ri and giri_wfrperil and adjust giri_wfrperil 
         v_discrep_tsi := 0;
         v_discrep_prem := 0;
         FOR frperil
            IN (SELECT SUM (
                          DECODE (b.peril_type, 'B', NVL (ri_tsi_amt, 0), 0))
                          sum_tsi,
                       SUM (NVL (ri_prem_amt, 0)) sum_prem
                  FROM giri_wfrperil a, giis_peril b
                 WHERE     1 = 1
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
                  NVL (frps_ri.ri_tsi_amt, 0) - NVL (frperil.sum_tsi, 0);
            END IF;

            IF frps_ri.ri_prem_amt <> frperil.sum_prem
            THEN
               v_discrep_prem :=
                  NVL (frps_ri.ri_prem_amt, 0) - NVL (frperil.sum_prem, 0);
            END IF;
         END LOOP;


         v_max_ri := 0;
         v_max_ri_seq := 0;
         v_temp_peril_cd := NULL;

         IF v_discrep_tsi <> 0 AND ABS (v_discrep_tsi) <= v_adjust_limit
         THEN
            v_tsi_adjusted := FALSE;
            v_exists := 'N';


            FOR ricd2
               IN (  SELECT b.peril_cd
                       FROM giri_wfrps_ri a, giri_wfrperil b, giis_peril c
                      WHERE     a.line_cd = b.line_cd
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
                            AND ABS (b.ri_tsi_amt) >= ABS (v_discrep_tsi)
                   ORDER BY b.peril_cd ASC)
            LOOP
               v_temp_peril_cd := ricd2.peril_cd;
               EXIT;
            END LOOP;


            FOR ricd3
               IN (  SELECT a.ri_cd, a.ri_seq_no
                       FROM giri_wfrps_ri a, giri_wfrperil b, giis_peril c
                      WHERE     a.line_cd = b.line_cd
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
                            AND b.ri_seq_no > frps_ri.ri_seq_no
                            AND b.peril_cd = v_temp_peril_cd
                            AND ABS (b.ri_tsi_amt) >= ABS (v_discrep_tsi)
                            AND NOT EXISTS
                                   (SELECT 1
                                      FROM giri_frps_ri y
                                     WHERE y.fnl_binder_id = a.pre_binder_id)
                   ORDER BY a.ri_seq_no DESC)
            LOOP
               v_exists := 'Y';
               v_max_ri := ricd3.ri_cd;
               v_max_ri_seq := ricd3.ri_seq_no;
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               UPDATE giri_wfrperil
                  SET ri_tsi_amt = ri_tsi_amt + v_discrep_tsi
                WHERE     line_cd = p_line_cd
                      AND frps_yy = p_frps_yy
                      AND frps_seq_no = p_frps_seq_no
                      AND ri_cd = frps_ri.ri_cd
                      AND ri_seq_no = frps_ri.ri_seq_no
                      AND peril_cd = v_temp_peril_cd;

               -- max peril ...last ri... -discrep
               UPDATE giri_wfrperil
                  SET ri_tsi_amt = ri_tsi_amt - v_discrep_tsi
                WHERE     line_cd = p_line_cd
                      AND frps_yy = p_frps_yy
                      AND frps_seq_no = p_frps_seq_no
                      AND ri_cd = v_max_ri
                      AND ri_seq_no = v_max_ri_seq
                      AND peril_cd = v_temp_peril_cd;

               v_tsi_adjusted := TRUE;
            END IF;
         END IF;

         -- ADJUST PREMIUM
         v_max_ri := 0;
         v_max_ri_seq := 0;
         v_temp_peril_cd := NULL;

         IF v_discrep_prem <> 0 AND ABS (v_discrep_prem) <= v_adjust_limit
         THEN
            v_prem_adjusted := FALSE;
            v_exists := 'N';


            FOR ricd2
               IN (  SELECT b.peril_cd
                       FROM giri_wfrps_ri a, giri_wfrperil b, giis_peril c
                      WHERE     a.line_cd = b.line_cd
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
                            AND ABS (b.ri_prem_amt) >= ABS (v_discrep_prem)
                   ORDER BY b.peril_cd ASC)
            LOOP
               v_temp_peril_cd := ricd2.peril_cd;
               EXIT;
            END LOOP;


            FOR ricd3
               IN (  SELECT a.ri_cd, a.ri_seq_no
                       FROM giri_wfrps_ri a, giri_wfrperil b, giis_peril c
                      WHERE     a.line_cd = b.line_cd
                            AND a.frps_yy = b.frps_yy
                            AND a.frps_seq_no = b.frps_seq_no
                            AND a.ri_cd = b.ri_cd
                            AND a.ri_seq_no = b.ri_seq_no
                            AND b.line_cd = c.line_cd
                            AND b.peril_cd = c.peril_cd
                            AND b.line_cd = p_line_cd
                            AND b.frps_yy = p_frps_yy
                            AND b.frps_seq_no = p_frps_seq_no
                            AND b.ri_seq_no > frps_ri.ri_seq_no
                            AND b.peril_cd = v_temp_peril_cd
                            AND ABS (b.ri_prem_amt) >= ABS (v_discrep_prem)
                            AND NOT EXISTS
                                   (SELECT 1
                                      FROM giri_frps_ri y
                                     WHERE y.fnl_binder_id = a.pre_binder_id)
                   ORDER BY a.ri_seq_no DESC)
            LOOP
               v_exists := 'Y';
               v_max_ri := ricd3.ri_cd;
               v_max_ri_seq := ricd3.ri_seq_no;
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               UPDATE giri_wfrperil
                  SET ri_prem_amt = ri_prem_amt + v_discrep_prem
                WHERE     line_cd = p_line_cd
                      AND frps_yy = p_frps_yy
                      AND frps_seq_no = p_frps_seq_no
                      AND ri_cd = frps_ri.ri_cd
                      AND ri_seq_no = frps_ri.ri_seq_no
                      AND peril_cd = v_temp_peril_cd;

               -- max peril ...last ri... -discrep
               UPDATE giri_wfrperil
                  SET ri_prem_amt = ri_prem_amt - v_discrep_prem
                WHERE     line_cd = p_line_cd
                      AND frps_yy = p_frps_yy
                      AND frps_seq_no = p_frps_seq_no
                      AND ri_cd = v_max_ri
                      AND ri_seq_no = v_max_ri_seq
                      AND peril_cd = v_temp_peril_cd;

               v_prem_adjusted := TRUE;
            END IF;
         END IF;
     
      END LOOP;  -- end of loop of reinsurer
      
      -- add final adjustment of giri_wfrps_ri in relation to giri_wfrperil in case there are scenarios which cannot be handled by the 
      -- first codes. Note, in essence this code should no longer have an impact since it is expected that at the codes before this segment,
      -- frps_ri is already tally with frperil. The initial codes prevents the adjustment of giri_wfrps_ri - only giri_wfrperil is updated
      -- however in case there are still unhandled errors, we must ensure giri_wfrperil is still tally with giri_wfrps hence this code is added
      FOR frps_ri
         IN (  SELECT ri_tsi_amt,
                      ri_prem_amt,
                      ri_cd,
                      ri_seq_no,
                      pre_binder_id
                 FROM giri_wfrps_ri x
                WHERE     x.line_cd = p_line_cd
                      AND x.frps_yy = p_frps_yy
                      AND x.frps_seq_no = p_frps_seq_no
                      AND NOT EXISTS
                             (SELECT 1
                                FROM giri_frps_ri y
                               WHERE y.fnl_binder_id = x.pre_binder_id)
             ORDER BY x.ri_seq_no ASC, x.ri_cd)
      LOOP
         v_discrep_tsi := 0;
         v_discrep_prem := 0;

         FOR cur
               IN (SELECT SUM (NVL (a.ri_tsi_amt, 0)) ri_tsi_amt
                     FROM giri_wfrperil a, giis_peril b
                    WHERE     a.line_cd = b.line_cd
                          AND a.peril_cd = b.peril_cd
                          AND a.line_cd = p_line_cd
                          AND a.frps_yy = p_frps_yy
                          AND a.frps_seq_no = p_frps_seq_no
                          AND a.ri_seq_no = frps_ri.ri_seq_no
                          AND a.ri_cd = frps_ri.ri_cd
                          AND b.peril_type = 'B')
            LOOP
               IF ABS (NVL (frps_ri.ri_tsi_amt, 0) - cur.ri_tsi_amt) <=
                     v_adjust_limit AND ABS (NVL (frps_ri.ri_tsi_amt, 0) - cur.ri_tsi_amt) <> 0 
               THEN
                  UPDATE giri_wfrps_ri
                     SET ri_tsi_amt = cur.ri_tsi_amt
                   WHERE     line_cd = p_line_cd
                         AND frps_yy = p_frps_yy
                         AND frps_seq_no = p_frps_seq_no
                         AND ri_seq_no = frps_ri.ri_seq_no
                         AND ri_cd = frps_ri.ri_cd;
               END IF;
            END LOOP;

            FOR cur
               IN (SELECT SUM (NVL (a.ri_prem_amt, 0)) ri_prem_amt
                     FROM giri_wfrperil a
                    WHERE     1 = 1
                          AND a.line_cd = p_line_cd
                          AND a.frps_yy = p_frps_yy
                          AND a.frps_seq_no = p_frps_seq_no
                          AND a.ri_seq_no = frps_ri.ri_seq_no
                          AND a.ri_cd = frps_ri.ri_cd)
            LOOP
               IF ABS (NVL (frps_ri.ri_prem_amt, 0) - cur.ri_prem_amt) <=
                     v_adjust_limit AND ABS (NVL (frps_ri.ri_prem_amt, 0) - cur.ri_prem_amt) <> 0 
               THEN
                  UPDATE giri_wfrps_ri
                     SET ri_prem_amt = cur.ri_prem_amt
                   WHERE     line_cd = p_line_cd
                         AND frps_yy = p_frps_yy
                         AND frps_seq_no = p_frps_seq_no
                         AND ri_seq_no = frps_ri.ri_seq_no
                         AND ri_cd = frps_ri.ri_cd;
               END IF;
          END LOOP;
      END LOOP;         

   END adjust_binder_amounts;   

   PROCEDURE recompute_ri_taxes_and_comm (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE,
      p_iss_cd        gipi_parlist.iss_cd%TYPE,
      p_dist_no       giuw_pol_dist.dist_no%TYPE
   )
   IS
      v_ri_comm_vat_rate   giis_reinsurer.input_vat_rate%TYPE   := 0;
      v_prem_tax_rate      giis_reinsurer.int_tax_rt%TYPE       := 0;
      v_ri_prem_vat_rate   giis_reinsurer.input_vat_rate%TYPE   := 0;
   BEGIN
      FOR frps_ri IN (SELECT   x.ri_cd, x.ri_seq_no, x.line_cd, x.frps_yy,
                               x.frps_seq_no
                          FROM giri_wfrps_ri x
                         WHERE x.line_cd = p_line_cd
                           AND x.frps_yy = p_frps_yy
                           AND x.frps_seq_no = p_frps_seq_no
                           AND NOT EXISTS (
                                       SELECT 1
                                         FROM giri_frps_ri y
                                        WHERE y.fnl_binder_id =
                                                               x.pre_binder_id)
                      ORDER BY x.ri_seq_no, x.ri_cd)
      LOOP
         get_ri_taxes_multiplier (p_line_cd,
                                  p_frps_yy,
                                  p_frps_seq_no,
                                  p_iss_cd,
                                  frps_ri.ri_cd,
                                  v_ri_comm_vat_rate,
                                  v_ri_prem_vat_rate,
                                  v_prem_tax_rate,
                                  p_dist_no
                                 );

         UPDATE giri_wfrperil
            SET ri_comm_vat =
                   ROUND (  NVL (ri_comm_amt, 0)
                          * (NVL (v_ri_comm_vat_rate, 0) / 100),
                          2
                         ),
                ri_prem_vat =
                   ROUND (  NVL (ri_prem_amt, 0)
                          * (NVL (v_ri_prem_vat_rate, 0) / 100),
                          2
                         ),
                prem_tax =
                   ROUND (  NVL (ri_prem_amt, 0)
                          * (NVL (v_prem_tax_rate, 0) / 100),
                          2
                         )
          WHERE line_cd = frps_ri.line_cd
            AND frps_yy = frps_ri.frps_yy
            AND frps_seq_no = frps_ri.frps_seq_no
            AND ri_seq_no = frps_ri.ri_seq_no
            AND ri_cd = frps_ri.ri_cd;
      END LOOP;
   END recompute_ri_taxes_and_comm;

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

   PROCEDURE get_ri_taxes_multiplier (
      p_line_cd            IN       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy            IN       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no        IN       giri_wdistfrps.frps_seq_no%TYPE,
      p_iss_cd             IN       gipi_parlist.iss_cd%TYPE,
      p_ri_cd              IN       giis_reinsurer.ri_cd%TYPE,
      p_ri_comm_vat_rate   IN OUT   giis_reinsurer.input_vat_rate%TYPE,
      p_ri_prem_vat_rate   IN OUT   giis_reinsurer.input_vat_rate%TYPE,
      p_prem_tax_rate      IN OUT   giis_reinsurer.int_tax_rt%TYPE,
      p_dist_no            IN       giuw_pol_dist.dist_no%TYPE
   )
   IS
      v_input_vat_rate   giis_reinsurer.input_vat_rate%TYPE     := 0;
      v_int_tax_rt       giis_reinsurer.int_tax_rt%TYPE         := 0;
      v_ri_iss_cd        giis_parameters.param_value_v%TYPE;
      v_acrpv            giis_parameters.param_value_v%TYPE;
      v_cpvf             giis_parameters.param_value_v%TYPE;
      v_loc_sw           giis_reinsurer.local_foreign_sw%TYPE   := 'L';
      v_iss_cd           gipi_polbasic.iss_cd%TYPE;
      v_booking          DATE;
   BEGIN
      p_ri_comm_vat_rate := 0;
      p_ri_prem_vat_rate := 0;
      p_prem_tax_rate := 0;
      v_ri_iss_cd := NVL (giisp.v ('ISS_CD_RI'), 'RI');
      v_acrpv := NVL (giisp.v ('AUTO_COMPUTE_RI_PREM_VAT'), 'N');
      v_cpvf := NVL (giisp.v ('COMPUTE_PREM_VAT_FOREIGN'), 'N');

      FOR ri IN (SELECT local_foreign_sw, input_vat_rate, int_tax_rt
                   FROM giis_reinsurer
                  WHERE ri_cd = p_ri_cd)
      LOOP
         v_loc_sw := ri.local_foreign_sw;
         v_input_vat_rate := NVL (ri.input_vat_rate, 0);
         v_int_tax_rt := NVL (ri.int_tax_rt, 0);
      END LOOP;

      FOR a IN (SELECT a.iss_cd,
                       TO_DATE (a.booking_mth || '/' || a.booking_year,
                                'MONTH/YYYY'
                               ) booking
                  FROM gipi_polbasic a, giuw_pol_dist b
                 WHERE 1 = 1
                   AND a.policy_id = b.policy_id
                   AND b.dist_no = p_dist_no)
      LOOP
         v_iss_cd := a.iss_cd;
         v_booking := a.booking;
      END LOOP;

      -- GET THE RATE TO BE APPLIED FOR RI COMM VAT AND PREM TAX
      IF v_ri_iss_cd <> v_iss_cd
      THEN                                                          -- outward
         IF v_loc_sw <> 'L'
         THEN                                               --outward/foreign
            IF v_cpvf = 'Y'
            THEN                                          --outward/foreign/Y
               p_ri_comm_vat_rate := 0;
               p_prem_tax_rate := v_int_tax_rt;
            ELSE                                           --outward/foreign/N
               p_ri_comm_vat_rate := v_input_vat_rate;
               p_prem_tax_rate := 0;
            END IF;
         ELSE                                                  --outward/local
            p_ri_comm_vat_rate := v_input_vat_rate;
            p_prem_tax_rate := 0;
         END IF;
      ELSE                                                            --inward
         IF v_loc_sw <> 'L'
         THEN                                                --inward/foreign
            IF v_cpvf = 'Y'
            THEN
               -- p_ri_comm_vat_rate := v_input_vat_rate;     --inward/foreign/Y
               --p_prem_tax_rate := 0;
                /* jhing 10.01.2014 as per discussion with Ma'am Lunie computation of amounts in direct and inward binders are 
                -- the same. For them the foreign RI has no prem vat but has prem tax while local reinsurer has prem vat but no prem tax */
                 p_ri_comm_vat_rate := 0;
                 p_prem_tax_rate := v_int_tax_rt;
            ELSE          
             /* jhing 10.01.2014 as per discussion with Ma'am Lunie computation of amounts in direct and inward binders are 
                -- the same. For them the foreign RI has no prem vat but has prem tax while local reinsurer has prem vat but no prem tax */                                  --inward/foreign/N
--               p_ri_comm_vat_rate := 0;
--               p_prem_tax_rate := 0;
               p_ri_comm_vat_rate := v_input_vat_rate;
               p_prem_tax_rate := 0;
            END IF;
         ELSE                                                   --inward/local
            p_ri_comm_vat_rate := v_input_vat_rate;
            p_prem_tax_rate := 0;
         END IF;
      END IF;

      -- GET THE RATE TO BE APPLIED FOR RI PREM VAT
      /* jhing 10.01.2014 as per consultation with Ma'am Lunie computation of RI Prem VAT is the same for direct and inward
      however to make conditions flexible to accommodate further changes, conditions are separated for inward and direct */
      IF v_ri_iss_cd = v_iss_cd
      THEN
         IF v_cpvf = 'Y' 
         THEN
            IF v_loc_sw = 'L' THEN 
                p_ri_prem_vat_rate := v_input_vat_rate;
            ELSE
                p_ri_prem_vat_rate := 0 ; 
            END IF; 
         ELSE
            IF v_acrpv = 'Y' AND v_loc_sw = 'L'
            THEN
               p_ri_prem_vat_rate := v_input_vat_rate;
            ELSE
               p_ri_prem_vat_rate := 0;                      
            END IF;
         END IF;
      ELSE
         IF v_cpvf = 'Y'
         THEN
            IF v_loc_sw = 'L'
            THEN
               p_ri_prem_vat_rate := v_input_vat_rate;
            ELSE
               p_ri_prem_vat_rate := 0;
            END IF;
         ELSE
            IF v_acrpv = 'Y' AND v_loc_sw = 'L'
            THEN
               p_ri_prem_vat_rate := v_input_vat_rate;
            ELSE
               p_ri_prem_vat_rate := 0;                      
            END IF;
         END IF;
      END IF;
   END get_ri_taxes_multiplier;

   PROCEDURE update_ri_comm (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE
   )
   IS
   BEGIN
      NULL;
   END update_ri_comm;

END;
/


