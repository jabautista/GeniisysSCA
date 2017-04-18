CREATE OR REPLACE PACKAGE BODY CPI.gicl_repair_other_dtl_pkg
AS
   FUNCTION get_gicl_repair_other_dtl (
      p_eval_id   gicl_repair_other_dtl.eval_id%TYPE
   )
      RETURN gicl_repair_other_dtl_tab PIPELINED
   IS
      v_dtl   gicl_repair_other_dtl_type;
   BEGIN
      FOR i IN (SELECT a.eval_id, a.repair_cd,
                       (SELECT b.repair_desc
                          FROM gicl_repair_type b
                         WHERE b.repair_cd = a.repair_cd) repair_desc,
                       amount, item_no, update_sw
                  FROM gicl_repair_other_dtl a
                 WHERE a.eval_id = p_eval_id
                 order by item_no)
      LOOP
         v_dtl.eval_id := i.eval_id;
         v_dtl.repair_cd := i.repair_cd;
         v_dtl.amount := i.amount;
         v_dtl.update_sw := i.update_sw;
         v_dtl.item_no := i.item_no;
         v_dtl.repair_desc := i.repair_desc;
         PIPE ROW (v_dtl);
      END LOOP;
   END;

   PROCEDURE validate_before_save_other (
      p_eval_id                  gicl_repair_other_dtl.eval_id%TYPE,
      p_eval_master_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_payee_type_cd            gicl_repair_hdr.payee_type_cd%TYPE,
      p_payee_cd                 gicl_repair_hdr.payee_cd%TYPE,
      vat_exist            OUT   VARCHAR2,
      ded_exist            OUT   VARCHAR2,
      master_report_type   OUT   VARCHAR2
   )
   IS
   BEGIN
      BEGIN
         SELECT report_type
           INTO master_report_type
           FROM gicl_mc_evaluation
          WHERE eval_id = p_eval_master_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            master_report_type := '**';
      END;

      BEGIN
         SELECT 'Y'
           INTO vat_exist
           FROM gicl_eval_vat
          WHERE eval_id = p_eval_id
            AND payee_type_cd = p_payee_type_cd
--jen.07022006 added the ff condition so that it will only prompt user if the company already has vat
            AND payee_cd = p_payee_cd
            AND apply_to = 'L';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            vat_exist := 'N';
      END;

      BEGIN
         SELECT 'Y'
           INTO ded_exist
           FROM gicl_eval_deductibles
          WHERE eval_id = p_eval_id
            AND payee_type_cd = p_payee_type_cd
            AND payee_cd = p_payee_cd
            AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ded_exist := 'N';
      END;
   END;

   PROCEDURE delete_details_labor (
      p_eval_id         gicl_repair_other_dtl.eval_id%TYPE,
      p_payee_type_cd   gicl_repair_hdr.payee_type_cd%TYPE,
      p_payee_cd        gicl_repair_hdr.payee_cd%TYPE,
      p_vat_exist       VARCHAR2,
      p_ded_exist       VARCHAR2
   )
   IS
      summa   NUMBER;
   BEGIN
      -- delete taxes/ vat if existing
      IF p_vat_exist = 'Y'
      THEN
         BEGIN
            DELETE      gicl_eval_vat
                  WHERE eval_id = p_eval_id
                    AND payee_cd = p_payee_cd
                    AND payee_type_cd = p_payee_type_cd
                    AND apply_to = 'L';

            --vat amt
            SELECT NVL (SUM (vat_amt), 0)
              INTO summa
              FROM gicl_eval_vat
             WHERE eval_id = p_eval_id;

            UPDATE gicl_mc_evaluation
               SET vat = summa
             WHERE eval_id = p_eval_id;
         END;
      END IF;

      -- delete deductibles if existing
      IF p_ded_exist = 'Y'
      THEN
         BEGIN
            DELETE      gicl_eval_deductibles
                  WHERE eval_id = p_eval_id
                    AND payee_cd = p_payee_cd
                    AND payee_type_cd = p_payee_type_cd;

            --deductible amt
            SELECT NVL (SUM (ded_amt), 0)
              INTO summa
              FROM gicl_eval_deductibles
             WHERE eval_id = p_eval_id;

            UPDATE gicl_mc_evaluation
               SET deductible = summa
             WHERE eval_id = p_eval_id;
         END;
      END IF;
   END;

   PROCEDURE save_repair_other_dtl (
      p_eval_master_id       gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id              gicl_repair_other_dtl.eval_id%TYPE,
      p_repair_cd            gicl_repair_other_dtl.repair_cd%TYPE,
      p_amount               gicl_repair_other_dtl.amount%TYPE,
      p_item_no              gicl_repair_other_dtl.item_no%TYPE,
      p_master_report_type   VARCHAR2
   )
   IS
      vupdatesw   VARCHAR2 (1);
   BEGIN
      IF p_master_report_type = 'RD'
      THEN
         vupdatesw := 'Y';

         /*msg_alert(':gicl_mc_evaluation.eval_master_id = '||:gicl_mc_evaluation.eval_master_id||chr(10)||
         'v_repairCd = '||v_repairCd||chr(10)||
         'v_amount = '||v_amount,'I',false); */--for debugging purposes only
         FOR x IN (SELECT 1
                     FROM gicl_repair_other_dtl
                    WHERE eval_id = p_eval_master_id
                      AND repair_cd = p_repair_cd
                      AND amount = p_amount)
         LOOP
            --msg_alert('pasok sa loop','I',false); --for debugging purposes only
            vupdatesw := 'N';
            EXIT;
         END LOOP;
      ELSE
         vupdatesw := 'N';
      END IF;

      gicl_repair_other_dtl_pkg.set_repair_other_dtl (p_eval_id,
                                                      p_repair_cd,
                                                      p_amount,
                                                      p_item_no,
                                                      vupdatesw
                                                     );
   END;

   PROCEDURE set_repair_other_dtl (
      p_eval_id     gicl_repair_other_dtl.eval_id%TYPE,
      p_repair_cd   gicl_repair_other_dtl.repair_cd%TYPE,
      p_amount      gicl_repair_other_dtl.amount%TYPE,
      p_item_no     gicl_repair_other_dtl.item_no%TYPE,
      p_update_sw   gicl_repair_other_dtl.update_sw%TYPE
   )
   IS
   BEGIN
      MERGE INTO gicl_repair_other_dtl
         USING DUAL
         ON (    eval_id = p_eval_id
             AND repair_cd = p_repair_cd
             AND item_no = p_item_no)
         WHEN MATCHED THEN
            UPDATE
               SET amount = p_amount, update_sw = p_update_sw
         WHEN NOT MATCHED THEN
            INSERT (eval_id, repair_cd, amount, update_sw)               --2.0
            VALUES (p_eval_id, p_repair_cd, p_amount, p_update_sw);
   END;

   PROCEDURE update_other_details (
      p_eval_id   gicl_repair_other_dtl.eval_id%TYPE,
	  dsp_total_labor gicl_repair_other_dtl.amount%TYPE
   )
   IS
      total_labor   gicl_repair_other_dtl.amount%TYPE;
      v_cnt         NUMBER                               := 0;
      v_max         NUMBER                               := 0;
      vitemno       gicl_repair_other_dtl.item_no%TYPE;
	  total_repair_labor  gicl_repair_other_dtl.amount%TYPE;
   BEGIN
  
      -- get total labor amount
      BEGIN
         SELECT SUM (amount)
           INTO total_labor
           FROM gicl_repair_other_dtl
          WHERE eval_id = p_eval_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            total_labor := NULL;
      END;
	
	BEGIN
         SELECT SUM (actual_total_amt)
           INTO total_repair_labor
           FROM gicl_repair_hdr
          WHERE eval_id = p_eval_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            total_repair_labor := NULL;
      END;
	
      --BEGIN
         UPDATE gicl_repair_hdr
            SET other_labor_amt = total_labor
          WHERE eval_id = p_eval_id;

-- adds the repair total labor and the total other labor amount new
      total_labor := total_labor + NVL (total_repair_labor, 0);
	
	-- updates the total labor in gicl_mc_evaluation
         UPDATE gicl_mc_evaluation
            SET repair_amt = total_labor
          WHERE eval_id = p_eval_id;
    --  END;

     -- BEGIN
         -- updates the item no
         
         SELECT COUNT (DISTINCT NVL (a.repair_cd, 0)), MAX (NVL (a.item_no, 0))
           INTO v_cnt, v_max
           FROM gicl_repair_other_dtl a, gicl_mc_evaluation b
          WHERE 1 = 1
            AND a.eval_id = b.eval_id
            AND b.eval_stat_cd <> 'CC'
            AND (   a.eval_id = p_eval_id
                 OR (b.eval_master_id = p_eval_id AND b.report_type = 'AD')
                );                                    --4.0 petermkaw 03122010

         vitemno := 0;
        
         IF NVL (v_cnt, 0) <> NVL (v_max, 0)
         THEN
            FOR x IN
               (SELECT   a.item_no, a.repair_cd
                    FROM gicl_repair_other_dtl a, gicl_mc_evaluation b
                   WHERE 1 = 1
                     AND a.eval_id = b.eval_id
                     AND b.eval_stat_cd <> 'CC'
                     AND (   a.eval_id = p_eval_id
                          OR (    b.eval_master_id = p_eval_id
                              AND b.report_type = 'AD'
                             )
                         )                            --4.0 petermkaw 03122010
                ORDER BY a.item_no)
            LOOP
               vitemno := vitemno + 1;

               UPDATE gicl_repair_other_dtl
                  SET item_no = vitemno
                WHERE eval_id = p_eval_id
                  AND repair_cd = x.repair_cd;
                 -- AND item_no = x.item_no;
            END LOOP;
         END IF;
     -- END;
   END;

   PROCEDURE del_repair_other_dtl (
      p_eval_id     gicl_repair_other_dtl.eval_id%TYPE,
      p_item_no     gicl_repair_other_dtl.item_no%TYPE,
      p_repair_cd   gicl_repair_other_dtl.repair_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_repair_other_dtl
            WHERE eval_id = p_eval_id
              AND item_no = p_item_no
              AND repair_cd = p_repair_cd;
   END;
END;
/


