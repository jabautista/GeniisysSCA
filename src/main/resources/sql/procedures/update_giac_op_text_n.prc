DROP PROCEDURE CPI.UPDATE_GIAC_OP_TEXT_N;

CREATE OR REPLACE PROCEDURE CPI.update_giac_op_text_n (
   p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
   p_iss_cd              IN       giac_comm_payts.iss_cd%TYPE,
   p_prem_seq_no         IN       giac_comm_payts.prem_seq_no%TYPE,
   p_inst_no                      giac_comm_payts.inst_no%TYPE,
   p_tran_type                    giac_comm_payts.tran_type%TYPE,
   p_prem_amt                     giac_direct_prem_collns.premium_amt%TYPE,
   p_module_name                  giac_modules.module_name%TYPE,
   p_giop_gacc_fund_cd            giac_acct_entries.gacc_gfun_fund_cd%TYPE
)
IS
   CURSOR c 
   IS
      SELECT                                                       --DISTINCT
               a.b140_iss_cd, a.b140_prem_seq_no,
               SUM (a.collection_amt) collection_amt,
               SUM (a.premium_amt) premium_amt, b.currency_cd, b.currency_rt,
               SUM (a.tax_amt) tax_amt
          FROM giac_direct_prem_collns a, gipi_invoice b, gipi_polbasic c
         WHERE a.b140_iss_cd = b.iss_cd
           AND a.b140_prem_seq_no = b.prem_seq_no
           --AND B.iss_cd           = C.iss_cd
           AND b.policy_id = c.policy_id
           AND gacc_tran_id = p_giop_gacc_tran_id
           AND a.b140_iss_cd = p_iss_cd
           AND a.b140_prem_seq_no = p_prem_seq_no
           AND a.inst_no = p_inst_no
      GROUP BY a.b140_iss_cd, a.b140_prem_seq_no, b.currency_cd,
               b.currency_rt;

   p_seq_no         giac_op_text.item_seq_no%TYPE               := 0;
   vl_lt            NUMBER;
   v_counter        NUMBER                                      := 1;
   v_coll_amt       NUMBER (14, 2)                              := 0;
   v_prem_amt       NUMBER (14, 2)                              := 0;
   v_tax_amt        NUMBER (14, 2)                              := 0;
   v_tax_cd         giac_tax_collns.b160_tax_cd%TYPE;
   v_exist          VARCHAR2 (1);
   v_cursor_exist   BOOLEAN;
   v_gen_type       giac_modules.generation_type%TYPE;
   v_currency_rt    giac_direct_prem_collns.convert_rate%TYPE;
   v_currency_cd    giac_direct_prem_collns.currency_cd%TYPE;
BEGIN
   BEGIN
      SELECT generation_type
        INTO v_gen_type
        FROM giac_modules
       WHERE module_name = p_module_name;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RAISE_APPLICATION_ERROR(20005, 'This module does not exist in giac_modules.');
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

   /*Remove first whatever records in giac_op_text.**/
   DELETE      giac_op_text
         WHERE gacc_tran_id = p_giop_gacc_tran_id
           AND item_gen_type = v_gen_type;

   IF p_tran_type IS NULL
   THEN
      NULL;
   ELSE
      v_cursor_exist := FALSE;

      FOR c_rec IN c
      LOOP
         -- creation of op_text record is per transaction basis
         check_op_text_insert_n (c_rec.premium_amt,
                                 c_rec.b140_iss_cd,
                                 c_rec.b140_prem_seq_no,
                                 p_inst_no,
								 p_giop_gacc_fund_cd,
								 p_giop_gacc_tran_id,
                                 c_rec.currency_cd,
                                 c_rec.currency_rt,
								 v_gen_type
                                );
         v_cursor_exist := TRUE;
      END LOOP;

      IF NOT v_cursor_exist
      THEN
         check_op_text_insert_n (p_prem_amt,
                                 p_iss_cd,
                                 p_prem_seq_no,
                                 p_inst_no,
								 p_giop_gacc_fund_cd,
								 p_giop_gacc_tran_id,
                                 v_currency_cd,
                                 v_currency_rt,
								 v_gen_type
                                );
      END IF;

      /*
      ** delete from giac_op_text
      ** where item_amt = 0
      */
      DELETE      giac_op_text
            WHERE gacc_tran_id = p_giop_gacc_tran_id
              AND NVL (item_amt, 0) = 0
              AND item_gen_type = v_gen_type;

      /*
      ** update giac_op_text
      ** where item_text = Taxes
      */
      UPDATE giac_op_text
         SET item_text = SUBSTR (item_text, 7, NVL (LENGTH (item_text), 0))
       WHERE gacc_tran_id = p_giop_gacc_tran_id
         AND LTRIM (SUBSTR (item_text, 1, 2), '0') IN (SELECT tax_cd
                                                         FROM giac_taxes
                                                        WHERE tax_cd <> 1)
         AND SUBSTR (item_text, 1, 2) NOT IN ('CO', 'PR')
         AND item_gen_type = v_gen_type;
   END IF;
END update_giac_op_text_n;
/


