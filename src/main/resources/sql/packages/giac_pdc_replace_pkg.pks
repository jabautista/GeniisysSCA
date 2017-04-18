CREATE OR REPLACE PACKAGE CPI.giac_pdc_replace_pkg
AS

   TYPE giac_pdc_replace_type IS RECORD(
   		item_no 			  GIAC_PDC_REPLACE.item_no%TYPE,
		pay_mode			  GIAC_PDC_REPLACE.pay_mode%TYPE,        
		bank_cd				  GIAC_PDC_REPLACE.bank_cd%TYPE,
		bank_sname			  GIAC_BANKS.bank_sname%TYPE,
        bank_name			  GIAC_BANKS.bank_name%TYPE,
		check_class			  GIAC_PDC_REPLACE.check_class%TYPE,
        check_class_desc	  VARCHAR2(200),
		check_no			  GIAC_PDC_REPLACE.check_no%TYPE,
		check_date			  GIAC_PDC_REPLACE.check_date%TYPE,
		amount				  GIAC_PDC_REPLACE.amount%TYPE,
		currency_cd			  GIAC_PDC_REPLACE.currency_cd%TYPE,
        currency_desc   	  GIIS_CURRENCY.currency_desc%TYPE,
		gross_amt			  GIAC_PDC_REPLACE.gross_amt%TYPE,
		commission_amt		  GIAC_PDC_REPLACE.commission_amt%TYPE,
		vat_amt				  GIAC_PDC_REPLACE.vat_amt%TYPE,
		ref_no				  GIAC_PDC_REPLACE.ref_no%TYPE
   );
   
   TYPE giac_pdc_replace_tab IS TABLE OF giac_pdc_replace_type;
   
   FUNCTION get_giac_pdc_replace(
   		p_pdc_id			  GIAC_PDC_REPLACE.pdc_id%TYPE
   )RETURN giac_pdc_replace_tab PIPELINED;
   
   PROCEDURE insert_giac_pdc_replace(
   		p_pdc_id				GIAC_PDC_REPLACE.pdc_id%TYPE,
		p_item_no				GIAC_PDC_REPLACE.pdc_id%TYPE,
		p_pay_mode				GIAC_PDC_REPLACE.pay_mode%TYPE,
		p_bank_cd				GIAC_PDC_REPLACE.bank_cd%TYPE,
		p_check_class			GIAC_PDC_REPLACE.check_class%TYPE,
		p_check_no				GIAC_PDC_REPLACE.check_no%TYPE,
		p_check_date			GIAC_PDC_REPLACE.check_date%TYPE,
		p_amount				GIAC_PDC_REPLACE.amount%TYPE,
		p_currency_cd			GIAC_PDC_REPLACE.currency_cd%TYPE,
		p_gross_amt				GIAC_PDC_REPLACE.gross_amt%TYPE,
		p_commission_amt		GIAC_PDC_REPLACE.commission_amt%TYPE,
		p_vat_amt				GIAC_PDC_REPLACE.vat_amt%TYPE,
		p_ref_no				GIAC_PDC_REPLACE.ref_no%TYPE
   );
   
END giac_pdc_replace_pkg;
/


