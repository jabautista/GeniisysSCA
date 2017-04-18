CREATE OR REPLACE PACKAGE CPI.giac_apdc_payt_dtl_pkg
AS

  TYPE giac_apdc_payt_dtl_type IS RECORD (
  	   apdc_id				   giac_apdc_payt_dtl.apdc_id%TYPE,
	   pdc_id				   giac_apdc_payt_dtl.pdc_id%TYPE,
	   item_no				   giac_apdc_payt_dtl.item_no%TYPE,
	   bank_cd				   giac_apdc_payt_dtl.bank_cd%TYPE,
	   bank_name			   giac_banks.bank_name%TYPE,
	   bank_sname			   giac_banks.bank_sname%TYPE,
	   check_class			   giac_apdc_payt_dtl.check_class%TYPE,
       check_class_desc		   VARCHAR2(50),
	   check_no				   giac_apdc_payt_dtl.check_no%TYPE,
	   check_date			   giac_apdc_payt_dtl.check_date%TYPE,
	   check_amt			   giac_apdc_payt_dtl.check_amt%TYPE,
	   currency_cd			   giac_apdc_payt_dtl.currency_cd%TYPE,
	   currency_name		   giis_currency.short_name%TYPE,
	   currency_desc		   giis_currency.currency_desc%TYPE,
	   currency_rt			   giis_currency.currency_rt%TYPE,
	   fcurrency_amt		   giac_apdc_payt_dtl.fcurrency_amt%TYPE,
	   payor				   giac_apdc_payt_dtl.payor%TYPE,
	   address_1			   giac_apdc_payt_dtl.address_1%TYPE,
	   address_2			   giac_apdc_payt_dtl.address_2%TYPE,
	   address_3			   giac_apdc_payt_dtl.address_3%TYPE,
	   intermediary			   giis_intermediary.intm_name%TYPE,
	   particulars			   giac_apdc_payt_dtl.particulars%TYPE,
	   tin					   giac_apdc_payt_dtl.tin%TYPE,
	   check_flag			   giac_apdc_payt_dtl.check_flag%TYPE,
	   check_status			   cg_ref_codes.rv_meaning%TYPE,
	   user_id				   giac_apdc_payt_dtl.user_id%TYPE,
	   gacc_tran_id			   giac_apdc_payt_dtl.gacc_tran_id%TYPE,
	   last_update			   giac_apdc_payt_dtl.last_update%TYPE,
	   gross_amt			   giac_apdc_payt_dtl.gross_amt%TYPE,
	   commission_amt		   giac_apdc_payt_dtl.commission_amt%TYPE,
	   vat_amt				   giac_apdc_payt_dtl.vat_amt%TYPE,
	   fc_gross_amt			   giac_apdc_payt_dtl.fc_gross_amt%TYPE,
	   fc_tax_amt			   giac_apdc_payt_dtl.fc_tax_amt%TYPE,
	   replace_date			   giac_apdc_payt_dtl.replace_date%TYPE,
	   pay_mode				   giac_apdc_payt_dtl.pay_mode%TYPE,
	   intm_no				   giac_apdc_payt_dtl.intm_no%TYPE,
	   dcb_no				   giac_apdc_payt_dtl.dcb_no%TYPE,
	   bank_branch			   giac_apdc_payt_dtl.bank_branch%TYPE,
	   remarks				   giac_apdc_payt_dtl.remarks%TYPE,
       or_flag                 giac_order_of_payts.or_flag%TYPE
  );
  
  TYPE giac_apdc_payt_dtl_tab IS TABLE OF giac_apdc_payt_dtl_type;
  
  FUNCTION get_giac_apdc_payt_dtl(
  	   p_apdc_id				   giac_apdc_payt_dtl.APDC_ID%TYPE
  )RETURN giac_apdc_payt_dtl_tab PIPELINED;
  
  PROCEDURE set_giac_apdc_payt_dtl(
	   p_apdc_id				GIAC_APDC_PAYT_DTL.apdc_id%TYPE,
	   p_pdc_id					GIAC_APDC_PAYT_DTL.pdc_id%TYPE,
	   p_item_no				GIAC_APDC_PAYT_DTL.item_no%TYPE,
	   p_bank_cd				GIAC_APDC_PAYT_DTL.bank_cd%TYPE,
	   p_check_class			GIAC_APDC_PAYT_DTL.check_class%TYPE,
	   p_check_no				GIAC_APDC_PAYT_DTL.check_no%TYPE,
	   p_check_date				GIAC_APDC_PAYT_DTL.check_date%TYPE,
	   p_check_amt				GIAC_APDC_PAYT_DTL.check_amt%TYPE,
	   p_currency_cd			GIAC_APDC_PAYT_DTL.currency_cd%TYPE,
	   p_currency_rt			GIAC_APDC_PAYT_DTL.currency_rt%TYPE,
	   p_fcurrency_amt			GIAC_APDC_PAYT_DTL.fcurrency_amt%TYPE,
	   p_particulars			GIAC_APDC_PAYT_DTL.particulars%TYPE,
	   p_payor					GIAC_APDC_PAYT_DTL.payor%TYPE,
	   p_address_1				GIAC_APDC_PAYT_DTL.address_1%TYPE,
	   p_address_2				GIAC_APDC_PAYT_DTL.address_2%TYPE,
	   p_address_3				GIAC_APDC_PAYT_DTL.address_3%TYPE,
	   p_tin					GIAC_APDC_PAYT_DTL.tin%TYPE,
	   p_check_flag				GIAC_APDC_PAYT_DTL.check_flag%TYPE,
	   p_gross_amt				GIAC_APDC_PAYT_DTL.gross_amt%TYPE,
	   p_commission_amt			GIAC_APDC_PAYT_DTL.commission_amt%TYPE,
	   p_vat_amt				GIAC_APDC_PAYT_DTL.vat_amt%TYPE,
	   p_fc_gross_amt			GIAC_APDC_PAYT_DTL.fc_gross_amt%TYPE,
	   p_fc_comm_amt			GIAC_APDC_PAYT_DTL.fc_comm_amt%TYPE,
	   p_fc_tax_amt				GIAC_APDC_PAYT_DTL.fc_tax_amt%TYPE,
	   p_replace_date			GIAC_APDC_PAYT_DTL.replace_date%TYPE,
	   p_pay_mode				GIAC_APDC_PAYT_DTL.pay_mode%TYPE,
	   p_intm_no				GIIS_INTERMEDIARY.intm_no%TYPE,
	   p_bank_branch			GIAC_APDC_PAYT_DTL.bank_branch%TYPE
  );
  
  PROCEDURE delete_giac_apdc_payt_dtl(
  	   p_pdc_id			GIAC_APDC_PAYT_DTL.pdc_id%TYPE
  );
  
  PROCEDURE cancel_apdc_payt_dtl(
  	   p_pdc_id		GIAC_APDC_PAYT_DTL.pdc_id%TYPE
  );	
  
  PROCEDURE update_apdc_payt_dtl_status(
    p_pdc_id        GIAC_APDC_PAYT_DTL.pdc_id%TYPE,
    p_check_flag    GIAC_APDC_PAYT_DTL.check_flag%TYPE);
  
  FUNCTION check_if_from_apdc (
    p_gacc_tran_id      GIAC_APDC_PAYT_DTL.gacc_tran_id%TYPE
  ) RETURN NUMBER;
  
  PROCEDURE val_del_apdc (
      p_pdc_id      GIAC_APDC_PAYT_DTL.pdc_id%TYPE
  );
END giac_apdc_payt_dtl_pkg;
/
