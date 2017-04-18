CREATE OR REPLACE PACKAGE CPI.giac_bank_cm_pkg
AS

  TYPE locm_list_type IS RECORD (
  	   gacc_tran_id	  	 		GIAC_BANK_CM.gacc_tran_id%TYPE,
	   fund_cd					GIAC_BANK_CM.fund_cd%TYPE,
	   branch_cd				GIAC_BANK_CM.branch_cd%TYPE,
	   dsp_or_pref_suf			VARCHAR2(20),
	   dcb_no					GIAC_BANK_CM.dcb_no%TYPE,
	   currency_cd				GIAC_BANK_CM.currency_cd%TYPE,
	   or_pref					GIAC_BANK_CM.or_pref%TYPE,
	   dcb_year					GIAC_BANK_CM.dcb_year%TYPE,
	   item_no					GIAC_BANK_CM.item_no%TYPE,
	   or_no					GIAC_BANK_CM.or_no%TYPE,
	   payor					GIAC_BANK_CM.payor%TYPE,
	   validation_dt			GIAC_BANK_CM.validation_dt%TYPE,
	   currency_short_name		GIIS_CURRENCY.short_name%TYPE,
	   amount					GIAC_BANK_CM.amount%TYPE,
	   foreign_curr_amt			GIAC_BANK_CM.foreign_curr_amt%TYPE,
	   currency_rt				GIAC_BANK_CM.currency_rt%TYPE
  );
  
  TYPE locm_list_tab IS TABLE OF locm_list_type;
  
  FUNCTION get_locm_list(p_gacc_tran_id			GIAC_BANK_CM.gacc_tran_id%TYPE,
  		   				 p_item_no				GIAC_BANK_CM.item_no%TYPE)
	RETURN locm_list_tab PIPELINED;

END giac_bank_cm_pkg;
/


