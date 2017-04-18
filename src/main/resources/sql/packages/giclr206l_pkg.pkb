CREATE OR REPLACE PACKAGE BODY CPI.giclr206l_pkg
AS
/*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created : 03.19.2013
    **  Reference By : GICLR206L - LOSSES PAID BORDEREAUX
    */
   FUNCTION cf_dv_noformula (
      p_paid_losses   gicl_clm_res_hist.losses_paid%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_clm_loss_id   gicl_clm_res_hist.clm_loss_id%TYPE,
      p_from_date     DATE,
      p_to_date       DATE,
      p_paid_date     NUMBER
   )
      RETURN VARCHAR2
   IS
      v_dv_no         VARCHAR2 (100);
      var_dv_no       VARCHAR2 (500);
      v_cancel_date   gicl_clm_res_hist.cancel_date%TYPE;
      v_loss          NUMBER;
      v_date_format   VARCHAR2 (50);
   BEGIN
      SELECT NVL (param_value_v, 'MM-DD-RRRR')
        INTO v_date_format
        FROM giis_parameters
       WHERE param_name = 'REP_DATE_FORMAT';

      FOR a IN (SELECT SIGN (p_paid_losses) losses_paid
                  FROM DUAL)
      LOOP
         v_loss := a.losses_paid;

         IF v_loss < 1
         THEN
            FOR v1 IN
               (SELECT DISTINCT    b.dv_pref
                                || '-'
                                || LTRIM (TO_CHAR (b.dv_no, '0999999999'))
                                || ' /'
                                || e.check_no
                                || CHR (10)
                                || TO_CHAR (e.check_date, v_date_format)
                                                                       dv_no,
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
                            AND a.claim_id = p_claim_id
                            AND a.clm_loss_id = p_clm_loss_id
                       GROUP BY b.dv_pref,
                                b.dv_no,
                                e.check_no,
                                e.check_date,
                                a.cancel_date
                         HAVING SUM (NVL (a.losses_paid, 0)) > 0)
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
                                || LTRIM (TO_CHAR (b.dv_no, '0999999999'))
                                || ' /'
                                || e.check_no
                                || CHR (10)
                                || TO_CHAR (e.check_date, v_date_format)
                                                                       dv_no
                           FROM gicl_clm_res_hist a,
                                giac_disb_vouchers b,
                                giac_direct_claim_payts c,
                                giac_acctrans d,
                                giac_chk_disbursement e
                          WHERE a.tran_id = d.tran_id
                            AND b.gacc_tran_id = c.gacc_tran_id
                            AND b.gacc_tran_id = d.tran_id
                            AND b.gacc_tran_id = e.gacc_tran_id
                            AND a.claim_id = p_claim_id
                            AND a.clm_loss_id = p_clm_loss_id
                            AND DECODE (p_paid_date,
                                        1, TRUNC (a.date_paid),
                                        2, TRUNC (d.posting_date)
                                       ) BETWEEN p_from_date AND p_to_date
                       GROUP BY b.dv_pref, b.dv_no, e.check_no, e.check_date
                         HAVING SUM (NVL (a.losses_paid, 0)) > 0)
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

      RETURN (var_dv_no);
   END;

   FUNCTION get_header (p_from_date DATE, p_to_date DATE, p_paid_date NUMBER)
      RETURN header_tab PIPELINED
   IS
      v_header   header_type;
   BEGIN
      v_header.cf_company := giisp.v ('COMPANY_NAME');
      v_header.cf_com_address := giisp.v ('COMPANY_ADDRESS');

      BEGIN
         SELECT report_title
           INTO v_header.report_title
           FROM giis_reports
          WHERE report_id = 'GICLR206L';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_header.report_title := NULL;
      END;

      BEGIN
         SELECT    '(Based on '
                || DECODE (p_paid_date,
                           1, 'Transaction Date',
                           2, 'Posting Date'
                          )
                || ')'
           INTO v_header.cf_param_date
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_header.cf_param_date := NULL;
      END;

      BEGIN
         SELECT    'from '
                || TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
                || ' to '
                || TO_CHAR (p_to_date, 'fmMonth DD, YYYY')
           INTO v_header.cf_date
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_header.cf_date := NULL;
      END;

      PIPE ROW (v_header);
      RETURN;
   END get_header;

   FUNCTION get_detail (
      p_from_date       DATE,
      p_to_date         DATE,
      p_paid_date       NUMBER,
      p_session_id      gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id        gicl_res_brdrx_extr.claim_id%TYPE,
      p_amt             VARCHAR2,
      p_intm_break      NUMBER,
      p_iss_break       NUMBER,
      p_subline_break   NUMBER
   )
      RETURN detail_tab PIPELINED
   IS
      v_detail        detail_type;
      v_loss          NUMBER;
      v_dv_no         VARCHAR2 (100);
      var_dv_no       VARCHAR2 (500);
      v_intm_ri       VARCHAR2 (1000);
      v_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE;
      v_cancel_date   gicl_clm_res_hist.cancel_date%TYPE;
      v_date_format   VARCHAR2 (50);
   BEGIN
      FOR i IN (SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                                DECODE (a.iss_cd,
                                        'RI', 'RI',
                                        b.intm_type
                                       ) buss_source_type,
                                a.iss_cd, a.buss_source, a.line_cd,
                                a.subline_cd, a.loss_year
                           FROM gicl_res_brdrx_extr a, giis_intermediary b
                          WHERE a.buss_source = b.intm_no(+)
                            AND a.session_id = p_session_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND NVL (a.losses_paid, 0) <> 0
                       ORDER BY a.buss_source)
      LOOP
         v_detail.iss_type := i.iss_type;
         v_detail.buss_source_type := i.buss_source_type;
         v_detail.iss_cd := i.iss_cd;
         v_detail.buss_source := i.buss_source;
         v_detail.line_cd := i.line_cd;
         v_detail.subline_cd := i.subline_cd;
         v_detail.loss_year := i.loss_year;

         BEGIN
            SELECT DISTINCT 'X'
                       INTO v_detail.v_exist
                       FROM gicl_res_brdrx_extr a
                      WHERE a.session_id = p_session_id
                        AND a.claim_id = NVL (p_claim_id, a.claim_id)
                        AND NVL (a.losses_paid, 0) <> 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_detail.v_exist := NULL;
         END;

         BEGIN
            SELECT intm_desc
              INTO v_detail.buss_source_name
              FROM giis_intm_type
             WHERE intm_type = i.buss_source_type;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_detail.buss_source_name := 'REINSURER ';
            WHEN OTHERS
            THEN
               v_detail.buss_source_name := NULL;
         END;

         BEGIN
            IF i.iss_type = 'RI'
            THEN
               BEGIN
                  SELECT ri_name
                    INTO v_detail.source_name
                    FROM giis_reinsurer
                   WHERE ri_cd = i.buss_source;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     v_detail.source_name := NULL;
               END;
            ELSE
               BEGIN
                  SELECT intm_name
                    INTO v_detail.source_name
                    FROM giis_intermediary
                   WHERE intm_no = i.buss_source;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     v_detail.source_name := NULL;
               END;
            END IF;
         END;

         BEGIN
            SELECT iss_name
              INTO v_detail.iss_name
              FROM giis_issource
             WHERE iss_cd = i.iss_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_detail.iss_name := NULL;
         END;

         BEGIN
            SELECT line_name
              INTO v_detail.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_detail.line_name := NULL;
         END;

         BEGIN
            SELECT subline_name
              INTO v_detail.subline_name
              FROM giis_subline
             WHERE subline_cd = i.subline_cd AND line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_detail.subline_name := NULL;
         END;

         FOR j IN (SELECT   a.brdrx_record_id, a.buss_source, a.iss_cd,
                            a.line_cd, a.subline_cd, a.loss_year, a.claim_id,
                            a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                            a.expiry_date, a.loss_date, a.clm_file_date,
                            a.item_no, a.grouped_item_no, a.peril_cd,
                            a.loss_cat_cd, a.tsi_amt, a.intm_no,
                            a.clm_loss_id, NVL (a.losses_paid, 0) paid_losses,
                            a.losses_paid
                       FROM gicl_res_brdrx_extr a
                      WHERE a.session_id = p_session_id
                        AND a.claim_id = NVL (p_claim_id, a.claim_id)
                        AND NVL (a.losses_paid, 0) <> 0
                        AND a.buss_source = i.buss_source
                        AND a.iss_cd = i.iss_cd
                        AND a.line_cd = i.line_cd
                        AND a.subline_cd = i.subline_cd
                        AND a.loss_year = i.loss_year
                   ORDER BY a.buss_source, a.claim_no)
         LOOP
            v_detail.brdrx_record_id := j.brdrx_record_id;
            v_detail.claim_no := j.claim_no;
            v_detail.incept_date := TO_CHAR (j.incept_date, 'MM-DD-RRRR');
            v_detail.expiry_date := TO_CHAR (j.expiry_date, 'MM-DD-RRRR');
            v_detail.loss_date := TO_CHAR (j.loss_date, 'MM-DD-RRRR');
            v_detail.item_title :=
               get_gpa_item_title (j.claim_id,
                                   j.line_cd,
                                   j.item_no,
                                   NVL (j.grouped_item_no, 0)
                                  );
            v_detail.tsi_amt := j.tsi_amt;
            v_detail.paid_losses := j.losses_paid;
            v_detail.policy_no := j.policy_no;
            v_detail.peril_cd := j.peril_cd;
            v_detail.item_no := j.item_no;
            v_detail.claim_id := j.claim_id;
            v_detail.cf_dv_no :=
               cf_dv_noformula (j.losses_paid,
                                j.claim_id,
                                j.clm_loss_id,
                                p_from_date,
                                p_to_date,
                                p_paid_date
                               );

            BEGIN
               SELECT peril_name
                 INTO v_detail.peril_name
                 FROM giis_peril
                WHERE peril_cd = j.peril_cd AND line_cd = j.line_cd;
            EXCEPTION
               WHEN OTHERS
               THEN
                  v_detail.peril_name := NULL;
            END;

            BEGIN
               SELECT assd_name
                 INTO v_detail.assd_name
                 FROM giis_assured
                WHERE assd_no = j.assd_no;
            EXCEPTION
               WHEN OTHERS
               THEN
                  v_detail.assd_name := NULL;
            END;

            BEGIN
               SELECT b.ref_pol_no
                 INTO v_detail.cf_policy_no
                 FROM gicl_claims a, gipi_polbasic b
                WHERE a.line_cd = b.line_cd
                  AND a.subline_cd = b.subline_cd
                  AND a.pol_iss_cd = b.iss_cd
                  AND a.issue_yy = b.issue_yy
                  AND a.pol_seq_no = b.pol_seq_no
                  AND a.renew_no = b.renew_no
                  AND b.endt_seq_no = 0
                  AND a.claim_id = j.claim_id
                  AND ref_pol_no IS NOT NULL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_detail.cf_policy_no := NULL;
            END;

            BEGIN
               v_intm_ri := NULL;

               BEGIN
                  SELECT pol_iss_cd
                    INTO v_pol_iss_cd
                    FROM gicl_claims
                   WHERE claim_id = j.claim_id;
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
                                  AND a.claim_id = j.claim_id)
                     LOOP
                        v_intm_ri := TO_CHAR (r.ri_cd) || CHR (10)
                                     || r.ri_name;
                     END LOOP;
                  END;
               ELSE
                  IF p_intm_break = 1
                  THEN
                     BEGIN
                        FOR i IN (SELECT a.intm_no intm_no,
                                         b.intm_name intm_name,
                                         b.ref_intm_cd ref_intm_cd
                                    FROM gicl_res_brdrx_extr a,
                                         giis_intermediary b
                                   WHERE a.intm_no = b.intm_no
                                     AND a.session_id = p_session_id
                                     AND a.claim_id = j.claim_id
                                     AND a.item_no = j.item_no
                                     AND a.peril_cd = j.peril_cd
                                     AND a.intm_no = j.intm_no)
                        LOOP
                           v_intm_ri :=
                                 TO_CHAR (i.intm_no)
                              || '/'
                              || i.ref_intm_cd
                              || CHR (10)
                              || i.intm_name;
                        END LOOP;
                     END;
                  ELSIF p_intm_break = 0
                  THEN
                     BEGIN
                        FOR m IN (SELECT a.intm_no, b.intm_name,
                                         b.ref_intm_cd
                                    FROM gicl_intm_itmperil a,
                                         giis_intermediary b
                                   WHERE a.intm_no = b.intm_no
                                     AND a.claim_id = j.claim_id
                                     AND a.item_no = j.item_no
                                     AND a.peril_cd = j.peril_cd)
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
               END IF;

               v_detail.intm_ri := v_intm_ri;
            END;

            PIPE ROW (v_detail);
         END LOOP;
      END LOOP;

      RETURN;
   END get_detail;

   FUNCTION get_treaty_detail (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE
   )
      RETURN treaty_detail_tab PIPELINED
   IS
      v_detail   treaty_detail_type;
   BEGIN
      FOR i IN (SELECT a.brdrx_record_id, a.buss_source, a.iss_cd, a.line_cd,
                       a.subline_cd, a.loss_year, a.claim_id, a.assd_no,
                       a.claim_no, a.policy_no, a.incept_date, a.expiry_date,
                       a.loss_date, a.clm_file_date, a.item_no,
                       a.grouped_item_no, a.peril_cd, a.loss_cat_cd,
                       a.tsi_amt, a.intm_no, a.clm_loss_id,
                       NVL (a.losses_paid, 0) paid_losses, a.losses_paid
                  FROM gicl_res_brdrx_extr a
                 WHERE a.session_id = p_session_id
                   AND a.claim_id = NVL (p_claim_id, a.claim_id)
                   AND NVL (a.losses_paid, 0) <> 0
                   AND a.buss_source = p_buss_source
                   AND a.iss_cd = p_iss_cd
                   AND a.line_cd = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.loss_year = p_loss_year)
      LOOP
         FOR j IN (SELECT DISTINCT a.grp_seq_no, a.buss_source, a.iss_cd,
                                   a.line_cd, a.subline_cd, a.loss_year
                              FROM gicl_res_brdrx_ds_extr a
                             WHERE a.session_id = p_session_id
                               AND a.claim_id = NVL (p_claim_id, a.claim_id)
                               AND a.buss_source = p_buss_source
                               AND a.iss_cd = p_iss_cd
                               AND a.line_cd = p_line_cd
                               AND a.subline_cd = p_subline_cd
                               AND a.loss_year = p_loss_year
                          ORDER BY a.grp_seq_no)
         LOOP
            FOR k IN (SELECT a.brdrx_record_id, a.brdrx_ds_record_id,
                             a.grp_seq_no, a.shr_pct,
                             NVL (a.losses_paid, 0) paid_losses
                        FROM gicl_res_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND NVL (a.losses_paid, 0) <> 0
                         AND a.brdrx_record_id = i.brdrx_record_id
                         AND a.grp_seq_no = j.grp_seq_no)
            LOOP
               v_detail.grp_seq_no := j.grp_seq_no;

               BEGIN
                  SELECT trty_name
                    INTO v_detail.trty_name
                    FROM giis_dist_share
                   WHERE share_cd = j.grp_seq_no AND line_cd = j.line_cd;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     v_detail.trty_name := NULL;
               END;

               v_detail.paid_losses2 := k.paid_losses;
               v_detail.brdrx_record_id := i.brdrx_record_id;
               v_detail.item_no := i.item_no;
               v_detail.ri_sname := NULL;
               v_detail.paid_losses3 := NULL;
               PIPE ROW (v_detail);

               FOR l IN (SELECT   a.brdrx_ds_record_id,
                                  DECODE (a.prnt_ri_cd,
                                          NULL, a.ri_cd,
                                          a.prnt_ri_cd
                                         ) facul_ri_cd,
                                  SUM (a.shr_ri_pct) facul_shr_ri_pct,
                                  SUM (NVL (a.losses_paid, 0)) paid_losses
                             FROM gicl_res_brdrx_rids_extr a
                            WHERE a.grp_seq_no = 999
                              AND a.session_id = p_session_id
                              AND a.brdrx_ds_record_id = k.brdrx_ds_record_id
                         GROUP BY a.brdrx_ds_record_id,
                                  DECODE (a.prnt_ri_cd,
                                          NULL, a.ri_cd,
                                          a.prnt_ri_cd
                                         ))
               LOOP
                  BEGIN
                     SELECT ri_sname
                       INTO v_detail.ri_sname
                       FROM giis_reinsurer
                      WHERE ri_cd = l.facul_ri_cd;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        v_detail.ri_sname := NULL;
                  END;

                  v_detail.paid_losses3 := l.paid_losses;
                  PIPE ROW (v_detail);
               END LOOP;
            END LOOP;
         END LOOP;

         FOR m IN (SELECT DISTINCT a.grp_seq_no, a.buss_source, a.iss_cd,
                                   a.line_cd, a.subline_cd, a.loss_year
                              FROM gicl_res_brdrx_ds_extr a
                             WHERE a.session_id = p_session_id
                               AND a.claim_id = NVL (p_claim_id, a.claim_id)
                               AND a.buss_source = p_buss_source
                               AND a.iss_cd = p_iss_cd
                               AND a.line_cd = p_line_cd
                               AND a.subline_cd = p_subline_cd
                               AND a.loss_year = p_loss_year
                               AND a.grp_seq_no NOT IN (
                                      SELECT DISTINCT a.grp_seq_no
                                                 FROM gicl_res_brdrx_ds_extr a
                                                WHERE a.brdrx_record_id =
                                                             i.brdrx_record_id
                                                  AND a.session_id =
                                                                  p_session_id
                                                  AND a.claim_id =
                                                         NVL (p_claim_id,
                                                              a.claim_id
                                                             )
                                                  AND a.buss_source =
                                                                 p_buss_source
                                                  AND a.iss_cd = p_iss_cd
                                                  AND a.line_cd = p_line_cd
                                                  AND a.subline_cd =
                                                                  p_subline_cd
                                                  AND a.loss_year =
                                                                   p_loss_year)
                          ORDER BY a.grp_seq_no)
         LOOP
            v_detail.grp_seq_no := m.grp_seq_no;

            BEGIN
               SELECT trty_name
                 INTO v_detail.trty_name
                 FROM giis_dist_share
                WHERE share_cd = m.grp_seq_no AND line_cd = m.line_cd;
            EXCEPTION
               WHEN OTHERS
               THEN
                  v_detail.trty_name := NULL;
            END;

            v_detail.paid_losses2 := NULL;
            v_detail.ri_sname := NULL;
            v_detail.paid_losses3 := NULL;
            PIPE ROW (v_detail);
         END LOOP;
      END LOOP;

      RETURN;
   END get_treaty_detail;

   FUNCTION get_ri_detail (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE
   )
      RETURN ri_detail_tab PIPELINED
   IS
      v_detail   ri_detail_type;
   BEGIN
      FOR h IN (SELECT DISTINCT a.ri_cd, a.grp_seq_no, a.buss_source,
                                a.iss_cd, a.line_cd, a.subline_cd,
                                a.loss_year
                           FROM gicl_res_brdrx_rids_extr a
                          WHERE a.grp_seq_no <> 999
                            AND a.session_id = p_session_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND NVL (a.losses_paid, 0) <> 0
                            AND a.buss_source = p_buss_source
                            AND a.iss_cd = p_iss_cd
                            AND a.line_cd = p_line_cd
                            AND a.subline_cd = p_subline_cd
                            AND a.loss_year = p_loss_year
                       ORDER BY a.grp_seq_no)
      LOOP
         v_detail.grp_seq_no := h.grp_seq_no;
         v_detail.ri_cd := h.ri_cd;

         FOR i IN (SELECT DISTINCT a.iss_cd, a.buss_source, a.line_cd,
                                   a.subline_cd, a.loss_year, a.grp_seq_no,
                                   DECODE (a.prnt_ri_cd,
                                           NULL, a.ri_cd,
                                           a.prnt_ri_cd
                                          ) trty_ri_cd,
                                   a.ri_cd, a.shr_ri_pct, b.trty_shr_pct
                              FROM gicl_res_brdrx_rids_extr a,
                                   giis_trty_panel b
                             WHERE a.grp_seq_no <> 999
                               AND a.session_id = p_session_id
                               AND a.claim_id = NVL (p_claim_id, a.claim_id)
                               AND a.line_cd = b.line_cd
                               AND a.grp_seq_no = b.trty_seq_no
                               AND a.ri_cd = b.ri_cd
                               AND a.buss_source = h.buss_source
                               AND a.iss_cd = h.iss_cd
                               AND a.line_cd = h.line_cd
                               AND a.subline_cd = h.subline_cd
                               AND a.loss_year = h.loss_year
                               AND a.grp_seq_no = h.grp_seq_no
                               AND a.ri_cd = h.ri_cd
                               AND NVL (a.losses_paid, 0) <> 0
                          ORDER BY a.grp_seq_no,
                                   DECODE (a.prnt_ri_cd,
                                           NULL, a.ri_cd,
                                           a.prnt_ri_cd
                                          ))
         LOOP
            v_detail.trty_ri_cd := i.trty_ri_cd;
            v_detail.dummy_measure := 1;
            v_detail.trty_shr_pct := i.trty_shr_pct;

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
         END LOOP;

         PIPE ROW (v_detail);
      END LOOP;

      RETURN;
   END get_ri_detail;

   FUNCTION get_ri_amount (
      p_session_id    gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_extr.claim_id%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_iss_cd        giis_issource.iss_cd%TYPE,
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE,
      p_ri_cd         NUMBER
   )
      RETURN ri_amount_tab PIPELINED
   IS
      v_detail   ri_amount_type;
   BEGIN
      FOR j IN (SELECT DISTINCT a.iss_cd, a.buss_source, a.line_cd,
                                a.subline_cd, a.loss_year, a.grp_seq_no
                           FROM gicl_res_brdrx_ds_extr a
                          WHERE a.grp_seq_no NOT IN (1, 999)
                            AND a.session_id = p_session_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND a.buss_source = p_buss_source
                            AND a.iss_cd = p_iss_cd
                            AND a.line_cd = p_line_cd
                            AND a.subline_cd = p_subline_cd
                            AND a.loss_year = p_loss_year
                       ORDER BY a.grp_seq_no)
      LOOP
         v_detail.grp_seq_no := j.grp_seq_no;
         v_detail.paid_losses3 := NULL;

         BEGIN
            SELECT trty_name
              INTO v_detail.trty_name
              FROM giis_dist_share
             WHERE share_cd = j.grp_seq_no AND line_cd = j.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_detail.trty_name := NULL;
         END;

         v_detail.ri_name := NULL;

         FOR i IN (SELECT   a.brdrx_rids_record_id, a.iss_cd, a.buss_source,
                            a.line_cd, a.subline_cd, a.loss_year,
                            a.grp_seq_no,
                            DECODE (a.prnt_ri_cd,
                                    NULL, a.ri_cd,
                                    a.prnt_ri_cd
                                   ) trty_ri_cd,
                            a.ri_cd, a.shr_ri_pct, b.trty_shr_pct
                       FROM gicl_res_brdrx_rids_extr a, giis_trty_panel b
                      WHERE a.grp_seq_no <> 999
                        AND a.session_id = p_session_id
                        AND a.claim_id = NVL (p_claim_id, a.claim_id)
                        AND a.line_cd = b.line_cd
                        AND a.grp_seq_no = b.trty_seq_no
                        AND a.ri_cd = b.ri_cd
                        AND NVL (a.losses_paid, 0) <> 0
                        AND a.buss_source = p_buss_source
                        AND a.iss_cd = p_iss_cd
                        AND a.line_cd = p_line_cd
                        AND a.subline_cd = p_subline_cd
                        AND a.loss_year = p_loss_year
                   ORDER BY a.grp_seq_no,
                            DECODE (a.prnt_ri_cd,
                                    NULL, a.ri_cd,
                                    a.prnt_ri_cd
                                   ))
         LOOP
            v_detail.ri_shr := NULL;
            v_detail.trty_ri_cd := NULL;
            v_detail.paid_losses3 := NULL;
            v_detail.ri_name := NULL;

            FOR k IN (SELECT a.brdrx_rids_record_id, a.grp_seq_no,
                             NVL (a.losses_paid, 0) paid_losses
                        FROM gicl_res_brdrx_rids_extr a
                       WHERE a.grp_seq_no <> 999
                         AND a.session_id = p_session_id
                         AND a.brdrx_rids_record_id = i.brdrx_rids_record_id
                         AND a.grp_seq_no = j.grp_seq_no
                         AND NVL (a.losses_paid, 0) <> 0
                         AND a.ri_cd = NVL (p_ri_cd, a.ri_cd))
            LOOP
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

               v_detail.paid_losses3 := k.paid_losses;
               v_detail.trty_ri_cd := i.trty_ri_cd;
               v_detail.dummy_measure := 1;
            END LOOP;

            PIPE ROW (v_detail);
         END LOOP;
      END LOOP;

      RETURN;
   END get_ri_amount;
   
   -- marco
   -- added function below for matrix
   
   FUNCTION get_giclr206l_main(
      p_paid_date          NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_amt                VARCHAR2,
      p_intm_break         NUMBER,
      p_iss_break          NUMBER,
      p_subline_break      NUMBER
   )
     RETURN giclr206l_main_tab PIPELINED
   IS
      v_row                giclr206l_main_type;
      v_treaty_tab         treaty_tab;
      v_index              NUMBER;
      v_id                 NUMBER;
   BEGIN
      FOR i IN (SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                                a.iss_cd, a.buss_source, a.line_cd,
                                a.subline_cd, a.loss_year
                           FROM GICL_RES_BRDRX_EXTR a,
                                GIIS_INTERMEDIARY b
                          WHERE a.buss_source = b.intm_no(+)
                            AND a.session_id = p_session_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND NVL (a.losses_paid, 0) <> 0
                            AND a.buss_source IS NOT NULL
                          ORDER BY DECODE (a.iss_cd, 'RI', 'RI', b.intm_type), a.buss_source, a.iss_cd, a.line_cd, a.subline_cd, a.loss_year)
      LOOP
         v_row := NULL;
         v_row.iss_type := i.iss_type;
         v_row.buss_source_type := i.buss_source_type;
         v_row.iss_cd := i.iss_cd;
         v_row.buss_source := i.buss_source;
         v_row.line_cd := i.line_cd;
         v_row.subline_cd := i.subline_cd;
         v_row.loss_year := i.loss_year;
         
         BEGIN
            SELECT intm_desc
              INTO v_row.buss_source_name
              FROM giis_intm_type
             WHERE intm_type = i.buss_source_type;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_row.buss_source_name := 'REINSURER ';
            WHEN OTHERS THEN
               v_row.buss_source_name := NULL;
         END;

         IF i.iss_type = 'RI' THEN
            BEGIN
               SELECT ri_name
                 INTO v_row.source_name
                 FROM GIIS_REINSURER
                WHERE ri_cd = i.buss_source;
            EXCEPTION
               WHEN OTHERS THEN
                  v_row.source_name := NULL;
            END;
         ELSE
            BEGIN
               SELECT intm_name
                 INTO v_row.source_name
                 FROM GIIS_INTERMEDIARY
                WHERE intm_no = i.buss_source;
            EXCEPTION
               WHEN OTHERS THEN
                  v_row.source_name := NULL;
            END;
         END IF;

         BEGIN
            SELECT iss_name
              INTO v_row.iss_name
              FROM GIIS_ISSOURCE
             WHERE iss_cd = i.iss_cd;
         EXCEPTION
            WHEN OTHERS THEN
               v_row.iss_name := NULL;
         END;

         BEGIN
            SELECT line_name
              INTO v_row.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS THEN
               v_row.line_name := NULL;
         END;

         BEGIN
            SELECT subline_name
              INTO v_row.subline_name
              FROM giis_subline
             WHERE subline_cd = i.subline_cd
             AND line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_row.subline_name := NULL;
         END;
         
         v_id := 0;
         v_index := 0;
         v_treaty_tab := treaty_tab();
         FOR s IN(SELECT DISTINCT grp_seq_no, b.trty_name
                    FROM GICL_RES_BRDRX_DS_EXTR a,
                         GIIS_DIST_SHARE b
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL(p_claim_id, a.claim_id)
                     AND a.buss_source = i.buss_source
                     AND a.iss_cd = i.iss_cd
                     AND a.line_cd = i.line_cd
                     AND a.subline_cd = i.subline_cd
                     AND a.loss_year = i.loss_year
                     AND a.line_cd = b.line_cd
                     AND a.grp_seq_no = b.share_cd
                     AND NVL (a.losses_paid, 0) <> 0
                   ORDER BY A.grp_seq_no)
         LOOP
            v_index := v_index + 1;
            v_treaty_tab.EXTEND;
            v_treaty_tab(v_index).grp_seq_no := s.grp_seq_no;
            v_treaty_tab(v_index).trty_name := s.trty_name;
         END LOOP;
         
         v_index := 1;
         LOOP
            v_id := v_id + 1;
            v_row.dummy := v_id;
            v_row.treaty1 := NULL;
            v_row.treaty2 := NULL;
            v_row.treaty3 := NULL;
            v_row.treaty4 := NULL;
            v_row.grp_seq_no1 := NULL;
            v_row.grp_seq_no2 := NULL;
            v_row.grp_seq_no3 := NULL;
            v_row.grp_seq_no4 := NULL;
            
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
   END;
   
   FUNCTION get_giclr206l_detail(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN giclr206l_detail_tab PIPELINED
   IS
      v_row                giclr206l_detail_type;
   BEGIN
      FOR i IN(SELECT DISTINCT claim_id, claim_no, policy_no, ref_pol_no,
                      incept_date, expiry_date, loss_date, assd_no
                 FROM GICL_RES_BRDRX_EXTR a
                WHERE a.session_id = p_session_id 
                  AND a.claim_id = NVL(p_claim_id, a.claim_id)
                  AND a.buss_source = p_buss_source
                  AND a.iss_cd = p_iss_cd
                  AND a.line_cd = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.loss_year = p_loss_year
                  AND NVL(a.losses_paid, 0) <> 0 
                ORDER BY a.claim_no)
      LOOP
         v_row.claim_id := i.claim_id;
         v_row.claim_no := i.claim_no;
         v_row.policy_no := i.policy_no;
         v_row.ref_pol_no := i.ref_pol_no;
         v_row.incept_date := TO_CHAR(i.incept_date, 'mm-dd-yyyy');
         v_row.expiry_date := TO_CHAR(i.expiry_date, 'mm-dd-yyyy');
         v_row.loss_date := TO_CHAR(i.loss_date, 'mm-dd-yyyy');
         v_row.assd_no := i.assd_no;
         
         BEGIN
            SELECT assd_name
              INTO v_row.assd_name
              FROM GIIS_ASSURED
             WHERE assd_no = i.assd_no;
         EXCEPTION
            WHEN OTHERS THEN
               v_row.assd_name := NULL;
         END;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr206l_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_claim_no           GICL_RES_BRDRX_EXTR.claim_no%TYPE
   )
     RETURN giclr206l_item_tab PIPELINED
   IS
      v_row                giclr206l_item_type;
   BEGIN
      FOR i IN(SELECT DISTINCT policy_no, claim_id, claim_no, item_no, grouped_item_no, line_cd
                 FROM GICL_RES_BRDRX_EXTR a
                WHERE a.session_id = p_session_id
                  AND a.claim_id = NVL (p_claim_id, a.claim_id)
                  AND a.buss_source = p_buss_source
                  AND a.iss_cd = p_iss_cd
                  AND a.line_cd = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.loss_year = p_loss_year
                  AND a.claim_no = p_claim_no
                  AND NVL (a.losses_paid, 0) <> 0
                ORDER BY a.claim_no)
      LOOP
         v_row.policy_no := i.policy_no;
         v_row.claim_id := i.claim_id;
         v_row.claim_no := i.claim_no;
         v_row.item_no := i.item_no;
         v_row.grouped_item_no := i.grouped_item_no;
         v_row.item_title :=  get_gpa_item_title (i.claim_id, i.line_cd, i.item_no, NVL(i.grouped_item_no, 0));
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr206l_peril(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_claim_no           GICL_RES_BRDRX_EXTR.claim_no%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_grouped_item_no    GICL_RES_BRDRX_EXTR.grouped_item_no%TYPE,
      p_intm_break         NUMBER,
      p_paid_date          NUMBER,
      p_from_date          DATE,
      p_to_date            DATE
   )
     RETURN giclr206l_peril_tab PIPELINED
   IS
      v_row                giclr206l_peril_type;
   BEGIN
      FOR i IN(SELECT a.tsi_amt, a.peril_cd, b.peril_name, a.intm_no,
                      NVL(a.losses_paid, 0) paid_losses, a.brdrx_record_id --added by gab 03.21.2016 SR 21796
                 FROM GICL_RES_BRDRX_EXTR a,
                      GIIS_PERIL b
                WHERE a.session_id = p_session_id
                  AND a.claim_id = NVL (p_claim_id, a.claim_id)
                  AND a.buss_source = p_buss_source
                  AND a.iss_cd = p_iss_cd
                  AND a.line_cd = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.loss_year = p_loss_year
                  AND a.claim_no = p_claim_no
                  AND a.item_no = p_item_no
                  AND NVL (a.losses_paid, 0) <> 0
                  AND a.line_cd = b.line_cd
                  AND a.peril_cd = b.peril_cd
                ORDER BY a.claim_no)
      LOOP
         v_row.tsi_amt := i.tsi_amt;
         v_row.peril_cd := i.peril_cd;
         v_row.peril_name := i.peril_name;
         v_row.intm_cedant := GICLR206E_PKG.intm_ri_formula(p_claim_id, p_session_id, p_item_no, i.peril_cd, i.intm_no, p_intm_break);
         v_row.dv_no := GICLS202_PKG.get_voucher_check_no(p_claim_id, p_item_no, i.peril_cd, p_grouped_item_no, p_from_date, p_to_date, p_paid_date, 'L');
         v_row.paid_losses := NVL(i.paid_losses, 0);
         v_row.brdrx_id := i.brdrx_record_id; --added by gab 03.21.2016 SR 21796
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr206l_treaty(
      p_dummy              NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_peril_cd           GICL_RES_BRDRX_EXTR.peril_cd%TYPE,
      p_brdrx_id           VARCHAR2 --added by gab 03.21.2016 SR 21796
   )
     RETURN paid_losses_tab PIPELINED
   IS
      TYPE t_tab IS TABLE OF paid_losses_type INDEX BY PLS_INTEGER;
      v_row                paid_losses_type;
      v_tab                t_tab;
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_index              NUMBER := 0;
   BEGIN
      FOR i IN(SELECT grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                 FROM TABLE(GICLR206L_PKG.get_giclr206l_main(NULL, p_session_id, NULL, NULL, NULL, NULL, NULL))
                WHERE dummy = p_dummy
                  AND buss_source = p_buss_source
                  AND iss_cd = p_iss_cd
                  AND line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND loss_year = p_loss_year)
      LOOP
         FOR c IN 1 .. 4
         LOOP
            IF c = 1 THEN
               v_grp_seq_no := i.grp_seq_no1;
            ELSIF c = 2 THEN
               v_grp_seq_no := i.grp_seq_no2;
            ELSIF c = 3 THEN
               v_grp_seq_no := i.grp_seq_no3;
            ELSIF c = 4 THEN
               v_grp_seq_no := i.grp_seq_no4;
            END IF;
            
            IF v_grp_seq_no IS NULL THEN
               EXIT;
            END IF;
            
            v_index := 1;
            FOR d IN(SELECT a.brdrx_record_id, a.brdrx_ds_record_id, a.grp_seq_no,
                            a.shr_pct, NVL(a.losses_paid,0) paid_losses
                       FROM GICL_RES_BRDRX_DS_EXTR a
                      WHERE a.session_id = p_session_id
                        AND NVL(a.losses_paid, 0) <> 0 
                        AND a.buss_source = p_buss_source
                        AND a.iss_cd = p_iss_cd
                        AND a.line_cd = p_line_cd
                        AND a.subline_cd = p_subline_cd
                        AND a.loss_year = p_loss_year
                        AND a.claim_id = p_claim_id
                        AND a.item_no = p_item_no
                        AND a.brdrx_record_id = p_brdrx_id --added by gab 03.21.2016 SR 21796
                        AND a.grp_seq_no = v_grp_seq_no
                        AND a.peril_cd = p_peril_cd)
            LOOP
               IF c = 1 THEN
                  v_tab(v_index).paid_losses1 := d.paid_losses;
               ELSIF c = 2 THEN
                  v_tab(v_index).paid_losses2 := d.paid_losses;
               ELSIF c = 3 THEN
                  v_tab(v_index).paid_losses3 := d.paid_losses;
               ELSIF c = 4 THEN
                  v_tab(v_index).paid_losses4 := d.paid_losses;
               END IF;
               v_tab(v_index).ds_record_id := d.brdrx_ds_record_id;
               v_index := v_index + 1;
            END LOOP;
         END LOOP;
      END LOOP;
      
      v_index := v_tab.FIRST;
      
      IF v_index IS NULL THEN
         v_row.paid_losses1 := 0.00;
         v_row.paid_losses2 := 0.00;
         v_row.paid_losses3 := 0.00;
         v_row.paid_losses4 := 0.00;
         PIPE ROW(v_row);
      END IF;
      
      WHILE v_index IS NOT NULL      
      LOOP
         v_row := NULL;
         v_row.paid_losses1 := NVL(v_tab(v_index).paid_losses1, 0.00);
         v_row.paid_losses2 := NVL(v_tab(v_index).paid_losses2, 0.00);
         v_row.paid_losses3 := NVL(v_tab(v_index).paid_losses3, 0.00);
         v_row.paid_losses4 := NVL(v_tab(v_index).paid_losses4, 0.00);
         v_row.ds_record_id := v_tab(v_index).ds_record_id;
         PIPE ROW(v_row);
         v_index := v_tab.NEXT(v_index);
      END LOOP;
   END;
   
   FUNCTION get_giclr206l_facul(
      p_dummy              NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_ds_record_id       GICL_RES_BRDRX_RIDS_EXTR.brdrx_ds_record_id%TYPE
   )
     RETURN facul_tab PIPELINED
   IS
      v_row                facul_type;
      v_ri_sname           GIIS_REINSURER.ri_sname%TYPE;
   BEGIN
      FOR i IN(SELECT grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                 FROM TABLE(GICLR206L_PKG.get_giclr206l_main(NULL, p_session_id, NULL, NULL, NULL, NULL, NULL))
                WHERE dummy = p_dummy
                  AND buss_source = p_buss_source
                  AND iss_cd = p_iss_cd
                  AND line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND loss_year = p_loss_year)
      LOOP
         FOR f IN(SELECT a.brdrx_ds_record_id,
                         DECODE(a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) facul_ri_cd,
                         SUM(a.shr_ri_pct) facul_shr_ri_pct,
                         SUM(NVL(a.losses_paid, 0)) paid_losses
                    FROM GICL_RES_BRDRX_RIDS_EXTR a
                   WHERE a.grp_seq_no IN (i.grp_seq_no1, i.grp_seq_no2, i.grp_seq_no3, i.grp_seq_no4)
                     AND a.grp_seq_no = 999
                     AND a.session_id = p_session_id
                     AND a.brdrx_ds_record_id = p_ds_record_id
                   GROUP BY a.brdrx_ds_record_id, DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
         LOOP
            v_row := NULL;
            
            FOR n IN(SELECT ri_sname
                       FROM GIIS_REINSURER
                      WHERE f.facul_ri_cd = ri_cd)
            LOOP
               v_ri_sname := n.ri_sname;
               EXIT;
            END LOOP;
            
            IF i.grp_seq_no1 = 999 THEN
               v_row.ri_name1 := v_ri_sname;
               v_row.paid_losses1 := f.paid_losses;
            ELSIF i.grp_seq_no2 = 999 THEN
               v_row.ri_name2 := v_ri_sname;
               v_row.paid_losses2 := f.paid_losses;
            ELSIF i.grp_seq_no3 = 999 THEN
               v_row.ri_name3 := v_ri_sname;
               v_row.paid_losses3 := f.paid_losses;
            ELSIF i.grp_seq_no4 = 999 THEN
               v_row.ri_name4 :=v_ri_sname;
               v_row.paid_losses4 := f.paid_losses;
            END IF;
            
            PIPE ROW(v_row);
         END LOOP;
      END LOOP;
   END;
   
   FUNCTION get_giclr206l_treaty_total(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE
   )
     RETURN paid_losses_tab PIPELINED
   IS
      v_row                paid_losses_type;
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_query              VARCHAR2(5000);
   BEGIN
      FOR i IN 1 .. 4
      LOOP
         IF i = 1 THEN
            v_grp_seq_no := p_grp_seq_no1;
         ELSIF i = 2 THEN
            v_grp_seq_no := p_grp_seq_no2;
         ELSIF i = 3 THEN
            v_grp_seq_no := p_grp_seq_no3;
         ELSIF i = 4 THEN
            v_grp_seq_no := p_grp_seq_no4;
         END IF;
      
         FOR s IN(SELECT SUM(NVL(a.losses_paid, 0)) paid_losses
                    FROM GICL_RES_BRDRX_DS_EXTR a
                   WHERE a.session_id = p_session_id
                     AND NVL(a.losses_paid, 0) <> 0 
                     AND a.buss_source = p_buss_source
                     AND a.iss_cd = p_iss_cd
                     AND a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.loss_year = p_loss_year
                     AND a.grp_seq_no = v_grp_seq_no)
         LOOP
            IF i = 1 THEN
               v_row.paid_losses1 := s.paid_losses;
            ELSIF i = 2 THEN
               v_row.paid_losses2 := s.paid_losses;
            ELSIF i = 3 THEN
               v_row.paid_losses3 := s.paid_losses;
            ELSIF i = 4 THEN
               v_row.paid_losses4 := s.paid_losses;
            END IF;
         END LOOP;
      END LOOP;
      
      PIPE ROW(v_row);
   END;
   
   FUNCTION get_giclr206l_treaty_ri(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN treaty_ri_tab PIPELINED
   IS
      v_row                treaty_ri_type;
   BEGIN
      FOR i IN(SELECT a.brdrx_rids_record_id, a.iss_cd, a.buss_source, a.line_cd,
                      a.subline_cd, a.loss_year, a.grp_seq_no,
                      DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) trty_ri_cd,
                      a.ri_cd, a.shr_ri_pct, b.trty_shr_pct,
                      NVL(a.losses_paid, 0) paid_losses
                 FROM GICL_RES_BRDRX_RIDS_EXTR a,
                      GIIS_TRTY_PANEL b
                WHERE a.grp_seq_no <> 999
                  AND a.session_id = p_session_id
                  AND a.buss_source = p_buss_source
                  AND a.iss_cd = p_iss_cd
                  AND a.line_cd = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.loss_year = p_loss_year
                  AND a.line_cd = b.line_cd
                  AND a.grp_seq_no = b.trty_seq_no
                  AND a.ri_cd = b.ri_cd
                  AND NVL (a.losses_paid, 0) <> 0
                ORDER BY a.grp_seq_no, DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
      LOOP
         v_row.trty_shr_pct := i.trty_shr_pct;
         v_row.paid_losses := i.paid_losses;
         v_row.grp_seq_no := i.grp_seq_no;
         v_row.ri_cd := i.ri_cd;
         
         BEGIN
            SELECT trty_name
              INTO v_row.treaty_name
              FROM GIIS_DIST_SHARE
             WHERE share_cd = i.grp_seq_no
               AND line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS THEN
               v_row.treaty_name := NULL;
         END;
         
         BEGIN
            SELECT ri_sname
              INTO v_row.ri_name
              FROM GIIS_REINSURER
             WHERE ri_cd = i.ri_cd ;
         EXCEPTION
            WHEN OTHERS THEN
               v_row.ri_name := NULL;
         END;
      
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr206l_totals(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source_type   VARCHAR2,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN NUMBER
   IS
      v_total              GICL_RES_BRDRX_EXTR.losses_paid%TYPE;
   BEGIN
      SELECT SUM(NVL(a.losses_paid,0)) paid_losses
        INTO v_total
        FROM GICL_RES_BRDRX_EXTR a,
             GIIS_INTERMEDIARY b
       WHERE a.buss_source = b.intm_no(+)
         AND a.session_id = p_session_id
         AND ((DECODE(a.iss_cd, 'RI', 'RI', b.intm_type) IS NULL)
          OR (DECODE(a.iss_cd, 'RI', 'RI', b.intm_type) LIKE NVL(p_buss_source_type, '%')))
         AND a.buss_source LIKE NVL(p_buss_source, '%')
         AND a.iss_cd LIKE NVL(p_iss_cd, '%')
         AND a.line_cd LIKE NVL(p_line_cd, '%')
         AND NVL (a.losses_paid, 0) <> 0;
         
      RETURN v_total;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN 0;
   END;
   
END giclr206l_pkg;
/


