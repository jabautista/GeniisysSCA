DROP PROCEDURE CPI.GICLS032_INS_INTO_TAXES_WHELD;

CREATE OR REPLACE PROCEDURE CPI.gicls032_ins_into_taxes_wheld (
   p_claim_id                  gicl_advice.claim_id%TYPE,
   p_advice_id                 gicl_advice.advice_id%TYPE,   
   p_payee_cd                  giac_taxes_wheld.payee_cd%TYPE,
   p_payee_class_cd            giac_taxes_wheld.payee_class_cd%TYPE,
   p_advice_rate               giac_currency.currency_rt%TYPE,
   p_tran_id                   giac_payt_requests_dtl.tran_id%TYPE,
   p_user_id                   giis_users.user_id%TYPE
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.1.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - insert_into_taxes_wheld
   */

   gen_type           VARCHAR2 (1);
   v_whtax            giac_taxes_wheld.gwtx_whtax_id%TYPE;
   v_tax_amt          giac_taxes_wheld.wholding_tax_amt%TYPE   DEFAULT 0;
   total_whtax        NUMBER (16, 2)                           DEFAULT 0;
   income_amt         NUMBER (16, 2)                           DEFAULT 0;
   v_sl_cd            giac_taxes_wheld.sl_cd%TYPE;
   v_sl_type          giac_taxes_wheld.sl_type_cd%TYPE;
   v_local_currency   NUMBER                                   := giacp.n ('CURRENCY_CD');
   v_ri_iss_cd        giac_parameters.param_value_v%TYPE       := giacp.v ('RI_ISS_CD');
   v_module_name      giis_modules.module_id%TYPE;
   v_item_no          NUMBER;
   v_pol_iss_cd       GICL_CLAIMS.pol_iss_cd%TYPE;
  
   CURSOR cur_whtax
   IS
      SELECT DISTINCT b.tax_cd whtax
                 FROM gicl_clm_loss_exp a, gicl_loss_exp_tax b
                WHERE a.claim_id = b.claim_id
                  AND a.clm_loss_id = b.clm_loss_id
                  AND a.payee_cd = p_payee_cd
                  AND a.payee_class_cd = p_payee_class_cd
                  AND a.claim_id = p_claim_id
                  AND a.advice_id = p_advice_id
                  AND b.tax_type = 'W';

   CURSOR t_amt
   IS
      SELECT   b.tax_cd whtax, SUM (NVL (b.tax_amt, 0)) tax_amount, SUM (NVL (b.base_amt, a.net_amt)) base_amt,
               b.sl_type_cd sl_type, b.sl_cd sl_cd, 
               DECODE (d.currency_cd,
                       v_local_currency, 1,
                       DECODE (d.currency_cd,
                               c.currency_cd, p_advice_rate,
                               DECODE (c.currency_cd,
                                       v_local_currency, d.currency_rate
                                      )
                              )
                      ) conv_rt 
               --DECODE (a.currency_cd, v_local_currency, 1, p_advice_rate) conv_rt --nieko 06162016, KB#3418 
          FROM gicl_clm_loss_exp a, gicl_loss_exp_tax b, gicl_advice c, gicl_clm_item d --nieko 06162016, added gicl_advice and gicl_clm_item KB#3418
         WHERE a.claim_id = b.claim_id
           AND a.clm_loss_id = b.clm_loss_id
           AND a.payee_cd = p_payee_cd
           AND a.payee_class_cd = p_payee_class_cd
           AND a.claim_id = p_claim_id
           AND a.advice_id = p_advice_id           
           AND a.advice_id = c.advice_id --nieko 06162016, added gicl_advice and gicl_clm_item KB#3418
           AND a.claim_id = d.claim_id   --nieko 06162016, added gicl_advice and gicl_clm_item KB#3418
           AND a.item_no = d.item_no     --nieko 06162016, added gicl_advice and gicl_clm_item KB#3418
           AND b.tax_type = 'W'
           AND b.tax_cd = v_whtax
      GROUP BY tax_cd, b.sl_type_cd, b.sl_cd, 
      DECODE (d.currency_cd,
              v_local_currency, 1,
              DECODE (d.currency_cd,
                      c.currency_cd, p_advice_rate,
                      DECODE (c.currency_cd,
                              v_local_currency, d.currency_rate
                             )
                     )
             ); 
      --DECODE (a.currency_cd, v_local_currency, 1, p_advice_rate); --nieko 06162016, KB#3418
      
BEGIN
  SELECT pol_iss_cd
    INTO v_pol_iss_cd
    FROM gicl_claims
   WHERE claim_id = p_claim_id; 

   IF v_pol_iss_cd = v_ri_iss_cd
   THEN
      v_module_name := 'GIACS018';
   ELSE
      v_module_name := 'GIACS017';
   END IF;

   BEGIN
      SELECT generation_type
        INTO gen_type
        FROM giac_modules
       WHERE module_name = v_module_name;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Insert into table not completed. Generation type does not exist!');
   END;

--  income_amt := p_income_amount;
   v_item_no := 1;
   FOR whtax IN cur_whtax
   LOOP
      v_whtax := whtax.whtax;

      FOR al IN t_amt
      LOOP
         total_whtax := al.tax_amount * al.conv_rt;
         income_amt := al.base_amt * al.conv_rt;
         v_sl_type := al.sl_type;
         v_sl_cd := al.sl_cd;
      END LOOP;

      INSERT INTO giac_taxes_wheld
                  (gacc_tran_id, gen_type, payee_class_cd, item_no, payee_cd, gwtx_whtax_id, income_amt, wholding_tax_amt,
                   user_id, last_update, sl_type_cd, sl_cd
                  )
           VALUES (p_tran_id, gen_type, p_payee_class_cd, v_item_no, p_payee_cd, v_whtax, (income_amt), (total_whtax),
                   p_user_id, SYSDATE, v_sl_type, v_sl_cd
                  );

      v_item_no := v_item_no + 1;
   END LOOP;
END;
/


