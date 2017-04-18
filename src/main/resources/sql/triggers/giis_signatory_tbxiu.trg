DROP TRIGGER CPI.GIIS_SIGNATORY_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_SIGNATORY_TBXIU
  BEFORE INSERT OR UPDATE ON CPI.GIIS_SIGNATORY   FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/

