DROP PROCEDURE CPI.CHECK_OP_TEXT_2_Y;

CREATE OR REPLACE PROCEDURE CPI.check_op_text_2_y (
   v_b160_tax_cd               NUMBER,
   v_tax_name                  VARCHAR2,
   v_tax_amt                   NUMBER,
   v_currency_cd               NUMBER,
   v_convert_rate              NUMBER,
   p_giop_gacc_tran_id         giac_direct_prem_collns.gacc_tran_id%TYPE,
   p_gen_type                  giac_modules.generation_type%TYPE,
   p_seq_no              IN OUT   NUMBER
)
IS
   v_exist   VARCHAR2 (1);
BEGIN
   BEGIN
      SELECT 'X'
        INTO v_exist
        FROM giac_op_text
       WHERE gacc_tran_id = p_giop_gacc_tran_id
         AND SUBSTR (item_text, 1, 5) =
                   LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                || '-'
                || LTRIM (TO_CHAR (v_currency_cd, '09'));

      UPDATE giac_op_text
         SET item_amt = NVL (item_amt, 0) + NVL (v_tax_amt, 0),
             foreign_curr_amt =
                NVL (foreign_curr_amt, 0)
                + NVL (v_tax_amt / v_convert_rate, 0)
       WHERE gacc_tran_id = p_giop_gacc_tran_id
         AND item_gen_type = p_gen_type
         AND SUBSTR (item_text, 1, 5) =
                   LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                || '-'
                || LTRIM (TO_CHAR (v_currency_cd, '09'));
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            p_seq_no := p_seq_no + 1;

            INSERT INTO giac_op_text
                        (gacc_tran_id, item_gen_type, item_seq_no,
                         item_amt,
                         item_text,
                         print_seq_no, currency_cd, user_id, last_update,
                         foreign_curr_amt
                        )
                 VALUES (p_giop_gacc_tran_id, p_gen_type, p_seq_no,
                         v_tax_amt,
                            LTRIM (TO_CHAR (v_b160_tax_cd, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (v_currency_cd, '09'))
                         || '-'
                         || v_tax_name,
                         p_seq_no, v_currency_cd, NVL(giis_users_pkg.app_user, USER), SYSDATE,
                         v_tax_amt / v_convert_rate
                        );
         END;
   END;
END;
/


