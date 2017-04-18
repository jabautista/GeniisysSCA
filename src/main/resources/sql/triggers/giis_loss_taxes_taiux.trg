DROP TRIGGER CPI.GIIS_LOSS_TAXES_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIIS_LOSS_TAXES_TAIUX
--CREATED BY JHEFF
AFTER INSERT OR UPDATE
ON CPI.GIIS_LOSS_TAXES REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
  v_tax_hist_no  giis_loss_tax_hist.tax_hist_no%TYPE;
BEGIN
  SELECT NVL(MAX(tax_hist_no),0)
    INTO v_tax_hist_no
    FROM giis_loss_tax_hist;
    v_tax_hist_no := v_tax_hist_no + 1;

  IF (INSERTING) THEN
   INSERT INTO giis_loss_tax_hist (loss_tax_id,tax_hist_no,start_date, end_date, tax_rate)
   VALUES (:NEW.loss_tax_id,v_tax_hist_no,:NEW.start_date,:NEW.end_date,:NEW.tax_rate);
  ELSIF (UPDATING) THEN
    IF :OLD.tax_rate   <> :NEW.tax_rate OR
       :OLD.start_date <> :NEW.start_date OR
       NVL(:OLD.end_date,LAST_DAY(SYSDATE)+30)   <> NVL(:NEW.end_date,LAST_DAY(SYSDATE)+30) THEN
    INSERT INTO giis_loss_tax_hist (loss_tax_id,tax_hist_no,start_date, end_date, tax_rate)
    VALUES (:OLD.loss_tax_id,v_tax_hist_no,:OLD.start_date,:OLD.end_date,:NEW.tax_rate);
    END IF;
  ELSE
   NULL;
  END IF;
END;
/


