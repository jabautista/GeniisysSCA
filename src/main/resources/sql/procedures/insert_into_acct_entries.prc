DROP PROCEDURE CPI.INSERT_INTO_ACCT_ENTRIES;

CREATE OR REPLACE PROCEDURE CPI.insert_into_acct_entries(
	   	  		  p_gacc_tran_id                 giac_order_of_payts.gacc_tran_id%TYPE,
				  p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
   				  p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
				  p_acc_tran_id					 giac_acctrans.tran_id%TYPE,	
				  p_item_no 				  	 giac_module_entries.item_no%TYPE,		
				  p_module_name				  	 varchar2,	 
				  p_message			OUT			 varchar2
		  ) 
IS
  
  v_tran_flag     giac_acctrans.tran_flag%TYPE;
BEGIN
  v_tran_flag := get_tran_flag(p_gacc_tran_id);

  IF v_tran_flag IN ('C', 'P') THEN
    gen_reversing_acct_entries(p_gacc_tran_id, p_gibr_gfun_fund_cd, p_gibr_branch_cd, p_acc_tran_id);
  ELSE
    force_close_acct_entries(p_gacc_tran_id, p_gibr_gfun_fund_cd, p_gibr_branch_cd, p_item_no, p_module_name, p_message);
	gen_reversing_acct_entries(p_gacc_tran_id, p_gibr_gfun_fund_cd, p_gibr_branch_cd, p_acc_tran_id);

    BEGIN
      UPDATE giac_acctrans
      SET tran_flag = 'C'
      WHERE tran_id = p_gacc_tran_id;

      IF SQL%NOTFOUND THEN   -- IF SQL%FOUND THEN   
        p_message := 'Error locating tran_id.';
      END IF;
    END;
  END IF;
END;
/


