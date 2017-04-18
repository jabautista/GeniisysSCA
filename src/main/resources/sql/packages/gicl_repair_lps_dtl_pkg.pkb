CREATE OR REPLACE PACKAGE BODY CPI.gicl_repair_lps_dtl_pkg
AS
   FUNCTION get_repair_lps_dtl_list (
      p_eval_id   gicl_repair_lps_dtl.eval_id%TYPE
   )
      RETURN gicl_repair_lps_dtl_tab PIPELINED
   IS
      v_lps   gicl_repair_lps_dtl_type;
   BEGIN
      FOR i IN (SELECT   eval_id, loss_exp_cd, tinsmith_type, item_no,
                         update_sw,
                         (SELECT amount
                            FROM gicl_repair_lps_dtl a
                           WHERE a.eval_id = b.eval_id
                             AND a.loss_exp_cd = b.loss_exp_cd
                             AND repair_cd = 'T') tinsmith_amount,
                         (SELECT amount
                            FROM gicl_repair_lps_dtl a
                           WHERE a.eval_id = b.eval_id
                             AND a.loss_exp_cd = b.loss_exp_cd
                             AND repair_cd = 'P') paintings_amount,
                         (SELECT DECODE (repair_cd,
                                         'P', 'Y'
                                        )
                            FROM gicl_repair_lps_dtl a
                           WHERE a.eval_id = b.eval_id
                             AND a.loss_exp_cd = b.loss_exp_cd
                             AND repair_cd = 'P') paintings_repair_cd,
                         (SELECT DECODE (repair_cd,
                                         'T', 'Y'
                                        )
                            FROM gicl_repair_lps_dtl a
                           WHERE a.eval_id = b.eval_id
                             AND a.loss_exp_cd = b.loss_exp_cd
                             AND repair_cd = 'T') tinsmith_repair_cd,
                         DECODE (b.tinsmith_type,
                                 'L', 'Light',
                                 'M', 'Medium',
                                 'H', 'Heavy',
                                 NULL, ''
                                ) tinsmith_type_desc
                    FROM gicl_repair_lps_dtl b
                   WHERE eval_id = p_eval_id
                GROUP BY loss_exp_cd,
                         eval_id,
                         tinsmith_type,
                         item_no,
                         update_sw
                ORDER BY item_no)
      LOOP
         v_lps.eval_id := i.eval_id;
         v_lps.loss_exp_cd := i.loss_exp_cd;
         v_lps.tinsmith_type := i.tinsmith_type;
         v_lps.item_no := i.item_no;
         v_lps.update_sw := i.update_sw;
         v_lps.paintings_repair_cd := i.paintings_repair_cd;        -- custom
         v_lps.tinsmith_repair_cd := i.tinsmith_repair_cd;          -- custom
         v_lps.paintings_amount := i.paintings_amount;
         v_lps.tinsmith_amount := i.tinsmith_amount;
         v_lps.tinsmith_type_desc := i.tinsmith_type_desc;

         BEGIN
            SELECT loss_exp_desc
              INTO v_lps.dsp_loss_desc
              FROM giis_loss_exp
             WHERE line_cd = 'MC'
               AND lps_sw = 'Y'
               AND comp_sw = '+'
               AND loss_exp_type = 'L'
               AND loss_exp_cd = i.loss_exp_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_lps.dsp_loss_desc := '';
         END;

         v_lps.total_amount :=
               NVL (v_lps.paintings_amount, 0)
               + NVL (v_lps.tinsmith_amount, 0);
         PIPE ROW (v_lps);
      END LOOP;
   END;

   FUNCTION get_vehicle_parts_list (
      p_eval_id     gicl_repair_lps_dtl.eval_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN vehicle_parts_tab PIPELINED
   IS
      v_veh   vehicle_parts_type;
   BEGIN
      FOR i IN (SELECT   a.loss_exp_cd, a.loss_exp_desc
                    FROM giis_loss_exp a
                   WHERE line_cd = 'MC'
                     AND lps_sw = 'Y'
                     AND comp_sw = '+'
                     AND loss_exp_type = 'L'
                     AND NOT EXISTS (
                            SELECT 1
                              FROM gicl_repair_lps_dtl
                             WHERE eval_id = p_eval_id
                               AND loss_exp_cd = a.loss_exp_cd)
                               AND UPPER (a.loss_exp_desc) LIKE
                                               NVL (UPPER (p_find_text), '%%')
					and exists (select 1 from gicl_mc_lps  where loss_exp_cd = a.loss_exp_cd)                    
                           and not exists (select g.loss_exp_cd from gicl_mc_lps g where nvl(g.tinsmith_light,0) = 0 and nvl(g.tinsmith_medium,0) = 0 and nvl(g.tinsmith_heavy,0) = 0 and nvl(g.painting,0) = 0
                            and g.loss_exp_cd = a.loss_exp_cd)
                ORDER BY loss_exp_desc ASC)
      LOOP
         v_veh.loss_exp_cd := i.loss_exp_cd;
         v_veh.dsp_loss_desc := i.loss_exp_desc;
         PIPE ROW (v_veh);
      END LOOP;
   END;

   FUNCTION get_tinsmith_amount (
      p_tinsmith_type   gicl_repair_lps_dtl.tinsmith_type%TYPE,
      p_loss_exp_cd     gicl_repair_lps_dtl.loss_exp_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      amt   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT TO_CHAR (DECODE (p_tinsmith_type,
                                 'L', tinsmith_light,
                                 'M', tinsmith_medium,
                                 'H', tinsmith_heavy
                                ),
                         '9999.99'
                        )
           INTO amt
           FROM gicl_mc_lps
          WHERE loss_exp_cd = p_loss_exp_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            amt := '';
         WHEN TOO_MANY_ROWS
         THEN
            amt := '';
      END;

      RETURN amt;
   END;

   FUNCTION get_paintings_amount (
      p_loss_exp_cd   gicl_repair_lps_dtl.loss_exp_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      amt   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT TO_CHAR (painting, '9999.99')
           INTO amt
           FROM gicl_mc_lps
          WHERE loss_exp_cd = p_loss_exp_cd;

         IF amt IS NULL
         THEN
           amt := 'Painting has no amount.';
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            amt := '';
         WHEN TOO_MANY_ROWS
         THEN
            amt := '';
      END;

      RETURN amt;
   END;

   PROCEDURE save_gicl_repair_lps_dtl (
      p_eval_master_id       IN   gicl_mc_evaluation.eval_id%TYPE,
      p_eval_id                   gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd               gicl_repair_lps_dtl.loss_exp_cd%TYPE,
      p_amount                    gicl_repair_lps_dtl.amount%TYPE,
      p_tinsmith_type             gicl_repair_lps_dtl.tinsmith_type%TYPE,
      p_repair_cd                 gicl_repair_lps_dtl.repair_cd%TYPE,
      p_item_no                   gicl_repair_lps_dtl.item_no%TYPE,
      p_master_report_type        VARCHAR2
   )
   IS
      v_updatesw   gicl_repair_lps_dtl.update_sw%TYPE;
   BEGIN
       -- transactions
      -- DELETE      gicl_repair_lps_dtl               -- delete all record first
           --  WHERE eval_id = p_eval_id;
      v_updatesw := 'Y';

      IF p_repair_cd = 'T' AND p_amount IS NOT NULL
      THEN
         /* added condition that would acquire the value of update_sw depending if there is
               ** an older version of the report which is a revised report. for tinsmith amount only.
               */-- msg_alert(vreptype,'I', false); --for debugging purposes only
         IF p_master_report_type = 'RD'
         THEN
            v_updatesw := 'Y';

            FOR x IN (SELECT 1
                        FROM gicl_repair_lps_dtl
                       WHERE eval_id = p_eval_master_id
                         AND loss_exp_cd = p_loss_exp_cd
                         AND repair_cd = 'T'
                         AND tinsmith_type = p_tinsmith_type
                         AND amount = p_amount)
            LOOP
               v_updatesw := 'N';
               EXIT;
            END LOOP;
         ELSE
            v_updatesw := 'N';
         END IF;

         gicl_repair_lps_dtl_pkg.set_repair_lps_dtl (p_eval_id,
                                                     p_loss_exp_cd,
                                                     p_repair_cd,
                                                     p_tinsmith_type,
                                                     p_amount,
                                                     p_item_no,
                                                     v_updatesw
                                                    );
      END IF;

      IF p_repair_cd = 'P' AND p_amount IS NOT NULL
      THEN
         IF p_master_report_type = 'RD'
         THEN
            v_updatesw := 'Y';

            FOR y IN (SELECT 1
                        FROM gicl_repair_lps_dtl
                       WHERE eval_id = p_eval_master_id
                         AND loss_exp_cd = p_loss_exp_cd
                         AND repair_cd = 'P'
                         AND tinsmith_type = p_tinsmith_type
                         AND amount = p_amount)
            LOOP
               v_updatesw := 'N';
               EXIT;
            END LOOP;
         ELSE
            v_updatesw := 'N';
         END IF;

         gicl_repair_lps_dtl_pkg.set_repair_lps_dtl (p_eval_id,
                                                     p_loss_exp_cd,
                                                     p_repair_cd,
                                                     p_tinsmith_type,
                                                     p_amount,
                                                     p_item_no,
                                                     v_updatesw
                                                    );
      END IF;
   END;

   PROCEDURE set_repair_lps_dtl (
      p_eval_id         gicl_repair_lps_dtl.eval_id%TYPE,
      p_loss_exp_cd     gicl_repair_lps_dtl.loss_exp_cd%TYPE,
      p_repair_cd       gicl_repair_lps_dtl.repair_cd%TYPE,
      p_tinsmith_type   gicl_repair_lps_dtl.tinsmith_type%TYPE,
      p_amount          gicl_repair_lps_dtl.amount%TYPE,
      p_item_no         gicl_repair_lps_dtl.item_no%TYPE,
      p_update_sw       gicl_repair_lps_dtl.update_sw%TYPE
   )
   IS
   BEGIN
      BEGIN
         MERGE INTO gicl_repair_lps_dtl
            USING DUAL
            ON (    eval_id = p_eval_id
                AND repair_cd = p_repair_cd
                AND item_no = p_item_no)
            WHEN MATCHED THEN
               UPDATE
                  SET loss_exp_cd = p_loss_exp_cd,
                      tinsmith_type = p_tinsmith_type, amount = p_amount,
                      update_sw = p_update_sw
            WHEN NOT MATCHED THEN
               INSERT (eval_id, loss_exp_cd, repair_cd, tinsmith_type, amount,
                       item_no, update_sw)                               --2.0
               VALUES (p_eval_id, p_loss_exp_cd, p_repair_cd, p_tinsmith_type,
                       p_amount, p_item_no, p_update_sw);                --2.0
      END;
   END;

   PROCEDURE del_repair_lps_dtl (
      p_eval_id       gicl_repair_lps_dtl.eval_id%TYPE,
      p_loss_exp_cd   gicl_repair_lps_dtl.loss_exp_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_repair_lps_dtl
            WHERE eval_id = p_eval_id AND loss_exp_cd = p_loss_exp_cd;
   END;

   PROCEDURE del_by_rep_cd (
      p_eval_id       gicl_repair_lps_dtl.eval_id%TYPE,
      p_loss_exp_cd   gicl_repair_lps_dtl.loss_exp_cd%TYPE,
      p_repair_cd     gicl_repair_lps_dtl.repair_cd%TYPE,
      p_item_no       gicl_repair_lps_dtl.item_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_repair_lps_dtl
            WHERE eval_id = p_eval_id
              AND loss_exp_cd = p_loss_exp_cd
              AND repair_cd = p_repair_cd
              AND item_no = p_item_no;
   END;
END;
/


