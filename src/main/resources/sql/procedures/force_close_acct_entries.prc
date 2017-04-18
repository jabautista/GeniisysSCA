DROP PROCEDURE CPI.FORCE_CLOSE_ACCT_ENTRIES;

CREATE OR REPLACE PROCEDURE CPI.force_close_acct_entries(
	   	  		  p_gacc_tran_id                 giac_order_of_payts.gacc_tran_id%TYPE,
				  p_gibr_gfun_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
   				  p_gibr_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
				  p_item_no 				  giac_module_entries.item_no%TYPE,
				  p_module_name				  varchar2,
				  p_message				OUT	  varchar2
)
 IS

  v_module_id          giac_modules.module_id%TYPE;
  v_generation_type    giac_modules.generation_type%TYPE;
  v_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE;
  v_gl_acct_category   giac_module_entries.gl_acct_category%TYPE;
  v_gl_control_acct    giac_module_entries.gl_control_acct%TYPE;
  v_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%TYPE;
  v_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%TYPE;
  v_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%TYPE;
  v_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%TYPE;
  v_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%TYPE;
  v_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%TYPE;
  v_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%TYPE;
  v_sl_type_cd         giac_module_entries.sl_type_cd%TYPE;
  v_balance            giac_acct_entries.debit_amt%TYPE;
  v_debit_amt          giac_acct_entries.debit_amt%TYPE;
  v_credit_amt         giac_acct_entries.credit_amt%TYPE;
  v_acct_entry_id      giac_acct_entries.acct_entry_id%TYPE;

BEGIN
  FOR id IN (SELECT module_id, generation_type
               FROM giac_modules
               WHERE UPPER(module_name) = p_module_name) LOOP
    v_module_id := id.module_id;
    v_generation_type := id.generation_type;
    EXIT;
  END LOOP;

  IF v_module_id IS NULL THEN
    p_message := 'Cancel OR: Module ID not found.';
  ELSE
    FOR mod_entr IN (
           SELECT gime.gl_acct_category, gime.gl_control_acct,
                  gime.gl_sub_acct_1, gime.gl_sub_acct_2,
                  gime.gl_sub_acct_3, gime.gl_sub_acct_4,
                  gime.gl_sub_acct_5, gime.gl_sub_acct_6,
                  gime.gl_sub_acct_7, gime.sl_type_cd,
                  gcoa.gl_acct_id
             FROM giac_chart_of_accts gcoa,
                  giac_modules gimod,
                  giac_module_entries gime
             WHERE gcoa.gl_control_acct = gime.gl_control_acct
             AND gcoa.gl_sub_acct_1 = gime.gl_sub_acct_1
             AND gcoa.gl_sub_acct_2 = gime.gl_sub_acct_2
             AND gcoa.gl_sub_acct_3 = gime.gl_sub_acct_3
             AND gcoa.gl_sub_acct_4 = gime.gl_sub_acct_4
             AND gcoa.gl_sub_acct_5 = gime.gl_sub_acct_5
             AND gcoa.gl_sub_acct_6 = gime.gl_sub_acct_6
             AND gcoa.gl_sub_acct_7 = gime.gl_sub_acct_7
             AND gcoa.leaf_tag = 'Y'
             AND gime.item_no = p_item_no
             AND gimod.module_id = gime.module_id
             AND gime.module_id = v_module_id) LOOP
      v_gl_acct_id := mod_entr.gl_acct_id;
      v_gl_acct_category := mod_entr.gl_acct_category;
      v_gl_control_acct := mod_entr.gl_control_acct;
      v_gl_sub_acct_1 := mod_entr.gl_sub_acct_1;
      v_gl_sub_acct_2 := mod_entr.gl_sub_acct_2;
      v_gl_sub_acct_3 := mod_entr.gl_sub_acct_3;
      v_gl_sub_acct_4 := mod_entr.gl_sub_acct_4;
      v_gl_sub_acct_5 := mod_entr.gl_sub_acct_5;
      v_gl_sub_acct_6 := mod_entr.gl_sub_acct_6;
      v_gl_sub_acct_7 := mod_entr.gl_sub_acct_7;
      EXIT;
    END LOOP;
      
    IF v_gl_acct_id IS NULL THEN
      p_message := 'Cancel OR: Error locating GL acct in ' || 'module_entries/chart_of_accts.';
    ELSE
      FOR dr_cr IN (SELECT NVL(SUM(debit_amt) - SUM(credit_amt),0) bal
                      FROM giac_acct_entries
                      WHERE gacc_tran_id = p_gacc_tran_id) LOOP
        v_balance := dr_cr.bal;
        EXIT;
      END LOOP;
      
      IF v_balance > 0 THEN
        v_credit_amt := ABS(v_balance);
        v_debit_amt := 0;
      ELSIF v_balance < 0 THEN
        v_credit_amt := 0;
        v_debit_amt := ABS(v_balance);
      END IF;
      
                         
      IF v_balance <> 0 THEN 
        FOR entr_id in (
          SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
            FROM giac_acct_entries
            WHERE gacc_gibr_branch_cd = p_gibr_branch_cd
            AND gacc_gfun_fund_cd = p_gibr_gfun_fund_cd
            AND gacc_tran_id = p_gacc_tran_id
            AND nvl(gl_acct_id, gl_acct_id) = v_gl_acct_id -- grace 02.01.2007 for optimization purpose
            AND generation_type = v_generation_type) LOOP
          v_acct_entry_id := entr_id.acct_entry_id;
          EXIT;
        END LOOP;
            
        IF NVL(v_acct_entry_id,0) = 0 THEN
          v_acct_entry_id := NVL(v_acct_entry_id,0) + 1;
                   
          INSERT into GIAC_ACCT_ENTRIES(
                       gacc_tran_id, gacc_gfun_fund_cd,
                       gacc_gibr_branch_cd, acct_entry_id,
                       gl_acct_id, gl_acct_category,
                       gl_control_acct, gl_sub_acct_1,
                       gl_sub_acct_2, gl_sub_acct_3,
                       gl_sub_acct_4, gl_sub_acct_5,
                       gl_sub_acct_6, gl_sub_acct_7,
                       sl_cd, debit_amt, credit_amt, 
                       generation_type, user_id, 
                       last_update)
            VALUES(p_gacc_tran_id, p_gibr_gfun_fund_cd,
                   p_gibr_branch_cd, v_acct_entry_id,
                   v_gl_acct_id, v_gl_acct_category, 
                   v_gl_control_acct, v_gl_sub_acct_1, 
                   v_gl_sub_acct_2, v_gl_sub_acct_3, 
                   v_gl_sub_acct_4, v_gl_sub_acct_5,  
                   v_gl_sub_acct_6, v_gl_sub_acct_7,  
                   NULL, v_debit_amt, 
                   v_credit_amt, v_generation_type,
                   NVL (giis_users_pkg.app_user, USER), SYSDATE);
        ELSE
          UPDATE giac_acct_entries
            SET debit_amt  = debit_amt  + v_debit_amt,
                credit_amt = credit_amt + v_credit_amt
            WHERE generation_type = v_generation_type
            AND nvl(gl_acct_id, gl_acct_id) = v_gl_acct_id -- grace 02.01.2007 for optimization purpose
            AND gacc_gibr_branch_cd = p_gibr_branch_cd
            AND gacc_gfun_fund_cd = p_gibr_gfun_fund_cd 
            AND gacc_tran_id = p_gacc_tran_id ;
        END IF; -- acct_entry_id = 0
      ELSE
        NULL;
      END IF; -- v_balance <> 0
    END IF;   -- gl_acct_id IS NULL
  END IF; -- module_id IS NULL
END;
/


