CREATE OR REPLACE PACKAGE BODY CPI.giclr208ar_pkg
AS
   FUNCTION get_giclr208ar_rep (
      p_session_id   VARCHAR2,
      p_claim_id     NUMBER,
      p_date_as_of   VARCHAR2,
      p_date_from    VARCHAR2,
      p_date_to      VARCHAR2
   )
      RETURN rep_tab PIPELINED
   IS
      v_list         rep_type;
      v_share_type   NUMBER       := 0;
      v_exist        VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT   a.buss_source, a.iss_cd, a.line_cd, a.subline_cd,
                         a.claim_id, a.assd_no, a.claim_no, a.policy_no,
                         a.clm_file_date, a.loss_date, a.loss_cat_cd,
                         a.intm_no,
                         SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)
                             ) outstanding_loss
                    FROM cpi.gicl_res_brdrx_extr a
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) >
                                                                             0
                GROUP BY a.buss_source,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd,
                         a.claim_id,
                         a.assd_no,
                         a.claim_no,
                         a.policy_no,
                         a.clm_file_date,
                         a.loss_date,
                         a.loss_cat_cd,
                         a.intm_no
                ORDER BY line_cd, claim_id)
      LOOP
         v_list.session_id := p_session_id;
         v_list.intm_no := NVL (LTRIM (TO_CHAR (i.intm_no, '0009')), ' ');
         v_list.iss_cd := i.iss_cd;
         v_list.line_cd := i.line_cd;
         v_list.claim_id := i.claim_id;
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.clm_file_date := i.clm_file_date;
         v_list.loss_date := i.loss_date;
         v_list.loss_cat_cd := i.loss_cat_cd;
         v_list.outstanding_loss := i.outstanding_loss;
         v_list.intm_name := NULL;

         FOR gi IN (SELECT intm_name
                      FROM giis_intermediary
                     WHERE intm_no = i.intm_no)
         LOOP
            v_list.intm_name := gi.intm_name;
         END LOOP;

         v_list.iss_name := NULL;

         FOR gi IN (SELECT iss_name
                      FROM giis_issource
                     WHERE iss_cd = i.iss_cd)
         LOOP
            v_list.iss_name := gi.iss_name;
         END LOOP;

         v_list.line_name := NULL;

         FOR gi IN (SELECT line_name
                      FROM giis_line
                     WHERE line_cd = i.line_cd)
         LOOP
            v_list.line_name := gi.line_name;
         END LOOP;

         v_list.eff_date := NULL;

         FOR gi IN (SELECT pol_eff_date
                      FROM gicl_claims
                     WHERE claim_id = i.claim_id)
         LOOP
            v_list.eff_date := gi.pol_eff_date;
         END LOOP;

         v_list.assd_name := NULL;

         FOR gi IN (SELECT assd_name
                      FROM giis_assured
                     WHERE assd_no = i.assd_no)
         LOOP
            v_list.assd_name := gi.assd_name;
         END LOOP;

         v_list.loss_cat_des := NULL;

         FOR gi IN (SELECT loss_cat_des
                      FROM giis_loss_ctgry
                     WHERE line_cd = i.line_cd AND loss_cat_cd = i.loss_cat_cd)
         LOOP
            v_list.loss_cat_des := gi.loss_cat_des;
         END LOOP;

         BEGIN
            v_list.net_loss := 0;

            SELECT SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0))
                                                                     net_loss
              INTO v_list.net_loss
              FROM gicl_res_brdrx_ds_extr a
             WHERE a.session_id = p_session_id
               AND a.loss_cat_cd = i.loss_cat_cd
               AND a.grp_seq_no IN (
                              SELECT a.share_cd
                                FROM giis_dist_share a
                               WHERE a.line_cd = i.line_cd
                                     AND a.share_type = 1)
               AND a.claim_id = i.claim_id
               AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0;

            IF v_list.net_loss IS NULL
            THEN
               v_list.net_loss := 0;
            END IF;

            FOR j IN (SELECT SUM (a.shr_recovery_amt) rec_amt
                        FROM gicl_rcvry_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND a.claim_id = i.claim_id
                         AND a.grp_seq_no IN (
                                SELECT b.share_cd
                                  FROM giis_dist_share b
                                 WHERE b.line_cd = i.line_cd
                                   AND b.share_type = 1)
                         AND a.payee_type = 'L')
            LOOP
               IF j.rec_amt IS NOT NULL
               THEN
                  v_list.net_loss := v_list.net_loss - j.rec_amt;
               END IF;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.net_loss := 0;
         END;

         BEGIN
            v_list.prop_treaty := 0;

            SELECT SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0))
                                                                  prop_treaty
              INTO v_list.prop_treaty
              FROM gicl_res_brdrx_ds_extr a
             WHERE a.session_id = p_session_id
               AND a.loss_cat_cd = i.loss_cat_cd
               AND a.grp_seq_no IN (
                              SELECT a.share_cd
                                FROM giis_dist_share a
                               WHERE a.line_cd = i.line_cd
                                     AND a.share_type = 2)
               AND a.claim_id = i.claim_id
               AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0;

            IF v_list.prop_treaty IS NULL
            THEN
               v_list.prop_treaty := 0;
            END IF;

            FOR j IN (SELECT SUM (a.shr_recovery_amt) rec_amt
                        FROM gicl_rcvry_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND a.claim_id = i.claim_id
                         AND a.grp_seq_no IN (
                                SELECT b.share_cd
                                  FROM giis_dist_share b
                                 WHERE b.line_cd = i.line_cd
                                   AND b.share_type = 2)
                         AND a.payee_type = 'L')
            LOOP
               IF j.rec_amt IS NOT NULL
               THEN
                  v_list.prop_treaty := v_list.prop_treaty - j.rec_amt;
               END IF;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.prop_treaty := 0;
         END;

         BEGIN
            v_list.facul := 0;

            SELECT SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0))
                                                                        facul
              INTO v_list.facul
              FROM gicl_res_brdrx_ds_extr a
             WHERE a.session_id = p_session_id
               AND loss_cat_cd = i.loss_cat_cd
               AND a.grp_seq_no IN (
                              SELECT a.share_cd
                                FROM giis_dist_share a
                               WHERE a.line_cd = i.line_cd
                                     AND a.share_type = 3)
               AND a.claim_id = i.claim_id
               AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0;

            IF v_list.facul IS NULL
            THEN
               v_list.facul := 0;
            END IF;

            FOR j IN (SELECT SUM (a.shr_recovery_amt) rec_amt
                        FROM gicl_rcvry_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND a.claim_id = i.claim_id
                         AND a.grp_seq_no IN (
                                SELECT b.share_cd
                                  FROM giis_dist_share b
                                 WHERE b.line_cd = i.line_cd
                                   AND b.share_type = 3)
                         AND a.payee_type = 'L')
            LOOP
               IF j.rec_amt IS NOT NULL
               THEN
                  v_list.facul := v_list.facul - j.rec_amt;
               END IF;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.facul := 0;
         END;

         IF v_share_type = 0
         THEN
            BEGIN
               SELECT param_value_v
                 INTO v_share_type
                 FROM giac_parameters
                WHERE param_name LIKE 'XOL_TRTY_SHARE_TYPE';
            END;
         END IF;

         BEGIN
            v_list.non_prop_treaty := 0;

            SELECT SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0))
                                                              non_prop_treaty
              INTO v_list.non_prop_treaty
              FROM gicl_res_brdrx_ds_extr a
             WHERE a.session_id = p_session_id
               AND loss_cat_cd = i.loss_cat_cd
               AND a.grp_seq_no IN (
                      SELECT a.share_cd
                        FROM giis_dist_share a
                       WHERE a.line_cd = i.line_cd
                         AND a.share_type = v_share_type)
               AND a.claim_id = i.claim_id
               AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0;

            IF v_list.non_prop_treaty IS NULL
            THEN
               v_list.non_prop_treaty := 0;
            END IF;

            FOR j IN (SELECT SUM (a.shr_recovery_amt) rec_amt
                        FROM gicl_rcvry_brdrx_ds_extr a
                       WHERE a.session_id = p_session_id
                         AND a.claim_id = i.claim_id
                         AND a.grp_seq_no IN (
                                SELECT b.share_cd
                                  FROM giis_dist_share b
                                 WHERE b.line_cd = i.line_cd
                                   AND b.share_type = v_share_type)
                         AND a.payee_type = 'L')
            LOOP
               IF j.rec_amt IS NOT NULL
               THEN
                  v_list.non_prop_treaty :=
                                           v_list.non_prop_treaty - j.rec_amt;
               END IF;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.non_prop_treaty := 0;
         END;

         IF v_list.date_as_of IS NULL AND p_date_as_of IS NOT NULL
         THEN
            v_list.date_as_of :=
                  TRIM (TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'),
                                 'Month')
                       )
               || TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF v_list.date_from IS NULL AND p_date_from IS NOT NULL
         THEN
            v_list.date_from :=
                  TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')
                       )
               || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.date_to :=
                  TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month'))
               || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF v_list.company_name IS NULL
         THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;

         v_exist := 'Y';
         v_list.exist := 'Y';
         PIPE ROW (v_list);
      END LOOP;

      IF v_exist = 'N'
      THEN
         IF v_list.date_as_of IS NULL AND p_date_as_of IS NOT NULL
         THEN
            v_list.date_as_of :=
                  TRIM (TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'),
                                 'Month')
                       )
               || TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF v_list.date_from IS NULL AND p_date_from IS NOT NULL
         THEN
            v_list.date_from :=
                  TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')
                       )
               || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.date_to :=
                  TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month'))
               || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF v_list.company_name IS NULL
         THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;

         v_list.exist := 'N';
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END;
END;
/


