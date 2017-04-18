DROP TRIGGER CPI.GIIS_LOSS_TAX_LINE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_LOSS_TAX_LINE_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_LOSS_TAX_LINE FOR EACH ROW
BEGIN
  :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


