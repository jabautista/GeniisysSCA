CREATE OR REPLACE PACKAGE BODY CPI.GICLR209LR_PKG
AS
   FUNCTION get_giclr209lr_report (
      p_claim_id     NUMBER,
      p_intm_break   NUMBER,
      p_iss_break    NUMBER,
      p_paid_date    VARCHAR2,
      p_session_id   NUMBER,
      p_date_from    VARCHAR2,
      p_date_to      VARCHAR2
   )
      RETURN giclr209lr_tab PIPELINED
   IS
      v_list          giclr209lr_type;
      v_clm_stat      giis_clm_stat.clm_stat_desc%TYPE;
      v_clm_stat1     giis_clm_stat.clm_stat_desc%TYPE;
      var_clm_stat    VARCHAR2 (5000);
      v_tran_date     VARCHAR2 (100);
      var_tran_date   VARCHAR2 (200);
      v_loss          NUMBER;
      v_pd_loss       NUMBER;
      v_share_type    VARCHAR2 (200);
      v_header        BOOLEAN                            := TRUE;
   BEGIN
      v_list.header_flag := 'N';
      v_list.company_name := giisp.v ('COMPANY_NAME');
      v_list.company_address := giisp.v ('COMPANY_ADDRESS');

      IF p_intm_break = 0
      THEN
         v_list.title_sw := 'LOSSES PAID DISTRIBUTION REGISTER - PER BRANCH';
      ELSIF p_intm_break = 1
      THEN
         v_list.title_sw :=
                       'LOSSES PAID DISTRIBUTION REGISTER - PER INTERMEDIARY';
      END IF;

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
                || TO_CHAR (TO_DATE (p_date_from, 'mm-dd-yyyy'),
                            'fmMonth DD, YYYY'
                           )
                || ' to '
                || TO_CHAR (TO_DATE (p_date_to, 'mm-dd-yyyy'),
                            'fmMonth DD, YYYY'
                           )
           INTO v_list.date_sw
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.date_sw := NULL;
      END;

      FOR i IN (SELECT   a.brdrx_record_id, a.buss_source, a.iss_cd,
                         a.line_cd, a.subline_cd, a.claim_id, a.assd_no,
                         a.claim_no, a.policy_no, a.clm_file_date,
                         a.loss_date, a.loss_cat_cd, a.item_no,
                         a.grouped_item_no, a.peril_cd, a.intm_no,
                         a.clm_loss_id, NVL (a.tsi_amt, 0) tsi_amt,
                         NVL (a.losses_paid, 0) paid_loss, a.from_date, a.to_date, a.pd_date_opt
                    FROM gicl_res_brdrx_extr a
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND NVL (a.losses_paid, 0) <> 0
                ORDER BY a.intm_no,
                         a.iss_cd,
                         a.line_cd,
                         a.claim_no,
                         a.item_no,
                         a.brdrx_record_id)
      LOOP
         v_header := FALSE;
         v_list.header_flag := 'Y';
         v_list.intm_no := NVL (LTRIM (TO_CHAR (i.intm_no, '0009')), ' ');
         v_list.buss_source := i.buss_source;
         v_list.iss_cd := i.iss_cd;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.claim_id := i.claim_id;
         v_list.assd_no := i.assd_no;
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.clm_file_date := i.clm_file_date;
         v_list.loss_date := i.loss_date;
         v_list.clm_loss_id := i.clm_loss_id;
         v_list.loss_cat_cd := i.loss_cat_cd;
         v_list.item_no := i.item_no;
         v_list.grouped_item_no := i.grouped_item_no;
         v_list.peril_cd := i.peril_cd;
         v_list.paid_loss := i.paid_loss;
         v_list.tsi_amt := i.tsi_amt;
         v_list.item_name :=
            get_gpa_item_title (i.claim_id,
                                i.line_cd,
                                i.item_no,
                                NVL (i.grouped_item_no, 0)
                               );

         BEGIN
            FOR a IN (SELECT intm_name
                        FROM giis_intermediary
                       WHERE intm_no = i.intm_no)
            LOOP
               v_list.intm_name := a.intm_name;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.intm_name := '';
         END;

         BEGIN
            FOR a IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_no = i.assd_no)
            LOOP
               v_list.assd_name := a.assd_name;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.assd_name := NULL;
         END;

         BEGIN
            SELECT iss_name
              INTO v_list.iss_name
              FROM giis_issource
             WHERE iss_cd = i.iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.iss_name := NULL;
         END;

         BEGIN
            SELECT line_name
              INTO v_list.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.line_name := NULL;
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
                  --||
                     -- v_list.intm_ri;
                  END LOOP;
               END;
            END IF;
         END IF;

         BEGIN
            FOR f IN (SELECT pol_eff_date
                        FROM gicl_claims
                       WHERE claim_id = i.claim_id)
            LOOP
               v_list.eff_date := f.pol_eff_date;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.eff_date := NULL;
         END;

         BEGIN
            FOR x IN (SELECT expiry_date
                        FROM gicl_claims
                       WHERE claim_id = i.claim_id)
            LOOP
               v_list.expiry_date := x.expiry_date;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.expiry_date := NULL;
         END;

         BEGIN
            SELECT loss_cat_des
              INTO v_list.loss_cat_category
              FROM giis_loss_ctgry
             WHERE line_cd = i.line_cd AND loss_cat_cd = i.loss_cat_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.loss_cat_category := NULL;
         END;

         BEGIN
            FOR l IN (SELECT loss_loc1, loss_loc2, loss_loc3
                        FROM gicl_claims
                       WHERE loss_cat_cd = i.loss_cat_cd
                         AND claim_id = i.claim_id)
            LOOP
               v_list.loc :=
                      l.loss_loc1 || ' ' || l.loss_loc2 || ' ' || l.loss_loc3;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.loc := NULL;
         END;

         BEGIN
            FOR p IN (SELECT peril_name
                        FROM giis_peril
                       WHERE peril_cd = i.peril_cd AND line_cd = i.line_cd)
            LOOP
               v_list.peril := p.peril_name;
            END LOOP;
         END;

         BEGIN
            FOR k IN (SELECT b.le_stat_desc
                        FROM gicl_clm_loss_exp a, gicl_le_stat b
                       WHERE claim_id = i.claim_id
                         AND NVL (cancel_sw, 'N') = 'N'
                         AND item_no = i.item_no
                         AND peril_cd = i.peril_cd
                         AND clm_loss_id = i.clm_loss_id
                         AND payee_type = 'E'
                         AND b.le_stat_cd = a.item_stat_cd)
            LOOP
               v_clm_stat := k.le_stat_desc;

               IF var_clm_stat IS NULL
               THEN
                  var_clm_stat := v_clm_stat;
               ELSE
                  var_clm_stat := v_clm_stat || '/' || CHR (10);
               END IF;
            END LOOP;

            IF var_clm_stat IS NULL
            THEN
               BEGIN
                  SELECT b.clm_stat_desc
                    INTO v_list.clm_stat
                    FROM gicl_claims a, giis_clm_stat b
                   WHERE a.claim_id = i.claim_id
                     AND b.clm_stat_cd = a.clm_stat_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_list.clm_stat := NULL;
               END;
            ELSE
               v_list.clm_stat := var_clm_stat;
            END IF;
         END;

         BEGIN
            v_list.pd_loss := i.paid_loss;

            FOR z IN (SELECT recovered_amt rec_amt
                        FROM gicl_rcvry_brdrx_extr
                       WHERE session_id = p_session_id
                         AND claim_id = NVL (i.claim_id, claim_id)
                         AND buss_source LIKE NVL(i.buss_source, '%')
                         AND iss_cd = i.iss_cd
                         AND line_cd = i.line_cd
                         AND subline_cd = i.subline_cd
                         AND item_no = i.item_no
                         AND peril_cd = i.peril_cd
                         AND payee_type = 'L')
            LOOP
               IF NVL (z.rec_amt, 0) != 0
               THEN
                  v_list.pd_loss := v_list.pd_loss - z.rec_amt;
               END IF;
            END LOOP;
         END;
         
         BEGIN
            v_list.cf_share_type1 := 0;

            FOR z IN (SELECT NVL (a.losses_paid, 0) paid_loss
                        FROM gicl_res_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND a.grp_seq_no IN (
                                SELECT b.share_cd
                                  FROM giis_dist_share b
                                 WHERE b.line_cd = i.line_cd
                                   AND b.share_type = 1)
                         AND a.claim_id = NVL (i.claim_id, a.claim_id)
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND a.brdrx_record_id = i.brdrx_record_id
                         AND NVL (a.losses_paid, 0) <> 0)
            LOOP
               v_list.cf_share_type1 := z.paid_loss + v_list.cf_share_type1;
            END LOOP;

            FOR x IN (SELECT SUM (shr_recovery_amt) rec_amt
                        FROM gicl_rcvry_brdrx_ds_extr a
                       WHERE session_id = p_session_id
                         AND a.grp_seq_no IN (
                                SELECT b.share_cd
                                  FROM giis_dist_share b
                                 WHERE b.line_cd = i.line_cd
                                   AND b.share_type = 1)
                         AND a.claim_id = NVL (i.claim_id, claim_id)
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND payee_type = 'L')
            LOOP
               IF NVL (x.rec_amt, 0) != 0
               THEN
                  v_list.cf_share_type1 := v_list.cf_share_type1 - x.rec_amt;
               END IF;
            END LOOP;
         END;

         BEGIN
            v_list.cf_share_type3 := 0;

            FOR z IN (SELECT NVL (a.losses_paid, 0) paid_loss
                        FROM gicl_res_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND a.grp_seq_no IN (
                                SELECT b.share_cd
                                  FROM giis_dist_share b
                                 WHERE b.line_cd = i.line_cd
                                   AND b.share_type = 3)
                         AND a.claim_id = NVL (i.claim_id, a.claim_id)
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND a.brdrx_record_id = i.brdrx_record_id
                         AND NVL (a.losses_paid, 0) <> 0)
            LOOP
               v_list.cf_share_type3 := z.paid_loss + v_list.cf_share_type3;
            END LOOP;

            FOR x IN (SELECT SUM (shr_recovery_amt) rec_amt
                        FROM gicl_rcvry_brdrx_ds_extr a
                       WHERE session_id = p_session_id
                         AND a.grp_seq_no IN (
                                SELECT b.share_cd
                                  FROM giis_dist_share b
                                 WHERE b.line_cd = i.line_cd
                                   AND b.share_type = 3)
                         AND a.claim_id = NVL (i.claim_id, claim_id)
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND payee_type = 'L')
            LOOP
               IF NVL (x.rec_amt, 0) != 0
               THEN
                  v_list.cf_share_type3 := v_list.cf_share_type3 - x.rec_amt;
               END IF;
            END LOOP;
         END;

         BEGIN
            v_list.cf_share_type2 := 0;

            FOR z IN (SELECT NVL (a.losses_paid, 0) paid_loss
                        FROM gicl_res_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND a.grp_seq_no IN (
                                SELECT b.share_cd
                                  FROM giis_dist_share b
                                 WHERE b.line_cd = i.line_cd
                                   AND b.share_type = 2)
                         AND a.claim_id = NVL (i.claim_id, a.claim_id)
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND a.brdrx_record_id = i.brdrx_record_id
                         AND NVL (a.losses_paid, 0) <> 0)
            LOOP
               v_list.cf_share_type2 := z.paid_loss + v_list.cf_share_type2;
            END LOOP;

            FOR x IN (SELECT SUM (shr_recovery_amt) rec_amt
                        FROM gicl_rcvry_brdrx_ds_extr a
                       WHERE session_id = p_session_id
                         AND a.grp_seq_no IN (
                                SELECT b.share_cd
                                  FROM giis_dist_share b
                                 WHERE b.line_cd = i.line_cd
                                   AND b.share_type = 2)
                         AND a.claim_id = NVL (i.claim_id, claim_id)
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND payee_type = 'L')
            LOOP
               IF NVL (x.rec_amt, 0) != 0
               THEN
                  v_list.cf_share_type2 := v_list.cf_share_type2 - x.rec_amt;
               END IF;
            END LOOP;
         END;

         BEGIN
            v_list.cf_share_type4 := 0;

            FOR z IN (SELECT NVL (a.losses_paid, 0) paid_loss
                        FROM gicl_res_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND a.grp_seq_no IN (
                                SELECT b.share_cd
                                  FROM giis_dist_share b
                                 WHERE b.line_cd = i.line_cd
                                   AND b.share_type = 4)
                         AND a.claim_id = NVL (i.claim_id, a.claim_id)
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND a.brdrx_record_id = i.brdrx_record_id
                         AND NVL (a.losses_paid, 0) <> 0)
            LOOP
               v_list.cf_share_type4 := z.paid_loss + v_list.cf_share_type4;
            END LOOP;

            FOR x IN (SELECT SUM (shr_recovery_amt) rec_amt
                        FROM gicl_rcvry_brdrx_ds_extr a
                       WHERE session_id = p_session_id
                         AND a.grp_seq_no IN (
                                SELECT b.share_cd
                                  FROM giis_dist_share b
                                 WHERE b.line_cd = i.line_cd
                                   AND b.share_type = 4)
                         AND a.claim_id = NVL (i.claim_id, claim_id)
                         AND a.item_no = i.item_no
                         AND a.peril_cd = i.peril_cd
                         AND payee_type = 'L')
            LOOP
               IF NVL (x.rec_amt, 0) != 0
               THEN
                  v_list.cf_share_type4 := v_list.cf_share_type4 - x.rec_amt;
               END IF;
            END LOOP;
         END;

         BEGIN
            BEGIN
               SELECT (  NVL (v_list.cf_share_type2, 0)
                       + NVL (v_list.cf_share_type3, 0)
                      )
                 INTO v_list.RECOVERABLE
                 FROM DUAL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_list.RECOVERABLE := NULL;
            END;
         END;
         
         BEGIN
            FOR a IN (SELECT SIGN (i.paid_loss) losses_paid
                        FROM DUAL)
            LOOP
               v_loss := a.losses_paid;

               IF v_loss < 1
               THEN
                  FOR d1 IN
                     (SELECT DISTINCT TO_CHAR (a.date_paid,
                                               'MM-DD-RRRR'
                                              ) tran_date,
                                      TO_CHAR (a.cancel_date,
                                               'MM-DD-RRRR'
                                              ) cancel_date
                                 FROM gicl_clm_res_hist a,
                                      giac_acctrans b,
                                      giac_reversals c
                                WHERE a.tran_id = c.gacc_tran_id
                                  AND b.tran_id = c.reversing_tran_id
                                  AND a.claim_id = i.claim_id
                                  AND a.clm_loss_id = i.clm_loss_id)
                  LOOP
                     v_tran_date :=
                           d1.tran_date
                        || CHR (10)
                        || 'cancelled '
                        || d1.cancel_date;

                     IF var_tran_date IS NULL
                     THEN
                        v_list.tran_date := v_tran_date;
                     ELSE
                        v_list.tran_date :=
                                      v_tran_date || CHR (10)
                                      || var_tran_date;
                     END IF;
                  END LOOP;
               ELSE
                  FOR d2 IN
                     (SELECT DISTINCT TO_CHAR (a.date_paid,
                                               'MM-DD-RRRR'
                                              ) tran_date
                                 FROM gicl_clm_res_hist a, giac_acctrans b
                                WHERE a.claim_id = i.claim_id
                                  AND a.clm_loss_id = i.clm_loss_id
                                  AND a.tran_id = b.tran_id
                                  AND DECODE (p_paid_date,
                                              1, TRUNC (a.date_paid),
                                              2, TRUNC (b.posting_date)
                                             ) BETWEEN (TO_DATE (p_date_from,
                                                                 'mm-dd-yyyy'
                                                                )
                                                       )
                                                   AND (TO_DATE (p_date_to,
                                                                 'mm-dd-yyyy'
                                                                )
                                                       ))
                  LOOP
                     v_tran_date := d2.tran_date;

                     IF var_tran_date IS NULL
                     THEN
                        v_list.tran_date := v_tran_date;
                     ELSE
                        v_list.tran_date :=
                                      v_tran_date || CHR (10)
                                      || var_tran_date;
                     END IF;
                  END LOOP;
               END IF;
            END LOOP;
         END;
         
         v_list.tran_date := gicls202_extraction_pkg.get_giclr209_dtl(i.claim_id, i.from_date, i.to_date, i.pd_date_opt, 'L', 'TRAN_DATE');

         PIPE ROW (v_list);
      END LOOP;

      IF (v_header = TRUE)
      THEN
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_giclr209lr_report;
END;
/


