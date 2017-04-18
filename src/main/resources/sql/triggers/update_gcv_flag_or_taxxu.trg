DROP TRIGGER CPI.UPDATE_GCV_FLAG_OR_TAXXU;

CREATE OR REPLACE TRIGGER CPI.UPDATE_GCV_FLAG_OR_TAXXU
  AFTER UPDATE OF or_flag ON CPI.GIAC_ORDER_OF_PAYTS   FOR EACH ROW
BEGIN
  IF UPDATING THEN
     IF :NEW.or_flag = 'C' THEN
        UPDATE GIAC_COMM_VOUCHER
    SET tran_flag = 'D'
  WHERE gacc_tran_id = :NEW.gacc_tran_id;
     END IF;
  END IF;
END;
/

