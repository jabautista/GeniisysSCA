CREATE OR REPLACE PACKAGE BODY cpi.csv_rep_clm_pol_det_giclr546
AS
   FUNCTION csv_giclr546_l (
      p_clmstat_cd     VARCHAR2,
      p_clmstat_type   VARCHAR2,
      p_end_dt         VARCHAR2,
      p_issue_yy       NUMBER,
      p_line_cd        VARCHAR2,
      p_loss_exp       VARCHAR2,
      p_pol_iss_cd     VARCHAR2,
      p_pol_seq_no     NUMBER,
      p_renew_no       NUMBER,
      p_start_dt       VARCHAR2,
      p_subline_cd     VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN loss_report_tab PIPELINED
   IS
      v_list          loss_report_type;
      v_intm          VARCHAR2 (300)                 := NULL;
      var_intm        VARCHAR2 (300)                 := NULL;
      v_print         BOOLEAN                        := TRUE;
      v_claim_id      gicl_claims.claim_id%TYPE;
      v_loss_exp      VARCHAR2 (2);
      v_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE;
   BEGIN
      FOR i IN
         (SELECT   a.clm_stat_cd, b.clm_stat_desc, a.claim_id,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim_number,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.renew_no), 2, '0') policy_number,
                   a.assured_name, a.intm_no, a.pol_iss_cd, a.pol_eff_date,
                   a.dsp_loss_date, a.clm_file_date
              FROM gicl_claims a, giis_clm_stat b
             WHERE a.clm_stat_cd = b.clm_stat_cd
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
               AND a.pol_iss_cd = NVL (p_pol_iss_cd, a.pol_iss_cd)
               AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
               AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
               AND a.renew_no = NVL (p_renew_no, a.renew_no)
               AND TRUNC (a.clm_file_date) BETWEEN NVL (TO_DATE (p_start_dt,
                                                                 'mm-dd-yyyy'
                                                                ),
                                                        a.clm_file_date
                                                       )
                                               AND NVL (TO_DATE (p_end_dt,
                                                                 'mm-dd-yyyy'
                                                                ),
                                                        a.clm_file_date
                                                       )
               AND check_user_per_iss_cd2 (a.line_cd,
                                           a.iss_cd,
                                           'GICLS540',
                                           p_user_id
                                          ) = 1
          ORDER BY policy_number, claim_number DESC)
      LOOP
         v_list.intermediary_cedant := '';
         v_list.peril := '';
         v_list.loss_amount := '.00';
         v_list.RETENTION := '.00';
         v_list.proportional_treaty := '.00';
         v_list.non_proportional_treaty := '.00';
         v_list.facultative := '.00';
         v_print := TRUE;
         v_list.claim_number := i.claim_number;
         v_list.policy_number := i.policy_number;

         IF i.pol_iss_cd = 'RI'
         THEN
            FOR ri IN (SELECT DISTINCT b.ri_name, a.ri_cd
                                  FROM gicl_claims a, giis_reinsurer b
                                 WHERE a.claim_id = i.claim_id
                                   AND a.ri_cd = b.ri_cd(+))
            LOOP
               v_intm := TO_CHAR (ri.ri_cd) || '/' || ri.ri_name;

               IF var_intm IS NULL
               THEN
                  v_list.intermediary_cedant := v_intm;
               ELSE
                  v_list.intermediary_cedant := v_intm || CHR (10)
                                                || var_intm;
               END IF;
            END LOOP;
         ELSE
            FOR intm IN (SELECT DISTINCT a.intm_no nmbr, b.intm_name nm,
                                         b.ref_intm_cd ref_cd
                                    FROM gicl_intm_itmperil a,
                                         giis_intermediary b
                                   WHERE a.intm_no = b.intm_no
                                     AND a.claim_id = i.claim_id)
            LOOP
               v_intm :=
                   TO_CHAR (intm.nmbr) || '/' || intm.ref_cd || '/'
                   || intm.nm;

               IF var_intm IS NULL
               THEN
                  v_list.intermediary_cedant := v_intm;
               ELSE
                  v_list.intermediary_cedant := v_intm || CHR (10)
                                                || var_intm;
               END IF;
            END LOOP;
         END IF;

         v_list.eff_date := TO_CHAR (i.pol_eff_date, 'MM-DD-YYYY');
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-YYYY');
         v_list.file_date := TO_CHAR (i.clm_file_date, 'MM-DD-YYYY');
         v_list.status := i.clm_stat_desc;
         v_claim_id := i.claim_id;
         v_clm_stat_cd := i.clm_stat_cd;

         FOR k IN (SELECT DISTINCT a.peril_name, b.claim_id, a.peril_cd
                              FROM giis_peril a, gicl_item_peril b
                             WHERE a.line_cd = b.line_cd
                               AND a.peril_cd = b.peril_cd
                               AND b.claim_id = i.claim_id)
         LOOP
            v_list.peril := k.peril_name;

            BEGIN
               v_print := FALSE;

               SELECT DECODE (p_loss_exp, 'E', 'E', 'L')
                 INTO v_loss_exp
                 FROM DUAL;

               v_list.loss_amount :=
                  TO_CHAR (gicls540_pkg.get_loss_amt (k.claim_id,
                                                      k.peril_cd,
                                                      v_loss_exp,
                                                      p_clmstat_cd
                                                     ),
                           '99,999,999,999.99'
                          );
               v_list.RETENTION :=
                  TO_CHAR (gicls540_pkg.amount_per_share_type (k.claim_id,
                                                               k.peril_cd,
                                                               1,
                                                               v_loss_exp,
                                                               p_clmstat_cd
                                                              ),
                           '99,999,999,999.99'
                          );
               v_list.proportional_treaty :=
                  TO_CHAR
                     (gicls540_pkg.amount_per_share_type
                                                  (k.claim_id,
                                                   k.peril_cd,
                                                   giacp.v ('TRTY_SHARE_TYPE'),
                                                   v_loss_exp,
                                                   p_clmstat_cd
                                                  ),
                      '99,999,999,999.99'
                     );
               v_list.non_proportional_treaty :=
                  TO_CHAR
                     (gicls540_pkg.amount_per_share_type
                                              (k.claim_id,
                                               k.peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               v_loss_exp,
                                               p_clmstat_cd
                                              ),
                      '99,999,999,999.99'
                     );
               v_list.facultative :=
                  TO_CHAR
                     (gicls540_pkg.amount_per_share_type
                                                 (k.claim_id,
                                                  k.peril_cd,
                                                  giacp.v ('FACUL_SHARE_TYPE'),
                                                  v_loss_exp,
                                                  p_clmstat_cd
                                                 ),
                      '99,999,999,999.99'
                     );
               PIPE ROW (v_list);
            END;
         END LOOP;

         IF v_print
         THEN
            PIPE ROW (v_list);
         END IF;
      END LOOP;
   END csv_giclr546_l;

   FUNCTION csv_giclr546_e (
      p_clmstat_cd     VARCHAR2,
      p_clmstat_type   VARCHAR2,
      p_end_dt         VARCHAR2,
      p_issue_yy       NUMBER,
      p_line_cd        VARCHAR2,
      p_loss_exp       VARCHAR2,
      p_pol_iss_cd     VARCHAR2,
      p_pol_seq_no     NUMBER,
      p_renew_no       NUMBER,
      p_start_dt       VARCHAR2,
      p_subline_cd     VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN expense_report_tab PIPELINED
   IS
      v_list          expense_report_type;
      v_intm          VARCHAR2 (300)                 := NULL;
      var_intm        VARCHAR2 (300)                 := NULL;
      v_print         BOOLEAN                        := TRUE;
      v_claim_id      gicl_claims.claim_id%TYPE;
      v_loss_exp      VARCHAR2 (2);
      v_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE;
   BEGIN
      FOR i IN
         (SELECT   a.clm_stat_cd, b.clm_stat_desc, a.claim_id,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim_number,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.renew_no), 2, '0') policy_number,
                   a.assured_name, a.intm_no, a.pol_iss_cd, a.pol_eff_date,
                   a.dsp_loss_date, a.clm_file_date
              FROM gicl_claims a, giis_clm_stat b
             WHERE a.clm_stat_cd = b.clm_stat_cd
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
               AND a.pol_iss_cd = NVL (p_pol_iss_cd, a.pol_iss_cd)
               AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
               AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
               AND a.renew_no = NVL (p_renew_no, a.renew_no)
               AND TRUNC (a.clm_file_date) BETWEEN NVL (TO_DATE (p_start_dt,
                                                                 'mm-dd-yyyy'
                                                                ),
                                                        a.clm_file_date
                                                       )
                                               AND NVL (TO_DATE (p_end_dt,
                                                                 'mm-dd-yyyy'
                                                                ),
                                                        a.clm_file_date
                                                       )
               AND check_user_per_iss_cd2 (a.line_cd,
                                           a.iss_cd,
                                           'GICLS540',
                                           p_user_id
                                          ) = 1
          ORDER BY policy_number, claim_number DESC)
      LOOP
         v_list.intermediary_cedant := '';
         v_list.peril := '';
         v_list.expense_amount := '.00';
         v_list.RETENTION := '.00';
         v_list.proportional_treaty := '.00';
         v_list.non_proportional_treaty := '.00';
         v_list.facultative := '.00';
         v_print := TRUE;
         v_list.claim_number := i.claim_number;
         v_list.policy_number := i.policy_number;

         IF i.pol_iss_cd = 'RI'
         THEN
            FOR ri IN (SELECT DISTINCT b.ri_name, a.ri_cd
                                  FROM gicl_claims a, giis_reinsurer b
                                 WHERE a.claim_id = i.claim_id
                                   AND a.ri_cd = b.ri_cd(+))
            LOOP
               v_intm := TO_CHAR (ri.ri_cd) || '/' || ri.ri_name;

               IF var_intm IS NULL
               THEN
                  v_list.intermediary_cedant := v_intm;
               ELSE
                  v_list.intermediary_cedant := v_intm || CHR (10)
                                                || var_intm;
               END IF;
            END LOOP;
         ELSE
            FOR intm IN (SELECT DISTINCT a.intm_no nmbr, b.intm_name nm,
                                         b.ref_intm_cd ref_cd
                                    FROM gicl_intm_itmperil a,
                                         giis_intermediary b
                                   WHERE a.intm_no = b.intm_no
                                     AND a.claim_id = i.claim_id)
            LOOP
               v_intm :=
                   TO_CHAR (intm.nmbr) || '/' || intm.ref_cd || '/'
                   || intm.nm;

               IF var_intm IS NULL
               THEN
                  v_list.intermediary_cedant := v_intm;
               ELSE
                  v_list.intermediary_cedant := v_intm || CHR (10)
                                                || var_intm;
               END IF;
            END LOOP;
         END IF;

         v_list.eff_date := TO_CHAR (i.pol_eff_date, 'MM-DD-YYYY');
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-YYYY');
         v_list.file_date := TO_CHAR (i.clm_file_date, 'MM-DD-YYYY');
         v_list.status := i.clm_stat_desc;
         v_claim_id := i.claim_id;
         v_clm_stat_cd := i.clm_stat_cd;

         FOR k IN (SELECT DISTINCT a.peril_name, b.claim_id, a.peril_cd
                              FROM giis_peril a, gicl_item_peril b
                             WHERE a.line_cd = b.line_cd
                               AND a.peril_cd = b.peril_cd
                               AND b.claim_id = i.claim_id)
         LOOP
            v_list.peril := k.peril_name;

            BEGIN
               v_print := FALSE;

               SELECT DECODE (p_loss_exp, 'E', 'E', 'L')
                 INTO v_loss_exp
                 FROM DUAL;

               v_list.expense_amount :=
                  TO_CHAR (gicls540_pkg.get_loss_amt (k.claim_id,
                                                      k.peril_cd,
                                                      v_loss_exp,
                                                      p_clmstat_cd
                                                     ),
                           '99,999,999,999.99'
                          );
               v_list.RETENTION :=
                  TO_CHAR (gicls540_pkg.amount_per_share_type (k.claim_id,
                                                               k.peril_cd,
                                                               1,
                                                               v_loss_exp,
                                                               p_clmstat_cd
                                                              ),
                           '99,999,999,999.99'
                          );
               v_list.proportional_treaty :=
                  TO_CHAR
                     (gicls540_pkg.amount_per_share_type
                                                  (k.claim_id,
                                                   k.peril_cd,
                                                   giacp.v ('TRTY_SHARE_TYPE'),
                                                   v_loss_exp,
                                                   p_clmstat_cd
                                                  ),
                      '99,999,999,999.99'
                     );
               v_list.non_proportional_treaty :=
                  TO_CHAR
                     (gicls540_pkg.amount_per_share_type
                                              (k.claim_id,
                                               k.peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               v_loss_exp,
                                               p_clmstat_cd
                                              ),
                      '99,999,999,999.99'
                     );
               v_list.facultative :=
                  TO_CHAR
                     (gicls540_pkg.amount_per_share_type
                                                 (k.claim_id,
                                                  k.peril_cd,
                                                  giacp.v ('FACUL_SHARE_TYPE'),
                                                  v_loss_exp,
                                                  p_clmstat_cd
                                                 ),
                      '99,999,999,999.99'
                     );
               PIPE ROW (v_list);
            END;
         END LOOP;

         IF v_print
         THEN
            PIPE ROW (v_list);
         END IF;
      END LOOP;
   END csv_giclr546_e;

   FUNCTION csv_giclr546_le (
      p_clmstat_cd     VARCHAR2,
      p_clmstat_type   VARCHAR2,
      p_end_dt         VARCHAR2,
      p_issue_yy       NUMBER,
      p_line_cd        VARCHAR2,
      p_loss_exp       VARCHAR2,
      p_pol_iss_cd     VARCHAR2,
      p_pol_seq_no     NUMBER,
      p_renew_no       NUMBER,
      p_start_dt       VARCHAR2,
      p_subline_cd     VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN claim_report_tab PIPELINED
   IS
      v_list          claim_report_type;
      v_intm          VARCHAR2 (300)                 := NULL;
      var_intm        VARCHAR2 (300)                 := NULL;
      v_print         BOOLEAN                        := TRUE;
      v_claim_id      gicl_claims.claim_id%TYPE;
      v_loss_exp      VARCHAR2 (2);
      v_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE;
   BEGIN
      FOR i IN
         (SELECT   a.clm_stat_cd, b.clm_stat_desc, a.claim_id,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim_number,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.renew_no), 2, '0') policy_number,
                   a.assured_name, a.intm_no, a.pol_iss_cd, a.pol_eff_date,
                   a.dsp_loss_date, a.clm_file_date
              FROM gicl_claims a, giis_clm_stat b
             WHERE a.clm_stat_cd = b.clm_stat_cd
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
               AND a.pol_iss_cd = NVL (p_pol_iss_cd, a.pol_iss_cd)
               AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
               AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
               AND a.renew_no = NVL (p_renew_no, a.renew_no)
               AND TRUNC (a.clm_file_date) BETWEEN NVL (TO_DATE (p_start_dt,
                                                                 'mm-dd-yyyy'
                                                                ),
                                                        a.clm_file_date
                                                       )
                                               AND NVL (TO_DATE (p_end_dt,
                                                                 'mm-dd-yyyy'
                                                                ),
                                                        a.clm_file_date
                                                       )
               AND check_user_per_iss_cd2 (a.line_cd,
                                           a.iss_cd,
                                           'GICLS540',
                                           p_user_id
                                          ) = 1
          ORDER BY policy_number, claim_number DESC)
      LOOP
         v_list.intermediary_cedant := '';
         v_list.peril := '';
         v_list.claim_amount := '.00';
         v_list.RETENTION := '.00';
         v_list.proportional_treaty := '.00';
         v_list.non_proportional_treaty := '.00';
         v_list.facultative := '.00';
         v_print := TRUE;
         v_list.claim_number := i.claim_number;
         v_list.policy_number := i.policy_number;

         IF i.pol_iss_cd = 'RI'
         THEN
            FOR ri IN (SELECT DISTINCT b.ri_name, a.ri_cd
                                  FROM gicl_claims a, giis_reinsurer b
                                 WHERE a.claim_id = i.claim_id
                                   AND a.ri_cd = b.ri_cd(+))
            LOOP
               v_intm := TO_CHAR (ri.ri_cd) || '/' || ri.ri_name;

               IF var_intm IS NULL
               THEN
                  v_list.intermediary_cedant := v_intm;
               ELSE
                  v_list.intermediary_cedant := v_intm || CHR (10)
                                                || var_intm;
               END IF;
            END LOOP;
         ELSE
            FOR intm IN (SELECT DISTINCT a.intm_no nmbr, b.intm_name nm,
                                         b.ref_intm_cd ref_cd
                                    FROM gicl_intm_itmperil a,
                                         giis_intermediary b
                                   WHERE a.intm_no = b.intm_no
                                     AND a.claim_id = i.claim_id)
            LOOP
               v_intm :=
                   TO_CHAR (intm.nmbr) || '/' || intm.ref_cd || '/'
                   || intm.nm;

               IF var_intm IS NULL
               THEN
                  v_list.intermediary_cedant := v_intm;
               ELSE
                  v_list.intermediary_cedant := v_intm || CHR (10)
                                                || var_intm;
               END IF;
            END LOOP;
         END IF;

         v_list.eff_date := TO_CHAR (i.pol_eff_date, 'MM-DD-YYYY');
         v_list.loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-YYYY');
         v_list.file_date := TO_CHAR (i.clm_file_date, 'MM-DD-YYYY');
         v_list.status := i.clm_stat_desc;
         v_claim_id := i.claim_id;
         v_clm_stat_cd := i.clm_stat_cd;

         FOR k IN (SELECT DISTINCT a.peril_name, b.claim_id, a.peril_cd
                              FROM giis_peril a, gicl_item_peril b
                             WHERE a.line_cd = b.line_cd
                               AND a.peril_cd = b.peril_cd
                               AND b.claim_id = i.claim_id)
         LOOP
            v_list.peril := k.peril_name;

            BEGIN
               v_print := FALSE;

               SELECT DECODE (p_loss_exp, 'E', 'E', 'L')
                 INTO v_loss_exp
                 FROM DUAL;

               v_list.claim_amount :=
                  TO_CHAR (gicls540_pkg.get_loss_amt (k.claim_id,
                                                      k.peril_cd,
                                                      v_loss_exp,
                                                      p_clmstat_cd
                                                     ),
                           '99,999,999,999.99'
                          );
               v_list.RETENTION :=
                  TO_CHAR (gicls540_pkg.amount_per_share_type (k.claim_id,
                                                               k.peril_cd,
                                                               1,
                                                               v_loss_exp,
                                                               p_clmstat_cd
                                                              ),
                           '99,999,999,999.99'
                          );
               v_list.proportional_treaty :=
                  TO_CHAR
                     (gicls540_pkg.amount_per_share_type
                                                  (k.claim_id,
                                                   k.peril_cd,
                                                   giacp.v ('TRTY_SHARE_TYPE'),
                                                   v_loss_exp,
                                                   p_clmstat_cd
                                                  ),
                      '99,999,999,999.99'
                     );
               v_list.non_proportional_treaty :=
                  TO_CHAR
                     (gicls540_pkg.amount_per_share_type
                                              (k.claim_id,
                                               k.peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               v_loss_exp,
                                               p_clmstat_cd
                                              ),
                      '99,999,999,999.99'
                     );
               v_list.facultative :=
                  TO_CHAR
                     (gicls540_pkg.amount_per_share_type
                                                 (k.claim_id,
                                                  k.peril_cd,
                                                  giacp.v ('FACUL_SHARE_TYPE'),
                                                  v_loss_exp,
                                                  p_clmstat_cd
                                                 ),
                      '99,999,999,999.99'
                     );
               PIPE ROW (v_list);
            END;
         END LOOP;

         IF v_print
         THEN
            PIPE ROW (v_list);
         END IF;
      END LOOP;
   END csv_giclr546_le;
END;
/