CREATE OR REPLACE PACKAGE BODY CPI.giri_frps_ri_pkg
AS
   /*
   **  Created by       : Anthony Santos
   **  Date Created     : 06.29.2011
   **  Reference By     : (GIRIS026- Post FRPS
   **
   */
   PROCEDURE delete_mrecords_giris026 (
      p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE
   )
   IS
   BEGIN
      FOR c1_rec IN (SELECT fnl_binder_id, line_cd, frps_yy, frps_seq_no,
                            ri_seq_no
                       FROM giri_frps_ri
                      WHERE line_cd = p_line_cd
                        AND frps_yy = p_frps_yy
                        AND frps_seq_no = p_frps_seq_no
                        AND fnl_binder_id IN (
                               SELECT pre_binder_id
                                 FROM giri_wfrps_ri
                                WHERE line_cd = p_line_cd
                                  AND frps_yy = p_frps_yy
                                  AND frps_seq_no = p_frps_seq_no))
      LOOP
         DELETE FROM giri_binder_peril
               WHERE fnl_binder_id = c1_rec.fnl_binder_id;

         DELETE FROM giri_frperil
               WHERE line_cd = c1_rec.line_cd
                 AND frps_yy = c1_rec.frps_yy
                 AND frps_seq_no = c1_rec.frps_seq_no
                 AND ri_seq_no = c1_rec.ri_seq_no;

         DELETE FROM giri_frps_ri
               WHERE line_cd = c1_rec.line_cd
                 AND frps_yy = c1_rec.frps_yy
                 AND frps_seq_no = c1_rec.frps_seq_no
                 AND fnl_binder_id = c1_rec.fnl_binder_id;
      END LOOP;

      DELETE FROM giri_frps_peril_grp
            WHERE line_cd = p_line_cd
              AND frps_yy = p_frps_yy
              AND frps_seq_no = p_frps_seq_no;
   END delete_mrecords_giris026;

/*
   **  Created by       : Anthony Santos
   **  Date Created     : 06.29.2011
   **  Reference By     : (GIRIS026- Post FRPS
   **
   */
   PROCEDURE create_giri_frps_ri_binder (
      p_line_cd         giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy         giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no     giri_distfrps_wdistfrps_v.frps_seq_no%TYPE,
      p_dist_no         giri_distfrps_wdistfrps_v.dist_no%TYPE,
      p_iss_cd          giri_distfrps_wdistfrps_v.iss_cd%TYPE,
      p_par_policy_id   giri_distfrps_wdistfrps_v.par_policy_id%TYPE
   )
   IS
      v_line_cd         giri_wbinder.line_cd%TYPE;
      v_binder_yy       giri_wbinder.binder_yy%TYPE;
      v_binder_seq_no   giri_wbinder.binder_seq_no%TYPE;
      v_yy              NUMBER;
      v_curr_date       DATE;
      v_ri_cd           giri_wbinder.ri_cd%TYPE;
      v_eff_date        giri_wbinder.eff_date%TYPE;
      v_expiry_date     giri_wbinder.expiry_date%TYPE;
      v_attention       giri_wbinder.attention%TYPE;
      v_sysdate         DATE;
      v_fbndr_seq_no    giis_fbndr_seq.fbndr_seq_no%TYPE;
      insert_sw         VARCHAR2 (1)                       := 'Y';
      v_par_id          giuw_pol_dist.par_id%TYPE;
      v_policy_id       giuw_pol_dist.policy_id%TYPE;
      v_ri_prem_vat     giri_wbinder.ri_prem_vat%TYPE;
      v_ri_comm_vat     giri_wbinder.ri_comm_vat%TYPE;
      v_wholding_vat    giri_binder.ri_wholding_vat%TYPE;

      CURSOR frps_ri_area
      IS
         SELECT line_cd, frps_yy, frps_seq_no, ri_seq_no, t1.ri_cd,
                pre_binder_id, ri_shr_pct, ri_tsi_amt, ri_prem_amt,
                ann_ri_s_amt, ann_ri_pct, ri_comm_rt, ri_comm_amt, prem_tax,
                renew_sw, reverse_sw, facoblig_sw, bndr_remarks1,
                bndr_remarks2, bndr_remarks3, t1.remarks, t2.attention,
                t1.ri_accept_by, t1.ri_as_no, t1.ri_accept_date, ri_shr_pct2,
                ri_comm_vat, ri_prem_vat, local_foreign_sw, address1,
                address2, address3, t1.prem_warr_tag, t1.prem_warr_days
           FROM giri_wfrps_ri t1, giis_reinsurer t2
          WHERE line_cd = p_line_cd
            AND frps_yy = p_frps_yy
            AND frps_seq_no = p_frps_seq_no
            AND t1.ri_cd = t2.ri_cd
            AND NOT EXISTS (SELECT 1 -- bonok :: 09.30.2014
                              FROM giri_frps_ri
                             WHERE line_cd = t1.line_cd
                               AND frps_yy = t1.frps_yy
                               AND frps_seq_no = t1.frps_seq_no
                               AND ri_seq_no = t1.ri_seq_no
                               AND ri_cd = t1.ri_cd);
   BEGIN
      BEGIN
         SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'YY')), SYSDATE
           INTO v_yy, v_sysdate
           FROM DUAL;

         SELECT fbndr_seq_no + 1
           INTO v_fbndr_seq_no
           FROM giis_fbndr_seq
          WHERE line_cd = p_line_cd AND fbndr_yy = v_yy;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_fbndr_seq_no := 1;

            INSERT INTO giis_fbndr_seq
                        (line_cd, fbndr_yy, fbndr_seq_no, user_id,
                         last_update, remarks
                        )
                 VALUES (p_line_cd, v_yy, 1, USER,
                         v_sysdate, 'POSTING'
                        );
      END;

      FOR c2_rec IN (SELECT eff_date, expiry_date, policy_id
                       FROM giuw_pol_dist
                      WHERE dist_no = p_dist_no)
      LOOP
         v_eff_date := c2_rec.eff_date;
         v_expiry_date := c2_rec.expiry_date;
      END LOOP;

      FOR c1_rec IN frps_ri_area
      LOOP
         update_bindrel (c1_rec.line_cd,
                         c1_rec.frps_yy,
                         c1_rec.frps_seq_no,
                         c1_rec.ri_cd,
                         c1_rec.pre_binder_id
                        );

         BEGIN
            SELECT line_cd, binder_yy, binder_seq_no, ri_comm_vat,
                   ri_prem_vat
              INTO v_line_cd, v_binder_yy, v_binder_seq_no, v_ri_comm_vat,
                   v_ri_prem_vat
              FROM giri_wbinder
             WHERE pre_binder_id = c1_rec.pre_binder_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         IF c1_rec.local_foreign_sw != 'L'
         THEN
            v_wholding_vat := c1_rec.ri_prem_vat;
         END IF;

         IF     v_line_cd IS NOT NULL
            AND v_binder_yy IS NOT NULL
            AND v_binder_seq_no IS NOT NULL
         THEN
            INSERT INTO giri_binder
                        (fnl_binder_id, line_cd, binder_yy,
                         binder_seq_no, ri_cd, ri_tsi_amt,
                         ri_shr_pct, ri_prem_amt,
                         ri_comm_rt, ri_comm_amt,
                         prem_tax, eff_date, expiry_date,
                         binder_date, attention, create_binder_date,
                         policy_id, iss_cd, ri_prem_vat,
                         ri_comm_vat, ri_wholding_vat
                        )
                 VALUES (c1_rec.pre_binder_id, c1_rec.line_cd, v_binder_yy,
                         v_fbndr_seq_no, c1_rec.ri_cd, c1_rec.ri_tsi_amt,
                         c1_rec.ri_shr_pct, c1_rec.ri_prem_amt,
                         c1_rec.ri_comm_rt, c1_rec.ri_comm_amt,
                         c1_rec.prem_tax, v_eff_date, v_expiry_date,
                         v_sysdate, c1_rec.attention, SYSDATE,
                         p_par_policy_id, p_iss_cd, v_ri_prem_vat,
                         v_ri_comm_vat, v_wholding_vat
                        );

            v_line_cd := NULL;
            v_binder_yy := NULL;
            v_binder_seq_no := NULL;

            UPDATE giis_fbndr_seq
               SET fbndr_seq_no = v_fbndr_seq_no,
                   remarks = 'POSTING'
             WHERE line_cd = p_line_cd AND fbndr_yy = v_yy;

            v_fbndr_seq_no := v_fbndr_seq_no + 1;
         ELSE
            insert_sw := 'Y';

            FOR a1 IN
               (SELECT '1'
                  FROM giri_wfrps_ri t1,
                       giri_distfrps_wdistfrps_v t2,
                       giuw_pol_dist t3,
                       giis_reinsurer t4
                 WHERE t1.line_cd = t2.line_cd
                   AND t1.frps_yy = t2.frps_yy
                   AND t1.frps_seq_no = t2.frps_seq_no
                   AND t2.dist_no = t3.dist_no
                   AND t1.ri_cd = t4.ri_cd
                   AND t1.line_cd = p_line_cd
                   AND t1.frps_yy = p_frps_yy
                   AND t1.frps_seq_no = p_frps_seq_no
                   AND t1.ri_cd = c1_rec.ri_cd
                   AND EXISTS (
                          SELECT t5.fnl_binder_id
                            FROM giri_distfrps t6, giri_frps_ri t5
                           WHERE t5.frps_yy = t6.frps_yy
                             AND t5.frps_seq_no = t6.frps_seq_no
                             AND t5.line_cd = t6.line_cd
                             AND t5.fnl_binder_id = t1.pre_binder_id
                             AND t5.reverse_sw = 'N'
                             AND t6.dist_no != t2.dist_no
                             AND t5.ri_cd = c1_rec.ri_cd
                             AND EXISTS (
                                    SELECT '1'
                                      FROM giuw_pol_dist t7
                                     WHERE t7.negate_date IS NOT NULL
                                       AND t7.dist_no = t6.dist_no))
                   AND t1.pre_binder_id = c1_rec.pre_binder_id)
            LOOP
               insert_sw := 'N';

               UPDATE giri_binder
                  SET reverse_date = NULL
                WHERE line_cd = p_line_cd
                  AND fnl_binder_id = c1_rec.pre_binder_id;

               EXIT;
            END LOOP;
         END IF;

         INSERT INTO giri_frps_ri
                     (line_cd, frps_yy, frps_seq_no,
                      ri_seq_no, ri_cd, fnl_binder_id,
                      ri_shr_pct, ri_tsi_amt,
                      ri_prem_amt, ann_ri_s_amt,
                      ann_ri_pct, ri_comm_rt,
                      ri_comm_amt, prem_tax, renew_sw,
                      reverse_sw, facoblig_sw, bndr_remarks1,
                      bndr_remarks2, bndr_remarks3,
                      remarks, ri_accept_by, ri_as_no,
                      ri_accept_date, ri_shr_pct2,
                      ri_comm_vat, ri_prem_vat, ri_wholding_vat,
                      address1, address2, address3,
                      prem_warr_tag, prem_warr_days
                     )
              VALUES (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,
                      c1_rec.ri_seq_no, c1_rec.ri_cd, c1_rec.pre_binder_id,
                      c1_rec.ri_shr_pct, c1_rec.ri_tsi_amt,
                      c1_rec.ri_prem_amt, c1_rec.ann_ri_s_amt,
                      c1_rec.ann_ri_pct, c1_rec.ri_comm_rt,
                      c1_rec.ri_comm_amt, c1_rec.prem_tax, c1_rec.renew_sw,
                      'N', c1_rec.facoblig_sw, c1_rec.bndr_remarks1,
                      c1_rec.bndr_remarks2, c1_rec.bndr_remarks3,
                      c1_rec.remarks, c1_rec.ri_accept_by, c1_rec.ri_as_no,
                      c1_rec.ri_accept_date, c1_rec.ri_shr_pct2,
                      c1_rec.ri_comm_vat, c1_rec.ri_prem_vat, v_wholding_vat,
                      c1_rec.address1, c1_rec.address2, c1_rec.address3,
                      c1_rec.prem_warr_tag, c1_rec.prem_warr_days
                     );

         v_wholding_vat := 0;
      END LOOP;

      SELECT par_id
        INTO v_par_id
        FROM giuw_pol_dist
       WHERE dist_no = p_dist_no;

      FOR v IN (SELECT d.fnl_binder_id
                  FROM giuw_pol_dist a,
                       giri_distfrps b,
                       giri_frps_ri c,
                       giri_binder d
                 WHERE a.dist_no = b.dist_no
                   AND b.line_cd = c.line_cd
                   AND b.frps_yy = c.frps_yy
                   AND b.frps_seq_no = c.frps_seq_no
                   AND c.fnl_binder_id = d.fnl_binder_id
                   AND a.par_id = v_par_id
                   AND a.negate_date IN (SELECT MAX (z.negate_date)
                                           FROM giuw_pol_dist z
                                          WHERE z.par_id = v_par_id))
      LOOP
         UPDATE giri_binder
            SET replaced_flag = 'Y'
          WHERE fnl_binder_id = v.fnl_binder_id AND reverse_date IS NOT NULL;
      END LOOP;
   END create_giri_frps_ri_binder;

/*
   **  Created by       : Anthony Santos
   **  Date Created     : 06.29.2011
   **  Reference By     : (GIRIS026- Post FRPS
   **
   */
   PROCEDURE update_bindrel (
      p_line_cd       giri_frps_ri.line_cd%TYPE,
      p_frps_yy       giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_frps_ri.frps_seq_no%TYPE,
      p_ri_cd         giri_frps_ri.ri_cd%TYPE,
      p_binder_id     giri_frps_ri.fnl_binder_id%TYPE
   )
   IS
   BEGIN
      FOR a1 IN (SELECT fnl_binder_id
                   FROM giri_frps_ri
                  WHERE line_cd = p_line_cd
                    AND frps_yy = p_frps_yy
                    AND frps_seq_no = p_frps_seq_no
                    AND ri_cd = p_ri_cd)
      LOOP
         FOR a2 IN (SELECT fnl_binder_id, lnk_binder_id
                      FROM giri_bindrel
                     WHERE fnl_binder_id = a1.fnl_binder_id)
         LOOP
            IF a2.lnk_binder_id IS NULL
            THEN
               UPDATE giri_bindrel
                  SET lnk_binder_id = p_binder_id
                WHERE fnl_binder_id = a1.fnl_binder_id;
            END IF;
         END LOOP;
      END LOOP;
   END;

    /*
   **  Created by       : Jerome Orio
   **  Date Created     : 07.07.2011
   **  Reference By     : (GIRIS001- Create RI Placement)
   **  Description      :  get records for D050 block (giri_frps_ri)
   */
   FUNCTION get_giri_frps_ri (p_dist_no giuw_pol_dist.dist_no%TYPE)
      RETURN giri_frps_ri_tab PIPELINED
   IS
      v_dist_no   giuw_pol_dist.dist_no%TYPE;
      v_list      giri_frps_ri_type;
   BEGIN
      FOR a1 IN (SELECT policy_id
                   FROM giuw_pol_dist
                  WHERE dist_no = p_dist_no)
      LOOP
         FOR a2 IN (SELECT   dist_no
                        FROM giuw_pol_dist
                       WHERE policy_id = a1.policy_id
                         AND negate_date =
                                (SELECT MAX (negate_date)
                                   FROM giuw_pol_dist
                                  WHERE policy_id = a1.policy_id
                                    AND negate_date IS NOT NULL)
                    ORDER BY dist_no DESC)
         LOOP
            v_dist_no := a2.dist_no;
            EXIT;
         END LOOP;

         EXIT;
      END LOOP;

      FOR a3 IN
         (SELECT line_cd, frps_yy, frps_seq_no, ri_seq_no, ri_cd,
                 fnl_binder_id, ri_shr_pct, ri_tsi_amt, ri_prem_amt,
                 reverse_sw, ann_ri_s_amt, ann_ri_pct, ri_comm_rt,
                 ri_comm_amt, prem_tax, other_charges, renew_sw, facoblig_sw,
                 bndr_remarks1, bndr_remarks2, bndr_remarks3, remarks,
                 delete_sw, revrs_bndr_print_date, last_update,
                 master_bndr_id, cpi_rec_no, cpi_branch_cd, bndr_printed_cnt,
                 revrs_bndr_printed_cnt, ri_as_no, ri_accept_by,
                 ri_accept_date, ri_shr_pct2, ri_prem_vat, ri_comm_vat,
                 ri_wholding_vat, address1, address2, address3,
                 prem_warr_days, prem_warr_tag, pack_binder_id, arc_ext_data
            FROM giri_frps_ri
           WHERE line_cd || TO_CHAR (frps_yy) || TO_CHAR (frps_seq_no) IN (
                    SELECT DISTINCT    line_cd
                                    || TO_CHAR (frps_yy)
                                    || TO_CHAR (frps_seq_no)
                               FROM giri_distfrps
                              WHERE dist_no = v_dist_no AND reverse_sw = 'N'))
      LOOP
         v_list.line_cd := a3.line_cd;
         v_list.frps_yy := a3.frps_yy;
         v_list.frps_seq_no := a3.frps_seq_no;
         v_list.ri_seq_no := a3.ri_seq_no;
         v_list.ri_cd := a3.ri_cd;
         v_list.fnl_binder_id := a3.fnl_binder_id;
         v_list.ri_shr_pct := a3.ri_shr_pct;
         v_list.ri_tsi_amt := a3.ri_tsi_amt;
         v_list.ri_prem_amt := a3.ri_prem_amt;
         v_list.reverse_sw := a3.reverse_sw;
         v_list.ann_ri_s_amt := a3.ann_ri_s_amt;
         v_list.ann_ri_pct := a3.ann_ri_pct;
         v_list.ri_comm_rt := a3.ri_comm_rt;
         v_list.ri_comm_amt := a3.ri_comm_amt;
         v_list.prem_tax := a3.prem_tax;
         v_list.other_charges := a3.other_charges;
         v_list.renew_sw := a3.renew_sw;
         v_list.facoblig_sw := a3.facoblig_sw;
         v_list.bndr_remarks1 := a3.bndr_remarks1;
         v_list.bndr_remarks2 := a3.bndr_remarks2;
         v_list.bndr_remarks3 := a3.bndr_remarks3;
         v_list.remarks := a3.remarks;
         v_list.delete_sw := a3.delete_sw;
         v_list.revrs_bndr_print_date := a3.revrs_bndr_print_date;
         v_list.last_update := a3.last_update;
         v_list.master_bndr_id := a3.master_bndr_id;
         v_list.cpi_rec_no := a3.cpi_rec_no;
         v_list.cpi_branch_cd := a3.cpi_branch_cd;
         v_list.bndr_printed_cnt := a3.bndr_printed_cnt;
         v_list.revrs_bndr_printed_cnt := a3.revrs_bndr_printed_cnt;
         v_list.ri_as_no := a3.ri_as_no;
         v_list.ri_accept_by := a3.ri_accept_by;
         v_list.ri_accept_date := a3.ri_accept_date;
         v_list.ri_shr_pct2 := a3.ri_shr_pct2;
         v_list.ri_prem_vat := a3.ri_prem_vat;
         v_list.ri_comm_vat := a3.ri_comm_vat;
         v_list.ri_wholding_vat := a3.ri_wholding_vat;
         v_list.address1 := a3.address1;
         v_list.address2 := a3.address2;
         v_list.address3 := a3.address3;
         v_list.prem_warr_days := a3.prem_warr_days;
         v_list.prem_warr_tag := a3.prem_warr_tag;
         v_list.pack_binder_id := a3.pack_binder_id;
         v_list.arc_ext_data := a3.arc_ext_data;
         v_list.dsp_ri_sname := '';

         FOR aa IN (SELECT ri_name
                      FROM giis_reinsurer
                     WHERE ri_cd = a3.ri_cd)
         LOOP
            v_list.dsp_ri_sname := aa.ri_name;
            EXIT;
         END LOOP;

         IF v_list.ri_shr_pct2 IS NULL
         THEN
            v_list.ri_shr_pct2 := v_list.ri_shr_pct;
         END IF;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by       : Robert Virrey
   **  Date Created     : 08.11.2011
   **  Reference By     : (GIUTS004- Reverse Binder)
   **  Description      : Retrieves giri_frps_ri records
   */
   FUNCTION get_giri_frps_ri2 (
      p_line_cd       giri_frps_ri.line_cd%TYPE,
      p_frps_yy       giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_frps_ri.frps_seq_no%TYPE
   )
      RETURN giri_frps_ri_tab PIPELINED
   IS
      v_frps_ri   giri_frps_ri_type;
   BEGIN
      FOR i IN (SELECT line_cd, frps_yy, frps_seq_no, ri_seq_no, ri_cd,
                       fnl_binder_id, ri_shr_pct, ri_tsi_amt, ri_prem_amt,
                       ann_ri_s_amt, ann_ri_pct, ri_comm_rt, ri_comm_amt,
                       prem_tax, bndr_remarks1, bndr_remarks2, bndr_remarks3,
                       remarks, ri_as_no, ri_accept_by, ri_accept_date,
                       ri_shr_pct2, ri_prem_vat, ri_comm_vat, address1,
                       address2, address3, reverse_sw, delete_sw,
                       last_update
                  FROM giri_frps_ri
                 WHERE line_cd = p_line_cd
                   AND frps_yy = p_frps_yy
                   AND frps_seq_no = p_frps_seq_no
                   AND reverse_sw = 'N'
                   AND NVL (delete_sw, 'X') != 'Y'
                   AND master_bndr_id IS NULL)
      LOOP
         v_frps_ri.line_cd := i.line_cd;
         v_frps_ri.frps_yy := i.frps_yy;
         v_frps_ri.frps_seq_no := i.frps_seq_no;
         v_frps_ri.ri_seq_no := i.ri_seq_no;
         v_frps_ri.ri_cd := i.ri_cd;
         v_frps_ri.fnl_binder_id := i.fnl_binder_id;
         v_frps_ri.ri_shr_pct := i.ri_shr_pct;
         v_frps_ri.ri_tsi_amt := i.ri_tsi_amt;
         v_frps_ri.ri_prem_amt := i.ri_prem_amt;
         v_frps_ri.ann_ri_s_amt := i.ann_ri_s_amt;
         v_frps_ri.ann_ri_pct := i.ann_ri_pct;
         v_frps_ri.ri_comm_rt := i.ri_comm_rt;
         v_frps_ri.ri_comm_amt := i.ri_comm_amt;
         v_frps_ri.prem_tax := i.prem_tax;
         v_frps_ri.bndr_remarks1 := i.bndr_remarks1;
         v_frps_ri.bndr_remarks2 := i.bndr_remarks2;
         v_frps_ri.bndr_remarks3 := i.bndr_remarks3;
         v_frps_ri.remarks := i.remarks;
         v_frps_ri.ri_as_no := i.ri_as_no;
         v_frps_ri.ri_accept_by := i.ri_accept_by;
         v_frps_ri.ri_accept_date := i.ri_accept_date;
         v_frps_ri.ri_shr_pct2 := i.ri_shr_pct;
         v_frps_ri.ri_prem_vat := i.ri_prem_vat;
         v_frps_ri.ri_comm_vat := i.ri_comm_vat;
         v_frps_ri.address1 := i.address1;
         v_frps_ri.address2 := i.address2;
         v_frps_ri.address3 := i.address3;
         v_frps_ri.reverse_sw := i.reverse_sw;
         v_frps_ri.delete_sw := i.delete_sw;
         v_frps_ri.last_update := i.last_update;

         BEGIN
            FOR a IN (SELECT line_cd, binder_yy, binder_seq_no, attention
                        FROM giri_binder
                       WHERE fnl_binder_id = i.fnl_binder_id)
            LOOP
               v_frps_ri.binder_no :=
                     a.line_cd
                  || ' - '
                  || LTRIM (TO_CHAR (a.binder_yy, '09'))
                  || ' - '
                  || LTRIM (TO_CHAR (a.binder_seq_no, '09999'));
               v_frps_ri.attention := a.attention;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         FOR j IN (SELECT giis_reinsurer.ri_sname
                     FROM giis_reinsurer giis_reinsurer
                    WHERE giis_reinsurer.ri_cd = i.ri_cd)
         LOOP
            v_frps_ri.dsp_ri_sname := j.ri_sname;
         END LOOP;

         PIPE ROW (v_frps_ri);
      END LOOP;
   END get_giri_frps_ri2;

   /*
   **  Created by       : Robert John Virrey
   **  Date Created     : 08.12.2011
   **  Reference By     : (GIUTS004- Reverse Binder)
   **  Description      : Copy GIRI_FRPS_RI TO GIRI_WFRPS_RI.
   **                     Copy GIRI_FRPERIL TO GIRI_WFRPERIL.
   **                     Copy GIRI_BINDER TO GIRI_WBINDER.
   **                     Copy GIRI_BINDER_PERIL TO GIRI_WBINDER_PERIL.
   */
   PROCEDURE reverse_binder (
      p_fnl_binder_id   IN   giri_frps_ri.fnl_binder_id%TYPE,
      p_line_cd         IN   giri_frps_ri.line_cd%TYPE,
      p_frps_yy         IN   giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no     IN   giri_frps_ri.frps_seq_no%TYPE,
      p_dist_no         IN   giuw_pol_dist.dist_no%TYPE
   )
   IS
      CURSOR c1
      IS
         SELECT ri_cd, fnl_binder_id, ri_seq_no, line_cd, frps_yy,
                frps_seq_no
           FROM giri_frps_ri
          WHERE fnl_binder_id = p_fnl_binder_id
            AND reverse_sw = 'N'
            AND line_cd = p_line_cd
            AND frps_yy = p_frps_yy
            AND frps_seq_no = p_frps_seq_no;
   BEGIN
      FOR c1_rec IN c1
      LOOP
         giri_wfrps_ri_pkg.copy_frps_ri (c1_rec.line_cd,
                                         c1_rec.frps_yy,
                                         c1_rec.frps_seq_no,
                                         c1_rec.fnl_binder_id
                                        );
         giri_wfrperil_pkg.copy_frperil (c1_rec.line_cd,
                                         c1_rec.frps_yy,
                                         c1_rec.frps_seq_no,
                                         c1_rec.ri_cd,
                                         c1_rec.ri_seq_no
                                        );
         giri_wbinder_pkg.copy_binder (c1_rec.line_cd,
                                       c1_rec.frps_yy,
                                       c1_rec.frps_seq_no,
                                       c1_rec.fnl_binder_id,
                                       p_dist_no
                                      );
         giri_wbinder_peril_pkg.copy_binder_peril (c1_rec.line_cd,
                                                   c1_rec.frps_yy,
                                                   c1_rec.frps_seq_no,
                                                   c1_rec.fnl_binder_id
                                                  );
      END LOOP;
   END reverse_binder;

   /*
   **  Created by      : Emman
   **  Date Created    : 08.17.2011
   **  Reference By    : (GIUTS021 - Redistribution)
   **  Description     : The procedure DELETE_MRECORDS
   */
   PROCEDURE delete_mrecords_giuts021 (
      p_line_cd       IN   giri_distfrps.line_cd%TYPE,
      p_frps_yy       IN   giri_distfrps.frps_yy%TYPE,
      p_frps_seq_no   IN   giri_distfrps.frps_seq_no%TYPE
   )
   IS
   BEGIN
      FOR c1_rec IN (SELECT fnl_binder_id, line_cd, frps_yy, frps_seq_no,
                            ri_seq_no
                       FROM giri_frps_ri
                      WHERE line_cd = p_line_cd
                        AND frps_yy = p_frps_yy
                        AND frps_seq_no = p_frps_seq_no
                        AND fnl_binder_id IN (
                               SELECT pre_binder_id
                                 FROM giri_wfrps_ri
                                WHERE line_cd = p_line_cd
                                  AND frps_yy = p_frps_yy
                                  AND frps_seq_no = p_frps_seq_no))
      LOOP
         DELETE FROM giri_binder_peril
               WHERE fnl_binder_id = c1_rec.fnl_binder_id;

         DELETE FROM giri_binder
               WHERE fnl_binder_id = c1_rec.fnl_binder_id;

         DELETE FROM giri_frperil
               WHERE line_cd = c1_rec.line_cd
                 AND frps_yy = c1_rec.frps_yy
                 AND frps_seq_no = c1_rec.frps_seq_no
                 AND ri_seq_no = c1_rec.ri_seq_no;

         DELETE FROM giri_frps_ri
               WHERE line_cd = c1_rec.line_cd
                 AND frps_yy = c1_rec.frps_yy
                 AND frps_seq_no = c1_rec.frps_seq_no
                 AND fnl_binder_id = c1_rec.fnl_binder_id;
      END LOOP;

      DELETE FROM giri_frps_peril_grp
            WHERE line_cd = p_line_cd
              AND frps_yy = p_frps_yy
              AND frps_seq_no = p_frps_seq_no;
   END delete_mrecords_giuts021;

   /*
   **  Created by      : Emman
   **  Date Created    : 08.17.2011
   **  Reference By    : (GIUTS021 - Redistribution)
   **  Description     : The procedure CREATE_GIRI_FRPS_RI_BINDER
   */
   PROCEDURE create_giri_frps_ri_binder2 (
      p_dist_no       IN   giuw_pol_dist.dist_no%TYPE,
      v_line_cd1      IN   giri_distfrps.line_cd%TYPE,
      v_frps_yy       IN   giri_distfrps.frps_yy%TYPE,
      v_frps_seq_no   IN   giri_distfrps.frps_seq_no%TYPE
   )
   IS
      v_line_cd         giri_wbinder.line_cd%TYPE;
      v_binder_yy       giri_wbinder.binder_yy%TYPE;
      v_binder_seq_no   giri_wbinder.binder_seq_no%TYPE;
      v_yy              NUMBER;
      v_curr_date       DATE;
      v_ri_cd           giri_wbinder.ri_cd%TYPE;
      v_eff_date        giri_wbinder.eff_date%TYPE;
      v_expiry_date     giri_wbinder.expiry_date%TYPE;
      v_attention       giri_wbinder.attention%TYPE;
      v_sysdate         DATE;
      v_fbndr_seq_no    giis_fbndr_seq.fbndr_seq_no%TYPE;
      insert_sw         VARCHAR2 (1)                       := 'Y';
      v_policy_id       gipi_polbasic.policy_id%TYPE; --added by clperello | 04.01.2014
      v_wholding_vat    giri_frperil.ri_wholding_vat%TYPE := 0; --edgar 09/30/2014

      CURSOR frps_ri_area
      IS
         SELECT line_cd, frps_yy, frps_seq_no, ri_seq_no, t1.ri_cd,
                pre_binder_id, ri_shr_pct, ri_tsi_amt, ri_prem_amt, ri_shr_pct2, ri_prem_vat, ri_comm_vat, prem_warr_days, prem_warr_tag, address1, address2, address3, t2.local_foreign_sw,--added ri_shr_pct2 edgar 09/24/2014
                ann_ri_s_amt, ann_ri_pct, ri_comm_rt, ri_comm_amt, prem_tax,
                renew_sw, reverse_sw, facoblig_sw, bndr_remarks1,
                bndr_remarks2, bndr_remarks3, t1.remarks, t2.attention
           FROM giri_wfrps_ri t1, giis_reinsurer t2
          WHERE line_cd = v_line_cd1
            AND frps_yy = v_frps_yy
            AND frps_seq_no = v_frps_seq_no
            AND t1.ri_cd = t2.ri_cd;
   BEGIN
      BEGIN
         SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'YY')), SYSDATE
           INTO v_yy, v_sysdate
           FROM DUAL;

         SELECT fbndr_seq_no + 1
           INTO v_fbndr_seq_no
           FROM giis_fbndr_seq
          WHERE line_cd = v_line_cd1 AND fbndr_yy = v_yy;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_fbndr_seq_no := 1;

            INSERT INTO giis_fbndr_seq
                        (line_cd, fbndr_yy, fbndr_seq_no,
                         user_id, last_update,
                         remarks
                        )
                 VALUES (v_line_cd1, v_yy, 1,
                         NVL (giis_users_pkg.app_user, USER), v_sysdate,
                         'POSTING'
                        );
      END;

      FOR c2_rec IN (SELECT eff_date, expiry_date
                       FROM giuw_pol_dist
                      WHERE dist_no = p_dist_no)
      LOOP
         v_eff_date := c2_rec.eff_date;
         v_expiry_date := c2_rec.expiry_date;
      END LOOP;
      
      --added by clperello | 04.01.2014
      FOR c_rec IN (SELECT a.policy_id
                      FROM gipi_polbasic a, giuw_pol_dist b
                     WHERE a.par_id = b.par_id
                       AND b.dist_no = p_dist_no)
      LOOP
         v_policy_id := c_rec.policy_id;
      END LOOP;
      --end clperello | 04.01.2014

      FOR c1_rec IN frps_ri_area
      LOOP
          /*added edgar 09/30/2014*/   
         IF c1_rec.local_foreign_sw != 'L'
         THEN
            v_wholding_vat := c1_rec.ri_prem_vat;
         END IF;
         /*end edgar 09/30/2014*/           
       giri_frps_ri_pkg.update_bindrel (c1_rec.line_cd,
                                          c1_rec.frps_yy,
                                          c1_rec.frps_seq_no,
                                          c1_rec.ri_cd,
                                          c1_rec.pre_binder_id
                                         );

         INSERT INTO giri_frps_ri
                     (line_cd, frps_yy, frps_seq_no,
                      ri_seq_no, ri_cd, fnl_binder_id,
                      ri_shr_pct, ri_tsi_amt, ri_shr_pct2, ri_prem_vat, ri_comm_vat, prem_warr_days, prem_warr_tag, address1, address2, address3, ri_wholding_vat,--added ri_shr_pct2 edgar 09/24/2014
                      ri_prem_amt, ann_ri_s_amt,
                      ann_ri_pct, ri_comm_rt,
                      ri_comm_amt, prem_tax, renew_sw,
                      reverse_sw, facoblig_sw, bndr_remarks1,
                      bndr_remarks2, bndr_remarks3,
                      remarks
                     )
              VALUES (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,
                      c1_rec.ri_seq_no, c1_rec.ri_cd, c1_rec.pre_binder_id,
                      c1_rec.ri_shr_pct, c1_rec.ri_tsi_amt, c1_rec.ri_shr_pct2, c1_rec.ri_prem_vat, c1_rec.ri_comm_vat, c1_rec.prem_warr_days, c1_rec.prem_warr_tag, c1_rec.address1, c1_rec.address2, c1_rec.address3, v_wholding_vat,--added ri_shr_pct2 edgar 09/24/2014
                      c1_rec.ri_prem_amt, c1_rec.ann_ri_s_amt,
                      c1_rec.ann_ri_pct, c1_rec.ri_comm_rt,
                      c1_rec.ri_comm_amt, c1_rec.prem_tax, c1_rec.renew_sw,
                      'N', c1_rec.facoblig_sw, c1_rec.bndr_remarks1,
                      c1_rec.bndr_remarks2, c1_rec.bndr_remarks3,
                      c1_rec.remarks
                     );

         BEGIN
            SELECT line_cd, binder_yy, binder_seq_no
              INTO v_line_cd, v_binder_yy, v_binder_seq_no
              FROM giri_wbinder
             WHERE pre_binder_id = c1_rec.pre_binder_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         IF     v_line_cd IS NOT NULL
            AND v_binder_yy IS NOT NULL
            AND v_binder_seq_no IS NOT NULL
         THEN
            INSERT INTO giri_binder
                        (fnl_binder_id, line_cd, binder_yy,
                         binder_seq_no, ri_cd, ri_tsi_amt,
                         ri_shr_pct, ri_prem_amt,
                         ri_comm_rt, ri_comm_amt,
                         prem_tax, eff_date, expiry_date,
                         binder_date, attention, policy_id --added policy_id | clperello 04.01.2014
                         ,ri_prem_vat, ri_comm_vat, ri_wholding_vat --added edgar 09/29/2014
                        )
                 VALUES (c1_rec.pre_binder_id, c1_rec.line_cd, v_binder_yy,
                         v_binder_seq_no, c1_rec.ri_cd, c1_rec.ri_tsi_amt,
                         c1_rec.ri_shr_pct, c1_rec.ri_prem_amt,
                         c1_rec.ri_comm_rt, c1_rec.ri_comm_amt,
                         c1_rec.prem_tax, v_eff_date, v_expiry_date,
                         v_sysdate, c1_rec.attention, v_policy_id --added policy_id | clperello 04.01.2014
                         ,c1_rec.ri_prem_vat, c1_rec.ri_comm_vat, v_wholding_vat --added edgar 09/29/2014
                        );

            v_line_cd := NULL;
            v_binder_yy := NULL;
            v_binder_seq_no := NULL;
         ELSE
            insert_sw := 'Y';

            FOR a1 IN
               (SELECT '1'
                  FROM giri_wfrps_ri t1,
                       giri_distfrps_wdistfrps_v t2,
                       giuw_pol_dist t3,
                       giis_reinsurer t4
                 WHERE t1.line_cd = t2.line_cd
                   AND t1.frps_yy = t2.frps_yy
                   AND t1.frps_seq_no = t2.frps_seq_no
                   AND t2.dist_no = t3.dist_no
                   AND t1.ri_cd = t4.ri_cd
                   AND t1.line_cd = v_line_cd1
                   AND t1.frps_yy = v_frps_yy
                   AND t1.frps_seq_no = v_frps_seq_no
                   AND t1.ri_cd = c1_rec.ri_cd
                   AND EXISTS (
                          SELECT t5.fnl_binder_id
                            FROM giri_distfrps t6, giri_frps_ri t5
                           WHERE t5.frps_yy = t6.frps_yy
                             AND t5.frps_seq_no = t6.frps_seq_no
                             AND t5.line_cd = t6.line_cd
                             AND t5.fnl_binder_id = t1.pre_binder_id
                             AND t5.reverse_sw = 'N'
                             AND t6.dist_no != t2.dist_no
                             AND t5.ri_cd = c1_rec.ri_cd
                             AND EXISTS (
                                    SELECT '1'
                                      FROM giuw_pol_dist t7
                                     WHERE t7.negate_date IS NOT NULL
                                       AND t7.dist_no = t6.dist_no)))
            LOOP
               insert_sw := 'N';
               EXIT;
            END LOOP;

            IF insert_sw = 'Y'
            THEN
               INSERT INTO giri_binder
                           (fnl_binder_id, line_cd, binder_yy,
                            binder_seq_no, ri_cd, ri_tsi_amt,
                            ri_shr_pct, ri_prem_amt,
                            ri_comm_rt, ri_comm_amt,
                            prem_tax, eff_date, expiry_date,
                            binder_date, attention, policy_id --added policy_id | clperello 04.01.2014
                            ,ri_prem_vat, ri_comm_vat, ri_wholding_vat --added edgar 09/29/2014
                           )
                    VALUES (c1_rec.pre_binder_id, c1_rec.line_cd, v_yy,
                            v_fbndr_seq_no, c1_rec.ri_cd, c1_rec.ri_tsi_amt,
                            c1_rec.ri_shr_pct, c1_rec.ri_prem_amt,
                            c1_rec.ri_comm_rt, c1_rec.ri_comm_amt,
                            c1_rec.prem_tax, v_eff_date, v_expiry_date,
                            v_sysdate, c1_rec.attention, v_policy_id --added policy_id | clperello 04.01.2014
                            ,c1_rec.ri_prem_vat, c1_rec.ri_comm_vat, v_wholding_vat --added edgar 09/29/2014
                           );

               v_fbndr_seq_no := v_fbndr_seq_no + 1;
            END IF;
         END IF;
         v_wholding_vat := 0; --edgar 09/30/2014  
      END LOOP;
   END create_giri_frps_ri_binder2;

   /*
   **  Created by       : Jerome Orio
   **  Date Created     : 01.05.2012
   **  Reference By     : (GIRIS053A- Generate Package Binders)
   **  Description      :  get records for D050 block (giri_frps_ri)
   */
   FUNCTION get_giri_frps_ri3 (
      p_pack_policy_id   gipi_polbasic.pack_policy_id%TYPE
   )
      RETURN giri_frps_ri_tab PIPELINED
   IS
      v_list   giri_frps_ri_type;
      v_gen_sw VARCHAR2(1) := 'Y';
   BEGIN
      FOR i IN (
        SELECT 1 
          FROM giri_frps_ri
         WHERE pack_binder_id IS NULL
           AND line_cd
               || RTRIM (TO_CHAR (frps_yy))
               || RTRIM (TO_CHAR (frps_seq_no)) IN (
                   SELECT DISTINCT    line_cd
                                      || RTRIM (TO_CHAR (frps_yy))
                                      || RTRIM (TO_CHAR (frps_seq_no))
                                 FROM giri_distfrps b
                                WHERE b.dist_no IN (
                                         SELECT y.dist_no dist_no
                                           FROM giuw_pol_dist y,
                                                gipi_polbasic z
                                          WHERE y.policy_id = z.policy_id
                                            AND y.dist_flag NOT IN (4, 5)
                                            AND z.pack_policy_id = p_pack_policy_id))
           AND reverse_sw != 'Y'
      ) 
      LOOP
        v_gen_sw := 'N';
        EXIT;
      END LOOP;
   
      FOR a3 IN
         (SELECT   line_cd, frps_yy, frps_seq_no, ri_seq_no, ri_cd,
                   fnl_binder_id, ri_shr_pct, ri_tsi_amt, ri_prem_amt,
                   reverse_sw, ann_ri_s_amt, ann_ri_pct, ri_comm_rt,
                   ri_comm_amt, prem_tax, other_charges, renew_sw,
                   facoblig_sw, bndr_remarks1, bndr_remarks2, bndr_remarks3,
                   remarks, delete_sw, revrs_bndr_print_date, last_update,
                   master_bndr_id, cpi_rec_no, cpi_branch_cd,
                   bndr_printed_cnt, revrs_bndr_printed_cnt, ri_as_no,
                   ri_accept_by, ri_accept_date, ri_shr_pct2, ri_prem_vat,
                   ri_comm_vat, ri_wholding_vat, address1, address2,
                   address3, prem_warr_days, prem_warr_tag, pack_binder_id,
                   arc_ext_data
              FROM giri_frps_ri a
             WHERE    line_cd
                   || RTRIM (TO_CHAR (frps_yy))
                   || RTRIM (TO_CHAR (frps_seq_no)) IN (
                      SELECT DISTINCT    line_cd
                                      || RTRIM (TO_CHAR (frps_yy))
                                      || RTRIM (TO_CHAR (frps_seq_no))
                                 FROM giri_distfrps b
                                WHERE b.dist_no IN (
                                         SELECT y.dist_no dist_no
                                           FROM giuw_pol_dist y,
                                                gipi_polbasic z
                                          WHERE y.policy_id = z.policy_id
                                            AND y.dist_flag NOT IN (4, 5)
                                            AND z.pack_policy_id =
                                                              p_pack_policy_id))
               AND reverse_sw != 'Y')          /*(SELECT a.line_cd
                                FROM giri_pack_binder_hdr a
                                 WHERE a.pack_binder_id = pack_binder_id)
                            ,(SELECT a.binder_yy
                                FROM giri_pack_binder_hdr a
                               WHERE a.pack_binder_id = pack_binder_id)
                            ,(SELECT a.binder_seq_no
                                FROM giri_pack_binder_hdr a
                               WHERE a.pack_binder_id = pack_binder_id))*/
      LOOP
         v_list.line_cd := a3.line_cd;
         v_list.frps_yy := a3.frps_yy;
         v_list.frps_seq_no := a3.frps_seq_no;
         v_list.ri_seq_no := a3.ri_seq_no;
         v_list.ri_cd := a3.ri_cd;
         v_list.fnl_binder_id := a3.fnl_binder_id;
         v_list.ri_shr_pct := a3.ri_shr_pct;
         v_list.ri_tsi_amt := a3.ri_tsi_amt;
         v_list.ri_prem_amt := a3.ri_prem_amt;
         v_list.reverse_sw := a3.reverse_sw;
         v_list.ann_ri_s_amt := a3.ann_ri_s_amt;
         v_list.ann_ri_pct := a3.ann_ri_pct;
         v_list.ri_comm_rt := a3.ri_comm_rt;
         v_list.ri_comm_amt := a3.ri_comm_amt;
         v_list.prem_tax := a3.prem_tax;
         v_list.other_charges := a3.other_charges;
         v_list.renew_sw := a3.renew_sw;
         v_list.facoblig_sw := a3.facoblig_sw;
         v_list.bndr_remarks1 := a3.bndr_remarks1;
         v_list.bndr_remarks2 := a3.bndr_remarks2;
         v_list.bndr_remarks3 := a3.bndr_remarks3;
         v_list.remarks := a3.remarks;
         v_list.delete_sw := a3.delete_sw;
         v_list.revrs_bndr_print_date := a3.revrs_bndr_print_date;
         v_list.last_update := a3.last_update;
         v_list.master_bndr_id := a3.master_bndr_id;
         v_list.cpi_rec_no := a3.cpi_rec_no;
         v_list.cpi_branch_cd := a3.cpi_branch_cd;
         v_list.bndr_printed_cnt := a3.bndr_printed_cnt;
         v_list.revrs_bndr_printed_cnt := a3.revrs_bndr_printed_cnt;
         v_list.ri_as_no := a3.ri_as_no;
         v_list.ri_accept_by := a3.ri_accept_by;
         v_list.ri_accept_date := a3.ri_accept_date;
         v_list.ri_shr_pct2 := a3.ri_shr_pct2;
         v_list.ri_prem_vat := a3.ri_prem_vat;
         v_list.ri_comm_vat := a3.ri_comm_vat;
         v_list.ri_wholding_vat := a3.ri_wholding_vat;
         v_list.address1 := a3.address1;
         v_list.address2 := a3.address2;
         v_list.address3 := a3.address3;
         v_list.prem_warr_days := a3.prem_warr_days;
         v_list.prem_warr_tag := a3.prem_warr_tag;
         v_list.pack_binder_id := a3.pack_binder_id;
         v_list.arc_ext_data := a3.arc_ext_data;
         v_list.dsp_ri_sname := '';
         v_list.binder_no := '';
         v_list.dsp_grp_bdr := '';
         v_list.currency_rt := '';
         v_list.currency_cd := '';
         v_list.dsp_policy_no := '';

         FOR aa IN (SELECT ri_name
                      FROM giis_reinsurer
                     WHERE ri_cd = a3.ri_cd)
         LOOP
            v_list.dsp_ri_sname := aa.ri_name;
            EXIT;
         END LOOP;

         v_list.dsp_frps_no :=
               a3.line_cd
            || ' - '
            || TO_CHAR (a3.frps_yy, '09')
            || ' - '
            || TO_CHAR (a3.frps_seq_no, '09999');

         FOR binder IN (SELECT line_cd, binder_yy, binder_seq_no
                          FROM giri_binder
                         WHERE fnl_binder_id = a3.fnl_binder_id)
         LOOP
            v_list.binder_no :=
                  binder.line_cd
               || ' - '
               || TO_CHAR (binder.binder_yy, '09')
               || ' - '
               || TO_CHAR (binder.binder_seq_no, '09999');
            EXIT;
         END LOOP;

         FOR grp IN (SELECT line_cd, binder_yy, binder_seq_no
                       FROM giri_pack_binder_hdr
                      WHERE pack_binder_id = a3.pack_binder_id)
         LOOP
            v_list.dsp_grp_bdr :=
                  grp.line_cd
               || ' - '
               || TO_CHAR (grp.binder_yy, '09')
               || ' - '
               || TO_CHAR (grp.binder_seq_no, '09999');
            EXIT;
         END LOOP;

         FOR curr IN (SELECT currency_rt, currency_cd
                        FROM giri_distfrps
                       WHERE line_cd = a3.line_cd
                         AND frps_yy = a3.frps_yy
                         AND frps_seq_no = a3.frps_seq_no)
         LOOP
            v_list.currency_rt := curr.currency_rt;
            v_list.currency_cd := curr.currency_cd;
            EXIT;
         END LOOP;

         FOR pol IN (SELECT get_policy_no (policy_id) policy_no
                       FROM giuw_pol_dist b, giri_distfrps a
                      WHERE 1 = 1
                        AND b.dist_no = a.dist_no
                        AND a.line_cd = a3.line_cd
                        AND a.frps_yy = a3.frps_yy
                        AND a.frps_seq_no = a3.frps_seq_no)
         LOOP
            v_list.dsp_policy_no := pol.policy_no;
            EXIT;
         END LOOP;
         
         v_list.gen_sw := v_gen_sw;
         
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
    **  Created by      : Emsy Bola?os
    **  Date Created    : 01.13.2012
    **  Reference By    : (GIRIS053 - Group Binders)
    **  Description     :  get binder table grid (giri_frps_ri)
    */
   FUNCTION get_binder_tg (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN giri_binder_tg_tab PIPELINED
   IS
      v_binder_list   giri_binder_tg_type;
   BEGIN
      FOR i IN
         (SELECT a.line_cd, a.frps_yy, a.frps_seq_no, b.binder_yy,
                 b.binder_seq_no, a.ri_cd, e.currency_cd, e.currency_rt,
                    a.line_cd
                 || '-'
                 || LTRIM (TO_CHAR (a.frps_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (a.frps_seq_no, '09999')) frps_no,
                    b.line_cd
                 || '-'
                 || LTRIM (TO_CHAR (b.binder_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (b.binder_seq_no, '09999')) binder_no,
                 c.ri_name dsp_reinsurer, b.ri_shr_pct,
                 LTRIM (TO_CHAR (b.ri_tsi_amt, '99,999,999,999,999.00')) ri_tsi_amt, --changed from 999,999,999.00 by robert SR 4965 09.16.15 
                 LTRIM (TO_CHAR (b.ri_prem_amt, '9,999,999,999.00')) --changed from 999,999,999.00 by robert SR 4965 09.16.15 
                                                                 ri_prem_amt,
                    d.line_cd
                 || '-'
                 || LTRIM (TO_CHAR (d.binder_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (d.binder_seq_no, '09999')) grp_binder_no,
                 d.master_bndr_id
            FROM giri_frps_ri a,
                 giri_binder b,
                 giis_reinsurer c,
                 giri_group_binder d,
                 giri_distfrps e
           WHERE a.fnl_binder_id = b.fnl_binder_id
             AND a.ri_cd = c.ri_cd
             AND a.master_bndr_id = d.master_bndr_id(+)
             AND a.line_cd = e.line_cd
             AND a.frps_yy = e.frps_yy
             AND a.frps_seq_no = e.frps_seq_no
             AND    a.line_cd
                 || RTRIM (TO_CHAR (a.frps_yy))
                 || RTRIM (TO_CHAR (a.frps_seq_no)) IN (
                    SELECT DISTINCT    line_cd
                                    || RTRIM (TO_CHAR (frps_yy))
                                    || RTRIM (TO_CHAR (frps_seq_no))
                               FROM giri_distfrps b
                              WHERE b.dist_no IN (
                                       SELECT a.dist_no dist_no
                                         FROM giuw_pol_dist a
                                        WHERE a.policy_id = p_policy_id
                                          AND a.dist_flag NOT IN (4, 5)))
             AND reverse_sw != 'Y')
      LOOP
         v_binder_list.line_cd := i.line_cd;
         v_binder_list.frps_yy := i.frps_yy;
         v_binder_list.frps_seq_no := i.frps_seq_no;
         v_binder_list.binder_yy := i.binder_yy;
         v_binder_list.binder_seq_no := i.binder_seq_no;
         v_binder_list.dsp_frps_no := i.frps_no;
         v_binder_list.dsp_binder_no := i.binder_no;
         v_binder_list.dsp_reinsurer := i.dsp_reinsurer;
         v_binder_list.ri_shr_pct := i.ri_shr_pct;
         v_binder_list.ri_tsi_amt := i.ri_tsi_amt;
         v_binder_list.ri_prem_amt := i.ri_prem_amt;
         v_binder_list.ri_cd := i.ri_cd;
         v_binder_list.currency_cd := i.currency_cd;
         v_binder_list.currency_rt := i.currency_rt;

         IF i.master_bndr_id IS NOT NULL
         THEN
            v_binder_list.dsp_grp_binder_no := i.grp_binder_no;
         ELSE
            v_binder_list.dsp_grp_binder_no := NULL;
         END IF;

         v_binder_list.master_bndr_id := i.master_bndr_id;
         PIPE ROW (v_binder_list);
      END LOOP;
   END;

   /*
   **  Created by       : Jerome Orio
   **  Date Created     : 01.18.2012
   **  Reference By     : (GIRIS053A- Generate Package Binders)
   **  Description      :  reverse package binder
   */
   PROCEDURE reverse_package_binder (
      p_pack_binder_id   giri_frps_ri.pack_binder_id%TYPE
   )
   IS
   BEGIN
      UPDATE giri_pack_binder_hdr
         SET reverse_tag = 'Y'
       WHERE pack_binder_id = p_pack_binder_id;

      UPDATE giri_frps_ri
         SET pack_binder_id = NULL
       WHERE pack_binder_id = p_pack_binder_id;
   END;

   /*
   **  Created by       : Jerome Orio
   **  Date Created     : 01.18.2012
   **  Reference By     : (GIRIS053A- Generate Package Binders)
   **  Description      :  to insert records to giri_pack_binder_hdr
   */
   PROCEDURE create_pack_binder (
      p_pack_line_cd     giis_fbndr_seq.line_cd%TYPE,
      p_pack_binder_id   giri_frps_ri.pack_binder_id%TYPE,
      p_pack_policy_id   giri_pack_binder_hdr.pack_policy_id%TYPE,
      p_ri_cd            giri_frps_ri.ri_cd%TYPE,
      p_currency_cd      giri_distfrps.currency_cd%TYPE,
      p_currency_rt      giri_distfrps.currency_rt%TYPE
   )
   IS
      v_binder_yy         giri_binder.binder_yy%TYPE;
      v_binder_seq_no     giri_binder.binder_seq_no%TYPE     := 1;
      v_ri_tsi_amt        giri_binder.ri_tsi_amt%TYPE;
      v_ri_shr_pct        giri_binder.ri_shr_pct%TYPE;
      v_ri_prem_amt       giri_binder.ri_prem_amt%TYPE;
      v_ri_comm_rt        giri_binder.ri_comm_rt%TYPE;
      v_ri_comm_amt       giri_binder.ri_comm_amt%TYPE;
      v_prem_tax          giri_binder.prem_tax%TYPE;
      v_ri_prem_vat       giri_binder.ri_prem_vat%TYPE;
      v_ri_comm_vat       giri_binder.ri_comm_vat%TYPE;
      v_ri_wholding_vat   giri_binder.ri_wholding_vat%TYPE;
      v_tsi_amt           giri_distfrps.tsi_amt%TYPE         := 0;
      v_prem_amt          giri_distfrps.prem_amt%TYPE        := 0;
   --A.R.C. 01.02.2007
   BEGIN
      BEGIN
         SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'YY'))
           INTO v_binder_yy
           FROM DUAL;

         SELECT fbndr_seq_no + 1
           INTO v_binder_seq_no
           FROM giis_fbndr_seq
          WHERE line_cd = p_pack_line_cd AND fbndr_yy = v_binder_yy;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            INSERT INTO giis_fbndr_seq
                        (line_cd, fbndr_yy, fbndr_seq_no, user_id,
                         last_update, remarks
                        )
                 VALUES (p_pack_line_cd, v_binder_yy, 1, USER,
                         SYSDATE, 'package  binder'
                        );
      END;

      FOR v IN (SELECT line_cd, frps_yy, frps_seq_no
                  FROM giri_frps_ri
                 WHERE pack_binder_id = p_pack_binder_id
                   AND reverse_sw <> 'Y' /*added by: ging 032107*/)
      LOOP
         FOR m IN (SELECT tsi_amt, prem_amt               --A.R.C. 01.02.2006
                     FROM giri_distfrps
                    WHERE line_cd = v.line_cd
                      AND frps_yy = v.frps_yy
                      AND frps_seq_no = v.frps_seq_no)
         LOOP
            v_tsi_amt := v_tsi_amt + m.tsi_amt;
            v_prem_amt := v_prem_amt + m.prem_amt;        --A.R.C. 01.02.2007
         END LOOP;
      END LOOP;

      /*modified by: ging 032307 -added NVL, and corrected ri_comm_rt formula */
      /*modified by: ramon, 01/08/09, avoid zero divide error in computation of ri_comm_rt*/
      FOR DATA IN
         (SELECT SUM (NVL (ri_prem_amt, 0)) ri_prem_amt,
                 SUM (NVL (ri_tsi_amt, 0)) ri_tsi_amt,
                 SUM (NVL (ri_comm_amt, 0)) ri_comm_amt,
                 SUM (NVL (prem_tax, 0)) prem_tax,         /*AVG(ri_comm_rt)*/
                 (  NVL ((  SUM (NVL (ri_comm_amt, 0))
                          /                        /*SUM(nvl(ri_prem_amt,0))*/
                            DECODE (SUM (NVL (ri_prem_amt, 0)),
                                    0, NULL,
                                    SUM (NVL (ri_prem_amt, 0))
                                   )
                         ),
                         0
                        )
                  * 100
                 ) ri_comm_rt,
                 SUM (NVL (ri_prem_vat, 0)) ri_prem_vat,
                 SUM (NVL (ri_comm_vat, 0)) ri_comm_vat,
                 SUM (NVL (ri_wholding_vat, 0)) ri_wholding_vat
            FROM giri_frps_ri
           WHERE pack_binder_id = p_pack_binder_id
             AND reverse_sw <> 'Y' /*added by: ging031506*/)
      LOOP
         v_ri_tsi_amt := DATA.ri_tsi_amt;
         v_ri_prem_amt := DATA.ri_prem_amt;
         v_ri_comm_rt := DATA.ri_comm_rt;
         v_ri_comm_amt := DATA.ri_comm_amt;
         v_ri_prem_vat := DATA.ri_prem_vat;
         v_ri_comm_vat := DATA.ri_comm_vat;
         v_ri_wholding_vat := DATA.ri_wholding_vat;
         v_prem_tax := DATA.prem_tax;
         EXIT;
      END LOOP;

      IF v_tsi_amt <> 0
      THEN
         v_ri_shr_pct := (v_ri_tsi_amt / v_tsi_amt) * 100;
      ELSIF v_tsi_amt = 0 AND v_prem_amt <> 0 
      THEN
         v_ri_shr_pct := (v_ri_prem_amt / v_prem_amt) * 100;
      ELSE
         v_ri_shr_pct := 0;
      END IF;

      INSERT INTO giri_pack_binder_hdr
                  (pack_policy_id, pack_binder_id, line_cd,
                   binder_yy, binder_seq_no, ri_cd, ri_tsi_amt,
                   ri_shr_pct, ri_prem_amt, ri_comm_rt, ri_comm_amt,
                   prem_tax, ri_prem_vat, ri_comm_vat,
                   ri_wholding_vat, currency_cd, currency_rt,
                   --A.R.C. 12.27.2006
                   tsi_amt, binder_date,                   --A.R.C. 12.29.2006
                                        prem_amt
                  )                                        --A.R.C. 01.02.2007
           VALUES (p_pack_policy_id, p_pack_binder_id, p_pack_line_cd,
                   v_binder_yy, v_binder_seq_no, p_ri_cd, v_ri_tsi_amt,
                   v_ri_shr_pct, v_ri_prem_amt, v_ri_comm_rt, v_ri_comm_amt,
                   v_prem_tax, v_ri_prem_vat, v_ri_comm_vat,
                   v_ri_wholding_vat, p_currency_cd, p_currency_rt,
                   --A.R.C. 12.27.2006
                   v_tsi_amt, SYSDATE,                     --A.R.C. 12.29.2006
                                      v_prem_amt
                  );                                       --A.R.C. 01.02.2007

      UPDATE giis_fbndr_seq
         SET fbndr_seq_no = v_binder_seq_no
       WHERE line_cd = p_pack_line_cd AND fbndr_yy = v_binder_yy;
   END;

   /*
   **  Created by       : Jerome Orio
   **  Date Created     : 01.18.2012
   **  Reference By     : (GIRIS053A- Generate Package Binders)
   **  Description      :
   */
   PROCEDURE gen_package_binder (
      p_pack_policy_id gipi_polbasic.pack_policy_id%TYPE,
      p_pack_line_cd   gipi_pack_parlist.line_cd%TYPE
   )
   IS
      v_list   gen_package_binder_type;
   BEGIN
      FOR c1 IN (SELECT DISTINCT a.ri_cd, b.currency_cd, b.currency_rt
                            FROM giri_frps_ri a, giri_distfrps b
                           WHERE 1 = 1
                             AND a.line_cd = b.line_cd
                             AND a.frps_yy = b.frps_yy
                             AND a.frps_seq_no = b.frps_seq_no
                             AND b.dist_no IN (
                                    SELECT y.dist_no dist_no
                                      FROM giuw_pol_dist y, gipi_polbasic z
                                     WHERE y.policy_id = z.policy_id
                                       AND y.dist_flag NOT IN (4, 5)
                                       AND z.pack_policy_id = p_pack_policy_id)
                             AND a.reverse_sw != 'Y'
                             AND a.pack_binder_id IS NULL)
      LOOP
         v_list.ri_cd := c1.ri_cd;
         v_list.currency_cd := c1.currency_cd;
         v_list.currency_rt := c1.currency_rt;

         SELECT pack_binder_id_s.NEXTVAL
           INTO v_list.pack_binder_id
           FROM DUAL;

         FOR i IN (SELECT  *
		          		  FROM TABLE (giri_frps_ri_pkg.get_giri_frps_ri3(p_pack_policy_id))                  
                   )
         LOOP
           giri_frps_ri_pkg.update_pack_binder_id(i.ri_cd, i.currency_cd, i. currency_rt
                                                 ,i.line_cd, i.frps_yy, i.frps_seq_no
                                                 ,i.fnl_binder_id, c1.ri_cd, c1.currency_cd
                                                 ,c1.currency_rt, v_list.pack_binder_id); 
         END LOOP;

         giri_frps_ri_pkg.create_pack_binder(p_pack_line_cd, v_list.pack_binder_id, p_pack_policy_id, c1.ri_cd, c1.currency_cd, c1.currency_rt);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by       : Jerome Orio
   **  Date Created     : 01.18.2012
   **  Reference By     : (GIRIS053A- Generate Package Binders)
   **  Description      :
   */
   PROCEDURE update_pack_binder_id (
      p_ri_cd            giri_frps_ri.ri_cd%TYPE,
      p_currency_cd      giri_distfrps.currency_cd%TYPE,
      p_currency_rt      giri_distfrps.currency_rt%TYPE,
      p_line_cd          giri_frps_ri.line_cd%TYPE,
      p_frps_yy          giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no      giri_frps_ri.frps_seq_no%TYPE,
      p_fnl_binder_id    giri_frps_ri.fnl_binder_id%TYPE,
      v_ri_cd            giri_frps_ri.ri_cd%TYPE,
      v_currency_cd      giri_distfrps.currency_cd%TYPE,
      v_currency_rt      giri_distfrps.currency_rt%TYPE,
      v_pack_binder_id   giri_frps_ri.pack_binder_id%TYPE
   )
   IS
   BEGIN
      IF     p_ri_cd = v_ri_cd
         AND p_currency_cd = v_currency_cd
         AND p_currency_rt = v_currency_rt
      THEN               --A.R.C. 12.27.2006 --add currency_cd and currency_rt
         UPDATE giri_frps_ri
            SET pack_binder_id = v_pack_binder_id
          WHERE line_cd = p_line_cd
            AND frps_yy = p_frps_yy
            AND frps_seq_no = p_frps_seq_no
            AND ri_cd = p_ri_cd;

         INSERT INTO giri_pack_binder_dtl
                     (pack_binder_id, binder_id
                     )
              VALUES (v_pack_binder_id, p_fnl_binder_id
                     );
      END IF;
   END;

   /*
    **  Created by       : Emsy Bola?os
    **  Date Created     : 01.31.2012
    **  Reference By     : (GIRIS053- Group Binders)
    **  Description      : selects the maximum pre_binder_Id used which is stored in giis_parameters.
    */
   FUNCTION get_binder_id
      RETURN NUMBER
   IS
      v_binder_id       VARCHAR2 (3200);
      v_pre_binder_id   giri_wfrps_ri.pre_binder_id%TYPE;
      v_fnl_binder_id   giri_wfrps_ri.pre_binder_id%TYPE;
--      v_binder_id_list     get_binder_id_type;
   BEGIN
      BEGIN
         -- lian 081001
         --SELECT param_value_n
         -- lian 092501
         --SELECT binder_id
         SELECT binder_id_s.NEXTVAL binder_id
           INTO v_binder_id
           FROM DUAL;
--      LOOP
--           v_binder_id_list.binder_id  :=  i.binder_id;
--          pipe row( v_binder_id_list);
--      END LOOP;
        --FROM giis_binder_id;
        --FROM giis_parameters
        --WHERE param_name like 'BINDER_ID';
       /*
       ** Commented by : aivhie
       ** Date         : 100301
       ** Description  : the ff. exception commented since binder_id is already a sequence
       **                and no need to be based or to be inserted in giis_binder_id table
       */
        /*EXCEPTION
          WHEN NO_DATA_FOUND THEN
            INSERT INTO giis_binder_id
                 VALUES (0);*/

      /*    INSERT INTO giis_parameters
            (PARAM_TYPE, PARAM_NAME, PARAM_VALUE_N, PARAM_LENGTH)
          VALUES
            ('N', 'BINDER_ID', 0, 8);*/
      END;

      --check max binder from giri_wfrps_ri
      SELECT MAX (pre_binder_id)
        INTO v_pre_binder_id
        FROM giri_wfrps_ri;

      --check max binder from giri_frps_ri
      SELECT MAX (fnl_binder_id)
        INTO v_fnl_binder_id
        FROM giri_frps_ri;

      IF v_pre_binder_id < v_fnl_binder_id
      THEN
         v_pre_binder_id := v_fnl_binder_id;
      END IF;

      --variable.binder_id := variable.binder_id + 1;
      IF v_binder_id < v_pre_binder_id
      THEN
         v_binder_id := v_pre_binder_id;
      END IF;

      SELECT binder_id_s.NEXTVAL
        INTO v_binder_id
        FROM DUAL;

      -- lian 081001
      --UPDATE giis_parameters
       /*
       ** Commented by : aivhie
       ** Date         : 100301
       ** Description  : the ff. exception commented since binder_id is already a sequence
       **                and no need to be based or to be inserted in giis_binder_id table
       */
       /*UPDATE giis_binder_id
         SET binder_id = variable.binder_id;
       --WHERE param_name like 'BINDER_ID'*/
      RETURN v_binder_id;
   END;

   /*
   **  Created by       : Emsy Bola?os
   **  Date Created     : 02.01.2012
   **  Reference By     : (GIRIS053 - Group Binders)
   **  Description      :
   */
   PROCEDURE update_master_bndr_id (
      p_line_cd       giri_frps_ri.line_cd%TYPE,
      p_frps_yy       giri_frps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_frps_ri.frps_seq_no%TYPE,
      p_ri_cd         giri_frps_ri.ri_cd%TYPE,
      p_binder_id     NUMBER
   )
   IS
   BEGIN
      UPDATE giri_frps_ri
         SET master_bndr_id = p_binder_id
       WHERE line_cd = p_line_cd
         AND frps_yy = p_frps_yy
         AND frps_seq_no = p_frps_seq_no
         AND ri_cd = p_ri_cd
         AND reverse_sw != 'Y';
   END;

   /*
   **  Created by       : Emsy Bola?os
   **  Date Created     : 02.01.2012
   **  Reference By     : (GIRIS053 - Group Binders)
   **  Description      :
   */
   PROCEDURE create_binder (
      p_line_cd     giri_frps_ri.line_cd%TYPE,
      p_ri_cd       giri_frps_ri.ri_cd%TYPE,
      p_binder_id   NUMBER ,
      P_USER_ID             VARCHAR2
   )
   IS
      v_binder_seq_no     giri_binder.binder_seq_no%TYPE;
      v_binder_date       giri_binder.binder_date%TYPE;
      v_binder_yy         giri_binder.binder_yy%TYPE;
      v_ri_tsi_amt        giri_binder.ri_tsi_amt%TYPE;
      v_ri_shr_pct        giri_binder.ri_shr_pct%TYPE;
      v_ri_prem_amt       giri_binder.ri_prem_amt%TYPE;
      v_ri_comm_rt        giri_binder.ri_comm_rt%TYPE;
      v_ri_comm_amt       giri_binder.ri_comm_amt%TYPE;
      v_prem_tax          giri_binder.prem_tax%TYPE;
      v_ri_prem_vat       giri_binder.ri_prem_vat%TYPE;
      v_ri_comm_vat       giri_binder.ri_comm_vat%TYPE;
      v_ri_wholding_vat   giri_binder.ri_wholding_vat%TYPE;
      v_tsi_amt           giri_distfrps.tsi_amt%TYPE         := 0;
   BEGIN
      v_binder_seq_no := 1;

      BEGIN
         SELECT SYSDATE, TO_NUMBER (TO_CHAR (SYSDATE, 'YY'))
           INTO v_binder_date, v_binder_yy
           FROM DUAL;

         SELECT fbndr_seq_no + 1
           INTO v_binder_seq_no
           FROM giis_fbndr_seq
          WHERE line_cd = p_line_cd AND fbndr_yy = v_binder_yy;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            INSERT INTO giis_fbndr_seq
                        (line_cd, fbndr_yy, fbndr_seq_no, user_id,
                         last_update, remarks
                        )
                 VALUES (p_line_cd, v_binder_yy, 1, p_user_id,
                         v_binder_date, 'grouping of binders'
                        );
      END;

      FOR v IN (SELECT line_cd, frps_yy, frps_seq_no
                  FROM giri_frps_ri
                 WHERE master_bndr_id = p_binder_id)
      LOOP
         FOR m IN (SELECT tsi_amt
                     FROM giri_distfrps
                    WHERE line_cd = v.line_cd
                      AND frps_yy = v.frps_yy
                      AND frps_seq_no = v.frps_seq_no)
         LOOP
            v_tsi_amt := m.tsi_amt + v_tsi_amt;
         END LOOP;
      -- EXIT;
      END LOOP;

      FOR DATA IN
         (SELECT /*SUM(ri_shr_pct) ri_shr_pct,*/ SUM (ri_prem_amt)
                                                                  ri_prem_amt,
                  SUM (ri_tsi_amt) ri_tsi_amt, SUM (ri_comm_amt) ri_comm_amt,
                  SUM (prem_tax) prem_tax, AVG (ri_comm_rt) ri_comm_rt,
                  SUM (ri_prem_vat) ri_prem_vat, SUM (ri_comm_vat)
                                                                  ri_comm_vat,
                  SUM (ri_wholding_vat) ri_wholding_vat
            FROM giri_frps_ri
           WHERE master_bndr_id = p_binder_id)
      LOOP
         v_ri_tsi_amt := DATA.ri_tsi_amt;
         --v_ri_shr_pct  := data.ri_shr_pct;
         v_ri_prem_amt := DATA.ri_prem_amt;
         v_ri_comm_rt := DATA.ri_comm_rt;
         v_ri_comm_amt := DATA.ri_comm_amt;
         v_ri_prem_vat := DATA.ri_prem_vat;
         v_ri_comm_vat := DATA.ri_comm_vat;
         v_ri_wholding_vat := DATA.ri_wholding_vat;
         v_prem_tax := DATA.prem_tax;
         EXIT;
      END LOOP;

      IF v_tsi_amt != 0
      THEN
         v_ri_shr_pct := (v_ri_tsi_amt / v_tsi_amt) * 100;
      ELSE
         v_ri_shr_pct := 0;
      END IF;

      INSERT INTO giri_group_binder
                  (master_bndr_id, line_cd, binder_yy, binder_seq_no,
                   ri_cd, ri_tsi_amt, ri_shr_pct, ri_prem_amt,
                   ri_comm_rt, ri_comm_amt, prem_tax, binder_date,
                   ri_prem_vat, ri_comm_vat, ri_wholding_vat
                  )
           VALUES (p_binder_id, p_line_cd, v_binder_yy, v_binder_seq_no,
                   p_ri_cd, v_ri_tsi_amt, v_ri_shr_pct, v_ri_prem_amt,
                   v_ri_comm_rt, v_ri_comm_amt, v_prem_tax, SYSDATE,
                   v_ri_prem_vat, v_ri_comm_vat, v_ri_wholding_vat
                  );

      UPDATE giis_fbndr_seq
         SET fbndr_seq_no = v_binder_seq_no
       WHERE line_cd = p_line_cd AND fbndr_yy = v_binder_yy;
   END;

   /*
   **  Created by       : Emsy Bola?os
   **  Date Created     : 02.01.2012
   **  Reference By     : (GIRIS053 - Group Binders)
   **  Description      :
   */
   PROCEDURE create_binder_peril_giris053 (p_binder_id NUMBER)
   IS
      v_ri_shr_pct   giri_wfrperil.ri_shr_pct%TYPE;
      v_ri_comm_rt   giri_wfrperil.ri_comm_rt%TYPE;
      v_peril_seq_no NUMBER := 0;
      CURSOR wperil_area
      IS
         SELECT   /*peril_seq_no,*/ t3.peril_cd, SUM (t1.ri_tsi_amt) ri_tsi_amt,  --commented out peril_seq_no : edgar 12/02/2014
                  SUM (t1.ri_prem_amt) ri_prem_amt,
                  SUM (t1.ri_comm_amt) ri_comm_amt, SUM (tsi_amt) tsi_amt,
                  SUM (prem_amt) prem_amt, SUM (t1.ri_prem_vat) ri_prem_vat,
                  SUM (t1.ri_comm_vat) ri_comm_vat,
                  SUM (t1.ri_wholding_vat) ri_wholding_vat
             FROM giri_frperil t1, giri_frps_ri t2, giri_frps_peril_grp t3
            WHERE t1.line_cd = t2.line_cd
              AND t1.frps_yy = t2.frps_yy
              AND t1.frps_seq_no = t2.frps_seq_no
              AND t1.ri_seq_no = t2.ri_seq_no
              AND t2.line_cd = t3.line_cd
              AND t2.frps_yy = t3.frps_yy
              AND t1.frps_seq_no = t3.frps_seq_no
              AND t1.peril_cd = t3.peril_cd                     -- beth 082798
              AND t2.master_bndr_id = p_binder_id
         GROUP BY /*peril_seq_no,*/ t3.peril_cd  --commented out peril_seq_no : edgar 12/02/2014
         --ORDER BY peril_seq_no, t3.peril_cd;            /*petermkaw 07012010*/ --commented out edgar 12/02/2014
         ORDER BY tsi_amt DESC, t3.peril_cd ASC; --edgar 12/02/2014
   BEGIN
      FOR c1_rec IN wperil_area
      LOOP
         IF c1_rec.tsi_amt != 0
         THEN
            v_ri_shr_pct := ROUND(((c1_rec.ri_tsi_amt / c1_rec.tsi_amt) * 100),9); --added round function : edgar 12/02/2014
         ELSE
            IF c1_rec.prem_amt != 0
            THEN
               v_ri_shr_pct := ROUND(((c1_rec.ri_prem_amt / c1_rec.prem_amt) * 100),9); --added round function : edgar 12/02/2014
            ELSE
               v_ri_shr_pct := 0;
            END IF;
         END IF;

         IF c1_rec.prem_amt != 0
         THEN
            v_ri_comm_rt := ROUND(((c1_rec.ri_comm_amt / c1_rec.ri_prem_amt) * 100),9); --added round function : edgar 12/02/2014
         ELSE
            v_ri_comm_rt := 0;
         END IF;
         v_peril_seq_no := v_peril_seq_no + 1; --edgar 12/02/2014
         /*msg_alert('ppmk dito nagiinsert','I',false); ||','||
         (variable.binder_id,   c1_rec.peril_seq_no, c1_rec.ri_tsi_amt,
            v_ri_shr_pct,         c1_rec.ri_prem_amt,  v_ri_comm_rt,
            c1_rec.ri_comm_amt,   c1_rec.ri_prem_vat,  c1_rec.ri_comm_vat,
            c1_rec.ri_wholding_vat)*/
         INSERT INTO giri_group_binder_peril
                     (master_bndr_id, peril_seq_no, ri_tsi_amt,
                      ri_shr_pct, ri_prem_amt, ri_comm_rt,
                      ri_comm_amt, ri_prem_vat,
                      ri_comm_vat, ri_wholding_vat, peril_cd
                     )                       /*peril_cd petermkaw 07012010) */
              VALUES (p_binder_id, /*c1_rec.peril_seq_no*/v_peril_seq_no, c1_rec.ri_tsi_amt,  --commented out peril_seq_no : edgar 12/02/2014
                      v_ri_shr_pct, c1_rec.ri_prem_amt, v_ri_comm_rt,
                      c1_rec.ri_comm_amt, c1_rec.ri_prem_vat,
                      c1_rec.ri_comm_vat, c1_rec.ri_wholding_vat, c1_rec.peril_cd
                     );               /*c1_rec.peril_cd petermkaw 07012010) */
      END LOOP;
   END;

   /*
    **  Created by      : Emsy Bola?os
    **  Date Created    : 01.13.2012
    **  Reference By    : (GIRIS053 - Group Binders)
    **  Description     :  get binder table grid (giri_frps_ri)
    */
   PROCEDURE ungroup_binders (p_master_bndr_id NUMBER)
   IS
   BEGIN
      FOR a IN (SELECT fnl_binder_id
                  FROM giri_frps_ri
                 WHERE master_bndr_id = p_master_bndr_id)
      LOOP
         INSERT INTO giri_group_bindrel_rev
                     (master_bndr_id, fnl_binder_id, user_id, last_update
                     )
              VALUES (p_master_bndr_id, a.fnl_binder_id, USER, SYSDATE
                     );
      END LOOP;

      UPDATE giri_frps_ri
         SET master_bndr_id = NULL
       WHERE master_bndr_id = p_master_bndr_id;

      UPDATE giri_group_binder
         SET reverse_date = SYSDATE
       WHERE master_bndr_id = p_master_bndr_id;
   END;
END giri_frps_ri_pkg;
/


