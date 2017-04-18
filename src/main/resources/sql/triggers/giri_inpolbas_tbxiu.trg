DROP TRIGGER CPI.GIRI_INPOLBAS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIRI_INPOLBAS_TBXIU
  BEFORE INSERT OR UPDATE ON CPI.GIRI_INPOLBAS FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_id    := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


