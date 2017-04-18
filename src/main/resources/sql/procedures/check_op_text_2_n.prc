DROP PROCEDURE CPI.CHECK_OP_TEXT_2_N;

CREATE OR REPLACE PROCEDURE CPI.check_op_text_2_n (
   p_b160_tax_cd                  NUMBER,
   p_tax_name                     VARCHAR2,
   p_tax_amt                      NUMBER,
   p_currency_cd                  NUMBER,
   p_convert_rate                 NUMBER,
   p_iss_cd              IN       giac_direct_prem_collns.b140_iss_cd%TYPE,
   p_prem_seq_no         IN       giac_direct_prem_collns.b140_prem_seq_no%TYPE,
   p_column_no           IN       giac_taxes.column_no%TYPE,
   p_seq_no              OUT      NUMBER,
   p_sq                  IN       NUMBER,
   p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
   p_gen_type            IN OUT      giac_modules.generation_type%TYPE
)
IS
   v_exist     VARCHAR2 (1);
   v_seq_no1   NUMBER;
BEGIN
   BEGIN
      SELECT 'X'
        INTO v_exist
        FROM giac_op_text
       WHERE gacc_tran_id = p_giop_gacc_tran_id
         AND SUBSTR (item_text, 1, 5) =
                   LTRIM (TO_CHAR (p_b160_tax_cd, '09'))
                || '-'
                || LTRIM (TO_CHAR (p_currency_cd, '09'))
         AND bill_no = p_iss_cd || '-' || TO_CHAR (p_prem_seq_no);

      IF p_b160_tax_cd <> 1
      THEN
         UPDATE giac_op_text
            SET item_amt = NVL (item_amt, 0) + NVL (p_tax_amt, 0),
                foreign_curr_amt =
                     NVL (foreign_curr_amt, 0)
                   + NVL
                        (p_tax_amt / p_convert_rate, 0)
          WHERE gacc_tran_id = p_giop_gacc_tran_id
            AND item_gen_type = p_gen_type
            AND SUBSTR (item_text, 1, 5) =
                      LTRIM (TO_CHAR (p_b160_tax_cd, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (p_currency_cd, '09'))
            AND bill_no = p_iss_cd || '-' || TO_CHAR (p_prem_seq_no);
      ELSE
         UPDATE giac_op_text
            SET item_amt = NVL (item_amt, 0) + NVL (p_tax_amt, 0),
                foreign_curr_amt =
                     NVL (foreign_curr_amt, 0)
                   + NVL
                        (p_tax_amt / p_convert_rate, 0)
          WHERE gacc_tran_id = p_giop_gacc_tran_id
            AND SUBSTR (item_text, 1, 7) = 'PREMIUM'
            AND item_gen_type = p_gen_type
            AND bill_no = p_iss_cd || '-' || TO_CHAR (p_prem_seq_no);
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            IF (p_b160_tax_cd = 1)
            THEN
               UPDATE giac_op_text
                  SET item_amt = NVL (item_amt, 0) + NVL (p_tax_amt, 0),
                      foreign_curr_amt =
                           NVL (foreign_curr_amt, 0)
                         + NVL
                              (p_tax_amt / p_convert_rate, 0)
                WHERE gacc_tran_id = p_giop_gacc_tran_id
                  AND SUBSTR (item_text, 1, 7) = 'PREMIUM'
                  AND item_gen_type = p_gen_type
                  AND bill_no = p_iss_cd || '-' || TO_CHAR (p_prem_seq_no);
            ELSE
               p_seq_no := p_sq + p_seq_no;

               INSERT INTO giac_op_text
                           (gacc_tran_id, item_gen_type, item_seq_no,
                            item_amt,
                            item_text,
                            bill_no,
                            print_seq_no, currency_cd, user_id, last_update,
                            foreign_curr_amt, column_no
                           )                          
                    VALUES (p_giop_gacc_tran_id, p_gen_type, p_seq_no,
                            p_tax_amt,
                               LTRIM (TO_CHAR (p_b160_tax_cd, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (p_currency_cd, '09'))
                            || '-'
                            || p_tax_name,
                            p_iss_cd || '-' || TO_CHAR (p_prem_seq_no),
                            p_seq_no, p_currency_cd, NVL(GIIS_USERS_PKG.app_user, USER), SYSDATE,
                            p_tax_amt / p_convert_rate, p_column_no
                           );
            END IF;
         END;
   END;
END check_op_text_2_n;
/


