DROP PROCEDURE CPI.AEG_PARAMETERS_REV;

CREATE OR REPLACE PROCEDURE CPI.AEG_Parameters_Rev(p_aeg_tran_id    giac_acctrans.tran_id%TYPE,
                             p_aeg_module_nm  giac_modules.module_name%TYPE,
							 p_acc_tran_id    giac_acctrans.tran_id%TYPE,
							 p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
							 p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
							 p_message OUT varchar2) IS
  

  CURSOR colln_CUR IS
    SELECT a.assd_no, b.line_cd,
           SUM(premium_amt + tax_amt)coll_amt
      FROM giac_advanced_payt a, gipi_polbasic b
     WHERE gacc_tran_id    = p_aeg_tran_id
       AND a.policy_id     = b.policy_id
       AND a.acct_ent_date IS NOT NULL
     GROUP BY a.assd_no, b.line_cd;
	 
	  v_module_id  giac_modules.module_id%TYPE;
	  v_gen_type   giac_modules.generation_type%TYPE;

BEGIN

  BEGIN
    SELECT module_id, generation_type
    	INTO v_module_id,
           v_gen_type
    	FROM giac_modules
    WHERE module_name  = 'GIACB005';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_message := 'No data found in GIAC MODULES.';
  END;

  AEG_Delete_Entries_Rev(p_acc_tran_id, v_gen_type);       
       
  FOR COLLN_rec IN COLLN_CUR LOOP
    CREATE_REV_ENTRIES(colln_rec.assd_no, colln_rec.coll_amt, colln_rec.line_cd, null, p_aeg_tran_id, p_gibr_gfun_fund_cd, p_gibr_branch_cd, p_acc_tran_id, p_message);
  END LOOP;
         
END;
/


