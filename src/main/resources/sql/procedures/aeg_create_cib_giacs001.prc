DROP PROCEDURE CPI.AEG_CREATE_CIB_GIACS001;

CREATE OR REPLACE PROCEDURE CPI.aeg_create_cib_GIACS001 
  (p_bank_cd     	 giac_banks.bank_cd%TYPE,
   p_bank_acct_cd  giac_bank_accounts.bank_acct_cd%TYPE,
   p_acct_amt    	 giac_collection_dtl.amount%TYPE,
   p_gen_type		 	 giac_acct_entries.generation_type%TYPE,
   p_gacc_tran_id   giac_acct_entries.gacc_tran_id%TYPE,
   p_branch_cd	    giac_acct_entries.gacc_gibr_branch_cd%TYPE,	
   p_fund_cd	    giac_acct_entries.gacc_gfun_fund_cd%TYPE,
   p_message	OUT  varchar2
   
	) IS

  v_gl_acct_category  giac_acct_entries.gl_acct_category%TYPE;
  v_gl_control_acct   giac_acct_entries.gl_control_acct%TYPE;
  v_gl_sub_acct_1     giac_acct_entries.gl_sub_acct_1%TYPE;
  v_gl_sub_acct_2     giac_acct_entries.gl_sub_acct_2%TYPE;
  v_gl_sub_acct_3     giac_acct_entries.gl_sub_acct_3%TYPE;
  v_gl_sub_acct_4     giac_acct_entries.gl_sub_acct_4%TYPE;
  v_gl_sub_acct_5     giac_acct_entries.gl_sub_acct_5%TYPE;
  v_gl_sub_acct_6     giac_acct_entries.gl_sub_acct_6%TYPE;
  v_gl_sub_acct_7     giac_acct_entries.gl_sub_acct_7%TYPE;
  v_dr_cr_tag         giac_chart_of_accts.dr_cr_tag%TYPE;
  v_debit_amt         giac_acct_entries.debit_amt%TYPE;
  v_credit_amt        giac_acct_entries.credit_amt%TYPE;
  v_gl_acct_id        giac_acct_entries.gl_acct_id%TYPE;
  v_sl_cd             giac_acct_entries.sl_cd%TYPE;
  v_sl_type_cd        giac_acct_entries.sl_type_cd%TYPE;
	v_acct_entry_id     giac_acct_entries.acct_entry_id%TYPE;
  v_sl_source_cd      giac_acct_entries.sl_source_cd%TYPE := '1';
  
BEGIN
  BEGIN
    SELECT gl_acct_id, sl_cd
      INTO v_gl_acct_id, v_sl_cd
      FROM giac_bank_accounts
      WHERE bank_cd = p_bank_cd
      AND bank_acct_cd = p_bank_acct_cd;
  EXCEPTION
    WHEN no_data_found THEN
      p_message := 'No data found in giac_bank_accounts for bank_cd/bank_acct_cd: '||p_bank_cd||'/'||p_bank_acct_cd;
  END;

	BEGIN
		SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
           gl_sub_acct_2,    gl_sub_acct_3,   gl_sub_acct_4,
           gl_sub_acct_5,    gl_sub_acct_6,   gl_sub_acct_7,
           dr_cr_tag,        gslt_sl_type_cd
      INTO v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1,
  				 v_gl_sub_acct_2,    v_gl_sub_acct_3,   v_gl_sub_acct_4,
  				 v_gl_sub_acct_5,    v_gl_sub_acct_6,   v_gl_sub_acct_7,
  				 v_dr_cr_tag,        v_sl_type_cd
  		FROM giac_chart_of_accts
  	 WHERE gl_acct_id = v_gl_acct_id;
	EXCEPTION
		WHEN no_data_found THEN
			p_message := 'No record in the Chart of Accounts for this GL ID '||to_char(v_gl_acct_id,'fm999999');
	END;

  /****************************************************************************
  * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
  * debit-credit tag to determine whether the positive amount will be debited *
  * or credited.                                                              *
  ****************************************************************************/

  IF v_dr_cr_tag = 'D' THEN
    v_debit_amt  := abs(p_acct_amt);
    v_credit_amt := 0;
  ELSE
    v_debit_amt  := 0;
    v_credit_amt := abs(p_acct_amt);
  END IF;

  /****************************************************************************
  * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
  * same transaction id.  Insert the record if it does not exists else update *
  * the existing record.                                                      *
  ****************************************************************************/

	BEGIN
	  SELECT nvl(max(acct_entry_id),0) acct_entry_id
	    INTO v_acct_entry_id
	    FROM giac_acct_entries
     WHERE gacc_gibr_branch_cd = p_branch_cd 
       AND gacc_gfun_fund_cd   = p_fund_cd 
       AND gacc_tran_id        = p_gacc_tran_id 
       AND NVL(gl_acct_id,gl_acct_id) = v_gl_acct_id --totel--1/30/2008--Tune--Added NVL function
       AND generation_type     = p_gen_type
	     AND nvl(sl_cd, 0)          = nvl(v_sl_cd, nvl(sl_cd, 0))
	     AND nvl(sl_type_cd, '-')   = nvl(v_sl_type_cd, nvl(sl_type_cd, '-'))
	     AND nvl(sl_source_cd, '-') = nvl(v_sl_source_cd, nvl(sl_source_cd, '-'));
	        
	  IF nvl(v_acct_entry_id,0) = 0 THEN
	    v_acct_entry_id := nvl(v_acct_entry_id,0) + 1;
	    INSERT INTO giac_acct_entries(gacc_tran_id,        gacc_gfun_fund_cd,
	                                  gacc_gibr_branch_cd, acct_entry_id,
	                                  gl_acct_id,          gl_acct_category,
	                                  gl_control_acct,     gl_sub_acct_1,
	                                  gl_sub_acct_2,       gl_sub_acct_3,
	                                  gl_sub_acct_4,       gl_sub_acct_5,
	                                  gl_sub_acct_6,       gl_sub_acct_7,
	                                  sl_cd,               debit_amt,
	                                  credit_amt,          generation_type,
	                                  user_id,             last_update,
	                                  sl_type_cd,          sl_source_cd)
	         VALUES (p_gacc_tran_id,   p_fund_cd,
	                 p_branch_cd, v_acct_entry_id,
	                 v_gl_acct_id,                   v_gl_acct_category,
	                 v_gl_control_acct,              v_gl_sub_acct_1,
	                 v_gl_sub_acct_2,                v_gl_sub_acct_3,
	                 v_gl_sub_acct_4,                v_gl_sub_acct_5,
	                 v_gl_sub_acct_6,                v_gl_sub_acct_7,
	                 v_sl_cd,                        v_debit_amt,
	                 v_credit_amt,                   p_gen_type,
	                 NVL(giis_users_pkg.app_user, USER),                           SYSDATE,
	                 v_sl_type_cd ,                  v_sl_source_cd);
	  ELSE
	    UPDATE giac_acct_entries
	      SET debit_amt  = debit_amt  + v_debit_amt,
	          credit_amt = credit_amt + v_credit_amt,
	          user_id = NVL(giis_users_pkg.app_user, USER),
	          last_update = SYSDATE
	    WHERE gacc_tran_id       = p_gacc_tran_id
	      AND gacc_gibr_branch_cd  = p_branch_cd
	      AND gacc_gfun_fund_cd    = p_fund_cd
	      AND gl_acct_id           = v_gl_acct_id
	      AND nvl(sl_cd, 0)        = nvl(v_sl_cd, nvl(sl_cd, 0))
	      AND nvl(sl_type_cd, '-') = nvl(v_sl_type_cd, nvl(sl_type_cd, '-'))
	      AND nvl(sl_source_cd, '-') = nvl(v_sl_source_cd, nvl(sl_source_cd, '-'))
	      AND generation_type      = p_gen_type;
	  END IF;
	END;				                         
END;
/


