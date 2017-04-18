DROP TRIGGER CPI.UPDATE_GCV_FLAG_DV_TAXXU;

CREATE OR REPLACE TRIGGER CPI.UPDATE_GCV_FLAG_DV_TAXXU
  AFTER UPDATE OF payt_req_flag ON CPI.GIAC_PAYT_REQUESTS_DTL   FOR EACH ROW
BEGIN
  IF UPDATING THEN
     IF :NEW.payt_req_flag = 'X' THEN
        UPDATE GIAC_COMM_VOUCHER
    SET tran_flag = 'D'
  WHERE gacc_tran_id = :NEW.tran_id;
     END IF;
  END IF;
END;
/

