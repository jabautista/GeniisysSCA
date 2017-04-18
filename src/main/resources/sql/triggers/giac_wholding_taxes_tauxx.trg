DROP TRIGGER CPI.GIAC_WHOLDING_TAXES_TAUXX;

CREATE OR REPLACE TRIGGER CPI.GIAC_WHOLDING_TAXES_TAUXX
/* by jayson 08.08.2011
   this will update giis_loss_taxes after changes has been made in its whtax_desc,
   percent_rate, gl_acct_id, sl_type_cd
*/
   AFTER UPDATE OF whtax_desc, percent_rate, gl_acct_id, sl_type_cd
   ON CPI.GIAC_WHOLDING_TAXES    REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
  v_tax_id   giis_loss_taxes.loss_tax_id%TYPE;
BEGIN
  IF :OLD.whtax_desc <> :NEW.whtax_desc THEN
    UPDATE cpi.giis_loss_taxes
       SET tax_name = :NEW.whtax_desc
     WHERE tax_cd = :OLD.whtax_id
       AND tax_type = 'W';
  END IF;
  
  IF :OLD.percent_rate <> :NEW.percent_rate THEN
    UPDATE cpi.giis_loss_taxes
       SET tax_rate = :NEW.percent_rate
     WHERE tax_cd = :OLD.whtax_id
       AND tax_type = 'W';
  END IF;
  
  IF :OLD.gl_acct_id <> :NEW.gl_acct_id THEN
    UPDATE cpi.giis_loss_taxes
       SET gl_acct_id = :NEW.gl_acct_id
     WHERE tax_cd = :OLD.whtax_id
       AND tax_type = 'W';
  END IF;
  
  IF :OLD.sl_type_cd <> :NEW.sl_type_cd THEN
    UPDATE cpi.giis_loss_taxes
       SET sl_type_cd = :NEW.sl_type_cd
     WHERE tax_cd = :OLD.whtax_id
       AND tax_type = 'W';
  END IF;
END;
/


