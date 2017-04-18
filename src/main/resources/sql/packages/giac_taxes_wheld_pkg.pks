CREATE OR REPLACE PACKAGE CPI.GIAC_TAXES_WHELD_PKG
AS
  
  TYPE giac_taxes_wheld_type IS RECORD(
  	   gacc_tran_id			 		   GIAC_TAXES_WHELD.gacc_tran_id%TYPE,
	   or_print_tag					   GIAC_TAXES_WHELD.or_print_tag%TYPE,
	   item_no						   GIAC_TAXES_WHELD.item_no%TYPE,
	   payee_class_cd				   GIAC_TAXES_WHELD.payee_class_cd%TYPE,
	   payee_cd						   GIAC_TAXES_WHELD.payee_cd%TYPE,
	   sl_cd						   GIAC_TAXES_WHELD.sl_cd%TYPE,
	   income_amt					   GIAC_TAXES_WHELD.income_amt%TYPE,
	   wholding_tax_amt				   GIAC_TAXES_WHELD.wholding_tax_amt%TYPE,
	   remarks						   GIAC_TAXES_WHELD.remarks%TYPE,
	   gen_type						   GIAC_TAXES_WHELD.gen_type%TYPE,
	   gwtx_whtax_id				   GIAC_TAXES_WHELD.gwtx_whtax_id%TYPE,
	   user_id						   GIAC_TAXES_WHELD.user_id%TYPE,
	   last_update					   GIAC_TAXES_WHELD.last_update%TYPE,
	   sl_type_cd					   GIAC_TAXES_WHELD.sl_type_cd%TYPE,
	   dsp_whtax_code				   GIAC_WHOLDING_TAXES.whtax_code%TYPE,
	   dsp_bir_tax_cd				   GIAC_WHOLDING_TAXES.bir_tax_cd%TYPE,
	   dsp_percent_rate				   GIAC_WHOLDING_TAXES.percent_rate%TYPE,
	   dsp_whtax_desc  				   GIAC_WHOLDING_TAXES.whtax_desc%TYPE,
	   dsp_payee_first_name			   GIIS_PAYEES.payee_first_name%TYPE,
	   dsp_payee_middle_name		   GIIS_PAYEES.payee_middle_name%TYPE,
	   dsp_payee_last_name			   GIIS_PAYEES.payee_last_name%TYPE,
	   drv_payee_cd					   VARCHAR2(850),
	   sl_name						   GIAC_SL_LISTS.sl_name%TYPE, 
	   class_desc				   	   GIIS_PAYEE_CLASS.class_desc%TYPE	
  );
  
  TYPE giac_taxes_wheld_tab IS TABLE OF giac_taxes_wheld_type;
  
  FUNCTION get_giac_taxes_wheld (p_gacc_tran_id		GIAC_TAXES_WHELD.gacc_tran_id%TYPE)
    RETURN giac_taxes_wheld_tab PIPELINED;
	
  PROCEDURE set_giac_taxes_wheld(p_gacc_tran_id			GIAC_TAXES_WHELD.gacc_tran_id%TYPE,
  								 p_item_no				GIAC_TAXES_WHELD.item_no%TYPE,
								 p_payee_class_cd		GIAC_TAXES_WHELD.payee_class_cd%TYPE,
								 p_payee_cd				GIAC_TAXES_WHELD.payee_cd%TYPE,
								 p_sl_cd				GIAC_TAXES_WHELD.sl_cd%TYPE,
								 p_income_amt			GIAC_TAXES_WHELD.income_amt%TYPE,
								 p_wholding_tax_amt		GIAC_TAXES_WHELD.wholding_tax_amt%TYPE,
								 p_remarks				GIAC_TAXES_WHELD.remarks%TYPE,
								 p_gwtx_whtax_id		GIAC_TAXES_WHELD.gwtx_whtax_id%TYPE,
								 p_sl_type_cd			GIAC_TAXES_WHELD.sl_type_cd%TYPE,
								 p_or_print_tag			GIAC_TAXES_WHELD.or_print_tag%TYPE,
								 p_gen_type				GIAC_TAXES_WHELD.gen_type%TYPE,
								 p_user_id				GIAC_TAXES_WHELD.user_id%TYPE,
								 p_last_update			GIAC_TAXES_WHELD.last_update%TYPE);
								 
  PROCEDURE del_giac_taxes_wheld(p_gacc_tran_id			GIAC_TAXES_WHELD.gacc_tran_id%TYPE,
  								 p_item_no				GIAC_TAXES_WHELD.item_no%TYPE,
								 p_payee_class_cd		GIAC_TAXES_WHELD.payee_class_cd%TYPE,
								 p_payee_cd				GIAC_TAXES_WHELD.payee_cd%TYPE);

  PROCEDURE giacs022_post_forms_commit(p_gacc_tran_id	IN	   GIAC_TAXES_WHELD.gacc_tran_id%TYPE,
									 p_gacc_branch_cd   IN	   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
									 p_gacc_fund_cd     IN 	   GIAC_ACCTRANS.gfun_fund_cd%TYPE,
		   	  		  				 p_var_module_name	IN	   GIAC_MODULES.module_name%TYPE,
									 p_tran_source		IN	   VARCHAR2,
									 p_or_flag			IN	   VARCHAR2,
		   	  		  				 p_message			   OUT VARCHAR2);
END GIAC_TAXES_WHELD_PKG;
/


