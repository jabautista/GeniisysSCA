DROP PROCEDURE CPI.AEG_INS_UPDT_GIAC_ACCT_ENT2;

CREATE OR REPLACE PROCEDURE CPI.aeg_ins_updt_giac_acct_ent2 (
   p_tran_id       IN   giac_acctrans.tran_id%TYPE,
   p_iss_cd        IN   gicl_claims.iss_cd%TYPE,
   p_ri_iss_cd     IN   gicl_claims.iss_cd%TYPE,
   p_batch_dv_id        giac_batch_dv.batch_dv_id%TYPE,
   p_fund_cd       IN   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
   p_user_id       IN   giis_users.user_id%TYPE
)
IS
   /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  12.26.2011
   **  Reference By : (GICLS086 - Special Claim Settlement Request)
   **  Description  : Executes Aeg_Ins_Updt_Giac_Acct_Entries
   **                program unit in GICLS086
   **
   */
   CURSOR cur_acct_entries
   IS
      SELECT   iss_cd, generation_type, gl_acct_id, gl_acct_category,
               gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
               gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
               sl_type_cd, sl_cd, sl_source_cd, SUM (debit_amt) debit_amt,
               SUM (credit_amt) credit_amt
          FROM gicl_acct_entries a, gicl_claims b
         WHERE batch_dv_id = p_batch_dv_id
           AND iss_cd IN (p_iss_cd, p_ri_iss_cd)
           AND a.claim_id = b.claim_id
      GROUP BY iss_cd,
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
BEGIN
   FOR al IN cur_acct_entries
   LOOP
      v_acct_entry_id := v_acct_entry_id + 1;

      INSERT INTO giac_acct_entries
                  (gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                   acct_entry_id, gl_acct_id, gl_acct_category,
                   gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
                   gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
                   gl_sub_acct_6, gl_sub_acct_7, sl_type_cd,
                   sl_cd, sl_source_cd, debit_amt, credit_amt,
                   generation_type, user_id, last_update
                  )
           VALUES (p_tran_id, p_fund_cd, p_iss_cd,
                   v_acct_entry_id, al.gl_acct_id, al.gl_acct_category,
                   al.gl_control_acct, al.gl_sub_acct_1, al.gl_sub_acct_2,
                   al.gl_sub_acct_3, al.gl_sub_acct_4, al.gl_sub_acct_5,
                   al.gl_sub_acct_6, al.gl_sub_acct_7, al.sl_type_cd,
                   al.sl_cd, al.sl_source_cd, al.debit_amt, al.credit_amt,
                   al.generation_type, p_user_id, SYSDATE
                  );
   END LOOP;
END;
/


