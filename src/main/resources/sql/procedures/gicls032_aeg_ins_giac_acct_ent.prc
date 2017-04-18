DROP PROCEDURE CPI.GICLS032_AEG_INS_GIAC_ACCT_ENT;

CREATE OR REPLACE PROCEDURE CPI.gicls032_aeg_ins_giac_acct_ent (
   p_claim_id         gicl_advice.claim_id%TYPE,
   p_advice_id        gicl_advice.advice_id%TYPE,
   p_iss_cd           gicl_advice.iss_cd%TYPE,
   p_user_id          giis_users.user_id%TYPE,
   p_tran_id          giac_payt_requests_dtl.tran_id%TYPE,
   p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE,
   p_payee_class_cd   gicl_clm_loss_exp.payee_class_cd%TYPE
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - aeg_ins_updt_giac_acct_entries
   */
   
   CURSOR cur_acct_entries
   IS
      SELECT   claim_id, advice_id, clm_loss_id, generation_type, gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1,
               gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_type_cd, sl_cd,
               sl_source_cd, SUM (debit_amt) debit_amt, SUM (credit_amt) credit_amt
          FROM gicl_acct_entries
         WHERE claim_id = p_claim_id
           AND advice_id = p_advice_id
           AND payee_cd = p_payee_cd
           AND payee_class_cd = p_payee_class_cd
      GROUP BY claim_id,
               advice_id,
               clm_loss_id,
               generation_type,
               gl_acct_id,
               gl_acct_category,
               gl_control_acct,
               gl_sub_acct_1,
               gl_sub_acct_2,
               gl_sub_acct_3,
               gl_sub_acct_4,
               gl_sub_acct_5,
               gl_sub_acct_6,
               gl_sub_acct_7,
               sl_type_cd,
               sl_cd,
               sl_source_cd;

   v_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE   DEFAULT 0;
   v_fund_cd       giac_parameters.param_value_v%TYPE   := giacp.v ('FUND_CD');
BEGIN
   FOR al IN cur_acct_entries
   LOOP
      v_acct_entry_id := v_acct_entry_id + 1;

      INSERT INTO giac_acct_entries
                  (gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id, gl_acct_id, gl_acct_category,
                   gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
                   gl_sub_acct_6, gl_sub_acct_7, sl_type_cd, sl_cd, sl_source_cd, debit_amt, credit_amt,
                   generation_type, user_id, last_update
                  )
           VALUES (p_tran_id, v_fund_cd, p_iss_cd, v_acct_entry_id, al.gl_acct_id, al.gl_acct_category,
                   al.gl_control_acct, al.gl_sub_acct_1, al.gl_sub_acct_2, al.gl_sub_acct_3, al.gl_sub_acct_4, al.gl_sub_acct_5,
                   al.gl_sub_acct_6, al.gl_sub_acct_7, al.sl_type_cd, al.sl_cd, al.sl_source_cd, al.debit_amt, al.credit_amt,
                   al.generation_type, p_user_id, SYSDATE
                  );
   END LOOP;
   
END;
/


