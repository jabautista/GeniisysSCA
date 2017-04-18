CREATE OR REPLACE PACKAGE BODY CPI.giclr208e_pkg
AS
/*
    **  Created by   :  Ildefonso L. Ellarina Jr.
    **  Date Created : 04.08.2013
    **  Reference By : GICLR208E - OUTSTANDING LOSS EXPENSE DISTRIBUTION REGISTER
    */
   FUNCTION get_giclr208e_report (
      p_claim_id      NUMBER,
      p_session_id    VARCHAR2,
      p_intm_break    NUMBER,
      p_os_date       NUMBER,
      p_date_option   NUMBER,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_as_of_date    VARCHAR2
   )
      RETURN get_giclr208e_report_tab PIPELINED
   IS
      v_detail       get_giclr208e_report_type;
      v_intm_name    VARCHAR2 (240);
      v_pol_iss_cd   gicl_claims.pol_iss_cd%TYPE;
      v_intm_ri      VARCHAR2 (10000);
      v_clm_stat     giis_clm_stat.clm_stat_desc%TYPE;
      v_clm_stat1    giis_clm_stat.clm_stat_desc%TYPE;
      v_param        VARCHAR2 (200);
      v_exist        VARCHAR2 (1)                       := 'N';
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_detail.cf_company
           FROM giac_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_detail.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_detail.cf_com_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_detail.cf_com_address := NULL;
      END;

      BEGIN
         IF p_intm_break = 0
         THEN
            v_detail.report_title :=
                'OUTSTANDING LOSS EXPENSE DISTRIBUTION REGISTER - PER BRANCH';
         ELSIF p_intm_break = 1
         THEN
            v_detail.report_title :=
               'OUTSTANDING LOSS EXPENSE DISTRIBUTION REGISTER - PER INTERMEDIARY';
         END IF;
      END;

      BEGIN
         BEGIN
            SELECT DECODE (p_os_date,
                           1, 'Loss Date',
                           2, 'Claim File Date',
                           3, 'Booking Month'
                          )
              INTO v_param
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_param := NULL;
         END;

         v_detail.cf_param_date := '(Based on ' || v_param || ')';
      END;

      BEGIN
         IF p_date_option = 1
         THEN
            BEGIN
               SELECT    'from '
                      || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                                  'fmMonth DD, YYYY'
                                 )
                      || ' to '
                      || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'),
                                  'fmMonth DD, YYYY'
                                 )
                 INTO v_detail.cf_date
                 FROM DUAL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_detail.cf_date := NULL;
            END;
         ELSIF p_date_option = 2
         THEN
            BEGIN
               SELECT    'as of '
                      || TO_CHAR (TO_DATE (p_as_of_date, 'MM-DD-YYYY'),
                                  'fmMonth DD, YYYY'
                                 )
                 INTO v_detail.cf_date
                 FROM DUAL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_detail.cf_date := NULL;
            END;
         END IF;
      END;

      FOR txn_temp_rec IN (SELECT   a.brdrx_record_id, a.buss_source,
                                    a.iss_cd, a.line_cd, a.subline_cd,
                                    a.claim_id, a.assd_no, a.claim_no,
                                    a.policy_no, a.clm_file_date, a.loss_date,
                                    a.loss_cat_cd, a.item_no,
                                    a.grouped_item_no, a.peril_cd, a.intm_no,
                                    NVL (a.tsi_amt, 0) tsi_amt,
                                    (  NVL (a.expense_reserve, 0)
                                     - NVL (a.expenses_paid, 0)
                                    ) outstanding_loss
                               FROM gicl_res_brdrx_extr a
                              WHERE a.session_id = p_session_id
                                AND a.claim_id = NVL (p_claim_id, a.claim_id)
                                AND (  NVL (a.expense_reserve, 0)
                                     - NVL (a.expenses_paid, 0)
                                    ) > 0
                           ORDER BY a.intm_no, a.iss_cd, a.line_cd,
                                    a.claim_no)
      LOOP
         v_detail.claim_no := txn_temp_rec.claim_no;
         v_detail.policy_no := txn_temp_rec.policy_no;
         v_detail.loss_date := txn_temp_rec.loss_date;
         v_detail.clm_file_date := txn_temp_rec.clm_file_date;
         v_detail.item_no := txn_temp_rec.item_no;
         v_detail.grouped_item_no := txn_temp_rec.grouped_item_no;
         v_detail.tsi_amt := txn_temp_rec.tsi_amt;
         v_detail.outstanding_loss := txn_temp_rec.outstanding_loss;
         v_detail.intm_no := txn_temp_rec.intm_no;
         v_detail.iss_cd := txn_temp_rec.iss_cd;
         v_detail.line_cd := txn_temp_rec.line_cd;
         v_detail.cf_intm_name := ' - ';
         v_detail.claim_id := txn_temp_rec.claim_id;
         v_detail.item_name :=
            get_gpa_item_title (txn_temp_rec.claim_id,
                                txn_temp_rec.line_cd,
                                txn_temp_rec.item_no,
                                NVL (txn_temp_rec.grouped_item_no, 0)
                               );

         BEGIN
            FOR i IN (SELECT intm_name
                        FROM giis_intermediary
                       WHERE intm_no = txn_temp_rec.intm_no)
            LOOP
               v_detail.cf_intm_name :=
                                 txn_temp_rec.intm_no || ' - ' || i.intm_name;
            END LOOP;
         END;

         BEGIN
            FOR i IN (SELECT iss_name
                        FROM giis_issource
                       WHERE iss_cd = txn_temp_rec.iss_cd)
            LOOP
               v_detail.iss_name := i.iss_name;
            END LOOP;
         END;

         BEGIN
            FOR i IN (SELECT line_name
                        FROM giis_line
                       WHERE line_cd = txn_temp_rec.line_cd)
            LOOP
               v_detail.line_name := i.line_name;
            END LOOP;
         END;

         BEGIN
            FOR i IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_no = txn_temp_rec.assd_no)
            LOOP
               v_detail.assd_name := i.assd_name;
            END LOOP;
         END;

         BEGIN
            /* Modified by: Cherrie
             * Modified date: 07192012
             * Remarks: add "distinct" on loop statement to prevent the function in returning
             * large data caused by concatenating loop's returned queries. The select may return
             * multiple but same data.
             */
            BEGIN
               SELECT pol_iss_cd
                 INTO v_pol_iss_cd
                 FROM gicl_claims
                WHERE claim_id = txn_temp_rec.claim_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_pol_iss_cd := NULL;
            END;

            IF v_pol_iss_cd = giacp.v ('RI_ISS_CD')
            THEN
               BEGIN
                  FOR r IN (SELECT DISTINCT a.ri_cd ri_cd, b.ri_name ri_name
                                       --add "distinct" by cherrie
                            FROM            gicl_claims a, giis_reinsurer b
                                      WHERE a.ri_cd = b.ri_cd
                                        AND a.claim_id = txn_temp_rec.claim_id)
                  LOOP
                     v_intm_ri := TO_CHAR (r.ri_cd) || '/' || r.ri_name;
                  END LOOP;
               END;
            ELSE
               IF p_intm_break = 1
               THEN
                  BEGIN
                     FOR i IN (SELECT DISTINCT a.intm_no intm_no,
                                               b.intm_name intm_name,
                                               
                                               --add "distinct" by cherrie
                                               b.ref_intm_cd ref_intm_cd
                                          FROM gicl_res_brdrx_extr a,
                                               giis_intermediary b
                                         WHERE a.intm_no = b.intm_no
                                           AND a.session_id = p_session_id
                                           AND a.claim_id =
                                                         txn_temp_rec.claim_id
                                           AND a.item_no =
                                                          txn_temp_rec.item_no
                                           AND a.peril_cd =
                                                         txn_temp_rec.peril_cd
                                           AND a.intm_no =
                                                          txn_temp_rec.intm_no)
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
                     FOR m IN (SELECT DISTINCT a.intm_no, b.intm_name,
                                               b.ref_intm_cd
                                          --add "distinct" by cherrie
                               FROM            gicl_intm_itmperil a,
                                               giis_intermediary b
                                         WHERE a.intm_no = b.intm_no
                                           AND a.claim_id =
                                                         txn_temp_rec.claim_id
                                           AND a.item_no =
                                                          txn_temp_rec.item_no
                                           AND a.peril_cd =
                                                         txn_temp_rec.peril_cd)
                     LOOP
                        v_intm_ri :=
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

            v_detail.cf_intm_ri := v_intm_ri;
         END;

         BEGIN
            FOR i IN (SELECT pol_eff_date
                        FROM gicl_claims
                       WHERE claim_id = txn_temp_rec.claim_id)
            LOOP
               v_detail.pol_eff_date := i.pol_eff_date;
            END LOOP;
         END;

         BEGIN
            FOR i IN (SELECT expiry_date
                        FROM gicl_claims
                       WHERE claim_id = txn_temp_rec.claim_id)
            LOOP
               v_detail.expiry_date := i.expiry_date;
            END LOOP;
         END;

         BEGIN
            FOR i IN (SELECT loss_cat_des
                        FROM giis_loss_ctgry
                       WHERE line_cd = txn_temp_rec.line_cd
                         AND loss_cat_cd = txn_temp_rec.loss_cat_cd)
            LOOP
               v_detail.loss_cat_des := i.loss_cat_des;
            END LOOP;
         END;

         BEGIN
            FOR i IN (SELECT loss_loc1, loss_loc2, loss_loc3
                        FROM gicl_claims
                       WHERE loss_cat_cd = txn_temp_rec.loss_cat_cd
                         AND claim_id = txn_temp_rec.claim_id)
            LOOP
               v_detail.LOCATION :=
                      i.loss_loc1 || ' ' || i.loss_loc2 || ' ' || i.loss_loc3;
            END LOOP;
         END;

         BEGIN
            FOR i IN (SELECT peril_name
                        FROM giis_peril
                       WHERE peril_cd = txn_temp_rec.peril_cd
                         AND line_cd = txn_temp_rec.line_cd)
            LOOP
               v_detail.peril_name := i.peril_name;
            END LOOP;
         END;

         BEGIN
            FOR i IN
               (SELECT b.clm_stat_desc
                  FROM gicl_clm_loss_exp a, giis_clm_stat b
                 WHERE claim_id = txn_temp_rec.claim_id
                   AND NVL (cancel_sw, 'N') = 'N'
                   AND item_no = txn_temp_rec.item_no
                   AND peril_cd = txn_temp_rec.peril_cd
                   AND clm_loss_id IN (
                          SELECT MAX (clm_loss_id)
                            FROM gicl_clm_loss_exp
                           WHERE claim_id = txn_temp_rec.claim_id
                             AND NVL (cancel_sw, 'N') = 'N'
                             AND item_no = txn_temp_rec.item_no
                             AND peril_cd = txn_temp_rec.peril_cd)
                   AND b.clm_stat_cd = a.item_stat_cd)
            LOOP
               v_clm_stat := i.clm_stat_desc;
            END LOOP;

            IF v_clm_stat IS NULL
            THEN
               BEGIN
                  SELECT b.clm_stat_desc
                    INTO v_clm_stat1
                    FROM gicl_claims a, giis_clm_stat b
                   WHERE a.claim_id = txn_temp_rec.claim_id
                     AND b.clm_stat_cd = a.clm_stat_cd;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     v_clm_stat1 := NULL;
               END;

               v_detail.claim_status := v_clm_stat1;
            ELSE
               v_detail.claim_status := v_clm_stat;
            END IF;
         END;

         BEGIN
            v_detail.cf_share_type1 := 0;

            FOR i IN
               (SELECT (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)
                       ) outstanding_loss
                  FROM gicl_res_brdrx_ds_extr a
                 WHERE a.session_id = p_session_id
                   AND a.grp_seq_no IN (
                          SELECT a.share_cd
                            FROM giis_dist_share a
                           WHERE a.line_cd = txn_temp_rec.line_cd
                             AND a.share_type = 1)
                   AND a.claim_id = NVL (txn_temp_rec.claim_id, a.claim_id)
                   AND a.item_no = txn_temp_rec.item_no
                   AND a.peril_cd = txn_temp_rec.peril_cd
                   AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)
                       ) > 0)
            LOOP
               v_detail.cf_share_type1 :=
                                 i.outstanding_loss + v_detail.cf_share_type1;
            END LOOP;
         END;

         BEGIN
            v_detail.cf_share_type2 := 0;

            FOR i IN
               (SELECT (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)
                       ) outstanding_loss
                  FROM gicl_res_brdrx_ds_extr a
                 WHERE a.session_id = p_session_id
                   AND a.grp_seq_no IN (
                          SELECT a.share_cd
                            FROM giis_dist_share a
                           WHERE a.line_cd = txn_temp_rec.line_cd
                             AND a.share_type = 2)
                   AND a.claim_id = NVL (txn_temp_rec.claim_id, a.claim_id)
                   AND a.item_no = txn_temp_rec.item_no
                   AND a.peril_cd = txn_temp_rec.peril_cd
                   AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)
                       ) > 0)
            LOOP
               v_detail.cf_share_type2 :=
                                 i.outstanding_loss + v_detail.cf_share_type2;
            END LOOP;
         END;

         BEGIN
            v_detail.cf_share_type3 := 0;

            FOR i IN
               (SELECT (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)
                       ) outstanding_loss
                  FROM gicl_res_brdrx_ds_extr a
                 WHERE a.session_id = p_session_id
                   AND a.grp_seq_no IN (
                          SELECT a.share_cd
                            FROM giis_dist_share a
                           WHERE a.line_cd = txn_temp_rec.line_cd
                             AND a.share_type = 3)
                   AND a.claim_id = NVL (txn_temp_rec.claim_id, a.claim_id)
                   AND a.item_no = txn_temp_rec.item_no
                   AND a.peril_cd = txn_temp_rec.peril_cd
                   AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)
                       ) > 0)
            LOOP
               v_detail.cf_share_type3 :=
                                 i.outstanding_loss + v_detail.cf_share_type3;
            END LOOP;
         END;

         BEGIN
            v_detail.cf_share_type4 := 0;

            FOR i IN
               (SELECT (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)
                       ) outstanding_loss
                  FROM gicl_res_brdrx_ds_extr a
                 WHERE a.session_id = p_session_id
                   AND a.grp_seq_no IN (
                          SELECT a.share_cd
                            FROM giis_dist_share a
                           WHERE a.line_cd = txn_temp_rec.line_cd
                             AND a.share_type = 4)
                   AND a.claim_id = NVL (txn_temp_rec.claim_id, a.claim_id)
                   AND a.item_no = txn_temp_rec.item_no
                   AND a.peril_cd = txn_temp_rec.peril_cd
                   AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)
                       ) > 0)
            LOOP
               v_detail.cf_share_type4 :=
                                 i.outstanding_loss + v_detail.cf_share_type4;
            END LOOP;
         END;

         BEGIN
            SELECT (  NVL (v_detail.cf_share_type2, 0)
                    + NVL (v_detail.cf_share_type3, 0)
                   )
              INTO v_detail.RECOVERABLE
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_detail.RECOVERABLE := NULL;
         END;

         v_exist := 'Y';
         v_detail.exist := 'Y';
         PIPE ROW (v_detail);
      END LOOP;

      IF v_exist = 'N'
      THEN
         v_detail.exist := 'N';
         PIPE ROW (v_detail);
      END IF;

      RETURN;
   END get_giclr208e_report;
END giclr208e_pkg;
/


