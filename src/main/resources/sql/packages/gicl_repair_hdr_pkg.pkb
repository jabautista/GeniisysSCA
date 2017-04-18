CREATE OR REPLACE PACKAGE BODY CPI.gicl_repair_hdr_pkg
AS
   FUNCTION get_repair_dtl (p_eval_id gicl_repair_hdr.eval_id%TYPE)
      RETURN repair_dtl_tab PIPELINED
   IS
      v_rep_dtl   repair_dtl_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_repair_hdr
                 WHERE eval_id = p_eval_id)
      LOOP
         v_rep_dtl.eval_id := i.eval_id;
         v_rep_dtl.payee_type_cd := i.payee_type_cd;
         v_rep_dtl.payee_cd := i.payee_cd;
         v_rep_dtl.lps_repair_amt := i.lps_repair_amt;
         v_rep_dtl.actual_total_amt := i.actual_total_amt;
         v_rep_dtl.actual_tinsmith_amt := i.actual_tinsmith_amt;
         v_rep_dtl.actual_painting_amt := i.actual_painting_amt;
         v_rep_dtl.other_labor_amt := i.other_labor_amt;
         v_rep_dtl.with_vat := i.with_vat;
         v_rep_dtl.user_id := i.user_id;
         v_rep_dtl.last_update := i.last_update;
         v_rep_dtl.update_sw := i.update_sw;

         /*company type*/
         BEGIN
            SELECT class_desc
              INTO v_rep_dtl.dsp_company_type
              FROM giis_payee_class
             WHERE payee_class_cd = i.payee_type_cd;

            v_rep_dtl.dsp_labor_com_type := v_rep_dtl.dsp_company_type;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_rep_dtl.dsp_company_type := '';
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
              INTO v_rep_dtl.dsp_company
              FROM giis_payees c
             WHERE c.payee_class_cd = i.payee_type_cd
               AND c.payee_no = i.payee_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rep_dtl.dsp_company := '';
            WHEN TOO_MANY_ROWS
            THEN
               v_rep_dtl.dsp_company := '';
         END;

         BEGIN
            SELECT SUM (amount)
              INTO v_rep_dtl.dsp_total_t
              FROM gicl_repair_lps_dtl a
             WHERE a.eval_id = p_eval_id AND repair_cd = 'T';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rep_dtl.dsp_total_t := NULL;
         END;

         BEGIN
            SELECT SUM (amount)
              INTO v_rep_dtl.dsp_total_p
              FROM gicl_repair_lps_dtl a
             WHERE a.eval_id = p_eval_id AND repair_cd = 'P';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rep_dtl.dsp_total_p := NULL;
         END;

         v_rep_dtl.dsp_labor_company := v_rep_dtl.dsp_company;
         v_rep_dtl.dsp_total_labor :=
              NVL (v_rep_dtl.other_labor_amt, 0)
            + NVL (v_rep_dtl.actual_total_amt, 0);
         PIPE ROW (v_rep_dtl);
      END LOOP;
   END;

   FUNCTION validate_before_save (
      p_eval_master_id     IN   gicl_mc_evaluation.eval_id%TYPE,
      p_eval_id                 gicl_mc_evaluation.eval_id%TYPE,
      p_actual_total_amt        gicl_repair_hdr.actual_total_amt%TYPE,
      p_payee_type_cd           gicl_repair_hdr.payee_type_cd%TYPE,
      p_payee_cd                gicl_repair_hdr.payee_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      vreptype                 gicl_mc_evaluation.report_type%TYPE;
      v_payee_type_old         gicl_repair_hdr.payee_type_cd%TYPE;
      v_payee_old              gicl_repair_hdr.payee_cd%TYPE;
      v_actual_total_amt_old   gicl_repair_hdr.other_labor_amt%TYPE;
      v_vat_exist              VARCHAR2 (1)                           := 'N';
      v_old_vat                gicl_eval_vat.vat_amt%TYPE             := 0;
      res                      VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT report_type
           INTO vreptype
           FROM gicl_mc_evaluation
          WHERE eval_id = p_eval_master_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            vreptype := '**';
      END;

      /* GET OLD DATA */
      FOR get_old IN (SELECT payee_type_cd, payee_cd, actual_total_amt
                        FROM gicl_repair_hdr
                       WHERE eval_id = p_eval_id)
      LOOP
         v_payee_type_old := get_old.payee_type_cd;
         v_payee_old := get_old.payee_cd;
         v_actual_total_amt_old := get_old.actual_total_amt;
      END LOOP;

      /* CHK VAT*/
      FOR exist IN (SELECT apply_to, vat_amt
                      FROM gicl_eval_vat
                     WHERE eval_id = p_eval_id
                       AND payee_type_cd = v_payee_type_old
                       AND payee_cd = v_payee_old)
      LOOP
         IF exist.apply_to = 'L'
         THEN
            v_vat_exist := 'Y';
            v_old_vat := exist.vat_amt;
         END IF;
      END LOOP;

      IF     v_vat_exist = 'Y'
         AND (   v_actual_total_amt_old <> p_actual_total_amt
              OR (   p_payee_type_cd <> v_payee_type_old
                  OR p_payee_cd = v_payee_old
                 )
             )
      THEN
         res := 'Y';
      ELSE
         res := 'N';
      END IF;

      RETURN res;
   END;

   PROCEDURE save_gicl_repair_hdr (
      p_eval_id               gicl_repair_hdr.eval_id%TYPE,
      p_payee_type_cd         gicl_repair_hdr.payee_type_cd%TYPE,
      p_payee_cd              gicl_repair_hdr.payee_cd%TYPE,
      p_lps_repair_amt        gicl_repair_hdr.lps_repair_amt%TYPE,
      p_actual_total_amt      gicl_repair_hdr.actual_total_amt%TYPE,
      p_actual_tinsmith_amt   gicl_repair_hdr.actual_tinsmith_amt%TYPE,
      p_actual_painting_amt   gicl_repair_hdr.actual_painting_amt%TYPE,
      p_other_labor_amt       gicl_repair_hdr.other_labor_amt%TYPE,
      p_with_vat              gicl_repair_hdr.with_vat%TYPE
   )
   IS
   BEGIN
      MERGE INTO gicl_repair_hdr
         USING DUAL
         ON (eval_id = p_eval_id)
         WHEN MATCHED THEN
            UPDATE
               SET payee_type_cd = p_payee_type_cd, payee_cd = p_payee_cd,
                   lps_repair_amt = p_lps_repair_amt,
                   actual_total_amt = p_actual_total_amt,
                   actual_tinsmith_amt = p_actual_tinsmith_amt,
                   actual_painting_amt = p_actual_painting_amt,
                   other_labor_amt = p_other_labor_amt,
                   with_vat = p_with_vat
         WHEN NOT MATCHED THEN
            INSERT (eval_id, payee_type_cd, payee_cd, lps_repair_amt,
                    actual_total_amt, actual_tinsmith_amt,
                    actual_painting_amt, other_labor_amt, with_vat)
            VALUES (p_eval_id, p_payee_type_cd, p_payee_cd, p_lps_repair_amt,
                    p_actual_total_amt, p_actual_tinsmith_amt,
                    p_actual_painting_amt, p_other_labor_amt, p_with_vat);
   END;

   PROCEDURE update_gicl_repair_dtls (
      p_eval_id            gicl_repair_hdr.eval_id%TYPE,
      p_actual_total_amt   gicl_repair_hdr.actual_total_amt%TYPE,
      p_payee_type_cd      gicl_repair_hdr.payee_type_cd%TYPE,
      p_payee_cd           gicl_repair_hdr.payee_cd%TYPE,
      p_dsp_total_labor    gicl_repair_hdr.actual_total_amt%TYPE
   )
   IS
      v_payee_type_old         gicl_repair_hdr.payee_type_cd%TYPE;
      v_payee_old              gicl_repair_hdr.payee_cd%TYPE;
      v_actual_total_amt_old   gicl_repair_hdr.other_labor_amt%TYPE;
      v_old_vat                gicl_eval_vat.vat_amt%TYPE             := 0;
      v_vat_exist              VARCHAR2 (1)                           := 'N';
      v_ded_exist              VARCHAR2 (1)                           := 'N';
      v_dep_exist              VARCHAR2 (1)                           := 'N';
      vhdrupdate               NUMBER                                 := 0;
      v_cnt                    NUMBER                                 := 0;
      v_max                    NUMBER                                 := 0;
      v_null                   NUMBER                                 := 0;
      vitemno                  gicl_repair_other_dtl.item_no%TYPE;
   BEGIN
      /* GET OLD DATA */
      FOR get_old IN (SELECT payee_type_cd, payee_cd, actual_total_amt
                        FROM gicl_repair_hdr
                       WHERE eval_id = p_eval_id)
      LOOP
         v_payee_type_old := get_old.payee_type_cd;
         v_payee_old := get_old.payee_cd;
         v_actual_total_amt_old := get_old.actual_total_amt;
      END LOOP;

      /* CHK DEDUCTIBLES*/
      FOR exist IN (SELECT 1
                      FROM gicl_eval_deductibles
                     WHERE eval_id = p_eval_id
                       AND payee_type_cd = v_payee_type_old
                       AND payee_cd = v_payee_old)
      LOOP
         v_ded_exist := 'Y';
         EXIT;
      END LOOP;

      /* CHK DEPRECIATION*/
      FOR exist IN (SELECT 1
                      FROM gicl_eval_dep_dtl
                     WHERE eval_id = p_eval_id
                       AND payee_type_cd = v_payee_type_old
                       AND payee_cd = v_payee_old)
      LOOP
         v_dep_exist := 'Y';
         EXIT;
      END LOOP;

      /* CHK VAT*/
      FOR exist IN (SELECT apply_to, vat_amt
                      FROM gicl_eval_vat
                     WHERE eval_id = p_eval_id
                       AND payee_type_cd = v_payee_type_old
                       AND payee_cd = v_payee_old)
      LOOP
         IF exist.apply_to = 'L'
         THEN
            v_vat_exist := 'Y';
            v_old_vat := exist.vat_amt;
         END IF;
      END LOOP;

      -- updates lps_repair_amt of main repair_hdr
      FOR i IN (SELECT NVL (SUM (amount), 0) a
                  FROM gicl_repair_lps_dtl
                 WHERE eval_id = p_eval_id)
      LOOP
         UPDATE gicl_repair_hdr
            SET lps_repair_amt = i.a
          WHERE eval_id = p_eval_id;
      END LOOP;

      /* conditions added to update the update_sw of gicl_repair_hdr */
      FOR x IN (SELECT 1
                  FROM gicl_repair_other_dtl
                 WHERE eval_id = p_eval_id AND update_sw = 'Y')
      LOOP
         vhdrupdate := vhdrupdate + 1;
         EXIT;
      END LOOP;

      FOR x IN (SELECT 1
                  FROM gicl_repair_lps_dtl
                 WHERE eval_id = p_eval_id AND update_sw = 'Y')
      LOOP
         vhdrupdate := vhdrupdate + 1;
         EXIT;
      END LOOP;

      IF vhdrupdate = 0
      THEN
         UPDATE gicl_repair_hdr
            SET update_sw = 'N'
          WHERE eval_id = p_eval_id;
      ELSIF vhdrupdate > 0
      THEN
         UPDATE gicl_repair_hdr
            SET update_sw = 'Y'
          WHERE eval_id = p_eval_id;
      END IF;

      /*DELETE VAT RECORD */
      IF     v_vat_exist = 'Y'
         AND (   v_actual_total_amt_old <> p_actual_total_amt
              OR (   p_payee_type_cd <> v_payee_type_old
                  OR p_payee_cd = v_payee_old
                 )
             )
      THEN
         DELETE      gicl_eval_vat
               WHERE eval_id = p_eval_id
                 AND payee_type_cd = v_payee_type_old
                 AND payee_cd = v_payee_old
                 AND apply_to = 'L';
      END IF;

      /* FOR CHANGE IN PAYEE UPDATE DEPRECIATION AND DEDUCTIBLES PAYEE */
      IF v_dep_exist = 'Y'
      THEN
         IF p_payee_type_cd IS NOT NULL
         THEN
            UPDATE gicl_eval_dep_dtl
               SET payee_type_cd = p_payee_type_cd,
                   payee_cd = p_payee_cd
             WHERE eval_id = p_eval_id
               AND payee_type_cd = v_payee_type_old
               AND payee_cd = v_payee_old;
         ELSE
            DELETE      gicl_eval_dep_dtl
                  WHERE eval_id = p_eval_id;
         END IF;
      END IF;

      IF v_ded_exist = 'Y'
      THEN
         IF p_payee_type_cd IS NOT NULL
         THEN
            UPDATE gicl_eval_deductibles
               SET payee_type_cd = p_payee_type_cd,
                   payee_cd = p_payee_cd
             WHERE eval_id = p_eval_id
               AND payee_type_cd = v_payee_type_old
               AND payee_cd = v_payee_old;
         ELSE
            DELETE      gicl_eval_deductibles
                  WHERE eval_id = p_eval_id;
         END IF;
      END IF;

      UPDATE gicl_mc_evaluation
         SET repair_amt = p_dsp_total_labor,
             vat = vat - v_old_vat
       WHERE eval_id = p_eval_id;

      /** added to place udate_sw to gicl_repair_hdr */
      FOR pk IN (SELECT 1
                   FROM gicl_repair_hdr
                  WHERE update_sw IS NULL AND eval_id = p_eval_id)
      LOOP
         UPDATE gicl_repair_hdr
            SET update_sw = 'N'
          WHERE eval_id = p_eval_id;

         EXIT;
      END LOOP;

      -- updates the item_no
      SELECT COUNT (DISTINCT NVL (a.loss_exp_cd, 0)), MAX (NVL (a.item_no, 0))
        INTO v_cnt, v_max
        FROM gicl_repair_lps_dtl a, gicl_mc_evaluation b
       WHERE 1 = 1
         AND a.eval_id = b.eval_id
         AND b.eval_stat_cd <> 'CC'
         AND (   a.eval_id = p_eval_id
              OR (b.eval_master_id = p_eval_id AND b.report_type = 'AD')
             );                                       --4.0 petermkaw 03122010

      FOR i IN
         (SELECT DISTINCT DECODE (a.item_no, NULL, 1, 2) vnull
                     FROM gicl_repair_lps_dtl a, gicl_mc_evaluation b
                    WHERE 1 = 1
                      AND a.eval_id = b.eval_id
                      AND b.eval_stat_cd <> 'CC'
                      AND (   a.eval_id = p_eval_id
                           OR (    b.eval_master_id = p_eval_id
                               AND b.report_type = 'AD'
                              )
                          ))                          --4.0 petermkaw 03122010
      LOOP
         IF i.vnull = 1
         THEN
            v_null := 1;
         END IF;
      END LOOP;

      vitemno := 0;

      IF NVL (v_cnt, 0) <> NVL (v_max, 0) OR v_null = 1
      THEN
         FOR x IN (SELECT DISTINCT a.item_no, a.loss_exp_cd
                              FROM gicl_repair_lps_dtl a,
                                   gicl_mc_evaluation b
                             WHERE 1 = 1
                               AND a.eval_id = b.eval_id
                               AND b.eval_stat_cd <> 'CC'
                               AND (   a.eval_id = p_eval_id
                                    OR (    b.eval_master_id = p_eval_id
                                        AND b.report_type = 'AD'
                                       )
                                   )                  --4.0 petermkaw 03122010
                          ORDER BY a.item_no)
         LOOP
            vitemno := vitemno + 1;

            UPDATE gicl_repair_lps_dtl
               SET item_no = vitemno
             WHERE eval_id = p_eval_id AND loss_exp_cd = x.loss_exp_cd;
         --:gicl_repair_lps_dtl_ctrl.item_no := vItemNo;
         END LOOP;
      END IF;
   END;
END;
/


