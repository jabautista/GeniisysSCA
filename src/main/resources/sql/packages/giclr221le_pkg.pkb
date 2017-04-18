CREATE OR REPLACE PACKAGE BODY CPI.GICLR221LE_PKG
AS
/*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created :  04.01.2013
    **  Reference By :  GICLR221LE- LOSS EXPENSE BORDEREAUX (PER ENROLLEE)
    */
   FUNCTION get_header (p_from_date DATE, p_to_date DATE, p_paid_date NUMBER)
      RETURN get_details_tab PIPELINED
   IS
      v_detail   get_details_type;
   BEGIN
      v_detail.cf_company     := giisp.v ('COMPANY_NAME');
      v_detail.cf_com_address := giisp.v ('COMPANY_ADDRESS');

      BEGIN
         SELECT report_title
           INTO v_detail.report_title
           FROM giis_reports
          WHERE report_id = 'GICLR221LE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_detail.report_title := NULL;
      END;

      BEGIN
         SELECT    '(Based on '
                || DECODE (p_paid_date,
                           1, 'Transaction Date',
                           2, 'Posting Date'
                          )
                || ')'
           INTO v_detail.cf_param_date
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_detail.cf_param_date := NULL;
      END;

      BEGIN
         SELECT    'from '
                || TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
                || ' to '
                || TO_CHAR (p_to_date, 'fmMonth DD, YYYY')
           INTO v_detail.cf_date
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_detail.cf_date := NULL;
      END;

      PIPE ROW (v_detail);
      RETURN;
   END get_header;

   FUNCTION get_details (
      p_from_date    DATE,
      p_to_date      DATE,
      p_paid_date    NUMBER,
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_amt          VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      v_detail   get_details_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.enrollee
                           FROM gicl_res_brdrx_extr a
                          WHERE a.session_id = p_session_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                 OR ABS (NVL (a.expenses_paid, 0)) > 0
                                ))
      LOOP
         v_detail.enrollee := i.enrollee;

         BEGIN
            SELECT DISTINCT 'X'
                       INTO v_detail.v_exist
                       FROM gicl_res_brdrx_extr a
                      WHERE a.session_id = p_session_id
                        AND a.claim_id = NVL (p_claim_id, a.claim_id)
                        AND (   ABS (NVL (a.losses_paid, 0)) > 0
                             OR ABS (NVL (a.expenses_paid, 0)) > 0
                            );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_detail.v_exist := NULL;
         END;

         PIPE ROW (v_detail);
      END LOOP;

      RETURN;
   END get_details;

   FUNCTION get_report_details (
      p_from_date    DATE,
      p_to_date      DATE,
      p_paid_date    NUMBER,
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_enrollee     gicl_res_brdrx_extr.enrollee%TYPE,
      p_amt          VARCHAR2
   )
      RETURN get_report_details_tab PIPELINED
   IS
      v_detail       get_report_details_type;
      v_pol_iss_cd   gicl_claims.pol_iss_cd%TYPE;
      v_intm_ri      VARCHAR2 (1000);
      v_dv_no        VARCHAR2 (100);
      var_dv_no      VARCHAR2 (500);
      v_loss         NUMBER;
      v_ref_pol_no   gipi_polbasic.ref_pol_no%type;
   BEGIN
      FOR i IN (SELECT   a.brdrx_record_id, a.claim_id, a.line_cd,
                         a.claim_no, a.policy_no, a.assd_no, a.incept_date,
                         a.expiry_date, a.loss_date, a.clm_file_date,
                         a.item_no, a.grouped_item_no, a.enrollee,
                         a.peril_cd, a.loss_cat_cd, a.tsi_amt, a.intm_no,
                         a.clm_loss_id, NVL (a.losses_paid, 0) paid_losses,
                         NVL (a.expenses_paid, 0) paid_expenses
                    FROM gicl_res_brdrx_extr a
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND a.enrollee = NVL (p_enrollee, a.enrollee)
                     AND (   ABS (NVL (a.losses_paid, 0)) > 0
                          OR ABS (NVL (a.expenses_paid, 0)) > 0
                         )
                ORDER BY a.claim_no)
      LOOP
         v_detail.brdrx_record_id := i.brdrx_record_id;
         v_detail.claim_id        := i.claim_id;
         v_detail.line_cd         := i.line_cd;
         v_detail.claim_no        := i.claim_no;
         v_detail.policy_no       := i.policy_no;
         v_detail.assd_no         := i.assd_no;
         v_detail.incept_date     := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         v_detail.expiry_date     := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         v_detail.loss_date       := TO_CHAR (i.loss_date, 'MM-DD-RRRR');
         v_detail.clm_file_date   := i.clm_file_date;
         v_detail.grouped_item_no := i.grouped_item_no;
         v_detail.item_no         := i.item_no;
         v_detail.item_title      := get_gpa_item_title (i.claim_id, i.line_cd, i.item_no, NVL (i.grouped_item_no, 0));
         v_detail.enrollee        := i.enrollee;
         v_detail.peril_cd        := i.peril_cd;
         v_detail.loss_cat_cd     := i.loss_cat_cd;
         v_detail.tsi_amt         := NVL (i.tsi_amt, 0.00);
         v_detail.intm_no         := i.intm_no;
         v_detail.clm_loss_id     := i.clm_loss_id;
         v_detail.paid_losses     := i.paid_losses;
         v_detail.paid_expenses   := i.paid_expenses;

         BEGIN
            SELECT b.ref_pol_no
              INTO v_ref_pol_no
              FROM gicl_claims a, gipi_polbasic b
             WHERE a.line_cd = b.line_cd
               AND a.subline_cd = b.subline_cd
               AND a.pol_iss_cd = b.iss_cd
               AND a.issue_yy = b.issue_yy
               AND a.pol_seq_no = b.pol_seq_no
               AND a.renew_no = b.renew_no
               AND b.endt_seq_no = 0
               AND a.claim_id = v_detail.claim_id
               AND ref_pol_no IS NOT NULL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_ref_pol_no := NULL;
         END;
         
         IF v_ref_pol_no IS NOT NULL THEN
  	        v_detail.cf_policy_no := v_detail.policy_no||'/'||CHR(10)||v_ref_pol_no;
         ELSE
  	        v_detail.cf_policy_no := v_detail.policy_no;
         END IF;
         
         BEGIN
            FOR a IN (SELECT SIGN (i.paid_losses) losses_paid
                        FROM DUAL)
            LOOP
               v_loss := a.losses_paid;

               IF v_loss < 1
               THEN
                  FOR v1 IN
                     (SELECT DISTINCT    b.dv_pref
                                      || '-'
                                      || LTRIM (TO_CHAR (b.dv_no,
                                                         '0999999999')
                                               )
                                      || ' /'
                                      || e.check_no dv_no,
                                      TO_CHAR (a.cancel_date,
                                               'MM/DD/YYYY'
                                              ) cancel_date
                                 FROM gicl_clm_res_hist a,
                                      giac_disb_vouchers b,
                                      giac_acctrans c,
                                      giac_reversals d,
                                      giac_chk_disbursement e
                                WHERE a.tran_id = b.gacc_tran_id
                                  AND a.tran_id = d.gacc_tran_id
                                  AND c.tran_id = d.reversing_tran_id
                                  AND b.gacc_tran_id = e.gacc_tran_id
                                  AND e.item_no = i.item_no
                                  AND a.claim_id = i.claim_id
                                  AND a.clm_loss_id = i.clm_loss_id
                             GROUP BY b.dv_pref,
                                      b.dv_no,
                                      e.check_no,
                                      a.cancel_date
                               HAVING SUM (NVL (a.losses_paid, 0)) > 0
                                   OR SUM (NVL (a.expenses_paid, 0)) > 0)
                  LOOP
                     v_dv_no :=
                        v1.dv_no || CHR (10) || 'cancelled '
                        || v1.cancel_date;

                     IF var_dv_no IS NULL
                     THEN
                        var_dv_no := v_dv_no;
                     ELSE
                        var_dv_no := v_dv_no || CHR (10) || var_dv_no;
                     END IF;
                  END LOOP;
               ELSE
                  FOR v2 IN
                     (SELECT DISTINCT    b.dv_pref
                                      || '-'
                                      || LTRIM (TO_CHAR (b.dv_no,
                                                         '0999999999')
                                               )
                                      || ' /'
                                      || '<br>'
                                      || e.check_no dv_no
                                 FROM gicl_clm_res_hist a,
                                      giac_disb_vouchers b,
                                      giac_direct_claim_payts c,
                                      giac_acctrans d,
                                      giac_chk_disbursement e
                                WHERE a.tran_id = d.tran_id
                                  AND b.gacc_tran_id = c.gacc_tran_id
                                  AND b.gacc_tran_id = d.tran_id
                                  AND b.gacc_tran_id = e.gacc_tran_id
                                  AND e.item_no = i.item_no
                                  AND a.claim_id = i.claim_id
                                  AND a.clm_loss_id = i.clm_loss_id
                                  AND DECODE (p_paid_date,
                                              1, TRUNC (a.date_paid),
                                              2, TRUNC (d.posting_date)
                                             ) BETWEEN p_from_date AND p_to_date
                             GROUP BY b.dv_pref, b.dv_no, e.check_no
                               HAVING SUM (NVL (a.losses_paid, 0)) > 0
                                   OR SUM (NVL (a.expenses_paid, 0)) > 0)
                  LOOP
                     v_dv_no := v2.dv_no;

                     IF var_dv_no IS NULL
                     THEN
                        var_dv_no := v_dv_no;
                     ELSE
                        var_dv_no := v_dv_no || CHR (10) || var_dv_no;
                     END IF;
                  END LOOP;
               END IF;
            END LOOP;

            v_detail.cf_dv_no := var_dv_no;
         END;

         BEGIN
            v_intm_ri := NULL;

            BEGIN
               SELECT pol_iss_cd
                 INTO v_pol_iss_cd
                 FROM gicl_claims
                WHERE claim_id = i.claim_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_pol_iss_cd := NULL;
            END;

            IF v_pol_iss_cd = giacp.v ('RI_ISS_CD')
            THEN
               BEGIN
                  FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                              FROM gicl_claims a, giis_reinsurer b
                             WHERE a.ri_cd = b.ri_cd
                               AND a.claim_id = i.claim_id)
                  LOOP
                     v_intm_ri := TO_CHAR (r.ri_cd) || CHR (10) || r.ri_name;
                  END LOOP;
               END;
            ELSE
               BEGIN
                  FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                              FROM gicl_intm_itmperil a, giis_intermediary b
                             WHERE a.intm_no = b.intm_no
                               AND a.claim_id = i.claim_id
                               AND a.item_no = i.item_no
                               AND a.peril_cd = i.peril_cd)
                  LOOP
                     v_intm_ri :=
                           TO_CHAR (m.intm_no)
                        || '/'
                        || m.ref_intm_cd
                        || CHR (10)
                        || m.intm_name
                        || CHR (10)
                        || v_intm_ri;
                  END LOOP;
               END;
            END IF;

            v_detail.intm_ri := v_intm_ri;
         END;

         BEGIN
            SELECT peril_name
              INTO v_detail.peril_name
              FROM giis_peril
             WHERE peril_cd = i.peril_cd AND line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_detail.peril_name := NULL;
         END;

         BEGIN
            SELECT assd_name
              INTO v_detail.assd_name
              FROM giis_assured
             WHERE assd_no = v_detail.assd_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_detail.assd_name := NULL;
         END;

         PIPE ROW (v_detail);
      END LOOP;

      RETURN;
   END get_report_details;

   FUNCTION get_treaty_header (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_enrollee     gicl_res_brdrx_extr.enrollee%TYPE
   )
      RETURN get_treaty_header_tab PIPELINED
   IS
      v_detail   get_treaty_header_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.grp_seq_no, a.line_cd, b.enrollee
                           FROM gicl_res_brdrx_ds_extr a,
                                gicl_res_brdrx_extr b
                          WHERE a.session_id = p_session_id
                            AND a.session_id = b.session_id
                            AND a.brdrx_record_id = b.brdrx_record_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                 OR ABS (NVL (a.expenses_paid, 0)) > 0
                                )
                            AND b.enrollee = NVL (p_enrollee, b.enrollee)
                       ORDER BY a.grp_seq_no)
      LOOP
         v_detail.grp_seq_no    := i.grp_seq_no;
         v_detail.line_cd       := i.line_cd;
         v_detail.enrollee      := i.enrollee;
         v_detail.dummy_measure := 1;

         BEGIN
            SELECT trty_name
              INTO v_detail.trty_name
              FROM giis_dist_share
             WHERE share_cd = i.grp_seq_no AND line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_detail.trty_name := NULL;
         END;

         PIPE ROW (v_detail);
      END LOOP;

      RETURN;
   END get_treaty_header;

   FUNCTION get_treaty_details (
      p_session_id        gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
      p_enrollee          gicl_res_brdrx_extr.enrollee%TYPE,
      --p_peril_cd          giis_peril.peril_cd%TYPE,
      --p_claim_no          gicl_res_brdrx_extr.claim_no%TYPE,
      p_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE
   )
      RETURN get_treaty_details_tab PIPELINED
   IS
      v_detail   get_treaty_details_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.enrollee
                           FROM gicl_res_brdrx_extr a
                          WHERE a.session_id = p_session_id
                            --AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND a.claim_id  = NVL(DECODE(p_claim_id, -1, a.claim_id, p_claim_id),a.claim_id )
                            AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                 OR ABS (NVL (a.expenses_paid, 0)) > 0
                                )
                            AND a.enrollee = NVL (p_enrollee, a.enrollee))
      LOOP
         FOR j IN (SELECT   a.brdrx_record_id, a.peril_cd
                       FROM gicl_res_brdrx_extr a
                      WHERE a.session_id = p_session_id
                        --AND a.claim_id = NVL (p_claim_id, a.claim_id)
                        AND a.claim_id  = NVL(DECODE(p_claim_id, -1, a.claim_id, p_claim_id),a.claim_id )
                        AND a.enrollee = i.enrollee
                        AND (   ABS (NVL (a.losses_paid, 0)) > 0
                             OR ABS (NVL (a.expenses_paid, 0)) > 0
                            )
                        --AND a.claim_no = NVL (p_claim_no, a.claim_no)
                        AND a.brdrx_record_id = NVL (p_brdrx_record_id, a.brdrx_record_id)
                   ORDER BY a.claim_no)
         LOOP
            FOR k IN (SELECT DISTINCT a.grp_seq_no
                                 FROM gicl_res_brdrx_ds_extr a,
                                      gicl_res_brdrx_extr b
                                WHERE a.session_id = p_session_id
                                  AND a.session_id = b.session_id
                                  AND a.brdrx_record_id = b.brdrx_record_id
                                  --AND a.claim_id = NVL (p_claim_id, a.claim_id)
                                  AND a.claim_id  = NVL(DECODE(p_claim_id, -1, a.claim_id, p_claim_id),a.claim_id )
                                  AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                       OR ABS (NVL (a.expenses_paid, 0)) > 0
                                      )
                                  AND b.enrollee = i.enrollee
                             ORDER BY a.grp_seq_no)
            LOOP
               FOR l IN (SELECT a.brdrx_record_id, a.brdrx_ds_record_id,
                                a.grp_seq_no, a.shr_pct,
                                NVL (a.losses_paid, 0) paid_losses,
                                NVL (a.expenses_paid, 0) paid_expenses
                           FROM gicl_res_brdrx_ds_extr a
                          WHERE a.session_id = p_session_id
                            AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                 OR ABS (NVL (a.expenses_paid, 0)) > 0
                                )
                            AND a.brdrx_record_id = j.brdrx_record_id
                            AND a.grp_seq_no = k.grp_seq_no
                            --AND a.peril_cd = NVL (p_peril_cd, a.peril_cd)
                            )
               LOOP
                  v_detail.paid_losses     := l.paid_losses;
                  v_detail.paid_expenses   := l.paid_expenses;
                  v_detail.enrollee        := i.enrollee;
                  v_detail.brdrx_record_id := j.brdrx_record_id;
                  v_detail.grp_seq_no      := k.grp_seq_no;
                  PIPE ROW (v_detail);
               END LOOP;
            END LOOP;
         END LOOP;
      END LOOP;

      RETURN;
   END get_treaty_details;

   FUNCTION get_facul (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_enrollee     gicl_res_brdrx_extr.enrollee%TYPE,
      p_brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE
      --p_peril_cd     giis_peril.peril_cd%TYPE,
      --p_claim_no     gicl_res_brdrx_extr.claim_no%TYPE
   )
      RETURN get_treaty_details_tab PIPELINED
   IS
      v_detail   get_treaty_details_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.enrollee
                           FROM gicl_res_brdrx_extr a
                          WHERE a.session_id = p_session_id
                            --AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND a.claim_id  = NVL(DECODE(p_claim_id, -1, a.claim_id, p_claim_id),a.claim_id )
                            AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                 OR ABS (NVL (a.expenses_paid, 0)) > 0
                                )
                            AND a.enrollee = NVL (p_enrollee, a.enrollee))
      LOOP
         FOR j IN (SELECT   a.brdrx_record_id, a.peril_cd
                       FROM gicl_res_brdrx_extr a
                      WHERE a.session_id = p_session_id
                        --AND a.claim_id = NVL (p_claim_id, a.claim_id)
                        AND a.claim_id  = NVL(DECODE(p_claim_id, -1, a.claim_id, p_claim_id),a.claim_id )
                        AND a.enrollee = i.enrollee
                        AND (   ABS (NVL (a.losses_paid, 0)) > 0
                             OR ABS (NVL (a.expenses_paid, 0)) > 0
                            )
                        --AND a.claim_no = NVL (p_claim_no, a.claim_no)
                        AND a.brdrx_record_id = NVL(DECODE(p_brdrx_record_id, -1, a.brdrx_record_id, p_brdrx_record_id),a.brdrx_record_id)
                   ORDER BY a.claim_no)
         LOOP
            FOR k IN (SELECT DISTINCT a.grp_seq_no
                                 FROM gicl_res_brdrx_ds_extr a,
                                      gicl_res_brdrx_extr b
                                WHERE a.session_id = p_session_id
                                  AND a.session_id = b.session_id
                                  AND a.brdrx_record_id = b.brdrx_record_id
                                  --AND a.claim_id = NVL (p_claim_id, a.claim_id)
                                  AND a.claim_id  = NVL(DECODE(p_claim_id, -1, a.claim_id, p_claim_id),a.claim_id )
                                  AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                       OR ABS (NVL (a.expenses_paid, 0)) > 0
                                      )
                                  AND b.enrollee = i.enrollee
                             ORDER BY a.grp_seq_no)
            LOOP
               FOR l IN (SELECT a.brdrx_record_id, a.brdrx_ds_record_id,
                                a.grp_seq_no, a.shr_pct,
                                NVL (a.losses_paid, 0) paid_losses,
                                NVL (a.expenses_paid, 0) paid_expenses
                           FROM gicl_res_brdrx_ds_extr a
                          WHERE a.session_id = p_session_id
                            AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                 OR ABS (NVL (a.expenses_paid, 0)) > 0
                                )
                            AND a.brdrx_record_id = j.brdrx_record_id
                            AND a.grp_seq_no = k.grp_seq_no
                            --AND a.peril_cd = NVL (p_peril_cd, a.peril_cd)
                            )
               LOOP
                  v_detail.enrollee        := i.enrollee;
                  v_detail.brdrx_record_id := j.brdrx_record_id;
                  v_detail.grp_seq_no      := k.grp_seq_no;
                  v_detail.paid_losses     := l.paid_losses;
                  v_detail.paid_expenses   := l.paid_expenses;
                  PIPE ROW (v_detail);

                  FOR m IN
                     (SELECT   a.brdrx_ds_record_id,
                               DECODE (a.prnt_ri_cd,
                                       NULL, a.ri_cd,
                                       a.prnt_ri_cd
                                      ) facul_ri_cd,
                               SUM (a.shr_ri_pct) facul_shr_ri_pct,
                               SUM
                                  (DECODE (SIGN (NVL (a.losses_paid, 0)),
                                           1, NVL (a.losses_paid, 0),
                                           0
                                          )
                                  ) paid_losses,
                               SUM
                                  (DECODE (SIGN (NVL (a.expenses_paid, 0)),
                                           1, NVL (a.expenses_paid, 0),
                                           0
                                          )
                                  ) paid_expenses
                          FROM gicl_res_brdrx_rids_extr a
                         WHERE a.grp_seq_no = 999
                           AND a.session_id = p_session_id
                           AND a.brdrx_ds_record_id = l.brdrx_ds_record_id
                      GROUP BY a.brdrx_ds_record_id,
                               DECODE (a.prnt_ri_cd,
                                       NULL, a.ri_cd,
                                       a.prnt_ri_cd
                                      ))
                  LOOP
                     BEGIN
                        SELECT ri_sname
                          INTO v_detail.ri_name
                          FROM giis_reinsurer
                         WHERE ri_cd = m.facul_ri_cd;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           v_detail.ri_name := NULL;
                     END;
                     v_detail.brdrx_ds_record_id := m.brdrx_ds_record_id;
                     v_detail.paid_losses2   := m.paid_losses;
                     v_detail.paid_expenses2 := m.paid_expenses;
                     PIPE ROW (v_detail);
                  END LOOP;
               END LOOP;
            END LOOP;
         END LOOP;
      END LOOP;

      RETURN;
   END get_facul;

   FUNCTION get_ri_details (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_enrollee     gicl_res_brdrx_extr.enrollee%TYPE
   )
      RETURN get_ri_details_tab PIPELINED
   IS
      v_detail   get_ri_details_type;
   BEGIN
      FOR j IN (SELECT DISTINCT c.enrollee
                           FROM gicl_res_brdrx_rids_extr a,
                                giis_trty_panel b,
                                gicl_res_brdrx_extr c,
                                gicl_res_brdrx_ds_extr d
                          WHERE a.grp_seq_no <> 999
                            AND a.session_id = p_session_id
                            AND a.session_id = c.session_id
                            AND a.session_id = d.session_id
                            AND c.brdrx_record_id = d.brdrx_record_id
                            AND a.brdrx_ds_record_id = d.brdrx_ds_record_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND a.line_cd = b.line_cd
                            AND a.grp_seq_no = b.trty_seq_no
                            AND a.ri_cd = b.ri_cd
                            AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                 OR ABS (NVL (a.expenses_paid, 0)) > 0
                                )
                            AND c.enrollee = NVL (p_enrollee, c.enrollee))
      LOOP
         FOR i IN (SELECT DISTINCT a.ri_cd, a.grp_seq_no, a.line_cd,
                                   DECODE (a.prnt_ri_cd,
                                           NULL, a.ri_cd,
                                           a.prnt_ri_cd
                                          ) trty_ri_cd,
                                   b.trty_shr_pct
                              FROM gicl_res_brdrx_rids_extr a,
                                   giis_trty_panel b,
                                   gicl_res_brdrx_extr c,
                                   gicl_res_brdrx_ds_extr d
                             WHERE a.grp_seq_no <> 999
                               AND a.session_id = p_session_id
                               AND a.session_id = c.session_id
                               AND a.session_id = d.session_id
                               AND c.brdrx_record_id = d.brdrx_record_id
                               AND a.brdrx_ds_record_id = d.brdrx_ds_record_id
                               AND a.claim_id = NVL (p_claim_id, a.claim_id)
                               AND a.line_cd = b.line_cd
                               AND a.grp_seq_no = b.trty_seq_no
                               AND a.ri_cd = b.ri_cd
                               AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                    OR ABS (NVL (a.expenses_paid, 0)) > 0
                                   )
                               AND c.enrollee = NVL (j.enrollee, c.enrollee))
         LOOP
            BEGIN
               SELECT trty_name
                 INTO v_detail.trty_name
                 FROM giis_dist_share
                WHERE share_cd = i.grp_seq_no AND line_cd = i.line_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_detail.trty_name := NULL;
            END;

            BEGIN
               SELECT ri_sname
                 INTO v_detail.ri_name
                 FROM giis_reinsurer
                WHERE ri_cd = i.ri_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_detail.ri_name := NULL;
            END;

            BEGIN
               FOR shr IN (SELECT trty_shr_pct
                             FROM giis_trty_panel
                            WHERE line_cd = i.line_cd
                              AND trty_seq_no = i.grp_seq_no
                              AND ri_cd = i.ri_cd)
               LOOP
                  v_detail.ri_shr := shr.trty_shr_pct;
               END LOOP;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_detail.ri_shr := NULL;
            END;

            v_detail.enrollee      := j.enrollee;
            v_detail.trty_ri_cd    := i.trty_ri_cd;
            v_detail.dummy_measure := 1;
            v_detail.ri_cd         := i.ri_cd;
            v_detail.trty_shr_pct  := i.trty_shr_pct;
            v_detail.grp_seq_no    := i.grp_seq_no;
            PIPE ROW (v_detail);
         END LOOP;
      END LOOP;

      RETURN;
   END get_ri_details;

   FUNCTION get_ri_amount (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_enrollee     gicl_res_brdrx_extr.enrollee%TYPE,
      p_ri_cd        NUMBER
   )
      RETURN get_ri_amount_tab PIPELINED
   IS
      v_detail   get_ri_amount_type;
   BEGIN
      FOR j IN (SELECT DISTINCT c.enrollee
                           FROM gicl_res_brdrx_rids_extr a,
                                giis_trty_panel b,
                                gicl_res_brdrx_extr c,
                                gicl_res_brdrx_ds_extr d
                          WHERE a.grp_seq_no <> 999
                            AND a.session_id = p_session_id
                            AND a.session_id = c.session_id
                            AND a.session_id = d.session_id
                            AND c.brdrx_record_id = d.brdrx_record_id
                            AND a.brdrx_ds_record_id = d.brdrx_ds_record_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND a.line_cd = b.line_cd
                            AND a.grp_seq_no = b.trty_seq_no
                            AND a.ri_cd = b.ri_cd
                            AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                 OR ABS (NVL (a.expenses_paid, 0)) > 0
                                )
                            AND c.enrollee = NVL (p_enrollee, c.enrollee))
      LOOP
         FOR i IN (SELECT DISTINCT a.ri_cd, a.grp_seq_no, a.line_cd,
                                   DECODE (a.prnt_ri_cd,
                                           NULL, a.ri_cd,
                                           a.prnt_ri_cd
                                          ) trty_ri_cd,
                                   a.brdrx_rids_record_id
                              FROM gicl_res_brdrx_rids_extr a,
                                   giis_trty_panel b,
                                   gicl_res_brdrx_extr c,
                                   gicl_res_brdrx_ds_extr d
                             WHERE a.grp_seq_no <> 999
                               AND a.session_id = p_session_id
                               AND a.session_id = c.session_id
                               AND a.session_id = d.session_id
                               AND c.brdrx_record_id = d.brdrx_record_id
                               AND a.brdrx_ds_record_id = d.brdrx_ds_record_id
                               AND a.claim_id = NVL (p_claim_id, a.claim_id)
                               AND a.line_cd = b.line_cd
                               AND a.grp_seq_no = b.trty_seq_no
                               AND a.ri_cd = b.ri_cd
                               AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                    OR ABS (NVL (a.expenses_paid, 0)) > 0
                                   )
                               AND c.enrollee = NVL (j.enrollee, c.enrollee)
                               AND a.ri_cd = NVL (p_ri_cd, a.ri_cd))
         LOOP
            FOR k IN (SELECT DISTINCT a.line_cd, a.grp_seq_no, b.enrollee
                                 FROM gicl_res_brdrx_ds_extr a,
                                      gicl_res_brdrx_extr b
                                WHERE a.grp_seq_no NOT IN (1, 999)
                                  AND a.session_id = p_session_id
                                  AND a.session_id = b.session_id
                                  AND a.brdrx_record_id = b.brdrx_record_id
                                  AND a.claim_id =
                                                  NVL (p_claim_id, a.claim_id)
                                  AND (   ABS (NVL (a.losses_paid, 0)) > 0
                                       OR ABS (NVL (a.expenses_paid, 0)) > 0
                                      )
                                  AND b.enrollee =
                                                  NVL (j.enrollee, b.enrollee)
                             ORDER BY a.grp_seq_no)
            LOOP
               FOR l IN
                  (SELECT a.brdrx_rids_record_id, a.grp_seq_no,
                          DECODE (SIGN (NVL (a.losses_paid, 0)),
                                  1, NVL (a.losses_paid, 0),
                                  0
                                 ) paid_losses,
                          DECODE (SIGN (NVL (a.expenses_paid, 0)),
                                  1, NVL (a.expenses_paid, 0),
                                  0
                                 ) paid_expenses
                     FROM gicl_res_brdrx_rids_extr a
                    WHERE a.grp_seq_no <> 999
                      AND a.session_id = p_session_id
                      AND (   ABS (NVL (a.losses_paid, 0)) > 0
                           OR ABS (NVL (a.expenses_paid, 0)) > 0
                          )
                      AND a.brdrx_rids_record_id = i.brdrx_rids_record_id
                      AND a.grp_seq_no = k.grp_seq_no)
               LOOP
                  BEGIN
                     SELECT trty_name
                       INTO v_detail.trty_name
                       FROM giis_dist_share
                      WHERE share_cd = i.grp_seq_no AND line_cd = i.line_cd;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_detail.trty_name := NULL;
                  END;

                  BEGIN
                     SELECT ri_sname
                       INTO v_detail.ri_name
                       FROM giis_reinsurer
                      WHERE ri_cd = i.ri_cd;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_detail.ri_name := NULL;
                  END;

                  BEGIN
                     FOR shr IN (SELECT trty_shr_pct
                                   FROM giis_trty_panel
                                  WHERE line_cd = i.line_cd
                                    AND trty_seq_no = i.grp_seq_no
                                    AND ri_cd = i.ri_cd)
                     LOOP
                        v_detail.ri_shr := shr.trty_shr_pct;
                     END LOOP;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_detail.ri_shr := NULL;
                  END;

                  v_detail.paid_losses3   := l.paid_losses;
                  v_detail.paid_expenses3 := l.paid_expenses;
                  v_detail.enrollee       := j.enrollee;
                  v_detail.trty_ri_cd     := i.trty_ri_cd;
                  v_detail.dummy_measure  := 1;
                  v_detail.grp_seq_no     := k.grp_seq_no;
                  PIPE ROW (v_detail);
               END LOOP;
            END LOOP;
         END LOOP;
      END LOOP;

      RETURN;
   END get_ri_amount;
   
   FUNCTION CF_DV_NOFormula(
        p_claim_id      gicl_clm_res_hist.CLAIM_ID%type,
        p_item_no       giac_chk_disbursement.ITEM_NO%type,
        p_clm_loss_id   gicl_clm_res_hist.CLM_LOSS_ID%type,    
        p_paid_losses   GICL_RES_BRDRX_EXTR.LOSSES_PAID%type,
        p_paid_expenses GICL_RES_BRDRX_EXTR.EXPENSES_PAID%type,
        p_paid_date     NUMBER,
        p_from_date     DATE,
        p_to_date       DATE
    )RETURN VARCHAR2
    AS
        v_dv_no          varchar2(100);
        var_dv_no        varchar2(500);
        v_cancel_date    gicl_clm_res_hist.cancel_date%type; 
        v_loss           number; 
        v_expense        number; 
    BEGIN
        FOR a IN (SELECT SIGN(p_paid_losses) losses_paid, SIGN(p_paid_expenses) expenses_paid
                    FROM dual)
        LOOP   
            v_loss := a.losses_paid;
            v_expense := a.expenses_paid;
            IF (v_loss < 1 AND v_expense = 0) OR (v_expense < 1 AND v_loss = 0) THEN  
                FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'|| LTRIM(TO_CHAR(b.dv_no,'0999999999'))|| ' /'||e.check_no dv_no,
                                  TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                             FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                                  giac_acctrans c, giac_reversals d,
                                  giac_chk_disbursement e
                            WHERE a.tran_id = b.gacc_tran_id
                              AND a.tran_id = d.gacc_tran_id
                              AND c.tran_id = d.reversing_tran_id 
                              AND b.gacc_tran_id = e.gacc_tran_id
                              AND e.item_no = p_item_no
                              AND a.claim_id = p_claim_id
                              AND a.clm_loss_id = p_clm_loss_id
                            GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                           HAVING SUM(NVL(a.losses_paid,0)) > 0
                               OR SUM(NVL(a.expenses_paid,0)) > 0)
                LOOP
                    v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
                    IF var_dv_no IS NULL THEN
                        var_dv_no := v_dv_no;
                    ELSE
                        var_dv_no := v_dv_no||CHR(10)||var_dv_no;   
                    END IF;
                END LOOP;
            ELSE 
                FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'|| LTRIM(TO_CHAR(b.dv_no,'0999999999'))||' /'||e.check_no dv_no
                             FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                                  giac_direct_claim_payts c, giac_acctrans d,
                                  giac_chk_disbursement e
                            WHERE a.tran_id             = d.tran_id    
                              AND b.gacc_tran_id = c.gacc_tran_id
                              AND b.gacc_tran_id = d.tran_id
                              AND b.gacc_tran_id = e.gacc_tran_id
                              AND e.item_no = p_item_no
                              AND a.claim_id = p_claim_id 
                              AND a.clm_loss_id = p_clm_loss_id
                              AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                                  BETWEEN p_from_date AND p_to_date
                            GROUP BY b.dv_pref, b.dv_no, e.check_no
                           HAVING SUM(NVL(a.losses_paid,0)) > 0
                               OR SUM(NVL(a.expenses_paid,0)) > 0)     
                LOOP
                    v_dv_no := v2.dv_no;
                    IF var_dv_no IS NULL THEN
                        var_dv_no := v_dv_no;
                    ELSE
                        var_dv_no := v_dv_no||CHR(10)||var_dv_no;   
                    END IF;
                END LOOP;      
            END IF;
        END LOOP;
  
        RETURN (var_dv_no);        
    
    END CF_DV_NOFormula;
    
    FUNCTION CF_INTM_RIFormula(
        p_claim_id      gicl_intm_itmperil.CLAIM_ID%type,
        p_item_no       gicl_intm_itmperil.ITEM_NO%type,
        p_peril_cd      gicl_intm_itmperil.PERIL_CD%type
    ) RETURN VARCHAR2
    AS
        v_pol_iss_cd     gicl_claims.pol_iss_cd%type; 
        v_intm_ri        VARCHAR2(1000);
    BEGIN
        BEGIN
            SELECT pol_iss_cd
              INTO v_pol_iss_cd 
              FROM gicl_claims
             WHERE claim_id = p_claim_id;   
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_pol_iss_cd := NULL; 
        END;    
    
        IF v_pol_iss_cd = GIACP.V('RI_ISS_CD') THEN
            BEGIN 
                FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                            FROM gicl_claims a, giis_reinsurer b
                           WHERE a.ri_cd = b.ri_cd
                             AND a.claim_id = p_claim_id)
                LOOP
                    v_intm_ri := TO_CHAR(r.ri_cd)||CHR(10)||r.ri_name;
                END LOOP;
            END;
        ELSE            
            BEGIN 
                FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                            FROM gicl_intm_itmperil a, giis_intermediary b
                           WHERE a.intm_no = b.intm_no
                             AND a.claim_id = p_claim_id
                             AND a.item_no = p_item_no
                             AND a.peril_cd = p_peril_cd) 
                LOOP
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||CHR(10)||
                                 m.intm_name||CHR(10)||v_intm_ri;
                END LOOP;
            END; 
        END IF;
        
        RETURN(v_intm_ri);
    
    END CF_INTM_RIFormula;
   
   /* Handle running multipage matrix 03.03.2014 - J. Diago */
   
   FUNCTION get_giclr221le_parent(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE
   )
     RETURN giclr221le_parent_tab PIPELINED
   IS
      v_row                giclr221le_parent_type;
      v_treaty_tab         treaty_tab;
      v_index              NUMBER := 0;
      v_id                 NUMBER := 0;
   BEGIN
      FOR enrollee IN (SELECT DISTINCT enrollee, line_cd
                         FROM gicl_res_brdrx_extr a
                        WHERE a.session_id = p_session_id
                          AND a.claim_id = NVL (p_claim_id, a.claim_id)
                          AND (ABS (NVL (a.losses_paid, 0)) > 0 
                                OR 
                               ABS (NVL (a.expenses_paid, 0)) > 0)
                        ORDER BY enrollee)
      LOOP
         v_id := 0;
         v_index := 0;
         v_treaty_tab := treaty_tab();
         
         FOR trty IN (SELECT DISTINCT a.grp_seq_no, a.line_cd, b.enrollee, c.trty_name
                       FROM gicl_res_brdrx_ds_extr a,
                            gicl_res_brdrx_extr b,
                            giis_dist_share c
                      WHERE a.session_id = p_session_id
                        AND a.session_id = b.session_id
                        AND a.brdrx_record_id = b.brdrx_record_id
                        AND a.claim_id = NVL (p_claim_id, a.claim_id)
                        AND (ABS (NVL (a.losses_paid, 0)) > 0 
                              OR 
                             ABS (NVL (a.expenses_paid, 0)) > 0)
                        AND c.line_cd = a.line_cd
                        AND c.share_cd = a.grp_seq_no
                        AND c.line_cd = enrollee.line_cd
                        AND b.enrollee = enrollee.enrollee
                   ORDER BY a.grp_seq_no)
        LOOP
           v_index := v_index + 1;
           v_treaty_tab.EXTEND;
           v_treaty_tab(v_index).grp_seq_no := trty.grp_seq_no;
           v_treaty_tab(v_index).trty_name := trty.trty_name;
        END LOOP;
        
        v_index := 1;
        
        LOOP
           v_id := v_id + 1;
           v_row := NULL;
           v_row.enrollee := enrollee.enrollee;
           v_row.enrollee_dummy := enrollee.enrollee || '_' || v_id;
           
           IF v_treaty_tab.EXISTS(v_index) THEN
              v_row.grp_seq_no1 := v_treaty_tab(v_index).grp_seq_no;
              v_row.treaty1 := v_treaty_tab(v_index).trty_name;
              v_index := v_index + 1;
           END IF;
            
           IF v_treaty_tab.EXISTS(v_index) THEN
              v_row.grp_seq_no2 := v_treaty_tab(v_index).grp_seq_no;
              v_row.treaty2 := v_treaty_tab(v_index).trty_name;
              v_index := v_index + 1;
           END IF;
            
           IF v_treaty_tab.EXISTS(v_index) THEN
              v_row.grp_seq_no3 := v_treaty_tab(v_index).grp_seq_no;
              v_row.treaty3 := v_treaty_tab(v_index).trty_name;
              v_index := v_index + 1;
           END IF;
            
           IF v_treaty_tab.EXISTS(v_index) THEN
              v_row.grp_seq_no4 := v_treaty_tab(v_index).grp_seq_no;
              v_row.treaty4 := v_treaty_tab(v_index).trty_name;
              v_index := v_index + 1;
           END IF;
           
           PIPE ROW(v_row);
           
           EXIT WHEN v_index > v_treaty_tab.COUNT;
        END LOOP;
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_giclr221le_claim(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee           GICL_RES_BRDRX_EXTR.enrollee%TYPE
   )
     RETURN giclr221le_claim_tab PIPELINED
   IS
      v_row                giclr221le_claim_type;
   BEGIN
      FOR claim IN (SELECT a.claim_id, a.claim_no, a.policy_no, a.enrollee, b.assd_name,
                           a.incept_date, a.expiry_date, a.loss_date, a.item_no
                      FROM gicl_res_brdrx_extr a, giis_assured b
                     WHERE a.assd_no = b.assd_no
                       AND a.session_id = p_session_id
                       AND a.claim_id = NVL (p_claim_id, a.claim_id)
                       AND (ABS (NVL (a.losses_paid, 0)) > 0 
                             OR 
                            ABS (NVL (a.expenses_paid, 0)) > 0)
                       AND a.enrollee = p_enrollee
                     GROUP BY a.claim_id, a.claim_no, a.policy_no, a.enrollee, b.assd_name, 
                              a.incept_date, a.expiry_date, a.loss_date, a.item_no
                     ORDER BY a.claim_no)
      LOOP
         v_row.claim_id := claim.claim_id;
         v_row.claim_no := claim.claim_no;
         v_row.policy_no := claim.policy_no;
         v_row.enrollee := claim.enrollee;
         v_row.assd_name := claim.assd_name;
         v_row.incept_date := claim.incept_date;
         v_row.expiry_date := claim.expiry_date;
         v_row.loss_date := claim.loss_date;
         v_row.item_no := claim.item_no;
         
         PIPE ROW(v_row);
      END LOOP;
      RETURN;
   END;
   
   FUNCTION get_giclr221le_item_main(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee           GICL_RES_BRDRX_EXTR.enrollee%TYPE
   )
     RETURN giclr221le_item_main_tab PIPELINED
   IS
      v_row                giclr221le_item_main_type;
   BEGIN
      FOR item_name IN (SELECT a.claim_id, a.claim_no, a.policy_no, a.enrollee, 
                               a.item_no, a.line_cd, a.grouped_item_no
                          FROM gicl_res_brdrx_extr a, giis_assured b
                         WHERE a.assd_no = b.assd_no
                           AND a.session_id = p_session_id
                           AND a.claim_id = NVL (p_claim_id, a.claim_id)
                           AND (ABS (NVL (a.losses_paid, 0)) > 0 
                                OR 
                                 ABS (NVL (a.expenses_paid, 0)) > 0)
                           AND a.enrollee = p_enrollee
                           GROUP BY claim_id, claim_no, policy_no, enrollee, item_no, line_cd, grouped_item_no
                         ORDER BY a.claim_no)
      LOOP
         v_row.claim_id := item_name.claim_id;
         v_row.claim_no := item_name.claim_no;
         v_row.policy_no := item_name.policy_no;
         v_row.enrollee := item_name.enrollee;
         v_row.item_no := item_name.item_no;
         v_row.item_title := CPI.get_gpa_item_title(item_name.claim_id, 
                                                   item_name.line_cd, 
                                                   item_name.item_no, 
                                                   item_name.grouped_item_no);
        
         PIPE ROW(v_row);
      END LOOP;
      RETURN;
   END;
   
   FUNCTION get_giclr221le_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee           GICL_RES_BRDRX_EXTR.enrollee%TYPE,
      p_paid_date          NUMBER,
      p_from_date          DATE,
      p_to_date            DATE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE
   )
     RETURN giclr221le_item_tab PIPELINED
   IS
      v_row                giclr221le_item_type;
   BEGIN
      FOR item IN (SELECT   a.claim_id, a.claim_no, a.policy_no, a.enrollee, a.item_no, a.tsi_amt,
                            a.loss_cat_cd, a.line_cd, a.peril_cd, a.clm_loss_id, NVL(a.losses_paid, 0) paid_losses,
                            NVL(a.expenses_paid, 0) paid_expenses, a.brdrx_record_id, a.grouped_item_no, a.from_date, a.to_date, a.pd_date_opt
                     FROM gicl_res_brdrx_extr a
                    WHERE a.session_id = p_session_id
                      AND a.claim_id = NVL (p_claim_id, a.claim_id)
                      AND (ABS (NVL (a.losses_paid, 0)) > 0 
                            OR 
                           ABS (NVL (a.expenses_paid, 0)) > 0)
                      AND a.enrollee = p_enrollee
                      AND a.item_no = p_item_no
                    ORDER BY a.claim_no, paid_expenses, paid_losses)
      LOOP
         v_row.claim_id := item.claim_id;
         v_row.claim_no := item.claim_no;
         v_row.policy_no := item.policy_no;
         v_row.enrollee := item.enrollee;
         v_row.item_no := item.item_no;
         v_row.tsi_amt := item.tsi_amt;
         v_row.paid_losses := item.paid_losses;
         v_row.paid_expenses := item.paid_expenses;
         v_row.brdrx_record_id := item.brdrx_record_id;
         
         BEGIN
           SELECT loss_cat_des
             INTO v_row.loss_cat_des
             FROM GIIS_LOSS_CTGRY
            WHERE loss_cat_cd  = item.loss_cat_cd
              AND line_cd = item.line_cd;
         END;
         
--         v_row.dv_no := cf_dv_noformula(item.claim_id, item.item_no, item.clm_loss_id, item.paid_losses, item.paid_expenses, p_paid_date, p_from_date, p_to_date);
         --v_row.dv_no_loss := gicls202_pkg.get_voucher_check_no(item.claim_id, item.item_no, item.peril_cd, item.grouped_item_no, p_from_date, p_to_date, p_paid_date, 'L');
         --v_row.dv_no_expense := gicls202_pkg.get_voucher_check_no(item.claim_id, item.item_no, item.peril_cd, item.grouped_item_no, p_from_date, p_to_date, p_paid_date, 'E');
         v_row.intm_name := giclr221le_pkg.CF_INTM_RIFormula(item.claim_id, item.item_no, item.peril_cd);
         
        IF item.paid_losses > 0 THEN
            v_row.dv_no := gicls202_extraction_pkg.get_voucher_check_no(item.claim_id, item.item_no, item.peril_cd, item.grouped_item_no, item.from_date, item.to_date, item.pd_date_opt, 'L');
        ELSE
            v_row.dv_no := gicls202_extraction_pkg.get_voucher_check_no(item.claim_id, item.item_no, item.peril_cd, item.grouped_item_no, item.from_date, item.to_date, item.pd_date_opt, 'E');
        END IF;
         
         PIPE ROW(v_row);
      END LOOP;
      RETURN;
   END;
   
   FUNCTION get_giclr221le_treaty(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee_dummy     GICL_RES_BRDRX_EXTR.enrollee%TYPE,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE
   )
     RETURN paid_lossexpense_tab_v PIPELINED
   IS
      TYPE ref_cursor IS REF CURSOR;
      TYPE t_table    IS TABLE OF VARCHAR2(1000);
      TYPE t_table2   IS TABLE OF VARCHAR2(1000);
      v_table              t_table;
      v_table2             t_table2;
      cur                  ref_cursor;
      cur2                 ref_cursor;
      v_row                paid_lossexpense_type_v;
      v_index              NUMBER := 1;
      v_index2             NUMBER := 1;
      v_temp               VARCHAR2(1000);
      v_temp2              VARCHAR2(1000);
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_loop               VARCHAR2(2500);
      v_loop2              VARCHAR2(2500);
      v_cur                VARCHAR2(1000);
      v_cur2               VARCHAR2(1000);
      v_claim_id           NUMBER(12);
   BEGIN
      v_table   := t_table();
      v_table2  := t_table2();
      
      IF p_claim_id IS NULL THEN
         v_claim_id := -1;
      ELSE
         v_claim_id := p_claim_id;
      END IF;
      
      FOR enrollee IN (SELECT enrollee, grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                         FROM TABLE (giclr221le_pkg.get_giclr221le_parent (p_session_id, p_claim_id))
                        WHERE enrollee_dummy = p_enrollee_dummy)
      LOOP
         FOR treaty IN 1 .. 4
         LOOP
            IF treaty = 1 THEN
               v_grp_seq_no := enrollee.grp_seq_no1;
            ELSIF treaty = 2 THEN
               v_grp_seq_no := enrollee.grp_seq_no2;
            ELSIF treaty = 3 THEN
               v_grp_seq_no := enrollee.grp_seq_no3;
            ELSIF treaty = 4 THEN
               v_grp_seq_no := enrollee.grp_seq_no4;
            END IF;
            
            IF v_grp_seq_no IS NULL THEN
               EXIT;
            END IF;
            
            v_loop := 'SELECT paid_losses
                         FROM TABLE (giclr221le_pkg.get_treaty_details (
                                                '||p_session_id||',
                                                '||v_claim_id||',
                                                '''||enrollee.enrollee||''',
                                                '||p_brdrx_record_id||'
                                               )
                                    )
                        WHERE grp_seq_no = '||v_grp_seq_no;
            
            v_loop2:= 'SELECT paid_expenses
                         FROM TABLE (giclr221le_pkg.get_treaty_details (
                                                '||p_session_id||',
                                                '||v_claim_id||',
                                                '''||enrollee.enrollee||''',
                                                '||p_brdrx_record_id||'
                                               )
                                    )
                        WHERE grp_seq_no = '||v_grp_seq_no;
                        
            v_temp  := NULL;
            v_temp2 := NULL;
            
            OPEN cur FOR v_loop;
            LOOP
               v_cur := NULL;
               FETCH cur INTO v_cur;
               
               BEGIN
                  IF v_temp IS NOT NULL THEN
                     v_temp := v_temp || CHR(10);
                  END IF;
            
                  SELECT v_temp || DECODE(SUBSTR(TRIM(TO_CHAR(v_cur, '9,999,999,999,999,999.99')), 1, 1), '.',
                         '0' || TRIM(TO_CHAR(v_cur, '9,999,999,999,999,999.99')),
                         TRIM(TO_CHAR(v_cur, '9,999,999,999,999,999.99')))
                    INTO v_temp
                    FROM DUAL;
               EXCEPTION
                  WHEN OTHERS THEN
                     v_temp := NULL;
               END;
               
               EXIT WHEN cur%NOTFOUND;
            END LOOP;
            
            v_table.EXTEND;
            v_table(v_index) := v_temp;
            v_index := v_index + 1;
            CLOSE cur;
            
            OPEN cur2 FOR v_loop2;
            LOOP
               v_cur2 := NULL;
               FETCH cur2 INTO v_cur2;
               
               BEGIN
                  IF v_temp2 IS NOT NULL THEN
                     v_temp2 := v_temp2 || CHR(10);
                  END IF;
            
                  SELECT v_temp2 || DECODE(SUBSTR(TRIM(TO_CHAR(v_cur2, '9,999,999,999,999,999.99')), 1, 1), '.',
                         '0' || TRIM(TO_CHAR(v_cur2, '9,999,999,999,999,999.99')),
                         TRIM(TO_CHAR(v_cur2, '9,999,999,999,999,999.99')))
                    INTO v_temp2
                    FROM DUAL;
               EXCEPTION
                  WHEN OTHERS THEN
                     v_temp2 := NULL;
               END;
               
               EXIT WHEN cur2%NOTFOUND;
            END LOOP;
            
            v_table2.EXTEND;
            v_table2(v_index2) := v_temp2;
            v_index2 := v_index2 + 1;
            CLOSE cur2;
         END LOOP;
      END LOOP;
      
      v_index := 1;
      IF v_table.EXISTS(v_index) THEN
         v_row.paid_losses1 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
      
      IF v_table.EXISTS(v_index) THEN
         v_row.paid_losses2 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
      
      IF v_table.EXISTS(v_index) THEN
         v_row.paid_losses3 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
      
      IF v_table.EXISTS(v_index) THEN
         v_row.paid_losses4 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
      
      v_index2 := 1;
      IF v_table2.EXISTS(v_index2) THEN
         v_row.paid_expenses1 := v_table2(v_index2);
         v_index2 := v_index2 + 1;
      END IF;
      
      IF v_table2.EXISTS(v_index2) THEN
         v_row.paid_expenses2 := v_table2(v_index2);
         v_index2 := v_index2 + 1;
      END IF;
      
      IF v_table2.EXISTS(v_index2) THEN
         v_row.paid_expenses3 := v_table2(v_index2);
         v_index2 := v_index2 + 1;
      END IF;
      
      IF v_table2.EXISTS(v_index2) THEN
         v_row.paid_expenses4 := v_table2(v_index2);
         v_index2 := v_index2 + 1;
      END IF;
      
      PIPE ROW(v_row);
      RETURN;
   END;
   
   FUNCTION get_giclr221le_facul(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee_dummy     GICL_RES_BRDRX_EXTR.enrollee%TYPE,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE
   )
     RETURN facul_tab PIPELINED
   IS
      v_row                facul_type;
   BEGIN
      FOR enrollee IN (SELECT enrollee, grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                         FROM TABLE (giclr221le_pkg.get_giclr221le_parent (p_session_id, p_claim_id))
                        WHERE enrollee_dummy = p_enrollee_dummy)
      LOOP
         FOR facul IN (SELECT *
                         FROM TABLE(giclr221le_pkg.get_facul(p_session_id, p_claim_id, enrollee.enrollee, p_brdrx_record_id))
                        WHERE grp_seq_no IN (enrollee.grp_seq_no1, enrollee.grp_seq_no2, enrollee.grp_seq_no3, enrollee.grp_seq_no4)
                          AND grp_seq_no = 999
                          AND ri_name IS NOT NULL)
         LOOP
            v_row := NULL;
            IF p_grp_seq_no1 = 999 THEN
               v_row.brdrx_ds_record_id := facul.brdrx_ds_record_id;
               v_row.ri_name1 := facul.ri_name;
               v_row.paid_losses1 := facul.paid_losses2;
               v_row.paid_expenses1 := facul.paid_expenses2;
            ELSIF p_grp_seq_no2 = 999 THEN
               v_row.brdrx_ds_record_id := facul.brdrx_ds_record_id;
               v_row.ri_name2 := facul.ri_name;
               v_row.paid_losses2 := facul.paid_losses2;
               v_row.paid_expenses2 := facul.paid_expenses2;
            ELSIF p_grp_seq_no3 = 999 THEN
               v_row.brdrx_ds_record_id := facul.brdrx_ds_record_id;
               v_row.ri_name3 := facul.ri_name;
               v_row.paid_losses3 := facul.paid_losses2;
               v_row.paid_expenses3 := facul.paid_expenses2;
            ELSIF p_grp_seq_no4 = 999 THEN
               v_row.brdrx_ds_record_id := facul.brdrx_ds_record_id;
               v_row.ri_name4 := facul.ri_name;
               v_row.paid_losses4 := facul.paid_losses2;
               v_row.paid_expenses4 := facul.paid_expenses2;
            END IF;
            
            PIPE ROW(v_row);
         END LOOP;
      END LOOP;
   END;
   
   FUNCTION get_giclr221le_expenses_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee           GICL_RES_BRDRX_EXTR.enrollee%TYPE
   )
     RETURN total_paid_lossexpenses_tab PIPELINED
   IS
      v_total              total_paid_lossexpenses_type;
   BEGIN
      FOR total IN (SELECT SUM (NVL (a.losses_paid, 0)) total_paid_losses, 
                           SUM (NVL (a.expenses_paid, 0)) total_paid_expenses
                      FROM gicl_res_brdrx_extr a
                     WHERE a.session_id = p_session_id
                       AND a.claim_id = NVL (p_claim_id, a.claim_id)
                       AND (ABS (NVL (a.losses_paid, 0)) > 0 
                             OR 
                            ABS (NVL (a.expenses_paid, 0)) > 0)
                       AND a.enrollee = p_enrollee
                     ORDER BY a.claim_no)
      LOOP
         v_total.total_paid_losses := total.total_paid_losses;
         v_total.total_paid_expenses := total.total_paid_expenses;
         PIPE ROW(v_total);
      END LOOP;
      RETURN;
   END;
   
   FUNCTION get_giclr221le_treaty_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee_dummy     GICL_RES_BRDRX_EXTR.enrollee%TYPE
   )
     RETURN paid_lossexpense_tab_v PIPELINED
   IS  
      TYPE ref_cursor IS REF CURSOR;
      TYPE t_table    IS TABLE OF VARCHAR2(1000);
      TYPE t_table2   IS TABLE OF VARCHAR2(1000);
      v_table              t_table;
      v_table2             t_table2;
      cur                  ref_cursor;
      cur2                 ref_cursor;
      v_row                paid_lossexpense_type_v;
      v_index              NUMBER := 1;
      v_index2             NUMBER := 1;
      v_temp               VARCHAR2(1000);
      v_temp2              VARCHAR2(1000);
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_loop               VARCHAR2(2500);
      v_loop2              VARCHAR2(2500);
      v_cur                VARCHAR2(1000);
      v_cur2               VARCHAR2(1000);
      v_claim_id           NUMBER(12) := -1;
      v_brdrx_record_id    NUMBER(12) := -1;
   BEGIN
      v_table  := t_table();
      v_table2  := t_table2();
      
      FOR enrollee IN (SELECT enrollee, grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                         FROM TABLE (giclr221le_pkg.get_giclr221le_parent (p_session_id, p_claim_id))
                        WHERE enrollee_dummy = p_enrollee_dummy)
      LOOP
         FOR treaty IN 1 .. 4
         LOOP
            IF treaty = 1 THEN
               v_grp_seq_no := enrollee.grp_seq_no1;
            ELSIF treaty = 2 THEN
               v_grp_seq_no := enrollee.grp_seq_no2;
            ELSIF treaty = 3 THEN
               v_grp_seq_no := enrollee.grp_seq_no3;
            ELSIF treaty = 4 THEN
               v_grp_seq_no := enrollee.grp_seq_no4;
            END IF;
            
            IF v_grp_seq_no IS NULL THEN
               EXIT;
            END IF;
            
            v_loop := 'SELECT SUM(paid_losses)
                         FROM ( SELECT paid_losses
                                  FROM TABLE (giclr221le_pkg.get_facul ('||p_session_id||',
                                                                       '||v_claim_id||',
                                                                       '''||enrollee.enrollee||''',
                                                                       '||v_brdrx_record_id||'
                                                                      )
                                             )
                                 WHERE grp_seq_no = '||v_grp_seq_no||'
                                 GROUP BY brdrx_record_id, paid_losses)';
                                 
            v_loop2:= 'SELECT SUM(paid_expenses)
                         FROM ( SELECT paid_expenses
                                  FROM TABLE (giclr221le_pkg.get_facul ('||p_session_id||',
                                                                       '||v_claim_id||',
                                                                       '''||enrollee.enrollee||''',
                                                                       '||v_brdrx_record_id||'
                                                                      )
                                             )
                                 WHERE grp_seq_no = '||v_grp_seq_no||'
                                 GROUP BY brdrx_record_id, paid_expenses)';
                                 
            OPEN cur FOR v_loop;
            LOOP
               FETCH cur INTO v_temp;
               EXIT WHEN cur%NOTFOUND;
            END LOOP;
            
            v_table.EXTEND;
            v_table(v_index) := v_temp;
            v_index := v_index + 1;
            
            CLOSE cur;
            
            OPEN cur2 FOR v_loop2;
            LOOP
               FETCH cur2 INTO v_temp2;
               EXIT WHEN cur2%NOTFOUND;
            END LOOP;
            
            v_table2.EXTEND;
            v_table2(v_index2) := v_temp2;
            v_index2 := v_index2 + 1;
            
            CLOSE cur2;
         END LOOP;
      END LOOP;
      
      v_index := 1;
      IF v_table.EXISTS(v_index) THEN
         v_row.paid_losses1 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
          
      IF v_table.EXISTS(v_index) THEN
         v_row.paid_losses2 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
          
      IF v_table.EXISTS(v_index) THEN
         v_row.paid_losses3 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
          
      IF v_table.EXISTS(v_index) THEN
         v_row.paid_losses4 := v_table(v_index);
         v_index := v_index + 1;
      END IF;
      
      v_index2 := 1;
      IF v_table2.EXISTS(v_index2) THEN
         v_row.paid_expenses1 := v_table2(v_index2);
         v_index2 := v_index2 + 1;
      END IF;
          
      IF v_table2.EXISTS(v_index2) THEN
         v_row.paid_expenses2 := v_table2(v_index2);
         v_index2 := v_index2 + 1;
      END IF;
          
      IF v_table2.EXISTS(v_index2) THEN
         v_row.paid_expenses3 := v_table2(v_index2);
         v_index2 := v_index2 + 1;
      END IF;
          
      IF v_table2.EXISTS(v_index2) THEN
         v_row.paid_expenses4 := v_table2(v_index2);
         v_index2 := v_index2 + 1;
      END IF;
      
      PIPE ROW(v_row);
      RETURN;
   END;
   
   FUNCTION get_treaty_ri2(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_enrollee           GICL_RES_BRDRX_EXTR.enrollee%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED
   AS
      rep                  treaty_ri_type2;
   BEGIN
      FOR j IN (SELECT DISTINCT a.ri_cd, a.line_cd, a.grp_seq_no,
                       DECODE(a.prnt_ri_cd, null, a.ri_cd, a.prnt_ri_cd) trty_ri_cd, policy_no
                  FROM GICL_RES_BRDRX_RIDS_EXTR a,
                       GIIS_TRTY_PANEL b,
                       GICL_RES_BRDRX_EXTR c,
                       GICL_RES_BRDRX_DS_EXTR d
                 WHERE 1 = 1
                   AND a.grp_seq_no <> 999
                   AND a.session_id = p_session_id
                   AND a.session_id = c.session_id
                   AND a.session_id = d.session_id
                   AND c.brdrx_record_id = d.brdrx_record_id
                   AND a.brdrx_ds_record_id = d.brdrx_ds_record_id
                   AND a.claim_id = nvl(p_claim_id, a.claim_id)
                   AND a.line_cd = b.line_cd
                   AND a.grp_seq_no = b.trty_seq_no
                   AND a.ri_cd = b.ri_cd
                   AND ( NVL(a.expenses_paid, 0) > 0
                    OR   NVL(a.losses_paid, 0) >0 ) 
                   AND c.enrollee = p_enrollee
                 ORDER BY a.grp_seq_no, a.ri_cd, DECODE(a.prnt_ri_cd, null, a.ri_cd, a.prnt_ri_cd))
     LOOP
        rep.policy_no := j.policy_no;
        rep.line_cd := j.line_cd;
        rep.grp_seq_no := j.grp_seq_no;
        rep.ri_cd := j.ri_cd;
        rep.trty_ri_cd := j.trty_ri_cd;
        
        BEGIN
           SELECT trty_name
             INTO rep.treaty_name
             FROM giis_dist_share
            WHERE share_cd = j.grp_seq_no AND line_cd = j.line_cd;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              rep.treaty_name := NULL;
        END;
        
        BEGIN
           SELECT ri_sname
             INTO rep.ri_name
             FROM giis_reinsurer
            WHERE ri_cd = j.ri_cd;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              rep.ri_name := NULL;
        END;
        
        BEGIN
           FOR shr IN (SELECT trty_shr_pct
                         FROM giis_trty_panel
                        WHERE line_cd = j.line_cd
                          AND trty_seq_no = j.grp_seq_no
                          AND ri_cd = j.ri_cd)
           LOOP
              rep.trty_shr_pct := shr.trty_shr_pct;
           END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rep.trty_shr_pct := NULL;
        END;
        
        FOR a IN (SELECT NVL(SUM(a.expenses_paid),0) paid_expenses,
                         NVL(SUM(a.losses_paid),0) paid_losses
                    FROM GICL_RES_BRDRX_RIDS_EXTR a
                   WHERE a.grp_seq_no <> 999
                     AND a.session_id = p_session_id
                     AND ( NVL(a.expenses_paid, 0) > 0
                      OR   NVL(a.losses_paid, 0) > 0 )
                     AND a.grp_seq_no = j.grp_seq_no
                     AND a.ri_cd = j.ri_cd
                     AND a.brdrx_rids_record_id IN(SELECT a.brdrx_rids_record_id
                                                     FROM GICL_RES_BRDRX_RIDS_EXTR a,
                                                          GIIS_TRTY_PANEL b,
                                                          GICL_RES_BRDRX_EXTR c,
                                                          GICL_RES_BRDRX_DS_EXTR d
                                                    WHERE a.grp_seq_no <> 999
                                                      AND a.session_id = p_session_id
                                                      AND a.session_id = c.session_id
                                                      AND a.session_id = d.session_id
                                                      AND c.brdrx_record_id = d.brdrx_record_id
                                                      AND a.brdrx_ds_record_id = d.brdrx_ds_record_id
                                                      AND a.claim_id = NVL(p_claim_id, a.claim_id)
                                                      AND a.line_cd = b.line_cd
                                                      AND a.grp_seq_no = b.trty_seq_no
                                                      AND a.ri_cd = b.ri_cd
                                                      AND ( NVL(a.expenses_paid, 0) > 0 
                                                       OR   NVL(a.losses_paid, 0) > 0 )
                                                      AND c.enrollee = p_enrollee)
                    ORDER BY a.grp_seq_no, a.brdrx_rids_record_id)
        LOOP
           rep.paid_losses := a.paid_losses;
           rep.paid_expenses := a.paid_expenses;
        END LOOP;
        
        PIPE ROW(rep);
     END LOOP;
     
     RETURN;
   END;
END GICLR221LE_PKG;
/


