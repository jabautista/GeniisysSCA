DROP PROCEDURE CPI.GET_REPLACE_AMT;

CREATE OR REPLACE PROCEDURE CPI.get_replace_amt (
   p_eval_id   gicl_mc_evaluation.eval_id%TYPE,
   p_user_id  giis_users.user_id%type
)
IS
   summa        NUMBER;
   total        NUMBER;
   v_with_vat   gicl_eval_vat.with_vat%TYPE;
   
BEGIN
giis_users_pkg.app_user := p_user_id;
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

   --    IF summa > 0 THEN
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
/


