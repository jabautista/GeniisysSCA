DROP PROCEDURE CPI.GEN_REVERSING_ACCT_ENTRIES;

CREATE OR REPLACE PROCEDURE CPI.gen_reversing_acct_entries(
	    p_gacc_tran_id                 giac_order_of_payts.gacc_tran_id%TYPE,
		p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
   		p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
		p_acc_tran_id      giac_acctrans.tran_id%TYPE
)
 IS
  CURSOR tr_closed IS
    SELECT acct_entry_id, gl_acct_id,
           gl_acct_category, gl_control_acct,
           gl_sub_acct_1, gl_sub_acct_2,
           gl_sub_acct_3, gl_sub_acct_4, 
           gl_sub_acct_5, gl_sub_acct_6, 
           gl_sub_acct_7, sl_cd,
           debit_amt, credit_amt,
           generation_type, sl_type_cd
      FROM giac_acct_entries
      WHERE gacc_tran_id = p_gacc_tran_id;  

  v_debit_amt        giac_acct_entries.debit_amt%TYPE;  
  v_credit_amt       giac_acct_entries.credit_amt%TYPE;  
  v_debit_amt2       giac_acct_entries.debit_amt%TYPE;  
  v_credit_amt2      giac_acct_entries.credit_amt%TYPE;  
  v_acct_entry_id    giac_acct_entries.acct_entry_id%TYPE;

BEGIN
  FOR tr_closed_rec IN tr_closed LOOP
    FOR entr_id in (
        SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
          FROM giac_acct_entries
          WHERE gacc_gibr_branch_cd = p_gibr_branch_cd
          AND gacc_gfun_fund_cd = p_gibr_gfun_fund_cd
          AND gacc_tran_id = p_acc_tran_id
          AND nvl(gl_acct_id, gl_acct_id) = tr_closed_rec.gl_acct_id -- grace 02.01.2007 for optimization purpose
          AND NVL(sl_cd, 0) = NVL(tr_closed_rec.sl_cd, NVL(sl_cd, 0))
          AND NVL(sl_type_cd, '-') = NVL(tr_closed_rec.sl_type_cd, NVL(sl_type_cd, '-'))
          AND generation_type = tr_closed_rec.generation_type) LOOP
      v_acct_entry_id := entr_id.acct_entry_id;
      EXIT;
    END LOOP;
     
    IF NVL(v_acct_entry_id,0) = 0 THEN
      v_acct_entry_id := NVL(v_acct_entry_id,0) + 1;

      INSERT into GIAC_ACCT_ENTRIES(
                   gacc_tran_id, gacc_gfun_fund_cd,
                   gacc_gibr_branch_cd, gl_acct_id, 
                   gl_acct_category, gl_control_acct,
                   gl_sub_acct_1, gl_sub_acct_2, 
                   gl_sub_acct_3, gl_sub_acct_4, 
                   gl_sub_acct_5, gl_sub_acct_6, 
                   gl_sub_acct_7, sl_cd, 
                   debit_amt, credit_amt, 
                   generation_type, user_id, 
                   last_update, sl_type_cd)
        VALUES(p_acc_tran_id, p_gibr_gfun_fund_cd,
               p_gibr_branch_cd, tr_closed_rec.gl_acct_id, 
               tr_closed_rec.gl_acct_category, tr_closed_rec.gl_control_acct, 
               tr_closed_rec.gl_sub_acct_1, tr_closed_rec.gl_sub_acct_2, 
               tr_closed_rec.gl_sub_acct_3, tr_closed_rec.gl_sub_acct_4,  
               tr_closed_rec.gl_sub_acct_5, tr_closed_rec.gl_sub_acct_6,  
               tr_closed_rec.gl_sub_acct_7, tr_closed_rec.sl_cd,
               tr_closed_rec.credit_amt, tr_closed_rec.debit_amt, 
               tr_closed_rec.generation_type, NVL (giis_users_pkg.app_user, USER), 
               SYSDATE, tr_closed_rec.sl_type_cd);
      ELSE
        UPDATE giac_acct_entries
          SET debit_amt  = debit_amt  + tr_closed_rec.credit_amt,
              credit_amt = credit_amt + tr_closed_rec.debit_amt
          WHERE gacc_gfun_fund_cd = p_gibr_gfun_fund_cd 
          AND gacc_gibr_branch_cd = p_gibr_branch_cd
          AND nvl(gl_acct_id, gl_acct_id) = tr_closed_rec.gl_acct_id 
          AND gacc_tran_id = p_acc_tran_id
          AND NVL(sl_cd, 0) = NVL(tr_closed_rec.sl_cd, NVL(sl_cd, 0))
          AND NVL(sl_type_cd, '-') = NVL(tr_closed_rec.sl_type_cd, NVL(sl_type_cd, '-'))
          AND generation_type = tr_closed_rec.generation_type;
      END IF; 
  END LOOP;
END;
/


