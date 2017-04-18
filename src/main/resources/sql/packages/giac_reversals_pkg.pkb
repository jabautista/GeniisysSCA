CREATE OR REPLACE PACKAGE BODY CPI.giac_reversals_pkg
AS

	PROCEDURE insert_into_reversals (
	   p_gacc_tran_id         giac_order_of_payts.gacc_tran_id%TYPE,
	   p_acc_tran_id          giac_acctrans.tran_id%TYPE,
	   p_message        OUT   VARCHAR2
	)
	IS
	BEGIN
	   INSERT INTO giac_reversals
	               (gacc_tran_id, reversing_tran_id, rev_corr_tag
	               )
	        VALUES (p_gacc_tran_id, p_acc_tran_id, 'R'
	               );
	
	   IF SQL%NOTFOUND
	   THEN
	      p_message := 'Cancel or: Unable to insert into reversals.';
	   END IF;
	END;
END giac_reversals_pkg;
/


