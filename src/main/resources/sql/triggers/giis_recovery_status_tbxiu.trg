DROP TRIGGER CPI.GIIS_RECOVERY_STATUS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_RECOVERY_STATUS_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_RECOVERY_STATUS FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


