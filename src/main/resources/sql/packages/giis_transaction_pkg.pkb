CREATE OR REPLACE PACKAGE BODY CPI.Giis_Transaction_Pkg AS

  FUNCTION get_giis_transaction_list
    RETURN giis_transaction_tab PIPELINED IS

	v_giis_transaction		giis_transaction_type;

  BEGIN

	FOR i IN (SELECT * FROM GIIS_TRANSACTION order by tran_desc)

	LOOP

	  v_giis_transaction.tran_cd		:= i.tran_cd;
	  v_giis_transaction.tran_desc		:= i.tran_desc;
	  v_giis_transaction.remarks		:= i.remarks;
	  v_giis_transaction.user_id		:= i.user_id;
	  v_giis_transaction.last_update	:= i.last_update;

	  PIPE ROW(v_giis_transaction);
	END LOOP;
    RETURN;
  END get_giis_transaction_list;

END Giis_Transaction_Pkg;
/


