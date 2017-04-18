CREATE OR REPLACE PACKAGE BODY CPI.giclr206er_pkg
AS
   FUNCTION get_giclr_206er_report (
      p_amt             VARCHAR2,
      p_claim_id        NUMBER,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_intm_break      NUMBER,
      p_iss_break       NUMBER,
      p_subline_break   NUMBER,
      p_paid_date       VARCHAR2,
      p_session_id      VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list         report_type;
      v_loss         NUMBER;
      v_dv_no        VARCHAR2 (100);
      var_dv_no      VARCHAR2 (500);
      v_ref_pol_no   gipi_polbasic.ref_pol_no%TYPE;
      v_exist        VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN (SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                                DECODE (a.iss_cd,
                                        'RI', 'RI',
                                        b.intm_type
                                       ) buss_source_type,
                                a.iss_cd, a.buss_source, a.line_cd,
                                a.subline_cd, a.loss_year, a.claim_id,
                                a.policy_no, a.assd_no, a.item_no,
                                a.grouped_item_no, a.peril_cd, a.intm_no,
                                NVL (a.expenses_paid, 0) paid_losses,
                                a.clm_loss_id, a.claim_no, a.incept_date,
                                a.expiry_date, a.loss_date, a.tsi_amt,
                                a.brdrx_record_id
                           FROM gicl_res_brdrx_extr a, giis_intermediary b
                          WHERE a.buss_source = b.intm_no(+)
                            AND a.session_id = p_session_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND NVL (a.expenses_paid, 0) <> 0
                       ORDER BY a.iss_cd, a.line_cd, a.subline_cd,
                                a.loss_year)
      LOOP
         v_list.intm_no := NVL (LTRIM (TO_CHAR (i.intm_no, '0009')), ' ');
         v_list.brdrx_record_id := i.brdrx_record_id;
         v_list.iss_type := i.iss_type;
         v_list.claim_no := i.claim_no;
         v_list.claim_id := i.claim_id;
         v_list.buss_source_type := i.buss_source_type;
         v_list.iss_cd := i.iss_cd;
         v_list.buss_source := i.buss_source;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.loss_year := i.loss_year;
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         v_list.item_name :=
            get_gpa_item_title (i.claim_id,
                                i.line_cd,
                                i.item_no,
                                NVL (i.grouped_item_no, 0)
                               );
         v_list.incept_date := i.incept_date;
         v_list.expiry_date := i.expiry_date;
         v_list.loss_date := i.loss_date;
         v_list.tsi_amt := i.tsi_amt;

         BEGIN
            SELECT report_title
              INTO v_list.report_title
              FROM giis_reports
             WHERE report_id = 'GICLR206E';
         END;

         BEGIN
            SELECT DECODE (p_paid_date,
                           1, 'Transaction Date',
                           2, 'Posting Date'
                          )
              INTO v_list.date_title
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.date_title := NULL;
         END;

         BEGIN
            SELECT    'from '
                   || TO_CHAR (TO_DATE (p_from_date, 'mm-dd-yyyy'),
                               'fmMonth DD, YYYY'
                              )
                   || ' to '
                   || TO_CHAR (TO_DATE (p_to_date, 'mm-dd-yyyy'),
                               'fmMonth DD, YYYY'
                              )
              INTO v_list.date_sw
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.date_sw := NULL;
         END;

         BEGIN
            SELECT intm_desc
              INTO v_list.intm_name
              FROM giis_intm_type
             WHERE intm_type = i.buss_source_type;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.intm_name := 'REINSURER ';
            WHEN OTHERS
            THEN
               v_list.intm_name := NULL;
         END;

         BEGIN
            IF i.iss_type = 'RI'
            THEN
               BEGIN
                  SELECT ri_name
                    INTO v_list.source_name
                    FROM giis_reinsurer
                   WHERE ri_cd = i.buss_source;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     v_list.source_name := NULL;
               END;
            ELSE
               BEGIN
                  SELECT intm_name
                    INTO v_list.source_name
                    FROM giis_intermediary
                   WHERE intm_no = i.buss_source;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     v_list.source_name := NULL;
               END;
            END IF;
         END;

         BEGIN
            SELECT iss_name
              INTO v_list.iss_name
              FROM giis_issource
             WHERE iss_cd = i.iss_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.iss_name := NULL;
         END;

         BEGIN
            SELECT line_name
              INTO v_list.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.line_name := NULL;
         END;

         BEGIN
            SELECT subline_name
              INTO v_list.subline_name
              FROM giis_subline
             WHERE subline_cd = i.subline_cd AND line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.subline_name := NULL;
         END;

         BEGIN
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
                  AND a.claim_id = i.claim_id
                  AND ref_pol_no IS NOT NULL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ref_pol_no := NULL;
            END;

            IF v_ref_pol_no IS NOT NULL
            THEN
               v_list.policy_number :=
                                i.policy_no || '/' || CHR (10)
                                || v_ref_pol_no;
            ELSE
               v_list.policy_number := i.policy_no;
            END IF;
         END;

         BEGIN
            SELECT assd_name
              INTO v_list.assd_name
              FROM giis_assured
             WHERE assd_no = i.assd_no;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.assd_name := NULL;
         END;

         BEGIN
            SELECT peril_name
              INTO v_list.loss_cat_des
              FROM giis_peril
             WHERE peril_cd = i.peril_cd AND line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.loss_cat_des := NULL;
         END;

         BEGIN
            SELECT pol_iss_cd
              INTO v_list.pol_iss_cd
              FROM gicl_claims
             WHERE claim_id = i.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.pol_iss_cd := NULL;
         END;

         IF v_list.pol_iss_cd = giacp.v ('RI_ISS_CD')
         THEN
            BEGIN
               FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                           FROM gicl_claims a, giis_reinsurer b
                          WHERE a.ri_cd = b.ri_cd AND a.claim_id = i.claim_id)
               LOOP
                  v_list.intm_ri := TO_CHAR (r.ri_cd) || '/' || r.ri_name;
               END LOOP;
            END;
         ELSE
            IF p_intm_break = 1
            THEN
               BEGIN
                  FOR j IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                                   b.ref_intm_cd ref_intm_cd
                              FROM gicl_res_brdrx_extr a,
                                   giis_intermediary b
                             WHERE a.intm_no = b.intm_no
                               AND a.session_id = p_session_id
                               AND a.claim_id = i.claim_id
                               AND a.item_no = i.item_no
                               AND a.peril_cd = i.peril_cd
                               AND a.intm_no = i.intm_no)
                  LOOP
                     v_list.intm_ri :=
                           TO_CHAR (j.intm_no)
                        || '/'
                        || j.ref_intm_cd
                        || '/'
                        || j.intm_name;
                  END LOOP;
               END;
            ELSIF p_intm_break = 0
            THEN
               BEGIN
                  FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                              FROM gicl_intm_itmperil a, giis_intermediary b
                             WHERE a.intm_no = b.intm_no
                               AND a.claim_id = i.claim_id
                               AND a.item_no = i.item_no
                               AND a.peril_cd = i.peril_cd)
                  LOOP
                     v_list.intm_ri :=
                           TO_CHAR (m.intm_no)
                        || '/'
                        || m.ref_intm_cd
                        || '/'
                        || m.intm_name
                        || CHR (10);
                  END LOOP;
               END;
            END IF;
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
                               HAVING SUM (NVL (a.expenses_paid, 0)) > 0)
                  LOOP
                     v_dv_no :=
                        v1.dv_no || CHR (10) || 'cancelled '
                        || v1.cancel_date;

                     IF var_dv_no IS NULL
                     THEN
                        v_list.dv_no := v_dv_no;
                     ELSE
                        v_list.dv_no := v_dv_no || CHR (10) || var_dv_no;
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
                                             ) BETWEEN (TO_DATE (p_from_date,
                                                                 'mm-dd-yyyy'
                                                                )
                                                       )
                                                   AND (TO_DATE (p_to_date,
                                                                 'mm-dd-yyyy'
                                                                )
                                                       )
                             GROUP BY b.dv_pref, b.dv_no, e.check_no
                               HAVING SUM (NVL (a.expenses_paid, 0)) > 0)
                  LOOP
                     v_dv_no := v2.dv_no;

                     IF var_dv_no IS NULL
                     THEN
                        v_list.dv_no := v_dv_no;
                     ELSE
                        v_list.dv_no := v_dv_no || CHR (10) || var_dv_no;
                     END IF;
                  END LOOP;
               END IF;
            END LOOP;
         END;

         BEGIN
            v_list.pd_loss := i.paid_losses;

            FOR z IN (SELECT recovered_amt rec_amt
                        FROM gicl_rcvry_brdrx_extr
                       WHERE session_id = p_session_id
                         AND claim_id = NVL (i.claim_id, claim_id)
                         AND peril_cd = i.peril_cd
                         AND payee_type = 'E')
            LOOP
               IF NVL (z.rec_amt, 0) != 0
               THEN
                  v_list.pd_loss := v_list.pd_loss - z.rec_amt;
               END IF;
            END LOOP;
         END;
         
         v_exist := 'Y';
         v_list.exist := 'Y';
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_exist = 'N' THEN
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');

         BEGIN
            SELECT report_title
              INTO v_list.report_title
              FROM giis_reports
             WHERE report_id = 'GICLR206E';
         END;

         BEGIN
            SELECT DECODE (p_paid_date,
                           1, 'Transaction Date',
                           2, 'Posting Date'
                          )
              INTO v_list.date_title
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.date_title := NULL;
         END;

         BEGIN
            SELECT    'from '
                   || TO_CHAR (TO_DATE (p_from_date, 'mm-dd-yyyy'),
                               'fmMonth DD, YYYY'
                              )
                   || ' to '
                   || TO_CHAR (TO_DATE (p_to_date, 'mm-dd-yyyy'),
                               'fmMonth DD, YYYY'
                              )
              INTO v_list.date_sw
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.date_sw := NULL;
         END;
         
         v_list.exist := 'N';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_giclr_206er_report;

   FUNCTION get_giclr206er_treaty_detail (
      p_session_id        VARCHAR2,
      p_claim_id          NUMBER,
      p_buss_source       gicl_res_brdrx_ds_extr.buss_source%TYPE,
      p_iss_cd            gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_line_cd           gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_loss_year         gicl_res_brdrx_ds_extr.loss_year%TYPE,
      p_brdrx_record_id   gicl_res_brdrx_ds_extr.brdrx_record_id%TYPE,
      p_subline_cd        gicl_res_brdrx_ds_extr.subline_cd%TYPE
   )
      RETURN giclr206er_detail_tab PIPELINED
   IS
      v_detail   giclr206er_detail_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.iss_cd, a.buss_source, a.line_cd,
                                a.subline_cd, a.loss_year,
                                a.brdrx_record_id
                           FROM gicl_res_brdrx_ds_extr a
                          WHERE a.session_id = p_session_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND a.buss_source = p_buss_source
                            AND a.iss_cd = p_iss_cd
                            AND a.line_cd = p_line_cd
                            AND a.loss_year = p_loss_year
                            AND a.subline_cd = p_subline_cd
                            AND a.brdrx_record_id =
                                   NVL (p_brdrx_record_id, a.brdrx_record_id)
                    )
      LOOP
         FOR f IN (SELECT DISTINCT a.grp_seq_no
                              FROM gicl_res_brdrx_ds_extr a
                             WHERE a.session_id = p_session_id
                               AND a.claim_id = NVL (p_claim_id, a.claim_id)
                               AND a.buss_source = p_buss_source
                               AND a.iss_cd = p_iss_cd
                               AND a.line_cd = p_line_cd
                               AND a.loss_year = p_loss_year
                               AND a.subline_cd = p_subline_cd
                          ORDER BY a.grp_seq_no)
         LOOP
            v_detail.paid_losses := NULL;
            v_detail.brdrx_record_id := NULL;
            v_detail.grp_seq_no := f.grp_seq_no;

            BEGIN
               SELECT trty_name
                 INTO v_detail.treaty_name
                 FROM giis_dist_share
                WHERE share_cd = f.grp_seq_no AND line_cd = i.line_cd;
            EXCEPTION
               WHEN OTHERS
               THEN
                  v_detail.treaty_name := NULL;
            END;

            FOR j IN (SELECT   a.brdrx_record_id, a.buss_source, a.iss_cd,
                               a.line_cd, a.subline_cd, a.loss_year,
                               a.claim_id, a.assd_no, a.claim_no, a.policy_no,
                               a.incept_date, a.expiry_date, a.loss_date,
                               a.clm_file_date, a.item_no, a.grouped_item_no,
                               a.peril_cd, a.loss_cat_cd, a.tsi_amt,
                               a.intm_no, a.clm_loss_id,
                               NVL (a.expenses_paid, 0) paid_losses
                          FROM gicl_res_brdrx_extr a
                         WHERE a.session_id = p_session_id
                           AND a.claim_id = NVL (p_claim_id, a.claim_id)
                           AND NVL (a.expenses_paid, 0) <> 0
                           AND a.buss_source = p_buss_source
                           AND a.iss_cd = p_iss_cd
                           AND a.line_cd = p_line_cd
                           AND a.loss_year = p_loss_year
                           AND a.subline_cd = p_subline_cd  
                           AND a.brdrx_record_id = i.brdrx_record_id               
                      ORDER BY a.claim_no)
            LOOP
               FOR k IN (SELECT a.brdrx_record_id, a.brdrx_ds_record_id,
                                a.grp_seq_no, a.shr_pct,
                                NVL (a.expenses_paid, 0) paid_losses,
                                a.claim_id, a.item_no, a.peril_cd
                           FROM gicl_res_brdrx_ds_extr a
                          WHERE a.session_id = p_session_id
                            AND NVL (a.expenses_paid, 0) <> 0
                            AND a.grp_seq_no = f.grp_seq_no
                            AND a.brdrx_record_id = j.brdrx_record_id)
               LOOP
                  v_detail.brdrx_record_id :=k.brdrx_record_id;
                  v_detail.paid_losses := k.paid_losses;

                  BEGIN
                     FOR i2 IN (SELECT SUM (shr_recovery_amt) rec_amt
                                  FROM gicl_rcvry_brdrx_ds_extr
                                 WHERE session_id = p_session_id
                                   AND claim_id = k.claim_id
                                   AND item_no = k.item_no
                                   AND peril_cd = k.peril_cd
                                   AND grp_seq_no = k.grp_seq_no
                                   AND payee_type = 'E')
                     LOOP
                        IF NVL (i2.rec_amt, 0) != 0
                        THEN
                           v_detail.paid_losses :=
                                            v_detail.paid_losses - i2.rec_amt;
                        END IF;
                     END LOOP;

                     FOR l IN (SELECT   a.brdrx_ds_record_id,
                                        DECODE (a.prnt_ri_cd,
                                                NULL, a.ri_cd,
                                                a.prnt_ri_cd
                                               ) facul_ri_cd,
                                        SUM (a.shr_ri_pct) facul_shr_ri_pct,
                                        SUM
                                           (NVL (a.expenses_paid, 0)
                                           ) paid_losses,
                                        claim_id, item_no, peril_cd
                                   FROM gicl_res_brdrx_rids_extr a
                                  WHERE a.grp_seq_no = 999
                                    AND a.session_id = p_session_id
                                    AND a.brdrx_ds_record_id =
                                                          k.brdrx_ds_record_id
                               GROUP BY a.brdrx_ds_record_id,
                                        DECODE (a.prnt_ri_cd,
                                                NULL, a.ri_cd,
                                                a.prnt_ri_cd
                                               ),
                                        claim_id,
                                        item_no,
                                        peril_cd)
                     LOOP
                        BEGIN
                           SELECT NVL (ri_sname, NULL)
                             INTO v_detail.ri_name
                             FROM giis_reinsurer
                            WHERE ri_cd = l.facul_ri_cd;
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              v_detail.ri_name := NULL;
                        END;

                        BEGIN
                           v_detail.paid_losses3 := l.paid_losses;

                           FOR i3 IN
                              (SELECT SUM (shr_ri_recovery_amt) rec_amt
                                 FROM gicl_rcvry_brdrx_rids_extr
                                WHERE session_id = p_session_id
                                  AND claim_id = NVL (l.claim_id, claim_id)
                                  AND item_no = l.item_no
                                  AND peril_cd = l.peril_cd
                                  AND grp_seq_no = 999
                                  AND ri_cd = l.facul_ri_cd
                                  AND payee_type = 'E')
                           LOOP
                              IF NVL (i3.rec_amt, 0) != 0
                              THEN
                                 v_detail.paid_losses3 :=
                                           v_detail.paid_losses3 - i3.rec_amt;
                              END IF;
                           END LOOP;
                        END;
                        
                     END LOOP;
                  END;
                  --PIPE ROW (v_detail);
               END LOOP;

               PIPE ROW (v_detail);
            END LOOP;
         END LOOP;
      END LOOP;
   END get_giclr206er_treaty_detail;

   FUNCTION get_giclr_206er_treaty (
      p_claim_id      NUMBER,
      p_session_id    VARCHAR2,
      p_iss_cd        gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_loss_year     gicl_res_brdrx_ds_extr.loss_year%TYPE,
      p_buss_source   gicl_res_brdrx_ds_extr.buss_source%TYPE
   )
      RETURN giclr206er_treaty_tab PIPELINED
   IS
      v_list   giclr206er_treaty_type;
   BEGIN
      FOR i IN (SELECT   a.brdrx_rids_record_id, a.iss_cd, a.buss_source,
                         a.line_cd, a.subline_cd, a.loss_year, a.grp_seq_no,
                         DECODE (a.prnt_ri_cd,
                                 NULL, a.ri_cd,
                                 a.prnt_ri_cd
                                ) trty_ri_cd,
                         a.ri_cd, a.shr_ri_pct, b.trty_shr_pct
                    FROM gicl_res_brdrx_rids_extr a, giis_trty_panel b
                   WHERE a.grp_seq_no NOT IN (1, 999)
                     AND a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND a.line_cd = b.line_cd
                     AND a.grp_seq_no = b.trty_seq_no
                     AND a.ri_cd = b.ri_cd
                     AND NVL (a.expenses_paid, 0) <> 0
                     AND a.buss_source = p_buss_source
                     AND a.iss_cd = p_iss_cd
                     AND a.line_cd = p_line_cd
                     AND a.loss_year = p_loss_year
                ORDER BY a.grp_seq_no,
                         DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
      LOOP
         v_list.trty_shr_pct := NULL;
         v_list.trty_shr_pct := i.trty_shr_pct;
         v_list.iss_cd := i.iss_cd;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.loss_year := i.loss_year;
         v_list.buss_source := i.buss_source;
         v_list.ri_cd := i.ri_cd;
         v_list.grp_seq_no := i.grp_seq_no;

         BEGIN
            SELECT trty_name
              INTO v_list.treaty_name
              FROM giis_dist_share
             WHERE share_cd = i.grp_seq_no AND line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.treaty_name := NULL;
         END;

         BEGIN
            SELECT ri_sname
              INTO v_list.trty_ri_name
              FROM giis_reinsurer
             WHERE ri_cd = i.ri_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.trty_ri_name := NULL;
         END;

         PIPE ROW (v_list);
      END LOOP;
   END get_giclr_206er_treaty;

   FUNCTION get_giclr_206er_share (
      p_claim_id      NUMBER,
      p_session_id    VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_loss_year     gicl_res_brdrx_extr.loss_year%TYPE,
      p_buss_source   gicl_res_brdrx_extr.buss_source%TYPE,
      p_ri_cd         gicl_res_brdrx_rids_extr.ri_cd%TYPE
   )
      RETURN giclr206er_share_tab PIPELINED
   IS
      v_list   giclr206er_share_type;
   BEGIN
      FOR i IN (SELECT   a.brdrx_rids_record_id, a.iss_cd, a.buss_source,
                         a.item_no, a.peril_cd, a.line_cd, a.subline_cd,
                         a.loss_year, a.grp_seq_no,
                         DECODE (a.prnt_ri_cd,
                                 NULL, a.ri_cd,
                                 a.prnt_ri_cd
                                ) trty_ri_cd,
                         a.ri_cd, a.shr_ri_pct, b.trty_shr_pct, a.claim_id
                    FROM gicl_res_brdrx_rids_extr a, giis_trty_panel b
                   WHERE a.grp_seq_no NOT IN (1, 999)
                     AND a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND a.line_cd = b.line_cd
                     AND a.grp_seq_no = b.trty_seq_no
                     AND a.ri_cd = b.ri_cd
                     AND NVL (a.expenses_paid, 0) <> 0
                     AND a.buss_source = p_buss_source
                     AND a.iss_cd = p_iss_cd
                     AND a.line_cd = p_line_cd
                     AND a.loss_year = p_loss_year
                     AND a.subline_cd = p_subline_cd
                ORDER BY a.grp_seq_no,
                         DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
      LOOP
         BEGIN
            SELECT trty_name
              INTO v_list.treaty_name
              FROM giis_dist_share
             WHERE share_cd = i.grp_seq_no AND line_cd = i.line_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.treaty_name := NULL;
         END;

         BEGIN
            SELECT ri_sname
              INTO v_list.trty_ri_name
              FROM giis_reinsurer
             WHERE ri_cd = i.ri_cd;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_list.trty_ri_name := NULL;
         END;

         BEGIN
            FOR t IN (SELECT DISTINCT a.iss_cd, a.buss_source, a.line_cd,
                                      a.subline_cd, a.loss_year,
                                      a.grp_seq_no
                                 FROM gicl_res_brdrx_ds_extr a
                                WHERE a.grp_seq_no NOT IN (1, 999)
                                  AND a.session_id = p_session_id
                                  AND a.claim_id =
                                                  NVL (p_claim_id, a.claim_id)
                                  AND a.buss_source = p_buss_source
                                  AND a.iss_cd = p_iss_cd
                                  AND a.line_cd = p_line_cd
                                  AND a.loss_year = p_loss_year
                                  AND a.subline_cd = p_subline_cd
                             ORDER BY a.grp_seq_no)
            LOOP
               v_list.ri_cd := NULL;
               v_list.ri_cd := i.ri_cd;
               v_list.grp_seq_no := NULL;
               v_list.grp_seq_no := t.grp_seq_no;
               v_list.pd_loss4 := NULL;

               FOR BIG IN (SELECT a.brdrx_rids_record_id, a.grp_seq_no,
                                  NVL (a.expenses_paid, 0) paid_losses,
                                  a.claim_id, a.item_no, a.peril_cd, a.ri_cd
                             FROM gicl_res_brdrx_rids_extr a
                            WHERE a.grp_seq_no <> 999
                              AND a.session_id = p_session_id
                              AND NVL (a.expenses_paid, 0) <> 0
                              AND a.brdrx_rids_record_id =
                                                        i.brdrx_rids_record_id
                              AND a.grp_seq_no = t.grp_seq_no
                              AND a.ri_cd = NVL (p_ri_cd, a.ri_cd))
               LOOP
                  BEGIN
                     v_list.pd_loss4 := BIG.paid_losses;

                     FOR q IN (SELECT SUM (shr_ri_recovery_amt) rec_amt
                                 FROM gicl_rcvry_brdrx_rids_extr
                                WHERE session_id = p_session_id
                                  AND claim_id = NVL (i.claim_id, claim_id)
                                  AND item_no = i.item_no
                                  AND peril_cd = i.peril_cd
                                  AND grp_seq_no = BIG.grp_seq_no
                                  AND ri_cd = i.ri_cd
                                  AND payee_type = 'E')
                     LOOP
                        IF NVL (q.rec_amt, 0) != 0
                        THEN
                           v_list.pd_loss4 := v_list.pd_loss4 - q.rec_amt;
                        END IF;

                        v_list.row_1 := 1;
                     END LOOP;
                  END;
               END LOOP;

               PIPE ROW (v_list);
            END LOOP;
         END;
      END LOOP;
   END get_giclr_206er_share;
   
   -- marco
   -- added functions below for matrix
   
   FUNCTION get_giclr206er_header(
      p_paid_date          NUMBER,
      p_from_date          VARCHAR2,
      p_to_date            VARCHAR2
   )
     RETURN giclr206er_header_tab PIPELINED
   IS
      v_row                giclr206er_header_type;
   BEGIN
      v_row.company_name := giisp.v('COMPANY_NAME');
      v_row.company_address := giisp.v('COMPANY_ADDRESS');
      
      BEGIN
         SELECT report_title
           INTO v_row.report_title
           FROM giis_reports
          WHERE report_id = 'GICLR206E';
      END;

      BEGIN
         SELECT DECODE (p_paid_date,
                        1, 'Transaction Date',
                        2, 'Posting Date'
                       )
           INTO v_row.date_title
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_row.date_title := NULL;
      END;

      BEGIN
         SELECT    'from '
                || TO_CHAR (TO_DATE (p_from_date, 'mm-dd-yyyy'),
                            'fmMonth DD, YYYY'
                           )
                || ' to '
                || TO_CHAR (TO_DATE (p_to_date, 'mm-dd-yyyy'),
                            'fmMonth DD, YYYY'
                           )
           INTO v_row.date_sw
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_row.date_sw := NULL;
      END;
      
      PIPE ROW(v_row);
   END;
   
   FUNCTION get_giclr206er_main(
      p_paid_date          NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_amt                VARCHAR2,
      p_intm_break         NUMBER,
      p_iss_break          NUMBER,
      p_subline_break      NUMBER
   )
     RETURN giclr206er_main_tab PIPELINED
   IS
      v_row                giclr206er_main_type;
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
                            AND NVL (a.expenses_paid, 0) <> 0
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
                     AND NVL (a.expenses_paid, 0) <> 0
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
   
   FUNCTION get_giclr206er_detail(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN giclr206er_detail_tab2 PIPELINED
   IS
      v_row                giclr206er_detail_type2;
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
                  AND NVL(a.expenses_paid, 0) <> 0 
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
   
   FUNCTION get_giclr206er_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_claim_no           GICL_RES_BRDRX_EXTR.claim_no%TYPE
   )
     RETURN giclr206er_item_tab PIPELINED
   IS
      v_row                giclr206er_item_type;
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
                  AND NVL (a.expenses_paid, 0) <> 0
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
   
   FUNCTION get_giclr206er_peril(
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
     RETURN giclr206er_peril_tab PIPELINED
   IS
      v_row                giclr206er_peril_type;
      v_pd_loss            GICL_RES_BRDRX_EXTR.expenses_paid%TYPE;
   BEGIN
      FOR i IN(SELECT a.tsi_amt, a.peril_cd, b.peril_name, a.intm_no,
                      SUM(NVL(c.expenses_paid, 0)) paid_losses
                 FROM GICL_RES_BRDRX_EXTR a,
                      GIIS_PERIL b, GICL_RES_BRDRX_DS_EXTR c
                WHERE a.session_id = p_session_id
                  AND a.claim_id = NVL (p_claim_id, a.claim_id)
                  AND a.buss_source = p_buss_source
                  AND a.iss_cd = p_iss_cd
                  AND a.line_cd = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.loss_year = p_loss_year
                  AND a.claim_no = p_claim_no
                  AND a.item_no = p_item_no
                  AND NVL (c.expenses_paid, 0) <> 0
                  AND a.line_cd = b.line_cd
                  AND a.peril_cd = b.peril_cd
                  AND a.session_id = c.session_id
                  AND a.brdrx_record_id = c.brdrx_record_id
                  GROUP BY a.tsi_amt, a.peril_cd, b.peril_name, a.intm_no
                ORDER BY a.claim_no)
      LOOP
         v_row.tsi_amt := i.tsi_amt;
         v_row.peril_cd := i.peril_cd;
         v_row.peril_name := i.peril_name;
         v_row.intm_cedant := GICLR206E_PKG.intm_ri_formula(p_claim_id, p_session_id, p_item_no, i.peril_cd, i.intm_no, p_intm_break);
         v_row.dv_no := GICLS202_PKG.get_voucher_check_no(p_claim_id, p_item_no, i.peril_cd, p_grouped_item_no, p_from_date, p_to_date, p_paid_date, 'E');
         
         v_pd_loss := i.paid_losses;
         FOR b IN(SELECT recovered_amt rec_amt
                    FROM GICL_RCVRY_BRDRX_EXTR
                   WHERE session_id = p_session_id 
                     AND claim_id = p_claim_id 
                     AND buss_source = p_buss_source
                     AND iss_cd = p_iss_cd
                     AND line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND item_no = p_item_no
                     AND peril_cd = i.peril_cd
                     AND payee_type = 'E')
         LOOP
            IF NVL(b.rec_amt, 0) != 0 THEN
               v_pd_loss := v_pd_loss - b.rec_amt;
            END IF;
         END LOOP;
         v_row.paid_losses := v_pd_loss;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr206er_treaty(
      p_dummy              NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_peril_cd           GICL_RES_BRDRX_EXTR.peril_cd%TYPE
   )
     RETURN paid_losses_tab PIPELINED
   IS
      TYPE t_tab IS TABLE OF paid_losses_type INDEX BY PLS_INTEGER;
      v_row                paid_losses_type;
      v_tab                t_tab;
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_index              NUMBER := 0;
      v_pd_loss            GICL_RES_BRDRX_EXTR.expenses_paid%TYPE;
   BEGIN
      FOR i IN(SELECT grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                 FROM TABLE(GICLR206ER_PKG.get_giclr206er_main(NULL, p_session_id, NULL, NULL, NULL, NULL, NULL))
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
                            a.shr_pct, NVL(a.expenses_paid,0) paid_losses
                       FROM GICL_RES_BRDRX_DS_EXTR a
                      WHERE a.session_id = p_session_id
                        AND NVL(a.expenses_paid, 0) <> 0 
                        AND a.buss_source = p_buss_source
                        AND a.iss_cd = p_iss_cd
                        AND a.line_cd = p_line_cd
                        AND a.subline_cd = p_subline_cd
                        AND a.loss_year = p_loss_year
                        AND a.claim_id = p_claim_id
                        AND a.item_no = p_item_no
                        AND a.grp_seq_no = v_grp_seq_no
                        AND a.peril_cd = p_peril_cd)
            LOOP
               v_pd_loss := d.paid_losses;
               
               FOR b IN(SELECT shr_recovery_amt rec_amt
                          FROM GICL_RCVRY_BRDRX_DS_EXTR
                         WHERE session_id = p_session_id
                           AND claim_id = p_claim_id
                           AND item_no = p_item_no
                           AND peril_cd = p_peril_cd
                           AND grp_seq_no = v_grp_seq_no
                           AND payee_type = 'E')
               LOOP
                  IF NVL(b.rec_amt, 0) != 0 THEN
                     v_pd_loss := v_pd_loss - b.rec_amt;
                  END IF;
               END LOOP;
            
               IF c = 1 THEN
                  v_tab(v_index).paid_losses1 := v_pd_loss;
               ELSIF c = 2 THEN
                  v_tab(v_index).paid_losses2 := v_pd_loss;
               ELSIF c = 3 THEN
                  v_tab(v_index).paid_losses3 := v_pd_loss;
               ELSIF c = 4 THEN
                  v_tab(v_index).paid_losses4 := v_pd_loss;
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
   
   FUNCTION get_giclr206er_facul(
      p_dummy              NUMBER,
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_ds_record_id       GICL_RES_BRDRX_RIDS_EXTR.brdrx_ds_record_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_peril_cd           GICL_RES_BRDRX_EXTR.peril_cd%TYPE
   )
     RETURN facul_tab PIPELINED
   IS
      v_row                facul_type;
      v_ri_sname           GIIS_REINSURER.ri_sname%TYPE;
      v_pd_loss            GICL_RES_BRDRX_EXTR.expenses_paid%TYPE;
   BEGIN
      FOR i IN(SELECT grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                 FROM TABLE(GICLR206ER_PKG.get_giclr206er_main(NULL, p_session_id, NULL, NULL, NULL, NULL, NULL))
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
                         SUM(NVL(a.expenses_paid, 0)) paid_losses
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
            
            v_pd_loss := f.paid_losses;
            FOR b IN(SELECT shr_ri_recovery_amt ri_rec_amt
                       FROM gicl_rcvry_brdrx_rids_extr
                      WHERE session_id = p_session_id
                        AND claim_id = p_claim_id
                        AND item_no = p_item_no
                        AND peril_cd = p_peril_cd
                        AND ri_cd = f.facul_ri_cd
                        AND grp_seq_no = 999
                        AND payee_type = 'E')
            LOOP
               IF NVL(b.ri_rec_amt, 0) != 0 THEN
                  v_pd_loss := v_pd_loss - b.ri_rec_amt;
  	            END IF;
            END LOOP;
            
            IF i.grp_seq_no1 = 999 THEN
               v_row.ri_name1 := v_ri_sname;
               v_row.paid_losses1 := v_pd_loss;
            ELSIF i.grp_seq_no2 = 999 THEN
               v_row.ri_name2 := v_ri_sname;
               v_row.paid_losses2 := v_pd_loss;
            ELSIF i.grp_seq_no3 = 999 THEN
               v_row.ri_name3 := v_ri_sname;
               v_row.paid_losses3 := v_pd_loss;
            ELSIF i.grp_seq_no4 = 999 THEN
               v_row.ri_name4 :=v_ri_sname;
               v_row.paid_losses4 := v_pd_loss;
            END IF;
            
            PIPE ROW(v_row);
         END LOOP;
      END LOOP;
   END;
   
   FUNCTION get_giclr206er_treaty_total(
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
      v_total_loss         GICL_RES_BRDRX_EXTR.expenses_paid%TYPE := 0;
      v_total_rec          GICL_RCVRY_BRDRX_EXTR.recovered_amt%TYPE := 0;
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
         
         v_total_loss := 0;
         FOR s IN(SELECT a.claim_id, SUM(NVL(a.expenses_paid, 0)) paid_losses
                    FROM GICL_RES_BRDRX_DS_EXTR a
                   WHERE a.session_id = p_session_id
                     AND NVL(a.expenses_paid, 0) <> 0 
                     AND a.buss_source = p_buss_source
                     AND a.iss_cd = p_iss_cd
                     AND a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.loss_year = p_loss_year
                     AND a.grp_seq_no = v_grp_seq_no
                   GROUP BY a.claim_id)
         LOOP
            v_total_loss := v_total_loss + s.paid_losses;
            v_total_rec := 0;
            
            FOR b IN(SELECT SUM(NVL(recovered_amt, 0)) recovered_amt
                       FROM GICL_RCVRY_BRDRX_DS_EXTR
                      WHERE session_id = p_session_id 
                        AND line_cd = p_line_cd
                        AND claim_id = s.claim_id
                        AND grp_seq_no = v_grp_seq_no
                        AND payee_type = 'E')
            LOOP
               v_total_rec := v_total_rec + NVL(b.recovered_amt, 0);
            END LOOP;
            
            v_total_loss := v_total_loss - v_total_rec;
         
            IF i = 1 THEN
               v_row.paid_losses1 := v_total_loss;
            ELSIF i = 2 THEN
               v_row.paid_losses2 := v_total_loss;
            ELSIF i = 3 THEN
               v_row.paid_losses3 := v_total_loss;
            ELSIF i = 4 THEN
               v_row.paid_losses4 := v_total_loss;
            END IF;
         END LOOP;
      END LOOP;
      
      PIPE ROW(v_row);
   END;
   
   FUNCTION get_giclr206er_treaty_ri(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED
   IS
      v_row                treaty_ri_type2;
      v_total_loss         GICL_RES_BRDRX_EXTR.expenses_paid%TYPE := 0;
      v_total_rec          GICL_RCVRY_BRDRX_EXTR.recovered_amt%TYPE := 0;
   BEGIN
      FOR i IN(SELECT a.brdrx_rids_record_id, a.iss_cd, a.buss_source, a.line_cd,
                      a.subline_cd, a.loss_year, a.grp_seq_no,
                      DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) trty_ri_cd,
                      a.ri_cd, a.shr_ri_pct, b.trty_shr_pct,
                      NVL(a.expenses_paid, 0) paid_losses
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
                  AND NVL (a.expenses_paid, 0) <> 0
                ORDER BY a.grp_seq_no, DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
      LOOP
         v_total_rec := 0;
         v_row.trty_shr_pct := i.trty_shr_pct;
         v_total_loss := i.paid_losses;
         v_row.grp_seq_no := i.grp_seq_no;
         v_row.ri_cd := i.ri_cd;
         
         FOR b IN(SELECT NVL(SUM(r.shr_ri_recovery_amt), 0) rec_amt
                    FROM GICL_RCVRY_BRDRX_RIDS_EXTR r
                   WHERE r.session_id = p_session_id
                     AND r.grp_seq_no = i.grp_seq_no
                     AND r.ri_cd = i.ri_cd
                     AND payee_type = 'E')
         LOOP
            v_total_rec := b.rec_amt;
         END LOOP;
         
         v_row.paid_losses := v_total_loss - v_total_rec;
         
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
   
   FUNCTION get_giclr206er_totals(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source_type   VARCHAR2,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE
   )
     RETURN NUMBER
   IS
      v_total_loss         GICL_RES_BRDRX_EXTR.expenses_paid%TYPE;
      v_total_rec          GICL_RCVRY_BRDRX_EXTR.recovered_amt%TYPE;
   BEGIN
      SELECT SUM(NVL(a.expenses_paid,0)) paid_losses
        INTO v_total_loss
        FROM GICL_RES_BRDRX_EXTR a,
             GIIS_INTERMEDIARY b
       WHERE a.buss_source = b.intm_no(+)
         AND a.session_id = p_session_id
         AND ((DECODE(a.iss_cd, 'RI', 'RI', b.intm_type) IS NULL)
          OR (DECODE(a.iss_cd, 'RI', 'RI', b.intm_type) LIKE NVL(p_buss_source_type, '%')))
         AND a.buss_source LIKE NVL(p_buss_source, '%')
         AND a.iss_cd LIKE NVL(p_iss_cd, '%')
         AND a.line_cd LIKE NVL(p_line_cd, '%')
         AND NVL (a.expenses_paid, 0) <> 0;

      SELECT NVL(SUM(recovered_amt), 0) rec_amt
        INTO v_total_rec
        FROM GICL_RCVRY_BRDRX_EXTR
       WHERE session_id = p_session_id 
         AND buss_source LIKE NVL(p_buss_source, '%')
         AND iss_cd LIKE NVL(DECODE(p_iss_cd, 0, '%', p_iss_cd), '%')
         AND line_cd LIKE NVL(p_line_cd, '%')
         AND payee_type = 'E';
         
      RETURN v_total_loss - v_total_rec;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN 0;
   END;
   
   FUNCTION get_giclr206er_total_loss(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN NUMBER
   IS
      v_total_loss         GICL_RES_BRDRX_EXTR.expenses_paid%TYPE := 0;
      v_total_rec          GICL_RCVRY_BRDRX_EXTR.recovered_amt%TYPE := 0;
   BEGIN
      FOR i IN(SELECT a.claim_id, NVL(SUM(b.expenses_paid),0) paid_losses
                 FROM GICL_RES_BRDRX_EXTR a, GICL_RES_BRDRX_DS_EXTR b
                WHERE a.session_id = p_session_id
                  AND a.buss_source = p_buss_source
                  AND a.iss_cd = p_iss_cd
                  AND a.line_cd = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.loss_year = p_loss_year
                  AND NVL(b.expenses_paid, 0) <> 0
                  AND a.session_id = b.session_id
                  AND a.brdrx_record_id = b.brdrx_record_id
                GROUP BY a.claim_id)
      LOOP
         v_total_loss := v_total_loss + i.paid_losses;
         
         FOR b IN(SELECT SUM(NVL(recovered_amt, 0)) recovered_amt
                    FROM GICL_RCVRY_BRDRX_EXTR
                   WHERE session_id = p_session_id 
                     AND line_cd = p_line_cd
                     AND claim_id = i.claim_id
                     AND payee_type = 'E')
         LOOP
            v_total_rec := v_total_rec + NVL(b.recovered_amt, 0);
         END LOOP;
      END LOOP;
      
      RETURN v_total_loss - v_total_rec;
   END;
   
END;
/


