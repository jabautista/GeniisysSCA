DROP PROCEDURE CPI.GET_REPAIR_AMT;

CREATE OR REPLACE PROCEDURE CPI.get_repair_amt (
   p_eval_id   gicl_mc_evaluation.eval_id%TYPE,
     p_user_id  giis_users.user_id%type
)
IS
   summa   NUMBER;
BEGIN
giis_users_pkg.app_user := p_user_id;
   SELECT NVL (SUM (a.actual_total_amt), 0)
     INTO summa
     FROM gicl_repair_hdr a
    WHERE 1 = 1
      AND a.eval_id = p_eval_id
      AND NOT EXISTS (
             SELECT 1
               FROM gicl_eval_vat
              WHERE eval_id = p_eval_id
                AND payee_type_cd = a.payee_type_cd
                AND payee_cd = a.payee_cd
                AND apply_to = 'L');

   SELECT NVL (SUM (base_amt), 0) + summa
     INTO summa
     FROM gicl_eval_vat
    WHERE eval_id = p_eval_id AND apply_to = 'L';

   -- IF summa > 0 THEN
   UPDATE gicl_mc_evaluation
      SET repair_amt = summa
    WHERE eval_id = p_eval_id;
END;
/


