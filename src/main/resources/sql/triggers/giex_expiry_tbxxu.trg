DROP TRIGGER CPI.GIEX_EXPIRY_TBXXU;

CREATE OR REPLACE TRIGGER CPI.GIEX_EXPIRY_TBXXU
BEFORE UPDATE
ON CPI.GIEX_EXPIRY FOR EACH ROW
BEGIN
  :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


