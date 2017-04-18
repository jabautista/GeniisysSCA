CREATE OR REPLACE PACKAGE BODY CPI.giclr208l_pkg
AS
   FUNCTION get_giclr208l_report (
      p_session_id   NUMBER,
      p_claim_id     NUMBER,
      p_intm_break   NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to     VARCHAR2
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
   BEGIN
      v_list.exist := 'N';
   
      FOR i IN (SELECT   a.brdrx_record_id, a.buss_source, a.iss_cd,
                         a.line_cd, a.subline_cd, a.claim_id, a.assd_no,
                         a.claim_no, a.policy_no, a.clm_file_date,
                         a.loss_date, a.loss_cat_cd, a.item_no,
                         a.grouped_item_no, a.peril_cd, a.intm_no,
                         NVL (a.tsi_amt, 0) tsi_amt,
                         (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)
                         ) outstanding_loss
                    FROM gicl_res_brdrx_extr a
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0
                ORDER BY a.claim_no)
      LOOP
         v_list.intm_ri := '';
         v_list.intm_no := NVL (LTRIM (TO_CHAR (i.intm_no, '0009')), ' ');
         v_list.claim_number := i.claim_no;
         v_list.policy_number := i.policy_no;
         v_list.line_cd := i.line_cd;
         v_list.loss_date := i.loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.item :=
            get_gpa_item_title (i.claim_id,
                                i.line_cd,
                                i.item_no,
                                i.grouped_item_no
                               );
         v_list.tsi_amt := i.tsi_amt;
         v_list.outstanding_loss := i.outstanding_loss;

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
               FOR r IN (SELECT DISTINCT a.ri_cd ri_cd, b.ri_name ri_name
                                    FROM gicl_claims a, giis_reinsurer b
                                   WHERE a.ri_cd = b.ri_cd
                                     AND a.claim_id = i.claim_id)
               LOOP
                  v_list.intm_ri := TO_CHAR (r.ri_cd) || '/' || r.ri_name;
               END LOOP;
            END;
         ELSE
            IF p_intm_break = 1
            THEN
               BEGIN
                  FOR intm IN (SELECT DISTINCT a.intm_no intm_no,
                                               b.intm_name intm_name,
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
                           TO_CHAR (intm.intm_no)
                        || '/'
                        || intm.ref_intm_cd
                        || '/'
                        || intm.intm_name;
                  END LOOP;
               END;
            ELSIF p_intm_break = 0
            THEN
               BEGIN
                  FOR m IN (SELECT DISTINCT a.intm_no, b.intm_name,
                                            b.ref_intm_cd
                                       FROM gicl_intm_itmperil a,
                                            giis_intermediary b
                                      WHERE a.intm_no = b.intm_no
                                        AND a.claim_id = i.claim_id
                                        AND a.item_no = i.item_no
                                        AND a.peril_cd = i.peril_cd)
                  LOOP
                     v_list.intm_ri := TO_CHAR (m.intm_no)
                                         || '/'
                                         || m.ref_intm_cd
                                         || '/'
                                         || m.intm_name
                                         || CHR (10)
                                         || v_list.intm_ri;
                  END LOOP;
               END;
            END IF;
         END IF;

         BEGIN v_list.share_type2 := 0;

            FOR s2 IN (SELECT (NVL (a.loss_reserve, 0)
                               - NVL (a.losses_paid, 0)
                              ) outstanding_loss
                         --INTO v_list.share_type2
                         FROM gicl_res_brdrx_ds_extr a
                        WHERE a.session_id = p_session_id
                          AND a.grp_seq_no IN (
                                 SELECT a.share_cd
                                   FROM giis_dist_share a
                                  WHERE a.line_cd = i.line_cd
                                    AND a.share_type = 2)
                          AND a.claim_id = i.claim_id
                          AND a.item_no = i.item_no
                          AND a.peril_cd = i.peril_cd
                          AND (NVL (a.loss_reserve, 0)
                               - NVL (a.losses_paid, 0)
                              ) > 0)
            LOOP
               v_list.share_type2 := v_list.share_type2 + s2.outstanding_loss;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.share_type2 := 0;
         END;

         BEGIN
            v_list.share_type3 := 0;

            FOR s3 IN (SELECT (NVL (a.loss_reserve, 0)
                               - NVL (a.losses_paid, 0)
                              ) outstanding_loss
                         FROM gicl_res_brdrx_ds_extr a
                        WHERE a.session_id = p_session_id
                          AND a.grp_seq_no IN (
                                 SELECT a.share_cd
                                   FROM giis_dist_share a
                                  WHERE a.line_cd = i.line_cd
                                    AND a.share_type = 3)
                          AND a.claim_id = i.claim_id
                          AND a.item_no = i.item_no
                          AND a.peril_cd = i.peril_cd
                          AND (NVL (a.loss_reserve, 0)
                               - NVL (a.losses_paid, 0)
                              ) > 0)
            LOOP
               v_list.share_type3 := v_list.share_type3 + s3.outstanding_loss;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.share_type3 := 0;
         END;

         BEGIN
            v_list.share_type1 := 0;

            FOR s1 IN (SELECT (NVL (a.loss_reserve, 0)
                               - NVL (a.losses_paid, 0)
                              ) outstanding_loss
                         FROM gicl_res_brdrx_ds_extr a
                        WHERE a.session_id = p_session_id
                          AND a.grp_seq_no IN (
                                 SELECT a.share_cd
                                   FROM giis_dist_share a
                                  WHERE a.line_cd = i.line_cd
                                    AND a.share_type = 1)
                          AND a.claim_id = i.claim_id
                          AND a.item_no = i.item_no
                          AND a.peril_cd = i.peril_cd
                          AND (NVL (a.loss_reserve, 0)
                               - NVL (a.losses_paid, 0)
                              ) > 0)
            LOOP
               v_list.share_type1 := v_list.share_type1 + s1.outstanding_loss;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.share_type1 := 0;
         END;

         BEGIN
            v_list.share_type4 := 0;

            FOR s4 IN (SELECT (NVL (a.loss_reserve, 0)
                               - NVL (a.losses_paid, 0)
                              ) outstanding_loss
                         FROM gicl_res_brdrx_ds_extr a
                        WHERE a.session_id = p_session_id
                          AND a.grp_seq_no IN (
                                 SELECT a.share_cd
                                   FROM giis_dist_share a
                                  WHERE a.line_cd = i.line_cd
                                    AND a.share_type = 4)
                          AND a.claim_id = i.claim_id
                          AND a.item_no = i.item_no
                          AND a.peril_cd = i.peril_cd
                          AND (NVL (a.loss_reserve, 0)
                               - NVL (a.losses_paid, 0)
                              ) > 0)
            LOOP
               v_list.share_type4 := v_list.share_type4 + s4.outstanding_loss;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.share_type4 := 0;
         END;

         BEGIN
            SELECT b.clm_stat_desc
              INTO v_list.clm_stat_desc
              FROM gicl_claims a, giis_clm_stat b
             WHERE a.claim_id = i.claim_id AND b.clm_stat_cd = a.clm_stat_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.clm_stat_desc := NULL;
         END;

         BEGIN
            SELECT peril_name
              INTO v_list.peril
              FROM giis_peril
             WHERE peril_cd = i.peril_cd AND line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.peril := NULL;
         END;

         BEGIN
            SELECT    NVL (loss_loc1, ' ')
                   || ' '
                   || NVL (loss_loc2, ' ')
                   || ' '
                   || NVL (loss_loc3, ' ')
              INTO v_list.loss_location
              FROM gicl_claims
             WHERE loss_cat_cd = i.loss_cat_cd AND claim_id = i.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.loss_location := NULL;
         END;

         BEGIN
            SELECT loss_cat_des
              INTO v_list.loss_cat_desc
              FROM giis_loss_ctgry
             WHERE line_cd = i.line_cd AND loss_cat_cd = i.loss_cat_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.loss_cat_desc := NULL;
         END;

         BEGIN
            SELECT pol_eff_date, expiry_date
              INTO v_list.eff_date, v_list.expiry_date
              FROM gicl_claims
             WHERE claim_id = i.claim_id;
         END;

         BEGIN
            SELECT assd_name
              INTO v_list.assd_name
              FROM giis_assured
             WHERE assd_no = i.assd_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.assd_name := NULL;
         END;

         BEGIN
            SELECT line_name
              INTO v_list.line
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.line := NULL;
         END;

         BEGIN
            SELECT iss_name
              INTO v_list.branch
              FROM giis_issource
             WHERE iss_cd = i.iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.branch := NULL;
         END;

         BEGIN
            SELECT intm_name
              INTO v_list.intm_name
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.intm_name := ' ';
         END;
         
         IF v_list.date_as_of IS NULL AND p_date_as_of IS NOT NULL THEN
            v_list.date_as_of := TRIM(TO_CHAR(TO_DATE (p_date_as_of, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;
         
         IF v_list.date_from IS NULL AND p_date_from IS NOT NULL THEN
            v_list.date_from := TRIM(TO_CHAR(TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.date_to := TRIM(TO_CHAR(TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;

         IF v_list.company_name IS NULL
         THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;

         v_list.exist := 'Y';
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_list.exist = 'N' THEN
         IF v_list.date_as_of IS NULL AND p_date_as_of IS NOT NULL THEN
            v_list.date_as_of := TRIM(TO_CHAR(TO_DATE (p_date_as_of, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;
         
         IF v_list.date_from IS NULL AND p_date_from IS NOT NULL THEN
            v_list.date_from := TRIM(TO_CHAR(TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.date_to := TRIM(TO_CHAR(TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;
      
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');  
         
         PIPE ROW (v_list); 
      END IF;

      RETURN;
   END get_giclr208l_report;
END;
/


