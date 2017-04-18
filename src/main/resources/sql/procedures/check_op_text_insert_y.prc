DROP PROCEDURE CPI.CHECK_OP_TEXT_INSERT_Y;

CREATE OR REPLACE PROCEDURE CPI.check_op_text_insert_y (
   p_premium_amt         IN       NUMBER,
   p_currency_cd         IN       giac_direct_prem_collns.currency_cd%TYPE,
   p_convert_rate        IN       giac_direct_prem_collns.convert_rate%TYPE,
   p_iss_cd              IN       giac_comm_payts.iss_cd%TYPE,
   p_prem_seq_no         IN       giac_comm_payts.prem_seq_no%TYPE,
   p_giop_gacc_tran_id            giac_direct_prem_collns.gacc_tran_id%TYPE,
   p_inst_no                      giac_comm_payts.inst_no%TYPE,
   p_giop_gacc_fund_cd            giac_acct_entries.gacc_gfun_fund_cd%TYPE,
   p_zero_prem_op_text   OUT      VARCHAR2,
   p_seq_no              IN OUT      NUMBER,
   p_module_name                  giac_modules.module_name%TYPE,
   p_gen_type            IN OUT      giac_modules.generation_type%TYPE
)
IS
   v_exist             VARCHAR2 (1);
   n_seq_no            NUMBER (2);
   v_tax_name          VARCHAR2 (100);
   v_tax_cd            NUMBER (2);
   v_sub_tax_amt       NUMBER (14, 2);
   v_count             NUMBER                                      := 0;
   v_check_name        VARCHAR2 (20)                               := 'GRACE';
   v_no                NUMBER                                      := 1;
   v_currency_cd       giac_direct_prem_collns.currency_cd%TYPE;
   v_convert_rate      giac_direct_prem_collns.convert_rate%TYPE;
   v_prem_type         VARCHAR2 (1)                                := 'E';
   v_prem_text         VARCHAR2 (25);
   v_or_curr_cd        giac_order_of_payts.currency_cd%TYPE;
   v_def_curr_cd       giac_order_of_payts.currency_cd%TYPE
                                          := NVL (giacp.n ('CURRENCY_CD'), 1);
   v_inv_tax_amt       gipi_inv_tax.tax_amt%TYPE;
   v_inv_tax_rt        gipi_inv_tax.rate%TYPE;
   v_inv_prem_amt      gipi_invoice.prem_amt%TYPE;
   v_tax_colln_amt     giac_tax_collns.tax_amt%TYPE;
   v_premium_amt       gipi_invoice.prem_amt%TYPE;
   v_exempt_prem_amt   gipi_invoice.prem_amt%TYPE;
   v_init_prem_text    VARCHAR2 (25);
BEGIN
   v_premium_amt := p_premium_amt;

   BEGIN
      SELECT DECODE (NVL (c.tax_amt, 0), 0, 'Z', 'V') prem_type,
             c.tax_amt inv_tax_amt, c.rate inv_tax_rt,
             b.prem_amt inv_prem_amt
        INTO v_prem_type,
             v_inv_tax_amt, v_inv_tax_rt,
             v_inv_prem_amt
        FROM gipi_invoice b, gipi_inv_tax c
       WHERE b.iss_cd = c.iss_cd
         AND b.prem_seq_no = c.prem_seq_no
         AND c.tax_cd = giacp.n ('EVAT')
         AND c.iss_cd = p_iss_cd
         AND c.prem_seq_no = p_prem_seq_no;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   IF v_prem_type = 'V'
   THEN
      v_prem_text := 'PREMIUM (VATABLE)';
      n_seq_no := 1;

      --Separate the vatable and vat-exempt premiums
      --for cases where the evat is peril dependent. Note the 1 peso variance, as per Ms. J.
      --If the difference is <= 1 then all the amt should be for the vatable premium
      IF   ABS (v_inv_prem_amt - ROUND (v_inv_tax_amt / v_inv_tax_rt * 100, 2)
               )
         * p_convert_rate > 1
      THEN
         BEGIN
            SELECT NVL (tax_amt, 0)
              INTO v_tax_colln_amt
              FROM giac_tax_collns
             WHERE gacc_tran_id = p_giop_gacc_tran_id
               AND b160_iss_cd = p_iss_cd
               AND b160_prem_seq_no = p_prem_seq_no
               AND inst_no = p_inst_no
               AND b160_tax_cd = giacp.n ('EVAT');
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_tax_colln_amt := 0;
         END;

         IF v_tax_colln_amt <> 0
         THEN
            v_premium_amt := ROUND (v_tax_colln_amt / v_inv_tax_rt * 100, 2);
            v_exempt_prem_amt := p_premium_amt - v_premium_amt;

            IF ABS (v_exempt_prem_amt) <= 1
            THEN
               v_premium_amt := p_premium_amt;
               v_exempt_prem_amt := NULL;
            END IF;
         END IF;
      END IF;
   ELSIF v_prem_type = 'Z'
   THEN
      v_prem_text := 'PREMIUM (ZERO-RATED)';
      n_seq_no := 2;
   ELSE
      v_prem_text := 'PREMIUM (VAT-EXEMPT)';
      n_seq_no := 3;
   END IF;

   --check if the currency_cd in the O.R. is the default currency. If so, the amts inserted in giac_op_text
   --should also be in the default  currency regardless of what currency_cd is in the invoice
   FOR b1 IN (SELECT currency_cd
                FROM giac_order_of_payts
               WHERE gacc_tran_id = p_giop_gacc_tran_id)
   LOOP
      v_or_curr_cd := b1.currency_cd;
      EXIT;
   END LOOP;

   IF v_or_curr_cd = v_def_curr_cd
   THEN
      v_convert_rate := 1;
      v_currency_cd := v_def_curr_cd;
   ELSE
      v_convert_rate := p_convert_rate;
      v_currency_cd := p_currency_cd;
   END IF;

   --insert the zero amts for the three types of premium
   IF p_zero_prem_op_text = 'Y'
   THEN
      FOR rec IN 1 .. 3
      LOOP
         IF rec = 1
         THEN
            v_init_prem_text := 'PREMIUM (VATABLE)';
         ELSIF rec = 2
         THEN
            v_init_prem_text := 'PREMIUM (ZERO-RATED)';
         ELSE
            v_init_prem_text := 'PREMIUM (VAT-EXEMPT)';
         END IF;

         check_op_text_insert_prem_y (rec,
                                      0,
                                      v_init_prem_text,
                                      v_currency_cd,
                                      v_convert_rate,
                                      p_giop_gacc_tran_id,
                                      p_module_name,
                                      p_gen_type
                                     );
         p_zero_prem_op_text := 'N';
      END LOOP;
   END IF;

   check_op_text_insert_prem_y (n_seq_no,
                                v_premium_amt,
                                v_prem_text,
                                v_currency_cd,
                                v_convert_rate,
                                p_giop_gacc_tran_id,
                                p_module_name,
                                p_gen_type
                               );

   --insert the vat-exempt premium
   IF NVL (v_exempt_prem_amt, 0) <> 0
   THEN
      v_prem_text := 'PREMIUM (VAT-EXEMPT)';
      n_seq_no := 3;
      check_op_text_insert_prem_y (n_seq_no,
                                   v_exempt_prem_amt,
                                   v_prem_text,
                                   v_currency_cd,
                                   v_convert_rate,
                                   p_giop_gacc_tran_id,
                                   p_module_name,
                                   p_gen_type
                                  );
   END IF;

   COMMIT;

   --FORMS_DDL('COMMIT');
   BEGIN
      FOR tax IN (SELECT b.b160_tax_cd, c.tax_name, b.tax_amt, a.currency_cd,
                         a.convert_rate
                    FROM giac_direct_prem_collns a,
                         giac_tax_collns b,
                         giac_taxes c
                   WHERE b.gacc_tran_id = p_giop_gacc_tran_id
                     AND a.gacc_tran_id = b.gacc_tran_id
                     AND a.b140_iss_cd = b.b160_iss_cd
                     AND a.b140_prem_seq_no = b.b160_prem_seq_no
                     AND a.inst_no = b.inst_no
                     AND c.fund_cd = p_giop_gacc_fund_cd
                     AND b.b160_iss_cd = p_iss_cd
                     AND b.b160_prem_seq_no = p_prem_seq_no
                     AND b.inst_no = p_inst_no
                     AND b.b160_tax_cd = c.tax_cd)
      LOOP
         v_count := v_count + 1;
         v_tax_cd := tax.b160_tax_cd;
         v_tax_name := tax.tax_name;
         v_sub_tax_amt := tax.tax_amt;

         --check if the currency_cd in the O.R. is the default currency. If so, the amts inserted in giac_op_text
         --should also be in the default  currency regardless of what currency_cd is in the invoice
         IF v_or_curr_cd = v_def_curr_cd
         THEN
            v_convert_rate := 1;
            v_currency_cd := v_def_curr_cd;
         ELSE
            v_convert_rate := tax.convert_rate;
            v_currency_cd := tax.currency_cd;
         END IF;

         IF v_tax_cd != giacp.n ('EVAT')
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

         check_op_text_2_y (v_tax_cd,
                            v_tax_name,
                            v_sub_tax_amt,
                            v_currency_cd,
                            v_convert_rate,
                            p_giop_gacc_tran_id,
                            p_gen_type,
							p_seq_no
                           );
      END LOOP;
   END;
END;
/


