CREATE OR REPLACE PACKAGE BODY CPI.gicl_replace_pkg
AS
   FUNCTION get_mc_eval_replace_list (p_eval_id gicl_replace.eval_id%TYPE)
      RETURN gicl_replace_tab PIPELINED
   IS
      v_rep   gicl_replace_type;
   BEGIN
      FOR i IN
         (SELECT   a.*,
                   (SELECT loss_exp_desc
                      FROM giis_loss_exp
                     WHERE loss_exp_cd = a.loss_exp_cd
                       AND line_cd = 'MC'
                       AND part_sw = 'Y'
                       AND loss_exp_type = 'L'
                       AND comp_sw = '+') dsp_part_desc,
                   (SELECT class_desc
                      FROM giis_payee_class
                     WHERE payee_class_cd = a.payee_type_cd)
                                                            dsp_company_type,
                   (gicl_replace_pkg.get_payee_name (a.payee_type_cd,
                                                     a.payee_cd
                                                    )
                   ) dsp_company
              FROM gicl_replace a
             WHERE eval_id = p_eval_id
          ORDER BY item_no)
      LOOP
         v_rep.eval_id := i.eval_id;
         v_rep.payee_type_cd := i.payee_type_cd;
         v_rep.payee_cd := i.payee_cd;
         v_rep.loss_exp_cd := i.loss_exp_cd;
         v_rep.part_type := i.part_type;
         v_rep.part_orig_amt := i.part_orig_amt;
         v_rep.orig_payee_type_cd := i.orig_payee_type_cd;
         v_rep.orig_payee_cd := i.orig_payee_cd;
         v_rep.part_amt := i.part_amt;
         v_rep.base_amt := i.base_amt;
         v_rep.no_of_units := i.no_of_units;
         v_rep.with_vat := i.with_vat;
         v_rep.revised_sw := i.revised_sw;
         v_rep.user_id := i.user_id;
         v_rep.last_update := i.last_update;
         v_rep.payt_payee_type_cd := i.payt_payee_type_cd;
         v_rep.payt_payee_cd := i.payt_payee_cd;
         v_rep.replace_id := i.replace_id;
         v_rep.replaced_master_id := i.replaced_master_id;
         v_rep.item_no := i.item_no;
         v_rep.update_sw := i.update_sw;
         v_rep.dsp_part_desc := i.dsp_part_desc;
         v_rep.dsp_company_type := i.dsp_company_type;
         v_rep.dsp_company := i.dsp_company;
         v_rep.total_part_amt := i.total_part_amt;

         IF i.part_type = 'O'
         THEN
            v_rep.dsp_part_type_desc := 'Original';
         ELSIF i.part_type = 'S'
         THEN
            v_rep.dsp_part_type_desc := 'Surplus';
         ELSIF i.part_type = 'R'
         THEN
            v_rep.dsp_part_type_desc := 'Replacement';
         END IF;

         PIPE ROW (v_rep);
      END LOOP;
   END;

   FUNCTION get_payee_name (
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_no        giis_payees.payee_no%TYPE
   )
      RETURN VARCHAR2
   IS
      vpayeename   VARCHAR2 (500);
   BEGIN
      IF p_payee_type_cd IS NOT NULL AND p_payee_no IS NOT NULL
      THEN
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
              INTO vpayeename
              FROM giis_payees c
             WHERE c.payee_class_cd = p_payee_type_cd
               --:gicl_eval_deductibles.payee_type_cd
               AND c.payee_no = p_payee_no; --:gicl_eval_deductibles.payee_cd;

            RETURN (vpayeename);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               -- msg_alert('payee not found in giis_payees table','I',FALSE);
               RETURN (NULL);
            WHEN TOO_MANY_ROWS
            THEN
               RETURN (NULL);
         END;
      ELSE
         RETURN (NULL);
      END IF;
   END;

   FUNCTION get_parts_list (
      p_eval_id     gicl_replace.eval_id%TYPE,
      p_part_type   gicl_replace.part_type%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN parts_list_tab PIPELINED
   IS
      v_parts   parts_list_type;
   BEGIN
      FOR i IN (SELECT   loss_exp_desc, loss_exp_cd
                    FROM giis_loss_exp a
                   WHERE part_sw = 'Y'
                     AND line_cd = 'MC'
                     AND comp_sw = '+'
                     AND loss_exp_type = 'L'
                     AND NOT EXISTS (
                            SELECT 1
                              FROM gicl_replace
                             WHERE eval_id = p_eval_id
                               AND loss_exp_cd = a.loss_exp_cd
                               AND part_type = p_part_type)
                     AND UPPER (a.loss_exp_desc) LIKE
                                               NVL (UPPER (p_find_text), '%%')
                ORDER BY loss_exp_desc ASC)
      LOOP
         v_parts.loss_exp_desc := i.loss_exp_desc;
         v_parts.loss_exp_cd := i.loss_exp_cd;
         PIPE ROW (v_parts);
      END LOOP;
   END;

   FUNCTION get_company_list (
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_claim_id        gicl_claims.claim_id%TYPE,
      p_find_text       VARCHAR2
   )
      RETURN company_list_tab PIPELINED
   IS
      v_com   company_list_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT    c.payee_last_name
                               || DECODE (c.payee_first_name,
                                          NULL, NULL,
                                          ',' || c.payee_first_name
                                         )
                               || DECODE (c.payee_middle_name,
                                          NULL, NULL,
                                          ' ' || c.payee_middle_name || '.'
                                         ) dsp_company,
                               payee_no
                          FROM giis_payees c
                         WHERE c.payee_class_cd = p_payee_type_cd
                           AND c.payee_no =
                                  (SELECT DECODE (p_payee_type_cd,
                                                  giacp.v ('ASSD_CLASS_CD'), (SELECT assd_no
                                                                                FROM gicl_claims
                                                                               WHERE claim_id =
                                                                                        p_claim_id),
                                                  c.payee_no
                                                 )
                                     FROM DUAL))
                 WHERE UPPER (dsp_company) LIKE
                                               NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_com.dsp_company := i.dsp_company;
         v_com.payee_no := i.payee_no;
         PIPE ROW (v_com);
      END LOOP;
   END;

   PROCEDURE check_update_report_dtl (
      p_eval_master_id       IN       gicl_mc_evaluation.eval_id%TYPE,
      p_eval_id                       gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd          IN       gicl_replace.loss_exp_cd%TYPE,
      p_master_report_type   OUT      gicl_mc_evaluation.report_type%TYPE,
      dep_exist              OUT      VARCHAR2
   )
   IS
   BEGIN
      BEGIN
         SELECT report_type
           INTO p_master_report_type
           FROM gicl_mc_evaluation
          WHERE eval_id = p_eval_master_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_master_report_type := '**';
      END;

      BEGIN
         SELECT 'Y'
           INTO dep_exist
           FROM gicl_eval_dep_dtl
          WHERE eval_id = p_eval_id AND loss_exp_cd = p_loss_exp_cd;
      --:gicl_replace.loss_exp_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            dep_exist := 'N';
      END;
   END;

   PROCEDURE validate_part_type (
      p_master_eval_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id                  gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd              gicl_replace.loss_exp_cd%TYPE,
      p_payee_type_cd            gicl_replace.payee_type_cd%TYPE,
      p_payee_cd                 gicl_replace.payee_cd%TYPE,
      p_base_amt                 gicl_replace.base_amt%TYPE,
      p_no_of_units              gicl_replace.no_of_units%TYPE,
      p_part_type                gicl_replace.part_type%TYPE,
      p_old_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      v_update_sw          OUT   VARCHAR2,
      master_report_type   OUT   gicl_mc_evaluation.report_type%TYPE,
      v_dep_exist          OUT   VARCHAR2
   )
   IS
      vparttype   gicl_replace.part_type%TYPE;
   BEGIN
      NULL;
   END;

   PROCEDURE validate_part_desc (
      p_master_eval_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id                  gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd              gicl_replace.loss_exp_cd%TYPE,
      p_payee_type_cd            gicl_replace.payee_type_cd%TYPE,
      p_payee_cd                 gicl_replace.payee_cd%TYPE,
      p_base_amt                 gicl_replace.base_amt%TYPE,
      p_no_of_units              gicl_replace.no_of_units%TYPE,
      p_part_type                gicl_replace.part_type%TYPE,
      p_old_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      v_update_sw          OUT   VARCHAR2,
      master_report_type   OUT   gicl_mc_evaluation.report_type%TYPE,
      v_dep_exist          OUT   VARCHAR2
   )
   IS
      vlossexpcd   gicl_replace.loss_exp_cd%TYPE;
   BEGIN
      check_update_report_dtl (p_master_eval_id,
                               p_eval_id,
                               p_old_loss_exp_cd,
                               master_report_type,
                               v_dep_exist
                              );

      IF master_report_type = 'RD'
      THEN
         BEGIN
            SELECT DISTINCT loss_exp_cd
                       INTO vlossexpcd
                       FROM gicl_replace
                      WHERE eval_id = p_master_eval_id
                        AND part_type = p_part_type
                        AND payee_type_cd = p_payee_type_cd
                        AND payee_cd = p_payee_cd
                        AND base_amt = p_base_amt
                        AND no_of_units = p_no_of_units;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               vlossexpcd := '-----';
         END;

         IF vlossexpcd <> p_loss_exp_cd
         THEN
            v_update_sw := 'Y';
         ELSE
            v_update_sw := 'N';
         END IF;
      END IF;
   END;

   PROCEDURE validate_company_type (
      p_master_eval_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id                  gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd              gicl_replace.loss_exp_cd%TYPE,
      p_payee_type_cd            gicl_replace.payee_type_cd%TYPE,
      p_payee_cd                 gicl_replace.payee_cd%TYPE,
      p_base_amt                 gicl_replace.base_amt%TYPE,
      p_no_of_units              gicl_replace.no_of_units%TYPE,
      p_part_type                gicl_replace.part_type%TYPE,
      p_old_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      v_update_sw          OUT   VARCHAR2,
      master_report_type   OUT   gicl_mc_evaluation.report_type%TYPE,
      v_dep_exist          OUT   VARCHAR2
   )
   IS
      vpayeetypecd   gicl_replace.payee_type_cd%TYPE;
   BEGIN
      check_update_report_dtl (p_master_eval_id,
                               p_eval_id,
                               p_loss_exp_cd,
                               master_report_type,
                               v_dep_exist
                              );

      IF master_report_type = 'RD'
      THEN
         BEGIN
            SELECT DISTINCT loss_exp_cd
                       INTO vpayeetypecd
                       FROM gicl_replace
                      WHERE eval_id = p_master_eval_id
                        AND part_type = p_part_type
                        AND loss_exp_cd = p_loss_exp_cd
                        AND payee_cd = p_payee_cd
                        AND base_amt = p_base_amt
                        AND no_of_units = p_no_of_units;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               vpayeetypecd := '--';
         END;

         IF vpayeetypecd <> p_payee_type_cd
         THEN
            v_update_sw := 'Y';
         ELSE
            v_update_sw := 'N';
         END IF;
      END IF;
   END;

   PROCEDURE validate_company_desc (
      p_master_eval_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id                  gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd              gicl_replace.loss_exp_cd%TYPE,
      p_payee_type_cd            gicl_replace.payee_type_cd%TYPE,
      p_payee_cd                 gicl_replace.payee_cd%TYPE,
      p_base_amt                 gicl_replace.base_amt%TYPE,
      p_no_of_units              gicl_replace.no_of_units%TYPE,
      p_part_type                gicl_replace.part_type%TYPE,
      p_old_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      v_update_sw          OUT   VARCHAR2,
      master_report_type   OUT   gicl_mc_evaluation.report_type%TYPE,
      v_dep_exist          OUT   VARCHAR2
   )
   IS
      vpayeecd   gicl_replace.payee_cd%TYPE;
   BEGIN
      check_update_report_dtl (p_master_eval_id,
                               p_eval_id,
                               p_loss_exp_cd,
                               master_report_type,
                               v_dep_exist
                              );

      IF master_report_type = 'RD'
      THEN
         BEGIN
            SELECT DISTINCT payee_cd
                       INTO vpayeecd
                       FROM gicl_replace
                      WHERE eval_id = p_master_eval_id
                        AND part_type = p_part_type
                        AND loss_exp_cd = p_loss_exp_cd
                        AND payee_type_cd = p_payee_type_cd
                        AND base_amt = p_base_amt
                        AND no_of_units = p_no_of_units;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               vpayeecd := -9999;
         END;

         IF vpayeecd <> p_payee_cd
         THEN
            v_update_sw := 'Y';
         ELSE
            v_update_sw := 'N';
         END IF;
      END IF;
   END;

   PROCEDURE validate_base_amt (
      p_master_eval_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id                  gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd              gicl_replace.loss_exp_cd%TYPE,
      p_payee_type_cd            gicl_replace.payee_type_cd%TYPE,
      p_payee_cd                 gicl_replace.payee_cd%TYPE,
      p_base_amt                 gicl_replace.base_amt%TYPE,
      p_no_of_units              gicl_replace.no_of_units%TYPE,
      p_part_type                gicl_replace.part_type%TYPE,
      p_old_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      v_update_sw          OUT   VARCHAR2,
      master_report_type   OUT   gicl_mc_evaluation.report_type%TYPE,
      v_dep_exist          OUT   VARCHAR2
   )
   IS
      vbaseamt   gicl_replace.base_amt%TYPE   := -1999987654321.84;
      haynako    NUMBER                       := 0;
   BEGIN
      check_update_report_dtl (p_master_eval_id,
                               p_eval_id,
                               p_loss_exp_cd,
                               master_report_type,
                               v_dep_exist
                              );

      IF master_report_type = 'RD'
      THEN
         BEGIN
            SELECT DISTINCT base_amt
                       INTO vbaseamt
                       FROM gicl_replace
                      WHERE eval_id = p_master_eval_id
                        AND part_type = p_part_type
                        AND loss_exp_cd = p_loss_exp_cd
                        AND payee_type_cd = p_payee_type_cd
                        AND payee_cd = p_payee_cd
                        AND no_of_units = p_no_of_units;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               vbaseamt := 0;
            WHEN TOO_MANY_ROWS
            THEN
               haynako := 1;

               FOR x IN (SELECT DISTINCT base_amt
                                    FROM gicl_replace
                                   WHERE eval_id = p_master_eval_id
                                     AND part_type = p_part_type
                                     AND loss_exp_cd = p_loss_exp_cd
                                     AND payee_type_cd = p_payee_type_cd
                                     AND payee_cd = p_payee_cd
                                     AND no_of_units = p_no_of_units)
               LOOP
                  IF p_base_amt = x.base_amt
                  THEN
                     haynako := 2;
                  END IF;
               END LOOP;
         END;

         IF p_base_amt - vbaseamt <> 0 AND vbaseamt <> -1999987654321.84
         THEN
            v_update_sw := 'Y';
         ELSE
            v_update_sw := 'N';
--msg_alert('Reverting to original information. Please save afterwards.','I',FALSE); --petermkawmsg optional msg
         END IF;

         IF haynako = 1
         THEN
            v_update_sw := 'Y';
         ELSIF haynako = 2
         THEN
            v_update_sw := 'N';
         END IF;
      END IF;
   END;

   PROCEDURE validate_no_of_units (
      p_master_eval_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id                  gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd              gicl_replace.loss_exp_cd%TYPE,
      p_payee_type_cd            gicl_replace.payee_type_cd%TYPE,
      p_payee_cd                 gicl_replace.payee_cd%TYPE,
      p_base_amt                 gicl_replace.base_amt%TYPE,
      p_no_of_units              gicl_replace.no_of_units%TYPE,
      p_part_type                gicl_replace.part_type%TYPE,
      p_old_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      v_update_sw          OUT   VARCHAR2,
      master_report_type   OUT   gicl_mc_evaluation.report_type%TYPE,
      v_dep_exist          OUT   VARCHAR2
   )
   IS
      vnoofunits   gicl_replace.no_of_units%TYPE;
   BEGIN
      check_update_report_dtl (p_master_eval_id,
                               p_eval_id,
                               p_loss_exp_cd,
                               master_report_type,
                               v_dep_exist
                              );

      IF master_report_type = 'RD'
      THEN
         BEGIN
            SELECT DISTINCT no_of_units
                       INTO vnoofunits
                       FROM gicl_replace
                      WHERE eval_id = p_master_eval_id
                        AND part_type = p_part_type
                        AND loss_exp_cd = p_loss_exp_cd
                        AND payee_type_cd = p_payee_type_cd
                        AND payee_cd = p_payee_cd
                        AND base_amt = p_base_amt;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               vnoofunits := -9999;
         END;

         IF vnoofunits <> p_no_of_units
         THEN
            v_update_sw := 'Y';
         ELSE
            v_update_sw := 'N';
         END IF;
      END IF;
   END;

   FUNCTION get_prev_part_list (
      p_loss_exp_cd      gicl_replace.loss_exp_cd%TYPE,
      p_part_type        gicl_replace.part_type%TYPE,
      p_tp_sw            gicl_mc_evaluation.tp_sw%TYPE,
      p_claim_id         gicl_mc_evaluation.claim_id%TYPE,
      p_item_no          gicl_mc_evaluation.item_no%TYPE,
      p_payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      p_payee_no         gicl_mc_evaluation.payee_no%TYPE,
      p_find_text        VARCHAR2
   )
      RETURN prev_part_list_tab PIPELINED
   IS
      v_parts   prev_part_list_type;
   BEGIN
      FOR i IN
         (SELECT *
            FROM (SELECT *
                    FROM (SELECT   DECODE (a.revised_sw,
                                           'Y', a.total_part_amt,
                                           a.base_amt
                                          ) part_amt,
                                   b.eval_date, a.payee_type_cd, a.payee_cd,
                                   d.class_desc,
                                      c.payee_last_name
                                   || DECODE (c.payee_first_name,
                                              NULL, NULL,
                                              ',' || c.payee_first_name
                                             )
                                   || DECODE (c.payee_middle_name,
                                              NULL, NULL,
                                              ' ' || c.payee_middle_name
                                              || '.'
                                             ) payee_name,
                                   a.eval_id,
                                   DECODE (part_type,
                                           'S', 'SURPLUS',
                                           'O', 'ORIGINAL',
                                           'R', 'REPLACEMENT'
                                          ) part_type1,
                                   part_type
                              FROM gicl_replace a,
                                   gicl_mc_evaluation b,
                                   giis_payees c,
                                   giis_payee_class d
                             WHERE 1 = 1
                               AND a.eval_id = b.eval_id
                               AND a.payee_type_cd = c.payee_class_cd
                               AND a.payee_cd = c.payee_no
                               AND a.payee_type_cd = d.payee_class_cd
                               AND a.loss_exp_cd = p_loss_exp_cd
                               AND a.part_type = p_part_type
                               AND b.eval_stat_cd = 'PD'
                               AND NOT EXISTS (
                                      SELECT 1
                                        FROM gicl_replace e,
                                             gicl_mc_evaluation f
                                       WHERE e.eval_id = f.eval_id
                                         AND e.replaced_master_id =
                                                                  a.replace_id
                                         AND ROWNUM = 1)
                               AND NVL
                                      ((SELECT DECODE
                                                  (b.tp_sw,
                                                   'Y', (SELECT    make_cd
                                                                || '/'
                                                                || motorcar_comp_cd
                                                                || '/'
                                                                || model_year
                                                           FROM gicl_mc_tp_dtl
                                                          WHERE claim_id =
                                                                    b.claim_id
                                                            AND item_no =
                                                                     b.item_no
                                                            AND payee_class_cd =
                                                                   b.payee_class_cd
                                                            AND payee_no =
                                                                    b.payee_no),
                                                   (SELECT    make_cd
                                                           || '/'
                                                           || motcar_comp_cd
                                                           || '/'
                                                           || model_year
                                                      FROM gicl_motor_car_dtl
                                                     WHERE claim_id =
                                                                    b.claim_id)
                                                  )
                                          FROM DUAL),
                                       -1
                                      ) =
                                      NVL
                                         ((SELECT DECODE
                                                     (p_tp_sw,
                                                      'Y', (SELECT    make_cd
                                                                   || '/'
                                                                   || motorcar_comp_cd
                                                                   || '/'
                                                                   || model_year
                                                              FROM gicl_mc_tp_dtl
                                                             WHERE claim_id =
                                                                      p_claim_id
                                                               AND item_no =
                                                                      p_item_no
                                                               AND payee_class_cd =
                                                                      p_payee_class_cd
                                                               AND payee_no =
                                                                      p_payee_no),
                                                      (SELECT    make_cd
                                                              || '/'
                                                              || motcar_comp_cd
                                                              || '/'
                                                              || model_year
                                                         FROM gicl_motor_car_dtl
                                                        WHERE claim_id =
                                                                    p_claim_id)
                                                     )
                                             FROM DUAL),
                                          -1
                                         )
                               AND b.eval_date IS NOT NULL
                          ORDER BY b.eval_date DESC,
                                   a.last_update DESC,
                                   a.part_amt ASC)
                   WHERE ROWNUM <= 3)
           WHERE UPPER (part_type1) LIKE NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_parts.part_type := i.part_type;
         v_parts.dsp_part_type_desc := i.part_type1;
         v_parts.dsp_company_type := i.class_desc;
         v_parts.dsp_company := i.payee_name;
         v_parts.part_amt := i.part_amt;
         v_parts.eval_date := TO_CHAR (i.eval_date, 'MM-DD-YYYY');
         v_parts.payee_cd := i.payee_cd;
         v_parts.payee_type_cd := i.payee_type_cd;
         PIPE ROW (v_parts);
      END LOOP;
   END;

   PROCEDURE check_part_if_exist_master (
      p_loss_exp_cd                gicl_replace.loss_exp_cd%TYPE,
      p_part_type                  gicl_replace.part_type%TYPE,
      p_eval_id                    gicl_mc_evaluation.eval_id%TYPE,
      p_eval_master_id             gicl_mc_evaluation.eval_id%TYPE,
      p_payee_cd                   gicl_replace.payee_cd%TYPE,
      p_payee_type_cd              gicl_replace.payee_type_cd%TYPE,
      p_var_s                      VARCHAR2,
      p_result               OUT   VARCHAR2,
      p_replaced_master_id   OUT   gicl_replace.replaced_master_id%TYPE
   )
   IS
      x     VARCHAR2 (1);
      idx   gicl_replace.replace_id%TYPE;
   BEGIN
      BEGIN
         x := '';

         SELECT replace_id
           INTO idx
           FROM gicl_replace a, gicl_mc_evaluation b
          WHERE 1 = 1
            AND a.loss_exp_cd = p_loss_exp_cd
            AND a.part_type = p_part_type
            AND a.eval_id <> p_eval_id
            AND a.eval_id = b.eval_id
            AND (   a.eval_id = p_eval_master_id
                 OR b.eval_master_id = p_eval_master_id
                )
            AND b.eval_stat_cd = 'PD'
            AND DECODE (p_var_s, 'Y', a.payee_type_cd, 1) =
                                     DECODE (p_var_s,
                                             'Y', p_payee_type_cd,
                                             1
                                            )
            AND DECODE (p_var_s, 'Y', a.payee_cd, 1) =
                                          DECODE (p_var_s,
                                                  'Y', p_payee_cd,
                                                  1
                                                 )
            --   AND NVL(revised_sw,'N') = 'N'
            --   AND replaced_master_id IS NULL
            AND NOT EXISTS (
                   SELECT 1
                     FROM gicl_replace c, gicl_mc_evaluation d
                    WHERE 1 = 1
                      AND c.eval_id = d.eval_id
                      AND d.eval_stat_cd = 'PD'
                      AND c.replaced_master_id = a.replace_id
                      AND ROWNUM = 1);

         x := '1';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            x := '0';
         WHEN TOO_MANY_ROWS
         THEN
            x := '2';
      END;

      p_result := x;
      p_replaced_master_id := idx;
   /* done in java
   IF x>0 THEN
        lov:=NULL;
        set_alert_property('save_alert',alert_message_text,'This part already exists in the master and/or other posted additional reports'||chr(10)||'Do you want to revise it?');
         ans := show_alert('save_alert');

         IF ans = ALERT_BUTTON1 THEN
             :gicl_replace.revised_sw := 'Y';  --ndi na kelngan to actually. hehe syang column eh lagyan naten :)
             IF x=2 THEN --multiple records...
                lov := show_lov('multiple_parts_lov');
                IF lov THEN
                     copyMasterPart(FALSE);
               ELSE
                   --will add new
                   :gicl_replace.revised_sw := 'N';
                  END IF;
             ELSE
                 :gicl_replace.replaced_master_id := idx;
                 copyMasterPart(TRUE);
             END IF;
         ELSE
             :gicl_replace.revised_sw := 'N';
             --will add new
         END IF;
    ELSE
      :gicl_replace.revised_sw := 'N';
   END IF;*/
   END;

   FUNCTION get_multiple_parts_list (
      p_loss_exp_cd      gicl_replace.loss_exp_cd%TYPE,
      p_part_type        gicl_replace.part_type%TYPE,
      p_eval_id          gicl_mc_evaluation.eval_id%TYPE,
      p_eval_master_id   gicl_mc_evaluation.eval_id%TYPE,
      p_find_text        VARCHAR2
   )
      RETURN multiple_parts_tab PIPELINED
   IS
      v_parts   multiple_parts_type;
   BEGIN
      FOR i IN (SELECT a.payee_type_cd, d.class_desc, a.payee_cd,
                       a.replace_id,
                          e.payee_last_name
                       || DECODE (e.payee_first_name,
                                  NULL, NULL,
                                  ',' || e.payee_first_name
                                 )
                       || DECODE (e.payee_middle_name,
                                  NULL, NULL,
                                  ' ' || e.payee_middle_name || '.'
                                 ) payee_name,
                       a.base_amt, c.loss_exp_desc
                  FROM gicl_replace a,
                       gicl_mc_evaluation b,
                       giis_loss_exp c,
                       giis_payee_class d,
                       giis_payees e
                 WHERE 1 = 1
                   AND e.payee_class_cd = a.payee_type_cd
                   AND e.payee_no = a.payee_cd
                   AND d.payee_class_cd = a.payee_type_cd
                   AND c.part_sw = 'Y'
                   AND c.line_cd = 'MC'
                   AND c.comp_sw = '+'
                   AND c.loss_exp_type = 'L'
                   AND a.loss_exp_cd = c.loss_exp_cd
                   AND a.loss_exp_cd = p_loss_exp_cd
                   AND a.part_type = p_part_type
                   AND a.eval_id <> p_eval_id
                   AND a.eval_id = b.eval_id
                   AND (   a.eval_id = p_eval_master_id
                        OR b.eval_master_id = p_eval_master_id
                       )
                   AND b.eval_stat_cd = 'PD'
                   --   AND NVL(revised_sw,'N') = 'N'
                   --   AND replaced_master_id IS NULL
                   AND NOT EXISTS (
                          SELECT 1
                            FROM gicl_replace f, gicl_mc_evaluation g
                           WHERE 1 = 1
                             AND f.eval_id = g.eval_id
                             AND g.eval_stat_cd = 'PD'
                             AND f.replaced_master_id = a.replace_id
                             AND ROWNUM = 1)
                   AND UPPER (d.class_desc) LIKE
                                               NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_parts.payee_type_cd := i.payee_type_cd;
         v_parts.dsp_company_type := i.class_desc;
         v_parts.dsp_company := i.payee_name;
         v_parts.payee_cd := i.payee_cd;
         v_parts.replace_id := i.replace_id;
         v_parts.base_amt := i.base_amt;
         v_parts.dsp_part_desc := i.loss_exp_desc;
         PIPE ROW (v_parts);
      END LOOP;
   END;

   FUNCTION copy_master_part (
      p_replaced_master_id   gicl_replace.replaced_master_id%TYPE,
      p_all_dtl_flag         VARCHAR2
   )
      RETURN copy_master_part_tab PIPELINED
   IS
      v_part   copy_master_part_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_replace
                 WHERE replace_id = p_replaced_master_id)
      --135555)--p_replaced_master_id)
      LOOP
         IF p_all_dtl_flag = 'Y'
         THEN
            v_part.payee_type_cd := i.payee_type_cd;
            v_part.payee_cd := i.payee_cd;

            /*company type*/
            BEGIN
               SELECT class_desc
                 INTO v_part.dsp_company_type
                 FROM giis_payee_class
                WHERE payee_class_cd = i.payee_type_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_part.dsp_company_type := '';
               --raise_application_error('-20001','class not found in giis_payee_class table');
               WHEN TOO_MANY_ROWS
               THEN
                  v_part.dsp_company_type := '';
            --raise_application_error('-20001','Too many rows retrieved for company type');
            END;

            /*company*/
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
                 INTO v_part.dsp_company
                 FROM giis_payees c
                WHERE c.payee_class_cd = i.payee_type_cd
                  --:gicl_eval_deductibles.payee_type_cd
                  AND c.payee_no = i.payee_cd;
            --:gicl_eval_deductibles.payee_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  --raise_application_error('-20001','payee not found in giis_payees table');
                  v_part.dsp_company := '';
               WHEN TOO_MANY_ROWS
               THEN
                  v_part.dsp_company := '';
            END;

            v_part.base_amt := NVL (i.total_part_amt, i.base_amt);
            v_part.no_of_units := i.no_of_units;
            v_part.part_amt := i.part_amt;
         END IF;

         v_part.total_part_amt :=
                           NVL (v_part.base_amt, 0)
                           + NVL (i.total_part_amt, 0);
         PIPE ROW (v_part);
         EXIT;
      END LOOP;
   END;

   PROCEDURE get_payee_details (
      p_claim_id              gicl_claims.claim_id%TYPE,
      p_payee_type_cd         gicl_replace.payee_type_cd%TYPE,
      dsp_company       OUT   VARCHAR2,
      payee_cd          OUT   gicl_replace.payee_cd%TYPE
   )
   IS
   BEGIN
      BEGIN
         SELECT assd_no
           INTO payee_cd
           FROM gicl_claims
          WHERE claim_id = p_claim_id;

         --  dsp_company := getPayeeName(:parameter.payee_type_cd,:gicl_replace.payee_cd);
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
              INTO dsp_company
              FROM giis_payees c
             WHERE c.payee_class_cd = p_payee_type_cd
                   --:gicl_eval_deductibles.payee_type_cd
                   AND c.payee_no = payee_cd;
         --:gicl_eval_deductibles.payee_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               dsp_company := '';
            WHEN TOO_MANY_ROWS
            THEN
               dsp_company := '';
         END;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   END;

   FUNCTION get_rep_mortgagee_list (
      p_claim_id    gicl_claims.claim_id%TYPE,
      p_item_no     gicl_replace.item_no%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN company_list_tab PIPELINED
   IS
      v_comp   company_list_type;
   BEGIN
      FOR i IN
         (SELECT *
            FROM (SELECT DISTINCT a.payee_no,
                                     a.payee_last_name
                                  || DECODE (a.payee_first_name,
                                             NULL, NULL,
                                             ',' || a.payee_first_name
                                            )
                                  || DECODE (a.payee_middle_name,
                                             NULL, NULL,
                                             ' ' || a.payee_middle_name || '.'
                                            ) dsp_company
                             FROM giis_payees a,
                                  giis_mortgagee b,
                                  gicl_mortgagee c
                            WHERE b.mortg_cd = c.mortg_cd
                              AND b.iss_cd = c.iss_cd
                              AND a.payee_no = b.mortgagee_id
                              AND a.payee_class_cd =
                                                giacp.v ('MORTGAGEE_CLASS_CD')
                              AND c.claim_id = p_claim_id
                              AND c.item_no = p_item_no)
           WHERE UPPER (dsp_company) LIKE NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_comp.dsp_company := i.dsp_company;
         v_comp.payee_no := i.payee_no;
         PIPE ROW (v_comp);
      END LOOP;
   END;

   PROCEDURE check_vat_and_deductibles (
      p_payee_cd                       gicl_replace.payee_cd%TYPE,
      p_payee_type_cd                  gicl_replace.payee_type_cd%TYPE,
      p_payt_payee_cd                  gicl_replace.payee_cd%TYPE,
      p_payt_payee_type_cd             gicl_replace.payee_type_cd%TYPE,
      p_payee_cd_old                   gicl_replace.payee_cd%TYPE,
      p_payee_type_cd_old              gicl_replace.payee_type_cd%TYPE,
      p_payt_payee_cd_old              gicl_replace.payee_cd%TYPE,
      p_payt_payee_type_cd_old         gicl_replace.payee_type_cd%TYPE,
      p_eval_id                        gicl_mc_evaluation.eval_id%TYPE,
      v_old_payee_ded            OUT   NUMBER,
      v_new_payee_ded            OUT   NUMBER,
      v_old_payee_ded2           OUT   NUMBER,
      v_new_payee_ded2           OUT   NUMBER,
      v_payee_dep                OUT   NUMBER
   )
   IS
      x   NUMBER;
   BEGIN
      --VAT--
      BEGIN
         SELECT 1
           INTO v_old_payee_ded
           FROM gicl_eval_vat
          WHERE eval_id = p_eval_id
            AND payee_type_cd =
                           NVL (p_payt_payee_type_cd_old, p_payee_type_cd_old)
            AND payee_cd = NVL (p_payt_payee_cd_old, p_payee_cd_old)
            AND apply_to = 'P'
            AND ROWNUM = 1;

         v_old_payee_ded :=
            gicl_replace_pkg.countreplace (NVL (p_payt_payee_type_cd_old,
                                                p_payee_type_cd_old
                                               ),
                                           NVL (p_payt_payee_cd_old,
                                                p_payee_cd_old
                                               ),
                                           p_eval_id
                                          );

         BEGIN
            SELECT 1 + v_old_payee_ded
              INTO v_old_payee_ded
              FROM gicl_repair_hdr
             WHERE eval_id = p_eval_id
               AND payee_type_cd =
                           NVL (p_payt_payee_type_cd_old, p_payee_type_cd_old)
               AND payee_cd = NVL (p_payt_payee_cd_old, p_payee_cd_old)
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_old_payee_ded := 0;
      END;

      BEGIN
         SELECT 1
           INTO v_new_payee_ded
           FROM gicl_eval_vat
          WHERE eval_id = p_eval_id
            AND payee_type_cd = NVL (p_payt_payee_type_cd, p_payee_type_cd)
            AND payee_cd = NVL (p_payt_payee_cd, p_payee_cd)
            AND apply_to = 'P'
            AND ROWNUM = 1;

         v_new_payee_ded :=
            gicl_replace_pkg.countreplace (NVL (p_payt_payee_type_cd,
                                                p_payee_type_cd
                                               ),
                                           NVL (p_payt_payee_cd, p_payee_cd),
                                           p_eval_id
                                          );

         BEGIN
            SELECT 1 + v_new_payee_ded
              INTO v_new_payee_ded
              FROM gicl_repair_hdr
             WHERE eval_id = p_eval_id
               AND payee_type_cd = NVL (p_payt_payee_type_cd, p_payee_type_cd)
               AND payee_cd = NVL (p_payt_payee_cd, p_payee_cd)
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_new_payee_ded := 0;
      END;

      --DEDUCTLIBLES--
                --company has deductible entry
      BEGIN
         SELECT 1, ded_base_amt
           INTO v_old_payee_ded2, x
           FROM gicl_eval_deductibles
          WHERE eval_id = p_eval_id
            AND payee_type_cd =
                           NVL (p_payt_payee_type_cd_old, p_payee_type_cd_old)
            AND payee_cd = NVL (p_payt_payee_cd_old, p_payee_cd_old);

         v_old_payee_ded2 :=
            gicl_replace_pkg.countreplace (NVL (p_payt_payee_type_cd_old,
                                                p_payee_type_cd_old
                                               ),
                                           NVL (p_payt_payee_cd_old,
                                                p_payee_cd_old
                                               ),
                                           p_eval_id
                                          );

         --msg_alert(x||'='||variables.v_base_amt,'I',FALSE);--++
         BEGIN
            SELECT 1 + v_old_payee_ded2
              INTO v_old_payee_ded2
              FROM gicl_repair_hdr
             WHERE eval_id = p_eval_id
               AND payee_type_cd =
                           NVL (p_payt_payee_type_cd_old, p_payee_type_cd_old)
               AND payee_cd = NVL (p_payt_payee_cd_old, p_payee_cd_old)
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_old_payee_ded2 := 0;
         WHEN TOO_MANY_ROWS
         THEN
            v_old_payee_ded2 := 2;
      END;

      --payee has deductible entry
      BEGIN
         SELECT 1, ded_base_amt
           INTO v_new_payee_ded2, x
           FROM gicl_eval_deductibles
          WHERE eval_id = p_eval_id
            AND payee_type_cd = p_payee_type_cd
            AND payee_cd = p_payee_cd;

         v_new_payee_ded :=
            gicl_replace_pkg.countreplace (p_payee_type_cd,
                                           p_payee_cd,
                                           p_eval_id
                                          );

         BEGIN
            SELECT 1 + v_new_payee_ded
              INTO v_new_payee_ded2
              FROM gicl_repair_hdr
             WHERE eval_id = p_eval_id
               AND payee_type_cd = p_payee_type_cd
               AND payee_cd = p_payee_cd
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_new_payee_ded2 := 0;
         WHEN TOO_MANY_ROWS
         THEN
            v_new_payee_ded2 := 2;
      END;

      -- depreciation
      BEGIN
         SELECT 1
           INTO v_payee_dep
           FROM gicl_eval_dep_dtl
          WHERE eval_id = p_eval_id
            AND payee_type_cd =
                           NVL (p_payt_payee_type_cd_old, p_payee_type_cd_old)
            AND payee_cd = NVL (p_payt_payee_cd_old, p_payee_cd_old)
            AND ROWNUM = 1;

         v_payee_dep :=
            gicl_replace_pkg.countreplace (NVL (p_payt_payee_type_cd_old,
                                                p_payee_type_cd_old
                                               ),
                                           NVL (p_payt_payee_cd_old,
                                                p_payee_cd_old
                                               ),
                                           p_eval_id
                                          );

         IF v_payee_dep = 1
         THEN
            BEGIN
               SELECT v_payee_dep + 1
                 INTO v_payee_dep
                 FROM gicl_repair_hdr
                WHERE eval_id = p_eval_id
                  AND payee_type_cd =
                           NVL (p_payt_payee_type_cd_old, p_payee_type_cd_old)
                  AND payee_cd = NVL (p_payt_payee_cd_old, p_payee_cd_old)
                  AND ROWNUM = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_payee_dep := 0;
      END;
   END;

   FUNCTION countreplace (
      p_payeetypecd   VARCHAR2,
      p_payeecd       NUMBER,
      p_eval_id       gicl_mc_evaluation.eval_id%TYPE
   )
      RETURN NUMBER
   IS
      x   NUMBER;
   BEGIN
      SELECT 1
        INTO x
        FROM gicl_replace
       WHERE eval_id = p_eval_id
         AND NVL (payt_payee_type_cd, payee_type_cd) = p_payeetypecd
         AND NVL (payt_payee_cd, payee_cd) = p_payeecd;

      RETURN (1);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
      WHEN TOO_MANY_ROWS
      THEN
         RETURN (2);
   END;

   FUNCTION get_with_vat_list (
      p_eval_master_id   gicl_mc_evaluation.eval_id%TYPE
   )
      RETURN with_vat_tab PIPELINED
   IS
      v_wv   with_vat_type;
   BEGIN
      FOR i IN (SELECT a.with_vat wv
                  FROM gicl_replace a, gicl_mc_evaluation b
                 WHERE 1 = 1
                   AND a.eval_id = b.eval_id
                   AND b.report_type = 'NR'
                   AND (   a.eval_id = p_eval_master_id
                        OR b.eval_master_id = p_eval_master_id
                       )
                   AND b.eval_stat_cd <> 'CC')
      LOOP
         v_wv.with_vat := i.wv;
         PIPE ROW (v_wv);
      END LOOP;
   END;

   FUNCTION final_check_vat (
      p_payee_cd             gicl_replace.payee_cd%TYPE,
      p_payee_type_cd        gicl_replace.payee_type_cd%TYPE,
      p_payt_payee_cd        gicl_replace.payee_cd%TYPE,
      p_payt_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_eval_id              gicl_mc_evaluation.eval_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_with_vat   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_with_vat
           FROM gicl_eval_vat
          WHERE 1 = 1
            AND eval_id = p_eval_id
            AND payee_type_cd = NVL (p_payt_payee_type_cd, p_payee_type_cd)
            AND payee_cd = NVL (p_payt_payee_cd, p_payee_cd)
            AND apply_to = 'P'
            AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_with_vat := 'N';
         WHEN TOO_MANY_ROWS
         THEN
            raise_application_error
                        ('-20001',
                         'Too many rows retrieved in checking of vat details'
                        );
      END;

      RETURN v_with_vat;
   END;

   FUNCTION final_check_ded (
      p_eval_id       gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd   gicl_replace.loss_exp_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_with_dep   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_with_dep
           FROM gicl_eval_dep_dtl
          WHERE eval_id = p_eval_id AND loss_exp_cd = p_loss_exp_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_with_dep := 'N';
         WHEN TOO_MANY_ROWS
         THEN
            raise_application_error
               ('-20001',
                'Too many rows retrieved in checking of depreciation details aaa002'
               );
      END;

      RETURN v_with_dep;
   END;

   PROCEDURE save_replace_dtls_gicls070 (
      p_eval_id              gicl_replace.eval_id%TYPE,
      p_payee_type_cd        gicl_replace.payee_type_cd%TYPE,
      p_payee_cd             gicl_replace.payee_cd%TYPE,
      p_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      p_part_type            gicl_replace.part_type%TYPE,
      p_part_orig_amt        gicl_replace.part_orig_amt%TYPE,
      p_orig_payee_type_cd   gicl_replace.orig_payee_type_cd%TYPE,
      p_orig_payee_cd        gicl_replace.orig_payee_cd%TYPE,
      p_part_amt             gicl_replace.part_amt%TYPE,
      p_total_part_amt       gicl_replace.total_part_amt%TYPE,
      p_base_amt             gicl_replace.base_amt%TYPE,
      p_no_of_units          gicl_replace.no_of_units%TYPE,
      p_with_vat             gicl_replace.with_vat%TYPE,
      p_revised_sw           gicl_replace.revised_sw%TYPE,
      p_user_id              gicl_replace.user_id%TYPE,
      p_payt_payee_type_cd   gicl_replace.payt_payee_type_cd%TYPE,
      p_payt_payee_cd        gicl_replace.payt_payee_cd%TYPE,
      p_replace_id           gicl_replace.replace_id%TYPE,
      p_replaced_master_id   gicl_replace.replaced_master_id%TYPE,
      p_update_sw            gicl_replace.update_sw%TYPE,
      p_new_rec              VARCHAR2,
      p_report_type          gicl_mc_evaluation.report_type%TYPE,
      p_eval_master_id       gicl_mc_evaluation.eval_master_id%TYPE
   )
   IS
      v_with_vat   gicl_replace.with_vat%TYPE;
      vtypetag     gicl_replace.with_vat%TYPE;
   BEGIN
      --  pre insert
      BEGIN
         v_with_vat := p_with_vat;

         IF (p_new_rec = 'Y')
         THEN
            FOR r IN
               (SELECT a.with_vat wv
                  FROM gicl_replace a, gicl_mc_evaluation b
                 WHERE 1 = 1
                   AND a.eval_id = b.eval_id
                   AND (   a.eval_id = p_eval_master_id
                        OR (    b.eval_master_id = p_eval_master_id
                            AND b.report_type = 'AD'
                           )
                       )                              --4.0 petermkaw 03122010
                   AND b.eval_stat_cd <> 'CC')
            LOOP
               IF p_report_type IN ('AD', 'NR')
               THEN
                  IF r.wv = 'Y'
                  THEN
                     vtypetag := 'Y';
                  ELSIF r.wv = 'N'
                  THEN
                     vtypetag := 'N';
                  END IF;

                  IF p_replace_id IS NULL
                  THEN
                     IF vtypetag = 'Y'
                     THEN
                        v_with_vat := 'Y';
                        NULL;
                     ELSE
                        v_with_vat := 'N';
                        NULL;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         END IF;
      END;

      BEGIN
         MERGE INTO gicl_replace
            USING DUAL
            ON (replace_id = p_replace_id)
            WHEN MATCHED THEN
               UPDATE
                  SET payee_type_cd = p_payee_type_cd, payee_cd = p_payee_cd,
                      loss_exp_cd = p_loss_exp_cd, part_type = p_part_type,
                      part_orig_amt = p_part_orig_amt,
                      orig_payee_type_cd = p_orig_payee_type_cd,
                      orig_payee_cd = p_orig_payee_cd, part_amt = p_part_amt,
                      total_part_amt = p_total_part_amt,
                      base_amt = p_base_amt, no_of_units = p_no_of_units,
                      with_vat = v_with_vat, revised_sw = p_revised_sw,
                      user_id = p_user_id, last_update = SYSDATE,
                      payt_payee_type_cd = p_payt_payee_type_cd,
                      replaced_master_id = p_replaced_master_id,
                      update_sw = p_update_sw
            WHEN NOT MATCHED THEN
               INSERT (eval_id, payee_type_cd, payee_cd, loss_exp_cd,
                       part_type, part_orig_amt, orig_payee_type_cd,
                       orig_payee_cd, part_amt, total_part_amt, base_amt,
                       no_of_units, with_vat, revised_sw, user_id,
                       last_update, payt_payee_type_cd, replaced_master_id,
                       update_sw)
               VALUES (p_eval_id, p_payee_type_cd, p_payee_cd, p_loss_exp_cd,
                       p_part_type, p_part_orig_amt, p_orig_payee_type_cd,
                       p_orig_payee_cd, p_part_amt, p_total_part_amt,
                       p_base_amt, p_no_of_units, v_with_vat, p_revised_sw,
                       p_user_id, SYSDATE, p_payt_payee_type_cd,
                       p_replaced_master_id, p_update_sw);
      END;
   END;

   PROCEDURE update_item_no (p_eval_id gicl_replace.eval_id%TYPE)
   IS
      vitemno   gicl_replace.item_no%TYPE;
      vcnt      NUMBER                      := 0;
      vmax      NUMBER                      := 0;
   BEGIN
      vitemno := 0;

      /* FOR i IN (SELECT   a.item_no, a.eval_id, a.loss_exp_cd
                     FROM gicl_replace a, gicl_mc_evaluation b
                    WHERE 1 = 1
                      AND a.eval_id = b.eval_id
                      AND (   a.eval_id = p_eval_id
                           OR (    b.eval_master_id = p_eval_id
                               AND b.report_type = 'AD'
                              )
                          )
                      AND b.eval_stat_cd <> 'CC'
                 ORDER BY a.item_no)
       LOOP
          vitemno := (vitemno  + 1);

          UPDATE gicl_replace
             SET item_no = 1
           WHERE eval_id = i.eval_id
             AND loss_exp_cd = i.loss_exp_cd
             AND item_no = i.item_no;
       END LOOP;*/
      FOR i IN (SELECT   a.item_no, a.eval_id, a.loss_exp_cd
                    FROM gicl_replace a
                   WHERE 1 = 1 AND a.eval_id = p_eval_id
                ORDER BY a.item_no)
      LOOP
         vitemno := (vitemno + 1);

         UPDATE gicl_replace
            SET item_no = vitemno
          WHERE eval_id = i.eval_id AND loss_exp_cd = i.loss_exp_cd;
      END LOOP;
   END;

   PROCEDURE delete_replace_dtl (p_replace_id gicl_replace.replace_id%TYPE)
   IS
   BEGIN
      DELETE FROM gicl_replace
            WHERE replace_id = p_replace_id;
   END;

   /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.11.2012
    **  Reference By  : GICLS070 - MC Evaluation Report
    **  Description   : Get list of companies for
    **                  MC Evaluation Deductibles
    */
   FUNCTION get_company_list_2 (p_eval_id IN gicl_mc_evaluation.eval_id%TYPE)
      RETURN payee_company_tab PIPELINED
   IS
      v_comp   payee_company_type;
   BEGIN
      FOR i IN (SELECT NVL (a.payt_payee_cd, a.payee_cd) payee_cd,
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
                   AND a.eval_id = p_eval_id)
      LOOP
         v_comp.payee_cd := i.payee_cd;
         v_comp.payee_type_cd := i.payee_type_cd;
         v_comp.dsp_company := i.payee_name;
         PIPE ROW (v_comp);
      END LOOP;
   END get_company_list_2;

   FUNCTION get_replace_payee_listing (
      p_eval_id   IN   gicl_mc_evaluation.eval_id%TYPE
   )
      RETURN replace_payee_listing_tab PIPELINED
   IS
      v_payee   replace_payee_listing_type;
   BEGIN
      FOR i IN (SELECT   a.eval_id, a.payee_type_cd, a.payee_cd,
                         a.payt_payee_type_cd, a.payt_payee_cd,
                         SUM (a.part_amt) payt_part_amt,
                            c.payee_last_name
                         || DECODE (c.payee_first_name,
                                    NULL, NULL,
                                    ',' || c.payee_first_name
                                   )
                         || DECODE (c.payee_middle_name,
                                    NULL, NULL,
                                    ' ' || c.payee_middle_name || '.'
                                   ) company_name
                    FROM gicl_replace a, giis_payees c
                   WHERE a.payee_type_cd = c.payee_class_cd
                     AND a.payee_cd = c.payee_no
                     AND eval_id = p_eval_id
                GROUP BY a.eval_id,
                         a.payee_type_cd,
                         a.payee_cd,
                         a.payt_payee_type_cd,
                         a.payt_payee_cd,
                            c.payee_last_name
                         || DECODE (c.payee_first_name,
                                    NULL, NULL,
                                    ',' || c.payee_first_name
                                   )
                         || DECODE (c.payee_middle_name,
                                    NULL, NULL,
                                    ' ' || c.payee_middle_name || '.'
                                   ))
      LOOP
         v_payee.eval_id := i.eval_id;
         v_payee.payt_payee_type_cd := i.payt_payee_type_cd;
         v_payee.payt_payee_cd := i.payt_payee_cd;
         v_payee.payee_type_cd := i.payee_type_cd;
         v_payee.payee_cd := i.payee_cd;
         v_payee.dsp_payee_type_cd := i.payee_type_cd;
         v_payee.dsp_payee_cd := i.payee_cd;
         v_payee.payt_part_amt := i.payt_part_amt;
         v_payee.dsp_company := i.company_name;

         IF v_payee.payt_payee_type_cd IS NOT NULL
         THEN
            v_payee.payt_imp_tag := 'Y';
         ELSE
            v_payee.payt_imp_tag := 'N';
         END IF;

         PIPE ROW (v_payee);
      END LOOP;
   END;

   PROCEDURE change_replace_payee (
      p_eval_id               gicl_replace.eval_id%TYPE,
      p_payt_pay_typ_cd_man   gicl_replace.payt_payee_type_cd%TYPE,
      p_payt_pay_cd_man       gicl_replace.payt_payee_cd%TYPE,
      p_payee_type_cd         gicl_replace.payt_payee_type_cd%TYPE,
      p_payee_cd              gicl_replace.payt_payee_cd%TYPE
   )
   IS
   BEGIN
      UPDATE gicl_replace
         SET payt_payee_type_cd = p_payt_pay_typ_cd_man,
             payt_payee_cd = p_payt_pay_cd_man
       WHERE eval_id = p_eval_id
         AND payee_type_cd = p_payee_type_cd
         AND payee_cd = p_payee_cd;
   END;

   PROCEDURE update_change_payee (
      p_eval_id                 gicl_replace.eval_id%TYPE,
      p_payt_pay_typ_cd_man     gicl_replace.payt_payee_type_cd%TYPE,
      p_payt_pay_cd_man         gicl_replace.payt_payee_cd%TYPE,
      prev_payt_payee_type_cd   gicl_replace.payt_payee_type_cd%TYPE,
      prev_payt_payee_cd        gicl_replace.payt_payee_cd%TYPE
   )
   IS
      v_payee          replace_payee_listing_type;
      v_ded_rate       gicl_eval_deductibles.ded_rt%TYPE;
      v_ded_base_amt   gicl_eval_deductibles.ded_base_amt%TYPE;
      x                NUMBER;
   BEGIN
      FOR i IN                                -- SELECT THE LAST RECORD FIRST
         (SELECT *
            FROM (SELECT   ROWNUM r_num, a.*
                      FROM TABLE
                              (gicl_replace_pkg.get_replace_payee_listing
                                                                    (p_eval_id)
                              ) a
                  ORDER BY 1 DESC)
           WHERE ROWNUM = 1)
      LOOP
         v_payee.eval_id := i.eval_id;
         v_payee.payt_payee_type_cd := i.payt_payee_type_cd;
         v_payee.payt_payee_cd := i.payt_payee_cd;
         v_payee.payee_type_cd := i.payee_type_cd;
         v_payee.payee_cd := i.payee_cd;
         v_payee.dsp_payee_type_cd := i.payee_type_cd;
         v_payee.dsp_payee_cd := i.payee_cd;
         v_payee.payt_part_amt := i.payt_part_amt;
      -- v_payee.dsp_company := i.company_name;
      END LOOP;

      -- inside v_tag in original procedure in forms
      FOR get_ded IN (SELECT   ded_cd, subline_cd, SUM (no_of_unit) unit,
                               SUM (ded_amt) tot_ded
                          FROM gicl_eval_deductibles a
                         WHERE eval_id = p_eval_id
                           AND (   (    payee_type_cd = p_payt_pay_typ_cd_man
                                    AND payee_cd = p_payt_pay_cd_man
                                   )
                                OR (EXISTS (
                                       SELECT 1
                                         FROM gicl_replace
                                        WHERE 1 = 1
                                          AND payee_type_cd = a.payee_type_cd
                                          AND payee_cd = a.payee_cd
                                          AND payt_payee_type_cd =
                                                         p_payt_pay_typ_cd_man
                                          AND payt_payee_cd =
                                                             p_payt_pay_cd_man
                                          AND eval_id = p_eval_id)
                                   )
                                OR (    payee_type_cd =
                                                       prev_payt_payee_type_cd
                                    --
                                    AND payee_cd = prev_payt_payee_cd
                                   )
                               )
                      GROUP BY ded_cd, subline_cd)
      LOOP
         FOR get_dtl IN
            (SELECT   ded_base_amt, ded_rt, ded_text
                 FROM gicl_eval_deductibles a
                WHERE eval_id = p_eval_id
                  AND (   (    payee_type_cd = p_payt_pay_typ_cd_man
                           AND payee_cd = p_payt_pay_cd_man
                          )
                       OR (EXISTS (
                              SELECT 1
                                FROM gicl_replace
                               WHERE 1 = 1
                                 AND payee_type_cd = a.payee_type_cd
                                 AND payee_cd = a.payee_cd
                                 AND payt_payee_type_cd =
                                                         p_payt_pay_typ_cd_man
                                 AND payt_payee_cd = p_payt_pay_cd_man
                                 AND eval_id = p_eval_id)
                          )
                       OR (    payee_type_cd = prev_payt_payee_type_cd
                           AND payee_cd = prev_payt_payee_cd
                          )
                      )
                  AND ded_cd = get_ded.ded_cd
                  AND NVL (subline_cd, '***') =
                                               NVL (get_ded.subline_cd, '***')
             ORDER BY ded_rt DESC)
         LOOP
            DELETE      gicl_eval_deductibles a
                  WHERE eval_id = p_eval_id
                    AND (   (    payee_type_cd = p_payt_pay_typ_cd_man
                             AND payee_cd = p_payt_pay_cd_man
                            )
                         OR (EXISTS (
                                SELECT 1
                                  FROM gicl_replace
                                 WHERE 1 = 1
                                   AND payee_type_cd = a.payee_type_cd
                                   AND payee_cd = a.payee_cd
                                   AND payt_payee_type_cd =
                                                         p_payt_pay_typ_cd_man
                                   AND payt_payee_cd = p_payt_pay_cd_man
                                   AND eval_id = p_eval_id)
                            )
                         OR (    payee_type_cd = prev_payt_payee_type_cd
                             AND payee_cd = prev_payt_payee_cd
                            )
                        )
                    AND ded_cd = get_ded.ded_cd
                    AND NVL (subline_cd, '***') =
                                               NVL (get_ded.subline_cd, '***');

            IF NVL (get_dtl.ded_rt, 0) > 0
            THEN
               v_ded_base_amt := get_dtl.ded_base_amt;
               v_ded_rate :=
                      (get_ded.tot_ded / get_ded.unit) / v_ded_base_amt * 100;
            ELSE
               v_ded_base_amt := (get_ded.tot_ded / get_ded.unit);
               v_ded_rate := 0;
            END IF;

            INSERT INTO gicl_eval_deductibles
                        (eval_id, ded_cd, subline_cd,
                         no_of_unit, ded_base_amt, ded_amt,
                         ded_rt, ded_text,
                         payee_type_cd, payee_cd
                        )
                 VALUES (p_eval_id, get_ded.ded_cd, get_ded.subline_cd,
                         get_ded.unit, v_ded_base_amt, get_ded.tot_ded,
                         v_ded_rate, get_dtl.ded_text,
                         v_payee.dsp_payee_type_cd, v_payee.dsp_payee_cd
                        );

            --END IF;
            EXIT;
         END LOOP;
      END LOOP;

      FOR dep IN (SELECT payee_type_cd, payee_cd
                    FROM gicl_eval_dep_dtl a
                   WHERE     eval_id = p_eval_id
                         AND (EXISTS (
                                 SELECT 1
                                   FROM gicl_replace
                                  WHERE eval_id = p_eval_id
                                    AND payee_type_cd = a.payee_type_cd
                                    AND payee_cd = a.payee_cd
                                    AND payt_payee_type_cd =
                                                         p_payt_pay_typ_cd_man
                                    AND payt_payee_cd = p_payt_pay_cd_man)
                             )
                      OR (    payee_type_cd = prev_payt_payee_type_cd
                          AND payee_cd = prev_payt_payee_cd
                         ))
      LOOP
         BEGIN
            SELECT 1
              INTO x
              FROM gicl_repair_hdr
             WHERE eval_id = p_eval_id
               AND payee_type_cd = dep.payee_type_cd
               AND payee_cd = dep.payee_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               BEGIN
                  SELECT 1
                    INTO x
                    FROM gicl_replace
                   WHERE eval_id = p_eval_id
                     AND payt_payee_type_cd IS NULL
                     AND payt_payee_cd IS NULL
                     AND payee_type_cd = p_payt_pay_typ_cd_man
                     AND payee_cd = p_payt_pay_cd_man;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     UPDATE gicl_eval_dep_dtl
                        SET payee_type_cd = p_payt_pay_typ_cd_man,
                            payee_cd = p_payt_pay_cd_man
                      WHERE eval_id = p_eval_id;

                     EXIT;
               END;
         END;
      END LOOP;
   END;
END;
/


