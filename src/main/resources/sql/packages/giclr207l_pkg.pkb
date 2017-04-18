CREATE OR REPLACE PACKAGE BODY CPI.giclr207l_pkg
AS
   /*
   **  Created by   :  Steven Ramirez
   **  Date Created : 02.26.2014
   **  Reference By : GICLR207L_PKG - OUTSTANDING LOSS EXPENSE DETAILS
   **  If you spend too much time thinking about a thing, you'll never get it done. This is the proper mind set for this report.
   */
   FUNCTION get_giclr207l_details (p_tran_id NUMBER)
      RETURN giclr207l_tab PIPELINED
   IS
      v_rec                 giclr207l_type;
      v_query               VARCHAR2 (10000);
      v_cnt                 NUMBER (10)                                  := 0;
      v_cnt_trty            NUMBER (10)                                  := 0;
      v_cnt_trty2           NUMBER (10)                                  := 0;
      v_total_cols          NUMBER (10);
      v_total_loop          NUMBER (10);
      v_ds_loss_res_amt     NUMBER (18, 2);
      v_date                DATE;
      v_exist               VARCHAR2 (1)                               := 'N';
      v_exist_trty          VARCHAR2 (1);
      v_exist_ri            VARCHAR2 (1);
      v_ri_cd               gicl_reserve_rids_xtr.ri_cd%TYPE;
      v_ri_sname            giis_reinsurer.ri_sname%TYPE;
      v_rids_loss_res_amt   gicl_reserve_rids_xtr.shr_exp_res_amt%TYPE;
      v_trty                giis_dist_share.trty_name%TYPE;
   BEGIN
      v_rec.company_name := giacp.v ('COMPANY_NAME');
      v_rec.company_add := giisp.v ('COMPANY_ADDRESS');

      BEGIN
         SELECT DISTINCT LAST_DAY (TO_DATE (   TO_CHAR (tran_month)
                                            || '-15'
                                            || '-'
                                            || TO_CHAR (tran_year),
                                            'MM-DD-YYYY'
                                           )
                                  )
                    INTO v_date
                    FROM giac_acctrans
                   WHERE tran_id = p_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.as_of_date := NULL;
      END;

      v_rec.as_of_date := 'As of ' || TO_CHAR (v_date, 'fmMonth dd, YYYY');

      BEGIN
         SELECT report_title
           INTO v_rec.rep_title
           FROM giis_reports
          WHERE report_id = 'GICLR207L';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.rep_title := NULL;
      END;

      FOR prime IN (SELECT DISTINCT a.line_cd, a.subline_cd     --, a.claim_id
                               FROM gicl_claims a, gicl_take_up_hist b
                              WHERE b.acct_tran_id = p_tran_id
                                AND a.claim_id = b.claim_id
                                AND os_expense > 0
                           ORDER BY a.line_cd, a.subline_cd)
      LOOP
         BEGIN
            SELECT line_name
              INTO v_rec.line_name
              FROM giis_line
             WHERE line_cd = prime.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.line_name := NULL;
         END;

         BEGIN
            SELECT subline_name
              INTO v_rec.subline_name
              FROM giis_subline
             WHERE line_cd = prime.line_cd AND subline_cd = prime.subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.subline_name := NULL;
         END;

         FOR dtl IN
            (SELECT DISTINCT a.claim_id, a.assured_name,
                                a.line_cd
                             || '-'
                             || a.subline_cd
                             || '-'
                             || a.pol_iss_cd
                             || '-'
                             || LTRIM (TO_CHAR (a.issue_yy, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                             || '-'
                             || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                                a.line_cd
                             || '-'
                             || a.subline_cd
                             || '-'
                             || a.iss_cd
                             || '-'
                             || LTRIM (TO_CHAR (a.clm_yy, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.clm_seq_no, '0999999'))
                                                                     claim_no,
                             a.pol_eff_date, a.loss_date, a.clm_file_date,
                             b.item_no, b.peril_cd, a.line_cd, a.subline_cd,
                             b.os_expense os_loss, a.expiry_date,
                             h.ann_tsi_amt
                        FROM gicl_claims a,
                             gicl_take_up_hist b,
                             gicl_reserve_ds_xtr f,
                             gicl_intm_itmperil d,
                             giis_intermediary e,
                             giis_reinsurer g,
                             gicl_item_peril h
                       WHERE b.acct_tran_id = p_tran_id
                         AND a.claim_id = b.claim_id
                         AND f.claim_id = d.claim_id(+)
                         AND f.item_no = d.item_no(+)
                         AND f.peril_cd = d.peril_cd(+)
                         AND d.intm_no = e.intm_no(+)
                         AND a.ri_cd = g.ri_cd(+)
                         AND b.claim_id = f.claim_id(+)
                         AND b.item_no = f.item_no(+)
                         AND b.peril_cd = f.peril_cd(+)
                         AND b.acct_tran_id = f.acct_tran_id(+)
                         AND os_expense > 0
                         AND h.claim_id = a.claim_id
                         AND h.item_no = b.item_no
                         AND h.peril_cd = b.peril_cd
                         AND a.line_cd = prime.line_cd
                         AND a.subline_cd = prime.subline_cd
                    ORDER BY    a.line_cd
                             || '-'
                             || a.subline_cd
                             || '-'
                             || a.iss_cd
                             || '-'
                             || LTRIM (TO_CHAR (a.clm_yy, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')))
         LOOP
            v_exist := 'Y';
            v_rec.exist := 'Y';
            v_rec.orig_subline_cd := dtl.subline_cd;
            v_rec.line_cd := dtl.line_cd;
            v_rec.subline_cd := dtl.subline_cd;
            v_rec.claim_id := dtl.claim_id;
            v_rec.assured_name := dtl.assured_name;
            v_rec.policy_no := dtl.policy_no;
            v_rec.claim_no := dtl.claim_no;
            v_rec.pol_eff_date := dtl.pol_eff_date;
            v_rec.loss_date := dtl.loss_date;
            v_rec.clm_file_date := dtl.clm_file_date;
            v_rec.expiry_date := dtl.expiry_date;
            v_rec.os_loss := dtl.os_loss;
            v_rec.orig_os_loss := dtl.os_loss;

            FOR cnt IN (SELECT DISTINCT a.acct_tran_id, a.share_type,
                                        a.grp_seq_no, a.line_cd,
                                        b.subline_cd
                                   FROM gicl_reserve_ds_xtr a, gicl_claims b
                                  WHERE acct_tran_id = p_tran_id
                                    --AND a.claim_id = dtl.claim_id
                                    AND a.claim_id = b.claim_id
                                    AND b.line_cd = prime.line_cd
                                    AND b.subline_cd = prime.subline_cd
                               ORDER BY grp_seq_no)
            LOOP
               v_cnt := v_cnt + 1;
            END LOOP;

            FOR trty IN (SELECT DISTINCT a.acct_tran_id, a.share_type,
                                         a.grp_seq_no, a.line_cd,
                                         b.subline_cd
                                    FROM gicl_reserve_ds_xtr a, gicl_claims b
                                   WHERE acct_tran_id = p_tran_id
                                     --AND a.claim_id = dtl.claim_id
                                     AND a.claim_id = b.claim_id
                                     AND b.line_cd = prime.line_cd
                                     AND b.subline_cd = prime.subline_cd
                                ORDER BY grp_seq_no)
            LOOP
               v_cnt_trty := v_cnt_trty + 1;
               v_cnt_trty2 := v_cnt_trty2 + 1;

               BEGIN
                  SELECT trty_name
                    INTO v_trty
                    FROM giis_dist_share
                   WHERE line_cd = trty.line_cd AND share_cd = trty.grp_seq_no;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_trty := NULL;
               END;

               FOR amt IN
                  (SELECT DISTINCT a.claim_id, a.acct_tran_id, a.share_type,
                                   a.grp_seq_no, a.line_cd, a.item_no,
                                   a.peril_cd,
                                   NVL (a.shr_exp_res_amt, 0) ds_loss_res_amt,
                                   a.clm_res_hist_id, a.clm_dist_no
                              FROM gicl_reserve_ds_xtr a
                             WHERE 1 = 1
                               AND a.acct_tran_id = p_tran_id
                               AND a.claim_id = dtl.claim_id
                               AND a.share_type = trty.share_type
                               AND a.grp_seq_no = trty.grp_seq_no)
               LOOP
                  v_ds_loss_res_amt := amt.ds_loss_res_amt;
                  EXIT;
               END LOOP;

               FOR ri IN (SELECT a.ri_cd, b.ri_sname,
                                 NVL (a.shr_exp_res_amt, 0) rids_loss_res_amt
                            FROM gicl_reserve_rids_xtr a, giis_reinsurer b
                           WHERE 1 = 1
                             AND a.acct_tran_id = p_tran_id
                             AND a.grp_seq_no = 999
                             AND a.claim_id = dtl.claim_id
                             AND b.ri_cd = a.ri_cd
                             AND a.grp_seq_no = trty.grp_seq_no)
               LOOP
                  v_ri_cd := ri.ri_cd;
                  v_ri_sname := ri.ri_sname;
                  v_rids_loss_res_amt := ri.rids_loss_res_amt;
                  EXIT;
               END LOOP;

               IF v_cnt_trty = 1
               THEN
                  v_rec.col_header1 := v_trty;
                  v_rec.sum_col_header1 := v_ds_loss_res_amt;
                  v_rec.ri_cd1 := v_ri_cd;
                  v_rec.sum_ri_cd1 := v_rids_loss_res_amt;
                  v_rec.ri_cd_header1 := v_ri_sname;
                  v_ds_loss_res_amt := NULL;
                  v_ri_cd := NULL;
                  v_ri_sname := NULL;
                  v_rids_loss_res_amt := NULL;
               ELSIF v_cnt_trty = 2
               THEN
                  v_rec.col_header2 := v_trty;
                  v_rec.sum_col_header2 := v_ds_loss_res_amt;
                  v_rec.ri_cd2 := v_ri_cd;
                  v_rec.sum_ri_cd2 := v_rids_loss_res_amt;
                  v_rec.ri_cd_header2 := v_ri_sname;
                  v_ds_loss_res_amt := NULL;
                  v_ri_cd := NULL;
                  v_ri_sname := NULL;
                  v_rids_loss_res_amt := NULL;
               ELSIF v_cnt_trty = 3
               THEN
                  v_rec.col_header3 := v_trty;
                  v_rec.sum_col_header3 := v_ds_loss_res_amt;
                  v_rec.ri_cd3 := v_ri_cd;
                  v_rec.sum_ri_cd3 := v_rids_loss_res_amt;
                  v_rec.ri_cd_header3 := v_ri_sname;
                  v_ds_loss_res_amt := NULL;
                  v_ri_cd := NULL;
                  v_ri_sname := NULL;
                  v_rids_loss_res_amt := NULL;
               ELSIF v_cnt_trty = 4
               THEN
                  v_rec.col_header4 := v_trty;
                  v_rec.sum_col_header4 := v_ds_loss_res_amt;
                  v_rec.ri_cd4 := v_ri_cd;
                  v_rec.sum_ri_cd4 := v_rids_loss_res_amt;
                  v_rec.ri_cd_header4 := v_ri_sname;
                  v_ds_loss_res_amt := NULL;
                  v_ri_cd := NULL;
                  v_ri_sname := NULL;
                  v_rids_loss_res_amt := NULL;
                  v_cnt_trty := 0;
                  PIPE ROW (v_rec);
                  v_rec.col_header1 := NULL;
                  v_rec.sum_col_header1 := NULL;
                  v_rec.col_header2 := NULL;
                  v_rec.sum_col_header2 := NULL;
                  v_rec.col_header3 := NULL;
                  v_rec.sum_col_header3 := NULL;
                  v_rec.col_header4 := NULL;
                  v_rec.sum_col_header4 := NULL;
                  v_rec.ri_cd1 := NULL;
                  v_rec.sum_ri_cd1 := NULL;
                  v_rec.ri_cd_header1 := NULL;
                  v_rec.ri_cd2 := NULL;
                  v_rec.sum_ri_cd2 := NULL;
                  v_rec.ri_cd_header2 := NULL;
                  v_rec.ri_cd3 := NULL;
                  v_rec.sum_ri_cd3 := NULL;
                  v_rec.ri_cd_header3 := NULL;
                  v_rec.ri_cd4 := NULL;
                  v_rec.sum_ri_cd4 := NULL;
                  v_rec.ri_cd_header4 := NULL;
                  v_rec.orig_os_loss := NULL;
                  v_rec.subline_cd := dtl.subline_cd || '_1';
               END IF;

               IF v_cnt_trty2 = v_cnt AND v_cnt_trty != 0
               THEN
                  v_cnt_trty := 0;
                  PIPE ROW (v_rec);
                  v_rec.col_header1 := NULL;
                  v_rec.sum_col_header1 := NULL;
                  v_rec.col_header2 := NULL;
                  v_rec.sum_col_header2 := NULL;
                  v_rec.col_header3 := NULL;
                  v_rec.sum_col_header3 := NULL;
                  v_rec.col_header4 := NULL;
                  v_rec.sum_col_header4 := NULL;
                  v_rec.ri_cd1 := NULL;
                  v_rec.sum_ri_cd1 := NULL;
                  v_rec.ri_cd_header1 := NULL;
                  v_rec.ri_cd2 := NULL;
                  v_rec.sum_ri_cd2 := NULL;
                  v_rec.ri_cd_header2 := NULL;
                  v_rec.ri_cd3 := NULL;
                  v_rec.sum_ri_cd3 := NULL;
                  v_rec.ri_cd_header3 := NULL;
                  v_rec.ri_cd4 := NULL;
                  v_rec.sum_ri_cd4 := NULL;
                  v_rec.ri_cd_header4 := NULL;
                  v_rec.orig_os_loss := NULL;
                  v_rec.subline_cd := dtl.subline_cd || '_1';
               END IF;
            END LOOP;
         END LOOP;
      END LOOP;

      IF v_exist = 'N'
      THEN
         v_rec.exist := 'N';
         PIPE ROW (v_rec);
      END IF;

      RETURN;
   END;

   FUNCTION get_giclr207l_item (
      p_tran_id    NUMBER,
      p_claim_id   gicl_claims.claim_id%TYPE
   )
      RETURN giclr207_item_tab PIPELINED
   IS
      v_rec   giclr207_item_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.claim_id, b.item_no, h.ann_tsi_amt
                           FROM gicl_claims a,
                                gicl_take_up_hist b,
                                gicl_reserve_ds_xtr f,
                                gicl_intm_itmperil d,
                                giis_intermediary e,
                                giis_reinsurer g,
                                gicl_item_peril h
                          WHERE b.acct_tran_id = p_tran_id
                            AND a.claim_id = p_claim_id
                            AND a.claim_id = b.claim_id
                            AND f.claim_id = d.claim_id(+)
                            AND f.item_no = d.item_no(+)
                            AND f.peril_cd = d.peril_cd(+)
                            AND d.intm_no = e.intm_no(+)
                            AND a.ri_cd = g.ri_cd(+)
                            AND b.claim_id = f.claim_id(+)
                            AND b.item_no = f.item_no(+)
                            AND b.peril_cd = f.peril_cd(+)
                            AND b.acct_tran_id = f.acct_tran_id(+)
                            AND os_expense > 0
                            AND h.claim_id = a.claim_id
                            AND h.item_no = b.item_no
                            AND h.peril_cd = b.peril_cd
                       ORDER BY    a.line_cd
                                || '-'
                                || a.subline_cd
                                || '-'
                                || a.iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (a.clm_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')))
      LOOP
         v_rec.claim_id := i.claim_id;
         v_rec.item_no := i.item_no;
         v_rec.ann_tsi_amt := i.ann_tsi_amt;

         BEGIN
            SELECT item_title
              INTO v_rec.item_title
              FROM gicl_clm_item
             WHERE claim_id = i.claim_id AND item_no = i.item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.item_title := NULL;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giclr207l_peril (
      p_tran_id    NUMBER,
      p_claim_id   gicl_claims.claim_id%TYPE
   )
      RETURN giclr207_peril_tab PIPELINED
   IS
      v_rec   giclr207_peril_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.claim_id, b.item_no, b.peril_cd, a.line_cd,
                                b.os_expense os_loss
                           FROM gicl_claims a,
                                gicl_take_up_hist b,
                                gicl_reserve_ds_xtr f,
                                gicl_intm_itmperil d,
                                giis_intermediary e,
                                giis_reinsurer g,
                                gicl_item_peril h
                          WHERE b.acct_tran_id = p_tran_id
                            AND a.claim_id = p_claim_id
                            AND a.claim_id = b.claim_id
                            AND f.claim_id = d.claim_id(+)
                            AND f.item_no = d.item_no(+)
                            AND f.peril_cd = d.peril_cd(+)
                            AND d.intm_no = e.intm_no(+)
                            AND a.ri_cd = g.ri_cd(+)
                            AND b.claim_id = f.claim_id(+)
                            AND b.item_no = f.item_no(+)
                            AND b.peril_cd = f.peril_cd(+)
                            AND b.acct_tran_id = f.acct_tran_id(+)
                            AND os_expense > 0
                            AND h.claim_id = a.claim_id
                            AND h.item_no = b.item_no
                            AND h.peril_cd = b.peril_cd
                       ORDER BY    a.line_cd
                                || '-'
                                || a.subline_cd
                                || '-'
                                || a.iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (a.clm_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')))
      LOOP
         v_rec.claim_id := i.claim_id;
         v_rec.item_no := i.item_no;
         v_rec.peril_cd := i.peril_cd;
         v_rec.os_loss := i.os_loss;
         v_rec.intm :=
                 giclr207l_pkg.cf_intm_ri (i.claim_id, i.peril_cd, i.item_no);

         BEGIN
            SELECT peril_name
              INTO v_rec.peril_name
              FROM giis_peril
             WHERE line_cd = i.line_cd AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.peril_name := NULL;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION cf_intm_ri (
      p_claim_id   gicl_claims.claim_id%TYPE,
      p_peril_cd   gicl_take_up_hist.peril_cd%TYPE,
      p_item_no    gicl_take_up_hist.peril_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE;
      v_intm_name     giis_intermediary.intm_name%TYPE;
      v_intm_no       gicl_intm_itmperil.intm_no%TYPE;
      v_ref_intm_cd   giis_intermediary.ref_intm_cd%TYPE;
      v_ri_cd         gicl_claims.ri_cd%TYPE;
      v_ri_name       giis_reinsurer.ri_name%TYPE;
      v_intm          VARCHAR2 (300)                       := NULL;
   BEGIN
      FOR i IN (SELECT a.pol_iss_cd
                  FROM gicl_claims a
                 WHERE a.claim_id = p_claim_id)
      LOOP
         v_pol_iss_cd := i.pol_iss_cd;
      END LOOP;

      IF v_pol_iss_cd = 'RI'
      THEN
         FOR k IN (SELECT g.ri_name, a.ri_cd
                     FROM gicl_claims a, giis_reinsurer g
                    WHERE a.claim_id = p_claim_id AND a.ri_cd = g.ri_cd(+))
         LOOP
            v_intm := (TO_CHAR (k.ri_cd) || CHR (10) || (k.ri_name));
         END LOOP;
      ELSE
         FOR j IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                     FROM gicl_intm_itmperil a, giis_intermediary b
                    WHERE a.intm_no = b.intm_no
                      AND a.claim_id = p_claim_id
                      AND a.peril_cd = p_peril_cd
                      AND a.item_no = p_item_no)
         LOOP
            v_intm :=
                  TO_CHAR (j.intm_no)
               || '/'
               || j.ref_intm_cd
               || CHR (10)
               || j.intm_name
               || CHR (10)
               || '                    '
               || v_intm;
         END LOOP;
      END IF;

      RETURN (v_intm);
   END;

   FUNCTION get_giclr207l_summary (
      p_tran_id      NUMBER,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2
   )
      RETURN giclr207l_summary_tab PIPELINED
   IS
      v_rec   giclr207l_summary_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.acct_tran_id, a.grp_seq_no,
                                a.shr_exp_res_amt rids_loss_amt, a.line_cd,
                                a.clm_dist_no, a.ri_cd, b.subline_cd,
                                a.shr_pct, c.trty_shr_pct share_ri
                           FROM gicl_reserve_rids_xtr a,
                                gicl_claims b,
                                giis_trty_panel c
                          WHERE grp_seq_no <> 999
                            AND acct_tran_id = p_tran_id
                            AND a.line_cd = p_line_cd
                            AND b.subline_cd = p_subline_cd
                            AND a.claim_id = b.claim_id
                            AND shr_exp_res_amt > 0
                            AND a.line_cd = c.line_cd
                            AND a.grp_seq_no = c.trty_seq_no
                            AND a.ri_cd = c.ri_cd)
      LOOP
         v_rec.rids_loss_amt := i.rids_loss_amt;
         v_rec.share_ri := i.share_ri;
         v_rec.grp_seq_no := i.grp_seq_no;

         FOR k IN (SELECT trty_name
                     FROM giis_dist_share
                    WHERE share_cd = i.grp_seq_no AND line_cd = i.line_cd)
         LOOP
            v_rec.trty_name := k.trty_name;
            EXIT;
         END LOOP;

         FOR l IN (SELECT ri_sname
                     FROM giis_reinsurer
                    WHERE ri_cd = i.ri_cd)
         LOOP
            v_rec.ri_sname := l.ri_sname;
            EXIT;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;
   END;
END;
/


