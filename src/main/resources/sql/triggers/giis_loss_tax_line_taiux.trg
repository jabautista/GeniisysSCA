DROP TRIGGER CPI.GIIS_LOSS_TAX_LINE_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIIS_LOSS_TAX_LINE_TAIUX
--REFERENCING NEW AS NEW OLD AS OLD
--created by jheff 06/16/04
AFTER INSERT OR UPDATE OF tax_rate
ON CPI.GIIS_LOSS_TAX_LINE FOR EACH ROW
DECLARE
  v_tax_hist_no  giis_loss_tax_line_hist.tax_hist_no%TYPE;
BEGIN
  SELECT NVL(MAX(tax_hist_no),0)
    INTO v_tax_hist_no
    FROM giis_loss_tax_line_hist;
    v_tax_hist_no := v_tax_hist_no + 1;
  IF (UPDATING) THEN
    IF :OLD.tax_rate   <> :NEW.tax_rate THEN
     INSERT INTO giis_loss_tax_line_hist (loss_tax_id,
                                          line_cd,
                                          loss_exp_cd,
                                          tax_hist_no,
                                          tax_rate)
     VALUES (:OLD.loss_tax_id,
             :OLD.line_cd,
             :OLD.loss_exp_cd,
              v_tax_hist_no,
             :NEW.tax_rate);
    END IF;
  ELSIF (INSERTING) THEN
     INSERT INTO giis_loss_tax_line_hist (loss_tax_id,
                                          line_cd,
                                          loss_exp_cd,
                                          tax_hist_no,
                                          tax_rate)
     VALUES (:NEW.loss_tax_id,
             :NEW.line_cd,
             :NEW.loss_exp_cd,
              v_tax_hist_no,
             :NEW.tax_rate);
  ELSE
   NULL;
  END IF;
END;
/


