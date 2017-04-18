CREATE OR REPLACE PACKAGE BODY CPI.gicl_mc_evaluation_pkg
AS
   FUNCTION get_mc_evaluation_info (
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_clm_yy       gicl_claims.clm_yy%TYPE,
      p_clm_seq_no   gicl_claims.clm_seq_no%TYPE,
      p_user_id      VARCHAR2
   )
      RETURN mc_evaluation_info_tab PIPELINED
   IS
      v_mc   mc_evaluation_info_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT DISTINCT gc.claim_id, gc.line_cd,
                                        gc.subline_cd, gc.iss_cd, gc.clm_yy,
                                        gc.clm_seq_no, gc.clm_file_date,
                                        gc.pol_iss_cd, gc.issue_yy,
                                        gc.pol_seq_no, gc.renew_no,
                                        gc.assured_name, gc.loss_date,
                                        gc.assd_no, gme.item_no, gme.plate_no,
                                        gme.peril_cd, gme.payee_no,
                                        gme.payee_class_cd, gme.tp_sw,
                                        gc.in_hou_adj
                                   FROM gicl_claims gc,
                                        gicl_mc_evaluation gme
                                  WHERE gc.claim_id = gme.claim_id
                                    AND gc.clm_stat_cd NOT IN ('CD', 'CC', 'DN', 'WD')
                                    AND check_user_per_iss_cd2 (gc.line_cd, NULL, 'GICLS070', p_user_id) =1) --added by robert
                 WHERE in_hou_adj = p_user_id
                   AND claim_id IN (SELECT DISTINCT claim_id
                                               FROM gicl_mc_evaluation)
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND clm_yy = p_clm_yy
                   AND clm_seq_no = p_clm_seq_no)
      LOOP
         v_mc.claim_id := i.claim_id;
         v_mc.line_cd := i.line_cd;
         v_mc.subline_cd := i.subline_cd;
         v_mc.iss_cd := i.iss_cd;
         v_mc.clm_yy := i.clm_yy;
         v_mc.clm_seq_no := i.clm_seq_no;
         v_mc.clm_file_date := i.clm_file_date;
         v_mc.renew_no := i.renew_no;
         v_mc.assd_no := i.assd_no;
         v_mc.assured_name := i.assured_name;
         v_mc.loss_date := TO_CHAR (i.loss_date, 'MM-DD-YYYY');
         v_mc.item_no := i.item_no;
         v_mc.plate_no := i.plate_no;
         v_mc.payee_no := i.payee_no;
         v_mc.payee_no := i.payee_no;
         v_mc.payee_class_cd := i.payee_class_cd;
         v_mc.tp_sw := i.tp_sw;
         v_mc.in_hou_adj := i.in_hou_adj;
         v_mc.claim_id := i.claim_id;
         v_mc.peril_cd := i.peril_cd;
         v_mc.pol_iss_cd := i.pol_iss_cd;
         v_mc.pol_seq_no := i.pol_seq_no;
         v_mc.issue_yy := i.issue_yy;

         BEGIN
            SELECT item_title
              INTO v_mc.dsp_item_desc
              FROM gicl_motor_car_dtl
             WHERE claim_id = i.claim_id AND item_no = i.item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_mc.dsp_item_desc := '';
         END;

         BEGIN
            SELECT peril_name
              INTO v_mc.dsp_peril_desc
              FROM giis_peril
             WHERE line_cd = 'MC' AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_mc.dsp_peril_desc := '';
         END;

         BEGIN
            SELECT a.currency_cd, a.currency_rate,
                   b.short_name
              INTO v_mc.currency_cd, v_mc.currency_rate,
                   v_mc.dsp_curr_shortname
              FROM gicl_motor_car_dtl a, giis_currency b
             WHERE a.currency_cd = b.main_currency_cd
               AND a.claim_id = v_mc.claim_id;
         EXCEPTION
            WHEN TOO_MANY_ROWS OR NO_DATA_FOUND
            THEN
               v_mc.currency_cd := NULL;
               v_mc.currency_rate := NULL;
               v_mc.dsp_curr_shortname := NULL;
         END;

         BEGIN
            SELECT ann_tsi_amt
              INTO v_mc.ann_tsi_amt
              FROM gicl_item_peril
             WHERE 1 = 1
               AND claim_id = i.claim_id
               AND peril_cd = i.peril_cd
               AND item_no = i.item_no
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_mc.ann_tsi_amt := NULL;
         END;

         PIPE ROW (v_mc);
      END LOOP;
   END;

   FUNCTION get_evaluation_subline_list (p_find_text VARCHAR2)
      RETURN subline_list_tab PIPELINED
   IS
      v_subline   subline_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.subline_cd,
                                (SELECT subline_name
                                   FROM giis_subline
                                  WHERE subline_cd =
                                                    a.subline_cd and line_cd = 'MC')
                                                                subline_name
                           FROM gicl_claims a
                          WHERE line_cd = 'MC'
                            AND clm_stat_cd NOT IN ('DN', 'WD', 'CD', 'CC')
                            AND UPPER (a.subline_cd) LIKE
                                               NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_subline.subline_cd := i.subline_cd;
         v_subline.subline_name := i.subline_name;
         PIPE ROW (v_subline);
      END LOOP;
   END;

   FUNCTION get_evaluation_issue_cd_list (
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_find_text    VARCHAR2
   )
      RETURN issue_code_list_tab PIPELINED
   IS
      v_iss   issue_code_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.iss_cd, (SELECT iss_name
                                             FROM giis_issource
                                            WHERE iss_cd = a.iss_cd)
                                                                    iss_name
                           FROM gicl_claims a
                          WHERE line_cd = 'MC'
                            AND subline_cd = p_subline_cd
                            AND clm_stat_cd NOT IN ('DN', 'WD', 'CD', 'CC')
                            AND UPPER (a.iss_cd) LIKE
                                               NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_iss.iss_cd := i.iss_cd;
         v_iss.iss_name := i.iss_name;
         PIPE ROW (v_iss);
      END LOOP;
   END;

   FUNCTION get_evaluation_clm_year_list (
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_find_text    VARCHAR2
   )
      RETURN clm_year_list_tab PIPELINED
   IS
      v_yy   clm_year_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT clm_yy
                           FROM gicl_claims
                          WHERE line_cd = 'MC'
                            AND subline_cd = p_subline_cd
                            AND iss_cd = p_iss_cd
                            AND clm_stat_cd NOT IN ('DN', 'WD', 'CD', 'CC')
                            AND clm_yy LIKE (NVL (p_find_text, '%%'))
                       ORDER BY clm_yy)
      LOOP
         v_yy.clm_yy := i.clm_yy;
         PIPE ROW (v_yy);
      END LOOP;
   END;

   FUNCTION get_evaluation_clm_seq_no_list (
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_clm_yy       gicl_claims.clm_yy%TYPE,
      p_find_text    VARCHAR2
   )
      RETURN clm_year_list_tab PIPELINED
   IS
      v_yy   clm_year_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT clm_seq_no
                           FROM gicl_claims
                          WHERE line_cd = 'MC'
                            AND subline_cd = p_subline_cd
                            AND iss_cd = p_iss_cd
                            AND clm_yy = p_clm_yy
                            AND clm_stat_cd NOT IN ('DN', 'WD', 'CD', 'CC')
                            AND clm_seq_no LIKE (NVL (p_find_text, '%%'))
                       ORDER BY clm_seq_no)
      LOOP
         v_yy.clm_seq_no := i.clm_seq_no;
         PIPE ROW (v_yy);
      END LOOP;
   END;

   PROCEDURE get_pol_info (
      p_subline_cd              gicl_claims.subline_cd%TYPE,
      p_iss_cd                  gicl_claims.iss_cd%TYPE,
      p_clm_yy                  gicl_claims.clm_yy%TYPE,
      p_clm_seq_no              gicl_claims.clm_seq_no%TYPE,
      p_user_id                 VARCHAR2,
      p_claim_id       IN OUT   gicl_claims.claim_id%TYPE,
      p_pol_iss_cd     OUT      gicl_claims.pol_iss_cd%TYPE,
      p_pol_seq_no     OUT      gicl_claims.pol_seq_no%TYPE,
      p_pol_renew_no   OUT      gicl_claims.renew_no%TYPE,
      p_pol_issue_yy   OUT      gicl_claims.issue_yy%TYPE,
      p_loss_date      OUT      VARCHAR2,
      p_assured_name   OUT      VARCHAR2,
      p_plate_no       OUT      VARCHAR2,
      p_peril_cd       OUT      gicl_item_peril.peril_cd%TYPE,
      p_peril_name     OUT      VARCHAR2,
      p_message        OUT      VARCHAR2
   )
   IS
      FOUND   NUMBER;
   BEGIN
      BEGIN
         SELECT 1
           INTO FOUND
           FROM gicl_claims
          WHERE line_cd = 'MC'
            --AND subline_cd = :gicl_claims.nbt_clm_subline_cd
            --AND iss_cd       = :gicl_claims.nbt_clm_iss_cd
            --AND clm_yy       = :gicl_claims.nbt_clm_yy
            --AND clm_seq_no = :gicl_claims.nbt_clm_seq_no;
            AND subline_cd = p_subline_cd
            AND iss_cd = p_iss_cd
            AND clm_yy = p_clm_yy
            AND clm_seq_no = p_clm_seq_no;

         BEGIN
            SELECT TO_CHAR (loss_date, 'MM-DD-YYYY'), assured_name,
                   claim_id, pol_iss_cd, pol_seq_no, renew_no,
                   issue_yy
              --INTO :gicl_claims.nbt_loss_date, :gicl_claims.nbt_assd_name, claimId,
              --     :gicl_claims.nbt_pol_iss_cd, :gicl_claims.nbt_pol_seq_no, :gicl_claims.nbt_pol_renew_no, :gicl_claims.nbt_pol_issue_yy
            INTO   p_loss_date, p_assured_name,
                   p_claim_id, p_pol_iss_cd, p_pol_seq_no, p_pol_renew_no,
                   p_pol_issue_yy
              FROM gicl_claims
             WHERE line_cd = 'MC'
               AND subline_cd = p_subline_cd
               AND iss_cd = p_iss_cd
               AND clm_yy = p_clm_yy                  --gicl_claims.nbt_clm_yy
               AND clm_seq_no = p_clm_seq_no
               AND in_hou_adj = p_user_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_message :=
                  'User is not allowed to create or modify report for this claim';
         END;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message := 'claim does not exists!';
      END;
   END;

   FUNCTION get_mc_evaluation_list (
      p_claim_id         gicl_mc_evaluation.claim_id%TYPE,
      p_item_no          gicl_mc_evaluation.item_no%TYPE,
      p_payee_no         gicl_mc_evaluation.payee_no%TYPE,
      p_payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      p_plate_no         gicl_mc_evaluation.plate_no%TYPE,
      p_peril_cd         gicl_mc_evaluation.peril_cd%TYPE,
      p_subline_cd       VARCHAR2,
      p_iss_cd           VARCHAR2,
      p_eval_yy          NUMBER,
      p_eval_seq_no      NUMBER,
      p_eval_version     NUMBER,
      p_cso_id           VARCHAR2,
      p_eval_date        VARCHAR2,
      p_inspect_date     VARCHAR2,
      p_pol_line_cd      gipi_polbasic.line_cd%TYPE,
      p_pol_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_pol_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN mc_eval_list_tab PIPELINED
   IS
      v_eval        mc_eval_list_type;
      v_ded_amt     NUMBER            := 0;
      v_ded_total   NUMBER            := 0;
      v_dep_amt     NUMBER            := 0;
      v_dep_total   NUMBER            := 0;
      x             NUMBER;
   BEGIN
      FOR i IN (SELECT   a.*
                    FROM gicl_mc_evaluation a
                   WHERE claim_id = p_claim_id
                     AND a.item_no = p_item_no
                     -- aND a.payee_no = p_payee_no
                     AND UPPER (NVL (a.payee_class_cd, '*')) =
                            UPPER (NVL (p_payee_class_cd,
                                        DECODE (a.payee_class_cd,
                                                NULL, '*',
                                                a.payee_class_cd
                                               )
                                       )
                                  )
                     AND NVL (a.plate_no, '*') =
                            UPPER (NVL (p_plate_no,
                                        DECODE (a.plate_no,
                                                NULL, '*',
                                                a.plate_no
                                               )
                                       )
                                  )
                     AND NVL (a.peril_cd, 0) =
                            NVL (p_peril_cd,
                                 DECODE (a.peril_cd, NULL, 0, a.peril_cd)
                                )
                     -- filters
                     AND subline_cd LIKE
                                        UPPER (NVL (p_subline_cd, subline_cd))
                     AND iss_cd LIKE UPPER (NVL (p_iss_cd, iss_cd))
                     AND eval_yy LIKE NVL (p_eval_yy, eval_yy)
                     AND eval_seq_no LIKE NVL (p_eval_seq_no, eval_seq_no)
                     AND eval_version LIKE NVL (p_eval_version, eval_version)
                     AND UPPER (cso_id) LIKE UPPER (NVL (p_cso_id, cso_id))
                     AND TRUNC (NVL (eval_date,
                                     TO_DATE ('11-11-1111', 'MM-DD-YYYY')
                                    )
                               ) =
                            TO_DATE (NVL (p_eval_date,
                                          DECODE (eval_date,
                                                  NULL, '11-11-1111',
                                                  TO_CHAR (eval_date,
                                                           'MM-DD-YYYY'
                                                          )
                                                 )
                                         ),
                                     'MM-DD-YYYY'
                                    )
                     AND TRUNC (inspect_date) =
                            TRUNC (NVL (TO_DATE (p_inspect_date, 'MM-DD-YYYY'),
                                        inspect_date
                                       )
                                  )
                ORDER BY subline_cd,
                         iss_cd,
                         eval_yy DESC,
                         eval_seq_no DESC,
                         eval_version DESC)
      LOOP
         v_eval.claim_id := i.claim_id;
         v_eval.eval_id := i.eval_id;
         v_eval.item_no := i.item_no;
         v_eval.peril_cd := i.peril_cd;
         v_eval.subline_cd := i.subline_cd;
         v_eval.iss_cd := i.iss_cd;
         v_eval.eval_yy := i.eval_yy;
         v_eval.eval_seq_no := i.eval_seq_no;
         v_eval.eval_version := i.eval_version;
         v_eval.report_type := i.report_type;
         v_eval.eval_master_id := i.eval_master_id;
         v_eval.payee_no := i.payee_no;
         v_eval.payee_class_cd := i.payee_class_cd;
         v_eval.plate_no := i.plate_no;
         v_eval.tp_sw := i.tp_sw;
         v_eval.cso_id := i.cso_id;
         v_eval.eval_date := TO_CHAR (i.eval_date, 'MM-DD-YYYY');
         v_eval.inspect_date := TO_CHAR (i.inspect_date, 'MM-DD-YYYY');
         v_eval.inspect_place := i.inspect_place;
         v_eval.adjuster_id := i.adjuster_id;
         v_eval.replace_amt := i.replace_amt;
         v_eval.vat := i.vat;
         --v_eval.deductible := i.deductible;
         v_eval.depreciation := i.depreciation;
         v_eval.remarks := escape_value_clob (i.remarks);
         v_eval.currency_cd := i.currency_cd;
         v_eval.currency_rate := i.currency_rate;
         v_eval.user_id := i.user_id;
         v_eval.repair_amt := i.repair_amt;
         v_eval.eval_stat_cd := i.eval_stat_cd;
         v_eval.evaluation_no :=
               i.subline_cd
            || '-'
            || i.iss_cd
            || '-'
            || LTRIM (TO_CHAR (i.eval_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (i.eval_seq_no, '0000009'))
            || '-'
            || LTRIM (TO_CHAR (i.eval_version, '09'));

         /*ADJUSTER*/
         FOR ad IN (SELECT DECODE (a.payee_name,
                                   NULL, c.payee_last_name,
                                   a.payee_name
                                  ) payee_name
                      FROM giis_adjuster a, gicl_clm_adjuster b,
                           giis_payees c
                     WHERE b.priv_adj_cd = a.priv_adj_cd(+)
                       AND b.adj_company_cd = a.adj_company_cd(+)
                       AND b.clm_adj_id = i.adjuster_id
                       AND b.claim_id = i.claim_id
                       AND c.payee_class_cd = giisp.v ('ADJUSTER_CD')
                       AND c.payee_no = b.adj_company_cd
                       AND NVL (cancel_tag, 'N') <> 'Y'
                       AND NVL (delete_tag, 'N') <> 'Y')
         LOOP
            v_eval.dsp_adjuster_desc := ad.payee_name;
         END LOOP;

         /*3rd party*/
         BEGIN
            SELECT    g.payee_last_name
                   || DECODE (g.payee_first_name,
                              NULL, NULL,
                              ',' || g.payee_first_name
                             )
                   || DECODE (g.payee_middle_name,
                              NULL, NULL,
                              '' || g.payee_middle_name || '.'
                             ) payee_name
              INTO v_eval.dsp_payee
              FROM giis_payees g
             WHERE g.payee_class_cd = i.payee_class_cd
               AND g.payee_no = i.payee_no;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_eval.dsp_payee := '';
         END;

         BEGIN
            SELECT short_name
              INTO v_eval.dsp_curr_shortname
              FROM giis_currency
             WHERE main_currency_cd = i.currency_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_eval.dsp_curr_shortname := '';
         END;

         BEGIN
            SELECT eval_stat_desc
              INTO v_eval.dsp_eval_desc
              FROM gicl_mc_eval_stat
             WHERE eval_stat_cd = i.eval_stat_cd;
         EXCEPTION
            WHEN TOO_MANY_ROWS OR NO_DATA_FOUND
            THEN
               v_eval.dsp_eval_desc := '';
         END;

         SELECT NVL (SUM (ded_amt), 0) discount
           INTO v_eval.dsp_discount
           FROM gicl_eval_deductibles
          WHERE eval_id = i.eval_id AND ded_cd = giisp.v ('CLM DISCOUNT');

         SELECT NVL (SUM (ded_amt), 0) deductible
           INTO v_eval.deductible
           FROM gicl_eval_deductibles
          WHERE eval_id = i.eval_id
            AND ded_cd NOT IN
                   (giisp.v ('CLM DISCOUNT'), giisp.v ('MC_DEPRECIATION_CD'));

         v_eval.tot_estcos := NVL (i.replace_amt, 0) + NVL (i.repair_amt, 0);
         --total estimated repair cost--
         v_eval.tot_erc :=
                 NVL (i.replace_amt, 0) + NVL (i.repair_amt, 0)
                 + NVL (i.vat, 0);
         --Insured's Net Participation = (ded+dep) ----:gicl_mc_evaluation.tot_inp      := ABS(NVL(:gicl_mc_evaluation.DEDUCTIBLE,0)) + abs(NVL(:gicl_mc_evaluation.depreciation,0)); Comment out by Marlo 02152010 changed to:
         v_eval.tot_inp :=
              ABS (NVL (v_eval.deductible, 0))
            + ABS (NVL (i.depreciation, 0))
            + ABS (NVL (v_eval.dsp_discount, 0));
         v_ded_total := NVL (v_eval.deductible, 0);
         v_dep_total := NVL (i.depreciation, 0);

         FOR p IN (SELECT payee_type_cd, payee_cd
                     FROM gicl_eval_vat
                    WHERE eval_id = v_eval.eval_id
                          AND NVL (less_ded, 'N') = 'Y')
         LOOP
            SELECT NVL (ded_amt, 0)                ---dito ung nilagyan ng sum
              INTO v_ded_amt
              FROM gicl_eval_deductibles
             WHERE eval_id = v_eval.eval_id;

              --AND payee_type_cd = p.payee_type_cd
            --  AND payee_cd = p.payee_cd;
            v_ded_total := NVL (v_ded_total, 0) - NVL (v_ded_amt, 0);
         END LOOP;

         FOR d IN (SELECT payee_type_cd, payee_cd
                     FROM gicl_eval_vat
                    WHERE eval_id = v_eval.eval_id
                          AND NVL (less_dep, 'N') = 'Y')
         LOOP
            SELECT NVL (ded_amt, 0)
              INTO v_dep_amt
              FROM gicl_eval_dep_dtl
             WHERE eval_id = v_eval.eval_id;

            --AND payee_type_cd = I.payee_type_cd
                --AND payee_cd = i.payee_cd;
            v_dep_total := NVL (v_dep_total, 0) - NVL (v_dep_amt, 0);
         END LOOP;

         v_eval.tot_inl :=
              NVL (v_eval.tot_erc, 0)
            - NVL (v_ded_total, 0)
            - NVL (v_dep_total, 0)
            - NVL (v_eval.dsp_discount, 0);

         FOR get_desc IN (SELECT rv_meaning
                            FROM cg_ref_codes
                           WHERE rv_domain = 'GICL_MC_EVALUATION.REPORT_TYPE'
                             AND rv_low_value = v_eval.report_type)
         LOOP
            v_eval.dsp_report_type_desc := get_desc.rv_meaning;
         END LOOP;

         -- ADDED REPLACE_GROSS NBT, EQUIVALENT TO NET AMT OF REPLACEMENTS + VAT + DEDUCTIBLES + DEPRECIATION
         FOR rpl_gross IN (SELECT SUM (NVL (y.vat_amt + y.base_amt,
                                            z.part_amt)
                                      ) replace_gross
                             FROM (SELECT   a.eval_id, a.payee_type_cd,
                                            a.payee_cd,
                                            SUM (a.part_amt) part_amt,
                                            'P' apply_to
                                       FROM gicl_replace a
                                      WHERE a.eval_id = v_eval.eval_id
                                   GROUP BY a.eval_id,
                                            a.payee_type_cd,
                                            a.payee_cd) z,
                                  gicl_eval_vat y
                            WHERE z.eval_id = y.eval_id(+)
                              AND z.payee_type_cd = y.payee_type_cd(+)
                              AND z.payee_cd = y.payee_cd(+)
                              AND z.apply_to = y.apply_to(+)
                              AND z.eval_id = v_eval.eval_id)
         -- END replaced to obtain correct replace_gross by Jayson 04.12.2011 --
         LOOP
            v_eval.replace_gross := rpl_gross.replace_gross;
         END LOOP;

         -- ADDED REPAIR_GROSS NBT, EQUIVALENT TO NET AMT OF REPAIRS + VAT + DEDUCTIBLES + DEPRECIATION
         FOR rpr_gross IN
            (SELECT DECODE (NVL (a.with_vat, 'N'),
                            
                            -- added NVL by Jayson 04.12.2011
                            'N', (  (  NVL (other_labor_amt, 0)
                                     + NVL (actual_total_amt, 0)
                                    )
                                  + b.vat_amt
                             ),
                            (  NVL (other_labor_amt, 0)
                             + NVL (actual_total_amt, 0)
                            )
                           ) repair_gross
               FROM gicl_repair_hdr a, gicl_eval_vat b
              WHERE a.eval_id = v_eval.eval_id
                AND apply_to = 'L'
                AND a.eval_id = b.eval_id)
         LOOP
            v_eval.repair_gross := rpr_gross.repair_gross;
         END LOOP;

-- included in 'load' program unit in the module
           --check if it is a master report...
         IF i.eval_master_id IS NOT NULL
         THEN        --revised a master report, thus making it a master report
            BEGIN
               SELECT 1
                 INTO x
                 FROM gicl_mc_evaluation
                WHERE eval_id = i.eval_master_id AND report_type = 'RD';

               --emchang
               v_eval.master_flag := 'Y';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_eval.master_flag := 'N';
            END;
         ELSIF i.eval_master_id IS NULL
         THEN
            v_eval.master_flag := 'Y';
         END IF;

         /*checks if report is ok to CANCEL and REVISE*/
         BEGIN
            SELECT 1
              INTO x
              FROM gicl_eval_payment
             WHERE eval_id = i.eval_id
               AND NVL (cancel_sw, 'N') <> 'Y'
               AND ROWNUM = 1;

            v_eval.cancel_flag := 'N';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_eval.cancel_flag := 'Y';
         END;

         --check if applying uw deductibles is allowed:
         BEGIN                   --checks if there's already saved deductibles
            SELECT 0
              INTO v_eval.ded_flag
              FROM gicl_eval_deductibles
             WHERE eval_id = v_eval.eval_id
                                           --AND ded_cd <> giisp.v('MC_DEPRECIATION_CD') --emchang DA102506TE
                   AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               BEGIN                --checks if there's only one company used
                  SELECT *
                    INTO v_eval.v_payee_cd_gicl_replace,
                         v_eval.v_payee_type_cd_gicl_replace
                    FROM (SELECT payee_cd, payee_type_cd
                            FROM gicl_replace
                           WHERE eval_id = v_eval.eval_id
                          UNION ALL
                          SELECT payee_cd, payee_type_cd
                            FROM gicl_repair_hdr
                           WHERE eval_id = v_eval.eval_id);

                  BEGIN      --checks if deductible exists in gipi_deductibles
                     SELECT 1
                       INTO v_eval.ded_flag
                       FROM gipi_deductibles a, gipi_polbasic b
                      WHERE a.policy_id = b.policy_id
                        AND b.line_cd = p_pol_line_cd
                        AND b.subline_cd = p_pol_subline_cd
                        AND b.iss_cd = p_pol_iss_cd
                        AND b.issue_yy = p_pol_issue_yy
                        AND b.renew_no = p_pol_renew_no
                        AND ROWNUM = 1;

                     v_eval.ded_flag := 1;
                  /* set_item_property('control.appded_btn',enabled,property_true);
                     set_item_property('control.appded_btn',navigable,property_true);
                     set_item_property('gicl_eval_deductibles.apply_ded',enabled,property_true);
                     set_item_property('gicl_eval_deductibles.apply_ded',navigable,property_true);*/
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_eval.ded_flag := 0;
                  END;
               EXCEPTION
                  WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
                  THEN
                     v_eval.ded_flag := 0;
               END;
         END;

         --check if applying depreciation is allowed:
         BEGIN               --search if there's an existing depreciation made
            SELECT 0
              INTO v_eval.dep_flag
              FROM gicl_eval_dep_dtl
             WHERE eval_id = v_eval.eval_id
                                           --     AND ded_cd = giisp.v('MC_DEPRECIATION_CD')
                   AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               --checks if there's original part
               BEGIN
                  SELECT 1
                    INTO v_eval.dep_flag
                    FROM gicl_replace
                   WHERE eval_id = v_eval.eval_id
                     AND part_type = 'O'
                     AND ROWNUM = 1;

                  BEGIN
                     SELECT 1
                       INTO v_eval.dep_flag
                       FROM gicl_repair_hdr
                      WHERE eval_id = v_eval.eval_id AND ROWNUM = 1;
                           /*
                           set_item_property('control.appdep_btn',enabled,property_true);
                        set_item_property('control.appdep_btn',navigable,property_true);
                  set_item_property('depreciation_dtl.apply_btn',enabled,property_true);
                  set_item_property('depreciation_dtl.apply_btn',navigable,property_true);*/
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_eval.dep_flag := 0;
                  END;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_eval.dep_flag := 0;
               END;
         END;

         /** To check the value of the cso_id and in_adj_hou and set the limitations of the user*/
         SELECT in_hou_adj
           INTO v_eval.in_hou_adj
           FROM gicl_claims
          WHERE claim_id = v_eval.claim_id;

         -- checks the master report type if it is existing
         BEGIN
            SELECT report_type
              INTO v_eval.master_report_type
              FROM gicl_mc_evaluation
             WHERE eval_id = i.eval_master_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_eval.master_report_type := '';
         END;

         BEGIN
            SELECT 'Y'
              INTO v_eval.main_eval_vat_exist
              FROM gicl_eval_vat
             WHERE eval_id = i.eval_id AND apply_to = 'P' AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_eval.main_eval_vat_exist := 'N';
         END;

         PIPE ROW (v_eval);
      END LOOP;
   END;

   PROCEDURE get_variables (
      replace_label        OUT   VARCHAR2,
      repair_label         OUT   VARCHAR2,
      mortgagee_class_cd   OUT   VARCHAR2,
      assd_class_cd        OUT   VARCHAR2,
      input_vat_rt         OUT   NUMBER
   )
   IS
   BEGIN
      replace_label := INITCAP (giisp.v ('REPLACE_LABEL'));
      repair_label := INITCAP (giisp.v ('REPAIR_LABEL'));
      mortgagee_class_cd := giacp.v ('MORTGAGEE_CLASS_CD');
      assd_class_cd := giacp.v ('ASSD_CLASS_CD');
      input_vat_rt := giacp.n ('INPUT_VAT_RT');
   END;

   PROCEDURE mc_eval_blk_pre_insert (
      p_new_rep_flag              VARCHAR2,
      p_copy_dtl_flag             VARCHAR2,
      p_revise_flag      IN       VARCHAR2,
      p_iss_cd                    gicl_mc_evaluation.iss_cd%TYPE,
      p_subline_cd                gicl_mc_evaluation.subline_cd%TYPE,
      p_inspect_date     IN OUT   VARCHAR2,
      p_eval_master_id   IN OUT   gicl_mc_evaluation.eval_master_id%TYPE,
      p_replace_amt      IN OUT   gicl_mc_evaluation.replace_amt%TYPE,
      p_repair_amt       IN OUT   gicl_mc_evaluation.repair_amt%TYPE,
      p_deductible2      OUT      gicl_mc_evaluation.deductible%TYPE,
      p_depreciation     OUT      gicl_mc_evaluation.depreciation%TYPE,
      p_eval_seq_no      OUT      gicl_mc_evaluation.eval_seq_no%TYPE,
      p_eval_yy          IN OUT   gicl_mc_evaluation.eval_yy%TYPE,
      p_eval_id          OUT      gicl_mc_evaluation.eval_id%TYPE,
      p_eval_version     OUT      gicl_mc_evaluation.eval_version%TYPE,
      p_eval_stat_cd     IN OUT   gicl_mc_evaluation.eval_stat_cd%TYPE,
      p_report_type      IN OUT   gicl_mc_evaluation.report_type%TYPE,
      p_vat              OUT      gicl_mc_evaluation.vat%TYPE,   -- added by kenneth L to insert vat value when copying MC eval report
      p_inspect_place    IN OUT   gicl_mc_evaluation.inspect_place%TYPE, -- marco - 03.27.2014
      p_adjuster_id      IN OUT   gicl_mc_evaluation.adjuster_id%TYPE    --
   )
   IS
      -- Disclaimer: The variable naming convention used below did not came from me. I opted to not change the names to keep the relation with the original module procedure - Irwin
      x                    NUMBER;
      vvatrt               gicl_eval_vat.vat_rate%TYPE
                                                  := giacp.n ('INPUT_VAT_RT');
      aktualtinsmit        gicl_repair_hdr.actual_tinsmith_amt%TYPE;
      aktualpinta          gicl_repair_hdr.actual_painting_amt%TYPE;
      aktualnakabuuan      gicl_repair_hdr.actual_total_amt%TYPE;
      --eherm..kanya-kanyang gawa yan ng variables...
      presyo               gicl_repair_other_dtl.amount%TYPE          := 0;
      presyotot            gicl_repair_other_dtl.amount%TYPE          := 0;
      ibanggawa            gicl_repair_hdr.other_labor_amt%TYPE;
      vlpsrepairamt        gicl_repair_hdr.lps_repair_amt%TYPE;
      vactualtotalamt      gicl_repair_hdr.actual_total_amt%TYPE;
      vactualtinsmithamt   gicl_repair_hdr.actual_tinsmith_amt%TYPE;
      vactualpaintingamt   gicl_repair_hdr.actual_painting_amt%TYPE;
      votherlaboramt       gicl_repair_hdr.other_labor_amt%TYPE;
      vwithvat             gicl_replace.with_vat%TYPE;
      vpayeetypecd         gicl_replace.payee_type_cd%TYPE;
      vpayeecd             gicl_replace.payee_cd%TYPE;
      vpaytpayeetypecd     gicl_replace.payee_type_cd%TYPE;
      vpaytpayeecd         gicl_replace.payee_cd%TYPE;
      vbaseamt             gicl_replace.base_amt%TYPE;
      vnoofunits           gicl_replace.no_of_units%TYPE;
      vpartamt             gicl_replace.part_amt%TYPE;
      vpartorigamt         gicl_replace.part_orig_amt%TYPE;
      vparttype            gicl_replace.part_type%TYPE;
      vmaster              gicl_mc_evaluation.eval_master_id%TYPE;
      vtypetag             gicl_replace.with_vat%TYPE;
      vitemno              gicl_replace.item_no%TYPE;
      vitemno2             gicl_repair_other_dtl.item_no%TYPE;
      vitemno3             gicl_eval_dep_dtl.item_no%TYPE;
      vitemno4             gicl_eval_dep_dtl.item_no%TYPE;
      v_inspect_date       gicl_mc_evaluation.inspect_date%TYPE;
      
   BEGIN
      vmaster := p_eval_master_id;
      p_eval_yy := TO_CHAR (SYSDATE, 'YY');

      IF p_inspect_date IS NULL
      THEN
         v_inspect_date := SYSDATE;
      ELSE
         v_inspect_date := TO_DATE (p_inspect_date, 'MM-DD-YYYY');
      END IF;

      IF p_new_rep_flag = 'Y'
      THEN                                               --pag copy report lng
         p_eval_master_id := NULL;
      END IF;

      /*generate eval_id*/
      BEGIN
         SELECT gicl_mc_evaluation_eval_id_s.NEXTVAL
           INTO p_eval_id
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error ('-20001',
                                     'No next value found for eval_id!'
                                    );
      END;

      IF vmaster IS NOT NULL
      THEN
         /*for revision of report*/
         IF p_copy_dtl_flag = 'Y'
         THEN
            vitemno := 0;

            --copy replace details--
            FOR i IN
               (SELECT DISTINCT a.loss_exp_cd, a.part_type, a.payee_type_cd,
                                a.payee_cd, a.base_amt, a.with_vat,
                                a.eval_id, a.last_update, a.item_no     --3.0
                           FROM gicl_replace a, gicl_mc_evaluation b
                          WHERE 1 = 1
                            AND a.eval_id = b.eval_id
                            AND (   a.eval_id = vmaster
                                 OR (    b.eval_master_id = vmaster
                                     AND b.report_type = 'AD'
                                    )
                                )                     --4.0 petermkaw 03122010
                            --AND b.eval_stat_cd <> 'CC' allow retrieval of amounts even if report status is CANCELLED by MAC 12/05/2013.
                       ORDER BY a.eval_id, a.item_no)
            LOOP
--msg_alert (vmaster,'I',false); --message for debugging purposes
               vitemno := vitemno + 1;                                  --3.0

               BEGIN                                               --PARENT--
                  SELECT payee_type_cd, payee_cd, payt_payee_type_cd,
                         payt_payee_cd, NVL (with_vat, 'N')
                    --added nvl to insert null values as 'N'
                  INTO   vpayeetypecd, vpayeecd, vpaytpayeetypecd,
                         vpaytpayeecd, vwithvat
                    FROM gicl_replace
                   WHERE eval_id = vmaster
                     AND loss_exp_cd = i.loss_exp_cd
                     AND payee_type_cd = i.payee_type_cd
                     AND payee_cd = i.payee_cd
                     AND base_amt = i.base_amt
                     --AND with_vat = i.with_vat
                     AND part_type = i.part_type          --petermkaw 03122010
                     AND item_no = i.item_no;             --petermkaw 03122010
               EXCEPTION
                  WHEN TOO_MANY_ROWS
                  THEN
                     raise_application_error
                                  ('-20001',
                                      'Too many rows inserted for eval_id = '
                                   || vmaster
                                   || '.'
                                  );
                  WHEN NO_DATA_FOUND
                  THEN
                     FOR j IN (SELECT   a.payee_type_cd, a.payee_cd,
                                        a.payt_payee_type_cd,
                                        a.payt_payee_cd, a.with_vat
                                   FROM gicl_replace a, gicl_mc_evaluation b
                                  WHERE 1 = 1
                                    AND a.loss_exp_cd = i.loss_exp_cd
                                    --AND b.eval_stat_cd <> 'CC' allow retrieval of amounts even if report status is CANCELLED by MAC 12/05/2013.
                                    AND a.eval_id = b.eval_id
                                    AND b.eval_master_id = vmaster
                                    AND a.item_no = i.item_no
                               ORDER BY a.revised_sw DESC, a.last_update DESC)
                     LOOP
                        vpayeetypecd := j.payee_type_cd;
                        vpayeecd := j.payee_cd;
                        vpaytpayeetypecd := j.payt_payee_type_cd;
                        vpaytpayeecd := j.payt_payee_cd;
                        vwithvat := j.with_vat;
                        EXIT;
                     END LOOP;
               END;

--msg_alert ('before part amts loop','I',false);        --message for debugging purposes
               vbaseamt := 0;
               vnoofunits := 0;
               vpartamt := 0;

               --part amts--
               FOR m IN
                  (SELECT DISTINCT a.base_amt, a.no_of_units, a.part_amt,
                                   a.part_orig_amt, a.part_type,
                                   a.total_part_amt, a.revised_sw, a.with_vat
                              FROM gicl_replace a, gicl_mc_evaluation b
                             WHERE 1 = 1
                               AND a.eval_id = b.eval_id
                               AND a.loss_exp_cd = i.loss_exp_cd
                               --2.0:
                               AND a.part_type = i.part_type
                               AND a.payee_type_cd = i.payee_type_cd
                               AND a.payee_cd = i.payee_cd
                               AND a.base_amt = i.base_amt
                               AND (   a.eval_id = vmaster
                                    OR (    b.eval_master_id = vmaster
                                        AND b.report_type = 'AD'
                                       )
                                   )                  --4.0 petermkaw 03122010
                               --AND b.eval_stat_cd <> 'CC' allow retrieval of amounts even if report status is CANCELLED by MAC 12/05/2013.
                                                         --ORDER BY a.last_update --petermkaw 03122010 commented out to optimize performance
                  )
               LOOP
                  IF NVL (m.revised_sw, 'N') = 'Y'
                  THEN
                     vbaseamt := vbaseamt + m.total_part_amt;
                     vnoofunits := vnoofunits + m.no_of_units;
                     vpartamt := vbaseamt * vnoofunits;
                     vparttype := m.part_type;
                  ELSE
                     vbaseamt := vbaseamt + m.base_amt;
                     vnoofunits := vnoofunits + m.no_of_units;
                     vpartamt := vbaseamt * vnoofunits;
                     vparttype := m.part_type;
                  END IF;

                  IF NVL (vwithvat, 'N') = 'Y' AND NVL (m.with_vat, 'N') = 'N'
                  THEN
                     vbaseamt := ROUND (vbaseamt / (1 + (vvatrt / 100)), 2);
                  ELSIF NVL (vwithvat, 'N') = 'N'
                        AND NVL (m.with_vat, 'N') = 'Y'
                  THEN
                     vbaseamt :=
                            ROUND (vbaseamt + (vbaseamt * (vvatrt / 100)), 2);
                  END IF;
               END LOOP;

--msg_alert (vbaseamt,'I',false);         --message for debugging purposes only
               FOR r IN
                  (SELECT a.with_vat wv
                     FROM gicl_replace a, gicl_mc_evaluation b
                    WHERE 1 = 1
                      AND a.eval_id = b.eval_id
                      AND b.report_type = 'NR'
                      AND (   a.eval_id = p_eval_master_id
                           OR (    b.eval_master_id = vmaster
                               AND b.report_type = 'AD'
                              )
                          )       --4.0 petermkaw 03122010 NR na nga, AD pa...
                      --AND b.eval_stat_cd <> 'CC' allow retrieval of amounts even if report status is CANCELLED by MAC 12/05/2013.
                      )
               LOOP
                  vtypetag := r.wv;
               END LOOP;

/*            msg_alert
                 ('eval_id          = '||:gicl_mc_Evaluation.eval_id||chr(10)||
                  'vPayeeTypeCd     = '||vPayeeTypeCd||chr(10)||
                  'vPayeeCd         = '||vPayeeCd||chr(10)||
                  'i.loss_Exp_cd    = '||i.loss_Exp_cd||chr(10)||
                  'vPartType        = '||vPartType||chr(10)||
                  'vPartAmt         = '||vPartAmt||chr(10)||
                  'vTypeTag         = '||vTypeTag||chr(10)||
                  'vNoOfUnits       = '||vNoOfUnits||chr(10)||
                  'vBaseAmt         = '||vBaseAmt||chr(10)||
                  'vPaytPayeeTypeCd = '||vPaytPayeeTypeCd||chr(10)||
                  'vPaytPayeeCd     = '||vPaytPayeeCd||chr(10)||
                  'vItemNo          = '||vItemNo,'I',FALSE);  */ --petermkawmsg for debugging purposes only
               INSERT INTO gicl_replace
                           (eval_id, payee_type_cd, payee_cd, loss_exp_cd,
                            part_type, part_amt, with_vat, no_of_units,
                            base_amt, payt_payee_type_cd, payt_payee_cd,
                            item_no, update_sw
                           )                                             --3.0
                    VALUES (p_eval_id, vpayeetypecd, vpayeecd, i.loss_exp_cd,
                            vparttype, vpartamt, /*'N'*/ vtypetag, vnoofunits,
                            vbaseamt, vpaytpayeetypecd, vpaytpayeecd,
                            vitemno, 'N'
                           );                                            --3.0
            END LOOP;                               --end of replace details--

            vbaseamt := 0;

            --copy repair details--
            BEGIN
               SELECT payee_type_cd, payee_cd, with_vat
                 INTO vpayeetypecd, vpayeecd, vwithvat
                 FROM gicl_repair_hdr
                WHERE eval_id = vmaster;
            EXCEPTION
               WHEN TOO_MANY_ROWS
               THEN
                  raise_application_error
                     ('-20001',
                         'Problem inserting on repair header table with eval_id = '
                      || vmaster
                      || '.'
                     );
               WHEN NO_DATA_FOUND
               THEN
                  FOR i IN (SELECT   a.payee_type_cd, a.payee_cd, a.with_vat
                                FROM gicl_repair_hdr a, gicl_mc_evaluation b
                               WHERE a.eval_id = b.eval_id
                                 AND b.eval_master_id = vmaster
                                 --AND b.eval_stat_cd <> 'CC' allow retrieval of amounts even if report status is CANCELLED by MAC 12/05/2013.
                            ORDER BY a.last_update DESC)
                  LOOP
                     vpayeetypecd := i.payee_type_cd;
                     vpayeecd := i.payee_cd;
                     vwithvat := i.with_vat;
                  END LOOP;
            END;

            --end copying repair details--
            vactualtotalamt := 0;
            vactualtinsmithamt := 0;
            vactualpaintingamt := 0;
            votherlaboramt := 0;
            vlpsrepairamt := 0;
            vitemno4 := 0;

            --REPAIR AMTS - tinsmith--
            FOR i IN
               (SELECT DISTINCT a.loss_exp_cd, a.repair_cd, a.tinsmith_type,
                                a.eval_id, a.item_no                     --3.0
                           FROM gicl_repair_lps_dtl a, gicl_mc_evaluation b
                          WHERE 1 = 1
                            AND a.eval_id = b.eval_id
                            AND (   a.eval_id = vmaster
                                 OR (    b.eval_master_id = vmaster
                                     AND b.report_type = 'AD'
                                    )
                                )                     --4.0 petermkaw 03122010
                            --AND b.eval_stat_cd <> 'CC' allow retrieval of amounts even if report status is CANCELLED by MAC 12/05/2013.
                       ORDER BY a.eval_id, a.item_no)
            LOOP
               FOR j IN
                  (SELECT   a.amount, a.repair_cd
                       FROM gicl_repair_lps_dtl a, gicl_mc_evaluation b
                      WHERE 1 = 1
                        AND a.eval_id = b.eval_id
                        AND a.repair_cd = i.repair_cd
                        AND NVL (a.tinsmith_type, '*') =
                                                    NVL (i.tinsmith_type, '*')
                        AND a.loss_exp_cd = i.loss_exp_cd
                        AND (   a.eval_id = vmaster
                             OR (    b.eval_master_id = vmaster
                                 AND b.report_type = 'AD'
                                )
                            )                         --4.0 petermkaw 03122010
                        --AND b.eval_stat_cd <> 'CC' allow retrieval of amounts even if report status is CANCELLED by MAC 12/05/2013.
                   ORDER BY a.eval_id, a.item_no)
               LOOP
                  vitemno4 := vitemno4 + 1;

                  INSERT INTO gicl_repair_lps_dtl
                       VALUES (p_eval_id, i.loss_exp_cd, i.repair_cd,
                               i.tinsmith_type, j.amount, vitemno4, 'N');

                  --3.0
                  vlpsrepairamt := NVL (vlpsrepairamt, 0) + j.amount;
                  --vBaseAmt := nvl(vBaseAmt,0) + j.amount;
                  EXIT;
               END LOOP;
            END LOOP;

            --actual amts
            FOR i IN (SELECT a.actual_total_amt, a.other_labor_amt,
                             a.with_vat, a.actual_tinsmith_amt,
                             a.actual_painting_amt
                        FROM gicl_repair_hdr a, gicl_mc_evaluation b
                       WHERE 1 = 1
                         AND a.eval_id = b.eval_id
                         --AND b.eval_stat_cd <> 'CC' allow retrieval of amounts even if report status is CANCELLED by MAC 12/05/2013.
                         AND (   a.eval_id = vmaster
                              OR (    b.eval_master_id = vmaster
                                  AND b.report_type = 'AD'
                                 )
                             ))                       --4.0 petermkaw 03122010
            LOOP
               IF NVL (vwithvat, 'N') = NVL (i.with_vat, 'N')
               THEN
                  aktualnakabuuan := NVL (i.actual_total_amt, 0);
                  ibanggawa := NVL (i.other_labor_amt, 0);
                  aktualtinsmit := NVL (i.actual_tinsmith_amt, 0);
                  aktualpinta := NVL (i.actual_painting_amt, 0);
               ELSE
                  IF NVL (vwithvat, 'N') = 'N' AND NVL (i.with_vat, 'N') =
                                                                          'Y'
                  THEN
                     aktualnakabuuan :=
                         ROUND (i.actual_total_amt / (1 + (vvatrt / 100)), 2);
                     ibanggawa :=
                          ROUND (i.other_labor_amt / (1 + (vvatrt / 100)), 2);
                     aktualtinsmit :=
                        ROUND (i.actual_tinsmith_amt / (1 + (vvatrt / 100)),
                               2
                              );
                     aktualpinta :=
                        ROUND (i.actual_painting_amt / (1 + (vvatrt / 100)),
                               2);
                  ELSIF NVL (vwithvat, 'N') = 'Y'
                        AND NVL (i.with_vat, 'N') = 'N'
                  THEN
                     aktualnakabuuan :=
                        ROUND (  i.actual_total_amt
                               + (i.actual_total_amt * (vvatrt / 100)),
                               2
                              );
                     ibanggawa :=
                        ROUND (  i.other_labor_amt
                               + (i.other_labor_amt * (vvatrt / 100)),
                               2
                              );
                     aktualtinsmit :=
                        ROUND (  i.actual_tinsmith_amt
                               + (i.actual_tinsmith_amt * (vvatrt / 100)),
                               2
                              );
                     aktualpinta :=
                        ROUND (  i.actual_painting_amt
                               + (i.actual_painting_amt * (vvatrt / 100)),
                               2
                              );
                  END IF;
               END IF;

               vactualtotalamt :=
                            NVL (vactualtotalamt, 0)
                            + NVL (aktualnakabuuan, 0);
               votherlaboramt := NVL (votherlaboramt, 0) + NVL (ibanggawa, 0);
               vactualtinsmithamt :=
                           NVL (vactualtinsmithamt, 0)
                           + NVL (aktualtinsmit, 0);
               vactualpaintingamt :=
                             NVL (vactualpaintingamt, 0)
                             + NVL (aktualpinta, 0);
                             
                             INSERT INTO gicl_repair_hdr
                        (eval_id, payee_type_cd, payee_cd, with_vat,
                         lps_repair_amt, actual_total_amt,
                         actual_tinsmith_amt, actual_painting_amt,
                         other_labor_amt, update_sw
                        )                          --petermkaw added update_sw
                 VALUES (p_eval_id, vpayeetypecd, vpayeecd, vwithvat,
                         vlpsrepairamt, vactualtotalamt,
                         vactualtinsmithamt, vactualpaintingamt,
                         votherlaboramt, 'N'
                        );
            END LOOP;

            

            --other details--
            vitemno2 := 0;

            --modify by BETH to fix error in multiple records
            FOR j IN (SELECT DISTINCT a.eval_id, a.repair_cd, a.item_no  --3.0
                                 FROM gicl_repair_other_dtl a,
                                      gicl_mc_evaluation b
                                WHERE 1 = 1
                                  AND a.eval_id = b.eval_id
                                  --AND b.eval_stat_cd <> 'CC' allow retrieval of amounts even if report status is CANCELLED by MAC 12/05/2013.
                                  AND (   b.eval_id = vmaster
                                       OR (    b.eval_master_id = vmaster
                                           AND b.report_type = 'AD'
                                          )
                                      )
                             ORDER BY a.eval_id, a.item_no)
            LOOP
               presyo := 0;
               presyotot := 0;
               vitemno2 := vitemno2 + 1;                                --3.0

               FOR i IN
                  (SELECT   a.amount, c.with_vat
                       FROM gicl_repair_other_dtl a,
                            gicl_mc_evaluation b,
                            gicl_repair_hdr c
                      WHERE 1 = 1
                        AND a.eval_id = c.eval_id
                        AND a.eval_id = b.eval_id
                        AND a.repair_cd = j.repair_cd 
                        --AND b.eval_stat_cd <> 'CC' allow retrieval of amounts even if report status is CANCELLED by MAC 12/05/2013.
                        AND (   b.eval_id = vmaster
                             OR (    b.eval_master_id = vmaster
                                 AND b.report_type = 'AD'
                                )
                            )                         --4.0 petermkaw 03122010
                   ORDER BY a.eval_id, a.item_no)
               LOOP
                  IF NVL (vwithvat, 'N') = NVL (i.with_vat, 'N')
                  THEN
                     presyo := i.amount;
                  ELSE
                     IF     NVL (vwithvat, 'N') = 'Y'
                        AND NVL (i.with_vat, 'N') = 'N'
                     THEN
                        presyo :=
                            ROUND (i.amount + (i.amount * (vvatrt / 100)), 2);
                     ELSIF     NVL (vwithvat, 'N') = 'N'
                           AND NVL (i.with_vat, 'N') = 'Y'
                     THEN
                        presyo := ROUND (i.amount / (1 + (vvatrt / 100)), 2);
                     END IF;
                  END IF;

                  presyotot := NVL (presyotot, 0) + presyo;
               END LOOP;

               INSERT INTO gicl_repair_other_dtl
                    VALUES (p_eval_id, j.repair_cd, presyotot, vitemno2, 'N');
            --3.0
            END LOOP;

            FOR i IN (SELECT NVL (SUM (part_amt), 0) part
                        FROM gicl_replace
                       WHERE eval_id = p_eval_id)
            LOOP
               p_replace_amt := i.part;
            END LOOP;

            FOR i IN (SELECT   NVL (actual_total_amt, 0)
                             + NVL (other_labor_amt, 0) repair
                        FROM gicl_repair_hdr
                       WHERE eval_id = p_eval_id)
            LOOP
               p_repair_amt := i.repair;
            END LOOP;

             /*Added by: jen.011909
            ** Include deductibles and depreciation in
            **   copying details.
            */
            vitemno3 := 0;

            --deductibles--
            FOR i IN
               (SELECT eval_id
                  FROM gicl_mc_evaluation
                 WHERE (   eval_id = vmaster
                        OR (eval_master_id = vmaster AND report_type = 'AD')
                       )                              --4.0 petermkaw 03122010
                   --AND eval_stat_cd <> 'CC' allow retrieval of amounts even if report status is CANCELLED by MAC 12/05/2013.
                   )
            LOOP
               FOR x IN (SELECT ded_cd, subline_cd, no_of_unit, ded_base_amt,
                                ded_amt, ded_rt, ded_text, payee_type_cd,
                                payee_cd, net_tag
                           FROM gicl_eval_deductibles
                          WHERE eval_id = i.eval_id)
               LOOP
                  INSERT INTO gicl_eval_deductibles
                              (eval_id, ded_cd, subline_cd,
                               no_of_unit, ded_base_amt, ded_amt,
                               ded_rt, ded_text, payee_type_cd,
                               payee_cd, net_tag
                              )
                       VALUES (p_eval_id, x.ded_cd, x.subline_cd,
                               x.no_of_unit, x.ded_base_amt, x.ded_amt,
                               x.ded_rt, x.ded_text, x.payee_type_cd,
                               x.payee_cd, x.net_tag
                              );
               END LOOP;

               --depreciation--
               FOR j IN (SELECT   ded_amt, ded_rt, loss_exp_cd, payee_type_cd,
                                  payee_cd, remarks, eval_id, item_no    --3.0
                             FROM gicl_eval_dep_dtl
                            WHERE eval_id = i.eval_id
                         ORDER BY eval_id, item_no)                      --3.0
               LOOP
                  vitemno3 := vitemno3 + 1;                             --3.0

                  INSERT INTO gicl_eval_dep_dtl
                              (eval_id, ded_amt, ded_rt,
                               loss_exp_cd, payee_type_cd, payee_cd,
                               remarks, item_no
                              )                                          --3.0
                       VALUES (p_eval_id, j.ded_amt, j.ded_rt,
                               j.loss_exp_cd, j.payee_type_cd, j.payee_cd,
                               j.remarks, vitemno3
                              );                                         --3.0
               END LOOP;
            END LOOP;

            --total ded--
            FOR totded IN (SELECT SUM (ded_amt) ded_amt
                             FROM gicl_eval_deductibles
                            WHERE eval_id = p_eval_id
                              AND ded_cd <> giisp.v ('CLM DISCOUNT'))
            LOOP
               /*UPDATE GICL_MC_EVALUATION
                  SET DEDUCTIBLE = totDed.ded_amt
                WHERE EVAL_ID = :gicl_mc_evaluation.eval_id;*/--:gicl_mc_evaluation.deductible := totDed.ded_amt; modified by: jen.081709 - to save the correct value of total deductible in mc eval table since deductible field is nbt.
               p_deductible2 := totded.ded_amt;
            END LOOP;

            FOR totdep IN (SELECT SUM (ded_amt) depamt
                             FROM gicl_eval_dep_dtl
                            WHERE eval_id = p_eval_id)
            LOOP
               /*update gicl_mc_evaluation
                  set depreciation = totDep.depAmt
                 where eval_id = :gicl_mc_evaluation.eval_id; */
               p_depreciation := totdep.depamt;
            END LOOP;
            
            
            -- added by kenneth L to insert vat value when copying MC eval report
            FOR vatAmt IN (SELECT vat, inspect_place, inspect_date, adjuster_id
                             FROM gicl_mc_evaluation
                            WHERE eval_id = vmaster)
            LOOP
               p_vat := vatAmt.vat;
               p_inspect_place := vatAmt.inspect_place; --marco - 03.27.2014
               v_inspect_date := vatAmt.inspect_date;   --for copy report
               p_adjuster_id := vatAmt.adjuster_id;     --
            END LOOP;
            

            FOR i IN (SELECT a.apply_to, a.vat_amt, a.vat_rate, a.base_amt,
                             a.payt_payee_type_cd, payt_payee_cd,  net_tag, 
                             less_ded, less_dep, payee_type_cd, payee_cd, with_vat
                        FROM gicl_eval_vat a, gicl_mc_evaluation b
                       WHERE 1 = 1
                         AND a.eval_id = b.eval_id
                         AND (   a.eval_id = vmaster
                              OR (    b.eval_master_id = vmaster
                                  AND b.report_type = 'AD'
                                 )
                             ))     
            LOOP
              INSERT INTO gicl_eval_vat
                    (eval_id, payee_type_cd, payee_cd, apply_to,
                     vat_amt, vat_rate, base_amt, with_vat,
                     payt_payee_type_cd, payt_payee_cd,
                     net_tag, less_ded, less_dep
                    )      
             VALUES (p_eval_id, i.payee_type_cd, i.payee_cd, i.apply_to,
                     i.vat_amt, i.vat_rate, i.base_amt, i.with_vat,
                     i.payt_payee_type_cd, i.payt_payee_cd,
                     i.net_tag, i.less_ded, i.less_dep
                    );
            END LOOP;
            --end for VAT

         END IF;

         /*report is revised*/
         IF p_revise_flag = 'Y'
         THEN
            --update stat_cd--
            UPDATE gicl_mc_evaluation
               SET report_type = 'RD'
             WHERE eval_id = vmaster
                OR (eval_master_id = vmaster AND eval_stat_cd <> 'CC');
         -- p_revise_flag := 'N';
         END IF;
      END IF;

      IF p_eval_master_id IS NOT NULL
      THEN
         --gen eval_seq_no
         BEGIN
            SELECT eval_seq_no, eval_yy
              INTO p_eval_seq_no, p_eval_yy
              --DA20090113TE: gets eval_yy of parent report
            FROM   gicl_mc_evaluation
             WHERE eval_id = p_eval_master_id;
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error
                  ('-20001',
                      'Problem inserting in mc evaluation table with eval_id = '
                   || p_eval_master_id
                   || '.'
                  );                              --petermkawmsg unshow error.
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error
                  ('-20001',
                      'Problem inserting in mc evaluation table with eval_id = '
                   || p_eval_master_id
                   || '.'
                  );                              --petermkawmsg unshow error.
         END;

         BEGIN
            SELECT NVL (MAX (eval_version), 0) + 1
              INTO p_eval_version
              FROM gicl_mc_evaluation
             WHERE subline_cd = p_subline_cd
               AND iss_cd = p_iss_cd
               AND eval_yy = p_eval_yy
               AND eval_seq_no = p_eval_seq_no;
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error ('-20001',
                                           'Too many rows for eval_id '
                                        || p_eval_master_id
                                        || '.'
                                       );          --petermkawmsg unshow error
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error ('-20001',
                                           'No data found for eval_id '
                                        || p_eval_master_id
                                        || '.'
                                       );          --petermkawmsg unshow error
         END;
      ELSE
         --generate eval_seq_no
         BEGIN
            SELECT eval_seq_no + 1
              INTO p_eval_seq_no
              FROM gicl_eval_sequence
             WHERE subline_cd = p_subline_cd
               AND iss_cd = p_iss_cd
               AND eval_yy = p_eval_yy;

            UPDATE gicl_eval_sequence
               SET eval_seq_no = p_eval_seq_no
             WHERE subline_cd = p_subline_cd
               AND iss_cd = p_iss_cd
               AND eval_yy = p_eval_yy;
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error
                             ('-20001',
                              'Too many rows for evaluation sequence number.'
                             );                    --petermkawmsg unshow error
            WHEN NO_DATA_FOUND
            THEN
               INSERT INTO gicl_eval_sequence
                    --VALUES (p_subline_cd, p_iss_cd, p_eval_yy, 0);
                    VALUES (p_subline_cd, p_iss_cd, p_eval_yy, 1);--p_eval_seq_no := 0; replaced by kenneth L. for SR 584 MC EVAL
               --forms_ddl('COMMIT');
               --p_eval_seq_no := 0; replaced by kenneth L. for SR 584 MC EVAL
               p_eval_seq_no := 1;
         END;

         p_eval_version := 0;
      END IF;

      IF p_eval_stat_cd IS NULL
      THEN
         p_eval_stat_cd := 'IP';
      END IF;

      IF p_report_type IS NULL
      THEN
         p_report_type := 'NR';
      END IF;

      --variables.v_evalno := :gicl_mc_evaluation.subline_cd||'-'||
      --                         :gicl_mc_evaluation.iss_cd||'-'||:gicl_mc_evaluation.eval_yy||'-'||
      --                         :gicl_mc_evaluation.eval_seq_no||'-'||:gicl_mc_evaluation.eval_version;

      --msg_alert('eval_seq_no' ||:gicl_mc_evaluation.eval_seq_no,'I',FALSE);--++
      --end of generate eval_seq_no\
      p_inspect_date := TO_CHAR (v_inspect_date, 'MM-DD-YYYY');
   END;

   PROCEDURE insert_mc_eval (
      p_eval_master_id   gicl_mc_evaluation.eval_master_id%TYPE,
      p_inspect_date     VARCHAR2,
      p_inspect_place    gicl_mc_evaluation.inspect_place%TYPE,
      p_subline_cd       gicl_mc_evaluation.subline_cd%TYPE,
      p_iss_cd           gicl_mc_evaluation.iss_cd%TYPE,
      p_eval_yy          gicl_mc_evaluation.eval_yy%TYPE,
      p_cso_id           gicl_mc_evaluation.cso_id%TYPE,
      p_item_no          gicl_mc_evaluation.item_no%TYPE,
      p_claim_id         gicl_mc_evaluation.claim_id%TYPE,
      p_peril_cd         gicl_mc_evaluation.peril_cd%TYPE,
      p_plate_no         gicl_mc_evaluation.plate_no%TYPE,
      p_tp_sw            gicl_mc_evaluation.tp_sw%TYPE,
      p_payee_no         gicl_mc_evaluation.payee_no%TYPE,
      p_payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      p_currency_cd      gicl_mc_evaluation.currency_cd%TYPE,
      p_currency_rate    gicl_mc_evaluation.currency_rate%TYPE,
      p_replace_amt      gicl_mc_evaluation.replace_amt%TYPE,
      p_report_type      gicl_mc_evaluation.report_type%TYPE,
      p_eval_version     gicl_mc_evaluation.eval_version%TYPE,
      p_eval_id          gicl_mc_evaluation.eval_id%TYPE,
      p_eval_seq_no      gicl_mc_evaluation.eval_seq_no%TYPE,
      p_repair_amt       gicl_mc_evaluation.repair_amt%TYPE,
      p_depreciation     gicl_mc_evaluation.depreciation%TYPE,
      p_deductible       gicl_mc_evaluation.deductible%TYPE,
      p_adjuster_id      gicl_mc_evaluation.adjuster_id%TYPE,
      p_eval_stat_cd     gicl_mc_evaluation.eval_stat_cd%TYPE,
      p_eval_date        VARCHAR2,
      p_remarks          gicl_mc_evaluation.remarks%TYPE,
      p_vat              gicl_mc_evaluation.vat%TYPE
   )
   IS
   BEGIN
      MERGE INTO gicl_mc_evaluation
         USING DUAL
         ON (eval_id = p_eval_id)
         WHEN NOT MATCHED THEN
            INSERT (eval_id, item_no, peril_cd, claim_id, subline_cd, iss_cd,
                    eval_yy, eval_seq_no, eval_version, eval_stat_cd,
                    report_type, eval_master_id, payee_no, payee_class_cd,
                    plate_no, tp_sw, cso_id, inspect_date, adjuster_id,
                    replace_amt, repair_amt, vat, deductible, depreciation,
                    currency_cd, currency_rate, user_id, last_update,
                    remarks, inspect_place)
            VALUES (p_eval_id, p_item_no, p_peril_cd, p_claim_id,
                    p_subline_cd, p_iss_cd, p_eval_yy, p_eval_seq_no,
                    p_eval_version, p_eval_stat_cd, p_report_type,
                    p_eval_master_id, p_payee_no, p_payee_class_cd,
                    p_plate_no, p_tp_sw, p_cso_id,
                    TO_DATE (p_inspect_date, 'MM-DD-YYYY'), p_adjuster_id,
                    p_replace_amt, p_repair_amt, p_vat, p_deductible,
                    NVL (p_depreciation, 0), p_currency_cd, p_currency_rate,
                    p_cso_id, SYSDATE, p_remarks, p_inspect_place)
         WHEN MATCHED THEN
            UPDATE
               SET item_no = p_item_no, peril_cd = p_peril_cd,
                   eval_yy = p_eval_yy, eval_seq_no = p_eval_seq_no,
                   eval_version = p_eval_version,
                   eval_stat_cd = p_eval_stat_cd,
                   report_type = p_report_type, payee_no = p_payee_no,
                   payee_class_cd = p_payee_class_cd, plate_no = p_plate_no,
                   tp_sw = p_tp_sw, cso_id = p_cso_id,
                   inspect_date = p_inspect_date,
                   eval_date = TO_DATE (p_eval_date, 'MM-DD-YYYY'),
                   adjuster_id = p_adjuster_id, replace_amt = p_replace_amt,
                   repair_amt = p_repair_amt, vat = p_vat,
                   deductible = p_deductible, depreciation = p_depreciation,
                   currency_cd = p_currency_cd,
                   currency_rate = p_currency_rate, user_id = p_cso_id,
                   last_update = SYSDATE
            ;
   END;

   FUNCTION get_copy_report_list (
      p_claim_id    gicl_claims.claim_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN copy_report_tab PIPELINED
   IS
      v_eval   copy_report_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM (SELECT eval_id,
                                    subline_cd
                                 || '-'
                                 || iss_cd
                                 || '-'
                                 || LPAD (eval_yy, 2, '0')
                                 || '-'
                                 || LPAD (eval_seq_no, 5, '0')
                                 || '-'
                                 || LPAD (eval_version, 2, '0') eval_no
                            FROM gicl_mc_evaluation a
                           WHERE 1 = 1 AND claim_id = p_claim_id)
                   WHERE UPPER (eval_no) LIKE NVL (UPPER (p_find_text), '%%')
                ORDER BY eval_id)
      LOOP
         v_eval.evaluation_no := i.eval_no;
         v_eval.eval_id := i.eval_id;
         PIPE ROW (v_eval);
      END LOOP;
   END;

   PROCEDURE update_mc_eval (
      p_eval_id         gicl_mc_evaluation.eval_id%TYPE,
      p_remarks         gicl_mc_evaluation.remarks%TYPE,
      p_inspect_date    VARCHAR2,
      p_adjuster_id     gicl_mc_evaluation.adjuster_id%TYPE,
      p_inspect_place   gicl_mc_evaluation.inspect_place%TYPE
   )
   IS
   BEGIN
      UPDATE gicl_mc_evaluation
         SET remarks = p_remarks,
             inspect_date = TO_DATE (p_inspect_date, 'MM/DD/YYYY'),
             adjuster_id = p_adjuster_id,
             last_update = SYSDATE,
             inspect_place = p_inspect_place
       WHERE eval_id = p_eval_id;
   END;

   PROCEDURE cancel_mc_eval (
      p_eval_id          gicl_mc_evaluation.eval_id%TYPE,
      p_eval_master_id   gicl_mc_evaluation.eval_master_id%TYPE,
      p_report_type      gicl_mc_evaluation.report_type%TYPE
   )
   IS
   BEGIN
      UPDATE gicl_mc_evaluation
         SET eval_stat_cd = 'CC'
       WHERE eval_id = p_eval_id;

      IF p_eval_master_id IS NULL                   --OR p_eval_master_id = ''
      THEN                    --means that cancelled report is a master report
         UPDATE gicl_mc_evaluation
            SET eval_stat_cd = 'CC'
          WHERE eval_master_id = p_eval_id;
      ELSIF p_eval_master_id IS NOT NULL AND
                                            --if report is a revised version of an existing report...
                                            p_report_type = 'NR'
      THEN
         FOR i IN (SELECT eval_id
                     FROM gicl_mc_evaluation
                    WHERE eval_id = p_eval_master_id AND report_type = 'RD')
         LOOP
            UPDATE gicl_mc_evaluation
               SET report_type = 'NR'
             WHERE eval_id = i.eval_id;

            UPDATE gicl_mc_evaluation
               SET report_type = 'AD'
             WHERE eval_master_id = i.eval_id AND report_type <> 'CC';

            EXIT;
         END LOOP;
      END IF;

      /* Added by Marlo
      ** 01052010
      ** To cancel LOA of the report cancelled.*/
      UPDATE gicl_eval_loa
         SET cancel_sw = 'Y'
       WHERE eval_id = p_eval_id;
   END;

   FUNCTION get_for_additional_report_list (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_plate_no         gicl_mc_evaluation.plate_no%TYPE,
      p_peril_cd         gicl_mc_evaluation.peril_cd%TYPE,
      p_payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      p_payee_no         gicl_mc_evaluation.payee_no%TYPE,
      p_tp_sw            gicl_mc_evaluation.tp_sw%TYPE,
      p_eval_stat_cd     gicl_mc_evaluation.eval_stat_cd%TYPE,
      p_item_no          gicl_mc_evaluation.item_no%TYPE,
      p_find_text        VARCHAR2
   )
      RETURN for_additional_report_tab PIPELINED
   IS
      v_rep   for_additional_report_type;
   BEGIN
      FOR i IN
         (SELECT *
            FROM (SELECT a.eval_id,
                            a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LPAD (a.eval_yy, 2, 0)
                         || '-'
                         || LPAD (a.eval_seq_no, 12, 0)
                         || '-'
                         || LPAD (a.eval_version, 2, 0) evaluation_no,
                         TO_CHAR (a.inspect_date, 'mm-dd-rrrr') inspect_date,
                         TO_CHAR (a.eval_date, 'mm-dd-rrrr') eval_date,
                         a.inspect_place, b.eval_stat_desc, a.adjuster_id,
                         d.payee_name adjuster
                    FROM gicl_mc_evaluation a,
                         gicl_mc_eval_stat b,
                         gicl_clm_adjuster c,
                         giis_adjuster d
                   WHERE 1 = 1
                     AND a.eval_stat_cd = b.eval_stat_cd
                     AND a.claim_id = p_claim_id
                     AND a.item_no = p_item_no
                     AND NVL (a.plate_no, '*') = NVL (p_plate_no, '*')
                     AND NVL (a.peril_cd, -1) = NVL (p_peril_cd, -1)
                     AND NVL (a.payee_class_cd, '*') =
                                                   NVL (p_payee_class_cd, '*')
                     AND NVL (a.payee_no, -1) = NVL (p_payee_no, -1)
                     AND a.tp_sw = p_tp_sw
                     AND a.adjuster_id = c.clm_adj_id(+)
                     AND c.adj_company_cd = d.adj_company_cd(+)
                     AND c.priv_adj_cd = d.priv_adj_cd(+)
                     AND a.eval_stat_cd = 'PD'
                     AND a.eval_master_id IS NULL
                     AND a.report_type <> 'RD'
                     AND 1 =
                            (SELECT DECODE
                                       (p_eval_stat_cd,
                                        'AD', 1,
                                        'RD', (SELECT 1
                                                 FROM DUAL
                                                WHERE NVL
                                                         ((SELECT 2
                                                             FROM gicl_eval_payment
                                                            WHERE eval_id =
                                                                     a.eval_id
                                                              AND clm_loss_id IS NOT NULL
                                                              AND ROWNUM = 1),
                                                          0
                                                         ) = 0
                                                  AND NVL
                                                         ((SELECT 2
                                                             FROM gicl_mc_evaluation
                                                            WHERE eval_master_id =
                                                                     a.eval_id
                                                              AND eval_stat_cd =
                                                                          'AD'
                                                              AND ROWNUM = 1),
                                                          0
                                                         ) = 0)
                                       )
                               FROM DUAL)
                  UNION ALL
                  SELECT a.eval_id,
                            a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LPAD (a.eval_yy, 2, 0)
                         || '-'
                         || LPAD (a.eval_seq_no, 12, 0)
                         || '-'
                         || LPAD (a.eval_version, 2, 0) eval_no,
                         TO_CHAR (a.inspect_date, 'mm-dd-rrrr') inspect_date,
                         TO_CHAR (a.eval_date, 'mm-dd-rrrr') eval_date,
                         a.inspect_place, b.eval_stat_desc, a.adjuster_id,
                         d.payee_name adjuster
                    FROM gicl_mc_evaluation a,
                         gicl_mc_eval_stat b,
                         gicl_clm_adjuster c,
                         giis_adjuster d
                   WHERE 1 = 1
                     AND a.eval_stat_cd = b.eval_stat_cd
                     AND a.claim_id = p_claim_id
                     AND a.item_no = p_item_no
                     AND NVL (a.plate_no, '*') = NVL (p_plate_no, '*')
                     AND NVL (a.peril_cd, -1) = NVL (p_peril_cd, -1)
                     AND NVL (a.payee_class_cd, '*') =
                                                   NVL (p_payee_class_cd, '*')
                     AND NVL (a.payee_no, -1) = NVL (p_payee_no, -1)
                     AND a.tp_sw = p_tp_sw
                     AND a.adjuster_id = c.clm_adj_id(+)
                     AND c.adj_company_cd = d.adj_company_cd(+)
                     AND c.priv_adj_cd = d.priv_adj_cd(+)
                     AND a.eval_stat_cd = 'PD'
                     AND a.eval_master_id IS NOT NULL
                     AND a.report_type = 'IP'
                     AND 'RD' = (SELECT report_type
                                   FROM gicl_mc_evaluation
                                  WHERE eval_id = a.eval_master_id)
                     AND 1 =
                            (SELECT DECODE
                                       (p_eval_stat_cd,
                                        'AD', 1,
                                        'RD', (SELECT 1
                                                 FROM DUAL
                                                WHERE NVL
                                                         ((SELECT 2
                                                             FROM gicl_eval_payment
                                                            WHERE eval_id =
                                                                     a.eval_id
                                                              AND clm_loss_id IS NOT NULL
                                                              AND ROWNUM = 1),
                                                          0
                                                         ) = 0
                                                  AND NVL
                                                         ((SELECT 2
                                                             FROM gicl_mc_evaluation
                                                            WHERE eval_master_id =
                                                                     a.eval_id
                                                              AND eval_stat_cd =
                                                                          'AD'
                                                              AND ROWNUM = 1),
                                                          0
                                                         ) = 0)
                                       )
                               FROM DUAL))
           WHERE UPPER (evaluation_no) LIKE NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_rep.eval_id := i.eval_id;
         v_rep.evaluation_no := i.evaluation_no;
         v_rep.eval_date := i.eval_date;
         v_rep.inspect_date := i.inspect_date;
         v_rep.inspect_place := i.inspect_place;
         v_rep.dsp_eval_desc := i.eval_stat_desc;
         v_rep.adjuster_id := i.adjuster_id;
         v_rep.adjuster := i.adjuster;
         PIPE ROW (v_rep);
      END LOOP;
   END;

   PROCEDURE validate_before_posting (
      p_claim_id           gicl_claims.claim_id%TYPE,
      p_item_no            gicl_mc_evaluation.item_no%TYPE,
      p_peril_cd           gicl_mc_evaluation.peril_cd%TYPE,
      p_eval_id            gicl_mc_evaluation.eval_id%TYPE,
      p_clm_iss_cd         gicl_claims.iss_cd%TYPE,
      p_user_id            VARCHAR2,
      p_res_amt      OUT   gicl_mc_evaluation.repair_amt%TYPE,
      p_message      OUT   VARCHAR2
   )
   IS
      v_res_amt          gicl_mc_evaluation.repair_amt%TYPE;
      validate_reserve   VARCHAR2 (1);
      all_res_sw         VARCHAR2 (1);
      alw_amt            gicl_adv_line_amt.res_range_to%TYPE;
   BEGIN
      BEGIN
         SELECT   SUM (  (NVL (repair_amt, 0) + NVL (replace_amt, 0))
                       + NVL (vat, 0)
                      )
                - (SUM (ABS (NVL (deductible, 0))
                        + ABS (NVL (depreciation, 0)))
                  )
           INTO v_res_amt
           FROM gicl_mc_evaluation
          WHERE (    claim_id = p_claim_id
                 AND item_no = p_item_no
                 AND peril_cd = p_peril_cd
                 AND eval_stat_cd = 'PD'
                 AND report_type <> 'RD'
                )
             OR eval_id = p_eval_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message := 'No posted reports';
            RETURN;
      END;

      BEGIN
         --SELECT ann_tsi_amt                              --eminemcy da082206te
         SELECT allow_tsi_amt --marco - 03.27.2014
           INTO alw_amt
           FROM gicl_item_peril
          WHERE claim_id = p_claim_id
            AND item_no = p_item_no
            AND peril_cd = p_peril_cd
            AND grouped_item_no = 0;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            raise_application_error
               ('-20001',
                'no_data_found or too_many_rows retrieved in gicl_item_peril'
               );
      END;

      IF alw_amt < v_res_amt
      THEN
         p_message :=
               'Total Reserve Amount should not exceed '
            || LTRIM (TO_CHAR (alw_amt, '9,999,999,999,999,990.00'));
      END IF;

      BEGIN
         SELECT param_value_v
           INTO validate_reserve
           FROM giis_parameters
          WHERE param_name = 'VALIDATE_RESERVE_LIMITS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
                      ('-20001',
                       'VALIDATE_RESERVE_LIMITS not found in giis_parameters'
                      );
      END;

      IF validate_reserve = 'Y'
      THEN
         BEGIN
            SELECT NVL (all_res_amt_sw, 'N')
              INTO all_res_sw
              FROM gicl_adv_line_amt
             WHERE adv_user = p_user_id AND line_cd = 'MC'
                   AND iss_cd = p_clm_iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_message :=
                  'User is not allowed to make a reserve, please refer to the reserve maintenance';
         END;

         IF all_res_sw = 'N'
         THEN
            BEGIN
               SELECT NVL (res_range_to, 0)
                 INTO alw_amt
                 FROM gicl_adv_line_amt
                WHERE adv_user = p_user_id
                  AND line_cd = 'MC'
                  AND iss_cd = p_clm_iss_cd;
            END;

            IF v_res_amt > alw_amt
            THEN
               p_message := 'Show override';
            END IF;
         END IF;
      END IF;

      -- p_message := 'Show override';
      p_res_amt := v_res_amt;
   END;

   PROCEDURE post_evaluation_report (
      p_eval_id         gicl_mc_evaluation.eval_id%TYPE,
      p_claim_id        gicl_claims.claim_id%TYPE,
      p_item_no         gicl_mc_evaluation.item_no%TYPE,
      p_peril_cd        gicl_mc_evaluation.peril_cd%TYPE,
      p_currency_cd     gicl_mc_evaluation.currency_cd%TYPE,
      p_currency_rate   gicl_mc_evaluation.currency_rate%TYPE,
      p_remarks         gicl_mc_evaluation.remarks%TYPE,
      p_inspect_date    VARCHAR2,
      p_adjuster_id     gicl_mc_evaluation.adjuster_id%TYPE,
      p_inspect_place   gicl_mc_evaluation.inspect_place%TYPE
   )
   IS
      v_res_amt   gicl_mc_evaluation.repair_amt%TYPE;
   BEGIN
      BEGIN
         SELECT   SUM (  (NVL (repair_amt, 0) + NVL (replace_amt, 0))
                       + NVL (vat, 0)
                      )
                - (SUM (ABS (NVL (deductible, 0))
                        + ABS (NVL (depreciation, 0)))
                  )
           INTO v_res_amt
           FROM gicl_mc_evaluation
          WHERE (    claim_id = p_claim_id
                 AND item_no = p_item_no
                 AND peril_cd = p_peril_cd
                 AND eval_stat_cd = 'PD'
                 AND report_type <> 'RD'
                )
             OR eval_id = p_eval_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error ('-20001', 'No posted rerpots');
            RETURN;
      END;

      create_evaluation_reserve_web (p_claim_id,
                                     p_item_no,
                                     0,
                                     p_peril_cd,
                                     v_res_amt,
                                     p_currency_cd,
                                     p_currency_rate
                                    );

      UPDATE gicl_mc_evaluation
         SET eval_stat_cd = 'PD',
             eval_date = SYSDATE,
             remarks = p_remarks,
             inspect_date = TO_DATE (p_inspect_date, 'MM/DD/YYYY'),
             adjuster_id = p_adjuster_id,
             last_update = SYSDATE,
             inspect_place = p_inspect_place
       WHERE eval_id = p_eval_id;
   END;

   PROCEDURE create_settlement_for_report (
      p_eval_id           gicl_mc_evaluation.eval_id%TYPE,
      p_claim_id     IN   gicl_mc_evaluation.claim_id%TYPE,
      p_item_no      IN   gicl_mc_evaluation.item_no%TYPE,
      p_peril_cd     IN   gicl_mc_evaluation.peril_cd%TYPE,
      p_tot_estcos        gicl_mc_evaluation.vat%TYPE,
      p_vat               gicl_mc_evaluation.vat%TYPE
   )
   IS
      --for settlement
      clmnt_no          gicl_clm_claimant.clm_clmnt_no%TYPE;
      clmlossid         gicl_clm_loss_exp.clm_loss_id%TYPE;
      histseqno         gicl_clm_loss_exp.hist_seq_no%TYPE;
      statuscd          gicl_le_stat.le_stat_cd%TYPE;
      rplce_loss_exp    giis_loss_exp.loss_exp_cd%TYPE;
      rpair_loss_exp    giis_loss_exp.loss_exp_cd%TYPE;
      deddep_loss_exp   giis_loss_exp.loss_exp_cd%TYPE;
      tax_cd            giis_payee_class.clm_vat_cd%TYPE;
      param             giis_parameters.param_value_v%TYPE;
      baseamt           gicl_eval_vat.base_amt%TYPE;
      taxamt            gicl_eval_vat.vat_amt%TYPE;
      vatrt             gicl_eval_vat.vat_rate%TYPE;
      taxid             giis_loss_taxes.tax_cd%TYPE;
      sltypecd          giis_loss_taxes.sl_type_cd%TYPE;
      net_adv_tag       VARCHAR2 (1);
      v_param           giis_parameters.param_value_v%TYPE;
      ans               NUMBER;
      x                 NUMBER;
      partruntot        NUMBER                                := 0;
      vatruntot         NUMBER                                := 0;
      dedruntot         NUMBER                                := 0;
      depruntot         NUMBER                                := 0;
      basepartamt       NUMBER;                                          --**
      baselabramt       NUMBER;                                          --**
      --deductible dtls
      partlabortot      NUMBER                                := 0;
      deppartamt        NUMBER;
      hasvatflag        NUMBER                                := 0;
   BEGIN
      --status code--
      BEGIN
         SELECT le_stat_cd
           INTO statuscd
           FROM gicl_le_stat
          WHERE le_stat_cd = giisp.v ('MC_EVAL_ITEM_STAT_CD');      --v_param;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error ('-20001',
                                     'no stat cd found in gicl_le_stat'
                                    );
      END;

      --loss expense code for replace--
      rplce_loss_exp := giisp.v ('PART_EVAL_CD');
      --loss_expense_cd for repair--
      rpair_loss_exp := giisp.v ('LABOR_EVAL_CD');

      FOR mc IN (SELECT DISTINCT NVL (payt_payee_cd, payee_cd) payee_cd,
                                 NVL (payt_payee_type_cd,
                                      payee_type_cd
                                     ) payee_type_cd
                            FROM gicl_replace
                           WHERE eval_id = p_eval_id
                 UNION
                 SELECT DISTINCT payee_cd, payee_type_cd
                            FROM gicl_repair_hdr
                           WHERE eval_id = p_eval_id)
      LOOP
         partruntot := 0;
         vatruntot := 0;
         dedruntot := 0;
         depruntot := 0;
         partlabortot := 0;
         gen_clmlossid_histseqno (mc.payee_type_cd,
                                  mc.payee_cd,
                                  clmlossid,
                                  histseqno,
                                  p_claim_id,
                                  p_item_no,
                                  p_peril_cd
                                 );

         INSERT INTO gicl_eval_payment
                     (claim_id, eval_id, clm_loss_id
                     )
              VALUES (p_claim_id, p_eval_id, clmlossid
                     );

         BEGIN
            SELECT COUNT(1)
              INTO x
              FROM gicl_loss_exp_payees
             WHERE 1 = 1
               AND claim_id = p_claim_id
               AND payee_type = 'L'
               AND payee_class_cd = mc.payee_type_cd
               AND payee_cd = mc.payee_cd
               AND item_no = p_item_no;
               --AND peril_cd = p_peril_cd -- Commented out by Jerome Bautista 08.18.2015 SR 19998
               --AND ROWNUM = 1;
         --EXCEPTION 
            --WHEN NO_DATA_FOUND
           IF x = 0 THEN -- Added by Jerome Bautista 08.18.2015 SR 19998
               /*generate claimant number*/
               FOR get_max_clmnt_no IN
                  (SELECT NVL (MAX (clm_clmnt_no), 0) clm_clmnt_no
                     FROM gicl_clm_claimant
                    WHERE claim_id = p_claim_id)
               LOOP
                  clmnt_no := get_max_clmnt_no.clm_clmnt_no;
               END LOOP;

               clmnt_no := NVL (clmnt_no, 0) + 1;

               INSERT INTO gicl_loss_exp_payees
                           (claim_id, payee_type, payee_class_cd, payee_cd,
                            item_no, peril_cd, grouped_item_no, clm_clmnt_no
                           )
                    VALUES (p_claim_id, 'L', mc.payee_type_cd, mc.payee_cd,
                            p_item_no, p_peril_cd, 0, NVL (clmnt_no, 0)
                           );
           ELSIF x = 1 THEN
               INSERT INTO gicl_loss_exp_payees
                           (claim_id, payee_type, payee_class_cd, payee_cd,
                            item_no, peril_cd, grouped_item_no, clm_clmnt_no
                           )
                    VALUES (p_claim_id, 'L', mc.payee_type_cd, mc.payee_cd,
                            p_item_no, p_peril_cd, 0, 1
                           );
           END IF;
         END;

         gen_payee_dtls (mc.payee_type_cd,
                         mc.payee_cd,
                         'P',
                         clmlossid,
                         clmnt_no,
                         tax_cd,
                         baseamt,
                         taxamt,
                         vatrt,
                         taxid,
                         sltypecd,
                         p_eval_id,
                         p_claim_id,
                         p_item_no,
                         p_peril_cd
                        );

         INSERT INTO gicl_clm_loss_exp
                     (claim_id, clm_loss_id, hist_seq_no, item_no,
                      peril_cd, item_stat_cd, payee_type, payee_cd,
                      payee_class_cd, ex_gratia_sw, dist_sw, paid_amt,
                      net_amt, advise_amt,
                      remarks,
                      cancel_sw, clm_clmnt_no, grouped_item_no
                     )
              VALUES (p_claim_id, clmlossid, histseqno, p_item_no,
                      p_peril_cd, statuscd, 'L', mc.payee_cd,
                      mc.payee_type_cd, 'N', 'N', p_tot_estcos,
                      p_tot_estcos - p_vat, p_tot_estcos - p_vat,
                      'Settlement done after posting MC Evaluation Report',
                      'N', clmnt_no, 0
                     );

         --REPlACE--
         BEGIN
            SELECT 1
              INTO hasvatflag
              FROM gicl_eval_vat
             WHERE eval_id = p_eval_id
               AND payee_type_cd = mc.payee_type_cd
               AND payee_cd = mc.payee_cd
               AND apply_to = 'P'
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               hasvatflag := 0;
         END;

         basepartamt := 0;

         FOR j IN (SELECT NVL (with_vat, 'N') w_vat, part_amt
                     FROM gicl_replace
                    WHERE eval_id = p_eval_id
                      AND NVL (payt_payee_type_cd, payee_type_cd) =
                                                              mc.payee_type_cd
                      AND NVL (payt_payee_cd, payee_cd) = mc.payee_cd)
         LOOP
            --msg_alert('base '||j.part_amt,'I',FALSE);--++
            IF NVL (j.w_vat, 'N') = 'Y' AND hasvatflag = 1
            THEN
               basepartamt :=
                    NVL (basepartamt, 0)
                  + ROUND (j.part_amt / (1 + (giacp.n ('INPUT_VAT_RT') / 100)),
                           2
                          );
            ELSE
               basepartamt := NVL (basepartamt, 0) + j.part_amt;
            END IF;
           --basePartAmt := nvl(basePartAmt,0) + j.part_amt;
         --msg_alert('tot '||basePartAmt,'I',FALSE);--++
         END LOOP;

         IF basepartamt <> 0
         THEN
            INSERT INTO gicl_loss_exp_dtl
                        (claim_id, clm_loss_id, line_cd, loss_exp_cd,
                         dtl_amt, ded_base_amt,                  --subline_cd,
                                               loss_exp_type,
                         loss_exp_class, no_of_units
                        )
                 VALUES (p_claim_id, clmlossid, 'MC', rplce_loss_exp,
                         basepartamt, basepartamt, 
                                                   -- :master_blk.clm_subline_cd,

                         /*j.payee_type_cd*/
                         'L',
                         'P', 1
                        );

            partruntot := partruntot + NVL (basepartamt, 0);
            --fields of loss tax dtls:
            net_adv_tag := 'N';

            --for net_tag and adv_tag, if w_tax = 'Y', then both of them is equal to 'Y'
            IF tax_cd IS NOT NULL AND taxid IS NOT NULL AND taxamt IS NOT NULL
            THEN                                                  --da071106te
               INSERT INTO gicl_loss_exp_tax
                           (claim_id, clm_loss_id, tax_cd, tax_type,
                            loss_exp_cd, base_amt, tax_amt, tax_pct,
                            adv_tag, net_tag, w_tax, tax_id, sl_type_cd,
                            sl_cd
                           )
                    VALUES (p_claim_id, clmlossid, tax_cd, 'I',
                            rplce_loss_exp, baseamt, taxamt, vatrt,
                            net_adv_tag, net_adv_tag, 'N', taxid, sltypecd,
                            mc.payee_cd
                           );

               vatruntot := vatruntot + NVL (taxamt, 0);
            END IF;
         END IF;

         --<<end replace>>--

         --REPAIR--
         BEGIN
            SELECT 1
              INTO hasvatflag
              FROM gicl_eval_vat
             WHERE eval_id = p_eval_id
               AND payee_type_cd = mc.payee_type_cd
               AND payee_cd = mc.payee_cd
               AND apply_to = 'L'
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               hasvatflag := 0;
         END;

         --gicl_repair_hdr--
         gen_payee_dtls (mc.payee_type_cd,
                         mc.payee_cd,
                         'L',
                         clmlossid,
                         clmnt_no,
                         tax_cd,
                         baseamt,
                         taxamt,
                         vatrt,
                         taxid,
                         sltypecd,
                         p_eval_id,
                         p_claim_id,
                         p_item_no,
                         p_peril_cd
                        );
         --basePartAmt := 0;
         baselabramt := 0;

         FOR n IN (SELECT NVL (with_vat, 'N') w_vat,
                            NVL (actual_total_amt, 0)
                          + NVL (other_labor_amt, 0) part_amt
                     FROM gicl_repair_hdr
                    WHERE eval_id = p_eval_id
                      AND payee_type_cd = mc.payee_type_cd
                      AND payee_cd = mc.payee_cd)
         LOOP
            baselabramt := n.part_amt;

            --fields of loss details:
            INSERT INTO gicl_loss_exp_dtl
                        (claim_id, clm_loss_id, line_cd, loss_exp_cd,
                         dtl_amt, ded_base_amt,                  --subline_cd,
                                               loss_exp_type,
                         loss_exp_class, no_of_units, w_tax
                        )
                 VALUES (p_claim_id, clmlossid, 'MC', rpair_loss_exp,
                         baselabramt, baselabramt, 
                                                   --:master_blk.clm_subline_cd,

                         /*m.payee_type_cd*/
                         'L',
                         'L', 1, n.w_vat
                        );

            --fields of loss tax dtls:
            net_adv_tag := n.w_vat;

            --for net_tag and adv_tag, if w_tax = 'Y', then both of them is equal to 'Y'
            IF tax_cd IS NOT NULL AND taxid IS NOT NULL AND taxamt IS NOT NULL
            THEN                                                  --da071106te
               INSERT INTO gicl_loss_exp_tax
                           (claim_id, clm_loss_id, tax_cd, tax_type,
                            loss_exp_cd, base_amt, tax_amt, tax_pct,
                            adv_tag, net_tag, w_tax, tax_id,
                            sl_type_cd, sl_cd
                           )
                    VALUES (p_claim_id, clmlossid, tax_cd, 'I',
                            rpair_loss_exp, baseamt, taxamt, vatrt,
                            net_adv_tag, net_adv_tag, n.w_vat, taxid,
                            sltypecd, mc.payee_cd
                           );

               IF NVL (n.w_vat, 'N') = 'N'
               THEN
                  vatruntot := NVL (vatruntot, 0) + NVL (taxamt, 0);
               END IF;
            END IF;
         END LOOP;

         partlabortot := NVL (partruntot, 0) + NVL (baselabramt, 0);

         FOR ded IN (SELECT ded_cd, subline_cd, no_of_unit, ded_base_amt,
                            DECODE (SIGN (ded_amt),
                                    -1, ded_amt,
                                    -ded_amt
                                   ) ded_amt,
                            ded_rt, ded_text
                       FROM gicl_eval_deductibles
                      WHERE 1 = 1
                        AND eval_id = p_eval_id
                        AND payee_type_cd = mc.payee_type_cd
                        AND payee_cd = mc.payee_cd)
         LOOP
            BEGIN
               SELECT loss_exp_cd                                   --,dtl_amt
                 INTO deddep_loss_exp
                 FROM gicl_loss_exp_dtl a                  --, giis_loss_exp b
                WHERE 1 = 1
                  AND a.subline_cd IS NULL
                  AND a.claim_id = p_claim_id
                  AND a.clm_loss_id = clmlossid;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error ('-20001',
                                           ' no_data_found in deductibles'
                                          );
               WHEN TOO_MANY_ROWS
               THEN
                  deddep_loss_exp := '%ALL%';
            END;

            --hindi ba dpat ung ded_base_amt, galing sa table?
            INSERT INTO gicl_loss_exp_dtl
                        (claim_id, clm_loss_id, line_cd, loss_exp_cd,
                         dtl_amt, ded_base_amt, ded_loss_exp_cd,
                         deductible_text, no_of_units, subline_cd,
                         loss_exp_type, ded_rate
                        )
                 VALUES (p_claim_id, clmlossid, 'MC', ded.ded_cd,
                         ded.ded_amt, ded.ded_base_amt, deddep_loss_exp,
                         ded.ded_text, ded.no_of_unit, ded.subline_cd,
                         'L', ded.ded_rt
                        );

            dedruntot := dedruntot + NVL (ded.ded_amt, 0);

            FOR z IN (SELECT   partruntot partlabor_amt,
                               rplce_loss_exp loss_exp_cd
                          --, b.ded_cd, b.ded_amt, b.ded_rt
                      FROM     gicl_replace a      --, gicl_eval_deductibles b
                         WHERE 1 = 1
                           AND a.eval_id = p_eval_id
                           AND NVL (a.payt_payee_type_cd, a.payee_type_cd) =
                                                              mc.payee_type_cd
                           AND NVL (a.payt_payee_cd, a.payee_cd) = mc.payee_cd
                      GROUP BY NVL (a.payt_payee_type_cd, a.payee_type_cd),
                               NVL (a.payt_payee_cd, a.payee_cd)
                      UNION ALL
                      SELECT   NVL (other_labor_amt, 0)
                             + NVL (actual_total_amt, 0),
                             rpair_loss_exp  --, b.ded_cd, b.ded_amt, b.ded_rt
                        FROM gicl_repair_hdr a     --, gicl_eval_deductibles b
                       WHERE 1 = 1
                         AND a.eval_id = p_eval_id
                         AND a.payee_type_cd = mc.payee_type_cd
                         AND a.payee_cd = mc.payee_cd)
            LOOP
               INSERT INTO gicl_loss_exp_ded_dtl
                           (claim_id, clm_loss_id, line_cd, loss_exp_type,
                            -- subline_cd,
                            loss_exp_cd, loss_amt, ded_cd,
                            ded_amt,
                            ded_rate
                           )
                    VALUES (p_claim_id, clmlossid, 'MC', 'L',
                            ded.ded_cd, z.partlabor_amt, z.loss_exp_cd,
                            (ded.ded_amt / partlabortot
                            ) * z.partlabor_amt,
                            (ABS (ded.ded_amt) / partlabortot
                            ) * 100
                           );
            /* VALUES (p_claim_id, clmlossid, 'MC', 'L',
             ded.ded_cd, z.partlabor_amt, z.loss_exp_cd,
             (ded.ded_amt / partlabortot
             ) * z.partlabor_amt,
             (ABS (ded.ded_amt) / partlabortot
             ) * 100
            );*/
            END LOOP;
         END LOOP;

         --DEPRECIATION DETAILS--
         FOR dep IN (SELECT   MAX (a.payee_cd) payee_cd,
                              MAX (a.payee_type_cd) payee_type_cd,
                              SUM (b.part_amt) part_amt,
                              
                              --SUM(DECODE(SIGN(a.ded_amt),-1,a.ded_amt,-a.ded_amt)) ded_amt  --emcy DA041907TE
                              SUM (ABS (a.ded_amt)) ded_amt
                         FROM gicl_eval_dep_dtl a, gicl_replace b
                        WHERE a.eval_id = p_eval_id
                          AND b.eval_id = p_eval_id
                          AND a.loss_exp_cd = b.loss_exp_cd
                          AND a.payee_type_cd = mc.payee_type_cd
                          AND a.payee_cd = mc.payee_cd
                     GROUP BY a.eval_id)
         LOOP
            INSERT INTO gicl_loss_exp_dtl
                        (loss_exp_cd, dtl_amt,
                         ded_rate,
                         ded_loss_exp_cd, no_of_units, ded_base_amt,
                         claim_id, clm_loss_id, line_cd, loss_exp_type
                        )
                 VALUES (giisp.v ('MC_DEPRECIATION_CD'), dep.ded_amt,
                         (ABS (dep.ded_amt) / dep.part_amt
                         ) * 100,
                         rplce_loss_exp, 1, dep.part_amt,
                         p_claim_id, clmlossid, 'MC', 'L'
                        );

            depruntot := depruntot + NVL (dep.ded_amt, 0);

            --depreiciation details--
            INSERT INTO gicl_loss_exp_ded_dtl
                        (claim_id, clm_loss_id, line_cd, loss_exp_type,
                         -- subline_cd,
                         loss_exp_cd, loss_amt,
                         ded_cd, ded_amt,
                         ded_rate
                        )
                 VALUES (p_claim_id, clmlossid, 'MC', 'L',
                         giisp.v ('MC_DEPRECIATION_CD'), dep.part_amt,
                         rplce_loss_exp, NVL (dep.ded_amt, 0),
                           ABS (NVL (dep.ded_amt, 0) / NVL (dep.part_amt, 0))
                         * 100
                        );

            EXIT;
         END LOOP;                                              --depreciation

         UPDATE gicl_clm_loss_exp
            SET paid_amt =
                     (NVL (partlabortot, 0) + NVL (vatruntot, 0))
                   - (ABS (NVL (depruntot, 0)) + ABS (NVL (dedruntot, 0))),
                net_amt =
                     NVL (partlabortot, 0)
                   - (ABS (NVL (depruntot, 0)) + ABS (NVL (dedruntot, 0))),
                advise_amt =
                     NVL (partlabortot, 0)
                   - (ABS (NVL (depruntot, 0)) + ABS (NVL (dedruntot, 0)))
          WHERE claim_id = p_claim_id AND clm_loss_id = clmlossid;
      --emcy('paid_amt '||( nvl(partLaborTot,0) + nvl(vatRunTot,0) ) - ( abs(nvl(depRunTot,0)) + abs( nvl(dedRunTot,0))),'c:\gicls070.emcylog','a');--++
      END LOOP;
   END;

   FUNCTION validate_override_user (
      p_user_id   IN   giac_users.user_id%TYPE,
      p_iss_cd    IN   gicl_claims.iss_cd%TYPE,
      p_res_amt   IN   gicl_mc_evaluation.repair_amt%TYPE,
      p_param          VARCHAR2
   )
      RETURN VARCHAR2
   IS
      all_res_sw   VARCHAR2 (1);
      res_amt      gicl_adv_line_amt.res_range_to%TYPE;
   BEGIN
      IF p_param = 'R'
      THEN
         BEGIN
            SELECT NVL (all_res_amt_sw, 'N')
              INTO all_res_sw
              FROM gicl_adv_line_amt
             WHERE adv_user = p_user_id AND line_cd = 'MC'
                   AND iss_cd = p_iss_cd;

            IF all_res_sw = 'N'
            THEN
               SELECT NVL (res_range_to, 0)
                 INTO res_amt
                 FROM gicl_adv_line_amt
                WHERE adv_user = p_user_id
                  AND line_cd = 'MC'
                  AND iss_cd = p_iss_cd;

               IF p_res_amt > res_amt
               THEN
                  RETURN ('FALSE');
               END IF;
            END IF;

            RETURN ('TRUE');
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               -- RETURN ('TRUE');
               RETURN ('User is not allowed to make a reserve, please refer to the reserve maintenance.');
         END;
      END IF;
   END;

   PROCEDURE update_eval_dep_vat_amt (
      p_eval_id   gicl_mc_evaluation.eval_id%TYPE
   )
   IS
      sum1     NUMBER;
      depamt   gicl_eval_dep_dtl.ded_amt%TYPE;
      summa    NUMBER;
      total    NUMBER;
   BEGIN
      BEGIN
         --deductible amt
         SELECT NVL (SUM (ded_amt), 0)
           INTO sum1
           FROM gicl_eval_deductibles
          WHERE eval_id = p_eval_id;

         --depreciation--
         SELECT NVL (SUM (ded_amt), 0)
           INTO depamt
           FROM gicl_eval_dep_dtl
          WHERE eval_id = p_eval_id;

         UPDATE gicl_mc_evaluation
            SET deductible = sum1,
                depreciation = depamt
          WHERE eval_id = p_eval_id;
      END;

      BEGIN
         SELECT NVL (SUM (a.part_amt), 0)
           INTO summa
           FROM gicl_replace a
          WHERE 1 = 1
            AND a.eval_id = p_eval_id
            AND NOT EXISTS (
                   SELECT 1
                     FROM gicl_eval_vat
                    WHERE eval_id = p_eval_id
                      AND payee_type_cd = a.payee_type_cd
                      AND payee_cd = a.payee_cd
                      AND apply_to = 'P');

         SELECT NVL (SUM (base_amt), 0) + summa
           INTO summa
           FROM gicl_eval_vat
          WHERE eval_id = p_eval_id AND apply_to = 'P';

         -- IF summa > 0 THEN
         UPDATE gicl_mc_evaluation
            SET replace_amt = summa
          WHERE eval_id = p_eval_id;

         --vat amt
         SELECT NVL (SUM (vat_amt), 0)
           INTO summa
           FROM gicl_eval_vat
          WHERE eval_id = p_eval_id;

         UPDATE gicl_mc_evaluation
            SET vat = summa
          WHERE eval_id = p_eval_id;
      END;
   END;

   /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.28.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of GICL_MC_EVALUATION records
    **                  for Evaluation Report in Loss expense history
    */
   FUNCTION get_le_eval_report_list (p_claim_id IN gicl_claims.claim_id%TYPE)
      RETURN le_eval_report_tab PIPELINED
   AS
      eval_rep   le_eval_report_type;
   BEGIN
      FOR i IN (SELECT    subline_cd
                       || '-'
                       || iss_cd
                       || '-'
                       || TRIM (TO_CHAR (eval_yy, '09'))
                       || '-'
                       || TRIM (TO_CHAR (eval_seq_no, '0999999'))
                       || '-'
                       || TRIM (TO_CHAR (eval_version, '09')) eval_no,
                       eval_id, peril_cd,
                       (  NVL (repair_amt, 0)
                        + NVL (replace_amt, 0)
                        + NVL (vat, 0)
                       ) tot_estcos,
                       repair_amt, replace_amt, vat, deductible,
                       depreciation
                  FROM gicl_mc_evaluation a
                 WHERE claim_id = p_claim_id
                   AND eval_stat_cd = 'PD'
                   AND NOT EXISTS (
                          SELECT 1
                            FROM gicl_eval_payment
                           WHERE eval_id = a.eval_id
                             AND clm_loss_id IS NOT NULL
                             AND NVL (cancel_sw, 'N') = 'N'))
      LOOP
         eval_rep.eval_no := i.eval_no;
         eval_rep.eval_id := i.eval_id;
         eval_rep.peril_cd := i.peril_cd;
         eval_rep.tot_estcos := i.tot_estcos;
         eval_rep.repair_amt := i.repair_amt;
         eval_rep.replace_amt := i.replace_amt;
         eval_rep.vat := i.vat;
         eval_rep.deductible := i.deductible;
         eval_rep.depreciation := i.depreciation;
         PIPE ROW (eval_rep);
      END LOOP;
   END get_le_eval_report_list;

   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 03.29.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : Create Settlement for Evaluation Report
   **                  used in Loss Expense History
   */
   PROCEDURE create_settlement_for_eval_rep (
      p_claim_id         IN   gicl_item_peril.claim_id%TYPE,
      p_item_no          IN   gicl_item_peril.item_no%TYPE,
      p_peril_cd         IN   gicl_item_peril.peril_cd%TYPE,
      p_eval_id          IN   gicl_mc_evaluation.eval_id%TYPE,
      p_param_peril_cd   IN   gicl_mc_evaluation.peril_cd%TYPE
   )
   AS
      --for settlement
      clmnt_no          gicl_clm_claimant.clm_clmnt_no%TYPE;
      clmlossid         gicl_clm_loss_exp.clm_loss_id%TYPE;
      histseqno         gicl_clm_loss_exp.hist_seq_no%TYPE;
      statuscd          gicl_le_stat.le_stat_cd%TYPE;
      rplce_loss_exp    giis_loss_exp.loss_exp_cd%TYPE;
      rpair_loss_exp    giis_loss_exp.loss_exp_cd%TYPE;
      deddep_loss_exp   giis_loss_exp.loss_exp_cd%TYPE;
      tax_cd            giis_payee_class.clm_vat_cd%TYPE;
      param             giis_parameters.param_value_v%TYPE;
      baseamt           gicl_eval_vat.base_amt%TYPE;
      taxamt            gicl_eval_vat.vat_amt%TYPE;
      vatrt             gicl_eval_vat.vat_rate%TYPE;
      taxid             giis_loss_taxes.tax_cd%TYPE;
      sltypecd          giis_loss_taxes.sl_type_cd%TYPE;
      net_adv_tag       VARCHAR2 (1);
      v_param           giis_parameters.param_value_v%TYPE;
      ans               NUMBER;
      x                 NUMBER;
      basepartamt       NUMBER;
      baselabramt       NUMBER;
      partruntot        NUMBER                                := 0;
      vatruntot         NUMBER                                := 0;
      dedruntot         NUMBER                                := 0;
      depruntot         NUMBER                                := 0;
      --deductible dtls
      partlabortot      NUMBER                                := 0;
      deppartamt        NUMBER;
      hasvatflag        NUMBER                                := 0;
      --jen.071508--
      v_pdamt           gicl_clm_loss_exp.paid_amt%TYPE       := 0;
      v_netamt          gicl_clm_loss_exp.net_amt%TYPE        := 0;
      v_deddep          gicl_eval_deductibles.ded_amt%TYPE    := 0;
      v_wvat            gicl_replace.with_vat%TYPE            := 'N';
   BEGIN
      BEGIN
         SELECT le_stat_cd
           INTO statuscd
           FROM gicl_le_stat
          WHERE le_stat_cd = giisp.v ('MC_EVAL_ITEM_STAT_CD');      --v_param;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error ('-20001',
                                     'NO STAT CD FOUND IN GICL_LE_STAT'
                                    );
      END;

      --loss expense code for replace--
      rplce_loss_exp := giisp.v ('PART_EVAL_CD');
      --loss_expense_cd for repair--
      rpair_loss_exp := giisp.v ('LABOR_EVAL_CD');

      FOR mc IN (SELECT DISTINCT NVL (payt_payee_cd, payee_cd) payee_cd,
                                 NVL (payt_payee_type_cd,
                                      payee_type_cd
                                     ) payee_type_cd
                            FROM gicl_replace
                           WHERE eval_id = p_eval_id
                 UNION
                 SELECT DISTINCT payee_cd, payee_type_cd
                            FROM gicl_repair_hdr
                           WHERE eval_id = p_eval_id)
      LOOP
         partruntot := 0;
         vatruntot := 0;
         dedruntot := 0;
         depruntot := 0;
         partlabortot := 0;
         v_pdamt := 0;
         v_netamt := 0;
         gen_clmlossid_histseqno (mc.payee_type_cd,
                                  mc.payee_cd,
                                  clmlossid,
                                  histseqno,
                                  p_claim_id,
                                  p_item_no,
                                  p_peril_cd
                                 );

         INSERT INTO gicl_eval_payment
                     (claim_id, eval_id, clm_loss_id
                     )
              VALUES (p_claim_id, p_eval_id, clmlossid
                     );

         BEGIN
            SELECT 1
              INTO x
              FROM gicl_loss_exp_payees
             WHERE 1 = 1
               AND claim_id = p_claim_id
               AND payee_type = 'L'
               AND payee_class_cd = mc.payee_type_cd
               AND payee_cd = mc.payee_cd
               AND item_no = p_item_no
               AND peril_cd = p_param_peril_cd
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               /*generate claimant number*/
               FOR get_max_clmnt_no IN
                  (SELECT NVL (MAX (clm_clmnt_no), 0) clm_clmnt_no
                     FROM gicl_clm_claimant
                    WHERE claim_id = p_claim_id)
               LOOP
                  clmnt_no := get_max_clmnt_no.clm_clmnt_no;
               END LOOP;

               clmnt_no := NVL (clmnt_no, 0) + 1;

               INSERT INTO gicl_loss_exp_payees
                           (claim_id, payee_type, payee_class_cd, payee_cd,
                            item_no, peril_cd, grouped_item_no, clm_clmnt_no
                           )
                    VALUES (p_claim_id, 'L', mc.payee_type_cd, mc.payee_cd,
                            p_item_no, p_param_peril_cd, 0, NVL (clmnt_no, 0)
                           );
         END;

         gen_payee_dtls (mc.payee_type_cd,
                         mc.payee_cd,
                         'P',
                         clmlossid,
                         clmnt_no,
                         tax_cd,
                         baseamt,
                         taxamt,
                         vatrt,
                         taxid,
                         sltypecd,
                         p_eval_id,
                         p_claim_id,
                         p_item_no,
                         p_peril_cd
                        );

         FOR i IN (SELECT   NVL (SUM (part_amt), 0) amt,
                            NVL (with_vat, 'N') wvat, 'P' applyto
                       FROM gicl_replace
                      WHERE eval_id = p_eval_id
                        AND NVL (payt_payee_type_cd, payee_type_cd) =
                                                              mc.payee_type_cd
                        AND NVL (payt_payee_cd, payee_cd) = mc.payee_cd
                   GROUP BY NVL (with_vat, 'N'), 'P'
                   UNION
                   SELECT     NVL (SUM (actual_total_amt), 0)
                            + NVL (SUM (other_labor_amt), 0) amt,
                            NVL (with_vat, 'N') wvat, 'L' applyto
                       FROM gicl_repair_hdr
                      WHERE eval_id = p_eval_id
                        AND payee_type_cd = mc.payee_type_cd
                        AND payee_cd = mc.payee_cd
                   GROUP BY NVL (with_vat, 'N'), 'L')
         LOOP
            BEGIN
               SELECT 1
                 INTO hasvatflag
                 FROM gicl_eval_vat
                WHERE eval_id = p_eval_id
                  AND payee_type_cd = mc.payee_type_cd
                  AND payee_cd = mc.payee_cd
                  AND apply_to = i.applyto
                  AND ROWNUM = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  hasvatflag := 0;
            END;

            IF hasvatflag = 1
            THEN
               IF i.wvat = 'N'
               THEN
                  v_pdamt :=
                       v_pdamt
                     + ROUND (  i.amt
                              + (i.amt * (giacp.n ('INPUT_VAT_RT') / 100)),
                              2
                             );                                  -- add taxamt
                  v_netamt := v_netamt + i.amt;
                                       --if exclusive, i.amt does not have tax
               --select vat amt
               ELSIF i.wvat = 'Y'
               THEN
                  v_pdamt := v_pdamt + i.amt;              --inclusive of tax
                  v_netamt :=
                       v_netamt
                     + ROUND (i.amt / (1 + (giacp.n ('INPUT_VAT_RT') / 100)),
                              2);                                 --net of tax
               END IF;
            ELSIF hasvatflag = 0
            THEN
               v_pdamt := v_pdamt + i.amt;
               v_netamt := v_netamt + i.amt;
            END IF;
         END LOOP;

         FOR x IN (SELECT NVL (ded_amt, 0) deddep
                     FROM gicl_eval_deductibles
                    WHERE eval_id = p_eval_id
                      AND payee_type_cd = mc.payee_type_cd
                      AND payee_cd = mc.payee_cd
                   UNION
                   SELECT NVL (ded_amt, 0) deddep
                     FROM gicl_eval_dep_dtl
                    WHERE eval_id = p_eval_id
                      AND payee_type_cd = mc.payee_type_cd
                      AND payee_cd = mc.payee_cd)
         LOOP
            v_deddep := v_deddep + x.deddep;
         END LOOP;

         v_pdamt := v_pdamt - v_deddep;
         v_netamt := v_netamt - v_deddep;

         INSERT INTO gicl_clm_loss_exp
                     (claim_id, clm_loss_id, hist_seq_no, item_no,
                      peril_cd, item_stat_cd, payee_type, payee_cd,
                      payee_class_cd, ex_gratia_sw, dist_sw, paid_amt,
                      net_amt, advise_amt,
                      remarks,
                      cancel_sw, clm_clmnt_no, grouped_item_no
                     )
              VALUES (p_claim_id, clmlossid, histseqno, p_item_no,
                      p_param_peril_cd, statuscd, 'L', mc.payee_cd,
                      mc.payee_type_cd, 'N', 'N', v_pdamt,
                      v_netamt, v_netamt,
                      'Settlement done after posting MC Evaluation Report',
                      'N', clmnt_no, 0
                     );

         BEGIN
            SELECT 1
              INTO hasvatflag
              FROM gicl_eval_vat
             WHERE eval_id = p_eval_id
               AND payee_type_cd = mc.payee_type_cd
               AND payee_cd = mc.payee_cd
               AND apply_to = 'P'
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               hasvatflag := 0;
         END;

         basepartamt := 0;

         FOR j IN (SELECT NVL (with_vat, 'N') w_vat, part_amt
                     FROM gicl_replace
                    WHERE eval_id = p_eval_id
                      AND NVL (payt_payee_type_cd, payee_type_cd) =
                                                              mc.payee_type_cd
                      AND NVL (payt_payee_cd, payee_cd) = mc.payee_cd)
         LOOP
            basepartamt := NVL (basepartamt, 0) + j.part_amt;
            v_wvat := j.w_vat;
         END LOOP;

         IF basepartamt <> 0
         THEN
            INSERT INTO gicl_loss_exp_dtl
                        (claim_id, clm_loss_id, line_cd, loss_exp_cd,
                         dtl_amt, ded_base_amt, loss_exp_type,
                         loss_exp_class, no_of_units, w_tax
                        )
                 VALUES (p_claim_id, clmlossid, 'MC', rplce_loss_exp,
                         basepartamt, basepartamt, 'L',
                         'P', 1, v_wvat
                        );

            partruntot := partruntot + NVL (basepartamt, 0);
            --fields of loss tax dtls:
            net_adv_tag := 'N';

            IF tax_cd IS NOT NULL AND taxid IS NOT NULL AND taxamt IS NOT NULL
            THEN
               INSERT INTO gicl_loss_exp_tax
                           (claim_id, clm_loss_id, tax_cd, tax_type,
                            loss_exp_cd, base_amt, tax_amt, tax_pct,
                            adv_tag, net_tag, w_tax, tax_id,
                            sl_type_cd, sl_cd
                           )
                    VALUES (p_claim_id, clmlossid, tax_cd, 'I',
                            rplce_loss_exp, baseamt, taxamt, vatrt,
                            net_adv_tag, net_adv_tag, v_wvat, taxid,
                            sltypecd, mc.payee_cd
                           );

               vatruntot := vatruntot + NVL (taxamt, 0);
            END IF;
         END IF;

         BEGIN
            SELECT 1
              INTO hasvatflag
              FROM gicl_eval_vat
             WHERE eval_id = eval_id
               AND payee_type_cd = mc.payee_type_cd
               AND payee_cd = mc.payee_cd
               AND apply_to = 'L'
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               hasvatflag := 0;
         END;

         gen_payee_dtls (mc.payee_type_cd,
                         mc.payee_cd,
                         'L',
                         clmlossid,
                         clmnt_no,
                         tax_cd,
                         baseamt,
                         taxamt,
                         vatrt,
                         taxid,
                         sltypecd,
                         p_eval_id,
                         p_claim_id,
                         p_item_no,
                         p_peril_cd
                        );
         baselabramt := 0;

         FOR n IN (SELECT NVL (with_vat, 'N') w_vat,
                            NVL (actual_total_amt, 0)
                          + NVL (other_labor_amt, 0) part_amt
                     FROM gicl_repair_hdr
                    WHERE eval_id = p_eval_id
                      AND payee_type_cd = mc.payee_type_cd
                      AND payee_cd = mc.payee_cd)
         LOOP
            baselabramt := n.part_amt;

            INSERT INTO gicl_loss_exp_dtl
                        (claim_id, clm_loss_id, line_cd, loss_exp_cd,
                         dtl_amt, ded_base_amt, loss_exp_type,
                         loss_exp_class, no_of_units, w_tax
                        )
                 VALUES (p_claim_id, clmlossid, 'MC', rpair_loss_exp,
                         baselabramt, baselabramt, 'L',
                         'L', 1, n.w_vat
                        );

            net_adv_tag := n.w_vat;

            --for net_tag and adv_tag, if w_tax = 'Y', then both of them is equal to 'Y'
            IF tax_cd IS NOT NULL AND taxid IS NOT NULL AND taxamt IS NOT NULL
            THEN
               INSERT INTO gicl_loss_exp_tax
                           (claim_id, clm_loss_id, tax_cd, tax_type,
                            loss_exp_cd, base_amt, tax_amt, tax_pct,
                            adv_tag, net_tag, w_tax, tax_id,
                            sl_type_cd, sl_cd
                           )
                    VALUES (p_claim_id, clmlossid, tax_cd, 'I',
                            rpair_loss_exp, baseamt, taxamt, vatrt,
                            net_adv_tag, net_adv_tag, n.w_vat, taxid,
                            sltypecd, mc.payee_cd
                           );

               IF NVL (n.w_vat, 'N') = 'N'
               THEN
                  vatruntot := NVL (vatruntot, 0) + NVL (taxamt, 0);
               END IF;
            END IF;
         END LOOP;                                             --vat ng repair

         partlabortot := NVL (partruntot, 0) + NVL (baselabramt, 0);

         /*Deductibles*/
         FOR ded IN (SELECT ded_cd, subline_cd, no_of_unit, ded_base_amt,
                            DECODE (SIGN (ded_amt),
                                    -1, ded_amt,
                                    -ded_amt
                                   ) ded_amt,
                            ded_rt, ded_text
                       FROM gicl_eval_deductibles
                      WHERE eval_id = p_eval_id
                        AND payee_type_cd = mc.payee_type_cd
                        AND payee_cd = mc.payee_cd
                        AND ded_cd <> giisp.v ('MC_DEPRECIATION_CD'))
         LOOP
            BEGIN
               SELECT loss_exp_cd                                   --,dtl_amt
                 INTO deddep_loss_exp
                 FROM gicl_loss_exp_dtl a                  --, giis_loss_exp b
                WHERE 1 = 1
                  AND a.subline_cd IS NULL
                  AND a.claim_id = p_claim_id
                  AND a.clm_loss_id = clmlossid;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error
                              (-20002,
                               'posting report: no_data_found in deductibles'
                              );
               WHEN TOO_MANY_ROWS
               THEN
                  deddep_loss_exp := '%ALL%';
            END;

            INSERT INTO gicl_loss_exp_dtl
                        (claim_id, clm_loss_id, line_cd, loss_exp_cd,
                         dtl_amt, ded_base_amt, ded_loss_exp_cd,
                         deductible_text, no_of_units, subline_cd,
                         loss_exp_type, ded_rate
                        )
                 VALUES (p_claim_id, clmlossid, 'MC', ded.ded_cd,
                         ded.ded_amt, ded.ded_base_amt, deddep_loss_exp,
                         ded.ded_text, ded.no_of_unit, ded.subline_cd,
                         'L', ded.ded_rt
                        );

            dedruntot := NVL (ded.ded_amt, 0);

            FOR z IN (SELECT   partruntot partlabor_amt,
                               rplce_loss_exp loss_exp_cd
                          FROM gicl_replace a
                         WHERE 1 = 1
                           AND a.eval_id = p_eval_id
                           AND NVL (a.payt_payee_type_cd, a.payee_type_cd) =
                                                              mc.payee_type_cd
                           AND NVL (a.payt_payee_cd, a.payee_cd) = mc.payee_cd
                      GROUP BY NVL (a.payt_payee_type_cd, a.payee_type_cd),
                               NVL (a.payt_payee_cd, a.payee_cd)
                      UNION ALL
                      SELECT   NVL (other_labor_amt, 0)
                             + NVL (actual_total_amt, 0),
                             rpair_loss_exp
                        FROM gicl_repair_hdr a
                       WHERE 1 = 1
                         AND a.eval_id = p_eval_id
                         AND a.payee_type_cd = mc.payee_type_cd
                         AND a.payee_cd = mc.payee_cd)
            LOOP
               INSERT INTO gicl_loss_exp_ded_dtl
                           (claim_id, clm_loss_id, line_cd, loss_exp_type,
                            loss_exp_cd, loss_amt, ded_cd,
                            ded_amt,
                            ded_rate
                           )
                    VALUES (p_claim_id, clmlossid, 'MC', 'L',
                            ded.ded_cd, z.partlabor_amt, z.loss_exp_cd,
                            (ded.ded_amt / partlabortot
                            ) * z.partlabor_amt,
                            (ABS (ded.ded_amt) / partlabortot
                            ) * 100
                           );
            END LOOP;

            EXIT;
         END LOOP;                                               --deductibles

         FOR dep IN (SELECT   MAX (a.payee_cd) payee_cd,
                              MAX (a.payee_type_cd) payee_type_cd,
                              SUM (b.part_amt) part_amt,
                              SUM (DECODE (SIGN (a.ded_amt),
                                           -1, a.ded_amt,
                                           -a.ded_amt
                                          )
                                  ) ded_amt
                         FROM gicl_eval_dep_dtl a, gicl_replace b
                        WHERE a.eval_id = p_eval_id
                          AND b.eval_id = p_eval_id
                          AND a.loss_exp_cd = b.loss_exp_cd
                          AND a.payee_type_cd = mc.payee_type_cd
                          AND a.payee_cd = mc.payee_cd
                     GROUP BY a.eval_id)
         LOOP
            INSERT INTO gicl_loss_exp_dtl
                        (loss_exp_cd, dtl_amt,
                         ded_rate,
                         ded_loss_exp_cd, no_of_units, ded_base_amt,
                         claim_id, clm_loss_id, line_cd, loss_exp_type
                        )
                 VALUES (giisp.v ('MC_DEPRECIATION_CD'), dep.ded_amt,
                         (ABS (dep.ded_amt) / dep.part_amt
                         ) * 100,
                         rplce_loss_exp, 1, dep.part_amt,
                         p_claim_id, clmlossid, 'MC', 'L'
                        );

            depruntot := depruntot + NVL (dep.ded_amt, 0);

            INSERT INTO gicl_loss_exp_ded_dtl
                        (claim_id, clm_loss_id, line_cd, loss_exp_type,
                         loss_exp_cd, loss_amt,
                         ded_cd, ded_amt,
                         ded_rate
                        )
                 VALUES (p_claim_id, clmlossid, 'MC', 'L',
                         giisp.v ('MC_DEPRECIATION_CD'), dep.part_amt,
                         rplce_loss_exp, NVL (dep.ded_amt, 0),
                         ABS (  (NVL (dep.ded_amt, 0) / NVL (dep.part_amt, 0)
                                )
                              * 100
                             )
                        );

            EXIT;
         END LOOP;                                              --depreciation
      END LOOP;                                                           --MC
   END;

   PROCEDURE pop_giclmceval (
      p_claim_id             IN OUT   gicl_item_peril.claim_id%TYPE,
      p_subline_cd           IN OUT   gicl_claims.subline_cd%TYPE,
      p_iss_cd               IN OUT   gicl_claims.iss_cd%TYPE,
      p_clm_yy               IN OUT   gicl_claims.clm_yy%TYPE,
      p_clm_seq_no           IN OUT   gicl_claims.clm_seq_no%TYPE,
      p_user_id              IN       gicl_claims.user_id%TYPE,
      p_loss_date            OUT      VARCHAR2,
      p_assured_name         OUT      VARCHAR2,
      p_pol_iss_cd           OUT      gicl_claims.iss_cd%TYPE,
      p_pol_issue_yy         OUT      gicl_claims.clm_yy%TYPE,
      p_pol_seq_no           OUT      gicl_claims.clm_seq_no%TYPE,
      p_pol_renew_no         OUT      gicl_claims.renew_no%TYPE,
      p_item_no              OUT      gicl_item_peril.item_no%TYPE,
      p_plate_no             OUT      gicl_mc_evaluation.plate_no%TYPE,
      p_tp_sw                OUT      gicl_mc_evaluation.tp_sw%TYPE,
      p_dsp_payee            OUT      VARCHAR2,
      p_dsp_curr_shortname   OUT      giis_currency.short_name%TYPE,
      p_currency_cd          OUT      gicl_motor_car_dtl.currency_cd%TYPE,
      p_currency_rate        OUT      gicl_motor_car_dtl.currency_rate%TYPE,
      p_peril_cd             OUT      gicl_mc_evaluation.peril_cd%TYPE,
      p_dsp_peril_desc       OUT      giis_peril.peril_name%TYPE,
      p_dsp_item_desc        OUT      gicl_motor_car_dtl.item_title%TYPE,
      p_adjuster_id          OUT      gicl_mc_evaluation.adjuster_id%TYPE,
      p_dsp_adjuster_desc    OUT      giis_adjuster.payee_name%TYPE,
      p_ann_tsi_amt          OUT      gipi_polbasic.ann_tsi_amt%TYPE,
      allow_plate_no         OUT      VARCHAR2,
      allow_peril_cd         OUT      VARCHAR2,
      allow_adjuster         OUT      VARCHAR2,
      eval_exist             OUT      VARCHAR2,
      MESSAGE                OUT      VARCHAR2
   )
   IS
      FOUND   NUMBER;
   BEGIN
      IF p_claim_id IS NULL
      THEN
         BEGIN
            SELECT 1
              INTO FOUND
              FROM gicl_claims
             WHERE line_cd = 'MC'
               AND subline_cd = p_subline_cd
               AND iss_cd = p_iss_cd
               AND clm_yy = p_clm_yy
               AND clm_seq_no = p_clm_seq_no;

            BEGIN
               SELECT loss_date, assured_name, claim_id, pol_iss_cd,
                      pol_seq_no, renew_no, issue_yy
                 INTO p_loss_date, p_assured_name, p_claim_id, p_pol_iss_cd,
                      p_pol_seq_no, p_pol_renew_no, p_pol_issue_yy
                 FROM gicl_claims
                WHERE line_cd = 'MC'
                  AND subline_cd = p_subline_cd
                  AND iss_cd = p_iss_cd
                  AND clm_yy = p_clm_yy
                  AND clm_seq_no = p_clm_seq_no
                  AND in_hou_adj = p_user_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  MESSAGE :=
                     'User is not allowed to create or modify report for this claim';
            END;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               MESSAGE := 'claim does not exists!';
         END;
      ELSIF p_claim_id IS NOT NULL
      THEN
         BEGIN
                --commtented because these variables are extracted from global objects
               /*SELECT subline_cd, iss_cd,
                      clm_yy, clm_seq_no,
                      loss_date, assured_name,
                      claim_id, pol_iss_cd,
                      pol_seq_no, renew_no,
                      issue_yy
                 --INTO lossDate, assuredName, claimId, polIssCd, polSeqNo, renewNo, issueYY
               INTO   p_subline_cd, p_clm_iss_cd,
                      p_clm_yy, p_clm_seq_no,
                      :master_blk.loss_date, :master_blk.assured_name,
                      :master_blk.claim_id, :master_blk.pol_iss_cd,
                      :master_blk.pol_seq_no, :master_blk.pol_renew_no,
                      :master_blk.pol_issue_yy
                 FROM gicl_claims
                WHERE claim_id = :parameter.claimid;

               -- :gicl_claims.claim_id              := claimId;
               -- :gicl_mc_evaluation.claim_id:=claimId;
               claimid := :parameter.claimid;
               :master_blk.pol_line_cd := 'MC';
               :master_blk.clm_line_cd := 'MC';
               :master_blk.pol_subline_cd := :master_blk.clm_subline_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                 raise_application_error ('20001','User is not allowed to create or modify report for this claim');
            END;*/
            NULL;
         END;
      END IF;

      BEGIN
         SELECT item_no, plate_no, tp_sw, payee_name, currency_cd,
                currency_rate, short_name
           INTO p_item_no, p_plate_no, p_tp_sw, p_dsp_payee, p_currency_cd,
                p_currency_rate, p_dsp_curr_shortname
           FROM (                                              /*THIRD PARTY*/
                 SELECT b.item_no, b.plate_no, 'Y' tp_sw,
                           g.payee_last_name
                        || DECODE (g.payee_first_name,
                                   NULL, NULL,
                                   ',' || g.payee_first_name
                                  )
                        || DECODE (g.payee_middle_name,
                                   NULL, NULL,
                                   '' || g.payee_middle_name || '.'
                                  ) payee_name,
                        a.currency_cd, a.currency_rate, h.short_name
                   FROM gicl_motor_car_dtl a,
                        gicl_mc_tp_dtl b,
                        giis_mc_car_company c,
                        giis_mc_make d,
                        giis_mc_eng_series e,
                        gicl_item_peril f,
                        giis_payees g,
                        giis_currency h
                  WHERE 1 = 1
                    AND a.claim_id = p_claim_id
                    AND a.claim_id = b.claim_id
                    AND a.item_no = b.item_no
                    AND a.claim_id = f.claim_id
                    AND a.item_no = f.item_no
                    AND a.currency_cd = h.main_currency_cd
                    AND b.motorcar_comp_cd = c.car_company_cd(+)
                    AND b.motorcar_comp_cd = d.car_company_cd(+)
                    AND b.make_cd = d.make_cd(+)
                    AND b.motorcar_comp_cd = e.car_company_cd(+)
                    AND b.make_cd = e.make_cd(+)
                    AND b.series_cd = e.series_cd(+)
                    AND b.payee_class_cd = g.payee_class_cd
                    AND b.payee_no = g.payee_no
                    AND b.tp_type = 'T'
                    AND 'Y' =
                             (SELECT NVL (eval_sw, 'N')
                                FROM giis_peril
                               WHERE line_cd = 'MC' AND peril_cd = f.peril_cd)
                 UNION
                 /*insured*/
                 SELECT a.item_no, a.plate_no, 'N', NULL, a.currency_cd,
                        a.currency_rate, g.short_name
                   FROM gicl_motor_car_dtl a,
                        gicl_item_peril f,
                        giis_mc_car_company c,
                        giis_mc_make d,
                        giis_mc_eng_series e,
                        giis_currency g
                  WHERE 1 = 1
                    AND a.claim_id = p_claim_id
                    AND a.item_no = f.item_no
                    AND a.claim_id = f.claim_id
                    AND a.motcar_comp_cd = c.car_company_cd(+)
                    AND a.motcar_comp_cd = d.car_company_cd(+)
                    AND a.make_cd = d.make_cd(+)
                    AND a.motcar_comp_cd = e.car_company_cd(+)
                    AND a.make_cd = e.make_cd(+)
                    AND a.series_cd = e.series_cd(+)
                    AND a.currency_cd = g.main_currency_cd
                    AND 'Y' =
                             (SELECT NVL (eval_sw, 'N')
                                FROM giis_peril
                               WHERE line_cd = 'MC' AND peril_cd = f.peril_cd));

         allow_plate_no := 'N';

         BEGIN
            SELECT a.peril_cd, b.peril_name
              --INTO :gicl_claims.nbt_peril_cd, :gicl_claims.nbt_peril_desc
            INTO   p_peril_cd, p_dsp_peril_desc
              FROM gicl_item_peril a, giis_peril b
             WHERE 1 = 1
               AND a.line_cd = b.line_cd
               AND a.peril_cd = b.peril_cd
               AND a.claim_id = p_claim_id
               --NVL(:parameter.claim_id,:gicl_claims.claim_id)
               AND a.item_no = p_item_no            --:gicl_claims.nbt_item_no
               AND b.eval_sw = 'Y';

            allow_peril_cd := 'N';
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               allow_peril_cd := 'Y';
            --set_item_property('master_blk.peril_cd',navigable,property_true);
            WHEN NO_DATA_FOUND
            THEN
               MESSAGE :=
                  'No item with valid peril found for this claim,Creation of report is not applicable.';
         END;

         BEGIN
            SELECT item_title
              --INTO :gicl_claims.nbt_ITEM_DESC
            INTO   p_dsp_item_desc
              FROM gicl_motor_car_dtl
             WHERE claim_id = p_claim_id
                                        -- NVL(:parameter.claim_id,:gicl_claims.claim_id)
                   AND item_no = p_item_no;        --:gicl_claims.nbt_item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_dsp_item_desc := '';
         END;
      EXCEPTION
         WHEN TOO_MANY_ROWS
         THEN
            allow_plate_no := 'Y';
         --set_item_property('master_blk.plate_no',navigable,property_true);
         WHEN NO_DATA_FOUND
         THEN
            MESSAGE :=
               'No item with valid peril found for this claim, creation of report is not applicable.';
      END;

      BEGIN
         SELECT DISTINCT DECODE (a.payee_name,
                                 NULL, c.payee_last_name,
                                 a.payee_name
                                ) payee_name,
                         b.clm_adj_id
                    INTO p_dsp_adjuster_desc,
                         p_adjuster_id
                    FROM giis_adjuster a, gicl_clm_adjuster b, giis_payees c
                   WHERE 1 = 1
                     AND b.adj_company_cd = a.adj_company_cd(+)
                     AND NVL (b.priv_adj_cd, 0) = a.priv_adj_cd(+)
                     AND b.claim_id = p_claim_id
                     AND c.payee_class_cd = giisp.v ('ADJUSTER_CD')
                     AND c.payee_no = b.adj_company_cd
                     AND NVL (cancel_tag, 'N') <> 'Y'
                     AND NVL (delete_tag, 'N') <> 'Y';

         /*Modified by: Jen.05162011
         **get adjuster from giis_payee if private adjuster not available.
         **exclude cancelled/deleted adjusters.

             SELECT a.payee_name, b.clm_adj_id
               INTO :gicl_mc_evaluation.nbt_adjuster_desc, :gicl_mc_evaluation.adjuster_id
                 FROM giis_adjuster a, gicl_clm_adjuster b
                WHERE 1 = 1
                 AND a.adj_company_cd = b.adj_company_cd
                 AND a.priv_adj_cd    = b.priv_adj_cd
                 AND b.claim_id = claimId;*/
         allow_adjuster := 'N';
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            allow_adjuster := 'Y';
      END;

      BEGIN
         SELECT ann_tsi_amt
           INTO p_ann_tsi_amt
           FROM gicl_item_peril
          WHERE 1 = 1
            AND claim_id = p_claim_id
            AND peril_cd = p_peril_cd
            AND item_no = p_item_no
            AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            p_ann_tsi_amt := NULL;
      END;

      BEGIN
         SELECT 'Y'
           INTO eval_exist
           FROM gicl_mc_evaluation
          WHERE claim_id = p_claim_id
            AND item_no = p_item_no
            AND peril_cd = p_peril_cd
            AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            eval_exist := 'N';
      END;
   END;

   FUNCTION get_eval_peril_lov (
      p_claim_id    gicl_item_peril.claim_id%TYPE,
      p_item_no     gicl_item_peril.item_no%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN mc_eval_peril_tab PIPELINED
   IS
      v_peril   mc_eval_peril_type;
   BEGIN
      FOR i IN (SELECT a.peril_cd, b.peril_name
                  FROM gicl_item_peril a, giis_peril b
                 WHERE 1 = 1
                   AND a.line_cd = b.line_cd
                   AND a.peril_cd = b.peril_cd
                   AND a.claim_id = p_claim_id
                   AND a.item_no = p_item_no
                   AND b.eval_sw = 'Y'
                   AND UPPER (peril_name) LIKE NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_peril.peril_cd := i.peril_cd;
         v_peril.dsp_peril_desc := i.peril_name;
         PIPE ROW (v_peril);
      END LOOP;
   END;

   FUNCTION get_mc_eval_item_lov (
      p_claim_id    gicl_claims.claim_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN item_no_lov_tab PIPELINED
   IS
      v_item   item_no_lov_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT b.item_no, b.plate_no, a.item_title,
                               c.car_company, d.make, e.engine_series,
                                  g.payee_last_name
                               || DECODE (g.payee_first_name,
                                          NULL, NULL,
                                          ',' || g.payee_first_name
                                         )
                               || DECODE (g.payee_middle_name,
                                          NULL, NULL,
                                          '' || g.payee_middle_name || '.'
                                         ) payee_name,
                               'Y' tp_sw, b.payee_class_cd, b.payee_no,
                               a.currency_cd, a.currency_rate, h.short_name
                          FROM gicl_motor_car_dtl a,
                               gicl_mc_tp_dtl b,
                               giis_mc_car_company c,
                               giis_mc_make d,
                               giis_mc_eng_series e,
                               gicl_item_peril f,
                               giis_payees g,
                               giis_currency h
                         WHERE 1 = 1
                           AND a.claim_id = p_claim_id
                           AND a.claim_id = b.claim_id
                           AND a.item_no = b.item_no
                           AND a.claim_id = f.claim_id
                           AND a.item_no = f.item_no
                           AND a.currency_cd = h.main_currency_cd
                           AND b.motorcar_comp_cd = c.car_company_cd(+)
                           AND b.motorcar_comp_cd = d.car_company_cd(+)
                           AND b.make_cd = d.make_cd(+)
                           AND b.motorcar_comp_cd = e.car_company_cd(+)
                           AND b.make_cd = e.make_cd(+)
                           AND b.series_cd = e.series_cd(+)
                           AND g.payee_class_cd = b.payee_class_cd
                           AND g.payee_no = b.payee_no
                           AND b.tp_type = 'T'
                           AND 'Y' =
                                  (SELECT NVL (eval_sw, 'N')
                                     FROM giis_peril
                                    WHERE line_cd = 'MC'
                                      AND peril_cd = f.peril_cd)
                        UNION
                        SELECT a.item_no, a.plate_no, a.item_title,
                               c.car_company, d.make, e.engine_series, NULL,
                               'N', NULL, NULL, a.currency_cd,
                               a.currency_rate, g.short_name
                          FROM gicl_motor_car_dtl a,
                               gicl_item_peril f,
                               giis_mc_car_company c,
                               giis_mc_make d,
                               giis_mc_eng_series e,
                               giis_currency g
                         WHERE 1 = 1
                           AND a.claim_id = p_claim_id
                           AND a.item_no = f.item_no
                           AND a.claim_id = f.claim_id
                           AND a.currency_cd = g.main_currency_cd
                           AND a.motcar_comp_cd = c.car_company_cd(+)
                           AND a.motcar_comp_cd = d.car_company_cd(+)
                           AND a.make_cd = d.make_cd(+)
                           AND a.motcar_comp_cd = e.car_company_cd(+)
                           AND a.make_cd = e.make_cd(+)
                           AND a.series_cd = e.series_cd(+)
                           AND 'Y' =
                                  (SELECT NVL (eval_sw, 'N')
                                     FROM giis_peril
                                    WHERE line_cd = 'MC'
                                      AND peril_cd = f.peril_cd))
                 WHERE UPPER (item_title) LIKE NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_item.item_no := i.item_no;
         v_item.plate_no := i.plate_no;
         v_item.item_title := i.item_title;
         v_item.car_company := i.car_company;
         v_item.make := i.make;
         v_item.engine_series := i.engine_series;
         v_item.payee_name := i.payee_name;
         v_item.tp_sw := i.tp_sw;
         v_item.payee_class_cd := i.payee_class_cd;
         v_item.payee_no := i.payee_no;
         v_item.currency_cd := i.currency_cd;
         v_item.short_name := i.short_name;

         -- get the peril name for the item selected
         BEGIN
            SELECT a.peril_cd, b.peril_name
              --INTO :gicl_claims.nbt_peril_cd, :gicl_claims.nbt_peril_desc
            INTO   v_item.peril_cd, v_item.dsp_peril_desc
              FROM gicl_item_peril a, giis_peril b
             WHERE 1 = 1
               AND a.line_cd = b.line_cd
               AND a.peril_cd = b.peril_cd
               AND a.claim_id = p_claim_id
               AND a.item_no = i.item_no
               AND b.eval_sw = 'Y';

            v_item.allow_peril := 'N';
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               v_item.allow_peril := 'Y';
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         PIPE ROW (v_item);
      END LOOP;
   END;

   PROCEDURE master_blk_key_commit (
      p_claim_id         gicl_item_peril.claim_id%TYPE,
      p_item_no          gicl_item_peril.item_no%TYPE,
      p_plate_no         gicl_mc_tp_dtl.plate_no%TYPE,
      p_tp_sw            gicl_mc_evaluation.tp_sw%TYPE,
      p_peril_cd         gicl_mc_evaluation.peril_cd%TYPE,
      p_payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      p_payee_no         gicl_mc_evaluation.payee_no%TYPE,
      v_item_no          gicl_item_peril.item_no%TYPE,
      v_plate_no         gicl_mc_tp_dtl.plate_no%TYPE,
      v_tp_sw            gicl_mc_evaluation.tp_sw%TYPE,
      v_peril_cd         gicl_mc_evaluation.peril_cd%TYPE,
      v_payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      v_payee_no         gicl_mc_evaluation.payee_no%TYPE,
      p_eval_id          gicl_mc_evaluation.eval_id%TYPE
   )
   IS
   BEGIN
      UPDATE gicl_mc_evaluation
         SET plate_no = v_plate_no,
             item_no = v_item_no,
             tp_sw = v_tp_sw,
             payee_class_cd = v_payee_class_cd,
             payee_no = v_payee_no,
             peril_cd = v_peril_cd
       WHERE claim_id = p_claim_id
         AND item_no = p_item_no
         AND NVL (plate_no, '*') = NVL (p_plate_no, '*')
         AND NVL (peril_cd, -1) = NVL (p_peril_cd, -1)
         AND NVL (tp_sw, 'N') = NVL (p_tp_sw, 'N')
         AND NVL (payee_class_cd, '*') = NVL (p_payee_class_cd, '*')
         AND NVL (payee_no, -1) = NVL (p_payee_no, -1)
         AND eval_id = p_eval_id; --added eval_id by robert 7.23.2013
   END;

   FUNCTION get_plate_no_lov (
      p_claim_id    gicl_item_peril.claim_id%TYPE,
      p_item_no     gicl_item_peril.item_no%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN plate_no_lov_tab PIPELINED
   IS
      v_plate   plate_no_lov_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT plate_no,
                                  b.payee_last_name
                               || DECODE (b.payee_first_name,
                                          NULL, NULL,
                                          ',' || b.payee_first_name
                                         )
                               || DECODE (b.payee_middle_name,
                                          NULL, NULL,
                                          ' ' || b.payee_middle_name || '.'
                                         ) payee_name,
                               'Y' tp_sw, a.payee_class_cd, a.payee_no
                          FROM gicl_mc_tp_dtl a, giis_payees b
                         WHERE 1 = 1
                           AND a.payee_class_cd = b.payee_class_cd
                           AND a.payee_no = b.payee_no
                           AND a.claim_id = p_claim_id
                           AND a.item_no = p_item_no
                           AND tp_type = 'T'
                        UNION
                        SELECT a.plate_no, '', 'N' tp_sw, '', NULL
                          FROM gicl_claims a, gicl_motor_car_dtl b
                         WHERE 1 = 1
                           AND a.claim_id = b.claim_id
                           AND a.claim_id = p_claim_id
                           AND b.item_no = p_item_no)
                 WHERE nvl(UPPER (plate_no),'%%') LIKE NVL (UPPER (p_find_text), '%%')
                 )
      LOOP
         v_plate.plate_no := i.plate_no;
         v_plate.payee_name := i.payee_name;
         v_plate.tp_sw := i.tp_sw;
         v_plate.payee_class_cd := i.payee_class_cd;
         v_plate.payee_no := i.payee_no;
         PIPE ROW (v_plate);
      END LOOP;
   END;
   
   procedure get_item_peril(p_claim_id gicl_claims.claim_id%type, p_item_no gicl_item_peril.item_no%type, v_peril_cd out gicl_item_peril.peril_cd%type, v_peril_name out giis_peril.peril_name%type, v_multiple_peril out varchar2 )
   
   is
   	
   begin
   	SELECT a.peril_cd, b.peril_name
				   --INTO :gicl_claims.nbt_peril_cd, :gicl_claims.nbt_peril_desc
				   INTO v_peril_cd, v_peril_name
					 FROM gicl_item_peril a, giis_peril b
			    WHERE 1 = 1
			 			AND a.line_cd = b.line_cd
			 		  AND a.peril_cd = b.peril_cd
			 			AND a.claim_id = p_claim_id--NVL(:parameter.claim_id,:gicl_claims.claim_id)
			 			AND a.item_no = p_item_no--:gicl_claims.nbt_item_no
			 			AND b.eval_sw = 'Y';
			EXCEPTION
			 	 WHEN too_many_rows THEN 
				 	v_peril_cd := '';
					v_peril_name :='';
			 	  v_multiple_peril := 'Y';
		 	   
			 	 WHEN no_data_found THEN
			 	  raise_application_error('-20001','No item with valid peril found for this claim, creation of report is not applicable');
	end;
    
    FUNCTION check_mc_evaluation_exist (
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_clm_yy       gicl_claims.clm_yy%TYPE,
      p_clm_seq_no   gicl_claims.clm_seq_no%TYPE,
      p_user_id      VARCHAR2
   )
      RETURN mc_evaluation_info_tab PIPELINED
   IS
      v_mc   mc_evaluation_info_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT DISTINCT gc.claim_id, gc.line_cd,
                                        gc.subline_cd, gc.iss_cd, gc.clm_yy,
                                        gc.clm_seq_no, gc.clm_file_date,
                                        gc.pol_iss_cd, gc.issue_yy,
                                        gc.pol_seq_no, gc.renew_no,
                                        gc.assured_name, gc.loss_date,
                                        gc.assd_no, gme.item_no, gme.plate_no,
                                        gme.peril_cd, gme.payee_no,
                                        gme.payee_class_cd, gme.tp_sw,
                                        gc.in_hou_adj
                                   FROM gicl_claims gc,
                                        gicl_mc_evaluation gme
                                  WHERE gc.claim_id = gme.claim_id
                                    AND gc.clm_stat_cd NOT IN ('CD', 'CC', 'DN', 'WD')
                                    AND check_user_per_iss_cd2 (gc.line_cd, NULL, 'GICLS070', p_user_id) =1)
                 WHERE in_hou_adj = p_user_id
                   AND claim_id IN (SELECT DISTINCT claim_id
                                               FROM gicl_mc_evaluation)
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND clm_yy = p_clm_yy
                   AND clm_seq_no = p_clm_seq_no)
      LOOP
         v_mc.claim_id := i.claim_id;
         v_mc.line_cd := i.line_cd;
         v_mc.subline_cd := i.subline_cd;
         v_mc.iss_cd := i.iss_cd;
         v_mc.clm_yy := i.clm_yy;
         v_mc.clm_seq_no := i.clm_seq_no;
         v_mc.clm_file_date := i.clm_file_date;
         v_mc.renew_no := i.renew_no;
         v_mc.assd_no := i.assd_no;
         v_mc.assured_name := i.assured_name;
         v_mc.loss_date := TO_CHAR (i.loss_date, 'MM-DD-YYYY');
         v_mc.item_no := i.item_no;
         v_mc.plate_no := i.plate_no;
         v_mc.payee_no := i.payee_no;
         v_mc.payee_no := i.payee_no;
         v_mc.payee_class_cd := i.payee_class_cd;
         v_mc.tp_sw := i.tp_sw;
         v_mc.in_hou_adj := i.in_hou_adj;
         v_mc.claim_id := i.claim_id;
         v_mc.peril_cd := i.peril_cd;
         v_mc.pol_iss_cd := i.pol_iss_cd;
         v_mc.pol_seq_no := i.pol_seq_no;
         v_mc.issue_yy := i.issue_yy;

         BEGIN
            SELECT item_title
              INTO v_mc.dsp_item_desc
              FROM gicl_motor_car_dtl
             WHERE claim_id = i.claim_id AND item_no = i.item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_mc.dsp_item_desc := '';
         END;

         BEGIN
            SELECT peril_name
              INTO v_mc.dsp_peril_desc
              FROM giis_peril
             WHERE line_cd = 'MC' AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_mc.dsp_peril_desc := '';
         END;

         BEGIN
            SELECT a.currency_cd, a.currency_rate,
                   b.short_name
              INTO v_mc.currency_cd, v_mc.currency_rate,
                   v_mc.dsp_curr_shortname
              FROM gicl_motor_car_dtl a, giis_currency b
             WHERE a.currency_cd = b.main_currency_cd
               AND a.claim_id = v_mc.claim_id;
         EXCEPTION
            WHEN TOO_MANY_ROWS OR NO_DATA_FOUND
            THEN
               v_mc.currency_cd := NULL;
               v_mc.currency_rate := NULL;
               v_mc.dsp_curr_shortname := NULL;
         END;

         BEGIN
            SELECT ann_tsi_amt
              INTO v_mc.ann_tsi_amt
              FROM gicl_item_peril
             WHERE 1 = 1
               AND claim_id = i.claim_id
               AND peril_cd = i.peril_cd
               AND item_no = i.item_no
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_mc.ann_tsi_amt := NULL;
         END;

         PIPE ROW (v_mc);
         EXIT;
      END LOOP;
   END;
    
END gicl_mc_evaluation_pkg;

--DROP PUBLIC SYNONYM GICL_MC_EVALUATION_PKG; comment out by MAC 12/05/2013.
/


