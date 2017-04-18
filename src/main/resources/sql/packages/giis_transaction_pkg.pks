CREATE OR REPLACE PACKAGE CPI.Giis_Transaction_Pkg AS

  TYPE giis_transaction_type IS RECORD (
  	   tran_cd				 GIIS_TRANSACTION.tran_cd%TYPE,
	   tran_desc			 GIIS_TRANSACTION.tran_desc%TYPE,
	   user_id				 GIIS_TRANSACTION.user_id%TYPE,
	   last_update			 GIIS_TRANSACTION.last_update%TYPE,
	   remarks				 GIIS_TRANSACTION.remarks%TYPE);

	   
  TYPE giis_transaction_tab IS TABLE OF giis_transaction_type;
  
  FUNCTION get_giis_transaction_list 
    RETURN giis_transaction_tab PIPELINED;

END Giis_Transaction_Pkg;
/


