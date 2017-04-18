CREATE OR REPLACE PACKAGE BODY CPI.giclr208a_pkg
AS
   FUNCTION get_giclr208a_report (
      p_session_id      NUMBER,
      p_claim_id        NUMBER,
      p_intm_break      NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr208a_tab PIPELINED
   IS
      v_list         giclr208a_type;
      v_share_type   giac_parameters.param_value_v%TYPE;
      v_exist        VARCHAR2 (1)                         := 'N';
   BEGIN
      FOR i IN (SELECT   a.buss_source, a.iss_cd, a.line_cd, a.subline_cd,
                         a.claim_id, a.assd_no, a.claim_no, a.policy_no,
                         a.clm_file_date, a.loss_date, a.loss_cat_cd,
                         a.intm_no,
                         SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)
                             ) outstanding_loss
                    FROM gicl_res_brdrx_extr a
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     --AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0 comment out by aliza g. 03/31/3015 for SR 18809
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
                HAVING (SUM(NVL (a.loss_reserve, 0)) - SUM(NVL (a.losses_paid, 0))) > 0 --added by aliza g. 03/31/3015 for SR 18809         
                         )
      LOOP
         v_list.intm_no := NVL (LTRIM (TO_CHAR (i.intm_no, '0009')), ' ');
         v_list.iss_cd := i.iss_cd;
         v_list.line_cd := i.line_cd;
         v_list.claim_number := i.claim_no;
         v_list.policy_number := i.policy_no;
         v_list.clm_file_date := i.clm_file_date;
         v_list.loss_date := i.loss_date;
         v_list.outstanding_loss := i.outstanding_loss;

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
            SELECT pol_eff_date
              INTO v_list.eff_date
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
            v_list.share_type1 := 0;

            FOR shr1 IN (SELECT (  NVL (a.loss_reserve, 0)
                                 - NVL (a.losses_paid, 0)
                                ) outstanding_loss
                           FROM gicl_res_brdrx_ds_extr a
                          WHERE a.session_id = p_session_id
                            AND a.loss_cat_cd = i.loss_cat_cd
                            AND a.grp_seq_no IN (
                                   SELECT a.share_cd
                                     FROM giis_dist_share a
                                    WHERE a.line_cd = i.line_cd
                                      AND a.share_type = 1)
                            AND a.claim_id = i.claim_id
                            AND (  NVL (a.loss_reserve, 0)
                                 - NVL (a.losses_paid, 0)
                                ) > 0)
            LOOP
               v_list.share_type1 :=
                                   v_list.share_type1 + shr1.outstanding_loss;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.share_type1 := 0;
         END;

         BEGIN
            v_list.share_type2 := 0;

            FOR shr2 IN (SELECT (  NVL (a.loss_reserve, 0)
                                 - NVL (a.losses_paid, 0)
                                ) outstanding_loss
                           FROM gicl_res_brdrx_ds_extr a
                          WHERE a.session_id = p_session_id
                            AND a.loss_cat_cd = i.loss_cat_cd
                            AND a.grp_seq_no IN (
                                   SELECT a.share_cd
                                     FROM giis_dist_share a
                                    WHERE a.line_cd = i.line_cd
                                      AND a.share_type = 2)
                            AND a.claim_id = i.claim_id
                            AND (  NVL (a.loss_reserve, 0)
                                 - NVL (a.losses_paid, 0)
                                ) > 0)
            LOOP
               v_list.share_type2 :=
                                   v_list.share_type2 + shr2.outstanding_loss;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.share_type2 := 0;
         END;

         BEGIN
            v_list.share_type3 := 0;

            FOR shr3 IN (SELECT (  NVL (a.loss_reserve, 0)
                                 - NVL (a.losses_paid, 0)
                                ) outstanding_loss
                           FROM gicl_res_brdrx_ds_extr a
                          WHERE a.session_id = p_session_id
                            AND loss_cat_cd = i.loss_cat_cd
                            AND a.grp_seq_no IN (
                                   SELECT a.share_cd
                                     FROM giis_dist_share a
                                    WHERE a.line_cd = i.line_cd
                                      AND a.share_type = 3)
                            AND a.claim_id = i.claim_id
                            AND (  NVL (a.loss_reserve, 0)
                                 - NVL (a.losses_paid, 0)
                                ) > 0)
            LOOP
               v_list.share_type3 :=
                                   v_list.share_type3 + shr3.outstanding_loss;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.share_type3 := 0;
         END;

         BEGIN
            v_list.share_type4 := 0;

            SELECT param_value_v
              INTO v_share_type
              FROM giac_parameters
             WHERE param_name LIKE 'XOL_TRTY_SHARE_TYPE';

            FOR shr4 IN (SELECT (  NVL (a.loss_reserve, 0)
                                 - NVL (a.losses_paid, 0)
                                ) outstanding_loss
                           --INTO v_list.share_type4
                           FROM gicl_res_brdrx_ds_extr a
                          WHERE a.session_id = p_session_id
                            AND loss_cat_cd = i.loss_cat_cd
                            AND a.grp_seq_no IN (
                                   SELECT a.share_cd
                                     FROM giis_dist_share a
                                    WHERE a.line_cd = i.line_cd
                                      AND a.share_type = v_share_type)
                            AND a.claim_id = i.claim_id
                            AND (  NVL (a.loss_reserve, 0)
                                 - NVL (a.losses_paid, 0)
                                ) > 0)
            LOOP
               v_list.share_type4 :=
                                   v_list.share_type4 + shr4.outstanding_loss;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.share_type4 := 0;
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
   END get_giclr208a_report;
   
	FUNCTION get_giclr208a_company_details(
		p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
	) RETURN giclr208a_company_tab PIPELINED
	AS
		v_rec			giclr208a_company_type;
	BEGIN
		IF v_rec.date_as_of IS NULL AND p_date_as_of IS NOT NULL THEN
			v_rec.date_as_of := TRIM (TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'), 'Month'))
									  || TO_CHAR (TO_DATE (p_date_as_of, 'MM-DD-YYYY'), ' DD, YYYY');
		END IF;

		IF v_rec.date_from IS NULL AND p_date_from IS NOT NULL THEN
			v_rec.date_from := TRIM (TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), 'Month'))
									 || TO_CHAR (TO_DATE (p_date_from, 'MM-DD-YYYY'), ' DD, YYYY');
			v_rec.date_to := TRIM (TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), 'Month'))
								  || TO_CHAR (TO_DATE (p_date_to, 'MM-DD-YYYY'), ' DD, YYYY');
		END IF;
		
		v_rec.company_name := giisp.v ('COMPANY_NAME');
		v_rec.company_address := giisp.v ('COMPANY_ADDRESS');
		
		PIPE ROW(v_rec);
	END;
END;
/


