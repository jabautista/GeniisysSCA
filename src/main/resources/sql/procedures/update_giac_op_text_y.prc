DROP PROCEDURE CPI.UPDATE_GIAC_OP_TEXT_Y;

CREATE OR REPLACE PROCEDURE CPI.update_giac_op_text_y (
   p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
   p_iss_cd              IN       giac_comm_payts.iss_cd%TYPE,
   p_prem_seq_no         IN       giac_comm_payts.prem_seq_no%TYPE,
   p_inst_no                      giac_comm_payts.inst_no%TYPE,
   p_tran_type                    giac_comm_payts.tran_type%TYPE,
   p_module_name                  giac_modules.module_name%TYPE,
   p_prem_amt                     giac_direct_prem_collns.premium_amt%TYPE,
   p_giop_gacc_fund_cd            giac_acct_entries.gacc_gfun_fund_cd%TYPE
)
IS
   CURSOR c
   IS
      SELECT DISTINCT a.collection_amt, a.premium_amt, b.currency_cd,
                      b.currency_rt, a.tax_amt
                 FROM giac_direct_prem_collns a,
                      gipi_invoice b,
                      gipi_polbasic c
                WHERE a.b140_iss_cd = b.iss_cd
                  AND a.b140_prem_seq_no = b.prem_seq_no
                  AND b.iss_cd = c.iss_cd
                  AND b.policy_id = c.policy_id
                  AND gacc_tran_id = p_giop_gacc_tran_id
                  AND a.b140_iss_cd = p_iss_cd
                  AND a.b140_prem_seq_no = p_prem_seq_no
                  AND a.inst_no = p_inst_no;

   v_coll_amt            NUMBER (14, 2)                              := 0;
   v_prem_amt            NUMBER (14, 2)                              := 0;
   v_tax_amt             NUMBER (14, 2)                              := 0;
   v_tax_cd              giac_tax_collns.b160_tax_cd%TYPE;
   v_exist               VARCHAR2 (1);
   v_cursor_exist        BOOLEAN;
   v_gen_type            giac_modules.generation_type%TYPE;
   --p_seq_no number:= 3;
   v_continue            BOOLEAN                                     := TRUE;
   v_currency_rt         giac_direct_prem_collns.convert_rate%TYPE;
   v_currency_cd         giac_direct_prem_collns.currency_cd%TYPE;
   v_zero_prem_op_text   VARCHAR2 (2);
   v_seq_no              giac_op_text.item_seq_no%TYPE;
BEGIN
   v_seq_no := 0;

   BEGIN
      SELECT generation_type
        INTO v_gen_type
        FROM giac_modules
       WHERE module_name = p_module_name;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RAISE_APPLICATION_ERROR(-20005, 'This module does not exist in giac_modules.');
   END;

   BEGIN
      SELECT currency_rt, main_currency_cd
        INTO v_currency_rt, v_currency_cd
        FROM giis_currency
       WHERE main_currency_cd = (SELECT currency_cd
                                   FROM giac_order_of_payts
                                  WHERE gacc_tran_id = p_giop_gacc_tran_id);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   BEGIN
      DELETE      giac_op_text
            WHERE gacc_tran_id = p_giop_gacc_tran_id
              AND item_gen_type = v_gen_type;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RAISE_APPLICATION_ERROR(-20005, 'No records found in Giac_Op_Text.');
   END;

   IF p_tran_type IS NULL
   THEN
      NULL;
   ELSE
      v_seq_no := 3;
      v_zero_prem_op_text := 'Y';
      v_cursor_exist := FALSE;

      FOR c_rec IN c
      LOOP
         check_op_text_insert_y (c_rec.premium_amt,
                                 c_rec.currency_cd,
                                 c_rec.currency_rt,
                                 p_iss_cd,
                                 p_prem_seq_no,
                                 p_giop_gacc_tran_id,
                                 p_inst_no,
                                 p_giop_gacc_fund_cd,
                                 v_zero_prem_op_text,
                                 v_seq_no,
                                 p_module_name,
                                 v_gen_type
                                );
         v_cursor_exist := TRUE;
      END LOOP;

      IF NOT v_cursor_exist
      THEN
         check_op_text_insert_y (p_prem_amt,
                                 v_currency_cd,
                                 v_currency_rt,
                                 p_iss_cd,
                                 p_prem_seq_no,
                                 p_giop_gacc_tran_id,
                                 p_inst_no,
                                 p_giop_gacc_fund_cd,
                                 v_zero_prem_op_text,
                                 v_seq_no,
                                 p_module_name,
                                 v_gen_type
                                );
      END IF;

      v_zero_prem_op_text := 'N';

      /*
      ** delete from giac_op_text
      ** where item_amt = 0
      */
      BEGIN
         DELETE      giac_op_text
               WHERE gacc_tran_id = p_giop_gacc_tran_id
                 AND NVL (item_amt, 0) = 0
                 AND LTRIM (SUBSTR (item_text, 1, 2), '0') IN (
                                                               SELECT tax_cd
                                                                 FROM giac_taxes)
                 AND SUBSTR (item_text, 1, 9) <> 'PREMIUM ('
                 --v--
                 AND item_gen_type = v_gen_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RAISE_APPLICATION_ERROR(-20005,
                       'No records found in Giac_Op_Text where item_amt = 0.');
      END;

      BEGIN
         UPDATE giac_op_text
            SET item_text = SUBSTR (item_text, 7, NVL (LENGTH (item_text), 0))
          WHERE gacc_tran_id = p_giop_gacc_tran_id
            AND LTRIM (SUBSTR (item_text, 1, 2), '0') IN (SELECT tax_cd
                                                            FROM giac_taxes)
            AND SUBSTR (item_text, 1, 2) NOT IN ('CO', 'PR')
            AND item_gen_type = v_gen_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RAISE_APPLICATION_ERROR(-20005,
                  'No records found in Giac_Op_Text where item_text = Taxes.');
      END;
   END IF;
   /*
EXCEPTION
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR(-20005, 'Error occured during update of Giac_Op_Text.'); */
END update_giac_op_text_y;
/


