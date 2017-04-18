CREATE OR REPLACE PACKAGE BODY CPI.gicl_repair_type_pkg
AS
   FUNCTION get_repair_type_type_list (
      p_eval_id     gicl_mc_evaluation.eval_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN gicl_repair_type_tab PIPELINED
   IS
      v_rep_type   gicl_repair_type_type;
   BEGIN
      FOR i IN (SELECT a.*
                  FROM gicl_repair_type a
                 WHERE UPPER (repair_desc) LIKE
                                              NVL (UPPER (p_find_text), '%%')
                   AND NOT EXISTS (
                          SELECT 1
                            FROM gicl_repair_other_dtl
                           WHERE eval_id = p_eval_id
                             AND repair_cd = a.repair_cd)
                             ORDER BY a.repair_desc
                             )
      LOOP
         v_rep_type.repair_cd := i.repair_cd;
         v_rep_type.repair_desc := i.repair_desc;
         v_rep_type.remarks := i.remarks;
         v_rep_type.required := i.required;
         v_rep_type.user_id := i.user_id;
         v_rep_type.last_update := i.last_update;
         PIPE ROW (v_rep_type);
      END LOOP;
   END;
END;
/


