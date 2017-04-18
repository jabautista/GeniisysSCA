CREATE OR REPLACE PACKAGE BODY CPI.gicl_eval_vat_pkg
AS
   PROCEDURE update_old_eval_vat (
      p_payee_type_cd       gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd            gicl_eval_vat.payee_cd%TYPE,
      p_var_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_var_payee_cd        gicl_eval_vat.payee_cd%TYPE,
      p_eval_id             gicl_eval_vat.eval_id%TYPE
   )
   IS
   BEGIN
      UPDATE gicl_eval_vat
         SET payee_type_cd = p_payee_type_cd,
             payee_cd = p_payee_cd
       WHERE eval_id = p_eval_id
         AND apply_to = 'P'
         AND payee_type_cd = p_var_payee_type_cd
         AND payee_cd = p_var_payee_cd;
   END;

   PROCEDURE delete_eval_vat (
      p_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_vat.payee_cd%TYPE,
      p_eval_id         gicl_eval_vat.eval_id%TYPE
   )
   IS
   BEGIN
      DELETE      gicl_eval_vat
            WHERE eval_id = p_eval_id
              AND payee_type_cd = p_payee_type_cd
              AND payee_cd = p_payee_cd
              AND apply_to = 'P';
   END;

   FUNCTION get_mc_eval_vat_listing (p_eval_id gicl_eval_vat.eval_id%TYPE)
      RETURN eval_vat_tab PIPELINED
   IS
      v_vat   eval_vat_type;
      param   giis_parameters.param_value_v%TYPE;
      temp    VARCHAR2 (30);
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_eval_vat
                 WHERE eval_id = p_eval_id)
      LOOP
         v_vat.eval_id := i.eval_id;
         v_vat.payee_type_cd := i.payee_type_cd;
         v_vat.payee_cd := i.payee_cd;
         v_vat.apply_to := i.apply_to;
         v_vat.vat_amt := i.vat_amt;
         v_vat.vat_rate := i.vat_rate;
         v_vat.base_amt := i.base_amt;
         v_vat.with_vat := i.with_vat;
         v_vat.user_id := i.user_id;
         v_vat.last_update := i.last_update;
         v_vat.payt_payee_type_cd := i.payt_payee_type_cd;
         v_vat.payt_payee_cd := i.payt_payee_cd;
         v_vat.net_tag := i.net_tag;
         v_vat.less_ded := NVL (i.less_ded, 'N');
         v_vat.less_dep := NVL (i.less_dep, 'N');

         BEGIN
            SELECT    c.payee_last_name
                   || DECODE (c.payee_first_name,
                              NULL, NULL,
                              ',' || c.payee_first_name
                             )
                   || DECODE (c.payee_middle_name,
                              NULL, NULL,
                              ' ' || c.payee_middle_name || '.'
                             ) payee_name
              INTO v_vat.dsp_company
              FROM giis_payees c
             WHERE c.payee_class_cd = i.payee_type_cd
               AND c.payee_no = i.payee_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_vat.dsp_company := '';
            WHEN TOO_MANY_ROWS
            THEN
               v_vat.dsp_company := '';
         END;

         IF i.apply_to = 'L'
         THEN
            temp := 'LABOR_EVAL_CD';
         ELSE
            temp := 'PART_EVAL_CD';
         END IF;

         BEGIN
            SELECT param_value_v
              INTO param
              FROM giis_parameters
             WHERE param_name = temp;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error
                             ('-20001',
                              'parameter is not set in giis_parameters table'
                             );
         END;

         FOR i IN (SELECT loss_exp_desc
                     FROM giis_loss_exp
                    WHERE line_cd = 'MC'
                      AND loss_exp_cd = param
                      AND loss_exp_type = 'L'
                      AND comp_sw = '+')
         LOOP
            v_vat.dsp_part_labor := i.loss_exp_desc;
         END LOOP;

         PIPE ROW (v_vat);
      END LOOP;
   END;

   FUNCTION get_vat_com_lov (
      p_eval_id     gicl_eval_vat.eval_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN vat_com_lov_tab PIPELINED
   IS
      v_com   vat_com_lov_type;
   BEGIN
      FOR i IN
         (SELECT *
            FROM (SELECT NVL (a.payt_payee_cd, a.payee_cd) payee_cd,
                         NVL (a.payt_payee_type_cd,
                              a.payee_type_cd
                             ) payee_type_cd,
                            c.payee_last_name
                         || DECODE (c.payee_first_name,
                                    NULL, NULL,
                                    ',' || c.payee_first_name
                                   )
                         || DECODE (c.payee_middle_name,
                                    NULL, NULL,
                                    ' ' || c.payee_middle_name || '.'
                                   ) payee_name
                    FROM gicl_replace a, giis_payees c
                   WHERE 1 = 1
                     AND NVL (a.payt_payee_cd, a.payee_cd) = c.payee_no
                     AND NVL (a.payt_payee_type_cd, a.payee_type_cd) =
                                                              c.payee_class_cd
                     AND a.eval_id = p_eval_id
                     AND NOT EXISTS (
                            SELECT 1
                              FROM gicl_eval_vat
                             WHERE eval_id = p_eval_id
                               AND payee_type_cd =
                                      NVL (a.payt_payee_type_cd,
                                           a.payee_type_cd
                                          )
                               AND payee_cd =
                                             NVL (a.payt_payee_cd, a.payee_cd)
                               AND apply_to = 'P')
                  UNION
                  SELECT a.payee_cd, a.payee_type_cd,
                            c.payee_last_name
                         || DECODE (c.payee_first_name,
                                    NULL, NULL,
                                    ',' || c.payee_first_name
                                   )
                         || DECODE (c.payee_middle_name,
                                    NULL, NULL,
                                    ' ' || c.payee_middle_name || '.'
                                   ) payee_name
                    FROM gicl_repair_hdr a, giis_payees c
                   WHERE 1 = 1
                     AND a.payee_cd = c.payee_no
                     AND a.payee_type_cd = c.payee_class_cd
                     AND a.eval_id = p_eval_id
                     AND NOT EXISTS (
                            SELECT 1
                              FROM gicl_eval_vat
                             WHERE eval_id = p_eval_id
                               AND payee_type_cd = a.payee_type_cd
                               AND payee_cd = a.payee_cd
                               AND apply_to = 'L'))
           WHERE UPPER (payee_name) LIKE NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_com.payee_type_cd := i.payee_type_cd;
         v_com.payee_cd := i.payee_cd;
         v_com.dsp_company := i.payee_name;
         PIPE ROW (v_com);
      END LOOP;
   END;

   FUNCTION get_vat_part_labor_lov (
      p_eval_id         gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_vat.payee_cd%TYPE,
      p_find_text       VARCHAR2
   )
      RETURN vat_labor_part_tab PIPELINED
   IS
      v_labor   vat_labor_part_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT   b.loss_exp_desc, 'P' apply_to,
                                 NVL (with_vat, 'N') w_vat,
                                 SUM (part_amt) base_amt
                            FROM gicl_replace a, giis_loss_exp b
                           WHERE 1 = 1
                             AND a.eval_id = p_eval_id
                             AND a.payee_type_cd = p_payee_type_cd
                             AND a.payee_cd = p_payee_cd
                             AND NOT EXISTS (
                                    SELECT 1
                                      FROM gicl_eval_vat
                                     WHERE eval_id = p_eval_id
                                       AND payee_type_cd = p_payee_type_cd
                                       AND payee_cd = p_payee_cd
                                       AND apply_to = 'P')
                             AND b.loss_exp_cd = giisp.v ('PART_EVAL_CD')
                        GROUP BY b.loss_exp_desc, 'P', with_vat
                        UNION
                        SELECT b.loss_exp_desc, 'L' apply_to,
                               NVL (a.with_vat, 'N'),
                                 NVL (a.actual_total_amt, 0)
                               + NVL (a.other_labor_amt, 0)
                          FROM gicl_repair_hdr a, giis_loss_exp b
                         WHERE a.eval_id = p_eval_id
                           AND a.payee_type_cd = p_payee_type_cd
                           AND a.payee_cd = p_payee_cd
                           AND NOT EXISTS (
                                  SELECT 1
                                    FROM gicl_eval_vat
                                   WHERE eval_id = p_eval_id
                                     AND payee_type_cd = p_payee_type_cd
                                     AND payee_cd = p_payee_cd
                                     AND apply_to = 'L')
                           AND b.loss_exp_cd = giisp.v ('LABOR_EVAL_CD'))
                 WHERE UPPER (loss_exp_desc) LIKE
                                               NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_labor.dsp_part_labor := i.loss_exp_desc;
         v_labor.apply_to := i.apply_to;
         v_labor.with_vat := i.w_vat;
         v_labor.base_amt := i.base_amt;
         PIPE ROW (v_labor);
      END LOOP;
   END;

   PROCEDURE validate_eval_vat_com (
      p_eval_id               gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd         gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd              gicl_eval_vat.payee_cd%TYPE,
      dsp_part_labor    OUT   giis_loss_exp.loss_exp_desc%TYPE,
      base_amt          OUT   gicl_eval_vat.base_amt%TYPE,
      vat_rate          OUT   gicl_eval_vat.vat_rate%TYPE,
      vat_amt           OUT   gicl_eval_vat.vat_amt%TYPE,
      apply_to          OUT   gicl_eval_vat.apply_to%TYPE,
      allow_labor_lov   OUT   VARCHAR2
   )
   IS
      v_scope       VARCHAR2 (1);
      vatamt        gicl_eval_vat.vat_amt%TYPE;
      bseamt        gicl_eval_vat.base_amt%TYPE;
      vatrt         gicl_eval_vat.vat_rate%TYPE;
      v_base_amt    gicl_eval_vat.base_amt%TYPE;
      v_vat_amt     gicl_eval_vat.vat_amt%TYPE;
      lossexpdesc   giis_loss_exp.loss_exp_desc%TYPE;
      v_baseamt     gicl_eval_vat.base_amt%TYPE;
      v_deds        gicl_eval_deductibles.ded_amt%TYPE;
      v_deps        gicl_eval_dep_dtl.ded_amt%TYPE;
   BEGIN
      BEGIN
         SELECT *
           INTO v_scope
           FROM (SELECT 'P' v_scope
                   FROM gicl_replace a
                  WHERE 1 = 1
                    AND a.eval_id = p_eval_id
                    AND NVL (a.payt_payee_type_cd, a.payee_type_cd) =
                                                               p_payee_type_cd
                    AND NVL (a.payt_payee_cd, a.payee_cd) = p_payee_cd
                    AND NOT EXISTS (
                           SELECT 1
                             FROM gicl_eval_vat
                            WHERE 1 = 1
                              AND NVL (payt_payee_type_cd, payee_type_cd) =
                                                               p_payee_type_cd
                              AND NVL (payt_payee_cd, payee_cd) = p_payee_cd
                              AND apply_to = 'P'
                              AND eval_id = p_eval_id)
                    AND ROWNUM = 1
                 UNION ALL
                 SELECT 'L'
                   FROM gicl_repair_hdr a
                  WHERE a.eval_id = p_eval_id
                    AND a.payee_type_cd = p_payee_type_cd
                    AND a.payee_cd = p_payee_cd
                    AND NOT EXISTS (
                           SELECT 1
                             FROM gicl_eval_vat
                            WHERE payee_cd = p_payee_cd
                              AND payee_type_cd = p_payee_type_cd
                              AND apply_to = 'L'
                              AND eval_id = p_eval_id));

         vatrt := giacp.n ('INPUT_VAT_RT');

         IF v_scope = 'P'
         THEN                                                        --REPLACE
            FOR part IN (SELECT with_vat, part_amt
                           FROM gicl_replace
                          WHERE eval_id = p_eval_id
                            AND NVL (payt_payee_type_cd, payee_type_cd) =
                                                               p_payee_type_cd
                            AND NVL (payt_payee_cd, payee_cd) = p_payee_cd)
            LOOP
               IF NVL (part.with_vat, 'N') = 'Y'
               THEN
                  vatamt :=
                     ROUND (  part.part_amt
                            - (part.part_amt / (1 + (vatrt / 100))),
                            2
                           );
                  bseamt := part.part_amt - vatamt;
               ELSE
                  vatamt := ROUND (part.part_amt * (vatrt / 100), 2);
                  bseamt := part.part_amt;
               END IF;

               v_base_amt := NVL (v_base_amt, 0) + bseamt;
               v_vat_amt := NVL (v_vat_amt, 0) + vatamt;
            END LOOP;

            BEGIN
               SELECT loss_exp_desc
                 INTO lossexpdesc
                 FROM giis_loss_exp
                WHERE line_cd = 'MC'
                  AND loss_exp_cd = giisp.v ('PART_EVAL_CD')
                  AND loss_exp_type = 'L'
                  AND comp_sw = '+';
            END;

            dsp_part_labor := lossexpdesc;
            base_amt := v_base_amt;
            vat_rate := vatrt;
            vat_amt := v_vat_amt;
         ELSIF v_scope = 'L'
         THEN                                                       --REPAIR--
            FOR labor IN (SELECT with_vat,
                                   NVL (actual_total_amt, 0)
                                 + NVL (other_labor_amt, 0) labor_amt
                            FROM gicl_repair_hdr
                           WHERE eval_id = p_eval_id
                             AND payee_type_cd = p_payee_type_cd
                             AND payee_cd = p_payee_cd)
            LOOP
               IF NVL (labor.with_vat, 'N') = 'Y'
               THEN
                  vatamt :=
                     ROUND (  labor.labor_amt
                            - (labor.labor_amt / (1 + (vatrt / 100))),
                            2
                           );
                  bseamt := labor.labor_amt - vatamt;
               --msg_alert(bseAmt||' 1','I',false);--jen**
               ELSE
                  vatamt := ROUND (labor.labor_amt * (vatrt / 100), 2);
                  bseamt := labor.labor_amt;
               --msg_alert(bseAmt||' 2','I',false);--jen**
               END IF;
            END LOOP;

            BEGIN
               SELECT loss_exp_desc
                 INTO lossexpdesc
                 FROM giis_loss_exp
                WHERE line_cd = 'MC'
                  AND loss_exp_cd = giisp.v ('LABOR_EVAL_CD')
                  AND loss_exp_type = 'L'
                  AND comp_sw = '+';
            END;

            dsp_part_labor := lossexpdesc;
            base_amt := bseamt;
            vat_rate := vatrt;
            vat_amt := vatamt;
         END IF;

         apply_to := v_scope;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;                                                        --==
         WHEN TOO_MANY_ROWS
         THEN
            allow_labor_lov := 'Y';
      END;
   END;

   PROCEDURE validate_eval_part_labor (
      p_eval_id               gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd         gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd              gicl_eval_vat.payee_cd%TYPE,
      p_apply_to              gicl_eval_vat.apply_to%TYPE,
      base_amt          OUT   gicl_eval_vat.base_amt%TYPE,
      vat_rate          OUT   gicl_eval_vat.vat_rate%TYPE,
      vat_amt           OUT   gicl_eval_vat.vat_amt%TYPE
   )
   IS
      v_vat_amt    gicl_eval_vat.vat_amt%TYPE;
      v_base_amt   gicl_eval_vat.base_amt%TYPE;
      v_vatamt     gicl_eval_vat.vat_amt%TYPE;
      v_bseamt     gicl_eval_vat.base_amt%TYPE;
   BEGIN
      vat_rate := giacp.n ('INPUT_VAT_RT');

      IF p_apply_to = 'P'
      THEN
         FOR part IN (SELECT with_vat, part_amt
                        FROM gicl_replace
                       WHERE eval_id = p_eval_id
                         AND NVL (payt_payee_type_cd, payee_type_cd) =
                                                               p_payee_type_cd
                         AND NVL (payt_payee_cd, payee_cd) = p_payee_cd)
         LOOP
            IF part.with_vat = 'Y'
            THEN
               v_vatamt :=
                  ROUND (  part.part_amt
                         - (part.part_amt / (1 + vat_rate / 100)),
                         2
                        );
               v_bseamt := part.part_amt - v_vatamt;
            ELSE
               v_vatamt := ROUND (part.part_amt * (vat_rate / 100), 2);
--               v_bseamt := part.part_amt - v_vatamt; --comment out 12.17.2013 ruben
               v_bseamt := part.part_amt;
            END IF;

            vat_amt := NVL (vat_amt, 0) + v_vatamt;
            base_amt := NVL (base_amt, 0) + v_bseamt;
         END LOOP;
      ELSIF p_apply_to = 'L'
      THEN
         FOR labor IN (SELECT with_vat,
                                NVL (actual_total_amt, 0)
                              + NVL (other_labor_amt, 0) repair
                         FROM gicl_repair_hdr
                        WHERE eval_id = p_eval_id)
         LOOP
            IF labor.with_vat = 'Y'
            THEN
               vat_amt :=
                  ROUND (labor.repair - (labor.repair / (1 + vat_rate / 100)),
                         2
                        );
               base_amt := labor.repair - vat_amt;
            ELSE
               vat_amt := ROUND (labor.repair * (vat_rate / 100), 2);
               --:gicl_eval_vat.base_amt := labor.repair  - :gicl_eval_vat.vat_amt;
               base_amt := labor.repair;
            END IF;

            EXIT;
         END LOOP;
      END IF;
   END;

   PROCEDURE validate_less_deductible (
      p_eval_id               gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd         gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd              gicl_eval_vat.payee_cd%TYPE,
      p_less_ded              gicl_eval_vat.less_ded%TYPE,
      p_apply_to              gicl_eval_vat.apply_to%TYPE,
      base_amt          OUT   gicl_eval_vat.base_amt%TYPE,
      vat_amt           OUT   gicl_eval_vat.vat_amt%TYPE,
      MESSAGE           OUT   VARCHAR2
   )
   IS
      v_ded_amt       NUMBER;           --gicl_eval_deductibles.ded_amt%type;
      v_vatrt         gicl_eval_vat.vat_rate%TYPE;
      v_with_vat      gicl_replace.with_vat%TYPE;
      v_total_amt     NUMBER;
      v_pdeductible   gicl_eval_deductibles.ded_amt%TYPE;
   BEGIN
      SELECT SUM (ded_amt)
        INTO v_pdeductible
        FROM gicl_eval_deductibles
       WHERE eval_id = p_eval_id
         AND payee_cd = p_payee_cd
         AND payee_type_cd = p_payee_type_cd;

      v_vatrt := giacp.n ('INPUT_VAT_RT');

      FOR i IN (SELECT   with_vat, SUM (total_part_amt) total
                    FROM gicl_replace
                   WHERE eval_id = p_eval_id
                     AND payee_cd = p_payee_cd
                     AND payee_type_cd = p_payee_type_cd
                GROUP BY with_vat)
      LOOP
         v_with_vat := i.with_vat;
         v_total_amt := i.total;
      END LOOP;

      IF v_pdeductible IS NOT NULL
      THEN
         IF p_less_ded = 'Y'
         THEN
            IF p_apply_to = 'P'
            THEN
               IF v_with_vat = 'Y'
               THEN
                  base_amt :=
                     ROUND (  (v_total_amt - v_pdeductible)
                            / (1 + v_vatrt / 100),
                            2
                           );
                  vat_amt :=
                     ROUND (  (v_total_amt - v_pdeductible)
                            - (  (v_total_amt - v_pdeductible)
                               / (1 + v_vatrt / 100)
                              ),
                            2
                           );
               ELSE
                  vat_amt := (v_total_amt - v_pdeductible) * (v_vatrt / 100);
--                  base_amt :=
--                             (v_total_amt - v_pdeductible) - NVL (vat_amt, 0); 12.17.2013 ruben
                  base_amt :=
                             (v_total_amt - v_pdeductible);
               END IF;
            ELSE
               MESSAGE := '1';
            -- msg_alert ('Deductible may only be applied to parts', 'I', FALSE);
            -- less_ded := 'N';
            END IF;
         ELSIF p_less_ded = 'N'
         THEN
            IF v_with_vat = 'Y'
            THEN
               base_amt := ROUND ((v_total_amt) / (1 + v_vatrt / 100), 2);
               vat_amt :=
                  ROUND (  (v_total_amt)
                         - ((v_total_amt) / (1 + v_vatrt / 100)),
                         2
                        );
            ELSE
               vat_amt := (v_total_amt) * (v_vatrt / 100);
--               base_amt := NVL (v_total_amt, 0) - NVL (vat_amt, 0); 12.17.2013 ruben
               base_amt := NVL (v_total_amt, 0);
            END IF;
         END IF;
      ELSIF v_pdeductible IS NULL
      THEN
         MESSAGE := '2';
--        null less ded
     /* msg_alert (   'No deductibles exist for this evaluation,'
                 || CHR (10)
                 || 'checking of this option is not applicable',
                 'E',
                 TRUE
                );*/
      END IF;
   END;

   PROCEDURE validate_less_depreciation (
      p_eval_id               gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd         gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd              gicl_eval_vat.payee_cd%TYPE,
      p_less_dep              gicl_eval_vat.less_ded%TYPE,
      p_apply_to              gicl_eval_vat.apply_to%TYPE,
      base_amt          OUT   gicl_eval_vat.base_amt%TYPE,
      vat_amt           OUT   gicl_eval_vat.vat_amt%TYPE,
      MESSAGE           OUT   VARCHAR2
   )
   IS
      v_dep_exist   NUMBER                        := 0;
      v_ded_amt     NUMBER                        := 0;
      v_tot_amt     NUMBER                        := 0;
      v_with_vat    VARCHAR2 (1);
      v_vatrt       gicl_eval_vat.vat_rate%TYPE;
   BEGIN
      BEGIN
         SELECT actual_total_amt, with_vat
           INTO v_tot_amt, v_with_vat
           FROM gicl_repair_hdr
          WHERE eval_id = p_eval_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            MESSAGE := '1';
        --:gicl_eval_vat.less_dep := 'N';
      --  msg_alert('depreciation may only be applied to labor','I',TRUE);
      END;

      FOR i IN (SELECT SUM (ded_amt) amt
                  FROM gicl_eval_dep_dtl
                 WHERE eval_id = p_eval_id)
      --    AND payee_cd = :gicl_eval_vat.payee_cd
      --   AND payee_type_cd = :gicl_eval_vat.payee_type_cd)
      LOOP
         v_ded_amt := i.amt;
      END LOOP;

      v_vatrt := giacp.n ('INPUT_VAT_RT');

      IF p_less_dep = 'Y'
      THEN
         IF p_apply_to = 'L'
         THEN
            IF v_with_vat = 'Y'
            THEN
               base_amt :=
                     ROUND ((v_tot_amt - v_ded_amt) / (1 + v_vatrt / 100), 2);
               vat_amt :=
                  ROUND (  (v_tot_amt - v_ded_amt)
                         - ((v_tot_amt - v_ded_amt) / (1 + v_vatrt / 100)),
                         2
                        );
            ELSE
               vat_amt := (v_tot_amt - v_ded_amt) * (v_vatrt / 100);
--               base_amt := (v_tot_amt - v_ded_amt) - NVL (vat_amt, 0); 12.17.2013 ruben
               base_amt := (v_tot_amt - v_ded_amt);
            END IF;
         ELSE
            MESSAGE := '1';
         --msg_alert('depreciation may only be applied to labor','I',false);
         --:gicl_eval_vat.less_dep := 'N';
         END IF;
      ELSIF p_less_dep = 'N'
      THEN
         IF v_with_vat = 'Y'
         THEN
            base_amt := ROUND ((v_tot_amt) / (1 + v_vatrt / 100), 2);
            vat_amt :=
                 ROUND ((v_tot_amt) - ((v_tot_amt) / (1 + v_vatrt / 100)), 2);
         ELSE
            vat_amt := (v_tot_amt) * (v_vatrt / 100);
--            base_amt := NVL (v_tot_amt, 0) - NVL (vat_amt, 0); 12.17.2013 ruben
            base_amt := NVL (v_tot_amt, 0);
         END IF;
      END IF;
   --IF GET_ITEM_PROPERTY('GICL_EVAL_VAT.CREATE_BTN', ENABLED) ='FALSE' THEN
   -- SET_ITEM_PROPERTY('GICL_EVAL_VAT.CREATE_BTN', ENABLED, PROPERTY_TRUE);
   --END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         --  :GICL_EVAL_VAT.LESS_DEP := NULL;
         MESSAGE := '2';
   /* msg_alert('No depriciation amounts exist for this evaluation,'||chr(10)||
                          'checking of this option is not applicable','E',TRUE);*/
   END;

   FUNCTION check_enable_create_vat (p_eval_id gicl_eval_vat.eval_id%TYPE)
      RETURN VARCHAR2
   IS
      res   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO res
           FROM (SELECT 1
                   FROM gicl_replace a
                  WHERE eval_id = p_eval_id
                    AND NOT EXISTS (
                           SELECT 1
                             FROM gicl_eval_vat
                            WHERE eval_id = p_eval_id
                              AND NVL (payt_payee_type_cd, payee_type_cd) =
                                     NVL (a.payt_payee_type_cd,
                                          a.payee_type_cd
                                         )
                              AND NVL (payt_payee_cd, payee_cd) =
                                             NVL (a.payt_payee_cd, a.payee_cd)
                              AND apply_to = 'P')
                 UNION
                 SELECT 1
                   FROM gicl_repair_hdr a
                  WHERE eval_id = p_eval_id
                    AND NOT EXISTS (
                           SELECT 1
                             FROM gicl_eval_vat
                            WHERE eval_id = p_eval_id
                              AND payee_type_cd = a.payee_type_cd
                              AND payee_cd = a.payee_cd
                              AND apply_to = 'L'));
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            res := 'N';
      END;

      RETURN res;
   END;

   PROCEDURE set_gicl_eval_vat (
      p_eval_id              gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd        gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd             gicl_eval_vat.payee_cd%TYPE,
      p_apply_to             gicl_eval_vat.apply_to%TYPE,
      p_vat_amt              gicl_eval_vat.vat_amt%TYPE,
      p_vat_rate             gicl_eval_vat.vat_rate%TYPE,
      p_base_amt             gicl_eval_vat.base_amt%TYPE,
      p_with_vat             gicl_eval_vat.with_vat%TYPE,
      p_payt_payee_type_cd   gicl_eval_vat.payt_payee_type_cd%TYPE,
      p_payt_payee_cd        gicl_eval_vat.payt_payee_cd%TYPE,
      p_net_tag              gicl_eval_vat.net_tag%TYPE,
      p_less_ded             gicl_eval_vat.less_ded%TYPE,
      p_less_dep             gicl_eval_vat.less_dep%TYPE
   )
   IS
   BEGIN
      MERGE INTO gicl_eval_vat
         USING DUAL
         ON (    eval_id = p_eval_id
             AND payee_cd = p_payee_cd
             AND payee_type_cd = p_payee_type_cd
             AND apply_to = p_apply_to)    -- nante 11.20.2013   add condition not to update VAT under claims with more than 1 perils
         WHEN NOT MATCHED THEN
            INSERT (eval_id, payee_type_cd, payee_cd, apply_to, vat_amt,
                    vat_rate, base_amt, with_vat, payt_payee_type_cd,
                    payt_payee_cd, net_tag, less_ded, less_dep)
            VALUES (p_eval_id, p_payee_type_cd, p_payee_cd, p_apply_to,
                    p_vat_amt, p_vat_rate, p_base_amt, p_with_vat,
                    p_payt_payee_type_cd, p_payt_payee_cd, p_net_tag,
                    p_less_ded, p_less_dep)
         WHEN MATCHED THEN
            UPDATE
               SET --apply_to = p_apply_to,    -- nante 11.20.2013 
                   vat_amt = p_vat_amt,
                   vat_rate = p_vat_rate, base_amt = p_base_amt,
                   with_vat = p_with_vat,
                   payt_payee_type_cd = p_payt_payee_type_cd,
                   payt_payee_cd = p_payt_payee_cd, net_tag = p_net_tag,
                   less_ded = p_less_ded, less_dep = p_less_dep
            ;
   END;

   PROCEDURE del_gicl_eval_vat (
      p_eval_id         gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_vat.payee_cd%TYPE,
      p_apply_to        gicl_eval_vat.apply_to%type
   )
   IS
   BEGIN
      DELETE FROM gicl_eval_vat
            WHERE eval_id = p_eval_id
              AND payee_cd = p_payee_cd
              AND payee_type_cd = p_payee_type_cd
              and apply_to = p_apply_to; -- ruben 12.17.2013
   END;

   PROCEDURE create_vat_details (
      p_eval_id            gicl_eval_vat.eval_id%TYPE,
      v_totalvat     OUT   gicl_mc_evaluation.vat%TYPE,
      v_totallabor   OUT   gicl_mc_evaluation.repair_amt%TYPE,
      v_totalpart    OUT   gicl_mc_evaluation.replace_amt%TYPE,
      v_changed1     OUT   VARCHAR2
   )
   IS
      v_vatrt        gicl_eval_vat.vat_rate%TYPE;
      --gicl_mc_evaluation

      --amt to save in gicl_mc_evaluation
      gev_base_amt   gicl_eval_vat.base_amt%TYPE   := 0;
      ---base amount to be saved in giclevalvat
      gev_vat_amt    gicl_eval_vat.vat_amt%TYPE    := 0;
      --vat amount to be saved in gicl eval_vat
      v_baseamt      gicl_eval_vat.base_amt%TYPE;
      vatamt         gicl_eval_vat.vat_amt%TYPE;
      --base_amt gicl_eval_vat.base_amt%TYPE;
      --vat_amt gicl_eval_vat.vat_amt%TYPE;
      v_changed2     BOOLEAN                       := FALSE;
      v_nettag       VARCHAR2 (1)                  := 'N';
   BEGIN
      --vat rate
      v_vatrt := giacp.n ('INPUT_VAT_RT');

      DELETE      gicl_eval_vat
            WHERE eval_id = p_eval_id;

      FOR lahat IN
         (SELECT payee_type_cd, payee_cd
            FROM (SELECT DISTINCT NVL (payt_payee_type_cd,
                                       payee_type_cd
                                      ) payee_type_cd,
                                  NVL (payt_payee_cd, payee_cd) payee_cd
                             FROM gicl_replace
                            WHERE eval_id = p_eval_id
                  UNION
                  SELECT payee_type_cd, payee_cd
                    FROM gicl_repair_hdr
                   WHERE eval_id = p_eval_id))
      LOOP
         --msg_alert('she eyes me like a picses','I',FALSE);--==
         --msg_alert(lahat.payee_type_cd||'--'||lahat.payee_cd,'I',false);
         v_changed1 := 'Y';
         v_changed2 := FALSE;
         gev_base_amt := 0;
         gev_vat_amt := 0;

         --PART--
         FOR part IN (SELECT NVL (with_vat, 'N') with_vat,
                             NVL (payt_payee_type_cd,
                                  payee_type_cd
                                 ) payee_type_cd,
                             NVL (payt_payee_cd, payee_cd) payee_cd,
                             part_amt base_amt
                        FROM gicl_replace a
                       WHERE eval_id = p_eval_id
                         AND NVL (payt_payee_type_cd, payee_type_cd) =
                                                           lahat.payee_type_cd
                         AND NVL (payt_payee_cd, payee_cd) = lahat.payee_cd)
         --GROUP BY NVL(with_vat,'N'),nvl(payt_payee_type_cd,payee_type_cd), nvl(payt_payee_cd,payee_cd))
         LOOP
            v_changed2 := TRUE;

              --msg_alert('when i am weak','I',FALSE);--++
            --v_BasicAmt := part.base_amt;
            IF part.with_vat = 'Y'
            THEN
               vatamt :=
                  ROUND (part.base_amt
                         - (part.base_amt / (1 + v_vatrt / 100)),
                         2
                        );
               v_baseamt := NVL (part.base_amt, 0) - NVL (vatamt, 0);
            --for totals:
            --vat_amt := ROUND(part.base_amt - (part.base_amt/(1 + v_vatRt/100)), 2);
            --base_amt := NVL(part.base_amt,0) - NVL(vat_Amt,0);
            ELSE
               vatamt := ROUND (part.base_amt * (v_vatrt / 100), 2);
               v_baseamt := part.base_amt;
            --        v_baseAmt := NVL(part.base_amt,0) - NVL(vatAmt,0);
            --for totals:
            --base_amt := part.base_amt;
            --vat_amt := ROUND(part.base_amt * (v_vatRt/100), 2);
            END IF;

            --FOR replace Totals: (gicl_mc_evaluation)
            v_totalpart := NVL (v_totalpart, 0) + NVL (v_baseamt, 0);
            v_totalvat := NVL (v_totalvat, 0) + NVL (vatamt, 0);
            --FOR gicl_eval_vat amt:
            gev_base_amt := NVL (gev_base_amt, 0) + NVL (v_baseamt, 0);
            gev_vat_amt := NVL (gev_vat_amt, 0) + NVL (vatamt, 0);
         END LOOP;

         IF v_changed2
         THEN
            INSERT INTO gicl_eval_vat
                        (eval_id, payee_type_cd, payee_cd,
                         apply_to, vat_amt, vat_rate, base_amt, net_tag
                        )
                 VALUES (p_eval_id, lahat.payee_type_cd, lahat.payee_cd,
                         'P', gev_vat_amt, v_vatrt,             /*v_BasicAmt*/
                                                   gev_base_amt, v_nettag
                        );
         END IF;

         v_changed2 := FALSE;

         --end of part--

         --msg_alert('start ng labor','I',FALSE);--++
         --LABOR--
         FOR labor IN (SELECT NVL (with_vat, 'N') with_vat,
                                NVL (actual_total_amt, 0)
                              + NVL (other_labor_amt, 0) base_amt
                         FROM gicl_repair_hdr a
                        WHERE eval_id = p_eval_id
                          AND payee_type_cd = lahat.payee_type_cd
                          AND payee_cd = lahat.payee_cd)
         LOOP
            v_changed2 := TRUE;
            v_changed1 := 'Y';

            IF labor.with_vat = 'Y'
            THEN
               vatamt :=
                  ROUND (  labor.base_amt
                         - (labor.base_amt / (1 + v_vatrt / 100)),
                         2
                        );
               v_baseamt := NVL (labor.base_amt, 0) - NVL (vatamt, 0);
            ELSE
               vatamt := ROUND (labor.base_amt * (v_vatrt / 100), 2);
               v_baseamt := NVL (labor.base_amt, 0);     --  - NVL(vatAmt,0);
            END IF;

            v_totallabor := NVL (v_totallabor, 0) + v_baseamt;
            v_totalvat := NVL (v_totalvat, 0) + vatamt;
         END LOOP;

         IF v_changed2
         THEN
            INSERT INTO gicl_eval_vat
                        (eval_id, payee_type_cd, payee_cd,
                         apply_to, vat_amt, vat_rate, base_amt, net_tag
                        )
                 VALUES (p_eval_id, lahat.payee_type_cd, lahat.payee_cd,
                         'L', vatamt, v_vatrt, /*v_BasicAmt*/ v_baseamt, v_nettag
                        );
         END IF;
      END LOOP;
   END;

   PROCEDURE create_vat_details2 (
      p_eval_id         gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_vat.payee_cd%TYPE,
      p_apply_to        gicl_eval_vat.apply_to%TYPE,
      p_less_ded        gicl_eval_vat.less_ded%TYPE,
      p_less_dep        gicl_eval_vat.less_dep%TYPE
   )
   IS

   BEGIN

      FOR eval_ctr IN (SELECT eval_id, payee_type_cd, payee_cd, apply_to
                         FROM gicl_eval_vat
                        WHERE eval_id = p_eval_id
                          AND payee_type_cd = p_payee_type_cd
                          AND payee_cd = p_payee_cd
                          AND apply_to = p_apply_to)
      LOOP
         UPDATE gicl_eval_vat
            SET less_ded = p_less_ded,
                less_dep = p_less_dep
          WHERE eval_id = eval_ctr.eval_id
            AND payee_type_cd = eval_ctr.payee_type_cd
            AND payee_cd = eval_ctr.payee_cd
            AND apply_to = eval_ctr.apply_to;
      END LOOP;
   END;

   PROCEDURE create_vat_details3 (
      p_eval_id      gicl_eval_vat.eval_id%TYPE,
      v_totalvat     gicl_mc_evaluation.vat%TYPE,
      v_totallabor   gicl_mc_evaluation.repair_amt%TYPE,
      v_totalpart    gicl_mc_evaluation.replace_amt%TYPE,
      v_changed1     VARCHAR2
   )
   IS
      v_vatrt   gicl_eval_vat.vat_rate%TYPE;
   BEGIN
      v_vatrt := giacp.n ('INPUT_VAT_RT');

      DECLARE
         v_pdeductible     gicl_eval_deductibles.ded_amt%TYPE;
         v_pdepreciation   gicl_eval_dep_dtl.ded_amt%TYPE;
         v_depwvat         NUMBER (1);
      BEGIN
         FOR pd IN (SELECT SUM (NVL (ded_amt, 0)) deductible
                      FROM gicl_eval_deductibles
                     WHERE eval_id = p_eval_id)
         LOOP
            v_pdeductible := pd.deductible;
         END LOOP;

         FOR pp IN (SELECT SUM (NVL (ded_amt, 0)) depreciations
                      FROM gicl_eval_dep_dtl
                     WHERE eval_id = p_eval_id)
         LOOP
            v_pdepreciation := pp.depreciations;
         END LOOP;

         -- PAU 07DEC07 START(1)
           -- CHECK IF VAT INCLUSIVE, USED IN APPLYING DEP AND DED TO REPAIRS
         FOR pau IN (SELECT 1 a
                       FROM gicl_repair_hdr a
                      WHERE eval_id = p_eval_id
                        AND (payee_type_cd, payee_cd) IN (
                                                SELECT payee_type_cd,
                                                       payee_cd
                                                  FROM gicl_repair_hdr
                                                 WHERE eval_id = p_eval_id))
         LOOP
            v_depwvat := pau.a;
         END LOOP;

         -- PAU 07DEC07 END(1)
         UPDATE gicl_eval_vat
            SET vat_amt = (base_amt - v_pdeductible) * (v_vatrt / 100),
                  --SET VAT_AMT = (SELECT DECODE(NVL(V_DEPWVAT, 0), 0, ROUND((BASE_AMT - V_PDEDUCTIBLE) * (V_VATRT/100), 2),
                  --                                               1, ROUND((BASE_AMT - V_PDEDUCTIBLE) - ((BASE_AMT - V_PDEDUCTIBLE) / (1 + V_VATRT/100)), 2))
                --                                    FROM DUAL),
                base_amt = base_amt - v_pdeductible
          WHERE eval_id = p_eval_id AND less_ded = 'Y';

         UPDATE gicl_eval_vat
            --SET VAT_AMT = (BASE_AMT - V_PDEPRECIATION) * (V_VATRT/100), -- PAU 07DEC07 REPLACED WITH:
         SET vat_amt =
                (SELECT DECODE (NVL (v_depwvat, 0),
                                0, ROUND (  (base_amt - v_pdepreciation)
                                          * (v_vatrt / 100),
                                          2
                                         ),
                                1, ROUND (  (base_amt - v_pdepreciation)
                                          - (  (base_amt - v_pdepreciation)
                                             / (1 + v_vatrt / 100)
                                            ),
                                          2
                                         )
                               )
                   FROM DUAL),
             base_amt = base_amt - v_pdepreciation
          WHERE eval_id = p_eval_id AND less_dep = 'Y';
      END;

      -- PAU 21NOV07 END(1)
      IF v_changed1 = 'Y'
      THEN
         UPDATE gicl_mc_evaluation
            SET replace_amt = v_totalpart,
                repair_amt = v_totallabor,
                vat = v_totalvat
          WHERE eval_id = p_eval_id;
      ELSE
         raise_application_error ('-20001', 'no VAT created');
      END IF;
   END;
   
   /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.13.2012
    **  Reference By  : GICLS070 - MC Evaluation Report
    **  Description   : Checks if GICL_EVAL_VAT records
    **                  exist for the given eval_id 
    */ 

    FUNCTION check_gicl_eval_vat_exist (p_eval_id  IN  GICL_MC_EVALUATION.eval_id%TYPE) 
    RETURN VARCHAR2 AS

      v_exist VARCHAR2(1) := 'N';

    BEGIN
        FOR i IN (SELECT 1
                    FROM GICL_EVAL_VAT
                   WHERE eval_id = p_eval_id)
        LOOP
            v_exist := 'Y';
        END LOOP;
        
        RETURN v_exist;
         
    END check_gicl_eval_vat_exist;

END;
/


