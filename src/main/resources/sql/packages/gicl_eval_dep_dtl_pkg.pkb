CREATE OR REPLACE PACKAGE BODY CPI.gicl_eval_dep_dtl_pkg
AS
   FUNCTION get_eval_dep_listing (p_eval_id gicl_mc_evaluation.eval_id%TYPE)
      RETURN gicls070_dep_tab PIPELINED
   IS
      v_dep   gicls070_dep_type;
   BEGIN
      FOR i IN (SELECT   a.part_type, a.loss_exp_cd, a.payee_type_cd,
                         a.payee_cd, a.item_no
                    FROM gicl_replace a
                   WHERE part_type = 'O' AND eval_id = p_eval_id 
                ORDER BY item_no)
      LOOP
         v_dep.part_type := i.part_type;
         v_dep.loss_exp_cd := i.loss_exp_cd;
         v_dep.payee_type_cd := i.payee_type_cd;
         v_dep.payee_cd := i.payee_cd;
         v_dep.item_no := i.item_no;
         v_dep.eval_id := p_eval_id;

         --get desc for part and labor--
         BEGIN
            SELECT loss_exp_desc
              INTO v_dep.part_desc
              FROM giis_loss_exp
             WHERE 1 = 1
               AND loss_exp_cd = v_dep.loss_exp_cd
               AND line_cd = 'MC'
               AND loss_exp_type = 'L'
               AND comp_sw = '+'
               AND NVL (part_sw, 'N') = 'Y';
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_dep.part_desc := '';
         END;

         --get rate, dep amt, and part amt
         BEGIN
            SELECT ded_rt, ded_amt, b.part_amt
              INTO v_dep.ded_rt, v_dep.ded_amt, v_dep.part_amt
              FROM gicl_eval_dep_dtl a, gicl_replace b
             WHERE a.eval_id = p_eval_id
               AND a.loss_exp_cd = v_dep.loss_exp_cd
               AND a.eval_id = b.eval_id
               AND a.item_no = b.item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_dep.ded_rt := NULL;
               v_dep.ded_amt := NULL;
               v_dep.part_amt := NULL;
         END;

         IF NVL (v_dep.part_amt, 0) = 0
         THEN
            FOR get_part IN (SELECT a.part_amt
--                                    DECODE (a.with_vat,
--                                            'Y', a.part_amt,
--                                              a.part_amt
--                                            + (  a.part_amt
--                                               * NVL (b.vat_rate / 100, 0)
--                                              )
--                                           )     -- 12.18.2013 ruben
                                     part_amt
                               FROM gicl_replace a, gicl_eval_vat b
                              WHERE a.eval_id = b.eval_id(+)
                                AND a.payee_type_cd = b.payee_type_cd(+)
                                AND a.payee_cd = b.payee_cd(+)
                                AND a.eval_id = b.eval_id(+)
                                AND a.eval_id = p_eval_id
                                AND a.loss_exp_cd = v_dep.loss_exp_cd)
            LOOP
               v_dep.part_amt := get_part.part_amt;
            END LOOP;
         END IF;

         PIPE ROW (v_dep);
      END LOOP;
   END;

   FUNCTION get_dep_payee_dtls (p_eval_id gicl_mc_evaluation.eval_id%TYPE)
      RETURN payee_dtl_tab PIPELINED
   IS
      v_payee   payee_dtl_type;
   BEGIN
      FOR i IN (SELECT DISTINCT payee_type_cd, payee_cd, eval_id
                           FROM gicl_eval_dep_dtl
                          WHERE eval_id = p_eval_id)
      LOOP
         v_payee.payee_type_cd := i.payee_type_cd;
         v_payee.payee_cd := i.payee_cd;
         v_payee.eval_id := i.eval_id;

         /*company type*/
         BEGIN
            SELECT class_desc
              INTO v_payee.dsp_company_type
              FROM giis_payee_class
             WHERE payee_class_cd = i.payee_type_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_payee.dsp_company_type := '';
         END;

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
              INTO v_payee.dsp_company
              FROM giis_payees c
             WHERE c.payee_class_cd = i.payee_type_cd
               AND c.payee_no = i.payee_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_payee.dsp_company := '';
            WHEN TOO_MANY_ROWS
            THEN
               v_payee.dsp_company := '';
         END;

         BEGIN
            SELECT SUM (ded_amt)
              INTO v_payee.total_amount
              FROM gicl_eval_dep_dtl
             WHERE eval_id = p_eval_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_payee.total_amount := NULL;
         END;

         PIPE ROW (v_payee);
      END LOOP;
   END;

   FUNCTION get_initial_dep_payee_dtls (
      p_eval_id   gicl_mc_evaluation.eval_id%TYPE
   )
      RETURN payee_dtl_tab PIPELINED
   IS
      v_payee   payee_dtl_type;
   BEGIN
      FOR i IN (SELECT DISTINCT payee_type_cd, payee_cd
                           FROM gicl_repair_hdr
                          WHERE eval_id = p_eval_id AND ROWNUM = 1)
      LOOP
         v_payee.payee_type_cd := i.payee_type_cd;
         v_payee.payee_cd := i.payee_cd;

         /*company type*/
         BEGIN
            SELECT class_desc
              INTO v_payee.dsp_company_type
              FROM giis_payee_class
             WHERE payee_class_cd = i.payee_type_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_payee.dsp_company_type := '';
         END;

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
              INTO v_payee.dsp_company
              FROM giis_payees c
             WHERE c.payee_class_cd = i.payee_type_cd
               AND c.payee_no = i.payee_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_payee.dsp_company := '';
            WHEN TOO_MANY_ROWS
            THEN
               v_payee.dsp_company := '';
         END;

         BEGIN
            SELECT SUM (ded_amt)
              INTO v_payee.total_amount
              FROM gicl_eval_dep_dtl
             WHERE eval_id = p_eval_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_payee.total_amount := NULL;
         END;

         PIPE ROW (v_payee);
      END LOOP;
   END;

   FUNCTION get_dep_com_type_lov (
      p_eval_id     gicl_mc_evaluation.eval_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN dep_com_type_tab PIPELINED
   IS
      v_com   dep_com_type_type;
   BEGIN
      FOR i IN
         (SELECT *
            FROM (SELECT DISTINCT NVL (a.payt_payee_type_cd,
                                       a.payee_type_cd
                                      ) payee_type_cd,
                                  b.class_desc
                             FROM gicl_replace a, giis_payee_class b
                            WHERE 1 = 1
                              AND a.eval_id = p_eval_id
                              AND NVL (a.payt_payee_type_cd, a.payee_type_cd) =
                                                              b.payee_class_cd
                  UNION
                  SELECT a.payee_type_cd, b.class_desc
                    FROM gicl_repair_hdr a, giis_payee_class b
                   WHERE 1 = 1
                     AND eval_id = p_eval_id
                     AND a.payee_type_cd = b.payee_class_cd)
           WHERE UPPER (class_desc) LIKE NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_com.payee_type_cd := i.payee_type_cd;
         v_com.dsp_company_type := i.class_desc;
         PIPE ROW (v_com);
      END LOOP;
   END;

   FUNCTION get_dep_com_lov (
      p_eval_id     gicl_mc_evaluation.eval_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN dep_com_tab PIPELINED
   IS
      v_com   dep_com_type;
   BEGIN
      FOR i IN (SELECT *
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
                 WHERE UPPER (payee_name) LIKE NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_com.payee_cd := i.payee_cd;
         v_com.dsp_company := i.payee_name;
         PIPE ROW (v_com);
      END LOOP;
   END;

   PROCEDURE check_dep_vat (
      p_eval_id             gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd         gicl_eval_dep_dtl.loss_exp_cd%TYPE,
      payee_cd        OUT   gicl_eval_dep_dtl.payee_cd%TYPE,
      payee_type_cd   OUT   gicl_eval_dep_dtl.payee_type_cd%TYPE,
      vat_exist       OUT   VARCHAR2
   )
   IS
   BEGIN
      BEGIN
         SELECT b.payee_type_cd, b.payee_cd
           INTO payee_type_cd, payee_cd
           FROM gicl_eval_vat a, gicl_replace b
          WHERE a.eval_id = p_eval_id
            AND a.eval_id = b.eval_id
            AND a.payee_type_cd = b.payee_type_cd
            AND a.payee_cd = b.payee_cd
            AND b.loss_exp_cd = p_loss_exp_cd
            AND NVL (a.net_tag, 'N') = 'Y';

         vat_exist := 'Y';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            vat_exist := 'N';
      END;
   END;

   PROCEDURE delete_eval_dep (
      p_eval_id       gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd   gicl_eval_dep_dtl.loss_exp_cd%TYPE
   )
   IS
   BEGIN
      DELETE      gicl_eval_dep_dtl
            WHERE eval_id = p_eval_id AND loss_exp_cd = p_loss_exp_cd;
   END;

   PROCEDURE set_eval_dep (
      p_eval_id         gicl_mc_evaluation.eval_id%TYPE,
      p_ded_amt         gicl_eval_dep_dtl.ded_amt%TYPE,
      p_ded_rt          gicl_eval_dep_dtl.ded_rt%TYPE,
      p_payee_type_cd   gicl_eval_dep_dtl.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_dep_dtl.payee_cd%TYPE,
      p_item_no         gicl_eval_dep_dtl.item_no%TYPE,
      p_loss_exp_cd     gicl_eval_dep_dtl.loss_exp_cd%TYPE
   )
   IS
   BEGIN
      INSERT INTO gicl_eval_dep_dtl
                  (eval_id, ded_amt, ded_rt, loss_exp_cd,
                   payee_type_cd, payee_cd, item_no
                  )
           VALUES (p_eval_id, p_ded_amt, p_ded_rt, p_loss_exp_cd,
                   p_payee_type_cd, p_payee_cd, p_item_no
                  );
   END;

   FUNCTION apply_depreciation (
      p_eval_id             gicl_mc_evaluation.eval_id%TYPE,
      p_clm_subline_cd      gicl_mc_evaluation.subline_cd%TYPE,
      p_pol_subline_cd      gicl_mc_evaluation.subline_cd%TYPE,
      p_claim_id            gicl_mc_evaluation.claim_id%TYPE,
      p_item_no             gicl_mc_evaluation.item_no%TYPE,
      p_payee_no            gicl_mc_evaluation.payee_no%TYPE,
      p_payee_class_cd      gicl_mc_evaluation.payee_class_cd%TYPE,
      p_tp_sw               gicl_mc_evaluation.tp_sw%TYPE,
      user_id               gicl_mc_evaluation.user_id%type,
      main_eval_vat_exist   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      MESSAGE           VARCHAR2 (100);
      payeetypecd       gicl_replace.payee_type_cd%TYPE;
      payeecd           gicl_replace.payee_cd%TYPE;
      v_pasokflag       BOOLEAN                                := FALSE;
      v_itemage         gicl_motor_car_dtl.model_year%TYPE;
      --age of vehicle based on model year
      v_max_fix_age     gicl_mc_depreciation.mc_year_fr%TYPE;
      --max age for all part
      v_max_fix_rate    gicl_mc_depreciation.rate%TYPE;
      --rate of dep of max age for all part
      v_max_spec_rate   gicl_mc_depreciation.rate%TYPE;
      --rate of dep per part (for max age)
      v_max_spec_age    gicl_mc_depreciation.mc_year_fr%TYPE;   --i dunno yet
      v_fix_rate        gicl_mc_depreciation.rate%TYPE;
      --rate of dep for all part
      v_spec_rate       gicl_mc_depreciation.rate%TYPE;
      --rate of dep per part
      v_ded_cd          gicl_eval_deductibles.ded_cd%TYPE;
      --ded_cd of depreciation
      v_runtot          gicl_mc_evaluation.depreciation%TYPE   := 0;
      x                 NUMBER;
      
   --sum of depreciation
   BEGIN
   giis_users_pkg.app_user := user_id;
      IF main_eval_vat_exist = 'Y'
      THEN
         DELETE      gicl_eval_vat
               WHERE apply_to = 'P' AND eval_id = p_eval_id;
      END IF;

      BEGIN
         SELECT   mc_year_fr, rate
             INTO v_max_fix_age, v_max_fix_rate
             FROM gicl_mc_depreciation
            WHERE subline_cd = p_pol_subline_cd
              AND special_part_cd IS NULL
              AND ROWNUM = 1
         ORDER BY mc_year_fr DESC;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      --age of vehicle
      IF p_tp_sw = 'Y'
      THEN
         BEGIN
            SELECT (  TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'))
                    - TO_NUMBER (model_year)
                   ) vehicle_age
              INTO v_itemage
              FROM gicl_mc_tp_dtl
             WHERE claim_id = p_claim_id
               AND item_no = p_item_no
               AND payee_no = p_payee_no
               AND payee_class_cd = p_payee_class_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;
      ELSE
         BEGIN
            SELECT (  TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'))
                    - TO_NUMBER (model_year)
                   ) vehicle_age
              INTO v_itemage
              FROM gicl_motor_car_dtl
             WHERE claim_id = p_claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;
      END IF;

      IF v_itemage IS NULL
      THEN
         MESSAGE :=
                 'Depreciation cannot be computed if item model year is null.';
         RETURN MESSAGE;
      END IF;

      IF v_itemage <= v_max_fix_age
      THEN
         --retrieve dep rate for all parts
         BEGIN
            SELECT   rate
                INTO v_fix_rate
                FROM gicl_mc_depreciation
               WHERE subline_cd = p_clm_subline_cd
                 AND mc_year_fr >= v_itemage
                 AND special_part_cd IS NULL
                 AND ROWNUM = 1
            ORDER BY mc_year_fr ASC;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      ELSE
         v_fix_rate := v_max_fix_rate;
      END IF;
      
       --replace parts
   FOR i IN (SELECT loss_exp_cd, part_amt          --, payee_type_cd, payee_cd
               FROM gicl_replace
              WHERE eval_id = p_eval_id AND part_type = 'O')
   LOOP
      BEGIN
         SELECT payee_type_cd, payee_cd
           INTO payeetypecd, payeecd
           FROM gicl_repair_hdr
          WHERE eval_id = p_eval_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      --refresh variables:
      v_max_spec_age := NULL;
      v_max_spec_rate := NULL;

      IF NVL (v_max_spec_age, 0) <= v_itemage
      THEN
         --check if part has a special rate
         v_spec_rate := NULL;

         BEGIN
            SELECT   rate
                INTO v_spec_rate
                FROM gicl_mc_depreciation
               WHERE subline_cd = p_pol_subline_cd
                 AND mc_year_fr <= v_itemage
                 AND special_part_cd = i.loss_exp_cd
            ORDER BY mc_year_fr ASC;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               null;
         END;
      ELSIF v_max_spec_age IS NOT NULL
      THEN
        -- msg_alert ('himala', 'I', FALSE); -- not sure anong error dapat ng message dito - irwin
        raise_application_error('-20001','SQL Exception occured.');
      END IF;

 
      IF NVL (v_spec_rate, NVL (v_fix_rate, 0)) > 0
      THEN
         BEGIN
            SELECT 1
              INTO x
              FROM gicl_eval_dep_dtl
             WHERE eval_id = p_eval_id
               AND loss_exp_cd = i.loss_exp_cd;

            UPDATE gicl_eval_dep_dtl
               SET ded_amt = i.part_amt * (v_spec_rate / 100),
                   ded_rt = v_spec_rate
             WHERE eval_id = p_eval_id
               AND loss_exp_cd = i.loss_exp_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               INSERT INTO gicl_eval_dep_dtl
                           (eval_id,
                            ded_amt, ded_rt,
                            loss_exp_cd, payee_type_cd, payee_cd
                           )
                    VALUES (p_eval_id,
                            i.part_amt * (v_spec_rate / 100), v_spec_rate,
                            i.loss_exp_cd, payeetypecd, payeecd
                           );
         END;
      ELSE
         message:= 'There''s no available depreciation rate for the parts tagged as original';
		 return message;
      END IF;

      v_runtot := i.part_amt * (v_spec_rate / 100) + v_runtot;
   END LOOP;
  if MESSAGE = '' then
      BEGIN
         UPDATE gicl_mc_evaluation
            SET depreciation = v_runtot
          WHERE eval_id = p_eval_id;
      END;
      end if;
    message := 'SUCCESS';
    return message;
   END;
END;
/


