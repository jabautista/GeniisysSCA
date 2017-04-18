CREATE OR REPLACE PACKAGE BODY CPI.GIPI_WBANK_SCHEDULE_PKG AS

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  March 18, 2010
**  Reference By : (GIPIS089 - Bank Collection
**  Description  : This retrieves bank schedule
*/
  FUNCTION get_gipi_wbank_schedule(p_par_id			   GIPI_WBANK_SCHEDULE.par_id%TYPE,
  		   						   p_bank_item_no	   GIPI_WBANK_SCHEDULE.bank_item_no%TYPE)
	RETURN gipi_wbanksched_tab PIPELINED
	IS
	v_bank 					   gipi_wbanksched_type;
  BEGIN
    FOR i IN (SELECT par_id,   	   LTRIM(TO_CHAR(bank_item_no, '009')) bank_item_no,  bank,	   		   include_tag,
		  	 		 bank_address, cash_in_vault, cash_in_transit, remarks, bank_item_no bank_item_no1
				FROM GIPI_WBANK_SCHEDULE
			   WHERE par_id 			= p_par_id
			     AND bank_item_no		= NVL(p_bank_item_no, bank_item_no))
	LOOP
	  v_bank.par_id	 					:= i.par_id;
	  v_bank.bank_item_no				:= i.bank_item_no;
	  v_bank.bank						:= i.bank;
	  v_bank.include_tag				:= i.include_tag;
	  v_bank.bank_address				:= i.bank_address;
	  v_bank.cash_in_vault				:= i.cash_in_vault;
	  v_bank.cash_in_transit			:= i.cash_in_transit;
	  v_bank.remarks					:= i.remarks;
	  v_bank.bank_item_no1				:= i.bank_item_no1;
	  PIPE ROW(v_bank);
	END LOOP;
	RETURN;
  END get_gipi_wbank_schedule;

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  March 18, 2010
**  Reference By : (GIPIS089 - Bank Collection
**  Description  : This inserts or updates records
*/
  PROCEDURE set_gipi_wbanksched(p_par_id	   	  IN GIPI_WBANK_SCHEDULE.par_id%TYPE
  							   ,p_bank_item_no	  IN GIPI_WBANK_SCHEDULE.bank_item_no%TYPE
							   ,p_bank	   	  	  IN GIPI_WBANK_SCHEDULE.bank%TYPE
							   ,p_include_tag	  IN GIPI_WBANK_SCHEDULE.include_tag%TYPE
							   ,p_bank_address    IN GIPI_WBANK_SCHEDULE.bank_address%TYPE
							   ,p_cash_in_vault	  IN GIPI_WBANK_SCHEDULE.cash_in_vault%TYPE
							   ,p_cash_in_transit IN GIPI_WBANK_SCHEDULE.cash_in_transit%TYPE
							   ,p_remarks		  IN GIPI_WBANK_SCHEDULE.remarks%TYPE)
    IS
  BEGIN
  	   MERGE INTO GIPI_WBANK_SCHEDULE
	   USING DUAL ON (par_id   		  = p_par_id
	 	   		 AND bank_item_no     = p_bank_item_no)
	   WHEN NOT MATCHED THEN
	   		INSERT ( par_id,         bank_item_no,     bank,            include_tag,
				     bank_address,   cash_in_vault,    cash_in_transit, remarks)
			VALUES ( p_par_id,       p_bank_item_no,   p_bank,            p_include_tag,
				     p_bank_address, p_cash_in_vault,  p_cash_in_transit, p_remarks)
		WHEN MATCHED THEN
	   	  UPDATE SET bank  			 =	  p_bank,
				     include_tag  	 =	  p_include_tag,
					 bank_address	 =	  p_bank_address,
					 cash_in_vault   =	  p_cash_in_vault,
					 cash_in_transit = 	  p_cash_in_transit,
					 remarks  		 =	  p_remarks;
  END set_gipi_wbanksched;

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  March 19, 2010
**  Reference By : (GIPIS029 - Required Documents Submitted
**  Description  : This deletes a certain record with a certain par_id and bankItemNo
*/
  PROCEDURE delete_gipi_wbank(p_par_id 			GIPI_WBANK_SCHEDULE.par_id%TYPE
  							 ,p_bank_item_no	GIPI_WBANK_SCHEDULE.bank_item_no%TYPE)
	IS
  BEGIN
    DELETE FROM GIPI_WBANK_SCHEDULE
	 WHERE par_id   		 = p_par_id
  	   AND bank_item_no		 = p_bank_item_no;
  END delete_gipi_wbank;

END GIPI_WBANK_SCHEDULE_PKG;
/


