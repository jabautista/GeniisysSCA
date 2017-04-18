CREATE OR REPLACE PACKAGE CPI.GIAC_OVRIDE_COMM_PAYTS_PKG
AS

  TYPE giac_ovride_comm_payts_type IS RECORD(
  	   gacc_tran_id				   	  		 GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
	   transaction_type						 GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
	   iss_cd								 GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
	   prem_seq_no							 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
	   intm_no								 GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
	   child_intm_no						 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
	   comm_amt								 GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
	   input_vat							 GIAC_OVRIDE_COMM_PAYTS.input_vat%TYPE,
	   wtax_amt								 GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
	   drv_comm_amt							 NUMBER,
	   particulars							 GIAC_OVRIDE_COMM_PAYTS.particulars%TYPE,
	   user_id								 GIAC_OVRIDE_COMM_PAYTS.user_id%TYPE,
	   last_update							 GIAC_OVRIDE_COMM_PAYTS.last_update%TYPE,
	   foreign_curr_amt						 GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
	   convert_rt							 GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE,
	   currency_cd							 GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE,
	   currency_desc						 GIIS_CURRENCY.currency_desc%TYPE,
	   policy_no							 VARCHAR2(40),
	   assd_name							 GIIS_ASSURED.assd_name%TYPE,
	   child_intm_name						 GIIS_INTERMEDIARY.intm_name%TYPE,
	   intermediary_name					 GIIS_INTERMEDIARY.intm_name%TYPE
  );
  
  TYPE giac_ovride_comm_payts_tab IS TABLE OF giac_ovride_comm_payts_type;
  
  TYPE overide_comm_payts_iss_cd_type IS RECORD(
	   branch_cd 		   		  	  	 	 giac_parent_comm_invoice.iss_cd%TYPE,
	   branch_name							 giis_issource.iss_name%TYPE
  );
  
  TYPE overide_comm_payts_iss_cd_tab IS TABLE OF overide_comm_payts_iss_cd_type;
  
  TYPE ovride_comm_payts_bill_no_type IS RECORD(
	   iss_cd 		   		  	  	 	   	 GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
	   prem_seq_no							 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
       bill_no		   		  	  	 	   	 VARCHAR2(16),
       intm_no                               GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
       intm_name                             GIIS_INTERMEDIARY.intm_name%TYPE,
       chld_intm_no                          GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
       chld_intm_name                        GIIS_INTERMEDIARY.intm_name%TYPE,
       policy_no                             VARCHAR2(50),
       assd_name                             GIIS_ASSURED.ASSD_NAME%TYPE,
       ovriding_comm_amt                     VARCHAR2(20),
       input_vat                             VARCHAR2(20),
       wtax_amt                              VARCHAR2(20),
       net_comm                              VARCHAR2(20),
       currency_cd                           GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE,
       currency_desc                         GIIS_CURRENCY.currency_desc%TYPE,
       convert_rt                            GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE,
       foreign_curr_amt                      GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
       prev_comm_amt                         GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
       prev_for_curr_amt                     GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE
  );
  
  TYPE ovride_comm_payts_bill_no_tab IS TABLE OF ovride_comm_payts_bill_no_type;
  
  FUNCTION get_giac_ovride_comm_payts (p_gacc_tran_id		GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE)
    RETURN giac_ovride_comm_payts_tab PIPELINED;
    
  FUNCTION get_overide_comm_payts_iss_cd(p_user_id          GIIS_USERS.user_id%TYPE)
    RETURN overide_comm_payts_iss_cd_tab PIPELINED;
	
  FUNCTION get_bill_no_by_tran_type(
        p_tran_type				GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
        p_iss_cd                GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
        p_prem_seq_no           GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
        p_new_bills             VARCHAR2,
        p_deleted_bills         VARCHAR2
   ) RETURN ovride_comm_payts_bill_no_tab PIPELINED;
	
  FUNCTION get_dflt_bill_no_listing(p_iss_cd	   			GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE)
    RETURN ovride_comm_payts_bill_no_tab PIPELINED;
	
  /**
   ** PROCEDURES from GIACS040
  **/
	
  PROCEDURE chck_prem_payts(p_iss_cd					   IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  							p_prem_seq_no				   IN	  GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
							p_var_with_prem				   IN OUT NUMBER,
							p_var_prem_amt				   IN OUT GIAC_DIRECT_PREM_COLLNS.premium_amt%TYPE,
							p_message					      OUT VARCHAR2);
							
  PROCEDURE chck_balance(p_iss_cd 			IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  						 p_prem_seq_no		IN	   GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
						 p_module_name		IN	   VARCHAR2,
						 p_user_id	    	IN	   VARCHAR2,
						 p_var_switch		IN OUT NUMBER,
						 p_message			   OUT VARCHAR2);
						 
  PROCEDURE get_percentage(p_iss_cd		  	 	 	 	   IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  						   p_prem_seq_no				   IN	  GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  						   p_var_prem_amt				   IN     NUMBER,
  						   p_var_percentage	 	 	 	   IN OUT NUMBER,
						   p_var_premium_payts			   IN OUT NUMBER);
						   
  PROCEDURE get_default_val_procedure(p_transaction_type	   		 IN     GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
  									  p_iss_cd						 IN		GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
									  p_prem_seq_no					 IN		GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
									  p_intm_no						 IN		GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
									  p_chld_intm_no				 IN		GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
									  p_comm_amt					 IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
									  p_prev_comm_amt				 IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
									  p_var_percentage				 IN OUT NUMBER,
									  p_var_prem_amt				 IN 	NUMBER,
									  p_var_premium_payts			 IN OUT NUMBER,
									  p_var_comm_amt				 IN OUT NUMBER,
									  p_var_comm_amt_def			 IN OUT NUMBER,
									  p_var_for_cur_amt_def			 IN OUT NUMBER);
									  
  PROCEDURE get_parent_child_procedure(p_iss_cd	  	  	   IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  									   p_prem_seq_no	   IN	  GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  									   p_intm_no  	  	   IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  									   p_chld_intm_no	   IN	  GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
									   p_intermediary_name IN OUT GIIS_INTERMEDIARY.intm_name%TYPE,
									   p_child_intm_name   IN OUT GIIS_INTERMEDIARY.intm_name%TYPE);
									   
  PROCEDURE get_assd_policy_procedure(p_iss_cd	  	  	   IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  									  p_prem_seq_no	   	   IN	  GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  									  p_intm_no  	  	   IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  									  p_chld_intm_no	   IN	  GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
									  p_policy_no  		   IN OUT VARCHAR2,
									  p_assd_name     	   IN OUT GIIS_ASSURED.assd_name%TYPE);
									  
  PROCEDURE get_input_vat_amt(p_intm_no				IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  							  p_comm_amt			IN	   GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
							  p_input_vat			IN OUT GIAC_OVRIDE_COMM_PAYTS.input_vat%TYPE);
							  
  PROCEDURE GET_WTAX_AMT_PROCEDURE(p_iss_cd	  	  	   IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  								   p_prem_seq_no	   IN	  GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  								   p_intm_no  	  	   IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								   p_chld_intm_no	   IN	  GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								   p_comm_amt		   IN	  GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_var_wtax_amt	   IN	  GIAC_PARENT_COMM_INVOICE.wholding_tax%TYPE,
								   p_wtax_amt		   IN OUT GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE);
								   
  PROCEDURE get_foreign_curr_amt(p_iss_cd	  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  								 p_prem_seq_no	   	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  								 p_intm_no  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								 p_chld_intm_no	   	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								 p_comm_amt				  IN	 GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								 p_foreign_curr_amt	   	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								 p_prev_for_curr_amt   	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								 p_var_foreign_curr_amt	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								 p_var_for_cur_amt_def	  IN OUT NUMBER);
								 
  PROCEDURE get_com_amt3_procedure(p_gacc_tran_id  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
                                   p_iss_cd	  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  								   p_prem_seq_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  								   p_intm_no  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								   p_chld_intm_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								   p_comm_amt			  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_foreign_curr_amt	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_prev_comm_amt		  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_prev_for_curr_amt    IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_var_comm_amt		  IN OUT NUMBER,
								   p_var_comm_amt_def	  IN OUT NUMBER,
								   p_var_for_cur_amt_def  IN OUT NUMBER,
								   p_message			     OUT VARCHAR2,
                                   p_deleted_bills        IN     VARCHAR2);
								   
  PROCEDURE get_com_amt6_procedure(p_gacc_tran_id  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
                                   p_iss_cd	  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  								   p_prem_seq_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  								   p_intm_no  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								   p_chld_intm_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								   p_comm_amt			  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_foreign_curr_amt	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_prev_comm_amt		  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_prev_for_curr_amt    IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_var_comm_amt		  IN OUT NUMBER,
								   p_var_comm_amt_def	  IN OUT NUMBER,
								   p_var_for_cur_amt_def  IN OUT NUMBER,
								   p_message			     OUT VARCHAR2,
                                   p_deleted_bills        IN     VARCHAR2);
								   
  PROCEDURE get_com_amt1_procedure(p_iss_cd	  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  								   p_prem_seq_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  								   p_intm_no  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								   p_chld_intm_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								   p_comm_amt			  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_foreign_curr_amt	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_prev_comm_amt		  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_prev_for_curr_amt    IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_var_comm_amt		  IN OUT NUMBER,
								   p_var_comm_amt_def	  IN OUT NUMBER,
								   p_var_for_cur_amt_def  IN OUT NUMBER,
								   p_var_prem_amt		  IN     NUMBER,
		  						   p_var_percentage	 	  IN OUT NUMBER,
								   p_var_premium_payts	  IN OUT NUMBER,
                                   p_deleted_bills        IN     VARCHAR2);
								   
  PROCEDURE get_com_amt4_procedure(p_iss_cd	  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  								   p_prem_seq_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  								   p_intm_no  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								   p_chld_intm_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								   p_comm_amt			  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_foreign_curr_amt	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_prev_comm_amt		  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_prev_for_curr_amt    IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_var_comm_amt		  IN OUT NUMBER,
								   p_var_comm_amt_def	  IN OUT NUMBER,
								   p_var_for_cur_amt_def  IN OUT NUMBER,
								   p_var_prem_amt		  IN     NUMBER,
		  						   p_var_percentage	 	  IN OUT NUMBER,
								   p_var_premium_payts	  IN OUT NUMBER,
                                   p_deleted_bills        IN     VARCHAR2);
								   
  PROCEDURE get_val_currency_procedure(p_iss_cd	  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
	  								   p_prem_seq_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
	  								   p_intm_no  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
	  								   p_chld_intm_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
									   p_convert_rt			  IN OUT GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE,
									   p_currency_cd		  IN OUT GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE,
									   p_currency_desc		  IN OUT GIIS_CURRENCY.currency_desc%TYPE,
									   p_var_currency_rt	  IN OUT GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE,
									   p_var_currency_cd	  IN OUT GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE,
									   p_var_currency_desc	  IN OUT GIIS_CURRENCY.currency_desc%TYPE);
									   
  PROCEDURE validate_giacs040_child_intm(p_transaction_type				IN     GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
	   	  		  						 p_iss_cd						IN	   GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
										 p_prem_seq_no					IN	   GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
										 p_intm_no						IN	   GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
										 p_chld_intm_no					IN	   GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
										 p_intermediary_name 			IN OUT GIIS_INTERMEDIARY.intm_name%TYPE,
										 p_child_intm_name   			IN OUT GIIS_INTERMEDIARY.intm_name%TYPE,
										 p_policy_no  		   			IN OUT VARCHAR2,
										 p_assd_name     	   			IN OUT GIIS_ASSURED.assd_name%TYPE,
										 p_comm_amt						IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
										 p_input_vat					IN OUT GIAC_OVRIDE_COMM_PAYTS.input_vat%TYPE,
										 p_wtax_amt		   				IN OUT GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
										 p_foreign_curr_amt				IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
										 p_prev_comm_amt				IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
										 p_prev_for_curr_amt			IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
										 p_convert_rt			  		IN OUT GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE,
										 p_currency_cd		  			IN OUT GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE,
										 p_currency_desc		  		IN OUT GIIS_CURRENCY.currency_desc%TYPE,
										 p_var_with_prem				IN OUT NUMBER,
										 p_var_comm_amt				 	IN OUT NUMBER,
										 p_var_comm_amt_def			 	IN OUT NUMBER,
										 p_var_for_cur_amt_def			IN OUT NUMBER,
										 p_var_prem_amt				    IN OUT NUMBER,
								  		 p_var_percentage	 	 	 	IN OUT NUMBER,
										 p_var_premium_payts			IN OUT NUMBER,
										 p_var_wtax_amt	   				IN	   GIAC_PARENT_COMM_INVOICE.wholding_tax%TYPE,
										 p_var_foreign_curr_amt	  		IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
										 p_var_switch					IN OUT NUMBER,
										 p_var_currency_rt	  			IN OUT GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE,
										 p_var_currency_cd	  	 		IN OUT GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE,
										 p_var_currency_desc	  		IN OUT GIIS_CURRENCY.currency_desc%TYPE,
										 p_message						   OUT VARCHAR2,
                                         p_deleted_bills        IN     VARCHAR2);
										 
  PROCEDURE validate_giacs040_comm_amt(p_transaction_type				IN     GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
			  							 p_iss_cd						IN 	   GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
										 p_prem_seq_no					IN	   GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
										 p_intm_no						IN	   GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
										 p_chld_intm_no					IN	   GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
			  							 p_comm_amt						IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
										 p_prev_comm_amt				IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
										 p_wtax_amt						IN OUT GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
										 p_foreign_curr_amt	   	  		IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
										 p_prev_for_curr_amt   	  		IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
										 p_var_foreign_curr_amt	  		IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
										 p_var_for_cur_amt_def	  		IN OUT NUMBER,
										 p_var_wtax_amt					IN 	   GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
										 p_var_comm_amt_def				IN	   GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE,
                                         p_add_update_btn               IN     VARCHAR2,
                                         p_current_bill                 IN      VARCHAR2,   
										 p_message						   OUT VARCHAR2);
										 
  PROCEDURE validate_giacs040_foreign_curr(p_transaction_type			IN     GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
		  								 p_iss_cd						IN	   GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
		  								 p_prem_seq_no					IN	   GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
										 p_intm_no						IN	   GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
										 p_chld_intm_no					IN	   GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
										 p_comm_amt						IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
										 p_wtax_amt						IN OUT GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
										 p_drv_comm_amt					IN OUT NUMBER,
										 p_foreign_curr_amt				IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
										 p_prev_for_curr_amt			IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
										 p_var_for_cur_amt_def			IN 	   GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE,
										 p_var_currency_rt				IN	   GIPI_INVOICE.currency_rt%TYPE,
										 p_message					   	   OUT VARCHAR2);
										 
  PROCEDURE set_giac_ovride_comm_payts(p_gacc_tran_id					GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
  									   p_transaction_type				GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
									   p_iss_cd							GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
									   p_prem_seq_no					GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
									   p_intm_no						GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
									   p_chld_intm_no					GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
									   p_comm_amt						GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
									   p_wtax_amt						GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
									   p_currency_cd					GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE,
									   p_convert_rt						GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE,
									   p_foreign_curr_amt				GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
									   p_input_vat						GIAC_OVRIDE_COMM_PAYTS.input_vat%TYPE,
									   p_particulars					GIAC_OVRIDE_COMM_PAYTS.particulars%TYPE,
									   p_user_id						GIAC_OVRIDE_COMM_PAYTS.user_id%TYPE,
									   p_last_update					GIAC_OVRIDE_COMM_PAYTS.last_update%TYPE);
									   
  PROCEDURE del_giac_ovride_comm_payts(p_gacc_tran_id					GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
  									   p_iss_cd							GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
									   p_prem_seq_no					GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
									   p_intm_no						GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
									   p_chld_intm_no					GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE);
									   
  PROCEDURE aeg_insert_update_acct_entries
					    (p_gacc_branch_cd       GIAC_ACCTRANS.gibr_branch_cd%TYPE,
					     p_gacc_fund_cd         GIAC_ACCTRANS.gfun_fund_cd%TYPE,
					     p_gacc_tran_id         GIAC_ACCTRANS.tran_id%TYPE,
						 iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
					     iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
					     iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
					     iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
					     iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
					     iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
					     iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
					     iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
					     iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
					     iuae_sl_type_cd	    GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
					     iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE,
					     iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
					     iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
					     iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
					     iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
					     iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE);
						 
  PROCEDURE giacs040_comm_payable_proc (p_gacc_branch_cd       IN GIAC_ACCTRANS.gibr_branch_cd%TYPE,
								      p_gacc_fund_cd         IN GIAC_ACCTRANS.gfun_fund_cd%TYPE,
								      p_gacc_tran_id         IN GIAC_ACCTRANS.tran_id%TYPE,
		  							  v_intm_no     		 IN GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
                             		  v_comm_amt    		 IN GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
                             		  v_wtax_amt    		 IN GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
                             		  v_input_vat   		 IN GIAC_OVRIDE_COMM_PAYTS.input_vat%TYPE,
			     					  v_line_cd     		 IN GIIS_LINE.line_cd%TYPE,
									  p_message	   			 OUT VARCHAR2);
									  
  PROCEDURE giacs040_aeg_parameters(p_gacc_tran_id			IN	   GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
		  						  p_gacc_branch_cd          IN 	   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
								  p_gacc_fund_cd         	IN 	   GIAC_ACCTRANS.gfun_fund_cd%TYPE,
		  						  p_var_module_name			IN	   GIAC_MODULES.module_name%TYPE,
								  p_message					   OUT VARCHAR2);
								  
  PROCEDURE giacs040_post_forms_commit(p_gacc_tran_id			   IN	  GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
				  						 p_gacc_branch_cd          IN 	  GIAC_ACCTRANS.gibr_branch_cd%TYPE,
										 p_gacc_fund_cd            IN 	  GIAC_ACCTRANS.gfun_fund_cd%TYPE,
										 p_tran_source			   IN	  VARCHAR2,
										 p_or_flag				   IN	  VARCHAR2,
										 p_var_module_name		   IN	  GIAC_MODULES.module_name%TYPE,
										 p_message				      OUT VARCHAR2);
  
    FUNCTION validate_tran_refund(
        p_tran_type     giac_ovride_comm_payts.transaction_type%type,
        p_iss_cd        giac_ovride_comm_payts.iss_cd%type,
        p_prem_seq_no   giac_ovride_comm_payts.prem_seq_no%type
    ) RETURN VARCHAR2;
    
    
    PROCEDURE val_delete_rec(
        p_tran_type       giac_ovride_comm_payts.transaction_type%TYPE,
        p_iss_cd          giac_ovride_comm_payts.iss_cd%TYPE,
        p_prem_seq_no     giac_ovride_comm_payts.prem_seq_no%TYPE
    );
    
    FUNCTION validate_bill(
        p_tran_type       giac_ovride_comm_payts.transaction_type%TYPE,
        p_iss_cd          giac_ovride_comm_payts.iss_cd%TYPE,
        p_prem_seq_no     giac_ovride_comm_payts.prem_seq_no%TYPE
    ) RETURN VARCHAR2;
									   
END GIAC_OVRIDE_COMM_PAYTS_PKG;
/


