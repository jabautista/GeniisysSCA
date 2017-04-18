CREATE OR REPLACE PACKAGE CPI.GIAC_INW_CLAIM_PAYTS_PKG
AS

  TYPE giac_inw_claim_payts_type IS RECORD(
  	   gacc_tran_id				 		   		  GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
	   claim_id									  GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
	   clm_loss_id								  GIAC_INW_CLAIM_PAYTS.clm_loss_id%TYPE,
	   or_print_tag								  GIAC_INW_CLAIM_PAYTS.or_print_tag%TYPE,
	   transaction_type							  GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE, 
	   advice_id								  GIAC_INW_CLAIM_PAYTS.advice_id%TYPE,
	   payee_type								  GIAC_INW_CLAIM_PAYTS.payee_type%TYPE,
	   dsp_payee_desc							  VARCHAR2(30), 
	   payee_class_cd  							  GIAC_INW_CLAIM_PAYTS.payee_class_cd%TYPE, 
	   payee_cd									  GIAC_INW_CLAIM_PAYTS.payee_cd%TYPE,
	   dsp_payee_name							  VARCHAR2(800),
	   disbursement_amt							  GIAC_INW_CLAIM_PAYTS.disbursement_amt%TYPE,
	   input_vat_amt  							  GIAC_INW_CLAIM_PAYTS.input_vat_amt%TYPE, 
	   wholding_tax_amt							  GIAC_INW_CLAIM_PAYTS.wholding_tax_amt%TYPE, 
	   net_disb_amt								  GIAC_INW_CLAIM_PAYTS.net_disb_amt%TYPE,
	   remarks									  GIAC_INW_CLAIM_PAYTS.remarks%TYPE, 
	   user_id									  GIAC_INW_CLAIM_PAYTS.user_id%TYPE, 
	   last_update								  GIAC_INW_CLAIM_PAYTS.last_update%TYPE,
	   currency_cd								  GIAC_INW_CLAIM_PAYTS.currency_cd%TYPE,
	   curr_desc								  GIIS_CURRENCY.currency_desc%TYPE,
	   convert_rate								  GIAC_INW_CLAIM_PAYTS.convert_rate%TYPE, 
	   foreign_curr_amt							  GIAC_INW_CLAIM_PAYTS.foreign_curr_amt%TYPE,
	   dsp_line_cd								  GICL_ADVICE.line_cd%TYPE,
	   dsp_iss_cd								  GICL_ADVICE.iss_cd%TYPE,
	   dsp_advice_year							  GICL_ADVICE.advice_year%TYPE,
	   dsp_advice_seq_no						  GICL_ADVICE.advice_seq_no%TYPE,
	   dsp_peril_name							  GIIS_PERIL.peril_name%TYPE,
	   dsp_peril_sname							  GIIS_PERIL.peril_sname%TYPE,
	   dsp_claim_no								  VARCHAR2(30),
	   dsp_policy_no							  VARCHAR2(30),
	   dsp_assured_name							  GICL_CLAIMS.assured_name%TYPE,
	   v_check									  NUMBER(1)
  );
  
  TYPE advice_year_type IS RECORD(
  	   advice_year		   GICL_ADVICE.advice_year%TYPE
  );
  
  TYPE advice_seq_no_type IS RECORD(
  	   advice_seq_no	  GICL_ADVICE.advice_seq_no%TYPE,
	   claim_id			  GICL_ADVICE.claim_id%TYPE,
	   advice_id		  GICL_ADVICE.advice_id%TYPE
  );
  
  TYPE clm_loss_id_lov_type IS RECORD(
  	   clm_loss_id		  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
	   payee_type		  GICL_CLM_LOSS_EXP.payee_type%TYPE,
	   dsp_payee_desc	  VARCHAR2(10),
	   payee_class_cd	  GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
	   payee_cd			  GICL_CLM_LOSS_EXP.payee_cd%TYPE,
	   dsp_payee_name	  VARCHAR2(200),
	   peril_cd			  GICL_CLM_LOSS_EXP.peril_cd%TYPE,
	   dsp_peril_name	  GIIS_PERIL.peril_name%TYPE,
	   dsp_peril_sname	  GIIS_PERIL.peril_sname%TYPE,
	   net_amt			  GICL_CLM_LOSS_EXP.net_amt%TYPE,
	   paid_amt			  GICL_CLM_LOSS_EXP.paid_amt%TYPE,
	   advise_amt		  GICL_CLM_LOSS_EXP.advise_amt%TYPE
  );
  
  TYPE giac_inw_claim_payts_tab IS TABLE OF giac_inw_claim_payts_type;
  
  TYPE advice_year_tab IS TABLE OF advice_year_type;
  
  TYPE advice_seq_no_tab IS TABLE OF advice_seq_no_type;
  
  TYPE clm_loss_id_lov_tab IS TABLE OF clm_loss_id_lov_type;
  
  FUNCTION get_giac_inw_claim_payts (p_gacc_tran_id		GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE)
     RETURN giac_inw_claim_payts_tab PIPELINED;
	 
  PROCEDURE set_giac_inw_claim_payts (p_gacc_tran_id		GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
  		   							 p_claim_id				GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
									 p_clm_loss_id			GIAC_INW_CLAIM_PAYTS.clm_loss_id%TYPE,
									 p_transaction_type		GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
									 p_advice_id			GIAC_INW_CLAIM_PAYTS.advice_id%TYPE,
									 p_payee_cd				GIAC_INW_CLAIM_PAYTS.payee_cd%TYPE,
									 p_payee_class_cd		GIAC_INW_CLAIM_PAYTS.payee_class_cd%TYPE,
									 p_payee_type			GIAC_INW_CLAIM_PAYTS.payee_type%TYPE,
									 p_disbursement_amt		GIAC_INW_CLAIM_PAYTS.disbursement_amt%TYPE,
									 p_currency_cd			GIAC_INW_CLAIM_PAYTS.currency_cd%TYPE,
									 p_convert_rate			GIAC_INW_CLAIM_PAYTS.convert_rate%TYPE,
									 p_foreign_curr_amt		GIAC_INW_CLAIM_PAYTS.foreign_curr_amt%TYPE,
									 p_or_print_tag			GIAC_INW_CLAIM_PAYTS.or_print_tag%TYPE,
									 p_last_update			GIAC_INW_CLAIM_PAYTS.last_update%TYPE,
									 p_user_id				GIAC_INW_CLAIM_PAYTS.user_id%TYPE,
									 p_remarks				GIAC_INW_CLAIM_PAYTS.remarks%TYPE,
									 p_input_vat_amt		GIAC_INW_CLAIM_PAYTS.input_vat_amt%TYPE,
									 p_wholding_tax_amt		GIAC_INW_CLAIM_PAYTS.wholding_tax_amt%TYPE,
									 p_net_disb_amt			GIAC_INW_CLAIM_PAYTS.net_disb_amt%TYPE);
									 
  PROCEDURE del_giac_inw_claim_payts (p_gacc_tran_id		GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
  		   							  p_claim_id			GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
									  p_clm_loss_id			GIAC_INW_CLAIM_PAYTS.clm_loss_id%TYPE);
	 
  FUNCTION get_advice_year_listing (p_tran_type			GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
  		   						    p_line_cd			GICL_ADVICE.line_cd%TYPE,
									p_iss_cd			GICL_ADVICE.iss_cd%TYPE,
									p_module_name		GIAC_MODULES.module_name%TYPE,
                                    p_user_id           GIIS_USERS.user_id%TYPE)
	 RETURN advice_year_tab PIPELINED;
	 
  FUNCTION get_advice_seq_no_listing (p_tran_type		GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
  		   						      p_line_cd			GICL_ADVICE.line_cd%TYPE,
									  p_iss_cd			GICL_ADVICE.iss_cd%TYPE,
									  p_advice_year		GICL_ADVICE.advice_year%TYPE,
									  p_module_name		GIAC_MODULES.module_name%TYPE,
                                      p_user_id         GIIS_USERS.user_id%TYPE)
	 RETURN advice_seq_no_tab PIPELINED;
	 
  PROCEDURE get_claim_policy_and_assured (p_claim_id	   IN  GICL_CLAIMS.claim_id%TYPE,
  										  p_claim_no	   OUT VARCHAR2,
										  p_policy_no	   OUT VARCHAR2,
										  p_assured_name   OUT GICL_CLAIMS.assured_name%TYPE,
										  p_message		   OUT VARCHAR2);
										  
  FUNCTION get_clm_loss_id_lov_listing (p_tran_type		GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
  		   						        p_line_cd		GICL_ADVICE.line_cd%TYPE,
										p_claim_id		GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
										p_advice_id		GIAC_INW_CLAIM_PAYTS.advice_id%TYPE)
    RETURN clm_loss_id_lov_tab PIPELINED;
	
  PROCEDURE validate_giacs018_payee(p_gacc_tran_id			IN     GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
		  						  p_transaction_type		IN	   GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
		  						  p_claim_id				IN	   GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
								  p_clm_loss_id				IN	   GIAC_INW_CLAIM_PAYTS.clm_loss_id%TYPE,
								  p_advice_id				IN	   GIAC_INW_CLAIM_PAYTS.advice_id%TYPE,
								  p_input_vat_amt			IN OUT GIAC_INW_CLAIM_PAYTS.input_vat_amt%TYPE,
								  p_wholding_tax_amt		IN OUT GIAC_INW_CLAIM_PAYTS.wholding_tax_amt%TYPE,
								  p_net_disb_amt			IN OUT GIAC_INW_CLAIM_PAYTS.net_disb_amt%TYPE,
								  p_v_check					   OUT NUMBER);
								  
  PROCEDURE execute_giacs018_key_delrec(p_gacc_tran_id			GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
		  							  p_transaction_type		GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
									  p_claim_id				GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
									  p_advice_id				GIAC_INW_CLAIM_PAYTS.advice_id%TYPE,
									  p_var_gen_type			GIAC_MODULES.generation_type%TYPE);
									  
  PROCEDURE execute_giacs018_pre_insert(p_payee_class_cd		IN     GIAC_INW_CLAIM_PAYTS.payee_class_cd%TYPE,
  									    p_payee_cd				IN	   GIAC_INW_CLAIM_PAYTS.payee_cd%TYPE,
										p_transaction_type		IN	   GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
										p_claim_id				IN	   GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
										p_advice_id				IN	   GIAC_INW_CLAIM_PAYTS.advice_id%TYPE,
										p_currency_cd			IN OUT GIAC_INW_CLAIM_PAYTS.currency_cd%TYPE,
										p_convert_rate			IN OUT GIAC_INW_CLAIM_PAYTS.convert_rate%TYPE,
										p_foreign_curr_amt		IN OUT GIAC_INW_CLAIM_PAYTS.foreign_curr_amt%TYPE,
										p_message				   OUT VARCHAR2);
	
  PROCEDURE execute_giacs018_post_insert(p_transaction_type		GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
									     p_claim_id				GIAC_INW_CLAIM_PAYTS.claim_id%TYPE,
									     p_advice_id			GIAC_INW_CLAIM_PAYTS.advice_id%TYPE);
										 
  PROCEDURE giacs018_post_forms_commit(p_gacc_tran_id			IN     GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
		  							   p_gacc_branch_cd         IN	   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
									   p_gacc_fund_cd          	IN	   GIAC_ACCTRANS.gfun_fund_cd%TYPE,
		  							   p_tran_source			IN	   VARCHAR2,
									   p_or_flag				IN	   VARCHAR2,
									   p_var_module_name		IN OUT GIAC_MODULES.module_name%TYPE,
									   p_var_gen_type			IN OUT GIAC_MODULES.generation_type%TYPE,
									   p_message				   OUT VARCHAR2);
									   
  PROCEDURE insert_into_giac_taxes_wheld(p_claim_id             IN     giac_inw_claim_payts.claim_id%TYPE,
								         p_advice_id         	IN	   giac_inw_claim_payts.advice_id%TYPE,     
								         p_payee_class_cd    	IN	   giac_taxes_wheld.payee_class_cd%TYPE, 
										 p_payee_cd          	IN	   giac_taxes_wheld.payee_cd%TYPE,
										 p_gacc_tran_id		    IN	   GIAC_INW_CLAIM_PAYTS.gacc_tran_id%TYPE,
										 p_dsp_iss_cd			IN	   GICL_ADVICE.iss_cd%TYPE,
										 p_convert_rate			IN	   GIAC_INW_CLAIM_PAYTS.convert_rate%TYPE,
                                         p_transaction_type	    IN	   GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE, --benjo 02.29.2016 SR-5303
										 p_var_module_name		IN OUT GIAC_MODULES.module_name%TYPE,
										 p_var_item_no			IN OUT NUMBER,
										 p_message			   	   OUT VARCHAR2);

END GIAC_INW_CLAIM_PAYTS_PKG;
/


