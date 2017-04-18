CREATE OR REPLACE PACKAGE BODY CPI.GICLR209L_PKG
AS
/*
    **  Created by    : Paul Joseph Diaz
    **  Date Created  : April 12, 2013
    **  Reference By  : GICLR209L - Losses Paid Distribution Register
    */
   FUNCTION get_giclr209l_details (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_iss_break    VARCHAR2,
      p_paid_date    NUMBER,
      p_intm_break   NUMBER
   )
      RETURN giclr209l_report_tab PIPELINED
   AS
      v_report         giclr209l_report_type;
      v_param_date     VARCHAR2 (100);
      v_intm_name      giis_intermediary.intm_name%TYPE;
      v_iss_name       giis_issource.iss_name%TYPE;
      v_line_name      giis_line.line_name%TYPE;
      v_assd_name      giis_assured.assd_name%TYPE;
      v_eff_date       gicl_claims.pol_eff_date%TYPE;
      v_loss_cat_des   giis_loss_ctgry.loss_cat_des%TYPE;
      v_peril          giis_peril.peril_name%TYPE;
      v_paid           NUMBER (16, 2);
      v_share_type     NUMBER                              := 0;
      v_xol_amt        NUMBER                              := 0;
      v_recoverable    NUMBER (16, 2);
      v_tran_date      VARCHAR2 (100);
      var_tran_date    VARCHAR2 (200);
      v_loss           NUMBER;
      v_pol_iss_cd     gicl_claims.pol_iss_cd%TYPE;
      v_intm_ri        VARCHAR2 (2000);
      v_expiry_date    gicl_claims.expiry_date%TYPE;
      v_loc            VARCHAR2 (250);
      v_clm_stat       giis_clm_stat.clm_stat_desc%TYPE;
      v_clm_stat1      giis_clm_stat.clm_stat_desc%TYPE;
      var_clm_stat     VARCHAR2 (500);
      v_claim_no       gicl_res_brdrx_extr.claim_no%TYPE;
      v_header         BOOLEAN                             := TRUE;
   BEGIN
      v_report.header_flag := 'N';

      BEGIN
         SELECT param_value_v
           INTO v_report.v_company_name
           FROM giac_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_report.v_company_name := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_report.v_company_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_report.v_company_address := NULL;
      END;

      BEGIN
         IF p_intm_break = 0
         THEN
            v_report.v_title :=
                             'LOSSES PAID DISTRIBUTION REGISTER - PER BRANCH';
         ELSIF p_intm_break = 1
         THEN
            v_report.v_title :=
                       'LOSSES PAID DISTRIBUTION REGISTER - PER INTERMEDIARY';
         ELSE
            v_report.v_title := NULL;
         END IF;
      END;

      BEGIN
         BEGIN
            SELECT DECODE (p_paid_date,
                           1, 'Transaction Date',
                           2, 'Posting Date'
                          )
              INTO v_param_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_param_date := NULL;
         END;

         v_report.v_param_date := '(Based on ' || v_param_date || ')';
      END;

      BEGIN
         SELECT    'from '
                || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                            'fmMonth DD, YYYY'
                           )
                || ' to '
                || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'),
                            'fmMonth DD, YYYY'
                           )
           INTO v_report.v_date
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_report.v_date := NULL;
      END;

      FOR xtract_rec IN (SELECT   a.brdrx_record_id, a.buss_source, a.iss_cd,
                                  line_cd, a.subline_cd, a.claim_id,
                                  a.assd_no, a.claim_no, a.policy_no,
                                  a.clm_file_date, a.loss_date, a.loss_cat_cd,
                                  a.item_no, a.grouped_item_no, a.peril_cd,
                                  a.intm_no, a.clm_loss_id,
                                  NVL (a.tsi_amt, 0) tsi_amt,
                                  NVL (a.losses_paid, 0) paid_loss, a.from_date, a.to_date, a.pd_date_opt
                             FROM gicl_res_brdrx_extr a
                            WHERE session_id = p_session_id
                              AND claim_id = NVL(p_claim_id, claim_id)
                              AND NVL (losses_paid, 0) <> 0
                         ORDER BY a.intm_no, a.iss_cd, a.line_cd, a.claim_no)
      LOOP
         v_header := FALSE;
         v_report.header_flag := 'Y';
         v_report.claim_no := xtract_rec.claim_no;
         v_report.loss_date := xtract_rec.loss_date;
         v_report.item_title :=
            get_gpa_item_title (xtract_rec.claim_id,
                                xtract_rec.line_cd,
                                xtract_rec.item_no,
                                NVL (xtract_rec.grouped_item_no, 0)
                               );
         v_report.iss_cd := xtract_rec.iss_cd;
         v_report.line_cd := xtract_rec.line_cd;
         v_report.tsi_amt := xtract_rec.tsi_amt;
         v_report.paid_loss := xtract_rec.paid_loss;
         v_report.policy_no := xtract_rec.policy_no;
         v_report.clm_file_date := xtract_rec.clm_file_date;
         v_intm_ri := NULL;

         BEGIN
            v_report.intm_no := xtract_rec.intm_no;

            FOR i IN (SELECT intm_name
                        FROM giis_intermediary
                       WHERE intm_no = xtract_rec.intm_no)
            LOOP
               v_intm_name := i.intm_name;
            END LOOP;

            v_report.intm_name := v_intm_name;
         END;

         BEGIN
            FOR b IN (SELECT iss_name
                        FROM giis_issource
                       WHERE iss_cd = xtract_rec.iss_cd)
            LOOP
               v_iss_name := b.iss_name;
            END LOOP;

            v_report.iss_name := v_iss_name;
         END;

         BEGIN
            FOR l IN (SELECT line_name
                        FROM giis_line
                       WHERE line_cd = xtract_rec.line_cd)
            LOOP
               v_line_name := l.line_name;
            END LOOP;

            v_report.line_name := v_line_name;
         END;

         BEGIN
            FOR a IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_no = xtract_rec.assd_no)
            LOOP
               v_assd_name := a.assd_name;
            END LOOP;

            v_report.assd_name := v_assd_name;
         END;

         BEGIN
            FOR f IN (SELECT pol_eff_date
                        FROM gicl_claims
                       WHERE claim_id = xtract_rec.claim_id)
            LOOP
               v_eff_date := f.pol_eff_date;
            END LOOP;

            v_report.eff_date := v_eff_date;
         END;

         BEGIN
            FOR c IN (SELECT loss_cat_des
                        FROM giis_loss_ctgry
                       WHERE line_cd = xtract_rec.line_cd
                         AND loss_cat_cd = xtract_rec.loss_cat_cd)
            LOOP
               v_loss_cat_des := c.loss_cat_des;
            END LOOP;

            v_report.loss_cat_des := v_loss_cat_des;
         END;

         BEGIN
            FOR p IN (SELECT peril_name
                        FROM giis_peril
                       WHERE peril_cd = xtract_rec.peril_cd
                         AND line_cd = xtract_rec.line_cd)
            LOOP
               v_peril := p.peril_name;
            END LOOP;

            v_report.peril_name := v_peril;
         END;

         BEGIN
            --cf_share_type1
            v_paid := 0;

            FOR s1 IN
               (SELECT NVL (a.losses_paid, 0) paid_loss
                  FROM gicl_res_brdrx_ds_extr a
                 WHERE a.session_id = p_session_id
                   AND a.grp_seq_no IN (
                          SELECT a.share_cd
                            FROM giis_dist_share a
                           WHERE a.line_cd = xtract_rec.line_cd
                             AND a.share_type = 1)
                   AND a.claim_id = NVL (xtract_rec.claim_id, a.claim_id)
                   AND a.item_no = xtract_rec.item_no
                   AND a.peril_cd = xtract_rec.peril_cd
                   AND a.brdrx_record_id = xtract_rec.brdrx_record_id
                   AND NVL (a.losses_paid, 0) <> 0)
            LOOP
               v_paid := s1.paid_loss + v_paid;
            END LOOP;

            v_report.cf_share_type1 := v_paid;
         END;

         BEGIN
            --cf_share_type2
            v_paid := 0;

            FOR s2 IN
               (SELECT NVL (a.losses_paid, 0) paid_loss
                  FROM gicl_res_brdrx_ds_extr a
                 WHERE a.session_id = p_session_id
                   AND a.grp_seq_no IN (
                          SELECT a.share_cd
                            FROM giis_dist_share a
                           WHERE a.line_cd = xtract_rec.line_cd
                             AND a.share_type = 2)
                   AND a.claim_id = NVL (xtract_rec.claim_id, a.claim_id)
                   AND a.item_no = xtract_rec.item_no
                   AND a.peril_cd = xtract_rec.peril_cd
                   AND a.brdrx_record_id = xtract_rec.brdrx_record_id
                   AND NVL (a.losses_paid, 0) <> 0)
            LOOP
               v_paid := s2.paid_loss + v_paid;
            END LOOP;

            v_report.cf_share_type2 := v_paid;
         END;

         BEGIN
            --cf_share_type3
            v_paid := 0;

            FOR s3 IN
               (SELECT NVL (a.losses_paid, 0) paid_loss
                  FROM gicl_res_brdrx_ds_extr a
                 WHERE a.session_id = p_session_id
                   AND a.grp_seq_no IN (
                          SELECT a.share_cd
                            FROM giis_dist_share a
                           WHERE a.line_cd = xtract_rec.line_cd
                             AND a.share_type = 3)
                   AND a.claim_id = NVL (xtract_rec.claim_id, a.claim_id)
                   AND a.item_no = xtract_rec.item_no
                   AND a.peril_cd = xtract_rec.peril_cd
                   AND a.brdrx_record_id = xtract_rec.brdrx_record_id
                   AND NVL (a.losses_paid, 0) <> 0)
            LOOP
               v_paid := s3.paid_loss + v_paid;
            END LOOP;

            v_report.cf_share_type3 := v_paid;
         END;

         BEGIN
            BEGIN
               SELECT (  NVL (v_report.cf_share_type2, 0)
                       + NVL (v_report.cf_share_type3, 0)
                      )
                 INTO v_recoverable
                 FROM DUAL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_recoverable := NULL;
            END;

            v_report.v_recoverable := v_recoverable;
         END;

         BEGIN
            --cf_share_type4
            SELECT param_value_v
              INTO v_share_type
              FROM giac_parameters
             WHERE param_name LIKE 'XOL_TRTY_SHARE_TYPE';

            FOR s4 IN
               (SELECT NVL (a.losses_paid, 0) paid_loss
                  FROM gicl_res_brdrx_ds_extr a
                 WHERE a.session_id = p_session_id
                   AND a.grp_seq_no IN (
                          SELECT a.share_cd
                            FROM giis_dist_share a
                           WHERE a.line_cd = xtract_rec.line_cd
                             AND a.share_type = v_share_type)
                   AND a.claim_id = NVL (xtract_rec.claim_id, a.claim_id)
                   AND a.item_no = xtract_rec.item_no
                   AND a.peril_cd = xtract_rec.peril_cd
                   AND a.brdrx_record_id = xtract_rec.brdrx_record_id
                   AND NVL (a.losses_paid, 0) <> 0)
            LOOP
               v_xol_amt := v_xol_amt + s4.paid_loss;
            END LOOP;

            v_report.cf_share_type4 := v_xol_amt;
         END;

         BEGIN
            --tran_date
            FOR a IN (SELECT SIGN (xtract_rec.paid_loss) losses_paid
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
                                  AND a.claim_id = xtract_rec.claim_id
                                  AND a.clm_loss_id = xtract_rec.clm_loss_id)
                  LOOP
                     v_tran_date :=
                           d1.tran_date
                        || CHR (10)
                        || 'cancelled '
                        || d1.cancel_date;

                     IF var_tran_date IS NULL
                     THEN
                        var_tran_date := v_tran_date;
                     ELSE
                        var_tran_date :=
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
                                WHERE a.claim_id = xtract_rec.claim_id
                                  AND a.clm_loss_id = xtract_rec.clm_loss_id
                                  AND a.tran_id = b.tran_id
                                  AND DECODE (p_paid_date,
                                              1, TRUNC (a.date_paid),
                                              2, TRUNC (b.posting_date)
                                             ) BETWEEN TO_DATE (p_from_date,
                                                                'mm-dd-yyyy'
                                                               )
                                                   AND TO_DATE (p_to_date,
                                                                'mm-dd-yyyy'
                                                               ))
                  LOOP
                     v_tran_date := d2.tran_date;

                     IF var_tran_date IS NULL
                     THEN
                        var_tran_date := v_tran_date;
                     ELSE
                        var_tran_date :=
                                      v_tran_date || CHR (10)
                                      || var_tran_date;
                     END IF;
                  END LOOP;
               END IF;
            END LOOP;

            v_report.tran_date := gicls202_extraction_pkg.get_giclr209_dtl(xtract_rec.claim_id, xtract_rec.from_date, xtract_rec.to_date, xtract_rec.pd_date_opt, 'L', 'TRAN_DATE');
            --v_report.tran_date := var_tran_date;
         END;

         BEGIN
            --intm_ri
            BEGIN
               SELECT pol_iss_cd
                 INTO v_pol_iss_cd
                 FROM gicl_claims
                WHERE claim_id = xtract_rec.claim_id;
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
                               AND a.claim_id = xtract_rec.claim_id)
                  LOOP
                     v_intm_ri := TO_CHAR (r.ri_cd) || '/' || r.ri_name;
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
                                  AND a.claim_id = xtract_rec.claim_id
                                  AND a.item_no = xtract_rec.item_no
                                  AND a.peril_cd = xtract_rec.peril_cd
                                  AND a.intm_no = xtract_rec.intm_no)
                     LOOP
                        v_intm_ri :=
                              TO_CHAR (i.intm_no)
                           || '/'
                           || i.ref_intm_cd
                           || '/'
                           || i.intm_name;
                     END LOOP;
                  END;
               ELSIF p_intm_break = 0
               THEN
                  BEGIN
                     FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                                 FROM gicl_intm_itmperil a,
                                      giis_intermediary b
                                WHERE a.intm_no = b.intm_no
                                  AND a.claim_id = xtract_rec.claim_id
                                  AND a.item_no = xtract_rec.item_no
                                  AND a.peril_cd = xtract_rec.peril_cd)
                     LOOP
                        v_intm_ri :=
                              TO_CHAR (m.intm_no)
                           || '/'
                           || m.ref_intm_cd
                           || '/'
                           || m.intm_name
                           || CHR (10)
                           || v_intm_ri;
                     END LOOP;
                  END;
               END IF;
            END IF;

            v_report.intm_ri := v_intm_ri;
         END;

         BEGIN
            --expiry_date
            FOR x IN (SELECT expiry_date
                        FROM gicl_claims
                       WHERE claim_id = xtract_rec.claim_id)
            LOOP
               v_expiry_date := x.expiry_date;
            END LOOP;

            v_report.expiry_date := v_expiry_date;
         END;

         BEGIN
            --location
            FOR l IN (SELECT loss_loc1, loss_loc2, loss_loc3
                        FROM gicl_claims
                       WHERE loss_cat_cd = xtract_rec.loss_cat_cd
                         AND claim_id = xtract_rec.claim_id)
            LOOP
               v_loc :=
                      l.loss_loc1 || ' ' || l.loss_loc2 || ' ' || l.loss_loc3;
            END LOOP;

            v_report.LOCATION := v_loc;
         END;

         BEGIN
            --claim_status
            FOR i IN (SELECT b.le_stat_desc
                        FROM gicl_clm_loss_exp a, gicl_le_stat b
                       WHERE claim_id = xtract_rec.claim_id
                         AND NVL (cancel_sw, 'N') = 'N'
                         AND item_no = xtract_rec.item_no
                         AND peril_cd = xtract_rec.peril_cd
                         AND clm_loss_id = xtract_rec.clm_loss_id
                         AND payee_type = 'L'
                         AND b.le_stat_cd = a.item_stat_cd)
            LOOP
               v_clm_stat := i.le_stat_desc;

               IF var_clm_stat IS NULL
               THEN
                  var_clm_stat := v_clm_stat;
               ELSE
                  var_clm_stat :=
                                 v_clm_stat || '/' || CHR (10)
                                 || var_clm_stat;
               END IF;
            END LOOP;

            IF var_clm_stat IS NULL
            THEN
               BEGIN
                  SELECT b.clm_stat_desc
                    INTO v_clm_stat1
                    FROM gicl_claims a, giis_clm_stat b
                   WHERE a.claim_id = xtract_rec.claim_id
                     AND b.clm_stat_cd = a.clm_stat_cd;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_clm_stat1 := NULL;
               END;

               v_report.claim_status := v_clm_stat1;
            ELSE
               v_report.claim_status := var_clm_stat;
            END IF;
         END;

         PIPE ROW (v_report);
      END LOOP;

      IF (v_header = TRUE)
      THEN
         PIPE ROW (v_report);
      END IF;
   END get_giclr209l_details;
END giclr209l_pkg;
/


