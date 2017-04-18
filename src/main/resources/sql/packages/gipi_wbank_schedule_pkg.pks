CREATE OR REPLACE PACKAGE CPI.GIPI_WBANK_SCHEDULE_PKG AS

  TYPE gipi_wbanksched_type IS RECORD
    (par_id		  		  GIPI_WBANK_SCHEDULE.par_id%TYPE,
	 bank_item_no		  VARCHAR2(5),--GIPI_WBANK_SCHEDULE.bank_item_no%TYPE,
	 bank_item_no1		  GIPI_WBANK_SCHEDULE.bank_item_no%TYPE,
	 bank			  	  GIPI_WBANK_SCHEDULE.bank%TYPE,
	 include_tag		  GIPI_WBANK_SCHEDULE.include_tag%TYPE,
	 bank_address		  GIPI_WBANK_SCHEDULE.bank_address%TYPE,
	 cash_in_vault		  GIPI_WBANK_SCHEDULE.cash_in_vault%TYPE,
	 cash_in_transit	  GIPI_WBANK_SCHEDULE.cash_in_transit%TYPE,
	 remarks			  GIPI_WBANK_SCHEDULE.remarks%TYPE);
	 
  TYPE gipi_wbanksched_tab IS TABLE OF gipi_wbanksched_type;
  
  FUNCTION get_gipi_wbank_schedule(p_par_id			   GIPI_WBANK_SCHEDULE.par_id%TYPE,
  		   						   p_bank_item_no	   GIPI_WBANK_SCHEDULE.bank_item_no%TYPE)
	RETURN gipi_wbanksched_tab PIPELINED;
	
  PROCEDURE set_gipi_wbanksched(p_par_id	   	  IN GIPI_WBANK_SCHEDULE.par_id%TYPE
  							   ,p_bank_item_no	  IN GIPI_WBANK_SCHEDULE.bank_item_no%TYPE
							   ,p_bank	   	  	  IN GIPI_WBANK_SCHEDULE.bank%TYPE
							   ,p_include_tag	  IN GIPI_WBANK_SCHEDULE.include_tag%TYPE
							   ,p_bank_address    IN GIPI_WBANK_SCHEDULE.bank_address%TYPE
							   ,p_cash_in_vault	  IN GIPI_WBANK_SCHEDULE.cash_in_vault%TYPE
							   ,p_cash_in_transit IN GIPI_WBANK_SCHEDULE.cash_in_transit%TYPE
							   ,p_remarks		  IN GIPI_WBANK_SCHEDULE.remarks%TYPE);
							   
  PROCEDURE delete_gipi_wbank(p_par_id 			GIPI_WBANK_SCHEDULE.par_id%TYPE
  							 ,p_bank_item_no	GIPI_WBANK_SCHEDULE.bank_item_no%TYPE);

END GIPI_WBANK_SCHEDULE_PKG;
/


