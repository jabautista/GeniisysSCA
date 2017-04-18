DROP PROCEDURE CPI.GIACS020_POST_FORMS_COMMIT;

CREATE OR REPLACE PROCEDURE CPI.giacs020_post_forms_commit(
	   	  		  					 p_global_tran_source	IN	   VARCHAR2,
									 p_global_or_flag		IN	   VARCHAR2,
									 p_gacc_branch_cd		IN	   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
								     p_gacc_fund_cd			IN	   GIAC_ACCTRANS.gfun_fund_cd%TYPE,
								     p_gacc_tran_id			IN	   GIAC_ACCTRANS.tran_id%TYPE,
								     p_iss_cd				IN	   GIAC_COMM_PAYTS.iss_cd%TYPE,
								     p_prem_seq_no			IN	   GIAC_COMM_PAYTS.prem_seq_no%TYPE,
								     p_intm_no				IN	   GIAC_COMM_PAYTS.intm_no%TYPE,
								     p_record_no			IN	   GIAC_COMM_PAYTS.record_no%TYPE,
								     p_disb_comm			IN	   GIAC_COMM_PAYTS.disb_comm%TYPE,
								     p_drv_comm_amt		  	IN	   NUMBER,
								     p_currency_cd			IN	   GIAC_COMM_PAYTS.currency_cd%TYPE,
								     p_convert_rate			IN	   GIAC_COMM_PAYTS.convert_rate%TYPE,
									 p_var_module_name		IN     VARCHAR2,
									 p_var_module_id		IN     GIAC_MODULES.module_id%TYPE,
									 p_var_gen_type			IN     GIAC_MODULES.generation_type%TYPE,
									 p_var_comm_take_up		IN OUT GIAC_PARAMETERS.param_value_n%TYPE,
									 p_var_v_item_num		IN OUT GIAC_MODULE_ENTRIES.item_no%TYPE,
									 p_var_v_bill_no		IN OUT GIPI_INVOICE.prem_seq_no%TYPE,
									 p_var_v_issue_cd		IN OUT GIPI_INVOICE.iss_cd%TYPE,
									 p_var_sl_type_cd1		IN     GIAC_PARAMETERS.param_name%TYPE,
									 p_var_sl_type_cd2		IN     GIAC_PARAMETERS.param_name%TYPE,
									 p_var_sl_type_cd3		IN     GIAC_PARAMETERS.param_name%TYPE,
									 p_message				   OUT VARCHAR2)
IS
BEGIN
     p_message := 'SUCCESS';
	 IF p_global_tran_source IN ('OP', 'OR') THEN
	   if p_global_or_flag = 'P' THEN
	     NULL;
	   ELSE
	    GIAC_OP_TEXT_PKG.update_giac_op_text_giacs020(p_gacc_tran_id);
	   END IF;
	 END IF;
	
	 DECLARE 	
	 	  v_comm_exp      VARCHAR2(1); 	  
	 BEGIN
	  	
		v_comm_exp := GIAC_PARAMETERS_PKG.v('COMM_EXP_GEN');
	    GIAC_ACCT_ENTRIES_PKG.aeg_delete_acct_entries(p_gacc_tran_id, p_var_gen_type);
	  	IF v_comm_exp = 'Y' THEN
	  		 giacs020_aeg_parameters_y(
			 				p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id, p_iss_cd, p_prem_seq_no,
							p_intm_no, p_record_no, p_disb_comm, p_drv_comm_amt, p_currency_cd, p_convert_rate,
							'GIACS020', p_var_module_id, p_var_gen_type, p_var_comm_take_up,
			 				p_gacc_tran_id, p_var_module_name, NVL(p_var_sl_type_cd1,NULL), NVL(p_var_sl_type_cd2,NULL), NVL(p_var_sl_type_cd3,NULL),
							p_message);
	  	ELSE
	  		 giacs020_aeg_parameters_n(
			 				p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id, p_iss_cd, p_prem_seq_no,
							p_intm_no, p_record_no, p_disb_comm, p_drv_comm_amt, p_currency_cd, p_convert_rate,
							p_var_comm_take_up, p_var_v_item_num, p_var_v_bill_no, p_var_v_issue_cd,
			 				p_gacc_tran_id, p_var_module_name, NVL(p_var_sl_type_cd1,NULL), NVL(p_var_sl_type_cd2,NULL), NVL(p_var_sl_type_cd3,NULL),
							p_message);
	  END IF;		 
	   
	/*
    ** Commented out by reymon 05072013
    ** to fire other exception like geniisys exception
    EXCEPTION
	  WHEN OTHERS THEN
	    NULL;	  
    */
	END;
END;
/


