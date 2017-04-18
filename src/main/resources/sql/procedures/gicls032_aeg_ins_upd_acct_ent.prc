DROP PROCEDURE CPI.GICLS032_AEG_INS_UPD_ACCT_ENT;

CREATE OR REPLACE PROCEDURE CPI.gicls032_aeg_ins_upd_acct_ent (
   p_claim_id              gicl_advice.claim_id%TYPE,
   p_advice_id             gicl_advice.advice_id%TYPE,
   iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
   iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
   iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
   iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
   iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
   iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
   iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
   iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
   iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
   iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
   iuae_generation_type    giac_acct_entries.generation_type%TYPE,
   iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
   iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
   iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
   iuae_sl_type_cd         giac_sl_types.sl_type_cd%TYPE,
   iuae_payee_class_cd     gicl_acct_entries.payee_class_cd%TYPE,
   iuae_payee_cd           gicl_acct_entries.payee_cd%TYPE
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - aeg_ins_updt_giac_acct_entries
   */
   
   iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
BEGIN
   SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
     INTO iuae_acct_entry_id
     FROM gicl_acct_entries
    WHERE gl_acct_category = iuae_gl_acct_category
      AND gl_control_acct = iuae_gl_control_acct
      AND gl_sub_acct_1 = iuae_gl_sub_acct_1
      AND gl_sub_acct_2 = iuae_gl_sub_acct_2
      AND gl_sub_acct_3 = iuae_gl_sub_acct_3
      AND gl_sub_acct_4 = iuae_gl_sub_acct_4
      AND gl_sub_acct_5 = iuae_gl_sub_acct_5
      AND gl_sub_acct_6 = iuae_gl_sub_acct_6
      AND gl_sub_acct_7 = iuae_gl_sub_acct_7
      AND sl_cd = iuae_sl_cd
      AND generation_type = iuae_generation_type
      AND claim_id = p_claim_id
      AND advice_id = p_advice_id
      AND payee_class_cd = iuae_payee_class_cd                                                              --:c011.payee_class_cd
      AND payee_cd = iuae_payee_cd;                                                                              --:c011.payee_cd;

   IF NVL (iuae_acct_entry_id, 0) = 0
   THEN
      SELECT NVL (MAX (acct_entry_id), 0) + 1
        INTO iuae_acct_entry_id
        FROM gicl_acct_entries
       WHERE claim_id = p_claim_id
         AND advice_id = p_advice_id
         AND payee_class_cd = iuae_payee_class_cd                                                           --:c011.payee_class_cd
         AND payee_cd = iuae_payee_cd;                                                                           --:c011.payee_cd;

      INSERT INTO gicl_acct_entries
                  (claim_id, advice_id, payee_class_cd, payee_cd, acct_entry_id, gl_acct_id,
                   gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                   gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd, debit_amt,
                   credit_amt, generation_type, sl_type_cd, sl_source_cd, user_id, last_update
                  )
           VALUES (p_claim_id, p_advice_id, iuae_payee_class_cd, iuae_payee_cd, iuae_acct_entry_id, iuae_gl_acct_id,
                   iuae_gl_acct_category, iuae_gl_control_acct, iuae_gl_sub_acct_1, iuae_gl_sub_acct_2, iuae_gl_sub_acct_3,
                   iuae_gl_sub_acct_4, iuae_gl_sub_acct_5, iuae_gl_sub_acct_6, iuae_gl_sub_acct_7, iuae_sl_cd, iuae_debit_amt,
                   iuae_credit_amt, iuae_generation_type, iuae_sl_type_cd, '1', USER, SYSDATE
                  );
   ELSE
      UPDATE gicl_acct_entries
         SET debit_amt = debit_amt + iuae_debit_amt,
             credit_amt = credit_amt + iuae_credit_amt
       WHERE gl_acct_category = iuae_gl_acct_category
         AND gl_control_acct = iuae_gl_control_acct
         AND gl_sub_acct_1 = iuae_gl_sub_acct_1
         AND gl_sub_acct_2 = iuae_gl_sub_acct_2
         AND gl_sub_acct_3 = iuae_gl_sub_acct_3
         AND gl_sub_acct_4 = iuae_gl_sub_acct_4
         AND gl_sub_acct_5 = iuae_gl_sub_acct_5
         AND gl_sub_acct_6 = iuae_gl_sub_acct_6
         AND gl_sub_acct_7 = iuae_gl_sub_acct_7
         AND sl_cd = iuae_sl_cd
         AND generation_type = iuae_generation_type
         AND gl_acct_id = iuae_gl_acct_id
         AND claim_id = p_claim_id
         AND advice_id = p_advice_id
         AND payee_class_cd = iuae_payee_class_cd                                                           --:c011.payee_class_cd
         AND payee_cd = iuae_payee_cd;                                                                           --:c011.payee_cd;
   END IF;
END;
/


