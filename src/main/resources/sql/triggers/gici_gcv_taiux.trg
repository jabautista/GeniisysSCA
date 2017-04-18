DROP TRIGGER CPI.GICI_GCV_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GICI_GCV_TAIUX
--CREATED BY JANET ANG FOR PFIC ONLY -- EMERGENCY PROC 080800
AFTER INSERT OR UPDATE ON CPI.GIPI_COMM_INVOICE FOR EACH ROW
BEGIN
  IF UPDATING THEN
    UPDATE GIAC_COMM_VOUCHER
    SET commission_amt = :NEW.commission_amt * (NVL(premium_amt,0)/NVL(:NEW.premium_amt,0)),
        wholding_tax = :NEW.wholding_tax * (NVL(premium_amt,0)/NVL(:NEW.premium_amt,0))
    WHERE intm_no = :NEW.intrmdry_intm_no
    AND prem_seq_no = :NEW.prem_Seq_no
    AND iss_Cd = :NEW.iss_cd;
  ELSIF INSERTING THEN
    UPDATE GIAC_COMM_VOUCHER
    SET commission_amt = :NEW.commission_amt * (NVL(premium_amt,0)/NVL(:NEW.premium_amt,0)),
        wholding_tax = :NEW.wholding_tax * (NVL(premium_amt,0)/NVL(:NEW.premium_amt,0)),
        intm_no = :NEW.intrmdry_intm_no
    WHERE iss_cd = :NEW.iss_cd
    AND prem_Seq_no = :NEW.prem_seq_no;
  END IF;
END;
/

ALTER TRIGGER CPI.GICI_GCV_TAIUX DISABLE;


