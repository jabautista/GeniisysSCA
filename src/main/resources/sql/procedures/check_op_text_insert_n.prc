DROP PROCEDURE CPI.CHECK_OP_TEXT_INSERT_N;

CREATE OR REPLACE PROCEDURE CPI.check_op_text_insert_n (
   p_premium_amt         IN       NUMBER,
   p_iss_cd              IN       giac_direct_prem_collns.b140_iss_cd%TYPE,
   p_prem_seq_no         IN       giac_direct_prem_collns.b140_prem_seq_no%TYPE,
   p_inst_no                      giac_comm_payts.inst_no%TYPE,
   p_giop_gacc_fund_cd            giac_acct_entries.gacc_gfun_fund_cd%TYPE,
   p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
   p_currency_cd         IN       giac_direct_prem_collns.currency_cd%TYPE,
   p_convert_rate        IN       giac_direct_prem_collns.convert_rate%TYPE,
   p_gen_type            OUT      giac_modules.generation_type%TYPE
)
IS
   v_exist          VARCHAR2 (1);
   n_seq_no         NUMBER (2)                                  := 0;
   v_tax_name       VARCHAR2 (100);
   v_tax_cd         NUMBER (2);
   v_sub_tax_amt    NUMBER (14, 2);
   v_count          NUMBER                                      := 0;
   v_check_name     VARCHAR2 (100)                              := 'GRACE';
   v_no             NUMBER                                      := 0;
   v_currency_cd    giac_direct_prem_collns.currency_cd%TYPE;
   v_convert_rate   giac_direct_prem_collns.convert_rate%TYPE;
   v_column_no      giac_taxes.column_no%TYPE;
   v_seq            NUMBER;
   v_seq_no         NUMBER;
BEGIN
   BEGIN
      SELECT 'X'
        INTO v_exist
        FROM giac_op_text
       WHERE gacc_tran_id = p_giop_gacc_tran_id
         AND item_gen_type = p_gen_type
         AND SUBSTR (item_text, 1, 7) = 'PREMIUM'
         AND bill_no = p_iss_cd || '-' || TO_CHAR (p_prem_seq_no);

      UPDATE giac_op_text
         SET item_amt = NVL (p_premium_amt, 0) + NVL (item_amt, 0),
             foreign_curr_amt =
                  NVL (p_premium_amt / p_convert_rate, 0)
                + NVL (foreign_curr_amt, 0),
             column_no = 1
       WHERE gacc_tran_id = p_giop_gacc_tran_id
         AND SUBSTR (item_text, 1, 7) = 'PREMIUM'
         AND item_gen_type = p_gen_type
         AND bill_no = p_iss_cd || '-' || TO_CHAR (p_prem_seq_no);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_seq_no := v_seq_no + 1;
         v_seq := v_seq_no;

         BEGIN
            INSERT INTO giac_op_text
                        (gacc_tran_id, item_gen_type, item_seq_no,
                         item_amt, item_text,
                         bill_no, print_seq_no,
                         currency_cd, user_id, last_update,
                         foreign_curr_amt, column_no
                        )
                 VALUES (p_giop_gacc_tran_id, p_gen_type, v_seq,
                         p_premium_amt, 'PREMIUM',
                         p_iss_cd || '-' || TO_CHAR (p_prem_seq_no), v_seq,
                         p_currency_cd,
                                       NVL(giis_users_pkg.app_user, USER), SYSDATE,
                         p_premium_amt / p_convert_rate, 1
                        );
         EXCEPTION
            WHEN OTHERS
            THEN
				null;
               --p_msg_alert := SQLERRM;
         END;
   END;

   BEGIN
      FOR tax IN (SELECT b.b160_tax_cd, c.tax_name, b.tax_amt, a.currency_cd,
                         a.convert_rate, c.column_no
                    FROM giac_direct_prem_collns a,
                         giac_tax_collns b,
                         giac_taxes c
                   WHERE 1 = 1
                     AND a.b140_iss_cd = b.b160_iss_cd
                     AND a.b140_prem_seq_no = b.b160_prem_seq_no
                     AND a.gacc_tran_id = b.gacc_tran_id
                     AND a.inst_no = b.inst_no
                     AND b.b160_tax_cd = c.tax_cd
                     AND b.fund_cd = c.fund_cd
                     AND c.fund_cd = p_giop_gacc_fund_cd
                     AND b.gacc_tran_id = p_giop_gacc_tran_id
                     AND b.b160_iss_cd = p_iss_cd
                     AND b.b160_prem_seq_no = p_prem_seq_no
                     AND b.inst_no = p_inst_no)
      LOOP
         v_count := v_count + 1;
         v_tax_cd := tax.b160_tax_cd;
         v_tax_name := tax.tax_name;
         v_sub_tax_amt := tax.tax_amt;
         v_convert_rate := tax.convert_rate;
         v_currency_cd := tax.currency_cd;
         v_column_no := tax.column_no;

         IF v_tax_name != 'EVAT'
         THEN
            v_no := v_no + 1;
         END IF;

         IF v_check_name = v_tax_name
         THEN
            EXIT;
         END IF;

         IF v_count = 1
         THEN
            v_check_name := v_tax_name;
         END IF;

         check_op_text_2_n (v_tax_cd,
                            v_tax_name,
                            v_sub_tax_amt,
                            v_currency_cd,
                            v_convert_rate,
                            p_iss_cd,
                            p_prem_seq_no,
                            v_column_no,
                            v_no,
                            v_seq,
							p_giop_gacc_tran_id,
							p_gen_type 
                           );
      END LOOP;
   END;
END check_op_text_insert_n;
/


