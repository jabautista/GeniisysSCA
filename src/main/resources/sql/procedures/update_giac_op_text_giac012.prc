DROP PROCEDURE CPI.UPDATE_GIAC_OP_TEXT_GIAC012;

CREATE OR REPLACE PROCEDURE CPI.update_giac_op_text_giac012(p_gacc_tran_id giac_oth_fund_off_collns.gacc_tran_id%TYPE)
IS
BEGIN
   DECLARE
      CURSOR c
      IS
         SELECT DISTINCT a.gacc_tran_id, a.user_id, a.last_update, a.item_no, a.collection_amt item_amt,
                            a.gibr_gfun_fund_cd
                         || '-'
                         || a.gibr_branch_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.item_no, '09'))
                         || DECODE (a.gofc_item_no,
                                    NULL, NULL,
                                       ' / '
                                    || LTRIM (TO_CHAR (a.gofc_gacc_tran_id, '09999999'))
                                    || '-'
                                    || a.gofc_gibr_gfun_fund_cd
                                    || '-'
                                    || a.gofc_gibr_branch_cd
                                    || '-'
                                    || LTRIM (TO_CHAR (a.gofc_item_no, '09'))
                                   ) item_text
                    FROM giac_oth_fund_off_collns a
                   WHERE a.gacc_tran_id = p_gacc_tran_id
                ORDER BY a.item_no;

      ws_seq_no     giac_op_text.item_seq_no%TYPE   := 1;
      ws_gen_type   VARCHAR2 (1)                    := 'F';
   BEGIN
      DECLARE
         v_test   giac_parameters.param_value_n%TYPE;
      BEGIN
         DELETE FROM giac_op_text
               WHERE gacc_tran_id = p_gacc_tran_id AND item_gen_type = ws_gen_type;

         FOR c_rec IN c
         LOOP
            SELECT param_value_n
              INTO v_test
              FROM giac_parameters
             WHERE param_name = 'CURRENCY_CD';

            INSERT INTO giac_op_text
                        (gacc_tran_id, item_seq_no, item_gen_type, item_text, item_amt, user_id,
                         last_update, print_seq_no, currency_cd, foreign_curr_amt
                        )
                 VALUES (c_rec.gacc_tran_id, ws_seq_no, ws_gen_type, c_rec.item_text, c_rec.item_amt, c_rec.user_id,
                         c_rec.last_update, ws_seq_no, v_test, c_rec.item_amt
                        );

            ws_seq_no := ws_seq_no + 1;
         END LOOP;
      END;
   END;
END;
/


