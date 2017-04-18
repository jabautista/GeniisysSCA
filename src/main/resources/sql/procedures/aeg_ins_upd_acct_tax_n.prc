DROP PROCEDURE CPI.AEG_INS_UPD_ACCT_TAX_N;

CREATE OR REPLACE PROCEDURE CPI.aeg_ins_upd_acct_tax_n (
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
   p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
   p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
   p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
)
IS
   iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
BEGIN
   SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
     INTO iuae_acct_entry_id
     FROM giac_acct_entries
    WHERE gacc_gibr_branch_cd = p_giop_gacc_branch_cd
      AND gacc_gfun_fund_cd = p_giop_gacc_fund_cd
      AND gacc_tran_id = p_giop_gacc_tran_id
      AND generation_type = iuae_generation_type
      AND NVL (gl_acct_id, gl_acct_id) = iuae_gl_acct_id;

--msg_alert('ok','i',false);
   IF NVL (iuae_acct_entry_id, 0) = 0
   THEN
--msg_alert('insert...','I',FALSE);
      iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

      INSERT INTO giac_acct_entries
                  (gacc_tran_id, gacc_gfun_fund_cd,
                   gacc_gibr_branch_cd, acct_entry_id,
                   gl_acct_id, gl_acct_category,
                   gl_control_acct, gl_sub_acct_1,
                   gl_sub_acct_2, gl_sub_acct_3,
                   gl_sub_acct_4, gl_sub_acct_5,
                   gl_sub_acct_6, gl_sub_acct_7, sl_cd,
                   debit_amt, credit_amt, generation_type,
                   user_id, last_update
                  )
           VALUES (p_giop_gacc_tran_id, p_giop_gacc_fund_cd,
                   p_giop_gacc_branch_cd, iuae_acct_entry_id,
                   iuae_gl_acct_id, iuae_gl_acct_category,
                   iuae_gl_control_acct, iuae_gl_sub_acct_1,
                   iuae_gl_sub_acct_2, iuae_gl_sub_acct_3,
                   iuae_gl_sub_acct_4, iuae_gl_sub_acct_5,
                   iuae_gl_sub_acct_6, iuae_gl_sub_acct_7, iuae_sl_cd,
                   iuae_debit_amt, iuae_credit_amt, iuae_generation_type,
                   NVL(giis_users_pkg.app_user, USER), SYSDATE
                  );
   ELSE
--msg_alert('update...','I',FALSE);
      UPDATE giac_acct_entries
         SET debit_amt = debit_amt + iuae_debit_amt,
             credit_amt = credit_amt + iuae_credit_amt
       WHERE generation_type = iuae_generation_type
         AND NVL (gl_acct_id, gl_acct_id) =
                   iuae_gl_acct_id
                                  -- grace 02.01.2007 for optimization purpose
         AND gacc_gibr_branch_cd = p_giop_gacc_branch_cd
         AND gacc_gfun_fund_cd = p_giop_gacc_fund_cd
         AND gacc_tran_id = p_giop_gacc_tran_id;
   END IF;
--msg_alert('done...','I',FALSE);
END;
/


