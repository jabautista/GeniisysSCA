CREATE OR REPLACE PACKAGE CPI.giac_bank_dep_slip_dtl_pkg
AS
  
  TYPE gbdsd_list_type IS RECORD (
  	   dep_id		   	  		 GIAC_BANK_DEP_SLIP_DTL.dep_id%TYPE,
	   dep_no					 GIAC_BANK_DEP_SLIP_DTL.dep_no%TYPE,
	   currency_cd				 GIAC_BANK_DEP_SLIP_DTL.currency_cd%TYPE,
	   bank_cd					 GIAC_BANK_DEP_SLIP_DTL.bank_cd%TYPE,
	   or_pref					 GIAC_BANK_DEP_SLIP_DTL.or_pref%TYPE,
	   check_no					 GIAC_BANK_DEP_SLIP_DTL.check_no%TYPE,
	   dsp_check_no				 VARCHAR2(40),
	   payor					 GIAC_BANK_DEP_SLIP_DTL.payor%TYPE,
	   or_no					 GIAC_BANK_DEP_SLIP_DTL.or_no%TYPE,
	   dsp_or_pref_suf			 VARCHAR2(20),
	   amount					 GIAC_BANK_DEP_SLIP_DTL.amount%TYPE,
	   currency_short_name	 	 GIIS_CURRENCY.short_name%TYPE,
	   foreign_curr_amt			 GIAC_BANK_DEP_SLIP_DTL.foreign_curr_amt%TYPE,
	   currency_rt				 GIAC_BANK_DEP_SLIP_DTL.currency_rt%TYPE,
	   bounce_tag				 GIAC_BANK_DEP_SLIP_DTL.bounce_tag%TYPE,
	   otc_tag					 GIAC_BANK_DEP_SLIP_DTL.otc_tag%TYPE,
	   local_sur				 GIAC_BANK_DEP_SLIP_DTL.local_sur%TYPE,
	   foreign_sur				 GIAC_BANK_DEP_SLIP_DTL.foreign_sur%TYPE,
	   net_colln_amt			 GIAC_BANK_DEP_SLIP_DTL.net_colln_amt%TYPE,
	   error_tag				 GIAC_BANK_DEP_SLIP_DTL.error_tag%TYPE,
	   book_tag					 GIAC_BANK_DEP_SLIP_DTL.book_tag%TYPE,
	   deposited_amt			 GIAC_BANK_DEP_SLIP_DTL.deposited_amt%TYPE,
	   loc_error_amt			 GIAC_BANK_DEP_SLIP_DTL.loc_error_amt%TYPE
  );
  
  TYPE otc_surcharge_type IS RECORD (
  	   local_sur	 		     GIAC_BANK_DEP_SLIP_DTL.local_sur%TYPE,
	   foreign_sur				 GIAC_BANK_DEP_SLIP_DTL.foreign_sur%TYPE,
	   net_colln_amt			 GIAC_BANK_DEP_SLIP_DTL.net_colln_amt%TYPE
  );
  
  TYPE gbdsd_list_tab IS TABLE OF gbdsd_list_type;
  
  TYPE otc_surcharge_tab IS TABLE OF otc_surcharge_type;
  
  FUNCTION get_gbdsd_list (p_dep_id			GIAC_BANK_DEP_SLIP_DTL.dep_id%TYPE,
  		   				   p_dep_no			GIAC_BANK_DEP_SLIP_DTL.dep_no%TYPE)
	RETURN gbdsd_list_tab PIPELINED;
	
  FUNCTION get_loc_error_amt (p_dep_id		GIAC_BANK_DEP_SLIP_DTL.dep_id%TYPE,
  		   					  p_dep_no		GIAC_BANK_DEP_SLIP_DTL.dep_no%TYPE,
							  p_bank_cd		GIAC_BANK_DEP_SLIP_DTL.bank_cd%TYPE,
							  p_check_no	GIAC_BANK_DEP_SLIP_DTL.check_no%TYPE,
							  p_or_pref		GIAC_BANK_DEP_SLIP_DTL.or_pref%TYPE,
							  p_or_no		GIAC_BANK_DEP_SLIP_DTL.or_no%TYPE)
	RETURN VARCHAR2; --GIAC_BANK_DEP_SLIP_DTL.loc_error_amt%TYPE;
	
  FUNCTION get_otc_surcharge(p_gacc_tran_id GIAC_DCB_BANK_DEP.gacc_tran_id%TYPE,
  		   					 p_dcb_no		GIAC_DCB_BANK_DEP.dcb_no%TYPE,
							 p_item_no		GIAC_DCB_BANK_DEP.item_no%TYPE)
	RETURN otc_surcharge_tab PIPELINED;
	
  FUNCTION get_gbdsd_list_by_tran_id (p_gacc_tran_id			GIAC_BANK_DEP_SLIPS.gacc_tran_id%TYPE)
	RETURN gbdsd_list_tab PIPELINED;
	
  PROCEDURE update_gbdsd_in_otc(p_dep_id    GIAC_BANK_DEP_SLIP_DTL.dep_id%TYPE);
  
  PROCEDURE set_giac_bank_dep_slip_dtl(p_dep_id		   	  		 GIAC_BANK_DEP_SLIP_DTL.dep_id%TYPE,
									   p_dep_no					 GIAC_BANK_DEP_SLIP_DTL.dep_no%TYPE,
									   p_currency_cd			 GIAC_BANK_DEP_SLIP_DTL.currency_cd%TYPE,
									   p_bank_cd				 GIAC_BANK_DEP_SLIP_DTL.bank_cd%TYPE,
									   p_or_pref				 GIAC_BANK_DEP_SLIP_DTL.or_pref%TYPE,
									   p_check_no				 GIAC_BANK_DEP_SLIP_DTL.check_no%TYPE,
									   p_payor					 GIAC_BANK_DEP_SLIP_DTL.payor%TYPE,
									   p_or_no					 GIAC_BANK_DEP_SLIP_DTL.or_no%TYPE,
									   p_amount					 GIAC_BANK_DEP_SLIP_DTL.amount%TYPE,
									   p_foreign_curr_amt		 GIAC_BANK_DEP_SLIP_DTL.foreign_curr_amt%TYPE,
									   p_currency_rt			 GIAC_BANK_DEP_SLIP_DTL.currency_rt%TYPE,
									   p_bounce_tag				 GIAC_BANK_DEP_SLIP_DTL.bounce_tag%TYPE,
									   p_otc_tag				 GIAC_BANK_DEP_SLIP_DTL.otc_tag%TYPE,
									   p_local_sur				 GIAC_BANK_DEP_SLIP_DTL.local_sur%TYPE,
									   p_foreign_sur			 GIAC_BANK_DEP_SLIP_DTL.foreign_sur%TYPE,
									   p_net_colln_amt			 GIAC_BANK_DEP_SLIP_DTL.net_colln_amt%TYPE,
									   p_error_tag				 GIAC_BANK_DEP_SLIP_DTL.error_tag%TYPE,
									   p_book_tag				 GIAC_BANK_DEP_SLIP_DTL.book_tag%TYPE,
									   p_deposited_amt			 GIAC_BANK_DEP_SLIP_DTL.deposited_amt%TYPE,
									   p_loc_error_amt			 GIAC_BANK_DEP_SLIP_DTL.loc_error_amt%TYPE);
									   
  PROCEDURE del_giac_bank_dep_slip_dtl(p_dep_id		   	  		 GIAC_BANK_DEP_SLIP_DTL.dep_id%TYPE,
									   p_dep_no					 GIAC_BANK_DEP_SLIP_DTL.dep_no%TYPE,
									   p_bank_cd				 GIAC_BANK_DEP_SLIP_DTL.bank_cd%TYPE,
									   p_check_no				 GIAC_BANK_DEP_SLIP_DTL.check_no%TYPE,
									   p_or_pref				 GIAC_BANK_DEP_SLIP_DTL.or_pref%TYPE,
									   p_or_no					 GIAC_BANK_DEP_SLIP_DTL.or_no%TYPE);

END giac_bank_dep_slip_dtl_pkg;
/


