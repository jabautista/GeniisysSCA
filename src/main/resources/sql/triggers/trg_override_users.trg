DROP TRIGGER CPI.TRG_OVERRIDE_USERS;

CREATE OR REPLACE TRIGGER CPI.TRG_OVERRIDE_USERS
BEFORE INSERT OR UPDATE ON CPI.GIIS_OVERRIDE_USERS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    BEGIN
        :NEW.user_id := NVL (giis_users_pkg.app_user, USER);
        :NEW.last_update := SYSDATE;
    END;
END;
/


