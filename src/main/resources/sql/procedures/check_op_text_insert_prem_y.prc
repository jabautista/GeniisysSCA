DROP PROCEDURE CPI.CHECK_OP_TEXT_INSERT_PREM_Y;

CREATE OR REPLACE PROCEDURE CPI.check_op_text_insert_prem_y (
   p_seq_no                    NUMBER,
   p_premium_amt               gipi_invoice.prem_amt%TYPE,
   p_prem_text                 VARCHAR2,
   p_currency_cd               giac_direct_prem_collns.currency_cd%TYPE,
   p_convert_rate              giac_direct_prem_collns.convert_rate%TYPE,
   p_giop_gacc_tran_id         giac_direct_prem_collns.gacc_tran_id%TYPE,
   p_module_name               giac_modules.module_name%TYPE,
   p_gen_type    giac_modules.generation_type%TYPE
)
IS
   v_exist      VARCHAR2 (1);
 
BEGIN


   SELECT 'X'
     INTO v_exist
     FROM giac_op_text
    WHERE gacc_tran_id = p_giop_gacc_tran_id
      AND item_gen_type = p_gen_type
      AND item_text = p_prem_text;

   UPDATE giac_op_text
      SET item_amt = NVL (item_amt, 0) + NVL (p_premium_amt, 0),
          foreign_curr_amt =
               NVL (foreign_curr_amt, 0)
             + NVL (p_premium_amt / p_convert_rate, 0)
    WHERE gacc_tran_id = p_giop_gacc_tran_id
      AND item_text = p_prem_text
      AND item_gen_type = p_gen_type;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO giac_op_text
                  (gacc_tran_id, item_gen_type, item_seq_no, item_amt,
                   item_text, print_seq_no, currency_cd, user_id,
                   last_update, foreign_curr_amt
                  )
           VALUES (p_giop_gacc_tran_id, p_gen_type, p_seq_no, p_premium_amt,
                   p_prem_text, p_seq_no, p_currency_cd, NVL(giis_users_pkg.app_user, USER),
                   SYSDATE, p_premium_amt / p_convert_rate
                  );
END;
/


