CREATE OR REPLACE PACKAGE BODY CPI.GIACS353_PKG
AS
   FUNCTION get_checking_scripts
      RETURN checking_scripts_tab
      PIPELINED
   IS
      v_list   checking_scripts_type;
   BEGIN
      FOR i IN (  SELECT *
                    FROM giac_eom_checking_scripts
                   WHERE NVL (display_sw, 'Y') = 'Y' --mikel 05.30.2016; do not display the scripts for data error
                ORDER BY eom_script_no)
      LOOP
         v_list.eom_script_no := i.eom_script_no;
         v_list.eom_script_title := i.eom_script_title;
         v_list.eom_script_text_1 := i.eom_script_text_1;
         v_list.eom_script_text_2 := i.eom_script_text_2;
         v_list.eom_script_soln := i.eom_script_soln;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update := i.last_update;
         v_list.check_book_date := i.check_book_date;       --mikel 05.30.2016

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_checking_scripts;

   FUNCTION get_data_type (p_query VARCHAR2)
      RETURN VARCHAR2
   AS
      v_start       NUMBER := 0;
      v_end         NUMBER := 0;
      v_data_type   VARCHAR2 (40);
   BEGIN
      v_start := INSTR (p_query, '<dt>');
      v_end := INSTR (p_query, '<DT>');
      v_data_type :=
         UPPER (SUBSTR (p_query, v_start + 4, (v_end - v_start) - 4));
      RETURN (v_data_type);
   END get_data_type;

   FUNCTION get_format (p_query VARCHAR2)
      RETURN VARCHAR2
   AS
      v_start    NUMBER := 0;
      v_end      NUMBER := 0;
      v_format   VARCHAR2 (300);
   BEGIN
      v_start := INSTR (p_query, '<f>');
      v_end := INSTR (p_query, '<F>');
      v_format := UPPER (SUBSTR (p_query, v_start + 3, (v_end - v_start) - 3));
      RETURN (v_format);
   END get_format;

   FUNCTION get_param_restriction (p_query VARCHAR2)
      RETURN VARCHAR2
   AS
      v_start         NUMBER := 0;
      v_end           NUMBER := 0;
      v_restriction   VARCHAR2 (200);
   BEGIN
      v_start := INSTR (p_query, '<res>');
      v_end := INSTR (p_query, '<RES>');
      v_restriction :=
         UPPER (SUBSTR (p_query, v_start + 5, (v_end - v_start) - 5));
      RETURN (v_restriction);
   END get_param_restriction;

   FUNCTION check_query (p_month VARCHAR2, p_year VARCHAR2, p_query VARCHAR2)
      RETURN check_query_tab
      PIPELINED
   AS
      v_list          check_query_type;
      v_data_type     VARCHAR2 (40);
      v_format        VARCHAR2 (300);
      v_restriction   VARCHAR2 (200);
      v_value         VARCHAR2 (300);
      v_rep_start     NUMBER := 0;
      v_rep_end       NUMBER := 0;
      v_old           VARCHAR2 (32767);
      v_new           VARCHAR2 (32767);
   BEGIN
      IF INSTR (p_query, '/*') <> 0
      THEN
         v_data_type := get_data_type (p_query);
         v_format := get_format (p_query);
         v_restriction := get_param_restriction (p_query);

         IF v_data_type = 'VARCHAR2'
         THEN
            v_value :=
               TO_CHAR (
                  LAST_DAY (TO_DATE ('01-' || p_month || '-' || p_year)),
                  'fm' || v_format);
         ELSIF v_data_type = 'NUMBER'
         THEN
            v_value := p_year;
         ELSIF v_data_type = 'DATE'
         THEN
            v_value := TO_DATE (LAST_DAY ('01-' || p_month || '-' || p_year));
         ELSE
            v_list.stat := 'ERROR';
         END IF;

         v_rep_start := INSTR (p_query, '/*');
         v_rep_end := INSTR (p_query, '*/');
         v_old := SUBSTR (p_query, v_rep_start, (v_rep_end - v_rep_start) + 2);

         IF v_data_type = 'NUMBER'
         THEN
            v_new := v_restriction || ' = ' || v_value;
         ELSE
            v_new := v_restriction || ' = ' || '''' || v_value || '''';
         END IF;

         v_list.script := REPLACE (p_query, v_old, v_new);
      ELSE
         v_list.script := p_query;
         v_list.stat := 'SUCCESS';
      END IF;

      PIPE ROW (v_list);
   --      RETURN v_list;
   END check_query;

   --mikel 05.27.2016; GENQA 5544
   PROCEDURE insert_upd_pol_dist (p_policy_id gipi_polbasic.policy_id%TYPE)
   IS
      v_dist_no         NUMBER;
      v_par_id_exists   BOOLEAN := FALSE;
   BEGIN
      FOR a IN (SELECT a.policy_id,
                       get_policy_no (a.policy_id) policy_no,
                       a.par_id,
                       a.endt_type,
                       a.tsi_amt,
                       c.prem_amt * c.currency_rt prem_amt,
                       a.ann_tsi_amt,
                       a.eff_date,
                       a.expiry_date,
                       a.booking_mth,
                       a.booking_year,
                       d.user_name,
                       c.takeup_seq_no,
                       a.line_cd,
                       c.item_grp
                  FROM gipi_polbasic a,
                       giis_subline b,
                       gipi_invoice c,
                       giis_users d
                 WHERE     a.policy_id = c.policy_id
                       AND NOT EXISTS
                              (SELECT '1'
                                 FROM giuw_pol_dist b
                                WHERE a.policy_id = b.policy_id)
                       AND a.reg_policy_sw = 'Y'
                       AND a.pol_flag != '5'
                       AND NVL (endt_type, 'A') != 'N'
                       AND a.subline_cd = b.subline_cd
                       AND a.line_cd = b.line_cd
                       AND a.user_id = d.user_id
                       AND b.op_flag = 'N'
                       AND a.policy_id = p_policy_id)
      LOOP
         v_par_id_exists := FALSE;

         FOR upd IN (SELECT 'X'
                       FROM giuw_pol_dist
                      WHERE par_id = a.par_id)
         LOOP
            v_par_id_exists := TRUE;
            EXIT;
         END LOOP;

         --USE AUTO_CREATE_DISTRIBUTION
         --MAKE IT UNDISTRIBUTED
         IF v_par_id_exists
         THEN
            UPDATE giuw_pol_dist
               SET policy_id = a.policy_id
             WHERE par_id = a.par_id;
         ELSE
            SELECT pol_dist_dist_no_s.NEXTVAL INTO v_dist_no FROM DUAL;

            INSERT INTO giuw_pol_dist (dist_no,
                                       par_id,
                                       policy_id,
                                       endt_type,
                                       tsi_amt,
                                       prem_amt,
                                       ann_tsi_amt,
                                       dist_flag,
                                       redist_flag,
                                       eff_date,
                                       expiry_date,
                                       create_date,
                                       user_id,
                                       last_upd_date,
                                       post_flag,
                                       auto_dist,
                                       item_grp,
                                       takeup_seq_no,
                                       acct_ent_date)
                 VALUES (v_dist_no,
                         a.par_id,
                         a.policy_id,
                         a.endt_type,
                         a.tsi_amt,
                         a.prem_amt,
                         a.ann_tsi_amt,
                         1,
                         1,
                         a.eff_date,
                         a.expiry_date,
                         SYSDATE,
                         USER,
                         SYSDATE,
                         'O',
                         'N',
                         NULL,
                         a.takeup_seq_no,
                         NULL);

            CPI.AUTO_CREATE_DISTRIBUTION (v_dist_no,
                                          a.line_cd,
                                          a.policy_id,
                                          a.item_grp);
         END IF;
      END LOOP;

      COMMIT;
   END;

   PROCEDURE update_pol_flag (p_policy_id gipi_polbasic.policy_id%TYPE)
   IS
   BEGIN
      UPDATE gipi_polbasic
         SET pol_flag = '5'
       WHERE policy_id = p_policy_id;

      COMMIT;
   END;

   PROCEDURE update_booking_date (p_policy_id gipi_polbasic.policy_id%TYPE)
   IS
      v_month   gipi_invoice.multi_booking_mm%TYPE;
      v_year    gipi_invoice.multi_booking_yy%TYPE;
   BEGIN
      SELECT multi_booking_mm, multi_booking_yy
        INTO v_month, v_year
        FROM gipi_invoice
       WHERE policy_id = p_policy_id;

      UPDATE gipi_polbasic
         SET booking_mth = v_month, booking_year = v_year
       WHERE policy_id = p_policy_id;

      COMMIT;
   END;

   PROCEDURE update_direct_comm (p_policy_id gipi_polbasic.policy_id%TYPE)
   IS
      v_prem_comm_inv         gipi_comm_invoice.premium_amt%TYPE;
      v_prem_comm_inv_peril   gipi_comm_inv_peril.premium_amt%TYPE;
      v_prem_intm_peril       gipi_comm_invoice.premium_amt%TYPE;
      v_wtax_rate             giis_intermediary.wtax_rate%TYPE;
      v_iss_cd                gipi_invoice.iss_cd%TYPE;
      v_prem_seq_no           gipi_invoice.prem_seq_no%TYPE;
   BEGIN
      BEGIN
         FOR rec
            IN (  SELECT a.policy_id,
                         a.iss_cd,
                         a.prem_seq_no,
                         SUM (b.prem_amt) prem_invperil
                    FROM gipi_invoice a, gipi_invperil b
                   WHERE     a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND a.policy_id = p_policy_id
                GROUP BY a.policy_id, a.iss_cd, a.prem_seq_no)
         LOOP
            BEGIN
               SELECT NVL (SUM (premium_amt), 0) prem_comminv
                 INTO v_prem_comm_inv
                 FROM gipi_comm_invoice
                WHERE iss_cd = rec.iss_cd AND prem_seq_no = rec.prem_seq_no;

               IF rec.prem_invperil != v_prem_comm_inv
               THEN
                  UPDATE gipi_comm_invoice
                     SET premium_amt =
                            rec.prem_invperil * share_percentage / 100
                   WHERE     iss_cd = rec.iss_cd
                         AND prem_seq_no = rec.prem_seq_no;
               END IF;
            END;

            BEGIN
               SELECT NVL (SUM (premium_amt), 0)
                 INTO v_prem_comm_inv_peril
                 FROM gipi_comm_inv_peril
                WHERE iss_cd = rec.iss_cd AND prem_seq_no = rec.prem_seq_no;

               FOR peril
                  IN (SELECT intrmdry_intm_no, peril_cd
                        FROM gipi_comm_inv_peril
                       WHERE     iss_cd = rec.iss_cd
                             AND prem_seq_no = rec.prem_seq_no)
               LOOP
                  SELECT a.prem_amt * share_percentage / 100, c.wtax_rate
                    INTO v_prem_intm_peril, v_wtax_rate
                    FROM gipi_invperil a,
                         gipi_comm_invoice b,
                         giis_intermediary c
                   WHERE     a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND b.intrmdry_intm_no = c.intm_no
                         AND b.intrmdry_intm_no = peril.intrmdry_intm_no
                         AND a.peril_cd = peril.peril_cd
                         AND a.iss_cd = rec.iss_cd
                         AND a.prem_seq_no = rec.prem_seq_no;

                  UPDATE gipi_comm_inv_peril
                     SET premium_amt = v_prem_intm_peril,
                         commission_amt =
                            v_prem_intm_peril * (commission_rt / 100),
                         wholding_tax =
                              v_prem_intm_peril
                            * (commission_rt / 100)
                            * (v_wtax_rate / 100)
                   WHERE     intrmdry_intm_no = peril.intrmdry_intm_no
                         AND peril_cd = peril.peril_cd
                         AND iss_cd = rec.iss_cd
                         AND prem_seq_no = rec.prem_seq_no;
               END LOOP;
            END;
         END LOOP;

         COMMIT;
      END;

      BEGIN
         FOR rec IN (SELECT iss_cd, prem_seq_no
                       FROM gipi_invoice
                      WHERE policy_id = p_policy_id)
         LOOP
            FOR COMM
               IN (  SELECT intrmdry_intm_no,
                            SUM (commission_amt) comm_amt,
                            SUM (wholding_tax) wholding_tax
                       FROM GIPI_COMM_INV_PERIL
                      WHERE     iss_cd = rec.iss_cd
                            AND prem_seq_no = rec.prem_seq_no
                   GROUP BY intrmdry_intm_no)
            LOOP
               UPDATE GIPI_COMM_INVOICE
                  SET commission_amt = comm.comm_amt,
                      wholding_tax = comm.wholding_tax
                WHERE     iss_cd = rec.iss_cd
                      AND prem_seq_no = rec.prem_seq_no
                      AND intrmdry_intm_no = comm.intrmdry_intm_no;
            END LOOP;
         END LOOP;

         COMMIT;
      END;
   END;

   PROCEDURE update_ri_comm (p_policy_id gipi_polbasic.policy_id%TYPE)
   IS
      v_total_ri_comm   gipi_invoice.ri_comm_amt%TYPE := 0;
      v_vat_rate        giis_reinsurer.input_vat_rate%TYPE;
   BEGIN
      FOR jm IN (SELECT iss_cd, prem_seq_no, ri_comm_amt
                   FROM gipi_invoice
                  WHERE policy_id = p_policy_id)
      LOOP
         IF jm.iss_cd = 'RI'
         THEN
            FOR rec
               IN (  SELECT a.policy_id,
                            b.item_grp,
                            a.peril_cd,
                            c.iss_cd,
                            c.prem_seq_no,
                            SUM (a.ri_comm_amt) item_peril_ri_comm,
                            SUM (d.ri_comm_amt) inv_peril_ri_comm
                       FROM gipi_itmperil a,
                            gipi_item b,
                            gipi_invoice c,
                            gipi_invperil d
                      WHERE     a.policy_id = b.policy_id
                            AND a.item_no = b.item_no
                            AND b.policy_id = c.policy_id
                            AND b.item_grp = c.item_grp
                            AND c.iss_cd = d.iss_cd
                            AND c.prem_seq_no = d.prem_seq_no
                            AND a.peril_cd = d.peril_cd
                            AND c.iss_cd = jm.iss_cd
                            AND c.prem_seq_no = jm.prem_seq_no
                   GROUP BY a.policy_id,
                            b.item_grp,
                            a.peril_cd,
                            c.iss_cd,
                            c.prem_seq_no)
            LOOP
               v_total_ri_comm :=
                  v_total_ri_comm + NVL (rec.item_peril_ri_comm, 0);

               IF rec.item_peril_ri_comm != rec.inv_peril_ri_comm
               THEN
                  UPDATE gipi_invperil
                     SET ri_comm_amt = rec.item_peril_ri_comm
                   WHERE     iss_cd = rec.iss_cd
                         AND prem_seq_no = rec.prem_seq_no
                         AND item_grp = rec.item_grp
                         AND peril_cd = rec.peril_cd;
               END IF;
            END LOOP;

            SELECT input_vat_rate
              INTO v_vat_rate
              FROM giri_inpolbas x, giis_reinsurer y
             WHERE x.ri_cd = y.ri_cd AND x.policy_id = p_policy_id;

            IF v_total_ri_comm != jm.ri_comm_amt
            THEN
               UPDATE gipi_invoice
                  SET ri_comm_amt = v_total_ri_comm,
                      ri_comm_vat = v_total_ri_comm * (v_vat_rate / 100)
                WHERE iss_cd = jm.iss_cd AND prem_seq_no = jm.prem_seq_no;
            END IF;

            populate_ri_soa (jm.prem_seq_no);
         ELSE
            UPDATE gipi_invoice
               SET ri_comm_amt = 0, ri_comm_vat = 0
             WHERE     1 = 1
                   AND policy_id = p_policy_id
                   AND iss_cd != 'RI'
                   AND ri_comm_amt != 0;
         END IF;
      END LOOP;

      COMMIT;
   END;

   PROCEDURE update_dist_flag (
      p_policy_id     gipi_polbasic.policy_id%TYPE,
      p_dist_no       giuw_pol_dist.dist_no%TYPE,
      p_script_tag    giac_eom_checking_scripts.eom_script_tag%TYPE)
   IS
   BEGIN
      IF UPPER (p_script_tag) = 'DIST_UNDIST'
      THEN
         UPDATE gipi_polbasic
            SET dist_flag = 1
          WHERE policy_id = p_policy_id;

         UPDATE giuw_pol_dist
            SET dist_flag = 1
          WHERE policy_id = p_policy_id AND dist_no = p_dist_no;
      ELSIF UPPER (p_script_tag) = 'DIST_ENDTTAX'
      THEN
         UPDATE giuw_pol_dist
            SET dist_flag = 3
          WHERE policy_id = p_policy_id AND dist_no = p_dist_no;
      END IF;

      COMMIT;
   END;

   PROCEDURE update_takeup_seq_no (
      p_policy_id    gipi_polbasic.policy_id%TYPE,
      p_dist_no      giuw_pol_dist.dist_no%TYPE)
   IS
   BEGIN
      UPDATE gipi_invoice
         SET takeup_seq_no = 1
       WHERE policy_id = p_policy_id AND takeup_seq_no IS NULL;

      UPDATE giuw_pol_dist
         SET takeup_seq_no = 1
       WHERE     policy_id = p_policy_id
             AND dist_no = p_dist_no
             AND takeup_seq_no IS NULL;
   END;

   PROCEDURE update_currency_rt (p_policy_id    gipi_polbasic.policy_id%TYPE,
                                 p_dist_no      giuw_pol_dist.dist_no%TYPE)
   IS
      v_curr_cd   gipi_invoice.currency_cd%TYPE;
      v_curr_rt   gipi_invoice.currency_rt%TYPE;
   BEGIN
      SELECT a.currency_cd, a.currency_rt
        INTO v_curr_cd, v_curr_rt
        FROM gipi_invoice a
       WHERE     a.policy_id = p_policy_id
             AND EXISTS
                    (SELECT 'X'
                       FROM giri_distfrps x, gipi_invoice y, giuw_pol_dist z
                      WHERE     y.policy_id = z.policy_id
                            AND z.dist_no = x.dist_no
                            AND x.dist_no = p_dist_no
                            AND y.iss_cd = a.iss_cd
                            AND y.prem_seq_no = a.prem_seq_no);

      UPDATE giri_distfrps
         SET currency_cd = v_curr_cd, currency_rt = v_curr_rt
       WHERE dist_no = p_dist_no;

      COMMIT;
   END;

   PROCEDURE update_binder_amt (
      p_fnl_binder_id giri_binder.fnl_binder_id%TYPE)
   IS
   BEGIN
      FOR rec1
         IN (  SELECT w.subline_cd,
                      w.iss_cd,
                      w.issue_yy,
                      w.pol_seq_no,
                      w.renew_no,
                      y.fnl_binder_id,
                      y.ri_cd,
                      y.ri_seq_no,
                      y.ri_prem_amt,
                      y.ri_comm_amt,
                      y.ri_comm_vat,
                      x.line_cd,
                      x.frps_yy,
                      x.frps_seq_no
                 FROM cpi.giri_distfrps x,
                      cpi.giuw_pol_dist z,
                      cpi.gipi_polbasic w,
                      (SELECT c.fnl_binder_id,
                              c.line_cd,
                              d.frps_yy,
                              d.frps_seq_no,
                              d.ri_seq_no,
                              c.ri_cd,
                              c.ri_prem_amt,
                              prem_frperil,
                              c.ri_prem_amt - prem_frperil prem_diff,
                              c.ri_comm_amt,
                              comm_frperil,
                              c.ri_comm_amt - comm_frperil comm_diff,
                              c.ri_comm_vat,
                              vat_frperil,
                              c.ri_comm_vat - vat_frperil comm_vat_diff
                         FROM (SELECT fnl_binder_id,
                                      line_cd,
                                      ri_cd,
                                      ri_prem_amt,
                                      ri_comm_amt,
                                      ri_comm_vat
                                 FROM cpi.giri_binder
                                WHERE (       acc_ent_date IS NULL
                                          AND reverse_date IS NULL
                                       OR (    reverse_date IS NOT NULL
                                           AND acc_rev_date IS NULL
                                           AND acc_ent_date IS NOT NULL))) c,
                              (  SELECT b.fnl_binder_id,
                                        a.line_cd,
                                        a.frps_yy,
                                        a.frps_seq_no,
                                        a.ri_seq_no,
                                        SUM (a.ri_prem_amt) prem_frperil,
                                        SUM (a.ri_comm_amt) comm_frperil,
                                        SUM (a.ri_comm_vat) vat_frperil
                                   FROM cpi.giri_frperil a, cpi.giri_frps_ri b
                                  WHERE     a.line_cd = b.line_cd
                                        AND a.frps_yy = b.frps_yy
                                        AND a.frps_seq_no = b.frps_seq_no
                                        AND a.ri_seq_no = b.ri_seq_no
                               GROUP BY b.fnl_binder_id,
                                        a.line_cd,
                                        a.frps_yy,
                                        a.frps_seq_no,
                                        a.ri_seq_no) d
                        WHERE     c.fnl_binder_id = d.fnl_binder_id
                              AND (   c.ri_prem_amt <> prem_frperil
                                   OR c.ri_comm_amt <> comm_frperil
                                   OR c.ri_comm_vat <> vat_frperil)) y
                WHERE     x.line_cd = y.line_cd
                      AND x.frps_yy = y.frps_yy
                      AND x.frps_seq_no = y.frps_seq_no
                      AND x.dist_no = z.dist_no
                      AND z.policy_id = w.policy_id
                      AND (   (z.dist_flag = '3' AND z.acct_ent_date IS NULL)
                           OR (    z.dist_flag IN ('4', '5')
                               AND z.acct_ent_date IS NOT NULL
                               AND z.acct_neg_date IS NULL))
             ORDER BY y.fnl_binder_id,
                      w.line_cd,
                      w.subline_cd,
                      w.iss_cd,
                      w.issue_yy,
                      w.pol_seq_no,
                      w.renew_no,
                      y.ri_cd,
                      y.ri_seq_no)
      LOOP
         FOR x
            IN (  SELECT SUM (a.ri_prem_amt) ri_prem_amt,
                         SUM (a.ri_comm_amt) ri_comm_amt,
                         SUM (a.ri_comm_vat) ri_comm_vat,
                         b.fnl_binder_id,
                         b.ri_seq_no,
                         b.ri_cd,
                         b.line_cd,
                         b.frps_yy,
                         b.frps_seq_no
                    FROM cpi.giri_frperil a,
                         cpi.giri_frps_ri b,
                         cpi.giri_distfrps c,
                         cpi.giuw_pol_dist d
                   WHERE     a.line_cd = b.line_cd
                         AND a.frps_yy = b.frps_yy
                         AND a.frps_seq_no = b.frps_seq_no
                         AND a.ri_seq_no = b.ri_seq_no
                         AND a.ri_cd = b.ri_cd
                         AND b.line_cd = c.line_cd
                         AND b.frps_yy = c.frps_yy
                         AND b.frps_seq_no = c.frps_seq_no
                         AND c.dist_no = d.dist_no
                         --AND d.dist_flag = '3'
                         AND a.line_cd = rec1.line_cd
                         AND a.frps_yy = rec1.frps_yy
                         AND a.frps_seq_no = rec1.frps_seq_no
                         AND a.ri_cd = rec1.ri_cd
                         AND a.ri_seq_no = rec1.ri_seq_no
                         AND b.fnl_binder_id = rec1.fnl_binder_id
                         AND b.fnl_binder_id = p_fnl_binder_id
                GROUP BY b.line_cd,
                         b.frps_yy,
                         b.frps_seq_no,
                         b.fnl_binder_id,
                         b.ri_seq_no,
                         b.ri_cd)
         LOOP
            UPDATE cpi.giri_binder
               SET ri_prem_amt = x.ri_prem_amt,
                   ri_comm_amt = x.ri_comm_amt,
                   ri_comm_vat = x.ri_comm_vat
             WHERE fnl_binder_id = rec1.fnl_binder_id;

            UPDATE cpi.giri_frps_ri
               SET ri_prem_amt = x.ri_prem_amt,
                   ri_comm_amt = x.ri_comm_amt,
                   ri_comm_vat = x.ri_comm_vat
             WHERE     line_cd = x.line_cd
                   AND frps_yy = x.frps_yy
                   AND frps_seq_no = x.frps_seq_no
                   AND ri_seq_no = x.ri_seq_no
                   AND fnl_binder_id = rec1.fnl_binder_id;
         END LOOP;
      END LOOP;

      COMMIT;
   END;

   PROCEDURE populate_direct_claim_payts
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR j
         IN (SELECT get_ref_no (a.gacc_tran_id) ref_no,
                    a.gacc_tran_id,
                    get_claim_number (a.claim_id) claim_no,
                    a.claim_id,
                    a.advice_id,
                    a.clm_loss_id,
                    a.disbursement_amt
               FROM giac_inw_claim_payts a, giac_acctrans b, gicl_claims c
              WHERE     a.gacc_tran_id = b.tran_id
                    AND b.tran_flag IN ('C', 'P')
                    AND a.claim_id = c.claim_id
                    AND c.pol_iss_cd != 'RI' /*AND NOT EXISTS (
                                                    SELECT 'X'
                                                      FROM giac_direct_claim_payts
                                                     WHERE gacc_tran_id = a.gacc_tran_id
                                                       AND claim_id = a.claim_id
                                                       AND clm_loss_id = a.clm_loss_id
                                                       AND advice_id = a.advice_id)*/
                                            )
      LOOP
         BEGIN
            SELECT 'Y'
              INTO v_exists
              FROM giac_direct_claim_payts
             WHERE     gacc_tran_id = j.gacc_tran_id
                   AND claim_id = j.claim_id
                   AND clm_loss_id = j.clm_loss_id
                   AND advice_id = j.advice_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               INSERT INTO giac_direct_claim_payts
                  SELECT *
                    FROM giac_inw_claim_payts
                   WHERE     gacc_tran_id = j.gacc_tran_id
                         AND claim_id = j.claim_id
                         AND clm_loss_id = j.clm_loss_id
                         AND advice_id = j.advice_id;
         END;

         DELETE FROM giac_inw_claim_payts
               WHERE     gacc_tran_id = j.gacc_tran_id
                     AND claim_id = j.claim_id
                     AND clm_loss_id = j.clm_loss_id
                     AND advice_id = j.advice_id;
      END LOOP;

      COMMIT;
   END;

   PROCEDURE update_claim_dist_no (p_claim_id gicl_claims.claim_id%TYPE)
   IS
   BEGIN
      UPDATE gicl_clm_res_hist a
         SET dist_no =
                (SELECT DISTINCT b.clm_dist_no
                   FROM gicl_loss_exp_ds b
                  WHERE     b.claim_id = a.claim_id
                        AND b.clm_loss_id = a.clm_loss_id
                        AND NVL (b.negate_tag, 'N') = 'N')
       WHERE     EXISTS
                    (SELECT 1
                       FROM giac_acctrans b
                      WHERE     b.tran_id = a.tran_id
                            AND b.tran_flag IN ('C', 'P'))
             AND a.dist_no IS NULL
             AND a.claim_id = p_claim_id
             AND NOT EXISTS
                        (  SELECT 1
                             FROM gicl_loss_exp_ds d
                            WHERE     NVL (d.negate_tag, 'N') = 'N'
                                  AND d.claim_id = a.claim_id
                                  AND d.clm_loss_id = a.clm_loss_id
                         GROUP BY d.claim_id, d.clm_loss_id
                           HAVING COUNT (DISTINCT d.clm_dist_no) > 1);

      COMMIT;
   END;

   PROCEDURE patch_records (p_month          VARCHAR2,
                            p_year           VARCHAR2,
                            p_script_type    VARCHAR2,
                            p_module_id      VARCHAR2)
   IS
      v_cur            SYS_REFCURSOR;
      v_pol_rec        policy_rec;
      v_script_tag     VARCHAR2 (30);
      v_stmt           VARCHAR2 (32767) := 'SELECT policy_no, policy_id ';
      v_add_stmt       VARCHAR2 (32767);
      v_script_title   giac_eom_checking_scripts.eom_script_title%TYPE;
      v_display_sw     giac_eom_checking_scripts.display_sw%TYPE;
      v_query          VARCHAR2 (32767);
      v_book_date      VARCHAR2 (200);
      v_check          VARCHAR2 (32767);
      v_month          VARCHAR2 (20);
      v_year           NUMBER (4);
   BEGIN
      IF p_year != 'N'
      THEN
         v_book_date :=
               ' AND LAST_DAY (TO_DATE (multi_booking_mm || ''-'' || multi_booking_yy, ''MM-YYYY'')) <= '
            || 'LAST_DAY (TO_DATE( '''
            || p_month
            || '-'
            || p_year
            || ''', ''MM-YYYY''))';
         v_month := p_month;
         v_year := p_year;
      ELSE
         v_book_date :=
               ' AND LAST_DAY (TO_DATE (multi_booking_mm || ''-'' || multi_booking_yy, ''MM-YYYY'')) <= '
            || 'LAST_DAY (TO_DATE( '''
            || p_month
            || ''', ''MM-DD-YYYY''))';
         v_month := TO_CHAR (TO_DATE (p_month, 'MM-DD-YYYY'), 'MONTH');
         v_year := TO_CHAR (TO_DATE (p_month, 'MM-DD-YYYY'), 'YYYY');
      END IF;

      --raise_application_error(-20000, p_script_type);
      FOR rec
         IN (  SELECT eom_script_no,
                      UPPER (eom_script_tag) eom_script_tag,
                      display_sw,
                      eom_script_text_1,
                      eom_script_text_2,
                      check_book_date
                 FROM giac_eom_checking_scripts
                WHERE     NVL (display_sw, 'Y') =
                             DECODE (p_script_type, 'CL', 'Y', 'N')
                      AND script_type =
                             DECODE (p_script_type,
                                     'ALL', script_type,
                                     p_script_type)
             --AND eom_script_no BETWEEN 17 AND 18
             ORDER BY eom_script_no)
      LOOP
         IF NVL (rec.check_book_date, 'N') = 'Y'
         THEN
            v_query :=
                  rec.eom_script_text_1
               || ' '
               || rec.eom_script_text_2
               || v_book_date;
         ELSE
            v_query := rec.eom_script_text_1 || ' ' || rec.eom_script_text_2;
         END IF;

         IF rec.eom_script_tag LIKE 'POL%'
         THEN
            v_add_stmt := ', '''' dist_no, '''' fnl_binder_no, '''' claim_id';
         ELSIF rec.eom_script_tag LIKE 'DIST%'
         THEN
            v_add_stmt := ', dist_no, '''' fnl_binder_no, '''' claim_id';
         ELSIF rec.eom_script_tag LIKE 'BINDER%'
         THEN
            v_add_stmt := ', '''' dist_no, fnl_binder_id, '''' claim_id';
         ELSIF rec.eom_script_tag LIKE 'CLAIM%'
         THEN
            v_stmt :=
               'SELECT '''' policy_no, '''' policy_id, '''' dist_no, '''' fnl_binder_no, claim_id';
            v_add_stmt := '';
         ELSIF rec.eom_script_tag IS NULL
         THEN
            v_stmt := 'SELECT *';
         END IF;

         IF rec.display_sw IS NOT NULL
         THEN
            OPEN v_cur FOR
               v_stmt || v_add_stmt || ' FROM ( ' || v_query || ' )';

            v_check :=
               cpi.check_select_script (
                  v_stmt || v_add_stmt || ' FROM ( ' || v_query || ' )',
                  rec.eom_script_no);

            LOOP
               FETCH v_cur INTO v_pol_rec;

               EXIT WHEN v_cur%NOTFOUND;

               IF v_check = 0
               THEN
                  RAISE_APPLICATION_ERROR (-20000, 'WITH ERROR'); --test mikel
               ELSE
                  INSERT INTO giac_eom_scripts_patched (MONTH,
                                                        YEAR,
                                                        eom_script_no,
                                                        policy_no,
                                                        policy_id,
                                                        dist_no,
                                                        fnl_binder_id,
                                                        claim_id,
                                                        module_id,
                                                        user_id,
                                                        last_update)
                       VALUES (v_month,
                               v_year,
                               rec.eom_script_no,
                               v_pol_rec.policy_no,
                               v_pol_rec.policy_id,
                               v_pol_rec.dist_no,
                               v_pol_rec.fnl_binder_id,
                               v_pol_rec.claim_id,
                               p_module_id,
                               USER,
                               SYSDATE);

                  IF rec.eom_script_tag = 'POL_AUTOCREATEDIST'
                  THEN
                     GIACS353_PKG.insert_upd_pol_dist (v_pol_rec.policy_id);
                  ELSIF rec.eom_script_tag IN ('DIST_UNDIST', 'DIST_ENDTTAX')
                  THEN
                     GIACS353_PKG.update_dist_flag (v_pol_rec.policy_id,
                                                    v_pol_rec.dist_no,
                                                    rec.eom_script_tag);
                  ELSIF rec.eom_script_tag = 'DIST_TAKEUPSEQNO'
                  THEN
                     GIACS353_PKG.update_takeup_seq_no (v_pol_rec.policy_id,
                                                        v_pol_rec.dist_no);
                  ELSIF rec.eom_script_tag = 'DIST_CURRENCYRT'
                  THEN
                     GIACS353_PKG.update_currency_rt (v_pol_rec.policy_id,
                                                      v_pol_rec.dist_no);
                  ELSIF rec.eom_script_tag = 'POL_SPOILEDPOLFLAG'
                  THEN
                     GIACS353_PKG.update_pol_flag (v_pol_rec.policy_id);
                  ELSIF rec.eom_script_tag = 'POL_RICOMM'
                  THEN
                     GIACS353_PKG.update_ri_comm (v_pol_rec.policy_id);
                  ELSIF rec.eom_script_tag = 'POL_BOOKINGMONTH'
                  THEN
                     GIACS353_PKG.update_booking_date (v_pol_rec.policy_id);
                  ELSIF rec.eom_script_tag = 'POL_PREMCOMM'
                  THEN
                     GIACS353_PKG.update_direct_comm (v_pol_rec.policy_id);
                  ELSIF rec.eom_script_tag = 'BINDER'
                  THEN
                     GIACS353_PKG.update_binder_amt (v_pol_rec.fnl_binder_id);
                  ELSIF rec.eom_script_tag = 'CLAIM_DIRECTPAYT'
                  THEN
                     GIACS353_PKG.populate_direct_claim_payts;
                  ELSIF rec.eom_script_tag = 'CLAIM_DISTNO'
                  THEN
                     GIACS353_PKG.update_claim_dist_no (v_pol_rec.claim_id);
                  END IF;
               END IF;
            END LOOP;

            CLOSE v_cur;
         ELSIF rec.display_sw IS NULL AND p_script_type = 'CL'
         THEN
            v_check :=
               cpi.check_select_script (
                  v_stmt || v_add_stmt || ' FROM ( ' || v_query || ' )',
                  rec.eom_script_no);

            IF v_check > 0
            THEN
               raise_application_error (
                  -20001,
                     'Geniisys Exception#E#The system detected erroneous record/s. Please run EOM script no. '
                  || rec.eom_script_no);
            END IF;
         END IF;
      END LOOP;
   END;
--end mikel 06.20.2016; GENQA 5544
END;
/