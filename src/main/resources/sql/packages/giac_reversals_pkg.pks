CREATE OR REPLACE PACKAGE CPI.giac_reversals_pkg
AS

PROCEDURE insert_into_reversals (
   p_gacc_tran_id         giac_order_of_payts.gacc_tran_id%TYPE,
   p_acc_tran_id          giac_acctrans.tran_id%TYPE,
   p_message        OUT   VARCHAR2
);

END;
/


