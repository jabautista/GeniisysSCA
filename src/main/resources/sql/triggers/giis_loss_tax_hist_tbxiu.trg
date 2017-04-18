DROP TRIGGER CPI.GIIS_LOSS_TAX_HIST_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_LOSS_TAX_HIST_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_LOSS_TAX_HIST FOR EACH ROW
BEGIN
  :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/

